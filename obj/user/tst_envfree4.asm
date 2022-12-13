
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
  800045:	68 60 36 80 00       	push   $0x803660
  80004a:	e8 01 15 00 00       	call   801550 <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*numOfFinished = 0 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int freeFrames_before = sys_calculate_free_frames() ;
  80005e:	e8 bf 17 00 00       	call   801822 <sys_calculate_free_frames>
  800063:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800066:	e8 57 18 00 00       	call   8018c2 <sys_pf_calculate_allocated_pages>
  80006b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80006e:	83 ec 08             	sub    $0x8,%esp
  800071:	ff 75 f0             	pushl  -0x10(%ebp)
  800074:	68 70 36 80 00       	push   $0x803670
  800079:	e8 b5 04 00 00       	call   800533 <cprintf>
  80007e:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tsem1", 100,(myEnv->SecondListSize), 50);
  800081:	a1 20 50 80 00       	mov    0x805020,%eax
  800086:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80008c:	6a 32                	push   $0x32
  80008e:	50                   	push   %eax
  80008f:	6a 64                	push   $0x64
  800091:	68 a3 36 80 00       	push   $0x8036a3
  800096:	e8 f9 19 00 00       	call   801a94 <sys_create_env>
  80009b:	83 c4 10             	add    $0x10,%esp
  80009e:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sys_run_env(envIdProcessA);
  8000a1:	83 ec 0c             	sub    $0xc,%esp
  8000a4:	ff 75 e8             	pushl  -0x18(%ebp)
  8000a7:	e8 06 1a 00 00       	call   801ab2 <sys_run_env>
  8000ac:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 1) ;
  8000af:	90                   	nop
  8000b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000b3:	8b 00                	mov    (%eax),%eax
  8000b5:	83 f8 01             	cmp    $0x1,%eax
  8000b8:	75 f6                	jne    8000b0 <_main+0x78>
	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  8000ba:	e8 63 17 00 00       	call   801822 <sys_calculate_free_frames>
  8000bf:	83 ec 08             	sub    $0x8,%esp
  8000c2:	50                   	push   %eax
  8000c3:	68 ac 36 80 00       	push   $0x8036ac
  8000c8:	e8 66 04 00 00       	call   800533 <cprintf>
  8000cd:	83 c4 10             	add    $0x10,%esp

	sys_destroy_env(envIdProcessA);
  8000d0:	83 ec 0c             	sub    $0xc,%esp
  8000d3:	ff 75 e8             	pushl  -0x18(%ebp)
  8000d6:	e8 f3 19 00 00       	call   801ace <sys_destroy_env>
  8000db:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  8000de:	e8 3f 17 00 00       	call   801822 <sys_calculate_free_frames>
  8000e3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  8000e6:	e8 d7 17 00 00       	call   8018c2 <sys_pf_calculate_allocated_pages>
  8000eb:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if ((freeFrames_after - freeFrames_before) != 0) {
  8000ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000f1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8000f4:	74 27                	je     80011d <_main+0xe5>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\n",
  8000f6:	83 ec 08             	sub    $0x8,%esp
  8000f9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000fc:	68 e0 36 80 00       	push   $0x8036e0
  800101:	e8 2d 04 00 00       	call   800533 <cprintf>
  800106:	83 c4 10             	add    $0x10,%esp
				freeFrames_after);
		panic("env_free() does not work correctly... check it again.");
  800109:	83 ec 04             	sub    $0x4,%esp
  80010c:	68 30 37 80 00       	push   $0x803730
  800111:	6a 1f                	push   $0x1f
  800113:	68 66 37 80 00       	push   $0x803766
  800118:	e8 62 01 00 00       	call   80027f <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  80011d:	83 ec 08             	sub    $0x8,%esp
  800120:	ff 75 e4             	pushl  -0x1c(%ebp)
  800123:	68 7c 37 80 00       	push   $0x80377c
  800128:	e8 06 04 00 00       	call   800533 <cprintf>
  80012d:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 4 for envfree completed successfully.\n");
  800130:	83 ec 0c             	sub    $0xc,%esp
  800133:	68 dc 37 80 00       	push   $0x8037dc
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
  800149:	e8 b4 19 00 00       	call   801b02 <sys_getenvindex>
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
  800170:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800175:	a1 20 50 80 00       	mov    0x805020,%eax
  80017a:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800180:	84 c0                	test   %al,%al
  800182:	74 0f                	je     800193 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800184:	a1 20 50 80 00       	mov    0x805020,%eax
  800189:	05 5c 05 00 00       	add    $0x55c,%eax
  80018e:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800193:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800197:	7e 0a                	jle    8001a3 <libmain+0x60>
		binaryname = argv[0];
  800199:	8b 45 0c             	mov    0xc(%ebp),%eax
  80019c:	8b 00                	mov    (%eax),%eax
  80019e:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8001a3:	83 ec 08             	sub    $0x8,%esp
  8001a6:	ff 75 0c             	pushl  0xc(%ebp)
  8001a9:	ff 75 08             	pushl  0x8(%ebp)
  8001ac:	e8 87 fe ff ff       	call   800038 <_main>
  8001b1:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001b4:	e8 56 17 00 00       	call   80190f <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001b9:	83 ec 0c             	sub    $0xc,%esp
  8001bc:	68 40 38 80 00       	push   $0x803840
  8001c1:	e8 6d 03 00 00       	call   800533 <cprintf>
  8001c6:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001c9:	a1 20 50 80 00       	mov    0x805020,%eax
  8001ce:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8001d4:	a1 20 50 80 00       	mov    0x805020,%eax
  8001d9:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8001df:	83 ec 04             	sub    $0x4,%esp
  8001e2:	52                   	push   %edx
  8001e3:	50                   	push   %eax
  8001e4:	68 68 38 80 00       	push   $0x803868
  8001e9:	e8 45 03 00 00       	call   800533 <cprintf>
  8001ee:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001f1:	a1 20 50 80 00       	mov    0x805020,%eax
  8001f6:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8001fc:	a1 20 50 80 00       	mov    0x805020,%eax
  800201:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800207:	a1 20 50 80 00       	mov    0x805020,%eax
  80020c:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800212:	51                   	push   %ecx
  800213:	52                   	push   %edx
  800214:	50                   	push   %eax
  800215:	68 90 38 80 00       	push   $0x803890
  80021a:	e8 14 03 00 00       	call   800533 <cprintf>
  80021f:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800222:	a1 20 50 80 00       	mov    0x805020,%eax
  800227:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80022d:	83 ec 08             	sub    $0x8,%esp
  800230:	50                   	push   %eax
  800231:	68 e8 38 80 00       	push   $0x8038e8
  800236:	e8 f8 02 00 00       	call   800533 <cprintf>
  80023b:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80023e:	83 ec 0c             	sub    $0xc,%esp
  800241:	68 40 38 80 00       	push   $0x803840
  800246:	e8 e8 02 00 00       	call   800533 <cprintf>
  80024b:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80024e:	e8 d6 16 00 00       	call   801929 <sys_enable_interrupt>

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
  800266:	e8 63 18 00 00       	call   801ace <sys_destroy_env>
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
  800277:	e8 b8 18 00 00       	call   801b34 <sys_exit_env>
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
  80028e:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800293:	85 c0                	test   %eax,%eax
  800295:	74 16                	je     8002ad <_panic+0x2e>
		cprintf("%s: ", argv0);
  800297:	a1 5c 51 80 00       	mov    0x80515c,%eax
  80029c:	83 ec 08             	sub    $0x8,%esp
  80029f:	50                   	push   %eax
  8002a0:	68 fc 38 80 00       	push   $0x8038fc
  8002a5:	e8 89 02 00 00       	call   800533 <cprintf>
  8002aa:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002ad:	a1 00 50 80 00       	mov    0x805000,%eax
  8002b2:	ff 75 0c             	pushl  0xc(%ebp)
  8002b5:	ff 75 08             	pushl  0x8(%ebp)
  8002b8:	50                   	push   %eax
  8002b9:	68 01 39 80 00       	push   $0x803901
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
  8002dd:	68 1d 39 80 00       	push   $0x80391d
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
  8002f7:	a1 20 50 80 00       	mov    0x805020,%eax
  8002fc:	8b 50 74             	mov    0x74(%eax),%edx
  8002ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800302:	39 c2                	cmp    %eax,%edx
  800304:	74 14                	je     80031a <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800306:	83 ec 04             	sub    $0x4,%esp
  800309:	68 20 39 80 00       	push   $0x803920
  80030e:	6a 26                	push   $0x26
  800310:	68 6c 39 80 00       	push   $0x80396c
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
  80035a:	a1 20 50 80 00       	mov    0x805020,%eax
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
  80037a:	a1 20 50 80 00       	mov    0x805020,%eax
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
  8003c3:	a1 20 50 80 00       	mov    0x805020,%eax
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
  8003db:	68 78 39 80 00       	push   $0x803978
  8003e0:	6a 3a                	push   $0x3a
  8003e2:	68 6c 39 80 00       	push   $0x80396c
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
  80040b:	a1 20 50 80 00       	mov    0x805020,%eax
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
  800431:	a1 20 50 80 00       	mov    0x805020,%eax
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
  80044b:	68 cc 39 80 00       	push   $0x8039cc
  800450:	6a 44                	push   $0x44
  800452:	68 6c 39 80 00       	push   $0x80396c
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
  80048a:	a0 24 50 80 00       	mov    0x805024,%al
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
  8004a5:	e8 b7 12 00 00       	call   801761 <sys_cputs>
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
  8004ff:	a0 24 50 80 00       	mov    0x805024,%al
  800504:	0f b6 c0             	movzbl %al,%eax
  800507:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80050d:	83 ec 04             	sub    $0x4,%esp
  800510:	50                   	push   %eax
  800511:	52                   	push   %edx
  800512:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800518:	83 c0 08             	add    $0x8,%eax
  80051b:	50                   	push   %eax
  80051c:	e8 40 12 00 00       	call   801761 <sys_cputs>
  800521:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800524:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
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
  800539:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
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
  800566:	e8 a4 13 00 00       	call   80190f <sys_disable_interrupt>
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
  800586:	e8 9e 13 00 00       	call   801929 <sys_enable_interrupt>
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
  8005d0:	e8 0f 2e 00 00       	call   8033e4 <__udivdi3>
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
  800620:	e8 cf 2e 00 00       	call   8034f4 <__umoddi3>
  800625:	83 c4 10             	add    $0x10,%esp
  800628:	05 34 3c 80 00       	add    $0x803c34,%eax
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
  80077b:	8b 04 85 58 3c 80 00 	mov    0x803c58(,%eax,4),%eax
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
  80085c:	8b 34 9d a0 3a 80 00 	mov    0x803aa0(,%ebx,4),%esi
  800863:	85 f6                	test   %esi,%esi
  800865:	75 19                	jne    800880 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800867:	53                   	push   %ebx
  800868:	68 45 3c 80 00       	push   $0x803c45
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
  800881:	68 4e 3c 80 00       	push   $0x803c4e
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
  8008ae:	be 51 3c 80 00       	mov    $0x803c51,%esi
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
  8012c3:	a1 04 50 80 00       	mov    0x805004,%eax
  8012c8:	85 c0                	test   %eax,%eax
  8012ca:	74 1f                	je     8012eb <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8012cc:	e8 1d 00 00 00       	call   8012ee <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8012d1:	83 ec 0c             	sub    $0xc,%esp
  8012d4:	68 b0 3d 80 00       	push   $0x803db0
  8012d9:	e8 55 f2 ff ff       	call   800533 <cprintf>
  8012de:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8012e1:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
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
  8012f4:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  8012fb:	00 00 00 
  8012fe:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801305:	00 00 00 
  801308:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  80130f:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801312:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801319:	00 00 00 
  80131c:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801323:	00 00 00 
  801326:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
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
  80134b:	a3 50 50 80 00       	mov    %eax,0x805050
	MAX_MEM_BLOCK_CNT = (USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE;
  801350:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801357:	00 02 00 
	arr_size =  ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock), PAGE_SIZE);
  80135a:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801361:	a1 20 51 80 00       	mov    0x805120,%eax
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
  8013a4:	e8 fc 04 00 00       	call   8018a5 <sys_allocate_chunk>
  8013a9:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013ac:	a1 20 51 80 00       	mov    0x805120,%eax
  8013b1:	83 ec 0c             	sub    $0xc,%esp
  8013b4:	50                   	push   %eax
  8013b5:	e8 71 0b 00 00       	call   801f2b <initialize_MemBlocksList>
  8013ba:	83 c4 10             	add    $0x10,%esp
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	struct MemBlock * NewBlock = LIST_FIRST(&AvailableMemBlocksList);
  8013bd:	a1 48 51 80 00       	mov    0x805148,%eax
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
  8013e2:	68 d5 3d 80 00       	push   $0x803dd5
  8013e7:	6a 33                	push   $0x33
  8013e9:	68 f3 3d 80 00       	push   $0x803df3
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
  801412:	a3 4c 51 80 00       	mov    %eax,0x80514c
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
  801435:	a3 48 51 80 00       	mov    %eax,0x805148
  80143a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80143d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801443:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801446:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80144d:	a1 54 51 80 00       	mov    0x805154,%eax
  801452:	48                   	dec    %eax
  801453:	a3 54 51 80 00       	mov    %eax,0x805154
	LIST_INSERT_HEAD(&FreeMemBlocksList, NewBlock);
  801458:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80145c:	75 14                	jne    801472 <initialize_dyn_block_system+0x184>
  80145e:	83 ec 04             	sub    $0x4,%esp
  801461:	68 00 3e 80 00       	push   $0x803e00
  801466:	6a 34                	push   $0x34
  801468:	68 f3 3d 80 00       	push   $0x803df3
  80146d:	e8 0d ee ff ff       	call   80027f <_panic>
  801472:	8b 15 38 51 80 00    	mov    0x805138,%edx
  801478:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80147b:	89 10                	mov    %edx,(%eax)
  80147d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801480:	8b 00                	mov    (%eax),%eax
  801482:	85 c0                	test   %eax,%eax
  801484:	74 0d                	je     801493 <initialize_dyn_block_system+0x1a5>
  801486:	a1 38 51 80 00       	mov    0x805138,%eax
  80148b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80148e:	89 50 04             	mov    %edx,0x4(%eax)
  801491:	eb 08                	jmp    80149b <initialize_dyn_block_system+0x1ad>
  801493:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801496:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80149b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80149e:	a3 38 51 80 00       	mov    %eax,0x805138
  8014a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014a6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8014ad:	a1 44 51 80 00       	mov    0x805144,%eax
  8014b2:	40                   	inc    %eax
  8014b3:	a3 44 51 80 00       	mov    %eax,0x805144
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
  8014f9:	e8 75 07 00 00       	call   801c73 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014fe:	85 c0                	test   %eax,%eax
  801500:	74 11                	je     801513 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801502:	83 ec 0c             	sub    $0xc,%esp
  801505:	ff 75 e8             	pushl  -0x18(%ebp)
  801508:	e8 e0 0d 00 00       	call   8022ed <alloc_block_FF>
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
  80151f:	e8 3c 0b 00 00       	call   802060 <insert_sorted_allocList>
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
  80153f:	68 24 3e 80 00       	push   $0x803e24
  801544:	6a 6f                	push   $0x6f
  801546:	68 f3 3d 80 00       	push   $0x803df3
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
  801565:	75 0a                	jne    801571 <smalloc+0x21>
  801567:	b8 00 00 00 00       	mov    $0x0,%eax
  80156c:	e9 8b 00 00 00       	jmp    8015fc <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801571:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801578:	8b 55 0c             	mov    0xc(%ebp),%edx
  80157b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80157e:	01 d0                	add    %edx,%eax
  801580:	48                   	dec    %eax
  801581:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801584:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801587:	ba 00 00 00 00       	mov    $0x0,%edx
  80158c:	f7 75 f0             	divl   -0x10(%ebp)
  80158f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801592:	29 d0                	sub    %edx,%eax
  801594:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801597:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  80159e:	e8 d0 06 00 00       	call   801c73 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8015a3:	85 c0                	test   %eax,%eax
  8015a5:	74 11                	je     8015b8 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  8015a7:	83 ec 0c             	sub    $0xc,%esp
  8015aa:	ff 75 e8             	pushl  -0x18(%ebp)
  8015ad:	e8 3b 0d 00 00       	call   8022ed <alloc_block_FF>
  8015b2:	83 c4 10             	add    $0x10,%esp
  8015b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  8015b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8015bc:	74 39                	je     8015f7 <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8015be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015c1:	8b 40 08             	mov    0x8(%eax),%eax
  8015c4:	89 c2                	mov    %eax,%edx
  8015c6:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8015ca:	52                   	push   %edx
  8015cb:	50                   	push   %eax
  8015cc:	ff 75 0c             	pushl  0xc(%ebp)
  8015cf:	ff 75 08             	pushl  0x8(%ebp)
  8015d2:	e8 21 04 00 00       	call   8019f8 <sys_createSharedObject>
  8015d7:	83 c4 10             	add    $0x10,%esp
  8015da:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  8015dd:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  8015e1:	74 14                	je     8015f7 <smalloc+0xa7>
  8015e3:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  8015e7:	74 0e                	je     8015f7 <smalloc+0xa7>
  8015e9:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  8015ed:	74 08                	je     8015f7 <smalloc+0xa7>
			return (void*) mem_block->sva;
  8015ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015f2:	8b 40 08             	mov    0x8(%eax),%eax
  8015f5:	eb 05                	jmp    8015fc <smalloc+0xac>
	}
	return NULL;
  8015f7:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8015fc:	c9                   	leave  
  8015fd:	c3                   	ret    

