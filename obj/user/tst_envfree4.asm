
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
  800045:	68 20 35 80 00       	push   $0x803520
  80004a:	e8 b4 14 00 00       	call   801503 <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*numOfFinished = 0 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int freeFrames_before = sys_calculate_free_frames() ;
  80005e:	e8 78 16 00 00       	call   8016db <sys_calculate_free_frames>
  800063:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800066:	e8 10 17 00 00       	call   80177b <sys_pf_calculate_allocated_pages>
  80006b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80006e:	83 ec 08             	sub    $0x8,%esp
  800071:	ff 75 f0             	pushl  -0x10(%ebp)
  800074:	68 30 35 80 00       	push   $0x803530
  800079:	e8 b5 04 00 00       	call   800533 <cprintf>
  80007e:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tsem1", 100,(myEnv->SecondListSize), 50);
  800081:	a1 20 40 80 00       	mov    0x804020,%eax
  800086:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80008c:	6a 32                	push   $0x32
  80008e:	50                   	push   %eax
  80008f:	6a 64                	push   $0x64
  800091:	68 63 35 80 00       	push   $0x803563
  800096:	e8 b2 18 00 00       	call   80194d <sys_create_env>
  80009b:	83 c4 10             	add    $0x10,%esp
  80009e:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sys_run_env(envIdProcessA);
  8000a1:	83 ec 0c             	sub    $0xc,%esp
  8000a4:	ff 75 e8             	pushl  -0x18(%ebp)
  8000a7:	e8 bf 18 00 00       	call   80196b <sys_run_env>
  8000ac:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 1) ;
  8000af:	90                   	nop
  8000b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000b3:	8b 00                	mov    (%eax),%eax
  8000b5:	83 f8 01             	cmp    $0x1,%eax
  8000b8:	75 f6                	jne    8000b0 <_main+0x78>
	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  8000ba:	e8 1c 16 00 00       	call   8016db <sys_calculate_free_frames>
  8000bf:	83 ec 08             	sub    $0x8,%esp
  8000c2:	50                   	push   %eax
  8000c3:	68 6c 35 80 00       	push   $0x80356c
  8000c8:	e8 66 04 00 00       	call   800533 <cprintf>
  8000cd:	83 c4 10             	add    $0x10,%esp

	sys_destroy_env(envIdProcessA);
  8000d0:	83 ec 0c             	sub    $0xc,%esp
  8000d3:	ff 75 e8             	pushl  -0x18(%ebp)
  8000d6:	e8 ac 18 00 00       	call   801987 <sys_destroy_env>
  8000db:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  8000de:	e8 f8 15 00 00       	call   8016db <sys_calculate_free_frames>
  8000e3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  8000e6:	e8 90 16 00 00       	call   80177b <sys_pf_calculate_allocated_pages>
  8000eb:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if ((freeFrames_after - freeFrames_before) != 0) {
  8000ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000f1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8000f4:	74 27                	je     80011d <_main+0xe5>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\n",
  8000f6:	83 ec 08             	sub    $0x8,%esp
  8000f9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000fc:	68 a0 35 80 00       	push   $0x8035a0
  800101:	e8 2d 04 00 00       	call   800533 <cprintf>
  800106:	83 c4 10             	add    $0x10,%esp
				freeFrames_after);
		panic("env_free() does not work correctly... check it again.");
  800109:	83 ec 04             	sub    $0x4,%esp
  80010c:	68 f0 35 80 00       	push   $0x8035f0
  800111:	6a 1f                	push   $0x1f
  800113:	68 26 36 80 00       	push   $0x803626
  800118:	e8 62 01 00 00       	call   80027f <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  80011d:	83 ec 08             	sub    $0x8,%esp
  800120:	ff 75 e4             	pushl  -0x1c(%ebp)
  800123:	68 3c 36 80 00       	push   $0x80363c
  800128:	e8 06 04 00 00       	call   800533 <cprintf>
  80012d:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 4 for envfree completed successfully.\n");
  800130:	83 ec 0c             	sub    $0xc,%esp
  800133:	68 9c 36 80 00       	push   $0x80369c
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
  800149:	e8 6d 18 00 00       	call   8019bb <sys_getenvindex>
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
  8001b4:	e8 0f 16 00 00       	call   8017c8 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001b9:	83 ec 0c             	sub    $0xc,%esp
  8001bc:	68 00 37 80 00       	push   $0x803700
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
  8001e4:	68 28 37 80 00       	push   $0x803728
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
  800215:	68 50 37 80 00       	push   $0x803750
  80021a:	e8 14 03 00 00       	call   800533 <cprintf>
  80021f:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800222:	a1 20 40 80 00       	mov    0x804020,%eax
  800227:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80022d:	83 ec 08             	sub    $0x8,%esp
  800230:	50                   	push   %eax
  800231:	68 a8 37 80 00       	push   $0x8037a8
  800236:	e8 f8 02 00 00       	call   800533 <cprintf>
  80023b:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80023e:	83 ec 0c             	sub    $0xc,%esp
  800241:	68 00 37 80 00       	push   $0x803700
  800246:	e8 e8 02 00 00       	call   800533 <cprintf>
  80024b:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80024e:	e8 8f 15 00 00       	call   8017e2 <sys_enable_interrupt>

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
  800266:	e8 1c 17 00 00       	call   801987 <sys_destroy_env>
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
  800277:	e8 71 17 00 00       	call   8019ed <sys_exit_env>
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
  8002a0:	68 bc 37 80 00       	push   $0x8037bc
  8002a5:	e8 89 02 00 00       	call   800533 <cprintf>
  8002aa:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002ad:	a1 00 40 80 00       	mov    0x804000,%eax
  8002b2:	ff 75 0c             	pushl  0xc(%ebp)
  8002b5:	ff 75 08             	pushl  0x8(%ebp)
  8002b8:	50                   	push   %eax
  8002b9:	68 c1 37 80 00       	push   $0x8037c1
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
  8002dd:	68 dd 37 80 00       	push   $0x8037dd
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
  800309:	68 e0 37 80 00       	push   $0x8037e0
  80030e:	6a 26                	push   $0x26
  800310:	68 2c 38 80 00       	push   $0x80382c
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
  8003db:	68 38 38 80 00       	push   $0x803838
  8003e0:	6a 3a                	push   $0x3a
  8003e2:	68 2c 38 80 00       	push   $0x80382c
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
  80044b:	68 8c 38 80 00       	push   $0x80388c
  800450:	6a 44                	push   $0x44
  800452:	68 2c 38 80 00       	push   $0x80382c
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
  8004a5:	e8 70 11 00 00       	call   80161a <sys_cputs>
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
  80051c:	e8 f9 10 00 00       	call   80161a <sys_cputs>
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
  800566:	e8 5d 12 00 00       	call   8017c8 <sys_disable_interrupt>
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
  800586:	e8 57 12 00 00       	call   8017e2 <sys_enable_interrupt>
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
  8005d0:	e8 cb 2c 00 00       	call   8032a0 <__udivdi3>
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
  800620:	e8 8b 2d 00 00       	call   8033b0 <__umoddi3>
  800625:	83 c4 10             	add    $0x10,%esp
  800628:	05 f4 3a 80 00       	add    $0x803af4,%eax
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
  80077b:	8b 04 85 18 3b 80 00 	mov    0x803b18(,%eax,4),%eax
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
  80085c:	8b 34 9d 60 39 80 00 	mov    0x803960(,%ebx,4),%esi
  800863:	85 f6                	test   %esi,%esi
  800865:	75 19                	jne    800880 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800867:	53                   	push   %ebx
  800868:	68 05 3b 80 00       	push   $0x803b05
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
  800881:	68 0e 3b 80 00       	push   $0x803b0e
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
  8008ae:	be 11 3b 80 00       	mov    $0x803b11,%esi
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
  8012d4:	68 70 3c 80 00       	push   $0x803c70
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
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_PRESENT);
  801387:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  80138e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801391:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801396:	2d 00 10 00 00       	sub    $0x1000,%eax
  80139b:	83 ec 04             	sub    $0x4,%esp
  80139e:	6a 03                	push   $0x3
  8013a0:	ff 75 f4             	pushl  -0xc(%ebp)
  8013a3:	50                   	push   %eax
  8013a4:	e8 b5 03 00 00       	call   80175e <sys_allocate_chunk>
  8013a9:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013ac:	a1 20 41 80 00       	mov    0x804120,%eax
  8013b1:	83 ec 0c             	sub    $0xc,%esp
  8013b4:	50                   	push   %eax
  8013b5:	e8 2a 0a 00 00       	call   801de4 <initialize_MemBlocksList>
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
  8013e2:	68 95 3c 80 00       	push   $0x803c95
  8013e7:	6a 33                	push   $0x33
  8013e9:	68 b3 3c 80 00       	push   $0x803cb3
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
  801461:	68 c0 3c 80 00       	push   $0x803cc0
  801466:	6a 34                	push   $0x34
  801468:	68 b3 3c 80 00       	push   $0x803cb3
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
  8014be:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8014c1:	e8 f7 fd ff ff       	call   8012bd <InitializeUHeap>
	if (size == 0) return NULL ;
  8014c6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014ca:	75 07                	jne    8014d3 <malloc+0x18>
  8014cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8014d1:	eb 14                	jmp    8014e7 <malloc+0x2c>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  8014d3:	83 ec 04             	sub    $0x4,%esp
  8014d6:	68 e4 3c 80 00       	push   $0x803ce4
  8014db:	6a 46                	push   $0x46
  8014dd:	68 b3 3c 80 00       	push   $0x803cb3
  8014e2:	e8 98 ed ff ff       	call   80027f <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  8014e7:	c9                   	leave  
  8014e8:	c3                   	ret    

008014e9 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8014e9:	55                   	push   %ebp
  8014ea:	89 e5                	mov    %esp,%ebp
  8014ec:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  8014ef:	83 ec 04             	sub    $0x4,%esp
  8014f2:	68 0c 3d 80 00       	push   $0x803d0c
  8014f7:	6a 61                	push   $0x61
  8014f9:	68 b3 3c 80 00       	push   $0x803cb3
  8014fe:	e8 7c ed ff ff       	call   80027f <_panic>

00801503 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801503:	55                   	push   %ebp
  801504:	89 e5                	mov    %esp,%ebp
  801506:	83 ec 18             	sub    $0x18,%esp
  801509:	8b 45 10             	mov    0x10(%ebp),%eax
  80150c:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80150f:	e8 a9 fd ff ff       	call   8012bd <InitializeUHeap>
	if (size == 0) return NULL ;
  801514:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801518:	75 07                	jne    801521 <smalloc+0x1e>
  80151a:	b8 00 00 00 00       	mov    $0x0,%eax
  80151f:	eb 14                	jmp    801535 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801521:	83 ec 04             	sub    $0x4,%esp
  801524:	68 30 3d 80 00       	push   $0x803d30
  801529:	6a 76                	push   $0x76
  80152b:	68 b3 3c 80 00       	push   $0x803cb3
  801530:	e8 4a ed ff ff       	call   80027f <_panic>

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801535:	c9                   	leave  
  801536:	c3                   	ret    

00801537 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801537:	55                   	push   %ebp
  801538:	89 e5                	mov    %esp,%ebp
  80153a:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80153d:	e8 7b fd ff ff       	call   8012bd <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801542:	83 ec 04             	sub    $0x4,%esp
  801545:	68 58 3d 80 00       	push   $0x803d58
  80154a:	68 93 00 00 00       	push   $0x93
  80154f:	68 b3 3c 80 00       	push   $0x803cb3
  801554:	e8 26 ed ff ff       	call   80027f <_panic>

00801559 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801559:	55                   	push   %ebp
  80155a:	89 e5                	mov    %esp,%ebp
  80155c:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80155f:	e8 59 fd ff ff       	call   8012bd <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801564:	83 ec 04             	sub    $0x4,%esp
  801567:	68 7c 3d 80 00       	push   $0x803d7c
  80156c:	68 c5 00 00 00       	push   $0xc5
  801571:	68 b3 3c 80 00       	push   $0x803cb3
  801576:	e8 04 ed ff ff       	call   80027f <_panic>

0080157b <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80157b:	55                   	push   %ebp
  80157c:	89 e5                	mov    %esp,%ebp
  80157e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801581:	83 ec 04             	sub    $0x4,%esp
  801584:	68 a4 3d 80 00       	push   $0x803da4
  801589:	68 d9 00 00 00       	push   $0xd9
  80158e:	68 b3 3c 80 00       	push   $0x803cb3
  801593:	e8 e7 ec ff ff       	call   80027f <_panic>

00801598 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801598:	55                   	push   %ebp
  801599:	89 e5                	mov    %esp,%ebp
  80159b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80159e:	83 ec 04             	sub    $0x4,%esp
  8015a1:	68 c8 3d 80 00       	push   $0x803dc8
  8015a6:	68 e4 00 00 00       	push   $0xe4
  8015ab:	68 b3 3c 80 00       	push   $0x803cb3
  8015b0:	e8 ca ec ff ff       	call   80027f <_panic>

008015b5 <shrink>:

}
void shrink(uint32 newSize)
{
  8015b5:	55                   	push   %ebp
  8015b6:	89 e5                	mov    %esp,%ebp
  8015b8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015bb:	83 ec 04             	sub    $0x4,%esp
  8015be:	68 c8 3d 80 00       	push   $0x803dc8
  8015c3:	68 e9 00 00 00       	push   $0xe9
  8015c8:	68 b3 3c 80 00       	push   $0x803cb3
  8015cd:	e8 ad ec ff ff       	call   80027f <_panic>

008015d2 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8015d2:	55                   	push   %ebp
  8015d3:	89 e5                	mov    %esp,%ebp
  8015d5:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015d8:	83 ec 04             	sub    $0x4,%esp
  8015db:	68 c8 3d 80 00       	push   $0x803dc8
  8015e0:	68 ee 00 00 00       	push   $0xee
  8015e5:	68 b3 3c 80 00       	push   $0x803cb3
  8015ea:	e8 90 ec ff ff       	call   80027f <_panic>

008015ef <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8015ef:	55                   	push   %ebp
  8015f0:	89 e5                	mov    %esp,%ebp
  8015f2:	57                   	push   %edi
  8015f3:	56                   	push   %esi
  8015f4:	53                   	push   %ebx
  8015f5:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015fe:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801601:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801604:	8b 7d 18             	mov    0x18(%ebp),%edi
  801607:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80160a:	cd 30                	int    $0x30
  80160c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80160f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801612:	83 c4 10             	add    $0x10,%esp
  801615:	5b                   	pop    %ebx
  801616:	5e                   	pop    %esi
  801617:	5f                   	pop    %edi
  801618:	5d                   	pop    %ebp
  801619:	c3                   	ret    

0080161a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80161a:	55                   	push   %ebp
  80161b:	89 e5                	mov    %esp,%ebp
  80161d:	83 ec 04             	sub    $0x4,%esp
  801620:	8b 45 10             	mov    0x10(%ebp),%eax
  801623:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801626:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80162a:	8b 45 08             	mov    0x8(%ebp),%eax
  80162d:	6a 00                	push   $0x0
  80162f:	6a 00                	push   $0x0
  801631:	52                   	push   %edx
  801632:	ff 75 0c             	pushl  0xc(%ebp)
  801635:	50                   	push   %eax
  801636:	6a 00                	push   $0x0
  801638:	e8 b2 ff ff ff       	call   8015ef <syscall>
  80163d:	83 c4 18             	add    $0x18,%esp
}
  801640:	90                   	nop
  801641:	c9                   	leave  
  801642:	c3                   	ret    

00801643 <sys_cgetc>:

int
sys_cgetc(void)
{
  801643:	55                   	push   %ebp
  801644:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801646:	6a 00                	push   $0x0
  801648:	6a 00                	push   $0x0
  80164a:	6a 00                	push   $0x0
  80164c:	6a 00                	push   $0x0
  80164e:	6a 00                	push   $0x0
  801650:	6a 01                	push   $0x1
  801652:	e8 98 ff ff ff       	call   8015ef <syscall>
  801657:	83 c4 18             	add    $0x18,%esp
}
  80165a:	c9                   	leave  
  80165b:	c3                   	ret    

0080165c <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80165c:	55                   	push   %ebp
  80165d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80165f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801662:	8b 45 08             	mov    0x8(%ebp),%eax
  801665:	6a 00                	push   $0x0
  801667:	6a 00                	push   $0x0
  801669:	6a 00                	push   $0x0
  80166b:	52                   	push   %edx
  80166c:	50                   	push   %eax
  80166d:	6a 05                	push   $0x5
  80166f:	e8 7b ff ff ff       	call   8015ef <syscall>
  801674:	83 c4 18             	add    $0x18,%esp
}
  801677:	c9                   	leave  
  801678:	c3                   	ret    

00801679 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801679:	55                   	push   %ebp
  80167a:	89 e5                	mov    %esp,%ebp
  80167c:	56                   	push   %esi
  80167d:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80167e:	8b 75 18             	mov    0x18(%ebp),%esi
  801681:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801684:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801687:	8b 55 0c             	mov    0xc(%ebp),%edx
  80168a:	8b 45 08             	mov    0x8(%ebp),%eax
  80168d:	56                   	push   %esi
  80168e:	53                   	push   %ebx
  80168f:	51                   	push   %ecx
  801690:	52                   	push   %edx
  801691:	50                   	push   %eax
  801692:	6a 06                	push   $0x6
  801694:	e8 56 ff ff ff       	call   8015ef <syscall>
  801699:	83 c4 18             	add    $0x18,%esp
}
  80169c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80169f:	5b                   	pop    %ebx
  8016a0:	5e                   	pop    %esi
  8016a1:	5d                   	pop    %ebp
  8016a2:	c3                   	ret    

