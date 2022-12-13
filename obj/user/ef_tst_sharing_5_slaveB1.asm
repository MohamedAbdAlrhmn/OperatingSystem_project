
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
  80008c:	68 80 36 80 00       	push   $0x803680
  800091:	6a 12                	push   $0x12
  800093:	68 9c 36 80 00       	push   $0x80369c
  800098:	e8 da 01 00 00       	call   800277 <_panic>
	}
	uint32 *x;
	x = sget(sys_getparentenvid(),"x");
  80009d:	e8 df 19 00 00       	call   801a81 <sys_getparentenvid>
  8000a2:	83 ec 08             	sub    $0x8,%esp
  8000a5:	68 bc 36 80 00       	push   $0x8036bc
  8000aa:	50                   	push   %eax
  8000ab:	e8 34 15 00 00       	call   8015e4 <sget>
  8000b0:	83 c4 10             	add    $0x10,%esp
  8000b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("Slave B1 env used x (getSharedObject)\n");
  8000b6:	83 ec 0c             	sub    $0xc,%esp
  8000b9:	68 c0 36 80 00       	push   $0x8036c0
  8000be:	e8 68 04 00 00       	call   80052b <cprintf>
  8000c3:	83 c4 10             	add    $0x10,%esp

	cprintf("Slave B1 please be patient ...\n");
  8000c6:	83 ec 0c             	sub    $0xc,%esp
  8000c9:	68 e8 36 80 00       	push   $0x8036e8
  8000ce:	e8 58 04 00 00       	call   80052b <cprintf>
  8000d3:	83 c4 10             	add    $0x10,%esp

	env_sleep(6000);
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	68 70 17 00 00       	push   $0x1770
  8000de:	e8 67 32 00 00       	call   80334a <env_sleep>
  8000e3:	83 c4 10             	add    $0x10,%esp
	int freeFrames = sys_calculate_free_frames() ;
  8000e6:	e8 9d 16 00 00       	call   801788 <sys_calculate_free_frames>
  8000eb:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sfree(x);
  8000ee:	83 ec 0c             	sub    $0xc,%esp
  8000f1:	ff 75 ec             	pushl  -0x14(%ebp)
  8000f4:	e8 2f 15 00 00       	call   801628 <sfree>
  8000f9:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave B1 env removed x\n");
  8000fc:	83 ec 0c             	sub    $0xc,%esp
  8000ff:	68 08 37 80 00       	push   $0x803708
  800104:	e8 22 04 00 00       	call   80052b <cprintf>
  800109:	83 c4 10             	add    $0x10,%esp

	if ((sys_calculate_free_frames() - freeFrames) !=  4) panic("B1 wrong free: frames removed not equal 4 !, correct frames to be removed are 4:\nfrom the env: 1 table and 1 for frame of x\nframes_storage of x: should be cleared now\n");
  80010c:	e8 77 16 00 00       	call   801788 <sys_calculate_free_frames>
  800111:	89 c2                	mov    %eax,%edx
  800113:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800116:	29 c2                	sub    %eax,%edx
  800118:	89 d0                	mov    %edx,%eax
  80011a:	83 f8 04             	cmp    $0x4,%eax
  80011d:	74 14                	je     800133 <_main+0xfb>
  80011f:	83 ec 04             	sub    $0x4,%esp
  800122:	68 20 37 80 00       	push   $0x803720
  800127:	6a 20                	push   $0x20
  800129:	68 9c 36 80 00       	push   $0x80369c
  80012e:	e8 44 01 00 00       	call   800277 <_panic>

	//To indicate that it's completed successfully
	inctst();
  800133:	e8 6e 1a 00 00       	call   801ba6 <inctst>
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
  800141:	e8 22 19 00 00       	call   801a68 <sys_getenvindex>
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
  8001ac:	e8 c4 16 00 00       	call   801875 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001b1:	83 ec 0c             	sub    $0xc,%esp
  8001b4:	68 e0 37 80 00       	push   $0x8037e0
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
  8001dc:	68 08 38 80 00       	push   $0x803808
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
  80020d:	68 30 38 80 00       	push   $0x803830
  800212:	e8 14 03 00 00       	call   80052b <cprintf>
  800217:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80021a:	a1 20 50 80 00       	mov    0x805020,%eax
  80021f:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800225:	83 ec 08             	sub    $0x8,%esp
  800228:	50                   	push   %eax
  800229:	68 88 38 80 00       	push   $0x803888
  80022e:	e8 f8 02 00 00       	call   80052b <cprintf>
  800233:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800236:	83 ec 0c             	sub    $0xc,%esp
  800239:	68 e0 37 80 00       	push   $0x8037e0
  80023e:	e8 e8 02 00 00       	call   80052b <cprintf>
  800243:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800246:	e8 44 16 00 00       	call   80188f <sys_enable_interrupt>

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
  80025e:	e8 d1 17 00 00       	call   801a34 <sys_destroy_env>
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
  80026f:	e8 26 18 00 00       	call   801a9a <sys_exit_env>
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
  800298:	68 9c 38 80 00       	push   $0x80389c
  80029d:	e8 89 02 00 00       	call   80052b <cprintf>
  8002a2:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002a5:	a1 00 50 80 00       	mov    0x805000,%eax
  8002aa:	ff 75 0c             	pushl  0xc(%ebp)
  8002ad:	ff 75 08             	pushl  0x8(%ebp)
  8002b0:	50                   	push   %eax
  8002b1:	68 a1 38 80 00       	push   $0x8038a1
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
  8002d5:	68 bd 38 80 00       	push   $0x8038bd
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
  800301:	68 c0 38 80 00       	push   $0x8038c0
  800306:	6a 26                	push   $0x26
  800308:	68 0c 39 80 00       	push   $0x80390c
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
  8003d3:	68 18 39 80 00       	push   $0x803918
  8003d8:	6a 3a                	push   $0x3a
  8003da:	68 0c 39 80 00       	push   $0x80390c
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
  800443:	68 6c 39 80 00       	push   $0x80396c
  800448:	6a 44                	push   $0x44
  80044a:	68 0c 39 80 00       	push   $0x80390c
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
  80049d:	e8 25 12 00 00       	call   8016c7 <sys_cputs>
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
  800514:	e8 ae 11 00 00       	call   8016c7 <sys_cputs>
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
  80055e:	e8 12 13 00 00       	call   801875 <sys_disable_interrupt>
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
  80057e:	e8 0c 13 00 00       	call   80188f <sys_enable_interrupt>
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
  8005c8:	e8 33 2e 00 00       	call   803400 <__udivdi3>
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
  800618:	e8 f3 2e 00 00       	call   803510 <__umoddi3>
  80061d:	83 c4 10             	add    $0x10,%esp
  800620:	05 d4 3b 80 00       	add    $0x803bd4,%eax
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
  800773:	8b 04 85 f8 3b 80 00 	mov    0x803bf8(,%eax,4),%eax
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
  800854:	8b 34 9d 40 3a 80 00 	mov    0x803a40(,%ebx,4),%esi
  80085b:	85 f6                	test   %esi,%esi
  80085d:	75 19                	jne    800878 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80085f:	53                   	push   %ebx
  800860:	68 e5 3b 80 00       	push   $0x803be5
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
  800879:	68 ee 3b 80 00       	push   $0x803bee
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
  8008a6:	be f1 3b 80 00       	mov    $0x803bf1,%esi
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
  8012cc:	68 50 3d 80 00       	push   $0x803d50
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
  80139c:	e8 6a 04 00 00       	call   80180b <sys_allocate_chunk>
  8013a1:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013a4:	a1 20 51 80 00       	mov    0x805120,%eax
  8013a9:	83 ec 0c             	sub    $0xc,%esp
  8013ac:	50                   	push   %eax
  8013ad:	e8 df 0a 00 00       	call   801e91 <initialize_MemBlocksList>
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
  8013da:	68 75 3d 80 00       	push   $0x803d75
  8013df:	6a 33                	push   $0x33
  8013e1:	68 93 3d 80 00       	push   $0x803d93
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
  801459:	68 a0 3d 80 00       	push   $0x803da0
  80145e:	6a 34                	push   $0x34
  801460:	68 93 3d 80 00       	push   $0x803d93
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
  8014f1:	e8 e3 06 00 00       	call   801bd9 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014f6:	85 c0                	test   %eax,%eax
  8014f8:	74 11                	je     80150b <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  8014fa:	83 ec 0c             	sub    $0xc,%esp
  8014fd:	ff 75 e8             	pushl  -0x18(%ebp)
  801500:	e8 4e 0d 00 00       	call   802253 <alloc_block_FF>
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
  801517:	e8 aa 0a 00 00       	call   801fc6 <insert_sorted_allocList>
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
  801537:	68 c4 3d 80 00       	push   $0x803dc4
  80153c:	6a 6f                	push   $0x6f
  80153e:	68 93 3d 80 00       	push   $0x803d93
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
  80155d:	75 07                	jne    801566 <smalloc+0x1e>
  80155f:	b8 00 00 00 00       	mov    $0x0,%eax
  801564:	eb 7c                	jmp    8015e2 <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801566:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80156d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801570:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801573:	01 d0                	add    %edx,%eax
  801575:	48                   	dec    %eax
  801576:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801579:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80157c:	ba 00 00 00 00       	mov    $0x0,%edx
  801581:	f7 75 f0             	divl   -0x10(%ebp)
  801584:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801587:	29 d0                	sub    %edx,%eax
  801589:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  80158c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801593:	e8 41 06 00 00       	call   801bd9 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801598:	85 c0                	test   %eax,%eax
  80159a:	74 11                	je     8015ad <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  80159c:	83 ec 0c             	sub    $0xc,%esp
  80159f:	ff 75 e8             	pushl  -0x18(%ebp)
  8015a2:	e8 ac 0c 00 00       	call   802253 <alloc_block_FF>
  8015a7:	83 c4 10             	add    $0x10,%esp
  8015aa:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  8015ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8015b1:	74 2a                	je     8015dd <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8015b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015b6:	8b 40 08             	mov    0x8(%eax),%eax
  8015b9:	89 c2                	mov    %eax,%edx
  8015bb:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8015bf:	52                   	push   %edx
  8015c0:	50                   	push   %eax
  8015c1:	ff 75 0c             	pushl  0xc(%ebp)
  8015c4:	ff 75 08             	pushl  0x8(%ebp)
  8015c7:	e8 92 03 00 00       	call   80195e <sys_createSharedObject>
  8015cc:	83 c4 10             	add    $0x10,%esp
  8015cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  8015d2:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  8015d6:	74 05                	je     8015dd <smalloc+0x95>
			return (void*)virtual_address;
  8015d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015db:	eb 05                	jmp    8015e2 <smalloc+0x9a>
	}
	return NULL;
  8015dd:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8015e2:	c9                   	leave  
  8015e3:	c3                   	ret    

008015e4 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8015e4:	55                   	push   %ebp
  8015e5:	89 e5                	mov    %esp,%ebp
  8015e7:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015ea:	e8 c6 fc ff ff       	call   8012b5 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8015ef:	83 ec 04             	sub    $0x4,%esp
  8015f2:	68 e8 3d 80 00       	push   $0x803de8
  8015f7:	68 b0 00 00 00       	push   $0xb0
  8015fc:	68 93 3d 80 00       	push   $0x803d93
  801601:	e8 71 ec ff ff       	call   800277 <_panic>

00801606 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801606:	55                   	push   %ebp
  801607:	89 e5                	mov    %esp,%ebp
  801609:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80160c:	e8 a4 fc ff ff       	call   8012b5 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801611:	83 ec 04             	sub    $0x4,%esp
  801614:	68 0c 3e 80 00       	push   $0x803e0c
  801619:	68 f4 00 00 00       	push   $0xf4
  80161e:	68 93 3d 80 00       	push   $0x803d93
  801623:	e8 4f ec ff ff       	call   800277 <_panic>

00801628 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801628:	55                   	push   %ebp
  801629:	89 e5                	mov    %esp,%ebp
  80162b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80162e:	83 ec 04             	sub    $0x4,%esp
  801631:	68 34 3e 80 00       	push   $0x803e34
  801636:	68 08 01 00 00       	push   $0x108
  80163b:	68 93 3d 80 00       	push   $0x803d93
  801640:	e8 32 ec ff ff       	call   800277 <_panic>

00801645 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801645:	55                   	push   %ebp
  801646:	89 e5                	mov    %esp,%ebp
  801648:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80164b:	83 ec 04             	sub    $0x4,%esp
  80164e:	68 58 3e 80 00       	push   $0x803e58
  801653:	68 13 01 00 00       	push   $0x113
  801658:	68 93 3d 80 00       	push   $0x803d93
  80165d:	e8 15 ec ff ff       	call   800277 <_panic>

00801662 <shrink>:

}
void shrink(uint32 newSize)
{
  801662:	55                   	push   %ebp
  801663:	89 e5                	mov    %esp,%ebp
  801665:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801668:	83 ec 04             	sub    $0x4,%esp
  80166b:	68 58 3e 80 00       	push   $0x803e58
  801670:	68 18 01 00 00       	push   $0x118
  801675:	68 93 3d 80 00       	push   $0x803d93
  80167a:	e8 f8 eb ff ff       	call   800277 <_panic>

0080167f <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80167f:	55                   	push   %ebp
  801680:	89 e5                	mov    %esp,%ebp
  801682:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801685:	83 ec 04             	sub    $0x4,%esp
  801688:	68 58 3e 80 00       	push   $0x803e58
  80168d:	68 1d 01 00 00       	push   $0x11d
  801692:	68 93 3d 80 00       	push   $0x803d93
  801697:	e8 db eb ff ff       	call   800277 <_panic>

0080169c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80169c:	55                   	push   %ebp
  80169d:	89 e5                	mov    %esp,%ebp
  80169f:	57                   	push   %edi
  8016a0:	56                   	push   %esi
  8016a1:	53                   	push   %ebx
  8016a2:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ab:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016ae:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016b1:	8b 7d 18             	mov    0x18(%ebp),%edi
  8016b4:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8016b7:	cd 30                	int    $0x30
  8016b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8016bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8016bf:	83 c4 10             	add    $0x10,%esp
  8016c2:	5b                   	pop    %ebx
  8016c3:	5e                   	pop    %esi
  8016c4:	5f                   	pop    %edi
  8016c5:	5d                   	pop    %ebp
  8016c6:	c3                   	ret    

008016c7 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8016c7:	55                   	push   %ebp
  8016c8:	89 e5                	mov    %esp,%ebp
  8016ca:	83 ec 04             	sub    $0x4,%esp
  8016cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8016d0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8016d3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8016d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016da:	6a 00                	push   $0x0
  8016dc:	6a 00                	push   $0x0
  8016de:	52                   	push   %edx
  8016df:	ff 75 0c             	pushl  0xc(%ebp)
  8016e2:	50                   	push   %eax
  8016e3:	6a 00                	push   $0x0
  8016e5:	e8 b2 ff ff ff       	call   80169c <syscall>
  8016ea:	83 c4 18             	add    $0x18,%esp
}
  8016ed:	90                   	nop
  8016ee:	c9                   	leave  
  8016ef:	c3                   	ret    

008016f0 <sys_cgetc>:

int
sys_cgetc(void)
{
  8016f0:	55                   	push   %ebp
  8016f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8016f3:	6a 00                	push   $0x0
  8016f5:	6a 00                	push   $0x0
  8016f7:	6a 00                	push   $0x0
  8016f9:	6a 00                	push   $0x0
  8016fb:	6a 00                	push   $0x0
  8016fd:	6a 01                	push   $0x1
  8016ff:	e8 98 ff ff ff       	call   80169c <syscall>
  801704:	83 c4 18             	add    $0x18,%esp
}
  801707:	c9                   	leave  
  801708:	c3                   	ret    

00801709 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801709:	55                   	push   %ebp
  80170a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80170c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80170f:	8b 45 08             	mov    0x8(%ebp),%eax
  801712:	6a 00                	push   $0x0
  801714:	6a 00                	push   $0x0
  801716:	6a 00                	push   $0x0
  801718:	52                   	push   %edx
  801719:	50                   	push   %eax
  80171a:	6a 05                	push   $0x5
  80171c:	e8 7b ff ff ff       	call   80169c <syscall>
  801721:	83 c4 18             	add    $0x18,%esp
}
  801724:	c9                   	leave  
  801725:	c3                   	ret    

00801726 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801726:	55                   	push   %ebp
  801727:	89 e5                	mov    %esp,%ebp
  801729:	56                   	push   %esi
  80172a:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80172b:	8b 75 18             	mov    0x18(%ebp),%esi
  80172e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801731:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801734:	8b 55 0c             	mov    0xc(%ebp),%edx
  801737:	8b 45 08             	mov    0x8(%ebp),%eax
  80173a:	56                   	push   %esi
  80173b:	53                   	push   %ebx
  80173c:	51                   	push   %ecx
  80173d:	52                   	push   %edx
  80173e:	50                   	push   %eax
  80173f:	6a 06                	push   $0x6
  801741:	e8 56 ff ff ff       	call   80169c <syscall>
  801746:	83 c4 18             	add    $0x18,%esp
}
  801749:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80174c:	5b                   	pop    %ebx
  80174d:	5e                   	pop    %esi
  80174e:	5d                   	pop    %ebp
  80174f:	c3                   	ret    

00801750 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801750:	55                   	push   %ebp
  801751:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801753:	8b 55 0c             	mov    0xc(%ebp),%edx
  801756:	8b 45 08             	mov    0x8(%ebp),%eax
  801759:	6a 00                	push   $0x0
  80175b:	6a 00                	push   $0x0
  80175d:	6a 00                	push   $0x0
  80175f:	52                   	push   %edx
  801760:	50                   	push   %eax
  801761:	6a 07                	push   $0x7
  801763:	e8 34 ff ff ff       	call   80169c <syscall>
  801768:	83 c4 18             	add    $0x18,%esp
}
  80176b:	c9                   	leave  
  80176c:	c3                   	ret    