008015fe <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8015fe:	55                   	push   %ebp
  8015ff:	89 e5                	mov    %esp,%ebp
  801601:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801604:	e8 b4 fc ff ff       	call   8012bd <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801609:	83 ec 08             	sub    $0x8,%esp
  80160c:	ff 75 0c             	pushl  0xc(%ebp)
  80160f:	ff 75 08             	pushl  0x8(%ebp)
  801612:	e8 0b 04 00 00       	call   801a22 <sys_getSizeOfSharedObject>
  801617:	83 c4 10             	add    $0x10,%esp
  80161a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  80161d:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  801621:	74 76                	je     801699 <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801623:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80162a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80162d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801630:	01 d0                	add    %edx,%eax
  801632:	48                   	dec    %eax
  801633:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801636:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801639:	ba 00 00 00 00       	mov    $0x0,%edx
  80163e:	f7 75 ec             	divl   -0x14(%ebp)
  801641:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801644:	29 d0                	sub    %edx,%eax
  801646:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  801649:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801650:	e8 1e 06 00 00       	call   801c73 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801655:	85 c0                	test   %eax,%eax
  801657:	74 11                	je     80166a <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  801659:	83 ec 0c             	sub    $0xc,%esp
  80165c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80165f:	e8 89 0c 00 00       	call   8022ed <alloc_block_FF>
  801664:	83 c4 10             	add    $0x10,%esp
  801667:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  80166a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80166e:	74 29                	je     801699 <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  801670:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801673:	8b 40 08             	mov    0x8(%eax),%eax
  801676:	83 ec 04             	sub    $0x4,%esp
  801679:	50                   	push   %eax
  80167a:	ff 75 0c             	pushl  0xc(%ebp)
  80167d:	ff 75 08             	pushl  0x8(%ebp)
  801680:	e8 ba 03 00 00       	call   801a3f <sys_getSharedObject>
  801685:	83 c4 10             	add    $0x10,%esp
  801688:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  80168b:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  80168f:	74 08                	je     801699 <sget+0x9b>
				return (void *)mem_block->sva;
  801691:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801694:	8b 40 08             	mov    0x8(%eax),%eax
  801697:	eb 05                	jmp    80169e <sget+0xa0>
		}
	}
	return (void *)NULL;
  801699:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80169e:	c9                   	leave  
  80169f:	c3                   	ret    

008016a0 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8016a0:	55                   	push   %ebp
  8016a1:	89 e5                	mov    %esp,%ebp
  8016a3:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016a6:	e8 12 fc ff ff       	call   8012bd <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8016ab:	83 ec 04             	sub    $0x4,%esp
  8016ae:	68 48 3e 80 00       	push   $0x803e48
  8016b3:	68 f1 00 00 00       	push   $0xf1
  8016b8:	68 f3 3d 80 00       	push   $0x803df3
  8016bd:	e8 bd eb ff ff       	call   80027f <_panic>

008016c2 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8016c2:	55                   	push   %ebp
  8016c3:	89 e5                	mov    %esp,%ebp
  8016c5:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8016c8:	83 ec 04             	sub    $0x4,%esp
  8016cb:	68 70 3e 80 00       	push   $0x803e70
  8016d0:	68 05 01 00 00       	push   $0x105
  8016d5:	68 f3 3d 80 00       	push   $0x803df3
  8016da:	e8 a0 eb ff ff       	call   80027f <_panic>

008016df <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8016df:	55                   	push   %ebp
  8016e0:	89 e5                	mov    %esp,%ebp
  8016e2:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016e5:	83 ec 04             	sub    $0x4,%esp
  8016e8:	68 94 3e 80 00       	push   $0x803e94
  8016ed:	68 10 01 00 00       	push   $0x110
  8016f2:	68 f3 3d 80 00       	push   $0x803df3
  8016f7:	e8 83 eb ff ff       	call   80027f <_panic>

008016fc <shrink>:

}
void shrink(uint32 newSize)
{
  8016fc:	55                   	push   %ebp
  8016fd:	89 e5                	mov    %esp,%ebp
  8016ff:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801702:	83 ec 04             	sub    $0x4,%esp
  801705:	68 94 3e 80 00       	push   $0x803e94
  80170a:	68 15 01 00 00       	push   $0x115
  80170f:	68 f3 3d 80 00       	push   $0x803df3
  801714:	e8 66 eb ff ff       	call   80027f <_panic>

00801719 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801719:	55                   	push   %ebp
  80171a:	89 e5                	mov    %esp,%ebp
  80171c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80171f:	83 ec 04             	sub    $0x4,%esp
  801722:	68 94 3e 80 00       	push   $0x803e94
  801727:	68 1a 01 00 00       	push   $0x11a
  80172c:	68 f3 3d 80 00       	push   $0x803df3
  801731:	e8 49 eb ff ff       	call   80027f <_panic>

00801736 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801736:	55                   	push   %ebp
  801737:	89 e5                	mov    %esp,%ebp
  801739:	57                   	push   %edi
  80173a:	56                   	push   %esi
  80173b:	53                   	push   %ebx
  80173c:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80173f:	8b 45 08             	mov    0x8(%ebp),%eax
  801742:	8b 55 0c             	mov    0xc(%ebp),%edx
  801745:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801748:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80174b:	8b 7d 18             	mov    0x18(%ebp),%edi
  80174e:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801751:	cd 30                	int    $0x30
  801753:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801756:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801759:	83 c4 10             	add    $0x10,%esp
  80175c:	5b                   	pop    %ebx
  80175d:	5e                   	pop    %esi
  80175e:	5f                   	pop    %edi
  80175f:	5d                   	pop    %ebp
  801760:	c3                   	ret    

00801761 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801761:	55                   	push   %ebp
  801762:	89 e5                	mov    %esp,%ebp
  801764:	83 ec 04             	sub    $0x4,%esp
  801767:	8b 45 10             	mov    0x10(%ebp),%eax
  80176a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80176d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801771:	8b 45 08             	mov    0x8(%ebp),%eax
  801774:	6a 00                	push   $0x0
  801776:	6a 00                	push   $0x0
  801778:	52                   	push   %edx
  801779:	ff 75 0c             	pushl  0xc(%ebp)
  80177c:	50                   	push   %eax
  80177d:	6a 00                	push   $0x0
  80177f:	e8 b2 ff ff ff       	call   801736 <syscall>
  801784:	83 c4 18             	add    $0x18,%esp
}
  801787:	90                   	nop
  801788:	c9                   	leave  
  801789:	c3                   	ret    

0080178a <sys_cgetc>:

int
sys_cgetc(void)
{
  80178a:	55                   	push   %ebp
  80178b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80178d:	6a 00                	push   $0x0
  80178f:	6a 00                	push   $0x0
  801791:	6a 00                	push   $0x0
  801793:	6a 00                	push   $0x0
  801795:	6a 00                	push   $0x0
  801797:	6a 01                	push   $0x1
  801799:	e8 98 ff ff ff       	call   801736 <syscall>
  80179e:	83 c4 18             	add    $0x18,%esp
}
  8017a1:	c9                   	leave  
  8017a2:	c3                   	ret    

008017a3 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8017a3:	55                   	push   %ebp
  8017a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8017a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ac:	6a 00                	push   $0x0
  8017ae:	6a 00                	push   $0x0
  8017b0:	6a 00                	push   $0x0
  8017b2:	52                   	push   %edx
  8017b3:	50                   	push   %eax
  8017b4:	6a 05                	push   $0x5
  8017b6:	e8 7b ff ff ff       	call   801736 <syscall>
  8017bb:	83 c4 18             	add    $0x18,%esp
}
  8017be:	c9                   	leave  
  8017bf:	c3                   	ret    

008017c0 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8017c0:	55                   	push   %ebp
  8017c1:	89 e5                	mov    %esp,%ebp
  8017c3:	56                   	push   %esi
  8017c4:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8017c5:	8b 75 18             	mov    0x18(%ebp),%esi
  8017c8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017cb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d4:	56                   	push   %esi
  8017d5:	53                   	push   %ebx
  8017d6:	51                   	push   %ecx
  8017d7:	52                   	push   %edx
  8017d8:	50                   	push   %eax
  8017d9:	6a 06                	push   $0x6
  8017db:	e8 56 ff ff ff       	call   801736 <syscall>
  8017e0:	83 c4 18             	add    $0x18,%esp
}
  8017e3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017e6:	5b                   	pop    %ebx
  8017e7:	5e                   	pop    %esi
  8017e8:	5d                   	pop    %ebp
  8017e9:	c3                   	ret    

008017ea <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8017ea:	55                   	push   %ebp
  8017eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8017ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f3:	6a 00                	push   $0x0
  8017f5:	6a 00                	push   $0x0
  8017f7:	6a 00                	push   $0x0
  8017f9:	52                   	push   %edx
  8017fa:	50                   	push   %eax
  8017fb:	6a 07                	push   $0x7
  8017fd:	e8 34 ff ff ff       	call   801736 <syscall>
  801802:	83 c4 18             	add    $0x18,%esp
}
  801805:	c9                   	leave  
  801806:	c3                   	ret    

00801807 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801807:	55                   	push   %ebp
  801808:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80180a:	6a 00                	push   $0x0
  80180c:	6a 00                	push   $0x0
  80180e:	6a 00                	push   $0x0
  801810:	ff 75 0c             	pushl  0xc(%ebp)
  801813:	ff 75 08             	pushl  0x8(%ebp)
  801816:	6a 08                	push   $0x8
  801818:	e8 19 ff ff ff       	call   801736 <syscall>
  80181d:	83 c4 18             	add    $0x18,%esp
}
  801820:	c9                   	leave  
  801821:	c3                   	ret    

00801822 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801822:	55                   	push   %ebp
  801823:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801825:	6a 00                	push   $0x0
  801827:	6a 00                	push   $0x0
  801829:	6a 00                	push   $0x0
  80182b:	6a 00                	push   $0x0
  80182d:	6a 00                	push   $0x0
  80182f:	6a 09                	push   $0x9
  801831:	e8 00 ff ff ff       	call   801736 <syscall>
  801836:	83 c4 18             	add    $0x18,%esp
}
  801839:	c9                   	leave  
  80183a:	c3                   	ret    

0080183b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80183b:	55                   	push   %ebp
  80183c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80183e:	6a 00                	push   $0x0
  801840:	6a 00                	push   $0x0
  801842:	6a 00                	push   $0x0
  801844:	6a 00                	push   $0x0
  801846:	6a 00                	push   $0x0
  801848:	6a 0a                	push   $0xa
  80184a:	e8 e7 fe ff ff       	call   801736 <syscall>
  80184f:	83 c4 18             	add    $0x18,%esp
}
  801852:	c9                   	leave  
  801853:	c3                   	ret    

00801854 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801854:	55                   	push   %ebp
  801855:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801857:	6a 00                	push   $0x0
  801859:	6a 00                	push   $0x0
  80185b:	6a 00                	push   $0x0
  80185d:	6a 00                	push   $0x0
  80185f:	6a 00                	push   $0x0
  801861:	6a 0b                	push   $0xb
  801863:	e8 ce fe ff ff       	call   801736 <syscall>
  801868:	83 c4 18             	add    $0x18,%esp
}
  80186b:	c9                   	leave  
  80186c:	c3                   	ret    

0080186d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80186d:	55                   	push   %ebp
  80186e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801870:	6a 00                	push   $0x0
  801872:	6a 00                	push   $0x0
  801874:	6a 00                	push   $0x0
  801876:	ff 75 0c             	pushl  0xc(%ebp)
  801879:	ff 75 08             	pushl  0x8(%ebp)
  80187c:	6a 0f                	push   $0xf
  80187e:	e8 b3 fe ff ff       	call   801736 <syscall>
  801883:	83 c4 18             	add    $0x18,%esp
	return;
  801886:	90                   	nop
}
  801887:	c9                   	leave  
  801888:	c3                   	ret    

00801889 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801889:	55                   	push   %ebp
  80188a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80188c:	6a 00                	push   $0x0
  80188e:	6a 00                	push   $0x0
  801890:	6a 00                	push   $0x0
  801892:	ff 75 0c             	pushl  0xc(%ebp)
  801895:	ff 75 08             	pushl  0x8(%ebp)
  801898:	6a 10                	push   $0x10
  80189a:	e8 97 fe ff ff       	call   801736 <syscall>
  80189f:	83 c4 18             	add    $0x18,%esp
	return ;
  8018a2:	90                   	nop
}
  8018a3:	c9                   	leave  
  8018a4:	c3                   	ret    

008018a5 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8018a5:	55                   	push   %ebp
  8018a6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8018a8:	6a 00                	push   $0x0
  8018aa:	6a 00                	push   $0x0
  8018ac:	ff 75 10             	pushl  0x10(%ebp)
  8018af:	ff 75 0c             	pushl  0xc(%ebp)
  8018b2:	ff 75 08             	pushl  0x8(%ebp)
  8018b5:	6a 11                	push   $0x11
  8018b7:	e8 7a fe ff ff       	call   801736 <syscall>
  8018bc:	83 c4 18             	add    $0x18,%esp
	return ;
  8018bf:	90                   	nop
}
  8018c0:	c9                   	leave  
  8018c1:	c3                   	ret    

008018c2 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8018c2:	55                   	push   %ebp
  8018c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8018c5:	6a 00                	push   $0x0
  8018c7:	6a 00                	push   $0x0
  8018c9:	6a 00                	push   $0x0
  8018cb:	6a 00                	push   $0x0
  8018cd:	6a 00                	push   $0x0
  8018cf:	6a 0c                	push   $0xc
  8018d1:	e8 60 fe ff ff       	call   801736 <syscall>
  8018d6:	83 c4 18             	add    $0x18,%esp
}
  8018d9:	c9                   	leave  
  8018da:	c3                   	ret    

008018db <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8018db:	55                   	push   %ebp
  8018dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 00                	push   $0x0
  8018e6:	ff 75 08             	pushl  0x8(%ebp)
  8018e9:	6a 0d                	push   $0xd
  8018eb:	e8 46 fe ff ff       	call   801736 <syscall>
  8018f0:	83 c4 18             	add    $0x18,%esp
}
  8018f3:	c9                   	leave  
  8018f4:	c3                   	ret    

008018f5 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8018f5:	55                   	push   %ebp
  8018f6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8018f8:	6a 00                	push   $0x0
  8018fa:	6a 00                	push   $0x0
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 00                	push   $0x0
  801900:	6a 00                	push   $0x0
  801902:	6a 0e                	push   $0xe
  801904:	e8 2d fe ff ff       	call   801736 <syscall>
  801909:	83 c4 18             	add    $0x18,%esp
}
  80190c:	90                   	nop
  80190d:	c9                   	leave  
  80190e:	c3                   	ret    

0080190f <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80190f:	55                   	push   %ebp
  801910:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801912:	6a 00                	push   $0x0
  801914:	6a 00                	push   $0x0
  801916:	6a 00                	push   $0x0
  801918:	6a 00                	push   $0x0
  80191a:	6a 00                	push   $0x0
  80191c:	6a 13                	push   $0x13
  80191e:	e8 13 fe ff ff       	call   801736 <syscall>
  801923:	83 c4 18             	add    $0x18,%esp
}
  801926:	90                   	nop
  801927:	c9                   	leave  
  801928:	c3                   	ret    

00801929 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801929:	55                   	push   %ebp
  80192a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80192c:	6a 00                	push   $0x0
  80192e:	6a 00                	push   $0x0
  801930:	6a 00                	push   $0x0
  801932:	6a 00                	push   $0x0
  801934:	6a 00                	push   $0x0
  801936:	6a 14                	push   $0x14
  801938:	e8 f9 fd ff ff       	call   801736 <syscall>
  80193d:	83 c4 18             	add    $0x18,%esp
}
  801940:	90                   	nop
  801941:	c9                   	leave  
  801942:	c3                   	ret    

00801943 <sys_cputc>:


void
sys_cputc(const char c)
{
  801943:	55                   	push   %ebp
  801944:	89 e5                	mov    %esp,%ebp
  801946:	83 ec 04             	sub    $0x4,%esp
  801949:	8b 45 08             	mov    0x8(%ebp),%eax
  80194c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80194f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801953:	6a 00                	push   $0x0
  801955:	6a 00                	push   $0x0
  801957:	6a 00                	push   $0x0
  801959:	6a 00                	push   $0x0
  80195b:	50                   	push   %eax
  80195c:	6a 15                	push   $0x15
  80195e:	e8 d3 fd ff ff       	call   801736 <syscall>
  801963:	83 c4 18             	add    $0x18,%esp
}
  801966:	90                   	nop
  801967:	c9                   	leave  
  801968:	c3                   	ret    

00801969 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801969:	55                   	push   %ebp
  80196a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80196c:	6a 00                	push   $0x0
  80196e:	6a 00                	push   $0x0
  801970:	6a 00                	push   $0x0
  801972:	6a 00                	push   $0x0
  801974:	6a 00                	push   $0x0
  801976:	6a 16                	push   $0x16
  801978:	e8 b9 fd ff ff       	call   801736 <syscall>
  80197d:	83 c4 18             	add    $0x18,%esp
}
  801980:	90                   	nop
  801981:	c9                   	leave  
  801982:	c3                   	ret    

00801983 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801983:	55                   	push   %ebp
  801984:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801986:	8b 45 08             	mov    0x8(%ebp),%eax
  801989:	6a 00                	push   $0x0
  80198b:	6a 00                	push   $0x0
  80198d:	6a 00                	push   $0x0
  80198f:	ff 75 0c             	pushl  0xc(%ebp)
  801992:	50                   	push   %eax
  801993:	6a 17                	push   $0x17
  801995:	e8 9c fd ff ff       	call   801736 <syscall>
  80199a:	83 c4 18             	add    $0x18,%esp
}
  80199d:	c9                   	leave  
  80199e:	c3                   	ret    

0080199f <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80199f:	55                   	push   %ebp
  8019a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a8:	6a 00                	push   $0x0
  8019aa:	6a 00                	push   $0x0
  8019ac:	6a 00                	push   $0x0
  8019ae:	52                   	push   %edx
  8019af:	50                   	push   %eax
  8019b0:	6a 1a                	push   $0x1a
  8019b2:	e8 7f fd ff ff       	call   801736 <syscall>
  8019b7:	83 c4 18             	add    $0x18,%esp
}
  8019ba:	c9                   	leave  
  8019bb:	c3                   	ret    

008019bc <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8019bc:	55                   	push   %ebp
  8019bd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c5:	6a 00                	push   $0x0
  8019c7:	6a 00                	push   $0x0
  8019c9:	6a 00                	push   $0x0
  8019cb:	52                   	push   %edx
  8019cc:	50                   	push   %eax
  8019cd:	6a 18                	push   $0x18
  8019cf:	e8 62 fd ff ff       	call   801736 <syscall>
  8019d4:	83 c4 18             	add    $0x18,%esp
}
  8019d7:	90                   	nop
  8019d8:	c9                   	leave  
  8019d9:	c3                   	ret    

008019da <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8019da:	55                   	push   %ebp
  8019db:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 00                	push   $0x0
  8019e9:	52                   	push   %edx
  8019ea:	50                   	push   %eax
  8019eb:	6a 19                	push   $0x19
  8019ed:	e8 44 fd ff ff       	call   801736 <syscall>
  8019f2:	83 c4 18             	add    $0x18,%esp
}
  8019f5:	90                   	nop
  8019f6:	c9                   	leave  
  8019f7:	c3                   	ret    

