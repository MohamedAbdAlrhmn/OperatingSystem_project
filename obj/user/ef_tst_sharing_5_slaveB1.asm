
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
  80008c:	68 00 37 80 00       	push   $0x803700
  800091:	6a 12                	push   $0x12
  800093:	68 1c 37 80 00       	push   $0x80371c
  800098:	e8 da 01 00 00       	call   800277 <_panic>
	}
	uint32 *x;
	x = sget(sys_getparentenvid(),"x");
  80009d:	e8 71 1a 00 00       	call   801b13 <sys_getparentenvid>
  8000a2:	83 ec 08             	sub    $0x8,%esp
  8000a5:	68 3c 37 80 00       	push   $0x80373c
  8000aa:	50                   	push   %eax
  8000ab:	e8 46 15 00 00       	call   8015f6 <sget>
  8000b0:	83 c4 10             	add    $0x10,%esp
  8000b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("Slave B1 env used x (getSharedObject)\n");
  8000b6:	83 ec 0c             	sub    $0xc,%esp
  8000b9:	68 40 37 80 00       	push   $0x803740
  8000be:	e8 68 04 00 00       	call   80052b <cprintf>
  8000c3:	83 c4 10             	add    $0x10,%esp

	cprintf("Slave B1 please be patient ...\n");
  8000c6:	83 ec 0c             	sub    $0xc,%esp
  8000c9:	68 68 37 80 00       	push   $0x803768
  8000ce:	e8 58 04 00 00       	call   80052b <cprintf>
  8000d3:	83 c4 10             	add    $0x10,%esp

	env_sleep(6000);
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	68 70 17 00 00       	push   $0x1770
  8000de:	e8 f9 32 00 00       	call   8033dc <env_sleep>
  8000e3:	83 c4 10             	add    $0x10,%esp
	int freeFrames = sys_calculate_free_frames() ;
  8000e6:	e8 2f 17 00 00       	call   80181a <sys_calculate_free_frames>
  8000eb:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sfree(x);
  8000ee:	83 ec 0c             	sub    $0xc,%esp
  8000f1:	ff 75 ec             	pushl  -0x14(%ebp)
  8000f4:	e8 c1 15 00 00       	call   8016ba <sfree>
  8000f9:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave B1 env removed x\n");
  8000fc:	83 ec 0c             	sub    $0xc,%esp
  8000ff:	68 88 37 80 00       	push   $0x803788
  800104:	e8 22 04 00 00       	call   80052b <cprintf>
  800109:	83 c4 10             	add    $0x10,%esp

	if ((sys_calculate_free_frames() - freeFrames) !=  4) panic("B1 wrong free: frames removed not equal 4 !, correct frames to be removed are 4:\nfrom the env: 1 table and 1 for frame of x\nframes_storage of x: should be cleared now\n");
  80010c:	e8 09 17 00 00       	call   80181a <sys_calculate_free_frames>
  800111:	89 c2                	mov    %eax,%edx
  800113:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800116:	29 c2                	sub    %eax,%edx
  800118:	89 d0                	mov    %edx,%eax
  80011a:	83 f8 04             	cmp    $0x4,%eax
  80011d:	74 14                	je     800133 <_main+0xfb>
  80011f:	83 ec 04             	sub    $0x4,%esp
  800122:	68 a0 37 80 00       	push   $0x8037a0
  800127:	6a 20                	push   $0x20
  800129:	68 1c 37 80 00       	push   $0x80371c
  80012e:	e8 44 01 00 00       	call   800277 <_panic>

	//To indicate that it's completed successfully
	inctst();
  800133:	e8 00 1b 00 00       	call   801c38 <inctst>
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
  800141:	e8 b4 19 00 00       	call   801afa <sys_getenvindex>
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
  8001ac:	e8 56 17 00 00       	call   801907 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001b1:	83 ec 0c             	sub    $0xc,%esp
  8001b4:	68 60 38 80 00       	push   $0x803860
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
  8001dc:	68 88 38 80 00       	push   $0x803888
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
  80020d:	68 b0 38 80 00       	push   $0x8038b0
  800212:	e8 14 03 00 00       	call   80052b <cprintf>
  800217:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80021a:	a1 20 50 80 00       	mov    0x805020,%eax
  80021f:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800225:	83 ec 08             	sub    $0x8,%esp
  800228:	50                   	push   %eax
  800229:	68 08 39 80 00       	push   $0x803908
  80022e:	e8 f8 02 00 00       	call   80052b <cprintf>
  800233:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800236:	83 ec 0c             	sub    $0xc,%esp
  800239:	68 60 38 80 00       	push   $0x803860
  80023e:	e8 e8 02 00 00       	call   80052b <cprintf>
  800243:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800246:	e8 d6 16 00 00       	call   801921 <sys_enable_interrupt>

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
  80025e:	e8 63 18 00 00       	call   801ac6 <sys_destroy_env>
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
  80026f:	e8 b8 18 00 00       	call   801b2c <sys_exit_env>
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
  800298:	68 1c 39 80 00       	push   $0x80391c
  80029d:	e8 89 02 00 00       	call   80052b <cprintf>
  8002a2:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002a5:	a1 00 50 80 00       	mov    0x805000,%eax
  8002aa:	ff 75 0c             	pushl  0xc(%ebp)
  8002ad:	ff 75 08             	pushl  0x8(%ebp)
  8002b0:	50                   	push   %eax
  8002b1:	68 21 39 80 00       	push   $0x803921
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
  8002d5:	68 3d 39 80 00       	push   $0x80393d
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
  800301:	68 40 39 80 00       	push   $0x803940
  800306:	6a 26                	push   $0x26
  800308:	68 8c 39 80 00       	push   $0x80398c
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
  8003d3:	68 98 39 80 00       	push   $0x803998
  8003d8:	6a 3a                	push   $0x3a
  8003da:	68 8c 39 80 00       	push   $0x80398c
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
  800443:	68 ec 39 80 00       	push   $0x8039ec
  800448:	6a 44                	push   $0x44
  80044a:	68 8c 39 80 00       	push   $0x80398c
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
  80049d:	e8 b7 12 00 00       	call   801759 <sys_cputs>
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
  800514:	e8 40 12 00 00       	call   801759 <sys_cputs>
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
  80055e:	e8 a4 13 00 00       	call   801907 <sys_disable_interrupt>
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
  80057e:	e8 9e 13 00 00       	call   801921 <sys_enable_interrupt>
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
  8005c8:	e8 c3 2e 00 00       	call   803490 <__udivdi3>
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
  800618:	e8 83 2f 00 00       	call   8035a0 <__umoddi3>
  80061d:	83 c4 10             	add    $0x10,%esp
  800620:	05 54 3c 80 00       	add    $0x803c54,%eax
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
  800773:	8b 04 85 78 3c 80 00 	mov    0x803c78(,%eax,4),%eax
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
  800854:	8b 34 9d c0 3a 80 00 	mov    0x803ac0(,%ebx,4),%esi
  80085b:	85 f6                	test   %esi,%esi
  80085d:	75 19                	jne    800878 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80085f:	53                   	push   %ebx
  800860:	68 65 3c 80 00       	push   $0x803c65
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
  800879:	68 6e 3c 80 00       	push   $0x803c6e
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
  8008a6:	be 71 3c 80 00       	mov    $0x803c71,%esi
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
  8012cc:	68 d0 3d 80 00       	push   $0x803dd0
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
  80139c:	e8 fc 04 00 00       	call   80189d <sys_allocate_chunk>
  8013a1:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013a4:	a1 20 51 80 00       	mov    0x805120,%eax
  8013a9:	83 ec 0c             	sub    $0xc,%esp
  8013ac:	50                   	push   %eax
  8013ad:	e8 71 0b 00 00       	call   801f23 <initialize_MemBlocksList>
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
  8013da:	68 f5 3d 80 00       	push   $0x803df5
  8013df:	6a 33                	push   $0x33
  8013e1:	68 13 3e 80 00       	push   $0x803e13
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
  801459:	68 20 3e 80 00       	push   $0x803e20
  80145e:	6a 34                	push   $0x34
  801460:	68 13 3e 80 00       	push   $0x803e13
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
  8014f1:	e8 75 07 00 00       	call   801c6b <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014f6:	85 c0                	test   %eax,%eax
  8014f8:	74 11                	je     80150b <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  8014fa:	83 ec 0c             	sub    $0xc,%esp
  8014fd:	ff 75 e8             	pushl  -0x18(%ebp)
  801500:	e8 e0 0d 00 00       	call   8022e5 <alloc_block_FF>
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
  801517:	e8 3c 0b 00 00       	call   802058 <insert_sorted_allocList>
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
  801531:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801534:	83 ec 04             	sub    $0x4,%esp
  801537:	68 44 3e 80 00       	push   $0x803e44
  80153c:	6a 6f                	push   $0x6f
  80153e:	68 13 3e 80 00       	push   $0x803e13
  801543:	e8 2f ed ff ff       	call   800277 <_panic>

00801548 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801548:	55                   	push   %ebp
  801549:	89 e5                	mov    %esp,%ebp
  80154b:	83 ec 38             	sub    $0x38,%esp
  80154e:	8b 45 10             	mov    0x10(%ebp),%eax
  801551:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801554:	e8 5c fd ff ff       	call   8012b5 <InitializeUHeap>
	if (size == 0) return NULL ;
  801559:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80155d:	75 0a                	jne    801569 <smalloc+0x21>
  80155f:	b8 00 00 00 00       	mov    $0x0,%eax
  801564:	e9 8b 00 00 00       	jmp    8015f4 <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801569:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801570:	8b 55 0c             	mov    0xc(%ebp),%edx
  801573:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801576:	01 d0                	add    %edx,%eax
  801578:	48                   	dec    %eax
  801579:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80157c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80157f:	ba 00 00 00 00       	mov    $0x0,%edx
  801584:	f7 75 f0             	divl   -0x10(%ebp)
  801587:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80158a:	29 d0                	sub    %edx,%eax
  80158c:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  80158f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801596:	e8 d0 06 00 00       	call   801c6b <sys_isUHeapPlacementStrategyFIRSTFIT>
  80159b:	85 c0                	test   %eax,%eax
  80159d:	74 11                	je     8015b0 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  80159f:	83 ec 0c             	sub    $0xc,%esp
  8015a2:	ff 75 e8             	pushl  -0x18(%ebp)
  8015a5:	e8 3b 0d 00 00       	call   8022e5 <alloc_block_FF>
  8015aa:	83 c4 10             	add    $0x10,%esp
  8015ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  8015b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8015b4:	74 39                	je     8015ef <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8015b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015b9:	8b 40 08             	mov    0x8(%eax),%eax
  8015bc:	89 c2                	mov    %eax,%edx
  8015be:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8015c2:	52                   	push   %edx
  8015c3:	50                   	push   %eax
  8015c4:	ff 75 0c             	pushl  0xc(%ebp)
  8015c7:	ff 75 08             	pushl  0x8(%ebp)
  8015ca:	e8 21 04 00 00       	call   8019f0 <sys_createSharedObject>
  8015cf:	83 c4 10             	add    $0x10,%esp
  8015d2:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  8015d5:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  8015d9:	74 14                	je     8015ef <smalloc+0xa7>
  8015db:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  8015df:	74 0e                	je     8015ef <smalloc+0xa7>
  8015e1:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  8015e5:	74 08                	je     8015ef <smalloc+0xa7>
			return (void*) mem_block->sva;
  8015e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015ea:	8b 40 08             	mov    0x8(%eax),%eax
  8015ed:	eb 05                	jmp    8015f4 <smalloc+0xac>
	}
	return NULL;
  8015ef:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8015f4:	c9                   	leave  
  8015f5:	c3                   	ret    

008015f6 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8015f6:	55                   	push   %ebp
  8015f7:	89 e5                	mov    %esp,%ebp
  8015f9:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015fc:	e8 b4 fc ff ff       	call   8012b5 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801601:	83 ec 08             	sub    $0x8,%esp
  801604:	ff 75 0c             	pushl  0xc(%ebp)
  801607:	ff 75 08             	pushl  0x8(%ebp)
  80160a:	e8 0b 04 00 00       	call   801a1a <sys_getSizeOfSharedObject>
  80160f:	83 c4 10             	add    $0x10,%esp
  801612:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  801615:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  801619:	74 76                	je     801691 <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  80161b:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801622:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801625:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801628:	01 d0                	add    %edx,%eax
  80162a:	48                   	dec    %eax
  80162b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80162e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801631:	ba 00 00 00 00       	mov    $0x0,%edx
  801636:	f7 75 ec             	divl   -0x14(%ebp)
  801639:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80163c:	29 d0                	sub    %edx,%eax
  80163e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  801641:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801648:	e8 1e 06 00 00       	call   801c6b <sys_isUHeapPlacementStrategyFIRSTFIT>
  80164d:	85 c0                	test   %eax,%eax
  80164f:	74 11                	je     801662 <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  801651:	83 ec 0c             	sub    $0xc,%esp
  801654:	ff 75 e4             	pushl  -0x1c(%ebp)
  801657:	e8 89 0c 00 00       	call   8022e5 <alloc_block_FF>
  80165c:	83 c4 10             	add    $0x10,%esp
  80165f:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  801662:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801666:	74 29                	je     801691 <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  801668:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80166b:	8b 40 08             	mov    0x8(%eax),%eax
  80166e:	83 ec 04             	sub    $0x4,%esp
  801671:	50                   	push   %eax
  801672:	ff 75 0c             	pushl  0xc(%ebp)
  801675:	ff 75 08             	pushl  0x8(%ebp)
  801678:	e8 ba 03 00 00       	call   801a37 <sys_getSharedObject>
  80167d:	83 c4 10             	add    $0x10,%esp
  801680:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  801683:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  801687:	74 08                	je     801691 <sget+0x9b>
				return (void *)mem_block->sva;
  801689:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80168c:	8b 40 08             	mov    0x8(%eax),%eax
  80168f:	eb 05                	jmp    801696 <sget+0xa0>
		}
	}
	return NULL;
  801691:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801696:	c9                   	leave  
  801697:	c3                   	ret    

00801698 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801698:	55                   	push   %ebp
  801699:	89 e5                	mov    %esp,%ebp
  80169b:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80169e:	e8 12 fc ff ff       	call   8012b5 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8016a3:	83 ec 04             	sub    $0x4,%esp
  8016a6:	68 68 3e 80 00       	push   $0x803e68
  8016ab:	68 f1 00 00 00       	push   $0xf1
  8016b0:	68 13 3e 80 00       	push   $0x803e13
  8016b5:	e8 bd eb ff ff       	call   800277 <_panic>

008016ba <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8016ba:	55                   	push   %ebp
  8016bb:	89 e5                	mov    %esp,%ebp
  8016bd:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8016c0:	83 ec 04             	sub    $0x4,%esp
  8016c3:	68 90 3e 80 00       	push   $0x803e90
  8016c8:	68 05 01 00 00       	push   $0x105
  8016cd:	68 13 3e 80 00       	push   $0x803e13
  8016d2:	e8 a0 eb ff ff       	call   800277 <_panic>

008016d7 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8016d7:	55                   	push   %ebp
  8016d8:	89 e5                	mov    %esp,%ebp
  8016da:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016dd:	83 ec 04             	sub    $0x4,%esp
  8016e0:	68 b4 3e 80 00       	push   $0x803eb4
  8016e5:	68 10 01 00 00       	push   $0x110
  8016ea:	68 13 3e 80 00       	push   $0x803e13
  8016ef:	e8 83 eb ff ff       	call   800277 <_panic>

008016f4 <shrink>:

}
void shrink(uint32 newSize)
{
  8016f4:	55                   	push   %ebp
  8016f5:	89 e5                	mov    %esp,%ebp
  8016f7:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016fa:	83 ec 04             	sub    $0x4,%esp
  8016fd:	68 b4 3e 80 00       	push   $0x803eb4
  801702:	68 15 01 00 00       	push   $0x115
  801707:	68 13 3e 80 00       	push   $0x803e13
  80170c:	e8 66 eb ff ff       	call   800277 <_panic>

00801711 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801711:	55                   	push   %ebp
  801712:	89 e5                	mov    %esp,%ebp
  801714:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801717:	83 ec 04             	sub    $0x4,%esp
  80171a:	68 b4 3e 80 00       	push   $0x803eb4
  80171f:	68 1a 01 00 00       	push   $0x11a
  801724:	68 13 3e 80 00       	push   $0x803e13
  801729:	e8 49 eb ff ff       	call   800277 <_panic>

0080172e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80172e:	55                   	push   %ebp
  80172f:	89 e5                	mov    %esp,%ebp
  801731:	57                   	push   %edi
  801732:	56                   	push   %esi
  801733:	53                   	push   %ebx
  801734:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801737:	8b 45 08             	mov    0x8(%ebp),%eax
  80173a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80173d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801740:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801743:	8b 7d 18             	mov    0x18(%ebp),%edi
  801746:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801749:	cd 30                	int    $0x30
  80174b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80174e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801751:	83 c4 10             	add    $0x10,%esp
  801754:	5b                   	pop    %ebx
  801755:	5e                   	pop    %esi
  801756:	5f                   	pop    %edi
  801757:	5d                   	pop    %ebp
  801758:	c3                   	ret    

00801759 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801759:	55                   	push   %ebp
  80175a:	89 e5                	mov    %esp,%ebp
  80175c:	83 ec 04             	sub    $0x4,%esp
  80175f:	8b 45 10             	mov    0x10(%ebp),%eax
  801762:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801765:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801769:	8b 45 08             	mov    0x8(%ebp),%eax
  80176c:	6a 00                	push   $0x0
  80176e:	6a 00                	push   $0x0
  801770:	52                   	push   %edx
  801771:	ff 75 0c             	pushl  0xc(%ebp)
  801774:	50                   	push   %eax
  801775:	6a 00                	push   $0x0
  801777:	e8 b2 ff ff ff       	call   80172e <syscall>
  80177c:	83 c4 18             	add    $0x18,%esp
}
  80177f:	90                   	nop
  801780:	c9                   	leave  
  801781:	c3                   	ret    

00801782 <sys_cgetc>:

