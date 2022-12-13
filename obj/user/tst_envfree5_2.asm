
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
  800045:	68 c0 36 80 00       	push   $0x8036c0
  80004a:	e8 3f 15 00 00       	call   80158e <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*numOfFinished = 0 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int freeFrames_before = sys_calculate_free_frames() ;
  80005e:	e8 6b 17 00 00       	call   8017ce <sys_calculate_free_frames>
  800063:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800066:	e8 03 18 00 00       	call   80186e <sys_pf_calculate_allocated_pages>
  80006b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80006e:	83 ec 08             	sub    $0x8,%esp
  800071:	ff 75 f0             	pushl  -0x10(%ebp)
  800074:	68 d0 36 80 00       	push   $0x8036d0
  800079:	e8 f3 04 00 00       	call   800571 <cprintf>
  80007e:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tshr4", 2000,100, 50);
  800081:	6a 32                	push   $0x32
  800083:	6a 64                	push   $0x64
  800085:	68 d0 07 00 00       	push   $0x7d0
  80008a:	68 03 37 80 00       	push   $0x803703
  80008f:	e8 ac 19 00 00       	call   801a40 <sys_create_env>
  800094:	83 c4 10             	add    $0x10,%esp
  800097:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int32 envIdProcessB = sys_create_env("ef_tshr5", 2000,100, 50);
  80009a:	6a 32                	push   $0x32
  80009c:	6a 64                	push   $0x64
  80009e:	68 d0 07 00 00       	push   $0x7d0
  8000a3:	68 0c 37 80 00       	push   $0x80370c
  8000a8:	e8 93 19 00 00       	call   801a40 <sys_create_env>
  8000ad:	83 c4 10             	add    $0x10,%esp
  8000b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	sys_run_env(envIdProcessA);
  8000b3:	83 ec 0c             	sub    $0xc,%esp
  8000b6:	ff 75 e8             	pushl  -0x18(%ebp)
  8000b9:	e8 a0 19 00 00       	call   801a5e <sys_run_env>
  8000be:	83 c4 10             	add    $0x10,%esp
	env_sleep(15000);
  8000c1:	83 ec 0c             	sub    $0xc,%esp
  8000c4:	68 98 3a 00 00       	push   $0x3a98
  8000c9:	e8 c2 32 00 00       	call   803390 <env_sleep>
  8000ce:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  8000d1:	83 ec 0c             	sub    $0xc,%esp
  8000d4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000d7:	e8 82 19 00 00       	call   801a5e <sys_run_env>
  8000dc:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 2) ;
  8000df:	90                   	nop
  8000e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000e3:	8b 00                	mov    (%eax),%eax
  8000e5:	83 f8 02             	cmp    $0x2,%eax
  8000e8:	75 f6                	jne    8000e0 <_main+0xa8>
	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  8000ea:	e8 df 16 00 00       	call   8017ce <sys_calculate_free_frames>
  8000ef:	83 ec 08             	sub    $0x8,%esp
  8000f2:	50                   	push   %eax
  8000f3:	68 18 37 80 00       	push   $0x803718
  8000f8:	e8 74 04 00 00       	call   800571 <cprintf>
  8000fd:	83 c4 10             	add    $0x10,%esp

	sys_destroy_env(envIdProcessA);
  800100:	83 ec 0c             	sub    $0xc,%esp
  800103:	ff 75 e8             	pushl  -0x18(%ebp)
  800106:	e8 6f 19 00 00       	call   801a7a <sys_destroy_env>
  80010b:	83 c4 10             	add    $0x10,%esp
	sys_destroy_env(envIdProcessB);
  80010e:	83 ec 0c             	sub    $0xc,%esp
  800111:	ff 75 e4             	pushl  -0x1c(%ebp)
  800114:	e8 61 19 00 00       	call   801a7a <sys_destroy_env>
  800119:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  80011c:	e8 ad 16 00 00       	call   8017ce <sys_calculate_free_frames>
  800121:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  800124:	e8 45 17 00 00       	call   80186e <sys_pf_calculate_allocated_pages>
  800129:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if ((freeFrames_after - freeFrames_before) != 0) {
  80012c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80012f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800132:	74 27                	je     80015b <_main+0x123>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\n",
  800134:	83 ec 08             	sub    $0x8,%esp
  800137:	ff 75 e0             	pushl  -0x20(%ebp)
  80013a:	68 4c 37 80 00       	push   $0x80374c
  80013f:	e8 2d 04 00 00       	call   800571 <cprintf>
  800144:	83 c4 10             	add    $0x10,%esp
				freeFrames_after);
		panic("env_free() does not work correctly... check it again.");
  800147:	83 ec 04             	sub    $0x4,%esp
  80014a:	68 9c 37 80 00       	push   $0x80379c
  80014f:	6a 23                	push   $0x23
  800151:	68 d2 37 80 00       	push   $0x8037d2
  800156:	e8 62 01 00 00       	call   8002bd <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  80015b:	83 ec 08             	sub    $0x8,%esp
  80015e:	ff 75 e0             	pushl  -0x20(%ebp)
  800161:	68 e8 37 80 00       	push   $0x8037e8
  800166:	e8 06 04 00 00       	call   800571 <cprintf>
  80016b:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 5_2 for envfree completed successfully.\n");
  80016e:	83 ec 0c             	sub    $0xc,%esp
  800171:	68 48 38 80 00       	push   $0x803848
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
  800187:	e8 22 19 00 00       	call   801aae <sys_getenvindex>
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
  8001f2:	e8 c4 16 00 00       	call   8018bb <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001f7:	83 ec 0c             	sub    $0xc,%esp
  8001fa:	68 ac 38 80 00       	push   $0x8038ac
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
  800222:	68 d4 38 80 00       	push   $0x8038d4
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
  800253:	68 fc 38 80 00       	push   $0x8038fc
  800258:	e8 14 03 00 00       	call   800571 <cprintf>
  80025d:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800260:	a1 20 50 80 00       	mov    0x805020,%eax
  800265:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80026b:	83 ec 08             	sub    $0x8,%esp
  80026e:	50                   	push   %eax
  80026f:	68 54 39 80 00       	push   $0x803954
  800274:	e8 f8 02 00 00       	call   800571 <cprintf>
  800279:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80027c:	83 ec 0c             	sub    $0xc,%esp
  80027f:	68 ac 38 80 00       	push   $0x8038ac
  800284:	e8 e8 02 00 00       	call   800571 <cprintf>
  800289:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80028c:	e8 44 16 00 00       	call   8018d5 <sys_enable_interrupt>

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
  8002a4:	e8 d1 17 00 00       	call   801a7a <sys_destroy_env>
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
  8002b5:	e8 26 18 00 00       	call   801ae0 <sys_exit_env>
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
  8002de:	68 68 39 80 00       	push   $0x803968
  8002e3:	e8 89 02 00 00       	call   800571 <cprintf>
  8002e8:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002eb:	a1 00 50 80 00       	mov    0x805000,%eax
  8002f0:	ff 75 0c             	pushl  0xc(%ebp)
  8002f3:	ff 75 08             	pushl  0x8(%ebp)
  8002f6:	50                   	push   %eax
  8002f7:	68 6d 39 80 00       	push   $0x80396d
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
  80031b:	68 89 39 80 00       	push   $0x803989
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
  800347:	68 8c 39 80 00       	push   $0x80398c
  80034c:	6a 26                	push   $0x26
  80034e:	68 d8 39 80 00       	push   $0x8039d8
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
  800419:	68 e4 39 80 00       	push   $0x8039e4
  80041e:	6a 3a                	push   $0x3a
  800420:	68 d8 39 80 00       	push   $0x8039d8
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
  800489:	68 38 3a 80 00       	push   $0x803a38
  80048e:	6a 44                	push   $0x44
  800490:	68 d8 39 80 00       	push   $0x8039d8
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
  8004e3:	e8 25 12 00 00       	call   80170d <sys_cputs>
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
  80055a:	e8 ae 11 00 00       	call   80170d <sys_cputs>
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
  8005a4:	e8 12 13 00 00       	call   8018bb <sys_disable_interrupt>
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
  8005c4:	e8 0c 13 00 00       	call   8018d5 <sys_enable_interrupt>
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
  80060e:	e8 31 2e 00 00       	call   803444 <__udivdi3>
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
  80065e:	e8 f1 2e 00 00       	call   803554 <__umoddi3>
  800663:	83 c4 10             	add    $0x10,%esp
  800666:	05 b4 3c 80 00       	add    $0x803cb4,%eax
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
  8007b9:	8b 04 85 d8 3c 80 00 	mov    0x803cd8(,%eax,4),%eax
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
  80089a:	8b 34 9d 20 3b 80 00 	mov    0x803b20(,%ebx,4),%esi
  8008a1:	85 f6                	test   %esi,%esi
  8008a3:	75 19                	jne    8008be <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008a5:	53                   	push   %ebx
  8008a6:	68 c5 3c 80 00       	push   $0x803cc5
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
  8008bf:	68 ce 3c 80 00       	push   $0x803cce
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
  8008ec:	be d1 3c 80 00       	mov    $0x803cd1,%esi
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
  801312:	68 30 3e 80 00       	push   $0x803e30
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
  8013e2:	e8 6a 04 00 00       	call   801851 <sys_allocate_chunk>
  8013e7:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013ea:	a1 20 51 80 00       	mov    0x805120,%eax
  8013ef:	83 ec 0c             	sub    $0xc,%esp
  8013f2:	50                   	push   %eax
  8013f3:	e8 df 0a 00 00       	call   801ed7 <initialize_MemBlocksList>
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
  801420:	68 55 3e 80 00       	push   $0x803e55
  801425:	6a 33                	push   $0x33
  801427:	68 73 3e 80 00       	push   $0x803e73
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
  80149f:	68 80 3e 80 00       	push   $0x803e80
  8014a4:	6a 34                	push   $0x34
  8014a6:	68 73 3e 80 00       	push   $0x803e73
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
  8014fc:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8014ff:	e8 f7 fd ff ff       	call   8012fb <InitializeUHeap>
	if (size == 0) return NULL ;
  801504:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801508:	75 07                	jne    801511 <malloc+0x18>
  80150a:	b8 00 00 00 00       	mov    $0x0,%eax
  80150f:	eb 61                	jmp    801572 <malloc+0x79>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
	uint32 malloc_allocsize=ROUNDUP(size,PAGE_SIZE);
  801511:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801518:	8b 55 08             	mov    0x8(%ebp),%edx
  80151b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80151e:	01 d0                	add    %edx,%eax
  801520:	48                   	dec    %eax
  801521:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801524:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801527:	ba 00 00 00 00       	mov    $0x0,%edx
  80152c:	f7 75 f0             	divl   -0x10(%ebp)
  80152f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801532:	29 d0                	sub    %edx,%eax
  801534:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 //int ret=0;
	struct MemBlock * user_block;
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801537:	e8 e3 06 00 00       	call   801c1f <sys_isUHeapPlacementStrategyFIRSTFIT>
  80153c:	85 c0                	test   %eax,%eax
  80153e:	74 11                	je     801551 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801540:	83 ec 0c             	sub    $0xc,%esp
  801543:	ff 75 e8             	pushl  -0x18(%ebp)
  801546:	e8 4e 0d 00 00       	call   802299 <alloc_block_FF>
  80154b:	83 c4 10             	add    $0x10,%esp
  80154e:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(user_block!=NULL)
  801551:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801555:	74 16                	je     80156d <malloc+0x74>
	{
		//sys_allocate_chunk(user_block->sva,malloc_allocsize,PERM_WRITEABLE| PERM_PRESENT);
		insert_sorted_allocList(user_block);
  801557:	83 ec 0c             	sub    $0xc,%esp
  80155a:	ff 75 f4             	pushl  -0xc(%ebp)
  80155d:	e8 aa 0a 00 00       	call   80200c <insert_sorted_allocList>
  801562:	83 c4 10             	add    $0x10,%esp
		return (uint32 *)user_block->sva;
  801565:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801568:	8b 40 08             	mov    0x8(%eax),%eax
  80156b:	eb 05                	jmp    801572 <malloc+0x79>
	}

    return NULL;
  80156d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801572:	c9                   	leave  
  801573:	c3                   	ret    

00801574 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801574:	55                   	push   %ebp
  801575:	89 e5                	mov    %esp,%ebp
  801577:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  80157a:	83 ec 04             	sub    $0x4,%esp
  80157d:	68 a4 3e 80 00       	push   $0x803ea4
  801582:	6a 6f                	push   $0x6f
  801584:	68 73 3e 80 00       	push   $0x803e73
  801589:	e8 2f ed ff ff       	call   8002bd <_panic>

0080158e <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80158e:	55                   	push   %ebp
  80158f:	89 e5                	mov    %esp,%ebp
  801591:	83 ec 38             	sub    $0x38,%esp
  801594:	8b 45 10             	mov    0x10(%ebp),%eax
  801597:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80159a:	e8 5c fd ff ff       	call   8012fb <InitializeUHeap>
	if (size == 0) return NULL ;
  80159f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015a3:	75 07                	jne    8015ac <smalloc+0x1e>
  8015a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8015aa:	eb 7c                	jmp    801628 <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  8015ac:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8015b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015b9:	01 d0                	add    %edx,%eax
  8015bb:	48                   	dec    %eax
  8015bc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8015bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8015c7:	f7 75 f0             	divl   -0x10(%ebp)
  8015ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015cd:	29 d0                	sub    %edx,%eax
  8015cf:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  8015d2:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8015d9:	e8 41 06 00 00       	call   801c1f <sys_isUHeapPlacementStrategyFIRSTFIT>
  8015de:	85 c0                	test   %eax,%eax
  8015e0:	74 11                	je     8015f3 <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  8015e2:	83 ec 0c             	sub    $0xc,%esp
  8015e5:	ff 75 e8             	pushl  -0x18(%ebp)
  8015e8:	e8 ac 0c 00 00       	call   802299 <alloc_block_FF>
  8015ed:	83 c4 10             	add    $0x10,%esp
  8015f0:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  8015f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8015f7:	74 2a                	je     801623 <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8015f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015fc:	8b 40 08             	mov    0x8(%eax),%eax
  8015ff:	89 c2                	mov    %eax,%edx
  801601:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801605:	52                   	push   %edx
  801606:	50                   	push   %eax
  801607:	ff 75 0c             	pushl  0xc(%ebp)
  80160a:	ff 75 08             	pushl  0x8(%ebp)
  80160d:	e8 92 03 00 00       	call   8019a4 <sys_createSharedObject>
  801612:	83 c4 10             	add    $0x10,%esp
  801615:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  801618:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  80161c:	74 05                	je     801623 <smalloc+0x95>
			return (void*)virtual_address;
  80161e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801621:	eb 05                	jmp    801628 <smalloc+0x9a>
	}
	return NULL;
  801623:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801628:	c9                   	leave  
  801629:	c3                   	ret    

0080162a <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80162a:	55                   	push   %ebp
  80162b:	89 e5                	mov    %esp,%ebp
  80162d:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801630:	e8 c6 fc ff ff       	call   8012fb <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801635:	83 ec 04             	sub    $0x4,%esp
  801638:	68 c8 3e 80 00       	push   $0x803ec8
  80163d:	68 b0 00 00 00       	push   $0xb0
  801642:	68 73 3e 80 00       	push   $0x803e73
  801647:	e8 71 ec ff ff       	call   8002bd <_panic>

0080164c <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80164c:	55                   	push   %ebp
  80164d:	89 e5                	mov    %esp,%ebp
  80164f:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801652:	e8 a4 fc ff ff       	call   8012fb <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801657:	83 ec 04             	sub    $0x4,%esp
  80165a:	68 ec 3e 80 00       	push   $0x803eec
  80165f:	68 f4 00 00 00       	push   $0xf4
  801664:	68 73 3e 80 00       	push   $0x803e73
  801669:	e8 4f ec ff ff       	call   8002bd <_panic>

0080166e <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80166e:	55                   	push   %ebp
  80166f:	89 e5                	mov    %esp,%ebp
  801671:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801674:	83 ec 04             	sub    $0x4,%esp
  801677:	68 14 3f 80 00       	push   $0x803f14
  80167c:	68 08 01 00 00       	push   $0x108
  801681:	68 73 3e 80 00       	push   $0x803e73
  801686:	e8 32 ec ff ff       	call   8002bd <_panic>

0080168b <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80168b:	55                   	push   %ebp
  80168c:	89 e5                	mov    %esp,%ebp
  80168e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801691:	83 ec 04             	sub    $0x4,%esp
  801694:	68 38 3f 80 00       	push   $0x803f38
  801699:	68 13 01 00 00       	push   $0x113
  80169e:	68 73 3e 80 00       	push   $0x803e73
  8016a3:	e8 15 ec ff ff       	call   8002bd <_panic>

008016a8 <shrink>:

}
void shrink(uint32 newSize)
{
  8016a8:	55                   	push   %ebp
  8016a9:	89 e5                	mov    %esp,%ebp
  8016ab:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016ae:	83 ec 04             	sub    $0x4,%esp
  8016b1:	68 38 3f 80 00       	push   $0x803f38
  8016b6:	68 18 01 00 00       	push   $0x118
  8016bb:	68 73 3e 80 00       	push   $0x803e73
  8016c0:	e8 f8 eb ff ff       	call   8002bd <_panic>

008016c5 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8016c5:	55                   	push   %ebp
  8016c6:	89 e5                	mov    %esp,%ebp
  8016c8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016cb:	83 ec 04             	sub    $0x4,%esp
  8016ce:	68 38 3f 80 00       	push   $0x803f38
  8016d3:	68 1d 01 00 00       	push   $0x11d
  8016d8:	68 73 3e 80 00       	push   $0x803e73
  8016dd:	e8 db eb ff ff       	call   8002bd <_panic>

008016e2 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8016e2:	55                   	push   %ebp
  8016e3:	89 e5                	mov    %esp,%ebp
  8016e5:	57                   	push   %edi
  8016e6:	56                   	push   %esi
  8016e7:	53                   	push   %ebx
  8016e8:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016f1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016f4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016f7:	8b 7d 18             	mov    0x18(%ebp),%edi
  8016fa:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8016fd:	cd 30                	int    $0x30
  8016ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801702:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801705:	83 c4 10             	add    $0x10,%esp
  801708:	5b                   	pop    %ebx
  801709:	5e                   	pop    %esi
  80170a:	5f                   	pop    %edi
  80170b:	5d                   	pop    %ebp
  80170c:	c3                   	ret    

0080170d <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80170d:	55                   	push   %ebp
  80170e:	89 e5                	mov    %esp,%ebp
  801710:	83 ec 04             	sub    $0x4,%esp
  801713:	8b 45 10             	mov    0x10(%ebp),%eax
  801716:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801719:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80171d:	8b 45 08             	mov    0x8(%ebp),%eax
  801720:	6a 00                	push   $0x0
  801722:	6a 00                	push   $0x0
  801724:	52                   	push   %edx
  801725:	ff 75 0c             	pushl  0xc(%ebp)
  801728:	50                   	push   %eax
  801729:	6a 00                	push   $0x0
  80172b:	e8 b2 ff ff ff       	call   8016e2 <syscall>
  801730:	83 c4 18             	add    $0x18,%esp
}
  801733:	90                   	nop
  801734:	c9                   	leave  
  801735:	c3                   	ret    