0080176d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80176d:	55                   	push   %ebp
  80176e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801770:	6a 00                	push   $0x0
  801772:	6a 00                	push   $0x0
  801774:	6a 00                	push   $0x0
  801776:	ff 75 0c             	pushl  0xc(%ebp)
  801779:	ff 75 08             	pushl  0x8(%ebp)
  80177c:	6a 08                	push   $0x8
  80177e:	e8 19 ff ff ff       	call   80169c <syscall>
  801783:	83 c4 18             	add    $0x18,%esp
}
  801786:	c9                   	leave  
  801787:	c3                   	ret    

00801788 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801788:	55                   	push   %ebp
  801789:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80178b:	6a 00                	push   $0x0
  80178d:	6a 00                	push   $0x0
  80178f:	6a 00                	push   $0x0
  801791:	6a 00                	push   $0x0
  801793:	6a 00                	push   $0x0
  801795:	6a 09                	push   $0x9
  801797:	e8 00 ff ff ff       	call   80169c <syscall>
  80179c:	83 c4 18             	add    $0x18,%esp
}
  80179f:	c9                   	leave  
  8017a0:	c3                   	ret    

008017a1 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8017a1:	55                   	push   %ebp
  8017a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8017a4:	6a 00                	push   $0x0
  8017a6:	6a 00                	push   $0x0
  8017a8:	6a 00                	push   $0x0
  8017aa:	6a 00                	push   $0x0
  8017ac:	6a 00                	push   $0x0
  8017ae:	6a 0a                	push   $0xa
  8017b0:	e8 e7 fe ff ff       	call   80169c <syscall>
  8017b5:	83 c4 18             	add    $0x18,%esp
}
  8017b8:	c9                   	leave  
  8017b9:	c3                   	ret    

008017ba <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8017ba:	55                   	push   %ebp
  8017bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8017bd:	6a 00                	push   $0x0
  8017bf:	6a 00                	push   $0x0
  8017c1:	6a 00                	push   $0x0
  8017c3:	6a 00                	push   $0x0
  8017c5:	6a 00                	push   $0x0
  8017c7:	6a 0b                	push   $0xb
  8017c9:	e8 ce fe ff ff       	call   80169c <syscall>
  8017ce:	83 c4 18             	add    $0x18,%esp
}
  8017d1:	c9                   	leave  
  8017d2:	c3                   	ret    

008017d3 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8017d3:	55                   	push   %ebp
  8017d4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8017d6:	6a 00                	push   $0x0
  8017d8:	6a 00                	push   $0x0
  8017da:	6a 00                	push   $0x0
  8017dc:	ff 75 0c             	pushl  0xc(%ebp)
  8017df:	ff 75 08             	pushl  0x8(%ebp)
  8017e2:	6a 0f                	push   $0xf
  8017e4:	e8 b3 fe ff ff       	call   80169c <syscall>
  8017e9:	83 c4 18             	add    $0x18,%esp
	return;
  8017ec:	90                   	nop
}
  8017ed:	c9                   	leave  
  8017ee:	c3                   	ret    

008017ef <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8017ef:	55                   	push   %ebp
  8017f0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8017f2:	6a 00                	push   $0x0
  8017f4:	6a 00                	push   $0x0
  8017f6:	6a 00                	push   $0x0
  8017f8:	ff 75 0c             	pushl  0xc(%ebp)
  8017fb:	ff 75 08             	pushl  0x8(%ebp)
  8017fe:	6a 10                	push   $0x10
  801800:	e8 97 fe ff ff       	call   80169c <syscall>
  801805:	83 c4 18             	add    $0x18,%esp
	return ;
  801808:	90                   	nop
}
  801809:	c9                   	leave  
  80180a:	c3                   	ret    

0080180b <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80180b:	55                   	push   %ebp
  80180c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80180e:	6a 00                	push   $0x0
  801810:	6a 00                	push   $0x0
  801812:	ff 75 10             	pushl  0x10(%ebp)
  801815:	ff 75 0c             	pushl  0xc(%ebp)
  801818:	ff 75 08             	pushl  0x8(%ebp)
  80181b:	6a 11                	push   $0x11
  80181d:	e8 7a fe ff ff       	call   80169c <syscall>
  801822:	83 c4 18             	add    $0x18,%esp
	return ;
  801825:	90                   	nop
}
  801826:	c9                   	leave  
  801827:	c3                   	ret    

00801828 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801828:	55                   	push   %ebp
  801829:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80182b:	6a 00                	push   $0x0
  80182d:	6a 00                	push   $0x0
  80182f:	6a 00                	push   $0x0
  801831:	6a 00                	push   $0x0
  801833:	6a 00                	push   $0x0
  801835:	6a 0c                	push   $0xc
  801837:	e8 60 fe ff ff       	call   80169c <syscall>
  80183c:	83 c4 18             	add    $0x18,%esp
}
  80183f:	c9                   	leave  
  801840:	c3                   	ret    

00801841 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801841:	55                   	push   %ebp
  801842:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801844:	6a 00                	push   $0x0
  801846:	6a 00                	push   $0x0
  801848:	6a 00                	push   $0x0
  80184a:	6a 00                	push   $0x0
  80184c:	ff 75 08             	pushl  0x8(%ebp)
  80184f:	6a 0d                	push   $0xd
  801851:	e8 46 fe ff ff       	call   80169c <syscall>
  801856:	83 c4 18             	add    $0x18,%esp
}
  801859:	c9                   	leave  
  80185a:	c3                   	ret    

0080185b <sys_scarce_memory>:

void sys_scarce_memory()
{
  80185b:	55                   	push   %ebp
  80185c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80185e:	6a 00                	push   $0x0
  801860:	6a 00                	push   $0x0
  801862:	6a 00                	push   $0x0
  801864:	6a 00                	push   $0x0
  801866:	6a 00                	push   $0x0
  801868:	6a 0e                	push   $0xe
  80186a:	e8 2d fe ff ff       	call   80169c <syscall>
  80186f:	83 c4 18             	add    $0x18,%esp
}
  801872:	90                   	nop
  801873:	c9                   	leave  
  801874:	c3                   	ret    

00801875 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801875:	55                   	push   %ebp
  801876:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801878:	6a 00                	push   $0x0
  80187a:	6a 00                	push   $0x0
  80187c:	6a 00                	push   $0x0
  80187e:	6a 00                	push   $0x0
  801880:	6a 00                	push   $0x0
  801882:	6a 13                	push   $0x13
  801884:	e8 13 fe ff ff       	call   80169c <syscall>
  801889:	83 c4 18             	add    $0x18,%esp
}
  80188c:	90                   	nop
  80188d:	c9                   	leave  
  80188e:	c3                   	ret    

0080188f <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80188f:	55                   	push   %ebp
  801890:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801892:	6a 00                	push   $0x0
  801894:	6a 00                	push   $0x0
  801896:	6a 00                	push   $0x0
  801898:	6a 00                	push   $0x0
  80189a:	6a 00                	push   $0x0
  80189c:	6a 14                	push   $0x14
  80189e:	e8 f9 fd ff ff       	call   80169c <syscall>
  8018a3:	83 c4 18             	add    $0x18,%esp
}
  8018a6:	90                   	nop
  8018a7:	c9                   	leave  
  8018a8:	c3                   	ret    

008018a9 <sys_cputc>:


void
sys_cputc(const char c)
{
  8018a9:	55                   	push   %ebp
  8018aa:	89 e5                	mov    %esp,%ebp
  8018ac:	83 ec 04             	sub    $0x4,%esp
  8018af:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8018b5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8018b9:	6a 00                	push   $0x0
  8018bb:	6a 00                	push   $0x0
  8018bd:	6a 00                	push   $0x0
  8018bf:	6a 00                	push   $0x0
  8018c1:	50                   	push   %eax
  8018c2:	6a 15                	push   $0x15
  8018c4:	e8 d3 fd ff ff       	call   80169c <syscall>
  8018c9:	83 c4 18             	add    $0x18,%esp
}
  8018cc:	90                   	nop
  8018cd:	c9                   	leave  
  8018ce:	c3                   	ret    

008018cf <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8018cf:	55                   	push   %ebp
  8018d0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8018d2:	6a 00                	push   $0x0
  8018d4:	6a 00                	push   $0x0
  8018d6:	6a 00                	push   $0x0
  8018d8:	6a 00                	push   $0x0
  8018da:	6a 00                	push   $0x0
  8018dc:	6a 16                	push   $0x16
  8018de:	e8 b9 fd ff ff       	call   80169c <syscall>
  8018e3:	83 c4 18             	add    $0x18,%esp
}
  8018e6:	90                   	nop
  8018e7:	c9                   	leave  
  8018e8:	c3                   	ret    

008018e9 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8018e9:	55                   	push   %ebp
  8018ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8018ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ef:	6a 00                	push   $0x0
  8018f1:	6a 00                	push   $0x0
  8018f3:	6a 00                	push   $0x0
  8018f5:	ff 75 0c             	pushl  0xc(%ebp)
  8018f8:	50                   	push   %eax
  8018f9:	6a 17                	push   $0x17
  8018fb:	e8 9c fd ff ff       	call   80169c <syscall>
  801900:	83 c4 18             	add    $0x18,%esp
}
  801903:	c9                   	leave  
  801904:	c3                   	ret    

00801905 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801905:	55                   	push   %ebp
  801906:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801908:	8b 55 0c             	mov    0xc(%ebp),%edx
  80190b:	8b 45 08             	mov    0x8(%ebp),%eax
  80190e:	6a 00                	push   $0x0
  801910:	6a 00                	push   $0x0
  801912:	6a 00                	push   $0x0
  801914:	52                   	push   %edx
  801915:	50                   	push   %eax
  801916:	6a 1a                	push   $0x1a
  801918:	e8 7f fd ff ff       	call   80169c <syscall>
  80191d:	83 c4 18             	add    $0x18,%esp
}
  801920:	c9                   	leave  
  801921:	c3                   	ret    

00801922 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801922:	55                   	push   %ebp
  801923:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801925:	8b 55 0c             	mov    0xc(%ebp),%edx
  801928:	8b 45 08             	mov    0x8(%ebp),%eax
  80192b:	6a 00                	push   $0x0
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	52                   	push   %edx
  801932:	50                   	push   %eax
  801933:	6a 18                	push   $0x18
  801935:	e8 62 fd ff ff       	call   80169c <syscall>
  80193a:	83 c4 18             	add    $0x18,%esp
}
  80193d:	90                   	nop
  80193e:	c9                   	leave  
  80193f:	c3                   	ret    

00801940 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801940:	55                   	push   %ebp
  801941:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801943:	8b 55 0c             	mov    0xc(%ebp),%edx
  801946:	8b 45 08             	mov    0x8(%ebp),%eax
  801949:	6a 00                	push   $0x0
  80194b:	6a 00                	push   $0x0
  80194d:	6a 00                	push   $0x0
  80194f:	52                   	push   %edx
  801950:	50                   	push   %eax
  801951:	6a 19                	push   $0x19
  801953:	e8 44 fd ff ff       	call   80169c <syscall>
  801958:	83 c4 18             	add    $0x18,%esp
}
  80195b:	90                   	nop
  80195c:	c9                   	leave  
  80195d:	c3                   	ret    

0080195e <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80195e:	55                   	push   %ebp
  80195f:	89 e5                	mov    %esp,%ebp
  801961:	83 ec 04             	sub    $0x4,%esp
  801964:	8b 45 10             	mov    0x10(%ebp),%eax
  801967:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80196a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80196d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801971:	8b 45 08             	mov    0x8(%ebp),%eax
  801974:	6a 00                	push   $0x0
  801976:	51                   	push   %ecx
  801977:	52                   	push   %edx
  801978:	ff 75 0c             	pushl  0xc(%ebp)
  80197b:	50                   	push   %eax
  80197c:	6a 1b                	push   $0x1b
  80197e:	e8 19 fd ff ff       	call   80169c <syscall>
  801983:	83 c4 18             	add    $0x18,%esp
}
  801986:	c9                   	leave  
  801987:	c3                   	ret    

00801988 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801988:	55                   	push   %ebp
  801989:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80198b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80198e:	8b 45 08             	mov    0x8(%ebp),%eax
  801991:	6a 00                	push   $0x0
  801993:	6a 00                	push   $0x0
  801995:	6a 00                	push   $0x0
  801997:	52                   	push   %edx
  801998:	50                   	push   %eax
  801999:	6a 1c                	push   $0x1c
  80199b:	e8 fc fc ff ff       	call   80169c <syscall>
  8019a0:	83 c4 18             	add    $0x18,%esp
}
  8019a3:	c9                   	leave  
  8019a4:	c3                   	ret    

008019a5 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8019a5:	55                   	push   %ebp
  8019a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8019a8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b1:	6a 00                	push   $0x0
  8019b3:	6a 00                	push   $0x0
  8019b5:	51                   	push   %ecx
  8019b6:	52                   	push   %edx
  8019b7:	50                   	push   %eax
  8019b8:	6a 1d                	push   $0x1d
  8019ba:	e8 dd fc ff ff       	call   80169c <syscall>
  8019bf:	83 c4 18             	add    $0x18,%esp
}
  8019c2:	c9                   	leave  
  8019c3:	c3                   	ret    

008019c4 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8019c4:	55                   	push   %ebp
  8019c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8019c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	52                   	push   %edx
  8019d4:	50                   	push   %eax
  8019d5:	6a 1e                	push   $0x1e
  8019d7:	e8 c0 fc ff ff       	call   80169c <syscall>
  8019dc:	83 c4 18             	add    $0x18,%esp
}
  8019df:	c9                   	leave  
  8019e0:	c3                   	ret    

008019e1 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8019e1:	55                   	push   %ebp
  8019e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 00                	push   $0x0
  8019ec:	6a 00                	push   $0x0
  8019ee:	6a 1f                	push   $0x1f
  8019f0:	e8 a7 fc ff ff       	call   80169c <syscall>
  8019f5:	83 c4 18             	add    $0x18,%esp
}
  8019f8:	c9                   	leave  
  8019f9:	c3                   	ret    

008019fa <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8019fa:	55                   	push   %ebp
  8019fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8019fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801a00:	6a 00                	push   $0x0
  801a02:	ff 75 14             	pushl  0x14(%ebp)
  801a05:	ff 75 10             	pushl  0x10(%ebp)
  801a08:	ff 75 0c             	pushl  0xc(%ebp)
  801a0b:	50                   	push   %eax
  801a0c:	6a 20                	push   $0x20
  801a0e:	e8 89 fc ff ff       	call   80169c <syscall>
  801a13:	83 c4 18             	add    $0x18,%esp
}
  801a16:	c9                   	leave  
  801a17:	c3                   	ret    

00801a18 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801a18:	55                   	push   %ebp
  801a19:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1e:	6a 00                	push   $0x0
  801a20:	6a 00                	push   $0x0
  801a22:	6a 00                	push   $0x0
  801a24:	6a 00                	push   $0x0
  801a26:	50                   	push   %eax
  801a27:	6a 21                	push   $0x21
  801a29:	e8 6e fc ff ff       	call   80169c <syscall>
  801a2e:	83 c4 18             	add    $0x18,%esp
}
  801a31:	90                   	nop
  801a32:	c9                   	leave  
  801a33:	c3                   	ret    

00801a34 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801a34:	55                   	push   %ebp
  801a35:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801a37:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3a:	6a 00                	push   $0x0
  801a3c:	6a 00                	push   $0x0
  801a3e:	6a 00                	push   $0x0
  801a40:	6a 00                	push   $0x0
  801a42:	50                   	push   %eax
  801a43:	6a 22                	push   $0x22
  801a45:	e8 52 fc ff ff       	call   80169c <syscall>
  801a4a:	83 c4 18             	add    $0x18,%esp
}
  801a4d:	c9                   	leave  
  801a4e:	c3                   	ret    

00801a4f <sys_getenvid>:

int32 sys_getenvid(void)
{
  801a4f:	55                   	push   %ebp
  801a50:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801a52:	6a 00                	push   $0x0
  801a54:	6a 00                	push   $0x0
  801a56:	6a 00                	push   $0x0
  801a58:	6a 00                	push   $0x0
  801a5a:	6a 00                	push   $0x0
  801a5c:	6a 02                	push   $0x2
  801a5e:	e8 39 fc ff ff       	call   80169c <syscall>
  801a63:	83 c4 18             	add    $0x18,%esp
}
  801a66:	c9                   	leave  
  801a67:	c3                   	ret    

00801a68 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801a68:	55                   	push   %ebp
  801a69:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801a6b:	6a 00                	push   $0x0
  801a6d:	6a 00                	push   $0x0
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 00                	push   $0x0
  801a73:	6a 00                	push   $0x0
  801a75:	6a 03                	push   $0x3
  801a77:	e8 20 fc ff ff       	call   80169c <syscall>
  801a7c:	83 c4 18             	add    $0x18,%esp
}
  801a7f:	c9                   	leave  
  801a80:	c3                   	ret    

00801a81 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801a81:	55                   	push   %ebp
  801a82:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801a84:	6a 00                	push   $0x0
  801a86:	6a 00                	push   $0x0
  801a88:	6a 00                	push   $0x0
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 04                	push   $0x4
  801a90:	e8 07 fc ff ff       	call   80169c <syscall>
  801a95:	83 c4 18             	add    $0x18,%esp
}
  801a98:	c9                   	leave  
  801a99:	c3                   	ret    

00801a9a <sys_exit_env>:


void sys_exit_env(void)
{
  801a9a:	55                   	push   %ebp
  801a9b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 00                	push   $0x0
  801aa3:	6a 00                	push   $0x0
  801aa5:	6a 00                	push   $0x0
  801aa7:	6a 23                	push   $0x23
  801aa9:	e8 ee fb ff ff       	call   80169c <syscall>
  801aae:	83 c4 18             	add    $0x18,%esp
}
  801ab1:	90                   	nop
  801ab2:	c9                   	leave  
  801ab3:	c3                   	ret    