int
sys_cgetc(void)
{
  801782:	55                   	push   %ebp
  801783:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801785:	6a 00                	push   $0x0
  801787:	6a 00                	push   $0x0
  801789:	6a 00                	push   $0x0
  80178b:	6a 00                	push   $0x0
  80178d:	6a 00                	push   $0x0
  80178f:	6a 01                	push   $0x1
  801791:	e8 98 ff ff ff       	call   80172e <syscall>
  801796:	83 c4 18             	add    $0x18,%esp
}
  801799:	c9                   	leave  
  80179a:	c3                   	ret    

0080179b <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80179b:	55                   	push   %ebp
  80179c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80179e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a4:	6a 00                	push   $0x0
  8017a6:	6a 00                	push   $0x0
  8017a8:	6a 00                	push   $0x0
  8017aa:	52                   	push   %edx
  8017ab:	50                   	push   %eax
  8017ac:	6a 05                	push   $0x5
  8017ae:	e8 7b ff ff ff       	call   80172e <syscall>
  8017b3:	83 c4 18             	add    $0x18,%esp
}
  8017b6:	c9                   	leave  
  8017b7:	c3                   	ret    

008017b8 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8017b8:	55                   	push   %ebp
  8017b9:	89 e5                	mov    %esp,%ebp
  8017bb:	56                   	push   %esi
  8017bc:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8017bd:	8b 75 18             	mov    0x18(%ebp),%esi
  8017c0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017c3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cc:	56                   	push   %esi
  8017cd:	53                   	push   %ebx
  8017ce:	51                   	push   %ecx
  8017cf:	52                   	push   %edx
  8017d0:	50                   	push   %eax
  8017d1:	6a 06                	push   $0x6
  8017d3:	e8 56 ff ff ff       	call   80172e <syscall>
  8017d8:	83 c4 18             	add    $0x18,%esp
}
  8017db:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017de:	5b                   	pop    %ebx
  8017df:	5e                   	pop    %esi
  8017e0:	5d                   	pop    %ebp
  8017e1:	c3                   	ret    

008017e2 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8017e2:	55                   	push   %ebp
  8017e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8017e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017eb:	6a 00                	push   $0x0
  8017ed:	6a 00                	push   $0x0
  8017ef:	6a 00                	push   $0x0
  8017f1:	52                   	push   %edx
  8017f2:	50                   	push   %eax
  8017f3:	6a 07                	push   $0x7
  8017f5:	e8 34 ff ff ff       	call   80172e <syscall>
  8017fa:	83 c4 18             	add    $0x18,%esp
}
  8017fd:	c9                   	leave  
  8017fe:	c3                   	ret    

008017ff <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8017ff:	55                   	push   %ebp
  801800:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801802:	6a 00                	push   $0x0
  801804:	6a 00                	push   $0x0
  801806:	6a 00                	push   $0x0
  801808:	ff 75 0c             	pushl  0xc(%ebp)
  80180b:	ff 75 08             	pushl  0x8(%ebp)
  80180e:	6a 08                	push   $0x8
  801810:	e8 19 ff ff ff       	call   80172e <syscall>
  801815:	83 c4 18             	add    $0x18,%esp
}
  801818:	c9                   	leave  
  801819:	c3                   	ret    

0080181a <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80181a:	55                   	push   %ebp
  80181b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80181d:	6a 00                	push   $0x0
  80181f:	6a 00                	push   $0x0
  801821:	6a 00                	push   $0x0
  801823:	6a 00                	push   $0x0
  801825:	6a 00                	push   $0x0
  801827:	6a 09                	push   $0x9
  801829:	e8 00 ff ff ff       	call   80172e <syscall>
  80182e:	83 c4 18             	add    $0x18,%esp
}
  801831:	c9                   	leave  
  801832:	c3                   	ret    

00801833 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801833:	55                   	push   %ebp
  801834:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801836:	6a 00                	push   $0x0
  801838:	6a 00                	push   $0x0
  80183a:	6a 00                	push   $0x0
  80183c:	6a 00                	push   $0x0
  80183e:	6a 00                	push   $0x0
  801840:	6a 0a                	push   $0xa
  801842:	e8 e7 fe ff ff       	call   80172e <syscall>
  801847:	83 c4 18             	add    $0x18,%esp
}
  80184a:	c9                   	leave  
  80184b:	c3                   	ret    

0080184c <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80184c:	55                   	push   %ebp
  80184d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80184f:	6a 00                	push   $0x0
  801851:	6a 00                	push   $0x0
  801853:	6a 00                	push   $0x0
  801855:	6a 00                	push   $0x0
  801857:	6a 00                	push   $0x0
  801859:	6a 0b                	push   $0xb
  80185b:	e8 ce fe ff ff       	call   80172e <syscall>
  801860:	83 c4 18             	add    $0x18,%esp
}
  801863:	c9                   	leave  
  801864:	c3                   	ret    

00801865 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801865:	55                   	push   %ebp
  801866:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801868:	6a 00                	push   $0x0
  80186a:	6a 00                	push   $0x0
  80186c:	6a 00                	push   $0x0
  80186e:	ff 75 0c             	pushl  0xc(%ebp)
  801871:	ff 75 08             	pushl  0x8(%ebp)
  801874:	6a 0f                	push   $0xf
  801876:	e8 b3 fe ff ff       	call   80172e <syscall>
  80187b:	83 c4 18             	add    $0x18,%esp
	return;
  80187e:	90                   	nop
}
  80187f:	c9                   	leave  
  801880:	c3                   	ret    

00801881 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801881:	55                   	push   %ebp
  801882:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801884:	6a 00                	push   $0x0
  801886:	6a 00                	push   $0x0
  801888:	6a 00                	push   $0x0
  80188a:	ff 75 0c             	pushl  0xc(%ebp)
  80188d:	ff 75 08             	pushl  0x8(%ebp)
  801890:	6a 10                	push   $0x10
  801892:	e8 97 fe ff ff       	call   80172e <syscall>
  801897:	83 c4 18             	add    $0x18,%esp
	return ;
  80189a:	90                   	nop
}
  80189b:	c9                   	leave  
  80189c:	c3                   	ret    

0080189d <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80189d:	55                   	push   %ebp
  80189e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8018a0:	6a 00                	push   $0x0
  8018a2:	6a 00                	push   $0x0
  8018a4:	ff 75 10             	pushl  0x10(%ebp)
  8018a7:	ff 75 0c             	pushl  0xc(%ebp)
  8018aa:	ff 75 08             	pushl  0x8(%ebp)
  8018ad:	6a 11                	push   $0x11
  8018af:	e8 7a fe ff ff       	call   80172e <syscall>
  8018b4:	83 c4 18             	add    $0x18,%esp
	return ;
  8018b7:	90                   	nop
}
  8018b8:	c9                   	leave  
  8018b9:	c3                   	ret    

008018ba <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8018ba:	55                   	push   %ebp
  8018bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8018bd:	6a 00                	push   $0x0
  8018bf:	6a 00                	push   $0x0
  8018c1:	6a 00                	push   $0x0
  8018c3:	6a 00                	push   $0x0
  8018c5:	6a 00                	push   $0x0
  8018c7:	6a 0c                	push   $0xc
  8018c9:	e8 60 fe ff ff       	call   80172e <syscall>
  8018ce:	83 c4 18             	add    $0x18,%esp
}
  8018d1:	c9                   	leave  
  8018d2:	c3                   	ret    

008018d3 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8018d3:	55                   	push   %ebp
  8018d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8018d6:	6a 00                	push   $0x0
  8018d8:	6a 00                	push   $0x0
  8018da:	6a 00                	push   $0x0
  8018dc:	6a 00                	push   $0x0
  8018de:	ff 75 08             	pushl  0x8(%ebp)
  8018e1:	6a 0d                	push   $0xd
  8018e3:	e8 46 fe ff ff       	call   80172e <syscall>
  8018e8:	83 c4 18             	add    $0x18,%esp
}
  8018eb:	c9                   	leave  
  8018ec:	c3                   	ret    

008018ed <sys_scarce_memory>:

void sys_scarce_memory()
{
  8018ed:	55                   	push   %ebp
  8018ee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8018f0:	6a 00                	push   $0x0
  8018f2:	6a 00                	push   $0x0
  8018f4:	6a 00                	push   $0x0
  8018f6:	6a 00                	push   $0x0
  8018f8:	6a 00                	push   $0x0
  8018fa:	6a 0e                	push   $0xe
  8018fc:	e8 2d fe ff ff       	call   80172e <syscall>
  801901:	83 c4 18             	add    $0x18,%esp
}
  801904:	90                   	nop
  801905:	c9                   	leave  
  801906:	c3                   	ret    

00801907 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801907:	55                   	push   %ebp
  801908:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80190a:	6a 00                	push   $0x0
  80190c:	6a 00                	push   $0x0
  80190e:	6a 00                	push   $0x0
  801910:	6a 00                	push   $0x0
  801912:	6a 00                	push   $0x0
  801914:	6a 13                	push   $0x13
  801916:	e8 13 fe ff ff       	call   80172e <syscall>
  80191b:	83 c4 18             	add    $0x18,%esp
}
  80191e:	90                   	nop
  80191f:	c9                   	leave  
  801920:	c3                   	ret    

00801921 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801921:	55                   	push   %ebp
  801922:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801924:	6a 00                	push   $0x0
  801926:	6a 00                	push   $0x0
  801928:	6a 00                	push   $0x0
  80192a:	6a 00                	push   $0x0
  80192c:	6a 00                	push   $0x0
  80192e:	6a 14                	push   $0x14
  801930:	e8 f9 fd ff ff       	call   80172e <syscall>
  801935:	83 c4 18             	add    $0x18,%esp
}
  801938:	90                   	nop
  801939:	c9                   	leave  
  80193a:	c3                   	ret    

0080193b <sys_cputc>:


void
sys_cputc(const char c)
{
  80193b:	55                   	push   %ebp
  80193c:	89 e5                	mov    %esp,%ebp
  80193e:	83 ec 04             	sub    $0x4,%esp
  801941:	8b 45 08             	mov    0x8(%ebp),%eax
  801944:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801947:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80194b:	6a 00                	push   $0x0
  80194d:	6a 00                	push   $0x0
  80194f:	6a 00                	push   $0x0
  801951:	6a 00                	push   $0x0
  801953:	50                   	push   %eax
  801954:	6a 15                	push   $0x15
  801956:	e8 d3 fd ff ff       	call   80172e <syscall>
  80195b:	83 c4 18             	add    $0x18,%esp
}
  80195e:	90                   	nop
  80195f:	c9                   	leave  
  801960:	c3                   	ret    

00801961 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801961:	55                   	push   %ebp
  801962:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801964:	6a 00                	push   $0x0
  801966:	6a 00                	push   $0x0
  801968:	6a 00                	push   $0x0
  80196a:	6a 00                	push   $0x0
  80196c:	6a 00                	push   $0x0
  80196e:	6a 16                	push   $0x16
  801970:	e8 b9 fd ff ff       	call   80172e <syscall>
  801975:	83 c4 18             	add    $0x18,%esp
}
  801978:	90                   	nop
  801979:	c9                   	leave  
  80197a:	c3                   	ret    

0080197b <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80197b:	55                   	push   %ebp
  80197c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80197e:	8b 45 08             	mov    0x8(%ebp),%eax
  801981:	6a 00                	push   $0x0
  801983:	6a 00                	push   $0x0
  801985:	6a 00                	push   $0x0
  801987:	ff 75 0c             	pushl  0xc(%ebp)
  80198a:	50                   	push   %eax
  80198b:	6a 17                	push   $0x17
  80198d:	e8 9c fd ff ff       	call   80172e <syscall>
  801992:	83 c4 18             	add    $0x18,%esp
}
  801995:	c9                   	leave  
  801996:	c3                   	ret    

00801997 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801997:	55                   	push   %ebp
  801998:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80199a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80199d:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a0:	6a 00                	push   $0x0
  8019a2:	6a 00                	push   $0x0
  8019a4:	6a 00                	push   $0x0
  8019a6:	52                   	push   %edx
  8019a7:	50                   	push   %eax
  8019a8:	6a 1a                	push   $0x1a
  8019aa:	e8 7f fd ff ff       	call   80172e <syscall>
  8019af:	83 c4 18             	add    $0x18,%esp
}
  8019b2:	c9                   	leave  
  8019b3:	c3                   	ret    

008019b4 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8019b4:	55                   	push   %ebp
  8019b5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 00                	push   $0x0
  8019c3:	52                   	push   %edx
  8019c4:	50                   	push   %eax
  8019c5:	6a 18                	push   $0x18
  8019c7:	e8 62 fd ff ff       	call   80172e <syscall>
  8019cc:	83 c4 18             	add    $0x18,%esp
}
  8019cf:	90                   	nop
  8019d0:	c9                   	leave  
  8019d1:	c3                   	ret    

008019d2 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8019d2:	55                   	push   %ebp
  8019d3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 00                	push   $0x0
  8019e1:	52                   	push   %edx
  8019e2:	50                   	push   %eax
  8019e3:	6a 19                	push   $0x19
  8019e5:	e8 44 fd ff ff       	call   80172e <syscall>
  8019ea:	83 c4 18             	add    $0x18,%esp
}
  8019ed:	90                   	nop
  8019ee:	c9                   	leave  
  8019ef:	c3                   	ret    

008019f0 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8019f0:	55                   	push   %ebp
  8019f1:	89 e5                	mov    %esp,%ebp
  8019f3:	83 ec 04             	sub    $0x4,%esp
  8019f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8019f9:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8019fc:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8019ff:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a03:	8b 45 08             	mov    0x8(%ebp),%eax
  801a06:	6a 00                	push   $0x0
  801a08:	51                   	push   %ecx
  801a09:	52                   	push   %edx
  801a0a:	ff 75 0c             	pushl  0xc(%ebp)
  801a0d:	50                   	push   %eax
  801a0e:	6a 1b                	push   $0x1b
  801a10:	e8 19 fd ff ff       	call   80172e <syscall>
  801a15:	83 c4 18             	add    $0x18,%esp
}
  801a18:	c9                   	leave  
  801a19:	c3                   	ret    

00801a1a <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801a1a:	55                   	push   %ebp
  801a1b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a1d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a20:	8b 45 08             	mov    0x8(%ebp),%eax
  801a23:	6a 00                	push   $0x0
  801a25:	6a 00                	push   $0x0
  801a27:	6a 00                	push   $0x0
  801a29:	52                   	push   %edx
  801a2a:	50                   	push   %eax
  801a2b:	6a 1c                	push   $0x1c
  801a2d:	e8 fc fc ff ff       	call   80172e <syscall>
  801a32:	83 c4 18             	add    $0x18,%esp
}
  801a35:	c9                   	leave  
  801a36:	c3                   	ret    

00801a37 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801a37:	55                   	push   %ebp
  801a38:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a3a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a40:	8b 45 08             	mov    0x8(%ebp),%eax
  801a43:	6a 00                	push   $0x0
  801a45:	6a 00                	push   $0x0
  801a47:	51                   	push   %ecx
  801a48:	52                   	push   %edx
  801a49:	50                   	push   %eax
  801a4a:	6a 1d                	push   $0x1d
  801a4c:	e8 dd fc ff ff       	call   80172e <syscall>
  801a51:	83 c4 18             	add    $0x18,%esp
}
  801a54:	c9                   	leave  
  801a55:	c3                   	ret    

00801a56 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801a56:	55                   	push   %ebp
  801a57:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a59:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 00                	push   $0x0
  801a63:	6a 00                	push   $0x0
  801a65:	52                   	push   %edx
  801a66:	50                   	push   %eax
  801a67:	6a 1e                	push   $0x1e
  801a69:	e8 c0 fc ff ff       	call   80172e <syscall>
  801a6e:	83 c4 18             	add    $0x18,%esp
}
  801a71:	c9                   	leave  
  801a72:	c3                   	ret    

00801a73 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801a73:	55                   	push   %ebp
  801a74:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801a76:	6a 00                	push   $0x0
  801a78:	6a 00                	push   $0x0
  801a7a:	6a 00                	push   $0x0
  801a7c:	6a 00                	push   $0x0
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 1f                	push   $0x1f
  801a82:	e8 a7 fc ff ff       	call   80172e <syscall>
  801a87:	83 c4 18             	add    $0x18,%esp
}
  801a8a:	c9                   	leave  
  801a8b:	c3                   	ret    

00801a8c <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a8c:	55                   	push   %ebp
  801a8d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a92:	6a 00                	push   $0x0
  801a94:	ff 75 14             	pushl  0x14(%ebp)
  801a97:	ff 75 10             	pushl  0x10(%ebp)
  801a9a:	ff 75 0c             	pushl  0xc(%ebp)
  801a9d:	50                   	push   %eax
  801a9e:	6a 20                	push   $0x20
  801aa0:	e8 89 fc ff ff       	call   80172e <syscall>
  801aa5:	83 c4 18             	add    $0x18,%esp
}
  801aa8:	c9                   	leave  
  801aa9:	c3                   	ret    

00801aaa <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801aaa:	55                   	push   %ebp
  801aab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801aad:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	50                   	push   %eax
  801ab9:	6a 21                	push   $0x21
  801abb:	e8 6e fc ff ff       	call   80172e <syscall>
  801ac0:	83 c4 18             	add    $0x18,%esp
}
  801ac3:	90                   	nop
  801ac4:	c9                   	leave  
  801ac5:	c3                   	ret    

00801ac6 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801ac6:	55                   	push   %ebp
  801ac7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  801acc:	6a 00                	push   $0x0
  801ace:	6a 00                	push   $0x0
  801ad0:	6a 00                	push   $0x0
  801ad2:	6a 00                	push   $0x0
  801ad4:	50                   	push   %eax
  801ad5:	6a 22                	push   $0x22
  801ad7:	e8 52 fc ff ff       	call   80172e <syscall>
  801adc:	83 c4 18             	add    $0x18,%esp
}
  801adf:	c9                   	leave  
  801ae0:	c3                   	ret    

00801ae1 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ae1:	55                   	push   %ebp
  801ae2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ae4:	6a 00                	push   $0x0
  801ae6:	6a 00                	push   $0x0
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 00                	push   $0x0
  801aec:	6a 00                	push   $0x0
  801aee:	6a 02                	push   $0x2
  801af0:	e8 39 fc ff ff       	call   80172e <syscall>
  801af5:	83 c4 18             	add    $0x18,%esp
}
  801af8:	c9                   	leave  
  801af9:	c3                   	ret    

