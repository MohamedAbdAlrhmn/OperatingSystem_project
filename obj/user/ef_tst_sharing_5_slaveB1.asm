
obj/user/ef_tst_sharing_5_slaveB1:     file format elf32-i386


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
  800031:	e8 05 01 00 00       	call   80013b <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the free of shared variables
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80003e:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800042:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800049:	eb 29                	jmp    800074 <_main+0x3c>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004b:	a1 20 50 80 00       	mov    0x805020,%eax
  800050:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800056:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800059:	89 d0                	mov    %edx,%eax
  80005b:	01 c0                	add    %eax,%eax
  80005d:	01 d0                	add    %edx,%eax
  80005f:	c1 e0 03             	shl    $0x3,%eax
  800062:	01 c8                	add    %ecx,%eax
  800064:	8a 40 04             	mov    0x4(%eax),%al
  800067:	84 c0                	test   %al,%al
  800069:	74 06                	je     800071 <_main+0x39>
			{
				fullWS = 0;
  80006b:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  80006f:	eb 12                	jmp    800083 <_main+0x4b>
_main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800071:	ff 45 f0             	incl   -0x10(%ebp)
  800074:	a1 20 50 80 00       	mov    0x805020,%eax
  800079:	8b 50 74             	mov    0x74(%eax),%edx
  80007c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80007f:	39 c2                	cmp    %eax,%edx
  800081:	77 c8                	ja     80004b <_main+0x13>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800083:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800087:	74 14                	je     80009d <_main+0x65>
  800089:	83 ec 04             	sub    $0x4,%esp
  80008c:	68 c0 37 80 00       	push   $0x8037c0
  800091:	6a 12                	push   $0x12
  800093:	68 dc 37 80 00       	push   $0x8037dc
  800098:	e8 da 01 00 00       	call   800277 <_panic>
	}
	uint32 *x;
	x = sget(sys_getparentenvid(),"x");
  80009d:	e8 27 1b 00 00       	call   801bc9 <sys_getparentenvid>
  8000a2:	83 ec 08             	sub    $0x8,%esp
  8000a5:	68 fc 37 80 00       	push   $0x8037fc
  8000aa:	50                   	push   %eax
  8000ab:	e8 fc 15 00 00       	call   8016ac <sget>
  8000b0:	83 c4 10             	add    $0x10,%esp
  8000b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("Slave B1 env used x (getSharedObject)\n");
  8000b6:	83 ec 0c             	sub    $0xc,%esp
  8000b9:	68 00 38 80 00       	push   $0x803800
  8000be:	e8 68 04 00 00       	call   80052b <cprintf>
  8000c3:	83 c4 10             	add    $0x10,%esp

	cprintf("Slave B1 please be patient ...\n");
  8000c6:	83 ec 0c             	sub    $0xc,%esp
  8000c9:	68 28 38 80 00       	push   $0x803828
  8000ce:	e8 58 04 00 00       	call   80052b <cprintf>
  8000d3:	83 c4 10             	add    $0x10,%esp

	env_sleep(6000);
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	68 70 17 00 00       	push   $0x1770
  8000de:	e8 af 33 00 00       	call   803492 <env_sleep>
  8000e3:	83 c4 10             	add    $0x10,%esp
	int freeFrames = sys_calculate_free_frames() ;
  8000e6:	e8 e5 17 00 00       	call   8018d0 <sys_calculate_free_frames>
  8000eb:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sfree(x);
  8000ee:	83 ec 0c             	sub    $0xc,%esp
  8000f1:	ff 75 ec             	pushl  -0x14(%ebp)
  8000f4:	e8 77 16 00 00       	call   801770 <sfree>
  8000f9:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave B1 env removed x\n");
  8000fc:	83 ec 0c             	sub    $0xc,%esp
  8000ff:	68 48 38 80 00       	push   $0x803848
  800104:	e8 22 04 00 00       	call   80052b <cprintf>
  800109:	83 c4 10             	add    $0x10,%esp

	if ((sys_calculate_free_frames() - freeFrames) !=  4) panic("B1 wrong free: frames removed not equal 4 !, correct frames to be removed are 4:\nfrom the env: 1 table and 1 for frame of x\nframes_storage of x: should be cleared now\n");
  80010c:	e8 bf 17 00 00       	call   8018d0 <sys_calculate_free_frames>
  800111:	89 c2                	mov    %eax,%edx
  800113:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800116:	29 c2                	sub    %eax,%edx
  800118:	89 d0                	mov    %edx,%eax
  80011a:	83 f8 04             	cmp    $0x4,%eax
  80011d:	74 14                	je     800133 <_main+0xfb>
  80011f:	83 ec 04             	sub    $0x4,%esp
  800122:	68 60 38 80 00       	push   $0x803860
  800127:	6a 20                	push   $0x20
  800129:	68 dc 37 80 00       	push   $0x8037dc
  80012e:	e8 44 01 00 00       	call   800277 <_panic>

	//To indicate that it's completed successfully
	inctst();
  800133:	e8 b6 1b 00 00       	call   801cee <inctst>
	return;
  800138:	90                   	nop
}
  800139:	c9                   	leave  
  80013a:	c3                   	ret    

0080013b <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80013b:	55                   	push   %ebp
  80013c:	89 e5                	mov    %esp,%ebp
  80013e:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800141:	e8 6a 1a 00 00       	call   801bb0 <sys_getenvindex>
  800146:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800149:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80014c:	89 d0                	mov    %edx,%eax
  80014e:	c1 e0 03             	shl    $0x3,%eax
  800151:	01 d0                	add    %edx,%eax
  800153:	01 c0                	add    %eax,%eax
  800155:	01 d0                	add    %edx,%eax
  800157:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80015e:	01 d0                	add    %edx,%eax
  800160:	c1 e0 04             	shl    $0x4,%eax
  800163:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800168:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80016d:	a1 20 50 80 00       	mov    0x805020,%eax
  800172:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800178:	84 c0                	test   %al,%al
  80017a:	74 0f                	je     80018b <libmain+0x50>
		binaryname = myEnv->prog_name;
  80017c:	a1 20 50 80 00       	mov    0x805020,%eax
  800181:	05 5c 05 00 00       	add    $0x55c,%eax
  800186:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80018b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80018f:	7e 0a                	jle    80019b <libmain+0x60>
		binaryname = argv[0];
  800191:	8b 45 0c             	mov    0xc(%ebp),%eax
  800194:	8b 00                	mov    (%eax),%eax
  800196:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  80019b:	83 ec 08             	sub    $0x8,%esp
  80019e:	ff 75 0c             	pushl  0xc(%ebp)
  8001a1:	ff 75 08             	pushl  0x8(%ebp)
  8001a4:	e8 8f fe ff ff       	call   800038 <_main>
  8001a9:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001ac:	e8 0c 18 00 00       	call   8019bd <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001b1:	83 ec 0c             	sub    $0xc,%esp
  8001b4:	68 20 39 80 00       	push   $0x803920
  8001b9:	e8 6d 03 00 00       	call   80052b <cprintf>
  8001be:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001c1:	a1 20 50 80 00       	mov    0x805020,%eax
  8001c6:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8001cc:	a1 20 50 80 00       	mov    0x805020,%eax
  8001d1:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8001d7:	83 ec 04             	sub    $0x4,%esp
  8001da:	52                   	push   %edx
  8001db:	50                   	push   %eax
  8001dc:	68 48 39 80 00       	push   $0x803948
  8001e1:	e8 45 03 00 00       	call   80052b <cprintf>
  8001e6:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001e9:	a1 20 50 80 00       	mov    0x805020,%eax
  8001ee:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8001f4:	a1 20 50 80 00       	mov    0x805020,%eax
  8001f9:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8001ff:	a1 20 50 80 00       	mov    0x805020,%eax
  800204:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80020a:	51                   	push   %ecx
  80020b:	52                   	push   %edx
  80020c:	50                   	push   %eax
  80020d:	68 70 39 80 00       	push   $0x803970
  800212:	e8 14 03 00 00       	call   80052b <cprintf>
  800217:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80021a:	a1 20 50 80 00       	mov    0x805020,%eax
  80021f:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800225:	83 ec 08             	sub    $0x8,%esp
  800228:	50                   	push   %eax
  800229:	68 c8 39 80 00       	push   $0x8039c8
  80022e:	e8 f8 02 00 00       	call   80052b <cprintf>
  800233:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800236:	83 ec 0c             	sub    $0xc,%esp
  800239:	68 20 39 80 00       	push   $0x803920
  80023e:	e8 e8 02 00 00       	call   80052b <cprintf>
  800243:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800246:	e8 8c 17 00 00       	call   8019d7 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80024b:	e8 19 00 00 00       	call   800269 <exit>
}
  800250:	90                   	nop
  800251:	c9                   	leave  
  800252:	c3                   	ret    

00800253 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800253:	55                   	push   %ebp
  800254:	89 e5                	mov    %esp,%ebp
  800256:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800259:	83 ec 0c             	sub    $0xc,%esp
  80025c:	6a 00                	push   $0x0
  80025e:	e8 19 19 00 00       	call   801b7c <sys_destroy_env>
  800263:	83 c4 10             	add    $0x10,%esp
}
  800266:	90                   	nop
  800267:	c9                   	leave  
  800268:	c3                   	ret    

00800269 <exit>:

void
exit(void)
{
  800269:	55                   	push   %ebp
  80026a:	89 e5                	mov    %esp,%ebp
  80026c:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80026f:	e8 6e 19 00 00       	call   801be2 <sys_exit_env>
}
  800274:	90                   	nop
  800275:	c9                   	leave  
  800276:	c3                   	ret    

00800277 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800277:	55                   	push   %ebp
  800278:	89 e5                	mov    %esp,%ebp
  80027a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80027d:	8d 45 10             	lea    0x10(%ebp),%eax
  800280:	83 c0 04             	add    $0x4,%eax
  800283:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800286:	a1 5c 51 80 00       	mov    0x80515c,%eax
  80028b:	85 c0                	test   %eax,%eax
  80028d:	74 16                	je     8002a5 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80028f:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800294:	83 ec 08             	sub    $0x8,%esp
  800297:	50                   	push   %eax
  800298:	68 dc 39 80 00       	push   $0x8039dc
  80029d:	e8 89 02 00 00       	call   80052b <cprintf>
  8002a2:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002a5:	a1 00 50 80 00       	mov    0x805000,%eax
  8002aa:	ff 75 0c             	pushl  0xc(%ebp)
  8002ad:	ff 75 08             	pushl  0x8(%ebp)
  8002b0:	50                   	push   %eax
  8002b1:	68 e1 39 80 00       	push   $0x8039e1
  8002b6:	e8 70 02 00 00       	call   80052b <cprintf>
  8002bb:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002be:	8b 45 10             	mov    0x10(%ebp),%eax
  8002c1:	83 ec 08             	sub    $0x8,%esp
  8002c4:	ff 75 f4             	pushl  -0xc(%ebp)
  8002c7:	50                   	push   %eax
  8002c8:	e8 f3 01 00 00       	call   8004c0 <vcprintf>
  8002cd:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002d0:	83 ec 08             	sub    $0x8,%esp
  8002d3:	6a 00                	push   $0x0
  8002d5:	68 fd 39 80 00       	push   $0x8039fd
  8002da:	e8 e1 01 00 00       	call   8004c0 <vcprintf>
  8002df:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002e2:	e8 82 ff ff ff       	call   800269 <exit>

	// should not return here
	while (1) ;
  8002e7:	eb fe                	jmp    8002e7 <_panic+0x70>

008002e9 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8002e9:	55                   	push   %ebp
  8002ea:	89 e5                	mov    %esp,%ebp
  8002ec:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8002ef:	a1 20 50 80 00       	mov    0x805020,%eax
  8002f4:	8b 50 74             	mov    0x74(%eax),%edx
  8002f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002fa:	39 c2                	cmp    %eax,%edx
  8002fc:	74 14                	je     800312 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8002fe:	83 ec 04             	sub    $0x4,%esp
  800301:	68 00 3a 80 00       	push   $0x803a00
  800306:	6a 26                	push   $0x26
  800308:	68 4c 3a 80 00       	push   $0x803a4c
  80030d:	e8 65 ff ff ff       	call   800277 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800312:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800319:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800320:	e9 c2 00 00 00       	jmp    8003e7 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800325:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800328:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80032f:	8b 45 08             	mov    0x8(%ebp),%eax
  800332:	01 d0                	add    %edx,%eax
  800334:	8b 00                	mov    (%eax),%eax
  800336:	85 c0                	test   %eax,%eax
  800338:	75 08                	jne    800342 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80033a:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80033d:	e9 a2 00 00 00       	jmp    8003e4 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800342:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800349:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800350:	eb 69                	jmp    8003bb <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800352:	a1 20 50 80 00       	mov    0x805020,%eax
  800357:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80035d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800360:	89 d0                	mov    %edx,%eax
  800362:	01 c0                	add    %eax,%eax
  800364:	01 d0                	add    %edx,%eax
  800366:	c1 e0 03             	shl    $0x3,%eax
  800369:	01 c8                	add    %ecx,%eax
  80036b:	8a 40 04             	mov    0x4(%eax),%al
  80036e:	84 c0                	test   %al,%al
  800370:	75 46                	jne    8003b8 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800372:	a1 20 50 80 00       	mov    0x805020,%eax
  800377:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80037d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800380:	89 d0                	mov    %edx,%eax
  800382:	01 c0                	add    %eax,%eax
  800384:	01 d0                	add    %edx,%eax
  800386:	c1 e0 03             	shl    $0x3,%eax
  800389:	01 c8                	add    %ecx,%eax
  80038b:	8b 00                	mov    (%eax),%eax
  80038d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800390:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800393:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800398:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80039a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80039d:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a7:	01 c8                	add    %ecx,%eax
  8003a9:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003ab:	39 c2                	cmp    %eax,%edx
  8003ad:	75 09                	jne    8003b8 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8003af:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003b6:	eb 12                	jmp    8003ca <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003b8:	ff 45 e8             	incl   -0x18(%ebp)
  8003bb:	a1 20 50 80 00       	mov    0x805020,%eax
  8003c0:	8b 50 74             	mov    0x74(%eax),%edx
  8003c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003c6:	39 c2                	cmp    %eax,%edx
  8003c8:	77 88                	ja     800352 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003ca:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003ce:	75 14                	jne    8003e4 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8003d0:	83 ec 04             	sub    $0x4,%esp
  8003d3:	68 58 3a 80 00       	push   $0x803a58
  8003d8:	6a 3a                	push   $0x3a
  8003da:	68 4c 3a 80 00       	push   $0x803a4c
  8003df:	e8 93 fe ff ff       	call   800277 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003e4:	ff 45 f0             	incl   -0x10(%ebp)
  8003e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003ea:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003ed:	0f 8c 32 ff ff ff    	jl     800325 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8003f3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003fa:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800401:	eb 26                	jmp    800429 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800403:	a1 20 50 80 00       	mov    0x805020,%eax
  800408:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80040e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800411:	89 d0                	mov    %edx,%eax
  800413:	01 c0                	add    %eax,%eax
  800415:	01 d0                	add    %edx,%eax
  800417:	c1 e0 03             	shl    $0x3,%eax
  80041a:	01 c8                	add    %ecx,%eax
  80041c:	8a 40 04             	mov    0x4(%eax),%al
  80041f:	3c 01                	cmp    $0x1,%al
  800421:	75 03                	jne    800426 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800423:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800426:	ff 45 e0             	incl   -0x20(%ebp)
  800429:	a1 20 50 80 00       	mov    0x805020,%eax
  80042e:	8b 50 74             	mov    0x74(%eax),%edx
  800431:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800434:	39 c2                	cmp    %eax,%edx
  800436:	77 cb                	ja     800403 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800438:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80043b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80043e:	74 14                	je     800454 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800440:	83 ec 04             	sub    $0x4,%esp
  800443:	68 ac 3a 80 00       	push   $0x803aac
  800448:	6a 44                	push   $0x44
  80044a:	68 4c 3a 80 00       	push   $0x803a4c
  80044f:	e8 23 fe ff ff       	call   800277 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800454:	90                   	nop
  800455:	c9                   	leave  
  800456:	c3                   	ret    

00800457 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800457:	55                   	push   %ebp
  800458:	89 e5                	mov    %esp,%ebp
  80045a:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80045d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800460:	8b 00                	mov    (%eax),%eax
  800462:	8d 48 01             	lea    0x1(%eax),%ecx
  800465:	8b 55 0c             	mov    0xc(%ebp),%edx
  800468:	89 0a                	mov    %ecx,(%edx)
  80046a:	8b 55 08             	mov    0x8(%ebp),%edx
  80046d:	88 d1                	mov    %dl,%cl
  80046f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800472:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800476:	8b 45 0c             	mov    0xc(%ebp),%eax
  800479:	8b 00                	mov    (%eax),%eax
  80047b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800480:	75 2c                	jne    8004ae <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800482:	a0 24 50 80 00       	mov    0x805024,%al
  800487:	0f b6 c0             	movzbl %al,%eax
  80048a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80048d:	8b 12                	mov    (%edx),%edx
  80048f:	89 d1                	mov    %edx,%ecx
  800491:	8b 55 0c             	mov    0xc(%ebp),%edx
  800494:	83 c2 08             	add    $0x8,%edx
  800497:	83 ec 04             	sub    $0x4,%esp
  80049a:	50                   	push   %eax
  80049b:	51                   	push   %ecx
  80049c:	52                   	push   %edx
  80049d:	e8 6d 13 00 00       	call   80180f <sys_cputs>
  8004a2:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b1:	8b 40 04             	mov    0x4(%eax),%eax
  8004b4:	8d 50 01             	lea    0x1(%eax),%edx
  8004b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ba:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004bd:	90                   	nop
  8004be:	c9                   	leave  
  8004bf:	c3                   	ret    

008004c0 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004c0:	55                   	push   %ebp
  8004c1:	89 e5                	mov    %esp,%ebp
  8004c3:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004c9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004d0:	00 00 00 
	b.cnt = 0;
  8004d3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004da:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004dd:	ff 75 0c             	pushl  0xc(%ebp)
  8004e0:	ff 75 08             	pushl  0x8(%ebp)
  8004e3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004e9:	50                   	push   %eax
  8004ea:	68 57 04 80 00       	push   $0x800457
  8004ef:	e8 11 02 00 00       	call   800705 <vprintfmt>
  8004f4:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8004f7:	a0 24 50 80 00       	mov    0x805024,%al
  8004fc:	0f b6 c0             	movzbl %al,%eax
  8004ff:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800505:	83 ec 04             	sub    $0x4,%esp
  800508:	50                   	push   %eax
  800509:	52                   	push   %edx
  80050a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800510:	83 c0 08             	add    $0x8,%eax
  800513:	50                   	push   %eax
  800514:	e8 f6 12 00 00       	call   80180f <sys_cputs>
  800519:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80051c:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800523:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800529:	c9                   	leave  
  80052a:	c3                   	ret    

0080052b <cprintf>:

int cprintf(const char *fmt, ...) {
  80052b:	55                   	push   %ebp
  80052c:	89 e5                	mov    %esp,%ebp
  80052e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800531:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800538:	8d 45 0c             	lea    0xc(%ebp),%eax
  80053b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80053e:	8b 45 08             	mov    0x8(%ebp),%eax
  800541:	83 ec 08             	sub    $0x8,%esp
  800544:	ff 75 f4             	pushl  -0xc(%ebp)
  800547:	50                   	push   %eax
  800548:	e8 73 ff ff ff       	call   8004c0 <vcprintf>
  80054d:	83 c4 10             	add    $0x10,%esp
  800550:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800553:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800556:	c9                   	leave  
  800557:	c3                   	ret    

00800558 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800558:	55                   	push   %ebp
  800559:	89 e5                	mov    %esp,%ebp
  80055b:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80055e:	e8 5a 14 00 00       	call   8019bd <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800563:	8d 45 0c             	lea    0xc(%ebp),%eax
  800566:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800569:	8b 45 08             	mov    0x8(%ebp),%eax
  80056c:	83 ec 08             	sub    $0x8,%esp
  80056f:	ff 75 f4             	pushl  -0xc(%ebp)
  800572:	50                   	push   %eax
  800573:	e8 48 ff ff ff       	call   8004c0 <vcprintf>
  800578:	83 c4 10             	add    $0x10,%esp
  80057b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80057e:	e8 54 14 00 00       	call   8019d7 <sys_enable_interrupt>
	return cnt;
  800583:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800586:	c9                   	leave  
  800587:	c3                   	ret    

00800588 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800588:	55                   	push   %ebp
  800589:	89 e5                	mov    %esp,%ebp
  80058b:	53                   	push   %ebx
  80058c:	83 ec 14             	sub    $0x14,%esp
  80058f:	8b 45 10             	mov    0x10(%ebp),%eax
  800592:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800595:	8b 45 14             	mov    0x14(%ebp),%eax
  800598:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80059b:	8b 45 18             	mov    0x18(%ebp),%eax
  80059e:	ba 00 00 00 00       	mov    $0x0,%edx
  8005a3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005a6:	77 55                	ja     8005fd <printnum+0x75>
  8005a8:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005ab:	72 05                	jb     8005b2 <printnum+0x2a>
  8005ad:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005b0:	77 4b                	ja     8005fd <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005b2:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005b5:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005b8:	8b 45 18             	mov    0x18(%ebp),%eax
  8005bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8005c0:	52                   	push   %edx
  8005c1:	50                   	push   %eax
  8005c2:	ff 75 f4             	pushl  -0xc(%ebp)
  8005c5:	ff 75 f0             	pushl  -0x10(%ebp)
  8005c8:	e8 7b 2f 00 00       	call   803548 <__udivdi3>
  8005cd:	83 c4 10             	add    $0x10,%esp
  8005d0:	83 ec 04             	sub    $0x4,%esp
  8005d3:	ff 75 20             	pushl  0x20(%ebp)
  8005d6:	53                   	push   %ebx
  8005d7:	ff 75 18             	pushl  0x18(%ebp)
  8005da:	52                   	push   %edx
  8005db:	50                   	push   %eax
  8005dc:	ff 75 0c             	pushl  0xc(%ebp)
  8005df:	ff 75 08             	pushl  0x8(%ebp)
  8005e2:	e8 a1 ff ff ff       	call   800588 <printnum>
  8005e7:	83 c4 20             	add    $0x20,%esp
  8005ea:	eb 1a                	jmp    800606 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005ec:	83 ec 08             	sub    $0x8,%esp
  8005ef:	ff 75 0c             	pushl  0xc(%ebp)
  8005f2:	ff 75 20             	pushl  0x20(%ebp)
  8005f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f8:	ff d0                	call   *%eax
  8005fa:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005fd:	ff 4d 1c             	decl   0x1c(%ebp)
  800600:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800604:	7f e6                	jg     8005ec <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800606:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800609:	bb 00 00 00 00       	mov    $0x0,%ebx
  80060e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800611:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800614:	53                   	push   %ebx
  800615:	51                   	push   %ecx
  800616:	52                   	push   %edx
  800617:	50                   	push   %eax
  800618:	e8 3b 30 00 00       	call   803658 <__umoddi3>
  80061d:	83 c4 10             	add    $0x10,%esp
  800620:	05 14 3d 80 00       	add    $0x803d14,%eax
  800625:	8a 00                	mov    (%eax),%al
  800627:	0f be c0             	movsbl %al,%eax
  80062a:	83 ec 08             	sub    $0x8,%esp
  80062d:	ff 75 0c             	pushl  0xc(%ebp)
  800630:	50                   	push   %eax
  800631:	8b 45 08             	mov    0x8(%ebp),%eax
  800634:	ff d0                	call   *%eax
  800636:	83 c4 10             	add    $0x10,%esp
}
  800639:	90                   	nop
  80063a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80063d:	c9                   	leave  
  80063e:	c3                   	ret    

0080063f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80063f:	55                   	push   %ebp
  800640:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800642:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800646:	7e 1c                	jle    800664 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800648:	8b 45 08             	mov    0x8(%ebp),%eax
  80064b:	8b 00                	mov    (%eax),%eax
  80064d:	8d 50 08             	lea    0x8(%eax),%edx
  800650:	8b 45 08             	mov    0x8(%ebp),%eax
  800653:	89 10                	mov    %edx,(%eax)
  800655:	8b 45 08             	mov    0x8(%ebp),%eax
  800658:	8b 00                	mov    (%eax),%eax
  80065a:	83 e8 08             	sub    $0x8,%eax
  80065d:	8b 50 04             	mov    0x4(%eax),%edx
  800660:	8b 00                	mov    (%eax),%eax
  800662:	eb 40                	jmp    8006a4 <getuint+0x65>
	else if (lflag)
  800664:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800668:	74 1e                	je     800688 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80066a:	8b 45 08             	mov    0x8(%ebp),%eax
  80066d:	8b 00                	mov    (%eax),%eax
  80066f:	8d 50 04             	lea    0x4(%eax),%edx
  800672:	8b 45 08             	mov    0x8(%ebp),%eax
  800675:	89 10                	mov    %edx,(%eax)
  800677:	8b 45 08             	mov    0x8(%ebp),%eax
  80067a:	8b 00                	mov    (%eax),%eax
  80067c:	83 e8 04             	sub    $0x4,%eax
  80067f:	8b 00                	mov    (%eax),%eax
  800681:	ba 00 00 00 00       	mov    $0x0,%edx
  800686:	eb 1c                	jmp    8006a4 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800688:	8b 45 08             	mov    0x8(%ebp),%eax
  80068b:	8b 00                	mov    (%eax),%eax
  80068d:	8d 50 04             	lea    0x4(%eax),%edx
  800690:	8b 45 08             	mov    0x8(%ebp),%eax
  800693:	89 10                	mov    %edx,(%eax)
  800695:	8b 45 08             	mov    0x8(%ebp),%eax
  800698:	8b 00                	mov    (%eax),%eax
  80069a:	83 e8 04             	sub    $0x4,%eax
  80069d:	8b 00                	mov    (%eax),%eax
  80069f:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006a4:	5d                   	pop    %ebp
  8006a5:	c3                   	ret    

008006a6 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006a6:	55                   	push   %ebp
  8006a7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006a9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006ad:	7e 1c                	jle    8006cb <getint+0x25>
		return va_arg(*ap, long long);
  8006af:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b2:	8b 00                	mov    (%eax),%eax
  8006b4:	8d 50 08             	lea    0x8(%eax),%edx
  8006b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ba:	89 10                	mov    %edx,(%eax)
  8006bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bf:	8b 00                	mov    (%eax),%eax
  8006c1:	83 e8 08             	sub    $0x8,%eax
  8006c4:	8b 50 04             	mov    0x4(%eax),%edx
  8006c7:	8b 00                	mov    (%eax),%eax
  8006c9:	eb 38                	jmp    800703 <getint+0x5d>
	else if (lflag)
  8006cb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006cf:	74 1a                	je     8006eb <getint+0x45>
		return va_arg(*ap, long);
  8006d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d4:	8b 00                	mov    (%eax),%eax
  8006d6:	8d 50 04             	lea    0x4(%eax),%edx
  8006d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006dc:	89 10                	mov    %edx,(%eax)
  8006de:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e1:	8b 00                	mov    (%eax),%eax
  8006e3:	83 e8 04             	sub    $0x4,%eax
  8006e6:	8b 00                	mov    (%eax),%eax
  8006e8:	99                   	cltd   
  8006e9:	eb 18                	jmp    800703 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ee:	8b 00                	mov    (%eax),%eax
  8006f0:	8d 50 04             	lea    0x4(%eax),%edx
  8006f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f6:	89 10                	mov    %edx,(%eax)
  8006f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fb:	8b 00                	mov    (%eax),%eax
  8006fd:	83 e8 04             	sub    $0x4,%eax
  800700:	8b 00                	mov    (%eax),%eax
  800702:	99                   	cltd   
}
  800703:	5d                   	pop    %ebp
  800704:	c3                   	ret    

