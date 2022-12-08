
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
  800045:	68 00 36 80 00       	push   $0x803600
  80004a:	e8 f2 14 00 00       	call   801541 <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*numOfFinished = 0 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int freeFrames_before = sys_calculate_free_frames() ;
  80005e:	e8 b6 16 00 00       	call   801719 <sys_calculate_free_frames>
  800063:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800066:	e8 4e 17 00 00       	call   8017b9 <sys_pf_calculate_allocated_pages>
  80006b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80006e:	83 ec 08             	sub    $0x8,%esp
  800071:	ff 75 f0             	pushl  -0x10(%ebp)
  800074:	68 10 36 80 00       	push   $0x803610
  800079:	e8 f3 04 00 00       	call   800571 <cprintf>
  80007e:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tshr4", 2000,100, 50);
  800081:	6a 32                	push   $0x32
  800083:	6a 64                	push   $0x64
  800085:	68 d0 07 00 00       	push   $0x7d0
  80008a:	68 43 36 80 00       	push   $0x803643
  80008f:	e8 f7 18 00 00       	call   80198b <sys_create_env>
  800094:	83 c4 10             	add    $0x10,%esp
  800097:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int32 envIdProcessB = sys_create_env("ef_tshr5", 2000,100, 50);
  80009a:	6a 32                	push   $0x32
  80009c:	6a 64                	push   $0x64
  80009e:	68 d0 07 00 00       	push   $0x7d0
  8000a3:	68 4c 36 80 00       	push   $0x80364c
  8000a8:	e8 de 18 00 00       	call   80198b <sys_create_env>
  8000ad:	83 c4 10             	add    $0x10,%esp
  8000b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	sys_run_env(envIdProcessA);
  8000b3:	83 ec 0c             	sub    $0xc,%esp
  8000b6:	ff 75 e8             	pushl  -0x18(%ebp)
  8000b9:	e8 eb 18 00 00       	call   8019a9 <sys_run_env>
  8000be:	83 c4 10             	add    $0x10,%esp
	env_sleep(15000);
  8000c1:	83 ec 0c             	sub    $0xc,%esp
  8000c4:	68 98 3a 00 00       	push   $0x3a98
  8000c9:	e8 0d 32 00 00       	call   8032db <env_sleep>
  8000ce:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  8000d1:	83 ec 0c             	sub    $0xc,%esp
  8000d4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000d7:	e8 cd 18 00 00       	call   8019a9 <sys_run_env>
  8000dc:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 2) ;
  8000df:	90                   	nop
  8000e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000e3:	8b 00                	mov    (%eax),%eax
  8000e5:	83 f8 02             	cmp    $0x2,%eax
  8000e8:	75 f6                	jne    8000e0 <_main+0xa8>
	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  8000ea:	e8 2a 16 00 00       	call   801719 <sys_calculate_free_frames>
  8000ef:	83 ec 08             	sub    $0x8,%esp
  8000f2:	50                   	push   %eax
  8000f3:	68 58 36 80 00       	push   $0x803658
  8000f8:	e8 74 04 00 00       	call   800571 <cprintf>
  8000fd:	83 c4 10             	add    $0x10,%esp

	sys_destroy_env(envIdProcessA);
  800100:	83 ec 0c             	sub    $0xc,%esp
  800103:	ff 75 e8             	pushl  -0x18(%ebp)
  800106:	e8 ba 18 00 00       	call   8019c5 <sys_destroy_env>
  80010b:	83 c4 10             	add    $0x10,%esp
	sys_destroy_env(envIdProcessB);
  80010e:	83 ec 0c             	sub    $0xc,%esp
  800111:	ff 75 e4             	pushl  -0x1c(%ebp)
  800114:	e8 ac 18 00 00       	call   8019c5 <sys_destroy_env>
  800119:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  80011c:	e8 f8 15 00 00       	call   801719 <sys_calculate_free_frames>
  800121:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  800124:	e8 90 16 00 00       	call   8017b9 <sys_pf_calculate_allocated_pages>
  800129:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if ((freeFrames_after - freeFrames_before) != 0) {
  80012c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80012f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800132:	74 27                	je     80015b <_main+0x123>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\n",
  800134:	83 ec 08             	sub    $0x8,%esp
  800137:	ff 75 e0             	pushl  -0x20(%ebp)
  80013a:	68 8c 36 80 00       	push   $0x80368c
  80013f:	e8 2d 04 00 00       	call   800571 <cprintf>
  800144:	83 c4 10             	add    $0x10,%esp
				freeFrames_after);
		panic("env_free() does not work correctly... check it again.");
  800147:	83 ec 04             	sub    $0x4,%esp
  80014a:	68 dc 36 80 00       	push   $0x8036dc
  80014f:	6a 23                	push   $0x23
  800151:	68 12 37 80 00       	push   $0x803712
  800156:	e8 62 01 00 00       	call   8002bd <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  80015b:	83 ec 08             	sub    $0x8,%esp
  80015e:	ff 75 e0             	pushl  -0x20(%ebp)
  800161:	68 28 37 80 00       	push   $0x803728
  800166:	e8 06 04 00 00       	call   800571 <cprintf>
  80016b:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 5_2 for envfree completed successfully.\n");
  80016e:	83 ec 0c             	sub    $0xc,%esp
  800171:	68 88 37 80 00       	push   $0x803788
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
  800187:	e8 6d 18 00 00       	call   8019f9 <sys_getenvindex>
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
  8001f2:	e8 0f 16 00 00       	call   801806 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001f7:	83 ec 0c             	sub    $0xc,%esp
  8001fa:	68 ec 37 80 00       	push   $0x8037ec
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
  800222:	68 14 38 80 00       	push   $0x803814
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
  800253:	68 3c 38 80 00       	push   $0x80383c
  800258:	e8 14 03 00 00       	call   800571 <cprintf>
  80025d:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800260:	a1 20 50 80 00       	mov    0x805020,%eax
  800265:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80026b:	83 ec 08             	sub    $0x8,%esp
  80026e:	50                   	push   %eax
  80026f:	68 94 38 80 00       	push   $0x803894
  800274:	e8 f8 02 00 00       	call   800571 <cprintf>
  800279:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80027c:	83 ec 0c             	sub    $0xc,%esp
  80027f:	68 ec 37 80 00       	push   $0x8037ec
  800284:	e8 e8 02 00 00       	call   800571 <cprintf>
  800289:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80028c:	e8 8f 15 00 00       	call   801820 <sys_enable_interrupt>

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
  8002a4:	e8 1c 17 00 00       	call   8019c5 <sys_destroy_env>
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
  8002b5:	e8 71 17 00 00       	call   801a2b <sys_exit_env>
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
  8002de:	68 a8 38 80 00       	push   $0x8038a8
  8002e3:	e8 89 02 00 00       	call   800571 <cprintf>
  8002e8:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002eb:	a1 00 50 80 00       	mov    0x805000,%eax
  8002f0:	ff 75 0c             	pushl  0xc(%ebp)
  8002f3:	ff 75 08             	pushl  0x8(%ebp)
  8002f6:	50                   	push   %eax
  8002f7:	68 ad 38 80 00       	push   $0x8038ad
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
  80031b:	68 c9 38 80 00       	push   $0x8038c9
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
  800347:	68 cc 38 80 00       	push   $0x8038cc
  80034c:	6a 26                	push   $0x26
  80034e:	68 18 39 80 00       	push   $0x803918
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
  800419:	68 24 39 80 00       	push   $0x803924
  80041e:	6a 3a                	push   $0x3a
  800420:	68 18 39 80 00       	push   $0x803918
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
  800489:	68 78 39 80 00       	push   $0x803978
  80048e:	6a 44                	push   $0x44
  800490:	68 18 39 80 00       	push   $0x803918
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
  8004e3:	e8 70 11 00 00       	call   801658 <sys_cputs>
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
  80055a:	e8 f9 10 00 00       	call   801658 <sys_cputs>
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
  8005a4:	e8 5d 12 00 00       	call   801806 <sys_disable_interrupt>
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
  8005c4:	e8 57 12 00 00       	call   801820 <sys_enable_interrupt>
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
  80060e:	e8 7d 2d 00 00       	call   803390 <__udivdi3>
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
  80065e:	e8 3d 2e 00 00       	call   8034a0 <__umoddi3>
  800663:	83 c4 10             	add    $0x10,%esp
  800666:	05 f4 3b 80 00       	add    $0x803bf4,%eax
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
  8007b9:	8b 04 85 18 3c 80 00 	mov    0x803c18(,%eax,4),%eax
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
  80089a:	8b 34 9d 60 3a 80 00 	mov    0x803a60(,%ebx,4),%esi
  8008a1:	85 f6                	test   %esi,%esi
  8008a3:	75 19                	jne    8008be <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008a5:	53                   	push   %ebx
  8008a6:	68 05 3c 80 00       	push   $0x803c05
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
  8008bf:	68 0e 3c 80 00       	push   $0x803c0e
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
  8008ec:	be 11 3c 80 00       	mov    $0x803c11,%esi
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
  801312:	68 70 3d 80 00       	push   $0x803d70
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
  8013e2:	e8 b5 03 00 00       	call   80179c <sys_allocate_chunk>
  8013e7:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013ea:	a1 20 51 80 00       	mov    0x805120,%eax
  8013ef:	83 ec 0c             	sub    $0xc,%esp
  8013f2:	50                   	push   %eax
  8013f3:	e8 2a 0a 00 00       	call   801e22 <initialize_MemBlocksList>
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
  801420:	68 95 3d 80 00       	push   $0x803d95
  801425:	6a 33                	push   $0x33
  801427:	68 b3 3d 80 00       	push   $0x803db3
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
  80149f:	68 c0 3d 80 00       	push   $0x803dc0
  8014a4:	6a 34                	push   $0x34
  8014a6:	68 b3 3d 80 00       	push   $0x803db3
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
  801514:	68 e4 3d 80 00       	push   $0x803de4
  801519:	6a 46                	push   $0x46
  80151b:	68 b3 3d 80 00       	push   $0x803db3
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
  801530:	68 0c 3e 80 00       	push   $0x803e0c
  801535:	6a 61                	push   $0x61
  801537:	68 b3 3d 80 00       	push   $0x803db3
  80153c:	e8 7c ed ff ff       	call   8002bd <_panic>

00801541 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801541:	55                   	push   %ebp
  801542:	89 e5                	mov    %esp,%ebp
  801544:	83 ec 18             	sub    $0x18,%esp
  801547:	8b 45 10             	mov    0x10(%ebp),%eax
  80154a:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80154d:	e8 a9 fd ff ff       	call   8012fb <InitializeUHeap>
	if (size == 0) return NULL ;
  801552:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801556:	75 07                	jne    80155f <smalloc+0x1e>
  801558:	b8 00 00 00 00       	mov    $0x0,%eax
  80155d:	eb 14                	jmp    801573 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  80155f:	83 ec 04             	sub    $0x4,%esp
  801562:	68 30 3e 80 00       	push   $0x803e30
  801567:	6a 76                	push   $0x76
  801569:	68 b3 3d 80 00       	push   $0x803db3
  80156e:	e8 4a ed ff ff       	call   8002bd <_panic>

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801573:	c9                   	leave  
  801574:	c3                   	ret    

00801575 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801575:	55                   	push   %ebp
  801576:	89 e5                	mov    %esp,%ebp
  801578:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80157b:	e8 7b fd ff ff       	call   8012fb <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801580:	83 ec 04             	sub    $0x4,%esp
  801583:	68 58 3e 80 00       	push   $0x803e58
  801588:	68 93 00 00 00       	push   $0x93
  80158d:	68 b3 3d 80 00       	push   $0x803db3
  801592:	e8 26 ed ff ff       	call   8002bd <_panic>

00801597 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801597:	55                   	push   %ebp
  801598:	89 e5                	mov    %esp,%ebp
  80159a:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80159d:	e8 59 fd ff ff       	call   8012fb <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8015a2:	83 ec 04             	sub    $0x4,%esp
  8015a5:	68 7c 3e 80 00       	push   $0x803e7c
  8015aa:	68 c5 00 00 00       	push   $0xc5
  8015af:	68 b3 3d 80 00       	push   $0x803db3
  8015b4:	e8 04 ed ff ff       	call   8002bd <_panic>

008015b9 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8015b9:	55                   	push   %ebp
  8015ba:	89 e5                	mov    %esp,%ebp
  8015bc:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8015bf:	83 ec 04             	sub    $0x4,%esp
  8015c2:	68 a4 3e 80 00       	push   $0x803ea4
  8015c7:	68 d9 00 00 00       	push   $0xd9
  8015cc:	68 b3 3d 80 00       	push   $0x803db3
  8015d1:	e8 e7 ec ff ff       	call   8002bd <_panic>

008015d6 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8015d6:	55                   	push   %ebp
  8015d7:	89 e5                	mov    %esp,%ebp
  8015d9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015dc:	83 ec 04             	sub    $0x4,%esp
  8015df:	68 c8 3e 80 00       	push   $0x803ec8
  8015e4:	68 e4 00 00 00       	push   $0xe4
  8015e9:	68 b3 3d 80 00       	push   $0x803db3
  8015ee:	e8 ca ec ff ff       	call   8002bd <_panic>

008015f3 <shrink>:

}
void shrink(uint32 newSize)
{
  8015f3:	55                   	push   %ebp
  8015f4:	89 e5                	mov    %esp,%ebp
  8015f6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015f9:	83 ec 04             	sub    $0x4,%esp
  8015fc:	68 c8 3e 80 00       	push   $0x803ec8
  801601:	68 e9 00 00 00       	push   $0xe9
  801606:	68 b3 3d 80 00       	push   $0x803db3
  80160b:	e8 ad ec ff ff       	call   8002bd <_panic>

00801610 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801610:	55                   	push   %ebp
  801611:	89 e5                	mov    %esp,%ebp
  801613:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801616:	83 ec 04             	sub    $0x4,%esp
  801619:	68 c8 3e 80 00       	push   $0x803ec8
  80161e:	68 ee 00 00 00       	push   $0xee
  801623:	68 b3 3d 80 00       	push   $0x803db3
  801628:	e8 90 ec ff ff       	call   8002bd <_panic>

0080162d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80162d:	55                   	push   %ebp
  80162e:	89 e5                	mov    %esp,%ebp
  801630:	57                   	push   %edi
  801631:	56                   	push   %esi
  801632:	53                   	push   %ebx
  801633:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801636:	8b 45 08             	mov    0x8(%ebp),%eax
  801639:	8b 55 0c             	mov    0xc(%ebp),%edx
  80163c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80163f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801642:	8b 7d 18             	mov    0x18(%ebp),%edi
  801645:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801648:	cd 30                	int    $0x30
  80164a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80164d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801650:	83 c4 10             	add    $0x10,%esp
  801653:	5b                   	pop    %ebx
  801654:	5e                   	pop    %esi
  801655:	5f                   	pop    %edi
  801656:	5d                   	pop    %ebp
  801657:	c3                   	ret    

00801658 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801658:	55                   	push   %ebp
  801659:	89 e5                	mov    %esp,%ebp
  80165b:	83 ec 04             	sub    $0x4,%esp
  80165e:	8b 45 10             	mov    0x10(%ebp),%eax
  801661:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801664:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801668:	8b 45 08             	mov    0x8(%ebp),%eax
  80166b:	6a 00                	push   $0x0
  80166d:	6a 00                	push   $0x0
  80166f:	52                   	push   %edx
  801670:	ff 75 0c             	pushl  0xc(%ebp)
  801673:	50                   	push   %eax
  801674:	6a 00                	push   $0x0
  801676:	e8 b2 ff ff ff       	call   80162d <syscall>
  80167b:	83 c4 18             	add    $0x18,%esp
}
  80167e:	90                   	nop
  80167f:	c9                   	leave  
  801680:	c3                   	ret    

00801681 <sys_cgetc>:

int
sys_cgetc(void)
{
  801681:	55                   	push   %ebp
  801682:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801684:	6a 00                	push   $0x0
  801686:	6a 00                	push   $0x0
  801688:	6a 00                	push   $0x0
  80168a:	6a 00                	push   $0x0
  80168c:	6a 00                	push   $0x0
  80168e:	6a 01                	push   $0x1
  801690:	e8 98 ff ff ff       	call   80162d <syscall>
  801695:	83 c4 18             	add    $0x18,%esp
}
  801698:	c9                   	leave  
  801699:	c3                   	ret    

0080169a <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80169a:	55                   	push   %ebp
  80169b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80169d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a3:	6a 00                	push   $0x0
  8016a5:	6a 00                	push   $0x0
  8016a7:	6a 00                	push   $0x0
  8016a9:	52                   	push   %edx
  8016aa:	50                   	push   %eax
  8016ab:	6a 05                	push   $0x5
  8016ad:	e8 7b ff ff ff       	call   80162d <syscall>
  8016b2:	83 c4 18             	add    $0x18,%esp
}
  8016b5:	c9                   	leave  
  8016b6:	c3                   	ret    

008016b7 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8016b7:	55                   	push   %ebp
  8016b8:	89 e5                	mov    %esp,%ebp
  8016ba:	56                   	push   %esi
  8016bb:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8016bc:	8b 75 18             	mov    0x18(%ebp),%esi
  8016bf:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016c2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cb:	56                   	push   %esi
  8016cc:	53                   	push   %ebx
  8016cd:	51                   	push   %ecx
  8016ce:	52                   	push   %edx
  8016cf:	50                   	push   %eax
  8016d0:	6a 06                	push   $0x6
  8016d2:	e8 56 ff ff ff       	call   80162d <syscall>
  8016d7:	83 c4 18             	add    $0x18,%esp
}
  8016da:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016dd:	5b                   	pop    %ebx
  8016de:	5e                   	pop    %esi
  8016df:	5d                   	pop    %ebp
  8016e0:	c3                   	ret    