008019f8 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8019f8:	55                   	push   %ebp
  8019f9:	89 e5                	mov    %esp,%ebp
  8019fb:	83 ec 04             	sub    $0x4,%esp
  8019fe:	8b 45 10             	mov    0x10(%ebp),%eax
  801a01:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a04:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a07:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0e:	6a 00                	push   $0x0
  801a10:	51                   	push   %ecx
  801a11:	52                   	push   %edx
  801a12:	ff 75 0c             	pushl  0xc(%ebp)
  801a15:	50                   	push   %eax
  801a16:	6a 1b                	push   $0x1b
  801a18:	e8 19 fd ff ff       	call   801736 <syscall>
  801a1d:	83 c4 18             	add    $0x18,%esp
}
  801a20:	c9                   	leave  
  801a21:	c3                   	ret    

00801a22 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801a22:	55                   	push   %ebp
  801a23:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a25:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a28:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 00                	push   $0x0
  801a2f:	6a 00                	push   $0x0
  801a31:	52                   	push   %edx
  801a32:	50                   	push   %eax
  801a33:	6a 1c                	push   $0x1c
  801a35:	e8 fc fc ff ff       	call   801736 <syscall>
  801a3a:	83 c4 18             	add    $0x18,%esp
}
  801a3d:	c9                   	leave  
  801a3e:	c3                   	ret    

00801a3f <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801a3f:	55                   	push   %ebp
  801a40:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a42:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a45:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a48:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4b:	6a 00                	push   $0x0
  801a4d:	6a 00                	push   $0x0
  801a4f:	51                   	push   %ecx
  801a50:	52                   	push   %edx
  801a51:	50                   	push   %eax
  801a52:	6a 1d                	push   $0x1d
  801a54:	e8 dd fc ff ff       	call   801736 <syscall>
  801a59:	83 c4 18             	add    $0x18,%esp
}
  801a5c:	c9                   	leave  
  801a5d:	c3                   	ret    

00801a5e <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801a5e:	55                   	push   %ebp
  801a5f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a61:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a64:	8b 45 08             	mov    0x8(%ebp),%eax
  801a67:	6a 00                	push   $0x0
  801a69:	6a 00                	push   $0x0
  801a6b:	6a 00                	push   $0x0
  801a6d:	52                   	push   %edx
  801a6e:	50                   	push   %eax
  801a6f:	6a 1e                	push   $0x1e
  801a71:	e8 c0 fc ff ff       	call   801736 <syscall>
  801a76:	83 c4 18             	add    $0x18,%esp
}
  801a79:	c9                   	leave  
  801a7a:	c3                   	ret    

00801a7b <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801a7b:	55                   	push   %ebp
  801a7c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	6a 00                	push   $0x0
  801a84:	6a 00                	push   $0x0
  801a86:	6a 00                	push   $0x0
  801a88:	6a 1f                	push   $0x1f
  801a8a:	e8 a7 fc ff ff       	call   801736 <syscall>
  801a8f:	83 c4 18             	add    $0x18,%esp
}
  801a92:	c9                   	leave  
  801a93:	c3                   	ret    

00801a94 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a94:	55                   	push   %ebp
  801a95:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a97:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9a:	6a 00                	push   $0x0
  801a9c:	ff 75 14             	pushl  0x14(%ebp)
  801a9f:	ff 75 10             	pushl  0x10(%ebp)
  801aa2:	ff 75 0c             	pushl  0xc(%ebp)
  801aa5:	50                   	push   %eax
  801aa6:	6a 20                	push   $0x20
  801aa8:	e8 89 fc ff ff       	call   801736 <syscall>
  801aad:	83 c4 18             	add    $0x18,%esp
}
  801ab0:	c9                   	leave  
  801ab1:	c3                   	ret    

00801ab2 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801ab2:	55                   	push   %ebp
  801ab3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801ab5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	6a 00                	push   $0x0
  801abe:	6a 00                	push   $0x0
  801ac0:	50                   	push   %eax
  801ac1:	6a 21                	push   $0x21
  801ac3:	e8 6e fc ff ff       	call   801736 <syscall>
  801ac8:	83 c4 18             	add    $0x18,%esp
}
  801acb:	90                   	nop
  801acc:	c9                   	leave  
  801acd:	c3                   	ret    

00801ace <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801ace:	55                   	push   %ebp
  801acf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad4:	6a 00                	push   $0x0
  801ad6:	6a 00                	push   $0x0
  801ad8:	6a 00                	push   $0x0
  801ada:	6a 00                	push   $0x0
  801adc:	50                   	push   %eax
  801add:	6a 22                	push   $0x22
  801adf:	e8 52 fc ff ff       	call   801736 <syscall>
  801ae4:	83 c4 18             	add    $0x18,%esp
}
  801ae7:	c9                   	leave  
  801ae8:	c3                   	ret    

00801ae9 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ae9:	55                   	push   %ebp
  801aea:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801aec:	6a 00                	push   $0x0
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	6a 02                	push   $0x2
  801af8:	e8 39 fc ff ff       	call   801736 <syscall>
  801afd:	83 c4 18             	add    $0x18,%esp
}
  801b00:	c9                   	leave  
  801b01:	c3                   	ret    

00801b02 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b02:	55                   	push   %ebp
  801b03:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b05:	6a 00                	push   $0x0
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 03                	push   $0x3
  801b11:	e8 20 fc ff ff       	call   801736 <syscall>
  801b16:	83 c4 18             	add    $0x18,%esp
}
  801b19:	c9                   	leave  
  801b1a:	c3                   	ret    

00801b1b <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b1b:	55                   	push   %ebp
  801b1c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	6a 00                	push   $0x0
  801b26:	6a 00                	push   $0x0
  801b28:	6a 04                	push   $0x4
  801b2a:	e8 07 fc ff ff       	call   801736 <syscall>
  801b2f:	83 c4 18             	add    $0x18,%esp
}
  801b32:	c9                   	leave  
  801b33:	c3                   	ret    

00801b34 <sys_exit_env>:


void sys_exit_env(void)
{
  801b34:	55                   	push   %ebp
  801b35:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b37:	6a 00                	push   $0x0
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 00                	push   $0x0
  801b3f:	6a 00                	push   $0x0
  801b41:	6a 23                	push   $0x23
  801b43:	e8 ee fb ff ff       	call   801736 <syscall>
  801b48:	83 c4 18             	add    $0x18,%esp
}
  801b4b:	90                   	nop
  801b4c:	c9                   	leave  
  801b4d:	c3                   	ret    

00801b4e <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801b4e:	55                   	push   %ebp
  801b4f:	89 e5                	mov    %esp,%ebp
  801b51:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b54:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b57:	8d 50 04             	lea    0x4(%eax),%edx
  801b5a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b5d:	6a 00                	push   $0x0
  801b5f:	6a 00                	push   $0x0
  801b61:	6a 00                	push   $0x0
  801b63:	52                   	push   %edx
  801b64:	50                   	push   %eax
  801b65:	6a 24                	push   $0x24
  801b67:	e8 ca fb ff ff       	call   801736 <syscall>
  801b6c:	83 c4 18             	add    $0x18,%esp
	return result;
  801b6f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b72:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b75:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b78:	89 01                	mov    %eax,(%ecx)
  801b7a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b80:	c9                   	leave  
  801b81:	c2 04 00             	ret    $0x4

00801b84 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b84:	55                   	push   %ebp
  801b85:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b87:	6a 00                	push   $0x0
  801b89:	6a 00                	push   $0x0
  801b8b:	ff 75 10             	pushl  0x10(%ebp)
  801b8e:	ff 75 0c             	pushl  0xc(%ebp)
  801b91:	ff 75 08             	pushl  0x8(%ebp)
  801b94:	6a 12                	push   $0x12
  801b96:	e8 9b fb ff ff       	call   801736 <syscall>
  801b9b:	83 c4 18             	add    $0x18,%esp
	return ;
  801b9e:	90                   	nop
}
  801b9f:	c9                   	leave  
  801ba0:	c3                   	ret    

00801ba1 <sys_rcr2>:
uint32 sys_rcr2()
{
  801ba1:	55                   	push   %ebp
  801ba2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ba4:	6a 00                	push   $0x0
  801ba6:	6a 00                	push   $0x0
  801ba8:	6a 00                	push   $0x0
  801baa:	6a 00                	push   $0x0
  801bac:	6a 00                	push   $0x0
  801bae:	6a 25                	push   $0x25
  801bb0:	e8 81 fb ff ff       	call   801736 <syscall>
  801bb5:	83 c4 18             	add    $0x18,%esp
}
  801bb8:	c9                   	leave  
  801bb9:	c3                   	ret    

00801bba <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801bba:	55                   	push   %ebp
  801bbb:	89 e5                	mov    %esp,%ebp
  801bbd:	83 ec 04             	sub    $0x4,%esp
  801bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801bc6:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 00                	push   $0x0
  801bd2:	50                   	push   %eax
  801bd3:	6a 26                	push   $0x26
  801bd5:	e8 5c fb ff ff       	call   801736 <syscall>
  801bda:	83 c4 18             	add    $0x18,%esp
	return ;
  801bdd:	90                   	nop
}
  801bde:	c9                   	leave  
  801bdf:	c3                   	ret    

00801be0 <rsttst>:
void rsttst()
{
  801be0:	55                   	push   %ebp
  801be1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801be3:	6a 00                	push   $0x0
  801be5:	6a 00                	push   $0x0
  801be7:	6a 00                	push   $0x0
  801be9:	6a 00                	push   $0x0
  801beb:	6a 00                	push   $0x0
  801bed:	6a 28                	push   $0x28
  801bef:	e8 42 fb ff ff       	call   801736 <syscall>
  801bf4:	83 c4 18             	add    $0x18,%esp
	return ;
  801bf7:	90                   	nop
}
  801bf8:	c9                   	leave  
  801bf9:	c3                   	ret    

00801bfa <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801bfa:	55                   	push   %ebp
  801bfb:	89 e5                	mov    %esp,%ebp
  801bfd:	83 ec 04             	sub    $0x4,%esp
  801c00:	8b 45 14             	mov    0x14(%ebp),%eax
  801c03:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c06:	8b 55 18             	mov    0x18(%ebp),%edx
  801c09:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c0d:	52                   	push   %edx
  801c0e:	50                   	push   %eax
  801c0f:	ff 75 10             	pushl  0x10(%ebp)
  801c12:	ff 75 0c             	pushl  0xc(%ebp)
  801c15:	ff 75 08             	pushl  0x8(%ebp)
  801c18:	6a 27                	push   $0x27
  801c1a:	e8 17 fb ff ff       	call   801736 <syscall>
  801c1f:	83 c4 18             	add    $0x18,%esp
	return ;
  801c22:	90                   	nop
}
  801c23:	c9                   	leave  
  801c24:	c3                   	ret    

00801c25 <chktst>:
void chktst(uint32 n)
{
  801c25:	55                   	push   %ebp
  801c26:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c28:	6a 00                	push   $0x0
  801c2a:	6a 00                	push   $0x0
  801c2c:	6a 00                	push   $0x0
  801c2e:	6a 00                	push   $0x0
  801c30:	ff 75 08             	pushl  0x8(%ebp)
  801c33:	6a 29                	push   $0x29
  801c35:	e8 fc fa ff ff       	call   801736 <syscall>
  801c3a:	83 c4 18             	add    $0x18,%esp
	return ;
  801c3d:	90                   	nop
}
  801c3e:	c9                   	leave  
  801c3f:	c3                   	ret    

00801c40 <inctst>:

void inctst()
{
  801c40:	55                   	push   %ebp
  801c41:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c43:	6a 00                	push   $0x0
  801c45:	6a 00                	push   $0x0
  801c47:	6a 00                	push   $0x0
  801c49:	6a 00                	push   $0x0
  801c4b:	6a 00                	push   $0x0
  801c4d:	6a 2a                	push   $0x2a
  801c4f:	e8 e2 fa ff ff       	call   801736 <syscall>
  801c54:	83 c4 18             	add    $0x18,%esp
	return ;
  801c57:	90                   	nop
}
  801c58:	c9                   	leave  
  801c59:	c3                   	ret    

00801c5a <gettst>:
uint32 gettst()
{
  801c5a:	55                   	push   %ebp
  801c5b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c5d:	6a 00                	push   $0x0
  801c5f:	6a 00                	push   $0x0
  801c61:	6a 00                	push   $0x0
  801c63:	6a 00                	push   $0x0
  801c65:	6a 00                	push   $0x0
  801c67:	6a 2b                	push   $0x2b
  801c69:	e8 c8 fa ff ff       	call   801736 <syscall>
  801c6e:	83 c4 18             	add    $0x18,%esp
}
  801c71:	c9                   	leave  
  801c72:	c3                   	ret    

00801c73 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801c73:	55                   	push   %ebp
  801c74:	89 e5                	mov    %esp,%ebp
  801c76:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c79:	6a 00                	push   $0x0
  801c7b:	6a 00                	push   $0x0
  801c7d:	6a 00                	push   $0x0
  801c7f:	6a 00                	push   $0x0
  801c81:	6a 00                	push   $0x0
  801c83:	6a 2c                	push   $0x2c
  801c85:	e8 ac fa ff ff       	call   801736 <syscall>
  801c8a:	83 c4 18             	add    $0x18,%esp
  801c8d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801c90:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801c94:	75 07                	jne    801c9d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801c96:	b8 01 00 00 00       	mov    $0x1,%eax
  801c9b:	eb 05                	jmp    801ca2 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801c9d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ca2:	c9                   	leave  
  801ca3:	c3                   	ret    

00801ca4 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801ca4:	55                   	push   %ebp
  801ca5:	89 e5                	mov    %esp,%ebp
  801ca7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801caa:	6a 00                	push   $0x0
  801cac:	6a 00                	push   $0x0
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 00                	push   $0x0
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 2c                	push   $0x2c
  801cb6:	e8 7b fa ff ff       	call   801736 <syscall>
  801cbb:	83 c4 18             	add    $0x18,%esp
  801cbe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801cc1:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801cc5:	75 07                	jne    801cce <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801cc7:	b8 01 00 00 00       	mov    $0x1,%eax
  801ccc:	eb 05                	jmp    801cd3 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801cce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cd3:	c9                   	leave  
  801cd4:	c3                   	ret    

00801cd5 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801cd5:	55                   	push   %ebp
  801cd6:	89 e5                	mov    %esp,%ebp
  801cd8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cdb:	6a 00                	push   $0x0
  801cdd:	6a 00                	push   $0x0
  801cdf:	6a 00                	push   $0x0
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 00                	push   $0x0
  801ce5:	6a 2c                	push   $0x2c
  801ce7:	e8 4a fa ff ff       	call   801736 <syscall>
  801cec:	83 c4 18             	add    $0x18,%esp
  801cef:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801cf2:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801cf6:	75 07                	jne    801cff <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801cf8:	b8 01 00 00 00       	mov    $0x1,%eax
  801cfd:	eb 05                	jmp    801d04 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801cff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d04:	c9                   	leave  
  801d05:	c3                   	ret    

00801d06 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801d06:	55                   	push   %ebp
  801d07:	89 e5                	mov    %esp,%ebp
  801d09:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d0c:	6a 00                	push   $0x0
  801d0e:	6a 00                	push   $0x0
  801d10:	6a 00                	push   $0x0
  801d12:	6a 00                	push   $0x0
  801d14:	6a 00                	push   $0x0
  801d16:	6a 2c                	push   $0x2c
  801d18:	e8 19 fa ff ff       	call   801736 <syscall>
  801d1d:	83 c4 18             	add    $0x18,%esp
  801d20:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801d23:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801d27:	75 07                	jne    801d30 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801d29:	b8 01 00 00 00       	mov    $0x1,%eax
  801d2e:	eb 05                	jmp    801d35 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801d30:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d35:	c9                   	leave  
  801d36:	c3                   	ret    

00801d37 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801d37:	55                   	push   %ebp
  801d38:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801d3a:	6a 00                	push   $0x0
  801d3c:	6a 00                	push   $0x0
  801d3e:	6a 00                	push   $0x0
  801d40:	6a 00                	push   $0x0
  801d42:	ff 75 08             	pushl  0x8(%ebp)
  801d45:	6a 2d                	push   $0x2d
  801d47:	e8 ea f9 ff ff       	call   801736 <syscall>
  801d4c:	83 c4 18             	add    $0x18,%esp
	return ;
  801d4f:	90                   	nop
}
  801d50:	c9                   	leave  
  801d51:	c3                   	ret    

00801d52 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801d52:	55                   	push   %ebp
  801d53:	89 e5                	mov    %esp,%ebp
  801d55:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801d56:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d59:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d5c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d62:	6a 00                	push   $0x0
  801d64:	53                   	push   %ebx
  801d65:	51                   	push   %ecx
  801d66:	52                   	push   %edx
  801d67:	50                   	push   %eax
  801d68:	6a 2e                	push   $0x2e
  801d6a:	e8 c7 f9 ff ff       	call   801736 <syscall>
  801d6f:	83 c4 18             	add    $0x18,%esp
}
  801d72:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d75:	c9                   	leave  
  801d76:	c3                   	ret    

00801d77 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801d77:	55                   	push   %ebp
  801d78:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801d7a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d80:	6a 00                	push   $0x0
  801d82:	6a 00                	push   $0x0
  801d84:	6a 00                	push   $0x0
  801d86:	52                   	push   %edx
  801d87:	50                   	push   %eax
  801d88:	6a 2f                	push   $0x2f
  801d8a:	e8 a7 f9 ff ff       	call   801736 <syscall>
  801d8f:	83 c4 18             	add    $0x18,%esp
}
  801d92:	c9                   	leave  
  801d93:	c3                   	ret    