00801ab4 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801ab4:	55                   	push   %ebp
  801ab5:	89 e5                	mov    %esp,%ebp
  801ab7:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801aba:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801abd:	8d 50 04             	lea    0x4(%eax),%edx
  801ac0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	52                   	push   %edx
  801aca:	50                   	push   %eax
  801acb:	6a 24                	push   $0x24
  801acd:	e8 ca fb ff ff       	call   80169c <syscall>
  801ad2:	83 c4 18             	add    $0x18,%esp
	return result;
  801ad5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ad8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801adb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ade:	89 01                	mov    %eax,(%ecx)
  801ae0:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae6:	c9                   	leave  
  801ae7:	c2 04 00             	ret    $0x4

00801aea <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801aea:	55                   	push   %ebp
  801aeb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801aed:	6a 00                	push   $0x0
  801aef:	6a 00                	push   $0x0
  801af1:	ff 75 10             	pushl  0x10(%ebp)
  801af4:	ff 75 0c             	pushl  0xc(%ebp)
  801af7:	ff 75 08             	pushl  0x8(%ebp)
  801afa:	6a 12                	push   $0x12
  801afc:	e8 9b fb ff ff       	call   80169c <syscall>
  801b01:	83 c4 18             	add    $0x18,%esp
	return ;
  801b04:	90                   	nop
}
  801b05:	c9                   	leave  
  801b06:	c3                   	ret    

00801b07 <sys_rcr2>:
uint32 sys_rcr2()
{
  801b07:	55                   	push   %ebp
  801b08:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b0a:	6a 00                	push   $0x0
  801b0c:	6a 00                	push   $0x0
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 00                	push   $0x0
  801b12:	6a 00                	push   $0x0
  801b14:	6a 25                	push   $0x25
  801b16:	e8 81 fb ff ff       	call   80169c <syscall>
  801b1b:	83 c4 18             	add    $0x18,%esp
}
  801b1e:	c9                   	leave  
  801b1f:	c3                   	ret    

00801b20 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801b20:	55                   	push   %ebp
  801b21:	89 e5                	mov    %esp,%ebp
  801b23:	83 ec 04             	sub    $0x4,%esp
  801b26:	8b 45 08             	mov    0x8(%ebp),%eax
  801b29:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801b2c:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801b30:	6a 00                	push   $0x0
  801b32:	6a 00                	push   $0x0
  801b34:	6a 00                	push   $0x0
  801b36:	6a 00                	push   $0x0
  801b38:	50                   	push   %eax
  801b39:	6a 26                	push   $0x26
  801b3b:	e8 5c fb ff ff       	call   80169c <syscall>
  801b40:	83 c4 18             	add    $0x18,%esp
	return ;
  801b43:	90                   	nop
}
  801b44:	c9                   	leave  
  801b45:	c3                   	ret    

00801b46 <rsttst>:
void rsttst()
{
  801b46:	55                   	push   %ebp
  801b47:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 00                	push   $0x0
  801b4f:	6a 00                	push   $0x0
  801b51:	6a 00                	push   $0x0
  801b53:	6a 28                	push   $0x28
  801b55:	e8 42 fb ff ff       	call   80169c <syscall>
  801b5a:	83 c4 18             	add    $0x18,%esp
	return ;
  801b5d:	90                   	nop
}
  801b5e:	c9                   	leave  
  801b5f:	c3                   	ret    

00801b60 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801b60:	55                   	push   %ebp
  801b61:	89 e5                	mov    %esp,%ebp
  801b63:	83 ec 04             	sub    $0x4,%esp
  801b66:	8b 45 14             	mov    0x14(%ebp),%eax
  801b69:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801b6c:	8b 55 18             	mov    0x18(%ebp),%edx
  801b6f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b73:	52                   	push   %edx
  801b74:	50                   	push   %eax
  801b75:	ff 75 10             	pushl  0x10(%ebp)
  801b78:	ff 75 0c             	pushl  0xc(%ebp)
  801b7b:	ff 75 08             	pushl  0x8(%ebp)
  801b7e:	6a 27                	push   $0x27
  801b80:	e8 17 fb ff ff       	call   80169c <syscall>
  801b85:	83 c4 18             	add    $0x18,%esp
	return ;
  801b88:	90                   	nop
}
  801b89:	c9                   	leave  
  801b8a:	c3                   	ret    

00801b8b <chktst>:
void chktst(uint32 n)
{
  801b8b:	55                   	push   %ebp
  801b8c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801b8e:	6a 00                	push   $0x0
  801b90:	6a 00                	push   $0x0
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	ff 75 08             	pushl  0x8(%ebp)
  801b99:	6a 29                	push   $0x29
  801b9b:	e8 fc fa ff ff       	call   80169c <syscall>
  801ba0:	83 c4 18             	add    $0x18,%esp
	return ;
  801ba3:	90                   	nop
}
  801ba4:	c9                   	leave  
  801ba5:	c3                   	ret    

00801ba6 <inctst>:

void inctst()
{
  801ba6:	55                   	push   %ebp
  801ba7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 00                	push   $0x0
  801bad:	6a 00                	push   $0x0
  801baf:	6a 00                	push   $0x0
  801bb1:	6a 00                	push   $0x0
  801bb3:	6a 2a                	push   $0x2a
  801bb5:	e8 e2 fa ff ff       	call   80169c <syscall>
  801bba:	83 c4 18             	add    $0x18,%esp
	return ;
  801bbd:	90                   	nop
}
  801bbe:	c9                   	leave  
  801bbf:	c3                   	ret    

00801bc0 <gettst>:
uint32 gettst()
{
  801bc0:	55                   	push   %ebp
  801bc1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 00                	push   $0x0
  801bcb:	6a 00                	push   $0x0
  801bcd:	6a 2b                	push   $0x2b
  801bcf:	e8 c8 fa ff ff       	call   80169c <syscall>
  801bd4:	83 c4 18             	add    $0x18,%esp
}
  801bd7:	c9                   	leave  
  801bd8:	c3                   	ret    

00801bd9 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801bd9:	55                   	push   %ebp
  801bda:	89 e5                	mov    %esp,%ebp
  801bdc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 00                	push   $0x0
  801be3:	6a 00                	push   $0x0
  801be5:	6a 00                	push   $0x0
  801be7:	6a 00                	push   $0x0
  801be9:	6a 2c                	push   $0x2c
  801beb:	e8 ac fa ff ff       	call   80169c <syscall>
  801bf0:	83 c4 18             	add    $0x18,%esp
  801bf3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801bf6:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801bfa:	75 07                	jne    801c03 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801bfc:	b8 01 00 00 00       	mov    $0x1,%eax
  801c01:	eb 05                	jmp    801c08 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801c03:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c08:	c9                   	leave  
  801c09:	c3                   	ret    

00801c0a <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801c0a:	55                   	push   %ebp
  801c0b:	89 e5                	mov    %esp,%ebp
  801c0d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c10:	6a 00                	push   $0x0
  801c12:	6a 00                	push   $0x0
  801c14:	6a 00                	push   $0x0
  801c16:	6a 00                	push   $0x0
  801c18:	6a 00                	push   $0x0
  801c1a:	6a 2c                	push   $0x2c
  801c1c:	e8 7b fa ff ff       	call   80169c <syscall>
  801c21:	83 c4 18             	add    $0x18,%esp
  801c24:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801c27:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801c2b:	75 07                	jne    801c34 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801c2d:	b8 01 00 00 00       	mov    $0x1,%eax
  801c32:	eb 05                	jmp    801c39 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801c34:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c39:	c9                   	leave  
  801c3a:	c3                   	ret    

00801c3b <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801c3b:	55                   	push   %ebp
  801c3c:	89 e5                	mov    %esp,%ebp
  801c3e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c41:	6a 00                	push   $0x0
  801c43:	6a 00                	push   $0x0
  801c45:	6a 00                	push   $0x0
  801c47:	6a 00                	push   $0x0
  801c49:	6a 00                	push   $0x0
  801c4b:	6a 2c                	push   $0x2c
  801c4d:	e8 4a fa ff ff       	call   80169c <syscall>
  801c52:	83 c4 18             	add    $0x18,%esp
  801c55:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801c58:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801c5c:	75 07                	jne    801c65 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801c5e:	b8 01 00 00 00       	mov    $0x1,%eax
  801c63:	eb 05                	jmp    801c6a <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801c65:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c6a:	c9                   	leave  
  801c6b:	c3                   	ret    

00801c6c <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801c6c:	55                   	push   %ebp
  801c6d:	89 e5                	mov    %esp,%ebp
  801c6f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c72:	6a 00                	push   $0x0
  801c74:	6a 00                	push   $0x0
  801c76:	6a 00                	push   $0x0
  801c78:	6a 00                	push   $0x0
  801c7a:	6a 00                	push   $0x0
  801c7c:	6a 2c                	push   $0x2c
  801c7e:	e8 19 fa ff ff       	call   80169c <syscall>
  801c83:	83 c4 18             	add    $0x18,%esp
  801c86:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801c89:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801c8d:	75 07                	jne    801c96 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801c8f:	b8 01 00 00 00       	mov    $0x1,%eax
  801c94:	eb 05                	jmp    801c9b <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801c96:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c9b:	c9                   	leave  
  801c9c:	c3                   	ret    

00801c9d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c9d:	55                   	push   %ebp
  801c9e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 00                	push   $0x0
  801ca8:	ff 75 08             	pushl  0x8(%ebp)
  801cab:	6a 2d                	push   $0x2d
  801cad:	e8 ea f9 ff ff       	call   80169c <syscall>
  801cb2:	83 c4 18             	add    $0x18,%esp
	return ;
  801cb5:	90                   	nop
}
  801cb6:	c9                   	leave  
  801cb7:	c3                   	ret    

00801cb8 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801cb8:	55                   	push   %ebp
  801cb9:	89 e5                	mov    %esp,%ebp
  801cbb:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801cbc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cbf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cc2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc8:	6a 00                	push   $0x0
  801cca:	53                   	push   %ebx
  801ccb:	51                   	push   %ecx
  801ccc:	52                   	push   %edx
  801ccd:	50                   	push   %eax
  801cce:	6a 2e                	push   $0x2e
  801cd0:	e8 c7 f9 ff ff       	call   80169c <syscall>
  801cd5:	83 c4 18             	add    $0x18,%esp
}
  801cd8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cdb:	c9                   	leave  
  801cdc:	c3                   	ret    

00801cdd <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801cdd:	55                   	push   %ebp
  801cde:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ce0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce6:	6a 00                	push   $0x0
  801ce8:	6a 00                	push   $0x0
  801cea:	6a 00                	push   $0x0
  801cec:	52                   	push   %edx
  801ced:	50                   	push   %eax
  801cee:	6a 2f                	push   $0x2f
  801cf0:	e8 a7 f9 ff ff       	call   80169c <syscall>
  801cf5:	83 c4 18             	add    $0x18,%esp
}
  801cf8:	c9                   	leave  
  801cf9:	c3                   	ret    

00801cfa <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801cfa:	55                   	push   %ebp
  801cfb:	89 e5                	mov    %esp,%ebp
  801cfd:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801d00:	83 ec 0c             	sub    $0xc,%esp
  801d03:	68 68 3e 80 00       	push   $0x803e68
  801d08:	e8 1e e8 ff ff       	call   80052b <cprintf>
  801d0d:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801d10:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801d17:	83 ec 0c             	sub    $0xc,%esp
  801d1a:	68 94 3e 80 00       	push   $0x803e94
  801d1f:	e8 07 e8 ff ff       	call   80052b <cprintf>
  801d24:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801d27:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d2b:	a1 38 51 80 00       	mov    0x805138,%eax
  801d30:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d33:	eb 56                	jmp    801d8b <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801d35:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d39:	74 1c                	je     801d57 <print_mem_block_lists+0x5d>
  801d3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d3e:	8b 50 08             	mov    0x8(%eax),%edx
  801d41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d44:	8b 48 08             	mov    0x8(%eax),%ecx
  801d47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d4a:	8b 40 0c             	mov    0xc(%eax),%eax
  801d4d:	01 c8                	add    %ecx,%eax
  801d4f:	39 c2                	cmp    %eax,%edx
  801d51:	73 04                	jae    801d57 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801d53:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801d57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d5a:	8b 50 08             	mov    0x8(%eax),%edx
  801d5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d60:	8b 40 0c             	mov    0xc(%eax),%eax
  801d63:	01 c2                	add    %eax,%edx
  801d65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d68:	8b 40 08             	mov    0x8(%eax),%eax
  801d6b:	83 ec 04             	sub    $0x4,%esp
  801d6e:	52                   	push   %edx
  801d6f:	50                   	push   %eax
  801d70:	68 a9 3e 80 00       	push   $0x803ea9
  801d75:	e8 b1 e7 ff ff       	call   80052b <cprintf>
  801d7a:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801d7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d80:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d83:	a1 40 51 80 00       	mov    0x805140,%eax
  801d88:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d8b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d8f:	74 07                	je     801d98 <print_mem_block_lists+0x9e>
  801d91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d94:	8b 00                	mov    (%eax),%eax
  801d96:	eb 05                	jmp    801d9d <print_mem_block_lists+0xa3>
  801d98:	b8 00 00 00 00       	mov    $0x0,%eax
  801d9d:	a3 40 51 80 00       	mov    %eax,0x805140
  801da2:	a1 40 51 80 00       	mov    0x805140,%eax
  801da7:	85 c0                	test   %eax,%eax
  801da9:	75 8a                	jne    801d35 <print_mem_block_lists+0x3b>
  801dab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801daf:	75 84                	jne    801d35 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801db1:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801db5:	75 10                	jne    801dc7 <print_mem_block_lists+0xcd>
  801db7:	83 ec 0c             	sub    $0xc,%esp
  801dba:	68 b8 3e 80 00       	push   $0x803eb8
  801dbf:	e8 67 e7 ff ff       	call   80052b <cprintf>
  801dc4:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801dc7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801dce:	83 ec 0c             	sub    $0xc,%esp
  801dd1:	68 dc 3e 80 00       	push   $0x803edc
  801dd6:	e8 50 e7 ff ff       	call   80052b <cprintf>
  801ddb:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801dde:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801de2:	a1 40 50 80 00       	mov    0x805040,%eax
  801de7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dea:	eb 56                	jmp    801e42 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801dec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801df0:	74 1c                	je     801e0e <print_mem_block_lists+0x114>
  801df2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df5:	8b 50 08             	mov    0x8(%eax),%edx
  801df8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dfb:	8b 48 08             	mov    0x8(%eax),%ecx
  801dfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e01:	8b 40 0c             	mov    0xc(%eax),%eax
  801e04:	01 c8                	add    %ecx,%eax
  801e06:	39 c2                	cmp    %eax,%edx
  801e08:	73 04                	jae    801e0e <print_mem_block_lists+0x114>
			sorted = 0 ;
  801e0a:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e11:	8b 50 08             	mov    0x8(%eax),%edx
  801e14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e17:	8b 40 0c             	mov    0xc(%eax),%eax
  801e1a:	01 c2                	add    %eax,%edx
  801e1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e1f:	8b 40 08             	mov    0x8(%eax),%eax
  801e22:	83 ec 04             	sub    $0x4,%esp
  801e25:	52                   	push   %edx
  801e26:	50                   	push   %eax
  801e27:	68 a9 3e 80 00       	push   $0x803ea9
  801e2c:	e8 fa e6 ff ff       	call   80052b <cprintf>
  801e31:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e37:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801e3a:	a1 48 50 80 00       	mov    0x805048,%eax
  801e3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e42:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e46:	74 07                	je     801e4f <print_mem_block_lists+0x155>
  801e48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e4b:	8b 00                	mov    (%eax),%eax
  801e4d:	eb 05                	jmp    801e54 <print_mem_block_lists+0x15a>
  801e4f:	b8 00 00 00 00       	mov    $0x0,%eax
  801e54:	a3 48 50 80 00       	mov    %eax,0x805048
  801e59:	a1 48 50 80 00       	mov    0x805048,%eax
  801e5e:	85 c0                	test   %eax,%eax
  801e60:	75 8a                	jne    801dec <print_mem_block_lists+0xf2>
  801e62:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e66:	75 84                	jne    801dec <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801e68:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e6c:	75 10                	jne    801e7e <print_mem_block_lists+0x184>
  801e6e:	83 ec 0c             	sub    $0xc,%esp
  801e71:	68 f4 3e 80 00       	push   $0x803ef4
  801e76:	e8 b0 e6 ff ff       	call   80052b <cprintf>
  801e7b:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801e7e:	83 ec 0c             	sub    $0xc,%esp
  801e81:	68 68 3e 80 00       	push   $0x803e68
  801e86:	e8 a0 e6 ff ff       	call   80052b <cprintf>
  801e8b:	83 c4 10             	add    $0x10,%esp

}
  801e8e:	90                   	nop
  801e8f:	c9                   	leave  
  801e90:	c3                   	ret    