008016e1 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8016e1:	55                   	push   %ebp
  8016e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8016e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ea:	6a 00                	push   $0x0
  8016ec:	6a 00                	push   $0x0
  8016ee:	6a 00                	push   $0x0
  8016f0:	52                   	push   %edx
  8016f1:	50                   	push   %eax
  8016f2:	6a 07                	push   $0x7
  8016f4:	e8 34 ff ff ff       	call   80162d <syscall>
  8016f9:	83 c4 18             	add    $0x18,%esp
}
  8016fc:	c9                   	leave  
  8016fd:	c3                   	ret    

008016fe <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8016fe:	55                   	push   %ebp
  8016ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801701:	6a 00                	push   $0x0
  801703:	6a 00                	push   $0x0
  801705:	6a 00                	push   $0x0
  801707:	ff 75 0c             	pushl  0xc(%ebp)
  80170a:	ff 75 08             	pushl  0x8(%ebp)
  80170d:	6a 08                	push   $0x8
  80170f:	e8 19 ff ff ff       	call   80162d <syscall>
  801714:	83 c4 18             	add    $0x18,%esp
}
  801717:	c9                   	leave  
  801718:	c3                   	ret    

00801719 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801719:	55                   	push   %ebp
  80171a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80171c:	6a 00                	push   $0x0
  80171e:	6a 00                	push   $0x0
  801720:	6a 00                	push   $0x0
  801722:	6a 00                	push   $0x0
  801724:	6a 00                	push   $0x0
  801726:	6a 09                	push   $0x9
  801728:	e8 00 ff ff ff       	call   80162d <syscall>
  80172d:	83 c4 18             	add    $0x18,%esp
}
  801730:	c9                   	leave  
  801731:	c3                   	ret    

00801732 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801732:	55                   	push   %ebp
  801733:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801735:	6a 00                	push   $0x0
  801737:	6a 00                	push   $0x0
  801739:	6a 00                	push   $0x0
  80173b:	6a 00                	push   $0x0
  80173d:	6a 00                	push   $0x0
  80173f:	6a 0a                	push   $0xa
  801741:	e8 e7 fe ff ff       	call   80162d <syscall>
  801746:	83 c4 18             	add    $0x18,%esp
}
  801749:	c9                   	leave  
  80174a:	c3                   	ret    

0080174b <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80174b:	55                   	push   %ebp
  80174c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80174e:	6a 00                	push   $0x0
  801750:	6a 00                	push   $0x0
  801752:	6a 00                	push   $0x0
  801754:	6a 00                	push   $0x0
  801756:	6a 00                	push   $0x0
  801758:	6a 0b                	push   $0xb
  80175a:	e8 ce fe ff ff       	call   80162d <syscall>
  80175f:	83 c4 18             	add    $0x18,%esp
}
  801762:	c9                   	leave  
  801763:	c3                   	ret    

00801764 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801764:	55                   	push   %ebp
  801765:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801767:	6a 00                	push   $0x0
  801769:	6a 00                	push   $0x0
  80176b:	6a 00                	push   $0x0
  80176d:	ff 75 0c             	pushl  0xc(%ebp)
  801770:	ff 75 08             	pushl  0x8(%ebp)
  801773:	6a 0f                	push   $0xf
  801775:	e8 b3 fe ff ff       	call   80162d <syscall>
  80177a:	83 c4 18             	add    $0x18,%esp
	return;
  80177d:	90                   	nop
}
  80177e:	c9                   	leave  
  80177f:	c3                   	ret    

00801780 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801780:	55                   	push   %ebp
  801781:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801783:	6a 00                	push   $0x0
  801785:	6a 00                	push   $0x0
  801787:	6a 00                	push   $0x0
  801789:	ff 75 0c             	pushl  0xc(%ebp)
  80178c:	ff 75 08             	pushl  0x8(%ebp)
  80178f:	6a 10                	push   $0x10
  801791:	e8 97 fe ff ff       	call   80162d <syscall>
  801796:	83 c4 18             	add    $0x18,%esp
	return ;
  801799:	90                   	nop
}
  80179a:	c9                   	leave  
  80179b:	c3                   	ret    

0080179c <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80179c:	55                   	push   %ebp
  80179d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80179f:	6a 00                	push   $0x0
  8017a1:	6a 00                	push   $0x0
  8017a3:	ff 75 10             	pushl  0x10(%ebp)
  8017a6:	ff 75 0c             	pushl  0xc(%ebp)
  8017a9:	ff 75 08             	pushl  0x8(%ebp)
  8017ac:	6a 11                	push   $0x11
  8017ae:	e8 7a fe ff ff       	call   80162d <syscall>
  8017b3:	83 c4 18             	add    $0x18,%esp
	return ;
  8017b6:	90                   	nop
}
  8017b7:	c9                   	leave  
  8017b8:	c3                   	ret    

008017b9 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8017b9:	55                   	push   %ebp
  8017ba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8017bc:	6a 00                	push   $0x0
  8017be:	6a 00                	push   $0x0
  8017c0:	6a 00                	push   $0x0
  8017c2:	6a 00                	push   $0x0
  8017c4:	6a 00                	push   $0x0
  8017c6:	6a 0c                	push   $0xc
  8017c8:	e8 60 fe ff ff       	call   80162d <syscall>
  8017cd:	83 c4 18             	add    $0x18,%esp
}
  8017d0:	c9                   	leave  
  8017d1:	c3                   	ret    

008017d2 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8017d2:	55                   	push   %ebp
  8017d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8017d5:	6a 00                	push   $0x0
  8017d7:	6a 00                	push   $0x0
  8017d9:	6a 00                	push   $0x0
  8017db:	6a 00                	push   $0x0
  8017dd:	ff 75 08             	pushl  0x8(%ebp)
  8017e0:	6a 0d                	push   $0xd
  8017e2:	e8 46 fe ff ff       	call   80162d <syscall>
  8017e7:	83 c4 18             	add    $0x18,%esp
}
  8017ea:	c9                   	leave  
  8017eb:	c3                   	ret    

008017ec <sys_scarce_memory>:

void sys_scarce_memory()
{
  8017ec:	55                   	push   %ebp
  8017ed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8017ef:	6a 00                	push   $0x0
  8017f1:	6a 00                	push   $0x0
  8017f3:	6a 00                	push   $0x0
  8017f5:	6a 00                	push   $0x0
  8017f7:	6a 00                	push   $0x0
  8017f9:	6a 0e                	push   $0xe
  8017fb:	e8 2d fe ff ff       	call   80162d <syscall>
  801800:	83 c4 18             	add    $0x18,%esp
}
  801803:	90                   	nop
  801804:	c9                   	leave  
  801805:	c3                   	ret    

00801806 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801806:	55                   	push   %ebp
  801807:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801809:	6a 00                	push   $0x0
  80180b:	6a 00                	push   $0x0
  80180d:	6a 00                	push   $0x0
  80180f:	6a 00                	push   $0x0
  801811:	6a 00                	push   $0x0
  801813:	6a 13                	push   $0x13
  801815:	e8 13 fe ff ff       	call   80162d <syscall>
  80181a:	83 c4 18             	add    $0x18,%esp
}
  80181d:	90                   	nop
  80181e:	c9                   	leave  
  80181f:	c3                   	ret    

00801820 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801820:	55                   	push   %ebp
  801821:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801823:	6a 00                	push   $0x0
  801825:	6a 00                	push   $0x0
  801827:	6a 00                	push   $0x0
  801829:	6a 00                	push   $0x0
  80182b:	6a 00                	push   $0x0
  80182d:	6a 14                	push   $0x14
  80182f:	e8 f9 fd ff ff       	call   80162d <syscall>
  801834:	83 c4 18             	add    $0x18,%esp
}
  801837:	90                   	nop
  801838:	c9                   	leave  
  801839:	c3                   	ret    

0080183a <sys_cputc>:


void
sys_cputc(const char c)
{
  80183a:	55                   	push   %ebp
  80183b:	89 e5                	mov    %esp,%ebp
  80183d:	83 ec 04             	sub    $0x4,%esp
  801840:	8b 45 08             	mov    0x8(%ebp),%eax
  801843:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801846:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80184a:	6a 00                	push   $0x0
  80184c:	6a 00                	push   $0x0
  80184e:	6a 00                	push   $0x0
  801850:	6a 00                	push   $0x0
  801852:	50                   	push   %eax
  801853:	6a 15                	push   $0x15
  801855:	e8 d3 fd ff ff       	call   80162d <syscall>
  80185a:	83 c4 18             	add    $0x18,%esp
}
  80185d:	90                   	nop
  80185e:	c9                   	leave  
  80185f:	c3                   	ret    

00801860 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801860:	55                   	push   %ebp
  801861:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801863:	6a 00                	push   $0x0
  801865:	6a 00                	push   $0x0
  801867:	6a 00                	push   $0x0
  801869:	6a 00                	push   $0x0
  80186b:	6a 00                	push   $0x0
  80186d:	6a 16                	push   $0x16
  80186f:	e8 b9 fd ff ff       	call   80162d <syscall>
  801874:	83 c4 18             	add    $0x18,%esp
}
  801877:	90                   	nop
  801878:	c9                   	leave  
  801879:	c3                   	ret    

0080187a <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80187a:	55                   	push   %ebp
  80187b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80187d:	8b 45 08             	mov    0x8(%ebp),%eax
  801880:	6a 00                	push   $0x0
  801882:	6a 00                	push   $0x0
  801884:	6a 00                	push   $0x0
  801886:	ff 75 0c             	pushl  0xc(%ebp)
  801889:	50                   	push   %eax
  80188a:	6a 17                	push   $0x17
  80188c:	e8 9c fd ff ff       	call   80162d <syscall>
  801891:	83 c4 18             	add    $0x18,%esp
}
  801894:	c9                   	leave  
  801895:	c3                   	ret    

00801896 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801896:	55                   	push   %ebp
  801897:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801899:	8b 55 0c             	mov    0xc(%ebp),%edx
  80189c:	8b 45 08             	mov    0x8(%ebp),%eax
  80189f:	6a 00                	push   $0x0
  8018a1:	6a 00                	push   $0x0
  8018a3:	6a 00                	push   $0x0
  8018a5:	52                   	push   %edx
  8018a6:	50                   	push   %eax
  8018a7:	6a 1a                	push   $0x1a
  8018a9:	e8 7f fd ff ff       	call   80162d <syscall>
  8018ae:	83 c4 18             	add    $0x18,%esp
}
  8018b1:	c9                   	leave  
  8018b2:	c3                   	ret    

008018b3 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8018b3:	55                   	push   %ebp
  8018b4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bc:	6a 00                	push   $0x0
  8018be:	6a 00                	push   $0x0
  8018c0:	6a 00                	push   $0x0
  8018c2:	52                   	push   %edx
  8018c3:	50                   	push   %eax
  8018c4:	6a 18                	push   $0x18
  8018c6:	e8 62 fd ff ff       	call   80162d <syscall>
  8018cb:	83 c4 18             	add    $0x18,%esp
}
  8018ce:	90                   	nop
  8018cf:	c9                   	leave  
  8018d0:	c3                   	ret    

008018d1 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8018d1:	55                   	push   %ebp
  8018d2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018da:	6a 00                	push   $0x0
  8018dc:	6a 00                	push   $0x0
  8018de:	6a 00                	push   $0x0
  8018e0:	52                   	push   %edx
  8018e1:	50                   	push   %eax
  8018e2:	6a 19                	push   $0x19
  8018e4:	e8 44 fd ff ff       	call   80162d <syscall>
  8018e9:	83 c4 18             	add    $0x18,%esp
}
  8018ec:	90                   	nop
  8018ed:	c9                   	leave  
  8018ee:	c3                   	ret    

008018ef <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8018ef:	55                   	push   %ebp
  8018f0:	89 e5                	mov    %esp,%ebp
  8018f2:	83 ec 04             	sub    $0x4,%esp
  8018f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8018f8:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8018fb:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8018fe:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801902:	8b 45 08             	mov    0x8(%ebp),%eax
  801905:	6a 00                	push   $0x0
  801907:	51                   	push   %ecx
  801908:	52                   	push   %edx
  801909:	ff 75 0c             	pushl  0xc(%ebp)
  80190c:	50                   	push   %eax
  80190d:	6a 1b                	push   $0x1b
  80190f:	e8 19 fd ff ff       	call   80162d <syscall>
  801914:	83 c4 18             	add    $0x18,%esp
}
  801917:	c9                   	leave  
  801918:	c3                   	ret    

00801919 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801919:	55                   	push   %ebp
  80191a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80191c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80191f:	8b 45 08             	mov    0x8(%ebp),%eax
  801922:	6a 00                	push   $0x0
  801924:	6a 00                	push   $0x0
  801926:	6a 00                	push   $0x0
  801928:	52                   	push   %edx
  801929:	50                   	push   %eax
  80192a:	6a 1c                	push   $0x1c
  80192c:	e8 fc fc ff ff       	call   80162d <syscall>
  801931:	83 c4 18             	add    $0x18,%esp
}
  801934:	c9                   	leave  
  801935:	c3                   	ret    

00801936 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801936:	55                   	push   %ebp
  801937:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801939:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80193c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80193f:	8b 45 08             	mov    0x8(%ebp),%eax
  801942:	6a 00                	push   $0x0
  801944:	6a 00                	push   $0x0
  801946:	51                   	push   %ecx
  801947:	52                   	push   %edx
  801948:	50                   	push   %eax
  801949:	6a 1d                	push   $0x1d
  80194b:	e8 dd fc ff ff       	call   80162d <syscall>
  801950:	83 c4 18             	add    $0x18,%esp
}
  801953:	c9                   	leave  
  801954:	c3                   	ret    

00801955 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801955:	55                   	push   %ebp
  801956:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801958:	8b 55 0c             	mov    0xc(%ebp),%edx
  80195b:	8b 45 08             	mov    0x8(%ebp),%eax
  80195e:	6a 00                	push   $0x0
  801960:	6a 00                	push   $0x0
  801962:	6a 00                	push   $0x0
  801964:	52                   	push   %edx
  801965:	50                   	push   %eax
  801966:	6a 1e                	push   $0x1e
  801968:	e8 c0 fc ff ff       	call   80162d <syscall>
  80196d:	83 c4 18             	add    $0x18,%esp
}
  801970:	c9                   	leave  
  801971:	c3                   	ret    

00801972 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801972:	55                   	push   %ebp
  801973:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801975:	6a 00                	push   $0x0
  801977:	6a 00                	push   $0x0
  801979:	6a 00                	push   $0x0
  80197b:	6a 00                	push   $0x0
  80197d:	6a 00                	push   $0x0
  80197f:	6a 1f                	push   $0x1f
  801981:	e8 a7 fc ff ff       	call   80162d <syscall>
  801986:	83 c4 18             	add    $0x18,%esp
}
  801989:	c9                   	leave  
  80198a:	c3                   	ret    

0080198b <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80198b:	55                   	push   %ebp
  80198c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80198e:	8b 45 08             	mov    0x8(%ebp),%eax
  801991:	6a 00                	push   $0x0
  801993:	ff 75 14             	pushl  0x14(%ebp)
  801996:	ff 75 10             	pushl  0x10(%ebp)
  801999:	ff 75 0c             	pushl  0xc(%ebp)
  80199c:	50                   	push   %eax
  80199d:	6a 20                	push   $0x20
  80199f:	e8 89 fc ff ff       	call   80162d <syscall>
  8019a4:	83 c4 18             	add    $0x18,%esp
}
  8019a7:	c9                   	leave  
  8019a8:	c3                   	ret    

008019a9 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8019a9:	55                   	push   %ebp
  8019aa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8019ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8019af:	6a 00                	push   $0x0
  8019b1:	6a 00                	push   $0x0
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 00                	push   $0x0
  8019b7:	50                   	push   %eax
  8019b8:	6a 21                	push   $0x21
  8019ba:	e8 6e fc ff ff       	call   80162d <syscall>
  8019bf:	83 c4 18             	add    $0x18,%esp
}
  8019c2:	90                   	nop
  8019c3:	c9                   	leave  
  8019c4:	c3                   	ret    

008019c5 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8019c5:	55                   	push   %ebp
  8019c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8019c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	50                   	push   %eax
  8019d4:	6a 22                	push   $0x22
  8019d6:	e8 52 fc ff ff       	call   80162d <syscall>
  8019db:	83 c4 18             	add    $0x18,%esp
}
  8019de:	c9                   	leave  
  8019df:	c3                   	ret    

008019e0 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8019e0:	55                   	push   %ebp
  8019e1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 02                	push   $0x2
  8019ef:	e8 39 fc ff ff       	call   80162d <syscall>
  8019f4:	83 c4 18             	add    $0x18,%esp
}
  8019f7:	c9                   	leave  
  8019f8:	c3                   	ret    

008019f9 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8019f9:	55                   	push   %ebp
  8019fa:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8019fc:	6a 00                	push   $0x0
  8019fe:	6a 00                	push   $0x0
  801a00:	6a 00                	push   $0x0
  801a02:	6a 00                	push   $0x0
  801a04:	6a 00                	push   $0x0
  801a06:	6a 03                	push   $0x3
  801a08:	e8 20 fc ff ff       	call   80162d <syscall>
  801a0d:	83 c4 18             	add    $0x18,%esp
}
  801a10:	c9                   	leave  
  801a11:	c3                   	ret    

00801a12 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801a12:	55                   	push   %ebp
  801a13:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801a15:	6a 00                	push   $0x0
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 04                	push   $0x4
  801a21:	e8 07 fc ff ff       	call   80162d <syscall>
  801a26:	83 c4 18             	add    $0x18,%esp
}
  801a29:	c9                   	leave  
  801a2a:	c3                   	ret    

00801a2b <sys_exit_env>:


void sys_exit_env(void)
{
  801a2b:	55                   	push   %ebp
  801a2c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 00                	push   $0x0
  801a32:	6a 00                	push   $0x0
  801a34:	6a 00                	push   $0x0
  801a36:	6a 00                	push   $0x0
  801a38:	6a 23                	push   $0x23
  801a3a:	e8 ee fb ff ff       	call   80162d <syscall>
  801a3f:	83 c4 18             	add    $0x18,%esp
}
  801a42:	90                   	nop
  801a43:	c9                   	leave  
  801a44:	c3                   	ret    

