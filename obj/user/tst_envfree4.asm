
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
  800045:	68 a0 35 80 00       	push   $0x8035a0
  80004a:	e8 b4 14 00 00       	call   801503 <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*numOfFinished = 0 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int freeFrames_before = sys_calculate_free_frames() ;
  80005e:	e8 05 17 00 00       	call   801768 <sys_calculate_free_frames>
  800063:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800066:	e8 9d 17 00 00       	call   801808 <sys_pf_calculate_allocated_pages>
  80006b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80006e:	83 ec 08             	sub    $0x8,%esp
  800071:	ff 75 f0             	pushl  -0x10(%ebp)
  800074:	68 b0 35 80 00       	push   $0x8035b0
  800079:	e8 b5 04 00 00       	call   800533 <cprintf>
  80007e:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tsem1", 100,(myEnv->SecondListSize), 50);
  800081:	a1 20 40 80 00       	mov    0x804020,%eax
  800086:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80008c:	6a 32                	push   $0x32
  80008e:	50                   	push   %eax
  80008f:	6a 64                	push   $0x64
  800091:	68 e3 35 80 00       	push   $0x8035e3
  800096:	e8 3f 19 00 00       	call   8019da <sys_create_env>
  80009b:	83 c4 10             	add    $0x10,%esp
  80009e:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sys_run_env(envIdProcessA);
  8000a1:	83 ec 0c             	sub    $0xc,%esp
  8000a4:	ff 75 e8             	pushl  -0x18(%ebp)
  8000a7:	e8 4c 19 00 00       	call   8019f8 <sys_run_env>
  8000ac:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 1) ;
  8000af:	90                   	nop
  8000b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000b3:	8b 00                	mov    (%eax),%eax
  8000b5:	83 f8 01             	cmp    $0x1,%eax
  8000b8:	75 f6                	jne    8000b0 <_main+0x78>
	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  8000ba:	e8 a9 16 00 00       	call   801768 <sys_calculate_free_frames>
  8000bf:	83 ec 08             	sub    $0x8,%esp
  8000c2:	50                   	push   %eax
  8000c3:	68 ec 35 80 00       	push   $0x8035ec
  8000c8:	e8 66 04 00 00       	call   800533 <cprintf>
  8000cd:	83 c4 10             	add    $0x10,%esp

	sys_destroy_env(envIdProcessA);
  8000d0:	83 ec 0c             	sub    $0xc,%esp
  8000d3:	ff 75 e8             	pushl  -0x18(%ebp)
  8000d6:	e8 39 19 00 00       	call   801a14 <sys_destroy_env>
  8000db:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  8000de:	e8 85 16 00 00       	call   801768 <sys_calculate_free_frames>
  8000e3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  8000e6:	e8 1d 17 00 00       	call   801808 <sys_pf_calculate_allocated_pages>
  8000eb:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if ((freeFrames_after - freeFrames_before) != 0) {
  8000ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000f1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8000f4:	74 27                	je     80011d <_main+0xe5>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\n",
  8000f6:	83 ec 08             	sub    $0x8,%esp
  8000f9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000fc:	68 20 36 80 00       	push   $0x803620
  800101:	e8 2d 04 00 00       	call   800533 <cprintf>
  800106:	83 c4 10             	add    $0x10,%esp
				freeFrames_after);
		panic("env_free() does not work correctly... check it again.");
  800109:	83 ec 04             	sub    $0x4,%esp
  80010c:	68 70 36 80 00       	push   $0x803670
  800111:	6a 1f                	push   $0x1f
  800113:	68 a6 36 80 00       	push   $0x8036a6
  800118:	e8 62 01 00 00       	call   80027f <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  80011d:	83 ec 08             	sub    $0x8,%esp
  800120:	ff 75 e4             	pushl  -0x1c(%ebp)
  800123:	68 bc 36 80 00       	push   $0x8036bc
  800128:	e8 06 04 00 00       	call   800533 <cprintf>
  80012d:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 4 for envfree completed successfully.\n");
  800130:	83 ec 0c             	sub    $0xc,%esp
  800133:	68 1c 37 80 00       	push   $0x80371c
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
  800149:	e8 fa 18 00 00       	call   801a48 <sys_getenvindex>
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
  8001b4:	e8 9c 16 00 00       	call   801855 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001b9:	83 ec 0c             	sub    $0xc,%esp
  8001bc:	68 80 37 80 00       	push   $0x803780
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
  8001e4:	68 a8 37 80 00       	push   $0x8037a8
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
  800215:	68 d0 37 80 00       	push   $0x8037d0
  80021a:	e8 14 03 00 00       	call   800533 <cprintf>
  80021f:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800222:	a1 20 40 80 00       	mov    0x804020,%eax
  800227:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80022d:	83 ec 08             	sub    $0x8,%esp
  800230:	50                   	push   %eax
  800231:	68 28 38 80 00       	push   $0x803828
  800236:	e8 f8 02 00 00       	call   800533 <cprintf>
  80023b:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80023e:	83 ec 0c             	sub    $0xc,%esp
  800241:	68 80 37 80 00       	push   $0x803780
  800246:	e8 e8 02 00 00       	call   800533 <cprintf>
  80024b:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80024e:	e8 1c 16 00 00       	call   80186f <sys_enable_interrupt>

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
  800266:	e8 a9 17 00 00       	call   801a14 <sys_destroy_env>
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
  800277:	e8 fe 17 00 00       	call   801a7a <sys_exit_env>
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
  8002a0:	68 3c 38 80 00       	push   $0x80383c
  8002a5:	e8 89 02 00 00       	call   800533 <cprintf>
  8002aa:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002ad:	a1 00 40 80 00       	mov    0x804000,%eax
  8002b2:	ff 75 0c             	pushl  0xc(%ebp)
  8002b5:	ff 75 08             	pushl  0x8(%ebp)
  8002b8:	50                   	push   %eax
  8002b9:	68 41 38 80 00       	push   $0x803841
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
  8002dd:	68 5d 38 80 00       	push   $0x80385d
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
  800309:	68 60 38 80 00       	push   $0x803860
  80030e:	6a 26                	push   $0x26
  800310:	68 ac 38 80 00       	push   $0x8038ac
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
  8003db:	68 b8 38 80 00       	push   $0x8038b8
  8003e0:	6a 3a                	push   $0x3a
  8003e2:	68 ac 38 80 00       	push   $0x8038ac
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
  80044b:	68 0c 39 80 00       	push   $0x80390c
  800450:	6a 44                	push   $0x44
  800452:	68 ac 38 80 00       	push   $0x8038ac
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
  8004a5:	e8 fd 11 00 00       	call   8016a7 <sys_cputs>
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
  80051c:	e8 86 11 00 00       	call   8016a7 <sys_cputs>
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
  800566:	e8 ea 12 00 00       	call   801855 <sys_disable_interrupt>
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
  800586:	e8 e4 12 00 00       	call   80186f <sys_enable_interrupt>
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
  8005d0:	e8 57 2d 00 00       	call   80332c <__udivdi3>
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
  800620:	e8 17 2e 00 00       	call   80343c <__umoddi3>
  800625:	83 c4 10             	add    $0x10,%esp
  800628:	05 74 3b 80 00       	add    $0x803b74,%eax
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
  80077b:	8b 04 85 98 3b 80 00 	mov    0x803b98(,%eax,4),%eax
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
  80085c:	8b 34 9d e0 39 80 00 	mov    0x8039e0(,%ebx,4),%esi
  800863:	85 f6                	test   %esi,%esi
  800865:	75 19                	jne    800880 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800867:	53                   	push   %ebx
  800868:	68 85 3b 80 00       	push   $0x803b85
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
  800881:	68 8e 3b 80 00       	push   $0x803b8e
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
  8008ae:	be 91 3b 80 00       	mov    $0x803b91,%esi
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
  8012d4:	68 f0 3c 80 00       	push   $0x803cf0
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
  8013a4:	e8 42 04 00 00       	call   8017eb <sys_allocate_chunk>
  8013a9:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013ac:	a1 20 41 80 00       	mov    0x804120,%eax
  8013b1:	83 ec 0c             	sub    $0xc,%esp
  8013b4:	50                   	push   %eax
  8013b5:	e8 b7 0a 00 00       	call   801e71 <initialize_MemBlocksList>
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
  8013e2:	68 15 3d 80 00       	push   $0x803d15
  8013e7:	6a 33                	push   $0x33
  8013e9:	68 33 3d 80 00       	push   $0x803d33
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
  801461:	68 40 3d 80 00       	push   $0x803d40
  801466:	6a 34                	push   $0x34
  801468:	68 33 3d 80 00       	push   $0x803d33
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
  8014d6:	68 64 3d 80 00       	push   $0x803d64
  8014db:	6a 46                	push   $0x46
  8014dd:	68 33 3d 80 00       	push   $0x803d33
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
  8014f2:	68 8c 3d 80 00       	push   $0x803d8c
  8014f7:	6a 61                	push   $0x61
  8014f9:	68 33 3d 80 00       	push   $0x803d33
  8014fe:	e8 7c ed ff ff       	call   80027f <_panic>

00801503 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801503:	55                   	push   %ebp
  801504:	89 e5                	mov    %esp,%ebp
  801506:	83 ec 38             	sub    $0x38,%esp
  801509:	8b 45 10             	mov    0x10(%ebp),%eax
  80150c:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80150f:	e8 a9 fd ff ff       	call   8012bd <InitializeUHeap>
	if (size == 0) return NULL ;
  801514:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801518:	75 0a                	jne    801524 <smalloc+0x21>
  80151a:	b8 00 00 00 00       	mov    $0x0,%eax
  80151f:	e9 9e 00 00 00       	jmp    8015c2 <smalloc+0xbf>
	//3-If the Kernel successfully creates the shared variable, return its virtual address
	//4-Else, return NULL



	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801524:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80152b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80152e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801531:	01 d0                	add    %edx,%eax
  801533:	48                   	dec    %eax
  801534:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801537:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80153a:	ba 00 00 00 00       	mov    $0x0,%edx
  80153f:	f7 75 f0             	divl   -0x10(%ebp)
  801542:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801545:	29 d0                	sub    %edx,%eax
  801547:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  80154a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801551:	e8 63 06 00 00       	call   801bb9 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801556:	85 c0                	test   %eax,%eax
  801558:	74 11                	je     80156b <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  80155a:	83 ec 0c             	sub    $0xc,%esp
  80155d:	ff 75 e8             	pushl  -0x18(%ebp)
  801560:	e8 ce 0c 00 00       	call   802233 <alloc_block_FF>
  801565:	83 c4 10             	add    $0x10,%esp
  801568:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  80156b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80156f:	74 4c                	je     8015bd <smalloc+0xba>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801571:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801574:	8b 40 08             	mov    0x8(%eax),%eax
  801577:	89 c2                	mov    %eax,%edx
  801579:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  80157d:	52                   	push   %edx
  80157e:	50                   	push   %eax
  80157f:	ff 75 0c             	pushl  0xc(%ebp)
  801582:	ff 75 08             	pushl  0x8(%ebp)
  801585:	e8 b4 03 00 00       	call   80193e <sys_createSharedObject>
  80158a:	83 c4 10             	add    $0x10,%esp
  80158d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cprintf("Output is :  %d \n" , result);
  801590:	83 ec 08             	sub    $0x8,%esp
  801593:	ff 75 e0             	pushl  -0x20(%ebp)
  801596:	68 af 3d 80 00       	push   $0x803daf
  80159b:	e8 93 ef ff ff       	call   800533 <cprintf>
  8015a0:	83 c4 10             	add    $0x10,%esp
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  8015a3:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  8015a7:	74 14                	je     8015bd <smalloc+0xba>
  8015a9:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  8015ad:	74 0e                	je     8015bd <smalloc+0xba>
  8015af:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  8015b3:	74 08                	je     8015bd <smalloc+0xba>
			return (void*) mem_block->sva;
  8015b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015b8:	8b 40 08             	mov    0x8(%eax),%eax
  8015bb:	eb 05                	jmp    8015c2 <smalloc+0xbf>
	}
	return NULL;
  8015bd:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8015c2:	c9                   	leave  
  8015c3:	c3                   	ret    

008015c4 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8015c4:	55                   	push   %ebp
  8015c5:	89 e5                	mov    %esp,%ebp
  8015c7:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015ca:	e8 ee fc ff ff       	call   8012bd <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8015cf:	83 ec 04             	sub    $0x4,%esp
  8015d2:	68 c4 3d 80 00       	push   $0x803dc4
  8015d7:	68 ab 00 00 00       	push   $0xab
  8015dc:	68 33 3d 80 00       	push   $0x803d33
  8015e1:	e8 99 ec ff ff       	call   80027f <_panic>

008015e6 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8015e6:	55                   	push   %ebp
  8015e7:	89 e5                	mov    %esp,%ebp
  8015e9:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015ec:	e8 cc fc ff ff       	call   8012bd <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8015f1:	83 ec 04             	sub    $0x4,%esp
  8015f4:	68 e8 3d 80 00       	push   $0x803de8
  8015f9:	68 ef 00 00 00       	push   $0xef
  8015fe:	68 33 3d 80 00       	push   $0x803d33
  801603:	e8 77 ec ff ff       	call   80027f <_panic>

00801608 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801608:	55                   	push   %ebp
  801609:	89 e5                	mov    %esp,%ebp
  80160b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80160e:	83 ec 04             	sub    $0x4,%esp
  801611:	68 10 3e 80 00       	push   $0x803e10
  801616:	68 03 01 00 00       	push   $0x103
  80161b:	68 33 3d 80 00       	push   $0x803d33
  801620:	e8 5a ec ff ff       	call   80027f <_panic>

00801625 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801625:	55                   	push   %ebp
  801626:	89 e5                	mov    %esp,%ebp
  801628:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80162b:	83 ec 04             	sub    $0x4,%esp
  80162e:	68 34 3e 80 00       	push   $0x803e34
  801633:	68 0e 01 00 00       	push   $0x10e
  801638:	68 33 3d 80 00       	push   $0x803d33
  80163d:	e8 3d ec ff ff       	call   80027f <_panic>

00801642 <shrink>:

}
void shrink(uint32 newSize)
{
  801642:	55                   	push   %ebp
  801643:	89 e5                	mov    %esp,%ebp
  801645:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801648:	83 ec 04             	sub    $0x4,%esp
  80164b:	68 34 3e 80 00       	push   $0x803e34
  801650:	68 13 01 00 00       	push   $0x113
  801655:	68 33 3d 80 00       	push   $0x803d33
  80165a:	e8 20 ec ff ff       	call   80027f <_panic>

0080165f <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80165f:	55                   	push   %ebp
  801660:	89 e5                	mov    %esp,%ebp
  801662:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801665:	83 ec 04             	sub    $0x4,%esp
  801668:	68 34 3e 80 00       	push   $0x803e34
  80166d:	68 18 01 00 00       	push   $0x118
  801672:	68 33 3d 80 00       	push   $0x803d33
  801677:	e8 03 ec ff ff       	call   80027f <_panic>

0080167c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80167c:	55                   	push   %ebp
  80167d:	89 e5                	mov    %esp,%ebp
  80167f:	57                   	push   %edi
  801680:	56                   	push   %esi
  801681:	53                   	push   %ebx
  801682:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801685:	8b 45 08             	mov    0x8(%ebp),%eax
  801688:	8b 55 0c             	mov    0xc(%ebp),%edx
  80168b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80168e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801691:	8b 7d 18             	mov    0x18(%ebp),%edi
  801694:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801697:	cd 30                	int    $0x30
  801699:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80169c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80169f:	83 c4 10             	add    $0x10,%esp
  8016a2:	5b                   	pop    %ebx
  8016a3:	5e                   	pop    %esi
  8016a4:	5f                   	pop    %edi
  8016a5:	5d                   	pop    %ebp
  8016a6:	c3                   	ret    

008016a7 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8016a7:	55                   	push   %ebp
  8016a8:	89 e5                	mov    %esp,%ebp
  8016aa:	83 ec 04             	sub    $0x4,%esp
  8016ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8016b3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8016b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ba:	6a 00                	push   $0x0
  8016bc:	6a 00                	push   $0x0
  8016be:	52                   	push   %edx
  8016bf:	ff 75 0c             	pushl  0xc(%ebp)
  8016c2:	50                   	push   %eax
  8016c3:	6a 00                	push   $0x0
  8016c5:	e8 b2 ff ff ff       	call   80167c <syscall>
  8016ca:	83 c4 18             	add    $0x18,%esp
}
  8016cd:	90                   	nop
  8016ce:	c9                   	leave  
  8016cf:	c3                   	ret    

008016d0 <sys_cgetc>:

int
sys_cgetc(void)
{
  8016d0:	55                   	push   %ebp
  8016d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8016d3:	6a 00                	push   $0x0
  8016d5:	6a 00                	push   $0x0
  8016d7:	6a 00                	push   $0x0
  8016d9:	6a 00                	push   $0x0
  8016db:	6a 00                	push   $0x0
  8016dd:	6a 01                	push   $0x1
  8016df:	e8 98 ff ff ff       	call   80167c <syscall>
  8016e4:	83 c4 18             	add    $0x18,%esp
}
  8016e7:	c9                   	leave  
  8016e8:	c3                   	ret    

008016e9 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8016e9:	55                   	push   %ebp
  8016ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8016ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f2:	6a 00                	push   $0x0
  8016f4:	6a 00                	push   $0x0
  8016f6:	6a 00                	push   $0x0
  8016f8:	52                   	push   %edx
  8016f9:	50                   	push   %eax
  8016fa:	6a 05                	push   $0x5
  8016fc:	e8 7b ff ff ff       	call   80167c <syscall>
  801701:	83 c4 18             	add    $0x18,%esp
}
  801704:	c9                   	leave  
  801705:	c3                   	ret    