00800705 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800705:	55                   	push   %ebp
  800706:	89 e5                	mov    %esp,%ebp
  800708:	56                   	push   %esi
  800709:	53                   	push   %ebx
  80070a:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80070d:	eb 17                	jmp    800726 <vprintfmt+0x21>
			if (ch == '\0')
  80070f:	85 db                	test   %ebx,%ebx
  800711:	0f 84 af 03 00 00    	je     800ac6 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800717:	83 ec 08             	sub    $0x8,%esp
  80071a:	ff 75 0c             	pushl  0xc(%ebp)
  80071d:	53                   	push   %ebx
  80071e:	8b 45 08             	mov    0x8(%ebp),%eax
  800721:	ff d0                	call   *%eax
  800723:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800726:	8b 45 10             	mov    0x10(%ebp),%eax
  800729:	8d 50 01             	lea    0x1(%eax),%edx
  80072c:	89 55 10             	mov    %edx,0x10(%ebp)
  80072f:	8a 00                	mov    (%eax),%al
  800731:	0f b6 d8             	movzbl %al,%ebx
  800734:	83 fb 25             	cmp    $0x25,%ebx
  800737:	75 d6                	jne    80070f <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800739:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80073d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800744:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80074b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800752:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800759:	8b 45 10             	mov    0x10(%ebp),%eax
  80075c:	8d 50 01             	lea    0x1(%eax),%edx
  80075f:	89 55 10             	mov    %edx,0x10(%ebp)
  800762:	8a 00                	mov    (%eax),%al
  800764:	0f b6 d8             	movzbl %al,%ebx
  800767:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80076a:	83 f8 55             	cmp    $0x55,%eax
  80076d:	0f 87 2b 03 00 00    	ja     800a9e <vprintfmt+0x399>
  800773:	8b 04 85 38 3d 80 00 	mov    0x803d38(,%eax,4),%eax
  80077a:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80077c:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800780:	eb d7                	jmp    800759 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800782:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800786:	eb d1                	jmp    800759 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800788:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80078f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800792:	89 d0                	mov    %edx,%eax
  800794:	c1 e0 02             	shl    $0x2,%eax
  800797:	01 d0                	add    %edx,%eax
  800799:	01 c0                	add    %eax,%eax
  80079b:	01 d8                	add    %ebx,%eax
  80079d:	83 e8 30             	sub    $0x30,%eax
  8007a0:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8007a6:	8a 00                	mov    (%eax),%al
  8007a8:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007ab:	83 fb 2f             	cmp    $0x2f,%ebx
  8007ae:	7e 3e                	jle    8007ee <vprintfmt+0xe9>
  8007b0:	83 fb 39             	cmp    $0x39,%ebx
  8007b3:	7f 39                	jg     8007ee <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007b5:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007b8:	eb d5                	jmp    80078f <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bd:	83 c0 04             	add    $0x4,%eax
  8007c0:	89 45 14             	mov    %eax,0x14(%ebp)
  8007c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c6:	83 e8 04             	sub    $0x4,%eax
  8007c9:	8b 00                	mov    (%eax),%eax
  8007cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007ce:	eb 1f                	jmp    8007ef <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007d0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007d4:	79 83                	jns    800759 <vprintfmt+0x54>
				width = 0;
  8007d6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007dd:	e9 77 ff ff ff       	jmp    800759 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007e2:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007e9:	e9 6b ff ff ff       	jmp    800759 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007ee:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007ef:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007f3:	0f 89 60 ff ff ff    	jns    800759 <vprintfmt+0x54>
				width = precision, precision = -1;
  8007f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007ff:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800806:	e9 4e ff ff ff       	jmp    800759 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80080b:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80080e:	e9 46 ff ff ff       	jmp    800759 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800813:	8b 45 14             	mov    0x14(%ebp),%eax
  800816:	83 c0 04             	add    $0x4,%eax
  800819:	89 45 14             	mov    %eax,0x14(%ebp)
  80081c:	8b 45 14             	mov    0x14(%ebp),%eax
  80081f:	83 e8 04             	sub    $0x4,%eax
  800822:	8b 00                	mov    (%eax),%eax
  800824:	83 ec 08             	sub    $0x8,%esp
  800827:	ff 75 0c             	pushl  0xc(%ebp)
  80082a:	50                   	push   %eax
  80082b:	8b 45 08             	mov    0x8(%ebp),%eax
  80082e:	ff d0                	call   *%eax
  800830:	83 c4 10             	add    $0x10,%esp
			break;
  800833:	e9 89 02 00 00       	jmp    800ac1 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800838:	8b 45 14             	mov    0x14(%ebp),%eax
  80083b:	83 c0 04             	add    $0x4,%eax
  80083e:	89 45 14             	mov    %eax,0x14(%ebp)
  800841:	8b 45 14             	mov    0x14(%ebp),%eax
  800844:	83 e8 04             	sub    $0x4,%eax
  800847:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800849:	85 db                	test   %ebx,%ebx
  80084b:	79 02                	jns    80084f <vprintfmt+0x14a>
				err = -err;
  80084d:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80084f:	83 fb 64             	cmp    $0x64,%ebx
  800852:	7f 0b                	jg     80085f <vprintfmt+0x15a>
  800854:	8b 34 9d 80 3b 80 00 	mov    0x803b80(,%ebx,4),%esi
  80085b:	85 f6                	test   %esi,%esi
  80085d:	75 19                	jne    800878 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80085f:	53                   	push   %ebx
  800860:	68 25 3d 80 00       	push   $0x803d25
  800865:	ff 75 0c             	pushl  0xc(%ebp)
  800868:	ff 75 08             	pushl  0x8(%ebp)
  80086b:	e8 5e 02 00 00       	call   800ace <printfmt>
  800870:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800873:	e9 49 02 00 00       	jmp    800ac1 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800878:	56                   	push   %esi
  800879:	68 2e 3d 80 00       	push   $0x803d2e
  80087e:	ff 75 0c             	pushl  0xc(%ebp)
  800881:	ff 75 08             	pushl  0x8(%ebp)
  800884:	e8 45 02 00 00       	call   800ace <printfmt>
  800889:	83 c4 10             	add    $0x10,%esp
			break;
  80088c:	e9 30 02 00 00       	jmp    800ac1 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800891:	8b 45 14             	mov    0x14(%ebp),%eax
  800894:	83 c0 04             	add    $0x4,%eax
  800897:	89 45 14             	mov    %eax,0x14(%ebp)
  80089a:	8b 45 14             	mov    0x14(%ebp),%eax
  80089d:	83 e8 04             	sub    $0x4,%eax
  8008a0:	8b 30                	mov    (%eax),%esi
  8008a2:	85 f6                	test   %esi,%esi
  8008a4:	75 05                	jne    8008ab <vprintfmt+0x1a6>
				p = "(null)";
  8008a6:	be 31 3d 80 00       	mov    $0x803d31,%esi
			if (width > 0 && padc != '-')
  8008ab:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008af:	7e 6d                	jle    80091e <vprintfmt+0x219>
  8008b1:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008b5:	74 67                	je     80091e <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008ba:	83 ec 08             	sub    $0x8,%esp
  8008bd:	50                   	push   %eax
  8008be:	56                   	push   %esi
  8008bf:	e8 0c 03 00 00       	call   800bd0 <strnlen>
  8008c4:	83 c4 10             	add    $0x10,%esp
  8008c7:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008ca:	eb 16                	jmp    8008e2 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008cc:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008d0:	83 ec 08             	sub    $0x8,%esp
  8008d3:	ff 75 0c             	pushl  0xc(%ebp)
  8008d6:	50                   	push   %eax
  8008d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008da:	ff d0                	call   *%eax
  8008dc:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008df:	ff 4d e4             	decl   -0x1c(%ebp)
  8008e2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008e6:	7f e4                	jg     8008cc <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008e8:	eb 34                	jmp    80091e <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008ea:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008ee:	74 1c                	je     80090c <vprintfmt+0x207>
  8008f0:	83 fb 1f             	cmp    $0x1f,%ebx
  8008f3:	7e 05                	jle    8008fa <vprintfmt+0x1f5>
  8008f5:	83 fb 7e             	cmp    $0x7e,%ebx
  8008f8:	7e 12                	jle    80090c <vprintfmt+0x207>
					putch('?', putdat);
  8008fa:	83 ec 08             	sub    $0x8,%esp
  8008fd:	ff 75 0c             	pushl  0xc(%ebp)
  800900:	6a 3f                	push   $0x3f
  800902:	8b 45 08             	mov    0x8(%ebp),%eax
  800905:	ff d0                	call   *%eax
  800907:	83 c4 10             	add    $0x10,%esp
  80090a:	eb 0f                	jmp    80091b <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80090c:	83 ec 08             	sub    $0x8,%esp
  80090f:	ff 75 0c             	pushl  0xc(%ebp)
  800912:	53                   	push   %ebx
  800913:	8b 45 08             	mov    0x8(%ebp),%eax
  800916:	ff d0                	call   *%eax
  800918:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80091b:	ff 4d e4             	decl   -0x1c(%ebp)
  80091e:	89 f0                	mov    %esi,%eax
  800920:	8d 70 01             	lea    0x1(%eax),%esi
  800923:	8a 00                	mov    (%eax),%al
  800925:	0f be d8             	movsbl %al,%ebx
  800928:	85 db                	test   %ebx,%ebx
  80092a:	74 24                	je     800950 <vprintfmt+0x24b>
  80092c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800930:	78 b8                	js     8008ea <vprintfmt+0x1e5>
  800932:	ff 4d e0             	decl   -0x20(%ebp)
  800935:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800939:	79 af                	jns    8008ea <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80093b:	eb 13                	jmp    800950 <vprintfmt+0x24b>
				putch(' ', putdat);
  80093d:	83 ec 08             	sub    $0x8,%esp
  800940:	ff 75 0c             	pushl  0xc(%ebp)
  800943:	6a 20                	push   $0x20
  800945:	8b 45 08             	mov    0x8(%ebp),%eax
  800948:	ff d0                	call   *%eax
  80094a:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80094d:	ff 4d e4             	decl   -0x1c(%ebp)
  800950:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800954:	7f e7                	jg     80093d <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800956:	e9 66 01 00 00       	jmp    800ac1 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80095b:	83 ec 08             	sub    $0x8,%esp
  80095e:	ff 75 e8             	pushl  -0x18(%ebp)
  800961:	8d 45 14             	lea    0x14(%ebp),%eax
  800964:	50                   	push   %eax
  800965:	e8 3c fd ff ff       	call   8006a6 <getint>
  80096a:	83 c4 10             	add    $0x10,%esp
  80096d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800970:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800973:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800976:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800979:	85 d2                	test   %edx,%edx
  80097b:	79 23                	jns    8009a0 <vprintfmt+0x29b>
				putch('-', putdat);
  80097d:	83 ec 08             	sub    $0x8,%esp
  800980:	ff 75 0c             	pushl  0xc(%ebp)
  800983:	6a 2d                	push   $0x2d
  800985:	8b 45 08             	mov    0x8(%ebp),%eax
  800988:	ff d0                	call   *%eax
  80098a:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80098d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800990:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800993:	f7 d8                	neg    %eax
  800995:	83 d2 00             	adc    $0x0,%edx
  800998:	f7 da                	neg    %edx
  80099a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80099d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009a0:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009a7:	e9 bc 00 00 00       	jmp    800a68 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009ac:	83 ec 08             	sub    $0x8,%esp
  8009af:	ff 75 e8             	pushl  -0x18(%ebp)
  8009b2:	8d 45 14             	lea    0x14(%ebp),%eax
  8009b5:	50                   	push   %eax
  8009b6:	e8 84 fc ff ff       	call   80063f <getuint>
  8009bb:	83 c4 10             	add    $0x10,%esp
  8009be:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009c1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009c4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009cb:	e9 98 00 00 00       	jmp    800a68 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009d0:	83 ec 08             	sub    $0x8,%esp
  8009d3:	ff 75 0c             	pushl  0xc(%ebp)
  8009d6:	6a 58                	push   $0x58
  8009d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009db:	ff d0                	call   *%eax
  8009dd:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009e0:	83 ec 08             	sub    $0x8,%esp
  8009e3:	ff 75 0c             	pushl  0xc(%ebp)
  8009e6:	6a 58                	push   $0x58
  8009e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009eb:	ff d0                	call   *%eax
  8009ed:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009f0:	83 ec 08             	sub    $0x8,%esp
  8009f3:	ff 75 0c             	pushl  0xc(%ebp)
  8009f6:	6a 58                	push   $0x58
  8009f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fb:	ff d0                	call   *%eax
  8009fd:	83 c4 10             	add    $0x10,%esp
			break;
  800a00:	e9 bc 00 00 00       	jmp    800ac1 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a05:	83 ec 08             	sub    $0x8,%esp
  800a08:	ff 75 0c             	pushl  0xc(%ebp)
  800a0b:	6a 30                	push   $0x30
  800a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a10:	ff d0                	call   *%eax
  800a12:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a15:	83 ec 08             	sub    $0x8,%esp
  800a18:	ff 75 0c             	pushl  0xc(%ebp)
  800a1b:	6a 78                	push   $0x78
  800a1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a20:	ff d0                	call   *%eax
  800a22:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a25:	8b 45 14             	mov    0x14(%ebp),%eax
  800a28:	83 c0 04             	add    $0x4,%eax
  800a2b:	89 45 14             	mov    %eax,0x14(%ebp)
  800a2e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a31:	83 e8 04             	sub    $0x4,%eax
  800a34:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a36:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a39:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a40:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a47:	eb 1f                	jmp    800a68 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a49:	83 ec 08             	sub    $0x8,%esp
  800a4c:	ff 75 e8             	pushl  -0x18(%ebp)
  800a4f:	8d 45 14             	lea    0x14(%ebp),%eax
  800a52:	50                   	push   %eax
  800a53:	e8 e7 fb ff ff       	call   80063f <getuint>
  800a58:	83 c4 10             	add    $0x10,%esp
  800a5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a5e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a61:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a68:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a6f:	83 ec 04             	sub    $0x4,%esp
  800a72:	52                   	push   %edx
  800a73:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a76:	50                   	push   %eax
  800a77:	ff 75 f4             	pushl  -0xc(%ebp)
  800a7a:	ff 75 f0             	pushl  -0x10(%ebp)
  800a7d:	ff 75 0c             	pushl  0xc(%ebp)
  800a80:	ff 75 08             	pushl  0x8(%ebp)
  800a83:	e8 00 fb ff ff       	call   800588 <printnum>
  800a88:	83 c4 20             	add    $0x20,%esp
			break;
  800a8b:	eb 34                	jmp    800ac1 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a8d:	83 ec 08             	sub    $0x8,%esp
  800a90:	ff 75 0c             	pushl  0xc(%ebp)
  800a93:	53                   	push   %ebx
  800a94:	8b 45 08             	mov    0x8(%ebp),%eax
  800a97:	ff d0                	call   *%eax
  800a99:	83 c4 10             	add    $0x10,%esp
			break;
  800a9c:	eb 23                	jmp    800ac1 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800a9e:	83 ec 08             	sub    $0x8,%esp
  800aa1:	ff 75 0c             	pushl  0xc(%ebp)
  800aa4:	6a 25                	push   $0x25
  800aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa9:	ff d0                	call   *%eax
  800aab:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800aae:	ff 4d 10             	decl   0x10(%ebp)
  800ab1:	eb 03                	jmp    800ab6 <vprintfmt+0x3b1>
  800ab3:	ff 4d 10             	decl   0x10(%ebp)
  800ab6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ab9:	48                   	dec    %eax
  800aba:	8a 00                	mov    (%eax),%al
  800abc:	3c 25                	cmp    $0x25,%al
  800abe:	75 f3                	jne    800ab3 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800ac0:	90                   	nop
		}
	}
  800ac1:	e9 47 fc ff ff       	jmp    80070d <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ac6:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ac7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800aca:	5b                   	pop    %ebx
  800acb:	5e                   	pop    %esi
  800acc:	5d                   	pop    %ebp
  800acd:	c3                   	ret    

00800ace <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ace:	55                   	push   %ebp
  800acf:	89 e5                	mov    %esp,%ebp
  800ad1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ad4:	8d 45 10             	lea    0x10(%ebp),%eax
  800ad7:	83 c0 04             	add    $0x4,%eax
  800ada:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800add:	8b 45 10             	mov    0x10(%ebp),%eax
  800ae0:	ff 75 f4             	pushl  -0xc(%ebp)
  800ae3:	50                   	push   %eax
  800ae4:	ff 75 0c             	pushl  0xc(%ebp)
  800ae7:	ff 75 08             	pushl  0x8(%ebp)
  800aea:	e8 16 fc ff ff       	call   800705 <vprintfmt>
  800aef:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800af2:	90                   	nop
  800af3:	c9                   	leave  
  800af4:	c3                   	ret    

00800af5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800af5:	55                   	push   %ebp
  800af6:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800af8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afb:	8b 40 08             	mov    0x8(%eax),%eax
  800afe:	8d 50 01             	lea    0x1(%eax),%edx
  800b01:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b04:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b07:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0a:	8b 10                	mov    (%eax),%edx
  800b0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0f:	8b 40 04             	mov    0x4(%eax),%eax
  800b12:	39 c2                	cmp    %eax,%edx
  800b14:	73 12                	jae    800b28 <sprintputch+0x33>
		*b->buf++ = ch;
  800b16:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b19:	8b 00                	mov    (%eax),%eax
  800b1b:	8d 48 01             	lea    0x1(%eax),%ecx
  800b1e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b21:	89 0a                	mov    %ecx,(%edx)
  800b23:	8b 55 08             	mov    0x8(%ebp),%edx
  800b26:	88 10                	mov    %dl,(%eax)
}
  800b28:	90                   	nop
  800b29:	5d                   	pop    %ebp
  800b2a:	c3                   	ret    

00800b2b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b2b:	55                   	push   %ebp
  800b2c:	89 e5                	mov    %esp,%ebp
  800b2e:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b31:	8b 45 08             	mov    0x8(%ebp),%eax
  800b34:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b40:	01 d0                	add    %edx,%eax
  800b42:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b45:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b4c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b50:	74 06                	je     800b58 <vsnprintf+0x2d>
  800b52:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b56:	7f 07                	jg     800b5f <vsnprintf+0x34>
		return -E_INVAL;
  800b58:	b8 03 00 00 00       	mov    $0x3,%eax
  800b5d:	eb 20                	jmp    800b7f <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b5f:	ff 75 14             	pushl  0x14(%ebp)
  800b62:	ff 75 10             	pushl  0x10(%ebp)
  800b65:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b68:	50                   	push   %eax
  800b69:	68 f5 0a 80 00       	push   $0x800af5
  800b6e:	e8 92 fb ff ff       	call   800705 <vprintfmt>
  800b73:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b76:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b79:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b7f:	c9                   	leave  
  800b80:	c3                   	ret    

00800b81 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b81:	55                   	push   %ebp
  800b82:	89 e5                	mov    %esp,%ebp
  800b84:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b87:	8d 45 10             	lea    0x10(%ebp),%eax
  800b8a:	83 c0 04             	add    $0x4,%eax
  800b8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b90:	8b 45 10             	mov    0x10(%ebp),%eax
  800b93:	ff 75 f4             	pushl  -0xc(%ebp)
  800b96:	50                   	push   %eax
  800b97:	ff 75 0c             	pushl  0xc(%ebp)
  800b9a:	ff 75 08             	pushl  0x8(%ebp)
  800b9d:	e8 89 ff ff ff       	call   800b2b <vsnprintf>
  800ba2:	83 c4 10             	add    $0x10,%esp
  800ba5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800ba8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bab:	c9                   	leave  
  800bac:	c3                   	ret    

00800bad <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800bad:	55                   	push   %ebp
  800bae:	89 e5                	mov    %esp,%ebp
  800bb0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bb3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bba:	eb 06                	jmp    800bc2 <strlen+0x15>
		n++;
  800bbc:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bbf:	ff 45 08             	incl   0x8(%ebp)
  800bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc5:	8a 00                	mov    (%eax),%al
  800bc7:	84 c0                	test   %al,%al
  800bc9:	75 f1                	jne    800bbc <strlen+0xf>
		n++;
	return n;
  800bcb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bce:	c9                   	leave  
  800bcf:	c3                   	ret    

00800bd0 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bd0:	55                   	push   %ebp
  800bd1:	89 e5                	mov    %esp,%ebp
  800bd3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bd6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bdd:	eb 09                	jmp    800be8 <strnlen+0x18>
		n++;
  800bdf:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800be2:	ff 45 08             	incl   0x8(%ebp)
  800be5:	ff 4d 0c             	decl   0xc(%ebp)
  800be8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bec:	74 09                	je     800bf7 <strnlen+0x27>
  800bee:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf1:	8a 00                	mov    (%eax),%al
  800bf3:	84 c0                	test   %al,%al
  800bf5:	75 e8                	jne    800bdf <strnlen+0xf>
		n++;
	return n;
  800bf7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bfa:	c9                   	leave  
  800bfb:	c3                   	ret    

00800bfc <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bfc:	55                   	push   %ebp
  800bfd:	89 e5                	mov    %esp,%ebp
  800bff:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c02:	8b 45 08             	mov    0x8(%ebp),%eax
  800c05:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c08:	90                   	nop
  800c09:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0c:	8d 50 01             	lea    0x1(%eax),%edx
  800c0f:	89 55 08             	mov    %edx,0x8(%ebp)
  800c12:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c15:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c18:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c1b:	8a 12                	mov    (%edx),%dl
  800c1d:	88 10                	mov    %dl,(%eax)
  800c1f:	8a 00                	mov    (%eax),%al
  800c21:	84 c0                	test   %al,%al
  800c23:	75 e4                	jne    800c09 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c25:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c28:	c9                   	leave  
  800c29:	c3                   	ret    

00800c2a <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c2a:	55                   	push   %ebp
  800c2b:	89 e5                	mov    %esp,%ebp
  800c2d:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c30:	8b 45 08             	mov    0x8(%ebp),%eax
  800c33:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c36:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c3d:	eb 1f                	jmp    800c5e <strncpy+0x34>
		*dst++ = *src;
  800c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c42:	8d 50 01             	lea    0x1(%eax),%edx
  800c45:	89 55 08             	mov    %edx,0x8(%ebp)
  800c48:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c4b:	8a 12                	mov    (%edx),%dl
  800c4d:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c52:	8a 00                	mov    (%eax),%al
  800c54:	84 c0                	test   %al,%al
  800c56:	74 03                	je     800c5b <strncpy+0x31>
			src++;
  800c58:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c5b:	ff 45 fc             	incl   -0x4(%ebp)
  800c5e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c61:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c64:	72 d9                	jb     800c3f <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c66:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c69:	c9                   	leave  
  800c6a:	c3                   	ret    

00800c6b <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c6b:	55                   	push   %ebp
  800c6c:	89 e5                	mov    %esp,%ebp
  800c6e:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c71:	8b 45 08             	mov    0x8(%ebp),%eax
  800c74:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c77:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c7b:	74 30                	je     800cad <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c7d:	eb 16                	jmp    800c95 <strlcpy+0x2a>
			*dst++ = *src++;
  800c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c82:	8d 50 01             	lea    0x1(%eax),%edx
  800c85:	89 55 08             	mov    %edx,0x8(%ebp)
  800c88:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c8b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c8e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c91:	8a 12                	mov    (%edx),%dl
  800c93:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c95:	ff 4d 10             	decl   0x10(%ebp)
  800c98:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c9c:	74 09                	je     800ca7 <strlcpy+0x3c>
  800c9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca1:	8a 00                	mov    (%eax),%al
  800ca3:	84 c0                	test   %al,%al
  800ca5:	75 d8                	jne    800c7f <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  800caa:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cad:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cb3:	29 c2                	sub    %eax,%edx
  800cb5:	89 d0                	mov    %edx,%eax
}
  800cb7:	c9                   	leave  
  800cb8:	c3                   	ret    

00800cb9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cb9:	55                   	push   %ebp
  800cba:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cbc:	eb 06                	jmp    800cc4 <strcmp+0xb>
		p++, q++;
  800cbe:	ff 45 08             	incl   0x8(%ebp)
  800cc1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc7:	8a 00                	mov    (%eax),%al
  800cc9:	84 c0                	test   %al,%al
  800ccb:	74 0e                	je     800cdb <strcmp+0x22>
  800ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd0:	8a 10                	mov    (%eax),%dl
  800cd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd5:	8a 00                	mov    (%eax),%al
  800cd7:	38 c2                	cmp    %al,%dl
  800cd9:	74 e3                	je     800cbe <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cde:	8a 00                	mov    (%eax),%al
  800ce0:	0f b6 d0             	movzbl %al,%edx
  800ce3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce6:	8a 00                	mov    (%eax),%al
  800ce8:	0f b6 c0             	movzbl %al,%eax
  800ceb:	29 c2                	sub    %eax,%edx
  800ced:	89 d0                	mov    %edx,%eax
}
  800cef:	5d                   	pop    %ebp
  800cf0:	c3                   	ret    

00800cf1 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800cf1:	55                   	push   %ebp
  800cf2:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800cf4:	eb 09                	jmp    800cff <strncmp+0xe>
		n--, p++, q++;
  800cf6:	ff 4d 10             	decl   0x10(%ebp)
  800cf9:	ff 45 08             	incl   0x8(%ebp)
  800cfc:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800cff:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d03:	74 17                	je     800d1c <strncmp+0x2b>
  800d05:	8b 45 08             	mov    0x8(%ebp),%eax
  800d08:	8a 00                	mov    (%eax),%al
  800d0a:	84 c0                	test   %al,%al
  800d0c:	74 0e                	je     800d1c <strncmp+0x2b>
  800d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d11:	8a 10                	mov    (%eax),%dl
  800d13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d16:	8a 00                	mov    (%eax),%al
  800d18:	38 c2                	cmp    %al,%dl
  800d1a:	74 da                	je     800cf6 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d1c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d20:	75 07                	jne    800d29 <strncmp+0x38>
		return 0;
  800d22:	b8 00 00 00 00       	mov    $0x0,%eax
  800d27:	eb 14                	jmp    800d3d <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d29:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2c:	8a 00                	mov    (%eax),%al
  800d2e:	0f b6 d0             	movzbl %al,%edx
  800d31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d34:	8a 00                	mov    (%eax),%al
  800d36:	0f b6 c0             	movzbl %al,%eax
  800d39:	29 c2                	sub    %eax,%edx
  800d3b:	89 d0                	mov    %edx,%eax
}
  800d3d:	5d                   	pop    %ebp
  800d3e:	c3                   	ret    

00800d3f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d3f:	55                   	push   %ebp
  800d40:	89 e5                	mov    %esp,%ebp
  800d42:	83 ec 04             	sub    $0x4,%esp
  800d45:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d48:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d4b:	eb 12                	jmp    800d5f <strchr+0x20>
		if (*s == c)
  800d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d50:	8a 00                	mov    (%eax),%al
  800d52:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d55:	75 05                	jne    800d5c <strchr+0x1d>
			return (char *) s;
  800d57:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5a:	eb 11                	jmp    800d6d <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d5c:	ff 45 08             	incl   0x8(%ebp)
  800d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d62:	8a 00                	mov    (%eax),%al
  800d64:	84 c0                	test   %al,%al
  800d66:	75 e5                	jne    800d4d <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d68:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d6d:	c9                   	leave  
  800d6e:	c3                   	ret    

00800d6f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d6f:	55                   	push   %ebp
  800d70:	89 e5                	mov    %esp,%ebp
  800d72:	83 ec 04             	sub    $0x4,%esp
  800d75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d78:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d7b:	eb 0d                	jmp    800d8a <strfind+0x1b>
		if (*s == c)
  800d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d80:	8a 00                	mov    (%eax),%al
  800d82:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d85:	74 0e                	je     800d95 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d87:	ff 45 08             	incl   0x8(%ebp)
  800d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8d:	8a 00                	mov    (%eax),%al
  800d8f:	84 c0                	test   %al,%al
  800d91:	75 ea                	jne    800d7d <strfind+0xe>
  800d93:	eb 01                	jmp    800d96 <strfind+0x27>
		if (*s == c)
			break;
  800d95:	90                   	nop
	return (char *) s;
  800d96:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d99:	c9                   	leave  
  800d9a:	c3                   	ret    