00801afa <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801afa:	55                   	push   %ebp
  801afb:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801afd:	6a 00                	push   $0x0
  801aff:	6a 00                	push   $0x0
  801b01:	6a 00                	push   $0x0
  801b03:	6a 00                	push   $0x0
  801b05:	6a 00                	push   $0x0
  801b07:	6a 03                	push   $0x3
  801b09:	e8 20 fc ff ff       	call   80172e <syscall>
  801b0e:	83 c4 18             	add    $0x18,%esp
}
  801b11:	c9                   	leave  
  801b12:	c3                   	ret    

00801b13 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b13:	55                   	push   %ebp
  801b14:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b16:	6a 00                	push   $0x0
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 00                	push   $0x0
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 04                	push   $0x4
  801b22:	e8 07 fc ff ff       	call   80172e <syscall>
  801b27:	83 c4 18             	add    $0x18,%esp
}
  801b2a:	c9                   	leave  
  801b2b:	c3                   	ret    

00801b2c <sys_exit_env>:


void sys_exit_env(void)
{
  801b2c:	55                   	push   %ebp
  801b2d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 00                	push   $0x0
  801b33:	6a 00                	push   $0x0
  801b35:	6a 00                	push   $0x0
  801b37:	6a 00                	push   $0x0
  801b39:	6a 23                	push   $0x23
  801b3b:	e8 ee fb ff ff       	call   80172e <syscall>
  801b40:	83 c4 18             	add    $0x18,%esp
}
  801b43:	90                   	nop
  801b44:	c9                   	leave  
  801b45:	c3                   	ret    

00801b46 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801b46:	55                   	push   %ebp
  801b47:	89 e5                	mov    %esp,%ebp
  801b49:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b4c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b4f:	8d 50 04             	lea    0x4(%eax),%edx
  801b52:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b55:	6a 00                	push   $0x0
  801b57:	6a 00                	push   $0x0
  801b59:	6a 00                	push   $0x0
  801b5b:	52                   	push   %edx
  801b5c:	50                   	push   %eax
  801b5d:	6a 24                	push   $0x24
  801b5f:	e8 ca fb ff ff       	call   80172e <syscall>
  801b64:	83 c4 18             	add    $0x18,%esp
	return result;
  801b67:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b6a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b6d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b70:	89 01                	mov    %eax,(%ecx)
  801b72:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b75:	8b 45 08             	mov    0x8(%ebp),%eax
  801b78:	c9                   	leave  
  801b79:	c2 04 00             	ret    $0x4

00801b7c <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b7c:	55                   	push   %ebp
  801b7d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 00                	push   $0x0
  801b83:	ff 75 10             	pushl  0x10(%ebp)
  801b86:	ff 75 0c             	pushl  0xc(%ebp)
  801b89:	ff 75 08             	pushl  0x8(%ebp)
  801b8c:	6a 12                	push   $0x12
  801b8e:	e8 9b fb ff ff       	call   80172e <syscall>
  801b93:	83 c4 18             	add    $0x18,%esp
	return ;
  801b96:	90                   	nop
}
  801b97:	c9                   	leave  
  801b98:	c3                   	ret    

00801b99 <sys_rcr2>:
uint32 sys_rcr2()
{
  801b99:	55                   	push   %ebp
  801b9a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b9c:	6a 00                	push   $0x0
  801b9e:	6a 00                	push   $0x0
  801ba0:	6a 00                	push   $0x0
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 00                	push   $0x0
  801ba6:	6a 25                	push   $0x25
  801ba8:	e8 81 fb ff ff       	call   80172e <syscall>
  801bad:	83 c4 18             	add    $0x18,%esp
}
  801bb0:	c9                   	leave  
  801bb1:	c3                   	ret    

00801bb2 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801bb2:	55                   	push   %ebp
  801bb3:	89 e5                	mov    %esp,%ebp
  801bb5:	83 ec 04             	sub    $0x4,%esp
  801bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801bbe:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801bc2:	6a 00                	push   $0x0
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 00                	push   $0x0
  801bc8:	6a 00                	push   $0x0
  801bca:	50                   	push   %eax
  801bcb:	6a 26                	push   $0x26
  801bcd:	e8 5c fb ff ff       	call   80172e <syscall>
  801bd2:	83 c4 18             	add    $0x18,%esp
	return ;
  801bd5:	90                   	nop
}
  801bd6:	c9                   	leave  
  801bd7:	c3                   	ret    

00801bd8 <rsttst>:
void rsttst()
{
  801bd8:	55                   	push   %ebp
  801bd9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 00                	push   $0x0
  801be3:	6a 00                	push   $0x0
  801be5:	6a 28                	push   $0x28
  801be7:	e8 42 fb ff ff       	call   80172e <syscall>
  801bec:	83 c4 18             	add    $0x18,%esp
	return ;
  801bef:	90                   	nop
}
  801bf0:	c9                   	leave  
  801bf1:	c3                   	ret    

00801bf2 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801bf2:	55                   	push   %ebp
  801bf3:	89 e5                	mov    %esp,%ebp
  801bf5:	83 ec 04             	sub    $0x4,%esp
  801bf8:	8b 45 14             	mov    0x14(%ebp),%eax
  801bfb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801bfe:	8b 55 18             	mov    0x18(%ebp),%edx
  801c01:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c05:	52                   	push   %edx
  801c06:	50                   	push   %eax
  801c07:	ff 75 10             	pushl  0x10(%ebp)
  801c0a:	ff 75 0c             	pushl  0xc(%ebp)
  801c0d:	ff 75 08             	pushl  0x8(%ebp)
  801c10:	6a 27                	push   $0x27
  801c12:	e8 17 fb ff ff       	call   80172e <syscall>
  801c17:	83 c4 18             	add    $0x18,%esp
	return ;
  801c1a:	90                   	nop
}
  801c1b:	c9                   	leave  
  801c1c:	c3                   	ret    

00801c1d <chktst>:
void chktst(uint32 n)
{
  801c1d:	55                   	push   %ebp
  801c1e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c20:	6a 00                	push   $0x0
  801c22:	6a 00                	push   $0x0
  801c24:	6a 00                	push   $0x0
  801c26:	6a 00                	push   $0x0
  801c28:	ff 75 08             	pushl  0x8(%ebp)
  801c2b:	6a 29                	push   $0x29
  801c2d:	e8 fc fa ff ff       	call   80172e <syscall>
  801c32:	83 c4 18             	add    $0x18,%esp
	return ;
  801c35:	90                   	nop
}
  801c36:	c9                   	leave  
  801c37:	c3                   	ret    

00801c38 <inctst>:

void inctst()
{
  801c38:	55                   	push   %ebp
  801c39:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 00                	push   $0x0
  801c3f:	6a 00                	push   $0x0
  801c41:	6a 00                	push   $0x0
  801c43:	6a 00                	push   $0x0
  801c45:	6a 2a                	push   $0x2a
  801c47:	e8 e2 fa ff ff       	call   80172e <syscall>
  801c4c:	83 c4 18             	add    $0x18,%esp
	return ;
  801c4f:	90                   	nop
}
  801c50:	c9                   	leave  
  801c51:	c3                   	ret    

00801c52 <gettst>:
uint32 gettst()
{
  801c52:	55                   	push   %ebp
  801c53:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c55:	6a 00                	push   $0x0
  801c57:	6a 00                	push   $0x0
  801c59:	6a 00                	push   $0x0
  801c5b:	6a 00                	push   $0x0
  801c5d:	6a 00                	push   $0x0
  801c5f:	6a 2b                	push   $0x2b
  801c61:	e8 c8 fa ff ff       	call   80172e <syscall>
  801c66:	83 c4 18             	add    $0x18,%esp
}
  801c69:	c9                   	leave  
  801c6a:	c3                   	ret    

00801c6b <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801c6b:	55                   	push   %ebp
  801c6c:	89 e5                	mov    %esp,%ebp
  801c6e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c71:	6a 00                	push   $0x0
  801c73:	6a 00                	push   $0x0
  801c75:	6a 00                	push   $0x0
  801c77:	6a 00                	push   $0x0
  801c79:	6a 00                	push   $0x0
  801c7b:	6a 2c                	push   $0x2c
  801c7d:	e8 ac fa ff ff       	call   80172e <syscall>
  801c82:	83 c4 18             	add    $0x18,%esp
  801c85:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801c88:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801c8c:	75 07                	jne    801c95 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801c8e:	b8 01 00 00 00       	mov    $0x1,%eax
  801c93:	eb 05                	jmp    801c9a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801c95:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c9a:	c9                   	leave  
  801c9b:	c3                   	ret    

00801c9c <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801c9c:	55                   	push   %ebp
  801c9d:	89 e5                	mov    %esp,%ebp
  801c9f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 00                	push   $0x0
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 00                	push   $0x0
  801cac:	6a 2c                	push   $0x2c
  801cae:	e8 7b fa ff ff       	call   80172e <syscall>
  801cb3:	83 c4 18             	add    $0x18,%esp
  801cb6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801cb9:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801cbd:	75 07                	jne    801cc6 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801cbf:	b8 01 00 00 00       	mov    $0x1,%eax
  801cc4:	eb 05                	jmp    801ccb <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801cc6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ccb:	c9                   	leave  
  801ccc:	c3                   	ret    

00801ccd <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801ccd:	55                   	push   %ebp
  801cce:	89 e5                	mov    %esp,%ebp
  801cd0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cd3:	6a 00                	push   $0x0
  801cd5:	6a 00                	push   $0x0
  801cd7:	6a 00                	push   $0x0
  801cd9:	6a 00                	push   $0x0
  801cdb:	6a 00                	push   $0x0
  801cdd:	6a 2c                	push   $0x2c
  801cdf:	e8 4a fa ff ff       	call   80172e <syscall>
  801ce4:	83 c4 18             	add    $0x18,%esp
  801ce7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801cea:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801cee:	75 07                	jne    801cf7 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801cf0:	b8 01 00 00 00       	mov    $0x1,%eax
  801cf5:	eb 05                	jmp    801cfc <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801cf7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cfc:	c9                   	leave  
  801cfd:	c3                   	ret    

00801cfe <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801cfe:	55                   	push   %ebp
  801cff:	89 e5                	mov    %esp,%ebp
  801d01:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d04:	6a 00                	push   $0x0
  801d06:	6a 00                	push   $0x0
  801d08:	6a 00                	push   $0x0
  801d0a:	6a 00                	push   $0x0
  801d0c:	6a 00                	push   $0x0
  801d0e:	6a 2c                	push   $0x2c
  801d10:	e8 19 fa ff ff       	call   80172e <syscall>
  801d15:	83 c4 18             	add    $0x18,%esp
  801d18:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801d1b:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801d1f:	75 07                	jne    801d28 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801d21:	b8 01 00 00 00       	mov    $0x1,%eax
  801d26:	eb 05                	jmp    801d2d <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801d28:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d2d:	c9                   	leave  
  801d2e:	c3                   	ret    

00801d2f <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801d2f:	55                   	push   %ebp
  801d30:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801d32:	6a 00                	push   $0x0
  801d34:	6a 00                	push   $0x0
  801d36:	6a 00                	push   $0x0
  801d38:	6a 00                	push   $0x0
  801d3a:	ff 75 08             	pushl  0x8(%ebp)
  801d3d:	6a 2d                	push   $0x2d
  801d3f:	e8 ea f9 ff ff       	call   80172e <syscall>
  801d44:	83 c4 18             	add    $0x18,%esp
	return ;
  801d47:	90                   	nop
}
  801d48:	c9                   	leave  
  801d49:	c3                   	ret    

00801d4a <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801d4a:	55                   	push   %ebp
  801d4b:	89 e5                	mov    %esp,%ebp
  801d4d:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801d4e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d51:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d54:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d57:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5a:	6a 00                	push   $0x0
  801d5c:	53                   	push   %ebx
  801d5d:	51                   	push   %ecx
  801d5e:	52                   	push   %edx
  801d5f:	50                   	push   %eax
  801d60:	6a 2e                	push   $0x2e
  801d62:	e8 c7 f9 ff ff       	call   80172e <syscall>
  801d67:	83 c4 18             	add    $0x18,%esp
}
  801d6a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d6d:	c9                   	leave  
  801d6e:	c3                   	ret    

00801d6f <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801d6f:	55                   	push   %ebp
  801d70:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801d72:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d75:	8b 45 08             	mov    0x8(%ebp),%eax
  801d78:	6a 00                	push   $0x0
  801d7a:	6a 00                	push   $0x0
  801d7c:	6a 00                	push   $0x0
  801d7e:	52                   	push   %edx
  801d7f:	50                   	push   %eax
  801d80:	6a 2f                	push   $0x2f
  801d82:	e8 a7 f9 ff ff       	call   80172e <syscall>
  801d87:	83 c4 18             	add    $0x18,%esp
}
  801d8a:	c9                   	leave  
  801d8b:	c3                   	ret    

00801d8c <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801d8c:	55                   	push   %ebp
  801d8d:	89 e5                	mov    %esp,%ebp
  801d8f:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801d92:	83 ec 0c             	sub    $0xc,%esp
  801d95:	68 c4 3e 80 00       	push   $0x803ec4
  801d9a:	e8 8c e7 ff ff       	call   80052b <cprintf>
  801d9f:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801da2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801da9:	83 ec 0c             	sub    $0xc,%esp
  801dac:	68 f0 3e 80 00       	push   $0x803ef0
  801db1:	e8 75 e7 ff ff       	call   80052b <cprintf>
  801db6:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801db9:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801dbd:	a1 38 51 80 00       	mov    0x805138,%eax
  801dc2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dc5:	eb 56                	jmp    801e1d <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801dc7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801dcb:	74 1c                	je     801de9 <print_mem_block_lists+0x5d>
  801dcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd0:	8b 50 08             	mov    0x8(%eax),%edx
  801dd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dd6:	8b 48 08             	mov    0x8(%eax),%ecx
  801dd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ddc:	8b 40 0c             	mov    0xc(%eax),%eax
  801ddf:	01 c8                	add    %ecx,%eax
  801de1:	39 c2                	cmp    %eax,%edx
  801de3:	73 04                	jae    801de9 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801de5:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801de9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dec:	8b 50 08             	mov    0x8(%eax),%edx
  801def:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df2:	8b 40 0c             	mov    0xc(%eax),%eax
  801df5:	01 c2                	add    %eax,%edx
  801df7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dfa:	8b 40 08             	mov    0x8(%eax),%eax
  801dfd:	83 ec 04             	sub    $0x4,%esp
  801e00:	52                   	push   %edx
  801e01:	50                   	push   %eax
  801e02:	68 05 3f 80 00       	push   $0x803f05
  801e07:	e8 1f e7 ff ff       	call   80052b <cprintf>
  801e0c:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e12:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e15:	a1 40 51 80 00       	mov    0x805140,%eax
  801e1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e1d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e21:	74 07                	je     801e2a <print_mem_block_lists+0x9e>
  801e23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e26:	8b 00                	mov    (%eax),%eax
  801e28:	eb 05                	jmp    801e2f <print_mem_block_lists+0xa3>
  801e2a:	b8 00 00 00 00       	mov    $0x0,%eax
  801e2f:	a3 40 51 80 00       	mov    %eax,0x805140
  801e34:	a1 40 51 80 00       	mov    0x805140,%eax
  801e39:	85 c0                	test   %eax,%eax
  801e3b:	75 8a                	jne    801dc7 <print_mem_block_lists+0x3b>
  801e3d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e41:	75 84                	jne    801dc7 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801e43:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e47:	75 10                	jne    801e59 <print_mem_block_lists+0xcd>
  801e49:	83 ec 0c             	sub    $0xc,%esp
  801e4c:	68 14 3f 80 00       	push   $0x803f14
  801e51:	e8 d5 e6 ff ff       	call   80052b <cprintf>
  801e56:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801e59:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801e60:	83 ec 0c             	sub    $0xc,%esp
  801e63:	68 38 3f 80 00       	push   $0x803f38
  801e68:	e8 be e6 ff ff       	call   80052b <cprintf>
  801e6d:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801e70:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801e74:	a1 40 50 80 00       	mov    0x805040,%eax
  801e79:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e7c:	eb 56                	jmp    801ed4 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e7e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e82:	74 1c                	je     801ea0 <print_mem_block_lists+0x114>
  801e84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e87:	8b 50 08             	mov    0x8(%eax),%edx
  801e8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e8d:	8b 48 08             	mov    0x8(%eax),%ecx
  801e90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e93:	8b 40 0c             	mov    0xc(%eax),%eax
  801e96:	01 c8                	add    %ecx,%eax
  801e98:	39 c2                	cmp    %eax,%edx
  801e9a:	73 04                	jae    801ea0 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801e9c:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801ea0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ea3:	8b 50 08             	mov    0x8(%eax),%edx
  801ea6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ea9:	8b 40 0c             	mov    0xc(%eax),%eax
  801eac:	01 c2                	add    %eax,%edx
  801eae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb1:	8b 40 08             	mov    0x8(%eax),%eax
  801eb4:	83 ec 04             	sub    $0x4,%esp
  801eb7:	52                   	push   %edx
  801eb8:	50                   	push   %eax
  801eb9:	68 05 3f 80 00       	push   $0x803f05
  801ebe:	e8 68 e6 ff ff       	call   80052b <cprintf>
  801ec3:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801ec6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801ecc:	a1 48 50 80 00       	mov    0x805048,%eax
  801ed1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ed4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ed8:	74 07                	je     801ee1 <print_mem_block_lists+0x155>
  801eda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801edd:	8b 00                	mov    (%eax),%eax
  801edf:	eb 05                	jmp    801ee6 <print_mem_block_lists+0x15a>
  801ee1:	b8 00 00 00 00       	mov    $0x0,%eax
  801ee6:	a3 48 50 80 00       	mov    %eax,0x805048
  801eeb:	a1 48 50 80 00       	mov    0x805048,%eax
  801ef0:	85 c0                	test   %eax,%eax
  801ef2:	75 8a                	jne    801e7e <print_mem_block_lists+0xf2>
  801ef4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ef8:	75 84                	jne    801e7e <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801efa:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801efe:	75 10                	jne    801f10 <print_mem_block_lists+0x184>
  801f00:	83 ec 0c             	sub    $0xc,%esp
  801f03:	68 50 3f 80 00       	push   $0x803f50
  801f08:	e8 1e e6 ff ff       	call   80052b <cprintf>
  801f0d:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801f10:	83 ec 0c             	sub    $0xc,%esp
  801f13:	68 c4 3e 80 00       	push   $0x803ec4
  801f18:	e8 0e e6 ff ff       	call   80052b <cprintf>
  801f1d:	83 c4 10             	add    $0x10,%esp

}
  801f20:	90                   	nop
  801f21:	c9                   	leave  
  801f22:	c3                   	ret    