00801736 <sys_cgetc>:

int
sys_cgetc(void)
{
  801736:	55                   	push   %ebp
  801737:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801739:	6a 00                	push   $0x0
  80173b:	6a 00                	push   $0x0
  80173d:	6a 00                	push   $0x0
  80173f:	6a 00                	push   $0x0
  801741:	6a 00                	push   $0x0
  801743:	6a 01                	push   $0x1
  801745:	e8 98 ff ff ff       	call   8016e2 <syscall>
  80174a:	83 c4 18             	add    $0x18,%esp
}
  80174d:	c9                   	leave  
  80174e:	c3                   	ret    

0080174f <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80174f:	55                   	push   %ebp
  801750:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801752:	8b 55 0c             	mov    0xc(%ebp),%edx
  801755:	8b 45 08             	mov    0x8(%ebp),%eax
  801758:	6a 00                	push   $0x0
  80175a:	6a 00                	push   $0x0
  80175c:	6a 00                	push   $0x0
  80175e:	52                   	push   %edx
  80175f:	50                   	push   %eax
  801760:	6a 05                	push   $0x5
  801762:	e8 7b ff ff ff       	call   8016e2 <syscall>
  801767:	83 c4 18             	add    $0x18,%esp
}
  80176a:	c9                   	leave  
  80176b:	c3                   	ret    

0080176c <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80176c:	55                   	push   %ebp
  80176d:	89 e5                	mov    %esp,%ebp
  80176f:	56                   	push   %esi
  801770:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801771:	8b 75 18             	mov    0x18(%ebp),%esi
  801774:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801777:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80177a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80177d:	8b 45 08             	mov    0x8(%ebp),%eax
  801780:	56                   	push   %esi
  801781:	53                   	push   %ebx
  801782:	51                   	push   %ecx
  801783:	52                   	push   %edx
  801784:	50                   	push   %eax
  801785:	6a 06                	push   $0x6
  801787:	e8 56 ff ff ff       	call   8016e2 <syscall>
  80178c:	83 c4 18             	add    $0x18,%esp
}
  80178f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801792:	5b                   	pop    %ebx
  801793:	5e                   	pop    %esi
  801794:	5d                   	pop    %ebp
  801795:	c3                   	ret    

00801796 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801796:	55                   	push   %ebp
  801797:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801799:	8b 55 0c             	mov    0xc(%ebp),%edx
  80179c:	8b 45 08             	mov    0x8(%ebp),%eax
  80179f:	6a 00                	push   $0x0
  8017a1:	6a 00                	push   $0x0
  8017a3:	6a 00                	push   $0x0
  8017a5:	52                   	push   %edx
  8017a6:	50                   	push   %eax
  8017a7:	6a 07                	push   $0x7
  8017a9:	e8 34 ff ff ff       	call   8016e2 <syscall>
  8017ae:	83 c4 18             	add    $0x18,%esp
}
  8017b1:	c9                   	leave  
  8017b2:	c3                   	ret    

008017b3 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8017b3:	55                   	push   %ebp
  8017b4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8017b6:	6a 00                	push   $0x0
  8017b8:	6a 00                	push   $0x0
  8017ba:	6a 00                	push   $0x0
  8017bc:	ff 75 0c             	pushl  0xc(%ebp)
  8017bf:	ff 75 08             	pushl  0x8(%ebp)
  8017c2:	6a 08                	push   $0x8
  8017c4:	e8 19 ff ff ff       	call   8016e2 <syscall>
  8017c9:	83 c4 18             	add    $0x18,%esp
}
  8017cc:	c9                   	leave  
  8017cd:	c3                   	ret    

008017ce <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8017ce:	55                   	push   %ebp
  8017cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8017d1:	6a 00                	push   $0x0
  8017d3:	6a 00                	push   $0x0
  8017d5:	6a 00                	push   $0x0
  8017d7:	6a 00                	push   $0x0
  8017d9:	6a 00                	push   $0x0
  8017db:	6a 09                	push   $0x9
  8017dd:	e8 00 ff ff ff       	call   8016e2 <syscall>
  8017e2:	83 c4 18             	add    $0x18,%esp
}
  8017e5:	c9                   	leave  
  8017e6:	c3                   	ret    

008017e7 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8017e7:	55                   	push   %ebp
  8017e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8017ea:	6a 00                	push   $0x0
  8017ec:	6a 00                	push   $0x0
  8017ee:	6a 00                	push   $0x0
  8017f0:	6a 00                	push   $0x0
  8017f2:	6a 00                	push   $0x0
  8017f4:	6a 0a                	push   $0xa
  8017f6:	e8 e7 fe ff ff       	call   8016e2 <syscall>
  8017fb:	83 c4 18             	add    $0x18,%esp
}
  8017fe:	c9                   	leave  
  8017ff:	c3                   	ret    

00801800 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801800:	55                   	push   %ebp
  801801:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801803:	6a 00                	push   $0x0
  801805:	6a 00                	push   $0x0
  801807:	6a 00                	push   $0x0
  801809:	6a 00                	push   $0x0
  80180b:	6a 00                	push   $0x0
  80180d:	6a 0b                	push   $0xb
  80180f:	e8 ce fe ff ff       	call   8016e2 <syscall>
  801814:	83 c4 18             	add    $0x18,%esp
}
  801817:	c9                   	leave  
  801818:	c3                   	ret    

00801819 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801819:	55                   	push   %ebp
  80181a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80181c:	6a 00                	push   $0x0
  80181e:	6a 00                	push   $0x0
  801820:	6a 00                	push   $0x0
  801822:	ff 75 0c             	pushl  0xc(%ebp)
  801825:	ff 75 08             	pushl  0x8(%ebp)
  801828:	6a 0f                	push   $0xf
  80182a:	e8 b3 fe ff ff       	call   8016e2 <syscall>
  80182f:	83 c4 18             	add    $0x18,%esp
	return;
  801832:	90                   	nop
}
  801833:	c9                   	leave  
  801834:	c3                   	ret    

00801835 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801835:	55                   	push   %ebp
  801836:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801838:	6a 00                	push   $0x0
  80183a:	6a 00                	push   $0x0
  80183c:	6a 00                	push   $0x0
  80183e:	ff 75 0c             	pushl  0xc(%ebp)
  801841:	ff 75 08             	pushl  0x8(%ebp)
  801844:	6a 10                	push   $0x10
  801846:	e8 97 fe ff ff       	call   8016e2 <syscall>
  80184b:	83 c4 18             	add    $0x18,%esp
	return ;
  80184e:	90                   	nop
}
  80184f:	c9                   	leave  
  801850:	c3                   	ret    

00801851 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801851:	55                   	push   %ebp
  801852:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801854:	6a 00                	push   $0x0
  801856:	6a 00                	push   $0x0
  801858:	ff 75 10             	pushl  0x10(%ebp)
  80185b:	ff 75 0c             	pushl  0xc(%ebp)
  80185e:	ff 75 08             	pushl  0x8(%ebp)
  801861:	6a 11                	push   $0x11
  801863:	e8 7a fe ff ff       	call   8016e2 <syscall>
  801868:	83 c4 18             	add    $0x18,%esp
	return ;
  80186b:	90                   	nop
}
  80186c:	c9                   	leave  
  80186d:	c3                   	ret    

0080186e <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80186e:	55                   	push   %ebp
  80186f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801871:	6a 00                	push   $0x0
  801873:	6a 00                	push   $0x0
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	6a 00                	push   $0x0
  80187b:	6a 0c                	push   $0xc
  80187d:	e8 60 fe ff ff       	call   8016e2 <syscall>
  801882:	83 c4 18             	add    $0x18,%esp
}
  801885:	c9                   	leave  
  801886:	c3                   	ret    

00801887 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801887:	55                   	push   %ebp
  801888:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80188a:	6a 00                	push   $0x0
  80188c:	6a 00                	push   $0x0
  80188e:	6a 00                	push   $0x0
  801890:	6a 00                	push   $0x0
  801892:	ff 75 08             	pushl  0x8(%ebp)
  801895:	6a 0d                	push   $0xd
  801897:	e8 46 fe ff ff       	call   8016e2 <syscall>
  80189c:	83 c4 18             	add    $0x18,%esp
}
  80189f:	c9                   	leave  
  8018a0:	c3                   	ret    

008018a1 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8018a1:	55                   	push   %ebp
  8018a2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8018a4:	6a 00                	push   $0x0
  8018a6:	6a 00                	push   $0x0
  8018a8:	6a 00                	push   $0x0
  8018aa:	6a 00                	push   $0x0
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 0e                	push   $0xe
  8018b0:	e8 2d fe ff ff       	call   8016e2 <syscall>
  8018b5:	83 c4 18             	add    $0x18,%esp
}
  8018b8:	90                   	nop
  8018b9:	c9                   	leave  
  8018ba:	c3                   	ret    

008018bb <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8018bb:	55                   	push   %ebp
  8018bc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8018be:	6a 00                	push   $0x0
  8018c0:	6a 00                	push   $0x0
  8018c2:	6a 00                	push   $0x0
  8018c4:	6a 00                	push   $0x0
  8018c6:	6a 00                	push   $0x0
  8018c8:	6a 13                	push   $0x13
  8018ca:	e8 13 fe ff ff       	call   8016e2 <syscall>
  8018cf:	83 c4 18             	add    $0x18,%esp
}
  8018d2:	90                   	nop
  8018d3:	c9                   	leave  
  8018d4:	c3                   	ret    

008018d5 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8018d5:	55                   	push   %ebp
  8018d6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8018d8:	6a 00                	push   $0x0
  8018da:	6a 00                	push   $0x0
  8018dc:	6a 00                	push   $0x0
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 14                	push   $0x14
  8018e4:	e8 f9 fd ff ff       	call   8016e2 <syscall>
  8018e9:	83 c4 18             	add    $0x18,%esp
}
  8018ec:	90                   	nop
  8018ed:	c9                   	leave  
  8018ee:	c3                   	ret    

008018ef <sys_cputc>:


void
sys_cputc(const char c)
{
  8018ef:	55                   	push   %ebp
  8018f0:	89 e5                	mov    %esp,%ebp
  8018f2:	83 ec 04             	sub    $0x4,%esp
  8018f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8018fb:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8018ff:	6a 00                	push   $0x0
  801901:	6a 00                	push   $0x0
  801903:	6a 00                	push   $0x0
  801905:	6a 00                	push   $0x0
  801907:	50                   	push   %eax
  801908:	6a 15                	push   $0x15
  80190a:	e8 d3 fd ff ff       	call   8016e2 <syscall>
  80190f:	83 c4 18             	add    $0x18,%esp
}
  801912:	90                   	nop
  801913:	c9                   	leave  
  801914:	c3                   	ret    

00801915 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801915:	55                   	push   %ebp
  801916:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801918:	6a 00                	push   $0x0
  80191a:	6a 00                	push   $0x0
  80191c:	6a 00                	push   $0x0
  80191e:	6a 00                	push   $0x0
  801920:	6a 00                	push   $0x0
  801922:	6a 16                	push   $0x16
  801924:	e8 b9 fd ff ff       	call   8016e2 <syscall>
  801929:	83 c4 18             	add    $0x18,%esp
}
  80192c:	90                   	nop
  80192d:	c9                   	leave  
  80192e:	c3                   	ret    

0080192f <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80192f:	55                   	push   %ebp
  801930:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801932:	8b 45 08             	mov    0x8(%ebp),%eax
  801935:	6a 00                	push   $0x0
  801937:	6a 00                	push   $0x0
  801939:	6a 00                	push   $0x0
  80193b:	ff 75 0c             	pushl  0xc(%ebp)
  80193e:	50                   	push   %eax
  80193f:	6a 17                	push   $0x17
  801941:	e8 9c fd ff ff       	call   8016e2 <syscall>
  801946:	83 c4 18             	add    $0x18,%esp
}
  801949:	c9                   	leave  
  80194a:	c3                   	ret    

0080194b <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80194b:	55                   	push   %ebp
  80194c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80194e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801951:	8b 45 08             	mov    0x8(%ebp),%eax
  801954:	6a 00                	push   $0x0
  801956:	6a 00                	push   $0x0
  801958:	6a 00                	push   $0x0
  80195a:	52                   	push   %edx
  80195b:	50                   	push   %eax
  80195c:	6a 1a                	push   $0x1a
  80195e:	e8 7f fd ff ff       	call   8016e2 <syscall>
  801963:	83 c4 18             	add    $0x18,%esp
}
  801966:	c9                   	leave  
  801967:	c3                   	ret    

00801968 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801968:	55                   	push   %ebp
  801969:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80196b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80196e:	8b 45 08             	mov    0x8(%ebp),%eax
  801971:	6a 00                	push   $0x0
  801973:	6a 00                	push   $0x0
  801975:	6a 00                	push   $0x0
  801977:	52                   	push   %edx
  801978:	50                   	push   %eax
  801979:	6a 18                	push   $0x18
  80197b:	e8 62 fd ff ff       	call   8016e2 <syscall>
  801980:	83 c4 18             	add    $0x18,%esp
}
  801983:	90                   	nop
  801984:	c9                   	leave  
  801985:	c3                   	ret    

00801986 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801986:	55                   	push   %ebp
  801987:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801989:	8b 55 0c             	mov    0xc(%ebp),%edx
  80198c:	8b 45 08             	mov    0x8(%ebp),%eax
  80198f:	6a 00                	push   $0x0
  801991:	6a 00                	push   $0x0
  801993:	6a 00                	push   $0x0
  801995:	52                   	push   %edx
  801996:	50                   	push   %eax
  801997:	6a 19                	push   $0x19
  801999:	e8 44 fd ff ff       	call   8016e2 <syscall>
  80199e:	83 c4 18             	add    $0x18,%esp
}
  8019a1:	90                   	nop
  8019a2:	c9                   	leave  
  8019a3:	c3                   	ret    

008019a4 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8019a4:	55                   	push   %ebp
  8019a5:	89 e5                	mov    %esp,%ebp
  8019a7:	83 ec 04             	sub    $0x4,%esp
  8019aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8019ad:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8019b0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8019b3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ba:	6a 00                	push   $0x0
  8019bc:	51                   	push   %ecx
  8019bd:	52                   	push   %edx
  8019be:	ff 75 0c             	pushl  0xc(%ebp)
  8019c1:	50                   	push   %eax
  8019c2:	6a 1b                	push   $0x1b
  8019c4:	e8 19 fd ff ff       	call   8016e2 <syscall>
  8019c9:	83 c4 18             	add    $0x18,%esp
}
  8019cc:	c9                   	leave  
  8019cd:	c3                   	ret    

008019ce <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8019ce:	55                   	push   %ebp
  8019cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8019d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d7:	6a 00                	push   $0x0
  8019d9:	6a 00                	push   $0x0
  8019db:	6a 00                	push   $0x0
  8019dd:	52                   	push   %edx
  8019de:	50                   	push   %eax
  8019df:	6a 1c                	push   $0x1c
  8019e1:	e8 fc fc ff ff       	call   8016e2 <syscall>
  8019e6:	83 c4 18             	add    $0x18,%esp
}
  8019e9:	c9                   	leave  
  8019ea:	c3                   	ret    

008019eb <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8019eb:	55                   	push   %ebp
  8019ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8019ee:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f7:	6a 00                	push   $0x0
  8019f9:	6a 00                	push   $0x0
  8019fb:	51                   	push   %ecx
  8019fc:	52                   	push   %edx
  8019fd:	50                   	push   %eax
  8019fe:	6a 1d                	push   $0x1d
  801a00:	e8 dd fc ff ff       	call   8016e2 <syscall>
  801a05:	83 c4 18             	add    $0x18,%esp
}
  801a08:	c9                   	leave  
  801a09:	c3                   	ret    

00801a0a <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801a0a:	55                   	push   %ebp
  801a0b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a10:	8b 45 08             	mov    0x8(%ebp),%eax
  801a13:	6a 00                	push   $0x0
  801a15:	6a 00                	push   $0x0
  801a17:	6a 00                	push   $0x0
  801a19:	52                   	push   %edx
  801a1a:	50                   	push   %eax
  801a1b:	6a 1e                	push   $0x1e
  801a1d:	e8 c0 fc ff ff       	call   8016e2 <syscall>
  801a22:	83 c4 18             	add    $0x18,%esp
}
  801a25:	c9                   	leave  
  801a26:	c3                   	ret    

00801a27 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801a27:	55                   	push   %ebp
  801a28:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 00                	push   $0x0
  801a32:	6a 00                	push   $0x0
  801a34:	6a 1f                	push   $0x1f
  801a36:	e8 a7 fc ff ff       	call   8016e2 <syscall>
  801a3b:	83 c4 18             	add    $0x18,%esp
}
  801a3e:	c9                   	leave  
  801a3f:	c3                   	ret    

00801a40 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a40:	55                   	push   %ebp
  801a41:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a43:	8b 45 08             	mov    0x8(%ebp),%eax
  801a46:	6a 00                	push   $0x0
  801a48:	ff 75 14             	pushl  0x14(%ebp)
  801a4b:	ff 75 10             	pushl  0x10(%ebp)
  801a4e:	ff 75 0c             	pushl  0xc(%ebp)
  801a51:	50                   	push   %eax
  801a52:	6a 20                	push   $0x20
  801a54:	e8 89 fc ff ff       	call   8016e2 <syscall>
  801a59:	83 c4 18             	add    $0x18,%esp
}
  801a5c:	c9                   	leave  
  801a5d:	c3                   	ret    

