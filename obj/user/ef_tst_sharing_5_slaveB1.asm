
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
  80004b:	a1 20 40 80 00       	mov    0x804020,%eax
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
  800074:	a1 20 40 80 00       	mov    0x804020,%eax
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
  80008c:	68 20 36 80 00       	push   $0x803620
  800091:	6a 12                	push   $0x12
  800093:	68 3c 36 80 00       	push   $0x80363c
  800098:	e8 da 01 00 00       	call   800277 <_panic>
	}
	uint32 *x;
	x = sget(sys_getparentenvid(),"x");
  80009d:	e8 92 19 00 00       	call   801a34 <sys_getparentenvid>
  8000a2:	83 ec 08             	sub    $0x8,%esp
  8000a5:	68 5c 36 80 00       	push   $0x80365c
  8000aa:	50                   	push   %eax
  8000ab:	e8 e7 14 00 00       	call   801597 <sget>
  8000b0:	83 c4 10             	add    $0x10,%esp
  8000b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("Slave B1 env used x (getSharedObject)\n");
  8000b6:	83 ec 0c             	sub    $0xc,%esp
  8000b9:	68 60 36 80 00       	push   $0x803660
  8000be:	e8 68 04 00 00       	call   80052b <cprintf>
  8000c3:	83 c4 10             	add    $0x10,%esp

	cprintf("Slave B1 please be patient ...\n");
  8000c6:	83 ec 0c             	sub    $0xc,%esp
  8000c9:	68 88 36 80 00       	push   $0x803688
  8000ce:	e8 58 04 00 00       	call   80052b <cprintf>
  8000d3:	83 c4 10             	add    $0x10,%esp

	env_sleep(6000);
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	68 70 17 00 00       	push   $0x1770
  8000de:	e8 1a 32 00 00       	call   8032fd <env_sleep>
  8000e3:	83 c4 10             	add    $0x10,%esp
	int freeFrames = sys_calculate_free_frames() ;
  8000e6:	e8 50 16 00 00       	call   80173b <sys_calculate_free_frames>
  8000eb:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sfree(x);
  8000ee:	83 ec 0c             	sub    $0xc,%esp
  8000f1:	ff 75 ec             	pushl  -0x14(%ebp)
  8000f4:	e8 e2 14 00 00       	call   8015db <sfree>
  8000f9:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave B1 env removed x\n");
  8000fc:	83 ec 0c             	sub    $0xc,%esp
  8000ff:	68 a8 36 80 00       	push   $0x8036a8
  800104:	e8 22 04 00 00       	call   80052b <cprintf>
  800109:	83 c4 10             	add    $0x10,%esp

	if ((sys_calculate_free_frames() - freeFrames) !=  4) panic("B1 wrong free: frames removed not equal 4 !, correct frames to be removed are 4:\nfrom the env: 1 table and 1 for frame of x\nframes_storage of x: should be cleared now\n");
  80010c:	e8 2a 16 00 00       	call   80173b <sys_calculate_free_frames>
  800111:	89 c2                	mov    %eax,%edx
  800113:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800116:	29 c2                	sub    %eax,%edx
  800118:	89 d0                	mov    %edx,%eax
  80011a:	83 f8 04             	cmp    $0x4,%eax
  80011d:	74 14                	je     800133 <_main+0xfb>
  80011f:	83 ec 04             	sub    $0x4,%esp
  800122:	68 c0 36 80 00       	push   $0x8036c0
  800127:	6a 20                	push   $0x20
  800129:	68 3c 36 80 00       	push   $0x80363c
  80012e:	e8 44 01 00 00       	call   800277 <_panic>

	//To indicate that it's completed successfully
	inctst();
  800133:	e8 21 1a 00 00       	call   801b59 <inctst>
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
  800141:	e8 d5 18 00 00       	call   801a1b <sys_getenvindex>
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
  800168:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80016d:	a1 20 40 80 00       	mov    0x804020,%eax
  800172:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800178:	84 c0                	test   %al,%al
  80017a:	74 0f                	je     80018b <libmain+0x50>
		binaryname = myEnv->prog_name;
  80017c:	a1 20 40 80 00       	mov    0x804020,%eax
  800181:	05 5c 05 00 00       	add    $0x55c,%eax
  800186:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80018b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80018f:	7e 0a                	jle    80019b <libmain+0x60>
		binaryname = argv[0];
  800191:	8b 45 0c             	mov    0xc(%ebp),%eax
  800194:	8b 00                	mov    (%eax),%eax
  800196:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  80019b:	83 ec 08             	sub    $0x8,%esp
  80019e:	ff 75 0c             	pushl  0xc(%ebp)
  8001a1:	ff 75 08             	pushl  0x8(%ebp)
  8001a4:	e8 8f fe ff ff       	call   800038 <_main>
  8001a9:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001ac:	e8 77 16 00 00       	call   801828 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001b1:	83 ec 0c             	sub    $0xc,%esp
  8001b4:	68 80 37 80 00       	push   $0x803780
  8001b9:	e8 6d 03 00 00       	call   80052b <cprintf>
  8001be:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001c1:	a1 20 40 80 00       	mov    0x804020,%eax
  8001c6:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8001cc:	a1 20 40 80 00       	mov    0x804020,%eax
  8001d1:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8001d7:	83 ec 04             	sub    $0x4,%esp
  8001da:	52                   	push   %edx
  8001db:	50                   	push   %eax
  8001dc:	68 a8 37 80 00       	push   $0x8037a8
  8001e1:	e8 45 03 00 00       	call   80052b <cprintf>
  8001e6:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001e9:	a1 20 40 80 00       	mov    0x804020,%eax
  8001ee:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8001f4:	a1 20 40 80 00       	mov    0x804020,%eax
  8001f9:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8001ff:	a1 20 40 80 00       	mov    0x804020,%eax
  800204:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80020a:	51                   	push   %ecx
  80020b:	52                   	push   %edx
  80020c:	50                   	push   %eax
  80020d:	68 d0 37 80 00       	push   $0x8037d0
  800212:	e8 14 03 00 00       	call   80052b <cprintf>
  800217:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80021a:	a1 20 40 80 00       	mov    0x804020,%eax
  80021f:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800225:	83 ec 08             	sub    $0x8,%esp
  800228:	50                   	push   %eax
  800229:	68 28 38 80 00       	push   $0x803828
  80022e:	e8 f8 02 00 00       	call   80052b <cprintf>
  800233:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800236:	83 ec 0c             	sub    $0xc,%esp
  800239:	68 80 37 80 00       	push   $0x803780
  80023e:	e8 e8 02 00 00       	call   80052b <cprintf>
  800243:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800246:	e8 f7 15 00 00       	call   801842 <sys_enable_interrupt>

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
  80025e:	e8 84 17 00 00       	call   8019e7 <sys_destroy_env>
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
  80026f:	e8 d9 17 00 00       	call   801a4d <sys_exit_env>
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
  800286:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80028b:	85 c0                	test   %eax,%eax
  80028d:	74 16                	je     8002a5 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80028f:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800294:	83 ec 08             	sub    $0x8,%esp
  800297:	50                   	push   %eax
  800298:	68 3c 38 80 00       	push   $0x80383c
  80029d:	e8 89 02 00 00       	call   80052b <cprintf>
  8002a2:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002a5:	a1 00 40 80 00       	mov    0x804000,%eax
  8002aa:	ff 75 0c             	pushl  0xc(%ebp)
  8002ad:	ff 75 08             	pushl  0x8(%ebp)
  8002b0:	50                   	push   %eax
  8002b1:	68 41 38 80 00       	push   $0x803841
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
  8002d5:	68 5d 38 80 00       	push   $0x80385d
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
  8002ef:	a1 20 40 80 00       	mov    0x804020,%eax
  8002f4:	8b 50 74             	mov    0x74(%eax),%edx
  8002f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002fa:	39 c2                	cmp    %eax,%edx
  8002fc:	74 14                	je     800312 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8002fe:	83 ec 04             	sub    $0x4,%esp
  800301:	68 60 38 80 00       	push   $0x803860
  800306:	6a 26                	push   $0x26
  800308:	68 ac 38 80 00       	push   $0x8038ac
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
  800352:	a1 20 40 80 00       	mov    0x804020,%eax
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
  800372:	a1 20 40 80 00       	mov    0x804020,%eax
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
  8003bb:	a1 20 40 80 00       	mov    0x804020,%eax
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
  8003d3:	68 b8 38 80 00       	push   $0x8038b8
  8003d8:	6a 3a                	push   $0x3a
  8003da:	68 ac 38 80 00       	push   $0x8038ac
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
  800403:	a1 20 40 80 00       	mov    0x804020,%eax
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
  800429:	a1 20 40 80 00       	mov    0x804020,%eax
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
  800443:	68 0c 39 80 00       	push   $0x80390c
  800448:	6a 44                	push   $0x44
  80044a:	68 ac 38 80 00       	push   $0x8038ac
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
  800482:	a0 24 40 80 00       	mov    0x804024,%al
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
  80049d:	e8 d8 11 00 00       	call   80167a <sys_cputs>
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
  8004f7:	a0 24 40 80 00       	mov    0x804024,%al
  8004fc:	0f b6 c0             	movzbl %al,%eax
  8004ff:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800505:	83 ec 04             	sub    $0x4,%esp
  800508:	50                   	push   %eax
  800509:	52                   	push   %edx
  80050a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800510:	83 c0 08             	add    $0x8,%eax
  800513:	50                   	push   %eax
  800514:	e8 61 11 00 00       	call   80167a <sys_cputs>
  800519:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80051c:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
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
  800531:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
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
  80055e:	e8 c5 12 00 00       	call   801828 <sys_disable_interrupt>
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
  80057e:	e8 bf 12 00 00       	call   801842 <sys_enable_interrupt>
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
  8005c8:	e8 e7 2d 00 00       	call   8033b4 <__udivdi3>
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
  800618:	e8 a7 2e 00 00       	call   8034c4 <__umoddi3>
  80061d:	83 c4 10             	add    $0x10,%esp
  800620:	05 74 3b 80 00       	add    $0x803b74,%eax
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
  800773:	8b 04 85 98 3b 80 00 	mov    0x803b98(,%eax,4),%eax
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
  800854:	8b 34 9d e0 39 80 00 	mov    0x8039e0(,%ebx,4),%esi
  80085b:	85 f6                	test   %esi,%esi
  80085d:	75 19                	jne    800878 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80085f:	53                   	push   %ebx
  800860:	68 85 3b 80 00       	push   $0x803b85
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
  800879:	68 8e 3b 80 00       	push   $0x803b8e
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
  8008a6:	be 91 3b 80 00       	mov    $0x803b91,%esi
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
  8012bb:	a1 04 40 80 00       	mov    0x804004,%eax
  8012c0:	85 c0                	test   %eax,%eax
  8012c2:	74 1f                	je     8012e3 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8012c4:	e8 1d 00 00 00       	call   8012e6 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8012c9:	83 ec 0c             	sub    $0xc,%esp
  8012cc:	68 f0 3c 80 00       	push   $0x803cf0
  8012d1:	e8 55 f2 ff ff       	call   80052b <cprintf>
  8012d6:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8012d9:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
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
  8012ec:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  8012f3:	00 00 00 
  8012f6:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  8012fd:	00 00 00 
  801300:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801307:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  80130a:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801311:	00 00 00 
  801314:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  80131b:	00 00 00 
  80131e:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
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
  801343:	a3 50 40 80 00       	mov    %eax,0x804050
	MAX_MEM_BLOCK_CNT = (USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE;
  801348:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  80134f:	00 02 00 
	arr_size =  ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock), PAGE_SIZE);
  801352:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801359:	a1 20 41 80 00       	mov    0x804120,%eax
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
  80139c:	e8 1d 04 00 00       	call   8017be <sys_allocate_chunk>
  8013a1:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013a4:	a1 20 41 80 00       	mov    0x804120,%eax
  8013a9:	83 ec 0c             	sub    $0xc,%esp
  8013ac:	50                   	push   %eax
  8013ad:	e8 92 0a 00 00       	call   801e44 <initialize_MemBlocksList>
  8013b2:	83 c4 10             	add    $0x10,%esp
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	struct MemBlock * NewBlock = LIST_FIRST(&AvailableMemBlocksList);
  8013b5:	a1 48 41 80 00       	mov    0x804148,%eax
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
  8013da:	68 15 3d 80 00       	push   $0x803d15
  8013df:	6a 33                	push   $0x33
  8013e1:	68 33 3d 80 00       	push   $0x803d33
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
  80140a:	a3 4c 41 80 00       	mov    %eax,0x80414c
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
  80142d:	a3 48 41 80 00       	mov    %eax,0x804148
  801432:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801435:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80143b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80143e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801445:	a1 54 41 80 00       	mov    0x804154,%eax
  80144a:	48                   	dec    %eax
  80144b:	a3 54 41 80 00       	mov    %eax,0x804154
	LIST_INSERT_HEAD(&FreeMemBlocksList, NewBlock);
  801450:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801454:	75 14                	jne    80146a <initialize_dyn_block_system+0x184>
  801456:	83 ec 04             	sub    $0x4,%esp
  801459:	68 40 3d 80 00       	push   $0x803d40
  80145e:	6a 34                	push   $0x34
  801460:	68 33 3d 80 00       	push   $0x803d33
  801465:	e8 0d ee ff ff       	call   800277 <_panic>
  80146a:	8b 15 38 41 80 00    	mov    0x804138,%edx
  801470:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801473:	89 10                	mov    %edx,(%eax)
  801475:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801478:	8b 00                	mov    (%eax),%eax
  80147a:	85 c0                	test   %eax,%eax
  80147c:	74 0d                	je     80148b <initialize_dyn_block_system+0x1a5>
  80147e:	a1 38 41 80 00       	mov    0x804138,%eax
  801483:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801486:	89 50 04             	mov    %edx,0x4(%eax)
  801489:	eb 08                	jmp    801493 <initialize_dyn_block_system+0x1ad>
  80148b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80148e:	a3 3c 41 80 00       	mov    %eax,0x80413c
  801493:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801496:	a3 38 41 80 00       	mov    %eax,0x804138
  80149b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80149e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8014a5:	a1 44 41 80 00       	mov    0x804144,%eax
  8014aa:	40                   	inc    %eax
  8014ab:	a3 44 41 80 00       	mov    %eax,0x804144
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
  8014b6:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8014b9:	e8 f7 fd ff ff       	call   8012b5 <InitializeUHeap>
	if (size == 0) return NULL ;
  8014be:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014c2:	75 07                	jne    8014cb <malloc+0x18>
  8014c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8014c9:	eb 14                	jmp    8014df <malloc+0x2c>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  8014cb:	83 ec 04             	sub    $0x4,%esp
  8014ce:	68 64 3d 80 00       	push   $0x803d64
  8014d3:	6a 46                	push   $0x46
  8014d5:	68 33 3d 80 00       	push   $0x803d33
  8014da:	e8 98 ed ff ff       	call   800277 <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  8014df:	c9                   	leave  
  8014e0:	c3                   	ret    

008014e1 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8014e1:	55                   	push   %ebp
  8014e2:	89 e5                	mov    %esp,%ebp
  8014e4:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  8014e7:	83 ec 04             	sub    $0x4,%esp
  8014ea:	68 8c 3d 80 00       	push   $0x803d8c
  8014ef:	6a 61                	push   $0x61
  8014f1:	68 33 3d 80 00       	push   $0x803d33
  8014f6:	e8 7c ed ff ff       	call   800277 <_panic>

008014fb <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8014fb:	55                   	push   %ebp
  8014fc:	89 e5                	mov    %esp,%ebp
  8014fe:	83 ec 38             	sub    $0x38,%esp
  801501:	8b 45 10             	mov    0x10(%ebp),%eax
  801504:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801507:	e8 a9 fd ff ff       	call   8012b5 <InitializeUHeap>
	if (size == 0) return NULL ;
  80150c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801510:	75 07                	jne    801519 <smalloc+0x1e>
  801512:	b8 00 00 00 00       	mov    $0x0,%eax
  801517:	eb 7c                	jmp    801595 <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801519:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801520:	8b 55 0c             	mov    0xc(%ebp),%edx
  801523:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801526:	01 d0                	add    %edx,%eax
  801528:	48                   	dec    %eax
  801529:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80152c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80152f:	ba 00 00 00 00       	mov    $0x0,%edx
  801534:	f7 75 f0             	divl   -0x10(%ebp)
  801537:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80153a:	29 d0                	sub    %edx,%eax
  80153c:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  80153f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801546:	e8 41 06 00 00       	call   801b8c <sys_isUHeapPlacementStrategyFIRSTFIT>
  80154b:	85 c0                	test   %eax,%eax
  80154d:	74 11                	je     801560 <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  80154f:	83 ec 0c             	sub    $0xc,%esp
  801552:	ff 75 e8             	pushl  -0x18(%ebp)
  801555:	e8 ac 0c 00 00       	call   802206 <alloc_block_FF>
  80155a:	83 c4 10             	add    $0x10,%esp
  80155d:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  801560:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801564:	74 2a                	je     801590 <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801566:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801569:	8b 40 08             	mov    0x8(%eax),%eax
  80156c:	89 c2                	mov    %eax,%edx
  80156e:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801572:	52                   	push   %edx
  801573:	50                   	push   %eax
  801574:	ff 75 0c             	pushl  0xc(%ebp)
  801577:	ff 75 08             	pushl  0x8(%ebp)
  80157a:	e8 92 03 00 00       	call   801911 <sys_createSharedObject>
  80157f:	83 c4 10             	add    $0x10,%esp
  801582:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  801585:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  801589:	74 05                	je     801590 <smalloc+0x95>
			return (void*)virtual_address;
  80158b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80158e:	eb 05                	jmp    801595 <smalloc+0x9a>
	}
	return NULL;
  801590:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801595:	c9                   	leave  
  801596:	c3                   	ret    

00801597 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801597:	55                   	push   %ebp
  801598:	89 e5                	mov    %esp,%ebp
  80159a:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80159d:	e8 13 fd ff ff       	call   8012b5 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8015a2:	83 ec 04             	sub    $0x4,%esp
  8015a5:	68 b0 3d 80 00       	push   $0x803db0
  8015aa:	68 a2 00 00 00       	push   $0xa2
  8015af:	68 33 3d 80 00       	push   $0x803d33
  8015b4:	e8 be ec ff ff       	call   800277 <_panic>

008015b9 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8015b9:	55                   	push   %ebp
  8015ba:	89 e5                	mov    %esp,%ebp
  8015bc:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015bf:	e8 f1 fc ff ff       	call   8012b5 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8015c4:	83 ec 04             	sub    $0x4,%esp
  8015c7:	68 d4 3d 80 00       	push   $0x803dd4
  8015cc:	68 e6 00 00 00       	push   $0xe6
  8015d1:	68 33 3d 80 00       	push   $0x803d33
  8015d6:	e8 9c ec ff ff       	call   800277 <_panic>