008016a3 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8016a3:	55                   	push   %ebp
  8016a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8016a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ac:	6a 00                	push   $0x0
  8016ae:	6a 00                	push   $0x0
  8016b0:	6a 00                	push   $0x0
  8016b2:	52                   	push   %edx
  8016b3:	50                   	push   %eax
  8016b4:	6a 07                	push   $0x7
  8016b6:	e8 34 ff ff ff       	call   8015ef <syscall>
  8016bb:	83 c4 18             	add    $0x18,%esp
}
  8016be:	c9                   	leave  
  8016bf:	c3                   	ret    

008016c0 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8016c0:	55                   	push   %ebp
  8016c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8016c3:	6a 00                	push   $0x0
  8016c5:	6a 00                	push   $0x0
  8016c7:	6a 00                	push   $0x0
  8016c9:	ff 75 0c             	pushl  0xc(%ebp)
  8016cc:	ff 75 08             	pushl  0x8(%ebp)
  8016cf:	6a 08                	push   $0x8
  8016d1:	e8 19 ff ff ff       	call   8015ef <syscall>
  8016d6:	83 c4 18             	add    $0x18,%esp
}
  8016d9:	c9                   	leave  
  8016da:	c3                   	ret    

008016db <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8016db:	55                   	push   %ebp
  8016dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8016de:	6a 00                	push   $0x0
  8016e0:	6a 00                	push   $0x0
  8016e2:	6a 00                	push   $0x0
  8016e4:	6a 00                	push   $0x0
  8016e6:	6a 00                	push   $0x0
  8016e8:	6a 09                	push   $0x9
  8016ea:	e8 00 ff ff ff       	call   8015ef <syscall>
  8016ef:	83 c4 18             	add    $0x18,%esp
}
  8016f2:	c9                   	leave  
  8016f3:	c3                   	ret    

008016f4 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8016f4:	55                   	push   %ebp
  8016f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8016f7:	6a 00                	push   $0x0
  8016f9:	6a 00                	push   $0x0
  8016fb:	6a 00                	push   $0x0
  8016fd:	6a 00                	push   $0x0
  8016ff:	6a 00                	push   $0x0
  801701:	6a 0a                	push   $0xa
  801703:	e8 e7 fe ff ff       	call   8015ef <syscall>
  801708:	83 c4 18             	add    $0x18,%esp
}
  80170b:	c9                   	leave  
  80170c:	c3                   	ret    

0080170d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80170d:	55                   	push   %ebp
  80170e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801710:	6a 00                	push   $0x0
  801712:	6a 00                	push   $0x0
  801714:	6a 00                	push   $0x0
  801716:	6a 00                	push   $0x0
  801718:	6a 00                	push   $0x0
  80171a:	6a 0b                	push   $0xb
  80171c:	e8 ce fe ff ff       	call   8015ef <syscall>
  801721:	83 c4 18             	add    $0x18,%esp
}
  801724:	c9                   	leave  
  801725:	c3                   	ret    

00801726 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801726:	55                   	push   %ebp
  801727:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801729:	6a 00                	push   $0x0
  80172b:	6a 00                	push   $0x0
  80172d:	6a 00                	push   $0x0
  80172f:	ff 75 0c             	pushl  0xc(%ebp)
  801732:	ff 75 08             	pushl  0x8(%ebp)
  801735:	6a 0f                	push   $0xf
  801737:	e8 b3 fe ff ff       	call   8015ef <syscall>
  80173c:	83 c4 18             	add    $0x18,%esp
	return;
  80173f:	90                   	nop
}
  801740:	c9                   	leave  
  801741:	c3                   	ret    

00801742 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801742:	55                   	push   %ebp
  801743:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801745:	6a 00                	push   $0x0
  801747:	6a 00                	push   $0x0
  801749:	6a 00                	push   $0x0
  80174b:	ff 75 0c             	pushl  0xc(%ebp)
  80174e:	ff 75 08             	pushl  0x8(%ebp)
  801751:	6a 10                	push   $0x10
  801753:	e8 97 fe ff ff       	call   8015ef <syscall>
  801758:	83 c4 18             	add    $0x18,%esp
	return ;
  80175b:	90                   	nop
}
  80175c:	c9                   	leave  
  80175d:	c3                   	ret    

0080175e <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80175e:	55                   	push   %ebp
  80175f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801761:	6a 00                	push   $0x0
  801763:	6a 00                	push   $0x0
  801765:	ff 75 10             	pushl  0x10(%ebp)
  801768:	ff 75 0c             	pushl  0xc(%ebp)
  80176b:	ff 75 08             	pushl  0x8(%ebp)
  80176e:	6a 11                	push   $0x11
  801770:	e8 7a fe ff ff       	call   8015ef <syscall>
  801775:	83 c4 18             	add    $0x18,%esp
	return ;
  801778:	90                   	nop
}
  801779:	c9                   	leave  
  80177a:	c3                   	ret    

0080177b <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80177b:	55                   	push   %ebp
  80177c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80177e:	6a 00                	push   $0x0
  801780:	6a 00                	push   $0x0
  801782:	6a 00                	push   $0x0
  801784:	6a 00                	push   $0x0
  801786:	6a 00                	push   $0x0
  801788:	6a 0c                	push   $0xc
  80178a:	e8 60 fe ff ff       	call   8015ef <syscall>
  80178f:	83 c4 18             	add    $0x18,%esp
}
  801792:	c9                   	leave  
  801793:	c3                   	ret    

00801794 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801794:	55                   	push   %ebp
  801795:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801797:	6a 00                	push   $0x0
  801799:	6a 00                	push   $0x0
  80179b:	6a 00                	push   $0x0
  80179d:	6a 00                	push   $0x0
  80179f:	ff 75 08             	pushl  0x8(%ebp)
  8017a2:	6a 0d                	push   $0xd
  8017a4:	e8 46 fe ff ff       	call   8015ef <syscall>
  8017a9:	83 c4 18             	add    $0x18,%esp
}
  8017ac:	c9                   	leave  
  8017ad:	c3                   	ret    

008017ae <sys_scarce_memory>:

void sys_scarce_memory()
{
  8017ae:	55                   	push   %ebp
  8017af:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8017b1:	6a 00                	push   $0x0
  8017b3:	6a 00                	push   $0x0
  8017b5:	6a 00                	push   $0x0
  8017b7:	6a 00                	push   $0x0
  8017b9:	6a 00                	push   $0x0
  8017bb:	6a 0e                	push   $0xe
  8017bd:	e8 2d fe ff ff       	call   8015ef <syscall>
  8017c2:	83 c4 18             	add    $0x18,%esp
}
  8017c5:	90                   	nop
  8017c6:	c9                   	leave  
  8017c7:	c3                   	ret    

008017c8 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8017c8:	55                   	push   %ebp
  8017c9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8017cb:	6a 00                	push   $0x0
  8017cd:	6a 00                	push   $0x0
  8017cf:	6a 00                	push   $0x0
  8017d1:	6a 00                	push   $0x0
  8017d3:	6a 00                	push   $0x0
  8017d5:	6a 13                	push   $0x13
  8017d7:	e8 13 fe ff ff       	call   8015ef <syscall>
  8017dc:	83 c4 18             	add    $0x18,%esp
}
  8017df:	90                   	nop
  8017e0:	c9                   	leave  
  8017e1:	c3                   	ret    

008017e2 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8017e2:	55                   	push   %ebp
  8017e3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8017e5:	6a 00                	push   $0x0
  8017e7:	6a 00                	push   $0x0
  8017e9:	6a 00                	push   $0x0
  8017eb:	6a 00                	push   $0x0
  8017ed:	6a 00                	push   $0x0
  8017ef:	6a 14                	push   $0x14
  8017f1:	e8 f9 fd ff ff       	call   8015ef <syscall>
  8017f6:	83 c4 18             	add    $0x18,%esp
}
  8017f9:	90                   	nop
  8017fa:	c9                   	leave  
  8017fb:	c3                   	ret    

008017fc <sys_cputc>:


void
sys_cputc(const char c)
{
  8017fc:	55                   	push   %ebp
  8017fd:	89 e5                	mov    %esp,%ebp
  8017ff:	83 ec 04             	sub    $0x4,%esp
  801802:	8b 45 08             	mov    0x8(%ebp),%eax
  801805:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801808:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80180c:	6a 00                	push   $0x0
  80180e:	6a 00                	push   $0x0
  801810:	6a 00                	push   $0x0
  801812:	6a 00                	push   $0x0
  801814:	50                   	push   %eax
  801815:	6a 15                	push   $0x15
  801817:	e8 d3 fd ff ff       	call   8015ef <syscall>
  80181c:	83 c4 18             	add    $0x18,%esp
}
  80181f:	90                   	nop
  801820:	c9                   	leave  
  801821:	c3                   	ret    

00801822 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801822:	55                   	push   %ebp
  801823:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801825:	6a 00                	push   $0x0
  801827:	6a 00                	push   $0x0
  801829:	6a 00                	push   $0x0
  80182b:	6a 00                	push   $0x0
  80182d:	6a 00                	push   $0x0
  80182f:	6a 16                	push   $0x16
  801831:	e8 b9 fd ff ff       	call   8015ef <syscall>
  801836:	83 c4 18             	add    $0x18,%esp
}
  801839:	90                   	nop
  80183a:	c9                   	leave  
  80183b:	c3                   	ret    

0080183c <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80183c:	55                   	push   %ebp
  80183d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80183f:	8b 45 08             	mov    0x8(%ebp),%eax
  801842:	6a 00                	push   $0x0
  801844:	6a 00                	push   $0x0
  801846:	6a 00                	push   $0x0
  801848:	ff 75 0c             	pushl  0xc(%ebp)
  80184b:	50                   	push   %eax
  80184c:	6a 17                	push   $0x17
  80184e:	e8 9c fd ff ff       	call   8015ef <syscall>
  801853:	83 c4 18             	add    $0x18,%esp
}
  801856:	c9                   	leave  
  801857:	c3                   	ret    

00801858 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801858:	55                   	push   %ebp
  801859:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80185b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80185e:	8b 45 08             	mov    0x8(%ebp),%eax
  801861:	6a 00                	push   $0x0
  801863:	6a 00                	push   $0x0
  801865:	6a 00                	push   $0x0
  801867:	52                   	push   %edx
  801868:	50                   	push   %eax
  801869:	6a 1a                	push   $0x1a
  80186b:	e8 7f fd ff ff       	call   8015ef <syscall>
  801870:	83 c4 18             	add    $0x18,%esp
}
  801873:	c9                   	leave  
  801874:	c3                   	ret    

00801875 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801875:	55                   	push   %ebp
  801876:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801878:	8b 55 0c             	mov    0xc(%ebp),%edx
  80187b:	8b 45 08             	mov    0x8(%ebp),%eax
  80187e:	6a 00                	push   $0x0
  801880:	6a 00                	push   $0x0
  801882:	6a 00                	push   $0x0
  801884:	52                   	push   %edx
  801885:	50                   	push   %eax
  801886:	6a 18                	push   $0x18
  801888:	e8 62 fd ff ff       	call   8015ef <syscall>
  80188d:	83 c4 18             	add    $0x18,%esp
}
  801890:	90                   	nop
  801891:	c9                   	leave  
  801892:	c3                   	ret    

00801893 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801893:	55                   	push   %ebp
  801894:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801896:	8b 55 0c             	mov    0xc(%ebp),%edx
  801899:	8b 45 08             	mov    0x8(%ebp),%eax
  80189c:	6a 00                	push   $0x0
  80189e:	6a 00                	push   $0x0
  8018a0:	6a 00                	push   $0x0
  8018a2:	52                   	push   %edx
  8018a3:	50                   	push   %eax
  8018a4:	6a 19                	push   $0x19
  8018a6:	e8 44 fd ff ff       	call   8015ef <syscall>
  8018ab:	83 c4 18             	add    $0x18,%esp
}
  8018ae:	90                   	nop
  8018af:	c9                   	leave  
  8018b0:	c3                   	ret    

008018b1 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8018b1:	55                   	push   %ebp
  8018b2:	89 e5                	mov    %esp,%ebp
  8018b4:	83 ec 04             	sub    $0x4,%esp
  8018b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8018ba:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8018bd:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8018c0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c7:	6a 00                	push   $0x0
  8018c9:	51                   	push   %ecx
  8018ca:	52                   	push   %edx
  8018cb:	ff 75 0c             	pushl  0xc(%ebp)
  8018ce:	50                   	push   %eax
  8018cf:	6a 1b                	push   $0x1b
  8018d1:	e8 19 fd ff ff       	call   8015ef <syscall>
  8018d6:	83 c4 18             	add    $0x18,%esp
}
  8018d9:	c9                   	leave  
  8018da:	c3                   	ret    

008018db <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8018db:	55                   	push   %ebp
  8018dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8018de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e4:	6a 00                	push   $0x0
  8018e6:	6a 00                	push   $0x0
  8018e8:	6a 00                	push   $0x0
  8018ea:	52                   	push   %edx
  8018eb:	50                   	push   %eax
  8018ec:	6a 1c                	push   $0x1c
  8018ee:	e8 fc fc ff ff       	call   8015ef <syscall>
  8018f3:	83 c4 18             	add    $0x18,%esp
}
  8018f6:	c9                   	leave  
  8018f7:	c3                   	ret    

008018f8 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8018f8:	55                   	push   %ebp
  8018f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8018fb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801901:	8b 45 08             	mov    0x8(%ebp),%eax
  801904:	6a 00                	push   $0x0
  801906:	6a 00                	push   $0x0
  801908:	51                   	push   %ecx
  801909:	52                   	push   %edx
  80190a:	50                   	push   %eax
  80190b:	6a 1d                	push   $0x1d
  80190d:	e8 dd fc ff ff       	call   8015ef <syscall>
  801912:	83 c4 18             	add    $0x18,%esp
}
  801915:	c9                   	leave  
  801916:	c3                   	ret    

00801917 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801917:	55                   	push   %ebp
  801918:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80191a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80191d:	8b 45 08             	mov    0x8(%ebp),%eax
  801920:	6a 00                	push   $0x0
  801922:	6a 00                	push   $0x0
  801924:	6a 00                	push   $0x0
  801926:	52                   	push   %edx
  801927:	50                   	push   %eax
  801928:	6a 1e                	push   $0x1e
  80192a:	e8 c0 fc ff ff       	call   8015ef <syscall>
  80192f:	83 c4 18             	add    $0x18,%esp
}
  801932:	c9                   	leave  
  801933:	c3                   	ret    

00801934 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801934:	55                   	push   %ebp
  801935:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801937:	6a 00                	push   $0x0
  801939:	6a 00                	push   $0x0
  80193b:	6a 00                	push   $0x0
  80193d:	6a 00                	push   $0x0
  80193f:	6a 00                	push   $0x0
  801941:	6a 1f                	push   $0x1f
  801943:	e8 a7 fc ff ff       	call   8015ef <syscall>
  801948:	83 c4 18             	add    $0x18,%esp
}
  80194b:	c9                   	leave  
  80194c:	c3                   	ret    

0080194d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80194d:	55                   	push   %ebp
  80194e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801950:	8b 45 08             	mov    0x8(%ebp),%eax
  801953:	6a 00                	push   $0x0
  801955:	ff 75 14             	pushl  0x14(%ebp)
  801958:	ff 75 10             	pushl  0x10(%ebp)
  80195b:	ff 75 0c             	pushl  0xc(%ebp)
  80195e:	50                   	push   %eax
  80195f:	6a 20                	push   $0x20
  801961:	e8 89 fc ff ff       	call   8015ef <syscall>
  801966:	83 c4 18             	add    $0x18,%esp
}
  801969:	c9                   	leave  
  80196a:	c3                   	ret    

0080196b <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80196b:	55                   	push   %ebp
  80196c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80196e:	8b 45 08             	mov    0x8(%ebp),%eax
  801971:	6a 00                	push   $0x0
  801973:	6a 00                	push   $0x0
  801975:	6a 00                	push   $0x0
  801977:	6a 00                	push   $0x0
  801979:	50                   	push   %eax
  80197a:	6a 21                	push   $0x21
  80197c:	e8 6e fc ff ff       	call   8015ef <syscall>
  801981:	83 c4 18             	add    $0x18,%esp
}
  801984:	90                   	nop
  801985:	c9                   	leave  
  801986:	c3                   	ret    

00801987 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801987:	55                   	push   %ebp
  801988:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80198a:	8b 45 08             	mov    0x8(%ebp),%eax
  80198d:	6a 00                	push   $0x0
  80198f:	6a 00                	push   $0x0
  801991:	6a 00                	push   $0x0
  801993:	6a 00                	push   $0x0
  801995:	50                   	push   %eax
  801996:	6a 22                	push   $0x22
  801998:	e8 52 fc ff ff       	call   8015ef <syscall>
  80199d:	83 c4 18             	add    $0x18,%esp
}
  8019a0:	c9                   	leave  
  8019a1:	c3                   	ret    

008019a2 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8019a2:	55                   	push   %ebp
  8019a3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 00                	push   $0x0
  8019ab:	6a 00                	push   $0x0
  8019ad:	6a 00                	push   $0x0
  8019af:	6a 02                	push   $0x2
  8019b1:	e8 39 fc ff ff       	call   8015ef <syscall>
  8019b6:	83 c4 18             	add    $0x18,%esp
}
  8019b9:	c9                   	leave  
  8019ba:	c3                   	ret    

008019bb <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8019bb:	55                   	push   %ebp
  8019bc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 00                	push   $0x0
  8019c2:	6a 00                	push   $0x0
  8019c4:	6a 00                	push   $0x0
  8019c6:	6a 00                	push   $0x0
  8019c8:	6a 03                	push   $0x3
  8019ca:	e8 20 fc ff ff       	call   8015ef <syscall>
  8019cf:	83 c4 18             	add    $0x18,%esp
}
  8019d2:	c9                   	leave  
  8019d3:	c3                   	ret    

008019d4 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8019d4:	55                   	push   %ebp
  8019d5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8019d7:	6a 00                	push   $0x0
  8019d9:	6a 00                	push   $0x0
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 04                	push   $0x4
  8019e3:	e8 07 fc ff ff       	call   8015ef <syscall>
  8019e8:	83 c4 18             	add    $0x18,%esp
}
  8019eb:	c9                   	leave  
  8019ec:	c3                   	ret    

