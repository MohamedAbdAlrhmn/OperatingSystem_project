
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
  80008c:	68 40 36 80 00       	push   $0x803640
  800091:	6a 12                	push   $0x12
  800093:	68 5c 36 80 00       	push   $0x80365c
  800098:	e8 da 01 00 00       	call   800277 <_panic>
	}
	uint32 *x;
	x = sget(sys_getparentenvid(),"x");
  80009d:	e8 b7 19 00 00       	call   801a59 <sys_getparentenvid>
  8000a2:	83 ec 08             	sub    $0x8,%esp
  8000a5:	68 7c 36 80 00       	push   $0x80367c
  8000aa:	50                   	push   %eax
  8000ab:	e8 0c 15 00 00       	call   8015bc <sget>
  8000b0:	83 c4 10             	add    $0x10,%esp
  8000b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("Slave B1 env used x (getSharedObject)\n");
  8000b6:	83 ec 0c             	sub    $0xc,%esp
  8000b9:	68 80 36 80 00       	push   $0x803680
  8000be:	e8 68 04 00 00       	call   80052b <cprintf>
  8000c3:	83 c4 10             	add    $0x10,%esp

	cprintf("Slave B1 please be patient ...\n");
  8000c6:	83 ec 0c             	sub    $0xc,%esp
  8000c9:	68 a8 36 80 00       	push   $0x8036a8
  8000ce:	e8 58 04 00 00       	call   80052b <cprintf>
  8000d3:	83 c4 10             	add    $0x10,%esp

	env_sleep(6000);
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	68 70 17 00 00       	push   $0x1770
  8000de:	e8 3f 32 00 00       	call   803322 <env_sleep>
  8000e3:	83 c4 10             	add    $0x10,%esp
	int freeFrames = sys_calculate_free_frames() ;
  8000e6:	e8 75 16 00 00       	call   801760 <sys_calculate_free_frames>
  8000eb:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sfree(x);
  8000ee:	83 ec 0c             	sub    $0xc,%esp
  8000f1:	ff 75 ec             	pushl  -0x14(%ebp)
  8000f4:	e8 07 15 00 00       	call   801600 <sfree>
  8000f9:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave B1 env removed x\n");
  8000fc:	83 ec 0c             	sub    $0xc,%esp
  8000ff:	68 c8 36 80 00       	push   $0x8036c8
  800104:	e8 22 04 00 00       	call   80052b <cprintf>
  800109:	83 c4 10             	add    $0x10,%esp

	if ((sys_calculate_free_frames() - freeFrames) !=  4) panic("B1 wrong free: frames removed not equal 4 !, correct frames to be removed are 4:\nfrom the env: 1 table and 1 for frame of x\nframes_storage of x: should be cleared now\n");
  80010c:	e8 4f 16 00 00       	call   801760 <sys_calculate_free_frames>
  800111:	89 c2                	mov    %eax,%edx
  800113:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800116:	29 c2                	sub    %eax,%edx
  800118:	89 d0                	mov    %edx,%eax
  80011a:	83 f8 04             	cmp    $0x4,%eax
  80011d:	74 14                	je     800133 <_main+0xfb>
  80011f:	83 ec 04             	sub    $0x4,%esp
  800122:	68 e0 36 80 00       	push   $0x8036e0
  800127:	6a 20                	push   $0x20
  800129:	68 5c 36 80 00       	push   $0x80365c
  80012e:	e8 44 01 00 00       	call   800277 <_panic>

	//To indicate that it's completed successfully
	inctst();
  800133:	e8 46 1a 00 00       	call   801b7e <inctst>
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
  800141:	e8 fa 18 00 00       	call   801a40 <sys_getenvindex>
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
  8001ac:	e8 9c 16 00 00       	call   80184d <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001b1:	83 ec 0c             	sub    $0xc,%esp
  8001b4:	68 a0 37 80 00       	push   $0x8037a0
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
  8001dc:	68 c8 37 80 00       	push   $0x8037c8
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
  80020d:	68 f0 37 80 00       	push   $0x8037f0
  800212:	e8 14 03 00 00       	call   80052b <cprintf>
  800217:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80021a:	a1 20 50 80 00       	mov    0x805020,%eax
  80021f:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800225:	83 ec 08             	sub    $0x8,%esp
  800228:	50                   	push   %eax
  800229:	68 48 38 80 00       	push   $0x803848
  80022e:	e8 f8 02 00 00       	call   80052b <cprintf>
  800233:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800236:	83 ec 0c             	sub    $0xc,%esp
  800239:	68 a0 37 80 00       	push   $0x8037a0
  80023e:	e8 e8 02 00 00       	call   80052b <cprintf>
  800243:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800246:	e8 1c 16 00 00       	call   801867 <sys_enable_interrupt>

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
  80025e:	e8 a9 17 00 00       	call   801a0c <sys_destroy_env>
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
  80026f:	e8 fe 17 00 00       	call   801a72 <sys_exit_env>
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
  800298:	68 5c 38 80 00       	push   $0x80385c
  80029d:	e8 89 02 00 00       	call   80052b <cprintf>
  8002a2:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002a5:	a1 00 50 80 00       	mov    0x805000,%eax
  8002aa:	ff 75 0c             	pushl  0xc(%ebp)
  8002ad:	ff 75 08             	pushl  0x8(%ebp)
  8002b0:	50                   	push   %eax
  8002b1:	68 61 38 80 00       	push   $0x803861
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
  8002d5:	68 7d 38 80 00       	push   $0x80387d
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
  800301:	68 80 38 80 00       	push   $0x803880
  800306:	6a 26                	push   $0x26
  800308:	68 cc 38 80 00       	push   $0x8038cc
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
  8003d3:	68 d8 38 80 00       	push   $0x8038d8
  8003d8:	6a 3a                	push   $0x3a
  8003da:	68 cc 38 80 00       	push   $0x8038cc
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
  800443:	68 2c 39 80 00       	push   $0x80392c
  800448:	6a 44                	push   $0x44
  80044a:	68 cc 38 80 00       	push   $0x8038cc
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
  80049d:	e8 fd 11 00 00       	call   80169f <sys_cputs>
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
  800514:	e8 86 11 00 00       	call   80169f <sys_cputs>
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
  80055e:	e8 ea 12 00 00       	call   80184d <sys_disable_interrupt>
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
  80057e:	e8 e4 12 00 00       	call   801867 <sys_enable_interrupt>
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
  8005c8:	e8 0b 2e 00 00       	call   8033d8 <__udivdi3>
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
  800618:	e8 cb 2e 00 00       	call   8034e8 <__umoddi3>
  80061d:	83 c4 10             	add    $0x10,%esp
  800620:	05 94 3b 80 00       	add    $0x803b94,%eax
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
  800773:	8b 04 85 b8 3b 80 00 	mov    0x803bb8(,%eax,4),%eax
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
  800854:	8b 34 9d 00 3a 80 00 	mov    0x803a00(,%ebx,4),%esi
  80085b:	85 f6                	test   %esi,%esi
  80085d:	75 19                	jne    800878 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80085f:	53                   	push   %ebx
  800860:	68 a5 3b 80 00       	push   $0x803ba5
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
  800879:	68 ae 3b 80 00       	push   $0x803bae
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
  8008a6:	be b1 3b 80 00       	mov    $0x803bb1,%esi
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
  8012cc:	68 10 3d 80 00       	push   $0x803d10
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
  80139c:	e8 42 04 00 00       	call   8017e3 <sys_allocate_chunk>
  8013a1:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013a4:	a1 20 51 80 00       	mov    0x805120,%eax
  8013a9:	83 ec 0c             	sub    $0xc,%esp
  8013ac:	50                   	push   %eax
  8013ad:	e8 b7 0a 00 00       	call   801e69 <initialize_MemBlocksList>
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
  8013da:	68 35 3d 80 00       	push   $0x803d35
  8013df:	6a 33                	push   $0x33
  8013e1:	68 53 3d 80 00       	push   $0x803d53
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
  801459:	68 60 3d 80 00       	push   $0x803d60
  80145e:	6a 34                	push   $0x34
  801460:	68 53 3d 80 00       	push   $0x803d53
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
  8014ce:	68 84 3d 80 00       	push   $0x803d84
  8014d3:	6a 46                	push   $0x46
  8014d5:	68 53 3d 80 00       	push   $0x803d53
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
  8014ea:	68 ac 3d 80 00       	push   $0x803dac
  8014ef:	6a 61                	push   $0x61
  8014f1:	68 53 3d 80 00       	push   $0x803d53
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
  801510:	75 0a                	jne    80151c <smalloc+0x21>
  801512:	b8 00 00 00 00       	mov    $0x0,%eax
  801517:	e9 9e 00 00 00       	jmp    8015ba <smalloc+0xbf>
	//3-If the Kernel successfully creates the shared variable, return its virtual address
	//4-Else, return NULL



	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  80151c:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801523:	8b 55 0c             	mov    0xc(%ebp),%edx
  801526:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801529:	01 d0                	add    %edx,%eax
  80152b:	48                   	dec    %eax
  80152c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80152f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801532:	ba 00 00 00 00       	mov    $0x0,%edx
  801537:	f7 75 f0             	divl   -0x10(%ebp)
  80153a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80153d:	29 d0                	sub    %edx,%eax
  80153f:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801542:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801549:	e8 63 06 00 00       	call   801bb1 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80154e:	85 c0                	test   %eax,%eax
  801550:	74 11                	je     801563 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  801552:	83 ec 0c             	sub    $0xc,%esp
  801555:	ff 75 e8             	pushl  -0x18(%ebp)
  801558:	e8 ce 0c 00 00       	call   80222b <alloc_block_FF>
  80155d:	83 c4 10             	add    $0x10,%esp
  801560:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  801563:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801567:	74 4c                	je     8015b5 <smalloc+0xba>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801569:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80156c:	8b 40 08             	mov    0x8(%eax),%eax
  80156f:	89 c2                	mov    %eax,%edx
  801571:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801575:	52                   	push   %edx
  801576:	50                   	push   %eax
  801577:	ff 75 0c             	pushl  0xc(%ebp)
  80157a:	ff 75 08             	pushl  0x8(%ebp)
  80157d:	e8 b4 03 00 00       	call   801936 <sys_createSharedObject>
  801582:	83 c4 10             	add    $0x10,%esp
  801585:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cprintf("Output is :  %d \n" , result);
  801588:	83 ec 08             	sub    $0x8,%esp
  80158b:	ff 75 e0             	pushl  -0x20(%ebp)
  80158e:	68 cf 3d 80 00       	push   $0x803dcf
  801593:	e8 93 ef ff ff       	call   80052b <cprintf>
  801598:	83 c4 10             	add    $0x10,%esp
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  80159b:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  80159f:	74 14                	je     8015b5 <smalloc+0xba>
  8015a1:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  8015a5:	74 0e                	je     8015b5 <smalloc+0xba>
  8015a7:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  8015ab:	74 08                	je     8015b5 <smalloc+0xba>
			return (void*) mem_block->sva;
  8015ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015b0:	8b 40 08             	mov    0x8(%eax),%eax
  8015b3:	eb 05                	jmp    8015ba <smalloc+0xbf>
	}
	return NULL;
  8015b5:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8015ba:	c9                   	leave  
  8015bb:	c3                   	ret    

008015bc <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8015bc:	55                   	push   %ebp
  8015bd:	89 e5                	mov    %esp,%ebp
  8015bf:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015c2:	e8 ee fc ff ff       	call   8012b5 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8015c7:	83 ec 04             	sub    $0x4,%esp
  8015ca:	68 e4 3d 80 00       	push   $0x803de4
  8015cf:	68 ab 00 00 00       	push   $0xab
  8015d4:	68 53 3d 80 00       	push   $0x803d53
  8015d9:	e8 99 ec ff ff       	call   800277 <_panic>

008015de <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8015de:	55                   	push   %ebp
  8015df:	89 e5                	mov    %esp,%ebp
  8015e1:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015e4:	e8 cc fc ff ff       	call   8012b5 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8015e9:	83 ec 04             	sub    $0x4,%esp
  8015ec:	68 08 3e 80 00       	push   $0x803e08
  8015f1:	68 ef 00 00 00       	push   $0xef
  8015f6:	68 53 3d 80 00       	push   $0x803d53
  8015fb:	e8 77 ec ff ff       	call   800277 <_panic>

00801600 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801600:	55                   	push   %ebp
  801601:	89 e5                	mov    %esp,%ebp
  801603:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801606:	83 ec 04             	sub    $0x4,%esp
  801609:	68 30 3e 80 00       	push   $0x803e30
  80160e:	68 03 01 00 00       	push   $0x103
  801613:	68 53 3d 80 00       	push   $0x803d53
  801618:	e8 5a ec ff ff       	call   800277 <_panic>

0080161d <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80161d:	55                   	push   %ebp
  80161e:	89 e5                	mov    %esp,%ebp
  801620:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801623:	83 ec 04             	sub    $0x4,%esp
  801626:	68 54 3e 80 00       	push   $0x803e54
  80162b:	68 0e 01 00 00       	push   $0x10e
  801630:	68 53 3d 80 00       	push   $0x803d53
  801635:	e8 3d ec ff ff       	call   800277 <_panic>

0080163a <shrink>:

}
void shrink(uint32 newSize)
{
  80163a:	55                   	push   %ebp
  80163b:	89 e5                	mov    %esp,%ebp
  80163d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801640:	83 ec 04             	sub    $0x4,%esp
  801643:	68 54 3e 80 00       	push   $0x803e54
  801648:	68 13 01 00 00       	push   $0x113
  80164d:	68 53 3d 80 00       	push   $0x803d53
  801652:	e8 20 ec ff ff       	call   800277 <_panic>

00801657 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801657:	55                   	push   %ebp
  801658:	89 e5                	mov    %esp,%ebp
  80165a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80165d:	83 ec 04             	sub    $0x4,%esp
  801660:	68 54 3e 80 00       	push   $0x803e54
  801665:	68 18 01 00 00       	push   $0x118
  80166a:	68 53 3d 80 00       	push   $0x803d53
  80166f:	e8 03 ec ff ff       	call   800277 <_panic>

00801674 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801674:	55                   	push   %ebp
  801675:	89 e5                	mov    %esp,%ebp
  801677:	57                   	push   %edi
  801678:	56                   	push   %esi
  801679:	53                   	push   %ebx
  80167a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80167d:	8b 45 08             	mov    0x8(%ebp),%eax
  801680:	8b 55 0c             	mov    0xc(%ebp),%edx
  801683:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801686:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801689:	8b 7d 18             	mov    0x18(%ebp),%edi
  80168c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80168f:	cd 30                	int    $0x30
  801691:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801694:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801697:	83 c4 10             	add    $0x10,%esp
  80169a:	5b                   	pop    %ebx
  80169b:	5e                   	pop    %esi
  80169c:	5f                   	pop    %edi
  80169d:	5d                   	pop    %ebp
  80169e:	c3                   	ret    

0080169f <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80169f:	55                   	push   %ebp
  8016a0:	89 e5                	mov    %esp,%ebp
  8016a2:	83 ec 04             	sub    $0x4,%esp
  8016a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8016ab:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8016af:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b2:	6a 00                	push   $0x0
  8016b4:	6a 00                	push   $0x0
  8016b6:	52                   	push   %edx
  8016b7:	ff 75 0c             	pushl  0xc(%ebp)
  8016ba:	50                   	push   %eax
  8016bb:	6a 00                	push   $0x0
  8016bd:	e8 b2 ff ff ff       	call   801674 <syscall>
  8016c2:	83 c4 18             	add    $0x18,%esp
}
  8016c5:	90                   	nop
  8016c6:	c9                   	leave  
  8016c7:	c3                   	ret    

008016c8 <sys_cgetc>:

int
sys_cgetc(void)
{
  8016c8:	55                   	push   %ebp
  8016c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8016cb:	6a 00                	push   $0x0
  8016cd:	6a 00                	push   $0x0
  8016cf:	6a 00                	push   $0x0
  8016d1:	6a 00                	push   $0x0
  8016d3:	6a 00                	push   $0x0
  8016d5:	6a 01                	push   $0x1
  8016d7:	e8 98 ff ff ff       	call   801674 <syscall>
  8016dc:	83 c4 18             	add    $0x18,%esp
}
  8016df:	c9                   	leave  
  8016e0:	c3                   	ret    

008016e1 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8016e1:	55                   	push   %ebp
  8016e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8016e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ea:	6a 00                	push   $0x0
  8016ec:	6a 00                	push   $0x0
  8016ee:	6a 00                	push   $0x0
  8016f0:	52                   	push   %edx
  8016f1:	50                   	push   %eax
  8016f2:	6a 05                	push   $0x5
  8016f4:	e8 7b ff ff ff       	call   801674 <syscall>
  8016f9:	83 c4 18             	add    $0x18,%esp
}
  8016fc:	c9                   	leave  
  8016fd:	c3                   	ret    

008016fe <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8016fe:	55                   	push   %ebp
  8016ff:	89 e5                	mov    %esp,%ebp
  801701:	56                   	push   %esi
  801702:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801703:	8b 75 18             	mov    0x18(%ebp),%esi
  801706:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801709:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80170c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80170f:	8b 45 08             	mov    0x8(%ebp),%eax
  801712:	56                   	push   %esi
  801713:	53                   	push   %ebx
  801714:	51                   	push   %ecx
  801715:	52                   	push   %edx
  801716:	50                   	push   %eax
  801717:	6a 06                	push   $0x6
  801719:	e8 56 ff ff ff       	call   801674 <syscall>
  80171e:	83 c4 18             	add    $0x18,%esp
}
  801721:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801724:	5b                   	pop    %ebx
  801725:	5e                   	pop    %esi
  801726:	5d                   	pop    %ebp
  801727:	c3                   	ret    

