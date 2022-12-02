
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
  80008c:	68 c0 35 80 00       	push   $0x8035c0
  800091:	6a 12                	push   $0x12
  800093:	68 dc 35 80 00       	push   $0x8035dc
  800098:	e8 da 01 00 00       	call   800277 <_panic>
	}
	uint32 *x;
	x = sget(sys_getparentenvid(),"x");
  80009d:	e8 2a 19 00 00       	call   8019cc <sys_getparentenvid>
  8000a2:	83 ec 08             	sub    $0x8,%esp
  8000a5:	68 fc 35 80 00       	push   $0x8035fc
  8000aa:	50                   	push   %eax
  8000ab:	e8 7f 14 00 00       	call   80152f <sget>
  8000b0:	83 c4 10             	add    $0x10,%esp
  8000b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("Slave B1 env used x (getSharedObject)\n");
  8000b6:	83 ec 0c             	sub    $0xc,%esp
  8000b9:	68 00 36 80 00       	push   $0x803600
  8000be:	e8 68 04 00 00       	call   80052b <cprintf>
  8000c3:	83 c4 10             	add    $0x10,%esp

	cprintf("Slave B1 please be patient ...\n");
  8000c6:	83 ec 0c             	sub    $0xc,%esp
  8000c9:	68 28 36 80 00       	push   $0x803628
  8000ce:	e8 58 04 00 00       	call   80052b <cprintf>
  8000d3:	83 c4 10             	add    $0x10,%esp

	env_sleep(6000);
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	68 70 17 00 00       	push   $0x1770
  8000de:	e8 b2 31 00 00       	call   803295 <env_sleep>
  8000e3:	83 c4 10             	add    $0x10,%esp
	int freeFrames = sys_calculate_free_frames() ;
  8000e6:	e8 e8 15 00 00       	call   8016d3 <sys_calculate_free_frames>
  8000eb:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sfree(x);
  8000ee:	83 ec 0c             	sub    $0xc,%esp
  8000f1:	ff 75 ec             	pushl  -0x14(%ebp)
  8000f4:	e8 7a 14 00 00       	call   801573 <sfree>
  8000f9:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave B1 env removed x\n");
  8000fc:	83 ec 0c             	sub    $0xc,%esp
  8000ff:	68 48 36 80 00       	push   $0x803648
  800104:	e8 22 04 00 00       	call   80052b <cprintf>
  800109:	83 c4 10             	add    $0x10,%esp

	if ((sys_calculate_free_frames() - freeFrames) !=  4) panic("B1 wrong free: frames removed not equal 4 !, correct frames to be removed are 4:\nfrom the env: 1 table and 1 for frame of x\nframes_storage of x: should be cleared now\n");
  80010c:	e8 c2 15 00 00       	call   8016d3 <sys_calculate_free_frames>
  800111:	89 c2                	mov    %eax,%edx
  800113:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800116:	29 c2                	sub    %eax,%edx
  800118:	89 d0                	mov    %edx,%eax
  80011a:	83 f8 04             	cmp    $0x4,%eax
  80011d:	74 14                	je     800133 <_main+0xfb>
  80011f:	83 ec 04             	sub    $0x4,%esp
  800122:	68 60 36 80 00       	push   $0x803660
  800127:	6a 20                	push   $0x20
  800129:	68 dc 35 80 00       	push   $0x8035dc
  80012e:	e8 44 01 00 00       	call   800277 <_panic>

	//To indicate that it's completed successfully
	inctst();
  800133:	e8 b9 19 00 00       	call   801af1 <inctst>
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
  800141:	e8 6d 18 00 00       	call   8019b3 <sys_getenvindex>
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
  8001ac:	e8 0f 16 00 00       	call   8017c0 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001b1:	83 ec 0c             	sub    $0xc,%esp
  8001b4:	68 20 37 80 00       	push   $0x803720
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
  8001dc:	68 48 37 80 00       	push   $0x803748
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
  80020d:	68 70 37 80 00       	push   $0x803770
  800212:	e8 14 03 00 00       	call   80052b <cprintf>
  800217:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80021a:	a1 20 40 80 00       	mov    0x804020,%eax
  80021f:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800225:	83 ec 08             	sub    $0x8,%esp
  800228:	50                   	push   %eax
  800229:	68 c8 37 80 00       	push   $0x8037c8
  80022e:	e8 f8 02 00 00       	call   80052b <cprintf>
  800233:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800236:	83 ec 0c             	sub    $0xc,%esp
  800239:	68 20 37 80 00       	push   $0x803720
  80023e:	e8 e8 02 00 00       	call   80052b <cprintf>
  800243:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800246:	e8 8f 15 00 00       	call   8017da <sys_enable_interrupt>

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
  80025e:	e8 1c 17 00 00       	call   80197f <sys_destroy_env>
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
  80026f:	e8 71 17 00 00       	call   8019e5 <sys_exit_env>
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
  800298:	68 dc 37 80 00       	push   $0x8037dc
  80029d:	e8 89 02 00 00       	call   80052b <cprintf>
  8002a2:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002a5:	a1 00 40 80 00       	mov    0x804000,%eax
  8002aa:	ff 75 0c             	pushl  0xc(%ebp)
  8002ad:	ff 75 08             	pushl  0x8(%ebp)
  8002b0:	50                   	push   %eax
  8002b1:	68 e1 37 80 00       	push   $0x8037e1
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
  8002d5:	68 fd 37 80 00       	push   $0x8037fd
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
  800301:	68 00 38 80 00       	push   $0x803800
  800306:	6a 26                	push   $0x26
  800308:	68 4c 38 80 00       	push   $0x80384c
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
  8003d3:	68 58 38 80 00       	push   $0x803858
  8003d8:	6a 3a                	push   $0x3a
  8003da:	68 4c 38 80 00       	push   $0x80384c
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
  800443:	68 ac 38 80 00       	push   $0x8038ac
  800448:	6a 44                	push   $0x44
  80044a:	68 4c 38 80 00       	push   $0x80384c
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
  80049d:	e8 70 11 00 00       	call   801612 <sys_cputs>
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
  800514:	e8 f9 10 00 00       	call   801612 <sys_cputs>
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
  80055e:	e8 5d 12 00 00       	call   8017c0 <sys_disable_interrupt>
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
  80057e:	e8 57 12 00 00       	call   8017da <sys_enable_interrupt>
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
  8005c8:	e8 7f 2d 00 00       	call   80334c <__udivdi3>
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
  800618:	e8 3f 2e 00 00       	call   80345c <__umoddi3>
  80061d:	83 c4 10             	add    $0x10,%esp
  800620:	05 14 3b 80 00       	add    $0x803b14,%eax
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
  800773:	8b 04 85 38 3b 80 00 	mov    0x803b38(,%eax,4),%eax
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
  800854:	8b 34 9d 80 39 80 00 	mov    0x803980(,%ebx,4),%esi
  80085b:	85 f6                	test   %esi,%esi
  80085d:	75 19                	jne    800878 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80085f:	53                   	push   %ebx
  800860:	68 25 3b 80 00       	push   $0x803b25
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
  800879:	68 2e 3b 80 00       	push   $0x803b2e
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
  8008a6:	be 31 3b 80 00       	mov    $0x803b31,%esi
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
  8012cc:	68 90 3c 80 00       	push   $0x803c90
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
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_PRESENT);
  80137f:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801386:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801389:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80138e:	2d 00 10 00 00       	sub    $0x1000,%eax
  801393:	83 ec 04             	sub    $0x4,%esp
  801396:	6a 03                	push   $0x3
  801398:	ff 75 f4             	pushl  -0xc(%ebp)
  80139b:	50                   	push   %eax
  80139c:	e8 b5 03 00 00       	call   801756 <sys_allocate_chunk>
  8013a1:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013a4:	a1 20 41 80 00       	mov    0x804120,%eax
  8013a9:	83 ec 0c             	sub    $0xc,%esp
  8013ac:	50                   	push   %eax
  8013ad:	e8 2a 0a 00 00       	call   801ddc <initialize_MemBlocksList>
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
  8013da:	68 b5 3c 80 00       	push   $0x803cb5
  8013df:	6a 33                	push   $0x33
  8013e1:	68 d3 3c 80 00       	push   $0x803cd3
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
  801459:	68 e0 3c 80 00       	push   $0x803ce0
  80145e:	6a 34                	push   $0x34
  801460:	68 d3 3c 80 00       	push   $0x803cd3
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
  8014ce:	68 04 3d 80 00       	push   $0x803d04
  8014d3:	6a 46                	push   $0x46
  8014d5:	68 d3 3c 80 00       	push   $0x803cd3
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
  8014ea:	68 2c 3d 80 00       	push   $0x803d2c
  8014ef:	6a 61                	push   $0x61
  8014f1:	68 d3 3c 80 00       	push   $0x803cd3
  8014f6:	e8 7c ed ff ff       	call   800277 <_panic>

008014fb <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8014fb:	55                   	push   %ebp
  8014fc:	89 e5                	mov    %esp,%ebp
  8014fe:	83 ec 18             	sub    $0x18,%esp
  801501:	8b 45 10             	mov    0x10(%ebp),%eax
  801504:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801507:	e8 a9 fd ff ff       	call   8012b5 <InitializeUHeap>
	if (size == 0) return NULL ;
  80150c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801510:	75 07                	jne    801519 <smalloc+0x1e>
  801512:	b8 00 00 00 00       	mov    $0x0,%eax
  801517:	eb 14                	jmp    80152d <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801519:	83 ec 04             	sub    $0x4,%esp
  80151c:	68 50 3d 80 00       	push   $0x803d50
  801521:	6a 76                	push   $0x76
  801523:	68 d3 3c 80 00       	push   $0x803cd3
  801528:	e8 4a ed ff ff       	call   800277 <_panic>

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80152d:	c9                   	leave  
  80152e:	c3                   	ret    

0080152f <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80152f:	55                   	push   %ebp
  801530:	89 e5                	mov    %esp,%ebp
  801532:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801535:	e8 7b fd ff ff       	call   8012b5 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  80153a:	83 ec 04             	sub    $0x4,%esp
  80153d:	68 78 3d 80 00       	push   $0x803d78
  801542:	68 93 00 00 00       	push   $0x93
  801547:	68 d3 3c 80 00       	push   $0x803cd3
  80154c:	e8 26 ed ff ff       	call   800277 <_panic>

00801551 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801551:	55                   	push   %ebp
  801552:	89 e5                	mov    %esp,%ebp
  801554:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801557:	e8 59 fd ff ff       	call   8012b5 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80155c:	83 ec 04             	sub    $0x4,%esp
  80155f:	68 9c 3d 80 00       	push   $0x803d9c
  801564:	68 c5 00 00 00       	push   $0xc5
  801569:	68 d3 3c 80 00       	push   $0x803cd3
  80156e:	e8 04 ed ff ff       	call   800277 <_panic>

00801573 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801573:	55                   	push   %ebp
  801574:	89 e5                	mov    %esp,%ebp
  801576:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801579:	83 ec 04             	sub    $0x4,%esp
  80157c:	68 c4 3d 80 00       	push   $0x803dc4
  801581:	68 d9 00 00 00       	push   $0xd9
  801586:	68 d3 3c 80 00       	push   $0x803cd3
  80158b:	e8 e7 ec ff ff       	call   800277 <_panic>

00801590 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801590:	55                   	push   %ebp
  801591:	89 e5                	mov    %esp,%ebp
  801593:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801596:	83 ec 04             	sub    $0x4,%esp
  801599:	68 e8 3d 80 00       	push   $0x803de8
  80159e:	68 e4 00 00 00       	push   $0xe4
  8015a3:	68 d3 3c 80 00       	push   $0x803cd3
  8015a8:	e8 ca ec ff ff       	call   800277 <_panic>

008015ad <shrink>:

}
void shrink(uint32 newSize)
{
  8015ad:	55                   	push   %ebp
  8015ae:	89 e5                	mov    %esp,%ebp
  8015b0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015b3:	83 ec 04             	sub    $0x4,%esp
  8015b6:	68 e8 3d 80 00       	push   $0x803de8
  8015bb:	68 e9 00 00 00       	push   $0xe9
  8015c0:	68 d3 3c 80 00       	push   $0x803cd3
  8015c5:	e8 ad ec ff ff       	call   800277 <_panic>

008015ca <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8015ca:	55                   	push   %ebp
  8015cb:	89 e5                	mov    %esp,%ebp
  8015cd:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015d0:	83 ec 04             	sub    $0x4,%esp
  8015d3:	68 e8 3d 80 00       	push   $0x803de8
  8015d8:	68 ee 00 00 00       	push   $0xee
  8015dd:	68 d3 3c 80 00       	push   $0x803cd3
  8015e2:	e8 90 ec ff ff       	call   800277 <_panic>

008015e7 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8015e7:	55                   	push   %ebp
  8015e8:	89 e5                	mov    %esp,%ebp
  8015ea:	57                   	push   %edi
  8015eb:	56                   	push   %esi
  8015ec:	53                   	push   %ebx
  8015ed:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015f6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015f9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8015fc:	8b 7d 18             	mov    0x18(%ebp),%edi
  8015ff:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801602:	cd 30                	int    $0x30
  801604:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801607:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80160a:	83 c4 10             	add    $0x10,%esp
  80160d:	5b                   	pop    %ebx
  80160e:	5e                   	pop    %esi
  80160f:	5f                   	pop    %edi
  801610:	5d                   	pop    %ebp
  801611:	c3                   	ret    

00801612 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801612:	55                   	push   %ebp
  801613:	89 e5                	mov    %esp,%ebp
  801615:	83 ec 04             	sub    $0x4,%esp
  801618:	8b 45 10             	mov    0x10(%ebp),%eax
  80161b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80161e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801622:	8b 45 08             	mov    0x8(%ebp),%eax
  801625:	6a 00                	push   $0x0
  801627:	6a 00                	push   $0x0
  801629:	52                   	push   %edx
  80162a:	ff 75 0c             	pushl  0xc(%ebp)
  80162d:	50                   	push   %eax
  80162e:	6a 00                	push   $0x0
  801630:	e8 b2 ff ff ff       	call   8015e7 <syscall>
  801635:	83 c4 18             	add    $0x18,%esp
}
  801638:	90                   	nop
  801639:	c9                   	leave  
  80163a:	c3                   	ret    

0080163b <sys_cgetc>:

int
sys_cgetc(void)
{
  80163b:	55                   	push   %ebp
  80163c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80163e:	6a 00                	push   $0x0
  801640:	6a 00                	push   $0x0
  801642:	6a 00                	push   $0x0
  801644:	6a 00                	push   $0x0
  801646:	6a 00                	push   $0x0
  801648:	6a 01                	push   $0x1
  80164a:	e8 98 ff ff ff       	call   8015e7 <syscall>
  80164f:	83 c4 18             	add    $0x18,%esp
}
  801652:	c9                   	leave  
  801653:	c3                   	ret    

00801654 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801654:	55                   	push   %ebp
  801655:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801657:	8b 55 0c             	mov    0xc(%ebp),%edx
  80165a:	8b 45 08             	mov    0x8(%ebp),%eax
  80165d:	6a 00                	push   $0x0
  80165f:	6a 00                	push   $0x0
  801661:	6a 00                	push   $0x0
  801663:	52                   	push   %edx
  801664:	50                   	push   %eax
  801665:	6a 05                	push   $0x5
  801667:	e8 7b ff ff ff       	call   8015e7 <syscall>
  80166c:	83 c4 18             	add    $0x18,%esp
}
  80166f:	c9                   	leave  
  801670:	c3                   	ret    

00801671 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801671:	55                   	push   %ebp
  801672:	89 e5                	mov    %esp,%ebp
  801674:	56                   	push   %esi
  801675:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801676:	8b 75 18             	mov    0x18(%ebp),%esi
  801679:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80167c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80167f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801682:	8b 45 08             	mov    0x8(%ebp),%eax
  801685:	56                   	push   %esi
  801686:	53                   	push   %ebx
  801687:	51                   	push   %ecx
  801688:	52                   	push   %edx
  801689:	50                   	push   %eax
  80168a:	6a 06                	push   $0x6
  80168c:	e8 56 ff ff ff       	call   8015e7 <syscall>
  801691:	83 c4 18             	add    $0x18,%esp
}
  801694:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801697:	5b                   	pop    %ebx
  801698:	5e                   	pop    %esi
  801699:	5d                   	pop    %ebp
  80169a:	c3                   	ret    

0080169b <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80169b:	55                   	push   %ebp
  80169c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80169e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a4:	6a 00                	push   $0x0
  8016a6:	6a 00                	push   $0x0
  8016a8:	6a 00                	push   $0x0
  8016aa:	52                   	push   %edx
  8016ab:	50                   	push   %eax
  8016ac:	6a 07                	push   $0x7
  8016ae:	e8 34 ff ff ff       	call   8015e7 <syscall>
  8016b3:	83 c4 18             	add    $0x18,%esp
}
  8016b6:	c9                   	leave  
  8016b7:	c3                   	ret    

008016b8 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8016b8:	55                   	push   %ebp
  8016b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8016bb:	6a 00                	push   $0x0
  8016bd:	6a 00                	push   $0x0
  8016bf:	6a 00                	push   $0x0
  8016c1:	ff 75 0c             	pushl  0xc(%ebp)
  8016c4:	ff 75 08             	pushl  0x8(%ebp)
  8016c7:	6a 08                	push   $0x8
  8016c9:	e8 19 ff ff ff       	call   8015e7 <syscall>
  8016ce:	83 c4 18             	add    $0x18,%esp
}
  8016d1:	c9                   	leave  
  8016d2:	c3                   	ret    

008016d3 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8016d3:	55                   	push   %ebp
  8016d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8016d6:	6a 00                	push   $0x0
  8016d8:	6a 00                	push   $0x0
  8016da:	6a 00                	push   $0x0
  8016dc:	6a 00                	push   $0x0
  8016de:	6a 00                	push   $0x0
  8016e0:	6a 09                	push   $0x9
  8016e2:	e8 00 ff ff ff       	call   8015e7 <syscall>
  8016e7:	83 c4 18             	add    $0x18,%esp
}
  8016ea:	c9                   	leave  
  8016eb:	c3                   	ret    