00801f23 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801f23:	55                   	push   %ebp
  801f24:	89 e5                	mov    %esp,%ebp
  801f26:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801f29:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  801f30:	00 00 00 
  801f33:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  801f3a:	00 00 00 
  801f3d:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  801f44:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801f47:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801f4e:	e9 9e 00 00 00       	jmp    801ff1 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801f53:	a1 50 50 80 00       	mov    0x805050,%eax
  801f58:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f5b:	c1 e2 04             	shl    $0x4,%edx
  801f5e:	01 d0                	add    %edx,%eax
  801f60:	85 c0                	test   %eax,%eax
  801f62:	75 14                	jne    801f78 <initialize_MemBlocksList+0x55>
  801f64:	83 ec 04             	sub    $0x4,%esp
  801f67:	68 78 3f 80 00       	push   $0x803f78
  801f6c:	6a 46                	push   $0x46
  801f6e:	68 9b 3f 80 00       	push   $0x803f9b
  801f73:	e8 ff e2 ff ff       	call   800277 <_panic>
  801f78:	a1 50 50 80 00       	mov    0x805050,%eax
  801f7d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f80:	c1 e2 04             	shl    $0x4,%edx
  801f83:	01 d0                	add    %edx,%eax
  801f85:	8b 15 48 51 80 00    	mov    0x805148,%edx
  801f8b:	89 10                	mov    %edx,(%eax)
  801f8d:	8b 00                	mov    (%eax),%eax
  801f8f:	85 c0                	test   %eax,%eax
  801f91:	74 18                	je     801fab <initialize_MemBlocksList+0x88>
  801f93:	a1 48 51 80 00       	mov    0x805148,%eax
  801f98:	8b 15 50 50 80 00    	mov    0x805050,%edx
  801f9e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801fa1:	c1 e1 04             	shl    $0x4,%ecx
  801fa4:	01 ca                	add    %ecx,%edx
  801fa6:	89 50 04             	mov    %edx,0x4(%eax)
  801fa9:	eb 12                	jmp    801fbd <initialize_MemBlocksList+0x9a>
  801fab:	a1 50 50 80 00       	mov    0x805050,%eax
  801fb0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fb3:	c1 e2 04             	shl    $0x4,%edx
  801fb6:	01 d0                	add    %edx,%eax
  801fb8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801fbd:	a1 50 50 80 00       	mov    0x805050,%eax
  801fc2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fc5:	c1 e2 04             	shl    $0x4,%edx
  801fc8:	01 d0                	add    %edx,%eax
  801fca:	a3 48 51 80 00       	mov    %eax,0x805148
  801fcf:	a1 50 50 80 00       	mov    0x805050,%eax
  801fd4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fd7:	c1 e2 04             	shl    $0x4,%edx
  801fda:	01 d0                	add    %edx,%eax
  801fdc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801fe3:	a1 54 51 80 00       	mov    0x805154,%eax
  801fe8:	40                   	inc    %eax
  801fe9:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801fee:	ff 45 f4             	incl   -0xc(%ebp)
  801ff1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff4:	3b 45 08             	cmp    0x8(%ebp),%eax
  801ff7:	0f 82 56 ff ff ff    	jb     801f53 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801ffd:	90                   	nop
  801ffe:	c9                   	leave  
  801fff:	c3                   	ret    

00802000 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802000:	55                   	push   %ebp
  802001:	89 e5                	mov    %esp,%ebp
  802003:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802006:	8b 45 08             	mov    0x8(%ebp),%eax
  802009:	8b 00                	mov    (%eax),%eax
  80200b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80200e:	eb 19                	jmp    802029 <find_block+0x29>
	{
		if(va==point->sva)
  802010:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802013:	8b 40 08             	mov    0x8(%eax),%eax
  802016:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802019:	75 05                	jne    802020 <find_block+0x20>
		   return point;
  80201b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80201e:	eb 36                	jmp    802056 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802020:	8b 45 08             	mov    0x8(%ebp),%eax
  802023:	8b 40 08             	mov    0x8(%eax),%eax
  802026:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802029:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80202d:	74 07                	je     802036 <find_block+0x36>
  80202f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802032:	8b 00                	mov    (%eax),%eax
  802034:	eb 05                	jmp    80203b <find_block+0x3b>
  802036:	b8 00 00 00 00       	mov    $0x0,%eax
  80203b:	8b 55 08             	mov    0x8(%ebp),%edx
  80203e:	89 42 08             	mov    %eax,0x8(%edx)
  802041:	8b 45 08             	mov    0x8(%ebp),%eax
  802044:	8b 40 08             	mov    0x8(%eax),%eax
  802047:	85 c0                	test   %eax,%eax
  802049:	75 c5                	jne    802010 <find_block+0x10>
  80204b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80204f:	75 bf                	jne    802010 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802051:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802056:	c9                   	leave  
  802057:	c3                   	ret    

00802058 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802058:	55                   	push   %ebp
  802059:	89 e5                	mov    %esp,%ebp
  80205b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  80205e:	a1 40 50 80 00       	mov    0x805040,%eax
  802063:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802066:	a1 44 50 80 00       	mov    0x805044,%eax
  80206b:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  80206e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802071:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802074:	74 24                	je     80209a <insert_sorted_allocList+0x42>
  802076:	8b 45 08             	mov    0x8(%ebp),%eax
  802079:	8b 50 08             	mov    0x8(%eax),%edx
  80207c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80207f:	8b 40 08             	mov    0x8(%eax),%eax
  802082:	39 c2                	cmp    %eax,%edx
  802084:	76 14                	jbe    80209a <insert_sorted_allocList+0x42>
  802086:	8b 45 08             	mov    0x8(%ebp),%eax
  802089:	8b 50 08             	mov    0x8(%eax),%edx
  80208c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80208f:	8b 40 08             	mov    0x8(%eax),%eax
  802092:	39 c2                	cmp    %eax,%edx
  802094:	0f 82 60 01 00 00    	jb     8021fa <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  80209a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80209e:	75 65                	jne    802105 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8020a0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020a4:	75 14                	jne    8020ba <insert_sorted_allocList+0x62>
  8020a6:	83 ec 04             	sub    $0x4,%esp
  8020a9:	68 78 3f 80 00       	push   $0x803f78
  8020ae:	6a 6b                	push   $0x6b
  8020b0:	68 9b 3f 80 00       	push   $0x803f9b
  8020b5:	e8 bd e1 ff ff       	call   800277 <_panic>
  8020ba:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8020c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c3:	89 10                	mov    %edx,(%eax)
  8020c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c8:	8b 00                	mov    (%eax),%eax
  8020ca:	85 c0                	test   %eax,%eax
  8020cc:	74 0d                	je     8020db <insert_sorted_allocList+0x83>
  8020ce:	a1 40 50 80 00       	mov    0x805040,%eax
  8020d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8020d6:	89 50 04             	mov    %edx,0x4(%eax)
  8020d9:	eb 08                	jmp    8020e3 <insert_sorted_allocList+0x8b>
  8020db:	8b 45 08             	mov    0x8(%ebp),%eax
  8020de:	a3 44 50 80 00       	mov    %eax,0x805044
  8020e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e6:	a3 40 50 80 00       	mov    %eax,0x805040
  8020eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020f5:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8020fa:	40                   	inc    %eax
  8020fb:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802100:	e9 dc 01 00 00       	jmp    8022e1 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802105:	8b 45 08             	mov    0x8(%ebp),%eax
  802108:	8b 50 08             	mov    0x8(%eax),%edx
  80210b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80210e:	8b 40 08             	mov    0x8(%eax),%eax
  802111:	39 c2                	cmp    %eax,%edx
  802113:	77 6c                	ja     802181 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802115:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802119:	74 06                	je     802121 <insert_sorted_allocList+0xc9>
  80211b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80211f:	75 14                	jne    802135 <insert_sorted_allocList+0xdd>
  802121:	83 ec 04             	sub    $0x4,%esp
  802124:	68 b4 3f 80 00       	push   $0x803fb4
  802129:	6a 6f                	push   $0x6f
  80212b:	68 9b 3f 80 00       	push   $0x803f9b
  802130:	e8 42 e1 ff ff       	call   800277 <_panic>
  802135:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802138:	8b 50 04             	mov    0x4(%eax),%edx
  80213b:	8b 45 08             	mov    0x8(%ebp),%eax
  80213e:	89 50 04             	mov    %edx,0x4(%eax)
  802141:	8b 45 08             	mov    0x8(%ebp),%eax
  802144:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802147:	89 10                	mov    %edx,(%eax)
  802149:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80214c:	8b 40 04             	mov    0x4(%eax),%eax
  80214f:	85 c0                	test   %eax,%eax
  802151:	74 0d                	je     802160 <insert_sorted_allocList+0x108>
  802153:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802156:	8b 40 04             	mov    0x4(%eax),%eax
  802159:	8b 55 08             	mov    0x8(%ebp),%edx
  80215c:	89 10                	mov    %edx,(%eax)
  80215e:	eb 08                	jmp    802168 <insert_sorted_allocList+0x110>
  802160:	8b 45 08             	mov    0x8(%ebp),%eax
  802163:	a3 40 50 80 00       	mov    %eax,0x805040
  802168:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80216b:	8b 55 08             	mov    0x8(%ebp),%edx
  80216e:	89 50 04             	mov    %edx,0x4(%eax)
  802171:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802176:	40                   	inc    %eax
  802177:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80217c:	e9 60 01 00 00       	jmp    8022e1 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802181:	8b 45 08             	mov    0x8(%ebp),%eax
  802184:	8b 50 08             	mov    0x8(%eax),%edx
  802187:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80218a:	8b 40 08             	mov    0x8(%eax),%eax
  80218d:	39 c2                	cmp    %eax,%edx
  80218f:	0f 82 4c 01 00 00    	jb     8022e1 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802195:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802199:	75 14                	jne    8021af <insert_sorted_allocList+0x157>
  80219b:	83 ec 04             	sub    $0x4,%esp
  80219e:	68 ec 3f 80 00       	push   $0x803fec
  8021a3:	6a 73                	push   $0x73
  8021a5:	68 9b 3f 80 00       	push   $0x803f9b
  8021aa:	e8 c8 e0 ff ff       	call   800277 <_panic>
  8021af:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8021b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b8:	89 50 04             	mov    %edx,0x4(%eax)
  8021bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021be:	8b 40 04             	mov    0x4(%eax),%eax
  8021c1:	85 c0                	test   %eax,%eax
  8021c3:	74 0c                	je     8021d1 <insert_sorted_allocList+0x179>
  8021c5:	a1 44 50 80 00       	mov    0x805044,%eax
  8021ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8021cd:	89 10                	mov    %edx,(%eax)
  8021cf:	eb 08                	jmp    8021d9 <insert_sorted_allocList+0x181>
  8021d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d4:	a3 40 50 80 00       	mov    %eax,0x805040
  8021d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021dc:	a3 44 50 80 00       	mov    %eax,0x805044
  8021e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021ea:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8021ef:	40                   	inc    %eax
  8021f0:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8021f5:	e9 e7 00 00 00       	jmp    8022e1 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8021fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802200:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802207:	a1 40 50 80 00       	mov    0x805040,%eax
  80220c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80220f:	e9 9d 00 00 00       	jmp    8022b1 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802214:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802217:	8b 00                	mov    (%eax),%eax
  802219:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  80221c:	8b 45 08             	mov    0x8(%ebp),%eax
  80221f:	8b 50 08             	mov    0x8(%eax),%edx
  802222:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802225:	8b 40 08             	mov    0x8(%eax),%eax
  802228:	39 c2                	cmp    %eax,%edx
  80222a:	76 7d                	jbe    8022a9 <insert_sorted_allocList+0x251>
  80222c:	8b 45 08             	mov    0x8(%ebp),%eax
  80222f:	8b 50 08             	mov    0x8(%eax),%edx
  802232:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802235:	8b 40 08             	mov    0x8(%eax),%eax
  802238:	39 c2                	cmp    %eax,%edx
  80223a:	73 6d                	jae    8022a9 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  80223c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802240:	74 06                	je     802248 <insert_sorted_allocList+0x1f0>
  802242:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802246:	75 14                	jne    80225c <insert_sorted_allocList+0x204>
  802248:	83 ec 04             	sub    $0x4,%esp
  80224b:	68 10 40 80 00       	push   $0x804010
  802250:	6a 7f                	push   $0x7f
  802252:	68 9b 3f 80 00       	push   $0x803f9b
  802257:	e8 1b e0 ff ff       	call   800277 <_panic>
  80225c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225f:	8b 10                	mov    (%eax),%edx
  802261:	8b 45 08             	mov    0x8(%ebp),%eax
  802264:	89 10                	mov    %edx,(%eax)
  802266:	8b 45 08             	mov    0x8(%ebp),%eax
  802269:	8b 00                	mov    (%eax),%eax
  80226b:	85 c0                	test   %eax,%eax
  80226d:	74 0b                	je     80227a <insert_sorted_allocList+0x222>
  80226f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802272:	8b 00                	mov    (%eax),%eax
  802274:	8b 55 08             	mov    0x8(%ebp),%edx
  802277:	89 50 04             	mov    %edx,0x4(%eax)
  80227a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227d:	8b 55 08             	mov    0x8(%ebp),%edx
  802280:	89 10                	mov    %edx,(%eax)
  802282:	8b 45 08             	mov    0x8(%ebp),%eax
  802285:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802288:	89 50 04             	mov    %edx,0x4(%eax)
  80228b:	8b 45 08             	mov    0x8(%ebp),%eax
  80228e:	8b 00                	mov    (%eax),%eax
  802290:	85 c0                	test   %eax,%eax
  802292:	75 08                	jne    80229c <insert_sorted_allocList+0x244>
  802294:	8b 45 08             	mov    0x8(%ebp),%eax
  802297:	a3 44 50 80 00       	mov    %eax,0x805044
  80229c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8022a1:	40                   	inc    %eax
  8022a2:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8022a7:	eb 39                	jmp    8022e2 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8022a9:	a1 48 50 80 00       	mov    0x805048,%eax
  8022ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022b5:	74 07                	je     8022be <insert_sorted_allocList+0x266>
  8022b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ba:	8b 00                	mov    (%eax),%eax
  8022bc:	eb 05                	jmp    8022c3 <insert_sorted_allocList+0x26b>
  8022be:	b8 00 00 00 00       	mov    $0x0,%eax
  8022c3:	a3 48 50 80 00       	mov    %eax,0x805048
  8022c8:	a1 48 50 80 00       	mov    0x805048,%eax
  8022cd:	85 c0                	test   %eax,%eax
  8022cf:	0f 85 3f ff ff ff    	jne    802214 <insert_sorted_allocList+0x1bc>
  8022d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022d9:	0f 85 35 ff ff ff    	jne    802214 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8022df:	eb 01                	jmp    8022e2 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8022e1:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8022e2:	90                   	nop
  8022e3:	c9                   	leave  
  8022e4:	c3                   	ret    

008022e5 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8022e5:	55                   	push   %ebp
  8022e6:	89 e5                	mov    %esp,%ebp
  8022e8:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8022eb:	a1 38 51 80 00       	mov    0x805138,%eax
  8022f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022f3:	e9 85 01 00 00       	jmp    80247d <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8022f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022fb:	8b 40 0c             	mov    0xc(%eax),%eax
  8022fe:	3b 45 08             	cmp    0x8(%ebp),%eax
  802301:	0f 82 6e 01 00 00    	jb     802475 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802307:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230a:	8b 40 0c             	mov    0xc(%eax),%eax
  80230d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802310:	0f 85 8a 00 00 00    	jne    8023a0 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802316:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80231a:	75 17                	jne    802333 <alloc_block_FF+0x4e>
  80231c:	83 ec 04             	sub    $0x4,%esp
  80231f:	68 44 40 80 00       	push   $0x804044
  802324:	68 93 00 00 00       	push   $0x93
  802329:	68 9b 3f 80 00       	push   $0x803f9b
  80232e:	e8 44 df ff ff       	call   800277 <_panic>
  802333:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802336:	8b 00                	mov    (%eax),%eax
  802338:	85 c0                	test   %eax,%eax
  80233a:	74 10                	je     80234c <alloc_block_FF+0x67>
  80233c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233f:	8b 00                	mov    (%eax),%eax
  802341:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802344:	8b 52 04             	mov    0x4(%edx),%edx
  802347:	89 50 04             	mov    %edx,0x4(%eax)
  80234a:	eb 0b                	jmp    802357 <alloc_block_FF+0x72>
  80234c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234f:	8b 40 04             	mov    0x4(%eax),%eax
  802352:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802357:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235a:	8b 40 04             	mov    0x4(%eax),%eax
  80235d:	85 c0                	test   %eax,%eax
  80235f:	74 0f                	je     802370 <alloc_block_FF+0x8b>
  802361:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802364:	8b 40 04             	mov    0x4(%eax),%eax
  802367:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80236a:	8b 12                	mov    (%edx),%edx
  80236c:	89 10                	mov    %edx,(%eax)
  80236e:	eb 0a                	jmp    80237a <alloc_block_FF+0x95>
  802370:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802373:	8b 00                	mov    (%eax),%eax
  802375:	a3 38 51 80 00       	mov    %eax,0x805138
  80237a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802383:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802386:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80238d:	a1 44 51 80 00       	mov    0x805144,%eax
  802392:	48                   	dec    %eax
  802393:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802398:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239b:	e9 10 01 00 00       	jmp    8024b0 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8023a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a3:	8b 40 0c             	mov    0xc(%eax),%eax
  8023a6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023a9:	0f 86 c6 00 00 00    	jbe    802475 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8023af:	a1 48 51 80 00       	mov    0x805148,%eax
  8023b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8023b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ba:	8b 50 08             	mov    0x8(%eax),%edx
  8023bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023c0:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8023c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8023c9:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8023cc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023d0:	75 17                	jne    8023e9 <alloc_block_FF+0x104>
  8023d2:	83 ec 04             	sub    $0x4,%esp
  8023d5:	68 44 40 80 00       	push   $0x804044
  8023da:	68 9b 00 00 00       	push   $0x9b
  8023df:	68 9b 3f 80 00       	push   $0x803f9b
  8023e4:	e8 8e de ff ff       	call   800277 <_panic>
  8023e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ec:	8b 00                	mov    (%eax),%eax
  8023ee:	85 c0                	test   %eax,%eax
  8023f0:	74 10                	je     802402 <alloc_block_FF+0x11d>
  8023f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023f5:	8b 00                	mov    (%eax),%eax
  8023f7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023fa:	8b 52 04             	mov    0x4(%edx),%edx
  8023fd:	89 50 04             	mov    %edx,0x4(%eax)
  802400:	eb 0b                	jmp    80240d <alloc_block_FF+0x128>
  802402:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802405:	8b 40 04             	mov    0x4(%eax),%eax
  802408:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80240d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802410:	8b 40 04             	mov    0x4(%eax),%eax
  802413:	85 c0                	test   %eax,%eax
  802415:	74 0f                	je     802426 <alloc_block_FF+0x141>
  802417:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80241a:	8b 40 04             	mov    0x4(%eax),%eax
  80241d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802420:	8b 12                	mov    (%edx),%edx
  802422:	89 10                	mov    %edx,(%eax)
  802424:	eb 0a                	jmp    802430 <alloc_block_FF+0x14b>
  802426:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802429:	8b 00                	mov    (%eax),%eax
  80242b:	a3 48 51 80 00       	mov    %eax,0x805148
  802430:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802433:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802439:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80243c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802443:	a1 54 51 80 00       	mov    0x805154,%eax
  802448:	48                   	dec    %eax
  802449:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  80244e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802451:	8b 50 08             	mov    0x8(%eax),%edx
  802454:	8b 45 08             	mov    0x8(%ebp),%eax
  802457:	01 c2                	add    %eax,%edx
  802459:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245c:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  80245f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802462:	8b 40 0c             	mov    0xc(%eax),%eax
  802465:	2b 45 08             	sub    0x8(%ebp),%eax
  802468:	89 c2                	mov    %eax,%edx
  80246a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246d:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802470:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802473:	eb 3b                	jmp    8024b0 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802475:	a1 40 51 80 00       	mov    0x805140,%eax
  80247a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80247d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802481:	74 07                	je     80248a <alloc_block_FF+0x1a5>
  802483:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802486:	8b 00                	mov    (%eax),%eax
  802488:	eb 05                	jmp    80248f <alloc_block_FF+0x1aa>
  80248a:	b8 00 00 00 00       	mov    $0x0,%eax
  80248f:	a3 40 51 80 00       	mov    %eax,0x805140
  802494:	a1 40 51 80 00       	mov    0x805140,%eax
  802499:	85 c0                	test   %eax,%eax
  80249b:	0f 85 57 fe ff ff    	jne    8022f8 <alloc_block_FF+0x13>
  8024a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024a5:	0f 85 4d fe ff ff    	jne    8022f8 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8024ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024b0:	c9                   	leave  
  8024b1:	c3                   	ret    

008024b2 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8024b2:	55                   	push   %ebp
  8024b3:	89 e5                	mov    %esp,%ebp
  8024b5:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8024b8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8024bf:	a1 38 51 80 00       	mov    0x805138,%eax
  8024c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024c7:	e9 df 00 00 00       	jmp    8025ab <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8024cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cf:	8b 40 0c             	mov    0xc(%eax),%eax
  8024d2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024d5:	0f 82 c8 00 00 00    	jb     8025a3 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8024db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024de:	8b 40 0c             	mov    0xc(%eax),%eax
  8024e1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024e4:	0f 85 8a 00 00 00    	jne    802574 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8024ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024ee:	75 17                	jne    802507 <alloc_block_BF+0x55>
  8024f0:	83 ec 04             	sub    $0x4,%esp
  8024f3:	68 44 40 80 00       	push   $0x804044
  8024f8:	68 b7 00 00 00       	push   $0xb7
  8024fd:	68 9b 3f 80 00       	push   $0x803f9b
  802502:	e8 70 dd ff ff       	call   800277 <_panic>
  802507:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250a:	8b 00                	mov    (%eax),%eax
  80250c:	85 c0                	test   %eax,%eax
  80250e:	74 10                	je     802520 <alloc_block_BF+0x6e>
  802510:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802513:	8b 00                	mov    (%eax),%eax
  802515:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802518:	8b 52 04             	mov    0x4(%edx),%edx
  80251b:	89 50 04             	mov    %edx,0x4(%eax)
  80251e:	eb 0b                	jmp    80252b <alloc_block_BF+0x79>
  802520:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802523:	8b 40 04             	mov    0x4(%eax),%eax
  802526:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80252b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252e:	8b 40 04             	mov    0x4(%eax),%eax
  802531:	85 c0                	test   %eax,%eax
  802533:	74 0f                	je     802544 <alloc_block_BF+0x92>
  802535:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802538:	8b 40 04             	mov    0x4(%eax),%eax
  80253b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80253e:	8b 12                	mov    (%edx),%edx
  802540:	89 10                	mov    %edx,(%eax)
  802542:	eb 0a                	jmp    80254e <alloc_block_BF+0x9c>
  802544:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802547:	8b 00                	mov    (%eax),%eax
  802549:	a3 38 51 80 00       	mov    %eax,0x805138
  80254e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802551:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802557:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802561:	a1 44 51 80 00       	mov    0x805144,%eax
  802566:	48                   	dec    %eax
  802567:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  80256c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256f:	e9 4d 01 00 00       	jmp    8026c1 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802574:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802577:	8b 40 0c             	mov    0xc(%eax),%eax
  80257a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80257d:	76 24                	jbe    8025a3 <alloc_block_BF+0xf1>
  80257f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802582:	8b 40 0c             	mov    0xc(%eax),%eax
  802585:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802588:	73 19                	jae    8025a3 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  80258a:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802591:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802594:	8b 40 0c             	mov    0xc(%eax),%eax
  802597:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  80259a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259d:	8b 40 08             	mov    0x8(%eax),%eax
  8025a0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8025a3:	a1 40 51 80 00       	mov    0x805140,%eax
  8025a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025af:	74 07                	je     8025b8 <alloc_block_BF+0x106>
  8025b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b4:	8b 00                	mov    (%eax),%eax
  8025b6:	eb 05                	jmp    8025bd <alloc_block_BF+0x10b>
  8025b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8025bd:	a3 40 51 80 00       	mov    %eax,0x805140
  8025c2:	a1 40 51 80 00       	mov    0x805140,%eax
  8025c7:	85 c0                	test   %eax,%eax
  8025c9:	0f 85 fd fe ff ff    	jne    8024cc <alloc_block_BF+0x1a>
  8025cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025d3:	0f 85 f3 fe ff ff    	jne    8024cc <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8025d9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8025dd:	0f 84 d9 00 00 00    	je     8026bc <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8025e3:	a1 48 51 80 00       	mov    0x805148,%eax
  8025e8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8025eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025ee:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025f1:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8025f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025f7:	8b 55 08             	mov    0x8(%ebp),%edx
  8025fa:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8025fd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802601:	75 17                	jne    80261a <alloc_block_BF+0x168>
  802603:	83 ec 04             	sub    $0x4,%esp
  802606:	68 44 40 80 00       	push   $0x804044
  80260b:	68 c7 00 00 00       	push   $0xc7
  802610:	68 9b 3f 80 00       	push   $0x803f9b
  802615:	e8 5d dc ff ff       	call   800277 <_panic>
  80261a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80261d:	8b 00                	mov    (%eax),%eax
  80261f:	85 c0                	test   %eax,%eax
  802621:	74 10                	je     802633 <alloc_block_BF+0x181>
  802623:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802626:	8b 00                	mov    (%eax),%eax
  802628:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80262b:	8b 52 04             	mov    0x4(%edx),%edx
  80262e:	89 50 04             	mov    %edx,0x4(%eax)
  802631:	eb 0b                	jmp    80263e <alloc_block_BF+0x18c>
  802633:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802636:	8b 40 04             	mov    0x4(%eax),%eax
  802639:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80263e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802641:	8b 40 04             	mov    0x4(%eax),%eax
  802644:	85 c0                	test   %eax,%eax
  802646:	74 0f                	je     802657 <alloc_block_BF+0x1a5>
  802648:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80264b:	8b 40 04             	mov    0x4(%eax),%eax
  80264e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802651:	8b 12                	mov    (%edx),%edx
  802653:	89 10                	mov    %edx,(%eax)
  802655:	eb 0a                	jmp    802661 <alloc_block_BF+0x1af>
  802657:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80265a:	8b 00                	mov    (%eax),%eax
  80265c:	a3 48 51 80 00       	mov    %eax,0x805148
  802661:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802664:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80266a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80266d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802674:	a1 54 51 80 00       	mov    0x805154,%eax
  802679:	48                   	dec    %eax
  80267a:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  80267f:	83 ec 08             	sub    $0x8,%esp
  802682:	ff 75 ec             	pushl  -0x14(%ebp)
  802685:	68 38 51 80 00       	push   $0x805138
  80268a:	e8 71 f9 ff ff       	call   802000 <find_block>
  80268f:	83 c4 10             	add    $0x10,%esp
  802692:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802695:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802698:	8b 50 08             	mov    0x8(%eax),%edx
  80269b:	8b 45 08             	mov    0x8(%ebp),%eax
  80269e:	01 c2                	add    %eax,%edx
  8026a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026a3:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8026a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8026ac:	2b 45 08             	sub    0x8(%ebp),%eax
  8026af:	89 c2                	mov    %eax,%edx
  8026b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026b4:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8026b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026ba:	eb 05                	jmp    8026c1 <alloc_block_BF+0x20f>
	}
	return NULL;
  8026bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026c1:	c9                   	leave  
  8026c2:	c3                   	ret    