00801a5e <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801a5e:	55                   	push   %ebp
  801a5f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a61:	8b 45 08             	mov    0x8(%ebp),%eax
  801a64:	6a 00                	push   $0x0
  801a66:	6a 00                	push   $0x0
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 00                	push   $0x0
  801a6c:	50                   	push   %eax
  801a6d:	6a 21                	push   $0x21
  801a6f:	e8 6e fc ff ff       	call   8016e2 <syscall>
  801a74:	83 c4 18             	add    $0x18,%esp
}
  801a77:	90                   	nop
  801a78:	c9                   	leave  
  801a79:	c3                   	ret    

00801a7a <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801a7a:	55                   	push   %ebp
  801a7b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801a7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a80:	6a 00                	push   $0x0
  801a82:	6a 00                	push   $0x0
  801a84:	6a 00                	push   $0x0
  801a86:	6a 00                	push   $0x0
  801a88:	50                   	push   %eax
  801a89:	6a 22                	push   $0x22
  801a8b:	e8 52 fc ff ff       	call   8016e2 <syscall>
  801a90:	83 c4 18             	add    $0x18,%esp
}
  801a93:	c9                   	leave  
  801a94:	c3                   	ret    

00801a95 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801a95:	55                   	push   %ebp
  801a96:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 00                	push   $0x0
  801aa2:	6a 02                	push   $0x2
  801aa4:	e8 39 fc ff ff       	call   8016e2 <syscall>
  801aa9:	83 c4 18             	add    $0x18,%esp
}
  801aac:	c9                   	leave  
  801aad:	c3                   	ret    

00801aae <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801aae:	55                   	push   %ebp
  801aaf:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801ab1:	6a 00                	push   $0x0
  801ab3:	6a 00                	push   $0x0
  801ab5:	6a 00                	push   $0x0
  801ab7:	6a 00                	push   $0x0
  801ab9:	6a 00                	push   $0x0
  801abb:	6a 03                	push   $0x3
  801abd:	e8 20 fc ff ff       	call   8016e2 <syscall>
  801ac2:	83 c4 18             	add    $0x18,%esp
}
  801ac5:	c9                   	leave  
  801ac6:	c3                   	ret    

00801ac7 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801ac7:	55                   	push   %ebp
  801ac8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801aca:	6a 00                	push   $0x0
  801acc:	6a 00                	push   $0x0
  801ace:	6a 00                	push   $0x0
  801ad0:	6a 00                	push   $0x0
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 04                	push   $0x4
  801ad6:	e8 07 fc ff ff       	call   8016e2 <syscall>
  801adb:	83 c4 18             	add    $0x18,%esp
}
  801ade:	c9                   	leave  
  801adf:	c3                   	ret    

00801ae0 <sys_exit_env>:


void sys_exit_env(void)
{
  801ae0:	55                   	push   %ebp
  801ae1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 00                	push   $0x0
  801ae9:	6a 00                	push   $0x0
  801aeb:	6a 00                	push   $0x0
  801aed:	6a 23                	push   $0x23
  801aef:	e8 ee fb ff ff       	call   8016e2 <syscall>
  801af4:	83 c4 18             	add    $0x18,%esp
}
  801af7:	90                   	nop
  801af8:	c9                   	leave  
  801af9:	c3                   	ret    

00801afa <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801afa:	55                   	push   %ebp
  801afb:	89 e5                	mov    %esp,%ebp
  801afd:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b00:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b03:	8d 50 04             	lea    0x4(%eax),%edx
  801b06:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	52                   	push   %edx
  801b10:	50                   	push   %eax
  801b11:	6a 24                	push   $0x24
  801b13:	e8 ca fb ff ff       	call   8016e2 <syscall>
  801b18:	83 c4 18             	add    $0x18,%esp
	return result;
  801b1b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b1e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b21:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b24:	89 01                	mov    %eax,(%ecx)
  801b26:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b29:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2c:	c9                   	leave  
  801b2d:	c2 04 00             	ret    $0x4

00801b30 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b30:	55                   	push   %ebp
  801b31:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b33:	6a 00                	push   $0x0
  801b35:	6a 00                	push   $0x0
  801b37:	ff 75 10             	pushl  0x10(%ebp)
  801b3a:	ff 75 0c             	pushl  0xc(%ebp)
  801b3d:	ff 75 08             	pushl  0x8(%ebp)
  801b40:	6a 12                	push   $0x12
  801b42:	e8 9b fb ff ff       	call   8016e2 <syscall>
  801b47:	83 c4 18             	add    $0x18,%esp
	return ;
  801b4a:	90                   	nop
}
  801b4b:	c9                   	leave  
  801b4c:	c3                   	ret    

00801b4d <sys_rcr2>:
uint32 sys_rcr2()
{
  801b4d:	55                   	push   %ebp
  801b4e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b50:	6a 00                	push   $0x0
  801b52:	6a 00                	push   $0x0
  801b54:	6a 00                	push   $0x0
  801b56:	6a 00                	push   $0x0
  801b58:	6a 00                	push   $0x0
  801b5a:	6a 25                	push   $0x25
  801b5c:	e8 81 fb ff ff       	call   8016e2 <syscall>
  801b61:	83 c4 18             	add    $0x18,%esp
}
  801b64:	c9                   	leave  
  801b65:	c3                   	ret    

00801b66 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801b66:	55                   	push   %ebp
  801b67:	89 e5                	mov    %esp,%ebp
  801b69:	83 ec 04             	sub    $0x4,%esp
  801b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801b72:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801b76:	6a 00                	push   $0x0
  801b78:	6a 00                	push   $0x0
  801b7a:	6a 00                	push   $0x0
  801b7c:	6a 00                	push   $0x0
  801b7e:	50                   	push   %eax
  801b7f:	6a 26                	push   $0x26
  801b81:	e8 5c fb ff ff       	call   8016e2 <syscall>
  801b86:	83 c4 18             	add    $0x18,%esp
	return ;
  801b89:	90                   	nop
}
  801b8a:	c9                   	leave  
  801b8b:	c3                   	ret    

00801b8c <rsttst>:
void rsttst()
{
  801b8c:	55                   	push   %ebp
  801b8d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 00                	push   $0x0
  801b93:	6a 00                	push   $0x0
  801b95:	6a 00                	push   $0x0
  801b97:	6a 00                	push   $0x0
  801b99:	6a 28                	push   $0x28
  801b9b:	e8 42 fb ff ff       	call   8016e2 <syscall>
  801ba0:	83 c4 18             	add    $0x18,%esp
	return ;
  801ba3:	90                   	nop
}
  801ba4:	c9                   	leave  
  801ba5:	c3                   	ret    

00801ba6 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ba6:	55                   	push   %ebp
  801ba7:	89 e5                	mov    %esp,%ebp
  801ba9:	83 ec 04             	sub    $0x4,%esp
  801bac:	8b 45 14             	mov    0x14(%ebp),%eax
  801baf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801bb2:	8b 55 18             	mov    0x18(%ebp),%edx
  801bb5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801bb9:	52                   	push   %edx
  801bba:	50                   	push   %eax
  801bbb:	ff 75 10             	pushl  0x10(%ebp)
  801bbe:	ff 75 0c             	pushl  0xc(%ebp)
  801bc1:	ff 75 08             	pushl  0x8(%ebp)
  801bc4:	6a 27                	push   $0x27
  801bc6:	e8 17 fb ff ff       	call   8016e2 <syscall>
  801bcb:	83 c4 18             	add    $0x18,%esp
	return ;
  801bce:	90                   	nop
}
  801bcf:	c9                   	leave  
  801bd0:	c3                   	ret    

00801bd1 <chktst>:
void chktst(uint32 n)
{
  801bd1:	55                   	push   %ebp
  801bd2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 00                	push   $0x0
  801bdc:	ff 75 08             	pushl  0x8(%ebp)
  801bdf:	6a 29                	push   $0x29
  801be1:	e8 fc fa ff ff       	call   8016e2 <syscall>
  801be6:	83 c4 18             	add    $0x18,%esp
	return ;
  801be9:	90                   	nop
}
  801bea:	c9                   	leave  
  801beb:	c3                   	ret    

00801bec <inctst>:

void inctst()
{
  801bec:	55                   	push   %ebp
  801bed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801bef:	6a 00                	push   $0x0
  801bf1:	6a 00                	push   $0x0
  801bf3:	6a 00                	push   $0x0
  801bf5:	6a 00                	push   $0x0
  801bf7:	6a 00                	push   $0x0
  801bf9:	6a 2a                	push   $0x2a
  801bfb:	e8 e2 fa ff ff       	call   8016e2 <syscall>
  801c00:	83 c4 18             	add    $0x18,%esp
	return ;
  801c03:	90                   	nop
}
  801c04:	c9                   	leave  
  801c05:	c3                   	ret    

00801c06 <gettst>:
uint32 gettst()
{
  801c06:	55                   	push   %ebp
  801c07:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 00                	push   $0x0
  801c11:	6a 00                	push   $0x0
  801c13:	6a 2b                	push   $0x2b
  801c15:	e8 c8 fa ff ff       	call   8016e2 <syscall>
  801c1a:	83 c4 18             	add    $0x18,%esp
}
  801c1d:	c9                   	leave  
  801c1e:	c3                   	ret    

00801c1f <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801c1f:	55                   	push   %ebp
  801c20:	89 e5                	mov    %esp,%ebp
  801c22:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c25:	6a 00                	push   $0x0
  801c27:	6a 00                	push   $0x0
  801c29:	6a 00                	push   $0x0
  801c2b:	6a 00                	push   $0x0
  801c2d:	6a 00                	push   $0x0
  801c2f:	6a 2c                	push   $0x2c
  801c31:	e8 ac fa ff ff       	call   8016e2 <syscall>
  801c36:	83 c4 18             	add    $0x18,%esp
  801c39:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801c3c:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801c40:	75 07                	jne    801c49 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801c42:	b8 01 00 00 00       	mov    $0x1,%eax
  801c47:	eb 05                	jmp    801c4e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801c49:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c4e:	c9                   	leave  
  801c4f:	c3                   	ret    

00801c50 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801c50:	55                   	push   %ebp
  801c51:	89 e5                	mov    %esp,%ebp
  801c53:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c56:	6a 00                	push   $0x0
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 00                	push   $0x0
  801c60:	6a 2c                	push   $0x2c
  801c62:	e8 7b fa ff ff       	call   8016e2 <syscall>
  801c67:	83 c4 18             	add    $0x18,%esp
  801c6a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801c6d:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801c71:	75 07                	jne    801c7a <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801c73:	b8 01 00 00 00       	mov    $0x1,%eax
  801c78:	eb 05                	jmp    801c7f <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801c7a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c7f:	c9                   	leave  
  801c80:	c3                   	ret    

00801c81 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801c81:	55                   	push   %ebp
  801c82:	89 e5                	mov    %esp,%ebp
  801c84:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c87:	6a 00                	push   $0x0
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 00                	push   $0x0
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 2c                	push   $0x2c
  801c93:	e8 4a fa ff ff       	call   8016e2 <syscall>
  801c98:	83 c4 18             	add    $0x18,%esp
  801c9b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801c9e:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801ca2:	75 07                	jne    801cab <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801ca4:	b8 01 00 00 00       	mov    $0x1,%eax
  801ca9:	eb 05                	jmp    801cb0 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801cab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cb0:	c9                   	leave  
  801cb1:	c3                   	ret    

00801cb2 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801cb2:	55                   	push   %ebp
  801cb3:	89 e5                	mov    %esp,%ebp
  801cb5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cb8:	6a 00                	push   $0x0
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 00                	push   $0x0
  801cbe:	6a 00                	push   $0x0
  801cc0:	6a 00                	push   $0x0
  801cc2:	6a 2c                	push   $0x2c
  801cc4:	e8 19 fa ff ff       	call   8016e2 <syscall>
  801cc9:	83 c4 18             	add    $0x18,%esp
  801ccc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801ccf:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801cd3:	75 07                	jne    801cdc <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801cd5:	b8 01 00 00 00       	mov    $0x1,%eax
  801cda:	eb 05                	jmp    801ce1 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801cdc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ce1:	c9                   	leave  
  801ce2:	c3                   	ret    

00801ce3 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ce3:	55                   	push   %ebp
  801ce4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ce6:	6a 00                	push   $0x0
  801ce8:	6a 00                	push   $0x0
  801cea:	6a 00                	push   $0x0
  801cec:	6a 00                	push   $0x0
  801cee:	ff 75 08             	pushl  0x8(%ebp)
  801cf1:	6a 2d                	push   $0x2d
  801cf3:	e8 ea f9 ff ff       	call   8016e2 <syscall>
  801cf8:	83 c4 18             	add    $0x18,%esp
	return ;
  801cfb:	90                   	nop
}
  801cfc:	c9                   	leave  
  801cfd:	c3                   	ret    

00801cfe <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801cfe:	55                   	push   %ebp
  801cff:	89 e5                	mov    %esp,%ebp
  801d01:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801d02:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d05:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d08:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0e:	6a 00                	push   $0x0
  801d10:	53                   	push   %ebx
  801d11:	51                   	push   %ecx
  801d12:	52                   	push   %edx
  801d13:	50                   	push   %eax
  801d14:	6a 2e                	push   $0x2e
  801d16:	e8 c7 f9 ff ff       	call   8016e2 <syscall>
  801d1b:	83 c4 18             	add    $0x18,%esp
}
  801d1e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d21:	c9                   	leave  
  801d22:	c3                   	ret    

00801d23 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801d23:	55                   	push   %ebp
  801d24:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801d26:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d29:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2c:	6a 00                	push   $0x0
  801d2e:	6a 00                	push   $0x0
  801d30:	6a 00                	push   $0x0
  801d32:	52                   	push   %edx
  801d33:	50                   	push   %eax
  801d34:	6a 2f                	push   $0x2f
  801d36:	e8 a7 f9 ff ff       	call   8016e2 <syscall>
  801d3b:	83 c4 18             	add    $0x18,%esp
}
  801d3e:	c9                   	leave  
  801d3f:	c3                   	ret    

00801d40 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801d40:	55                   	push   %ebp
  801d41:	89 e5                	mov    %esp,%ebp
  801d43:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801d46:	83 ec 0c             	sub    $0xc,%esp
  801d49:	68 48 3f 80 00       	push   $0x803f48
  801d4e:	e8 1e e8 ff ff       	call   800571 <cprintf>
  801d53:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801d56:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801d5d:	83 ec 0c             	sub    $0xc,%esp
  801d60:	68 74 3f 80 00       	push   $0x803f74
  801d65:	e8 07 e8 ff ff       	call   800571 <cprintf>
  801d6a:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801d6d:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d71:	a1 38 51 80 00       	mov    0x805138,%eax
  801d76:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d79:	eb 56                	jmp    801dd1 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801d7b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d7f:	74 1c                	je     801d9d <print_mem_block_lists+0x5d>
  801d81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d84:	8b 50 08             	mov    0x8(%eax),%edx
  801d87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d8a:	8b 48 08             	mov    0x8(%eax),%ecx
  801d8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d90:	8b 40 0c             	mov    0xc(%eax),%eax
  801d93:	01 c8                	add    %ecx,%eax
  801d95:	39 c2                	cmp    %eax,%edx
  801d97:	73 04                	jae    801d9d <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801d99:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801d9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801da0:	8b 50 08             	mov    0x8(%eax),%edx
  801da3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801da6:	8b 40 0c             	mov    0xc(%eax),%eax
  801da9:	01 c2                	add    %eax,%edx
  801dab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dae:	8b 40 08             	mov    0x8(%eax),%eax
  801db1:	83 ec 04             	sub    $0x4,%esp
  801db4:	52                   	push   %edx
  801db5:	50                   	push   %eax
  801db6:	68 89 3f 80 00       	push   $0x803f89
  801dbb:	e8 b1 e7 ff ff       	call   800571 <cprintf>
  801dc0:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801dc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801dc9:	a1 40 51 80 00       	mov    0x805140,%eax
  801dce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dd1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801dd5:	74 07                	je     801dde <print_mem_block_lists+0x9e>
  801dd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dda:	8b 00                	mov    (%eax),%eax
  801ddc:	eb 05                	jmp    801de3 <print_mem_block_lists+0xa3>
  801dde:	b8 00 00 00 00       	mov    $0x0,%eax
  801de3:	a3 40 51 80 00       	mov    %eax,0x805140
  801de8:	a1 40 51 80 00       	mov    0x805140,%eax
  801ded:	85 c0                	test   %eax,%eax
  801def:	75 8a                	jne    801d7b <print_mem_block_lists+0x3b>
  801df1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801df5:	75 84                	jne    801d7b <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801df7:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801dfb:	75 10                	jne    801e0d <print_mem_block_lists+0xcd>
  801dfd:	83 ec 0c             	sub    $0xc,%esp
  801e00:	68 98 3f 80 00       	push   $0x803f98
  801e05:	e8 67 e7 ff ff       	call   800571 <cprintf>
  801e0a:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801e0d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801e14:	83 ec 0c             	sub    $0xc,%esp
  801e17:	68 bc 3f 80 00       	push   $0x803fbc
  801e1c:	e8 50 e7 ff ff       	call   800571 <cprintf>
  801e21:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801e24:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801e28:	a1 40 50 80 00       	mov    0x805040,%eax
  801e2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e30:	eb 56                	jmp    801e88 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e32:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e36:	74 1c                	je     801e54 <print_mem_block_lists+0x114>
  801e38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e3b:	8b 50 08             	mov    0x8(%eax),%edx
  801e3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e41:	8b 48 08             	mov    0x8(%eax),%ecx
  801e44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e47:	8b 40 0c             	mov    0xc(%eax),%eax
  801e4a:	01 c8                	add    %ecx,%eax
  801e4c:	39 c2                	cmp    %eax,%edx
  801e4e:	73 04                	jae    801e54 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801e50:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e57:	8b 50 08             	mov    0x8(%eax),%edx
  801e5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e5d:	8b 40 0c             	mov    0xc(%eax),%eax
  801e60:	01 c2                	add    %eax,%edx
  801e62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e65:	8b 40 08             	mov    0x8(%eax),%eax
  801e68:	83 ec 04             	sub    $0x4,%esp
  801e6b:	52                   	push   %edx
  801e6c:	50                   	push   %eax
  801e6d:	68 89 3f 80 00       	push   $0x803f89
  801e72:	e8 fa e6 ff ff       	call   800571 <cprintf>
  801e77:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801e80:	a1 48 50 80 00       	mov    0x805048,%eax
  801e85:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e88:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e8c:	74 07                	je     801e95 <print_mem_block_lists+0x155>
  801e8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e91:	8b 00                	mov    (%eax),%eax
  801e93:	eb 05                	jmp    801e9a <print_mem_block_lists+0x15a>
  801e95:	b8 00 00 00 00       	mov    $0x0,%eax
  801e9a:	a3 48 50 80 00       	mov    %eax,0x805048
  801e9f:	a1 48 50 80 00       	mov    0x805048,%eax
  801ea4:	85 c0                	test   %eax,%eax
  801ea6:	75 8a                	jne    801e32 <print_mem_block_lists+0xf2>
  801ea8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801eac:	75 84                	jne    801e32 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801eae:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801eb2:	75 10                	jne    801ec4 <print_mem_block_lists+0x184>
  801eb4:	83 ec 0c             	sub    $0xc,%esp
  801eb7:	68 d4 3f 80 00       	push   $0x803fd4
  801ebc:	e8 b0 e6 ff ff       	call   800571 <cprintf>
  801ec1:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801ec4:	83 ec 0c             	sub    $0xc,%esp
  801ec7:	68 48 3f 80 00       	push   $0x803f48
  801ecc:	e8 a0 e6 ff ff       	call   800571 <cprintf>
  801ed1:	83 c4 10             	add    $0x10,%esp

}
  801ed4:	90                   	nop
  801ed5:	c9                   	leave  
  801ed6:	c3                   	ret    