00801a45 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801a45:	55                   	push   %ebp
  801a46:	89 e5                	mov    %esp,%ebp
  801a48:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801a4b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a4e:	8d 50 04             	lea    0x4(%eax),%edx
  801a51:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a54:	6a 00                	push   $0x0
  801a56:	6a 00                	push   $0x0
  801a58:	6a 00                	push   $0x0
  801a5a:	52                   	push   %edx
  801a5b:	50                   	push   %eax
  801a5c:	6a 24                	push   $0x24
  801a5e:	e8 ca fb ff ff       	call   80162d <syscall>
  801a63:	83 c4 18             	add    $0x18,%esp
	return result;
  801a66:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a69:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a6c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a6f:	89 01                	mov    %eax,(%ecx)
  801a71:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801a74:	8b 45 08             	mov    0x8(%ebp),%eax
  801a77:	c9                   	leave  
  801a78:	c2 04 00             	ret    $0x4

00801a7b <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801a7b:	55                   	push   %ebp
  801a7c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	ff 75 10             	pushl  0x10(%ebp)
  801a85:	ff 75 0c             	pushl  0xc(%ebp)
  801a88:	ff 75 08             	pushl  0x8(%ebp)
  801a8b:	6a 12                	push   $0x12
  801a8d:	e8 9b fb ff ff       	call   80162d <syscall>
  801a92:	83 c4 18             	add    $0x18,%esp
	return ;
  801a95:	90                   	nop
}
  801a96:	c9                   	leave  
  801a97:	c3                   	ret    

00801a98 <sys_rcr2>:
uint32 sys_rcr2()
{
  801a98:	55                   	push   %ebp
  801a99:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801a9b:	6a 00                	push   $0x0
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 00                	push   $0x0
  801aa3:	6a 00                	push   $0x0
  801aa5:	6a 25                	push   $0x25
  801aa7:	e8 81 fb ff ff       	call   80162d <syscall>
  801aac:	83 c4 18             	add    $0x18,%esp
}
  801aaf:	c9                   	leave  
  801ab0:	c3                   	ret    

00801ab1 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801ab1:	55                   	push   %ebp
  801ab2:	89 e5                	mov    %esp,%ebp
  801ab4:	83 ec 04             	sub    $0x4,%esp
  801ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aba:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801abd:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801ac1:	6a 00                	push   $0x0
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	50                   	push   %eax
  801aca:	6a 26                	push   $0x26
  801acc:	e8 5c fb ff ff       	call   80162d <syscall>
  801ad1:	83 c4 18             	add    $0x18,%esp
	return ;
  801ad4:	90                   	nop
}
  801ad5:	c9                   	leave  
  801ad6:	c3                   	ret    

00801ad7 <rsttst>:
void rsttst()
{
  801ad7:	55                   	push   %ebp
  801ad8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ada:	6a 00                	push   $0x0
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 00                	push   $0x0
  801ae4:	6a 28                	push   $0x28
  801ae6:	e8 42 fb ff ff       	call   80162d <syscall>
  801aeb:	83 c4 18             	add    $0x18,%esp
	return ;
  801aee:	90                   	nop
}
  801aef:	c9                   	leave  
  801af0:	c3                   	ret    

00801af1 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801af1:	55                   	push   %ebp
  801af2:	89 e5                	mov    %esp,%ebp
  801af4:	83 ec 04             	sub    $0x4,%esp
  801af7:	8b 45 14             	mov    0x14(%ebp),%eax
  801afa:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801afd:	8b 55 18             	mov    0x18(%ebp),%edx
  801b00:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b04:	52                   	push   %edx
  801b05:	50                   	push   %eax
  801b06:	ff 75 10             	pushl  0x10(%ebp)
  801b09:	ff 75 0c             	pushl  0xc(%ebp)
  801b0c:	ff 75 08             	pushl  0x8(%ebp)
  801b0f:	6a 27                	push   $0x27
  801b11:	e8 17 fb ff ff       	call   80162d <syscall>
  801b16:	83 c4 18             	add    $0x18,%esp
	return ;
  801b19:	90                   	nop
}
  801b1a:	c9                   	leave  
  801b1b:	c3                   	ret    

00801b1c <chktst>:
void chktst(uint32 n)
{
  801b1c:	55                   	push   %ebp
  801b1d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801b1f:	6a 00                	push   $0x0
  801b21:	6a 00                	push   $0x0
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	ff 75 08             	pushl  0x8(%ebp)
  801b2a:	6a 29                	push   $0x29
  801b2c:	e8 fc fa ff ff       	call   80162d <syscall>
  801b31:	83 c4 18             	add    $0x18,%esp
	return ;
  801b34:	90                   	nop
}
  801b35:	c9                   	leave  
  801b36:	c3                   	ret    

00801b37 <inctst>:

void inctst()
{
  801b37:	55                   	push   %ebp
  801b38:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801b3a:	6a 00                	push   $0x0
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 00                	push   $0x0
  801b42:	6a 00                	push   $0x0
  801b44:	6a 2a                	push   $0x2a
  801b46:	e8 e2 fa ff ff       	call   80162d <syscall>
  801b4b:	83 c4 18             	add    $0x18,%esp
	return ;
  801b4e:	90                   	nop
}
  801b4f:	c9                   	leave  
  801b50:	c3                   	ret    

00801b51 <gettst>:
uint32 gettst()
{
  801b51:	55                   	push   %ebp
  801b52:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801b54:	6a 00                	push   $0x0
  801b56:	6a 00                	push   $0x0
  801b58:	6a 00                	push   $0x0
  801b5a:	6a 00                	push   $0x0
  801b5c:	6a 00                	push   $0x0
  801b5e:	6a 2b                	push   $0x2b
  801b60:	e8 c8 fa ff ff       	call   80162d <syscall>
  801b65:	83 c4 18             	add    $0x18,%esp
}
  801b68:	c9                   	leave  
  801b69:	c3                   	ret    

00801b6a <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801b6a:	55                   	push   %ebp
  801b6b:	89 e5                	mov    %esp,%ebp
  801b6d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b70:	6a 00                	push   $0x0
  801b72:	6a 00                	push   $0x0
  801b74:	6a 00                	push   $0x0
  801b76:	6a 00                	push   $0x0
  801b78:	6a 00                	push   $0x0
  801b7a:	6a 2c                	push   $0x2c
  801b7c:	e8 ac fa ff ff       	call   80162d <syscall>
  801b81:	83 c4 18             	add    $0x18,%esp
  801b84:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801b87:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801b8b:	75 07                	jne    801b94 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801b8d:	b8 01 00 00 00       	mov    $0x1,%eax
  801b92:	eb 05                	jmp    801b99 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801b94:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b99:	c9                   	leave  
  801b9a:	c3                   	ret    

00801b9b <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801b9b:	55                   	push   %ebp
  801b9c:	89 e5                	mov    %esp,%ebp
  801b9e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ba1:	6a 00                	push   $0x0
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 2c                	push   $0x2c
  801bad:	e8 7b fa ff ff       	call   80162d <syscall>
  801bb2:	83 c4 18             	add    $0x18,%esp
  801bb5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801bb8:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801bbc:	75 07                	jne    801bc5 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801bbe:	b8 01 00 00 00       	mov    $0x1,%eax
  801bc3:	eb 05                	jmp    801bca <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801bc5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bca:	c9                   	leave  
  801bcb:	c3                   	ret    

00801bcc <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801bcc:	55                   	push   %ebp
  801bcd:	89 e5                	mov    %esp,%ebp
  801bcf:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 2c                	push   $0x2c
  801bde:	e8 4a fa ff ff       	call   80162d <syscall>
  801be3:	83 c4 18             	add    $0x18,%esp
  801be6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801be9:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801bed:	75 07                	jne    801bf6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801bef:	b8 01 00 00 00       	mov    $0x1,%eax
  801bf4:	eb 05                	jmp    801bfb <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801bf6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bfb:	c9                   	leave  
  801bfc:	c3                   	ret    

00801bfd <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801bfd:	55                   	push   %ebp
  801bfe:	89 e5                	mov    %esp,%ebp
  801c00:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 2c                	push   $0x2c
  801c0f:	e8 19 fa ff ff       	call   80162d <syscall>
  801c14:	83 c4 18             	add    $0x18,%esp
  801c17:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801c1a:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801c1e:	75 07                	jne    801c27 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801c20:	b8 01 00 00 00       	mov    $0x1,%eax
  801c25:	eb 05                	jmp    801c2c <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801c27:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c2c:	c9                   	leave  
  801c2d:	c3                   	ret    

00801c2e <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c2e:	55                   	push   %ebp
  801c2f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c31:	6a 00                	push   $0x0
  801c33:	6a 00                	push   $0x0
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	ff 75 08             	pushl  0x8(%ebp)
  801c3c:	6a 2d                	push   $0x2d
  801c3e:	e8 ea f9 ff ff       	call   80162d <syscall>
  801c43:	83 c4 18             	add    $0x18,%esp
	return ;
  801c46:	90                   	nop
}
  801c47:	c9                   	leave  
  801c48:	c3                   	ret    

00801c49 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801c49:	55                   	push   %ebp
  801c4a:	89 e5                	mov    %esp,%ebp
  801c4c:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801c4d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c50:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c53:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c56:	8b 45 08             	mov    0x8(%ebp),%eax
  801c59:	6a 00                	push   $0x0
  801c5b:	53                   	push   %ebx
  801c5c:	51                   	push   %ecx
  801c5d:	52                   	push   %edx
  801c5e:	50                   	push   %eax
  801c5f:	6a 2e                	push   $0x2e
  801c61:	e8 c7 f9 ff ff       	call   80162d <syscall>
  801c66:	83 c4 18             	add    $0x18,%esp
}
  801c69:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c6c:	c9                   	leave  
  801c6d:	c3                   	ret    

00801c6e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801c6e:	55                   	push   %ebp
  801c6f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801c71:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c74:	8b 45 08             	mov    0x8(%ebp),%eax
  801c77:	6a 00                	push   $0x0
  801c79:	6a 00                	push   $0x0
  801c7b:	6a 00                	push   $0x0
  801c7d:	52                   	push   %edx
  801c7e:	50                   	push   %eax
  801c7f:	6a 2f                	push   $0x2f
  801c81:	e8 a7 f9 ff ff       	call   80162d <syscall>
  801c86:	83 c4 18             	add    $0x18,%esp
}
  801c89:	c9                   	leave  
  801c8a:	c3                   	ret    

00801c8b <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801c8b:	55                   	push   %ebp
  801c8c:	89 e5                	mov    %esp,%ebp
  801c8e:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801c91:	83 ec 0c             	sub    $0xc,%esp
  801c94:	68 d8 3e 80 00       	push   $0x803ed8
  801c99:	e8 d3 e8 ff ff       	call   800571 <cprintf>
  801c9e:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801ca1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801ca8:	83 ec 0c             	sub    $0xc,%esp
  801cab:	68 04 3f 80 00       	push   $0x803f04
  801cb0:	e8 bc e8 ff ff       	call   800571 <cprintf>
  801cb5:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801cb8:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801cbc:	a1 38 51 80 00       	mov    0x805138,%eax
  801cc1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801cc4:	eb 56                	jmp    801d1c <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801cc6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801cca:	74 1c                	je     801ce8 <print_mem_block_lists+0x5d>
  801ccc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ccf:	8b 50 08             	mov    0x8(%eax),%edx
  801cd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cd5:	8b 48 08             	mov    0x8(%eax),%ecx
  801cd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cdb:	8b 40 0c             	mov    0xc(%eax),%eax
  801cde:	01 c8                	add    %ecx,%eax
  801ce0:	39 c2                	cmp    %eax,%edx
  801ce2:	73 04                	jae    801ce8 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801ce4:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801ce8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ceb:	8b 50 08             	mov    0x8(%eax),%edx
  801cee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cf1:	8b 40 0c             	mov    0xc(%eax),%eax
  801cf4:	01 c2                	add    %eax,%edx
  801cf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cf9:	8b 40 08             	mov    0x8(%eax),%eax
  801cfc:	83 ec 04             	sub    $0x4,%esp
  801cff:	52                   	push   %edx
  801d00:	50                   	push   %eax
  801d01:	68 19 3f 80 00       	push   $0x803f19
  801d06:	e8 66 e8 ff ff       	call   800571 <cprintf>
  801d0b:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801d0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d11:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d14:	a1 40 51 80 00       	mov    0x805140,%eax
  801d19:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d1c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d20:	74 07                	je     801d29 <print_mem_block_lists+0x9e>
  801d22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d25:	8b 00                	mov    (%eax),%eax
  801d27:	eb 05                	jmp    801d2e <print_mem_block_lists+0xa3>
  801d29:	b8 00 00 00 00       	mov    $0x0,%eax
  801d2e:	a3 40 51 80 00       	mov    %eax,0x805140
  801d33:	a1 40 51 80 00       	mov    0x805140,%eax
  801d38:	85 c0                	test   %eax,%eax
  801d3a:	75 8a                	jne    801cc6 <print_mem_block_lists+0x3b>
  801d3c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d40:	75 84                	jne    801cc6 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801d42:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801d46:	75 10                	jne    801d58 <print_mem_block_lists+0xcd>
  801d48:	83 ec 0c             	sub    $0xc,%esp
  801d4b:	68 28 3f 80 00       	push   $0x803f28
  801d50:	e8 1c e8 ff ff       	call   800571 <cprintf>
  801d55:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801d58:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801d5f:	83 ec 0c             	sub    $0xc,%esp
  801d62:	68 4c 3f 80 00       	push   $0x803f4c
  801d67:	e8 05 e8 ff ff       	call   800571 <cprintf>
  801d6c:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801d6f:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801d73:	a1 40 50 80 00       	mov    0x805040,%eax
  801d78:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d7b:	eb 56                	jmp    801dd3 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801d7d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d81:	74 1c                	je     801d9f <print_mem_block_lists+0x114>
  801d83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d86:	8b 50 08             	mov    0x8(%eax),%edx
  801d89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d8c:	8b 48 08             	mov    0x8(%eax),%ecx
  801d8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d92:	8b 40 0c             	mov    0xc(%eax),%eax
  801d95:	01 c8                	add    %ecx,%eax
  801d97:	39 c2                	cmp    %eax,%edx
  801d99:	73 04                	jae    801d9f <print_mem_block_lists+0x114>
			sorted = 0 ;
  801d9b:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801d9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801da2:	8b 50 08             	mov    0x8(%eax),%edx
  801da5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801da8:	8b 40 0c             	mov    0xc(%eax),%eax
  801dab:	01 c2                	add    %eax,%edx
  801dad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db0:	8b 40 08             	mov    0x8(%eax),%eax
  801db3:	83 ec 04             	sub    $0x4,%esp
  801db6:	52                   	push   %edx
  801db7:	50                   	push   %eax
  801db8:	68 19 3f 80 00       	push   $0x803f19
  801dbd:	e8 af e7 ff ff       	call   800571 <cprintf>
  801dc2:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801dc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801dcb:	a1 48 50 80 00       	mov    0x805048,%eax
  801dd0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dd3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801dd7:	74 07                	je     801de0 <print_mem_block_lists+0x155>
  801dd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ddc:	8b 00                	mov    (%eax),%eax
  801dde:	eb 05                	jmp    801de5 <print_mem_block_lists+0x15a>
  801de0:	b8 00 00 00 00       	mov    $0x0,%eax
  801de5:	a3 48 50 80 00       	mov    %eax,0x805048
  801dea:	a1 48 50 80 00       	mov    0x805048,%eax
  801def:	85 c0                	test   %eax,%eax
  801df1:	75 8a                	jne    801d7d <print_mem_block_lists+0xf2>
  801df3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801df7:	75 84                	jne    801d7d <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801df9:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801dfd:	75 10                	jne    801e0f <print_mem_block_lists+0x184>
  801dff:	83 ec 0c             	sub    $0xc,%esp
  801e02:	68 64 3f 80 00       	push   $0x803f64
  801e07:	e8 65 e7 ff ff       	call   800571 <cprintf>
  801e0c:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801e0f:	83 ec 0c             	sub    $0xc,%esp
  801e12:	68 d8 3e 80 00       	push   $0x803ed8
  801e17:	e8 55 e7 ff ff       	call   800571 <cprintf>
  801e1c:	83 c4 10             	add    $0x10,%esp

}
  801e1f:	90                   	nop
  801e20:	c9                   	leave  
  801e21:	c3                   	ret    

