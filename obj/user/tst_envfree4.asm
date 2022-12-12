
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
  800045:	68 80 35 80 00       	push   $0x803580
  80004a:	e8 b4 14 00 00       	call   801503 <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*numOfFinished = 0 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int freeFrames_before = sys_calculate_free_frames() ;
  80005e:	e8 e0 16 00 00       	call   801743 <sys_calculate_free_frames>
  800063:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800066:	e8 78 17 00 00       	call   8017e3 <sys_pf_calculate_allocated_pages>
  80006b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80006e:	83 ec 08             	sub    $0x8,%esp
  800071:	ff 75 f0             	pushl  -0x10(%ebp)
  800074:	68 90 35 80 00       	push   $0x803590
  800079:	e8 b5 04 00 00       	call   800533 <cprintf>
  80007e:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tsem1", 100,(myEnv->SecondListSize), 50);
  800081:	a1 20 40 80 00       	mov    0x804020,%eax
  800086:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80008c:	6a 32                	push   $0x32
  80008e:	50                   	push   %eax
  80008f:	6a 64                	push   $0x64
  800091:	68 c3 35 80 00       	push   $0x8035c3
  800096:	e8 1a 19 00 00       	call   8019b5 <sys_create_env>
  80009b:	83 c4 10             	add    $0x10,%esp
  80009e:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sys_run_env(envIdProcessA);
  8000a1:	83 ec 0c             	sub    $0xc,%esp
  8000a4:	ff 75 e8             	pushl  -0x18(%ebp)
  8000a7:	e8 27 19 00 00       	call   8019d3 <sys_run_env>
  8000ac:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 1) ;
  8000af:	90                   	nop
  8000b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000b3:	8b 00                	mov    (%eax),%eax
  8000b5:	83 f8 01             	cmp    $0x1,%eax
  8000b8:	75 f6                	jne    8000b0 <_main+0x78>
	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  8000ba:	e8 84 16 00 00       	call   801743 <sys_calculate_free_frames>
  8000bf:	83 ec 08             	sub    $0x8,%esp
  8000c2:	50                   	push   %eax
  8000c3:	68 cc 35 80 00       	push   $0x8035cc
  8000c8:	e8 66 04 00 00       	call   800533 <cprintf>
  8000cd:	83 c4 10             	add    $0x10,%esp

	sys_destroy_env(envIdProcessA);
  8000d0:	83 ec 0c             	sub    $0xc,%esp
  8000d3:	ff 75 e8             	pushl  -0x18(%ebp)
  8000d6:	e8 14 19 00 00       	call   8019ef <sys_destroy_env>
  8000db:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  8000de:	e8 60 16 00 00       	call   801743 <sys_calculate_free_frames>
  8000e3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  8000e6:	e8 f8 16 00 00       	call   8017e3 <sys_pf_calculate_allocated_pages>
  8000eb:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if ((freeFrames_after - freeFrames_before) != 0) {
  8000ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000f1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8000f4:	74 27                	je     80011d <_main+0xe5>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\n",
  8000f6:	83 ec 08             	sub    $0x8,%esp
  8000f9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000fc:	68 00 36 80 00       	push   $0x803600
  800101:	e8 2d 04 00 00       	call   800533 <cprintf>
  800106:	83 c4 10             	add    $0x10,%esp
				freeFrames_after);
		panic("env_free() does not work correctly... check it again.");
  800109:	83 ec 04             	sub    $0x4,%esp
  80010c:	68 50 36 80 00       	push   $0x803650
  800111:	6a 1f                	push   $0x1f
  800113:	68 86 36 80 00       	push   $0x803686
  800118:	e8 62 01 00 00       	call   80027f <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  80011d:	83 ec 08             	sub    $0x8,%esp
  800120:	ff 75 e4             	pushl  -0x1c(%ebp)
  800123:	68 9c 36 80 00       	push   $0x80369c
  800128:	e8 06 04 00 00       	call   800533 <cprintf>
  80012d:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 4 for envfree completed successfully.\n");
  800130:	83 ec 0c             	sub    $0xc,%esp
  800133:	68 fc 36 80 00       	push   $0x8036fc
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
  800149:	e8 d5 18 00 00       	call   801a23 <sys_getenvindex>
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
  8001b4:	e8 77 16 00 00       	call   801830 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001b9:	83 ec 0c             	sub    $0xc,%esp
  8001bc:	68 60 37 80 00       	push   $0x803760
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
  8001e4:	68 88 37 80 00       	push   $0x803788
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
  800215:	68 b0 37 80 00       	push   $0x8037b0
  80021a:	e8 14 03 00 00       	call   800533 <cprintf>
  80021f:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800222:	a1 20 40 80 00       	mov    0x804020,%eax
  800227:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80022d:	83 ec 08             	sub    $0x8,%esp
  800230:	50                   	push   %eax
  800231:	68 08 38 80 00       	push   $0x803808
  800236:	e8 f8 02 00 00       	call   800533 <cprintf>
  80023b:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80023e:	83 ec 0c             	sub    $0xc,%esp
  800241:	68 60 37 80 00       	push   $0x803760
  800246:	e8 e8 02 00 00       	call   800533 <cprintf>
  80024b:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80024e:	e8 f7 15 00 00       	call   80184a <sys_enable_interrupt>

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
  800266:	e8 84 17 00 00       	call   8019ef <sys_destroy_env>
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
  800277:	e8 d9 17 00 00       	call   801a55 <sys_exit_env>
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
  8002a0:	68 1c 38 80 00       	push   $0x80381c
  8002a5:	e8 89 02 00 00       	call   800533 <cprintf>
  8002aa:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002ad:	a1 00 40 80 00       	mov    0x804000,%eax
  8002b2:	ff 75 0c             	pushl  0xc(%ebp)
  8002b5:	ff 75 08             	pushl  0x8(%ebp)
  8002b8:	50                   	push   %eax
  8002b9:	68 21 38 80 00       	push   $0x803821
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
  8002dd:	68 3d 38 80 00       	push   $0x80383d
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
  800309:	68 40 38 80 00       	push   $0x803840
  80030e:	6a 26                	push   $0x26
  800310:	68 8c 38 80 00       	push   $0x80388c
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
  8003db:	68 98 38 80 00       	push   $0x803898
  8003e0:	6a 3a                	push   $0x3a
  8003e2:	68 8c 38 80 00       	push   $0x80388c
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
  80044b:	68 ec 38 80 00       	push   $0x8038ec
  800450:	6a 44                	push   $0x44
  800452:	68 8c 38 80 00       	push   $0x80388c
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
  8004a5:	e8 d8 11 00 00       	call   801682 <sys_cputs>
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
  80051c:	e8 61 11 00 00       	call   801682 <sys_cputs>
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
  800566:	e8 c5 12 00 00       	call   801830 <sys_disable_interrupt>
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
  800586:	e8 bf 12 00 00       	call   80184a <sys_enable_interrupt>
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
  8005d0:	e8 33 2d 00 00       	call   803308 <__udivdi3>
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
  800620:	e8 f3 2d 00 00       	call   803418 <__umoddi3>
  800625:	83 c4 10             	add    $0x10,%esp
  800628:	05 54 3b 80 00       	add    $0x803b54,%eax
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
  80077b:	8b 04 85 78 3b 80 00 	mov    0x803b78(,%eax,4),%eax
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
  80085c:	8b 34 9d c0 39 80 00 	mov    0x8039c0(,%ebx,4),%esi
  800863:	85 f6                	test   %esi,%esi
  800865:	75 19                	jne    800880 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800867:	53                   	push   %ebx
  800868:	68 65 3b 80 00       	push   $0x803b65
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
  800881:	68 6e 3b 80 00       	push   $0x803b6e
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
  8008ae:	be 71 3b 80 00       	mov    $0x803b71,%esi
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
  8012d4:	68 d0 3c 80 00       	push   $0x803cd0
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
  8013a4:	e8 1d 04 00 00       	call   8017c6 <sys_allocate_chunk>
  8013a9:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013ac:	a1 20 41 80 00       	mov    0x804120,%eax
  8013b1:	83 ec 0c             	sub    $0xc,%esp
  8013b4:	50                   	push   %eax
  8013b5:	e8 92 0a 00 00       	call   801e4c <initialize_MemBlocksList>
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
  8013e2:	68 f5 3c 80 00       	push   $0x803cf5
  8013e7:	6a 33                	push   $0x33
  8013e9:	68 13 3d 80 00       	push   $0x803d13
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
  801461:	68 20 3d 80 00       	push   $0x803d20
  801466:	6a 34                	push   $0x34
  801468:	68 13 3d 80 00       	push   $0x803d13
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
  8014d6:	68 44 3d 80 00       	push   $0x803d44
  8014db:	6a 46                	push   $0x46
  8014dd:	68 13 3d 80 00       	push   $0x803d13
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
  8014f2:	68 6c 3d 80 00       	push   $0x803d6c
  8014f7:	6a 61                	push   $0x61
  8014f9:	68 13 3d 80 00       	push   $0x803d13
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
  801518:	75 07                	jne    801521 <smalloc+0x1e>
  80151a:	b8 00 00 00 00       	mov    $0x0,%eax
  80151f:	eb 7c                	jmp    80159d <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801521:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801528:	8b 55 0c             	mov    0xc(%ebp),%edx
  80152b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80152e:	01 d0                	add    %edx,%eax
  801530:	48                   	dec    %eax
  801531:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801534:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801537:	ba 00 00 00 00       	mov    $0x0,%edx
  80153c:	f7 75 f0             	divl   -0x10(%ebp)
  80153f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801542:	29 d0                	sub    %edx,%eax
  801544:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801547:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  80154e:	e8 41 06 00 00       	call   801b94 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801553:	85 c0                	test   %eax,%eax
  801555:	74 11                	je     801568 <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  801557:	83 ec 0c             	sub    $0xc,%esp
  80155a:	ff 75 e8             	pushl  -0x18(%ebp)
  80155d:	e8 ac 0c 00 00       	call   80220e <alloc_block_FF>
  801562:	83 c4 10             	add    $0x10,%esp
  801565:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  801568:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80156c:	74 2a                	je     801598 <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  80156e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801571:	8b 40 08             	mov    0x8(%eax),%eax
  801574:	89 c2                	mov    %eax,%edx
  801576:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  80157a:	52                   	push   %edx
  80157b:	50                   	push   %eax
  80157c:	ff 75 0c             	pushl  0xc(%ebp)
  80157f:	ff 75 08             	pushl  0x8(%ebp)
  801582:	e8 92 03 00 00       	call   801919 <sys_createSharedObject>
  801587:	83 c4 10             	add    $0x10,%esp
  80158a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  80158d:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  801591:	74 05                	je     801598 <smalloc+0x95>
			return (void*)virtual_address;
  801593:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801596:	eb 05                	jmp    80159d <smalloc+0x9a>
	}
	return NULL;
  801598:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80159d:	c9                   	leave  
  80159e:	c3                   	ret    

0080159f <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80159f:	55                   	push   %ebp
  8015a0:	89 e5                	mov    %esp,%ebp
  8015a2:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015a5:	e8 13 fd ff ff       	call   8012bd <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8015aa:	83 ec 04             	sub    $0x4,%esp
  8015ad:	68 90 3d 80 00       	push   $0x803d90
  8015b2:	68 a2 00 00 00       	push   $0xa2
  8015b7:	68 13 3d 80 00       	push   $0x803d13
  8015bc:	e8 be ec ff ff       	call   80027f <_panic>

008015c1 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8015c1:	55                   	push   %ebp
  8015c2:	89 e5                	mov    %esp,%ebp
  8015c4:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015c7:	e8 f1 fc ff ff       	call   8012bd <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8015cc:	83 ec 04             	sub    $0x4,%esp
  8015cf:	68 b4 3d 80 00       	push   $0x803db4
  8015d4:	68 e6 00 00 00       	push   $0xe6
  8015d9:	68 13 3d 80 00       	push   $0x803d13
  8015de:	e8 9c ec ff ff       	call   80027f <_panic>

008015e3 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8015e3:	55                   	push   %ebp
  8015e4:	89 e5                	mov    %esp,%ebp
  8015e6:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8015e9:	83 ec 04             	sub    $0x4,%esp
  8015ec:	68 dc 3d 80 00       	push   $0x803ddc
  8015f1:	68 fa 00 00 00       	push   $0xfa
  8015f6:	68 13 3d 80 00       	push   $0x803d13
  8015fb:	e8 7f ec ff ff       	call   80027f <_panic>

00801600 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801600:	55                   	push   %ebp
  801601:	89 e5                	mov    %esp,%ebp
  801603:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801606:	83 ec 04             	sub    $0x4,%esp
  801609:	68 00 3e 80 00       	push   $0x803e00
  80160e:	68 05 01 00 00       	push   $0x105
  801613:	68 13 3d 80 00       	push   $0x803d13
  801618:	e8 62 ec ff ff       	call   80027f <_panic>

0080161d <shrink>:

}
void shrink(uint32 newSize)
{
  80161d:	55                   	push   %ebp
  80161e:	89 e5                	mov    %esp,%ebp
  801620:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801623:	83 ec 04             	sub    $0x4,%esp
  801626:	68 00 3e 80 00       	push   $0x803e00
  80162b:	68 0a 01 00 00       	push   $0x10a
  801630:	68 13 3d 80 00       	push   $0x803d13
  801635:	e8 45 ec ff ff       	call   80027f <_panic>

0080163a <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80163a:	55                   	push   %ebp
  80163b:	89 e5                	mov    %esp,%ebp
  80163d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801640:	83 ec 04             	sub    $0x4,%esp
  801643:	68 00 3e 80 00       	push   $0x803e00
  801648:	68 0f 01 00 00       	push   $0x10f
  80164d:	68 13 3d 80 00       	push   $0x803d13
  801652:	e8 28 ec ff ff       	call   80027f <_panic>

00801657 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801657:	55                   	push   %ebp
  801658:	89 e5                	mov    %esp,%ebp
  80165a:	57                   	push   %edi
  80165b:	56                   	push   %esi
  80165c:	53                   	push   %ebx
  80165d:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801660:	8b 45 08             	mov    0x8(%ebp),%eax
  801663:	8b 55 0c             	mov    0xc(%ebp),%edx
  801666:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801669:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80166c:	8b 7d 18             	mov    0x18(%ebp),%edi
  80166f:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801672:	cd 30                	int    $0x30
  801674:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801677:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80167a:	83 c4 10             	add    $0x10,%esp
  80167d:	5b                   	pop    %ebx
  80167e:	5e                   	pop    %esi
  80167f:	5f                   	pop    %edi
  801680:	5d                   	pop    %ebp
  801681:	c3                   	ret    

00801682 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801682:	55                   	push   %ebp
  801683:	89 e5                	mov    %esp,%ebp
  801685:	83 ec 04             	sub    $0x4,%esp
  801688:	8b 45 10             	mov    0x10(%ebp),%eax
  80168b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80168e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801692:	8b 45 08             	mov    0x8(%ebp),%eax
  801695:	6a 00                	push   $0x0
  801697:	6a 00                	push   $0x0
  801699:	52                   	push   %edx
  80169a:	ff 75 0c             	pushl  0xc(%ebp)
  80169d:	50                   	push   %eax
  80169e:	6a 00                	push   $0x0
  8016a0:	e8 b2 ff ff ff       	call   801657 <syscall>
  8016a5:	83 c4 18             	add    $0x18,%esp
}
  8016a8:	90                   	nop
  8016a9:	c9                   	leave  
  8016aa:	c3                   	ret    

008016ab <sys_cgetc>:

int
sys_cgetc(void)
{
  8016ab:	55                   	push   %ebp
  8016ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8016ae:	6a 00                	push   $0x0
  8016b0:	6a 00                	push   $0x0
  8016b2:	6a 00                	push   $0x0
  8016b4:	6a 00                	push   $0x0
  8016b6:	6a 00                	push   $0x0
  8016b8:	6a 01                	push   $0x1
  8016ba:	e8 98 ff ff ff       	call   801657 <syscall>
  8016bf:	83 c4 18             	add    $0x18,%esp
}
  8016c2:	c9                   	leave  
  8016c3:	c3                   	ret    

008016c4 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8016c4:	55                   	push   %ebp
  8016c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8016c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cd:	6a 00                	push   $0x0
  8016cf:	6a 00                	push   $0x0
  8016d1:	6a 00                	push   $0x0
  8016d3:	52                   	push   %edx
  8016d4:	50                   	push   %eax
  8016d5:	6a 05                	push   $0x5
  8016d7:	e8 7b ff ff ff       	call   801657 <syscall>
  8016dc:	83 c4 18             	add    $0x18,%esp
}
  8016df:	c9                   	leave  
  8016e0:	c3                   	ret    

008016e1 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8016e1:	55                   	push   %ebp
  8016e2:	89 e5                	mov    %esp,%ebp
  8016e4:	56                   	push   %esi
  8016e5:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8016e6:	8b 75 18             	mov    0x18(%ebp),%esi
  8016e9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016ec:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f5:	56                   	push   %esi
  8016f6:	53                   	push   %ebx
  8016f7:	51                   	push   %ecx
  8016f8:	52                   	push   %edx
  8016f9:	50                   	push   %eax
  8016fa:	6a 06                	push   $0x6
  8016fc:	e8 56 ff ff ff       	call   801657 <syscall>
  801701:	83 c4 18             	add    $0x18,%esp
}
  801704:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801707:	5b                   	pop    %ebx
  801708:	5e                   	pop    %esi
  801709:	5d                   	pop    %ebp
  80170a:	c3                   	ret    

