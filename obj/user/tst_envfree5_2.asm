
obj/user/tst_envfree5_2:     file format elf32-i386


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
  800031:	e8 4b 01 00 00       	call   800181 <libmain>
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
	// Testing removing the shared variables
	// Testing scenario 5_2: Kill programs have already shared variables and they free it [include scenario 5_1]
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	6a 01                	push   $0x1
  800043:	6a 04                	push   $0x4
  800045:	68 80 36 80 00       	push   $0x803680
  80004a:	e8 f2 14 00 00       	call   801541 <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*numOfFinished = 0 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int freeFrames_before = sys_calculate_free_frames() ;
  80005e:	e8 43 17 00 00       	call   8017a6 <sys_calculate_free_frames>
  800063:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800066:	e8 db 17 00 00       	call   801846 <sys_pf_calculate_allocated_pages>
  80006b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80006e:	83 ec 08             	sub    $0x8,%esp
  800071:	ff 75 f0             	pushl  -0x10(%ebp)
  800074:	68 90 36 80 00       	push   $0x803690
  800079:	e8 f3 04 00 00       	call   800571 <cprintf>
  80007e:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tshr4", 2000,100, 50);
  800081:	6a 32                	push   $0x32
  800083:	6a 64                	push   $0x64
  800085:	68 d0 07 00 00       	push   $0x7d0
  80008a:	68 c3 36 80 00       	push   $0x8036c3
  80008f:	e8 84 19 00 00       	call   801a18 <sys_create_env>
  800094:	83 c4 10             	add    $0x10,%esp
  800097:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int32 envIdProcessB = sys_create_env("ef_tshr5", 2000,100, 50);
  80009a:	6a 32                	push   $0x32
  80009c:	6a 64                	push   $0x64
  80009e:	68 d0 07 00 00       	push   $0x7d0
  8000a3:	68 cc 36 80 00       	push   $0x8036cc
  8000a8:	e8 6b 19 00 00       	call   801a18 <sys_create_env>
  8000ad:	83 c4 10             	add    $0x10,%esp
  8000b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	sys_run_env(envIdProcessA);
  8000b3:	83 ec 0c             	sub    $0xc,%esp
  8000b6:	ff 75 e8             	pushl  -0x18(%ebp)
  8000b9:	e8 78 19 00 00       	call   801a36 <sys_run_env>
  8000be:	83 c4 10             	add    $0x10,%esp
	env_sleep(15000);
  8000c1:	83 ec 0c             	sub    $0xc,%esp
  8000c4:	68 98 3a 00 00       	push   $0x3a98
  8000c9:	e8 9a 32 00 00       	call   803368 <env_sleep>
  8000ce:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  8000d1:	83 ec 0c             	sub    $0xc,%esp
  8000d4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000d7:	e8 5a 19 00 00       	call   801a36 <sys_run_env>
  8000dc:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 2) ;
  8000df:	90                   	nop
  8000e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000e3:	8b 00                	mov    (%eax),%eax
  8000e5:	83 f8 02             	cmp    $0x2,%eax
  8000e8:	75 f6                	jne    8000e0 <_main+0xa8>
	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  8000ea:	e8 b7 16 00 00       	call   8017a6 <sys_calculate_free_frames>
  8000ef:	83 ec 08             	sub    $0x8,%esp
  8000f2:	50                   	push   %eax
  8000f3:	68 d8 36 80 00       	push   $0x8036d8
  8000f8:	e8 74 04 00 00       	call   800571 <cprintf>
  8000fd:	83 c4 10             	add    $0x10,%esp

	sys_destroy_env(envIdProcessA);
  800100:	83 ec 0c             	sub    $0xc,%esp
  800103:	ff 75 e8             	pushl  -0x18(%ebp)
  800106:	e8 47 19 00 00       	call   801a52 <sys_destroy_env>
  80010b:	83 c4 10             	add    $0x10,%esp
	sys_destroy_env(envIdProcessB);
  80010e:	83 ec 0c             	sub    $0xc,%esp
  800111:	ff 75 e4             	pushl  -0x1c(%ebp)
  800114:	e8 39 19 00 00       	call   801a52 <sys_destroy_env>
  800119:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  80011c:	e8 85 16 00 00       	call   8017a6 <sys_calculate_free_frames>
  800121:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  800124:	e8 1d 17 00 00       	call   801846 <sys_pf_calculate_allocated_pages>
  800129:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if ((freeFrames_after - freeFrames_before) != 0) {
  80012c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80012f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800132:	74 27                	je     80015b <_main+0x123>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\n",
  800134:	83 ec 08             	sub    $0x8,%esp
  800137:	ff 75 e0             	pushl  -0x20(%ebp)
  80013a:	68 0c 37 80 00       	push   $0x80370c
  80013f:	e8 2d 04 00 00       	call   800571 <cprintf>
  800144:	83 c4 10             	add    $0x10,%esp
				freeFrames_after);
		panic("env_free() does not work correctly... check it again.");
  800147:	83 ec 04             	sub    $0x4,%esp
  80014a:	68 5c 37 80 00       	push   $0x80375c
  80014f:	6a 23                	push   $0x23
  800151:	68 92 37 80 00       	push   $0x803792
  800156:	e8 62 01 00 00       	call   8002bd <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  80015b:	83 ec 08             	sub    $0x8,%esp
  80015e:	ff 75 e0             	pushl  -0x20(%ebp)
  800161:	68 a8 37 80 00       	push   $0x8037a8
  800166:	e8 06 04 00 00       	call   800571 <cprintf>
  80016b:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 5_2 for envfree completed successfully.\n");
  80016e:	83 ec 0c             	sub    $0xc,%esp
  800171:	68 08 38 80 00       	push   $0x803808
  800176:	e8 f6 03 00 00       	call   800571 <cprintf>
  80017b:	83 c4 10             	add    $0x10,%esp
	return;
  80017e:	90                   	nop
}
  80017f:	c9                   	leave  
  800180:	c3                   	ret    

00800181 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800181:	55                   	push   %ebp
  800182:	89 e5                	mov    %esp,%ebp
  800184:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800187:	e8 fa 18 00 00       	call   801a86 <sys_getenvindex>
  80018c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80018f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800192:	89 d0                	mov    %edx,%eax
  800194:	c1 e0 03             	shl    $0x3,%eax
  800197:	01 d0                	add    %edx,%eax
  800199:	01 c0                	add    %eax,%eax
  80019b:	01 d0                	add    %edx,%eax
  80019d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001a4:	01 d0                	add    %edx,%eax
  8001a6:	c1 e0 04             	shl    $0x4,%eax
  8001a9:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001ae:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001b3:	a1 20 50 80 00       	mov    0x805020,%eax
  8001b8:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8001be:	84 c0                	test   %al,%al
  8001c0:	74 0f                	je     8001d1 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8001c2:	a1 20 50 80 00       	mov    0x805020,%eax
  8001c7:	05 5c 05 00 00       	add    $0x55c,%eax
  8001cc:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001d1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001d5:	7e 0a                	jle    8001e1 <libmain+0x60>
		binaryname = argv[0];
  8001d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001da:	8b 00                	mov    (%eax),%eax
  8001dc:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8001e1:	83 ec 08             	sub    $0x8,%esp
  8001e4:	ff 75 0c             	pushl  0xc(%ebp)
  8001e7:	ff 75 08             	pushl  0x8(%ebp)
  8001ea:	e8 49 fe ff ff       	call   800038 <_main>
  8001ef:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001f2:	e8 9c 16 00 00       	call   801893 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001f7:	83 ec 0c             	sub    $0xc,%esp
  8001fa:	68 6c 38 80 00       	push   $0x80386c
  8001ff:	e8 6d 03 00 00       	call   800571 <cprintf>
  800204:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800207:	a1 20 50 80 00       	mov    0x805020,%eax
  80020c:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800212:	a1 20 50 80 00       	mov    0x805020,%eax
  800217:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80021d:	83 ec 04             	sub    $0x4,%esp
  800220:	52                   	push   %edx
  800221:	50                   	push   %eax
  800222:	68 94 38 80 00       	push   $0x803894
  800227:	e8 45 03 00 00       	call   800571 <cprintf>
  80022c:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80022f:	a1 20 50 80 00       	mov    0x805020,%eax
  800234:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80023a:	a1 20 50 80 00       	mov    0x805020,%eax
  80023f:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800245:	a1 20 50 80 00       	mov    0x805020,%eax
  80024a:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800250:	51                   	push   %ecx
  800251:	52                   	push   %edx
  800252:	50                   	push   %eax
  800253:	68 bc 38 80 00       	push   $0x8038bc
  800258:	e8 14 03 00 00       	call   800571 <cprintf>
  80025d:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800260:	a1 20 50 80 00       	mov    0x805020,%eax
  800265:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80026b:	83 ec 08             	sub    $0x8,%esp
  80026e:	50                   	push   %eax
  80026f:	68 14 39 80 00       	push   $0x803914
  800274:	e8 f8 02 00 00       	call   800571 <cprintf>
  800279:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80027c:	83 ec 0c             	sub    $0xc,%esp
  80027f:	68 6c 38 80 00       	push   $0x80386c
  800284:	e8 e8 02 00 00       	call   800571 <cprintf>
  800289:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80028c:	e8 1c 16 00 00       	call   8018ad <sys_enable_interrupt>

	// exit gracefully
	exit();
  800291:	e8 19 00 00 00       	call   8002af <exit>
}
  800296:	90                   	nop
  800297:	c9                   	leave  
  800298:	c3                   	ret    

00800299 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800299:	55                   	push   %ebp
  80029a:	89 e5                	mov    %esp,%ebp
  80029c:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80029f:	83 ec 0c             	sub    $0xc,%esp
  8002a2:	6a 00                	push   $0x0
  8002a4:	e8 a9 17 00 00       	call   801a52 <sys_destroy_env>
  8002a9:	83 c4 10             	add    $0x10,%esp
}
  8002ac:	90                   	nop
  8002ad:	c9                   	leave  
  8002ae:	c3                   	ret    

008002af <exit>:

void
exit(void)
{
  8002af:	55                   	push   %ebp
  8002b0:	89 e5                	mov    %esp,%ebp
  8002b2:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002b5:	e8 fe 17 00 00       	call   801ab8 <sys_exit_env>
}
  8002ba:	90                   	nop
  8002bb:	c9                   	leave  
  8002bc:	c3                   	ret    

008002bd <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002bd:	55                   	push   %ebp
  8002be:	89 e5                	mov    %esp,%ebp
  8002c0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002c3:	8d 45 10             	lea    0x10(%ebp),%eax
  8002c6:	83 c0 04             	add    $0x4,%eax
  8002c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002cc:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8002d1:	85 c0                	test   %eax,%eax
  8002d3:	74 16                	je     8002eb <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002d5:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8002da:	83 ec 08             	sub    $0x8,%esp
  8002dd:	50                   	push   %eax
  8002de:	68 28 39 80 00       	push   $0x803928
  8002e3:	e8 89 02 00 00       	call   800571 <cprintf>
  8002e8:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002eb:	a1 00 50 80 00       	mov    0x805000,%eax
  8002f0:	ff 75 0c             	pushl  0xc(%ebp)
  8002f3:	ff 75 08             	pushl  0x8(%ebp)
  8002f6:	50                   	push   %eax
  8002f7:	68 2d 39 80 00       	push   $0x80392d
  8002fc:	e8 70 02 00 00       	call   800571 <cprintf>
  800301:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800304:	8b 45 10             	mov    0x10(%ebp),%eax
  800307:	83 ec 08             	sub    $0x8,%esp
  80030a:	ff 75 f4             	pushl  -0xc(%ebp)
  80030d:	50                   	push   %eax
  80030e:	e8 f3 01 00 00       	call   800506 <vcprintf>
  800313:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800316:	83 ec 08             	sub    $0x8,%esp
  800319:	6a 00                	push   $0x0
  80031b:	68 49 39 80 00       	push   $0x803949
  800320:	e8 e1 01 00 00       	call   800506 <vcprintf>
  800325:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800328:	e8 82 ff ff ff       	call   8002af <exit>

	// should not return here
	while (1) ;
  80032d:	eb fe                	jmp    80032d <_panic+0x70>

0080032f <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80032f:	55                   	push   %ebp
  800330:	89 e5                	mov    %esp,%ebp
  800332:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800335:	a1 20 50 80 00       	mov    0x805020,%eax
  80033a:	8b 50 74             	mov    0x74(%eax),%edx
  80033d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800340:	39 c2                	cmp    %eax,%edx
  800342:	74 14                	je     800358 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800344:	83 ec 04             	sub    $0x4,%esp
  800347:	68 4c 39 80 00       	push   $0x80394c
  80034c:	6a 26                	push   $0x26
  80034e:	68 98 39 80 00       	push   $0x803998
  800353:	e8 65 ff ff ff       	call   8002bd <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800358:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80035f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800366:	e9 c2 00 00 00       	jmp    80042d <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80036b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80036e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800375:	8b 45 08             	mov    0x8(%ebp),%eax
  800378:	01 d0                	add    %edx,%eax
  80037a:	8b 00                	mov    (%eax),%eax
  80037c:	85 c0                	test   %eax,%eax
  80037e:	75 08                	jne    800388 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800380:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800383:	e9 a2 00 00 00       	jmp    80042a <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800388:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80038f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800396:	eb 69                	jmp    800401 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800398:	a1 20 50 80 00       	mov    0x805020,%eax
  80039d:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003a3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003a6:	89 d0                	mov    %edx,%eax
  8003a8:	01 c0                	add    %eax,%eax
  8003aa:	01 d0                	add    %edx,%eax
  8003ac:	c1 e0 03             	shl    $0x3,%eax
  8003af:	01 c8                	add    %ecx,%eax
  8003b1:	8a 40 04             	mov    0x4(%eax),%al
  8003b4:	84 c0                	test   %al,%al
  8003b6:	75 46                	jne    8003fe <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003b8:	a1 20 50 80 00       	mov    0x805020,%eax
  8003bd:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003c3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003c6:	89 d0                	mov    %edx,%eax
  8003c8:	01 c0                	add    %eax,%eax
  8003ca:	01 d0                	add    %edx,%eax
  8003cc:	c1 e0 03             	shl    $0x3,%eax
  8003cf:	01 c8                	add    %ecx,%eax
  8003d1:	8b 00                	mov    (%eax),%eax
  8003d3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003d9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003de:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003e3:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ed:	01 c8                	add    %ecx,%eax
  8003ef:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003f1:	39 c2                	cmp    %eax,%edx
  8003f3:	75 09                	jne    8003fe <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8003f5:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003fc:	eb 12                	jmp    800410 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003fe:	ff 45 e8             	incl   -0x18(%ebp)
  800401:	a1 20 50 80 00       	mov    0x805020,%eax
  800406:	8b 50 74             	mov    0x74(%eax),%edx
  800409:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80040c:	39 c2                	cmp    %eax,%edx
  80040e:	77 88                	ja     800398 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800410:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800414:	75 14                	jne    80042a <CheckWSWithoutLastIndex+0xfb>
			panic(
  800416:	83 ec 04             	sub    $0x4,%esp
  800419:	68 a4 39 80 00       	push   $0x8039a4
  80041e:	6a 3a                	push   $0x3a
  800420:	68 98 39 80 00       	push   $0x803998
  800425:	e8 93 fe ff ff       	call   8002bd <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80042a:	ff 45 f0             	incl   -0x10(%ebp)
  80042d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800430:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800433:	0f 8c 32 ff ff ff    	jl     80036b <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800439:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800440:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800447:	eb 26                	jmp    80046f <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800449:	a1 20 50 80 00       	mov    0x805020,%eax
  80044e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800454:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800457:	89 d0                	mov    %edx,%eax
  800459:	01 c0                	add    %eax,%eax
  80045b:	01 d0                	add    %edx,%eax
  80045d:	c1 e0 03             	shl    $0x3,%eax
  800460:	01 c8                	add    %ecx,%eax
  800462:	8a 40 04             	mov    0x4(%eax),%al
  800465:	3c 01                	cmp    $0x1,%al
  800467:	75 03                	jne    80046c <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800469:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80046c:	ff 45 e0             	incl   -0x20(%ebp)
  80046f:	a1 20 50 80 00       	mov    0x805020,%eax
  800474:	8b 50 74             	mov    0x74(%eax),%edx
  800477:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80047a:	39 c2                	cmp    %eax,%edx
  80047c:	77 cb                	ja     800449 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80047e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800481:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800484:	74 14                	je     80049a <CheckWSWithoutLastIndex+0x16b>
		panic(
  800486:	83 ec 04             	sub    $0x4,%esp
  800489:	68 f8 39 80 00       	push   $0x8039f8
  80048e:	6a 44                	push   $0x44
  800490:	68 98 39 80 00       	push   $0x803998
  800495:	e8 23 fe ff ff       	call   8002bd <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80049a:	90                   	nop
  80049b:	c9                   	leave  
  80049c:	c3                   	ret    

0080049d <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80049d:	55                   	push   %ebp
  80049e:	89 e5                	mov    %esp,%ebp
  8004a0:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8004a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004a6:	8b 00                	mov    (%eax),%eax
  8004a8:	8d 48 01             	lea    0x1(%eax),%ecx
  8004ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004ae:	89 0a                	mov    %ecx,(%edx)
  8004b0:	8b 55 08             	mov    0x8(%ebp),%edx
  8004b3:	88 d1                	mov    %dl,%cl
  8004b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004b8:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004bf:	8b 00                	mov    (%eax),%eax
  8004c1:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004c6:	75 2c                	jne    8004f4 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8004c8:	a0 24 50 80 00       	mov    0x805024,%al
  8004cd:	0f b6 c0             	movzbl %al,%eax
  8004d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004d3:	8b 12                	mov    (%edx),%edx
  8004d5:	89 d1                	mov    %edx,%ecx
  8004d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004da:	83 c2 08             	add    $0x8,%edx
  8004dd:	83 ec 04             	sub    $0x4,%esp
  8004e0:	50                   	push   %eax
  8004e1:	51                   	push   %ecx
  8004e2:	52                   	push   %edx
  8004e3:	e8 fd 11 00 00       	call   8016e5 <sys_cputs>
  8004e8:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f7:	8b 40 04             	mov    0x4(%eax),%eax
  8004fa:	8d 50 01             	lea    0x1(%eax),%edx
  8004fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800500:	89 50 04             	mov    %edx,0x4(%eax)
}
  800503:	90                   	nop
  800504:	c9                   	leave  
  800505:	c3                   	ret    

00800506 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800506:	55                   	push   %ebp
  800507:	89 e5                	mov    %esp,%ebp
  800509:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80050f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800516:	00 00 00 
	b.cnt = 0;
  800519:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800520:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800523:	ff 75 0c             	pushl  0xc(%ebp)
  800526:	ff 75 08             	pushl  0x8(%ebp)
  800529:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80052f:	50                   	push   %eax
  800530:	68 9d 04 80 00       	push   $0x80049d
  800535:	e8 11 02 00 00       	call   80074b <vprintfmt>
  80053a:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80053d:	a0 24 50 80 00       	mov    0x805024,%al
  800542:	0f b6 c0             	movzbl %al,%eax
  800545:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80054b:	83 ec 04             	sub    $0x4,%esp
  80054e:	50                   	push   %eax
  80054f:	52                   	push   %edx
  800550:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800556:	83 c0 08             	add    $0x8,%eax
  800559:	50                   	push   %eax
  80055a:	e8 86 11 00 00       	call   8016e5 <sys_cputs>
  80055f:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800562:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800569:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80056f:	c9                   	leave  
  800570:	c3                   	ret    

00800571 <cprintf>:

int cprintf(const char *fmt, ...) {
  800571:	55                   	push   %ebp
  800572:	89 e5                	mov    %esp,%ebp
  800574:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800577:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  80057e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800581:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800584:	8b 45 08             	mov    0x8(%ebp),%eax
  800587:	83 ec 08             	sub    $0x8,%esp
  80058a:	ff 75 f4             	pushl  -0xc(%ebp)
  80058d:	50                   	push   %eax
  80058e:	e8 73 ff ff ff       	call   800506 <vcprintf>
  800593:	83 c4 10             	add    $0x10,%esp
  800596:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800599:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80059c:	c9                   	leave  
  80059d:	c3                   	ret    

0080059e <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80059e:	55                   	push   %ebp
  80059f:	89 e5                	mov    %esp,%ebp
  8005a1:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005a4:	e8 ea 12 00 00       	call   801893 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8005a9:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005af:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b2:	83 ec 08             	sub    $0x8,%esp
  8005b5:	ff 75 f4             	pushl  -0xc(%ebp)
  8005b8:	50                   	push   %eax
  8005b9:	e8 48 ff ff ff       	call   800506 <vcprintf>
  8005be:	83 c4 10             	add    $0x10,%esp
  8005c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8005c4:	e8 e4 12 00 00       	call   8018ad <sys_enable_interrupt>
	return cnt;
  8005c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005cc:	c9                   	leave  
  8005cd:	c3                   	ret    

008005ce <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005ce:	55                   	push   %ebp
  8005cf:	89 e5                	mov    %esp,%ebp
  8005d1:	53                   	push   %ebx
  8005d2:	83 ec 14             	sub    $0x14,%esp
  8005d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8005d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005db:	8b 45 14             	mov    0x14(%ebp),%eax
  8005de:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005e1:	8b 45 18             	mov    0x18(%ebp),%eax
  8005e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8005e9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005ec:	77 55                	ja     800643 <printnum+0x75>
  8005ee:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005f1:	72 05                	jb     8005f8 <printnum+0x2a>
  8005f3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005f6:	77 4b                	ja     800643 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005f8:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005fb:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005fe:	8b 45 18             	mov    0x18(%ebp),%eax
  800601:	ba 00 00 00 00       	mov    $0x0,%edx
  800606:	52                   	push   %edx
  800607:	50                   	push   %eax
  800608:	ff 75 f4             	pushl  -0xc(%ebp)
  80060b:	ff 75 f0             	pushl  -0x10(%ebp)
  80060e:	e8 09 2e 00 00       	call   80341c <__udivdi3>
  800613:	83 c4 10             	add    $0x10,%esp
  800616:	83 ec 04             	sub    $0x4,%esp
  800619:	ff 75 20             	pushl  0x20(%ebp)
  80061c:	53                   	push   %ebx
  80061d:	ff 75 18             	pushl  0x18(%ebp)
  800620:	52                   	push   %edx
  800621:	50                   	push   %eax
  800622:	ff 75 0c             	pushl  0xc(%ebp)
  800625:	ff 75 08             	pushl  0x8(%ebp)
  800628:	e8 a1 ff ff ff       	call   8005ce <printnum>
  80062d:	83 c4 20             	add    $0x20,%esp
  800630:	eb 1a                	jmp    80064c <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800632:	83 ec 08             	sub    $0x8,%esp
  800635:	ff 75 0c             	pushl  0xc(%ebp)
  800638:	ff 75 20             	pushl  0x20(%ebp)
  80063b:	8b 45 08             	mov    0x8(%ebp),%eax
  80063e:	ff d0                	call   *%eax
  800640:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800643:	ff 4d 1c             	decl   0x1c(%ebp)
  800646:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80064a:	7f e6                	jg     800632 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80064c:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80064f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800654:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800657:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80065a:	53                   	push   %ebx
  80065b:	51                   	push   %ecx
  80065c:	52                   	push   %edx
  80065d:	50                   	push   %eax
  80065e:	e8 c9 2e 00 00       	call   80352c <__umoddi3>
  800663:	83 c4 10             	add    $0x10,%esp
  800666:	05 74 3c 80 00       	add    $0x803c74,%eax
  80066b:	8a 00                	mov    (%eax),%al
  80066d:	0f be c0             	movsbl %al,%eax
  800670:	83 ec 08             	sub    $0x8,%esp
  800673:	ff 75 0c             	pushl  0xc(%ebp)
  800676:	50                   	push   %eax
  800677:	8b 45 08             	mov    0x8(%ebp),%eax
  80067a:	ff d0                	call   *%eax
  80067c:	83 c4 10             	add    $0x10,%esp
}
  80067f:	90                   	nop
  800680:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800683:	c9                   	leave  
  800684:	c3                   	ret    

00800685 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800685:	55                   	push   %ebp
  800686:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800688:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80068c:	7e 1c                	jle    8006aa <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80068e:	8b 45 08             	mov    0x8(%ebp),%eax
  800691:	8b 00                	mov    (%eax),%eax
  800693:	8d 50 08             	lea    0x8(%eax),%edx
  800696:	8b 45 08             	mov    0x8(%ebp),%eax
  800699:	89 10                	mov    %edx,(%eax)
  80069b:	8b 45 08             	mov    0x8(%ebp),%eax
  80069e:	8b 00                	mov    (%eax),%eax
  8006a0:	83 e8 08             	sub    $0x8,%eax
  8006a3:	8b 50 04             	mov    0x4(%eax),%edx
  8006a6:	8b 00                	mov    (%eax),%eax
  8006a8:	eb 40                	jmp    8006ea <getuint+0x65>
	else if (lflag)
  8006aa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006ae:	74 1e                	je     8006ce <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b3:	8b 00                	mov    (%eax),%eax
  8006b5:	8d 50 04             	lea    0x4(%eax),%edx
  8006b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bb:	89 10                	mov    %edx,(%eax)
  8006bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c0:	8b 00                	mov    (%eax),%eax
  8006c2:	83 e8 04             	sub    $0x4,%eax
  8006c5:	8b 00                	mov    (%eax),%eax
  8006c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8006cc:	eb 1c                	jmp    8006ea <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d1:	8b 00                	mov    (%eax),%eax
  8006d3:	8d 50 04             	lea    0x4(%eax),%edx
  8006d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d9:	89 10                	mov    %edx,(%eax)
  8006db:	8b 45 08             	mov    0x8(%ebp),%eax
  8006de:	8b 00                	mov    (%eax),%eax
  8006e0:	83 e8 04             	sub    $0x4,%eax
  8006e3:	8b 00                	mov    (%eax),%eax
  8006e5:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006ea:	5d                   	pop    %ebp
  8006eb:	c3                   	ret    

008006ec <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006ec:	55                   	push   %ebp
  8006ed:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006ef:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006f3:	7e 1c                	jle    800711 <getint+0x25>
		return va_arg(*ap, long long);
  8006f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f8:	8b 00                	mov    (%eax),%eax
  8006fa:	8d 50 08             	lea    0x8(%eax),%edx
  8006fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800700:	89 10                	mov    %edx,(%eax)
  800702:	8b 45 08             	mov    0x8(%ebp),%eax
  800705:	8b 00                	mov    (%eax),%eax
  800707:	83 e8 08             	sub    $0x8,%eax
  80070a:	8b 50 04             	mov    0x4(%eax),%edx
  80070d:	8b 00                	mov    (%eax),%eax
  80070f:	eb 38                	jmp    800749 <getint+0x5d>
	else if (lflag)
  800711:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800715:	74 1a                	je     800731 <getint+0x45>
		return va_arg(*ap, long);
  800717:	8b 45 08             	mov    0x8(%ebp),%eax
  80071a:	8b 00                	mov    (%eax),%eax
  80071c:	8d 50 04             	lea    0x4(%eax),%edx
  80071f:	8b 45 08             	mov    0x8(%ebp),%eax
  800722:	89 10                	mov    %edx,(%eax)
  800724:	8b 45 08             	mov    0x8(%ebp),%eax
  800727:	8b 00                	mov    (%eax),%eax
  800729:	83 e8 04             	sub    $0x4,%eax
  80072c:	8b 00                	mov    (%eax),%eax
  80072e:	99                   	cltd   
  80072f:	eb 18                	jmp    800749 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800731:	8b 45 08             	mov    0x8(%ebp),%eax
  800734:	8b 00                	mov    (%eax),%eax
  800736:	8d 50 04             	lea    0x4(%eax),%edx
  800739:	8b 45 08             	mov    0x8(%ebp),%eax
  80073c:	89 10                	mov    %edx,(%eax)
  80073e:	8b 45 08             	mov    0x8(%ebp),%eax
  800741:	8b 00                	mov    (%eax),%eax
  800743:	83 e8 04             	sub    $0x4,%eax
  800746:	8b 00                	mov    (%eax),%eax
  800748:	99                   	cltd   
}
  800749:	5d                   	pop    %ebp
  80074a:	c3                   	ret    