00801728 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801728:	55                   	push   %ebp
  801729:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80172b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80172e:	8b 45 08             	mov    0x8(%ebp),%eax
  801731:	6a 00                	push   $0x0
  801733:	6a 00                	push   $0x0
  801735:	6a 00                	push   $0x0
  801737:	52                   	push   %edx
  801738:	50                   	push   %eax
  801739:	6a 07                	push   $0x7
  80173b:	e8 34 ff ff ff       	call   801674 <syscall>
  801740:	83 c4 18             	add    $0x18,%esp
}
  801743:	c9                   	leave  
  801744:	c3                   	ret    

00801745 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801745:	55                   	push   %ebp
  801746:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801748:	6a 00                	push   $0x0
  80174a:	6a 00                	push   $0x0
  80174c:	6a 00                	push   $0x0
  80174e:	ff 75 0c             	pushl  0xc(%ebp)
  801751:	ff 75 08             	pushl  0x8(%ebp)
  801754:	6a 08                	push   $0x8
  801756:	e8 19 ff ff ff       	call   801674 <syscall>
  80175b:	83 c4 18             	add    $0x18,%esp
}
  80175e:	c9                   	leave  
  80175f:	c3                   	ret    

00801760 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801760:	55                   	push   %ebp
  801761:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801763:	6a 00                	push   $0x0
  801765:	6a 00                	push   $0x0
  801767:	6a 00                	push   $0x0
  801769:	6a 00                	push   $0x0
  80176b:	6a 00                	push   $0x0
  80176d:	6a 09                	push   $0x9
  80176f:	e8 00 ff ff ff       	call   801674 <syscall>
  801774:	83 c4 18             	add    $0x18,%esp
}
  801777:	c9                   	leave  
  801778:	c3                   	ret    

00801779 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801779:	55                   	push   %ebp
  80177a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80177c:	6a 00                	push   $0x0
  80177e:	6a 00                	push   $0x0
  801780:	6a 00                	push   $0x0
  801782:	6a 00                	push   $0x0
  801784:	6a 00                	push   $0x0
  801786:	6a 0a                	push   $0xa
  801788:	e8 e7 fe ff ff       	call   801674 <syscall>
  80178d:	83 c4 18             	add    $0x18,%esp
}
  801790:	c9                   	leave  
  801791:	c3                   	ret    

00801792 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801792:	55                   	push   %ebp
  801793:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801795:	6a 00                	push   $0x0
  801797:	6a 00                	push   $0x0
  801799:	6a 00                	push   $0x0
  80179b:	6a 00                	push   $0x0
  80179d:	6a 00                	push   $0x0
  80179f:	6a 0b                	push   $0xb
  8017a1:	e8 ce fe ff ff       	call   801674 <syscall>
  8017a6:	83 c4 18             	add    $0x18,%esp
}
  8017a9:	c9                   	leave  
  8017aa:	c3                   	ret    

008017ab <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8017ab:	55                   	push   %ebp
  8017ac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8017ae:	6a 00                	push   $0x0
  8017b0:	6a 00                	push   $0x0
  8017b2:	6a 00                	push   $0x0
  8017b4:	ff 75 0c             	pushl  0xc(%ebp)
  8017b7:	ff 75 08             	pushl  0x8(%ebp)
  8017ba:	6a 0f                	push   $0xf
  8017bc:	e8 b3 fe ff ff       	call   801674 <syscall>
  8017c1:	83 c4 18             	add    $0x18,%esp
	return;
  8017c4:	90                   	nop
}
  8017c5:	c9                   	leave  
  8017c6:	c3                   	ret    

008017c7 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8017c7:	55                   	push   %ebp
  8017c8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8017ca:	6a 00                	push   $0x0
  8017cc:	6a 00                	push   $0x0
  8017ce:	6a 00                	push   $0x0
  8017d0:	ff 75 0c             	pushl  0xc(%ebp)
  8017d3:	ff 75 08             	pushl  0x8(%ebp)
  8017d6:	6a 10                	push   $0x10
  8017d8:	e8 97 fe ff ff       	call   801674 <syscall>
  8017dd:	83 c4 18             	add    $0x18,%esp
	return ;
  8017e0:	90                   	nop
}
  8017e1:	c9                   	leave  
  8017e2:	c3                   	ret    

008017e3 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8017e3:	55                   	push   %ebp
  8017e4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8017e6:	6a 00                	push   $0x0
  8017e8:	6a 00                	push   $0x0
  8017ea:	ff 75 10             	pushl  0x10(%ebp)
  8017ed:	ff 75 0c             	pushl  0xc(%ebp)
  8017f0:	ff 75 08             	pushl  0x8(%ebp)
  8017f3:	6a 11                	push   $0x11
  8017f5:	e8 7a fe ff ff       	call   801674 <syscall>
  8017fa:	83 c4 18             	add    $0x18,%esp
	return ;
  8017fd:	90                   	nop
}
  8017fe:	c9                   	leave  
  8017ff:	c3                   	ret    

00801800 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801800:	55                   	push   %ebp
  801801:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801803:	6a 00                	push   $0x0
  801805:	6a 00                	push   $0x0
  801807:	6a 00                	push   $0x0
  801809:	6a 00                	push   $0x0
  80180b:	6a 00                	push   $0x0
  80180d:	6a 0c                	push   $0xc
  80180f:	e8 60 fe ff ff       	call   801674 <syscall>
  801814:	83 c4 18             	add    $0x18,%esp
}
  801817:	c9                   	leave  
  801818:	c3                   	ret    

00801819 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801819:	55                   	push   %ebp
  80181a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80181c:	6a 00                	push   $0x0
  80181e:	6a 00                	push   $0x0
  801820:	6a 00                	push   $0x0
  801822:	6a 00                	push   $0x0
  801824:	ff 75 08             	pushl  0x8(%ebp)
  801827:	6a 0d                	push   $0xd
  801829:	e8 46 fe ff ff       	call   801674 <syscall>
  80182e:	83 c4 18             	add    $0x18,%esp
}
  801831:	c9                   	leave  
  801832:	c3                   	ret    

00801833 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801833:	55                   	push   %ebp
  801834:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801836:	6a 00                	push   $0x0
  801838:	6a 00                	push   $0x0
  80183a:	6a 00                	push   $0x0
  80183c:	6a 00                	push   $0x0
  80183e:	6a 00                	push   $0x0
  801840:	6a 0e                	push   $0xe
  801842:	e8 2d fe ff ff       	call   801674 <syscall>
  801847:	83 c4 18             	add    $0x18,%esp
}
  80184a:	90                   	nop
  80184b:	c9                   	leave  
  80184c:	c3                   	ret    

0080184d <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80184d:	55                   	push   %ebp
  80184e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801850:	6a 00                	push   $0x0
  801852:	6a 00                	push   $0x0
  801854:	6a 00                	push   $0x0
  801856:	6a 00                	push   $0x0
  801858:	6a 00                	push   $0x0
  80185a:	6a 13                	push   $0x13
  80185c:	e8 13 fe ff ff       	call   801674 <syscall>
  801861:	83 c4 18             	add    $0x18,%esp
}
  801864:	90                   	nop
  801865:	c9                   	leave  
  801866:	c3                   	ret    

00801867 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801867:	55                   	push   %ebp
  801868:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80186a:	6a 00                	push   $0x0
  80186c:	6a 00                	push   $0x0
  80186e:	6a 00                	push   $0x0
  801870:	6a 00                	push   $0x0
  801872:	6a 00                	push   $0x0
  801874:	6a 14                	push   $0x14
  801876:	e8 f9 fd ff ff       	call   801674 <syscall>
  80187b:	83 c4 18             	add    $0x18,%esp
}
  80187e:	90                   	nop
  80187f:	c9                   	leave  
  801880:	c3                   	ret    

00801881 <sys_cputc>:


void
sys_cputc(const char c)
{
  801881:	55                   	push   %ebp
  801882:	89 e5                	mov    %esp,%ebp
  801884:	83 ec 04             	sub    $0x4,%esp
  801887:	8b 45 08             	mov    0x8(%ebp),%eax
  80188a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80188d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801891:	6a 00                	push   $0x0
  801893:	6a 00                	push   $0x0
  801895:	6a 00                	push   $0x0
  801897:	6a 00                	push   $0x0
  801899:	50                   	push   %eax
  80189a:	6a 15                	push   $0x15
  80189c:	e8 d3 fd ff ff       	call   801674 <syscall>
  8018a1:	83 c4 18             	add    $0x18,%esp
}
  8018a4:	90                   	nop
  8018a5:	c9                   	leave  
  8018a6:	c3                   	ret    

008018a7 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8018a7:	55                   	push   %ebp
  8018a8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8018aa:	6a 00                	push   $0x0
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 00                	push   $0x0
  8018b0:	6a 00                	push   $0x0
  8018b2:	6a 00                	push   $0x0
  8018b4:	6a 16                	push   $0x16
  8018b6:	e8 b9 fd ff ff       	call   801674 <syscall>
  8018bb:	83 c4 18             	add    $0x18,%esp
}
  8018be:	90                   	nop
  8018bf:	c9                   	leave  
  8018c0:	c3                   	ret    

008018c1 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8018c1:	55                   	push   %ebp
  8018c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8018c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c7:	6a 00                	push   $0x0
  8018c9:	6a 00                	push   $0x0
  8018cb:	6a 00                	push   $0x0
  8018cd:	ff 75 0c             	pushl  0xc(%ebp)
  8018d0:	50                   	push   %eax
  8018d1:	6a 17                	push   $0x17
  8018d3:	e8 9c fd ff ff       	call   801674 <syscall>
  8018d8:	83 c4 18             	add    $0x18,%esp
}
  8018db:	c9                   	leave  
  8018dc:	c3                   	ret    

008018dd <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8018dd:	55                   	push   %ebp
  8018de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e6:	6a 00                	push   $0x0
  8018e8:	6a 00                	push   $0x0
  8018ea:	6a 00                	push   $0x0
  8018ec:	52                   	push   %edx
  8018ed:	50                   	push   %eax
  8018ee:	6a 1a                	push   $0x1a
  8018f0:	e8 7f fd ff ff       	call   801674 <syscall>
  8018f5:	83 c4 18             	add    $0x18,%esp
}
  8018f8:	c9                   	leave  
  8018f9:	c3                   	ret    

008018fa <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8018fa:	55                   	push   %ebp
  8018fb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801900:	8b 45 08             	mov    0x8(%ebp),%eax
  801903:	6a 00                	push   $0x0
  801905:	6a 00                	push   $0x0
  801907:	6a 00                	push   $0x0
  801909:	52                   	push   %edx
  80190a:	50                   	push   %eax
  80190b:	6a 18                	push   $0x18
  80190d:	e8 62 fd ff ff       	call   801674 <syscall>
  801912:	83 c4 18             	add    $0x18,%esp
}
  801915:	90                   	nop
  801916:	c9                   	leave  
  801917:	c3                   	ret    

00801918 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801918:	55                   	push   %ebp
  801919:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80191b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80191e:	8b 45 08             	mov    0x8(%ebp),%eax
  801921:	6a 00                	push   $0x0
  801923:	6a 00                	push   $0x0
  801925:	6a 00                	push   $0x0
  801927:	52                   	push   %edx
  801928:	50                   	push   %eax
  801929:	6a 19                	push   $0x19
  80192b:	e8 44 fd ff ff       	call   801674 <syscall>
  801930:	83 c4 18             	add    $0x18,%esp
}
  801933:	90                   	nop
  801934:	c9                   	leave  
  801935:	c3                   	ret    

00801936 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801936:	55                   	push   %ebp
  801937:	89 e5                	mov    %esp,%ebp
  801939:	83 ec 04             	sub    $0x4,%esp
  80193c:	8b 45 10             	mov    0x10(%ebp),%eax
  80193f:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801942:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801945:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801949:	8b 45 08             	mov    0x8(%ebp),%eax
  80194c:	6a 00                	push   $0x0
  80194e:	51                   	push   %ecx
  80194f:	52                   	push   %edx
  801950:	ff 75 0c             	pushl  0xc(%ebp)
  801953:	50                   	push   %eax
  801954:	6a 1b                	push   $0x1b
  801956:	e8 19 fd ff ff       	call   801674 <syscall>
  80195b:	83 c4 18             	add    $0x18,%esp
}
  80195e:	c9                   	leave  
  80195f:	c3                   	ret    

00801960 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801960:	55                   	push   %ebp
  801961:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801963:	8b 55 0c             	mov    0xc(%ebp),%edx
  801966:	8b 45 08             	mov    0x8(%ebp),%eax
  801969:	6a 00                	push   $0x0
  80196b:	6a 00                	push   $0x0
  80196d:	6a 00                	push   $0x0
  80196f:	52                   	push   %edx
  801970:	50                   	push   %eax
  801971:	6a 1c                	push   $0x1c
  801973:	e8 fc fc ff ff       	call   801674 <syscall>
  801978:	83 c4 18             	add    $0x18,%esp
}
  80197b:	c9                   	leave  
  80197c:	c3                   	ret    

0080197d <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80197d:	55                   	push   %ebp
  80197e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801980:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801983:	8b 55 0c             	mov    0xc(%ebp),%edx
  801986:	8b 45 08             	mov    0x8(%ebp),%eax
  801989:	6a 00                	push   $0x0
  80198b:	6a 00                	push   $0x0
  80198d:	51                   	push   %ecx
  80198e:	52                   	push   %edx
  80198f:	50                   	push   %eax
  801990:	6a 1d                	push   $0x1d
  801992:	e8 dd fc ff ff       	call   801674 <syscall>
  801997:	83 c4 18             	add    $0x18,%esp
}
  80199a:	c9                   	leave  
  80199b:	c3                   	ret    

0080199c <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80199c:	55                   	push   %ebp
  80199d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80199f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 00                	push   $0x0
  8019ab:	52                   	push   %edx
  8019ac:	50                   	push   %eax
  8019ad:	6a 1e                	push   $0x1e
  8019af:	e8 c0 fc ff ff       	call   801674 <syscall>
  8019b4:	83 c4 18             	add    $0x18,%esp
}
  8019b7:	c9                   	leave  
  8019b8:	c3                   	ret    

008019b9 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8019b9:	55                   	push   %ebp
  8019ba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 00                	push   $0x0
  8019c2:	6a 00                	push   $0x0
  8019c4:	6a 00                	push   $0x0
  8019c6:	6a 1f                	push   $0x1f
  8019c8:	e8 a7 fc ff ff       	call   801674 <syscall>
  8019cd:	83 c4 18             	add    $0x18,%esp
}
  8019d0:	c9                   	leave  
  8019d1:	c3                   	ret    

008019d2 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8019d2:	55                   	push   %ebp
  8019d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8019d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d8:	6a 00                	push   $0x0
  8019da:	ff 75 14             	pushl  0x14(%ebp)
  8019dd:	ff 75 10             	pushl  0x10(%ebp)
  8019e0:	ff 75 0c             	pushl  0xc(%ebp)
  8019e3:	50                   	push   %eax
  8019e4:	6a 20                	push   $0x20
  8019e6:	e8 89 fc ff ff       	call   801674 <syscall>
  8019eb:	83 c4 18             	add    $0x18,%esp
}
  8019ee:	c9                   	leave  
  8019ef:	c3                   	ret    

008019f0 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8019f0:	55                   	push   %ebp
  8019f1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8019f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f6:	6a 00                	push   $0x0
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 00                	push   $0x0
  8019fe:	50                   	push   %eax
  8019ff:	6a 21                	push   $0x21
  801a01:	e8 6e fc ff ff       	call   801674 <syscall>
  801a06:	83 c4 18             	add    $0x18,%esp
}
  801a09:	90                   	nop
  801a0a:	c9                   	leave  
  801a0b:	c3                   	ret    

00801a0c <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801a0c:	55                   	push   %ebp
  801a0d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a12:	6a 00                	push   $0x0
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	6a 00                	push   $0x0
  801a1a:	50                   	push   %eax
  801a1b:	6a 22                	push   $0x22
  801a1d:	e8 52 fc ff ff       	call   801674 <syscall>
  801a22:	83 c4 18             	add    $0x18,%esp
}
  801a25:	c9                   	leave  
  801a26:	c3                   	ret    

00801a27 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801a27:	55                   	push   %ebp
  801a28:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 00                	push   $0x0
  801a32:	6a 00                	push   $0x0
  801a34:	6a 02                	push   $0x2
  801a36:	e8 39 fc ff ff       	call   801674 <syscall>
  801a3b:	83 c4 18             	add    $0x18,%esp
}
  801a3e:	c9                   	leave  
  801a3f:	c3                   	ret    

00801a40 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801a40:	55                   	push   %ebp
  801a41:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801a43:	6a 00                	push   $0x0
  801a45:	6a 00                	push   $0x0
  801a47:	6a 00                	push   $0x0
  801a49:	6a 00                	push   $0x0
  801a4b:	6a 00                	push   $0x0
  801a4d:	6a 03                	push   $0x3
  801a4f:	e8 20 fc ff ff       	call   801674 <syscall>
  801a54:	83 c4 18             	add    $0x18,%esp
}
  801a57:	c9                   	leave  
  801a58:	c3                   	ret    

00801a59 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801a59:	55                   	push   %ebp
  801a5a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801a5c:	6a 00                	push   $0x0
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 00                	push   $0x0
  801a62:	6a 00                	push   $0x0
  801a64:	6a 00                	push   $0x0
  801a66:	6a 04                	push   $0x4
  801a68:	e8 07 fc ff ff       	call   801674 <syscall>
  801a6d:	83 c4 18             	add    $0x18,%esp
}
  801a70:	c9                   	leave  
  801a71:	c3                   	ret    

00801a72 <sys_exit_env>:


void sys_exit_env(void)
{
  801a72:	55                   	push   %ebp
  801a73:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801a75:	6a 00                	push   $0x0
  801a77:	6a 00                	push   $0x0
  801a79:	6a 00                	push   $0x0
  801a7b:	6a 00                	push   $0x0
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 23                	push   $0x23
  801a81:	e8 ee fb ff ff       	call   801674 <syscall>
  801a86:	83 c4 18             	add    $0x18,%esp
}
  801a89:	90                   	nop
  801a8a:	c9                   	leave  
  801a8b:	c3                   	ret    

00801a8c <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801a8c:	55                   	push   %ebp
  801a8d:	89 e5                	mov    %esp,%ebp
  801a8f:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801a92:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a95:	8d 50 04             	lea    0x4(%eax),%edx
  801a98:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a9b:	6a 00                	push   $0x0
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 00                	push   $0x0
  801aa1:	52                   	push   %edx
  801aa2:	50                   	push   %eax
  801aa3:	6a 24                	push   $0x24
  801aa5:	e8 ca fb ff ff       	call   801674 <syscall>
  801aaa:	83 c4 18             	add    $0x18,%esp
	return result;
  801aad:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ab0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ab3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ab6:	89 01                	mov    %eax,(%ecx)
  801ab8:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801abb:	8b 45 08             	mov    0x8(%ebp),%eax
  801abe:	c9                   	leave  
  801abf:	c2 04 00             	ret    $0x4

00801ac2 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801ac2:	55                   	push   %ebp
  801ac3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	ff 75 10             	pushl  0x10(%ebp)
  801acc:	ff 75 0c             	pushl  0xc(%ebp)
  801acf:	ff 75 08             	pushl  0x8(%ebp)
  801ad2:	6a 12                	push   $0x12
  801ad4:	e8 9b fb ff ff       	call   801674 <syscall>
  801ad9:	83 c4 18             	add    $0x18,%esp
	return ;
  801adc:	90                   	nop
}
  801add:	c9                   	leave  
  801ade:	c3                   	ret    

00801adf <sys_rcr2>:
uint32 sys_rcr2()
{
  801adf:	55                   	push   %ebp
  801ae0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ae2:	6a 00                	push   $0x0
  801ae4:	6a 00                	push   $0x0
  801ae6:	6a 00                	push   $0x0
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 00                	push   $0x0
  801aec:	6a 25                	push   $0x25
  801aee:	e8 81 fb ff ff       	call   801674 <syscall>
  801af3:	83 c4 18             	add    $0x18,%esp
}
  801af6:	c9                   	leave  
  801af7:	c3                   	ret    

00801af8 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801af8:	55                   	push   %ebp
  801af9:	89 e5                	mov    %esp,%ebp
  801afb:	83 ec 04             	sub    $0x4,%esp
  801afe:	8b 45 08             	mov    0x8(%ebp),%eax
  801b01:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801b04:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801b08:	6a 00                	push   $0x0
  801b0a:	6a 00                	push   $0x0
  801b0c:	6a 00                	push   $0x0
  801b0e:	6a 00                	push   $0x0
  801b10:	50                   	push   %eax
  801b11:	6a 26                	push   $0x26
  801b13:	e8 5c fb ff ff       	call   801674 <syscall>
  801b18:	83 c4 18             	add    $0x18,%esp
	return ;
  801b1b:	90                   	nop
}
  801b1c:	c9                   	leave  
  801b1d:	c3                   	ret    

00801b1e <rsttst>:
void rsttst()
{
  801b1e:	55                   	push   %ebp
  801b1f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801b21:	6a 00                	push   $0x0
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 28                	push   $0x28
  801b2d:	e8 42 fb ff ff       	call   801674 <syscall>
  801b32:	83 c4 18             	add    $0x18,%esp
	return ;
  801b35:	90                   	nop
}
  801b36:	c9                   	leave  
  801b37:	c3                   	ret    

00801b38 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801b38:	55                   	push   %ebp
  801b39:	89 e5                	mov    %esp,%ebp
  801b3b:	83 ec 04             	sub    $0x4,%esp
  801b3e:	8b 45 14             	mov    0x14(%ebp),%eax
  801b41:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801b44:	8b 55 18             	mov    0x18(%ebp),%edx
  801b47:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b4b:	52                   	push   %edx
  801b4c:	50                   	push   %eax
  801b4d:	ff 75 10             	pushl  0x10(%ebp)
  801b50:	ff 75 0c             	pushl  0xc(%ebp)
  801b53:	ff 75 08             	pushl  0x8(%ebp)
  801b56:	6a 27                	push   $0x27
  801b58:	e8 17 fb ff ff       	call   801674 <syscall>
  801b5d:	83 c4 18             	add    $0x18,%esp
	return ;
  801b60:	90                   	nop
}
  801b61:	c9                   	leave  
  801b62:	c3                   	ret    

00801b63 <chktst>:
void chktst(uint32 n)
{
  801b63:	55                   	push   %ebp
  801b64:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801b66:	6a 00                	push   $0x0
  801b68:	6a 00                	push   $0x0
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 00                	push   $0x0
  801b6e:	ff 75 08             	pushl  0x8(%ebp)
  801b71:	6a 29                	push   $0x29
  801b73:	e8 fc fa ff ff       	call   801674 <syscall>
  801b78:	83 c4 18             	add    $0x18,%esp
	return ;
  801b7b:	90                   	nop
}
  801b7c:	c9                   	leave  
  801b7d:	c3                   	ret    

00801b7e <inctst>:

void inctst()
{
  801b7e:	55                   	push   %ebp
  801b7f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801b81:	6a 00                	push   $0x0
  801b83:	6a 00                	push   $0x0
  801b85:	6a 00                	push   $0x0
  801b87:	6a 00                	push   $0x0
  801b89:	6a 00                	push   $0x0
  801b8b:	6a 2a                	push   $0x2a
  801b8d:	e8 e2 fa ff ff       	call   801674 <syscall>
  801b92:	83 c4 18             	add    $0x18,%esp
	return ;
  801b95:	90                   	nop
}
  801b96:	c9                   	leave  
  801b97:	c3                   	ret    

00801b98 <gettst>:
uint32 gettst()
{
  801b98:	55                   	push   %ebp
  801b99:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 00                	push   $0x0
  801b9f:	6a 00                	push   $0x0
  801ba1:	6a 00                	push   $0x0
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 2b                	push   $0x2b
  801ba7:	e8 c8 fa ff ff       	call   801674 <syscall>
  801bac:	83 c4 18             	add    $0x18,%esp
}
  801baf:	c9                   	leave  
  801bb0:	c3                   	ret    

00801bb1 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801bb1:	55                   	push   %ebp
  801bb2:	89 e5                	mov    %esp,%ebp
  801bb4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bb7:	6a 00                	push   $0x0
  801bb9:	6a 00                	push   $0x0
  801bbb:	6a 00                	push   $0x0
  801bbd:	6a 00                	push   $0x0
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 2c                	push   $0x2c
  801bc3:	e8 ac fa ff ff       	call   801674 <syscall>
  801bc8:	83 c4 18             	add    $0x18,%esp
  801bcb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801bce:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801bd2:	75 07                	jne    801bdb <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801bd4:	b8 01 00 00 00       	mov    $0x1,%eax
  801bd9:	eb 05                	jmp    801be0 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801bdb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801be0:	c9                   	leave  
  801be1:	c3                   	ret    

00801be2 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801be2:	55                   	push   %ebp
  801be3:	89 e5                	mov    %esp,%ebp
  801be5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801be8:	6a 00                	push   $0x0
  801bea:	6a 00                	push   $0x0
  801bec:	6a 00                	push   $0x0
  801bee:	6a 00                	push   $0x0
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 2c                	push   $0x2c
  801bf4:	e8 7b fa ff ff       	call   801674 <syscall>
  801bf9:	83 c4 18             	add    $0x18,%esp
  801bfc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801bff:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801c03:	75 07                	jne    801c0c <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801c05:	b8 01 00 00 00       	mov    $0x1,%eax
  801c0a:	eb 05                	jmp    801c11 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801c0c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c11:	c9                   	leave  
  801c12:	c3                   	ret    

00801c13 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801c13:	55                   	push   %ebp
  801c14:	89 e5                	mov    %esp,%ebp
  801c16:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	6a 2c                	push   $0x2c
  801c25:	e8 4a fa ff ff       	call   801674 <syscall>
  801c2a:	83 c4 18             	add    $0x18,%esp
  801c2d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801c30:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801c34:	75 07                	jne    801c3d <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801c36:	b8 01 00 00 00       	mov    $0x1,%eax
  801c3b:	eb 05                	jmp    801c42 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801c3d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c42:	c9                   	leave  
  801c43:	c3                   	ret    

00801c44 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801c44:	55                   	push   %ebp
  801c45:	89 e5                	mov    %esp,%ebp
  801c47:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 00                	push   $0x0
  801c52:	6a 00                	push   $0x0
  801c54:	6a 2c                	push   $0x2c
  801c56:	e8 19 fa ff ff       	call   801674 <syscall>
  801c5b:	83 c4 18             	add    $0x18,%esp
  801c5e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801c61:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801c65:	75 07                	jne    801c6e <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801c67:	b8 01 00 00 00       	mov    $0x1,%eax
  801c6c:	eb 05                	jmp    801c73 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801c6e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c73:	c9                   	leave  
  801c74:	c3                   	ret    

00801c75 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c75:	55                   	push   %ebp
  801c76:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c78:	6a 00                	push   $0x0
  801c7a:	6a 00                	push   $0x0
  801c7c:	6a 00                	push   $0x0
  801c7e:	6a 00                	push   $0x0
  801c80:	ff 75 08             	pushl  0x8(%ebp)
  801c83:	6a 2d                	push   $0x2d
  801c85:	e8 ea f9 ff ff       	call   801674 <syscall>
  801c8a:	83 c4 18             	add    $0x18,%esp
	return ;
  801c8d:	90                   	nop
}
  801c8e:	c9                   	leave  
  801c8f:	c3                   	ret    

00801c90 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801c90:	55                   	push   %ebp
  801c91:	89 e5                	mov    %esp,%ebp
  801c93:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801c94:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c97:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca0:	6a 00                	push   $0x0
  801ca2:	53                   	push   %ebx
  801ca3:	51                   	push   %ecx
  801ca4:	52                   	push   %edx
  801ca5:	50                   	push   %eax
  801ca6:	6a 2e                	push   $0x2e
  801ca8:	e8 c7 f9 ff ff       	call   801674 <syscall>
  801cad:	83 c4 18             	add    $0x18,%esp
}
  801cb0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cb3:	c9                   	leave  
  801cb4:	c3                   	ret    

00801cb5 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801cb5:	55                   	push   %ebp
  801cb6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801cb8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbe:	6a 00                	push   $0x0
  801cc0:	6a 00                	push   $0x0
  801cc2:	6a 00                	push   $0x0
  801cc4:	52                   	push   %edx
  801cc5:	50                   	push   %eax
  801cc6:	6a 2f                	push   $0x2f
  801cc8:	e8 a7 f9 ff ff       	call   801674 <syscall>
  801ccd:	83 c4 18             	add    $0x18,%esp
}
  801cd0:	c9                   	leave  
  801cd1:	c3                   	ret    

00801cd2 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801cd2:	55                   	push   %ebp
  801cd3:	89 e5                	mov    %esp,%ebp
  801cd5:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801cd8:	83 ec 0c             	sub    $0xc,%esp
  801cdb:	68 64 3e 80 00       	push   $0x803e64
  801ce0:	e8 46 e8 ff ff       	call   80052b <cprintf>
  801ce5:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801ce8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801cef:	83 ec 0c             	sub    $0xc,%esp
  801cf2:	68 90 3e 80 00       	push   $0x803e90
  801cf7:	e8 2f e8 ff ff       	call   80052b <cprintf>
  801cfc:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801cff:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d03:	a1 38 51 80 00       	mov    0x805138,%eax
  801d08:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d0b:	eb 56                	jmp    801d63 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801d0d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d11:	74 1c                	je     801d2f <print_mem_block_lists+0x5d>
  801d13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d16:	8b 50 08             	mov    0x8(%eax),%edx
  801d19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d1c:	8b 48 08             	mov    0x8(%eax),%ecx
  801d1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d22:	8b 40 0c             	mov    0xc(%eax),%eax
  801d25:	01 c8                	add    %ecx,%eax
  801d27:	39 c2                	cmp    %eax,%edx
  801d29:	73 04                	jae    801d2f <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801d2b:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801d2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d32:	8b 50 08             	mov    0x8(%eax),%edx
  801d35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d38:	8b 40 0c             	mov    0xc(%eax),%eax
  801d3b:	01 c2                	add    %eax,%edx
  801d3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d40:	8b 40 08             	mov    0x8(%eax),%eax
  801d43:	83 ec 04             	sub    $0x4,%esp
  801d46:	52                   	push   %edx
  801d47:	50                   	push   %eax
  801d48:	68 a5 3e 80 00       	push   $0x803ea5
  801d4d:	e8 d9 e7 ff ff       	call   80052b <cprintf>
  801d52:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801d55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d58:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d5b:	a1 40 51 80 00       	mov    0x805140,%eax
  801d60:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d63:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d67:	74 07                	je     801d70 <print_mem_block_lists+0x9e>
  801d69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d6c:	8b 00                	mov    (%eax),%eax
  801d6e:	eb 05                	jmp    801d75 <print_mem_block_lists+0xa3>
  801d70:	b8 00 00 00 00       	mov    $0x0,%eax
  801d75:	a3 40 51 80 00       	mov    %eax,0x805140
  801d7a:	a1 40 51 80 00       	mov    0x805140,%eax
  801d7f:	85 c0                	test   %eax,%eax
  801d81:	75 8a                	jne    801d0d <print_mem_block_lists+0x3b>
  801d83:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d87:	75 84                	jne    801d0d <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801d89:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801d8d:	75 10                	jne    801d9f <print_mem_block_lists+0xcd>
  801d8f:	83 ec 0c             	sub    $0xc,%esp
  801d92:	68 b4 3e 80 00       	push   $0x803eb4
  801d97:	e8 8f e7 ff ff       	call   80052b <cprintf>
  801d9c:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801d9f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801da6:	83 ec 0c             	sub    $0xc,%esp
  801da9:	68 d8 3e 80 00       	push   $0x803ed8
  801dae:	e8 78 e7 ff ff       	call   80052b <cprintf>
  801db3:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801db6:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801dba:	a1 40 50 80 00       	mov    0x805040,%eax
  801dbf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dc2:	eb 56                	jmp    801e1a <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801dc4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801dc8:	74 1c                	je     801de6 <print_mem_block_lists+0x114>
  801dca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dcd:	8b 50 08             	mov    0x8(%eax),%edx
  801dd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dd3:	8b 48 08             	mov    0x8(%eax),%ecx
  801dd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dd9:	8b 40 0c             	mov    0xc(%eax),%eax
  801ddc:	01 c8                	add    %ecx,%eax
  801dde:	39 c2                	cmp    %eax,%edx
  801de0:	73 04                	jae    801de6 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801de2:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801de6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801de9:	8b 50 08             	mov    0x8(%eax),%edx
  801dec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801def:	8b 40 0c             	mov    0xc(%eax),%eax
  801df2:	01 c2                	add    %eax,%edx
  801df4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df7:	8b 40 08             	mov    0x8(%eax),%eax
  801dfa:	83 ec 04             	sub    $0x4,%esp
  801dfd:	52                   	push   %edx
  801dfe:	50                   	push   %eax
  801dff:	68 a5 3e 80 00       	push   $0x803ea5
  801e04:	e8 22 e7 ff ff       	call   80052b <cprintf>
  801e09:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e0f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801e12:	a1 48 50 80 00       	mov    0x805048,%eax
  801e17:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e1a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e1e:	74 07                	je     801e27 <print_mem_block_lists+0x155>
  801e20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e23:	8b 00                	mov    (%eax),%eax
  801e25:	eb 05                	jmp    801e2c <print_mem_block_lists+0x15a>
  801e27:	b8 00 00 00 00       	mov    $0x0,%eax
  801e2c:	a3 48 50 80 00       	mov    %eax,0x805048
  801e31:	a1 48 50 80 00       	mov    0x805048,%eax
  801e36:	85 c0                	test   %eax,%eax
  801e38:	75 8a                	jne    801dc4 <print_mem_block_lists+0xf2>
  801e3a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e3e:	75 84                	jne    801dc4 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801e40:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e44:	75 10                	jne    801e56 <print_mem_block_lists+0x184>
  801e46:	83 ec 0c             	sub    $0xc,%esp
  801e49:	68 f0 3e 80 00       	push   $0x803ef0
  801e4e:	e8 d8 e6 ff ff       	call   80052b <cprintf>
  801e53:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801e56:	83 ec 0c             	sub    $0xc,%esp
  801e59:	68 64 3e 80 00       	push   $0x803e64
  801e5e:	e8 c8 e6 ff ff       	call   80052b <cprintf>
  801e63:	83 c4 10             	add    $0x10,%esp

}
  801e66:	90                   	nop
  801e67:	c9                   	leave  
  801e68:	c3                   	ret    