00801706 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801706:	55                   	push   %ebp
  801707:	89 e5                	mov    %esp,%ebp
  801709:	56                   	push   %esi
  80170a:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80170b:	8b 75 18             	mov    0x18(%ebp),%esi
  80170e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801711:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801714:	8b 55 0c             	mov    0xc(%ebp),%edx
  801717:	8b 45 08             	mov    0x8(%ebp),%eax
  80171a:	56                   	push   %esi
  80171b:	53                   	push   %ebx
  80171c:	51                   	push   %ecx
  80171d:	52                   	push   %edx
  80171e:	50                   	push   %eax
  80171f:	6a 06                	push   $0x6
  801721:	e8 56 ff ff ff       	call   80167c <syscall>
  801726:	83 c4 18             	add    $0x18,%esp
}
  801729:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80172c:	5b                   	pop    %ebx
  80172d:	5e                   	pop    %esi
  80172e:	5d                   	pop    %ebp
  80172f:	c3                   	ret    

00801730 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801730:	55                   	push   %ebp
  801731:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801733:	8b 55 0c             	mov    0xc(%ebp),%edx
  801736:	8b 45 08             	mov    0x8(%ebp),%eax
  801739:	6a 00                	push   $0x0
  80173b:	6a 00                	push   $0x0
  80173d:	6a 00                	push   $0x0
  80173f:	52                   	push   %edx
  801740:	50                   	push   %eax
  801741:	6a 07                	push   $0x7
  801743:	e8 34 ff ff ff       	call   80167c <syscall>
  801748:	83 c4 18             	add    $0x18,%esp
}
  80174b:	c9                   	leave  
  80174c:	c3                   	ret    

0080174d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80174d:	55                   	push   %ebp
  80174e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801750:	6a 00                	push   $0x0
  801752:	6a 00                	push   $0x0
  801754:	6a 00                	push   $0x0
  801756:	ff 75 0c             	pushl  0xc(%ebp)
  801759:	ff 75 08             	pushl  0x8(%ebp)
  80175c:	6a 08                	push   $0x8
  80175e:	e8 19 ff ff ff       	call   80167c <syscall>
  801763:	83 c4 18             	add    $0x18,%esp
}
  801766:	c9                   	leave  
  801767:	c3                   	ret    

00801768 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801768:	55                   	push   %ebp
  801769:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80176b:	6a 00                	push   $0x0
  80176d:	6a 00                	push   $0x0
  80176f:	6a 00                	push   $0x0
  801771:	6a 00                	push   $0x0
  801773:	6a 00                	push   $0x0
  801775:	6a 09                	push   $0x9
  801777:	e8 00 ff ff ff       	call   80167c <syscall>
  80177c:	83 c4 18             	add    $0x18,%esp
}
  80177f:	c9                   	leave  
  801780:	c3                   	ret    

00801781 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801781:	55                   	push   %ebp
  801782:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801784:	6a 00                	push   $0x0
  801786:	6a 00                	push   $0x0
  801788:	6a 00                	push   $0x0
  80178a:	6a 00                	push   $0x0
  80178c:	6a 00                	push   $0x0
  80178e:	6a 0a                	push   $0xa
  801790:	e8 e7 fe ff ff       	call   80167c <syscall>
  801795:	83 c4 18             	add    $0x18,%esp
}
  801798:	c9                   	leave  
  801799:	c3                   	ret    

0080179a <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80179a:	55                   	push   %ebp
  80179b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80179d:	6a 00                	push   $0x0
  80179f:	6a 00                	push   $0x0
  8017a1:	6a 00                	push   $0x0
  8017a3:	6a 00                	push   $0x0
  8017a5:	6a 00                	push   $0x0
  8017a7:	6a 0b                	push   $0xb
  8017a9:	e8 ce fe ff ff       	call   80167c <syscall>
  8017ae:	83 c4 18             	add    $0x18,%esp
}
  8017b1:	c9                   	leave  
  8017b2:	c3                   	ret    

008017b3 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8017b3:	55                   	push   %ebp
  8017b4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8017b6:	6a 00                	push   $0x0
  8017b8:	6a 00                	push   $0x0
  8017ba:	6a 00                	push   $0x0
  8017bc:	ff 75 0c             	pushl  0xc(%ebp)
  8017bf:	ff 75 08             	pushl  0x8(%ebp)
  8017c2:	6a 0f                	push   $0xf
  8017c4:	e8 b3 fe ff ff       	call   80167c <syscall>
  8017c9:	83 c4 18             	add    $0x18,%esp
	return;
  8017cc:	90                   	nop
}
  8017cd:	c9                   	leave  
  8017ce:	c3                   	ret    

008017cf <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8017cf:	55                   	push   %ebp
  8017d0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8017d2:	6a 00                	push   $0x0
  8017d4:	6a 00                	push   $0x0
  8017d6:	6a 00                	push   $0x0
  8017d8:	ff 75 0c             	pushl  0xc(%ebp)
  8017db:	ff 75 08             	pushl  0x8(%ebp)
  8017de:	6a 10                	push   $0x10
  8017e0:	e8 97 fe ff ff       	call   80167c <syscall>
  8017e5:	83 c4 18             	add    $0x18,%esp
	return ;
  8017e8:	90                   	nop
}
  8017e9:	c9                   	leave  
  8017ea:	c3                   	ret    

008017eb <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8017eb:	55                   	push   %ebp
  8017ec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8017ee:	6a 00                	push   $0x0
  8017f0:	6a 00                	push   $0x0
  8017f2:	ff 75 10             	pushl  0x10(%ebp)
  8017f5:	ff 75 0c             	pushl  0xc(%ebp)
  8017f8:	ff 75 08             	pushl  0x8(%ebp)
  8017fb:	6a 11                	push   $0x11
  8017fd:	e8 7a fe ff ff       	call   80167c <syscall>
  801802:	83 c4 18             	add    $0x18,%esp
	return ;
  801805:	90                   	nop
}
  801806:	c9                   	leave  
  801807:	c3                   	ret    

00801808 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801808:	55                   	push   %ebp
  801809:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80180b:	6a 00                	push   $0x0
  80180d:	6a 00                	push   $0x0
  80180f:	6a 00                	push   $0x0
  801811:	6a 00                	push   $0x0
  801813:	6a 00                	push   $0x0
  801815:	6a 0c                	push   $0xc
  801817:	e8 60 fe ff ff       	call   80167c <syscall>
  80181c:	83 c4 18             	add    $0x18,%esp
}
  80181f:	c9                   	leave  
  801820:	c3                   	ret    

00801821 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801821:	55                   	push   %ebp
  801822:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801824:	6a 00                	push   $0x0
  801826:	6a 00                	push   $0x0
  801828:	6a 00                	push   $0x0
  80182a:	6a 00                	push   $0x0
  80182c:	ff 75 08             	pushl  0x8(%ebp)
  80182f:	6a 0d                	push   $0xd
  801831:	e8 46 fe ff ff       	call   80167c <syscall>
  801836:	83 c4 18             	add    $0x18,%esp
}
  801839:	c9                   	leave  
  80183a:	c3                   	ret    

0080183b <sys_scarce_memory>:

void sys_scarce_memory()
{
  80183b:	55                   	push   %ebp
  80183c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80183e:	6a 00                	push   $0x0
  801840:	6a 00                	push   $0x0
  801842:	6a 00                	push   $0x0
  801844:	6a 00                	push   $0x0
  801846:	6a 00                	push   $0x0
  801848:	6a 0e                	push   $0xe
  80184a:	e8 2d fe ff ff       	call   80167c <syscall>
  80184f:	83 c4 18             	add    $0x18,%esp
}
  801852:	90                   	nop
  801853:	c9                   	leave  
  801854:	c3                   	ret    

00801855 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801855:	55                   	push   %ebp
  801856:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801858:	6a 00                	push   $0x0
  80185a:	6a 00                	push   $0x0
  80185c:	6a 00                	push   $0x0
  80185e:	6a 00                	push   $0x0
  801860:	6a 00                	push   $0x0
  801862:	6a 13                	push   $0x13
  801864:	e8 13 fe ff ff       	call   80167c <syscall>
  801869:	83 c4 18             	add    $0x18,%esp
}
  80186c:	90                   	nop
  80186d:	c9                   	leave  
  80186e:	c3                   	ret    

0080186f <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80186f:	55                   	push   %ebp
  801870:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801872:	6a 00                	push   $0x0
  801874:	6a 00                	push   $0x0
  801876:	6a 00                	push   $0x0
  801878:	6a 00                	push   $0x0
  80187a:	6a 00                	push   $0x0
  80187c:	6a 14                	push   $0x14
  80187e:	e8 f9 fd ff ff       	call   80167c <syscall>
  801883:	83 c4 18             	add    $0x18,%esp
}
  801886:	90                   	nop
  801887:	c9                   	leave  
  801888:	c3                   	ret    

00801889 <sys_cputc>:


void
sys_cputc(const char c)
{
  801889:	55                   	push   %ebp
  80188a:	89 e5                	mov    %esp,%ebp
  80188c:	83 ec 04             	sub    $0x4,%esp
  80188f:	8b 45 08             	mov    0x8(%ebp),%eax
  801892:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801895:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801899:	6a 00                	push   $0x0
  80189b:	6a 00                	push   $0x0
  80189d:	6a 00                	push   $0x0
  80189f:	6a 00                	push   $0x0
  8018a1:	50                   	push   %eax
  8018a2:	6a 15                	push   $0x15
  8018a4:	e8 d3 fd ff ff       	call   80167c <syscall>
  8018a9:	83 c4 18             	add    $0x18,%esp
}
  8018ac:	90                   	nop
  8018ad:	c9                   	leave  
  8018ae:	c3                   	ret    

008018af <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8018af:	55                   	push   %ebp
  8018b0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8018b2:	6a 00                	push   $0x0
  8018b4:	6a 00                	push   $0x0
  8018b6:	6a 00                	push   $0x0
  8018b8:	6a 00                	push   $0x0
  8018ba:	6a 00                	push   $0x0
  8018bc:	6a 16                	push   $0x16
  8018be:	e8 b9 fd ff ff       	call   80167c <syscall>
  8018c3:	83 c4 18             	add    $0x18,%esp
}
  8018c6:	90                   	nop
  8018c7:	c9                   	leave  
  8018c8:	c3                   	ret    

008018c9 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8018c9:	55                   	push   %ebp
  8018ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8018cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cf:	6a 00                	push   $0x0
  8018d1:	6a 00                	push   $0x0
  8018d3:	6a 00                	push   $0x0
  8018d5:	ff 75 0c             	pushl  0xc(%ebp)
  8018d8:	50                   	push   %eax
  8018d9:	6a 17                	push   $0x17
  8018db:	e8 9c fd ff ff       	call   80167c <syscall>
  8018e0:	83 c4 18             	add    $0x18,%esp
}
  8018e3:	c9                   	leave  
  8018e4:	c3                   	ret    

008018e5 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8018e5:	55                   	push   %ebp
  8018e6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ee:	6a 00                	push   $0x0
  8018f0:	6a 00                	push   $0x0
  8018f2:	6a 00                	push   $0x0
  8018f4:	52                   	push   %edx
  8018f5:	50                   	push   %eax
  8018f6:	6a 1a                	push   $0x1a
  8018f8:	e8 7f fd ff ff       	call   80167c <syscall>
  8018fd:	83 c4 18             	add    $0x18,%esp
}
  801900:	c9                   	leave  
  801901:	c3                   	ret    

00801902 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801902:	55                   	push   %ebp
  801903:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801905:	8b 55 0c             	mov    0xc(%ebp),%edx
  801908:	8b 45 08             	mov    0x8(%ebp),%eax
  80190b:	6a 00                	push   $0x0
  80190d:	6a 00                	push   $0x0
  80190f:	6a 00                	push   $0x0
  801911:	52                   	push   %edx
  801912:	50                   	push   %eax
  801913:	6a 18                	push   $0x18
  801915:	e8 62 fd ff ff       	call   80167c <syscall>
  80191a:	83 c4 18             	add    $0x18,%esp
}
  80191d:	90                   	nop
  80191e:	c9                   	leave  
  80191f:	c3                   	ret    

00801920 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801920:	55                   	push   %ebp
  801921:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801923:	8b 55 0c             	mov    0xc(%ebp),%edx
  801926:	8b 45 08             	mov    0x8(%ebp),%eax
  801929:	6a 00                	push   $0x0
  80192b:	6a 00                	push   $0x0
  80192d:	6a 00                	push   $0x0
  80192f:	52                   	push   %edx
  801930:	50                   	push   %eax
  801931:	6a 19                	push   $0x19
  801933:	e8 44 fd ff ff       	call   80167c <syscall>
  801938:	83 c4 18             	add    $0x18,%esp
}
  80193b:	90                   	nop
  80193c:	c9                   	leave  
  80193d:	c3                   	ret    

0080193e <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80193e:	55                   	push   %ebp
  80193f:	89 e5                	mov    %esp,%ebp
  801941:	83 ec 04             	sub    $0x4,%esp
  801944:	8b 45 10             	mov    0x10(%ebp),%eax
  801947:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80194a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80194d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801951:	8b 45 08             	mov    0x8(%ebp),%eax
  801954:	6a 00                	push   $0x0
  801956:	51                   	push   %ecx
  801957:	52                   	push   %edx
  801958:	ff 75 0c             	pushl  0xc(%ebp)
  80195b:	50                   	push   %eax
  80195c:	6a 1b                	push   $0x1b
  80195e:	e8 19 fd ff ff       	call   80167c <syscall>
  801963:	83 c4 18             	add    $0x18,%esp
}
  801966:	c9                   	leave  
  801967:	c3                   	ret    

00801968 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801968:	55                   	push   %ebp
  801969:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80196b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80196e:	8b 45 08             	mov    0x8(%ebp),%eax
  801971:	6a 00                	push   $0x0
  801973:	6a 00                	push   $0x0
  801975:	6a 00                	push   $0x0
  801977:	52                   	push   %edx
  801978:	50                   	push   %eax
  801979:	6a 1c                	push   $0x1c
  80197b:	e8 fc fc ff ff       	call   80167c <syscall>
  801980:	83 c4 18             	add    $0x18,%esp
}
  801983:	c9                   	leave  
  801984:	c3                   	ret    

00801985 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801985:	55                   	push   %ebp
  801986:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801988:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80198b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80198e:	8b 45 08             	mov    0x8(%ebp),%eax
  801991:	6a 00                	push   $0x0
  801993:	6a 00                	push   $0x0
  801995:	51                   	push   %ecx
  801996:	52                   	push   %edx
  801997:	50                   	push   %eax
  801998:	6a 1d                	push   $0x1d
  80199a:	e8 dd fc ff ff       	call   80167c <syscall>
  80199f:	83 c4 18             	add    $0x18,%esp
}
  8019a2:	c9                   	leave  
  8019a3:	c3                   	ret    

008019a4 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8019a4:	55                   	push   %ebp
  8019a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8019a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ad:	6a 00                	push   $0x0
  8019af:	6a 00                	push   $0x0
  8019b1:	6a 00                	push   $0x0
  8019b3:	52                   	push   %edx
  8019b4:	50                   	push   %eax
  8019b5:	6a 1e                	push   $0x1e
  8019b7:	e8 c0 fc ff ff       	call   80167c <syscall>
  8019bc:	83 c4 18             	add    $0x18,%esp
}
  8019bf:	c9                   	leave  
  8019c0:	c3                   	ret    

008019c1 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8019c1:	55                   	push   %ebp
  8019c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8019c4:	6a 00                	push   $0x0
  8019c6:	6a 00                	push   $0x0
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 1f                	push   $0x1f
  8019d0:	e8 a7 fc ff ff       	call   80167c <syscall>
  8019d5:	83 c4 18             	add    $0x18,%esp
}
  8019d8:	c9                   	leave  
  8019d9:	c3                   	ret    

008019da <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8019da:	55                   	push   %ebp
  8019db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8019dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e0:	6a 00                	push   $0x0
  8019e2:	ff 75 14             	pushl  0x14(%ebp)
  8019e5:	ff 75 10             	pushl  0x10(%ebp)
  8019e8:	ff 75 0c             	pushl  0xc(%ebp)
  8019eb:	50                   	push   %eax
  8019ec:	6a 20                	push   $0x20
  8019ee:	e8 89 fc ff ff       	call   80167c <syscall>
  8019f3:	83 c4 18             	add    $0x18,%esp
}
  8019f6:	c9                   	leave  
  8019f7:	c3                   	ret    

008019f8 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8019f8:	55                   	push   %ebp
  8019f9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8019fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fe:	6a 00                	push   $0x0
  801a00:	6a 00                	push   $0x0
  801a02:	6a 00                	push   $0x0
  801a04:	6a 00                	push   $0x0
  801a06:	50                   	push   %eax
  801a07:	6a 21                	push   $0x21
  801a09:	e8 6e fc ff ff       	call   80167c <syscall>
  801a0e:	83 c4 18             	add    $0x18,%esp
}
  801a11:	90                   	nop
  801a12:	c9                   	leave  
  801a13:	c3                   	ret    

00801a14 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801a14:	55                   	push   %ebp
  801a15:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801a17:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1a:	6a 00                	push   $0x0
  801a1c:	6a 00                	push   $0x0
  801a1e:	6a 00                	push   $0x0
  801a20:	6a 00                	push   $0x0
  801a22:	50                   	push   %eax
  801a23:	6a 22                	push   $0x22
  801a25:	e8 52 fc ff ff       	call   80167c <syscall>
  801a2a:	83 c4 18             	add    $0x18,%esp
}
  801a2d:	c9                   	leave  
  801a2e:	c3                   	ret    

00801a2f <sys_getenvid>:

int32 sys_getenvid(void)
{
  801a2f:	55                   	push   %ebp
  801a30:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801a32:	6a 00                	push   $0x0
  801a34:	6a 00                	push   $0x0
  801a36:	6a 00                	push   $0x0
  801a38:	6a 00                	push   $0x0
  801a3a:	6a 00                	push   $0x0
  801a3c:	6a 02                	push   $0x2
  801a3e:	e8 39 fc ff ff       	call   80167c <syscall>
  801a43:	83 c4 18             	add    $0x18,%esp
}
  801a46:	c9                   	leave  
  801a47:	c3                   	ret    

00801a48 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801a48:	55                   	push   %ebp
  801a49:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801a4b:	6a 00                	push   $0x0
  801a4d:	6a 00                	push   $0x0
  801a4f:	6a 00                	push   $0x0
  801a51:	6a 00                	push   $0x0
  801a53:	6a 00                	push   $0x0
  801a55:	6a 03                	push   $0x3
  801a57:	e8 20 fc ff ff       	call   80167c <syscall>
  801a5c:	83 c4 18             	add    $0x18,%esp
}
  801a5f:	c9                   	leave  
  801a60:	c3                   	ret    

00801a61 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801a61:	55                   	push   %ebp
  801a62:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801a64:	6a 00                	push   $0x0
  801a66:	6a 00                	push   $0x0
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 04                	push   $0x4
  801a70:	e8 07 fc ff ff       	call   80167c <syscall>
  801a75:	83 c4 18             	add    $0x18,%esp
}
  801a78:	c9                   	leave  
  801a79:	c3                   	ret    

00801a7a <sys_exit_env>:


void sys_exit_env(void)
{
  801a7a:	55                   	push   %ebp
  801a7b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 00                	push   $0x0
  801a83:	6a 00                	push   $0x0
  801a85:	6a 00                	push   $0x0
  801a87:	6a 23                	push   $0x23
  801a89:	e8 ee fb ff ff       	call   80167c <syscall>
  801a8e:	83 c4 18             	add    $0x18,%esp
}
  801a91:	90                   	nop
  801a92:	c9                   	leave  
  801a93:	c3                   	ret    

00801a94 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801a94:	55                   	push   %ebp
  801a95:	89 e5                	mov    %esp,%ebp
  801a97:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801a9a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a9d:	8d 50 04             	lea    0x4(%eax),%edx
  801aa0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801aa3:	6a 00                	push   $0x0
  801aa5:	6a 00                	push   $0x0
  801aa7:	6a 00                	push   $0x0
  801aa9:	52                   	push   %edx
  801aaa:	50                   	push   %eax
  801aab:	6a 24                	push   $0x24
  801aad:	e8 ca fb ff ff       	call   80167c <syscall>
  801ab2:	83 c4 18             	add    $0x18,%esp
	return result;
  801ab5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ab8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801abb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801abe:	89 01                	mov    %eax,(%ecx)
  801ac0:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac6:	c9                   	leave  
  801ac7:	c2 04 00             	ret    $0x4

00801aca <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801aca:	55                   	push   %ebp
  801acb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801acd:	6a 00                	push   $0x0
  801acf:	6a 00                	push   $0x0
  801ad1:	ff 75 10             	pushl  0x10(%ebp)
  801ad4:	ff 75 0c             	pushl  0xc(%ebp)
  801ad7:	ff 75 08             	pushl  0x8(%ebp)
  801ada:	6a 12                	push   $0x12
  801adc:	e8 9b fb ff ff       	call   80167c <syscall>
  801ae1:	83 c4 18             	add    $0x18,%esp
	return ;
  801ae4:	90                   	nop
}
  801ae5:	c9                   	leave  
  801ae6:	c3                   	ret    

00801ae7 <sys_rcr2>:
uint32 sys_rcr2()
{
  801ae7:	55                   	push   %ebp
  801ae8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801aea:	6a 00                	push   $0x0
  801aec:	6a 00                	push   $0x0
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	6a 25                	push   $0x25
  801af6:	e8 81 fb ff ff       	call   80167c <syscall>
  801afb:	83 c4 18             	add    $0x18,%esp
}
  801afe:	c9                   	leave  
  801aff:	c3                   	ret    

00801b00 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801b00:	55                   	push   %ebp
  801b01:	89 e5                	mov    %esp,%ebp
  801b03:	83 ec 04             	sub    $0x4,%esp
  801b06:	8b 45 08             	mov    0x8(%ebp),%eax
  801b09:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801b0c:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801b10:	6a 00                	push   $0x0
  801b12:	6a 00                	push   $0x0
  801b14:	6a 00                	push   $0x0
  801b16:	6a 00                	push   $0x0
  801b18:	50                   	push   %eax
  801b19:	6a 26                	push   $0x26
  801b1b:	e8 5c fb ff ff       	call   80167c <syscall>
  801b20:	83 c4 18             	add    $0x18,%esp
	return ;
  801b23:	90                   	nop
}
  801b24:	c9                   	leave  
  801b25:	c3                   	ret    

00801b26 <rsttst>:
void rsttst()
{
  801b26:	55                   	push   %ebp
  801b27:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 00                	push   $0x0
  801b33:	6a 28                	push   $0x28
  801b35:	e8 42 fb ff ff       	call   80167c <syscall>
  801b3a:	83 c4 18             	add    $0x18,%esp
	return ;
  801b3d:	90                   	nop
}
  801b3e:	c9                   	leave  
  801b3f:	c3                   	ret    

00801b40 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801b40:	55                   	push   %ebp
  801b41:	89 e5                	mov    %esp,%ebp
  801b43:	83 ec 04             	sub    $0x4,%esp
  801b46:	8b 45 14             	mov    0x14(%ebp),%eax
  801b49:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801b4c:	8b 55 18             	mov    0x18(%ebp),%edx
  801b4f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b53:	52                   	push   %edx
  801b54:	50                   	push   %eax
  801b55:	ff 75 10             	pushl  0x10(%ebp)
  801b58:	ff 75 0c             	pushl  0xc(%ebp)
  801b5b:	ff 75 08             	pushl  0x8(%ebp)
  801b5e:	6a 27                	push   $0x27
  801b60:	e8 17 fb ff ff       	call   80167c <syscall>
  801b65:	83 c4 18             	add    $0x18,%esp
	return ;
  801b68:	90                   	nop
}
  801b69:	c9                   	leave  
  801b6a:	c3                   	ret    

00801b6b <chktst>:
void chktst(uint32 n)
{
  801b6b:	55                   	push   %ebp
  801b6c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801b6e:	6a 00                	push   $0x0
  801b70:	6a 00                	push   $0x0
  801b72:	6a 00                	push   $0x0
  801b74:	6a 00                	push   $0x0
  801b76:	ff 75 08             	pushl  0x8(%ebp)
  801b79:	6a 29                	push   $0x29
  801b7b:	e8 fc fa ff ff       	call   80167c <syscall>
  801b80:	83 c4 18             	add    $0x18,%esp
	return ;
  801b83:	90                   	nop
}
  801b84:	c9                   	leave  
  801b85:	c3                   	ret    

00801b86 <inctst>:

void inctst()
{
  801b86:	55                   	push   %ebp
  801b87:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801b89:	6a 00                	push   $0x0
  801b8b:	6a 00                	push   $0x0
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 00                	push   $0x0
  801b93:	6a 2a                	push   $0x2a
  801b95:	e8 e2 fa ff ff       	call   80167c <syscall>
  801b9a:	83 c4 18             	add    $0x18,%esp
	return ;
  801b9d:	90                   	nop
}
  801b9e:	c9                   	leave  
  801b9f:	c3                   	ret    

00801ba0 <gettst>:
uint32 gettst()
{
  801ba0:	55                   	push   %ebp
  801ba1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 00                	push   $0x0
  801bad:	6a 2b                	push   $0x2b
  801baf:	e8 c8 fa ff ff       	call   80167c <syscall>
  801bb4:	83 c4 18             	add    $0x18,%esp
}
  801bb7:	c9                   	leave  
  801bb8:	c3                   	ret    

00801bb9 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801bb9:	55                   	push   %ebp
  801bba:	89 e5                	mov    %esp,%ebp
  801bbc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 2c                	push   $0x2c
  801bcb:	e8 ac fa ff ff       	call   80167c <syscall>
  801bd0:	83 c4 18             	add    $0x18,%esp
  801bd3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801bd6:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801bda:	75 07                	jne    801be3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801bdc:	b8 01 00 00 00       	mov    $0x1,%eax
  801be1:	eb 05                	jmp    801be8 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801be3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801be8:	c9                   	leave  
  801be9:	c3                   	ret    

00801bea <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801bea:	55                   	push   %ebp
  801beb:	89 e5                	mov    %esp,%ebp
  801bed:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 00                	push   $0x0
  801bf4:	6a 00                	push   $0x0
  801bf6:	6a 00                	push   $0x0
  801bf8:	6a 00                	push   $0x0
  801bfa:	6a 2c                	push   $0x2c
  801bfc:	e8 7b fa ff ff       	call   80167c <syscall>
  801c01:	83 c4 18             	add    $0x18,%esp
  801c04:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801c07:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801c0b:	75 07                	jne    801c14 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801c0d:	b8 01 00 00 00       	mov    $0x1,%eax
  801c12:	eb 05                	jmp    801c19 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801c14:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c19:	c9                   	leave  
  801c1a:	c3                   	ret    

00801c1b <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801c1b:	55                   	push   %ebp
  801c1c:	89 e5                	mov    %esp,%ebp
  801c1e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c21:	6a 00                	push   $0x0
  801c23:	6a 00                	push   $0x0
  801c25:	6a 00                	push   $0x0
  801c27:	6a 00                	push   $0x0
  801c29:	6a 00                	push   $0x0
  801c2b:	6a 2c                	push   $0x2c
  801c2d:	e8 4a fa ff ff       	call   80167c <syscall>
  801c32:	83 c4 18             	add    $0x18,%esp
  801c35:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801c38:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801c3c:	75 07                	jne    801c45 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801c3e:	b8 01 00 00 00       	mov    $0x1,%eax
  801c43:	eb 05                	jmp    801c4a <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801c45:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c4a:	c9                   	leave  
  801c4b:	c3                   	ret    

00801c4c <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801c4c:	55                   	push   %ebp
  801c4d:	89 e5                	mov    %esp,%ebp
  801c4f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c52:	6a 00                	push   $0x0
  801c54:	6a 00                	push   $0x0
  801c56:	6a 00                	push   $0x0
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 2c                	push   $0x2c
  801c5e:	e8 19 fa ff ff       	call   80167c <syscall>
  801c63:	83 c4 18             	add    $0x18,%esp
  801c66:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801c69:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801c6d:	75 07                	jne    801c76 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801c6f:	b8 01 00 00 00       	mov    $0x1,%eax
  801c74:	eb 05                	jmp    801c7b <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801c76:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c7b:	c9                   	leave  
  801c7c:	c3                   	ret    

00801c7d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c7d:	55                   	push   %ebp
  801c7e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c80:	6a 00                	push   $0x0
  801c82:	6a 00                	push   $0x0
  801c84:	6a 00                	push   $0x0
  801c86:	6a 00                	push   $0x0
  801c88:	ff 75 08             	pushl  0x8(%ebp)
  801c8b:	6a 2d                	push   $0x2d
  801c8d:	e8 ea f9 ff ff       	call   80167c <syscall>
  801c92:	83 c4 18             	add    $0x18,%esp
	return ;
  801c95:	90                   	nop
}
  801c96:	c9                   	leave  
  801c97:	c3                   	ret    

00801c98 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801c98:	55                   	push   %ebp
  801c99:	89 e5                	mov    %esp,%ebp
  801c9b:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801c9c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c9f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ca2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca8:	6a 00                	push   $0x0
  801caa:	53                   	push   %ebx
  801cab:	51                   	push   %ecx
  801cac:	52                   	push   %edx
  801cad:	50                   	push   %eax
  801cae:	6a 2e                	push   $0x2e
  801cb0:	e8 c7 f9 ff ff       	call   80167c <syscall>
  801cb5:	83 c4 18             	add    $0x18,%esp
}
  801cb8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cbb:	c9                   	leave  
  801cbc:	c3                   	ret    

00801cbd <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801cbd:	55                   	push   %ebp
  801cbe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801cc0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc6:	6a 00                	push   $0x0
  801cc8:	6a 00                	push   $0x0
  801cca:	6a 00                	push   $0x0
  801ccc:	52                   	push   %edx
  801ccd:	50                   	push   %eax
  801cce:	6a 2f                	push   $0x2f
  801cd0:	e8 a7 f9 ff ff       	call   80167c <syscall>
  801cd5:	83 c4 18             	add    $0x18,%esp
}
  801cd8:	c9                   	leave  
  801cd9:	c3                   	ret    

00801cda <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801cda:	55                   	push   %ebp
  801cdb:	89 e5                	mov    %esp,%ebp
  801cdd:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801ce0:	83 ec 0c             	sub    $0xc,%esp
  801ce3:	68 44 3e 80 00       	push   $0x803e44
  801ce8:	e8 46 e8 ff ff       	call   800533 <cprintf>
  801ced:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801cf0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801cf7:	83 ec 0c             	sub    $0xc,%esp
  801cfa:	68 70 3e 80 00       	push   $0x803e70
  801cff:	e8 2f e8 ff ff       	call   800533 <cprintf>
  801d04:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801d07:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d0b:	a1 38 41 80 00       	mov    0x804138,%eax
  801d10:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d13:	eb 56                	jmp    801d6b <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801d15:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d19:	74 1c                	je     801d37 <print_mem_block_lists+0x5d>
  801d1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d1e:	8b 50 08             	mov    0x8(%eax),%edx
  801d21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d24:	8b 48 08             	mov    0x8(%eax),%ecx
  801d27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d2a:	8b 40 0c             	mov    0xc(%eax),%eax
  801d2d:	01 c8                	add    %ecx,%eax
  801d2f:	39 c2                	cmp    %eax,%edx
  801d31:	73 04                	jae    801d37 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801d33:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801d37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d3a:	8b 50 08             	mov    0x8(%eax),%edx
  801d3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d40:	8b 40 0c             	mov    0xc(%eax),%eax
  801d43:	01 c2                	add    %eax,%edx
  801d45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d48:	8b 40 08             	mov    0x8(%eax),%eax
  801d4b:	83 ec 04             	sub    $0x4,%esp
  801d4e:	52                   	push   %edx
  801d4f:	50                   	push   %eax
  801d50:	68 85 3e 80 00       	push   $0x803e85
  801d55:	e8 d9 e7 ff ff       	call   800533 <cprintf>
  801d5a:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801d5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d60:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d63:	a1 40 41 80 00       	mov    0x804140,%eax
  801d68:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d6b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d6f:	74 07                	je     801d78 <print_mem_block_lists+0x9e>
  801d71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d74:	8b 00                	mov    (%eax),%eax
  801d76:	eb 05                	jmp    801d7d <print_mem_block_lists+0xa3>
  801d78:	b8 00 00 00 00       	mov    $0x0,%eax
  801d7d:	a3 40 41 80 00       	mov    %eax,0x804140
  801d82:	a1 40 41 80 00       	mov    0x804140,%eax
  801d87:	85 c0                	test   %eax,%eax
  801d89:	75 8a                	jne    801d15 <print_mem_block_lists+0x3b>
  801d8b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d8f:	75 84                	jne    801d15 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801d91:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801d95:	75 10                	jne    801da7 <print_mem_block_lists+0xcd>
  801d97:	83 ec 0c             	sub    $0xc,%esp
  801d9a:	68 94 3e 80 00       	push   $0x803e94
  801d9f:	e8 8f e7 ff ff       	call   800533 <cprintf>
  801da4:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801da7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801dae:	83 ec 0c             	sub    $0xc,%esp
  801db1:	68 b8 3e 80 00       	push   $0x803eb8
  801db6:	e8 78 e7 ff ff       	call   800533 <cprintf>
  801dbb:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801dbe:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801dc2:	a1 40 40 80 00       	mov    0x804040,%eax
  801dc7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dca:	eb 56                	jmp    801e22 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801dcc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801dd0:	74 1c                	je     801dee <print_mem_block_lists+0x114>
  801dd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd5:	8b 50 08             	mov    0x8(%eax),%edx
  801dd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ddb:	8b 48 08             	mov    0x8(%eax),%ecx
  801dde:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801de1:	8b 40 0c             	mov    0xc(%eax),%eax
  801de4:	01 c8                	add    %ecx,%eax
  801de6:	39 c2                	cmp    %eax,%edx
  801de8:	73 04                	jae    801dee <print_mem_block_lists+0x114>
			sorted = 0 ;
  801dea:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801dee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df1:	8b 50 08             	mov    0x8(%eax),%edx
  801df4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df7:	8b 40 0c             	mov    0xc(%eax),%eax
  801dfa:	01 c2                	add    %eax,%edx
  801dfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dff:	8b 40 08             	mov    0x8(%eax),%eax
  801e02:	83 ec 04             	sub    $0x4,%esp
  801e05:	52                   	push   %edx
  801e06:	50                   	push   %eax
  801e07:	68 85 3e 80 00       	push   $0x803e85
  801e0c:	e8 22 e7 ff ff       	call   800533 <cprintf>
  801e11:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e17:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801e1a:	a1 48 40 80 00       	mov    0x804048,%eax
  801e1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e22:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e26:	74 07                	je     801e2f <print_mem_block_lists+0x155>
  801e28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e2b:	8b 00                	mov    (%eax),%eax
  801e2d:	eb 05                	jmp    801e34 <print_mem_block_lists+0x15a>
  801e2f:	b8 00 00 00 00       	mov    $0x0,%eax
  801e34:	a3 48 40 80 00       	mov    %eax,0x804048
  801e39:	a1 48 40 80 00       	mov    0x804048,%eax
  801e3e:	85 c0                	test   %eax,%eax
  801e40:	75 8a                	jne    801dcc <print_mem_block_lists+0xf2>
  801e42:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e46:	75 84                	jne    801dcc <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801e48:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e4c:	75 10                	jne    801e5e <print_mem_block_lists+0x184>
  801e4e:	83 ec 0c             	sub    $0xc,%esp
  801e51:	68 d0 3e 80 00       	push   $0x803ed0
  801e56:	e8 d8 e6 ff ff       	call   800533 <cprintf>
  801e5b:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801e5e:	83 ec 0c             	sub    $0xc,%esp
  801e61:	68 44 3e 80 00       	push   $0x803e44
  801e66:	e8 c8 e6 ff ff       	call   800533 <cprintf>
  801e6b:	83 c4 10             	add    $0x10,%esp

}
  801e6e:	90                   	nop
  801e6f:	c9                   	leave  
  801e70:	c3                   	ret    