00801e22 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801e22:	55                   	push   %ebp
  801e23:	89 e5                	mov    %esp,%ebp
  801e25:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801e28:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  801e2f:	00 00 00 
  801e32:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  801e39:	00 00 00 
  801e3c:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  801e43:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801e46:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801e4d:	e9 9e 00 00 00       	jmp    801ef0 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801e52:	a1 50 50 80 00       	mov    0x805050,%eax
  801e57:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e5a:	c1 e2 04             	shl    $0x4,%edx
  801e5d:	01 d0                	add    %edx,%eax
  801e5f:	85 c0                	test   %eax,%eax
  801e61:	75 14                	jne    801e77 <initialize_MemBlocksList+0x55>
  801e63:	83 ec 04             	sub    $0x4,%esp
  801e66:	68 8c 3f 80 00       	push   $0x803f8c
  801e6b:	6a 46                	push   $0x46
  801e6d:	68 af 3f 80 00       	push   $0x803faf
  801e72:	e8 46 e4 ff ff       	call   8002bd <_panic>
  801e77:	a1 50 50 80 00       	mov    0x805050,%eax
  801e7c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e7f:	c1 e2 04             	shl    $0x4,%edx
  801e82:	01 d0                	add    %edx,%eax
  801e84:	8b 15 48 51 80 00    	mov    0x805148,%edx
  801e8a:	89 10                	mov    %edx,(%eax)
  801e8c:	8b 00                	mov    (%eax),%eax
  801e8e:	85 c0                	test   %eax,%eax
  801e90:	74 18                	je     801eaa <initialize_MemBlocksList+0x88>
  801e92:	a1 48 51 80 00       	mov    0x805148,%eax
  801e97:	8b 15 50 50 80 00    	mov    0x805050,%edx
  801e9d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801ea0:	c1 e1 04             	shl    $0x4,%ecx
  801ea3:	01 ca                	add    %ecx,%edx
  801ea5:	89 50 04             	mov    %edx,0x4(%eax)
  801ea8:	eb 12                	jmp    801ebc <initialize_MemBlocksList+0x9a>
  801eaa:	a1 50 50 80 00       	mov    0x805050,%eax
  801eaf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801eb2:	c1 e2 04             	shl    $0x4,%edx
  801eb5:	01 d0                	add    %edx,%eax
  801eb7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801ebc:	a1 50 50 80 00       	mov    0x805050,%eax
  801ec1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ec4:	c1 e2 04             	shl    $0x4,%edx
  801ec7:	01 d0                	add    %edx,%eax
  801ec9:	a3 48 51 80 00       	mov    %eax,0x805148
  801ece:	a1 50 50 80 00       	mov    0x805050,%eax
  801ed3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ed6:	c1 e2 04             	shl    $0x4,%edx
  801ed9:	01 d0                	add    %edx,%eax
  801edb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801ee2:	a1 54 51 80 00       	mov    0x805154,%eax
  801ee7:	40                   	inc    %eax
  801ee8:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801eed:	ff 45 f4             	incl   -0xc(%ebp)
  801ef0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef3:	3b 45 08             	cmp    0x8(%ebp),%eax
  801ef6:	0f 82 56 ff ff ff    	jb     801e52 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801efc:	90                   	nop
  801efd:	c9                   	leave  
  801efe:	c3                   	ret    

00801eff <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801eff:	55                   	push   %ebp
  801f00:	89 e5                	mov    %esp,%ebp
  801f02:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801f05:	8b 45 08             	mov    0x8(%ebp),%eax
  801f08:	8b 00                	mov    (%eax),%eax
  801f0a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f0d:	eb 19                	jmp    801f28 <find_block+0x29>
	{
		if(va==point->sva)
  801f0f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f12:	8b 40 08             	mov    0x8(%eax),%eax
  801f15:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801f18:	75 05                	jne    801f1f <find_block+0x20>
		   return point;
  801f1a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f1d:	eb 36                	jmp    801f55 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f22:	8b 40 08             	mov    0x8(%eax),%eax
  801f25:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f28:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f2c:	74 07                	je     801f35 <find_block+0x36>
  801f2e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f31:	8b 00                	mov    (%eax),%eax
  801f33:	eb 05                	jmp    801f3a <find_block+0x3b>
  801f35:	b8 00 00 00 00       	mov    $0x0,%eax
  801f3a:	8b 55 08             	mov    0x8(%ebp),%edx
  801f3d:	89 42 08             	mov    %eax,0x8(%edx)
  801f40:	8b 45 08             	mov    0x8(%ebp),%eax
  801f43:	8b 40 08             	mov    0x8(%eax),%eax
  801f46:	85 c0                	test   %eax,%eax
  801f48:	75 c5                	jne    801f0f <find_block+0x10>
  801f4a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f4e:	75 bf                	jne    801f0f <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  801f50:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f55:	c9                   	leave  
  801f56:	c3                   	ret    

00801f57 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  801f57:	55                   	push   %ebp
  801f58:	89 e5                	mov    %esp,%ebp
  801f5a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  801f5d:	a1 40 50 80 00       	mov    0x805040,%eax
  801f62:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  801f65:	a1 44 50 80 00       	mov    0x805044,%eax
  801f6a:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  801f6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f70:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801f73:	74 24                	je     801f99 <insert_sorted_allocList+0x42>
  801f75:	8b 45 08             	mov    0x8(%ebp),%eax
  801f78:	8b 50 08             	mov    0x8(%eax),%edx
  801f7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f7e:	8b 40 08             	mov    0x8(%eax),%eax
  801f81:	39 c2                	cmp    %eax,%edx
  801f83:	76 14                	jbe    801f99 <insert_sorted_allocList+0x42>
  801f85:	8b 45 08             	mov    0x8(%ebp),%eax
  801f88:	8b 50 08             	mov    0x8(%eax),%edx
  801f8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f8e:	8b 40 08             	mov    0x8(%eax),%eax
  801f91:	39 c2                	cmp    %eax,%edx
  801f93:	0f 82 60 01 00 00    	jb     8020f9 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  801f99:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f9d:	75 65                	jne    802004 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  801f9f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801fa3:	75 14                	jne    801fb9 <insert_sorted_allocList+0x62>
  801fa5:	83 ec 04             	sub    $0x4,%esp
  801fa8:	68 8c 3f 80 00       	push   $0x803f8c
  801fad:	6a 6b                	push   $0x6b
  801faf:	68 af 3f 80 00       	push   $0x803faf
  801fb4:	e8 04 e3 ff ff       	call   8002bd <_panic>
  801fb9:	8b 15 40 50 80 00    	mov    0x805040,%edx
  801fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc2:	89 10                	mov    %edx,(%eax)
  801fc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc7:	8b 00                	mov    (%eax),%eax
  801fc9:	85 c0                	test   %eax,%eax
  801fcb:	74 0d                	je     801fda <insert_sorted_allocList+0x83>
  801fcd:	a1 40 50 80 00       	mov    0x805040,%eax
  801fd2:	8b 55 08             	mov    0x8(%ebp),%edx
  801fd5:	89 50 04             	mov    %edx,0x4(%eax)
  801fd8:	eb 08                	jmp    801fe2 <insert_sorted_allocList+0x8b>
  801fda:	8b 45 08             	mov    0x8(%ebp),%eax
  801fdd:	a3 44 50 80 00       	mov    %eax,0x805044
  801fe2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe5:	a3 40 50 80 00       	mov    %eax,0x805040
  801fea:	8b 45 08             	mov    0x8(%ebp),%eax
  801fed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801ff4:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801ff9:	40                   	inc    %eax
  801ffa:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  801fff:	e9 dc 01 00 00       	jmp    8021e0 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802004:	8b 45 08             	mov    0x8(%ebp),%eax
  802007:	8b 50 08             	mov    0x8(%eax),%edx
  80200a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80200d:	8b 40 08             	mov    0x8(%eax),%eax
  802010:	39 c2                	cmp    %eax,%edx
  802012:	77 6c                	ja     802080 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802014:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802018:	74 06                	je     802020 <insert_sorted_allocList+0xc9>
  80201a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80201e:	75 14                	jne    802034 <insert_sorted_allocList+0xdd>
  802020:	83 ec 04             	sub    $0x4,%esp
  802023:	68 c8 3f 80 00       	push   $0x803fc8
  802028:	6a 6f                	push   $0x6f
  80202a:	68 af 3f 80 00       	push   $0x803faf
  80202f:	e8 89 e2 ff ff       	call   8002bd <_panic>
  802034:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802037:	8b 50 04             	mov    0x4(%eax),%edx
  80203a:	8b 45 08             	mov    0x8(%ebp),%eax
  80203d:	89 50 04             	mov    %edx,0x4(%eax)
  802040:	8b 45 08             	mov    0x8(%ebp),%eax
  802043:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802046:	89 10                	mov    %edx,(%eax)
  802048:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80204b:	8b 40 04             	mov    0x4(%eax),%eax
  80204e:	85 c0                	test   %eax,%eax
  802050:	74 0d                	je     80205f <insert_sorted_allocList+0x108>
  802052:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802055:	8b 40 04             	mov    0x4(%eax),%eax
  802058:	8b 55 08             	mov    0x8(%ebp),%edx
  80205b:	89 10                	mov    %edx,(%eax)
  80205d:	eb 08                	jmp    802067 <insert_sorted_allocList+0x110>
  80205f:	8b 45 08             	mov    0x8(%ebp),%eax
  802062:	a3 40 50 80 00       	mov    %eax,0x805040
  802067:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80206a:	8b 55 08             	mov    0x8(%ebp),%edx
  80206d:	89 50 04             	mov    %edx,0x4(%eax)
  802070:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802075:	40                   	inc    %eax
  802076:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80207b:	e9 60 01 00 00       	jmp    8021e0 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802080:	8b 45 08             	mov    0x8(%ebp),%eax
  802083:	8b 50 08             	mov    0x8(%eax),%edx
  802086:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802089:	8b 40 08             	mov    0x8(%eax),%eax
  80208c:	39 c2                	cmp    %eax,%edx
  80208e:	0f 82 4c 01 00 00    	jb     8021e0 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802094:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802098:	75 14                	jne    8020ae <insert_sorted_allocList+0x157>
  80209a:	83 ec 04             	sub    $0x4,%esp
  80209d:	68 00 40 80 00       	push   $0x804000
  8020a2:	6a 73                	push   $0x73
  8020a4:	68 af 3f 80 00       	push   $0x803faf
  8020a9:	e8 0f e2 ff ff       	call   8002bd <_panic>
  8020ae:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8020b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b7:	89 50 04             	mov    %edx,0x4(%eax)
  8020ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bd:	8b 40 04             	mov    0x4(%eax),%eax
  8020c0:	85 c0                	test   %eax,%eax
  8020c2:	74 0c                	je     8020d0 <insert_sorted_allocList+0x179>
  8020c4:	a1 44 50 80 00       	mov    0x805044,%eax
  8020c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8020cc:	89 10                	mov    %edx,(%eax)
  8020ce:	eb 08                	jmp    8020d8 <insert_sorted_allocList+0x181>
  8020d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d3:	a3 40 50 80 00       	mov    %eax,0x805040
  8020d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020db:	a3 44 50 80 00       	mov    %eax,0x805044
  8020e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8020e9:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8020ee:	40                   	inc    %eax
  8020ef:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8020f4:	e9 e7 00 00 00       	jmp    8021e0 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8020f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8020ff:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802106:	a1 40 50 80 00       	mov    0x805040,%eax
  80210b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80210e:	e9 9d 00 00 00       	jmp    8021b0 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802113:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802116:	8b 00                	mov    (%eax),%eax
  802118:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  80211b:	8b 45 08             	mov    0x8(%ebp),%eax
  80211e:	8b 50 08             	mov    0x8(%eax),%edx
  802121:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802124:	8b 40 08             	mov    0x8(%eax),%eax
  802127:	39 c2                	cmp    %eax,%edx
  802129:	76 7d                	jbe    8021a8 <insert_sorted_allocList+0x251>
  80212b:	8b 45 08             	mov    0x8(%ebp),%eax
  80212e:	8b 50 08             	mov    0x8(%eax),%edx
  802131:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802134:	8b 40 08             	mov    0x8(%eax),%eax
  802137:	39 c2                	cmp    %eax,%edx
  802139:	73 6d                	jae    8021a8 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  80213b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80213f:	74 06                	je     802147 <insert_sorted_allocList+0x1f0>
  802141:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802145:	75 14                	jne    80215b <insert_sorted_allocList+0x204>
  802147:	83 ec 04             	sub    $0x4,%esp
  80214a:	68 24 40 80 00       	push   $0x804024
  80214f:	6a 7f                	push   $0x7f
  802151:	68 af 3f 80 00       	push   $0x803faf
  802156:	e8 62 e1 ff ff       	call   8002bd <_panic>
  80215b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80215e:	8b 10                	mov    (%eax),%edx
  802160:	8b 45 08             	mov    0x8(%ebp),%eax
  802163:	89 10                	mov    %edx,(%eax)
  802165:	8b 45 08             	mov    0x8(%ebp),%eax
  802168:	8b 00                	mov    (%eax),%eax
  80216a:	85 c0                	test   %eax,%eax
  80216c:	74 0b                	je     802179 <insert_sorted_allocList+0x222>
  80216e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802171:	8b 00                	mov    (%eax),%eax
  802173:	8b 55 08             	mov    0x8(%ebp),%edx
  802176:	89 50 04             	mov    %edx,0x4(%eax)
  802179:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217c:	8b 55 08             	mov    0x8(%ebp),%edx
  80217f:	89 10                	mov    %edx,(%eax)
  802181:	8b 45 08             	mov    0x8(%ebp),%eax
  802184:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802187:	89 50 04             	mov    %edx,0x4(%eax)
  80218a:	8b 45 08             	mov    0x8(%ebp),%eax
  80218d:	8b 00                	mov    (%eax),%eax
  80218f:	85 c0                	test   %eax,%eax
  802191:	75 08                	jne    80219b <insert_sorted_allocList+0x244>
  802193:	8b 45 08             	mov    0x8(%ebp),%eax
  802196:	a3 44 50 80 00       	mov    %eax,0x805044
  80219b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8021a0:	40                   	inc    %eax
  8021a1:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8021a6:	eb 39                	jmp    8021e1 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8021a8:	a1 48 50 80 00       	mov    0x805048,%eax
  8021ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021b4:	74 07                	je     8021bd <insert_sorted_allocList+0x266>
  8021b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b9:	8b 00                	mov    (%eax),%eax
  8021bb:	eb 05                	jmp    8021c2 <insert_sorted_allocList+0x26b>
  8021bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8021c2:	a3 48 50 80 00       	mov    %eax,0x805048
  8021c7:	a1 48 50 80 00       	mov    0x805048,%eax
  8021cc:	85 c0                	test   %eax,%eax
  8021ce:	0f 85 3f ff ff ff    	jne    802113 <insert_sorted_allocList+0x1bc>
  8021d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021d8:	0f 85 35 ff ff ff    	jne    802113 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8021de:	eb 01                	jmp    8021e1 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8021e0:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8021e1:	90                   	nop
  8021e2:	c9                   	leave  
  8021e3:	c3                   	ret    

008021e4 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8021e4:	55                   	push   %ebp
  8021e5:	89 e5                	mov    %esp,%ebp
  8021e7:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8021ea:	a1 38 51 80 00       	mov    0x805138,%eax
  8021ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021f2:	e9 85 01 00 00       	jmp    80237c <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8021f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021fa:	8b 40 0c             	mov    0xc(%eax),%eax
  8021fd:	3b 45 08             	cmp    0x8(%ebp),%eax
  802200:	0f 82 6e 01 00 00    	jb     802374 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802206:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802209:	8b 40 0c             	mov    0xc(%eax),%eax
  80220c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80220f:	0f 85 8a 00 00 00    	jne    80229f <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802215:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802219:	75 17                	jne    802232 <alloc_block_FF+0x4e>
  80221b:	83 ec 04             	sub    $0x4,%esp
  80221e:	68 58 40 80 00       	push   $0x804058
  802223:	68 93 00 00 00       	push   $0x93
  802228:	68 af 3f 80 00       	push   $0x803faf
  80222d:	e8 8b e0 ff ff       	call   8002bd <_panic>
  802232:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802235:	8b 00                	mov    (%eax),%eax
  802237:	85 c0                	test   %eax,%eax
  802239:	74 10                	je     80224b <alloc_block_FF+0x67>
  80223b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223e:	8b 00                	mov    (%eax),%eax
  802240:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802243:	8b 52 04             	mov    0x4(%edx),%edx
  802246:	89 50 04             	mov    %edx,0x4(%eax)
  802249:	eb 0b                	jmp    802256 <alloc_block_FF+0x72>
  80224b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224e:	8b 40 04             	mov    0x4(%eax),%eax
  802251:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802256:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802259:	8b 40 04             	mov    0x4(%eax),%eax
  80225c:	85 c0                	test   %eax,%eax
  80225e:	74 0f                	je     80226f <alloc_block_FF+0x8b>
  802260:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802263:	8b 40 04             	mov    0x4(%eax),%eax
  802266:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802269:	8b 12                	mov    (%edx),%edx
  80226b:	89 10                	mov    %edx,(%eax)
  80226d:	eb 0a                	jmp    802279 <alloc_block_FF+0x95>
  80226f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802272:	8b 00                	mov    (%eax),%eax
  802274:	a3 38 51 80 00       	mov    %eax,0x805138
  802279:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802282:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802285:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80228c:	a1 44 51 80 00       	mov    0x805144,%eax
  802291:	48                   	dec    %eax
  802292:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802297:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229a:	e9 10 01 00 00       	jmp    8023af <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  80229f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a2:	8b 40 0c             	mov    0xc(%eax),%eax
  8022a5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022a8:	0f 86 c6 00 00 00    	jbe    802374 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8022ae:	a1 48 51 80 00       	mov    0x805148,%eax
  8022b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8022b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b9:	8b 50 08             	mov    0x8(%eax),%edx
  8022bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022bf:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8022c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8022c8:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8022cb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022cf:	75 17                	jne    8022e8 <alloc_block_FF+0x104>
  8022d1:	83 ec 04             	sub    $0x4,%esp
  8022d4:	68 58 40 80 00       	push   $0x804058
  8022d9:	68 9b 00 00 00       	push   $0x9b
  8022de:	68 af 3f 80 00       	push   $0x803faf
  8022e3:	e8 d5 df ff ff       	call   8002bd <_panic>
  8022e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022eb:	8b 00                	mov    (%eax),%eax
  8022ed:	85 c0                	test   %eax,%eax
  8022ef:	74 10                	je     802301 <alloc_block_FF+0x11d>
  8022f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022f4:	8b 00                	mov    (%eax),%eax
  8022f6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022f9:	8b 52 04             	mov    0x4(%edx),%edx
  8022fc:	89 50 04             	mov    %edx,0x4(%eax)
  8022ff:	eb 0b                	jmp    80230c <alloc_block_FF+0x128>
  802301:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802304:	8b 40 04             	mov    0x4(%eax),%eax
  802307:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80230c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80230f:	8b 40 04             	mov    0x4(%eax),%eax
  802312:	85 c0                	test   %eax,%eax
  802314:	74 0f                	je     802325 <alloc_block_FF+0x141>
  802316:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802319:	8b 40 04             	mov    0x4(%eax),%eax
  80231c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80231f:	8b 12                	mov    (%edx),%edx
  802321:	89 10                	mov    %edx,(%eax)
  802323:	eb 0a                	jmp    80232f <alloc_block_FF+0x14b>
  802325:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802328:	8b 00                	mov    (%eax),%eax
  80232a:	a3 48 51 80 00       	mov    %eax,0x805148
  80232f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802332:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802338:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80233b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802342:	a1 54 51 80 00       	mov    0x805154,%eax
  802347:	48                   	dec    %eax
  802348:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  80234d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802350:	8b 50 08             	mov    0x8(%eax),%edx
  802353:	8b 45 08             	mov    0x8(%ebp),%eax
  802356:	01 c2                	add    %eax,%edx
  802358:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235b:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  80235e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802361:	8b 40 0c             	mov    0xc(%eax),%eax
  802364:	2b 45 08             	sub    0x8(%ebp),%eax
  802367:	89 c2                	mov    %eax,%edx
  802369:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236c:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  80236f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802372:	eb 3b                	jmp    8023af <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802374:	a1 40 51 80 00       	mov    0x805140,%eax
  802379:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80237c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802380:	74 07                	je     802389 <alloc_block_FF+0x1a5>
  802382:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802385:	8b 00                	mov    (%eax),%eax
  802387:	eb 05                	jmp    80238e <alloc_block_FF+0x1aa>
  802389:	b8 00 00 00 00       	mov    $0x0,%eax
  80238e:	a3 40 51 80 00       	mov    %eax,0x805140
  802393:	a1 40 51 80 00       	mov    0x805140,%eax
  802398:	85 c0                	test   %eax,%eax
  80239a:	0f 85 57 fe ff ff    	jne    8021f7 <alloc_block_FF+0x13>
  8023a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023a4:	0f 85 4d fe ff ff    	jne    8021f7 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8023aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023af:	c9                   	leave  
  8023b0:	c3                   	ret    

008023b1 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8023b1:	55                   	push   %ebp
  8023b2:	89 e5                	mov    %esp,%ebp
  8023b4:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8023b7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8023be:	a1 38 51 80 00       	mov    0x805138,%eax
  8023c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023c6:	e9 df 00 00 00       	jmp    8024aa <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8023cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ce:	8b 40 0c             	mov    0xc(%eax),%eax
  8023d1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023d4:	0f 82 c8 00 00 00    	jb     8024a2 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8023da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023dd:	8b 40 0c             	mov    0xc(%eax),%eax
  8023e0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023e3:	0f 85 8a 00 00 00    	jne    802473 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8023e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023ed:	75 17                	jne    802406 <alloc_block_BF+0x55>
  8023ef:	83 ec 04             	sub    $0x4,%esp
  8023f2:	68 58 40 80 00       	push   $0x804058
  8023f7:	68 b7 00 00 00       	push   $0xb7
  8023fc:	68 af 3f 80 00       	push   $0x803faf
  802401:	e8 b7 de ff ff       	call   8002bd <_panic>
  802406:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802409:	8b 00                	mov    (%eax),%eax
  80240b:	85 c0                	test   %eax,%eax
  80240d:	74 10                	je     80241f <alloc_block_BF+0x6e>
  80240f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802412:	8b 00                	mov    (%eax),%eax
  802414:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802417:	8b 52 04             	mov    0x4(%edx),%edx
  80241a:	89 50 04             	mov    %edx,0x4(%eax)
  80241d:	eb 0b                	jmp    80242a <alloc_block_BF+0x79>
  80241f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802422:	8b 40 04             	mov    0x4(%eax),%eax
  802425:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80242a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242d:	8b 40 04             	mov    0x4(%eax),%eax
  802430:	85 c0                	test   %eax,%eax
  802432:	74 0f                	je     802443 <alloc_block_BF+0x92>
  802434:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802437:	8b 40 04             	mov    0x4(%eax),%eax
  80243a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80243d:	8b 12                	mov    (%edx),%edx
  80243f:	89 10                	mov    %edx,(%eax)
  802441:	eb 0a                	jmp    80244d <alloc_block_BF+0x9c>
  802443:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802446:	8b 00                	mov    (%eax),%eax
  802448:	a3 38 51 80 00       	mov    %eax,0x805138
  80244d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802450:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802456:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802459:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802460:	a1 44 51 80 00       	mov    0x805144,%eax
  802465:	48                   	dec    %eax
  802466:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  80246b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246e:	e9 4d 01 00 00       	jmp    8025c0 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802473:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802476:	8b 40 0c             	mov    0xc(%eax),%eax
  802479:	3b 45 08             	cmp    0x8(%ebp),%eax
  80247c:	76 24                	jbe    8024a2 <alloc_block_BF+0xf1>
  80247e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802481:	8b 40 0c             	mov    0xc(%eax),%eax
  802484:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802487:	73 19                	jae    8024a2 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802489:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802490:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802493:	8b 40 0c             	mov    0xc(%eax),%eax
  802496:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802499:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249c:	8b 40 08             	mov    0x8(%eax),%eax
  80249f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8024a2:	a1 40 51 80 00       	mov    0x805140,%eax
  8024a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024ae:	74 07                	je     8024b7 <alloc_block_BF+0x106>
  8024b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b3:	8b 00                	mov    (%eax),%eax
  8024b5:	eb 05                	jmp    8024bc <alloc_block_BF+0x10b>
  8024b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8024bc:	a3 40 51 80 00       	mov    %eax,0x805140
  8024c1:	a1 40 51 80 00       	mov    0x805140,%eax
  8024c6:	85 c0                	test   %eax,%eax
  8024c8:	0f 85 fd fe ff ff    	jne    8023cb <alloc_block_BF+0x1a>
  8024ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024d2:	0f 85 f3 fe ff ff    	jne    8023cb <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8024d8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8024dc:	0f 84 d9 00 00 00    	je     8025bb <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8024e2:	a1 48 51 80 00       	mov    0x805148,%eax
  8024e7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8024ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024ed:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024f0:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8024f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8024f9:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8024fc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802500:	75 17                	jne    802519 <alloc_block_BF+0x168>
  802502:	83 ec 04             	sub    $0x4,%esp
  802505:	68 58 40 80 00       	push   $0x804058
  80250a:	68 c7 00 00 00       	push   $0xc7
  80250f:	68 af 3f 80 00       	push   $0x803faf
  802514:	e8 a4 dd ff ff       	call   8002bd <_panic>
  802519:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80251c:	8b 00                	mov    (%eax),%eax
  80251e:	85 c0                	test   %eax,%eax
  802520:	74 10                	je     802532 <alloc_block_BF+0x181>
  802522:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802525:	8b 00                	mov    (%eax),%eax
  802527:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80252a:	8b 52 04             	mov    0x4(%edx),%edx
  80252d:	89 50 04             	mov    %edx,0x4(%eax)
  802530:	eb 0b                	jmp    80253d <alloc_block_BF+0x18c>
  802532:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802535:	8b 40 04             	mov    0x4(%eax),%eax
  802538:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80253d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802540:	8b 40 04             	mov    0x4(%eax),%eax
  802543:	85 c0                	test   %eax,%eax
  802545:	74 0f                	je     802556 <alloc_block_BF+0x1a5>
  802547:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80254a:	8b 40 04             	mov    0x4(%eax),%eax
  80254d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802550:	8b 12                	mov    (%edx),%edx
  802552:	89 10                	mov    %edx,(%eax)
  802554:	eb 0a                	jmp    802560 <alloc_block_BF+0x1af>
  802556:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802559:	8b 00                	mov    (%eax),%eax
  80255b:	a3 48 51 80 00       	mov    %eax,0x805148
  802560:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802563:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802569:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80256c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802573:	a1 54 51 80 00       	mov    0x805154,%eax
  802578:	48                   	dec    %eax
  802579:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  80257e:	83 ec 08             	sub    $0x8,%esp
  802581:	ff 75 ec             	pushl  -0x14(%ebp)
  802584:	68 38 51 80 00       	push   $0x805138
  802589:	e8 71 f9 ff ff       	call   801eff <find_block>
  80258e:	83 c4 10             	add    $0x10,%esp
  802591:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802594:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802597:	8b 50 08             	mov    0x8(%eax),%edx
  80259a:	8b 45 08             	mov    0x8(%ebp),%eax
  80259d:	01 c2                	add    %eax,%edx
  80259f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025a2:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8025a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025a8:	8b 40 0c             	mov    0xc(%eax),%eax
  8025ab:	2b 45 08             	sub    0x8(%ebp),%eax
  8025ae:	89 c2                	mov    %eax,%edx
  8025b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025b3:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8025b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025b9:	eb 05                	jmp    8025c0 <alloc_block_BF+0x20f>
	}
	return NULL;
  8025bb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025c0:	c9                   	leave  
  8025c1:	c3                   	ret    