00801e91 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801e91:	55                   	push   %ebp
  801e92:	89 e5                	mov    %esp,%ebp
  801e94:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801e97:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  801e9e:	00 00 00 
  801ea1:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  801ea8:	00 00 00 
  801eab:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  801eb2:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801eb5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801ebc:	e9 9e 00 00 00       	jmp    801f5f <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801ec1:	a1 50 50 80 00       	mov    0x805050,%eax
  801ec6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ec9:	c1 e2 04             	shl    $0x4,%edx
  801ecc:	01 d0                	add    %edx,%eax
  801ece:	85 c0                	test   %eax,%eax
  801ed0:	75 14                	jne    801ee6 <initialize_MemBlocksList+0x55>
  801ed2:	83 ec 04             	sub    $0x4,%esp
  801ed5:	68 1c 3f 80 00       	push   $0x803f1c
  801eda:	6a 46                	push   $0x46
  801edc:	68 3f 3f 80 00       	push   $0x803f3f
  801ee1:	e8 91 e3 ff ff       	call   800277 <_panic>
  801ee6:	a1 50 50 80 00       	mov    0x805050,%eax
  801eeb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801eee:	c1 e2 04             	shl    $0x4,%edx
  801ef1:	01 d0                	add    %edx,%eax
  801ef3:	8b 15 48 51 80 00    	mov    0x805148,%edx
  801ef9:	89 10                	mov    %edx,(%eax)
  801efb:	8b 00                	mov    (%eax),%eax
  801efd:	85 c0                	test   %eax,%eax
  801eff:	74 18                	je     801f19 <initialize_MemBlocksList+0x88>
  801f01:	a1 48 51 80 00       	mov    0x805148,%eax
  801f06:	8b 15 50 50 80 00    	mov    0x805050,%edx
  801f0c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801f0f:	c1 e1 04             	shl    $0x4,%ecx
  801f12:	01 ca                	add    %ecx,%edx
  801f14:	89 50 04             	mov    %edx,0x4(%eax)
  801f17:	eb 12                	jmp    801f2b <initialize_MemBlocksList+0x9a>
  801f19:	a1 50 50 80 00       	mov    0x805050,%eax
  801f1e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f21:	c1 e2 04             	shl    $0x4,%edx
  801f24:	01 d0                	add    %edx,%eax
  801f26:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801f2b:	a1 50 50 80 00       	mov    0x805050,%eax
  801f30:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f33:	c1 e2 04             	shl    $0x4,%edx
  801f36:	01 d0                	add    %edx,%eax
  801f38:	a3 48 51 80 00       	mov    %eax,0x805148
  801f3d:	a1 50 50 80 00       	mov    0x805050,%eax
  801f42:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f45:	c1 e2 04             	shl    $0x4,%edx
  801f48:	01 d0                	add    %edx,%eax
  801f4a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f51:	a1 54 51 80 00       	mov    0x805154,%eax
  801f56:	40                   	inc    %eax
  801f57:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801f5c:	ff 45 f4             	incl   -0xc(%ebp)
  801f5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f62:	3b 45 08             	cmp    0x8(%ebp),%eax
  801f65:	0f 82 56 ff ff ff    	jb     801ec1 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801f6b:	90                   	nop
  801f6c:	c9                   	leave  
  801f6d:	c3                   	ret    

00801f6e <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801f6e:	55                   	push   %ebp
  801f6f:	89 e5                	mov    %esp,%ebp
  801f71:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801f74:	8b 45 08             	mov    0x8(%ebp),%eax
  801f77:	8b 00                	mov    (%eax),%eax
  801f79:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f7c:	eb 19                	jmp    801f97 <find_block+0x29>
	{
		if(va==point->sva)
  801f7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f81:	8b 40 08             	mov    0x8(%eax),%eax
  801f84:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801f87:	75 05                	jne    801f8e <find_block+0x20>
		   return point;
  801f89:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f8c:	eb 36                	jmp    801fc4 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801f8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f91:	8b 40 08             	mov    0x8(%eax),%eax
  801f94:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f97:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f9b:	74 07                	je     801fa4 <find_block+0x36>
  801f9d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fa0:	8b 00                	mov    (%eax),%eax
  801fa2:	eb 05                	jmp    801fa9 <find_block+0x3b>
  801fa4:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa9:	8b 55 08             	mov    0x8(%ebp),%edx
  801fac:	89 42 08             	mov    %eax,0x8(%edx)
  801faf:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb2:	8b 40 08             	mov    0x8(%eax),%eax
  801fb5:	85 c0                	test   %eax,%eax
  801fb7:	75 c5                	jne    801f7e <find_block+0x10>
  801fb9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801fbd:	75 bf                	jne    801f7e <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  801fbf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fc4:	c9                   	leave  
  801fc5:	c3                   	ret    

00801fc6 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  801fc6:	55                   	push   %ebp
  801fc7:	89 e5                	mov    %esp,%ebp
  801fc9:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  801fcc:	a1 40 50 80 00       	mov    0x805040,%eax
  801fd1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  801fd4:	a1 44 50 80 00       	mov    0x805044,%eax
  801fd9:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  801fdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fdf:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801fe2:	74 24                	je     802008 <insert_sorted_allocList+0x42>
  801fe4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe7:	8b 50 08             	mov    0x8(%eax),%edx
  801fea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fed:	8b 40 08             	mov    0x8(%eax),%eax
  801ff0:	39 c2                	cmp    %eax,%edx
  801ff2:	76 14                	jbe    802008 <insert_sorted_allocList+0x42>
  801ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff7:	8b 50 08             	mov    0x8(%eax),%edx
  801ffa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ffd:	8b 40 08             	mov    0x8(%eax),%eax
  802000:	39 c2                	cmp    %eax,%edx
  802002:	0f 82 60 01 00 00    	jb     802168 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802008:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80200c:	75 65                	jne    802073 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  80200e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802012:	75 14                	jne    802028 <insert_sorted_allocList+0x62>
  802014:	83 ec 04             	sub    $0x4,%esp
  802017:	68 1c 3f 80 00       	push   $0x803f1c
  80201c:	6a 6b                	push   $0x6b
  80201e:	68 3f 3f 80 00       	push   $0x803f3f
  802023:	e8 4f e2 ff ff       	call   800277 <_panic>
  802028:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80202e:	8b 45 08             	mov    0x8(%ebp),%eax
  802031:	89 10                	mov    %edx,(%eax)
  802033:	8b 45 08             	mov    0x8(%ebp),%eax
  802036:	8b 00                	mov    (%eax),%eax
  802038:	85 c0                	test   %eax,%eax
  80203a:	74 0d                	je     802049 <insert_sorted_allocList+0x83>
  80203c:	a1 40 50 80 00       	mov    0x805040,%eax
  802041:	8b 55 08             	mov    0x8(%ebp),%edx
  802044:	89 50 04             	mov    %edx,0x4(%eax)
  802047:	eb 08                	jmp    802051 <insert_sorted_allocList+0x8b>
  802049:	8b 45 08             	mov    0x8(%ebp),%eax
  80204c:	a3 44 50 80 00       	mov    %eax,0x805044
  802051:	8b 45 08             	mov    0x8(%ebp),%eax
  802054:	a3 40 50 80 00       	mov    %eax,0x805040
  802059:	8b 45 08             	mov    0x8(%ebp),%eax
  80205c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802063:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802068:	40                   	inc    %eax
  802069:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80206e:	e9 dc 01 00 00       	jmp    80224f <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802073:	8b 45 08             	mov    0x8(%ebp),%eax
  802076:	8b 50 08             	mov    0x8(%eax),%edx
  802079:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80207c:	8b 40 08             	mov    0x8(%eax),%eax
  80207f:	39 c2                	cmp    %eax,%edx
  802081:	77 6c                	ja     8020ef <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802083:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802087:	74 06                	je     80208f <insert_sorted_allocList+0xc9>
  802089:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80208d:	75 14                	jne    8020a3 <insert_sorted_allocList+0xdd>
  80208f:	83 ec 04             	sub    $0x4,%esp
  802092:	68 58 3f 80 00       	push   $0x803f58
  802097:	6a 6f                	push   $0x6f
  802099:	68 3f 3f 80 00       	push   $0x803f3f
  80209e:	e8 d4 e1 ff ff       	call   800277 <_panic>
  8020a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020a6:	8b 50 04             	mov    0x4(%eax),%edx
  8020a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ac:	89 50 04             	mov    %edx,0x4(%eax)
  8020af:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8020b5:	89 10                	mov    %edx,(%eax)
  8020b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020ba:	8b 40 04             	mov    0x4(%eax),%eax
  8020bd:	85 c0                	test   %eax,%eax
  8020bf:	74 0d                	je     8020ce <insert_sorted_allocList+0x108>
  8020c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020c4:	8b 40 04             	mov    0x4(%eax),%eax
  8020c7:	8b 55 08             	mov    0x8(%ebp),%edx
  8020ca:	89 10                	mov    %edx,(%eax)
  8020cc:	eb 08                	jmp    8020d6 <insert_sorted_allocList+0x110>
  8020ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d1:	a3 40 50 80 00       	mov    %eax,0x805040
  8020d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8020dc:	89 50 04             	mov    %edx,0x4(%eax)
  8020df:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8020e4:	40                   	inc    %eax
  8020e5:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8020ea:	e9 60 01 00 00       	jmp    80224f <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8020ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f2:	8b 50 08             	mov    0x8(%eax),%edx
  8020f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020f8:	8b 40 08             	mov    0x8(%eax),%eax
  8020fb:	39 c2                	cmp    %eax,%edx
  8020fd:	0f 82 4c 01 00 00    	jb     80224f <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802103:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802107:	75 14                	jne    80211d <insert_sorted_allocList+0x157>
  802109:	83 ec 04             	sub    $0x4,%esp
  80210c:	68 90 3f 80 00       	push   $0x803f90
  802111:	6a 73                	push   $0x73
  802113:	68 3f 3f 80 00       	push   $0x803f3f
  802118:	e8 5a e1 ff ff       	call   800277 <_panic>
  80211d:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802123:	8b 45 08             	mov    0x8(%ebp),%eax
  802126:	89 50 04             	mov    %edx,0x4(%eax)
  802129:	8b 45 08             	mov    0x8(%ebp),%eax
  80212c:	8b 40 04             	mov    0x4(%eax),%eax
  80212f:	85 c0                	test   %eax,%eax
  802131:	74 0c                	je     80213f <insert_sorted_allocList+0x179>
  802133:	a1 44 50 80 00       	mov    0x805044,%eax
  802138:	8b 55 08             	mov    0x8(%ebp),%edx
  80213b:	89 10                	mov    %edx,(%eax)
  80213d:	eb 08                	jmp    802147 <insert_sorted_allocList+0x181>
  80213f:	8b 45 08             	mov    0x8(%ebp),%eax
  802142:	a3 40 50 80 00       	mov    %eax,0x805040
  802147:	8b 45 08             	mov    0x8(%ebp),%eax
  80214a:	a3 44 50 80 00       	mov    %eax,0x805044
  80214f:	8b 45 08             	mov    0x8(%ebp),%eax
  802152:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802158:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80215d:	40                   	inc    %eax
  80215e:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802163:	e9 e7 00 00 00       	jmp    80224f <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802168:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80216b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  80216e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802175:	a1 40 50 80 00       	mov    0x805040,%eax
  80217a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80217d:	e9 9d 00 00 00       	jmp    80221f <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802182:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802185:	8b 00                	mov    (%eax),%eax
  802187:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  80218a:	8b 45 08             	mov    0x8(%ebp),%eax
  80218d:	8b 50 08             	mov    0x8(%eax),%edx
  802190:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802193:	8b 40 08             	mov    0x8(%eax),%eax
  802196:	39 c2                	cmp    %eax,%edx
  802198:	76 7d                	jbe    802217 <insert_sorted_allocList+0x251>
  80219a:	8b 45 08             	mov    0x8(%ebp),%eax
  80219d:	8b 50 08             	mov    0x8(%eax),%edx
  8021a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8021a3:	8b 40 08             	mov    0x8(%eax),%eax
  8021a6:	39 c2                	cmp    %eax,%edx
  8021a8:	73 6d                	jae    802217 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8021aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021ae:	74 06                	je     8021b6 <insert_sorted_allocList+0x1f0>
  8021b0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021b4:	75 14                	jne    8021ca <insert_sorted_allocList+0x204>
  8021b6:	83 ec 04             	sub    $0x4,%esp
  8021b9:	68 b4 3f 80 00       	push   $0x803fb4
  8021be:	6a 7f                	push   $0x7f
  8021c0:	68 3f 3f 80 00       	push   $0x803f3f
  8021c5:	e8 ad e0 ff ff       	call   800277 <_panic>
  8021ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021cd:	8b 10                	mov    (%eax),%edx
  8021cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d2:	89 10                	mov    %edx,(%eax)
  8021d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d7:	8b 00                	mov    (%eax),%eax
  8021d9:	85 c0                	test   %eax,%eax
  8021db:	74 0b                	je     8021e8 <insert_sorted_allocList+0x222>
  8021dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e0:	8b 00                	mov    (%eax),%eax
  8021e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8021e5:	89 50 04             	mov    %edx,0x4(%eax)
  8021e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8021ee:	89 10                	mov    %edx,(%eax)
  8021f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021f6:	89 50 04             	mov    %edx,0x4(%eax)
  8021f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fc:	8b 00                	mov    (%eax),%eax
  8021fe:	85 c0                	test   %eax,%eax
  802200:	75 08                	jne    80220a <insert_sorted_allocList+0x244>
  802202:	8b 45 08             	mov    0x8(%ebp),%eax
  802205:	a3 44 50 80 00       	mov    %eax,0x805044
  80220a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80220f:	40                   	inc    %eax
  802210:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802215:	eb 39                	jmp    802250 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802217:	a1 48 50 80 00       	mov    0x805048,%eax
  80221c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80221f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802223:	74 07                	je     80222c <insert_sorted_allocList+0x266>
  802225:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802228:	8b 00                	mov    (%eax),%eax
  80222a:	eb 05                	jmp    802231 <insert_sorted_allocList+0x26b>
  80222c:	b8 00 00 00 00       	mov    $0x0,%eax
  802231:	a3 48 50 80 00       	mov    %eax,0x805048
  802236:	a1 48 50 80 00       	mov    0x805048,%eax
  80223b:	85 c0                	test   %eax,%eax
  80223d:	0f 85 3f ff ff ff    	jne    802182 <insert_sorted_allocList+0x1bc>
  802243:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802247:	0f 85 35 ff ff ff    	jne    802182 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80224d:	eb 01                	jmp    802250 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80224f:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802250:	90                   	nop
  802251:	c9                   	leave  
  802252:	c3                   	ret    

00802253 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802253:	55                   	push   %ebp
  802254:	89 e5                	mov    %esp,%ebp
  802256:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802259:	a1 38 51 80 00       	mov    0x805138,%eax
  80225e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802261:	e9 85 01 00 00       	jmp    8023eb <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802266:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802269:	8b 40 0c             	mov    0xc(%eax),%eax
  80226c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80226f:	0f 82 6e 01 00 00    	jb     8023e3 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802275:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802278:	8b 40 0c             	mov    0xc(%eax),%eax
  80227b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80227e:	0f 85 8a 00 00 00    	jne    80230e <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802284:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802288:	75 17                	jne    8022a1 <alloc_block_FF+0x4e>
  80228a:	83 ec 04             	sub    $0x4,%esp
  80228d:	68 e8 3f 80 00       	push   $0x803fe8
  802292:	68 93 00 00 00       	push   $0x93
  802297:	68 3f 3f 80 00       	push   $0x803f3f
  80229c:	e8 d6 df ff ff       	call   800277 <_panic>
  8022a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a4:	8b 00                	mov    (%eax),%eax
  8022a6:	85 c0                	test   %eax,%eax
  8022a8:	74 10                	je     8022ba <alloc_block_FF+0x67>
  8022aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ad:	8b 00                	mov    (%eax),%eax
  8022af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022b2:	8b 52 04             	mov    0x4(%edx),%edx
  8022b5:	89 50 04             	mov    %edx,0x4(%eax)
  8022b8:	eb 0b                	jmp    8022c5 <alloc_block_FF+0x72>
  8022ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022bd:	8b 40 04             	mov    0x4(%eax),%eax
  8022c0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8022c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c8:	8b 40 04             	mov    0x4(%eax),%eax
  8022cb:	85 c0                	test   %eax,%eax
  8022cd:	74 0f                	je     8022de <alloc_block_FF+0x8b>
  8022cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d2:	8b 40 04             	mov    0x4(%eax),%eax
  8022d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022d8:	8b 12                	mov    (%edx),%edx
  8022da:	89 10                	mov    %edx,(%eax)
  8022dc:	eb 0a                	jmp    8022e8 <alloc_block_FF+0x95>
  8022de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e1:	8b 00                	mov    (%eax),%eax
  8022e3:	a3 38 51 80 00       	mov    %eax,0x805138
  8022e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022eb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022fb:	a1 44 51 80 00       	mov    0x805144,%eax
  802300:	48                   	dec    %eax
  802301:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802306:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802309:	e9 10 01 00 00       	jmp    80241e <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  80230e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802311:	8b 40 0c             	mov    0xc(%eax),%eax
  802314:	3b 45 08             	cmp    0x8(%ebp),%eax
  802317:	0f 86 c6 00 00 00    	jbe    8023e3 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80231d:	a1 48 51 80 00       	mov    0x805148,%eax
  802322:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802325:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802328:	8b 50 08             	mov    0x8(%eax),%edx
  80232b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80232e:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802331:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802334:	8b 55 08             	mov    0x8(%ebp),%edx
  802337:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80233a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80233e:	75 17                	jne    802357 <alloc_block_FF+0x104>
  802340:	83 ec 04             	sub    $0x4,%esp
  802343:	68 e8 3f 80 00       	push   $0x803fe8
  802348:	68 9b 00 00 00       	push   $0x9b
  80234d:	68 3f 3f 80 00       	push   $0x803f3f
  802352:	e8 20 df ff ff       	call   800277 <_panic>
  802357:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80235a:	8b 00                	mov    (%eax),%eax
  80235c:	85 c0                	test   %eax,%eax
  80235e:	74 10                	je     802370 <alloc_block_FF+0x11d>
  802360:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802363:	8b 00                	mov    (%eax),%eax
  802365:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802368:	8b 52 04             	mov    0x4(%edx),%edx
  80236b:	89 50 04             	mov    %edx,0x4(%eax)
  80236e:	eb 0b                	jmp    80237b <alloc_block_FF+0x128>
  802370:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802373:	8b 40 04             	mov    0x4(%eax),%eax
  802376:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80237b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80237e:	8b 40 04             	mov    0x4(%eax),%eax
  802381:	85 c0                	test   %eax,%eax
  802383:	74 0f                	je     802394 <alloc_block_FF+0x141>
  802385:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802388:	8b 40 04             	mov    0x4(%eax),%eax
  80238b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80238e:	8b 12                	mov    (%edx),%edx
  802390:	89 10                	mov    %edx,(%eax)
  802392:	eb 0a                	jmp    80239e <alloc_block_FF+0x14b>
  802394:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802397:	8b 00                	mov    (%eax),%eax
  802399:	a3 48 51 80 00       	mov    %eax,0x805148
  80239e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023a1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023aa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023b1:	a1 54 51 80 00       	mov    0x805154,%eax
  8023b6:	48                   	dec    %eax
  8023b7:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  8023bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023bf:	8b 50 08             	mov    0x8(%eax),%edx
  8023c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c5:	01 c2                	add    %eax,%edx
  8023c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ca:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8023cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8023d3:	2b 45 08             	sub    0x8(%ebp),%eax
  8023d6:	89 c2                	mov    %eax,%edx
  8023d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023db:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8023de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023e1:	eb 3b                	jmp    80241e <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8023e3:	a1 40 51 80 00       	mov    0x805140,%eax
  8023e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023ef:	74 07                	je     8023f8 <alloc_block_FF+0x1a5>
  8023f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f4:	8b 00                	mov    (%eax),%eax
  8023f6:	eb 05                	jmp    8023fd <alloc_block_FF+0x1aa>
  8023f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8023fd:	a3 40 51 80 00       	mov    %eax,0x805140
  802402:	a1 40 51 80 00       	mov    0x805140,%eax
  802407:	85 c0                	test   %eax,%eax
  802409:	0f 85 57 fe ff ff    	jne    802266 <alloc_block_FF+0x13>
  80240f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802413:	0f 85 4d fe ff ff    	jne    802266 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802419:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80241e:	c9                   	leave  
  80241f:	c3                   	ret    

00802420 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802420:	55                   	push   %ebp
  802421:	89 e5                	mov    %esp,%ebp
  802423:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802426:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80242d:	a1 38 51 80 00       	mov    0x805138,%eax
  802432:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802435:	e9 df 00 00 00       	jmp    802519 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  80243a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243d:	8b 40 0c             	mov    0xc(%eax),%eax
  802440:	3b 45 08             	cmp    0x8(%ebp),%eax
  802443:	0f 82 c8 00 00 00    	jb     802511 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802449:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244c:	8b 40 0c             	mov    0xc(%eax),%eax
  80244f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802452:	0f 85 8a 00 00 00    	jne    8024e2 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802458:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80245c:	75 17                	jne    802475 <alloc_block_BF+0x55>
  80245e:	83 ec 04             	sub    $0x4,%esp
  802461:	68 e8 3f 80 00       	push   $0x803fe8
  802466:	68 b7 00 00 00       	push   $0xb7
  80246b:	68 3f 3f 80 00       	push   $0x803f3f
  802470:	e8 02 de ff ff       	call   800277 <_panic>
  802475:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802478:	8b 00                	mov    (%eax),%eax
  80247a:	85 c0                	test   %eax,%eax
  80247c:	74 10                	je     80248e <alloc_block_BF+0x6e>
  80247e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802481:	8b 00                	mov    (%eax),%eax
  802483:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802486:	8b 52 04             	mov    0x4(%edx),%edx
  802489:	89 50 04             	mov    %edx,0x4(%eax)
  80248c:	eb 0b                	jmp    802499 <alloc_block_BF+0x79>
  80248e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802491:	8b 40 04             	mov    0x4(%eax),%eax
  802494:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802499:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249c:	8b 40 04             	mov    0x4(%eax),%eax
  80249f:	85 c0                	test   %eax,%eax
  8024a1:	74 0f                	je     8024b2 <alloc_block_BF+0x92>
  8024a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a6:	8b 40 04             	mov    0x4(%eax),%eax
  8024a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024ac:	8b 12                	mov    (%edx),%edx
  8024ae:	89 10                	mov    %edx,(%eax)
  8024b0:	eb 0a                	jmp    8024bc <alloc_block_BF+0x9c>
  8024b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b5:	8b 00                	mov    (%eax),%eax
  8024b7:	a3 38 51 80 00       	mov    %eax,0x805138
  8024bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024cf:	a1 44 51 80 00       	mov    0x805144,%eax
  8024d4:	48                   	dec    %eax
  8024d5:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  8024da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024dd:	e9 4d 01 00 00       	jmp    80262f <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8024e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e5:	8b 40 0c             	mov    0xc(%eax),%eax
  8024e8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024eb:	76 24                	jbe    802511 <alloc_block_BF+0xf1>
  8024ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f0:	8b 40 0c             	mov    0xc(%eax),%eax
  8024f3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8024f6:	73 19                	jae    802511 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8024f8:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8024ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802502:	8b 40 0c             	mov    0xc(%eax),%eax
  802505:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802508:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250b:	8b 40 08             	mov    0x8(%eax),%eax
  80250e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802511:	a1 40 51 80 00       	mov    0x805140,%eax
  802516:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802519:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80251d:	74 07                	je     802526 <alloc_block_BF+0x106>
  80251f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802522:	8b 00                	mov    (%eax),%eax
  802524:	eb 05                	jmp    80252b <alloc_block_BF+0x10b>
  802526:	b8 00 00 00 00       	mov    $0x0,%eax
  80252b:	a3 40 51 80 00       	mov    %eax,0x805140
  802530:	a1 40 51 80 00       	mov    0x805140,%eax
  802535:	85 c0                	test   %eax,%eax
  802537:	0f 85 fd fe ff ff    	jne    80243a <alloc_block_BF+0x1a>
  80253d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802541:	0f 85 f3 fe ff ff    	jne    80243a <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802547:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80254b:	0f 84 d9 00 00 00    	je     80262a <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802551:	a1 48 51 80 00       	mov    0x805148,%eax
  802556:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802559:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80255c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80255f:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802562:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802565:	8b 55 08             	mov    0x8(%ebp),%edx
  802568:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  80256b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80256f:	75 17                	jne    802588 <alloc_block_BF+0x168>
  802571:	83 ec 04             	sub    $0x4,%esp
  802574:	68 e8 3f 80 00       	push   $0x803fe8
  802579:	68 c7 00 00 00       	push   $0xc7
  80257e:	68 3f 3f 80 00       	push   $0x803f3f
  802583:	e8 ef dc ff ff       	call   800277 <_panic>
  802588:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80258b:	8b 00                	mov    (%eax),%eax
  80258d:	85 c0                	test   %eax,%eax
  80258f:	74 10                	je     8025a1 <alloc_block_BF+0x181>
  802591:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802594:	8b 00                	mov    (%eax),%eax
  802596:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802599:	8b 52 04             	mov    0x4(%edx),%edx
  80259c:	89 50 04             	mov    %edx,0x4(%eax)
  80259f:	eb 0b                	jmp    8025ac <alloc_block_BF+0x18c>
  8025a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025a4:	8b 40 04             	mov    0x4(%eax),%eax
  8025a7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8025ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025af:	8b 40 04             	mov    0x4(%eax),%eax
  8025b2:	85 c0                	test   %eax,%eax
  8025b4:	74 0f                	je     8025c5 <alloc_block_BF+0x1a5>
  8025b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025b9:	8b 40 04             	mov    0x4(%eax),%eax
  8025bc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025bf:	8b 12                	mov    (%edx),%edx
  8025c1:	89 10                	mov    %edx,(%eax)
  8025c3:	eb 0a                	jmp    8025cf <alloc_block_BF+0x1af>
  8025c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025c8:	8b 00                	mov    (%eax),%eax
  8025ca:	a3 48 51 80 00       	mov    %eax,0x805148
  8025cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025d2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025db:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025e2:	a1 54 51 80 00       	mov    0x805154,%eax
  8025e7:	48                   	dec    %eax
  8025e8:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8025ed:	83 ec 08             	sub    $0x8,%esp
  8025f0:	ff 75 ec             	pushl  -0x14(%ebp)
  8025f3:	68 38 51 80 00       	push   $0x805138
  8025f8:	e8 71 f9 ff ff       	call   801f6e <find_block>
  8025fd:	83 c4 10             	add    $0x10,%esp
  802600:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802603:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802606:	8b 50 08             	mov    0x8(%eax),%edx
  802609:	8b 45 08             	mov    0x8(%ebp),%eax
  80260c:	01 c2                	add    %eax,%edx
  80260e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802611:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802614:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802617:	8b 40 0c             	mov    0xc(%eax),%eax
  80261a:	2b 45 08             	sub    0x8(%ebp),%eax
  80261d:	89 c2                	mov    %eax,%edx
  80261f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802622:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802625:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802628:	eb 05                	jmp    80262f <alloc_block_BF+0x20f>
	}
	return NULL;
  80262a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80262f:	c9                   	leave  
  802630:	c3                   	ret    