00801e71 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801e71:	55                   	push   %ebp
  801e72:	89 e5                	mov    %esp,%ebp
  801e74:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801e77:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801e7e:	00 00 00 
  801e81:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801e88:	00 00 00 
  801e8b:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801e92:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801e95:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801e9c:	e9 9e 00 00 00       	jmp    801f3f <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801ea1:	a1 50 40 80 00       	mov    0x804050,%eax
  801ea6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ea9:	c1 e2 04             	shl    $0x4,%edx
  801eac:	01 d0                	add    %edx,%eax
  801eae:	85 c0                	test   %eax,%eax
  801eb0:	75 14                	jne    801ec6 <initialize_MemBlocksList+0x55>
  801eb2:	83 ec 04             	sub    $0x4,%esp
  801eb5:	68 f8 3e 80 00       	push   $0x803ef8
  801eba:	6a 46                	push   $0x46
  801ebc:	68 1b 3f 80 00       	push   $0x803f1b
  801ec1:	e8 b9 e3 ff ff       	call   80027f <_panic>
  801ec6:	a1 50 40 80 00       	mov    0x804050,%eax
  801ecb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ece:	c1 e2 04             	shl    $0x4,%edx
  801ed1:	01 d0                	add    %edx,%eax
  801ed3:	8b 15 48 41 80 00    	mov    0x804148,%edx
  801ed9:	89 10                	mov    %edx,(%eax)
  801edb:	8b 00                	mov    (%eax),%eax
  801edd:	85 c0                	test   %eax,%eax
  801edf:	74 18                	je     801ef9 <initialize_MemBlocksList+0x88>
  801ee1:	a1 48 41 80 00       	mov    0x804148,%eax
  801ee6:	8b 15 50 40 80 00    	mov    0x804050,%edx
  801eec:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801eef:	c1 e1 04             	shl    $0x4,%ecx
  801ef2:	01 ca                	add    %ecx,%edx
  801ef4:	89 50 04             	mov    %edx,0x4(%eax)
  801ef7:	eb 12                	jmp    801f0b <initialize_MemBlocksList+0x9a>
  801ef9:	a1 50 40 80 00       	mov    0x804050,%eax
  801efe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f01:	c1 e2 04             	shl    $0x4,%edx
  801f04:	01 d0                	add    %edx,%eax
  801f06:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801f0b:	a1 50 40 80 00       	mov    0x804050,%eax
  801f10:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f13:	c1 e2 04             	shl    $0x4,%edx
  801f16:	01 d0                	add    %edx,%eax
  801f18:	a3 48 41 80 00       	mov    %eax,0x804148
  801f1d:	a1 50 40 80 00       	mov    0x804050,%eax
  801f22:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f25:	c1 e2 04             	shl    $0x4,%edx
  801f28:	01 d0                	add    %edx,%eax
  801f2a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f31:	a1 54 41 80 00       	mov    0x804154,%eax
  801f36:	40                   	inc    %eax
  801f37:	a3 54 41 80 00       	mov    %eax,0x804154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801f3c:	ff 45 f4             	incl   -0xc(%ebp)
  801f3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f42:	3b 45 08             	cmp    0x8(%ebp),%eax
  801f45:	0f 82 56 ff ff ff    	jb     801ea1 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801f4b:	90                   	nop
  801f4c:	c9                   	leave  
  801f4d:	c3                   	ret    

00801f4e <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801f4e:	55                   	push   %ebp
  801f4f:	89 e5                	mov    %esp,%ebp
  801f51:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801f54:	8b 45 08             	mov    0x8(%ebp),%eax
  801f57:	8b 00                	mov    (%eax),%eax
  801f59:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f5c:	eb 19                	jmp    801f77 <find_block+0x29>
	{
		if(va==point->sva)
  801f5e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f61:	8b 40 08             	mov    0x8(%eax),%eax
  801f64:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801f67:	75 05                	jne    801f6e <find_block+0x20>
		   return point;
  801f69:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f6c:	eb 36                	jmp    801fa4 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f71:	8b 40 08             	mov    0x8(%eax),%eax
  801f74:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f77:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f7b:	74 07                	je     801f84 <find_block+0x36>
  801f7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f80:	8b 00                	mov    (%eax),%eax
  801f82:	eb 05                	jmp    801f89 <find_block+0x3b>
  801f84:	b8 00 00 00 00       	mov    $0x0,%eax
  801f89:	8b 55 08             	mov    0x8(%ebp),%edx
  801f8c:	89 42 08             	mov    %eax,0x8(%edx)
  801f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f92:	8b 40 08             	mov    0x8(%eax),%eax
  801f95:	85 c0                	test   %eax,%eax
  801f97:	75 c5                	jne    801f5e <find_block+0x10>
  801f99:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f9d:	75 bf                	jne    801f5e <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  801f9f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fa4:	c9                   	leave  
  801fa5:	c3                   	ret    

00801fa6 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  801fa6:	55                   	push   %ebp
  801fa7:	89 e5                	mov    %esp,%ebp
  801fa9:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  801fac:	a1 40 40 80 00       	mov    0x804040,%eax
  801fb1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  801fb4:	a1 44 40 80 00       	mov    0x804044,%eax
  801fb9:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  801fbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fbf:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801fc2:	74 24                	je     801fe8 <insert_sorted_allocList+0x42>
  801fc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc7:	8b 50 08             	mov    0x8(%eax),%edx
  801fca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fcd:	8b 40 08             	mov    0x8(%eax),%eax
  801fd0:	39 c2                	cmp    %eax,%edx
  801fd2:	76 14                	jbe    801fe8 <insert_sorted_allocList+0x42>
  801fd4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd7:	8b 50 08             	mov    0x8(%eax),%edx
  801fda:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fdd:	8b 40 08             	mov    0x8(%eax),%eax
  801fe0:	39 c2                	cmp    %eax,%edx
  801fe2:	0f 82 60 01 00 00    	jb     802148 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  801fe8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fec:	75 65                	jne    802053 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  801fee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ff2:	75 14                	jne    802008 <insert_sorted_allocList+0x62>
  801ff4:	83 ec 04             	sub    $0x4,%esp
  801ff7:	68 f8 3e 80 00       	push   $0x803ef8
  801ffc:	6a 6b                	push   $0x6b
  801ffe:	68 1b 3f 80 00       	push   $0x803f1b
  802003:	e8 77 e2 ff ff       	call   80027f <_panic>
  802008:	8b 15 40 40 80 00    	mov    0x804040,%edx
  80200e:	8b 45 08             	mov    0x8(%ebp),%eax
  802011:	89 10                	mov    %edx,(%eax)
  802013:	8b 45 08             	mov    0x8(%ebp),%eax
  802016:	8b 00                	mov    (%eax),%eax
  802018:	85 c0                	test   %eax,%eax
  80201a:	74 0d                	je     802029 <insert_sorted_allocList+0x83>
  80201c:	a1 40 40 80 00       	mov    0x804040,%eax
  802021:	8b 55 08             	mov    0x8(%ebp),%edx
  802024:	89 50 04             	mov    %edx,0x4(%eax)
  802027:	eb 08                	jmp    802031 <insert_sorted_allocList+0x8b>
  802029:	8b 45 08             	mov    0x8(%ebp),%eax
  80202c:	a3 44 40 80 00       	mov    %eax,0x804044
  802031:	8b 45 08             	mov    0x8(%ebp),%eax
  802034:	a3 40 40 80 00       	mov    %eax,0x804040
  802039:	8b 45 08             	mov    0x8(%ebp),%eax
  80203c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802043:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802048:	40                   	inc    %eax
  802049:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80204e:	e9 dc 01 00 00       	jmp    80222f <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802053:	8b 45 08             	mov    0x8(%ebp),%eax
  802056:	8b 50 08             	mov    0x8(%eax),%edx
  802059:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80205c:	8b 40 08             	mov    0x8(%eax),%eax
  80205f:	39 c2                	cmp    %eax,%edx
  802061:	77 6c                	ja     8020cf <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802063:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802067:	74 06                	je     80206f <insert_sorted_allocList+0xc9>
  802069:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80206d:	75 14                	jne    802083 <insert_sorted_allocList+0xdd>
  80206f:	83 ec 04             	sub    $0x4,%esp
  802072:	68 34 3f 80 00       	push   $0x803f34
  802077:	6a 6f                	push   $0x6f
  802079:	68 1b 3f 80 00       	push   $0x803f1b
  80207e:	e8 fc e1 ff ff       	call   80027f <_panic>
  802083:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802086:	8b 50 04             	mov    0x4(%eax),%edx
  802089:	8b 45 08             	mov    0x8(%ebp),%eax
  80208c:	89 50 04             	mov    %edx,0x4(%eax)
  80208f:	8b 45 08             	mov    0x8(%ebp),%eax
  802092:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802095:	89 10                	mov    %edx,(%eax)
  802097:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80209a:	8b 40 04             	mov    0x4(%eax),%eax
  80209d:	85 c0                	test   %eax,%eax
  80209f:	74 0d                	je     8020ae <insert_sorted_allocList+0x108>
  8020a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020a4:	8b 40 04             	mov    0x4(%eax),%eax
  8020a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8020aa:	89 10                	mov    %edx,(%eax)
  8020ac:	eb 08                	jmp    8020b6 <insert_sorted_allocList+0x110>
  8020ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b1:	a3 40 40 80 00       	mov    %eax,0x804040
  8020b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8020bc:	89 50 04             	mov    %edx,0x4(%eax)
  8020bf:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8020c4:	40                   	inc    %eax
  8020c5:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8020ca:	e9 60 01 00 00       	jmp    80222f <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8020cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d2:	8b 50 08             	mov    0x8(%eax),%edx
  8020d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020d8:	8b 40 08             	mov    0x8(%eax),%eax
  8020db:	39 c2                	cmp    %eax,%edx
  8020dd:	0f 82 4c 01 00 00    	jb     80222f <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8020e3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020e7:	75 14                	jne    8020fd <insert_sorted_allocList+0x157>
  8020e9:	83 ec 04             	sub    $0x4,%esp
  8020ec:	68 6c 3f 80 00       	push   $0x803f6c
  8020f1:	6a 73                	push   $0x73
  8020f3:	68 1b 3f 80 00       	push   $0x803f1b
  8020f8:	e8 82 e1 ff ff       	call   80027f <_panic>
  8020fd:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802103:	8b 45 08             	mov    0x8(%ebp),%eax
  802106:	89 50 04             	mov    %edx,0x4(%eax)
  802109:	8b 45 08             	mov    0x8(%ebp),%eax
  80210c:	8b 40 04             	mov    0x4(%eax),%eax
  80210f:	85 c0                	test   %eax,%eax
  802111:	74 0c                	je     80211f <insert_sorted_allocList+0x179>
  802113:	a1 44 40 80 00       	mov    0x804044,%eax
  802118:	8b 55 08             	mov    0x8(%ebp),%edx
  80211b:	89 10                	mov    %edx,(%eax)
  80211d:	eb 08                	jmp    802127 <insert_sorted_allocList+0x181>
  80211f:	8b 45 08             	mov    0x8(%ebp),%eax
  802122:	a3 40 40 80 00       	mov    %eax,0x804040
  802127:	8b 45 08             	mov    0x8(%ebp),%eax
  80212a:	a3 44 40 80 00       	mov    %eax,0x804044
  80212f:	8b 45 08             	mov    0x8(%ebp),%eax
  802132:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802138:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80213d:	40                   	inc    %eax
  80213e:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802143:	e9 e7 00 00 00       	jmp    80222f <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802148:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80214b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  80214e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802155:	a1 40 40 80 00       	mov    0x804040,%eax
  80215a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80215d:	e9 9d 00 00 00       	jmp    8021ff <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802162:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802165:	8b 00                	mov    (%eax),%eax
  802167:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  80216a:	8b 45 08             	mov    0x8(%ebp),%eax
  80216d:	8b 50 08             	mov    0x8(%eax),%edx
  802170:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802173:	8b 40 08             	mov    0x8(%eax),%eax
  802176:	39 c2                	cmp    %eax,%edx
  802178:	76 7d                	jbe    8021f7 <insert_sorted_allocList+0x251>
  80217a:	8b 45 08             	mov    0x8(%ebp),%eax
  80217d:	8b 50 08             	mov    0x8(%eax),%edx
  802180:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802183:	8b 40 08             	mov    0x8(%eax),%eax
  802186:	39 c2                	cmp    %eax,%edx
  802188:	73 6d                	jae    8021f7 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  80218a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80218e:	74 06                	je     802196 <insert_sorted_allocList+0x1f0>
  802190:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802194:	75 14                	jne    8021aa <insert_sorted_allocList+0x204>
  802196:	83 ec 04             	sub    $0x4,%esp
  802199:	68 90 3f 80 00       	push   $0x803f90
  80219e:	6a 7f                	push   $0x7f
  8021a0:	68 1b 3f 80 00       	push   $0x803f1b
  8021a5:	e8 d5 e0 ff ff       	call   80027f <_panic>
  8021aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ad:	8b 10                	mov    (%eax),%edx
  8021af:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b2:	89 10                	mov    %edx,(%eax)
  8021b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b7:	8b 00                	mov    (%eax),%eax
  8021b9:	85 c0                	test   %eax,%eax
  8021bb:	74 0b                	je     8021c8 <insert_sorted_allocList+0x222>
  8021bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c0:	8b 00                	mov    (%eax),%eax
  8021c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8021c5:	89 50 04             	mov    %edx,0x4(%eax)
  8021c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8021ce:	89 10                	mov    %edx,(%eax)
  8021d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021d6:	89 50 04             	mov    %edx,0x4(%eax)
  8021d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021dc:	8b 00                	mov    (%eax),%eax
  8021de:	85 c0                	test   %eax,%eax
  8021e0:	75 08                	jne    8021ea <insert_sorted_allocList+0x244>
  8021e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e5:	a3 44 40 80 00       	mov    %eax,0x804044
  8021ea:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021ef:	40                   	inc    %eax
  8021f0:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  8021f5:	eb 39                	jmp    802230 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8021f7:	a1 48 40 80 00       	mov    0x804048,%eax
  8021fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802203:	74 07                	je     80220c <insert_sorted_allocList+0x266>
  802205:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802208:	8b 00                	mov    (%eax),%eax
  80220a:	eb 05                	jmp    802211 <insert_sorted_allocList+0x26b>
  80220c:	b8 00 00 00 00       	mov    $0x0,%eax
  802211:	a3 48 40 80 00       	mov    %eax,0x804048
  802216:	a1 48 40 80 00       	mov    0x804048,%eax
  80221b:	85 c0                	test   %eax,%eax
  80221d:	0f 85 3f ff ff ff    	jne    802162 <insert_sorted_allocList+0x1bc>
  802223:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802227:	0f 85 35 ff ff ff    	jne    802162 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80222d:	eb 01                	jmp    802230 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80222f:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802230:	90                   	nop
  802231:	c9                   	leave  
  802232:	c3                   	ret    

00802233 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802233:	55                   	push   %ebp
  802234:	89 e5                	mov    %esp,%ebp
  802236:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802239:	a1 38 41 80 00       	mov    0x804138,%eax
  80223e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802241:	e9 85 01 00 00       	jmp    8023cb <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802246:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802249:	8b 40 0c             	mov    0xc(%eax),%eax
  80224c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80224f:	0f 82 6e 01 00 00    	jb     8023c3 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802255:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802258:	8b 40 0c             	mov    0xc(%eax),%eax
  80225b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80225e:	0f 85 8a 00 00 00    	jne    8022ee <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802264:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802268:	75 17                	jne    802281 <alloc_block_FF+0x4e>
  80226a:	83 ec 04             	sub    $0x4,%esp
  80226d:	68 c4 3f 80 00       	push   $0x803fc4
  802272:	68 93 00 00 00       	push   $0x93
  802277:	68 1b 3f 80 00       	push   $0x803f1b
  80227c:	e8 fe df ff ff       	call   80027f <_panic>
  802281:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802284:	8b 00                	mov    (%eax),%eax
  802286:	85 c0                	test   %eax,%eax
  802288:	74 10                	je     80229a <alloc_block_FF+0x67>
  80228a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228d:	8b 00                	mov    (%eax),%eax
  80228f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802292:	8b 52 04             	mov    0x4(%edx),%edx
  802295:	89 50 04             	mov    %edx,0x4(%eax)
  802298:	eb 0b                	jmp    8022a5 <alloc_block_FF+0x72>
  80229a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229d:	8b 40 04             	mov    0x4(%eax),%eax
  8022a0:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8022a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a8:	8b 40 04             	mov    0x4(%eax),%eax
  8022ab:	85 c0                	test   %eax,%eax
  8022ad:	74 0f                	je     8022be <alloc_block_FF+0x8b>
  8022af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b2:	8b 40 04             	mov    0x4(%eax),%eax
  8022b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022b8:	8b 12                	mov    (%edx),%edx
  8022ba:	89 10                	mov    %edx,(%eax)
  8022bc:	eb 0a                	jmp    8022c8 <alloc_block_FF+0x95>
  8022be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c1:	8b 00                	mov    (%eax),%eax
  8022c3:	a3 38 41 80 00       	mov    %eax,0x804138
  8022c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022db:	a1 44 41 80 00       	mov    0x804144,%eax
  8022e0:	48                   	dec    %eax
  8022e1:	a3 44 41 80 00       	mov    %eax,0x804144
			   return  point;
  8022e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e9:	e9 10 01 00 00       	jmp    8023fe <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8022ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f1:	8b 40 0c             	mov    0xc(%eax),%eax
  8022f4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022f7:	0f 86 c6 00 00 00    	jbe    8023c3 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8022fd:	a1 48 41 80 00       	mov    0x804148,%eax
  802302:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802305:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802308:	8b 50 08             	mov    0x8(%eax),%edx
  80230b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80230e:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802311:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802314:	8b 55 08             	mov    0x8(%ebp),%edx
  802317:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80231a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80231e:	75 17                	jne    802337 <alloc_block_FF+0x104>
  802320:	83 ec 04             	sub    $0x4,%esp
  802323:	68 c4 3f 80 00       	push   $0x803fc4
  802328:	68 9b 00 00 00       	push   $0x9b
  80232d:	68 1b 3f 80 00       	push   $0x803f1b
  802332:	e8 48 df ff ff       	call   80027f <_panic>
  802337:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80233a:	8b 00                	mov    (%eax),%eax
  80233c:	85 c0                	test   %eax,%eax
  80233e:	74 10                	je     802350 <alloc_block_FF+0x11d>
  802340:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802343:	8b 00                	mov    (%eax),%eax
  802345:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802348:	8b 52 04             	mov    0x4(%edx),%edx
  80234b:	89 50 04             	mov    %edx,0x4(%eax)
  80234e:	eb 0b                	jmp    80235b <alloc_block_FF+0x128>
  802350:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802353:	8b 40 04             	mov    0x4(%eax),%eax
  802356:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80235b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80235e:	8b 40 04             	mov    0x4(%eax),%eax
  802361:	85 c0                	test   %eax,%eax
  802363:	74 0f                	je     802374 <alloc_block_FF+0x141>
  802365:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802368:	8b 40 04             	mov    0x4(%eax),%eax
  80236b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80236e:	8b 12                	mov    (%edx),%edx
  802370:	89 10                	mov    %edx,(%eax)
  802372:	eb 0a                	jmp    80237e <alloc_block_FF+0x14b>
  802374:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802377:	8b 00                	mov    (%eax),%eax
  802379:	a3 48 41 80 00       	mov    %eax,0x804148
  80237e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802381:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802387:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80238a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802391:	a1 54 41 80 00       	mov    0x804154,%eax
  802396:	48                   	dec    %eax
  802397:	a3 54 41 80 00       	mov    %eax,0x804154
			   point->sva += size;
  80239c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239f:	8b 50 08             	mov    0x8(%eax),%edx
  8023a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a5:	01 c2                	add    %eax,%edx
  8023a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023aa:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8023ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8023b3:	2b 45 08             	sub    0x8(%ebp),%eax
  8023b6:	89 c2                	mov    %eax,%edx
  8023b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023bb:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8023be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023c1:	eb 3b                	jmp    8023fe <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8023c3:	a1 40 41 80 00       	mov    0x804140,%eax
  8023c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023cf:	74 07                	je     8023d8 <alloc_block_FF+0x1a5>
  8023d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d4:	8b 00                	mov    (%eax),%eax
  8023d6:	eb 05                	jmp    8023dd <alloc_block_FF+0x1aa>
  8023d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8023dd:	a3 40 41 80 00       	mov    %eax,0x804140
  8023e2:	a1 40 41 80 00       	mov    0x804140,%eax
  8023e7:	85 c0                	test   %eax,%eax
  8023e9:	0f 85 57 fe ff ff    	jne    802246 <alloc_block_FF+0x13>
  8023ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023f3:	0f 85 4d fe ff ff    	jne    802246 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8023f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023fe:	c9                   	leave  
  8023ff:	c3                   	ret    

00802400 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802400:	55                   	push   %ebp
  802401:	89 e5                	mov    %esp,%ebp
  802403:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802406:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80240d:	a1 38 41 80 00       	mov    0x804138,%eax
  802412:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802415:	e9 df 00 00 00       	jmp    8024f9 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  80241a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241d:	8b 40 0c             	mov    0xc(%eax),%eax
  802420:	3b 45 08             	cmp    0x8(%ebp),%eax
  802423:	0f 82 c8 00 00 00    	jb     8024f1 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802429:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242c:	8b 40 0c             	mov    0xc(%eax),%eax
  80242f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802432:	0f 85 8a 00 00 00    	jne    8024c2 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802438:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80243c:	75 17                	jne    802455 <alloc_block_BF+0x55>
  80243e:	83 ec 04             	sub    $0x4,%esp
  802441:	68 c4 3f 80 00       	push   $0x803fc4
  802446:	68 b7 00 00 00       	push   $0xb7
  80244b:	68 1b 3f 80 00       	push   $0x803f1b
  802450:	e8 2a de ff ff       	call   80027f <_panic>
  802455:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802458:	8b 00                	mov    (%eax),%eax
  80245a:	85 c0                	test   %eax,%eax
  80245c:	74 10                	je     80246e <alloc_block_BF+0x6e>
  80245e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802461:	8b 00                	mov    (%eax),%eax
  802463:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802466:	8b 52 04             	mov    0x4(%edx),%edx
  802469:	89 50 04             	mov    %edx,0x4(%eax)
  80246c:	eb 0b                	jmp    802479 <alloc_block_BF+0x79>
  80246e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802471:	8b 40 04             	mov    0x4(%eax),%eax
  802474:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802479:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247c:	8b 40 04             	mov    0x4(%eax),%eax
  80247f:	85 c0                	test   %eax,%eax
  802481:	74 0f                	je     802492 <alloc_block_BF+0x92>
  802483:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802486:	8b 40 04             	mov    0x4(%eax),%eax
  802489:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80248c:	8b 12                	mov    (%edx),%edx
  80248e:	89 10                	mov    %edx,(%eax)
  802490:	eb 0a                	jmp    80249c <alloc_block_BF+0x9c>
  802492:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802495:	8b 00                	mov    (%eax),%eax
  802497:	a3 38 41 80 00       	mov    %eax,0x804138
  80249c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024af:	a1 44 41 80 00       	mov    0x804144,%eax
  8024b4:	48                   	dec    %eax
  8024b5:	a3 44 41 80 00       	mov    %eax,0x804144
			   return currentMemBlock;
  8024ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bd:	e9 4d 01 00 00       	jmp    80260f <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8024c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c5:	8b 40 0c             	mov    0xc(%eax),%eax
  8024c8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024cb:	76 24                	jbe    8024f1 <alloc_block_BF+0xf1>
  8024cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8024d3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8024d6:	73 19                	jae    8024f1 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8024d8:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8024df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8024e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8024e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024eb:	8b 40 08             	mov    0x8(%eax),%eax
  8024ee:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8024f1:	a1 40 41 80 00       	mov    0x804140,%eax
  8024f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024fd:	74 07                	je     802506 <alloc_block_BF+0x106>
  8024ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802502:	8b 00                	mov    (%eax),%eax
  802504:	eb 05                	jmp    80250b <alloc_block_BF+0x10b>
  802506:	b8 00 00 00 00       	mov    $0x0,%eax
  80250b:	a3 40 41 80 00       	mov    %eax,0x804140
  802510:	a1 40 41 80 00       	mov    0x804140,%eax
  802515:	85 c0                	test   %eax,%eax
  802517:	0f 85 fd fe ff ff    	jne    80241a <alloc_block_BF+0x1a>
  80251d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802521:	0f 85 f3 fe ff ff    	jne    80241a <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802527:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80252b:	0f 84 d9 00 00 00    	je     80260a <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802531:	a1 48 41 80 00       	mov    0x804148,%eax
  802536:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802539:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80253c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80253f:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802542:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802545:	8b 55 08             	mov    0x8(%ebp),%edx
  802548:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  80254b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80254f:	75 17                	jne    802568 <alloc_block_BF+0x168>
  802551:	83 ec 04             	sub    $0x4,%esp
  802554:	68 c4 3f 80 00       	push   $0x803fc4
  802559:	68 c7 00 00 00       	push   $0xc7
  80255e:	68 1b 3f 80 00       	push   $0x803f1b
  802563:	e8 17 dd ff ff       	call   80027f <_panic>
  802568:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80256b:	8b 00                	mov    (%eax),%eax
  80256d:	85 c0                	test   %eax,%eax
  80256f:	74 10                	je     802581 <alloc_block_BF+0x181>
  802571:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802574:	8b 00                	mov    (%eax),%eax
  802576:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802579:	8b 52 04             	mov    0x4(%edx),%edx
  80257c:	89 50 04             	mov    %edx,0x4(%eax)
  80257f:	eb 0b                	jmp    80258c <alloc_block_BF+0x18c>
  802581:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802584:	8b 40 04             	mov    0x4(%eax),%eax
  802587:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80258c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80258f:	8b 40 04             	mov    0x4(%eax),%eax
  802592:	85 c0                	test   %eax,%eax
  802594:	74 0f                	je     8025a5 <alloc_block_BF+0x1a5>
  802596:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802599:	8b 40 04             	mov    0x4(%eax),%eax
  80259c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80259f:	8b 12                	mov    (%edx),%edx
  8025a1:	89 10                	mov    %edx,(%eax)
  8025a3:	eb 0a                	jmp    8025af <alloc_block_BF+0x1af>
  8025a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025a8:	8b 00                	mov    (%eax),%eax
  8025aa:	a3 48 41 80 00       	mov    %eax,0x804148
  8025af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025bb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025c2:	a1 54 41 80 00       	mov    0x804154,%eax
  8025c7:	48                   	dec    %eax
  8025c8:	a3 54 41 80 00       	mov    %eax,0x804154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8025cd:	83 ec 08             	sub    $0x8,%esp
  8025d0:	ff 75 ec             	pushl  -0x14(%ebp)
  8025d3:	68 38 41 80 00       	push   $0x804138
  8025d8:	e8 71 f9 ff ff       	call   801f4e <find_block>
  8025dd:	83 c4 10             	add    $0x10,%esp
  8025e0:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8025e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025e6:	8b 50 08             	mov    0x8(%eax),%edx
  8025e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ec:	01 c2                	add    %eax,%edx
  8025ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025f1:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8025f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025f7:	8b 40 0c             	mov    0xc(%eax),%eax
  8025fa:	2b 45 08             	sub    0x8(%ebp),%eax
  8025fd:	89 c2                	mov    %eax,%edx
  8025ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802602:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802605:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802608:	eb 05                	jmp    80260f <alloc_block_BF+0x20f>
	}
	return NULL;
  80260a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80260f:	c9                   	leave  
  802610:	c3                   	ret    