0080170b <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80170b:	55                   	push   %ebp
  80170c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80170e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801711:	8b 45 08             	mov    0x8(%ebp),%eax
  801714:	6a 00                	push   $0x0
  801716:	6a 00                	push   $0x0
  801718:	6a 00                	push   $0x0
  80171a:	52                   	push   %edx
  80171b:	50                   	push   %eax
  80171c:	6a 07                	push   $0x7
  80171e:	e8 34 ff ff ff       	call   801657 <syscall>
  801723:	83 c4 18             	add    $0x18,%esp
}
  801726:	c9                   	leave  
  801727:	c3                   	ret    

00801728 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801728:	55                   	push   %ebp
  801729:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80172b:	6a 00                	push   $0x0
  80172d:	6a 00                	push   $0x0
  80172f:	6a 00                	push   $0x0
  801731:	ff 75 0c             	pushl  0xc(%ebp)
  801734:	ff 75 08             	pushl  0x8(%ebp)
  801737:	6a 08                	push   $0x8
  801739:	e8 19 ff ff ff       	call   801657 <syscall>
  80173e:	83 c4 18             	add    $0x18,%esp
}
  801741:	c9                   	leave  
  801742:	c3                   	ret    

00801743 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801743:	55                   	push   %ebp
  801744:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801746:	6a 00                	push   $0x0
  801748:	6a 00                	push   $0x0
  80174a:	6a 00                	push   $0x0
  80174c:	6a 00                	push   $0x0
  80174e:	6a 00                	push   $0x0
  801750:	6a 09                	push   $0x9
  801752:	e8 00 ff ff ff       	call   801657 <syscall>
  801757:	83 c4 18             	add    $0x18,%esp
}
  80175a:	c9                   	leave  
  80175b:	c3                   	ret    

0080175c <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80175c:	55                   	push   %ebp
  80175d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80175f:	6a 00                	push   $0x0
  801761:	6a 00                	push   $0x0
  801763:	6a 00                	push   $0x0
  801765:	6a 00                	push   $0x0
  801767:	6a 00                	push   $0x0
  801769:	6a 0a                	push   $0xa
  80176b:	e8 e7 fe ff ff       	call   801657 <syscall>
  801770:	83 c4 18             	add    $0x18,%esp
}
  801773:	c9                   	leave  
  801774:	c3                   	ret    

00801775 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801775:	55                   	push   %ebp
  801776:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801778:	6a 00                	push   $0x0
  80177a:	6a 00                	push   $0x0
  80177c:	6a 00                	push   $0x0
  80177e:	6a 00                	push   $0x0
  801780:	6a 00                	push   $0x0
  801782:	6a 0b                	push   $0xb
  801784:	e8 ce fe ff ff       	call   801657 <syscall>
  801789:	83 c4 18             	add    $0x18,%esp
}
  80178c:	c9                   	leave  
  80178d:	c3                   	ret    

0080178e <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80178e:	55                   	push   %ebp
  80178f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801791:	6a 00                	push   $0x0
  801793:	6a 00                	push   $0x0
  801795:	6a 00                	push   $0x0
  801797:	ff 75 0c             	pushl  0xc(%ebp)
  80179a:	ff 75 08             	pushl  0x8(%ebp)
  80179d:	6a 0f                	push   $0xf
  80179f:	e8 b3 fe ff ff       	call   801657 <syscall>
  8017a4:	83 c4 18             	add    $0x18,%esp
	return;
  8017a7:	90                   	nop
}
  8017a8:	c9                   	leave  
  8017a9:	c3                   	ret    

008017aa <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8017aa:	55                   	push   %ebp
  8017ab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8017ad:	6a 00                	push   $0x0
  8017af:	6a 00                	push   $0x0
  8017b1:	6a 00                	push   $0x0
  8017b3:	ff 75 0c             	pushl  0xc(%ebp)
  8017b6:	ff 75 08             	pushl  0x8(%ebp)
  8017b9:	6a 10                	push   $0x10
  8017bb:	e8 97 fe ff ff       	call   801657 <syscall>
  8017c0:	83 c4 18             	add    $0x18,%esp
	return ;
  8017c3:	90                   	nop
}
  8017c4:	c9                   	leave  
  8017c5:	c3                   	ret    

008017c6 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8017c6:	55                   	push   %ebp
  8017c7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8017c9:	6a 00                	push   $0x0
  8017cb:	6a 00                	push   $0x0
  8017cd:	ff 75 10             	pushl  0x10(%ebp)
  8017d0:	ff 75 0c             	pushl  0xc(%ebp)
  8017d3:	ff 75 08             	pushl  0x8(%ebp)
  8017d6:	6a 11                	push   $0x11
  8017d8:	e8 7a fe ff ff       	call   801657 <syscall>
  8017dd:	83 c4 18             	add    $0x18,%esp
	return ;
  8017e0:	90                   	nop
}
  8017e1:	c9                   	leave  
  8017e2:	c3                   	ret    

008017e3 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8017e3:	55                   	push   %ebp
  8017e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8017e6:	6a 00                	push   $0x0
  8017e8:	6a 00                	push   $0x0
  8017ea:	6a 00                	push   $0x0
  8017ec:	6a 00                	push   $0x0
  8017ee:	6a 00                	push   $0x0
  8017f0:	6a 0c                	push   $0xc
  8017f2:	e8 60 fe ff ff       	call   801657 <syscall>
  8017f7:	83 c4 18             	add    $0x18,%esp
}
  8017fa:	c9                   	leave  
  8017fb:	c3                   	ret    

008017fc <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8017fc:	55                   	push   %ebp
  8017fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8017ff:	6a 00                	push   $0x0
  801801:	6a 00                	push   $0x0
  801803:	6a 00                	push   $0x0
  801805:	6a 00                	push   $0x0
  801807:	ff 75 08             	pushl  0x8(%ebp)
  80180a:	6a 0d                	push   $0xd
  80180c:	e8 46 fe ff ff       	call   801657 <syscall>
  801811:	83 c4 18             	add    $0x18,%esp
}
  801814:	c9                   	leave  
  801815:	c3                   	ret    

00801816 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801816:	55                   	push   %ebp
  801817:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801819:	6a 00                	push   $0x0
  80181b:	6a 00                	push   $0x0
  80181d:	6a 00                	push   $0x0
  80181f:	6a 00                	push   $0x0
  801821:	6a 00                	push   $0x0
  801823:	6a 0e                	push   $0xe
  801825:	e8 2d fe ff ff       	call   801657 <syscall>
  80182a:	83 c4 18             	add    $0x18,%esp
}
  80182d:	90                   	nop
  80182e:	c9                   	leave  
  80182f:	c3                   	ret    

00801830 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801830:	55                   	push   %ebp
  801831:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801833:	6a 00                	push   $0x0
  801835:	6a 00                	push   $0x0
  801837:	6a 00                	push   $0x0
  801839:	6a 00                	push   $0x0
  80183b:	6a 00                	push   $0x0
  80183d:	6a 13                	push   $0x13
  80183f:	e8 13 fe ff ff       	call   801657 <syscall>
  801844:	83 c4 18             	add    $0x18,%esp
}
  801847:	90                   	nop
  801848:	c9                   	leave  
  801849:	c3                   	ret    

0080184a <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80184a:	55                   	push   %ebp
  80184b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80184d:	6a 00                	push   $0x0
  80184f:	6a 00                	push   $0x0
  801851:	6a 00                	push   $0x0
  801853:	6a 00                	push   $0x0
  801855:	6a 00                	push   $0x0
  801857:	6a 14                	push   $0x14
  801859:	e8 f9 fd ff ff       	call   801657 <syscall>
  80185e:	83 c4 18             	add    $0x18,%esp
}
  801861:	90                   	nop
  801862:	c9                   	leave  
  801863:	c3                   	ret    

00801864 <sys_cputc>:


void
sys_cputc(const char c)
{
  801864:	55                   	push   %ebp
  801865:	89 e5                	mov    %esp,%ebp
  801867:	83 ec 04             	sub    $0x4,%esp
  80186a:	8b 45 08             	mov    0x8(%ebp),%eax
  80186d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801870:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801874:	6a 00                	push   $0x0
  801876:	6a 00                	push   $0x0
  801878:	6a 00                	push   $0x0
  80187a:	6a 00                	push   $0x0
  80187c:	50                   	push   %eax
  80187d:	6a 15                	push   $0x15
  80187f:	e8 d3 fd ff ff       	call   801657 <syscall>
  801884:	83 c4 18             	add    $0x18,%esp
}
  801887:	90                   	nop
  801888:	c9                   	leave  
  801889:	c3                   	ret    

0080188a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80188a:	55                   	push   %ebp
  80188b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80188d:	6a 00                	push   $0x0
  80188f:	6a 00                	push   $0x0
  801891:	6a 00                	push   $0x0
  801893:	6a 00                	push   $0x0
  801895:	6a 00                	push   $0x0
  801897:	6a 16                	push   $0x16
  801899:	e8 b9 fd ff ff       	call   801657 <syscall>
  80189e:	83 c4 18             	add    $0x18,%esp
}
  8018a1:	90                   	nop
  8018a2:	c9                   	leave  
  8018a3:	c3                   	ret    

008018a4 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8018a4:	55                   	push   %ebp
  8018a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8018a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018aa:	6a 00                	push   $0x0
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 00                	push   $0x0
  8018b0:	ff 75 0c             	pushl  0xc(%ebp)
  8018b3:	50                   	push   %eax
  8018b4:	6a 17                	push   $0x17
  8018b6:	e8 9c fd ff ff       	call   801657 <syscall>
  8018bb:	83 c4 18             	add    $0x18,%esp
}
  8018be:	c9                   	leave  
  8018bf:	c3                   	ret    

008018c0 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8018c0:	55                   	push   %ebp
  8018c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c9:	6a 00                	push   $0x0
  8018cb:	6a 00                	push   $0x0
  8018cd:	6a 00                	push   $0x0
  8018cf:	52                   	push   %edx
  8018d0:	50                   	push   %eax
  8018d1:	6a 1a                	push   $0x1a
  8018d3:	e8 7f fd ff ff       	call   801657 <syscall>
  8018d8:	83 c4 18             	add    $0x18,%esp
}
  8018db:	c9                   	leave  
  8018dc:	c3                   	ret    

008018dd <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8018dd:	55                   	push   %ebp
  8018de:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e6:	6a 00                	push   $0x0
  8018e8:	6a 00                	push   $0x0
  8018ea:	6a 00                	push   $0x0
  8018ec:	52                   	push   %edx
  8018ed:	50                   	push   %eax
  8018ee:	6a 18                	push   $0x18
  8018f0:	e8 62 fd ff ff       	call   801657 <syscall>
  8018f5:	83 c4 18             	add    $0x18,%esp
}
  8018f8:	90                   	nop
  8018f9:	c9                   	leave  
  8018fa:	c3                   	ret    

008018fb <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8018fb:	55                   	push   %ebp
  8018fc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801901:	8b 45 08             	mov    0x8(%ebp),%eax
  801904:	6a 00                	push   $0x0
  801906:	6a 00                	push   $0x0
  801908:	6a 00                	push   $0x0
  80190a:	52                   	push   %edx
  80190b:	50                   	push   %eax
  80190c:	6a 19                	push   $0x19
  80190e:	e8 44 fd ff ff       	call   801657 <syscall>
  801913:	83 c4 18             	add    $0x18,%esp
}
  801916:	90                   	nop
  801917:	c9                   	leave  
  801918:	c3                   	ret    

00801919 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801919:	55                   	push   %ebp
  80191a:	89 e5                	mov    %esp,%ebp
  80191c:	83 ec 04             	sub    $0x4,%esp
  80191f:	8b 45 10             	mov    0x10(%ebp),%eax
  801922:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801925:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801928:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80192c:	8b 45 08             	mov    0x8(%ebp),%eax
  80192f:	6a 00                	push   $0x0
  801931:	51                   	push   %ecx
  801932:	52                   	push   %edx
  801933:	ff 75 0c             	pushl  0xc(%ebp)
  801936:	50                   	push   %eax
  801937:	6a 1b                	push   $0x1b
  801939:	e8 19 fd ff ff       	call   801657 <syscall>
  80193e:	83 c4 18             	add    $0x18,%esp
}
  801941:	c9                   	leave  
  801942:	c3                   	ret    

00801943 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801943:	55                   	push   %ebp
  801944:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801946:	8b 55 0c             	mov    0xc(%ebp),%edx
  801949:	8b 45 08             	mov    0x8(%ebp),%eax
  80194c:	6a 00                	push   $0x0
  80194e:	6a 00                	push   $0x0
  801950:	6a 00                	push   $0x0
  801952:	52                   	push   %edx
  801953:	50                   	push   %eax
  801954:	6a 1c                	push   $0x1c
  801956:	e8 fc fc ff ff       	call   801657 <syscall>
  80195b:	83 c4 18             	add    $0x18,%esp
}
  80195e:	c9                   	leave  
  80195f:	c3                   	ret    

00801960 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801960:	55                   	push   %ebp
  801961:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801963:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801966:	8b 55 0c             	mov    0xc(%ebp),%edx
  801969:	8b 45 08             	mov    0x8(%ebp),%eax
  80196c:	6a 00                	push   $0x0
  80196e:	6a 00                	push   $0x0
  801970:	51                   	push   %ecx
  801971:	52                   	push   %edx
  801972:	50                   	push   %eax
  801973:	6a 1d                	push   $0x1d
  801975:	e8 dd fc ff ff       	call   801657 <syscall>
  80197a:	83 c4 18             	add    $0x18,%esp
}
  80197d:	c9                   	leave  
  80197e:	c3                   	ret    

0080197f <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80197f:	55                   	push   %ebp
  801980:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801982:	8b 55 0c             	mov    0xc(%ebp),%edx
  801985:	8b 45 08             	mov    0x8(%ebp),%eax
  801988:	6a 00                	push   $0x0
  80198a:	6a 00                	push   $0x0
  80198c:	6a 00                	push   $0x0
  80198e:	52                   	push   %edx
  80198f:	50                   	push   %eax
  801990:	6a 1e                	push   $0x1e
  801992:	e8 c0 fc ff ff       	call   801657 <syscall>
  801997:	83 c4 18             	add    $0x18,%esp
}
  80199a:	c9                   	leave  
  80199b:	c3                   	ret    

0080199c <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80199c:	55                   	push   %ebp
  80199d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 1f                	push   $0x1f
  8019ab:	e8 a7 fc ff ff       	call   801657 <syscall>
  8019b0:	83 c4 18             	add    $0x18,%esp
}
  8019b3:	c9                   	leave  
  8019b4:	c3                   	ret    

008019b5 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8019b5:	55                   	push   %ebp
  8019b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8019b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bb:	6a 00                	push   $0x0
  8019bd:	ff 75 14             	pushl  0x14(%ebp)
  8019c0:	ff 75 10             	pushl  0x10(%ebp)
  8019c3:	ff 75 0c             	pushl  0xc(%ebp)
  8019c6:	50                   	push   %eax
  8019c7:	6a 20                	push   $0x20
  8019c9:	e8 89 fc ff ff       	call   801657 <syscall>
  8019ce:	83 c4 18             	add    $0x18,%esp
}
  8019d1:	c9                   	leave  
  8019d2:	c3                   	ret    

008019d3 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8019d3:	55                   	push   %ebp
  8019d4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8019d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d9:	6a 00                	push   $0x0
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 00                	push   $0x0
  8019e1:	50                   	push   %eax
  8019e2:	6a 21                	push   $0x21
  8019e4:	e8 6e fc ff ff       	call   801657 <syscall>
  8019e9:	83 c4 18             	add    $0x18,%esp
}
  8019ec:	90                   	nop
  8019ed:	c9                   	leave  
  8019ee:	c3                   	ret    

008019ef <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8019ef:	55                   	push   %ebp
  8019f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8019f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 00                	push   $0x0
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 00                	push   $0x0
  8019fd:	50                   	push   %eax
  8019fe:	6a 22                	push   $0x22
  801a00:	e8 52 fc ff ff       	call   801657 <syscall>
  801a05:	83 c4 18             	add    $0x18,%esp
}
  801a08:	c9                   	leave  
  801a09:	c3                   	ret    

00801a0a <sys_getenvid>:

int32 sys_getenvid(void)
{
  801a0a:	55                   	push   %ebp
  801a0b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801a0d:	6a 00                	push   $0x0
  801a0f:	6a 00                	push   $0x0
  801a11:	6a 00                	push   $0x0
  801a13:	6a 00                	push   $0x0
  801a15:	6a 00                	push   $0x0
  801a17:	6a 02                	push   $0x2
  801a19:	e8 39 fc ff ff       	call   801657 <syscall>
  801a1e:	83 c4 18             	add    $0x18,%esp
}
  801a21:	c9                   	leave  
  801a22:	c3                   	ret    

00801a23 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801a23:	55                   	push   %ebp
  801a24:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801a26:	6a 00                	push   $0x0
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 03                	push   $0x3
  801a32:	e8 20 fc ff ff       	call   801657 <syscall>
  801a37:	83 c4 18             	add    $0x18,%esp
}
  801a3a:	c9                   	leave  
  801a3b:	c3                   	ret    

00801a3c <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801a3c:	55                   	push   %ebp
  801a3d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801a3f:	6a 00                	push   $0x0
  801a41:	6a 00                	push   $0x0
  801a43:	6a 00                	push   $0x0
  801a45:	6a 00                	push   $0x0
  801a47:	6a 00                	push   $0x0
  801a49:	6a 04                	push   $0x4
  801a4b:	e8 07 fc ff ff       	call   801657 <syscall>
  801a50:	83 c4 18             	add    $0x18,%esp
}
  801a53:	c9                   	leave  
  801a54:	c3                   	ret    

00801a55 <sys_exit_env>:


void sys_exit_env(void)
{
  801a55:	55                   	push   %ebp
  801a56:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801a58:	6a 00                	push   $0x0
  801a5a:	6a 00                	push   $0x0
  801a5c:	6a 00                	push   $0x0
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 00                	push   $0x0
  801a62:	6a 23                	push   $0x23
  801a64:	e8 ee fb ff ff       	call   801657 <syscall>
  801a69:	83 c4 18             	add    $0x18,%esp
}
  801a6c:	90                   	nop
  801a6d:	c9                   	leave  
  801a6e:	c3                   	ret    

00801a6f <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801a6f:	55                   	push   %ebp
  801a70:	89 e5                	mov    %esp,%ebp
  801a72:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801a75:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a78:	8d 50 04             	lea    0x4(%eax),%edx
  801a7b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	6a 00                	push   $0x0
  801a84:	52                   	push   %edx
  801a85:	50                   	push   %eax
  801a86:	6a 24                	push   $0x24
  801a88:	e8 ca fb ff ff       	call   801657 <syscall>
  801a8d:	83 c4 18             	add    $0x18,%esp
	return result;
  801a90:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a93:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a96:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a99:	89 01                	mov    %eax,(%ecx)
  801a9b:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa1:	c9                   	leave  
  801aa2:	c2 04 00             	ret    $0x4

00801aa5 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801aa5:	55                   	push   %ebp
  801aa6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801aa8:	6a 00                	push   $0x0
  801aaa:	6a 00                	push   $0x0
  801aac:	ff 75 10             	pushl  0x10(%ebp)
  801aaf:	ff 75 0c             	pushl  0xc(%ebp)
  801ab2:	ff 75 08             	pushl  0x8(%ebp)
  801ab5:	6a 12                	push   $0x12
  801ab7:	e8 9b fb ff ff       	call   801657 <syscall>
  801abc:	83 c4 18             	add    $0x18,%esp
	return ;
  801abf:	90                   	nop
}
  801ac0:	c9                   	leave  
  801ac1:	c3                   	ret    

00801ac2 <sys_rcr2>:
uint32 sys_rcr2()
{
  801ac2:	55                   	push   %ebp
  801ac3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 00                	push   $0x0
  801acd:	6a 00                	push   $0x0
  801acf:	6a 25                	push   $0x25
  801ad1:	e8 81 fb ff ff       	call   801657 <syscall>
  801ad6:	83 c4 18             	add    $0x18,%esp
}
  801ad9:	c9                   	leave  
  801ada:	c3                   	ret    

00801adb <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801adb:	55                   	push   %ebp
  801adc:	89 e5                	mov    %esp,%ebp
  801ade:	83 ec 04             	sub    $0x4,%esp
  801ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ae7:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801aeb:	6a 00                	push   $0x0
  801aed:	6a 00                	push   $0x0
  801aef:	6a 00                	push   $0x0
  801af1:	6a 00                	push   $0x0
  801af3:	50                   	push   %eax
  801af4:	6a 26                	push   $0x26
  801af6:	e8 5c fb ff ff       	call   801657 <syscall>
  801afb:	83 c4 18             	add    $0x18,%esp
	return ;
  801afe:	90                   	nop
}
  801aff:	c9                   	leave  
  801b00:	c3                   	ret    

00801b01 <rsttst>:
void rsttst()
{
  801b01:	55                   	push   %ebp
  801b02:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801b04:	6a 00                	push   $0x0
  801b06:	6a 00                	push   $0x0
  801b08:	6a 00                	push   $0x0
  801b0a:	6a 00                	push   $0x0
  801b0c:	6a 00                	push   $0x0
  801b0e:	6a 28                	push   $0x28
  801b10:	e8 42 fb ff ff       	call   801657 <syscall>
  801b15:	83 c4 18             	add    $0x18,%esp
	return ;
  801b18:	90                   	nop
}
  801b19:	c9                   	leave  
  801b1a:	c3                   	ret    

00801b1b <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801b1b:	55                   	push   %ebp
  801b1c:	89 e5                	mov    %esp,%ebp
  801b1e:	83 ec 04             	sub    $0x4,%esp
  801b21:	8b 45 14             	mov    0x14(%ebp),%eax
  801b24:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801b27:	8b 55 18             	mov    0x18(%ebp),%edx
  801b2a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b2e:	52                   	push   %edx
  801b2f:	50                   	push   %eax
  801b30:	ff 75 10             	pushl  0x10(%ebp)
  801b33:	ff 75 0c             	pushl  0xc(%ebp)
  801b36:	ff 75 08             	pushl  0x8(%ebp)
  801b39:	6a 27                	push   $0x27
  801b3b:	e8 17 fb ff ff       	call   801657 <syscall>
  801b40:	83 c4 18             	add    $0x18,%esp
	return ;
  801b43:	90                   	nop
}
  801b44:	c9                   	leave  
  801b45:	c3                   	ret    

00801b46 <chktst>:
void chktst(uint32 n)
{
  801b46:	55                   	push   %ebp
  801b47:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 00                	push   $0x0
  801b4f:	6a 00                	push   $0x0
  801b51:	ff 75 08             	pushl  0x8(%ebp)
  801b54:	6a 29                	push   $0x29
  801b56:	e8 fc fa ff ff       	call   801657 <syscall>
  801b5b:	83 c4 18             	add    $0x18,%esp
	return ;
  801b5e:	90                   	nop
}
  801b5f:	c9                   	leave  
  801b60:	c3                   	ret    

00801b61 <inctst>:

void inctst()
{
  801b61:	55                   	push   %ebp
  801b62:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801b64:	6a 00                	push   $0x0
  801b66:	6a 00                	push   $0x0
  801b68:	6a 00                	push   $0x0
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 00                	push   $0x0
  801b6e:	6a 2a                	push   $0x2a
  801b70:	e8 e2 fa ff ff       	call   801657 <syscall>
  801b75:	83 c4 18             	add    $0x18,%esp
	return ;
  801b78:	90                   	nop
}
  801b79:	c9                   	leave  
  801b7a:	c3                   	ret    

00801b7b <gettst>:
uint32 gettst()
{
  801b7b:	55                   	push   %ebp
  801b7c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 00                	push   $0x0
  801b82:	6a 00                	push   $0x0
  801b84:	6a 00                	push   $0x0
  801b86:	6a 00                	push   $0x0
  801b88:	6a 2b                	push   $0x2b
  801b8a:	e8 c8 fa ff ff       	call   801657 <syscall>
  801b8f:	83 c4 18             	add    $0x18,%esp
}
  801b92:	c9                   	leave  
  801b93:	c3                   	ret    

00801b94 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801b94:	55                   	push   %ebp
  801b95:	89 e5                	mov    %esp,%ebp
  801b97:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b9a:	6a 00                	push   $0x0
  801b9c:	6a 00                	push   $0x0
  801b9e:	6a 00                	push   $0x0
  801ba0:	6a 00                	push   $0x0
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 2c                	push   $0x2c
  801ba6:	e8 ac fa ff ff       	call   801657 <syscall>
  801bab:	83 c4 18             	add    $0x18,%esp
  801bae:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801bb1:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801bb5:	75 07                	jne    801bbe <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801bb7:	b8 01 00 00 00       	mov    $0x1,%eax
  801bbc:	eb 05                	jmp    801bc3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801bbe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bc3:	c9                   	leave  
  801bc4:	c3                   	ret    

00801bc5 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801bc5:	55                   	push   %ebp
  801bc6:	89 e5                	mov    %esp,%ebp
  801bc8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bcb:	6a 00                	push   $0x0
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 00                	push   $0x0
  801bd1:	6a 00                	push   $0x0
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 2c                	push   $0x2c
  801bd7:	e8 7b fa ff ff       	call   801657 <syscall>
  801bdc:	83 c4 18             	add    $0x18,%esp
  801bdf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801be2:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801be6:	75 07                	jne    801bef <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801be8:	b8 01 00 00 00       	mov    $0x1,%eax
  801bed:	eb 05                	jmp    801bf4 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801bef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bf4:	c9                   	leave  
  801bf5:	c3                   	ret    

00801bf6 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801bf6:	55                   	push   %ebp
  801bf7:	89 e5                	mov    %esp,%ebp
  801bf9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	6a 00                	push   $0x0
  801c04:	6a 00                	push   $0x0
  801c06:	6a 2c                	push   $0x2c
  801c08:	e8 4a fa ff ff       	call   801657 <syscall>
  801c0d:	83 c4 18             	add    $0x18,%esp
  801c10:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801c13:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801c17:	75 07                	jne    801c20 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801c19:	b8 01 00 00 00       	mov    $0x1,%eax
  801c1e:	eb 05                	jmp    801c25 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801c20:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c25:	c9                   	leave  
  801c26:	c3                   	ret    

00801c27 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801c27:	55                   	push   %ebp
  801c28:	89 e5                	mov    %esp,%ebp
  801c2a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c2d:	6a 00                	push   $0x0
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 00                	push   $0x0
  801c33:	6a 00                	push   $0x0
  801c35:	6a 00                	push   $0x0
  801c37:	6a 2c                	push   $0x2c
  801c39:	e8 19 fa ff ff       	call   801657 <syscall>
  801c3e:	83 c4 18             	add    $0x18,%esp
  801c41:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801c44:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801c48:	75 07                	jne    801c51 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801c4a:	b8 01 00 00 00       	mov    $0x1,%eax
  801c4f:	eb 05                	jmp    801c56 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801c51:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c56:	c9                   	leave  
  801c57:	c3                   	ret    

00801c58 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c58:	55                   	push   %ebp
  801c59:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c5b:	6a 00                	push   $0x0
  801c5d:	6a 00                	push   $0x0
  801c5f:	6a 00                	push   $0x0
  801c61:	6a 00                	push   $0x0
  801c63:	ff 75 08             	pushl  0x8(%ebp)
  801c66:	6a 2d                	push   $0x2d
  801c68:	e8 ea f9 ff ff       	call   801657 <syscall>
  801c6d:	83 c4 18             	add    $0x18,%esp
	return ;
  801c70:	90                   	nop
}
  801c71:	c9                   	leave  
  801c72:	c3                   	ret    

00801c73 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801c73:	55                   	push   %ebp
  801c74:	89 e5                	mov    %esp,%ebp
  801c76:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801c77:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c7a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c80:	8b 45 08             	mov    0x8(%ebp),%eax
  801c83:	6a 00                	push   $0x0
  801c85:	53                   	push   %ebx
  801c86:	51                   	push   %ecx
  801c87:	52                   	push   %edx
  801c88:	50                   	push   %eax
  801c89:	6a 2e                	push   $0x2e
  801c8b:	e8 c7 f9 ff ff       	call   801657 <syscall>
  801c90:	83 c4 18             	add    $0x18,%esp
}
  801c93:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c96:	c9                   	leave  
  801c97:	c3                   	ret    

00801c98 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801c98:	55                   	push   %ebp
  801c99:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801c9b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca1:	6a 00                	push   $0x0
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 00                	push   $0x0
  801ca7:	52                   	push   %edx
  801ca8:	50                   	push   %eax
  801ca9:	6a 2f                	push   $0x2f
  801cab:	e8 a7 f9 ff ff       	call   801657 <syscall>
  801cb0:	83 c4 18             	add    $0x18,%esp
}
  801cb3:	c9                   	leave  
  801cb4:	c3                   	ret    

00801cb5 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801cb5:	55                   	push   %ebp
  801cb6:	89 e5                	mov    %esp,%ebp
  801cb8:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801cbb:	83 ec 0c             	sub    $0xc,%esp
  801cbe:	68 10 3e 80 00       	push   $0x803e10
  801cc3:	e8 6b e8 ff ff       	call   800533 <cprintf>
  801cc8:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801ccb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801cd2:	83 ec 0c             	sub    $0xc,%esp
  801cd5:	68 3c 3e 80 00       	push   $0x803e3c
  801cda:	e8 54 e8 ff ff       	call   800533 <cprintf>
  801cdf:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801ce2:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ce6:	a1 38 41 80 00       	mov    0x804138,%eax
  801ceb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801cee:	eb 56                	jmp    801d46 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801cf0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801cf4:	74 1c                	je     801d12 <print_mem_block_lists+0x5d>
  801cf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cf9:	8b 50 08             	mov    0x8(%eax),%edx
  801cfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cff:	8b 48 08             	mov    0x8(%eax),%ecx
  801d02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d05:	8b 40 0c             	mov    0xc(%eax),%eax
  801d08:	01 c8                	add    %ecx,%eax
  801d0a:	39 c2                	cmp    %eax,%edx
  801d0c:	73 04                	jae    801d12 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801d0e:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801d12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d15:	8b 50 08             	mov    0x8(%eax),%edx
  801d18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d1b:	8b 40 0c             	mov    0xc(%eax),%eax
  801d1e:	01 c2                	add    %eax,%edx
  801d20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d23:	8b 40 08             	mov    0x8(%eax),%eax
  801d26:	83 ec 04             	sub    $0x4,%esp
  801d29:	52                   	push   %edx
  801d2a:	50                   	push   %eax
  801d2b:	68 51 3e 80 00       	push   $0x803e51
  801d30:	e8 fe e7 ff ff       	call   800533 <cprintf>
  801d35:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801d38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d3e:	a1 40 41 80 00       	mov    0x804140,%eax
  801d43:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d46:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d4a:	74 07                	je     801d53 <print_mem_block_lists+0x9e>
  801d4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d4f:	8b 00                	mov    (%eax),%eax
  801d51:	eb 05                	jmp    801d58 <print_mem_block_lists+0xa3>
  801d53:	b8 00 00 00 00       	mov    $0x0,%eax
  801d58:	a3 40 41 80 00       	mov    %eax,0x804140
  801d5d:	a1 40 41 80 00       	mov    0x804140,%eax
  801d62:	85 c0                	test   %eax,%eax
  801d64:	75 8a                	jne    801cf0 <print_mem_block_lists+0x3b>
  801d66:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d6a:	75 84                	jne    801cf0 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801d6c:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801d70:	75 10                	jne    801d82 <print_mem_block_lists+0xcd>
  801d72:	83 ec 0c             	sub    $0xc,%esp
  801d75:	68 60 3e 80 00       	push   $0x803e60
  801d7a:	e8 b4 e7 ff ff       	call   800533 <cprintf>
  801d7f:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801d82:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801d89:	83 ec 0c             	sub    $0xc,%esp
  801d8c:	68 84 3e 80 00       	push   $0x803e84
  801d91:	e8 9d e7 ff ff       	call   800533 <cprintf>
  801d96:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801d99:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801d9d:	a1 40 40 80 00       	mov    0x804040,%eax
  801da2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801da5:	eb 56                	jmp    801dfd <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801da7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801dab:	74 1c                	je     801dc9 <print_mem_block_lists+0x114>
  801dad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db0:	8b 50 08             	mov    0x8(%eax),%edx
  801db3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801db6:	8b 48 08             	mov    0x8(%eax),%ecx
  801db9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dbc:	8b 40 0c             	mov    0xc(%eax),%eax
  801dbf:	01 c8                	add    %ecx,%eax
  801dc1:	39 c2                	cmp    %eax,%edx
  801dc3:	73 04                	jae    801dc9 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801dc5:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801dc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dcc:	8b 50 08             	mov    0x8(%eax),%edx
  801dcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd2:	8b 40 0c             	mov    0xc(%eax),%eax
  801dd5:	01 c2                	add    %eax,%edx
  801dd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dda:	8b 40 08             	mov    0x8(%eax),%eax
  801ddd:	83 ec 04             	sub    $0x4,%esp
  801de0:	52                   	push   %edx
  801de1:	50                   	push   %eax
  801de2:	68 51 3e 80 00       	push   $0x803e51
  801de7:	e8 47 e7 ff ff       	call   800533 <cprintf>
  801dec:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801def:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801df5:	a1 48 40 80 00       	mov    0x804048,%eax
  801dfa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dfd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e01:	74 07                	je     801e0a <print_mem_block_lists+0x155>
  801e03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e06:	8b 00                	mov    (%eax),%eax
  801e08:	eb 05                	jmp    801e0f <print_mem_block_lists+0x15a>
  801e0a:	b8 00 00 00 00       	mov    $0x0,%eax
  801e0f:	a3 48 40 80 00       	mov    %eax,0x804048
  801e14:	a1 48 40 80 00       	mov    0x804048,%eax
  801e19:	85 c0                	test   %eax,%eax
  801e1b:	75 8a                	jne    801da7 <print_mem_block_lists+0xf2>
  801e1d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e21:	75 84                	jne    801da7 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801e23:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e27:	75 10                	jne    801e39 <print_mem_block_lists+0x184>
  801e29:	83 ec 0c             	sub    $0xc,%esp
  801e2c:	68 9c 3e 80 00       	push   $0x803e9c
  801e31:	e8 fd e6 ff ff       	call   800533 <cprintf>
  801e36:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801e39:	83 ec 0c             	sub    $0xc,%esp
  801e3c:	68 10 3e 80 00       	push   $0x803e10
  801e41:	e8 ed e6 ff ff       	call   800533 <cprintf>
  801e46:	83 c4 10             	add    $0x10,%esp

}
  801e49:	90                   	nop
  801e4a:	c9                   	leave  
  801e4b:	c3                   	ret    