00802631 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802631:	55                   	push   %ebp
  802632:	89 e5                	mov    %esp,%ebp
  802634:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802637:	a1 28 50 80 00       	mov    0x805028,%eax
  80263c:	85 c0                	test   %eax,%eax
  80263e:	0f 85 de 01 00 00    	jne    802822 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802644:	a1 38 51 80 00       	mov    0x805138,%eax
  802649:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80264c:	e9 9e 01 00 00       	jmp    8027ef <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802651:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802654:	8b 40 0c             	mov    0xc(%eax),%eax
  802657:	3b 45 08             	cmp    0x8(%ebp),%eax
  80265a:	0f 82 87 01 00 00    	jb     8027e7 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802660:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802663:	8b 40 0c             	mov    0xc(%eax),%eax
  802666:	3b 45 08             	cmp    0x8(%ebp),%eax
  802669:	0f 85 95 00 00 00    	jne    802704 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  80266f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802673:	75 17                	jne    80268c <alloc_block_NF+0x5b>
  802675:	83 ec 04             	sub    $0x4,%esp
  802678:	68 e8 3f 80 00       	push   $0x803fe8
  80267d:	68 e0 00 00 00       	push   $0xe0
  802682:	68 3f 3f 80 00       	push   $0x803f3f
  802687:	e8 eb db ff ff       	call   800277 <_panic>
  80268c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268f:	8b 00                	mov    (%eax),%eax
  802691:	85 c0                	test   %eax,%eax
  802693:	74 10                	je     8026a5 <alloc_block_NF+0x74>
  802695:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802698:	8b 00                	mov    (%eax),%eax
  80269a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80269d:	8b 52 04             	mov    0x4(%edx),%edx
  8026a0:	89 50 04             	mov    %edx,0x4(%eax)
  8026a3:	eb 0b                	jmp    8026b0 <alloc_block_NF+0x7f>
  8026a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a8:	8b 40 04             	mov    0x4(%eax),%eax
  8026ab:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8026b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b3:	8b 40 04             	mov    0x4(%eax),%eax
  8026b6:	85 c0                	test   %eax,%eax
  8026b8:	74 0f                	je     8026c9 <alloc_block_NF+0x98>
  8026ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bd:	8b 40 04             	mov    0x4(%eax),%eax
  8026c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026c3:	8b 12                	mov    (%edx),%edx
  8026c5:	89 10                	mov    %edx,(%eax)
  8026c7:	eb 0a                	jmp    8026d3 <alloc_block_NF+0xa2>
  8026c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cc:	8b 00                	mov    (%eax),%eax
  8026ce:	a3 38 51 80 00       	mov    %eax,0x805138
  8026d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026df:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026e6:	a1 44 51 80 00       	mov    0x805144,%eax
  8026eb:	48                   	dec    %eax
  8026ec:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  8026f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f4:	8b 40 08             	mov    0x8(%eax),%eax
  8026f7:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  8026fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ff:	e9 f8 04 00 00       	jmp    802bfc <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802704:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802707:	8b 40 0c             	mov    0xc(%eax),%eax
  80270a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80270d:	0f 86 d4 00 00 00    	jbe    8027e7 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802713:	a1 48 51 80 00       	mov    0x805148,%eax
  802718:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  80271b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271e:	8b 50 08             	mov    0x8(%eax),%edx
  802721:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802724:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802727:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80272a:	8b 55 08             	mov    0x8(%ebp),%edx
  80272d:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802730:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802734:	75 17                	jne    80274d <alloc_block_NF+0x11c>
  802736:	83 ec 04             	sub    $0x4,%esp
  802739:	68 e8 3f 80 00       	push   $0x803fe8
  80273e:	68 e9 00 00 00       	push   $0xe9
  802743:	68 3f 3f 80 00       	push   $0x803f3f
  802748:	e8 2a db ff ff       	call   800277 <_panic>
  80274d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802750:	8b 00                	mov    (%eax),%eax
  802752:	85 c0                	test   %eax,%eax
  802754:	74 10                	je     802766 <alloc_block_NF+0x135>
  802756:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802759:	8b 00                	mov    (%eax),%eax
  80275b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80275e:	8b 52 04             	mov    0x4(%edx),%edx
  802761:	89 50 04             	mov    %edx,0x4(%eax)
  802764:	eb 0b                	jmp    802771 <alloc_block_NF+0x140>
  802766:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802769:	8b 40 04             	mov    0x4(%eax),%eax
  80276c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802771:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802774:	8b 40 04             	mov    0x4(%eax),%eax
  802777:	85 c0                	test   %eax,%eax
  802779:	74 0f                	je     80278a <alloc_block_NF+0x159>
  80277b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80277e:	8b 40 04             	mov    0x4(%eax),%eax
  802781:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802784:	8b 12                	mov    (%edx),%edx
  802786:	89 10                	mov    %edx,(%eax)
  802788:	eb 0a                	jmp    802794 <alloc_block_NF+0x163>
  80278a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80278d:	8b 00                	mov    (%eax),%eax
  80278f:	a3 48 51 80 00       	mov    %eax,0x805148
  802794:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802797:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80279d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027a0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027a7:	a1 54 51 80 00       	mov    0x805154,%eax
  8027ac:	48                   	dec    %eax
  8027ad:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  8027b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027b5:	8b 40 08             	mov    0x8(%eax),%eax
  8027b8:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  8027bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c0:	8b 50 08             	mov    0x8(%eax),%edx
  8027c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c6:	01 c2                	add    %eax,%edx
  8027c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cb:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  8027ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d1:	8b 40 0c             	mov    0xc(%eax),%eax
  8027d4:	2b 45 08             	sub    0x8(%ebp),%eax
  8027d7:	89 c2                	mov    %eax,%edx
  8027d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027dc:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8027df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e2:	e9 15 04 00 00       	jmp    802bfc <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8027e7:	a1 40 51 80 00       	mov    0x805140,%eax
  8027ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027f3:	74 07                	je     8027fc <alloc_block_NF+0x1cb>
  8027f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f8:	8b 00                	mov    (%eax),%eax
  8027fa:	eb 05                	jmp    802801 <alloc_block_NF+0x1d0>
  8027fc:	b8 00 00 00 00       	mov    $0x0,%eax
  802801:	a3 40 51 80 00       	mov    %eax,0x805140
  802806:	a1 40 51 80 00       	mov    0x805140,%eax
  80280b:	85 c0                	test   %eax,%eax
  80280d:	0f 85 3e fe ff ff    	jne    802651 <alloc_block_NF+0x20>
  802813:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802817:	0f 85 34 fe ff ff    	jne    802651 <alloc_block_NF+0x20>
  80281d:	e9 d5 03 00 00       	jmp    802bf7 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802822:	a1 38 51 80 00       	mov    0x805138,%eax
  802827:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80282a:	e9 b1 01 00 00       	jmp    8029e0 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  80282f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802832:	8b 50 08             	mov    0x8(%eax),%edx
  802835:	a1 28 50 80 00       	mov    0x805028,%eax
  80283a:	39 c2                	cmp    %eax,%edx
  80283c:	0f 82 96 01 00 00    	jb     8029d8 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802842:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802845:	8b 40 0c             	mov    0xc(%eax),%eax
  802848:	3b 45 08             	cmp    0x8(%ebp),%eax
  80284b:	0f 82 87 01 00 00    	jb     8029d8 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802851:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802854:	8b 40 0c             	mov    0xc(%eax),%eax
  802857:	3b 45 08             	cmp    0x8(%ebp),%eax
  80285a:	0f 85 95 00 00 00    	jne    8028f5 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802860:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802864:	75 17                	jne    80287d <alloc_block_NF+0x24c>
  802866:	83 ec 04             	sub    $0x4,%esp
  802869:	68 e8 3f 80 00       	push   $0x803fe8
  80286e:	68 fc 00 00 00       	push   $0xfc
  802873:	68 3f 3f 80 00       	push   $0x803f3f
  802878:	e8 fa d9 ff ff       	call   800277 <_panic>
  80287d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802880:	8b 00                	mov    (%eax),%eax
  802882:	85 c0                	test   %eax,%eax
  802884:	74 10                	je     802896 <alloc_block_NF+0x265>
  802886:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802889:	8b 00                	mov    (%eax),%eax
  80288b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80288e:	8b 52 04             	mov    0x4(%edx),%edx
  802891:	89 50 04             	mov    %edx,0x4(%eax)
  802894:	eb 0b                	jmp    8028a1 <alloc_block_NF+0x270>
  802896:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802899:	8b 40 04             	mov    0x4(%eax),%eax
  80289c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8028a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a4:	8b 40 04             	mov    0x4(%eax),%eax
  8028a7:	85 c0                	test   %eax,%eax
  8028a9:	74 0f                	je     8028ba <alloc_block_NF+0x289>
  8028ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ae:	8b 40 04             	mov    0x4(%eax),%eax
  8028b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028b4:	8b 12                	mov    (%edx),%edx
  8028b6:	89 10                	mov    %edx,(%eax)
  8028b8:	eb 0a                	jmp    8028c4 <alloc_block_NF+0x293>
  8028ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bd:	8b 00                	mov    (%eax),%eax
  8028bf:	a3 38 51 80 00       	mov    %eax,0x805138
  8028c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028d7:	a1 44 51 80 00       	mov    0x805144,%eax
  8028dc:	48                   	dec    %eax
  8028dd:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8028e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e5:	8b 40 08             	mov    0x8(%eax),%eax
  8028e8:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  8028ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f0:	e9 07 03 00 00       	jmp    802bfc <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8028f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f8:	8b 40 0c             	mov    0xc(%eax),%eax
  8028fb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028fe:	0f 86 d4 00 00 00    	jbe    8029d8 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802904:	a1 48 51 80 00       	mov    0x805148,%eax
  802909:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  80290c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290f:	8b 50 08             	mov    0x8(%eax),%edx
  802912:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802915:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802918:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80291b:	8b 55 08             	mov    0x8(%ebp),%edx
  80291e:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802921:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802925:	75 17                	jne    80293e <alloc_block_NF+0x30d>
  802927:	83 ec 04             	sub    $0x4,%esp
  80292a:	68 e8 3f 80 00       	push   $0x803fe8
  80292f:	68 04 01 00 00       	push   $0x104
  802934:	68 3f 3f 80 00       	push   $0x803f3f
  802939:	e8 39 d9 ff ff       	call   800277 <_panic>
  80293e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802941:	8b 00                	mov    (%eax),%eax
  802943:	85 c0                	test   %eax,%eax
  802945:	74 10                	je     802957 <alloc_block_NF+0x326>
  802947:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80294a:	8b 00                	mov    (%eax),%eax
  80294c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80294f:	8b 52 04             	mov    0x4(%edx),%edx
  802952:	89 50 04             	mov    %edx,0x4(%eax)
  802955:	eb 0b                	jmp    802962 <alloc_block_NF+0x331>
  802957:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80295a:	8b 40 04             	mov    0x4(%eax),%eax
  80295d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802962:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802965:	8b 40 04             	mov    0x4(%eax),%eax
  802968:	85 c0                	test   %eax,%eax
  80296a:	74 0f                	je     80297b <alloc_block_NF+0x34a>
  80296c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80296f:	8b 40 04             	mov    0x4(%eax),%eax
  802972:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802975:	8b 12                	mov    (%edx),%edx
  802977:	89 10                	mov    %edx,(%eax)
  802979:	eb 0a                	jmp    802985 <alloc_block_NF+0x354>
  80297b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80297e:	8b 00                	mov    (%eax),%eax
  802980:	a3 48 51 80 00       	mov    %eax,0x805148
  802985:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802988:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80298e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802991:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802998:	a1 54 51 80 00       	mov    0x805154,%eax
  80299d:	48                   	dec    %eax
  80299e:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  8029a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029a6:	8b 40 08             	mov    0x8(%eax),%eax
  8029a9:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  8029ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b1:	8b 50 08             	mov    0x8(%eax),%edx
  8029b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b7:	01 c2                	add    %eax,%edx
  8029b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bc:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8029bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c2:	8b 40 0c             	mov    0xc(%eax),%eax
  8029c5:	2b 45 08             	sub    0x8(%ebp),%eax
  8029c8:	89 c2                	mov    %eax,%edx
  8029ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029cd:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8029d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029d3:	e9 24 02 00 00       	jmp    802bfc <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8029d8:	a1 40 51 80 00       	mov    0x805140,%eax
  8029dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029e4:	74 07                	je     8029ed <alloc_block_NF+0x3bc>
  8029e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e9:	8b 00                	mov    (%eax),%eax
  8029eb:	eb 05                	jmp    8029f2 <alloc_block_NF+0x3c1>
  8029ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8029f2:	a3 40 51 80 00       	mov    %eax,0x805140
  8029f7:	a1 40 51 80 00       	mov    0x805140,%eax
  8029fc:	85 c0                	test   %eax,%eax
  8029fe:	0f 85 2b fe ff ff    	jne    80282f <alloc_block_NF+0x1fe>
  802a04:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a08:	0f 85 21 fe ff ff    	jne    80282f <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a0e:	a1 38 51 80 00       	mov    0x805138,%eax
  802a13:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a16:	e9 ae 01 00 00       	jmp    802bc9 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802a1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1e:	8b 50 08             	mov    0x8(%eax),%edx
  802a21:	a1 28 50 80 00       	mov    0x805028,%eax
  802a26:	39 c2                	cmp    %eax,%edx
  802a28:	0f 83 93 01 00 00    	jae    802bc1 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802a2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a31:	8b 40 0c             	mov    0xc(%eax),%eax
  802a34:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a37:	0f 82 84 01 00 00    	jb     802bc1 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802a3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a40:	8b 40 0c             	mov    0xc(%eax),%eax
  802a43:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a46:	0f 85 95 00 00 00    	jne    802ae1 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802a4c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a50:	75 17                	jne    802a69 <alloc_block_NF+0x438>
  802a52:	83 ec 04             	sub    $0x4,%esp
  802a55:	68 e8 3f 80 00       	push   $0x803fe8
  802a5a:	68 14 01 00 00       	push   $0x114
  802a5f:	68 3f 3f 80 00       	push   $0x803f3f
  802a64:	e8 0e d8 ff ff       	call   800277 <_panic>
  802a69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6c:	8b 00                	mov    (%eax),%eax
  802a6e:	85 c0                	test   %eax,%eax
  802a70:	74 10                	je     802a82 <alloc_block_NF+0x451>
  802a72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a75:	8b 00                	mov    (%eax),%eax
  802a77:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a7a:	8b 52 04             	mov    0x4(%edx),%edx
  802a7d:	89 50 04             	mov    %edx,0x4(%eax)
  802a80:	eb 0b                	jmp    802a8d <alloc_block_NF+0x45c>
  802a82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a85:	8b 40 04             	mov    0x4(%eax),%eax
  802a88:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a90:	8b 40 04             	mov    0x4(%eax),%eax
  802a93:	85 c0                	test   %eax,%eax
  802a95:	74 0f                	je     802aa6 <alloc_block_NF+0x475>
  802a97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9a:	8b 40 04             	mov    0x4(%eax),%eax
  802a9d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802aa0:	8b 12                	mov    (%edx),%edx
  802aa2:	89 10                	mov    %edx,(%eax)
  802aa4:	eb 0a                	jmp    802ab0 <alloc_block_NF+0x47f>
  802aa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa9:	8b 00                	mov    (%eax),%eax
  802aab:	a3 38 51 80 00       	mov    %eax,0x805138
  802ab0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ab9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ac3:	a1 44 51 80 00       	mov    0x805144,%eax
  802ac8:	48                   	dec    %eax
  802ac9:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802ace:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad1:	8b 40 08             	mov    0x8(%eax),%eax
  802ad4:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802ad9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802adc:	e9 1b 01 00 00       	jmp    802bfc <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802ae1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae4:	8b 40 0c             	mov    0xc(%eax),%eax
  802ae7:	3b 45 08             	cmp    0x8(%ebp),%eax
  802aea:	0f 86 d1 00 00 00    	jbe    802bc1 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802af0:	a1 48 51 80 00       	mov    0x805148,%eax
  802af5:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802af8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afb:	8b 50 08             	mov    0x8(%eax),%edx
  802afe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b01:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802b04:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b07:	8b 55 08             	mov    0x8(%ebp),%edx
  802b0a:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b0d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b11:	75 17                	jne    802b2a <alloc_block_NF+0x4f9>
  802b13:	83 ec 04             	sub    $0x4,%esp
  802b16:	68 e8 3f 80 00       	push   $0x803fe8
  802b1b:	68 1c 01 00 00       	push   $0x11c
  802b20:	68 3f 3f 80 00       	push   $0x803f3f
  802b25:	e8 4d d7 ff ff       	call   800277 <_panic>
  802b2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b2d:	8b 00                	mov    (%eax),%eax
  802b2f:	85 c0                	test   %eax,%eax
  802b31:	74 10                	je     802b43 <alloc_block_NF+0x512>
  802b33:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b36:	8b 00                	mov    (%eax),%eax
  802b38:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b3b:	8b 52 04             	mov    0x4(%edx),%edx
  802b3e:	89 50 04             	mov    %edx,0x4(%eax)
  802b41:	eb 0b                	jmp    802b4e <alloc_block_NF+0x51d>
  802b43:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b46:	8b 40 04             	mov    0x4(%eax),%eax
  802b49:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b4e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b51:	8b 40 04             	mov    0x4(%eax),%eax
  802b54:	85 c0                	test   %eax,%eax
  802b56:	74 0f                	je     802b67 <alloc_block_NF+0x536>
  802b58:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b5b:	8b 40 04             	mov    0x4(%eax),%eax
  802b5e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b61:	8b 12                	mov    (%edx),%edx
  802b63:	89 10                	mov    %edx,(%eax)
  802b65:	eb 0a                	jmp    802b71 <alloc_block_NF+0x540>
  802b67:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b6a:	8b 00                	mov    (%eax),%eax
  802b6c:	a3 48 51 80 00       	mov    %eax,0x805148
  802b71:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b74:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b7a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b7d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b84:	a1 54 51 80 00       	mov    0x805154,%eax
  802b89:	48                   	dec    %eax
  802b8a:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802b8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b92:	8b 40 08             	mov    0x8(%eax),%eax
  802b95:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802b9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9d:	8b 50 08             	mov    0x8(%eax),%edx
  802ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba3:	01 c2                	add    %eax,%edx
  802ba5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba8:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802bab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bae:	8b 40 0c             	mov    0xc(%eax),%eax
  802bb1:	2b 45 08             	sub    0x8(%ebp),%eax
  802bb4:	89 c2                	mov    %eax,%edx
  802bb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb9:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802bbc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bbf:	eb 3b                	jmp    802bfc <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802bc1:	a1 40 51 80 00       	mov    0x805140,%eax
  802bc6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bc9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bcd:	74 07                	je     802bd6 <alloc_block_NF+0x5a5>
  802bcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd2:	8b 00                	mov    (%eax),%eax
  802bd4:	eb 05                	jmp    802bdb <alloc_block_NF+0x5aa>
  802bd6:	b8 00 00 00 00       	mov    $0x0,%eax
  802bdb:	a3 40 51 80 00       	mov    %eax,0x805140
  802be0:	a1 40 51 80 00       	mov    0x805140,%eax
  802be5:	85 c0                	test   %eax,%eax
  802be7:	0f 85 2e fe ff ff    	jne    802a1b <alloc_block_NF+0x3ea>
  802bed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bf1:	0f 85 24 fe ff ff    	jne    802a1b <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802bf7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bfc:	c9                   	leave  
  802bfd:	c3                   	ret    