00802611 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802611:	55                   	push   %ebp
  802612:	89 e5                	mov    %esp,%ebp
  802614:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802617:	a1 28 40 80 00       	mov    0x804028,%eax
  80261c:	85 c0                	test   %eax,%eax
  80261e:	0f 85 de 01 00 00    	jne    802802 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802624:	a1 38 41 80 00       	mov    0x804138,%eax
  802629:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80262c:	e9 9e 01 00 00       	jmp    8027cf <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802631:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802634:	8b 40 0c             	mov    0xc(%eax),%eax
  802637:	3b 45 08             	cmp    0x8(%ebp),%eax
  80263a:	0f 82 87 01 00 00    	jb     8027c7 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802640:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802643:	8b 40 0c             	mov    0xc(%eax),%eax
  802646:	3b 45 08             	cmp    0x8(%ebp),%eax
  802649:	0f 85 95 00 00 00    	jne    8026e4 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  80264f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802653:	75 17                	jne    80266c <alloc_block_NF+0x5b>
  802655:	83 ec 04             	sub    $0x4,%esp
  802658:	68 c4 3f 80 00       	push   $0x803fc4
  80265d:	68 e0 00 00 00       	push   $0xe0
  802662:	68 1b 3f 80 00       	push   $0x803f1b
  802667:	e8 13 dc ff ff       	call   80027f <_panic>
  80266c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266f:	8b 00                	mov    (%eax),%eax
  802671:	85 c0                	test   %eax,%eax
  802673:	74 10                	je     802685 <alloc_block_NF+0x74>
  802675:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802678:	8b 00                	mov    (%eax),%eax
  80267a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80267d:	8b 52 04             	mov    0x4(%edx),%edx
  802680:	89 50 04             	mov    %edx,0x4(%eax)
  802683:	eb 0b                	jmp    802690 <alloc_block_NF+0x7f>
  802685:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802688:	8b 40 04             	mov    0x4(%eax),%eax
  80268b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802690:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802693:	8b 40 04             	mov    0x4(%eax),%eax
  802696:	85 c0                	test   %eax,%eax
  802698:	74 0f                	je     8026a9 <alloc_block_NF+0x98>
  80269a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269d:	8b 40 04             	mov    0x4(%eax),%eax
  8026a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026a3:	8b 12                	mov    (%edx),%edx
  8026a5:	89 10                	mov    %edx,(%eax)
  8026a7:	eb 0a                	jmp    8026b3 <alloc_block_NF+0xa2>
  8026a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ac:	8b 00                	mov    (%eax),%eax
  8026ae:	a3 38 41 80 00       	mov    %eax,0x804138
  8026b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026c6:	a1 44 41 80 00       	mov    0x804144,%eax
  8026cb:	48                   	dec    %eax
  8026cc:	a3 44 41 80 00       	mov    %eax,0x804144
				   svaOfNF = point->sva;
  8026d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d4:	8b 40 08             	mov    0x8(%eax),%eax
  8026d7:	a3 28 40 80 00       	mov    %eax,0x804028
				   return  point;
  8026dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026df:	e9 f8 04 00 00       	jmp    802bdc <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8026e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e7:	8b 40 0c             	mov    0xc(%eax),%eax
  8026ea:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026ed:	0f 86 d4 00 00 00    	jbe    8027c7 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8026f3:	a1 48 41 80 00       	mov    0x804148,%eax
  8026f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8026fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fe:	8b 50 08             	mov    0x8(%eax),%edx
  802701:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802704:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802707:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80270a:	8b 55 08             	mov    0x8(%ebp),%edx
  80270d:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802710:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802714:	75 17                	jne    80272d <alloc_block_NF+0x11c>
  802716:	83 ec 04             	sub    $0x4,%esp
  802719:	68 c4 3f 80 00       	push   $0x803fc4
  80271e:	68 e9 00 00 00       	push   $0xe9
  802723:	68 1b 3f 80 00       	push   $0x803f1b
  802728:	e8 52 db ff ff       	call   80027f <_panic>
  80272d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802730:	8b 00                	mov    (%eax),%eax
  802732:	85 c0                	test   %eax,%eax
  802734:	74 10                	je     802746 <alloc_block_NF+0x135>
  802736:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802739:	8b 00                	mov    (%eax),%eax
  80273b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80273e:	8b 52 04             	mov    0x4(%edx),%edx
  802741:	89 50 04             	mov    %edx,0x4(%eax)
  802744:	eb 0b                	jmp    802751 <alloc_block_NF+0x140>
  802746:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802749:	8b 40 04             	mov    0x4(%eax),%eax
  80274c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802751:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802754:	8b 40 04             	mov    0x4(%eax),%eax
  802757:	85 c0                	test   %eax,%eax
  802759:	74 0f                	je     80276a <alloc_block_NF+0x159>
  80275b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80275e:	8b 40 04             	mov    0x4(%eax),%eax
  802761:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802764:	8b 12                	mov    (%edx),%edx
  802766:	89 10                	mov    %edx,(%eax)
  802768:	eb 0a                	jmp    802774 <alloc_block_NF+0x163>
  80276a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80276d:	8b 00                	mov    (%eax),%eax
  80276f:	a3 48 41 80 00       	mov    %eax,0x804148
  802774:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802777:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80277d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802780:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802787:	a1 54 41 80 00       	mov    0x804154,%eax
  80278c:	48                   	dec    %eax
  80278d:	a3 54 41 80 00       	mov    %eax,0x804154
				   svaOfNF = ReturnedBlock->sva;
  802792:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802795:	8b 40 08             	mov    0x8(%eax),%eax
  802798:	a3 28 40 80 00       	mov    %eax,0x804028
				   point->sva += size;
  80279d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a0:	8b 50 08             	mov    0x8(%eax),%edx
  8027a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a6:	01 c2                	add    %eax,%edx
  8027a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ab:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  8027ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b1:	8b 40 0c             	mov    0xc(%eax),%eax
  8027b4:	2b 45 08             	sub    0x8(%ebp),%eax
  8027b7:	89 c2                	mov    %eax,%edx
  8027b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027bc:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8027bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c2:	e9 15 04 00 00       	jmp    802bdc <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8027c7:	a1 40 41 80 00       	mov    0x804140,%eax
  8027cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027d3:	74 07                	je     8027dc <alloc_block_NF+0x1cb>
  8027d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d8:	8b 00                	mov    (%eax),%eax
  8027da:	eb 05                	jmp    8027e1 <alloc_block_NF+0x1d0>
  8027dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8027e1:	a3 40 41 80 00       	mov    %eax,0x804140
  8027e6:	a1 40 41 80 00       	mov    0x804140,%eax
  8027eb:	85 c0                	test   %eax,%eax
  8027ed:	0f 85 3e fe ff ff    	jne    802631 <alloc_block_NF+0x20>
  8027f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027f7:	0f 85 34 fe ff ff    	jne    802631 <alloc_block_NF+0x20>
  8027fd:	e9 d5 03 00 00       	jmp    802bd7 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802802:	a1 38 41 80 00       	mov    0x804138,%eax
  802807:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80280a:	e9 b1 01 00 00       	jmp    8029c0 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  80280f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802812:	8b 50 08             	mov    0x8(%eax),%edx
  802815:	a1 28 40 80 00       	mov    0x804028,%eax
  80281a:	39 c2                	cmp    %eax,%edx
  80281c:	0f 82 96 01 00 00    	jb     8029b8 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802822:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802825:	8b 40 0c             	mov    0xc(%eax),%eax
  802828:	3b 45 08             	cmp    0x8(%ebp),%eax
  80282b:	0f 82 87 01 00 00    	jb     8029b8 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802831:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802834:	8b 40 0c             	mov    0xc(%eax),%eax
  802837:	3b 45 08             	cmp    0x8(%ebp),%eax
  80283a:	0f 85 95 00 00 00    	jne    8028d5 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802840:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802844:	75 17                	jne    80285d <alloc_block_NF+0x24c>
  802846:	83 ec 04             	sub    $0x4,%esp
  802849:	68 c4 3f 80 00       	push   $0x803fc4
  80284e:	68 fc 00 00 00       	push   $0xfc
  802853:	68 1b 3f 80 00       	push   $0x803f1b
  802858:	e8 22 da ff ff       	call   80027f <_panic>
  80285d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802860:	8b 00                	mov    (%eax),%eax
  802862:	85 c0                	test   %eax,%eax
  802864:	74 10                	je     802876 <alloc_block_NF+0x265>
  802866:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802869:	8b 00                	mov    (%eax),%eax
  80286b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80286e:	8b 52 04             	mov    0x4(%edx),%edx
  802871:	89 50 04             	mov    %edx,0x4(%eax)
  802874:	eb 0b                	jmp    802881 <alloc_block_NF+0x270>
  802876:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802879:	8b 40 04             	mov    0x4(%eax),%eax
  80287c:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802881:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802884:	8b 40 04             	mov    0x4(%eax),%eax
  802887:	85 c0                	test   %eax,%eax
  802889:	74 0f                	je     80289a <alloc_block_NF+0x289>
  80288b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288e:	8b 40 04             	mov    0x4(%eax),%eax
  802891:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802894:	8b 12                	mov    (%edx),%edx
  802896:	89 10                	mov    %edx,(%eax)
  802898:	eb 0a                	jmp    8028a4 <alloc_block_NF+0x293>
  80289a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289d:	8b 00                	mov    (%eax),%eax
  80289f:	a3 38 41 80 00       	mov    %eax,0x804138
  8028a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028b7:	a1 44 41 80 00       	mov    0x804144,%eax
  8028bc:	48                   	dec    %eax
  8028bd:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  8028c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c5:	8b 40 08             	mov    0x8(%eax),%eax
  8028c8:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  8028cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d0:	e9 07 03 00 00       	jmp    802bdc <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8028d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d8:	8b 40 0c             	mov    0xc(%eax),%eax
  8028db:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028de:	0f 86 d4 00 00 00    	jbe    8029b8 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8028e4:	a1 48 41 80 00       	mov    0x804148,%eax
  8028e9:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  8028ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ef:	8b 50 08             	mov    0x8(%eax),%edx
  8028f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028f5:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8028f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8028fe:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802901:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802905:	75 17                	jne    80291e <alloc_block_NF+0x30d>
  802907:	83 ec 04             	sub    $0x4,%esp
  80290a:	68 c4 3f 80 00       	push   $0x803fc4
  80290f:	68 04 01 00 00       	push   $0x104
  802914:	68 1b 3f 80 00       	push   $0x803f1b
  802919:	e8 61 d9 ff ff       	call   80027f <_panic>
  80291e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802921:	8b 00                	mov    (%eax),%eax
  802923:	85 c0                	test   %eax,%eax
  802925:	74 10                	je     802937 <alloc_block_NF+0x326>
  802927:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80292a:	8b 00                	mov    (%eax),%eax
  80292c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80292f:	8b 52 04             	mov    0x4(%edx),%edx
  802932:	89 50 04             	mov    %edx,0x4(%eax)
  802935:	eb 0b                	jmp    802942 <alloc_block_NF+0x331>
  802937:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80293a:	8b 40 04             	mov    0x4(%eax),%eax
  80293d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802942:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802945:	8b 40 04             	mov    0x4(%eax),%eax
  802948:	85 c0                	test   %eax,%eax
  80294a:	74 0f                	je     80295b <alloc_block_NF+0x34a>
  80294c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80294f:	8b 40 04             	mov    0x4(%eax),%eax
  802952:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802955:	8b 12                	mov    (%edx),%edx
  802957:	89 10                	mov    %edx,(%eax)
  802959:	eb 0a                	jmp    802965 <alloc_block_NF+0x354>
  80295b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80295e:	8b 00                	mov    (%eax),%eax
  802960:	a3 48 41 80 00       	mov    %eax,0x804148
  802965:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802968:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80296e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802971:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802978:	a1 54 41 80 00       	mov    0x804154,%eax
  80297d:	48                   	dec    %eax
  80297e:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  802983:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802986:	8b 40 08             	mov    0x8(%eax),%eax
  802989:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  80298e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802991:	8b 50 08             	mov    0x8(%eax),%edx
  802994:	8b 45 08             	mov    0x8(%ebp),%eax
  802997:	01 c2                	add    %eax,%edx
  802999:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299c:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  80299f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a2:	8b 40 0c             	mov    0xc(%eax),%eax
  8029a5:	2b 45 08             	sub    0x8(%ebp),%eax
  8029a8:	89 c2                	mov    %eax,%edx
  8029aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ad:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8029b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029b3:	e9 24 02 00 00       	jmp    802bdc <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8029b8:	a1 40 41 80 00       	mov    0x804140,%eax
  8029bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029c4:	74 07                	je     8029cd <alloc_block_NF+0x3bc>
  8029c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c9:	8b 00                	mov    (%eax),%eax
  8029cb:	eb 05                	jmp    8029d2 <alloc_block_NF+0x3c1>
  8029cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8029d2:	a3 40 41 80 00       	mov    %eax,0x804140
  8029d7:	a1 40 41 80 00       	mov    0x804140,%eax
  8029dc:	85 c0                	test   %eax,%eax
  8029de:	0f 85 2b fe ff ff    	jne    80280f <alloc_block_NF+0x1fe>
  8029e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029e8:	0f 85 21 fe ff ff    	jne    80280f <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8029ee:	a1 38 41 80 00       	mov    0x804138,%eax
  8029f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029f6:	e9 ae 01 00 00       	jmp    802ba9 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  8029fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fe:	8b 50 08             	mov    0x8(%eax),%edx
  802a01:	a1 28 40 80 00       	mov    0x804028,%eax
  802a06:	39 c2                	cmp    %eax,%edx
  802a08:	0f 83 93 01 00 00    	jae    802ba1 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802a0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a11:	8b 40 0c             	mov    0xc(%eax),%eax
  802a14:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a17:	0f 82 84 01 00 00    	jb     802ba1 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802a1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a20:	8b 40 0c             	mov    0xc(%eax),%eax
  802a23:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a26:	0f 85 95 00 00 00    	jne    802ac1 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802a2c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a30:	75 17                	jne    802a49 <alloc_block_NF+0x438>
  802a32:	83 ec 04             	sub    $0x4,%esp
  802a35:	68 c4 3f 80 00       	push   $0x803fc4
  802a3a:	68 14 01 00 00       	push   $0x114
  802a3f:	68 1b 3f 80 00       	push   $0x803f1b
  802a44:	e8 36 d8 ff ff       	call   80027f <_panic>
  802a49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4c:	8b 00                	mov    (%eax),%eax
  802a4e:	85 c0                	test   %eax,%eax
  802a50:	74 10                	je     802a62 <alloc_block_NF+0x451>
  802a52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a55:	8b 00                	mov    (%eax),%eax
  802a57:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a5a:	8b 52 04             	mov    0x4(%edx),%edx
  802a5d:	89 50 04             	mov    %edx,0x4(%eax)
  802a60:	eb 0b                	jmp    802a6d <alloc_block_NF+0x45c>
  802a62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a65:	8b 40 04             	mov    0x4(%eax),%eax
  802a68:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a70:	8b 40 04             	mov    0x4(%eax),%eax
  802a73:	85 c0                	test   %eax,%eax
  802a75:	74 0f                	je     802a86 <alloc_block_NF+0x475>
  802a77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7a:	8b 40 04             	mov    0x4(%eax),%eax
  802a7d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a80:	8b 12                	mov    (%edx),%edx
  802a82:	89 10                	mov    %edx,(%eax)
  802a84:	eb 0a                	jmp    802a90 <alloc_block_NF+0x47f>
  802a86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a89:	8b 00                	mov    (%eax),%eax
  802a8b:	a3 38 41 80 00       	mov    %eax,0x804138
  802a90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a93:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802aa3:	a1 44 41 80 00       	mov    0x804144,%eax
  802aa8:	48                   	dec    %eax
  802aa9:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  802aae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab1:	8b 40 08             	mov    0x8(%eax),%eax
  802ab4:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  802ab9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abc:	e9 1b 01 00 00       	jmp    802bdc <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802ac1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac4:	8b 40 0c             	mov    0xc(%eax),%eax
  802ac7:	3b 45 08             	cmp    0x8(%ebp),%eax
  802aca:	0f 86 d1 00 00 00    	jbe    802ba1 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802ad0:	a1 48 41 80 00       	mov    0x804148,%eax
  802ad5:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802ad8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802adb:	8b 50 08             	mov    0x8(%eax),%edx
  802ade:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ae1:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802ae4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ae7:	8b 55 08             	mov    0x8(%ebp),%edx
  802aea:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802aed:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802af1:	75 17                	jne    802b0a <alloc_block_NF+0x4f9>
  802af3:	83 ec 04             	sub    $0x4,%esp
  802af6:	68 c4 3f 80 00       	push   $0x803fc4
  802afb:	68 1c 01 00 00       	push   $0x11c
  802b00:	68 1b 3f 80 00       	push   $0x803f1b
  802b05:	e8 75 d7 ff ff       	call   80027f <_panic>
  802b0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b0d:	8b 00                	mov    (%eax),%eax
  802b0f:	85 c0                	test   %eax,%eax
  802b11:	74 10                	je     802b23 <alloc_block_NF+0x512>
  802b13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b16:	8b 00                	mov    (%eax),%eax
  802b18:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b1b:	8b 52 04             	mov    0x4(%edx),%edx
  802b1e:	89 50 04             	mov    %edx,0x4(%eax)
  802b21:	eb 0b                	jmp    802b2e <alloc_block_NF+0x51d>
  802b23:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b26:	8b 40 04             	mov    0x4(%eax),%eax
  802b29:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b31:	8b 40 04             	mov    0x4(%eax),%eax
  802b34:	85 c0                	test   %eax,%eax
  802b36:	74 0f                	je     802b47 <alloc_block_NF+0x536>
  802b38:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b3b:	8b 40 04             	mov    0x4(%eax),%eax
  802b3e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b41:	8b 12                	mov    (%edx),%edx
  802b43:	89 10                	mov    %edx,(%eax)
  802b45:	eb 0a                	jmp    802b51 <alloc_block_NF+0x540>
  802b47:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b4a:	8b 00                	mov    (%eax),%eax
  802b4c:	a3 48 41 80 00       	mov    %eax,0x804148
  802b51:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b54:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b5d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b64:	a1 54 41 80 00       	mov    0x804154,%eax
  802b69:	48                   	dec    %eax
  802b6a:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  802b6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b72:	8b 40 08             	mov    0x8(%eax),%eax
  802b75:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  802b7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7d:	8b 50 08             	mov    0x8(%eax),%edx
  802b80:	8b 45 08             	mov    0x8(%ebp),%eax
  802b83:	01 c2                	add    %eax,%edx
  802b85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b88:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802b8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8e:	8b 40 0c             	mov    0xc(%eax),%eax
  802b91:	2b 45 08             	sub    0x8(%ebp),%eax
  802b94:	89 c2                	mov    %eax,%edx
  802b96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b99:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802b9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b9f:	eb 3b                	jmp    802bdc <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802ba1:	a1 40 41 80 00       	mov    0x804140,%eax
  802ba6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ba9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bad:	74 07                	je     802bb6 <alloc_block_NF+0x5a5>
  802baf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb2:	8b 00                	mov    (%eax),%eax
  802bb4:	eb 05                	jmp    802bbb <alloc_block_NF+0x5aa>
  802bb6:	b8 00 00 00 00       	mov    $0x0,%eax
  802bbb:	a3 40 41 80 00       	mov    %eax,0x804140
  802bc0:	a1 40 41 80 00       	mov    0x804140,%eax
  802bc5:	85 c0                	test   %eax,%eax
  802bc7:	0f 85 2e fe ff ff    	jne    8029fb <alloc_block_NF+0x3ea>
  802bcd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bd1:	0f 85 24 fe ff ff    	jne    8029fb <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802bd7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bdc:	c9                   	leave  
  802bdd:	c3                   	ret    