00801e4c <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801e4c:	55                   	push   %ebp
  801e4d:	89 e5                	mov    %esp,%ebp
  801e4f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801e52:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801e59:	00 00 00 
  801e5c:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801e63:	00 00 00 
  801e66:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801e6d:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801e70:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801e77:	e9 9e 00 00 00       	jmp    801f1a <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801e7c:	a1 50 40 80 00       	mov    0x804050,%eax
  801e81:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e84:	c1 e2 04             	shl    $0x4,%edx
  801e87:	01 d0                	add    %edx,%eax
  801e89:	85 c0                	test   %eax,%eax
  801e8b:	75 14                	jne    801ea1 <initialize_MemBlocksList+0x55>
  801e8d:	83 ec 04             	sub    $0x4,%esp
  801e90:	68 c4 3e 80 00       	push   $0x803ec4
  801e95:	6a 46                	push   $0x46
  801e97:	68 e7 3e 80 00       	push   $0x803ee7
  801e9c:	e8 de e3 ff ff       	call   80027f <_panic>
  801ea1:	a1 50 40 80 00       	mov    0x804050,%eax
  801ea6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ea9:	c1 e2 04             	shl    $0x4,%edx
  801eac:	01 d0                	add    %edx,%eax
  801eae:	8b 15 48 41 80 00    	mov    0x804148,%edx
  801eb4:	89 10                	mov    %edx,(%eax)
  801eb6:	8b 00                	mov    (%eax),%eax
  801eb8:	85 c0                	test   %eax,%eax
  801eba:	74 18                	je     801ed4 <initialize_MemBlocksList+0x88>
  801ebc:	a1 48 41 80 00       	mov    0x804148,%eax
  801ec1:	8b 15 50 40 80 00    	mov    0x804050,%edx
  801ec7:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801eca:	c1 e1 04             	shl    $0x4,%ecx
  801ecd:	01 ca                	add    %ecx,%edx
  801ecf:	89 50 04             	mov    %edx,0x4(%eax)
  801ed2:	eb 12                	jmp    801ee6 <initialize_MemBlocksList+0x9a>
  801ed4:	a1 50 40 80 00       	mov    0x804050,%eax
  801ed9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801edc:	c1 e2 04             	shl    $0x4,%edx
  801edf:	01 d0                	add    %edx,%eax
  801ee1:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801ee6:	a1 50 40 80 00       	mov    0x804050,%eax
  801eeb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801eee:	c1 e2 04             	shl    $0x4,%edx
  801ef1:	01 d0                	add    %edx,%eax
  801ef3:	a3 48 41 80 00       	mov    %eax,0x804148
  801ef8:	a1 50 40 80 00       	mov    0x804050,%eax
  801efd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f00:	c1 e2 04             	shl    $0x4,%edx
  801f03:	01 d0                	add    %edx,%eax
  801f05:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f0c:	a1 54 41 80 00       	mov    0x804154,%eax
  801f11:	40                   	inc    %eax
  801f12:	a3 54 41 80 00       	mov    %eax,0x804154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801f17:	ff 45 f4             	incl   -0xc(%ebp)
  801f1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f1d:	3b 45 08             	cmp    0x8(%ebp),%eax
  801f20:	0f 82 56 ff ff ff    	jb     801e7c <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801f26:	90                   	nop
  801f27:	c9                   	leave  
  801f28:	c3                   	ret    

00801f29 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801f29:	55                   	push   %ebp
  801f2a:	89 e5                	mov    %esp,%ebp
  801f2c:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f32:	8b 00                	mov    (%eax),%eax
  801f34:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f37:	eb 19                	jmp    801f52 <find_block+0x29>
	{
		if(va==point->sva)
  801f39:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f3c:	8b 40 08             	mov    0x8(%eax),%eax
  801f3f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801f42:	75 05                	jne    801f49 <find_block+0x20>
		   return point;
  801f44:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f47:	eb 36                	jmp    801f7f <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801f49:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4c:	8b 40 08             	mov    0x8(%eax),%eax
  801f4f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f52:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f56:	74 07                	je     801f5f <find_block+0x36>
  801f58:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f5b:	8b 00                	mov    (%eax),%eax
  801f5d:	eb 05                	jmp    801f64 <find_block+0x3b>
  801f5f:	b8 00 00 00 00       	mov    $0x0,%eax
  801f64:	8b 55 08             	mov    0x8(%ebp),%edx
  801f67:	89 42 08             	mov    %eax,0x8(%edx)
  801f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6d:	8b 40 08             	mov    0x8(%eax),%eax
  801f70:	85 c0                	test   %eax,%eax
  801f72:	75 c5                	jne    801f39 <find_block+0x10>
  801f74:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f78:	75 bf                	jne    801f39 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  801f7a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f7f:	c9                   	leave  
  801f80:	c3                   	ret    

00801f81 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  801f81:	55                   	push   %ebp
  801f82:	89 e5                	mov    %esp,%ebp
  801f84:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  801f87:	a1 40 40 80 00       	mov    0x804040,%eax
  801f8c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  801f8f:	a1 44 40 80 00       	mov    0x804044,%eax
  801f94:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  801f97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f9a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801f9d:	74 24                	je     801fc3 <insert_sorted_allocList+0x42>
  801f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa2:	8b 50 08             	mov    0x8(%eax),%edx
  801fa5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fa8:	8b 40 08             	mov    0x8(%eax),%eax
  801fab:	39 c2                	cmp    %eax,%edx
  801fad:	76 14                	jbe    801fc3 <insert_sorted_allocList+0x42>
  801faf:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb2:	8b 50 08             	mov    0x8(%eax),%edx
  801fb5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fb8:	8b 40 08             	mov    0x8(%eax),%eax
  801fbb:	39 c2                	cmp    %eax,%edx
  801fbd:	0f 82 60 01 00 00    	jb     802123 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  801fc3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fc7:	75 65                	jne    80202e <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  801fc9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801fcd:	75 14                	jne    801fe3 <insert_sorted_allocList+0x62>
  801fcf:	83 ec 04             	sub    $0x4,%esp
  801fd2:	68 c4 3e 80 00       	push   $0x803ec4
  801fd7:	6a 6b                	push   $0x6b
  801fd9:	68 e7 3e 80 00       	push   $0x803ee7
  801fde:	e8 9c e2 ff ff       	call   80027f <_panic>
  801fe3:	8b 15 40 40 80 00    	mov    0x804040,%edx
  801fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fec:	89 10                	mov    %edx,(%eax)
  801fee:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff1:	8b 00                	mov    (%eax),%eax
  801ff3:	85 c0                	test   %eax,%eax
  801ff5:	74 0d                	je     802004 <insert_sorted_allocList+0x83>
  801ff7:	a1 40 40 80 00       	mov    0x804040,%eax
  801ffc:	8b 55 08             	mov    0x8(%ebp),%edx
  801fff:	89 50 04             	mov    %edx,0x4(%eax)
  802002:	eb 08                	jmp    80200c <insert_sorted_allocList+0x8b>
  802004:	8b 45 08             	mov    0x8(%ebp),%eax
  802007:	a3 44 40 80 00       	mov    %eax,0x804044
  80200c:	8b 45 08             	mov    0x8(%ebp),%eax
  80200f:	a3 40 40 80 00       	mov    %eax,0x804040
  802014:	8b 45 08             	mov    0x8(%ebp),%eax
  802017:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80201e:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802023:	40                   	inc    %eax
  802024:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802029:	e9 dc 01 00 00       	jmp    80220a <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  80202e:	8b 45 08             	mov    0x8(%ebp),%eax
  802031:	8b 50 08             	mov    0x8(%eax),%edx
  802034:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802037:	8b 40 08             	mov    0x8(%eax),%eax
  80203a:	39 c2                	cmp    %eax,%edx
  80203c:	77 6c                	ja     8020aa <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  80203e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802042:	74 06                	je     80204a <insert_sorted_allocList+0xc9>
  802044:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802048:	75 14                	jne    80205e <insert_sorted_allocList+0xdd>
  80204a:	83 ec 04             	sub    $0x4,%esp
  80204d:	68 00 3f 80 00       	push   $0x803f00
  802052:	6a 6f                	push   $0x6f
  802054:	68 e7 3e 80 00       	push   $0x803ee7
  802059:	e8 21 e2 ff ff       	call   80027f <_panic>
  80205e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802061:	8b 50 04             	mov    0x4(%eax),%edx
  802064:	8b 45 08             	mov    0x8(%ebp),%eax
  802067:	89 50 04             	mov    %edx,0x4(%eax)
  80206a:	8b 45 08             	mov    0x8(%ebp),%eax
  80206d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802070:	89 10                	mov    %edx,(%eax)
  802072:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802075:	8b 40 04             	mov    0x4(%eax),%eax
  802078:	85 c0                	test   %eax,%eax
  80207a:	74 0d                	je     802089 <insert_sorted_allocList+0x108>
  80207c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80207f:	8b 40 04             	mov    0x4(%eax),%eax
  802082:	8b 55 08             	mov    0x8(%ebp),%edx
  802085:	89 10                	mov    %edx,(%eax)
  802087:	eb 08                	jmp    802091 <insert_sorted_allocList+0x110>
  802089:	8b 45 08             	mov    0x8(%ebp),%eax
  80208c:	a3 40 40 80 00       	mov    %eax,0x804040
  802091:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802094:	8b 55 08             	mov    0x8(%ebp),%edx
  802097:	89 50 04             	mov    %edx,0x4(%eax)
  80209a:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80209f:	40                   	inc    %eax
  8020a0:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8020a5:	e9 60 01 00 00       	jmp    80220a <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8020aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ad:	8b 50 08             	mov    0x8(%eax),%edx
  8020b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020b3:	8b 40 08             	mov    0x8(%eax),%eax
  8020b6:	39 c2                	cmp    %eax,%edx
  8020b8:	0f 82 4c 01 00 00    	jb     80220a <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8020be:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020c2:	75 14                	jne    8020d8 <insert_sorted_allocList+0x157>
  8020c4:	83 ec 04             	sub    $0x4,%esp
  8020c7:	68 38 3f 80 00       	push   $0x803f38
  8020cc:	6a 73                	push   $0x73
  8020ce:	68 e7 3e 80 00       	push   $0x803ee7
  8020d3:	e8 a7 e1 ff ff       	call   80027f <_panic>
  8020d8:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8020de:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e1:	89 50 04             	mov    %edx,0x4(%eax)
  8020e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e7:	8b 40 04             	mov    0x4(%eax),%eax
  8020ea:	85 c0                	test   %eax,%eax
  8020ec:	74 0c                	je     8020fa <insert_sorted_allocList+0x179>
  8020ee:	a1 44 40 80 00       	mov    0x804044,%eax
  8020f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8020f6:	89 10                	mov    %edx,(%eax)
  8020f8:	eb 08                	jmp    802102 <insert_sorted_allocList+0x181>
  8020fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fd:	a3 40 40 80 00       	mov    %eax,0x804040
  802102:	8b 45 08             	mov    0x8(%ebp),%eax
  802105:	a3 44 40 80 00       	mov    %eax,0x804044
  80210a:	8b 45 08             	mov    0x8(%ebp),%eax
  80210d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802113:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802118:	40                   	inc    %eax
  802119:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80211e:	e9 e7 00 00 00       	jmp    80220a <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802123:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802126:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802129:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802130:	a1 40 40 80 00       	mov    0x804040,%eax
  802135:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802138:	e9 9d 00 00 00       	jmp    8021da <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  80213d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802140:	8b 00                	mov    (%eax),%eax
  802142:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802145:	8b 45 08             	mov    0x8(%ebp),%eax
  802148:	8b 50 08             	mov    0x8(%eax),%edx
  80214b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80214e:	8b 40 08             	mov    0x8(%eax),%eax
  802151:	39 c2                	cmp    %eax,%edx
  802153:	76 7d                	jbe    8021d2 <insert_sorted_allocList+0x251>
  802155:	8b 45 08             	mov    0x8(%ebp),%eax
  802158:	8b 50 08             	mov    0x8(%eax),%edx
  80215b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80215e:	8b 40 08             	mov    0x8(%eax),%eax
  802161:	39 c2                	cmp    %eax,%edx
  802163:	73 6d                	jae    8021d2 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802165:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802169:	74 06                	je     802171 <insert_sorted_allocList+0x1f0>
  80216b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80216f:	75 14                	jne    802185 <insert_sorted_allocList+0x204>
  802171:	83 ec 04             	sub    $0x4,%esp
  802174:	68 5c 3f 80 00       	push   $0x803f5c
  802179:	6a 7f                	push   $0x7f
  80217b:	68 e7 3e 80 00       	push   $0x803ee7
  802180:	e8 fa e0 ff ff       	call   80027f <_panic>
  802185:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802188:	8b 10                	mov    (%eax),%edx
  80218a:	8b 45 08             	mov    0x8(%ebp),%eax
  80218d:	89 10                	mov    %edx,(%eax)
  80218f:	8b 45 08             	mov    0x8(%ebp),%eax
  802192:	8b 00                	mov    (%eax),%eax
  802194:	85 c0                	test   %eax,%eax
  802196:	74 0b                	je     8021a3 <insert_sorted_allocList+0x222>
  802198:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219b:	8b 00                	mov    (%eax),%eax
  80219d:	8b 55 08             	mov    0x8(%ebp),%edx
  8021a0:	89 50 04             	mov    %edx,0x4(%eax)
  8021a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8021a9:	89 10                	mov    %edx,(%eax)
  8021ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021b1:	89 50 04             	mov    %edx,0x4(%eax)
  8021b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b7:	8b 00                	mov    (%eax),%eax
  8021b9:	85 c0                	test   %eax,%eax
  8021bb:	75 08                	jne    8021c5 <insert_sorted_allocList+0x244>
  8021bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c0:	a3 44 40 80 00       	mov    %eax,0x804044
  8021c5:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021ca:	40                   	inc    %eax
  8021cb:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  8021d0:	eb 39                	jmp    80220b <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8021d2:	a1 48 40 80 00       	mov    0x804048,%eax
  8021d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021da:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021de:	74 07                	je     8021e7 <insert_sorted_allocList+0x266>
  8021e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e3:	8b 00                	mov    (%eax),%eax
  8021e5:	eb 05                	jmp    8021ec <insert_sorted_allocList+0x26b>
  8021e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ec:	a3 48 40 80 00       	mov    %eax,0x804048
  8021f1:	a1 48 40 80 00       	mov    0x804048,%eax
  8021f6:	85 c0                	test   %eax,%eax
  8021f8:	0f 85 3f ff ff ff    	jne    80213d <insert_sorted_allocList+0x1bc>
  8021fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802202:	0f 85 35 ff ff ff    	jne    80213d <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802208:	eb 01                	jmp    80220b <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80220a:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80220b:	90                   	nop
  80220c:	c9                   	leave  
  80220d:	c3                   	ret    

0080220e <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80220e:	55                   	push   %ebp
  80220f:	89 e5                	mov    %esp,%ebp
  802211:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802214:	a1 38 41 80 00       	mov    0x804138,%eax
  802219:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80221c:	e9 85 01 00 00       	jmp    8023a6 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802221:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802224:	8b 40 0c             	mov    0xc(%eax),%eax
  802227:	3b 45 08             	cmp    0x8(%ebp),%eax
  80222a:	0f 82 6e 01 00 00    	jb     80239e <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802230:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802233:	8b 40 0c             	mov    0xc(%eax),%eax
  802236:	3b 45 08             	cmp    0x8(%ebp),%eax
  802239:	0f 85 8a 00 00 00    	jne    8022c9 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  80223f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802243:	75 17                	jne    80225c <alloc_block_FF+0x4e>
  802245:	83 ec 04             	sub    $0x4,%esp
  802248:	68 90 3f 80 00       	push   $0x803f90
  80224d:	68 93 00 00 00       	push   $0x93
  802252:	68 e7 3e 80 00       	push   $0x803ee7
  802257:	e8 23 e0 ff ff       	call   80027f <_panic>
  80225c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225f:	8b 00                	mov    (%eax),%eax
  802261:	85 c0                	test   %eax,%eax
  802263:	74 10                	je     802275 <alloc_block_FF+0x67>
  802265:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802268:	8b 00                	mov    (%eax),%eax
  80226a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80226d:	8b 52 04             	mov    0x4(%edx),%edx
  802270:	89 50 04             	mov    %edx,0x4(%eax)
  802273:	eb 0b                	jmp    802280 <alloc_block_FF+0x72>
  802275:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802278:	8b 40 04             	mov    0x4(%eax),%eax
  80227b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802280:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802283:	8b 40 04             	mov    0x4(%eax),%eax
  802286:	85 c0                	test   %eax,%eax
  802288:	74 0f                	je     802299 <alloc_block_FF+0x8b>
  80228a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228d:	8b 40 04             	mov    0x4(%eax),%eax
  802290:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802293:	8b 12                	mov    (%edx),%edx
  802295:	89 10                	mov    %edx,(%eax)
  802297:	eb 0a                	jmp    8022a3 <alloc_block_FF+0x95>
  802299:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229c:	8b 00                	mov    (%eax),%eax
  80229e:	a3 38 41 80 00       	mov    %eax,0x804138
  8022a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022af:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022b6:	a1 44 41 80 00       	mov    0x804144,%eax
  8022bb:	48                   	dec    %eax
  8022bc:	a3 44 41 80 00       	mov    %eax,0x804144
			   return  point;
  8022c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c4:	e9 10 01 00 00       	jmp    8023d9 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8022c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022cc:	8b 40 0c             	mov    0xc(%eax),%eax
  8022cf:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022d2:	0f 86 c6 00 00 00    	jbe    80239e <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8022d8:	a1 48 41 80 00       	mov    0x804148,%eax
  8022dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8022e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e3:	8b 50 08             	mov    0x8(%eax),%edx
  8022e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022e9:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8022ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8022f2:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8022f5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022f9:	75 17                	jne    802312 <alloc_block_FF+0x104>
  8022fb:	83 ec 04             	sub    $0x4,%esp
  8022fe:	68 90 3f 80 00       	push   $0x803f90
  802303:	68 9b 00 00 00       	push   $0x9b
  802308:	68 e7 3e 80 00       	push   $0x803ee7
  80230d:	e8 6d df ff ff       	call   80027f <_panic>
  802312:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802315:	8b 00                	mov    (%eax),%eax
  802317:	85 c0                	test   %eax,%eax
  802319:	74 10                	je     80232b <alloc_block_FF+0x11d>
  80231b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80231e:	8b 00                	mov    (%eax),%eax
  802320:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802323:	8b 52 04             	mov    0x4(%edx),%edx
  802326:	89 50 04             	mov    %edx,0x4(%eax)
  802329:	eb 0b                	jmp    802336 <alloc_block_FF+0x128>
  80232b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80232e:	8b 40 04             	mov    0x4(%eax),%eax
  802331:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802336:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802339:	8b 40 04             	mov    0x4(%eax),%eax
  80233c:	85 c0                	test   %eax,%eax
  80233e:	74 0f                	je     80234f <alloc_block_FF+0x141>
  802340:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802343:	8b 40 04             	mov    0x4(%eax),%eax
  802346:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802349:	8b 12                	mov    (%edx),%edx
  80234b:	89 10                	mov    %edx,(%eax)
  80234d:	eb 0a                	jmp    802359 <alloc_block_FF+0x14b>
  80234f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802352:	8b 00                	mov    (%eax),%eax
  802354:	a3 48 41 80 00       	mov    %eax,0x804148
  802359:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80235c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802362:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802365:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80236c:	a1 54 41 80 00       	mov    0x804154,%eax
  802371:	48                   	dec    %eax
  802372:	a3 54 41 80 00       	mov    %eax,0x804154
			   point->sva += size;
  802377:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237a:	8b 50 08             	mov    0x8(%eax),%edx
  80237d:	8b 45 08             	mov    0x8(%ebp),%eax
  802380:	01 c2                	add    %eax,%edx
  802382:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802385:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802388:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238b:	8b 40 0c             	mov    0xc(%eax),%eax
  80238e:	2b 45 08             	sub    0x8(%ebp),%eax
  802391:	89 c2                	mov    %eax,%edx
  802393:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802396:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802399:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80239c:	eb 3b                	jmp    8023d9 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80239e:	a1 40 41 80 00       	mov    0x804140,%eax
  8023a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023aa:	74 07                	je     8023b3 <alloc_block_FF+0x1a5>
  8023ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023af:	8b 00                	mov    (%eax),%eax
  8023b1:	eb 05                	jmp    8023b8 <alloc_block_FF+0x1aa>
  8023b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8023b8:	a3 40 41 80 00       	mov    %eax,0x804140
  8023bd:	a1 40 41 80 00       	mov    0x804140,%eax
  8023c2:	85 c0                	test   %eax,%eax
  8023c4:	0f 85 57 fe ff ff    	jne    802221 <alloc_block_FF+0x13>
  8023ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023ce:	0f 85 4d fe ff ff    	jne    802221 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8023d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023d9:	c9                   	leave  
  8023da:	c3                   	ret    

008023db <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8023db:	55                   	push   %ebp
  8023dc:	89 e5                	mov    %esp,%ebp
  8023de:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8023e1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8023e8:	a1 38 41 80 00       	mov    0x804138,%eax
  8023ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023f0:	e9 df 00 00 00       	jmp    8024d4 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8023f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f8:	8b 40 0c             	mov    0xc(%eax),%eax
  8023fb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023fe:	0f 82 c8 00 00 00    	jb     8024cc <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802404:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802407:	8b 40 0c             	mov    0xc(%eax),%eax
  80240a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80240d:	0f 85 8a 00 00 00    	jne    80249d <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802413:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802417:	75 17                	jne    802430 <alloc_block_BF+0x55>
  802419:	83 ec 04             	sub    $0x4,%esp
  80241c:	68 90 3f 80 00       	push   $0x803f90
  802421:	68 b7 00 00 00       	push   $0xb7
  802426:	68 e7 3e 80 00       	push   $0x803ee7
  80242b:	e8 4f de ff ff       	call   80027f <_panic>
  802430:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802433:	8b 00                	mov    (%eax),%eax
  802435:	85 c0                	test   %eax,%eax
  802437:	74 10                	je     802449 <alloc_block_BF+0x6e>
  802439:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243c:	8b 00                	mov    (%eax),%eax
  80243e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802441:	8b 52 04             	mov    0x4(%edx),%edx
  802444:	89 50 04             	mov    %edx,0x4(%eax)
  802447:	eb 0b                	jmp    802454 <alloc_block_BF+0x79>
  802449:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244c:	8b 40 04             	mov    0x4(%eax),%eax
  80244f:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802454:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802457:	8b 40 04             	mov    0x4(%eax),%eax
  80245a:	85 c0                	test   %eax,%eax
  80245c:	74 0f                	je     80246d <alloc_block_BF+0x92>
  80245e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802461:	8b 40 04             	mov    0x4(%eax),%eax
  802464:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802467:	8b 12                	mov    (%edx),%edx
  802469:	89 10                	mov    %edx,(%eax)
  80246b:	eb 0a                	jmp    802477 <alloc_block_BF+0x9c>
  80246d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802470:	8b 00                	mov    (%eax),%eax
  802472:	a3 38 41 80 00       	mov    %eax,0x804138
  802477:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802480:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802483:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80248a:	a1 44 41 80 00       	mov    0x804144,%eax
  80248f:	48                   	dec    %eax
  802490:	a3 44 41 80 00       	mov    %eax,0x804144
			   return currentMemBlock;
  802495:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802498:	e9 4d 01 00 00       	jmp    8025ea <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  80249d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a0:	8b 40 0c             	mov    0xc(%eax),%eax
  8024a3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024a6:	76 24                	jbe    8024cc <alloc_block_BF+0xf1>
  8024a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ab:	8b 40 0c             	mov    0xc(%eax),%eax
  8024ae:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8024b1:	73 19                	jae    8024cc <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8024b3:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8024ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bd:	8b 40 0c             	mov    0xc(%eax),%eax
  8024c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8024c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c6:	8b 40 08             	mov    0x8(%eax),%eax
  8024c9:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8024cc:	a1 40 41 80 00       	mov    0x804140,%eax
  8024d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024d8:	74 07                	je     8024e1 <alloc_block_BF+0x106>
  8024da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024dd:	8b 00                	mov    (%eax),%eax
  8024df:	eb 05                	jmp    8024e6 <alloc_block_BF+0x10b>
  8024e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8024e6:	a3 40 41 80 00       	mov    %eax,0x804140
  8024eb:	a1 40 41 80 00       	mov    0x804140,%eax
  8024f0:	85 c0                	test   %eax,%eax
  8024f2:	0f 85 fd fe ff ff    	jne    8023f5 <alloc_block_BF+0x1a>
  8024f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024fc:	0f 85 f3 fe ff ff    	jne    8023f5 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802502:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802506:	0f 84 d9 00 00 00    	je     8025e5 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  80250c:	a1 48 41 80 00       	mov    0x804148,%eax
  802511:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802514:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802517:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80251a:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  80251d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802520:	8b 55 08             	mov    0x8(%ebp),%edx
  802523:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802526:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80252a:	75 17                	jne    802543 <alloc_block_BF+0x168>
  80252c:	83 ec 04             	sub    $0x4,%esp
  80252f:	68 90 3f 80 00       	push   $0x803f90
  802534:	68 c7 00 00 00       	push   $0xc7
  802539:	68 e7 3e 80 00       	push   $0x803ee7
  80253e:	e8 3c dd ff ff       	call   80027f <_panic>
  802543:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802546:	8b 00                	mov    (%eax),%eax
  802548:	85 c0                	test   %eax,%eax
  80254a:	74 10                	je     80255c <alloc_block_BF+0x181>
  80254c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80254f:	8b 00                	mov    (%eax),%eax
  802551:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802554:	8b 52 04             	mov    0x4(%edx),%edx
  802557:	89 50 04             	mov    %edx,0x4(%eax)
  80255a:	eb 0b                	jmp    802567 <alloc_block_BF+0x18c>
  80255c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80255f:	8b 40 04             	mov    0x4(%eax),%eax
  802562:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802567:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80256a:	8b 40 04             	mov    0x4(%eax),%eax
  80256d:	85 c0                	test   %eax,%eax
  80256f:	74 0f                	je     802580 <alloc_block_BF+0x1a5>
  802571:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802574:	8b 40 04             	mov    0x4(%eax),%eax
  802577:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80257a:	8b 12                	mov    (%edx),%edx
  80257c:	89 10                	mov    %edx,(%eax)
  80257e:	eb 0a                	jmp    80258a <alloc_block_BF+0x1af>
  802580:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802583:	8b 00                	mov    (%eax),%eax
  802585:	a3 48 41 80 00       	mov    %eax,0x804148
  80258a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80258d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802593:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802596:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80259d:	a1 54 41 80 00       	mov    0x804154,%eax
  8025a2:	48                   	dec    %eax
  8025a3:	a3 54 41 80 00       	mov    %eax,0x804154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8025a8:	83 ec 08             	sub    $0x8,%esp
  8025ab:	ff 75 ec             	pushl  -0x14(%ebp)
  8025ae:	68 38 41 80 00       	push   $0x804138
  8025b3:	e8 71 f9 ff ff       	call   801f29 <find_block>
  8025b8:	83 c4 10             	add    $0x10,%esp
  8025bb:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8025be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025c1:	8b 50 08             	mov    0x8(%eax),%edx
  8025c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c7:	01 c2                	add    %eax,%edx
  8025c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025cc:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8025cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8025d5:	2b 45 08             	sub    0x8(%ebp),%eax
  8025d8:	89 c2                	mov    %eax,%edx
  8025da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025dd:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8025e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025e3:	eb 05                	jmp    8025ea <alloc_block_BF+0x20f>
	}
	return NULL;
  8025e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025ea:	c9                   	leave  
  8025eb:	c3                   	ret    