0080074b <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80074b:	55                   	push   %ebp
  80074c:	89 e5                	mov    %esp,%ebp
  80074e:	56                   	push   %esi
  80074f:	53                   	push   %ebx
  800750:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800753:	eb 17                	jmp    80076c <vprintfmt+0x21>
			if (ch == '\0')
  800755:	85 db                	test   %ebx,%ebx
  800757:	0f 84 af 03 00 00    	je     800b0c <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80075d:	83 ec 08             	sub    $0x8,%esp
  800760:	ff 75 0c             	pushl  0xc(%ebp)
  800763:	53                   	push   %ebx
  800764:	8b 45 08             	mov    0x8(%ebp),%eax
  800767:	ff d0                	call   *%eax
  800769:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80076c:	8b 45 10             	mov    0x10(%ebp),%eax
  80076f:	8d 50 01             	lea    0x1(%eax),%edx
  800772:	89 55 10             	mov    %edx,0x10(%ebp)
  800775:	8a 00                	mov    (%eax),%al
  800777:	0f b6 d8             	movzbl %al,%ebx
  80077a:	83 fb 25             	cmp    $0x25,%ebx
  80077d:	75 d6                	jne    800755 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80077f:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800783:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80078a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800791:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800798:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80079f:	8b 45 10             	mov    0x10(%ebp),%eax
  8007a2:	8d 50 01             	lea    0x1(%eax),%edx
  8007a5:	89 55 10             	mov    %edx,0x10(%ebp)
  8007a8:	8a 00                	mov    (%eax),%al
  8007aa:	0f b6 d8             	movzbl %al,%ebx
  8007ad:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007b0:	83 f8 55             	cmp    $0x55,%eax
  8007b3:	0f 87 2b 03 00 00    	ja     800ae4 <vprintfmt+0x399>
  8007b9:	8b 04 85 98 3c 80 00 	mov    0x803c98(,%eax,4),%eax
  8007c0:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007c2:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007c6:	eb d7                	jmp    80079f <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007c8:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007cc:	eb d1                	jmp    80079f <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007ce:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007d5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007d8:	89 d0                	mov    %edx,%eax
  8007da:	c1 e0 02             	shl    $0x2,%eax
  8007dd:	01 d0                	add    %edx,%eax
  8007df:	01 c0                	add    %eax,%eax
  8007e1:	01 d8                	add    %ebx,%eax
  8007e3:	83 e8 30             	sub    $0x30,%eax
  8007e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ec:	8a 00                	mov    (%eax),%al
  8007ee:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007f1:	83 fb 2f             	cmp    $0x2f,%ebx
  8007f4:	7e 3e                	jle    800834 <vprintfmt+0xe9>
  8007f6:	83 fb 39             	cmp    $0x39,%ebx
  8007f9:	7f 39                	jg     800834 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007fb:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007fe:	eb d5                	jmp    8007d5 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800800:	8b 45 14             	mov    0x14(%ebp),%eax
  800803:	83 c0 04             	add    $0x4,%eax
  800806:	89 45 14             	mov    %eax,0x14(%ebp)
  800809:	8b 45 14             	mov    0x14(%ebp),%eax
  80080c:	83 e8 04             	sub    $0x4,%eax
  80080f:	8b 00                	mov    (%eax),%eax
  800811:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800814:	eb 1f                	jmp    800835 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800816:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80081a:	79 83                	jns    80079f <vprintfmt+0x54>
				width = 0;
  80081c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800823:	e9 77 ff ff ff       	jmp    80079f <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800828:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80082f:	e9 6b ff ff ff       	jmp    80079f <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800834:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800835:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800839:	0f 89 60 ff ff ff    	jns    80079f <vprintfmt+0x54>
				width = precision, precision = -1;
  80083f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800842:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800845:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80084c:	e9 4e ff ff ff       	jmp    80079f <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800851:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800854:	e9 46 ff ff ff       	jmp    80079f <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800859:	8b 45 14             	mov    0x14(%ebp),%eax
  80085c:	83 c0 04             	add    $0x4,%eax
  80085f:	89 45 14             	mov    %eax,0x14(%ebp)
  800862:	8b 45 14             	mov    0x14(%ebp),%eax
  800865:	83 e8 04             	sub    $0x4,%eax
  800868:	8b 00                	mov    (%eax),%eax
  80086a:	83 ec 08             	sub    $0x8,%esp
  80086d:	ff 75 0c             	pushl  0xc(%ebp)
  800870:	50                   	push   %eax
  800871:	8b 45 08             	mov    0x8(%ebp),%eax
  800874:	ff d0                	call   *%eax
  800876:	83 c4 10             	add    $0x10,%esp
			break;
  800879:	e9 89 02 00 00       	jmp    800b07 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80087e:	8b 45 14             	mov    0x14(%ebp),%eax
  800881:	83 c0 04             	add    $0x4,%eax
  800884:	89 45 14             	mov    %eax,0x14(%ebp)
  800887:	8b 45 14             	mov    0x14(%ebp),%eax
  80088a:	83 e8 04             	sub    $0x4,%eax
  80088d:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80088f:	85 db                	test   %ebx,%ebx
  800891:	79 02                	jns    800895 <vprintfmt+0x14a>
				err = -err;
  800893:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800895:	83 fb 64             	cmp    $0x64,%ebx
  800898:	7f 0b                	jg     8008a5 <vprintfmt+0x15a>
  80089a:	8b 34 9d e0 3a 80 00 	mov    0x803ae0(,%ebx,4),%esi
  8008a1:	85 f6                	test   %esi,%esi
  8008a3:	75 19                	jne    8008be <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008a5:	53                   	push   %ebx
  8008a6:	68 85 3c 80 00       	push   $0x803c85
  8008ab:	ff 75 0c             	pushl  0xc(%ebp)
  8008ae:	ff 75 08             	pushl  0x8(%ebp)
  8008b1:	e8 5e 02 00 00       	call   800b14 <printfmt>
  8008b6:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008b9:	e9 49 02 00 00       	jmp    800b07 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008be:	56                   	push   %esi
  8008bf:	68 8e 3c 80 00       	push   $0x803c8e
  8008c4:	ff 75 0c             	pushl  0xc(%ebp)
  8008c7:	ff 75 08             	pushl  0x8(%ebp)
  8008ca:	e8 45 02 00 00       	call   800b14 <printfmt>
  8008cf:	83 c4 10             	add    $0x10,%esp
			break;
  8008d2:	e9 30 02 00 00       	jmp    800b07 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008da:	83 c0 04             	add    $0x4,%eax
  8008dd:	89 45 14             	mov    %eax,0x14(%ebp)
  8008e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e3:	83 e8 04             	sub    $0x4,%eax
  8008e6:	8b 30                	mov    (%eax),%esi
  8008e8:	85 f6                	test   %esi,%esi
  8008ea:	75 05                	jne    8008f1 <vprintfmt+0x1a6>
				p = "(null)";
  8008ec:	be 91 3c 80 00       	mov    $0x803c91,%esi
			if (width > 0 && padc != '-')
  8008f1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008f5:	7e 6d                	jle    800964 <vprintfmt+0x219>
  8008f7:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008fb:	74 67                	je     800964 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800900:	83 ec 08             	sub    $0x8,%esp
  800903:	50                   	push   %eax
  800904:	56                   	push   %esi
  800905:	e8 0c 03 00 00       	call   800c16 <strnlen>
  80090a:	83 c4 10             	add    $0x10,%esp
  80090d:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800910:	eb 16                	jmp    800928 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800912:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800916:	83 ec 08             	sub    $0x8,%esp
  800919:	ff 75 0c             	pushl  0xc(%ebp)
  80091c:	50                   	push   %eax
  80091d:	8b 45 08             	mov    0x8(%ebp),%eax
  800920:	ff d0                	call   *%eax
  800922:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800925:	ff 4d e4             	decl   -0x1c(%ebp)
  800928:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80092c:	7f e4                	jg     800912 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80092e:	eb 34                	jmp    800964 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800930:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800934:	74 1c                	je     800952 <vprintfmt+0x207>
  800936:	83 fb 1f             	cmp    $0x1f,%ebx
  800939:	7e 05                	jle    800940 <vprintfmt+0x1f5>
  80093b:	83 fb 7e             	cmp    $0x7e,%ebx
  80093e:	7e 12                	jle    800952 <vprintfmt+0x207>
					putch('?', putdat);
  800940:	83 ec 08             	sub    $0x8,%esp
  800943:	ff 75 0c             	pushl  0xc(%ebp)
  800946:	6a 3f                	push   $0x3f
  800948:	8b 45 08             	mov    0x8(%ebp),%eax
  80094b:	ff d0                	call   *%eax
  80094d:	83 c4 10             	add    $0x10,%esp
  800950:	eb 0f                	jmp    800961 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800952:	83 ec 08             	sub    $0x8,%esp
  800955:	ff 75 0c             	pushl  0xc(%ebp)
  800958:	53                   	push   %ebx
  800959:	8b 45 08             	mov    0x8(%ebp),%eax
  80095c:	ff d0                	call   *%eax
  80095e:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800961:	ff 4d e4             	decl   -0x1c(%ebp)
  800964:	89 f0                	mov    %esi,%eax
  800966:	8d 70 01             	lea    0x1(%eax),%esi
  800969:	8a 00                	mov    (%eax),%al
  80096b:	0f be d8             	movsbl %al,%ebx
  80096e:	85 db                	test   %ebx,%ebx
  800970:	74 24                	je     800996 <vprintfmt+0x24b>
  800972:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800976:	78 b8                	js     800930 <vprintfmt+0x1e5>
  800978:	ff 4d e0             	decl   -0x20(%ebp)
  80097b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80097f:	79 af                	jns    800930 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800981:	eb 13                	jmp    800996 <vprintfmt+0x24b>
				putch(' ', putdat);
  800983:	83 ec 08             	sub    $0x8,%esp
  800986:	ff 75 0c             	pushl  0xc(%ebp)
  800989:	6a 20                	push   $0x20
  80098b:	8b 45 08             	mov    0x8(%ebp),%eax
  80098e:	ff d0                	call   *%eax
  800990:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800993:	ff 4d e4             	decl   -0x1c(%ebp)
  800996:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80099a:	7f e7                	jg     800983 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80099c:	e9 66 01 00 00       	jmp    800b07 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009a1:	83 ec 08             	sub    $0x8,%esp
  8009a4:	ff 75 e8             	pushl  -0x18(%ebp)
  8009a7:	8d 45 14             	lea    0x14(%ebp),%eax
  8009aa:	50                   	push   %eax
  8009ab:	e8 3c fd ff ff       	call   8006ec <getint>
  8009b0:	83 c4 10             	add    $0x10,%esp
  8009b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009b6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009bf:	85 d2                	test   %edx,%edx
  8009c1:	79 23                	jns    8009e6 <vprintfmt+0x29b>
				putch('-', putdat);
  8009c3:	83 ec 08             	sub    $0x8,%esp
  8009c6:	ff 75 0c             	pushl  0xc(%ebp)
  8009c9:	6a 2d                	push   $0x2d
  8009cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ce:	ff d0                	call   *%eax
  8009d0:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009d9:	f7 d8                	neg    %eax
  8009db:	83 d2 00             	adc    $0x0,%edx
  8009de:	f7 da                	neg    %edx
  8009e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009e3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009e6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009ed:	e9 bc 00 00 00       	jmp    800aae <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009f2:	83 ec 08             	sub    $0x8,%esp
  8009f5:	ff 75 e8             	pushl  -0x18(%ebp)
  8009f8:	8d 45 14             	lea    0x14(%ebp),%eax
  8009fb:	50                   	push   %eax
  8009fc:	e8 84 fc ff ff       	call   800685 <getuint>
  800a01:	83 c4 10             	add    $0x10,%esp
  800a04:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a07:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a0a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a11:	e9 98 00 00 00       	jmp    800aae <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a16:	83 ec 08             	sub    $0x8,%esp
  800a19:	ff 75 0c             	pushl  0xc(%ebp)
  800a1c:	6a 58                	push   $0x58
  800a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a21:	ff d0                	call   *%eax
  800a23:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a26:	83 ec 08             	sub    $0x8,%esp
  800a29:	ff 75 0c             	pushl  0xc(%ebp)
  800a2c:	6a 58                	push   $0x58
  800a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a31:	ff d0                	call   *%eax
  800a33:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a36:	83 ec 08             	sub    $0x8,%esp
  800a39:	ff 75 0c             	pushl  0xc(%ebp)
  800a3c:	6a 58                	push   $0x58
  800a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a41:	ff d0                	call   *%eax
  800a43:	83 c4 10             	add    $0x10,%esp
			break;
  800a46:	e9 bc 00 00 00       	jmp    800b07 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a4b:	83 ec 08             	sub    $0x8,%esp
  800a4e:	ff 75 0c             	pushl  0xc(%ebp)
  800a51:	6a 30                	push   $0x30
  800a53:	8b 45 08             	mov    0x8(%ebp),%eax
  800a56:	ff d0                	call   *%eax
  800a58:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a5b:	83 ec 08             	sub    $0x8,%esp
  800a5e:	ff 75 0c             	pushl  0xc(%ebp)
  800a61:	6a 78                	push   $0x78
  800a63:	8b 45 08             	mov    0x8(%ebp),%eax
  800a66:	ff d0                	call   *%eax
  800a68:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a6b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6e:	83 c0 04             	add    $0x4,%eax
  800a71:	89 45 14             	mov    %eax,0x14(%ebp)
  800a74:	8b 45 14             	mov    0x14(%ebp),%eax
  800a77:	83 e8 04             	sub    $0x4,%eax
  800a7a:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a7c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a7f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a86:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a8d:	eb 1f                	jmp    800aae <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a8f:	83 ec 08             	sub    $0x8,%esp
  800a92:	ff 75 e8             	pushl  -0x18(%ebp)
  800a95:	8d 45 14             	lea    0x14(%ebp),%eax
  800a98:	50                   	push   %eax
  800a99:	e8 e7 fb ff ff       	call   800685 <getuint>
  800a9e:	83 c4 10             	add    $0x10,%esp
  800aa1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aa4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800aa7:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800aae:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ab2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ab5:	83 ec 04             	sub    $0x4,%esp
  800ab8:	52                   	push   %edx
  800ab9:	ff 75 e4             	pushl  -0x1c(%ebp)
  800abc:	50                   	push   %eax
  800abd:	ff 75 f4             	pushl  -0xc(%ebp)
  800ac0:	ff 75 f0             	pushl  -0x10(%ebp)
  800ac3:	ff 75 0c             	pushl  0xc(%ebp)
  800ac6:	ff 75 08             	pushl  0x8(%ebp)
  800ac9:	e8 00 fb ff ff       	call   8005ce <printnum>
  800ace:	83 c4 20             	add    $0x20,%esp
			break;
  800ad1:	eb 34                	jmp    800b07 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ad3:	83 ec 08             	sub    $0x8,%esp
  800ad6:	ff 75 0c             	pushl  0xc(%ebp)
  800ad9:	53                   	push   %ebx
  800ada:	8b 45 08             	mov    0x8(%ebp),%eax
  800add:	ff d0                	call   *%eax
  800adf:	83 c4 10             	add    $0x10,%esp
			break;
  800ae2:	eb 23                	jmp    800b07 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ae4:	83 ec 08             	sub    $0x8,%esp
  800ae7:	ff 75 0c             	pushl  0xc(%ebp)
  800aea:	6a 25                	push   $0x25
  800aec:	8b 45 08             	mov    0x8(%ebp),%eax
  800aef:	ff d0                	call   *%eax
  800af1:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800af4:	ff 4d 10             	decl   0x10(%ebp)
  800af7:	eb 03                	jmp    800afc <vprintfmt+0x3b1>
  800af9:	ff 4d 10             	decl   0x10(%ebp)
  800afc:	8b 45 10             	mov    0x10(%ebp),%eax
  800aff:	48                   	dec    %eax
  800b00:	8a 00                	mov    (%eax),%al
  800b02:	3c 25                	cmp    $0x25,%al
  800b04:	75 f3                	jne    800af9 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800b06:	90                   	nop
		}
	}
  800b07:	e9 47 fc ff ff       	jmp    800753 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b0c:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b0d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b10:	5b                   	pop    %ebx
  800b11:	5e                   	pop    %esi
  800b12:	5d                   	pop    %ebp
  800b13:	c3                   	ret    

00800b14 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b14:	55                   	push   %ebp
  800b15:	89 e5                	mov    %esp,%ebp
  800b17:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b1a:	8d 45 10             	lea    0x10(%ebp),%eax
  800b1d:	83 c0 04             	add    $0x4,%eax
  800b20:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b23:	8b 45 10             	mov    0x10(%ebp),%eax
  800b26:	ff 75 f4             	pushl  -0xc(%ebp)
  800b29:	50                   	push   %eax
  800b2a:	ff 75 0c             	pushl  0xc(%ebp)
  800b2d:	ff 75 08             	pushl  0x8(%ebp)
  800b30:	e8 16 fc ff ff       	call   80074b <vprintfmt>
  800b35:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b38:	90                   	nop
  800b39:	c9                   	leave  
  800b3a:	c3                   	ret    

00800b3b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b3b:	55                   	push   %ebp
  800b3c:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b41:	8b 40 08             	mov    0x8(%eax),%eax
  800b44:	8d 50 01             	lea    0x1(%eax),%edx
  800b47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4a:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b50:	8b 10                	mov    (%eax),%edx
  800b52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b55:	8b 40 04             	mov    0x4(%eax),%eax
  800b58:	39 c2                	cmp    %eax,%edx
  800b5a:	73 12                	jae    800b6e <sprintputch+0x33>
		*b->buf++ = ch;
  800b5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5f:	8b 00                	mov    (%eax),%eax
  800b61:	8d 48 01             	lea    0x1(%eax),%ecx
  800b64:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b67:	89 0a                	mov    %ecx,(%edx)
  800b69:	8b 55 08             	mov    0x8(%ebp),%edx
  800b6c:	88 10                	mov    %dl,(%eax)
}
  800b6e:	90                   	nop
  800b6f:	5d                   	pop    %ebp
  800b70:	c3                   	ret    

00800b71 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b71:	55                   	push   %ebp
  800b72:	89 e5                	mov    %esp,%ebp
  800b74:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b77:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b80:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b83:	8b 45 08             	mov    0x8(%ebp),%eax
  800b86:	01 d0                	add    %edx,%eax
  800b88:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b8b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b92:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b96:	74 06                	je     800b9e <vsnprintf+0x2d>
  800b98:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b9c:	7f 07                	jg     800ba5 <vsnprintf+0x34>
		return -E_INVAL;
  800b9e:	b8 03 00 00 00       	mov    $0x3,%eax
  800ba3:	eb 20                	jmp    800bc5 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ba5:	ff 75 14             	pushl  0x14(%ebp)
  800ba8:	ff 75 10             	pushl  0x10(%ebp)
  800bab:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bae:	50                   	push   %eax
  800baf:	68 3b 0b 80 00       	push   $0x800b3b
  800bb4:	e8 92 fb ff ff       	call   80074b <vprintfmt>
  800bb9:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800bbc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bbf:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800bc5:	c9                   	leave  
  800bc6:	c3                   	ret    

00800bc7 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bc7:	55                   	push   %ebp
  800bc8:	89 e5                	mov    %esp,%ebp
  800bca:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bcd:	8d 45 10             	lea    0x10(%ebp),%eax
  800bd0:	83 c0 04             	add    $0x4,%eax
  800bd3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800bd6:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd9:	ff 75 f4             	pushl  -0xc(%ebp)
  800bdc:	50                   	push   %eax
  800bdd:	ff 75 0c             	pushl  0xc(%ebp)
  800be0:	ff 75 08             	pushl  0x8(%ebp)
  800be3:	e8 89 ff ff ff       	call   800b71 <vsnprintf>
  800be8:	83 c4 10             	add    $0x10,%esp
  800beb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bee:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bf1:	c9                   	leave  
  800bf2:	c3                   	ret    

00800bf3 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800bf3:	55                   	push   %ebp
  800bf4:	89 e5                	mov    %esp,%ebp
  800bf6:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bf9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c00:	eb 06                	jmp    800c08 <strlen+0x15>
		n++;
  800c02:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c05:	ff 45 08             	incl   0x8(%ebp)
  800c08:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0b:	8a 00                	mov    (%eax),%al
  800c0d:	84 c0                	test   %al,%al
  800c0f:	75 f1                	jne    800c02 <strlen+0xf>
		n++;
	return n;
  800c11:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c14:	c9                   	leave  
  800c15:	c3                   	ret    

00800c16 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c16:	55                   	push   %ebp
  800c17:	89 e5                	mov    %esp,%ebp
  800c19:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c1c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c23:	eb 09                	jmp    800c2e <strnlen+0x18>
		n++;
  800c25:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c28:	ff 45 08             	incl   0x8(%ebp)
  800c2b:	ff 4d 0c             	decl   0xc(%ebp)
  800c2e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c32:	74 09                	je     800c3d <strnlen+0x27>
  800c34:	8b 45 08             	mov    0x8(%ebp),%eax
  800c37:	8a 00                	mov    (%eax),%al
  800c39:	84 c0                	test   %al,%al
  800c3b:	75 e8                	jne    800c25 <strnlen+0xf>
		n++;
	return n;
  800c3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c40:	c9                   	leave  
  800c41:	c3                   	ret    

00800c42 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c42:	55                   	push   %ebp
  800c43:	89 e5                	mov    %esp,%ebp
  800c45:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c48:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c4e:	90                   	nop
  800c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c52:	8d 50 01             	lea    0x1(%eax),%edx
  800c55:	89 55 08             	mov    %edx,0x8(%ebp)
  800c58:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c5b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c5e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c61:	8a 12                	mov    (%edx),%dl
  800c63:	88 10                	mov    %dl,(%eax)
  800c65:	8a 00                	mov    (%eax),%al
  800c67:	84 c0                	test   %al,%al
  800c69:	75 e4                	jne    800c4f <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c6b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c6e:	c9                   	leave  
  800c6f:	c3                   	ret    

00800c70 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c70:	55                   	push   %ebp
  800c71:	89 e5                	mov    %esp,%ebp
  800c73:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c76:	8b 45 08             	mov    0x8(%ebp),%eax
  800c79:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c7c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c83:	eb 1f                	jmp    800ca4 <strncpy+0x34>
		*dst++ = *src;
  800c85:	8b 45 08             	mov    0x8(%ebp),%eax
  800c88:	8d 50 01             	lea    0x1(%eax),%edx
  800c8b:	89 55 08             	mov    %edx,0x8(%ebp)
  800c8e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c91:	8a 12                	mov    (%edx),%dl
  800c93:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c95:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c98:	8a 00                	mov    (%eax),%al
  800c9a:	84 c0                	test   %al,%al
  800c9c:	74 03                	je     800ca1 <strncpy+0x31>
			src++;
  800c9e:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ca1:	ff 45 fc             	incl   -0x4(%ebp)
  800ca4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ca7:	3b 45 10             	cmp    0x10(%ebp),%eax
  800caa:	72 d9                	jb     800c85 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800cac:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800caf:	c9                   	leave  
  800cb0:	c3                   	ret    

00800cb1 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800cb1:	55                   	push   %ebp
  800cb2:	89 e5                	mov    %esp,%ebp
  800cb4:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cba:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800cbd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cc1:	74 30                	je     800cf3 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800cc3:	eb 16                	jmp    800cdb <strlcpy+0x2a>
			*dst++ = *src++;
  800cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc8:	8d 50 01             	lea    0x1(%eax),%edx
  800ccb:	89 55 08             	mov    %edx,0x8(%ebp)
  800cce:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cd1:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cd4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cd7:	8a 12                	mov    (%edx),%dl
  800cd9:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cdb:	ff 4d 10             	decl   0x10(%ebp)
  800cde:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ce2:	74 09                	je     800ced <strlcpy+0x3c>
  800ce4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce7:	8a 00                	mov    (%eax),%al
  800ce9:	84 c0                	test   %al,%al
  800ceb:	75 d8                	jne    800cc5 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ced:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf0:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cf3:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cf9:	29 c2                	sub    %eax,%edx
  800cfb:	89 d0                	mov    %edx,%eax
}
  800cfd:	c9                   	leave  
  800cfe:	c3                   	ret    

00800cff <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cff:	55                   	push   %ebp
  800d00:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d02:	eb 06                	jmp    800d0a <strcmp+0xb>
		p++, q++;
  800d04:	ff 45 08             	incl   0x8(%ebp)
  800d07:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0d:	8a 00                	mov    (%eax),%al
  800d0f:	84 c0                	test   %al,%al
  800d11:	74 0e                	je     800d21 <strcmp+0x22>
  800d13:	8b 45 08             	mov    0x8(%ebp),%eax
  800d16:	8a 10                	mov    (%eax),%dl
  800d18:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1b:	8a 00                	mov    (%eax),%al
  800d1d:	38 c2                	cmp    %al,%dl
  800d1f:	74 e3                	je     800d04 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d21:	8b 45 08             	mov    0x8(%ebp),%eax
  800d24:	8a 00                	mov    (%eax),%al
  800d26:	0f b6 d0             	movzbl %al,%edx
  800d29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2c:	8a 00                	mov    (%eax),%al
  800d2e:	0f b6 c0             	movzbl %al,%eax
  800d31:	29 c2                	sub    %eax,%edx
  800d33:	89 d0                	mov    %edx,%eax
}
  800d35:	5d                   	pop    %ebp
  800d36:	c3                   	ret    

00800d37 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d37:	55                   	push   %ebp
  800d38:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d3a:	eb 09                	jmp    800d45 <strncmp+0xe>
		n--, p++, q++;
  800d3c:	ff 4d 10             	decl   0x10(%ebp)
  800d3f:	ff 45 08             	incl   0x8(%ebp)
  800d42:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d45:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d49:	74 17                	je     800d62 <strncmp+0x2b>
  800d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4e:	8a 00                	mov    (%eax),%al
  800d50:	84 c0                	test   %al,%al
  800d52:	74 0e                	je     800d62 <strncmp+0x2b>
  800d54:	8b 45 08             	mov    0x8(%ebp),%eax
  800d57:	8a 10                	mov    (%eax),%dl
  800d59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5c:	8a 00                	mov    (%eax),%al
  800d5e:	38 c2                	cmp    %al,%dl
  800d60:	74 da                	je     800d3c <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d62:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d66:	75 07                	jne    800d6f <strncmp+0x38>
		return 0;
  800d68:	b8 00 00 00 00       	mov    $0x0,%eax
  800d6d:	eb 14                	jmp    800d83 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d72:	8a 00                	mov    (%eax),%al
  800d74:	0f b6 d0             	movzbl %al,%edx
  800d77:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7a:	8a 00                	mov    (%eax),%al
  800d7c:	0f b6 c0             	movzbl %al,%eax
  800d7f:	29 c2                	sub    %eax,%edx
  800d81:	89 d0                	mov    %edx,%eax
}
  800d83:	5d                   	pop    %ebp
  800d84:	c3                   	ret    