00802bfe <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802bfe:	55                   	push   %ebp
  802bff:	89 e5                	mov    %esp,%ebp
  802c01:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802c04:	a1 38 51 80 00       	mov    0x805138,%eax
  802c09:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802c0c:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802c11:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802c14:	a1 38 51 80 00       	mov    0x805138,%eax
  802c19:	85 c0                	test   %eax,%eax
  802c1b:	74 14                	je     802c31 <insert_sorted_with_merge_freeList+0x33>
  802c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c20:	8b 50 08             	mov    0x8(%eax),%edx
  802c23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c26:	8b 40 08             	mov    0x8(%eax),%eax
  802c29:	39 c2                	cmp    %eax,%edx
  802c2b:	0f 87 9b 01 00 00    	ja     802dcc <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802c31:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c35:	75 17                	jne    802c4e <insert_sorted_with_merge_freeList+0x50>
  802c37:	83 ec 04             	sub    $0x4,%esp
  802c3a:	68 1c 3f 80 00       	push   $0x803f1c
  802c3f:	68 38 01 00 00       	push   $0x138
  802c44:	68 3f 3f 80 00       	push   $0x803f3f
  802c49:	e8 29 d6 ff ff       	call   800277 <_panic>
  802c4e:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802c54:	8b 45 08             	mov    0x8(%ebp),%eax
  802c57:	89 10                	mov    %edx,(%eax)
  802c59:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5c:	8b 00                	mov    (%eax),%eax
  802c5e:	85 c0                	test   %eax,%eax
  802c60:	74 0d                	je     802c6f <insert_sorted_with_merge_freeList+0x71>
  802c62:	a1 38 51 80 00       	mov    0x805138,%eax
  802c67:	8b 55 08             	mov    0x8(%ebp),%edx
  802c6a:	89 50 04             	mov    %edx,0x4(%eax)
  802c6d:	eb 08                	jmp    802c77 <insert_sorted_with_merge_freeList+0x79>
  802c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c72:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c77:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7a:	a3 38 51 80 00       	mov    %eax,0x805138
  802c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c82:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c89:	a1 44 51 80 00       	mov    0x805144,%eax
  802c8e:	40                   	inc    %eax
  802c8f:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802c94:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c98:	0f 84 a8 06 00 00    	je     803346 <insert_sorted_with_merge_freeList+0x748>
  802c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca1:	8b 50 08             	mov    0x8(%eax),%edx
  802ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca7:	8b 40 0c             	mov    0xc(%eax),%eax
  802caa:	01 c2                	add    %eax,%edx
  802cac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802caf:	8b 40 08             	mov    0x8(%eax),%eax
  802cb2:	39 c2                	cmp    %eax,%edx
  802cb4:	0f 85 8c 06 00 00    	jne    803346 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802cba:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbd:	8b 50 0c             	mov    0xc(%eax),%edx
  802cc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cc3:	8b 40 0c             	mov    0xc(%eax),%eax
  802cc6:	01 c2                	add    %eax,%edx
  802cc8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ccb:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802cce:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cd2:	75 17                	jne    802ceb <insert_sorted_with_merge_freeList+0xed>
  802cd4:	83 ec 04             	sub    $0x4,%esp
  802cd7:	68 e8 3f 80 00       	push   $0x803fe8
  802cdc:	68 3c 01 00 00       	push   $0x13c
  802ce1:	68 3f 3f 80 00       	push   $0x803f3f
  802ce6:	e8 8c d5 ff ff       	call   800277 <_panic>
  802ceb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cee:	8b 00                	mov    (%eax),%eax
  802cf0:	85 c0                	test   %eax,%eax
  802cf2:	74 10                	je     802d04 <insert_sorted_with_merge_freeList+0x106>
  802cf4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf7:	8b 00                	mov    (%eax),%eax
  802cf9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cfc:	8b 52 04             	mov    0x4(%edx),%edx
  802cff:	89 50 04             	mov    %edx,0x4(%eax)
  802d02:	eb 0b                	jmp    802d0f <insert_sorted_with_merge_freeList+0x111>
  802d04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d07:	8b 40 04             	mov    0x4(%eax),%eax
  802d0a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d12:	8b 40 04             	mov    0x4(%eax),%eax
  802d15:	85 c0                	test   %eax,%eax
  802d17:	74 0f                	je     802d28 <insert_sorted_with_merge_freeList+0x12a>
  802d19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d1c:	8b 40 04             	mov    0x4(%eax),%eax
  802d1f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d22:	8b 12                	mov    (%edx),%edx
  802d24:	89 10                	mov    %edx,(%eax)
  802d26:	eb 0a                	jmp    802d32 <insert_sorted_with_merge_freeList+0x134>
  802d28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d2b:	8b 00                	mov    (%eax),%eax
  802d2d:	a3 38 51 80 00       	mov    %eax,0x805138
  802d32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d35:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d3e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d45:	a1 44 51 80 00       	mov    0x805144,%eax
  802d4a:	48                   	dec    %eax
  802d4b:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802d50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d53:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802d5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d5d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802d64:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d68:	75 17                	jne    802d81 <insert_sorted_with_merge_freeList+0x183>
  802d6a:	83 ec 04             	sub    $0x4,%esp
  802d6d:	68 1c 3f 80 00       	push   $0x803f1c
  802d72:	68 3f 01 00 00       	push   $0x13f
  802d77:	68 3f 3f 80 00       	push   $0x803f3f
  802d7c:	e8 f6 d4 ff ff       	call   800277 <_panic>
  802d81:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802d87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d8a:	89 10                	mov    %edx,(%eax)
  802d8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d8f:	8b 00                	mov    (%eax),%eax
  802d91:	85 c0                	test   %eax,%eax
  802d93:	74 0d                	je     802da2 <insert_sorted_with_merge_freeList+0x1a4>
  802d95:	a1 48 51 80 00       	mov    0x805148,%eax
  802d9a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d9d:	89 50 04             	mov    %edx,0x4(%eax)
  802da0:	eb 08                	jmp    802daa <insert_sorted_with_merge_freeList+0x1ac>
  802da2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802daa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dad:	a3 48 51 80 00       	mov    %eax,0x805148
  802db2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802db5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dbc:	a1 54 51 80 00       	mov    0x805154,%eax
  802dc1:	40                   	inc    %eax
  802dc2:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802dc7:	e9 7a 05 00 00       	jmp    803346 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  802dcf:	8b 50 08             	mov    0x8(%eax),%edx
  802dd2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dd5:	8b 40 08             	mov    0x8(%eax),%eax
  802dd8:	39 c2                	cmp    %eax,%edx
  802dda:	0f 82 14 01 00 00    	jb     802ef4 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802de0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802de3:	8b 50 08             	mov    0x8(%eax),%edx
  802de6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802de9:	8b 40 0c             	mov    0xc(%eax),%eax
  802dec:	01 c2                	add    %eax,%edx
  802dee:	8b 45 08             	mov    0x8(%ebp),%eax
  802df1:	8b 40 08             	mov    0x8(%eax),%eax
  802df4:	39 c2                	cmp    %eax,%edx
  802df6:	0f 85 90 00 00 00    	jne    802e8c <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802dfc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dff:	8b 50 0c             	mov    0xc(%eax),%edx
  802e02:	8b 45 08             	mov    0x8(%ebp),%eax
  802e05:	8b 40 0c             	mov    0xc(%eax),%eax
  802e08:	01 c2                	add    %eax,%edx
  802e0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e0d:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802e10:	8b 45 08             	mov    0x8(%ebp),%eax
  802e13:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802e1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802e24:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e28:	75 17                	jne    802e41 <insert_sorted_with_merge_freeList+0x243>
  802e2a:	83 ec 04             	sub    $0x4,%esp
  802e2d:	68 1c 3f 80 00       	push   $0x803f1c
  802e32:	68 49 01 00 00       	push   $0x149
  802e37:	68 3f 3f 80 00       	push   $0x803f3f
  802e3c:	e8 36 d4 ff ff       	call   800277 <_panic>
  802e41:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802e47:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4a:	89 10                	mov    %edx,(%eax)
  802e4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4f:	8b 00                	mov    (%eax),%eax
  802e51:	85 c0                	test   %eax,%eax
  802e53:	74 0d                	je     802e62 <insert_sorted_with_merge_freeList+0x264>
  802e55:	a1 48 51 80 00       	mov    0x805148,%eax
  802e5a:	8b 55 08             	mov    0x8(%ebp),%edx
  802e5d:	89 50 04             	mov    %edx,0x4(%eax)
  802e60:	eb 08                	jmp    802e6a <insert_sorted_with_merge_freeList+0x26c>
  802e62:	8b 45 08             	mov    0x8(%ebp),%eax
  802e65:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6d:	a3 48 51 80 00       	mov    %eax,0x805148
  802e72:	8b 45 08             	mov    0x8(%ebp),%eax
  802e75:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e7c:	a1 54 51 80 00       	mov    0x805154,%eax
  802e81:	40                   	inc    %eax
  802e82:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802e87:	e9 bb 04 00 00       	jmp    803347 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802e8c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e90:	75 17                	jne    802ea9 <insert_sorted_with_merge_freeList+0x2ab>
  802e92:	83 ec 04             	sub    $0x4,%esp
  802e95:	68 90 3f 80 00       	push   $0x803f90
  802e9a:	68 4c 01 00 00       	push   $0x14c
  802e9f:	68 3f 3f 80 00       	push   $0x803f3f
  802ea4:	e8 ce d3 ff ff       	call   800277 <_panic>
  802ea9:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802eaf:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb2:	89 50 04             	mov    %edx,0x4(%eax)
  802eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb8:	8b 40 04             	mov    0x4(%eax),%eax
  802ebb:	85 c0                	test   %eax,%eax
  802ebd:	74 0c                	je     802ecb <insert_sorted_with_merge_freeList+0x2cd>
  802ebf:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802ec4:	8b 55 08             	mov    0x8(%ebp),%edx
  802ec7:	89 10                	mov    %edx,(%eax)
  802ec9:	eb 08                	jmp    802ed3 <insert_sorted_with_merge_freeList+0x2d5>
  802ecb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ece:	a3 38 51 80 00       	mov    %eax,0x805138
  802ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802edb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ede:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ee4:	a1 44 51 80 00       	mov    0x805144,%eax
  802ee9:	40                   	inc    %eax
  802eea:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802eef:	e9 53 04 00 00       	jmp    803347 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802ef4:	a1 38 51 80 00       	mov    0x805138,%eax
  802ef9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802efc:	e9 15 04 00 00       	jmp    803316 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802f01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f04:	8b 00                	mov    (%eax),%eax
  802f06:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802f09:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0c:	8b 50 08             	mov    0x8(%eax),%edx
  802f0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f12:	8b 40 08             	mov    0x8(%eax),%eax
  802f15:	39 c2                	cmp    %eax,%edx
  802f17:	0f 86 f1 03 00 00    	jbe    80330e <insert_sorted_with_merge_freeList+0x710>
  802f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f20:	8b 50 08             	mov    0x8(%eax),%edx
  802f23:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f26:	8b 40 08             	mov    0x8(%eax),%eax
  802f29:	39 c2                	cmp    %eax,%edx
  802f2b:	0f 83 dd 03 00 00    	jae    80330e <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802f31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f34:	8b 50 08             	mov    0x8(%eax),%edx
  802f37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3a:	8b 40 0c             	mov    0xc(%eax),%eax
  802f3d:	01 c2                	add    %eax,%edx
  802f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f42:	8b 40 08             	mov    0x8(%eax),%eax
  802f45:	39 c2                	cmp    %eax,%edx
  802f47:	0f 85 b9 01 00 00    	jne    803106 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802f4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f50:	8b 50 08             	mov    0x8(%eax),%edx
  802f53:	8b 45 08             	mov    0x8(%ebp),%eax
  802f56:	8b 40 0c             	mov    0xc(%eax),%eax
  802f59:	01 c2                	add    %eax,%edx
  802f5b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f5e:	8b 40 08             	mov    0x8(%eax),%eax
  802f61:	39 c2                	cmp    %eax,%edx
  802f63:	0f 85 0d 01 00 00    	jne    803076 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802f69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6c:	8b 50 0c             	mov    0xc(%eax),%edx
  802f6f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f72:	8b 40 0c             	mov    0xc(%eax),%eax
  802f75:	01 c2                	add    %eax,%edx
  802f77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7a:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802f7d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f81:	75 17                	jne    802f9a <insert_sorted_with_merge_freeList+0x39c>
  802f83:	83 ec 04             	sub    $0x4,%esp
  802f86:	68 e8 3f 80 00       	push   $0x803fe8
  802f8b:	68 5c 01 00 00       	push   $0x15c
  802f90:	68 3f 3f 80 00       	push   $0x803f3f
  802f95:	e8 dd d2 ff ff       	call   800277 <_panic>
  802f9a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f9d:	8b 00                	mov    (%eax),%eax
  802f9f:	85 c0                	test   %eax,%eax
  802fa1:	74 10                	je     802fb3 <insert_sorted_with_merge_freeList+0x3b5>
  802fa3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fa6:	8b 00                	mov    (%eax),%eax
  802fa8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fab:	8b 52 04             	mov    0x4(%edx),%edx
  802fae:	89 50 04             	mov    %edx,0x4(%eax)
  802fb1:	eb 0b                	jmp    802fbe <insert_sorted_with_merge_freeList+0x3c0>
  802fb3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fb6:	8b 40 04             	mov    0x4(%eax),%eax
  802fb9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fbe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fc1:	8b 40 04             	mov    0x4(%eax),%eax
  802fc4:	85 c0                	test   %eax,%eax
  802fc6:	74 0f                	je     802fd7 <insert_sorted_with_merge_freeList+0x3d9>
  802fc8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fcb:	8b 40 04             	mov    0x4(%eax),%eax
  802fce:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fd1:	8b 12                	mov    (%edx),%edx
  802fd3:	89 10                	mov    %edx,(%eax)
  802fd5:	eb 0a                	jmp    802fe1 <insert_sorted_with_merge_freeList+0x3e3>
  802fd7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fda:	8b 00                	mov    (%eax),%eax
  802fdc:	a3 38 51 80 00       	mov    %eax,0x805138
  802fe1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fe4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ff4:	a1 44 51 80 00       	mov    0x805144,%eax
  802ff9:	48                   	dec    %eax
  802ffa:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  802fff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803002:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803009:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80300c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803013:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803017:	75 17                	jne    803030 <insert_sorted_with_merge_freeList+0x432>
  803019:	83 ec 04             	sub    $0x4,%esp
  80301c:	68 1c 3f 80 00       	push   $0x803f1c
  803021:	68 5f 01 00 00       	push   $0x15f
  803026:	68 3f 3f 80 00       	push   $0x803f3f
  80302b:	e8 47 d2 ff ff       	call   800277 <_panic>
  803030:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803036:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803039:	89 10                	mov    %edx,(%eax)
  80303b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80303e:	8b 00                	mov    (%eax),%eax
  803040:	85 c0                	test   %eax,%eax
  803042:	74 0d                	je     803051 <insert_sorted_with_merge_freeList+0x453>
  803044:	a1 48 51 80 00       	mov    0x805148,%eax
  803049:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80304c:	89 50 04             	mov    %edx,0x4(%eax)
  80304f:	eb 08                	jmp    803059 <insert_sorted_with_merge_freeList+0x45b>
  803051:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803054:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803059:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80305c:	a3 48 51 80 00       	mov    %eax,0x805148
  803061:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803064:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80306b:	a1 54 51 80 00       	mov    0x805154,%eax
  803070:	40                   	inc    %eax
  803071:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803076:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803079:	8b 50 0c             	mov    0xc(%eax),%edx
  80307c:	8b 45 08             	mov    0x8(%ebp),%eax
  80307f:	8b 40 0c             	mov    0xc(%eax),%eax
  803082:	01 c2                	add    %eax,%edx
  803084:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803087:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  80308a:	8b 45 08             	mov    0x8(%ebp),%eax
  80308d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803094:	8b 45 08             	mov    0x8(%ebp),%eax
  803097:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80309e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030a2:	75 17                	jne    8030bb <insert_sorted_with_merge_freeList+0x4bd>
  8030a4:	83 ec 04             	sub    $0x4,%esp
  8030a7:	68 1c 3f 80 00       	push   $0x803f1c
  8030ac:	68 64 01 00 00       	push   $0x164
  8030b1:	68 3f 3f 80 00       	push   $0x803f3f
  8030b6:	e8 bc d1 ff ff       	call   800277 <_panic>
  8030bb:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8030c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c4:	89 10                	mov    %edx,(%eax)
  8030c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c9:	8b 00                	mov    (%eax),%eax
  8030cb:	85 c0                	test   %eax,%eax
  8030cd:	74 0d                	je     8030dc <insert_sorted_with_merge_freeList+0x4de>
  8030cf:	a1 48 51 80 00       	mov    0x805148,%eax
  8030d4:	8b 55 08             	mov    0x8(%ebp),%edx
  8030d7:	89 50 04             	mov    %edx,0x4(%eax)
  8030da:	eb 08                	jmp    8030e4 <insert_sorted_with_merge_freeList+0x4e6>
  8030dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8030df:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e7:	a3 48 51 80 00       	mov    %eax,0x805148
  8030ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ef:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030f6:	a1 54 51 80 00       	mov    0x805154,%eax
  8030fb:	40                   	inc    %eax
  8030fc:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803101:	e9 41 02 00 00       	jmp    803347 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803106:	8b 45 08             	mov    0x8(%ebp),%eax
  803109:	8b 50 08             	mov    0x8(%eax),%edx
  80310c:	8b 45 08             	mov    0x8(%ebp),%eax
  80310f:	8b 40 0c             	mov    0xc(%eax),%eax
  803112:	01 c2                	add    %eax,%edx
  803114:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803117:	8b 40 08             	mov    0x8(%eax),%eax
  80311a:	39 c2                	cmp    %eax,%edx
  80311c:	0f 85 7c 01 00 00    	jne    80329e <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803122:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803126:	74 06                	je     80312e <insert_sorted_with_merge_freeList+0x530>
  803128:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80312c:	75 17                	jne    803145 <insert_sorted_with_merge_freeList+0x547>
  80312e:	83 ec 04             	sub    $0x4,%esp
  803131:	68 58 3f 80 00       	push   $0x803f58
  803136:	68 69 01 00 00       	push   $0x169
  80313b:	68 3f 3f 80 00       	push   $0x803f3f
  803140:	e8 32 d1 ff ff       	call   800277 <_panic>
  803145:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803148:	8b 50 04             	mov    0x4(%eax),%edx
  80314b:	8b 45 08             	mov    0x8(%ebp),%eax
  80314e:	89 50 04             	mov    %edx,0x4(%eax)
  803151:	8b 45 08             	mov    0x8(%ebp),%eax
  803154:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803157:	89 10                	mov    %edx,(%eax)
  803159:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80315c:	8b 40 04             	mov    0x4(%eax),%eax
  80315f:	85 c0                	test   %eax,%eax
  803161:	74 0d                	je     803170 <insert_sorted_with_merge_freeList+0x572>
  803163:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803166:	8b 40 04             	mov    0x4(%eax),%eax
  803169:	8b 55 08             	mov    0x8(%ebp),%edx
  80316c:	89 10                	mov    %edx,(%eax)
  80316e:	eb 08                	jmp    803178 <insert_sorted_with_merge_freeList+0x57a>
  803170:	8b 45 08             	mov    0x8(%ebp),%eax
  803173:	a3 38 51 80 00       	mov    %eax,0x805138
  803178:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80317b:	8b 55 08             	mov    0x8(%ebp),%edx
  80317e:	89 50 04             	mov    %edx,0x4(%eax)
  803181:	a1 44 51 80 00       	mov    0x805144,%eax
  803186:	40                   	inc    %eax
  803187:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  80318c:	8b 45 08             	mov    0x8(%ebp),%eax
  80318f:	8b 50 0c             	mov    0xc(%eax),%edx
  803192:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803195:	8b 40 0c             	mov    0xc(%eax),%eax
  803198:	01 c2                	add    %eax,%edx
  80319a:	8b 45 08             	mov    0x8(%ebp),%eax
  80319d:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8031a0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031a4:	75 17                	jne    8031bd <insert_sorted_with_merge_freeList+0x5bf>
  8031a6:	83 ec 04             	sub    $0x4,%esp
  8031a9:	68 e8 3f 80 00       	push   $0x803fe8
  8031ae:	68 6b 01 00 00       	push   $0x16b
  8031b3:	68 3f 3f 80 00       	push   $0x803f3f
  8031b8:	e8 ba d0 ff ff       	call   800277 <_panic>
  8031bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c0:	8b 00                	mov    (%eax),%eax
  8031c2:	85 c0                	test   %eax,%eax
  8031c4:	74 10                	je     8031d6 <insert_sorted_with_merge_freeList+0x5d8>
  8031c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c9:	8b 00                	mov    (%eax),%eax
  8031cb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031ce:	8b 52 04             	mov    0x4(%edx),%edx
  8031d1:	89 50 04             	mov    %edx,0x4(%eax)
  8031d4:	eb 0b                	jmp    8031e1 <insert_sorted_with_merge_freeList+0x5e3>
  8031d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d9:	8b 40 04             	mov    0x4(%eax),%eax
  8031dc:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e4:	8b 40 04             	mov    0x4(%eax),%eax
  8031e7:	85 c0                	test   %eax,%eax
  8031e9:	74 0f                	je     8031fa <insert_sorted_with_merge_freeList+0x5fc>
  8031eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ee:	8b 40 04             	mov    0x4(%eax),%eax
  8031f1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031f4:	8b 12                	mov    (%edx),%edx
  8031f6:	89 10                	mov    %edx,(%eax)
  8031f8:	eb 0a                	jmp    803204 <insert_sorted_with_merge_freeList+0x606>
  8031fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031fd:	8b 00                	mov    (%eax),%eax
  8031ff:	a3 38 51 80 00       	mov    %eax,0x805138
  803204:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803207:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80320d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803210:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803217:	a1 44 51 80 00       	mov    0x805144,%eax
  80321c:	48                   	dec    %eax
  80321d:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803222:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803225:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  80322c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80322f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803236:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80323a:	75 17                	jne    803253 <insert_sorted_with_merge_freeList+0x655>
  80323c:	83 ec 04             	sub    $0x4,%esp
  80323f:	68 1c 3f 80 00       	push   $0x803f1c
  803244:	68 6e 01 00 00       	push   $0x16e
  803249:	68 3f 3f 80 00       	push   $0x803f3f
  80324e:	e8 24 d0 ff ff       	call   800277 <_panic>
  803253:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803259:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80325c:	89 10                	mov    %edx,(%eax)
  80325e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803261:	8b 00                	mov    (%eax),%eax
  803263:	85 c0                	test   %eax,%eax
  803265:	74 0d                	je     803274 <insert_sorted_with_merge_freeList+0x676>
  803267:	a1 48 51 80 00       	mov    0x805148,%eax
  80326c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80326f:	89 50 04             	mov    %edx,0x4(%eax)
  803272:	eb 08                	jmp    80327c <insert_sorted_with_merge_freeList+0x67e>
  803274:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803277:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80327c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80327f:	a3 48 51 80 00       	mov    %eax,0x805148
  803284:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803287:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80328e:	a1 54 51 80 00       	mov    0x805154,%eax
  803293:	40                   	inc    %eax
  803294:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803299:	e9 a9 00 00 00       	jmp    803347 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  80329e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032a2:	74 06                	je     8032aa <insert_sorted_with_merge_freeList+0x6ac>
  8032a4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032a8:	75 17                	jne    8032c1 <insert_sorted_with_merge_freeList+0x6c3>
  8032aa:	83 ec 04             	sub    $0x4,%esp
  8032ad:	68 b4 3f 80 00       	push   $0x803fb4
  8032b2:	68 73 01 00 00       	push   $0x173
  8032b7:	68 3f 3f 80 00       	push   $0x803f3f
  8032bc:	e8 b6 cf ff ff       	call   800277 <_panic>
  8032c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c4:	8b 10                	mov    (%eax),%edx
  8032c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c9:	89 10                	mov    %edx,(%eax)
  8032cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ce:	8b 00                	mov    (%eax),%eax
  8032d0:	85 c0                	test   %eax,%eax
  8032d2:	74 0b                	je     8032df <insert_sorted_with_merge_freeList+0x6e1>
  8032d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d7:	8b 00                	mov    (%eax),%eax
  8032d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8032dc:	89 50 04             	mov    %edx,0x4(%eax)
  8032df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8032e5:	89 10                	mov    %edx,(%eax)
  8032e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032ed:	89 50 04             	mov    %edx,0x4(%eax)
  8032f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f3:	8b 00                	mov    (%eax),%eax
  8032f5:	85 c0                	test   %eax,%eax
  8032f7:	75 08                	jne    803301 <insert_sorted_with_merge_freeList+0x703>
  8032f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fc:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803301:	a1 44 51 80 00       	mov    0x805144,%eax
  803306:	40                   	inc    %eax
  803307:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  80330c:	eb 39                	jmp    803347 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80330e:	a1 40 51 80 00       	mov    0x805140,%eax
  803313:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803316:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80331a:	74 07                	je     803323 <insert_sorted_with_merge_freeList+0x725>
  80331c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80331f:	8b 00                	mov    (%eax),%eax
  803321:	eb 05                	jmp    803328 <insert_sorted_with_merge_freeList+0x72a>
  803323:	b8 00 00 00 00       	mov    $0x0,%eax
  803328:	a3 40 51 80 00       	mov    %eax,0x805140
  80332d:	a1 40 51 80 00       	mov    0x805140,%eax
  803332:	85 c0                	test   %eax,%eax
  803334:	0f 85 c7 fb ff ff    	jne    802f01 <insert_sorted_with_merge_freeList+0x303>
  80333a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80333e:	0f 85 bd fb ff ff    	jne    802f01 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803344:	eb 01                	jmp    803347 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803346:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803347:	90                   	nop
  803348:	c9                   	leave  
  803349:	c3                   	ret    