008025ec <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8025ec:	55                   	push   %ebp
  8025ed:	89 e5                	mov    %esp,%ebp
  8025ef:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8025f2:	a1 28 40 80 00       	mov    0x804028,%eax
  8025f7:	85 c0                	test   %eax,%eax
  8025f9:	0f 85 de 01 00 00    	jne    8027dd <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8025ff:	a1 38 41 80 00       	mov    0x804138,%eax
  802604:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802607:	e9 9e 01 00 00       	jmp    8027aa <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  80260c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260f:	8b 40 0c             	mov    0xc(%eax),%eax
  802612:	3b 45 08             	cmp    0x8(%ebp),%eax
  802615:	0f 82 87 01 00 00    	jb     8027a2 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  80261b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261e:	8b 40 0c             	mov    0xc(%eax),%eax
  802621:	3b 45 08             	cmp    0x8(%ebp),%eax
  802624:	0f 85 95 00 00 00    	jne    8026bf <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  80262a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80262e:	75 17                	jne    802647 <alloc_block_NF+0x5b>
  802630:	83 ec 04             	sub    $0x4,%esp
  802633:	68 90 3f 80 00       	push   $0x803f90
  802638:	68 e0 00 00 00       	push   $0xe0
  80263d:	68 e7 3e 80 00       	push   $0x803ee7
  802642:	e8 38 dc ff ff       	call   80027f <_panic>
  802647:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264a:	8b 00                	mov    (%eax),%eax
  80264c:	85 c0                	test   %eax,%eax
  80264e:	74 10                	je     802660 <alloc_block_NF+0x74>
  802650:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802653:	8b 00                	mov    (%eax),%eax
  802655:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802658:	8b 52 04             	mov    0x4(%edx),%edx
  80265b:	89 50 04             	mov    %edx,0x4(%eax)
  80265e:	eb 0b                	jmp    80266b <alloc_block_NF+0x7f>
  802660:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802663:	8b 40 04             	mov    0x4(%eax),%eax
  802666:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80266b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266e:	8b 40 04             	mov    0x4(%eax),%eax
  802671:	85 c0                	test   %eax,%eax
  802673:	74 0f                	je     802684 <alloc_block_NF+0x98>
  802675:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802678:	8b 40 04             	mov    0x4(%eax),%eax
  80267b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80267e:	8b 12                	mov    (%edx),%edx
  802680:	89 10                	mov    %edx,(%eax)
  802682:	eb 0a                	jmp    80268e <alloc_block_NF+0xa2>
  802684:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802687:	8b 00                	mov    (%eax),%eax
  802689:	a3 38 41 80 00       	mov    %eax,0x804138
  80268e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802691:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802697:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026a1:	a1 44 41 80 00       	mov    0x804144,%eax
  8026a6:	48                   	dec    %eax
  8026a7:	a3 44 41 80 00       	mov    %eax,0x804144
				   svaOfNF = point->sva;
  8026ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026af:	8b 40 08             	mov    0x8(%eax),%eax
  8026b2:	a3 28 40 80 00       	mov    %eax,0x804028
				   return  point;
  8026b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ba:	e9 f8 04 00 00       	jmp    802bb7 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8026bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c2:	8b 40 0c             	mov    0xc(%eax),%eax
  8026c5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026c8:	0f 86 d4 00 00 00    	jbe    8027a2 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8026ce:	a1 48 41 80 00       	mov    0x804148,%eax
  8026d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8026d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d9:	8b 50 08             	mov    0x8(%eax),%edx
  8026dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026df:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8026e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8026e8:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8026eb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026ef:	75 17                	jne    802708 <alloc_block_NF+0x11c>
  8026f1:	83 ec 04             	sub    $0x4,%esp
  8026f4:	68 90 3f 80 00       	push   $0x803f90
  8026f9:	68 e9 00 00 00       	push   $0xe9
  8026fe:	68 e7 3e 80 00       	push   $0x803ee7
  802703:	e8 77 db ff ff       	call   80027f <_panic>
  802708:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80270b:	8b 00                	mov    (%eax),%eax
  80270d:	85 c0                	test   %eax,%eax
  80270f:	74 10                	je     802721 <alloc_block_NF+0x135>
  802711:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802714:	8b 00                	mov    (%eax),%eax
  802716:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802719:	8b 52 04             	mov    0x4(%edx),%edx
  80271c:	89 50 04             	mov    %edx,0x4(%eax)
  80271f:	eb 0b                	jmp    80272c <alloc_block_NF+0x140>
  802721:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802724:	8b 40 04             	mov    0x4(%eax),%eax
  802727:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80272c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80272f:	8b 40 04             	mov    0x4(%eax),%eax
  802732:	85 c0                	test   %eax,%eax
  802734:	74 0f                	je     802745 <alloc_block_NF+0x159>
  802736:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802739:	8b 40 04             	mov    0x4(%eax),%eax
  80273c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80273f:	8b 12                	mov    (%edx),%edx
  802741:	89 10                	mov    %edx,(%eax)
  802743:	eb 0a                	jmp    80274f <alloc_block_NF+0x163>
  802745:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802748:	8b 00                	mov    (%eax),%eax
  80274a:	a3 48 41 80 00       	mov    %eax,0x804148
  80274f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802752:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802758:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80275b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802762:	a1 54 41 80 00       	mov    0x804154,%eax
  802767:	48                   	dec    %eax
  802768:	a3 54 41 80 00       	mov    %eax,0x804154
				   svaOfNF = ReturnedBlock->sva;
  80276d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802770:	8b 40 08             	mov    0x8(%eax),%eax
  802773:	a3 28 40 80 00       	mov    %eax,0x804028
				   point->sva += size;
  802778:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277b:	8b 50 08             	mov    0x8(%eax),%edx
  80277e:	8b 45 08             	mov    0x8(%ebp),%eax
  802781:	01 c2                	add    %eax,%edx
  802783:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802786:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802789:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278c:	8b 40 0c             	mov    0xc(%eax),%eax
  80278f:	2b 45 08             	sub    0x8(%ebp),%eax
  802792:	89 c2                	mov    %eax,%edx
  802794:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802797:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  80279a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80279d:	e9 15 04 00 00       	jmp    802bb7 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8027a2:	a1 40 41 80 00       	mov    0x804140,%eax
  8027a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027ae:	74 07                	je     8027b7 <alloc_block_NF+0x1cb>
  8027b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b3:	8b 00                	mov    (%eax),%eax
  8027b5:	eb 05                	jmp    8027bc <alloc_block_NF+0x1d0>
  8027b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8027bc:	a3 40 41 80 00       	mov    %eax,0x804140
  8027c1:	a1 40 41 80 00       	mov    0x804140,%eax
  8027c6:	85 c0                	test   %eax,%eax
  8027c8:	0f 85 3e fe ff ff    	jne    80260c <alloc_block_NF+0x20>
  8027ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027d2:	0f 85 34 fe ff ff    	jne    80260c <alloc_block_NF+0x20>
  8027d8:	e9 d5 03 00 00       	jmp    802bb2 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8027dd:	a1 38 41 80 00       	mov    0x804138,%eax
  8027e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027e5:	e9 b1 01 00 00       	jmp    80299b <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8027ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ed:	8b 50 08             	mov    0x8(%eax),%edx
  8027f0:	a1 28 40 80 00       	mov    0x804028,%eax
  8027f5:	39 c2                	cmp    %eax,%edx
  8027f7:	0f 82 96 01 00 00    	jb     802993 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  8027fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802800:	8b 40 0c             	mov    0xc(%eax),%eax
  802803:	3b 45 08             	cmp    0x8(%ebp),%eax
  802806:	0f 82 87 01 00 00    	jb     802993 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  80280c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280f:	8b 40 0c             	mov    0xc(%eax),%eax
  802812:	3b 45 08             	cmp    0x8(%ebp),%eax
  802815:	0f 85 95 00 00 00    	jne    8028b0 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80281b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80281f:	75 17                	jne    802838 <alloc_block_NF+0x24c>
  802821:	83 ec 04             	sub    $0x4,%esp
  802824:	68 90 3f 80 00       	push   $0x803f90
  802829:	68 fc 00 00 00       	push   $0xfc
  80282e:	68 e7 3e 80 00       	push   $0x803ee7
  802833:	e8 47 da ff ff       	call   80027f <_panic>
  802838:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283b:	8b 00                	mov    (%eax),%eax
  80283d:	85 c0                	test   %eax,%eax
  80283f:	74 10                	je     802851 <alloc_block_NF+0x265>
  802841:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802844:	8b 00                	mov    (%eax),%eax
  802846:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802849:	8b 52 04             	mov    0x4(%edx),%edx
  80284c:	89 50 04             	mov    %edx,0x4(%eax)
  80284f:	eb 0b                	jmp    80285c <alloc_block_NF+0x270>
  802851:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802854:	8b 40 04             	mov    0x4(%eax),%eax
  802857:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80285c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285f:	8b 40 04             	mov    0x4(%eax),%eax
  802862:	85 c0                	test   %eax,%eax
  802864:	74 0f                	je     802875 <alloc_block_NF+0x289>
  802866:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802869:	8b 40 04             	mov    0x4(%eax),%eax
  80286c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80286f:	8b 12                	mov    (%edx),%edx
  802871:	89 10                	mov    %edx,(%eax)
  802873:	eb 0a                	jmp    80287f <alloc_block_NF+0x293>
  802875:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802878:	8b 00                	mov    (%eax),%eax
  80287a:	a3 38 41 80 00       	mov    %eax,0x804138
  80287f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802882:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802888:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802892:	a1 44 41 80 00       	mov    0x804144,%eax
  802897:	48                   	dec    %eax
  802898:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  80289d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a0:	8b 40 08             	mov    0x8(%eax),%eax
  8028a3:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  8028a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ab:	e9 07 03 00 00       	jmp    802bb7 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8028b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b3:	8b 40 0c             	mov    0xc(%eax),%eax
  8028b6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028b9:	0f 86 d4 00 00 00    	jbe    802993 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8028bf:	a1 48 41 80 00       	mov    0x804148,%eax
  8028c4:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  8028c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ca:	8b 50 08             	mov    0x8(%eax),%edx
  8028cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028d0:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8028d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8028d9:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8028dc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8028e0:	75 17                	jne    8028f9 <alloc_block_NF+0x30d>
  8028e2:	83 ec 04             	sub    $0x4,%esp
  8028e5:	68 90 3f 80 00       	push   $0x803f90
  8028ea:	68 04 01 00 00       	push   $0x104
  8028ef:	68 e7 3e 80 00       	push   $0x803ee7
  8028f4:	e8 86 d9 ff ff       	call   80027f <_panic>
  8028f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028fc:	8b 00                	mov    (%eax),%eax
  8028fe:	85 c0                	test   %eax,%eax
  802900:	74 10                	je     802912 <alloc_block_NF+0x326>
  802902:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802905:	8b 00                	mov    (%eax),%eax
  802907:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80290a:	8b 52 04             	mov    0x4(%edx),%edx
  80290d:	89 50 04             	mov    %edx,0x4(%eax)
  802910:	eb 0b                	jmp    80291d <alloc_block_NF+0x331>
  802912:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802915:	8b 40 04             	mov    0x4(%eax),%eax
  802918:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80291d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802920:	8b 40 04             	mov    0x4(%eax),%eax
  802923:	85 c0                	test   %eax,%eax
  802925:	74 0f                	je     802936 <alloc_block_NF+0x34a>
  802927:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80292a:	8b 40 04             	mov    0x4(%eax),%eax
  80292d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802930:	8b 12                	mov    (%edx),%edx
  802932:	89 10                	mov    %edx,(%eax)
  802934:	eb 0a                	jmp    802940 <alloc_block_NF+0x354>
  802936:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802939:	8b 00                	mov    (%eax),%eax
  80293b:	a3 48 41 80 00       	mov    %eax,0x804148
  802940:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802943:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802949:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80294c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802953:	a1 54 41 80 00       	mov    0x804154,%eax
  802958:	48                   	dec    %eax
  802959:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  80295e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802961:	8b 40 08             	mov    0x8(%eax),%eax
  802964:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  802969:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296c:	8b 50 08             	mov    0x8(%eax),%edx
  80296f:	8b 45 08             	mov    0x8(%ebp),%eax
  802972:	01 c2                	add    %eax,%edx
  802974:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802977:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  80297a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297d:	8b 40 0c             	mov    0xc(%eax),%eax
  802980:	2b 45 08             	sub    0x8(%ebp),%eax
  802983:	89 c2                	mov    %eax,%edx
  802985:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802988:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  80298b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80298e:	e9 24 02 00 00       	jmp    802bb7 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802993:	a1 40 41 80 00       	mov    0x804140,%eax
  802998:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80299b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80299f:	74 07                	je     8029a8 <alloc_block_NF+0x3bc>
  8029a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a4:	8b 00                	mov    (%eax),%eax
  8029a6:	eb 05                	jmp    8029ad <alloc_block_NF+0x3c1>
  8029a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8029ad:	a3 40 41 80 00       	mov    %eax,0x804140
  8029b2:	a1 40 41 80 00       	mov    0x804140,%eax
  8029b7:	85 c0                	test   %eax,%eax
  8029b9:	0f 85 2b fe ff ff    	jne    8027ea <alloc_block_NF+0x1fe>
  8029bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029c3:	0f 85 21 fe ff ff    	jne    8027ea <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8029c9:	a1 38 41 80 00       	mov    0x804138,%eax
  8029ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029d1:	e9 ae 01 00 00       	jmp    802b84 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  8029d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d9:	8b 50 08             	mov    0x8(%eax),%edx
  8029dc:	a1 28 40 80 00       	mov    0x804028,%eax
  8029e1:	39 c2                	cmp    %eax,%edx
  8029e3:	0f 83 93 01 00 00    	jae    802b7c <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  8029e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ec:	8b 40 0c             	mov    0xc(%eax),%eax
  8029ef:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029f2:	0f 82 84 01 00 00    	jb     802b7c <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  8029f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fb:	8b 40 0c             	mov    0xc(%eax),%eax
  8029fe:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a01:	0f 85 95 00 00 00    	jne    802a9c <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802a07:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a0b:	75 17                	jne    802a24 <alloc_block_NF+0x438>
  802a0d:	83 ec 04             	sub    $0x4,%esp
  802a10:	68 90 3f 80 00       	push   $0x803f90
  802a15:	68 14 01 00 00       	push   $0x114
  802a1a:	68 e7 3e 80 00       	push   $0x803ee7
  802a1f:	e8 5b d8 ff ff       	call   80027f <_panic>
  802a24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a27:	8b 00                	mov    (%eax),%eax
  802a29:	85 c0                	test   %eax,%eax
  802a2b:	74 10                	je     802a3d <alloc_block_NF+0x451>
  802a2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a30:	8b 00                	mov    (%eax),%eax
  802a32:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a35:	8b 52 04             	mov    0x4(%edx),%edx
  802a38:	89 50 04             	mov    %edx,0x4(%eax)
  802a3b:	eb 0b                	jmp    802a48 <alloc_block_NF+0x45c>
  802a3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a40:	8b 40 04             	mov    0x4(%eax),%eax
  802a43:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4b:	8b 40 04             	mov    0x4(%eax),%eax
  802a4e:	85 c0                	test   %eax,%eax
  802a50:	74 0f                	je     802a61 <alloc_block_NF+0x475>
  802a52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a55:	8b 40 04             	mov    0x4(%eax),%eax
  802a58:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a5b:	8b 12                	mov    (%edx),%edx
  802a5d:	89 10                	mov    %edx,(%eax)
  802a5f:	eb 0a                	jmp    802a6b <alloc_block_NF+0x47f>
  802a61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a64:	8b 00                	mov    (%eax),%eax
  802a66:	a3 38 41 80 00       	mov    %eax,0x804138
  802a6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a77:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a7e:	a1 44 41 80 00       	mov    0x804144,%eax
  802a83:	48                   	dec    %eax
  802a84:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  802a89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8c:	8b 40 08             	mov    0x8(%eax),%eax
  802a8f:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  802a94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a97:	e9 1b 01 00 00       	jmp    802bb7 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802a9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9f:	8b 40 0c             	mov    0xc(%eax),%eax
  802aa2:	3b 45 08             	cmp    0x8(%ebp),%eax
  802aa5:	0f 86 d1 00 00 00    	jbe    802b7c <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802aab:	a1 48 41 80 00       	mov    0x804148,%eax
  802ab0:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802ab3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab6:	8b 50 08             	mov    0x8(%eax),%edx
  802ab9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802abc:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802abf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ac2:	8b 55 08             	mov    0x8(%ebp),%edx
  802ac5:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802ac8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802acc:	75 17                	jne    802ae5 <alloc_block_NF+0x4f9>
  802ace:	83 ec 04             	sub    $0x4,%esp
  802ad1:	68 90 3f 80 00       	push   $0x803f90
  802ad6:	68 1c 01 00 00       	push   $0x11c
  802adb:	68 e7 3e 80 00       	push   $0x803ee7
  802ae0:	e8 9a d7 ff ff       	call   80027f <_panic>
  802ae5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ae8:	8b 00                	mov    (%eax),%eax
  802aea:	85 c0                	test   %eax,%eax
  802aec:	74 10                	je     802afe <alloc_block_NF+0x512>
  802aee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802af1:	8b 00                	mov    (%eax),%eax
  802af3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802af6:	8b 52 04             	mov    0x4(%edx),%edx
  802af9:	89 50 04             	mov    %edx,0x4(%eax)
  802afc:	eb 0b                	jmp    802b09 <alloc_block_NF+0x51d>
  802afe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b01:	8b 40 04             	mov    0x4(%eax),%eax
  802b04:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b09:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b0c:	8b 40 04             	mov    0x4(%eax),%eax
  802b0f:	85 c0                	test   %eax,%eax
  802b11:	74 0f                	je     802b22 <alloc_block_NF+0x536>
  802b13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b16:	8b 40 04             	mov    0x4(%eax),%eax
  802b19:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b1c:	8b 12                	mov    (%edx),%edx
  802b1e:	89 10                	mov    %edx,(%eax)
  802b20:	eb 0a                	jmp    802b2c <alloc_block_NF+0x540>
  802b22:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b25:	8b 00                	mov    (%eax),%eax
  802b27:	a3 48 41 80 00       	mov    %eax,0x804148
  802b2c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b2f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b35:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b38:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b3f:	a1 54 41 80 00       	mov    0x804154,%eax
  802b44:	48                   	dec    %eax
  802b45:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  802b4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b4d:	8b 40 08             	mov    0x8(%eax),%eax
  802b50:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  802b55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b58:	8b 50 08             	mov    0x8(%eax),%edx
  802b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5e:	01 c2                	add    %eax,%edx
  802b60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b63:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802b66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b69:	8b 40 0c             	mov    0xc(%eax),%eax
  802b6c:	2b 45 08             	sub    0x8(%ebp),%eax
  802b6f:	89 c2                	mov    %eax,%edx
  802b71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b74:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802b77:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b7a:	eb 3b                	jmp    802bb7 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b7c:	a1 40 41 80 00       	mov    0x804140,%eax
  802b81:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b84:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b88:	74 07                	je     802b91 <alloc_block_NF+0x5a5>
  802b8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8d:	8b 00                	mov    (%eax),%eax
  802b8f:	eb 05                	jmp    802b96 <alloc_block_NF+0x5aa>
  802b91:	b8 00 00 00 00       	mov    $0x0,%eax
  802b96:	a3 40 41 80 00       	mov    %eax,0x804140
  802b9b:	a1 40 41 80 00       	mov    0x804140,%eax
  802ba0:	85 c0                	test   %eax,%eax
  802ba2:	0f 85 2e fe ff ff    	jne    8029d6 <alloc_block_NF+0x3ea>
  802ba8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bac:	0f 85 24 fe ff ff    	jne    8029d6 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802bb2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bb7:	c9                   	leave  
  802bb8:	c3                   	ret    