00800d85 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d85:	55                   	push   %ebp
  800d86:	89 e5                	mov    %esp,%ebp
  800d88:	83 ec 04             	sub    $0x4,%esp
  800d8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d91:	eb 12                	jmp    800da5 <strchr+0x20>
		if (*s == c)
  800d93:	8b 45 08             	mov    0x8(%ebp),%eax
  800d96:	8a 00                	mov    (%eax),%al
  800d98:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d9b:	75 05                	jne    800da2 <strchr+0x1d>
			return (char *) s;
  800d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800da0:	eb 11                	jmp    800db3 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800da2:	ff 45 08             	incl   0x8(%ebp)
  800da5:	8b 45 08             	mov    0x8(%ebp),%eax
  800da8:	8a 00                	mov    (%eax),%al
  800daa:	84 c0                	test   %al,%al
  800dac:	75 e5                	jne    800d93 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800dae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800db3:	c9                   	leave  
  800db4:	c3                   	ret    

00800db5 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800db5:	55                   	push   %ebp
  800db6:	89 e5                	mov    %esp,%ebp
  800db8:	83 ec 04             	sub    $0x4,%esp
  800dbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dbe:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dc1:	eb 0d                	jmp    800dd0 <strfind+0x1b>
		if (*s == c)
  800dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc6:	8a 00                	mov    (%eax),%al
  800dc8:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dcb:	74 0e                	je     800ddb <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800dcd:	ff 45 08             	incl   0x8(%ebp)
  800dd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd3:	8a 00                	mov    (%eax),%al
  800dd5:	84 c0                	test   %al,%al
  800dd7:	75 ea                	jne    800dc3 <strfind+0xe>
  800dd9:	eb 01                	jmp    800ddc <strfind+0x27>
		if (*s == c)
			break;
  800ddb:	90                   	nop
	return (char *) s;
  800ddc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ddf:	c9                   	leave  
  800de0:	c3                   	ret    

00800de1 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800de1:	55                   	push   %ebp
  800de2:	89 e5                	mov    %esp,%ebp
  800de4:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800de7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dea:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800ded:	8b 45 10             	mov    0x10(%ebp),%eax
  800df0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800df3:	eb 0e                	jmp    800e03 <memset+0x22>
		*p++ = c;
  800df5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800df8:	8d 50 01             	lea    0x1(%eax),%edx
  800dfb:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800dfe:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e01:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e03:	ff 4d f8             	decl   -0x8(%ebp)
  800e06:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e0a:	79 e9                	jns    800df5 <memset+0x14>
		*p++ = c;

	return v;
  800e0c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e0f:	c9                   	leave  
  800e10:	c3                   	ret    

00800e11 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e11:	55                   	push   %ebp
  800e12:	89 e5                	mov    %esp,%ebp
  800e14:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e20:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e23:	eb 16                	jmp    800e3b <memcpy+0x2a>
		*d++ = *s++;
  800e25:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e28:	8d 50 01             	lea    0x1(%eax),%edx
  800e2b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e2e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e31:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e34:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e37:	8a 12                	mov    (%edx),%dl
  800e39:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e3b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e3e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e41:	89 55 10             	mov    %edx,0x10(%ebp)
  800e44:	85 c0                	test   %eax,%eax
  800e46:	75 dd                	jne    800e25 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e48:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e4b:	c9                   	leave  
  800e4c:	c3                   	ret    

00800e4d <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e4d:	55                   	push   %ebp
  800e4e:	89 e5                	mov    %esp,%ebp
  800e50:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e53:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e56:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e59:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e62:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e65:	73 50                	jae    800eb7 <memmove+0x6a>
  800e67:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e6a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e6d:	01 d0                	add    %edx,%eax
  800e6f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e72:	76 43                	jbe    800eb7 <memmove+0x6a>
		s += n;
  800e74:	8b 45 10             	mov    0x10(%ebp),%eax
  800e77:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e7a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e7d:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e80:	eb 10                	jmp    800e92 <memmove+0x45>
			*--d = *--s;
  800e82:	ff 4d f8             	decl   -0x8(%ebp)
  800e85:	ff 4d fc             	decl   -0x4(%ebp)
  800e88:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e8b:	8a 10                	mov    (%eax),%dl
  800e8d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e90:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e92:	8b 45 10             	mov    0x10(%ebp),%eax
  800e95:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e98:	89 55 10             	mov    %edx,0x10(%ebp)
  800e9b:	85 c0                	test   %eax,%eax
  800e9d:	75 e3                	jne    800e82 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e9f:	eb 23                	jmp    800ec4 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800ea1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ea4:	8d 50 01             	lea    0x1(%eax),%edx
  800ea7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800eaa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ead:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eb0:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800eb3:	8a 12                	mov    (%edx),%dl
  800eb5:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800eb7:	8b 45 10             	mov    0x10(%ebp),%eax
  800eba:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ebd:	89 55 10             	mov    %edx,0x10(%ebp)
  800ec0:	85 c0                	test   %eax,%eax
  800ec2:	75 dd                	jne    800ea1 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ec4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ec7:	c9                   	leave  
  800ec8:	c3                   	ret    

00800ec9 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ec9:	55                   	push   %ebp
  800eca:	89 e5                	mov    %esp,%ebp
  800ecc:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ecf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ed5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed8:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800edb:	eb 2a                	jmp    800f07 <memcmp+0x3e>
		if (*s1 != *s2)
  800edd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee0:	8a 10                	mov    (%eax),%dl
  800ee2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ee5:	8a 00                	mov    (%eax),%al
  800ee7:	38 c2                	cmp    %al,%dl
  800ee9:	74 16                	je     800f01 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800eeb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eee:	8a 00                	mov    (%eax),%al
  800ef0:	0f b6 d0             	movzbl %al,%edx
  800ef3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ef6:	8a 00                	mov    (%eax),%al
  800ef8:	0f b6 c0             	movzbl %al,%eax
  800efb:	29 c2                	sub    %eax,%edx
  800efd:	89 d0                	mov    %edx,%eax
  800eff:	eb 18                	jmp    800f19 <memcmp+0x50>
		s1++, s2++;
  800f01:	ff 45 fc             	incl   -0x4(%ebp)
  800f04:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f07:	8b 45 10             	mov    0x10(%ebp),%eax
  800f0a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f0d:	89 55 10             	mov    %edx,0x10(%ebp)
  800f10:	85 c0                	test   %eax,%eax
  800f12:	75 c9                	jne    800edd <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f14:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f19:	c9                   	leave  
  800f1a:	c3                   	ret    

00800f1b <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f1b:	55                   	push   %ebp
  800f1c:	89 e5                	mov    %esp,%ebp
  800f1e:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f21:	8b 55 08             	mov    0x8(%ebp),%edx
  800f24:	8b 45 10             	mov    0x10(%ebp),%eax
  800f27:	01 d0                	add    %edx,%eax
  800f29:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f2c:	eb 15                	jmp    800f43 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f31:	8a 00                	mov    (%eax),%al
  800f33:	0f b6 d0             	movzbl %al,%edx
  800f36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f39:	0f b6 c0             	movzbl %al,%eax
  800f3c:	39 c2                	cmp    %eax,%edx
  800f3e:	74 0d                	je     800f4d <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f40:	ff 45 08             	incl   0x8(%ebp)
  800f43:	8b 45 08             	mov    0x8(%ebp),%eax
  800f46:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f49:	72 e3                	jb     800f2e <memfind+0x13>
  800f4b:	eb 01                	jmp    800f4e <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f4d:	90                   	nop
	return (void *) s;
  800f4e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f51:	c9                   	leave  
  800f52:	c3                   	ret    

00800f53 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f53:	55                   	push   %ebp
  800f54:	89 e5                	mov    %esp,%ebp
  800f56:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f59:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f60:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f67:	eb 03                	jmp    800f6c <strtol+0x19>
		s++;
  800f69:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6f:	8a 00                	mov    (%eax),%al
  800f71:	3c 20                	cmp    $0x20,%al
  800f73:	74 f4                	je     800f69 <strtol+0x16>
  800f75:	8b 45 08             	mov    0x8(%ebp),%eax
  800f78:	8a 00                	mov    (%eax),%al
  800f7a:	3c 09                	cmp    $0x9,%al
  800f7c:	74 eb                	je     800f69 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f81:	8a 00                	mov    (%eax),%al
  800f83:	3c 2b                	cmp    $0x2b,%al
  800f85:	75 05                	jne    800f8c <strtol+0x39>
		s++;
  800f87:	ff 45 08             	incl   0x8(%ebp)
  800f8a:	eb 13                	jmp    800f9f <strtol+0x4c>
	else if (*s == '-')
  800f8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8f:	8a 00                	mov    (%eax),%al
  800f91:	3c 2d                	cmp    $0x2d,%al
  800f93:	75 0a                	jne    800f9f <strtol+0x4c>
		s++, neg = 1;
  800f95:	ff 45 08             	incl   0x8(%ebp)
  800f98:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f9f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fa3:	74 06                	je     800fab <strtol+0x58>
  800fa5:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800fa9:	75 20                	jne    800fcb <strtol+0x78>
  800fab:	8b 45 08             	mov    0x8(%ebp),%eax
  800fae:	8a 00                	mov    (%eax),%al
  800fb0:	3c 30                	cmp    $0x30,%al
  800fb2:	75 17                	jne    800fcb <strtol+0x78>
  800fb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb7:	40                   	inc    %eax
  800fb8:	8a 00                	mov    (%eax),%al
  800fba:	3c 78                	cmp    $0x78,%al
  800fbc:	75 0d                	jne    800fcb <strtol+0x78>
		s += 2, base = 16;
  800fbe:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800fc2:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800fc9:	eb 28                	jmp    800ff3 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800fcb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fcf:	75 15                	jne    800fe6 <strtol+0x93>
  800fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd4:	8a 00                	mov    (%eax),%al
  800fd6:	3c 30                	cmp    $0x30,%al
  800fd8:	75 0c                	jne    800fe6 <strtol+0x93>
		s++, base = 8;
  800fda:	ff 45 08             	incl   0x8(%ebp)
  800fdd:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fe4:	eb 0d                	jmp    800ff3 <strtol+0xa0>
	else if (base == 0)
  800fe6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fea:	75 07                	jne    800ff3 <strtol+0xa0>
		base = 10;
  800fec:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ff3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff6:	8a 00                	mov    (%eax),%al
  800ff8:	3c 2f                	cmp    $0x2f,%al
  800ffa:	7e 19                	jle    801015 <strtol+0xc2>
  800ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fff:	8a 00                	mov    (%eax),%al
  801001:	3c 39                	cmp    $0x39,%al
  801003:	7f 10                	jg     801015 <strtol+0xc2>
			dig = *s - '0';
  801005:	8b 45 08             	mov    0x8(%ebp),%eax
  801008:	8a 00                	mov    (%eax),%al
  80100a:	0f be c0             	movsbl %al,%eax
  80100d:	83 e8 30             	sub    $0x30,%eax
  801010:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801013:	eb 42                	jmp    801057 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801015:	8b 45 08             	mov    0x8(%ebp),%eax
  801018:	8a 00                	mov    (%eax),%al
  80101a:	3c 60                	cmp    $0x60,%al
  80101c:	7e 19                	jle    801037 <strtol+0xe4>
  80101e:	8b 45 08             	mov    0x8(%ebp),%eax
  801021:	8a 00                	mov    (%eax),%al
  801023:	3c 7a                	cmp    $0x7a,%al
  801025:	7f 10                	jg     801037 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801027:	8b 45 08             	mov    0x8(%ebp),%eax
  80102a:	8a 00                	mov    (%eax),%al
  80102c:	0f be c0             	movsbl %al,%eax
  80102f:	83 e8 57             	sub    $0x57,%eax
  801032:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801035:	eb 20                	jmp    801057 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801037:	8b 45 08             	mov    0x8(%ebp),%eax
  80103a:	8a 00                	mov    (%eax),%al
  80103c:	3c 40                	cmp    $0x40,%al
  80103e:	7e 39                	jle    801079 <strtol+0x126>
  801040:	8b 45 08             	mov    0x8(%ebp),%eax
  801043:	8a 00                	mov    (%eax),%al
  801045:	3c 5a                	cmp    $0x5a,%al
  801047:	7f 30                	jg     801079 <strtol+0x126>
			dig = *s - 'A' + 10;
  801049:	8b 45 08             	mov    0x8(%ebp),%eax
  80104c:	8a 00                	mov    (%eax),%al
  80104e:	0f be c0             	movsbl %al,%eax
  801051:	83 e8 37             	sub    $0x37,%eax
  801054:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801057:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80105a:	3b 45 10             	cmp    0x10(%ebp),%eax
  80105d:	7d 19                	jge    801078 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80105f:	ff 45 08             	incl   0x8(%ebp)
  801062:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801065:	0f af 45 10          	imul   0x10(%ebp),%eax
  801069:	89 c2                	mov    %eax,%edx
  80106b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80106e:	01 d0                	add    %edx,%eax
  801070:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801073:	e9 7b ff ff ff       	jmp    800ff3 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801078:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801079:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80107d:	74 08                	je     801087 <strtol+0x134>
		*endptr = (char *) s;
  80107f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801082:	8b 55 08             	mov    0x8(%ebp),%edx
  801085:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801087:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80108b:	74 07                	je     801094 <strtol+0x141>
  80108d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801090:	f7 d8                	neg    %eax
  801092:	eb 03                	jmp    801097 <strtol+0x144>
  801094:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801097:	c9                   	leave  
  801098:	c3                   	ret    

00801099 <ltostr>:

void
ltostr(long value, char *str)
{
  801099:	55                   	push   %ebp
  80109a:	89 e5                	mov    %esp,%ebp
  80109c:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80109f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8010a6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8010ad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010b1:	79 13                	jns    8010c6 <ltostr+0x2d>
	{
		neg = 1;
  8010b3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8010ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010bd:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8010c0:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8010c3:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8010c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c9:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010ce:	99                   	cltd   
  8010cf:	f7 f9                	idiv   %ecx
  8010d1:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010d7:	8d 50 01             	lea    0x1(%eax),%edx
  8010da:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010dd:	89 c2                	mov    %eax,%edx
  8010df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e2:	01 d0                	add    %edx,%eax
  8010e4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010e7:	83 c2 30             	add    $0x30,%edx
  8010ea:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010ec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010ef:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010f4:	f7 e9                	imul   %ecx
  8010f6:	c1 fa 02             	sar    $0x2,%edx
  8010f9:	89 c8                	mov    %ecx,%eax
  8010fb:	c1 f8 1f             	sar    $0x1f,%eax
  8010fe:	29 c2                	sub    %eax,%edx
  801100:	89 d0                	mov    %edx,%eax
  801102:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801105:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801108:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80110d:	f7 e9                	imul   %ecx
  80110f:	c1 fa 02             	sar    $0x2,%edx
  801112:	89 c8                	mov    %ecx,%eax
  801114:	c1 f8 1f             	sar    $0x1f,%eax
  801117:	29 c2                	sub    %eax,%edx
  801119:	89 d0                	mov    %edx,%eax
  80111b:	c1 e0 02             	shl    $0x2,%eax
  80111e:	01 d0                	add    %edx,%eax
  801120:	01 c0                	add    %eax,%eax
  801122:	29 c1                	sub    %eax,%ecx
  801124:	89 ca                	mov    %ecx,%edx
  801126:	85 d2                	test   %edx,%edx
  801128:	75 9c                	jne    8010c6 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80112a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801131:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801134:	48                   	dec    %eax
  801135:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801138:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80113c:	74 3d                	je     80117b <ltostr+0xe2>
		start = 1 ;
  80113e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801145:	eb 34                	jmp    80117b <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801147:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80114a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114d:	01 d0                	add    %edx,%eax
  80114f:	8a 00                	mov    (%eax),%al
  801151:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801154:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801157:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115a:	01 c2                	add    %eax,%edx
  80115c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80115f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801162:	01 c8                	add    %ecx,%eax
  801164:	8a 00                	mov    (%eax),%al
  801166:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801168:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80116b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116e:	01 c2                	add    %eax,%edx
  801170:	8a 45 eb             	mov    -0x15(%ebp),%al
  801173:	88 02                	mov    %al,(%edx)
		start++ ;
  801175:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801178:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80117b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80117e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801181:	7c c4                	jl     801147 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801183:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801186:	8b 45 0c             	mov    0xc(%ebp),%eax
  801189:	01 d0                	add    %edx,%eax
  80118b:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80118e:	90                   	nop
  80118f:	c9                   	leave  
  801190:	c3                   	ret    

00801191 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801191:	55                   	push   %ebp
  801192:	89 e5                	mov    %esp,%ebp
  801194:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801197:	ff 75 08             	pushl  0x8(%ebp)
  80119a:	e8 54 fa ff ff       	call   800bf3 <strlen>
  80119f:	83 c4 04             	add    $0x4,%esp
  8011a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8011a5:	ff 75 0c             	pushl  0xc(%ebp)
  8011a8:	e8 46 fa ff ff       	call   800bf3 <strlen>
  8011ad:	83 c4 04             	add    $0x4,%esp
  8011b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8011b3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8011ba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011c1:	eb 17                	jmp    8011da <strcconcat+0x49>
		final[s] = str1[s] ;
  8011c3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c9:	01 c2                	add    %eax,%edx
  8011cb:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d1:	01 c8                	add    %ecx,%eax
  8011d3:	8a 00                	mov    (%eax),%al
  8011d5:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8011d7:	ff 45 fc             	incl   -0x4(%ebp)
  8011da:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011dd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011e0:	7c e1                	jl     8011c3 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011e2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011e9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011f0:	eb 1f                	jmp    801211 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011f5:	8d 50 01             	lea    0x1(%eax),%edx
  8011f8:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011fb:	89 c2                	mov    %eax,%edx
  8011fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801200:	01 c2                	add    %eax,%edx
  801202:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801205:	8b 45 0c             	mov    0xc(%ebp),%eax
  801208:	01 c8                	add    %ecx,%eax
  80120a:	8a 00                	mov    (%eax),%al
  80120c:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80120e:	ff 45 f8             	incl   -0x8(%ebp)
  801211:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801214:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801217:	7c d9                	jl     8011f2 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801219:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80121c:	8b 45 10             	mov    0x10(%ebp),%eax
  80121f:	01 d0                	add    %edx,%eax
  801221:	c6 00 00             	movb   $0x0,(%eax)
}
  801224:	90                   	nop
  801225:	c9                   	leave  
  801226:	c3                   	ret    

00801227 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801227:	55                   	push   %ebp
  801228:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80122a:	8b 45 14             	mov    0x14(%ebp),%eax
  80122d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801233:	8b 45 14             	mov    0x14(%ebp),%eax
  801236:	8b 00                	mov    (%eax),%eax
  801238:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80123f:	8b 45 10             	mov    0x10(%ebp),%eax
  801242:	01 d0                	add    %edx,%eax
  801244:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80124a:	eb 0c                	jmp    801258 <strsplit+0x31>
			*string++ = 0;
  80124c:	8b 45 08             	mov    0x8(%ebp),%eax
  80124f:	8d 50 01             	lea    0x1(%eax),%edx
  801252:	89 55 08             	mov    %edx,0x8(%ebp)
  801255:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801258:	8b 45 08             	mov    0x8(%ebp),%eax
  80125b:	8a 00                	mov    (%eax),%al
  80125d:	84 c0                	test   %al,%al
  80125f:	74 18                	je     801279 <strsplit+0x52>
  801261:	8b 45 08             	mov    0x8(%ebp),%eax
  801264:	8a 00                	mov    (%eax),%al
  801266:	0f be c0             	movsbl %al,%eax
  801269:	50                   	push   %eax
  80126a:	ff 75 0c             	pushl  0xc(%ebp)
  80126d:	e8 13 fb ff ff       	call   800d85 <strchr>
  801272:	83 c4 08             	add    $0x8,%esp
  801275:	85 c0                	test   %eax,%eax
  801277:	75 d3                	jne    80124c <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801279:	8b 45 08             	mov    0x8(%ebp),%eax
  80127c:	8a 00                	mov    (%eax),%al
  80127e:	84 c0                	test   %al,%al
  801280:	74 5a                	je     8012dc <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801282:	8b 45 14             	mov    0x14(%ebp),%eax
  801285:	8b 00                	mov    (%eax),%eax
  801287:	83 f8 0f             	cmp    $0xf,%eax
  80128a:	75 07                	jne    801293 <strsplit+0x6c>
		{
			return 0;
  80128c:	b8 00 00 00 00       	mov    $0x0,%eax
  801291:	eb 66                	jmp    8012f9 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801293:	8b 45 14             	mov    0x14(%ebp),%eax
  801296:	8b 00                	mov    (%eax),%eax
  801298:	8d 48 01             	lea    0x1(%eax),%ecx
  80129b:	8b 55 14             	mov    0x14(%ebp),%edx
  80129e:	89 0a                	mov    %ecx,(%edx)
  8012a0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8012aa:	01 c2                	add    %eax,%edx
  8012ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8012af:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012b1:	eb 03                	jmp    8012b6 <strsplit+0x8f>
			string++;
  8012b3:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b9:	8a 00                	mov    (%eax),%al
  8012bb:	84 c0                	test   %al,%al
  8012bd:	74 8b                	je     80124a <strsplit+0x23>
  8012bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c2:	8a 00                	mov    (%eax),%al
  8012c4:	0f be c0             	movsbl %al,%eax
  8012c7:	50                   	push   %eax
  8012c8:	ff 75 0c             	pushl  0xc(%ebp)
  8012cb:	e8 b5 fa ff ff       	call   800d85 <strchr>
  8012d0:	83 c4 08             	add    $0x8,%esp
  8012d3:	85 c0                	test   %eax,%eax
  8012d5:	74 dc                	je     8012b3 <strsplit+0x8c>
			string++;
	}
  8012d7:	e9 6e ff ff ff       	jmp    80124a <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012dc:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8012e0:	8b 00                	mov    (%eax),%eax
  8012e2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ec:	01 d0                	add    %edx,%eax
  8012ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012f4:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012f9:	c9                   	leave  
  8012fa:	c3                   	ret    

008012fb <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8012fb:	55                   	push   %ebp
  8012fc:	89 e5                	mov    %esp,%ebp
  8012fe:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801301:	a1 04 50 80 00       	mov    0x805004,%eax
  801306:	85 c0                	test   %eax,%eax
  801308:	74 1f                	je     801329 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  80130a:	e8 1d 00 00 00       	call   80132c <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  80130f:	83 ec 0c             	sub    $0xc,%esp
  801312:	68 f0 3d 80 00       	push   $0x803df0
  801317:	e8 55 f2 ff ff       	call   800571 <cprintf>
  80131c:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80131f:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801326:	00 00 00 
	}
}
  801329:	90                   	nop
  80132a:	c9                   	leave  
  80132b:	c3                   	ret    

0080132c <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80132c:	55                   	push   %ebp
  80132d:	89 e5                	mov    %esp,%ebp
  80132f:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	LIST_INIT(&AllocMemBlocksList);
  801332:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801339:	00 00 00 
  80133c:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801343:	00 00 00 
  801346:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  80134d:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801350:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801357:	00 00 00 
  80135a:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801361:	00 00 00 
  801364:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  80136b:	00 00 00 
	uint32 arr_size = 0;
  80136e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	MemBlockNodes  =(struct MemBlock*) USER_DYN_BLKS_ARRAY;
  801375:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  80137c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80137f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801384:	2d 00 10 00 00       	sub    $0x1000,%eax
  801389:	a3 50 50 80 00       	mov    %eax,0x805050
	MAX_MEM_BLOCK_CNT = (USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE;
  80138e:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801395:	00 02 00 
	arr_size =  ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock), PAGE_SIZE);
  801398:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80139f:	a1 20 51 80 00       	mov    0x805120,%eax
  8013a4:	c1 e0 04             	shl    $0x4,%eax
  8013a7:	89 c2                	mov    %eax,%edx
  8013a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013ac:	01 d0                	add    %edx,%eax
  8013ae:	48                   	dec    %eax
  8013af:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8013b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8013ba:	f7 75 ec             	divl   -0x14(%ebp)
  8013bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013c0:	29 d0                	sub    %edx,%eax
  8013c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_USER);
  8013c5:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8013cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013cf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013d4:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013d9:	83 ec 04             	sub    $0x4,%esp
  8013dc:	6a 06                	push   $0x6
  8013de:	ff 75 f4             	pushl  -0xc(%ebp)
  8013e1:	50                   	push   %eax
  8013e2:	e8 42 04 00 00       	call   801829 <sys_allocate_chunk>
  8013e7:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013ea:	a1 20 51 80 00       	mov    0x805120,%eax
  8013ef:	83 ec 0c             	sub    $0xc,%esp
  8013f2:	50                   	push   %eax
  8013f3:	e8 b7 0a 00 00       	call   801eaf <initialize_MemBlocksList>
  8013f8:	83 c4 10             	add    $0x10,%esp
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	struct MemBlock * NewBlock = LIST_FIRST(&AvailableMemBlocksList);
  8013fb:	a1 48 51 80 00       	mov    0x805148,%eax
  801400:	89 45 e0             	mov    %eax,-0x20(%ebp)
	NewBlock->sva = USER_HEAP_START;
  801403:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801406:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	NewBlock->size = (USER_HEAP_MAX-USER_HEAP_START);
  80140d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801410:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	LIST_REMOVE(&AvailableMemBlocksList,NewBlock);
  801417:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80141b:	75 14                	jne    801431 <initialize_dyn_block_system+0x105>
  80141d:	83 ec 04             	sub    $0x4,%esp
  801420:	68 15 3e 80 00       	push   $0x803e15
  801425:	6a 33                	push   $0x33
  801427:	68 33 3e 80 00       	push   $0x803e33
  80142c:	e8 8c ee ff ff       	call   8002bd <_panic>
  801431:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801434:	8b 00                	mov    (%eax),%eax
  801436:	85 c0                	test   %eax,%eax
  801438:	74 10                	je     80144a <initialize_dyn_block_system+0x11e>
  80143a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80143d:	8b 00                	mov    (%eax),%eax
  80143f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801442:	8b 52 04             	mov    0x4(%edx),%edx
  801445:	89 50 04             	mov    %edx,0x4(%eax)
  801448:	eb 0b                	jmp    801455 <initialize_dyn_block_system+0x129>
  80144a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80144d:	8b 40 04             	mov    0x4(%eax),%eax
  801450:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801455:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801458:	8b 40 04             	mov    0x4(%eax),%eax
  80145b:	85 c0                	test   %eax,%eax
  80145d:	74 0f                	je     80146e <initialize_dyn_block_system+0x142>
  80145f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801462:	8b 40 04             	mov    0x4(%eax),%eax
  801465:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801468:	8b 12                	mov    (%edx),%edx
  80146a:	89 10                	mov    %edx,(%eax)
  80146c:	eb 0a                	jmp    801478 <initialize_dyn_block_system+0x14c>
  80146e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801471:	8b 00                	mov    (%eax),%eax
  801473:	a3 48 51 80 00       	mov    %eax,0x805148
  801478:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80147b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801481:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801484:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80148b:	a1 54 51 80 00       	mov    0x805154,%eax
  801490:	48                   	dec    %eax
  801491:	a3 54 51 80 00       	mov    %eax,0x805154
	LIST_INSERT_HEAD(&FreeMemBlocksList, NewBlock);
  801496:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80149a:	75 14                	jne    8014b0 <initialize_dyn_block_system+0x184>
  80149c:	83 ec 04             	sub    $0x4,%esp
  80149f:	68 40 3e 80 00       	push   $0x803e40
  8014a4:	6a 34                	push   $0x34
  8014a6:	68 33 3e 80 00       	push   $0x803e33
  8014ab:	e8 0d ee ff ff       	call   8002bd <_panic>
  8014b0:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8014b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014b9:	89 10                	mov    %edx,(%eax)
  8014bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014be:	8b 00                	mov    (%eax),%eax
  8014c0:	85 c0                	test   %eax,%eax
  8014c2:	74 0d                	je     8014d1 <initialize_dyn_block_system+0x1a5>
  8014c4:	a1 38 51 80 00       	mov    0x805138,%eax
  8014c9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8014cc:	89 50 04             	mov    %edx,0x4(%eax)
  8014cf:	eb 08                	jmp    8014d9 <initialize_dyn_block_system+0x1ad>
  8014d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014d4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8014d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014dc:	a3 38 51 80 00       	mov    %eax,0x805138
  8014e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014e4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8014eb:	a1 44 51 80 00       	mov    0x805144,%eax
  8014f0:	40                   	inc    %eax
  8014f1:	a3 44 51 80 00       	mov    %eax,0x805144
}
  8014f6:	90                   	nop
  8014f7:	c9                   	leave  
  8014f8:	c3                   	ret    