00801d94 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801d94:	55                   	push   %ebp
  801d95:	89 e5                	mov    %esp,%ebp
  801d97:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801d9a:	83 ec 0c             	sub    $0xc,%esp
  801d9d:	68 a4 3e 80 00       	push   $0x803ea4
  801da2:	e8 8c e7 ff ff       	call   800533 <cprintf>
  801da7:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801daa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801db1:	83 ec 0c             	sub    $0xc,%esp
  801db4:	68 d0 3e 80 00       	push   $0x803ed0
  801db9:	e8 75 e7 ff ff       	call   800533 <cprintf>
  801dbe:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801dc1:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801dc5:	a1 38 51 80 00       	mov    0x805138,%eax
  801dca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dcd:	eb 56                	jmp    801e25 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801dcf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801dd3:	74 1c                	je     801df1 <print_mem_block_lists+0x5d>
  801dd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd8:	8b 50 08             	mov    0x8(%eax),%edx
  801ddb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dde:	8b 48 08             	mov    0x8(%eax),%ecx
  801de1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801de4:	8b 40 0c             	mov    0xc(%eax),%eax
  801de7:	01 c8                	add    %ecx,%eax
  801de9:	39 c2                	cmp    %eax,%edx
  801deb:	73 04                	jae    801df1 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801ded:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801df1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df4:	8b 50 08             	mov    0x8(%eax),%edx
  801df7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dfa:	8b 40 0c             	mov    0xc(%eax),%eax
  801dfd:	01 c2                	add    %eax,%edx
  801dff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e02:	8b 40 08             	mov    0x8(%eax),%eax
  801e05:	83 ec 04             	sub    $0x4,%esp
  801e08:	52                   	push   %edx
  801e09:	50                   	push   %eax
  801e0a:	68 e5 3e 80 00       	push   $0x803ee5
  801e0f:	e8 1f e7 ff ff       	call   800533 <cprintf>
  801e14:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e1d:	a1 40 51 80 00       	mov    0x805140,%eax
  801e22:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e25:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e29:	74 07                	je     801e32 <print_mem_block_lists+0x9e>
  801e2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e2e:	8b 00                	mov    (%eax),%eax
  801e30:	eb 05                	jmp    801e37 <print_mem_block_lists+0xa3>
  801e32:	b8 00 00 00 00       	mov    $0x0,%eax
  801e37:	a3 40 51 80 00       	mov    %eax,0x805140
  801e3c:	a1 40 51 80 00       	mov    0x805140,%eax
  801e41:	85 c0                	test   %eax,%eax
  801e43:	75 8a                	jne    801dcf <print_mem_block_lists+0x3b>
  801e45:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e49:	75 84                	jne    801dcf <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801e4b:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e4f:	75 10                	jne    801e61 <print_mem_block_lists+0xcd>
  801e51:	83 ec 0c             	sub    $0xc,%esp
  801e54:	68 f4 3e 80 00       	push   $0x803ef4
  801e59:	e8 d5 e6 ff ff       	call   800533 <cprintf>
  801e5e:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801e61:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801e68:	83 ec 0c             	sub    $0xc,%esp
  801e6b:	68 18 3f 80 00       	push   $0x803f18
  801e70:	e8 be e6 ff ff       	call   800533 <cprintf>
  801e75:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801e78:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801e7c:	a1 40 50 80 00       	mov    0x805040,%eax
  801e81:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e84:	eb 56                	jmp    801edc <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e86:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e8a:	74 1c                	je     801ea8 <print_mem_block_lists+0x114>
  801e8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e8f:	8b 50 08             	mov    0x8(%eax),%edx
  801e92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e95:	8b 48 08             	mov    0x8(%eax),%ecx
  801e98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e9b:	8b 40 0c             	mov    0xc(%eax),%eax
  801e9e:	01 c8                	add    %ecx,%eax
  801ea0:	39 c2                	cmp    %eax,%edx
  801ea2:	73 04                	jae    801ea8 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801ea4:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801ea8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eab:	8b 50 08             	mov    0x8(%eax),%edx
  801eae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb1:	8b 40 0c             	mov    0xc(%eax),%eax
  801eb4:	01 c2                	add    %eax,%edx
  801eb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb9:	8b 40 08             	mov    0x8(%eax),%eax
  801ebc:	83 ec 04             	sub    $0x4,%esp
  801ebf:	52                   	push   %edx
  801ec0:	50                   	push   %eax
  801ec1:	68 e5 3e 80 00       	push   $0x803ee5
  801ec6:	e8 68 e6 ff ff       	call   800533 <cprintf>
  801ecb:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801ece:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801ed4:	a1 48 50 80 00       	mov    0x805048,%eax
  801ed9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801edc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ee0:	74 07                	je     801ee9 <print_mem_block_lists+0x155>
  801ee2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee5:	8b 00                	mov    (%eax),%eax
  801ee7:	eb 05                	jmp    801eee <print_mem_block_lists+0x15a>
  801ee9:	b8 00 00 00 00       	mov    $0x0,%eax
  801eee:	a3 48 50 80 00       	mov    %eax,0x805048
  801ef3:	a1 48 50 80 00       	mov    0x805048,%eax
  801ef8:	85 c0                	test   %eax,%eax
  801efa:	75 8a                	jne    801e86 <print_mem_block_lists+0xf2>
  801efc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f00:	75 84                	jne    801e86 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801f02:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f06:	75 10                	jne    801f18 <print_mem_block_lists+0x184>
  801f08:	83 ec 0c             	sub    $0xc,%esp
  801f0b:	68 30 3f 80 00       	push   $0x803f30
  801f10:	e8 1e e6 ff ff       	call   800533 <cprintf>
  801f15:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801f18:	83 ec 0c             	sub    $0xc,%esp
  801f1b:	68 a4 3e 80 00       	push   $0x803ea4
  801f20:	e8 0e e6 ff ff       	call   800533 <cprintf>
  801f25:	83 c4 10             	add    $0x10,%esp

}
  801f28:	90                   	nop
  801f29:	c9                   	leave  
  801f2a:	c3                   	ret    

00801f2b <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801f2b:	55                   	push   %ebp
  801f2c:	89 e5                	mov    %esp,%ebp
  801f2e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801f31:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  801f38:	00 00 00 
  801f3b:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  801f42:	00 00 00 
  801f45:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  801f4c:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801f4f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801f56:	e9 9e 00 00 00       	jmp    801ff9 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801f5b:	a1 50 50 80 00       	mov    0x805050,%eax
  801f60:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f63:	c1 e2 04             	shl    $0x4,%edx
  801f66:	01 d0                	add    %edx,%eax
  801f68:	85 c0                	test   %eax,%eax
  801f6a:	75 14                	jne    801f80 <initialize_MemBlocksList+0x55>
  801f6c:	83 ec 04             	sub    $0x4,%esp
  801f6f:	68 58 3f 80 00       	push   $0x803f58
  801f74:	6a 46                	push   $0x46
  801f76:	68 7b 3f 80 00       	push   $0x803f7b
  801f7b:	e8 ff e2 ff ff       	call   80027f <_panic>
  801f80:	a1 50 50 80 00       	mov    0x805050,%eax
  801f85:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f88:	c1 e2 04             	shl    $0x4,%edx
  801f8b:	01 d0                	add    %edx,%eax
  801f8d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  801f93:	89 10                	mov    %edx,(%eax)
  801f95:	8b 00                	mov    (%eax),%eax
  801f97:	85 c0                	test   %eax,%eax
  801f99:	74 18                	je     801fb3 <initialize_MemBlocksList+0x88>
  801f9b:	a1 48 51 80 00       	mov    0x805148,%eax
  801fa0:	8b 15 50 50 80 00    	mov    0x805050,%edx
  801fa6:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801fa9:	c1 e1 04             	shl    $0x4,%ecx
  801fac:	01 ca                	add    %ecx,%edx
  801fae:	89 50 04             	mov    %edx,0x4(%eax)
  801fb1:	eb 12                	jmp    801fc5 <initialize_MemBlocksList+0x9a>
  801fb3:	a1 50 50 80 00       	mov    0x805050,%eax
  801fb8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fbb:	c1 e2 04             	shl    $0x4,%edx
  801fbe:	01 d0                	add    %edx,%eax
  801fc0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801fc5:	a1 50 50 80 00       	mov    0x805050,%eax
  801fca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fcd:	c1 e2 04             	shl    $0x4,%edx
  801fd0:	01 d0                	add    %edx,%eax
  801fd2:	a3 48 51 80 00       	mov    %eax,0x805148
  801fd7:	a1 50 50 80 00       	mov    0x805050,%eax
  801fdc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fdf:	c1 e2 04             	shl    $0x4,%edx
  801fe2:	01 d0                	add    %edx,%eax
  801fe4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801feb:	a1 54 51 80 00       	mov    0x805154,%eax
  801ff0:	40                   	inc    %eax
  801ff1:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801ff6:	ff 45 f4             	incl   -0xc(%ebp)
  801ff9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ffc:	3b 45 08             	cmp    0x8(%ebp),%eax
  801fff:	0f 82 56 ff ff ff    	jb     801f5b <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802005:	90                   	nop
  802006:	c9                   	leave  
  802007:	c3                   	ret    