008015db <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8015db:	55                   	push   %ebp
  8015dc:	89 e5                	mov    %esp,%ebp
  8015de:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8015e1:	83 ec 04             	sub    $0x4,%esp
  8015e4:	68 fc 3d 80 00       	push   $0x803dfc
  8015e9:	68 fa 00 00 00       	push   $0xfa
  8015ee:	68 33 3d 80 00       	push   $0x803d33
  8015f3:	e8 7f ec ff ff       	call   800277 <_panic>

008015f8 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8015f8:	55                   	push   %ebp
  8015f9:	89 e5                	mov    %esp,%ebp
  8015fb:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015fe:	83 ec 04             	sub    $0x4,%esp
  801601:	68 20 3e 80 00       	push   $0x803e20
  801606:	68 05 01 00 00       	push   $0x105
  80160b:	68 33 3d 80 00       	push   $0x803d33
  801610:	e8 62 ec ff ff       	call   800277 <_panic>

00801615 <shrink>:

}
void shrink(uint32 newSize)
{
  801615:	55                   	push   %ebp
  801616:	89 e5                	mov    %esp,%ebp
  801618:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80161b:	83 ec 04             	sub    $0x4,%esp
  80161e:	68 20 3e 80 00       	push   $0x803e20
  801623:	68 0a 01 00 00       	push   $0x10a
  801628:	68 33 3d 80 00       	push   $0x803d33
  80162d:	e8 45 ec ff ff       	call   800277 <_panic>

00801632 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801632:	55                   	push   %ebp
  801633:	89 e5                	mov    %esp,%ebp
  801635:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801638:	83 ec 04             	sub    $0x4,%esp
  80163b:	68 20 3e 80 00       	push   $0x803e20
  801640:	68 0f 01 00 00       	push   $0x10f
  801645:	68 33 3d 80 00       	push   $0x803d33
  80164a:	e8 28 ec ff ff       	call   800277 <_panic>

0080164f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80164f:	55                   	push   %ebp
  801650:	89 e5                	mov    %esp,%ebp
  801652:	57                   	push   %edi
  801653:	56                   	push   %esi
  801654:	53                   	push   %ebx
  801655:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801658:	8b 45 08             	mov    0x8(%ebp),%eax
  80165b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80165e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801661:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801664:	8b 7d 18             	mov    0x18(%ebp),%edi
  801667:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80166a:	cd 30                	int    $0x30
  80166c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80166f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801672:	83 c4 10             	add    $0x10,%esp
  801675:	5b                   	pop    %ebx
  801676:	5e                   	pop    %esi
  801677:	5f                   	pop    %edi
  801678:	5d                   	pop    %ebp
  801679:	c3                   	ret    

0080167a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80167a:	55                   	push   %ebp
  80167b:	89 e5                	mov    %esp,%ebp
  80167d:	83 ec 04             	sub    $0x4,%esp
  801680:	8b 45 10             	mov    0x10(%ebp),%eax
  801683:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801686:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80168a:	8b 45 08             	mov    0x8(%ebp),%eax
  80168d:	6a 00                	push   $0x0
  80168f:	6a 00                	push   $0x0
  801691:	52                   	push   %edx
  801692:	ff 75 0c             	pushl  0xc(%ebp)
  801695:	50                   	push   %eax
  801696:	6a 00                	push   $0x0
  801698:	e8 b2 ff ff ff       	call   80164f <syscall>
  80169d:	83 c4 18             	add    $0x18,%esp
}
  8016a0:	90                   	nop
  8016a1:	c9                   	leave  
  8016a2:	c3                   	ret    

008016a3 <sys_cgetc>:

int
sys_cgetc(void)
{
  8016a3:	55                   	push   %ebp
  8016a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8016a6:	6a 00                	push   $0x0
  8016a8:	6a 00                	push   $0x0
  8016aa:	6a 00                	push   $0x0
  8016ac:	6a 00                	push   $0x0
  8016ae:	6a 00                	push   $0x0
  8016b0:	6a 01                	push   $0x1
  8016b2:	e8 98 ff ff ff       	call   80164f <syscall>
  8016b7:	83 c4 18             	add    $0x18,%esp
}
  8016ba:	c9                   	leave  
  8016bb:	c3                   	ret    

008016bc <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8016bc:	55                   	push   %ebp
  8016bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8016bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c5:	6a 00                	push   $0x0
  8016c7:	6a 00                	push   $0x0
  8016c9:	6a 00                	push   $0x0
  8016cb:	52                   	push   %edx
  8016cc:	50                   	push   %eax
  8016cd:	6a 05                	push   $0x5
  8016cf:	e8 7b ff ff ff       	call   80164f <syscall>
  8016d4:	83 c4 18             	add    $0x18,%esp
}
  8016d7:	c9                   	leave  
  8016d8:	c3                   	ret    

008016d9 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8016d9:	55                   	push   %ebp
  8016da:	89 e5                	mov    %esp,%ebp
  8016dc:	56                   	push   %esi
  8016dd:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8016de:	8b 75 18             	mov    0x18(%ebp),%esi
  8016e1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016e4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ed:	56                   	push   %esi
  8016ee:	53                   	push   %ebx
  8016ef:	51                   	push   %ecx
  8016f0:	52                   	push   %edx
  8016f1:	50                   	push   %eax
  8016f2:	6a 06                	push   $0x6
  8016f4:	e8 56 ff ff ff       	call   80164f <syscall>
  8016f9:	83 c4 18             	add    $0x18,%esp
}
  8016fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016ff:	5b                   	pop    %ebx
  801700:	5e                   	pop    %esi
  801701:	5d                   	pop    %ebp
  801702:	c3                   	ret    

00801703 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801703:	55                   	push   %ebp
  801704:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801706:	8b 55 0c             	mov    0xc(%ebp),%edx
  801709:	8b 45 08             	mov    0x8(%ebp),%eax
  80170c:	6a 00                	push   $0x0
  80170e:	6a 00                	push   $0x0
  801710:	6a 00                	push   $0x0
  801712:	52                   	push   %edx
  801713:	50                   	push   %eax
  801714:	6a 07                	push   $0x7
  801716:	e8 34 ff ff ff       	call   80164f <syscall>
  80171b:	83 c4 18             	add    $0x18,%esp
}
  80171e:	c9                   	leave  
  80171f:	c3                   	ret    

00801720 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801720:	55                   	push   %ebp
  801721:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801723:	6a 00                	push   $0x0
  801725:	6a 00                	push   $0x0
  801727:	6a 00                	push   $0x0
  801729:	ff 75 0c             	pushl  0xc(%ebp)
  80172c:	ff 75 08             	pushl  0x8(%ebp)
  80172f:	6a 08                	push   $0x8
  801731:	e8 19 ff ff ff       	call   80164f <syscall>
  801736:	83 c4 18             	add    $0x18,%esp
}
  801739:	c9                   	leave  
  80173a:	c3                   	ret    

0080173b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80173b:	55                   	push   %ebp
  80173c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80173e:	6a 00                	push   $0x0
  801740:	6a 00                	push   $0x0
  801742:	6a 00                	push   $0x0
  801744:	6a 00                	push   $0x0
  801746:	6a 00                	push   $0x0
  801748:	6a 09                	push   $0x9
  80174a:	e8 00 ff ff ff       	call   80164f <syscall>
  80174f:	83 c4 18             	add    $0x18,%esp
}
  801752:	c9                   	leave  
  801753:	c3                   	ret    

00801754 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801754:	55                   	push   %ebp
  801755:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801757:	6a 00                	push   $0x0
  801759:	6a 00                	push   $0x0
  80175b:	6a 00                	push   $0x0
  80175d:	6a 00                	push   $0x0
  80175f:	6a 00                	push   $0x0
  801761:	6a 0a                	push   $0xa
  801763:	e8 e7 fe ff ff       	call   80164f <syscall>
  801768:	83 c4 18             	add    $0x18,%esp
}
  80176b:	c9                   	leave  
  80176c:	c3                   	ret    

0080176d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80176d:	55                   	push   %ebp
  80176e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801770:	6a 00                	push   $0x0
  801772:	6a 00                	push   $0x0
  801774:	6a 00                	push   $0x0
  801776:	6a 00                	push   $0x0
  801778:	6a 00                	push   $0x0
  80177a:	6a 0b                	push   $0xb
  80177c:	e8 ce fe ff ff       	call   80164f <syscall>
  801781:	83 c4 18             	add    $0x18,%esp
}
  801784:	c9                   	leave  
  801785:	c3                   	ret    

00801786 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801786:	55                   	push   %ebp
  801787:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801789:	6a 00                	push   $0x0
  80178b:	6a 00                	push   $0x0
  80178d:	6a 00                	push   $0x0
  80178f:	ff 75 0c             	pushl  0xc(%ebp)
  801792:	ff 75 08             	pushl  0x8(%ebp)
  801795:	6a 0f                	push   $0xf
  801797:	e8 b3 fe ff ff       	call   80164f <syscall>
  80179c:	83 c4 18             	add    $0x18,%esp
	return;
  80179f:	90                   	nop
}
  8017a0:	c9                   	leave  
  8017a1:	c3                   	ret    

008017a2 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8017a2:	55                   	push   %ebp
  8017a3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8017a5:	6a 00                	push   $0x0
  8017a7:	6a 00                	push   $0x0
  8017a9:	6a 00                	push   $0x0
  8017ab:	ff 75 0c             	pushl  0xc(%ebp)
  8017ae:	ff 75 08             	pushl  0x8(%ebp)
  8017b1:	6a 10                	push   $0x10
  8017b3:	e8 97 fe ff ff       	call   80164f <syscall>
  8017b8:	83 c4 18             	add    $0x18,%esp
	return ;
  8017bb:	90                   	nop
}
  8017bc:	c9                   	leave  
  8017bd:	c3                   	ret    

008017be <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8017be:	55                   	push   %ebp
  8017bf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8017c1:	6a 00                	push   $0x0
  8017c3:	6a 00                	push   $0x0
  8017c5:	ff 75 10             	pushl  0x10(%ebp)
  8017c8:	ff 75 0c             	pushl  0xc(%ebp)
  8017cb:	ff 75 08             	pushl  0x8(%ebp)
  8017ce:	6a 11                	push   $0x11
  8017d0:	e8 7a fe ff ff       	call   80164f <syscall>
  8017d5:	83 c4 18             	add    $0x18,%esp
	return ;
  8017d8:	90                   	nop
}
  8017d9:	c9                   	leave  
  8017da:	c3                   	ret    

008017db <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8017db:	55                   	push   %ebp
  8017dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8017de:	6a 00                	push   $0x0
  8017e0:	6a 00                	push   $0x0
  8017e2:	6a 00                	push   $0x0
  8017e4:	6a 00                	push   $0x0
  8017e6:	6a 00                	push   $0x0
  8017e8:	6a 0c                	push   $0xc
  8017ea:	e8 60 fe ff ff       	call   80164f <syscall>
  8017ef:	83 c4 18             	add    $0x18,%esp
}
  8017f2:	c9                   	leave  
  8017f3:	c3                   	ret    

008017f4 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8017f4:	55                   	push   %ebp
  8017f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8017f7:	6a 00                	push   $0x0
  8017f9:	6a 00                	push   $0x0
  8017fb:	6a 00                	push   $0x0
  8017fd:	6a 00                	push   $0x0
  8017ff:	ff 75 08             	pushl  0x8(%ebp)
  801802:	6a 0d                	push   $0xd
  801804:	e8 46 fe ff ff       	call   80164f <syscall>
  801809:	83 c4 18             	add    $0x18,%esp
}
  80180c:	c9                   	leave  
  80180d:	c3                   	ret    

0080180e <sys_scarce_memory>:

void sys_scarce_memory()
{
  80180e:	55                   	push   %ebp
  80180f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801811:	6a 00                	push   $0x0
  801813:	6a 00                	push   $0x0
  801815:	6a 00                	push   $0x0
  801817:	6a 00                	push   $0x0
  801819:	6a 00                	push   $0x0
  80181b:	6a 0e                	push   $0xe
  80181d:	e8 2d fe ff ff       	call   80164f <syscall>
  801822:	83 c4 18             	add    $0x18,%esp
}
  801825:	90                   	nop
  801826:	c9                   	leave  
  801827:	c3                   	ret    

00801828 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801828:	55                   	push   %ebp
  801829:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80182b:	6a 00                	push   $0x0
  80182d:	6a 00                	push   $0x0
  80182f:	6a 00                	push   $0x0
  801831:	6a 00                	push   $0x0
  801833:	6a 00                	push   $0x0
  801835:	6a 13                	push   $0x13
  801837:	e8 13 fe ff ff       	call   80164f <syscall>
  80183c:	83 c4 18             	add    $0x18,%esp
}
  80183f:	90                   	nop
  801840:	c9                   	leave  
  801841:	c3                   	ret    

00801842 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801842:	55                   	push   %ebp
  801843:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801845:	6a 00                	push   $0x0
  801847:	6a 00                	push   $0x0
  801849:	6a 00                	push   $0x0
  80184b:	6a 00                	push   $0x0
  80184d:	6a 00                	push   $0x0
  80184f:	6a 14                	push   $0x14
  801851:	e8 f9 fd ff ff       	call   80164f <syscall>
  801856:	83 c4 18             	add    $0x18,%esp
}
  801859:	90                   	nop
  80185a:	c9                   	leave  
  80185b:	c3                   	ret    

0080185c <sys_cputc>:


void
sys_cputc(const char c)
{
  80185c:	55                   	push   %ebp
  80185d:	89 e5                	mov    %esp,%ebp
  80185f:	83 ec 04             	sub    $0x4,%esp
  801862:	8b 45 08             	mov    0x8(%ebp),%eax
  801865:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801868:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80186c:	6a 00                	push   $0x0
  80186e:	6a 00                	push   $0x0
  801870:	6a 00                	push   $0x0
  801872:	6a 00                	push   $0x0
  801874:	50                   	push   %eax
  801875:	6a 15                	push   $0x15
  801877:	e8 d3 fd ff ff       	call   80164f <syscall>
  80187c:	83 c4 18             	add    $0x18,%esp
}
  80187f:	90                   	nop
  801880:	c9                   	leave  
  801881:	c3                   	ret    

00801882 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801882:	55                   	push   %ebp
  801883:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801885:	6a 00                	push   $0x0
  801887:	6a 00                	push   $0x0
  801889:	6a 00                	push   $0x0
  80188b:	6a 00                	push   $0x0
  80188d:	6a 00                	push   $0x0
  80188f:	6a 16                	push   $0x16
  801891:	e8 b9 fd ff ff       	call   80164f <syscall>
  801896:	83 c4 18             	add    $0x18,%esp
}
  801899:	90                   	nop
  80189a:	c9                   	leave  
  80189b:	c3                   	ret    

0080189c <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80189c:	55                   	push   %ebp
  80189d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80189f:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a2:	6a 00                	push   $0x0
  8018a4:	6a 00                	push   $0x0
  8018a6:	6a 00                	push   $0x0
  8018a8:	ff 75 0c             	pushl  0xc(%ebp)
  8018ab:	50                   	push   %eax
  8018ac:	6a 17                	push   $0x17
  8018ae:	e8 9c fd ff ff       	call   80164f <syscall>
  8018b3:	83 c4 18             	add    $0x18,%esp
}
  8018b6:	c9                   	leave  
  8018b7:	c3                   	ret    

008018b8 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8018b8:	55                   	push   %ebp
  8018b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018be:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c1:	6a 00                	push   $0x0
  8018c3:	6a 00                	push   $0x0
  8018c5:	6a 00                	push   $0x0
  8018c7:	52                   	push   %edx
  8018c8:	50                   	push   %eax
  8018c9:	6a 1a                	push   $0x1a
  8018cb:	e8 7f fd ff ff       	call   80164f <syscall>
  8018d0:	83 c4 18             	add    $0x18,%esp
}
  8018d3:	c9                   	leave  
  8018d4:	c3                   	ret    

008018d5 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8018d5:	55                   	push   %ebp
  8018d6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018db:	8b 45 08             	mov    0x8(%ebp),%eax
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	52                   	push   %edx
  8018e5:	50                   	push   %eax
  8018e6:	6a 18                	push   $0x18
  8018e8:	e8 62 fd ff ff       	call   80164f <syscall>
  8018ed:	83 c4 18             	add    $0x18,%esp
}
  8018f0:	90                   	nop
  8018f1:	c9                   	leave  
  8018f2:	c3                   	ret    

008018f3 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8018f3:	55                   	push   %ebp
  8018f4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 00                	push   $0x0
  801900:	6a 00                	push   $0x0
  801902:	52                   	push   %edx
  801903:	50                   	push   %eax
  801904:	6a 19                	push   $0x19
  801906:	e8 44 fd ff ff       	call   80164f <syscall>
  80190b:	83 c4 18             	add    $0x18,%esp
}
  80190e:	90                   	nop
  80190f:	c9                   	leave  
  801910:	c3                   	ret    

00801911 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801911:	55                   	push   %ebp
  801912:	89 e5                	mov    %esp,%ebp
  801914:	83 ec 04             	sub    $0x4,%esp
  801917:	8b 45 10             	mov    0x10(%ebp),%eax
  80191a:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80191d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801920:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801924:	8b 45 08             	mov    0x8(%ebp),%eax
  801927:	6a 00                	push   $0x0
  801929:	51                   	push   %ecx
  80192a:	52                   	push   %edx
  80192b:	ff 75 0c             	pushl  0xc(%ebp)
  80192e:	50                   	push   %eax
  80192f:	6a 1b                	push   $0x1b
  801931:	e8 19 fd ff ff       	call   80164f <syscall>
  801936:	83 c4 18             	add    $0x18,%esp
}
  801939:	c9                   	leave  
  80193a:	c3                   	ret    

0080193b <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80193b:	55                   	push   %ebp
  80193c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80193e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801941:	8b 45 08             	mov    0x8(%ebp),%eax
  801944:	6a 00                	push   $0x0
  801946:	6a 00                	push   $0x0
  801948:	6a 00                	push   $0x0
  80194a:	52                   	push   %edx
  80194b:	50                   	push   %eax
  80194c:	6a 1c                	push   $0x1c
  80194e:	e8 fc fc ff ff       	call   80164f <syscall>
  801953:	83 c4 18             	add    $0x18,%esp
}
  801956:	c9                   	leave  
  801957:	c3                   	ret    

00801958 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801958:	55                   	push   %ebp
  801959:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80195b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80195e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801961:	8b 45 08             	mov    0x8(%ebp),%eax
  801964:	6a 00                	push   $0x0
  801966:	6a 00                	push   $0x0
  801968:	51                   	push   %ecx
  801969:	52                   	push   %edx
  80196a:	50                   	push   %eax
  80196b:	6a 1d                	push   $0x1d
  80196d:	e8 dd fc ff ff       	call   80164f <syscall>
  801972:	83 c4 18             	add    $0x18,%esp
}
  801975:	c9                   	leave  
  801976:	c3                   	ret    