008016ec <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8016ec:	55                   	push   %ebp
  8016ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8016ef:	6a 00                	push   $0x0
  8016f1:	6a 00                	push   $0x0
  8016f3:	6a 00                	push   $0x0
  8016f5:	6a 00                	push   $0x0
  8016f7:	6a 00                	push   $0x0
  8016f9:	6a 0a                	push   $0xa
  8016fb:	e8 e7 fe ff ff       	call   8015e7 <syscall>
  801700:	83 c4 18             	add    $0x18,%esp
}
  801703:	c9                   	leave  
  801704:	c3                   	ret    

00801705 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801705:	55                   	push   %ebp
  801706:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801708:	6a 00                	push   $0x0
  80170a:	6a 00                	push   $0x0
  80170c:	6a 00                	push   $0x0
  80170e:	6a 00                	push   $0x0
  801710:	6a 00                	push   $0x0
  801712:	6a 0b                	push   $0xb
  801714:	e8 ce fe ff ff       	call   8015e7 <syscall>
  801719:	83 c4 18             	add    $0x18,%esp
}
  80171c:	c9                   	leave  
  80171d:	c3                   	ret    

0080171e <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80171e:	55                   	push   %ebp
  80171f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801721:	6a 00                	push   $0x0
  801723:	6a 00                	push   $0x0
  801725:	6a 00                	push   $0x0
  801727:	ff 75 0c             	pushl  0xc(%ebp)
  80172a:	ff 75 08             	pushl  0x8(%ebp)
  80172d:	6a 0f                	push   $0xf
  80172f:	e8 b3 fe ff ff       	call   8015e7 <syscall>
  801734:	83 c4 18             	add    $0x18,%esp
	return;
  801737:	90                   	nop
}
  801738:	c9                   	leave  
  801739:	c3                   	ret    

0080173a <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80173a:	55                   	push   %ebp
  80173b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80173d:	6a 00                	push   $0x0
  80173f:	6a 00                	push   $0x0
  801741:	6a 00                	push   $0x0
  801743:	ff 75 0c             	pushl  0xc(%ebp)
  801746:	ff 75 08             	pushl  0x8(%ebp)
  801749:	6a 10                	push   $0x10
  80174b:	e8 97 fe ff ff       	call   8015e7 <syscall>
  801750:	83 c4 18             	add    $0x18,%esp
	return ;
  801753:	90                   	nop
}
  801754:	c9                   	leave  
  801755:	c3                   	ret    

00801756 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801756:	55                   	push   %ebp
  801757:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801759:	6a 00                	push   $0x0
  80175b:	6a 00                	push   $0x0
  80175d:	ff 75 10             	pushl  0x10(%ebp)
  801760:	ff 75 0c             	pushl  0xc(%ebp)
  801763:	ff 75 08             	pushl  0x8(%ebp)
  801766:	6a 11                	push   $0x11
  801768:	e8 7a fe ff ff       	call   8015e7 <syscall>
  80176d:	83 c4 18             	add    $0x18,%esp
	return ;
  801770:	90                   	nop
}
  801771:	c9                   	leave  
  801772:	c3                   	ret    

00801773 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801773:	55                   	push   %ebp
  801774:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801776:	6a 00                	push   $0x0
  801778:	6a 00                	push   $0x0
  80177a:	6a 00                	push   $0x0
  80177c:	6a 00                	push   $0x0
  80177e:	6a 00                	push   $0x0
  801780:	6a 0c                	push   $0xc
  801782:	e8 60 fe ff ff       	call   8015e7 <syscall>
  801787:	83 c4 18             	add    $0x18,%esp
}
  80178a:	c9                   	leave  
  80178b:	c3                   	ret    

0080178c <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80178c:	55                   	push   %ebp
  80178d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80178f:	6a 00                	push   $0x0
  801791:	6a 00                	push   $0x0
  801793:	6a 00                	push   $0x0
  801795:	6a 00                	push   $0x0
  801797:	ff 75 08             	pushl  0x8(%ebp)
  80179a:	6a 0d                	push   $0xd
  80179c:	e8 46 fe ff ff       	call   8015e7 <syscall>
  8017a1:	83 c4 18             	add    $0x18,%esp
}
  8017a4:	c9                   	leave  
  8017a5:	c3                   	ret    

008017a6 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8017a6:	55                   	push   %ebp
  8017a7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8017a9:	6a 00                	push   $0x0
  8017ab:	6a 00                	push   $0x0
  8017ad:	6a 00                	push   $0x0
  8017af:	6a 00                	push   $0x0
  8017b1:	6a 00                	push   $0x0
  8017b3:	6a 0e                	push   $0xe
  8017b5:	e8 2d fe ff ff       	call   8015e7 <syscall>
  8017ba:	83 c4 18             	add    $0x18,%esp
}
  8017bd:	90                   	nop
  8017be:	c9                   	leave  
  8017bf:	c3                   	ret    

008017c0 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8017c0:	55                   	push   %ebp
  8017c1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8017c3:	6a 00                	push   $0x0
  8017c5:	6a 00                	push   $0x0
  8017c7:	6a 00                	push   $0x0
  8017c9:	6a 00                	push   $0x0
  8017cb:	6a 00                	push   $0x0
  8017cd:	6a 13                	push   $0x13
  8017cf:	e8 13 fe ff ff       	call   8015e7 <syscall>
  8017d4:	83 c4 18             	add    $0x18,%esp
}
  8017d7:	90                   	nop
  8017d8:	c9                   	leave  
  8017d9:	c3                   	ret    

008017da <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8017da:	55                   	push   %ebp
  8017db:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8017dd:	6a 00                	push   $0x0
  8017df:	6a 00                	push   $0x0
  8017e1:	6a 00                	push   $0x0
  8017e3:	6a 00                	push   $0x0
  8017e5:	6a 00                	push   $0x0
  8017e7:	6a 14                	push   $0x14
  8017e9:	e8 f9 fd ff ff       	call   8015e7 <syscall>
  8017ee:	83 c4 18             	add    $0x18,%esp
}
  8017f1:	90                   	nop
  8017f2:	c9                   	leave  
  8017f3:	c3                   	ret    

008017f4 <sys_cputc>:


void
sys_cputc(const char c)
{
  8017f4:	55                   	push   %ebp
  8017f5:	89 e5                	mov    %esp,%ebp
  8017f7:	83 ec 04             	sub    $0x4,%esp
  8017fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801800:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801804:	6a 00                	push   $0x0
  801806:	6a 00                	push   $0x0
  801808:	6a 00                	push   $0x0
  80180a:	6a 00                	push   $0x0
  80180c:	50                   	push   %eax
  80180d:	6a 15                	push   $0x15
  80180f:	e8 d3 fd ff ff       	call   8015e7 <syscall>
  801814:	83 c4 18             	add    $0x18,%esp
}
  801817:	90                   	nop
  801818:	c9                   	leave  
  801819:	c3                   	ret    

0080181a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80181a:	55                   	push   %ebp
  80181b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80181d:	6a 00                	push   $0x0
  80181f:	6a 00                	push   $0x0
  801821:	6a 00                	push   $0x0
  801823:	6a 00                	push   $0x0
  801825:	6a 00                	push   $0x0
  801827:	6a 16                	push   $0x16
  801829:	e8 b9 fd ff ff       	call   8015e7 <syscall>
  80182e:	83 c4 18             	add    $0x18,%esp
}
  801831:	90                   	nop
  801832:	c9                   	leave  
  801833:	c3                   	ret    

00801834 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801834:	55                   	push   %ebp
  801835:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801837:	8b 45 08             	mov    0x8(%ebp),%eax
  80183a:	6a 00                	push   $0x0
  80183c:	6a 00                	push   $0x0
  80183e:	6a 00                	push   $0x0
  801840:	ff 75 0c             	pushl  0xc(%ebp)
  801843:	50                   	push   %eax
  801844:	6a 17                	push   $0x17
  801846:	e8 9c fd ff ff       	call   8015e7 <syscall>
  80184b:	83 c4 18             	add    $0x18,%esp
}
  80184e:	c9                   	leave  
  80184f:	c3                   	ret    

00801850 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801850:	55                   	push   %ebp
  801851:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801853:	8b 55 0c             	mov    0xc(%ebp),%edx
  801856:	8b 45 08             	mov    0x8(%ebp),%eax
  801859:	6a 00                	push   $0x0
  80185b:	6a 00                	push   $0x0
  80185d:	6a 00                	push   $0x0
  80185f:	52                   	push   %edx
  801860:	50                   	push   %eax
  801861:	6a 1a                	push   $0x1a
  801863:	e8 7f fd ff ff       	call   8015e7 <syscall>
  801868:	83 c4 18             	add    $0x18,%esp
}
  80186b:	c9                   	leave  
  80186c:	c3                   	ret    

0080186d <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80186d:	55                   	push   %ebp
  80186e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801870:	8b 55 0c             	mov    0xc(%ebp),%edx
  801873:	8b 45 08             	mov    0x8(%ebp),%eax
  801876:	6a 00                	push   $0x0
  801878:	6a 00                	push   $0x0
  80187a:	6a 00                	push   $0x0
  80187c:	52                   	push   %edx
  80187d:	50                   	push   %eax
  80187e:	6a 18                	push   $0x18
  801880:	e8 62 fd ff ff       	call   8015e7 <syscall>
  801885:	83 c4 18             	add    $0x18,%esp
}
  801888:	90                   	nop
  801889:	c9                   	leave  
  80188a:	c3                   	ret    

0080188b <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80188b:	55                   	push   %ebp
  80188c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80188e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801891:	8b 45 08             	mov    0x8(%ebp),%eax
  801894:	6a 00                	push   $0x0
  801896:	6a 00                	push   $0x0
  801898:	6a 00                	push   $0x0
  80189a:	52                   	push   %edx
  80189b:	50                   	push   %eax
  80189c:	6a 19                	push   $0x19
  80189e:	e8 44 fd ff ff       	call   8015e7 <syscall>
  8018a3:	83 c4 18             	add    $0x18,%esp
}
  8018a6:	90                   	nop
  8018a7:	c9                   	leave  
  8018a8:	c3                   	ret    

008018a9 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8018a9:	55                   	push   %ebp
  8018aa:	89 e5                	mov    %esp,%ebp
  8018ac:	83 ec 04             	sub    $0x4,%esp
  8018af:	8b 45 10             	mov    0x10(%ebp),%eax
  8018b2:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8018b5:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8018b8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bf:	6a 00                	push   $0x0
  8018c1:	51                   	push   %ecx
  8018c2:	52                   	push   %edx
  8018c3:	ff 75 0c             	pushl  0xc(%ebp)
  8018c6:	50                   	push   %eax
  8018c7:	6a 1b                	push   $0x1b
  8018c9:	e8 19 fd ff ff       	call   8015e7 <syscall>
  8018ce:	83 c4 18             	add    $0x18,%esp
}
  8018d1:	c9                   	leave  
  8018d2:	c3                   	ret    

008018d3 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8018d3:	55                   	push   %ebp
  8018d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8018d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018dc:	6a 00                	push   $0x0
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	52                   	push   %edx
  8018e3:	50                   	push   %eax
  8018e4:	6a 1c                	push   $0x1c
  8018e6:	e8 fc fc ff ff       	call   8015e7 <syscall>
  8018eb:	83 c4 18             	add    $0x18,%esp
}
  8018ee:	c9                   	leave  
  8018ef:	c3                   	ret    

008018f0 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8018f0:	55                   	push   %ebp
  8018f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8018f3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 00                	push   $0x0
  801900:	51                   	push   %ecx
  801901:	52                   	push   %edx
  801902:	50                   	push   %eax
  801903:	6a 1d                	push   $0x1d
  801905:	e8 dd fc ff ff       	call   8015e7 <syscall>
  80190a:	83 c4 18             	add    $0x18,%esp
}
  80190d:	c9                   	leave  
  80190e:	c3                   	ret    

0080190f <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80190f:	55                   	push   %ebp
  801910:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801912:	8b 55 0c             	mov    0xc(%ebp),%edx
  801915:	8b 45 08             	mov    0x8(%ebp),%eax
  801918:	6a 00                	push   $0x0
  80191a:	6a 00                	push   $0x0
  80191c:	6a 00                	push   $0x0
  80191e:	52                   	push   %edx
  80191f:	50                   	push   %eax
  801920:	6a 1e                	push   $0x1e
  801922:	e8 c0 fc ff ff       	call   8015e7 <syscall>
  801927:	83 c4 18             	add    $0x18,%esp
}
  80192a:	c9                   	leave  
  80192b:	c3                   	ret    

0080192c <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80192c:	55                   	push   %ebp
  80192d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80192f:	6a 00                	push   $0x0
  801931:	6a 00                	push   $0x0
  801933:	6a 00                	push   $0x0
  801935:	6a 00                	push   $0x0
  801937:	6a 00                	push   $0x0
  801939:	6a 1f                	push   $0x1f
  80193b:	e8 a7 fc ff ff       	call   8015e7 <syscall>
  801940:	83 c4 18             	add    $0x18,%esp
}
  801943:	c9                   	leave  
  801944:	c3                   	ret    

00801945 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801945:	55                   	push   %ebp
  801946:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801948:	8b 45 08             	mov    0x8(%ebp),%eax
  80194b:	6a 00                	push   $0x0
  80194d:	ff 75 14             	pushl  0x14(%ebp)
  801950:	ff 75 10             	pushl  0x10(%ebp)
  801953:	ff 75 0c             	pushl  0xc(%ebp)
  801956:	50                   	push   %eax
  801957:	6a 20                	push   $0x20
  801959:	e8 89 fc ff ff       	call   8015e7 <syscall>
  80195e:	83 c4 18             	add    $0x18,%esp
}
  801961:	c9                   	leave  
  801962:	c3                   	ret    

00801963 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801963:	55                   	push   %ebp
  801964:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801966:	8b 45 08             	mov    0x8(%ebp),%eax
  801969:	6a 00                	push   $0x0
  80196b:	6a 00                	push   $0x0
  80196d:	6a 00                	push   $0x0
  80196f:	6a 00                	push   $0x0
  801971:	50                   	push   %eax
  801972:	6a 21                	push   $0x21
  801974:	e8 6e fc ff ff       	call   8015e7 <syscall>
  801979:	83 c4 18             	add    $0x18,%esp
}
  80197c:	90                   	nop
  80197d:	c9                   	leave  
  80197e:	c3                   	ret    

0080197f <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80197f:	55                   	push   %ebp
  801980:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801982:	8b 45 08             	mov    0x8(%ebp),%eax
  801985:	6a 00                	push   $0x0
  801987:	6a 00                	push   $0x0
  801989:	6a 00                	push   $0x0
  80198b:	6a 00                	push   $0x0
  80198d:	50                   	push   %eax
  80198e:	6a 22                	push   $0x22
  801990:	e8 52 fc ff ff       	call   8015e7 <syscall>
  801995:	83 c4 18             	add    $0x18,%esp
}
  801998:	c9                   	leave  
  801999:	c3                   	ret    

0080199a <sys_getenvid>:

int32 sys_getenvid(void)
{
  80199a:	55                   	push   %ebp
  80199b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 02                	push   $0x2
  8019a9:	e8 39 fc ff ff       	call   8015e7 <syscall>
  8019ae:	83 c4 18             	add    $0x18,%esp
}
  8019b1:	c9                   	leave  
  8019b2:	c3                   	ret    

008019b3 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8019b3:	55                   	push   %ebp
  8019b4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 03                	push   $0x3
  8019c2:	e8 20 fc ff ff       	call   8015e7 <syscall>
  8019c7:	83 c4 18             	add    $0x18,%esp
}
  8019ca:	c9                   	leave  
  8019cb:	c3                   	ret    

008019cc <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8019cc:	55                   	push   %ebp
  8019cd:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 00                	push   $0x0
  8019d9:	6a 04                	push   $0x4
  8019db:	e8 07 fc ff ff       	call   8015e7 <syscall>
  8019e0:	83 c4 18             	add    $0x18,%esp
}
  8019e3:	c9                   	leave  
  8019e4:	c3                   	ret    

008019e5 <sys_exit_env>:


void sys_exit_env(void)
{
  8019e5:	55                   	push   %ebp
  8019e6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 00                	push   $0x0
  8019ec:	6a 00                	push   $0x0
  8019ee:	6a 00                	push   $0x0
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 23                	push   $0x23
  8019f4:	e8 ee fb ff ff       	call   8015e7 <syscall>
  8019f9:	83 c4 18             	add    $0x18,%esp
}
  8019fc:	90                   	nop
  8019fd:	c9                   	leave  
  8019fe:	c3                   	ret    

008019ff <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8019ff:	55                   	push   %ebp
  801a00:	89 e5                	mov    %esp,%ebp
  801a02:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801a05:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a08:	8d 50 04             	lea    0x4(%eax),%edx
  801a0b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a0e:	6a 00                	push   $0x0
  801a10:	6a 00                	push   $0x0
  801a12:	6a 00                	push   $0x0
  801a14:	52                   	push   %edx
  801a15:	50                   	push   %eax
  801a16:	6a 24                	push   $0x24
  801a18:	e8 ca fb ff ff       	call   8015e7 <syscall>
  801a1d:	83 c4 18             	add    $0x18,%esp
	return result;
  801a20:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a23:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a26:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a29:	89 01                	mov    %eax,(%ecx)
  801a2b:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a31:	c9                   	leave  
  801a32:	c2 04 00             	ret    $0x4