00802bb9 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802bb9:	55                   	push   %ebp
  802bba:	89 e5                	mov    %esp,%ebp
  802bbc:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802bbf:	a1 38 41 80 00       	mov    0x804138,%eax
  802bc4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802bc7:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802bcc:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802bcf:	a1 38 41 80 00       	mov    0x804138,%eax
  802bd4:	85 c0                	test   %eax,%eax
  802bd6:	74 14                	je     802bec <insert_sorted_with_merge_freeList+0x33>
  802bd8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bdb:	8b 50 08             	mov    0x8(%eax),%edx
  802bde:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be1:	8b 40 08             	mov    0x8(%eax),%eax
  802be4:	39 c2                	cmp    %eax,%edx
  802be6:	0f 87 9b 01 00 00    	ja     802d87 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802bec:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bf0:	75 17                	jne    802c09 <insert_sorted_with_merge_freeList+0x50>
  802bf2:	83 ec 04             	sub    $0x4,%esp
  802bf5:	68 c4 3e 80 00       	push   $0x803ec4
  802bfa:	68 38 01 00 00       	push   $0x138
  802bff:	68 e7 3e 80 00       	push   $0x803ee7
  802c04:	e8 76 d6 ff ff       	call   80027f <_panic>
  802c09:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c12:	89 10                	mov    %edx,(%eax)
  802c14:	8b 45 08             	mov    0x8(%ebp),%eax
  802c17:	8b 00                	mov    (%eax),%eax
  802c19:	85 c0                	test   %eax,%eax
  802c1b:	74 0d                	je     802c2a <insert_sorted_with_merge_freeList+0x71>
  802c1d:	a1 38 41 80 00       	mov    0x804138,%eax
  802c22:	8b 55 08             	mov    0x8(%ebp),%edx
  802c25:	89 50 04             	mov    %edx,0x4(%eax)
  802c28:	eb 08                	jmp    802c32 <insert_sorted_with_merge_freeList+0x79>
  802c2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2d:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c32:	8b 45 08             	mov    0x8(%ebp),%eax
  802c35:	a3 38 41 80 00       	mov    %eax,0x804138
  802c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c44:	a1 44 41 80 00       	mov    0x804144,%eax
  802c49:	40                   	inc    %eax
  802c4a:	a3 44 41 80 00       	mov    %eax,0x804144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802c4f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c53:	0f 84 a8 06 00 00    	je     803301 <insert_sorted_with_merge_freeList+0x748>
  802c59:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5c:	8b 50 08             	mov    0x8(%eax),%edx
  802c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c62:	8b 40 0c             	mov    0xc(%eax),%eax
  802c65:	01 c2                	add    %eax,%edx
  802c67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c6a:	8b 40 08             	mov    0x8(%eax),%eax
  802c6d:	39 c2                	cmp    %eax,%edx
  802c6f:	0f 85 8c 06 00 00    	jne    803301 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802c75:	8b 45 08             	mov    0x8(%ebp),%eax
  802c78:	8b 50 0c             	mov    0xc(%eax),%edx
  802c7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c7e:	8b 40 0c             	mov    0xc(%eax),%eax
  802c81:	01 c2                	add    %eax,%edx
  802c83:	8b 45 08             	mov    0x8(%ebp),%eax
  802c86:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802c89:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c8d:	75 17                	jne    802ca6 <insert_sorted_with_merge_freeList+0xed>
  802c8f:	83 ec 04             	sub    $0x4,%esp
  802c92:	68 90 3f 80 00       	push   $0x803f90
  802c97:	68 3c 01 00 00       	push   $0x13c
  802c9c:	68 e7 3e 80 00       	push   $0x803ee7
  802ca1:	e8 d9 d5 ff ff       	call   80027f <_panic>
  802ca6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ca9:	8b 00                	mov    (%eax),%eax
  802cab:	85 c0                	test   %eax,%eax
  802cad:	74 10                	je     802cbf <insert_sorted_with_merge_freeList+0x106>
  802caf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb2:	8b 00                	mov    (%eax),%eax
  802cb4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cb7:	8b 52 04             	mov    0x4(%edx),%edx
  802cba:	89 50 04             	mov    %edx,0x4(%eax)
  802cbd:	eb 0b                	jmp    802cca <insert_sorted_with_merge_freeList+0x111>
  802cbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cc2:	8b 40 04             	mov    0x4(%eax),%eax
  802cc5:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802cca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ccd:	8b 40 04             	mov    0x4(%eax),%eax
  802cd0:	85 c0                	test   %eax,%eax
  802cd2:	74 0f                	je     802ce3 <insert_sorted_with_merge_freeList+0x12a>
  802cd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cd7:	8b 40 04             	mov    0x4(%eax),%eax
  802cda:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cdd:	8b 12                	mov    (%edx),%edx
  802cdf:	89 10                	mov    %edx,(%eax)
  802ce1:	eb 0a                	jmp    802ced <insert_sorted_with_merge_freeList+0x134>
  802ce3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ce6:	8b 00                	mov    (%eax),%eax
  802ce8:	a3 38 41 80 00       	mov    %eax,0x804138
  802ced:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cf6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d00:	a1 44 41 80 00       	mov    0x804144,%eax
  802d05:	48                   	dec    %eax
  802d06:	a3 44 41 80 00       	mov    %eax,0x804144
			head->size = 0;
  802d0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d0e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802d15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d18:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802d1f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d23:	75 17                	jne    802d3c <insert_sorted_with_merge_freeList+0x183>
  802d25:	83 ec 04             	sub    $0x4,%esp
  802d28:	68 c4 3e 80 00       	push   $0x803ec4
  802d2d:	68 3f 01 00 00       	push   $0x13f
  802d32:	68 e7 3e 80 00       	push   $0x803ee7
  802d37:	e8 43 d5 ff ff       	call   80027f <_panic>
  802d3c:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d45:	89 10                	mov    %edx,(%eax)
  802d47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d4a:	8b 00                	mov    (%eax),%eax
  802d4c:	85 c0                	test   %eax,%eax
  802d4e:	74 0d                	je     802d5d <insert_sorted_with_merge_freeList+0x1a4>
  802d50:	a1 48 41 80 00       	mov    0x804148,%eax
  802d55:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d58:	89 50 04             	mov    %edx,0x4(%eax)
  802d5b:	eb 08                	jmp    802d65 <insert_sorted_with_merge_freeList+0x1ac>
  802d5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d60:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d68:	a3 48 41 80 00       	mov    %eax,0x804148
  802d6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d70:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d77:	a1 54 41 80 00       	mov    0x804154,%eax
  802d7c:	40                   	inc    %eax
  802d7d:	a3 54 41 80 00       	mov    %eax,0x804154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802d82:	e9 7a 05 00 00       	jmp    803301 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802d87:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8a:	8b 50 08             	mov    0x8(%eax),%edx
  802d8d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d90:	8b 40 08             	mov    0x8(%eax),%eax
  802d93:	39 c2                	cmp    %eax,%edx
  802d95:	0f 82 14 01 00 00    	jb     802eaf <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802d9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d9e:	8b 50 08             	mov    0x8(%eax),%edx
  802da1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802da4:	8b 40 0c             	mov    0xc(%eax),%eax
  802da7:	01 c2                	add    %eax,%edx
  802da9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dac:	8b 40 08             	mov    0x8(%eax),%eax
  802daf:	39 c2                	cmp    %eax,%edx
  802db1:	0f 85 90 00 00 00    	jne    802e47 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802db7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dba:	8b 50 0c             	mov    0xc(%eax),%edx
  802dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc0:	8b 40 0c             	mov    0xc(%eax),%eax
  802dc3:	01 c2                	add    %eax,%edx
  802dc5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dc8:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802dcb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dce:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802dd5:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802ddf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802de3:	75 17                	jne    802dfc <insert_sorted_with_merge_freeList+0x243>
  802de5:	83 ec 04             	sub    $0x4,%esp
  802de8:	68 c4 3e 80 00       	push   $0x803ec4
  802ded:	68 49 01 00 00       	push   $0x149
  802df2:	68 e7 3e 80 00       	push   $0x803ee7
  802df7:	e8 83 d4 ff ff       	call   80027f <_panic>
  802dfc:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e02:	8b 45 08             	mov    0x8(%ebp),%eax
  802e05:	89 10                	mov    %edx,(%eax)
  802e07:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0a:	8b 00                	mov    (%eax),%eax
  802e0c:	85 c0                	test   %eax,%eax
  802e0e:	74 0d                	je     802e1d <insert_sorted_with_merge_freeList+0x264>
  802e10:	a1 48 41 80 00       	mov    0x804148,%eax
  802e15:	8b 55 08             	mov    0x8(%ebp),%edx
  802e18:	89 50 04             	mov    %edx,0x4(%eax)
  802e1b:	eb 08                	jmp    802e25 <insert_sorted_with_merge_freeList+0x26c>
  802e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e20:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e25:	8b 45 08             	mov    0x8(%ebp),%eax
  802e28:	a3 48 41 80 00       	mov    %eax,0x804148
  802e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e30:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e37:	a1 54 41 80 00       	mov    0x804154,%eax
  802e3c:	40                   	inc    %eax
  802e3d:	a3 54 41 80 00       	mov    %eax,0x804154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802e42:	e9 bb 04 00 00       	jmp    803302 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802e47:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e4b:	75 17                	jne    802e64 <insert_sorted_with_merge_freeList+0x2ab>
  802e4d:	83 ec 04             	sub    $0x4,%esp
  802e50:	68 38 3f 80 00       	push   $0x803f38
  802e55:	68 4c 01 00 00       	push   $0x14c
  802e5a:	68 e7 3e 80 00       	push   $0x803ee7
  802e5f:	e8 1b d4 ff ff       	call   80027f <_panic>
  802e64:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802e6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6d:	89 50 04             	mov    %edx,0x4(%eax)
  802e70:	8b 45 08             	mov    0x8(%ebp),%eax
  802e73:	8b 40 04             	mov    0x4(%eax),%eax
  802e76:	85 c0                	test   %eax,%eax
  802e78:	74 0c                	je     802e86 <insert_sorted_with_merge_freeList+0x2cd>
  802e7a:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802e7f:	8b 55 08             	mov    0x8(%ebp),%edx
  802e82:	89 10                	mov    %edx,(%eax)
  802e84:	eb 08                	jmp    802e8e <insert_sorted_with_merge_freeList+0x2d5>
  802e86:	8b 45 08             	mov    0x8(%ebp),%eax
  802e89:	a3 38 41 80 00       	mov    %eax,0x804138
  802e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e91:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802e96:	8b 45 08             	mov    0x8(%ebp),%eax
  802e99:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e9f:	a1 44 41 80 00       	mov    0x804144,%eax
  802ea4:	40                   	inc    %eax
  802ea5:	a3 44 41 80 00       	mov    %eax,0x804144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802eaa:	e9 53 04 00 00       	jmp    803302 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802eaf:	a1 38 41 80 00       	mov    0x804138,%eax
  802eb4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802eb7:	e9 15 04 00 00       	jmp    8032d1 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802ebc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebf:	8b 00                	mov    (%eax),%eax
  802ec1:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec7:	8b 50 08             	mov    0x8(%eax),%edx
  802eca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ecd:	8b 40 08             	mov    0x8(%eax),%eax
  802ed0:	39 c2                	cmp    %eax,%edx
  802ed2:	0f 86 f1 03 00 00    	jbe    8032c9 <insert_sorted_with_merge_freeList+0x710>
  802ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  802edb:	8b 50 08             	mov    0x8(%eax),%edx
  802ede:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ee1:	8b 40 08             	mov    0x8(%eax),%eax
  802ee4:	39 c2                	cmp    %eax,%edx
  802ee6:	0f 83 dd 03 00 00    	jae    8032c9 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802eec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eef:	8b 50 08             	mov    0x8(%eax),%edx
  802ef2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef5:	8b 40 0c             	mov    0xc(%eax),%eax
  802ef8:	01 c2                	add    %eax,%edx
  802efa:	8b 45 08             	mov    0x8(%ebp),%eax
  802efd:	8b 40 08             	mov    0x8(%eax),%eax
  802f00:	39 c2                	cmp    %eax,%edx
  802f02:	0f 85 b9 01 00 00    	jne    8030c1 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802f08:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0b:	8b 50 08             	mov    0x8(%eax),%edx
  802f0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f11:	8b 40 0c             	mov    0xc(%eax),%eax
  802f14:	01 c2                	add    %eax,%edx
  802f16:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f19:	8b 40 08             	mov    0x8(%eax),%eax
  802f1c:	39 c2                	cmp    %eax,%edx
  802f1e:	0f 85 0d 01 00 00    	jne    803031 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802f24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f27:	8b 50 0c             	mov    0xc(%eax),%edx
  802f2a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f2d:	8b 40 0c             	mov    0xc(%eax),%eax
  802f30:	01 c2                	add    %eax,%edx
  802f32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f35:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802f38:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f3c:	75 17                	jne    802f55 <insert_sorted_with_merge_freeList+0x39c>
  802f3e:	83 ec 04             	sub    $0x4,%esp
  802f41:	68 90 3f 80 00       	push   $0x803f90
  802f46:	68 5c 01 00 00       	push   $0x15c
  802f4b:	68 e7 3e 80 00       	push   $0x803ee7
  802f50:	e8 2a d3 ff ff       	call   80027f <_panic>
  802f55:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f58:	8b 00                	mov    (%eax),%eax
  802f5a:	85 c0                	test   %eax,%eax
  802f5c:	74 10                	je     802f6e <insert_sorted_with_merge_freeList+0x3b5>
  802f5e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f61:	8b 00                	mov    (%eax),%eax
  802f63:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f66:	8b 52 04             	mov    0x4(%edx),%edx
  802f69:	89 50 04             	mov    %edx,0x4(%eax)
  802f6c:	eb 0b                	jmp    802f79 <insert_sorted_with_merge_freeList+0x3c0>
  802f6e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f71:	8b 40 04             	mov    0x4(%eax),%eax
  802f74:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802f79:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f7c:	8b 40 04             	mov    0x4(%eax),%eax
  802f7f:	85 c0                	test   %eax,%eax
  802f81:	74 0f                	je     802f92 <insert_sorted_with_merge_freeList+0x3d9>
  802f83:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f86:	8b 40 04             	mov    0x4(%eax),%eax
  802f89:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f8c:	8b 12                	mov    (%edx),%edx
  802f8e:	89 10                	mov    %edx,(%eax)
  802f90:	eb 0a                	jmp    802f9c <insert_sorted_with_merge_freeList+0x3e3>
  802f92:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f95:	8b 00                	mov    (%eax),%eax
  802f97:	a3 38 41 80 00       	mov    %eax,0x804138
  802f9c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f9f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fa5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fa8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802faf:	a1 44 41 80 00       	mov    0x804144,%eax
  802fb4:	48                   	dec    %eax
  802fb5:	a3 44 41 80 00       	mov    %eax,0x804144
						nextBlock->sva = 0;
  802fba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fbd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  802fc4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fc7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  802fce:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802fd2:	75 17                	jne    802feb <insert_sorted_with_merge_freeList+0x432>
  802fd4:	83 ec 04             	sub    $0x4,%esp
  802fd7:	68 c4 3e 80 00       	push   $0x803ec4
  802fdc:	68 5f 01 00 00       	push   $0x15f
  802fe1:	68 e7 3e 80 00       	push   $0x803ee7
  802fe6:	e8 94 d2 ff ff       	call   80027f <_panic>
  802feb:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ff1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ff4:	89 10                	mov    %edx,(%eax)
  802ff6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ff9:	8b 00                	mov    (%eax),%eax
  802ffb:	85 c0                	test   %eax,%eax
  802ffd:	74 0d                	je     80300c <insert_sorted_with_merge_freeList+0x453>
  802fff:	a1 48 41 80 00       	mov    0x804148,%eax
  803004:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803007:	89 50 04             	mov    %edx,0x4(%eax)
  80300a:	eb 08                	jmp    803014 <insert_sorted_with_merge_freeList+0x45b>
  80300c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80300f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803014:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803017:	a3 48 41 80 00       	mov    %eax,0x804148
  80301c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80301f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803026:	a1 54 41 80 00       	mov    0x804154,%eax
  80302b:	40                   	inc    %eax
  80302c:	a3 54 41 80 00       	mov    %eax,0x804154
					}
					currentBlock->size += blockToInsert->size;
  803031:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803034:	8b 50 0c             	mov    0xc(%eax),%edx
  803037:	8b 45 08             	mov    0x8(%ebp),%eax
  80303a:	8b 40 0c             	mov    0xc(%eax),%eax
  80303d:	01 c2                	add    %eax,%edx
  80303f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803042:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803045:	8b 45 08             	mov    0x8(%ebp),%eax
  803048:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  80304f:	8b 45 08             	mov    0x8(%ebp),%eax
  803052:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803059:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80305d:	75 17                	jne    803076 <insert_sorted_with_merge_freeList+0x4bd>
  80305f:	83 ec 04             	sub    $0x4,%esp
  803062:	68 c4 3e 80 00       	push   $0x803ec4
  803067:	68 64 01 00 00       	push   $0x164
  80306c:	68 e7 3e 80 00       	push   $0x803ee7
  803071:	e8 09 d2 ff ff       	call   80027f <_panic>
  803076:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80307c:	8b 45 08             	mov    0x8(%ebp),%eax
  80307f:	89 10                	mov    %edx,(%eax)
  803081:	8b 45 08             	mov    0x8(%ebp),%eax
  803084:	8b 00                	mov    (%eax),%eax
  803086:	85 c0                	test   %eax,%eax
  803088:	74 0d                	je     803097 <insert_sorted_with_merge_freeList+0x4de>
  80308a:	a1 48 41 80 00       	mov    0x804148,%eax
  80308f:	8b 55 08             	mov    0x8(%ebp),%edx
  803092:	89 50 04             	mov    %edx,0x4(%eax)
  803095:	eb 08                	jmp    80309f <insert_sorted_with_merge_freeList+0x4e6>
  803097:	8b 45 08             	mov    0x8(%ebp),%eax
  80309a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80309f:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a2:	a3 48 41 80 00       	mov    %eax,0x804148
  8030a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030aa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030b1:	a1 54 41 80 00       	mov    0x804154,%eax
  8030b6:	40                   	inc    %eax
  8030b7:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  8030bc:	e9 41 02 00 00       	jmp    803302 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8030c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c4:	8b 50 08             	mov    0x8(%eax),%edx
  8030c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8030cd:	01 c2                	add    %eax,%edx
  8030cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030d2:	8b 40 08             	mov    0x8(%eax),%eax
  8030d5:	39 c2                	cmp    %eax,%edx
  8030d7:	0f 85 7c 01 00 00    	jne    803259 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8030dd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030e1:	74 06                	je     8030e9 <insert_sorted_with_merge_freeList+0x530>
  8030e3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030e7:	75 17                	jne    803100 <insert_sorted_with_merge_freeList+0x547>
  8030e9:	83 ec 04             	sub    $0x4,%esp
  8030ec:	68 00 3f 80 00       	push   $0x803f00
  8030f1:	68 69 01 00 00       	push   $0x169
  8030f6:	68 e7 3e 80 00       	push   $0x803ee7
  8030fb:	e8 7f d1 ff ff       	call   80027f <_panic>
  803100:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803103:	8b 50 04             	mov    0x4(%eax),%edx
  803106:	8b 45 08             	mov    0x8(%ebp),%eax
  803109:	89 50 04             	mov    %edx,0x4(%eax)
  80310c:	8b 45 08             	mov    0x8(%ebp),%eax
  80310f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803112:	89 10                	mov    %edx,(%eax)
  803114:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803117:	8b 40 04             	mov    0x4(%eax),%eax
  80311a:	85 c0                	test   %eax,%eax
  80311c:	74 0d                	je     80312b <insert_sorted_with_merge_freeList+0x572>
  80311e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803121:	8b 40 04             	mov    0x4(%eax),%eax
  803124:	8b 55 08             	mov    0x8(%ebp),%edx
  803127:	89 10                	mov    %edx,(%eax)
  803129:	eb 08                	jmp    803133 <insert_sorted_with_merge_freeList+0x57a>
  80312b:	8b 45 08             	mov    0x8(%ebp),%eax
  80312e:	a3 38 41 80 00       	mov    %eax,0x804138
  803133:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803136:	8b 55 08             	mov    0x8(%ebp),%edx
  803139:	89 50 04             	mov    %edx,0x4(%eax)
  80313c:	a1 44 41 80 00       	mov    0x804144,%eax
  803141:	40                   	inc    %eax
  803142:	a3 44 41 80 00       	mov    %eax,0x804144
					blockToInsert->size += nextBlock->size;
  803147:	8b 45 08             	mov    0x8(%ebp),%eax
  80314a:	8b 50 0c             	mov    0xc(%eax),%edx
  80314d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803150:	8b 40 0c             	mov    0xc(%eax),%eax
  803153:	01 c2                	add    %eax,%edx
  803155:	8b 45 08             	mov    0x8(%ebp),%eax
  803158:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80315b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80315f:	75 17                	jne    803178 <insert_sorted_with_merge_freeList+0x5bf>
  803161:	83 ec 04             	sub    $0x4,%esp
  803164:	68 90 3f 80 00       	push   $0x803f90
  803169:	68 6b 01 00 00       	push   $0x16b
  80316e:	68 e7 3e 80 00       	push   $0x803ee7
  803173:	e8 07 d1 ff ff       	call   80027f <_panic>
  803178:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80317b:	8b 00                	mov    (%eax),%eax
  80317d:	85 c0                	test   %eax,%eax
  80317f:	74 10                	je     803191 <insert_sorted_with_merge_freeList+0x5d8>
  803181:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803184:	8b 00                	mov    (%eax),%eax
  803186:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803189:	8b 52 04             	mov    0x4(%edx),%edx
  80318c:	89 50 04             	mov    %edx,0x4(%eax)
  80318f:	eb 0b                	jmp    80319c <insert_sorted_with_merge_freeList+0x5e3>
  803191:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803194:	8b 40 04             	mov    0x4(%eax),%eax
  803197:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80319c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80319f:	8b 40 04             	mov    0x4(%eax),%eax
  8031a2:	85 c0                	test   %eax,%eax
  8031a4:	74 0f                	je     8031b5 <insert_sorted_with_merge_freeList+0x5fc>
  8031a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031a9:	8b 40 04             	mov    0x4(%eax),%eax
  8031ac:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031af:	8b 12                	mov    (%edx),%edx
  8031b1:	89 10                	mov    %edx,(%eax)
  8031b3:	eb 0a                	jmp    8031bf <insert_sorted_with_merge_freeList+0x606>
  8031b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031b8:	8b 00                	mov    (%eax),%eax
  8031ba:	a3 38 41 80 00       	mov    %eax,0x804138
  8031bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031cb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031d2:	a1 44 41 80 00       	mov    0x804144,%eax
  8031d7:	48                   	dec    %eax
  8031d8:	a3 44 41 80 00       	mov    %eax,0x804144
					nextBlock->sva = 0;
  8031dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8031e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ea:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8031f1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031f5:	75 17                	jne    80320e <insert_sorted_with_merge_freeList+0x655>
  8031f7:	83 ec 04             	sub    $0x4,%esp
  8031fa:	68 c4 3e 80 00       	push   $0x803ec4
  8031ff:	68 6e 01 00 00       	push   $0x16e
  803204:	68 e7 3e 80 00       	push   $0x803ee7
  803209:	e8 71 d0 ff ff       	call   80027f <_panic>
  80320e:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803214:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803217:	89 10                	mov    %edx,(%eax)
  803219:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80321c:	8b 00                	mov    (%eax),%eax
  80321e:	85 c0                	test   %eax,%eax
  803220:	74 0d                	je     80322f <insert_sorted_with_merge_freeList+0x676>
  803222:	a1 48 41 80 00       	mov    0x804148,%eax
  803227:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80322a:	89 50 04             	mov    %edx,0x4(%eax)
  80322d:	eb 08                	jmp    803237 <insert_sorted_with_merge_freeList+0x67e>
  80322f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803232:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803237:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80323a:	a3 48 41 80 00       	mov    %eax,0x804148
  80323f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803242:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803249:	a1 54 41 80 00       	mov    0x804154,%eax
  80324e:	40                   	inc    %eax
  80324f:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  803254:	e9 a9 00 00 00       	jmp    803302 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803259:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80325d:	74 06                	je     803265 <insert_sorted_with_merge_freeList+0x6ac>
  80325f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803263:	75 17                	jne    80327c <insert_sorted_with_merge_freeList+0x6c3>
  803265:	83 ec 04             	sub    $0x4,%esp
  803268:	68 5c 3f 80 00       	push   $0x803f5c
  80326d:	68 73 01 00 00       	push   $0x173
  803272:	68 e7 3e 80 00       	push   $0x803ee7
  803277:	e8 03 d0 ff ff       	call   80027f <_panic>
  80327c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80327f:	8b 10                	mov    (%eax),%edx
  803281:	8b 45 08             	mov    0x8(%ebp),%eax
  803284:	89 10                	mov    %edx,(%eax)
  803286:	8b 45 08             	mov    0x8(%ebp),%eax
  803289:	8b 00                	mov    (%eax),%eax
  80328b:	85 c0                	test   %eax,%eax
  80328d:	74 0b                	je     80329a <insert_sorted_with_merge_freeList+0x6e1>
  80328f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803292:	8b 00                	mov    (%eax),%eax
  803294:	8b 55 08             	mov    0x8(%ebp),%edx
  803297:	89 50 04             	mov    %edx,0x4(%eax)
  80329a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80329d:	8b 55 08             	mov    0x8(%ebp),%edx
  8032a0:	89 10                	mov    %edx,(%eax)
  8032a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032a8:	89 50 04             	mov    %edx,0x4(%eax)
  8032ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ae:	8b 00                	mov    (%eax),%eax
  8032b0:	85 c0                	test   %eax,%eax
  8032b2:	75 08                	jne    8032bc <insert_sorted_with_merge_freeList+0x703>
  8032b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b7:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8032bc:	a1 44 41 80 00       	mov    0x804144,%eax
  8032c1:	40                   	inc    %eax
  8032c2:	a3 44 41 80 00       	mov    %eax,0x804144
					break;
  8032c7:	eb 39                	jmp    803302 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8032c9:	a1 40 41 80 00       	mov    0x804140,%eax
  8032ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032d5:	74 07                	je     8032de <insert_sorted_with_merge_freeList+0x725>
  8032d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032da:	8b 00                	mov    (%eax),%eax
  8032dc:	eb 05                	jmp    8032e3 <insert_sorted_with_merge_freeList+0x72a>
  8032de:	b8 00 00 00 00       	mov    $0x0,%eax
  8032e3:	a3 40 41 80 00       	mov    %eax,0x804140
  8032e8:	a1 40 41 80 00       	mov    0x804140,%eax
  8032ed:	85 c0                	test   %eax,%eax
  8032ef:	0f 85 c7 fb ff ff    	jne    802ebc <insert_sorted_with_merge_freeList+0x303>
  8032f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032f9:	0f 85 bd fb ff ff    	jne    802ebc <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8032ff:	eb 01                	jmp    803302 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803301:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803302:	90                   	nop
  803303:	c9                   	leave  
  803304:	c3                   	ret    
  803305:	66 90                	xchg   %ax,%ax
  803307:	90                   	nop