008026c3 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8026c3:	55                   	push   %ebp
  8026c4:	89 e5                	mov    %esp,%ebp
  8026c6:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8026c9:	a1 28 50 80 00       	mov    0x805028,%eax
  8026ce:	85 c0                	test   %eax,%eax
  8026d0:	0f 85 de 01 00 00    	jne    8028b4 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8026d6:	a1 38 51 80 00       	mov    0x805138,%eax
  8026db:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026de:	e9 9e 01 00 00       	jmp    802881 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8026e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e6:	8b 40 0c             	mov    0xc(%eax),%eax
  8026e9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026ec:	0f 82 87 01 00 00    	jb     802879 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8026f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f5:	8b 40 0c             	mov    0xc(%eax),%eax
  8026f8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026fb:	0f 85 95 00 00 00    	jne    802796 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802701:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802705:	75 17                	jne    80271e <alloc_block_NF+0x5b>
  802707:	83 ec 04             	sub    $0x4,%esp
  80270a:	68 44 40 80 00       	push   $0x804044
  80270f:	68 e0 00 00 00       	push   $0xe0
  802714:	68 9b 3f 80 00       	push   $0x803f9b
  802719:	e8 59 db ff ff       	call   800277 <_panic>
  80271e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802721:	8b 00                	mov    (%eax),%eax
  802723:	85 c0                	test   %eax,%eax
  802725:	74 10                	je     802737 <alloc_block_NF+0x74>
  802727:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272a:	8b 00                	mov    (%eax),%eax
  80272c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80272f:	8b 52 04             	mov    0x4(%edx),%edx
  802732:	89 50 04             	mov    %edx,0x4(%eax)
  802735:	eb 0b                	jmp    802742 <alloc_block_NF+0x7f>
  802737:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273a:	8b 40 04             	mov    0x4(%eax),%eax
  80273d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802742:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802745:	8b 40 04             	mov    0x4(%eax),%eax
  802748:	85 c0                	test   %eax,%eax
  80274a:	74 0f                	je     80275b <alloc_block_NF+0x98>
  80274c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274f:	8b 40 04             	mov    0x4(%eax),%eax
  802752:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802755:	8b 12                	mov    (%edx),%edx
  802757:	89 10                	mov    %edx,(%eax)
  802759:	eb 0a                	jmp    802765 <alloc_block_NF+0xa2>
  80275b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275e:	8b 00                	mov    (%eax),%eax
  802760:	a3 38 51 80 00       	mov    %eax,0x805138
  802765:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802768:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80276e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802771:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802778:	a1 44 51 80 00       	mov    0x805144,%eax
  80277d:	48                   	dec    %eax
  80277e:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802783:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802786:	8b 40 08             	mov    0x8(%eax),%eax
  802789:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  80278e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802791:	e9 f8 04 00 00       	jmp    802c8e <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802796:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802799:	8b 40 0c             	mov    0xc(%eax),%eax
  80279c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80279f:	0f 86 d4 00 00 00    	jbe    802879 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8027a5:	a1 48 51 80 00       	mov    0x805148,%eax
  8027aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8027ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b0:	8b 50 08             	mov    0x8(%eax),%edx
  8027b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027b6:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8027b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8027bf:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8027c2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027c6:	75 17                	jne    8027df <alloc_block_NF+0x11c>
  8027c8:	83 ec 04             	sub    $0x4,%esp
  8027cb:	68 44 40 80 00       	push   $0x804044
  8027d0:	68 e9 00 00 00       	push   $0xe9
  8027d5:	68 9b 3f 80 00       	push   $0x803f9b
  8027da:	e8 98 da ff ff       	call   800277 <_panic>
  8027df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e2:	8b 00                	mov    (%eax),%eax
  8027e4:	85 c0                	test   %eax,%eax
  8027e6:	74 10                	je     8027f8 <alloc_block_NF+0x135>
  8027e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027eb:	8b 00                	mov    (%eax),%eax
  8027ed:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027f0:	8b 52 04             	mov    0x4(%edx),%edx
  8027f3:	89 50 04             	mov    %edx,0x4(%eax)
  8027f6:	eb 0b                	jmp    802803 <alloc_block_NF+0x140>
  8027f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027fb:	8b 40 04             	mov    0x4(%eax),%eax
  8027fe:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802803:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802806:	8b 40 04             	mov    0x4(%eax),%eax
  802809:	85 c0                	test   %eax,%eax
  80280b:	74 0f                	je     80281c <alloc_block_NF+0x159>
  80280d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802810:	8b 40 04             	mov    0x4(%eax),%eax
  802813:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802816:	8b 12                	mov    (%edx),%edx
  802818:	89 10                	mov    %edx,(%eax)
  80281a:	eb 0a                	jmp    802826 <alloc_block_NF+0x163>
  80281c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80281f:	8b 00                	mov    (%eax),%eax
  802821:	a3 48 51 80 00       	mov    %eax,0x805148
  802826:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802829:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80282f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802832:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802839:	a1 54 51 80 00       	mov    0x805154,%eax
  80283e:	48                   	dec    %eax
  80283f:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802844:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802847:	8b 40 08             	mov    0x8(%eax),%eax
  80284a:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  80284f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802852:	8b 50 08             	mov    0x8(%eax),%edx
  802855:	8b 45 08             	mov    0x8(%ebp),%eax
  802858:	01 c2                	add    %eax,%edx
  80285a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285d:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802860:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802863:	8b 40 0c             	mov    0xc(%eax),%eax
  802866:	2b 45 08             	sub    0x8(%ebp),%eax
  802869:	89 c2                	mov    %eax,%edx
  80286b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286e:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802871:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802874:	e9 15 04 00 00       	jmp    802c8e <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802879:	a1 40 51 80 00       	mov    0x805140,%eax
  80287e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802881:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802885:	74 07                	je     80288e <alloc_block_NF+0x1cb>
  802887:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288a:	8b 00                	mov    (%eax),%eax
  80288c:	eb 05                	jmp    802893 <alloc_block_NF+0x1d0>
  80288e:	b8 00 00 00 00       	mov    $0x0,%eax
  802893:	a3 40 51 80 00       	mov    %eax,0x805140
  802898:	a1 40 51 80 00       	mov    0x805140,%eax
  80289d:	85 c0                	test   %eax,%eax
  80289f:	0f 85 3e fe ff ff    	jne    8026e3 <alloc_block_NF+0x20>
  8028a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028a9:	0f 85 34 fe ff ff    	jne    8026e3 <alloc_block_NF+0x20>
  8028af:	e9 d5 03 00 00       	jmp    802c89 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8028b4:	a1 38 51 80 00       	mov    0x805138,%eax
  8028b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028bc:	e9 b1 01 00 00       	jmp    802a72 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8028c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c4:	8b 50 08             	mov    0x8(%eax),%edx
  8028c7:	a1 28 50 80 00       	mov    0x805028,%eax
  8028cc:	39 c2                	cmp    %eax,%edx
  8028ce:	0f 82 96 01 00 00    	jb     802a6a <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  8028d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d7:	8b 40 0c             	mov    0xc(%eax),%eax
  8028da:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028dd:	0f 82 87 01 00 00    	jb     802a6a <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  8028e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e6:	8b 40 0c             	mov    0xc(%eax),%eax
  8028e9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028ec:	0f 85 95 00 00 00    	jne    802987 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8028f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028f6:	75 17                	jne    80290f <alloc_block_NF+0x24c>
  8028f8:	83 ec 04             	sub    $0x4,%esp
  8028fb:	68 44 40 80 00       	push   $0x804044
  802900:	68 fc 00 00 00       	push   $0xfc
  802905:	68 9b 3f 80 00       	push   $0x803f9b
  80290a:	e8 68 d9 ff ff       	call   800277 <_panic>
  80290f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802912:	8b 00                	mov    (%eax),%eax
  802914:	85 c0                	test   %eax,%eax
  802916:	74 10                	je     802928 <alloc_block_NF+0x265>
  802918:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291b:	8b 00                	mov    (%eax),%eax
  80291d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802920:	8b 52 04             	mov    0x4(%edx),%edx
  802923:	89 50 04             	mov    %edx,0x4(%eax)
  802926:	eb 0b                	jmp    802933 <alloc_block_NF+0x270>
  802928:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292b:	8b 40 04             	mov    0x4(%eax),%eax
  80292e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802933:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802936:	8b 40 04             	mov    0x4(%eax),%eax
  802939:	85 c0                	test   %eax,%eax
  80293b:	74 0f                	je     80294c <alloc_block_NF+0x289>
  80293d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802940:	8b 40 04             	mov    0x4(%eax),%eax
  802943:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802946:	8b 12                	mov    (%edx),%edx
  802948:	89 10                	mov    %edx,(%eax)
  80294a:	eb 0a                	jmp    802956 <alloc_block_NF+0x293>
  80294c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294f:	8b 00                	mov    (%eax),%eax
  802951:	a3 38 51 80 00       	mov    %eax,0x805138
  802956:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802959:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80295f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802962:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802969:	a1 44 51 80 00       	mov    0x805144,%eax
  80296e:	48                   	dec    %eax
  80296f:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802974:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802977:	8b 40 08             	mov    0x8(%eax),%eax
  80297a:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  80297f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802982:	e9 07 03 00 00       	jmp    802c8e <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802987:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298a:	8b 40 0c             	mov    0xc(%eax),%eax
  80298d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802990:	0f 86 d4 00 00 00    	jbe    802a6a <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802996:	a1 48 51 80 00       	mov    0x805148,%eax
  80299b:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  80299e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a1:	8b 50 08             	mov    0x8(%eax),%edx
  8029a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029a7:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8029aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8029b0:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8029b3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8029b7:	75 17                	jne    8029d0 <alloc_block_NF+0x30d>
  8029b9:	83 ec 04             	sub    $0x4,%esp
  8029bc:	68 44 40 80 00       	push   $0x804044
  8029c1:	68 04 01 00 00       	push   $0x104
  8029c6:	68 9b 3f 80 00       	push   $0x803f9b
  8029cb:	e8 a7 d8 ff ff       	call   800277 <_panic>
  8029d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029d3:	8b 00                	mov    (%eax),%eax
  8029d5:	85 c0                	test   %eax,%eax
  8029d7:	74 10                	je     8029e9 <alloc_block_NF+0x326>
  8029d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029dc:	8b 00                	mov    (%eax),%eax
  8029de:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8029e1:	8b 52 04             	mov    0x4(%edx),%edx
  8029e4:	89 50 04             	mov    %edx,0x4(%eax)
  8029e7:	eb 0b                	jmp    8029f4 <alloc_block_NF+0x331>
  8029e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029ec:	8b 40 04             	mov    0x4(%eax),%eax
  8029ef:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8029f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029f7:	8b 40 04             	mov    0x4(%eax),%eax
  8029fa:	85 c0                	test   %eax,%eax
  8029fc:	74 0f                	je     802a0d <alloc_block_NF+0x34a>
  8029fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a01:	8b 40 04             	mov    0x4(%eax),%eax
  802a04:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a07:	8b 12                	mov    (%edx),%edx
  802a09:	89 10                	mov    %edx,(%eax)
  802a0b:	eb 0a                	jmp    802a17 <alloc_block_NF+0x354>
  802a0d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a10:	8b 00                	mov    (%eax),%eax
  802a12:	a3 48 51 80 00       	mov    %eax,0x805148
  802a17:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a1a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a20:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a23:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a2a:	a1 54 51 80 00       	mov    0x805154,%eax
  802a2f:	48                   	dec    %eax
  802a30:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802a35:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a38:	8b 40 08             	mov    0x8(%eax),%eax
  802a3b:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802a40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a43:	8b 50 08             	mov    0x8(%eax),%edx
  802a46:	8b 45 08             	mov    0x8(%ebp),%eax
  802a49:	01 c2                	add    %eax,%edx
  802a4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4e:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802a51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a54:	8b 40 0c             	mov    0xc(%eax),%eax
  802a57:	2b 45 08             	sub    0x8(%ebp),%eax
  802a5a:	89 c2                	mov    %eax,%edx
  802a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5f:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802a62:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a65:	e9 24 02 00 00       	jmp    802c8e <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a6a:	a1 40 51 80 00       	mov    0x805140,%eax
  802a6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a72:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a76:	74 07                	je     802a7f <alloc_block_NF+0x3bc>
  802a78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7b:	8b 00                	mov    (%eax),%eax
  802a7d:	eb 05                	jmp    802a84 <alloc_block_NF+0x3c1>
  802a7f:	b8 00 00 00 00       	mov    $0x0,%eax
  802a84:	a3 40 51 80 00       	mov    %eax,0x805140
  802a89:	a1 40 51 80 00       	mov    0x805140,%eax
  802a8e:	85 c0                	test   %eax,%eax
  802a90:	0f 85 2b fe ff ff    	jne    8028c1 <alloc_block_NF+0x1fe>
  802a96:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a9a:	0f 85 21 fe ff ff    	jne    8028c1 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802aa0:	a1 38 51 80 00       	mov    0x805138,%eax
  802aa5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802aa8:	e9 ae 01 00 00       	jmp    802c5b <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802aad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab0:	8b 50 08             	mov    0x8(%eax),%edx
  802ab3:	a1 28 50 80 00       	mov    0x805028,%eax
  802ab8:	39 c2                	cmp    %eax,%edx
  802aba:	0f 83 93 01 00 00    	jae    802c53 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802ac0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac3:	8b 40 0c             	mov    0xc(%eax),%eax
  802ac6:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ac9:	0f 82 84 01 00 00    	jb     802c53 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802acf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad2:	8b 40 0c             	mov    0xc(%eax),%eax
  802ad5:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ad8:	0f 85 95 00 00 00    	jne    802b73 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802ade:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ae2:	75 17                	jne    802afb <alloc_block_NF+0x438>
  802ae4:	83 ec 04             	sub    $0x4,%esp
  802ae7:	68 44 40 80 00       	push   $0x804044
  802aec:	68 14 01 00 00       	push   $0x114
  802af1:	68 9b 3f 80 00       	push   $0x803f9b
  802af6:	e8 7c d7 ff ff       	call   800277 <_panic>
  802afb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afe:	8b 00                	mov    (%eax),%eax
  802b00:	85 c0                	test   %eax,%eax
  802b02:	74 10                	je     802b14 <alloc_block_NF+0x451>
  802b04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b07:	8b 00                	mov    (%eax),%eax
  802b09:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b0c:	8b 52 04             	mov    0x4(%edx),%edx
  802b0f:	89 50 04             	mov    %edx,0x4(%eax)
  802b12:	eb 0b                	jmp    802b1f <alloc_block_NF+0x45c>
  802b14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b17:	8b 40 04             	mov    0x4(%eax),%eax
  802b1a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b22:	8b 40 04             	mov    0x4(%eax),%eax
  802b25:	85 c0                	test   %eax,%eax
  802b27:	74 0f                	je     802b38 <alloc_block_NF+0x475>
  802b29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2c:	8b 40 04             	mov    0x4(%eax),%eax
  802b2f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b32:	8b 12                	mov    (%edx),%edx
  802b34:	89 10                	mov    %edx,(%eax)
  802b36:	eb 0a                	jmp    802b42 <alloc_block_NF+0x47f>
  802b38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3b:	8b 00                	mov    (%eax),%eax
  802b3d:	a3 38 51 80 00       	mov    %eax,0x805138
  802b42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b45:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b55:	a1 44 51 80 00       	mov    0x805144,%eax
  802b5a:	48                   	dec    %eax
  802b5b:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802b60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b63:	8b 40 08             	mov    0x8(%eax),%eax
  802b66:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802b6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6e:	e9 1b 01 00 00       	jmp    802c8e <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802b73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b76:	8b 40 0c             	mov    0xc(%eax),%eax
  802b79:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b7c:	0f 86 d1 00 00 00    	jbe    802c53 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b82:	a1 48 51 80 00       	mov    0x805148,%eax
  802b87:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802b8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8d:	8b 50 08             	mov    0x8(%eax),%edx
  802b90:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b93:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802b96:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b99:	8b 55 08             	mov    0x8(%ebp),%edx
  802b9c:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b9f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802ba3:	75 17                	jne    802bbc <alloc_block_NF+0x4f9>
  802ba5:	83 ec 04             	sub    $0x4,%esp
  802ba8:	68 44 40 80 00       	push   $0x804044
  802bad:	68 1c 01 00 00       	push   $0x11c
  802bb2:	68 9b 3f 80 00       	push   $0x803f9b
  802bb7:	e8 bb d6 ff ff       	call   800277 <_panic>
  802bbc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bbf:	8b 00                	mov    (%eax),%eax
  802bc1:	85 c0                	test   %eax,%eax
  802bc3:	74 10                	je     802bd5 <alloc_block_NF+0x512>
  802bc5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bc8:	8b 00                	mov    (%eax),%eax
  802bca:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802bcd:	8b 52 04             	mov    0x4(%edx),%edx
  802bd0:	89 50 04             	mov    %edx,0x4(%eax)
  802bd3:	eb 0b                	jmp    802be0 <alloc_block_NF+0x51d>
  802bd5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bd8:	8b 40 04             	mov    0x4(%eax),%eax
  802bdb:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802be0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802be3:	8b 40 04             	mov    0x4(%eax),%eax
  802be6:	85 c0                	test   %eax,%eax
  802be8:	74 0f                	je     802bf9 <alloc_block_NF+0x536>
  802bea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bed:	8b 40 04             	mov    0x4(%eax),%eax
  802bf0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802bf3:	8b 12                	mov    (%edx),%edx
  802bf5:	89 10                	mov    %edx,(%eax)
  802bf7:	eb 0a                	jmp    802c03 <alloc_block_NF+0x540>
  802bf9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bfc:	8b 00                	mov    (%eax),%eax
  802bfe:	a3 48 51 80 00       	mov    %eax,0x805148
  802c03:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c06:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c0f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c16:	a1 54 51 80 00       	mov    0x805154,%eax
  802c1b:	48                   	dec    %eax
  802c1c:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802c21:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c24:	8b 40 08             	mov    0x8(%eax),%eax
  802c27:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802c2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2f:	8b 50 08             	mov    0x8(%eax),%edx
  802c32:	8b 45 08             	mov    0x8(%ebp),%eax
  802c35:	01 c2                	add    %eax,%edx
  802c37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3a:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802c3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c40:	8b 40 0c             	mov    0xc(%eax),%eax
  802c43:	2b 45 08             	sub    0x8(%ebp),%eax
  802c46:	89 c2                	mov    %eax,%edx
  802c48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4b:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802c4e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c51:	eb 3b                	jmp    802c8e <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c53:	a1 40 51 80 00       	mov    0x805140,%eax
  802c58:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c5b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c5f:	74 07                	je     802c68 <alloc_block_NF+0x5a5>
  802c61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c64:	8b 00                	mov    (%eax),%eax
  802c66:	eb 05                	jmp    802c6d <alloc_block_NF+0x5aa>
  802c68:	b8 00 00 00 00       	mov    $0x0,%eax
  802c6d:	a3 40 51 80 00       	mov    %eax,0x805140
  802c72:	a1 40 51 80 00       	mov    0x805140,%eax
  802c77:	85 c0                	test   %eax,%eax
  802c79:	0f 85 2e fe ff ff    	jne    802aad <alloc_block_NF+0x3ea>
  802c7f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c83:	0f 85 24 fe ff ff    	jne    802aad <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802c89:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c8e:	c9                   	leave  
  802c8f:	c3                   	ret    