00801977 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801977:	55                   	push   %ebp
  801978:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80197a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80197d:	8b 45 08             	mov    0x8(%ebp),%eax
  801980:	6a 00                	push   $0x0
  801982:	6a 00                	push   $0x0
  801984:	6a 00                	push   $0x0
  801986:	52                   	push   %edx
  801987:	50                   	push   %eax
  801988:	6a 1e                	push   $0x1e
  80198a:	e8 c0 fc ff ff       	call   80164f <syscall>
  80198f:	83 c4 18             	add    $0x18,%esp
}
  801992:	c9                   	leave  
  801993:	c3                   	ret    

00801994 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801994:	55                   	push   %ebp
  801995:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801997:	6a 00                	push   $0x0
  801999:	6a 00                	push   $0x0
  80199b:	6a 00                	push   $0x0
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 1f                	push   $0x1f
  8019a3:	e8 a7 fc ff ff       	call   80164f <syscall>
  8019a8:	83 c4 18             	add    $0x18,%esp
}
  8019ab:	c9                   	leave  
  8019ac:	c3                   	ret    

008019ad <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8019ad:	55                   	push   %ebp
  8019ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8019b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b3:	6a 00                	push   $0x0
  8019b5:	ff 75 14             	pushl  0x14(%ebp)
  8019b8:	ff 75 10             	pushl  0x10(%ebp)
  8019bb:	ff 75 0c             	pushl  0xc(%ebp)
  8019be:	50                   	push   %eax
  8019bf:	6a 20                	push   $0x20
  8019c1:	e8 89 fc ff ff       	call   80164f <syscall>
  8019c6:	83 c4 18             	add    $0x18,%esp
}
  8019c9:	c9                   	leave  
  8019ca:	c3                   	ret    

008019cb <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8019cb:	55                   	push   %ebp
  8019cc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8019ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 00                	push   $0x0
  8019d9:	50                   	push   %eax
  8019da:	6a 21                	push   $0x21
  8019dc:	e8 6e fc ff ff       	call   80164f <syscall>
  8019e1:	83 c4 18             	add    $0x18,%esp
}
  8019e4:	90                   	nop
  8019e5:	c9                   	leave  
  8019e6:	c3                   	ret    

008019e7 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8019e7:	55                   	push   %ebp
  8019e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8019ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 00                	push   $0x0
  8019f5:	50                   	push   %eax
  8019f6:	6a 22                	push   $0x22
  8019f8:	e8 52 fc ff ff       	call   80164f <syscall>
  8019fd:	83 c4 18             	add    $0x18,%esp
}
  801a00:	c9                   	leave  
  801a01:	c3                   	ret    

00801a02 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801a02:	55                   	push   %ebp
  801a03:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801a05:	6a 00                	push   $0x0
  801a07:	6a 00                	push   $0x0
  801a09:	6a 00                	push   $0x0
  801a0b:	6a 00                	push   $0x0
  801a0d:	6a 00                	push   $0x0
  801a0f:	6a 02                	push   $0x2
  801a11:	e8 39 fc ff ff       	call   80164f <syscall>
  801a16:	83 c4 18             	add    $0x18,%esp
}
  801a19:	c9                   	leave  
  801a1a:	c3                   	ret    

00801a1b <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801a1b:	55                   	push   %ebp
  801a1c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801a1e:	6a 00                	push   $0x0
  801a20:	6a 00                	push   $0x0
  801a22:	6a 00                	push   $0x0
  801a24:	6a 00                	push   $0x0
  801a26:	6a 00                	push   $0x0
  801a28:	6a 03                	push   $0x3
  801a2a:	e8 20 fc ff ff       	call   80164f <syscall>
  801a2f:	83 c4 18             	add    $0x18,%esp
}
  801a32:	c9                   	leave  
  801a33:	c3                   	ret    

00801a34 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801a34:	55                   	push   %ebp
  801a35:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801a37:	6a 00                	push   $0x0
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 00                	push   $0x0
  801a3f:	6a 00                	push   $0x0
  801a41:	6a 04                	push   $0x4
  801a43:	e8 07 fc ff ff       	call   80164f <syscall>
  801a48:	83 c4 18             	add    $0x18,%esp
}
  801a4b:	c9                   	leave  
  801a4c:	c3                   	ret    

00801a4d <sys_exit_env>:


void sys_exit_env(void)
{
  801a4d:	55                   	push   %ebp
  801a4e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801a50:	6a 00                	push   $0x0
  801a52:	6a 00                	push   $0x0
  801a54:	6a 00                	push   $0x0
  801a56:	6a 00                	push   $0x0
  801a58:	6a 00                	push   $0x0
  801a5a:	6a 23                	push   $0x23
  801a5c:	e8 ee fb ff ff       	call   80164f <syscall>
  801a61:	83 c4 18             	add    $0x18,%esp
}
  801a64:	90                   	nop
  801a65:	c9                   	leave  
  801a66:	c3                   	ret    

00801a67 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801a67:	55                   	push   %ebp
  801a68:	89 e5                	mov    %esp,%ebp
  801a6a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801a6d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a70:	8d 50 04             	lea    0x4(%eax),%edx
  801a73:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a76:	6a 00                	push   $0x0
  801a78:	6a 00                	push   $0x0
  801a7a:	6a 00                	push   $0x0
  801a7c:	52                   	push   %edx
  801a7d:	50                   	push   %eax
  801a7e:	6a 24                	push   $0x24
  801a80:	e8 ca fb ff ff       	call   80164f <syscall>
  801a85:	83 c4 18             	add    $0x18,%esp
	return result;
  801a88:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a8b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a8e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a91:	89 01                	mov    %eax,(%ecx)
  801a93:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801a96:	8b 45 08             	mov    0x8(%ebp),%eax
  801a99:	c9                   	leave  
  801a9a:	c2 04 00             	ret    $0x4

00801a9d <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801a9d:	55                   	push   %ebp
  801a9e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801aa0:	6a 00                	push   $0x0
  801aa2:	6a 00                	push   $0x0
  801aa4:	ff 75 10             	pushl  0x10(%ebp)
  801aa7:	ff 75 0c             	pushl  0xc(%ebp)
  801aaa:	ff 75 08             	pushl  0x8(%ebp)
  801aad:	6a 12                	push   $0x12
  801aaf:	e8 9b fb ff ff       	call   80164f <syscall>
  801ab4:	83 c4 18             	add    $0x18,%esp
	return ;
  801ab7:	90                   	nop
}
  801ab8:	c9                   	leave  
  801ab9:	c3                   	ret    

00801aba <sys_rcr2>:
uint32 sys_rcr2()
{
  801aba:	55                   	push   %ebp
  801abb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801abd:	6a 00                	push   $0x0
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 00                	push   $0x0
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 25                	push   $0x25
  801ac9:	e8 81 fb ff ff       	call   80164f <syscall>
  801ace:	83 c4 18             	add    $0x18,%esp
}
  801ad1:	c9                   	leave  
  801ad2:	c3                   	ret    

00801ad3 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801ad3:	55                   	push   %ebp
  801ad4:	89 e5                	mov    %esp,%ebp
  801ad6:	83 ec 04             	sub    $0x4,%esp
  801ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  801adc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801adf:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 00                	push   $0x0
  801ae9:	6a 00                	push   $0x0
  801aeb:	50                   	push   %eax
  801aec:	6a 26                	push   $0x26
  801aee:	e8 5c fb ff ff       	call   80164f <syscall>
  801af3:	83 c4 18             	add    $0x18,%esp
	return ;
  801af6:	90                   	nop
}
  801af7:	c9                   	leave  
  801af8:	c3                   	ret    

00801af9 <rsttst>:
void rsttst()
{
  801af9:	55                   	push   %ebp
  801afa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801afc:	6a 00                	push   $0x0
  801afe:	6a 00                	push   $0x0
  801b00:	6a 00                	push   $0x0
  801b02:	6a 00                	push   $0x0
  801b04:	6a 00                	push   $0x0
  801b06:	6a 28                	push   $0x28
  801b08:	e8 42 fb ff ff       	call   80164f <syscall>
  801b0d:	83 c4 18             	add    $0x18,%esp
	return ;
  801b10:	90                   	nop
}
  801b11:	c9                   	leave  
  801b12:	c3                   	ret    

00801b13 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801b13:	55                   	push   %ebp
  801b14:	89 e5                	mov    %esp,%ebp
  801b16:	83 ec 04             	sub    $0x4,%esp
  801b19:	8b 45 14             	mov    0x14(%ebp),%eax
  801b1c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801b1f:	8b 55 18             	mov    0x18(%ebp),%edx
  801b22:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b26:	52                   	push   %edx
  801b27:	50                   	push   %eax
  801b28:	ff 75 10             	pushl  0x10(%ebp)
  801b2b:	ff 75 0c             	pushl  0xc(%ebp)
  801b2e:	ff 75 08             	pushl  0x8(%ebp)
  801b31:	6a 27                	push   $0x27
  801b33:	e8 17 fb ff ff       	call   80164f <syscall>
  801b38:	83 c4 18             	add    $0x18,%esp
	return ;
  801b3b:	90                   	nop
}
  801b3c:	c9                   	leave  
  801b3d:	c3                   	ret    

00801b3e <chktst>:
void chktst(uint32 n)
{
  801b3e:	55                   	push   %ebp
  801b3f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801b41:	6a 00                	push   $0x0
  801b43:	6a 00                	push   $0x0
  801b45:	6a 00                	push   $0x0
  801b47:	6a 00                	push   $0x0
  801b49:	ff 75 08             	pushl  0x8(%ebp)
  801b4c:	6a 29                	push   $0x29
  801b4e:	e8 fc fa ff ff       	call   80164f <syscall>
  801b53:	83 c4 18             	add    $0x18,%esp
	return ;
  801b56:	90                   	nop
}
  801b57:	c9                   	leave  
  801b58:	c3                   	ret    

00801b59 <inctst>:

void inctst()
{
  801b59:	55                   	push   %ebp
  801b5a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801b5c:	6a 00                	push   $0x0
  801b5e:	6a 00                	push   $0x0
  801b60:	6a 00                	push   $0x0
  801b62:	6a 00                	push   $0x0
  801b64:	6a 00                	push   $0x0
  801b66:	6a 2a                	push   $0x2a
  801b68:	e8 e2 fa ff ff       	call   80164f <syscall>
  801b6d:	83 c4 18             	add    $0x18,%esp
	return ;
  801b70:	90                   	nop
}
  801b71:	c9                   	leave  
  801b72:	c3                   	ret    

00801b73 <gettst>:
uint32 gettst()
{
  801b73:	55                   	push   %ebp
  801b74:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801b76:	6a 00                	push   $0x0
  801b78:	6a 00                	push   $0x0
  801b7a:	6a 00                	push   $0x0
  801b7c:	6a 00                	push   $0x0
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 2b                	push   $0x2b
  801b82:	e8 c8 fa ff ff       	call   80164f <syscall>
  801b87:	83 c4 18             	add    $0x18,%esp
}
  801b8a:	c9                   	leave  
  801b8b:	c3                   	ret    

00801b8c <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801b8c:	55                   	push   %ebp
  801b8d:	89 e5                	mov    %esp,%ebp
  801b8f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	6a 00                	push   $0x0
  801b98:	6a 00                	push   $0x0
  801b9a:	6a 00                	push   $0x0
  801b9c:	6a 2c                	push   $0x2c
  801b9e:	e8 ac fa ff ff       	call   80164f <syscall>
  801ba3:	83 c4 18             	add    $0x18,%esp
  801ba6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801ba9:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801bad:	75 07                	jne    801bb6 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801baf:	b8 01 00 00 00       	mov    $0x1,%eax
  801bb4:	eb 05                	jmp    801bbb <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801bb6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bbb:	c9                   	leave  
  801bbc:	c3                   	ret    

00801bbd <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801bbd:	55                   	push   %ebp
  801bbe:	89 e5                	mov    %esp,%ebp
  801bc0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 00                	push   $0x0
  801bcb:	6a 00                	push   $0x0
  801bcd:	6a 2c                	push   $0x2c
  801bcf:	e8 7b fa ff ff       	call   80164f <syscall>
  801bd4:	83 c4 18             	add    $0x18,%esp
  801bd7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801bda:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801bde:	75 07                	jne    801be7 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801be0:	b8 01 00 00 00       	mov    $0x1,%eax
  801be5:	eb 05                	jmp    801bec <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801be7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bec:	c9                   	leave  
  801bed:	c3                   	ret    

00801bee <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801bee:	55                   	push   %ebp
  801bef:	89 e5                	mov    %esp,%ebp
  801bf1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bf4:	6a 00                	push   $0x0
  801bf6:	6a 00                	push   $0x0
  801bf8:	6a 00                	push   $0x0
  801bfa:	6a 00                	push   $0x0
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 2c                	push   $0x2c
  801c00:	e8 4a fa ff ff       	call   80164f <syscall>
  801c05:	83 c4 18             	add    $0x18,%esp
  801c08:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801c0b:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801c0f:	75 07                	jne    801c18 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801c11:	b8 01 00 00 00       	mov    $0x1,%eax
  801c16:	eb 05                	jmp    801c1d <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801c18:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c1d:	c9                   	leave  
  801c1e:	c3                   	ret    

00801c1f <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
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
  801c31:	e8 19 fa ff ff       	call   80164f <syscall>
  801c36:	83 c4 18             	add    $0x18,%esp
  801c39:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801c3c:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801c40:	75 07                	jne    801c49 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801c42:	b8 01 00 00 00       	mov    $0x1,%eax
  801c47:	eb 05                	jmp    801c4e <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801c49:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c4e:	c9                   	leave  
  801c4f:	c3                   	ret    

00801c50 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c50:	55                   	push   %ebp
  801c51:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c53:	6a 00                	push   $0x0
  801c55:	6a 00                	push   $0x0
  801c57:	6a 00                	push   $0x0
  801c59:	6a 00                	push   $0x0
  801c5b:	ff 75 08             	pushl  0x8(%ebp)
  801c5e:	6a 2d                	push   $0x2d
  801c60:	e8 ea f9 ff ff       	call   80164f <syscall>
  801c65:	83 c4 18             	add    $0x18,%esp
	return ;
  801c68:	90                   	nop
}
  801c69:	c9                   	leave  
  801c6a:	c3                   	ret    

00801c6b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801c6b:	55                   	push   %ebp
  801c6c:	89 e5                	mov    %esp,%ebp
  801c6e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801c6f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c72:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c75:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c78:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7b:	6a 00                	push   $0x0
  801c7d:	53                   	push   %ebx
  801c7e:	51                   	push   %ecx
  801c7f:	52                   	push   %edx
  801c80:	50                   	push   %eax
  801c81:	6a 2e                	push   $0x2e
  801c83:	e8 c7 f9 ff ff       	call   80164f <syscall>
  801c88:	83 c4 18             	add    $0x18,%esp
}
  801c8b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c8e:	c9                   	leave  
  801c8f:	c3                   	ret    

00801c90 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801c90:	55                   	push   %ebp
  801c91:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801c93:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c96:	8b 45 08             	mov    0x8(%ebp),%eax
  801c99:	6a 00                	push   $0x0
  801c9b:	6a 00                	push   $0x0
  801c9d:	6a 00                	push   $0x0
  801c9f:	52                   	push   %edx
  801ca0:	50                   	push   %eax
  801ca1:	6a 2f                	push   $0x2f
  801ca3:	e8 a7 f9 ff ff       	call   80164f <syscall>
  801ca8:	83 c4 18             	add    $0x18,%esp
}
  801cab:	c9                   	leave  
  801cac:	c3                   	ret    

00801cad <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801cad:	55                   	push   %ebp
  801cae:	89 e5                	mov    %esp,%ebp
  801cb0:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801cb3:	83 ec 0c             	sub    $0xc,%esp
  801cb6:	68 30 3e 80 00       	push   $0x803e30
  801cbb:	e8 6b e8 ff ff       	call   80052b <cprintf>
  801cc0:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801cc3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801cca:	83 ec 0c             	sub    $0xc,%esp
  801ccd:	68 5c 3e 80 00       	push   $0x803e5c
  801cd2:	e8 54 e8 ff ff       	call   80052b <cprintf>
  801cd7:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801cda:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801cde:	a1 38 41 80 00       	mov    0x804138,%eax
  801ce3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ce6:	eb 56                	jmp    801d3e <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801ce8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801cec:	74 1c                	je     801d0a <print_mem_block_lists+0x5d>
  801cee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cf1:	8b 50 08             	mov    0x8(%eax),%edx
  801cf4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cf7:	8b 48 08             	mov    0x8(%eax),%ecx
  801cfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cfd:	8b 40 0c             	mov    0xc(%eax),%eax
  801d00:	01 c8                	add    %ecx,%eax
  801d02:	39 c2                	cmp    %eax,%edx
  801d04:	73 04                	jae    801d0a <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801d06:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801d0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d0d:	8b 50 08             	mov    0x8(%eax),%edx
  801d10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d13:	8b 40 0c             	mov    0xc(%eax),%eax
  801d16:	01 c2                	add    %eax,%edx
  801d18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d1b:	8b 40 08             	mov    0x8(%eax),%eax
  801d1e:	83 ec 04             	sub    $0x4,%esp
  801d21:	52                   	push   %edx
  801d22:	50                   	push   %eax
  801d23:	68 71 3e 80 00       	push   $0x803e71
  801d28:	e8 fe e7 ff ff       	call   80052b <cprintf>
  801d2d:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801d30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d33:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d36:	a1 40 41 80 00       	mov    0x804140,%eax
  801d3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d3e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d42:	74 07                	je     801d4b <print_mem_block_lists+0x9e>
  801d44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d47:	8b 00                	mov    (%eax),%eax
  801d49:	eb 05                	jmp    801d50 <print_mem_block_lists+0xa3>
  801d4b:	b8 00 00 00 00       	mov    $0x0,%eax
  801d50:	a3 40 41 80 00       	mov    %eax,0x804140
  801d55:	a1 40 41 80 00       	mov    0x804140,%eax
  801d5a:	85 c0                	test   %eax,%eax
  801d5c:	75 8a                	jne    801ce8 <print_mem_block_lists+0x3b>
  801d5e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d62:	75 84                	jne    801ce8 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801d64:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801d68:	75 10                	jne    801d7a <print_mem_block_lists+0xcd>
  801d6a:	83 ec 0c             	sub    $0xc,%esp
  801d6d:	68 80 3e 80 00       	push   $0x803e80
  801d72:	e8 b4 e7 ff ff       	call   80052b <cprintf>
  801d77:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801d7a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801d81:	83 ec 0c             	sub    $0xc,%esp
  801d84:	68 a4 3e 80 00       	push   $0x803ea4
  801d89:	e8 9d e7 ff ff       	call   80052b <cprintf>
  801d8e:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801d91:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801d95:	a1 40 40 80 00       	mov    0x804040,%eax
  801d9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d9d:	eb 56                	jmp    801df5 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801d9f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801da3:	74 1c                	je     801dc1 <print_mem_block_lists+0x114>
  801da5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801da8:	8b 50 08             	mov    0x8(%eax),%edx
  801dab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dae:	8b 48 08             	mov    0x8(%eax),%ecx
  801db1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801db4:	8b 40 0c             	mov    0xc(%eax),%eax
  801db7:	01 c8                	add    %ecx,%eax
  801db9:	39 c2                	cmp    %eax,%edx
  801dbb:	73 04                	jae    801dc1 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801dbd:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801dc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc4:	8b 50 08             	mov    0x8(%eax),%edx
  801dc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dca:	8b 40 0c             	mov    0xc(%eax),%eax
  801dcd:	01 c2                	add    %eax,%edx
  801dcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd2:	8b 40 08             	mov    0x8(%eax),%eax
  801dd5:	83 ec 04             	sub    $0x4,%esp
  801dd8:	52                   	push   %edx
  801dd9:	50                   	push   %eax
  801dda:	68 71 3e 80 00       	push   $0x803e71
  801ddf:	e8 47 e7 ff ff       	call   80052b <cprintf>
  801de4:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801de7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dea:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801ded:	a1 48 40 80 00       	mov    0x804048,%eax
  801df2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801df5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801df9:	74 07                	je     801e02 <print_mem_block_lists+0x155>
  801dfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dfe:	8b 00                	mov    (%eax),%eax
  801e00:	eb 05                	jmp    801e07 <print_mem_block_lists+0x15a>
  801e02:	b8 00 00 00 00       	mov    $0x0,%eax
  801e07:	a3 48 40 80 00       	mov    %eax,0x804048
  801e0c:	a1 48 40 80 00       	mov    0x804048,%eax
  801e11:	85 c0                	test   %eax,%eax
  801e13:	75 8a                	jne    801d9f <print_mem_block_lists+0xf2>
  801e15:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e19:	75 84                	jne    801d9f <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801e1b:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e1f:	75 10                	jne    801e31 <print_mem_block_lists+0x184>
  801e21:	83 ec 0c             	sub    $0xc,%esp
  801e24:	68 bc 3e 80 00       	push   $0x803ebc
  801e29:	e8 fd e6 ff ff       	call   80052b <cprintf>
  801e2e:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801e31:	83 ec 0c             	sub    $0xc,%esp
  801e34:	68 30 3e 80 00       	push   $0x803e30
  801e39:	e8 ed e6 ff ff       	call   80052b <cprintf>
  801e3e:	83 c4 10             	add    $0x10,%esp

}
  801e41:	90                   	nop
  801e42:	c9                   	leave  
  801e43:	c3                   	ret    