00801ed7 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801ed7:	55                   	push   %ebp
  801ed8:	89 e5                	mov    %esp,%ebp
  801eda:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801edd:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  801ee4:	00 00 00 
  801ee7:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  801eee:	00 00 00 
  801ef1:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  801ef8:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801efb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801f02:	e9 9e 00 00 00       	jmp    801fa5 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801f07:	a1 50 50 80 00       	mov    0x805050,%eax
  801f0c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f0f:	c1 e2 04             	shl    $0x4,%edx
  801f12:	01 d0                	add    %edx,%eax
  801f14:	85 c0                	test   %eax,%eax
  801f16:	75 14                	jne    801f2c <initialize_MemBlocksList+0x55>
  801f18:	83 ec 04             	sub    $0x4,%esp
  801f1b:	68 fc 3f 80 00       	push   $0x803ffc
  801f20:	6a 46                	push   $0x46
  801f22:	68 1f 40 80 00       	push   $0x80401f
  801f27:	e8 91 e3 ff ff       	call   8002bd <_panic>
  801f2c:	a1 50 50 80 00       	mov    0x805050,%eax
  801f31:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f34:	c1 e2 04             	shl    $0x4,%edx
  801f37:	01 d0                	add    %edx,%eax
  801f39:	8b 15 48 51 80 00    	mov    0x805148,%edx
  801f3f:	89 10                	mov    %edx,(%eax)
  801f41:	8b 00                	mov    (%eax),%eax
  801f43:	85 c0                	test   %eax,%eax
  801f45:	74 18                	je     801f5f <initialize_MemBlocksList+0x88>
  801f47:	a1 48 51 80 00       	mov    0x805148,%eax
  801f4c:	8b 15 50 50 80 00    	mov    0x805050,%edx
  801f52:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801f55:	c1 e1 04             	shl    $0x4,%ecx
  801f58:	01 ca                	add    %ecx,%edx
  801f5a:	89 50 04             	mov    %edx,0x4(%eax)
  801f5d:	eb 12                	jmp    801f71 <initialize_MemBlocksList+0x9a>
  801f5f:	a1 50 50 80 00       	mov    0x805050,%eax
  801f64:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f67:	c1 e2 04             	shl    $0x4,%edx
  801f6a:	01 d0                	add    %edx,%eax
  801f6c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801f71:	a1 50 50 80 00       	mov    0x805050,%eax
  801f76:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f79:	c1 e2 04             	shl    $0x4,%edx
  801f7c:	01 d0                	add    %edx,%eax
  801f7e:	a3 48 51 80 00       	mov    %eax,0x805148
  801f83:	a1 50 50 80 00       	mov    0x805050,%eax
  801f88:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f8b:	c1 e2 04             	shl    $0x4,%edx
  801f8e:	01 d0                	add    %edx,%eax
  801f90:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f97:	a1 54 51 80 00       	mov    0x805154,%eax
  801f9c:	40                   	inc    %eax
  801f9d:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801fa2:	ff 45 f4             	incl   -0xc(%ebp)
  801fa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa8:	3b 45 08             	cmp    0x8(%ebp),%eax
  801fab:	0f 82 56 ff ff ff    	jb     801f07 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801fb1:	90                   	nop
  801fb2:	c9                   	leave  
  801fb3:	c3                   	ret    

00801fb4 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801fb4:	55                   	push   %ebp
  801fb5:	89 e5                	mov    %esp,%ebp
  801fb7:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801fba:	8b 45 08             	mov    0x8(%ebp),%eax
  801fbd:	8b 00                	mov    (%eax),%eax
  801fbf:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801fc2:	eb 19                	jmp    801fdd <find_block+0x29>
	{
		if(va==point->sva)
  801fc4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fc7:	8b 40 08             	mov    0x8(%eax),%eax
  801fca:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801fcd:	75 05                	jne    801fd4 <find_block+0x20>
		   return point;
  801fcf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fd2:	eb 36                	jmp    80200a <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801fd4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd7:	8b 40 08             	mov    0x8(%eax),%eax
  801fda:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801fdd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801fe1:	74 07                	je     801fea <find_block+0x36>
  801fe3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fe6:	8b 00                	mov    (%eax),%eax
  801fe8:	eb 05                	jmp    801fef <find_block+0x3b>
  801fea:	b8 00 00 00 00       	mov    $0x0,%eax
  801fef:	8b 55 08             	mov    0x8(%ebp),%edx
  801ff2:	89 42 08             	mov    %eax,0x8(%edx)
  801ff5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff8:	8b 40 08             	mov    0x8(%eax),%eax
  801ffb:	85 c0                	test   %eax,%eax
  801ffd:	75 c5                	jne    801fc4 <find_block+0x10>
  801fff:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802003:	75 bf                	jne    801fc4 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802005:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80200a:	c9                   	leave  
  80200b:	c3                   	ret    

0080200c <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80200c:	55                   	push   %ebp
  80200d:	89 e5                	mov    %esp,%ebp
  80200f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802012:	a1 40 50 80 00       	mov    0x805040,%eax
  802017:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  80201a:	a1 44 50 80 00       	mov    0x805044,%eax
  80201f:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802022:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802025:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802028:	74 24                	je     80204e <insert_sorted_allocList+0x42>
  80202a:	8b 45 08             	mov    0x8(%ebp),%eax
  80202d:	8b 50 08             	mov    0x8(%eax),%edx
  802030:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802033:	8b 40 08             	mov    0x8(%eax),%eax
  802036:	39 c2                	cmp    %eax,%edx
  802038:	76 14                	jbe    80204e <insert_sorted_allocList+0x42>
  80203a:	8b 45 08             	mov    0x8(%ebp),%eax
  80203d:	8b 50 08             	mov    0x8(%eax),%edx
  802040:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802043:	8b 40 08             	mov    0x8(%eax),%eax
  802046:	39 c2                	cmp    %eax,%edx
  802048:	0f 82 60 01 00 00    	jb     8021ae <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  80204e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802052:	75 65                	jne    8020b9 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802054:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802058:	75 14                	jne    80206e <insert_sorted_allocList+0x62>
  80205a:	83 ec 04             	sub    $0x4,%esp
  80205d:	68 fc 3f 80 00       	push   $0x803ffc
  802062:	6a 6b                	push   $0x6b
  802064:	68 1f 40 80 00       	push   $0x80401f
  802069:	e8 4f e2 ff ff       	call   8002bd <_panic>
  80206e:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802074:	8b 45 08             	mov    0x8(%ebp),%eax
  802077:	89 10                	mov    %edx,(%eax)
  802079:	8b 45 08             	mov    0x8(%ebp),%eax
  80207c:	8b 00                	mov    (%eax),%eax
  80207e:	85 c0                	test   %eax,%eax
  802080:	74 0d                	je     80208f <insert_sorted_allocList+0x83>
  802082:	a1 40 50 80 00       	mov    0x805040,%eax
  802087:	8b 55 08             	mov    0x8(%ebp),%edx
  80208a:	89 50 04             	mov    %edx,0x4(%eax)
  80208d:	eb 08                	jmp    802097 <insert_sorted_allocList+0x8b>
  80208f:	8b 45 08             	mov    0x8(%ebp),%eax
  802092:	a3 44 50 80 00       	mov    %eax,0x805044
  802097:	8b 45 08             	mov    0x8(%ebp),%eax
  80209a:	a3 40 50 80 00       	mov    %eax,0x805040
  80209f:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020a9:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8020ae:	40                   	inc    %eax
  8020af:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8020b4:	e9 dc 01 00 00       	jmp    802295 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8020b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bc:	8b 50 08             	mov    0x8(%eax),%edx
  8020bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020c2:	8b 40 08             	mov    0x8(%eax),%eax
  8020c5:	39 c2                	cmp    %eax,%edx
  8020c7:	77 6c                	ja     802135 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8020c9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020cd:	74 06                	je     8020d5 <insert_sorted_allocList+0xc9>
  8020cf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020d3:	75 14                	jne    8020e9 <insert_sorted_allocList+0xdd>
  8020d5:	83 ec 04             	sub    $0x4,%esp
  8020d8:	68 38 40 80 00       	push   $0x804038
  8020dd:	6a 6f                	push   $0x6f
  8020df:	68 1f 40 80 00       	push   $0x80401f
  8020e4:	e8 d4 e1 ff ff       	call   8002bd <_panic>
  8020e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020ec:	8b 50 04             	mov    0x4(%eax),%edx
  8020ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f2:	89 50 04             	mov    %edx,0x4(%eax)
  8020f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8020fb:	89 10                	mov    %edx,(%eax)
  8020fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802100:	8b 40 04             	mov    0x4(%eax),%eax
  802103:	85 c0                	test   %eax,%eax
  802105:	74 0d                	je     802114 <insert_sorted_allocList+0x108>
  802107:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80210a:	8b 40 04             	mov    0x4(%eax),%eax
  80210d:	8b 55 08             	mov    0x8(%ebp),%edx
  802110:	89 10                	mov    %edx,(%eax)
  802112:	eb 08                	jmp    80211c <insert_sorted_allocList+0x110>
  802114:	8b 45 08             	mov    0x8(%ebp),%eax
  802117:	a3 40 50 80 00       	mov    %eax,0x805040
  80211c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80211f:	8b 55 08             	mov    0x8(%ebp),%edx
  802122:	89 50 04             	mov    %edx,0x4(%eax)
  802125:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80212a:	40                   	inc    %eax
  80212b:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802130:	e9 60 01 00 00       	jmp    802295 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802135:	8b 45 08             	mov    0x8(%ebp),%eax
  802138:	8b 50 08             	mov    0x8(%eax),%edx
  80213b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80213e:	8b 40 08             	mov    0x8(%eax),%eax
  802141:	39 c2                	cmp    %eax,%edx
  802143:	0f 82 4c 01 00 00    	jb     802295 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802149:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80214d:	75 14                	jne    802163 <insert_sorted_allocList+0x157>
  80214f:	83 ec 04             	sub    $0x4,%esp
  802152:	68 70 40 80 00       	push   $0x804070
  802157:	6a 73                	push   $0x73
  802159:	68 1f 40 80 00       	push   $0x80401f
  80215e:	e8 5a e1 ff ff       	call   8002bd <_panic>
  802163:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802169:	8b 45 08             	mov    0x8(%ebp),%eax
  80216c:	89 50 04             	mov    %edx,0x4(%eax)
  80216f:	8b 45 08             	mov    0x8(%ebp),%eax
  802172:	8b 40 04             	mov    0x4(%eax),%eax
  802175:	85 c0                	test   %eax,%eax
  802177:	74 0c                	je     802185 <insert_sorted_allocList+0x179>
  802179:	a1 44 50 80 00       	mov    0x805044,%eax
  80217e:	8b 55 08             	mov    0x8(%ebp),%edx
  802181:	89 10                	mov    %edx,(%eax)
  802183:	eb 08                	jmp    80218d <insert_sorted_allocList+0x181>
  802185:	8b 45 08             	mov    0x8(%ebp),%eax
  802188:	a3 40 50 80 00       	mov    %eax,0x805040
  80218d:	8b 45 08             	mov    0x8(%ebp),%eax
  802190:	a3 44 50 80 00       	mov    %eax,0x805044
  802195:	8b 45 08             	mov    0x8(%ebp),%eax
  802198:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80219e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8021a3:	40                   	inc    %eax
  8021a4:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8021a9:	e9 e7 00 00 00       	jmp    802295 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8021ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8021b4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8021bb:	a1 40 50 80 00       	mov    0x805040,%eax
  8021c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021c3:	e9 9d 00 00 00       	jmp    802265 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8021c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021cb:	8b 00                	mov    (%eax),%eax
  8021cd:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8021d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d3:	8b 50 08             	mov    0x8(%eax),%edx
  8021d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d9:	8b 40 08             	mov    0x8(%eax),%eax
  8021dc:	39 c2                	cmp    %eax,%edx
  8021de:	76 7d                	jbe    80225d <insert_sorted_allocList+0x251>
  8021e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e3:	8b 50 08             	mov    0x8(%eax),%edx
  8021e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8021e9:	8b 40 08             	mov    0x8(%eax),%eax
  8021ec:	39 c2                	cmp    %eax,%edx
  8021ee:	73 6d                	jae    80225d <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8021f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021f4:	74 06                	je     8021fc <insert_sorted_allocList+0x1f0>
  8021f6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021fa:	75 14                	jne    802210 <insert_sorted_allocList+0x204>
  8021fc:	83 ec 04             	sub    $0x4,%esp
  8021ff:	68 94 40 80 00       	push   $0x804094
  802204:	6a 7f                	push   $0x7f
  802206:	68 1f 40 80 00       	push   $0x80401f
  80220b:	e8 ad e0 ff ff       	call   8002bd <_panic>
  802210:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802213:	8b 10                	mov    (%eax),%edx
  802215:	8b 45 08             	mov    0x8(%ebp),%eax
  802218:	89 10                	mov    %edx,(%eax)
  80221a:	8b 45 08             	mov    0x8(%ebp),%eax
  80221d:	8b 00                	mov    (%eax),%eax
  80221f:	85 c0                	test   %eax,%eax
  802221:	74 0b                	je     80222e <insert_sorted_allocList+0x222>
  802223:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802226:	8b 00                	mov    (%eax),%eax
  802228:	8b 55 08             	mov    0x8(%ebp),%edx
  80222b:	89 50 04             	mov    %edx,0x4(%eax)
  80222e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802231:	8b 55 08             	mov    0x8(%ebp),%edx
  802234:	89 10                	mov    %edx,(%eax)
  802236:	8b 45 08             	mov    0x8(%ebp),%eax
  802239:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80223c:	89 50 04             	mov    %edx,0x4(%eax)
  80223f:	8b 45 08             	mov    0x8(%ebp),%eax
  802242:	8b 00                	mov    (%eax),%eax
  802244:	85 c0                	test   %eax,%eax
  802246:	75 08                	jne    802250 <insert_sorted_allocList+0x244>
  802248:	8b 45 08             	mov    0x8(%ebp),%eax
  80224b:	a3 44 50 80 00       	mov    %eax,0x805044
  802250:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802255:	40                   	inc    %eax
  802256:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  80225b:	eb 39                	jmp    802296 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80225d:	a1 48 50 80 00       	mov    0x805048,%eax
  802262:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802265:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802269:	74 07                	je     802272 <insert_sorted_allocList+0x266>
  80226b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226e:	8b 00                	mov    (%eax),%eax
  802270:	eb 05                	jmp    802277 <insert_sorted_allocList+0x26b>
  802272:	b8 00 00 00 00       	mov    $0x0,%eax
  802277:	a3 48 50 80 00       	mov    %eax,0x805048
  80227c:	a1 48 50 80 00       	mov    0x805048,%eax
  802281:	85 c0                	test   %eax,%eax
  802283:	0f 85 3f ff ff ff    	jne    8021c8 <insert_sorted_allocList+0x1bc>
  802289:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80228d:	0f 85 35 ff ff ff    	jne    8021c8 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802293:	eb 01                	jmp    802296 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802295:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802296:	90                   	nop
  802297:	c9                   	leave  
  802298:	c3                   	ret    

00802299 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802299:	55                   	push   %ebp
  80229a:	89 e5                	mov    %esp,%ebp
  80229c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80229f:	a1 38 51 80 00       	mov    0x805138,%eax
  8022a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022a7:	e9 85 01 00 00       	jmp    802431 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8022ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022af:	8b 40 0c             	mov    0xc(%eax),%eax
  8022b2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022b5:	0f 82 6e 01 00 00    	jb     802429 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8022bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022be:	8b 40 0c             	mov    0xc(%eax),%eax
  8022c1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022c4:	0f 85 8a 00 00 00    	jne    802354 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8022ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022ce:	75 17                	jne    8022e7 <alloc_block_FF+0x4e>
  8022d0:	83 ec 04             	sub    $0x4,%esp
  8022d3:	68 c8 40 80 00       	push   $0x8040c8
  8022d8:	68 93 00 00 00       	push   $0x93
  8022dd:	68 1f 40 80 00       	push   $0x80401f
  8022e2:	e8 d6 df ff ff       	call   8002bd <_panic>
  8022e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ea:	8b 00                	mov    (%eax),%eax
  8022ec:	85 c0                	test   %eax,%eax
  8022ee:	74 10                	je     802300 <alloc_block_FF+0x67>
  8022f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f3:	8b 00                	mov    (%eax),%eax
  8022f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022f8:	8b 52 04             	mov    0x4(%edx),%edx
  8022fb:	89 50 04             	mov    %edx,0x4(%eax)
  8022fe:	eb 0b                	jmp    80230b <alloc_block_FF+0x72>
  802300:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802303:	8b 40 04             	mov    0x4(%eax),%eax
  802306:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80230b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230e:	8b 40 04             	mov    0x4(%eax),%eax
  802311:	85 c0                	test   %eax,%eax
  802313:	74 0f                	je     802324 <alloc_block_FF+0x8b>
  802315:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802318:	8b 40 04             	mov    0x4(%eax),%eax
  80231b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80231e:	8b 12                	mov    (%edx),%edx
  802320:	89 10                	mov    %edx,(%eax)
  802322:	eb 0a                	jmp    80232e <alloc_block_FF+0x95>
  802324:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802327:	8b 00                	mov    (%eax),%eax
  802329:	a3 38 51 80 00       	mov    %eax,0x805138
  80232e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802331:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802337:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802341:	a1 44 51 80 00       	mov    0x805144,%eax
  802346:	48                   	dec    %eax
  802347:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  80234c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234f:	e9 10 01 00 00       	jmp    802464 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802354:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802357:	8b 40 0c             	mov    0xc(%eax),%eax
  80235a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80235d:	0f 86 c6 00 00 00    	jbe    802429 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802363:	a1 48 51 80 00       	mov    0x805148,%eax
  802368:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  80236b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236e:	8b 50 08             	mov    0x8(%eax),%edx
  802371:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802374:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802377:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80237a:	8b 55 08             	mov    0x8(%ebp),%edx
  80237d:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802380:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802384:	75 17                	jne    80239d <alloc_block_FF+0x104>
  802386:	83 ec 04             	sub    $0x4,%esp
  802389:	68 c8 40 80 00       	push   $0x8040c8
  80238e:	68 9b 00 00 00       	push   $0x9b
  802393:	68 1f 40 80 00       	push   $0x80401f
  802398:	e8 20 df ff ff       	call   8002bd <_panic>
  80239d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023a0:	8b 00                	mov    (%eax),%eax
  8023a2:	85 c0                	test   %eax,%eax
  8023a4:	74 10                	je     8023b6 <alloc_block_FF+0x11d>
  8023a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023a9:	8b 00                	mov    (%eax),%eax
  8023ab:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023ae:	8b 52 04             	mov    0x4(%edx),%edx
  8023b1:	89 50 04             	mov    %edx,0x4(%eax)
  8023b4:	eb 0b                	jmp    8023c1 <alloc_block_FF+0x128>
  8023b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023b9:	8b 40 04             	mov    0x4(%eax),%eax
  8023bc:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8023c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023c4:	8b 40 04             	mov    0x4(%eax),%eax
  8023c7:	85 c0                	test   %eax,%eax
  8023c9:	74 0f                	je     8023da <alloc_block_FF+0x141>
  8023cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ce:	8b 40 04             	mov    0x4(%eax),%eax
  8023d1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023d4:	8b 12                	mov    (%edx),%edx
  8023d6:	89 10                	mov    %edx,(%eax)
  8023d8:	eb 0a                	jmp    8023e4 <alloc_block_FF+0x14b>
  8023da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023dd:	8b 00                	mov    (%eax),%eax
  8023df:	a3 48 51 80 00       	mov    %eax,0x805148
  8023e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023f0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023f7:	a1 54 51 80 00       	mov    0x805154,%eax
  8023fc:	48                   	dec    %eax
  8023fd:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802402:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802405:	8b 50 08             	mov    0x8(%eax),%edx
  802408:	8b 45 08             	mov    0x8(%ebp),%eax
  80240b:	01 c2                	add    %eax,%edx
  80240d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802410:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802413:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802416:	8b 40 0c             	mov    0xc(%eax),%eax
  802419:	2b 45 08             	sub    0x8(%ebp),%eax
  80241c:	89 c2                	mov    %eax,%edx
  80241e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802421:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802424:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802427:	eb 3b                	jmp    802464 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802429:	a1 40 51 80 00       	mov    0x805140,%eax
  80242e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802431:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802435:	74 07                	je     80243e <alloc_block_FF+0x1a5>
  802437:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243a:	8b 00                	mov    (%eax),%eax
  80243c:	eb 05                	jmp    802443 <alloc_block_FF+0x1aa>
  80243e:	b8 00 00 00 00       	mov    $0x0,%eax
  802443:	a3 40 51 80 00       	mov    %eax,0x805140
  802448:	a1 40 51 80 00       	mov    0x805140,%eax
  80244d:	85 c0                	test   %eax,%eax
  80244f:	0f 85 57 fe ff ff    	jne    8022ac <alloc_block_FF+0x13>
  802455:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802459:	0f 85 4d fe ff ff    	jne    8022ac <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  80245f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802464:	c9                   	leave  
  802465:	c3                   	ret    

00802466 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802466:	55                   	push   %ebp
  802467:	89 e5                	mov    %esp,%ebp
  802469:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  80246c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802473:	a1 38 51 80 00       	mov    0x805138,%eax
  802478:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80247b:	e9 df 00 00 00       	jmp    80255f <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802480:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802483:	8b 40 0c             	mov    0xc(%eax),%eax
  802486:	3b 45 08             	cmp    0x8(%ebp),%eax
  802489:	0f 82 c8 00 00 00    	jb     802557 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  80248f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802492:	8b 40 0c             	mov    0xc(%eax),%eax
  802495:	3b 45 08             	cmp    0x8(%ebp),%eax
  802498:	0f 85 8a 00 00 00    	jne    802528 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  80249e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024a2:	75 17                	jne    8024bb <alloc_block_BF+0x55>
  8024a4:	83 ec 04             	sub    $0x4,%esp
  8024a7:	68 c8 40 80 00       	push   $0x8040c8
  8024ac:	68 b7 00 00 00       	push   $0xb7
  8024b1:	68 1f 40 80 00       	push   $0x80401f
  8024b6:	e8 02 de ff ff       	call   8002bd <_panic>
  8024bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024be:	8b 00                	mov    (%eax),%eax
  8024c0:	85 c0                	test   %eax,%eax
  8024c2:	74 10                	je     8024d4 <alloc_block_BF+0x6e>
  8024c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c7:	8b 00                	mov    (%eax),%eax
  8024c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024cc:	8b 52 04             	mov    0x4(%edx),%edx
  8024cf:	89 50 04             	mov    %edx,0x4(%eax)
  8024d2:	eb 0b                	jmp    8024df <alloc_block_BF+0x79>
  8024d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d7:	8b 40 04             	mov    0x4(%eax),%eax
  8024da:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8024df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e2:	8b 40 04             	mov    0x4(%eax),%eax
  8024e5:	85 c0                	test   %eax,%eax
  8024e7:	74 0f                	je     8024f8 <alloc_block_BF+0x92>
  8024e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ec:	8b 40 04             	mov    0x4(%eax),%eax
  8024ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024f2:	8b 12                	mov    (%edx),%edx
  8024f4:	89 10                	mov    %edx,(%eax)
  8024f6:	eb 0a                	jmp    802502 <alloc_block_BF+0x9c>
  8024f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fb:	8b 00                	mov    (%eax),%eax
  8024fd:	a3 38 51 80 00       	mov    %eax,0x805138
  802502:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802505:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80250b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802515:	a1 44 51 80 00       	mov    0x805144,%eax
  80251a:	48                   	dec    %eax
  80251b:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802520:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802523:	e9 4d 01 00 00       	jmp    802675 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802528:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252b:	8b 40 0c             	mov    0xc(%eax),%eax
  80252e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802531:	76 24                	jbe    802557 <alloc_block_BF+0xf1>
  802533:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802536:	8b 40 0c             	mov    0xc(%eax),%eax
  802539:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80253c:	73 19                	jae    802557 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  80253e:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802545:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802548:	8b 40 0c             	mov    0xc(%eax),%eax
  80254b:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  80254e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802551:	8b 40 08             	mov    0x8(%eax),%eax
  802554:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802557:	a1 40 51 80 00       	mov    0x805140,%eax
  80255c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80255f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802563:	74 07                	je     80256c <alloc_block_BF+0x106>
  802565:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802568:	8b 00                	mov    (%eax),%eax
  80256a:	eb 05                	jmp    802571 <alloc_block_BF+0x10b>
  80256c:	b8 00 00 00 00       	mov    $0x0,%eax
  802571:	a3 40 51 80 00       	mov    %eax,0x805140
  802576:	a1 40 51 80 00       	mov    0x805140,%eax
  80257b:	85 c0                	test   %eax,%eax
  80257d:	0f 85 fd fe ff ff    	jne    802480 <alloc_block_BF+0x1a>
  802583:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802587:	0f 85 f3 fe ff ff    	jne    802480 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  80258d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802591:	0f 84 d9 00 00 00    	je     802670 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802597:	a1 48 51 80 00       	mov    0x805148,%eax
  80259c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  80259f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025a2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025a5:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8025a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8025ae:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8025b1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8025b5:	75 17                	jne    8025ce <alloc_block_BF+0x168>
  8025b7:	83 ec 04             	sub    $0x4,%esp
  8025ba:	68 c8 40 80 00       	push   $0x8040c8
  8025bf:	68 c7 00 00 00       	push   $0xc7
  8025c4:	68 1f 40 80 00       	push   $0x80401f
  8025c9:	e8 ef dc ff ff       	call   8002bd <_panic>
  8025ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025d1:	8b 00                	mov    (%eax),%eax
  8025d3:	85 c0                	test   %eax,%eax
  8025d5:	74 10                	je     8025e7 <alloc_block_BF+0x181>
  8025d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025da:	8b 00                	mov    (%eax),%eax
  8025dc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025df:	8b 52 04             	mov    0x4(%edx),%edx
  8025e2:	89 50 04             	mov    %edx,0x4(%eax)
  8025e5:	eb 0b                	jmp    8025f2 <alloc_block_BF+0x18c>
  8025e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025ea:	8b 40 04             	mov    0x4(%eax),%eax
  8025ed:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8025f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025f5:	8b 40 04             	mov    0x4(%eax),%eax
  8025f8:	85 c0                	test   %eax,%eax
  8025fa:	74 0f                	je     80260b <alloc_block_BF+0x1a5>
  8025fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025ff:	8b 40 04             	mov    0x4(%eax),%eax
  802602:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802605:	8b 12                	mov    (%edx),%edx
  802607:	89 10                	mov    %edx,(%eax)
  802609:	eb 0a                	jmp    802615 <alloc_block_BF+0x1af>
  80260b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80260e:	8b 00                	mov    (%eax),%eax
  802610:	a3 48 51 80 00       	mov    %eax,0x805148
  802615:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802618:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80261e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802621:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802628:	a1 54 51 80 00       	mov    0x805154,%eax
  80262d:	48                   	dec    %eax
  80262e:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802633:	83 ec 08             	sub    $0x8,%esp
  802636:	ff 75 ec             	pushl  -0x14(%ebp)
  802639:	68 38 51 80 00       	push   $0x805138
  80263e:	e8 71 f9 ff ff       	call   801fb4 <find_block>
  802643:	83 c4 10             	add    $0x10,%esp
  802646:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802649:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80264c:	8b 50 08             	mov    0x8(%eax),%edx
  80264f:	8b 45 08             	mov    0x8(%ebp),%eax
  802652:	01 c2                	add    %eax,%edx
  802654:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802657:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  80265a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80265d:	8b 40 0c             	mov    0xc(%eax),%eax
  802660:	2b 45 08             	sub    0x8(%ebp),%eax
  802663:	89 c2                	mov    %eax,%edx
  802665:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802668:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  80266b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80266e:	eb 05                	jmp    802675 <alloc_block_BF+0x20f>
	}
	return NULL;
  802670:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802675:	c9                   	leave  
  802676:	c3                   	ret    

