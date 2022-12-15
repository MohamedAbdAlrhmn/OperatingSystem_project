
obj/user/tst_sharing_5_slaveB1:     file format elf32-i386


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
  800031:	e8 1e 01 00 00       	call   800154 <libmain>
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
  80003b:	83 ec 28             	sub    $0x28,%esp
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
  80008c:	68 20 37 80 00       	push   $0x803720
  800091:	6a 12                	push   $0x12
  800093:	68 3c 37 80 00       	push   $0x80373c
  800098:	e8 f3 01 00 00       	call   800290 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  80009d:	83 ec 0c             	sub    $0xc,%esp
  8000a0:	6a 00                	push   $0x0
  8000a2:	e8 25 14 00 00       	call   8014cc <malloc>
  8000a7:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	uint32 *x;
	x = sget(sys_getparentenvid(),"x");
  8000aa:	e8 7d 1a 00 00       	call   801b2c <sys_getparentenvid>
  8000af:	83 ec 08             	sub    $0x8,%esp
  8000b2:	68 59 37 80 00       	push   $0x803759
  8000b7:	50                   	push   %eax
  8000b8:	e8 52 15 00 00       	call   80160f <sget>
  8000bd:	83 c4 10             	add    $0x10,%esp
  8000c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("Slave B1 env used x (getSharedObject)\n");
  8000c3:	83 ec 0c             	sub    $0xc,%esp
  8000c6:	68 5c 37 80 00       	push   $0x80375c
  8000cb:	e8 74 04 00 00       	call   800544 <cprintf>
  8000d0:	83 c4 10             	add    $0x10,%esp
	//To indicate that it's successfully got x
	inctst();
  8000d3:	e8 79 1b 00 00       	call   801c51 <inctst>
	cprintf("Slave B1 please be patient ...\n");
  8000d8:	83 ec 0c             	sub    $0xc,%esp
  8000db:	68 84 37 80 00       	push   $0x803784
  8000e0:	e8 5f 04 00 00       	call   800544 <cprintf>
  8000e5:	83 c4 10             	add    $0x10,%esp

	//sleep a while to allow the master to remove x & z
	env_sleep(6000);
  8000e8:	83 ec 0c             	sub    $0xc,%esp
  8000eb:	68 70 17 00 00       	push   $0x1770
  8000f0:	e8 00 33 00 00       	call   8033f5 <env_sleep>
  8000f5:	83 c4 10             	add    $0x10,%esp

	int freeFrames = sys_calculate_free_frames() ;
  8000f8:	e8 36 17 00 00       	call   801833 <sys_calculate_free_frames>
  8000fd:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sfree(x);
  800100:	83 ec 0c             	sub    $0xc,%esp
  800103:	ff 75 ec             	pushl  -0x14(%ebp)
  800106:	e8 c8 15 00 00       	call   8016d3 <sfree>
  80010b:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave B1 env removed x\n");
  80010e:	83 ec 0c             	sub    $0xc,%esp
  800111:	68 a4 37 80 00       	push   $0x8037a4
  800116:	e8 29 04 00 00       	call   800544 <cprintf>
  80011b:	83 c4 10             	add    $0x10,%esp
	int expected = (1+1) + (1+1);
  80011e:	c7 45 e4 04 00 00 00 	movl   $0x4,-0x1c(%ebp)
	if ((sys_calculate_free_frames() - freeFrames) !=  expected) panic("B1 wrong free: frames removed not equal 4 !, correct frames to be removed are 4:\nfrom the env: 1 table and 1 for frame of x\nframes_storage of x: should be cleared now\n");
  800125:	e8 09 17 00 00       	call   801833 <sys_calculate_free_frames>
  80012a:	89 c2                	mov    %eax,%edx
  80012c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80012f:	29 c2                	sub    %eax,%edx
  800131:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800134:	39 c2                	cmp    %eax,%edx
  800136:	74 14                	je     80014c <_main+0x114>
  800138:	83 ec 04             	sub    $0x4,%esp
  80013b:	68 bc 37 80 00       	push   $0x8037bc
  800140:	6a 27                	push   $0x27
  800142:	68 3c 37 80 00       	push   $0x80373c
  800147:	e8 44 01 00 00       	call   800290 <_panic>

	//To indicate that it's completed successfully
	inctst();
  80014c:	e8 00 1b 00 00       	call   801c51 <inctst>
	return;
  800151:	90                   	nop
}
  800152:	c9                   	leave  
  800153:	c3                   	ret    

00800154 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800154:	55                   	push   %ebp
  800155:	89 e5                	mov    %esp,%ebp
  800157:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80015a:	e8 b4 19 00 00       	call   801b13 <sys_getenvindex>
  80015f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800162:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800165:	89 d0                	mov    %edx,%eax
  800167:	c1 e0 03             	shl    $0x3,%eax
  80016a:	01 d0                	add    %edx,%eax
  80016c:	01 c0                	add    %eax,%eax
  80016e:	01 d0                	add    %edx,%eax
  800170:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800177:	01 d0                	add    %edx,%eax
  800179:	c1 e0 04             	shl    $0x4,%eax
  80017c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800181:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800186:	a1 20 50 80 00       	mov    0x805020,%eax
  80018b:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800191:	84 c0                	test   %al,%al
  800193:	74 0f                	je     8001a4 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800195:	a1 20 50 80 00       	mov    0x805020,%eax
  80019a:	05 5c 05 00 00       	add    $0x55c,%eax
  80019f:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001a4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001a8:	7e 0a                	jle    8001b4 <libmain+0x60>
		binaryname = argv[0];
  8001aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001ad:	8b 00                	mov    (%eax),%eax
  8001af:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8001b4:	83 ec 08             	sub    $0x8,%esp
  8001b7:	ff 75 0c             	pushl  0xc(%ebp)
  8001ba:	ff 75 08             	pushl  0x8(%ebp)
  8001bd:	e8 76 fe ff ff       	call   800038 <_main>
  8001c2:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001c5:	e8 56 17 00 00       	call   801920 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001ca:	83 ec 0c             	sub    $0xc,%esp
  8001cd:	68 7c 38 80 00       	push   $0x80387c
  8001d2:	e8 6d 03 00 00       	call   800544 <cprintf>
  8001d7:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001da:	a1 20 50 80 00       	mov    0x805020,%eax
  8001df:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8001e5:	a1 20 50 80 00       	mov    0x805020,%eax
  8001ea:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8001f0:	83 ec 04             	sub    $0x4,%esp
  8001f3:	52                   	push   %edx
  8001f4:	50                   	push   %eax
  8001f5:	68 a4 38 80 00       	push   $0x8038a4
  8001fa:	e8 45 03 00 00       	call   800544 <cprintf>
  8001ff:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800202:	a1 20 50 80 00       	mov    0x805020,%eax
  800207:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80020d:	a1 20 50 80 00       	mov    0x805020,%eax
  800212:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800218:	a1 20 50 80 00       	mov    0x805020,%eax
  80021d:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800223:	51                   	push   %ecx
  800224:	52                   	push   %edx
  800225:	50                   	push   %eax
  800226:	68 cc 38 80 00       	push   $0x8038cc
  80022b:	e8 14 03 00 00       	call   800544 <cprintf>
  800230:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800233:	a1 20 50 80 00       	mov    0x805020,%eax
  800238:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80023e:	83 ec 08             	sub    $0x8,%esp
  800241:	50                   	push   %eax
  800242:	68 24 39 80 00       	push   $0x803924
  800247:	e8 f8 02 00 00       	call   800544 <cprintf>
  80024c:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80024f:	83 ec 0c             	sub    $0xc,%esp
  800252:	68 7c 38 80 00       	push   $0x80387c
  800257:	e8 e8 02 00 00       	call   800544 <cprintf>
  80025c:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80025f:	e8 d6 16 00 00       	call   80193a <sys_enable_interrupt>

	// exit gracefully
	exit();
  800264:	e8 19 00 00 00       	call   800282 <exit>
}
  800269:	90                   	nop
  80026a:	c9                   	leave  
  80026b:	c3                   	ret    

0080026c <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80026c:	55                   	push   %ebp
  80026d:	89 e5                	mov    %esp,%ebp
  80026f:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800272:	83 ec 0c             	sub    $0xc,%esp
  800275:	6a 00                	push   $0x0
  800277:	e8 63 18 00 00       	call   801adf <sys_destroy_env>
  80027c:	83 c4 10             	add    $0x10,%esp
}
  80027f:	90                   	nop
  800280:	c9                   	leave  
  800281:	c3                   	ret    

00800282 <exit>:

void
exit(void)
{
  800282:	55                   	push   %ebp
  800283:	89 e5                	mov    %esp,%ebp
  800285:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800288:	e8 b8 18 00 00       	call   801b45 <sys_exit_env>
}
  80028d:	90                   	nop
  80028e:	c9                   	leave  
  80028f:	c3                   	ret    

00800290 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800290:	55                   	push   %ebp
  800291:	89 e5                	mov    %esp,%ebp
  800293:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800296:	8d 45 10             	lea    0x10(%ebp),%eax
  800299:	83 c0 04             	add    $0x4,%eax
  80029c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80029f:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8002a4:	85 c0                	test   %eax,%eax
  8002a6:	74 16                	je     8002be <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002a8:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8002ad:	83 ec 08             	sub    $0x8,%esp
  8002b0:	50                   	push   %eax
  8002b1:	68 38 39 80 00       	push   $0x803938
  8002b6:	e8 89 02 00 00       	call   800544 <cprintf>
  8002bb:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002be:	a1 00 50 80 00       	mov    0x805000,%eax
  8002c3:	ff 75 0c             	pushl  0xc(%ebp)
  8002c6:	ff 75 08             	pushl  0x8(%ebp)
  8002c9:	50                   	push   %eax
  8002ca:	68 3d 39 80 00       	push   $0x80393d
  8002cf:	e8 70 02 00 00       	call   800544 <cprintf>
  8002d4:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8002da:	83 ec 08             	sub    $0x8,%esp
  8002dd:	ff 75 f4             	pushl  -0xc(%ebp)
  8002e0:	50                   	push   %eax
  8002e1:	e8 f3 01 00 00       	call   8004d9 <vcprintf>
  8002e6:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002e9:	83 ec 08             	sub    $0x8,%esp
  8002ec:	6a 00                	push   $0x0
  8002ee:	68 59 39 80 00       	push   $0x803959
  8002f3:	e8 e1 01 00 00       	call   8004d9 <vcprintf>
  8002f8:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002fb:	e8 82 ff ff ff       	call   800282 <exit>

	// should not return here
	while (1) ;
  800300:	eb fe                	jmp    800300 <_panic+0x70>

00800302 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800302:	55                   	push   %ebp
  800303:	89 e5                	mov    %esp,%ebp
  800305:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800308:	a1 20 50 80 00       	mov    0x805020,%eax
  80030d:	8b 50 74             	mov    0x74(%eax),%edx
  800310:	8b 45 0c             	mov    0xc(%ebp),%eax
  800313:	39 c2                	cmp    %eax,%edx
  800315:	74 14                	je     80032b <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800317:	83 ec 04             	sub    $0x4,%esp
  80031a:	68 5c 39 80 00       	push   $0x80395c
  80031f:	6a 26                	push   $0x26
  800321:	68 a8 39 80 00       	push   $0x8039a8
  800326:	e8 65 ff ff ff       	call   800290 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80032b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800332:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800339:	e9 c2 00 00 00       	jmp    800400 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80033e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800341:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800348:	8b 45 08             	mov    0x8(%ebp),%eax
  80034b:	01 d0                	add    %edx,%eax
  80034d:	8b 00                	mov    (%eax),%eax
  80034f:	85 c0                	test   %eax,%eax
  800351:	75 08                	jne    80035b <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800353:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800356:	e9 a2 00 00 00       	jmp    8003fd <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80035b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800362:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800369:	eb 69                	jmp    8003d4 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80036b:	a1 20 50 80 00       	mov    0x805020,%eax
  800370:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800376:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800379:	89 d0                	mov    %edx,%eax
  80037b:	01 c0                	add    %eax,%eax
  80037d:	01 d0                	add    %edx,%eax
  80037f:	c1 e0 03             	shl    $0x3,%eax
  800382:	01 c8                	add    %ecx,%eax
  800384:	8a 40 04             	mov    0x4(%eax),%al
  800387:	84 c0                	test   %al,%al
  800389:	75 46                	jne    8003d1 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80038b:	a1 20 50 80 00       	mov    0x805020,%eax
  800390:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800396:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800399:	89 d0                	mov    %edx,%eax
  80039b:	01 c0                	add    %eax,%eax
  80039d:	01 d0                	add    %edx,%eax
  80039f:	c1 e0 03             	shl    $0x3,%eax
  8003a2:	01 c8                	add    %ecx,%eax
  8003a4:	8b 00                	mov    (%eax),%eax
  8003a6:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003ac:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003b1:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003b6:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c0:	01 c8                	add    %ecx,%eax
  8003c2:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003c4:	39 c2                	cmp    %eax,%edx
  8003c6:	75 09                	jne    8003d1 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8003c8:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003cf:	eb 12                	jmp    8003e3 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003d1:	ff 45 e8             	incl   -0x18(%ebp)
  8003d4:	a1 20 50 80 00       	mov    0x805020,%eax
  8003d9:	8b 50 74             	mov    0x74(%eax),%edx
  8003dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003df:	39 c2                	cmp    %eax,%edx
  8003e1:	77 88                	ja     80036b <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003e3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003e7:	75 14                	jne    8003fd <CheckWSWithoutLastIndex+0xfb>
			panic(
  8003e9:	83 ec 04             	sub    $0x4,%esp
  8003ec:	68 b4 39 80 00       	push   $0x8039b4
  8003f1:	6a 3a                	push   $0x3a
  8003f3:	68 a8 39 80 00       	push   $0x8039a8
  8003f8:	e8 93 fe ff ff       	call   800290 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003fd:	ff 45 f0             	incl   -0x10(%ebp)
  800400:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800403:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800406:	0f 8c 32 ff ff ff    	jl     80033e <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80040c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800413:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80041a:	eb 26                	jmp    800442 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80041c:	a1 20 50 80 00       	mov    0x805020,%eax
  800421:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800427:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80042a:	89 d0                	mov    %edx,%eax
  80042c:	01 c0                	add    %eax,%eax
  80042e:	01 d0                	add    %edx,%eax
  800430:	c1 e0 03             	shl    $0x3,%eax
  800433:	01 c8                	add    %ecx,%eax
  800435:	8a 40 04             	mov    0x4(%eax),%al
  800438:	3c 01                	cmp    $0x1,%al
  80043a:	75 03                	jne    80043f <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80043c:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80043f:	ff 45 e0             	incl   -0x20(%ebp)
  800442:	a1 20 50 80 00       	mov    0x805020,%eax
  800447:	8b 50 74             	mov    0x74(%eax),%edx
  80044a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80044d:	39 c2                	cmp    %eax,%edx
  80044f:	77 cb                	ja     80041c <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800451:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800454:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800457:	74 14                	je     80046d <CheckWSWithoutLastIndex+0x16b>
		panic(
  800459:	83 ec 04             	sub    $0x4,%esp
  80045c:	68 08 3a 80 00       	push   $0x803a08
  800461:	6a 44                	push   $0x44
  800463:	68 a8 39 80 00       	push   $0x8039a8
  800468:	e8 23 fe ff ff       	call   800290 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80046d:	90                   	nop
  80046e:	c9                   	leave  
  80046f:	c3                   	ret    

00800470 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800470:	55                   	push   %ebp
  800471:	89 e5                	mov    %esp,%ebp
  800473:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800476:	8b 45 0c             	mov    0xc(%ebp),%eax
  800479:	8b 00                	mov    (%eax),%eax
  80047b:	8d 48 01             	lea    0x1(%eax),%ecx
  80047e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800481:	89 0a                	mov    %ecx,(%edx)
  800483:	8b 55 08             	mov    0x8(%ebp),%edx
  800486:	88 d1                	mov    %dl,%cl
  800488:	8b 55 0c             	mov    0xc(%ebp),%edx
  80048b:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80048f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800492:	8b 00                	mov    (%eax),%eax
  800494:	3d ff 00 00 00       	cmp    $0xff,%eax
  800499:	75 2c                	jne    8004c7 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80049b:	a0 24 50 80 00       	mov    0x805024,%al
  8004a0:	0f b6 c0             	movzbl %al,%eax
  8004a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004a6:	8b 12                	mov    (%edx),%edx
  8004a8:	89 d1                	mov    %edx,%ecx
  8004aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004ad:	83 c2 08             	add    $0x8,%edx
  8004b0:	83 ec 04             	sub    $0x4,%esp
  8004b3:	50                   	push   %eax
  8004b4:	51                   	push   %ecx
  8004b5:	52                   	push   %edx
  8004b6:	e8 b7 12 00 00       	call   801772 <sys_cputs>
  8004bb:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ca:	8b 40 04             	mov    0x4(%eax),%eax
  8004cd:	8d 50 01             	lea    0x1(%eax),%edx
  8004d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004d3:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004d6:	90                   	nop
  8004d7:	c9                   	leave  
  8004d8:	c3                   	ret    

008004d9 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004d9:	55                   	push   %ebp
  8004da:	89 e5                	mov    %esp,%ebp
  8004dc:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004e2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004e9:	00 00 00 
	b.cnt = 0;
  8004ec:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004f3:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004f6:	ff 75 0c             	pushl  0xc(%ebp)
  8004f9:	ff 75 08             	pushl  0x8(%ebp)
  8004fc:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800502:	50                   	push   %eax
  800503:	68 70 04 80 00       	push   $0x800470
  800508:	e8 11 02 00 00       	call   80071e <vprintfmt>
  80050d:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800510:	a0 24 50 80 00       	mov    0x805024,%al
  800515:	0f b6 c0             	movzbl %al,%eax
  800518:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80051e:	83 ec 04             	sub    $0x4,%esp
  800521:	50                   	push   %eax
  800522:	52                   	push   %edx
  800523:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800529:	83 c0 08             	add    $0x8,%eax
  80052c:	50                   	push   %eax
  80052d:	e8 40 12 00 00       	call   801772 <sys_cputs>
  800532:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800535:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  80053c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800542:	c9                   	leave  
  800543:	c3                   	ret    

00800544 <cprintf>:

int cprintf(const char *fmt, ...) {
  800544:	55                   	push   %ebp
  800545:	89 e5                	mov    %esp,%ebp
  800547:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80054a:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800551:	8d 45 0c             	lea    0xc(%ebp),%eax
  800554:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800557:	8b 45 08             	mov    0x8(%ebp),%eax
  80055a:	83 ec 08             	sub    $0x8,%esp
  80055d:	ff 75 f4             	pushl  -0xc(%ebp)
  800560:	50                   	push   %eax
  800561:	e8 73 ff ff ff       	call   8004d9 <vcprintf>
  800566:	83 c4 10             	add    $0x10,%esp
  800569:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80056c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80056f:	c9                   	leave  
  800570:	c3                   	ret    

00800571 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800571:	55                   	push   %ebp
  800572:	89 e5                	mov    %esp,%ebp
  800574:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800577:	e8 a4 13 00 00       	call   801920 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80057c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80057f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800582:	8b 45 08             	mov    0x8(%ebp),%eax
  800585:	83 ec 08             	sub    $0x8,%esp
  800588:	ff 75 f4             	pushl  -0xc(%ebp)
  80058b:	50                   	push   %eax
  80058c:	e8 48 ff ff ff       	call   8004d9 <vcprintf>
  800591:	83 c4 10             	add    $0x10,%esp
  800594:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800597:	e8 9e 13 00 00       	call   80193a <sys_enable_interrupt>
	return cnt;
  80059c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80059f:	c9                   	leave  
  8005a0:	c3                   	ret    

008005a1 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005a1:	55                   	push   %ebp
  8005a2:	89 e5                	mov    %esp,%ebp
  8005a4:	53                   	push   %ebx
  8005a5:	83 ec 14             	sub    $0x14,%esp
  8005a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8005ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005b4:	8b 45 18             	mov    0x18(%ebp),%eax
  8005b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8005bc:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005bf:	77 55                	ja     800616 <printnum+0x75>
  8005c1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005c4:	72 05                	jb     8005cb <printnum+0x2a>
  8005c6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005c9:	77 4b                	ja     800616 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005cb:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005ce:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005d1:	8b 45 18             	mov    0x18(%ebp),%eax
  8005d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8005d9:	52                   	push   %edx
  8005da:	50                   	push   %eax
  8005db:	ff 75 f4             	pushl  -0xc(%ebp)
  8005de:	ff 75 f0             	pushl  -0x10(%ebp)
  8005e1:	e8 c6 2e 00 00       	call   8034ac <__udivdi3>
  8005e6:	83 c4 10             	add    $0x10,%esp
  8005e9:	83 ec 04             	sub    $0x4,%esp
  8005ec:	ff 75 20             	pushl  0x20(%ebp)
  8005ef:	53                   	push   %ebx
  8005f0:	ff 75 18             	pushl  0x18(%ebp)
  8005f3:	52                   	push   %edx
  8005f4:	50                   	push   %eax
  8005f5:	ff 75 0c             	pushl  0xc(%ebp)
  8005f8:	ff 75 08             	pushl  0x8(%ebp)
  8005fb:	e8 a1 ff ff ff       	call   8005a1 <printnum>
  800600:	83 c4 20             	add    $0x20,%esp
  800603:	eb 1a                	jmp    80061f <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800605:	83 ec 08             	sub    $0x8,%esp
  800608:	ff 75 0c             	pushl  0xc(%ebp)
  80060b:	ff 75 20             	pushl  0x20(%ebp)
  80060e:	8b 45 08             	mov    0x8(%ebp),%eax
  800611:	ff d0                	call   *%eax
  800613:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800616:	ff 4d 1c             	decl   0x1c(%ebp)
  800619:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80061d:	7f e6                	jg     800605 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80061f:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800622:	bb 00 00 00 00       	mov    $0x0,%ebx
  800627:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80062a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80062d:	53                   	push   %ebx
  80062e:	51                   	push   %ecx
  80062f:	52                   	push   %edx
  800630:	50                   	push   %eax
  800631:	e8 86 2f 00 00       	call   8035bc <__umoddi3>
  800636:	83 c4 10             	add    $0x10,%esp
  800639:	05 74 3c 80 00       	add    $0x803c74,%eax
  80063e:	8a 00                	mov    (%eax),%al
  800640:	0f be c0             	movsbl %al,%eax
  800643:	83 ec 08             	sub    $0x8,%esp
  800646:	ff 75 0c             	pushl  0xc(%ebp)
  800649:	50                   	push   %eax
  80064a:	8b 45 08             	mov    0x8(%ebp),%eax
  80064d:	ff d0                	call   *%eax
  80064f:	83 c4 10             	add    $0x10,%esp
}
  800652:	90                   	nop
  800653:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800656:	c9                   	leave  
  800657:	c3                   	ret    

00800658 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800658:	55                   	push   %ebp
  800659:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80065b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80065f:	7e 1c                	jle    80067d <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800661:	8b 45 08             	mov    0x8(%ebp),%eax
  800664:	8b 00                	mov    (%eax),%eax
  800666:	8d 50 08             	lea    0x8(%eax),%edx
  800669:	8b 45 08             	mov    0x8(%ebp),%eax
  80066c:	89 10                	mov    %edx,(%eax)
  80066e:	8b 45 08             	mov    0x8(%ebp),%eax
  800671:	8b 00                	mov    (%eax),%eax
  800673:	83 e8 08             	sub    $0x8,%eax
  800676:	8b 50 04             	mov    0x4(%eax),%edx
  800679:	8b 00                	mov    (%eax),%eax
  80067b:	eb 40                	jmp    8006bd <getuint+0x65>
	else if (lflag)
  80067d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800681:	74 1e                	je     8006a1 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800683:	8b 45 08             	mov    0x8(%ebp),%eax
  800686:	8b 00                	mov    (%eax),%eax
  800688:	8d 50 04             	lea    0x4(%eax),%edx
  80068b:	8b 45 08             	mov    0x8(%ebp),%eax
  80068e:	89 10                	mov    %edx,(%eax)
  800690:	8b 45 08             	mov    0x8(%ebp),%eax
  800693:	8b 00                	mov    (%eax),%eax
  800695:	83 e8 04             	sub    $0x4,%eax
  800698:	8b 00                	mov    (%eax),%eax
  80069a:	ba 00 00 00 00       	mov    $0x0,%edx
  80069f:	eb 1c                	jmp    8006bd <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a4:	8b 00                	mov    (%eax),%eax
  8006a6:	8d 50 04             	lea    0x4(%eax),%edx
  8006a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ac:	89 10                	mov    %edx,(%eax)
  8006ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b1:	8b 00                	mov    (%eax),%eax
  8006b3:	83 e8 04             	sub    $0x4,%eax
  8006b6:	8b 00                	mov    (%eax),%eax
  8006b8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006bd:	5d                   	pop    %ebp
  8006be:	c3                   	ret    

008006bf <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006bf:	55                   	push   %ebp
  8006c0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006c2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006c6:	7e 1c                	jle    8006e4 <getint+0x25>
		return va_arg(*ap, long long);
  8006c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cb:	8b 00                	mov    (%eax),%eax
  8006cd:	8d 50 08             	lea    0x8(%eax),%edx
  8006d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d3:	89 10                	mov    %edx,(%eax)
  8006d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d8:	8b 00                	mov    (%eax),%eax
  8006da:	83 e8 08             	sub    $0x8,%eax
  8006dd:	8b 50 04             	mov    0x4(%eax),%edx
  8006e0:	8b 00                	mov    (%eax),%eax
  8006e2:	eb 38                	jmp    80071c <getint+0x5d>
	else if (lflag)
  8006e4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006e8:	74 1a                	je     800704 <getint+0x45>
		return va_arg(*ap, long);
  8006ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ed:	8b 00                	mov    (%eax),%eax
  8006ef:	8d 50 04             	lea    0x4(%eax),%edx
  8006f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f5:	89 10                	mov    %edx,(%eax)
  8006f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fa:	8b 00                	mov    (%eax),%eax
  8006fc:	83 e8 04             	sub    $0x4,%eax
  8006ff:	8b 00                	mov    (%eax),%eax
  800701:	99                   	cltd   
  800702:	eb 18                	jmp    80071c <getint+0x5d>
	else
		return va_arg(*ap, int);
  800704:	8b 45 08             	mov    0x8(%ebp),%eax
  800707:	8b 00                	mov    (%eax),%eax
  800709:	8d 50 04             	lea    0x4(%eax),%edx
  80070c:	8b 45 08             	mov    0x8(%ebp),%eax
  80070f:	89 10                	mov    %edx,(%eax)
  800711:	8b 45 08             	mov    0x8(%ebp),%eax
  800714:	8b 00                	mov    (%eax),%eax
  800716:	83 e8 04             	sub    $0x4,%eax
  800719:	8b 00                	mov    (%eax),%eax
  80071b:	99                   	cltd   
}
  80071c:	5d                   	pop    %ebp
  80071d:	c3                   	ret    

0080071e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80071e:	55                   	push   %ebp
  80071f:	89 e5                	mov    %esp,%ebp
  800721:	56                   	push   %esi
  800722:	53                   	push   %ebx
  800723:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800726:	eb 17                	jmp    80073f <vprintfmt+0x21>
			if (ch == '\0')
  800728:	85 db                	test   %ebx,%ebx
  80072a:	0f 84 af 03 00 00    	je     800adf <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800730:	83 ec 08             	sub    $0x8,%esp
  800733:	ff 75 0c             	pushl  0xc(%ebp)
  800736:	53                   	push   %ebx
  800737:	8b 45 08             	mov    0x8(%ebp),%eax
  80073a:	ff d0                	call   *%eax
  80073c:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80073f:	8b 45 10             	mov    0x10(%ebp),%eax
  800742:	8d 50 01             	lea    0x1(%eax),%edx
  800745:	89 55 10             	mov    %edx,0x10(%ebp)
  800748:	8a 00                	mov    (%eax),%al
  80074a:	0f b6 d8             	movzbl %al,%ebx
  80074d:	83 fb 25             	cmp    $0x25,%ebx
  800750:	75 d6                	jne    800728 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800752:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800756:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80075d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800764:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80076b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800772:	8b 45 10             	mov    0x10(%ebp),%eax
  800775:	8d 50 01             	lea    0x1(%eax),%edx
  800778:	89 55 10             	mov    %edx,0x10(%ebp)
  80077b:	8a 00                	mov    (%eax),%al
  80077d:	0f b6 d8             	movzbl %al,%ebx
  800780:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800783:	83 f8 55             	cmp    $0x55,%eax
  800786:	0f 87 2b 03 00 00    	ja     800ab7 <vprintfmt+0x399>
  80078c:	8b 04 85 98 3c 80 00 	mov    0x803c98(,%eax,4),%eax
  800793:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800795:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800799:	eb d7                	jmp    800772 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80079b:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80079f:	eb d1                	jmp    800772 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007a1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007a8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007ab:	89 d0                	mov    %edx,%eax
  8007ad:	c1 e0 02             	shl    $0x2,%eax
  8007b0:	01 d0                	add    %edx,%eax
  8007b2:	01 c0                	add    %eax,%eax
  8007b4:	01 d8                	add    %ebx,%eax
  8007b6:	83 e8 30             	sub    $0x30,%eax
  8007b9:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8007bf:	8a 00                	mov    (%eax),%al
  8007c1:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007c4:	83 fb 2f             	cmp    $0x2f,%ebx
  8007c7:	7e 3e                	jle    800807 <vprintfmt+0xe9>
  8007c9:	83 fb 39             	cmp    $0x39,%ebx
  8007cc:	7f 39                	jg     800807 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007ce:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007d1:	eb d5                	jmp    8007a8 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d6:	83 c0 04             	add    $0x4,%eax
  8007d9:	89 45 14             	mov    %eax,0x14(%ebp)
  8007dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007df:	83 e8 04             	sub    $0x4,%eax
  8007e2:	8b 00                	mov    (%eax),%eax
  8007e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007e7:	eb 1f                	jmp    800808 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007e9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007ed:	79 83                	jns    800772 <vprintfmt+0x54>
				width = 0;
  8007ef:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007f6:	e9 77 ff ff ff       	jmp    800772 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007fb:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800802:	e9 6b ff ff ff       	jmp    800772 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800807:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800808:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80080c:	0f 89 60 ff ff ff    	jns    800772 <vprintfmt+0x54>
				width = precision, precision = -1;
  800812:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800815:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800818:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80081f:	e9 4e ff ff ff       	jmp    800772 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800824:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800827:	e9 46 ff ff ff       	jmp    800772 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80082c:	8b 45 14             	mov    0x14(%ebp),%eax
  80082f:	83 c0 04             	add    $0x4,%eax
  800832:	89 45 14             	mov    %eax,0x14(%ebp)
  800835:	8b 45 14             	mov    0x14(%ebp),%eax
  800838:	83 e8 04             	sub    $0x4,%eax
  80083b:	8b 00                	mov    (%eax),%eax
  80083d:	83 ec 08             	sub    $0x8,%esp
  800840:	ff 75 0c             	pushl  0xc(%ebp)
  800843:	50                   	push   %eax
  800844:	8b 45 08             	mov    0x8(%ebp),%eax
  800847:	ff d0                	call   *%eax
  800849:	83 c4 10             	add    $0x10,%esp
			break;
  80084c:	e9 89 02 00 00       	jmp    800ada <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800851:	8b 45 14             	mov    0x14(%ebp),%eax
  800854:	83 c0 04             	add    $0x4,%eax
  800857:	89 45 14             	mov    %eax,0x14(%ebp)
  80085a:	8b 45 14             	mov    0x14(%ebp),%eax
  80085d:	83 e8 04             	sub    $0x4,%eax
  800860:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800862:	85 db                	test   %ebx,%ebx
  800864:	79 02                	jns    800868 <vprintfmt+0x14a>
				err = -err;
  800866:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800868:	83 fb 64             	cmp    $0x64,%ebx
  80086b:	7f 0b                	jg     800878 <vprintfmt+0x15a>
  80086d:	8b 34 9d e0 3a 80 00 	mov    0x803ae0(,%ebx,4),%esi
  800874:	85 f6                	test   %esi,%esi
  800876:	75 19                	jne    800891 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800878:	53                   	push   %ebx
  800879:	68 85 3c 80 00       	push   $0x803c85
  80087e:	ff 75 0c             	pushl  0xc(%ebp)
  800881:	ff 75 08             	pushl  0x8(%ebp)
  800884:	e8 5e 02 00 00       	call   800ae7 <printfmt>
  800889:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80088c:	e9 49 02 00 00       	jmp    800ada <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800891:	56                   	push   %esi
  800892:	68 8e 3c 80 00       	push   $0x803c8e
  800897:	ff 75 0c             	pushl  0xc(%ebp)
  80089a:	ff 75 08             	pushl  0x8(%ebp)
  80089d:	e8 45 02 00 00       	call   800ae7 <printfmt>
  8008a2:	83 c4 10             	add    $0x10,%esp
			break;
  8008a5:	e9 30 02 00 00       	jmp    800ada <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ad:	83 c0 04             	add    $0x4,%eax
  8008b0:	89 45 14             	mov    %eax,0x14(%ebp)
  8008b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b6:	83 e8 04             	sub    $0x4,%eax
  8008b9:	8b 30                	mov    (%eax),%esi
  8008bb:	85 f6                	test   %esi,%esi
  8008bd:	75 05                	jne    8008c4 <vprintfmt+0x1a6>
				p = "(null)";
  8008bf:	be 91 3c 80 00       	mov    $0x803c91,%esi
			if (width > 0 && padc != '-')
  8008c4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008c8:	7e 6d                	jle    800937 <vprintfmt+0x219>
  8008ca:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008ce:	74 67                	je     800937 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008d3:	83 ec 08             	sub    $0x8,%esp
  8008d6:	50                   	push   %eax
  8008d7:	56                   	push   %esi
  8008d8:	e8 0c 03 00 00       	call   800be9 <strnlen>
  8008dd:	83 c4 10             	add    $0x10,%esp
  8008e0:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008e3:	eb 16                	jmp    8008fb <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008e5:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008e9:	83 ec 08             	sub    $0x8,%esp
  8008ec:	ff 75 0c             	pushl  0xc(%ebp)
  8008ef:	50                   	push   %eax
  8008f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f3:	ff d0                	call   *%eax
  8008f5:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008f8:	ff 4d e4             	decl   -0x1c(%ebp)
  8008fb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ff:	7f e4                	jg     8008e5 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800901:	eb 34                	jmp    800937 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800903:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800907:	74 1c                	je     800925 <vprintfmt+0x207>
  800909:	83 fb 1f             	cmp    $0x1f,%ebx
  80090c:	7e 05                	jle    800913 <vprintfmt+0x1f5>
  80090e:	83 fb 7e             	cmp    $0x7e,%ebx
  800911:	7e 12                	jle    800925 <vprintfmt+0x207>
					putch('?', putdat);
  800913:	83 ec 08             	sub    $0x8,%esp
  800916:	ff 75 0c             	pushl  0xc(%ebp)
  800919:	6a 3f                	push   $0x3f
  80091b:	8b 45 08             	mov    0x8(%ebp),%eax
  80091e:	ff d0                	call   *%eax
  800920:	83 c4 10             	add    $0x10,%esp
  800923:	eb 0f                	jmp    800934 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800925:	83 ec 08             	sub    $0x8,%esp
  800928:	ff 75 0c             	pushl  0xc(%ebp)
  80092b:	53                   	push   %ebx
  80092c:	8b 45 08             	mov    0x8(%ebp),%eax
  80092f:	ff d0                	call   *%eax
  800931:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800934:	ff 4d e4             	decl   -0x1c(%ebp)
  800937:	89 f0                	mov    %esi,%eax
  800939:	8d 70 01             	lea    0x1(%eax),%esi
  80093c:	8a 00                	mov    (%eax),%al
  80093e:	0f be d8             	movsbl %al,%ebx
  800941:	85 db                	test   %ebx,%ebx
  800943:	74 24                	je     800969 <vprintfmt+0x24b>
  800945:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800949:	78 b8                	js     800903 <vprintfmt+0x1e5>
  80094b:	ff 4d e0             	decl   -0x20(%ebp)
  80094e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800952:	79 af                	jns    800903 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800954:	eb 13                	jmp    800969 <vprintfmt+0x24b>
				putch(' ', putdat);
  800956:	83 ec 08             	sub    $0x8,%esp
  800959:	ff 75 0c             	pushl  0xc(%ebp)
  80095c:	6a 20                	push   $0x20
  80095e:	8b 45 08             	mov    0x8(%ebp),%eax
  800961:	ff d0                	call   *%eax
  800963:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800966:	ff 4d e4             	decl   -0x1c(%ebp)
  800969:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80096d:	7f e7                	jg     800956 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80096f:	e9 66 01 00 00       	jmp    800ada <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800974:	83 ec 08             	sub    $0x8,%esp
  800977:	ff 75 e8             	pushl  -0x18(%ebp)
  80097a:	8d 45 14             	lea    0x14(%ebp),%eax
  80097d:	50                   	push   %eax
  80097e:	e8 3c fd ff ff       	call   8006bf <getint>
  800983:	83 c4 10             	add    $0x10,%esp
  800986:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800989:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80098c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80098f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800992:	85 d2                	test   %edx,%edx
  800994:	79 23                	jns    8009b9 <vprintfmt+0x29b>
				putch('-', putdat);
  800996:	83 ec 08             	sub    $0x8,%esp
  800999:	ff 75 0c             	pushl  0xc(%ebp)
  80099c:	6a 2d                	push   $0x2d
  80099e:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a1:	ff d0                	call   *%eax
  8009a3:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009ac:	f7 d8                	neg    %eax
  8009ae:	83 d2 00             	adc    $0x0,%edx
  8009b1:	f7 da                	neg    %edx
  8009b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009b6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009b9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009c0:	e9 bc 00 00 00       	jmp    800a81 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009c5:	83 ec 08             	sub    $0x8,%esp
  8009c8:	ff 75 e8             	pushl  -0x18(%ebp)
  8009cb:	8d 45 14             	lea    0x14(%ebp),%eax
  8009ce:	50                   	push   %eax
  8009cf:	e8 84 fc ff ff       	call   800658 <getuint>
  8009d4:	83 c4 10             	add    $0x10,%esp
  8009d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009da:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009dd:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009e4:	e9 98 00 00 00       	jmp    800a81 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009e9:	83 ec 08             	sub    $0x8,%esp
  8009ec:	ff 75 0c             	pushl  0xc(%ebp)
  8009ef:	6a 58                	push   $0x58
  8009f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f4:	ff d0                	call   *%eax
  8009f6:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009f9:	83 ec 08             	sub    $0x8,%esp
  8009fc:	ff 75 0c             	pushl  0xc(%ebp)
  8009ff:	6a 58                	push   $0x58
  800a01:	8b 45 08             	mov    0x8(%ebp),%eax
  800a04:	ff d0                	call   *%eax
  800a06:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a09:	83 ec 08             	sub    $0x8,%esp
  800a0c:	ff 75 0c             	pushl  0xc(%ebp)
  800a0f:	6a 58                	push   $0x58
  800a11:	8b 45 08             	mov    0x8(%ebp),%eax
  800a14:	ff d0                	call   *%eax
  800a16:	83 c4 10             	add    $0x10,%esp
			break;
  800a19:	e9 bc 00 00 00       	jmp    800ada <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a1e:	83 ec 08             	sub    $0x8,%esp
  800a21:	ff 75 0c             	pushl  0xc(%ebp)
  800a24:	6a 30                	push   $0x30
  800a26:	8b 45 08             	mov    0x8(%ebp),%eax
  800a29:	ff d0                	call   *%eax
  800a2b:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a2e:	83 ec 08             	sub    $0x8,%esp
  800a31:	ff 75 0c             	pushl  0xc(%ebp)
  800a34:	6a 78                	push   $0x78
  800a36:	8b 45 08             	mov    0x8(%ebp),%eax
  800a39:	ff d0                	call   *%eax
  800a3b:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a3e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a41:	83 c0 04             	add    $0x4,%eax
  800a44:	89 45 14             	mov    %eax,0x14(%ebp)
  800a47:	8b 45 14             	mov    0x14(%ebp),%eax
  800a4a:	83 e8 04             	sub    $0x4,%eax
  800a4d:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a52:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a59:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a60:	eb 1f                	jmp    800a81 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a62:	83 ec 08             	sub    $0x8,%esp
  800a65:	ff 75 e8             	pushl  -0x18(%ebp)
  800a68:	8d 45 14             	lea    0x14(%ebp),%eax
  800a6b:	50                   	push   %eax
  800a6c:	e8 e7 fb ff ff       	call   800658 <getuint>
  800a71:	83 c4 10             	add    $0x10,%esp
  800a74:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a77:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a7a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a81:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a85:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a88:	83 ec 04             	sub    $0x4,%esp
  800a8b:	52                   	push   %edx
  800a8c:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a8f:	50                   	push   %eax
  800a90:	ff 75 f4             	pushl  -0xc(%ebp)
  800a93:	ff 75 f0             	pushl  -0x10(%ebp)
  800a96:	ff 75 0c             	pushl  0xc(%ebp)
  800a99:	ff 75 08             	pushl  0x8(%ebp)
  800a9c:	e8 00 fb ff ff       	call   8005a1 <printnum>
  800aa1:	83 c4 20             	add    $0x20,%esp
			break;
  800aa4:	eb 34                	jmp    800ada <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800aa6:	83 ec 08             	sub    $0x8,%esp
  800aa9:	ff 75 0c             	pushl  0xc(%ebp)
  800aac:	53                   	push   %ebx
  800aad:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab0:	ff d0                	call   *%eax
  800ab2:	83 c4 10             	add    $0x10,%esp
			break;
  800ab5:	eb 23                	jmp    800ada <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ab7:	83 ec 08             	sub    $0x8,%esp
  800aba:	ff 75 0c             	pushl  0xc(%ebp)
  800abd:	6a 25                	push   $0x25
  800abf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac2:	ff d0                	call   *%eax
  800ac4:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ac7:	ff 4d 10             	decl   0x10(%ebp)
  800aca:	eb 03                	jmp    800acf <vprintfmt+0x3b1>
  800acc:	ff 4d 10             	decl   0x10(%ebp)
  800acf:	8b 45 10             	mov    0x10(%ebp),%eax
  800ad2:	48                   	dec    %eax
  800ad3:	8a 00                	mov    (%eax),%al
  800ad5:	3c 25                	cmp    $0x25,%al
  800ad7:	75 f3                	jne    800acc <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800ad9:	90                   	nop
		}
	}
  800ada:	e9 47 fc ff ff       	jmp    800726 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800adf:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ae0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ae3:	5b                   	pop    %ebx
  800ae4:	5e                   	pop    %esi
  800ae5:	5d                   	pop    %ebp
  800ae6:	c3                   	ret    