00801e44 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801e44:	55                   	push   %ebp
  801e45:	89 e5                	mov    %esp,%ebp
  801e47:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801e4a:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801e51:	00 00 00 
  801e54:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801e5b:	00 00 00 
  801e5e:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801e65:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801e68:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801e6f:	e9 9e 00 00 00       	jmp    801f12 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801e74:	a1 50 40 80 00       	mov    0x804050,%eax
  801e79:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e7c:	c1 e2 04             	shl    $0x4,%edx
  801e7f:	01 d0                	add    %edx,%eax
  801e81:	85 c0                	test   %eax,%eax
  801e83:	75 14                	jne    801e99 <initialize_MemBlocksList+0x55>
  801e85:	83 ec 04             	sub    $0x4,%esp
  801e88:	68 e4 3e 80 00       	push   $0x803ee4
  801e8d:	6a 46                	push   $0x46
  801e8f:	68 07 3f 80 00       	push   $0x803f07
  801e94:	e8 de e3 ff ff       	call   800277 <_panic>
  801e99:	a1 50 40 80 00       	mov    0x804050,%eax
  801e9e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ea1:	c1 e2 04             	shl    $0x4,%edx
  801ea4:	01 d0                	add    %edx,%eax
  801ea6:	8b 15 48 41 80 00    	mov    0x804148,%edx
  801eac:	89 10                	mov    %edx,(%eax)
  801eae:	8b 00                	mov    (%eax),%eax
  801eb0:	85 c0                	test   %eax,%eax
  801eb2:	74 18                	je     801ecc <initialize_MemBlocksList+0x88>
  801eb4:	a1 48 41 80 00       	mov    0x804148,%eax
  801eb9:	8b 15 50 40 80 00    	mov    0x804050,%edx
  801ebf:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801ec2:	c1 e1 04             	shl    $0x4,%ecx
  801ec5:	01 ca                	add    %ecx,%edx
  801ec7:	89 50 04             	mov    %edx,0x4(%eax)
  801eca:	eb 12                	jmp    801ede <initialize_MemBlocksList+0x9a>
  801ecc:	a1 50 40 80 00       	mov    0x804050,%eax
  801ed1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ed4:	c1 e2 04             	shl    $0x4,%edx
  801ed7:	01 d0                	add    %edx,%eax
  801ed9:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801ede:	a1 50 40 80 00       	mov    0x804050,%eax
  801ee3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ee6:	c1 e2 04             	shl    $0x4,%edx
  801ee9:	01 d0                	add    %edx,%eax
  801eeb:	a3 48 41 80 00       	mov    %eax,0x804148
  801ef0:	a1 50 40 80 00       	mov    0x804050,%eax
  801ef5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ef8:	c1 e2 04             	shl    $0x4,%edx
  801efb:	01 d0                	add    %edx,%eax
  801efd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f04:	a1 54 41 80 00       	mov    0x804154,%eax
  801f09:	40                   	inc    %eax
  801f0a:	a3 54 41 80 00       	mov    %eax,0x804154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801f0f:	ff 45 f4             	incl   -0xc(%ebp)
  801f12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f15:	3b 45 08             	cmp    0x8(%ebp),%eax
  801f18:	0f 82 56 ff ff ff    	jb     801e74 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801f1e:	90                   	nop
  801f1f:	c9                   	leave  
  801f20:	c3                   	ret    

00801f21 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801f21:	55                   	push   %ebp
  801f22:	89 e5                	mov    %esp,%ebp
  801f24:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801f27:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2a:	8b 00                	mov    (%eax),%eax
  801f2c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f2f:	eb 19                	jmp    801f4a <find_block+0x29>
	{
		if(va==point->sva)
  801f31:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f34:	8b 40 08             	mov    0x8(%eax),%eax
  801f37:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801f3a:	75 05                	jne    801f41 <find_block+0x20>
		   return point;
  801f3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f3f:	eb 36                	jmp    801f77 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801f41:	8b 45 08             	mov    0x8(%ebp),%eax
  801f44:	8b 40 08             	mov    0x8(%eax),%eax
  801f47:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f4a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f4e:	74 07                	je     801f57 <find_block+0x36>
  801f50:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f53:	8b 00                	mov    (%eax),%eax
  801f55:	eb 05                	jmp    801f5c <find_block+0x3b>
  801f57:	b8 00 00 00 00       	mov    $0x0,%eax
  801f5c:	8b 55 08             	mov    0x8(%ebp),%edx
  801f5f:	89 42 08             	mov    %eax,0x8(%edx)
  801f62:	8b 45 08             	mov    0x8(%ebp),%eax
  801f65:	8b 40 08             	mov    0x8(%eax),%eax
  801f68:	85 c0                	test   %eax,%eax
  801f6a:	75 c5                	jne    801f31 <find_block+0x10>
  801f6c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f70:	75 bf                	jne    801f31 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  801f72:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f77:	c9                   	leave  
  801f78:	c3                   	ret    

00801f79 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  801f79:	55                   	push   %ebp
  801f7a:	89 e5                	mov    %esp,%ebp
  801f7c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  801f7f:	a1 40 40 80 00       	mov    0x804040,%eax
  801f84:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  801f87:	a1 44 40 80 00       	mov    0x804044,%eax
  801f8c:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  801f8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f92:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801f95:	74 24                	je     801fbb <insert_sorted_allocList+0x42>
  801f97:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9a:	8b 50 08             	mov    0x8(%eax),%edx
  801f9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fa0:	8b 40 08             	mov    0x8(%eax),%eax
  801fa3:	39 c2                	cmp    %eax,%edx
  801fa5:	76 14                	jbe    801fbb <insert_sorted_allocList+0x42>
  801fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  801faa:	8b 50 08             	mov    0x8(%eax),%edx
  801fad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fb0:	8b 40 08             	mov    0x8(%eax),%eax
  801fb3:	39 c2                	cmp    %eax,%edx
  801fb5:	0f 82 60 01 00 00    	jb     80211b <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  801fbb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fbf:	75 65                	jne    802026 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  801fc1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801fc5:	75 14                	jne    801fdb <insert_sorted_allocList+0x62>
  801fc7:	83 ec 04             	sub    $0x4,%esp
  801fca:	68 e4 3e 80 00       	push   $0x803ee4
  801fcf:	6a 6b                	push   $0x6b
  801fd1:	68 07 3f 80 00       	push   $0x803f07
  801fd6:	e8 9c e2 ff ff       	call   800277 <_panic>
  801fdb:	8b 15 40 40 80 00    	mov    0x804040,%edx
  801fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe4:	89 10                	mov    %edx,(%eax)
  801fe6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe9:	8b 00                	mov    (%eax),%eax
  801feb:	85 c0                	test   %eax,%eax
  801fed:	74 0d                	je     801ffc <insert_sorted_allocList+0x83>
  801fef:	a1 40 40 80 00       	mov    0x804040,%eax
  801ff4:	8b 55 08             	mov    0x8(%ebp),%edx
  801ff7:	89 50 04             	mov    %edx,0x4(%eax)
  801ffa:	eb 08                	jmp    802004 <insert_sorted_allocList+0x8b>
  801ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  801fff:	a3 44 40 80 00       	mov    %eax,0x804044
  802004:	8b 45 08             	mov    0x8(%ebp),%eax
  802007:	a3 40 40 80 00       	mov    %eax,0x804040
  80200c:	8b 45 08             	mov    0x8(%ebp),%eax
  80200f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802016:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80201b:	40                   	inc    %eax
  80201c:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802021:	e9 dc 01 00 00       	jmp    802202 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802026:	8b 45 08             	mov    0x8(%ebp),%eax
  802029:	8b 50 08             	mov    0x8(%eax),%edx
  80202c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80202f:	8b 40 08             	mov    0x8(%eax),%eax
  802032:	39 c2                	cmp    %eax,%edx
  802034:	77 6c                	ja     8020a2 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802036:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80203a:	74 06                	je     802042 <insert_sorted_allocList+0xc9>
  80203c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802040:	75 14                	jne    802056 <insert_sorted_allocList+0xdd>
  802042:	83 ec 04             	sub    $0x4,%esp
  802045:	68 20 3f 80 00       	push   $0x803f20
  80204a:	6a 6f                	push   $0x6f
  80204c:	68 07 3f 80 00       	push   $0x803f07
  802051:	e8 21 e2 ff ff       	call   800277 <_panic>
  802056:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802059:	8b 50 04             	mov    0x4(%eax),%edx
  80205c:	8b 45 08             	mov    0x8(%ebp),%eax
  80205f:	89 50 04             	mov    %edx,0x4(%eax)
  802062:	8b 45 08             	mov    0x8(%ebp),%eax
  802065:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802068:	89 10                	mov    %edx,(%eax)
  80206a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80206d:	8b 40 04             	mov    0x4(%eax),%eax
  802070:	85 c0                	test   %eax,%eax
  802072:	74 0d                	je     802081 <insert_sorted_allocList+0x108>
  802074:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802077:	8b 40 04             	mov    0x4(%eax),%eax
  80207a:	8b 55 08             	mov    0x8(%ebp),%edx
  80207d:	89 10                	mov    %edx,(%eax)
  80207f:	eb 08                	jmp    802089 <insert_sorted_allocList+0x110>
  802081:	8b 45 08             	mov    0x8(%ebp),%eax
  802084:	a3 40 40 80 00       	mov    %eax,0x804040
  802089:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80208c:	8b 55 08             	mov    0x8(%ebp),%edx
  80208f:	89 50 04             	mov    %edx,0x4(%eax)
  802092:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802097:	40                   	inc    %eax
  802098:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80209d:	e9 60 01 00 00       	jmp    802202 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8020a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a5:	8b 50 08             	mov    0x8(%eax),%edx
  8020a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020ab:	8b 40 08             	mov    0x8(%eax),%eax
  8020ae:	39 c2                	cmp    %eax,%edx
  8020b0:	0f 82 4c 01 00 00    	jb     802202 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8020b6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020ba:	75 14                	jne    8020d0 <insert_sorted_allocList+0x157>
  8020bc:	83 ec 04             	sub    $0x4,%esp
  8020bf:	68 58 3f 80 00       	push   $0x803f58
  8020c4:	6a 73                	push   $0x73
  8020c6:	68 07 3f 80 00       	push   $0x803f07
  8020cb:	e8 a7 e1 ff ff       	call   800277 <_panic>
  8020d0:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8020d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d9:	89 50 04             	mov    %edx,0x4(%eax)
  8020dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020df:	8b 40 04             	mov    0x4(%eax),%eax
  8020e2:	85 c0                	test   %eax,%eax
  8020e4:	74 0c                	je     8020f2 <insert_sorted_allocList+0x179>
  8020e6:	a1 44 40 80 00       	mov    0x804044,%eax
  8020eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8020ee:	89 10                	mov    %edx,(%eax)
  8020f0:	eb 08                	jmp    8020fa <insert_sorted_allocList+0x181>
  8020f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f5:	a3 40 40 80 00       	mov    %eax,0x804040
  8020fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fd:	a3 44 40 80 00       	mov    %eax,0x804044
  802102:	8b 45 08             	mov    0x8(%ebp),%eax
  802105:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80210b:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802110:	40                   	inc    %eax
  802111:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802116:	e9 e7 00 00 00       	jmp    802202 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  80211b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80211e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802121:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802128:	a1 40 40 80 00       	mov    0x804040,%eax
  80212d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802130:	e9 9d 00 00 00       	jmp    8021d2 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802135:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802138:	8b 00                	mov    (%eax),%eax
  80213a:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  80213d:	8b 45 08             	mov    0x8(%ebp),%eax
  802140:	8b 50 08             	mov    0x8(%eax),%edx
  802143:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802146:	8b 40 08             	mov    0x8(%eax),%eax
  802149:	39 c2                	cmp    %eax,%edx
  80214b:	76 7d                	jbe    8021ca <insert_sorted_allocList+0x251>
  80214d:	8b 45 08             	mov    0x8(%ebp),%eax
  802150:	8b 50 08             	mov    0x8(%eax),%edx
  802153:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802156:	8b 40 08             	mov    0x8(%eax),%eax
  802159:	39 c2                	cmp    %eax,%edx
  80215b:	73 6d                	jae    8021ca <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  80215d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802161:	74 06                	je     802169 <insert_sorted_allocList+0x1f0>
  802163:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802167:	75 14                	jne    80217d <insert_sorted_allocList+0x204>
  802169:	83 ec 04             	sub    $0x4,%esp
  80216c:	68 7c 3f 80 00       	push   $0x803f7c
  802171:	6a 7f                	push   $0x7f
  802173:	68 07 3f 80 00       	push   $0x803f07
  802178:	e8 fa e0 ff ff       	call   800277 <_panic>
  80217d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802180:	8b 10                	mov    (%eax),%edx
  802182:	8b 45 08             	mov    0x8(%ebp),%eax
  802185:	89 10                	mov    %edx,(%eax)
  802187:	8b 45 08             	mov    0x8(%ebp),%eax
  80218a:	8b 00                	mov    (%eax),%eax
  80218c:	85 c0                	test   %eax,%eax
  80218e:	74 0b                	je     80219b <insert_sorted_allocList+0x222>
  802190:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802193:	8b 00                	mov    (%eax),%eax
  802195:	8b 55 08             	mov    0x8(%ebp),%edx
  802198:	89 50 04             	mov    %edx,0x4(%eax)
  80219b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219e:	8b 55 08             	mov    0x8(%ebp),%edx
  8021a1:	89 10                	mov    %edx,(%eax)
  8021a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021a9:	89 50 04             	mov    %edx,0x4(%eax)
  8021ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8021af:	8b 00                	mov    (%eax),%eax
  8021b1:	85 c0                	test   %eax,%eax
  8021b3:	75 08                	jne    8021bd <insert_sorted_allocList+0x244>
  8021b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b8:	a3 44 40 80 00       	mov    %eax,0x804044
  8021bd:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021c2:	40                   	inc    %eax
  8021c3:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  8021c8:	eb 39                	jmp    802203 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8021ca:	a1 48 40 80 00       	mov    0x804048,%eax
  8021cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021d6:	74 07                	je     8021df <insert_sorted_allocList+0x266>
  8021d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021db:	8b 00                	mov    (%eax),%eax
  8021dd:	eb 05                	jmp    8021e4 <insert_sorted_allocList+0x26b>
  8021df:	b8 00 00 00 00       	mov    $0x0,%eax
  8021e4:	a3 48 40 80 00       	mov    %eax,0x804048
  8021e9:	a1 48 40 80 00       	mov    0x804048,%eax
  8021ee:	85 c0                	test   %eax,%eax
  8021f0:	0f 85 3f ff ff ff    	jne    802135 <insert_sorted_allocList+0x1bc>
  8021f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021fa:	0f 85 35 ff ff ff    	jne    802135 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802200:	eb 01                	jmp    802203 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802202:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802203:	90                   	nop
  802204:	c9                   	leave  
  802205:	c3                   	ret    

00802206 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802206:	55                   	push   %ebp
  802207:	89 e5                	mov    %esp,%ebp
  802209:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80220c:	a1 38 41 80 00       	mov    0x804138,%eax
  802211:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802214:	e9 85 01 00 00       	jmp    80239e <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802219:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80221c:	8b 40 0c             	mov    0xc(%eax),%eax
  80221f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802222:	0f 82 6e 01 00 00    	jb     802396 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802228:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80222b:	8b 40 0c             	mov    0xc(%eax),%eax
  80222e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802231:	0f 85 8a 00 00 00    	jne    8022c1 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802237:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80223b:	75 17                	jne    802254 <alloc_block_FF+0x4e>
  80223d:	83 ec 04             	sub    $0x4,%esp
  802240:	68 b0 3f 80 00       	push   $0x803fb0
  802245:	68 93 00 00 00       	push   $0x93
  80224a:	68 07 3f 80 00       	push   $0x803f07
  80224f:	e8 23 e0 ff ff       	call   800277 <_panic>
  802254:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802257:	8b 00                	mov    (%eax),%eax
  802259:	85 c0                	test   %eax,%eax
  80225b:	74 10                	je     80226d <alloc_block_FF+0x67>
  80225d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802260:	8b 00                	mov    (%eax),%eax
  802262:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802265:	8b 52 04             	mov    0x4(%edx),%edx
  802268:	89 50 04             	mov    %edx,0x4(%eax)
  80226b:	eb 0b                	jmp    802278 <alloc_block_FF+0x72>
  80226d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802270:	8b 40 04             	mov    0x4(%eax),%eax
  802273:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802278:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227b:	8b 40 04             	mov    0x4(%eax),%eax
  80227e:	85 c0                	test   %eax,%eax
  802280:	74 0f                	je     802291 <alloc_block_FF+0x8b>
  802282:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802285:	8b 40 04             	mov    0x4(%eax),%eax
  802288:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80228b:	8b 12                	mov    (%edx),%edx
  80228d:	89 10                	mov    %edx,(%eax)
  80228f:	eb 0a                	jmp    80229b <alloc_block_FF+0x95>
  802291:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802294:	8b 00                	mov    (%eax),%eax
  802296:	a3 38 41 80 00       	mov    %eax,0x804138
  80229b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022ae:	a1 44 41 80 00       	mov    0x804144,%eax
  8022b3:	48                   	dec    %eax
  8022b4:	a3 44 41 80 00       	mov    %eax,0x804144
			   return  point;
  8022b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022bc:	e9 10 01 00 00       	jmp    8023d1 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8022c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c4:	8b 40 0c             	mov    0xc(%eax),%eax
  8022c7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022ca:	0f 86 c6 00 00 00    	jbe    802396 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8022d0:	a1 48 41 80 00       	mov    0x804148,%eax
  8022d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8022d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022db:	8b 50 08             	mov    0x8(%eax),%edx
  8022de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022e1:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8022e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8022ea:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8022ed:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022f1:	75 17                	jne    80230a <alloc_block_FF+0x104>
  8022f3:	83 ec 04             	sub    $0x4,%esp
  8022f6:	68 b0 3f 80 00       	push   $0x803fb0
  8022fb:	68 9b 00 00 00       	push   $0x9b
  802300:	68 07 3f 80 00       	push   $0x803f07
  802305:	e8 6d df ff ff       	call   800277 <_panic>
  80230a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80230d:	8b 00                	mov    (%eax),%eax
  80230f:	85 c0                	test   %eax,%eax
  802311:	74 10                	je     802323 <alloc_block_FF+0x11d>
  802313:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802316:	8b 00                	mov    (%eax),%eax
  802318:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80231b:	8b 52 04             	mov    0x4(%edx),%edx
  80231e:	89 50 04             	mov    %edx,0x4(%eax)
  802321:	eb 0b                	jmp    80232e <alloc_block_FF+0x128>
  802323:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802326:	8b 40 04             	mov    0x4(%eax),%eax
  802329:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80232e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802331:	8b 40 04             	mov    0x4(%eax),%eax
  802334:	85 c0                	test   %eax,%eax
  802336:	74 0f                	je     802347 <alloc_block_FF+0x141>
  802338:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80233b:	8b 40 04             	mov    0x4(%eax),%eax
  80233e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802341:	8b 12                	mov    (%edx),%edx
  802343:	89 10                	mov    %edx,(%eax)
  802345:	eb 0a                	jmp    802351 <alloc_block_FF+0x14b>
  802347:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80234a:	8b 00                	mov    (%eax),%eax
  80234c:	a3 48 41 80 00       	mov    %eax,0x804148
  802351:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802354:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80235a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80235d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802364:	a1 54 41 80 00       	mov    0x804154,%eax
  802369:	48                   	dec    %eax
  80236a:	a3 54 41 80 00       	mov    %eax,0x804154
			   point->sva += size;
  80236f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802372:	8b 50 08             	mov    0x8(%eax),%edx
  802375:	8b 45 08             	mov    0x8(%ebp),%eax
  802378:	01 c2                	add    %eax,%edx
  80237a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237d:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802380:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802383:	8b 40 0c             	mov    0xc(%eax),%eax
  802386:	2b 45 08             	sub    0x8(%ebp),%eax
  802389:	89 c2                	mov    %eax,%edx
  80238b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238e:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802391:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802394:	eb 3b                	jmp    8023d1 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802396:	a1 40 41 80 00       	mov    0x804140,%eax
  80239b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80239e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023a2:	74 07                	je     8023ab <alloc_block_FF+0x1a5>
  8023a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a7:	8b 00                	mov    (%eax),%eax
  8023a9:	eb 05                	jmp    8023b0 <alloc_block_FF+0x1aa>
  8023ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8023b0:	a3 40 41 80 00       	mov    %eax,0x804140
  8023b5:	a1 40 41 80 00       	mov    0x804140,%eax
  8023ba:	85 c0                	test   %eax,%eax
  8023bc:	0f 85 57 fe ff ff    	jne    802219 <alloc_block_FF+0x13>
  8023c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023c6:	0f 85 4d fe ff ff    	jne    802219 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8023cc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023d1:	c9                   	leave  
  8023d2:	c3                   	ret    

008023d3 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8023d3:	55                   	push   %ebp
  8023d4:	89 e5                	mov    %esp,%ebp
  8023d6:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8023d9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8023e0:	a1 38 41 80 00       	mov    0x804138,%eax
  8023e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023e8:	e9 df 00 00 00       	jmp    8024cc <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8023ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f0:	8b 40 0c             	mov    0xc(%eax),%eax
  8023f3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023f6:	0f 82 c8 00 00 00    	jb     8024c4 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8023fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ff:	8b 40 0c             	mov    0xc(%eax),%eax
  802402:	3b 45 08             	cmp    0x8(%ebp),%eax
  802405:	0f 85 8a 00 00 00    	jne    802495 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  80240b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80240f:	75 17                	jne    802428 <alloc_block_BF+0x55>
  802411:	83 ec 04             	sub    $0x4,%esp
  802414:	68 b0 3f 80 00       	push   $0x803fb0
  802419:	68 b7 00 00 00       	push   $0xb7
  80241e:	68 07 3f 80 00       	push   $0x803f07
  802423:	e8 4f de ff ff       	call   800277 <_panic>
  802428:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242b:	8b 00                	mov    (%eax),%eax
  80242d:	85 c0                	test   %eax,%eax
  80242f:	74 10                	je     802441 <alloc_block_BF+0x6e>
  802431:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802434:	8b 00                	mov    (%eax),%eax
  802436:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802439:	8b 52 04             	mov    0x4(%edx),%edx
  80243c:	89 50 04             	mov    %edx,0x4(%eax)
  80243f:	eb 0b                	jmp    80244c <alloc_block_BF+0x79>
  802441:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802444:	8b 40 04             	mov    0x4(%eax),%eax
  802447:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80244c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244f:	8b 40 04             	mov    0x4(%eax),%eax
  802452:	85 c0                	test   %eax,%eax
  802454:	74 0f                	je     802465 <alloc_block_BF+0x92>
  802456:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802459:	8b 40 04             	mov    0x4(%eax),%eax
  80245c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80245f:	8b 12                	mov    (%edx),%edx
  802461:	89 10                	mov    %edx,(%eax)
  802463:	eb 0a                	jmp    80246f <alloc_block_BF+0x9c>
  802465:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802468:	8b 00                	mov    (%eax),%eax
  80246a:	a3 38 41 80 00       	mov    %eax,0x804138
  80246f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802472:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802478:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802482:	a1 44 41 80 00       	mov    0x804144,%eax
  802487:	48                   	dec    %eax
  802488:	a3 44 41 80 00       	mov    %eax,0x804144
			   return currentMemBlock;
  80248d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802490:	e9 4d 01 00 00       	jmp    8025e2 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802495:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802498:	8b 40 0c             	mov    0xc(%eax),%eax
  80249b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80249e:	76 24                	jbe    8024c4 <alloc_block_BF+0xf1>
  8024a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a3:	8b 40 0c             	mov    0xc(%eax),%eax
  8024a6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8024a9:	73 19                	jae    8024c4 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8024ab:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8024b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b5:	8b 40 0c             	mov    0xc(%eax),%eax
  8024b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8024bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024be:	8b 40 08             	mov    0x8(%eax),%eax
  8024c1:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8024c4:	a1 40 41 80 00       	mov    0x804140,%eax
  8024c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024d0:	74 07                	je     8024d9 <alloc_block_BF+0x106>
  8024d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d5:	8b 00                	mov    (%eax),%eax
  8024d7:	eb 05                	jmp    8024de <alloc_block_BF+0x10b>
  8024d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8024de:	a3 40 41 80 00       	mov    %eax,0x804140
  8024e3:	a1 40 41 80 00       	mov    0x804140,%eax
  8024e8:	85 c0                	test   %eax,%eax
  8024ea:	0f 85 fd fe ff ff    	jne    8023ed <alloc_block_BF+0x1a>
  8024f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024f4:	0f 85 f3 fe ff ff    	jne    8023ed <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8024fa:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8024fe:	0f 84 d9 00 00 00    	je     8025dd <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802504:	a1 48 41 80 00       	mov    0x804148,%eax
  802509:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  80250c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80250f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802512:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802515:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802518:	8b 55 08             	mov    0x8(%ebp),%edx
  80251b:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  80251e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802522:	75 17                	jne    80253b <alloc_block_BF+0x168>
  802524:	83 ec 04             	sub    $0x4,%esp
  802527:	68 b0 3f 80 00       	push   $0x803fb0
  80252c:	68 c7 00 00 00       	push   $0xc7
  802531:	68 07 3f 80 00       	push   $0x803f07
  802536:	e8 3c dd ff ff       	call   800277 <_panic>
  80253b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80253e:	8b 00                	mov    (%eax),%eax
  802540:	85 c0                	test   %eax,%eax
  802542:	74 10                	je     802554 <alloc_block_BF+0x181>
  802544:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802547:	8b 00                	mov    (%eax),%eax
  802549:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80254c:	8b 52 04             	mov    0x4(%edx),%edx
  80254f:	89 50 04             	mov    %edx,0x4(%eax)
  802552:	eb 0b                	jmp    80255f <alloc_block_BF+0x18c>
  802554:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802557:	8b 40 04             	mov    0x4(%eax),%eax
  80255a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80255f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802562:	8b 40 04             	mov    0x4(%eax),%eax
  802565:	85 c0                	test   %eax,%eax
  802567:	74 0f                	je     802578 <alloc_block_BF+0x1a5>
  802569:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80256c:	8b 40 04             	mov    0x4(%eax),%eax
  80256f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802572:	8b 12                	mov    (%edx),%edx
  802574:	89 10                	mov    %edx,(%eax)
  802576:	eb 0a                	jmp    802582 <alloc_block_BF+0x1af>
  802578:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80257b:	8b 00                	mov    (%eax),%eax
  80257d:	a3 48 41 80 00       	mov    %eax,0x804148
  802582:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802585:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80258b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80258e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802595:	a1 54 41 80 00       	mov    0x804154,%eax
  80259a:	48                   	dec    %eax
  80259b:	a3 54 41 80 00       	mov    %eax,0x804154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8025a0:	83 ec 08             	sub    $0x8,%esp
  8025a3:	ff 75 ec             	pushl  -0x14(%ebp)
  8025a6:	68 38 41 80 00       	push   $0x804138
  8025ab:	e8 71 f9 ff ff       	call   801f21 <find_block>
  8025b0:	83 c4 10             	add    $0x10,%esp
  8025b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8025b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025b9:	8b 50 08             	mov    0x8(%eax),%edx
  8025bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8025bf:	01 c2                	add    %eax,%edx
  8025c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025c4:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8025c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8025cd:	2b 45 08             	sub    0x8(%ebp),%eax
  8025d0:	89 c2                	mov    %eax,%edx
  8025d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025d5:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8025d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025db:	eb 05                	jmp    8025e2 <alloc_block_BF+0x20f>
	}
	return NULL;
  8025dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025e2:	c9                   	leave  
  8025e3:	c3                   	ret    