00802bde <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802bde:	55                   	push   %ebp
  802bdf:	89 e5                	mov    %esp,%ebp
  802be1:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802be4:	a1 38 41 80 00       	mov    0x804138,%eax
  802be9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802bec:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802bf1:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802bf4:	a1 38 41 80 00       	mov    0x804138,%eax
  802bf9:	85 c0                	test   %eax,%eax
  802bfb:	74 14                	je     802c11 <insert_sorted_with_merge_freeList+0x33>
  802bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  802c00:	8b 50 08             	mov    0x8(%eax),%edx
  802c03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c06:	8b 40 08             	mov    0x8(%eax),%eax
  802c09:	39 c2                	cmp    %eax,%edx
  802c0b:	0f 87 9b 01 00 00    	ja     802dac <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802c11:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c15:	75 17                	jne    802c2e <insert_sorted_with_merge_freeList+0x50>
  802c17:	83 ec 04             	sub    $0x4,%esp
  802c1a:	68 f8 3e 80 00       	push   $0x803ef8
  802c1f:	68 38 01 00 00       	push   $0x138
  802c24:	68 1b 3f 80 00       	push   $0x803f1b
  802c29:	e8 51 d6 ff ff       	call   80027f <_panic>
  802c2e:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802c34:	8b 45 08             	mov    0x8(%ebp),%eax
  802c37:	89 10                	mov    %edx,(%eax)
  802c39:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3c:	8b 00                	mov    (%eax),%eax
  802c3e:	85 c0                	test   %eax,%eax
  802c40:	74 0d                	je     802c4f <insert_sorted_with_merge_freeList+0x71>
  802c42:	a1 38 41 80 00       	mov    0x804138,%eax
  802c47:	8b 55 08             	mov    0x8(%ebp),%edx
  802c4a:	89 50 04             	mov    %edx,0x4(%eax)
  802c4d:	eb 08                	jmp    802c57 <insert_sorted_with_merge_freeList+0x79>
  802c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c52:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c57:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5a:	a3 38 41 80 00       	mov    %eax,0x804138
  802c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c62:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c69:	a1 44 41 80 00       	mov    0x804144,%eax
  802c6e:	40                   	inc    %eax
  802c6f:	a3 44 41 80 00       	mov    %eax,0x804144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802c74:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c78:	0f 84 a8 06 00 00    	je     803326 <insert_sorted_with_merge_freeList+0x748>
  802c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c81:	8b 50 08             	mov    0x8(%eax),%edx
  802c84:	8b 45 08             	mov    0x8(%ebp),%eax
  802c87:	8b 40 0c             	mov    0xc(%eax),%eax
  802c8a:	01 c2                	add    %eax,%edx
  802c8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c8f:	8b 40 08             	mov    0x8(%eax),%eax
  802c92:	39 c2                	cmp    %eax,%edx
  802c94:	0f 85 8c 06 00 00    	jne    803326 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802c9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9d:	8b 50 0c             	mov    0xc(%eax),%edx
  802ca0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ca3:	8b 40 0c             	mov    0xc(%eax),%eax
  802ca6:	01 c2                	add    %eax,%edx
  802ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  802cab:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802cae:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cb2:	75 17                	jne    802ccb <insert_sorted_with_merge_freeList+0xed>
  802cb4:	83 ec 04             	sub    $0x4,%esp
  802cb7:	68 c4 3f 80 00       	push   $0x803fc4
  802cbc:	68 3c 01 00 00       	push   $0x13c
  802cc1:	68 1b 3f 80 00       	push   $0x803f1b
  802cc6:	e8 b4 d5 ff ff       	call   80027f <_panic>
  802ccb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cce:	8b 00                	mov    (%eax),%eax
  802cd0:	85 c0                	test   %eax,%eax
  802cd2:	74 10                	je     802ce4 <insert_sorted_with_merge_freeList+0x106>
  802cd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cd7:	8b 00                	mov    (%eax),%eax
  802cd9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cdc:	8b 52 04             	mov    0x4(%edx),%edx
  802cdf:	89 50 04             	mov    %edx,0x4(%eax)
  802ce2:	eb 0b                	jmp    802cef <insert_sorted_with_merge_freeList+0x111>
  802ce4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ce7:	8b 40 04             	mov    0x4(%eax),%eax
  802cea:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802cef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf2:	8b 40 04             	mov    0x4(%eax),%eax
  802cf5:	85 c0                	test   %eax,%eax
  802cf7:	74 0f                	je     802d08 <insert_sorted_with_merge_freeList+0x12a>
  802cf9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cfc:	8b 40 04             	mov    0x4(%eax),%eax
  802cff:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d02:	8b 12                	mov    (%edx),%edx
  802d04:	89 10                	mov    %edx,(%eax)
  802d06:	eb 0a                	jmp    802d12 <insert_sorted_with_merge_freeList+0x134>
  802d08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d0b:	8b 00                	mov    (%eax),%eax
  802d0d:	a3 38 41 80 00       	mov    %eax,0x804138
  802d12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d15:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d1e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d25:	a1 44 41 80 00       	mov    0x804144,%eax
  802d2a:	48                   	dec    %eax
  802d2b:	a3 44 41 80 00       	mov    %eax,0x804144
			head->size = 0;
  802d30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d33:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802d3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d3d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802d44:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d48:	75 17                	jne    802d61 <insert_sorted_with_merge_freeList+0x183>
  802d4a:	83 ec 04             	sub    $0x4,%esp
  802d4d:	68 f8 3e 80 00       	push   $0x803ef8
  802d52:	68 3f 01 00 00       	push   $0x13f
  802d57:	68 1b 3f 80 00       	push   $0x803f1b
  802d5c:	e8 1e d5 ff ff       	call   80027f <_panic>
  802d61:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d6a:	89 10                	mov    %edx,(%eax)
  802d6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d6f:	8b 00                	mov    (%eax),%eax
  802d71:	85 c0                	test   %eax,%eax
  802d73:	74 0d                	je     802d82 <insert_sorted_with_merge_freeList+0x1a4>
  802d75:	a1 48 41 80 00       	mov    0x804148,%eax
  802d7a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d7d:	89 50 04             	mov    %edx,0x4(%eax)
  802d80:	eb 08                	jmp    802d8a <insert_sorted_with_merge_freeList+0x1ac>
  802d82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d85:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d8d:	a3 48 41 80 00       	mov    %eax,0x804148
  802d92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d95:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d9c:	a1 54 41 80 00       	mov    0x804154,%eax
  802da1:	40                   	inc    %eax
  802da2:	a3 54 41 80 00       	mov    %eax,0x804154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802da7:	e9 7a 05 00 00       	jmp    803326 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802dac:	8b 45 08             	mov    0x8(%ebp),%eax
  802daf:	8b 50 08             	mov    0x8(%eax),%edx
  802db2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802db5:	8b 40 08             	mov    0x8(%eax),%eax
  802db8:	39 c2                	cmp    %eax,%edx
  802dba:	0f 82 14 01 00 00    	jb     802ed4 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802dc0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dc3:	8b 50 08             	mov    0x8(%eax),%edx
  802dc6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dc9:	8b 40 0c             	mov    0xc(%eax),%eax
  802dcc:	01 c2                	add    %eax,%edx
  802dce:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd1:	8b 40 08             	mov    0x8(%eax),%eax
  802dd4:	39 c2                	cmp    %eax,%edx
  802dd6:	0f 85 90 00 00 00    	jne    802e6c <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802ddc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ddf:	8b 50 0c             	mov    0xc(%eax),%edx
  802de2:	8b 45 08             	mov    0x8(%ebp),%eax
  802de5:	8b 40 0c             	mov    0xc(%eax),%eax
  802de8:	01 c2                	add    %eax,%edx
  802dea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ded:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802df0:	8b 45 08             	mov    0x8(%ebp),%eax
  802df3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802e04:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e08:	75 17                	jne    802e21 <insert_sorted_with_merge_freeList+0x243>
  802e0a:	83 ec 04             	sub    $0x4,%esp
  802e0d:	68 f8 3e 80 00       	push   $0x803ef8
  802e12:	68 49 01 00 00       	push   $0x149
  802e17:	68 1b 3f 80 00       	push   $0x803f1b
  802e1c:	e8 5e d4 ff ff       	call   80027f <_panic>
  802e21:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e27:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2a:	89 10                	mov    %edx,(%eax)
  802e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2f:	8b 00                	mov    (%eax),%eax
  802e31:	85 c0                	test   %eax,%eax
  802e33:	74 0d                	je     802e42 <insert_sorted_with_merge_freeList+0x264>
  802e35:	a1 48 41 80 00       	mov    0x804148,%eax
  802e3a:	8b 55 08             	mov    0x8(%ebp),%edx
  802e3d:	89 50 04             	mov    %edx,0x4(%eax)
  802e40:	eb 08                	jmp    802e4a <insert_sorted_with_merge_freeList+0x26c>
  802e42:	8b 45 08             	mov    0x8(%ebp),%eax
  802e45:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4d:	a3 48 41 80 00       	mov    %eax,0x804148
  802e52:	8b 45 08             	mov    0x8(%ebp),%eax
  802e55:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e5c:	a1 54 41 80 00       	mov    0x804154,%eax
  802e61:	40                   	inc    %eax
  802e62:	a3 54 41 80 00       	mov    %eax,0x804154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802e67:	e9 bb 04 00 00       	jmp    803327 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802e6c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e70:	75 17                	jne    802e89 <insert_sorted_with_merge_freeList+0x2ab>
  802e72:	83 ec 04             	sub    $0x4,%esp
  802e75:	68 6c 3f 80 00       	push   $0x803f6c
  802e7a:	68 4c 01 00 00       	push   $0x14c
  802e7f:	68 1b 3f 80 00       	push   $0x803f1b
  802e84:	e8 f6 d3 ff ff       	call   80027f <_panic>
  802e89:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e92:	89 50 04             	mov    %edx,0x4(%eax)
  802e95:	8b 45 08             	mov    0x8(%ebp),%eax
  802e98:	8b 40 04             	mov    0x4(%eax),%eax
  802e9b:	85 c0                	test   %eax,%eax
  802e9d:	74 0c                	je     802eab <insert_sorted_with_merge_freeList+0x2cd>
  802e9f:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802ea4:	8b 55 08             	mov    0x8(%ebp),%edx
  802ea7:	89 10                	mov    %edx,(%eax)
  802ea9:	eb 08                	jmp    802eb3 <insert_sorted_with_merge_freeList+0x2d5>
  802eab:	8b 45 08             	mov    0x8(%ebp),%eax
  802eae:	a3 38 41 80 00       	mov    %eax,0x804138
  802eb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb6:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ec4:	a1 44 41 80 00       	mov    0x804144,%eax
  802ec9:	40                   	inc    %eax
  802eca:	a3 44 41 80 00       	mov    %eax,0x804144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802ecf:	e9 53 04 00 00       	jmp    803327 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802ed4:	a1 38 41 80 00       	mov    0x804138,%eax
  802ed9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802edc:	e9 15 04 00 00       	jmp    8032f6 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802ee1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee4:	8b 00                	mov    (%eax),%eax
  802ee6:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802ee9:	8b 45 08             	mov    0x8(%ebp),%eax
  802eec:	8b 50 08             	mov    0x8(%eax),%edx
  802eef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef2:	8b 40 08             	mov    0x8(%eax),%eax
  802ef5:	39 c2                	cmp    %eax,%edx
  802ef7:	0f 86 f1 03 00 00    	jbe    8032ee <insert_sorted_with_merge_freeList+0x710>
  802efd:	8b 45 08             	mov    0x8(%ebp),%eax
  802f00:	8b 50 08             	mov    0x8(%eax),%edx
  802f03:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f06:	8b 40 08             	mov    0x8(%eax),%eax
  802f09:	39 c2                	cmp    %eax,%edx
  802f0b:	0f 83 dd 03 00 00    	jae    8032ee <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802f11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f14:	8b 50 08             	mov    0x8(%eax),%edx
  802f17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1a:	8b 40 0c             	mov    0xc(%eax),%eax
  802f1d:	01 c2                	add    %eax,%edx
  802f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f22:	8b 40 08             	mov    0x8(%eax),%eax
  802f25:	39 c2                	cmp    %eax,%edx
  802f27:	0f 85 b9 01 00 00    	jne    8030e6 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f30:	8b 50 08             	mov    0x8(%eax),%edx
  802f33:	8b 45 08             	mov    0x8(%ebp),%eax
  802f36:	8b 40 0c             	mov    0xc(%eax),%eax
  802f39:	01 c2                	add    %eax,%edx
  802f3b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f3e:	8b 40 08             	mov    0x8(%eax),%eax
  802f41:	39 c2                	cmp    %eax,%edx
  802f43:	0f 85 0d 01 00 00    	jne    803056 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802f49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4c:	8b 50 0c             	mov    0xc(%eax),%edx
  802f4f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f52:	8b 40 0c             	mov    0xc(%eax),%eax
  802f55:	01 c2                	add    %eax,%edx
  802f57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5a:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802f5d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f61:	75 17                	jne    802f7a <insert_sorted_with_merge_freeList+0x39c>
  802f63:	83 ec 04             	sub    $0x4,%esp
  802f66:	68 c4 3f 80 00       	push   $0x803fc4
  802f6b:	68 5c 01 00 00       	push   $0x15c
  802f70:	68 1b 3f 80 00       	push   $0x803f1b
  802f75:	e8 05 d3 ff ff       	call   80027f <_panic>
  802f7a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f7d:	8b 00                	mov    (%eax),%eax
  802f7f:	85 c0                	test   %eax,%eax
  802f81:	74 10                	je     802f93 <insert_sorted_with_merge_freeList+0x3b5>
  802f83:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f86:	8b 00                	mov    (%eax),%eax
  802f88:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f8b:	8b 52 04             	mov    0x4(%edx),%edx
  802f8e:	89 50 04             	mov    %edx,0x4(%eax)
  802f91:	eb 0b                	jmp    802f9e <insert_sorted_with_merge_freeList+0x3c0>
  802f93:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f96:	8b 40 04             	mov    0x4(%eax),%eax
  802f99:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802f9e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fa1:	8b 40 04             	mov    0x4(%eax),%eax
  802fa4:	85 c0                	test   %eax,%eax
  802fa6:	74 0f                	je     802fb7 <insert_sorted_with_merge_freeList+0x3d9>
  802fa8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fab:	8b 40 04             	mov    0x4(%eax),%eax
  802fae:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fb1:	8b 12                	mov    (%edx),%edx
  802fb3:	89 10                	mov    %edx,(%eax)
  802fb5:	eb 0a                	jmp    802fc1 <insert_sorted_with_merge_freeList+0x3e3>
  802fb7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fba:	8b 00                	mov    (%eax),%eax
  802fbc:	a3 38 41 80 00       	mov    %eax,0x804138
  802fc1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fc4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fcd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fd4:	a1 44 41 80 00       	mov    0x804144,%eax
  802fd9:	48                   	dec    %eax
  802fda:	a3 44 41 80 00       	mov    %eax,0x804144
						nextBlock->sva = 0;
  802fdf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fe2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  802fe9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fec:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  802ff3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ff7:	75 17                	jne    803010 <insert_sorted_with_merge_freeList+0x432>
  802ff9:	83 ec 04             	sub    $0x4,%esp
  802ffc:	68 f8 3e 80 00       	push   $0x803ef8
  803001:	68 5f 01 00 00       	push   $0x15f
  803006:	68 1b 3f 80 00       	push   $0x803f1b
  80300b:	e8 6f d2 ff ff       	call   80027f <_panic>
  803010:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803016:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803019:	89 10                	mov    %edx,(%eax)
  80301b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80301e:	8b 00                	mov    (%eax),%eax
  803020:	85 c0                	test   %eax,%eax
  803022:	74 0d                	je     803031 <insert_sorted_with_merge_freeList+0x453>
  803024:	a1 48 41 80 00       	mov    0x804148,%eax
  803029:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80302c:	89 50 04             	mov    %edx,0x4(%eax)
  80302f:	eb 08                	jmp    803039 <insert_sorted_with_merge_freeList+0x45b>
  803031:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803034:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803039:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80303c:	a3 48 41 80 00       	mov    %eax,0x804148
  803041:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803044:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80304b:	a1 54 41 80 00       	mov    0x804154,%eax
  803050:	40                   	inc    %eax
  803051:	a3 54 41 80 00       	mov    %eax,0x804154
					}
					currentBlock->size += blockToInsert->size;
  803056:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803059:	8b 50 0c             	mov    0xc(%eax),%edx
  80305c:	8b 45 08             	mov    0x8(%ebp),%eax
  80305f:	8b 40 0c             	mov    0xc(%eax),%eax
  803062:	01 c2                	add    %eax,%edx
  803064:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803067:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  80306a:	8b 45 08             	mov    0x8(%ebp),%eax
  80306d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803074:	8b 45 08             	mov    0x8(%ebp),%eax
  803077:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80307e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803082:	75 17                	jne    80309b <insert_sorted_with_merge_freeList+0x4bd>
  803084:	83 ec 04             	sub    $0x4,%esp
  803087:	68 f8 3e 80 00       	push   $0x803ef8
  80308c:	68 64 01 00 00       	push   $0x164
  803091:	68 1b 3f 80 00       	push   $0x803f1b
  803096:	e8 e4 d1 ff ff       	call   80027f <_panic>
  80309b:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8030a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a4:	89 10                	mov    %edx,(%eax)
  8030a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a9:	8b 00                	mov    (%eax),%eax
  8030ab:	85 c0                	test   %eax,%eax
  8030ad:	74 0d                	je     8030bc <insert_sorted_with_merge_freeList+0x4de>
  8030af:	a1 48 41 80 00       	mov    0x804148,%eax
  8030b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8030b7:	89 50 04             	mov    %edx,0x4(%eax)
  8030ba:	eb 08                	jmp    8030c4 <insert_sorted_with_merge_freeList+0x4e6>
  8030bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8030bf:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8030c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c7:	a3 48 41 80 00       	mov    %eax,0x804148
  8030cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8030cf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030d6:	a1 54 41 80 00       	mov    0x804154,%eax
  8030db:	40                   	inc    %eax
  8030dc:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  8030e1:	e9 41 02 00 00       	jmp    803327 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8030e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e9:	8b 50 08             	mov    0x8(%eax),%edx
  8030ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ef:	8b 40 0c             	mov    0xc(%eax),%eax
  8030f2:	01 c2                	add    %eax,%edx
  8030f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030f7:	8b 40 08             	mov    0x8(%eax),%eax
  8030fa:	39 c2                	cmp    %eax,%edx
  8030fc:	0f 85 7c 01 00 00    	jne    80327e <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803102:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803106:	74 06                	je     80310e <insert_sorted_with_merge_freeList+0x530>
  803108:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80310c:	75 17                	jne    803125 <insert_sorted_with_merge_freeList+0x547>
  80310e:	83 ec 04             	sub    $0x4,%esp
  803111:	68 34 3f 80 00       	push   $0x803f34
  803116:	68 69 01 00 00       	push   $0x169
  80311b:	68 1b 3f 80 00       	push   $0x803f1b
  803120:	e8 5a d1 ff ff       	call   80027f <_panic>
  803125:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803128:	8b 50 04             	mov    0x4(%eax),%edx
  80312b:	8b 45 08             	mov    0x8(%ebp),%eax
  80312e:	89 50 04             	mov    %edx,0x4(%eax)
  803131:	8b 45 08             	mov    0x8(%ebp),%eax
  803134:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803137:	89 10                	mov    %edx,(%eax)
  803139:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80313c:	8b 40 04             	mov    0x4(%eax),%eax
  80313f:	85 c0                	test   %eax,%eax
  803141:	74 0d                	je     803150 <insert_sorted_with_merge_freeList+0x572>
  803143:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803146:	8b 40 04             	mov    0x4(%eax),%eax
  803149:	8b 55 08             	mov    0x8(%ebp),%edx
  80314c:	89 10                	mov    %edx,(%eax)
  80314e:	eb 08                	jmp    803158 <insert_sorted_with_merge_freeList+0x57a>
  803150:	8b 45 08             	mov    0x8(%ebp),%eax
  803153:	a3 38 41 80 00       	mov    %eax,0x804138
  803158:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80315b:	8b 55 08             	mov    0x8(%ebp),%edx
  80315e:	89 50 04             	mov    %edx,0x4(%eax)
  803161:	a1 44 41 80 00       	mov    0x804144,%eax
  803166:	40                   	inc    %eax
  803167:	a3 44 41 80 00       	mov    %eax,0x804144
					blockToInsert->size += nextBlock->size;
  80316c:	8b 45 08             	mov    0x8(%ebp),%eax
  80316f:	8b 50 0c             	mov    0xc(%eax),%edx
  803172:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803175:	8b 40 0c             	mov    0xc(%eax),%eax
  803178:	01 c2                	add    %eax,%edx
  80317a:	8b 45 08             	mov    0x8(%ebp),%eax
  80317d:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803180:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803184:	75 17                	jne    80319d <insert_sorted_with_merge_freeList+0x5bf>
  803186:	83 ec 04             	sub    $0x4,%esp
  803189:	68 c4 3f 80 00       	push   $0x803fc4
  80318e:	68 6b 01 00 00       	push   $0x16b
  803193:	68 1b 3f 80 00       	push   $0x803f1b
  803198:	e8 e2 d0 ff ff       	call   80027f <_panic>
  80319d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031a0:	8b 00                	mov    (%eax),%eax
  8031a2:	85 c0                	test   %eax,%eax
  8031a4:	74 10                	je     8031b6 <insert_sorted_with_merge_freeList+0x5d8>
  8031a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031a9:	8b 00                	mov    (%eax),%eax
  8031ab:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031ae:	8b 52 04             	mov    0x4(%edx),%edx
  8031b1:	89 50 04             	mov    %edx,0x4(%eax)
  8031b4:	eb 0b                	jmp    8031c1 <insert_sorted_with_merge_freeList+0x5e3>
  8031b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031b9:	8b 40 04             	mov    0x4(%eax),%eax
  8031bc:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8031c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c4:	8b 40 04             	mov    0x4(%eax),%eax
  8031c7:	85 c0                	test   %eax,%eax
  8031c9:	74 0f                	je     8031da <insert_sorted_with_merge_freeList+0x5fc>
  8031cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ce:	8b 40 04             	mov    0x4(%eax),%eax
  8031d1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031d4:	8b 12                	mov    (%edx),%edx
  8031d6:	89 10                	mov    %edx,(%eax)
  8031d8:	eb 0a                	jmp    8031e4 <insert_sorted_with_merge_freeList+0x606>
  8031da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031dd:	8b 00                	mov    (%eax),%eax
  8031df:	a3 38 41 80 00       	mov    %eax,0x804138
  8031e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031f7:	a1 44 41 80 00       	mov    0x804144,%eax
  8031fc:	48                   	dec    %eax
  8031fd:	a3 44 41 80 00       	mov    %eax,0x804144
					nextBlock->sva = 0;
  803202:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803205:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  80320c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80320f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803216:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80321a:	75 17                	jne    803233 <insert_sorted_with_merge_freeList+0x655>
  80321c:	83 ec 04             	sub    $0x4,%esp
  80321f:	68 f8 3e 80 00       	push   $0x803ef8
  803224:	68 6e 01 00 00       	push   $0x16e
  803229:	68 1b 3f 80 00       	push   $0x803f1b
  80322e:	e8 4c d0 ff ff       	call   80027f <_panic>
  803233:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803239:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80323c:	89 10                	mov    %edx,(%eax)
  80323e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803241:	8b 00                	mov    (%eax),%eax
  803243:	85 c0                	test   %eax,%eax
  803245:	74 0d                	je     803254 <insert_sorted_with_merge_freeList+0x676>
  803247:	a1 48 41 80 00       	mov    0x804148,%eax
  80324c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80324f:	89 50 04             	mov    %edx,0x4(%eax)
  803252:	eb 08                	jmp    80325c <insert_sorted_with_merge_freeList+0x67e>
  803254:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803257:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80325c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80325f:	a3 48 41 80 00       	mov    %eax,0x804148
  803264:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803267:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80326e:	a1 54 41 80 00       	mov    0x804154,%eax
  803273:	40                   	inc    %eax
  803274:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  803279:	e9 a9 00 00 00       	jmp    803327 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  80327e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803282:	74 06                	je     80328a <insert_sorted_with_merge_freeList+0x6ac>
  803284:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803288:	75 17                	jne    8032a1 <insert_sorted_with_merge_freeList+0x6c3>
  80328a:	83 ec 04             	sub    $0x4,%esp
  80328d:	68 90 3f 80 00       	push   $0x803f90
  803292:	68 73 01 00 00       	push   $0x173
  803297:	68 1b 3f 80 00       	push   $0x803f1b
  80329c:	e8 de cf ff ff       	call   80027f <_panic>
  8032a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a4:	8b 10                	mov    (%eax),%edx
  8032a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a9:	89 10                	mov    %edx,(%eax)
  8032ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ae:	8b 00                	mov    (%eax),%eax
  8032b0:	85 c0                	test   %eax,%eax
  8032b2:	74 0b                	je     8032bf <insert_sorted_with_merge_freeList+0x6e1>
  8032b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b7:	8b 00                	mov    (%eax),%eax
  8032b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8032bc:	89 50 04             	mov    %edx,0x4(%eax)
  8032bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8032c5:	89 10                	mov    %edx,(%eax)
  8032c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032cd:	89 50 04             	mov    %edx,0x4(%eax)
  8032d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d3:	8b 00                	mov    (%eax),%eax
  8032d5:	85 c0                	test   %eax,%eax
  8032d7:	75 08                	jne    8032e1 <insert_sorted_with_merge_freeList+0x703>
  8032d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032dc:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8032e1:	a1 44 41 80 00       	mov    0x804144,%eax
  8032e6:	40                   	inc    %eax
  8032e7:	a3 44 41 80 00       	mov    %eax,0x804144
					break;
  8032ec:	eb 39                	jmp    803327 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8032ee:	a1 40 41 80 00       	mov    0x804140,%eax
  8032f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032fa:	74 07                	je     803303 <insert_sorted_with_merge_freeList+0x725>
  8032fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ff:	8b 00                	mov    (%eax),%eax
  803301:	eb 05                	jmp    803308 <insert_sorted_with_merge_freeList+0x72a>
  803303:	b8 00 00 00 00       	mov    $0x0,%eax
  803308:	a3 40 41 80 00       	mov    %eax,0x804140
  80330d:	a1 40 41 80 00       	mov    0x804140,%eax
  803312:	85 c0                	test   %eax,%eax
  803314:	0f 85 c7 fb ff ff    	jne    802ee1 <insert_sorted_with_merge_freeList+0x303>
  80331a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80331e:	0f 85 bd fb ff ff    	jne    802ee1 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803324:	eb 01                	jmp    803327 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803326:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803327:	90                   	nop
  803328:	c9                   	leave  
  803329:	c3                   	ret    
  80332a:	66 90                	xchg   %ax,%ax