00800ae7 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ae7:	55                   	push   %ebp
  800ae8:	89 e5                	mov    %esp,%ebp
  800aea:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800aed:	8d 45 10             	lea    0x10(%ebp),%eax
  800af0:	83 c0 04             	add    $0x4,%eax
  800af3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800af6:	8b 45 10             	mov    0x10(%ebp),%eax
  800af9:	ff 75 f4             	pushl  -0xc(%ebp)
  800afc:	50                   	push   %eax
  800afd:	ff 75 0c             	pushl  0xc(%ebp)
  800b00:	ff 75 08             	pushl  0x8(%ebp)
  800b03:	e8 16 fc ff ff       	call   80071e <vprintfmt>
  800b08:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b0b:	90                   	nop
  800b0c:	c9                   	leave  
  800b0d:	c3                   	ret    

00800b0e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b0e:	55                   	push   %ebp
  800b0f:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b11:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b14:	8b 40 08             	mov    0x8(%eax),%eax
  800b17:	8d 50 01             	lea    0x1(%eax),%edx
  800b1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1d:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b20:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b23:	8b 10                	mov    (%eax),%edx
  800b25:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b28:	8b 40 04             	mov    0x4(%eax),%eax
  800b2b:	39 c2                	cmp    %eax,%edx
  800b2d:	73 12                	jae    800b41 <sprintputch+0x33>
		*b->buf++ = ch;
  800b2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b32:	8b 00                	mov    (%eax),%eax
  800b34:	8d 48 01             	lea    0x1(%eax),%ecx
  800b37:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b3a:	89 0a                	mov    %ecx,(%edx)
  800b3c:	8b 55 08             	mov    0x8(%ebp),%edx
  800b3f:	88 10                	mov    %dl,(%eax)
}
  800b41:	90                   	nop
  800b42:	5d                   	pop    %ebp
  800b43:	c3                   	ret    

00800b44 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b44:	55                   	push   %ebp
  800b45:	89 e5                	mov    %esp,%ebp
  800b47:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b53:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b56:	8b 45 08             	mov    0x8(%ebp),%eax
  800b59:	01 d0                	add    %edx,%eax
  800b5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b5e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b65:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b69:	74 06                	je     800b71 <vsnprintf+0x2d>
  800b6b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b6f:	7f 07                	jg     800b78 <vsnprintf+0x34>
		return -E_INVAL;
  800b71:	b8 03 00 00 00       	mov    $0x3,%eax
  800b76:	eb 20                	jmp    800b98 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b78:	ff 75 14             	pushl  0x14(%ebp)
  800b7b:	ff 75 10             	pushl  0x10(%ebp)
  800b7e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b81:	50                   	push   %eax
  800b82:	68 0e 0b 80 00       	push   $0x800b0e
  800b87:	e8 92 fb ff ff       	call   80071e <vprintfmt>
  800b8c:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b92:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b95:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b98:	c9                   	leave  
  800b99:	c3                   	ret    

00800b9a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b9a:	55                   	push   %ebp
  800b9b:	89 e5                	mov    %esp,%ebp
  800b9d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ba0:	8d 45 10             	lea    0x10(%ebp),%eax
  800ba3:	83 c0 04             	add    $0x4,%eax
  800ba6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ba9:	8b 45 10             	mov    0x10(%ebp),%eax
  800bac:	ff 75 f4             	pushl  -0xc(%ebp)
  800baf:	50                   	push   %eax
  800bb0:	ff 75 0c             	pushl  0xc(%ebp)
  800bb3:	ff 75 08             	pushl  0x8(%ebp)
  800bb6:	e8 89 ff ff ff       	call   800b44 <vsnprintf>
  800bbb:	83 c4 10             	add    $0x10,%esp
  800bbe:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bc4:	c9                   	leave  
  800bc5:	c3                   	ret    

00800bc6 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800bc6:	55                   	push   %ebp
  800bc7:	89 e5                	mov    %esp,%ebp
  800bc9:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bcc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bd3:	eb 06                	jmp    800bdb <strlen+0x15>
		n++;
  800bd5:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bd8:	ff 45 08             	incl   0x8(%ebp)
  800bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bde:	8a 00                	mov    (%eax),%al
  800be0:	84 c0                	test   %al,%al
  800be2:	75 f1                	jne    800bd5 <strlen+0xf>
		n++;
	return n;
  800be4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800be7:	c9                   	leave  
  800be8:	c3                   	ret    

00800be9 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800be9:	55                   	push   %ebp
  800bea:	89 e5                	mov    %esp,%ebp
  800bec:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bf6:	eb 09                	jmp    800c01 <strnlen+0x18>
		n++;
  800bf8:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bfb:	ff 45 08             	incl   0x8(%ebp)
  800bfe:	ff 4d 0c             	decl   0xc(%ebp)
  800c01:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c05:	74 09                	je     800c10 <strnlen+0x27>
  800c07:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0a:	8a 00                	mov    (%eax),%al
  800c0c:	84 c0                	test   %al,%al
  800c0e:	75 e8                	jne    800bf8 <strnlen+0xf>
		n++;
	return n;
  800c10:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c13:	c9                   	leave  
  800c14:	c3                   	ret    

00800c15 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c15:	55                   	push   %ebp
  800c16:	89 e5                	mov    %esp,%ebp
  800c18:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c21:	90                   	nop
  800c22:	8b 45 08             	mov    0x8(%ebp),%eax
  800c25:	8d 50 01             	lea    0x1(%eax),%edx
  800c28:	89 55 08             	mov    %edx,0x8(%ebp)
  800c2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c2e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c31:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c34:	8a 12                	mov    (%edx),%dl
  800c36:	88 10                	mov    %dl,(%eax)
  800c38:	8a 00                	mov    (%eax),%al
  800c3a:	84 c0                	test   %al,%al
  800c3c:	75 e4                	jne    800c22 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c3e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c41:	c9                   	leave  
  800c42:	c3                   	ret    

00800c43 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c43:	55                   	push   %ebp
  800c44:	89 e5                	mov    %esp,%ebp
  800c46:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c49:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c4f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c56:	eb 1f                	jmp    800c77 <strncpy+0x34>
		*dst++ = *src;
  800c58:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5b:	8d 50 01             	lea    0x1(%eax),%edx
  800c5e:	89 55 08             	mov    %edx,0x8(%ebp)
  800c61:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c64:	8a 12                	mov    (%edx),%dl
  800c66:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c6b:	8a 00                	mov    (%eax),%al
  800c6d:	84 c0                	test   %al,%al
  800c6f:	74 03                	je     800c74 <strncpy+0x31>
			src++;
  800c71:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c74:	ff 45 fc             	incl   -0x4(%ebp)
  800c77:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c7a:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c7d:	72 d9                	jb     800c58 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c7f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c82:	c9                   	leave  
  800c83:	c3                   	ret    

00800c84 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c84:	55                   	push   %ebp
  800c85:	89 e5                	mov    %esp,%ebp
  800c87:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c90:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c94:	74 30                	je     800cc6 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c96:	eb 16                	jmp    800cae <strlcpy+0x2a>
			*dst++ = *src++;
  800c98:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9b:	8d 50 01             	lea    0x1(%eax),%edx
  800c9e:	89 55 08             	mov    %edx,0x8(%ebp)
  800ca1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ca4:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ca7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800caa:	8a 12                	mov    (%edx),%dl
  800cac:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cae:	ff 4d 10             	decl   0x10(%ebp)
  800cb1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cb5:	74 09                	je     800cc0 <strlcpy+0x3c>
  800cb7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cba:	8a 00                	mov    (%eax),%al
  800cbc:	84 c0                	test   %al,%al
  800cbe:	75 d8                	jne    800c98 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc3:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cc6:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ccc:	29 c2                	sub    %eax,%edx
  800cce:	89 d0                	mov    %edx,%eax
}
  800cd0:	c9                   	leave  
  800cd1:	c3                   	ret    

00800cd2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cd2:	55                   	push   %ebp
  800cd3:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cd5:	eb 06                	jmp    800cdd <strcmp+0xb>
		p++, q++;
  800cd7:	ff 45 08             	incl   0x8(%ebp)
  800cda:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce0:	8a 00                	mov    (%eax),%al
  800ce2:	84 c0                	test   %al,%al
  800ce4:	74 0e                	je     800cf4 <strcmp+0x22>
  800ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce9:	8a 10                	mov    (%eax),%dl
  800ceb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cee:	8a 00                	mov    (%eax),%al
  800cf0:	38 c2                	cmp    %al,%dl
  800cf2:	74 e3                	je     800cd7 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf7:	8a 00                	mov    (%eax),%al
  800cf9:	0f b6 d0             	movzbl %al,%edx
  800cfc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cff:	8a 00                	mov    (%eax),%al
  800d01:	0f b6 c0             	movzbl %al,%eax
  800d04:	29 c2                	sub    %eax,%edx
  800d06:	89 d0                	mov    %edx,%eax
}
  800d08:	5d                   	pop    %ebp
  800d09:	c3                   	ret    

00800d0a <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d0a:	55                   	push   %ebp
  800d0b:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d0d:	eb 09                	jmp    800d18 <strncmp+0xe>
		n--, p++, q++;
  800d0f:	ff 4d 10             	decl   0x10(%ebp)
  800d12:	ff 45 08             	incl   0x8(%ebp)
  800d15:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d18:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d1c:	74 17                	je     800d35 <strncmp+0x2b>
  800d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d21:	8a 00                	mov    (%eax),%al
  800d23:	84 c0                	test   %al,%al
  800d25:	74 0e                	je     800d35 <strncmp+0x2b>
  800d27:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2a:	8a 10                	mov    (%eax),%dl
  800d2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2f:	8a 00                	mov    (%eax),%al
  800d31:	38 c2                	cmp    %al,%dl
  800d33:	74 da                	je     800d0f <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d35:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d39:	75 07                	jne    800d42 <strncmp+0x38>
		return 0;
  800d3b:	b8 00 00 00 00       	mov    $0x0,%eax
  800d40:	eb 14                	jmp    800d56 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d42:	8b 45 08             	mov    0x8(%ebp),%eax
  800d45:	8a 00                	mov    (%eax),%al
  800d47:	0f b6 d0             	movzbl %al,%edx
  800d4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d4d:	8a 00                	mov    (%eax),%al
  800d4f:	0f b6 c0             	movzbl %al,%eax
  800d52:	29 c2                	sub    %eax,%edx
  800d54:	89 d0                	mov    %edx,%eax
}
  800d56:	5d                   	pop    %ebp
  800d57:	c3                   	ret    

00800d58 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d58:	55                   	push   %ebp
  800d59:	89 e5                	mov    %esp,%ebp
  800d5b:	83 ec 04             	sub    $0x4,%esp
  800d5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d61:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d64:	eb 12                	jmp    800d78 <strchr+0x20>
		if (*s == c)
  800d66:	8b 45 08             	mov    0x8(%ebp),%eax
  800d69:	8a 00                	mov    (%eax),%al
  800d6b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d6e:	75 05                	jne    800d75 <strchr+0x1d>
			return (char *) s;
  800d70:	8b 45 08             	mov    0x8(%ebp),%eax
  800d73:	eb 11                	jmp    800d86 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d75:	ff 45 08             	incl   0x8(%ebp)
  800d78:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7b:	8a 00                	mov    (%eax),%al
  800d7d:	84 c0                	test   %al,%al
  800d7f:	75 e5                	jne    800d66 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d81:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d86:	c9                   	leave  
  800d87:	c3                   	ret    

00800d88 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d88:	55                   	push   %ebp
  800d89:	89 e5                	mov    %esp,%ebp
  800d8b:	83 ec 04             	sub    $0x4,%esp
  800d8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d91:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d94:	eb 0d                	jmp    800da3 <strfind+0x1b>
		if (*s == c)
  800d96:	8b 45 08             	mov    0x8(%ebp),%eax
  800d99:	8a 00                	mov    (%eax),%al
  800d9b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d9e:	74 0e                	je     800dae <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800da0:	ff 45 08             	incl   0x8(%ebp)
  800da3:	8b 45 08             	mov    0x8(%ebp),%eax
  800da6:	8a 00                	mov    (%eax),%al
  800da8:	84 c0                	test   %al,%al
  800daa:	75 ea                	jne    800d96 <strfind+0xe>
  800dac:	eb 01                	jmp    800daf <strfind+0x27>
		if (*s == c)
			break;
  800dae:	90                   	nop
	return (char *) s;
  800daf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800db2:	c9                   	leave  
  800db3:	c3                   	ret    