00802677 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802677:	55                   	push   %ebp
  802678:	89 e5                	mov    %esp,%ebp
  80267a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  80267d:	a1 28 50 80 00       	mov    0x805028,%eax
  802682:	85 c0                	test   %eax,%eax
  802684:	0f 85 de 01 00 00    	jne    802868 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80268a:	a1 38 51 80 00       	mov    0x805138,%eax
  80268f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802692:	e9 9e 01 00 00       	jmp    802835 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802697:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269a:	8b 40 0c             	mov    0xc(%eax),%eax
  80269d:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026a0:	0f 82 87 01 00 00    	jb     80282d <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8026a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8026ac:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026af:	0f 85 95 00 00 00    	jne    80274a <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8026b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026b9:	75 17                	jne    8026d2 <alloc_block_NF+0x5b>
  8026bb:	83 ec 04             	sub    $0x4,%esp
  8026be:	68 c8 40 80 00       	push   $0x8040c8
  8026c3:	68 e0 00 00 00       	push   $0xe0
  8026c8:	68 1f 40 80 00       	push   $0x80401f
  8026cd:	e8 eb db ff ff       	call   8002bd <_panic>
  8026d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d5:	8b 00                	mov    (%eax),%eax
  8026d7:	85 c0                	test   %eax,%eax
  8026d9:	74 10                	je     8026eb <alloc_block_NF+0x74>
  8026db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026de:	8b 00                	mov    (%eax),%eax
  8026e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026e3:	8b 52 04             	mov    0x4(%edx),%edx
  8026e6:	89 50 04             	mov    %edx,0x4(%eax)
  8026e9:	eb 0b                	jmp    8026f6 <alloc_block_NF+0x7f>
  8026eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ee:	8b 40 04             	mov    0x4(%eax),%eax
  8026f1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8026f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f9:	8b 40 04             	mov    0x4(%eax),%eax
  8026fc:	85 c0                	test   %eax,%eax
  8026fe:	74 0f                	je     80270f <alloc_block_NF+0x98>
  802700:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802703:	8b 40 04             	mov    0x4(%eax),%eax
  802706:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802709:	8b 12                	mov    (%edx),%edx
  80270b:	89 10                	mov    %edx,(%eax)
  80270d:	eb 0a                	jmp    802719 <alloc_block_NF+0xa2>
  80270f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802712:	8b 00                	mov    (%eax),%eax
  802714:	a3 38 51 80 00       	mov    %eax,0x805138
  802719:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802722:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802725:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80272c:	a1 44 51 80 00       	mov    0x805144,%eax
  802731:	48                   	dec    %eax
  802732:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802737:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273a:	8b 40 08             	mov    0x8(%eax),%eax
  80273d:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802742:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802745:	e9 f8 04 00 00       	jmp    802c42 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  80274a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274d:	8b 40 0c             	mov    0xc(%eax),%eax
  802750:	3b 45 08             	cmp    0x8(%ebp),%eax
  802753:	0f 86 d4 00 00 00    	jbe    80282d <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802759:	a1 48 51 80 00       	mov    0x805148,%eax
  80275e:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802761:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802764:	8b 50 08             	mov    0x8(%eax),%edx
  802767:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80276a:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  80276d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802770:	8b 55 08             	mov    0x8(%ebp),%edx
  802773:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802776:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80277a:	75 17                	jne    802793 <alloc_block_NF+0x11c>
  80277c:	83 ec 04             	sub    $0x4,%esp
  80277f:	68 c8 40 80 00       	push   $0x8040c8
  802784:	68 e9 00 00 00       	push   $0xe9
  802789:	68 1f 40 80 00       	push   $0x80401f
  80278e:	e8 2a db ff ff       	call   8002bd <_panic>
  802793:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802796:	8b 00                	mov    (%eax),%eax
  802798:	85 c0                	test   %eax,%eax
  80279a:	74 10                	je     8027ac <alloc_block_NF+0x135>
  80279c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80279f:	8b 00                	mov    (%eax),%eax
  8027a1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027a4:	8b 52 04             	mov    0x4(%edx),%edx
  8027a7:	89 50 04             	mov    %edx,0x4(%eax)
  8027aa:	eb 0b                	jmp    8027b7 <alloc_block_NF+0x140>
  8027ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027af:	8b 40 04             	mov    0x4(%eax),%eax
  8027b2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8027b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ba:	8b 40 04             	mov    0x4(%eax),%eax
  8027bd:	85 c0                	test   %eax,%eax
  8027bf:	74 0f                	je     8027d0 <alloc_block_NF+0x159>
  8027c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c4:	8b 40 04             	mov    0x4(%eax),%eax
  8027c7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027ca:	8b 12                	mov    (%edx),%edx
  8027cc:	89 10                	mov    %edx,(%eax)
  8027ce:	eb 0a                	jmp    8027da <alloc_block_NF+0x163>
  8027d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027d3:	8b 00                	mov    (%eax),%eax
  8027d5:	a3 48 51 80 00       	mov    %eax,0x805148
  8027da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027ed:	a1 54 51 80 00       	mov    0x805154,%eax
  8027f2:	48                   	dec    %eax
  8027f3:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  8027f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027fb:	8b 40 08             	mov    0x8(%eax),%eax
  8027fe:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802803:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802806:	8b 50 08             	mov    0x8(%eax),%edx
  802809:	8b 45 08             	mov    0x8(%ebp),%eax
  80280c:	01 c2                	add    %eax,%edx
  80280e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802811:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802814:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802817:	8b 40 0c             	mov    0xc(%eax),%eax
  80281a:	2b 45 08             	sub    0x8(%ebp),%eax
  80281d:	89 c2                	mov    %eax,%edx
  80281f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802822:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802825:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802828:	e9 15 04 00 00       	jmp    802c42 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80282d:	a1 40 51 80 00       	mov    0x805140,%eax
  802832:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802835:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802839:	74 07                	je     802842 <alloc_block_NF+0x1cb>
  80283b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283e:	8b 00                	mov    (%eax),%eax
  802840:	eb 05                	jmp    802847 <alloc_block_NF+0x1d0>
  802842:	b8 00 00 00 00       	mov    $0x0,%eax
  802847:	a3 40 51 80 00       	mov    %eax,0x805140
  80284c:	a1 40 51 80 00       	mov    0x805140,%eax
  802851:	85 c0                	test   %eax,%eax
  802853:	0f 85 3e fe ff ff    	jne    802697 <alloc_block_NF+0x20>
  802859:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80285d:	0f 85 34 fe ff ff    	jne    802697 <alloc_block_NF+0x20>
  802863:	e9 d5 03 00 00       	jmp    802c3d <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802868:	a1 38 51 80 00       	mov    0x805138,%eax
  80286d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802870:	e9 b1 01 00 00       	jmp    802a26 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802875:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802878:	8b 50 08             	mov    0x8(%eax),%edx
  80287b:	a1 28 50 80 00       	mov    0x805028,%eax
  802880:	39 c2                	cmp    %eax,%edx
  802882:	0f 82 96 01 00 00    	jb     802a1e <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802888:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288b:	8b 40 0c             	mov    0xc(%eax),%eax
  80288e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802891:	0f 82 87 01 00 00    	jb     802a1e <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802897:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289a:	8b 40 0c             	mov    0xc(%eax),%eax
  80289d:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028a0:	0f 85 95 00 00 00    	jne    80293b <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8028a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028aa:	75 17                	jne    8028c3 <alloc_block_NF+0x24c>
  8028ac:	83 ec 04             	sub    $0x4,%esp
  8028af:	68 c8 40 80 00       	push   $0x8040c8
  8028b4:	68 fc 00 00 00       	push   $0xfc
  8028b9:	68 1f 40 80 00       	push   $0x80401f
  8028be:	e8 fa d9 ff ff       	call   8002bd <_panic>
  8028c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c6:	8b 00                	mov    (%eax),%eax
  8028c8:	85 c0                	test   %eax,%eax
  8028ca:	74 10                	je     8028dc <alloc_block_NF+0x265>
  8028cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cf:	8b 00                	mov    (%eax),%eax
  8028d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028d4:	8b 52 04             	mov    0x4(%edx),%edx
  8028d7:	89 50 04             	mov    %edx,0x4(%eax)
  8028da:	eb 0b                	jmp    8028e7 <alloc_block_NF+0x270>
  8028dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028df:	8b 40 04             	mov    0x4(%eax),%eax
  8028e2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8028e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ea:	8b 40 04             	mov    0x4(%eax),%eax
  8028ed:	85 c0                	test   %eax,%eax
  8028ef:	74 0f                	je     802900 <alloc_block_NF+0x289>
  8028f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f4:	8b 40 04             	mov    0x4(%eax),%eax
  8028f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028fa:	8b 12                	mov    (%edx),%edx
  8028fc:	89 10                	mov    %edx,(%eax)
  8028fe:	eb 0a                	jmp    80290a <alloc_block_NF+0x293>
  802900:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802903:	8b 00                	mov    (%eax),%eax
  802905:	a3 38 51 80 00       	mov    %eax,0x805138
  80290a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802913:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802916:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80291d:	a1 44 51 80 00       	mov    0x805144,%eax
  802922:	48                   	dec    %eax
  802923:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802928:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292b:	8b 40 08             	mov    0x8(%eax),%eax
  80292e:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802933:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802936:	e9 07 03 00 00       	jmp    802c42 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  80293b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293e:	8b 40 0c             	mov    0xc(%eax),%eax
  802941:	3b 45 08             	cmp    0x8(%ebp),%eax
  802944:	0f 86 d4 00 00 00    	jbe    802a1e <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80294a:	a1 48 51 80 00       	mov    0x805148,%eax
  80294f:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802952:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802955:	8b 50 08             	mov    0x8(%eax),%edx
  802958:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80295b:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  80295e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802961:	8b 55 08             	mov    0x8(%ebp),%edx
  802964:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802967:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80296b:	75 17                	jne    802984 <alloc_block_NF+0x30d>
  80296d:	83 ec 04             	sub    $0x4,%esp
  802970:	68 c8 40 80 00       	push   $0x8040c8
  802975:	68 04 01 00 00       	push   $0x104
  80297a:	68 1f 40 80 00       	push   $0x80401f
  80297f:	e8 39 d9 ff ff       	call   8002bd <_panic>
  802984:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802987:	8b 00                	mov    (%eax),%eax
  802989:	85 c0                	test   %eax,%eax
  80298b:	74 10                	je     80299d <alloc_block_NF+0x326>
  80298d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802990:	8b 00                	mov    (%eax),%eax
  802992:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802995:	8b 52 04             	mov    0x4(%edx),%edx
  802998:	89 50 04             	mov    %edx,0x4(%eax)
  80299b:	eb 0b                	jmp    8029a8 <alloc_block_NF+0x331>
  80299d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029a0:	8b 40 04             	mov    0x4(%eax),%eax
  8029a3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8029a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029ab:	8b 40 04             	mov    0x4(%eax),%eax
  8029ae:	85 c0                	test   %eax,%eax
  8029b0:	74 0f                	je     8029c1 <alloc_block_NF+0x34a>
  8029b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029b5:	8b 40 04             	mov    0x4(%eax),%eax
  8029b8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8029bb:	8b 12                	mov    (%edx),%edx
  8029bd:	89 10                	mov    %edx,(%eax)
  8029bf:	eb 0a                	jmp    8029cb <alloc_block_NF+0x354>
  8029c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029c4:	8b 00                	mov    (%eax),%eax
  8029c6:	a3 48 51 80 00       	mov    %eax,0x805148
  8029cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029d7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029de:	a1 54 51 80 00       	mov    0x805154,%eax
  8029e3:	48                   	dec    %eax
  8029e4:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  8029e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029ec:	8b 40 08             	mov    0x8(%eax),%eax
  8029ef:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  8029f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f7:	8b 50 08             	mov    0x8(%eax),%edx
  8029fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8029fd:	01 c2                	add    %eax,%edx
  8029ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a02:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802a05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a08:	8b 40 0c             	mov    0xc(%eax),%eax
  802a0b:	2b 45 08             	sub    0x8(%ebp),%eax
  802a0e:	89 c2                	mov    %eax,%edx
  802a10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a13:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802a16:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a19:	e9 24 02 00 00       	jmp    802c42 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a1e:	a1 40 51 80 00       	mov    0x805140,%eax
  802a23:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a26:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a2a:	74 07                	je     802a33 <alloc_block_NF+0x3bc>
  802a2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2f:	8b 00                	mov    (%eax),%eax
  802a31:	eb 05                	jmp    802a38 <alloc_block_NF+0x3c1>
  802a33:	b8 00 00 00 00       	mov    $0x0,%eax
  802a38:	a3 40 51 80 00       	mov    %eax,0x805140
  802a3d:	a1 40 51 80 00       	mov    0x805140,%eax
  802a42:	85 c0                	test   %eax,%eax
  802a44:	0f 85 2b fe ff ff    	jne    802875 <alloc_block_NF+0x1fe>
  802a4a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a4e:	0f 85 21 fe ff ff    	jne    802875 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a54:	a1 38 51 80 00       	mov    0x805138,%eax
  802a59:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a5c:	e9 ae 01 00 00       	jmp    802c0f <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802a61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a64:	8b 50 08             	mov    0x8(%eax),%edx
  802a67:	a1 28 50 80 00       	mov    0x805028,%eax
  802a6c:	39 c2                	cmp    %eax,%edx
  802a6e:	0f 83 93 01 00 00    	jae    802c07 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802a74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a77:	8b 40 0c             	mov    0xc(%eax),%eax
  802a7a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a7d:	0f 82 84 01 00 00    	jb     802c07 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802a83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a86:	8b 40 0c             	mov    0xc(%eax),%eax
  802a89:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a8c:	0f 85 95 00 00 00    	jne    802b27 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802a92:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a96:	75 17                	jne    802aaf <alloc_block_NF+0x438>
  802a98:	83 ec 04             	sub    $0x4,%esp
  802a9b:	68 c8 40 80 00       	push   $0x8040c8
  802aa0:	68 14 01 00 00       	push   $0x114
  802aa5:	68 1f 40 80 00       	push   $0x80401f
  802aaa:	e8 0e d8 ff ff       	call   8002bd <_panic>
  802aaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab2:	8b 00                	mov    (%eax),%eax
  802ab4:	85 c0                	test   %eax,%eax
  802ab6:	74 10                	je     802ac8 <alloc_block_NF+0x451>
  802ab8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abb:	8b 00                	mov    (%eax),%eax
  802abd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ac0:	8b 52 04             	mov    0x4(%edx),%edx
  802ac3:	89 50 04             	mov    %edx,0x4(%eax)
  802ac6:	eb 0b                	jmp    802ad3 <alloc_block_NF+0x45c>
  802ac8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acb:	8b 40 04             	mov    0x4(%eax),%eax
  802ace:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ad3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad6:	8b 40 04             	mov    0x4(%eax),%eax
  802ad9:	85 c0                	test   %eax,%eax
  802adb:	74 0f                	je     802aec <alloc_block_NF+0x475>
  802add:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae0:	8b 40 04             	mov    0x4(%eax),%eax
  802ae3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ae6:	8b 12                	mov    (%edx),%edx
  802ae8:	89 10                	mov    %edx,(%eax)
  802aea:	eb 0a                	jmp    802af6 <alloc_block_NF+0x47f>
  802aec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aef:	8b 00                	mov    (%eax),%eax
  802af1:	a3 38 51 80 00       	mov    %eax,0x805138
  802af6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802aff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b02:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b09:	a1 44 51 80 00       	mov    0x805144,%eax
  802b0e:	48                   	dec    %eax
  802b0f:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802b14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b17:	8b 40 08             	mov    0x8(%eax),%eax
  802b1a:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802b1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b22:	e9 1b 01 00 00       	jmp    802c42 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802b27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2a:	8b 40 0c             	mov    0xc(%eax),%eax
  802b2d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b30:	0f 86 d1 00 00 00    	jbe    802c07 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b36:	a1 48 51 80 00       	mov    0x805148,%eax
  802b3b:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802b3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b41:	8b 50 08             	mov    0x8(%eax),%edx
  802b44:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b47:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802b4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b4d:	8b 55 08             	mov    0x8(%ebp),%edx
  802b50:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b53:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b57:	75 17                	jne    802b70 <alloc_block_NF+0x4f9>
  802b59:	83 ec 04             	sub    $0x4,%esp
  802b5c:	68 c8 40 80 00       	push   $0x8040c8
  802b61:	68 1c 01 00 00       	push   $0x11c
  802b66:	68 1f 40 80 00       	push   $0x80401f
  802b6b:	e8 4d d7 ff ff       	call   8002bd <_panic>
  802b70:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b73:	8b 00                	mov    (%eax),%eax
  802b75:	85 c0                	test   %eax,%eax
  802b77:	74 10                	je     802b89 <alloc_block_NF+0x512>
  802b79:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b7c:	8b 00                	mov    (%eax),%eax
  802b7e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b81:	8b 52 04             	mov    0x4(%edx),%edx
  802b84:	89 50 04             	mov    %edx,0x4(%eax)
  802b87:	eb 0b                	jmp    802b94 <alloc_block_NF+0x51d>
  802b89:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b8c:	8b 40 04             	mov    0x4(%eax),%eax
  802b8f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b94:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b97:	8b 40 04             	mov    0x4(%eax),%eax
  802b9a:	85 c0                	test   %eax,%eax
  802b9c:	74 0f                	je     802bad <alloc_block_NF+0x536>
  802b9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ba1:	8b 40 04             	mov    0x4(%eax),%eax
  802ba4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ba7:	8b 12                	mov    (%edx),%edx
  802ba9:	89 10                	mov    %edx,(%eax)
  802bab:	eb 0a                	jmp    802bb7 <alloc_block_NF+0x540>
  802bad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bb0:	8b 00                	mov    (%eax),%eax
  802bb2:	a3 48 51 80 00       	mov    %eax,0x805148
  802bb7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bc0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bc3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bca:	a1 54 51 80 00       	mov    0x805154,%eax
  802bcf:	48                   	dec    %eax
  802bd0:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802bd5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bd8:	8b 40 08             	mov    0x8(%eax),%eax
  802bdb:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802be0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be3:	8b 50 08             	mov    0x8(%eax),%edx
  802be6:	8b 45 08             	mov    0x8(%ebp),%eax
  802be9:	01 c2                	add    %eax,%edx
  802beb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bee:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802bf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf4:	8b 40 0c             	mov    0xc(%eax),%eax
  802bf7:	2b 45 08             	sub    0x8(%ebp),%eax
  802bfa:	89 c2                	mov    %eax,%edx
  802bfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bff:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802c02:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c05:	eb 3b                	jmp    802c42 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c07:	a1 40 51 80 00       	mov    0x805140,%eax
  802c0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c0f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c13:	74 07                	je     802c1c <alloc_block_NF+0x5a5>
  802c15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c18:	8b 00                	mov    (%eax),%eax
  802c1a:	eb 05                	jmp    802c21 <alloc_block_NF+0x5aa>
  802c1c:	b8 00 00 00 00       	mov    $0x0,%eax
  802c21:	a3 40 51 80 00       	mov    %eax,0x805140
  802c26:	a1 40 51 80 00       	mov    0x805140,%eax
  802c2b:	85 c0                	test   %eax,%eax
  802c2d:	0f 85 2e fe ff ff    	jne    802a61 <alloc_block_NF+0x3ea>
  802c33:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c37:	0f 85 24 fe ff ff    	jne    802a61 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802c3d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c42:	c9                   	leave  
  802c43:	c3                   	ret    