008019ed <sys_exit_env>:


void sys_exit_env(void)
{
  8019ed:	55                   	push   %ebp
  8019ee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 00                	push   $0x0
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 00                	push   $0x0
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 23                	push   $0x23
  8019fc:	e8 ee fb ff ff       	call   8015ef <syscall>
  801a01:	83 c4 18             	add    $0x18,%esp
}
  801a04:	90                   	nop
  801a05:	c9                   	leave  
  801a06:	c3                   	ret    

00801a07 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801a07:	55                   	push   %ebp
  801a08:	89 e5                	mov    %esp,%ebp
  801a0a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801a0d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a10:	8d 50 04             	lea    0x4(%eax),%edx
  801a13:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a16:	6a 00                	push   $0x0
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 00                	push   $0x0
  801a1c:	52                   	push   %edx
  801a1d:	50                   	push   %eax
  801a1e:	6a 24                	push   $0x24
  801a20:	e8 ca fb ff ff       	call   8015ef <syscall>
  801a25:	83 c4 18             	add    $0x18,%esp
	return result;
  801a28:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a2b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a2e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a31:	89 01                	mov    %eax,(%ecx)
  801a33:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801a36:	8b 45 08             	mov    0x8(%ebp),%eax
  801a39:	c9                   	leave  
  801a3a:	c2 04 00             	ret    $0x4

00801a3d <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801a3d:	55                   	push   %ebp
  801a3e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801a40:	6a 00                	push   $0x0
  801a42:	6a 00                	push   $0x0
  801a44:	ff 75 10             	pushl  0x10(%ebp)
  801a47:	ff 75 0c             	pushl  0xc(%ebp)
  801a4a:	ff 75 08             	pushl  0x8(%ebp)
  801a4d:	6a 12                	push   $0x12
  801a4f:	e8 9b fb ff ff       	call   8015ef <syscall>
  801a54:	83 c4 18             	add    $0x18,%esp
	return ;
  801a57:	90                   	nop
}
  801a58:	c9                   	leave  
  801a59:	c3                   	ret    

00801a5a <sys_rcr2>:
uint32 sys_rcr2()
{
  801a5a:	55                   	push   %ebp
  801a5b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 00                	push   $0x0
  801a63:	6a 00                	push   $0x0
  801a65:	6a 00                	push   $0x0
  801a67:	6a 25                	push   $0x25
  801a69:	e8 81 fb ff ff       	call   8015ef <syscall>
  801a6e:	83 c4 18             	add    $0x18,%esp
}
  801a71:	c9                   	leave  
  801a72:	c3                   	ret    

00801a73 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801a73:	55                   	push   %ebp
  801a74:	89 e5                	mov    %esp,%ebp
  801a76:	83 ec 04             	sub    $0x4,%esp
  801a79:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801a7f:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801a83:	6a 00                	push   $0x0
  801a85:	6a 00                	push   $0x0
  801a87:	6a 00                	push   $0x0
  801a89:	6a 00                	push   $0x0
  801a8b:	50                   	push   %eax
  801a8c:	6a 26                	push   $0x26
  801a8e:	e8 5c fb ff ff       	call   8015ef <syscall>
  801a93:	83 c4 18             	add    $0x18,%esp
	return ;
  801a96:	90                   	nop
}
  801a97:	c9                   	leave  
  801a98:	c3                   	ret    

00801a99 <rsttst>:
void rsttst()
{
  801a99:	55                   	push   %ebp
  801a9a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 00                	push   $0x0
  801aa2:	6a 00                	push   $0x0
  801aa4:	6a 00                	push   $0x0
  801aa6:	6a 28                	push   $0x28
  801aa8:	e8 42 fb ff ff       	call   8015ef <syscall>
  801aad:	83 c4 18             	add    $0x18,%esp
	return ;
  801ab0:	90                   	nop
}
  801ab1:	c9                   	leave  
  801ab2:	c3                   	ret    

00801ab3 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ab3:	55                   	push   %ebp
  801ab4:	89 e5                	mov    %esp,%ebp
  801ab6:	83 ec 04             	sub    $0x4,%esp
  801ab9:	8b 45 14             	mov    0x14(%ebp),%eax
  801abc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801abf:	8b 55 18             	mov    0x18(%ebp),%edx
  801ac2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ac6:	52                   	push   %edx
  801ac7:	50                   	push   %eax
  801ac8:	ff 75 10             	pushl  0x10(%ebp)
  801acb:	ff 75 0c             	pushl  0xc(%ebp)
  801ace:	ff 75 08             	pushl  0x8(%ebp)
  801ad1:	6a 27                	push   $0x27
  801ad3:	e8 17 fb ff ff       	call   8015ef <syscall>
  801ad8:	83 c4 18             	add    $0x18,%esp
	return ;
  801adb:	90                   	nop
}
  801adc:	c9                   	leave  
  801add:	c3                   	ret    

00801ade <chktst>:
void chktst(uint32 n)
{
  801ade:	55                   	push   %ebp
  801adf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 00                	push   $0x0
  801ae9:	ff 75 08             	pushl  0x8(%ebp)
  801aec:	6a 29                	push   $0x29
  801aee:	e8 fc fa ff ff       	call   8015ef <syscall>
  801af3:	83 c4 18             	add    $0x18,%esp
	return ;
  801af6:	90                   	nop
}
  801af7:	c9                   	leave  
  801af8:	c3                   	ret    

00801af9 <inctst>:

void inctst()
{
  801af9:	55                   	push   %ebp
  801afa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801afc:	6a 00                	push   $0x0
  801afe:	6a 00                	push   $0x0
  801b00:	6a 00                	push   $0x0
  801b02:	6a 00                	push   $0x0
  801b04:	6a 00                	push   $0x0
  801b06:	6a 2a                	push   $0x2a
  801b08:	e8 e2 fa ff ff       	call   8015ef <syscall>
  801b0d:	83 c4 18             	add    $0x18,%esp
	return ;
  801b10:	90                   	nop
}
  801b11:	c9                   	leave  
  801b12:	c3                   	ret    

00801b13 <gettst>:
uint32 gettst()
{
  801b13:	55                   	push   %ebp
  801b14:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801b16:	6a 00                	push   $0x0
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 00                	push   $0x0
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 2b                	push   $0x2b
  801b22:	e8 c8 fa ff ff       	call   8015ef <syscall>
  801b27:	83 c4 18             	add    $0x18,%esp
}
  801b2a:	c9                   	leave  
  801b2b:	c3                   	ret    

00801b2c <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801b2c:	55                   	push   %ebp
  801b2d:	89 e5                	mov    %esp,%ebp
  801b2f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b32:	6a 00                	push   $0x0
  801b34:	6a 00                	push   $0x0
  801b36:	6a 00                	push   $0x0
  801b38:	6a 00                	push   $0x0
  801b3a:	6a 00                	push   $0x0
  801b3c:	6a 2c                	push   $0x2c
  801b3e:	e8 ac fa ff ff       	call   8015ef <syscall>
  801b43:	83 c4 18             	add    $0x18,%esp
  801b46:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801b49:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801b4d:	75 07                	jne    801b56 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801b4f:	b8 01 00 00 00       	mov    $0x1,%eax
  801b54:	eb 05                	jmp    801b5b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801b56:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b5b:	c9                   	leave  
  801b5c:	c3                   	ret    

00801b5d <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801b5d:	55                   	push   %ebp
  801b5e:	89 e5                	mov    %esp,%ebp
  801b60:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b63:	6a 00                	push   $0x0
  801b65:	6a 00                	push   $0x0
  801b67:	6a 00                	push   $0x0
  801b69:	6a 00                	push   $0x0
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 2c                	push   $0x2c
  801b6f:	e8 7b fa ff ff       	call   8015ef <syscall>
  801b74:	83 c4 18             	add    $0x18,%esp
  801b77:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801b7a:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801b7e:	75 07                	jne    801b87 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801b80:	b8 01 00 00 00       	mov    $0x1,%eax
  801b85:	eb 05                	jmp    801b8c <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801b87:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b8c:	c9                   	leave  
  801b8d:	c3                   	ret    

00801b8e <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801b8e:	55                   	push   %ebp
  801b8f:	89 e5                	mov    %esp,%ebp
  801b91:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b94:	6a 00                	push   $0x0
  801b96:	6a 00                	push   $0x0
  801b98:	6a 00                	push   $0x0
  801b9a:	6a 00                	push   $0x0
  801b9c:	6a 00                	push   $0x0
  801b9e:	6a 2c                	push   $0x2c
  801ba0:	e8 4a fa ff ff       	call   8015ef <syscall>
  801ba5:	83 c4 18             	add    $0x18,%esp
  801ba8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801bab:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801baf:	75 07                	jne    801bb8 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801bb1:	b8 01 00 00 00       	mov    $0x1,%eax
  801bb6:	eb 05                	jmp    801bbd <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801bb8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bbd:	c9                   	leave  
  801bbe:	c3                   	ret    

00801bbf <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801bbf:	55                   	push   %ebp
  801bc0:	89 e5                	mov    %esp,%ebp
  801bc2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 00                	push   $0x0
  801bcb:	6a 00                	push   $0x0
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 2c                	push   $0x2c
  801bd1:	e8 19 fa ff ff       	call   8015ef <syscall>
  801bd6:	83 c4 18             	add    $0x18,%esp
  801bd9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801bdc:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801be0:	75 07                	jne    801be9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801be2:	b8 01 00 00 00       	mov    $0x1,%eax
  801be7:	eb 05                	jmp    801bee <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801be9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bee:	c9                   	leave  
  801bef:	c3                   	ret    

00801bf0 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801bf0:	55                   	push   %ebp
  801bf1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801bf3:	6a 00                	push   $0x0
  801bf5:	6a 00                	push   $0x0
  801bf7:	6a 00                	push   $0x0
  801bf9:	6a 00                	push   $0x0
  801bfb:	ff 75 08             	pushl  0x8(%ebp)
  801bfe:	6a 2d                	push   $0x2d
  801c00:	e8 ea f9 ff ff       	call   8015ef <syscall>
  801c05:	83 c4 18             	add    $0x18,%esp
	return ;
  801c08:	90                   	nop
}
  801c09:	c9                   	leave  
  801c0a:	c3                   	ret    

00801c0b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801c0b:	55                   	push   %ebp
  801c0c:	89 e5                	mov    %esp,%ebp
  801c0e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801c0f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c12:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c15:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c18:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1b:	6a 00                	push   $0x0
  801c1d:	53                   	push   %ebx
  801c1e:	51                   	push   %ecx
  801c1f:	52                   	push   %edx
  801c20:	50                   	push   %eax
  801c21:	6a 2e                	push   $0x2e
  801c23:	e8 c7 f9 ff ff       	call   8015ef <syscall>
  801c28:	83 c4 18             	add    $0x18,%esp
}
  801c2b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c2e:	c9                   	leave  
  801c2f:	c3                   	ret    

00801c30 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801c30:	55                   	push   %ebp
  801c31:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801c33:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c36:	8b 45 08             	mov    0x8(%ebp),%eax
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 00                	push   $0x0
  801c3f:	52                   	push   %edx
  801c40:	50                   	push   %eax
  801c41:	6a 2f                	push   $0x2f
  801c43:	e8 a7 f9 ff ff       	call   8015ef <syscall>
  801c48:	83 c4 18             	add    $0x18,%esp
}
  801c4b:	c9                   	leave  
  801c4c:	c3                   	ret    

00801c4d <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801c4d:	55                   	push   %ebp
  801c4e:	89 e5                	mov    %esp,%ebp
  801c50:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801c53:	83 ec 0c             	sub    $0xc,%esp
  801c56:	68 d8 3d 80 00       	push   $0x803dd8
  801c5b:	e8 d3 e8 ff ff       	call   800533 <cprintf>
  801c60:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801c63:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801c6a:	83 ec 0c             	sub    $0xc,%esp
  801c6d:	68 04 3e 80 00       	push   $0x803e04
  801c72:	e8 bc e8 ff ff       	call   800533 <cprintf>
  801c77:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801c7a:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801c7e:	a1 38 41 80 00       	mov    0x804138,%eax
  801c83:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c86:	eb 56                	jmp    801cde <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801c88:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801c8c:	74 1c                	je     801caa <print_mem_block_lists+0x5d>
  801c8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c91:	8b 50 08             	mov    0x8(%eax),%edx
  801c94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c97:	8b 48 08             	mov    0x8(%eax),%ecx
  801c9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c9d:	8b 40 0c             	mov    0xc(%eax),%eax
  801ca0:	01 c8                	add    %ecx,%eax
  801ca2:	39 c2                	cmp    %eax,%edx
  801ca4:	73 04                	jae    801caa <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801ca6:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801caa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cad:	8b 50 08             	mov    0x8(%eax),%edx
  801cb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cb3:	8b 40 0c             	mov    0xc(%eax),%eax
  801cb6:	01 c2                	add    %eax,%edx
  801cb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cbb:	8b 40 08             	mov    0x8(%eax),%eax
  801cbe:	83 ec 04             	sub    $0x4,%esp
  801cc1:	52                   	push   %edx
  801cc2:	50                   	push   %eax
  801cc3:	68 19 3e 80 00       	push   $0x803e19
  801cc8:	e8 66 e8 ff ff       	call   800533 <cprintf>
  801ccd:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801cd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cd3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801cd6:	a1 40 41 80 00       	mov    0x804140,%eax
  801cdb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801cde:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ce2:	74 07                	je     801ceb <print_mem_block_lists+0x9e>
  801ce4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ce7:	8b 00                	mov    (%eax),%eax
  801ce9:	eb 05                	jmp    801cf0 <print_mem_block_lists+0xa3>
  801ceb:	b8 00 00 00 00       	mov    $0x0,%eax
  801cf0:	a3 40 41 80 00       	mov    %eax,0x804140
  801cf5:	a1 40 41 80 00       	mov    0x804140,%eax
  801cfa:	85 c0                	test   %eax,%eax
  801cfc:	75 8a                	jne    801c88 <print_mem_block_lists+0x3b>
  801cfe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d02:	75 84                	jne    801c88 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801d04:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801d08:	75 10                	jne    801d1a <print_mem_block_lists+0xcd>
  801d0a:	83 ec 0c             	sub    $0xc,%esp
  801d0d:	68 28 3e 80 00       	push   $0x803e28
  801d12:	e8 1c e8 ff ff       	call   800533 <cprintf>
  801d17:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801d1a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801d21:	83 ec 0c             	sub    $0xc,%esp
  801d24:	68 4c 3e 80 00       	push   $0x803e4c
  801d29:	e8 05 e8 ff ff       	call   800533 <cprintf>
  801d2e:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801d31:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801d35:	a1 40 40 80 00       	mov    0x804040,%eax
  801d3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d3d:	eb 56                	jmp    801d95 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801d3f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d43:	74 1c                	je     801d61 <print_mem_block_lists+0x114>
  801d45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d48:	8b 50 08             	mov    0x8(%eax),%edx
  801d4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d4e:	8b 48 08             	mov    0x8(%eax),%ecx
  801d51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d54:	8b 40 0c             	mov    0xc(%eax),%eax
  801d57:	01 c8                	add    %ecx,%eax
  801d59:	39 c2                	cmp    %eax,%edx
  801d5b:	73 04                	jae    801d61 <print_mem_block_lists+0x114>
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
  801d7a:	68 19 3e 80 00       	push   $0x803e19
  801d7f:	e8 af e7 ff ff       	call   800533 <cprintf>
  801d84:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801d87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d8a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801d8d:	a1 48 40 80 00       	mov    0x804048,%eax
  801d92:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d95:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d99:	74 07                	je     801da2 <print_mem_block_lists+0x155>
  801d9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d9e:	8b 00                	mov    (%eax),%eax
  801da0:	eb 05                	jmp    801da7 <print_mem_block_lists+0x15a>
  801da2:	b8 00 00 00 00       	mov    $0x0,%eax
  801da7:	a3 48 40 80 00       	mov    %eax,0x804048
  801dac:	a1 48 40 80 00       	mov    0x804048,%eax
  801db1:	85 c0                	test   %eax,%eax
  801db3:	75 8a                	jne    801d3f <print_mem_block_lists+0xf2>
  801db5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801db9:	75 84                	jne    801d3f <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801dbb:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801dbf:	75 10                	jne    801dd1 <print_mem_block_lists+0x184>
  801dc1:	83 ec 0c             	sub    $0xc,%esp
  801dc4:	68 64 3e 80 00       	push   $0x803e64
  801dc9:	e8 65 e7 ff ff       	call   800533 <cprintf>
  801dce:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801dd1:	83 ec 0c             	sub    $0xc,%esp
  801dd4:	68 d8 3d 80 00       	push   $0x803dd8
  801dd9:	e8 55 e7 ff ff       	call   800533 <cprintf>
  801dde:	83 c4 10             	add    $0x10,%esp

}
  801de1:	90                   	nop
  801de2:	c9                   	leave  
  801de3:	c3                   	ret    