00801e69 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801e69:	55                   	push   %ebp
  801e6a:	89 e5                	mov    %esp,%ebp
  801e6c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801e6f:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  801e76:	00 00 00 
  801e79:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  801e80:	00 00 00 
  801e83:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  801e8a:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801e8d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801e94:	e9 9e 00 00 00       	jmp    801f37 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801e99:	a1 50 50 80 00       	mov    0x805050,%eax
  801e9e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ea1:	c1 e2 04             	shl    $0x4,%edx
  801ea4:	01 d0                	add    %edx,%eax
  801ea6:	85 c0                	test   %eax,%eax
  801ea8:	75 14                	jne    801ebe <initialize_MemBlocksList+0x55>
  801eaa:	83 ec 04             	sub    $0x4,%esp
  801ead:	68 18 3f 80 00       	push   $0x803f18
  801eb2:	6a 46                	push   $0x46
  801eb4:	68 3b 3f 80 00       	push   $0x803f3b
  801eb9:	e8 b9 e3 ff ff       	call   800277 <_panic>
  801ebe:	a1 50 50 80 00       	mov    0x805050,%eax
  801ec3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ec6:	c1 e2 04             	shl    $0x4,%edx
  801ec9:	01 d0                	add    %edx,%eax
  801ecb:	8b 15 48 51 80 00    	mov    0x805148,%edx
  801ed1:	89 10                	mov    %edx,(%eax)
  801ed3:	8b 00                	mov    (%eax),%eax
  801ed5:	85 c0                	test   %eax,%eax
  801ed7:	74 18                	je     801ef1 <initialize_MemBlocksList+0x88>
  801ed9:	a1 48 51 80 00       	mov    0x805148,%eax
  801ede:	8b 15 50 50 80 00    	mov    0x805050,%edx
  801ee4:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801ee7:	c1 e1 04             	shl    $0x4,%ecx
  801eea:	01 ca                	add    %ecx,%edx
  801eec:	89 50 04             	mov    %edx,0x4(%eax)
  801eef:	eb 12                	jmp    801f03 <initialize_MemBlocksList+0x9a>
  801ef1:	a1 50 50 80 00       	mov    0x805050,%eax
  801ef6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ef9:	c1 e2 04             	shl    $0x4,%edx
  801efc:	01 d0                	add    %edx,%eax
  801efe:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801f03:	a1 50 50 80 00       	mov    0x805050,%eax
  801f08:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f0b:	c1 e2 04             	shl    $0x4,%edx
  801f0e:	01 d0                	add    %edx,%eax
  801f10:	a3 48 51 80 00       	mov    %eax,0x805148
  801f15:	a1 50 50 80 00       	mov    0x805050,%eax
  801f1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f1d:	c1 e2 04             	shl    $0x4,%edx
  801f20:	01 d0                	add    %edx,%eax
  801f22:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f29:	a1 54 51 80 00       	mov    0x805154,%eax
  801f2e:	40                   	inc    %eax
  801f2f:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801f34:	ff 45 f4             	incl   -0xc(%ebp)
  801f37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f3a:	3b 45 08             	cmp    0x8(%ebp),%eax
  801f3d:	0f 82 56 ff ff ff    	jb     801e99 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801f43:	90                   	nop
  801f44:	c9                   	leave  
  801f45:	c3                   	ret    

00801f46 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801f46:	55                   	push   %ebp
  801f47:	89 e5                	mov    %esp,%ebp
  801f49:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801f4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4f:	8b 00                	mov    (%eax),%eax
  801f51:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f54:	eb 19                	jmp    801f6f <find_block+0x29>
	{
		if(va==point->sva)
  801f56:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f59:	8b 40 08             	mov    0x8(%eax),%eax
  801f5c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801f5f:	75 05                	jne    801f66 <find_block+0x20>
		   return point;
  801f61:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f64:	eb 36                	jmp    801f9c <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801f66:	8b 45 08             	mov    0x8(%ebp),%eax
  801f69:	8b 40 08             	mov    0x8(%eax),%eax
  801f6c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f6f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f73:	74 07                	je     801f7c <find_block+0x36>
  801f75:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f78:	8b 00                	mov    (%eax),%eax
  801f7a:	eb 05                	jmp    801f81 <find_block+0x3b>
  801f7c:	b8 00 00 00 00       	mov    $0x0,%eax
  801f81:	8b 55 08             	mov    0x8(%ebp),%edx
  801f84:	89 42 08             	mov    %eax,0x8(%edx)
  801f87:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8a:	8b 40 08             	mov    0x8(%eax),%eax
  801f8d:	85 c0                	test   %eax,%eax
  801f8f:	75 c5                	jne    801f56 <find_block+0x10>
  801f91:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f95:	75 bf                	jne    801f56 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  801f97:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f9c:	c9                   	leave  
  801f9d:	c3                   	ret    

00801f9e <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  801f9e:	55                   	push   %ebp
  801f9f:	89 e5                	mov    %esp,%ebp
  801fa1:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  801fa4:	a1 40 50 80 00       	mov    0x805040,%eax
  801fa9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  801fac:	a1 44 50 80 00       	mov    0x805044,%eax
  801fb1:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  801fb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fb7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801fba:	74 24                	je     801fe0 <insert_sorted_allocList+0x42>
  801fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  801fbf:	8b 50 08             	mov    0x8(%eax),%edx
  801fc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fc5:	8b 40 08             	mov    0x8(%eax),%eax
  801fc8:	39 c2                	cmp    %eax,%edx
  801fca:	76 14                	jbe    801fe0 <insert_sorted_allocList+0x42>
  801fcc:	8b 45 08             	mov    0x8(%ebp),%eax
  801fcf:	8b 50 08             	mov    0x8(%eax),%edx
  801fd2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fd5:	8b 40 08             	mov    0x8(%eax),%eax
  801fd8:	39 c2                	cmp    %eax,%edx
  801fda:	0f 82 60 01 00 00    	jb     802140 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  801fe0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fe4:	75 65                	jne    80204b <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  801fe6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801fea:	75 14                	jne    802000 <insert_sorted_allocList+0x62>
  801fec:	83 ec 04             	sub    $0x4,%esp
  801fef:	68 18 3f 80 00       	push   $0x803f18
  801ff4:	6a 6b                	push   $0x6b
  801ff6:	68 3b 3f 80 00       	push   $0x803f3b
  801ffb:	e8 77 e2 ff ff       	call   800277 <_panic>
  802000:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802006:	8b 45 08             	mov    0x8(%ebp),%eax
  802009:	89 10                	mov    %edx,(%eax)
  80200b:	8b 45 08             	mov    0x8(%ebp),%eax
  80200e:	8b 00                	mov    (%eax),%eax
  802010:	85 c0                	test   %eax,%eax
  802012:	74 0d                	je     802021 <insert_sorted_allocList+0x83>
  802014:	a1 40 50 80 00       	mov    0x805040,%eax
  802019:	8b 55 08             	mov    0x8(%ebp),%edx
  80201c:	89 50 04             	mov    %edx,0x4(%eax)
  80201f:	eb 08                	jmp    802029 <insert_sorted_allocList+0x8b>
  802021:	8b 45 08             	mov    0x8(%ebp),%eax
  802024:	a3 44 50 80 00       	mov    %eax,0x805044
  802029:	8b 45 08             	mov    0x8(%ebp),%eax
  80202c:	a3 40 50 80 00       	mov    %eax,0x805040
  802031:	8b 45 08             	mov    0x8(%ebp),%eax
  802034:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80203b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802040:	40                   	inc    %eax
  802041:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802046:	e9 dc 01 00 00       	jmp    802227 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  80204b:	8b 45 08             	mov    0x8(%ebp),%eax
  80204e:	8b 50 08             	mov    0x8(%eax),%edx
  802051:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802054:	8b 40 08             	mov    0x8(%eax),%eax
  802057:	39 c2                	cmp    %eax,%edx
  802059:	77 6c                	ja     8020c7 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  80205b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80205f:	74 06                	je     802067 <insert_sorted_allocList+0xc9>
  802061:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802065:	75 14                	jne    80207b <insert_sorted_allocList+0xdd>
  802067:	83 ec 04             	sub    $0x4,%esp
  80206a:	68 54 3f 80 00       	push   $0x803f54
  80206f:	6a 6f                	push   $0x6f
  802071:	68 3b 3f 80 00       	push   $0x803f3b
  802076:	e8 fc e1 ff ff       	call   800277 <_panic>
  80207b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80207e:	8b 50 04             	mov    0x4(%eax),%edx
  802081:	8b 45 08             	mov    0x8(%ebp),%eax
  802084:	89 50 04             	mov    %edx,0x4(%eax)
  802087:	8b 45 08             	mov    0x8(%ebp),%eax
  80208a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80208d:	89 10                	mov    %edx,(%eax)
  80208f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802092:	8b 40 04             	mov    0x4(%eax),%eax
  802095:	85 c0                	test   %eax,%eax
  802097:	74 0d                	je     8020a6 <insert_sorted_allocList+0x108>
  802099:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80209c:	8b 40 04             	mov    0x4(%eax),%eax
  80209f:	8b 55 08             	mov    0x8(%ebp),%edx
  8020a2:	89 10                	mov    %edx,(%eax)
  8020a4:	eb 08                	jmp    8020ae <insert_sorted_allocList+0x110>
  8020a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a9:	a3 40 50 80 00       	mov    %eax,0x805040
  8020ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8020b4:	89 50 04             	mov    %edx,0x4(%eax)
  8020b7:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8020bc:	40                   	inc    %eax
  8020bd:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8020c2:	e9 60 01 00 00       	jmp    802227 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8020c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ca:	8b 50 08             	mov    0x8(%eax),%edx
  8020cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020d0:	8b 40 08             	mov    0x8(%eax),%eax
  8020d3:	39 c2                	cmp    %eax,%edx
  8020d5:	0f 82 4c 01 00 00    	jb     802227 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8020db:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020df:	75 14                	jne    8020f5 <insert_sorted_allocList+0x157>
  8020e1:	83 ec 04             	sub    $0x4,%esp
  8020e4:	68 8c 3f 80 00       	push   $0x803f8c
  8020e9:	6a 73                	push   $0x73
  8020eb:	68 3b 3f 80 00       	push   $0x803f3b
  8020f0:	e8 82 e1 ff ff       	call   800277 <_panic>
  8020f5:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8020fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fe:	89 50 04             	mov    %edx,0x4(%eax)
  802101:	8b 45 08             	mov    0x8(%ebp),%eax
  802104:	8b 40 04             	mov    0x4(%eax),%eax
  802107:	85 c0                	test   %eax,%eax
  802109:	74 0c                	je     802117 <insert_sorted_allocList+0x179>
  80210b:	a1 44 50 80 00       	mov    0x805044,%eax
  802110:	8b 55 08             	mov    0x8(%ebp),%edx
  802113:	89 10                	mov    %edx,(%eax)
  802115:	eb 08                	jmp    80211f <insert_sorted_allocList+0x181>
  802117:	8b 45 08             	mov    0x8(%ebp),%eax
  80211a:	a3 40 50 80 00       	mov    %eax,0x805040
  80211f:	8b 45 08             	mov    0x8(%ebp),%eax
  802122:	a3 44 50 80 00       	mov    %eax,0x805044
  802127:	8b 45 08             	mov    0x8(%ebp),%eax
  80212a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802130:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802135:	40                   	inc    %eax
  802136:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80213b:	e9 e7 00 00 00       	jmp    802227 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802140:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802143:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802146:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80214d:	a1 40 50 80 00       	mov    0x805040,%eax
  802152:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802155:	e9 9d 00 00 00       	jmp    8021f7 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  80215a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80215d:	8b 00                	mov    (%eax),%eax
  80215f:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802162:	8b 45 08             	mov    0x8(%ebp),%eax
  802165:	8b 50 08             	mov    0x8(%eax),%edx
  802168:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216b:	8b 40 08             	mov    0x8(%eax),%eax
  80216e:	39 c2                	cmp    %eax,%edx
  802170:	76 7d                	jbe    8021ef <insert_sorted_allocList+0x251>
  802172:	8b 45 08             	mov    0x8(%ebp),%eax
  802175:	8b 50 08             	mov    0x8(%eax),%edx
  802178:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80217b:	8b 40 08             	mov    0x8(%eax),%eax
  80217e:	39 c2                	cmp    %eax,%edx
  802180:	73 6d                	jae    8021ef <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802182:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802186:	74 06                	je     80218e <insert_sorted_allocList+0x1f0>
  802188:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80218c:	75 14                	jne    8021a2 <insert_sorted_allocList+0x204>
  80218e:	83 ec 04             	sub    $0x4,%esp
  802191:	68 b0 3f 80 00       	push   $0x803fb0
  802196:	6a 7f                	push   $0x7f
  802198:	68 3b 3f 80 00       	push   $0x803f3b
  80219d:	e8 d5 e0 ff ff       	call   800277 <_panic>
  8021a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a5:	8b 10                	mov    (%eax),%edx
  8021a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021aa:	89 10                	mov    %edx,(%eax)
  8021ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8021af:	8b 00                	mov    (%eax),%eax
  8021b1:	85 c0                	test   %eax,%eax
  8021b3:	74 0b                	je     8021c0 <insert_sorted_allocList+0x222>
  8021b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b8:	8b 00                	mov    (%eax),%eax
  8021ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8021bd:	89 50 04             	mov    %edx,0x4(%eax)
  8021c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8021c6:	89 10                	mov    %edx,(%eax)
  8021c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021ce:	89 50 04             	mov    %edx,0x4(%eax)
  8021d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d4:	8b 00                	mov    (%eax),%eax
  8021d6:	85 c0                	test   %eax,%eax
  8021d8:	75 08                	jne    8021e2 <insert_sorted_allocList+0x244>
  8021da:	8b 45 08             	mov    0x8(%ebp),%eax
  8021dd:	a3 44 50 80 00       	mov    %eax,0x805044
  8021e2:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8021e7:	40                   	inc    %eax
  8021e8:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8021ed:	eb 39                	jmp    802228 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8021ef:	a1 48 50 80 00       	mov    0x805048,%eax
  8021f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021fb:	74 07                	je     802204 <insert_sorted_allocList+0x266>
  8021fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802200:	8b 00                	mov    (%eax),%eax
  802202:	eb 05                	jmp    802209 <insert_sorted_allocList+0x26b>
  802204:	b8 00 00 00 00       	mov    $0x0,%eax
  802209:	a3 48 50 80 00       	mov    %eax,0x805048
  80220e:	a1 48 50 80 00       	mov    0x805048,%eax
  802213:	85 c0                	test   %eax,%eax
  802215:	0f 85 3f ff ff ff    	jne    80215a <insert_sorted_allocList+0x1bc>
  80221b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80221f:	0f 85 35 ff ff ff    	jne    80215a <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802225:	eb 01                	jmp    802228 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802227:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802228:	90                   	nop
  802229:	c9                   	leave  
  80222a:	c3                   	ret    

0080222b <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80222b:	55                   	push   %ebp
  80222c:	89 e5                	mov    %esp,%ebp
  80222e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802231:	a1 38 51 80 00       	mov    0x805138,%eax
  802236:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802239:	e9 85 01 00 00       	jmp    8023c3 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  80223e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802241:	8b 40 0c             	mov    0xc(%eax),%eax
  802244:	3b 45 08             	cmp    0x8(%ebp),%eax
  802247:	0f 82 6e 01 00 00    	jb     8023bb <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  80224d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802250:	8b 40 0c             	mov    0xc(%eax),%eax
  802253:	3b 45 08             	cmp    0x8(%ebp),%eax
  802256:	0f 85 8a 00 00 00    	jne    8022e6 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  80225c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802260:	75 17                	jne    802279 <alloc_block_FF+0x4e>
  802262:	83 ec 04             	sub    $0x4,%esp
  802265:	68 e4 3f 80 00       	push   $0x803fe4
  80226a:	68 93 00 00 00       	push   $0x93
  80226f:	68 3b 3f 80 00       	push   $0x803f3b
  802274:	e8 fe df ff ff       	call   800277 <_panic>
  802279:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227c:	8b 00                	mov    (%eax),%eax
  80227e:	85 c0                	test   %eax,%eax
  802280:	74 10                	je     802292 <alloc_block_FF+0x67>
  802282:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802285:	8b 00                	mov    (%eax),%eax
  802287:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80228a:	8b 52 04             	mov    0x4(%edx),%edx
  80228d:	89 50 04             	mov    %edx,0x4(%eax)
  802290:	eb 0b                	jmp    80229d <alloc_block_FF+0x72>
  802292:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802295:	8b 40 04             	mov    0x4(%eax),%eax
  802298:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80229d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a0:	8b 40 04             	mov    0x4(%eax),%eax
  8022a3:	85 c0                	test   %eax,%eax
  8022a5:	74 0f                	je     8022b6 <alloc_block_FF+0x8b>
  8022a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022aa:	8b 40 04             	mov    0x4(%eax),%eax
  8022ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022b0:	8b 12                	mov    (%edx),%edx
  8022b2:	89 10                	mov    %edx,(%eax)
  8022b4:	eb 0a                	jmp    8022c0 <alloc_block_FF+0x95>
  8022b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b9:	8b 00                	mov    (%eax),%eax
  8022bb:	a3 38 51 80 00       	mov    %eax,0x805138
  8022c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022cc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022d3:	a1 44 51 80 00       	mov    0x805144,%eax
  8022d8:	48                   	dec    %eax
  8022d9:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  8022de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e1:	e9 10 01 00 00       	jmp    8023f6 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8022e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e9:	8b 40 0c             	mov    0xc(%eax),%eax
  8022ec:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022ef:	0f 86 c6 00 00 00    	jbe    8023bb <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8022f5:	a1 48 51 80 00       	mov    0x805148,%eax
  8022fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8022fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802300:	8b 50 08             	mov    0x8(%eax),%edx
  802303:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802306:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802309:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80230c:	8b 55 08             	mov    0x8(%ebp),%edx
  80230f:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802312:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802316:	75 17                	jne    80232f <alloc_block_FF+0x104>
  802318:	83 ec 04             	sub    $0x4,%esp
  80231b:	68 e4 3f 80 00       	push   $0x803fe4
  802320:	68 9b 00 00 00       	push   $0x9b
  802325:	68 3b 3f 80 00       	push   $0x803f3b
  80232a:	e8 48 df ff ff       	call   800277 <_panic>
  80232f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802332:	8b 00                	mov    (%eax),%eax
  802334:	85 c0                	test   %eax,%eax
  802336:	74 10                	je     802348 <alloc_block_FF+0x11d>
  802338:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80233b:	8b 00                	mov    (%eax),%eax
  80233d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802340:	8b 52 04             	mov    0x4(%edx),%edx
  802343:	89 50 04             	mov    %edx,0x4(%eax)
  802346:	eb 0b                	jmp    802353 <alloc_block_FF+0x128>
  802348:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80234b:	8b 40 04             	mov    0x4(%eax),%eax
  80234e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802353:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802356:	8b 40 04             	mov    0x4(%eax),%eax
  802359:	85 c0                	test   %eax,%eax
  80235b:	74 0f                	je     80236c <alloc_block_FF+0x141>
  80235d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802360:	8b 40 04             	mov    0x4(%eax),%eax
  802363:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802366:	8b 12                	mov    (%edx),%edx
  802368:	89 10                	mov    %edx,(%eax)
  80236a:	eb 0a                	jmp    802376 <alloc_block_FF+0x14b>
  80236c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80236f:	8b 00                	mov    (%eax),%eax
  802371:	a3 48 51 80 00       	mov    %eax,0x805148
  802376:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802379:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80237f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802382:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802389:	a1 54 51 80 00       	mov    0x805154,%eax
  80238e:	48                   	dec    %eax
  80238f:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802394:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802397:	8b 50 08             	mov    0x8(%eax),%edx
  80239a:	8b 45 08             	mov    0x8(%ebp),%eax
  80239d:	01 c2                	add    %eax,%edx
  80239f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a2:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8023a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a8:	8b 40 0c             	mov    0xc(%eax),%eax
  8023ab:	2b 45 08             	sub    0x8(%ebp),%eax
  8023ae:	89 c2                	mov    %eax,%edx
  8023b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b3:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8023b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023b9:	eb 3b                	jmp    8023f6 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8023bb:	a1 40 51 80 00       	mov    0x805140,%eax
  8023c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023c7:	74 07                	je     8023d0 <alloc_block_FF+0x1a5>
  8023c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cc:	8b 00                	mov    (%eax),%eax
  8023ce:	eb 05                	jmp    8023d5 <alloc_block_FF+0x1aa>
  8023d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8023d5:	a3 40 51 80 00       	mov    %eax,0x805140
  8023da:	a1 40 51 80 00       	mov    0x805140,%eax
  8023df:	85 c0                	test   %eax,%eax
  8023e1:	0f 85 57 fe ff ff    	jne    80223e <alloc_block_FF+0x13>
  8023e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023eb:	0f 85 4d fe ff ff    	jne    80223e <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8023f1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023f6:	c9                   	leave  
  8023f7:	c3                   	ret    

008023f8 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8023f8:	55                   	push   %ebp
  8023f9:	89 e5                	mov    %esp,%ebp
  8023fb:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8023fe:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802405:	a1 38 51 80 00       	mov    0x805138,%eax
  80240a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80240d:	e9 df 00 00 00       	jmp    8024f1 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802412:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802415:	8b 40 0c             	mov    0xc(%eax),%eax
  802418:	3b 45 08             	cmp    0x8(%ebp),%eax
  80241b:	0f 82 c8 00 00 00    	jb     8024e9 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802421:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802424:	8b 40 0c             	mov    0xc(%eax),%eax
  802427:	3b 45 08             	cmp    0x8(%ebp),%eax
  80242a:	0f 85 8a 00 00 00    	jne    8024ba <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802430:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802434:	75 17                	jne    80244d <alloc_block_BF+0x55>
  802436:	83 ec 04             	sub    $0x4,%esp
  802439:	68 e4 3f 80 00       	push   $0x803fe4
  80243e:	68 b7 00 00 00       	push   $0xb7
  802443:	68 3b 3f 80 00       	push   $0x803f3b
  802448:	e8 2a de ff ff       	call   800277 <_panic>
  80244d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802450:	8b 00                	mov    (%eax),%eax
  802452:	85 c0                	test   %eax,%eax
  802454:	74 10                	je     802466 <alloc_block_BF+0x6e>
  802456:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802459:	8b 00                	mov    (%eax),%eax
  80245b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80245e:	8b 52 04             	mov    0x4(%edx),%edx
  802461:	89 50 04             	mov    %edx,0x4(%eax)
  802464:	eb 0b                	jmp    802471 <alloc_block_BF+0x79>
  802466:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802469:	8b 40 04             	mov    0x4(%eax),%eax
  80246c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802471:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802474:	8b 40 04             	mov    0x4(%eax),%eax
  802477:	85 c0                	test   %eax,%eax
  802479:	74 0f                	je     80248a <alloc_block_BF+0x92>
  80247b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247e:	8b 40 04             	mov    0x4(%eax),%eax
  802481:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802484:	8b 12                	mov    (%edx),%edx
  802486:	89 10                	mov    %edx,(%eax)
  802488:	eb 0a                	jmp    802494 <alloc_block_BF+0x9c>
  80248a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248d:	8b 00                	mov    (%eax),%eax
  80248f:	a3 38 51 80 00       	mov    %eax,0x805138
  802494:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802497:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80249d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024a7:	a1 44 51 80 00       	mov    0x805144,%eax
  8024ac:	48                   	dec    %eax
  8024ad:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  8024b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b5:	e9 4d 01 00 00       	jmp    802607 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8024ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bd:	8b 40 0c             	mov    0xc(%eax),%eax
  8024c0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024c3:	76 24                	jbe    8024e9 <alloc_block_BF+0xf1>
  8024c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c8:	8b 40 0c             	mov    0xc(%eax),%eax
  8024cb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8024ce:	73 19                	jae    8024e9 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8024d0:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8024d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024da:	8b 40 0c             	mov    0xc(%eax),%eax
  8024dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8024e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e3:	8b 40 08             	mov    0x8(%eax),%eax
  8024e6:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8024e9:	a1 40 51 80 00       	mov    0x805140,%eax
  8024ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024f5:	74 07                	je     8024fe <alloc_block_BF+0x106>
  8024f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fa:	8b 00                	mov    (%eax),%eax
  8024fc:	eb 05                	jmp    802503 <alloc_block_BF+0x10b>
  8024fe:	b8 00 00 00 00       	mov    $0x0,%eax
  802503:	a3 40 51 80 00       	mov    %eax,0x805140
  802508:	a1 40 51 80 00       	mov    0x805140,%eax
  80250d:	85 c0                	test   %eax,%eax
  80250f:	0f 85 fd fe ff ff    	jne    802412 <alloc_block_BF+0x1a>
  802515:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802519:	0f 85 f3 fe ff ff    	jne    802412 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  80251f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802523:	0f 84 d9 00 00 00    	je     802602 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802529:	a1 48 51 80 00       	mov    0x805148,%eax
  80252e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802531:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802534:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802537:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  80253a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80253d:	8b 55 08             	mov    0x8(%ebp),%edx
  802540:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802543:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802547:	75 17                	jne    802560 <alloc_block_BF+0x168>
  802549:	83 ec 04             	sub    $0x4,%esp
  80254c:	68 e4 3f 80 00       	push   $0x803fe4
  802551:	68 c7 00 00 00       	push   $0xc7
  802556:	68 3b 3f 80 00       	push   $0x803f3b
  80255b:	e8 17 dd ff ff       	call   800277 <_panic>
  802560:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802563:	8b 00                	mov    (%eax),%eax
  802565:	85 c0                	test   %eax,%eax
  802567:	74 10                	je     802579 <alloc_block_BF+0x181>
  802569:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80256c:	8b 00                	mov    (%eax),%eax
  80256e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802571:	8b 52 04             	mov    0x4(%edx),%edx
  802574:	89 50 04             	mov    %edx,0x4(%eax)
  802577:	eb 0b                	jmp    802584 <alloc_block_BF+0x18c>
  802579:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80257c:	8b 40 04             	mov    0x4(%eax),%eax
  80257f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802584:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802587:	8b 40 04             	mov    0x4(%eax),%eax
  80258a:	85 c0                	test   %eax,%eax
  80258c:	74 0f                	je     80259d <alloc_block_BF+0x1a5>
  80258e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802591:	8b 40 04             	mov    0x4(%eax),%eax
  802594:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802597:	8b 12                	mov    (%edx),%edx
  802599:	89 10                	mov    %edx,(%eax)
  80259b:	eb 0a                	jmp    8025a7 <alloc_block_BF+0x1af>
  80259d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025a0:	8b 00                	mov    (%eax),%eax
  8025a2:	a3 48 51 80 00       	mov    %eax,0x805148
  8025a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025aa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025b3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025ba:	a1 54 51 80 00       	mov    0x805154,%eax
  8025bf:	48                   	dec    %eax
  8025c0:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8025c5:	83 ec 08             	sub    $0x8,%esp
  8025c8:	ff 75 ec             	pushl  -0x14(%ebp)
  8025cb:	68 38 51 80 00       	push   $0x805138
  8025d0:	e8 71 f9 ff ff       	call   801f46 <find_block>
  8025d5:	83 c4 10             	add    $0x10,%esp
  8025d8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8025db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025de:	8b 50 08             	mov    0x8(%eax),%edx
  8025e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e4:	01 c2                	add    %eax,%edx
  8025e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025e9:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8025ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025ef:	8b 40 0c             	mov    0xc(%eax),%eax
  8025f2:	2b 45 08             	sub    0x8(%ebp),%eax
  8025f5:	89 c2                	mov    %eax,%edx
  8025f7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025fa:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8025fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802600:	eb 05                	jmp    802607 <alloc_block_BF+0x20f>
	}
	return NULL;
  802602:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802607:	c9                   	leave  
  802608:	c3                   	ret    