00802c44 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802c44:	55                   	push   %ebp
  802c45:	89 e5                	mov    %esp,%ebp
  802c47:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802c4a:	a1 38 51 80 00       	mov    0x805138,%eax
  802c4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802c52:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802c57:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802c5a:	a1 38 51 80 00       	mov    0x805138,%eax
  802c5f:	85 c0                	test   %eax,%eax
  802c61:	74 14                	je     802c77 <insert_sorted_with_merge_freeList+0x33>
  802c63:	8b 45 08             	mov    0x8(%ebp),%eax
  802c66:	8b 50 08             	mov    0x8(%eax),%edx
  802c69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c6c:	8b 40 08             	mov    0x8(%eax),%eax
  802c6f:	39 c2                	cmp    %eax,%edx
  802c71:	0f 87 9b 01 00 00    	ja     802e12 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802c77:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c7b:	75 17                	jne    802c94 <insert_sorted_with_merge_freeList+0x50>
  802c7d:	83 ec 04             	sub    $0x4,%esp
  802c80:	68 fc 3f 80 00       	push   $0x803ffc
  802c85:	68 38 01 00 00       	push   $0x138
  802c8a:	68 1f 40 80 00       	push   $0x80401f
  802c8f:	e8 29 d6 ff ff       	call   8002bd <_panic>
  802c94:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802c9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9d:	89 10                	mov    %edx,(%eax)
  802c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca2:	8b 00                	mov    (%eax),%eax
  802ca4:	85 c0                	test   %eax,%eax
  802ca6:	74 0d                	je     802cb5 <insert_sorted_with_merge_freeList+0x71>
  802ca8:	a1 38 51 80 00       	mov    0x805138,%eax
  802cad:	8b 55 08             	mov    0x8(%ebp),%edx
  802cb0:	89 50 04             	mov    %edx,0x4(%eax)
  802cb3:	eb 08                	jmp    802cbd <insert_sorted_with_merge_freeList+0x79>
  802cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc0:	a3 38 51 80 00       	mov    %eax,0x805138
  802cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ccf:	a1 44 51 80 00       	mov    0x805144,%eax
  802cd4:	40                   	inc    %eax
  802cd5:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802cda:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cde:	0f 84 a8 06 00 00    	je     80338c <insert_sorted_with_merge_freeList+0x748>
  802ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce7:	8b 50 08             	mov    0x8(%eax),%edx
  802cea:	8b 45 08             	mov    0x8(%ebp),%eax
  802ced:	8b 40 0c             	mov    0xc(%eax),%eax
  802cf0:	01 c2                	add    %eax,%edx
  802cf2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf5:	8b 40 08             	mov    0x8(%eax),%eax
  802cf8:	39 c2                	cmp    %eax,%edx
  802cfa:	0f 85 8c 06 00 00    	jne    80338c <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802d00:	8b 45 08             	mov    0x8(%ebp),%eax
  802d03:	8b 50 0c             	mov    0xc(%eax),%edx
  802d06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d09:	8b 40 0c             	mov    0xc(%eax),%eax
  802d0c:	01 c2                	add    %eax,%edx
  802d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d11:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802d14:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d18:	75 17                	jne    802d31 <insert_sorted_with_merge_freeList+0xed>
  802d1a:	83 ec 04             	sub    $0x4,%esp
  802d1d:	68 c8 40 80 00       	push   $0x8040c8
  802d22:	68 3c 01 00 00       	push   $0x13c
  802d27:	68 1f 40 80 00       	push   $0x80401f
  802d2c:	e8 8c d5 ff ff       	call   8002bd <_panic>
  802d31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d34:	8b 00                	mov    (%eax),%eax
  802d36:	85 c0                	test   %eax,%eax
  802d38:	74 10                	je     802d4a <insert_sorted_with_merge_freeList+0x106>
  802d3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d3d:	8b 00                	mov    (%eax),%eax
  802d3f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d42:	8b 52 04             	mov    0x4(%edx),%edx
  802d45:	89 50 04             	mov    %edx,0x4(%eax)
  802d48:	eb 0b                	jmp    802d55 <insert_sorted_with_merge_freeList+0x111>
  802d4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d4d:	8b 40 04             	mov    0x4(%eax),%eax
  802d50:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d58:	8b 40 04             	mov    0x4(%eax),%eax
  802d5b:	85 c0                	test   %eax,%eax
  802d5d:	74 0f                	je     802d6e <insert_sorted_with_merge_freeList+0x12a>
  802d5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d62:	8b 40 04             	mov    0x4(%eax),%eax
  802d65:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d68:	8b 12                	mov    (%edx),%edx
  802d6a:	89 10                	mov    %edx,(%eax)
  802d6c:	eb 0a                	jmp    802d78 <insert_sorted_with_merge_freeList+0x134>
  802d6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d71:	8b 00                	mov    (%eax),%eax
  802d73:	a3 38 51 80 00       	mov    %eax,0x805138
  802d78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d7b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d84:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d8b:	a1 44 51 80 00       	mov    0x805144,%eax
  802d90:	48                   	dec    %eax
  802d91:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802d96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d99:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802da0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802daa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802dae:	75 17                	jne    802dc7 <insert_sorted_with_merge_freeList+0x183>
  802db0:	83 ec 04             	sub    $0x4,%esp
  802db3:	68 fc 3f 80 00       	push   $0x803ffc
  802db8:	68 3f 01 00 00       	push   $0x13f
  802dbd:	68 1f 40 80 00       	push   $0x80401f
  802dc2:	e8 f6 d4 ff ff       	call   8002bd <_panic>
  802dc7:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802dcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dd0:	89 10                	mov    %edx,(%eax)
  802dd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dd5:	8b 00                	mov    (%eax),%eax
  802dd7:	85 c0                	test   %eax,%eax
  802dd9:	74 0d                	je     802de8 <insert_sorted_with_merge_freeList+0x1a4>
  802ddb:	a1 48 51 80 00       	mov    0x805148,%eax
  802de0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802de3:	89 50 04             	mov    %edx,0x4(%eax)
  802de6:	eb 08                	jmp    802df0 <insert_sorted_with_merge_freeList+0x1ac>
  802de8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802deb:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802df0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df3:	a3 48 51 80 00       	mov    %eax,0x805148
  802df8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dfb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e02:	a1 54 51 80 00       	mov    0x805154,%eax
  802e07:	40                   	inc    %eax
  802e08:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802e0d:	e9 7a 05 00 00       	jmp    80338c <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802e12:	8b 45 08             	mov    0x8(%ebp),%eax
  802e15:	8b 50 08             	mov    0x8(%eax),%edx
  802e18:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e1b:	8b 40 08             	mov    0x8(%eax),%eax
  802e1e:	39 c2                	cmp    %eax,%edx
  802e20:	0f 82 14 01 00 00    	jb     802f3a <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802e26:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e29:	8b 50 08             	mov    0x8(%eax),%edx
  802e2c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e2f:	8b 40 0c             	mov    0xc(%eax),%eax
  802e32:	01 c2                	add    %eax,%edx
  802e34:	8b 45 08             	mov    0x8(%ebp),%eax
  802e37:	8b 40 08             	mov    0x8(%eax),%eax
  802e3a:	39 c2                	cmp    %eax,%edx
  802e3c:	0f 85 90 00 00 00    	jne    802ed2 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802e42:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e45:	8b 50 0c             	mov    0xc(%eax),%edx
  802e48:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4b:	8b 40 0c             	mov    0xc(%eax),%eax
  802e4e:	01 c2                	add    %eax,%edx
  802e50:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e53:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802e56:	8b 45 08             	mov    0x8(%ebp),%eax
  802e59:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802e60:	8b 45 08             	mov    0x8(%ebp),%eax
  802e63:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802e6a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e6e:	75 17                	jne    802e87 <insert_sorted_with_merge_freeList+0x243>
  802e70:	83 ec 04             	sub    $0x4,%esp
  802e73:	68 fc 3f 80 00       	push   $0x803ffc
  802e78:	68 49 01 00 00       	push   $0x149
  802e7d:	68 1f 40 80 00       	push   $0x80401f
  802e82:	e8 36 d4 ff ff       	call   8002bd <_panic>
  802e87:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802e8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e90:	89 10                	mov    %edx,(%eax)
  802e92:	8b 45 08             	mov    0x8(%ebp),%eax
  802e95:	8b 00                	mov    (%eax),%eax
  802e97:	85 c0                	test   %eax,%eax
  802e99:	74 0d                	je     802ea8 <insert_sorted_with_merge_freeList+0x264>
  802e9b:	a1 48 51 80 00       	mov    0x805148,%eax
  802ea0:	8b 55 08             	mov    0x8(%ebp),%edx
  802ea3:	89 50 04             	mov    %edx,0x4(%eax)
  802ea6:	eb 08                	jmp    802eb0 <insert_sorted_with_merge_freeList+0x26c>
  802ea8:	8b 45 08             	mov    0x8(%ebp),%eax
  802eab:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb3:	a3 48 51 80 00       	mov    %eax,0x805148
  802eb8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ec2:	a1 54 51 80 00       	mov    0x805154,%eax
  802ec7:	40                   	inc    %eax
  802ec8:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802ecd:	e9 bb 04 00 00       	jmp    80338d <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802ed2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ed6:	75 17                	jne    802eef <insert_sorted_with_merge_freeList+0x2ab>
  802ed8:	83 ec 04             	sub    $0x4,%esp
  802edb:	68 70 40 80 00       	push   $0x804070
  802ee0:	68 4c 01 00 00       	push   $0x14c
  802ee5:	68 1f 40 80 00       	push   $0x80401f
  802eea:	e8 ce d3 ff ff       	call   8002bd <_panic>
  802eef:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802ef5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef8:	89 50 04             	mov    %edx,0x4(%eax)
  802efb:	8b 45 08             	mov    0x8(%ebp),%eax
  802efe:	8b 40 04             	mov    0x4(%eax),%eax
  802f01:	85 c0                	test   %eax,%eax
  802f03:	74 0c                	je     802f11 <insert_sorted_with_merge_freeList+0x2cd>
  802f05:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f0a:	8b 55 08             	mov    0x8(%ebp),%edx
  802f0d:	89 10                	mov    %edx,(%eax)
  802f0f:	eb 08                	jmp    802f19 <insert_sorted_with_merge_freeList+0x2d5>
  802f11:	8b 45 08             	mov    0x8(%ebp),%eax
  802f14:	a3 38 51 80 00       	mov    %eax,0x805138
  802f19:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f21:	8b 45 08             	mov    0x8(%ebp),%eax
  802f24:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f2a:	a1 44 51 80 00       	mov    0x805144,%eax
  802f2f:	40                   	inc    %eax
  802f30:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802f35:	e9 53 04 00 00       	jmp    80338d <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802f3a:	a1 38 51 80 00       	mov    0x805138,%eax
  802f3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f42:	e9 15 04 00 00       	jmp    80335c <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802f47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4a:	8b 00                	mov    (%eax),%eax
  802f4c:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f52:	8b 50 08             	mov    0x8(%eax),%edx
  802f55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f58:	8b 40 08             	mov    0x8(%eax),%eax
  802f5b:	39 c2                	cmp    %eax,%edx
  802f5d:	0f 86 f1 03 00 00    	jbe    803354 <insert_sorted_with_merge_freeList+0x710>
  802f63:	8b 45 08             	mov    0x8(%ebp),%eax
  802f66:	8b 50 08             	mov    0x8(%eax),%edx
  802f69:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f6c:	8b 40 08             	mov    0x8(%eax),%eax
  802f6f:	39 c2                	cmp    %eax,%edx
  802f71:	0f 83 dd 03 00 00    	jae    803354 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802f77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7a:	8b 50 08             	mov    0x8(%eax),%edx
  802f7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f80:	8b 40 0c             	mov    0xc(%eax),%eax
  802f83:	01 c2                	add    %eax,%edx
  802f85:	8b 45 08             	mov    0x8(%ebp),%eax
  802f88:	8b 40 08             	mov    0x8(%eax),%eax
  802f8b:	39 c2                	cmp    %eax,%edx
  802f8d:	0f 85 b9 01 00 00    	jne    80314c <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802f93:	8b 45 08             	mov    0x8(%ebp),%eax
  802f96:	8b 50 08             	mov    0x8(%eax),%edx
  802f99:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9c:	8b 40 0c             	mov    0xc(%eax),%eax
  802f9f:	01 c2                	add    %eax,%edx
  802fa1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fa4:	8b 40 08             	mov    0x8(%eax),%eax
  802fa7:	39 c2                	cmp    %eax,%edx
  802fa9:	0f 85 0d 01 00 00    	jne    8030bc <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802faf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb2:	8b 50 0c             	mov    0xc(%eax),%edx
  802fb5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fb8:	8b 40 0c             	mov    0xc(%eax),%eax
  802fbb:	01 c2                	add    %eax,%edx
  802fbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc0:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802fc3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802fc7:	75 17                	jne    802fe0 <insert_sorted_with_merge_freeList+0x39c>
  802fc9:	83 ec 04             	sub    $0x4,%esp
  802fcc:	68 c8 40 80 00       	push   $0x8040c8
  802fd1:	68 5c 01 00 00       	push   $0x15c
  802fd6:	68 1f 40 80 00       	push   $0x80401f
  802fdb:	e8 dd d2 ff ff       	call   8002bd <_panic>
  802fe0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fe3:	8b 00                	mov    (%eax),%eax
  802fe5:	85 c0                	test   %eax,%eax
  802fe7:	74 10                	je     802ff9 <insert_sorted_with_merge_freeList+0x3b5>
  802fe9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fec:	8b 00                	mov    (%eax),%eax
  802fee:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ff1:	8b 52 04             	mov    0x4(%edx),%edx
  802ff4:	89 50 04             	mov    %edx,0x4(%eax)
  802ff7:	eb 0b                	jmp    803004 <insert_sorted_with_merge_freeList+0x3c0>
  802ff9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ffc:	8b 40 04             	mov    0x4(%eax),%eax
  802fff:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803004:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803007:	8b 40 04             	mov    0x4(%eax),%eax
  80300a:	85 c0                	test   %eax,%eax
  80300c:	74 0f                	je     80301d <insert_sorted_with_merge_freeList+0x3d9>
  80300e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803011:	8b 40 04             	mov    0x4(%eax),%eax
  803014:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803017:	8b 12                	mov    (%edx),%edx
  803019:	89 10                	mov    %edx,(%eax)
  80301b:	eb 0a                	jmp    803027 <insert_sorted_with_merge_freeList+0x3e3>
  80301d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803020:	8b 00                	mov    (%eax),%eax
  803022:	a3 38 51 80 00       	mov    %eax,0x805138
  803027:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80302a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803030:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803033:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80303a:	a1 44 51 80 00       	mov    0x805144,%eax
  80303f:	48                   	dec    %eax
  803040:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803045:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803048:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  80304f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803052:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803059:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80305d:	75 17                	jne    803076 <insert_sorted_with_merge_freeList+0x432>
  80305f:	83 ec 04             	sub    $0x4,%esp
  803062:	68 fc 3f 80 00       	push   $0x803ffc
  803067:	68 5f 01 00 00       	push   $0x15f
  80306c:	68 1f 40 80 00       	push   $0x80401f
  803071:	e8 47 d2 ff ff       	call   8002bd <_panic>
  803076:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80307c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80307f:	89 10                	mov    %edx,(%eax)
  803081:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803084:	8b 00                	mov    (%eax),%eax
  803086:	85 c0                	test   %eax,%eax
  803088:	74 0d                	je     803097 <insert_sorted_with_merge_freeList+0x453>
  80308a:	a1 48 51 80 00       	mov    0x805148,%eax
  80308f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803092:	89 50 04             	mov    %edx,0x4(%eax)
  803095:	eb 08                	jmp    80309f <insert_sorted_with_merge_freeList+0x45b>
  803097:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80309a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80309f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030a2:	a3 48 51 80 00       	mov    %eax,0x805148
  8030a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030aa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030b1:	a1 54 51 80 00       	mov    0x805154,%eax
  8030b6:	40                   	inc    %eax
  8030b7:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8030bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030bf:	8b 50 0c             	mov    0xc(%eax),%edx
  8030c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c5:	8b 40 0c             	mov    0xc(%eax),%eax
  8030c8:	01 c2                	add    %eax,%edx
  8030ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030cd:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8030d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8030da:	8b 45 08             	mov    0x8(%ebp),%eax
  8030dd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8030e4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030e8:	75 17                	jne    803101 <insert_sorted_with_merge_freeList+0x4bd>
  8030ea:	83 ec 04             	sub    $0x4,%esp
  8030ed:	68 fc 3f 80 00       	push   $0x803ffc
  8030f2:	68 64 01 00 00       	push   $0x164
  8030f7:	68 1f 40 80 00       	push   $0x80401f
  8030fc:	e8 bc d1 ff ff       	call   8002bd <_panic>
  803101:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803107:	8b 45 08             	mov    0x8(%ebp),%eax
  80310a:	89 10                	mov    %edx,(%eax)
  80310c:	8b 45 08             	mov    0x8(%ebp),%eax
  80310f:	8b 00                	mov    (%eax),%eax
  803111:	85 c0                	test   %eax,%eax
  803113:	74 0d                	je     803122 <insert_sorted_with_merge_freeList+0x4de>
  803115:	a1 48 51 80 00       	mov    0x805148,%eax
  80311a:	8b 55 08             	mov    0x8(%ebp),%edx
  80311d:	89 50 04             	mov    %edx,0x4(%eax)
  803120:	eb 08                	jmp    80312a <insert_sorted_with_merge_freeList+0x4e6>
  803122:	8b 45 08             	mov    0x8(%ebp),%eax
  803125:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80312a:	8b 45 08             	mov    0x8(%ebp),%eax
  80312d:	a3 48 51 80 00       	mov    %eax,0x805148
  803132:	8b 45 08             	mov    0x8(%ebp),%eax
  803135:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80313c:	a1 54 51 80 00       	mov    0x805154,%eax
  803141:	40                   	inc    %eax
  803142:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803147:	e9 41 02 00 00       	jmp    80338d <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80314c:	8b 45 08             	mov    0x8(%ebp),%eax
  80314f:	8b 50 08             	mov    0x8(%eax),%edx
  803152:	8b 45 08             	mov    0x8(%ebp),%eax
  803155:	8b 40 0c             	mov    0xc(%eax),%eax
  803158:	01 c2                	add    %eax,%edx
  80315a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80315d:	8b 40 08             	mov    0x8(%eax),%eax
  803160:	39 c2                	cmp    %eax,%edx
  803162:	0f 85 7c 01 00 00    	jne    8032e4 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803168:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80316c:	74 06                	je     803174 <insert_sorted_with_merge_freeList+0x530>
  80316e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803172:	75 17                	jne    80318b <insert_sorted_with_merge_freeList+0x547>
  803174:	83 ec 04             	sub    $0x4,%esp
  803177:	68 38 40 80 00       	push   $0x804038
  80317c:	68 69 01 00 00       	push   $0x169
  803181:	68 1f 40 80 00       	push   $0x80401f
  803186:	e8 32 d1 ff ff       	call   8002bd <_panic>
  80318b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80318e:	8b 50 04             	mov    0x4(%eax),%edx
  803191:	8b 45 08             	mov    0x8(%ebp),%eax
  803194:	89 50 04             	mov    %edx,0x4(%eax)
  803197:	8b 45 08             	mov    0x8(%ebp),%eax
  80319a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80319d:	89 10                	mov    %edx,(%eax)
  80319f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031a2:	8b 40 04             	mov    0x4(%eax),%eax
  8031a5:	85 c0                	test   %eax,%eax
  8031a7:	74 0d                	je     8031b6 <insert_sorted_with_merge_freeList+0x572>
  8031a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ac:	8b 40 04             	mov    0x4(%eax),%eax
  8031af:	8b 55 08             	mov    0x8(%ebp),%edx
  8031b2:	89 10                	mov    %edx,(%eax)
  8031b4:	eb 08                	jmp    8031be <insert_sorted_with_merge_freeList+0x57a>
  8031b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b9:	a3 38 51 80 00       	mov    %eax,0x805138
  8031be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8031c4:	89 50 04             	mov    %edx,0x4(%eax)
  8031c7:	a1 44 51 80 00       	mov    0x805144,%eax
  8031cc:	40                   	inc    %eax
  8031cd:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8031d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d5:	8b 50 0c             	mov    0xc(%eax),%edx
  8031d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031db:	8b 40 0c             	mov    0xc(%eax),%eax
  8031de:	01 c2                	add    %eax,%edx
  8031e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e3:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8031e6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031ea:	75 17                	jne    803203 <insert_sorted_with_merge_freeList+0x5bf>
  8031ec:	83 ec 04             	sub    $0x4,%esp
  8031ef:	68 c8 40 80 00       	push   $0x8040c8
  8031f4:	68 6b 01 00 00       	push   $0x16b
  8031f9:	68 1f 40 80 00       	push   $0x80401f
  8031fe:	e8 ba d0 ff ff       	call   8002bd <_panic>
  803203:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803206:	8b 00                	mov    (%eax),%eax
  803208:	85 c0                	test   %eax,%eax
  80320a:	74 10                	je     80321c <insert_sorted_with_merge_freeList+0x5d8>
  80320c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80320f:	8b 00                	mov    (%eax),%eax
  803211:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803214:	8b 52 04             	mov    0x4(%edx),%edx
  803217:	89 50 04             	mov    %edx,0x4(%eax)
  80321a:	eb 0b                	jmp    803227 <insert_sorted_with_merge_freeList+0x5e3>
  80321c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80321f:	8b 40 04             	mov    0x4(%eax),%eax
  803222:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803227:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80322a:	8b 40 04             	mov    0x4(%eax),%eax
  80322d:	85 c0                	test   %eax,%eax
  80322f:	74 0f                	je     803240 <insert_sorted_with_merge_freeList+0x5fc>
  803231:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803234:	8b 40 04             	mov    0x4(%eax),%eax
  803237:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80323a:	8b 12                	mov    (%edx),%edx
  80323c:	89 10                	mov    %edx,(%eax)
  80323e:	eb 0a                	jmp    80324a <insert_sorted_with_merge_freeList+0x606>
  803240:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803243:	8b 00                	mov    (%eax),%eax
  803245:	a3 38 51 80 00       	mov    %eax,0x805138
  80324a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80324d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803253:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803256:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80325d:	a1 44 51 80 00       	mov    0x805144,%eax
  803262:	48                   	dec    %eax
  803263:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803268:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80326b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803272:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803275:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80327c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803280:	75 17                	jne    803299 <insert_sorted_with_merge_freeList+0x655>
  803282:	83 ec 04             	sub    $0x4,%esp
  803285:	68 fc 3f 80 00       	push   $0x803ffc
  80328a:	68 6e 01 00 00       	push   $0x16e
  80328f:	68 1f 40 80 00       	push   $0x80401f
  803294:	e8 24 d0 ff ff       	call   8002bd <_panic>
  803299:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80329f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032a2:	89 10                	mov    %edx,(%eax)
  8032a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032a7:	8b 00                	mov    (%eax),%eax
  8032a9:	85 c0                	test   %eax,%eax
  8032ab:	74 0d                	je     8032ba <insert_sorted_with_merge_freeList+0x676>
  8032ad:	a1 48 51 80 00       	mov    0x805148,%eax
  8032b2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032b5:	89 50 04             	mov    %edx,0x4(%eax)
  8032b8:	eb 08                	jmp    8032c2 <insert_sorted_with_merge_freeList+0x67e>
  8032ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032bd:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032c5:	a3 48 51 80 00       	mov    %eax,0x805148
  8032ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032cd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032d4:	a1 54 51 80 00       	mov    0x805154,%eax
  8032d9:	40                   	inc    %eax
  8032da:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8032df:	e9 a9 00 00 00       	jmp    80338d <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8032e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032e8:	74 06                	je     8032f0 <insert_sorted_with_merge_freeList+0x6ac>
  8032ea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032ee:	75 17                	jne    803307 <insert_sorted_with_merge_freeList+0x6c3>
  8032f0:	83 ec 04             	sub    $0x4,%esp
  8032f3:	68 94 40 80 00       	push   $0x804094
  8032f8:	68 73 01 00 00       	push   $0x173
  8032fd:	68 1f 40 80 00       	push   $0x80401f
  803302:	e8 b6 cf ff ff       	call   8002bd <_panic>
  803307:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80330a:	8b 10                	mov    (%eax),%edx
  80330c:	8b 45 08             	mov    0x8(%ebp),%eax
  80330f:	89 10                	mov    %edx,(%eax)
  803311:	8b 45 08             	mov    0x8(%ebp),%eax
  803314:	8b 00                	mov    (%eax),%eax
  803316:	85 c0                	test   %eax,%eax
  803318:	74 0b                	je     803325 <insert_sorted_with_merge_freeList+0x6e1>
  80331a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80331d:	8b 00                	mov    (%eax),%eax
  80331f:	8b 55 08             	mov    0x8(%ebp),%edx
  803322:	89 50 04             	mov    %edx,0x4(%eax)
  803325:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803328:	8b 55 08             	mov    0x8(%ebp),%edx
  80332b:	89 10                	mov    %edx,(%eax)
  80332d:	8b 45 08             	mov    0x8(%ebp),%eax
  803330:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803333:	89 50 04             	mov    %edx,0x4(%eax)
  803336:	8b 45 08             	mov    0x8(%ebp),%eax
  803339:	8b 00                	mov    (%eax),%eax
  80333b:	85 c0                	test   %eax,%eax
  80333d:	75 08                	jne    803347 <insert_sorted_with_merge_freeList+0x703>
  80333f:	8b 45 08             	mov    0x8(%ebp),%eax
  803342:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803347:	a1 44 51 80 00       	mov    0x805144,%eax
  80334c:	40                   	inc    %eax
  80334d:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803352:	eb 39                	jmp    80338d <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803354:	a1 40 51 80 00       	mov    0x805140,%eax
  803359:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80335c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803360:	74 07                	je     803369 <insert_sorted_with_merge_freeList+0x725>
  803362:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803365:	8b 00                	mov    (%eax),%eax
  803367:	eb 05                	jmp    80336e <insert_sorted_with_merge_freeList+0x72a>
  803369:	b8 00 00 00 00       	mov    $0x0,%eax
  80336e:	a3 40 51 80 00       	mov    %eax,0x805140
  803373:	a1 40 51 80 00       	mov    0x805140,%eax
  803378:	85 c0                	test   %eax,%eax
  80337a:	0f 85 c7 fb ff ff    	jne    802f47 <insert_sorted_with_merge_freeList+0x303>
  803380:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803384:	0f 85 bd fb ff ff    	jne    802f47 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80338a:	eb 01                	jmp    80338d <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80338c:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80338d:	90                   	nop
  80338e:	c9                   	leave  
  80338f:	c3                   	ret    