008014f9 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8014f9:	55                   	push   %ebp
  8014fa:	89 e5                	mov    %esp,%ebp
  8014fc:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8014ff:	e8 f7 fd ff ff       	call   8012fb <InitializeUHeap>
	if (size == 0) return NULL ;
  801504:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801508:	75 07                	jne    801511 <malloc+0x18>
  80150a:	b8 00 00 00 00       	mov    $0x0,%eax
  80150f:	eb 14                	jmp    801525 <malloc+0x2c>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801511:	83 ec 04             	sub    $0x4,%esp
  801514:	68 64 3e 80 00       	push   $0x803e64
  801519:	6a 46                	push   $0x46
  80151b:	68 33 3e 80 00       	push   $0x803e33
  801520:	e8 98 ed ff ff       	call   8002bd <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801525:	c9                   	leave  
  801526:	c3                   	ret    

00801527 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801527:	55                   	push   %ebp
  801528:	89 e5                	mov    %esp,%ebp
  80152a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  80152d:	83 ec 04             	sub    $0x4,%esp
  801530:	68 8c 3e 80 00       	push   $0x803e8c
  801535:	6a 61                	push   $0x61
  801537:	68 33 3e 80 00       	push   $0x803e33
  80153c:	e8 7c ed ff ff       	call   8002bd <_panic>

00801541 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801541:	55                   	push   %ebp
  801542:	89 e5                	mov    %esp,%ebp
  801544:	83 ec 38             	sub    $0x38,%esp
  801547:	8b 45 10             	mov    0x10(%ebp),%eax
  80154a:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80154d:	e8 a9 fd ff ff       	call   8012fb <InitializeUHeap>
	if (size == 0) return NULL ;
  801552:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801556:	75 0a                	jne    801562 <smalloc+0x21>
  801558:	b8 00 00 00 00       	mov    $0x0,%eax
  80155d:	e9 9e 00 00 00       	jmp    801600 <smalloc+0xbf>
	//3-If the Kernel successfully creates the shared variable, return its virtual address
	//4-Else, return NULL



	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801562:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801569:	8b 55 0c             	mov    0xc(%ebp),%edx
  80156c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80156f:	01 d0                	add    %edx,%eax
  801571:	48                   	dec    %eax
  801572:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801575:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801578:	ba 00 00 00 00       	mov    $0x0,%edx
  80157d:	f7 75 f0             	divl   -0x10(%ebp)
  801580:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801583:	29 d0                	sub    %edx,%eax
  801585:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801588:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  80158f:	e8 63 06 00 00       	call   801bf7 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801594:	85 c0                	test   %eax,%eax
  801596:	74 11                	je     8015a9 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  801598:	83 ec 0c             	sub    $0xc,%esp
  80159b:	ff 75 e8             	pushl  -0x18(%ebp)
  80159e:	e8 ce 0c 00 00       	call   802271 <alloc_block_FF>
  8015a3:	83 c4 10             	add    $0x10,%esp
  8015a6:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  8015a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8015ad:	74 4c                	je     8015fb <smalloc+0xba>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8015af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015b2:	8b 40 08             	mov    0x8(%eax),%eax
  8015b5:	89 c2                	mov    %eax,%edx
  8015b7:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8015bb:	52                   	push   %edx
  8015bc:	50                   	push   %eax
  8015bd:	ff 75 0c             	pushl  0xc(%ebp)
  8015c0:	ff 75 08             	pushl  0x8(%ebp)
  8015c3:	e8 b4 03 00 00       	call   80197c <sys_createSharedObject>
  8015c8:	83 c4 10             	add    $0x10,%esp
  8015cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cprintf("Output is :  %d \n" , result);
  8015ce:	83 ec 08             	sub    $0x8,%esp
  8015d1:	ff 75 e0             	pushl  -0x20(%ebp)
  8015d4:	68 af 3e 80 00       	push   $0x803eaf
  8015d9:	e8 93 ef ff ff       	call   800571 <cprintf>
  8015de:	83 c4 10             	add    $0x10,%esp
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  8015e1:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  8015e5:	74 14                	je     8015fb <smalloc+0xba>
  8015e7:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  8015eb:	74 0e                	je     8015fb <smalloc+0xba>
  8015ed:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  8015f1:	74 08                	je     8015fb <smalloc+0xba>
			return (void*) mem_block->sva;
  8015f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015f6:	8b 40 08             	mov    0x8(%eax),%eax
  8015f9:	eb 05                	jmp    801600 <smalloc+0xbf>
	}
	return NULL;
  8015fb:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801600:	c9                   	leave  
  801601:	c3                   	ret    

00801602 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801602:	55                   	push   %ebp
  801603:	89 e5                	mov    %esp,%ebp
  801605:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801608:	e8 ee fc ff ff       	call   8012fb <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  80160d:	83 ec 04             	sub    $0x4,%esp
  801610:	68 c4 3e 80 00       	push   $0x803ec4
  801615:	68 ab 00 00 00       	push   $0xab
  80161a:	68 33 3e 80 00       	push   $0x803e33
  80161f:	e8 99 ec ff ff       	call   8002bd <_panic>

00801624 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801624:	55                   	push   %ebp
  801625:	89 e5                	mov    %esp,%ebp
  801627:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80162a:	e8 cc fc ff ff       	call   8012fb <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80162f:	83 ec 04             	sub    $0x4,%esp
  801632:	68 e8 3e 80 00       	push   $0x803ee8
  801637:	68 ef 00 00 00       	push   $0xef
  80163c:	68 33 3e 80 00       	push   $0x803e33
  801641:	e8 77 ec ff ff       	call   8002bd <_panic>

00801646 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801646:	55                   	push   %ebp
  801647:	89 e5                	mov    %esp,%ebp
  801649:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80164c:	83 ec 04             	sub    $0x4,%esp
  80164f:	68 10 3f 80 00       	push   $0x803f10
  801654:	68 03 01 00 00       	push   $0x103
  801659:	68 33 3e 80 00       	push   $0x803e33
  80165e:	e8 5a ec ff ff       	call   8002bd <_panic>

00801663 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801663:	55                   	push   %ebp
  801664:	89 e5                	mov    %esp,%ebp
  801666:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801669:	83 ec 04             	sub    $0x4,%esp
  80166c:	68 34 3f 80 00       	push   $0x803f34
  801671:	68 0e 01 00 00       	push   $0x10e
  801676:	68 33 3e 80 00       	push   $0x803e33
  80167b:	e8 3d ec ff ff       	call   8002bd <_panic>

00801680 <shrink>:

}
void shrink(uint32 newSize)
{
  801680:	55                   	push   %ebp
  801681:	89 e5                	mov    %esp,%ebp
  801683:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801686:	83 ec 04             	sub    $0x4,%esp
  801689:	68 34 3f 80 00       	push   $0x803f34
  80168e:	68 13 01 00 00       	push   $0x113
  801693:	68 33 3e 80 00       	push   $0x803e33
  801698:	e8 20 ec ff ff       	call   8002bd <_panic>

0080169d <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80169d:	55                   	push   %ebp
  80169e:	89 e5                	mov    %esp,%ebp
  8016a0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016a3:	83 ec 04             	sub    $0x4,%esp
  8016a6:	68 34 3f 80 00       	push   $0x803f34
  8016ab:	68 18 01 00 00       	push   $0x118
  8016b0:	68 33 3e 80 00       	push   $0x803e33
  8016b5:	e8 03 ec ff ff       	call   8002bd <_panic>

008016ba <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8016ba:	55                   	push   %ebp
  8016bb:	89 e5                	mov    %esp,%ebp
  8016bd:	57                   	push   %edi
  8016be:	56                   	push   %esi
  8016bf:	53                   	push   %ebx
  8016c0:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016c9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016cc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016cf:	8b 7d 18             	mov    0x18(%ebp),%edi
  8016d2:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8016d5:	cd 30                	int    $0x30
  8016d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8016da:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8016dd:	83 c4 10             	add    $0x10,%esp
  8016e0:	5b                   	pop    %ebx
  8016e1:	5e                   	pop    %esi
  8016e2:	5f                   	pop    %edi
  8016e3:	5d                   	pop    %ebp
  8016e4:	c3                   	ret    

008016e5 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8016e5:	55                   	push   %ebp
  8016e6:	89 e5                	mov    %esp,%ebp
  8016e8:	83 ec 04             	sub    $0x4,%esp
  8016eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ee:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8016f1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8016f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f8:	6a 00                	push   $0x0
  8016fa:	6a 00                	push   $0x0
  8016fc:	52                   	push   %edx
  8016fd:	ff 75 0c             	pushl  0xc(%ebp)
  801700:	50                   	push   %eax
  801701:	6a 00                	push   $0x0
  801703:	e8 b2 ff ff ff       	call   8016ba <syscall>
  801708:	83 c4 18             	add    $0x18,%esp
}
  80170b:	90                   	nop
  80170c:	c9                   	leave  
  80170d:	c3                   	ret    

0080170e <sys_cgetc>:

int
sys_cgetc(void)
{
  80170e:	55                   	push   %ebp
  80170f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801711:	6a 00                	push   $0x0
  801713:	6a 00                	push   $0x0
  801715:	6a 00                	push   $0x0
  801717:	6a 00                	push   $0x0
  801719:	6a 00                	push   $0x0
  80171b:	6a 01                	push   $0x1
  80171d:	e8 98 ff ff ff       	call   8016ba <syscall>
  801722:	83 c4 18             	add    $0x18,%esp
}
  801725:	c9                   	leave  
  801726:	c3                   	ret    

00801727 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801727:	55                   	push   %ebp
  801728:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80172a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80172d:	8b 45 08             	mov    0x8(%ebp),%eax
  801730:	6a 00                	push   $0x0
  801732:	6a 00                	push   $0x0
  801734:	6a 00                	push   $0x0
  801736:	52                   	push   %edx
  801737:	50                   	push   %eax
  801738:	6a 05                	push   $0x5
  80173a:	e8 7b ff ff ff       	call   8016ba <syscall>
  80173f:	83 c4 18             	add    $0x18,%esp
}
  801742:	c9                   	leave  
  801743:	c3                   	ret    

00801744 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801744:	55                   	push   %ebp
  801745:	89 e5                	mov    %esp,%ebp
  801747:	56                   	push   %esi
  801748:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801749:	8b 75 18             	mov    0x18(%ebp),%esi
  80174c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80174f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801752:	8b 55 0c             	mov    0xc(%ebp),%edx
  801755:	8b 45 08             	mov    0x8(%ebp),%eax
  801758:	56                   	push   %esi
  801759:	53                   	push   %ebx
  80175a:	51                   	push   %ecx
  80175b:	52                   	push   %edx
  80175c:	50                   	push   %eax
  80175d:	6a 06                	push   $0x6
  80175f:	e8 56 ff ff ff       	call   8016ba <syscall>
  801764:	83 c4 18             	add    $0x18,%esp
}
  801767:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80176a:	5b                   	pop    %ebx
  80176b:	5e                   	pop    %esi
  80176c:	5d                   	pop    %ebp
  80176d:	c3                   	ret    

0080176e <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80176e:	55                   	push   %ebp
  80176f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801771:	8b 55 0c             	mov    0xc(%ebp),%edx
  801774:	8b 45 08             	mov    0x8(%ebp),%eax
  801777:	6a 00                	push   $0x0
  801779:	6a 00                	push   $0x0
  80177b:	6a 00                	push   $0x0
  80177d:	52                   	push   %edx
  80177e:	50                   	push   %eax
  80177f:	6a 07                	push   $0x7
  801781:	e8 34 ff ff ff       	call   8016ba <syscall>
  801786:	83 c4 18             	add    $0x18,%esp
}
  801789:	c9                   	leave  
  80178a:	c3                   	ret    

0080178b <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80178b:	55                   	push   %ebp
  80178c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80178e:	6a 00                	push   $0x0
  801790:	6a 00                	push   $0x0
  801792:	6a 00                	push   $0x0
  801794:	ff 75 0c             	pushl  0xc(%ebp)
  801797:	ff 75 08             	pushl  0x8(%ebp)
  80179a:	6a 08                	push   $0x8
  80179c:	e8 19 ff ff ff       	call   8016ba <syscall>
  8017a1:	83 c4 18             	add    $0x18,%esp
}
  8017a4:	c9                   	leave  
  8017a5:	c3                   	ret    

008017a6 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8017a6:	55                   	push   %ebp
  8017a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8017a9:	6a 00                	push   $0x0
  8017ab:	6a 00                	push   $0x0
  8017ad:	6a 00                	push   $0x0
  8017af:	6a 00                	push   $0x0
  8017b1:	6a 00                	push   $0x0
  8017b3:	6a 09                	push   $0x9
  8017b5:	e8 00 ff ff ff       	call   8016ba <syscall>
  8017ba:	83 c4 18             	add    $0x18,%esp
}
  8017bd:	c9                   	leave  
  8017be:	c3                   	ret    

008017bf <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8017bf:	55                   	push   %ebp
  8017c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8017c2:	6a 00                	push   $0x0
  8017c4:	6a 00                	push   $0x0
  8017c6:	6a 00                	push   $0x0
  8017c8:	6a 00                	push   $0x0
  8017ca:	6a 00                	push   $0x0
  8017cc:	6a 0a                	push   $0xa
  8017ce:	e8 e7 fe ff ff       	call   8016ba <syscall>
  8017d3:	83 c4 18             	add    $0x18,%esp
}
  8017d6:	c9                   	leave  
  8017d7:	c3                   	ret    

008017d8 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8017d8:	55                   	push   %ebp
  8017d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8017db:	6a 00                	push   $0x0
  8017dd:	6a 00                	push   $0x0
  8017df:	6a 00                	push   $0x0
  8017e1:	6a 00                	push   $0x0
  8017e3:	6a 00                	push   $0x0
  8017e5:	6a 0b                	push   $0xb
  8017e7:	e8 ce fe ff ff       	call   8016ba <syscall>
  8017ec:	83 c4 18             	add    $0x18,%esp
}
  8017ef:	c9                   	leave  
  8017f0:	c3                   	ret    

008017f1 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8017f1:	55                   	push   %ebp
  8017f2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8017f4:	6a 00                	push   $0x0
  8017f6:	6a 00                	push   $0x0
  8017f8:	6a 00                	push   $0x0
  8017fa:	ff 75 0c             	pushl  0xc(%ebp)
  8017fd:	ff 75 08             	pushl  0x8(%ebp)
  801800:	6a 0f                	push   $0xf
  801802:	e8 b3 fe ff ff       	call   8016ba <syscall>
  801807:	83 c4 18             	add    $0x18,%esp
	return;
  80180a:	90                   	nop
}
  80180b:	c9                   	leave  
  80180c:	c3                   	ret    

0080180d <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80180d:	55                   	push   %ebp
  80180e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801810:	6a 00                	push   $0x0
  801812:	6a 00                	push   $0x0
  801814:	6a 00                	push   $0x0
  801816:	ff 75 0c             	pushl  0xc(%ebp)
  801819:	ff 75 08             	pushl  0x8(%ebp)
  80181c:	6a 10                	push   $0x10
  80181e:	e8 97 fe ff ff       	call   8016ba <syscall>
  801823:	83 c4 18             	add    $0x18,%esp
	return ;
  801826:	90                   	nop
}
  801827:	c9                   	leave  
  801828:	c3                   	ret    

00801829 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801829:	55                   	push   %ebp
  80182a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80182c:	6a 00                	push   $0x0
  80182e:	6a 00                	push   $0x0
  801830:	ff 75 10             	pushl  0x10(%ebp)
  801833:	ff 75 0c             	pushl  0xc(%ebp)
  801836:	ff 75 08             	pushl  0x8(%ebp)
  801839:	6a 11                	push   $0x11
  80183b:	e8 7a fe ff ff       	call   8016ba <syscall>
  801840:	83 c4 18             	add    $0x18,%esp
	return ;
  801843:	90                   	nop
}
  801844:	c9                   	leave  
  801845:	c3                   	ret    

00801846 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801846:	55                   	push   %ebp
  801847:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801849:	6a 00                	push   $0x0
  80184b:	6a 00                	push   $0x0
  80184d:	6a 00                	push   $0x0
  80184f:	6a 00                	push   $0x0
  801851:	6a 00                	push   $0x0
  801853:	6a 0c                	push   $0xc
  801855:	e8 60 fe ff ff       	call   8016ba <syscall>
  80185a:	83 c4 18             	add    $0x18,%esp
}
  80185d:	c9                   	leave  
  80185e:	c3                   	ret    

0080185f <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80185f:	55                   	push   %ebp
  801860:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801862:	6a 00                	push   $0x0
  801864:	6a 00                	push   $0x0
  801866:	6a 00                	push   $0x0
  801868:	6a 00                	push   $0x0
  80186a:	ff 75 08             	pushl  0x8(%ebp)
  80186d:	6a 0d                	push   $0xd
  80186f:	e8 46 fe ff ff       	call   8016ba <syscall>
  801874:	83 c4 18             	add    $0x18,%esp
}
  801877:	c9                   	leave  
  801878:	c3                   	ret    

00801879 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801879:	55                   	push   %ebp
  80187a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80187c:	6a 00                	push   $0x0
  80187e:	6a 00                	push   $0x0
  801880:	6a 00                	push   $0x0
  801882:	6a 00                	push   $0x0
  801884:	6a 00                	push   $0x0
  801886:	6a 0e                	push   $0xe
  801888:	e8 2d fe ff ff       	call   8016ba <syscall>
  80188d:	83 c4 18             	add    $0x18,%esp
}
  801890:	90                   	nop
  801891:	c9                   	leave  
  801892:	c3                   	ret    

00801893 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801893:	55                   	push   %ebp
  801894:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801896:	6a 00                	push   $0x0
  801898:	6a 00                	push   $0x0
  80189a:	6a 00                	push   $0x0
  80189c:	6a 00                	push   $0x0
  80189e:	6a 00                	push   $0x0
  8018a0:	6a 13                	push   $0x13
  8018a2:	e8 13 fe ff ff       	call   8016ba <syscall>
  8018a7:	83 c4 18             	add    $0x18,%esp
}
  8018aa:	90                   	nop
  8018ab:	c9                   	leave  
  8018ac:	c3                   	ret    

008018ad <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8018ad:	55                   	push   %ebp
  8018ae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8018b0:	6a 00                	push   $0x0
  8018b2:	6a 00                	push   $0x0
  8018b4:	6a 00                	push   $0x0
  8018b6:	6a 00                	push   $0x0
  8018b8:	6a 00                	push   $0x0
  8018ba:	6a 14                	push   $0x14
  8018bc:	e8 f9 fd ff ff       	call   8016ba <syscall>
  8018c1:	83 c4 18             	add    $0x18,%esp
}
  8018c4:	90                   	nop
  8018c5:	c9                   	leave  
  8018c6:	c3                   	ret    

008018c7 <sys_cputc>:


void
sys_cputc(const char c)
{
  8018c7:	55                   	push   %ebp
  8018c8:	89 e5                	mov    %esp,%ebp
  8018ca:	83 ec 04             	sub    $0x4,%esp
  8018cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8018d3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8018d7:	6a 00                	push   $0x0
  8018d9:	6a 00                	push   $0x0
  8018db:	6a 00                	push   $0x0
  8018dd:	6a 00                	push   $0x0
  8018df:	50                   	push   %eax
  8018e0:	6a 15                	push   $0x15
  8018e2:	e8 d3 fd ff ff       	call   8016ba <syscall>
  8018e7:	83 c4 18             	add    $0x18,%esp
}
  8018ea:	90                   	nop
  8018eb:	c9                   	leave  
  8018ec:	c3                   	ret    

008018ed <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8018ed:	55                   	push   %ebp
  8018ee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8018f0:	6a 00                	push   $0x0
  8018f2:	6a 00                	push   $0x0
  8018f4:	6a 00                	push   $0x0
  8018f6:	6a 00                	push   $0x0
  8018f8:	6a 00                	push   $0x0
  8018fa:	6a 16                	push   $0x16
  8018fc:	e8 b9 fd ff ff       	call   8016ba <syscall>
  801901:	83 c4 18             	add    $0x18,%esp
}
  801904:	90                   	nop
  801905:	c9                   	leave  
  801906:	c3                   	ret    

00801907 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801907:	55                   	push   %ebp
  801908:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80190a:	8b 45 08             	mov    0x8(%ebp),%eax
  80190d:	6a 00                	push   $0x0
  80190f:	6a 00                	push   $0x0
  801911:	6a 00                	push   $0x0
  801913:	ff 75 0c             	pushl  0xc(%ebp)
  801916:	50                   	push   %eax
  801917:	6a 17                	push   $0x17
  801919:	e8 9c fd ff ff       	call   8016ba <syscall>
  80191e:	83 c4 18             	add    $0x18,%esp
}
  801921:	c9                   	leave  
  801922:	c3                   	ret    

00801923 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801923:	55                   	push   %ebp
  801924:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801926:	8b 55 0c             	mov    0xc(%ebp),%edx
  801929:	8b 45 08             	mov    0x8(%ebp),%eax
  80192c:	6a 00                	push   $0x0
  80192e:	6a 00                	push   $0x0
  801930:	6a 00                	push   $0x0
  801932:	52                   	push   %edx
  801933:	50                   	push   %eax
  801934:	6a 1a                	push   $0x1a
  801936:	e8 7f fd ff ff       	call   8016ba <syscall>
  80193b:	83 c4 18             	add    $0x18,%esp
}
  80193e:	c9                   	leave  
  80193f:	c3                   	ret    

00801940 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801940:	55                   	push   %ebp
  801941:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801943:	8b 55 0c             	mov    0xc(%ebp),%edx
  801946:	8b 45 08             	mov    0x8(%ebp),%eax
  801949:	6a 00                	push   $0x0
  80194b:	6a 00                	push   $0x0
  80194d:	6a 00                	push   $0x0
  80194f:	52                   	push   %edx
  801950:	50                   	push   %eax
  801951:	6a 18                	push   $0x18
  801953:	e8 62 fd ff ff       	call   8016ba <syscall>
  801958:	83 c4 18             	add    $0x18,%esp
}
  80195b:	90                   	nop
  80195c:	c9                   	leave  
  80195d:	c3                   	ret    

0080195e <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80195e:	55                   	push   %ebp
  80195f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801961:	8b 55 0c             	mov    0xc(%ebp),%edx
  801964:	8b 45 08             	mov    0x8(%ebp),%eax
  801967:	6a 00                	push   $0x0
  801969:	6a 00                	push   $0x0
  80196b:	6a 00                	push   $0x0
  80196d:	52                   	push   %edx
  80196e:	50                   	push   %eax
  80196f:	6a 19                	push   $0x19
  801971:	e8 44 fd ff ff       	call   8016ba <syscall>
  801976:	83 c4 18             	add    $0x18,%esp
}
  801979:	90                   	nop
  80197a:	c9                   	leave  
  80197b:	c3                   	ret    

0080197c <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80197c:	55                   	push   %ebp
  80197d:	89 e5                	mov    %esp,%ebp
  80197f:	83 ec 04             	sub    $0x4,%esp
  801982:	8b 45 10             	mov    0x10(%ebp),%eax
  801985:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801988:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80198b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80198f:	8b 45 08             	mov    0x8(%ebp),%eax
  801992:	6a 00                	push   $0x0
  801994:	51                   	push   %ecx
  801995:	52                   	push   %edx
  801996:	ff 75 0c             	pushl  0xc(%ebp)
  801999:	50                   	push   %eax
  80199a:	6a 1b                	push   $0x1b
  80199c:	e8 19 fd ff ff       	call   8016ba <syscall>
  8019a1:	83 c4 18             	add    $0x18,%esp
}
  8019a4:	c9                   	leave  
  8019a5:	c3                   	ret    

008019a6 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8019a6:	55                   	push   %ebp
  8019a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8019a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8019af:	6a 00                	push   $0x0
  8019b1:	6a 00                	push   $0x0
  8019b3:	6a 00                	push   $0x0
  8019b5:	52                   	push   %edx
  8019b6:	50                   	push   %eax
  8019b7:	6a 1c                	push   $0x1c
  8019b9:	e8 fc fc ff ff       	call   8016ba <syscall>
  8019be:	83 c4 18             	add    $0x18,%esp
}
  8019c1:	c9                   	leave  
  8019c2:	c3                   	ret    

008019c3 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8019c3:	55                   	push   %ebp
  8019c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8019c6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	51                   	push   %ecx
  8019d4:	52                   	push   %edx
  8019d5:	50                   	push   %eax
  8019d6:	6a 1d                	push   $0x1d
  8019d8:	e8 dd fc ff ff       	call   8016ba <syscall>
  8019dd:	83 c4 18             	add    $0x18,%esp
}
  8019e0:	c9                   	leave  
  8019e1:	c3                   	ret    

008019e2 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8019e2:	55                   	push   %ebp
  8019e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8019e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 00                	push   $0x0
  8019f1:	52                   	push   %edx
  8019f2:	50                   	push   %eax
  8019f3:	6a 1e                	push   $0x1e
  8019f5:	e8 c0 fc ff ff       	call   8016ba <syscall>
  8019fa:	83 c4 18             	add    $0x18,%esp
}
  8019fd:	c9                   	leave  
  8019fe:	c3                   	ret    

008019ff <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8019ff:	55                   	push   %ebp
  801a00:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801a02:	6a 00                	push   $0x0
  801a04:	6a 00                	push   $0x0
  801a06:	6a 00                	push   $0x0
  801a08:	6a 00                	push   $0x0
  801a0a:	6a 00                	push   $0x0
  801a0c:	6a 1f                	push   $0x1f
  801a0e:	e8 a7 fc ff ff       	call   8016ba <syscall>
  801a13:	83 c4 18             	add    $0x18,%esp
}
  801a16:	c9                   	leave  
  801a17:	c3                   	ret    

00801a18 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a18:	55                   	push   %ebp
  801a19:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1e:	6a 00                	push   $0x0
  801a20:	ff 75 14             	pushl  0x14(%ebp)
  801a23:	ff 75 10             	pushl  0x10(%ebp)
  801a26:	ff 75 0c             	pushl  0xc(%ebp)
  801a29:	50                   	push   %eax
  801a2a:	6a 20                	push   $0x20
  801a2c:	e8 89 fc ff ff       	call   8016ba <syscall>
  801a31:	83 c4 18             	add    $0x18,%esp
}
  801a34:	c9                   	leave  
  801a35:	c3                   	ret    