00800db4 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800db4:	55                   	push   %ebp
  800db5:	89 e5                	mov    %esp,%ebp
  800db7:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800dba:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800dc0:	8b 45 10             	mov    0x10(%ebp),%eax
  800dc3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800dc6:	eb 0e                	jmp    800dd6 <memset+0x22>
		*p++ = c;
  800dc8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dcb:	8d 50 01             	lea    0x1(%eax),%edx
  800dce:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800dd1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dd4:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800dd6:	ff 4d f8             	decl   -0x8(%ebp)
  800dd9:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800ddd:	79 e9                	jns    800dc8 <memset+0x14>
		*p++ = c;

	return v;
  800ddf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800de2:	c9                   	leave  
  800de3:	c3                   	ret    

00800de4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800de4:	55                   	push   %ebp
  800de5:	89 e5                	mov    %esp,%ebp
  800de7:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ded:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800df0:	8b 45 08             	mov    0x8(%ebp),%eax
  800df3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800df6:	eb 16                	jmp    800e0e <memcpy+0x2a>
		*d++ = *s++;
  800df8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dfb:	8d 50 01             	lea    0x1(%eax),%edx
  800dfe:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e01:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e04:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e07:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e0a:	8a 12                	mov    (%edx),%dl
  800e0c:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e0e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e11:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e14:	89 55 10             	mov    %edx,0x10(%ebp)
  800e17:	85 c0                	test   %eax,%eax
  800e19:	75 dd                	jne    800df8 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e1b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e1e:	c9                   	leave  
  800e1f:	c3                   	ret    

00800e20 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e20:	55                   	push   %ebp
  800e21:	89 e5                	mov    %esp,%ebp
  800e23:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e26:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e29:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e32:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e35:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e38:	73 50                	jae    800e8a <memmove+0x6a>
  800e3a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e3d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e40:	01 d0                	add    %edx,%eax
  800e42:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e45:	76 43                	jbe    800e8a <memmove+0x6a>
		s += n;
  800e47:	8b 45 10             	mov    0x10(%ebp),%eax
  800e4a:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e4d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e50:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e53:	eb 10                	jmp    800e65 <memmove+0x45>
			*--d = *--s;
  800e55:	ff 4d f8             	decl   -0x8(%ebp)
  800e58:	ff 4d fc             	decl   -0x4(%ebp)
  800e5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e5e:	8a 10                	mov    (%eax),%dl
  800e60:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e63:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e65:	8b 45 10             	mov    0x10(%ebp),%eax
  800e68:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e6b:	89 55 10             	mov    %edx,0x10(%ebp)
  800e6e:	85 c0                	test   %eax,%eax
  800e70:	75 e3                	jne    800e55 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e72:	eb 23                	jmp    800e97 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e74:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e77:	8d 50 01             	lea    0x1(%eax),%edx
  800e7a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e7d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e80:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e83:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e86:	8a 12                	mov    (%edx),%dl
  800e88:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e8a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e8d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e90:	89 55 10             	mov    %edx,0x10(%ebp)
  800e93:	85 c0                	test   %eax,%eax
  800e95:	75 dd                	jne    800e74 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e97:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e9a:	c9                   	leave  
  800e9b:	c3                   	ret    

00800e9c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e9c:	55                   	push   %ebp
  800e9d:	89 e5                	mov    %esp,%ebp
  800e9f:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ea2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ea8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eab:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800eae:	eb 2a                	jmp    800eda <memcmp+0x3e>
		if (*s1 != *s2)
  800eb0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eb3:	8a 10                	mov    (%eax),%dl
  800eb5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eb8:	8a 00                	mov    (%eax),%al
  800eba:	38 c2                	cmp    %al,%dl
  800ebc:	74 16                	je     800ed4 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ebe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ec1:	8a 00                	mov    (%eax),%al
  800ec3:	0f b6 d0             	movzbl %al,%edx
  800ec6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ec9:	8a 00                	mov    (%eax),%al
  800ecb:	0f b6 c0             	movzbl %al,%eax
  800ece:	29 c2                	sub    %eax,%edx
  800ed0:	89 d0                	mov    %edx,%eax
  800ed2:	eb 18                	jmp    800eec <memcmp+0x50>
		s1++, s2++;
  800ed4:	ff 45 fc             	incl   -0x4(%ebp)
  800ed7:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800eda:	8b 45 10             	mov    0x10(%ebp),%eax
  800edd:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ee0:	89 55 10             	mov    %edx,0x10(%ebp)
  800ee3:	85 c0                	test   %eax,%eax
  800ee5:	75 c9                	jne    800eb0 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ee7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800eec:	c9                   	leave  
  800eed:	c3                   	ret    

00800eee <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800eee:	55                   	push   %ebp
  800eef:	89 e5                	mov    %esp,%ebp
  800ef1:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ef4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef7:	8b 45 10             	mov    0x10(%ebp),%eax
  800efa:	01 d0                	add    %edx,%eax
  800efc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800eff:	eb 15                	jmp    800f16 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f01:	8b 45 08             	mov    0x8(%ebp),%eax
  800f04:	8a 00                	mov    (%eax),%al
  800f06:	0f b6 d0             	movzbl %al,%edx
  800f09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f0c:	0f b6 c0             	movzbl %al,%eax
  800f0f:	39 c2                	cmp    %eax,%edx
  800f11:	74 0d                	je     800f20 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f13:	ff 45 08             	incl   0x8(%ebp)
  800f16:	8b 45 08             	mov    0x8(%ebp),%eax
  800f19:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f1c:	72 e3                	jb     800f01 <memfind+0x13>
  800f1e:	eb 01                	jmp    800f21 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f20:	90                   	nop
	return (void *) s;
  800f21:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f24:	c9                   	leave  
  800f25:	c3                   	ret    

00800f26 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f26:	55                   	push   %ebp
  800f27:	89 e5                	mov    %esp,%ebp
  800f29:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f2c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f33:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f3a:	eb 03                	jmp    800f3f <strtol+0x19>
		s++;
  800f3c:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f42:	8a 00                	mov    (%eax),%al
  800f44:	3c 20                	cmp    $0x20,%al
  800f46:	74 f4                	je     800f3c <strtol+0x16>
  800f48:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4b:	8a 00                	mov    (%eax),%al
  800f4d:	3c 09                	cmp    $0x9,%al
  800f4f:	74 eb                	je     800f3c <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f51:	8b 45 08             	mov    0x8(%ebp),%eax
  800f54:	8a 00                	mov    (%eax),%al
  800f56:	3c 2b                	cmp    $0x2b,%al
  800f58:	75 05                	jne    800f5f <strtol+0x39>
		s++;
  800f5a:	ff 45 08             	incl   0x8(%ebp)
  800f5d:	eb 13                	jmp    800f72 <strtol+0x4c>
	else if (*s == '-')
  800f5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f62:	8a 00                	mov    (%eax),%al
  800f64:	3c 2d                	cmp    $0x2d,%al
  800f66:	75 0a                	jne    800f72 <strtol+0x4c>
		s++, neg = 1;
  800f68:	ff 45 08             	incl   0x8(%ebp)
  800f6b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f72:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f76:	74 06                	je     800f7e <strtol+0x58>
  800f78:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f7c:	75 20                	jne    800f9e <strtol+0x78>
  800f7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f81:	8a 00                	mov    (%eax),%al
  800f83:	3c 30                	cmp    $0x30,%al
  800f85:	75 17                	jne    800f9e <strtol+0x78>
  800f87:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8a:	40                   	inc    %eax
  800f8b:	8a 00                	mov    (%eax),%al
  800f8d:	3c 78                	cmp    $0x78,%al
  800f8f:	75 0d                	jne    800f9e <strtol+0x78>
		s += 2, base = 16;
  800f91:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f95:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f9c:	eb 28                	jmp    800fc6 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f9e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fa2:	75 15                	jne    800fb9 <strtol+0x93>
  800fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa7:	8a 00                	mov    (%eax),%al
  800fa9:	3c 30                	cmp    $0x30,%al
  800fab:	75 0c                	jne    800fb9 <strtol+0x93>
		s++, base = 8;
  800fad:	ff 45 08             	incl   0x8(%ebp)
  800fb0:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fb7:	eb 0d                	jmp    800fc6 <strtol+0xa0>
	else if (base == 0)
  800fb9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fbd:	75 07                	jne    800fc6 <strtol+0xa0>
		base = 10;
  800fbf:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc9:	8a 00                	mov    (%eax),%al
  800fcb:	3c 2f                	cmp    $0x2f,%al
  800fcd:	7e 19                	jle    800fe8 <strtol+0xc2>
  800fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd2:	8a 00                	mov    (%eax),%al
  800fd4:	3c 39                	cmp    $0x39,%al
  800fd6:	7f 10                	jg     800fe8 <strtol+0xc2>
			dig = *s - '0';
  800fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdb:	8a 00                	mov    (%eax),%al
  800fdd:	0f be c0             	movsbl %al,%eax
  800fe0:	83 e8 30             	sub    $0x30,%eax
  800fe3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fe6:	eb 42                	jmp    80102a <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fe8:	8b 45 08             	mov    0x8(%ebp),%eax
  800feb:	8a 00                	mov    (%eax),%al
  800fed:	3c 60                	cmp    $0x60,%al
  800fef:	7e 19                	jle    80100a <strtol+0xe4>
  800ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff4:	8a 00                	mov    (%eax),%al
  800ff6:	3c 7a                	cmp    $0x7a,%al
  800ff8:	7f 10                	jg     80100a <strtol+0xe4>
			dig = *s - 'a' + 10;
  800ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffd:	8a 00                	mov    (%eax),%al
  800fff:	0f be c0             	movsbl %al,%eax
  801002:	83 e8 57             	sub    $0x57,%eax
  801005:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801008:	eb 20                	jmp    80102a <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80100a:	8b 45 08             	mov    0x8(%ebp),%eax
  80100d:	8a 00                	mov    (%eax),%al
  80100f:	3c 40                	cmp    $0x40,%al
  801011:	7e 39                	jle    80104c <strtol+0x126>
  801013:	8b 45 08             	mov    0x8(%ebp),%eax
  801016:	8a 00                	mov    (%eax),%al
  801018:	3c 5a                	cmp    $0x5a,%al
  80101a:	7f 30                	jg     80104c <strtol+0x126>
			dig = *s - 'A' + 10;
  80101c:	8b 45 08             	mov    0x8(%ebp),%eax
  80101f:	8a 00                	mov    (%eax),%al
  801021:	0f be c0             	movsbl %al,%eax
  801024:	83 e8 37             	sub    $0x37,%eax
  801027:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80102a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80102d:	3b 45 10             	cmp    0x10(%ebp),%eax
  801030:	7d 19                	jge    80104b <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801032:	ff 45 08             	incl   0x8(%ebp)
  801035:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801038:	0f af 45 10          	imul   0x10(%ebp),%eax
  80103c:	89 c2                	mov    %eax,%edx
  80103e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801041:	01 d0                	add    %edx,%eax
  801043:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801046:	e9 7b ff ff ff       	jmp    800fc6 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80104b:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80104c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801050:	74 08                	je     80105a <strtol+0x134>
		*endptr = (char *) s;
  801052:	8b 45 0c             	mov    0xc(%ebp),%eax
  801055:	8b 55 08             	mov    0x8(%ebp),%edx
  801058:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80105a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80105e:	74 07                	je     801067 <strtol+0x141>
  801060:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801063:	f7 d8                	neg    %eax
  801065:	eb 03                	jmp    80106a <strtol+0x144>
  801067:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80106a:	c9                   	leave  
  80106b:	c3                   	ret    

0080106c <ltostr>:

void
ltostr(long value, char *str)
{
  80106c:	55                   	push   %ebp
  80106d:	89 e5                	mov    %esp,%ebp
  80106f:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801072:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801079:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801080:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801084:	79 13                	jns    801099 <ltostr+0x2d>
	{
		neg = 1;
  801086:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80108d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801090:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801093:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801096:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801099:	8b 45 08             	mov    0x8(%ebp),%eax
  80109c:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010a1:	99                   	cltd   
  8010a2:	f7 f9                	idiv   %ecx
  8010a4:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010aa:	8d 50 01             	lea    0x1(%eax),%edx
  8010ad:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010b0:	89 c2                	mov    %eax,%edx
  8010b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b5:	01 d0                	add    %edx,%eax
  8010b7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010ba:	83 c2 30             	add    $0x30,%edx
  8010bd:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010c2:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010c7:	f7 e9                	imul   %ecx
  8010c9:	c1 fa 02             	sar    $0x2,%edx
  8010cc:	89 c8                	mov    %ecx,%eax
  8010ce:	c1 f8 1f             	sar    $0x1f,%eax
  8010d1:	29 c2                	sub    %eax,%edx
  8010d3:	89 d0                	mov    %edx,%eax
  8010d5:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010d8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010db:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010e0:	f7 e9                	imul   %ecx
  8010e2:	c1 fa 02             	sar    $0x2,%edx
  8010e5:	89 c8                	mov    %ecx,%eax
  8010e7:	c1 f8 1f             	sar    $0x1f,%eax
  8010ea:	29 c2                	sub    %eax,%edx
  8010ec:	89 d0                	mov    %edx,%eax
  8010ee:	c1 e0 02             	shl    $0x2,%eax
  8010f1:	01 d0                	add    %edx,%eax
  8010f3:	01 c0                	add    %eax,%eax
  8010f5:	29 c1                	sub    %eax,%ecx
  8010f7:	89 ca                	mov    %ecx,%edx
  8010f9:	85 d2                	test   %edx,%edx
  8010fb:	75 9c                	jne    801099 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010fd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801104:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801107:	48                   	dec    %eax
  801108:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80110b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80110f:	74 3d                	je     80114e <ltostr+0xe2>
		start = 1 ;
  801111:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801118:	eb 34                	jmp    80114e <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80111a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80111d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801120:	01 d0                	add    %edx,%eax
  801122:	8a 00                	mov    (%eax),%al
  801124:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801127:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80112a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112d:	01 c2                	add    %eax,%edx
  80112f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801132:	8b 45 0c             	mov    0xc(%ebp),%eax
  801135:	01 c8                	add    %ecx,%eax
  801137:	8a 00                	mov    (%eax),%al
  801139:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80113b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80113e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801141:	01 c2                	add    %eax,%edx
  801143:	8a 45 eb             	mov    -0x15(%ebp),%al
  801146:	88 02                	mov    %al,(%edx)
		start++ ;
  801148:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80114b:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80114e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801151:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801154:	7c c4                	jl     80111a <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801156:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801159:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115c:	01 d0                	add    %edx,%eax
  80115e:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801161:	90                   	nop
  801162:	c9                   	leave  
  801163:	c3                   	ret    

00801164 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801164:	55                   	push   %ebp
  801165:	89 e5                	mov    %esp,%ebp
  801167:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80116a:	ff 75 08             	pushl  0x8(%ebp)
  80116d:	e8 54 fa ff ff       	call   800bc6 <strlen>
  801172:	83 c4 04             	add    $0x4,%esp
  801175:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801178:	ff 75 0c             	pushl  0xc(%ebp)
  80117b:	e8 46 fa ff ff       	call   800bc6 <strlen>
  801180:	83 c4 04             	add    $0x4,%esp
  801183:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801186:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80118d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801194:	eb 17                	jmp    8011ad <strcconcat+0x49>
		final[s] = str1[s] ;
  801196:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801199:	8b 45 10             	mov    0x10(%ebp),%eax
  80119c:	01 c2                	add    %eax,%edx
  80119e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a4:	01 c8                	add    %ecx,%eax
  8011a6:	8a 00                	mov    (%eax),%al
  8011a8:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8011aa:	ff 45 fc             	incl   -0x4(%ebp)
  8011ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011b0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011b3:	7c e1                	jl     801196 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011b5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011bc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011c3:	eb 1f                	jmp    8011e4 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011c8:	8d 50 01             	lea    0x1(%eax),%edx
  8011cb:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011ce:	89 c2                	mov    %eax,%edx
  8011d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d3:	01 c2                	add    %eax,%edx
  8011d5:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011db:	01 c8                	add    %ecx,%eax
  8011dd:	8a 00                	mov    (%eax),%al
  8011df:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011e1:	ff 45 f8             	incl   -0x8(%ebp)
  8011e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011e7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011ea:	7c d9                	jl     8011c5 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011ec:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f2:	01 d0                	add    %edx,%eax
  8011f4:	c6 00 00             	movb   $0x0,(%eax)
}
  8011f7:	90                   	nop
  8011f8:	c9                   	leave  
  8011f9:	c3                   	ret    

008011fa <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011fa:	55                   	push   %ebp
  8011fb:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011fd:	8b 45 14             	mov    0x14(%ebp),%eax
  801200:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801206:	8b 45 14             	mov    0x14(%ebp),%eax
  801209:	8b 00                	mov    (%eax),%eax
  80120b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801212:	8b 45 10             	mov    0x10(%ebp),%eax
  801215:	01 d0                	add    %edx,%eax
  801217:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80121d:	eb 0c                	jmp    80122b <strsplit+0x31>
			*string++ = 0;
  80121f:	8b 45 08             	mov    0x8(%ebp),%eax
  801222:	8d 50 01             	lea    0x1(%eax),%edx
  801225:	89 55 08             	mov    %edx,0x8(%ebp)
  801228:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80122b:	8b 45 08             	mov    0x8(%ebp),%eax
  80122e:	8a 00                	mov    (%eax),%al
  801230:	84 c0                	test   %al,%al
  801232:	74 18                	je     80124c <strsplit+0x52>
  801234:	8b 45 08             	mov    0x8(%ebp),%eax
  801237:	8a 00                	mov    (%eax),%al
  801239:	0f be c0             	movsbl %al,%eax
  80123c:	50                   	push   %eax
  80123d:	ff 75 0c             	pushl  0xc(%ebp)
  801240:	e8 13 fb ff ff       	call   800d58 <strchr>
  801245:	83 c4 08             	add    $0x8,%esp
  801248:	85 c0                	test   %eax,%eax
  80124a:	75 d3                	jne    80121f <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80124c:	8b 45 08             	mov    0x8(%ebp),%eax
  80124f:	8a 00                	mov    (%eax),%al
  801251:	84 c0                	test   %al,%al
  801253:	74 5a                	je     8012af <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801255:	8b 45 14             	mov    0x14(%ebp),%eax
  801258:	8b 00                	mov    (%eax),%eax
  80125a:	83 f8 0f             	cmp    $0xf,%eax
  80125d:	75 07                	jne    801266 <strsplit+0x6c>
		{
			return 0;
  80125f:	b8 00 00 00 00       	mov    $0x0,%eax
  801264:	eb 66                	jmp    8012cc <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801266:	8b 45 14             	mov    0x14(%ebp),%eax
  801269:	8b 00                	mov    (%eax),%eax
  80126b:	8d 48 01             	lea    0x1(%eax),%ecx
  80126e:	8b 55 14             	mov    0x14(%ebp),%edx
  801271:	89 0a                	mov    %ecx,(%edx)
  801273:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80127a:	8b 45 10             	mov    0x10(%ebp),%eax
  80127d:	01 c2                	add    %eax,%edx
  80127f:	8b 45 08             	mov    0x8(%ebp),%eax
  801282:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801284:	eb 03                	jmp    801289 <strsplit+0x8f>
			string++;
  801286:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801289:	8b 45 08             	mov    0x8(%ebp),%eax
  80128c:	8a 00                	mov    (%eax),%al
  80128e:	84 c0                	test   %al,%al
  801290:	74 8b                	je     80121d <strsplit+0x23>
  801292:	8b 45 08             	mov    0x8(%ebp),%eax
  801295:	8a 00                	mov    (%eax),%al
  801297:	0f be c0             	movsbl %al,%eax
  80129a:	50                   	push   %eax
  80129b:	ff 75 0c             	pushl  0xc(%ebp)
  80129e:	e8 b5 fa ff ff       	call   800d58 <strchr>
  8012a3:	83 c4 08             	add    $0x8,%esp
  8012a6:	85 c0                	test   %eax,%eax
  8012a8:	74 dc                	je     801286 <strsplit+0x8c>
			string++;
	}
  8012aa:	e9 6e ff ff ff       	jmp    80121d <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012af:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8012b3:	8b 00                	mov    (%eax),%eax
  8012b5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8012bf:	01 d0                	add    %edx,%eax
  8012c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012c7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012cc:	c9                   	leave  
  8012cd:	c3                   	ret    

008012ce <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8012ce:	55                   	push   %ebp
  8012cf:	89 e5                	mov    %esp,%ebp
  8012d1:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8012d4:	a1 04 50 80 00       	mov    0x805004,%eax
  8012d9:	85 c0                	test   %eax,%eax
  8012db:	74 1f                	je     8012fc <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8012dd:	e8 1d 00 00 00       	call   8012ff <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8012e2:	83 ec 0c             	sub    $0xc,%esp
  8012e5:	68 f0 3d 80 00       	push   $0x803df0
  8012ea:	e8 55 f2 ff ff       	call   800544 <cprintf>
  8012ef:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8012f2:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  8012f9:	00 00 00 
	}
}
  8012fc:	90                   	nop
  8012fd:	c9                   	leave  
  8012fe:	c3                   	ret    

008012ff <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8012ff:	55                   	push   %ebp
  801300:	89 e5                	mov    %esp,%ebp
  801302:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	LIST_INIT(&AllocMemBlocksList);
  801305:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  80130c:	00 00 00 
  80130f:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801316:	00 00 00 
  801319:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801320:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801323:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  80132a:	00 00 00 
  80132d:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801334:	00 00 00 
  801337:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  80133e:	00 00 00 
	uint32 arr_size = 0;
  801341:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	MemBlockNodes  =(struct MemBlock*) USER_DYN_BLKS_ARRAY;
  801348:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  80134f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801352:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801357:	2d 00 10 00 00       	sub    $0x1000,%eax
  80135c:	a3 50 50 80 00       	mov    %eax,0x805050
	MAX_MEM_BLOCK_CNT = (USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE;
  801361:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801368:	00 02 00 
	arr_size =  ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock), PAGE_SIZE);
  80136b:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801372:	a1 20 51 80 00       	mov    0x805120,%eax
  801377:	c1 e0 04             	shl    $0x4,%eax
  80137a:	89 c2                	mov    %eax,%edx
  80137c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80137f:	01 d0                	add    %edx,%eax
  801381:	48                   	dec    %eax
  801382:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801385:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801388:	ba 00 00 00 00       	mov    $0x0,%edx
  80138d:	f7 75 ec             	divl   -0x14(%ebp)
  801390:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801393:	29 d0                	sub    %edx,%eax
  801395:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_USER);
  801398:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  80139f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013a2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013a7:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013ac:	83 ec 04             	sub    $0x4,%esp
  8013af:	6a 06                	push   $0x6
  8013b1:	ff 75 f4             	pushl  -0xc(%ebp)
  8013b4:	50                   	push   %eax
  8013b5:	e8 fc 04 00 00       	call   8018b6 <sys_allocate_chunk>
  8013ba:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013bd:	a1 20 51 80 00       	mov    0x805120,%eax
  8013c2:	83 ec 0c             	sub    $0xc,%esp
  8013c5:	50                   	push   %eax
  8013c6:	e8 71 0b 00 00       	call   801f3c <initialize_MemBlocksList>
  8013cb:	83 c4 10             	add    $0x10,%esp
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	struct MemBlock * NewBlock = LIST_FIRST(&AvailableMemBlocksList);
  8013ce:	a1 48 51 80 00       	mov    0x805148,%eax
  8013d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
	NewBlock->sva = USER_HEAP_START;
  8013d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013d9:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	NewBlock->size = (USER_HEAP_MAX-USER_HEAP_START);
  8013e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013e3:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	LIST_REMOVE(&AvailableMemBlocksList,NewBlock);
  8013ea:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8013ee:	75 14                	jne    801404 <initialize_dyn_block_system+0x105>
  8013f0:	83 ec 04             	sub    $0x4,%esp
  8013f3:	68 15 3e 80 00       	push   $0x803e15
  8013f8:	6a 33                	push   $0x33
  8013fa:	68 33 3e 80 00       	push   $0x803e33
  8013ff:	e8 8c ee ff ff       	call   800290 <_panic>
  801404:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801407:	8b 00                	mov    (%eax),%eax
  801409:	85 c0                	test   %eax,%eax
  80140b:	74 10                	je     80141d <initialize_dyn_block_system+0x11e>
  80140d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801410:	8b 00                	mov    (%eax),%eax
  801412:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801415:	8b 52 04             	mov    0x4(%edx),%edx
  801418:	89 50 04             	mov    %edx,0x4(%eax)
  80141b:	eb 0b                	jmp    801428 <initialize_dyn_block_system+0x129>
  80141d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801420:	8b 40 04             	mov    0x4(%eax),%eax
  801423:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801428:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80142b:	8b 40 04             	mov    0x4(%eax),%eax
  80142e:	85 c0                	test   %eax,%eax
  801430:	74 0f                	je     801441 <initialize_dyn_block_system+0x142>
  801432:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801435:	8b 40 04             	mov    0x4(%eax),%eax
  801438:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80143b:	8b 12                	mov    (%edx),%edx
  80143d:	89 10                	mov    %edx,(%eax)
  80143f:	eb 0a                	jmp    80144b <initialize_dyn_block_system+0x14c>
  801441:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801444:	8b 00                	mov    (%eax),%eax
  801446:	a3 48 51 80 00       	mov    %eax,0x805148
  80144b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80144e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801454:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801457:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80145e:	a1 54 51 80 00       	mov    0x805154,%eax
  801463:	48                   	dec    %eax
  801464:	a3 54 51 80 00       	mov    %eax,0x805154
	LIST_INSERT_HEAD(&FreeMemBlocksList, NewBlock);
  801469:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80146d:	75 14                	jne    801483 <initialize_dyn_block_system+0x184>
  80146f:	83 ec 04             	sub    $0x4,%esp
  801472:	68 40 3e 80 00       	push   $0x803e40
  801477:	6a 34                	push   $0x34
  801479:	68 33 3e 80 00       	push   $0x803e33
  80147e:	e8 0d ee ff ff       	call   800290 <_panic>
  801483:	8b 15 38 51 80 00    	mov    0x805138,%edx
  801489:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80148c:	89 10                	mov    %edx,(%eax)
  80148e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801491:	8b 00                	mov    (%eax),%eax
  801493:	85 c0                	test   %eax,%eax
  801495:	74 0d                	je     8014a4 <initialize_dyn_block_system+0x1a5>
  801497:	a1 38 51 80 00       	mov    0x805138,%eax
  80149c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80149f:	89 50 04             	mov    %edx,0x4(%eax)
  8014a2:	eb 08                	jmp    8014ac <initialize_dyn_block_system+0x1ad>
  8014a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014a7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8014ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014af:	a3 38 51 80 00       	mov    %eax,0x805138
  8014b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014b7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8014be:	a1 44 51 80 00       	mov    0x805144,%eax
  8014c3:	40                   	inc    %eax
  8014c4:	a3 44 51 80 00       	mov    %eax,0x805144
}
  8014c9:	90                   	nop
  8014ca:	c9                   	leave  
  8014cb:	c3                   	ret    