00803390 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803390:	55                   	push   %ebp
  803391:	89 e5                	mov    %esp,%ebp
  803393:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803396:	8b 55 08             	mov    0x8(%ebp),%edx
  803399:	89 d0                	mov    %edx,%eax
  80339b:	c1 e0 02             	shl    $0x2,%eax
  80339e:	01 d0                	add    %edx,%eax
  8033a0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8033a7:	01 d0                	add    %edx,%eax
  8033a9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8033b0:	01 d0                	add    %edx,%eax
  8033b2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8033b9:	01 d0                	add    %edx,%eax
  8033bb:	c1 e0 04             	shl    $0x4,%eax
  8033be:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8033c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8033c8:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8033cb:	83 ec 0c             	sub    $0xc,%esp
  8033ce:	50                   	push   %eax
  8033cf:	e8 26 e7 ff ff       	call   801afa <sys_get_virtual_time>
  8033d4:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8033d7:	eb 41                	jmp    80341a <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8033d9:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8033dc:	83 ec 0c             	sub    $0xc,%esp
  8033df:	50                   	push   %eax
  8033e0:	e8 15 e7 ff ff       	call   801afa <sys_get_virtual_time>
  8033e5:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8033e8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8033eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033ee:	29 c2                	sub    %eax,%edx
  8033f0:	89 d0                	mov    %edx,%eax
  8033f2:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8033f5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8033f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033fb:	89 d1                	mov    %edx,%ecx
  8033fd:	29 c1                	sub    %eax,%ecx
  8033ff:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803402:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803405:	39 c2                	cmp    %eax,%edx
  803407:	0f 97 c0             	seta   %al
  80340a:	0f b6 c0             	movzbl %al,%eax
  80340d:	29 c1                	sub    %eax,%ecx
  80340f:	89 c8                	mov    %ecx,%eax
  803411:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803414:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803417:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  80341a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80341d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803420:	72 b7                	jb     8033d9 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803422:	90                   	nop
  803423:	c9                   	leave  
  803424:	c3                   	ret    