00801de4 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801de4:	55                   	push   %ebp
  801de5:	89 e5                	mov    %esp,%ebp
  801de7:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801dea:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801df1:	00 00 00 
  801df4:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801dfb:	00 00 00 
  801dfe:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801e05:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801e08:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801e0f:	e9 9e 00 00 00       	jmp    801eb2 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801e14:	a1 50 40 80 00       	mov    0x804050,%eax
  801e19:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e1c:	c1 e2 04             	shl    $0x4,%edx
  801e1f:	01 d0                	add    %edx,%eax
  801e21:	85 c0                	test   %eax,%eax
  801e23:	75 14                	jne    801e39 <initialize_MemBlocksList+0x55>
  801e25:	83 ec 04             	sub    $0x4,%esp
  801e28:	68 8c 3e 80 00       	push   $0x803e8c
  801e2d:	6a 46                	push   $0x46
  801e2f:	68 af 3e 80 00       	push   $0x803eaf
  801e34:	e8 46 e4 ff ff       	call   80027f <_panic>
  801e39:	a1 50 40 80 00       	mov    0x804050,%eax
  801e3e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e41:	c1 e2 04             	shl    $0x4,%edx
  801e44:	01 d0                	add    %edx,%eax
  801e46:	8b 15 48 41 80 00    	mov    0x804148,%edx
  801e4c:	89 10                	mov    %edx,(%eax)
  801e4e:	8b 00                	mov    (%eax),%eax
  801e50:	85 c0                	test   %eax,%eax
  801e52:	74 18                	je     801e6c <initialize_MemBlocksList+0x88>
  801e54:	a1 48 41 80 00       	mov    0x804148,%eax
  801e59:	8b 15 50 40 80 00    	mov    0x804050,%edx
  801e5f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801e62:	c1 e1 04             	shl    $0x4,%ecx
  801e65:	01 ca                	add    %ecx,%edx
  801e67:	89 50 04             	mov    %edx,0x4(%eax)
  801e6a:	eb 12                	jmp    801e7e <initialize_MemBlocksList+0x9a>
  801e6c:	a1 50 40 80 00       	mov    0x804050,%eax
  801e71:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e74:	c1 e2 04             	shl    $0x4,%edx
  801e77:	01 d0                	add    %edx,%eax
  801e79:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801e7e:	a1 50 40 80 00       	mov    0x804050,%eax
  801e83:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e86:	c1 e2 04             	shl    $0x4,%edx
  801e89:	01 d0                	add    %edx,%eax
  801e8b:	a3 48 41 80 00       	mov    %eax,0x804148
  801e90:	a1 50 40 80 00       	mov    0x804050,%eax
  801e95:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e98:	c1 e2 04             	shl    $0x4,%edx
  801e9b:	01 d0                	add    %edx,%eax
  801e9d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801ea4:	a1 54 41 80 00       	mov    0x804154,%eax
  801ea9:	40                   	inc    %eax
  801eaa:	a3 54 41 80 00       	mov    %eax,0x804154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801eaf:	ff 45 f4             	incl   -0xc(%ebp)
  801eb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb5:	3b 45 08             	cmp    0x8(%ebp),%eax
  801eb8:	0f 82 56 ff ff ff    	jb     801e14 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801ebe:	90                   	nop
  801ebf:	c9                   	leave  
  801ec0:	c3                   	ret    

00801ec1 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801ec1:	55                   	push   %ebp
  801ec2:	89 e5                	mov    %esp,%ebp
  801ec4:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801ec7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eca:	8b 00                	mov    (%eax),%eax
  801ecc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801ecf:	eb 19                	jmp    801eea <find_block+0x29>
	{
		if(va==point->sva)
  801ed1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ed4:	8b 40 08             	mov    0x8(%eax),%eax
  801ed7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801eda:	75 05                	jne    801ee1 <find_block+0x20>
		   return point;
  801edc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801edf:	eb 36                	jmp    801f17 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee4:	8b 40 08             	mov    0x8(%eax),%eax
  801ee7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801eea:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801eee:	74 07                	je     801ef7 <find_block+0x36>
  801ef0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ef3:	8b 00                	mov    (%eax),%eax
  801ef5:	eb 05                	jmp    801efc <find_block+0x3b>
  801ef7:	b8 00 00 00 00       	mov    $0x0,%eax
  801efc:	8b 55 08             	mov    0x8(%ebp),%edx
  801eff:	89 42 08             	mov    %eax,0x8(%edx)
  801f02:	8b 45 08             	mov    0x8(%ebp),%eax
  801f05:	8b 40 08             	mov    0x8(%eax),%eax
  801f08:	85 c0                	test   %eax,%eax
  801f0a:	75 c5                	jne    801ed1 <find_block+0x10>
  801f0c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f10:	75 bf                	jne    801ed1 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  801f12:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f17:	c9                   	leave  
  801f18:	c3                   	ret    

00801f19 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  801f19:	55                   	push   %ebp
  801f1a:	89 e5                	mov    %esp,%ebp
  801f1c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  801f1f:	a1 40 40 80 00       	mov    0x804040,%eax
  801f24:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  801f27:	a1 44 40 80 00       	mov    0x804044,%eax
  801f2c:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  801f2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f32:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801f35:	74 24                	je     801f5b <insert_sorted_allocList+0x42>
  801f37:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3a:	8b 50 08             	mov    0x8(%eax),%edx
  801f3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f40:	8b 40 08             	mov    0x8(%eax),%eax
  801f43:	39 c2                	cmp    %eax,%edx
  801f45:	76 14                	jbe    801f5b <insert_sorted_allocList+0x42>
  801f47:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4a:	8b 50 08             	mov    0x8(%eax),%edx
  801f4d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f50:	8b 40 08             	mov    0x8(%eax),%eax
  801f53:	39 c2                	cmp    %eax,%edx
  801f55:	0f 82 60 01 00 00    	jb     8020bb <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  801f5b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f5f:	75 65                	jne    801fc6 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  801f61:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f65:	75 14                	jne    801f7b <insert_sorted_allocList+0x62>
  801f67:	83 ec 04             	sub    $0x4,%esp
  801f6a:	68 8c 3e 80 00       	push   $0x803e8c
  801f6f:	6a 6b                	push   $0x6b
  801f71:	68 af 3e 80 00       	push   $0x803eaf
  801f76:	e8 04 e3 ff ff       	call   80027f <_panic>
  801f7b:	8b 15 40 40 80 00    	mov    0x804040,%edx
  801f81:	8b 45 08             	mov    0x8(%ebp),%eax
  801f84:	89 10                	mov    %edx,(%eax)
  801f86:	8b 45 08             	mov    0x8(%ebp),%eax
  801f89:	8b 00                	mov    (%eax),%eax
  801f8b:	85 c0                	test   %eax,%eax
  801f8d:	74 0d                	je     801f9c <insert_sorted_allocList+0x83>
  801f8f:	a1 40 40 80 00       	mov    0x804040,%eax
  801f94:	8b 55 08             	mov    0x8(%ebp),%edx
  801f97:	89 50 04             	mov    %edx,0x4(%eax)
  801f9a:	eb 08                	jmp    801fa4 <insert_sorted_allocList+0x8b>
  801f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9f:	a3 44 40 80 00       	mov    %eax,0x804044
  801fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa7:	a3 40 40 80 00       	mov    %eax,0x804040
  801fac:	8b 45 08             	mov    0x8(%ebp),%eax
  801faf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801fb6:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801fbb:	40                   	inc    %eax
  801fbc:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  801fc1:	e9 dc 01 00 00       	jmp    8021a2 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  801fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc9:	8b 50 08             	mov    0x8(%eax),%edx
  801fcc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fcf:	8b 40 08             	mov    0x8(%eax),%eax
  801fd2:	39 c2                	cmp    %eax,%edx
  801fd4:	77 6c                	ja     802042 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  801fd6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fda:	74 06                	je     801fe2 <insert_sorted_allocList+0xc9>
  801fdc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801fe0:	75 14                	jne    801ff6 <insert_sorted_allocList+0xdd>
  801fe2:	83 ec 04             	sub    $0x4,%esp
  801fe5:	68 c8 3e 80 00       	push   $0x803ec8
  801fea:	6a 6f                	push   $0x6f
  801fec:	68 af 3e 80 00       	push   $0x803eaf
  801ff1:	e8 89 e2 ff ff       	call   80027f <_panic>
  801ff6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ff9:	8b 50 04             	mov    0x4(%eax),%edx
  801ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  801fff:	89 50 04             	mov    %edx,0x4(%eax)
  802002:	8b 45 08             	mov    0x8(%ebp),%eax
  802005:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802008:	89 10                	mov    %edx,(%eax)
  80200a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80200d:	8b 40 04             	mov    0x4(%eax),%eax
  802010:	85 c0                	test   %eax,%eax
  802012:	74 0d                	je     802021 <insert_sorted_allocList+0x108>
  802014:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802017:	8b 40 04             	mov    0x4(%eax),%eax
  80201a:	8b 55 08             	mov    0x8(%ebp),%edx
  80201d:	89 10                	mov    %edx,(%eax)
  80201f:	eb 08                	jmp    802029 <insert_sorted_allocList+0x110>
  802021:	8b 45 08             	mov    0x8(%ebp),%eax
  802024:	a3 40 40 80 00       	mov    %eax,0x804040
  802029:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80202c:	8b 55 08             	mov    0x8(%ebp),%edx
  80202f:	89 50 04             	mov    %edx,0x4(%eax)
  802032:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802037:	40                   	inc    %eax
  802038:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80203d:	e9 60 01 00 00       	jmp    8021a2 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802042:	8b 45 08             	mov    0x8(%ebp),%eax
  802045:	8b 50 08             	mov    0x8(%eax),%edx
  802048:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80204b:	8b 40 08             	mov    0x8(%eax),%eax
  80204e:	39 c2                	cmp    %eax,%edx
  802050:	0f 82 4c 01 00 00    	jb     8021a2 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802056:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80205a:	75 14                	jne    802070 <insert_sorted_allocList+0x157>
  80205c:	83 ec 04             	sub    $0x4,%esp
  80205f:	68 00 3f 80 00       	push   $0x803f00
  802064:	6a 73                	push   $0x73
  802066:	68 af 3e 80 00       	push   $0x803eaf
  80206b:	e8 0f e2 ff ff       	call   80027f <_panic>
  802070:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802076:	8b 45 08             	mov    0x8(%ebp),%eax
  802079:	89 50 04             	mov    %edx,0x4(%eax)
  80207c:	8b 45 08             	mov    0x8(%ebp),%eax
  80207f:	8b 40 04             	mov    0x4(%eax),%eax
  802082:	85 c0                	test   %eax,%eax
  802084:	74 0c                	je     802092 <insert_sorted_allocList+0x179>
  802086:	a1 44 40 80 00       	mov    0x804044,%eax
  80208b:	8b 55 08             	mov    0x8(%ebp),%edx
  80208e:	89 10                	mov    %edx,(%eax)
  802090:	eb 08                	jmp    80209a <insert_sorted_allocList+0x181>
  802092:	8b 45 08             	mov    0x8(%ebp),%eax
  802095:	a3 40 40 80 00       	mov    %eax,0x804040
  80209a:	8b 45 08             	mov    0x8(%ebp),%eax
  80209d:	a3 44 40 80 00       	mov    %eax,0x804044
  8020a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8020ab:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8020b0:	40                   	inc    %eax
  8020b1:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8020b6:	e9 e7 00 00 00       	jmp    8021a2 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8020bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020be:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8020c1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8020c8:	a1 40 40 80 00       	mov    0x804040,%eax
  8020cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020d0:	e9 9d 00 00 00       	jmp    802172 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8020d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d8:	8b 00                	mov    (%eax),%eax
  8020da:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8020dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e0:	8b 50 08             	mov    0x8(%eax),%edx
  8020e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e6:	8b 40 08             	mov    0x8(%eax),%eax
  8020e9:	39 c2                	cmp    %eax,%edx
  8020eb:	76 7d                	jbe    80216a <insert_sorted_allocList+0x251>
  8020ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f0:	8b 50 08             	mov    0x8(%eax),%edx
  8020f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8020f6:	8b 40 08             	mov    0x8(%eax),%eax
  8020f9:	39 c2                	cmp    %eax,%edx
  8020fb:	73 6d                	jae    80216a <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8020fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802101:	74 06                	je     802109 <insert_sorted_allocList+0x1f0>
  802103:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802107:	75 14                	jne    80211d <insert_sorted_allocList+0x204>
  802109:	83 ec 04             	sub    $0x4,%esp
  80210c:	68 24 3f 80 00       	push   $0x803f24
  802111:	6a 7f                	push   $0x7f
  802113:	68 af 3e 80 00       	push   $0x803eaf
  802118:	e8 62 e1 ff ff       	call   80027f <_panic>
  80211d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802120:	8b 10                	mov    (%eax),%edx
  802122:	8b 45 08             	mov    0x8(%ebp),%eax
  802125:	89 10                	mov    %edx,(%eax)
  802127:	8b 45 08             	mov    0x8(%ebp),%eax
  80212a:	8b 00                	mov    (%eax),%eax
  80212c:	85 c0                	test   %eax,%eax
  80212e:	74 0b                	je     80213b <insert_sorted_allocList+0x222>
  802130:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802133:	8b 00                	mov    (%eax),%eax
  802135:	8b 55 08             	mov    0x8(%ebp),%edx
  802138:	89 50 04             	mov    %edx,0x4(%eax)
  80213b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80213e:	8b 55 08             	mov    0x8(%ebp),%edx
  802141:	89 10                	mov    %edx,(%eax)
  802143:	8b 45 08             	mov    0x8(%ebp),%eax
  802146:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802149:	89 50 04             	mov    %edx,0x4(%eax)
  80214c:	8b 45 08             	mov    0x8(%ebp),%eax
  80214f:	8b 00                	mov    (%eax),%eax
  802151:	85 c0                	test   %eax,%eax
  802153:	75 08                	jne    80215d <insert_sorted_allocList+0x244>
  802155:	8b 45 08             	mov    0x8(%ebp),%eax
  802158:	a3 44 40 80 00       	mov    %eax,0x804044
  80215d:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802162:	40                   	inc    %eax
  802163:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  802168:	eb 39                	jmp    8021a3 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80216a:	a1 48 40 80 00       	mov    0x804048,%eax
  80216f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802172:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802176:	74 07                	je     80217f <insert_sorted_allocList+0x266>
  802178:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217b:	8b 00                	mov    (%eax),%eax
  80217d:	eb 05                	jmp    802184 <insert_sorted_allocList+0x26b>
  80217f:	b8 00 00 00 00       	mov    $0x0,%eax
  802184:	a3 48 40 80 00       	mov    %eax,0x804048
  802189:	a1 48 40 80 00       	mov    0x804048,%eax
  80218e:	85 c0                	test   %eax,%eax
  802190:	0f 85 3f ff ff ff    	jne    8020d5 <insert_sorted_allocList+0x1bc>
  802196:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80219a:	0f 85 35 ff ff ff    	jne    8020d5 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8021a0:	eb 01                	jmp    8021a3 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8021a2:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8021a3:	90                   	nop
  8021a4:	c9                   	leave  
  8021a5:	c3                   	ret    

008021a6 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8021a6:	55                   	push   %ebp
  8021a7:	89 e5                	mov    %esp,%ebp
  8021a9:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8021ac:	a1 38 41 80 00       	mov    0x804138,%eax
  8021b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021b4:	e9 85 01 00 00       	jmp    80233e <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8021b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8021bf:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021c2:	0f 82 6e 01 00 00    	jb     802336 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8021c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021cb:	8b 40 0c             	mov    0xc(%eax),%eax
  8021ce:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021d1:	0f 85 8a 00 00 00    	jne    802261 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8021d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021db:	75 17                	jne    8021f4 <alloc_block_FF+0x4e>
  8021dd:	83 ec 04             	sub    $0x4,%esp
  8021e0:	68 58 3f 80 00       	push   $0x803f58
  8021e5:	68 93 00 00 00       	push   $0x93
  8021ea:	68 af 3e 80 00       	push   $0x803eaf
  8021ef:	e8 8b e0 ff ff       	call   80027f <_panic>
  8021f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f7:	8b 00                	mov    (%eax),%eax
  8021f9:	85 c0                	test   %eax,%eax
  8021fb:	74 10                	je     80220d <alloc_block_FF+0x67>
  8021fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802200:	8b 00                	mov    (%eax),%eax
  802202:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802205:	8b 52 04             	mov    0x4(%edx),%edx
  802208:	89 50 04             	mov    %edx,0x4(%eax)
  80220b:	eb 0b                	jmp    802218 <alloc_block_FF+0x72>
  80220d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802210:	8b 40 04             	mov    0x4(%eax),%eax
  802213:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802218:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80221b:	8b 40 04             	mov    0x4(%eax),%eax
  80221e:	85 c0                	test   %eax,%eax
  802220:	74 0f                	je     802231 <alloc_block_FF+0x8b>
  802222:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802225:	8b 40 04             	mov    0x4(%eax),%eax
  802228:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80222b:	8b 12                	mov    (%edx),%edx
  80222d:	89 10                	mov    %edx,(%eax)
  80222f:	eb 0a                	jmp    80223b <alloc_block_FF+0x95>
  802231:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802234:	8b 00                	mov    (%eax),%eax
  802236:	a3 38 41 80 00       	mov    %eax,0x804138
  80223b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802244:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802247:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80224e:	a1 44 41 80 00       	mov    0x804144,%eax
  802253:	48                   	dec    %eax
  802254:	a3 44 41 80 00       	mov    %eax,0x804144
			   return  point;
  802259:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225c:	e9 10 01 00 00       	jmp    802371 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802261:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802264:	8b 40 0c             	mov    0xc(%eax),%eax
  802267:	3b 45 08             	cmp    0x8(%ebp),%eax
  80226a:	0f 86 c6 00 00 00    	jbe    802336 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802270:	a1 48 41 80 00       	mov    0x804148,%eax
  802275:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802278:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227b:	8b 50 08             	mov    0x8(%eax),%edx
  80227e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802281:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802284:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802287:	8b 55 08             	mov    0x8(%ebp),%edx
  80228a:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80228d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802291:	75 17                	jne    8022aa <alloc_block_FF+0x104>
  802293:	83 ec 04             	sub    $0x4,%esp
  802296:	68 58 3f 80 00       	push   $0x803f58
  80229b:	68 9b 00 00 00       	push   $0x9b
  8022a0:	68 af 3e 80 00       	push   $0x803eaf
  8022a5:	e8 d5 df ff ff       	call   80027f <_panic>
  8022aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022ad:	8b 00                	mov    (%eax),%eax
  8022af:	85 c0                	test   %eax,%eax
  8022b1:	74 10                	je     8022c3 <alloc_block_FF+0x11d>
  8022b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022b6:	8b 00                	mov    (%eax),%eax
  8022b8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022bb:	8b 52 04             	mov    0x4(%edx),%edx
  8022be:	89 50 04             	mov    %edx,0x4(%eax)
  8022c1:	eb 0b                	jmp    8022ce <alloc_block_FF+0x128>
  8022c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022c6:	8b 40 04             	mov    0x4(%eax),%eax
  8022c9:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8022ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022d1:	8b 40 04             	mov    0x4(%eax),%eax
  8022d4:	85 c0                	test   %eax,%eax
  8022d6:	74 0f                	je     8022e7 <alloc_block_FF+0x141>
  8022d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022db:	8b 40 04             	mov    0x4(%eax),%eax
  8022de:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022e1:	8b 12                	mov    (%edx),%edx
  8022e3:	89 10                	mov    %edx,(%eax)
  8022e5:	eb 0a                	jmp    8022f1 <alloc_block_FF+0x14b>
  8022e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022ea:	8b 00                	mov    (%eax),%eax
  8022ec:	a3 48 41 80 00       	mov    %eax,0x804148
  8022f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022f4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022fd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802304:	a1 54 41 80 00       	mov    0x804154,%eax
  802309:	48                   	dec    %eax
  80230a:	a3 54 41 80 00       	mov    %eax,0x804154
			   point->sva += size;
  80230f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802312:	8b 50 08             	mov    0x8(%eax),%edx
  802315:	8b 45 08             	mov    0x8(%ebp),%eax
  802318:	01 c2                	add    %eax,%edx
  80231a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231d:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802320:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802323:	8b 40 0c             	mov    0xc(%eax),%eax
  802326:	2b 45 08             	sub    0x8(%ebp),%eax
  802329:	89 c2                	mov    %eax,%edx
  80232b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232e:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802331:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802334:	eb 3b                	jmp    802371 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802336:	a1 40 41 80 00       	mov    0x804140,%eax
  80233b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80233e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802342:	74 07                	je     80234b <alloc_block_FF+0x1a5>
  802344:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802347:	8b 00                	mov    (%eax),%eax
  802349:	eb 05                	jmp    802350 <alloc_block_FF+0x1aa>
  80234b:	b8 00 00 00 00       	mov    $0x0,%eax
  802350:	a3 40 41 80 00       	mov    %eax,0x804140
  802355:	a1 40 41 80 00       	mov    0x804140,%eax
  80235a:	85 c0                	test   %eax,%eax
  80235c:	0f 85 57 fe ff ff    	jne    8021b9 <alloc_block_FF+0x13>
  802362:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802366:	0f 85 4d fe ff ff    	jne    8021b9 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  80236c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802371:	c9                   	leave  
  802372:	c3                   	ret    

00802373 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802373:	55                   	push   %ebp
  802374:	89 e5                	mov    %esp,%ebp
  802376:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802379:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802380:	a1 38 41 80 00       	mov    0x804138,%eax
  802385:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802388:	e9 df 00 00 00       	jmp    80246c <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  80238d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802390:	8b 40 0c             	mov    0xc(%eax),%eax
  802393:	3b 45 08             	cmp    0x8(%ebp),%eax
  802396:	0f 82 c8 00 00 00    	jb     802464 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  80239c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239f:	8b 40 0c             	mov    0xc(%eax),%eax
  8023a2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023a5:	0f 85 8a 00 00 00    	jne    802435 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8023ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023af:	75 17                	jne    8023c8 <alloc_block_BF+0x55>
  8023b1:	83 ec 04             	sub    $0x4,%esp
  8023b4:	68 58 3f 80 00       	push   $0x803f58
  8023b9:	68 b7 00 00 00       	push   $0xb7
  8023be:	68 af 3e 80 00       	push   $0x803eaf
  8023c3:	e8 b7 de ff ff       	call   80027f <_panic>
  8023c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cb:	8b 00                	mov    (%eax),%eax
  8023cd:	85 c0                	test   %eax,%eax
  8023cf:	74 10                	je     8023e1 <alloc_block_BF+0x6e>
  8023d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d4:	8b 00                	mov    (%eax),%eax
  8023d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023d9:	8b 52 04             	mov    0x4(%edx),%edx
  8023dc:	89 50 04             	mov    %edx,0x4(%eax)
  8023df:	eb 0b                	jmp    8023ec <alloc_block_BF+0x79>
  8023e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e4:	8b 40 04             	mov    0x4(%eax),%eax
  8023e7:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8023ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ef:	8b 40 04             	mov    0x4(%eax),%eax
  8023f2:	85 c0                	test   %eax,%eax
  8023f4:	74 0f                	je     802405 <alloc_block_BF+0x92>
  8023f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f9:	8b 40 04             	mov    0x4(%eax),%eax
  8023fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023ff:	8b 12                	mov    (%edx),%edx
  802401:	89 10                	mov    %edx,(%eax)
  802403:	eb 0a                	jmp    80240f <alloc_block_BF+0x9c>
  802405:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802408:	8b 00                	mov    (%eax),%eax
  80240a:	a3 38 41 80 00       	mov    %eax,0x804138
  80240f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802412:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802418:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802422:	a1 44 41 80 00       	mov    0x804144,%eax
  802427:	48                   	dec    %eax
  802428:	a3 44 41 80 00       	mov    %eax,0x804144
			   return currentMemBlock;
  80242d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802430:	e9 4d 01 00 00       	jmp    802582 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802435:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802438:	8b 40 0c             	mov    0xc(%eax),%eax
  80243b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80243e:	76 24                	jbe    802464 <alloc_block_BF+0xf1>
  802440:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802443:	8b 40 0c             	mov    0xc(%eax),%eax
  802446:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802449:	73 19                	jae    802464 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  80244b:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802452:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802455:	8b 40 0c             	mov    0xc(%eax),%eax
  802458:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  80245b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245e:	8b 40 08             	mov    0x8(%eax),%eax
  802461:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802464:	a1 40 41 80 00       	mov    0x804140,%eax
  802469:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80246c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802470:	74 07                	je     802479 <alloc_block_BF+0x106>
  802472:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802475:	8b 00                	mov    (%eax),%eax
  802477:	eb 05                	jmp    80247e <alloc_block_BF+0x10b>
  802479:	b8 00 00 00 00       	mov    $0x0,%eax
  80247e:	a3 40 41 80 00       	mov    %eax,0x804140
  802483:	a1 40 41 80 00       	mov    0x804140,%eax
  802488:	85 c0                	test   %eax,%eax
  80248a:	0f 85 fd fe ff ff    	jne    80238d <alloc_block_BF+0x1a>
  802490:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802494:	0f 85 f3 fe ff ff    	jne    80238d <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  80249a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80249e:	0f 84 d9 00 00 00    	je     80257d <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8024a4:	a1 48 41 80 00       	mov    0x804148,%eax
  8024a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8024ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024af:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024b2:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8024b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8024bb:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8024be:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8024c2:	75 17                	jne    8024db <alloc_block_BF+0x168>
  8024c4:	83 ec 04             	sub    $0x4,%esp
  8024c7:	68 58 3f 80 00       	push   $0x803f58
  8024cc:	68 c7 00 00 00       	push   $0xc7
  8024d1:	68 af 3e 80 00       	push   $0x803eaf
  8024d6:	e8 a4 dd ff ff       	call   80027f <_panic>
  8024db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024de:	8b 00                	mov    (%eax),%eax
  8024e0:	85 c0                	test   %eax,%eax
  8024e2:	74 10                	je     8024f4 <alloc_block_BF+0x181>
  8024e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024e7:	8b 00                	mov    (%eax),%eax
  8024e9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8024ec:	8b 52 04             	mov    0x4(%edx),%edx
  8024ef:	89 50 04             	mov    %edx,0x4(%eax)
  8024f2:	eb 0b                	jmp    8024ff <alloc_block_BF+0x18c>
  8024f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024f7:	8b 40 04             	mov    0x4(%eax),%eax
  8024fa:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8024ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802502:	8b 40 04             	mov    0x4(%eax),%eax
  802505:	85 c0                	test   %eax,%eax
  802507:	74 0f                	je     802518 <alloc_block_BF+0x1a5>
  802509:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80250c:	8b 40 04             	mov    0x4(%eax),%eax
  80250f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802512:	8b 12                	mov    (%edx),%edx
  802514:	89 10                	mov    %edx,(%eax)
  802516:	eb 0a                	jmp    802522 <alloc_block_BF+0x1af>
  802518:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80251b:	8b 00                	mov    (%eax),%eax
  80251d:	a3 48 41 80 00       	mov    %eax,0x804148
  802522:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802525:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80252b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80252e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802535:	a1 54 41 80 00       	mov    0x804154,%eax
  80253a:	48                   	dec    %eax
  80253b:	a3 54 41 80 00       	mov    %eax,0x804154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802540:	83 ec 08             	sub    $0x8,%esp
  802543:	ff 75 ec             	pushl  -0x14(%ebp)
  802546:	68 38 41 80 00       	push   $0x804138
  80254b:	e8 71 f9 ff ff       	call   801ec1 <find_block>
  802550:	83 c4 10             	add    $0x10,%esp
  802553:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802556:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802559:	8b 50 08             	mov    0x8(%eax),%edx
  80255c:	8b 45 08             	mov    0x8(%ebp),%eax
  80255f:	01 c2                	add    %eax,%edx
  802561:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802564:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802567:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80256a:	8b 40 0c             	mov    0xc(%eax),%eax
  80256d:	2b 45 08             	sub    0x8(%ebp),%eax
  802570:	89 c2                	mov    %eax,%edx
  802572:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802575:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802578:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80257b:	eb 05                	jmp    802582 <alloc_block_BF+0x20f>
	}
	return NULL;
  80257d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802582:	c9                   	leave  
  802583:	c3                   	ret    