008014cc <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8014cc:	55                   	push   %ebp
  8014cd:	89 e5                	mov    %esp,%ebp
  8014cf:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8014d2:	e8 f7 fd ff ff       	call   8012ce <InitializeUHeap>
	if (size == 0) return NULL ;
  8014d7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014db:	75 07                	jne    8014e4 <malloc+0x18>
  8014dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8014e2:	eb 61                	jmp    801545 <malloc+0x79>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
	uint32 malloc_allocsize=ROUNDUP(size,PAGE_SIZE);
  8014e4:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8014eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8014ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014f1:	01 d0                	add    %edx,%eax
  8014f3:	48                   	dec    %eax
  8014f4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8014f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8014ff:	f7 75 f0             	divl   -0x10(%ebp)
  801502:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801505:	29 d0                	sub    %edx,%eax
  801507:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 //int ret=0;
	struct MemBlock * user_block;
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80150a:	e8 75 07 00 00       	call   801c84 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80150f:	85 c0                	test   %eax,%eax
  801511:	74 11                	je     801524 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801513:	83 ec 0c             	sub    $0xc,%esp
  801516:	ff 75 e8             	pushl  -0x18(%ebp)
  801519:	e8 e0 0d 00 00       	call   8022fe <alloc_block_FF>
  80151e:	83 c4 10             	add    $0x10,%esp
  801521:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(user_block!=NULL)
  801524:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801528:	74 16                	je     801540 <malloc+0x74>
	{
		//sys_allocate_chunk(user_block->sva,malloc_allocsize,PERM_WRITEABLE| PERM_PRESENT);
		insert_sorted_allocList(user_block);
  80152a:	83 ec 0c             	sub    $0xc,%esp
  80152d:	ff 75 f4             	pushl  -0xc(%ebp)
  801530:	e8 3c 0b 00 00       	call   802071 <insert_sorted_allocList>
  801535:	83 c4 10             	add    $0x10,%esp
		return (uint32 *)user_block->sva;
  801538:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80153b:	8b 40 08             	mov    0x8(%eax),%eax
  80153e:	eb 05                	jmp    801545 <malloc+0x79>
	}

    return NULL;
  801540:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801545:	c9                   	leave  
  801546:	c3                   	ret    

00801547 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801547:	55                   	push   %ebp
  801548:	89 e5                	mov    %esp,%ebp
  80154a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  80154d:	83 ec 04             	sub    $0x4,%esp
  801550:	68 64 3e 80 00       	push   $0x803e64
  801555:	6a 6f                	push   $0x6f
  801557:	68 33 3e 80 00       	push   $0x803e33
  80155c:	e8 2f ed ff ff       	call   800290 <_panic>

00801561 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801561:	55                   	push   %ebp
  801562:	89 e5                	mov    %esp,%ebp
  801564:	83 ec 38             	sub    $0x38,%esp
  801567:	8b 45 10             	mov    0x10(%ebp),%eax
  80156a:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80156d:	e8 5c fd ff ff       	call   8012ce <InitializeUHeap>
	if (size == 0) return NULL ;
  801572:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801576:	75 0a                	jne    801582 <smalloc+0x21>
  801578:	b8 00 00 00 00       	mov    $0x0,%eax
  80157d:	e9 8b 00 00 00       	jmp    80160d <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801582:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801589:	8b 55 0c             	mov    0xc(%ebp),%edx
  80158c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80158f:	01 d0                	add    %edx,%eax
  801591:	48                   	dec    %eax
  801592:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801595:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801598:	ba 00 00 00 00       	mov    $0x0,%edx
  80159d:	f7 75 f0             	divl   -0x10(%ebp)
  8015a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015a3:	29 d0                	sub    %edx,%eax
  8015a5:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  8015a8:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8015af:	e8 d0 06 00 00       	call   801c84 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8015b4:	85 c0                	test   %eax,%eax
  8015b6:	74 11                	je     8015c9 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  8015b8:	83 ec 0c             	sub    $0xc,%esp
  8015bb:	ff 75 e8             	pushl  -0x18(%ebp)
  8015be:	e8 3b 0d 00 00       	call   8022fe <alloc_block_FF>
  8015c3:	83 c4 10             	add    $0x10,%esp
  8015c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  8015c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8015cd:	74 39                	je     801608 <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8015cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015d2:	8b 40 08             	mov    0x8(%eax),%eax
  8015d5:	89 c2                	mov    %eax,%edx
  8015d7:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8015db:	52                   	push   %edx
  8015dc:	50                   	push   %eax
  8015dd:	ff 75 0c             	pushl  0xc(%ebp)
  8015e0:	ff 75 08             	pushl  0x8(%ebp)
  8015e3:	e8 21 04 00 00       	call   801a09 <sys_createSharedObject>
  8015e8:	83 c4 10             	add    $0x10,%esp
  8015eb:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  8015ee:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  8015f2:	74 14                	je     801608 <smalloc+0xa7>
  8015f4:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  8015f8:	74 0e                	je     801608 <smalloc+0xa7>
  8015fa:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  8015fe:	74 08                	je     801608 <smalloc+0xa7>
			return (void*) mem_block->sva;
  801600:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801603:	8b 40 08             	mov    0x8(%eax),%eax
  801606:	eb 05                	jmp    80160d <smalloc+0xac>
	}
	return NULL;
  801608:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80160d:	c9                   	leave  
  80160e:	c3                   	ret    

0080160f <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80160f:	55                   	push   %ebp
  801610:	89 e5                	mov    %esp,%ebp
  801612:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801615:	e8 b4 fc ff ff       	call   8012ce <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80161a:	83 ec 08             	sub    $0x8,%esp
  80161d:	ff 75 0c             	pushl  0xc(%ebp)
  801620:	ff 75 08             	pushl  0x8(%ebp)
  801623:	e8 0b 04 00 00       	call   801a33 <sys_getSizeOfSharedObject>
  801628:	83 c4 10             	add    $0x10,%esp
  80162b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  80162e:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  801632:	74 76                	je     8016aa <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801634:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80163b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80163e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801641:	01 d0                	add    %edx,%eax
  801643:	48                   	dec    %eax
  801644:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801647:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80164a:	ba 00 00 00 00       	mov    $0x0,%edx
  80164f:	f7 75 ec             	divl   -0x14(%ebp)
  801652:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801655:	29 d0                	sub    %edx,%eax
  801657:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  80165a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801661:	e8 1e 06 00 00       	call   801c84 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801666:	85 c0                	test   %eax,%eax
  801668:	74 11                	je     80167b <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  80166a:	83 ec 0c             	sub    $0xc,%esp
  80166d:	ff 75 e4             	pushl  -0x1c(%ebp)
  801670:	e8 89 0c 00 00       	call   8022fe <alloc_block_FF>
  801675:	83 c4 10             	add    $0x10,%esp
  801678:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  80167b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80167f:	74 29                	je     8016aa <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  801681:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801684:	8b 40 08             	mov    0x8(%eax),%eax
  801687:	83 ec 04             	sub    $0x4,%esp
  80168a:	50                   	push   %eax
  80168b:	ff 75 0c             	pushl  0xc(%ebp)
  80168e:	ff 75 08             	pushl  0x8(%ebp)
  801691:	e8 ba 03 00 00       	call   801a50 <sys_getSharedObject>
  801696:	83 c4 10             	add    $0x10,%esp
  801699:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  80169c:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  8016a0:	74 08                	je     8016aa <sget+0x9b>
				return (void *)mem_block->sva;
  8016a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016a5:	8b 40 08             	mov    0x8(%eax),%eax
  8016a8:	eb 05                	jmp    8016af <sget+0xa0>
		}
	}
	return NULL;
  8016aa:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8016af:	c9                   	leave  
  8016b0:	c3                   	ret    

008016b1 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8016b1:	55                   	push   %ebp
  8016b2:	89 e5                	mov    %esp,%ebp
  8016b4:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016b7:	e8 12 fc ff ff       	call   8012ce <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8016bc:	83 ec 04             	sub    $0x4,%esp
  8016bf:	68 88 3e 80 00       	push   $0x803e88
  8016c4:	68 f1 00 00 00       	push   $0xf1
  8016c9:	68 33 3e 80 00       	push   $0x803e33
  8016ce:	e8 bd eb ff ff       	call   800290 <_panic>

008016d3 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8016d3:	55                   	push   %ebp
  8016d4:	89 e5                	mov    %esp,%ebp
  8016d6:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8016d9:	83 ec 04             	sub    $0x4,%esp
  8016dc:	68 b0 3e 80 00       	push   $0x803eb0
  8016e1:	68 05 01 00 00       	push   $0x105
  8016e6:	68 33 3e 80 00       	push   $0x803e33
  8016eb:	e8 a0 eb ff ff       	call   800290 <_panic>

008016f0 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8016f0:	55                   	push   %ebp
  8016f1:	89 e5                	mov    %esp,%ebp
  8016f3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016f6:	83 ec 04             	sub    $0x4,%esp
  8016f9:	68 d4 3e 80 00       	push   $0x803ed4
  8016fe:	68 10 01 00 00       	push   $0x110
  801703:	68 33 3e 80 00       	push   $0x803e33
  801708:	e8 83 eb ff ff       	call   800290 <_panic>

0080170d <shrink>:

}
void shrink(uint32 newSize)
{
  80170d:	55                   	push   %ebp
  80170e:	89 e5                	mov    %esp,%ebp
  801710:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801713:	83 ec 04             	sub    $0x4,%esp
  801716:	68 d4 3e 80 00       	push   $0x803ed4
  80171b:	68 15 01 00 00       	push   $0x115
  801720:	68 33 3e 80 00       	push   $0x803e33
  801725:	e8 66 eb ff ff       	call   800290 <_panic>

0080172a <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80172a:	55                   	push   %ebp
  80172b:	89 e5                	mov    %esp,%ebp
  80172d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801730:	83 ec 04             	sub    $0x4,%esp
  801733:	68 d4 3e 80 00       	push   $0x803ed4
  801738:	68 1a 01 00 00       	push   $0x11a
  80173d:	68 33 3e 80 00       	push   $0x803e33
  801742:	e8 49 eb ff ff       	call   800290 <_panic>

00801747 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801747:	55                   	push   %ebp
  801748:	89 e5                	mov    %esp,%ebp
  80174a:	57                   	push   %edi
  80174b:	56                   	push   %esi
  80174c:	53                   	push   %ebx
  80174d:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801750:	8b 45 08             	mov    0x8(%ebp),%eax
  801753:	8b 55 0c             	mov    0xc(%ebp),%edx
  801756:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801759:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80175c:	8b 7d 18             	mov    0x18(%ebp),%edi
  80175f:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801762:	cd 30                	int    $0x30
  801764:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801767:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80176a:	83 c4 10             	add    $0x10,%esp
  80176d:	5b                   	pop    %ebx
  80176e:	5e                   	pop    %esi
  80176f:	5f                   	pop    %edi
  801770:	5d                   	pop    %ebp
  801771:	c3                   	ret    

00801772 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801772:	55                   	push   %ebp
  801773:	89 e5                	mov    %esp,%ebp
  801775:	83 ec 04             	sub    $0x4,%esp
  801778:	8b 45 10             	mov    0x10(%ebp),%eax
  80177b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80177e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801782:	8b 45 08             	mov    0x8(%ebp),%eax
  801785:	6a 00                	push   $0x0
  801787:	6a 00                	push   $0x0
  801789:	52                   	push   %edx
  80178a:	ff 75 0c             	pushl  0xc(%ebp)
  80178d:	50                   	push   %eax
  80178e:	6a 00                	push   $0x0
  801790:	e8 b2 ff ff ff       	call   801747 <syscall>
  801795:	83 c4 18             	add    $0x18,%esp
}
  801798:	90                   	nop
  801799:	c9                   	leave  
  80179a:	c3                   	ret    

0080179b <sys_cgetc>:

int
sys_cgetc(void)
{
  80179b:	55                   	push   %ebp
  80179c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80179e:	6a 00                	push   $0x0
  8017a0:	6a 00                	push   $0x0
  8017a2:	6a 00                	push   $0x0
  8017a4:	6a 00                	push   $0x0
  8017a6:	6a 00                	push   $0x0
  8017a8:	6a 01                	push   $0x1
  8017aa:	e8 98 ff ff ff       	call   801747 <syscall>
  8017af:	83 c4 18             	add    $0x18,%esp
}
  8017b2:	c9                   	leave  
  8017b3:	c3                   	ret    

008017b4 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8017b4:	55                   	push   %ebp
  8017b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8017b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bd:	6a 00                	push   $0x0
  8017bf:	6a 00                	push   $0x0
  8017c1:	6a 00                	push   $0x0
  8017c3:	52                   	push   %edx
  8017c4:	50                   	push   %eax
  8017c5:	6a 05                	push   $0x5
  8017c7:	e8 7b ff ff ff       	call   801747 <syscall>
  8017cc:	83 c4 18             	add    $0x18,%esp
}
  8017cf:	c9                   	leave  
  8017d0:	c3                   	ret    

008017d1 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8017d1:	55                   	push   %ebp
  8017d2:	89 e5                	mov    %esp,%ebp
  8017d4:	56                   	push   %esi
  8017d5:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8017d6:	8b 75 18             	mov    0x18(%ebp),%esi
  8017d9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017dc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e5:	56                   	push   %esi
  8017e6:	53                   	push   %ebx
  8017e7:	51                   	push   %ecx
  8017e8:	52                   	push   %edx
  8017e9:	50                   	push   %eax
  8017ea:	6a 06                	push   $0x6
  8017ec:	e8 56 ff ff ff       	call   801747 <syscall>
  8017f1:	83 c4 18             	add    $0x18,%esp
}
  8017f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017f7:	5b                   	pop    %ebx
  8017f8:	5e                   	pop    %esi
  8017f9:	5d                   	pop    %ebp
  8017fa:	c3                   	ret    

008017fb <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8017fb:	55                   	push   %ebp
  8017fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8017fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801801:	8b 45 08             	mov    0x8(%ebp),%eax
  801804:	6a 00                	push   $0x0
  801806:	6a 00                	push   $0x0
  801808:	6a 00                	push   $0x0
  80180a:	52                   	push   %edx
  80180b:	50                   	push   %eax
  80180c:	6a 07                	push   $0x7
  80180e:	e8 34 ff ff ff       	call   801747 <syscall>
  801813:	83 c4 18             	add    $0x18,%esp
}
  801816:	c9                   	leave  
  801817:	c3                   	ret    

00801818 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801818:	55                   	push   %ebp
  801819:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80181b:	6a 00                	push   $0x0
  80181d:	6a 00                	push   $0x0
  80181f:	6a 00                	push   $0x0
  801821:	ff 75 0c             	pushl  0xc(%ebp)
  801824:	ff 75 08             	pushl  0x8(%ebp)
  801827:	6a 08                	push   $0x8
  801829:	e8 19 ff ff ff       	call   801747 <syscall>
  80182e:	83 c4 18             	add    $0x18,%esp
}
  801831:	c9                   	leave  
  801832:	c3                   	ret    

00801833 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801833:	55                   	push   %ebp
  801834:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801836:	6a 00                	push   $0x0
  801838:	6a 00                	push   $0x0
  80183a:	6a 00                	push   $0x0
  80183c:	6a 00                	push   $0x0
  80183e:	6a 00                	push   $0x0
  801840:	6a 09                	push   $0x9
  801842:	e8 00 ff ff ff       	call   801747 <syscall>
  801847:	83 c4 18             	add    $0x18,%esp
}
  80184a:	c9                   	leave  
  80184b:	c3                   	ret    

0080184c <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80184c:	55                   	push   %ebp
  80184d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80184f:	6a 00                	push   $0x0
  801851:	6a 00                	push   $0x0
  801853:	6a 00                	push   $0x0
  801855:	6a 00                	push   $0x0
  801857:	6a 00                	push   $0x0
  801859:	6a 0a                	push   $0xa
  80185b:	e8 e7 fe ff ff       	call   801747 <syscall>
  801860:	83 c4 18             	add    $0x18,%esp
}
  801863:	c9                   	leave  
  801864:	c3                   	ret    

00801865 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801865:	55                   	push   %ebp
  801866:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801868:	6a 00                	push   $0x0
  80186a:	6a 00                	push   $0x0
  80186c:	6a 00                	push   $0x0
  80186e:	6a 00                	push   $0x0
  801870:	6a 00                	push   $0x0
  801872:	6a 0b                	push   $0xb
  801874:	e8 ce fe ff ff       	call   801747 <syscall>
  801879:	83 c4 18             	add    $0x18,%esp
}
  80187c:	c9                   	leave  
  80187d:	c3                   	ret    

0080187e <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80187e:	55                   	push   %ebp
  80187f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801881:	6a 00                	push   $0x0
  801883:	6a 00                	push   $0x0
  801885:	6a 00                	push   $0x0
  801887:	ff 75 0c             	pushl  0xc(%ebp)
  80188a:	ff 75 08             	pushl  0x8(%ebp)
  80188d:	6a 0f                	push   $0xf
  80188f:	e8 b3 fe ff ff       	call   801747 <syscall>
  801894:	83 c4 18             	add    $0x18,%esp
	return;
  801897:	90                   	nop
}
  801898:	c9                   	leave  
  801899:	c3                   	ret    

0080189a <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80189a:	55                   	push   %ebp
  80189b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80189d:	6a 00                	push   $0x0
  80189f:	6a 00                	push   $0x0
  8018a1:	6a 00                	push   $0x0
  8018a3:	ff 75 0c             	pushl  0xc(%ebp)
  8018a6:	ff 75 08             	pushl  0x8(%ebp)
  8018a9:	6a 10                	push   $0x10
  8018ab:	e8 97 fe ff ff       	call   801747 <syscall>
  8018b0:	83 c4 18             	add    $0x18,%esp
	return ;
  8018b3:	90                   	nop
}
  8018b4:	c9                   	leave  
  8018b5:	c3                   	ret    

008018b6 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8018b6:	55                   	push   %ebp
  8018b7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8018b9:	6a 00                	push   $0x0
  8018bb:	6a 00                	push   $0x0
  8018bd:	ff 75 10             	pushl  0x10(%ebp)
  8018c0:	ff 75 0c             	pushl  0xc(%ebp)
  8018c3:	ff 75 08             	pushl  0x8(%ebp)
  8018c6:	6a 11                	push   $0x11
  8018c8:	e8 7a fe ff ff       	call   801747 <syscall>
  8018cd:	83 c4 18             	add    $0x18,%esp
	return ;
  8018d0:	90                   	nop
}
  8018d1:	c9                   	leave  
  8018d2:	c3                   	ret    

008018d3 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8018d3:	55                   	push   %ebp
  8018d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8018d6:	6a 00                	push   $0x0
  8018d8:	6a 00                	push   $0x0
  8018da:	6a 00                	push   $0x0
  8018dc:	6a 00                	push   $0x0
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 0c                	push   $0xc
  8018e2:	e8 60 fe ff ff       	call   801747 <syscall>
  8018e7:	83 c4 18             	add    $0x18,%esp
}
  8018ea:	c9                   	leave  
  8018eb:	c3                   	ret    

008018ec <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8018ec:	55                   	push   %ebp
  8018ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8018ef:	6a 00                	push   $0x0
  8018f1:	6a 00                	push   $0x0
  8018f3:	6a 00                	push   $0x0
  8018f5:	6a 00                	push   $0x0
  8018f7:	ff 75 08             	pushl  0x8(%ebp)
  8018fa:	6a 0d                	push   $0xd
  8018fc:	e8 46 fe ff ff       	call   801747 <syscall>
  801901:	83 c4 18             	add    $0x18,%esp
}
  801904:	c9                   	leave  
  801905:	c3                   	ret    

00801906 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801906:	55                   	push   %ebp
  801907:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801909:	6a 00                	push   $0x0
  80190b:	6a 00                	push   $0x0
  80190d:	6a 00                	push   $0x0
  80190f:	6a 00                	push   $0x0
  801911:	6a 00                	push   $0x0
  801913:	6a 0e                	push   $0xe
  801915:	e8 2d fe ff ff       	call   801747 <syscall>
  80191a:	83 c4 18             	add    $0x18,%esp
}
  80191d:	90                   	nop
  80191e:	c9                   	leave  
  80191f:	c3                   	ret    

00801920 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801920:	55                   	push   %ebp
  801921:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801923:	6a 00                	push   $0x0
  801925:	6a 00                	push   $0x0
  801927:	6a 00                	push   $0x0
  801929:	6a 00                	push   $0x0
  80192b:	6a 00                	push   $0x0
  80192d:	6a 13                	push   $0x13
  80192f:	e8 13 fe ff ff       	call   801747 <syscall>
  801934:	83 c4 18             	add    $0x18,%esp
}
  801937:	90                   	nop
  801938:	c9                   	leave  
  801939:	c3                   	ret    

0080193a <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80193a:	55                   	push   %ebp
  80193b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80193d:	6a 00                	push   $0x0
  80193f:	6a 00                	push   $0x0
  801941:	6a 00                	push   $0x0
  801943:	6a 00                	push   $0x0
  801945:	6a 00                	push   $0x0
  801947:	6a 14                	push   $0x14
  801949:	e8 f9 fd ff ff       	call   801747 <syscall>
  80194e:	83 c4 18             	add    $0x18,%esp
}
  801951:	90                   	nop
  801952:	c9                   	leave  
  801953:	c3                   	ret    

00801954 <sys_cputc>:


void
sys_cputc(const char c)
{
  801954:	55                   	push   %ebp
  801955:	89 e5                	mov    %esp,%ebp
  801957:	83 ec 04             	sub    $0x4,%esp
  80195a:	8b 45 08             	mov    0x8(%ebp),%eax
  80195d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801960:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801964:	6a 00                	push   $0x0
  801966:	6a 00                	push   $0x0
  801968:	6a 00                	push   $0x0
  80196a:	6a 00                	push   $0x0
  80196c:	50                   	push   %eax
  80196d:	6a 15                	push   $0x15
  80196f:	e8 d3 fd ff ff       	call   801747 <syscall>
  801974:	83 c4 18             	add    $0x18,%esp
}
  801977:	90                   	nop
  801978:	c9                   	leave  
  801979:	c3                   	ret    

0080197a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80197a:	55                   	push   %ebp
  80197b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80197d:	6a 00                	push   $0x0
  80197f:	6a 00                	push   $0x0
  801981:	6a 00                	push   $0x0
  801983:	6a 00                	push   $0x0
  801985:	6a 00                	push   $0x0
  801987:	6a 16                	push   $0x16
  801989:	e8 b9 fd ff ff       	call   801747 <syscall>
  80198e:	83 c4 18             	add    $0x18,%esp
}
  801991:	90                   	nop
  801992:	c9                   	leave  
  801993:	c3                   	ret    

00801994 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801994:	55                   	push   %ebp
  801995:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801997:	8b 45 08             	mov    0x8(%ebp),%eax
  80199a:	6a 00                	push   $0x0
  80199c:	6a 00                	push   $0x0
  80199e:	6a 00                	push   $0x0
  8019a0:	ff 75 0c             	pushl  0xc(%ebp)
  8019a3:	50                   	push   %eax
  8019a4:	6a 17                	push   $0x17
  8019a6:	e8 9c fd ff ff       	call   801747 <syscall>
  8019ab:	83 c4 18             	add    $0x18,%esp
}
  8019ae:	c9                   	leave  
  8019af:	c3                   	ret    

008019b0 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8019b0:	55                   	push   %ebp
  8019b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 00                	push   $0x0
  8019bf:	52                   	push   %edx
  8019c0:	50                   	push   %eax
  8019c1:	6a 1a                	push   $0x1a
  8019c3:	e8 7f fd ff ff       	call   801747 <syscall>
  8019c8:	83 c4 18             	add    $0x18,%esp
}
  8019cb:	c9                   	leave  
  8019cc:	c3                   	ret    

008019cd <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8019cd:	55                   	push   %ebp
  8019ce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d6:	6a 00                	push   $0x0
  8019d8:	6a 00                	push   $0x0
  8019da:	6a 00                	push   $0x0
  8019dc:	52                   	push   %edx
  8019dd:	50                   	push   %eax
  8019de:	6a 18                	push   $0x18
  8019e0:	e8 62 fd ff ff       	call   801747 <syscall>
  8019e5:	83 c4 18             	add    $0x18,%esp
}
  8019e8:	90                   	nop
  8019e9:	c9                   	leave  
  8019ea:	c3                   	ret    

008019eb <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8019eb:	55                   	push   %ebp
  8019ec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 00                	push   $0x0
  8019f8:	6a 00                	push   $0x0
  8019fa:	52                   	push   %edx
  8019fb:	50                   	push   %eax
  8019fc:	6a 19                	push   $0x19
  8019fe:	e8 44 fd ff ff       	call   801747 <syscall>
  801a03:	83 c4 18             	add    $0x18,%esp
}
  801a06:	90                   	nop
  801a07:	c9                   	leave  
  801a08:	c3                   	ret    

00801a09 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a09:	55                   	push   %ebp
  801a0a:	89 e5                	mov    %esp,%ebp
  801a0c:	83 ec 04             	sub    $0x4,%esp
  801a0f:	8b 45 10             	mov    0x10(%ebp),%eax
  801a12:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a15:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a18:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1f:	6a 00                	push   $0x0
  801a21:	51                   	push   %ecx
  801a22:	52                   	push   %edx
  801a23:	ff 75 0c             	pushl  0xc(%ebp)
  801a26:	50                   	push   %eax
  801a27:	6a 1b                	push   $0x1b
  801a29:	e8 19 fd ff ff       	call   801747 <syscall>
  801a2e:	83 c4 18             	add    $0x18,%esp
}
  801a31:	c9                   	leave  
  801a32:	c3                   	ret    

00801a33 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801a33:	55                   	push   %ebp
  801a34:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a36:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a39:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3c:	6a 00                	push   $0x0
  801a3e:	6a 00                	push   $0x0
  801a40:	6a 00                	push   $0x0
  801a42:	52                   	push   %edx
  801a43:	50                   	push   %eax
  801a44:	6a 1c                	push   $0x1c
  801a46:	e8 fc fc ff ff       	call   801747 <syscall>
  801a4b:	83 c4 18             	add    $0x18,%esp
}
  801a4e:	c9                   	leave  
  801a4f:	c3                   	ret    

00801a50 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801a50:	55                   	push   %ebp
  801a51:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a53:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a56:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a59:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5c:	6a 00                	push   $0x0
  801a5e:	6a 00                	push   $0x0
  801a60:	51                   	push   %ecx
  801a61:	52                   	push   %edx
  801a62:	50                   	push   %eax
  801a63:	6a 1d                	push   $0x1d
  801a65:	e8 dd fc ff ff       	call   801747 <syscall>
  801a6a:	83 c4 18             	add    $0x18,%esp
}
  801a6d:	c9                   	leave  
  801a6e:	c3                   	ret    

00801a6f <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801a6f:	55                   	push   %ebp
  801a70:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a72:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a75:	8b 45 08             	mov    0x8(%ebp),%eax
  801a78:	6a 00                	push   $0x0
  801a7a:	6a 00                	push   $0x0
  801a7c:	6a 00                	push   $0x0
  801a7e:	52                   	push   %edx
  801a7f:	50                   	push   %eax
  801a80:	6a 1e                	push   $0x1e
  801a82:	e8 c0 fc ff ff       	call   801747 <syscall>
  801a87:	83 c4 18             	add    $0x18,%esp
}
  801a8a:	c9                   	leave  
  801a8b:	c3                   	ret    

00801a8c <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801a8c:	55                   	push   %ebp
  801a8d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 00                	push   $0x0
  801a93:	6a 00                	push   $0x0
  801a95:	6a 00                	push   $0x0
  801a97:	6a 00                	push   $0x0
  801a99:	6a 1f                	push   $0x1f
  801a9b:	e8 a7 fc ff ff       	call   801747 <syscall>
  801aa0:	83 c4 18             	add    $0x18,%esp
}
  801aa3:	c9                   	leave  
  801aa4:	c3                   	ret    