00801a35 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801a35:	55                   	push   %ebp
  801a36:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801a38:	6a 00                	push   $0x0
  801a3a:	6a 00                	push   $0x0
  801a3c:	ff 75 10             	pushl  0x10(%ebp)
  801a3f:	ff 75 0c             	pushl  0xc(%ebp)
  801a42:	ff 75 08             	pushl  0x8(%ebp)
  801a45:	6a 12                	push   $0x12
  801a47:	e8 9b fb ff ff       	call   8015e7 <syscall>
  801a4c:	83 c4 18             	add    $0x18,%esp
	return ;
  801a4f:	90                   	nop
}
  801a50:	c9                   	leave  
  801a51:	c3                   	ret    

00801a52 <sys_rcr2>:
uint32 sys_rcr2()
{
  801a52:	55                   	push   %ebp
  801a53:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801a55:	6a 00                	push   $0x0
  801a57:	6a 00                	push   $0x0
  801a59:	6a 00                	push   $0x0
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 25                	push   $0x25
  801a61:	e8 81 fb ff ff       	call   8015e7 <syscall>
  801a66:	83 c4 18             	add    $0x18,%esp
}
  801a69:	c9                   	leave  
  801a6a:	c3                   	ret    

00801a6b <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801a6b:	55                   	push   %ebp
  801a6c:	89 e5                	mov    %esp,%ebp
  801a6e:	83 ec 04             	sub    $0x4,%esp
  801a71:	8b 45 08             	mov    0x8(%ebp),%eax
  801a74:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801a77:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801a7b:	6a 00                	push   $0x0
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 00                	push   $0x0
  801a83:	50                   	push   %eax
  801a84:	6a 26                	push   $0x26
  801a86:	e8 5c fb ff ff       	call   8015e7 <syscall>
  801a8b:	83 c4 18             	add    $0x18,%esp
	return ;
  801a8e:	90                   	nop
}
  801a8f:	c9                   	leave  
  801a90:	c3                   	ret    

00801a91 <rsttst>:
void rsttst()
{
  801a91:	55                   	push   %ebp
  801a92:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801a94:	6a 00                	push   $0x0
  801a96:	6a 00                	push   $0x0
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 28                	push   $0x28
  801aa0:	e8 42 fb ff ff       	call   8015e7 <syscall>
  801aa5:	83 c4 18             	add    $0x18,%esp
	return ;
  801aa8:	90                   	nop
}
  801aa9:	c9                   	leave  
  801aaa:	c3                   	ret    

00801aab <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801aab:	55                   	push   %ebp
  801aac:	89 e5                	mov    %esp,%ebp
  801aae:	83 ec 04             	sub    $0x4,%esp
  801ab1:	8b 45 14             	mov    0x14(%ebp),%eax
  801ab4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ab7:	8b 55 18             	mov    0x18(%ebp),%edx
  801aba:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801abe:	52                   	push   %edx
  801abf:	50                   	push   %eax
  801ac0:	ff 75 10             	pushl  0x10(%ebp)
  801ac3:	ff 75 0c             	pushl  0xc(%ebp)
  801ac6:	ff 75 08             	pushl  0x8(%ebp)
  801ac9:	6a 27                	push   $0x27
  801acb:	e8 17 fb ff ff       	call   8015e7 <syscall>
  801ad0:	83 c4 18             	add    $0x18,%esp
	return ;
  801ad3:	90                   	nop
}
  801ad4:	c9                   	leave  
  801ad5:	c3                   	ret    

00801ad6 <chktst>:
void chktst(uint32 n)
{
  801ad6:	55                   	push   %ebp
  801ad7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801ad9:	6a 00                	push   $0x0
  801adb:	6a 00                	push   $0x0
  801add:	6a 00                	push   $0x0
  801adf:	6a 00                	push   $0x0
  801ae1:	ff 75 08             	pushl  0x8(%ebp)
  801ae4:	6a 29                	push   $0x29
  801ae6:	e8 fc fa ff ff       	call   8015e7 <syscall>
  801aeb:	83 c4 18             	add    $0x18,%esp
	return ;
  801aee:	90                   	nop
}
  801aef:	c9                   	leave  
  801af0:	c3                   	ret    

00801af1 <inctst>:

void inctst()
{
  801af1:	55                   	push   %ebp
  801af2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	6a 00                	push   $0x0
  801afa:	6a 00                	push   $0x0
  801afc:	6a 00                	push   $0x0
  801afe:	6a 2a                	push   $0x2a
  801b00:	e8 e2 fa ff ff       	call   8015e7 <syscall>
  801b05:	83 c4 18             	add    $0x18,%esp
	return ;
  801b08:	90                   	nop
}
  801b09:	c9                   	leave  
  801b0a:	c3                   	ret    

00801b0b <gettst>:
uint32 gettst()
{
  801b0b:	55                   	push   %ebp
  801b0c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 00                	push   $0x0
  801b12:	6a 00                	push   $0x0
  801b14:	6a 00                	push   $0x0
  801b16:	6a 00                	push   $0x0
  801b18:	6a 2b                	push   $0x2b
  801b1a:	e8 c8 fa ff ff       	call   8015e7 <syscall>
  801b1f:	83 c4 18             	add    $0x18,%esp
}
  801b22:	c9                   	leave  
  801b23:	c3                   	ret    

00801b24 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801b24:	55                   	push   %ebp
  801b25:	89 e5                	mov    %esp,%ebp
  801b27:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b2a:	6a 00                	push   $0x0
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 00                	push   $0x0
  801b30:	6a 00                	push   $0x0
  801b32:	6a 00                	push   $0x0
  801b34:	6a 2c                	push   $0x2c
  801b36:	e8 ac fa ff ff       	call   8015e7 <syscall>
  801b3b:	83 c4 18             	add    $0x18,%esp
  801b3e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801b41:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801b45:	75 07                	jne    801b4e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801b47:	b8 01 00 00 00       	mov    $0x1,%eax
  801b4c:	eb 05                	jmp    801b53 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801b4e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b53:	c9                   	leave  
  801b54:	c3                   	ret    

00801b55 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801b55:	55                   	push   %ebp
  801b56:	89 e5                	mov    %esp,%ebp
  801b58:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b5b:	6a 00                	push   $0x0
  801b5d:	6a 00                	push   $0x0
  801b5f:	6a 00                	push   $0x0
  801b61:	6a 00                	push   $0x0
  801b63:	6a 00                	push   $0x0
  801b65:	6a 2c                	push   $0x2c
  801b67:	e8 7b fa ff ff       	call   8015e7 <syscall>
  801b6c:	83 c4 18             	add    $0x18,%esp
  801b6f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801b72:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801b76:	75 07                	jne    801b7f <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801b78:	b8 01 00 00 00       	mov    $0x1,%eax
  801b7d:	eb 05                	jmp    801b84 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801b7f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b84:	c9                   	leave  
  801b85:	c3                   	ret    

00801b86 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801b86:	55                   	push   %ebp
  801b87:	89 e5                	mov    %esp,%ebp
  801b89:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b8c:	6a 00                	push   $0x0
  801b8e:	6a 00                	push   $0x0
  801b90:	6a 00                	push   $0x0
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	6a 2c                	push   $0x2c
  801b98:	e8 4a fa ff ff       	call   8015e7 <syscall>
  801b9d:	83 c4 18             	add    $0x18,%esp
  801ba0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801ba3:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801ba7:	75 07                	jne    801bb0 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801ba9:	b8 01 00 00 00       	mov    $0x1,%eax
  801bae:	eb 05                	jmp    801bb5 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801bb0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bb5:	c9                   	leave  
  801bb6:	c3                   	ret    

00801bb7 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801bb7:	55                   	push   %ebp
  801bb8:	89 e5                	mov    %esp,%ebp
  801bba:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bbd:	6a 00                	push   $0x0
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 2c                	push   $0x2c
  801bc9:	e8 19 fa ff ff       	call   8015e7 <syscall>
  801bce:	83 c4 18             	add    $0x18,%esp
  801bd1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801bd4:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801bd8:	75 07                	jne    801be1 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801bda:	b8 01 00 00 00       	mov    $0x1,%eax
  801bdf:	eb 05                	jmp    801be6 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801be1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801be6:	c9                   	leave  
  801be7:	c3                   	ret    

00801be8 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801be8:	55                   	push   %ebp
  801be9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	6a 00                	push   $0x0
  801bf1:	6a 00                	push   $0x0
  801bf3:	ff 75 08             	pushl  0x8(%ebp)
  801bf6:	6a 2d                	push   $0x2d
  801bf8:	e8 ea f9 ff ff       	call   8015e7 <syscall>
  801bfd:	83 c4 18             	add    $0x18,%esp
	return ;
  801c00:	90                   	nop
}
  801c01:	c9                   	leave  
  801c02:	c3                   	ret    

00801c03 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801c03:	55                   	push   %ebp
  801c04:	89 e5                	mov    %esp,%ebp
  801c06:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801c07:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c0a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c10:	8b 45 08             	mov    0x8(%ebp),%eax
  801c13:	6a 00                	push   $0x0
  801c15:	53                   	push   %ebx
  801c16:	51                   	push   %ecx
  801c17:	52                   	push   %edx
  801c18:	50                   	push   %eax
  801c19:	6a 2e                	push   $0x2e
  801c1b:	e8 c7 f9 ff ff       	call   8015e7 <syscall>
  801c20:	83 c4 18             	add    $0x18,%esp
}
  801c23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c26:	c9                   	leave  
  801c27:	c3                   	ret    

00801c28 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801c28:	55                   	push   %ebp
  801c29:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801c2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c31:	6a 00                	push   $0x0
  801c33:	6a 00                	push   $0x0
  801c35:	6a 00                	push   $0x0
  801c37:	52                   	push   %edx
  801c38:	50                   	push   %eax
  801c39:	6a 2f                	push   $0x2f
  801c3b:	e8 a7 f9 ff ff       	call   8015e7 <syscall>
  801c40:	83 c4 18             	add    $0x18,%esp
}
  801c43:	c9                   	leave  
  801c44:	c3                   	ret    

00801c45 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801c45:	55                   	push   %ebp
  801c46:	89 e5                	mov    %esp,%ebp
  801c48:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801c4b:	83 ec 0c             	sub    $0xc,%esp
  801c4e:	68 f8 3d 80 00       	push   $0x803df8
  801c53:	e8 d3 e8 ff ff       	call   80052b <cprintf>
  801c58:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801c5b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801c62:	83 ec 0c             	sub    $0xc,%esp
  801c65:	68 24 3e 80 00       	push   $0x803e24
  801c6a:	e8 bc e8 ff ff       	call   80052b <cprintf>
  801c6f:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801c72:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801c76:	a1 38 41 80 00       	mov    0x804138,%eax
  801c7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c7e:	eb 56                	jmp    801cd6 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801c80:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801c84:	74 1c                	je     801ca2 <print_mem_block_lists+0x5d>
  801c86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c89:	8b 50 08             	mov    0x8(%eax),%edx
  801c8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c8f:	8b 48 08             	mov    0x8(%eax),%ecx
  801c92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c95:	8b 40 0c             	mov    0xc(%eax),%eax
  801c98:	01 c8                	add    %ecx,%eax
  801c9a:	39 c2                	cmp    %eax,%edx
  801c9c:	73 04                	jae    801ca2 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801c9e:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801ca2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ca5:	8b 50 08             	mov    0x8(%eax),%edx
  801ca8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cab:	8b 40 0c             	mov    0xc(%eax),%eax
  801cae:	01 c2                	add    %eax,%edx
  801cb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cb3:	8b 40 08             	mov    0x8(%eax),%eax
  801cb6:	83 ec 04             	sub    $0x4,%esp
  801cb9:	52                   	push   %edx
  801cba:	50                   	push   %eax
  801cbb:	68 39 3e 80 00       	push   $0x803e39
  801cc0:	e8 66 e8 ff ff       	call   80052b <cprintf>
  801cc5:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801cc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ccb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801cce:	a1 40 41 80 00       	mov    0x804140,%eax
  801cd3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801cd6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801cda:	74 07                	je     801ce3 <print_mem_block_lists+0x9e>
  801cdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cdf:	8b 00                	mov    (%eax),%eax
  801ce1:	eb 05                	jmp    801ce8 <print_mem_block_lists+0xa3>
  801ce3:	b8 00 00 00 00       	mov    $0x0,%eax
  801ce8:	a3 40 41 80 00       	mov    %eax,0x804140
  801ced:	a1 40 41 80 00       	mov    0x804140,%eax
  801cf2:	85 c0                	test   %eax,%eax
  801cf4:	75 8a                	jne    801c80 <print_mem_block_lists+0x3b>
  801cf6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801cfa:	75 84                	jne    801c80 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801cfc:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801d00:	75 10                	jne    801d12 <print_mem_block_lists+0xcd>
  801d02:	83 ec 0c             	sub    $0xc,%esp
  801d05:	68 48 3e 80 00       	push   $0x803e48
  801d0a:	e8 1c e8 ff ff       	call   80052b <cprintf>
  801d0f:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801d12:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801d19:	83 ec 0c             	sub    $0xc,%esp
  801d1c:	68 6c 3e 80 00       	push   $0x803e6c
  801d21:	e8 05 e8 ff ff       	call   80052b <cprintf>
  801d26:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801d29:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801d2d:	a1 40 40 80 00       	mov    0x804040,%eax
  801d32:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d35:	eb 56                	jmp    801d8d <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801d37:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d3b:	74 1c                	je     801d59 <print_mem_block_lists+0x114>
  801d3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d40:	8b 50 08             	mov    0x8(%eax),%edx
  801d43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d46:	8b 48 08             	mov    0x8(%eax),%ecx
  801d49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d4c:	8b 40 0c             	mov    0xc(%eax),%eax
  801d4f:	01 c8                	add    %ecx,%eax
  801d51:	39 c2                	cmp    %eax,%edx
  801d53:	73 04                	jae    801d59 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801d55:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801d59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d5c:	8b 50 08             	mov    0x8(%eax),%edx
  801d5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d62:	8b 40 0c             	mov    0xc(%eax),%eax
  801d65:	01 c2                	add    %eax,%edx
  801d67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d6a:	8b 40 08             	mov    0x8(%eax),%eax
  801d6d:	83 ec 04             	sub    $0x4,%esp
  801d70:	52                   	push   %edx
  801d71:	50                   	push   %eax
  801d72:	68 39 3e 80 00       	push   $0x803e39
  801d77:	e8 af e7 ff ff       	call   80052b <cprintf>
  801d7c:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801d7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d82:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801d85:	a1 48 40 80 00       	mov    0x804048,%eax
  801d8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d8d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d91:	74 07                	je     801d9a <print_mem_block_lists+0x155>
  801d93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d96:	8b 00                	mov    (%eax),%eax
  801d98:	eb 05                	jmp    801d9f <print_mem_block_lists+0x15a>
  801d9a:	b8 00 00 00 00       	mov    $0x0,%eax
  801d9f:	a3 48 40 80 00       	mov    %eax,0x804048
  801da4:	a1 48 40 80 00       	mov    0x804048,%eax
  801da9:	85 c0                	test   %eax,%eax
  801dab:	75 8a                	jne    801d37 <print_mem_block_lists+0xf2>
  801dad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801db1:	75 84                	jne    801d37 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801db3:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801db7:	75 10                	jne    801dc9 <print_mem_block_lists+0x184>
  801db9:	83 ec 0c             	sub    $0xc,%esp
  801dbc:	68 84 3e 80 00       	push   $0x803e84
  801dc1:	e8 65 e7 ff ff       	call   80052b <cprintf>
  801dc6:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801dc9:	83 ec 0c             	sub    $0xc,%esp
  801dcc:	68 f8 3d 80 00       	push   $0x803df8
  801dd1:	e8 55 e7 ff ff       	call   80052b <cprintf>
  801dd6:	83 c4 10             	add    $0x10,%esp

}
  801dd9:	90                   	nop
  801dda:	c9                   	leave  
  801ddb:	c3                   	ret    

00801ddc <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801ddc:	55                   	push   %ebp
  801ddd:	89 e5                	mov    %esp,%ebp
  801ddf:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801de2:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801de9:	00 00 00 
  801dec:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801df3:	00 00 00 
  801df6:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801dfd:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801e00:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801e07:	e9 9e 00 00 00       	jmp    801eaa <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801e0c:	a1 50 40 80 00       	mov    0x804050,%eax
  801e11:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e14:	c1 e2 04             	shl    $0x4,%edx
  801e17:	01 d0                	add    %edx,%eax
  801e19:	85 c0                	test   %eax,%eax
  801e1b:	75 14                	jne    801e31 <initialize_MemBlocksList+0x55>
  801e1d:	83 ec 04             	sub    $0x4,%esp
  801e20:	68 ac 3e 80 00       	push   $0x803eac
  801e25:	6a 46                	push   $0x46
  801e27:	68 cf 3e 80 00       	push   $0x803ecf
  801e2c:	e8 46 e4 ff ff       	call   800277 <_panic>
  801e31:	a1 50 40 80 00       	mov    0x804050,%eax
  801e36:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e39:	c1 e2 04             	shl    $0x4,%edx
  801e3c:	01 d0                	add    %edx,%eax
  801e3e:	8b 15 48 41 80 00    	mov    0x804148,%edx
  801e44:	89 10                	mov    %edx,(%eax)
  801e46:	8b 00                	mov    (%eax),%eax
  801e48:	85 c0                	test   %eax,%eax
  801e4a:	74 18                	je     801e64 <initialize_MemBlocksList+0x88>
  801e4c:	a1 48 41 80 00       	mov    0x804148,%eax
  801e51:	8b 15 50 40 80 00    	mov    0x804050,%edx
  801e57:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801e5a:	c1 e1 04             	shl    $0x4,%ecx
  801e5d:	01 ca                	add    %ecx,%edx
  801e5f:	89 50 04             	mov    %edx,0x4(%eax)
  801e62:	eb 12                	jmp    801e76 <initialize_MemBlocksList+0x9a>
  801e64:	a1 50 40 80 00       	mov    0x804050,%eax
  801e69:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e6c:	c1 e2 04             	shl    $0x4,%edx
  801e6f:	01 d0                	add    %edx,%eax
  801e71:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801e76:	a1 50 40 80 00       	mov    0x804050,%eax
  801e7b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e7e:	c1 e2 04             	shl    $0x4,%edx
  801e81:	01 d0                	add    %edx,%eax
  801e83:	a3 48 41 80 00       	mov    %eax,0x804148
  801e88:	a1 50 40 80 00       	mov    0x804050,%eax
  801e8d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e90:	c1 e2 04             	shl    $0x4,%edx
  801e93:	01 d0                	add    %edx,%eax
  801e95:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801e9c:	a1 54 41 80 00       	mov    0x804154,%eax
  801ea1:	40                   	inc    %eax
  801ea2:	a3 54 41 80 00       	mov    %eax,0x804154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801ea7:	ff 45 f4             	incl   -0xc(%ebp)
  801eaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ead:	3b 45 08             	cmp    0x8(%ebp),%eax
  801eb0:	0f 82 56 ff ff ff    	jb     801e0c <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801eb6:	90                   	nop
  801eb7:	c9                   	leave  
  801eb8:	c3                   	ret    