00802609 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802609:	55                   	push   %ebp
  80260a:	89 e5                	mov    %esp,%ebp
  80260c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  80260f:	a1 28 50 80 00       	mov    0x805028,%eax
  802614:	85 c0                	test   %eax,%eax
  802616:	0f 85 de 01 00 00    	jne    8027fa <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80261c:	a1 38 51 80 00       	mov    0x805138,%eax
  802621:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802624:	e9 9e 01 00 00       	jmp    8027c7 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802629:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262c:	8b 40 0c             	mov    0xc(%eax),%eax
  80262f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802632:	0f 82 87 01 00 00    	jb     8027bf <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802638:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263b:	8b 40 0c             	mov    0xc(%eax),%eax
  80263e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802641:	0f 85 95 00 00 00    	jne    8026dc <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802647:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80264b:	75 17                	jne    802664 <alloc_block_NF+0x5b>
  80264d:	83 ec 04             	sub    $0x4,%esp
  802650:	68 e4 3f 80 00       	push   $0x803fe4
  802655:	68 e0 00 00 00       	push   $0xe0
  80265a:	68 3b 3f 80 00       	push   $0x803f3b
  80265f:	e8 13 dc ff ff       	call   800277 <_panic>
  802664:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802667:	8b 00                	mov    (%eax),%eax
  802669:	85 c0                	test   %eax,%eax
  80266b:	74 10                	je     80267d <alloc_block_NF+0x74>
  80266d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802670:	8b 00                	mov    (%eax),%eax
  802672:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802675:	8b 52 04             	mov    0x4(%edx),%edx
  802678:	89 50 04             	mov    %edx,0x4(%eax)
  80267b:	eb 0b                	jmp    802688 <alloc_block_NF+0x7f>
  80267d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802680:	8b 40 04             	mov    0x4(%eax),%eax
  802683:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802688:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268b:	8b 40 04             	mov    0x4(%eax),%eax
  80268e:	85 c0                	test   %eax,%eax
  802690:	74 0f                	je     8026a1 <alloc_block_NF+0x98>
  802692:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802695:	8b 40 04             	mov    0x4(%eax),%eax
  802698:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80269b:	8b 12                	mov    (%edx),%edx
  80269d:	89 10                	mov    %edx,(%eax)
  80269f:	eb 0a                	jmp    8026ab <alloc_block_NF+0xa2>
  8026a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a4:	8b 00                	mov    (%eax),%eax
  8026a6:	a3 38 51 80 00       	mov    %eax,0x805138
  8026ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026be:	a1 44 51 80 00       	mov    0x805144,%eax
  8026c3:	48                   	dec    %eax
  8026c4:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  8026c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cc:	8b 40 08             	mov    0x8(%eax),%eax
  8026cf:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  8026d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d7:	e9 f8 04 00 00       	jmp    802bd4 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8026dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026df:	8b 40 0c             	mov    0xc(%eax),%eax
  8026e2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026e5:	0f 86 d4 00 00 00    	jbe    8027bf <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8026eb:	a1 48 51 80 00       	mov    0x805148,%eax
  8026f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8026f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f6:	8b 50 08             	mov    0x8(%eax),%edx
  8026f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026fc:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8026ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802702:	8b 55 08             	mov    0x8(%ebp),%edx
  802705:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802708:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80270c:	75 17                	jne    802725 <alloc_block_NF+0x11c>
  80270e:	83 ec 04             	sub    $0x4,%esp
  802711:	68 e4 3f 80 00       	push   $0x803fe4
  802716:	68 e9 00 00 00       	push   $0xe9
  80271b:	68 3b 3f 80 00       	push   $0x803f3b
  802720:	e8 52 db ff ff       	call   800277 <_panic>
  802725:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802728:	8b 00                	mov    (%eax),%eax
  80272a:	85 c0                	test   %eax,%eax
  80272c:	74 10                	je     80273e <alloc_block_NF+0x135>
  80272e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802731:	8b 00                	mov    (%eax),%eax
  802733:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802736:	8b 52 04             	mov    0x4(%edx),%edx
  802739:	89 50 04             	mov    %edx,0x4(%eax)
  80273c:	eb 0b                	jmp    802749 <alloc_block_NF+0x140>
  80273e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802741:	8b 40 04             	mov    0x4(%eax),%eax
  802744:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802749:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80274c:	8b 40 04             	mov    0x4(%eax),%eax
  80274f:	85 c0                	test   %eax,%eax
  802751:	74 0f                	je     802762 <alloc_block_NF+0x159>
  802753:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802756:	8b 40 04             	mov    0x4(%eax),%eax
  802759:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80275c:	8b 12                	mov    (%edx),%edx
  80275e:	89 10                	mov    %edx,(%eax)
  802760:	eb 0a                	jmp    80276c <alloc_block_NF+0x163>
  802762:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802765:	8b 00                	mov    (%eax),%eax
  802767:	a3 48 51 80 00       	mov    %eax,0x805148
  80276c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80276f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802775:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802778:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80277f:	a1 54 51 80 00       	mov    0x805154,%eax
  802784:	48                   	dec    %eax
  802785:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  80278a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80278d:	8b 40 08             	mov    0x8(%eax),%eax
  802790:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802795:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802798:	8b 50 08             	mov    0x8(%eax),%edx
  80279b:	8b 45 08             	mov    0x8(%ebp),%eax
  80279e:	01 c2                	add    %eax,%edx
  8027a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a3:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  8027a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8027ac:	2b 45 08             	sub    0x8(%ebp),%eax
  8027af:	89 c2                	mov    %eax,%edx
  8027b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b4:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8027b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ba:	e9 15 04 00 00       	jmp    802bd4 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8027bf:	a1 40 51 80 00       	mov    0x805140,%eax
  8027c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027cb:	74 07                	je     8027d4 <alloc_block_NF+0x1cb>
  8027cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d0:	8b 00                	mov    (%eax),%eax
  8027d2:	eb 05                	jmp    8027d9 <alloc_block_NF+0x1d0>
  8027d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8027d9:	a3 40 51 80 00       	mov    %eax,0x805140
  8027de:	a1 40 51 80 00       	mov    0x805140,%eax
  8027e3:	85 c0                	test   %eax,%eax
  8027e5:	0f 85 3e fe ff ff    	jne    802629 <alloc_block_NF+0x20>
  8027eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027ef:	0f 85 34 fe ff ff    	jne    802629 <alloc_block_NF+0x20>
  8027f5:	e9 d5 03 00 00       	jmp    802bcf <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8027fa:	a1 38 51 80 00       	mov    0x805138,%eax
  8027ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802802:	e9 b1 01 00 00       	jmp    8029b8 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802807:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280a:	8b 50 08             	mov    0x8(%eax),%edx
  80280d:	a1 28 50 80 00       	mov    0x805028,%eax
  802812:	39 c2                	cmp    %eax,%edx
  802814:	0f 82 96 01 00 00    	jb     8029b0 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  80281a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281d:	8b 40 0c             	mov    0xc(%eax),%eax
  802820:	3b 45 08             	cmp    0x8(%ebp),%eax
  802823:	0f 82 87 01 00 00    	jb     8029b0 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802829:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282c:	8b 40 0c             	mov    0xc(%eax),%eax
  80282f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802832:	0f 85 95 00 00 00    	jne    8028cd <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802838:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80283c:	75 17                	jne    802855 <alloc_block_NF+0x24c>
  80283e:	83 ec 04             	sub    $0x4,%esp
  802841:	68 e4 3f 80 00       	push   $0x803fe4
  802846:	68 fc 00 00 00       	push   $0xfc
  80284b:	68 3b 3f 80 00       	push   $0x803f3b
  802850:	e8 22 da ff ff       	call   800277 <_panic>
  802855:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802858:	8b 00                	mov    (%eax),%eax
  80285a:	85 c0                	test   %eax,%eax
  80285c:	74 10                	je     80286e <alloc_block_NF+0x265>
  80285e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802861:	8b 00                	mov    (%eax),%eax
  802863:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802866:	8b 52 04             	mov    0x4(%edx),%edx
  802869:	89 50 04             	mov    %edx,0x4(%eax)
  80286c:	eb 0b                	jmp    802879 <alloc_block_NF+0x270>
  80286e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802871:	8b 40 04             	mov    0x4(%eax),%eax
  802874:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802879:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287c:	8b 40 04             	mov    0x4(%eax),%eax
  80287f:	85 c0                	test   %eax,%eax
  802881:	74 0f                	je     802892 <alloc_block_NF+0x289>
  802883:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802886:	8b 40 04             	mov    0x4(%eax),%eax
  802889:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80288c:	8b 12                	mov    (%edx),%edx
  80288e:	89 10                	mov    %edx,(%eax)
  802890:	eb 0a                	jmp    80289c <alloc_block_NF+0x293>
  802892:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802895:	8b 00                	mov    (%eax),%eax
  802897:	a3 38 51 80 00       	mov    %eax,0x805138
  80289c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028af:	a1 44 51 80 00       	mov    0x805144,%eax
  8028b4:	48                   	dec    %eax
  8028b5:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8028ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bd:	8b 40 08             	mov    0x8(%eax),%eax
  8028c0:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  8028c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c8:	e9 07 03 00 00       	jmp    802bd4 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8028cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8028d3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028d6:	0f 86 d4 00 00 00    	jbe    8029b0 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8028dc:	a1 48 51 80 00       	mov    0x805148,%eax
  8028e1:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  8028e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e7:	8b 50 08             	mov    0x8(%eax),%edx
  8028ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028ed:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8028f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8028f6:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8028f9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8028fd:	75 17                	jne    802916 <alloc_block_NF+0x30d>
  8028ff:	83 ec 04             	sub    $0x4,%esp
  802902:	68 e4 3f 80 00       	push   $0x803fe4
  802907:	68 04 01 00 00       	push   $0x104
  80290c:	68 3b 3f 80 00       	push   $0x803f3b
  802911:	e8 61 d9 ff ff       	call   800277 <_panic>
  802916:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802919:	8b 00                	mov    (%eax),%eax
  80291b:	85 c0                	test   %eax,%eax
  80291d:	74 10                	je     80292f <alloc_block_NF+0x326>
  80291f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802922:	8b 00                	mov    (%eax),%eax
  802924:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802927:	8b 52 04             	mov    0x4(%edx),%edx
  80292a:	89 50 04             	mov    %edx,0x4(%eax)
  80292d:	eb 0b                	jmp    80293a <alloc_block_NF+0x331>
  80292f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802932:	8b 40 04             	mov    0x4(%eax),%eax
  802935:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80293a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80293d:	8b 40 04             	mov    0x4(%eax),%eax
  802940:	85 c0                	test   %eax,%eax
  802942:	74 0f                	je     802953 <alloc_block_NF+0x34a>
  802944:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802947:	8b 40 04             	mov    0x4(%eax),%eax
  80294a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80294d:	8b 12                	mov    (%edx),%edx
  80294f:	89 10                	mov    %edx,(%eax)
  802951:	eb 0a                	jmp    80295d <alloc_block_NF+0x354>
  802953:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802956:	8b 00                	mov    (%eax),%eax
  802958:	a3 48 51 80 00       	mov    %eax,0x805148
  80295d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802960:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802966:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802969:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802970:	a1 54 51 80 00       	mov    0x805154,%eax
  802975:	48                   	dec    %eax
  802976:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  80297b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80297e:	8b 40 08             	mov    0x8(%eax),%eax
  802981:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802986:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802989:	8b 50 08             	mov    0x8(%eax),%edx
  80298c:	8b 45 08             	mov    0x8(%ebp),%eax
  80298f:	01 c2                	add    %eax,%edx
  802991:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802994:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802997:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299a:	8b 40 0c             	mov    0xc(%eax),%eax
  80299d:	2b 45 08             	sub    0x8(%ebp),%eax
  8029a0:	89 c2                	mov    %eax,%edx
  8029a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a5:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8029a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029ab:	e9 24 02 00 00       	jmp    802bd4 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8029b0:	a1 40 51 80 00       	mov    0x805140,%eax
  8029b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029bc:	74 07                	je     8029c5 <alloc_block_NF+0x3bc>
  8029be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c1:	8b 00                	mov    (%eax),%eax
  8029c3:	eb 05                	jmp    8029ca <alloc_block_NF+0x3c1>
  8029c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8029ca:	a3 40 51 80 00       	mov    %eax,0x805140
  8029cf:	a1 40 51 80 00       	mov    0x805140,%eax
  8029d4:	85 c0                	test   %eax,%eax
  8029d6:	0f 85 2b fe ff ff    	jne    802807 <alloc_block_NF+0x1fe>
  8029dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029e0:	0f 85 21 fe ff ff    	jne    802807 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8029e6:	a1 38 51 80 00       	mov    0x805138,%eax
  8029eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029ee:	e9 ae 01 00 00       	jmp    802ba1 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  8029f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f6:	8b 50 08             	mov    0x8(%eax),%edx
  8029f9:	a1 28 50 80 00       	mov    0x805028,%eax
  8029fe:	39 c2                	cmp    %eax,%edx
  802a00:	0f 83 93 01 00 00    	jae    802b99 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802a06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a09:	8b 40 0c             	mov    0xc(%eax),%eax
  802a0c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a0f:	0f 82 84 01 00 00    	jb     802b99 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802a15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a18:	8b 40 0c             	mov    0xc(%eax),%eax
  802a1b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a1e:	0f 85 95 00 00 00    	jne    802ab9 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802a24:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a28:	75 17                	jne    802a41 <alloc_block_NF+0x438>
  802a2a:	83 ec 04             	sub    $0x4,%esp
  802a2d:	68 e4 3f 80 00       	push   $0x803fe4
  802a32:	68 14 01 00 00       	push   $0x114
  802a37:	68 3b 3f 80 00       	push   $0x803f3b
  802a3c:	e8 36 d8 ff ff       	call   800277 <_panic>
  802a41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a44:	8b 00                	mov    (%eax),%eax
  802a46:	85 c0                	test   %eax,%eax
  802a48:	74 10                	je     802a5a <alloc_block_NF+0x451>
  802a4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4d:	8b 00                	mov    (%eax),%eax
  802a4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a52:	8b 52 04             	mov    0x4(%edx),%edx
  802a55:	89 50 04             	mov    %edx,0x4(%eax)
  802a58:	eb 0b                	jmp    802a65 <alloc_block_NF+0x45c>
  802a5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5d:	8b 40 04             	mov    0x4(%eax),%eax
  802a60:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a68:	8b 40 04             	mov    0x4(%eax),%eax
  802a6b:	85 c0                	test   %eax,%eax
  802a6d:	74 0f                	je     802a7e <alloc_block_NF+0x475>
  802a6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a72:	8b 40 04             	mov    0x4(%eax),%eax
  802a75:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a78:	8b 12                	mov    (%edx),%edx
  802a7a:	89 10                	mov    %edx,(%eax)
  802a7c:	eb 0a                	jmp    802a88 <alloc_block_NF+0x47f>
  802a7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a81:	8b 00                	mov    (%eax),%eax
  802a83:	a3 38 51 80 00       	mov    %eax,0x805138
  802a88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a94:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a9b:	a1 44 51 80 00       	mov    0x805144,%eax
  802aa0:	48                   	dec    %eax
  802aa1:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802aa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa9:	8b 40 08             	mov    0x8(%eax),%eax
  802aac:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802ab1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab4:	e9 1b 01 00 00       	jmp    802bd4 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802ab9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abc:	8b 40 0c             	mov    0xc(%eax),%eax
  802abf:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ac2:	0f 86 d1 00 00 00    	jbe    802b99 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802ac8:	a1 48 51 80 00       	mov    0x805148,%eax
  802acd:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802ad0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad3:	8b 50 08             	mov    0x8(%eax),%edx
  802ad6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ad9:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802adc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802adf:	8b 55 08             	mov    0x8(%ebp),%edx
  802ae2:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802ae5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802ae9:	75 17                	jne    802b02 <alloc_block_NF+0x4f9>
  802aeb:	83 ec 04             	sub    $0x4,%esp
  802aee:	68 e4 3f 80 00       	push   $0x803fe4
  802af3:	68 1c 01 00 00       	push   $0x11c
  802af8:	68 3b 3f 80 00       	push   $0x803f3b
  802afd:	e8 75 d7 ff ff       	call   800277 <_panic>
  802b02:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b05:	8b 00                	mov    (%eax),%eax
  802b07:	85 c0                	test   %eax,%eax
  802b09:	74 10                	je     802b1b <alloc_block_NF+0x512>
  802b0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b0e:	8b 00                	mov    (%eax),%eax
  802b10:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b13:	8b 52 04             	mov    0x4(%edx),%edx
  802b16:	89 50 04             	mov    %edx,0x4(%eax)
  802b19:	eb 0b                	jmp    802b26 <alloc_block_NF+0x51d>
  802b1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b1e:	8b 40 04             	mov    0x4(%eax),%eax
  802b21:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b26:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b29:	8b 40 04             	mov    0x4(%eax),%eax
  802b2c:	85 c0                	test   %eax,%eax
  802b2e:	74 0f                	je     802b3f <alloc_block_NF+0x536>
  802b30:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b33:	8b 40 04             	mov    0x4(%eax),%eax
  802b36:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b39:	8b 12                	mov    (%edx),%edx
  802b3b:	89 10                	mov    %edx,(%eax)
  802b3d:	eb 0a                	jmp    802b49 <alloc_block_NF+0x540>
  802b3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b42:	8b 00                	mov    (%eax),%eax
  802b44:	a3 48 51 80 00       	mov    %eax,0x805148
  802b49:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b4c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b52:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b55:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b5c:	a1 54 51 80 00       	mov    0x805154,%eax
  802b61:	48                   	dec    %eax
  802b62:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802b67:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b6a:	8b 40 08             	mov    0x8(%eax),%eax
  802b6d:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802b72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b75:	8b 50 08             	mov    0x8(%eax),%edx
  802b78:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7b:	01 c2                	add    %eax,%edx
  802b7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b80:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802b83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b86:	8b 40 0c             	mov    0xc(%eax),%eax
  802b89:	2b 45 08             	sub    0x8(%ebp),%eax
  802b8c:	89 c2                	mov    %eax,%edx
  802b8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b91:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802b94:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b97:	eb 3b                	jmp    802bd4 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b99:	a1 40 51 80 00       	mov    0x805140,%eax
  802b9e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ba1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ba5:	74 07                	je     802bae <alloc_block_NF+0x5a5>
  802ba7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802baa:	8b 00                	mov    (%eax),%eax
  802bac:	eb 05                	jmp    802bb3 <alloc_block_NF+0x5aa>
  802bae:	b8 00 00 00 00       	mov    $0x0,%eax
  802bb3:	a3 40 51 80 00       	mov    %eax,0x805140
  802bb8:	a1 40 51 80 00       	mov    0x805140,%eax
  802bbd:	85 c0                	test   %eax,%eax
  802bbf:	0f 85 2e fe ff ff    	jne    8029f3 <alloc_block_NF+0x3ea>
  802bc5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bc9:	0f 85 24 fe ff ff    	jne    8029f3 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802bcf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bd4:	c9                   	leave  
  802bd5:	c3                   	ret    