00803308 <__udivdi3>:
  803308:	55                   	push   %ebp
  803309:	57                   	push   %edi
  80330a:	56                   	push   %esi
  80330b:	53                   	push   %ebx
  80330c:	83 ec 1c             	sub    $0x1c,%esp
  80330f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803313:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803317:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80331b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80331f:	89 ca                	mov    %ecx,%edx
  803321:	89 f8                	mov    %edi,%eax
  803323:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803327:	85 f6                	test   %esi,%esi
  803329:	75 2d                	jne    803358 <__udivdi3+0x50>
  80332b:	39 cf                	cmp    %ecx,%edi
  80332d:	77 65                	ja     803394 <__udivdi3+0x8c>
  80332f:	89 fd                	mov    %edi,%ebp
  803331:	85 ff                	test   %edi,%edi
  803333:	75 0b                	jne    803340 <__udivdi3+0x38>
  803335:	b8 01 00 00 00       	mov    $0x1,%eax
  80333a:	31 d2                	xor    %edx,%edx
  80333c:	f7 f7                	div    %edi
  80333e:	89 c5                	mov    %eax,%ebp
  803340:	31 d2                	xor    %edx,%edx
  803342:	89 c8                	mov    %ecx,%eax
  803344:	f7 f5                	div    %ebp
  803346:	89 c1                	mov    %eax,%ecx
  803348:	89 d8                	mov    %ebx,%eax
  80334a:	f7 f5                	div    %ebp
  80334c:	89 cf                	mov    %ecx,%edi
  80334e:	89 fa                	mov    %edi,%edx
  803350:	83 c4 1c             	add    $0x1c,%esp
  803353:	5b                   	pop    %ebx
  803354:	5e                   	pop    %esi
  803355:	5f                   	pop    %edi
  803356:	5d                   	pop    %ebp
  803357:	c3                   	ret    
  803358:	39 ce                	cmp    %ecx,%esi
  80335a:	77 28                	ja     803384 <__udivdi3+0x7c>
  80335c:	0f bd fe             	bsr    %esi,%edi
  80335f:	83 f7 1f             	xor    $0x1f,%edi
  803362:	75 40                	jne    8033a4 <__udivdi3+0x9c>
  803364:	39 ce                	cmp    %ecx,%esi
  803366:	72 0a                	jb     803372 <__udivdi3+0x6a>
  803368:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80336c:	0f 87 9e 00 00 00    	ja     803410 <__udivdi3+0x108>
  803372:	b8 01 00 00 00       	mov    $0x1,%eax
  803377:	89 fa                	mov    %edi,%edx
  803379:	83 c4 1c             	add    $0x1c,%esp
  80337c:	5b                   	pop    %ebx
  80337d:	5e                   	pop    %esi
  80337e:	5f                   	pop    %edi
  80337f:	5d                   	pop    %ebp
  803380:	c3                   	ret    
  803381:	8d 76 00             	lea    0x0(%esi),%esi
  803384:	31 ff                	xor    %edi,%edi
  803386:	31 c0                	xor    %eax,%eax
  803388:	89 fa                	mov    %edi,%edx
  80338a:	83 c4 1c             	add    $0x1c,%esp
  80338d:	5b                   	pop    %ebx
  80338e:	5e                   	pop    %esi
  80338f:	5f                   	pop    %edi
  803390:	5d                   	pop    %ebp
  803391:	c3                   	ret    
  803392:	66 90                	xchg   %ax,%ax
  803394:	89 d8                	mov    %ebx,%eax
  803396:	f7 f7                	div    %edi
  803398:	31 ff                	xor    %edi,%edi
  80339a:	89 fa                	mov    %edi,%edx
  80339c:	83 c4 1c             	add    $0x1c,%esp
  80339f:	5b                   	pop    %ebx
  8033a0:	5e                   	pop    %esi
  8033a1:	5f                   	pop    %edi
  8033a2:	5d                   	pop    %ebp
  8033a3:	c3                   	ret    
  8033a4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8033a9:	89 eb                	mov    %ebp,%ebx
  8033ab:	29 fb                	sub    %edi,%ebx
  8033ad:	89 f9                	mov    %edi,%ecx
  8033af:	d3 e6                	shl    %cl,%esi
  8033b1:	89 c5                	mov    %eax,%ebp
  8033b3:	88 d9                	mov    %bl,%cl
  8033b5:	d3 ed                	shr    %cl,%ebp
  8033b7:	89 e9                	mov    %ebp,%ecx
  8033b9:	09 f1                	or     %esi,%ecx
  8033bb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8033bf:	89 f9                	mov    %edi,%ecx
  8033c1:	d3 e0                	shl    %cl,%eax
  8033c3:	89 c5                	mov    %eax,%ebp
  8033c5:	89 d6                	mov    %edx,%esi
  8033c7:	88 d9                	mov    %bl,%cl
  8033c9:	d3 ee                	shr    %cl,%esi
  8033cb:	89 f9                	mov    %edi,%ecx
  8033cd:	d3 e2                	shl    %cl,%edx
  8033cf:	8b 44 24 08          	mov    0x8(%esp),%eax
  8033d3:	88 d9                	mov    %bl,%cl
  8033d5:	d3 e8                	shr    %cl,%eax
  8033d7:	09 c2                	or     %eax,%edx
  8033d9:	89 d0                	mov    %edx,%eax
  8033db:	89 f2                	mov    %esi,%edx
  8033dd:	f7 74 24 0c          	divl   0xc(%esp)
  8033e1:	89 d6                	mov    %edx,%esi
  8033e3:	89 c3                	mov    %eax,%ebx
  8033e5:	f7 e5                	mul    %ebp
  8033e7:	39 d6                	cmp    %edx,%esi
  8033e9:	72 19                	jb     803404 <__udivdi3+0xfc>
  8033eb:	74 0b                	je     8033f8 <__udivdi3+0xf0>
  8033ed:	89 d8                	mov    %ebx,%eax
  8033ef:	31 ff                	xor    %edi,%edi
  8033f1:	e9 58 ff ff ff       	jmp    80334e <__udivdi3+0x46>
  8033f6:	66 90                	xchg   %ax,%ax
  8033f8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8033fc:	89 f9                	mov    %edi,%ecx
  8033fe:	d3 e2                	shl    %cl,%edx
  803400:	39 c2                	cmp    %eax,%edx
  803402:	73 e9                	jae    8033ed <__udivdi3+0xe5>
  803404:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803407:	31 ff                	xor    %edi,%edi
  803409:	e9 40 ff ff ff       	jmp    80334e <__udivdi3+0x46>
  80340e:	66 90                	xchg   %ax,%ax
  803410:	31 c0                	xor    %eax,%eax
  803412:	e9 37 ff ff ff       	jmp    80334e <__udivdi3+0x46>
  803417:	90                   	nop