008025c2 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8025c2:	55                   	push   %ebp
  8025c3:	89 e5                	mov    %esp,%ebp
  8025c5:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8025c8:	a1 28 50 80 00       	mov    0x805028,%eax
  8025cd:	85 c0                	test   %eax,%eax
  8025cf:	0f 85 de 01 00 00    	jne    8027b3 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8025d5:	a1 38 51 80 00       	mov    0x805138,%eax
  8025da:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025dd:	e9 9e 01 00 00       	jmp    802780 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8025e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e5:	8b 40 0c             	mov    0xc(%eax),%eax
  8025e8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025eb:	0f 82 87 01 00 00    	jb     802778 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8025f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f4:	8b 40 0c             	mov    0xc(%eax),%eax
  8025f7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025fa:	0f 85 95 00 00 00    	jne    802695 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802600:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802604:	75 17                	jne    80261d <alloc_block_NF+0x5b>
  802606:	83 ec 04             	sub    $0x4,%esp
  802609:	68 58 40 80 00       	push   $0x804058
  80260e:	68 e0 00 00 00       	push   $0xe0
  802613:	68 af 3f 80 00       	push   $0x803faf
  802618:	e8 a0 dc ff ff       	call   8002bd <_panic>
  80261d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802620:	8b 00                	mov    (%eax),%eax
  802622:	85 c0                	test   %eax,%eax
  802624:	74 10                	je     802636 <alloc_block_NF+0x74>
  802626:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802629:	8b 00                	mov    (%eax),%eax
  80262b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80262e:	8b 52 04             	mov    0x4(%edx),%edx
  802631:	89 50 04             	mov    %edx,0x4(%eax)
  802634:	eb 0b                	jmp    802641 <alloc_block_NF+0x7f>
  802636:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802639:	8b 40 04             	mov    0x4(%eax),%eax
  80263c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802641:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802644:	8b 40 04             	mov    0x4(%eax),%eax
  802647:	85 c0                	test   %eax,%eax
  802649:	74 0f                	je     80265a <alloc_block_NF+0x98>
  80264b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264e:	8b 40 04             	mov    0x4(%eax),%eax
  802651:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802654:	8b 12                	mov    (%edx),%edx
  802656:	89 10                	mov    %edx,(%eax)
  802658:	eb 0a                	jmp    802664 <alloc_block_NF+0xa2>
  80265a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265d:	8b 00                	mov    (%eax),%eax
  80265f:	a3 38 51 80 00       	mov    %eax,0x805138
  802664:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802667:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80266d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802670:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802677:	a1 44 51 80 00       	mov    0x805144,%eax
  80267c:	48                   	dec    %eax
  80267d:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802682:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802685:	8b 40 08             	mov    0x8(%eax),%eax
  802688:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  80268d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802690:	e9 f8 04 00 00       	jmp    802b8d <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802695:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802698:	8b 40 0c             	mov    0xc(%eax),%eax
  80269b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80269e:	0f 86 d4 00 00 00    	jbe    802778 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8026a4:	a1 48 51 80 00       	mov    0x805148,%eax
  8026a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8026ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026af:	8b 50 08             	mov    0x8(%eax),%edx
  8026b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026b5:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8026b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8026be:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8026c1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026c5:	75 17                	jne    8026de <alloc_block_NF+0x11c>
  8026c7:	83 ec 04             	sub    $0x4,%esp
  8026ca:	68 58 40 80 00       	push   $0x804058
  8026cf:	68 e9 00 00 00       	push   $0xe9
  8026d4:	68 af 3f 80 00       	push   $0x803faf
  8026d9:	e8 df db ff ff       	call   8002bd <_panic>
  8026de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026e1:	8b 00                	mov    (%eax),%eax
  8026e3:	85 c0                	test   %eax,%eax
  8026e5:	74 10                	je     8026f7 <alloc_block_NF+0x135>
  8026e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026ea:	8b 00                	mov    (%eax),%eax
  8026ec:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026ef:	8b 52 04             	mov    0x4(%edx),%edx
  8026f2:	89 50 04             	mov    %edx,0x4(%eax)
  8026f5:	eb 0b                	jmp    802702 <alloc_block_NF+0x140>
  8026f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026fa:	8b 40 04             	mov    0x4(%eax),%eax
  8026fd:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802702:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802705:	8b 40 04             	mov    0x4(%eax),%eax
  802708:	85 c0                	test   %eax,%eax
  80270a:	74 0f                	je     80271b <alloc_block_NF+0x159>
  80270c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80270f:	8b 40 04             	mov    0x4(%eax),%eax
  802712:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802715:	8b 12                	mov    (%edx),%edx
  802717:	89 10                	mov    %edx,(%eax)
  802719:	eb 0a                	jmp    802725 <alloc_block_NF+0x163>
  80271b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80271e:	8b 00                	mov    (%eax),%eax
  802720:	a3 48 51 80 00       	mov    %eax,0x805148
  802725:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802728:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80272e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802731:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802738:	a1 54 51 80 00       	mov    0x805154,%eax
  80273d:	48                   	dec    %eax
  80273e:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802743:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802746:	8b 40 08             	mov    0x8(%eax),%eax
  802749:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  80274e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802751:	8b 50 08             	mov    0x8(%eax),%edx
  802754:	8b 45 08             	mov    0x8(%ebp),%eax
  802757:	01 c2                	add    %eax,%edx
  802759:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275c:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  80275f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802762:	8b 40 0c             	mov    0xc(%eax),%eax
  802765:	2b 45 08             	sub    0x8(%ebp),%eax
  802768:	89 c2                	mov    %eax,%edx
  80276a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276d:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802770:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802773:	e9 15 04 00 00       	jmp    802b8d <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802778:	a1 40 51 80 00       	mov    0x805140,%eax
  80277d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802780:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802784:	74 07                	je     80278d <alloc_block_NF+0x1cb>
  802786:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802789:	8b 00                	mov    (%eax),%eax
  80278b:	eb 05                	jmp    802792 <alloc_block_NF+0x1d0>
  80278d:	b8 00 00 00 00       	mov    $0x0,%eax
  802792:	a3 40 51 80 00       	mov    %eax,0x805140
  802797:	a1 40 51 80 00       	mov    0x805140,%eax
  80279c:	85 c0                	test   %eax,%eax
  80279e:	0f 85 3e fe ff ff    	jne    8025e2 <alloc_block_NF+0x20>
  8027a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027a8:	0f 85 34 fe ff ff    	jne    8025e2 <alloc_block_NF+0x20>
  8027ae:	e9 d5 03 00 00       	jmp    802b88 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8027b3:	a1 38 51 80 00       	mov    0x805138,%eax
  8027b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027bb:	e9 b1 01 00 00       	jmp    802971 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8027c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c3:	8b 50 08             	mov    0x8(%eax),%edx
  8027c6:	a1 28 50 80 00       	mov    0x805028,%eax
  8027cb:	39 c2                	cmp    %eax,%edx
  8027cd:	0f 82 96 01 00 00    	jb     802969 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  8027d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d6:	8b 40 0c             	mov    0xc(%eax),%eax
  8027d9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027dc:	0f 82 87 01 00 00    	jb     802969 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  8027e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e5:	8b 40 0c             	mov    0xc(%eax),%eax
  8027e8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027eb:	0f 85 95 00 00 00    	jne    802886 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8027f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027f5:	75 17                	jne    80280e <alloc_block_NF+0x24c>
  8027f7:	83 ec 04             	sub    $0x4,%esp
  8027fa:	68 58 40 80 00       	push   $0x804058
  8027ff:	68 fc 00 00 00       	push   $0xfc
  802804:	68 af 3f 80 00       	push   $0x803faf
  802809:	e8 af da ff ff       	call   8002bd <_panic>
  80280e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802811:	8b 00                	mov    (%eax),%eax
  802813:	85 c0                	test   %eax,%eax
  802815:	74 10                	je     802827 <alloc_block_NF+0x265>
  802817:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281a:	8b 00                	mov    (%eax),%eax
  80281c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80281f:	8b 52 04             	mov    0x4(%edx),%edx
  802822:	89 50 04             	mov    %edx,0x4(%eax)
  802825:	eb 0b                	jmp    802832 <alloc_block_NF+0x270>
  802827:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282a:	8b 40 04             	mov    0x4(%eax),%eax
  80282d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802832:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802835:	8b 40 04             	mov    0x4(%eax),%eax
  802838:	85 c0                	test   %eax,%eax
  80283a:	74 0f                	je     80284b <alloc_block_NF+0x289>
  80283c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283f:	8b 40 04             	mov    0x4(%eax),%eax
  802842:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802845:	8b 12                	mov    (%edx),%edx
  802847:	89 10                	mov    %edx,(%eax)
  802849:	eb 0a                	jmp    802855 <alloc_block_NF+0x293>
  80284b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284e:	8b 00                	mov    (%eax),%eax
  802850:	a3 38 51 80 00       	mov    %eax,0x805138
  802855:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802858:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80285e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802861:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802868:	a1 44 51 80 00       	mov    0x805144,%eax
  80286d:	48                   	dec    %eax
  80286e:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802873:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802876:	8b 40 08             	mov    0x8(%eax),%eax
  802879:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  80287e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802881:	e9 07 03 00 00       	jmp    802b8d <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802886:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802889:	8b 40 0c             	mov    0xc(%eax),%eax
  80288c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80288f:	0f 86 d4 00 00 00    	jbe    802969 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802895:	a1 48 51 80 00       	mov    0x805148,%eax
  80289a:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  80289d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a0:	8b 50 08             	mov    0x8(%eax),%edx
  8028a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028a6:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8028a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028ac:	8b 55 08             	mov    0x8(%ebp),%edx
  8028af:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8028b2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8028b6:	75 17                	jne    8028cf <alloc_block_NF+0x30d>
  8028b8:	83 ec 04             	sub    $0x4,%esp
  8028bb:	68 58 40 80 00       	push   $0x804058
  8028c0:	68 04 01 00 00       	push   $0x104
  8028c5:	68 af 3f 80 00       	push   $0x803faf
  8028ca:	e8 ee d9 ff ff       	call   8002bd <_panic>
  8028cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028d2:	8b 00                	mov    (%eax),%eax
  8028d4:	85 c0                	test   %eax,%eax
  8028d6:	74 10                	je     8028e8 <alloc_block_NF+0x326>
  8028d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028db:	8b 00                	mov    (%eax),%eax
  8028dd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8028e0:	8b 52 04             	mov    0x4(%edx),%edx
  8028e3:	89 50 04             	mov    %edx,0x4(%eax)
  8028e6:	eb 0b                	jmp    8028f3 <alloc_block_NF+0x331>
  8028e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028eb:	8b 40 04             	mov    0x4(%eax),%eax
  8028ee:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8028f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028f6:	8b 40 04             	mov    0x4(%eax),%eax
  8028f9:	85 c0                	test   %eax,%eax
  8028fb:	74 0f                	je     80290c <alloc_block_NF+0x34a>
  8028fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802900:	8b 40 04             	mov    0x4(%eax),%eax
  802903:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802906:	8b 12                	mov    (%edx),%edx
  802908:	89 10                	mov    %edx,(%eax)
  80290a:	eb 0a                	jmp    802916 <alloc_block_NF+0x354>
  80290c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80290f:	8b 00                	mov    (%eax),%eax
  802911:	a3 48 51 80 00       	mov    %eax,0x805148
  802916:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802919:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80291f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802922:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802929:	a1 54 51 80 00       	mov    0x805154,%eax
  80292e:	48                   	dec    %eax
  80292f:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802934:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802937:	8b 40 08             	mov    0x8(%eax),%eax
  80293a:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  80293f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802942:	8b 50 08             	mov    0x8(%eax),%edx
  802945:	8b 45 08             	mov    0x8(%ebp),%eax
  802948:	01 c2                	add    %eax,%edx
  80294a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294d:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802950:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802953:	8b 40 0c             	mov    0xc(%eax),%eax
  802956:	2b 45 08             	sub    0x8(%ebp),%eax
  802959:	89 c2                	mov    %eax,%edx
  80295b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295e:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802961:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802964:	e9 24 02 00 00       	jmp    802b8d <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802969:	a1 40 51 80 00       	mov    0x805140,%eax
  80296e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802971:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802975:	74 07                	je     80297e <alloc_block_NF+0x3bc>
  802977:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297a:	8b 00                	mov    (%eax),%eax
  80297c:	eb 05                	jmp    802983 <alloc_block_NF+0x3c1>
  80297e:	b8 00 00 00 00       	mov    $0x0,%eax
  802983:	a3 40 51 80 00       	mov    %eax,0x805140
  802988:	a1 40 51 80 00       	mov    0x805140,%eax
  80298d:	85 c0                	test   %eax,%eax
  80298f:	0f 85 2b fe ff ff    	jne    8027c0 <alloc_block_NF+0x1fe>
  802995:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802999:	0f 85 21 fe ff ff    	jne    8027c0 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  80299f:	a1 38 51 80 00       	mov    0x805138,%eax
  8029a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029a7:	e9 ae 01 00 00       	jmp    802b5a <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  8029ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029af:	8b 50 08             	mov    0x8(%eax),%edx
  8029b2:	a1 28 50 80 00       	mov    0x805028,%eax
  8029b7:	39 c2                	cmp    %eax,%edx
  8029b9:	0f 83 93 01 00 00    	jae    802b52 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  8029bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c2:	8b 40 0c             	mov    0xc(%eax),%eax
  8029c5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029c8:	0f 82 84 01 00 00    	jb     802b52 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  8029ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d1:	8b 40 0c             	mov    0xc(%eax),%eax
  8029d4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029d7:	0f 85 95 00 00 00    	jne    802a72 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8029dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029e1:	75 17                	jne    8029fa <alloc_block_NF+0x438>
  8029e3:	83 ec 04             	sub    $0x4,%esp
  8029e6:	68 58 40 80 00       	push   $0x804058
  8029eb:	68 14 01 00 00       	push   $0x114
  8029f0:	68 af 3f 80 00       	push   $0x803faf
  8029f5:	e8 c3 d8 ff ff       	call   8002bd <_panic>
  8029fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fd:	8b 00                	mov    (%eax),%eax
  8029ff:	85 c0                	test   %eax,%eax
  802a01:	74 10                	je     802a13 <alloc_block_NF+0x451>
  802a03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a06:	8b 00                	mov    (%eax),%eax
  802a08:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a0b:	8b 52 04             	mov    0x4(%edx),%edx
  802a0e:	89 50 04             	mov    %edx,0x4(%eax)
  802a11:	eb 0b                	jmp    802a1e <alloc_block_NF+0x45c>
  802a13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a16:	8b 40 04             	mov    0x4(%eax),%eax
  802a19:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a21:	8b 40 04             	mov    0x4(%eax),%eax
  802a24:	85 c0                	test   %eax,%eax
  802a26:	74 0f                	je     802a37 <alloc_block_NF+0x475>
  802a28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2b:	8b 40 04             	mov    0x4(%eax),%eax
  802a2e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a31:	8b 12                	mov    (%edx),%edx
  802a33:	89 10                	mov    %edx,(%eax)
  802a35:	eb 0a                	jmp    802a41 <alloc_block_NF+0x47f>
  802a37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3a:	8b 00                	mov    (%eax),%eax
  802a3c:	a3 38 51 80 00       	mov    %eax,0x805138
  802a41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a44:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a54:	a1 44 51 80 00       	mov    0x805144,%eax
  802a59:	48                   	dec    %eax
  802a5a:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802a5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a62:	8b 40 08             	mov    0x8(%eax),%eax
  802a65:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802a6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6d:	e9 1b 01 00 00       	jmp    802b8d <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802a72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a75:	8b 40 0c             	mov    0xc(%eax),%eax
  802a78:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a7b:	0f 86 d1 00 00 00    	jbe    802b52 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802a81:	a1 48 51 80 00       	mov    0x805148,%eax
  802a86:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802a89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8c:	8b 50 08             	mov    0x8(%eax),%edx
  802a8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a92:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802a95:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a98:	8b 55 08             	mov    0x8(%ebp),%edx
  802a9b:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802a9e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802aa2:	75 17                	jne    802abb <alloc_block_NF+0x4f9>
  802aa4:	83 ec 04             	sub    $0x4,%esp
  802aa7:	68 58 40 80 00       	push   $0x804058
  802aac:	68 1c 01 00 00       	push   $0x11c
  802ab1:	68 af 3f 80 00       	push   $0x803faf
  802ab6:	e8 02 d8 ff ff       	call   8002bd <_panic>
  802abb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802abe:	8b 00                	mov    (%eax),%eax
  802ac0:	85 c0                	test   %eax,%eax
  802ac2:	74 10                	je     802ad4 <alloc_block_NF+0x512>
  802ac4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ac7:	8b 00                	mov    (%eax),%eax
  802ac9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802acc:	8b 52 04             	mov    0x4(%edx),%edx
  802acf:	89 50 04             	mov    %edx,0x4(%eax)
  802ad2:	eb 0b                	jmp    802adf <alloc_block_NF+0x51d>
  802ad4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ad7:	8b 40 04             	mov    0x4(%eax),%eax
  802ada:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802adf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ae2:	8b 40 04             	mov    0x4(%eax),%eax
  802ae5:	85 c0                	test   %eax,%eax
  802ae7:	74 0f                	je     802af8 <alloc_block_NF+0x536>
  802ae9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aec:	8b 40 04             	mov    0x4(%eax),%eax
  802aef:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802af2:	8b 12                	mov    (%edx),%edx
  802af4:	89 10                	mov    %edx,(%eax)
  802af6:	eb 0a                	jmp    802b02 <alloc_block_NF+0x540>
  802af8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802afb:	8b 00                	mov    (%eax),%eax
  802afd:	a3 48 51 80 00       	mov    %eax,0x805148
  802b02:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b05:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b0e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b15:	a1 54 51 80 00       	mov    0x805154,%eax
  802b1a:	48                   	dec    %eax
  802b1b:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802b20:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b23:	8b 40 08             	mov    0x8(%eax),%eax
  802b26:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802b2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2e:	8b 50 08             	mov    0x8(%eax),%edx
  802b31:	8b 45 08             	mov    0x8(%ebp),%eax
  802b34:	01 c2                	add    %eax,%edx
  802b36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b39:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802b3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3f:	8b 40 0c             	mov    0xc(%eax),%eax
  802b42:	2b 45 08             	sub    0x8(%ebp),%eax
  802b45:	89 c2                	mov    %eax,%edx
  802b47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4a:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802b4d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b50:	eb 3b                	jmp    802b8d <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b52:	a1 40 51 80 00       	mov    0x805140,%eax
  802b57:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b5a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b5e:	74 07                	je     802b67 <alloc_block_NF+0x5a5>
  802b60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b63:	8b 00                	mov    (%eax),%eax
  802b65:	eb 05                	jmp    802b6c <alloc_block_NF+0x5aa>
  802b67:	b8 00 00 00 00       	mov    $0x0,%eax
  802b6c:	a3 40 51 80 00       	mov    %eax,0x805140
  802b71:	a1 40 51 80 00       	mov    0x805140,%eax
  802b76:	85 c0                	test   %eax,%eax
  802b78:	0f 85 2e fe ff ff    	jne    8029ac <alloc_block_NF+0x3ea>
  802b7e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b82:	0f 85 24 fe ff ff    	jne    8029ac <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802b88:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b8d:	c9                   	leave  
  802b8e:	c3                   	ret    