00802584 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802584:	55                   	push   %ebp
  802585:	89 e5                	mov    %esp,%ebp
  802587:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  80258a:	a1 28 40 80 00       	mov    0x804028,%eax
  80258f:	85 c0                	test   %eax,%eax
  802591:	0f 85 de 01 00 00    	jne    802775 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802597:	a1 38 41 80 00       	mov    0x804138,%eax
  80259c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80259f:	e9 9e 01 00 00       	jmp    802742 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8025a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a7:	8b 40 0c             	mov    0xc(%eax),%eax
  8025aa:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025ad:	0f 82 87 01 00 00    	jb     80273a <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8025b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b6:	8b 40 0c             	mov    0xc(%eax),%eax
  8025b9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025bc:	0f 85 95 00 00 00    	jne    802657 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8025c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025c6:	75 17                	jne    8025df <alloc_block_NF+0x5b>
  8025c8:	83 ec 04             	sub    $0x4,%esp
  8025cb:	68 58 3f 80 00       	push   $0x803f58
  8025d0:	68 e0 00 00 00       	push   $0xe0
  8025d5:	68 af 3e 80 00       	push   $0x803eaf
  8025da:	e8 a0 dc ff ff       	call   80027f <_panic>
  8025df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e2:	8b 00                	mov    (%eax),%eax
  8025e4:	85 c0                	test   %eax,%eax
  8025e6:	74 10                	je     8025f8 <alloc_block_NF+0x74>
  8025e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025eb:	8b 00                	mov    (%eax),%eax
  8025ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025f0:	8b 52 04             	mov    0x4(%edx),%edx
  8025f3:	89 50 04             	mov    %edx,0x4(%eax)
  8025f6:	eb 0b                	jmp    802603 <alloc_block_NF+0x7f>
  8025f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fb:	8b 40 04             	mov    0x4(%eax),%eax
  8025fe:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802603:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802606:	8b 40 04             	mov    0x4(%eax),%eax
  802609:	85 c0                	test   %eax,%eax
  80260b:	74 0f                	je     80261c <alloc_block_NF+0x98>
  80260d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802610:	8b 40 04             	mov    0x4(%eax),%eax
  802613:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802616:	8b 12                	mov    (%edx),%edx
  802618:	89 10                	mov    %edx,(%eax)
  80261a:	eb 0a                	jmp    802626 <alloc_block_NF+0xa2>
  80261c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261f:	8b 00                	mov    (%eax),%eax
  802621:	a3 38 41 80 00       	mov    %eax,0x804138
  802626:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802629:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80262f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802632:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802639:	a1 44 41 80 00       	mov    0x804144,%eax
  80263e:	48                   	dec    %eax
  80263f:	a3 44 41 80 00       	mov    %eax,0x804144
				   svaOfNF = point->sva;
  802644:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802647:	8b 40 08             	mov    0x8(%eax),%eax
  80264a:	a3 28 40 80 00       	mov    %eax,0x804028
				   return  point;
  80264f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802652:	e9 f8 04 00 00       	jmp    802b4f <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802657:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265a:	8b 40 0c             	mov    0xc(%eax),%eax
  80265d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802660:	0f 86 d4 00 00 00    	jbe    80273a <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802666:	a1 48 41 80 00       	mov    0x804148,%eax
  80266b:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  80266e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802671:	8b 50 08             	mov    0x8(%eax),%edx
  802674:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802677:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  80267a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80267d:	8b 55 08             	mov    0x8(%ebp),%edx
  802680:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802683:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802687:	75 17                	jne    8026a0 <alloc_block_NF+0x11c>
  802689:	83 ec 04             	sub    $0x4,%esp
  80268c:	68 58 3f 80 00       	push   $0x803f58
  802691:	68 e9 00 00 00       	push   $0xe9
  802696:	68 af 3e 80 00       	push   $0x803eaf
  80269b:	e8 df db ff ff       	call   80027f <_panic>
  8026a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026a3:	8b 00                	mov    (%eax),%eax
  8026a5:	85 c0                	test   %eax,%eax
  8026a7:	74 10                	je     8026b9 <alloc_block_NF+0x135>
  8026a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026ac:	8b 00                	mov    (%eax),%eax
  8026ae:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026b1:	8b 52 04             	mov    0x4(%edx),%edx
  8026b4:	89 50 04             	mov    %edx,0x4(%eax)
  8026b7:	eb 0b                	jmp    8026c4 <alloc_block_NF+0x140>
  8026b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026bc:	8b 40 04             	mov    0x4(%eax),%eax
  8026bf:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8026c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026c7:	8b 40 04             	mov    0x4(%eax),%eax
  8026ca:	85 c0                	test   %eax,%eax
  8026cc:	74 0f                	je     8026dd <alloc_block_NF+0x159>
  8026ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026d1:	8b 40 04             	mov    0x4(%eax),%eax
  8026d4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026d7:	8b 12                	mov    (%edx),%edx
  8026d9:	89 10                	mov    %edx,(%eax)
  8026db:	eb 0a                	jmp    8026e7 <alloc_block_NF+0x163>
  8026dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026e0:	8b 00                	mov    (%eax),%eax
  8026e2:	a3 48 41 80 00       	mov    %eax,0x804148
  8026e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026f3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026fa:	a1 54 41 80 00       	mov    0x804154,%eax
  8026ff:	48                   	dec    %eax
  802700:	a3 54 41 80 00       	mov    %eax,0x804154
				   svaOfNF = ReturnedBlock->sva;
  802705:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802708:	8b 40 08             	mov    0x8(%eax),%eax
  80270b:	a3 28 40 80 00       	mov    %eax,0x804028
				   point->sva += size;
  802710:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802713:	8b 50 08             	mov    0x8(%eax),%edx
  802716:	8b 45 08             	mov    0x8(%ebp),%eax
  802719:	01 c2                	add    %eax,%edx
  80271b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271e:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802721:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802724:	8b 40 0c             	mov    0xc(%eax),%eax
  802727:	2b 45 08             	sub    0x8(%ebp),%eax
  80272a:	89 c2                	mov    %eax,%edx
  80272c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272f:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802732:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802735:	e9 15 04 00 00       	jmp    802b4f <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80273a:	a1 40 41 80 00       	mov    0x804140,%eax
  80273f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802742:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802746:	74 07                	je     80274f <alloc_block_NF+0x1cb>
  802748:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274b:	8b 00                	mov    (%eax),%eax
  80274d:	eb 05                	jmp    802754 <alloc_block_NF+0x1d0>
  80274f:	b8 00 00 00 00       	mov    $0x0,%eax
  802754:	a3 40 41 80 00       	mov    %eax,0x804140
  802759:	a1 40 41 80 00       	mov    0x804140,%eax
  80275e:	85 c0                	test   %eax,%eax
  802760:	0f 85 3e fe ff ff    	jne    8025a4 <alloc_block_NF+0x20>
  802766:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80276a:	0f 85 34 fe ff ff    	jne    8025a4 <alloc_block_NF+0x20>
  802770:	e9 d5 03 00 00       	jmp    802b4a <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802775:	a1 38 41 80 00       	mov    0x804138,%eax
  80277a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80277d:	e9 b1 01 00 00       	jmp    802933 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802782:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802785:	8b 50 08             	mov    0x8(%eax),%edx
  802788:	a1 28 40 80 00       	mov    0x804028,%eax
  80278d:	39 c2                	cmp    %eax,%edx
  80278f:	0f 82 96 01 00 00    	jb     80292b <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802795:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802798:	8b 40 0c             	mov    0xc(%eax),%eax
  80279b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80279e:	0f 82 87 01 00 00    	jb     80292b <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  8027a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a7:	8b 40 0c             	mov    0xc(%eax),%eax
  8027aa:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027ad:	0f 85 95 00 00 00    	jne    802848 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8027b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027b7:	75 17                	jne    8027d0 <alloc_block_NF+0x24c>
  8027b9:	83 ec 04             	sub    $0x4,%esp
  8027bc:	68 58 3f 80 00       	push   $0x803f58
  8027c1:	68 fc 00 00 00       	push   $0xfc
  8027c6:	68 af 3e 80 00       	push   $0x803eaf
  8027cb:	e8 af da ff ff       	call   80027f <_panic>
  8027d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d3:	8b 00                	mov    (%eax),%eax
  8027d5:	85 c0                	test   %eax,%eax
  8027d7:	74 10                	je     8027e9 <alloc_block_NF+0x265>
  8027d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027dc:	8b 00                	mov    (%eax),%eax
  8027de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027e1:	8b 52 04             	mov    0x4(%edx),%edx
  8027e4:	89 50 04             	mov    %edx,0x4(%eax)
  8027e7:	eb 0b                	jmp    8027f4 <alloc_block_NF+0x270>
  8027e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ec:	8b 40 04             	mov    0x4(%eax),%eax
  8027ef:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8027f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f7:	8b 40 04             	mov    0x4(%eax),%eax
  8027fa:	85 c0                	test   %eax,%eax
  8027fc:	74 0f                	je     80280d <alloc_block_NF+0x289>
  8027fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802801:	8b 40 04             	mov    0x4(%eax),%eax
  802804:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802807:	8b 12                	mov    (%edx),%edx
  802809:	89 10                	mov    %edx,(%eax)
  80280b:	eb 0a                	jmp    802817 <alloc_block_NF+0x293>
  80280d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802810:	8b 00                	mov    (%eax),%eax
  802812:	a3 38 41 80 00       	mov    %eax,0x804138
  802817:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802820:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802823:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80282a:	a1 44 41 80 00       	mov    0x804144,%eax
  80282f:	48                   	dec    %eax
  802830:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  802835:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802838:	8b 40 08             	mov    0x8(%eax),%eax
  80283b:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  802840:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802843:	e9 07 03 00 00       	jmp    802b4f <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802848:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284b:	8b 40 0c             	mov    0xc(%eax),%eax
  80284e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802851:	0f 86 d4 00 00 00    	jbe    80292b <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802857:	a1 48 41 80 00       	mov    0x804148,%eax
  80285c:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  80285f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802862:	8b 50 08             	mov    0x8(%eax),%edx
  802865:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802868:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  80286b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80286e:	8b 55 08             	mov    0x8(%ebp),%edx
  802871:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802874:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802878:	75 17                	jne    802891 <alloc_block_NF+0x30d>
  80287a:	83 ec 04             	sub    $0x4,%esp
  80287d:	68 58 3f 80 00       	push   $0x803f58
  802882:	68 04 01 00 00       	push   $0x104
  802887:	68 af 3e 80 00       	push   $0x803eaf
  80288c:	e8 ee d9 ff ff       	call   80027f <_panic>
  802891:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802894:	8b 00                	mov    (%eax),%eax
  802896:	85 c0                	test   %eax,%eax
  802898:	74 10                	je     8028aa <alloc_block_NF+0x326>
  80289a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80289d:	8b 00                	mov    (%eax),%eax
  80289f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8028a2:	8b 52 04             	mov    0x4(%edx),%edx
  8028a5:	89 50 04             	mov    %edx,0x4(%eax)
  8028a8:	eb 0b                	jmp    8028b5 <alloc_block_NF+0x331>
  8028aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028ad:	8b 40 04             	mov    0x4(%eax),%eax
  8028b0:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8028b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028b8:	8b 40 04             	mov    0x4(%eax),%eax
  8028bb:	85 c0                	test   %eax,%eax
  8028bd:	74 0f                	je     8028ce <alloc_block_NF+0x34a>
  8028bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028c2:	8b 40 04             	mov    0x4(%eax),%eax
  8028c5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8028c8:	8b 12                	mov    (%edx),%edx
  8028ca:	89 10                	mov    %edx,(%eax)
  8028cc:	eb 0a                	jmp    8028d8 <alloc_block_NF+0x354>
  8028ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028d1:	8b 00                	mov    (%eax),%eax
  8028d3:	a3 48 41 80 00       	mov    %eax,0x804148
  8028d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028db:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028e4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028eb:	a1 54 41 80 00       	mov    0x804154,%eax
  8028f0:	48                   	dec    %eax
  8028f1:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  8028f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028f9:	8b 40 08             	mov    0x8(%eax),%eax
  8028fc:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  802901:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802904:	8b 50 08             	mov    0x8(%eax),%edx
  802907:	8b 45 08             	mov    0x8(%ebp),%eax
  80290a:	01 c2                	add    %eax,%edx
  80290c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290f:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802912:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802915:	8b 40 0c             	mov    0xc(%eax),%eax
  802918:	2b 45 08             	sub    0x8(%ebp),%eax
  80291b:	89 c2                	mov    %eax,%edx
  80291d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802920:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802923:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802926:	e9 24 02 00 00       	jmp    802b4f <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  80292b:	a1 40 41 80 00       	mov    0x804140,%eax
  802930:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802933:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802937:	74 07                	je     802940 <alloc_block_NF+0x3bc>
  802939:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293c:	8b 00                	mov    (%eax),%eax
  80293e:	eb 05                	jmp    802945 <alloc_block_NF+0x3c1>
  802940:	b8 00 00 00 00       	mov    $0x0,%eax
  802945:	a3 40 41 80 00       	mov    %eax,0x804140
  80294a:	a1 40 41 80 00       	mov    0x804140,%eax
  80294f:	85 c0                	test   %eax,%eax
  802951:	0f 85 2b fe ff ff    	jne    802782 <alloc_block_NF+0x1fe>
  802957:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80295b:	0f 85 21 fe ff ff    	jne    802782 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802961:	a1 38 41 80 00       	mov    0x804138,%eax
  802966:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802969:	e9 ae 01 00 00       	jmp    802b1c <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  80296e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802971:	8b 50 08             	mov    0x8(%eax),%edx
  802974:	a1 28 40 80 00       	mov    0x804028,%eax
  802979:	39 c2                	cmp    %eax,%edx
  80297b:	0f 83 93 01 00 00    	jae    802b14 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802981:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802984:	8b 40 0c             	mov    0xc(%eax),%eax
  802987:	3b 45 08             	cmp    0x8(%ebp),%eax
  80298a:	0f 82 84 01 00 00    	jb     802b14 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802990:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802993:	8b 40 0c             	mov    0xc(%eax),%eax
  802996:	3b 45 08             	cmp    0x8(%ebp),%eax
  802999:	0f 85 95 00 00 00    	jne    802a34 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80299f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029a3:	75 17                	jne    8029bc <alloc_block_NF+0x438>
  8029a5:	83 ec 04             	sub    $0x4,%esp
  8029a8:	68 58 3f 80 00       	push   $0x803f58
  8029ad:	68 14 01 00 00       	push   $0x114
  8029b2:	68 af 3e 80 00       	push   $0x803eaf
  8029b7:	e8 c3 d8 ff ff       	call   80027f <_panic>
  8029bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bf:	8b 00                	mov    (%eax),%eax
  8029c1:	85 c0                	test   %eax,%eax
  8029c3:	74 10                	je     8029d5 <alloc_block_NF+0x451>
  8029c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c8:	8b 00                	mov    (%eax),%eax
  8029ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029cd:	8b 52 04             	mov    0x4(%edx),%edx
  8029d0:	89 50 04             	mov    %edx,0x4(%eax)
  8029d3:	eb 0b                	jmp    8029e0 <alloc_block_NF+0x45c>
  8029d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d8:	8b 40 04             	mov    0x4(%eax),%eax
  8029db:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8029e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e3:	8b 40 04             	mov    0x4(%eax),%eax
  8029e6:	85 c0                	test   %eax,%eax
  8029e8:	74 0f                	je     8029f9 <alloc_block_NF+0x475>
  8029ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ed:	8b 40 04             	mov    0x4(%eax),%eax
  8029f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029f3:	8b 12                	mov    (%edx),%edx
  8029f5:	89 10                	mov    %edx,(%eax)
  8029f7:	eb 0a                	jmp    802a03 <alloc_block_NF+0x47f>
  8029f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fc:	8b 00                	mov    (%eax),%eax
  8029fe:	a3 38 41 80 00       	mov    %eax,0x804138
  802a03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a06:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a16:	a1 44 41 80 00       	mov    0x804144,%eax
  802a1b:	48                   	dec    %eax
  802a1c:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  802a21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a24:	8b 40 08             	mov    0x8(%eax),%eax
  802a27:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  802a2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2f:	e9 1b 01 00 00       	jmp    802b4f <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802a34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a37:	8b 40 0c             	mov    0xc(%eax),%eax
  802a3a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a3d:	0f 86 d1 00 00 00    	jbe    802b14 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802a43:	a1 48 41 80 00       	mov    0x804148,%eax
  802a48:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802a4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4e:	8b 50 08             	mov    0x8(%eax),%edx
  802a51:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a54:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802a57:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a5a:	8b 55 08             	mov    0x8(%ebp),%edx
  802a5d:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802a60:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a64:	75 17                	jne    802a7d <alloc_block_NF+0x4f9>
  802a66:	83 ec 04             	sub    $0x4,%esp
  802a69:	68 58 3f 80 00       	push   $0x803f58
  802a6e:	68 1c 01 00 00       	push   $0x11c
  802a73:	68 af 3e 80 00       	push   $0x803eaf
  802a78:	e8 02 d8 ff ff       	call   80027f <_panic>
  802a7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a80:	8b 00                	mov    (%eax),%eax
  802a82:	85 c0                	test   %eax,%eax
  802a84:	74 10                	je     802a96 <alloc_block_NF+0x512>
  802a86:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a89:	8b 00                	mov    (%eax),%eax
  802a8b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a8e:	8b 52 04             	mov    0x4(%edx),%edx
  802a91:	89 50 04             	mov    %edx,0x4(%eax)
  802a94:	eb 0b                	jmp    802aa1 <alloc_block_NF+0x51d>
  802a96:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a99:	8b 40 04             	mov    0x4(%eax),%eax
  802a9c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802aa1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aa4:	8b 40 04             	mov    0x4(%eax),%eax
  802aa7:	85 c0                	test   %eax,%eax
  802aa9:	74 0f                	je     802aba <alloc_block_NF+0x536>
  802aab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aae:	8b 40 04             	mov    0x4(%eax),%eax
  802ab1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ab4:	8b 12                	mov    (%edx),%edx
  802ab6:	89 10                	mov    %edx,(%eax)
  802ab8:	eb 0a                	jmp    802ac4 <alloc_block_NF+0x540>
  802aba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802abd:	8b 00                	mov    (%eax),%eax
  802abf:	a3 48 41 80 00       	mov    %eax,0x804148
  802ac4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ac7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802acd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ad0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ad7:	a1 54 41 80 00       	mov    0x804154,%eax
  802adc:	48                   	dec    %eax
  802add:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  802ae2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ae5:	8b 40 08             	mov    0x8(%eax),%eax
  802ae8:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  802aed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af0:	8b 50 08             	mov    0x8(%eax),%edx
  802af3:	8b 45 08             	mov    0x8(%ebp),%eax
  802af6:	01 c2                	add    %eax,%edx
  802af8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afb:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802afe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b01:	8b 40 0c             	mov    0xc(%eax),%eax
  802b04:	2b 45 08             	sub    0x8(%ebp),%eax
  802b07:	89 c2                	mov    %eax,%edx
  802b09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0c:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802b0f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b12:	eb 3b                	jmp    802b4f <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b14:	a1 40 41 80 00       	mov    0x804140,%eax
  802b19:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b1c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b20:	74 07                	je     802b29 <alloc_block_NF+0x5a5>
  802b22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b25:	8b 00                	mov    (%eax),%eax
  802b27:	eb 05                	jmp    802b2e <alloc_block_NF+0x5aa>
  802b29:	b8 00 00 00 00       	mov    $0x0,%eax
  802b2e:	a3 40 41 80 00       	mov    %eax,0x804140
  802b33:	a1 40 41 80 00       	mov    0x804140,%eax
  802b38:	85 c0                	test   %eax,%eax
  802b3a:	0f 85 2e fe ff ff    	jne    80296e <alloc_block_NF+0x3ea>
  802b40:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b44:	0f 85 24 fe ff ff    	jne    80296e <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802b4a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b4f:	c9                   	leave  
  802b50:	c3                   	ret    