00803418 <__umoddi3>:
  803418:	55                   	push   %ebp
  803419:	57                   	push   %edi
  80341a:	56                   	push   %esi
  80341b:	53                   	push   %ebx
  80341c:	83 ec 1c             	sub    $0x1c,%esp
  80341f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803423:	8b 74 24 34          	mov    0x34(%esp),%esi
  803427:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80342b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80342f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803433:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803437:	89 f3                	mov    %esi,%ebx
  803439:	89 fa                	mov    %edi,%edx
  80343b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80343f:	89 34 24             	mov    %esi,(%esp)
  803442:	85 c0                	test   %eax,%eax
  803444:	75 1a                	jne    803460 <__umoddi3+0x48>
  803446:	39 f7                	cmp    %esi,%edi
  803448:	0f 86 a2 00 00 00    	jbe    8034f0 <__umoddi3+0xd8>
  80344e:	89 c8                	mov    %ecx,%eax
  803450:	89 f2                	mov    %esi,%edx
  803452:	f7 f7                	div    %edi
  803454:	89 d0                	mov    %edx,%eax
  803456:	31 d2                	xor    %edx,%edx
  803458:	83 c4 1c             	add    $0x1c,%esp
  80345b:	5b                   	pop    %ebx
  80345c:	5e                   	pop    %esi
  80345d:	5f                   	pop    %edi
  80345e:	5d                   	pop    %ebp
  80345f:	c3                   	ret    
  803460:	39 f0                	cmp    %esi,%eax
  803462:	0f 87 ac 00 00 00    	ja     803514 <__umoddi3+0xfc>
  803468:	0f bd e8             	bsr    %eax,%ebp
  80346b:	83 f5 1f             	xor    $0x1f,%ebp
  80346e:	0f 84 ac 00 00 00    	je     803520 <__umoddi3+0x108>
  803474:	bf 20 00 00 00       	mov    $0x20,%edi
  803479:	29 ef                	sub    %ebp,%edi
  80347b:	89 fe                	mov    %edi,%esi
  80347d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803481:	89 e9                	mov    %ebp,%ecx
  803483:	d3 e0                	shl    %cl,%eax
  803485:	89 d7                	mov    %edx,%edi
  803487:	89 f1                	mov    %esi,%ecx
  803489:	d3 ef                	shr    %cl,%edi
  80348b:	09 c7                	or     %eax,%edi
  80348d:	89 e9                	mov    %ebp,%ecx
  80348f:	d3 e2                	shl    %cl,%edx
  803491:	89 14 24             	mov    %edx,(%esp)
  803494:	89 d8                	mov    %ebx,%eax
  803496:	d3 e0                	shl    %cl,%eax
  803498:	89 c2                	mov    %eax,%edx
  80349a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80349e:	d3 e0                	shl    %cl,%eax
  8034a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8034a4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034a8:	89 f1                	mov    %esi,%ecx
  8034aa:	d3 e8                	shr    %cl,%eax
  8034ac:	09 d0                	or     %edx,%eax
  8034ae:	d3 eb                	shr    %cl,%ebx
  8034b0:	89 da                	mov    %ebx,%edx
  8034b2:	f7 f7                	div    %edi
  8034b4:	89 d3                	mov    %edx,%ebx
  8034b6:	f7 24 24             	mull   (%esp)
  8034b9:	89 c6                	mov    %eax,%esi
  8034bb:	89 d1                	mov    %edx,%ecx
  8034bd:	39 d3                	cmp    %edx,%ebx
  8034bf:	0f 82 87 00 00 00    	jb     80354c <__umoddi3+0x134>
  8034c5:	0f 84 91 00 00 00    	je     80355c <__umoddi3+0x144>
  8034cb:	8b 54 24 04          	mov    0x4(%esp),%edx
  8034cf:	29 f2                	sub    %esi,%edx
  8034d1:	19 cb                	sbb    %ecx,%ebx
  8034d3:	89 d8                	mov    %ebx,%eax
  8034d5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8034d9:	d3 e0                	shl    %cl,%eax
  8034db:	89 e9                	mov    %ebp,%ecx
  8034dd:	d3 ea                	shr    %cl,%edx
  8034df:	09 d0                	or     %edx,%eax
  8034e1:	89 e9                	mov    %ebp,%ecx
  8034e3:	d3 eb                	shr    %cl,%ebx
  8034e5:	89 da                	mov    %ebx,%edx
  8034e7:	83 c4 1c             	add    $0x1c,%esp
  8034ea:	5b                   	pop    %ebx
  8034eb:	5e                   	pop    %esi
  8034ec:	5f                   	pop    %edi
  8034ed:	5d                   	pop    %ebp
  8034ee:	c3                   	ret    
  8034ef:	90                   	nop
  8034f0:	89 fd                	mov    %edi,%ebp
  8034f2:	85 ff                	test   %edi,%edi
  8034f4:	75 0b                	jne    803501 <__umoddi3+0xe9>
  8034f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8034fb:	31 d2                	xor    %edx,%edx
  8034fd:	f7 f7                	div    %edi
  8034ff:	89 c5                	mov    %eax,%ebp
  803501:	89 f0                	mov    %esi,%eax
  803503:	31 d2                	xor    %edx,%edx
  803505:	f7 f5                	div    %ebp
  803507:	89 c8                	mov    %ecx,%eax
  803509:	f7 f5                	div    %ebp
  80350b:	89 d0                	mov    %edx,%eax
  80350d:	e9 44 ff ff ff       	jmp    803456 <__umoddi3+0x3e>
  803512:	66 90                	xchg   %ax,%ax
  803514:	89 c8                	mov    %ecx,%eax
  803516:	89 f2                	mov    %esi,%edx
  803518:	83 c4 1c             	add    $0x1c,%esp
  80351b:	5b                   	pop    %ebx
  80351c:	5e                   	pop    %esi
  80351d:	5f                   	pop    %edi
  80351e:	5d                   	pop    %ebp
  80351f:	c3                   	ret    
  803520:	3b 04 24             	cmp    (%esp),%eax
  803523:	72 06                	jb     80352b <__umoddi3+0x113>
  803525:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803529:	77 0f                	ja     80353a <__umoddi3+0x122>
  80352b:	89 f2                	mov    %esi,%edx
  80352d:	29 f9                	sub    %edi,%ecx
  80352f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803533:	89 14 24             	mov    %edx,(%esp)
  803536:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80353a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80353e:	8b 14 24             	mov    (%esp),%edx
  803541:	83 c4 1c             	add    $0x1c,%esp
  803544:	5b                   	pop    %ebx
  803545:	5e                   	pop    %esi
  803546:	5f                   	pop    %edi
  803547:	5d                   	pop    %ebp
  803548:	c3                   	ret    
  803549:	8d 76 00             	lea    0x0(%esi),%esi
  80354c:	2b 04 24             	sub    (%esp),%eax
  80354f:	19 fa                	sbb    %edi,%edx
  803551:	89 d1                	mov    %edx,%ecx
  803553:	89 c6                	mov    %eax,%esi
  803555:	e9 71 ff ff ff       	jmp    8034cb <__umoddi3+0xb3>
  80355a:	66 90                	xchg   %ax,%ax
  80355c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803560:	72 ea                	jb     80354c <__umoddi3+0x134>
  803562:	89 d9                	mov    %ebx,%ecx
  803564:	e9 62 ff ff ff       	jmp    8034cb <__umoddi3+0xb3>