00801aa5 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801aa5:	55                   	push   %ebp
  801aa6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  801aab:	6a 00                	push   $0x0
  801aad:	ff 75 14             	pushl  0x14(%ebp)
  801ab0:	ff 75 10             	pushl  0x10(%ebp)
  801ab3:	ff 75 0c             	pushl  0xc(%ebp)
  801ab6:	50                   	push   %eax
  801ab7:	6a 20                	push   $0x20
  801ab9:	e8 89 fc ff ff       	call   801747 <syscall>
  801abe:	83 c4 18             	add    $0x18,%esp
}
  801ac1:	c9                   	leave  
  801ac2:	c3                   	ret    

00801ac3 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801ac3:	55                   	push   %ebp
  801ac4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 00                	push   $0x0
  801acd:	6a 00                	push   $0x0
  801acf:	6a 00                	push   $0x0
  801ad1:	50                   	push   %eax
  801ad2:	6a 21                	push   $0x21
  801ad4:	e8 6e fc ff ff       	call   801747 <syscall>
  801ad9:	83 c4 18             	add    $0x18,%esp
}
  801adc:	90                   	nop
  801add:	c9                   	leave  
  801ade:	c3                   	ret    

00801adf <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801adf:	55                   	push   %ebp
  801ae0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 00                	push   $0x0
  801ae9:	6a 00                	push   $0x0
  801aeb:	6a 00                	push   $0x0
  801aed:	50                   	push   %eax
  801aee:	6a 22                	push   $0x22
  801af0:	e8 52 fc ff ff       	call   801747 <syscall>
  801af5:	83 c4 18             	add    $0x18,%esp
}
  801af8:	c9                   	leave  
  801af9:	c3                   	ret    

00801afa <sys_getenvid>:

int32 sys_getenvid(void)
{
  801afa:	55                   	push   %ebp
  801afb:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801afd:	6a 00                	push   $0x0
  801aff:	6a 00                	push   $0x0
  801b01:	6a 00                	push   $0x0
  801b03:	6a 00                	push   $0x0
  801b05:	6a 00                	push   $0x0
  801b07:	6a 02                	push   $0x2
  801b09:	e8 39 fc ff ff       	call   801747 <syscall>
  801b0e:	83 c4 18             	add    $0x18,%esp
}
  801b11:	c9                   	leave  
  801b12:	c3                   	ret    

00801b13 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b13:	55                   	push   %ebp
  801b14:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b16:	6a 00                	push   $0x0
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 00                	push   $0x0
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 03                	push   $0x3
  801b22:	e8 20 fc ff ff       	call   801747 <syscall>
  801b27:	83 c4 18             	add    $0x18,%esp
}
  801b2a:	c9                   	leave  
  801b2b:	c3                   	ret    

00801b2c <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b2c:	55                   	push   %ebp
  801b2d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 00                	push   $0x0
  801b33:	6a 00                	push   $0x0
  801b35:	6a 00                	push   $0x0
  801b37:	6a 00                	push   $0x0
  801b39:	6a 04                	push   $0x4
  801b3b:	e8 07 fc ff ff       	call   801747 <syscall>
  801b40:	83 c4 18             	add    $0x18,%esp
}
  801b43:	c9                   	leave  
  801b44:	c3                   	ret    

00801b45 <sys_exit_env>:


void sys_exit_env(void)
{
  801b45:	55                   	push   %ebp
  801b46:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b48:	6a 00                	push   $0x0
  801b4a:	6a 00                	push   $0x0
  801b4c:	6a 00                	push   $0x0
  801b4e:	6a 00                	push   $0x0
  801b50:	6a 00                	push   $0x0
  801b52:	6a 23                	push   $0x23
  801b54:	e8 ee fb ff ff       	call   801747 <syscall>
  801b59:	83 c4 18             	add    $0x18,%esp
}
  801b5c:	90                   	nop
  801b5d:	c9                   	leave  
  801b5e:	c3                   	ret    

00801b5f <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801b5f:	55                   	push   %ebp
  801b60:	89 e5                	mov    %esp,%ebp
  801b62:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b65:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b68:	8d 50 04             	lea    0x4(%eax),%edx
  801b6b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b6e:	6a 00                	push   $0x0
  801b70:	6a 00                	push   $0x0
  801b72:	6a 00                	push   $0x0
  801b74:	52                   	push   %edx
  801b75:	50                   	push   %eax
  801b76:	6a 24                	push   $0x24
  801b78:	e8 ca fb ff ff       	call   801747 <syscall>
  801b7d:	83 c4 18             	add    $0x18,%esp
	return result;
  801b80:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b83:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b86:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b89:	89 01                	mov    %eax,(%ecx)
  801b8b:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b91:	c9                   	leave  
  801b92:	c2 04 00             	ret    $0x4

00801b95 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b95:	55                   	push   %ebp
  801b96:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b98:	6a 00                	push   $0x0
  801b9a:	6a 00                	push   $0x0
  801b9c:	ff 75 10             	pushl  0x10(%ebp)
  801b9f:	ff 75 0c             	pushl  0xc(%ebp)
  801ba2:	ff 75 08             	pushl  0x8(%ebp)
  801ba5:	6a 12                	push   $0x12
  801ba7:	e8 9b fb ff ff       	call   801747 <syscall>
  801bac:	83 c4 18             	add    $0x18,%esp
	return ;
  801baf:	90                   	nop
}
  801bb0:	c9                   	leave  
  801bb1:	c3                   	ret    

00801bb2 <sys_rcr2>:
uint32 sys_rcr2()
{
  801bb2:	55                   	push   %ebp
  801bb3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801bb5:	6a 00                	push   $0x0
  801bb7:	6a 00                	push   $0x0
  801bb9:	6a 00                	push   $0x0
  801bbb:	6a 00                	push   $0x0
  801bbd:	6a 00                	push   $0x0
  801bbf:	6a 25                	push   $0x25
  801bc1:	e8 81 fb ff ff       	call   801747 <syscall>
  801bc6:	83 c4 18             	add    $0x18,%esp
}
  801bc9:	c9                   	leave  
  801bca:	c3                   	ret    

00801bcb <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801bcb:	55                   	push   %ebp
  801bcc:	89 e5                	mov    %esp,%ebp
  801bce:	83 ec 04             	sub    $0x4,%esp
  801bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801bd7:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 00                	push   $0x0
  801be3:	50                   	push   %eax
  801be4:	6a 26                	push   $0x26
  801be6:	e8 5c fb ff ff       	call   801747 <syscall>
  801beb:	83 c4 18             	add    $0x18,%esp
	return ;
  801bee:	90                   	nop
}
  801bef:	c9                   	leave  
  801bf0:	c3                   	ret    

00801bf1 <rsttst>:
void rsttst()
{
  801bf1:	55                   	push   %ebp
  801bf2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801bf4:	6a 00                	push   $0x0
  801bf6:	6a 00                	push   $0x0
  801bf8:	6a 00                	push   $0x0
  801bfa:	6a 00                	push   $0x0
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 28                	push   $0x28
  801c00:	e8 42 fb ff ff       	call   801747 <syscall>
  801c05:	83 c4 18             	add    $0x18,%esp
	return ;
  801c08:	90                   	nop
}
  801c09:	c9                   	leave  
  801c0a:	c3                   	ret    

00801c0b <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c0b:	55                   	push   %ebp
  801c0c:	89 e5                	mov    %esp,%ebp
  801c0e:	83 ec 04             	sub    $0x4,%esp
  801c11:	8b 45 14             	mov    0x14(%ebp),%eax
  801c14:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c17:	8b 55 18             	mov    0x18(%ebp),%edx
  801c1a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c1e:	52                   	push   %edx
  801c1f:	50                   	push   %eax
  801c20:	ff 75 10             	pushl  0x10(%ebp)
  801c23:	ff 75 0c             	pushl  0xc(%ebp)
  801c26:	ff 75 08             	pushl  0x8(%ebp)
  801c29:	6a 27                	push   $0x27
  801c2b:	e8 17 fb ff ff       	call   801747 <syscall>
  801c30:	83 c4 18             	add    $0x18,%esp
	return ;
  801c33:	90                   	nop
}
  801c34:	c9                   	leave  
  801c35:	c3                   	ret    

00801c36 <chktst>:
void chktst(uint32 n)
{
  801c36:	55                   	push   %ebp
  801c37:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 00                	push   $0x0
  801c3f:	6a 00                	push   $0x0
  801c41:	ff 75 08             	pushl  0x8(%ebp)
  801c44:	6a 29                	push   $0x29
  801c46:	e8 fc fa ff ff       	call   801747 <syscall>
  801c4b:	83 c4 18             	add    $0x18,%esp
	return ;
  801c4e:	90                   	nop
}
  801c4f:	c9                   	leave  
  801c50:	c3                   	ret    

00801c51 <inctst>:

void inctst()
{
  801c51:	55                   	push   %ebp
  801c52:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c54:	6a 00                	push   $0x0
  801c56:	6a 00                	push   $0x0
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 2a                	push   $0x2a
  801c60:	e8 e2 fa ff ff       	call   801747 <syscall>
  801c65:	83 c4 18             	add    $0x18,%esp
	return ;
  801c68:	90                   	nop
}
  801c69:	c9                   	leave  
  801c6a:	c3                   	ret    

00801c6b <gettst>:
uint32 gettst()
{
  801c6b:	55                   	push   %ebp
  801c6c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c6e:	6a 00                	push   $0x0
  801c70:	6a 00                	push   $0x0
  801c72:	6a 00                	push   $0x0
  801c74:	6a 00                	push   $0x0
  801c76:	6a 00                	push   $0x0
  801c78:	6a 2b                	push   $0x2b
  801c7a:	e8 c8 fa ff ff       	call   801747 <syscall>
  801c7f:	83 c4 18             	add    $0x18,%esp
}
  801c82:	c9                   	leave  
  801c83:	c3                   	ret    

00801c84 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801c84:	55                   	push   %ebp
  801c85:	89 e5                	mov    %esp,%ebp
  801c87:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 00                	push   $0x0
  801c92:	6a 00                	push   $0x0
  801c94:	6a 2c                	push   $0x2c
  801c96:	e8 ac fa ff ff       	call   801747 <syscall>
  801c9b:	83 c4 18             	add    $0x18,%esp
  801c9e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801ca1:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801ca5:	75 07                	jne    801cae <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801ca7:	b8 01 00 00 00       	mov    $0x1,%eax
  801cac:	eb 05                	jmp    801cb3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801cae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cb3:	c9                   	leave  
  801cb4:	c3                   	ret    

00801cb5 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801cb5:	55                   	push   %ebp
  801cb6:	89 e5                	mov    %esp,%ebp
  801cb8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cbb:	6a 00                	push   $0x0
  801cbd:	6a 00                	push   $0x0
  801cbf:	6a 00                	push   $0x0
  801cc1:	6a 00                	push   $0x0
  801cc3:	6a 00                	push   $0x0
  801cc5:	6a 2c                	push   $0x2c
  801cc7:	e8 7b fa ff ff       	call   801747 <syscall>
  801ccc:	83 c4 18             	add    $0x18,%esp
  801ccf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801cd2:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801cd6:	75 07                	jne    801cdf <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801cd8:	b8 01 00 00 00       	mov    $0x1,%eax
  801cdd:	eb 05                	jmp    801ce4 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801cdf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ce4:	c9                   	leave  
  801ce5:	c3                   	ret    

00801ce6 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801ce6:	55                   	push   %ebp
  801ce7:	89 e5                	mov    %esp,%ebp
  801ce9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cec:	6a 00                	push   $0x0
  801cee:	6a 00                	push   $0x0
  801cf0:	6a 00                	push   $0x0
  801cf2:	6a 00                	push   $0x0
  801cf4:	6a 00                	push   $0x0
  801cf6:	6a 2c                	push   $0x2c
  801cf8:	e8 4a fa ff ff       	call   801747 <syscall>
  801cfd:	83 c4 18             	add    $0x18,%esp
  801d00:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801d03:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d07:	75 07                	jne    801d10 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801d09:	b8 01 00 00 00       	mov    $0x1,%eax
  801d0e:	eb 05                	jmp    801d15 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801d10:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d15:	c9                   	leave  
  801d16:	c3                   	ret    

00801d17 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801d17:	55                   	push   %ebp
  801d18:	89 e5                	mov    %esp,%ebp
  801d1a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d1d:	6a 00                	push   $0x0
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 00                	push   $0x0
  801d23:	6a 00                	push   $0x0
  801d25:	6a 00                	push   $0x0
  801d27:	6a 2c                	push   $0x2c
  801d29:	e8 19 fa ff ff       	call   801747 <syscall>
  801d2e:	83 c4 18             	add    $0x18,%esp
  801d31:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801d34:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801d38:	75 07                	jne    801d41 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801d3a:	b8 01 00 00 00       	mov    $0x1,%eax
  801d3f:	eb 05                	jmp    801d46 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801d41:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d46:	c9                   	leave  
  801d47:	c3                   	ret    

00801d48 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801d48:	55                   	push   %ebp
  801d49:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801d4b:	6a 00                	push   $0x0
  801d4d:	6a 00                	push   $0x0
  801d4f:	6a 00                	push   $0x0
  801d51:	6a 00                	push   $0x0
  801d53:	ff 75 08             	pushl  0x8(%ebp)
  801d56:	6a 2d                	push   $0x2d
  801d58:	e8 ea f9 ff ff       	call   801747 <syscall>
  801d5d:	83 c4 18             	add    $0x18,%esp
	return ;
  801d60:	90                   	nop
}
  801d61:	c9                   	leave  
  801d62:	c3                   	ret    

00801d63 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801d63:	55                   	push   %ebp
  801d64:	89 e5                	mov    %esp,%ebp
  801d66:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801d67:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d6a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d6d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d70:	8b 45 08             	mov    0x8(%ebp),%eax
  801d73:	6a 00                	push   $0x0
  801d75:	53                   	push   %ebx
  801d76:	51                   	push   %ecx
  801d77:	52                   	push   %edx
  801d78:	50                   	push   %eax
  801d79:	6a 2e                	push   $0x2e
  801d7b:	e8 c7 f9 ff ff       	call   801747 <syscall>
  801d80:	83 c4 18             	add    $0x18,%esp
}
  801d83:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d86:	c9                   	leave  
  801d87:	c3                   	ret    

00801d88 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801d88:	55                   	push   %ebp
  801d89:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801d8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d91:	6a 00                	push   $0x0
  801d93:	6a 00                	push   $0x0
  801d95:	6a 00                	push   $0x0
  801d97:	52                   	push   %edx
  801d98:	50                   	push   %eax
  801d99:	6a 2f                	push   $0x2f
  801d9b:	e8 a7 f9 ff ff       	call   801747 <syscall>
  801da0:	83 c4 18             	add    $0x18,%esp
}
  801da3:	c9                   	leave  
  801da4:	c3                   	ret    

00801da5 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801da5:	55                   	push   %ebp
  801da6:	89 e5                	mov    %esp,%ebp
  801da8:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801dab:	83 ec 0c             	sub    $0xc,%esp
  801dae:	68 e4 3e 80 00       	push   $0x803ee4
  801db3:	e8 8c e7 ff ff       	call   800544 <cprintf>
  801db8:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801dbb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801dc2:	83 ec 0c             	sub    $0xc,%esp
  801dc5:	68 10 3f 80 00       	push   $0x803f10
  801dca:	e8 75 e7 ff ff       	call   800544 <cprintf>
  801dcf:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801dd2:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801dd6:	a1 38 51 80 00       	mov    0x805138,%eax
  801ddb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dde:	eb 56                	jmp    801e36 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801de0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801de4:	74 1c                	je     801e02 <print_mem_block_lists+0x5d>
  801de6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801de9:	8b 50 08             	mov    0x8(%eax),%edx
  801dec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801def:	8b 48 08             	mov    0x8(%eax),%ecx
  801df2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801df5:	8b 40 0c             	mov    0xc(%eax),%eax
  801df8:	01 c8                	add    %ecx,%eax
  801dfa:	39 c2                	cmp    %eax,%edx
  801dfc:	73 04                	jae    801e02 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801dfe:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e05:	8b 50 08             	mov    0x8(%eax),%edx
  801e08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e0b:	8b 40 0c             	mov    0xc(%eax),%eax
  801e0e:	01 c2                	add    %eax,%edx
  801e10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e13:	8b 40 08             	mov    0x8(%eax),%eax
  801e16:	83 ec 04             	sub    $0x4,%esp
  801e19:	52                   	push   %edx
  801e1a:	50                   	push   %eax
  801e1b:	68 25 3f 80 00       	push   $0x803f25
  801e20:	e8 1f e7 ff ff       	call   800544 <cprintf>
  801e25:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e2e:	a1 40 51 80 00       	mov    0x805140,%eax
  801e33:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e36:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e3a:	74 07                	je     801e43 <print_mem_block_lists+0x9e>
  801e3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e3f:	8b 00                	mov    (%eax),%eax
  801e41:	eb 05                	jmp    801e48 <print_mem_block_lists+0xa3>
  801e43:	b8 00 00 00 00       	mov    $0x0,%eax
  801e48:	a3 40 51 80 00       	mov    %eax,0x805140
  801e4d:	a1 40 51 80 00       	mov    0x805140,%eax
  801e52:	85 c0                	test   %eax,%eax
  801e54:	75 8a                	jne    801de0 <print_mem_block_lists+0x3b>
  801e56:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e5a:	75 84                	jne    801de0 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801e5c:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e60:	75 10                	jne    801e72 <print_mem_block_lists+0xcd>
  801e62:	83 ec 0c             	sub    $0xc,%esp
  801e65:	68 34 3f 80 00       	push   $0x803f34
  801e6a:	e8 d5 e6 ff ff       	call   800544 <cprintf>
  801e6f:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801e72:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801e79:	83 ec 0c             	sub    $0xc,%esp
  801e7c:	68 58 3f 80 00       	push   $0x803f58
  801e81:	e8 be e6 ff ff       	call   800544 <cprintf>
  801e86:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801e89:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801e8d:	a1 40 50 80 00       	mov    0x805040,%eax
  801e92:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e95:	eb 56                	jmp    801eed <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e97:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e9b:	74 1c                	je     801eb9 <print_mem_block_lists+0x114>
  801e9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ea0:	8b 50 08             	mov    0x8(%eax),%edx
  801ea3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ea6:	8b 48 08             	mov    0x8(%eax),%ecx
  801ea9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eac:	8b 40 0c             	mov    0xc(%eax),%eax
  801eaf:	01 c8                	add    %ecx,%eax
  801eb1:	39 c2                	cmp    %eax,%edx
  801eb3:	73 04                	jae    801eb9 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801eb5:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801eb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ebc:	8b 50 08             	mov    0x8(%eax),%edx
  801ebf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec2:	8b 40 0c             	mov    0xc(%eax),%eax
  801ec5:	01 c2                	add    %eax,%edx
  801ec7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eca:	8b 40 08             	mov    0x8(%eax),%eax
  801ecd:	83 ec 04             	sub    $0x4,%esp
  801ed0:	52                   	push   %edx
  801ed1:	50                   	push   %eax
  801ed2:	68 25 3f 80 00       	push   $0x803f25
  801ed7:	e8 68 e6 ff ff       	call   800544 <cprintf>
  801edc:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801edf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801ee5:	a1 48 50 80 00       	mov    0x805048,%eax
  801eea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801eed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ef1:	74 07                	je     801efa <print_mem_block_lists+0x155>
  801ef3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef6:	8b 00                	mov    (%eax),%eax
  801ef8:	eb 05                	jmp    801eff <print_mem_block_lists+0x15a>
  801efa:	b8 00 00 00 00       	mov    $0x0,%eax
  801eff:	a3 48 50 80 00       	mov    %eax,0x805048
  801f04:	a1 48 50 80 00       	mov    0x805048,%eax
  801f09:	85 c0                	test   %eax,%eax
  801f0b:	75 8a                	jne    801e97 <print_mem_block_lists+0xf2>
  801f0d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f11:	75 84                	jne    801e97 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801f13:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f17:	75 10                	jne    801f29 <print_mem_block_lists+0x184>
  801f19:	83 ec 0c             	sub    $0xc,%esp
  801f1c:	68 70 3f 80 00       	push   $0x803f70
  801f21:	e8 1e e6 ff ff       	call   800544 <cprintf>
  801f26:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801f29:	83 ec 0c             	sub    $0xc,%esp
  801f2c:	68 e4 3e 80 00       	push   $0x803ee4
  801f31:	e8 0e e6 ff ff       	call   800544 <cprintf>
  801f36:	83 c4 10             	add    $0x10,%esp

}
  801f39:	90                   	nop
  801f3a:	c9                   	leave  
  801f3b:	c3                   	ret    

00801f3c <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801f3c:	55                   	push   %ebp
  801f3d:	89 e5                	mov    %esp,%ebp
  801f3f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801f42:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  801f49:	00 00 00 
  801f4c:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  801f53:	00 00 00 
  801f56:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  801f5d:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801f60:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801f67:	e9 9e 00 00 00       	jmp    80200a <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801f6c:	a1 50 50 80 00       	mov    0x805050,%eax
  801f71:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f74:	c1 e2 04             	shl    $0x4,%edx
  801f77:	01 d0                	add    %edx,%eax
  801f79:	85 c0                	test   %eax,%eax
  801f7b:	75 14                	jne    801f91 <initialize_MemBlocksList+0x55>
  801f7d:	83 ec 04             	sub    $0x4,%esp
  801f80:	68 98 3f 80 00       	push   $0x803f98
  801f85:	6a 46                	push   $0x46
  801f87:	68 bb 3f 80 00       	push   $0x803fbb
  801f8c:	e8 ff e2 ff ff       	call   800290 <_panic>
  801f91:	a1 50 50 80 00       	mov    0x805050,%eax
  801f96:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f99:	c1 e2 04             	shl    $0x4,%edx
  801f9c:	01 d0                	add    %edx,%eax
  801f9e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  801fa4:	89 10                	mov    %edx,(%eax)
  801fa6:	8b 00                	mov    (%eax),%eax
  801fa8:	85 c0                	test   %eax,%eax
  801faa:	74 18                	je     801fc4 <initialize_MemBlocksList+0x88>
  801fac:	a1 48 51 80 00       	mov    0x805148,%eax
  801fb1:	8b 15 50 50 80 00    	mov    0x805050,%edx
  801fb7:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801fba:	c1 e1 04             	shl    $0x4,%ecx
  801fbd:	01 ca                	add    %ecx,%edx
  801fbf:	89 50 04             	mov    %edx,0x4(%eax)
  801fc2:	eb 12                	jmp    801fd6 <initialize_MemBlocksList+0x9a>
  801fc4:	a1 50 50 80 00       	mov    0x805050,%eax
  801fc9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fcc:	c1 e2 04             	shl    $0x4,%edx
  801fcf:	01 d0                	add    %edx,%eax
  801fd1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801fd6:	a1 50 50 80 00       	mov    0x805050,%eax
  801fdb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fde:	c1 e2 04             	shl    $0x4,%edx
  801fe1:	01 d0                	add    %edx,%eax
  801fe3:	a3 48 51 80 00       	mov    %eax,0x805148
  801fe8:	a1 50 50 80 00       	mov    0x805050,%eax
  801fed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ff0:	c1 e2 04             	shl    $0x4,%edx
  801ff3:	01 d0                	add    %edx,%eax
  801ff5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801ffc:	a1 54 51 80 00       	mov    0x805154,%eax
  802001:	40                   	inc    %eax
  802002:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802007:	ff 45 f4             	incl   -0xc(%ebp)
  80200a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80200d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802010:	0f 82 56 ff ff ff    	jb     801f6c <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802016:	90                   	nop
  802017:	c9                   	leave  
  802018:	c3                   	ret    