00803425 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803425:	55                   	push   %ebp
  803426:	89 e5                	mov    %esp,%ebp
  803428:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  80342b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803432:	eb 03                	jmp    803437 <busy_wait+0x12>
  803434:	ff 45 fc             	incl   -0x4(%ebp)
  803437:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80343a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80343d:	72 f5                	jb     803434 <busy_wait+0xf>
	return i;
  80343f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803442:	c9                   	leave  
  803443:	c3                   	ret    

00803444 <__udivdi3>:
  803444:	55                   	push   %ebp
  803445:	57                   	push   %edi
  803446:	56                   	push   %esi
  803447:	53                   	push   %ebx
  803448:	83 ec 1c             	sub    $0x1c,%esp
  80344b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80344f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803453:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803457:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80345b:	89 ca                	mov    %ecx,%edx
  80345d:	89 f8                	mov    %edi,%eax
  80345f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803463:	85 f6                	test   %esi,%esi
  803465:	75 2d                	jne    803494 <__udivdi3+0x50>
  803467:	39 cf                	cmp    %ecx,%edi
  803469:	77 65                	ja     8034d0 <__udivdi3+0x8c>
  80346b:	89 fd                	mov    %edi,%ebp
  80346d:	85 ff                	test   %edi,%edi
  80346f:	75 0b                	jne    80347c <__udivdi3+0x38>
  803471:	b8 01 00 00 00       	mov    $0x1,%eax
  803476:	31 d2                	xor    %edx,%edx
  803478:	f7 f7                	div    %edi
  80347a:	89 c5                	mov    %eax,%ebp
  80347c:	31 d2                	xor    %edx,%edx
  80347e:	89 c8                	mov    %ecx,%eax
  803480:	f7 f5                	div    %ebp
  803482:	89 c1                	mov    %eax,%ecx
  803484:	89 d8                	mov    %ebx,%eax
  803486:	f7 f5                	div    %ebp
  803488:	89 cf                	mov    %ecx,%edi
  80348a:	89 fa                	mov    %edi,%edx
  80348c:	83 c4 1c             	add    $0x1c,%esp
  80348f:	5b                   	pop    %ebx
  803490:	5e                   	pop    %esi
  803491:	5f                   	pop    %edi
  803492:	5d                   	pop    %ebp
  803493:	c3                   	ret    
  803494:	39 ce                	cmp    %ecx,%esi
  803496:	77 28                	ja     8034c0 <__udivdi3+0x7c>
  803498:	0f bd fe             	bsr    %esi,%edi
  80349b:	83 f7 1f             	xor    $0x1f,%edi
  80349e:	75 40                	jne    8034e0 <__udivdi3+0x9c>
  8034a0:	39 ce                	cmp    %ecx,%esi
  8034a2:	72 0a                	jb     8034ae <__udivdi3+0x6a>
  8034a4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8034a8:	0f 87 9e 00 00 00    	ja     80354c <__udivdi3+0x108>
  8034ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8034b3:	89 fa                	mov    %edi,%edx
  8034b5:	83 c4 1c             	add    $0x1c,%esp
  8034b8:	5b                   	pop    %ebx
  8034b9:	5e                   	pop    %esi
  8034ba:	5f                   	pop    %edi
  8034bb:	5d                   	pop    %ebp
  8034bc:	c3                   	ret    
  8034bd:	8d 76 00             	lea    0x0(%esi),%esi
  8034c0:	31 ff                	xor    %edi,%edi
  8034c2:	31 c0                	xor    %eax,%eax
  8034c4:	89 fa                	mov    %edi,%edx
  8034c6:	83 c4 1c             	add    $0x1c,%esp
  8034c9:	5b                   	pop    %ebx
  8034ca:	5e                   	pop    %esi
  8034cb:	5f                   	pop    %edi
  8034cc:	5d                   	pop    %ebp
  8034cd:	c3                   	ret    
  8034ce:	66 90                	xchg   %ax,%ax
  8034d0:	89 d8                	mov    %ebx,%eax
  8034d2:	f7 f7                	div    %edi
  8034d4:	31 ff                	xor    %edi,%edi
  8034d6:	89 fa                	mov    %edi,%edx
  8034d8:	83 c4 1c             	add    $0x1c,%esp
  8034db:	5b                   	pop    %ebx
  8034dc:	5e                   	pop    %esi
  8034dd:	5f                   	pop    %edi
  8034de:	5d                   	pop    %ebp
  8034df:	c3                   	ret    
  8034e0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8034e5:	89 eb                	mov    %ebp,%ebx
  8034e7:	29 fb                	sub    %edi,%ebx
  8034e9:	89 f9                	mov    %edi,%ecx
  8034eb:	d3 e6                	shl    %cl,%esi
  8034ed:	89 c5                	mov    %eax,%ebp
  8034ef:	88 d9                	mov    %bl,%cl
  8034f1:	d3 ed                	shr    %cl,%ebp
  8034f3:	89 e9                	mov    %ebp,%ecx
  8034f5:	09 f1                	or     %esi,%ecx
  8034f7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8034fb:	89 f9                	mov    %edi,%ecx
  8034fd:	d3 e0                	shl    %cl,%eax
  8034ff:	89 c5                	mov    %eax,%ebp
  803501:	89 d6                	mov    %edx,%esi
  803503:	88 d9                	mov    %bl,%cl
  803505:	d3 ee                	shr    %cl,%esi
  803507:	89 f9                	mov    %edi,%ecx
  803509:	d3 e2                	shl    %cl,%edx
  80350b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80350f:	88 d9                	mov    %bl,%cl
  803511:	d3 e8                	shr    %cl,%eax
  803513:	09 c2                	or     %eax,%edx
  803515:	89 d0                	mov    %edx,%eax
  803517:	89 f2                	mov    %esi,%edx
  803519:	f7 74 24 0c          	divl   0xc(%esp)
  80351d:	89 d6                	mov    %edx,%esi
  80351f:	89 c3                	mov    %eax,%ebx
  803521:	f7 e5                	mul    %ebp
  803523:	39 d6                	cmp    %edx,%esi
  803525:	72 19                	jb     803540 <__udivdi3+0xfc>
  803527:	74 0b                	je     803534 <__udivdi3+0xf0>
  803529:	89 d8                	mov    %ebx,%eax
  80352b:	31 ff                	xor    %edi,%edi
  80352d:	e9 58 ff ff ff       	jmp    80348a <__udivdi3+0x46>
  803532:	66 90                	xchg   %ax,%ax
  803534:	8b 54 24 08          	mov    0x8(%esp),%edx
  803538:	89 f9                	mov    %edi,%ecx
  80353a:	d3 e2                	shl    %cl,%edx
  80353c:	39 c2                	cmp    %eax,%edx
  80353e:	73 e9                	jae    803529 <__udivdi3+0xe5>
  803540:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803543:	31 ff                	xor    %edi,%edi
  803545:	e9 40 ff ff ff       	jmp    80348a <__udivdi3+0x46>
  80354a:	66 90                	xchg   %ax,%ax
  80354c:	31 c0                	xor    %eax,%eax
  80354e:	e9 37 ff ff ff       	jmp    80348a <__udivdi3+0x46>
  803553:	90                   	nop

00803554 <__umoddi3>:
  803554:	55                   	push   %ebp
  803555:	57                   	push   %edi
  803556:	56                   	push   %esi
  803557:	53                   	push   %ebx
  803558:	83 ec 1c             	sub    $0x1c,%esp
  80355b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80355f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803563:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803567:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80356b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80356f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803573:	89 f3                	mov    %esi,%ebx
  803575:	89 fa                	mov    %edi,%edx
  803577:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80357b:	89 34 24             	mov    %esi,(%esp)
  80357e:	85 c0                	test   %eax,%eax
  803580:	75 1a                	jne    80359c <__umoddi3+0x48>
  803582:	39 f7                	cmp    %esi,%edi
  803584:	0f 86 a2 00 00 00    	jbe    80362c <__umoddi3+0xd8>
  80358a:	89 c8                	mov    %ecx,%eax
  80358c:	89 f2                	mov    %esi,%edx
  80358e:	f7 f7                	div    %edi
  803590:	89 d0                	mov    %edx,%eax
  803592:	31 d2                	xor    %edx,%edx
  803594:	83 c4 1c             	add    $0x1c,%esp
  803597:	5b                   	pop    %ebx
  803598:	5e                   	pop    %esi
  803599:	5f                   	pop    %edi
  80359a:	5d                   	pop    %ebp
  80359b:	c3                   	ret    
  80359c:	39 f0                	cmp    %esi,%eax
  80359e:	0f 87 ac 00 00 00    	ja     803650 <__umoddi3+0xfc>
  8035a4:	0f bd e8             	bsr    %eax,%ebp
  8035a7:	83 f5 1f             	xor    $0x1f,%ebp
  8035aa:	0f 84 ac 00 00 00    	je     80365c <__umoddi3+0x108>
  8035b0:	bf 20 00 00 00       	mov    $0x20,%edi
  8035b5:	29 ef                	sub    %ebp,%edi
  8035b7:	89 fe                	mov    %edi,%esi
  8035b9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8035bd:	89 e9                	mov    %ebp,%ecx
  8035bf:	d3 e0                	shl    %cl,%eax
  8035c1:	89 d7                	mov    %edx,%edi
  8035c3:	89 f1                	mov    %esi,%ecx
  8035c5:	d3 ef                	shr    %cl,%edi
  8035c7:	09 c7                	or     %eax,%edi
  8035c9:	89 e9                	mov    %ebp,%ecx
  8035cb:	d3 e2                	shl    %cl,%edx
  8035cd:	89 14 24             	mov    %edx,(%esp)
  8035d0:	89 d8                	mov    %ebx,%eax
  8035d2:	d3 e0                	shl    %cl,%eax
  8035d4:	89 c2                	mov    %eax,%edx
  8035d6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035da:	d3 e0                	shl    %cl,%eax
  8035dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8035e0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035e4:	89 f1                	mov    %esi,%ecx
  8035e6:	d3 e8                	shr    %cl,%eax
  8035e8:	09 d0                	or     %edx,%eax
  8035ea:	d3 eb                	shr    %cl,%ebx
  8035ec:	89 da                	mov    %ebx,%edx
  8035ee:	f7 f7                	div    %edi
  8035f0:	89 d3                	mov    %edx,%ebx
  8035f2:	f7 24 24             	mull   (%esp)
  8035f5:	89 c6                	mov    %eax,%esi
  8035f7:	89 d1                	mov    %edx,%ecx
  8035f9:	39 d3                	cmp    %edx,%ebx
  8035fb:	0f 82 87 00 00 00    	jb     803688 <__umoddi3+0x134>
  803601:	0f 84 91 00 00 00    	je     803698 <__umoddi3+0x144>
  803607:	8b 54 24 04          	mov    0x4(%esp),%edx
  80360b:	29 f2                	sub    %esi,%edx
  80360d:	19 cb                	sbb    %ecx,%ebx
  80360f:	89 d8                	mov    %ebx,%eax
  803611:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803615:	d3 e0                	shl    %cl,%eax
  803617:	89 e9                	mov    %ebp,%ecx
  803619:	d3 ea                	shr    %cl,%edx
  80361b:	09 d0                	or     %edx,%eax
  80361d:	89 e9                	mov    %ebp,%ecx
  80361f:	d3 eb                	shr    %cl,%ebx
  803621:	89 da                	mov    %ebx,%edx
  803623:	83 c4 1c             	add    $0x1c,%esp
  803626:	5b                   	pop    %ebx
  803627:	5e                   	pop    %esi
  803628:	5f                   	pop    %edi
  803629:	5d                   	pop    %ebp
  80362a:	c3                   	ret    
  80362b:	90                   	nop
  80362c:	89 fd                	mov    %edi,%ebp
  80362e:	85 ff                	test   %edi,%edi
  803630:	75 0b                	jne    80363d <__umoddi3+0xe9>
  803632:	b8 01 00 00 00       	mov    $0x1,%eax
  803637:	31 d2                	xor    %edx,%edx
  803639:	f7 f7                	div    %edi
  80363b:	89 c5                	mov    %eax,%ebp
  80363d:	89 f0                	mov    %esi,%eax
  80363f:	31 d2                	xor    %edx,%edx
  803641:	f7 f5                	div    %ebp
  803643:	89 c8                	mov    %ecx,%eax
  803645:	f7 f5                	div    %ebp
  803647:	89 d0                	mov    %edx,%eax
  803649:	e9 44 ff ff ff       	jmp    803592 <__umoddi3+0x3e>
  80364e:	66 90                	xchg   %ax,%ax
  803650:	89 c8                	mov    %ecx,%eax
  803652:	89 f2                	mov    %esi,%edx
  803654:	83 c4 1c             	add    $0x1c,%esp
  803657:	5b                   	pop    %ebx
  803658:	5e                   	pop    %esi
  803659:	5f                   	pop    %edi
  80365a:	5d                   	pop    %ebp
  80365b:	c3                   	ret    
  80365c:	3b 04 24             	cmp    (%esp),%eax
  80365f:	72 06                	jb     803667 <__umoddi3+0x113>
  803661:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803665:	77 0f                	ja     803676 <__umoddi3+0x122>
  803667:	89 f2                	mov    %esi,%edx
  803669:	29 f9                	sub    %edi,%ecx
  80366b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80366f:	89 14 24             	mov    %edx,(%esp)
  803672:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803676:	8b 44 24 04          	mov    0x4(%esp),%eax
  80367a:	8b 14 24             	mov    (%esp),%edx
  80367d:	83 c4 1c             	add    $0x1c,%esp
  803680:	5b                   	pop    %ebx
  803681:	5e                   	pop    %esi
  803682:	5f                   	pop    %edi
  803683:	5d                   	pop    %ebp
  803684:	c3                   	ret    
  803685:	8d 76 00             	lea    0x0(%esi),%esi
  803688:	2b 04 24             	sub    (%esp),%eax
  80368b:	19 fa                	sbb    %edi,%edx
  80368d:	89 d1                	mov    %edx,%ecx
  80368f:	89 c6                	mov    %eax,%esi
  803691:	e9 71 ff ff ff       	jmp    803607 <__umoddi3+0xb3>
  803696:	66 90                	xchg   %ax,%ax
  803698:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80369c:	72 ea                	jb     803688 <__umoddi3+0x134>
  80369e:	89 d9                	mov    %ebx,%ecx
  8036a0:	e9 62 ff ff ff       	jmp    803607 <__umoddi3+0xb3>