00802c90 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802c90:	55                   	push   %ebp
  802c91:	89 e5                	mov    %esp,%ebp
  802c93:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802c96:	a1 38 51 80 00       	mov    0x805138,%eax
  802c9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802c9e:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802ca3:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802ca6:	a1 38 51 80 00       	mov    0x805138,%eax
  802cab:	85 c0                	test   %eax,%eax
  802cad:	74 14                	je     802cc3 <insert_sorted_with_merge_freeList+0x33>
  802caf:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb2:	8b 50 08             	mov    0x8(%eax),%edx
  802cb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb8:	8b 40 08             	mov    0x8(%eax),%eax
  802cbb:	39 c2                	cmp    %eax,%edx
  802cbd:	0f 87 9b 01 00 00    	ja     802e5e <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802cc3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cc7:	75 17                	jne    802ce0 <insert_sorted_with_merge_freeList+0x50>
  802cc9:	83 ec 04             	sub    $0x4,%esp
  802ccc:	68 78 3f 80 00       	push   $0x803f78
  802cd1:	68 38 01 00 00       	push   $0x138
  802cd6:	68 9b 3f 80 00       	push   $0x803f9b
  802cdb:	e8 97 d5 ff ff       	call   800277 <_panic>
  802ce0:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce9:	89 10                	mov    %edx,(%eax)
  802ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cee:	8b 00                	mov    (%eax),%eax
  802cf0:	85 c0                	test   %eax,%eax
  802cf2:	74 0d                	je     802d01 <insert_sorted_with_merge_freeList+0x71>
  802cf4:	a1 38 51 80 00       	mov    0x805138,%eax
  802cf9:	8b 55 08             	mov    0x8(%ebp),%edx
  802cfc:	89 50 04             	mov    %edx,0x4(%eax)
  802cff:	eb 08                	jmp    802d09 <insert_sorted_with_merge_freeList+0x79>
  802d01:	8b 45 08             	mov    0x8(%ebp),%eax
  802d04:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d09:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0c:	a3 38 51 80 00       	mov    %eax,0x805138
  802d11:	8b 45 08             	mov    0x8(%ebp),%eax
  802d14:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d1b:	a1 44 51 80 00       	mov    0x805144,%eax
  802d20:	40                   	inc    %eax
  802d21:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802d26:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d2a:	0f 84 a8 06 00 00    	je     8033d8 <insert_sorted_with_merge_freeList+0x748>
  802d30:	8b 45 08             	mov    0x8(%ebp),%eax
  802d33:	8b 50 08             	mov    0x8(%eax),%edx
  802d36:	8b 45 08             	mov    0x8(%ebp),%eax
  802d39:	8b 40 0c             	mov    0xc(%eax),%eax
  802d3c:	01 c2                	add    %eax,%edx
  802d3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d41:	8b 40 08             	mov    0x8(%eax),%eax
  802d44:	39 c2                	cmp    %eax,%edx
  802d46:	0f 85 8c 06 00 00    	jne    8033d8 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4f:	8b 50 0c             	mov    0xc(%eax),%edx
  802d52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d55:	8b 40 0c             	mov    0xc(%eax),%eax
  802d58:	01 c2                	add    %eax,%edx
  802d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5d:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802d60:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d64:	75 17                	jne    802d7d <insert_sorted_with_merge_freeList+0xed>
  802d66:	83 ec 04             	sub    $0x4,%esp
  802d69:	68 44 40 80 00       	push   $0x804044
  802d6e:	68 3c 01 00 00       	push   $0x13c
  802d73:	68 9b 3f 80 00       	push   $0x803f9b
  802d78:	e8 fa d4 ff ff       	call   800277 <_panic>
  802d7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d80:	8b 00                	mov    (%eax),%eax
  802d82:	85 c0                	test   %eax,%eax
  802d84:	74 10                	je     802d96 <insert_sorted_with_merge_freeList+0x106>
  802d86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d89:	8b 00                	mov    (%eax),%eax
  802d8b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d8e:	8b 52 04             	mov    0x4(%edx),%edx
  802d91:	89 50 04             	mov    %edx,0x4(%eax)
  802d94:	eb 0b                	jmp    802da1 <insert_sorted_with_merge_freeList+0x111>
  802d96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d99:	8b 40 04             	mov    0x4(%eax),%eax
  802d9c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802da1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da4:	8b 40 04             	mov    0x4(%eax),%eax
  802da7:	85 c0                	test   %eax,%eax
  802da9:	74 0f                	je     802dba <insert_sorted_with_merge_freeList+0x12a>
  802dab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dae:	8b 40 04             	mov    0x4(%eax),%eax
  802db1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802db4:	8b 12                	mov    (%edx),%edx
  802db6:	89 10                	mov    %edx,(%eax)
  802db8:	eb 0a                	jmp    802dc4 <insert_sorted_with_merge_freeList+0x134>
  802dba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dbd:	8b 00                	mov    (%eax),%eax
  802dbf:	a3 38 51 80 00       	mov    %eax,0x805138
  802dc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dd0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dd7:	a1 44 51 80 00       	mov    0x805144,%eax
  802ddc:	48                   	dec    %eax
  802ddd:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802de2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802dec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802def:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802df6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802dfa:	75 17                	jne    802e13 <insert_sorted_with_merge_freeList+0x183>
  802dfc:	83 ec 04             	sub    $0x4,%esp
  802dff:	68 78 3f 80 00       	push   $0x803f78
  802e04:	68 3f 01 00 00       	push   $0x13f
  802e09:	68 9b 3f 80 00       	push   $0x803f9b
  802e0e:	e8 64 d4 ff ff       	call   800277 <_panic>
  802e13:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802e19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e1c:	89 10                	mov    %edx,(%eax)
  802e1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e21:	8b 00                	mov    (%eax),%eax
  802e23:	85 c0                	test   %eax,%eax
  802e25:	74 0d                	je     802e34 <insert_sorted_with_merge_freeList+0x1a4>
  802e27:	a1 48 51 80 00       	mov    0x805148,%eax
  802e2c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e2f:	89 50 04             	mov    %edx,0x4(%eax)
  802e32:	eb 08                	jmp    802e3c <insert_sorted_with_merge_freeList+0x1ac>
  802e34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e37:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e3f:	a3 48 51 80 00       	mov    %eax,0x805148
  802e44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e47:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e4e:	a1 54 51 80 00       	mov    0x805154,%eax
  802e53:	40                   	inc    %eax
  802e54:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802e59:	e9 7a 05 00 00       	jmp    8033d8 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e61:	8b 50 08             	mov    0x8(%eax),%edx
  802e64:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e67:	8b 40 08             	mov    0x8(%eax),%eax
  802e6a:	39 c2                	cmp    %eax,%edx
  802e6c:	0f 82 14 01 00 00    	jb     802f86 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802e72:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e75:	8b 50 08             	mov    0x8(%eax),%edx
  802e78:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e7b:	8b 40 0c             	mov    0xc(%eax),%eax
  802e7e:	01 c2                	add    %eax,%edx
  802e80:	8b 45 08             	mov    0x8(%ebp),%eax
  802e83:	8b 40 08             	mov    0x8(%eax),%eax
  802e86:	39 c2                	cmp    %eax,%edx
  802e88:	0f 85 90 00 00 00    	jne    802f1e <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802e8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e91:	8b 50 0c             	mov    0xc(%eax),%edx
  802e94:	8b 45 08             	mov    0x8(%ebp),%eax
  802e97:	8b 40 0c             	mov    0xc(%eax),%eax
  802e9a:	01 c2                	add    %eax,%edx
  802e9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e9f:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802ea2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802eac:	8b 45 08             	mov    0x8(%ebp),%eax
  802eaf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802eb6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802eba:	75 17                	jne    802ed3 <insert_sorted_with_merge_freeList+0x243>
  802ebc:	83 ec 04             	sub    $0x4,%esp
  802ebf:	68 78 3f 80 00       	push   $0x803f78
  802ec4:	68 49 01 00 00       	push   $0x149
  802ec9:	68 9b 3f 80 00       	push   $0x803f9b
  802ece:	e8 a4 d3 ff ff       	call   800277 <_panic>
  802ed3:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  802edc:	89 10                	mov    %edx,(%eax)
  802ede:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee1:	8b 00                	mov    (%eax),%eax
  802ee3:	85 c0                	test   %eax,%eax
  802ee5:	74 0d                	je     802ef4 <insert_sorted_with_merge_freeList+0x264>
  802ee7:	a1 48 51 80 00       	mov    0x805148,%eax
  802eec:	8b 55 08             	mov    0x8(%ebp),%edx
  802eef:	89 50 04             	mov    %edx,0x4(%eax)
  802ef2:	eb 08                	jmp    802efc <insert_sorted_with_merge_freeList+0x26c>
  802ef4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802efc:	8b 45 08             	mov    0x8(%ebp),%eax
  802eff:	a3 48 51 80 00       	mov    %eax,0x805148
  802f04:	8b 45 08             	mov    0x8(%ebp),%eax
  802f07:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f0e:	a1 54 51 80 00       	mov    0x805154,%eax
  802f13:	40                   	inc    %eax
  802f14:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802f19:	e9 bb 04 00 00       	jmp    8033d9 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802f1e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f22:	75 17                	jne    802f3b <insert_sorted_with_merge_freeList+0x2ab>
  802f24:	83 ec 04             	sub    $0x4,%esp
  802f27:	68 ec 3f 80 00       	push   $0x803fec
  802f2c:	68 4c 01 00 00       	push   $0x14c
  802f31:	68 9b 3f 80 00       	push   $0x803f9b
  802f36:	e8 3c d3 ff ff       	call   800277 <_panic>
  802f3b:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802f41:	8b 45 08             	mov    0x8(%ebp),%eax
  802f44:	89 50 04             	mov    %edx,0x4(%eax)
  802f47:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4a:	8b 40 04             	mov    0x4(%eax),%eax
  802f4d:	85 c0                	test   %eax,%eax
  802f4f:	74 0c                	je     802f5d <insert_sorted_with_merge_freeList+0x2cd>
  802f51:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f56:	8b 55 08             	mov    0x8(%ebp),%edx
  802f59:	89 10                	mov    %edx,(%eax)
  802f5b:	eb 08                	jmp    802f65 <insert_sorted_with_merge_freeList+0x2d5>
  802f5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f60:	a3 38 51 80 00       	mov    %eax,0x805138
  802f65:	8b 45 08             	mov    0x8(%ebp),%eax
  802f68:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f70:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f76:	a1 44 51 80 00       	mov    0x805144,%eax
  802f7b:	40                   	inc    %eax
  802f7c:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802f81:	e9 53 04 00 00       	jmp    8033d9 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802f86:	a1 38 51 80 00       	mov    0x805138,%eax
  802f8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f8e:	e9 15 04 00 00       	jmp    8033a8 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802f93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f96:	8b 00                	mov    (%eax),%eax
  802f98:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9e:	8b 50 08             	mov    0x8(%eax),%edx
  802fa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa4:	8b 40 08             	mov    0x8(%eax),%eax
  802fa7:	39 c2                	cmp    %eax,%edx
  802fa9:	0f 86 f1 03 00 00    	jbe    8033a0 <insert_sorted_with_merge_freeList+0x710>
  802faf:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb2:	8b 50 08             	mov    0x8(%eax),%edx
  802fb5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fb8:	8b 40 08             	mov    0x8(%eax),%eax
  802fbb:	39 c2                	cmp    %eax,%edx
  802fbd:	0f 83 dd 03 00 00    	jae    8033a0 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802fc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc6:	8b 50 08             	mov    0x8(%eax),%edx
  802fc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fcc:	8b 40 0c             	mov    0xc(%eax),%eax
  802fcf:	01 c2                	add    %eax,%edx
  802fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd4:	8b 40 08             	mov    0x8(%eax),%eax
  802fd7:	39 c2                	cmp    %eax,%edx
  802fd9:	0f 85 b9 01 00 00    	jne    803198 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802fdf:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe2:	8b 50 08             	mov    0x8(%eax),%edx
  802fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe8:	8b 40 0c             	mov    0xc(%eax),%eax
  802feb:	01 c2                	add    %eax,%edx
  802fed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ff0:	8b 40 08             	mov    0x8(%eax),%eax
  802ff3:	39 c2                	cmp    %eax,%edx
  802ff5:	0f 85 0d 01 00 00    	jne    803108 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802ffb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ffe:	8b 50 0c             	mov    0xc(%eax),%edx
  803001:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803004:	8b 40 0c             	mov    0xc(%eax),%eax
  803007:	01 c2                	add    %eax,%edx
  803009:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300c:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80300f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803013:	75 17                	jne    80302c <insert_sorted_with_merge_freeList+0x39c>
  803015:	83 ec 04             	sub    $0x4,%esp
  803018:	68 44 40 80 00       	push   $0x804044
  80301d:	68 5c 01 00 00       	push   $0x15c
  803022:	68 9b 3f 80 00       	push   $0x803f9b
  803027:	e8 4b d2 ff ff       	call   800277 <_panic>
  80302c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80302f:	8b 00                	mov    (%eax),%eax
  803031:	85 c0                	test   %eax,%eax
  803033:	74 10                	je     803045 <insert_sorted_with_merge_freeList+0x3b5>
  803035:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803038:	8b 00                	mov    (%eax),%eax
  80303a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80303d:	8b 52 04             	mov    0x4(%edx),%edx
  803040:	89 50 04             	mov    %edx,0x4(%eax)
  803043:	eb 0b                	jmp    803050 <insert_sorted_with_merge_freeList+0x3c0>
  803045:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803048:	8b 40 04             	mov    0x4(%eax),%eax
  80304b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803050:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803053:	8b 40 04             	mov    0x4(%eax),%eax
  803056:	85 c0                	test   %eax,%eax
  803058:	74 0f                	je     803069 <insert_sorted_with_merge_freeList+0x3d9>
  80305a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80305d:	8b 40 04             	mov    0x4(%eax),%eax
  803060:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803063:	8b 12                	mov    (%edx),%edx
  803065:	89 10                	mov    %edx,(%eax)
  803067:	eb 0a                	jmp    803073 <insert_sorted_with_merge_freeList+0x3e3>
  803069:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80306c:	8b 00                	mov    (%eax),%eax
  80306e:	a3 38 51 80 00       	mov    %eax,0x805138
  803073:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803076:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80307c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80307f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803086:	a1 44 51 80 00       	mov    0x805144,%eax
  80308b:	48                   	dec    %eax
  80308c:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803091:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803094:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  80309b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80309e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8030a5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030a9:	75 17                	jne    8030c2 <insert_sorted_with_merge_freeList+0x432>
  8030ab:	83 ec 04             	sub    $0x4,%esp
  8030ae:	68 78 3f 80 00       	push   $0x803f78
  8030b3:	68 5f 01 00 00       	push   $0x15f
  8030b8:	68 9b 3f 80 00       	push   $0x803f9b
  8030bd:	e8 b5 d1 ff ff       	call   800277 <_panic>
  8030c2:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8030c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030cb:	89 10                	mov    %edx,(%eax)
  8030cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030d0:	8b 00                	mov    (%eax),%eax
  8030d2:	85 c0                	test   %eax,%eax
  8030d4:	74 0d                	je     8030e3 <insert_sorted_with_merge_freeList+0x453>
  8030d6:	a1 48 51 80 00       	mov    0x805148,%eax
  8030db:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030de:	89 50 04             	mov    %edx,0x4(%eax)
  8030e1:	eb 08                	jmp    8030eb <insert_sorted_with_merge_freeList+0x45b>
  8030e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030e6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ee:	a3 48 51 80 00       	mov    %eax,0x805148
  8030f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030f6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030fd:	a1 54 51 80 00       	mov    0x805154,%eax
  803102:	40                   	inc    %eax
  803103:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803108:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80310b:	8b 50 0c             	mov    0xc(%eax),%edx
  80310e:	8b 45 08             	mov    0x8(%ebp),%eax
  803111:	8b 40 0c             	mov    0xc(%eax),%eax
  803114:	01 c2                	add    %eax,%edx
  803116:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803119:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  80311c:	8b 45 08             	mov    0x8(%ebp),%eax
  80311f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803126:	8b 45 08             	mov    0x8(%ebp),%eax
  803129:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803130:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803134:	75 17                	jne    80314d <insert_sorted_with_merge_freeList+0x4bd>
  803136:	83 ec 04             	sub    $0x4,%esp
  803139:	68 78 3f 80 00       	push   $0x803f78
  80313e:	68 64 01 00 00       	push   $0x164
  803143:	68 9b 3f 80 00       	push   $0x803f9b
  803148:	e8 2a d1 ff ff       	call   800277 <_panic>
  80314d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803153:	8b 45 08             	mov    0x8(%ebp),%eax
  803156:	89 10                	mov    %edx,(%eax)
  803158:	8b 45 08             	mov    0x8(%ebp),%eax
  80315b:	8b 00                	mov    (%eax),%eax
  80315d:	85 c0                	test   %eax,%eax
  80315f:	74 0d                	je     80316e <insert_sorted_with_merge_freeList+0x4de>
  803161:	a1 48 51 80 00       	mov    0x805148,%eax
  803166:	8b 55 08             	mov    0x8(%ebp),%edx
  803169:	89 50 04             	mov    %edx,0x4(%eax)
  80316c:	eb 08                	jmp    803176 <insert_sorted_with_merge_freeList+0x4e6>
  80316e:	8b 45 08             	mov    0x8(%ebp),%eax
  803171:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803176:	8b 45 08             	mov    0x8(%ebp),%eax
  803179:	a3 48 51 80 00       	mov    %eax,0x805148
  80317e:	8b 45 08             	mov    0x8(%ebp),%eax
  803181:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803188:	a1 54 51 80 00       	mov    0x805154,%eax
  80318d:	40                   	inc    %eax
  80318e:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803193:	e9 41 02 00 00       	jmp    8033d9 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803198:	8b 45 08             	mov    0x8(%ebp),%eax
  80319b:	8b 50 08             	mov    0x8(%eax),%edx
  80319e:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a1:	8b 40 0c             	mov    0xc(%eax),%eax
  8031a4:	01 c2                	add    %eax,%edx
  8031a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031a9:	8b 40 08             	mov    0x8(%eax),%eax
  8031ac:	39 c2                	cmp    %eax,%edx
  8031ae:	0f 85 7c 01 00 00    	jne    803330 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8031b4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031b8:	74 06                	je     8031c0 <insert_sorted_with_merge_freeList+0x530>
  8031ba:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031be:	75 17                	jne    8031d7 <insert_sorted_with_merge_freeList+0x547>
  8031c0:	83 ec 04             	sub    $0x4,%esp
  8031c3:	68 b4 3f 80 00       	push   $0x803fb4
  8031c8:	68 69 01 00 00       	push   $0x169
  8031cd:	68 9b 3f 80 00       	push   $0x803f9b
  8031d2:	e8 a0 d0 ff ff       	call   800277 <_panic>
  8031d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031da:	8b 50 04             	mov    0x4(%eax),%edx
  8031dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e0:	89 50 04             	mov    %edx,0x4(%eax)
  8031e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031e9:	89 10                	mov    %edx,(%eax)
  8031eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ee:	8b 40 04             	mov    0x4(%eax),%eax
  8031f1:	85 c0                	test   %eax,%eax
  8031f3:	74 0d                	je     803202 <insert_sorted_with_merge_freeList+0x572>
  8031f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f8:	8b 40 04             	mov    0x4(%eax),%eax
  8031fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8031fe:	89 10                	mov    %edx,(%eax)
  803200:	eb 08                	jmp    80320a <insert_sorted_with_merge_freeList+0x57a>
  803202:	8b 45 08             	mov    0x8(%ebp),%eax
  803205:	a3 38 51 80 00       	mov    %eax,0x805138
  80320a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80320d:	8b 55 08             	mov    0x8(%ebp),%edx
  803210:	89 50 04             	mov    %edx,0x4(%eax)
  803213:	a1 44 51 80 00       	mov    0x805144,%eax
  803218:	40                   	inc    %eax
  803219:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  80321e:	8b 45 08             	mov    0x8(%ebp),%eax
  803221:	8b 50 0c             	mov    0xc(%eax),%edx
  803224:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803227:	8b 40 0c             	mov    0xc(%eax),%eax
  80322a:	01 c2                	add    %eax,%edx
  80322c:	8b 45 08             	mov    0x8(%ebp),%eax
  80322f:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803232:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803236:	75 17                	jne    80324f <insert_sorted_with_merge_freeList+0x5bf>
  803238:	83 ec 04             	sub    $0x4,%esp
  80323b:	68 44 40 80 00       	push   $0x804044
  803240:	68 6b 01 00 00       	push   $0x16b
  803245:	68 9b 3f 80 00       	push   $0x803f9b
  80324a:	e8 28 d0 ff ff       	call   800277 <_panic>
  80324f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803252:	8b 00                	mov    (%eax),%eax
  803254:	85 c0                	test   %eax,%eax
  803256:	74 10                	je     803268 <insert_sorted_with_merge_freeList+0x5d8>
  803258:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80325b:	8b 00                	mov    (%eax),%eax
  80325d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803260:	8b 52 04             	mov    0x4(%edx),%edx
  803263:	89 50 04             	mov    %edx,0x4(%eax)
  803266:	eb 0b                	jmp    803273 <insert_sorted_with_merge_freeList+0x5e3>
  803268:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80326b:	8b 40 04             	mov    0x4(%eax),%eax
  80326e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803273:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803276:	8b 40 04             	mov    0x4(%eax),%eax
  803279:	85 c0                	test   %eax,%eax
  80327b:	74 0f                	je     80328c <insert_sorted_with_merge_freeList+0x5fc>
  80327d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803280:	8b 40 04             	mov    0x4(%eax),%eax
  803283:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803286:	8b 12                	mov    (%edx),%edx
  803288:	89 10                	mov    %edx,(%eax)
  80328a:	eb 0a                	jmp    803296 <insert_sorted_with_merge_freeList+0x606>
  80328c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80328f:	8b 00                	mov    (%eax),%eax
  803291:	a3 38 51 80 00       	mov    %eax,0x805138
  803296:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803299:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80329f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032a2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032a9:	a1 44 51 80 00       	mov    0x805144,%eax
  8032ae:	48                   	dec    %eax
  8032af:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8032b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032b7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8032be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032c1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8032c8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032cc:	75 17                	jne    8032e5 <insert_sorted_with_merge_freeList+0x655>
  8032ce:	83 ec 04             	sub    $0x4,%esp
  8032d1:	68 78 3f 80 00       	push   $0x803f78
  8032d6:	68 6e 01 00 00       	push   $0x16e
  8032db:	68 9b 3f 80 00       	push   $0x803f9b
  8032e0:	e8 92 cf ff ff       	call   800277 <_panic>
  8032e5:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ee:	89 10                	mov    %edx,(%eax)
  8032f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032f3:	8b 00                	mov    (%eax),%eax
  8032f5:	85 c0                	test   %eax,%eax
  8032f7:	74 0d                	je     803306 <insert_sorted_with_merge_freeList+0x676>
  8032f9:	a1 48 51 80 00       	mov    0x805148,%eax
  8032fe:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803301:	89 50 04             	mov    %edx,0x4(%eax)
  803304:	eb 08                	jmp    80330e <insert_sorted_with_merge_freeList+0x67e>
  803306:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803309:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80330e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803311:	a3 48 51 80 00       	mov    %eax,0x805148
  803316:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803319:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803320:	a1 54 51 80 00       	mov    0x805154,%eax
  803325:	40                   	inc    %eax
  803326:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80332b:	e9 a9 00 00 00       	jmp    8033d9 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803330:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803334:	74 06                	je     80333c <insert_sorted_with_merge_freeList+0x6ac>
  803336:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80333a:	75 17                	jne    803353 <insert_sorted_with_merge_freeList+0x6c3>
  80333c:	83 ec 04             	sub    $0x4,%esp
  80333f:	68 10 40 80 00       	push   $0x804010
  803344:	68 73 01 00 00       	push   $0x173
  803349:	68 9b 3f 80 00       	push   $0x803f9b
  80334e:	e8 24 cf ff ff       	call   800277 <_panic>
  803353:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803356:	8b 10                	mov    (%eax),%edx
  803358:	8b 45 08             	mov    0x8(%ebp),%eax
  80335b:	89 10                	mov    %edx,(%eax)
  80335d:	8b 45 08             	mov    0x8(%ebp),%eax
  803360:	8b 00                	mov    (%eax),%eax
  803362:	85 c0                	test   %eax,%eax
  803364:	74 0b                	je     803371 <insert_sorted_with_merge_freeList+0x6e1>
  803366:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803369:	8b 00                	mov    (%eax),%eax
  80336b:	8b 55 08             	mov    0x8(%ebp),%edx
  80336e:	89 50 04             	mov    %edx,0x4(%eax)
  803371:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803374:	8b 55 08             	mov    0x8(%ebp),%edx
  803377:	89 10                	mov    %edx,(%eax)
  803379:	8b 45 08             	mov    0x8(%ebp),%eax
  80337c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80337f:	89 50 04             	mov    %edx,0x4(%eax)
  803382:	8b 45 08             	mov    0x8(%ebp),%eax
  803385:	8b 00                	mov    (%eax),%eax
  803387:	85 c0                	test   %eax,%eax
  803389:	75 08                	jne    803393 <insert_sorted_with_merge_freeList+0x703>
  80338b:	8b 45 08             	mov    0x8(%ebp),%eax
  80338e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803393:	a1 44 51 80 00       	mov    0x805144,%eax
  803398:	40                   	inc    %eax
  803399:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  80339e:	eb 39                	jmp    8033d9 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8033a0:	a1 40 51 80 00       	mov    0x805140,%eax
  8033a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033ac:	74 07                	je     8033b5 <insert_sorted_with_merge_freeList+0x725>
  8033ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b1:	8b 00                	mov    (%eax),%eax
  8033b3:	eb 05                	jmp    8033ba <insert_sorted_with_merge_freeList+0x72a>
  8033b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8033ba:	a3 40 51 80 00       	mov    %eax,0x805140
  8033bf:	a1 40 51 80 00       	mov    0x805140,%eax
  8033c4:	85 c0                	test   %eax,%eax
  8033c6:	0f 85 c7 fb ff ff    	jne    802f93 <insert_sorted_with_merge_freeList+0x303>
  8033cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033d0:	0f 85 bd fb ff ff    	jne    802f93 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8033d6:	eb 01                	jmp    8033d9 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8033d8:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8033d9:	90                   	nop
  8033da:	c9                   	leave  
  8033db:	c3                   	ret    