00802019 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802019:	55                   	push   %ebp
  80201a:	89 e5                	mov    %esp,%ebp
  80201c:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80201f:	8b 45 08             	mov    0x8(%ebp),%eax
  802022:	8b 00                	mov    (%eax),%eax
  802024:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802027:	eb 19                	jmp    802042 <find_block+0x29>
	{
		if(va==point->sva)
  802029:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80202c:	8b 40 08             	mov    0x8(%eax),%eax
  80202f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802032:	75 05                	jne    802039 <find_block+0x20>
		   return point;
  802034:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802037:	eb 36                	jmp    80206f <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802039:	8b 45 08             	mov    0x8(%ebp),%eax
  80203c:	8b 40 08             	mov    0x8(%eax),%eax
  80203f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802042:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802046:	74 07                	je     80204f <find_block+0x36>
  802048:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80204b:	8b 00                	mov    (%eax),%eax
  80204d:	eb 05                	jmp    802054 <find_block+0x3b>
  80204f:	b8 00 00 00 00       	mov    $0x0,%eax
  802054:	8b 55 08             	mov    0x8(%ebp),%edx
  802057:	89 42 08             	mov    %eax,0x8(%edx)
  80205a:	8b 45 08             	mov    0x8(%ebp),%eax
  80205d:	8b 40 08             	mov    0x8(%eax),%eax
  802060:	85 c0                	test   %eax,%eax
  802062:	75 c5                	jne    802029 <find_block+0x10>
  802064:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802068:	75 bf                	jne    802029 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  80206a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80206f:	c9                   	leave  
  802070:	c3                   	ret    

00802071 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802071:	55                   	push   %ebp
  802072:	89 e5                	mov    %esp,%ebp
  802074:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802077:	a1 40 50 80 00       	mov    0x805040,%eax
  80207c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  80207f:	a1 44 50 80 00       	mov    0x805044,%eax
  802084:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802087:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80208a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80208d:	74 24                	je     8020b3 <insert_sorted_allocList+0x42>
  80208f:	8b 45 08             	mov    0x8(%ebp),%eax
  802092:	8b 50 08             	mov    0x8(%eax),%edx
  802095:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802098:	8b 40 08             	mov    0x8(%eax),%eax
  80209b:	39 c2                	cmp    %eax,%edx
  80209d:	76 14                	jbe    8020b3 <insert_sorted_allocList+0x42>
  80209f:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a2:	8b 50 08             	mov    0x8(%eax),%edx
  8020a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020a8:	8b 40 08             	mov    0x8(%eax),%eax
  8020ab:	39 c2                	cmp    %eax,%edx
  8020ad:	0f 82 60 01 00 00    	jb     802213 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8020b3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020b7:	75 65                	jne    80211e <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8020b9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020bd:	75 14                	jne    8020d3 <insert_sorted_allocList+0x62>
  8020bf:	83 ec 04             	sub    $0x4,%esp
  8020c2:	68 98 3f 80 00       	push   $0x803f98
  8020c7:	6a 6b                	push   $0x6b
  8020c9:	68 bb 3f 80 00       	push   $0x803fbb
  8020ce:	e8 bd e1 ff ff       	call   800290 <_panic>
  8020d3:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8020d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020dc:	89 10                	mov    %edx,(%eax)
  8020de:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e1:	8b 00                	mov    (%eax),%eax
  8020e3:	85 c0                	test   %eax,%eax
  8020e5:	74 0d                	je     8020f4 <insert_sorted_allocList+0x83>
  8020e7:	a1 40 50 80 00       	mov    0x805040,%eax
  8020ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8020ef:	89 50 04             	mov    %edx,0x4(%eax)
  8020f2:	eb 08                	jmp    8020fc <insert_sorted_allocList+0x8b>
  8020f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f7:	a3 44 50 80 00       	mov    %eax,0x805044
  8020fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ff:	a3 40 50 80 00       	mov    %eax,0x805040
  802104:	8b 45 08             	mov    0x8(%ebp),%eax
  802107:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80210e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802113:	40                   	inc    %eax
  802114:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802119:	e9 dc 01 00 00       	jmp    8022fa <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  80211e:	8b 45 08             	mov    0x8(%ebp),%eax
  802121:	8b 50 08             	mov    0x8(%eax),%edx
  802124:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802127:	8b 40 08             	mov    0x8(%eax),%eax
  80212a:	39 c2                	cmp    %eax,%edx
  80212c:	77 6c                	ja     80219a <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  80212e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802132:	74 06                	je     80213a <insert_sorted_allocList+0xc9>
  802134:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802138:	75 14                	jne    80214e <insert_sorted_allocList+0xdd>
  80213a:	83 ec 04             	sub    $0x4,%esp
  80213d:	68 d4 3f 80 00       	push   $0x803fd4
  802142:	6a 6f                	push   $0x6f
  802144:	68 bb 3f 80 00       	push   $0x803fbb
  802149:	e8 42 e1 ff ff       	call   800290 <_panic>
  80214e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802151:	8b 50 04             	mov    0x4(%eax),%edx
  802154:	8b 45 08             	mov    0x8(%ebp),%eax
  802157:	89 50 04             	mov    %edx,0x4(%eax)
  80215a:	8b 45 08             	mov    0x8(%ebp),%eax
  80215d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802160:	89 10                	mov    %edx,(%eax)
  802162:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802165:	8b 40 04             	mov    0x4(%eax),%eax
  802168:	85 c0                	test   %eax,%eax
  80216a:	74 0d                	je     802179 <insert_sorted_allocList+0x108>
  80216c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80216f:	8b 40 04             	mov    0x4(%eax),%eax
  802172:	8b 55 08             	mov    0x8(%ebp),%edx
  802175:	89 10                	mov    %edx,(%eax)
  802177:	eb 08                	jmp    802181 <insert_sorted_allocList+0x110>
  802179:	8b 45 08             	mov    0x8(%ebp),%eax
  80217c:	a3 40 50 80 00       	mov    %eax,0x805040
  802181:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802184:	8b 55 08             	mov    0x8(%ebp),%edx
  802187:	89 50 04             	mov    %edx,0x4(%eax)
  80218a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80218f:	40                   	inc    %eax
  802190:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802195:	e9 60 01 00 00       	jmp    8022fa <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  80219a:	8b 45 08             	mov    0x8(%ebp),%eax
  80219d:	8b 50 08             	mov    0x8(%eax),%edx
  8021a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021a3:	8b 40 08             	mov    0x8(%eax),%eax
  8021a6:	39 c2                	cmp    %eax,%edx
  8021a8:	0f 82 4c 01 00 00    	jb     8022fa <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8021ae:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021b2:	75 14                	jne    8021c8 <insert_sorted_allocList+0x157>
  8021b4:	83 ec 04             	sub    $0x4,%esp
  8021b7:	68 0c 40 80 00       	push   $0x80400c
  8021bc:	6a 73                	push   $0x73
  8021be:	68 bb 3f 80 00       	push   $0x803fbb
  8021c3:	e8 c8 e0 ff ff       	call   800290 <_panic>
  8021c8:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8021ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d1:	89 50 04             	mov    %edx,0x4(%eax)
  8021d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d7:	8b 40 04             	mov    0x4(%eax),%eax
  8021da:	85 c0                	test   %eax,%eax
  8021dc:	74 0c                	je     8021ea <insert_sorted_allocList+0x179>
  8021de:	a1 44 50 80 00       	mov    0x805044,%eax
  8021e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8021e6:	89 10                	mov    %edx,(%eax)
  8021e8:	eb 08                	jmp    8021f2 <insert_sorted_allocList+0x181>
  8021ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ed:	a3 40 50 80 00       	mov    %eax,0x805040
  8021f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f5:	a3 44 50 80 00       	mov    %eax,0x805044
  8021fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802203:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802208:	40                   	inc    %eax
  802209:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80220e:	e9 e7 00 00 00       	jmp    8022fa <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802213:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802216:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802219:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802220:	a1 40 50 80 00       	mov    0x805040,%eax
  802225:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802228:	e9 9d 00 00 00       	jmp    8022ca <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  80222d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802230:	8b 00                	mov    (%eax),%eax
  802232:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802235:	8b 45 08             	mov    0x8(%ebp),%eax
  802238:	8b 50 08             	mov    0x8(%eax),%edx
  80223b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223e:	8b 40 08             	mov    0x8(%eax),%eax
  802241:	39 c2                	cmp    %eax,%edx
  802243:	76 7d                	jbe    8022c2 <insert_sorted_allocList+0x251>
  802245:	8b 45 08             	mov    0x8(%ebp),%eax
  802248:	8b 50 08             	mov    0x8(%eax),%edx
  80224b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80224e:	8b 40 08             	mov    0x8(%eax),%eax
  802251:	39 c2                	cmp    %eax,%edx
  802253:	73 6d                	jae    8022c2 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802255:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802259:	74 06                	je     802261 <insert_sorted_allocList+0x1f0>
  80225b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80225f:	75 14                	jne    802275 <insert_sorted_allocList+0x204>
  802261:	83 ec 04             	sub    $0x4,%esp
  802264:	68 30 40 80 00       	push   $0x804030
  802269:	6a 7f                	push   $0x7f
  80226b:	68 bb 3f 80 00       	push   $0x803fbb
  802270:	e8 1b e0 ff ff       	call   800290 <_panic>
  802275:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802278:	8b 10                	mov    (%eax),%edx
  80227a:	8b 45 08             	mov    0x8(%ebp),%eax
  80227d:	89 10                	mov    %edx,(%eax)
  80227f:	8b 45 08             	mov    0x8(%ebp),%eax
  802282:	8b 00                	mov    (%eax),%eax
  802284:	85 c0                	test   %eax,%eax
  802286:	74 0b                	je     802293 <insert_sorted_allocList+0x222>
  802288:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228b:	8b 00                	mov    (%eax),%eax
  80228d:	8b 55 08             	mov    0x8(%ebp),%edx
  802290:	89 50 04             	mov    %edx,0x4(%eax)
  802293:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802296:	8b 55 08             	mov    0x8(%ebp),%edx
  802299:	89 10                	mov    %edx,(%eax)
  80229b:	8b 45 08             	mov    0x8(%ebp),%eax
  80229e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022a1:	89 50 04             	mov    %edx,0x4(%eax)
  8022a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a7:	8b 00                	mov    (%eax),%eax
  8022a9:	85 c0                	test   %eax,%eax
  8022ab:	75 08                	jne    8022b5 <insert_sorted_allocList+0x244>
  8022ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b0:	a3 44 50 80 00       	mov    %eax,0x805044
  8022b5:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8022ba:	40                   	inc    %eax
  8022bb:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8022c0:	eb 39                	jmp    8022fb <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8022c2:	a1 48 50 80 00       	mov    0x805048,%eax
  8022c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022ce:	74 07                	je     8022d7 <insert_sorted_allocList+0x266>
  8022d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d3:	8b 00                	mov    (%eax),%eax
  8022d5:	eb 05                	jmp    8022dc <insert_sorted_allocList+0x26b>
  8022d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8022dc:	a3 48 50 80 00       	mov    %eax,0x805048
  8022e1:	a1 48 50 80 00       	mov    0x805048,%eax
  8022e6:	85 c0                	test   %eax,%eax
  8022e8:	0f 85 3f ff ff ff    	jne    80222d <insert_sorted_allocList+0x1bc>
  8022ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022f2:	0f 85 35 ff ff ff    	jne    80222d <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8022f8:	eb 01                	jmp    8022fb <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8022fa:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8022fb:	90                   	nop
  8022fc:	c9                   	leave  
  8022fd:	c3                   	ret    

008022fe <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8022fe:	55                   	push   %ebp
  8022ff:	89 e5                	mov    %esp,%ebp
  802301:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802304:	a1 38 51 80 00       	mov    0x805138,%eax
  802309:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80230c:	e9 85 01 00 00       	jmp    802496 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802311:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802314:	8b 40 0c             	mov    0xc(%eax),%eax
  802317:	3b 45 08             	cmp    0x8(%ebp),%eax
  80231a:	0f 82 6e 01 00 00    	jb     80248e <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802320:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802323:	8b 40 0c             	mov    0xc(%eax),%eax
  802326:	3b 45 08             	cmp    0x8(%ebp),%eax
  802329:	0f 85 8a 00 00 00    	jne    8023b9 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  80232f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802333:	75 17                	jne    80234c <alloc_block_FF+0x4e>
  802335:	83 ec 04             	sub    $0x4,%esp
  802338:	68 64 40 80 00       	push   $0x804064
  80233d:	68 93 00 00 00       	push   $0x93
  802342:	68 bb 3f 80 00       	push   $0x803fbb
  802347:	e8 44 df ff ff       	call   800290 <_panic>
  80234c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234f:	8b 00                	mov    (%eax),%eax
  802351:	85 c0                	test   %eax,%eax
  802353:	74 10                	je     802365 <alloc_block_FF+0x67>
  802355:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802358:	8b 00                	mov    (%eax),%eax
  80235a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80235d:	8b 52 04             	mov    0x4(%edx),%edx
  802360:	89 50 04             	mov    %edx,0x4(%eax)
  802363:	eb 0b                	jmp    802370 <alloc_block_FF+0x72>
  802365:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802368:	8b 40 04             	mov    0x4(%eax),%eax
  80236b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802370:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802373:	8b 40 04             	mov    0x4(%eax),%eax
  802376:	85 c0                	test   %eax,%eax
  802378:	74 0f                	je     802389 <alloc_block_FF+0x8b>
  80237a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237d:	8b 40 04             	mov    0x4(%eax),%eax
  802380:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802383:	8b 12                	mov    (%edx),%edx
  802385:	89 10                	mov    %edx,(%eax)
  802387:	eb 0a                	jmp    802393 <alloc_block_FF+0x95>
  802389:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238c:	8b 00                	mov    (%eax),%eax
  80238e:	a3 38 51 80 00       	mov    %eax,0x805138
  802393:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802396:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80239c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023a6:	a1 44 51 80 00       	mov    0x805144,%eax
  8023ab:	48                   	dec    %eax
  8023ac:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  8023b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b4:	e9 10 01 00 00       	jmp    8024c9 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8023b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8023bf:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023c2:	0f 86 c6 00 00 00    	jbe    80248e <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8023c8:	a1 48 51 80 00       	mov    0x805148,%eax
  8023cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8023d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d3:	8b 50 08             	mov    0x8(%eax),%edx
  8023d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023d9:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8023dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023df:	8b 55 08             	mov    0x8(%ebp),%edx
  8023e2:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8023e5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023e9:	75 17                	jne    802402 <alloc_block_FF+0x104>
  8023eb:	83 ec 04             	sub    $0x4,%esp
  8023ee:	68 64 40 80 00       	push   $0x804064
  8023f3:	68 9b 00 00 00       	push   $0x9b
  8023f8:	68 bb 3f 80 00       	push   $0x803fbb
  8023fd:	e8 8e de ff ff       	call   800290 <_panic>
  802402:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802405:	8b 00                	mov    (%eax),%eax
  802407:	85 c0                	test   %eax,%eax
  802409:	74 10                	je     80241b <alloc_block_FF+0x11d>
  80240b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80240e:	8b 00                	mov    (%eax),%eax
  802410:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802413:	8b 52 04             	mov    0x4(%edx),%edx
  802416:	89 50 04             	mov    %edx,0x4(%eax)
  802419:	eb 0b                	jmp    802426 <alloc_block_FF+0x128>
  80241b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80241e:	8b 40 04             	mov    0x4(%eax),%eax
  802421:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802426:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802429:	8b 40 04             	mov    0x4(%eax),%eax
  80242c:	85 c0                	test   %eax,%eax
  80242e:	74 0f                	je     80243f <alloc_block_FF+0x141>
  802430:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802433:	8b 40 04             	mov    0x4(%eax),%eax
  802436:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802439:	8b 12                	mov    (%edx),%edx
  80243b:	89 10                	mov    %edx,(%eax)
  80243d:	eb 0a                	jmp    802449 <alloc_block_FF+0x14b>
  80243f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802442:	8b 00                	mov    (%eax),%eax
  802444:	a3 48 51 80 00       	mov    %eax,0x805148
  802449:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80244c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802452:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802455:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80245c:	a1 54 51 80 00       	mov    0x805154,%eax
  802461:	48                   	dec    %eax
  802462:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802467:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246a:	8b 50 08             	mov    0x8(%eax),%edx
  80246d:	8b 45 08             	mov    0x8(%ebp),%eax
  802470:	01 c2                	add    %eax,%edx
  802472:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802475:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802478:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247b:	8b 40 0c             	mov    0xc(%eax),%eax
  80247e:	2b 45 08             	sub    0x8(%ebp),%eax
  802481:	89 c2                	mov    %eax,%edx
  802483:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802486:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802489:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80248c:	eb 3b                	jmp    8024c9 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80248e:	a1 40 51 80 00       	mov    0x805140,%eax
  802493:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802496:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80249a:	74 07                	je     8024a3 <alloc_block_FF+0x1a5>
  80249c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249f:	8b 00                	mov    (%eax),%eax
  8024a1:	eb 05                	jmp    8024a8 <alloc_block_FF+0x1aa>
  8024a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8024a8:	a3 40 51 80 00       	mov    %eax,0x805140
  8024ad:	a1 40 51 80 00       	mov    0x805140,%eax
  8024b2:	85 c0                	test   %eax,%eax
  8024b4:	0f 85 57 fe ff ff    	jne    802311 <alloc_block_FF+0x13>
  8024ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024be:	0f 85 4d fe ff ff    	jne    802311 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8024c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024c9:	c9                   	leave  
  8024ca:	c3                   	ret    

008024cb <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8024cb:	55                   	push   %ebp
  8024cc:	89 e5                	mov    %esp,%ebp
  8024ce:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8024d1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8024d8:	a1 38 51 80 00       	mov    0x805138,%eax
  8024dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024e0:	e9 df 00 00 00       	jmp    8025c4 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8024e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e8:	8b 40 0c             	mov    0xc(%eax),%eax
  8024eb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024ee:	0f 82 c8 00 00 00    	jb     8025bc <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8024f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f7:	8b 40 0c             	mov    0xc(%eax),%eax
  8024fa:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024fd:	0f 85 8a 00 00 00    	jne    80258d <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802503:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802507:	75 17                	jne    802520 <alloc_block_BF+0x55>
  802509:	83 ec 04             	sub    $0x4,%esp
  80250c:	68 64 40 80 00       	push   $0x804064
  802511:	68 b7 00 00 00       	push   $0xb7
  802516:	68 bb 3f 80 00       	push   $0x803fbb
  80251b:	e8 70 dd ff ff       	call   800290 <_panic>
  802520:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802523:	8b 00                	mov    (%eax),%eax
  802525:	85 c0                	test   %eax,%eax
  802527:	74 10                	je     802539 <alloc_block_BF+0x6e>
  802529:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252c:	8b 00                	mov    (%eax),%eax
  80252e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802531:	8b 52 04             	mov    0x4(%edx),%edx
  802534:	89 50 04             	mov    %edx,0x4(%eax)
  802537:	eb 0b                	jmp    802544 <alloc_block_BF+0x79>
  802539:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253c:	8b 40 04             	mov    0x4(%eax),%eax
  80253f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802544:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802547:	8b 40 04             	mov    0x4(%eax),%eax
  80254a:	85 c0                	test   %eax,%eax
  80254c:	74 0f                	je     80255d <alloc_block_BF+0x92>
  80254e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802551:	8b 40 04             	mov    0x4(%eax),%eax
  802554:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802557:	8b 12                	mov    (%edx),%edx
  802559:	89 10                	mov    %edx,(%eax)
  80255b:	eb 0a                	jmp    802567 <alloc_block_BF+0x9c>
  80255d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802560:	8b 00                	mov    (%eax),%eax
  802562:	a3 38 51 80 00       	mov    %eax,0x805138
  802567:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802570:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802573:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80257a:	a1 44 51 80 00       	mov    0x805144,%eax
  80257f:	48                   	dec    %eax
  802580:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802585:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802588:	e9 4d 01 00 00       	jmp    8026da <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  80258d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802590:	8b 40 0c             	mov    0xc(%eax),%eax
  802593:	3b 45 08             	cmp    0x8(%ebp),%eax
  802596:	76 24                	jbe    8025bc <alloc_block_BF+0xf1>
  802598:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259b:	8b 40 0c             	mov    0xc(%eax),%eax
  80259e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8025a1:	73 19                	jae    8025bc <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8025a3:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8025aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ad:	8b 40 0c             	mov    0xc(%eax),%eax
  8025b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8025b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b6:	8b 40 08             	mov    0x8(%eax),%eax
  8025b9:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8025bc:	a1 40 51 80 00       	mov    0x805140,%eax
  8025c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025c8:	74 07                	je     8025d1 <alloc_block_BF+0x106>
  8025ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cd:	8b 00                	mov    (%eax),%eax
  8025cf:	eb 05                	jmp    8025d6 <alloc_block_BF+0x10b>
  8025d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8025d6:	a3 40 51 80 00       	mov    %eax,0x805140
  8025db:	a1 40 51 80 00       	mov    0x805140,%eax
  8025e0:	85 c0                	test   %eax,%eax
  8025e2:	0f 85 fd fe ff ff    	jne    8024e5 <alloc_block_BF+0x1a>
  8025e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025ec:	0f 85 f3 fe ff ff    	jne    8024e5 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8025f2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8025f6:	0f 84 d9 00 00 00    	je     8026d5 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8025fc:	a1 48 51 80 00       	mov    0x805148,%eax
  802601:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802604:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802607:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80260a:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  80260d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802610:	8b 55 08             	mov    0x8(%ebp),%edx
  802613:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802616:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80261a:	75 17                	jne    802633 <alloc_block_BF+0x168>
  80261c:	83 ec 04             	sub    $0x4,%esp
  80261f:	68 64 40 80 00       	push   $0x804064
  802624:	68 c7 00 00 00       	push   $0xc7
  802629:	68 bb 3f 80 00       	push   $0x803fbb
  80262e:	e8 5d dc ff ff       	call   800290 <_panic>
  802633:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802636:	8b 00                	mov    (%eax),%eax
  802638:	85 c0                	test   %eax,%eax
  80263a:	74 10                	je     80264c <alloc_block_BF+0x181>
  80263c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80263f:	8b 00                	mov    (%eax),%eax
  802641:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802644:	8b 52 04             	mov    0x4(%edx),%edx
  802647:	89 50 04             	mov    %edx,0x4(%eax)
  80264a:	eb 0b                	jmp    802657 <alloc_block_BF+0x18c>
  80264c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80264f:	8b 40 04             	mov    0x4(%eax),%eax
  802652:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802657:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80265a:	8b 40 04             	mov    0x4(%eax),%eax
  80265d:	85 c0                	test   %eax,%eax
  80265f:	74 0f                	je     802670 <alloc_block_BF+0x1a5>
  802661:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802664:	8b 40 04             	mov    0x4(%eax),%eax
  802667:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80266a:	8b 12                	mov    (%edx),%edx
  80266c:	89 10                	mov    %edx,(%eax)
  80266e:	eb 0a                	jmp    80267a <alloc_block_BF+0x1af>
  802670:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802673:	8b 00                	mov    (%eax),%eax
  802675:	a3 48 51 80 00       	mov    %eax,0x805148
  80267a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80267d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802683:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802686:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80268d:	a1 54 51 80 00       	mov    0x805154,%eax
  802692:	48                   	dec    %eax
  802693:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802698:	83 ec 08             	sub    $0x8,%esp
  80269b:	ff 75 ec             	pushl  -0x14(%ebp)
  80269e:	68 38 51 80 00       	push   $0x805138
  8026a3:	e8 71 f9 ff ff       	call   802019 <find_block>
  8026a8:	83 c4 10             	add    $0x10,%esp
  8026ab:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8026ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026b1:	8b 50 08             	mov    0x8(%eax),%edx
  8026b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b7:	01 c2                	add    %eax,%edx
  8026b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026bc:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8026bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026c2:	8b 40 0c             	mov    0xc(%eax),%eax
  8026c5:	2b 45 08             	sub    0x8(%ebp),%eax
  8026c8:	89 c2                	mov    %eax,%edx
  8026ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026cd:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8026d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026d3:	eb 05                	jmp    8026da <alloc_block_BF+0x20f>
	}
	return NULL;
  8026d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026da:	c9                   	leave  
  8026db:	c3                   	ret    