0080332c <__udivdi3>:
  80332c:	55                   	push   %ebp
  80332d:	57                   	push   %edi
  80332e:	56                   	push   %esi
  80332f:	53                   	push   %ebx
  803330:	83 ec 1c             	sub    $0x1c,%esp
  803333:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803337:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80333b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80333f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803343:	89 ca                	mov    %ecx,%edx
  803345:	89 f8                	mov    %edi,%eax
  803347:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80334b:	85 f6                	test   %esi,%esi
  80334d:	75 2d                	jne    80337c <__udivdi3+0x50>
  80334f:	39 cf                	cmp    %ecx,%edi
  803351:	77 65                	ja     8033b8 <__udivdi3+0x8c>
  803353:	89 fd                	mov    %edi,%ebp
  803355:	85 ff                	test   %edi,%edi
  803357:	75 0b                	jne    803364 <__udivdi3+0x38>
  803359:	b8 01 00 00 00       	mov    $0x1,%eax
  80335e:	31 d2                	xor    %edx,%edx
  803360:	f7 f7                	div    %edi
  803362:	89 c5                	mov    %eax,%ebp
  803364:	31 d2                	xor    %edx,%edx
  803366:	89 c8                	mov    %ecx,%eax
  803368:	f7 f5                	div    %ebp
  80336a:	89 c1                	mov    %eax,%ecx
  80336c:	89 d8                	mov    %ebx,%eax
  80336e:	f7 f5                	div    %ebp
  803370:	89 cf                	mov    %ecx,%edi
  803372:	89 fa                	mov    %edi,%edx
  803374:	83 c4 1c             	add    $0x1c,%esp
  803377:	5b                   	pop    %ebx
  803378:	5e                   	pop    %esi
  803379:	5f                   	pop    %edi
  80337a:	5d                   	pop    %ebp
  80337b:	c3                   	ret    
  80337c:	39 ce                	cmp    %ecx,%esi
  80337e:	77 28                	ja     8033a8 <__udivdi3+0x7c>
  803380:	0f bd fe             	bsr    %esi,%edi
  803383:	83 f7 1f             	xor    $0x1f,%edi
  803386:	75 40                	jne    8033c8 <__udivdi3+0x9c>
  803388:	39 ce                	cmp    %ecx,%esi
  80338a:	72 0a                	jb     803396 <__udivdi3+0x6a>
  80338c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803390:	0f 87 9e 00 00 00    	ja     803434 <__udivdi3+0x108>
  803396:	b8 01 00 00 00       	mov    $0x1,%eax
  80339b:	89 fa                	mov    %edi,%edx
  80339d:	83 c4 1c             	add    $0x1c,%esp
  8033a0:	5b                   	pop    %ebx
  8033a1:	5e                   	pop    %esi
  8033a2:	5f                   	pop    %edi
  8033a3:	5d                   	pop    %ebp
  8033a4:	c3                   	ret    
  8033a5:	8d 76 00             	lea    0x0(%esi),%esi
  8033a8:	31 ff                	xor    %edi,%edi
  8033aa:	31 c0                	xor    %eax,%eax
  8033ac:	89 fa                	mov    %edi,%edx
  8033ae:	83 c4 1c             	add    $0x1c,%esp
  8033b1:	5b                   	pop    %ebx
  8033b2:	5e                   	pop    %esi
  8033b3:	5f                   	pop    %edi
  8033b4:	5d                   	pop    %ebp
  8033b5:	c3                   	ret    
  8033b6:	66 90                	xchg   %ax,%ax
  8033b8:	89 d8                	mov    %ebx,%eax
  8033ba:	f7 f7                	div    %edi
  8033bc:	31 ff                	xor    %edi,%edi
  8033be:	89 fa                	mov    %edi,%edx
  8033c0:	83 c4 1c             	add    $0x1c,%esp
  8033c3:	5b                   	pop    %ebx
  8033c4:	5e                   	pop    %esi
  8033c5:	5f                   	pop    %edi
  8033c6:	5d                   	pop    %ebp
  8033c7:	c3                   	ret    
  8033c8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8033cd:	89 eb                	mov    %ebp,%ebx
  8033cf:	29 fb                	sub    %edi,%ebx
  8033d1:	89 f9                	mov    %edi,%ecx
  8033d3:	d3 e6                	shl    %cl,%esi
  8033d5:	89 c5                	mov    %eax,%ebp
  8033d7:	88 d9                	mov    %bl,%cl
  8033d9:	d3 ed                	shr    %cl,%ebp
  8033db:	89 e9                	mov    %ebp,%ecx
  8033dd:	09 f1                	or     %esi,%ecx
  8033df:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8033e3:	89 f9                	mov    %edi,%ecx
  8033e5:	d3 e0                	shl    %cl,%eax
  8033e7:	89 c5                	mov    %eax,%ebp
  8033e9:	89 d6                	mov    %edx,%esi
  8033eb:	88 d9                	mov    %bl,%cl
  8033ed:	d3 ee                	shr    %cl,%esi
  8033ef:	89 f9                	mov    %edi,%ecx
  8033f1:	d3 e2                	shl    %cl,%edx
  8033f3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8033f7:	88 d9                	mov    %bl,%cl
  8033f9:	d3 e8                	shr    %cl,%eax
  8033fb:	09 c2                	or     %eax,%edx
  8033fd:	89 d0                	mov    %edx,%eax
  8033ff:	89 f2                	mov    %esi,%edx
  803401:	f7 74 24 0c          	divl   0xc(%esp)
  803405:	89 d6                	mov    %edx,%esi
  803407:	89 c3                	mov    %eax,%ebx
  803409:	f7 e5                	mul    %ebp
  80340b:	39 d6                	cmp    %edx,%esi
  80340d:	72 19                	jb     803428 <__udivdi3+0xfc>
  80340f:	74 0b                	je     80341c <__udivdi3+0xf0>
  803411:	89 d8                	mov    %ebx,%eax
  803413:	31 ff                	xor    %edi,%edi
  803415:	e9 58 ff ff ff       	jmp    803372 <__udivdi3+0x46>
  80341a:	66 90                	xchg   %ax,%ax
  80341c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803420:	89 f9                	mov    %edi,%ecx
  803422:	d3 e2                	shl    %cl,%edx
  803424:	39 c2                	cmp    %eax,%edx
  803426:	73 e9                	jae    803411 <__udivdi3+0xe5>
  803428:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80342b:	31 ff                	xor    %edi,%edi
  80342d:	e9 40 ff ff ff       	jmp    803372 <__udivdi3+0x46>
  803432:	66 90                	xchg   %ax,%ax
  803434:	31 c0                	xor    %eax,%eax
  803436:	e9 37 ff ff ff       	jmp    803372 <__udivdi3+0x46>
  80343b:	90                   	nop