00802008 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802008:	55                   	push   %ebp
  802009:	89 e5                	mov    %esp,%ebp
  80200b:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80200e:	8b 45 08             	mov    0x8(%ebp),%eax
  802011:	8b 00                	mov    (%eax),%eax
  802013:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802016:	eb 19                	jmp    802031 <find_block+0x29>
	{
		if(va==point->sva)
  802018:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80201b:	8b 40 08             	mov    0x8(%eax),%eax
  80201e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802021:	75 05                	jne    802028 <find_block+0x20>
		   return point;
  802023:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802026:	eb 36                	jmp    80205e <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802028:	8b 45 08             	mov    0x8(%ebp),%eax
  80202b:	8b 40 08             	mov    0x8(%eax),%eax
  80202e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802031:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802035:	74 07                	je     80203e <find_block+0x36>
  802037:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80203a:	8b 00                	mov    (%eax),%eax
  80203c:	eb 05                	jmp    802043 <find_block+0x3b>
  80203e:	b8 00 00 00 00       	mov    $0x0,%eax
  802043:	8b 55 08             	mov    0x8(%ebp),%edx
  802046:	89 42 08             	mov    %eax,0x8(%edx)
  802049:	8b 45 08             	mov    0x8(%ebp),%eax
  80204c:	8b 40 08             	mov    0x8(%eax),%eax
  80204f:	85 c0                	test   %eax,%eax
  802051:	75 c5                	jne    802018 <find_block+0x10>
  802053:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802057:	75 bf                	jne    802018 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802059:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80205e:	c9                   	leave  
  80205f:	c3                   	ret    

00802060 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802060:	55                   	push   %ebp
  802061:	89 e5                	mov    %esp,%ebp
  802063:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802066:	a1 40 50 80 00       	mov    0x805040,%eax
  80206b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  80206e:	a1 44 50 80 00       	mov    0x805044,%eax
  802073:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802076:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802079:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80207c:	74 24                	je     8020a2 <insert_sorted_allocList+0x42>
  80207e:	8b 45 08             	mov    0x8(%ebp),%eax
  802081:	8b 50 08             	mov    0x8(%eax),%edx
  802084:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802087:	8b 40 08             	mov    0x8(%eax),%eax
  80208a:	39 c2                	cmp    %eax,%edx
  80208c:	76 14                	jbe    8020a2 <insert_sorted_allocList+0x42>
  80208e:	8b 45 08             	mov    0x8(%ebp),%eax
  802091:	8b 50 08             	mov    0x8(%eax),%edx
  802094:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802097:	8b 40 08             	mov    0x8(%eax),%eax
  80209a:	39 c2                	cmp    %eax,%edx
  80209c:	0f 82 60 01 00 00    	jb     802202 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8020a2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020a6:	75 65                	jne    80210d <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8020a8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020ac:	75 14                	jne    8020c2 <insert_sorted_allocList+0x62>
  8020ae:	83 ec 04             	sub    $0x4,%esp
  8020b1:	68 58 3f 80 00       	push   $0x803f58
  8020b6:	6a 6b                	push   $0x6b
  8020b8:	68 7b 3f 80 00       	push   $0x803f7b
  8020bd:	e8 bd e1 ff ff       	call   80027f <_panic>
  8020c2:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8020c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cb:	89 10                	mov    %edx,(%eax)
  8020cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d0:	8b 00                	mov    (%eax),%eax
  8020d2:	85 c0                	test   %eax,%eax
  8020d4:	74 0d                	je     8020e3 <insert_sorted_allocList+0x83>
  8020d6:	a1 40 50 80 00       	mov    0x805040,%eax
  8020db:	8b 55 08             	mov    0x8(%ebp),%edx
  8020de:	89 50 04             	mov    %edx,0x4(%eax)
  8020e1:	eb 08                	jmp    8020eb <insert_sorted_allocList+0x8b>
  8020e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e6:	a3 44 50 80 00       	mov    %eax,0x805044
  8020eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ee:	a3 40 50 80 00       	mov    %eax,0x805040
  8020f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020fd:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802102:	40                   	inc    %eax
  802103:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802108:	e9 dc 01 00 00       	jmp    8022e9 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  80210d:	8b 45 08             	mov    0x8(%ebp),%eax
  802110:	8b 50 08             	mov    0x8(%eax),%edx
  802113:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802116:	8b 40 08             	mov    0x8(%eax),%eax
  802119:	39 c2                	cmp    %eax,%edx
  80211b:	77 6c                	ja     802189 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  80211d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802121:	74 06                	je     802129 <insert_sorted_allocList+0xc9>
  802123:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802127:	75 14                	jne    80213d <insert_sorted_allocList+0xdd>
  802129:	83 ec 04             	sub    $0x4,%esp
  80212c:	68 94 3f 80 00       	push   $0x803f94
  802131:	6a 6f                	push   $0x6f
  802133:	68 7b 3f 80 00       	push   $0x803f7b
  802138:	e8 42 e1 ff ff       	call   80027f <_panic>
  80213d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802140:	8b 50 04             	mov    0x4(%eax),%edx
  802143:	8b 45 08             	mov    0x8(%ebp),%eax
  802146:	89 50 04             	mov    %edx,0x4(%eax)
  802149:	8b 45 08             	mov    0x8(%ebp),%eax
  80214c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80214f:	89 10                	mov    %edx,(%eax)
  802151:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802154:	8b 40 04             	mov    0x4(%eax),%eax
  802157:	85 c0                	test   %eax,%eax
  802159:	74 0d                	je     802168 <insert_sorted_allocList+0x108>
  80215b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80215e:	8b 40 04             	mov    0x4(%eax),%eax
  802161:	8b 55 08             	mov    0x8(%ebp),%edx
  802164:	89 10                	mov    %edx,(%eax)
  802166:	eb 08                	jmp    802170 <insert_sorted_allocList+0x110>
  802168:	8b 45 08             	mov    0x8(%ebp),%eax
  80216b:	a3 40 50 80 00       	mov    %eax,0x805040
  802170:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802173:	8b 55 08             	mov    0x8(%ebp),%edx
  802176:	89 50 04             	mov    %edx,0x4(%eax)
  802179:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80217e:	40                   	inc    %eax
  80217f:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802184:	e9 60 01 00 00       	jmp    8022e9 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802189:	8b 45 08             	mov    0x8(%ebp),%eax
  80218c:	8b 50 08             	mov    0x8(%eax),%edx
  80218f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802192:	8b 40 08             	mov    0x8(%eax),%eax
  802195:	39 c2                	cmp    %eax,%edx
  802197:	0f 82 4c 01 00 00    	jb     8022e9 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  80219d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021a1:	75 14                	jne    8021b7 <insert_sorted_allocList+0x157>
  8021a3:	83 ec 04             	sub    $0x4,%esp
  8021a6:	68 cc 3f 80 00       	push   $0x803fcc
  8021ab:	6a 73                	push   $0x73
  8021ad:	68 7b 3f 80 00       	push   $0x803f7b
  8021b2:	e8 c8 e0 ff ff       	call   80027f <_panic>
  8021b7:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8021bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c0:	89 50 04             	mov    %edx,0x4(%eax)
  8021c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c6:	8b 40 04             	mov    0x4(%eax),%eax
  8021c9:	85 c0                	test   %eax,%eax
  8021cb:	74 0c                	je     8021d9 <insert_sorted_allocList+0x179>
  8021cd:	a1 44 50 80 00       	mov    0x805044,%eax
  8021d2:	8b 55 08             	mov    0x8(%ebp),%edx
  8021d5:	89 10                	mov    %edx,(%eax)
  8021d7:	eb 08                	jmp    8021e1 <insert_sorted_allocList+0x181>
  8021d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021dc:	a3 40 50 80 00       	mov    %eax,0x805040
  8021e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e4:	a3 44 50 80 00       	mov    %eax,0x805044
  8021e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021f2:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8021f7:	40                   	inc    %eax
  8021f8:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8021fd:	e9 e7 00 00 00       	jmp    8022e9 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802202:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802205:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802208:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80220f:	a1 40 50 80 00       	mov    0x805040,%eax
  802214:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802217:	e9 9d 00 00 00       	jmp    8022b9 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  80221c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80221f:	8b 00                	mov    (%eax),%eax
  802221:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802224:	8b 45 08             	mov    0x8(%ebp),%eax
  802227:	8b 50 08             	mov    0x8(%eax),%edx
  80222a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80222d:	8b 40 08             	mov    0x8(%eax),%eax
  802230:	39 c2                	cmp    %eax,%edx
  802232:	76 7d                	jbe    8022b1 <insert_sorted_allocList+0x251>
  802234:	8b 45 08             	mov    0x8(%ebp),%eax
  802237:	8b 50 08             	mov    0x8(%eax),%edx
  80223a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80223d:	8b 40 08             	mov    0x8(%eax),%eax
  802240:	39 c2                	cmp    %eax,%edx
  802242:	73 6d                	jae    8022b1 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802244:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802248:	74 06                	je     802250 <insert_sorted_allocList+0x1f0>
  80224a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80224e:	75 14                	jne    802264 <insert_sorted_allocList+0x204>
  802250:	83 ec 04             	sub    $0x4,%esp
  802253:	68 f0 3f 80 00       	push   $0x803ff0
  802258:	6a 7f                	push   $0x7f
  80225a:	68 7b 3f 80 00       	push   $0x803f7b
  80225f:	e8 1b e0 ff ff       	call   80027f <_panic>
  802264:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802267:	8b 10                	mov    (%eax),%edx
  802269:	8b 45 08             	mov    0x8(%ebp),%eax
  80226c:	89 10                	mov    %edx,(%eax)
  80226e:	8b 45 08             	mov    0x8(%ebp),%eax
  802271:	8b 00                	mov    (%eax),%eax
  802273:	85 c0                	test   %eax,%eax
  802275:	74 0b                	je     802282 <insert_sorted_allocList+0x222>
  802277:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227a:	8b 00                	mov    (%eax),%eax
  80227c:	8b 55 08             	mov    0x8(%ebp),%edx
  80227f:	89 50 04             	mov    %edx,0x4(%eax)
  802282:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802285:	8b 55 08             	mov    0x8(%ebp),%edx
  802288:	89 10                	mov    %edx,(%eax)
  80228a:	8b 45 08             	mov    0x8(%ebp),%eax
  80228d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802290:	89 50 04             	mov    %edx,0x4(%eax)
  802293:	8b 45 08             	mov    0x8(%ebp),%eax
  802296:	8b 00                	mov    (%eax),%eax
  802298:	85 c0                	test   %eax,%eax
  80229a:	75 08                	jne    8022a4 <insert_sorted_allocList+0x244>
  80229c:	8b 45 08             	mov    0x8(%ebp),%eax
  80229f:	a3 44 50 80 00       	mov    %eax,0x805044
  8022a4:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8022a9:	40                   	inc    %eax
  8022aa:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8022af:	eb 39                	jmp    8022ea <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8022b1:	a1 48 50 80 00       	mov    0x805048,%eax
  8022b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022bd:	74 07                	je     8022c6 <insert_sorted_allocList+0x266>
  8022bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c2:	8b 00                	mov    (%eax),%eax
  8022c4:	eb 05                	jmp    8022cb <insert_sorted_allocList+0x26b>
  8022c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8022cb:	a3 48 50 80 00       	mov    %eax,0x805048
  8022d0:	a1 48 50 80 00       	mov    0x805048,%eax
  8022d5:	85 c0                	test   %eax,%eax
  8022d7:	0f 85 3f ff ff ff    	jne    80221c <insert_sorted_allocList+0x1bc>
  8022dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022e1:	0f 85 35 ff ff ff    	jne    80221c <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8022e7:	eb 01                	jmp    8022ea <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8022e9:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8022ea:	90                   	nop
  8022eb:	c9                   	leave  
  8022ec:	c3                   	ret    

008022ed <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8022ed:	55                   	push   %ebp
  8022ee:	89 e5                	mov    %esp,%ebp
  8022f0:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8022f3:	a1 38 51 80 00       	mov    0x805138,%eax
  8022f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022fb:	e9 85 01 00 00       	jmp    802485 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802300:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802303:	8b 40 0c             	mov    0xc(%eax),%eax
  802306:	3b 45 08             	cmp    0x8(%ebp),%eax
  802309:	0f 82 6e 01 00 00    	jb     80247d <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  80230f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802312:	8b 40 0c             	mov    0xc(%eax),%eax
  802315:	3b 45 08             	cmp    0x8(%ebp),%eax
  802318:	0f 85 8a 00 00 00    	jne    8023a8 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  80231e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802322:	75 17                	jne    80233b <alloc_block_FF+0x4e>
  802324:	83 ec 04             	sub    $0x4,%esp
  802327:	68 24 40 80 00       	push   $0x804024
  80232c:	68 93 00 00 00       	push   $0x93
  802331:	68 7b 3f 80 00       	push   $0x803f7b
  802336:	e8 44 df ff ff       	call   80027f <_panic>
  80233b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233e:	8b 00                	mov    (%eax),%eax
  802340:	85 c0                	test   %eax,%eax
  802342:	74 10                	je     802354 <alloc_block_FF+0x67>
  802344:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802347:	8b 00                	mov    (%eax),%eax
  802349:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80234c:	8b 52 04             	mov    0x4(%edx),%edx
  80234f:	89 50 04             	mov    %edx,0x4(%eax)
  802352:	eb 0b                	jmp    80235f <alloc_block_FF+0x72>
  802354:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802357:	8b 40 04             	mov    0x4(%eax),%eax
  80235a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80235f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802362:	8b 40 04             	mov    0x4(%eax),%eax
  802365:	85 c0                	test   %eax,%eax
  802367:	74 0f                	je     802378 <alloc_block_FF+0x8b>
  802369:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236c:	8b 40 04             	mov    0x4(%eax),%eax
  80236f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802372:	8b 12                	mov    (%edx),%edx
  802374:	89 10                	mov    %edx,(%eax)
  802376:	eb 0a                	jmp    802382 <alloc_block_FF+0x95>
  802378:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237b:	8b 00                	mov    (%eax),%eax
  80237d:	a3 38 51 80 00       	mov    %eax,0x805138
  802382:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802385:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80238b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802395:	a1 44 51 80 00       	mov    0x805144,%eax
  80239a:	48                   	dec    %eax
  80239b:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  8023a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a3:	e9 10 01 00 00       	jmp    8024b8 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8023a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ab:	8b 40 0c             	mov    0xc(%eax),%eax
  8023ae:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023b1:	0f 86 c6 00 00 00    	jbe    80247d <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8023b7:	a1 48 51 80 00       	mov    0x805148,%eax
  8023bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8023bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c2:	8b 50 08             	mov    0x8(%eax),%edx
  8023c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023c8:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8023cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8023d1:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8023d4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023d8:	75 17                	jne    8023f1 <alloc_block_FF+0x104>
  8023da:	83 ec 04             	sub    $0x4,%esp
  8023dd:	68 24 40 80 00       	push   $0x804024
  8023e2:	68 9b 00 00 00       	push   $0x9b
  8023e7:	68 7b 3f 80 00       	push   $0x803f7b
  8023ec:	e8 8e de ff ff       	call   80027f <_panic>
  8023f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023f4:	8b 00                	mov    (%eax),%eax
  8023f6:	85 c0                	test   %eax,%eax
  8023f8:	74 10                	je     80240a <alloc_block_FF+0x11d>
  8023fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023fd:	8b 00                	mov    (%eax),%eax
  8023ff:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802402:	8b 52 04             	mov    0x4(%edx),%edx
  802405:	89 50 04             	mov    %edx,0x4(%eax)
  802408:	eb 0b                	jmp    802415 <alloc_block_FF+0x128>
  80240a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80240d:	8b 40 04             	mov    0x4(%eax),%eax
  802410:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802415:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802418:	8b 40 04             	mov    0x4(%eax),%eax
  80241b:	85 c0                	test   %eax,%eax
  80241d:	74 0f                	je     80242e <alloc_block_FF+0x141>
  80241f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802422:	8b 40 04             	mov    0x4(%eax),%eax
  802425:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802428:	8b 12                	mov    (%edx),%edx
  80242a:	89 10                	mov    %edx,(%eax)
  80242c:	eb 0a                	jmp    802438 <alloc_block_FF+0x14b>
  80242e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802431:	8b 00                	mov    (%eax),%eax
  802433:	a3 48 51 80 00       	mov    %eax,0x805148
  802438:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80243b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802441:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802444:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80244b:	a1 54 51 80 00       	mov    0x805154,%eax
  802450:	48                   	dec    %eax
  802451:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802456:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802459:	8b 50 08             	mov    0x8(%eax),%edx
  80245c:	8b 45 08             	mov    0x8(%ebp),%eax
  80245f:	01 c2                	add    %eax,%edx
  802461:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802464:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802467:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246a:	8b 40 0c             	mov    0xc(%eax),%eax
  80246d:	2b 45 08             	sub    0x8(%ebp),%eax
  802470:	89 c2                	mov    %eax,%edx
  802472:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802475:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802478:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80247b:	eb 3b                	jmp    8024b8 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80247d:	a1 40 51 80 00       	mov    0x805140,%eax
  802482:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802485:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802489:	74 07                	je     802492 <alloc_block_FF+0x1a5>
  80248b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248e:	8b 00                	mov    (%eax),%eax
  802490:	eb 05                	jmp    802497 <alloc_block_FF+0x1aa>
  802492:	b8 00 00 00 00       	mov    $0x0,%eax
  802497:	a3 40 51 80 00       	mov    %eax,0x805140
  80249c:	a1 40 51 80 00       	mov    0x805140,%eax
  8024a1:	85 c0                	test   %eax,%eax
  8024a3:	0f 85 57 fe ff ff    	jne    802300 <alloc_block_FF+0x13>
  8024a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024ad:	0f 85 4d fe ff ff    	jne    802300 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8024b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024b8:	c9                   	leave  
  8024b9:	c3                   	ret    

008024ba <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8024ba:	55                   	push   %ebp
  8024bb:	89 e5                	mov    %esp,%ebp
  8024bd:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8024c0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8024c7:	a1 38 51 80 00       	mov    0x805138,%eax
  8024cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024cf:	e9 df 00 00 00       	jmp    8025b3 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8024d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d7:	8b 40 0c             	mov    0xc(%eax),%eax
  8024da:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024dd:	0f 82 c8 00 00 00    	jb     8025ab <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8024e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e6:	8b 40 0c             	mov    0xc(%eax),%eax
  8024e9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024ec:	0f 85 8a 00 00 00    	jne    80257c <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8024f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024f6:	75 17                	jne    80250f <alloc_block_BF+0x55>
  8024f8:	83 ec 04             	sub    $0x4,%esp
  8024fb:	68 24 40 80 00       	push   $0x804024
  802500:	68 b7 00 00 00       	push   $0xb7
  802505:	68 7b 3f 80 00       	push   $0x803f7b
  80250a:	e8 70 dd ff ff       	call   80027f <_panic>
  80250f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802512:	8b 00                	mov    (%eax),%eax
  802514:	85 c0                	test   %eax,%eax
  802516:	74 10                	je     802528 <alloc_block_BF+0x6e>
  802518:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251b:	8b 00                	mov    (%eax),%eax
  80251d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802520:	8b 52 04             	mov    0x4(%edx),%edx
  802523:	89 50 04             	mov    %edx,0x4(%eax)
  802526:	eb 0b                	jmp    802533 <alloc_block_BF+0x79>
  802528:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252b:	8b 40 04             	mov    0x4(%eax),%eax
  80252e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802533:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802536:	8b 40 04             	mov    0x4(%eax),%eax
  802539:	85 c0                	test   %eax,%eax
  80253b:	74 0f                	je     80254c <alloc_block_BF+0x92>
  80253d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802540:	8b 40 04             	mov    0x4(%eax),%eax
  802543:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802546:	8b 12                	mov    (%edx),%edx
  802548:	89 10                	mov    %edx,(%eax)
  80254a:	eb 0a                	jmp    802556 <alloc_block_BF+0x9c>
  80254c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254f:	8b 00                	mov    (%eax),%eax
  802551:	a3 38 51 80 00       	mov    %eax,0x805138
  802556:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802559:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80255f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802562:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802569:	a1 44 51 80 00       	mov    0x805144,%eax
  80256e:	48                   	dec    %eax
  80256f:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802574:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802577:	e9 4d 01 00 00       	jmp    8026c9 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  80257c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257f:	8b 40 0c             	mov    0xc(%eax),%eax
  802582:	3b 45 08             	cmp    0x8(%ebp),%eax
  802585:	76 24                	jbe    8025ab <alloc_block_BF+0xf1>
  802587:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258a:	8b 40 0c             	mov    0xc(%eax),%eax
  80258d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802590:	73 19                	jae    8025ab <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802592:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802599:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259c:	8b 40 0c             	mov    0xc(%eax),%eax
  80259f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8025a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a5:	8b 40 08             	mov    0x8(%eax),%eax
  8025a8:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8025ab:	a1 40 51 80 00       	mov    0x805140,%eax
  8025b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025b7:	74 07                	je     8025c0 <alloc_block_BF+0x106>
  8025b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bc:	8b 00                	mov    (%eax),%eax
  8025be:	eb 05                	jmp    8025c5 <alloc_block_BF+0x10b>
  8025c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8025c5:	a3 40 51 80 00       	mov    %eax,0x805140
  8025ca:	a1 40 51 80 00       	mov    0x805140,%eax
  8025cf:	85 c0                	test   %eax,%eax
  8025d1:	0f 85 fd fe ff ff    	jne    8024d4 <alloc_block_BF+0x1a>
  8025d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025db:	0f 85 f3 fe ff ff    	jne    8024d4 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8025e1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8025e5:	0f 84 d9 00 00 00    	je     8026c4 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8025eb:	a1 48 51 80 00       	mov    0x805148,%eax
  8025f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8025f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025f6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025f9:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8025fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025ff:	8b 55 08             	mov    0x8(%ebp),%edx
  802602:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802605:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802609:	75 17                	jne    802622 <alloc_block_BF+0x168>
  80260b:	83 ec 04             	sub    $0x4,%esp
  80260e:	68 24 40 80 00       	push   $0x804024
  802613:	68 c7 00 00 00       	push   $0xc7
  802618:	68 7b 3f 80 00       	push   $0x803f7b
  80261d:	e8 5d dc ff ff       	call   80027f <_panic>
  802622:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802625:	8b 00                	mov    (%eax),%eax
  802627:	85 c0                	test   %eax,%eax
  802629:	74 10                	je     80263b <alloc_block_BF+0x181>
  80262b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80262e:	8b 00                	mov    (%eax),%eax
  802630:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802633:	8b 52 04             	mov    0x4(%edx),%edx
  802636:	89 50 04             	mov    %edx,0x4(%eax)
  802639:	eb 0b                	jmp    802646 <alloc_block_BF+0x18c>
  80263b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80263e:	8b 40 04             	mov    0x4(%eax),%eax
  802641:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802646:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802649:	8b 40 04             	mov    0x4(%eax),%eax
  80264c:	85 c0                	test   %eax,%eax
  80264e:	74 0f                	je     80265f <alloc_block_BF+0x1a5>
  802650:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802653:	8b 40 04             	mov    0x4(%eax),%eax
  802656:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802659:	8b 12                	mov    (%edx),%edx
  80265b:	89 10                	mov    %edx,(%eax)
  80265d:	eb 0a                	jmp    802669 <alloc_block_BF+0x1af>
  80265f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802662:	8b 00                	mov    (%eax),%eax
  802664:	a3 48 51 80 00       	mov    %eax,0x805148
  802669:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80266c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802672:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802675:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80267c:	a1 54 51 80 00       	mov    0x805154,%eax
  802681:	48                   	dec    %eax
  802682:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802687:	83 ec 08             	sub    $0x8,%esp
  80268a:	ff 75 ec             	pushl  -0x14(%ebp)
  80268d:	68 38 51 80 00       	push   $0x805138
  802692:	e8 71 f9 ff ff       	call   802008 <find_block>
  802697:	83 c4 10             	add    $0x10,%esp
  80269a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  80269d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026a0:	8b 50 08             	mov    0x8(%eax),%edx
  8026a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a6:	01 c2                	add    %eax,%edx
  8026a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026ab:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8026ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026b1:	8b 40 0c             	mov    0xc(%eax),%eax
  8026b4:	2b 45 08             	sub    0x8(%ebp),%eax
  8026b7:	89 c2                	mov    %eax,%edx
  8026b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026bc:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8026bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026c2:	eb 05                	jmp    8026c9 <alloc_block_BF+0x20f>
	}
	return NULL;
  8026c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026c9:	c9                   	leave  
  8026ca:	c3                   	ret    