00800d9b <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800d9b:	55                   	push   %ebp
  800d9c:	89 e5                	mov    %esp,%ebp
  800d9e:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800da1:	8b 45 08             	mov    0x8(%ebp),%eax
  800da4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800da7:	8b 45 10             	mov    0x10(%ebp),%eax
  800daa:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800dad:	eb 0e                	jmp    800dbd <memset+0x22>
		*p++ = c;
  800daf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800db2:	8d 50 01             	lea    0x1(%eax),%edx
  800db5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800db8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dbb:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800dbd:	ff 4d f8             	decl   -0x8(%ebp)
  800dc0:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800dc4:	79 e9                	jns    800daf <memset+0x14>
		*p++ = c;

	return v;
  800dc6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dc9:	c9                   	leave  
  800dca:	c3                   	ret    

00800dcb <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800dcb:	55                   	push   %ebp
  800dcc:	89 e5                	mov    %esp,%ebp
  800dce:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dda:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800ddd:	eb 16                	jmp    800df5 <memcpy+0x2a>
		*d++ = *s++;
  800ddf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800de2:	8d 50 01             	lea    0x1(%eax),%edx
  800de5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800de8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800deb:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dee:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800df1:	8a 12                	mov    (%edx),%dl
  800df3:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800df5:	8b 45 10             	mov    0x10(%ebp),%eax
  800df8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dfb:	89 55 10             	mov    %edx,0x10(%ebp)
  800dfe:	85 c0                	test   %eax,%eax
  800e00:	75 dd                	jne    800ddf <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e02:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e05:	c9                   	leave  
  800e06:	c3                   	ret    

00800e07 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e07:	55                   	push   %ebp
  800e08:	89 e5                	mov    %esp,%ebp
  800e0a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e10:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e13:	8b 45 08             	mov    0x8(%ebp),%eax
  800e16:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e19:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e1c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e1f:	73 50                	jae    800e71 <memmove+0x6a>
  800e21:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e24:	8b 45 10             	mov    0x10(%ebp),%eax
  800e27:	01 d0                	add    %edx,%eax
  800e29:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e2c:	76 43                	jbe    800e71 <memmove+0x6a>
		s += n;
  800e2e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e31:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e34:	8b 45 10             	mov    0x10(%ebp),%eax
  800e37:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e3a:	eb 10                	jmp    800e4c <memmove+0x45>
			*--d = *--s;
  800e3c:	ff 4d f8             	decl   -0x8(%ebp)
  800e3f:	ff 4d fc             	decl   -0x4(%ebp)
  800e42:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e45:	8a 10                	mov    (%eax),%dl
  800e47:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e4a:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e4c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e4f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e52:	89 55 10             	mov    %edx,0x10(%ebp)
  800e55:	85 c0                	test   %eax,%eax
  800e57:	75 e3                	jne    800e3c <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e59:	eb 23                	jmp    800e7e <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e5b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e5e:	8d 50 01             	lea    0x1(%eax),%edx
  800e61:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e64:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e67:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e6a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e6d:	8a 12                	mov    (%edx),%dl
  800e6f:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e71:	8b 45 10             	mov    0x10(%ebp),%eax
  800e74:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e77:	89 55 10             	mov    %edx,0x10(%ebp)
  800e7a:	85 c0                	test   %eax,%eax
  800e7c:	75 dd                	jne    800e5b <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e7e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e81:	c9                   	leave  
  800e82:	c3                   	ret    

00800e83 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e83:	55                   	push   %ebp
  800e84:	89 e5                	mov    %esp,%ebp
  800e86:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e89:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e92:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e95:	eb 2a                	jmp    800ec1 <memcmp+0x3e>
		if (*s1 != *s2)
  800e97:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e9a:	8a 10                	mov    (%eax),%dl
  800e9c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e9f:	8a 00                	mov    (%eax),%al
  800ea1:	38 c2                	cmp    %al,%dl
  800ea3:	74 16                	je     800ebb <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ea5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea8:	8a 00                	mov    (%eax),%al
  800eaa:	0f b6 d0             	movzbl %al,%edx
  800ead:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eb0:	8a 00                	mov    (%eax),%al
  800eb2:	0f b6 c0             	movzbl %al,%eax
  800eb5:	29 c2                	sub    %eax,%edx
  800eb7:	89 d0                	mov    %edx,%eax
  800eb9:	eb 18                	jmp    800ed3 <memcmp+0x50>
		s1++, s2++;
  800ebb:	ff 45 fc             	incl   -0x4(%ebp)
  800ebe:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ec1:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ec7:	89 55 10             	mov    %edx,0x10(%ebp)
  800eca:	85 c0                	test   %eax,%eax
  800ecc:	75 c9                	jne    800e97 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ece:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ed3:	c9                   	leave  
  800ed4:	c3                   	ret    

00800ed5 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800ed5:	55                   	push   %ebp
  800ed6:	89 e5                	mov    %esp,%ebp
  800ed8:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800edb:	8b 55 08             	mov    0x8(%ebp),%edx
  800ede:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee1:	01 d0                	add    %edx,%eax
  800ee3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800ee6:	eb 15                	jmp    800efd <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  800eeb:	8a 00                	mov    (%eax),%al
  800eed:	0f b6 d0             	movzbl %al,%edx
  800ef0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef3:	0f b6 c0             	movzbl %al,%eax
  800ef6:	39 c2                	cmp    %eax,%edx
  800ef8:	74 0d                	je     800f07 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800efa:	ff 45 08             	incl   0x8(%ebp)
  800efd:	8b 45 08             	mov    0x8(%ebp),%eax
  800f00:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f03:	72 e3                	jb     800ee8 <memfind+0x13>
  800f05:	eb 01                	jmp    800f08 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f07:	90                   	nop
	return (void *) s;
  800f08:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f0b:	c9                   	leave  
  800f0c:	c3                   	ret    

00800f0d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f0d:	55                   	push   %ebp
  800f0e:	89 e5                	mov    %esp,%ebp
  800f10:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f13:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f1a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f21:	eb 03                	jmp    800f26 <strtol+0x19>
		s++;
  800f23:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f26:	8b 45 08             	mov    0x8(%ebp),%eax
  800f29:	8a 00                	mov    (%eax),%al
  800f2b:	3c 20                	cmp    $0x20,%al
  800f2d:	74 f4                	je     800f23 <strtol+0x16>
  800f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f32:	8a 00                	mov    (%eax),%al
  800f34:	3c 09                	cmp    $0x9,%al
  800f36:	74 eb                	je     800f23 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f38:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3b:	8a 00                	mov    (%eax),%al
  800f3d:	3c 2b                	cmp    $0x2b,%al
  800f3f:	75 05                	jne    800f46 <strtol+0x39>
		s++;
  800f41:	ff 45 08             	incl   0x8(%ebp)
  800f44:	eb 13                	jmp    800f59 <strtol+0x4c>
	else if (*s == '-')
  800f46:	8b 45 08             	mov    0x8(%ebp),%eax
  800f49:	8a 00                	mov    (%eax),%al
  800f4b:	3c 2d                	cmp    $0x2d,%al
  800f4d:	75 0a                	jne    800f59 <strtol+0x4c>
		s++, neg = 1;
  800f4f:	ff 45 08             	incl   0x8(%ebp)
  800f52:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f59:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f5d:	74 06                	je     800f65 <strtol+0x58>
  800f5f:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f63:	75 20                	jne    800f85 <strtol+0x78>
  800f65:	8b 45 08             	mov    0x8(%ebp),%eax
  800f68:	8a 00                	mov    (%eax),%al
  800f6a:	3c 30                	cmp    $0x30,%al
  800f6c:	75 17                	jne    800f85 <strtol+0x78>
  800f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f71:	40                   	inc    %eax
  800f72:	8a 00                	mov    (%eax),%al
  800f74:	3c 78                	cmp    $0x78,%al
  800f76:	75 0d                	jne    800f85 <strtol+0x78>
		s += 2, base = 16;
  800f78:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f7c:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f83:	eb 28                	jmp    800fad <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f85:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f89:	75 15                	jne    800fa0 <strtol+0x93>
  800f8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8e:	8a 00                	mov    (%eax),%al
  800f90:	3c 30                	cmp    $0x30,%al
  800f92:	75 0c                	jne    800fa0 <strtol+0x93>
		s++, base = 8;
  800f94:	ff 45 08             	incl   0x8(%ebp)
  800f97:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f9e:	eb 0d                	jmp    800fad <strtol+0xa0>
	else if (base == 0)
  800fa0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fa4:	75 07                	jne    800fad <strtol+0xa0>
		base = 10;
  800fa6:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fad:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb0:	8a 00                	mov    (%eax),%al
  800fb2:	3c 2f                	cmp    $0x2f,%al
  800fb4:	7e 19                	jle    800fcf <strtol+0xc2>
  800fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb9:	8a 00                	mov    (%eax),%al
  800fbb:	3c 39                	cmp    $0x39,%al
  800fbd:	7f 10                	jg     800fcf <strtol+0xc2>
			dig = *s - '0';
  800fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc2:	8a 00                	mov    (%eax),%al
  800fc4:	0f be c0             	movsbl %al,%eax
  800fc7:	83 e8 30             	sub    $0x30,%eax
  800fca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fcd:	eb 42                	jmp    801011 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd2:	8a 00                	mov    (%eax),%al
  800fd4:	3c 60                	cmp    $0x60,%al
  800fd6:	7e 19                	jle    800ff1 <strtol+0xe4>
  800fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdb:	8a 00                	mov    (%eax),%al
  800fdd:	3c 7a                	cmp    $0x7a,%al
  800fdf:	7f 10                	jg     800ff1 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe4:	8a 00                	mov    (%eax),%al
  800fe6:	0f be c0             	movsbl %al,%eax
  800fe9:	83 e8 57             	sub    $0x57,%eax
  800fec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fef:	eb 20                	jmp    801011 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff4:	8a 00                	mov    (%eax),%al
  800ff6:	3c 40                	cmp    $0x40,%al
  800ff8:	7e 39                	jle    801033 <strtol+0x126>
  800ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffd:	8a 00                	mov    (%eax),%al
  800fff:	3c 5a                	cmp    $0x5a,%al
  801001:	7f 30                	jg     801033 <strtol+0x126>
			dig = *s - 'A' + 10;
  801003:	8b 45 08             	mov    0x8(%ebp),%eax
  801006:	8a 00                	mov    (%eax),%al
  801008:	0f be c0             	movsbl %al,%eax
  80100b:	83 e8 37             	sub    $0x37,%eax
  80100e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801011:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801014:	3b 45 10             	cmp    0x10(%ebp),%eax
  801017:	7d 19                	jge    801032 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801019:	ff 45 08             	incl   0x8(%ebp)
  80101c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80101f:	0f af 45 10          	imul   0x10(%ebp),%eax
  801023:	89 c2                	mov    %eax,%edx
  801025:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801028:	01 d0                	add    %edx,%eax
  80102a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80102d:	e9 7b ff ff ff       	jmp    800fad <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801032:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801033:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801037:	74 08                	je     801041 <strtol+0x134>
		*endptr = (char *) s;
  801039:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103c:	8b 55 08             	mov    0x8(%ebp),%edx
  80103f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801041:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801045:	74 07                	je     80104e <strtol+0x141>
  801047:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80104a:	f7 d8                	neg    %eax
  80104c:	eb 03                	jmp    801051 <strtol+0x144>
  80104e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801051:	c9                   	leave  
  801052:	c3                   	ret    

00801053 <ltostr>:

void
ltostr(long value, char *str)
{
  801053:	55                   	push   %ebp
  801054:	89 e5                	mov    %esp,%ebp
  801056:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801059:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801060:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801067:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80106b:	79 13                	jns    801080 <ltostr+0x2d>
	{
		neg = 1;
  80106d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801074:	8b 45 0c             	mov    0xc(%ebp),%eax
  801077:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80107a:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80107d:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801080:	8b 45 08             	mov    0x8(%ebp),%eax
  801083:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801088:	99                   	cltd   
  801089:	f7 f9                	idiv   %ecx
  80108b:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80108e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801091:	8d 50 01             	lea    0x1(%eax),%edx
  801094:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801097:	89 c2                	mov    %eax,%edx
  801099:	8b 45 0c             	mov    0xc(%ebp),%eax
  80109c:	01 d0                	add    %edx,%eax
  80109e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010a1:	83 c2 30             	add    $0x30,%edx
  8010a4:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010a6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010a9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010ae:	f7 e9                	imul   %ecx
  8010b0:	c1 fa 02             	sar    $0x2,%edx
  8010b3:	89 c8                	mov    %ecx,%eax
  8010b5:	c1 f8 1f             	sar    $0x1f,%eax
  8010b8:	29 c2                	sub    %eax,%edx
  8010ba:	89 d0                	mov    %edx,%eax
  8010bc:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010c2:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010c7:	f7 e9                	imul   %ecx
  8010c9:	c1 fa 02             	sar    $0x2,%edx
  8010cc:	89 c8                	mov    %ecx,%eax
  8010ce:	c1 f8 1f             	sar    $0x1f,%eax
  8010d1:	29 c2                	sub    %eax,%edx
  8010d3:	89 d0                	mov    %edx,%eax
  8010d5:	c1 e0 02             	shl    $0x2,%eax
  8010d8:	01 d0                	add    %edx,%eax
  8010da:	01 c0                	add    %eax,%eax
  8010dc:	29 c1                	sub    %eax,%ecx
  8010de:	89 ca                	mov    %ecx,%edx
  8010e0:	85 d2                	test   %edx,%edx
  8010e2:	75 9c                	jne    801080 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010e4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ee:	48                   	dec    %eax
  8010ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010f2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010f6:	74 3d                	je     801135 <ltostr+0xe2>
		start = 1 ;
  8010f8:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8010ff:	eb 34                	jmp    801135 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801101:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801104:	8b 45 0c             	mov    0xc(%ebp),%eax
  801107:	01 d0                	add    %edx,%eax
  801109:	8a 00                	mov    (%eax),%al
  80110b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80110e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801111:	8b 45 0c             	mov    0xc(%ebp),%eax
  801114:	01 c2                	add    %eax,%edx
  801116:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801119:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111c:	01 c8                	add    %ecx,%eax
  80111e:	8a 00                	mov    (%eax),%al
  801120:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801122:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801125:	8b 45 0c             	mov    0xc(%ebp),%eax
  801128:	01 c2                	add    %eax,%edx
  80112a:	8a 45 eb             	mov    -0x15(%ebp),%al
  80112d:	88 02                	mov    %al,(%edx)
		start++ ;
  80112f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801132:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801135:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801138:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80113b:	7c c4                	jl     801101 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80113d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801140:	8b 45 0c             	mov    0xc(%ebp),%eax
  801143:	01 d0                	add    %edx,%eax
  801145:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801148:	90                   	nop
  801149:	c9                   	leave  
  80114a:	c3                   	ret    

0080114b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80114b:	55                   	push   %ebp
  80114c:	89 e5                	mov    %esp,%ebp
  80114e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801151:	ff 75 08             	pushl  0x8(%ebp)
  801154:	e8 54 fa ff ff       	call   800bad <strlen>
  801159:	83 c4 04             	add    $0x4,%esp
  80115c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80115f:	ff 75 0c             	pushl  0xc(%ebp)
  801162:	e8 46 fa ff ff       	call   800bad <strlen>
  801167:	83 c4 04             	add    $0x4,%esp
  80116a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80116d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801174:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80117b:	eb 17                	jmp    801194 <strcconcat+0x49>
		final[s] = str1[s] ;
  80117d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801180:	8b 45 10             	mov    0x10(%ebp),%eax
  801183:	01 c2                	add    %eax,%edx
  801185:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801188:	8b 45 08             	mov    0x8(%ebp),%eax
  80118b:	01 c8                	add    %ecx,%eax
  80118d:	8a 00                	mov    (%eax),%al
  80118f:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801191:	ff 45 fc             	incl   -0x4(%ebp)
  801194:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801197:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80119a:	7c e1                	jl     80117d <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80119c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011a3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011aa:	eb 1f                	jmp    8011cb <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011af:	8d 50 01             	lea    0x1(%eax),%edx
  8011b2:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011b5:	89 c2                	mov    %eax,%edx
  8011b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ba:	01 c2                	add    %eax,%edx
  8011bc:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c2:	01 c8                	add    %ecx,%eax
  8011c4:	8a 00                	mov    (%eax),%al
  8011c6:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011c8:	ff 45 f8             	incl   -0x8(%ebp)
  8011cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011ce:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011d1:	7c d9                	jl     8011ac <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011d3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d9:	01 d0                	add    %edx,%eax
  8011db:	c6 00 00             	movb   $0x0,(%eax)
}
  8011de:	90                   	nop
  8011df:	c9                   	leave  
  8011e0:	c3                   	ret    

008011e1 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011e1:	55                   	push   %ebp
  8011e2:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8011e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8011f0:	8b 00                	mov    (%eax),%eax
  8011f2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8011fc:	01 d0                	add    %edx,%eax
  8011fe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801204:	eb 0c                	jmp    801212 <strsplit+0x31>
			*string++ = 0;
  801206:	8b 45 08             	mov    0x8(%ebp),%eax
  801209:	8d 50 01             	lea    0x1(%eax),%edx
  80120c:	89 55 08             	mov    %edx,0x8(%ebp)
  80120f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801212:	8b 45 08             	mov    0x8(%ebp),%eax
  801215:	8a 00                	mov    (%eax),%al
  801217:	84 c0                	test   %al,%al
  801219:	74 18                	je     801233 <strsplit+0x52>
  80121b:	8b 45 08             	mov    0x8(%ebp),%eax
  80121e:	8a 00                	mov    (%eax),%al
  801220:	0f be c0             	movsbl %al,%eax
  801223:	50                   	push   %eax
  801224:	ff 75 0c             	pushl  0xc(%ebp)
  801227:	e8 13 fb ff ff       	call   800d3f <strchr>
  80122c:	83 c4 08             	add    $0x8,%esp
  80122f:	85 c0                	test   %eax,%eax
  801231:	75 d3                	jne    801206 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801233:	8b 45 08             	mov    0x8(%ebp),%eax
  801236:	8a 00                	mov    (%eax),%al
  801238:	84 c0                	test   %al,%al
  80123a:	74 5a                	je     801296 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80123c:	8b 45 14             	mov    0x14(%ebp),%eax
  80123f:	8b 00                	mov    (%eax),%eax
  801241:	83 f8 0f             	cmp    $0xf,%eax
  801244:	75 07                	jne    80124d <strsplit+0x6c>
		{
			return 0;
  801246:	b8 00 00 00 00       	mov    $0x0,%eax
  80124b:	eb 66                	jmp    8012b3 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80124d:	8b 45 14             	mov    0x14(%ebp),%eax
  801250:	8b 00                	mov    (%eax),%eax
  801252:	8d 48 01             	lea    0x1(%eax),%ecx
  801255:	8b 55 14             	mov    0x14(%ebp),%edx
  801258:	89 0a                	mov    %ecx,(%edx)
  80125a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801261:	8b 45 10             	mov    0x10(%ebp),%eax
  801264:	01 c2                	add    %eax,%edx
  801266:	8b 45 08             	mov    0x8(%ebp),%eax
  801269:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80126b:	eb 03                	jmp    801270 <strsplit+0x8f>
			string++;
  80126d:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801270:	8b 45 08             	mov    0x8(%ebp),%eax
  801273:	8a 00                	mov    (%eax),%al
  801275:	84 c0                	test   %al,%al
  801277:	74 8b                	je     801204 <strsplit+0x23>
  801279:	8b 45 08             	mov    0x8(%ebp),%eax
  80127c:	8a 00                	mov    (%eax),%al
  80127e:	0f be c0             	movsbl %al,%eax
  801281:	50                   	push   %eax
  801282:	ff 75 0c             	pushl  0xc(%ebp)
  801285:	e8 b5 fa ff ff       	call   800d3f <strchr>
  80128a:	83 c4 08             	add    $0x8,%esp
  80128d:	85 c0                	test   %eax,%eax
  80128f:	74 dc                	je     80126d <strsplit+0x8c>
			string++;
	}
  801291:	e9 6e ff ff ff       	jmp    801204 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801296:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801297:	8b 45 14             	mov    0x14(%ebp),%eax
  80129a:	8b 00                	mov    (%eax),%eax
  80129c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a6:	01 d0                	add    %edx,%eax
  8012a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012ae:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012b3:	c9                   	leave  
  8012b4:	c3                   	ret    

008012b5 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8012b5:	55                   	push   %ebp
  8012b6:	89 e5                	mov    %esp,%ebp
  8012b8:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8012bb:	a1 04 50 80 00       	mov    0x805004,%eax
  8012c0:	85 c0                	test   %eax,%eax
  8012c2:	74 1f                	je     8012e3 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8012c4:	e8 1d 00 00 00       	call   8012e6 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8012c9:	83 ec 0c             	sub    $0xc,%esp
  8012cc:	68 90 3e 80 00       	push   $0x803e90
  8012d1:	e8 55 f2 ff ff       	call   80052b <cprintf>
  8012d6:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8012d9:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  8012e0:	00 00 00 
	}
}
  8012e3:	90                   	nop
  8012e4:	c9                   	leave  
  8012e5:	c3                   	ret    

008012e6 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8012e6:	55                   	push   %ebp
  8012e7:	89 e5                	mov    %esp,%ebp
  8012e9:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	LIST_INIT(&AllocMemBlocksList);
  8012ec:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  8012f3:	00 00 00 
  8012f6:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  8012fd:	00 00 00 
  801300:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801307:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  80130a:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801311:	00 00 00 
  801314:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  80131b:	00 00 00 
  80131e:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801325:	00 00 00 
	uint32 arr_size = 0;
  801328:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	MemBlockNodes  =(struct MemBlock*) USER_DYN_BLKS_ARRAY;
  80132f:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801336:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801339:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80133e:	2d 00 10 00 00       	sub    $0x1000,%eax
  801343:	a3 50 50 80 00       	mov    %eax,0x805050
	MAX_MEM_BLOCK_CNT = (USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE;
  801348:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  80134f:	00 02 00 
	arr_size =  ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock), PAGE_SIZE);
  801352:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801359:	a1 20 51 80 00       	mov    0x805120,%eax
  80135e:	c1 e0 04             	shl    $0x4,%eax
  801361:	89 c2                	mov    %eax,%edx
  801363:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801366:	01 d0                	add    %edx,%eax
  801368:	48                   	dec    %eax
  801369:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80136c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80136f:	ba 00 00 00 00       	mov    $0x0,%edx
  801374:	f7 75 ec             	divl   -0x14(%ebp)
  801377:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80137a:	29 d0                	sub    %edx,%eax
  80137c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_USER);
  80137f:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801386:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801389:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80138e:	2d 00 10 00 00       	sub    $0x1000,%eax
  801393:	83 ec 04             	sub    $0x4,%esp
  801396:	6a 06                	push   $0x6
  801398:	ff 75 f4             	pushl  -0xc(%ebp)
  80139b:	50                   	push   %eax
  80139c:	e8 b2 05 00 00       	call   801953 <sys_allocate_chunk>
  8013a1:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013a4:	a1 20 51 80 00       	mov    0x805120,%eax
  8013a9:	83 ec 0c             	sub    $0xc,%esp
  8013ac:	50                   	push   %eax
  8013ad:	e8 27 0c 00 00       	call   801fd9 <initialize_MemBlocksList>
  8013b2:	83 c4 10             	add    $0x10,%esp
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	struct MemBlock * NewBlock = LIST_FIRST(&AvailableMemBlocksList);
  8013b5:	a1 48 51 80 00       	mov    0x805148,%eax
  8013ba:	89 45 e0             	mov    %eax,-0x20(%ebp)
	NewBlock->sva = USER_HEAP_START;
  8013bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013c0:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	NewBlock->size = (USER_HEAP_MAX-USER_HEAP_START);
  8013c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013ca:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	LIST_REMOVE(&AvailableMemBlocksList,NewBlock);
  8013d1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8013d5:	75 14                	jne    8013eb <initialize_dyn_block_system+0x105>
  8013d7:	83 ec 04             	sub    $0x4,%esp
  8013da:	68 b5 3e 80 00       	push   $0x803eb5
  8013df:	6a 33                	push   $0x33
  8013e1:	68 d3 3e 80 00       	push   $0x803ed3
  8013e6:	e8 8c ee ff ff       	call   800277 <_panic>
  8013eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013ee:	8b 00                	mov    (%eax),%eax
  8013f0:	85 c0                	test   %eax,%eax
  8013f2:	74 10                	je     801404 <initialize_dyn_block_system+0x11e>
  8013f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013f7:	8b 00                	mov    (%eax),%eax
  8013f9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8013fc:	8b 52 04             	mov    0x4(%edx),%edx
  8013ff:	89 50 04             	mov    %edx,0x4(%eax)
  801402:	eb 0b                	jmp    80140f <initialize_dyn_block_system+0x129>
  801404:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801407:	8b 40 04             	mov    0x4(%eax),%eax
  80140a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80140f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801412:	8b 40 04             	mov    0x4(%eax),%eax
  801415:	85 c0                	test   %eax,%eax
  801417:	74 0f                	je     801428 <initialize_dyn_block_system+0x142>
  801419:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80141c:	8b 40 04             	mov    0x4(%eax),%eax
  80141f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801422:	8b 12                	mov    (%edx),%edx
  801424:	89 10                	mov    %edx,(%eax)
  801426:	eb 0a                	jmp    801432 <initialize_dyn_block_system+0x14c>
  801428:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80142b:	8b 00                	mov    (%eax),%eax
  80142d:	a3 48 51 80 00       	mov    %eax,0x805148
  801432:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801435:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80143b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80143e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801445:	a1 54 51 80 00       	mov    0x805154,%eax
  80144a:	48                   	dec    %eax
  80144b:	a3 54 51 80 00       	mov    %eax,0x805154
	LIST_INSERT_HEAD(&FreeMemBlocksList, NewBlock);
  801450:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801454:	75 14                	jne    80146a <initialize_dyn_block_system+0x184>
  801456:	83 ec 04             	sub    $0x4,%esp
  801459:	68 e0 3e 80 00       	push   $0x803ee0
  80145e:	6a 34                	push   $0x34
  801460:	68 d3 3e 80 00       	push   $0x803ed3
  801465:	e8 0d ee ff ff       	call   800277 <_panic>
  80146a:	8b 15 38 51 80 00    	mov    0x805138,%edx
  801470:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801473:	89 10                	mov    %edx,(%eax)
  801475:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801478:	8b 00                	mov    (%eax),%eax
  80147a:	85 c0                	test   %eax,%eax
  80147c:	74 0d                	je     80148b <initialize_dyn_block_system+0x1a5>
  80147e:	a1 38 51 80 00       	mov    0x805138,%eax
  801483:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801486:	89 50 04             	mov    %edx,0x4(%eax)
  801489:	eb 08                	jmp    801493 <initialize_dyn_block_system+0x1ad>
  80148b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80148e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  801493:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801496:	a3 38 51 80 00       	mov    %eax,0x805138
  80149b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80149e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8014a5:	a1 44 51 80 00       	mov    0x805144,%eax
  8014aa:	40                   	inc    %eax
  8014ab:	a3 44 51 80 00       	mov    %eax,0x805144
}
  8014b0:	90                   	nop
  8014b1:	c9                   	leave  
  8014b2:	c3                   	ret    

008014b3 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8014b3:	55                   	push   %ebp
  8014b4:	89 e5                	mov    %esp,%ebp
  8014b6:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8014b9:	e8 f7 fd ff ff       	call   8012b5 <InitializeUHeap>
	if (size == 0) return NULL ;
  8014be:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014c2:	75 07                	jne    8014cb <malloc+0x18>
  8014c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8014c9:	eb 61                	jmp    80152c <malloc+0x79>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
	uint32 malloc_allocsize=ROUNDUP(size,PAGE_SIZE);
  8014cb:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8014d2:	8b 55 08             	mov    0x8(%ebp),%edx
  8014d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014d8:	01 d0                	add    %edx,%eax
  8014da:	48                   	dec    %eax
  8014db:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8014de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8014e6:	f7 75 f0             	divl   -0x10(%ebp)
  8014e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014ec:	29 d0                	sub    %edx,%eax
  8014ee:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 //int ret=0;
	struct MemBlock * user_block;
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8014f1:	e8 2b 08 00 00       	call   801d21 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014f6:	85 c0                	test   %eax,%eax
  8014f8:	74 11                	je     80150b <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  8014fa:	83 ec 0c             	sub    $0xc,%esp
  8014fd:	ff 75 e8             	pushl  -0x18(%ebp)
  801500:	e8 96 0e 00 00       	call   80239b <alloc_block_FF>
  801505:	83 c4 10             	add    $0x10,%esp
  801508:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(user_block!=NULL)
  80150b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80150f:	74 16                	je     801527 <malloc+0x74>
	{
		//sys_allocate_chunk(user_block->sva,malloc_allocsize,PERM_WRITEABLE| PERM_PRESENT);
		insert_sorted_allocList(user_block);
  801511:	83 ec 0c             	sub    $0xc,%esp
  801514:	ff 75 f4             	pushl  -0xc(%ebp)
  801517:	e8 f2 0b 00 00       	call   80210e <insert_sorted_allocList>
  80151c:	83 c4 10             	add    $0x10,%esp
		return (uint32 *)user_block->sva;
  80151f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801522:	8b 40 08             	mov    0x8(%eax),%eax
  801525:	eb 05                	jmp    80152c <malloc+0x79>
	}

    return NULL;
  801527:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80152c:	c9                   	leave  
  80152d:	c3                   	ret    