00801a36 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801a36:	55                   	push   %ebp
  801a37:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a39:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3c:	6a 00                	push   $0x0
  801a3e:	6a 00                	push   $0x0
  801a40:	6a 00                	push   $0x0
  801a42:	6a 00                	push   $0x0
  801a44:	50                   	push   %eax
  801a45:	6a 21                	push   $0x21
  801a47:	e8 6e fc ff ff       	call   8016ba <syscall>
  801a4c:	83 c4 18             	add    $0x18,%esp
}
  801a4f:	90                   	nop
  801a50:	c9                   	leave  
  801a51:	c3                   	ret    

00801a52 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801a52:	55                   	push   %ebp
  801a53:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801a55:	8b 45 08             	mov    0x8(%ebp),%eax
  801a58:	6a 00                	push   $0x0
  801a5a:	6a 00                	push   $0x0
  801a5c:	6a 00                	push   $0x0
  801a5e:	6a 00                	push   $0x0
  801a60:	50                   	push   %eax
  801a61:	6a 22                	push   $0x22
  801a63:	e8 52 fc ff ff       	call   8016ba <syscall>
  801a68:	83 c4 18             	add    $0x18,%esp
}
  801a6b:	c9                   	leave  
  801a6c:	c3                   	ret    

00801a6d <sys_getenvid>:

int32 sys_getenvid(void)
{
  801a6d:	55                   	push   %ebp
  801a6e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801a70:	6a 00                	push   $0x0
  801a72:	6a 00                	push   $0x0
  801a74:	6a 00                	push   $0x0
  801a76:	6a 00                	push   $0x0
  801a78:	6a 00                	push   $0x0
  801a7a:	6a 02                	push   $0x2
  801a7c:	e8 39 fc ff ff       	call   8016ba <syscall>
  801a81:	83 c4 18             	add    $0x18,%esp
}
  801a84:	c9                   	leave  
  801a85:	c3                   	ret    

00801a86 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801a86:	55                   	push   %ebp
  801a87:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801a89:	6a 00                	push   $0x0
  801a8b:	6a 00                	push   $0x0
  801a8d:	6a 00                	push   $0x0
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 00                	push   $0x0
  801a93:	6a 03                	push   $0x3
  801a95:	e8 20 fc ff ff       	call   8016ba <syscall>
  801a9a:	83 c4 18             	add    $0x18,%esp
}
  801a9d:	c9                   	leave  
  801a9e:	c3                   	ret    

00801a9f <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801a9f:	55                   	push   %ebp
  801aa0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801aa2:	6a 00                	push   $0x0
  801aa4:	6a 00                	push   $0x0
  801aa6:	6a 00                	push   $0x0
  801aa8:	6a 00                	push   $0x0
  801aaa:	6a 00                	push   $0x0
  801aac:	6a 04                	push   $0x4
  801aae:	e8 07 fc ff ff       	call   8016ba <syscall>
  801ab3:	83 c4 18             	add    $0x18,%esp
}
  801ab6:	c9                   	leave  
  801ab7:	c3                   	ret    

00801ab8 <sys_exit_env>:


void sys_exit_env(void)
{
  801ab8:	55                   	push   %ebp
  801ab9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801abb:	6a 00                	push   $0x0
  801abd:	6a 00                	push   $0x0
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 00                	push   $0x0
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 23                	push   $0x23
  801ac7:	e8 ee fb ff ff       	call   8016ba <syscall>
  801acc:	83 c4 18             	add    $0x18,%esp
}
  801acf:	90                   	nop
  801ad0:	c9                   	leave  
  801ad1:	c3                   	ret    

00801ad2 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801ad2:	55                   	push   %ebp
  801ad3:	89 e5                	mov    %esp,%ebp
  801ad5:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801ad8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801adb:	8d 50 04             	lea    0x4(%eax),%edx
  801ade:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 00                	push   $0x0
  801ae7:	52                   	push   %edx
  801ae8:	50                   	push   %eax
  801ae9:	6a 24                	push   $0x24
  801aeb:	e8 ca fb ff ff       	call   8016ba <syscall>
  801af0:	83 c4 18             	add    $0x18,%esp
	return result;
  801af3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801af6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801af9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801afc:	89 01                	mov    %eax,(%ecx)
  801afe:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b01:	8b 45 08             	mov    0x8(%ebp),%eax
  801b04:	c9                   	leave  
  801b05:	c2 04 00             	ret    $0x4

00801b08 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b08:	55                   	push   %ebp
  801b09:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	ff 75 10             	pushl  0x10(%ebp)
  801b12:	ff 75 0c             	pushl  0xc(%ebp)
  801b15:	ff 75 08             	pushl  0x8(%ebp)
  801b18:	6a 12                	push   $0x12
  801b1a:	e8 9b fb ff ff       	call   8016ba <syscall>
  801b1f:	83 c4 18             	add    $0x18,%esp
	return ;
  801b22:	90                   	nop
}
  801b23:	c9                   	leave  
  801b24:	c3                   	ret    

00801b25 <sys_rcr2>:
uint32 sys_rcr2()
{
  801b25:	55                   	push   %ebp
  801b26:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b28:	6a 00                	push   $0x0
  801b2a:	6a 00                	push   $0x0
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 00                	push   $0x0
  801b30:	6a 00                	push   $0x0
  801b32:	6a 25                	push   $0x25
  801b34:	e8 81 fb ff ff       	call   8016ba <syscall>
  801b39:	83 c4 18             	add    $0x18,%esp
}
  801b3c:	c9                   	leave  
  801b3d:	c3                   	ret    

00801b3e <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801b3e:	55                   	push   %ebp
  801b3f:	89 e5                	mov    %esp,%ebp
  801b41:	83 ec 04             	sub    $0x4,%esp
  801b44:	8b 45 08             	mov    0x8(%ebp),%eax
  801b47:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801b4a:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801b4e:	6a 00                	push   $0x0
  801b50:	6a 00                	push   $0x0
  801b52:	6a 00                	push   $0x0
  801b54:	6a 00                	push   $0x0
  801b56:	50                   	push   %eax
  801b57:	6a 26                	push   $0x26
  801b59:	e8 5c fb ff ff       	call   8016ba <syscall>
  801b5e:	83 c4 18             	add    $0x18,%esp
	return ;
  801b61:	90                   	nop
}
  801b62:	c9                   	leave  
  801b63:	c3                   	ret    

00801b64 <rsttst>:
void rsttst()
{
  801b64:	55                   	push   %ebp
  801b65:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801b67:	6a 00                	push   $0x0
  801b69:	6a 00                	push   $0x0
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 28                	push   $0x28
  801b73:	e8 42 fb ff ff       	call   8016ba <syscall>
  801b78:	83 c4 18             	add    $0x18,%esp
	return ;
  801b7b:	90                   	nop
}
  801b7c:	c9                   	leave  
  801b7d:	c3                   	ret    

00801b7e <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801b7e:	55                   	push   %ebp
  801b7f:	89 e5                	mov    %esp,%ebp
  801b81:	83 ec 04             	sub    $0x4,%esp
  801b84:	8b 45 14             	mov    0x14(%ebp),%eax
  801b87:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801b8a:	8b 55 18             	mov    0x18(%ebp),%edx
  801b8d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b91:	52                   	push   %edx
  801b92:	50                   	push   %eax
  801b93:	ff 75 10             	pushl  0x10(%ebp)
  801b96:	ff 75 0c             	pushl  0xc(%ebp)
  801b99:	ff 75 08             	pushl  0x8(%ebp)
  801b9c:	6a 27                	push   $0x27
  801b9e:	e8 17 fb ff ff       	call   8016ba <syscall>
  801ba3:	83 c4 18             	add    $0x18,%esp
	return ;
  801ba6:	90                   	nop
}
  801ba7:	c9                   	leave  
  801ba8:	c3                   	ret    

00801ba9 <chktst>:
void chktst(uint32 n)
{
  801ba9:	55                   	push   %ebp
  801baa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801bac:	6a 00                	push   $0x0
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 00                	push   $0x0
  801bb4:	ff 75 08             	pushl  0x8(%ebp)
  801bb7:	6a 29                	push   $0x29
  801bb9:	e8 fc fa ff ff       	call   8016ba <syscall>
  801bbe:	83 c4 18             	add    $0x18,%esp
	return ;
  801bc1:	90                   	nop
}
  801bc2:	c9                   	leave  
  801bc3:	c3                   	ret    

00801bc4 <inctst>:

void inctst()
{
  801bc4:	55                   	push   %ebp
  801bc5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 00                	push   $0x0
  801bcb:	6a 00                	push   $0x0
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 00                	push   $0x0
  801bd1:	6a 2a                	push   $0x2a
  801bd3:	e8 e2 fa ff ff       	call   8016ba <syscall>
  801bd8:	83 c4 18             	add    $0x18,%esp
	return ;
  801bdb:	90                   	nop
}
  801bdc:	c9                   	leave  
  801bdd:	c3                   	ret    

00801bde <gettst>:
uint32 gettst()
{
  801bde:	55                   	push   %ebp
  801bdf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801be1:	6a 00                	push   $0x0
  801be3:	6a 00                	push   $0x0
  801be5:	6a 00                	push   $0x0
  801be7:	6a 00                	push   $0x0
  801be9:	6a 00                	push   $0x0
  801beb:	6a 2b                	push   $0x2b
  801bed:	e8 c8 fa ff ff       	call   8016ba <syscall>
  801bf2:	83 c4 18             	add    $0x18,%esp
}
  801bf5:	c9                   	leave  
  801bf6:	c3                   	ret    

00801bf7 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801bf7:	55                   	push   %ebp
  801bf8:	89 e5                	mov    %esp,%ebp
  801bfa:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 00                	push   $0x0
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	6a 2c                	push   $0x2c
  801c09:	e8 ac fa ff ff       	call   8016ba <syscall>
  801c0e:	83 c4 18             	add    $0x18,%esp
  801c11:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801c14:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801c18:	75 07                	jne    801c21 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801c1a:	b8 01 00 00 00       	mov    $0x1,%eax
  801c1f:	eb 05                	jmp    801c26 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801c21:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c26:	c9                   	leave  
  801c27:	c3                   	ret    

00801c28 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801c28:	55                   	push   %ebp
  801c29:	89 e5                	mov    %esp,%ebp
  801c2b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c2e:	6a 00                	push   $0x0
  801c30:	6a 00                	push   $0x0
  801c32:	6a 00                	push   $0x0
  801c34:	6a 00                	push   $0x0
  801c36:	6a 00                	push   $0x0
  801c38:	6a 2c                	push   $0x2c
  801c3a:	e8 7b fa ff ff       	call   8016ba <syscall>
  801c3f:	83 c4 18             	add    $0x18,%esp
  801c42:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801c45:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801c49:	75 07                	jne    801c52 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801c4b:	b8 01 00 00 00       	mov    $0x1,%eax
  801c50:	eb 05                	jmp    801c57 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801c52:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c57:	c9                   	leave  
  801c58:	c3                   	ret    

00801c59 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801c59:	55                   	push   %ebp
  801c5a:	89 e5                	mov    %esp,%ebp
  801c5c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c5f:	6a 00                	push   $0x0
  801c61:	6a 00                	push   $0x0
  801c63:	6a 00                	push   $0x0
  801c65:	6a 00                	push   $0x0
  801c67:	6a 00                	push   $0x0
  801c69:	6a 2c                	push   $0x2c
  801c6b:	e8 4a fa ff ff       	call   8016ba <syscall>
  801c70:	83 c4 18             	add    $0x18,%esp
  801c73:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801c76:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801c7a:	75 07                	jne    801c83 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801c7c:	b8 01 00 00 00       	mov    $0x1,%eax
  801c81:	eb 05                	jmp    801c88 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801c83:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c88:	c9                   	leave  
  801c89:	c3                   	ret    

00801c8a <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801c8a:	55                   	push   %ebp
  801c8b:	89 e5                	mov    %esp,%ebp
  801c8d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c90:	6a 00                	push   $0x0
  801c92:	6a 00                	push   $0x0
  801c94:	6a 00                	push   $0x0
  801c96:	6a 00                	push   $0x0
  801c98:	6a 00                	push   $0x0
  801c9a:	6a 2c                	push   $0x2c
  801c9c:	e8 19 fa ff ff       	call   8016ba <syscall>
  801ca1:	83 c4 18             	add    $0x18,%esp
  801ca4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801ca7:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801cab:	75 07                	jne    801cb4 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801cad:	b8 01 00 00 00       	mov    $0x1,%eax
  801cb2:	eb 05                	jmp    801cb9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801cb4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cb9:	c9                   	leave  
  801cba:	c3                   	ret    

00801cbb <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801cbb:	55                   	push   %ebp
  801cbc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801cbe:	6a 00                	push   $0x0
  801cc0:	6a 00                	push   $0x0
  801cc2:	6a 00                	push   $0x0
  801cc4:	6a 00                	push   $0x0
  801cc6:	ff 75 08             	pushl  0x8(%ebp)
  801cc9:	6a 2d                	push   $0x2d
  801ccb:	e8 ea f9 ff ff       	call   8016ba <syscall>
  801cd0:	83 c4 18             	add    $0x18,%esp
	return ;
  801cd3:	90                   	nop
}
  801cd4:	c9                   	leave  
  801cd5:	c3                   	ret    

00801cd6 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801cd6:	55                   	push   %ebp
  801cd7:	89 e5                	mov    %esp,%ebp
  801cd9:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801cda:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cdd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ce0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce6:	6a 00                	push   $0x0
  801ce8:	53                   	push   %ebx
  801ce9:	51                   	push   %ecx
  801cea:	52                   	push   %edx
  801ceb:	50                   	push   %eax
  801cec:	6a 2e                	push   $0x2e
  801cee:	e8 c7 f9 ff ff       	call   8016ba <syscall>
  801cf3:	83 c4 18             	add    $0x18,%esp
}
  801cf6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cf9:	c9                   	leave  
  801cfa:	c3                   	ret    

00801cfb <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801cfb:	55                   	push   %ebp
  801cfc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801cfe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d01:	8b 45 08             	mov    0x8(%ebp),%eax
  801d04:	6a 00                	push   $0x0
  801d06:	6a 00                	push   $0x0
  801d08:	6a 00                	push   $0x0
  801d0a:	52                   	push   %edx
  801d0b:	50                   	push   %eax
  801d0c:	6a 2f                	push   $0x2f
  801d0e:	e8 a7 f9 ff ff       	call   8016ba <syscall>
  801d13:	83 c4 18             	add    $0x18,%esp
}
  801d16:	c9                   	leave  
  801d17:	c3                   	ret    

00801d18 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801d18:	55                   	push   %ebp
  801d19:	89 e5                	mov    %esp,%ebp
  801d1b:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801d1e:	83 ec 0c             	sub    $0xc,%esp
  801d21:	68 44 3f 80 00       	push   $0x803f44
  801d26:	e8 46 e8 ff ff       	call   800571 <cprintf>
  801d2b:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801d2e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801d35:	83 ec 0c             	sub    $0xc,%esp
  801d38:	68 70 3f 80 00       	push   $0x803f70
  801d3d:	e8 2f e8 ff ff       	call   800571 <cprintf>
  801d42:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801d45:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d49:	a1 38 51 80 00       	mov    0x805138,%eax
  801d4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d51:	eb 56                	jmp    801da9 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801d53:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d57:	74 1c                	je     801d75 <print_mem_block_lists+0x5d>
  801d59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d5c:	8b 50 08             	mov    0x8(%eax),%edx
  801d5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d62:	8b 48 08             	mov    0x8(%eax),%ecx
  801d65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d68:	8b 40 0c             	mov    0xc(%eax),%eax
  801d6b:	01 c8                	add    %ecx,%eax
  801d6d:	39 c2                	cmp    %eax,%edx
  801d6f:	73 04                	jae    801d75 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801d71:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801d75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d78:	8b 50 08             	mov    0x8(%eax),%edx
  801d7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d7e:	8b 40 0c             	mov    0xc(%eax),%eax
  801d81:	01 c2                	add    %eax,%edx
  801d83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d86:	8b 40 08             	mov    0x8(%eax),%eax
  801d89:	83 ec 04             	sub    $0x4,%esp
  801d8c:	52                   	push   %edx
  801d8d:	50                   	push   %eax
  801d8e:	68 85 3f 80 00       	push   $0x803f85
  801d93:	e8 d9 e7 ff ff       	call   800571 <cprintf>
  801d98:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801d9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801da1:	a1 40 51 80 00       	mov    0x805140,%eax
  801da6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801da9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801dad:	74 07                	je     801db6 <print_mem_block_lists+0x9e>
  801daf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db2:	8b 00                	mov    (%eax),%eax
  801db4:	eb 05                	jmp    801dbb <print_mem_block_lists+0xa3>
  801db6:	b8 00 00 00 00       	mov    $0x0,%eax
  801dbb:	a3 40 51 80 00       	mov    %eax,0x805140
  801dc0:	a1 40 51 80 00       	mov    0x805140,%eax
  801dc5:	85 c0                	test   %eax,%eax
  801dc7:	75 8a                	jne    801d53 <print_mem_block_lists+0x3b>
  801dc9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801dcd:	75 84                	jne    801d53 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801dcf:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801dd3:	75 10                	jne    801de5 <print_mem_block_lists+0xcd>
  801dd5:	83 ec 0c             	sub    $0xc,%esp
  801dd8:	68 94 3f 80 00       	push   $0x803f94
  801ddd:	e8 8f e7 ff ff       	call   800571 <cprintf>
  801de2:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801de5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801dec:	83 ec 0c             	sub    $0xc,%esp
  801def:	68 b8 3f 80 00       	push   $0x803fb8
  801df4:	e8 78 e7 ff ff       	call   800571 <cprintf>
  801df9:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801dfc:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801e00:	a1 40 50 80 00       	mov    0x805040,%eax
  801e05:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e08:	eb 56                	jmp    801e60 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e0a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e0e:	74 1c                	je     801e2c <print_mem_block_lists+0x114>
  801e10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e13:	8b 50 08             	mov    0x8(%eax),%edx
  801e16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e19:	8b 48 08             	mov    0x8(%eax),%ecx
  801e1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e1f:	8b 40 0c             	mov    0xc(%eax),%eax
  801e22:	01 c8                	add    %ecx,%eax
  801e24:	39 c2                	cmp    %eax,%edx
  801e26:	73 04                	jae    801e2c <print_mem_block_lists+0x114>
			sorted = 0 ;
  801e28:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e2f:	8b 50 08             	mov    0x8(%eax),%edx
  801e32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e35:	8b 40 0c             	mov    0xc(%eax),%eax
  801e38:	01 c2                	add    %eax,%edx
  801e3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e3d:	8b 40 08             	mov    0x8(%eax),%eax
  801e40:	83 ec 04             	sub    $0x4,%esp
  801e43:	52                   	push   %edx
  801e44:	50                   	push   %eax
  801e45:	68 85 3f 80 00       	push   $0x803f85
  801e4a:	e8 22 e7 ff ff       	call   800571 <cprintf>
  801e4f:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e55:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801e58:	a1 48 50 80 00       	mov    0x805048,%eax
  801e5d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e60:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e64:	74 07                	je     801e6d <print_mem_block_lists+0x155>
  801e66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e69:	8b 00                	mov    (%eax),%eax
  801e6b:	eb 05                	jmp    801e72 <print_mem_block_lists+0x15a>
  801e6d:	b8 00 00 00 00       	mov    $0x0,%eax
  801e72:	a3 48 50 80 00       	mov    %eax,0x805048
  801e77:	a1 48 50 80 00       	mov    0x805048,%eax
  801e7c:	85 c0                	test   %eax,%eax
  801e7e:	75 8a                	jne    801e0a <print_mem_block_lists+0xf2>
  801e80:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e84:	75 84                	jne    801e0a <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801e86:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e8a:	75 10                	jne    801e9c <print_mem_block_lists+0x184>
  801e8c:	83 ec 0c             	sub    $0xc,%esp
  801e8f:	68 d0 3f 80 00       	push   $0x803fd0
  801e94:	e8 d8 e6 ff ff       	call   800571 <cprintf>
  801e99:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801e9c:	83 ec 0c             	sub    $0xc,%esp
  801e9f:	68 44 3f 80 00       	push   $0x803f44
  801ea4:	e8 c8 e6 ff ff       	call   800571 <cprintf>
  801ea9:	83 c4 10             	add    $0x10,%esp

}
  801eac:	90                   	nop
  801ead:	c9                   	leave  
  801eae:	c3                   	ret    

00801eaf <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801eaf:	55                   	push   %ebp
  801eb0:	89 e5                	mov    %esp,%ebp
  801eb2:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801eb5:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  801ebc:	00 00 00 
  801ebf:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  801ec6:	00 00 00 
  801ec9:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  801ed0:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801ed3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801eda:	e9 9e 00 00 00       	jmp    801f7d <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801edf:	a1 50 50 80 00       	mov    0x805050,%eax
  801ee4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ee7:	c1 e2 04             	shl    $0x4,%edx
  801eea:	01 d0                	add    %edx,%eax
  801eec:	85 c0                	test   %eax,%eax
  801eee:	75 14                	jne    801f04 <initialize_MemBlocksList+0x55>
  801ef0:	83 ec 04             	sub    $0x4,%esp
  801ef3:	68 f8 3f 80 00       	push   $0x803ff8
  801ef8:	6a 46                	push   $0x46
  801efa:	68 1b 40 80 00       	push   $0x80401b
  801eff:	e8 b9 e3 ff ff       	call   8002bd <_panic>
  801f04:	a1 50 50 80 00       	mov    0x805050,%eax
  801f09:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f0c:	c1 e2 04             	shl    $0x4,%edx
  801f0f:	01 d0                	add    %edx,%eax
  801f11:	8b 15 48 51 80 00    	mov    0x805148,%edx
  801f17:	89 10                	mov    %edx,(%eax)
  801f19:	8b 00                	mov    (%eax),%eax
  801f1b:	85 c0                	test   %eax,%eax
  801f1d:	74 18                	je     801f37 <initialize_MemBlocksList+0x88>
  801f1f:	a1 48 51 80 00       	mov    0x805148,%eax
  801f24:	8b 15 50 50 80 00    	mov    0x805050,%edx
  801f2a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801f2d:	c1 e1 04             	shl    $0x4,%ecx
  801f30:	01 ca                	add    %ecx,%edx
  801f32:	89 50 04             	mov    %edx,0x4(%eax)
  801f35:	eb 12                	jmp    801f49 <initialize_MemBlocksList+0x9a>
  801f37:	a1 50 50 80 00       	mov    0x805050,%eax
  801f3c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f3f:	c1 e2 04             	shl    $0x4,%edx
  801f42:	01 d0                	add    %edx,%eax
  801f44:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801f49:	a1 50 50 80 00       	mov    0x805050,%eax
  801f4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f51:	c1 e2 04             	shl    $0x4,%edx
  801f54:	01 d0                	add    %edx,%eax
  801f56:	a3 48 51 80 00       	mov    %eax,0x805148
  801f5b:	a1 50 50 80 00       	mov    0x805050,%eax
  801f60:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f63:	c1 e2 04             	shl    $0x4,%edx
  801f66:	01 d0                	add    %edx,%eax
  801f68:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f6f:	a1 54 51 80 00       	mov    0x805154,%eax
  801f74:	40                   	inc    %eax
  801f75:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801f7a:	ff 45 f4             	incl   -0xc(%ebp)
  801f7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f80:	3b 45 08             	cmp    0x8(%ebp),%eax
  801f83:	0f 82 56 ff ff ff    	jb     801edf <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801f89:	90                   	nop
  801f8a:	c9                   	leave  
  801f8b:	c3                   	ret    