00802bd6 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802bd6:	55                   	push   %ebp
  802bd7:	89 e5                	mov    %esp,%ebp
  802bd9:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802bdc:	a1 38 51 80 00       	mov    0x805138,%eax
  802be1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802be4:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802be9:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802bec:	a1 38 51 80 00       	mov    0x805138,%eax
  802bf1:	85 c0                	test   %eax,%eax
  802bf3:	74 14                	je     802c09 <insert_sorted_with_merge_freeList+0x33>
  802bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf8:	8b 50 08             	mov    0x8(%eax),%edx
  802bfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bfe:	8b 40 08             	mov    0x8(%eax),%eax
  802c01:	39 c2                	cmp    %eax,%edx
  802c03:	0f 87 9b 01 00 00    	ja     802da4 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802c09:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c0d:	75 17                	jne    802c26 <insert_sorted_with_merge_freeList+0x50>
  802c0f:	83 ec 04             	sub    $0x4,%esp
  802c12:	68 18 3f 80 00       	push   $0x803f18
  802c17:	68 38 01 00 00       	push   $0x138
  802c1c:	68 3b 3f 80 00       	push   $0x803f3b
  802c21:	e8 51 d6 ff ff       	call   800277 <_panic>
  802c26:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2f:	89 10                	mov    %edx,(%eax)
  802c31:	8b 45 08             	mov    0x8(%ebp),%eax
  802c34:	8b 00                	mov    (%eax),%eax
  802c36:	85 c0                	test   %eax,%eax
  802c38:	74 0d                	je     802c47 <insert_sorted_with_merge_freeList+0x71>
  802c3a:	a1 38 51 80 00       	mov    0x805138,%eax
  802c3f:	8b 55 08             	mov    0x8(%ebp),%edx
  802c42:	89 50 04             	mov    %edx,0x4(%eax)
  802c45:	eb 08                	jmp    802c4f <insert_sorted_with_merge_freeList+0x79>
  802c47:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c52:	a3 38 51 80 00       	mov    %eax,0x805138
  802c57:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c61:	a1 44 51 80 00       	mov    0x805144,%eax
  802c66:	40                   	inc    %eax
  802c67:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802c6c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c70:	0f 84 a8 06 00 00    	je     80331e <insert_sorted_with_merge_freeList+0x748>
  802c76:	8b 45 08             	mov    0x8(%ebp),%eax
  802c79:	8b 50 08             	mov    0x8(%eax),%edx
  802c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7f:	8b 40 0c             	mov    0xc(%eax),%eax
  802c82:	01 c2                	add    %eax,%edx
  802c84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c87:	8b 40 08             	mov    0x8(%eax),%eax
  802c8a:	39 c2                	cmp    %eax,%edx
  802c8c:	0f 85 8c 06 00 00    	jne    80331e <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802c92:	8b 45 08             	mov    0x8(%ebp),%eax
  802c95:	8b 50 0c             	mov    0xc(%eax),%edx
  802c98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c9b:	8b 40 0c             	mov    0xc(%eax),%eax
  802c9e:	01 c2                	add    %eax,%edx
  802ca0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca3:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802ca6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802caa:	75 17                	jne    802cc3 <insert_sorted_with_merge_freeList+0xed>
  802cac:	83 ec 04             	sub    $0x4,%esp
  802caf:	68 e4 3f 80 00       	push   $0x803fe4
  802cb4:	68 3c 01 00 00       	push   $0x13c
  802cb9:	68 3b 3f 80 00       	push   $0x803f3b
  802cbe:	e8 b4 d5 ff ff       	call   800277 <_panic>
  802cc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cc6:	8b 00                	mov    (%eax),%eax
  802cc8:	85 c0                	test   %eax,%eax
  802cca:	74 10                	je     802cdc <insert_sorted_with_merge_freeList+0x106>
  802ccc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ccf:	8b 00                	mov    (%eax),%eax
  802cd1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cd4:	8b 52 04             	mov    0x4(%edx),%edx
  802cd7:	89 50 04             	mov    %edx,0x4(%eax)
  802cda:	eb 0b                	jmp    802ce7 <insert_sorted_with_merge_freeList+0x111>
  802cdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cdf:	8b 40 04             	mov    0x4(%eax),%eax
  802ce2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ce7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cea:	8b 40 04             	mov    0x4(%eax),%eax
  802ced:	85 c0                	test   %eax,%eax
  802cef:	74 0f                	je     802d00 <insert_sorted_with_merge_freeList+0x12a>
  802cf1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf4:	8b 40 04             	mov    0x4(%eax),%eax
  802cf7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cfa:	8b 12                	mov    (%edx),%edx
  802cfc:	89 10                	mov    %edx,(%eax)
  802cfe:	eb 0a                	jmp    802d0a <insert_sorted_with_merge_freeList+0x134>
  802d00:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d03:	8b 00                	mov    (%eax),%eax
  802d05:	a3 38 51 80 00       	mov    %eax,0x805138
  802d0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d0d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d16:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d1d:	a1 44 51 80 00       	mov    0x805144,%eax
  802d22:	48                   	dec    %eax
  802d23:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802d28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d2b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802d32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d35:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802d3c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d40:	75 17                	jne    802d59 <insert_sorted_with_merge_freeList+0x183>
  802d42:	83 ec 04             	sub    $0x4,%esp
  802d45:	68 18 3f 80 00       	push   $0x803f18
  802d4a:	68 3f 01 00 00       	push   $0x13f
  802d4f:	68 3b 3f 80 00       	push   $0x803f3b
  802d54:	e8 1e d5 ff ff       	call   800277 <_panic>
  802d59:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802d5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d62:	89 10                	mov    %edx,(%eax)
  802d64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d67:	8b 00                	mov    (%eax),%eax
  802d69:	85 c0                	test   %eax,%eax
  802d6b:	74 0d                	je     802d7a <insert_sorted_with_merge_freeList+0x1a4>
  802d6d:	a1 48 51 80 00       	mov    0x805148,%eax
  802d72:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d75:	89 50 04             	mov    %edx,0x4(%eax)
  802d78:	eb 08                	jmp    802d82 <insert_sorted_with_merge_freeList+0x1ac>
  802d7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d7d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d85:	a3 48 51 80 00       	mov    %eax,0x805148
  802d8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d8d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d94:	a1 54 51 80 00       	mov    0x805154,%eax
  802d99:	40                   	inc    %eax
  802d9a:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802d9f:	e9 7a 05 00 00       	jmp    80331e <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802da4:	8b 45 08             	mov    0x8(%ebp),%eax
  802da7:	8b 50 08             	mov    0x8(%eax),%edx
  802daa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dad:	8b 40 08             	mov    0x8(%eax),%eax
  802db0:	39 c2                	cmp    %eax,%edx
  802db2:	0f 82 14 01 00 00    	jb     802ecc <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802db8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dbb:	8b 50 08             	mov    0x8(%eax),%edx
  802dbe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dc1:	8b 40 0c             	mov    0xc(%eax),%eax
  802dc4:	01 c2                	add    %eax,%edx
  802dc6:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc9:	8b 40 08             	mov    0x8(%eax),%eax
  802dcc:	39 c2                	cmp    %eax,%edx
  802dce:	0f 85 90 00 00 00    	jne    802e64 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802dd4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dd7:	8b 50 0c             	mov    0xc(%eax),%edx
  802dda:	8b 45 08             	mov    0x8(%ebp),%eax
  802ddd:	8b 40 0c             	mov    0xc(%eax),%eax
  802de0:	01 c2                	add    %eax,%edx
  802de2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802de5:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802de8:	8b 45 08             	mov    0x8(%ebp),%eax
  802deb:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802df2:	8b 45 08             	mov    0x8(%ebp),%eax
  802df5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802dfc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e00:	75 17                	jne    802e19 <insert_sorted_with_merge_freeList+0x243>
  802e02:	83 ec 04             	sub    $0x4,%esp
  802e05:	68 18 3f 80 00       	push   $0x803f18
  802e0a:	68 49 01 00 00       	push   $0x149
  802e0f:	68 3b 3f 80 00       	push   $0x803f3b
  802e14:	e8 5e d4 ff ff       	call   800277 <_panic>
  802e19:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802e1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e22:	89 10                	mov    %edx,(%eax)
  802e24:	8b 45 08             	mov    0x8(%ebp),%eax
  802e27:	8b 00                	mov    (%eax),%eax
  802e29:	85 c0                	test   %eax,%eax
  802e2b:	74 0d                	je     802e3a <insert_sorted_with_merge_freeList+0x264>
  802e2d:	a1 48 51 80 00       	mov    0x805148,%eax
  802e32:	8b 55 08             	mov    0x8(%ebp),%edx
  802e35:	89 50 04             	mov    %edx,0x4(%eax)
  802e38:	eb 08                	jmp    802e42 <insert_sorted_with_merge_freeList+0x26c>
  802e3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e42:	8b 45 08             	mov    0x8(%ebp),%eax
  802e45:	a3 48 51 80 00       	mov    %eax,0x805148
  802e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e54:	a1 54 51 80 00       	mov    0x805154,%eax
  802e59:	40                   	inc    %eax
  802e5a:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802e5f:	e9 bb 04 00 00       	jmp    80331f <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802e64:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e68:	75 17                	jne    802e81 <insert_sorted_with_merge_freeList+0x2ab>
  802e6a:	83 ec 04             	sub    $0x4,%esp
  802e6d:	68 8c 3f 80 00       	push   $0x803f8c
  802e72:	68 4c 01 00 00       	push   $0x14c
  802e77:	68 3b 3f 80 00       	push   $0x803f3b
  802e7c:	e8 f6 d3 ff ff       	call   800277 <_panic>
  802e81:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802e87:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8a:	89 50 04             	mov    %edx,0x4(%eax)
  802e8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e90:	8b 40 04             	mov    0x4(%eax),%eax
  802e93:	85 c0                	test   %eax,%eax
  802e95:	74 0c                	je     802ea3 <insert_sorted_with_merge_freeList+0x2cd>
  802e97:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802e9c:	8b 55 08             	mov    0x8(%ebp),%edx
  802e9f:	89 10                	mov    %edx,(%eax)
  802ea1:	eb 08                	jmp    802eab <insert_sorted_with_merge_freeList+0x2d5>
  802ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea6:	a3 38 51 80 00       	mov    %eax,0x805138
  802eab:	8b 45 08             	mov    0x8(%ebp),%eax
  802eae:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802eb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ebc:	a1 44 51 80 00       	mov    0x805144,%eax
  802ec1:	40                   	inc    %eax
  802ec2:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802ec7:	e9 53 04 00 00       	jmp    80331f <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802ecc:	a1 38 51 80 00       	mov    0x805138,%eax
  802ed1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ed4:	e9 15 04 00 00       	jmp    8032ee <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802ed9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802edc:	8b 00                	mov    (%eax),%eax
  802ede:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee4:	8b 50 08             	mov    0x8(%eax),%edx
  802ee7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eea:	8b 40 08             	mov    0x8(%eax),%eax
  802eed:	39 c2                	cmp    %eax,%edx
  802eef:	0f 86 f1 03 00 00    	jbe    8032e6 <insert_sorted_with_merge_freeList+0x710>
  802ef5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef8:	8b 50 08             	mov    0x8(%eax),%edx
  802efb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802efe:	8b 40 08             	mov    0x8(%eax),%eax
  802f01:	39 c2                	cmp    %eax,%edx
  802f03:	0f 83 dd 03 00 00    	jae    8032e6 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802f09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0c:	8b 50 08             	mov    0x8(%eax),%edx
  802f0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f12:	8b 40 0c             	mov    0xc(%eax),%eax
  802f15:	01 c2                	add    %eax,%edx
  802f17:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1a:	8b 40 08             	mov    0x8(%eax),%eax
  802f1d:	39 c2                	cmp    %eax,%edx
  802f1f:	0f 85 b9 01 00 00    	jne    8030de <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802f25:	8b 45 08             	mov    0x8(%ebp),%eax
  802f28:	8b 50 08             	mov    0x8(%eax),%edx
  802f2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2e:	8b 40 0c             	mov    0xc(%eax),%eax
  802f31:	01 c2                	add    %eax,%edx
  802f33:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f36:	8b 40 08             	mov    0x8(%eax),%eax
  802f39:	39 c2                	cmp    %eax,%edx
  802f3b:	0f 85 0d 01 00 00    	jne    80304e <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802f41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f44:	8b 50 0c             	mov    0xc(%eax),%edx
  802f47:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f4a:	8b 40 0c             	mov    0xc(%eax),%eax
  802f4d:	01 c2                	add    %eax,%edx
  802f4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f52:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802f55:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f59:	75 17                	jne    802f72 <insert_sorted_with_merge_freeList+0x39c>
  802f5b:	83 ec 04             	sub    $0x4,%esp
  802f5e:	68 e4 3f 80 00       	push   $0x803fe4
  802f63:	68 5c 01 00 00       	push   $0x15c
  802f68:	68 3b 3f 80 00       	push   $0x803f3b
  802f6d:	e8 05 d3 ff ff       	call   800277 <_panic>
  802f72:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f75:	8b 00                	mov    (%eax),%eax
  802f77:	85 c0                	test   %eax,%eax
  802f79:	74 10                	je     802f8b <insert_sorted_with_merge_freeList+0x3b5>
  802f7b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f7e:	8b 00                	mov    (%eax),%eax
  802f80:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f83:	8b 52 04             	mov    0x4(%edx),%edx
  802f86:	89 50 04             	mov    %edx,0x4(%eax)
  802f89:	eb 0b                	jmp    802f96 <insert_sorted_with_merge_freeList+0x3c0>
  802f8b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f8e:	8b 40 04             	mov    0x4(%eax),%eax
  802f91:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f96:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f99:	8b 40 04             	mov    0x4(%eax),%eax
  802f9c:	85 c0                	test   %eax,%eax
  802f9e:	74 0f                	je     802faf <insert_sorted_with_merge_freeList+0x3d9>
  802fa0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fa3:	8b 40 04             	mov    0x4(%eax),%eax
  802fa6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fa9:	8b 12                	mov    (%edx),%edx
  802fab:	89 10                	mov    %edx,(%eax)
  802fad:	eb 0a                	jmp    802fb9 <insert_sorted_with_merge_freeList+0x3e3>
  802faf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fb2:	8b 00                	mov    (%eax),%eax
  802fb4:	a3 38 51 80 00       	mov    %eax,0x805138
  802fb9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fbc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fc2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fc5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fcc:	a1 44 51 80 00       	mov    0x805144,%eax
  802fd1:	48                   	dec    %eax
  802fd2:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  802fd7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fda:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  802fe1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fe4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  802feb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802fef:	75 17                	jne    803008 <insert_sorted_with_merge_freeList+0x432>
  802ff1:	83 ec 04             	sub    $0x4,%esp
  802ff4:	68 18 3f 80 00       	push   $0x803f18
  802ff9:	68 5f 01 00 00       	push   $0x15f
  802ffe:	68 3b 3f 80 00       	push   $0x803f3b
  803003:	e8 6f d2 ff ff       	call   800277 <_panic>
  803008:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80300e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803011:	89 10                	mov    %edx,(%eax)
  803013:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803016:	8b 00                	mov    (%eax),%eax
  803018:	85 c0                	test   %eax,%eax
  80301a:	74 0d                	je     803029 <insert_sorted_with_merge_freeList+0x453>
  80301c:	a1 48 51 80 00       	mov    0x805148,%eax
  803021:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803024:	89 50 04             	mov    %edx,0x4(%eax)
  803027:	eb 08                	jmp    803031 <insert_sorted_with_merge_freeList+0x45b>
  803029:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80302c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803031:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803034:	a3 48 51 80 00       	mov    %eax,0x805148
  803039:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80303c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803043:	a1 54 51 80 00       	mov    0x805154,%eax
  803048:	40                   	inc    %eax
  803049:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  80304e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803051:	8b 50 0c             	mov    0xc(%eax),%edx
  803054:	8b 45 08             	mov    0x8(%ebp),%eax
  803057:	8b 40 0c             	mov    0xc(%eax),%eax
  80305a:	01 c2                	add    %eax,%edx
  80305c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305f:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803062:	8b 45 08             	mov    0x8(%ebp),%eax
  803065:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  80306c:	8b 45 08             	mov    0x8(%ebp),%eax
  80306f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803076:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80307a:	75 17                	jne    803093 <insert_sorted_with_merge_freeList+0x4bd>
  80307c:	83 ec 04             	sub    $0x4,%esp
  80307f:	68 18 3f 80 00       	push   $0x803f18
  803084:	68 64 01 00 00       	push   $0x164
  803089:	68 3b 3f 80 00       	push   $0x803f3b
  80308e:	e8 e4 d1 ff ff       	call   800277 <_panic>
  803093:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803099:	8b 45 08             	mov    0x8(%ebp),%eax
  80309c:	89 10                	mov    %edx,(%eax)
  80309e:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a1:	8b 00                	mov    (%eax),%eax
  8030a3:	85 c0                	test   %eax,%eax
  8030a5:	74 0d                	je     8030b4 <insert_sorted_with_merge_freeList+0x4de>
  8030a7:	a1 48 51 80 00       	mov    0x805148,%eax
  8030ac:	8b 55 08             	mov    0x8(%ebp),%edx
  8030af:	89 50 04             	mov    %edx,0x4(%eax)
  8030b2:	eb 08                	jmp    8030bc <insert_sorted_with_merge_freeList+0x4e6>
  8030b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8030bf:	a3 48 51 80 00       	mov    %eax,0x805148
  8030c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030ce:	a1 54 51 80 00       	mov    0x805154,%eax
  8030d3:	40                   	inc    %eax
  8030d4:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8030d9:	e9 41 02 00 00       	jmp    80331f <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8030de:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e1:	8b 50 08             	mov    0x8(%eax),%edx
  8030e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e7:	8b 40 0c             	mov    0xc(%eax),%eax
  8030ea:	01 c2                	add    %eax,%edx
  8030ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ef:	8b 40 08             	mov    0x8(%eax),%eax
  8030f2:	39 c2                	cmp    %eax,%edx
  8030f4:	0f 85 7c 01 00 00    	jne    803276 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8030fa:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030fe:	74 06                	je     803106 <insert_sorted_with_merge_freeList+0x530>
  803100:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803104:	75 17                	jne    80311d <insert_sorted_with_merge_freeList+0x547>
  803106:	83 ec 04             	sub    $0x4,%esp
  803109:	68 54 3f 80 00       	push   $0x803f54
  80310e:	68 69 01 00 00       	push   $0x169
  803113:	68 3b 3f 80 00       	push   $0x803f3b
  803118:	e8 5a d1 ff ff       	call   800277 <_panic>
  80311d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803120:	8b 50 04             	mov    0x4(%eax),%edx
  803123:	8b 45 08             	mov    0x8(%ebp),%eax
  803126:	89 50 04             	mov    %edx,0x4(%eax)
  803129:	8b 45 08             	mov    0x8(%ebp),%eax
  80312c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80312f:	89 10                	mov    %edx,(%eax)
  803131:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803134:	8b 40 04             	mov    0x4(%eax),%eax
  803137:	85 c0                	test   %eax,%eax
  803139:	74 0d                	je     803148 <insert_sorted_with_merge_freeList+0x572>
  80313b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80313e:	8b 40 04             	mov    0x4(%eax),%eax
  803141:	8b 55 08             	mov    0x8(%ebp),%edx
  803144:	89 10                	mov    %edx,(%eax)
  803146:	eb 08                	jmp    803150 <insert_sorted_with_merge_freeList+0x57a>
  803148:	8b 45 08             	mov    0x8(%ebp),%eax
  80314b:	a3 38 51 80 00       	mov    %eax,0x805138
  803150:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803153:	8b 55 08             	mov    0x8(%ebp),%edx
  803156:	89 50 04             	mov    %edx,0x4(%eax)
  803159:	a1 44 51 80 00       	mov    0x805144,%eax
  80315e:	40                   	inc    %eax
  80315f:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803164:	8b 45 08             	mov    0x8(%ebp),%eax
  803167:	8b 50 0c             	mov    0xc(%eax),%edx
  80316a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80316d:	8b 40 0c             	mov    0xc(%eax),%eax
  803170:	01 c2                	add    %eax,%edx
  803172:	8b 45 08             	mov    0x8(%ebp),%eax
  803175:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803178:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80317c:	75 17                	jne    803195 <insert_sorted_with_merge_freeList+0x5bf>
  80317e:	83 ec 04             	sub    $0x4,%esp
  803181:	68 e4 3f 80 00       	push   $0x803fe4
  803186:	68 6b 01 00 00       	push   $0x16b
  80318b:	68 3b 3f 80 00       	push   $0x803f3b
  803190:	e8 e2 d0 ff ff       	call   800277 <_panic>
  803195:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803198:	8b 00                	mov    (%eax),%eax
  80319a:	85 c0                	test   %eax,%eax
  80319c:	74 10                	je     8031ae <insert_sorted_with_merge_freeList+0x5d8>
  80319e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031a1:	8b 00                	mov    (%eax),%eax
  8031a3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031a6:	8b 52 04             	mov    0x4(%edx),%edx
  8031a9:	89 50 04             	mov    %edx,0x4(%eax)
  8031ac:	eb 0b                	jmp    8031b9 <insert_sorted_with_merge_freeList+0x5e3>
  8031ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031b1:	8b 40 04             	mov    0x4(%eax),%eax
  8031b4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031bc:	8b 40 04             	mov    0x4(%eax),%eax
  8031bf:	85 c0                	test   %eax,%eax
  8031c1:	74 0f                	je     8031d2 <insert_sorted_with_merge_freeList+0x5fc>
  8031c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c6:	8b 40 04             	mov    0x4(%eax),%eax
  8031c9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031cc:	8b 12                	mov    (%edx),%edx
  8031ce:	89 10                	mov    %edx,(%eax)
  8031d0:	eb 0a                	jmp    8031dc <insert_sorted_with_merge_freeList+0x606>
  8031d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d5:	8b 00                	mov    (%eax),%eax
  8031d7:	a3 38 51 80 00       	mov    %eax,0x805138
  8031dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031df:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031ef:	a1 44 51 80 00       	mov    0x805144,%eax
  8031f4:	48                   	dec    %eax
  8031f5:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8031fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031fd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803204:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803207:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80320e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803212:	75 17                	jne    80322b <insert_sorted_with_merge_freeList+0x655>
  803214:	83 ec 04             	sub    $0x4,%esp
  803217:	68 18 3f 80 00       	push   $0x803f18
  80321c:	68 6e 01 00 00       	push   $0x16e
  803221:	68 3b 3f 80 00       	push   $0x803f3b
  803226:	e8 4c d0 ff ff       	call   800277 <_panic>
  80322b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803231:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803234:	89 10                	mov    %edx,(%eax)
  803236:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803239:	8b 00                	mov    (%eax),%eax
  80323b:	85 c0                	test   %eax,%eax
  80323d:	74 0d                	je     80324c <insert_sorted_with_merge_freeList+0x676>
  80323f:	a1 48 51 80 00       	mov    0x805148,%eax
  803244:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803247:	89 50 04             	mov    %edx,0x4(%eax)
  80324a:	eb 08                	jmp    803254 <insert_sorted_with_merge_freeList+0x67e>
  80324c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80324f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803254:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803257:	a3 48 51 80 00       	mov    %eax,0x805148
  80325c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80325f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803266:	a1 54 51 80 00       	mov    0x805154,%eax
  80326b:	40                   	inc    %eax
  80326c:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803271:	e9 a9 00 00 00       	jmp    80331f <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803276:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80327a:	74 06                	je     803282 <insert_sorted_with_merge_freeList+0x6ac>
  80327c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803280:	75 17                	jne    803299 <insert_sorted_with_merge_freeList+0x6c3>
  803282:	83 ec 04             	sub    $0x4,%esp
  803285:	68 b0 3f 80 00       	push   $0x803fb0
  80328a:	68 73 01 00 00       	push   $0x173
  80328f:	68 3b 3f 80 00       	push   $0x803f3b
  803294:	e8 de cf ff ff       	call   800277 <_panic>
  803299:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80329c:	8b 10                	mov    (%eax),%edx
  80329e:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a1:	89 10                	mov    %edx,(%eax)
  8032a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a6:	8b 00                	mov    (%eax),%eax
  8032a8:	85 c0                	test   %eax,%eax
  8032aa:	74 0b                	je     8032b7 <insert_sorted_with_merge_freeList+0x6e1>
  8032ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032af:	8b 00                	mov    (%eax),%eax
  8032b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8032b4:	89 50 04             	mov    %edx,0x4(%eax)
  8032b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8032bd:	89 10                	mov    %edx,(%eax)
  8032bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032c5:	89 50 04             	mov    %edx,0x4(%eax)
  8032c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032cb:	8b 00                	mov    (%eax),%eax
  8032cd:	85 c0                	test   %eax,%eax
  8032cf:	75 08                	jne    8032d9 <insert_sorted_with_merge_freeList+0x703>
  8032d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032d9:	a1 44 51 80 00       	mov    0x805144,%eax
  8032de:	40                   	inc    %eax
  8032df:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  8032e4:	eb 39                	jmp    80331f <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8032e6:	a1 40 51 80 00       	mov    0x805140,%eax
  8032eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032f2:	74 07                	je     8032fb <insert_sorted_with_merge_freeList+0x725>
  8032f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f7:	8b 00                	mov    (%eax),%eax
  8032f9:	eb 05                	jmp    803300 <insert_sorted_with_merge_freeList+0x72a>
  8032fb:	b8 00 00 00 00       	mov    $0x0,%eax
  803300:	a3 40 51 80 00       	mov    %eax,0x805140
  803305:	a1 40 51 80 00       	mov    0x805140,%eax
  80330a:	85 c0                	test   %eax,%eax
  80330c:	0f 85 c7 fb ff ff    	jne    802ed9 <insert_sorted_with_merge_freeList+0x303>
  803312:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803316:	0f 85 bd fb ff ff    	jne    802ed9 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80331c:	eb 01                	jmp    80331f <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80331e:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80331f:	90                   	nop
  803320:	c9                   	leave  
  803321:	c3                   	ret    