00802b8f <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802b8f:	55                   	push   %ebp
  802b90:	89 e5                	mov    %esp,%ebp
  802b92:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802b95:	a1 38 51 80 00       	mov    0x805138,%eax
  802b9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802b9d:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802ba2:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802ba5:	a1 38 51 80 00       	mov    0x805138,%eax
  802baa:	85 c0                	test   %eax,%eax
  802bac:	74 14                	je     802bc2 <insert_sorted_with_merge_freeList+0x33>
  802bae:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb1:	8b 50 08             	mov    0x8(%eax),%edx
  802bb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb7:	8b 40 08             	mov    0x8(%eax),%eax
  802bba:	39 c2                	cmp    %eax,%edx
  802bbc:	0f 87 9b 01 00 00    	ja     802d5d <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802bc2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bc6:	75 17                	jne    802bdf <insert_sorted_with_merge_freeList+0x50>
  802bc8:	83 ec 04             	sub    $0x4,%esp
  802bcb:	68 8c 3f 80 00       	push   $0x803f8c
  802bd0:	68 38 01 00 00       	push   $0x138
  802bd5:	68 af 3f 80 00       	push   $0x803faf
  802bda:	e8 de d6 ff ff       	call   8002bd <_panic>
  802bdf:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802be5:	8b 45 08             	mov    0x8(%ebp),%eax
  802be8:	89 10                	mov    %edx,(%eax)
  802bea:	8b 45 08             	mov    0x8(%ebp),%eax
  802bed:	8b 00                	mov    (%eax),%eax
  802bef:	85 c0                	test   %eax,%eax
  802bf1:	74 0d                	je     802c00 <insert_sorted_with_merge_freeList+0x71>
  802bf3:	a1 38 51 80 00       	mov    0x805138,%eax
  802bf8:	8b 55 08             	mov    0x8(%ebp),%edx
  802bfb:	89 50 04             	mov    %edx,0x4(%eax)
  802bfe:	eb 08                	jmp    802c08 <insert_sorted_with_merge_freeList+0x79>
  802c00:	8b 45 08             	mov    0x8(%ebp),%eax
  802c03:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c08:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0b:	a3 38 51 80 00       	mov    %eax,0x805138
  802c10:	8b 45 08             	mov    0x8(%ebp),%eax
  802c13:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c1a:	a1 44 51 80 00       	mov    0x805144,%eax
  802c1f:	40                   	inc    %eax
  802c20:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802c25:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c29:	0f 84 a8 06 00 00    	je     8032d7 <insert_sorted_with_merge_freeList+0x748>
  802c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c32:	8b 50 08             	mov    0x8(%eax),%edx
  802c35:	8b 45 08             	mov    0x8(%ebp),%eax
  802c38:	8b 40 0c             	mov    0xc(%eax),%eax
  802c3b:	01 c2                	add    %eax,%edx
  802c3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c40:	8b 40 08             	mov    0x8(%eax),%eax
  802c43:	39 c2                	cmp    %eax,%edx
  802c45:	0f 85 8c 06 00 00    	jne    8032d7 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4e:	8b 50 0c             	mov    0xc(%eax),%edx
  802c51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c54:	8b 40 0c             	mov    0xc(%eax),%eax
  802c57:	01 c2                	add    %eax,%edx
  802c59:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5c:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802c5f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c63:	75 17                	jne    802c7c <insert_sorted_with_merge_freeList+0xed>
  802c65:	83 ec 04             	sub    $0x4,%esp
  802c68:	68 58 40 80 00       	push   $0x804058
  802c6d:	68 3c 01 00 00       	push   $0x13c
  802c72:	68 af 3f 80 00       	push   $0x803faf
  802c77:	e8 41 d6 ff ff       	call   8002bd <_panic>
  802c7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c7f:	8b 00                	mov    (%eax),%eax
  802c81:	85 c0                	test   %eax,%eax
  802c83:	74 10                	je     802c95 <insert_sorted_with_merge_freeList+0x106>
  802c85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c88:	8b 00                	mov    (%eax),%eax
  802c8a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c8d:	8b 52 04             	mov    0x4(%edx),%edx
  802c90:	89 50 04             	mov    %edx,0x4(%eax)
  802c93:	eb 0b                	jmp    802ca0 <insert_sorted_with_merge_freeList+0x111>
  802c95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c98:	8b 40 04             	mov    0x4(%eax),%eax
  802c9b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ca0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ca3:	8b 40 04             	mov    0x4(%eax),%eax
  802ca6:	85 c0                	test   %eax,%eax
  802ca8:	74 0f                	je     802cb9 <insert_sorted_with_merge_freeList+0x12a>
  802caa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cad:	8b 40 04             	mov    0x4(%eax),%eax
  802cb0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cb3:	8b 12                	mov    (%edx),%edx
  802cb5:	89 10                	mov    %edx,(%eax)
  802cb7:	eb 0a                	jmp    802cc3 <insert_sorted_with_merge_freeList+0x134>
  802cb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cbc:	8b 00                	mov    (%eax),%eax
  802cbe:	a3 38 51 80 00       	mov    %eax,0x805138
  802cc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cc6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ccc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ccf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cd6:	a1 44 51 80 00       	mov    0x805144,%eax
  802cdb:	48                   	dec    %eax
  802cdc:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802ce1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ce4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802ceb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cee:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802cf5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cf9:	75 17                	jne    802d12 <insert_sorted_with_merge_freeList+0x183>
  802cfb:	83 ec 04             	sub    $0x4,%esp
  802cfe:	68 8c 3f 80 00       	push   $0x803f8c
  802d03:	68 3f 01 00 00       	push   $0x13f
  802d08:	68 af 3f 80 00       	push   $0x803faf
  802d0d:	e8 ab d5 ff ff       	call   8002bd <_panic>
  802d12:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802d18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d1b:	89 10                	mov    %edx,(%eax)
  802d1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d20:	8b 00                	mov    (%eax),%eax
  802d22:	85 c0                	test   %eax,%eax
  802d24:	74 0d                	je     802d33 <insert_sorted_with_merge_freeList+0x1a4>
  802d26:	a1 48 51 80 00       	mov    0x805148,%eax
  802d2b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d2e:	89 50 04             	mov    %edx,0x4(%eax)
  802d31:	eb 08                	jmp    802d3b <insert_sorted_with_merge_freeList+0x1ac>
  802d33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d36:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d3e:	a3 48 51 80 00       	mov    %eax,0x805148
  802d43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d46:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d4d:	a1 54 51 80 00       	mov    0x805154,%eax
  802d52:	40                   	inc    %eax
  802d53:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802d58:	e9 7a 05 00 00       	jmp    8032d7 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802d5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d60:	8b 50 08             	mov    0x8(%eax),%edx
  802d63:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d66:	8b 40 08             	mov    0x8(%eax),%eax
  802d69:	39 c2                	cmp    %eax,%edx
  802d6b:	0f 82 14 01 00 00    	jb     802e85 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802d71:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d74:	8b 50 08             	mov    0x8(%eax),%edx
  802d77:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d7a:	8b 40 0c             	mov    0xc(%eax),%eax
  802d7d:	01 c2                	add    %eax,%edx
  802d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d82:	8b 40 08             	mov    0x8(%eax),%eax
  802d85:	39 c2                	cmp    %eax,%edx
  802d87:	0f 85 90 00 00 00    	jne    802e1d <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802d8d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d90:	8b 50 0c             	mov    0xc(%eax),%edx
  802d93:	8b 45 08             	mov    0x8(%ebp),%eax
  802d96:	8b 40 0c             	mov    0xc(%eax),%eax
  802d99:	01 c2                	add    %eax,%edx
  802d9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d9e:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802da1:	8b 45 08             	mov    0x8(%ebp),%eax
  802da4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802dab:	8b 45 08             	mov    0x8(%ebp),%eax
  802dae:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802db5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802db9:	75 17                	jne    802dd2 <insert_sorted_with_merge_freeList+0x243>
  802dbb:	83 ec 04             	sub    $0x4,%esp
  802dbe:	68 8c 3f 80 00       	push   $0x803f8c
  802dc3:	68 49 01 00 00       	push   $0x149
  802dc8:	68 af 3f 80 00       	push   $0x803faf
  802dcd:	e8 eb d4 ff ff       	call   8002bd <_panic>
  802dd2:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802dd8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ddb:	89 10                	mov    %edx,(%eax)
  802ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  802de0:	8b 00                	mov    (%eax),%eax
  802de2:	85 c0                	test   %eax,%eax
  802de4:	74 0d                	je     802df3 <insert_sorted_with_merge_freeList+0x264>
  802de6:	a1 48 51 80 00       	mov    0x805148,%eax
  802deb:	8b 55 08             	mov    0x8(%ebp),%edx
  802dee:	89 50 04             	mov    %edx,0x4(%eax)
  802df1:	eb 08                	jmp    802dfb <insert_sorted_with_merge_freeList+0x26c>
  802df3:	8b 45 08             	mov    0x8(%ebp),%eax
  802df6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfe:	a3 48 51 80 00       	mov    %eax,0x805148
  802e03:	8b 45 08             	mov    0x8(%ebp),%eax
  802e06:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e0d:	a1 54 51 80 00       	mov    0x805154,%eax
  802e12:	40                   	inc    %eax
  802e13:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802e18:	e9 bb 04 00 00       	jmp    8032d8 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802e1d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e21:	75 17                	jne    802e3a <insert_sorted_with_merge_freeList+0x2ab>
  802e23:	83 ec 04             	sub    $0x4,%esp
  802e26:	68 00 40 80 00       	push   $0x804000
  802e2b:	68 4c 01 00 00       	push   $0x14c
  802e30:	68 af 3f 80 00       	push   $0x803faf
  802e35:	e8 83 d4 ff ff       	call   8002bd <_panic>
  802e3a:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802e40:	8b 45 08             	mov    0x8(%ebp),%eax
  802e43:	89 50 04             	mov    %edx,0x4(%eax)
  802e46:	8b 45 08             	mov    0x8(%ebp),%eax
  802e49:	8b 40 04             	mov    0x4(%eax),%eax
  802e4c:	85 c0                	test   %eax,%eax
  802e4e:	74 0c                	je     802e5c <insert_sorted_with_merge_freeList+0x2cd>
  802e50:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802e55:	8b 55 08             	mov    0x8(%ebp),%edx
  802e58:	89 10                	mov    %edx,(%eax)
  802e5a:	eb 08                	jmp    802e64 <insert_sorted_with_merge_freeList+0x2d5>
  802e5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5f:	a3 38 51 80 00       	mov    %eax,0x805138
  802e64:	8b 45 08             	mov    0x8(%ebp),%eax
  802e67:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e75:	a1 44 51 80 00       	mov    0x805144,%eax
  802e7a:	40                   	inc    %eax
  802e7b:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802e80:	e9 53 04 00 00       	jmp    8032d8 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802e85:	a1 38 51 80 00       	mov    0x805138,%eax
  802e8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e8d:	e9 15 04 00 00       	jmp    8032a7 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802e92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e95:	8b 00                	mov    (%eax),%eax
  802e97:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802e9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9d:	8b 50 08             	mov    0x8(%eax),%edx
  802ea0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea3:	8b 40 08             	mov    0x8(%eax),%eax
  802ea6:	39 c2                	cmp    %eax,%edx
  802ea8:	0f 86 f1 03 00 00    	jbe    80329f <insert_sorted_with_merge_freeList+0x710>
  802eae:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb1:	8b 50 08             	mov    0x8(%eax),%edx
  802eb4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eb7:	8b 40 08             	mov    0x8(%eax),%eax
  802eba:	39 c2                	cmp    %eax,%edx
  802ebc:	0f 83 dd 03 00 00    	jae    80329f <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802ec2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec5:	8b 50 08             	mov    0x8(%eax),%edx
  802ec8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ecb:	8b 40 0c             	mov    0xc(%eax),%eax
  802ece:	01 c2                	add    %eax,%edx
  802ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed3:	8b 40 08             	mov    0x8(%eax),%eax
  802ed6:	39 c2                	cmp    %eax,%edx
  802ed8:	0f 85 b9 01 00 00    	jne    803097 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802ede:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee1:	8b 50 08             	mov    0x8(%eax),%edx
  802ee4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee7:	8b 40 0c             	mov    0xc(%eax),%eax
  802eea:	01 c2                	add    %eax,%edx
  802eec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eef:	8b 40 08             	mov    0x8(%eax),%eax
  802ef2:	39 c2                	cmp    %eax,%edx
  802ef4:	0f 85 0d 01 00 00    	jne    803007 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802efa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802efd:	8b 50 0c             	mov    0xc(%eax),%edx
  802f00:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f03:	8b 40 0c             	mov    0xc(%eax),%eax
  802f06:	01 c2                	add    %eax,%edx
  802f08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0b:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802f0e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f12:	75 17                	jne    802f2b <insert_sorted_with_merge_freeList+0x39c>
  802f14:	83 ec 04             	sub    $0x4,%esp
  802f17:	68 58 40 80 00       	push   $0x804058
  802f1c:	68 5c 01 00 00       	push   $0x15c
  802f21:	68 af 3f 80 00       	push   $0x803faf
  802f26:	e8 92 d3 ff ff       	call   8002bd <_panic>
  802f2b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f2e:	8b 00                	mov    (%eax),%eax
  802f30:	85 c0                	test   %eax,%eax
  802f32:	74 10                	je     802f44 <insert_sorted_with_merge_freeList+0x3b5>
  802f34:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f37:	8b 00                	mov    (%eax),%eax
  802f39:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f3c:	8b 52 04             	mov    0x4(%edx),%edx
  802f3f:	89 50 04             	mov    %edx,0x4(%eax)
  802f42:	eb 0b                	jmp    802f4f <insert_sorted_with_merge_freeList+0x3c0>
  802f44:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f47:	8b 40 04             	mov    0x4(%eax),%eax
  802f4a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f4f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f52:	8b 40 04             	mov    0x4(%eax),%eax
  802f55:	85 c0                	test   %eax,%eax
  802f57:	74 0f                	je     802f68 <insert_sorted_with_merge_freeList+0x3d9>
  802f59:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f5c:	8b 40 04             	mov    0x4(%eax),%eax
  802f5f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f62:	8b 12                	mov    (%edx),%edx
  802f64:	89 10                	mov    %edx,(%eax)
  802f66:	eb 0a                	jmp    802f72 <insert_sorted_with_merge_freeList+0x3e3>
  802f68:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f6b:	8b 00                	mov    (%eax),%eax
  802f6d:	a3 38 51 80 00       	mov    %eax,0x805138
  802f72:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f75:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f7b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f7e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f85:	a1 44 51 80 00       	mov    0x805144,%eax
  802f8a:	48                   	dec    %eax
  802f8b:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  802f90:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f93:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  802f9a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f9d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  802fa4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802fa8:	75 17                	jne    802fc1 <insert_sorted_with_merge_freeList+0x432>
  802faa:	83 ec 04             	sub    $0x4,%esp
  802fad:	68 8c 3f 80 00       	push   $0x803f8c
  802fb2:	68 5f 01 00 00       	push   $0x15f
  802fb7:	68 af 3f 80 00       	push   $0x803faf
  802fbc:	e8 fc d2 ff ff       	call   8002bd <_panic>
  802fc1:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802fc7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fca:	89 10                	mov    %edx,(%eax)
  802fcc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fcf:	8b 00                	mov    (%eax),%eax
  802fd1:	85 c0                	test   %eax,%eax
  802fd3:	74 0d                	je     802fe2 <insert_sorted_with_merge_freeList+0x453>
  802fd5:	a1 48 51 80 00       	mov    0x805148,%eax
  802fda:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fdd:	89 50 04             	mov    %edx,0x4(%eax)
  802fe0:	eb 08                	jmp    802fea <insert_sorted_with_merge_freeList+0x45b>
  802fe2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fe5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fed:	a3 48 51 80 00       	mov    %eax,0x805148
  802ff2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ff5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ffc:	a1 54 51 80 00       	mov    0x805154,%eax
  803001:	40                   	inc    %eax
  803002:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803007:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300a:	8b 50 0c             	mov    0xc(%eax),%edx
  80300d:	8b 45 08             	mov    0x8(%ebp),%eax
  803010:	8b 40 0c             	mov    0xc(%eax),%eax
  803013:	01 c2                	add    %eax,%edx
  803015:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803018:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  80301b:	8b 45 08             	mov    0x8(%ebp),%eax
  80301e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803025:	8b 45 08             	mov    0x8(%ebp),%eax
  803028:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80302f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803033:	75 17                	jne    80304c <insert_sorted_with_merge_freeList+0x4bd>
  803035:	83 ec 04             	sub    $0x4,%esp
  803038:	68 8c 3f 80 00       	push   $0x803f8c
  80303d:	68 64 01 00 00       	push   $0x164
  803042:	68 af 3f 80 00       	push   $0x803faf
  803047:	e8 71 d2 ff ff       	call   8002bd <_panic>
  80304c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803052:	8b 45 08             	mov    0x8(%ebp),%eax
  803055:	89 10                	mov    %edx,(%eax)
  803057:	8b 45 08             	mov    0x8(%ebp),%eax
  80305a:	8b 00                	mov    (%eax),%eax
  80305c:	85 c0                	test   %eax,%eax
  80305e:	74 0d                	je     80306d <insert_sorted_with_merge_freeList+0x4de>
  803060:	a1 48 51 80 00       	mov    0x805148,%eax
  803065:	8b 55 08             	mov    0x8(%ebp),%edx
  803068:	89 50 04             	mov    %edx,0x4(%eax)
  80306b:	eb 08                	jmp    803075 <insert_sorted_with_merge_freeList+0x4e6>
  80306d:	8b 45 08             	mov    0x8(%ebp),%eax
  803070:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803075:	8b 45 08             	mov    0x8(%ebp),%eax
  803078:	a3 48 51 80 00       	mov    %eax,0x805148
  80307d:	8b 45 08             	mov    0x8(%ebp),%eax
  803080:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803087:	a1 54 51 80 00       	mov    0x805154,%eax
  80308c:	40                   	inc    %eax
  80308d:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803092:	e9 41 02 00 00       	jmp    8032d8 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803097:	8b 45 08             	mov    0x8(%ebp),%eax
  80309a:	8b 50 08             	mov    0x8(%eax),%edx
  80309d:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a0:	8b 40 0c             	mov    0xc(%eax),%eax
  8030a3:	01 c2                	add    %eax,%edx
  8030a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030a8:	8b 40 08             	mov    0x8(%eax),%eax
  8030ab:	39 c2                	cmp    %eax,%edx
  8030ad:	0f 85 7c 01 00 00    	jne    80322f <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8030b3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030b7:	74 06                	je     8030bf <insert_sorted_with_merge_freeList+0x530>
  8030b9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030bd:	75 17                	jne    8030d6 <insert_sorted_with_merge_freeList+0x547>
  8030bf:	83 ec 04             	sub    $0x4,%esp
  8030c2:	68 c8 3f 80 00       	push   $0x803fc8
  8030c7:	68 69 01 00 00       	push   $0x169
  8030cc:	68 af 3f 80 00       	push   $0x803faf
  8030d1:	e8 e7 d1 ff ff       	call   8002bd <_panic>
  8030d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030d9:	8b 50 04             	mov    0x4(%eax),%edx
  8030dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8030df:	89 50 04             	mov    %edx,0x4(%eax)
  8030e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030e8:	89 10                	mov    %edx,(%eax)
  8030ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ed:	8b 40 04             	mov    0x4(%eax),%eax
  8030f0:	85 c0                	test   %eax,%eax
  8030f2:	74 0d                	je     803101 <insert_sorted_with_merge_freeList+0x572>
  8030f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030f7:	8b 40 04             	mov    0x4(%eax),%eax
  8030fa:	8b 55 08             	mov    0x8(%ebp),%edx
  8030fd:	89 10                	mov    %edx,(%eax)
  8030ff:	eb 08                	jmp    803109 <insert_sorted_with_merge_freeList+0x57a>
  803101:	8b 45 08             	mov    0x8(%ebp),%eax
  803104:	a3 38 51 80 00       	mov    %eax,0x805138
  803109:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80310c:	8b 55 08             	mov    0x8(%ebp),%edx
  80310f:	89 50 04             	mov    %edx,0x4(%eax)
  803112:	a1 44 51 80 00       	mov    0x805144,%eax
  803117:	40                   	inc    %eax
  803118:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  80311d:	8b 45 08             	mov    0x8(%ebp),%eax
  803120:	8b 50 0c             	mov    0xc(%eax),%edx
  803123:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803126:	8b 40 0c             	mov    0xc(%eax),%eax
  803129:	01 c2                	add    %eax,%edx
  80312b:	8b 45 08             	mov    0x8(%ebp),%eax
  80312e:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803131:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803135:	75 17                	jne    80314e <insert_sorted_with_merge_freeList+0x5bf>
  803137:	83 ec 04             	sub    $0x4,%esp
  80313a:	68 58 40 80 00       	push   $0x804058
  80313f:	68 6b 01 00 00       	push   $0x16b
  803144:	68 af 3f 80 00       	push   $0x803faf
  803149:	e8 6f d1 ff ff       	call   8002bd <_panic>
  80314e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803151:	8b 00                	mov    (%eax),%eax
  803153:	85 c0                	test   %eax,%eax
  803155:	74 10                	je     803167 <insert_sorted_with_merge_freeList+0x5d8>
  803157:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80315a:	8b 00                	mov    (%eax),%eax
  80315c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80315f:	8b 52 04             	mov    0x4(%edx),%edx
  803162:	89 50 04             	mov    %edx,0x4(%eax)
  803165:	eb 0b                	jmp    803172 <insert_sorted_with_merge_freeList+0x5e3>
  803167:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80316a:	8b 40 04             	mov    0x4(%eax),%eax
  80316d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803172:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803175:	8b 40 04             	mov    0x4(%eax),%eax
  803178:	85 c0                	test   %eax,%eax
  80317a:	74 0f                	je     80318b <insert_sorted_with_merge_freeList+0x5fc>
  80317c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80317f:	8b 40 04             	mov    0x4(%eax),%eax
  803182:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803185:	8b 12                	mov    (%edx),%edx
  803187:	89 10                	mov    %edx,(%eax)
  803189:	eb 0a                	jmp    803195 <insert_sorted_with_merge_freeList+0x606>
  80318b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80318e:	8b 00                	mov    (%eax),%eax
  803190:	a3 38 51 80 00       	mov    %eax,0x805138
  803195:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803198:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80319e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031a1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031a8:	a1 44 51 80 00       	mov    0x805144,%eax
  8031ad:	48                   	dec    %eax
  8031ae:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8031b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031b6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8031bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8031c7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031cb:	75 17                	jne    8031e4 <insert_sorted_with_merge_freeList+0x655>
  8031cd:	83 ec 04             	sub    $0x4,%esp
  8031d0:	68 8c 3f 80 00       	push   $0x803f8c
  8031d5:	68 6e 01 00 00       	push   $0x16e
  8031da:	68 af 3f 80 00       	push   $0x803faf
  8031df:	e8 d9 d0 ff ff       	call   8002bd <_panic>
  8031e4:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ed:	89 10                	mov    %edx,(%eax)
  8031ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f2:	8b 00                	mov    (%eax),%eax
  8031f4:	85 c0                	test   %eax,%eax
  8031f6:	74 0d                	je     803205 <insert_sorted_with_merge_freeList+0x676>
  8031f8:	a1 48 51 80 00       	mov    0x805148,%eax
  8031fd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803200:	89 50 04             	mov    %edx,0x4(%eax)
  803203:	eb 08                	jmp    80320d <insert_sorted_with_merge_freeList+0x67e>
  803205:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803208:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80320d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803210:	a3 48 51 80 00       	mov    %eax,0x805148
  803215:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803218:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80321f:	a1 54 51 80 00       	mov    0x805154,%eax
  803224:	40                   	inc    %eax
  803225:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80322a:	e9 a9 00 00 00       	jmp    8032d8 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  80322f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803233:	74 06                	je     80323b <insert_sorted_with_merge_freeList+0x6ac>
  803235:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803239:	75 17                	jne    803252 <insert_sorted_with_merge_freeList+0x6c3>
  80323b:	83 ec 04             	sub    $0x4,%esp
  80323e:	68 24 40 80 00       	push   $0x804024
  803243:	68 73 01 00 00       	push   $0x173
  803248:	68 af 3f 80 00       	push   $0x803faf
  80324d:	e8 6b d0 ff ff       	call   8002bd <_panic>
  803252:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803255:	8b 10                	mov    (%eax),%edx
  803257:	8b 45 08             	mov    0x8(%ebp),%eax
  80325a:	89 10                	mov    %edx,(%eax)
  80325c:	8b 45 08             	mov    0x8(%ebp),%eax
  80325f:	8b 00                	mov    (%eax),%eax
  803261:	85 c0                	test   %eax,%eax
  803263:	74 0b                	je     803270 <insert_sorted_with_merge_freeList+0x6e1>
  803265:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803268:	8b 00                	mov    (%eax),%eax
  80326a:	8b 55 08             	mov    0x8(%ebp),%edx
  80326d:	89 50 04             	mov    %edx,0x4(%eax)
  803270:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803273:	8b 55 08             	mov    0x8(%ebp),%edx
  803276:	89 10                	mov    %edx,(%eax)
  803278:	8b 45 08             	mov    0x8(%ebp),%eax
  80327b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80327e:	89 50 04             	mov    %edx,0x4(%eax)
  803281:	8b 45 08             	mov    0x8(%ebp),%eax
  803284:	8b 00                	mov    (%eax),%eax
  803286:	85 c0                	test   %eax,%eax
  803288:	75 08                	jne    803292 <insert_sorted_with_merge_freeList+0x703>
  80328a:	8b 45 08             	mov    0x8(%ebp),%eax
  80328d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803292:	a1 44 51 80 00       	mov    0x805144,%eax
  803297:	40                   	inc    %eax
  803298:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  80329d:	eb 39                	jmp    8032d8 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80329f:	a1 40 51 80 00       	mov    0x805140,%eax
  8032a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032ab:	74 07                	je     8032b4 <insert_sorted_with_merge_freeList+0x725>
  8032ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b0:	8b 00                	mov    (%eax),%eax
  8032b2:	eb 05                	jmp    8032b9 <insert_sorted_with_merge_freeList+0x72a>
  8032b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8032b9:	a3 40 51 80 00       	mov    %eax,0x805140
  8032be:	a1 40 51 80 00       	mov    0x805140,%eax
  8032c3:	85 c0                	test   %eax,%eax
  8032c5:	0f 85 c7 fb ff ff    	jne    802e92 <insert_sorted_with_merge_freeList+0x303>
  8032cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032cf:	0f 85 bd fb ff ff    	jne    802e92 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8032d5:	eb 01                	jmp    8032d8 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8032d7:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8032d8:	90                   	nop
  8032d9:	c9                   	leave  
  8032da:	c3                   	ret    