00801f8c <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801f8c:	55                   	push   %ebp
  801f8d:	89 e5                	mov    %esp,%ebp
  801f8f:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801f92:	8b 45 08             	mov    0x8(%ebp),%eax
  801f95:	8b 00                	mov    (%eax),%eax
  801f97:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f9a:	eb 19                	jmp    801fb5 <find_block+0x29>
	{
		if(va==point->sva)
  801f9c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f9f:	8b 40 08             	mov    0x8(%eax),%eax
  801fa2:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801fa5:	75 05                	jne    801fac <find_block+0x20>
		   return point;
  801fa7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801faa:	eb 36                	jmp    801fe2 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801fac:	8b 45 08             	mov    0x8(%ebp),%eax
  801faf:	8b 40 08             	mov    0x8(%eax),%eax
  801fb2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801fb5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801fb9:	74 07                	je     801fc2 <find_block+0x36>
  801fbb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fbe:	8b 00                	mov    (%eax),%eax
  801fc0:	eb 05                	jmp    801fc7 <find_block+0x3b>
  801fc2:	b8 00 00 00 00       	mov    $0x0,%eax
  801fc7:	8b 55 08             	mov    0x8(%ebp),%edx
  801fca:	89 42 08             	mov    %eax,0x8(%edx)
  801fcd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd0:	8b 40 08             	mov    0x8(%eax),%eax
  801fd3:	85 c0                	test   %eax,%eax
  801fd5:	75 c5                	jne    801f9c <find_block+0x10>
  801fd7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801fdb:	75 bf                	jne    801f9c <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  801fdd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fe2:	c9                   	leave  
  801fe3:	c3                   	ret    

00801fe4 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  801fe4:	55                   	push   %ebp
  801fe5:	89 e5                	mov    %esp,%ebp
  801fe7:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  801fea:	a1 40 50 80 00       	mov    0x805040,%eax
  801fef:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  801ff2:	a1 44 50 80 00       	mov    0x805044,%eax
  801ff7:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  801ffa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ffd:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802000:	74 24                	je     802026 <insert_sorted_allocList+0x42>
  802002:	8b 45 08             	mov    0x8(%ebp),%eax
  802005:	8b 50 08             	mov    0x8(%eax),%edx
  802008:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80200b:	8b 40 08             	mov    0x8(%eax),%eax
  80200e:	39 c2                	cmp    %eax,%edx
  802010:	76 14                	jbe    802026 <insert_sorted_allocList+0x42>
  802012:	8b 45 08             	mov    0x8(%ebp),%eax
  802015:	8b 50 08             	mov    0x8(%eax),%edx
  802018:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80201b:	8b 40 08             	mov    0x8(%eax),%eax
  80201e:	39 c2                	cmp    %eax,%edx
  802020:	0f 82 60 01 00 00    	jb     802186 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802026:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80202a:	75 65                	jne    802091 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  80202c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802030:	75 14                	jne    802046 <insert_sorted_allocList+0x62>
  802032:	83 ec 04             	sub    $0x4,%esp
  802035:	68 f8 3f 80 00       	push   $0x803ff8
  80203a:	6a 6b                	push   $0x6b
  80203c:	68 1b 40 80 00       	push   $0x80401b
  802041:	e8 77 e2 ff ff       	call   8002bd <_panic>
  802046:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80204c:	8b 45 08             	mov    0x8(%ebp),%eax
  80204f:	89 10                	mov    %edx,(%eax)
  802051:	8b 45 08             	mov    0x8(%ebp),%eax
  802054:	8b 00                	mov    (%eax),%eax
  802056:	85 c0                	test   %eax,%eax
  802058:	74 0d                	je     802067 <insert_sorted_allocList+0x83>
  80205a:	a1 40 50 80 00       	mov    0x805040,%eax
  80205f:	8b 55 08             	mov    0x8(%ebp),%edx
  802062:	89 50 04             	mov    %edx,0x4(%eax)
  802065:	eb 08                	jmp    80206f <insert_sorted_allocList+0x8b>
  802067:	8b 45 08             	mov    0x8(%ebp),%eax
  80206a:	a3 44 50 80 00       	mov    %eax,0x805044
  80206f:	8b 45 08             	mov    0x8(%ebp),%eax
  802072:	a3 40 50 80 00       	mov    %eax,0x805040
  802077:	8b 45 08             	mov    0x8(%ebp),%eax
  80207a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802081:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802086:	40                   	inc    %eax
  802087:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80208c:	e9 dc 01 00 00       	jmp    80226d <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802091:	8b 45 08             	mov    0x8(%ebp),%eax
  802094:	8b 50 08             	mov    0x8(%eax),%edx
  802097:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80209a:	8b 40 08             	mov    0x8(%eax),%eax
  80209d:	39 c2                	cmp    %eax,%edx
  80209f:	77 6c                	ja     80210d <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8020a1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020a5:	74 06                	je     8020ad <insert_sorted_allocList+0xc9>
  8020a7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020ab:	75 14                	jne    8020c1 <insert_sorted_allocList+0xdd>
  8020ad:	83 ec 04             	sub    $0x4,%esp
  8020b0:	68 34 40 80 00       	push   $0x804034
  8020b5:	6a 6f                	push   $0x6f
  8020b7:	68 1b 40 80 00       	push   $0x80401b
  8020bc:	e8 fc e1 ff ff       	call   8002bd <_panic>
  8020c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020c4:	8b 50 04             	mov    0x4(%eax),%edx
  8020c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ca:	89 50 04             	mov    %edx,0x4(%eax)
  8020cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8020d3:	89 10                	mov    %edx,(%eax)
  8020d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020d8:	8b 40 04             	mov    0x4(%eax),%eax
  8020db:	85 c0                	test   %eax,%eax
  8020dd:	74 0d                	je     8020ec <insert_sorted_allocList+0x108>
  8020df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020e2:	8b 40 04             	mov    0x4(%eax),%eax
  8020e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8020e8:	89 10                	mov    %edx,(%eax)
  8020ea:	eb 08                	jmp    8020f4 <insert_sorted_allocList+0x110>
  8020ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ef:	a3 40 50 80 00       	mov    %eax,0x805040
  8020f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020f7:	8b 55 08             	mov    0x8(%ebp),%edx
  8020fa:	89 50 04             	mov    %edx,0x4(%eax)
  8020fd:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802102:	40                   	inc    %eax
  802103:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802108:	e9 60 01 00 00       	jmp    80226d <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  80210d:	8b 45 08             	mov    0x8(%ebp),%eax
  802110:	8b 50 08             	mov    0x8(%eax),%edx
  802113:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802116:	8b 40 08             	mov    0x8(%eax),%eax
  802119:	39 c2                	cmp    %eax,%edx
  80211b:	0f 82 4c 01 00 00    	jb     80226d <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802121:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802125:	75 14                	jne    80213b <insert_sorted_allocList+0x157>
  802127:	83 ec 04             	sub    $0x4,%esp
  80212a:	68 6c 40 80 00       	push   $0x80406c
  80212f:	6a 73                	push   $0x73
  802131:	68 1b 40 80 00       	push   $0x80401b
  802136:	e8 82 e1 ff ff       	call   8002bd <_panic>
  80213b:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802141:	8b 45 08             	mov    0x8(%ebp),%eax
  802144:	89 50 04             	mov    %edx,0x4(%eax)
  802147:	8b 45 08             	mov    0x8(%ebp),%eax
  80214a:	8b 40 04             	mov    0x4(%eax),%eax
  80214d:	85 c0                	test   %eax,%eax
  80214f:	74 0c                	je     80215d <insert_sorted_allocList+0x179>
  802151:	a1 44 50 80 00       	mov    0x805044,%eax
  802156:	8b 55 08             	mov    0x8(%ebp),%edx
  802159:	89 10                	mov    %edx,(%eax)
  80215b:	eb 08                	jmp    802165 <insert_sorted_allocList+0x181>
  80215d:	8b 45 08             	mov    0x8(%ebp),%eax
  802160:	a3 40 50 80 00       	mov    %eax,0x805040
  802165:	8b 45 08             	mov    0x8(%ebp),%eax
  802168:	a3 44 50 80 00       	mov    %eax,0x805044
  80216d:	8b 45 08             	mov    0x8(%ebp),%eax
  802170:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802176:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80217b:	40                   	inc    %eax
  80217c:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802181:	e9 e7 00 00 00       	jmp    80226d <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802186:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802189:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  80218c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802193:	a1 40 50 80 00       	mov    0x805040,%eax
  802198:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80219b:	e9 9d 00 00 00       	jmp    80223d <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8021a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a3:	8b 00                	mov    (%eax),%eax
  8021a5:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8021a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ab:	8b 50 08             	mov    0x8(%eax),%edx
  8021ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b1:	8b 40 08             	mov    0x8(%eax),%eax
  8021b4:	39 c2                	cmp    %eax,%edx
  8021b6:	76 7d                	jbe    802235 <insert_sorted_allocList+0x251>
  8021b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bb:	8b 50 08             	mov    0x8(%eax),%edx
  8021be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8021c1:	8b 40 08             	mov    0x8(%eax),%eax
  8021c4:	39 c2                	cmp    %eax,%edx
  8021c6:	73 6d                	jae    802235 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8021c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021cc:	74 06                	je     8021d4 <insert_sorted_allocList+0x1f0>
  8021ce:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021d2:	75 14                	jne    8021e8 <insert_sorted_allocList+0x204>
  8021d4:	83 ec 04             	sub    $0x4,%esp
  8021d7:	68 90 40 80 00       	push   $0x804090
  8021dc:	6a 7f                	push   $0x7f
  8021de:	68 1b 40 80 00       	push   $0x80401b
  8021e3:	e8 d5 e0 ff ff       	call   8002bd <_panic>
  8021e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021eb:	8b 10                	mov    (%eax),%edx
  8021ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f0:	89 10                	mov    %edx,(%eax)
  8021f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f5:	8b 00                	mov    (%eax),%eax
  8021f7:	85 c0                	test   %eax,%eax
  8021f9:	74 0b                	je     802206 <insert_sorted_allocList+0x222>
  8021fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021fe:	8b 00                	mov    (%eax),%eax
  802200:	8b 55 08             	mov    0x8(%ebp),%edx
  802203:	89 50 04             	mov    %edx,0x4(%eax)
  802206:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802209:	8b 55 08             	mov    0x8(%ebp),%edx
  80220c:	89 10                	mov    %edx,(%eax)
  80220e:	8b 45 08             	mov    0x8(%ebp),%eax
  802211:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802214:	89 50 04             	mov    %edx,0x4(%eax)
  802217:	8b 45 08             	mov    0x8(%ebp),%eax
  80221a:	8b 00                	mov    (%eax),%eax
  80221c:	85 c0                	test   %eax,%eax
  80221e:	75 08                	jne    802228 <insert_sorted_allocList+0x244>
  802220:	8b 45 08             	mov    0x8(%ebp),%eax
  802223:	a3 44 50 80 00       	mov    %eax,0x805044
  802228:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80222d:	40                   	inc    %eax
  80222e:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802233:	eb 39                	jmp    80226e <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802235:	a1 48 50 80 00       	mov    0x805048,%eax
  80223a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80223d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802241:	74 07                	je     80224a <insert_sorted_allocList+0x266>
  802243:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802246:	8b 00                	mov    (%eax),%eax
  802248:	eb 05                	jmp    80224f <insert_sorted_allocList+0x26b>
  80224a:	b8 00 00 00 00       	mov    $0x0,%eax
  80224f:	a3 48 50 80 00       	mov    %eax,0x805048
  802254:	a1 48 50 80 00       	mov    0x805048,%eax
  802259:	85 c0                	test   %eax,%eax
  80225b:	0f 85 3f ff ff ff    	jne    8021a0 <insert_sorted_allocList+0x1bc>
  802261:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802265:	0f 85 35 ff ff ff    	jne    8021a0 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80226b:	eb 01                	jmp    80226e <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80226d:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80226e:	90                   	nop
  80226f:	c9                   	leave  
  802270:	c3                   	ret    

00802271 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802271:	55                   	push   %ebp
  802272:	89 e5                	mov    %esp,%ebp
  802274:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802277:	a1 38 51 80 00       	mov    0x805138,%eax
  80227c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80227f:	e9 85 01 00 00       	jmp    802409 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802284:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802287:	8b 40 0c             	mov    0xc(%eax),%eax
  80228a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80228d:	0f 82 6e 01 00 00    	jb     802401 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802293:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802296:	8b 40 0c             	mov    0xc(%eax),%eax
  802299:	3b 45 08             	cmp    0x8(%ebp),%eax
  80229c:	0f 85 8a 00 00 00    	jne    80232c <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8022a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022a6:	75 17                	jne    8022bf <alloc_block_FF+0x4e>
  8022a8:	83 ec 04             	sub    $0x4,%esp
  8022ab:	68 c4 40 80 00       	push   $0x8040c4
  8022b0:	68 93 00 00 00       	push   $0x93
  8022b5:	68 1b 40 80 00       	push   $0x80401b
  8022ba:	e8 fe df ff ff       	call   8002bd <_panic>
  8022bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c2:	8b 00                	mov    (%eax),%eax
  8022c4:	85 c0                	test   %eax,%eax
  8022c6:	74 10                	je     8022d8 <alloc_block_FF+0x67>
  8022c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022cb:	8b 00                	mov    (%eax),%eax
  8022cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022d0:	8b 52 04             	mov    0x4(%edx),%edx
  8022d3:	89 50 04             	mov    %edx,0x4(%eax)
  8022d6:	eb 0b                	jmp    8022e3 <alloc_block_FF+0x72>
  8022d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022db:	8b 40 04             	mov    0x4(%eax),%eax
  8022de:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8022e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e6:	8b 40 04             	mov    0x4(%eax),%eax
  8022e9:	85 c0                	test   %eax,%eax
  8022eb:	74 0f                	je     8022fc <alloc_block_FF+0x8b>
  8022ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f0:	8b 40 04             	mov    0x4(%eax),%eax
  8022f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022f6:	8b 12                	mov    (%edx),%edx
  8022f8:	89 10                	mov    %edx,(%eax)
  8022fa:	eb 0a                	jmp    802306 <alloc_block_FF+0x95>
  8022fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ff:	8b 00                	mov    (%eax),%eax
  802301:	a3 38 51 80 00       	mov    %eax,0x805138
  802306:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802309:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80230f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802312:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802319:	a1 44 51 80 00       	mov    0x805144,%eax
  80231e:	48                   	dec    %eax
  80231f:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802324:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802327:	e9 10 01 00 00       	jmp    80243c <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  80232c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232f:	8b 40 0c             	mov    0xc(%eax),%eax
  802332:	3b 45 08             	cmp    0x8(%ebp),%eax
  802335:	0f 86 c6 00 00 00    	jbe    802401 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80233b:	a1 48 51 80 00       	mov    0x805148,%eax
  802340:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802343:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802346:	8b 50 08             	mov    0x8(%eax),%edx
  802349:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80234c:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  80234f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802352:	8b 55 08             	mov    0x8(%ebp),%edx
  802355:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802358:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80235c:	75 17                	jne    802375 <alloc_block_FF+0x104>
  80235e:	83 ec 04             	sub    $0x4,%esp
  802361:	68 c4 40 80 00       	push   $0x8040c4
  802366:	68 9b 00 00 00       	push   $0x9b
  80236b:	68 1b 40 80 00       	push   $0x80401b
  802370:	e8 48 df ff ff       	call   8002bd <_panic>
  802375:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802378:	8b 00                	mov    (%eax),%eax
  80237a:	85 c0                	test   %eax,%eax
  80237c:	74 10                	je     80238e <alloc_block_FF+0x11d>
  80237e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802381:	8b 00                	mov    (%eax),%eax
  802383:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802386:	8b 52 04             	mov    0x4(%edx),%edx
  802389:	89 50 04             	mov    %edx,0x4(%eax)
  80238c:	eb 0b                	jmp    802399 <alloc_block_FF+0x128>
  80238e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802391:	8b 40 04             	mov    0x4(%eax),%eax
  802394:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802399:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80239c:	8b 40 04             	mov    0x4(%eax),%eax
  80239f:	85 c0                	test   %eax,%eax
  8023a1:	74 0f                	je     8023b2 <alloc_block_FF+0x141>
  8023a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023a6:	8b 40 04             	mov    0x4(%eax),%eax
  8023a9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023ac:	8b 12                	mov    (%edx),%edx
  8023ae:	89 10                	mov    %edx,(%eax)
  8023b0:	eb 0a                	jmp    8023bc <alloc_block_FF+0x14b>
  8023b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023b5:	8b 00                	mov    (%eax),%eax
  8023b7:	a3 48 51 80 00       	mov    %eax,0x805148
  8023bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023bf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023c8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023cf:	a1 54 51 80 00       	mov    0x805154,%eax
  8023d4:	48                   	dec    %eax
  8023d5:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  8023da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023dd:	8b 50 08             	mov    0x8(%eax),%edx
  8023e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e3:	01 c2                	add    %eax,%edx
  8023e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e8:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8023eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ee:	8b 40 0c             	mov    0xc(%eax),%eax
  8023f1:	2b 45 08             	sub    0x8(%ebp),%eax
  8023f4:	89 c2                	mov    %eax,%edx
  8023f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f9:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8023fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ff:	eb 3b                	jmp    80243c <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802401:	a1 40 51 80 00       	mov    0x805140,%eax
  802406:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802409:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80240d:	74 07                	je     802416 <alloc_block_FF+0x1a5>
  80240f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802412:	8b 00                	mov    (%eax),%eax
  802414:	eb 05                	jmp    80241b <alloc_block_FF+0x1aa>
  802416:	b8 00 00 00 00       	mov    $0x0,%eax
  80241b:	a3 40 51 80 00       	mov    %eax,0x805140
  802420:	a1 40 51 80 00       	mov    0x805140,%eax
  802425:	85 c0                	test   %eax,%eax
  802427:	0f 85 57 fe ff ff    	jne    802284 <alloc_block_FF+0x13>
  80242d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802431:	0f 85 4d fe ff ff    	jne    802284 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802437:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80243c:	c9                   	leave  
  80243d:	c3                   	ret    

0080243e <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80243e:	55                   	push   %ebp
  80243f:	89 e5                	mov    %esp,%ebp
  802441:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802444:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80244b:	a1 38 51 80 00       	mov    0x805138,%eax
  802450:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802453:	e9 df 00 00 00       	jmp    802537 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802458:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245b:	8b 40 0c             	mov    0xc(%eax),%eax
  80245e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802461:	0f 82 c8 00 00 00    	jb     80252f <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802467:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246a:	8b 40 0c             	mov    0xc(%eax),%eax
  80246d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802470:	0f 85 8a 00 00 00    	jne    802500 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802476:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80247a:	75 17                	jne    802493 <alloc_block_BF+0x55>
  80247c:	83 ec 04             	sub    $0x4,%esp
  80247f:	68 c4 40 80 00       	push   $0x8040c4
  802484:	68 b7 00 00 00       	push   $0xb7
  802489:	68 1b 40 80 00       	push   $0x80401b
  80248e:	e8 2a de ff ff       	call   8002bd <_panic>
  802493:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802496:	8b 00                	mov    (%eax),%eax
  802498:	85 c0                	test   %eax,%eax
  80249a:	74 10                	je     8024ac <alloc_block_BF+0x6e>
  80249c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249f:	8b 00                	mov    (%eax),%eax
  8024a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024a4:	8b 52 04             	mov    0x4(%edx),%edx
  8024a7:	89 50 04             	mov    %edx,0x4(%eax)
  8024aa:	eb 0b                	jmp    8024b7 <alloc_block_BF+0x79>
  8024ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024af:	8b 40 04             	mov    0x4(%eax),%eax
  8024b2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8024b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ba:	8b 40 04             	mov    0x4(%eax),%eax
  8024bd:	85 c0                	test   %eax,%eax
  8024bf:	74 0f                	je     8024d0 <alloc_block_BF+0x92>
  8024c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c4:	8b 40 04             	mov    0x4(%eax),%eax
  8024c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024ca:	8b 12                	mov    (%edx),%edx
  8024cc:	89 10                	mov    %edx,(%eax)
  8024ce:	eb 0a                	jmp    8024da <alloc_block_BF+0x9c>
  8024d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d3:	8b 00                	mov    (%eax),%eax
  8024d5:	a3 38 51 80 00       	mov    %eax,0x805138
  8024da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024ed:	a1 44 51 80 00       	mov    0x805144,%eax
  8024f2:	48                   	dec    %eax
  8024f3:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  8024f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fb:	e9 4d 01 00 00       	jmp    80264d <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802500:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802503:	8b 40 0c             	mov    0xc(%eax),%eax
  802506:	3b 45 08             	cmp    0x8(%ebp),%eax
  802509:	76 24                	jbe    80252f <alloc_block_BF+0xf1>
  80250b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250e:	8b 40 0c             	mov    0xc(%eax),%eax
  802511:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802514:	73 19                	jae    80252f <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802516:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  80251d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802520:	8b 40 0c             	mov    0xc(%eax),%eax
  802523:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802526:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802529:	8b 40 08             	mov    0x8(%eax),%eax
  80252c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80252f:	a1 40 51 80 00       	mov    0x805140,%eax
  802534:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802537:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80253b:	74 07                	je     802544 <alloc_block_BF+0x106>
  80253d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802540:	8b 00                	mov    (%eax),%eax
  802542:	eb 05                	jmp    802549 <alloc_block_BF+0x10b>
  802544:	b8 00 00 00 00       	mov    $0x0,%eax
  802549:	a3 40 51 80 00       	mov    %eax,0x805140
  80254e:	a1 40 51 80 00       	mov    0x805140,%eax
  802553:	85 c0                	test   %eax,%eax
  802555:	0f 85 fd fe ff ff    	jne    802458 <alloc_block_BF+0x1a>
  80255b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80255f:	0f 85 f3 fe ff ff    	jne    802458 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802565:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802569:	0f 84 d9 00 00 00    	je     802648 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  80256f:	a1 48 51 80 00       	mov    0x805148,%eax
  802574:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802577:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80257a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80257d:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802580:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802583:	8b 55 08             	mov    0x8(%ebp),%edx
  802586:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802589:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80258d:	75 17                	jne    8025a6 <alloc_block_BF+0x168>
  80258f:	83 ec 04             	sub    $0x4,%esp
  802592:	68 c4 40 80 00       	push   $0x8040c4
  802597:	68 c7 00 00 00       	push   $0xc7
  80259c:	68 1b 40 80 00       	push   $0x80401b
  8025a1:	e8 17 dd ff ff       	call   8002bd <_panic>
  8025a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025a9:	8b 00                	mov    (%eax),%eax
  8025ab:	85 c0                	test   %eax,%eax
  8025ad:	74 10                	je     8025bf <alloc_block_BF+0x181>
  8025af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025b2:	8b 00                	mov    (%eax),%eax
  8025b4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025b7:	8b 52 04             	mov    0x4(%edx),%edx
  8025ba:	89 50 04             	mov    %edx,0x4(%eax)
  8025bd:	eb 0b                	jmp    8025ca <alloc_block_BF+0x18c>
  8025bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025c2:	8b 40 04             	mov    0x4(%eax),%eax
  8025c5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8025ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025cd:	8b 40 04             	mov    0x4(%eax),%eax
  8025d0:	85 c0                	test   %eax,%eax
  8025d2:	74 0f                	je     8025e3 <alloc_block_BF+0x1a5>
  8025d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025d7:	8b 40 04             	mov    0x4(%eax),%eax
  8025da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025dd:	8b 12                	mov    (%edx),%edx
  8025df:	89 10                	mov    %edx,(%eax)
  8025e1:	eb 0a                	jmp    8025ed <alloc_block_BF+0x1af>
  8025e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025e6:	8b 00                	mov    (%eax),%eax
  8025e8:	a3 48 51 80 00       	mov    %eax,0x805148
  8025ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025f9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802600:	a1 54 51 80 00       	mov    0x805154,%eax
  802605:	48                   	dec    %eax
  802606:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  80260b:	83 ec 08             	sub    $0x8,%esp
  80260e:	ff 75 ec             	pushl  -0x14(%ebp)
  802611:	68 38 51 80 00       	push   $0x805138
  802616:	e8 71 f9 ff ff       	call   801f8c <find_block>
  80261b:	83 c4 10             	add    $0x10,%esp
  80261e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802621:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802624:	8b 50 08             	mov    0x8(%eax),%edx
  802627:	8b 45 08             	mov    0x8(%ebp),%eax
  80262a:	01 c2                	add    %eax,%edx
  80262c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80262f:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802632:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802635:	8b 40 0c             	mov    0xc(%eax),%eax
  802638:	2b 45 08             	sub    0x8(%ebp),%eax
  80263b:	89 c2                	mov    %eax,%edx
  80263d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802640:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802643:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802646:	eb 05                	jmp    80264d <alloc_block_BF+0x20f>
	}
	return NULL;
  802648:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80264d:	c9                   	leave  
  80264e:	c3                   	ret    