008025e4 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8025e4:	55                   	push   %ebp
  8025e5:	89 e5                	mov    %esp,%ebp
  8025e7:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8025ea:	a1 28 40 80 00       	mov    0x804028,%eax
  8025ef:	85 c0                	test   %eax,%eax
  8025f1:	0f 85 de 01 00 00    	jne    8027d5 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8025f7:	a1 38 41 80 00       	mov    0x804138,%eax
  8025fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025ff:	e9 9e 01 00 00       	jmp    8027a2 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802604:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802607:	8b 40 0c             	mov    0xc(%eax),%eax
  80260a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80260d:	0f 82 87 01 00 00    	jb     80279a <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802613:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802616:	8b 40 0c             	mov    0xc(%eax),%eax
  802619:	3b 45 08             	cmp    0x8(%ebp),%eax
  80261c:	0f 85 95 00 00 00    	jne    8026b7 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802622:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802626:	75 17                	jne    80263f <alloc_block_NF+0x5b>
  802628:	83 ec 04             	sub    $0x4,%esp
  80262b:	68 b0 3f 80 00       	push   $0x803fb0
  802630:	68 e0 00 00 00       	push   $0xe0
  802635:	68 07 3f 80 00       	push   $0x803f07
  80263a:	e8 38 dc ff ff       	call   800277 <_panic>
  80263f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802642:	8b 00                	mov    (%eax),%eax
  802644:	85 c0                	test   %eax,%eax
  802646:	74 10                	je     802658 <alloc_block_NF+0x74>
  802648:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264b:	8b 00                	mov    (%eax),%eax
  80264d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802650:	8b 52 04             	mov    0x4(%edx),%edx
  802653:	89 50 04             	mov    %edx,0x4(%eax)
  802656:	eb 0b                	jmp    802663 <alloc_block_NF+0x7f>
  802658:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265b:	8b 40 04             	mov    0x4(%eax),%eax
  80265e:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802663:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802666:	8b 40 04             	mov    0x4(%eax),%eax
  802669:	85 c0                	test   %eax,%eax
  80266b:	74 0f                	je     80267c <alloc_block_NF+0x98>
  80266d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802670:	8b 40 04             	mov    0x4(%eax),%eax
  802673:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802676:	8b 12                	mov    (%edx),%edx
  802678:	89 10                	mov    %edx,(%eax)
  80267a:	eb 0a                	jmp    802686 <alloc_block_NF+0xa2>
  80267c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267f:	8b 00                	mov    (%eax),%eax
  802681:	a3 38 41 80 00       	mov    %eax,0x804138
  802686:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802689:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80268f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802692:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802699:	a1 44 41 80 00       	mov    0x804144,%eax
  80269e:	48                   	dec    %eax
  80269f:	a3 44 41 80 00       	mov    %eax,0x804144
				   svaOfNF = point->sva;
  8026a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a7:	8b 40 08             	mov    0x8(%eax),%eax
  8026aa:	a3 28 40 80 00       	mov    %eax,0x804028
				   return  point;
  8026af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b2:	e9 f8 04 00 00       	jmp    802baf <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8026b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8026bd:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026c0:	0f 86 d4 00 00 00    	jbe    80279a <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8026c6:	a1 48 41 80 00       	mov    0x804148,%eax
  8026cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8026ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d1:	8b 50 08             	mov    0x8(%eax),%edx
  8026d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026d7:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8026da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8026e0:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8026e3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026e7:	75 17                	jne    802700 <alloc_block_NF+0x11c>
  8026e9:	83 ec 04             	sub    $0x4,%esp
  8026ec:	68 b0 3f 80 00       	push   $0x803fb0
  8026f1:	68 e9 00 00 00       	push   $0xe9
  8026f6:	68 07 3f 80 00       	push   $0x803f07
  8026fb:	e8 77 db ff ff       	call   800277 <_panic>
  802700:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802703:	8b 00                	mov    (%eax),%eax
  802705:	85 c0                	test   %eax,%eax
  802707:	74 10                	je     802719 <alloc_block_NF+0x135>
  802709:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80270c:	8b 00                	mov    (%eax),%eax
  80270e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802711:	8b 52 04             	mov    0x4(%edx),%edx
  802714:	89 50 04             	mov    %edx,0x4(%eax)
  802717:	eb 0b                	jmp    802724 <alloc_block_NF+0x140>
  802719:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80271c:	8b 40 04             	mov    0x4(%eax),%eax
  80271f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802724:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802727:	8b 40 04             	mov    0x4(%eax),%eax
  80272a:	85 c0                	test   %eax,%eax
  80272c:	74 0f                	je     80273d <alloc_block_NF+0x159>
  80272e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802731:	8b 40 04             	mov    0x4(%eax),%eax
  802734:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802737:	8b 12                	mov    (%edx),%edx
  802739:	89 10                	mov    %edx,(%eax)
  80273b:	eb 0a                	jmp    802747 <alloc_block_NF+0x163>
  80273d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802740:	8b 00                	mov    (%eax),%eax
  802742:	a3 48 41 80 00       	mov    %eax,0x804148
  802747:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80274a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802750:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802753:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80275a:	a1 54 41 80 00       	mov    0x804154,%eax
  80275f:	48                   	dec    %eax
  802760:	a3 54 41 80 00       	mov    %eax,0x804154
				   svaOfNF = ReturnedBlock->sva;
  802765:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802768:	8b 40 08             	mov    0x8(%eax),%eax
  80276b:	a3 28 40 80 00       	mov    %eax,0x804028
				   point->sva += size;
  802770:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802773:	8b 50 08             	mov    0x8(%eax),%edx
  802776:	8b 45 08             	mov    0x8(%ebp),%eax
  802779:	01 c2                	add    %eax,%edx
  80277b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277e:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802781:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802784:	8b 40 0c             	mov    0xc(%eax),%eax
  802787:	2b 45 08             	sub    0x8(%ebp),%eax
  80278a:	89 c2                	mov    %eax,%edx
  80278c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278f:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802792:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802795:	e9 15 04 00 00       	jmp    802baf <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80279a:	a1 40 41 80 00       	mov    0x804140,%eax
  80279f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027a6:	74 07                	je     8027af <alloc_block_NF+0x1cb>
  8027a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ab:	8b 00                	mov    (%eax),%eax
  8027ad:	eb 05                	jmp    8027b4 <alloc_block_NF+0x1d0>
  8027af:	b8 00 00 00 00       	mov    $0x0,%eax
  8027b4:	a3 40 41 80 00       	mov    %eax,0x804140
  8027b9:	a1 40 41 80 00       	mov    0x804140,%eax
  8027be:	85 c0                	test   %eax,%eax
  8027c0:	0f 85 3e fe ff ff    	jne    802604 <alloc_block_NF+0x20>
  8027c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027ca:	0f 85 34 fe ff ff    	jne    802604 <alloc_block_NF+0x20>
  8027d0:	e9 d5 03 00 00       	jmp    802baa <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8027d5:	a1 38 41 80 00       	mov    0x804138,%eax
  8027da:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027dd:	e9 b1 01 00 00       	jmp    802993 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8027e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e5:	8b 50 08             	mov    0x8(%eax),%edx
  8027e8:	a1 28 40 80 00       	mov    0x804028,%eax
  8027ed:	39 c2                	cmp    %eax,%edx
  8027ef:	0f 82 96 01 00 00    	jb     80298b <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  8027f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f8:	8b 40 0c             	mov    0xc(%eax),%eax
  8027fb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027fe:	0f 82 87 01 00 00    	jb     80298b <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802804:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802807:	8b 40 0c             	mov    0xc(%eax),%eax
  80280a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80280d:	0f 85 95 00 00 00    	jne    8028a8 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802813:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802817:	75 17                	jne    802830 <alloc_block_NF+0x24c>
  802819:	83 ec 04             	sub    $0x4,%esp
  80281c:	68 b0 3f 80 00       	push   $0x803fb0
  802821:	68 fc 00 00 00       	push   $0xfc
  802826:	68 07 3f 80 00       	push   $0x803f07
  80282b:	e8 47 da ff ff       	call   800277 <_panic>
  802830:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802833:	8b 00                	mov    (%eax),%eax
  802835:	85 c0                	test   %eax,%eax
  802837:	74 10                	je     802849 <alloc_block_NF+0x265>
  802839:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283c:	8b 00                	mov    (%eax),%eax
  80283e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802841:	8b 52 04             	mov    0x4(%edx),%edx
  802844:	89 50 04             	mov    %edx,0x4(%eax)
  802847:	eb 0b                	jmp    802854 <alloc_block_NF+0x270>
  802849:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284c:	8b 40 04             	mov    0x4(%eax),%eax
  80284f:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802854:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802857:	8b 40 04             	mov    0x4(%eax),%eax
  80285a:	85 c0                	test   %eax,%eax
  80285c:	74 0f                	je     80286d <alloc_block_NF+0x289>
  80285e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802861:	8b 40 04             	mov    0x4(%eax),%eax
  802864:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802867:	8b 12                	mov    (%edx),%edx
  802869:	89 10                	mov    %edx,(%eax)
  80286b:	eb 0a                	jmp    802877 <alloc_block_NF+0x293>
  80286d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802870:	8b 00                	mov    (%eax),%eax
  802872:	a3 38 41 80 00       	mov    %eax,0x804138
  802877:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802880:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802883:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80288a:	a1 44 41 80 00       	mov    0x804144,%eax
  80288f:	48                   	dec    %eax
  802890:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  802895:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802898:	8b 40 08             	mov    0x8(%eax),%eax
  80289b:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  8028a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a3:	e9 07 03 00 00       	jmp    802baf <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8028a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ab:	8b 40 0c             	mov    0xc(%eax),%eax
  8028ae:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028b1:	0f 86 d4 00 00 00    	jbe    80298b <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8028b7:	a1 48 41 80 00       	mov    0x804148,%eax
  8028bc:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  8028bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c2:	8b 50 08             	mov    0x8(%eax),%edx
  8028c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028c8:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8028cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8028d1:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8028d4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8028d8:	75 17                	jne    8028f1 <alloc_block_NF+0x30d>
  8028da:	83 ec 04             	sub    $0x4,%esp
  8028dd:	68 b0 3f 80 00       	push   $0x803fb0
  8028e2:	68 04 01 00 00       	push   $0x104
  8028e7:	68 07 3f 80 00       	push   $0x803f07
  8028ec:	e8 86 d9 ff ff       	call   800277 <_panic>
  8028f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028f4:	8b 00                	mov    (%eax),%eax
  8028f6:	85 c0                	test   %eax,%eax
  8028f8:	74 10                	je     80290a <alloc_block_NF+0x326>
  8028fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028fd:	8b 00                	mov    (%eax),%eax
  8028ff:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802902:	8b 52 04             	mov    0x4(%edx),%edx
  802905:	89 50 04             	mov    %edx,0x4(%eax)
  802908:	eb 0b                	jmp    802915 <alloc_block_NF+0x331>
  80290a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80290d:	8b 40 04             	mov    0x4(%eax),%eax
  802910:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802915:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802918:	8b 40 04             	mov    0x4(%eax),%eax
  80291b:	85 c0                	test   %eax,%eax
  80291d:	74 0f                	je     80292e <alloc_block_NF+0x34a>
  80291f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802922:	8b 40 04             	mov    0x4(%eax),%eax
  802925:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802928:	8b 12                	mov    (%edx),%edx
  80292a:	89 10                	mov    %edx,(%eax)
  80292c:	eb 0a                	jmp    802938 <alloc_block_NF+0x354>
  80292e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802931:	8b 00                	mov    (%eax),%eax
  802933:	a3 48 41 80 00       	mov    %eax,0x804148
  802938:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80293b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802941:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802944:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80294b:	a1 54 41 80 00       	mov    0x804154,%eax
  802950:	48                   	dec    %eax
  802951:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  802956:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802959:	8b 40 08             	mov    0x8(%eax),%eax
  80295c:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  802961:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802964:	8b 50 08             	mov    0x8(%eax),%edx
  802967:	8b 45 08             	mov    0x8(%ebp),%eax
  80296a:	01 c2                	add    %eax,%edx
  80296c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296f:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802972:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802975:	8b 40 0c             	mov    0xc(%eax),%eax
  802978:	2b 45 08             	sub    0x8(%ebp),%eax
  80297b:	89 c2                	mov    %eax,%edx
  80297d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802980:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802983:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802986:	e9 24 02 00 00       	jmp    802baf <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  80298b:	a1 40 41 80 00       	mov    0x804140,%eax
  802990:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802993:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802997:	74 07                	je     8029a0 <alloc_block_NF+0x3bc>
  802999:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299c:	8b 00                	mov    (%eax),%eax
  80299e:	eb 05                	jmp    8029a5 <alloc_block_NF+0x3c1>
  8029a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8029a5:	a3 40 41 80 00       	mov    %eax,0x804140
  8029aa:	a1 40 41 80 00       	mov    0x804140,%eax
  8029af:	85 c0                	test   %eax,%eax
  8029b1:	0f 85 2b fe ff ff    	jne    8027e2 <alloc_block_NF+0x1fe>
  8029b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029bb:	0f 85 21 fe ff ff    	jne    8027e2 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8029c1:	a1 38 41 80 00       	mov    0x804138,%eax
  8029c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029c9:	e9 ae 01 00 00       	jmp    802b7c <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  8029ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d1:	8b 50 08             	mov    0x8(%eax),%edx
  8029d4:	a1 28 40 80 00       	mov    0x804028,%eax
  8029d9:	39 c2                	cmp    %eax,%edx
  8029db:	0f 83 93 01 00 00    	jae    802b74 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  8029e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e4:	8b 40 0c             	mov    0xc(%eax),%eax
  8029e7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029ea:	0f 82 84 01 00 00    	jb     802b74 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  8029f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f3:	8b 40 0c             	mov    0xc(%eax),%eax
  8029f6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029f9:	0f 85 95 00 00 00    	jne    802a94 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8029ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a03:	75 17                	jne    802a1c <alloc_block_NF+0x438>
  802a05:	83 ec 04             	sub    $0x4,%esp
  802a08:	68 b0 3f 80 00       	push   $0x803fb0
  802a0d:	68 14 01 00 00       	push   $0x114
  802a12:	68 07 3f 80 00       	push   $0x803f07
  802a17:	e8 5b d8 ff ff       	call   800277 <_panic>
  802a1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1f:	8b 00                	mov    (%eax),%eax
  802a21:	85 c0                	test   %eax,%eax
  802a23:	74 10                	je     802a35 <alloc_block_NF+0x451>
  802a25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a28:	8b 00                	mov    (%eax),%eax
  802a2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a2d:	8b 52 04             	mov    0x4(%edx),%edx
  802a30:	89 50 04             	mov    %edx,0x4(%eax)
  802a33:	eb 0b                	jmp    802a40 <alloc_block_NF+0x45c>
  802a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a38:	8b 40 04             	mov    0x4(%eax),%eax
  802a3b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a43:	8b 40 04             	mov    0x4(%eax),%eax
  802a46:	85 c0                	test   %eax,%eax
  802a48:	74 0f                	je     802a59 <alloc_block_NF+0x475>
  802a4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4d:	8b 40 04             	mov    0x4(%eax),%eax
  802a50:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a53:	8b 12                	mov    (%edx),%edx
  802a55:	89 10                	mov    %edx,(%eax)
  802a57:	eb 0a                	jmp    802a63 <alloc_block_NF+0x47f>
  802a59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5c:	8b 00                	mov    (%eax),%eax
  802a5e:	a3 38 41 80 00       	mov    %eax,0x804138
  802a63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a66:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a76:	a1 44 41 80 00       	mov    0x804144,%eax
  802a7b:	48                   	dec    %eax
  802a7c:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  802a81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a84:	8b 40 08             	mov    0x8(%eax),%eax
  802a87:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  802a8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8f:	e9 1b 01 00 00       	jmp    802baf <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802a94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a97:	8b 40 0c             	mov    0xc(%eax),%eax
  802a9a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a9d:	0f 86 d1 00 00 00    	jbe    802b74 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802aa3:	a1 48 41 80 00       	mov    0x804148,%eax
  802aa8:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802aab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aae:	8b 50 08             	mov    0x8(%eax),%edx
  802ab1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ab4:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802ab7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aba:	8b 55 08             	mov    0x8(%ebp),%edx
  802abd:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802ac0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802ac4:	75 17                	jne    802add <alloc_block_NF+0x4f9>
  802ac6:	83 ec 04             	sub    $0x4,%esp
  802ac9:	68 b0 3f 80 00       	push   $0x803fb0
  802ace:	68 1c 01 00 00       	push   $0x11c
  802ad3:	68 07 3f 80 00       	push   $0x803f07
  802ad8:	e8 9a d7 ff ff       	call   800277 <_panic>
  802add:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ae0:	8b 00                	mov    (%eax),%eax
  802ae2:	85 c0                	test   %eax,%eax
  802ae4:	74 10                	je     802af6 <alloc_block_NF+0x512>
  802ae6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ae9:	8b 00                	mov    (%eax),%eax
  802aeb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802aee:	8b 52 04             	mov    0x4(%edx),%edx
  802af1:	89 50 04             	mov    %edx,0x4(%eax)
  802af4:	eb 0b                	jmp    802b01 <alloc_block_NF+0x51d>
  802af6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802af9:	8b 40 04             	mov    0x4(%eax),%eax
  802afc:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b01:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b04:	8b 40 04             	mov    0x4(%eax),%eax
  802b07:	85 c0                	test   %eax,%eax
  802b09:	74 0f                	je     802b1a <alloc_block_NF+0x536>
  802b0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b0e:	8b 40 04             	mov    0x4(%eax),%eax
  802b11:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b14:	8b 12                	mov    (%edx),%edx
  802b16:	89 10                	mov    %edx,(%eax)
  802b18:	eb 0a                	jmp    802b24 <alloc_block_NF+0x540>
  802b1a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b1d:	8b 00                	mov    (%eax),%eax
  802b1f:	a3 48 41 80 00       	mov    %eax,0x804148
  802b24:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b27:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b30:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b37:	a1 54 41 80 00       	mov    0x804154,%eax
  802b3c:	48                   	dec    %eax
  802b3d:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  802b42:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b45:	8b 40 08             	mov    0x8(%eax),%eax
  802b48:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  802b4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b50:	8b 50 08             	mov    0x8(%eax),%edx
  802b53:	8b 45 08             	mov    0x8(%ebp),%eax
  802b56:	01 c2                	add    %eax,%edx
  802b58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5b:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802b5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b61:	8b 40 0c             	mov    0xc(%eax),%eax
  802b64:	2b 45 08             	sub    0x8(%ebp),%eax
  802b67:	89 c2                	mov    %eax,%edx
  802b69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6c:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802b6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b72:	eb 3b                	jmp    802baf <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b74:	a1 40 41 80 00       	mov    0x804140,%eax
  802b79:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b7c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b80:	74 07                	je     802b89 <alloc_block_NF+0x5a5>
  802b82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b85:	8b 00                	mov    (%eax),%eax
  802b87:	eb 05                	jmp    802b8e <alloc_block_NF+0x5aa>
  802b89:	b8 00 00 00 00       	mov    $0x0,%eax
  802b8e:	a3 40 41 80 00       	mov    %eax,0x804140
  802b93:	a1 40 41 80 00       	mov    0x804140,%eax
  802b98:	85 c0                	test   %eax,%eax
  802b9a:	0f 85 2e fe ff ff    	jne    8029ce <alloc_block_NF+0x3ea>
  802ba0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ba4:	0f 85 24 fe ff ff    	jne    8029ce <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802baa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802baf:	c9                   	leave  
  802bb0:	c3                   	ret    