00803322 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803322:	55                   	push   %ebp
  803323:	89 e5                	mov    %esp,%ebp
  803325:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803328:	8b 55 08             	mov    0x8(%ebp),%edx
  80332b:	89 d0                	mov    %edx,%eax
  80332d:	c1 e0 02             	shl    $0x2,%eax
  803330:	01 d0                	add    %edx,%eax
  803332:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803339:	01 d0                	add    %edx,%eax
  80333b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803342:	01 d0                	add    %edx,%eax
  803344:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80334b:	01 d0                	add    %edx,%eax
  80334d:	c1 e0 04             	shl    $0x4,%eax
  803350:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803353:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  80335a:	8d 45 e8             	lea    -0x18(%ebp),%eax
  80335d:	83 ec 0c             	sub    $0xc,%esp
  803360:	50                   	push   %eax
  803361:	e8 26 e7 ff ff       	call   801a8c <sys_get_virtual_time>
  803366:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803369:	eb 41                	jmp    8033ac <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  80336b:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80336e:	83 ec 0c             	sub    $0xc,%esp
  803371:	50                   	push   %eax
  803372:	e8 15 e7 ff ff       	call   801a8c <sys_get_virtual_time>
  803377:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  80337a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80337d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803380:	29 c2                	sub    %eax,%edx
  803382:	89 d0                	mov    %edx,%eax
  803384:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803387:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80338a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80338d:	89 d1                	mov    %edx,%ecx
  80338f:	29 c1                	sub    %eax,%ecx
  803391:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803394:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803397:	39 c2                	cmp    %eax,%edx
  803399:	0f 97 c0             	seta   %al
  80339c:	0f b6 c0             	movzbl %al,%eax
  80339f:	29 c1                	sub    %eax,%ecx
  8033a1:	89 c8                	mov    %ecx,%eax
  8033a3:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8033a6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8033a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8033ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033af:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8033b2:	72 b7                	jb     80336b <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8033b4:	90                   	nop
  8033b5:	c9                   	leave  
  8033b6:	c3                   	ret    