0080152e <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80152e:	55                   	push   %ebp
  80152f:	89 e5                	mov    %esp,%ebp
  801531:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	struct MemBlock * free_block=find_block(&AllocMemBlocksList,(uint32)virtual_address);
  801534:	8b 45 08             	mov    0x8(%ebp),%eax
  801537:	83 ec 08             	sub    $0x8,%esp
  80153a:	50                   	push   %eax
  80153b:	68 40 50 80 00       	push   $0x805040
  801540:	e8 71 0b 00 00       	call   8020b6 <find_block>
  801545:	83 c4 10             	add    $0x10,%esp
  801548:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(free_block!=NULL)
  80154b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80154f:	0f 84 a6 00 00 00    	je     8015fb <free+0xcd>
	{
		sys_free_user_mem(free_block->sva,free_block->size);
  801555:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801558:	8b 50 0c             	mov    0xc(%eax),%edx
  80155b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80155e:	8b 40 08             	mov    0x8(%eax),%eax
  801561:	83 ec 08             	sub    $0x8,%esp
  801564:	52                   	push   %edx
  801565:	50                   	push   %eax
  801566:	e8 b0 03 00 00       	call   80191b <sys_free_user_mem>
  80156b:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,free_block);
  80156e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801572:	75 14                	jne    801588 <free+0x5a>
  801574:	83 ec 04             	sub    $0x4,%esp
  801577:	68 b5 3e 80 00       	push   $0x803eb5
  80157c:	6a 74                	push   $0x74
  80157e:	68 d3 3e 80 00       	push   $0x803ed3
  801583:	e8 ef ec ff ff       	call   800277 <_panic>
  801588:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80158b:	8b 00                	mov    (%eax),%eax
  80158d:	85 c0                	test   %eax,%eax
  80158f:	74 10                	je     8015a1 <free+0x73>
  801591:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801594:	8b 00                	mov    (%eax),%eax
  801596:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801599:	8b 52 04             	mov    0x4(%edx),%edx
  80159c:	89 50 04             	mov    %edx,0x4(%eax)
  80159f:	eb 0b                	jmp    8015ac <free+0x7e>
  8015a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015a4:	8b 40 04             	mov    0x4(%eax),%eax
  8015a7:	a3 44 50 80 00       	mov    %eax,0x805044
  8015ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015af:	8b 40 04             	mov    0x4(%eax),%eax
  8015b2:	85 c0                	test   %eax,%eax
  8015b4:	74 0f                	je     8015c5 <free+0x97>
  8015b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015b9:	8b 40 04             	mov    0x4(%eax),%eax
  8015bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015bf:	8b 12                	mov    (%edx),%edx
  8015c1:	89 10                	mov    %edx,(%eax)
  8015c3:	eb 0a                	jmp    8015cf <free+0xa1>
  8015c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015c8:	8b 00                	mov    (%eax),%eax
  8015ca:	a3 40 50 80 00       	mov    %eax,0x805040
  8015cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015d2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8015d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015db:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8015e2:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8015e7:	48                   	dec    %eax
  8015e8:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(free_block);
  8015ed:	83 ec 0c             	sub    $0xc,%esp
  8015f0:	ff 75 f4             	pushl  -0xc(%ebp)
  8015f3:	e8 4e 17 00 00       	call   802d46 <insert_sorted_with_merge_freeList>
  8015f8:	83 c4 10             	add    $0x10,%esp
	}

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  8015fb:	90                   	nop
  8015fc:	c9                   	leave  
  8015fd:	c3                   	ret    

008015fe <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8015fe:	55                   	push   %ebp
  8015ff:	89 e5                	mov    %esp,%ebp
  801601:	83 ec 38             	sub    $0x38,%esp
  801604:	8b 45 10             	mov    0x10(%ebp),%eax
  801607:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80160a:	e8 a6 fc ff ff       	call   8012b5 <InitializeUHeap>
	if (size == 0) return NULL ;
  80160f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801613:	75 0a                	jne    80161f <smalloc+0x21>
  801615:	b8 00 00 00 00       	mov    $0x0,%eax
  80161a:	e9 8b 00 00 00       	jmp    8016aa <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  80161f:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801626:	8b 55 0c             	mov    0xc(%ebp),%edx
  801629:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80162c:	01 d0                	add    %edx,%eax
  80162e:	48                   	dec    %eax
  80162f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801632:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801635:	ba 00 00 00 00       	mov    $0x0,%edx
  80163a:	f7 75 f0             	divl   -0x10(%ebp)
  80163d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801640:	29 d0                	sub    %edx,%eax
  801642:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801645:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  80164c:	e8 d0 06 00 00       	call   801d21 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801651:	85 c0                	test   %eax,%eax
  801653:	74 11                	je     801666 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  801655:	83 ec 0c             	sub    $0xc,%esp
  801658:	ff 75 e8             	pushl  -0x18(%ebp)
  80165b:	e8 3b 0d 00 00       	call   80239b <alloc_block_FF>
  801660:	83 c4 10             	add    $0x10,%esp
  801663:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  801666:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80166a:	74 39                	je     8016a5 <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  80166c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80166f:	8b 40 08             	mov    0x8(%eax),%eax
  801672:	89 c2                	mov    %eax,%edx
  801674:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801678:	52                   	push   %edx
  801679:	50                   	push   %eax
  80167a:	ff 75 0c             	pushl  0xc(%ebp)
  80167d:	ff 75 08             	pushl  0x8(%ebp)
  801680:	e8 21 04 00 00       	call   801aa6 <sys_createSharedObject>
  801685:	83 c4 10             	add    $0x10,%esp
  801688:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  80168b:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  80168f:	74 14                	je     8016a5 <smalloc+0xa7>
  801691:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  801695:	74 0e                	je     8016a5 <smalloc+0xa7>
  801697:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  80169b:	74 08                	je     8016a5 <smalloc+0xa7>
			return (void*) mem_block->sva;
  80169d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016a0:	8b 40 08             	mov    0x8(%eax),%eax
  8016a3:	eb 05                	jmp    8016aa <smalloc+0xac>
	}
	return NULL;
  8016a5:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8016aa:	c9                   	leave  
  8016ab:	c3                   	ret    

008016ac <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8016ac:	55                   	push   %ebp
  8016ad:	89 e5                	mov    %esp,%ebp
  8016af:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016b2:	e8 fe fb ff ff       	call   8012b5 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8016b7:	83 ec 08             	sub    $0x8,%esp
  8016ba:	ff 75 0c             	pushl  0xc(%ebp)
  8016bd:	ff 75 08             	pushl  0x8(%ebp)
  8016c0:	e8 0b 04 00 00       	call   801ad0 <sys_getSizeOfSharedObject>
  8016c5:	83 c4 10             	add    $0x10,%esp
  8016c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  8016cb:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  8016cf:	74 76                	je     801747 <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  8016d1:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8016d8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016de:	01 d0                	add    %edx,%eax
  8016e0:	48                   	dec    %eax
  8016e1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8016e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8016ec:	f7 75 ec             	divl   -0x14(%ebp)
  8016ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016f2:	29 d0                	sub    %edx,%eax
  8016f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  8016f7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8016fe:	e8 1e 06 00 00       	call   801d21 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801703:	85 c0                	test   %eax,%eax
  801705:	74 11                	je     801718 <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  801707:	83 ec 0c             	sub    $0xc,%esp
  80170a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80170d:	e8 89 0c 00 00       	call   80239b <alloc_block_FF>
  801712:	83 c4 10             	add    $0x10,%esp
  801715:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  801718:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80171c:	74 29                	je     801747 <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  80171e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801721:	8b 40 08             	mov    0x8(%eax),%eax
  801724:	83 ec 04             	sub    $0x4,%esp
  801727:	50                   	push   %eax
  801728:	ff 75 0c             	pushl  0xc(%ebp)
  80172b:	ff 75 08             	pushl  0x8(%ebp)
  80172e:	e8 ba 03 00 00       	call   801aed <sys_getSharedObject>
  801733:	83 c4 10             	add    $0x10,%esp
  801736:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  801739:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  80173d:	74 08                	je     801747 <sget+0x9b>
				return (void *)mem_block->sva;
  80173f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801742:	8b 40 08             	mov    0x8(%eax),%eax
  801745:	eb 05                	jmp    80174c <sget+0xa0>
		}
	}
	return NULL;
  801747:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80174c:	c9                   	leave  
  80174d:	c3                   	ret    

0080174e <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80174e:	55                   	push   %ebp
  80174f:	89 e5                	mov    %esp,%ebp
  801751:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801754:	e8 5c fb ff ff       	call   8012b5 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801759:	83 ec 04             	sub    $0x4,%esp
  80175c:	68 04 3f 80 00       	push   $0x803f04
  801761:	68 f7 00 00 00       	push   $0xf7
  801766:	68 d3 3e 80 00       	push   $0x803ed3
  80176b:	e8 07 eb ff ff       	call   800277 <_panic>

00801770 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801770:	55                   	push   %ebp
  801771:	89 e5                	mov    %esp,%ebp
  801773:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801776:	83 ec 04             	sub    $0x4,%esp
  801779:	68 2c 3f 80 00       	push   $0x803f2c
  80177e:	68 0b 01 00 00       	push   $0x10b
  801783:	68 d3 3e 80 00       	push   $0x803ed3
  801788:	e8 ea ea ff ff       	call   800277 <_panic>

0080178d <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80178d:	55                   	push   %ebp
  80178e:	89 e5                	mov    %esp,%ebp
  801790:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801793:	83 ec 04             	sub    $0x4,%esp
  801796:	68 50 3f 80 00       	push   $0x803f50
  80179b:	68 16 01 00 00       	push   $0x116
  8017a0:	68 d3 3e 80 00       	push   $0x803ed3
  8017a5:	e8 cd ea ff ff       	call   800277 <_panic>

008017aa <shrink>:

}
void shrink(uint32 newSize)
{
  8017aa:	55                   	push   %ebp
  8017ab:	89 e5                	mov    %esp,%ebp
  8017ad:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017b0:	83 ec 04             	sub    $0x4,%esp
  8017b3:	68 50 3f 80 00       	push   $0x803f50
  8017b8:	68 1b 01 00 00       	push   $0x11b
  8017bd:	68 d3 3e 80 00       	push   $0x803ed3
  8017c2:	e8 b0 ea ff ff       	call   800277 <_panic>

008017c7 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8017c7:	55                   	push   %ebp
  8017c8:	89 e5                	mov    %esp,%ebp
  8017ca:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017cd:	83 ec 04             	sub    $0x4,%esp
  8017d0:	68 50 3f 80 00       	push   $0x803f50
  8017d5:	68 20 01 00 00       	push   $0x120
  8017da:	68 d3 3e 80 00       	push   $0x803ed3
  8017df:	e8 93 ea ff ff       	call   800277 <_panic>

008017e4 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8017e4:	55                   	push   %ebp
  8017e5:	89 e5                	mov    %esp,%ebp
  8017e7:	57                   	push   %edi
  8017e8:	56                   	push   %esi
  8017e9:	53                   	push   %ebx
  8017ea:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017f3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017f6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017f9:	8b 7d 18             	mov    0x18(%ebp),%edi
  8017fc:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8017ff:	cd 30                	int    $0x30
  801801:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801804:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801807:	83 c4 10             	add    $0x10,%esp
  80180a:	5b                   	pop    %ebx
  80180b:	5e                   	pop    %esi
  80180c:	5f                   	pop    %edi
  80180d:	5d                   	pop    %ebp
  80180e:	c3                   	ret    

0080180f <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80180f:	55                   	push   %ebp
  801810:	89 e5                	mov    %esp,%ebp
  801812:	83 ec 04             	sub    $0x4,%esp
  801815:	8b 45 10             	mov    0x10(%ebp),%eax
  801818:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80181b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80181f:	8b 45 08             	mov    0x8(%ebp),%eax
  801822:	6a 00                	push   $0x0
  801824:	6a 00                	push   $0x0
  801826:	52                   	push   %edx
  801827:	ff 75 0c             	pushl  0xc(%ebp)
  80182a:	50                   	push   %eax
  80182b:	6a 00                	push   $0x0
  80182d:	e8 b2 ff ff ff       	call   8017e4 <syscall>
  801832:	83 c4 18             	add    $0x18,%esp
}
  801835:	90                   	nop
  801836:	c9                   	leave  
  801837:	c3                   	ret    

00801838 <sys_cgetc>:

int
sys_cgetc(void)
{
  801838:	55                   	push   %ebp
  801839:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80183b:	6a 00                	push   $0x0
  80183d:	6a 00                	push   $0x0
  80183f:	6a 00                	push   $0x0
  801841:	6a 00                	push   $0x0
  801843:	6a 00                	push   $0x0
  801845:	6a 01                	push   $0x1
  801847:	e8 98 ff ff ff       	call   8017e4 <syscall>
  80184c:	83 c4 18             	add    $0x18,%esp
}
  80184f:	c9                   	leave  
  801850:	c3                   	ret    

00801851 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801851:	55                   	push   %ebp
  801852:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801854:	8b 55 0c             	mov    0xc(%ebp),%edx
  801857:	8b 45 08             	mov    0x8(%ebp),%eax
  80185a:	6a 00                	push   $0x0
  80185c:	6a 00                	push   $0x0
  80185e:	6a 00                	push   $0x0
  801860:	52                   	push   %edx
  801861:	50                   	push   %eax
  801862:	6a 05                	push   $0x5
  801864:	e8 7b ff ff ff       	call   8017e4 <syscall>
  801869:	83 c4 18             	add    $0x18,%esp
}
  80186c:	c9                   	leave  
  80186d:	c3                   	ret    

0080186e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80186e:	55                   	push   %ebp
  80186f:	89 e5                	mov    %esp,%ebp
  801871:	56                   	push   %esi
  801872:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801873:	8b 75 18             	mov    0x18(%ebp),%esi
  801876:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801879:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80187c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80187f:	8b 45 08             	mov    0x8(%ebp),%eax
  801882:	56                   	push   %esi
  801883:	53                   	push   %ebx
  801884:	51                   	push   %ecx
  801885:	52                   	push   %edx
  801886:	50                   	push   %eax
  801887:	6a 06                	push   $0x6
  801889:	e8 56 ff ff ff       	call   8017e4 <syscall>
  80188e:	83 c4 18             	add    $0x18,%esp
}
  801891:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801894:	5b                   	pop    %ebx
  801895:	5e                   	pop    %esi
  801896:	5d                   	pop    %ebp
  801897:	c3                   	ret    

00801898 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801898:	55                   	push   %ebp
  801899:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80189b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80189e:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a1:	6a 00                	push   $0x0
  8018a3:	6a 00                	push   $0x0
  8018a5:	6a 00                	push   $0x0
  8018a7:	52                   	push   %edx
  8018a8:	50                   	push   %eax
  8018a9:	6a 07                	push   $0x7
  8018ab:	e8 34 ff ff ff       	call   8017e4 <syscall>
  8018b0:	83 c4 18             	add    $0x18,%esp
}
  8018b3:	c9                   	leave  
  8018b4:	c3                   	ret    

008018b5 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018b5:	55                   	push   %ebp
  8018b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018b8:	6a 00                	push   $0x0
  8018ba:	6a 00                	push   $0x0
  8018bc:	6a 00                	push   $0x0
  8018be:	ff 75 0c             	pushl  0xc(%ebp)
  8018c1:	ff 75 08             	pushl  0x8(%ebp)
  8018c4:	6a 08                	push   $0x8
  8018c6:	e8 19 ff ff ff       	call   8017e4 <syscall>
  8018cb:	83 c4 18             	add    $0x18,%esp
}
  8018ce:	c9                   	leave  
  8018cf:	c3                   	ret    

008018d0 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8018d0:	55                   	push   %ebp
  8018d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8018d3:	6a 00                	push   $0x0
  8018d5:	6a 00                	push   $0x0
  8018d7:	6a 00                	push   $0x0
  8018d9:	6a 00                	push   $0x0
  8018db:	6a 00                	push   $0x0
  8018dd:	6a 09                	push   $0x9
  8018df:	e8 00 ff ff ff       	call   8017e4 <syscall>
  8018e4:	83 c4 18             	add    $0x18,%esp
}
  8018e7:	c9                   	leave  
  8018e8:	c3                   	ret    

008018e9 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8018e9:	55                   	push   %ebp
  8018ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8018ec:	6a 00                	push   $0x0
  8018ee:	6a 00                	push   $0x0
  8018f0:	6a 00                	push   $0x0
  8018f2:	6a 00                	push   $0x0
  8018f4:	6a 00                	push   $0x0
  8018f6:	6a 0a                	push   $0xa
  8018f8:	e8 e7 fe ff ff       	call   8017e4 <syscall>
  8018fd:	83 c4 18             	add    $0x18,%esp
}
  801900:	c9                   	leave  
  801901:	c3                   	ret    

00801902 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801902:	55                   	push   %ebp
  801903:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801905:	6a 00                	push   $0x0
  801907:	6a 00                	push   $0x0
  801909:	6a 00                	push   $0x0
  80190b:	6a 00                	push   $0x0
  80190d:	6a 00                	push   $0x0
  80190f:	6a 0b                	push   $0xb
  801911:	e8 ce fe ff ff       	call   8017e4 <syscall>
  801916:	83 c4 18             	add    $0x18,%esp
}
  801919:	c9                   	leave  
  80191a:	c3                   	ret    

0080191b <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80191b:	55                   	push   %ebp
  80191c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80191e:	6a 00                	push   $0x0
  801920:	6a 00                	push   $0x0
  801922:	6a 00                	push   $0x0
  801924:	ff 75 0c             	pushl  0xc(%ebp)
  801927:	ff 75 08             	pushl  0x8(%ebp)
  80192a:	6a 0f                	push   $0xf
  80192c:	e8 b3 fe ff ff       	call   8017e4 <syscall>
  801931:	83 c4 18             	add    $0x18,%esp
	return;
  801934:	90                   	nop
}
  801935:	c9                   	leave  
  801936:	c3                   	ret    

00801937 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801937:	55                   	push   %ebp
  801938:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80193a:	6a 00                	push   $0x0
  80193c:	6a 00                	push   $0x0
  80193e:	6a 00                	push   $0x0
  801940:	ff 75 0c             	pushl  0xc(%ebp)
  801943:	ff 75 08             	pushl  0x8(%ebp)
  801946:	6a 10                	push   $0x10
  801948:	e8 97 fe ff ff       	call   8017e4 <syscall>
  80194d:	83 c4 18             	add    $0x18,%esp
	return ;
  801950:	90                   	nop
}
  801951:	c9                   	leave  
  801952:	c3                   	ret    

00801953 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801953:	55                   	push   %ebp
  801954:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801956:	6a 00                	push   $0x0
  801958:	6a 00                	push   $0x0
  80195a:	ff 75 10             	pushl  0x10(%ebp)
  80195d:	ff 75 0c             	pushl  0xc(%ebp)
  801960:	ff 75 08             	pushl  0x8(%ebp)
  801963:	6a 11                	push   $0x11
  801965:	e8 7a fe ff ff       	call   8017e4 <syscall>
  80196a:	83 c4 18             	add    $0x18,%esp
	return ;
  80196d:	90                   	nop
}
  80196e:	c9                   	leave  
  80196f:	c3                   	ret    

00801970 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801970:	55                   	push   %ebp
  801971:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801973:	6a 00                	push   $0x0
  801975:	6a 00                	push   $0x0
  801977:	6a 00                	push   $0x0
  801979:	6a 00                	push   $0x0
  80197b:	6a 00                	push   $0x0
  80197d:	6a 0c                	push   $0xc
  80197f:	e8 60 fe ff ff       	call   8017e4 <syscall>
  801984:	83 c4 18             	add    $0x18,%esp
}
  801987:	c9                   	leave  
  801988:	c3                   	ret    

00801989 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801989:	55                   	push   %ebp
  80198a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80198c:	6a 00                	push   $0x0
  80198e:	6a 00                	push   $0x0
  801990:	6a 00                	push   $0x0
  801992:	6a 00                	push   $0x0
  801994:	ff 75 08             	pushl  0x8(%ebp)
  801997:	6a 0d                	push   $0xd
  801999:	e8 46 fe ff ff       	call   8017e4 <syscall>
  80199e:	83 c4 18             	add    $0x18,%esp
}
  8019a1:	c9                   	leave  
  8019a2:	c3                   	ret    

008019a3 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019a3:	55                   	push   %ebp
  8019a4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019a6:	6a 00                	push   $0x0
  8019a8:	6a 00                	push   $0x0
  8019aa:	6a 00                	push   $0x0
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 00                	push   $0x0
  8019b0:	6a 0e                	push   $0xe
  8019b2:	e8 2d fe ff ff       	call   8017e4 <syscall>
  8019b7:	83 c4 18             	add    $0x18,%esp
}
  8019ba:	90                   	nop
  8019bb:	c9                   	leave  
  8019bc:	c3                   	ret    

008019bd <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8019bd:	55                   	push   %ebp
  8019be:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8019c0:	6a 00                	push   $0x0
  8019c2:	6a 00                	push   $0x0
  8019c4:	6a 00                	push   $0x0
  8019c6:	6a 00                	push   $0x0
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 13                	push   $0x13
  8019cc:	e8 13 fe ff ff       	call   8017e4 <syscall>
  8019d1:	83 c4 18             	add    $0x18,%esp
}
  8019d4:	90                   	nop
  8019d5:	c9                   	leave  
  8019d6:	c3                   	ret    

008019d7 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8019d7:	55                   	push   %ebp
  8019d8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 14                	push   $0x14
  8019e6:	e8 f9 fd ff ff       	call   8017e4 <syscall>
  8019eb:	83 c4 18             	add    $0x18,%esp
}
  8019ee:	90                   	nop
  8019ef:	c9                   	leave  
  8019f0:	c3                   	ret    

008019f1 <sys_cputc>:


void
sys_cputc(const char c)
{
  8019f1:	55                   	push   %ebp
  8019f2:	89 e5                	mov    %esp,%ebp
  8019f4:	83 ec 04             	sub    $0x4,%esp
  8019f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fa:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8019fd:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a01:	6a 00                	push   $0x0
  801a03:	6a 00                	push   $0x0
  801a05:	6a 00                	push   $0x0
  801a07:	6a 00                	push   $0x0
  801a09:	50                   	push   %eax
  801a0a:	6a 15                	push   $0x15
  801a0c:	e8 d3 fd ff ff       	call   8017e4 <syscall>
  801a11:	83 c4 18             	add    $0x18,%esp
}
  801a14:	90                   	nop
  801a15:	c9                   	leave  
  801a16:	c3                   	ret    

00801a17 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a17:	55                   	push   %ebp
  801a18:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a1a:	6a 00                	push   $0x0
  801a1c:	6a 00                	push   $0x0
  801a1e:	6a 00                	push   $0x0
  801a20:	6a 00                	push   $0x0
  801a22:	6a 00                	push   $0x0
  801a24:	6a 16                	push   $0x16
  801a26:	e8 b9 fd ff ff       	call   8017e4 <syscall>
  801a2b:	83 c4 18             	add    $0x18,%esp
}
  801a2e:	90                   	nop
  801a2f:	c9                   	leave  
  801a30:	c3                   	ret    

00801a31 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a31:	55                   	push   %ebp
  801a32:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a34:	8b 45 08             	mov    0x8(%ebp),%eax
  801a37:	6a 00                	push   $0x0
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 00                	push   $0x0
  801a3d:	ff 75 0c             	pushl  0xc(%ebp)
  801a40:	50                   	push   %eax
  801a41:	6a 17                	push   $0x17
  801a43:	e8 9c fd ff ff       	call   8017e4 <syscall>
  801a48:	83 c4 18             	add    $0x18,%esp
}
  801a4b:	c9                   	leave  
  801a4c:	c3                   	ret    

00801a4d <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a4d:	55                   	push   %ebp
  801a4e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a50:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a53:	8b 45 08             	mov    0x8(%ebp),%eax
  801a56:	6a 00                	push   $0x0
  801a58:	6a 00                	push   $0x0
  801a5a:	6a 00                	push   $0x0
  801a5c:	52                   	push   %edx
  801a5d:	50                   	push   %eax
  801a5e:	6a 1a                	push   $0x1a
  801a60:	e8 7f fd ff ff       	call   8017e4 <syscall>
  801a65:	83 c4 18             	add    $0x18,%esp
}
  801a68:	c9                   	leave  
  801a69:	c3                   	ret    

00801a6a <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a6a:	55                   	push   %ebp
  801a6b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a6d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a70:	8b 45 08             	mov    0x8(%ebp),%eax
  801a73:	6a 00                	push   $0x0
  801a75:	6a 00                	push   $0x0
  801a77:	6a 00                	push   $0x0
  801a79:	52                   	push   %edx
  801a7a:	50                   	push   %eax
  801a7b:	6a 18                	push   $0x18
  801a7d:	e8 62 fd ff ff       	call   8017e4 <syscall>
  801a82:	83 c4 18             	add    $0x18,%esp
}
  801a85:	90                   	nop
  801a86:	c9                   	leave  
  801a87:	c3                   	ret    

00801a88 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a88:	55                   	push   %ebp
  801a89:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a91:	6a 00                	push   $0x0
  801a93:	6a 00                	push   $0x0
  801a95:	6a 00                	push   $0x0
  801a97:	52                   	push   %edx
  801a98:	50                   	push   %eax
  801a99:	6a 19                	push   $0x19
  801a9b:	e8 44 fd ff ff       	call   8017e4 <syscall>
  801aa0:	83 c4 18             	add    $0x18,%esp
}
  801aa3:	90                   	nop
  801aa4:	c9                   	leave  
  801aa5:	c3                   	ret    

00801aa6 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801aa6:	55                   	push   %ebp
  801aa7:	89 e5                	mov    %esp,%ebp
  801aa9:	83 ec 04             	sub    $0x4,%esp
  801aac:	8b 45 10             	mov    0x10(%ebp),%eax
  801aaf:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801ab2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ab5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  801abc:	6a 00                	push   $0x0
  801abe:	51                   	push   %ecx
  801abf:	52                   	push   %edx
  801ac0:	ff 75 0c             	pushl  0xc(%ebp)
  801ac3:	50                   	push   %eax
  801ac4:	6a 1b                	push   $0x1b
  801ac6:	e8 19 fd ff ff       	call   8017e4 <syscall>
  801acb:	83 c4 18             	add    $0x18,%esp
}
  801ace:	c9                   	leave  
  801acf:	c3                   	ret    

00801ad0 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801ad0:	55                   	push   %ebp
  801ad1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801ad3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ad6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad9:	6a 00                	push   $0x0
  801adb:	6a 00                	push   $0x0
  801add:	6a 00                	push   $0x0
  801adf:	52                   	push   %edx
  801ae0:	50                   	push   %eax
  801ae1:	6a 1c                	push   $0x1c
  801ae3:	e8 fc fc ff ff       	call   8017e4 <syscall>
  801ae8:	83 c4 18             	add    $0x18,%esp
}
  801aeb:	c9                   	leave  
  801aec:	c3                   	ret    