0080334a <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  80334a:	55                   	push   %ebp
  80334b:	89 e5                	mov    %esp,%ebp
  80334d:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803350:	8b 55 08             	mov    0x8(%ebp),%edx
  803353:	89 d0                	mov    %edx,%eax
  803355:	c1 e0 02             	shl    $0x2,%eax
  803358:	01 d0                	add    %edx,%eax
  80335a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803361:	01 d0                	add    %edx,%eax
  803363:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80336a:	01 d0                	add    %edx,%eax
  80336c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803373:	01 d0                	add    %edx,%eax
  803375:	c1 e0 04             	shl    $0x4,%eax
  803378:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  80337b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803382:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803385:	83 ec 0c             	sub    $0xc,%esp
  803388:	50                   	push   %eax
  803389:	e8 26 e7 ff ff       	call   801ab4 <sys_get_virtual_time>
  80338e:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803391:	eb 41                	jmp    8033d4 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803393:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803396:	83 ec 0c             	sub    $0xc,%esp
  803399:	50                   	push   %eax
  80339a:	e8 15 e7 ff ff       	call   801ab4 <sys_get_virtual_time>
  80339f:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8033a2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8033a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033a8:	29 c2                	sub    %eax,%edx
  8033aa:	89 d0                	mov    %edx,%eax
  8033ac:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8033af:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8033b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033b5:	89 d1                	mov    %edx,%ecx
  8033b7:	29 c1                	sub    %eax,%ecx
  8033b9:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8033bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033bf:	39 c2                	cmp    %eax,%edx
  8033c1:	0f 97 c0             	seta   %al
  8033c4:	0f b6 c0             	movzbl %al,%eax
  8033c7:	29 c1                	sub    %eax,%ecx
  8033c9:	89 c8                	mov    %ecx,%eax
  8033cb:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8033ce:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8033d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8033d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8033da:	72 b7                	jb     803393 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8033dc:	90                   	nop
  8033dd:	c9                   	leave  
  8033de:	c3                   	ret    