008026cb <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8026cb:	55                   	push   %ebp
  8026cc:	89 e5                	mov    %esp,%ebp
  8026ce:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8026d1:	a1 28 50 80 00       	mov    0x805028,%eax
  8026d6:	85 c0                	test   %eax,%eax
  8026d8:	0f 85 de 01 00 00    	jne    8028bc <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8026de:	a1 38 51 80 00       	mov    0x805138,%eax
  8026e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026e6:	e9 9e 01 00 00       	jmp    802889 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8026eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ee:	8b 40 0c             	mov    0xc(%eax),%eax
  8026f1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026f4:	0f 82 87 01 00 00    	jb     802881 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8026fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fd:	8b 40 0c             	mov    0xc(%eax),%eax
  802700:	3b 45 08             	cmp    0x8(%ebp),%eax
  802703:	0f 85 95 00 00 00    	jne    80279e <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802709:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80270d:	75 17                	jne    802726 <alloc_block_NF+0x5b>
  80270f:	83 ec 04             	sub    $0x4,%esp
  802712:	68 24 40 80 00       	push   $0x804024
  802717:	68 e0 00 00 00       	push   $0xe0
  80271c:	68 7b 3f 80 00       	push   $0x803f7b
  802721:	e8 59 db ff ff       	call   80027f <_panic>
  802726:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802729:	8b 00                	mov    (%eax),%eax
  80272b:	85 c0                	test   %eax,%eax
  80272d:	74 10                	je     80273f <alloc_block_NF+0x74>
  80272f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802732:	8b 00                	mov    (%eax),%eax
  802734:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802737:	8b 52 04             	mov    0x4(%edx),%edx
  80273a:	89 50 04             	mov    %edx,0x4(%eax)
  80273d:	eb 0b                	jmp    80274a <alloc_block_NF+0x7f>
  80273f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802742:	8b 40 04             	mov    0x4(%eax),%eax
  802745:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80274a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274d:	8b 40 04             	mov    0x4(%eax),%eax
  802750:	85 c0                	test   %eax,%eax
  802752:	74 0f                	je     802763 <alloc_block_NF+0x98>
  802754:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802757:	8b 40 04             	mov    0x4(%eax),%eax
  80275a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80275d:	8b 12                	mov    (%edx),%edx
  80275f:	89 10                	mov    %edx,(%eax)
  802761:	eb 0a                	jmp    80276d <alloc_block_NF+0xa2>
  802763:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802766:	8b 00                	mov    (%eax),%eax
  802768:	a3 38 51 80 00       	mov    %eax,0x805138
  80276d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802770:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802776:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802779:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802780:	a1 44 51 80 00       	mov    0x805144,%eax
  802785:	48                   	dec    %eax
  802786:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  80278b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278e:	8b 40 08             	mov    0x8(%eax),%eax
  802791:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802796:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802799:	e9 f8 04 00 00       	jmp    802c96 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  80279e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a1:	8b 40 0c             	mov    0xc(%eax),%eax
  8027a4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027a7:	0f 86 d4 00 00 00    	jbe    802881 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8027ad:	a1 48 51 80 00       	mov    0x805148,%eax
  8027b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8027b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b8:	8b 50 08             	mov    0x8(%eax),%edx
  8027bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027be:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8027c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8027c7:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8027ca:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027ce:	75 17                	jne    8027e7 <alloc_block_NF+0x11c>
  8027d0:	83 ec 04             	sub    $0x4,%esp
  8027d3:	68 24 40 80 00       	push   $0x804024
  8027d8:	68 e9 00 00 00       	push   $0xe9
  8027dd:	68 7b 3f 80 00       	push   $0x803f7b
  8027e2:	e8 98 da ff ff       	call   80027f <_panic>
  8027e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ea:	8b 00                	mov    (%eax),%eax
  8027ec:	85 c0                	test   %eax,%eax
  8027ee:	74 10                	je     802800 <alloc_block_NF+0x135>
  8027f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f3:	8b 00                	mov    (%eax),%eax
  8027f5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027f8:	8b 52 04             	mov    0x4(%edx),%edx
  8027fb:	89 50 04             	mov    %edx,0x4(%eax)
  8027fe:	eb 0b                	jmp    80280b <alloc_block_NF+0x140>
  802800:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802803:	8b 40 04             	mov    0x4(%eax),%eax
  802806:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80280b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80280e:	8b 40 04             	mov    0x4(%eax),%eax
  802811:	85 c0                	test   %eax,%eax
  802813:	74 0f                	je     802824 <alloc_block_NF+0x159>
  802815:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802818:	8b 40 04             	mov    0x4(%eax),%eax
  80281b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80281e:	8b 12                	mov    (%edx),%edx
  802820:	89 10                	mov    %edx,(%eax)
  802822:	eb 0a                	jmp    80282e <alloc_block_NF+0x163>
  802824:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802827:	8b 00                	mov    (%eax),%eax
  802829:	a3 48 51 80 00       	mov    %eax,0x805148
  80282e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802831:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802837:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80283a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802841:	a1 54 51 80 00       	mov    0x805154,%eax
  802846:	48                   	dec    %eax
  802847:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  80284c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80284f:	8b 40 08             	mov    0x8(%eax),%eax
  802852:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802857:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285a:	8b 50 08             	mov    0x8(%eax),%edx
  80285d:	8b 45 08             	mov    0x8(%ebp),%eax
  802860:	01 c2                	add    %eax,%edx
  802862:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802865:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802868:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286b:	8b 40 0c             	mov    0xc(%eax),%eax
  80286e:	2b 45 08             	sub    0x8(%ebp),%eax
  802871:	89 c2                	mov    %eax,%edx
  802873:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802876:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802879:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80287c:	e9 15 04 00 00       	jmp    802c96 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802881:	a1 40 51 80 00       	mov    0x805140,%eax
  802886:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802889:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80288d:	74 07                	je     802896 <alloc_block_NF+0x1cb>
  80288f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802892:	8b 00                	mov    (%eax),%eax
  802894:	eb 05                	jmp    80289b <alloc_block_NF+0x1d0>
  802896:	b8 00 00 00 00       	mov    $0x0,%eax
  80289b:	a3 40 51 80 00       	mov    %eax,0x805140
  8028a0:	a1 40 51 80 00       	mov    0x805140,%eax
  8028a5:	85 c0                	test   %eax,%eax
  8028a7:	0f 85 3e fe ff ff    	jne    8026eb <alloc_block_NF+0x20>
  8028ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028b1:	0f 85 34 fe ff ff    	jne    8026eb <alloc_block_NF+0x20>
  8028b7:	e9 d5 03 00 00       	jmp    802c91 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8028bc:	a1 38 51 80 00       	mov    0x805138,%eax
  8028c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028c4:	e9 b1 01 00 00       	jmp    802a7a <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8028c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cc:	8b 50 08             	mov    0x8(%eax),%edx
  8028cf:	a1 28 50 80 00       	mov    0x805028,%eax
  8028d4:	39 c2                	cmp    %eax,%edx
  8028d6:	0f 82 96 01 00 00    	jb     802a72 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  8028dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028df:	8b 40 0c             	mov    0xc(%eax),%eax
  8028e2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028e5:	0f 82 87 01 00 00    	jb     802a72 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  8028eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ee:	8b 40 0c             	mov    0xc(%eax),%eax
  8028f1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028f4:	0f 85 95 00 00 00    	jne    80298f <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8028fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028fe:	75 17                	jne    802917 <alloc_block_NF+0x24c>
  802900:	83 ec 04             	sub    $0x4,%esp
  802903:	68 24 40 80 00       	push   $0x804024
  802908:	68 fc 00 00 00       	push   $0xfc
  80290d:	68 7b 3f 80 00       	push   $0x803f7b
  802912:	e8 68 d9 ff ff       	call   80027f <_panic>
  802917:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291a:	8b 00                	mov    (%eax),%eax
  80291c:	85 c0                	test   %eax,%eax
  80291e:	74 10                	je     802930 <alloc_block_NF+0x265>
  802920:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802923:	8b 00                	mov    (%eax),%eax
  802925:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802928:	8b 52 04             	mov    0x4(%edx),%edx
  80292b:	89 50 04             	mov    %edx,0x4(%eax)
  80292e:	eb 0b                	jmp    80293b <alloc_block_NF+0x270>
  802930:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802933:	8b 40 04             	mov    0x4(%eax),%eax
  802936:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80293b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293e:	8b 40 04             	mov    0x4(%eax),%eax
  802941:	85 c0                	test   %eax,%eax
  802943:	74 0f                	je     802954 <alloc_block_NF+0x289>
  802945:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802948:	8b 40 04             	mov    0x4(%eax),%eax
  80294b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80294e:	8b 12                	mov    (%edx),%edx
  802950:	89 10                	mov    %edx,(%eax)
  802952:	eb 0a                	jmp    80295e <alloc_block_NF+0x293>
  802954:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802957:	8b 00                	mov    (%eax),%eax
  802959:	a3 38 51 80 00       	mov    %eax,0x805138
  80295e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802961:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802967:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802971:	a1 44 51 80 00       	mov    0x805144,%eax
  802976:	48                   	dec    %eax
  802977:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  80297c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297f:	8b 40 08             	mov    0x8(%eax),%eax
  802982:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802987:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298a:	e9 07 03 00 00       	jmp    802c96 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  80298f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802992:	8b 40 0c             	mov    0xc(%eax),%eax
  802995:	3b 45 08             	cmp    0x8(%ebp),%eax
  802998:	0f 86 d4 00 00 00    	jbe    802a72 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80299e:	a1 48 51 80 00       	mov    0x805148,%eax
  8029a3:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  8029a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a9:	8b 50 08             	mov    0x8(%eax),%edx
  8029ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029af:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8029b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8029b8:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8029bb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8029bf:	75 17                	jne    8029d8 <alloc_block_NF+0x30d>
  8029c1:	83 ec 04             	sub    $0x4,%esp
  8029c4:	68 24 40 80 00       	push   $0x804024
  8029c9:	68 04 01 00 00       	push   $0x104
  8029ce:	68 7b 3f 80 00       	push   $0x803f7b
  8029d3:	e8 a7 d8 ff ff       	call   80027f <_panic>
  8029d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029db:	8b 00                	mov    (%eax),%eax
  8029dd:	85 c0                	test   %eax,%eax
  8029df:	74 10                	je     8029f1 <alloc_block_NF+0x326>
  8029e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029e4:	8b 00                	mov    (%eax),%eax
  8029e6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8029e9:	8b 52 04             	mov    0x4(%edx),%edx
  8029ec:	89 50 04             	mov    %edx,0x4(%eax)
  8029ef:	eb 0b                	jmp    8029fc <alloc_block_NF+0x331>
  8029f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029f4:	8b 40 04             	mov    0x4(%eax),%eax
  8029f7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8029fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029ff:	8b 40 04             	mov    0x4(%eax),%eax
  802a02:	85 c0                	test   %eax,%eax
  802a04:	74 0f                	je     802a15 <alloc_block_NF+0x34a>
  802a06:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a09:	8b 40 04             	mov    0x4(%eax),%eax
  802a0c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a0f:	8b 12                	mov    (%edx),%edx
  802a11:	89 10                	mov    %edx,(%eax)
  802a13:	eb 0a                	jmp    802a1f <alloc_block_NF+0x354>
  802a15:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a18:	8b 00                	mov    (%eax),%eax
  802a1a:	a3 48 51 80 00       	mov    %eax,0x805148
  802a1f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a22:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a28:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a2b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a32:	a1 54 51 80 00       	mov    0x805154,%eax
  802a37:	48                   	dec    %eax
  802a38:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802a3d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a40:	8b 40 08             	mov    0x8(%eax),%eax
  802a43:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802a48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4b:	8b 50 08             	mov    0x8(%eax),%edx
  802a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a51:	01 c2                	add    %eax,%edx
  802a53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a56:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802a59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5c:	8b 40 0c             	mov    0xc(%eax),%eax
  802a5f:	2b 45 08             	sub    0x8(%ebp),%eax
  802a62:	89 c2                	mov    %eax,%edx
  802a64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a67:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802a6a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a6d:	e9 24 02 00 00       	jmp    802c96 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a72:	a1 40 51 80 00       	mov    0x805140,%eax
  802a77:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a7a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a7e:	74 07                	je     802a87 <alloc_block_NF+0x3bc>
  802a80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a83:	8b 00                	mov    (%eax),%eax
  802a85:	eb 05                	jmp    802a8c <alloc_block_NF+0x3c1>
  802a87:	b8 00 00 00 00       	mov    $0x0,%eax
  802a8c:	a3 40 51 80 00       	mov    %eax,0x805140
  802a91:	a1 40 51 80 00       	mov    0x805140,%eax
  802a96:	85 c0                	test   %eax,%eax
  802a98:	0f 85 2b fe ff ff    	jne    8028c9 <alloc_block_NF+0x1fe>
  802a9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aa2:	0f 85 21 fe ff ff    	jne    8028c9 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802aa8:	a1 38 51 80 00       	mov    0x805138,%eax
  802aad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ab0:	e9 ae 01 00 00       	jmp    802c63 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802ab5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab8:	8b 50 08             	mov    0x8(%eax),%edx
  802abb:	a1 28 50 80 00       	mov    0x805028,%eax
  802ac0:	39 c2                	cmp    %eax,%edx
  802ac2:	0f 83 93 01 00 00    	jae    802c5b <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802ac8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acb:	8b 40 0c             	mov    0xc(%eax),%eax
  802ace:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ad1:	0f 82 84 01 00 00    	jb     802c5b <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802ad7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ada:	8b 40 0c             	mov    0xc(%eax),%eax
  802add:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ae0:	0f 85 95 00 00 00    	jne    802b7b <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802ae6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aea:	75 17                	jne    802b03 <alloc_block_NF+0x438>
  802aec:	83 ec 04             	sub    $0x4,%esp
  802aef:	68 24 40 80 00       	push   $0x804024
  802af4:	68 14 01 00 00       	push   $0x114
  802af9:	68 7b 3f 80 00       	push   $0x803f7b
  802afe:	e8 7c d7 ff ff       	call   80027f <_panic>
  802b03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b06:	8b 00                	mov    (%eax),%eax
  802b08:	85 c0                	test   %eax,%eax
  802b0a:	74 10                	je     802b1c <alloc_block_NF+0x451>
  802b0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0f:	8b 00                	mov    (%eax),%eax
  802b11:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b14:	8b 52 04             	mov    0x4(%edx),%edx
  802b17:	89 50 04             	mov    %edx,0x4(%eax)
  802b1a:	eb 0b                	jmp    802b27 <alloc_block_NF+0x45c>
  802b1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1f:	8b 40 04             	mov    0x4(%eax),%eax
  802b22:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2a:	8b 40 04             	mov    0x4(%eax),%eax
  802b2d:	85 c0                	test   %eax,%eax
  802b2f:	74 0f                	je     802b40 <alloc_block_NF+0x475>
  802b31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b34:	8b 40 04             	mov    0x4(%eax),%eax
  802b37:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b3a:	8b 12                	mov    (%edx),%edx
  802b3c:	89 10                	mov    %edx,(%eax)
  802b3e:	eb 0a                	jmp    802b4a <alloc_block_NF+0x47f>
  802b40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b43:	8b 00                	mov    (%eax),%eax
  802b45:	a3 38 51 80 00       	mov    %eax,0x805138
  802b4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b56:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b5d:	a1 44 51 80 00       	mov    0x805144,%eax
  802b62:	48                   	dec    %eax
  802b63:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802b68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6b:	8b 40 08             	mov    0x8(%eax),%eax
  802b6e:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802b73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b76:	e9 1b 01 00 00       	jmp    802c96 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802b7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7e:	8b 40 0c             	mov    0xc(%eax),%eax
  802b81:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b84:	0f 86 d1 00 00 00    	jbe    802c5b <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b8a:	a1 48 51 80 00       	mov    0x805148,%eax
  802b8f:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802b92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b95:	8b 50 08             	mov    0x8(%eax),%edx
  802b98:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b9b:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802b9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ba1:	8b 55 08             	mov    0x8(%ebp),%edx
  802ba4:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802ba7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802bab:	75 17                	jne    802bc4 <alloc_block_NF+0x4f9>
  802bad:	83 ec 04             	sub    $0x4,%esp
  802bb0:	68 24 40 80 00       	push   $0x804024
  802bb5:	68 1c 01 00 00       	push   $0x11c
  802bba:	68 7b 3f 80 00       	push   $0x803f7b
  802bbf:	e8 bb d6 ff ff       	call   80027f <_panic>
  802bc4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bc7:	8b 00                	mov    (%eax),%eax
  802bc9:	85 c0                	test   %eax,%eax
  802bcb:	74 10                	je     802bdd <alloc_block_NF+0x512>
  802bcd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bd0:	8b 00                	mov    (%eax),%eax
  802bd2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802bd5:	8b 52 04             	mov    0x4(%edx),%edx
  802bd8:	89 50 04             	mov    %edx,0x4(%eax)
  802bdb:	eb 0b                	jmp    802be8 <alloc_block_NF+0x51d>
  802bdd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802be0:	8b 40 04             	mov    0x4(%eax),%eax
  802be3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802be8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802beb:	8b 40 04             	mov    0x4(%eax),%eax
  802bee:	85 c0                	test   %eax,%eax
  802bf0:	74 0f                	je     802c01 <alloc_block_NF+0x536>
  802bf2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bf5:	8b 40 04             	mov    0x4(%eax),%eax
  802bf8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802bfb:	8b 12                	mov    (%edx),%edx
  802bfd:	89 10                	mov    %edx,(%eax)
  802bff:	eb 0a                	jmp    802c0b <alloc_block_NF+0x540>
  802c01:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c04:	8b 00                	mov    (%eax),%eax
  802c06:	a3 48 51 80 00       	mov    %eax,0x805148
  802c0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c0e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c14:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c17:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c1e:	a1 54 51 80 00       	mov    0x805154,%eax
  802c23:	48                   	dec    %eax
  802c24:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802c29:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c2c:	8b 40 08             	mov    0x8(%eax),%eax
  802c2f:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802c34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c37:	8b 50 08             	mov    0x8(%eax),%edx
  802c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3d:	01 c2                	add    %eax,%edx
  802c3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c42:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802c45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c48:	8b 40 0c             	mov    0xc(%eax),%eax
  802c4b:	2b 45 08             	sub    0x8(%ebp),%eax
  802c4e:	89 c2                	mov    %eax,%edx
  802c50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c53:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802c56:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c59:	eb 3b                	jmp    802c96 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c5b:	a1 40 51 80 00       	mov    0x805140,%eax
  802c60:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c63:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c67:	74 07                	je     802c70 <alloc_block_NF+0x5a5>
  802c69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6c:	8b 00                	mov    (%eax),%eax
  802c6e:	eb 05                	jmp    802c75 <alloc_block_NF+0x5aa>
  802c70:	b8 00 00 00 00       	mov    $0x0,%eax
  802c75:	a3 40 51 80 00       	mov    %eax,0x805140
  802c7a:	a1 40 51 80 00       	mov    0x805140,%eax
  802c7f:	85 c0                	test   %eax,%eax
  802c81:	0f 85 2e fe ff ff    	jne    802ab5 <alloc_block_NF+0x3ea>
  802c87:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c8b:	0f 85 24 fe ff ff    	jne    802ab5 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802c91:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c96:	c9                   	leave  
  802c97:	c3                   	ret    