00801aed <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801aed:	55                   	push   %ebp
  801aee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801af0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801af3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801af6:	8b 45 08             	mov    0x8(%ebp),%eax
  801af9:	6a 00                	push   $0x0
  801afb:	6a 00                	push   $0x0
  801afd:	51                   	push   %ecx
  801afe:	52                   	push   %edx
  801aff:	50                   	push   %eax
  801b00:	6a 1d                	push   $0x1d
  801b02:	e8 dd fc ff ff       	call   8017e4 <syscall>
  801b07:	83 c4 18             	add    $0x18,%esp
}
  801b0a:	c9                   	leave  
  801b0b:	c3                   	ret    

00801b0c <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b0c:	55                   	push   %ebp
  801b0d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b0f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b12:	8b 45 08             	mov    0x8(%ebp),%eax
  801b15:	6a 00                	push   $0x0
  801b17:	6a 00                	push   $0x0
  801b19:	6a 00                	push   $0x0
  801b1b:	52                   	push   %edx
  801b1c:	50                   	push   %eax
  801b1d:	6a 1e                	push   $0x1e
  801b1f:	e8 c0 fc ff ff       	call   8017e4 <syscall>
  801b24:	83 c4 18             	add    $0x18,%esp
}
  801b27:	c9                   	leave  
  801b28:	c3                   	ret    

00801b29 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b29:	55                   	push   %ebp
  801b2a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 00                	push   $0x0
  801b30:	6a 00                	push   $0x0
  801b32:	6a 00                	push   $0x0
  801b34:	6a 00                	push   $0x0
  801b36:	6a 1f                	push   $0x1f
  801b38:	e8 a7 fc ff ff       	call   8017e4 <syscall>
  801b3d:	83 c4 18             	add    $0x18,%esp
}
  801b40:	c9                   	leave  
  801b41:	c3                   	ret    

00801b42 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b42:	55                   	push   %ebp
  801b43:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b45:	8b 45 08             	mov    0x8(%ebp),%eax
  801b48:	6a 00                	push   $0x0
  801b4a:	ff 75 14             	pushl  0x14(%ebp)
  801b4d:	ff 75 10             	pushl  0x10(%ebp)
  801b50:	ff 75 0c             	pushl  0xc(%ebp)
  801b53:	50                   	push   %eax
  801b54:	6a 20                	push   $0x20
  801b56:	e8 89 fc ff ff       	call   8017e4 <syscall>
  801b5b:	83 c4 18             	add    $0x18,%esp
}
  801b5e:	c9                   	leave  
  801b5f:	c3                   	ret    

00801b60 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801b60:	55                   	push   %ebp
  801b61:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b63:	8b 45 08             	mov    0x8(%ebp),%eax
  801b66:	6a 00                	push   $0x0
  801b68:	6a 00                	push   $0x0
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 00                	push   $0x0
  801b6e:	50                   	push   %eax
  801b6f:	6a 21                	push   $0x21
  801b71:	e8 6e fc ff ff       	call   8017e4 <syscall>
  801b76:	83 c4 18             	add    $0x18,%esp
}
  801b79:	90                   	nop
  801b7a:	c9                   	leave  
  801b7b:	c3                   	ret    

00801b7c <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b7c:	55                   	push   %ebp
  801b7d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b82:	6a 00                	push   $0x0
  801b84:	6a 00                	push   $0x0
  801b86:	6a 00                	push   $0x0
  801b88:	6a 00                	push   $0x0
  801b8a:	50                   	push   %eax
  801b8b:	6a 22                	push   $0x22
  801b8d:	e8 52 fc ff ff       	call   8017e4 <syscall>
  801b92:	83 c4 18             	add    $0x18,%esp
}
  801b95:	c9                   	leave  
  801b96:	c3                   	ret    

00801b97 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b97:	55                   	push   %ebp
  801b98:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b9a:	6a 00                	push   $0x0
  801b9c:	6a 00                	push   $0x0
  801b9e:	6a 00                	push   $0x0
  801ba0:	6a 00                	push   $0x0
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 02                	push   $0x2
  801ba6:	e8 39 fc ff ff       	call   8017e4 <syscall>
  801bab:	83 c4 18             	add    $0x18,%esp
}
  801bae:	c9                   	leave  
  801baf:	c3                   	ret    

00801bb0 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801bb0:	55                   	push   %ebp
  801bb1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801bb3:	6a 00                	push   $0x0
  801bb5:	6a 00                	push   $0x0
  801bb7:	6a 00                	push   $0x0
  801bb9:	6a 00                	push   $0x0
  801bbb:	6a 00                	push   $0x0
  801bbd:	6a 03                	push   $0x3
  801bbf:	e8 20 fc ff ff       	call   8017e4 <syscall>
  801bc4:	83 c4 18             	add    $0x18,%esp
}
  801bc7:	c9                   	leave  
  801bc8:	c3                   	ret    

00801bc9 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801bc9:	55                   	push   %ebp
  801bca:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 04                	push   $0x4
  801bd8:	e8 07 fc ff ff       	call   8017e4 <syscall>
  801bdd:	83 c4 18             	add    $0x18,%esp
}
  801be0:	c9                   	leave  
  801be1:	c3                   	ret    

00801be2 <sys_exit_env>:


void sys_exit_env(void)
{
  801be2:	55                   	push   %ebp
  801be3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801be5:	6a 00                	push   $0x0
  801be7:	6a 00                	push   $0x0
  801be9:	6a 00                	push   $0x0
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	6a 23                	push   $0x23
  801bf1:	e8 ee fb ff ff       	call   8017e4 <syscall>
  801bf6:	83 c4 18             	add    $0x18,%esp
}
  801bf9:	90                   	nop
  801bfa:	c9                   	leave  
  801bfb:	c3                   	ret    

00801bfc <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801bfc:	55                   	push   %ebp
  801bfd:	89 e5                	mov    %esp,%ebp
  801bff:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c02:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c05:	8d 50 04             	lea    0x4(%eax),%edx
  801c08:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 00                	push   $0x0
  801c11:	52                   	push   %edx
  801c12:	50                   	push   %eax
  801c13:	6a 24                	push   $0x24
  801c15:	e8 ca fb ff ff       	call   8017e4 <syscall>
  801c1a:	83 c4 18             	add    $0x18,%esp
	return result;
  801c1d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c20:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c23:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c26:	89 01                	mov    %eax,(%ecx)
  801c28:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2e:	c9                   	leave  
  801c2f:	c2 04 00             	ret    $0x4

00801c32 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c32:	55                   	push   %ebp
  801c33:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	ff 75 10             	pushl  0x10(%ebp)
  801c3c:	ff 75 0c             	pushl  0xc(%ebp)
  801c3f:	ff 75 08             	pushl  0x8(%ebp)
  801c42:	6a 12                	push   $0x12
  801c44:	e8 9b fb ff ff       	call   8017e4 <syscall>
  801c49:	83 c4 18             	add    $0x18,%esp
	return ;
  801c4c:	90                   	nop
}
  801c4d:	c9                   	leave  
  801c4e:	c3                   	ret    

00801c4f <sys_rcr2>:
uint32 sys_rcr2()
{
  801c4f:	55                   	push   %ebp
  801c50:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c52:	6a 00                	push   $0x0
  801c54:	6a 00                	push   $0x0
  801c56:	6a 00                	push   $0x0
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 25                	push   $0x25
  801c5e:	e8 81 fb ff ff       	call   8017e4 <syscall>
  801c63:	83 c4 18             	add    $0x18,%esp
}
  801c66:	c9                   	leave  
  801c67:	c3                   	ret    

00801c68 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801c68:	55                   	push   %ebp
  801c69:	89 e5                	mov    %esp,%ebp
  801c6b:	83 ec 04             	sub    $0x4,%esp
  801c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c71:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c74:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c78:	6a 00                	push   $0x0
  801c7a:	6a 00                	push   $0x0
  801c7c:	6a 00                	push   $0x0
  801c7e:	6a 00                	push   $0x0
  801c80:	50                   	push   %eax
  801c81:	6a 26                	push   $0x26
  801c83:	e8 5c fb ff ff       	call   8017e4 <syscall>
  801c88:	83 c4 18             	add    $0x18,%esp
	return ;
  801c8b:	90                   	nop
}
  801c8c:	c9                   	leave  
  801c8d:	c3                   	ret    

00801c8e <rsttst>:
void rsttst()
{
  801c8e:	55                   	push   %ebp
  801c8f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c91:	6a 00                	push   $0x0
  801c93:	6a 00                	push   $0x0
  801c95:	6a 00                	push   $0x0
  801c97:	6a 00                	push   $0x0
  801c99:	6a 00                	push   $0x0
  801c9b:	6a 28                	push   $0x28
  801c9d:	e8 42 fb ff ff       	call   8017e4 <syscall>
  801ca2:	83 c4 18             	add    $0x18,%esp
	return ;
  801ca5:	90                   	nop
}
  801ca6:	c9                   	leave  
  801ca7:	c3                   	ret    

00801ca8 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ca8:	55                   	push   %ebp
  801ca9:	89 e5                	mov    %esp,%ebp
  801cab:	83 ec 04             	sub    $0x4,%esp
  801cae:	8b 45 14             	mov    0x14(%ebp),%eax
  801cb1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801cb4:	8b 55 18             	mov    0x18(%ebp),%edx
  801cb7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cbb:	52                   	push   %edx
  801cbc:	50                   	push   %eax
  801cbd:	ff 75 10             	pushl  0x10(%ebp)
  801cc0:	ff 75 0c             	pushl  0xc(%ebp)
  801cc3:	ff 75 08             	pushl  0x8(%ebp)
  801cc6:	6a 27                	push   $0x27
  801cc8:	e8 17 fb ff ff       	call   8017e4 <syscall>
  801ccd:	83 c4 18             	add    $0x18,%esp
	return ;
  801cd0:	90                   	nop
}
  801cd1:	c9                   	leave  
  801cd2:	c3                   	ret    

00801cd3 <chktst>:
void chktst(uint32 n)
{
  801cd3:	55                   	push   %ebp
  801cd4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 00                	push   $0x0
  801cda:	6a 00                	push   $0x0
  801cdc:	6a 00                	push   $0x0
  801cde:	ff 75 08             	pushl  0x8(%ebp)
  801ce1:	6a 29                	push   $0x29
  801ce3:	e8 fc fa ff ff       	call   8017e4 <syscall>
  801ce8:	83 c4 18             	add    $0x18,%esp
	return ;
  801ceb:	90                   	nop
}
  801cec:	c9                   	leave  
  801ced:	c3                   	ret    

00801cee <inctst>:

void inctst()
{
  801cee:	55                   	push   %ebp
  801cef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801cf1:	6a 00                	push   $0x0
  801cf3:	6a 00                	push   $0x0
  801cf5:	6a 00                	push   $0x0
  801cf7:	6a 00                	push   $0x0
  801cf9:	6a 00                	push   $0x0
  801cfb:	6a 2a                	push   $0x2a
  801cfd:	e8 e2 fa ff ff       	call   8017e4 <syscall>
  801d02:	83 c4 18             	add    $0x18,%esp
	return ;
  801d05:	90                   	nop
}
  801d06:	c9                   	leave  
  801d07:	c3                   	ret    

00801d08 <gettst>:
uint32 gettst()
{
  801d08:	55                   	push   %ebp
  801d09:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d0b:	6a 00                	push   $0x0
  801d0d:	6a 00                	push   $0x0
  801d0f:	6a 00                	push   $0x0
  801d11:	6a 00                	push   $0x0
  801d13:	6a 00                	push   $0x0
  801d15:	6a 2b                	push   $0x2b
  801d17:	e8 c8 fa ff ff       	call   8017e4 <syscall>
  801d1c:	83 c4 18             	add    $0x18,%esp
}
  801d1f:	c9                   	leave  
  801d20:	c3                   	ret    

00801d21 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d21:	55                   	push   %ebp
  801d22:	89 e5                	mov    %esp,%ebp
  801d24:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d27:	6a 00                	push   $0x0
  801d29:	6a 00                	push   $0x0
  801d2b:	6a 00                	push   $0x0
  801d2d:	6a 00                	push   $0x0
  801d2f:	6a 00                	push   $0x0
  801d31:	6a 2c                	push   $0x2c
  801d33:	e8 ac fa ff ff       	call   8017e4 <syscall>
  801d38:	83 c4 18             	add    $0x18,%esp
  801d3b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d3e:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d42:	75 07                	jne    801d4b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d44:	b8 01 00 00 00       	mov    $0x1,%eax
  801d49:	eb 05                	jmp    801d50 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d4b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d50:	c9                   	leave  
  801d51:	c3                   	ret    

00801d52 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d52:	55                   	push   %ebp
  801d53:	89 e5                	mov    %esp,%ebp
  801d55:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d58:	6a 00                	push   $0x0
  801d5a:	6a 00                	push   $0x0
  801d5c:	6a 00                	push   $0x0
  801d5e:	6a 00                	push   $0x0
  801d60:	6a 00                	push   $0x0
  801d62:	6a 2c                	push   $0x2c
  801d64:	e8 7b fa ff ff       	call   8017e4 <syscall>
  801d69:	83 c4 18             	add    $0x18,%esp
  801d6c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d6f:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d73:	75 07                	jne    801d7c <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d75:	b8 01 00 00 00       	mov    $0x1,%eax
  801d7a:	eb 05                	jmp    801d81 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d7c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d81:	c9                   	leave  
  801d82:	c3                   	ret    

00801d83 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d83:	55                   	push   %ebp
  801d84:	89 e5                	mov    %esp,%ebp
  801d86:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d89:	6a 00                	push   $0x0
  801d8b:	6a 00                	push   $0x0
  801d8d:	6a 00                	push   $0x0
  801d8f:	6a 00                	push   $0x0
  801d91:	6a 00                	push   $0x0
  801d93:	6a 2c                	push   $0x2c
  801d95:	e8 4a fa ff ff       	call   8017e4 <syscall>
  801d9a:	83 c4 18             	add    $0x18,%esp
  801d9d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801da0:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801da4:	75 07                	jne    801dad <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801da6:	b8 01 00 00 00       	mov    $0x1,%eax
  801dab:	eb 05                	jmp    801db2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801dad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801db2:	c9                   	leave  
  801db3:	c3                   	ret    

00801db4 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801db4:	55                   	push   %ebp
  801db5:	89 e5                	mov    %esp,%ebp
  801db7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dba:	6a 00                	push   $0x0
  801dbc:	6a 00                	push   $0x0
  801dbe:	6a 00                	push   $0x0
  801dc0:	6a 00                	push   $0x0
  801dc2:	6a 00                	push   $0x0
  801dc4:	6a 2c                	push   $0x2c
  801dc6:	e8 19 fa ff ff       	call   8017e4 <syscall>
  801dcb:	83 c4 18             	add    $0x18,%esp
  801dce:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801dd1:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801dd5:	75 07                	jne    801dde <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801dd7:	b8 01 00 00 00       	mov    $0x1,%eax
  801ddc:	eb 05                	jmp    801de3 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801dde:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801de3:	c9                   	leave  
  801de4:	c3                   	ret    

00801de5 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801de5:	55                   	push   %ebp
  801de6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801de8:	6a 00                	push   $0x0
  801dea:	6a 00                	push   $0x0
  801dec:	6a 00                	push   $0x0
  801dee:	6a 00                	push   $0x0
  801df0:	ff 75 08             	pushl  0x8(%ebp)
  801df3:	6a 2d                	push   $0x2d
  801df5:	e8 ea f9 ff ff       	call   8017e4 <syscall>
  801dfa:	83 c4 18             	add    $0x18,%esp
	return ;
  801dfd:	90                   	nop
}
  801dfe:	c9                   	leave  
  801dff:	c3                   	ret    

00801e00 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e00:	55                   	push   %ebp
  801e01:	89 e5                	mov    %esp,%ebp
  801e03:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e04:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e07:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e0a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e10:	6a 00                	push   $0x0
  801e12:	53                   	push   %ebx
  801e13:	51                   	push   %ecx
  801e14:	52                   	push   %edx
  801e15:	50                   	push   %eax
  801e16:	6a 2e                	push   $0x2e
  801e18:	e8 c7 f9 ff ff       	call   8017e4 <syscall>
  801e1d:	83 c4 18             	add    $0x18,%esp
}
  801e20:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e23:	c9                   	leave  
  801e24:	c3                   	ret    

00801e25 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e25:	55                   	push   %ebp
  801e26:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e28:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2e:	6a 00                	push   $0x0
  801e30:	6a 00                	push   $0x0
  801e32:	6a 00                	push   $0x0
  801e34:	52                   	push   %edx
  801e35:	50                   	push   %eax
  801e36:	6a 2f                	push   $0x2f
  801e38:	e8 a7 f9 ff ff       	call   8017e4 <syscall>
  801e3d:	83 c4 18             	add    $0x18,%esp
}
  801e40:	c9                   	leave  
  801e41:	c3                   	ret    

00801e42 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801e42:	55                   	push   %ebp
  801e43:	89 e5                	mov    %esp,%ebp
  801e45:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801e48:	83 ec 0c             	sub    $0xc,%esp
  801e4b:	68 60 3f 80 00       	push   $0x803f60
  801e50:	e8 d6 e6 ff ff       	call   80052b <cprintf>
  801e55:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801e58:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801e5f:	83 ec 0c             	sub    $0xc,%esp
  801e62:	68 8c 3f 80 00       	push   $0x803f8c
  801e67:	e8 bf e6 ff ff       	call   80052b <cprintf>
  801e6c:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801e6f:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e73:	a1 38 51 80 00       	mov    0x805138,%eax
  801e78:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e7b:	eb 56                	jmp    801ed3 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e7d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e81:	74 1c                	je     801e9f <print_mem_block_lists+0x5d>
  801e83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e86:	8b 50 08             	mov    0x8(%eax),%edx
  801e89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e8c:	8b 48 08             	mov    0x8(%eax),%ecx
  801e8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e92:	8b 40 0c             	mov    0xc(%eax),%eax
  801e95:	01 c8                	add    %ecx,%eax
  801e97:	39 c2                	cmp    %eax,%edx
  801e99:	73 04                	jae    801e9f <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801e9b:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ea2:	8b 50 08             	mov    0x8(%eax),%edx
  801ea5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ea8:	8b 40 0c             	mov    0xc(%eax),%eax
  801eab:	01 c2                	add    %eax,%edx
  801ead:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb0:	8b 40 08             	mov    0x8(%eax),%eax
  801eb3:	83 ec 04             	sub    $0x4,%esp
  801eb6:	52                   	push   %edx
  801eb7:	50                   	push   %eax
  801eb8:	68 a1 3f 80 00       	push   $0x803fa1
  801ebd:	e8 69 e6 ff ff       	call   80052b <cprintf>
  801ec2:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801ec5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ecb:	a1 40 51 80 00       	mov    0x805140,%eax
  801ed0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ed3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ed7:	74 07                	je     801ee0 <print_mem_block_lists+0x9e>
  801ed9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801edc:	8b 00                	mov    (%eax),%eax
  801ede:	eb 05                	jmp    801ee5 <print_mem_block_lists+0xa3>
  801ee0:	b8 00 00 00 00       	mov    $0x0,%eax
  801ee5:	a3 40 51 80 00       	mov    %eax,0x805140
  801eea:	a1 40 51 80 00       	mov    0x805140,%eax
  801eef:	85 c0                	test   %eax,%eax
  801ef1:	75 8a                	jne    801e7d <print_mem_block_lists+0x3b>
  801ef3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ef7:	75 84                	jne    801e7d <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801ef9:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801efd:	75 10                	jne    801f0f <print_mem_block_lists+0xcd>
  801eff:	83 ec 0c             	sub    $0xc,%esp
  801f02:	68 b0 3f 80 00       	push   $0x803fb0
  801f07:	e8 1f e6 ff ff       	call   80052b <cprintf>
  801f0c:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f0f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f16:	83 ec 0c             	sub    $0xc,%esp
  801f19:	68 d4 3f 80 00       	push   $0x803fd4
  801f1e:	e8 08 e6 ff ff       	call   80052b <cprintf>
  801f23:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f26:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f2a:	a1 40 50 80 00       	mov    0x805040,%eax
  801f2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f32:	eb 56                	jmp    801f8a <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f34:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f38:	74 1c                	je     801f56 <print_mem_block_lists+0x114>
  801f3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f3d:	8b 50 08             	mov    0x8(%eax),%edx
  801f40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f43:	8b 48 08             	mov    0x8(%eax),%ecx
  801f46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f49:	8b 40 0c             	mov    0xc(%eax),%eax
  801f4c:	01 c8                	add    %ecx,%eax
  801f4e:	39 c2                	cmp    %eax,%edx
  801f50:	73 04                	jae    801f56 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801f52:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f59:	8b 50 08             	mov    0x8(%eax),%edx
  801f5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f5f:	8b 40 0c             	mov    0xc(%eax),%eax
  801f62:	01 c2                	add    %eax,%edx
  801f64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f67:	8b 40 08             	mov    0x8(%eax),%eax
  801f6a:	83 ec 04             	sub    $0x4,%esp
  801f6d:	52                   	push   %edx
  801f6e:	50                   	push   %eax
  801f6f:	68 a1 3f 80 00       	push   $0x803fa1
  801f74:	e8 b2 e5 ff ff       	call   80052b <cprintf>
  801f79:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f82:	a1 48 50 80 00       	mov    0x805048,%eax
  801f87:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f8a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f8e:	74 07                	je     801f97 <print_mem_block_lists+0x155>
  801f90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f93:	8b 00                	mov    (%eax),%eax
  801f95:	eb 05                	jmp    801f9c <print_mem_block_lists+0x15a>
  801f97:	b8 00 00 00 00       	mov    $0x0,%eax
  801f9c:	a3 48 50 80 00       	mov    %eax,0x805048
  801fa1:	a1 48 50 80 00       	mov    0x805048,%eax
  801fa6:	85 c0                	test   %eax,%eax
  801fa8:	75 8a                	jne    801f34 <print_mem_block_lists+0xf2>
  801faa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fae:	75 84                	jne    801f34 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801fb0:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fb4:	75 10                	jne    801fc6 <print_mem_block_lists+0x184>
  801fb6:	83 ec 0c             	sub    $0xc,%esp
  801fb9:	68 ec 3f 80 00       	push   $0x803fec
  801fbe:	e8 68 e5 ff ff       	call   80052b <cprintf>
  801fc3:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801fc6:	83 ec 0c             	sub    $0xc,%esp
  801fc9:	68 60 3f 80 00       	push   $0x803f60
  801fce:	e8 58 e5 ff ff       	call   80052b <cprintf>
  801fd3:	83 c4 10             	add    $0x10,%esp

}
  801fd6:	90                   	nop
  801fd7:	c9                   	leave  
  801fd8:	c3                   	ret    

00801fd9 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801fd9:	55                   	push   %ebp
  801fda:	89 e5                	mov    %esp,%ebp
  801fdc:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801fdf:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  801fe6:	00 00 00 
  801fe9:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  801ff0:	00 00 00 
  801ff3:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  801ffa:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801ffd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802004:	e9 9e 00 00 00       	jmp    8020a7 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802009:	a1 50 50 80 00       	mov    0x805050,%eax
  80200e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802011:	c1 e2 04             	shl    $0x4,%edx
  802014:	01 d0                	add    %edx,%eax
  802016:	85 c0                	test   %eax,%eax
  802018:	75 14                	jne    80202e <initialize_MemBlocksList+0x55>
  80201a:	83 ec 04             	sub    $0x4,%esp
  80201d:	68 14 40 80 00       	push   $0x804014
  802022:	6a 46                	push   $0x46
  802024:	68 37 40 80 00       	push   $0x804037
  802029:	e8 49 e2 ff ff       	call   800277 <_panic>
  80202e:	a1 50 50 80 00       	mov    0x805050,%eax
  802033:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802036:	c1 e2 04             	shl    $0x4,%edx
  802039:	01 d0                	add    %edx,%eax
  80203b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802041:	89 10                	mov    %edx,(%eax)
  802043:	8b 00                	mov    (%eax),%eax
  802045:	85 c0                	test   %eax,%eax
  802047:	74 18                	je     802061 <initialize_MemBlocksList+0x88>
  802049:	a1 48 51 80 00       	mov    0x805148,%eax
  80204e:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802054:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802057:	c1 e1 04             	shl    $0x4,%ecx
  80205a:	01 ca                	add    %ecx,%edx
  80205c:	89 50 04             	mov    %edx,0x4(%eax)
  80205f:	eb 12                	jmp    802073 <initialize_MemBlocksList+0x9a>
  802061:	a1 50 50 80 00       	mov    0x805050,%eax
  802066:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802069:	c1 e2 04             	shl    $0x4,%edx
  80206c:	01 d0                	add    %edx,%eax
  80206e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802073:	a1 50 50 80 00       	mov    0x805050,%eax
  802078:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80207b:	c1 e2 04             	shl    $0x4,%edx
  80207e:	01 d0                	add    %edx,%eax
  802080:	a3 48 51 80 00       	mov    %eax,0x805148
  802085:	a1 50 50 80 00       	mov    0x805050,%eax
  80208a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80208d:	c1 e2 04             	shl    $0x4,%edx
  802090:	01 d0                	add    %edx,%eax
  802092:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802099:	a1 54 51 80 00       	mov    0x805154,%eax
  80209e:	40                   	inc    %eax
  80209f:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  8020a4:	ff 45 f4             	incl   -0xc(%ebp)
  8020a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020aa:	3b 45 08             	cmp    0x8(%ebp),%eax
  8020ad:	0f 82 56 ff ff ff    	jb     802009 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  8020b3:	90                   	nop
  8020b4:	c9                   	leave  
  8020b5:	c3                   	ret    