008033dc <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8033dc:	55                   	push   %ebp
  8033dd:	89 e5                	mov    %esp,%ebp
  8033df:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8033e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8033e5:	89 d0                	mov    %edx,%eax
  8033e7:	c1 e0 02             	shl    $0x2,%eax
  8033ea:	01 d0                	add    %edx,%eax
  8033ec:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8033f3:	01 d0                	add    %edx,%eax
  8033f5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8033fc:	01 d0                	add    %edx,%eax
  8033fe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803405:	01 d0                	add    %edx,%eax
  803407:	c1 e0 04             	shl    $0x4,%eax
  80340a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  80340d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803414:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803417:	83 ec 0c             	sub    $0xc,%esp
  80341a:	50                   	push   %eax
  80341b:	e8 26 e7 ff ff       	call   801b46 <sys_get_virtual_time>
  803420:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803423:	eb 41                	jmp    803466 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803425:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803428:	83 ec 0c             	sub    $0xc,%esp
  80342b:	50                   	push   %eax
  80342c:	e8 15 e7 ff ff       	call   801b46 <sys_get_virtual_time>
  803431:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803434:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803437:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80343a:	29 c2                	sub    %eax,%edx
  80343c:	89 d0                	mov    %edx,%eax
  80343e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803441:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803444:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803447:	89 d1                	mov    %edx,%ecx
  803449:	29 c1                	sub    %eax,%ecx
  80344b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80344e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803451:	39 c2                	cmp    %eax,%edx
  803453:	0f 97 c0             	seta   %al
  803456:	0f b6 c0             	movzbl %al,%eax
  803459:	29 c1                	sub    %eax,%ecx
  80345b:	89 c8                	mov    %ecx,%eax
  80345d:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803460:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803463:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803466:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803469:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80346c:	72 b7                	jb     803425 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  80346e:	90                   	nop
  80346f:	c9                   	leave  
  803470:	c3                   	ret    