008033b7 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8033b7:	55                   	push   %ebp
  8033b8:	89 e5                	mov    %esp,%ebp
  8033ba:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8033bd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8033c4:	eb 03                	jmp    8033c9 <busy_wait+0x12>
  8033c6:	ff 45 fc             	incl   -0x4(%ebp)
  8033c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8033cc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8033cf:	72 f5                	jb     8033c6 <busy_wait+0xf>
	return i;
  8033d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8033d4:	c9                   	leave  
  8033d5:	c3                   	ret    
  8033d6:	66 90                	xchg   %ax,%ax

008033d8 <__udivdi3>:
  8033d8:	55                   	push   %ebp
  8033d9:	57                   	push   %edi
  8033da:	56                   	push   %esi
  8033db:	53                   	push   %ebx
  8033dc:	83 ec 1c             	sub    $0x1c,%esp
  8033df:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8033e3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8033e7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8033eb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8033ef:	89 ca                	mov    %ecx,%edx
  8033f1:	89 f8                	mov    %edi,%eax
  8033f3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8033f7:	85 f6                	test   %esi,%esi
  8033f9:	75 2d                	jne    803428 <__udivdi3+0x50>
  8033fb:	39 cf                	cmp    %ecx,%edi
  8033fd:	77 65                	ja     803464 <__udivdi3+0x8c>
  8033ff:	89 fd                	mov    %edi,%ebp
  803401:	85 ff                	test   %edi,%edi
  803403:	75 0b                	jne    803410 <__udivdi3+0x38>
  803405:	b8 01 00 00 00       	mov    $0x1,%eax
  80340a:	31 d2                	xor    %edx,%edx
  80340c:	f7 f7                	div    %edi
  80340e:	89 c5                	mov    %eax,%ebp
  803410:	31 d2                	xor    %edx,%edx
  803412:	89 c8                	mov    %ecx,%eax
  803414:	f7 f5                	div    %ebp
  803416:	89 c1                	mov    %eax,%ecx
  803418:	89 d8                	mov    %ebx,%eax
  80341a:	f7 f5                	div    %ebp
  80341c:	89 cf                	mov    %ecx,%edi
  80341e:	89 fa                	mov    %edi,%edx
  803420:	83 c4 1c             	add    $0x1c,%esp
  803423:	5b                   	pop    %ebx
  803424:	5e                   	pop    %esi
  803425:	5f                   	pop    %edi
  803426:	5d                   	pop    %ebp
  803427:	c3                   	ret    
  803428:	39 ce                	cmp    %ecx,%esi
  80342a:	77 28                	ja     803454 <__udivdi3+0x7c>
  80342c:	0f bd fe             	bsr    %esi,%edi
  80342f:	83 f7 1f             	xor    $0x1f,%edi
  803432:	75 40                	jne    803474 <__udivdi3+0x9c>
  803434:	39 ce                	cmp    %ecx,%esi
  803436:	72 0a                	jb     803442 <__udivdi3+0x6a>
  803438:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80343c:	0f 87 9e 00 00 00    	ja     8034e0 <__udivdi3+0x108>
  803442:	b8 01 00 00 00       	mov    $0x1,%eax
  803447:	89 fa                	mov    %edi,%edx
  803449:	83 c4 1c             	add    $0x1c,%esp
  80344c:	5b                   	pop    %ebx
  80344d:	5e                   	pop    %esi
  80344e:	5f                   	pop    %edi
  80344f:	5d                   	pop    %ebp
  803450:	c3                   	ret    
  803451:	8d 76 00             	lea    0x0(%esi),%esi
  803454:	31 ff                	xor    %edi,%edi
  803456:	31 c0                	xor    %eax,%eax
  803458:	89 fa                	mov    %edi,%edx
  80345a:	83 c4 1c             	add    $0x1c,%esp
  80345d:	5b                   	pop    %ebx
  80345e:	5e                   	pop    %esi
  80345f:	5f                   	pop    %edi
  803460:	5d                   	pop    %ebp
  803461:	c3                   	ret    
  803462:	66 90                	xchg   %ax,%ax
  803464:	89 d8                	mov    %ebx,%eax
  803466:	f7 f7                	div    %edi
  803468:	31 ff                	xor    %edi,%edi
  80346a:	89 fa                	mov    %edi,%edx
  80346c:	83 c4 1c             	add    $0x1c,%esp
  80346f:	5b                   	pop    %ebx
  803470:	5e                   	pop    %esi
  803471:	5f                   	pop    %edi
  803472:	5d                   	pop    %ebp
  803473:	c3                   	ret    
  803474:	bd 20 00 00 00       	mov    $0x20,%ebp
  803479:	89 eb                	mov    %ebp,%ebx
  80347b:	29 fb                	sub    %edi,%ebx
  80347d:	89 f9                	mov    %edi,%ecx
  80347f:	d3 e6                	shl    %cl,%esi
  803481:	89 c5                	mov    %eax,%ebp
  803483:	88 d9                	mov    %bl,%cl
  803485:	d3 ed                	shr    %cl,%ebp
  803487:	89 e9                	mov    %ebp,%ecx
  803489:	09 f1                	or     %esi,%ecx
  80348b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80348f:	89 f9                	mov    %edi,%ecx
  803491:	d3 e0                	shl    %cl,%eax
  803493:	89 c5                	mov    %eax,%ebp
  803495:	89 d6                	mov    %edx,%esi
  803497:	88 d9                	mov    %bl,%cl
  803499:	d3 ee                	shr    %cl,%esi
  80349b:	89 f9                	mov    %edi,%ecx
  80349d:	d3 e2                	shl    %cl,%edx
  80349f:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034a3:	88 d9                	mov    %bl,%cl
  8034a5:	d3 e8                	shr    %cl,%eax
  8034a7:	09 c2                	or     %eax,%edx
  8034a9:	89 d0                	mov    %edx,%eax
  8034ab:	89 f2                	mov    %esi,%edx
  8034ad:	f7 74 24 0c          	divl   0xc(%esp)
  8034b1:	89 d6                	mov    %edx,%esi
  8034b3:	89 c3                	mov    %eax,%ebx
  8034b5:	f7 e5                	mul    %ebp
  8034b7:	39 d6                	cmp    %edx,%esi
  8034b9:	72 19                	jb     8034d4 <__udivdi3+0xfc>
  8034bb:	74 0b                	je     8034c8 <__udivdi3+0xf0>
  8034bd:	89 d8                	mov    %ebx,%eax
  8034bf:	31 ff                	xor    %edi,%edi
  8034c1:	e9 58 ff ff ff       	jmp    80341e <__udivdi3+0x46>
  8034c6:	66 90                	xchg   %ax,%ax
  8034c8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8034cc:	89 f9                	mov    %edi,%ecx
  8034ce:	d3 e2                	shl    %cl,%edx
  8034d0:	39 c2                	cmp    %eax,%edx
  8034d2:	73 e9                	jae    8034bd <__udivdi3+0xe5>
  8034d4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8034d7:	31 ff                	xor    %edi,%edi
  8034d9:	e9 40 ff ff ff       	jmp    80341e <__udivdi3+0x46>
  8034de:	66 90                	xchg   %ax,%ax
  8034e0:	31 c0                	xor    %eax,%eax
  8034e2:	e9 37 ff ff ff       	jmp    80341e <__udivdi3+0x46>
  8034e7:	90                   	nop

008034e8 <__umoddi3>:
  8034e8:	55                   	push   %ebp
  8034e9:	57                   	push   %edi
  8034ea:	56                   	push   %esi
  8034eb:	53                   	push   %ebx
  8034ec:	83 ec 1c             	sub    $0x1c,%esp
  8034ef:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8034f3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8034f7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8034fb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8034ff:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803503:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803507:	89 f3                	mov    %esi,%ebx
  803509:	89 fa                	mov    %edi,%edx
  80350b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80350f:	89 34 24             	mov    %esi,(%esp)
  803512:	85 c0                	test   %eax,%eax
  803514:	75 1a                	jne    803530 <__umoddi3+0x48>
  803516:	39 f7                	cmp    %esi,%edi
  803518:	0f 86 a2 00 00 00    	jbe    8035c0 <__umoddi3+0xd8>
  80351e:	89 c8                	mov    %ecx,%eax
  803520:	89 f2                	mov    %esi,%edx
  803522:	f7 f7                	div    %edi
  803524:	89 d0                	mov    %edx,%eax
  803526:	31 d2                	xor    %edx,%edx
  803528:	83 c4 1c             	add    $0x1c,%esp
  80352b:	5b                   	pop    %ebx
  80352c:	5e                   	pop    %esi
  80352d:	5f                   	pop    %edi
  80352e:	5d                   	pop    %ebp
  80352f:	c3                   	ret    
  803530:	39 f0                	cmp    %esi,%eax
  803532:	0f 87 ac 00 00 00    	ja     8035e4 <__umoddi3+0xfc>
  803538:	0f bd e8             	bsr    %eax,%ebp
  80353b:	83 f5 1f             	xor    $0x1f,%ebp
  80353e:	0f 84 ac 00 00 00    	je     8035f0 <__umoddi3+0x108>
  803544:	bf 20 00 00 00       	mov    $0x20,%edi
  803549:	29 ef                	sub    %ebp,%edi
  80354b:	89 fe                	mov    %edi,%esi
  80354d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803551:	89 e9                	mov    %ebp,%ecx
  803553:	d3 e0                	shl    %cl,%eax
  803555:	89 d7                	mov    %edx,%edi
  803557:	89 f1                	mov    %esi,%ecx
  803559:	d3 ef                	shr    %cl,%edi
  80355b:	09 c7                	or     %eax,%edi
  80355d:	89 e9                	mov    %ebp,%ecx
  80355f:	d3 e2                	shl    %cl,%edx
  803561:	89 14 24             	mov    %edx,(%esp)
  803564:	89 d8                	mov    %ebx,%eax
  803566:	d3 e0                	shl    %cl,%eax
  803568:	89 c2                	mov    %eax,%edx
  80356a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80356e:	d3 e0                	shl    %cl,%eax
  803570:	89 44 24 04          	mov    %eax,0x4(%esp)
  803574:	8b 44 24 08          	mov    0x8(%esp),%eax
  803578:	89 f1                	mov    %esi,%ecx
  80357a:	d3 e8                	shr    %cl,%eax
  80357c:	09 d0                	or     %edx,%eax
  80357e:	d3 eb                	shr    %cl,%ebx
  803580:	89 da                	mov    %ebx,%edx
  803582:	f7 f7                	div    %edi
  803584:	89 d3                	mov    %edx,%ebx
  803586:	f7 24 24             	mull   (%esp)
  803589:	89 c6                	mov    %eax,%esi
  80358b:	89 d1                	mov    %edx,%ecx
  80358d:	39 d3                	cmp    %edx,%ebx
  80358f:	0f 82 87 00 00 00    	jb     80361c <__umoddi3+0x134>
  803595:	0f 84 91 00 00 00    	je     80362c <__umoddi3+0x144>
  80359b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80359f:	29 f2                	sub    %esi,%edx
  8035a1:	19 cb                	sbb    %ecx,%ebx
  8035a3:	89 d8                	mov    %ebx,%eax
  8035a5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8035a9:	d3 e0                	shl    %cl,%eax
  8035ab:	89 e9                	mov    %ebp,%ecx
  8035ad:	d3 ea                	shr    %cl,%edx
  8035af:	09 d0                	or     %edx,%eax
  8035b1:	89 e9                	mov    %ebp,%ecx
  8035b3:	d3 eb                	shr    %cl,%ebx
  8035b5:	89 da                	mov    %ebx,%edx
  8035b7:	83 c4 1c             	add    $0x1c,%esp
  8035ba:	5b                   	pop    %ebx
  8035bb:	5e                   	pop    %esi
  8035bc:	5f                   	pop    %edi
  8035bd:	5d                   	pop    %ebp
  8035be:	c3                   	ret    
  8035bf:	90                   	nop
  8035c0:	89 fd                	mov    %edi,%ebp
  8035c2:	85 ff                	test   %edi,%edi
  8035c4:	75 0b                	jne    8035d1 <__umoddi3+0xe9>
  8035c6:	b8 01 00 00 00       	mov    $0x1,%eax
  8035cb:	31 d2                	xor    %edx,%edx
  8035cd:	f7 f7                	div    %edi
  8035cf:	89 c5                	mov    %eax,%ebp
  8035d1:	89 f0                	mov    %esi,%eax
  8035d3:	31 d2                	xor    %edx,%edx
  8035d5:	f7 f5                	div    %ebp
  8035d7:	89 c8                	mov    %ecx,%eax
  8035d9:	f7 f5                	div    %ebp
  8035db:	89 d0                	mov    %edx,%eax
  8035dd:	e9 44 ff ff ff       	jmp    803526 <__umoddi3+0x3e>
  8035e2:	66 90                	xchg   %ax,%ax
  8035e4:	89 c8                	mov    %ecx,%eax
  8035e6:	89 f2                	mov    %esi,%edx
  8035e8:	83 c4 1c             	add    $0x1c,%esp
  8035eb:	5b                   	pop    %ebx
  8035ec:	5e                   	pop    %esi
  8035ed:	5f                   	pop    %edi
  8035ee:	5d                   	pop    %ebp
  8035ef:	c3                   	ret    
  8035f0:	3b 04 24             	cmp    (%esp),%eax
  8035f3:	72 06                	jb     8035fb <__umoddi3+0x113>
  8035f5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8035f9:	77 0f                	ja     80360a <__umoddi3+0x122>
  8035fb:	89 f2                	mov    %esi,%edx
  8035fd:	29 f9                	sub    %edi,%ecx
  8035ff:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803603:	89 14 24             	mov    %edx,(%esp)
  803606:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80360a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80360e:	8b 14 24             	mov    (%esp),%edx
  803611:	83 c4 1c             	add    $0x1c,%esp
  803614:	5b                   	pop    %ebx
  803615:	5e                   	pop    %esi
  803616:	5f                   	pop    %edi
  803617:	5d                   	pop    %ebp
  803618:	c3                   	ret    
  803619:	8d 76 00             	lea    0x0(%esi),%esi
  80361c:	2b 04 24             	sub    (%esp),%eax
  80361f:	19 fa                	sbb    %edi,%edx
  803621:	89 d1                	mov    %edx,%ecx
  803623:	89 c6                	mov    %eax,%esi
  803625:	e9 71 ff ff ff       	jmp    80359b <__umoddi3+0xb3>
  80362a:	66 90                	xchg   %ax,%ax
  80362c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803630:	72 ea                	jb     80361c <__umoddi3+0x134>
  803632:	89 d9                	mov    %ebx,%ecx
  803634:	e9 62 ff ff ff       	jmp    80359b <__umoddi3+0xb3>