008020b6 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8020b6:	55                   	push   %ebp
  8020b7:	89 e5                	mov    %esp,%ebp
  8020b9:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8020bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bf:	8b 00                	mov    (%eax),%eax
  8020c1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020c4:	eb 19                	jmp    8020df <find_block+0x29>
	{
		if(va==point->sva)
  8020c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020c9:	8b 40 08             	mov    0x8(%eax),%eax
  8020cc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8020cf:	75 05                	jne    8020d6 <find_block+0x20>
		   return point;
  8020d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020d4:	eb 36                	jmp    80210c <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8020d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d9:	8b 40 08             	mov    0x8(%eax),%eax
  8020dc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020df:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020e3:	74 07                	je     8020ec <find_block+0x36>
  8020e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020e8:	8b 00                	mov    (%eax),%eax
  8020ea:	eb 05                	jmp    8020f1 <find_block+0x3b>
  8020ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8020f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8020f4:	89 42 08             	mov    %eax,0x8(%edx)
  8020f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fa:	8b 40 08             	mov    0x8(%eax),%eax
  8020fd:	85 c0                	test   %eax,%eax
  8020ff:	75 c5                	jne    8020c6 <find_block+0x10>
  802101:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802105:	75 bf                	jne    8020c6 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802107:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80210c:	c9                   	leave  
  80210d:	c3                   	ret    

0080210e <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80210e:	55                   	push   %ebp
  80210f:	89 e5                	mov    %esp,%ebp
  802111:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802114:	a1 40 50 80 00       	mov    0x805040,%eax
  802119:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  80211c:	a1 44 50 80 00       	mov    0x805044,%eax
  802121:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802124:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802127:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80212a:	74 24                	je     802150 <insert_sorted_allocList+0x42>
  80212c:	8b 45 08             	mov    0x8(%ebp),%eax
  80212f:	8b 50 08             	mov    0x8(%eax),%edx
  802132:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802135:	8b 40 08             	mov    0x8(%eax),%eax
  802138:	39 c2                	cmp    %eax,%edx
  80213a:	76 14                	jbe    802150 <insert_sorted_allocList+0x42>
  80213c:	8b 45 08             	mov    0x8(%ebp),%eax
  80213f:	8b 50 08             	mov    0x8(%eax),%edx
  802142:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802145:	8b 40 08             	mov    0x8(%eax),%eax
  802148:	39 c2                	cmp    %eax,%edx
  80214a:	0f 82 60 01 00 00    	jb     8022b0 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802150:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802154:	75 65                	jne    8021bb <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802156:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80215a:	75 14                	jne    802170 <insert_sorted_allocList+0x62>
  80215c:	83 ec 04             	sub    $0x4,%esp
  80215f:	68 14 40 80 00       	push   $0x804014
  802164:	6a 6b                	push   $0x6b
  802166:	68 37 40 80 00       	push   $0x804037
  80216b:	e8 07 e1 ff ff       	call   800277 <_panic>
  802170:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802176:	8b 45 08             	mov    0x8(%ebp),%eax
  802179:	89 10                	mov    %edx,(%eax)
  80217b:	8b 45 08             	mov    0x8(%ebp),%eax
  80217e:	8b 00                	mov    (%eax),%eax
  802180:	85 c0                	test   %eax,%eax
  802182:	74 0d                	je     802191 <insert_sorted_allocList+0x83>
  802184:	a1 40 50 80 00       	mov    0x805040,%eax
  802189:	8b 55 08             	mov    0x8(%ebp),%edx
  80218c:	89 50 04             	mov    %edx,0x4(%eax)
  80218f:	eb 08                	jmp    802199 <insert_sorted_allocList+0x8b>
  802191:	8b 45 08             	mov    0x8(%ebp),%eax
  802194:	a3 44 50 80 00       	mov    %eax,0x805044
  802199:	8b 45 08             	mov    0x8(%ebp),%eax
  80219c:	a3 40 50 80 00       	mov    %eax,0x805040
  8021a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021ab:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8021b0:	40                   	inc    %eax
  8021b1:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8021b6:	e9 dc 01 00 00       	jmp    802397 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8021bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021be:	8b 50 08             	mov    0x8(%eax),%edx
  8021c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021c4:	8b 40 08             	mov    0x8(%eax),%eax
  8021c7:	39 c2                	cmp    %eax,%edx
  8021c9:	77 6c                	ja     802237 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8021cb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021cf:	74 06                	je     8021d7 <insert_sorted_allocList+0xc9>
  8021d1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021d5:	75 14                	jne    8021eb <insert_sorted_allocList+0xdd>
  8021d7:	83 ec 04             	sub    $0x4,%esp
  8021da:	68 50 40 80 00       	push   $0x804050
  8021df:	6a 6f                	push   $0x6f
  8021e1:	68 37 40 80 00       	push   $0x804037
  8021e6:	e8 8c e0 ff ff       	call   800277 <_panic>
  8021eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021ee:	8b 50 04             	mov    0x4(%eax),%edx
  8021f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f4:	89 50 04             	mov    %edx,0x4(%eax)
  8021f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021fd:	89 10                	mov    %edx,(%eax)
  8021ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802202:	8b 40 04             	mov    0x4(%eax),%eax
  802205:	85 c0                	test   %eax,%eax
  802207:	74 0d                	je     802216 <insert_sorted_allocList+0x108>
  802209:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80220c:	8b 40 04             	mov    0x4(%eax),%eax
  80220f:	8b 55 08             	mov    0x8(%ebp),%edx
  802212:	89 10                	mov    %edx,(%eax)
  802214:	eb 08                	jmp    80221e <insert_sorted_allocList+0x110>
  802216:	8b 45 08             	mov    0x8(%ebp),%eax
  802219:	a3 40 50 80 00       	mov    %eax,0x805040
  80221e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802221:	8b 55 08             	mov    0x8(%ebp),%edx
  802224:	89 50 04             	mov    %edx,0x4(%eax)
  802227:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80222c:	40                   	inc    %eax
  80222d:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802232:	e9 60 01 00 00       	jmp    802397 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802237:	8b 45 08             	mov    0x8(%ebp),%eax
  80223a:	8b 50 08             	mov    0x8(%eax),%edx
  80223d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802240:	8b 40 08             	mov    0x8(%eax),%eax
  802243:	39 c2                	cmp    %eax,%edx
  802245:	0f 82 4c 01 00 00    	jb     802397 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  80224b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80224f:	75 14                	jne    802265 <insert_sorted_allocList+0x157>
  802251:	83 ec 04             	sub    $0x4,%esp
  802254:	68 88 40 80 00       	push   $0x804088
  802259:	6a 73                	push   $0x73
  80225b:	68 37 40 80 00       	push   $0x804037
  802260:	e8 12 e0 ff ff       	call   800277 <_panic>
  802265:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80226b:	8b 45 08             	mov    0x8(%ebp),%eax
  80226e:	89 50 04             	mov    %edx,0x4(%eax)
  802271:	8b 45 08             	mov    0x8(%ebp),%eax
  802274:	8b 40 04             	mov    0x4(%eax),%eax
  802277:	85 c0                	test   %eax,%eax
  802279:	74 0c                	je     802287 <insert_sorted_allocList+0x179>
  80227b:	a1 44 50 80 00       	mov    0x805044,%eax
  802280:	8b 55 08             	mov    0x8(%ebp),%edx
  802283:	89 10                	mov    %edx,(%eax)
  802285:	eb 08                	jmp    80228f <insert_sorted_allocList+0x181>
  802287:	8b 45 08             	mov    0x8(%ebp),%eax
  80228a:	a3 40 50 80 00       	mov    %eax,0x805040
  80228f:	8b 45 08             	mov    0x8(%ebp),%eax
  802292:	a3 44 50 80 00       	mov    %eax,0x805044
  802297:	8b 45 08             	mov    0x8(%ebp),%eax
  80229a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022a0:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8022a5:	40                   	inc    %eax
  8022a6:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8022ab:	e9 e7 00 00 00       	jmp    802397 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8022b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8022b6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8022bd:	a1 40 50 80 00       	mov    0x805040,%eax
  8022c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022c5:	e9 9d 00 00 00       	jmp    802367 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8022ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022cd:	8b 00                	mov    (%eax),%eax
  8022cf:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8022d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d5:	8b 50 08             	mov    0x8(%eax),%edx
  8022d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022db:	8b 40 08             	mov    0x8(%eax),%eax
  8022de:	39 c2                	cmp    %eax,%edx
  8022e0:	76 7d                	jbe    80235f <insert_sorted_allocList+0x251>
  8022e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e5:	8b 50 08             	mov    0x8(%eax),%edx
  8022e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022eb:	8b 40 08             	mov    0x8(%eax),%eax
  8022ee:	39 c2                	cmp    %eax,%edx
  8022f0:	73 6d                	jae    80235f <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8022f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022f6:	74 06                	je     8022fe <insert_sorted_allocList+0x1f0>
  8022f8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022fc:	75 14                	jne    802312 <insert_sorted_allocList+0x204>
  8022fe:	83 ec 04             	sub    $0x4,%esp
  802301:	68 ac 40 80 00       	push   $0x8040ac
  802306:	6a 7f                	push   $0x7f
  802308:	68 37 40 80 00       	push   $0x804037
  80230d:	e8 65 df ff ff       	call   800277 <_panic>
  802312:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802315:	8b 10                	mov    (%eax),%edx
  802317:	8b 45 08             	mov    0x8(%ebp),%eax
  80231a:	89 10                	mov    %edx,(%eax)
  80231c:	8b 45 08             	mov    0x8(%ebp),%eax
  80231f:	8b 00                	mov    (%eax),%eax
  802321:	85 c0                	test   %eax,%eax
  802323:	74 0b                	je     802330 <insert_sorted_allocList+0x222>
  802325:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802328:	8b 00                	mov    (%eax),%eax
  80232a:	8b 55 08             	mov    0x8(%ebp),%edx
  80232d:	89 50 04             	mov    %edx,0x4(%eax)
  802330:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802333:	8b 55 08             	mov    0x8(%ebp),%edx
  802336:	89 10                	mov    %edx,(%eax)
  802338:	8b 45 08             	mov    0x8(%ebp),%eax
  80233b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80233e:	89 50 04             	mov    %edx,0x4(%eax)
  802341:	8b 45 08             	mov    0x8(%ebp),%eax
  802344:	8b 00                	mov    (%eax),%eax
  802346:	85 c0                	test   %eax,%eax
  802348:	75 08                	jne    802352 <insert_sorted_allocList+0x244>
  80234a:	8b 45 08             	mov    0x8(%ebp),%eax
  80234d:	a3 44 50 80 00       	mov    %eax,0x805044
  802352:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802357:	40                   	inc    %eax
  802358:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  80235d:	eb 39                	jmp    802398 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80235f:	a1 48 50 80 00       	mov    0x805048,%eax
  802364:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802367:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80236b:	74 07                	je     802374 <insert_sorted_allocList+0x266>
  80236d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802370:	8b 00                	mov    (%eax),%eax
  802372:	eb 05                	jmp    802379 <insert_sorted_allocList+0x26b>
  802374:	b8 00 00 00 00       	mov    $0x0,%eax
  802379:	a3 48 50 80 00       	mov    %eax,0x805048
  80237e:	a1 48 50 80 00       	mov    0x805048,%eax
  802383:	85 c0                	test   %eax,%eax
  802385:	0f 85 3f ff ff ff    	jne    8022ca <insert_sorted_allocList+0x1bc>
  80238b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80238f:	0f 85 35 ff ff ff    	jne    8022ca <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802395:	eb 01                	jmp    802398 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802397:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802398:	90                   	nop
  802399:	c9                   	leave  
  80239a:	c3                   	ret    

0080239b <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80239b:	55                   	push   %ebp
  80239c:	89 e5                	mov    %esp,%ebp
  80239e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8023a1:	a1 38 51 80 00       	mov    0x805138,%eax
  8023a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023a9:	e9 85 01 00 00       	jmp    802533 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8023ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b1:	8b 40 0c             	mov    0xc(%eax),%eax
  8023b4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023b7:	0f 82 6e 01 00 00    	jb     80252b <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8023bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c0:	8b 40 0c             	mov    0xc(%eax),%eax
  8023c3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023c6:	0f 85 8a 00 00 00    	jne    802456 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8023cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023d0:	75 17                	jne    8023e9 <alloc_block_FF+0x4e>
  8023d2:	83 ec 04             	sub    $0x4,%esp
  8023d5:	68 e0 40 80 00       	push   $0x8040e0
  8023da:	68 93 00 00 00       	push   $0x93
  8023df:	68 37 40 80 00       	push   $0x804037
  8023e4:	e8 8e de ff ff       	call   800277 <_panic>
  8023e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ec:	8b 00                	mov    (%eax),%eax
  8023ee:	85 c0                	test   %eax,%eax
  8023f0:	74 10                	je     802402 <alloc_block_FF+0x67>
  8023f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f5:	8b 00                	mov    (%eax),%eax
  8023f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023fa:	8b 52 04             	mov    0x4(%edx),%edx
  8023fd:	89 50 04             	mov    %edx,0x4(%eax)
  802400:	eb 0b                	jmp    80240d <alloc_block_FF+0x72>
  802402:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802405:	8b 40 04             	mov    0x4(%eax),%eax
  802408:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80240d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802410:	8b 40 04             	mov    0x4(%eax),%eax
  802413:	85 c0                	test   %eax,%eax
  802415:	74 0f                	je     802426 <alloc_block_FF+0x8b>
  802417:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241a:	8b 40 04             	mov    0x4(%eax),%eax
  80241d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802420:	8b 12                	mov    (%edx),%edx
  802422:	89 10                	mov    %edx,(%eax)
  802424:	eb 0a                	jmp    802430 <alloc_block_FF+0x95>
  802426:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802429:	8b 00                	mov    (%eax),%eax
  80242b:	a3 38 51 80 00       	mov    %eax,0x805138
  802430:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802433:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802439:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802443:	a1 44 51 80 00       	mov    0x805144,%eax
  802448:	48                   	dec    %eax
  802449:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  80244e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802451:	e9 10 01 00 00       	jmp    802566 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802456:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802459:	8b 40 0c             	mov    0xc(%eax),%eax
  80245c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80245f:	0f 86 c6 00 00 00    	jbe    80252b <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802465:	a1 48 51 80 00       	mov    0x805148,%eax
  80246a:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  80246d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802470:	8b 50 08             	mov    0x8(%eax),%edx
  802473:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802476:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802479:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80247c:	8b 55 08             	mov    0x8(%ebp),%edx
  80247f:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802482:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802486:	75 17                	jne    80249f <alloc_block_FF+0x104>
  802488:	83 ec 04             	sub    $0x4,%esp
  80248b:	68 e0 40 80 00       	push   $0x8040e0
  802490:	68 9b 00 00 00       	push   $0x9b
  802495:	68 37 40 80 00       	push   $0x804037
  80249a:	e8 d8 dd ff ff       	call   800277 <_panic>
  80249f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024a2:	8b 00                	mov    (%eax),%eax
  8024a4:	85 c0                	test   %eax,%eax
  8024a6:	74 10                	je     8024b8 <alloc_block_FF+0x11d>
  8024a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024ab:	8b 00                	mov    (%eax),%eax
  8024ad:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024b0:	8b 52 04             	mov    0x4(%edx),%edx
  8024b3:	89 50 04             	mov    %edx,0x4(%eax)
  8024b6:	eb 0b                	jmp    8024c3 <alloc_block_FF+0x128>
  8024b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024bb:	8b 40 04             	mov    0x4(%eax),%eax
  8024be:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8024c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024c6:	8b 40 04             	mov    0x4(%eax),%eax
  8024c9:	85 c0                	test   %eax,%eax
  8024cb:	74 0f                	je     8024dc <alloc_block_FF+0x141>
  8024cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024d0:	8b 40 04             	mov    0x4(%eax),%eax
  8024d3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024d6:	8b 12                	mov    (%edx),%edx
  8024d8:	89 10                	mov    %edx,(%eax)
  8024da:	eb 0a                	jmp    8024e6 <alloc_block_FF+0x14b>
  8024dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024df:	8b 00                	mov    (%eax),%eax
  8024e1:	a3 48 51 80 00       	mov    %eax,0x805148
  8024e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024f2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024f9:	a1 54 51 80 00       	mov    0x805154,%eax
  8024fe:	48                   	dec    %eax
  8024ff:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802504:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802507:	8b 50 08             	mov    0x8(%eax),%edx
  80250a:	8b 45 08             	mov    0x8(%ebp),%eax
  80250d:	01 c2                	add    %eax,%edx
  80250f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802512:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802515:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802518:	8b 40 0c             	mov    0xc(%eax),%eax
  80251b:	2b 45 08             	sub    0x8(%ebp),%eax
  80251e:	89 c2                	mov    %eax,%edx
  802520:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802523:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802526:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802529:	eb 3b                	jmp    802566 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80252b:	a1 40 51 80 00       	mov    0x805140,%eax
  802530:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802533:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802537:	74 07                	je     802540 <alloc_block_FF+0x1a5>
  802539:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253c:	8b 00                	mov    (%eax),%eax
  80253e:	eb 05                	jmp    802545 <alloc_block_FF+0x1aa>
  802540:	b8 00 00 00 00       	mov    $0x0,%eax
  802545:	a3 40 51 80 00       	mov    %eax,0x805140
  80254a:	a1 40 51 80 00       	mov    0x805140,%eax
  80254f:	85 c0                	test   %eax,%eax
  802551:	0f 85 57 fe ff ff    	jne    8023ae <alloc_block_FF+0x13>
  802557:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80255b:	0f 85 4d fe ff ff    	jne    8023ae <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802561:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802566:	c9                   	leave  
  802567:	c3                   	ret    

00802568 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802568:	55                   	push   %ebp
  802569:	89 e5                	mov    %esp,%ebp
  80256b:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  80256e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802575:	a1 38 51 80 00       	mov    0x805138,%eax
  80257a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80257d:	e9 df 00 00 00       	jmp    802661 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802582:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802585:	8b 40 0c             	mov    0xc(%eax),%eax
  802588:	3b 45 08             	cmp    0x8(%ebp),%eax
  80258b:	0f 82 c8 00 00 00    	jb     802659 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802591:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802594:	8b 40 0c             	mov    0xc(%eax),%eax
  802597:	3b 45 08             	cmp    0x8(%ebp),%eax
  80259a:	0f 85 8a 00 00 00    	jne    80262a <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8025a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025a4:	75 17                	jne    8025bd <alloc_block_BF+0x55>
  8025a6:	83 ec 04             	sub    $0x4,%esp
  8025a9:	68 e0 40 80 00       	push   $0x8040e0
  8025ae:	68 b7 00 00 00       	push   $0xb7
  8025b3:	68 37 40 80 00       	push   $0x804037
  8025b8:	e8 ba dc ff ff       	call   800277 <_panic>
  8025bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c0:	8b 00                	mov    (%eax),%eax
  8025c2:	85 c0                	test   %eax,%eax
  8025c4:	74 10                	je     8025d6 <alloc_block_BF+0x6e>
  8025c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c9:	8b 00                	mov    (%eax),%eax
  8025cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025ce:	8b 52 04             	mov    0x4(%edx),%edx
  8025d1:	89 50 04             	mov    %edx,0x4(%eax)
  8025d4:	eb 0b                	jmp    8025e1 <alloc_block_BF+0x79>
  8025d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d9:	8b 40 04             	mov    0x4(%eax),%eax
  8025dc:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8025e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e4:	8b 40 04             	mov    0x4(%eax),%eax
  8025e7:	85 c0                	test   %eax,%eax
  8025e9:	74 0f                	je     8025fa <alloc_block_BF+0x92>
  8025eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ee:	8b 40 04             	mov    0x4(%eax),%eax
  8025f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025f4:	8b 12                	mov    (%edx),%edx
  8025f6:	89 10                	mov    %edx,(%eax)
  8025f8:	eb 0a                	jmp    802604 <alloc_block_BF+0x9c>
  8025fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fd:	8b 00                	mov    (%eax),%eax
  8025ff:	a3 38 51 80 00       	mov    %eax,0x805138
  802604:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802607:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80260d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802610:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802617:	a1 44 51 80 00       	mov    0x805144,%eax
  80261c:	48                   	dec    %eax
  80261d:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802622:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802625:	e9 4d 01 00 00       	jmp    802777 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  80262a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262d:	8b 40 0c             	mov    0xc(%eax),%eax
  802630:	3b 45 08             	cmp    0x8(%ebp),%eax
  802633:	76 24                	jbe    802659 <alloc_block_BF+0xf1>
  802635:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802638:	8b 40 0c             	mov    0xc(%eax),%eax
  80263b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80263e:	73 19                	jae    802659 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802640:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802647:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264a:	8b 40 0c             	mov    0xc(%eax),%eax
  80264d:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802650:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802653:	8b 40 08             	mov    0x8(%eax),%eax
  802656:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802659:	a1 40 51 80 00       	mov    0x805140,%eax
  80265e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802661:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802665:	74 07                	je     80266e <alloc_block_BF+0x106>
  802667:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266a:	8b 00                	mov    (%eax),%eax
  80266c:	eb 05                	jmp    802673 <alloc_block_BF+0x10b>
  80266e:	b8 00 00 00 00       	mov    $0x0,%eax
  802673:	a3 40 51 80 00       	mov    %eax,0x805140
  802678:	a1 40 51 80 00       	mov    0x805140,%eax
  80267d:	85 c0                	test   %eax,%eax
  80267f:	0f 85 fd fe ff ff    	jne    802582 <alloc_block_BF+0x1a>
  802685:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802689:	0f 85 f3 fe ff ff    	jne    802582 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  80268f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802693:	0f 84 d9 00 00 00    	je     802772 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802699:	a1 48 51 80 00       	mov    0x805148,%eax
  80269e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8026a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026a4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026a7:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8026aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8026b0:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8026b3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8026b7:	75 17                	jne    8026d0 <alloc_block_BF+0x168>
  8026b9:	83 ec 04             	sub    $0x4,%esp
  8026bc:	68 e0 40 80 00       	push   $0x8040e0
  8026c1:	68 c7 00 00 00       	push   $0xc7
  8026c6:	68 37 40 80 00       	push   $0x804037
  8026cb:	e8 a7 db ff ff       	call   800277 <_panic>
  8026d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026d3:	8b 00                	mov    (%eax),%eax
  8026d5:	85 c0                	test   %eax,%eax
  8026d7:	74 10                	je     8026e9 <alloc_block_BF+0x181>
  8026d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026dc:	8b 00                	mov    (%eax),%eax
  8026de:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026e1:	8b 52 04             	mov    0x4(%edx),%edx
  8026e4:	89 50 04             	mov    %edx,0x4(%eax)
  8026e7:	eb 0b                	jmp    8026f4 <alloc_block_BF+0x18c>
  8026e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026ec:	8b 40 04             	mov    0x4(%eax),%eax
  8026ef:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8026f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026f7:	8b 40 04             	mov    0x4(%eax),%eax
  8026fa:	85 c0                	test   %eax,%eax
  8026fc:	74 0f                	je     80270d <alloc_block_BF+0x1a5>
  8026fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802701:	8b 40 04             	mov    0x4(%eax),%eax
  802704:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802707:	8b 12                	mov    (%edx),%edx
  802709:	89 10                	mov    %edx,(%eax)
  80270b:	eb 0a                	jmp    802717 <alloc_block_BF+0x1af>
  80270d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802710:	8b 00                	mov    (%eax),%eax
  802712:	a3 48 51 80 00       	mov    %eax,0x805148
  802717:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80271a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802720:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802723:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80272a:	a1 54 51 80 00       	mov    0x805154,%eax
  80272f:	48                   	dec    %eax
  802730:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802735:	83 ec 08             	sub    $0x8,%esp
  802738:	ff 75 ec             	pushl  -0x14(%ebp)
  80273b:	68 38 51 80 00       	push   $0x805138
  802740:	e8 71 f9 ff ff       	call   8020b6 <find_block>
  802745:	83 c4 10             	add    $0x10,%esp
  802748:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  80274b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80274e:	8b 50 08             	mov    0x8(%eax),%edx
  802751:	8b 45 08             	mov    0x8(%ebp),%eax
  802754:	01 c2                	add    %eax,%edx
  802756:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802759:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  80275c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80275f:	8b 40 0c             	mov    0xc(%eax),%eax
  802762:	2b 45 08             	sub    0x8(%ebp),%eax
  802765:	89 c2                	mov    %eax,%edx
  802767:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80276a:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  80276d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802770:	eb 05                	jmp    802777 <alloc_block_BF+0x20f>
	}
	return NULL;
  802772:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802777:	c9                   	leave  
  802778:	c3                   	ret    