008032db <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8032db:	55                   	push   %ebp
  8032dc:	89 e5                	mov    %esp,%ebp
  8032de:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8032e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8032e4:	89 d0                	mov    %edx,%eax
  8032e6:	c1 e0 02             	shl    $0x2,%eax
  8032e9:	01 d0                	add    %edx,%eax
  8032eb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8032f2:	01 d0                	add    %edx,%eax
  8032f4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8032fb:	01 d0                	add    %edx,%eax
  8032fd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803304:	01 d0                	add    %edx,%eax
  803306:	c1 e0 04             	shl    $0x4,%eax
  803309:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  80330c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803313:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803316:	83 ec 0c             	sub    $0xc,%esp
  803319:	50                   	push   %eax
  80331a:	e8 26 e7 ff ff       	call   801a45 <sys_get_virtual_time>
  80331f:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803322:	eb 41                	jmp    803365 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803324:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803327:	83 ec 0c             	sub    $0xc,%esp
  80332a:	50                   	push   %eax
  80332b:	e8 15 e7 ff ff       	call   801a45 <sys_get_virtual_time>
  803330:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803333:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803336:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803339:	29 c2                	sub    %eax,%edx
  80333b:	89 d0                	mov    %edx,%eax
  80333d:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803340:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803343:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803346:	89 d1                	mov    %edx,%ecx
  803348:	29 c1                	sub    %eax,%ecx
  80334a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80334d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803350:	39 c2                	cmp    %eax,%edx
  803352:	0f 97 c0             	seta   %al
  803355:	0f b6 c0             	movzbl %al,%eax
  803358:	29 c1                	sub    %eax,%ecx
  80335a:	89 c8                	mov    %ecx,%eax
  80335c:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  80335f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803362:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803365:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803368:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80336b:	72 b7                	jb     803324 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  80336d:	90                   	nop
  80336e:	c9                   	leave  
  80336f:	c3                   	ret    