00802c98 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802c98:	55                   	push   %ebp
  802c99:	89 e5                	mov    %esp,%ebp
  802c9b:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802c9e:	a1 38 51 80 00       	mov    0x805138,%eax
  802ca3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802ca6:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802cab:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802cae:	a1 38 51 80 00       	mov    0x805138,%eax
  802cb3:	85 c0                	test   %eax,%eax
  802cb5:	74 14                	je     802ccb <insert_sorted_with_merge_freeList+0x33>
  802cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  802cba:	8b 50 08             	mov    0x8(%eax),%edx
  802cbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cc0:	8b 40 08             	mov    0x8(%eax),%eax
  802cc3:	39 c2                	cmp    %eax,%edx
  802cc5:	0f 87 9b 01 00 00    	ja     802e66 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802ccb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ccf:	75 17                	jne    802ce8 <insert_sorted_with_merge_freeList+0x50>
  802cd1:	83 ec 04             	sub    $0x4,%esp
  802cd4:	68 58 3f 80 00       	push   $0x803f58
  802cd9:	68 38 01 00 00       	push   $0x138
  802cde:	68 7b 3f 80 00       	push   $0x803f7b
  802ce3:	e8 97 d5 ff ff       	call   80027f <_panic>
  802ce8:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802cee:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf1:	89 10                	mov    %edx,(%eax)
  802cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf6:	8b 00                	mov    (%eax),%eax
  802cf8:	85 c0                	test   %eax,%eax
  802cfa:	74 0d                	je     802d09 <insert_sorted_with_merge_freeList+0x71>
  802cfc:	a1 38 51 80 00       	mov    0x805138,%eax
  802d01:	8b 55 08             	mov    0x8(%ebp),%edx
  802d04:	89 50 04             	mov    %edx,0x4(%eax)
  802d07:	eb 08                	jmp    802d11 <insert_sorted_with_merge_freeList+0x79>
  802d09:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d11:	8b 45 08             	mov    0x8(%ebp),%eax
  802d14:	a3 38 51 80 00       	mov    %eax,0x805138
  802d19:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d23:	a1 44 51 80 00       	mov    0x805144,%eax
  802d28:	40                   	inc    %eax
  802d29:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802d2e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d32:	0f 84 a8 06 00 00    	je     8033e0 <insert_sorted_with_merge_freeList+0x748>
  802d38:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3b:	8b 50 08             	mov    0x8(%eax),%edx
  802d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d41:	8b 40 0c             	mov    0xc(%eax),%eax
  802d44:	01 c2                	add    %eax,%edx
  802d46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d49:	8b 40 08             	mov    0x8(%eax),%eax
  802d4c:	39 c2                	cmp    %eax,%edx
  802d4e:	0f 85 8c 06 00 00    	jne    8033e0 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802d54:	8b 45 08             	mov    0x8(%ebp),%eax
  802d57:	8b 50 0c             	mov    0xc(%eax),%edx
  802d5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d5d:	8b 40 0c             	mov    0xc(%eax),%eax
  802d60:	01 c2                	add    %eax,%edx
  802d62:	8b 45 08             	mov    0x8(%ebp),%eax
  802d65:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802d68:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d6c:	75 17                	jne    802d85 <insert_sorted_with_merge_freeList+0xed>
  802d6e:	83 ec 04             	sub    $0x4,%esp
  802d71:	68 24 40 80 00       	push   $0x804024
  802d76:	68 3c 01 00 00       	push   $0x13c
  802d7b:	68 7b 3f 80 00       	push   $0x803f7b
  802d80:	e8 fa d4 ff ff       	call   80027f <_panic>
  802d85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d88:	8b 00                	mov    (%eax),%eax
  802d8a:	85 c0                	test   %eax,%eax
  802d8c:	74 10                	je     802d9e <insert_sorted_with_merge_freeList+0x106>
  802d8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d91:	8b 00                	mov    (%eax),%eax
  802d93:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d96:	8b 52 04             	mov    0x4(%edx),%edx
  802d99:	89 50 04             	mov    %edx,0x4(%eax)
  802d9c:	eb 0b                	jmp    802da9 <insert_sorted_with_merge_freeList+0x111>
  802d9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da1:	8b 40 04             	mov    0x4(%eax),%eax
  802da4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802da9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dac:	8b 40 04             	mov    0x4(%eax),%eax
  802daf:	85 c0                	test   %eax,%eax
  802db1:	74 0f                	je     802dc2 <insert_sorted_with_merge_freeList+0x12a>
  802db3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802db6:	8b 40 04             	mov    0x4(%eax),%eax
  802db9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802dbc:	8b 12                	mov    (%edx),%edx
  802dbe:	89 10                	mov    %edx,(%eax)
  802dc0:	eb 0a                	jmp    802dcc <insert_sorted_with_merge_freeList+0x134>
  802dc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc5:	8b 00                	mov    (%eax),%eax
  802dc7:	a3 38 51 80 00       	mov    %eax,0x805138
  802dcc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dcf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dd8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ddf:	a1 44 51 80 00       	mov    0x805144,%eax
  802de4:	48                   	dec    %eax
  802de5:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802dea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ded:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802df4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802dfe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e02:	75 17                	jne    802e1b <insert_sorted_with_merge_freeList+0x183>
  802e04:	83 ec 04             	sub    $0x4,%esp
  802e07:	68 58 3f 80 00       	push   $0x803f58
  802e0c:	68 3f 01 00 00       	push   $0x13f
  802e11:	68 7b 3f 80 00       	push   $0x803f7b
  802e16:	e8 64 d4 ff ff       	call   80027f <_panic>
  802e1b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802e21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e24:	89 10                	mov    %edx,(%eax)
  802e26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e29:	8b 00                	mov    (%eax),%eax
  802e2b:	85 c0                	test   %eax,%eax
  802e2d:	74 0d                	je     802e3c <insert_sorted_with_merge_freeList+0x1a4>
  802e2f:	a1 48 51 80 00       	mov    0x805148,%eax
  802e34:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e37:	89 50 04             	mov    %edx,0x4(%eax)
  802e3a:	eb 08                	jmp    802e44 <insert_sorted_with_merge_freeList+0x1ac>
  802e3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e3f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e47:	a3 48 51 80 00       	mov    %eax,0x805148
  802e4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e4f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e56:	a1 54 51 80 00       	mov    0x805154,%eax
  802e5b:	40                   	inc    %eax
  802e5c:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802e61:	e9 7a 05 00 00       	jmp    8033e0 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802e66:	8b 45 08             	mov    0x8(%ebp),%eax
  802e69:	8b 50 08             	mov    0x8(%eax),%edx
  802e6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e6f:	8b 40 08             	mov    0x8(%eax),%eax
  802e72:	39 c2                	cmp    %eax,%edx
  802e74:	0f 82 14 01 00 00    	jb     802f8e <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802e7a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e7d:	8b 50 08             	mov    0x8(%eax),%edx
  802e80:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e83:	8b 40 0c             	mov    0xc(%eax),%eax
  802e86:	01 c2                	add    %eax,%edx
  802e88:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8b:	8b 40 08             	mov    0x8(%eax),%eax
  802e8e:	39 c2                	cmp    %eax,%edx
  802e90:	0f 85 90 00 00 00    	jne    802f26 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802e96:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e99:	8b 50 0c             	mov    0xc(%eax),%edx
  802e9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9f:	8b 40 0c             	mov    0xc(%eax),%eax
  802ea2:	01 c2                	add    %eax,%edx
  802ea4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ea7:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802eaa:	8b 45 08             	mov    0x8(%ebp),%eax
  802ead:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802eb4:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802ebe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ec2:	75 17                	jne    802edb <insert_sorted_with_merge_freeList+0x243>
  802ec4:	83 ec 04             	sub    $0x4,%esp
  802ec7:	68 58 3f 80 00       	push   $0x803f58
  802ecc:	68 49 01 00 00       	push   $0x149
  802ed1:	68 7b 3f 80 00       	push   $0x803f7b
  802ed6:	e8 a4 d3 ff ff       	call   80027f <_panic>
  802edb:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee4:	89 10                	mov    %edx,(%eax)
  802ee6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee9:	8b 00                	mov    (%eax),%eax
  802eeb:	85 c0                	test   %eax,%eax
  802eed:	74 0d                	je     802efc <insert_sorted_with_merge_freeList+0x264>
  802eef:	a1 48 51 80 00       	mov    0x805148,%eax
  802ef4:	8b 55 08             	mov    0x8(%ebp),%edx
  802ef7:	89 50 04             	mov    %edx,0x4(%eax)
  802efa:	eb 08                	jmp    802f04 <insert_sorted_with_merge_freeList+0x26c>
  802efc:	8b 45 08             	mov    0x8(%ebp),%eax
  802eff:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f04:	8b 45 08             	mov    0x8(%ebp),%eax
  802f07:	a3 48 51 80 00       	mov    %eax,0x805148
  802f0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f16:	a1 54 51 80 00       	mov    0x805154,%eax
  802f1b:	40                   	inc    %eax
  802f1c:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802f21:	e9 bb 04 00 00       	jmp    8033e1 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802f26:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f2a:	75 17                	jne    802f43 <insert_sorted_with_merge_freeList+0x2ab>
  802f2c:	83 ec 04             	sub    $0x4,%esp
  802f2f:	68 cc 3f 80 00       	push   $0x803fcc
  802f34:	68 4c 01 00 00       	push   $0x14c
  802f39:	68 7b 3f 80 00       	push   $0x803f7b
  802f3e:	e8 3c d3 ff ff       	call   80027f <_panic>
  802f43:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802f49:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4c:	89 50 04             	mov    %edx,0x4(%eax)
  802f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f52:	8b 40 04             	mov    0x4(%eax),%eax
  802f55:	85 c0                	test   %eax,%eax
  802f57:	74 0c                	je     802f65 <insert_sorted_with_merge_freeList+0x2cd>
  802f59:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f5e:	8b 55 08             	mov    0x8(%ebp),%edx
  802f61:	89 10                	mov    %edx,(%eax)
  802f63:	eb 08                	jmp    802f6d <insert_sorted_with_merge_freeList+0x2d5>
  802f65:	8b 45 08             	mov    0x8(%ebp),%eax
  802f68:	a3 38 51 80 00       	mov    %eax,0x805138
  802f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f70:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f75:	8b 45 08             	mov    0x8(%ebp),%eax
  802f78:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f7e:	a1 44 51 80 00       	mov    0x805144,%eax
  802f83:	40                   	inc    %eax
  802f84:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802f89:	e9 53 04 00 00       	jmp    8033e1 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802f8e:	a1 38 51 80 00       	mov    0x805138,%eax
  802f93:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f96:	e9 15 04 00 00       	jmp    8033b0 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802f9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f9e:	8b 00                	mov    (%eax),%eax
  802fa0:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa6:	8b 50 08             	mov    0x8(%eax),%edx
  802fa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fac:	8b 40 08             	mov    0x8(%eax),%eax
  802faf:	39 c2                	cmp    %eax,%edx
  802fb1:	0f 86 f1 03 00 00    	jbe    8033a8 <insert_sorted_with_merge_freeList+0x710>
  802fb7:	8b 45 08             	mov    0x8(%ebp),%eax
  802fba:	8b 50 08             	mov    0x8(%eax),%edx
  802fbd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fc0:	8b 40 08             	mov    0x8(%eax),%eax
  802fc3:	39 c2                	cmp    %eax,%edx
  802fc5:	0f 83 dd 03 00 00    	jae    8033a8 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802fcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fce:	8b 50 08             	mov    0x8(%eax),%edx
  802fd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd4:	8b 40 0c             	mov    0xc(%eax),%eax
  802fd7:	01 c2                	add    %eax,%edx
  802fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fdc:	8b 40 08             	mov    0x8(%eax),%eax
  802fdf:	39 c2                	cmp    %eax,%edx
  802fe1:	0f 85 b9 01 00 00    	jne    8031a0 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  802fea:	8b 50 08             	mov    0x8(%eax),%edx
  802fed:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff0:	8b 40 0c             	mov    0xc(%eax),%eax
  802ff3:	01 c2                	add    %eax,%edx
  802ff5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ff8:	8b 40 08             	mov    0x8(%eax),%eax
  802ffb:	39 c2                	cmp    %eax,%edx
  802ffd:	0f 85 0d 01 00 00    	jne    803110 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803003:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803006:	8b 50 0c             	mov    0xc(%eax),%edx
  803009:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80300c:	8b 40 0c             	mov    0xc(%eax),%eax
  80300f:	01 c2                	add    %eax,%edx
  803011:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803014:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803017:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80301b:	75 17                	jne    803034 <insert_sorted_with_merge_freeList+0x39c>
  80301d:	83 ec 04             	sub    $0x4,%esp
  803020:	68 24 40 80 00       	push   $0x804024
  803025:	68 5c 01 00 00       	push   $0x15c
  80302a:	68 7b 3f 80 00       	push   $0x803f7b
  80302f:	e8 4b d2 ff ff       	call   80027f <_panic>
  803034:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803037:	8b 00                	mov    (%eax),%eax
  803039:	85 c0                	test   %eax,%eax
  80303b:	74 10                	je     80304d <insert_sorted_with_merge_freeList+0x3b5>
  80303d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803040:	8b 00                	mov    (%eax),%eax
  803042:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803045:	8b 52 04             	mov    0x4(%edx),%edx
  803048:	89 50 04             	mov    %edx,0x4(%eax)
  80304b:	eb 0b                	jmp    803058 <insert_sorted_with_merge_freeList+0x3c0>
  80304d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803050:	8b 40 04             	mov    0x4(%eax),%eax
  803053:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803058:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80305b:	8b 40 04             	mov    0x4(%eax),%eax
  80305e:	85 c0                	test   %eax,%eax
  803060:	74 0f                	je     803071 <insert_sorted_with_merge_freeList+0x3d9>
  803062:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803065:	8b 40 04             	mov    0x4(%eax),%eax
  803068:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80306b:	8b 12                	mov    (%edx),%edx
  80306d:	89 10                	mov    %edx,(%eax)
  80306f:	eb 0a                	jmp    80307b <insert_sorted_with_merge_freeList+0x3e3>
  803071:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803074:	8b 00                	mov    (%eax),%eax
  803076:	a3 38 51 80 00       	mov    %eax,0x805138
  80307b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80307e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803084:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803087:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80308e:	a1 44 51 80 00       	mov    0x805144,%eax
  803093:	48                   	dec    %eax
  803094:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803099:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80309c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8030a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030a6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8030ad:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030b1:	75 17                	jne    8030ca <insert_sorted_with_merge_freeList+0x432>
  8030b3:	83 ec 04             	sub    $0x4,%esp
  8030b6:	68 58 3f 80 00       	push   $0x803f58
  8030bb:	68 5f 01 00 00       	push   $0x15f
  8030c0:	68 7b 3f 80 00       	push   $0x803f7b
  8030c5:	e8 b5 d1 ff ff       	call   80027f <_panic>
  8030ca:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8030d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030d3:	89 10                	mov    %edx,(%eax)
  8030d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030d8:	8b 00                	mov    (%eax),%eax
  8030da:	85 c0                	test   %eax,%eax
  8030dc:	74 0d                	je     8030eb <insert_sorted_with_merge_freeList+0x453>
  8030de:	a1 48 51 80 00       	mov    0x805148,%eax
  8030e3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030e6:	89 50 04             	mov    %edx,0x4(%eax)
  8030e9:	eb 08                	jmp    8030f3 <insert_sorted_with_merge_freeList+0x45b>
  8030eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ee:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030f6:	a3 48 51 80 00       	mov    %eax,0x805148
  8030fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030fe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803105:	a1 54 51 80 00       	mov    0x805154,%eax
  80310a:	40                   	inc    %eax
  80310b:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803110:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803113:	8b 50 0c             	mov    0xc(%eax),%edx
  803116:	8b 45 08             	mov    0x8(%ebp),%eax
  803119:	8b 40 0c             	mov    0xc(%eax),%eax
  80311c:	01 c2                	add    %eax,%edx
  80311e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803121:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803124:	8b 45 08             	mov    0x8(%ebp),%eax
  803127:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  80312e:	8b 45 08             	mov    0x8(%ebp),%eax
  803131:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803138:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80313c:	75 17                	jne    803155 <insert_sorted_with_merge_freeList+0x4bd>
  80313e:	83 ec 04             	sub    $0x4,%esp
  803141:	68 58 3f 80 00       	push   $0x803f58
  803146:	68 64 01 00 00       	push   $0x164
  80314b:	68 7b 3f 80 00       	push   $0x803f7b
  803150:	e8 2a d1 ff ff       	call   80027f <_panic>
  803155:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80315b:	8b 45 08             	mov    0x8(%ebp),%eax
  80315e:	89 10                	mov    %edx,(%eax)
  803160:	8b 45 08             	mov    0x8(%ebp),%eax
  803163:	8b 00                	mov    (%eax),%eax
  803165:	85 c0                	test   %eax,%eax
  803167:	74 0d                	je     803176 <insert_sorted_with_merge_freeList+0x4de>
  803169:	a1 48 51 80 00       	mov    0x805148,%eax
  80316e:	8b 55 08             	mov    0x8(%ebp),%edx
  803171:	89 50 04             	mov    %edx,0x4(%eax)
  803174:	eb 08                	jmp    80317e <insert_sorted_with_merge_freeList+0x4e6>
  803176:	8b 45 08             	mov    0x8(%ebp),%eax
  803179:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80317e:	8b 45 08             	mov    0x8(%ebp),%eax
  803181:	a3 48 51 80 00       	mov    %eax,0x805148
  803186:	8b 45 08             	mov    0x8(%ebp),%eax
  803189:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803190:	a1 54 51 80 00       	mov    0x805154,%eax
  803195:	40                   	inc    %eax
  803196:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80319b:	e9 41 02 00 00       	jmp    8033e1 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8031a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a3:	8b 50 08             	mov    0x8(%eax),%edx
  8031a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8031ac:	01 c2                	add    %eax,%edx
  8031ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031b1:	8b 40 08             	mov    0x8(%eax),%eax
  8031b4:	39 c2                	cmp    %eax,%edx
  8031b6:	0f 85 7c 01 00 00    	jne    803338 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8031bc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031c0:	74 06                	je     8031c8 <insert_sorted_with_merge_freeList+0x530>
  8031c2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031c6:	75 17                	jne    8031df <insert_sorted_with_merge_freeList+0x547>
  8031c8:	83 ec 04             	sub    $0x4,%esp
  8031cb:	68 94 3f 80 00       	push   $0x803f94
  8031d0:	68 69 01 00 00       	push   $0x169
  8031d5:	68 7b 3f 80 00       	push   $0x803f7b
  8031da:	e8 a0 d0 ff ff       	call   80027f <_panic>
  8031df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e2:	8b 50 04             	mov    0x4(%eax),%edx
  8031e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e8:	89 50 04             	mov    %edx,0x4(%eax)
  8031eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ee:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031f1:	89 10                	mov    %edx,(%eax)
  8031f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f6:	8b 40 04             	mov    0x4(%eax),%eax
  8031f9:	85 c0                	test   %eax,%eax
  8031fb:	74 0d                	je     80320a <insert_sorted_with_merge_freeList+0x572>
  8031fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803200:	8b 40 04             	mov    0x4(%eax),%eax
  803203:	8b 55 08             	mov    0x8(%ebp),%edx
  803206:	89 10                	mov    %edx,(%eax)
  803208:	eb 08                	jmp    803212 <insert_sorted_with_merge_freeList+0x57a>
  80320a:	8b 45 08             	mov    0x8(%ebp),%eax
  80320d:	a3 38 51 80 00       	mov    %eax,0x805138
  803212:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803215:	8b 55 08             	mov    0x8(%ebp),%edx
  803218:	89 50 04             	mov    %edx,0x4(%eax)
  80321b:	a1 44 51 80 00       	mov    0x805144,%eax
  803220:	40                   	inc    %eax
  803221:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803226:	8b 45 08             	mov    0x8(%ebp),%eax
  803229:	8b 50 0c             	mov    0xc(%eax),%edx
  80322c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80322f:	8b 40 0c             	mov    0xc(%eax),%eax
  803232:	01 c2                	add    %eax,%edx
  803234:	8b 45 08             	mov    0x8(%ebp),%eax
  803237:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80323a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80323e:	75 17                	jne    803257 <insert_sorted_with_merge_freeList+0x5bf>
  803240:	83 ec 04             	sub    $0x4,%esp
  803243:	68 24 40 80 00       	push   $0x804024
  803248:	68 6b 01 00 00       	push   $0x16b
  80324d:	68 7b 3f 80 00       	push   $0x803f7b
  803252:	e8 28 d0 ff ff       	call   80027f <_panic>
  803257:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80325a:	8b 00                	mov    (%eax),%eax
  80325c:	85 c0                	test   %eax,%eax
  80325e:	74 10                	je     803270 <insert_sorted_with_merge_freeList+0x5d8>
  803260:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803263:	8b 00                	mov    (%eax),%eax
  803265:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803268:	8b 52 04             	mov    0x4(%edx),%edx
  80326b:	89 50 04             	mov    %edx,0x4(%eax)
  80326e:	eb 0b                	jmp    80327b <insert_sorted_with_merge_freeList+0x5e3>
  803270:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803273:	8b 40 04             	mov    0x4(%eax),%eax
  803276:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80327b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80327e:	8b 40 04             	mov    0x4(%eax),%eax
  803281:	85 c0                	test   %eax,%eax
  803283:	74 0f                	je     803294 <insert_sorted_with_merge_freeList+0x5fc>
  803285:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803288:	8b 40 04             	mov    0x4(%eax),%eax
  80328b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80328e:	8b 12                	mov    (%edx),%edx
  803290:	89 10                	mov    %edx,(%eax)
  803292:	eb 0a                	jmp    80329e <insert_sorted_with_merge_freeList+0x606>
  803294:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803297:	8b 00                	mov    (%eax),%eax
  803299:	a3 38 51 80 00       	mov    %eax,0x805138
  80329e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032a1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032aa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032b1:	a1 44 51 80 00       	mov    0x805144,%eax
  8032b6:	48                   	dec    %eax
  8032b7:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8032bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032bf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8032c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032c9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8032d0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032d4:	75 17                	jne    8032ed <insert_sorted_with_merge_freeList+0x655>
  8032d6:	83 ec 04             	sub    $0x4,%esp
  8032d9:	68 58 3f 80 00       	push   $0x803f58
  8032de:	68 6e 01 00 00       	push   $0x16e
  8032e3:	68 7b 3f 80 00       	push   $0x803f7b
  8032e8:	e8 92 cf ff ff       	call   80027f <_panic>
  8032ed:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032f6:	89 10                	mov    %edx,(%eax)
  8032f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032fb:	8b 00                	mov    (%eax),%eax
  8032fd:	85 c0                	test   %eax,%eax
  8032ff:	74 0d                	je     80330e <insert_sorted_with_merge_freeList+0x676>
  803301:	a1 48 51 80 00       	mov    0x805148,%eax
  803306:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803309:	89 50 04             	mov    %edx,0x4(%eax)
  80330c:	eb 08                	jmp    803316 <insert_sorted_with_merge_freeList+0x67e>
  80330e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803311:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803316:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803319:	a3 48 51 80 00       	mov    %eax,0x805148
  80331e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803321:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803328:	a1 54 51 80 00       	mov    0x805154,%eax
  80332d:	40                   	inc    %eax
  80332e:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803333:	e9 a9 00 00 00       	jmp    8033e1 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803338:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80333c:	74 06                	je     803344 <insert_sorted_with_merge_freeList+0x6ac>
  80333e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803342:	75 17                	jne    80335b <insert_sorted_with_merge_freeList+0x6c3>
  803344:	83 ec 04             	sub    $0x4,%esp
  803347:	68 f0 3f 80 00       	push   $0x803ff0
  80334c:	68 73 01 00 00       	push   $0x173
  803351:	68 7b 3f 80 00       	push   $0x803f7b
  803356:	e8 24 cf ff ff       	call   80027f <_panic>
  80335b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80335e:	8b 10                	mov    (%eax),%edx
  803360:	8b 45 08             	mov    0x8(%ebp),%eax
  803363:	89 10                	mov    %edx,(%eax)
  803365:	8b 45 08             	mov    0x8(%ebp),%eax
  803368:	8b 00                	mov    (%eax),%eax
  80336a:	85 c0                	test   %eax,%eax
  80336c:	74 0b                	je     803379 <insert_sorted_with_merge_freeList+0x6e1>
  80336e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803371:	8b 00                	mov    (%eax),%eax
  803373:	8b 55 08             	mov    0x8(%ebp),%edx
  803376:	89 50 04             	mov    %edx,0x4(%eax)
  803379:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80337c:	8b 55 08             	mov    0x8(%ebp),%edx
  80337f:	89 10                	mov    %edx,(%eax)
  803381:	8b 45 08             	mov    0x8(%ebp),%eax
  803384:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803387:	89 50 04             	mov    %edx,0x4(%eax)
  80338a:	8b 45 08             	mov    0x8(%ebp),%eax
  80338d:	8b 00                	mov    (%eax),%eax
  80338f:	85 c0                	test   %eax,%eax
  803391:	75 08                	jne    80339b <insert_sorted_with_merge_freeList+0x703>
  803393:	8b 45 08             	mov    0x8(%ebp),%eax
  803396:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80339b:	a1 44 51 80 00       	mov    0x805144,%eax
  8033a0:	40                   	inc    %eax
  8033a1:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  8033a6:	eb 39                	jmp    8033e1 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8033a8:	a1 40 51 80 00       	mov    0x805140,%eax
  8033ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033b4:	74 07                	je     8033bd <insert_sorted_with_merge_freeList+0x725>
  8033b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b9:	8b 00                	mov    (%eax),%eax
  8033bb:	eb 05                	jmp    8033c2 <insert_sorted_with_merge_freeList+0x72a>
  8033bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8033c2:	a3 40 51 80 00       	mov    %eax,0x805140
  8033c7:	a1 40 51 80 00       	mov    0x805140,%eax
  8033cc:	85 c0                	test   %eax,%eax
  8033ce:	0f 85 c7 fb ff ff    	jne    802f9b <insert_sorted_with_merge_freeList+0x303>
  8033d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033d8:	0f 85 bd fb ff ff    	jne    802f9b <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8033de:	eb 01                	jmp    8033e1 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8033e0:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8033e1:	90                   	nop
  8033e2:	c9                   	leave  
  8033e3:	c3                   	ret    