00802779 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802779:	55                   	push   %ebp
  80277a:	89 e5                	mov    %esp,%ebp
  80277c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  80277f:	a1 28 50 80 00       	mov    0x805028,%eax
  802784:	85 c0                	test   %eax,%eax
  802786:	0f 85 de 01 00 00    	jne    80296a <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80278c:	a1 38 51 80 00       	mov    0x805138,%eax
  802791:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802794:	e9 9e 01 00 00       	jmp    802937 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802799:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279c:	8b 40 0c             	mov    0xc(%eax),%eax
  80279f:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027a2:	0f 82 87 01 00 00    	jb     80292f <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8027a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ab:	8b 40 0c             	mov    0xc(%eax),%eax
  8027ae:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027b1:	0f 85 95 00 00 00    	jne    80284c <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8027b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027bb:	75 17                	jne    8027d4 <alloc_block_NF+0x5b>
  8027bd:	83 ec 04             	sub    $0x4,%esp
  8027c0:	68 e0 40 80 00       	push   $0x8040e0
  8027c5:	68 e0 00 00 00       	push   $0xe0
  8027ca:	68 37 40 80 00       	push   $0x804037
  8027cf:	e8 a3 da ff ff       	call   800277 <_panic>
  8027d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d7:	8b 00                	mov    (%eax),%eax
  8027d9:	85 c0                	test   %eax,%eax
  8027db:	74 10                	je     8027ed <alloc_block_NF+0x74>
  8027dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e0:	8b 00                	mov    (%eax),%eax
  8027e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027e5:	8b 52 04             	mov    0x4(%edx),%edx
  8027e8:	89 50 04             	mov    %edx,0x4(%eax)
  8027eb:	eb 0b                	jmp    8027f8 <alloc_block_NF+0x7f>
  8027ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f0:	8b 40 04             	mov    0x4(%eax),%eax
  8027f3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8027f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fb:	8b 40 04             	mov    0x4(%eax),%eax
  8027fe:	85 c0                	test   %eax,%eax
  802800:	74 0f                	je     802811 <alloc_block_NF+0x98>
  802802:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802805:	8b 40 04             	mov    0x4(%eax),%eax
  802808:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80280b:	8b 12                	mov    (%edx),%edx
  80280d:	89 10                	mov    %edx,(%eax)
  80280f:	eb 0a                	jmp    80281b <alloc_block_NF+0xa2>
  802811:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802814:	8b 00                	mov    (%eax),%eax
  802816:	a3 38 51 80 00       	mov    %eax,0x805138
  80281b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802824:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802827:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80282e:	a1 44 51 80 00       	mov    0x805144,%eax
  802833:	48                   	dec    %eax
  802834:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802839:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283c:	8b 40 08             	mov    0x8(%eax),%eax
  80283f:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802844:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802847:	e9 f8 04 00 00       	jmp    802d44 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  80284c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284f:	8b 40 0c             	mov    0xc(%eax),%eax
  802852:	3b 45 08             	cmp    0x8(%ebp),%eax
  802855:	0f 86 d4 00 00 00    	jbe    80292f <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80285b:	a1 48 51 80 00       	mov    0x805148,%eax
  802860:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802863:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802866:	8b 50 08             	mov    0x8(%eax),%edx
  802869:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80286c:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  80286f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802872:	8b 55 08             	mov    0x8(%ebp),%edx
  802875:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802878:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80287c:	75 17                	jne    802895 <alloc_block_NF+0x11c>
  80287e:	83 ec 04             	sub    $0x4,%esp
  802881:	68 e0 40 80 00       	push   $0x8040e0
  802886:	68 e9 00 00 00       	push   $0xe9
  80288b:	68 37 40 80 00       	push   $0x804037
  802890:	e8 e2 d9 ff ff       	call   800277 <_panic>
  802895:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802898:	8b 00                	mov    (%eax),%eax
  80289a:	85 c0                	test   %eax,%eax
  80289c:	74 10                	je     8028ae <alloc_block_NF+0x135>
  80289e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a1:	8b 00                	mov    (%eax),%eax
  8028a3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028a6:	8b 52 04             	mov    0x4(%edx),%edx
  8028a9:	89 50 04             	mov    %edx,0x4(%eax)
  8028ac:	eb 0b                	jmp    8028b9 <alloc_block_NF+0x140>
  8028ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b1:	8b 40 04             	mov    0x4(%eax),%eax
  8028b4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8028b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028bc:	8b 40 04             	mov    0x4(%eax),%eax
  8028bf:	85 c0                	test   %eax,%eax
  8028c1:	74 0f                	je     8028d2 <alloc_block_NF+0x159>
  8028c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c6:	8b 40 04             	mov    0x4(%eax),%eax
  8028c9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028cc:	8b 12                	mov    (%edx),%edx
  8028ce:	89 10                	mov    %edx,(%eax)
  8028d0:	eb 0a                	jmp    8028dc <alloc_block_NF+0x163>
  8028d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028d5:	8b 00                	mov    (%eax),%eax
  8028d7:	a3 48 51 80 00       	mov    %eax,0x805148
  8028dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028df:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028ef:	a1 54 51 80 00       	mov    0x805154,%eax
  8028f4:	48                   	dec    %eax
  8028f5:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  8028fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028fd:	8b 40 08             	mov    0x8(%eax),%eax
  802900:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802905:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802908:	8b 50 08             	mov    0x8(%eax),%edx
  80290b:	8b 45 08             	mov    0x8(%ebp),%eax
  80290e:	01 c2                	add    %eax,%edx
  802910:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802913:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802916:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802919:	8b 40 0c             	mov    0xc(%eax),%eax
  80291c:	2b 45 08             	sub    0x8(%ebp),%eax
  80291f:	89 c2                	mov    %eax,%edx
  802921:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802924:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802927:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80292a:	e9 15 04 00 00       	jmp    802d44 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80292f:	a1 40 51 80 00       	mov    0x805140,%eax
  802934:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802937:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80293b:	74 07                	je     802944 <alloc_block_NF+0x1cb>
  80293d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802940:	8b 00                	mov    (%eax),%eax
  802942:	eb 05                	jmp    802949 <alloc_block_NF+0x1d0>
  802944:	b8 00 00 00 00       	mov    $0x0,%eax
  802949:	a3 40 51 80 00       	mov    %eax,0x805140
  80294e:	a1 40 51 80 00       	mov    0x805140,%eax
  802953:	85 c0                	test   %eax,%eax
  802955:	0f 85 3e fe ff ff    	jne    802799 <alloc_block_NF+0x20>
  80295b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80295f:	0f 85 34 fe ff ff    	jne    802799 <alloc_block_NF+0x20>
  802965:	e9 d5 03 00 00       	jmp    802d3f <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  80296a:	a1 38 51 80 00       	mov    0x805138,%eax
  80296f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802972:	e9 b1 01 00 00       	jmp    802b28 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802977:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297a:	8b 50 08             	mov    0x8(%eax),%edx
  80297d:	a1 28 50 80 00       	mov    0x805028,%eax
  802982:	39 c2                	cmp    %eax,%edx
  802984:	0f 82 96 01 00 00    	jb     802b20 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  80298a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298d:	8b 40 0c             	mov    0xc(%eax),%eax
  802990:	3b 45 08             	cmp    0x8(%ebp),%eax
  802993:	0f 82 87 01 00 00    	jb     802b20 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802999:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299c:	8b 40 0c             	mov    0xc(%eax),%eax
  80299f:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029a2:	0f 85 95 00 00 00    	jne    802a3d <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8029a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029ac:	75 17                	jne    8029c5 <alloc_block_NF+0x24c>
  8029ae:	83 ec 04             	sub    $0x4,%esp
  8029b1:	68 e0 40 80 00       	push   $0x8040e0
  8029b6:	68 fc 00 00 00       	push   $0xfc
  8029bb:	68 37 40 80 00       	push   $0x804037
  8029c0:	e8 b2 d8 ff ff       	call   800277 <_panic>
  8029c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c8:	8b 00                	mov    (%eax),%eax
  8029ca:	85 c0                	test   %eax,%eax
  8029cc:	74 10                	je     8029de <alloc_block_NF+0x265>
  8029ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d1:	8b 00                	mov    (%eax),%eax
  8029d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029d6:	8b 52 04             	mov    0x4(%edx),%edx
  8029d9:	89 50 04             	mov    %edx,0x4(%eax)
  8029dc:	eb 0b                	jmp    8029e9 <alloc_block_NF+0x270>
  8029de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e1:	8b 40 04             	mov    0x4(%eax),%eax
  8029e4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8029e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ec:	8b 40 04             	mov    0x4(%eax),%eax
  8029ef:	85 c0                	test   %eax,%eax
  8029f1:	74 0f                	je     802a02 <alloc_block_NF+0x289>
  8029f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f6:	8b 40 04             	mov    0x4(%eax),%eax
  8029f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029fc:	8b 12                	mov    (%edx),%edx
  8029fe:	89 10                	mov    %edx,(%eax)
  802a00:	eb 0a                	jmp    802a0c <alloc_block_NF+0x293>
  802a02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a05:	8b 00                	mov    (%eax),%eax
  802a07:	a3 38 51 80 00       	mov    %eax,0x805138
  802a0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a18:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a1f:	a1 44 51 80 00       	mov    0x805144,%eax
  802a24:	48                   	dec    %eax
  802a25:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802a2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2d:	8b 40 08             	mov    0x8(%eax),%eax
  802a30:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a38:	e9 07 03 00 00       	jmp    802d44 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802a3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a40:	8b 40 0c             	mov    0xc(%eax),%eax
  802a43:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a46:	0f 86 d4 00 00 00    	jbe    802b20 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802a4c:	a1 48 51 80 00       	mov    0x805148,%eax
  802a51:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802a54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a57:	8b 50 08             	mov    0x8(%eax),%edx
  802a5a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a5d:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802a60:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a63:	8b 55 08             	mov    0x8(%ebp),%edx
  802a66:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802a69:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802a6d:	75 17                	jne    802a86 <alloc_block_NF+0x30d>
  802a6f:	83 ec 04             	sub    $0x4,%esp
  802a72:	68 e0 40 80 00       	push   $0x8040e0
  802a77:	68 04 01 00 00       	push   $0x104
  802a7c:	68 37 40 80 00       	push   $0x804037
  802a81:	e8 f1 d7 ff ff       	call   800277 <_panic>
  802a86:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a89:	8b 00                	mov    (%eax),%eax
  802a8b:	85 c0                	test   %eax,%eax
  802a8d:	74 10                	je     802a9f <alloc_block_NF+0x326>
  802a8f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a92:	8b 00                	mov    (%eax),%eax
  802a94:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a97:	8b 52 04             	mov    0x4(%edx),%edx
  802a9a:	89 50 04             	mov    %edx,0x4(%eax)
  802a9d:	eb 0b                	jmp    802aaa <alloc_block_NF+0x331>
  802a9f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aa2:	8b 40 04             	mov    0x4(%eax),%eax
  802aa5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802aaa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aad:	8b 40 04             	mov    0x4(%eax),%eax
  802ab0:	85 c0                	test   %eax,%eax
  802ab2:	74 0f                	je     802ac3 <alloc_block_NF+0x34a>
  802ab4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ab7:	8b 40 04             	mov    0x4(%eax),%eax
  802aba:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802abd:	8b 12                	mov    (%edx),%edx
  802abf:	89 10                	mov    %edx,(%eax)
  802ac1:	eb 0a                	jmp    802acd <alloc_block_NF+0x354>
  802ac3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ac6:	8b 00                	mov    (%eax),%eax
  802ac8:	a3 48 51 80 00       	mov    %eax,0x805148
  802acd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ad0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ad6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ad9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ae0:	a1 54 51 80 00       	mov    0x805154,%eax
  802ae5:	48                   	dec    %eax
  802ae6:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802aeb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aee:	8b 40 08             	mov    0x8(%eax),%eax
  802af1:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802af6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af9:	8b 50 08             	mov    0x8(%eax),%edx
  802afc:	8b 45 08             	mov    0x8(%ebp),%eax
  802aff:	01 c2                	add    %eax,%edx
  802b01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b04:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802b07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0a:	8b 40 0c             	mov    0xc(%eax),%eax
  802b0d:	2b 45 08             	sub    0x8(%ebp),%eax
  802b10:	89 c2                	mov    %eax,%edx
  802b12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b15:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802b18:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b1b:	e9 24 02 00 00       	jmp    802d44 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b20:	a1 40 51 80 00       	mov    0x805140,%eax
  802b25:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b28:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b2c:	74 07                	je     802b35 <alloc_block_NF+0x3bc>
  802b2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b31:	8b 00                	mov    (%eax),%eax
  802b33:	eb 05                	jmp    802b3a <alloc_block_NF+0x3c1>
  802b35:	b8 00 00 00 00       	mov    $0x0,%eax
  802b3a:	a3 40 51 80 00       	mov    %eax,0x805140
  802b3f:	a1 40 51 80 00       	mov    0x805140,%eax
  802b44:	85 c0                	test   %eax,%eax
  802b46:	0f 85 2b fe ff ff    	jne    802977 <alloc_block_NF+0x1fe>
  802b4c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b50:	0f 85 21 fe ff ff    	jne    802977 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b56:	a1 38 51 80 00       	mov    0x805138,%eax
  802b5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b5e:	e9 ae 01 00 00       	jmp    802d11 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802b63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b66:	8b 50 08             	mov    0x8(%eax),%edx
  802b69:	a1 28 50 80 00       	mov    0x805028,%eax
  802b6e:	39 c2                	cmp    %eax,%edx
  802b70:	0f 83 93 01 00 00    	jae    802d09 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802b76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b79:	8b 40 0c             	mov    0xc(%eax),%eax
  802b7c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b7f:	0f 82 84 01 00 00    	jb     802d09 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802b85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b88:	8b 40 0c             	mov    0xc(%eax),%eax
  802b8b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b8e:	0f 85 95 00 00 00    	jne    802c29 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802b94:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b98:	75 17                	jne    802bb1 <alloc_block_NF+0x438>
  802b9a:	83 ec 04             	sub    $0x4,%esp
  802b9d:	68 e0 40 80 00       	push   $0x8040e0
  802ba2:	68 14 01 00 00       	push   $0x114
  802ba7:	68 37 40 80 00       	push   $0x804037
  802bac:	e8 c6 d6 ff ff       	call   800277 <_panic>
  802bb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb4:	8b 00                	mov    (%eax),%eax
  802bb6:	85 c0                	test   %eax,%eax
  802bb8:	74 10                	je     802bca <alloc_block_NF+0x451>
  802bba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbd:	8b 00                	mov    (%eax),%eax
  802bbf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bc2:	8b 52 04             	mov    0x4(%edx),%edx
  802bc5:	89 50 04             	mov    %edx,0x4(%eax)
  802bc8:	eb 0b                	jmp    802bd5 <alloc_block_NF+0x45c>
  802bca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcd:	8b 40 04             	mov    0x4(%eax),%eax
  802bd0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802bd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd8:	8b 40 04             	mov    0x4(%eax),%eax
  802bdb:	85 c0                	test   %eax,%eax
  802bdd:	74 0f                	je     802bee <alloc_block_NF+0x475>
  802bdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be2:	8b 40 04             	mov    0x4(%eax),%eax
  802be5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802be8:	8b 12                	mov    (%edx),%edx
  802bea:	89 10                	mov    %edx,(%eax)
  802bec:	eb 0a                	jmp    802bf8 <alloc_block_NF+0x47f>
  802bee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf1:	8b 00                	mov    (%eax),%eax
  802bf3:	a3 38 51 80 00       	mov    %eax,0x805138
  802bf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c04:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c0b:	a1 44 51 80 00       	mov    0x805144,%eax
  802c10:	48                   	dec    %eax
  802c11:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802c16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c19:	8b 40 08             	mov    0x8(%eax),%eax
  802c1c:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802c21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c24:	e9 1b 01 00 00       	jmp    802d44 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802c29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2c:	8b 40 0c             	mov    0xc(%eax),%eax
  802c2f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c32:	0f 86 d1 00 00 00    	jbe    802d09 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802c38:	a1 48 51 80 00       	mov    0x805148,%eax
  802c3d:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802c40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c43:	8b 50 08             	mov    0x8(%eax),%edx
  802c46:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c49:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802c4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c4f:	8b 55 08             	mov    0x8(%ebp),%edx
  802c52:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802c55:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c59:	75 17                	jne    802c72 <alloc_block_NF+0x4f9>
  802c5b:	83 ec 04             	sub    $0x4,%esp
  802c5e:	68 e0 40 80 00       	push   $0x8040e0
  802c63:	68 1c 01 00 00       	push   $0x11c
  802c68:	68 37 40 80 00       	push   $0x804037
  802c6d:	e8 05 d6 ff ff       	call   800277 <_panic>
  802c72:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c75:	8b 00                	mov    (%eax),%eax
  802c77:	85 c0                	test   %eax,%eax
  802c79:	74 10                	je     802c8b <alloc_block_NF+0x512>
  802c7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c7e:	8b 00                	mov    (%eax),%eax
  802c80:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c83:	8b 52 04             	mov    0x4(%edx),%edx
  802c86:	89 50 04             	mov    %edx,0x4(%eax)
  802c89:	eb 0b                	jmp    802c96 <alloc_block_NF+0x51d>
  802c8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c8e:	8b 40 04             	mov    0x4(%eax),%eax
  802c91:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c96:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c99:	8b 40 04             	mov    0x4(%eax),%eax
  802c9c:	85 c0                	test   %eax,%eax
  802c9e:	74 0f                	je     802caf <alloc_block_NF+0x536>
  802ca0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ca3:	8b 40 04             	mov    0x4(%eax),%eax
  802ca6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ca9:	8b 12                	mov    (%edx),%edx
  802cab:	89 10                	mov    %edx,(%eax)
  802cad:	eb 0a                	jmp    802cb9 <alloc_block_NF+0x540>
  802caf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cb2:	8b 00                	mov    (%eax),%eax
  802cb4:	a3 48 51 80 00       	mov    %eax,0x805148
  802cb9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cbc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cc2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cc5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ccc:	a1 54 51 80 00       	mov    0x805154,%eax
  802cd1:	48                   	dec    %eax
  802cd2:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802cd7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cda:	8b 40 08             	mov    0x8(%eax),%eax
  802cdd:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802ce2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce5:	8b 50 08             	mov    0x8(%eax),%edx
  802ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ceb:	01 c2                	add    %eax,%edx
  802ced:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf0:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802cf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf6:	8b 40 0c             	mov    0xc(%eax),%eax
  802cf9:	2b 45 08             	sub    0x8(%ebp),%eax
  802cfc:	89 c2                	mov    %eax,%edx
  802cfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d01:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802d04:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d07:	eb 3b                	jmp    802d44 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802d09:	a1 40 51 80 00       	mov    0x805140,%eax
  802d0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d11:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d15:	74 07                	je     802d1e <alloc_block_NF+0x5a5>
  802d17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1a:	8b 00                	mov    (%eax),%eax
  802d1c:	eb 05                	jmp    802d23 <alloc_block_NF+0x5aa>
  802d1e:	b8 00 00 00 00       	mov    $0x0,%eax
  802d23:	a3 40 51 80 00       	mov    %eax,0x805140
  802d28:	a1 40 51 80 00       	mov    0x805140,%eax
  802d2d:	85 c0                	test   %eax,%eax
  802d2f:	0f 85 2e fe ff ff    	jne    802b63 <alloc_block_NF+0x3ea>
  802d35:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d39:	0f 85 24 fe ff ff    	jne    802b63 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802d3f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d44:	c9                   	leave  
  802d45:	c3                   	ret    

00802d46 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802d46:	55                   	push   %ebp
  802d47:	89 e5                	mov    %esp,%ebp
  802d49:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802d4c:	a1 38 51 80 00       	mov    0x805138,%eax
  802d51:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802d54:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802d59:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802d5c:	a1 38 51 80 00       	mov    0x805138,%eax
  802d61:	85 c0                	test   %eax,%eax
  802d63:	74 14                	je     802d79 <insert_sorted_with_merge_freeList+0x33>
  802d65:	8b 45 08             	mov    0x8(%ebp),%eax
  802d68:	8b 50 08             	mov    0x8(%eax),%edx
  802d6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d6e:	8b 40 08             	mov    0x8(%eax),%eax
  802d71:	39 c2                	cmp    %eax,%edx
  802d73:	0f 87 9b 01 00 00    	ja     802f14 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802d79:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d7d:	75 17                	jne    802d96 <insert_sorted_with_merge_freeList+0x50>
  802d7f:	83 ec 04             	sub    $0x4,%esp
  802d82:	68 14 40 80 00       	push   $0x804014
  802d87:	68 38 01 00 00       	push   $0x138
  802d8c:	68 37 40 80 00       	push   $0x804037
  802d91:	e8 e1 d4 ff ff       	call   800277 <_panic>
  802d96:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9f:	89 10                	mov    %edx,(%eax)
  802da1:	8b 45 08             	mov    0x8(%ebp),%eax
  802da4:	8b 00                	mov    (%eax),%eax
  802da6:	85 c0                	test   %eax,%eax
  802da8:	74 0d                	je     802db7 <insert_sorted_with_merge_freeList+0x71>
  802daa:	a1 38 51 80 00       	mov    0x805138,%eax
  802daf:	8b 55 08             	mov    0x8(%ebp),%edx
  802db2:	89 50 04             	mov    %edx,0x4(%eax)
  802db5:	eb 08                	jmp    802dbf <insert_sorted_with_merge_freeList+0x79>
  802db7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dba:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc2:	a3 38 51 80 00       	mov    %eax,0x805138
  802dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dd1:	a1 44 51 80 00       	mov    0x805144,%eax
  802dd6:	40                   	inc    %eax
  802dd7:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802ddc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802de0:	0f 84 a8 06 00 00    	je     80348e <insert_sorted_with_merge_freeList+0x748>
  802de6:	8b 45 08             	mov    0x8(%ebp),%eax
  802de9:	8b 50 08             	mov    0x8(%eax),%edx
  802dec:	8b 45 08             	mov    0x8(%ebp),%eax
  802def:	8b 40 0c             	mov    0xc(%eax),%eax
  802df2:	01 c2                	add    %eax,%edx
  802df4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df7:	8b 40 08             	mov    0x8(%eax),%eax
  802dfa:	39 c2                	cmp    %eax,%edx
  802dfc:	0f 85 8c 06 00 00    	jne    80348e <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802e02:	8b 45 08             	mov    0x8(%ebp),%eax
  802e05:	8b 50 0c             	mov    0xc(%eax),%edx
  802e08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e0b:	8b 40 0c             	mov    0xc(%eax),%eax
  802e0e:	01 c2                	add    %eax,%edx
  802e10:	8b 45 08             	mov    0x8(%ebp),%eax
  802e13:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802e16:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e1a:	75 17                	jne    802e33 <insert_sorted_with_merge_freeList+0xed>
  802e1c:	83 ec 04             	sub    $0x4,%esp
  802e1f:	68 e0 40 80 00       	push   $0x8040e0
  802e24:	68 3c 01 00 00       	push   $0x13c
  802e29:	68 37 40 80 00       	push   $0x804037
  802e2e:	e8 44 d4 ff ff       	call   800277 <_panic>
  802e33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e36:	8b 00                	mov    (%eax),%eax
  802e38:	85 c0                	test   %eax,%eax
  802e3a:	74 10                	je     802e4c <insert_sorted_with_merge_freeList+0x106>
  802e3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e3f:	8b 00                	mov    (%eax),%eax
  802e41:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e44:	8b 52 04             	mov    0x4(%edx),%edx
  802e47:	89 50 04             	mov    %edx,0x4(%eax)
  802e4a:	eb 0b                	jmp    802e57 <insert_sorted_with_merge_freeList+0x111>
  802e4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e4f:	8b 40 04             	mov    0x4(%eax),%eax
  802e52:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e5a:	8b 40 04             	mov    0x4(%eax),%eax
  802e5d:	85 c0                	test   %eax,%eax
  802e5f:	74 0f                	je     802e70 <insert_sorted_with_merge_freeList+0x12a>
  802e61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e64:	8b 40 04             	mov    0x4(%eax),%eax
  802e67:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e6a:	8b 12                	mov    (%edx),%edx
  802e6c:	89 10                	mov    %edx,(%eax)
  802e6e:	eb 0a                	jmp    802e7a <insert_sorted_with_merge_freeList+0x134>
  802e70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e73:	8b 00                	mov    (%eax),%eax
  802e75:	a3 38 51 80 00       	mov    %eax,0x805138
  802e7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e7d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e86:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e8d:	a1 44 51 80 00       	mov    0x805144,%eax
  802e92:	48                   	dec    %eax
  802e93:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802e98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e9b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802ea2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ea5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802eac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802eb0:	75 17                	jne    802ec9 <insert_sorted_with_merge_freeList+0x183>
  802eb2:	83 ec 04             	sub    $0x4,%esp
  802eb5:	68 14 40 80 00       	push   $0x804014
  802eba:	68 3f 01 00 00       	push   $0x13f
  802ebf:	68 37 40 80 00       	push   $0x804037
  802ec4:	e8 ae d3 ff ff       	call   800277 <_panic>
  802ec9:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802ecf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ed2:	89 10                	mov    %edx,(%eax)
  802ed4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ed7:	8b 00                	mov    (%eax),%eax
  802ed9:	85 c0                	test   %eax,%eax
  802edb:	74 0d                	je     802eea <insert_sorted_with_merge_freeList+0x1a4>
  802edd:	a1 48 51 80 00       	mov    0x805148,%eax
  802ee2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ee5:	89 50 04             	mov    %edx,0x4(%eax)
  802ee8:	eb 08                	jmp    802ef2 <insert_sorted_with_merge_freeList+0x1ac>
  802eea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eed:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ef2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ef5:	a3 48 51 80 00       	mov    %eax,0x805148
  802efa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802efd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f04:	a1 54 51 80 00       	mov    0x805154,%eax
  802f09:	40                   	inc    %eax
  802f0a:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802f0f:	e9 7a 05 00 00       	jmp    80348e <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802f14:	8b 45 08             	mov    0x8(%ebp),%eax
  802f17:	8b 50 08             	mov    0x8(%eax),%edx
  802f1a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f1d:	8b 40 08             	mov    0x8(%eax),%eax
  802f20:	39 c2                	cmp    %eax,%edx
  802f22:	0f 82 14 01 00 00    	jb     80303c <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802f28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f2b:	8b 50 08             	mov    0x8(%eax),%edx
  802f2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f31:	8b 40 0c             	mov    0xc(%eax),%eax
  802f34:	01 c2                	add    %eax,%edx
  802f36:	8b 45 08             	mov    0x8(%ebp),%eax
  802f39:	8b 40 08             	mov    0x8(%eax),%eax
  802f3c:	39 c2                	cmp    %eax,%edx
  802f3e:	0f 85 90 00 00 00    	jne    802fd4 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802f44:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f47:	8b 50 0c             	mov    0xc(%eax),%edx
  802f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4d:	8b 40 0c             	mov    0xc(%eax),%eax
  802f50:	01 c2                	add    %eax,%edx
  802f52:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f55:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802f58:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802f62:	8b 45 08             	mov    0x8(%ebp),%eax
  802f65:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802f6c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f70:	75 17                	jne    802f89 <insert_sorted_with_merge_freeList+0x243>
  802f72:	83 ec 04             	sub    $0x4,%esp
  802f75:	68 14 40 80 00       	push   $0x804014
  802f7a:	68 49 01 00 00       	push   $0x149
  802f7f:	68 37 40 80 00       	push   $0x804037
  802f84:	e8 ee d2 ff ff       	call   800277 <_panic>
  802f89:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f92:	89 10                	mov    %edx,(%eax)
  802f94:	8b 45 08             	mov    0x8(%ebp),%eax
  802f97:	8b 00                	mov    (%eax),%eax
  802f99:	85 c0                	test   %eax,%eax
  802f9b:	74 0d                	je     802faa <insert_sorted_with_merge_freeList+0x264>
  802f9d:	a1 48 51 80 00       	mov    0x805148,%eax
  802fa2:	8b 55 08             	mov    0x8(%ebp),%edx
  802fa5:	89 50 04             	mov    %edx,0x4(%eax)
  802fa8:	eb 08                	jmp    802fb2 <insert_sorted_with_merge_freeList+0x26c>
  802faa:	8b 45 08             	mov    0x8(%ebp),%eax
  802fad:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fb2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb5:	a3 48 51 80 00       	mov    %eax,0x805148
  802fba:	8b 45 08             	mov    0x8(%ebp),%eax
  802fbd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fc4:	a1 54 51 80 00       	mov    0x805154,%eax
  802fc9:	40                   	inc    %eax
  802fca:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802fcf:	e9 bb 04 00 00       	jmp    80348f <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802fd4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fd8:	75 17                	jne    802ff1 <insert_sorted_with_merge_freeList+0x2ab>
  802fda:	83 ec 04             	sub    $0x4,%esp
  802fdd:	68 88 40 80 00       	push   $0x804088
  802fe2:	68 4c 01 00 00       	push   $0x14c
  802fe7:	68 37 40 80 00       	push   $0x804037
  802fec:	e8 86 d2 ff ff       	call   800277 <_panic>
  802ff1:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802ff7:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffa:	89 50 04             	mov    %edx,0x4(%eax)
  802ffd:	8b 45 08             	mov    0x8(%ebp),%eax
  803000:	8b 40 04             	mov    0x4(%eax),%eax
  803003:	85 c0                	test   %eax,%eax
  803005:	74 0c                	je     803013 <insert_sorted_with_merge_freeList+0x2cd>
  803007:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80300c:	8b 55 08             	mov    0x8(%ebp),%edx
  80300f:	89 10                	mov    %edx,(%eax)
  803011:	eb 08                	jmp    80301b <insert_sorted_with_merge_freeList+0x2d5>
  803013:	8b 45 08             	mov    0x8(%ebp),%eax
  803016:	a3 38 51 80 00       	mov    %eax,0x805138
  80301b:	8b 45 08             	mov    0x8(%ebp),%eax
  80301e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803023:	8b 45 08             	mov    0x8(%ebp),%eax
  803026:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80302c:	a1 44 51 80 00       	mov    0x805144,%eax
  803031:	40                   	inc    %eax
  803032:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803037:	e9 53 04 00 00       	jmp    80348f <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80303c:	a1 38 51 80 00       	mov    0x805138,%eax
  803041:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803044:	e9 15 04 00 00       	jmp    80345e <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803049:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304c:	8b 00                	mov    (%eax),%eax
  80304e:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803051:	8b 45 08             	mov    0x8(%ebp),%eax
  803054:	8b 50 08             	mov    0x8(%eax),%edx
  803057:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305a:	8b 40 08             	mov    0x8(%eax),%eax
  80305d:	39 c2                	cmp    %eax,%edx
  80305f:	0f 86 f1 03 00 00    	jbe    803456 <insert_sorted_with_merge_freeList+0x710>
  803065:	8b 45 08             	mov    0x8(%ebp),%eax
  803068:	8b 50 08             	mov    0x8(%eax),%edx
  80306b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80306e:	8b 40 08             	mov    0x8(%eax),%eax
  803071:	39 c2                	cmp    %eax,%edx
  803073:	0f 83 dd 03 00 00    	jae    803456 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803079:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80307c:	8b 50 08             	mov    0x8(%eax),%edx
  80307f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803082:	8b 40 0c             	mov    0xc(%eax),%eax
  803085:	01 c2                	add    %eax,%edx
  803087:	8b 45 08             	mov    0x8(%ebp),%eax
  80308a:	8b 40 08             	mov    0x8(%eax),%eax
  80308d:	39 c2                	cmp    %eax,%edx
  80308f:	0f 85 b9 01 00 00    	jne    80324e <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803095:	8b 45 08             	mov    0x8(%ebp),%eax
  803098:	8b 50 08             	mov    0x8(%eax),%edx
  80309b:	8b 45 08             	mov    0x8(%ebp),%eax
  80309e:	8b 40 0c             	mov    0xc(%eax),%eax
  8030a1:	01 c2                	add    %eax,%edx
  8030a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030a6:	8b 40 08             	mov    0x8(%eax),%eax
  8030a9:	39 c2                	cmp    %eax,%edx
  8030ab:	0f 85 0d 01 00 00    	jne    8031be <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8030b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b4:	8b 50 0c             	mov    0xc(%eax),%edx
  8030b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8030bd:	01 c2                	add    %eax,%edx
  8030bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c2:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8030c5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030c9:	75 17                	jne    8030e2 <insert_sorted_with_merge_freeList+0x39c>
  8030cb:	83 ec 04             	sub    $0x4,%esp
  8030ce:	68 e0 40 80 00       	push   $0x8040e0
  8030d3:	68 5c 01 00 00       	push   $0x15c
  8030d8:	68 37 40 80 00       	push   $0x804037
  8030dd:	e8 95 d1 ff ff       	call   800277 <_panic>
  8030e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030e5:	8b 00                	mov    (%eax),%eax
  8030e7:	85 c0                	test   %eax,%eax
  8030e9:	74 10                	je     8030fb <insert_sorted_with_merge_freeList+0x3b5>
  8030eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ee:	8b 00                	mov    (%eax),%eax
  8030f0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030f3:	8b 52 04             	mov    0x4(%edx),%edx
  8030f6:	89 50 04             	mov    %edx,0x4(%eax)
  8030f9:	eb 0b                	jmp    803106 <insert_sorted_with_merge_freeList+0x3c0>
  8030fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030fe:	8b 40 04             	mov    0x4(%eax),%eax
  803101:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803106:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803109:	8b 40 04             	mov    0x4(%eax),%eax
  80310c:	85 c0                	test   %eax,%eax
  80310e:	74 0f                	je     80311f <insert_sorted_with_merge_freeList+0x3d9>
  803110:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803113:	8b 40 04             	mov    0x4(%eax),%eax
  803116:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803119:	8b 12                	mov    (%edx),%edx
  80311b:	89 10                	mov    %edx,(%eax)
  80311d:	eb 0a                	jmp    803129 <insert_sorted_with_merge_freeList+0x3e3>
  80311f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803122:	8b 00                	mov    (%eax),%eax
  803124:	a3 38 51 80 00       	mov    %eax,0x805138
  803129:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80312c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803132:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803135:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80313c:	a1 44 51 80 00       	mov    0x805144,%eax
  803141:	48                   	dec    %eax
  803142:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803147:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80314a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803151:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803154:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80315b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80315f:	75 17                	jne    803178 <insert_sorted_with_merge_freeList+0x432>
  803161:	83 ec 04             	sub    $0x4,%esp
  803164:	68 14 40 80 00       	push   $0x804014
  803169:	68 5f 01 00 00       	push   $0x15f
  80316e:	68 37 40 80 00       	push   $0x804037
  803173:	e8 ff d0 ff ff       	call   800277 <_panic>
  803178:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80317e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803181:	89 10                	mov    %edx,(%eax)
  803183:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803186:	8b 00                	mov    (%eax),%eax
  803188:	85 c0                	test   %eax,%eax
  80318a:	74 0d                	je     803199 <insert_sorted_with_merge_freeList+0x453>
  80318c:	a1 48 51 80 00       	mov    0x805148,%eax
  803191:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803194:	89 50 04             	mov    %edx,0x4(%eax)
  803197:	eb 08                	jmp    8031a1 <insert_sorted_with_merge_freeList+0x45b>
  803199:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80319c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031a4:	a3 48 51 80 00       	mov    %eax,0x805148
  8031a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031b3:	a1 54 51 80 00       	mov    0x805154,%eax
  8031b8:	40                   	inc    %eax
  8031b9:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8031be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c1:	8b 50 0c             	mov    0xc(%eax),%edx
  8031c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c7:	8b 40 0c             	mov    0xc(%eax),%eax
  8031ca:	01 c2                	add    %eax,%edx
  8031cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031cf:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8031d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8031dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8031df:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8031e6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031ea:	75 17                	jne    803203 <insert_sorted_with_merge_freeList+0x4bd>
  8031ec:	83 ec 04             	sub    $0x4,%esp
  8031ef:	68 14 40 80 00       	push   $0x804014
  8031f4:	68 64 01 00 00       	push   $0x164
  8031f9:	68 37 40 80 00       	push   $0x804037
  8031fe:	e8 74 d0 ff ff       	call   800277 <_panic>
  803203:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803209:	8b 45 08             	mov    0x8(%ebp),%eax
  80320c:	89 10                	mov    %edx,(%eax)
  80320e:	8b 45 08             	mov    0x8(%ebp),%eax
  803211:	8b 00                	mov    (%eax),%eax
  803213:	85 c0                	test   %eax,%eax
  803215:	74 0d                	je     803224 <insert_sorted_with_merge_freeList+0x4de>
  803217:	a1 48 51 80 00       	mov    0x805148,%eax
  80321c:	8b 55 08             	mov    0x8(%ebp),%edx
  80321f:	89 50 04             	mov    %edx,0x4(%eax)
  803222:	eb 08                	jmp    80322c <insert_sorted_with_merge_freeList+0x4e6>
  803224:	8b 45 08             	mov    0x8(%ebp),%eax
  803227:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80322c:	8b 45 08             	mov    0x8(%ebp),%eax
  80322f:	a3 48 51 80 00       	mov    %eax,0x805148
  803234:	8b 45 08             	mov    0x8(%ebp),%eax
  803237:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80323e:	a1 54 51 80 00       	mov    0x805154,%eax
  803243:	40                   	inc    %eax
  803244:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803249:	e9 41 02 00 00       	jmp    80348f <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80324e:	8b 45 08             	mov    0x8(%ebp),%eax
  803251:	8b 50 08             	mov    0x8(%eax),%edx
  803254:	8b 45 08             	mov    0x8(%ebp),%eax
  803257:	8b 40 0c             	mov    0xc(%eax),%eax
  80325a:	01 c2                	add    %eax,%edx
  80325c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80325f:	8b 40 08             	mov    0x8(%eax),%eax
  803262:	39 c2                	cmp    %eax,%edx
  803264:	0f 85 7c 01 00 00    	jne    8033e6 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  80326a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80326e:	74 06                	je     803276 <insert_sorted_with_merge_freeList+0x530>
  803270:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803274:	75 17                	jne    80328d <insert_sorted_with_merge_freeList+0x547>
  803276:	83 ec 04             	sub    $0x4,%esp
  803279:	68 50 40 80 00       	push   $0x804050
  80327e:	68 69 01 00 00       	push   $0x169
  803283:	68 37 40 80 00       	push   $0x804037
  803288:	e8 ea cf ff ff       	call   800277 <_panic>
  80328d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803290:	8b 50 04             	mov    0x4(%eax),%edx
  803293:	8b 45 08             	mov    0x8(%ebp),%eax
  803296:	89 50 04             	mov    %edx,0x4(%eax)
  803299:	8b 45 08             	mov    0x8(%ebp),%eax
  80329c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80329f:	89 10                	mov    %edx,(%eax)
  8032a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032a4:	8b 40 04             	mov    0x4(%eax),%eax
  8032a7:	85 c0                	test   %eax,%eax
  8032a9:	74 0d                	je     8032b8 <insert_sorted_with_merge_freeList+0x572>
  8032ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ae:	8b 40 04             	mov    0x4(%eax),%eax
  8032b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8032b4:	89 10                	mov    %edx,(%eax)
  8032b6:	eb 08                	jmp    8032c0 <insert_sorted_with_merge_freeList+0x57a>
  8032b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032bb:	a3 38 51 80 00       	mov    %eax,0x805138
  8032c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8032c6:	89 50 04             	mov    %edx,0x4(%eax)
  8032c9:	a1 44 51 80 00       	mov    0x805144,%eax
  8032ce:	40                   	inc    %eax
  8032cf:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8032d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d7:	8b 50 0c             	mov    0xc(%eax),%edx
  8032da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032dd:	8b 40 0c             	mov    0xc(%eax),%eax
  8032e0:	01 c2                	add    %eax,%edx
  8032e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e5:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8032e8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032ec:	75 17                	jne    803305 <insert_sorted_with_merge_freeList+0x5bf>
  8032ee:	83 ec 04             	sub    $0x4,%esp
  8032f1:	68 e0 40 80 00       	push   $0x8040e0
  8032f6:	68 6b 01 00 00       	push   $0x16b
  8032fb:	68 37 40 80 00       	push   $0x804037
  803300:	e8 72 cf ff ff       	call   800277 <_panic>
  803305:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803308:	8b 00                	mov    (%eax),%eax
  80330a:	85 c0                	test   %eax,%eax
  80330c:	74 10                	je     80331e <insert_sorted_with_merge_freeList+0x5d8>
  80330e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803311:	8b 00                	mov    (%eax),%eax
  803313:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803316:	8b 52 04             	mov    0x4(%edx),%edx
  803319:	89 50 04             	mov    %edx,0x4(%eax)
  80331c:	eb 0b                	jmp    803329 <insert_sorted_with_merge_freeList+0x5e3>
  80331e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803321:	8b 40 04             	mov    0x4(%eax),%eax
  803324:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803329:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80332c:	8b 40 04             	mov    0x4(%eax),%eax
  80332f:	85 c0                	test   %eax,%eax
  803331:	74 0f                	je     803342 <insert_sorted_with_merge_freeList+0x5fc>
  803333:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803336:	8b 40 04             	mov    0x4(%eax),%eax
  803339:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80333c:	8b 12                	mov    (%edx),%edx
  80333e:	89 10                	mov    %edx,(%eax)
  803340:	eb 0a                	jmp    80334c <insert_sorted_with_merge_freeList+0x606>
  803342:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803345:	8b 00                	mov    (%eax),%eax
  803347:	a3 38 51 80 00       	mov    %eax,0x805138
  80334c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80334f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803355:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803358:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80335f:	a1 44 51 80 00       	mov    0x805144,%eax
  803364:	48                   	dec    %eax
  803365:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  80336a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80336d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803374:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803377:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80337e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803382:	75 17                	jne    80339b <insert_sorted_with_merge_freeList+0x655>
  803384:	83 ec 04             	sub    $0x4,%esp
  803387:	68 14 40 80 00       	push   $0x804014
  80338c:	68 6e 01 00 00       	push   $0x16e
  803391:	68 37 40 80 00       	push   $0x804037
  803396:	e8 dc ce ff ff       	call   800277 <_panic>
  80339b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033a4:	89 10                	mov    %edx,(%eax)
  8033a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033a9:	8b 00                	mov    (%eax),%eax
  8033ab:	85 c0                	test   %eax,%eax
  8033ad:	74 0d                	je     8033bc <insert_sorted_with_merge_freeList+0x676>
  8033af:	a1 48 51 80 00       	mov    0x805148,%eax
  8033b4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033b7:	89 50 04             	mov    %edx,0x4(%eax)
  8033ba:	eb 08                	jmp    8033c4 <insert_sorted_with_merge_freeList+0x67e>
  8033bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033bf:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033c7:	a3 48 51 80 00       	mov    %eax,0x805148
  8033cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033cf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033d6:	a1 54 51 80 00       	mov    0x805154,%eax
  8033db:	40                   	inc    %eax
  8033dc:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8033e1:	e9 a9 00 00 00       	jmp    80348f <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8033e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033ea:	74 06                	je     8033f2 <insert_sorted_with_merge_freeList+0x6ac>
  8033ec:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033f0:	75 17                	jne    803409 <insert_sorted_with_merge_freeList+0x6c3>
  8033f2:	83 ec 04             	sub    $0x4,%esp
  8033f5:	68 ac 40 80 00       	push   $0x8040ac
  8033fa:	68 73 01 00 00       	push   $0x173
  8033ff:	68 37 40 80 00       	push   $0x804037
  803404:	e8 6e ce ff ff       	call   800277 <_panic>
  803409:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80340c:	8b 10                	mov    (%eax),%edx
  80340e:	8b 45 08             	mov    0x8(%ebp),%eax
  803411:	89 10                	mov    %edx,(%eax)
  803413:	8b 45 08             	mov    0x8(%ebp),%eax
  803416:	8b 00                	mov    (%eax),%eax
  803418:	85 c0                	test   %eax,%eax
  80341a:	74 0b                	je     803427 <insert_sorted_with_merge_freeList+0x6e1>
  80341c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80341f:	8b 00                	mov    (%eax),%eax
  803421:	8b 55 08             	mov    0x8(%ebp),%edx
  803424:	89 50 04             	mov    %edx,0x4(%eax)
  803427:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80342a:	8b 55 08             	mov    0x8(%ebp),%edx
  80342d:	89 10                	mov    %edx,(%eax)
  80342f:	8b 45 08             	mov    0x8(%ebp),%eax
  803432:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803435:	89 50 04             	mov    %edx,0x4(%eax)
  803438:	8b 45 08             	mov    0x8(%ebp),%eax
  80343b:	8b 00                	mov    (%eax),%eax
  80343d:	85 c0                	test   %eax,%eax
  80343f:	75 08                	jne    803449 <insert_sorted_with_merge_freeList+0x703>
  803441:	8b 45 08             	mov    0x8(%ebp),%eax
  803444:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803449:	a1 44 51 80 00       	mov    0x805144,%eax
  80344e:	40                   	inc    %eax
  80344f:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803454:	eb 39                	jmp    80348f <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803456:	a1 40 51 80 00       	mov    0x805140,%eax
  80345b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80345e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803462:	74 07                	je     80346b <insert_sorted_with_merge_freeList+0x725>
  803464:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803467:	8b 00                	mov    (%eax),%eax
  803469:	eb 05                	jmp    803470 <insert_sorted_with_merge_freeList+0x72a>
  80346b:	b8 00 00 00 00       	mov    $0x0,%eax
  803470:	a3 40 51 80 00       	mov    %eax,0x805140
  803475:	a1 40 51 80 00       	mov    0x805140,%eax
  80347a:	85 c0                	test   %eax,%eax
  80347c:	0f 85 c7 fb ff ff    	jne    803049 <insert_sorted_with_merge_freeList+0x303>
  803482:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803486:	0f 85 bd fb ff ff    	jne    803049 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80348c:	eb 01                	jmp    80348f <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80348e:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80348f:	90                   	nop
  803490:	c9                   	leave  
  803491:	c3                   	ret    