00803370 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803370:	55                   	push   %ebp
  803371:	89 e5                	mov    %esp,%ebp
  803373:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803376:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  80337d:	eb 03                	jmp    803382 <busy_wait+0x12>
  80337f:	ff 45 fc             	incl   -0x4(%ebp)
  803382:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803385:	3b 45 08             	cmp    0x8(%ebp),%eax
  803388:	72 f5                	jb     80337f <busy_wait+0xf>
	return i;
  80338a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80338d:	c9                   	leave  
  80338e:	c3                   	ret    
  80338f:	90                   	nop

00803390 <__udivdi3>:
  803390:	55                   	push   %ebp
  803391:	57                   	push   %edi
  803392:	56                   	push   %esi
  803393:	53                   	push   %ebx
  803394:	83 ec 1c             	sub    $0x1c,%esp
  803397:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80339b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80339f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8033a3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8033a7:	89 ca                	mov    %ecx,%edx
  8033a9:	89 f8                	mov    %edi,%eax
  8033ab:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8033af:	85 f6                	test   %esi,%esi
  8033b1:	75 2d                	jne    8033e0 <__udivdi3+0x50>
  8033b3:	39 cf                	cmp    %ecx,%edi
  8033b5:	77 65                	ja     80341c <__udivdi3+0x8c>
  8033b7:	89 fd                	mov    %edi,%ebp
  8033b9:	85 ff                	test   %edi,%edi
  8033bb:	75 0b                	jne    8033c8 <__udivdi3+0x38>
  8033bd:	b8 01 00 00 00       	mov    $0x1,%eax
  8033c2:	31 d2                	xor    %edx,%edx
  8033c4:	f7 f7                	div    %edi
  8033c6:	89 c5                	mov    %eax,%ebp
  8033c8:	31 d2                	xor    %edx,%edx
  8033ca:	89 c8                	mov    %ecx,%eax
  8033cc:	f7 f5                	div    %ebp
  8033ce:	89 c1                	mov    %eax,%ecx
  8033d0:	89 d8                	mov    %ebx,%eax
  8033d2:	f7 f5                	div    %ebp
  8033d4:	89 cf                	mov    %ecx,%edi
  8033d6:	89 fa                	mov    %edi,%edx
  8033d8:	83 c4 1c             	add    $0x1c,%esp
  8033db:	5b                   	pop    %ebx
  8033dc:	5e                   	pop    %esi
  8033dd:	5f                   	pop    %edi
  8033de:	5d                   	pop    %ebp
  8033df:	c3                   	ret    
  8033e0:	39 ce                	cmp    %ecx,%esi
  8033e2:	77 28                	ja     80340c <__udivdi3+0x7c>
  8033e4:	0f bd fe             	bsr    %esi,%edi
  8033e7:	83 f7 1f             	xor    $0x1f,%edi
  8033ea:	75 40                	jne    80342c <__udivdi3+0x9c>
  8033ec:	39 ce                	cmp    %ecx,%esi
  8033ee:	72 0a                	jb     8033fa <__udivdi3+0x6a>
  8033f0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8033f4:	0f 87 9e 00 00 00    	ja     803498 <__udivdi3+0x108>
  8033fa:	b8 01 00 00 00       	mov    $0x1,%eax
  8033ff:	89 fa                	mov    %edi,%edx
  803401:	83 c4 1c             	add    $0x1c,%esp
  803404:	5b                   	pop    %ebx
  803405:	5e                   	pop    %esi
  803406:	5f                   	pop    %edi
  803407:	5d                   	pop    %ebp
  803408:	c3                   	ret    
  803409:	8d 76 00             	lea    0x0(%esi),%esi
  80340c:	31 ff                	xor    %edi,%edi
  80340e:	31 c0                	xor    %eax,%eax
  803410:	89 fa                	mov    %edi,%edx
  803412:	83 c4 1c             	add    $0x1c,%esp
  803415:	5b                   	pop    %ebx
  803416:	5e                   	pop    %esi
  803417:	5f                   	pop    %edi
  803418:	5d                   	pop    %ebp
  803419:	c3                   	ret    
  80341a:	66 90                	xchg   %ax,%ax
  80341c:	89 d8                	mov    %ebx,%eax
  80341e:	f7 f7                	div    %edi
  803420:	31 ff                	xor    %edi,%edi
  803422:	89 fa                	mov    %edi,%edx
  803424:	83 c4 1c             	add    $0x1c,%esp
  803427:	5b                   	pop    %ebx
  803428:	5e                   	pop    %esi
  803429:	5f                   	pop    %edi
  80342a:	5d                   	pop    %ebp
  80342b:	c3                   	ret    
  80342c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803431:	89 eb                	mov    %ebp,%ebx
  803433:	29 fb                	sub    %edi,%ebx
  803435:	89 f9                	mov    %edi,%ecx
  803437:	d3 e6                	shl    %cl,%esi
  803439:	89 c5                	mov    %eax,%ebp
  80343b:	88 d9                	mov    %bl,%cl
  80343d:	d3 ed                	shr    %cl,%ebp
  80343f:	89 e9                	mov    %ebp,%ecx
  803441:	09 f1                	or     %esi,%ecx
  803443:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803447:	89 f9                	mov    %edi,%ecx
  803449:	d3 e0                	shl    %cl,%eax
  80344b:	89 c5                	mov    %eax,%ebp
  80344d:	89 d6                	mov    %edx,%esi
  80344f:	88 d9                	mov    %bl,%cl
  803451:	d3 ee                	shr    %cl,%esi
  803453:	89 f9                	mov    %edi,%ecx
  803455:	d3 e2                	shl    %cl,%edx
  803457:	8b 44 24 08          	mov    0x8(%esp),%eax
  80345b:	88 d9                	mov    %bl,%cl
  80345d:	d3 e8                	shr    %cl,%eax
  80345f:	09 c2                	or     %eax,%edx
  803461:	89 d0                	mov    %edx,%eax
  803463:	89 f2                	mov    %esi,%edx
  803465:	f7 74 24 0c          	divl   0xc(%esp)
  803469:	89 d6                	mov    %edx,%esi
  80346b:	89 c3                	mov    %eax,%ebx
  80346d:	f7 e5                	mul    %ebp
  80346f:	39 d6                	cmp    %edx,%esi
  803471:	72 19                	jb     80348c <__udivdi3+0xfc>
  803473:	74 0b                	je     803480 <__udivdi3+0xf0>
  803475:	89 d8                	mov    %ebx,%eax
  803477:	31 ff                	xor    %edi,%edi
  803479:	e9 58 ff ff ff       	jmp    8033d6 <__udivdi3+0x46>
  80347e:	66 90                	xchg   %ax,%ax
  803480:	8b 54 24 08          	mov    0x8(%esp),%edx
  803484:	89 f9                	mov    %edi,%ecx
  803486:	d3 e2                	shl    %cl,%edx
  803488:	39 c2                	cmp    %eax,%edx
  80348a:	73 e9                	jae    803475 <__udivdi3+0xe5>
  80348c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80348f:	31 ff                	xor    %edi,%edi
  803491:	e9 40 ff ff ff       	jmp    8033d6 <__udivdi3+0x46>
  803496:	66 90                	xchg   %ax,%ax
  803498:	31 c0                	xor    %eax,%eax
  80349a:	e9 37 ff ff ff       	jmp    8033d6 <__udivdi3+0x46>
  80349f:	90                   	nop

008034a0 <__umoddi3>:
  8034a0:	55                   	push   %ebp
  8034a1:	57                   	push   %edi
  8034a2:	56                   	push   %esi
  8034a3:	53                   	push   %ebx
  8034a4:	83 ec 1c             	sub    $0x1c,%esp
  8034a7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8034ab:	8b 74 24 34          	mov    0x34(%esp),%esi
  8034af:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8034b3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8034b7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8034bb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8034bf:	89 f3                	mov    %esi,%ebx
  8034c1:	89 fa                	mov    %edi,%edx
  8034c3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8034c7:	89 34 24             	mov    %esi,(%esp)
  8034ca:	85 c0                	test   %eax,%eax
  8034cc:	75 1a                	jne    8034e8 <__umoddi3+0x48>
  8034ce:	39 f7                	cmp    %esi,%edi
  8034d0:	0f 86 a2 00 00 00    	jbe    803578 <__umoddi3+0xd8>
  8034d6:	89 c8                	mov    %ecx,%eax
  8034d8:	89 f2                	mov    %esi,%edx
  8034da:	f7 f7                	div    %edi
  8034dc:	89 d0                	mov    %edx,%eax
  8034de:	31 d2                	xor    %edx,%edx
  8034e0:	83 c4 1c             	add    $0x1c,%esp
  8034e3:	5b                   	pop    %ebx
  8034e4:	5e                   	pop    %esi
  8034e5:	5f                   	pop    %edi
  8034e6:	5d                   	pop    %ebp
  8034e7:	c3                   	ret    
  8034e8:	39 f0                	cmp    %esi,%eax
  8034ea:	0f 87 ac 00 00 00    	ja     80359c <__umoddi3+0xfc>
  8034f0:	0f bd e8             	bsr    %eax,%ebp
  8034f3:	83 f5 1f             	xor    $0x1f,%ebp
  8034f6:	0f 84 ac 00 00 00    	je     8035a8 <__umoddi3+0x108>
  8034fc:	bf 20 00 00 00       	mov    $0x20,%edi
  803501:	29 ef                	sub    %ebp,%edi
  803503:	89 fe                	mov    %edi,%esi
  803505:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803509:	89 e9                	mov    %ebp,%ecx
  80350b:	d3 e0                	shl    %cl,%eax
  80350d:	89 d7                	mov    %edx,%edi
  80350f:	89 f1                	mov    %esi,%ecx
  803511:	d3 ef                	shr    %cl,%edi
  803513:	09 c7                	or     %eax,%edi
  803515:	89 e9                	mov    %ebp,%ecx
  803517:	d3 e2                	shl    %cl,%edx
  803519:	89 14 24             	mov    %edx,(%esp)
  80351c:	89 d8                	mov    %ebx,%eax
  80351e:	d3 e0                	shl    %cl,%eax
  803520:	89 c2                	mov    %eax,%edx
  803522:	8b 44 24 08          	mov    0x8(%esp),%eax
  803526:	d3 e0                	shl    %cl,%eax
  803528:	89 44 24 04          	mov    %eax,0x4(%esp)
  80352c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803530:	89 f1                	mov    %esi,%ecx
  803532:	d3 e8                	shr    %cl,%eax
  803534:	09 d0                	or     %edx,%eax
  803536:	d3 eb                	shr    %cl,%ebx
  803538:	89 da                	mov    %ebx,%edx
  80353a:	f7 f7                	div    %edi
  80353c:	89 d3                	mov    %edx,%ebx
  80353e:	f7 24 24             	mull   (%esp)
  803541:	89 c6                	mov    %eax,%esi
  803543:	89 d1                	mov    %edx,%ecx
  803545:	39 d3                	cmp    %edx,%ebx
  803547:	0f 82 87 00 00 00    	jb     8035d4 <__umoddi3+0x134>
  80354d:	0f 84 91 00 00 00    	je     8035e4 <__umoddi3+0x144>
  803553:	8b 54 24 04          	mov    0x4(%esp),%edx
  803557:	29 f2                	sub    %esi,%edx
  803559:	19 cb                	sbb    %ecx,%ebx
  80355b:	89 d8                	mov    %ebx,%eax
  80355d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803561:	d3 e0                	shl    %cl,%eax
  803563:	89 e9                	mov    %ebp,%ecx
  803565:	d3 ea                	shr    %cl,%edx
  803567:	09 d0                	or     %edx,%eax
  803569:	89 e9                	mov    %ebp,%ecx
  80356b:	d3 eb                	shr    %cl,%ebx
  80356d:	89 da                	mov    %ebx,%edx
  80356f:	83 c4 1c             	add    $0x1c,%esp
  803572:	5b                   	pop    %ebx
  803573:	5e                   	pop    %esi
  803574:	5f                   	pop    %edi
  803575:	5d                   	pop    %ebp
  803576:	c3                   	ret    
  803577:	90                   	nop
  803578:	89 fd                	mov    %edi,%ebp
  80357a:	85 ff                	test   %edi,%edi
  80357c:	75 0b                	jne    803589 <__umoddi3+0xe9>
  80357e:	b8 01 00 00 00       	mov    $0x1,%eax
  803583:	31 d2                	xor    %edx,%edx
  803585:	f7 f7                	div    %edi
  803587:	89 c5                	mov    %eax,%ebp
  803589:	89 f0                	mov    %esi,%eax
  80358b:	31 d2                	xor    %edx,%edx
  80358d:	f7 f5                	div    %ebp
  80358f:	89 c8                	mov    %ecx,%eax
  803591:	f7 f5                	div    %ebp
  803593:	89 d0                	mov    %edx,%eax
  803595:	e9 44 ff ff ff       	jmp    8034de <__umoddi3+0x3e>
  80359a:	66 90                	xchg   %ax,%ax
  80359c:	89 c8                	mov    %ecx,%eax
  80359e:	89 f2                	mov    %esi,%edx
  8035a0:	83 c4 1c             	add    $0x1c,%esp
  8035a3:	5b                   	pop    %ebx
  8035a4:	5e                   	pop    %esi
  8035a5:	5f                   	pop    %edi
  8035a6:	5d                   	pop    %ebp
  8035a7:	c3                   	ret    
  8035a8:	3b 04 24             	cmp    (%esp),%eax
  8035ab:	72 06                	jb     8035b3 <__umoddi3+0x113>
  8035ad:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8035b1:	77 0f                	ja     8035c2 <__umoddi3+0x122>
  8035b3:	89 f2                	mov    %esi,%edx
  8035b5:	29 f9                	sub    %edi,%ecx
  8035b7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8035bb:	89 14 24             	mov    %edx,(%esp)
  8035be:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8035c2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8035c6:	8b 14 24             	mov    (%esp),%edx
  8035c9:	83 c4 1c             	add    $0x1c,%esp
  8035cc:	5b                   	pop    %ebx
  8035cd:	5e                   	pop    %esi
  8035ce:	5f                   	pop    %edi
  8035cf:	5d                   	pop    %ebp
  8035d0:	c3                   	ret    
  8035d1:	8d 76 00             	lea    0x0(%esi),%esi
  8035d4:	2b 04 24             	sub    (%esp),%eax
  8035d7:	19 fa                	sbb    %edi,%edx
  8035d9:	89 d1                	mov    %edx,%ecx
  8035db:	89 c6                	mov    %eax,%esi
  8035dd:	e9 71 ff ff ff       	jmp    803553 <__umoddi3+0xb3>
  8035e2:	66 90                	xchg   %ax,%ax
  8035e4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8035e8:	72 ea                	jb     8035d4 <__umoddi3+0x134>
  8035ea:	89 d9                	mov    %ebx,%ecx
  8035ec:	e9 62 ff ff ff       	jmp    803553 <__umoddi3+0xb3>