0080343c <__umoddi3>:
  80343c:	55                   	push   %ebp
  80343d:	57                   	push   %edi
  80343e:	56                   	push   %esi
  80343f:	53                   	push   %ebx
  803440:	83 ec 1c             	sub    $0x1c,%esp
  803443:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803447:	8b 74 24 34          	mov    0x34(%esp),%esi
  80344b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80344f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803453:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803457:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80345b:	89 f3                	mov    %esi,%ebx
  80345d:	89 fa                	mov    %edi,%edx
  80345f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803463:	89 34 24             	mov    %esi,(%esp)
  803466:	85 c0                	test   %eax,%eax
  803468:	75 1a                	jne    803484 <__umoddi3+0x48>
  80346a:	39 f7                	cmp    %esi,%edi
  80346c:	0f 86 a2 00 00 00    	jbe    803514 <__umoddi3+0xd8>
  803472:	89 c8                	mov    %ecx,%eax
  803474:	89 f2                	mov    %esi,%edx
  803476:	f7 f7                	div    %edi
  803478:	89 d0                	mov    %edx,%eax
  80347a:	31 d2                	xor    %edx,%edx
  80347c:	83 c4 1c             	add    $0x1c,%esp
  80347f:	5b                   	pop    %ebx
  803480:	5e                   	pop    %esi
  803481:	5f                   	pop    %edi
  803482:	5d                   	pop    %ebp
  803483:	c3                   	ret    
  803484:	39 f0                	cmp    %esi,%eax
  803486:	0f 87 ac 00 00 00    	ja     803538 <__umoddi3+0xfc>
  80348c:	0f bd e8             	bsr    %eax,%ebp
  80348f:	83 f5 1f             	xor    $0x1f,%ebp
  803492:	0f 84 ac 00 00 00    	je     803544 <__umoddi3+0x108>
  803498:	bf 20 00 00 00       	mov    $0x20,%edi
  80349d:	29 ef                	sub    %ebp,%edi
  80349f:	89 fe                	mov    %edi,%esi
  8034a1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8034a5:	89 e9                	mov    %ebp,%ecx
  8034a7:	d3 e0                	shl    %cl,%eax
  8034a9:	89 d7                	mov    %edx,%edi
  8034ab:	89 f1                	mov    %esi,%ecx
  8034ad:	d3 ef                	shr    %cl,%edi
  8034af:	09 c7                	or     %eax,%edi
  8034b1:	89 e9                	mov    %ebp,%ecx
  8034b3:	d3 e2                	shl    %cl,%edx
  8034b5:	89 14 24             	mov    %edx,(%esp)
  8034b8:	89 d8                	mov    %ebx,%eax
  8034ba:	d3 e0                	shl    %cl,%eax
  8034bc:	89 c2                	mov    %eax,%edx
  8034be:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034c2:	d3 e0                	shl    %cl,%eax
  8034c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8034c8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034cc:	89 f1                	mov    %esi,%ecx
  8034ce:	d3 e8                	shr    %cl,%eax
  8034d0:	09 d0                	or     %edx,%eax
  8034d2:	d3 eb                	shr    %cl,%ebx
  8034d4:	89 da                	mov    %ebx,%edx
  8034d6:	f7 f7                	div    %edi
  8034d8:	89 d3                	mov    %edx,%ebx
  8034da:	f7 24 24             	mull   (%esp)
  8034dd:	89 c6                	mov    %eax,%esi
  8034df:	89 d1                	mov    %edx,%ecx
  8034e1:	39 d3                	cmp    %edx,%ebx
  8034e3:	0f 82 87 00 00 00    	jb     803570 <__umoddi3+0x134>
  8034e9:	0f 84 91 00 00 00    	je     803580 <__umoddi3+0x144>
  8034ef:	8b 54 24 04          	mov    0x4(%esp),%edx
  8034f3:	29 f2                	sub    %esi,%edx
  8034f5:	19 cb                	sbb    %ecx,%ebx
  8034f7:	89 d8                	mov    %ebx,%eax
  8034f9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8034fd:	d3 e0                	shl    %cl,%eax
  8034ff:	89 e9                	mov    %ebp,%ecx
  803501:	d3 ea                	shr    %cl,%edx
  803503:	09 d0                	or     %edx,%eax
  803505:	89 e9                	mov    %ebp,%ecx
  803507:	d3 eb                	shr    %cl,%ebx
  803509:	89 da                	mov    %ebx,%edx
  80350b:	83 c4 1c             	add    $0x1c,%esp
  80350e:	5b                   	pop    %ebx
  80350f:	5e                   	pop    %esi
  803510:	5f                   	pop    %edi
  803511:	5d                   	pop    %ebp
  803512:	c3                   	ret    
  803513:	90                   	nop
  803514:	89 fd                	mov    %edi,%ebp
  803516:	85 ff                	test   %edi,%edi
  803518:	75 0b                	jne    803525 <__umoddi3+0xe9>
  80351a:	b8 01 00 00 00       	mov    $0x1,%eax
  80351f:	31 d2                	xor    %edx,%edx
  803521:	f7 f7                	div    %edi
  803523:	89 c5                	mov    %eax,%ebp
  803525:	89 f0                	mov    %esi,%eax
  803527:	31 d2                	xor    %edx,%edx
  803529:	f7 f5                	div    %ebp
  80352b:	89 c8                	mov    %ecx,%eax
  80352d:	f7 f5                	div    %ebp
  80352f:	89 d0                	mov    %edx,%eax
  803531:	e9 44 ff ff ff       	jmp    80347a <__umoddi3+0x3e>
  803536:	66 90                	xchg   %ax,%ax
  803538:	89 c8                	mov    %ecx,%eax
  80353a:	89 f2                	mov    %esi,%edx
  80353c:	83 c4 1c             	add    $0x1c,%esp
  80353f:	5b                   	pop    %ebx
  803540:	5e                   	pop    %esi
  803541:	5f                   	pop    %edi
  803542:	5d                   	pop    %ebp
  803543:	c3                   	ret    
  803544:	3b 04 24             	cmp    (%esp),%eax
  803547:	72 06                	jb     80354f <__umoddi3+0x113>
  803549:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80354d:	77 0f                	ja     80355e <__umoddi3+0x122>
  80354f:	89 f2                	mov    %esi,%edx
  803551:	29 f9                	sub    %edi,%ecx
  803553:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803557:	89 14 24             	mov    %edx,(%esp)
  80355a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80355e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803562:	8b 14 24             	mov    (%esp),%edx
  803565:	83 c4 1c             	add    $0x1c,%esp
  803568:	5b                   	pop    %ebx
  803569:	5e                   	pop    %esi
  80356a:	5f                   	pop    %edi
  80356b:	5d                   	pop    %ebp
  80356c:	c3                   	ret    
  80356d:	8d 76 00             	lea    0x0(%esi),%esi
  803570:	2b 04 24             	sub    (%esp),%eax
  803573:	19 fa                	sbb    %edi,%edx
  803575:	89 d1                	mov    %edx,%ecx
  803577:	89 c6                	mov    %eax,%esi
  803579:	e9 71 ff ff ff       	jmp    8034ef <__umoddi3+0xb3>
  80357e:	66 90                	xchg   %ax,%ax
  803580:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803584:	72 ea                	jb     803570 <__umoddi3+0x134>
  803586:	89 d9                	mov    %ebx,%ecx
  803588:	e9 62 ff ff ff       	jmp    8034ef <__umoddi3+0xb3>