008026dc <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8026dc:	55                   	push   %ebp
  8026dd:	89 e5                	mov    %esp,%ebp
  8026df:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8026e2:	a1 28 50 80 00       	mov    0x805028,%eax
  8026e7:	85 c0                	test   %eax,%eax
  8026e9:	0f 85 de 01 00 00    	jne    8028cd <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8026ef:	a1 38 51 80 00       	mov    0x805138,%eax
  8026f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026f7:	e9 9e 01 00 00       	jmp    80289a <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8026fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ff:	8b 40 0c             	mov    0xc(%eax),%eax
  802702:	3b 45 08             	cmp    0x8(%ebp),%eax
  802705:	0f 82 87 01 00 00    	jb     802892 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  80270b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270e:	8b 40 0c             	mov    0xc(%eax),%eax
  802711:	3b 45 08             	cmp    0x8(%ebp),%eax
  802714:	0f 85 95 00 00 00    	jne    8027af <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  80271a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80271e:	75 17                	jne    802737 <alloc_block_NF+0x5b>
  802720:	83 ec 04             	sub    $0x4,%esp
  802723:	68 64 40 80 00       	push   $0x804064
  802728:	68 e0 00 00 00       	push   $0xe0
  80272d:	68 bb 3f 80 00       	push   $0x803fbb
  802732:	e8 59 db ff ff       	call   800290 <_panic>
  802737:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273a:	8b 00                	mov    (%eax),%eax
  80273c:	85 c0                	test   %eax,%eax
  80273e:	74 10                	je     802750 <alloc_block_NF+0x74>
  802740:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802743:	8b 00                	mov    (%eax),%eax
  802745:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802748:	8b 52 04             	mov    0x4(%edx),%edx
  80274b:	89 50 04             	mov    %edx,0x4(%eax)
  80274e:	eb 0b                	jmp    80275b <alloc_block_NF+0x7f>
  802750:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802753:	8b 40 04             	mov    0x4(%eax),%eax
  802756:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80275b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275e:	8b 40 04             	mov    0x4(%eax),%eax
  802761:	85 c0                	test   %eax,%eax
  802763:	74 0f                	je     802774 <alloc_block_NF+0x98>
  802765:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802768:	8b 40 04             	mov    0x4(%eax),%eax
  80276b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80276e:	8b 12                	mov    (%edx),%edx
  802770:	89 10                	mov    %edx,(%eax)
  802772:	eb 0a                	jmp    80277e <alloc_block_NF+0xa2>
  802774:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802777:	8b 00                	mov    (%eax),%eax
  802779:	a3 38 51 80 00       	mov    %eax,0x805138
  80277e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802781:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802787:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802791:	a1 44 51 80 00       	mov    0x805144,%eax
  802796:	48                   	dec    %eax
  802797:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  80279c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279f:	8b 40 08             	mov    0x8(%eax),%eax
  8027a2:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  8027a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027aa:	e9 f8 04 00 00       	jmp    802ca7 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8027af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b2:	8b 40 0c             	mov    0xc(%eax),%eax
  8027b5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027b8:	0f 86 d4 00 00 00    	jbe    802892 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8027be:	a1 48 51 80 00       	mov    0x805148,%eax
  8027c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8027c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c9:	8b 50 08             	mov    0x8(%eax),%edx
  8027cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027cf:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8027d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027d5:	8b 55 08             	mov    0x8(%ebp),%edx
  8027d8:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8027db:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027df:	75 17                	jne    8027f8 <alloc_block_NF+0x11c>
  8027e1:	83 ec 04             	sub    $0x4,%esp
  8027e4:	68 64 40 80 00       	push   $0x804064
  8027e9:	68 e9 00 00 00       	push   $0xe9
  8027ee:	68 bb 3f 80 00       	push   $0x803fbb
  8027f3:	e8 98 da ff ff       	call   800290 <_panic>
  8027f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027fb:	8b 00                	mov    (%eax),%eax
  8027fd:	85 c0                	test   %eax,%eax
  8027ff:	74 10                	je     802811 <alloc_block_NF+0x135>
  802801:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802804:	8b 00                	mov    (%eax),%eax
  802806:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802809:	8b 52 04             	mov    0x4(%edx),%edx
  80280c:	89 50 04             	mov    %edx,0x4(%eax)
  80280f:	eb 0b                	jmp    80281c <alloc_block_NF+0x140>
  802811:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802814:	8b 40 04             	mov    0x4(%eax),%eax
  802817:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80281c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80281f:	8b 40 04             	mov    0x4(%eax),%eax
  802822:	85 c0                	test   %eax,%eax
  802824:	74 0f                	je     802835 <alloc_block_NF+0x159>
  802826:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802829:	8b 40 04             	mov    0x4(%eax),%eax
  80282c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80282f:	8b 12                	mov    (%edx),%edx
  802831:	89 10                	mov    %edx,(%eax)
  802833:	eb 0a                	jmp    80283f <alloc_block_NF+0x163>
  802835:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802838:	8b 00                	mov    (%eax),%eax
  80283a:	a3 48 51 80 00       	mov    %eax,0x805148
  80283f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802842:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802848:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80284b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802852:	a1 54 51 80 00       	mov    0x805154,%eax
  802857:	48                   	dec    %eax
  802858:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  80285d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802860:	8b 40 08             	mov    0x8(%eax),%eax
  802863:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802868:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286b:	8b 50 08             	mov    0x8(%eax),%edx
  80286e:	8b 45 08             	mov    0x8(%ebp),%eax
  802871:	01 c2                	add    %eax,%edx
  802873:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802876:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802879:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287c:	8b 40 0c             	mov    0xc(%eax),%eax
  80287f:	2b 45 08             	sub    0x8(%ebp),%eax
  802882:	89 c2                	mov    %eax,%edx
  802884:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802887:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  80288a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80288d:	e9 15 04 00 00       	jmp    802ca7 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802892:	a1 40 51 80 00       	mov    0x805140,%eax
  802897:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80289a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80289e:	74 07                	je     8028a7 <alloc_block_NF+0x1cb>
  8028a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a3:	8b 00                	mov    (%eax),%eax
  8028a5:	eb 05                	jmp    8028ac <alloc_block_NF+0x1d0>
  8028a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8028ac:	a3 40 51 80 00       	mov    %eax,0x805140
  8028b1:	a1 40 51 80 00       	mov    0x805140,%eax
  8028b6:	85 c0                	test   %eax,%eax
  8028b8:	0f 85 3e fe ff ff    	jne    8026fc <alloc_block_NF+0x20>
  8028be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028c2:	0f 85 34 fe ff ff    	jne    8026fc <alloc_block_NF+0x20>
  8028c8:	e9 d5 03 00 00       	jmp    802ca2 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8028cd:	a1 38 51 80 00       	mov    0x805138,%eax
  8028d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028d5:	e9 b1 01 00 00       	jmp    802a8b <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8028da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028dd:	8b 50 08             	mov    0x8(%eax),%edx
  8028e0:	a1 28 50 80 00       	mov    0x805028,%eax
  8028e5:	39 c2                	cmp    %eax,%edx
  8028e7:	0f 82 96 01 00 00    	jb     802a83 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  8028ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f0:	8b 40 0c             	mov    0xc(%eax),%eax
  8028f3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028f6:	0f 82 87 01 00 00    	jb     802a83 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  8028fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ff:	8b 40 0c             	mov    0xc(%eax),%eax
  802902:	3b 45 08             	cmp    0x8(%ebp),%eax
  802905:	0f 85 95 00 00 00    	jne    8029a0 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80290b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80290f:	75 17                	jne    802928 <alloc_block_NF+0x24c>
  802911:	83 ec 04             	sub    $0x4,%esp
  802914:	68 64 40 80 00       	push   $0x804064
  802919:	68 fc 00 00 00       	push   $0xfc
  80291e:	68 bb 3f 80 00       	push   $0x803fbb
  802923:	e8 68 d9 ff ff       	call   800290 <_panic>
  802928:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292b:	8b 00                	mov    (%eax),%eax
  80292d:	85 c0                	test   %eax,%eax
  80292f:	74 10                	je     802941 <alloc_block_NF+0x265>
  802931:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802934:	8b 00                	mov    (%eax),%eax
  802936:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802939:	8b 52 04             	mov    0x4(%edx),%edx
  80293c:	89 50 04             	mov    %edx,0x4(%eax)
  80293f:	eb 0b                	jmp    80294c <alloc_block_NF+0x270>
  802941:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802944:	8b 40 04             	mov    0x4(%eax),%eax
  802947:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80294c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294f:	8b 40 04             	mov    0x4(%eax),%eax
  802952:	85 c0                	test   %eax,%eax
  802954:	74 0f                	je     802965 <alloc_block_NF+0x289>
  802956:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802959:	8b 40 04             	mov    0x4(%eax),%eax
  80295c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80295f:	8b 12                	mov    (%edx),%edx
  802961:	89 10                	mov    %edx,(%eax)
  802963:	eb 0a                	jmp    80296f <alloc_block_NF+0x293>
  802965:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802968:	8b 00                	mov    (%eax),%eax
  80296a:	a3 38 51 80 00       	mov    %eax,0x805138
  80296f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802972:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802978:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802982:	a1 44 51 80 00       	mov    0x805144,%eax
  802987:	48                   	dec    %eax
  802988:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  80298d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802990:	8b 40 08             	mov    0x8(%eax),%eax
  802993:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802998:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299b:	e9 07 03 00 00       	jmp    802ca7 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8029a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a3:	8b 40 0c             	mov    0xc(%eax),%eax
  8029a6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029a9:	0f 86 d4 00 00 00    	jbe    802a83 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8029af:	a1 48 51 80 00       	mov    0x805148,%eax
  8029b4:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  8029b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ba:	8b 50 08             	mov    0x8(%eax),%edx
  8029bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029c0:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8029c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8029c9:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8029cc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8029d0:	75 17                	jne    8029e9 <alloc_block_NF+0x30d>
  8029d2:	83 ec 04             	sub    $0x4,%esp
  8029d5:	68 64 40 80 00       	push   $0x804064
  8029da:	68 04 01 00 00       	push   $0x104
  8029df:	68 bb 3f 80 00       	push   $0x803fbb
  8029e4:	e8 a7 d8 ff ff       	call   800290 <_panic>
  8029e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029ec:	8b 00                	mov    (%eax),%eax
  8029ee:	85 c0                	test   %eax,%eax
  8029f0:	74 10                	je     802a02 <alloc_block_NF+0x326>
  8029f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029f5:	8b 00                	mov    (%eax),%eax
  8029f7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8029fa:	8b 52 04             	mov    0x4(%edx),%edx
  8029fd:	89 50 04             	mov    %edx,0x4(%eax)
  802a00:	eb 0b                	jmp    802a0d <alloc_block_NF+0x331>
  802a02:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a05:	8b 40 04             	mov    0x4(%eax),%eax
  802a08:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a0d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a10:	8b 40 04             	mov    0x4(%eax),%eax
  802a13:	85 c0                	test   %eax,%eax
  802a15:	74 0f                	je     802a26 <alloc_block_NF+0x34a>
  802a17:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a1a:	8b 40 04             	mov    0x4(%eax),%eax
  802a1d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a20:	8b 12                	mov    (%edx),%edx
  802a22:	89 10                	mov    %edx,(%eax)
  802a24:	eb 0a                	jmp    802a30 <alloc_block_NF+0x354>
  802a26:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a29:	8b 00                	mov    (%eax),%eax
  802a2b:	a3 48 51 80 00       	mov    %eax,0x805148
  802a30:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a33:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a39:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a3c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a43:	a1 54 51 80 00       	mov    0x805154,%eax
  802a48:	48                   	dec    %eax
  802a49:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802a4e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a51:	8b 40 08             	mov    0x8(%eax),%eax
  802a54:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802a59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5c:	8b 50 08             	mov    0x8(%eax),%edx
  802a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a62:	01 c2                	add    %eax,%edx
  802a64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a67:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802a6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6d:	8b 40 0c             	mov    0xc(%eax),%eax
  802a70:	2b 45 08             	sub    0x8(%ebp),%eax
  802a73:	89 c2                	mov    %eax,%edx
  802a75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a78:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802a7b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a7e:	e9 24 02 00 00       	jmp    802ca7 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a83:	a1 40 51 80 00       	mov    0x805140,%eax
  802a88:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a8b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a8f:	74 07                	je     802a98 <alloc_block_NF+0x3bc>
  802a91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a94:	8b 00                	mov    (%eax),%eax
  802a96:	eb 05                	jmp    802a9d <alloc_block_NF+0x3c1>
  802a98:	b8 00 00 00 00       	mov    $0x0,%eax
  802a9d:	a3 40 51 80 00       	mov    %eax,0x805140
  802aa2:	a1 40 51 80 00       	mov    0x805140,%eax
  802aa7:	85 c0                	test   %eax,%eax
  802aa9:	0f 85 2b fe ff ff    	jne    8028da <alloc_block_NF+0x1fe>
  802aaf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ab3:	0f 85 21 fe ff ff    	jne    8028da <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802ab9:	a1 38 51 80 00       	mov    0x805138,%eax
  802abe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ac1:	e9 ae 01 00 00       	jmp    802c74 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802ac6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac9:	8b 50 08             	mov    0x8(%eax),%edx
  802acc:	a1 28 50 80 00       	mov    0x805028,%eax
  802ad1:	39 c2                	cmp    %eax,%edx
  802ad3:	0f 83 93 01 00 00    	jae    802c6c <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802ad9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802adc:	8b 40 0c             	mov    0xc(%eax),%eax
  802adf:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ae2:	0f 82 84 01 00 00    	jb     802c6c <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802ae8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aeb:	8b 40 0c             	mov    0xc(%eax),%eax
  802aee:	3b 45 08             	cmp    0x8(%ebp),%eax
  802af1:	0f 85 95 00 00 00    	jne    802b8c <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802af7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802afb:	75 17                	jne    802b14 <alloc_block_NF+0x438>
  802afd:	83 ec 04             	sub    $0x4,%esp
  802b00:	68 64 40 80 00       	push   $0x804064
  802b05:	68 14 01 00 00       	push   $0x114
  802b0a:	68 bb 3f 80 00       	push   $0x803fbb
  802b0f:	e8 7c d7 ff ff       	call   800290 <_panic>
  802b14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b17:	8b 00                	mov    (%eax),%eax
  802b19:	85 c0                	test   %eax,%eax
  802b1b:	74 10                	je     802b2d <alloc_block_NF+0x451>
  802b1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b20:	8b 00                	mov    (%eax),%eax
  802b22:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b25:	8b 52 04             	mov    0x4(%edx),%edx
  802b28:	89 50 04             	mov    %edx,0x4(%eax)
  802b2b:	eb 0b                	jmp    802b38 <alloc_block_NF+0x45c>
  802b2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b30:	8b 40 04             	mov    0x4(%eax),%eax
  802b33:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3b:	8b 40 04             	mov    0x4(%eax),%eax
  802b3e:	85 c0                	test   %eax,%eax
  802b40:	74 0f                	je     802b51 <alloc_block_NF+0x475>
  802b42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b45:	8b 40 04             	mov    0x4(%eax),%eax
  802b48:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b4b:	8b 12                	mov    (%edx),%edx
  802b4d:	89 10                	mov    %edx,(%eax)
  802b4f:	eb 0a                	jmp    802b5b <alloc_block_NF+0x47f>
  802b51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b54:	8b 00                	mov    (%eax),%eax
  802b56:	a3 38 51 80 00       	mov    %eax,0x805138
  802b5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b67:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b6e:	a1 44 51 80 00       	mov    0x805144,%eax
  802b73:	48                   	dec    %eax
  802b74:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802b79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7c:	8b 40 08             	mov    0x8(%eax),%eax
  802b7f:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802b84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b87:	e9 1b 01 00 00       	jmp    802ca7 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802b8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8f:	8b 40 0c             	mov    0xc(%eax),%eax
  802b92:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b95:	0f 86 d1 00 00 00    	jbe    802c6c <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b9b:	a1 48 51 80 00       	mov    0x805148,%eax
  802ba0:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802ba3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba6:	8b 50 08             	mov    0x8(%eax),%edx
  802ba9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bac:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802baf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bb2:	8b 55 08             	mov    0x8(%ebp),%edx
  802bb5:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802bb8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802bbc:	75 17                	jne    802bd5 <alloc_block_NF+0x4f9>
  802bbe:	83 ec 04             	sub    $0x4,%esp
  802bc1:	68 64 40 80 00       	push   $0x804064
  802bc6:	68 1c 01 00 00       	push   $0x11c
  802bcb:	68 bb 3f 80 00       	push   $0x803fbb
  802bd0:	e8 bb d6 ff ff       	call   800290 <_panic>
  802bd5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bd8:	8b 00                	mov    (%eax),%eax
  802bda:	85 c0                	test   %eax,%eax
  802bdc:	74 10                	je     802bee <alloc_block_NF+0x512>
  802bde:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802be1:	8b 00                	mov    (%eax),%eax
  802be3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802be6:	8b 52 04             	mov    0x4(%edx),%edx
  802be9:	89 50 04             	mov    %edx,0x4(%eax)
  802bec:	eb 0b                	jmp    802bf9 <alloc_block_NF+0x51d>
  802bee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bf1:	8b 40 04             	mov    0x4(%eax),%eax
  802bf4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802bf9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bfc:	8b 40 04             	mov    0x4(%eax),%eax
  802bff:	85 c0                	test   %eax,%eax
  802c01:	74 0f                	je     802c12 <alloc_block_NF+0x536>
  802c03:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c06:	8b 40 04             	mov    0x4(%eax),%eax
  802c09:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c0c:	8b 12                	mov    (%edx),%edx
  802c0e:	89 10                	mov    %edx,(%eax)
  802c10:	eb 0a                	jmp    802c1c <alloc_block_NF+0x540>
  802c12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c15:	8b 00                	mov    (%eax),%eax
  802c17:	a3 48 51 80 00       	mov    %eax,0x805148
  802c1c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c1f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c25:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c28:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c2f:	a1 54 51 80 00       	mov    0x805154,%eax
  802c34:	48                   	dec    %eax
  802c35:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802c3a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c3d:	8b 40 08             	mov    0x8(%eax),%eax
  802c40:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802c45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c48:	8b 50 08             	mov    0x8(%eax),%edx
  802c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4e:	01 c2                	add    %eax,%edx
  802c50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c53:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802c56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c59:	8b 40 0c             	mov    0xc(%eax),%eax
  802c5c:	2b 45 08             	sub    0x8(%ebp),%eax
  802c5f:	89 c2                	mov    %eax,%edx
  802c61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c64:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802c67:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c6a:	eb 3b                	jmp    802ca7 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c6c:	a1 40 51 80 00       	mov    0x805140,%eax
  802c71:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c74:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c78:	74 07                	je     802c81 <alloc_block_NF+0x5a5>
  802c7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7d:	8b 00                	mov    (%eax),%eax
  802c7f:	eb 05                	jmp    802c86 <alloc_block_NF+0x5aa>
  802c81:	b8 00 00 00 00       	mov    $0x0,%eax
  802c86:	a3 40 51 80 00       	mov    %eax,0x805140
  802c8b:	a1 40 51 80 00       	mov    0x805140,%eax
  802c90:	85 c0                	test   %eax,%eax
  802c92:	0f 85 2e fe ff ff    	jne    802ac6 <alloc_block_NF+0x3ea>
  802c98:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c9c:	0f 85 24 fe ff ff    	jne    802ac6 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802ca2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ca7:	c9                   	leave  
  802ca8:	c3                   	ret    

00802ca9 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802ca9:	55                   	push   %ebp
  802caa:	89 e5                	mov    %esp,%ebp
  802cac:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802caf:	a1 38 51 80 00       	mov    0x805138,%eax
  802cb4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802cb7:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802cbc:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802cbf:	a1 38 51 80 00       	mov    0x805138,%eax
  802cc4:	85 c0                	test   %eax,%eax
  802cc6:	74 14                	je     802cdc <insert_sorted_with_merge_freeList+0x33>
  802cc8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ccb:	8b 50 08             	mov    0x8(%eax),%edx
  802cce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cd1:	8b 40 08             	mov    0x8(%eax),%eax
  802cd4:	39 c2                	cmp    %eax,%edx
  802cd6:	0f 87 9b 01 00 00    	ja     802e77 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802cdc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ce0:	75 17                	jne    802cf9 <insert_sorted_with_merge_freeList+0x50>
  802ce2:	83 ec 04             	sub    $0x4,%esp
  802ce5:	68 98 3f 80 00       	push   $0x803f98
  802cea:	68 38 01 00 00       	push   $0x138
  802cef:	68 bb 3f 80 00       	push   $0x803fbb
  802cf4:	e8 97 d5 ff ff       	call   800290 <_panic>
  802cf9:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802cff:	8b 45 08             	mov    0x8(%ebp),%eax
  802d02:	89 10                	mov    %edx,(%eax)
  802d04:	8b 45 08             	mov    0x8(%ebp),%eax
  802d07:	8b 00                	mov    (%eax),%eax
  802d09:	85 c0                	test   %eax,%eax
  802d0b:	74 0d                	je     802d1a <insert_sorted_with_merge_freeList+0x71>
  802d0d:	a1 38 51 80 00       	mov    0x805138,%eax
  802d12:	8b 55 08             	mov    0x8(%ebp),%edx
  802d15:	89 50 04             	mov    %edx,0x4(%eax)
  802d18:	eb 08                	jmp    802d22 <insert_sorted_with_merge_freeList+0x79>
  802d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d22:	8b 45 08             	mov    0x8(%ebp),%eax
  802d25:	a3 38 51 80 00       	mov    %eax,0x805138
  802d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d34:	a1 44 51 80 00       	mov    0x805144,%eax
  802d39:	40                   	inc    %eax
  802d3a:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802d3f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d43:	0f 84 a8 06 00 00    	je     8033f1 <insert_sorted_with_merge_freeList+0x748>
  802d49:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4c:	8b 50 08             	mov    0x8(%eax),%edx
  802d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d52:	8b 40 0c             	mov    0xc(%eax),%eax
  802d55:	01 c2                	add    %eax,%edx
  802d57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d5a:	8b 40 08             	mov    0x8(%eax),%eax
  802d5d:	39 c2                	cmp    %eax,%edx
  802d5f:	0f 85 8c 06 00 00    	jne    8033f1 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802d65:	8b 45 08             	mov    0x8(%ebp),%eax
  802d68:	8b 50 0c             	mov    0xc(%eax),%edx
  802d6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d6e:	8b 40 0c             	mov    0xc(%eax),%eax
  802d71:	01 c2                	add    %eax,%edx
  802d73:	8b 45 08             	mov    0x8(%ebp),%eax
  802d76:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802d79:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d7d:	75 17                	jne    802d96 <insert_sorted_with_merge_freeList+0xed>
  802d7f:	83 ec 04             	sub    $0x4,%esp
  802d82:	68 64 40 80 00       	push   $0x804064
  802d87:	68 3c 01 00 00       	push   $0x13c
  802d8c:	68 bb 3f 80 00       	push   $0x803fbb
  802d91:	e8 fa d4 ff ff       	call   800290 <_panic>
  802d96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d99:	8b 00                	mov    (%eax),%eax
  802d9b:	85 c0                	test   %eax,%eax
  802d9d:	74 10                	je     802daf <insert_sorted_with_merge_freeList+0x106>
  802d9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da2:	8b 00                	mov    (%eax),%eax
  802da4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802da7:	8b 52 04             	mov    0x4(%edx),%edx
  802daa:	89 50 04             	mov    %edx,0x4(%eax)
  802dad:	eb 0b                	jmp    802dba <insert_sorted_with_merge_freeList+0x111>
  802daf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802db2:	8b 40 04             	mov    0x4(%eax),%eax
  802db5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802dba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dbd:	8b 40 04             	mov    0x4(%eax),%eax
  802dc0:	85 c0                	test   %eax,%eax
  802dc2:	74 0f                	je     802dd3 <insert_sorted_with_merge_freeList+0x12a>
  802dc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc7:	8b 40 04             	mov    0x4(%eax),%eax
  802dca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802dcd:	8b 12                	mov    (%edx),%edx
  802dcf:	89 10                	mov    %edx,(%eax)
  802dd1:	eb 0a                	jmp    802ddd <insert_sorted_with_merge_freeList+0x134>
  802dd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dd6:	8b 00                	mov    (%eax),%eax
  802dd8:	a3 38 51 80 00       	mov    %eax,0x805138
  802ddd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802de6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802df0:	a1 44 51 80 00       	mov    0x805144,%eax
  802df5:	48                   	dec    %eax
  802df6:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802dfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dfe:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802e05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e08:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802e0f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e13:	75 17                	jne    802e2c <insert_sorted_with_merge_freeList+0x183>
  802e15:	83 ec 04             	sub    $0x4,%esp
  802e18:	68 98 3f 80 00       	push   $0x803f98
  802e1d:	68 3f 01 00 00       	push   $0x13f
  802e22:	68 bb 3f 80 00       	push   $0x803fbb
  802e27:	e8 64 d4 ff ff       	call   800290 <_panic>
  802e2c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802e32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e35:	89 10                	mov    %edx,(%eax)
  802e37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e3a:	8b 00                	mov    (%eax),%eax
  802e3c:	85 c0                	test   %eax,%eax
  802e3e:	74 0d                	je     802e4d <insert_sorted_with_merge_freeList+0x1a4>
  802e40:	a1 48 51 80 00       	mov    0x805148,%eax
  802e45:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e48:	89 50 04             	mov    %edx,0x4(%eax)
  802e4b:	eb 08                	jmp    802e55 <insert_sorted_with_merge_freeList+0x1ac>
  802e4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e50:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e58:	a3 48 51 80 00       	mov    %eax,0x805148
  802e5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e60:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e67:	a1 54 51 80 00       	mov    0x805154,%eax
  802e6c:	40                   	inc    %eax
  802e6d:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802e72:	e9 7a 05 00 00       	jmp    8033f1 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802e77:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7a:	8b 50 08             	mov    0x8(%eax),%edx
  802e7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e80:	8b 40 08             	mov    0x8(%eax),%eax
  802e83:	39 c2                	cmp    %eax,%edx
  802e85:	0f 82 14 01 00 00    	jb     802f9f <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802e8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e8e:	8b 50 08             	mov    0x8(%eax),%edx
  802e91:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e94:	8b 40 0c             	mov    0xc(%eax),%eax
  802e97:	01 c2                	add    %eax,%edx
  802e99:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9c:	8b 40 08             	mov    0x8(%eax),%eax
  802e9f:	39 c2                	cmp    %eax,%edx
  802ea1:	0f 85 90 00 00 00    	jne    802f37 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802ea7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eaa:	8b 50 0c             	mov    0xc(%eax),%edx
  802ead:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb0:	8b 40 0c             	mov    0xc(%eax),%eax
  802eb3:	01 c2                	add    %eax,%edx
  802eb5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eb8:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebe:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802ec5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802ecf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ed3:	75 17                	jne    802eec <insert_sorted_with_merge_freeList+0x243>
  802ed5:	83 ec 04             	sub    $0x4,%esp
  802ed8:	68 98 3f 80 00       	push   $0x803f98
  802edd:	68 49 01 00 00       	push   $0x149
  802ee2:	68 bb 3f 80 00       	push   $0x803fbb
  802ee7:	e8 a4 d3 ff ff       	call   800290 <_panic>
  802eec:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef5:	89 10                	mov    %edx,(%eax)
  802ef7:	8b 45 08             	mov    0x8(%ebp),%eax
  802efa:	8b 00                	mov    (%eax),%eax
  802efc:	85 c0                	test   %eax,%eax
  802efe:	74 0d                	je     802f0d <insert_sorted_with_merge_freeList+0x264>
  802f00:	a1 48 51 80 00       	mov    0x805148,%eax
  802f05:	8b 55 08             	mov    0x8(%ebp),%edx
  802f08:	89 50 04             	mov    %edx,0x4(%eax)
  802f0b:	eb 08                	jmp    802f15 <insert_sorted_with_merge_freeList+0x26c>
  802f0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f10:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f15:	8b 45 08             	mov    0x8(%ebp),%eax
  802f18:	a3 48 51 80 00       	mov    %eax,0x805148
  802f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f20:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f27:	a1 54 51 80 00       	mov    0x805154,%eax
  802f2c:	40                   	inc    %eax
  802f2d:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802f32:	e9 bb 04 00 00       	jmp    8033f2 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802f37:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f3b:	75 17                	jne    802f54 <insert_sorted_with_merge_freeList+0x2ab>
  802f3d:	83 ec 04             	sub    $0x4,%esp
  802f40:	68 0c 40 80 00       	push   $0x80400c
  802f45:	68 4c 01 00 00       	push   $0x14c
  802f4a:	68 bb 3f 80 00       	push   $0x803fbb
  802f4f:	e8 3c d3 ff ff       	call   800290 <_panic>
  802f54:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802f5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5d:	89 50 04             	mov    %edx,0x4(%eax)
  802f60:	8b 45 08             	mov    0x8(%ebp),%eax
  802f63:	8b 40 04             	mov    0x4(%eax),%eax
  802f66:	85 c0                	test   %eax,%eax
  802f68:	74 0c                	je     802f76 <insert_sorted_with_merge_freeList+0x2cd>
  802f6a:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f6f:	8b 55 08             	mov    0x8(%ebp),%edx
  802f72:	89 10                	mov    %edx,(%eax)
  802f74:	eb 08                	jmp    802f7e <insert_sorted_with_merge_freeList+0x2d5>
  802f76:	8b 45 08             	mov    0x8(%ebp),%eax
  802f79:	a3 38 51 80 00       	mov    %eax,0x805138
  802f7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f81:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f86:	8b 45 08             	mov    0x8(%ebp),%eax
  802f89:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f8f:	a1 44 51 80 00       	mov    0x805144,%eax
  802f94:	40                   	inc    %eax
  802f95:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802f9a:	e9 53 04 00 00       	jmp    8033f2 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802f9f:	a1 38 51 80 00       	mov    0x805138,%eax
  802fa4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fa7:	e9 15 04 00 00       	jmp    8033c1 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802fac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802faf:	8b 00                	mov    (%eax),%eax
  802fb1:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802fb4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb7:	8b 50 08             	mov    0x8(%eax),%edx
  802fba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fbd:	8b 40 08             	mov    0x8(%eax),%eax
  802fc0:	39 c2                	cmp    %eax,%edx
  802fc2:	0f 86 f1 03 00 00    	jbe    8033b9 <insert_sorted_with_merge_freeList+0x710>
  802fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  802fcb:	8b 50 08             	mov    0x8(%eax),%edx
  802fce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fd1:	8b 40 08             	mov    0x8(%eax),%eax
  802fd4:	39 c2                	cmp    %eax,%edx
  802fd6:	0f 83 dd 03 00 00    	jae    8033b9 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802fdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fdf:	8b 50 08             	mov    0x8(%eax),%edx
  802fe2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe5:	8b 40 0c             	mov    0xc(%eax),%eax
  802fe8:	01 c2                	add    %eax,%edx
  802fea:	8b 45 08             	mov    0x8(%ebp),%eax
  802fed:	8b 40 08             	mov    0x8(%eax),%eax
  802ff0:	39 c2                	cmp    %eax,%edx
  802ff2:	0f 85 b9 01 00 00    	jne    8031b1 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802ff8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffb:	8b 50 08             	mov    0x8(%eax),%edx
  802ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  803001:	8b 40 0c             	mov    0xc(%eax),%eax
  803004:	01 c2                	add    %eax,%edx
  803006:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803009:	8b 40 08             	mov    0x8(%eax),%eax
  80300c:	39 c2                	cmp    %eax,%edx
  80300e:	0f 85 0d 01 00 00    	jne    803121 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803014:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803017:	8b 50 0c             	mov    0xc(%eax),%edx
  80301a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80301d:	8b 40 0c             	mov    0xc(%eax),%eax
  803020:	01 c2                	add    %eax,%edx
  803022:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803025:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803028:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80302c:	75 17                	jne    803045 <insert_sorted_with_merge_freeList+0x39c>
  80302e:	83 ec 04             	sub    $0x4,%esp
  803031:	68 64 40 80 00       	push   $0x804064
  803036:	68 5c 01 00 00       	push   $0x15c
  80303b:	68 bb 3f 80 00       	push   $0x803fbb
  803040:	e8 4b d2 ff ff       	call   800290 <_panic>
  803045:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803048:	8b 00                	mov    (%eax),%eax
  80304a:	85 c0                	test   %eax,%eax
  80304c:	74 10                	je     80305e <insert_sorted_with_merge_freeList+0x3b5>
  80304e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803051:	8b 00                	mov    (%eax),%eax
  803053:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803056:	8b 52 04             	mov    0x4(%edx),%edx
  803059:	89 50 04             	mov    %edx,0x4(%eax)
  80305c:	eb 0b                	jmp    803069 <insert_sorted_with_merge_freeList+0x3c0>
  80305e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803061:	8b 40 04             	mov    0x4(%eax),%eax
  803064:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803069:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80306c:	8b 40 04             	mov    0x4(%eax),%eax
  80306f:	85 c0                	test   %eax,%eax
  803071:	74 0f                	je     803082 <insert_sorted_with_merge_freeList+0x3d9>
  803073:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803076:	8b 40 04             	mov    0x4(%eax),%eax
  803079:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80307c:	8b 12                	mov    (%edx),%edx
  80307e:	89 10                	mov    %edx,(%eax)
  803080:	eb 0a                	jmp    80308c <insert_sorted_with_merge_freeList+0x3e3>
  803082:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803085:	8b 00                	mov    (%eax),%eax
  803087:	a3 38 51 80 00       	mov    %eax,0x805138
  80308c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80308f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803095:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803098:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80309f:	a1 44 51 80 00       	mov    0x805144,%eax
  8030a4:	48                   	dec    %eax
  8030a5:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8030aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ad:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8030b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030b7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8030be:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030c2:	75 17                	jne    8030db <insert_sorted_with_merge_freeList+0x432>
  8030c4:	83 ec 04             	sub    $0x4,%esp
  8030c7:	68 98 3f 80 00       	push   $0x803f98
  8030cc:	68 5f 01 00 00       	push   $0x15f
  8030d1:	68 bb 3f 80 00       	push   $0x803fbb
  8030d6:	e8 b5 d1 ff ff       	call   800290 <_panic>
  8030db:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8030e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030e4:	89 10                	mov    %edx,(%eax)
  8030e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030e9:	8b 00                	mov    (%eax),%eax
  8030eb:	85 c0                	test   %eax,%eax
  8030ed:	74 0d                	je     8030fc <insert_sorted_with_merge_freeList+0x453>
  8030ef:	a1 48 51 80 00       	mov    0x805148,%eax
  8030f4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030f7:	89 50 04             	mov    %edx,0x4(%eax)
  8030fa:	eb 08                	jmp    803104 <insert_sorted_with_merge_freeList+0x45b>
  8030fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ff:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803104:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803107:	a3 48 51 80 00       	mov    %eax,0x805148
  80310c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80310f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803116:	a1 54 51 80 00       	mov    0x805154,%eax
  80311b:	40                   	inc    %eax
  80311c:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803121:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803124:	8b 50 0c             	mov    0xc(%eax),%edx
  803127:	8b 45 08             	mov    0x8(%ebp),%eax
  80312a:	8b 40 0c             	mov    0xc(%eax),%eax
  80312d:	01 c2                	add    %eax,%edx
  80312f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803132:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803135:	8b 45 08             	mov    0x8(%ebp),%eax
  803138:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  80313f:	8b 45 08             	mov    0x8(%ebp),%eax
  803142:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803149:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80314d:	75 17                	jne    803166 <insert_sorted_with_merge_freeList+0x4bd>
  80314f:	83 ec 04             	sub    $0x4,%esp
  803152:	68 98 3f 80 00       	push   $0x803f98
  803157:	68 64 01 00 00       	push   $0x164
  80315c:	68 bb 3f 80 00       	push   $0x803fbb
  803161:	e8 2a d1 ff ff       	call   800290 <_panic>
  803166:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80316c:	8b 45 08             	mov    0x8(%ebp),%eax
  80316f:	89 10                	mov    %edx,(%eax)
  803171:	8b 45 08             	mov    0x8(%ebp),%eax
  803174:	8b 00                	mov    (%eax),%eax
  803176:	85 c0                	test   %eax,%eax
  803178:	74 0d                	je     803187 <insert_sorted_with_merge_freeList+0x4de>
  80317a:	a1 48 51 80 00       	mov    0x805148,%eax
  80317f:	8b 55 08             	mov    0x8(%ebp),%edx
  803182:	89 50 04             	mov    %edx,0x4(%eax)
  803185:	eb 08                	jmp    80318f <insert_sorted_with_merge_freeList+0x4e6>
  803187:	8b 45 08             	mov    0x8(%ebp),%eax
  80318a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80318f:	8b 45 08             	mov    0x8(%ebp),%eax
  803192:	a3 48 51 80 00       	mov    %eax,0x805148
  803197:	8b 45 08             	mov    0x8(%ebp),%eax
  80319a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031a1:	a1 54 51 80 00       	mov    0x805154,%eax
  8031a6:	40                   	inc    %eax
  8031a7:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8031ac:	e9 41 02 00 00       	jmp    8033f2 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8031b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b4:	8b 50 08             	mov    0x8(%eax),%edx
  8031b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8031bd:	01 c2                	add    %eax,%edx
  8031bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c2:	8b 40 08             	mov    0x8(%eax),%eax
  8031c5:	39 c2                	cmp    %eax,%edx
  8031c7:	0f 85 7c 01 00 00    	jne    803349 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8031cd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031d1:	74 06                	je     8031d9 <insert_sorted_with_merge_freeList+0x530>
  8031d3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031d7:	75 17                	jne    8031f0 <insert_sorted_with_merge_freeList+0x547>
  8031d9:	83 ec 04             	sub    $0x4,%esp
  8031dc:	68 d4 3f 80 00       	push   $0x803fd4
  8031e1:	68 69 01 00 00       	push   $0x169
  8031e6:	68 bb 3f 80 00       	push   $0x803fbb
  8031eb:	e8 a0 d0 ff ff       	call   800290 <_panic>
  8031f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f3:	8b 50 04             	mov    0x4(%eax),%edx
  8031f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f9:	89 50 04             	mov    %edx,0x4(%eax)
  8031fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ff:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803202:	89 10                	mov    %edx,(%eax)
  803204:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803207:	8b 40 04             	mov    0x4(%eax),%eax
  80320a:	85 c0                	test   %eax,%eax
  80320c:	74 0d                	je     80321b <insert_sorted_with_merge_freeList+0x572>
  80320e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803211:	8b 40 04             	mov    0x4(%eax),%eax
  803214:	8b 55 08             	mov    0x8(%ebp),%edx
  803217:	89 10                	mov    %edx,(%eax)
  803219:	eb 08                	jmp    803223 <insert_sorted_with_merge_freeList+0x57a>
  80321b:	8b 45 08             	mov    0x8(%ebp),%eax
  80321e:	a3 38 51 80 00       	mov    %eax,0x805138
  803223:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803226:	8b 55 08             	mov    0x8(%ebp),%edx
  803229:	89 50 04             	mov    %edx,0x4(%eax)
  80322c:	a1 44 51 80 00       	mov    0x805144,%eax
  803231:	40                   	inc    %eax
  803232:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803237:	8b 45 08             	mov    0x8(%ebp),%eax
  80323a:	8b 50 0c             	mov    0xc(%eax),%edx
  80323d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803240:	8b 40 0c             	mov    0xc(%eax),%eax
  803243:	01 c2                	add    %eax,%edx
  803245:	8b 45 08             	mov    0x8(%ebp),%eax
  803248:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80324b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80324f:	75 17                	jne    803268 <insert_sorted_with_merge_freeList+0x5bf>
  803251:	83 ec 04             	sub    $0x4,%esp
  803254:	68 64 40 80 00       	push   $0x804064
  803259:	68 6b 01 00 00       	push   $0x16b
  80325e:	68 bb 3f 80 00       	push   $0x803fbb
  803263:	e8 28 d0 ff ff       	call   800290 <_panic>
  803268:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80326b:	8b 00                	mov    (%eax),%eax
  80326d:	85 c0                	test   %eax,%eax
  80326f:	74 10                	je     803281 <insert_sorted_with_merge_freeList+0x5d8>
  803271:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803274:	8b 00                	mov    (%eax),%eax
  803276:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803279:	8b 52 04             	mov    0x4(%edx),%edx
  80327c:	89 50 04             	mov    %edx,0x4(%eax)
  80327f:	eb 0b                	jmp    80328c <insert_sorted_with_merge_freeList+0x5e3>
  803281:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803284:	8b 40 04             	mov    0x4(%eax),%eax
  803287:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80328c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80328f:	8b 40 04             	mov    0x4(%eax),%eax
  803292:	85 c0                	test   %eax,%eax
  803294:	74 0f                	je     8032a5 <insert_sorted_with_merge_freeList+0x5fc>
  803296:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803299:	8b 40 04             	mov    0x4(%eax),%eax
  80329c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80329f:	8b 12                	mov    (%edx),%edx
  8032a1:	89 10                	mov    %edx,(%eax)
  8032a3:	eb 0a                	jmp    8032af <insert_sorted_with_merge_freeList+0x606>
  8032a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032a8:	8b 00                	mov    (%eax),%eax
  8032aa:	a3 38 51 80 00       	mov    %eax,0x805138
  8032af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032bb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032c2:	a1 44 51 80 00       	mov    0x805144,%eax
  8032c7:	48                   	dec    %eax
  8032c8:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8032cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8032d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032da:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8032e1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032e5:	75 17                	jne    8032fe <insert_sorted_with_merge_freeList+0x655>
  8032e7:	83 ec 04             	sub    $0x4,%esp
  8032ea:	68 98 3f 80 00       	push   $0x803f98
  8032ef:	68 6e 01 00 00       	push   $0x16e
  8032f4:	68 bb 3f 80 00       	push   $0x803fbb
  8032f9:	e8 92 cf ff ff       	call   800290 <_panic>
  8032fe:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803304:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803307:	89 10                	mov    %edx,(%eax)
  803309:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80330c:	8b 00                	mov    (%eax),%eax
  80330e:	85 c0                	test   %eax,%eax
  803310:	74 0d                	je     80331f <insert_sorted_with_merge_freeList+0x676>
  803312:	a1 48 51 80 00       	mov    0x805148,%eax
  803317:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80331a:	89 50 04             	mov    %edx,0x4(%eax)
  80331d:	eb 08                	jmp    803327 <insert_sorted_with_merge_freeList+0x67e>
  80331f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803322:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803327:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80332a:	a3 48 51 80 00       	mov    %eax,0x805148
  80332f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803332:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803339:	a1 54 51 80 00       	mov    0x805154,%eax
  80333e:	40                   	inc    %eax
  80333f:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803344:	e9 a9 00 00 00       	jmp    8033f2 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803349:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80334d:	74 06                	je     803355 <insert_sorted_with_merge_freeList+0x6ac>
  80334f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803353:	75 17                	jne    80336c <insert_sorted_with_merge_freeList+0x6c3>
  803355:	83 ec 04             	sub    $0x4,%esp
  803358:	68 30 40 80 00       	push   $0x804030
  80335d:	68 73 01 00 00       	push   $0x173
  803362:	68 bb 3f 80 00       	push   $0x803fbb
  803367:	e8 24 cf ff ff       	call   800290 <_panic>
  80336c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80336f:	8b 10                	mov    (%eax),%edx
  803371:	8b 45 08             	mov    0x8(%ebp),%eax
  803374:	89 10                	mov    %edx,(%eax)
  803376:	8b 45 08             	mov    0x8(%ebp),%eax
  803379:	8b 00                	mov    (%eax),%eax
  80337b:	85 c0                	test   %eax,%eax
  80337d:	74 0b                	je     80338a <insert_sorted_with_merge_freeList+0x6e1>
  80337f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803382:	8b 00                	mov    (%eax),%eax
  803384:	8b 55 08             	mov    0x8(%ebp),%edx
  803387:	89 50 04             	mov    %edx,0x4(%eax)
  80338a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80338d:	8b 55 08             	mov    0x8(%ebp),%edx
  803390:	89 10                	mov    %edx,(%eax)
  803392:	8b 45 08             	mov    0x8(%ebp),%eax
  803395:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803398:	89 50 04             	mov    %edx,0x4(%eax)
  80339b:	8b 45 08             	mov    0x8(%ebp),%eax
  80339e:	8b 00                	mov    (%eax),%eax
  8033a0:	85 c0                	test   %eax,%eax
  8033a2:	75 08                	jne    8033ac <insert_sorted_with_merge_freeList+0x703>
  8033a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033ac:	a1 44 51 80 00       	mov    0x805144,%eax
  8033b1:	40                   	inc    %eax
  8033b2:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  8033b7:	eb 39                	jmp    8033f2 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8033b9:	a1 40 51 80 00       	mov    0x805140,%eax
  8033be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033c5:	74 07                	je     8033ce <insert_sorted_with_merge_freeList+0x725>
  8033c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ca:	8b 00                	mov    (%eax),%eax
  8033cc:	eb 05                	jmp    8033d3 <insert_sorted_with_merge_freeList+0x72a>
  8033ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8033d3:	a3 40 51 80 00       	mov    %eax,0x805140
  8033d8:	a1 40 51 80 00       	mov    0x805140,%eax
  8033dd:	85 c0                	test   %eax,%eax
  8033df:	0f 85 c7 fb ff ff    	jne    802fac <insert_sorted_with_merge_freeList+0x303>
  8033e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033e9:	0f 85 bd fb ff ff    	jne    802fac <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8033ef:	eb 01                	jmp    8033f2 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8033f1:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8033f2:	90                   	nop
  8033f3:	c9                   	leave  
  8033f4:	c3                   	ret    