008033e4 <__udivdi3>:
  8033e4:	55                   	push   %ebp
  8033e5:	57                   	push   %edi
  8033e6:	56                   	push   %esi
  8033e7:	53                   	push   %ebx
  8033e8:	83 ec 1c             	sub    $0x1c,%esp
  8033eb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8033ef:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8033f3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8033f7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8033fb:	89 ca                	mov    %ecx,%edx
  8033fd:	89 f8                	mov    %edi,%eax
  8033ff:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803403:	85 f6                	test   %esi,%esi
  803405:	75 2d                	jne    803434 <__udivdi3+0x50>
  803407:	39 cf                	cmp    %ecx,%edi
  803409:	77 65                	ja     803470 <__udivdi3+0x8c>
  80340b:	89 fd                	mov    %edi,%ebp
  80340d:	85 ff                	test   %edi,%edi
  80340f:	75 0b                	jne    80341c <__udivdi3+0x38>
  803411:	b8 01 00 00 00       	mov    $0x1,%eax
  803416:	31 d2                	xor    %edx,%edx
  803418:	f7 f7                	div    %edi
  80341a:	89 c5                	mov    %eax,%ebp
  80341c:	31 d2                	xor    %edx,%edx
  80341e:	89 c8                	mov    %ecx,%eax
  803420:	f7 f5                	div    %ebp
  803422:	89 c1                	mov    %eax,%ecx
  803424:	89 d8                	mov    %ebx,%eax
  803426:	f7 f5                	div    %ebp
  803428:	89 cf                	mov    %ecx,%edi
  80342a:	89 fa                	mov    %edi,%edx
  80342c:	83 c4 1c             	add    $0x1c,%esp
  80342f:	5b                   	pop    %ebx
  803430:	5e                   	pop    %esi
  803431:	5f                   	pop    %edi
  803432:	5d                   	pop    %ebp
  803433:	c3                   	ret    
  803434:	39 ce                	cmp    %ecx,%esi
  803436:	77 28                	ja     803460 <__udivdi3+0x7c>
  803438:	0f bd fe             	bsr    %esi,%edi
  80343b:	83 f7 1f             	xor    $0x1f,%edi
  80343e:	75 40                	jne    803480 <__udivdi3+0x9c>
  803440:	39 ce                	cmp    %ecx,%esi
  803442:	72 0a                	jb     80344e <__udivdi3+0x6a>
  803444:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803448:	0f 87 9e 00 00 00    	ja     8034ec <__udivdi3+0x108>
  80344e:	b8 01 00 00 00       	mov    $0x1,%eax
  803453:	89 fa                	mov    %edi,%edx
  803455:	83 c4 1c             	add    $0x1c,%esp
  803458:	5b                   	pop    %ebx
  803459:	5e                   	pop    %esi
  80345a:	5f                   	pop    %edi
  80345b:	5d                   	pop    %ebp
  80345c:	c3                   	ret    
  80345d:	8d 76 00             	lea    0x0(%esi),%esi
  803460:	31 ff                	xor    %edi,%edi
  803462:	31 c0                	xor    %eax,%eax
  803464:	89 fa                	mov    %edi,%edx
  803466:	83 c4 1c             	add    $0x1c,%esp
  803469:	5b                   	pop    %ebx
  80346a:	5e                   	pop    %esi
  80346b:	5f                   	pop    %edi
  80346c:	5d                   	pop    %ebp
  80346d:	c3                   	ret    
  80346e:	66 90                	xchg   %ax,%ax
  803470:	89 d8                	mov    %ebx,%eax
  803472:	f7 f7                	div    %edi
  803474:	31 ff                	xor    %edi,%edi
  803476:	89 fa                	mov    %edi,%edx
  803478:	83 c4 1c             	add    $0x1c,%esp
  80347b:	5b                   	pop    %ebx
  80347c:	5e                   	pop    %esi
  80347d:	5f                   	pop    %edi
  80347e:	5d                   	pop    %ebp
  80347f:	c3                   	ret    
  803480:	bd 20 00 00 00       	mov    $0x20,%ebp
  803485:	89 eb                	mov    %ebp,%ebx
  803487:	29 fb                	sub    %edi,%ebx
  803489:	89 f9                	mov    %edi,%ecx
  80348b:	d3 e6                	shl    %cl,%esi
  80348d:	89 c5                	mov    %eax,%ebp
  80348f:	88 d9                	mov    %bl,%cl
  803491:	d3 ed                	shr    %cl,%ebp
  803493:	89 e9                	mov    %ebp,%ecx
  803495:	09 f1                	or     %esi,%ecx
  803497:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80349b:	89 f9                	mov    %edi,%ecx
  80349d:	d3 e0                	shl    %cl,%eax
  80349f:	89 c5                	mov    %eax,%ebp
  8034a1:	89 d6                	mov    %edx,%esi
  8034a3:	88 d9                	mov    %bl,%cl
  8034a5:	d3 ee                	shr    %cl,%esi
  8034a7:	89 f9                	mov    %edi,%ecx
  8034a9:	d3 e2                	shl    %cl,%edx
  8034ab:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034af:	88 d9                	mov    %bl,%cl
  8034b1:	d3 e8                	shr    %cl,%eax
  8034b3:	09 c2                	or     %eax,%edx
  8034b5:	89 d0                	mov    %edx,%eax
  8034b7:	89 f2                	mov    %esi,%edx
  8034b9:	f7 74 24 0c          	divl   0xc(%esp)
  8034bd:	89 d6                	mov    %edx,%esi
  8034bf:	89 c3                	mov    %eax,%ebx
  8034c1:	f7 e5                	mul    %ebp
  8034c3:	39 d6                	cmp    %edx,%esi
  8034c5:	72 19                	jb     8034e0 <__udivdi3+0xfc>
  8034c7:	74 0b                	je     8034d4 <__udivdi3+0xf0>
  8034c9:	89 d8                	mov    %ebx,%eax
  8034cb:	31 ff                	xor    %edi,%edi
  8034cd:	e9 58 ff ff ff       	jmp    80342a <__udivdi3+0x46>
  8034d2:	66 90                	xchg   %ax,%ax
  8034d4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8034d8:	89 f9                	mov    %edi,%ecx
  8034da:	d3 e2                	shl    %cl,%edx
  8034dc:	39 c2                	cmp    %eax,%edx
  8034de:	73 e9                	jae    8034c9 <__udivdi3+0xe5>
  8034e0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8034e3:	31 ff                	xor    %edi,%edi
  8034e5:	e9 40 ff ff ff       	jmp    80342a <__udivdi3+0x46>
  8034ea:	66 90                	xchg   %ax,%ax
  8034ec:	31 c0                	xor    %eax,%eax
  8034ee:	e9 37 ff ff ff       	jmp    80342a <__udivdi3+0x46>
  8034f3:	90                   	nop

008034f4 <__umoddi3>:
  8034f4:	55                   	push   %ebp
  8034f5:	57                   	push   %edi
  8034f6:	56                   	push   %esi
  8034f7:	53                   	push   %ebx
  8034f8:	83 ec 1c             	sub    $0x1c,%esp
  8034fb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8034ff:	8b 74 24 34          	mov    0x34(%esp),%esi
  803503:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803507:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80350b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80350f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803513:	89 f3                	mov    %esi,%ebx
  803515:	89 fa                	mov    %edi,%edx
  803517:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80351b:	89 34 24             	mov    %esi,(%esp)
  80351e:	85 c0                	test   %eax,%eax
  803520:	75 1a                	jne    80353c <__umoddi3+0x48>
  803522:	39 f7                	cmp    %esi,%edi
  803524:	0f 86 a2 00 00 00    	jbe    8035cc <__umoddi3+0xd8>
  80352a:	89 c8                	mov    %ecx,%eax
  80352c:	89 f2                	mov    %esi,%edx
  80352e:	f7 f7                	div    %edi
  803530:	89 d0                	mov    %edx,%eax
  803532:	31 d2                	xor    %edx,%edx
  803534:	83 c4 1c             	add    $0x1c,%esp
  803537:	5b                   	pop    %ebx
  803538:	5e                   	pop    %esi
  803539:	5f                   	pop    %edi
  80353a:	5d                   	pop    %ebp
  80353b:	c3                   	ret    
  80353c:	39 f0                	cmp    %esi,%eax
  80353e:	0f 87 ac 00 00 00    	ja     8035f0 <__umoddi3+0xfc>
  803544:	0f bd e8             	bsr    %eax,%ebp
  803547:	83 f5 1f             	xor    $0x1f,%ebp
  80354a:	0f 84 ac 00 00 00    	je     8035fc <__umoddi3+0x108>
  803550:	bf 20 00 00 00       	mov    $0x20,%edi
  803555:	29 ef                	sub    %ebp,%edi
  803557:	89 fe                	mov    %edi,%esi
  803559:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80355d:	89 e9                	mov    %ebp,%ecx
  80355f:	d3 e0                	shl    %cl,%eax
  803561:	89 d7                	mov    %edx,%edi
  803563:	89 f1                	mov    %esi,%ecx
  803565:	d3 ef                	shr    %cl,%edi
  803567:	09 c7                	or     %eax,%edi
  803569:	89 e9                	mov    %ebp,%ecx
  80356b:	d3 e2                	shl    %cl,%edx
  80356d:	89 14 24             	mov    %edx,(%esp)
  803570:	89 d8                	mov    %ebx,%eax
  803572:	d3 e0                	shl    %cl,%eax
  803574:	89 c2                	mov    %eax,%edx
  803576:	8b 44 24 08          	mov    0x8(%esp),%eax
  80357a:	d3 e0                	shl    %cl,%eax
  80357c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803580:	8b 44 24 08          	mov    0x8(%esp),%eax
  803584:	89 f1                	mov    %esi,%ecx
  803586:	d3 e8                	shr    %cl,%eax
  803588:	09 d0                	or     %edx,%eax
  80358a:	d3 eb                	shr    %cl,%ebx
  80358c:	89 da                	mov    %ebx,%edx
  80358e:	f7 f7                	div    %edi
  803590:	89 d3                	mov    %edx,%ebx
  803592:	f7 24 24             	mull   (%esp)
  803595:	89 c6                	mov    %eax,%esi
  803597:	89 d1                	mov    %edx,%ecx
  803599:	39 d3                	cmp    %edx,%ebx
  80359b:	0f 82 87 00 00 00    	jb     803628 <__umoddi3+0x134>
  8035a1:	0f 84 91 00 00 00    	je     803638 <__umoddi3+0x144>
  8035a7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8035ab:	29 f2                	sub    %esi,%edx
  8035ad:	19 cb                	sbb    %ecx,%ebx
  8035af:	89 d8                	mov    %ebx,%eax
  8035b1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8035b5:	d3 e0                	shl    %cl,%eax
  8035b7:	89 e9                	mov    %ebp,%ecx
  8035b9:	d3 ea                	shr    %cl,%edx
  8035bb:	09 d0                	or     %edx,%eax
  8035bd:	89 e9                	mov    %ebp,%ecx
  8035bf:	d3 eb                	shr    %cl,%ebx
  8035c1:	89 da                	mov    %ebx,%edx
  8035c3:	83 c4 1c             	add    $0x1c,%esp
  8035c6:	5b                   	pop    %ebx
  8035c7:	5e                   	pop    %esi
  8035c8:	5f                   	pop    %edi
  8035c9:	5d                   	pop    %ebp
  8035ca:	c3                   	ret    
  8035cb:	90                   	nop
  8035cc:	89 fd                	mov    %edi,%ebp
  8035ce:	85 ff                	test   %edi,%edi
  8035d0:	75 0b                	jne    8035dd <__umoddi3+0xe9>
  8035d2:	b8 01 00 00 00       	mov    $0x1,%eax
  8035d7:	31 d2                	xor    %edx,%edx
  8035d9:	f7 f7                	div    %edi
  8035db:	89 c5                	mov    %eax,%ebp
  8035dd:	89 f0                	mov    %esi,%eax
  8035df:	31 d2                	xor    %edx,%edx
  8035e1:	f7 f5                	div    %ebp
  8035e3:	89 c8                	mov    %ecx,%eax
  8035e5:	f7 f5                	div    %ebp
  8035e7:	89 d0                	mov    %edx,%eax
  8035e9:	e9 44 ff ff ff       	jmp    803532 <__umoddi3+0x3e>
  8035ee:	66 90                	xchg   %ax,%ax
  8035f0:	89 c8                	mov    %ecx,%eax
  8035f2:	89 f2                	mov    %esi,%edx
  8035f4:	83 c4 1c             	add    $0x1c,%esp
  8035f7:	5b                   	pop    %ebx
  8035f8:	5e                   	pop    %esi
  8035f9:	5f                   	pop    %edi
  8035fa:	5d                   	pop    %ebp
  8035fb:	c3                   	ret    
  8035fc:	3b 04 24             	cmp    (%esp),%eax
  8035ff:	72 06                	jb     803607 <__umoddi3+0x113>
  803601:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803605:	77 0f                	ja     803616 <__umoddi3+0x122>
  803607:	89 f2                	mov    %esi,%edx
  803609:	29 f9                	sub    %edi,%ecx
  80360b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80360f:	89 14 24             	mov    %edx,(%esp)
  803612:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803616:	8b 44 24 04          	mov    0x4(%esp),%eax
  80361a:	8b 14 24             	mov    (%esp),%edx
  80361d:	83 c4 1c             	add    $0x1c,%esp
  803620:	5b                   	pop    %ebx
  803621:	5e                   	pop    %esi
  803622:	5f                   	pop    %edi
  803623:	5d                   	pop    %ebp
  803624:	c3                   	ret    
  803625:	8d 76 00             	lea    0x0(%esi),%esi
  803628:	2b 04 24             	sub    (%esp),%eax
  80362b:	19 fa                	sbb    %edi,%edx
  80362d:	89 d1                	mov    %edx,%ecx
  80362f:	89 c6                	mov    %eax,%esi
  803631:	e9 71 ff ff ff       	jmp    8035a7 <__umoddi3+0xb3>
  803636:	66 90                	xchg   %ax,%ax
  803638:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80363c:	72 ea                	jb     803628 <__umoddi3+0x134>
  80363e:	89 d9                	mov    %ebx,%ecx
  803640:	e9 62 ff ff ff       	jmp    8035a7 <__umoddi3+0xb3>