00802bb1 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802bb1:	55                   	push   %ebp
  802bb2:	89 e5                	mov    %esp,%ebp
  802bb4:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802bb7:	a1 38 41 80 00       	mov    0x804138,%eax
  802bbc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802bbf:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802bc4:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802bc7:	a1 38 41 80 00       	mov    0x804138,%eax
  802bcc:	85 c0                	test   %eax,%eax
  802bce:	74 14                	je     802be4 <insert_sorted_with_merge_freeList+0x33>
  802bd0:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd3:	8b 50 08             	mov    0x8(%eax),%edx
  802bd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd9:	8b 40 08             	mov    0x8(%eax),%eax
  802bdc:	39 c2                	cmp    %eax,%edx
  802bde:	0f 87 9b 01 00 00    	ja     802d7f <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802be4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802be8:	75 17                	jne    802c01 <insert_sorted_with_merge_freeList+0x50>
  802bea:	83 ec 04             	sub    $0x4,%esp
  802bed:	68 e4 3e 80 00       	push   $0x803ee4
  802bf2:	68 38 01 00 00       	push   $0x138
  802bf7:	68 07 3f 80 00       	push   $0x803f07
  802bfc:	e8 76 d6 ff ff       	call   800277 <_panic>
  802c01:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802c07:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0a:	89 10                	mov    %edx,(%eax)
  802c0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0f:	8b 00                	mov    (%eax),%eax
  802c11:	85 c0                	test   %eax,%eax
  802c13:	74 0d                	je     802c22 <insert_sorted_with_merge_freeList+0x71>
  802c15:	a1 38 41 80 00       	mov    0x804138,%eax
  802c1a:	8b 55 08             	mov    0x8(%ebp),%edx
  802c1d:	89 50 04             	mov    %edx,0x4(%eax)
  802c20:	eb 08                	jmp    802c2a <insert_sorted_with_merge_freeList+0x79>
  802c22:	8b 45 08             	mov    0x8(%ebp),%eax
  802c25:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2d:	a3 38 41 80 00       	mov    %eax,0x804138
  802c32:	8b 45 08             	mov    0x8(%ebp),%eax
  802c35:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c3c:	a1 44 41 80 00       	mov    0x804144,%eax
  802c41:	40                   	inc    %eax
  802c42:	a3 44 41 80 00       	mov    %eax,0x804144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802c47:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c4b:	0f 84 a8 06 00 00    	je     8032f9 <insert_sorted_with_merge_freeList+0x748>
  802c51:	8b 45 08             	mov    0x8(%ebp),%eax
  802c54:	8b 50 08             	mov    0x8(%eax),%edx
  802c57:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5a:	8b 40 0c             	mov    0xc(%eax),%eax
  802c5d:	01 c2                	add    %eax,%edx
  802c5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c62:	8b 40 08             	mov    0x8(%eax),%eax
  802c65:	39 c2                	cmp    %eax,%edx
  802c67:	0f 85 8c 06 00 00    	jne    8032f9 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c70:	8b 50 0c             	mov    0xc(%eax),%edx
  802c73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c76:	8b 40 0c             	mov    0xc(%eax),%eax
  802c79:	01 c2                	add    %eax,%edx
  802c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7e:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802c81:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c85:	75 17                	jne    802c9e <insert_sorted_with_merge_freeList+0xed>
  802c87:	83 ec 04             	sub    $0x4,%esp
  802c8a:	68 b0 3f 80 00       	push   $0x803fb0
  802c8f:	68 3c 01 00 00       	push   $0x13c
  802c94:	68 07 3f 80 00       	push   $0x803f07
  802c99:	e8 d9 d5 ff ff       	call   800277 <_panic>
  802c9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ca1:	8b 00                	mov    (%eax),%eax
  802ca3:	85 c0                	test   %eax,%eax
  802ca5:	74 10                	je     802cb7 <insert_sorted_with_merge_freeList+0x106>
  802ca7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802caa:	8b 00                	mov    (%eax),%eax
  802cac:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802caf:	8b 52 04             	mov    0x4(%edx),%edx
  802cb2:	89 50 04             	mov    %edx,0x4(%eax)
  802cb5:	eb 0b                	jmp    802cc2 <insert_sorted_with_merge_freeList+0x111>
  802cb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cba:	8b 40 04             	mov    0x4(%eax),%eax
  802cbd:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802cc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cc5:	8b 40 04             	mov    0x4(%eax),%eax
  802cc8:	85 c0                	test   %eax,%eax
  802cca:	74 0f                	je     802cdb <insert_sorted_with_merge_freeList+0x12a>
  802ccc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ccf:	8b 40 04             	mov    0x4(%eax),%eax
  802cd2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cd5:	8b 12                	mov    (%edx),%edx
  802cd7:	89 10                	mov    %edx,(%eax)
  802cd9:	eb 0a                	jmp    802ce5 <insert_sorted_with_merge_freeList+0x134>
  802cdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cde:	8b 00                	mov    (%eax),%eax
  802ce0:	a3 38 41 80 00       	mov    %eax,0x804138
  802ce5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ce8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cf8:	a1 44 41 80 00       	mov    0x804144,%eax
  802cfd:	48                   	dec    %eax
  802cfe:	a3 44 41 80 00       	mov    %eax,0x804144
			head->size = 0;
  802d03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d06:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802d0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d10:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802d17:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d1b:	75 17                	jne    802d34 <insert_sorted_with_merge_freeList+0x183>
  802d1d:	83 ec 04             	sub    $0x4,%esp
  802d20:	68 e4 3e 80 00       	push   $0x803ee4
  802d25:	68 3f 01 00 00       	push   $0x13f
  802d2a:	68 07 3f 80 00       	push   $0x803f07
  802d2f:	e8 43 d5 ff ff       	call   800277 <_panic>
  802d34:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d3d:	89 10                	mov    %edx,(%eax)
  802d3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d42:	8b 00                	mov    (%eax),%eax
  802d44:	85 c0                	test   %eax,%eax
  802d46:	74 0d                	je     802d55 <insert_sorted_with_merge_freeList+0x1a4>
  802d48:	a1 48 41 80 00       	mov    0x804148,%eax
  802d4d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d50:	89 50 04             	mov    %edx,0x4(%eax)
  802d53:	eb 08                	jmp    802d5d <insert_sorted_with_merge_freeList+0x1ac>
  802d55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d58:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d60:	a3 48 41 80 00       	mov    %eax,0x804148
  802d65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d68:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d6f:	a1 54 41 80 00       	mov    0x804154,%eax
  802d74:	40                   	inc    %eax
  802d75:	a3 54 41 80 00       	mov    %eax,0x804154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802d7a:	e9 7a 05 00 00       	jmp    8032f9 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d82:	8b 50 08             	mov    0x8(%eax),%edx
  802d85:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d88:	8b 40 08             	mov    0x8(%eax),%eax
  802d8b:	39 c2                	cmp    %eax,%edx
  802d8d:	0f 82 14 01 00 00    	jb     802ea7 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802d93:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d96:	8b 50 08             	mov    0x8(%eax),%edx
  802d99:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d9c:	8b 40 0c             	mov    0xc(%eax),%eax
  802d9f:	01 c2                	add    %eax,%edx
  802da1:	8b 45 08             	mov    0x8(%ebp),%eax
  802da4:	8b 40 08             	mov    0x8(%eax),%eax
  802da7:	39 c2                	cmp    %eax,%edx
  802da9:	0f 85 90 00 00 00    	jne    802e3f <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802daf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802db2:	8b 50 0c             	mov    0xc(%eax),%edx
  802db5:	8b 45 08             	mov    0x8(%ebp),%eax
  802db8:	8b 40 0c             	mov    0xc(%eax),%eax
  802dbb:	01 c2                	add    %eax,%edx
  802dbd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dc0:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802dd7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ddb:	75 17                	jne    802df4 <insert_sorted_with_merge_freeList+0x243>
  802ddd:	83 ec 04             	sub    $0x4,%esp
  802de0:	68 e4 3e 80 00       	push   $0x803ee4
  802de5:	68 49 01 00 00       	push   $0x149
  802dea:	68 07 3f 80 00       	push   $0x803f07
  802def:	e8 83 d4 ff ff       	call   800277 <_panic>
  802df4:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfd:	89 10                	mov    %edx,(%eax)
  802dff:	8b 45 08             	mov    0x8(%ebp),%eax
  802e02:	8b 00                	mov    (%eax),%eax
  802e04:	85 c0                	test   %eax,%eax
  802e06:	74 0d                	je     802e15 <insert_sorted_with_merge_freeList+0x264>
  802e08:	a1 48 41 80 00       	mov    0x804148,%eax
  802e0d:	8b 55 08             	mov    0x8(%ebp),%edx
  802e10:	89 50 04             	mov    %edx,0x4(%eax)
  802e13:	eb 08                	jmp    802e1d <insert_sorted_with_merge_freeList+0x26c>
  802e15:	8b 45 08             	mov    0x8(%ebp),%eax
  802e18:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e20:	a3 48 41 80 00       	mov    %eax,0x804148
  802e25:	8b 45 08             	mov    0x8(%ebp),%eax
  802e28:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e2f:	a1 54 41 80 00       	mov    0x804154,%eax
  802e34:	40                   	inc    %eax
  802e35:	a3 54 41 80 00       	mov    %eax,0x804154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802e3a:	e9 bb 04 00 00       	jmp    8032fa <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802e3f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e43:	75 17                	jne    802e5c <insert_sorted_with_merge_freeList+0x2ab>
  802e45:	83 ec 04             	sub    $0x4,%esp
  802e48:	68 58 3f 80 00       	push   $0x803f58
  802e4d:	68 4c 01 00 00       	push   $0x14c
  802e52:	68 07 3f 80 00       	push   $0x803f07
  802e57:	e8 1b d4 ff ff       	call   800277 <_panic>
  802e5c:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802e62:	8b 45 08             	mov    0x8(%ebp),%eax
  802e65:	89 50 04             	mov    %edx,0x4(%eax)
  802e68:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6b:	8b 40 04             	mov    0x4(%eax),%eax
  802e6e:	85 c0                	test   %eax,%eax
  802e70:	74 0c                	je     802e7e <insert_sorted_with_merge_freeList+0x2cd>
  802e72:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802e77:	8b 55 08             	mov    0x8(%ebp),%edx
  802e7a:	89 10                	mov    %edx,(%eax)
  802e7c:	eb 08                	jmp    802e86 <insert_sorted_with_merge_freeList+0x2d5>
  802e7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e81:	a3 38 41 80 00       	mov    %eax,0x804138
  802e86:	8b 45 08             	mov    0x8(%ebp),%eax
  802e89:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e91:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e97:	a1 44 41 80 00       	mov    0x804144,%eax
  802e9c:	40                   	inc    %eax
  802e9d:	a3 44 41 80 00       	mov    %eax,0x804144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802ea2:	e9 53 04 00 00       	jmp    8032fa <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802ea7:	a1 38 41 80 00       	mov    0x804138,%eax
  802eac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802eaf:	e9 15 04 00 00       	jmp    8032c9 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802eb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb7:	8b 00                	mov    (%eax),%eax
  802eb9:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802ebc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebf:	8b 50 08             	mov    0x8(%eax),%edx
  802ec2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec5:	8b 40 08             	mov    0x8(%eax),%eax
  802ec8:	39 c2                	cmp    %eax,%edx
  802eca:	0f 86 f1 03 00 00    	jbe    8032c1 <insert_sorted_with_merge_freeList+0x710>
  802ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed3:	8b 50 08             	mov    0x8(%eax),%edx
  802ed6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ed9:	8b 40 08             	mov    0x8(%eax),%eax
  802edc:	39 c2                	cmp    %eax,%edx
  802ede:	0f 83 dd 03 00 00    	jae    8032c1 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802ee4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee7:	8b 50 08             	mov    0x8(%eax),%edx
  802eea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eed:	8b 40 0c             	mov    0xc(%eax),%eax
  802ef0:	01 c2                	add    %eax,%edx
  802ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef5:	8b 40 08             	mov    0x8(%eax),%eax
  802ef8:	39 c2                	cmp    %eax,%edx
  802efa:	0f 85 b9 01 00 00    	jne    8030b9 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802f00:	8b 45 08             	mov    0x8(%ebp),%eax
  802f03:	8b 50 08             	mov    0x8(%eax),%edx
  802f06:	8b 45 08             	mov    0x8(%ebp),%eax
  802f09:	8b 40 0c             	mov    0xc(%eax),%eax
  802f0c:	01 c2                	add    %eax,%edx
  802f0e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f11:	8b 40 08             	mov    0x8(%eax),%eax
  802f14:	39 c2                	cmp    %eax,%edx
  802f16:	0f 85 0d 01 00 00    	jne    803029 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802f1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1f:	8b 50 0c             	mov    0xc(%eax),%edx
  802f22:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f25:	8b 40 0c             	mov    0xc(%eax),%eax
  802f28:	01 c2                	add    %eax,%edx
  802f2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2d:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802f30:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f34:	75 17                	jne    802f4d <insert_sorted_with_merge_freeList+0x39c>
  802f36:	83 ec 04             	sub    $0x4,%esp
  802f39:	68 b0 3f 80 00       	push   $0x803fb0
  802f3e:	68 5c 01 00 00       	push   $0x15c
  802f43:	68 07 3f 80 00       	push   $0x803f07
  802f48:	e8 2a d3 ff ff       	call   800277 <_panic>
  802f4d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f50:	8b 00                	mov    (%eax),%eax
  802f52:	85 c0                	test   %eax,%eax
  802f54:	74 10                	je     802f66 <insert_sorted_with_merge_freeList+0x3b5>
  802f56:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f59:	8b 00                	mov    (%eax),%eax
  802f5b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f5e:	8b 52 04             	mov    0x4(%edx),%edx
  802f61:	89 50 04             	mov    %edx,0x4(%eax)
  802f64:	eb 0b                	jmp    802f71 <insert_sorted_with_merge_freeList+0x3c0>
  802f66:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f69:	8b 40 04             	mov    0x4(%eax),%eax
  802f6c:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802f71:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f74:	8b 40 04             	mov    0x4(%eax),%eax
  802f77:	85 c0                	test   %eax,%eax
  802f79:	74 0f                	je     802f8a <insert_sorted_with_merge_freeList+0x3d9>
  802f7b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f7e:	8b 40 04             	mov    0x4(%eax),%eax
  802f81:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f84:	8b 12                	mov    (%edx),%edx
  802f86:	89 10                	mov    %edx,(%eax)
  802f88:	eb 0a                	jmp    802f94 <insert_sorted_with_merge_freeList+0x3e3>
  802f8a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f8d:	8b 00                	mov    (%eax),%eax
  802f8f:	a3 38 41 80 00       	mov    %eax,0x804138
  802f94:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f97:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f9d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fa0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fa7:	a1 44 41 80 00       	mov    0x804144,%eax
  802fac:	48                   	dec    %eax
  802fad:	a3 44 41 80 00       	mov    %eax,0x804144
						nextBlock->sva = 0;
  802fb2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fb5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  802fbc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fbf:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  802fc6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802fca:	75 17                	jne    802fe3 <insert_sorted_with_merge_freeList+0x432>
  802fcc:	83 ec 04             	sub    $0x4,%esp
  802fcf:	68 e4 3e 80 00       	push   $0x803ee4
  802fd4:	68 5f 01 00 00       	push   $0x15f
  802fd9:	68 07 3f 80 00       	push   $0x803f07
  802fde:	e8 94 d2 ff ff       	call   800277 <_panic>
  802fe3:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802fe9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fec:	89 10                	mov    %edx,(%eax)
  802fee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ff1:	8b 00                	mov    (%eax),%eax
  802ff3:	85 c0                	test   %eax,%eax
  802ff5:	74 0d                	je     803004 <insert_sorted_with_merge_freeList+0x453>
  802ff7:	a1 48 41 80 00       	mov    0x804148,%eax
  802ffc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fff:	89 50 04             	mov    %edx,0x4(%eax)
  803002:	eb 08                	jmp    80300c <insert_sorted_with_merge_freeList+0x45b>
  803004:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803007:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80300c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80300f:	a3 48 41 80 00       	mov    %eax,0x804148
  803014:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803017:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80301e:	a1 54 41 80 00       	mov    0x804154,%eax
  803023:	40                   	inc    %eax
  803024:	a3 54 41 80 00       	mov    %eax,0x804154
					}
					currentBlock->size += blockToInsert->size;
  803029:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80302c:	8b 50 0c             	mov    0xc(%eax),%edx
  80302f:	8b 45 08             	mov    0x8(%ebp),%eax
  803032:	8b 40 0c             	mov    0xc(%eax),%eax
  803035:	01 c2                	add    %eax,%edx
  803037:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303a:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  80303d:	8b 45 08             	mov    0x8(%ebp),%eax
  803040:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803047:	8b 45 08             	mov    0x8(%ebp),%eax
  80304a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803051:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803055:	75 17                	jne    80306e <insert_sorted_with_merge_freeList+0x4bd>
  803057:	83 ec 04             	sub    $0x4,%esp
  80305a:	68 e4 3e 80 00       	push   $0x803ee4
  80305f:	68 64 01 00 00       	push   $0x164
  803064:	68 07 3f 80 00       	push   $0x803f07
  803069:	e8 09 d2 ff ff       	call   800277 <_panic>
  80306e:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803074:	8b 45 08             	mov    0x8(%ebp),%eax
  803077:	89 10                	mov    %edx,(%eax)
  803079:	8b 45 08             	mov    0x8(%ebp),%eax
  80307c:	8b 00                	mov    (%eax),%eax
  80307e:	85 c0                	test   %eax,%eax
  803080:	74 0d                	je     80308f <insert_sorted_with_merge_freeList+0x4de>
  803082:	a1 48 41 80 00       	mov    0x804148,%eax
  803087:	8b 55 08             	mov    0x8(%ebp),%edx
  80308a:	89 50 04             	mov    %edx,0x4(%eax)
  80308d:	eb 08                	jmp    803097 <insert_sorted_with_merge_freeList+0x4e6>
  80308f:	8b 45 08             	mov    0x8(%ebp),%eax
  803092:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803097:	8b 45 08             	mov    0x8(%ebp),%eax
  80309a:	a3 48 41 80 00       	mov    %eax,0x804148
  80309f:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030a9:	a1 54 41 80 00       	mov    0x804154,%eax
  8030ae:	40                   	inc    %eax
  8030af:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  8030b4:	e9 41 02 00 00       	jmp    8032fa <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8030b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030bc:	8b 50 08             	mov    0x8(%eax),%edx
  8030bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c2:	8b 40 0c             	mov    0xc(%eax),%eax
  8030c5:	01 c2                	add    %eax,%edx
  8030c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ca:	8b 40 08             	mov    0x8(%eax),%eax
  8030cd:	39 c2                	cmp    %eax,%edx
  8030cf:	0f 85 7c 01 00 00    	jne    803251 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8030d5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030d9:	74 06                	je     8030e1 <insert_sorted_with_merge_freeList+0x530>
  8030db:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030df:	75 17                	jne    8030f8 <insert_sorted_with_merge_freeList+0x547>
  8030e1:	83 ec 04             	sub    $0x4,%esp
  8030e4:	68 20 3f 80 00       	push   $0x803f20
  8030e9:	68 69 01 00 00       	push   $0x169
  8030ee:	68 07 3f 80 00       	push   $0x803f07
  8030f3:	e8 7f d1 ff ff       	call   800277 <_panic>
  8030f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030fb:	8b 50 04             	mov    0x4(%eax),%edx
  8030fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803101:	89 50 04             	mov    %edx,0x4(%eax)
  803104:	8b 45 08             	mov    0x8(%ebp),%eax
  803107:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80310a:	89 10                	mov    %edx,(%eax)
  80310c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80310f:	8b 40 04             	mov    0x4(%eax),%eax
  803112:	85 c0                	test   %eax,%eax
  803114:	74 0d                	je     803123 <insert_sorted_with_merge_freeList+0x572>
  803116:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803119:	8b 40 04             	mov    0x4(%eax),%eax
  80311c:	8b 55 08             	mov    0x8(%ebp),%edx
  80311f:	89 10                	mov    %edx,(%eax)
  803121:	eb 08                	jmp    80312b <insert_sorted_with_merge_freeList+0x57a>
  803123:	8b 45 08             	mov    0x8(%ebp),%eax
  803126:	a3 38 41 80 00       	mov    %eax,0x804138
  80312b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80312e:	8b 55 08             	mov    0x8(%ebp),%edx
  803131:	89 50 04             	mov    %edx,0x4(%eax)
  803134:	a1 44 41 80 00       	mov    0x804144,%eax
  803139:	40                   	inc    %eax
  80313a:	a3 44 41 80 00       	mov    %eax,0x804144
					blockToInsert->size += nextBlock->size;
  80313f:	8b 45 08             	mov    0x8(%ebp),%eax
  803142:	8b 50 0c             	mov    0xc(%eax),%edx
  803145:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803148:	8b 40 0c             	mov    0xc(%eax),%eax
  80314b:	01 c2                	add    %eax,%edx
  80314d:	8b 45 08             	mov    0x8(%ebp),%eax
  803150:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803153:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803157:	75 17                	jne    803170 <insert_sorted_with_merge_freeList+0x5bf>
  803159:	83 ec 04             	sub    $0x4,%esp
  80315c:	68 b0 3f 80 00       	push   $0x803fb0
  803161:	68 6b 01 00 00       	push   $0x16b
  803166:	68 07 3f 80 00       	push   $0x803f07
  80316b:	e8 07 d1 ff ff       	call   800277 <_panic>
  803170:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803173:	8b 00                	mov    (%eax),%eax
  803175:	85 c0                	test   %eax,%eax
  803177:	74 10                	je     803189 <insert_sorted_with_merge_freeList+0x5d8>
  803179:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80317c:	8b 00                	mov    (%eax),%eax
  80317e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803181:	8b 52 04             	mov    0x4(%edx),%edx
  803184:	89 50 04             	mov    %edx,0x4(%eax)
  803187:	eb 0b                	jmp    803194 <insert_sorted_with_merge_freeList+0x5e3>
  803189:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80318c:	8b 40 04             	mov    0x4(%eax),%eax
  80318f:	a3 3c 41 80 00       	mov    %eax,0x80413c
  803194:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803197:	8b 40 04             	mov    0x4(%eax),%eax
  80319a:	85 c0                	test   %eax,%eax
  80319c:	74 0f                	je     8031ad <insert_sorted_with_merge_freeList+0x5fc>
  80319e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031a1:	8b 40 04             	mov    0x4(%eax),%eax
  8031a4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031a7:	8b 12                	mov    (%edx),%edx
  8031a9:	89 10                	mov    %edx,(%eax)
  8031ab:	eb 0a                	jmp    8031b7 <insert_sorted_with_merge_freeList+0x606>
  8031ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031b0:	8b 00                	mov    (%eax),%eax
  8031b2:	a3 38 41 80 00       	mov    %eax,0x804138
  8031b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031ca:	a1 44 41 80 00       	mov    0x804144,%eax
  8031cf:	48                   	dec    %eax
  8031d0:	a3 44 41 80 00       	mov    %eax,0x804144
					nextBlock->sva = 0;
  8031d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8031df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8031e9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031ed:	75 17                	jne    803206 <insert_sorted_with_merge_freeList+0x655>
  8031ef:	83 ec 04             	sub    $0x4,%esp
  8031f2:	68 e4 3e 80 00       	push   $0x803ee4
  8031f7:	68 6e 01 00 00       	push   $0x16e
  8031fc:	68 07 3f 80 00       	push   $0x803f07
  803201:	e8 71 d0 ff ff       	call   800277 <_panic>
  803206:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80320c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80320f:	89 10                	mov    %edx,(%eax)
  803211:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803214:	8b 00                	mov    (%eax),%eax
  803216:	85 c0                	test   %eax,%eax
  803218:	74 0d                	je     803227 <insert_sorted_with_merge_freeList+0x676>
  80321a:	a1 48 41 80 00       	mov    0x804148,%eax
  80321f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803222:	89 50 04             	mov    %edx,0x4(%eax)
  803225:	eb 08                	jmp    80322f <insert_sorted_with_merge_freeList+0x67e>
  803227:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80322a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80322f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803232:	a3 48 41 80 00       	mov    %eax,0x804148
  803237:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80323a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803241:	a1 54 41 80 00       	mov    0x804154,%eax
  803246:	40                   	inc    %eax
  803247:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  80324c:	e9 a9 00 00 00       	jmp    8032fa <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803251:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803255:	74 06                	je     80325d <insert_sorted_with_merge_freeList+0x6ac>
  803257:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80325b:	75 17                	jne    803274 <insert_sorted_with_merge_freeList+0x6c3>
  80325d:	83 ec 04             	sub    $0x4,%esp
  803260:	68 7c 3f 80 00       	push   $0x803f7c
  803265:	68 73 01 00 00       	push   $0x173
  80326a:	68 07 3f 80 00       	push   $0x803f07
  80326f:	e8 03 d0 ff ff       	call   800277 <_panic>
  803274:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803277:	8b 10                	mov    (%eax),%edx
  803279:	8b 45 08             	mov    0x8(%ebp),%eax
  80327c:	89 10                	mov    %edx,(%eax)
  80327e:	8b 45 08             	mov    0x8(%ebp),%eax
  803281:	8b 00                	mov    (%eax),%eax
  803283:	85 c0                	test   %eax,%eax
  803285:	74 0b                	je     803292 <insert_sorted_with_merge_freeList+0x6e1>
  803287:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80328a:	8b 00                	mov    (%eax),%eax
  80328c:	8b 55 08             	mov    0x8(%ebp),%edx
  80328f:	89 50 04             	mov    %edx,0x4(%eax)
  803292:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803295:	8b 55 08             	mov    0x8(%ebp),%edx
  803298:	89 10                	mov    %edx,(%eax)
  80329a:	8b 45 08             	mov    0x8(%ebp),%eax
  80329d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032a0:	89 50 04             	mov    %edx,0x4(%eax)
  8032a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a6:	8b 00                	mov    (%eax),%eax
  8032a8:	85 c0                	test   %eax,%eax
  8032aa:	75 08                	jne    8032b4 <insert_sorted_with_merge_freeList+0x703>
  8032ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8032af:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8032b4:	a1 44 41 80 00       	mov    0x804144,%eax
  8032b9:	40                   	inc    %eax
  8032ba:	a3 44 41 80 00       	mov    %eax,0x804144
					break;
  8032bf:	eb 39                	jmp    8032fa <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8032c1:	a1 40 41 80 00       	mov    0x804140,%eax
  8032c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032cd:	74 07                	je     8032d6 <insert_sorted_with_merge_freeList+0x725>
  8032cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d2:	8b 00                	mov    (%eax),%eax
  8032d4:	eb 05                	jmp    8032db <insert_sorted_with_merge_freeList+0x72a>
  8032d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8032db:	a3 40 41 80 00       	mov    %eax,0x804140
  8032e0:	a1 40 41 80 00       	mov    0x804140,%eax
  8032e5:	85 c0                	test   %eax,%eax
  8032e7:	0f 85 c7 fb ff ff    	jne    802eb4 <insert_sorted_with_merge_freeList+0x303>
  8032ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032f1:	0f 85 bd fb ff ff    	jne    802eb4 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8032f7:	eb 01                	jmp    8032fa <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8032f9:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8032fa:	90                   	nop
  8032fb:	c9                   	leave  
  8032fc:	c3                   	ret    