00801eb9 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801eb9:	55                   	push   %ebp
  801eba:	89 e5                	mov    %esp,%ebp
  801ebc:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801ebf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec2:	8b 00                	mov    (%eax),%eax
  801ec4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801ec7:	eb 19                	jmp    801ee2 <find_block+0x29>
	{
		if(va==point->sva)
  801ec9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ecc:	8b 40 08             	mov    0x8(%eax),%eax
  801ecf:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801ed2:	75 05                	jne    801ed9 <find_block+0x20>
		   return point;
  801ed4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ed7:	eb 36                	jmp    801f0f <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  801edc:	8b 40 08             	mov    0x8(%eax),%eax
  801edf:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801ee2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801ee6:	74 07                	je     801eef <find_block+0x36>
  801ee8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801eeb:	8b 00                	mov    (%eax),%eax
  801eed:	eb 05                	jmp    801ef4 <find_block+0x3b>
  801eef:	b8 00 00 00 00       	mov    $0x0,%eax
  801ef4:	8b 55 08             	mov    0x8(%ebp),%edx
  801ef7:	89 42 08             	mov    %eax,0x8(%edx)
  801efa:	8b 45 08             	mov    0x8(%ebp),%eax
  801efd:	8b 40 08             	mov    0x8(%eax),%eax
  801f00:	85 c0                	test   %eax,%eax
  801f02:	75 c5                	jne    801ec9 <find_block+0x10>
  801f04:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f08:	75 bf                	jne    801ec9 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  801f0a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f0f:	c9                   	leave  
  801f10:	c3                   	ret    

00801f11 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  801f11:	55                   	push   %ebp
  801f12:	89 e5                	mov    %esp,%ebp
  801f14:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  801f17:	a1 40 40 80 00       	mov    0x804040,%eax
  801f1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  801f1f:	a1 44 40 80 00       	mov    0x804044,%eax
  801f24:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  801f27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f2a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801f2d:	74 24                	je     801f53 <insert_sorted_allocList+0x42>
  801f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f32:	8b 50 08             	mov    0x8(%eax),%edx
  801f35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f38:	8b 40 08             	mov    0x8(%eax),%eax
  801f3b:	39 c2                	cmp    %eax,%edx
  801f3d:	76 14                	jbe    801f53 <insert_sorted_allocList+0x42>
  801f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f42:	8b 50 08             	mov    0x8(%eax),%edx
  801f45:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f48:	8b 40 08             	mov    0x8(%eax),%eax
  801f4b:	39 c2                	cmp    %eax,%edx
  801f4d:	0f 82 60 01 00 00    	jb     8020b3 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  801f53:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f57:	75 65                	jne    801fbe <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  801f59:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f5d:	75 14                	jne    801f73 <insert_sorted_allocList+0x62>
  801f5f:	83 ec 04             	sub    $0x4,%esp
  801f62:	68 ac 3e 80 00       	push   $0x803eac
  801f67:	6a 6b                	push   $0x6b
  801f69:	68 cf 3e 80 00       	push   $0x803ecf
  801f6e:	e8 04 e3 ff ff       	call   800277 <_panic>
  801f73:	8b 15 40 40 80 00    	mov    0x804040,%edx
  801f79:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7c:	89 10                	mov    %edx,(%eax)
  801f7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f81:	8b 00                	mov    (%eax),%eax
  801f83:	85 c0                	test   %eax,%eax
  801f85:	74 0d                	je     801f94 <insert_sorted_allocList+0x83>
  801f87:	a1 40 40 80 00       	mov    0x804040,%eax
  801f8c:	8b 55 08             	mov    0x8(%ebp),%edx
  801f8f:	89 50 04             	mov    %edx,0x4(%eax)
  801f92:	eb 08                	jmp    801f9c <insert_sorted_allocList+0x8b>
  801f94:	8b 45 08             	mov    0x8(%ebp),%eax
  801f97:	a3 44 40 80 00       	mov    %eax,0x804044
  801f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9f:	a3 40 40 80 00       	mov    %eax,0x804040
  801fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801fae:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801fb3:	40                   	inc    %eax
  801fb4:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  801fb9:	e9 dc 01 00 00       	jmp    80219a <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  801fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc1:	8b 50 08             	mov    0x8(%eax),%edx
  801fc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fc7:	8b 40 08             	mov    0x8(%eax),%eax
  801fca:	39 c2                	cmp    %eax,%edx
  801fcc:	77 6c                	ja     80203a <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  801fce:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fd2:	74 06                	je     801fda <insert_sorted_allocList+0xc9>
  801fd4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801fd8:	75 14                	jne    801fee <insert_sorted_allocList+0xdd>
  801fda:	83 ec 04             	sub    $0x4,%esp
  801fdd:	68 e8 3e 80 00       	push   $0x803ee8
  801fe2:	6a 6f                	push   $0x6f
  801fe4:	68 cf 3e 80 00       	push   $0x803ecf
  801fe9:	e8 89 e2 ff ff       	call   800277 <_panic>
  801fee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ff1:	8b 50 04             	mov    0x4(%eax),%edx
  801ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff7:	89 50 04             	mov    %edx,0x4(%eax)
  801ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802000:	89 10                	mov    %edx,(%eax)
  802002:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802005:	8b 40 04             	mov    0x4(%eax),%eax
  802008:	85 c0                	test   %eax,%eax
  80200a:	74 0d                	je     802019 <insert_sorted_allocList+0x108>
  80200c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80200f:	8b 40 04             	mov    0x4(%eax),%eax
  802012:	8b 55 08             	mov    0x8(%ebp),%edx
  802015:	89 10                	mov    %edx,(%eax)
  802017:	eb 08                	jmp    802021 <insert_sorted_allocList+0x110>
  802019:	8b 45 08             	mov    0x8(%ebp),%eax
  80201c:	a3 40 40 80 00       	mov    %eax,0x804040
  802021:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802024:	8b 55 08             	mov    0x8(%ebp),%edx
  802027:	89 50 04             	mov    %edx,0x4(%eax)
  80202a:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80202f:	40                   	inc    %eax
  802030:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802035:	e9 60 01 00 00       	jmp    80219a <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  80203a:	8b 45 08             	mov    0x8(%ebp),%eax
  80203d:	8b 50 08             	mov    0x8(%eax),%edx
  802040:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802043:	8b 40 08             	mov    0x8(%eax),%eax
  802046:	39 c2                	cmp    %eax,%edx
  802048:	0f 82 4c 01 00 00    	jb     80219a <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  80204e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802052:	75 14                	jne    802068 <insert_sorted_allocList+0x157>
  802054:	83 ec 04             	sub    $0x4,%esp
  802057:	68 20 3f 80 00       	push   $0x803f20
  80205c:	6a 73                	push   $0x73
  80205e:	68 cf 3e 80 00       	push   $0x803ecf
  802063:	e8 0f e2 ff ff       	call   800277 <_panic>
  802068:	8b 15 44 40 80 00    	mov    0x804044,%edx
  80206e:	8b 45 08             	mov    0x8(%ebp),%eax
  802071:	89 50 04             	mov    %edx,0x4(%eax)
  802074:	8b 45 08             	mov    0x8(%ebp),%eax
  802077:	8b 40 04             	mov    0x4(%eax),%eax
  80207a:	85 c0                	test   %eax,%eax
  80207c:	74 0c                	je     80208a <insert_sorted_allocList+0x179>
  80207e:	a1 44 40 80 00       	mov    0x804044,%eax
  802083:	8b 55 08             	mov    0x8(%ebp),%edx
  802086:	89 10                	mov    %edx,(%eax)
  802088:	eb 08                	jmp    802092 <insert_sorted_allocList+0x181>
  80208a:	8b 45 08             	mov    0x8(%ebp),%eax
  80208d:	a3 40 40 80 00       	mov    %eax,0x804040
  802092:	8b 45 08             	mov    0x8(%ebp),%eax
  802095:	a3 44 40 80 00       	mov    %eax,0x804044
  80209a:	8b 45 08             	mov    0x8(%ebp),%eax
  80209d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8020a3:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8020a8:	40                   	inc    %eax
  8020a9:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8020ae:	e9 e7 00 00 00       	jmp    80219a <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8020b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8020b9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8020c0:	a1 40 40 80 00       	mov    0x804040,%eax
  8020c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020c8:	e9 9d 00 00 00       	jmp    80216a <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8020cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d0:	8b 00                	mov    (%eax),%eax
  8020d2:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8020d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d8:	8b 50 08             	mov    0x8(%eax),%edx
  8020db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020de:	8b 40 08             	mov    0x8(%eax),%eax
  8020e1:	39 c2                	cmp    %eax,%edx
  8020e3:	76 7d                	jbe    802162 <insert_sorted_allocList+0x251>
  8020e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e8:	8b 50 08             	mov    0x8(%eax),%edx
  8020eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8020ee:	8b 40 08             	mov    0x8(%eax),%eax
  8020f1:	39 c2                	cmp    %eax,%edx
  8020f3:	73 6d                	jae    802162 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8020f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020f9:	74 06                	je     802101 <insert_sorted_allocList+0x1f0>
  8020fb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020ff:	75 14                	jne    802115 <insert_sorted_allocList+0x204>
  802101:	83 ec 04             	sub    $0x4,%esp
  802104:	68 44 3f 80 00       	push   $0x803f44
  802109:	6a 7f                	push   $0x7f
  80210b:	68 cf 3e 80 00       	push   $0x803ecf
  802110:	e8 62 e1 ff ff       	call   800277 <_panic>
  802115:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802118:	8b 10                	mov    (%eax),%edx
  80211a:	8b 45 08             	mov    0x8(%ebp),%eax
  80211d:	89 10                	mov    %edx,(%eax)
  80211f:	8b 45 08             	mov    0x8(%ebp),%eax
  802122:	8b 00                	mov    (%eax),%eax
  802124:	85 c0                	test   %eax,%eax
  802126:	74 0b                	je     802133 <insert_sorted_allocList+0x222>
  802128:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80212b:	8b 00                	mov    (%eax),%eax
  80212d:	8b 55 08             	mov    0x8(%ebp),%edx
  802130:	89 50 04             	mov    %edx,0x4(%eax)
  802133:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802136:	8b 55 08             	mov    0x8(%ebp),%edx
  802139:	89 10                	mov    %edx,(%eax)
  80213b:	8b 45 08             	mov    0x8(%ebp),%eax
  80213e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802141:	89 50 04             	mov    %edx,0x4(%eax)
  802144:	8b 45 08             	mov    0x8(%ebp),%eax
  802147:	8b 00                	mov    (%eax),%eax
  802149:	85 c0                	test   %eax,%eax
  80214b:	75 08                	jne    802155 <insert_sorted_allocList+0x244>
  80214d:	8b 45 08             	mov    0x8(%ebp),%eax
  802150:	a3 44 40 80 00       	mov    %eax,0x804044
  802155:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80215a:	40                   	inc    %eax
  80215b:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  802160:	eb 39                	jmp    80219b <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802162:	a1 48 40 80 00       	mov    0x804048,%eax
  802167:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80216a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80216e:	74 07                	je     802177 <insert_sorted_allocList+0x266>
  802170:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802173:	8b 00                	mov    (%eax),%eax
  802175:	eb 05                	jmp    80217c <insert_sorted_allocList+0x26b>
  802177:	b8 00 00 00 00       	mov    $0x0,%eax
  80217c:	a3 48 40 80 00       	mov    %eax,0x804048
  802181:	a1 48 40 80 00       	mov    0x804048,%eax
  802186:	85 c0                	test   %eax,%eax
  802188:	0f 85 3f ff ff ff    	jne    8020cd <insert_sorted_allocList+0x1bc>
  80218e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802192:	0f 85 35 ff ff ff    	jne    8020cd <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802198:	eb 01                	jmp    80219b <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80219a:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80219b:	90                   	nop
  80219c:	c9                   	leave  
  80219d:	c3                   	ret    

0080219e <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80219e:	55                   	push   %ebp
  80219f:	89 e5                	mov    %esp,%ebp
  8021a1:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8021a4:	a1 38 41 80 00       	mov    0x804138,%eax
  8021a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021ac:	e9 85 01 00 00       	jmp    802336 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8021b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b4:	8b 40 0c             	mov    0xc(%eax),%eax
  8021b7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021ba:	0f 82 6e 01 00 00    	jb     80232e <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8021c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c3:	8b 40 0c             	mov    0xc(%eax),%eax
  8021c6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021c9:	0f 85 8a 00 00 00    	jne    802259 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8021cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021d3:	75 17                	jne    8021ec <alloc_block_FF+0x4e>
  8021d5:	83 ec 04             	sub    $0x4,%esp
  8021d8:	68 78 3f 80 00       	push   $0x803f78
  8021dd:	68 93 00 00 00       	push   $0x93
  8021e2:	68 cf 3e 80 00       	push   $0x803ecf
  8021e7:	e8 8b e0 ff ff       	call   800277 <_panic>
  8021ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ef:	8b 00                	mov    (%eax),%eax
  8021f1:	85 c0                	test   %eax,%eax
  8021f3:	74 10                	je     802205 <alloc_block_FF+0x67>
  8021f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f8:	8b 00                	mov    (%eax),%eax
  8021fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021fd:	8b 52 04             	mov    0x4(%edx),%edx
  802200:	89 50 04             	mov    %edx,0x4(%eax)
  802203:	eb 0b                	jmp    802210 <alloc_block_FF+0x72>
  802205:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802208:	8b 40 04             	mov    0x4(%eax),%eax
  80220b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802210:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802213:	8b 40 04             	mov    0x4(%eax),%eax
  802216:	85 c0                	test   %eax,%eax
  802218:	74 0f                	je     802229 <alloc_block_FF+0x8b>
  80221a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80221d:	8b 40 04             	mov    0x4(%eax),%eax
  802220:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802223:	8b 12                	mov    (%edx),%edx
  802225:	89 10                	mov    %edx,(%eax)
  802227:	eb 0a                	jmp    802233 <alloc_block_FF+0x95>
  802229:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80222c:	8b 00                	mov    (%eax),%eax
  80222e:	a3 38 41 80 00       	mov    %eax,0x804138
  802233:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802236:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80223c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802246:	a1 44 41 80 00       	mov    0x804144,%eax
  80224b:	48                   	dec    %eax
  80224c:	a3 44 41 80 00       	mov    %eax,0x804144
			   return  point;
  802251:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802254:	e9 10 01 00 00       	jmp    802369 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802259:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225c:	8b 40 0c             	mov    0xc(%eax),%eax
  80225f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802262:	0f 86 c6 00 00 00    	jbe    80232e <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802268:	a1 48 41 80 00       	mov    0x804148,%eax
  80226d:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802270:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802273:	8b 50 08             	mov    0x8(%eax),%edx
  802276:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802279:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  80227c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80227f:	8b 55 08             	mov    0x8(%ebp),%edx
  802282:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802285:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802289:	75 17                	jne    8022a2 <alloc_block_FF+0x104>
  80228b:	83 ec 04             	sub    $0x4,%esp
  80228e:	68 78 3f 80 00       	push   $0x803f78
  802293:	68 9b 00 00 00       	push   $0x9b
  802298:	68 cf 3e 80 00       	push   $0x803ecf
  80229d:	e8 d5 df ff ff       	call   800277 <_panic>
  8022a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022a5:	8b 00                	mov    (%eax),%eax
  8022a7:	85 c0                	test   %eax,%eax
  8022a9:	74 10                	je     8022bb <alloc_block_FF+0x11d>
  8022ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022ae:	8b 00                	mov    (%eax),%eax
  8022b0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022b3:	8b 52 04             	mov    0x4(%edx),%edx
  8022b6:	89 50 04             	mov    %edx,0x4(%eax)
  8022b9:	eb 0b                	jmp    8022c6 <alloc_block_FF+0x128>
  8022bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022be:	8b 40 04             	mov    0x4(%eax),%eax
  8022c1:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8022c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022c9:	8b 40 04             	mov    0x4(%eax),%eax
  8022cc:	85 c0                	test   %eax,%eax
  8022ce:	74 0f                	je     8022df <alloc_block_FF+0x141>
  8022d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022d3:	8b 40 04             	mov    0x4(%eax),%eax
  8022d6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022d9:	8b 12                	mov    (%edx),%edx
  8022db:	89 10                	mov    %edx,(%eax)
  8022dd:	eb 0a                	jmp    8022e9 <alloc_block_FF+0x14b>
  8022df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022e2:	8b 00                	mov    (%eax),%eax
  8022e4:	a3 48 41 80 00       	mov    %eax,0x804148
  8022e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022ec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022f5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022fc:	a1 54 41 80 00       	mov    0x804154,%eax
  802301:	48                   	dec    %eax
  802302:	a3 54 41 80 00       	mov    %eax,0x804154
			   point->sva += size;
  802307:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230a:	8b 50 08             	mov    0x8(%eax),%edx
  80230d:	8b 45 08             	mov    0x8(%ebp),%eax
  802310:	01 c2                	add    %eax,%edx
  802312:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802315:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802318:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231b:	8b 40 0c             	mov    0xc(%eax),%eax
  80231e:	2b 45 08             	sub    0x8(%ebp),%eax
  802321:	89 c2                	mov    %eax,%edx
  802323:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802326:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802329:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80232c:	eb 3b                	jmp    802369 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80232e:	a1 40 41 80 00       	mov    0x804140,%eax
  802333:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802336:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80233a:	74 07                	je     802343 <alloc_block_FF+0x1a5>
  80233c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233f:	8b 00                	mov    (%eax),%eax
  802341:	eb 05                	jmp    802348 <alloc_block_FF+0x1aa>
  802343:	b8 00 00 00 00       	mov    $0x0,%eax
  802348:	a3 40 41 80 00       	mov    %eax,0x804140
  80234d:	a1 40 41 80 00       	mov    0x804140,%eax
  802352:	85 c0                	test   %eax,%eax
  802354:	0f 85 57 fe ff ff    	jne    8021b1 <alloc_block_FF+0x13>
  80235a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80235e:	0f 85 4d fe ff ff    	jne    8021b1 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802364:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802369:	c9                   	leave  
  80236a:	c3                   	ret    

0080236b <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80236b:	55                   	push   %ebp
  80236c:	89 e5                	mov    %esp,%ebp
  80236e:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802371:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802378:	a1 38 41 80 00       	mov    0x804138,%eax
  80237d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802380:	e9 df 00 00 00       	jmp    802464 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802385:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802388:	8b 40 0c             	mov    0xc(%eax),%eax
  80238b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80238e:	0f 82 c8 00 00 00    	jb     80245c <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802394:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802397:	8b 40 0c             	mov    0xc(%eax),%eax
  80239a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80239d:	0f 85 8a 00 00 00    	jne    80242d <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8023a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023a7:	75 17                	jne    8023c0 <alloc_block_BF+0x55>
  8023a9:	83 ec 04             	sub    $0x4,%esp
  8023ac:	68 78 3f 80 00       	push   $0x803f78
  8023b1:	68 b7 00 00 00       	push   $0xb7
  8023b6:	68 cf 3e 80 00       	push   $0x803ecf
  8023bb:	e8 b7 de ff ff       	call   800277 <_panic>
  8023c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c3:	8b 00                	mov    (%eax),%eax
  8023c5:	85 c0                	test   %eax,%eax
  8023c7:	74 10                	je     8023d9 <alloc_block_BF+0x6e>
  8023c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cc:	8b 00                	mov    (%eax),%eax
  8023ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023d1:	8b 52 04             	mov    0x4(%edx),%edx
  8023d4:	89 50 04             	mov    %edx,0x4(%eax)
  8023d7:	eb 0b                	jmp    8023e4 <alloc_block_BF+0x79>
  8023d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023dc:	8b 40 04             	mov    0x4(%eax),%eax
  8023df:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8023e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e7:	8b 40 04             	mov    0x4(%eax),%eax
  8023ea:	85 c0                	test   %eax,%eax
  8023ec:	74 0f                	je     8023fd <alloc_block_BF+0x92>
  8023ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f1:	8b 40 04             	mov    0x4(%eax),%eax
  8023f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023f7:	8b 12                	mov    (%edx),%edx
  8023f9:	89 10                	mov    %edx,(%eax)
  8023fb:	eb 0a                	jmp    802407 <alloc_block_BF+0x9c>
  8023fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802400:	8b 00                	mov    (%eax),%eax
  802402:	a3 38 41 80 00       	mov    %eax,0x804138
  802407:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802410:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802413:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80241a:	a1 44 41 80 00       	mov    0x804144,%eax
  80241f:	48                   	dec    %eax
  802420:	a3 44 41 80 00       	mov    %eax,0x804144
			   return currentMemBlock;
  802425:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802428:	e9 4d 01 00 00       	jmp    80257a <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  80242d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802430:	8b 40 0c             	mov    0xc(%eax),%eax
  802433:	3b 45 08             	cmp    0x8(%ebp),%eax
  802436:	76 24                	jbe    80245c <alloc_block_BF+0xf1>
  802438:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243b:	8b 40 0c             	mov    0xc(%eax),%eax
  80243e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802441:	73 19                	jae    80245c <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802443:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  80244a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244d:	8b 40 0c             	mov    0xc(%eax),%eax
  802450:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802453:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802456:	8b 40 08             	mov    0x8(%eax),%eax
  802459:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80245c:	a1 40 41 80 00       	mov    0x804140,%eax
  802461:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802464:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802468:	74 07                	je     802471 <alloc_block_BF+0x106>
  80246a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246d:	8b 00                	mov    (%eax),%eax
  80246f:	eb 05                	jmp    802476 <alloc_block_BF+0x10b>
  802471:	b8 00 00 00 00       	mov    $0x0,%eax
  802476:	a3 40 41 80 00       	mov    %eax,0x804140
  80247b:	a1 40 41 80 00       	mov    0x804140,%eax
  802480:	85 c0                	test   %eax,%eax
  802482:	0f 85 fd fe ff ff    	jne    802385 <alloc_block_BF+0x1a>
  802488:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80248c:	0f 85 f3 fe ff ff    	jne    802385 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802492:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802496:	0f 84 d9 00 00 00    	je     802575 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  80249c:	a1 48 41 80 00       	mov    0x804148,%eax
  8024a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8024a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024a7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024aa:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8024ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024b0:	8b 55 08             	mov    0x8(%ebp),%edx
  8024b3:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8024b6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8024ba:	75 17                	jne    8024d3 <alloc_block_BF+0x168>
  8024bc:	83 ec 04             	sub    $0x4,%esp
  8024bf:	68 78 3f 80 00       	push   $0x803f78
  8024c4:	68 c7 00 00 00       	push   $0xc7
  8024c9:	68 cf 3e 80 00       	push   $0x803ecf
  8024ce:	e8 a4 dd ff ff       	call   800277 <_panic>
  8024d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024d6:	8b 00                	mov    (%eax),%eax
  8024d8:	85 c0                	test   %eax,%eax
  8024da:	74 10                	je     8024ec <alloc_block_BF+0x181>
  8024dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024df:	8b 00                	mov    (%eax),%eax
  8024e1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8024e4:	8b 52 04             	mov    0x4(%edx),%edx
  8024e7:	89 50 04             	mov    %edx,0x4(%eax)
  8024ea:	eb 0b                	jmp    8024f7 <alloc_block_BF+0x18c>
  8024ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024ef:	8b 40 04             	mov    0x4(%eax),%eax
  8024f2:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8024f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024fa:	8b 40 04             	mov    0x4(%eax),%eax
  8024fd:	85 c0                	test   %eax,%eax
  8024ff:	74 0f                	je     802510 <alloc_block_BF+0x1a5>
  802501:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802504:	8b 40 04             	mov    0x4(%eax),%eax
  802507:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80250a:	8b 12                	mov    (%edx),%edx
  80250c:	89 10                	mov    %edx,(%eax)
  80250e:	eb 0a                	jmp    80251a <alloc_block_BF+0x1af>
  802510:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802513:	8b 00                	mov    (%eax),%eax
  802515:	a3 48 41 80 00       	mov    %eax,0x804148
  80251a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80251d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802523:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802526:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80252d:	a1 54 41 80 00       	mov    0x804154,%eax
  802532:	48                   	dec    %eax
  802533:	a3 54 41 80 00       	mov    %eax,0x804154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802538:	83 ec 08             	sub    $0x8,%esp
  80253b:	ff 75 ec             	pushl  -0x14(%ebp)
  80253e:	68 38 41 80 00       	push   $0x804138
  802543:	e8 71 f9 ff ff       	call   801eb9 <find_block>
  802548:	83 c4 10             	add    $0x10,%esp
  80254b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  80254e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802551:	8b 50 08             	mov    0x8(%eax),%edx
  802554:	8b 45 08             	mov    0x8(%ebp),%eax
  802557:	01 c2                	add    %eax,%edx
  802559:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80255c:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  80255f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802562:	8b 40 0c             	mov    0xc(%eax),%eax
  802565:	2b 45 08             	sub    0x8(%ebp),%eax
  802568:	89 c2                	mov    %eax,%edx
  80256a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80256d:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802570:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802573:	eb 05                	jmp    80257a <alloc_block_BF+0x20f>
	}
	return NULL;
  802575:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80257a:	c9                   	leave  
  80257b:	c3                   	ret    