008033f5 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8033f5:	55                   	push   %ebp
  8033f6:	89 e5                	mov    %esp,%ebp
  8033f8:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8033fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8033fe:	89 d0                	mov    %edx,%eax
  803400:	c1 e0 02             	shl    $0x2,%eax
  803403:	01 d0                	add    %edx,%eax
  803405:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80340c:	01 d0                	add    %edx,%eax
  80340e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803415:	01 d0                	add    %edx,%eax
  803417:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80341e:	01 d0                	add    %edx,%eax
  803420:	c1 e0 04             	shl    $0x4,%eax
  803423:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803426:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  80342d:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803430:	83 ec 0c             	sub    $0xc,%esp
  803433:	50                   	push   %eax
  803434:	e8 26 e7 ff ff       	call   801b5f <sys_get_virtual_time>
  803439:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  80343c:	eb 41                	jmp    80347f <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  80343e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803441:	83 ec 0c             	sub    $0xc,%esp
  803444:	50                   	push   %eax
  803445:	e8 15 e7 ff ff       	call   801b5f <sys_get_virtual_time>
  80344a:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  80344d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803450:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803453:	29 c2                	sub    %eax,%edx
  803455:	89 d0                	mov    %edx,%eax
  803457:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  80345a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80345d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803460:	89 d1                	mov    %edx,%ecx
  803462:	29 c1                	sub    %eax,%ecx
  803464:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803467:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80346a:	39 c2                	cmp    %eax,%edx
  80346c:	0f 97 c0             	seta   %al
  80346f:	0f b6 c0             	movzbl %al,%eax
  803472:	29 c1                	sub    %eax,%ecx
  803474:	89 c8                	mov    %ecx,%eax
  803476:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803479:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80347c:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  80347f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803482:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803485:	72 b7                	jb     80343e <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803487:	90                   	nop
  803488:	c9                   	leave  
  803489:	c3                   	ret    

0080348a <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  80348a:	55                   	push   %ebp
  80348b:	89 e5                	mov    %esp,%ebp
  80348d:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803490:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803497:	eb 03                	jmp    80349c <busy_wait+0x12>
  803499:	ff 45 fc             	incl   -0x4(%ebp)
  80349c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80349f:	3b 45 08             	cmp    0x8(%ebp),%eax
  8034a2:	72 f5                	jb     803499 <busy_wait+0xf>
	return i;
  8034a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8034a7:	c9                   	leave  
  8034a8:	c3                   	ret    
  8034a9:	66 90                	xchg   %ax,%ax
  8034ab:	90                   	nop

008034ac <__udivdi3>:
  8034ac:	55                   	push   %ebp
  8034ad:	57                   	push   %edi
  8034ae:	56                   	push   %esi
  8034af:	53                   	push   %ebx
  8034b0:	83 ec 1c             	sub    $0x1c,%esp
  8034b3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8034b7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8034bb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8034bf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8034c3:	89 ca                	mov    %ecx,%edx
  8034c5:	89 f8                	mov    %edi,%eax
  8034c7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8034cb:	85 f6                	test   %esi,%esi
  8034cd:	75 2d                	jne    8034fc <__udivdi3+0x50>
  8034cf:	39 cf                	cmp    %ecx,%edi
  8034d1:	77 65                	ja     803538 <__udivdi3+0x8c>
  8034d3:	89 fd                	mov    %edi,%ebp
  8034d5:	85 ff                	test   %edi,%edi
  8034d7:	75 0b                	jne    8034e4 <__udivdi3+0x38>
  8034d9:	b8 01 00 00 00       	mov    $0x1,%eax
  8034de:	31 d2                	xor    %edx,%edx
  8034e0:	f7 f7                	div    %edi
  8034e2:	89 c5                	mov    %eax,%ebp
  8034e4:	31 d2                	xor    %edx,%edx
  8034e6:	89 c8                	mov    %ecx,%eax
  8034e8:	f7 f5                	div    %ebp
  8034ea:	89 c1                	mov    %eax,%ecx
  8034ec:	89 d8                	mov    %ebx,%eax
  8034ee:	f7 f5                	div    %ebp
  8034f0:	89 cf                	mov    %ecx,%edi
  8034f2:	89 fa                	mov    %edi,%edx
  8034f4:	83 c4 1c             	add    $0x1c,%esp
  8034f7:	5b                   	pop    %ebx
  8034f8:	5e                   	pop    %esi
  8034f9:	5f                   	pop    %edi
  8034fa:	5d                   	pop    %ebp
  8034fb:	c3                   	ret    
  8034fc:	39 ce                	cmp    %ecx,%esi
  8034fe:	77 28                	ja     803528 <__udivdi3+0x7c>
  803500:	0f bd fe             	bsr    %esi,%edi
  803503:	83 f7 1f             	xor    $0x1f,%edi
  803506:	75 40                	jne    803548 <__udivdi3+0x9c>
  803508:	39 ce                	cmp    %ecx,%esi
  80350a:	72 0a                	jb     803516 <__udivdi3+0x6a>
  80350c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803510:	0f 87 9e 00 00 00    	ja     8035b4 <__udivdi3+0x108>
  803516:	b8 01 00 00 00       	mov    $0x1,%eax
  80351b:	89 fa                	mov    %edi,%edx
  80351d:	83 c4 1c             	add    $0x1c,%esp
  803520:	5b                   	pop    %ebx
  803521:	5e                   	pop    %esi
  803522:	5f                   	pop    %edi
  803523:	5d                   	pop    %ebp
  803524:	c3                   	ret    
  803525:	8d 76 00             	lea    0x0(%esi),%esi
  803528:	31 ff                	xor    %edi,%edi
  80352a:	31 c0                	xor    %eax,%eax
  80352c:	89 fa                	mov    %edi,%edx
  80352e:	83 c4 1c             	add    $0x1c,%esp
  803531:	5b                   	pop    %ebx
  803532:	5e                   	pop    %esi
  803533:	5f                   	pop    %edi
  803534:	5d                   	pop    %ebp
  803535:	c3                   	ret    
  803536:	66 90                	xchg   %ax,%ax
  803538:	89 d8                	mov    %ebx,%eax
  80353a:	f7 f7                	div    %edi
  80353c:	31 ff                	xor    %edi,%edi
  80353e:	89 fa                	mov    %edi,%edx
  803540:	83 c4 1c             	add    $0x1c,%esp
  803543:	5b                   	pop    %ebx
  803544:	5e                   	pop    %esi
  803545:	5f                   	pop    %edi
  803546:	5d                   	pop    %ebp
  803547:	c3                   	ret    
  803548:	bd 20 00 00 00       	mov    $0x20,%ebp
  80354d:	89 eb                	mov    %ebp,%ebx
  80354f:	29 fb                	sub    %edi,%ebx
  803551:	89 f9                	mov    %edi,%ecx
  803553:	d3 e6                	shl    %cl,%esi
  803555:	89 c5                	mov    %eax,%ebp
  803557:	88 d9                	mov    %bl,%cl
  803559:	d3 ed                	shr    %cl,%ebp
  80355b:	89 e9                	mov    %ebp,%ecx
  80355d:	09 f1                	or     %esi,%ecx
  80355f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803563:	89 f9                	mov    %edi,%ecx
  803565:	d3 e0                	shl    %cl,%eax
  803567:	89 c5                	mov    %eax,%ebp
  803569:	89 d6                	mov    %edx,%esi
  80356b:	88 d9                	mov    %bl,%cl
  80356d:	d3 ee                	shr    %cl,%esi
  80356f:	89 f9                	mov    %edi,%ecx
  803571:	d3 e2                	shl    %cl,%edx
  803573:	8b 44 24 08          	mov    0x8(%esp),%eax
  803577:	88 d9                	mov    %bl,%cl
  803579:	d3 e8                	shr    %cl,%eax
  80357b:	09 c2                	or     %eax,%edx
  80357d:	89 d0                	mov    %edx,%eax
  80357f:	89 f2                	mov    %esi,%edx
  803581:	f7 74 24 0c          	divl   0xc(%esp)
  803585:	89 d6                	mov    %edx,%esi
  803587:	89 c3                	mov    %eax,%ebx
  803589:	f7 e5                	mul    %ebp
  80358b:	39 d6                	cmp    %edx,%esi
  80358d:	72 19                	jb     8035a8 <__udivdi3+0xfc>
  80358f:	74 0b                	je     80359c <__udivdi3+0xf0>
  803591:	89 d8                	mov    %ebx,%eax
  803593:	31 ff                	xor    %edi,%edi
  803595:	e9 58 ff ff ff       	jmp    8034f2 <__udivdi3+0x46>
  80359a:	66 90                	xchg   %ax,%ax
  80359c:	8b 54 24 08          	mov    0x8(%esp),%edx
  8035a0:	89 f9                	mov    %edi,%ecx
  8035a2:	d3 e2                	shl    %cl,%edx
  8035a4:	39 c2                	cmp    %eax,%edx
  8035a6:	73 e9                	jae    803591 <__udivdi3+0xe5>
  8035a8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8035ab:	31 ff                	xor    %edi,%edi
  8035ad:	e9 40 ff ff ff       	jmp    8034f2 <__udivdi3+0x46>
  8035b2:	66 90                	xchg   %ax,%ax
  8035b4:	31 c0                	xor    %eax,%eax
  8035b6:	e9 37 ff ff ff       	jmp    8034f2 <__udivdi3+0x46>
  8035bb:	90                   	nop

008035bc <__umoddi3>:
  8035bc:	55                   	push   %ebp
  8035bd:	57                   	push   %edi
  8035be:	56                   	push   %esi
  8035bf:	53                   	push   %ebx
  8035c0:	83 ec 1c             	sub    $0x1c,%esp
  8035c3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8035c7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8035cb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8035cf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8035d3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8035d7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8035db:	89 f3                	mov    %esi,%ebx
  8035dd:	89 fa                	mov    %edi,%edx
  8035df:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8035e3:	89 34 24             	mov    %esi,(%esp)
  8035e6:	85 c0                	test   %eax,%eax
  8035e8:	75 1a                	jne    803604 <__umoddi3+0x48>
  8035ea:	39 f7                	cmp    %esi,%edi
  8035ec:	0f 86 a2 00 00 00    	jbe    803694 <__umoddi3+0xd8>
  8035f2:	89 c8                	mov    %ecx,%eax
  8035f4:	89 f2                	mov    %esi,%edx
  8035f6:	f7 f7                	div    %edi
  8035f8:	89 d0                	mov    %edx,%eax
  8035fa:	31 d2                	xor    %edx,%edx
  8035fc:	83 c4 1c             	add    $0x1c,%esp
  8035ff:	5b                   	pop    %ebx
  803600:	5e                   	pop    %esi
  803601:	5f                   	pop    %edi
  803602:	5d                   	pop    %ebp
  803603:	c3                   	ret    
  803604:	39 f0                	cmp    %esi,%eax
  803606:	0f 87 ac 00 00 00    	ja     8036b8 <__umoddi3+0xfc>
  80360c:	0f bd e8             	bsr    %eax,%ebp
  80360f:	83 f5 1f             	xor    $0x1f,%ebp
  803612:	0f 84 ac 00 00 00    	je     8036c4 <__umoddi3+0x108>
  803618:	bf 20 00 00 00       	mov    $0x20,%edi
  80361d:	29 ef                	sub    %ebp,%edi
  80361f:	89 fe                	mov    %edi,%esi
  803621:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803625:	89 e9                	mov    %ebp,%ecx
  803627:	d3 e0                	shl    %cl,%eax
  803629:	89 d7                	mov    %edx,%edi
  80362b:	89 f1                	mov    %esi,%ecx
  80362d:	d3 ef                	shr    %cl,%edi
  80362f:	09 c7                	or     %eax,%edi
  803631:	89 e9                	mov    %ebp,%ecx
  803633:	d3 e2                	shl    %cl,%edx
  803635:	89 14 24             	mov    %edx,(%esp)
  803638:	89 d8                	mov    %ebx,%eax
  80363a:	d3 e0                	shl    %cl,%eax
  80363c:	89 c2                	mov    %eax,%edx
  80363e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803642:	d3 e0                	shl    %cl,%eax
  803644:	89 44 24 04          	mov    %eax,0x4(%esp)
  803648:	8b 44 24 08          	mov    0x8(%esp),%eax
  80364c:	89 f1                	mov    %esi,%ecx
  80364e:	d3 e8                	shr    %cl,%eax
  803650:	09 d0                	or     %edx,%eax
  803652:	d3 eb                	shr    %cl,%ebx
  803654:	89 da                	mov    %ebx,%edx
  803656:	f7 f7                	div    %edi
  803658:	89 d3                	mov    %edx,%ebx
  80365a:	f7 24 24             	mull   (%esp)
  80365d:	89 c6                	mov    %eax,%esi
  80365f:	89 d1                	mov    %edx,%ecx
  803661:	39 d3                	cmp    %edx,%ebx
  803663:	0f 82 87 00 00 00    	jb     8036f0 <__umoddi3+0x134>
  803669:	0f 84 91 00 00 00    	je     803700 <__umoddi3+0x144>
  80366f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803673:	29 f2                	sub    %esi,%edx
  803675:	19 cb                	sbb    %ecx,%ebx
  803677:	89 d8                	mov    %ebx,%eax
  803679:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80367d:	d3 e0                	shl    %cl,%eax
  80367f:	89 e9                	mov    %ebp,%ecx
  803681:	d3 ea                	shr    %cl,%edx
  803683:	09 d0                	or     %edx,%eax
  803685:	89 e9                	mov    %ebp,%ecx
  803687:	d3 eb                	shr    %cl,%ebx
  803689:	89 da                	mov    %ebx,%edx
  80368b:	83 c4 1c             	add    $0x1c,%esp
  80368e:	5b                   	pop    %ebx
  80368f:	5e                   	pop    %esi
  803690:	5f                   	pop    %edi
  803691:	5d                   	pop    %ebp
  803692:	c3                   	ret    
  803693:	90                   	nop
  803694:	89 fd                	mov    %edi,%ebp
  803696:	85 ff                	test   %edi,%edi
  803698:	75 0b                	jne    8036a5 <__umoddi3+0xe9>
  80369a:	b8 01 00 00 00       	mov    $0x1,%eax
  80369f:	31 d2                	xor    %edx,%edx
  8036a1:	f7 f7                	div    %edi
  8036a3:	89 c5                	mov    %eax,%ebp
  8036a5:	89 f0                	mov    %esi,%eax
  8036a7:	31 d2                	xor    %edx,%edx
  8036a9:	f7 f5                	div    %ebp
  8036ab:	89 c8                	mov    %ecx,%eax
  8036ad:	f7 f5                	div    %ebp
  8036af:	89 d0                	mov    %edx,%eax
  8036b1:	e9 44 ff ff ff       	jmp    8035fa <__umoddi3+0x3e>
  8036b6:	66 90                	xchg   %ax,%ax
  8036b8:	89 c8                	mov    %ecx,%eax
  8036ba:	89 f2                	mov    %esi,%edx
  8036bc:	83 c4 1c             	add    $0x1c,%esp
  8036bf:	5b                   	pop    %ebx
  8036c0:	5e                   	pop    %esi
  8036c1:	5f                   	pop    %edi
  8036c2:	5d                   	pop    %ebp
  8036c3:	c3                   	ret    
  8036c4:	3b 04 24             	cmp    (%esp),%eax
  8036c7:	72 06                	jb     8036cf <__umoddi3+0x113>
  8036c9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8036cd:	77 0f                	ja     8036de <__umoddi3+0x122>
  8036cf:	89 f2                	mov    %esi,%edx
  8036d1:	29 f9                	sub    %edi,%ecx
  8036d3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8036d7:	89 14 24             	mov    %edx,(%esp)
  8036da:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8036de:	8b 44 24 04          	mov    0x4(%esp),%eax
  8036e2:	8b 14 24             	mov    (%esp),%edx
  8036e5:	83 c4 1c             	add    $0x1c,%esp
  8036e8:	5b                   	pop    %ebx
  8036e9:	5e                   	pop    %esi
  8036ea:	5f                   	pop    %edi
  8036eb:	5d                   	pop    %ebp
  8036ec:	c3                   	ret    
  8036ed:	8d 76 00             	lea    0x0(%esi),%esi
  8036f0:	2b 04 24             	sub    (%esp),%eax
  8036f3:	19 fa                	sbb    %edi,%edx
  8036f5:	89 d1                	mov    %edx,%ecx
  8036f7:	89 c6                	mov    %eax,%esi
  8036f9:	e9 71 ff ff ff       	jmp    80366f <__umoddi3+0xb3>
  8036fe:	66 90                	xchg   %ax,%ax
  803700:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803704:	72 ea                	jb     8036f0 <__umoddi3+0x134>
  803706:	89 d9                	mov    %ebx,%ecx
  803708:	e9 62 ff ff ff       	jmp    80366f <__umoddi3+0xb3>