00802b51 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802b51:	55                   	push   %ebp
  802b52:	89 e5                	mov    %esp,%ebp
  802b54:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802b57:	a1 38 41 80 00       	mov    0x804138,%eax
  802b5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802b5f:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b64:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802b67:	a1 38 41 80 00       	mov    0x804138,%eax
  802b6c:	85 c0                	test   %eax,%eax
  802b6e:	74 14                	je     802b84 <insert_sorted_with_merge_freeList+0x33>
  802b70:	8b 45 08             	mov    0x8(%ebp),%eax
  802b73:	8b 50 08             	mov    0x8(%eax),%edx
  802b76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b79:	8b 40 08             	mov    0x8(%eax),%eax
  802b7c:	39 c2                	cmp    %eax,%edx
  802b7e:	0f 87 9b 01 00 00    	ja     802d1f <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802b84:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b88:	75 17                	jne    802ba1 <insert_sorted_with_merge_freeList+0x50>
  802b8a:	83 ec 04             	sub    $0x4,%esp
  802b8d:	68 8c 3e 80 00       	push   $0x803e8c
  802b92:	68 38 01 00 00       	push   $0x138
  802b97:	68 af 3e 80 00       	push   $0x803eaf
  802b9c:	e8 de d6 ff ff       	call   80027f <_panic>
  802ba1:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  802baa:	89 10                	mov    %edx,(%eax)
  802bac:	8b 45 08             	mov    0x8(%ebp),%eax
  802baf:	8b 00                	mov    (%eax),%eax
  802bb1:	85 c0                	test   %eax,%eax
  802bb3:	74 0d                	je     802bc2 <insert_sorted_with_merge_freeList+0x71>
  802bb5:	a1 38 41 80 00       	mov    0x804138,%eax
  802bba:	8b 55 08             	mov    0x8(%ebp),%edx
  802bbd:	89 50 04             	mov    %edx,0x4(%eax)
  802bc0:	eb 08                	jmp    802bca <insert_sorted_with_merge_freeList+0x79>
  802bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc5:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802bca:	8b 45 08             	mov    0x8(%ebp),%eax
  802bcd:	a3 38 41 80 00       	mov    %eax,0x804138
  802bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bdc:	a1 44 41 80 00       	mov    0x804144,%eax
  802be1:	40                   	inc    %eax
  802be2:	a3 44 41 80 00       	mov    %eax,0x804144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802be7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802beb:	0f 84 a8 06 00 00    	je     803299 <insert_sorted_with_merge_freeList+0x748>
  802bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf4:	8b 50 08             	mov    0x8(%eax),%edx
  802bf7:	8b 45 08             	mov    0x8(%ebp),%eax
  802bfa:	8b 40 0c             	mov    0xc(%eax),%eax
  802bfd:	01 c2                	add    %eax,%edx
  802bff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c02:	8b 40 08             	mov    0x8(%eax),%eax
  802c05:	39 c2                	cmp    %eax,%edx
  802c07:	0f 85 8c 06 00 00    	jne    803299 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c10:	8b 50 0c             	mov    0xc(%eax),%edx
  802c13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c16:	8b 40 0c             	mov    0xc(%eax),%eax
  802c19:	01 c2                	add    %eax,%edx
  802c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1e:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802c21:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c25:	75 17                	jne    802c3e <insert_sorted_with_merge_freeList+0xed>
  802c27:	83 ec 04             	sub    $0x4,%esp
  802c2a:	68 58 3f 80 00       	push   $0x803f58
  802c2f:	68 3c 01 00 00       	push   $0x13c
  802c34:	68 af 3e 80 00       	push   $0x803eaf
  802c39:	e8 41 d6 ff ff       	call   80027f <_panic>
  802c3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c41:	8b 00                	mov    (%eax),%eax
  802c43:	85 c0                	test   %eax,%eax
  802c45:	74 10                	je     802c57 <insert_sorted_with_merge_freeList+0x106>
  802c47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c4a:	8b 00                	mov    (%eax),%eax
  802c4c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c4f:	8b 52 04             	mov    0x4(%edx),%edx
  802c52:	89 50 04             	mov    %edx,0x4(%eax)
  802c55:	eb 0b                	jmp    802c62 <insert_sorted_with_merge_freeList+0x111>
  802c57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c5a:	8b 40 04             	mov    0x4(%eax),%eax
  802c5d:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c65:	8b 40 04             	mov    0x4(%eax),%eax
  802c68:	85 c0                	test   %eax,%eax
  802c6a:	74 0f                	je     802c7b <insert_sorted_with_merge_freeList+0x12a>
  802c6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c6f:	8b 40 04             	mov    0x4(%eax),%eax
  802c72:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c75:	8b 12                	mov    (%edx),%edx
  802c77:	89 10                	mov    %edx,(%eax)
  802c79:	eb 0a                	jmp    802c85 <insert_sorted_with_merge_freeList+0x134>
  802c7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c7e:	8b 00                	mov    (%eax),%eax
  802c80:	a3 38 41 80 00       	mov    %eax,0x804138
  802c85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c88:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c91:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c98:	a1 44 41 80 00       	mov    0x804144,%eax
  802c9d:	48                   	dec    %eax
  802c9e:	a3 44 41 80 00       	mov    %eax,0x804144
			head->size = 0;
  802ca3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ca6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802cad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802cb7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cbb:	75 17                	jne    802cd4 <insert_sorted_with_merge_freeList+0x183>
  802cbd:	83 ec 04             	sub    $0x4,%esp
  802cc0:	68 8c 3e 80 00       	push   $0x803e8c
  802cc5:	68 3f 01 00 00       	push   $0x13f
  802cca:	68 af 3e 80 00       	push   $0x803eaf
  802ccf:	e8 ab d5 ff ff       	call   80027f <_panic>
  802cd4:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802cda:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cdd:	89 10                	mov    %edx,(%eax)
  802cdf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ce2:	8b 00                	mov    (%eax),%eax
  802ce4:	85 c0                	test   %eax,%eax
  802ce6:	74 0d                	je     802cf5 <insert_sorted_with_merge_freeList+0x1a4>
  802ce8:	a1 48 41 80 00       	mov    0x804148,%eax
  802ced:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cf0:	89 50 04             	mov    %edx,0x4(%eax)
  802cf3:	eb 08                	jmp    802cfd <insert_sorted_with_merge_freeList+0x1ac>
  802cf5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf8:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802cfd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d00:	a3 48 41 80 00       	mov    %eax,0x804148
  802d05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d08:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d0f:	a1 54 41 80 00       	mov    0x804154,%eax
  802d14:	40                   	inc    %eax
  802d15:	a3 54 41 80 00       	mov    %eax,0x804154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802d1a:	e9 7a 05 00 00       	jmp    803299 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d22:	8b 50 08             	mov    0x8(%eax),%edx
  802d25:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d28:	8b 40 08             	mov    0x8(%eax),%eax
  802d2b:	39 c2                	cmp    %eax,%edx
  802d2d:	0f 82 14 01 00 00    	jb     802e47 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802d33:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d36:	8b 50 08             	mov    0x8(%eax),%edx
  802d39:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d3c:	8b 40 0c             	mov    0xc(%eax),%eax
  802d3f:	01 c2                	add    %eax,%edx
  802d41:	8b 45 08             	mov    0x8(%ebp),%eax
  802d44:	8b 40 08             	mov    0x8(%eax),%eax
  802d47:	39 c2                	cmp    %eax,%edx
  802d49:	0f 85 90 00 00 00    	jne    802ddf <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802d4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d52:	8b 50 0c             	mov    0xc(%eax),%edx
  802d55:	8b 45 08             	mov    0x8(%ebp),%eax
  802d58:	8b 40 0c             	mov    0xc(%eax),%eax
  802d5b:	01 c2                	add    %eax,%edx
  802d5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d60:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802d63:	8b 45 08             	mov    0x8(%ebp),%eax
  802d66:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d70:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802d77:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d7b:	75 17                	jne    802d94 <insert_sorted_with_merge_freeList+0x243>
  802d7d:	83 ec 04             	sub    $0x4,%esp
  802d80:	68 8c 3e 80 00       	push   $0x803e8c
  802d85:	68 49 01 00 00       	push   $0x149
  802d8a:	68 af 3e 80 00       	push   $0x803eaf
  802d8f:	e8 eb d4 ff ff       	call   80027f <_panic>
  802d94:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9d:	89 10                	mov    %edx,(%eax)
  802d9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802da2:	8b 00                	mov    (%eax),%eax
  802da4:	85 c0                	test   %eax,%eax
  802da6:	74 0d                	je     802db5 <insert_sorted_with_merge_freeList+0x264>
  802da8:	a1 48 41 80 00       	mov    0x804148,%eax
  802dad:	8b 55 08             	mov    0x8(%ebp),%edx
  802db0:	89 50 04             	mov    %edx,0x4(%eax)
  802db3:	eb 08                	jmp    802dbd <insert_sorted_with_merge_freeList+0x26c>
  802db5:	8b 45 08             	mov    0x8(%ebp),%eax
  802db8:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc0:	a3 48 41 80 00       	mov    %eax,0x804148
  802dc5:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dcf:	a1 54 41 80 00       	mov    0x804154,%eax
  802dd4:	40                   	inc    %eax
  802dd5:	a3 54 41 80 00       	mov    %eax,0x804154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802dda:	e9 bb 04 00 00       	jmp    80329a <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802ddf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802de3:	75 17                	jne    802dfc <insert_sorted_with_merge_freeList+0x2ab>
  802de5:	83 ec 04             	sub    $0x4,%esp
  802de8:	68 00 3f 80 00       	push   $0x803f00
  802ded:	68 4c 01 00 00       	push   $0x14c
  802df2:	68 af 3e 80 00       	push   $0x803eaf
  802df7:	e8 83 d4 ff ff       	call   80027f <_panic>
  802dfc:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802e02:	8b 45 08             	mov    0x8(%ebp),%eax
  802e05:	89 50 04             	mov    %edx,0x4(%eax)
  802e08:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0b:	8b 40 04             	mov    0x4(%eax),%eax
  802e0e:	85 c0                	test   %eax,%eax
  802e10:	74 0c                	je     802e1e <insert_sorted_with_merge_freeList+0x2cd>
  802e12:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802e17:	8b 55 08             	mov    0x8(%ebp),%edx
  802e1a:	89 10                	mov    %edx,(%eax)
  802e1c:	eb 08                	jmp    802e26 <insert_sorted_with_merge_freeList+0x2d5>
  802e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e21:	a3 38 41 80 00       	mov    %eax,0x804138
  802e26:	8b 45 08             	mov    0x8(%ebp),%eax
  802e29:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e31:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e37:	a1 44 41 80 00       	mov    0x804144,%eax
  802e3c:	40                   	inc    %eax
  802e3d:	a3 44 41 80 00       	mov    %eax,0x804144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802e42:	e9 53 04 00 00       	jmp    80329a <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802e47:	a1 38 41 80 00       	mov    0x804138,%eax
  802e4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e4f:	e9 15 04 00 00       	jmp    803269 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802e54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e57:	8b 00                	mov    (%eax),%eax
  802e59:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802e5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5f:	8b 50 08             	mov    0x8(%eax),%edx
  802e62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e65:	8b 40 08             	mov    0x8(%eax),%eax
  802e68:	39 c2                	cmp    %eax,%edx
  802e6a:	0f 86 f1 03 00 00    	jbe    803261 <insert_sorted_with_merge_freeList+0x710>
  802e70:	8b 45 08             	mov    0x8(%ebp),%eax
  802e73:	8b 50 08             	mov    0x8(%eax),%edx
  802e76:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e79:	8b 40 08             	mov    0x8(%eax),%eax
  802e7c:	39 c2                	cmp    %eax,%edx
  802e7e:	0f 83 dd 03 00 00    	jae    803261 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802e84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e87:	8b 50 08             	mov    0x8(%eax),%edx
  802e8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8d:	8b 40 0c             	mov    0xc(%eax),%eax
  802e90:	01 c2                	add    %eax,%edx
  802e92:	8b 45 08             	mov    0x8(%ebp),%eax
  802e95:	8b 40 08             	mov    0x8(%eax),%eax
  802e98:	39 c2                	cmp    %eax,%edx
  802e9a:	0f 85 b9 01 00 00    	jne    803059 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802ea0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea3:	8b 50 08             	mov    0x8(%eax),%edx
  802ea6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea9:	8b 40 0c             	mov    0xc(%eax),%eax
  802eac:	01 c2                	add    %eax,%edx
  802eae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eb1:	8b 40 08             	mov    0x8(%eax),%eax
  802eb4:	39 c2                	cmp    %eax,%edx
  802eb6:	0f 85 0d 01 00 00    	jne    802fc9 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802ebc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebf:	8b 50 0c             	mov    0xc(%eax),%edx
  802ec2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ec5:	8b 40 0c             	mov    0xc(%eax),%eax
  802ec8:	01 c2                	add    %eax,%edx
  802eca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ecd:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802ed0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ed4:	75 17                	jne    802eed <insert_sorted_with_merge_freeList+0x39c>
  802ed6:	83 ec 04             	sub    $0x4,%esp
  802ed9:	68 58 3f 80 00       	push   $0x803f58
  802ede:	68 5c 01 00 00       	push   $0x15c
  802ee3:	68 af 3e 80 00       	push   $0x803eaf
  802ee8:	e8 92 d3 ff ff       	call   80027f <_panic>
  802eed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ef0:	8b 00                	mov    (%eax),%eax
  802ef2:	85 c0                	test   %eax,%eax
  802ef4:	74 10                	je     802f06 <insert_sorted_with_merge_freeList+0x3b5>
  802ef6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ef9:	8b 00                	mov    (%eax),%eax
  802efb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802efe:	8b 52 04             	mov    0x4(%edx),%edx
  802f01:	89 50 04             	mov    %edx,0x4(%eax)
  802f04:	eb 0b                	jmp    802f11 <insert_sorted_with_merge_freeList+0x3c0>
  802f06:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f09:	8b 40 04             	mov    0x4(%eax),%eax
  802f0c:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802f11:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f14:	8b 40 04             	mov    0x4(%eax),%eax
  802f17:	85 c0                	test   %eax,%eax
  802f19:	74 0f                	je     802f2a <insert_sorted_with_merge_freeList+0x3d9>
  802f1b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f1e:	8b 40 04             	mov    0x4(%eax),%eax
  802f21:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f24:	8b 12                	mov    (%edx),%edx
  802f26:	89 10                	mov    %edx,(%eax)
  802f28:	eb 0a                	jmp    802f34 <insert_sorted_with_merge_freeList+0x3e3>
  802f2a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f2d:	8b 00                	mov    (%eax),%eax
  802f2f:	a3 38 41 80 00       	mov    %eax,0x804138
  802f34:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f37:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f3d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f40:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f47:	a1 44 41 80 00       	mov    0x804144,%eax
  802f4c:	48                   	dec    %eax
  802f4d:	a3 44 41 80 00       	mov    %eax,0x804144
						nextBlock->sva = 0;
  802f52:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f55:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  802f5c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f5f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  802f66:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f6a:	75 17                	jne    802f83 <insert_sorted_with_merge_freeList+0x432>
  802f6c:	83 ec 04             	sub    $0x4,%esp
  802f6f:	68 8c 3e 80 00       	push   $0x803e8c
  802f74:	68 5f 01 00 00       	push   $0x15f
  802f79:	68 af 3e 80 00       	push   $0x803eaf
  802f7e:	e8 fc d2 ff ff       	call   80027f <_panic>
  802f83:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f89:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f8c:	89 10                	mov    %edx,(%eax)
  802f8e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f91:	8b 00                	mov    (%eax),%eax
  802f93:	85 c0                	test   %eax,%eax
  802f95:	74 0d                	je     802fa4 <insert_sorted_with_merge_freeList+0x453>
  802f97:	a1 48 41 80 00       	mov    0x804148,%eax
  802f9c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f9f:	89 50 04             	mov    %edx,0x4(%eax)
  802fa2:	eb 08                	jmp    802fac <insert_sorted_with_merge_freeList+0x45b>
  802fa4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fa7:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802fac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802faf:	a3 48 41 80 00       	mov    %eax,0x804148
  802fb4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fb7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fbe:	a1 54 41 80 00       	mov    0x804154,%eax
  802fc3:	40                   	inc    %eax
  802fc4:	a3 54 41 80 00       	mov    %eax,0x804154
					}
					currentBlock->size += blockToInsert->size;
  802fc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fcc:	8b 50 0c             	mov    0xc(%eax),%edx
  802fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd2:	8b 40 0c             	mov    0xc(%eax),%eax
  802fd5:	01 c2                	add    %eax,%edx
  802fd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fda:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  802fdd:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  802fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  802fea:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802ff1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ff5:	75 17                	jne    80300e <insert_sorted_with_merge_freeList+0x4bd>
  802ff7:	83 ec 04             	sub    $0x4,%esp
  802ffa:	68 8c 3e 80 00       	push   $0x803e8c
  802fff:	68 64 01 00 00       	push   $0x164
  803004:	68 af 3e 80 00       	push   $0x803eaf
  803009:	e8 71 d2 ff ff       	call   80027f <_panic>
  80300e:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803014:	8b 45 08             	mov    0x8(%ebp),%eax
  803017:	89 10                	mov    %edx,(%eax)
  803019:	8b 45 08             	mov    0x8(%ebp),%eax
  80301c:	8b 00                	mov    (%eax),%eax
  80301e:	85 c0                	test   %eax,%eax
  803020:	74 0d                	je     80302f <insert_sorted_with_merge_freeList+0x4de>
  803022:	a1 48 41 80 00       	mov    0x804148,%eax
  803027:	8b 55 08             	mov    0x8(%ebp),%edx
  80302a:	89 50 04             	mov    %edx,0x4(%eax)
  80302d:	eb 08                	jmp    803037 <insert_sorted_with_merge_freeList+0x4e6>
  80302f:	8b 45 08             	mov    0x8(%ebp),%eax
  803032:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803037:	8b 45 08             	mov    0x8(%ebp),%eax
  80303a:	a3 48 41 80 00       	mov    %eax,0x804148
  80303f:	8b 45 08             	mov    0x8(%ebp),%eax
  803042:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803049:	a1 54 41 80 00       	mov    0x804154,%eax
  80304e:	40                   	inc    %eax
  80304f:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  803054:	e9 41 02 00 00       	jmp    80329a <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803059:	8b 45 08             	mov    0x8(%ebp),%eax
  80305c:	8b 50 08             	mov    0x8(%eax),%edx
  80305f:	8b 45 08             	mov    0x8(%ebp),%eax
  803062:	8b 40 0c             	mov    0xc(%eax),%eax
  803065:	01 c2                	add    %eax,%edx
  803067:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80306a:	8b 40 08             	mov    0x8(%eax),%eax
  80306d:	39 c2                	cmp    %eax,%edx
  80306f:	0f 85 7c 01 00 00    	jne    8031f1 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803075:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803079:	74 06                	je     803081 <insert_sorted_with_merge_freeList+0x530>
  80307b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80307f:	75 17                	jne    803098 <insert_sorted_with_merge_freeList+0x547>
  803081:	83 ec 04             	sub    $0x4,%esp
  803084:	68 c8 3e 80 00       	push   $0x803ec8
  803089:	68 69 01 00 00       	push   $0x169
  80308e:	68 af 3e 80 00       	push   $0x803eaf
  803093:	e8 e7 d1 ff ff       	call   80027f <_panic>
  803098:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80309b:	8b 50 04             	mov    0x4(%eax),%edx
  80309e:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a1:	89 50 04             	mov    %edx,0x4(%eax)
  8030a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030aa:	89 10                	mov    %edx,(%eax)
  8030ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030af:	8b 40 04             	mov    0x4(%eax),%eax
  8030b2:	85 c0                	test   %eax,%eax
  8030b4:	74 0d                	je     8030c3 <insert_sorted_with_merge_freeList+0x572>
  8030b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030b9:	8b 40 04             	mov    0x4(%eax),%eax
  8030bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8030bf:	89 10                	mov    %edx,(%eax)
  8030c1:	eb 08                	jmp    8030cb <insert_sorted_with_merge_freeList+0x57a>
  8030c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c6:	a3 38 41 80 00       	mov    %eax,0x804138
  8030cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8030d1:	89 50 04             	mov    %edx,0x4(%eax)
  8030d4:	a1 44 41 80 00       	mov    0x804144,%eax
  8030d9:	40                   	inc    %eax
  8030da:	a3 44 41 80 00       	mov    %eax,0x804144
					blockToInsert->size += nextBlock->size;
  8030df:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e2:	8b 50 0c             	mov    0xc(%eax),%edx
  8030e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030e8:	8b 40 0c             	mov    0xc(%eax),%eax
  8030eb:	01 c2                	add    %eax,%edx
  8030ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f0:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8030f3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030f7:	75 17                	jne    803110 <insert_sorted_with_merge_freeList+0x5bf>
  8030f9:	83 ec 04             	sub    $0x4,%esp
  8030fc:	68 58 3f 80 00       	push   $0x803f58
  803101:	68 6b 01 00 00       	push   $0x16b
  803106:	68 af 3e 80 00       	push   $0x803eaf
  80310b:	e8 6f d1 ff ff       	call   80027f <_panic>
  803110:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803113:	8b 00                	mov    (%eax),%eax
  803115:	85 c0                	test   %eax,%eax
  803117:	74 10                	je     803129 <insert_sorted_with_merge_freeList+0x5d8>
  803119:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80311c:	8b 00                	mov    (%eax),%eax
  80311e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803121:	8b 52 04             	mov    0x4(%edx),%edx
  803124:	89 50 04             	mov    %edx,0x4(%eax)
  803127:	eb 0b                	jmp    803134 <insert_sorted_with_merge_freeList+0x5e3>
  803129:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80312c:	8b 40 04             	mov    0x4(%eax),%eax
  80312f:	a3 3c 41 80 00       	mov    %eax,0x80413c
  803134:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803137:	8b 40 04             	mov    0x4(%eax),%eax
  80313a:	85 c0                	test   %eax,%eax
  80313c:	74 0f                	je     80314d <insert_sorted_with_merge_freeList+0x5fc>
  80313e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803141:	8b 40 04             	mov    0x4(%eax),%eax
  803144:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803147:	8b 12                	mov    (%edx),%edx
  803149:	89 10                	mov    %edx,(%eax)
  80314b:	eb 0a                	jmp    803157 <insert_sorted_with_merge_freeList+0x606>
  80314d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803150:	8b 00                	mov    (%eax),%eax
  803152:	a3 38 41 80 00       	mov    %eax,0x804138
  803157:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80315a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803160:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803163:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80316a:	a1 44 41 80 00       	mov    0x804144,%eax
  80316f:	48                   	dec    %eax
  803170:	a3 44 41 80 00       	mov    %eax,0x804144
					nextBlock->sva = 0;
  803175:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803178:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  80317f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803182:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803189:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80318d:	75 17                	jne    8031a6 <insert_sorted_with_merge_freeList+0x655>
  80318f:	83 ec 04             	sub    $0x4,%esp
  803192:	68 8c 3e 80 00       	push   $0x803e8c
  803197:	68 6e 01 00 00       	push   $0x16e
  80319c:	68 af 3e 80 00       	push   $0x803eaf
  8031a1:	e8 d9 d0 ff ff       	call   80027f <_panic>
  8031a6:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8031ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031af:	89 10                	mov    %edx,(%eax)
  8031b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031b4:	8b 00                	mov    (%eax),%eax
  8031b6:	85 c0                	test   %eax,%eax
  8031b8:	74 0d                	je     8031c7 <insert_sorted_with_merge_freeList+0x676>
  8031ba:	a1 48 41 80 00       	mov    0x804148,%eax
  8031bf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031c2:	89 50 04             	mov    %edx,0x4(%eax)
  8031c5:	eb 08                	jmp    8031cf <insert_sorted_with_merge_freeList+0x67e>
  8031c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ca:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8031cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d2:	a3 48 41 80 00       	mov    %eax,0x804148
  8031d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031da:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031e1:	a1 54 41 80 00       	mov    0x804154,%eax
  8031e6:	40                   	inc    %eax
  8031e7:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  8031ec:	e9 a9 00 00 00       	jmp    80329a <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8031f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031f5:	74 06                	je     8031fd <insert_sorted_with_merge_freeList+0x6ac>
  8031f7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031fb:	75 17                	jne    803214 <insert_sorted_with_merge_freeList+0x6c3>
  8031fd:	83 ec 04             	sub    $0x4,%esp
  803200:	68 24 3f 80 00       	push   $0x803f24
  803205:	68 73 01 00 00       	push   $0x173
  80320a:	68 af 3e 80 00       	push   $0x803eaf
  80320f:	e8 6b d0 ff ff       	call   80027f <_panic>
  803214:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803217:	8b 10                	mov    (%eax),%edx
  803219:	8b 45 08             	mov    0x8(%ebp),%eax
  80321c:	89 10                	mov    %edx,(%eax)
  80321e:	8b 45 08             	mov    0x8(%ebp),%eax
  803221:	8b 00                	mov    (%eax),%eax
  803223:	85 c0                	test   %eax,%eax
  803225:	74 0b                	je     803232 <insert_sorted_with_merge_freeList+0x6e1>
  803227:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80322a:	8b 00                	mov    (%eax),%eax
  80322c:	8b 55 08             	mov    0x8(%ebp),%edx
  80322f:	89 50 04             	mov    %edx,0x4(%eax)
  803232:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803235:	8b 55 08             	mov    0x8(%ebp),%edx
  803238:	89 10                	mov    %edx,(%eax)
  80323a:	8b 45 08             	mov    0x8(%ebp),%eax
  80323d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803240:	89 50 04             	mov    %edx,0x4(%eax)
  803243:	8b 45 08             	mov    0x8(%ebp),%eax
  803246:	8b 00                	mov    (%eax),%eax
  803248:	85 c0                	test   %eax,%eax
  80324a:	75 08                	jne    803254 <insert_sorted_with_merge_freeList+0x703>
  80324c:	8b 45 08             	mov    0x8(%ebp),%eax
  80324f:	a3 3c 41 80 00       	mov    %eax,0x80413c
  803254:	a1 44 41 80 00       	mov    0x804144,%eax
  803259:	40                   	inc    %eax
  80325a:	a3 44 41 80 00       	mov    %eax,0x804144
					break;
  80325f:	eb 39                	jmp    80329a <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803261:	a1 40 41 80 00       	mov    0x804140,%eax
  803266:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803269:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80326d:	74 07                	je     803276 <insert_sorted_with_merge_freeList+0x725>
  80326f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803272:	8b 00                	mov    (%eax),%eax
  803274:	eb 05                	jmp    80327b <insert_sorted_with_merge_freeList+0x72a>
  803276:	b8 00 00 00 00       	mov    $0x0,%eax
  80327b:	a3 40 41 80 00       	mov    %eax,0x804140
  803280:	a1 40 41 80 00       	mov    0x804140,%eax
  803285:	85 c0                	test   %eax,%eax
  803287:	0f 85 c7 fb ff ff    	jne    802e54 <insert_sorted_with_merge_freeList+0x303>
  80328d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803291:	0f 85 bd fb ff ff    	jne    802e54 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803297:	eb 01                	jmp    80329a <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803299:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80329a:	90                   	nop
  80329b:	c9                   	leave  
  80329c:	c3                   	ret    
  80329d:	66 90                	xchg   %ax,%ax
  80329f:	90                   	nop