0080257c <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  80257c:	55                   	push   %ebp
  80257d:	89 e5                	mov    %esp,%ebp
  80257f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802582:	a1 28 40 80 00       	mov    0x804028,%eax
  802587:	85 c0                	test   %eax,%eax
  802589:	0f 85 de 01 00 00    	jne    80276d <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80258f:	a1 38 41 80 00       	mov    0x804138,%eax
  802594:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802597:	e9 9e 01 00 00       	jmp    80273a <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  80259c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259f:	8b 40 0c             	mov    0xc(%eax),%eax
  8025a2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025a5:	0f 82 87 01 00 00    	jb     802732 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8025ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ae:	8b 40 0c             	mov    0xc(%eax),%eax
  8025b1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025b4:	0f 85 95 00 00 00    	jne    80264f <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8025ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025be:	75 17                	jne    8025d7 <alloc_block_NF+0x5b>
  8025c0:	83 ec 04             	sub    $0x4,%esp
  8025c3:	68 78 3f 80 00       	push   $0x803f78
  8025c8:	68 e0 00 00 00       	push   $0xe0
  8025cd:	68 cf 3e 80 00       	push   $0x803ecf
  8025d2:	e8 a0 dc ff ff       	call   800277 <_panic>
  8025d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025da:	8b 00                	mov    (%eax),%eax
  8025dc:	85 c0                	test   %eax,%eax
  8025de:	74 10                	je     8025f0 <alloc_block_NF+0x74>
  8025e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e3:	8b 00                	mov    (%eax),%eax
  8025e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025e8:	8b 52 04             	mov    0x4(%edx),%edx
  8025eb:	89 50 04             	mov    %edx,0x4(%eax)
  8025ee:	eb 0b                	jmp    8025fb <alloc_block_NF+0x7f>
  8025f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f3:	8b 40 04             	mov    0x4(%eax),%eax
  8025f6:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8025fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fe:	8b 40 04             	mov    0x4(%eax),%eax
  802601:	85 c0                	test   %eax,%eax
  802603:	74 0f                	je     802614 <alloc_block_NF+0x98>
  802605:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802608:	8b 40 04             	mov    0x4(%eax),%eax
  80260b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80260e:	8b 12                	mov    (%edx),%edx
  802610:	89 10                	mov    %edx,(%eax)
  802612:	eb 0a                	jmp    80261e <alloc_block_NF+0xa2>
  802614:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802617:	8b 00                	mov    (%eax),%eax
  802619:	a3 38 41 80 00       	mov    %eax,0x804138
  80261e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802621:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802627:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802631:	a1 44 41 80 00       	mov    0x804144,%eax
  802636:	48                   	dec    %eax
  802637:	a3 44 41 80 00       	mov    %eax,0x804144
				   svaOfNF = point->sva;
  80263c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263f:	8b 40 08             	mov    0x8(%eax),%eax
  802642:	a3 28 40 80 00       	mov    %eax,0x804028
				   return  point;
  802647:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264a:	e9 f8 04 00 00       	jmp    802b47 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  80264f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802652:	8b 40 0c             	mov    0xc(%eax),%eax
  802655:	3b 45 08             	cmp    0x8(%ebp),%eax
  802658:	0f 86 d4 00 00 00    	jbe    802732 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80265e:	a1 48 41 80 00       	mov    0x804148,%eax
  802663:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802666:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802669:	8b 50 08             	mov    0x8(%eax),%edx
  80266c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80266f:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802672:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802675:	8b 55 08             	mov    0x8(%ebp),%edx
  802678:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80267b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80267f:	75 17                	jne    802698 <alloc_block_NF+0x11c>
  802681:	83 ec 04             	sub    $0x4,%esp
  802684:	68 78 3f 80 00       	push   $0x803f78
  802689:	68 e9 00 00 00       	push   $0xe9
  80268e:	68 cf 3e 80 00       	push   $0x803ecf
  802693:	e8 df db ff ff       	call   800277 <_panic>
  802698:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80269b:	8b 00                	mov    (%eax),%eax
  80269d:	85 c0                	test   %eax,%eax
  80269f:	74 10                	je     8026b1 <alloc_block_NF+0x135>
  8026a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026a4:	8b 00                	mov    (%eax),%eax
  8026a6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026a9:	8b 52 04             	mov    0x4(%edx),%edx
  8026ac:	89 50 04             	mov    %edx,0x4(%eax)
  8026af:	eb 0b                	jmp    8026bc <alloc_block_NF+0x140>
  8026b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026b4:	8b 40 04             	mov    0x4(%eax),%eax
  8026b7:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8026bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026bf:	8b 40 04             	mov    0x4(%eax),%eax
  8026c2:	85 c0                	test   %eax,%eax
  8026c4:	74 0f                	je     8026d5 <alloc_block_NF+0x159>
  8026c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026c9:	8b 40 04             	mov    0x4(%eax),%eax
  8026cc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026cf:	8b 12                	mov    (%edx),%edx
  8026d1:	89 10                	mov    %edx,(%eax)
  8026d3:	eb 0a                	jmp    8026df <alloc_block_NF+0x163>
  8026d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026d8:	8b 00                	mov    (%eax),%eax
  8026da:	a3 48 41 80 00       	mov    %eax,0x804148
  8026df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026e2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026eb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026f2:	a1 54 41 80 00       	mov    0x804154,%eax
  8026f7:	48                   	dec    %eax
  8026f8:	a3 54 41 80 00       	mov    %eax,0x804154
				   svaOfNF = ReturnedBlock->sva;
  8026fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802700:	8b 40 08             	mov    0x8(%eax),%eax
  802703:	a3 28 40 80 00       	mov    %eax,0x804028
				   point->sva += size;
  802708:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270b:	8b 50 08             	mov    0x8(%eax),%edx
  80270e:	8b 45 08             	mov    0x8(%ebp),%eax
  802711:	01 c2                	add    %eax,%edx
  802713:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802716:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802719:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271c:	8b 40 0c             	mov    0xc(%eax),%eax
  80271f:	2b 45 08             	sub    0x8(%ebp),%eax
  802722:	89 c2                	mov    %eax,%edx
  802724:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802727:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  80272a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80272d:	e9 15 04 00 00       	jmp    802b47 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802732:	a1 40 41 80 00       	mov    0x804140,%eax
  802737:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80273a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80273e:	74 07                	je     802747 <alloc_block_NF+0x1cb>
  802740:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802743:	8b 00                	mov    (%eax),%eax
  802745:	eb 05                	jmp    80274c <alloc_block_NF+0x1d0>
  802747:	b8 00 00 00 00       	mov    $0x0,%eax
  80274c:	a3 40 41 80 00       	mov    %eax,0x804140
  802751:	a1 40 41 80 00       	mov    0x804140,%eax
  802756:	85 c0                	test   %eax,%eax
  802758:	0f 85 3e fe ff ff    	jne    80259c <alloc_block_NF+0x20>
  80275e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802762:	0f 85 34 fe ff ff    	jne    80259c <alloc_block_NF+0x20>
  802768:	e9 d5 03 00 00       	jmp    802b42 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  80276d:	a1 38 41 80 00       	mov    0x804138,%eax
  802772:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802775:	e9 b1 01 00 00       	jmp    80292b <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  80277a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277d:	8b 50 08             	mov    0x8(%eax),%edx
  802780:	a1 28 40 80 00       	mov    0x804028,%eax
  802785:	39 c2                	cmp    %eax,%edx
  802787:	0f 82 96 01 00 00    	jb     802923 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  80278d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802790:	8b 40 0c             	mov    0xc(%eax),%eax
  802793:	3b 45 08             	cmp    0x8(%ebp),%eax
  802796:	0f 82 87 01 00 00    	jb     802923 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  80279c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279f:	8b 40 0c             	mov    0xc(%eax),%eax
  8027a2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027a5:	0f 85 95 00 00 00    	jne    802840 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8027ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027af:	75 17                	jne    8027c8 <alloc_block_NF+0x24c>
  8027b1:	83 ec 04             	sub    $0x4,%esp
  8027b4:	68 78 3f 80 00       	push   $0x803f78
  8027b9:	68 fc 00 00 00       	push   $0xfc
  8027be:	68 cf 3e 80 00       	push   $0x803ecf
  8027c3:	e8 af da ff ff       	call   800277 <_panic>
  8027c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cb:	8b 00                	mov    (%eax),%eax
  8027cd:	85 c0                	test   %eax,%eax
  8027cf:	74 10                	je     8027e1 <alloc_block_NF+0x265>
  8027d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d4:	8b 00                	mov    (%eax),%eax
  8027d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027d9:	8b 52 04             	mov    0x4(%edx),%edx
  8027dc:	89 50 04             	mov    %edx,0x4(%eax)
  8027df:	eb 0b                	jmp    8027ec <alloc_block_NF+0x270>
  8027e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e4:	8b 40 04             	mov    0x4(%eax),%eax
  8027e7:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8027ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ef:	8b 40 04             	mov    0x4(%eax),%eax
  8027f2:	85 c0                	test   %eax,%eax
  8027f4:	74 0f                	je     802805 <alloc_block_NF+0x289>
  8027f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f9:	8b 40 04             	mov    0x4(%eax),%eax
  8027fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027ff:	8b 12                	mov    (%edx),%edx
  802801:	89 10                	mov    %edx,(%eax)
  802803:	eb 0a                	jmp    80280f <alloc_block_NF+0x293>
  802805:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802808:	8b 00                	mov    (%eax),%eax
  80280a:	a3 38 41 80 00       	mov    %eax,0x804138
  80280f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802812:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802818:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802822:	a1 44 41 80 00       	mov    0x804144,%eax
  802827:	48                   	dec    %eax
  802828:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  80282d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802830:	8b 40 08             	mov    0x8(%eax),%eax
  802833:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  802838:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283b:	e9 07 03 00 00       	jmp    802b47 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802840:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802843:	8b 40 0c             	mov    0xc(%eax),%eax
  802846:	3b 45 08             	cmp    0x8(%ebp),%eax
  802849:	0f 86 d4 00 00 00    	jbe    802923 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80284f:	a1 48 41 80 00       	mov    0x804148,%eax
  802854:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802857:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285a:	8b 50 08             	mov    0x8(%eax),%edx
  80285d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802860:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802863:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802866:	8b 55 08             	mov    0x8(%ebp),%edx
  802869:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80286c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802870:	75 17                	jne    802889 <alloc_block_NF+0x30d>
  802872:	83 ec 04             	sub    $0x4,%esp
  802875:	68 78 3f 80 00       	push   $0x803f78
  80287a:	68 04 01 00 00       	push   $0x104
  80287f:	68 cf 3e 80 00       	push   $0x803ecf
  802884:	e8 ee d9 ff ff       	call   800277 <_panic>
  802889:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80288c:	8b 00                	mov    (%eax),%eax
  80288e:	85 c0                	test   %eax,%eax
  802890:	74 10                	je     8028a2 <alloc_block_NF+0x326>
  802892:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802895:	8b 00                	mov    (%eax),%eax
  802897:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80289a:	8b 52 04             	mov    0x4(%edx),%edx
  80289d:	89 50 04             	mov    %edx,0x4(%eax)
  8028a0:	eb 0b                	jmp    8028ad <alloc_block_NF+0x331>
  8028a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028a5:	8b 40 04             	mov    0x4(%eax),%eax
  8028a8:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8028ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028b0:	8b 40 04             	mov    0x4(%eax),%eax
  8028b3:	85 c0                	test   %eax,%eax
  8028b5:	74 0f                	je     8028c6 <alloc_block_NF+0x34a>
  8028b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028ba:	8b 40 04             	mov    0x4(%eax),%eax
  8028bd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8028c0:	8b 12                	mov    (%edx),%edx
  8028c2:	89 10                	mov    %edx,(%eax)
  8028c4:	eb 0a                	jmp    8028d0 <alloc_block_NF+0x354>
  8028c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028c9:	8b 00                	mov    (%eax),%eax
  8028cb:	a3 48 41 80 00       	mov    %eax,0x804148
  8028d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028dc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028e3:	a1 54 41 80 00       	mov    0x804154,%eax
  8028e8:	48                   	dec    %eax
  8028e9:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  8028ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028f1:	8b 40 08             	mov    0x8(%eax),%eax
  8028f4:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  8028f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fc:	8b 50 08             	mov    0x8(%eax),%edx
  8028ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802902:	01 c2                	add    %eax,%edx
  802904:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802907:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  80290a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290d:	8b 40 0c             	mov    0xc(%eax),%eax
  802910:	2b 45 08             	sub    0x8(%ebp),%eax
  802913:	89 c2                	mov    %eax,%edx
  802915:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802918:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  80291b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80291e:	e9 24 02 00 00       	jmp    802b47 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802923:	a1 40 41 80 00       	mov    0x804140,%eax
  802928:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80292b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80292f:	74 07                	je     802938 <alloc_block_NF+0x3bc>
  802931:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802934:	8b 00                	mov    (%eax),%eax
  802936:	eb 05                	jmp    80293d <alloc_block_NF+0x3c1>
  802938:	b8 00 00 00 00       	mov    $0x0,%eax
  80293d:	a3 40 41 80 00       	mov    %eax,0x804140
  802942:	a1 40 41 80 00       	mov    0x804140,%eax
  802947:	85 c0                	test   %eax,%eax
  802949:	0f 85 2b fe ff ff    	jne    80277a <alloc_block_NF+0x1fe>
  80294f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802953:	0f 85 21 fe ff ff    	jne    80277a <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802959:	a1 38 41 80 00       	mov    0x804138,%eax
  80295e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802961:	e9 ae 01 00 00       	jmp    802b14 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802966:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802969:	8b 50 08             	mov    0x8(%eax),%edx
  80296c:	a1 28 40 80 00       	mov    0x804028,%eax
  802971:	39 c2                	cmp    %eax,%edx
  802973:	0f 83 93 01 00 00    	jae    802b0c <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802979:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297c:	8b 40 0c             	mov    0xc(%eax),%eax
  80297f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802982:	0f 82 84 01 00 00    	jb     802b0c <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802988:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298b:	8b 40 0c             	mov    0xc(%eax),%eax
  80298e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802991:	0f 85 95 00 00 00    	jne    802a2c <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802997:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80299b:	75 17                	jne    8029b4 <alloc_block_NF+0x438>
  80299d:	83 ec 04             	sub    $0x4,%esp
  8029a0:	68 78 3f 80 00       	push   $0x803f78
  8029a5:	68 14 01 00 00       	push   $0x114
  8029aa:	68 cf 3e 80 00       	push   $0x803ecf
  8029af:	e8 c3 d8 ff ff       	call   800277 <_panic>
  8029b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b7:	8b 00                	mov    (%eax),%eax
  8029b9:	85 c0                	test   %eax,%eax
  8029bb:	74 10                	je     8029cd <alloc_block_NF+0x451>
  8029bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c0:	8b 00                	mov    (%eax),%eax
  8029c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029c5:	8b 52 04             	mov    0x4(%edx),%edx
  8029c8:	89 50 04             	mov    %edx,0x4(%eax)
  8029cb:	eb 0b                	jmp    8029d8 <alloc_block_NF+0x45c>
  8029cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d0:	8b 40 04             	mov    0x4(%eax),%eax
  8029d3:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8029d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029db:	8b 40 04             	mov    0x4(%eax),%eax
  8029de:	85 c0                	test   %eax,%eax
  8029e0:	74 0f                	je     8029f1 <alloc_block_NF+0x475>
  8029e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e5:	8b 40 04             	mov    0x4(%eax),%eax
  8029e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029eb:	8b 12                	mov    (%edx),%edx
  8029ed:	89 10                	mov    %edx,(%eax)
  8029ef:	eb 0a                	jmp    8029fb <alloc_block_NF+0x47f>
  8029f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f4:	8b 00                	mov    (%eax),%eax
  8029f6:	a3 38 41 80 00       	mov    %eax,0x804138
  8029fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a07:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a0e:	a1 44 41 80 00       	mov    0x804144,%eax
  802a13:	48                   	dec    %eax
  802a14:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  802a19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1c:	8b 40 08             	mov    0x8(%eax),%eax
  802a1f:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  802a24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a27:	e9 1b 01 00 00       	jmp    802b47 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802a2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2f:	8b 40 0c             	mov    0xc(%eax),%eax
  802a32:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a35:	0f 86 d1 00 00 00    	jbe    802b0c <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802a3b:	a1 48 41 80 00       	mov    0x804148,%eax
  802a40:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802a43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a46:	8b 50 08             	mov    0x8(%eax),%edx
  802a49:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a4c:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802a4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a52:	8b 55 08             	mov    0x8(%ebp),%edx
  802a55:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802a58:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a5c:	75 17                	jne    802a75 <alloc_block_NF+0x4f9>
  802a5e:	83 ec 04             	sub    $0x4,%esp
  802a61:	68 78 3f 80 00       	push   $0x803f78
  802a66:	68 1c 01 00 00       	push   $0x11c
  802a6b:	68 cf 3e 80 00       	push   $0x803ecf
  802a70:	e8 02 d8 ff ff       	call   800277 <_panic>
  802a75:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a78:	8b 00                	mov    (%eax),%eax
  802a7a:	85 c0                	test   %eax,%eax
  802a7c:	74 10                	je     802a8e <alloc_block_NF+0x512>
  802a7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a81:	8b 00                	mov    (%eax),%eax
  802a83:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a86:	8b 52 04             	mov    0x4(%edx),%edx
  802a89:	89 50 04             	mov    %edx,0x4(%eax)
  802a8c:	eb 0b                	jmp    802a99 <alloc_block_NF+0x51d>
  802a8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a91:	8b 40 04             	mov    0x4(%eax),%eax
  802a94:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802a99:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a9c:	8b 40 04             	mov    0x4(%eax),%eax
  802a9f:	85 c0                	test   %eax,%eax
  802aa1:	74 0f                	je     802ab2 <alloc_block_NF+0x536>
  802aa3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aa6:	8b 40 04             	mov    0x4(%eax),%eax
  802aa9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802aac:	8b 12                	mov    (%edx),%edx
  802aae:	89 10                	mov    %edx,(%eax)
  802ab0:	eb 0a                	jmp    802abc <alloc_block_NF+0x540>
  802ab2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ab5:	8b 00                	mov    (%eax),%eax
  802ab7:	a3 48 41 80 00       	mov    %eax,0x804148
  802abc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802abf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ac5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ac8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802acf:	a1 54 41 80 00       	mov    0x804154,%eax
  802ad4:	48                   	dec    %eax
  802ad5:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  802ada:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802add:	8b 40 08             	mov    0x8(%eax),%eax
  802ae0:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  802ae5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae8:	8b 50 08             	mov    0x8(%eax),%edx
  802aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  802aee:	01 c2                	add    %eax,%edx
  802af0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af3:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802af6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af9:	8b 40 0c             	mov    0xc(%eax),%eax
  802afc:	2b 45 08             	sub    0x8(%ebp),%eax
  802aff:	89 c2                	mov    %eax,%edx
  802b01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b04:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802b07:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b0a:	eb 3b                	jmp    802b47 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b0c:	a1 40 41 80 00       	mov    0x804140,%eax
  802b11:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b14:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b18:	74 07                	je     802b21 <alloc_block_NF+0x5a5>
  802b1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1d:	8b 00                	mov    (%eax),%eax
  802b1f:	eb 05                	jmp    802b26 <alloc_block_NF+0x5aa>
  802b21:	b8 00 00 00 00       	mov    $0x0,%eax
  802b26:	a3 40 41 80 00       	mov    %eax,0x804140
  802b2b:	a1 40 41 80 00       	mov    0x804140,%eax
  802b30:	85 c0                	test   %eax,%eax
  802b32:	0f 85 2e fe ff ff    	jne    802966 <alloc_block_NF+0x3ea>
  802b38:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b3c:	0f 85 24 fe ff ff    	jne    802966 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802b42:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b47:	c9                   	leave  
  802b48:	c3                   	ret    