0080264f <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  80264f:	55                   	push   %ebp
  802650:	89 e5                	mov    %esp,%ebp
  802652:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802655:	a1 28 50 80 00       	mov    0x805028,%eax
  80265a:	85 c0                	test   %eax,%eax
  80265c:	0f 85 de 01 00 00    	jne    802840 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802662:	a1 38 51 80 00       	mov    0x805138,%eax
  802667:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80266a:	e9 9e 01 00 00       	jmp    80280d <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  80266f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802672:	8b 40 0c             	mov    0xc(%eax),%eax
  802675:	3b 45 08             	cmp    0x8(%ebp),%eax
  802678:	0f 82 87 01 00 00    	jb     802805 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  80267e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802681:	8b 40 0c             	mov    0xc(%eax),%eax
  802684:	3b 45 08             	cmp    0x8(%ebp),%eax
  802687:	0f 85 95 00 00 00    	jne    802722 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  80268d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802691:	75 17                	jne    8026aa <alloc_block_NF+0x5b>
  802693:	83 ec 04             	sub    $0x4,%esp
  802696:	68 c4 40 80 00       	push   $0x8040c4
  80269b:	68 e0 00 00 00       	push   $0xe0
  8026a0:	68 1b 40 80 00       	push   $0x80401b
  8026a5:	e8 13 dc ff ff       	call   8002bd <_panic>
  8026aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ad:	8b 00                	mov    (%eax),%eax
  8026af:	85 c0                	test   %eax,%eax
  8026b1:	74 10                	je     8026c3 <alloc_block_NF+0x74>
  8026b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b6:	8b 00                	mov    (%eax),%eax
  8026b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026bb:	8b 52 04             	mov    0x4(%edx),%edx
  8026be:	89 50 04             	mov    %edx,0x4(%eax)
  8026c1:	eb 0b                	jmp    8026ce <alloc_block_NF+0x7f>
  8026c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c6:	8b 40 04             	mov    0x4(%eax),%eax
  8026c9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8026ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d1:	8b 40 04             	mov    0x4(%eax),%eax
  8026d4:	85 c0                	test   %eax,%eax
  8026d6:	74 0f                	je     8026e7 <alloc_block_NF+0x98>
  8026d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026db:	8b 40 04             	mov    0x4(%eax),%eax
  8026de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026e1:	8b 12                	mov    (%edx),%edx
  8026e3:	89 10                	mov    %edx,(%eax)
  8026e5:	eb 0a                	jmp    8026f1 <alloc_block_NF+0xa2>
  8026e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ea:	8b 00                	mov    (%eax),%eax
  8026ec:	a3 38 51 80 00       	mov    %eax,0x805138
  8026f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802704:	a1 44 51 80 00       	mov    0x805144,%eax
  802709:	48                   	dec    %eax
  80270a:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  80270f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802712:	8b 40 08             	mov    0x8(%eax),%eax
  802715:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  80271a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271d:	e9 f8 04 00 00       	jmp    802c1a <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802722:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802725:	8b 40 0c             	mov    0xc(%eax),%eax
  802728:	3b 45 08             	cmp    0x8(%ebp),%eax
  80272b:	0f 86 d4 00 00 00    	jbe    802805 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802731:	a1 48 51 80 00       	mov    0x805148,%eax
  802736:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802739:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273c:	8b 50 08             	mov    0x8(%eax),%edx
  80273f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802742:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802745:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802748:	8b 55 08             	mov    0x8(%ebp),%edx
  80274b:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80274e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802752:	75 17                	jne    80276b <alloc_block_NF+0x11c>
  802754:	83 ec 04             	sub    $0x4,%esp
  802757:	68 c4 40 80 00       	push   $0x8040c4
  80275c:	68 e9 00 00 00       	push   $0xe9
  802761:	68 1b 40 80 00       	push   $0x80401b
  802766:	e8 52 db ff ff       	call   8002bd <_panic>
  80276b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80276e:	8b 00                	mov    (%eax),%eax
  802770:	85 c0                	test   %eax,%eax
  802772:	74 10                	je     802784 <alloc_block_NF+0x135>
  802774:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802777:	8b 00                	mov    (%eax),%eax
  802779:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80277c:	8b 52 04             	mov    0x4(%edx),%edx
  80277f:	89 50 04             	mov    %edx,0x4(%eax)
  802782:	eb 0b                	jmp    80278f <alloc_block_NF+0x140>
  802784:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802787:	8b 40 04             	mov    0x4(%eax),%eax
  80278a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80278f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802792:	8b 40 04             	mov    0x4(%eax),%eax
  802795:	85 c0                	test   %eax,%eax
  802797:	74 0f                	je     8027a8 <alloc_block_NF+0x159>
  802799:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80279c:	8b 40 04             	mov    0x4(%eax),%eax
  80279f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027a2:	8b 12                	mov    (%edx),%edx
  8027a4:	89 10                	mov    %edx,(%eax)
  8027a6:	eb 0a                	jmp    8027b2 <alloc_block_NF+0x163>
  8027a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ab:	8b 00                	mov    (%eax),%eax
  8027ad:	a3 48 51 80 00       	mov    %eax,0x805148
  8027b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027b5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027be:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027c5:	a1 54 51 80 00       	mov    0x805154,%eax
  8027ca:	48                   	dec    %eax
  8027cb:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  8027d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027d3:	8b 40 08             	mov    0x8(%eax),%eax
  8027d6:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  8027db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027de:	8b 50 08             	mov    0x8(%eax),%edx
  8027e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e4:	01 c2                	add    %eax,%edx
  8027e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e9:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  8027ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ef:	8b 40 0c             	mov    0xc(%eax),%eax
  8027f2:	2b 45 08             	sub    0x8(%ebp),%eax
  8027f5:	89 c2                	mov    %eax,%edx
  8027f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fa:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8027fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802800:	e9 15 04 00 00       	jmp    802c1a <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802805:	a1 40 51 80 00       	mov    0x805140,%eax
  80280a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80280d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802811:	74 07                	je     80281a <alloc_block_NF+0x1cb>
  802813:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802816:	8b 00                	mov    (%eax),%eax
  802818:	eb 05                	jmp    80281f <alloc_block_NF+0x1d0>
  80281a:	b8 00 00 00 00       	mov    $0x0,%eax
  80281f:	a3 40 51 80 00       	mov    %eax,0x805140
  802824:	a1 40 51 80 00       	mov    0x805140,%eax
  802829:	85 c0                	test   %eax,%eax
  80282b:	0f 85 3e fe ff ff    	jne    80266f <alloc_block_NF+0x20>
  802831:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802835:	0f 85 34 fe ff ff    	jne    80266f <alloc_block_NF+0x20>
  80283b:	e9 d5 03 00 00       	jmp    802c15 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802840:	a1 38 51 80 00       	mov    0x805138,%eax
  802845:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802848:	e9 b1 01 00 00       	jmp    8029fe <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  80284d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802850:	8b 50 08             	mov    0x8(%eax),%edx
  802853:	a1 28 50 80 00       	mov    0x805028,%eax
  802858:	39 c2                	cmp    %eax,%edx
  80285a:	0f 82 96 01 00 00    	jb     8029f6 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802860:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802863:	8b 40 0c             	mov    0xc(%eax),%eax
  802866:	3b 45 08             	cmp    0x8(%ebp),%eax
  802869:	0f 82 87 01 00 00    	jb     8029f6 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  80286f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802872:	8b 40 0c             	mov    0xc(%eax),%eax
  802875:	3b 45 08             	cmp    0x8(%ebp),%eax
  802878:	0f 85 95 00 00 00    	jne    802913 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80287e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802882:	75 17                	jne    80289b <alloc_block_NF+0x24c>
  802884:	83 ec 04             	sub    $0x4,%esp
  802887:	68 c4 40 80 00       	push   $0x8040c4
  80288c:	68 fc 00 00 00       	push   $0xfc
  802891:	68 1b 40 80 00       	push   $0x80401b
  802896:	e8 22 da ff ff       	call   8002bd <_panic>
  80289b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289e:	8b 00                	mov    (%eax),%eax
  8028a0:	85 c0                	test   %eax,%eax
  8028a2:	74 10                	je     8028b4 <alloc_block_NF+0x265>
  8028a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a7:	8b 00                	mov    (%eax),%eax
  8028a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028ac:	8b 52 04             	mov    0x4(%edx),%edx
  8028af:	89 50 04             	mov    %edx,0x4(%eax)
  8028b2:	eb 0b                	jmp    8028bf <alloc_block_NF+0x270>
  8028b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b7:	8b 40 04             	mov    0x4(%eax),%eax
  8028ba:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8028bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c2:	8b 40 04             	mov    0x4(%eax),%eax
  8028c5:	85 c0                	test   %eax,%eax
  8028c7:	74 0f                	je     8028d8 <alloc_block_NF+0x289>
  8028c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cc:	8b 40 04             	mov    0x4(%eax),%eax
  8028cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028d2:	8b 12                	mov    (%edx),%edx
  8028d4:	89 10                	mov    %edx,(%eax)
  8028d6:	eb 0a                	jmp    8028e2 <alloc_block_NF+0x293>
  8028d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028db:	8b 00                	mov    (%eax),%eax
  8028dd:	a3 38 51 80 00       	mov    %eax,0x805138
  8028e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028f5:	a1 44 51 80 00       	mov    0x805144,%eax
  8028fa:	48                   	dec    %eax
  8028fb:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802900:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802903:	8b 40 08             	mov    0x8(%eax),%eax
  802906:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  80290b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290e:	e9 07 03 00 00       	jmp    802c1a <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802913:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802916:	8b 40 0c             	mov    0xc(%eax),%eax
  802919:	3b 45 08             	cmp    0x8(%ebp),%eax
  80291c:	0f 86 d4 00 00 00    	jbe    8029f6 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802922:	a1 48 51 80 00       	mov    0x805148,%eax
  802927:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  80292a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292d:	8b 50 08             	mov    0x8(%eax),%edx
  802930:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802933:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802936:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802939:	8b 55 08             	mov    0x8(%ebp),%edx
  80293c:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80293f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802943:	75 17                	jne    80295c <alloc_block_NF+0x30d>
  802945:	83 ec 04             	sub    $0x4,%esp
  802948:	68 c4 40 80 00       	push   $0x8040c4
  80294d:	68 04 01 00 00       	push   $0x104
  802952:	68 1b 40 80 00       	push   $0x80401b
  802957:	e8 61 d9 ff ff       	call   8002bd <_panic>
  80295c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80295f:	8b 00                	mov    (%eax),%eax
  802961:	85 c0                	test   %eax,%eax
  802963:	74 10                	je     802975 <alloc_block_NF+0x326>
  802965:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802968:	8b 00                	mov    (%eax),%eax
  80296a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80296d:	8b 52 04             	mov    0x4(%edx),%edx
  802970:	89 50 04             	mov    %edx,0x4(%eax)
  802973:	eb 0b                	jmp    802980 <alloc_block_NF+0x331>
  802975:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802978:	8b 40 04             	mov    0x4(%eax),%eax
  80297b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802980:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802983:	8b 40 04             	mov    0x4(%eax),%eax
  802986:	85 c0                	test   %eax,%eax
  802988:	74 0f                	je     802999 <alloc_block_NF+0x34a>
  80298a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80298d:	8b 40 04             	mov    0x4(%eax),%eax
  802990:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802993:	8b 12                	mov    (%edx),%edx
  802995:	89 10                	mov    %edx,(%eax)
  802997:	eb 0a                	jmp    8029a3 <alloc_block_NF+0x354>
  802999:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80299c:	8b 00                	mov    (%eax),%eax
  80299e:	a3 48 51 80 00       	mov    %eax,0x805148
  8029a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029a6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029af:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029b6:	a1 54 51 80 00       	mov    0x805154,%eax
  8029bb:	48                   	dec    %eax
  8029bc:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  8029c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029c4:	8b 40 08             	mov    0x8(%eax),%eax
  8029c7:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  8029cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029cf:	8b 50 08             	mov    0x8(%eax),%edx
  8029d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d5:	01 c2                	add    %eax,%edx
  8029d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029da:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8029dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e0:	8b 40 0c             	mov    0xc(%eax),%eax
  8029e3:	2b 45 08             	sub    0x8(%ebp),%eax
  8029e6:	89 c2                	mov    %eax,%edx
  8029e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029eb:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8029ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029f1:	e9 24 02 00 00       	jmp    802c1a <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8029f6:	a1 40 51 80 00       	mov    0x805140,%eax
  8029fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a02:	74 07                	je     802a0b <alloc_block_NF+0x3bc>
  802a04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a07:	8b 00                	mov    (%eax),%eax
  802a09:	eb 05                	jmp    802a10 <alloc_block_NF+0x3c1>
  802a0b:	b8 00 00 00 00       	mov    $0x0,%eax
  802a10:	a3 40 51 80 00       	mov    %eax,0x805140
  802a15:	a1 40 51 80 00       	mov    0x805140,%eax
  802a1a:	85 c0                	test   %eax,%eax
  802a1c:	0f 85 2b fe ff ff    	jne    80284d <alloc_block_NF+0x1fe>
  802a22:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a26:	0f 85 21 fe ff ff    	jne    80284d <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a2c:	a1 38 51 80 00       	mov    0x805138,%eax
  802a31:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a34:	e9 ae 01 00 00       	jmp    802be7 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802a39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3c:	8b 50 08             	mov    0x8(%eax),%edx
  802a3f:	a1 28 50 80 00       	mov    0x805028,%eax
  802a44:	39 c2                	cmp    %eax,%edx
  802a46:	0f 83 93 01 00 00    	jae    802bdf <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802a4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4f:	8b 40 0c             	mov    0xc(%eax),%eax
  802a52:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a55:	0f 82 84 01 00 00    	jb     802bdf <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802a5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5e:	8b 40 0c             	mov    0xc(%eax),%eax
  802a61:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a64:	0f 85 95 00 00 00    	jne    802aff <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802a6a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a6e:	75 17                	jne    802a87 <alloc_block_NF+0x438>
  802a70:	83 ec 04             	sub    $0x4,%esp
  802a73:	68 c4 40 80 00       	push   $0x8040c4
  802a78:	68 14 01 00 00       	push   $0x114
  802a7d:	68 1b 40 80 00       	push   $0x80401b
  802a82:	e8 36 d8 ff ff       	call   8002bd <_panic>
  802a87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8a:	8b 00                	mov    (%eax),%eax
  802a8c:	85 c0                	test   %eax,%eax
  802a8e:	74 10                	je     802aa0 <alloc_block_NF+0x451>
  802a90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a93:	8b 00                	mov    (%eax),%eax
  802a95:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a98:	8b 52 04             	mov    0x4(%edx),%edx
  802a9b:	89 50 04             	mov    %edx,0x4(%eax)
  802a9e:	eb 0b                	jmp    802aab <alloc_block_NF+0x45c>
  802aa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa3:	8b 40 04             	mov    0x4(%eax),%eax
  802aa6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802aab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aae:	8b 40 04             	mov    0x4(%eax),%eax
  802ab1:	85 c0                	test   %eax,%eax
  802ab3:	74 0f                	je     802ac4 <alloc_block_NF+0x475>
  802ab5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab8:	8b 40 04             	mov    0x4(%eax),%eax
  802abb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802abe:	8b 12                	mov    (%edx),%edx
  802ac0:	89 10                	mov    %edx,(%eax)
  802ac2:	eb 0a                	jmp    802ace <alloc_block_NF+0x47f>
  802ac4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac7:	8b 00                	mov    (%eax),%eax
  802ac9:	a3 38 51 80 00       	mov    %eax,0x805138
  802ace:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ad7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ada:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ae1:	a1 44 51 80 00       	mov    0x805144,%eax
  802ae6:	48                   	dec    %eax
  802ae7:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802aec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aef:	8b 40 08             	mov    0x8(%eax),%eax
  802af2:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802af7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afa:	e9 1b 01 00 00       	jmp    802c1a <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802aff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b02:	8b 40 0c             	mov    0xc(%eax),%eax
  802b05:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b08:	0f 86 d1 00 00 00    	jbe    802bdf <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b0e:	a1 48 51 80 00       	mov    0x805148,%eax
  802b13:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802b16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b19:	8b 50 08             	mov    0x8(%eax),%edx
  802b1c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b1f:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802b22:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b25:	8b 55 08             	mov    0x8(%ebp),%edx
  802b28:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b2b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b2f:	75 17                	jne    802b48 <alloc_block_NF+0x4f9>
  802b31:	83 ec 04             	sub    $0x4,%esp
  802b34:	68 c4 40 80 00       	push   $0x8040c4
  802b39:	68 1c 01 00 00       	push   $0x11c
  802b3e:	68 1b 40 80 00       	push   $0x80401b
  802b43:	e8 75 d7 ff ff       	call   8002bd <_panic>
  802b48:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b4b:	8b 00                	mov    (%eax),%eax
  802b4d:	85 c0                	test   %eax,%eax
  802b4f:	74 10                	je     802b61 <alloc_block_NF+0x512>
  802b51:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b54:	8b 00                	mov    (%eax),%eax
  802b56:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b59:	8b 52 04             	mov    0x4(%edx),%edx
  802b5c:	89 50 04             	mov    %edx,0x4(%eax)
  802b5f:	eb 0b                	jmp    802b6c <alloc_block_NF+0x51d>
  802b61:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b64:	8b 40 04             	mov    0x4(%eax),%eax
  802b67:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b6f:	8b 40 04             	mov    0x4(%eax),%eax
  802b72:	85 c0                	test   %eax,%eax
  802b74:	74 0f                	je     802b85 <alloc_block_NF+0x536>
  802b76:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b79:	8b 40 04             	mov    0x4(%eax),%eax
  802b7c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b7f:	8b 12                	mov    (%edx),%edx
  802b81:	89 10                	mov    %edx,(%eax)
  802b83:	eb 0a                	jmp    802b8f <alloc_block_NF+0x540>
  802b85:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b88:	8b 00                	mov    (%eax),%eax
  802b8a:	a3 48 51 80 00       	mov    %eax,0x805148
  802b8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b92:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b98:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b9b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ba2:	a1 54 51 80 00       	mov    0x805154,%eax
  802ba7:	48                   	dec    %eax
  802ba8:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802bad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bb0:	8b 40 08             	mov    0x8(%eax),%eax
  802bb3:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802bb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbb:	8b 50 08             	mov    0x8(%eax),%edx
  802bbe:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc1:	01 c2                	add    %eax,%edx
  802bc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc6:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802bc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcc:	8b 40 0c             	mov    0xc(%eax),%eax
  802bcf:	2b 45 08             	sub    0x8(%ebp),%eax
  802bd2:	89 c2                	mov    %eax,%edx
  802bd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd7:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802bda:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bdd:	eb 3b                	jmp    802c1a <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802bdf:	a1 40 51 80 00       	mov    0x805140,%eax
  802be4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802be7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802beb:	74 07                	je     802bf4 <alloc_block_NF+0x5a5>
  802bed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf0:	8b 00                	mov    (%eax),%eax
  802bf2:	eb 05                	jmp    802bf9 <alloc_block_NF+0x5aa>
  802bf4:	b8 00 00 00 00       	mov    $0x0,%eax
  802bf9:	a3 40 51 80 00       	mov    %eax,0x805140
  802bfe:	a1 40 51 80 00       	mov    0x805140,%eax
  802c03:	85 c0                	test   %eax,%eax
  802c05:	0f 85 2e fe ff ff    	jne    802a39 <alloc_block_NF+0x3ea>
  802c0b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c0f:	0f 85 24 fe ff ff    	jne    802a39 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802c15:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c1a:	c9                   	leave  
  802c1b:	c3                   	ret    

00802c1c <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802c1c:	55                   	push   %ebp
  802c1d:	89 e5                	mov    %esp,%ebp
  802c1f:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802c22:	a1 38 51 80 00       	mov    0x805138,%eax
  802c27:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802c2a:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802c2f:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802c32:	a1 38 51 80 00       	mov    0x805138,%eax
  802c37:	85 c0                	test   %eax,%eax
  802c39:	74 14                	je     802c4f <insert_sorted_with_merge_freeList+0x33>
  802c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3e:	8b 50 08             	mov    0x8(%eax),%edx
  802c41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c44:	8b 40 08             	mov    0x8(%eax),%eax
  802c47:	39 c2                	cmp    %eax,%edx
  802c49:	0f 87 9b 01 00 00    	ja     802dea <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802c4f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c53:	75 17                	jne    802c6c <insert_sorted_with_merge_freeList+0x50>
  802c55:	83 ec 04             	sub    $0x4,%esp
  802c58:	68 f8 3f 80 00       	push   $0x803ff8
  802c5d:	68 38 01 00 00       	push   $0x138
  802c62:	68 1b 40 80 00       	push   $0x80401b
  802c67:	e8 51 d6 ff ff       	call   8002bd <_panic>
  802c6c:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802c72:	8b 45 08             	mov    0x8(%ebp),%eax
  802c75:	89 10                	mov    %edx,(%eax)
  802c77:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7a:	8b 00                	mov    (%eax),%eax
  802c7c:	85 c0                	test   %eax,%eax
  802c7e:	74 0d                	je     802c8d <insert_sorted_with_merge_freeList+0x71>
  802c80:	a1 38 51 80 00       	mov    0x805138,%eax
  802c85:	8b 55 08             	mov    0x8(%ebp),%edx
  802c88:	89 50 04             	mov    %edx,0x4(%eax)
  802c8b:	eb 08                	jmp    802c95 <insert_sorted_with_merge_freeList+0x79>
  802c8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c90:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c95:	8b 45 08             	mov    0x8(%ebp),%eax
  802c98:	a3 38 51 80 00       	mov    %eax,0x805138
  802c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ca7:	a1 44 51 80 00       	mov    0x805144,%eax
  802cac:	40                   	inc    %eax
  802cad:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802cb2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cb6:	0f 84 a8 06 00 00    	je     803364 <insert_sorted_with_merge_freeList+0x748>
  802cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbf:	8b 50 08             	mov    0x8(%eax),%edx
  802cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc5:	8b 40 0c             	mov    0xc(%eax),%eax
  802cc8:	01 c2                	add    %eax,%edx
  802cca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ccd:	8b 40 08             	mov    0x8(%eax),%eax
  802cd0:	39 c2                	cmp    %eax,%edx
  802cd2:	0f 85 8c 06 00 00    	jne    803364 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  802cdb:	8b 50 0c             	mov    0xc(%eax),%edx
  802cde:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ce1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ce4:	01 c2                	add    %eax,%edx
  802ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce9:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802cec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cf0:	75 17                	jne    802d09 <insert_sorted_with_merge_freeList+0xed>
  802cf2:	83 ec 04             	sub    $0x4,%esp
  802cf5:	68 c4 40 80 00       	push   $0x8040c4
  802cfa:	68 3c 01 00 00       	push   $0x13c
  802cff:	68 1b 40 80 00       	push   $0x80401b
  802d04:	e8 b4 d5 ff ff       	call   8002bd <_panic>
  802d09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d0c:	8b 00                	mov    (%eax),%eax
  802d0e:	85 c0                	test   %eax,%eax
  802d10:	74 10                	je     802d22 <insert_sorted_with_merge_freeList+0x106>
  802d12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d15:	8b 00                	mov    (%eax),%eax
  802d17:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d1a:	8b 52 04             	mov    0x4(%edx),%edx
  802d1d:	89 50 04             	mov    %edx,0x4(%eax)
  802d20:	eb 0b                	jmp    802d2d <insert_sorted_with_merge_freeList+0x111>
  802d22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d25:	8b 40 04             	mov    0x4(%eax),%eax
  802d28:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d30:	8b 40 04             	mov    0x4(%eax),%eax
  802d33:	85 c0                	test   %eax,%eax
  802d35:	74 0f                	je     802d46 <insert_sorted_with_merge_freeList+0x12a>
  802d37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d3a:	8b 40 04             	mov    0x4(%eax),%eax
  802d3d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d40:	8b 12                	mov    (%edx),%edx
  802d42:	89 10                	mov    %edx,(%eax)
  802d44:	eb 0a                	jmp    802d50 <insert_sorted_with_merge_freeList+0x134>
  802d46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d49:	8b 00                	mov    (%eax),%eax
  802d4b:	a3 38 51 80 00       	mov    %eax,0x805138
  802d50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d53:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d5c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d63:	a1 44 51 80 00       	mov    0x805144,%eax
  802d68:	48                   	dec    %eax
  802d69:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802d6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d71:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802d78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d7b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802d82:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d86:	75 17                	jne    802d9f <insert_sorted_with_merge_freeList+0x183>
  802d88:	83 ec 04             	sub    $0x4,%esp
  802d8b:	68 f8 3f 80 00       	push   $0x803ff8
  802d90:	68 3f 01 00 00       	push   $0x13f
  802d95:	68 1b 40 80 00       	push   $0x80401b
  802d9a:	e8 1e d5 ff ff       	call   8002bd <_panic>
  802d9f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802da5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da8:	89 10                	mov    %edx,(%eax)
  802daa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dad:	8b 00                	mov    (%eax),%eax
  802daf:	85 c0                	test   %eax,%eax
  802db1:	74 0d                	je     802dc0 <insert_sorted_with_merge_freeList+0x1a4>
  802db3:	a1 48 51 80 00       	mov    0x805148,%eax
  802db8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802dbb:	89 50 04             	mov    %edx,0x4(%eax)
  802dbe:	eb 08                	jmp    802dc8 <insert_sorted_with_merge_freeList+0x1ac>
  802dc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802dc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dcb:	a3 48 51 80 00       	mov    %eax,0x805148
  802dd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dd3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dda:	a1 54 51 80 00       	mov    0x805154,%eax
  802ddf:	40                   	inc    %eax
  802de0:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802de5:	e9 7a 05 00 00       	jmp    803364 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802dea:	8b 45 08             	mov    0x8(%ebp),%eax
  802ded:	8b 50 08             	mov    0x8(%eax),%edx
  802df0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802df3:	8b 40 08             	mov    0x8(%eax),%eax
  802df6:	39 c2                	cmp    %eax,%edx
  802df8:	0f 82 14 01 00 00    	jb     802f12 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802dfe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e01:	8b 50 08             	mov    0x8(%eax),%edx
  802e04:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e07:	8b 40 0c             	mov    0xc(%eax),%eax
  802e0a:	01 c2                	add    %eax,%edx
  802e0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0f:	8b 40 08             	mov    0x8(%eax),%eax
  802e12:	39 c2                	cmp    %eax,%edx
  802e14:	0f 85 90 00 00 00    	jne    802eaa <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802e1a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e1d:	8b 50 0c             	mov    0xc(%eax),%edx
  802e20:	8b 45 08             	mov    0x8(%ebp),%eax
  802e23:	8b 40 0c             	mov    0xc(%eax),%eax
  802e26:	01 c2                	add    %eax,%edx
  802e28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e2b:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e31:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802e38:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802e42:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e46:	75 17                	jne    802e5f <insert_sorted_with_merge_freeList+0x243>
  802e48:	83 ec 04             	sub    $0x4,%esp
  802e4b:	68 f8 3f 80 00       	push   $0x803ff8
  802e50:	68 49 01 00 00       	push   $0x149
  802e55:	68 1b 40 80 00       	push   $0x80401b
  802e5a:	e8 5e d4 ff ff       	call   8002bd <_panic>
  802e5f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802e65:	8b 45 08             	mov    0x8(%ebp),%eax
  802e68:	89 10                	mov    %edx,(%eax)
  802e6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6d:	8b 00                	mov    (%eax),%eax
  802e6f:	85 c0                	test   %eax,%eax
  802e71:	74 0d                	je     802e80 <insert_sorted_with_merge_freeList+0x264>
  802e73:	a1 48 51 80 00       	mov    0x805148,%eax
  802e78:	8b 55 08             	mov    0x8(%ebp),%edx
  802e7b:	89 50 04             	mov    %edx,0x4(%eax)
  802e7e:	eb 08                	jmp    802e88 <insert_sorted_with_merge_freeList+0x26c>
  802e80:	8b 45 08             	mov    0x8(%ebp),%eax
  802e83:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e88:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8b:	a3 48 51 80 00       	mov    %eax,0x805148
  802e90:	8b 45 08             	mov    0x8(%ebp),%eax
  802e93:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e9a:	a1 54 51 80 00       	mov    0x805154,%eax
  802e9f:	40                   	inc    %eax
  802ea0:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802ea5:	e9 bb 04 00 00       	jmp    803365 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802eaa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802eae:	75 17                	jne    802ec7 <insert_sorted_with_merge_freeList+0x2ab>
  802eb0:	83 ec 04             	sub    $0x4,%esp
  802eb3:	68 6c 40 80 00       	push   $0x80406c
  802eb8:	68 4c 01 00 00       	push   $0x14c
  802ebd:	68 1b 40 80 00       	push   $0x80401b
  802ec2:	e8 f6 d3 ff ff       	call   8002bd <_panic>
  802ec7:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802ecd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed0:	89 50 04             	mov    %edx,0x4(%eax)
  802ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed6:	8b 40 04             	mov    0x4(%eax),%eax
  802ed9:	85 c0                	test   %eax,%eax
  802edb:	74 0c                	je     802ee9 <insert_sorted_with_merge_freeList+0x2cd>
  802edd:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802ee2:	8b 55 08             	mov    0x8(%ebp),%edx
  802ee5:	89 10                	mov    %edx,(%eax)
  802ee7:	eb 08                	jmp    802ef1 <insert_sorted_with_merge_freeList+0x2d5>
  802ee9:	8b 45 08             	mov    0x8(%ebp),%eax
  802eec:	a3 38 51 80 00       	mov    %eax,0x805138
  802ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  802efc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f02:	a1 44 51 80 00       	mov    0x805144,%eax
  802f07:	40                   	inc    %eax
  802f08:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802f0d:	e9 53 04 00 00       	jmp    803365 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802f12:	a1 38 51 80 00       	mov    0x805138,%eax
  802f17:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f1a:	e9 15 04 00 00       	jmp    803334 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802f1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f22:	8b 00                	mov    (%eax),%eax
  802f24:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802f27:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2a:	8b 50 08             	mov    0x8(%eax),%edx
  802f2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f30:	8b 40 08             	mov    0x8(%eax),%eax
  802f33:	39 c2                	cmp    %eax,%edx
  802f35:	0f 86 f1 03 00 00    	jbe    80332c <insert_sorted_with_merge_freeList+0x710>
  802f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3e:	8b 50 08             	mov    0x8(%eax),%edx
  802f41:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f44:	8b 40 08             	mov    0x8(%eax),%eax
  802f47:	39 c2                	cmp    %eax,%edx
  802f49:	0f 83 dd 03 00 00    	jae    80332c <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802f4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f52:	8b 50 08             	mov    0x8(%eax),%edx
  802f55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f58:	8b 40 0c             	mov    0xc(%eax),%eax
  802f5b:	01 c2                	add    %eax,%edx
  802f5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f60:	8b 40 08             	mov    0x8(%eax),%eax
  802f63:	39 c2                	cmp    %eax,%edx
  802f65:	0f 85 b9 01 00 00    	jne    803124 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6e:	8b 50 08             	mov    0x8(%eax),%edx
  802f71:	8b 45 08             	mov    0x8(%ebp),%eax
  802f74:	8b 40 0c             	mov    0xc(%eax),%eax
  802f77:	01 c2                	add    %eax,%edx
  802f79:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f7c:	8b 40 08             	mov    0x8(%eax),%eax
  802f7f:	39 c2                	cmp    %eax,%edx
  802f81:	0f 85 0d 01 00 00    	jne    803094 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802f87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8a:	8b 50 0c             	mov    0xc(%eax),%edx
  802f8d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f90:	8b 40 0c             	mov    0xc(%eax),%eax
  802f93:	01 c2                	add    %eax,%edx
  802f95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f98:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802f9b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f9f:	75 17                	jne    802fb8 <insert_sorted_with_merge_freeList+0x39c>
  802fa1:	83 ec 04             	sub    $0x4,%esp
  802fa4:	68 c4 40 80 00       	push   $0x8040c4
  802fa9:	68 5c 01 00 00       	push   $0x15c
  802fae:	68 1b 40 80 00       	push   $0x80401b
  802fb3:	e8 05 d3 ff ff       	call   8002bd <_panic>
  802fb8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fbb:	8b 00                	mov    (%eax),%eax
  802fbd:	85 c0                	test   %eax,%eax
  802fbf:	74 10                	je     802fd1 <insert_sorted_with_merge_freeList+0x3b5>
  802fc1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fc4:	8b 00                	mov    (%eax),%eax
  802fc6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fc9:	8b 52 04             	mov    0x4(%edx),%edx
  802fcc:	89 50 04             	mov    %edx,0x4(%eax)
  802fcf:	eb 0b                	jmp    802fdc <insert_sorted_with_merge_freeList+0x3c0>
  802fd1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fd4:	8b 40 04             	mov    0x4(%eax),%eax
  802fd7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fdc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fdf:	8b 40 04             	mov    0x4(%eax),%eax
  802fe2:	85 c0                	test   %eax,%eax
  802fe4:	74 0f                	je     802ff5 <insert_sorted_with_merge_freeList+0x3d9>
  802fe6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fe9:	8b 40 04             	mov    0x4(%eax),%eax
  802fec:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fef:	8b 12                	mov    (%edx),%edx
  802ff1:	89 10                	mov    %edx,(%eax)
  802ff3:	eb 0a                	jmp    802fff <insert_sorted_with_merge_freeList+0x3e3>
  802ff5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ff8:	8b 00                	mov    (%eax),%eax
  802ffa:	a3 38 51 80 00       	mov    %eax,0x805138
  802fff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803002:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803008:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80300b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803012:	a1 44 51 80 00       	mov    0x805144,%eax
  803017:	48                   	dec    %eax
  803018:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  80301d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803020:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803027:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80302a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803031:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803035:	75 17                	jne    80304e <insert_sorted_with_merge_freeList+0x432>
  803037:	83 ec 04             	sub    $0x4,%esp
  80303a:	68 f8 3f 80 00       	push   $0x803ff8
  80303f:	68 5f 01 00 00       	push   $0x15f
  803044:	68 1b 40 80 00       	push   $0x80401b
  803049:	e8 6f d2 ff ff       	call   8002bd <_panic>
  80304e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803054:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803057:	89 10                	mov    %edx,(%eax)
  803059:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80305c:	8b 00                	mov    (%eax),%eax
  80305e:	85 c0                	test   %eax,%eax
  803060:	74 0d                	je     80306f <insert_sorted_with_merge_freeList+0x453>
  803062:	a1 48 51 80 00       	mov    0x805148,%eax
  803067:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80306a:	89 50 04             	mov    %edx,0x4(%eax)
  80306d:	eb 08                	jmp    803077 <insert_sorted_with_merge_freeList+0x45b>
  80306f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803072:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803077:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80307a:	a3 48 51 80 00       	mov    %eax,0x805148
  80307f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803082:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803089:	a1 54 51 80 00       	mov    0x805154,%eax
  80308e:	40                   	inc    %eax
  80308f:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803094:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803097:	8b 50 0c             	mov    0xc(%eax),%edx
  80309a:	8b 45 08             	mov    0x8(%ebp),%eax
  80309d:	8b 40 0c             	mov    0xc(%eax),%eax
  8030a0:	01 c2                	add    %eax,%edx
  8030a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a5:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8030a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ab:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8030b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8030bc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030c0:	75 17                	jne    8030d9 <insert_sorted_with_merge_freeList+0x4bd>
  8030c2:	83 ec 04             	sub    $0x4,%esp
  8030c5:	68 f8 3f 80 00       	push   $0x803ff8
  8030ca:	68 64 01 00 00       	push   $0x164
  8030cf:	68 1b 40 80 00       	push   $0x80401b
  8030d4:	e8 e4 d1 ff ff       	call   8002bd <_panic>
  8030d9:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8030df:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e2:	89 10                	mov    %edx,(%eax)
  8030e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e7:	8b 00                	mov    (%eax),%eax
  8030e9:	85 c0                	test   %eax,%eax
  8030eb:	74 0d                	je     8030fa <insert_sorted_with_merge_freeList+0x4de>
  8030ed:	a1 48 51 80 00       	mov    0x805148,%eax
  8030f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8030f5:	89 50 04             	mov    %edx,0x4(%eax)
  8030f8:	eb 08                	jmp    803102 <insert_sorted_with_merge_freeList+0x4e6>
  8030fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fd:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803102:	8b 45 08             	mov    0x8(%ebp),%eax
  803105:	a3 48 51 80 00       	mov    %eax,0x805148
  80310a:	8b 45 08             	mov    0x8(%ebp),%eax
  80310d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803114:	a1 54 51 80 00       	mov    0x805154,%eax
  803119:	40                   	inc    %eax
  80311a:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80311f:	e9 41 02 00 00       	jmp    803365 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803124:	8b 45 08             	mov    0x8(%ebp),%eax
  803127:	8b 50 08             	mov    0x8(%eax),%edx
  80312a:	8b 45 08             	mov    0x8(%ebp),%eax
  80312d:	8b 40 0c             	mov    0xc(%eax),%eax
  803130:	01 c2                	add    %eax,%edx
  803132:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803135:	8b 40 08             	mov    0x8(%eax),%eax
  803138:	39 c2                	cmp    %eax,%edx
  80313a:	0f 85 7c 01 00 00    	jne    8032bc <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803140:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803144:	74 06                	je     80314c <insert_sorted_with_merge_freeList+0x530>
  803146:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80314a:	75 17                	jne    803163 <insert_sorted_with_merge_freeList+0x547>
  80314c:	83 ec 04             	sub    $0x4,%esp
  80314f:	68 34 40 80 00       	push   $0x804034
  803154:	68 69 01 00 00       	push   $0x169
  803159:	68 1b 40 80 00       	push   $0x80401b
  80315e:	e8 5a d1 ff ff       	call   8002bd <_panic>
  803163:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803166:	8b 50 04             	mov    0x4(%eax),%edx
  803169:	8b 45 08             	mov    0x8(%ebp),%eax
  80316c:	89 50 04             	mov    %edx,0x4(%eax)
  80316f:	8b 45 08             	mov    0x8(%ebp),%eax
  803172:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803175:	89 10                	mov    %edx,(%eax)
  803177:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80317a:	8b 40 04             	mov    0x4(%eax),%eax
  80317d:	85 c0                	test   %eax,%eax
  80317f:	74 0d                	je     80318e <insert_sorted_with_merge_freeList+0x572>
  803181:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803184:	8b 40 04             	mov    0x4(%eax),%eax
  803187:	8b 55 08             	mov    0x8(%ebp),%edx
  80318a:	89 10                	mov    %edx,(%eax)
  80318c:	eb 08                	jmp    803196 <insert_sorted_with_merge_freeList+0x57a>
  80318e:	8b 45 08             	mov    0x8(%ebp),%eax
  803191:	a3 38 51 80 00       	mov    %eax,0x805138
  803196:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803199:	8b 55 08             	mov    0x8(%ebp),%edx
  80319c:	89 50 04             	mov    %edx,0x4(%eax)
  80319f:	a1 44 51 80 00       	mov    0x805144,%eax
  8031a4:	40                   	inc    %eax
  8031a5:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8031aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ad:	8b 50 0c             	mov    0xc(%eax),%edx
  8031b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031b3:	8b 40 0c             	mov    0xc(%eax),%eax
  8031b6:	01 c2                	add    %eax,%edx
  8031b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031bb:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8031be:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031c2:	75 17                	jne    8031db <insert_sorted_with_merge_freeList+0x5bf>
  8031c4:	83 ec 04             	sub    $0x4,%esp
  8031c7:	68 c4 40 80 00       	push   $0x8040c4
  8031cc:	68 6b 01 00 00       	push   $0x16b
  8031d1:	68 1b 40 80 00       	push   $0x80401b
  8031d6:	e8 e2 d0 ff ff       	call   8002bd <_panic>
  8031db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031de:	8b 00                	mov    (%eax),%eax
  8031e0:	85 c0                	test   %eax,%eax
  8031e2:	74 10                	je     8031f4 <insert_sorted_with_merge_freeList+0x5d8>
  8031e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e7:	8b 00                	mov    (%eax),%eax
  8031e9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031ec:	8b 52 04             	mov    0x4(%edx),%edx
  8031ef:	89 50 04             	mov    %edx,0x4(%eax)
  8031f2:	eb 0b                	jmp    8031ff <insert_sorted_with_merge_freeList+0x5e3>
  8031f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f7:	8b 40 04             	mov    0x4(%eax),%eax
  8031fa:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803202:	8b 40 04             	mov    0x4(%eax),%eax
  803205:	85 c0                	test   %eax,%eax
  803207:	74 0f                	je     803218 <insert_sorted_with_merge_freeList+0x5fc>
  803209:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80320c:	8b 40 04             	mov    0x4(%eax),%eax
  80320f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803212:	8b 12                	mov    (%edx),%edx
  803214:	89 10                	mov    %edx,(%eax)
  803216:	eb 0a                	jmp    803222 <insert_sorted_with_merge_freeList+0x606>
  803218:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80321b:	8b 00                	mov    (%eax),%eax
  80321d:	a3 38 51 80 00       	mov    %eax,0x805138
  803222:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803225:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80322b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80322e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803235:	a1 44 51 80 00       	mov    0x805144,%eax
  80323a:	48                   	dec    %eax
  80323b:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803240:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803243:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  80324a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80324d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803254:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803258:	75 17                	jne    803271 <insert_sorted_with_merge_freeList+0x655>
  80325a:	83 ec 04             	sub    $0x4,%esp
  80325d:	68 f8 3f 80 00       	push   $0x803ff8
  803262:	68 6e 01 00 00       	push   $0x16e
  803267:	68 1b 40 80 00       	push   $0x80401b
  80326c:	e8 4c d0 ff ff       	call   8002bd <_panic>
  803271:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803277:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80327a:	89 10                	mov    %edx,(%eax)
  80327c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80327f:	8b 00                	mov    (%eax),%eax
  803281:	85 c0                	test   %eax,%eax
  803283:	74 0d                	je     803292 <insert_sorted_with_merge_freeList+0x676>
  803285:	a1 48 51 80 00       	mov    0x805148,%eax
  80328a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80328d:	89 50 04             	mov    %edx,0x4(%eax)
  803290:	eb 08                	jmp    80329a <insert_sorted_with_merge_freeList+0x67e>
  803292:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803295:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80329a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80329d:	a3 48 51 80 00       	mov    %eax,0x805148
  8032a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032a5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032ac:	a1 54 51 80 00       	mov    0x805154,%eax
  8032b1:	40                   	inc    %eax
  8032b2:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8032b7:	e9 a9 00 00 00       	jmp    803365 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8032bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032c0:	74 06                	je     8032c8 <insert_sorted_with_merge_freeList+0x6ac>
  8032c2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032c6:	75 17                	jne    8032df <insert_sorted_with_merge_freeList+0x6c3>
  8032c8:	83 ec 04             	sub    $0x4,%esp
  8032cb:	68 90 40 80 00       	push   $0x804090
  8032d0:	68 73 01 00 00       	push   $0x173
  8032d5:	68 1b 40 80 00       	push   $0x80401b
  8032da:	e8 de cf ff ff       	call   8002bd <_panic>
  8032df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032e2:	8b 10                	mov    (%eax),%edx
  8032e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e7:	89 10                	mov    %edx,(%eax)
  8032e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ec:	8b 00                	mov    (%eax),%eax
  8032ee:	85 c0                	test   %eax,%eax
  8032f0:	74 0b                	je     8032fd <insert_sorted_with_merge_freeList+0x6e1>
  8032f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f5:	8b 00                	mov    (%eax),%eax
  8032f7:	8b 55 08             	mov    0x8(%ebp),%edx
  8032fa:	89 50 04             	mov    %edx,0x4(%eax)
  8032fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803300:	8b 55 08             	mov    0x8(%ebp),%edx
  803303:	89 10                	mov    %edx,(%eax)
  803305:	8b 45 08             	mov    0x8(%ebp),%eax
  803308:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80330b:	89 50 04             	mov    %edx,0x4(%eax)
  80330e:	8b 45 08             	mov    0x8(%ebp),%eax
  803311:	8b 00                	mov    (%eax),%eax
  803313:	85 c0                	test   %eax,%eax
  803315:	75 08                	jne    80331f <insert_sorted_with_merge_freeList+0x703>
  803317:	8b 45 08             	mov    0x8(%ebp),%eax
  80331a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80331f:	a1 44 51 80 00       	mov    0x805144,%eax
  803324:	40                   	inc    %eax
  803325:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  80332a:	eb 39                	jmp    803365 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80332c:	a1 40 51 80 00       	mov    0x805140,%eax
  803331:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803334:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803338:	74 07                	je     803341 <insert_sorted_with_merge_freeList+0x725>
  80333a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80333d:	8b 00                	mov    (%eax),%eax
  80333f:	eb 05                	jmp    803346 <insert_sorted_with_merge_freeList+0x72a>
  803341:	b8 00 00 00 00       	mov    $0x0,%eax
  803346:	a3 40 51 80 00       	mov    %eax,0x805140
  80334b:	a1 40 51 80 00       	mov    0x805140,%eax
  803350:	85 c0                	test   %eax,%eax
  803352:	0f 85 c7 fb ff ff    	jne    802f1f <insert_sorted_with_merge_freeList+0x303>
  803358:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80335c:	0f 85 bd fb ff ff    	jne    802f1f <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803362:	eb 01                	jmp    803365 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803364:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803365:	90                   	nop
  803366:	c9                   	leave  
  803367:	c3                   	ret    