008032fd <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8032fd:	55                   	push   %ebp
  8032fe:	89 e5                	mov    %esp,%ebp
  803300:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803303:	8b 55 08             	mov    0x8(%ebp),%edx
  803306:	89 d0                	mov    %edx,%eax
  803308:	c1 e0 02             	shl    $0x2,%eax
  80330b:	01 d0                	add    %edx,%eax
  80330d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803314:	01 d0                	add    %edx,%eax
  803316:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80331d:	01 d0                	add    %edx,%eax
  80331f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803326:	01 d0                	add    %edx,%eax
  803328:	c1 e0 04             	shl    $0x4,%eax
  80332b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  80332e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803335:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803338:	83 ec 0c             	sub    $0xc,%esp
  80333b:	50                   	push   %eax
  80333c:	e8 26 e7 ff ff       	call   801a67 <sys_get_virtual_time>
  803341:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803344:	eb 41                	jmp    803387 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803346:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803349:	83 ec 0c             	sub    $0xc,%esp
  80334c:	50                   	push   %eax
  80334d:	e8 15 e7 ff ff       	call   801a67 <sys_get_virtual_time>
  803352:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803355:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803358:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80335b:	29 c2                	sub    %eax,%edx
  80335d:	89 d0                	mov    %edx,%eax
  80335f:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803362:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803365:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803368:	89 d1                	mov    %edx,%ecx
  80336a:	29 c1                	sub    %eax,%ecx
  80336c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80336f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803372:	39 c2                	cmp    %eax,%edx
  803374:	0f 97 c0             	seta   %al
  803377:	0f b6 c0             	movzbl %al,%eax
  80337a:	29 c1                	sub    %eax,%ecx
  80337c:	89 c8                	mov    %ecx,%eax
  80337e:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803381:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803384:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803387:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80338a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80338d:	72 b7                	jb     803346 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  80338f:	90                   	nop
  803390:	c9                   	leave  
  803391:	c3                   	ret    