00802b49 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802b49:	55                   	push   %ebp
  802b4a:	89 e5                	mov    %esp,%ebp
  802b4c:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802b4f:	a1 38 41 80 00       	mov    0x804138,%eax
  802b54:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802b57:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b5c:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802b5f:	a1 38 41 80 00       	mov    0x804138,%eax
  802b64:	85 c0                	test   %eax,%eax
  802b66:	74 14                	je     802b7c <insert_sorted_with_merge_freeList+0x33>
  802b68:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6b:	8b 50 08             	mov    0x8(%eax),%edx
  802b6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b71:	8b 40 08             	mov    0x8(%eax),%eax
  802b74:	39 c2                	cmp    %eax,%edx
  802b76:	0f 87 9b 01 00 00    	ja     802d17 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802b7c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b80:	75 17                	jne    802b99 <insert_sorted_with_merge_freeList+0x50>
  802b82:	83 ec 04             	sub    $0x4,%esp
  802b85:	68 ac 3e 80 00       	push   $0x803eac
  802b8a:	68 38 01 00 00       	push   $0x138
  802b8f:	68 cf 3e 80 00       	push   $0x803ecf
  802b94:	e8 de d6 ff ff       	call   800277 <_panic>
  802b99:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba2:	89 10                	mov    %edx,(%eax)
  802ba4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba7:	8b 00                	mov    (%eax),%eax
  802ba9:	85 c0                	test   %eax,%eax
  802bab:	74 0d                	je     802bba <insert_sorted_with_merge_freeList+0x71>
  802bad:	a1 38 41 80 00       	mov    0x804138,%eax
  802bb2:	8b 55 08             	mov    0x8(%ebp),%edx
  802bb5:	89 50 04             	mov    %edx,0x4(%eax)
  802bb8:	eb 08                	jmp    802bc2 <insert_sorted_with_merge_freeList+0x79>
  802bba:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbd:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc5:	a3 38 41 80 00       	mov    %eax,0x804138
  802bca:	8b 45 08             	mov    0x8(%ebp),%eax
  802bcd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bd4:	a1 44 41 80 00       	mov    0x804144,%eax
  802bd9:	40                   	inc    %eax
  802bda:	a3 44 41 80 00       	mov    %eax,0x804144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802bdf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802be3:	0f 84 a8 06 00 00    	je     803291 <insert_sorted_with_merge_freeList+0x748>
  802be9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bec:	8b 50 08             	mov    0x8(%eax),%edx
  802bef:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf2:	8b 40 0c             	mov    0xc(%eax),%eax
  802bf5:	01 c2                	add    %eax,%edx
  802bf7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bfa:	8b 40 08             	mov    0x8(%eax),%eax
  802bfd:	39 c2                	cmp    %eax,%edx
  802bff:	0f 85 8c 06 00 00    	jne    803291 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802c05:	8b 45 08             	mov    0x8(%ebp),%eax
  802c08:	8b 50 0c             	mov    0xc(%eax),%edx
  802c0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c0e:	8b 40 0c             	mov    0xc(%eax),%eax
  802c11:	01 c2                	add    %eax,%edx
  802c13:	8b 45 08             	mov    0x8(%ebp),%eax
  802c16:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802c19:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c1d:	75 17                	jne    802c36 <insert_sorted_with_merge_freeList+0xed>
  802c1f:	83 ec 04             	sub    $0x4,%esp
  802c22:	68 78 3f 80 00       	push   $0x803f78
  802c27:	68 3c 01 00 00       	push   $0x13c
  802c2c:	68 cf 3e 80 00       	push   $0x803ecf
  802c31:	e8 41 d6 ff ff       	call   800277 <_panic>
  802c36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c39:	8b 00                	mov    (%eax),%eax
  802c3b:	85 c0                	test   %eax,%eax
  802c3d:	74 10                	je     802c4f <insert_sorted_with_merge_freeList+0x106>
  802c3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c42:	8b 00                	mov    (%eax),%eax
  802c44:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c47:	8b 52 04             	mov    0x4(%edx),%edx
  802c4a:	89 50 04             	mov    %edx,0x4(%eax)
  802c4d:	eb 0b                	jmp    802c5a <insert_sorted_with_merge_freeList+0x111>
  802c4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c52:	8b 40 04             	mov    0x4(%eax),%eax
  802c55:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c5d:	8b 40 04             	mov    0x4(%eax),%eax
  802c60:	85 c0                	test   %eax,%eax
  802c62:	74 0f                	je     802c73 <insert_sorted_with_merge_freeList+0x12a>
  802c64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c67:	8b 40 04             	mov    0x4(%eax),%eax
  802c6a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c6d:	8b 12                	mov    (%edx),%edx
  802c6f:	89 10                	mov    %edx,(%eax)
  802c71:	eb 0a                	jmp    802c7d <insert_sorted_with_merge_freeList+0x134>
  802c73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c76:	8b 00                	mov    (%eax),%eax
  802c78:	a3 38 41 80 00       	mov    %eax,0x804138
  802c7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c80:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c89:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c90:	a1 44 41 80 00       	mov    0x804144,%eax
  802c95:	48                   	dec    %eax
  802c96:	a3 44 41 80 00       	mov    %eax,0x804144
			head->size = 0;
  802c9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c9e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802ca5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ca8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802caf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cb3:	75 17                	jne    802ccc <insert_sorted_with_merge_freeList+0x183>
  802cb5:	83 ec 04             	sub    $0x4,%esp
  802cb8:	68 ac 3e 80 00       	push   $0x803eac
  802cbd:	68 3f 01 00 00       	push   $0x13f
  802cc2:	68 cf 3e 80 00       	push   $0x803ecf
  802cc7:	e8 ab d5 ff ff       	call   800277 <_panic>
  802ccc:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802cd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cd5:	89 10                	mov    %edx,(%eax)
  802cd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cda:	8b 00                	mov    (%eax),%eax
  802cdc:	85 c0                	test   %eax,%eax
  802cde:	74 0d                	je     802ced <insert_sorted_with_merge_freeList+0x1a4>
  802ce0:	a1 48 41 80 00       	mov    0x804148,%eax
  802ce5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ce8:	89 50 04             	mov    %edx,0x4(%eax)
  802ceb:	eb 08                	jmp    802cf5 <insert_sorted_with_merge_freeList+0x1ac>
  802ced:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf0:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802cf5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf8:	a3 48 41 80 00       	mov    %eax,0x804148
  802cfd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d00:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d07:	a1 54 41 80 00       	mov    0x804154,%eax
  802d0c:	40                   	inc    %eax
  802d0d:	a3 54 41 80 00       	mov    %eax,0x804154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802d12:	e9 7a 05 00 00       	jmp    803291 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802d17:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1a:	8b 50 08             	mov    0x8(%eax),%edx
  802d1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d20:	8b 40 08             	mov    0x8(%eax),%eax
  802d23:	39 c2                	cmp    %eax,%edx
  802d25:	0f 82 14 01 00 00    	jb     802e3f <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802d2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d2e:	8b 50 08             	mov    0x8(%eax),%edx
  802d31:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d34:	8b 40 0c             	mov    0xc(%eax),%eax
  802d37:	01 c2                	add    %eax,%edx
  802d39:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3c:	8b 40 08             	mov    0x8(%eax),%eax
  802d3f:	39 c2                	cmp    %eax,%edx
  802d41:	0f 85 90 00 00 00    	jne    802dd7 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802d47:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d4a:	8b 50 0c             	mov    0xc(%eax),%edx
  802d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d50:	8b 40 0c             	mov    0xc(%eax),%eax
  802d53:	01 c2                	add    %eax,%edx
  802d55:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d58:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802d65:	8b 45 08             	mov    0x8(%ebp),%eax
  802d68:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802d6f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d73:	75 17                	jne    802d8c <insert_sorted_with_merge_freeList+0x243>
  802d75:	83 ec 04             	sub    $0x4,%esp
  802d78:	68 ac 3e 80 00       	push   $0x803eac
  802d7d:	68 49 01 00 00       	push   $0x149
  802d82:	68 cf 3e 80 00       	push   $0x803ecf
  802d87:	e8 eb d4 ff ff       	call   800277 <_panic>
  802d8c:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d92:	8b 45 08             	mov    0x8(%ebp),%eax
  802d95:	89 10                	mov    %edx,(%eax)
  802d97:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9a:	8b 00                	mov    (%eax),%eax
  802d9c:	85 c0                	test   %eax,%eax
  802d9e:	74 0d                	je     802dad <insert_sorted_with_merge_freeList+0x264>
  802da0:	a1 48 41 80 00       	mov    0x804148,%eax
  802da5:	8b 55 08             	mov    0x8(%ebp),%edx
  802da8:	89 50 04             	mov    %edx,0x4(%eax)
  802dab:	eb 08                	jmp    802db5 <insert_sorted_with_merge_freeList+0x26c>
  802dad:	8b 45 08             	mov    0x8(%ebp),%eax
  802db0:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802db5:	8b 45 08             	mov    0x8(%ebp),%eax
  802db8:	a3 48 41 80 00       	mov    %eax,0x804148
  802dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dc7:	a1 54 41 80 00       	mov    0x804154,%eax
  802dcc:	40                   	inc    %eax
  802dcd:	a3 54 41 80 00       	mov    %eax,0x804154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802dd2:	e9 bb 04 00 00       	jmp    803292 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802dd7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ddb:	75 17                	jne    802df4 <insert_sorted_with_merge_freeList+0x2ab>
  802ddd:	83 ec 04             	sub    $0x4,%esp
  802de0:	68 20 3f 80 00       	push   $0x803f20
  802de5:	68 4c 01 00 00       	push   $0x14c
  802dea:	68 cf 3e 80 00       	push   $0x803ecf
  802def:	e8 83 d4 ff ff       	call   800277 <_panic>
  802df4:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfd:	89 50 04             	mov    %edx,0x4(%eax)
  802e00:	8b 45 08             	mov    0x8(%ebp),%eax
  802e03:	8b 40 04             	mov    0x4(%eax),%eax
  802e06:	85 c0                	test   %eax,%eax
  802e08:	74 0c                	je     802e16 <insert_sorted_with_merge_freeList+0x2cd>
  802e0a:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802e0f:	8b 55 08             	mov    0x8(%ebp),%edx
  802e12:	89 10                	mov    %edx,(%eax)
  802e14:	eb 08                	jmp    802e1e <insert_sorted_with_merge_freeList+0x2d5>
  802e16:	8b 45 08             	mov    0x8(%ebp),%eax
  802e19:	a3 38 41 80 00       	mov    %eax,0x804138
  802e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e21:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802e26:	8b 45 08             	mov    0x8(%ebp),%eax
  802e29:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e2f:	a1 44 41 80 00       	mov    0x804144,%eax
  802e34:	40                   	inc    %eax
  802e35:	a3 44 41 80 00       	mov    %eax,0x804144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802e3a:	e9 53 04 00 00       	jmp    803292 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802e3f:	a1 38 41 80 00       	mov    0x804138,%eax
  802e44:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e47:	e9 15 04 00 00       	jmp    803261 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802e4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4f:	8b 00                	mov    (%eax),%eax
  802e51:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802e54:	8b 45 08             	mov    0x8(%ebp),%eax
  802e57:	8b 50 08             	mov    0x8(%eax),%edx
  802e5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5d:	8b 40 08             	mov    0x8(%eax),%eax
  802e60:	39 c2                	cmp    %eax,%edx
  802e62:	0f 86 f1 03 00 00    	jbe    803259 <insert_sorted_with_merge_freeList+0x710>
  802e68:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6b:	8b 50 08             	mov    0x8(%eax),%edx
  802e6e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e71:	8b 40 08             	mov    0x8(%eax),%eax
  802e74:	39 c2                	cmp    %eax,%edx
  802e76:	0f 83 dd 03 00 00    	jae    803259 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802e7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7f:	8b 50 08             	mov    0x8(%eax),%edx
  802e82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e85:	8b 40 0c             	mov    0xc(%eax),%eax
  802e88:	01 c2                	add    %eax,%edx
  802e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8d:	8b 40 08             	mov    0x8(%eax),%eax
  802e90:	39 c2                	cmp    %eax,%edx
  802e92:	0f 85 b9 01 00 00    	jne    803051 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802e98:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9b:	8b 50 08             	mov    0x8(%eax),%edx
  802e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ea4:	01 c2                	add    %eax,%edx
  802ea6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ea9:	8b 40 08             	mov    0x8(%eax),%eax
  802eac:	39 c2                	cmp    %eax,%edx
  802eae:	0f 85 0d 01 00 00    	jne    802fc1 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802eb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb7:	8b 50 0c             	mov    0xc(%eax),%edx
  802eba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ebd:	8b 40 0c             	mov    0xc(%eax),%eax
  802ec0:	01 c2                	add    %eax,%edx
  802ec2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec5:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802ec8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ecc:	75 17                	jne    802ee5 <insert_sorted_with_merge_freeList+0x39c>
  802ece:	83 ec 04             	sub    $0x4,%esp
  802ed1:	68 78 3f 80 00       	push   $0x803f78
  802ed6:	68 5c 01 00 00       	push   $0x15c
  802edb:	68 cf 3e 80 00       	push   $0x803ecf
  802ee0:	e8 92 d3 ff ff       	call   800277 <_panic>
  802ee5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ee8:	8b 00                	mov    (%eax),%eax
  802eea:	85 c0                	test   %eax,%eax
  802eec:	74 10                	je     802efe <insert_sorted_with_merge_freeList+0x3b5>
  802eee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ef1:	8b 00                	mov    (%eax),%eax
  802ef3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ef6:	8b 52 04             	mov    0x4(%edx),%edx
  802ef9:	89 50 04             	mov    %edx,0x4(%eax)
  802efc:	eb 0b                	jmp    802f09 <insert_sorted_with_merge_freeList+0x3c0>
  802efe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f01:	8b 40 04             	mov    0x4(%eax),%eax
  802f04:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802f09:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f0c:	8b 40 04             	mov    0x4(%eax),%eax
  802f0f:	85 c0                	test   %eax,%eax
  802f11:	74 0f                	je     802f22 <insert_sorted_with_merge_freeList+0x3d9>
  802f13:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f16:	8b 40 04             	mov    0x4(%eax),%eax
  802f19:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f1c:	8b 12                	mov    (%edx),%edx
  802f1e:	89 10                	mov    %edx,(%eax)
  802f20:	eb 0a                	jmp    802f2c <insert_sorted_with_merge_freeList+0x3e3>
  802f22:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f25:	8b 00                	mov    (%eax),%eax
  802f27:	a3 38 41 80 00       	mov    %eax,0x804138
  802f2c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f2f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f35:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f38:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f3f:	a1 44 41 80 00       	mov    0x804144,%eax
  802f44:	48                   	dec    %eax
  802f45:	a3 44 41 80 00       	mov    %eax,0x804144
						nextBlock->sva = 0;
  802f4a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f4d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  802f54:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f57:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  802f5e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f62:	75 17                	jne    802f7b <insert_sorted_with_merge_freeList+0x432>
  802f64:	83 ec 04             	sub    $0x4,%esp
  802f67:	68 ac 3e 80 00       	push   $0x803eac
  802f6c:	68 5f 01 00 00       	push   $0x15f
  802f71:	68 cf 3e 80 00       	push   $0x803ecf
  802f76:	e8 fc d2 ff ff       	call   800277 <_panic>
  802f7b:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f81:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f84:	89 10                	mov    %edx,(%eax)
  802f86:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f89:	8b 00                	mov    (%eax),%eax
  802f8b:	85 c0                	test   %eax,%eax
  802f8d:	74 0d                	je     802f9c <insert_sorted_with_merge_freeList+0x453>
  802f8f:	a1 48 41 80 00       	mov    0x804148,%eax
  802f94:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f97:	89 50 04             	mov    %edx,0x4(%eax)
  802f9a:	eb 08                	jmp    802fa4 <insert_sorted_with_merge_freeList+0x45b>
  802f9c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f9f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802fa4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fa7:	a3 48 41 80 00       	mov    %eax,0x804148
  802fac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802faf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fb6:	a1 54 41 80 00       	mov    0x804154,%eax
  802fbb:	40                   	inc    %eax
  802fbc:	a3 54 41 80 00       	mov    %eax,0x804154
					}
					currentBlock->size += blockToInsert->size;
  802fc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc4:	8b 50 0c             	mov    0xc(%eax),%edx
  802fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  802fca:	8b 40 0c             	mov    0xc(%eax),%eax
  802fcd:	01 c2                	add    %eax,%edx
  802fcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd2:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  802fd5:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  802fdf:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802fe9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fed:	75 17                	jne    803006 <insert_sorted_with_merge_freeList+0x4bd>
  802fef:	83 ec 04             	sub    $0x4,%esp
  802ff2:	68 ac 3e 80 00       	push   $0x803eac
  802ff7:	68 64 01 00 00       	push   $0x164
  802ffc:	68 cf 3e 80 00       	push   $0x803ecf
  803001:	e8 71 d2 ff ff       	call   800277 <_panic>
  803006:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80300c:	8b 45 08             	mov    0x8(%ebp),%eax
  80300f:	89 10                	mov    %edx,(%eax)
  803011:	8b 45 08             	mov    0x8(%ebp),%eax
  803014:	8b 00                	mov    (%eax),%eax
  803016:	85 c0                	test   %eax,%eax
  803018:	74 0d                	je     803027 <insert_sorted_with_merge_freeList+0x4de>
  80301a:	a1 48 41 80 00       	mov    0x804148,%eax
  80301f:	8b 55 08             	mov    0x8(%ebp),%edx
  803022:	89 50 04             	mov    %edx,0x4(%eax)
  803025:	eb 08                	jmp    80302f <insert_sorted_with_merge_freeList+0x4e6>
  803027:	8b 45 08             	mov    0x8(%ebp),%eax
  80302a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80302f:	8b 45 08             	mov    0x8(%ebp),%eax
  803032:	a3 48 41 80 00       	mov    %eax,0x804148
  803037:	8b 45 08             	mov    0x8(%ebp),%eax
  80303a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803041:	a1 54 41 80 00       	mov    0x804154,%eax
  803046:	40                   	inc    %eax
  803047:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  80304c:	e9 41 02 00 00       	jmp    803292 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803051:	8b 45 08             	mov    0x8(%ebp),%eax
  803054:	8b 50 08             	mov    0x8(%eax),%edx
  803057:	8b 45 08             	mov    0x8(%ebp),%eax
  80305a:	8b 40 0c             	mov    0xc(%eax),%eax
  80305d:	01 c2                	add    %eax,%edx
  80305f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803062:	8b 40 08             	mov    0x8(%eax),%eax
  803065:	39 c2                	cmp    %eax,%edx
  803067:	0f 85 7c 01 00 00    	jne    8031e9 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  80306d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803071:	74 06                	je     803079 <insert_sorted_with_merge_freeList+0x530>
  803073:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803077:	75 17                	jne    803090 <insert_sorted_with_merge_freeList+0x547>
  803079:	83 ec 04             	sub    $0x4,%esp
  80307c:	68 e8 3e 80 00       	push   $0x803ee8
  803081:	68 69 01 00 00       	push   $0x169
  803086:	68 cf 3e 80 00       	push   $0x803ecf
  80308b:	e8 e7 d1 ff ff       	call   800277 <_panic>
  803090:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803093:	8b 50 04             	mov    0x4(%eax),%edx
  803096:	8b 45 08             	mov    0x8(%ebp),%eax
  803099:	89 50 04             	mov    %edx,0x4(%eax)
  80309c:	8b 45 08             	mov    0x8(%ebp),%eax
  80309f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030a2:	89 10                	mov    %edx,(%eax)
  8030a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030a7:	8b 40 04             	mov    0x4(%eax),%eax
  8030aa:	85 c0                	test   %eax,%eax
  8030ac:	74 0d                	je     8030bb <insert_sorted_with_merge_freeList+0x572>
  8030ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030b1:	8b 40 04             	mov    0x4(%eax),%eax
  8030b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8030b7:	89 10                	mov    %edx,(%eax)
  8030b9:	eb 08                	jmp    8030c3 <insert_sorted_with_merge_freeList+0x57a>
  8030bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8030be:	a3 38 41 80 00       	mov    %eax,0x804138
  8030c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8030c9:	89 50 04             	mov    %edx,0x4(%eax)
  8030cc:	a1 44 41 80 00       	mov    0x804144,%eax
  8030d1:	40                   	inc    %eax
  8030d2:	a3 44 41 80 00       	mov    %eax,0x804144
					blockToInsert->size += nextBlock->size;
  8030d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030da:	8b 50 0c             	mov    0xc(%eax),%edx
  8030dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030e0:	8b 40 0c             	mov    0xc(%eax),%eax
  8030e3:	01 c2                	add    %eax,%edx
  8030e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e8:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8030eb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030ef:	75 17                	jne    803108 <insert_sorted_with_merge_freeList+0x5bf>
  8030f1:	83 ec 04             	sub    $0x4,%esp
  8030f4:	68 78 3f 80 00       	push   $0x803f78
  8030f9:	68 6b 01 00 00       	push   $0x16b
  8030fe:	68 cf 3e 80 00       	push   $0x803ecf
  803103:	e8 6f d1 ff ff       	call   800277 <_panic>
  803108:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80310b:	8b 00                	mov    (%eax),%eax
  80310d:	85 c0                	test   %eax,%eax
  80310f:	74 10                	je     803121 <insert_sorted_with_merge_freeList+0x5d8>
  803111:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803114:	8b 00                	mov    (%eax),%eax
  803116:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803119:	8b 52 04             	mov    0x4(%edx),%edx
  80311c:	89 50 04             	mov    %edx,0x4(%eax)
  80311f:	eb 0b                	jmp    80312c <insert_sorted_with_merge_freeList+0x5e3>
  803121:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803124:	8b 40 04             	mov    0x4(%eax),%eax
  803127:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80312c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80312f:	8b 40 04             	mov    0x4(%eax),%eax
  803132:	85 c0                	test   %eax,%eax
  803134:	74 0f                	je     803145 <insert_sorted_with_merge_freeList+0x5fc>
  803136:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803139:	8b 40 04             	mov    0x4(%eax),%eax
  80313c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80313f:	8b 12                	mov    (%edx),%edx
  803141:	89 10                	mov    %edx,(%eax)
  803143:	eb 0a                	jmp    80314f <insert_sorted_with_merge_freeList+0x606>
  803145:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803148:	8b 00                	mov    (%eax),%eax
  80314a:	a3 38 41 80 00       	mov    %eax,0x804138
  80314f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803152:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803158:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80315b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803162:	a1 44 41 80 00       	mov    0x804144,%eax
  803167:	48                   	dec    %eax
  803168:	a3 44 41 80 00       	mov    %eax,0x804144
					nextBlock->sva = 0;
  80316d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803170:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803177:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80317a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803181:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803185:	75 17                	jne    80319e <insert_sorted_with_merge_freeList+0x655>
  803187:	83 ec 04             	sub    $0x4,%esp
  80318a:	68 ac 3e 80 00       	push   $0x803eac
  80318f:	68 6e 01 00 00       	push   $0x16e
  803194:	68 cf 3e 80 00       	push   $0x803ecf
  803199:	e8 d9 d0 ff ff       	call   800277 <_panic>
  80319e:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8031a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031a7:	89 10                	mov    %edx,(%eax)
  8031a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ac:	8b 00                	mov    (%eax),%eax
  8031ae:	85 c0                	test   %eax,%eax
  8031b0:	74 0d                	je     8031bf <insert_sorted_with_merge_freeList+0x676>
  8031b2:	a1 48 41 80 00       	mov    0x804148,%eax
  8031b7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031ba:	89 50 04             	mov    %edx,0x4(%eax)
  8031bd:	eb 08                	jmp    8031c7 <insert_sorted_with_merge_freeList+0x67e>
  8031bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c2:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8031c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ca:	a3 48 41 80 00       	mov    %eax,0x804148
  8031cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031d9:	a1 54 41 80 00       	mov    0x804154,%eax
  8031de:	40                   	inc    %eax
  8031df:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  8031e4:	e9 a9 00 00 00       	jmp    803292 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8031e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031ed:	74 06                	je     8031f5 <insert_sorted_with_merge_freeList+0x6ac>
  8031ef:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031f3:	75 17                	jne    80320c <insert_sorted_with_merge_freeList+0x6c3>
  8031f5:	83 ec 04             	sub    $0x4,%esp
  8031f8:	68 44 3f 80 00       	push   $0x803f44
  8031fd:	68 73 01 00 00       	push   $0x173
  803202:	68 cf 3e 80 00       	push   $0x803ecf
  803207:	e8 6b d0 ff ff       	call   800277 <_panic>
  80320c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80320f:	8b 10                	mov    (%eax),%edx
  803211:	8b 45 08             	mov    0x8(%ebp),%eax
  803214:	89 10                	mov    %edx,(%eax)
  803216:	8b 45 08             	mov    0x8(%ebp),%eax
  803219:	8b 00                	mov    (%eax),%eax
  80321b:	85 c0                	test   %eax,%eax
  80321d:	74 0b                	je     80322a <insert_sorted_with_merge_freeList+0x6e1>
  80321f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803222:	8b 00                	mov    (%eax),%eax
  803224:	8b 55 08             	mov    0x8(%ebp),%edx
  803227:	89 50 04             	mov    %edx,0x4(%eax)
  80322a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80322d:	8b 55 08             	mov    0x8(%ebp),%edx
  803230:	89 10                	mov    %edx,(%eax)
  803232:	8b 45 08             	mov    0x8(%ebp),%eax
  803235:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803238:	89 50 04             	mov    %edx,0x4(%eax)
  80323b:	8b 45 08             	mov    0x8(%ebp),%eax
  80323e:	8b 00                	mov    (%eax),%eax
  803240:	85 c0                	test   %eax,%eax
  803242:	75 08                	jne    80324c <insert_sorted_with_merge_freeList+0x703>
  803244:	8b 45 08             	mov    0x8(%ebp),%eax
  803247:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80324c:	a1 44 41 80 00       	mov    0x804144,%eax
  803251:	40                   	inc    %eax
  803252:	a3 44 41 80 00       	mov    %eax,0x804144
					break;
  803257:	eb 39                	jmp    803292 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803259:	a1 40 41 80 00       	mov    0x804140,%eax
  80325e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803261:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803265:	74 07                	je     80326e <insert_sorted_with_merge_freeList+0x725>
  803267:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80326a:	8b 00                	mov    (%eax),%eax
  80326c:	eb 05                	jmp    803273 <insert_sorted_with_merge_freeList+0x72a>
  80326e:	b8 00 00 00 00       	mov    $0x0,%eax
  803273:	a3 40 41 80 00       	mov    %eax,0x804140
  803278:	a1 40 41 80 00       	mov    0x804140,%eax
  80327d:	85 c0                	test   %eax,%eax
  80327f:	0f 85 c7 fb ff ff    	jne    802e4c <insert_sorted_with_merge_freeList+0x303>
  803285:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803289:	0f 85 bd fb ff ff    	jne    802e4c <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80328f:	eb 01                	jmp    803292 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803291:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803292:	90                   	nop
  803293:	c9                   	leave  
  803294:	c3                   	ret    