00803492 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803492:	55                   	push   %ebp
  803493:	89 e5                	mov    %esp,%ebp
  803495:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803498:	8b 55 08             	mov    0x8(%ebp),%edx
  80349b:	89 d0                	mov    %edx,%eax
  80349d:	c1 e0 02             	shl    $0x2,%eax
  8034a0:	01 d0                	add    %edx,%eax
  8034a2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8034a9:	01 d0                	add    %edx,%eax
  8034ab:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8034b2:	01 d0                	add    %edx,%eax
  8034b4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8034bb:	01 d0                	add    %edx,%eax
  8034bd:	c1 e0 04             	shl    $0x4,%eax
  8034c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8034c3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8034ca:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8034cd:	83 ec 0c             	sub    $0xc,%esp
  8034d0:	50                   	push   %eax
  8034d1:	e8 26 e7 ff ff       	call   801bfc <sys_get_virtual_time>
  8034d6:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8034d9:	eb 41                	jmp    80351c <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8034db:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8034de:	83 ec 0c             	sub    $0xc,%esp
  8034e1:	50                   	push   %eax
  8034e2:	e8 15 e7 ff ff       	call   801bfc <sys_get_virtual_time>
  8034e7:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8034ea:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8034ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034f0:	29 c2                	sub    %eax,%edx
  8034f2:	89 d0                	mov    %edx,%eax
  8034f4:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8034f7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034fd:	89 d1                	mov    %edx,%ecx
  8034ff:	29 c1                	sub    %eax,%ecx
  803501:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803504:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803507:	39 c2                	cmp    %eax,%edx
  803509:	0f 97 c0             	seta   %al
  80350c:	0f b6 c0             	movzbl %al,%eax
  80350f:	29 c1                	sub    %eax,%ecx
  803511:	89 c8                	mov    %ecx,%eax
  803513:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803516:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803519:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  80351c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80351f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803522:	72 b7                	jb     8034db <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803524:	90                   	nop
  803525:	c9                   	leave  
  803526:	c3                   	ret    

00803527 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803527:	55                   	push   %ebp
  803528:	89 e5                	mov    %esp,%ebp
  80352a:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  80352d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803534:	eb 03                	jmp    803539 <busy_wait+0x12>
  803536:	ff 45 fc             	incl   -0x4(%ebp)
  803539:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80353c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80353f:	72 f5                	jb     803536 <busy_wait+0xf>
	return i;
  803541:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803544:	c9                   	leave  
  803545:	c3                   	ret    
  803546:	66 90                	xchg   %ax,%ax

00803548 <__udivdi3>:
  803548:	55                   	push   %ebp
  803549:	57                   	push   %edi
  80354a:	56                   	push   %esi
  80354b:	53                   	push   %ebx
  80354c:	83 ec 1c             	sub    $0x1c,%esp
  80354f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803553:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803557:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80355b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80355f:	89 ca                	mov    %ecx,%edx
  803561:	89 f8                	mov    %edi,%eax
  803563:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803567:	85 f6                	test   %esi,%esi
  803569:	75 2d                	jne    803598 <__udivdi3+0x50>
  80356b:	39 cf                	cmp    %ecx,%edi
  80356d:	77 65                	ja     8035d4 <__udivdi3+0x8c>
  80356f:	89 fd                	mov    %edi,%ebp
  803571:	85 ff                	test   %edi,%edi
  803573:	75 0b                	jne    803580 <__udivdi3+0x38>
  803575:	b8 01 00 00 00       	mov    $0x1,%eax
  80357a:	31 d2                	xor    %edx,%edx
  80357c:	f7 f7                	div    %edi
  80357e:	89 c5                	mov    %eax,%ebp
  803580:	31 d2                	xor    %edx,%edx
  803582:	89 c8                	mov    %ecx,%eax
  803584:	f7 f5                	div    %ebp
  803586:	89 c1                	mov    %eax,%ecx
  803588:	89 d8                	mov    %ebx,%eax
  80358a:	f7 f5                	div    %ebp
  80358c:	89 cf                	mov    %ecx,%edi
  80358e:	89 fa                	mov    %edi,%edx
  803590:	83 c4 1c             	add    $0x1c,%esp
  803593:	5b                   	pop    %ebx
  803594:	5e                   	pop    %esi
  803595:	5f                   	pop    %edi
  803596:	5d                   	pop    %ebp
  803597:	c3                   	ret    
  803598:	39 ce                	cmp    %ecx,%esi
  80359a:	77 28                	ja     8035c4 <__udivdi3+0x7c>
  80359c:	0f bd fe             	bsr    %esi,%edi
  80359f:	83 f7 1f             	xor    $0x1f,%edi
  8035a2:	75 40                	jne    8035e4 <__udivdi3+0x9c>
  8035a4:	39 ce                	cmp    %ecx,%esi
  8035a6:	72 0a                	jb     8035b2 <__udivdi3+0x6a>
  8035a8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8035ac:	0f 87 9e 00 00 00    	ja     803650 <__udivdi3+0x108>
  8035b2:	b8 01 00 00 00       	mov    $0x1,%eax
  8035b7:	89 fa                	mov    %edi,%edx
  8035b9:	83 c4 1c             	add    $0x1c,%esp
  8035bc:	5b                   	pop    %ebx
  8035bd:	5e                   	pop    %esi
  8035be:	5f                   	pop    %edi
  8035bf:	5d                   	pop    %ebp
  8035c0:	c3                   	ret    
  8035c1:	8d 76 00             	lea    0x0(%esi),%esi
  8035c4:	31 ff                	xor    %edi,%edi
  8035c6:	31 c0                	xor    %eax,%eax
  8035c8:	89 fa                	mov    %edi,%edx
  8035ca:	83 c4 1c             	add    $0x1c,%esp
  8035cd:	5b                   	pop    %ebx
  8035ce:	5e                   	pop    %esi
  8035cf:	5f                   	pop    %edi
  8035d0:	5d                   	pop    %ebp
  8035d1:	c3                   	ret    
  8035d2:	66 90                	xchg   %ax,%ax
  8035d4:	89 d8                	mov    %ebx,%eax
  8035d6:	f7 f7                	div    %edi
  8035d8:	31 ff                	xor    %edi,%edi
  8035da:	89 fa                	mov    %edi,%edx
  8035dc:	83 c4 1c             	add    $0x1c,%esp
  8035df:	5b                   	pop    %ebx
  8035e0:	5e                   	pop    %esi
  8035e1:	5f                   	pop    %edi
  8035e2:	5d                   	pop    %ebp
  8035e3:	c3                   	ret    
  8035e4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8035e9:	89 eb                	mov    %ebp,%ebx
  8035eb:	29 fb                	sub    %edi,%ebx
  8035ed:	89 f9                	mov    %edi,%ecx
  8035ef:	d3 e6                	shl    %cl,%esi
  8035f1:	89 c5                	mov    %eax,%ebp
  8035f3:	88 d9                	mov    %bl,%cl
  8035f5:	d3 ed                	shr    %cl,%ebp
  8035f7:	89 e9                	mov    %ebp,%ecx
  8035f9:	09 f1                	or     %esi,%ecx
  8035fb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8035ff:	89 f9                	mov    %edi,%ecx
  803601:	d3 e0                	shl    %cl,%eax
  803603:	89 c5                	mov    %eax,%ebp
  803605:	89 d6                	mov    %edx,%esi
  803607:	88 d9                	mov    %bl,%cl
  803609:	d3 ee                	shr    %cl,%esi
  80360b:	89 f9                	mov    %edi,%ecx
  80360d:	d3 e2                	shl    %cl,%edx
  80360f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803613:	88 d9                	mov    %bl,%cl
  803615:	d3 e8                	shr    %cl,%eax
  803617:	09 c2                	or     %eax,%edx
  803619:	89 d0                	mov    %edx,%eax
  80361b:	89 f2                	mov    %esi,%edx
  80361d:	f7 74 24 0c          	divl   0xc(%esp)
  803621:	89 d6                	mov    %edx,%esi
  803623:	89 c3                	mov    %eax,%ebx
  803625:	f7 e5                	mul    %ebp
  803627:	39 d6                	cmp    %edx,%esi
  803629:	72 19                	jb     803644 <__udivdi3+0xfc>
  80362b:	74 0b                	je     803638 <__udivdi3+0xf0>
  80362d:	89 d8                	mov    %ebx,%eax
  80362f:	31 ff                	xor    %edi,%edi
  803631:	e9 58 ff ff ff       	jmp    80358e <__udivdi3+0x46>
  803636:	66 90                	xchg   %ax,%ax
  803638:	8b 54 24 08          	mov    0x8(%esp),%edx
  80363c:	89 f9                	mov    %edi,%ecx
  80363e:	d3 e2                	shl    %cl,%edx
  803640:	39 c2                	cmp    %eax,%edx
  803642:	73 e9                	jae    80362d <__udivdi3+0xe5>
  803644:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803647:	31 ff                	xor    %edi,%edi
  803649:	e9 40 ff ff ff       	jmp    80358e <__udivdi3+0x46>
  80364e:	66 90                	xchg   %ax,%ax
  803650:	31 c0                	xor    %eax,%eax
  803652:	e9 37 ff ff ff       	jmp    80358e <__udivdi3+0x46>
  803657:	90                   	nop

00803658 <__umoddi3>:
  803658:	55                   	push   %ebp
  803659:	57                   	push   %edi
  80365a:	56                   	push   %esi
  80365b:	53                   	push   %ebx
  80365c:	83 ec 1c             	sub    $0x1c,%esp
  80365f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803663:	8b 74 24 34          	mov    0x34(%esp),%esi
  803667:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80366b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80366f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803673:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803677:	89 f3                	mov    %esi,%ebx
  803679:	89 fa                	mov    %edi,%edx
  80367b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80367f:	89 34 24             	mov    %esi,(%esp)
  803682:	85 c0                	test   %eax,%eax
  803684:	75 1a                	jne    8036a0 <__umoddi3+0x48>
  803686:	39 f7                	cmp    %esi,%edi
  803688:	0f 86 a2 00 00 00    	jbe    803730 <__umoddi3+0xd8>
  80368e:	89 c8                	mov    %ecx,%eax
  803690:	89 f2                	mov    %esi,%edx
  803692:	f7 f7                	div    %edi
  803694:	89 d0                	mov    %edx,%eax
  803696:	31 d2                	xor    %edx,%edx
  803698:	83 c4 1c             	add    $0x1c,%esp
  80369b:	5b                   	pop    %ebx
  80369c:	5e                   	pop    %esi
  80369d:	5f                   	pop    %edi
  80369e:	5d                   	pop    %ebp
  80369f:	c3                   	ret    
  8036a0:	39 f0                	cmp    %esi,%eax
  8036a2:	0f 87 ac 00 00 00    	ja     803754 <__umoddi3+0xfc>
  8036a8:	0f bd e8             	bsr    %eax,%ebp
  8036ab:	83 f5 1f             	xor    $0x1f,%ebp
  8036ae:	0f 84 ac 00 00 00    	je     803760 <__umoddi3+0x108>
  8036b4:	bf 20 00 00 00       	mov    $0x20,%edi
  8036b9:	29 ef                	sub    %ebp,%edi
  8036bb:	89 fe                	mov    %edi,%esi
  8036bd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8036c1:	89 e9                	mov    %ebp,%ecx
  8036c3:	d3 e0                	shl    %cl,%eax
  8036c5:	89 d7                	mov    %edx,%edi
  8036c7:	89 f1                	mov    %esi,%ecx
  8036c9:	d3 ef                	shr    %cl,%edi
  8036cb:	09 c7                	or     %eax,%edi
  8036cd:	89 e9                	mov    %ebp,%ecx
  8036cf:	d3 e2                	shl    %cl,%edx
  8036d1:	89 14 24             	mov    %edx,(%esp)
  8036d4:	89 d8                	mov    %ebx,%eax
  8036d6:	d3 e0                	shl    %cl,%eax
  8036d8:	89 c2                	mov    %eax,%edx
  8036da:	8b 44 24 08          	mov    0x8(%esp),%eax
  8036de:	d3 e0                	shl    %cl,%eax
  8036e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8036e4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8036e8:	89 f1                	mov    %esi,%ecx
  8036ea:	d3 e8                	shr    %cl,%eax
  8036ec:	09 d0                	or     %edx,%eax
  8036ee:	d3 eb                	shr    %cl,%ebx
  8036f0:	89 da                	mov    %ebx,%edx
  8036f2:	f7 f7                	div    %edi
  8036f4:	89 d3                	mov    %edx,%ebx
  8036f6:	f7 24 24             	mull   (%esp)
  8036f9:	89 c6                	mov    %eax,%esi
  8036fb:	89 d1                	mov    %edx,%ecx
  8036fd:	39 d3                	cmp    %edx,%ebx
  8036ff:	0f 82 87 00 00 00    	jb     80378c <__umoddi3+0x134>
  803705:	0f 84 91 00 00 00    	je     80379c <__umoddi3+0x144>
  80370b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80370f:	29 f2                	sub    %esi,%edx
  803711:	19 cb                	sbb    %ecx,%ebx
  803713:	89 d8                	mov    %ebx,%eax
  803715:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803719:	d3 e0                	shl    %cl,%eax
  80371b:	89 e9                	mov    %ebp,%ecx
  80371d:	d3 ea                	shr    %cl,%edx
  80371f:	09 d0                	or     %edx,%eax
  803721:	89 e9                	mov    %ebp,%ecx
  803723:	d3 eb                	shr    %cl,%ebx
  803725:	89 da                	mov    %ebx,%edx
  803727:	83 c4 1c             	add    $0x1c,%esp
  80372a:	5b                   	pop    %ebx
  80372b:	5e                   	pop    %esi
  80372c:	5f                   	pop    %edi
  80372d:	5d                   	pop    %ebp
  80372e:	c3                   	ret    
  80372f:	90                   	nop
  803730:	89 fd                	mov    %edi,%ebp
  803732:	85 ff                	test   %edi,%edi
  803734:	75 0b                	jne    803741 <__umoddi3+0xe9>
  803736:	b8 01 00 00 00       	mov    $0x1,%eax
  80373b:	31 d2                	xor    %edx,%edx
  80373d:	f7 f7                	div    %edi
  80373f:	89 c5                	mov    %eax,%ebp
  803741:	89 f0                	mov    %esi,%eax
  803743:	31 d2                	xor    %edx,%edx
  803745:	f7 f5                	div    %ebp
  803747:	89 c8                	mov    %ecx,%eax
  803749:	f7 f5                	div    %ebp
  80374b:	89 d0                	mov    %edx,%eax
  80374d:	e9 44 ff ff ff       	jmp    803696 <__umoddi3+0x3e>
  803752:	66 90                	xchg   %ax,%ax
  803754:	89 c8                	mov    %ecx,%eax
  803756:	89 f2                	mov    %esi,%edx
  803758:	83 c4 1c             	add    $0x1c,%esp
  80375b:	5b                   	pop    %ebx
  80375c:	5e                   	pop    %esi
  80375d:	5f                   	pop    %edi
  80375e:	5d                   	pop    %ebp
  80375f:	c3                   	ret    
  803760:	3b 04 24             	cmp    (%esp),%eax
  803763:	72 06                	jb     80376b <__umoddi3+0x113>
  803765:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803769:	77 0f                	ja     80377a <__umoddi3+0x122>
  80376b:	89 f2                	mov    %esi,%edx
  80376d:	29 f9                	sub    %edi,%ecx
  80376f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803773:	89 14 24             	mov    %edx,(%esp)
  803776:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80377a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80377e:	8b 14 24             	mov    (%esp),%edx
  803781:	83 c4 1c             	add    $0x1c,%esp
  803784:	5b                   	pop    %ebx
  803785:	5e                   	pop    %esi
  803786:	5f                   	pop    %edi
  803787:	5d                   	pop    %ebp
  803788:	c3                   	ret    
  803789:	8d 76 00             	lea    0x0(%esi),%esi
  80378c:	2b 04 24             	sub    (%esp),%eax
  80378f:	19 fa                	sbb    %edi,%edx
  803791:	89 d1                	mov    %edx,%ecx
  803793:	89 c6                	mov    %eax,%esi
  803795:	e9 71 ff ff ff       	jmp    80370b <__umoddi3+0xb3>
  80379a:	66 90                	xchg   %ax,%ax
  80379c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8037a0:	72 ea                	jb     80378c <__umoddi3+0x134>
  8037a2:	89 d9                	mov    %ebx,%ecx
  8037a4:	e9 62 ff ff ff       	jmp    80370b <__umoddi3+0xb3>