008033df <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8033df:	55                   	push   %ebp
  8033e0:	89 e5                	mov    %esp,%ebp
  8033e2:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8033e5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8033ec:	eb 03                	jmp    8033f1 <busy_wait+0x12>
  8033ee:	ff 45 fc             	incl   -0x4(%ebp)
  8033f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8033f4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8033f7:	72 f5                	jb     8033ee <busy_wait+0xf>
	return i;
  8033f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8033fc:	c9                   	leave  
  8033fd:	c3                   	ret    
  8033fe:	66 90                	xchg   %ax,%ax

00803400 <__udivdi3>:
  803400:	55                   	push   %ebp
  803401:	57                   	push   %edi
  803402:	56                   	push   %esi
  803403:	53                   	push   %ebx
  803404:	83 ec 1c             	sub    $0x1c,%esp
  803407:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80340b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80340f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803413:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803417:	89 ca                	mov    %ecx,%edx
  803419:	89 f8                	mov    %edi,%eax
  80341b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80341f:	85 f6                	test   %esi,%esi
  803421:	75 2d                	jne    803450 <__udivdi3+0x50>
  803423:	39 cf                	cmp    %ecx,%edi
  803425:	77 65                	ja     80348c <__udivdi3+0x8c>
  803427:	89 fd                	mov    %edi,%ebp
  803429:	85 ff                	test   %edi,%edi
  80342b:	75 0b                	jne    803438 <__udivdi3+0x38>
  80342d:	b8 01 00 00 00       	mov    $0x1,%eax
  803432:	31 d2                	xor    %edx,%edx
  803434:	f7 f7                	div    %edi
  803436:	89 c5                	mov    %eax,%ebp
  803438:	31 d2                	xor    %edx,%edx
  80343a:	89 c8                	mov    %ecx,%eax
  80343c:	f7 f5                	div    %ebp
  80343e:	89 c1                	mov    %eax,%ecx
  803440:	89 d8                	mov    %ebx,%eax
  803442:	f7 f5                	div    %ebp
  803444:	89 cf                	mov    %ecx,%edi
  803446:	89 fa                	mov    %edi,%edx
  803448:	83 c4 1c             	add    $0x1c,%esp
  80344b:	5b                   	pop    %ebx
  80344c:	5e                   	pop    %esi
  80344d:	5f                   	pop    %edi
  80344e:	5d                   	pop    %ebp
  80344f:	c3                   	ret    
  803450:	39 ce                	cmp    %ecx,%esi
  803452:	77 28                	ja     80347c <__udivdi3+0x7c>
  803454:	0f bd fe             	bsr    %esi,%edi
  803457:	83 f7 1f             	xor    $0x1f,%edi
  80345a:	75 40                	jne    80349c <__udivdi3+0x9c>
  80345c:	39 ce                	cmp    %ecx,%esi
  80345e:	72 0a                	jb     80346a <__udivdi3+0x6a>
  803460:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803464:	0f 87 9e 00 00 00    	ja     803508 <__udivdi3+0x108>
  80346a:	b8 01 00 00 00       	mov    $0x1,%eax
  80346f:	89 fa                	mov    %edi,%edx
  803471:	83 c4 1c             	add    $0x1c,%esp
  803474:	5b                   	pop    %ebx
  803475:	5e                   	pop    %esi
  803476:	5f                   	pop    %edi
  803477:	5d                   	pop    %ebp
  803478:	c3                   	ret    
  803479:	8d 76 00             	lea    0x0(%esi),%esi
  80347c:	31 ff                	xor    %edi,%edi
  80347e:	31 c0                	xor    %eax,%eax
  803480:	89 fa                	mov    %edi,%edx
  803482:	83 c4 1c             	add    $0x1c,%esp
  803485:	5b                   	pop    %ebx
  803486:	5e                   	pop    %esi
  803487:	5f                   	pop    %edi
  803488:	5d                   	pop    %ebp
  803489:	c3                   	ret    
  80348a:	66 90                	xchg   %ax,%ax
  80348c:	89 d8                	mov    %ebx,%eax
  80348e:	f7 f7                	div    %edi
  803490:	31 ff                	xor    %edi,%edi
  803492:	89 fa                	mov    %edi,%edx
  803494:	83 c4 1c             	add    $0x1c,%esp
  803497:	5b                   	pop    %ebx
  803498:	5e                   	pop    %esi
  803499:	5f                   	pop    %edi
  80349a:	5d                   	pop    %ebp
  80349b:	c3                   	ret    
  80349c:	bd 20 00 00 00       	mov    $0x20,%ebp
  8034a1:	89 eb                	mov    %ebp,%ebx
  8034a3:	29 fb                	sub    %edi,%ebx
  8034a5:	89 f9                	mov    %edi,%ecx
  8034a7:	d3 e6                	shl    %cl,%esi
  8034a9:	89 c5                	mov    %eax,%ebp
  8034ab:	88 d9                	mov    %bl,%cl
  8034ad:	d3 ed                	shr    %cl,%ebp
  8034af:	89 e9                	mov    %ebp,%ecx
  8034b1:	09 f1                	or     %esi,%ecx
  8034b3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8034b7:	89 f9                	mov    %edi,%ecx
  8034b9:	d3 e0                	shl    %cl,%eax
  8034bb:	89 c5                	mov    %eax,%ebp
  8034bd:	89 d6                	mov    %edx,%esi
  8034bf:	88 d9                	mov    %bl,%cl
  8034c1:	d3 ee                	shr    %cl,%esi
  8034c3:	89 f9                	mov    %edi,%ecx
  8034c5:	d3 e2                	shl    %cl,%edx
  8034c7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034cb:	88 d9                	mov    %bl,%cl
  8034cd:	d3 e8                	shr    %cl,%eax
  8034cf:	09 c2                	or     %eax,%edx
  8034d1:	89 d0                	mov    %edx,%eax
  8034d3:	89 f2                	mov    %esi,%edx
  8034d5:	f7 74 24 0c          	divl   0xc(%esp)
  8034d9:	89 d6                	mov    %edx,%esi
  8034db:	89 c3                	mov    %eax,%ebx
  8034dd:	f7 e5                	mul    %ebp
  8034df:	39 d6                	cmp    %edx,%esi
  8034e1:	72 19                	jb     8034fc <__udivdi3+0xfc>
  8034e3:	74 0b                	je     8034f0 <__udivdi3+0xf0>
  8034e5:	89 d8                	mov    %ebx,%eax
  8034e7:	31 ff                	xor    %edi,%edi
  8034e9:	e9 58 ff ff ff       	jmp    803446 <__udivdi3+0x46>
  8034ee:	66 90                	xchg   %ax,%ax
  8034f0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8034f4:	89 f9                	mov    %edi,%ecx
  8034f6:	d3 e2                	shl    %cl,%edx
  8034f8:	39 c2                	cmp    %eax,%edx
  8034fa:	73 e9                	jae    8034e5 <__udivdi3+0xe5>
  8034fc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8034ff:	31 ff                	xor    %edi,%edi
  803501:	e9 40 ff ff ff       	jmp    803446 <__udivdi3+0x46>
  803506:	66 90                	xchg   %ax,%ax
  803508:	31 c0                	xor    %eax,%eax
  80350a:	e9 37 ff ff ff       	jmp    803446 <__udivdi3+0x46>
  80350f:	90                   	nop

00803510 <__umoddi3>:
  803510:	55                   	push   %ebp
  803511:	57                   	push   %edi
  803512:	56                   	push   %esi
  803513:	53                   	push   %ebx
  803514:	83 ec 1c             	sub    $0x1c,%esp
  803517:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80351b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80351f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803523:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803527:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80352b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80352f:	89 f3                	mov    %esi,%ebx
  803531:	89 fa                	mov    %edi,%edx
  803533:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803537:	89 34 24             	mov    %esi,(%esp)
  80353a:	85 c0                	test   %eax,%eax
  80353c:	75 1a                	jne    803558 <__umoddi3+0x48>
  80353e:	39 f7                	cmp    %esi,%edi
  803540:	0f 86 a2 00 00 00    	jbe    8035e8 <__umoddi3+0xd8>
  803546:	89 c8                	mov    %ecx,%eax
  803548:	89 f2                	mov    %esi,%edx
  80354a:	f7 f7                	div    %edi
  80354c:	89 d0                	mov    %edx,%eax
  80354e:	31 d2                	xor    %edx,%edx
  803550:	83 c4 1c             	add    $0x1c,%esp
  803553:	5b                   	pop    %ebx
  803554:	5e                   	pop    %esi
  803555:	5f                   	pop    %edi
  803556:	5d                   	pop    %ebp
  803557:	c3                   	ret    
  803558:	39 f0                	cmp    %esi,%eax
  80355a:	0f 87 ac 00 00 00    	ja     80360c <__umoddi3+0xfc>
  803560:	0f bd e8             	bsr    %eax,%ebp
  803563:	83 f5 1f             	xor    $0x1f,%ebp
  803566:	0f 84 ac 00 00 00    	je     803618 <__umoddi3+0x108>
  80356c:	bf 20 00 00 00       	mov    $0x20,%edi
  803571:	29 ef                	sub    %ebp,%edi
  803573:	89 fe                	mov    %edi,%esi
  803575:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803579:	89 e9                	mov    %ebp,%ecx
  80357b:	d3 e0                	shl    %cl,%eax
  80357d:	89 d7                	mov    %edx,%edi
  80357f:	89 f1                	mov    %esi,%ecx
  803581:	d3 ef                	shr    %cl,%edi
  803583:	09 c7                	or     %eax,%edi
  803585:	89 e9                	mov    %ebp,%ecx
  803587:	d3 e2                	shl    %cl,%edx
  803589:	89 14 24             	mov    %edx,(%esp)
  80358c:	89 d8                	mov    %ebx,%eax
  80358e:	d3 e0                	shl    %cl,%eax
  803590:	89 c2                	mov    %eax,%edx
  803592:	8b 44 24 08          	mov    0x8(%esp),%eax
  803596:	d3 e0                	shl    %cl,%eax
  803598:	89 44 24 04          	mov    %eax,0x4(%esp)
  80359c:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035a0:	89 f1                	mov    %esi,%ecx
  8035a2:	d3 e8                	shr    %cl,%eax
  8035a4:	09 d0                	or     %edx,%eax
  8035a6:	d3 eb                	shr    %cl,%ebx
  8035a8:	89 da                	mov    %ebx,%edx
  8035aa:	f7 f7                	div    %edi
  8035ac:	89 d3                	mov    %edx,%ebx
  8035ae:	f7 24 24             	mull   (%esp)
  8035b1:	89 c6                	mov    %eax,%esi
  8035b3:	89 d1                	mov    %edx,%ecx
  8035b5:	39 d3                	cmp    %edx,%ebx
  8035b7:	0f 82 87 00 00 00    	jb     803644 <__umoddi3+0x134>
  8035bd:	0f 84 91 00 00 00    	je     803654 <__umoddi3+0x144>
  8035c3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8035c7:	29 f2                	sub    %esi,%edx
  8035c9:	19 cb                	sbb    %ecx,%ebx
  8035cb:	89 d8                	mov    %ebx,%eax
  8035cd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8035d1:	d3 e0                	shl    %cl,%eax
  8035d3:	89 e9                	mov    %ebp,%ecx
  8035d5:	d3 ea                	shr    %cl,%edx
  8035d7:	09 d0                	or     %edx,%eax
  8035d9:	89 e9                	mov    %ebp,%ecx
  8035db:	d3 eb                	shr    %cl,%ebx
  8035dd:	89 da                	mov    %ebx,%edx
  8035df:	83 c4 1c             	add    $0x1c,%esp
  8035e2:	5b                   	pop    %ebx
  8035e3:	5e                   	pop    %esi
  8035e4:	5f                   	pop    %edi
  8035e5:	5d                   	pop    %ebp
  8035e6:	c3                   	ret    
  8035e7:	90                   	nop
  8035e8:	89 fd                	mov    %edi,%ebp
  8035ea:	85 ff                	test   %edi,%edi
  8035ec:	75 0b                	jne    8035f9 <__umoddi3+0xe9>
  8035ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8035f3:	31 d2                	xor    %edx,%edx
  8035f5:	f7 f7                	div    %edi
  8035f7:	89 c5                	mov    %eax,%ebp
  8035f9:	89 f0                	mov    %esi,%eax
  8035fb:	31 d2                	xor    %edx,%edx
  8035fd:	f7 f5                	div    %ebp
  8035ff:	89 c8                	mov    %ecx,%eax
  803601:	f7 f5                	div    %ebp
  803603:	89 d0                	mov    %edx,%eax
  803605:	e9 44 ff ff ff       	jmp    80354e <__umoddi3+0x3e>
  80360a:	66 90                	xchg   %ax,%ax
  80360c:	89 c8                	mov    %ecx,%eax
  80360e:	89 f2                	mov    %esi,%edx
  803610:	83 c4 1c             	add    $0x1c,%esp
  803613:	5b                   	pop    %ebx
  803614:	5e                   	pop    %esi
  803615:	5f                   	pop    %edi
  803616:	5d                   	pop    %ebp
  803617:	c3                   	ret    
  803618:	3b 04 24             	cmp    (%esp),%eax
  80361b:	72 06                	jb     803623 <__umoddi3+0x113>
  80361d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803621:	77 0f                	ja     803632 <__umoddi3+0x122>
  803623:	89 f2                	mov    %esi,%edx
  803625:	29 f9                	sub    %edi,%ecx
  803627:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80362b:	89 14 24             	mov    %edx,(%esp)
  80362e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803632:	8b 44 24 04          	mov    0x4(%esp),%eax
  803636:	8b 14 24             	mov    (%esp),%edx
  803639:	83 c4 1c             	add    $0x1c,%esp
  80363c:	5b                   	pop    %ebx
  80363d:	5e                   	pop    %esi
  80363e:	5f                   	pop    %edi
  80363f:	5d                   	pop    %ebp
  803640:	c3                   	ret    
  803641:	8d 76 00             	lea    0x0(%esi),%esi
  803644:	2b 04 24             	sub    (%esp),%eax
  803647:	19 fa                	sbb    %edi,%edx
  803649:	89 d1                	mov    %edx,%ecx
  80364b:	89 c6                	mov    %eax,%esi
  80364d:	e9 71 ff ff ff       	jmp    8035c3 <__umoddi3+0xb3>
  803652:	66 90                	xchg   %ax,%ax
  803654:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803658:	72 ea                	jb     803644 <__umoddi3+0x134>
  80365a:	89 d9                	mov    %ebx,%ecx
  80365c:	e9 62 ff ff ff       	jmp    8035c3 <__umoddi3+0xb3>