00803295 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803295:	55                   	push   %ebp
  803296:	89 e5                	mov    %esp,%ebp
  803298:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  80329b:	8b 55 08             	mov    0x8(%ebp),%edx
  80329e:	89 d0                	mov    %edx,%eax
  8032a0:	c1 e0 02             	shl    $0x2,%eax
  8032a3:	01 d0                	add    %edx,%eax
  8032a5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8032ac:	01 d0                	add    %edx,%eax
  8032ae:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8032b5:	01 d0                	add    %edx,%eax
  8032b7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8032be:	01 d0                	add    %edx,%eax
  8032c0:	c1 e0 04             	shl    $0x4,%eax
  8032c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8032c6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8032cd:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8032d0:	83 ec 0c             	sub    $0xc,%esp
  8032d3:	50                   	push   %eax
  8032d4:	e8 26 e7 ff ff       	call   8019ff <sys_get_virtual_time>
  8032d9:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8032dc:	eb 41                	jmp    80331f <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8032de:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8032e1:	83 ec 0c             	sub    $0xc,%esp
  8032e4:	50                   	push   %eax
  8032e5:	e8 15 e7 ff ff       	call   8019ff <sys_get_virtual_time>
  8032ea:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8032ed:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8032f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032f3:	29 c2                	sub    %eax,%edx
  8032f5:	89 d0                	mov    %edx,%eax
  8032f7:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8032fa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8032fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803300:	89 d1                	mov    %edx,%ecx
  803302:	29 c1                	sub    %eax,%ecx
  803304:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803307:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80330a:	39 c2                	cmp    %eax,%edx
  80330c:	0f 97 c0             	seta   %al
  80330f:	0f b6 c0             	movzbl %al,%eax
  803312:	29 c1                	sub    %eax,%ecx
  803314:	89 c8                	mov    %ecx,%eax
  803316:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803319:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80331c:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  80331f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803322:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803325:	72 b7                	jb     8032de <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803327:	90                   	nop
  803328:	c9                   	leave  
  803329:	c3                   	ret    