008032a0 <__udivdi3>:
  8032a0:	55                   	push   %ebp
  8032a1:	57                   	push   %edi
  8032a2:	56                   	push   %esi
  8032a3:	53                   	push   %ebx
  8032a4:	83 ec 1c             	sub    $0x1c,%esp
  8032a7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8032ab:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8032af:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8032b3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8032b7:	89 ca                	mov    %ecx,%edx
  8032b9:	89 f8                	mov    %edi,%eax
  8032bb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8032bf:	85 f6                	test   %esi,%esi
  8032c1:	75 2d                	jne    8032f0 <__udivdi3+0x50>
  8032c3:	39 cf                	cmp    %ecx,%edi
  8032c5:	77 65                	ja     80332c <__udivdi3+0x8c>
  8032c7:	89 fd                	mov    %edi,%ebp
  8032c9:	85 ff                	test   %edi,%edi
  8032cb:	75 0b                	jne    8032d8 <__udivdi3+0x38>
  8032cd:	b8 01 00 00 00       	mov    $0x1,%eax
  8032d2:	31 d2                	xor    %edx,%edx
  8032d4:	f7 f7                	div    %edi
  8032d6:	89 c5                	mov    %eax,%ebp
  8032d8:	31 d2                	xor    %edx,%edx
  8032da:	89 c8                	mov    %ecx,%eax
  8032dc:	f7 f5                	div    %ebp
  8032de:	89 c1                	mov    %eax,%ecx
  8032e0:	89 d8                	mov    %ebx,%eax
  8032e2:	f7 f5                	div    %ebp
  8032e4:	89 cf                	mov    %ecx,%edi
  8032e6:	89 fa                	mov    %edi,%edx
  8032e8:	83 c4 1c             	add    $0x1c,%esp
  8032eb:	5b                   	pop    %ebx
  8032ec:	5e                   	pop    %esi
  8032ed:	5f                   	pop    %edi
  8032ee:	5d                   	pop    %ebp
  8032ef:	c3                   	ret    
  8032f0:	39 ce                	cmp    %ecx,%esi
  8032f2:	77 28                	ja     80331c <__udivdi3+0x7c>
  8032f4:	0f bd fe             	bsr    %esi,%edi
  8032f7:	83 f7 1f             	xor    $0x1f,%edi
  8032fa:	75 40                	jne    80333c <__udivdi3+0x9c>
  8032fc:	39 ce                	cmp    %ecx,%esi
  8032fe:	72 0a                	jb     80330a <__udivdi3+0x6a>
  803300:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803304:	0f 87 9e 00 00 00    	ja     8033a8 <__udivdi3+0x108>
  80330a:	b8 01 00 00 00       	mov    $0x1,%eax
  80330f:	89 fa                	mov    %edi,%edx
  803311:	83 c4 1c             	add    $0x1c,%esp
  803314:	5b                   	pop    %ebx
  803315:	5e                   	pop    %esi
  803316:	5f                   	pop    %edi
  803317:	5d                   	pop    %ebp
  803318:	c3                   	ret    
  803319:	8d 76 00             	lea    0x0(%esi),%esi
  80331c:	31 ff                	xor    %edi,%edi
  80331e:	31 c0                	xor    %eax,%eax
  803320:	89 fa                	mov    %edi,%edx
  803322:	83 c4 1c             	add    $0x1c,%esp
  803325:	5b                   	pop    %ebx
  803326:	5e                   	pop    %esi
  803327:	5f                   	pop    %edi
  803328:	5d                   	pop    %ebp
  803329:	c3                   	ret    
  80332a:	66 90                	xchg   %ax,%ax
  80332c:	89 d8                	mov    %ebx,%eax
  80332e:	f7 f7                	div    %edi
  803330:	31 ff                	xor    %edi,%edi
  803332:	89 fa                	mov    %edi,%edx
  803334:	83 c4 1c             	add    $0x1c,%esp
  803337:	5b                   	pop    %ebx
  803338:	5e                   	pop    %esi
  803339:	5f                   	pop    %edi
  80333a:	5d                   	pop    %ebp
  80333b:	c3                   	ret    
  80333c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803341:	89 eb                	mov    %ebp,%ebx
  803343:	29 fb                	sub    %edi,%ebx
  803345:	89 f9                	mov    %edi,%ecx
  803347:	d3 e6                	shl    %cl,%esi
  803349:	89 c5                	mov    %eax,%ebp
  80334b:	88 d9                	mov    %bl,%cl
  80334d:	d3 ed                	shr    %cl,%ebp
  80334f:	89 e9                	mov    %ebp,%ecx
  803351:	09 f1                	or     %esi,%ecx
  803353:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803357:	89 f9                	mov    %edi,%ecx
  803359:	d3 e0                	shl    %cl,%eax
  80335b:	89 c5                	mov    %eax,%ebp
  80335d:	89 d6                	mov    %edx,%esi
  80335f:	88 d9                	mov    %bl,%cl
  803361:	d3 ee                	shr    %cl,%esi
  803363:	89 f9                	mov    %edi,%ecx
  803365:	d3 e2                	shl    %cl,%edx
  803367:	8b 44 24 08          	mov    0x8(%esp),%eax
  80336b:	88 d9                	mov    %bl,%cl
  80336d:	d3 e8                	shr    %cl,%eax
  80336f:	09 c2                	or     %eax,%edx
  803371:	89 d0                	mov    %edx,%eax
  803373:	89 f2                	mov    %esi,%edx
  803375:	f7 74 24 0c          	divl   0xc(%esp)
  803379:	89 d6                	mov    %edx,%esi
  80337b:	89 c3                	mov    %eax,%ebx
  80337d:	f7 e5                	mul    %ebp
  80337f:	39 d6                	cmp    %edx,%esi
  803381:	72 19                	jb     80339c <__udivdi3+0xfc>
  803383:	74 0b                	je     803390 <__udivdi3+0xf0>
  803385:	89 d8                	mov    %ebx,%eax
  803387:	31 ff                	xor    %edi,%edi
  803389:	e9 58 ff ff ff       	jmp    8032e6 <__udivdi3+0x46>
  80338e:	66 90                	xchg   %ax,%ax
  803390:	8b 54 24 08          	mov    0x8(%esp),%edx
  803394:	89 f9                	mov    %edi,%ecx
  803396:	d3 e2                	shl    %cl,%edx
  803398:	39 c2                	cmp    %eax,%edx
  80339a:	73 e9                	jae    803385 <__udivdi3+0xe5>
  80339c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80339f:	31 ff                	xor    %edi,%edi
  8033a1:	e9 40 ff ff ff       	jmp    8032e6 <__udivdi3+0x46>
  8033a6:	66 90                	xchg   %ax,%ax
  8033a8:	31 c0                	xor    %eax,%eax
  8033aa:	e9 37 ff ff ff       	jmp    8032e6 <__udivdi3+0x46>
  8033af:	90                   	nop