00803392 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803392:	55                   	push   %ebp
  803393:	89 e5                	mov    %esp,%ebp
  803395:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803398:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  80339f:	eb 03                	jmp    8033a4 <busy_wait+0x12>
  8033a1:	ff 45 fc             	incl   -0x4(%ebp)
  8033a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8033a7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8033aa:	72 f5                	jb     8033a1 <busy_wait+0xf>
	return i;
  8033ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8033af:	c9                   	leave  
  8033b0:	c3                   	ret    
  8033b1:	66 90                	xchg   %ax,%ax
  8033b3:	90                   	nop

008033b4 <__udivdi3>:
  8033b4:	55                   	push   %ebp
  8033b5:	57                   	push   %edi
  8033b6:	56                   	push   %esi
  8033b7:	53                   	push   %ebx
  8033b8:	83 ec 1c             	sub    $0x1c,%esp
  8033bb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8033bf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8033c3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8033c7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8033cb:	89 ca                	mov    %ecx,%edx
  8033cd:	89 f8                	mov    %edi,%eax
  8033cf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8033d3:	85 f6                	test   %esi,%esi
  8033d5:	75 2d                	jne    803404 <__udivdi3+0x50>
  8033d7:	39 cf                	cmp    %ecx,%edi
  8033d9:	77 65                	ja     803440 <__udivdi3+0x8c>
  8033db:	89 fd                	mov    %edi,%ebp
  8033dd:	85 ff                	test   %edi,%edi
  8033df:	75 0b                	jne    8033ec <__udivdi3+0x38>
  8033e1:	b8 01 00 00 00       	mov    $0x1,%eax
  8033e6:	31 d2                	xor    %edx,%edx
  8033e8:	f7 f7                	div    %edi
  8033ea:	89 c5                	mov    %eax,%ebp
  8033ec:	31 d2                	xor    %edx,%edx
  8033ee:	89 c8                	mov    %ecx,%eax
  8033f0:	f7 f5                	div    %ebp
  8033f2:	89 c1                	mov    %eax,%ecx
  8033f4:	89 d8                	mov    %ebx,%eax
  8033f6:	f7 f5                	div    %ebp
  8033f8:	89 cf                	mov    %ecx,%edi
  8033fa:	89 fa                	mov    %edi,%edx
  8033fc:	83 c4 1c             	add    $0x1c,%esp
  8033ff:	5b                   	pop    %ebx
  803400:	5e                   	pop    %esi
  803401:	5f                   	pop    %edi
  803402:	5d                   	pop    %ebp
  803403:	c3                   	ret    
  803404:	39 ce                	cmp    %ecx,%esi
  803406:	77 28                	ja     803430 <__udivdi3+0x7c>
  803408:	0f bd fe             	bsr    %esi,%edi
  80340b:	83 f7 1f             	xor    $0x1f,%edi
  80340e:	75 40                	jne    803450 <__udivdi3+0x9c>
  803410:	39 ce                	cmp    %ecx,%esi
  803412:	72 0a                	jb     80341e <__udivdi3+0x6a>
  803414:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803418:	0f 87 9e 00 00 00    	ja     8034bc <__udivdi3+0x108>
  80341e:	b8 01 00 00 00       	mov    $0x1,%eax
  803423:	89 fa                	mov    %edi,%edx
  803425:	83 c4 1c             	add    $0x1c,%esp
  803428:	5b                   	pop    %ebx
  803429:	5e                   	pop    %esi
  80342a:	5f                   	pop    %edi
  80342b:	5d                   	pop    %ebp
  80342c:	c3                   	ret    
  80342d:	8d 76 00             	lea    0x0(%esi),%esi
  803430:	31 ff                	xor    %edi,%edi
  803432:	31 c0                	xor    %eax,%eax
  803434:	89 fa                	mov    %edi,%edx
  803436:	83 c4 1c             	add    $0x1c,%esp
  803439:	5b                   	pop    %ebx
  80343a:	5e                   	pop    %esi
  80343b:	5f                   	pop    %edi
  80343c:	5d                   	pop    %ebp
  80343d:	c3                   	ret    
  80343e:	66 90                	xchg   %ax,%ax
  803440:	89 d8                	mov    %ebx,%eax
  803442:	f7 f7                	div    %edi
  803444:	31 ff                	xor    %edi,%edi
  803446:	89 fa                	mov    %edi,%edx
  803448:	83 c4 1c             	add    $0x1c,%esp
  80344b:	5b                   	pop    %ebx
  80344c:	5e                   	pop    %esi
  80344d:	5f                   	pop    %edi
  80344e:	5d                   	pop    %ebp
  80344f:	c3                   	ret    
  803450:	bd 20 00 00 00       	mov    $0x20,%ebp
  803455:	89 eb                	mov    %ebp,%ebx
  803457:	29 fb                	sub    %edi,%ebx
  803459:	89 f9                	mov    %edi,%ecx
  80345b:	d3 e6                	shl    %cl,%esi
  80345d:	89 c5                	mov    %eax,%ebp
  80345f:	88 d9                	mov    %bl,%cl
  803461:	d3 ed                	shr    %cl,%ebp
  803463:	89 e9                	mov    %ebp,%ecx
  803465:	09 f1                	or     %esi,%ecx
  803467:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80346b:	89 f9                	mov    %edi,%ecx
  80346d:	d3 e0                	shl    %cl,%eax
  80346f:	89 c5                	mov    %eax,%ebp
  803471:	89 d6                	mov    %edx,%esi
  803473:	88 d9                	mov    %bl,%cl
  803475:	d3 ee                	shr    %cl,%esi
  803477:	89 f9                	mov    %edi,%ecx
  803479:	d3 e2                	shl    %cl,%edx
  80347b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80347f:	88 d9                	mov    %bl,%cl
  803481:	d3 e8                	shr    %cl,%eax
  803483:	09 c2                	or     %eax,%edx
  803485:	89 d0                	mov    %edx,%eax
  803487:	89 f2                	mov    %esi,%edx
  803489:	f7 74 24 0c          	divl   0xc(%esp)
  80348d:	89 d6                	mov    %edx,%esi
  80348f:	89 c3                	mov    %eax,%ebx
  803491:	f7 e5                	mul    %ebp
  803493:	39 d6                	cmp    %edx,%esi
  803495:	72 19                	jb     8034b0 <__udivdi3+0xfc>
  803497:	74 0b                	je     8034a4 <__udivdi3+0xf0>
  803499:	89 d8                	mov    %ebx,%eax
  80349b:	31 ff                	xor    %edi,%edi
  80349d:	e9 58 ff ff ff       	jmp    8033fa <__udivdi3+0x46>
  8034a2:	66 90                	xchg   %ax,%ax
  8034a4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8034a8:	89 f9                	mov    %edi,%ecx
  8034aa:	d3 e2                	shl    %cl,%edx
  8034ac:	39 c2                	cmp    %eax,%edx
  8034ae:	73 e9                	jae    803499 <__udivdi3+0xe5>
  8034b0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8034b3:	31 ff                	xor    %edi,%edi
  8034b5:	e9 40 ff ff ff       	jmp    8033fa <__udivdi3+0x46>
  8034ba:	66 90                	xchg   %ax,%ax
  8034bc:	31 c0                	xor    %eax,%eax
  8034be:	e9 37 ff ff ff       	jmp    8033fa <__udivdi3+0x46>
  8034c3:	90                   	nop

008034c4 <__umoddi3>:
  8034c4:	55                   	push   %ebp
  8034c5:	57                   	push   %edi
  8034c6:	56                   	push   %esi
  8034c7:	53                   	push   %ebx
  8034c8:	83 ec 1c             	sub    $0x1c,%esp
  8034cb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8034cf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8034d3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8034d7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8034db:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8034df:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8034e3:	89 f3                	mov    %esi,%ebx
  8034e5:	89 fa                	mov    %edi,%edx
  8034e7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8034eb:	89 34 24             	mov    %esi,(%esp)
  8034ee:	85 c0                	test   %eax,%eax
  8034f0:	75 1a                	jne    80350c <__umoddi3+0x48>
  8034f2:	39 f7                	cmp    %esi,%edi
  8034f4:	0f 86 a2 00 00 00    	jbe    80359c <__umoddi3+0xd8>
  8034fa:	89 c8                	mov    %ecx,%eax
  8034fc:	89 f2                	mov    %esi,%edx
  8034fe:	f7 f7                	div    %edi
  803500:	89 d0                	mov    %edx,%eax
  803502:	31 d2                	xor    %edx,%edx
  803504:	83 c4 1c             	add    $0x1c,%esp
  803507:	5b                   	pop    %ebx
  803508:	5e                   	pop    %esi
  803509:	5f                   	pop    %edi
  80350a:	5d                   	pop    %ebp
  80350b:	c3                   	ret    
  80350c:	39 f0                	cmp    %esi,%eax
  80350e:	0f 87 ac 00 00 00    	ja     8035c0 <__umoddi3+0xfc>
  803514:	0f bd e8             	bsr    %eax,%ebp
  803517:	83 f5 1f             	xor    $0x1f,%ebp
  80351a:	0f 84 ac 00 00 00    	je     8035cc <__umoddi3+0x108>
  803520:	bf 20 00 00 00       	mov    $0x20,%edi
  803525:	29 ef                	sub    %ebp,%edi
  803527:	89 fe                	mov    %edi,%esi
  803529:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80352d:	89 e9                	mov    %ebp,%ecx
  80352f:	d3 e0                	shl    %cl,%eax
  803531:	89 d7                	mov    %edx,%edi
  803533:	89 f1                	mov    %esi,%ecx
  803535:	d3 ef                	shr    %cl,%edi
  803537:	09 c7                	or     %eax,%edi
  803539:	89 e9                	mov    %ebp,%ecx
  80353b:	d3 e2                	shl    %cl,%edx
  80353d:	89 14 24             	mov    %edx,(%esp)
  803540:	89 d8                	mov    %ebx,%eax
  803542:	d3 e0                	shl    %cl,%eax
  803544:	89 c2                	mov    %eax,%edx
  803546:	8b 44 24 08          	mov    0x8(%esp),%eax
  80354a:	d3 e0                	shl    %cl,%eax
  80354c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803550:	8b 44 24 08          	mov    0x8(%esp),%eax
  803554:	89 f1                	mov    %esi,%ecx
  803556:	d3 e8                	shr    %cl,%eax
  803558:	09 d0                	or     %edx,%eax
  80355a:	d3 eb                	shr    %cl,%ebx
  80355c:	89 da                	mov    %ebx,%edx
  80355e:	f7 f7                	div    %edi
  803560:	89 d3                	mov    %edx,%ebx
  803562:	f7 24 24             	mull   (%esp)
  803565:	89 c6                	mov    %eax,%esi
  803567:	89 d1                	mov    %edx,%ecx
  803569:	39 d3                	cmp    %edx,%ebx
  80356b:	0f 82 87 00 00 00    	jb     8035f8 <__umoddi3+0x134>
  803571:	0f 84 91 00 00 00    	je     803608 <__umoddi3+0x144>
  803577:	8b 54 24 04          	mov    0x4(%esp),%edx
  80357b:	29 f2                	sub    %esi,%edx
  80357d:	19 cb                	sbb    %ecx,%ebx
  80357f:	89 d8                	mov    %ebx,%eax
  803581:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803585:	d3 e0                	shl    %cl,%eax
  803587:	89 e9                	mov    %ebp,%ecx
  803589:	d3 ea                	shr    %cl,%edx
  80358b:	09 d0                	or     %edx,%eax
  80358d:	89 e9                	mov    %ebp,%ecx
  80358f:	d3 eb                	shr    %cl,%ebx
  803591:	89 da                	mov    %ebx,%edx
  803593:	83 c4 1c             	add    $0x1c,%esp
  803596:	5b                   	pop    %ebx
  803597:	5e                   	pop    %esi
  803598:	5f                   	pop    %edi
  803599:	5d                   	pop    %ebp
  80359a:	c3                   	ret    
  80359b:	90                   	nop
  80359c:	89 fd                	mov    %edi,%ebp
  80359e:	85 ff                	test   %edi,%edi
  8035a0:	75 0b                	jne    8035ad <__umoddi3+0xe9>
  8035a2:	b8 01 00 00 00       	mov    $0x1,%eax
  8035a7:	31 d2                	xor    %edx,%edx
  8035a9:	f7 f7                	div    %edi
  8035ab:	89 c5                	mov    %eax,%ebp
  8035ad:	89 f0                	mov    %esi,%eax
  8035af:	31 d2                	xor    %edx,%edx
  8035b1:	f7 f5                	div    %ebp
  8035b3:	89 c8                	mov    %ecx,%eax
  8035b5:	f7 f5                	div    %ebp
  8035b7:	89 d0                	mov    %edx,%eax
  8035b9:	e9 44 ff ff ff       	jmp    803502 <__umoddi3+0x3e>
  8035be:	66 90                	xchg   %ax,%ax
  8035c0:	89 c8                	mov    %ecx,%eax
  8035c2:	89 f2                	mov    %esi,%edx
  8035c4:	83 c4 1c             	add    $0x1c,%esp
  8035c7:	5b                   	pop    %ebx
  8035c8:	5e                   	pop    %esi
  8035c9:	5f                   	pop    %edi
  8035ca:	5d                   	pop    %ebp
  8035cb:	c3                   	ret    
  8035cc:	3b 04 24             	cmp    (%esp),%eax
  8035cf:	72 06                	jb     8035d7 <__umoddi3+0x113>
  8035d1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8035d5:	77 0f                	ja     8035e6 <__umoddi3+0x122>
  8035d7:	89 f2                	mov    %esi,%edx
  8035d9:	29 f9                	sub    %edi,%ecx
  8035db:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8035df:	89 14 24             	mov    %edx,(%esp)
  8035e2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8035e6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8035ea:	8b 14 24             	mov    (%esp),%edx
  8035ed:	83 c4 1c             	add    $0x1c,%esp
  8035f0:	5b                   	pop    %ebx
  8035f1:	5e                   	pop    %esi
  8035f2:	5f                   	pop    %edi
  8035f3:	5d                   	pop    %ebp
  8035f4:	c3                   	ret    
  8035f5:	8d 76 00             	lea    0x0(%esi),%esi
  8035f8:	2b 04 24             	sub    (%esp),%eax
  8035fb:	19 fa                	sbb    %edi,%edx
  8035fd:	89 d1                	mov    %edx,%ecx
  8035ff:	89 c6                	mov    %eax,%esi
  803601:	e9 71 ff ff ff       	jmp    803577 <__umoddi3+0xb3>
  803606:	66 90                	xchg   %ax,%ax
  803608:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80360c:	72 ea                	jb     8035f8 <__umoddi3+0x134>
  80360e:	89 d9                	mov    %ebx,%ecx
  803610:	e9 62 ff ff ff       	jmp    803577 <__umoddi3+0xb3>