00803471 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803471:	55                   	push   %ebp
  803472:	89 e5                	mov    %esp,%ebp
  803474:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803477:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  80347e:	eb 03                	jmp    803483 <busy_wait+0x12>
  803480:	ff 45 fc             	incl   -0x4(%ebp)
  803483:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803486:	3b 45 08             	cmp    0x8(%ebp),%eax
  803489:	72 f5                	jb     803480 <busy_wait+0xf>
	return i;
  80348b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80348e:	c9                   	leave  
  80348f:	c3                   	ret    

00803490 <__udivdi3>:
  803490:	55                   	push   %ebp
  803491:	57                   	push   %edi
  803492:	56                   	push   %esi
  803493:	53                   	push   %ebx
  803494:	83 ec 1c             	sub    $0x1c,%esp
  803497:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80349b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80349f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8034a3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8034a7:	89 ca                	mov    %ecx,%edx
  8034a9:	89 f8                	mov    %edi,%eax
  8034ab:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8034af:	85 f6                	test   %esi,%esi
  8034b1:	75 2d                	jne    8034e0 <__udivdi3+0x50>
  8034b3:	39 cf                	cmp    %ecx,%edi
  8034b5:	77 65                	ja     80351c <__udivdi3+0x8c>
  8034b7:	89 fd                	mov    %edi,%ebp
  8034b9:	85 ff                	test   %edi,%edi
  8034bb:	75 0b                	jne    8034c8 <__udivdi3+0x38>
  8034bd:	b8 01 00 00 00       	mov    $0x1,%eax
  8034c2:	31 d2                	xor    %edx,%edx
  8034c4:	f7 f7                	div    %edi
  8034c6:	89 c5                	mov    %eax,%ebp
  8034c8:	31 d2                	xor    %edx,%edx
  8034ca:	89 c8                	mov    %ecx,%eax
  8034cc:	f7 f5                	div    %ebp
  8034ce:	89 c1                	mov    %eax,%ecx
  8034d0:	89 d8                	mov    %ebx,%eax
  8034d2:	f7 f5                	div    %ebp
  8034d4:	89 cf                	mov    %ecx,%edi
  8034d6:	89 fa                	mov    %edi,%edx
  8034d8:	83 c4 1c             	add    $0x1c,%esp
  8034db:	5b                   	pop    %ebx
  8034dc:	5e                   	pop    %esi
  8034dd:	5f                   	pop    %edi
  8034de:	5d                   	pop    %ebp
  8034df:	c3                   	ret    
  8034e0:	39 ce                	cmp    %ecx,%esi
  8034e2:	77 28                	ja     80350c <__udivdi3+0x7c>
  8034e4:	0f bd fe             	bsr    %esi,%edi
  8034e7:	83 f7 1f             	xor    $0x1f,%edi
  8034ea:	75 40                	jne    80352c <__udivdi3+0x9c>
  8034ec:	39 ce                	cmp    %ecx,%esi
  8034ee:	72 0a                	jb     8034fa <__udivdi3+0x6a>
  8034f0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8034f4:	0f 87 9e 00 00 00    	ja     803598 <__udivdi3+0x108>
  8034fa:	b8 01 00 00 00       	mov    $0x1,%eax
  8034ff:	89 fa                	mov    %edi,%edx
  803501:	83 c4 1c             	add    $0x1c,%esp
  803504:	5b                   	pop    %ebx
  803505:	5e                   	pop    %esi
  803506:	5f                   	pop    %edi
  803507:	5d                   	pop    %ebp
  803508:	c3                   	ret    
  803509:	8d 76 00             	lea    0x0(%esi),%esi
  80350c:	31 ff                	xor    %edi,%edi
  80350e:	31 c0                	xor    %eax,%eax
  803510:	89 fa                	mov    %edi,%edx
  803512:	83 c4 1c             	add    $0x1c,%esp
  803515:	5b                   	pop    %ebx
  803516:	5e                   	pop    %esi
  803517:	5f                   	pop    %edi
  803518:	5d                   	pop    %ebp
  803519:	c3                   	ret    
  80351a:	66 90                	xchg   %ax,%ax
  80351c:	89 d8                	mov    %ebx,%eax
  80351e:	f7 f7                	div    %edi
  803520:	31 ff                	xor    %edi,%edi
  803522:	89 fa                	mov    %edi,%edx
  803524:	83 c4 1c             	add    $0x1c,%esp
  803527:	5b                   	pop    %ebx
  803528:	5e                   	pop    %esi
  803529:	5f                   	pop    %edi
  80352a:	5d                   	pop    %ebp
  80352b:	c3                   	ret    
  80352c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803531:	89 eb                	mov    %ebp,%ebx
  803533:	29 fb                	sub    %edi,%ebx
  803535:	89 f9                	mov    %edi,%ecx
  803537:	d3 e6                	shl    %cl,%esi
  803539:	89 c5                	mov    %eax,%ebp
  80353b:	88 d9                	mov    %bl,%cl
  80353d:	d3 ed                	shr    %cl,%ebp
  80353f:	89 e9                	mov    %ebp,%ecx
  803541:	09 f1                	or     %esi,%ecx
  803543:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803547:	89 f9                	mov    %edi,%ecx
  803549:	d3 e0                	shl    %cl,%eax
  80354b:	89 c5                	mov    %eax,%ebp
  80354d:	89 d6                	mov    %edx,%esi
  80354f:	88 d9                	mov    %bl,%cl
  803551:	d3 ee                	shr    %cl,%esi
  803553:	89 f9                	mov    %edi,%ecx
  803555:	d3 e2                	shl    %cl,%edx
  803557:	8b 44 24 08          	mov    0x8(%esp),%eax
  80355b:	88 d9                	mov    %bl,%cl
  80355d:	d3 e8                	shr    %cl,%eax
  80355f:	09 c2                	or     %eax,%edx
  803561:	89 d0                	mov    %edx,%eax
  803563:	89 f2                	mov    %esi,%edx
  803565:	f7 74 24 0c          	divl   0xc(%esp)
  803569:	89 d6                	mov    %edx,%esi
  80356b:	89 c3                	mov    %eax,%ebx
  80356d:	f7 e5                	mul    %ebp
  80356f:	39 d6                	cmp    %edx,%esi
  803571:	72 19                	jb     80358c <__udivdi3+0xfc>
  803573:	74 0b                	je     803580 <__udivdi3+0xf0>
  803575:	89 d8                	mov    %ebx,%eax
  803577:	31 ff                	xor    %edi,%edi
  803579:	e9 58 ff ff ff       	jmp    8034d6 <__udivdi3+0x46>
  80357e:	66 90                	xchg   %ax,%ax
  803580:	8b 54 24 08          	mov    0x8(%esp),%edx
  803584:	89 f9                	mov    %edi,%ecx
  803586:	d3 e2                	shl    %cl,%edx
  803588:	39 c2                	cmp    %eax,%edx
  80358a:	73 e9                	jae    803575 <__udivdi3+0xe5>
  80358c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80358f:	31 ff                	xor    %edi,%edi
  803591:	e9 40 ff ff ff       	jmp    8034d6 <__udivdi3+0x46>
  803596:	66 90                	xchg   %ax,%ax
  803598:	31 c0                	xor    %eax,%eax
  80359a:	e9 37 ff ff ff       	jmp    8034d6 <__udivdi3+0x46>
  80359f:	90                   	nop

008035a0 <__umoddi3>:
  8035a0:	55                   	push   %ebp
  8035a1:	57                   	push   %edi
  8035a2:	56                   	push   %esi
  8035a3:	53                   	push   %ebx
  8035a4:	83 ec 1c             	sub    $0x1c,%esp
  8035a7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8035ab:	8b 74 24 34          	mov    0x34(%esp),%esi
  8035af:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8035b3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8035b7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8035bb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8035bf:	89 f3                	mov    %esi,%ebx
  8035c1:	89 fa                	mov    %edi,%edx
  8035c3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8035c7:	89 34 24             	mov    %esi,(%esp)
  8035ca:	85 c0                	test   %eax,%eax
  8035cc:	75 1a                	jne    8035e8 <__umoddi3+0x48>
  8035ce:	39 f7                	cmp    %esi,%edi
  8035d0:	0f 86 a2 00 00 00    	jbe    803678 <__umoddi3+0xd8>
  8035d6:	89 c8                	mov    %ecx,%eax
  8035d8:	89 f2                	mov    %esi,%edx
  8035da:	f7 f7                	div    %edi
  8035dc:	89 d0                	mov    %edx,%eax
  8035de:	31 d2                	xor    %edx,%edx
  8035e0:	83 c4 1c             	add    $0x1c,%esp
  8035e3:	5b                   	pop    %ebx
  8035e4:	5e                   	pop    %esi
  8035e5:	5f                   	pop    %edi
  8035e6:	5d                   	pop    %ebp
  8035e7:	c3                   	ret    
  8035e8:	39 f0                	cmp    %esi,%eax
  8035ea:	0f 87 ac 00 00 00    	ja     80369c <__umoddi3+0xfc>
  8035f0:	0f bd e8             	bsr    %eax,%ebp
  8035f3:	83 f5 1f             	xor    $0x1f,%ebp
  8035f6:	0f 84 ac 00 00 00    	je     8036a8 <__umoddi3+0x108>
  8035fc:	bf 20 00 00 00       	mov    $0x20,%edi
  803601:	29 ef                	sub    %ebp,%edi
  803603:	89 fe                	mov    %edi,%esi
  803605:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803609:	89 e9                	mov    %ebp,%ecx
  80360b:	d3 e0                	shl    %cl,%eax
  80360d:	89 d7                	mov    %edx,%edi
  80360f:	89 f1                	mov    %esi,%ecx
  803611:	d3 ef                	shr    %cl,%edi
  803613:	09 c7                	or     %eax,%edi
  803615:	89 e9                	mov    %ebp,%ecx
  803617:	d3 e2                	shl    %cl,%edx
  803619:	89 14 24             	mov    %edx,(%esp)
  80361c:	89 d8                	mov    %ebx,%eax
  80361e:	d3 e0                	shl    %cl,%eax
  803620:	89 c2                	mov    %eax,%edx
  803622:	8b 44 24 08          	mov    0x8(%esp),%eax
  803626:	d3 e0                	shl    %cl,%eax
  803628:	89 44 24 04          	mov    %eax,0x4(%esp)
  80362c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803630:	89 f1                	mov    %esi,%ecx
  803632:	d3 e8                	shr    %cl,%eax
  803634:	09 d0                	or     %edx,%eax
  803636:	d3 eb                	shr    %cl,%ebx
  803638:	89 da                	mov    %ebx,%edx
  80363a:	f7 f7                	div    %edi
  80363c:	89 d3                	mov    %edx,%ebx
  80363e:	f7 24 24             	mull   (%esp)
  803641:	89 c6                	mov    %eax,%esi
  803643:	89 d1                	mov    %edx,%ecx
  803645:	39 d3                	cmp    %edx,%ebx
  803647:	0f 82 87 00 00 00    	jb     8036d4 <__umoddi3+0x134>
  80364d:	0f 84 91 00 00 00    	je     8036e4 <__umoddi3+0x144>
  803653:	8b 54 24 04          	mov    0x4(%esp),%edx
  803657:	29 f2                	sub    %esi,%edx
  803659:	19 cb                	sbb    %ecx,%ebx
  80365b:	89 d8                	mov    %ebx,%eax
  80365d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803661:	d3 e0                	shl    %cl,%eax
  803663:	89 e9                	mov    %ebp,%ecx
  803665:	d3 ea                	shr    %cl,%edx
  803667:	09 d0                	or     %edx,%eax
  803669:	89 e9                	mov    %ebp,%ecx
  80366b:	d3 eb                	shr    %cl,%ebx
  80366d:	89 da                	mov    %ebx,%edx
  80366f:	83 c4 1c             	add    $0x1c,%esp
  803672:	5b                   	pop    %ebx
  803673:	5e                   	pop    %esi
  803674:	5f                   	pop    %edi
  803675:	5d                   	pop    %ebp
  803676:	c3                   	ret    
  803677:	90                   	nop
  803678:	89 fd                	mov    %edi,%ebp
  80367a:	85 ff                	test   %edi,%edi
  80367c:	75 0b                	jne    803689 <__umoddi3+0xe9>
  80367e:	b8 01 00 00 00       	mov    $0x1,%eax
  803683:	31 d2                	xor    %edx,%edx
  803685:	f7 f7                	div    %edi
  803687:	89 c5                	mov    %eax,%ebp
  803689:	89 f0                	mov    %esi,%eax
  80368b:	31 d2                	xor    %edx,%edx
  80368d:	f7 f5                	div    %ebp
  80368f:	89 c8                	mov    %ecx,%eax
  803691:	f7 f5                	div    %ebp
  803693:	89 d0                	mov    %edx,%eax
  803695:	e9 44 ff ff ff       	jmp    8035de <__umoddi3+0x3e>
  80369a:	66 90                	xchg   %ax,%ax
  80369c:	89 c8                	mov    %ecx,%eax
  80369e:	89 f2                	mov    %esi,%edx
  8036a0:	83 c4 1c             	add    $0x1c,%esp
  8036a3:	5b                   	pop    %ebx
  8036a4:	5e                   	pop    %esi
  8036a5:	5f                   	pop    %edi
  8036a6:	5d                   	pop    %ebp
  8036a7:	c3                   	ret    
  8036a8:	3b 04 24             	cmp    (%esp),%eax
  8036ab:	72 06                	jb     8036b3 <__umoddi3+0x113>
  8036ad:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8036b1:	77 0f                	ja     8036c2 <__umoddi3+0x122>
  8036b3:	89 f2                	mov    %esi,%edx
  8036b5:	29 f9                	sub    %edi,%ecx
  8036b7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8036bb:	89 14 24             	mov    %edx,(%esp)
  8036be:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8036c2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8036c6:	8b 14 24             	mov    (%esp),%edx
  8036c9:	83 c4 1c             	add    $0x1c,%esp
  8036cc:	5b                   	pop    %ebx
  8036cd:	5e                   	pop    %esi
  8036ce:	5f                   	pop    %edi
  8036cf:	5d                   	pop    %ebp
  8036d0:	c3                   	ret    
  8036d1:	8d 76 00             	lea    0x0(%esi),%esi
  8036d4:	2b 04 24             	sub    (%esp),%eax
  8036d7:	19 fa                	sbb    %edi,%edx
  8036d9:	89 d1                	mov    %edx,%ecx
  8036db:	89 c6                	mov    %eax,%esi
  8036dd:	e9 71 ff ff ff       	jmp    803653 <__umoddi3+0xb3>
  8036e2:	66 90                	xchg   %ax,%ax
  8036e4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8036e8:	72 ea                	jb     8036d4 <__umoddi3+0x134>
  8036ea:	89 d9                	mov    %ebx,%ecx
  8036ec:	e9 62 ff ff ff       	jmp    803653 <__umoddi3+0xb3>