008033b0 <__umoddi3>:
  8033b0:	55                   	push   %ebp
  8033b1:	57                   	push   %edi
  8033b2:	56                   	push   %esi
  8033b3:	53                   	push   %ebx
  8033b4:	83 ec 1c             	sub    $0x1c,%esp
  8033b7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8033bb:	8b 74 24 34          	mov    0x34(%esp),%esi
  8033bf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8033c3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8033c7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8033cb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8033cf:	89 f3                	mov    %esi,%ebx
  8033d1:	89 fa                	mov    %edi,%edx
  8033d3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8033d7:	89 34 24             	mov    %esi,(%esp)
  8033da:	85 c0                	test   %eax,%eax
  8033dc:	75 1a                	jne    8033f8 <__umoddi3+0x48>
  8033de:	39 f7                	cmp    %esi,%edi
  8033e0:	0f 86 a2 00 00 00    	jbe    803488 <__umoddi3+0xd8>
  8033e6:	89 c8                	mov    %ecx,%eax
  8033e8:	89 f2                	mov    %esi,%edx
  8033ea:	f7 f7                	div    %edi
  8033ec:	89 d0                	mov    %edx,%eax
  8033ee:	31 d2                	xor    %edx,%edx
  8033f0:	83 c4 1c             	add    $0x1c,%esp
  8033f3:	5b                   	pop    %ebx
  8033f4:	5e                   	pop    %esi
  8033f5:	5f                   	pop    %edi
  8033f6:	5d                   	pop    %ebp
  8033f7:	c3                   	ret    
  8033f8:	39 f0                	cmp    %esi,%eax
  8033fa:	0f 87 ac 00 00 00    	ja     8034ac <__umoddi3+0xfc>
  803400:	0f bd e8             	bsr    %eax,%ebp
  803403:	83 f5 1f             	xor    $0x1f,%ebp
  803406:	0f 84 ac 00 00 00    	je     8034b8 <__umoddi3+0x108>
  80340c:	bf 20 00 00 00       	mov    $0x20,%edi
  803411:	29 ef                	sub    %ebp,%edi
  803413:	89 fe                	mov    %edi,%esi
  803415:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803419:	89 e9                	mov    %ebp,%ecx
  80341b:	d3 e0                	shl    %cl,%eax
  80341d:	89 d7                	mov    %edx,%edi
  80341f:	89 f1                	mov    %esi,%ecx
  803421:	d3 ef                	shr    %cl,%edi
  803423:	09 c7                	or     %eax,%edi
  803425:	89 e9                	mov    %ebp,%ecx
  803427:	d3 e2                	shl    %cl,%edx
  803429:	89 14 24             	mov    %edx,(%esp)
  80342c:	89 d8                	mov    %ebx,%eax
  80342e:	d3 e0                	shl    %cl,%eax
  803430:	89 c2                	mov    %eax,%edx
  803432:	8b 44 24 08          	mov    0x8(%esp),%eax
  803436:	d3 e0                	shl    %cl,%eax
  803438:	89 44 24 04          	mov    %eax,0x4(%esp)
  80343c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803440:	89 f1                	mov    %esi,%ecx
  803442:	d3 e8                	shr    %cl,%eax
  803444:	09 d0                	or     %edx,%eax
  803446:	d3 eb                	shr    %cl,%ebx
  803448:	89 da                	mov    %ebx,%edx
  80344a:	f7 f7                	div    %edi
  80344c:	89 d3                	mov    %edx,%ebx
  80344e:	f7 24 24             	mull   (%esp)
  803451:	89 c6                	mov    %eax,%esi
  803453:	89 d1                	mov    %edx,%ecx
  803455:	39 d3                	cmp    %edx,%ebx
  803457:	0f 82 87 00 00 00    	jb     8034e4 <__umoddi3+0x134>
  80345d:	0f 84 91 00 00 00    	je     8034f4 <__umoddi3+0x144>
  803463:	8b 54 24 04          	mov    0x4(%esp),%edx
  803467:	29 f2                	sub    %esi,%edx
  803469:	19 cb                	sbb    %ecx,%ebx
  80346b:	89 d8                	mov    %ebx,%eax
  80346d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803471:	d3 e0                	shl    %cl,%eax
  803473:	89 e9                	mov    %ebp,%ecx
  803475:	d3 ea                	shr    %cl,%edx
  803477:	09 d0                	or     %edx,%eax
  803479:	89 e9                	mov    %ebp,%ecx
  80347b:	d3 eb                	shr    %cl,%ebx
  80347d:	89 da                	mov    %ebx,%edx
  80347f:	83 c4 1c             	add    $0x1c,%esp
  803482:	5b                   	pop    %ebx
  803483:	5e                   	pop    %esi
  803484:	5f                   	pop    %edi
  803485:	5d                   	pop    %ebp
  803486:	c3                   	ret    
  803487:	90                   	nop
  803488:	89 fd                	mov    %edi,%ebp
  80348a:	85 ff                	test   %edi,%edi
  80348c:	75 0b                	jne    803499 <__umoddi3+0xe9>
  80348e:	b8 01 00 00 00       	mov    $0x1,%eax
  803493:	31 d2                	xor    %edx,%edx
  803495:	f7 f7                	div    %edi
  803497:	89 c5                	mov    %eax,%ebp
  803499:	89 f0                	mov    %esi,%eax
  80349b:	31 d2                	xor    %edx,%edx
  80349d:	f7 f5                	div    %ebp
  80349f:	89 c8                	mov    %ecx,%eax
  8034a1:	f7 f5                	div    %ebp
  8034a3:	89 d0                	mov    %edx,%eax
  8034a5:	e9 44 ff ff ff       	jmp    8033ee <__umoddi3+0x3e>
  8034aa:	66 90                	xchg   %ax,%ax
  8034ac:	89 c8                	mov    %ecx,%eax
  8034ae:	89 f2                	mov    %esi,%edx
  8034b0:	83 c4 1c             	add    $0x1c,%esp
  8034b3:	5b                   	pop    %ebx
  8034b4:	5e                   	pop    %esi
  8034b5:	5f                   	pop    %edi
  8034b6:	5d                   	pop    %ebp
  8034b7:	c3                   	ret    
  8034b8:	3b 04 24             	cmp    (%esp),%eax
  8034bb:	72 06                	jb     8034c3 <__umoddi3+0x113>
  8034bd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8034c1:	77 0f                	ja     8034d2 <__umoddi3+0x122>
  8034c3:	89 f2                	mov    %esi,%edx
  8034c5:	29 f9                	sub    %edi,%ecx
  8034c7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8034cb:	89 14 24             	mov    %edx,(%esp)
  8034ce:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8034d2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8034d6:	8b 14 24             	mov    (%esp),%edx
  8034d9:	83 c4 1c             	add    $0x1c,%esp
  8034dc:	5b                   	pop    %ebx
  8034dd:	5e                   	pop    %esi
  8034de:	5f                   	pop    %edi
  8034df:	5d                   	pop    %ebp
  8034e0:	c3                   	ret    
  8034e1:	8d 76 00             	lea    0x0(%esi),%esi
  8034e4:	2b 04 24             	sub    (%esp),%eax
  8034e7:	19 fa                	sbb    %edi,%edx
  8034e9:	89 d1                	mov    %edx,%ecx
  8034eb:	89 c6                	mov    %eax,%esi
  8034ed:	e9 71 ff ff ff       	jmp    803463 <__umoddi3+0xb3>
  8034f2:	66 90                	xchg   %ax,%ax
  8034f4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8034f8:	72 ea                	jb     8034e4 <__umoddi3+0x134>
  8034fa:	89 d9                	mov    %ebx,%ecx
  8034fc:	e9 62 ff ff ff       	jmp    803463 <__umoddi3+0xb3>