00803368 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803368:	55                   	push   %ebp
  803369:	89 e5                	mov    %esp,%ebp
  80336b:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  80336e:	8b 55 08             	mov    0x8(%ebp),%edx
  803371:	89 d0                	mov    %edx,%eax
  803373:	c1 e0 02             	shl    $0x2,%eax
  803376:	01 d0                	add    %edx,%eax
  803378:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80337f:	01 d0                	add    %edx,%eax
  803381:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803388:	01 d0                	add    %edx,%eax
  80338a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803391:	01 d0                	add    %edx,%eax
  803393:	c1 e0 04             	shl    $0x4,%eax
  803396:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803399:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8033a0:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8033a3:	83 ec 0c             	sub    $0xc,%esp
  8033a6:	50                   	push   %eax
  8033a7:	e8 26 e7 ff ff       	call   801ad2 <sys_get_virtual_time>
  8033ac:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8033af:	eb 41                	jmp    8033f2 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8033b1:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8033b4:	83 ec 0c             	sub    $0xc,%esp
  8033b7:	50                   	push   %eax
  8033b8:	e8 15 e7 ff ff       	call   801ad2 <sys_get_virtual_time>
  8033bd:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8033c0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8033c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033c6:	29 c2                	sub    %eax,%edx
  8033c8:	89 d0                	mov    %edx,%eax
  8033ca:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8033cd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8033d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033d3:	89 d1                	mov    %edx,%ecx
  8033d5:	29 c1                	sub    %eax,%ecx
  8033d7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8033da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033dd:	39 c2                	cmp    %eax,%edx
  8033df:	0f 97 c0             	seta   %al
  8033e2:	0f b6 c0             	movzbl %al,%eax
  8033e5:	29 c1                	sub    %eax,%ecx
  8033e7:	89 c8                	mov    %ecx,%eax
  8033e9:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8033ec:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8033ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8033f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8033f8:	72 b7                	jb     8033b1 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8033fa:	90                   	nop
  8033fb:	c9                   	leave  
  8033fc:	c3                   	ret    

008033fd <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8033fd:	55                   	push   %ebp
  8033fe:	89 e5                	mov    %esp,%ebp
  803400:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803403:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  80340a:	eb 03                	jmp    80340f <busy_wait+0x12>
  80340c:	ff 45 fc             	incl   -0x4(%ebp)
  80340f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803412:	3b 45 08             	cmp    0x8(%ebp),%eax
  803415:	72 f5                	jb     80340c <busy_wait+0xf>
	return i;
  803417:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80341a:	c9                   	leave  
  80341b:	c3                   	ret    

0080341c <__udivdi3>:
  80341c:	55                   	push   %ebp
  80341d:	57                   	push   %edi
  80341e:	56                   	push   %esi
  80341f:	53                   	push   %ebx
  803420:	83 ec 1c             	sub    $0x1c,%esp
  803423:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803427:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80342b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80342f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803433:	89 ca                	mov    %ecx,%edx
  803435:	89 f8                	mov    %edi,%eax
  803437:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80343b:	85 f6                	test   %esi,%esi
  80343d:	75 2d                	jne    80346c <__udivdi3+0x50>
  80343f:	39 cf                	cmp    %ecx,%edi
  803441:	77 65                	ja     8034a8 <__udivdi3+0x8c>
  803443:	89 fd                	mov    %edi,%ebp
  803445:	85 ff                	test   %edi,%edi
  803447:	75 0b                	jne    803454 <__udivdi3+0x38>
  803449:	b8 01 00 00 00       	mov    $0x1,%eax
  80344e:	31 d2                	xor    %edx,%edx
  803450:	f7 f7                	div    %edi
  803452:	89 c5                	mov    %eax,%ebp
  803454:	31 d2                	xor    %edx,%edx
  803456:	89 c8                	mov    %ecx,%eax
  803458:	f7 f5                	div    %ebp
  80345a:	89 c1                	mov    %eax,%ecx
  80345c:	89 d8                	mov    %ebx,%eax
  80345e:	f7 f5                	div    %ebp
  803460:	89 cf                	mov    %ecx,%edi
  803462:	89 fa                	mov    %edi,%edx
  803464:	83 c4 1c             	add    $0x1c,%esp
  803467:	5b                   	pop    %ebx
  803468:	5e                   	pop    %esi
  803469:	5f                   	pop    %edi
  80346a:	5d                   	pop    %ebp
  80346b:	c3                   	ret    
  80346c:	39 ce                	cmp    %ecx,%esi
  80346e:	77 28                	ja     803498 <__udivdi3+0x7c>
  803470:	0f bd fe             	bsr    %esi,%edi
  803473:	83 f7 1f             	xor    $0x1f,%edi
  803476:	75 40                	jne    8034b8 <__udivdi3+0x9c>
  803478:	39 ce                	cmp    %ecx,%esi
  80347a:	72 0a                	jb     803486 <__udivdi3+0x6a>
  80347c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803480:	0f 87 9e 00 00 00    	ja     803524 <__udivdi3+0x108>
  803486:	b8 01 00 00 00       	mov    $0x1,%eax
  80348b:	89 fa                	mov    %edi,%edx
  80348d:	83 c4 1c             	add    $0x1c,%esp
  803490:	5b                   	pop    %ebx
  803491:	5e                   	pop    %esi
  803492:	5f                   	pop    %edi
  803493:	5d                   	pop    %ebp
  803494:	c3                   	ret    
  803495:	8d 76 00             	lea    0x0(%esi),%esi
  803498:	31 ff                	xor    %edi,%edi
  80349a:	31 c0                	xor    %eax,%eax
  80349c:	89 fa                	mov    %edi,%edx
  80349e:	83 c4 1c             	add    $0x1c,%esp
  8034a1:	5b                   	pop    %ebx
  8034a2:	5e                   	pop    %esi
  8034a3:	5f                   	pop    %edi
  8034a4:	5d                   	pop    %ebp
  8034a5:	c3                   	ret    
  8034a6:	66 90                	xchg   %ax,%ax
  8034a8:	89 d8                	mov    %ebx,%eax
  8034aa:	f7 f7                	div    %edi
  8034ac:	31 ff                	xor    %edi,%edi
  8034ae:	89 fa                	mov    %edi,%edx
  8034b0:	83 c4 1c             	add    $0x1c,%esp
  8034b3:	5b                   	pop    %ebx
  8034b4:	5e                   	pop    %esi
  8034b5:	5f                   	pop    %edi
  8034b6:	5d                   	pop    %ebp
  8034b7:	c3                   	ret    
  8034b8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8034bd:	89 eb                	mov    %ebp,%ebx
  8034bf:	29 fb                	sub    %edi,%ebx
  8034c1:	89 f9                	mov    %edi,%ecx
  8034c3:	d3 e6                	shl    %cl,%esi
  8034c5:	89 c5                	mov    %eax,%ebp
  8034c7:	88 d9                	mov    %bl,%cl
  8034c9:	d3 ed                	shr    %cl,%ebp
  8034cb:	89 e9                	mov    %ebp,%ecx
  8034cd:	09 f1                	or     %esi,%ecx
  8034cf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8034d3:	89 f9                	mov    %edi,%ecx
  8034d5:	d3 e0                	shl    %cl,%eax
  8034d7:	89 c5                	mov    %eax,%ebp
  8034d9:	89 d6                	mov    %edx,%esi
  8034db:	88 d9                	mov    %bl,%cl
  8034dd:	d3 ee                	shr    %cl,%esi
  8034df:	89 f9                	mov    %edi,%ecx
  8034e1:	d3 e2                	shl    %cl,%edx
  8034e3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034e7:	88 d9                	mov    %bl,%cl
  8034e9:	d3 e8                	shr    %cl,%eax
  8034eb:	09 c2                	or     %eax,%edx
  8034ed:	89 d0                	mov    %edx,%eax
  8034ef:	89 f2                	mov    %esi,%edx
  8034f1:	f7 74 24 0c          	divl   0xc(%esp)
  8034f5:	89 d6                	mov    %edx,%esi
  8034f7:	89 c3                	mov    %eax,%ebx
  8034f9:	f7 e5                	mul    %ebp
  8034fb:	39 d6                	cmp    %edx,%esi
  8034fd:	72 19                	jb     803518 <__udivdi3+0xfc>
  8034ff:	74 0b                	je     80350c <__udivdi3+0xf0>
  803501:	89 d8                	mov    %ebx,%eax
  803503:	31 ff                	xor    %edi,%edi
  803505:	e9 58 ff ff ff       	jmp    803462 <__udivdi3+0x46>
  80350a:	66 90                	xchg   %ax,%ax
  80350c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803510:	89 f9                	mov    %edi,%ecx
  803512:	d3 e2                	shl    %cl,%edx
  803514:	39 c2                	cmp    %eax,%edx
  803516:	73 e9                	jae    803501 <__udivdi3+0xe5>
  803518:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80351b:	31 ff                	xor    %edi,%edi
  80351d:	e9 40 ff ff ff       	jmp    803462 <__udivdi3+0x46>
  803522:	66 90                	xchg   %ax,%ax
  803524:	31 c0                	xor    %eax,%eax
  803526:	e9 37 ff ff ff       	jmp    803462 <__udivdi3+0x46>
  80352b:	90                   	nop

0080352c <__umoddi3>:
  80352c:	55                   	push   %ebp
  80352d:	57                   	push   %edi
  80352e:	56                   	push   %esi
  80352f:	53                   	push   %ebx
  803530:	83 ec 1c             	sub    $0x1c,%esp
  803533:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803537:	8b 74 24 34          	mov    0x34(%esp),%esi
  80353b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80353f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803543:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803547:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80354b:	89 f3                	mov    %esi,%ebx
  80354d:	89 fa                	mov    %edi,%edx
  80354f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803553:	89 34 24             	mov    %esi,(%esp)
  803556:	85 c0                	test   %eax,%eax
  803558:	75 1a                	jne    803574 <__umoddi3+0x48>
  80355a:	39 f7                	cmp    %esi,%edi
  80355c:	0f 86 a2 00 00 00    	jbe    803604 <__umoddi3+0xd8>
  803562:	89 c8                	mov    %ecx,%eax
  803564:	89 f2                	mov    %esi,%edx
  803566:	f7 f7                	div    %edi
  803568:	89 d0                	mov    %edx,%eax
  80356a:	31 d2                	xor    %edx,%edx
  80356c:	83 c4 1c             	add    $0x1c,%esp
  80356f:	5b                   	pop    %ebx
  803570:	5e                   	pop    %esi
  803571:	5f                   	pop    %edi
  803572:	5d                   	pop    %ebp
  803573:	c3                   	ret    
  803574:	39 f0                	cmp    %esi,%eax
  803576:	0f 87 ac 00 00 00    	ja     803628 <__umoddi3+0xfc>
  80357c:	0f bd e8             	bsr    %eax,%ebp
  80357f:	83 f5 1f             	xor    $0x1f,%ebp
  803582:	0f 84 ac 00 00 00    	je     803634 <__umoddi3+0x108>
  803588:	bf 20 00 00 00       	mov    $0x20,%edi
  80358d:	29 ef                	sub    %ebp,%edi
  80358f:	89 fe                	mov    %edi,%esi
  803591:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803595:	89 e9                	mov    %ebp,%ecx
  803597:	d3 e0                	shl    %cl,%eax
  803599:	89 d7                	mov    %edx,%edi
  80359b:	89 f1                	mov    %esi,%ecx
  80359d:	d3 ef                	shr    %cl,%edi
  80359f:	09 c7                	or     %eax,%edi
  8035a1:	89 e9                	mov    %ebp,%ecx
  8035a3:	d3 e2                	shl    %cl,%edx
  8035a5:	89 14 24             	mov    %edx,(%esp)
  8035a8:	89 d8                	mov    %ebx,%eax
  8035aa:	d3 e0                	shl    %cl,%eax
  8035ac:	89 c2                	mov    %eax,%edx
  8035ae:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035b2:	d3 e0                	shl    %cl,%eax
  8035b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8035b8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035bc:	89 f1                	mov    %esi,%ecx
  8035be:	d3 e8                	shr    %cl,%eax
  8035c0:	09 d0                	or     %edx,%eax
  8035c2:	d3 eb                	shr    %cl,%ebx
  8035c4:	89 da                	mov    %ebx,%edx
  8035c6:	f7 f7                	div    %edi
  8035c8:	89 d3                	mov    %edx,%ebx
  8035ca:	f7 24 24             	mull   (%esp)
  8035cd:	89 c6                	mov    %eax,%esi
  8035cf:	89 d1                	mov    %edx,%ecx
  8035d1:	39 d3                	cmp    %edx,%ebx
  8035d3:	0f 82 87 00 00 00    	jb     803660 <__umoddi3+0x134>
  8035d9:	0f 84 91 00 00 00    	je     803670 <__umoddi3+0x144>
  8035df:	8b 54 24 04          	mov    0x4(%esp),%edx
  8035e3:	29 f2                	sub    %esi,%edx
  8035e5:	19 cb                	sbb    %ecx,%ebx
  8035e7:	89 d8                	mov    %ebx,%eax
  8035e9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8035ed:	d3 e0                	shl    %cl,%eax
  8035ef:	89 e9                	mov    %ebp,%ecx
  8035f1:	d3 ea                	shr    %cl,%edx
  8035f3:	09 d0                	or     %edx,%eax
  8035f5:	89 e9                	mov    %ebp,%ecx
  8035f7:	d3 eb                	shr    %cl,%ebx
  8035f9:	89 da                	mov    %ebx,%edx
  8035fb:	83 c4 1c             	add    $0x1c,%esp
  8035fe:	5b                   	pop    %ebx
  8035ff:	5e                   	pop    %esi
  803600:	5f                   	pop    %edi
  803601:	5d                   	pop    %ebp
  803602:	c3                   	ret    
  803603:	90                   	nop
  803604:	89 fd                	mov    %edi,%ebp
  803606:	85 ff                	test   %edi,%edi
  803608:	75 0b                	jne    803615 <__umoddi3+0xe9>
  80360a:	b8 01 00 00 00       	mov    $0x1,%eax
  80360f:	31 d2                	xor    %edx,%edx
  803611:	f7 f7                	div    %edi
  803613:	89 c5                	mov    %eax,%ebp
  803615:	89 f0                	mov    %esi,%eax
  803617:	31 d2                	xor    %edx,%edx
  803619:	f7 f5                	div    %ebp
  80361b:	89 c8                	mov    %ecx,%eax
  80361d:	f7 f5                	div    %ebp
  80361f:	89 d0                	mov    %edx,%eax
  803621:	e9 44 ff ff ff       	jmp    80356a <__umoddi3+0x3e>
  803626:	66 90                	xchg   %ax,%ax
  803628:	89 c8                	mov    %ecx,%eax
  80362a:	89 f2                	mov    %esi,%edx
  80362c:	83 c4 1c             	add    $0x1c,%esp
  80362f:	5b                   	pop    %ebx
  803630:	5e                   	pop    %esi
  803631:	5f                   	pop    %edi
  803632:	5d                   	pop    %ebp
  803633:	c3                   	ret    
  803634:	3b 04 24             	cmp    (%esp),%eax
  803637:	72 06                	jb     80363f <__umoddi3+0x113>
  803639:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80363d:	77 0f                	ja     80364e <__umoddi3+0x122>
  80363f:	89 f2                	mov    %esi,%edx
  803641:	29 f9                	sub    %edi,%ecx
  803643:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803647:	89 14 24             	mov    %edx,(%esp)
  80364a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80364e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803652:	8b 14 24             	mov    (%esp),%edx
  803655:	83 c4 1c             	add    $0x1c,%esp
  803658:	5b                   	pop    %ebx
  803659:	5e                   	pop    %esi
  80365a:	5f                   	pop    %edi
  80365b:	5d                   	pop    %ebp
  80365c:	c3                   	ret    
  80365d:	8d 76 00             	lea    0x0(%esi),%esi
  803660:	2b 04 24             	sub    (%esp),%eax
  803663:	19 fa                	sbb    %edi,%edx
  803665:	89 d1                	mov    %edx,%ecx
  803667:	89 c6                	mov    %eax,%esi
  803669:	e9 71 ff ff ff       	jmp    8035df <__umoddi3+0xb3>
  80366e:	66 90                	xchg   %ax,%ax
  803670:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803674:	72 ea                	jb     803660 <__umoddi3+0x134>
  803676:	89 d9                	mov    %ebx,%ecx
  803678:	e9 62 ff ff ff       	jmp    8035df <__umoddi3+0xb3>