0080332a <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  80332a:	55                   	push   %ebp
  80332b:	89 e5                	mov    %esp,%ebp
  80332d:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803330:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803337:	eb 03                	jmp    80333c <busy_wait+0x12>
  803339:	ff 45 fc             	incl   -0x4(%ebp)
  80333c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80333f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803342:	72 f5                	jb     803339 <busy_wait+0xf>
	return i;
  803344:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803347:	c9                   	leave  
  803348:	c3                   	ret    
  803349:	66 90                	xchg   %ax,%ax
  80334b:	90                   	nop

0080334c <__udivdi3>:
  80334c:	55                   	push   %ebp
  80334d:	57                   	push   %edi
  80334e:	56                   	push   %esi
  80334f:	53                   	push   %ebx
  803350:	83 ec 1c             	sub    $0x1c,%esp
  803353:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803357:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80335b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80335f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803363:	89 ca                	mov    %ecx,%edx
  803365:	89 f8                	mov    %edi,%eax
  803367:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80336b:	85 f6                	test   %esi,%esi
  80336d:	75 2d                	jne    80339c <__udivdi3+0x50>
  80336f:	39 cf                	cmp    %ecx,%edi
  803371:	77 65                	ja     8033d8 <__udivdi3+0x8c>
  803373:	89 fd                	mov    %edi,%ebp
  803375:	85 ff                	test   %edi,%edi
  803377:	75 0b                	jne    803384 <__udivdi3+0x38>
  803379:	b8 01 00 00 00       	mov    $0x1,%eax
  80337e:	31 d2                	xor    %edx,%edx
  803380:	f7 f7                	div    %edi
  803382:	89 c5                	mov    %eax,%ebp
  803384:	31 d2                	xor    %edx,%edx
  803386:	89 c8                	mov    %ecx,%eax
  803388:	f7 f5                	div    %ebp
  80338a:	89 c1                	mov    %eax,%ecx
  80338c:	89 d8                	mov    %ebx,%eax
  80338e:	f7 f5                	div    %ebp
  803390:	89 cf                	mov    %ecx,%edi
  803392:	89 fa                	mov    %edi,%edx
  803394:	83 c4 1c             	add    $0x1c,%esp
  803397:	5b                   	pop    %ebx
  803398:	5e                   	pop    %esi
  803399:	5f                   	pop    %edi
  80339a:	5d                   	pop    %ebp
  80339b:	c3                   	ret    
  80339c:	39 ce                	cmp    %ecx,%esi
  80339e:	77 28                	ja     8033c8 <__udivdi3+0x7c>
  8033a0:	0f bd fe             	bsr    %esi,%edi
  8033a3:	83 f7 1f             	xor    $0x1f,%edi
  8033a6:	75 40                	jne    8033e8 <__udivdi3+0x9c>
  8033a8:	39 ce                	cmp    %ecx,%esi
  8033aa:	72 0a                	jb     8033b6 <__udivdi3+0x6a>
  8033ac:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8033b0:	0f 87 9e 00 00 00    	ja     803454 <__udivdi3+0x108>
  8033b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8033bb:	89 fa                	mov    %edi,%edx
  8033bd:	83 c4 1c             	add    $0x1c,%esp
  8033c0:	5b                   	pop    %ebx
  8033c1:	5e                   	pop    %esi
  8033c2:	5f                   	pop    %edi
  8033c3:	5d                   	pop    %ebp
  8033c4:	c3                   	ret    
  8033c5:	8d 76 00             	lea    0x0(%esi),%esi
  8033c8:	31 ff                	xor    %edi,%edi
  8033ca:	31 c0                	xor    %eax,%eax
  8033cc:	89 fa                	mov    %edi,%edx
  8033ce:	83 c4 1c             	add    $0x1c,%esp
  8033d1:	5b                   	pop    %ebx
  8033d2:	5e                   	pop    %esi
  8033d3:	5f                   	pop    %edi
  8033d4:	5d                   	pop    %ebp
  8033d5:	c3                   	ret    
  8033d6:	66 90                	xchg   %ax,%ax
  8033d8:	89 d8                	mov    %ebx,%eax
  8033da:	f7 f7                	div    %edi
  8033dc:	31 ff                	xor    %edi,%edi
  8033de:	89 fa                	mov    %edi,%edx
  8033e0:	83 c4 1c             	add    $0x1c,%esp
  8033e3:	5b                   	pop    %ebx
  8033e4:	5e                   	pop    %esi
  8033e5:	5f                   	pop    %edi
  8033e6:	5d                   	pop    %ebp
  8033e7:	c3                   	ret    
  8033e8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8033ed:	89 eb                	mov    %ebp,%ebx
  8033ef:	29 fb                	sub    %edi,%ebx
  8033f1:	89 f9                	mov    %edi,%ecx
  8033f3:	d3 e6                	shl    %cl,%esi
  8033f5:	89 c5                	mov    %eax,%ebp
  8033f7:	88 d9                	mov    %bl,%cl
  8033f9:	d3 ed                	shr    %cl,%ebp
  8033fb:	89 e9                	mov    %ebp,%ecx
  8033fd:	09 f1                	or     %esi,%ecx
  8033ff:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803403:	89 f9                	mov    %edi,%ecx
  803405:	d3 e0                	shl    %cl,%eax
  803407:	89 c5                	mov    %eax,%ebp
  803409:	89 d6                	mov    %edx,%esi
  80340b:	88 d9                	mov    %bl,%cl
  80340d:	d3 ee                	shr    %cl,%esi
  80340f:	89 f9                	mov    %edi,%ecx
  803411:	d3 e2                	shl    %cl,%edx
  803413:	8b 44 24 08          	mov    0x8(%esp),%eax
  803417:	88 d9                	mov    %bl,%cl
  803419:	d3 e8                	shr    %cl,%eax
  80341b:	09 c2                	or     %eax,%edx
  80341d:	89 d0                	mov    %edx,%eax
  80341f:	89 f2                	mov    %esi,%edx
  803421:	f7 74 24 0c          	divl   0xc(%esp)
  803425:	89 d6                	mov    %edx,%esi
  803427:	89 c3                	mov    %eax,%ebx
  803429:	f7 e5                	mul    %ebp
  80342b:	39 d6                	cmp    %edx,%esi
  80342d:	72 19                	jb     803448 <__udivdi3+0xfc>
  80342f:	74 0b                	je     80343c <__udivdi3+0xf0>
  803431:	89 d8                	mov    %ebx,%eax
  803433:	31 ff                	xor    %edi,%edi
  803435:	e9 58 ff ff ff       	jmp    803392 <__udivdi3+0x46>
  80343a:	66 90                	xchg   %ax,%ax
  80343c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803440:	89 f9                	mov    %edi,%ecx
  803442:	d3 e2                	shl    %cl,%edx
  803444:	39 c2                	cmp    %eax,%edx
  803446:	73 e9                	jae    803431 <__udivdi3+0xe5>
  803448:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80344b:	31 ff                	xor    %edi,%edi
  80344d:	e9 40 ff ff ff       	jmp    803392 <__udivdi3+0x46>
  803452:	66 90                	xchg   %ax,%ax
  803454:	31 c0                	xor    %eax,%eax
  803456:	e9 37 ff ff ff       	jmp    803392 <__udivdi3+0x46>
  80345b:	90                   	nop

0080345c <__umoddi3>:
  80345c:	55                   	push   %ebp
  80345d:	57                   	push   %edi
  80345e:	56                   	push   %esi
  80345f:	53                   	push   %ebx
  803460:	83 ec 1c             	sub    $0x1c,%esp
  803463:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803467:	8b 74 24 34          	mov    0x34(%esp),%esi
  80346b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80346f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803473:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803477:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80347b:	89 f3                	mov    %esi,%ebx
  80347d:	89 fa                	mov    %edi,%edx
  80347f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803483:	89 34 24             	mov    %esi,(%esp)
  803486:	85 c0                	test   %eax,%eax
  803488:	75 1a                	jne    8034a4 <__umoddi3+0x48>
  80348a:	39 f7                	cmp    %esi,%edi
  80348c:	0f 86 a2 00 00 00    	jbe    803534 <__umoddi3+0xd8>
  803492:	89 c8                	mov    %ecx,%eax
  803494:	89 f2                	mov    %esi,%edx
  803496:	f7 f7                	div    %edi
  803498:	89 d0                	mov    %edx,%eax
  80349a:	31 d2                	xor    %edx,%edx
  80349c:	83 c4 1c             	add    $0x1c,%esp
  80349f:	5b                   	pop    %ebx
  8034a0:	5e                   	pop    %esi
  8034a1:	5f                   	pop    %edi
  8034a2:	5d                   	pop    %ebp
  8034a3:	c3                   	ret    
  8034a4:	39 f0                	cmp    %esi,%eax
  8034a6:	0f 87 ac 00 00 00    	ja     803558 <__umoddi3+0xfc>
  8034ac:	0f bd e8             	bsr    %eax,%ebp
  8034af:	83 f5 1f             	xor    $0x1f,%ebp
  8034b2:	0f 84 ac 00 00 00    	je     803564 <__umoddi3+0x108>
  8034b8:	bf 20 00 00 00       	mov    $0x20,%edi
  8034bd:	29 ef                	sub    %ebp,%edi
  8034bf:	89 fe                	mov    %edi,%esi
  8034c1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8034c5:	89 e9                	mov    %ebp,%ecx
  8034c7:	d3 e0                	shl    %cl,%eax
  8034c9:	89 d7                	mov    %edx,%edi
  8034cb:	89 f1                	mov    %esi,%ecx
  8034cd:	d3 ef                	shr    %cl,%edi
  8034cf:	09 c7                	or     %eax,%edi
  8034d1:	89 e9                	mov    %ebp,%ecx
  8034d3:	d3 e2                	shl    %cl,%edx
  8034d5:	89 14 24             	mov    %edx,(%esp)
  8034d8:	89 d8                	mov    %ebx,%eax
  8034da:	d3 e0                	shl    %cl,%eax
  8034dc:	89 c2                	mov    %eax,%edx
  8034de:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034e2:	d3 e0                	shl    %cl,%eax
  8034e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8034e8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034ec:	89 f1                	mov    %esi,%ecx
  8034ee:	d3 e8                	shr    %cl,%eax
  8034f0:	09 d0                	or     %edx,%eax
  8034f2:	d3 eb                	shr    %cl,%ebx
  8034f4:	89 da                	mov    %ebx,%edx
  8034f6:	f7 f7                	div    %edi
  8034f8:	89 d3                	mov    %edx,%ebx
  8034fa:	f7 24 24             	mull   (%esp)
  8034fd:	89 c6                	mov    %eax,%esi
  8034ff:	89 d1                	mov    %edx,%ecx
  803501:	39 d3                	cmp    %edx,%ebx
  803503:	0f 82 87 00 00 00    	jb     803590 <__umoddi3+0x134>
  803509:	0f 84 91 00 00 00    	je     8035a0 <__umoddi3+0x144>
  80350f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803513:	29 f2                	sub    %esi,%edx
  803515:	19 cb                	sbb    %ecx,%ebx
  803517:	89 d8                	mov    %ebx,%eax
  803519:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80351d:	d3 e0                	shl    %cl,%eax
  80351f:	89 e9                	mov    %ebp,%ecx
  803521:	d3 ea                	shr    %cl,%edx
  803523:	09 d0                	or     %edx,%eax
  803525:	89 e9                	mov    %ebp,%ecx
  803527:	d3 eb                	shr    %cl,%ebx
  803529:	89 da                	mov    %ebx,%edx
  80352b:	83 c4 1c             	add    $0x1c,%esp
  80352e:	5b                   	pop    %ebx
  80352f:	5e                   	pop    %esi
  803530:	5f                   	pop    %edi
  803531:	5d                   	pop    %ebp
  803532:	c3                   	ret    
  803533:	90                   	nop
  803534:	89 fd                	mov    %edi,%ebp
  803536:	85 ff                	test   %edi,%edi
  803538:	75 0b                	jne    803545 <__umoddi3+0xe9>
  80353a:	b8 01 00 00 00       	mov    $0x1,%eax
  80353f:	31 d2                	xor    %edx,%edx
  803541:	f7 f7                	div    %edi
  803543:	89 c5                	mov    %eax,%ebp
  803545:	89 f0                	mov    %esi,%eax
  803547:	31 d2                	xor    %edx,%edx
  803549:	f7 f5                	div    %ebp
  80354b:	89 c8                	mov    %ecx,%eax
  80354d:	f7 f5                	div    %ebp
  80354f:	89 d0                	mov    %edx,%eax
  803551:	e9 44 ff ff ff       	jmp    80349a <__umoddi3+0x3e>
  803556:	66 90                	xchg   %ax,%ax
  803558:	89 c8                	mov    %ecx,%eax
  80355a:	89 f2                	mov    %esi,%edx
  80355c:	83 c4 1c             	add    $0x1c,%esp
  80355f:	5b                   	pop    %ebx
  803560:	5e                   	pop    %esi
  803561:	5f                   	pop    %edi
  803562:	5d                   	pop    %ebp
  803563:	c3                   	ret    
  803564:	3b 04 24             	cmp    (%esp),%eax
  803567:	72 06                	jb     80356f <__umoddi3+0x113>
  803569:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80356d:	77 0f                	ja     80357e <__umoddi3+0x122>
  80356f:	89 f2                	mov    %esi,%edx
  803571:	29 f9                	sub    %edi,%ecx
  803573:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803577:	89 14 24             	mov    %edx,(%esp)
  80357a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80357e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803582:	8b 14 24             	mov    (%esp),%edx
  803585:	83 c4 1c             	add    $0x1c,%esp
  803588:	5b                   	pop    %ebx
  803589:	5e                   	pop    %esi
  80358a:	5f                   	pop    %edi
  80358b:	5d                   	pop    %ebp
  80358c:	c3                   	ret    
  80358d:	8d 76 00             	lea    0x0(%esi),%esi
  803590:	2b 04 24             	sub    (%esp),%eax
  803593:	19 fa                	sbb    %edi,%edx
  803595:	89 d1                	mov    %edx,%ecx
  803597:	89 c6                	mov    %eax,%esi
  803599:	e9 71 ff ff ff       	jmp    80350f <__umoddi3+0xb3>
  80359e:	66 90                	xchg   %ax,%ax
  8035a0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8035a4:	72 ea                	jb     803590 <__umoddi3+0x134>
  8035a6:	89 d9                	mov    %ebx,%ecx
  8035a8:	e9 62 ff ff ff       	jmp    80350f <__umoddi3+0xb3>
