
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
  80008c:	68 80 36 80 00       	push   $0x803680
  800091:	6a 12                	push   $0x12
  800093:	68 9c 36 80 00       	push   $0x80369c
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
  8000aa:	e8 eb 19 00 00       	call   801a9a <sys_getparentenvid>
  8000af:	83 ec 08             	sub    $0x8,%esp
  8000b2:	68 b9 36 80 00       	push   $0x8036b9
  8000b7:	50                   	push   %eax
  8000b8:	e8 40 15 00 00       	call   8015fd <sget>
  8000bd:	83 c4 10             	add    $0x10,%esp
  8000c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("Slave B1 env used x (getSharedObject)\n");
  8000c3:	83 ec 0c             	sub    $0xc,%esp
  8000c6:	68 bc 36 80 00       	push   $0x8036bc
  8000cb:	e8 74 04 00 00       	call   800544 <cprintf>
  8000d0:	83 c4 10             	add    $0x10,%esp
	//To indicate that it's successfully got x
	inctst();
  8000d3:	e8 e7 1a 00 00       	call   801bbf <inctst>
	cprintf("Slave B1 please be patient ...\n");
  8000d8:	83 ec 0c             	sub    $0xc,%esp
  8000db:	68 e4 36 80 00       	push   $0x8036e4
  8000e0:	e8 5f 04 00 00       	call   800544 <cprintf>
  8000e5:	83 c4 10             	add    $0x10,%esp

	//sleep a while to allow the master to remove x & z
	env_sleep(6000);
  8000e8:	83 ec 0c             	sub    $0xc,%esp
  8000eb:	68 70 17 00 00       	push   $0x1770
  8000f0:	e8 6e 32 00 00       	call   803363 <env_sleep>
  8000f5:	83 c4 10             	add    $0x10,%esp

	int freeFrames = sys_calculate_free_frames() ;
  8000f8:	e8 a4 16 00 00       	call   8017a1 <sys_calculate_free_frames>
  8000fd:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sfree(x);
  800100:	83 ec 0c             	sub    $0xc,%esp
  800103:	ff 75 ec             	pushl  -0x14(%ebp)
  800106:	e8 36 15 00 00       	call   801641 <sfree>
  80010b:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave B1 env removed x\n");
  80010e:	83 ec 0c             	sub    $0xc,%esp
  800111:	68 04 37 80 00       	push   $0x803704
  800116:	e8 29 04 00 00       	call   800544 <cprintf>
  80011b:	83 c4 10             	add    $0x10,%esp
	int expected = (1+1) + (1+1);
  80011e:	c7 45 e4 04 00 00 00 	movl   $0x4,-0x1c(%ebp)
	if ((sys_calculate_free_frames() - freeFrames) !=  expected) panic("B1 wrong free: frames removed not equal 4 !, correct frames to be removed are 4:\nfrom the env: 1 table and 1 for frame of x\nframes_storage of x: should be cleared now\n");
  800125:	e8 77 16 00 00       	call   8017a1 <sys_calculate_free_frames>
  80012a:	89 c2                	mov    %eax,%edx
  80012c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80012f:	29 c2                	sub    %eax,%edx
  800131:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800134:	39 c2                	cmp    %eax,%edx
  800136:	74 14                	je     80014c <_main+0x114>
  800138:	83 ec 04             	sub    $0x4,%esp
  80013b:	68 1c 37 80 00       	push   $0x80371c
  800140:	6a 27                	push   $0x27
  800142:	68 9c 36 80 00       	push   $0x80369c
  800147:	e8 44 01 00 00       	call   800290 <_panic>

	//To indicate that it's completed successfully
	inctst();
  80014c:	e8 6e 1a 00 00       	call   801bbf <inctst>
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
  80015a:	e8 22 19 00 00       	call   801a81 <sys_getenvindex>
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
  8001c5:	e8 c4 16 00 00       	call   80188e <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001ca:	83 ec 0c             	sub    $0xc,%esp
  8001cd:	68 dc 37 80 00       	push   $0x8037dc
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
  8001f5:	68 04 38 80 00       	push   $0x803804
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
  800226:	68 2c 38 80 00       	push   $0x80382c
  80022b:	e8 14 03 00 00       	call   800544 <cprintf>
  800230:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800233:	a1 20 50 80 00       	mov    0x805020,%eax
  800238:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80023e:	83 ec 08             	sub    $0x8,%esp
  800241:	50                   	push   %eax
  800242:	68 84 38 80 00       	push   $0x803884
  800247:	e8 f8 02 00 00       	call   800544 <cprintf>
  80024c:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80024f:	83 ec 0c             	sub    $0xc,%esp
  800252:	68 dc 37 80 00       	push   $0x8037dc
  800257:	e8 e8 02 00 00       	call   800544 <cprintf>
  80025c:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80025f:	e8 44 16 00 00       	call   8018a8 <sys_enable_interrupt>

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
  800277:	e8 d1 17 00 00       	call   801a4d <sys_destroy_env>
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
  800288:	e8 26 18 00 00       	call   801ab3 <sys_exit_env>
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
  8002b1:	68 98 38 80 00       	push   $0x803898
  8002b6:	e8 89 02 00 00       	call   800544 <cprintf>
  8002bb:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002be:	a1 00 50 80 00       	mov    0x805000,%eax
  8002c3:	ff 75 0c             	pushl  0xc(%ebp)
  8002c6:	ff 75 08             	pushl  0x8(%ebp)
  8002c9:	50                   	push   %eax
  8002ca:	68 9d 38 80 00       	push   $0x80389d
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
  8002ee:	68 b9 38 80 00       	push   $0x8038b9
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
  80031a:	68 bc 38 80 00       	push   $0x8038bc
  80031f:	6a 26                	push   $0x26
  800321:	68 08 39 80 00       	push   $0x803908
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
  8003ec:	68 14 39 80 00       	push   $0x803914
  8003f1:	6a 3a                	push   $0x3a
  8003f3:	68 08 39 80 00       	push   $0x803908
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
  80045c:	68 68 39 80 00       	push   $0x803968
  800461:	6a 44                	push   $0x44
  800463:	68 08 39 80 00       	push   $0x803908
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
  8004b6:	e8 25 12 00 00       	call   8016e0 <sys_cputs>
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
  80052d:	e8 ae 11 00 00       	call   8016e0 <sys_cputs>
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
  800577:	e8 12 13 00 00       	call   80188e <sys_disable_interrupt>
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
  800597:	e8 0c 13 00 00       	call   8018a8 <sys_enable_interrupt>
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
  8005e1:	e8 32 2e 00 00       	call   803418 <__udivdi3>
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
  800631:	e8 f2 2e 00 00       	call   803528 <__umoddi3>
  800636:	83 c4 10             	add    $0x10,%esp
  800639:	05 d4 3b 80 00       	add    $0x803bd4,%eax
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
  80078c:	8b 04 85 f8 3b 80 00 	mov    0x803bf8(,%eax,4),%eax
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
  80086d:	8b 34 9d 40 3a 80 00 	mov    0x803a40(,%ebx,4),%esi
  800874:	85 f6                	test   %esi,%esi
  800876:	75 19                	jne    800891 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800878:	53                   	push   %ebx
  800879:	68 e5 3b 80 00       	push   $0x803be5
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
  800892:	68 ee 3b 80 00       	push   $0x803bee
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
  8008bf:	be f1 3b 80 00       	mov    $0x803bf1,%esi
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
  8012e5:	68 50 3d 80 00       	push   $0x803d50
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
  8013b5:	e8 6a 04 00 00       	call   801824 <sys_allocate_chunk>
  8013ba:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013bd:	a1 20 51 80 00       	mov    0x805120,%eax
  8013c2:	83 ec 0c             	sub    $0xc,%esp
  8013c5:	50                   	push   %eax
  8013c6:	e8 df 0a 00 00       	call   801eaa <initialize_MemBlocksList>
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
  8013f3:	68 75 3d 80 00       	push   $0x803d75
  8013f8:	6a 33                	push   $0x33
  8013fa:	68 93 3d 80 00       	push   $0x803d93
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
  801472:	68 a0 3d 80 00       	push   $0x803da0
  801477:	6a 34                	push   $0x34
  801479:	68 93 3d 80 00       	push   $0x803d93
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
  80150a:	e8 e3 06 00 00       	call   801bf2 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80150f:	85 c0                	test   %eax,%eax
  801511:	74 11                	je     801524 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801513:	83 ec 0c             	sub    $0xc,%esp
  801516:	ff 75 e8             	pushl  -0x18(%ebp)
  801519:	e8 4e 0d 00 00       	call   80226c <alloc_block_FF>
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
  801530:	e8 aa 0a 00 00       	call   801fdf <insert_sorted_allocList>
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
  801550:	68 c4 3d 80 00       	push   $0x803dc4
  801555:	6a 6f                	push   $0x6f
  801557:	68 93 3d 80 00       	push   $0x803d93
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
  801576:	75 07                	jne    80157f <smalloc+0x1e>
  801578:	b8 00 00 00 00       	mov    $0x0,%eax
  80157d:	eb 7c                	jmp    8015fb <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  80157f:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801586:	8b 55 0c             	mov    0xc(%ebp),%edx
  801589:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80158c:	01 d0                	add    %edx,%eax
  80158e:	48                   	dec    %eax
  80158f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801592:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801595:	ba 00 00 00 00       	mov    $0x0,%edx
  80159a:	f7 75 f0             	divl   -0x10(%ebp)
  80159d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015a0:	29 d0                	sub    %edx,%eax
  8015a2:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  8015a5:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8015ac:	e8 41 06 00 00       	call   801bf2 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8015b1:	85 c0                	test   %eax,%eax
  8015b3:	74 11                	je     8015c6 <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  8015b5:	83 ec 0c             	sub    $0xc,%esp
  8015b8:	ff 75 e8             	pushl  -0x18(%ebp)
  8015bb:	e8 ac 0c 00 00       	call   80226c <alloc_block_FF>
  8015c0:	83 c4 10             	add    $0x10,%esp
  8015c3:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  8015c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8015ca:	74 2a                	je     8015f6 <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8015cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015cf:	8b 40 08             	mov    0x8(%eax),%eax
  8015d2:	89 c2                	mov    %eax,%edx
  8015d4:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8015d8:	52                   	push   %edx
  8015d9:	50                   	push   %eax
  8015da:	ff 75 0c             	pushl  0xc(%ebp)
  8015dd:	ff 75 08             	pushl  0x8(%ebp)
  8015e0:	e8 92 03 00 00       	call   801977 <sys_createSharedObject>
  8015e5:	83 c4 10             	add    $0x10,%esp
  8015e8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  8015eb:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  8015ef:	74 05                	je     8015f6 <smalloc+0x95>
			return (void*)virtual_address;
  8015f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015f4:	eb 05                	jmp    8015fb <smalloc+0x9a>
	}
	return NULL;
  8015f6:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8015fb:	c9                   	leave  
  8015fc:	c3                   	ret    

008015fd <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8015fd:	55                   	push   %ebp
  8015fe:	89 e5                	mov    %esp,%ebp
  801600:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801603:	e8 c6 fc ff ff       	call   8012ce <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801608:	83 ec 04             	sub    $0x4,%esp
  80160b:	68 e8 3d 80 00       	push   $0x803de8
  801610:	68 b0 00 00 00       	push   $0xb0
  801615:	68 93 3d 80 00       	push   $0x803d93
  80161a:	e8 71 ec ff ff       	call   800290 <_panic>

0080161f <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80161f:	55                   	push   %ebp
  801620:	89 e5                	mov    %esp,%ebp
  801622:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801625:	e8 a4 fc ff ff       	call   8012ce <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80162a:	83 ec 04             	sub    $0x4,%esp
  80162d:	68 0c 3e 80 00       	push   $0x803e0c
  801632:	68 f4 00 00 00       	push   $0xf4
  801637:	68 93 3d 80 00       	push   $0x803d93
  80163c:	e8 4f ec ff ff       	call   800290 <_panic>

00801641 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801641:	55                   	push   %ebp
  801642:	89 e5                	mov    %esp,%ebp
  801644:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801647:	83 ec 04             	sub    $0x4,%esp
  80164a:	68 34 3e 80 00       	push   $0x803e34
  80164f:	68 08 01 00 00       	push   $0x108
  801654:	68 93 3d 80 00       	push   $0x803d93
  801659:	e8 32 ec ff ff       	call   800290 <_panic>

0080165e <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80165e:	55                   	push   %ebp
  80165f:	89 e5                	mov    %esp,%ebp
  801661:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801664:	83 ec 04             	sub    $0x4,%esp
  801667:	68 58 3e 80 00       	push   $0x803e58
  80166c:	68 13 01 00 00       	push   $0x113
  801671:	68 93 3d 80 00       	push   $0x803d93
  801676:	e8 15 ec ff ff       	call   800290 <_panic>

0080167b <shrink>:

}
void shrink(uint32 newSize)
{
  80167b:	55                   	push   %ebp
  80167c:	89 e5                	mov    %esp,%ebp
  80167e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801681:	83 ec 04             	sub    $0x4,%esp
  801684:	68 58 3e 80 00       	push   $0x803e58
  801689:	68 18 01 00 00       	push   $0x118
  80168e:	68 93 3d 80 00       	push   $0x803d93
  801693:	e8 f8 eb ff ff       	call   800290 <_panic>

00801698 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801698:	55                   	push   %ebp
  801699:	89 e5                	mov    %esp,%ebp
  80169b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80169e:	83 ec 04             	sub    $0x4,%esp
  8016a1:	68 58 3e 80 00       	push   $0x803e58
  8016a6:	68 1d 01 00 00       	push   $0x11d
  8016ab:	68 93 3d 80 00       	push   $0x803d93
  8016b0:	e8 db eb ff ff       	call   800290 <_panic>

008016b5 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8016b5:	55                   	push   %ebp
  8016b6:	89 e5                	mov    %esp,%ebp
  8016b8:	57                   	push   %edi
  8016b9:	56                   	push   %esi
  8016ba:	53                   	push   %ebx
  8016bb:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016be:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016c4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016c7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016ca:	8b 7d 18             	mov    0x18(%ebp),%edi
  8016cd:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8016d0:	cd 30                	int    $0x30
  8016d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8016d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8016d8:	83 c4 10             	add    $0x10,%esp
  8016db:	5b                   	pop    %ebx
  8016dc:	5e                   	pop    %esi
  8016dd:	5f                   	pop    %edi
  8016de:	5d                   	pop    %ebp
  8016df:	c3                   	ret    

008016e0 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8016e0:	55                   	push   %ebp
  8016e1:	89 e5                	mov    %esp,%ebp
  8016e3:	83 ec 04             	sub    $0x4,%esp
  8016e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8016e9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8016ec:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8016f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f3:	6a 00                	push   $0x0
  8016f5:	6a 00                	push   $0x0
  8016f7:	52                   	push   %edx
  8016f8:	ff 75 0c             	pushl  0xc(%ebp)
  8016fb:	50                   	push   %eax
  8016fc:	6a 00                	push   $0x0
  8016fe:	e8 b2 ff ff ff       	call   8016b5 <syscall>
  801703:	83 c4 18             	add    $0x18,%esp
}
  801706:	90                   	nop
  801707:	c9                   	leave  
  801708:	c3                   	ret    

00801709 <sys_cgetc>:

int
sys_cgetc(void)
{
  801709:	55                   	push   %ebp
  80170a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80170c:	6a 00                	push   $0x0
  80170e:	6a 00                	push   $0x0
  801710:	6a 00                	push   $0x0
  801712:	6a 00                	push   $0x0
  801714:	6a 00                	push   $0x0
  801716:	6a 01                	push   $0x1
  801718:	e8 98 ff ff ff       	call   8016b5 <syscall>
  80171d:	83 c4 18             	add    $0x18,%esp
}
  801720:	c9                   	leave  
  801721:	c3                   	ret    

00801722 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801722:	55                   	push   %ebp
  801723:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801725:	8b 55 0c             	mov    0xc(%ebp),%edx
  801728:	8b 45 08             	mov    0x8(%ebp),%eax
  80172b:	6a 00                	push   $0x0
  80172d:	6a 00                	push   $0x0
  80172f:	6a 00                	push   $0x0
  801731:	52                   	push   %edx
  801732:	50                   	push   %eax
  801733:	6a 05                	push   $0x5
  801735:	e8 7b ff ff ff       	call   8016b5 <syscall>
  80173a:	83 c4 18             	add    $0x18,%esp
}
  80173d:	c9                   	leave  
  80173e:	c3                   	ret    

0080173f <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80173f:	55                   	push   %ebp
  801740:	89 e5                	mov    %esp,%ebp
  801742:	56                   	push   %esi
  801743:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801744:	8b 75 18             	mov    0x18(%ebp),%esi
  801747:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80174a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80174d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801750:	8b 45 08             	mov    0x8(%ebp),%eax
  801753:	56                   	push   %esi
  801754:	53                   	push   %ebx
  801755:	51                   	push   %ecx
  801756:	52                   	push   %edx
  801757:	50                   	push   %eax
  801758:	6a 06                	push   $0x6
  80175a:	e8 56 ff ff ff       	call   8016b5 <syscall>
  80175f:	83 c4 18             	add    $0x18,%esp
}
  801762:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801765:	5b                   	pop    %ebx
  801766:	5e                   	pop    %esi
  801767:	5d                   	pop    %ebp
  801768:	c3                   	ret    

00801769 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801769:	55                   	push   %ebp
  80176a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80176c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80176f:	8b 45 08             	mov    0x8(%ebp),%eax
  801772:	6a 00                	push   $0x0
  801774:	6a 00                	push   $0x0
  801776:	6a 00                	push   $0x0
  801778:	52                   	push   %edx
  801779:	50                   	push   %eax
  80177a:	6a 07                	push   $0x7
  80177c:	e8 34 ff ff ff       	call   8016b5 <syscall>
  801781:	83 c4 18             	add    $0x18,%esp
}
  801784:	c9                   	leave  
  801785:	c3                   	ret    

00801786 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801786:	55                   	push   %ebp
  801787:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801789:	6a 00                	push   $0x0
  80178b:	6a 00                	push   $0x0
  80178d:	6a 00                	push   $0x0
  80178f:	ff 75 0c             	pushl  0xc(%ebp)
  801792:	ff 75 08             	pushl  0x8(%ebp)
  801795:	6a 08                	push   $0x8
  801797:	e8 19 ff ff ff       	call   8016b5 <syscall>
  80179c:	83 c4 18             	add    $0x18,%esp
}
  80179f:	c9                   	leave  
  8017a0:	c3                   	ret    

008017a1 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8017a1:	55                   	push   %ebp
  8017a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8017a4:	6a 00                	push   $0x0
  8017a6:	6a 00                	push   $0x0
  8017a8:	6a 00                	push   $0x0
  8017aa:	6a 00                	push   $0x0
  8017ac:	6a 00                	push   $0x0
  8017ae:	6a 09                	push   $0x9
  8017b0:	e8 00 ff ff ff       	call   8016b5 <syscall>
  8017b5:	83 c4 18             	add    $0x18,%esp
}
  8017b8:	c9                   	leave  
  8017b9:	c3                   	ret    

008017ba <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8017ba:	55                   	push   %ebp
  8017bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8017bd:	6a 00                	push   $0x0
  8017bf:	6a 00                	push   $0x0
  8017c1:	6a 00                	push   $0x0
  8017c3:	6a 00                	push   $0x0
  8017c5:	6a 00                	push   $0x0
  8017c7:	6a 0a                	push   $0xa
  8017c9:	e8 e7 fe ff ff       	call   8016b5 <syscall>
  8017ce:	83 c4 18             	add    $0x18,%esp
}
  8017d1:	c9                   	leave  
  8017d2:	c3                   	ret    

008017d3 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8017d3:	55                   	push   %ebp
  8017d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8017d6:	6a 00                	push   $0x0
  8017d8:	6a 00                	push   $0x0
  8017da:	6a 00                	push   $0x0
  8017dc:	6a 00                	push   $0x0
  8017de:	6a 00                	push   $0x0
  8017e0:	6a 0b                	push   $0xb
  8017e2:	e8 ce fe ff ff       	call   8016b5 <syscall>
  8017e7:	83 c4 18             	add    $0x18,%esp
}
  8017ea:	c9                   	leave  
  8017eb:	c3                   	ret    

008017ec <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8017ec:	55                   	push   %ebp
  8017ed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8017ef:	6a 00                	push   $0x0
  8017f1:	6a 00                	push   $0x0
  8017f3:	6a 00                	push   $0x0
  8017f5:	ff 75 0c             	pushl  0xc(%ebp)
  8017f8:	ff 75 08             	pushl  0x8(%ebp)
  8017fb:	6a 0f                	push   $0xf
  8017fd:	e8 b3 fe ff ff       	call   8016b5 <syscall>
  801802:	83 c4 18             	add    $0x18,%esp
	return;
  801805:	90                   	nop
}
  801806:	c9                   	leave  
  801807:	c3                   	ret    

00801808 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801808:	55                   	push   %ebp
  801809:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80180b:	6a 00                	push   $0x0
  80180d:	6a 00                	push   $0x0
  80180f:	6a 00                	push   $0x0
  801811:	ff 75 0c             	pushl  0xc(%ebp)
  801814:	ff 75 08             	pushl  0x8(%ebp)
  801817:	6a 10                	push   $0x10
  801819:	e8 97 fe ff ff       	call   8016b5 <syscall>
  80181e:	83 c4 18             	add    $0x18,%esp
	return ;
  801821:	90                   	nop
}
  801822:	c9                   	leave  
  801823:	c3                   	ret    

00801824 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801824:	55                   	push   %ebp
  801825:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801827:	6a 00                	push   $0x0
  801829:	6a 00                	push   $0x0
  80182b:	ff 75 10             	pushl  0x10(%ebp)
  80182e:	ff 75 0c             	pushl  0xc(%ebp)
  801831:	ff 75 08             	pushl  0x8(%ebp)
  801834:	6a 11                	push   $0x11
  801836:	e8 7a fe ff ff       	call   8016b5 <syscall>
  80183b:	83 c4 18             	add    $0x18,%esp
	return ;
  80183e:	90                   	nop
}
  80183f:	c9                   	leave  
  801840:	c3                   	ret    

00801841 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801841:	55                   	push   %ebp
  801842:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801844:	6a 00                	push   $0x0
  801846:	6a 00                	push   $0x0
  801848:	6a 00                	push   $0x0
  80184a:	6a 00                	push   $0x0
  80184c:	6a 00                	push   $0x0
  80184e:	6a 0c                	push   $0xc
  801850:	e8 60 fe ff ff       	call   8016b5 <syscall>
  801855:	83 c4 18             	add    $0x18,%esp
}
  801858:	c9                   	leave  
  801859:	c3                   	ret    

0080185a <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80185a:	55                   	push   %ebp
  80185b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80185d:	6a 00                	push   $0x0
  80185f:	6a 00                	push   $0x0
  801861:	6a 00                	push   $0x0
  801863:	6a 00                	push   $0x0
  801865:	ff 75 08             	pushl  0x8(%ebp)
  801868:	6a 0d                	push   $0xd
  80186a:	e8 46 fe ff ff       	call   8016b5 <syscall>
  80186f:	83 c4 18             	add    $0x18,%esp
}
  801872:	c9                   	leave  
  801873:	c3                   	ret    

00801874 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801874:	55                   	push   %ebp
  801875:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801877:	6a 00                	push   $0x0
  801879:	6a 00                	push   $0x0
  80187b:	6a 00                	push   $0x0
  80187d:	6a 00                	push   $0x0
  80187f:	6a 00                	push   $0x0
  801881:	6a 0e                	push   $0xe
  801883:	e8 2d fe ff ff       	call   8016b5 <syscall>
  801888:	83 c4 18             	add    $0x18,%esp
}
  80188b:	90                   	nop
  80188c:	c9                   	leave  
  80188d:	c3                   	ret    

0080188e <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80188e:	55                   	push   %ebp
  80188f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801891:	6a 00                	push   $0x0
  801893:	6a 00                	push   $0x0
  801895:	6a 00                	push   $0x0
  801897:	6a 00                	push   $0x0
  801899:	6a 00                	push   $0x0
  80189b:	6a 13                	push   $0x13
  80189d:	e8 13 fe ff ff       	call   8016b5 <syscall>
  8018a2:	83 c4 18             	add    $0x18,%esp
}
  8018a5:	90                   	nop
  8018a6:	c9                   	leave  
  8018a7:	c3                   	ret    

008018a8 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8018a8:	55                   	push   %ebp
  8018a9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8018ab:	6a 00                	push   $0x0
  8018ad:	6a 00                	push   $0x0
  8018af:	6a 00                	push   $0x0
  8018b1:	6a 00                	push   $0x0
  8018b3:	6a 00                	push   $0x0
  8018b5:	6a 14                	push   $0x14
  8018b7:	e8 f9 fd ff ff       	call   8016b5 <syscall>
  8018bc:	83 c4 18             	add    $0x18,%esp
}
  8018bf:	90                   	nop
  8018c0:	c9                   	leave  
  8018c1:	c3                   	ret    

008018c2 <sys_cputc>:


void
sys_cputc(const char c)
{
  8018c2:	55                   	push   %ebp
  8018c3:	89 e5                	mov    %esp,%ebp
  8018c5:	83 ec 04             	sub    $0x4,%esp
  8018c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8018ce:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8018d2:	6a 00                	push   $0x0
  8018d4:	6a 00                	push   $0x0
  8018d6:	6a 00                	push   $0x0
  8018d8:	6a 00                	push   $0x0
  8018da:	50                   	push   %eax
  8018db:	6a 15                	push   $0x15
  8018dd:	e8 d3 fd ff ff       	call   8016b5 <syscall>
  8018e2:	83 c4 18             	add    $0x18,%esp
}
  8018e5:	90                   	nop
  8018e6:	c9                   	leave  
  8018e7:	c3                   	ret    

008018e8 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8018e8:	55                   	push   %ebp
  8018e9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8018eb:	6a 00                	push   $0x0
  8018ed:	6a 00                	push   $0x0
  8018ef:	6a 00                	push   $0x0
  8018f1:	6a 00                	push   $0x0
  8018f3:	6a 00                	push   $0x0
  8018f5:	6a 16                	push   $0x16
  8018f7:	e8 b9 fd ff ff       	call   8016b5 <syscall>
  8018fc:	83 c4 18             	add    $0x18,%esp
}
  8018ff:	90                   	nop
  801900:	c9                   	leave  
  801901:	c3                   	ret    

00801902 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801902:	55                   	push   %ebp
  801903:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801905:	8b 45 08             	mov    0x8(%ebp),%eax
  801908:	6a 00                	push   $0x0
  80190a:	6a 00                	push   $0x0
  80190c:	6a 00                	push   $0x0
  80190e:	ff 75 0c             	pushl  0xc(%ebp)
  801911:	50                   	push   %eax
  801912:	6a 17                	push   $0x17
  801914:	e8 9c fd ff ff       	call   8016b5 <syscall>
  801919:	83 c4 18             	add    $0x18,%esp
}
  80191c:	c9                   	leave  
  80191d:	c3                   	ret    

0080191e <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80191e:	55                   	push   %ebp
  80191f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801921:	8b 55 0c             	mov    0xc(%ebp),%edx
  801924:	8b 45 08             	mov    0x8(%ebp),%eax
  801927:	6a 00                	push   $0x0
  801929:	6a 00                	push   $0x0
  80192b:	6a 00                	push   $0x0
  80192d:	52                   	push   %edx
  80192e:	50                   	push   %eax
  80192f:	6a 1a                	push   $0x1a
  801931:	e8 7f fd ff ff       	call   8016b5 <syscall>
  801936:	83 c4 18             	add    $0x18,%esp
}
  801939:	c9                   	leave  
  80193a:	c3                   	ret    

0080193b <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80193b:	55                   	push   %ebp
  80193c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80193e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801941:	8b 45 08             	mov    0x8(%ebp),%eax
  801944:	6a 00                	push   $0x0
  801946:	6a 00                	push   $0x0
  801948:	6a 00                	push   $0x0
  80194a:	52                   	push   %edx
  80194b:	50                   	push   %eax
  80194c:	6a 18                	push   $0x18
  80194e:	e8 62 fd ff ff       	call   8016b5 <syscall>
  801953:	83 c4 18             	add    $0x18,%esp
}
  801956:	90                   	nop
  801957:	c9                   	leave  
  801958:	c3                   	ret    

00801959 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801959:	55                   	push   %ebp
  80195a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80195c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80195f:	8b 45 08             	mov    0x8(%ebp),%eax
  801962:	6a 00                	push   $0x0
  801964:	6a 00                	push   $0x0
  801966:	6a 00                	push   $0x0
  801968:	52                   	push   %edx
  801969:	50                   	push   %eax
  80196a:	6a 19                	push   $0x19
  80196c:	e8 44 fd ff ff       	call   8016b5 <syscall>
  801971:	83 c4 18             	add    $0x18,%esp
}
  801974:	90                   	nop
  801975:	c9                   	leave  
  801976:	c3                   	ret    

00801977 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801977:	55                   	push   %ebp
  801978:	89 e5                	mov    %esp,%ebp
  80197a:	83 ec 04             	sub    $0x4,%esp
  80197d:	8b 45 10             	mov    0x10(%ebp),%eax
  801980:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801983:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801986:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80198a:	8b 45 08             	mov    0x8(%ebp),%eax
  80198d:	6a 00                	push   $0x0
  80198f:	51                   	push   %ecx
  801990:	52                   	push   %edx
  801991:	ff 75 0c             	pushl  0xc(%ebp)
  801994:	50                   	push   %eax
  801995:	6a 1b                	push   $0x1b
  801997:	e8 19 fd ff ff       	call   8016b5 <syscall>
  80199c:	83 c4 18             	add    $0x18,%esp
}
  80199f:	c9                   	leave  
  8019a0:	c3                   	ret    

008019a1 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8019a1:	55                   	push   %ebp
  8019a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8019a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019aa:	6a 00                	push   $0x0
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 00                	push   $0x0
  8019b0:	52                   	push   %edx
  8019b1:	50                   	push   %eax
  8019b2:	6a 1c                	push   $0x1c
  8019b4:	e8 fc fc ff ff       	call   8016b5 <syscall>
  8019b9:	83 c4 18             	add    $0x18,%esp
}
  8019bc:	c9                   	leave  
  8019bd:	c3                   	ret    

008019be <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8019be:	55                   	push   %ebp
  8019bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8019c1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	51                   	push   %ecx
  8019cf:	52                   	push   %edx
  8019d0:	50                   	push   %eax
  8019d1:	6a 1d                	push   $0x1d
  8019d3:	e8 dd fc ff ff       	call   8016b5 <syscall>
  8019d8:	83 c4 18             	add    $0x18,%esp
}
  8019db:	c9                   	leave  
  8019dc:	c3                   	ret    

008019dd <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8019dd:	55                   	push   %ebp
  8019de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8019e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 00                	push   $0x0
  8019ec:	52                   	push   %edx
  8019ed:	50                   	push   %eax
  8019ee:	6a 1e                	push   $0x1e
  8019f0:	e8 c0 fc ff ff       	call   8016b5 <syscall>
  8019f5:	83 c4 18             	add    $0x18,%esp
}
  8019f8:	c9                   	leave  
  8019f9:	c3                   	ret    

008019fa <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8019fa:	55                   	push   %ebp
  8019fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 00                	push   $0x0
  801a01:	6a 00                	push   $0x0
  801a03:	6a 00                	push   $0x0
  801a05:	6a 00                	push   $0x0
  801a07:	6a 1f                	push   $0x1f
  801a09:	e8 a7 fc ff ff       	call   8016b5 <syscall>
  801a0e:	83 c4 18             	add    $0x18,%esp
}
  801a11:	c9                   	leave  
  801a12:	c3                   	ret    

00801a13 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a13:	55                   	push   %ebp
  801a14:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a16:	8b 45 08             	mov    0x8(%ebp),%eax
  801a19:	6a 00                	push   $0x0
  801a1b:	ff 75 14             	pushl  0x14(%ebp)
  801a1e:	ff 75 10             	pushl  0x10(%ebp)
  801a21:	ff 75 0c             	pushl  0xc(%ebp)
  801a24:	50                   	push   %eax
  801a25:	6a 20                	push   $0x20
  801a27:	e8 89 fc ff ff       	call   8016b5 <syscall>
  801a2c:	83 c4 18             	add    $0x18,%esp
}
  801a2f:	c9                   	leave  
  801a30:	c3                   	ret    

00801a31 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801a31:	55                   	push   %ebp
  801a32:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a34:	8b 45 08             	mov    0x8(%ebp),%eax
  801a37:	6a 00                	push   $0x0
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 00                	push   $0x0
  801a3f:	50                   	push   %eax
  801a40:	6a 21                	push   $0x21
  801a42:	e8 6e fc ff ff       	call   8016b5 <syscall>
  801a47:	83 c4 18             	add    $0x18,%esp
}
  801a4a:	90                   	nop
  801a4b:	c9                   	leave  
  801a4c:	c3                   	ret    

00801a4d <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801a4d:	55                   	push   %ebp
  801a4e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801a50:	8b 45 08             	mov    0x8(%ebp),%eax
  801a53:	6a 00                	push   $0x0
  801a55:	6a 00                	push   $0x0
  801a57:	6a 00                	push   $0x0
  801a59:	6a 00                	push   $0x0
  801a5b:	50                   	push   %eax
  801a5c:	6a 22                	push   $0x22
  801a5e:	e8 52 fc ff ff       	call   8016b5 <syscall>
  801a63:	83 c4 18             	add    $0x18,%esp
}
  801a66:	c9                   	leave  
  801a67:	c3                   	ret    

00801a68 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801a68:	55                   	push   %ebp
  801a69:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801a6b:	6a 00                	push   $0x0
  801a6d:	6a 00                	push   $0x0
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 00                	push   $0x0
  801a73:	6a 00                	push   $0x0
  801a75:	6a 02                	push   $0x2
  801a77:	e8 39 fc ff ff       	call   8016b5 <syscall>
  801a7c:	83 c4 18             	add    $0x18,%esp
}
  801a7f:	c9                   	leave  
  801a80:	c3                   	ret    

00801a81 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801a81:	55                   	push   %ebp
  801a82:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801a84:	6a 00                	push   $0x0
  801a86:	6a 00                	push   $0x0
  801a88:	6a 00                	push   $0x0
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 03                	push   $0x3
  801a90:	e8 20 fc ff ff       	call   8016b5 <syscall>
  801a95:	83 c4 18             	add    $0x18,%esp
}
  801a98:	c9                   	leave  
  801a99:	c3                   	ret    

00801a9a <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801a9a:	55                   	push   %ebp
  801a9b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 00                	push   $0x0
  801aa3:	6a 00                	push   $0x0
  801aa5:	6a 00                	push   $0x0
  801aa7:	6a 04                	push   $0x4
  801aa9:	e8 07 fc ff ff       	call   8016b5 <syscall>
  801aae:	83 c4 18             	add    $0x18,%esp
}
  801ab1:	c9                   	leave  
  801ab2:	c3                   	ret    

00801ab3 <sys_exit_env>:


void sys_exit_env(void)
{
  801ab3:	55                   	push   %ebp
  801ab4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	6a 00                	push   $0x0
  801abe:	6a 00                	push   $0x0
  801ac0:	6a 23                	push   $0x23
  801ac2:	e8 ee fb ff ff       	call   8016b5 <syscall>
  801ac7:	83 c4 18             	add    $0x18,%esp
}
  801aca:	90                   	nop
  801acb:	c9                   	leave  
  801acc:	c3                   	ret    

00801acd <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801acd:	55                   	push   %ebp
  801ace:	89 e5                	mov    %esp,%ebp
  801ad0:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801ad3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ad6:	8d 50 04             	lea    0x4(%eax),%edx
  801ad9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 00                	push   $0x0
  801ae2:	52                   	push   %edx
  801ae3:	50                   	push   %eax
  801ae4:	6a 24                	push   $0x24
  801ae6:	e8 ca fb ff ff       	call   8016b5 <syscall>
  801aeb:	83 c4 18             	add    $0x18,%esp
	return result;
  801aee:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801af1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801af4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801af7:	89 01                	mov    %eax,(%ecx)
  801af9:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801afc:	8b 45 08             	mov    0x8(%ebp),%eax
  801aff:	c9                   	leave  
  801b00:	c2 04 00             	ret    $0x4

00801b03 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b03:	55                   	push   %ebp
  801b04:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b06:	6a 00                	push   $0x0
  801b08:	6a 00                	push   $0x0
  801b0a:	ff 75 10             	pushl  0x10(%ebp)
  801b0d:	ff 75 0c             	pushl  0xc(%ebp)
  801b10:	ff 75 08             	pushl  0x8(%ebp)
  801b13:	6a 12                	push   $0x12
  801b15:	e8 9b fb ff ff       	call   8016b5 <syscall>
  801b1a:	83 c4 18             	add    $0x18,%esp
	return ;
  801b1d:	90                   	nop
}
  801b1e:	c9                   	leave  
  801b1f:	c3                   	ret    

00801b20 <sys_rcr2>:
uint32 sys_rcr2()
{
  801b20:	55                   	push   %ebp
  801b21:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 25                	push   $0x25
  801b2f:	e8 81 fb ff ff       	call   8016b5 <syscall>
  801b34:	83 c4 18             	add    $0x18,%esp
}
  801b37:	c9                   	leave  
  801b38:	c3                   	ret    

00801b39 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801b39:	55                   	push   %ebp
  801b3a:	89 e5                	mov    %esp,%ebp
  801b3c:	83 ec 04             	sub    $0x4,%esp
  801b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b42:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801b45:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 00                	push   $0x0
  801b4f:	6a 00                	push   $0x0
  801b51:	50                   	push   %eax
  801b52:	6a 26                	push   $0x26
  801b54:	e8 5c fb ff ff       	call   8016b5 <syscall>
  801b59:	83 c4 18             	add    $0x18,%esp
	return ;
  801b5c:	90                   	nop
}
  801b5d:	c9                   	leave  
  801b5e:	c3                   	ret    

00801b5f <rsttst>:
void rsttst()
{
  801b5f:	55                   	push   %ebp
  801b60:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801b62:	6a 00                	push   $0x0
  801b64:	6a 00                	push   $0x0
  801b66:	6a 00                	push   $0x0
  801b68:	6a 00                	push   $0x0
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 28                	push   $0x28
  801b6e:	e8 42 fb ff ff       	call   8016b5 <syscall>
  801b73:	83 c4 18             	add    $0x18,%esp
	return ;
  801b76:	90                   	nop
}
  801b77:	c9                   	leave  
  801b78:	c3                   	ret    

00801b79 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801b79:	55                   	push   %ebp
  801b7a:	89 e5                	mov    %esp,%ebp
  801b7c:	83 ec 04             	sub    $0x4,%esp
  801b7f:	8b 45 14             	mov    0x14(%ebp),%eax
  801b82:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801b85:	8b 55 18             	mov    0x18(%ebp),%edx
  801b88:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b8c:	52                   	push   %edx
  801b8d:	50                   	push   %eax
  801b8e:	ff 75 10             	pushl  0x10(%ebp)
  801b91:	ff 75 0c             	pushl  0xc(%ebp)
  801b94:	ff 75 08             	pushl  0x8(%ebp)
  801b97:	6a 27                	push   $0x27
  801b99:	e8 17 fb ff ff       	call   8016b5 <syscall>
  801b9e:	83 c4 18             	add    $0x18,%esp
	return ;
  801ba1:	90                   	nop
}
  801ba2:	c9                   	leave  
  801ba3:	c3                   	ret    

00801ba4 <chktst>:
void chktst(uint32 n)
{
  801ba4:	55                   	push   %ebp
  801ba5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 00                	push   $0x0
  801bad:	6a 00                	push   $0x0
  801baf:	ff 75 08             	pushl  0x8(%ebp)
  801bb2:	6a 29                	push   $0x29
  801bb4:	e8 fc fa ff ff       	call   8016b5 <syscall>
  801bb9:	83 c4 18             	add    $0x18,%esp
	return ;
  801bbc:	90                   	nop
}
  801bbd:	c9                   	leave  
  801bbe:	c3                   	ret    

00801bbf <inctst>:

void inctst()
{
  801bbf:	55                   	push   %ebp
  801bc0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801bc2:	6a 00                	push   $0x0
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 00                	push   $0x0
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 2a                	push   $0x2a
  801bce:	e8 e2 fa ff ff       	call   8016b5 <syscall>
  801bd3:	83 c4 18             	add    $0x18,%esp
	return ;
  801bd6:	90                   	nop
}
  801bd7:	c9                   	leave  
  801bd8:	c3                   	ret    

00801bd9 <gettst>:
uint32 gettst()
{
  801bd9:	55                   	push   %ebp
  801bda:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 00                	push   $0x0
  801be0:	6a 00                	push   $0x0
  801be2:	6a 00                	push   $0x0
  801be4:	6a 00                	push   $0x0
  801be6:	6a 2b                	push   $0x2b
  801be8:	e8 c8 fa ff ff       	call   8016b5 <syscall>
  801bed:	83 c4 18             	add    $0x18,%esp
}
  801bf0:	c9                   	leave  
  801bf1:	c3                   	ret    

00801bf2 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801bf2:	55                   	push   %ebp
  801bf3:	89 e5                	mov    %esp,%ebp
  801bf5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bf8:	6a 00                	push   $0x0
  801bfa:	6a 00                	push   $0x0
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	6a 2c                	push   $0x2c
  801c04:	e8 ac fa ff ff       	call   8016b5 <syscall>
  801c09:	83 c4 18             	add    $0x18,%esp
  801c0c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801c0f:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801c13:	75 07                	jne    801c1c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801c15:	b8 01 00 00 00       	mov    $0x1,%eax
  801c1a:	eb 05                	jmp    801c21 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801c1c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c21:	c9                   	leave  
  801c22:	c3                   	ret    

00801c23 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801c23:	55                   	push   %ebp
  801c24:	89 e5                	mov    %esp,%ebp
  801c26:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c29:	6a 00                	push   $0x0
  801c2b:	6a 00                	push   $0x0
  801c2d:	6a 00                	push   $0x0
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 00                	push   $0x0
  801c33:	6a 2c                	push   $0x2c
  801c35:	e8 7b fa ff ff       	call   8016b5 <syscall>
  801c3a:	83 c4 18             	add    $0x18,%esp
  801c3d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801c40:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801c44:	75 07                	jne    801c4d <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801c46:	b8 01 00 00 00       	mov    $0x1,%eax
  801c4b:	eb 05                	jmp    801c52 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801c4d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c52:	c9                   	leave  
  801c53:	c3                   	ret    

00801c54 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801c54:	55                   	push   %ebp
  801c55:	89 e5                	mov    %esp,%ebp
  801c57:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 00                	push   $0x0
  801c60:	6a 00                	push   $0x0
  801c62:	6a 00                	push   $0x0
  801c64:	6a 2c                	push   $0x2c
  801c66:	e8 4a fa ff ff       	call   8016b5 <syscall>
  801c6b:	83 c4 18             	add    $0x18,%esp
  801c6e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801c71:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801c75:	75 07                	jne    801c7e <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801c77:	b8 01 00 00 00       	mov    $0x1,%eax
  801c7c:	eb 05                	jmp    801c83 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801c7e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c83:	c9                   	leave  
  801c84:	c3                   	ret    

00801c85 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801c85:	55                   	push   %ebp
  801c86:	89 e5                	mov    %esp,%ebp
  801c88:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c8b:	6a 00                	push   $0x0
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 00                	push   $0x0
  801c93:	6a 00                	push   $0x0
  801c95:	6a 2c                	push   $0x2c
  801c97:	e8 19 fa ff ff       	call   8016b5 <syscall>
  801c9c:	83 c4 18             	add    $0x18,%esp
  801c9f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801ca2:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801ca6:	75 07                	jne    801caf <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801ca8:	b8 01 00 00 00       	mov    $0x1,%eax
  801cad:	eb 05                	jmp    801cb4 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801caf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cb4:	c9                   	leave  
  801cb5:	c3                   	ret    

00801cb6 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801cb6:	55                   	push   %ebp
  801cb7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801cb9:	6a 00                	push   $0x0
  801cbb:	6a 00                	push   $0x0
  801cbd:	6a 00                	push   $0x0
  801cbf:	6a 00                	push   $0x0
  801cc1:	ff 75 08             	pushl  0x8(%ebp)
  801cc4:	6a 2d                	push   $0x2d
  801cc6:	e8 ea f9 ff ff       	call   8016b5 <syscall>
  801ccb:	83 c4 18             	add    $0x18,%esp
	return ;
  801cce:	90                   	nop
}
  801ccf:	c9                   	leave  
  801cd0:	c3                   	ret    

00801cd1 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801cd1:	55                   	push   %ebp
  801cd2:	89 e5                	mov    %esp,%ebp
  801cd4:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801cd5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cd8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cdb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cde:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce1:	6a 00                	push   $0x0
  801ce3:	53                   	push   %ebx
  801ce4:	51                   	push   %ecx
  801ce5:	52                   	push   %edx
  801ce6:	50                   	push   %eax
  801ce7:	6a 2e                	push   $0x2e
  801ce9:	e8 c7 f9 ff ff       	call   8016b5 <syscall>
  801cee:	83 c4 18             	add    $0x18,%esp
}
  801cf1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cf4:	c9                   	leave  
  801cf5:	c3                   	ret    

00801cf6 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801cf6:	55                   	push   %ebp
  801cf7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801cf9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  801cff:	6a 00                	push   $0x0
  801d01:	6a 00                	push   $0x0
  801d03:	6a 00                	push   $0x0
  801d05:	52                   	push   %edx
  801d06:	50                   	push   %eax
  801d07:	6a 2f                	push   $0x2f
  801d09:	e8 a7 f9 ff ff       	call   8016b5 <syscall>
  801d0e:	83 c4 18             	add    $0x18,%esp
}
  801d11:	c9                   	leave  
  801d12:	c3                   	ret    

00801d13 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801d13:	55                   	push   %ebp
  801d14:	89 e5                	mov    %esp,%ebp
  801d16:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801d19:	83 ec 0c             	sub    $0xc,%esp
  801d1c:	68 68 3e 80 00       	push   $0x803e68
  801d21:	e8 1e e8 ff ff       	call   800544 <cprintf>
  801d26:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801d29:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801d30:	83 ec 0c             	sub    $0xc,%esp
  801d33:	68 94 3e 80 00       	push   $0x803e94
  801d38:	e8 07 e8 ff ff       	call   800544 <cprintf>
  801d3d:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801d40:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d44:	a1 38 51 80 00       	mov    0x805138,%eax
  801d49:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d4c:	eb 56                	jmp    801da4 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801d4e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d52:	74 1c                	je     801d70 <print_mem_block_lists+0x5d>
  801d54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d57:	8b 50 08             	mov    0x8(%eax),%edx
  801d5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d5d:	8b 48 08             	mov    0x8(%eax),%ecx
  801d60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d63:	8b 40 0c             	mov    0xc(%eax),%eax
  801d66:	01 c8                	add    %ecx,%eax
  801d68:	39 c2                	cmp    %eax,%edx
  801d6a:	73 04                	jae    801d70 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801d6c:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801d70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d73:	8b 50 08             	mov    0x8(%eax),%edx
  801d76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d79:	8b 40 0c             	mov    0xc(%eax),%eax
  801d7c:	01 c2                	add    %eax,%edx
  801d7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d81:	8b 40 08             	mov    0x8(%eax),%eax
  801d84:	83 ec 04             	sub    $0x4,%esp
  801d87:	52                   	push   %edx
  801d88:	50                   	push   %eax
  801d89:	68 a9 3e 80 00       	push   $0x803ea9
  801d8e:	e8 b1 e7 ff ff       	call   800544 <cprintf>
  801d93:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801d96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d99:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d9c:	a1 40 51 80 00       	mov    0x805140,%eax
  801da1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801da4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801da8:	74 07                	je     801db1 <print_mem_block_lists+0x9e>
  801daa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dad:	8b 00                	mov    (%eax),%eax
  801daf:	eb 05                	jmp    801db6 <print_mem_block_lists+0xa3>
  801db1:	b8 00 00 00 00       	mov    $0x0,%eax
  801db6:	a3 40 51 80 00       	mov    %eax,0x805140
  801dbb:	a1 40 51 80 00       	mov    0x805140,%eax
  801dc0:	85 c0                	test   %eax,%eax
  801dc2:	75 8a                	jne    801d4e <print_mem_block_lists+0x3b>
  801dc4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801dc8:	75 84                	jne    801d4e <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801dca:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801dce:	75 10                	jne    801de0 <print_mem_block_lists+0xcd>
  801dd0:	83 ec 0c             	sub    $0xc,%esp
  801dd3:	68 b8 3e 80 00       	push   $0x803eb8
  801dd8:	e8 67 e7 ff ff       	call   800544 <cprintf>
  801ddd:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801de0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801de7:	83 ec 0c             	sub    $0xc,%esp
  801dea:	68 dc 3e 80 00       	push   $0x803edc
  801def:	e8 50 e7 ff ff       	call   800544 <cprintf>
  801df4:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801df7:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801dfb:	a1 40 50 80 00       	mov    0x805040,%eax
  801e00:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e03:	eb 56                	jmp    801e5b <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e05:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e09:	74 1c                	je     801e27 <print_mem_block_lists+0x114>
  801e0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e0e:	8b 50 08             	mov    0x8(%eax),%edx
  801e11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e14:	8b 48 08             	mov    0x8(%eax),%ecx
  801e17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e1a:	8b 40 0c             	mov    0xc(%eax),%eax
  801e1d:	01 c8                	add    %ecx,%eax
  801e1f:	39 c2                	cmp    %eax,%edx
  801e21:	73 04                	jae    801e27 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801e23:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e2a:	8b 50 08             	mov    0x8(%eax),%edx
  801e2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e30:	8b 40 0c             	mov    0xc(%eax),%eax
  801e33:	01 c2                	add    %eax,%edx
  801e35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e38:	8b 40 08             	mov    0x8(%eax),%eax
  801e3b:	83 ec 04             	sub    $0x4,%esp
  801e3e:	52                   	push   %edx
  801e3f:	50                   	push   %eax
  801e40:	68 a9 3e 80 00       	push   $0x803ea9
  801e45:	e8 fa e6 ff ff       	call   800544 <cprintf>
  801e4a:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e50:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801e53:	a1 48 50 80 00       	mov    0x805048,%eax
  801e58:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e5b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e5f:	74 07                	je     801e68 <print_mem_block_lists+0x155>
  801e61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e64:	8b 00                	mov    (%eax),%eax
  801e66:	eb 05                	jmp    801e6d <print_mem_block_lists+0x15a>
  801e68:	b8 00 00 00 00       	mov    $0x0,%eax
  801e6d:	a3 48 50 80 00       	mov    %eax,0x805048
  801e72:	a1 48 50 80 00       	mov    0x805048,%eax
  801e77:	85 c0                	test   %eax,%eax
  801e79:	75 8a                	jne    801e05 <print_mem_block_lists+0xf2>
  801e7b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e7f:	75 84                	jne    801e05 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801e81:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e85:	75 10                	jne    801e97 <print_mem_block_lists+0x184>
  801e87:	83 ec 0c             	sub    $0xc,%esp
  801e8a:	68 f4 3e 80 00       	push   $0x803ef4
  801e8f:	e8 b0 e6 ff ff       	call   800544 <cprintf>
  801e94:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801e97:	83 ec 0c             	sub    $0xc,%esp
  801e9a:	68 68 3e 80 00       	push   $0x803e68
  801e9f:	e8 a0 e6 ff ff       	call   800544 <cprintf>
  801ea4:	83 c4 10             	add    $0x10,%esp

}
  801ea7:	90                   	nop
  801ea8:	c9                   	leave  
  801ea9:	c3                   	ret    

00801eaa <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801eaa:	55                   	push   %ebp
  801eab:	89 e5                	mov    %esp,%ebp
  801ead:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801eb0:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  801eb7:	00 00 00 
  801eba:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  801ec1:	00 00 00 
  801ec4:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  801ecb:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801ece:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801ed5:	e9 9e 00 00 00       	jmp    801f78 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801eda:	a1 50 50 80 00       	mov    0x805050,%eax
  801edf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ee2:	c1 e2 04             	shl    $0x4,%edx
  801ee5:	01 d0                	add    %edx,%eax
  801ee7:	85 c0                	test   %eax,%eax
  801ee9:	75 14                	jne    801eff <initialize_MemBlocksList+0x55>
  801eeb:	83 ec 04             	sub    $0x4,%esp
  801eee:	68 1c 3f 80 00       	push   $0x803f1c
  801ef3:	6a 46                	push   $0x46
  801ef5:	68 3f 3f 80 00       	push   $0x803f3f
  801efa:	e8 91 e3 ff ff       	call   800290 <_panic>
  801eff:	a1 50 50 80 00       	mov    0x805050,%eax
  801f04:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f07:	c1 e2 04             	shl    $0x4,%edx
  801f0a:	01 d0                	add    %edx,%eax
  801f0c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  801f12:	89 10                	mov    %edx,(%eax)
  801f14:	8b 00                	mov    (%eax),%eax
  801f16:	85 c0                	test   %eax,%eax
  801f18:	74 18                	je     801f32 <initialize_MemBlocksList+0x88>
  801f1a:	a1 48 51 80 00       	mov    0x805148,%eax
  801f1f:	8b 15 50 50 80 00    	mov    0x805050,%edx
  801f25:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801f28:	c1 e1 04             	shl    $0x4,%ecx
  801f2b:	01 ca                	add    %ecx,%edx
  801f2d:	89 50 04             	mov    %edx,0x4(%eax)
  801f30:	eb 12                	jmp    801f44 <initialize_MemBlocksList+0x9a>
  801f32:	a1 50 50 80 00       	mov    0x805050,%eax
  801f37:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f3a:	c1 e2 04             	shl    $0x4,%edx
  801f3d:	01 d0                	add    %edx,%eax
  801f3f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801f44:	a1 50 50 80 00       	mov    0x805050,%eax
  801f49:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f4c:	c1 e2 04             	shl    $0x4,%edx
  801f4f:	01 d0                	add    %edx,%eax
  801f51:	a3 48 51 80 00       	mov    %eax,0x805148
  801f56:	a1 50 50 80 00       	mov    0x805050,%eax
  801f5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f5e:	c1 e2 04             	shl    $0x4,%edx
  801f61:	01 d0                	add    %edx,%eax
  801f63:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f6a:	a1 54 51 80 00       	mov    0x805154,%eax
  801f6f:	40                   	inc    %eax
  801f70:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801f75:	ff 45 f4             	incl   -0xc(%ebp)
  801f78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f7b:	3b 45 08             	cmp    0x8(%ebp),%eax
  801f7e:	0f 82 56 ff ff ff    	jb     801eda <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801f84:	90                   	nop
  801f85:	c9                   	leave  
  801f86:	c3                   	ret    

00801f87 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801f87:	55                   	push   %ebp
  801f88:	89 e5                	mov    %esp,%ebp
  801f8a:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801f8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f90:	8b 00                	mov    (%eax),%eax
  801f92:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f95:	eb 19                	jmp    801fb0 <find_block+0x29>
	{
		if(va==point->sva)
  801f97:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f9a:	8b 40 08             	mov    0x8(%eax),%eax
  801f9d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801fa0:	75 05                	jne    801fa7 <find_block+0x20>
		   return point;
  801fa2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fa5:	eb 36                	jmp    801fdd <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  801faa:	8b 40 08             	mov    0x8(%eax),%eax
  801fad:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801fb0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801fb4:	74 07                	je     801fbd <find_block+0x36>
  801fb6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fb9:	8b 00                	mov    (%eax),%eax
  801fbb:	eb 05                	jmp    801fc2 <find_block+0x3b>
  801fbd:	b8 00 00 00 00       	mov    $0x0,%eax
  801fc2:	8b 55 08             	mov    0x8(%ebp),%edx
  801fc5:	89 42 08             	mov    %eax,0x8(%edx)
  801fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  801fcb:	8b 40 08             	mov    0x8(%eax),%eax
  801fce:	85 c0                	test   %eax,%eax
  801fd0:	75 c5                	jne    801f97 <find_block+0x10>
  801fd2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801fd6:	75 bf                	jne    801f97 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  801fd8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fdd:	c9                   	leave  
  801fde:	c3                   	ret    

00801fdf <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  801fdf:	55                   	push   %ebp
  801fe0:	89 e5                	mov    %esp,%ebp
  801fe2:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  801fe5:	a1 40 50 80 00       	mov    0x805040,%eax
  801fea:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  801fed:	a1 44 50 80 00       	mov    0x805044,%eax
  801ff2:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  801ff5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ff8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801ffb:	74 24                	je     802021 <insert_sorted_allocList+0x42>
  801ffd:	8b 45 08             	mov    0x8(%ebp),%eax
  802000:	8b 50 08             	mov    0x8(%eax),%edx
  802003:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802006:	8b 40 08             	mov    0x8(%eax),%eax
  802009:	39 c2                	cmp    %eax,%edx
  80200b:	76 14                	jbe    802021 <insert_sorted_allocList+0x42>
  80200d:	8b 45 08             	mov    0x8(%ebp),%eax
  802010:	8b 50 08             	mov    0x8(%eax),%edx
  802013:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802016:	8b 40 08             	mov    0x8(%eax),%eax
  802019:	39 c2                	cmp    %eax,%edx
  80201b:	0f 82 60 01 00 00    	jb     802181 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802021:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802025:	75 65                	jne    80208c <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802027:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80202b:	75 14                	jne    802041 <insert_sorted_allocList+0x62>
  80202d:	83 ec 04             	sub    $0x4,%esp
  802030:	68 1c 3f 80 00       	push   $0x803f1c
  802035:	6a 6b                	push   $0x6b
  802037:	68 3f 3f 80 00       	push   $0x803f3f
  80203c:	e8 4f e2 ff ff       	call   800290 <_panic>
  802041:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802047:	8b 45 08             	mov    0x8(%ebp),%eax
  80204a:	89 10                	mov    %edx,(%eax)
  80204c:	8b 45 08             	mov    0x8(%ebp),%eax
  80204f:	8b 00                	mov    (%eax),%eax
  802051:	85 c0                	test   %eax,%eax
  802053:	74 0d                	je     802062 <insert_sorted_allocList+0x83>
  802055:	a1 40 50 80 00       	mov    0x805040,%eax
  80205a:	8b 55 08             	mov    0x8(%ebp),%edx
  80205d:	89 50 04             	mov    %edx,0x4(%eax)
  802060:	eb 08                	jmp    80206a <insert_sorted_allocList+0x8b>
  802062:	8b 45 08             	mov    0x8(%ebp),%eax
  802065:	a3 44 50 80 00       	mov    %eax,0x805044
  80206a:	8b 45 08             	mov    0x8(%ebp),%eax
  80206d:	a3 40 50 80 00       	mov    %eax,0x805040
  802072:	8b 45 08             	mov    0x8(%ebp),%eax
  802075:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80207c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802081:	40                   	inc    %eax
  802082:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802087:	e9 dc 01 00 00       	jmp    802268 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  80208c:	8b 45 08             	mov    0x8(%ebp),%eax
  80208f:	8b 50 08             	mov    0x8(%eax),%edx
  802092:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802095:	8b 40 08             	mov    0x8(%eax),%eax
  802098:	39 c2                	cmp    %eax,%edx
  80209a:	77 6c                	ja     802108 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  80209c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020a0:	74 06                	je     8020a8 <insert_sorted_allocList+0xc9>
  8020a2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020a6:	75 14                	jne    8020bc <insert_sorted_allocList+0xdd>
  8020a8:	83 ec 04             	sub    $0x4,%esp
  8020ab:	68 58 3f 80 00       	push   $0x803f58
  8020b0:	6a 6f                	push   $0x6f
  8020b2:	68 3f 3f 80 00       	push   $0x803f3f
  8020b7:	e8 d4 e1 ff ff       	call   800290 <_panic>
  8020bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020bf:	8b 50 04             	mov    0x4(%eax),%edx
  8020c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c5:	89 50 04             	mov    %edx,0x4(%eax)
  8020c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8020ce:	89 10                	mov    %edx,(%eax)
  8020d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020d3:	8b 40 04             	mov    0x4(%eax),%eax
  8020d6:	85 c0                	test   %eax,%eax
  8020d8:	74 0d                	je     8020e7 <insert_sorted_allocList+0x108>
  8020da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020dd:	8b 40 04             	mov    0x4(%eax),%eax
  8020e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8020e3:	89 10                	mov    %edx,(%eax)
  8020e5:	eb 08                	jmp    8020ef <insert_sorted_allocList+0x110>
  8020e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ea:	a3 40 50 80 00       	mov    %eax,0x805040
  8020ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8020f5:	89 50 04             	mov    %edx,0x4(%eax)
  8020f8:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8020fd:	40                   	inc    %eax
  8020fe:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802103:	e9 60 01 00 00       	jmp    802268 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802108:	8b 45 08             	mov    0x8(%ebp),%eax
  80210b:	8b 50 08             	mov    0x8(%eax),%edx
  80210e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802111:	8b 40 08             	mov    0x8(%eax),%eax
  802114:	39 c2                	cmp    %eax,%edx
  802116:	0f 82 4c 01 00 00    	jb     802268 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  80211c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802120:	75 14                	jne    802136 <insert_sorted_allocList+0x157>
  802122:	83 ec 04             	sub    $0x4,%esp
  802125:	68 90 3f 80 00       	push   $0x803f90
  80212a:	6a 73                	push   $0x73
  80212c:	68 3f 3f 80 00       	push   $0x803f3f
  802131:	e8 5a e1 ff ff       	call   800290 <_panic>
  802136:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80213c:	8b 45 08             	mov    0x8(%ebp),%eax
  80213f:	89 50 04             	mov    %edx,0x4(%eax)
  802142:	8b 45 08             	mov    0x8(%ebp),%eax
  802145:	8b 40 04             	mov    0x4(%eax),%eax
  802148:	85 c0                	test   %eax,%eax
  80214a:	74 0c                	je     802158 <insert_sorted_allocList+0x179>
  80214c:	a1 44 50 80 00       	mov    0x805044,%eax
  802151:	8b 55 08             	mov    0x8(%ebp),%edx
  802154:	89 10                	mov    %edx,(%eax)
  802156:	eb 08                	jmp    802160 <insert_sorted_allocList+0x181>
  802158:	8b 45 08             	mov    0x8(%ebp),%eax
  80215b:	a3 40 50 80 00       	mov    %eax,0x805040
  802160:	8b 45 08             	mov    0x8(%ebp),%eax
  802163:	a3 44 50 80 00       	mov    %eax,0x805044
  802168:	8b 45 08             	mov    0x8(%ebp),%eax
  80216b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802171:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802176:	40                   	inc    %eax
  802177:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80217c:	e9 e7 00 00 00       	jmp    802268 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802181:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802184:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802187:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80218e:	a1 40 50 80 00       	mov    0x805040,%eax
  802193:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802196:	e9 9d 00 00 00       	jmp    802238 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  80219b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219e:	8b 00                	mov    (%eax),%eax
  8021a0:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8021a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a6:	8b 50 08             	mov    0x8(%eax),%edx
  8021a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ac:	8b 40 08             	mov    0x8(%eax),%eax
  8021af:	39 c2                	cmp    %eax,%edx
  8021b1:	76 7d                	jbe    802230 <insert_sorted_allocList+0x251>
  8021b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b6:	8b 50 08             	mov    0x8(%eax),%edx
  8021b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8021bc:	8b 40 08             	mov    0x8(%eax),%eax
  8021bf:	39 c2                	cmp    %eax,%edx
  8021c1:	73 6d                	jae    802230 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8021c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021c7:	74 06                	je     8021cf <insert_sorted_allocList+0x1f0>
  8021c9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021cd:	75 14                	jne    8021e3 <insert_sorted_allocList+0x204>
  8021cf:	83 ec 04             	sub    $0x4,%esp
  8021d2:	68 b4 3f 80 00       	push   $0x803fb4
  8021d7:	6a 7f                	push   $0x7f
  8021d9:	68 3f 3f 80 00       	push   $0x803f3f
  8021de:	e8 ad e0 ff ff       	call   800290 <_panic>
  8021e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e6:	8b 10                	mov    (%eax),%edx
  8021e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021eb:	89 10                	mov    %edx,(%eax)
  8021ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f0:	8b 00                	mov    (%eax),%eax
  8021f2:	85 c0                	test   %eax,%eax
  8021f4:	74 0b                	je     802201 <insert_sorted_allocList+0x222>
  8021f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f9:	8b 00                	mov    (%eax),%eax
  8021fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8021fe:	89 50 04             	mov    %edx,0x4(%eax)
  802201:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802204:	8b 55 08             	mov    0x8(%ebp),%edx
  802207:	89 10                	mov    %edx,(%eax)
  802209:	8b 45 08             	mov    0x8(%ebp),%eax
  80220c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80220f:	89 50 04             	mov    %edx,0x4(%eax)
  802212:	8b 45 08             	mov    0x8(%ebp),%eax
  802215:	8b 00                	mov    (%eax),%eax
  802217:	85 c0                	test   %eax,%eax
  802219:	75 08                	jne    802223 <insert_sorted_allocList+0x244>
  80221b:	8b 45 08             	mov    0x8(%ebp),%eax
  80221e:	a3 44 50 80 00       	mov    %eax,0x805044
  802223:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802228:	40                   	inc    %eax
  802229:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  80222e:	eb 39                	jmp    802269 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802230:	a1 48 50 80 00       	mov    0x805048,%eax
  802235:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802238:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80223c:	74 07                	je     802245 <insert_sorted_allocList+0x266>
  80223e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802241:	8b 00                	mov    (%eax),%eax
  802243:	eb 05                	jmp    80224a <insert_sorted_allocList+0x26b>
  802245:	b8 00 00 00 00       	mov    $0x0,%eax
  80224a:	a3 48 50 80 00       	mov    %eax,0x805048
  80224f:	a1 48 50 80 00       	mov    0x805048,%eax
  802254:	85 c0                	test   %eax,%eax
  802256:	0f 85 3f ff ff ff    	jne    80219b <insert_sorted_allocList+0x1bc>
  80225c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802260:	0f 85 35 ff ff ff    	jne    80219b <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802266:	eb 01                	jmp    802269 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802268:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802269:	90                   	nop
  80226a:	c9                   	leave  
  80226b:	c3                   	ret    

0080226c <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80226c:	55                   	push   %ebp
  80226d:	89 e5                	mov    %esp,%ebp
  80226f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802272:	a1 38 51 80 00       	mov    0x805138,%eax
  802277:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80227a:	e9 85 01 00 00       	jmp    802404 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  80227f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802282:	8b 40 0c             	mov    0xc(%eax),%eax
  802285:	3b 45 08             	cmp    0x8(%ebp),%eax
  802288:	0f 82 6e 01 00 00    	jb     8023fc <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  80228e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802291:	8b 40 0c             	mov    0xc(%eax),%eax
  802294:	3b 45 08             	cmp    0x8(%ebp),%eax
  802297:	0f 85 8a 00 00 00    	jne    802327 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  80229d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022a1:	75 17                	jne    8022ba <alloc_block_FF+0x4e>
  8022a3:	83 ec 04             	sub    $0x4,%esp
  8022a6:	68 e8 3f 80 00       	push   $0x803fe8
  8022ab:	68 93 00 00 00       	push   $0x93
  8022b0:	68 3f 3f 80 00       	push   $0x803f3f
  8022b5:	e8 d6 df ff ff       	call   800290 <_panic>
  8022ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022bd:	8b 00                	mov    (%eax),%eax
  8022bf:	85 c0                	test   %eax,%eax
  8022c1:	74 10                	je     8022d3 <alloc_block_FF+0x67>
  8022c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c6:	8b 00                	mov    (%eax),%eax
  8022c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022cb:	8b 52 04             	mov    0x4(%edx),%edx
  8022ce:	89 50 04             	mov    %edx,0x4(%eax)
  8022d1:	eb 0b                	jmp    8022de <alloc_block_FF+0x72>
  8022d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d6:	8b 40 04             	mov    0x4(%eax),%eax
  8022d9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8022de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e1:	8b 40 04             	mov    0x4(%eax),%eax
  8022e4:	85 c0                	test   %eax,%eax
  8022e6:	74 0f                	je     8022f7 <alloc_block_FF+0x8b>
  8022e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022eb:	8b 40 04             	mov    0x4(%eax),%eax
  8022ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022f1:	8b 12                	mov    (%edx),%edx
  8022f3:	89 10                	mov    %edx,(%eax)
  8022f5:	eb 0a                	jmp    802301 <alloc_block_FF+0x95>
  8022f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022fa:	8b 00                	mov    (%eax),%eax
  8022fc:	a3 38 51 80 00       	mov    %eax,0x805138
  802301:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802304:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80230a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802314:	a1 44 51 80 00       	mov    0x805144,%eax
  802319:	48                   	dec    %eax
  80231a:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  80231f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802322:	e9 10 01 00 00       	jmp    802437 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802327:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232a:	8b 40 0c             	mov    0xc(%eax),%eax
  80232d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802330:	0f 86 c6 00 00 00    	jbe    8023fc <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802336:	a1 48 51 80 00       	mov    0x805148,%eax
  80233b:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  80233e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802341:	8b 50 08             	mov    0x8(%eax),%edx
  802344:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802347:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  80234a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80234d:	8b 55 08             	mov    0x8(%ebp),%edx
  802350:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802353:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802357:	75 17                	jne    802370 <alloc_block_FF+0x104>
  802359:	83 ec 04             	sub    $0x4,%esp
  80235c:	68 e8 3f 80 00       	push   $0x803fe8
  802361:	68 9b 00 00 00       	push   $0x9b
  802366:	68 3f 3f 80 00       	push   $0x803f3f
  80236b:	e8 20 df ff ff       	call   800290 <_panic>
  802370:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802373:	8b 00                	mov    (%eax),%eax
  802375:	85 c0                	test   %eax,%eax
  802377:	74 10                	je     802389 <alloc_block_FF+0x11d>
  802379:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80237c:	8b 00                	mov    (%eax),%eax
  80237e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802381:	8b 52 04             	mov    0x4(%edx),%edx
  802384:	89 50 04             	mov    %edx,0x4(%eax)
  802387:	eb 0b                	jmp    802394 <alloc_block_FF+0x128>
  802389:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80238c:	8b 40 04             	mov    0x4(%eax),%eax
  80238f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802394:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802397:	8b 40 04             	mov    0x4(%eax),%eax
  80239a:	85 c0                	test   %eax,%eax
  80239c:	74 0f                	je     8023ad <alloc_block_FF+0x141>
  80239e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023a1:	8b 40 04             	mov    0x4(%eax),%eax
  8023a4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023a7:	8b 12                	mov    (%edx),%edx
  8023a9:	89 10                	mov    %edx,(%eax)
  8023ab:	eb 0a                	jmp    8023b7 <alloc_block_FF+0x14b>
  8023ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023b0:	8b 00                	mov    (%eax),%eax
  8023b2:	a3 48 51 80 00       	mov    %eax,0x805148
  8023b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023c3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023ca:	a1 54 51 80 00       	mov    0x805154,%eax
  8023cf:	48                   	dec    %eax
  8023d0:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  8023d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d8:	8b 50 08             	mov    0x8(%eax),%edx
  8023db:	8b 45 08             	mov    0x8(%ebp),%eax
  8023de:	01 c2                	add    %eax,%edx
  8023e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e3:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8023e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e9:	8b 40 0c             	mov    0xc(%eax),%eax
  8023ec:	2b 45 08             	sub    0x8(%ebp),%eax
  8023ef:	89 c2                	mov    %eax,%edx
  8023f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f4:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8023f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023fa:	eb 3b                	jmp    802437 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8023fc:	a1 40 51 80 00       	mov    0x805140,%eax
  802401:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802404:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802408:	74 07                	je     802411 <alloc_block_FF+0x1a5>
  80240a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240d:	8b 00                	mov    (%eax),%eax
  80240f:	eb 05                	jmp    802416 <alloc_block_FF+0x1aa>
  802411:	b8 00 00 00 00       	mov    $0x0,%eax
  802416:	a3 40 51 80 00       	mov    %eax,0x805140
  80241b:	a1 40 51 80 00       	mov    0x805140,%eax
  802420:	85 c0                	test   %eax,%eax
  802422:	0f 85 57 fe ff ff    	jne    80227f <alloc_block_FF+0x13>
  802428:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80242c:	0f 85 4d fe ff ff    	jne    80227f <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802432:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802437:	c9                   	leave  
  802438:	c3                   	ret    

00802439 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802439:	55                   	push   %ebp
  80243a:	89 e5                	mov    %esp,%ebp
  80243c:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  80243f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802446:	a1 38 51 80 00       	mov    0x805138,%eax
  80244b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80244e:	e9 df 00 00 00       	jmp    802532 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802453:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802456:	8b 40 0c             	mov    0xc(%eax),%eax
  802459:	3b 45 08             	cmp    0x8(%ebp),%eax
  80245c:	0f 82 c8 00 00 00    	jb     80252a <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802462:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802465:	8b 40 0c             	mov    0xc(%eax),%eax
  802468:	3b 45 08             	cmp    0x8(%ebp),%eax
  80246b:	0f 85 8a 00 00 00    	jne    8024fb <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802471:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802475:	75 17                	jne    80248e <alloc_block_BF+0x55>
  802477:	83 ec 04             	sub    $0x4,%esp
  80247a:	68 e8 3f 80 00       	push   $0x803fe8
  80247f:	68 b7 00 00 00       	push   $0xb7
  802484:	68 3f 3f 80 00       	push   $0x803f3f
  802489:	e8 02 de ff ff       	call   800290 <_panic>
  80248e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802491:	8b 00                	mov    (%eax),%eax
  802493:	85 c0                	test   %eax,%eax
  802495:	74 10                	je     8024a7 <alloc_block_BF+0x6e>
  802497:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249a:	8b 00                	mov    (%eax),%eax
  80249c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80249f:	8b 52 04             	mov    0x4(%edx),%edx
  8024a2:	89 50 04             	mov    %edx,0x4(%eax)
  8024a5:	eb 0b                	jmp    8024b2 <alloc_block_BF+0x79>
  8024a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024aa:	8b 40 04             	mov    0x4(%eax),%eax
  8024ad:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8024b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b5:	8b 40 04             	mov    0x4(%eax),%eax
  8024b8:	85 c0                	test   %eax,%eax
  8024ba:	74 0f                	je     8024cb <alloc_block_BF+0x92>
  8024bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bf:	8b 40 04             	mov    0x4(%eax),%eax
  8024c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024c5:	8b 12                	mov    (%edx),%edx
  8024c7:	89 10                	mov    %edx,(%eax)
  8024c9:	eb 0a                	jmp    8024d5 <alloc_block_BF+0x9c>
  8024cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ce:	8b 00                	mov    (%eax),%eax
  8024d0:	a3 38 51 80 00       	mov    %eax,0x805138
  8024d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024e8:	a1 44 51 80 00       	mov    0x805144,%eax
  8024ed:	48                   	dec    %eax
  8024ee:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  8024f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f6:	e9 4d 01 00 00       	jmp    802648 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8024fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fe:	8b 40 0c             	mov    0xc(%eax),%eax
  802501:	3b 45 08             	cmp    0x8(%ebp),%eax
  802504:	76 24                	jbe    80252a <alloc_block_BF+0xf1>
  802506:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802509:	8b 40 0c             	mov    0xc(%eax),%eax
  80250c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80250f:	73 19                	jae    80252a <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802511:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802518:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251b:	8b 40 0c             	mov    0xc(%eax),%eax
  80251e:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802521:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802524:	8b 40 08             	mov    0x8(%eax),%eax
  802527:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80252a:	a1 40 51 80 00       	mov    0x805140,%eax
  80252f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802532:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802536:	74 07                	je     80253f <alloc_block_BF+0x106>
  802538:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253b:	8b 00                	mov    (%eax),%eax
  80253d:	eb 05                	jmp    802544 <alloc_block_BF+0x10b>
  80253f:	b8 00 00 00 00       	mov    $0x0,%eax
  802544:	a3 40 51 80 00       	mov    %eax,0x805140
  802549:	a1 40 51 80 00       	mov    0x805140,%eax
  80254e:	85 c0                	test   %eax,%eax
  802550:	0f 85 fd fe ff ff    	jne    802453 <alloc_block_BF+0x1a>
  802556:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80255a:	0f 85 f3 fe ff ff    	jne    802453 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802560:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802564:	0f 84 d9 00 00 00    	je     802643 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  80256a:	a1 48 51 80 00       	mov    0x805148,%eax
  80256f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802572:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802575:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802578:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  80257b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80257e:	8b 55 08             	mov    0x8(%ebp),%edx
  802581:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802584:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802588:	75 17                	jne    8025a1 <alloc_block_BF+0x168>
  80258a:	83 ec 04             	sub    $0x4,%esp
  80258d:	68 e8 3f 80 00       	push   $0x803fe8
  802592:	68 c7 00 00 00       	push   $0xc7
  802597:	68 3f 3f 80 00       	push   $0x803f3f
  80259c:	e8 ef dc ff ff       	call   800290 <_panic>
  8025a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025a4:	8b 00                	mov    (%eax),%eax
  8025a6:	85 c0                	test   %eax,%eax
  8025a8:	74 10                	je     8025ba <alloc_block_BF+0x181>
  8025aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025ad:	8b 00                	mov    (%eax),%eax
  8025af:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025b2:	8b 52 04             	mov    0x4(%edx),%edx
  8025b5:	89 50 04             	mov    %edx,0x4(%eax)
  8025b8:	eb 0b                	jmp    8025c5 <alloc_block_BF+0x18c>
  8025ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025bd:	8b 40 04             	mov    0x4(%eax),%eax
  8025c0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8025c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025c8:	8b 40 04             	mov    0x4(%eax),%eax
  8025cb:	85 c0                	test   %eax,%eax
  8025cd:	74 0f                	je     8025de <alloc_block_BF+0x1a5>
  8025cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025d2:	8b 40 04             	mov    0x4(%eax),%eax
  8025d5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025d8:	8b 12                	mov    (%edx),%edx
  8025da:	89 10                	mov    %edx,(%eax)
  8025dc:	eb 0a                	jmp    8025e8 <alloc_block_BF+0x1af>
  8025de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025e1:	8b 00                	mov    (%eax),%eax
  8025e3:	a3 48 51 80 00       	mov    %eax,0x805148
  8025e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025eb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025f4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025fb:	a1 54 51 80 00       	mov    0x805154,%eax
  802600:	48                   	dec    %eax
  802601:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802606:	83 ec 08             	sub    $0x8,%esp
  802609:	ff 75 ec             	pushl  -0x14(%ebp)
  80260c:	68 38 51 80 00       	push   $0x805138
  802611:	e8 71 f9 ff ff       	call   801f87 <find_block>
  802616:	83 c4 10             	add    $0x10,%esp
  802619:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  80261c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80261f:	8b 50 08             	mov    0x8(%eax),%edx
  802622:	8b 45 08             	mov    0x8(%ebp),%eax
  802625:	01 c2                	add    %eax,%edx
  802627:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80262a:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  80262d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802630:	8b 40 0c             	mov    0xc(%eax),%eax
  802633:	2b 45 08             	sub    0x8(%ebp),%eax
  802636:	89 c2                	mov    %eax,%edx
  802638:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80263b:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  80263e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802641:	eb 05                	jmp    802648 <alloc_block_BF+0x20f>
	}
	return NULL;
  802643:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802648:	c9                   	leave  
  802649:	c3                   	ret    

0080264a <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  80264a:	55                   	push   %ebp
  80264b:	89 e5                	mov    %esp,%ebp
  80264d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802650:	a1 28 50 80 00       	mov    0x805028,%eax
  802655:	85 c0                	test   %eax,%eax
  802657:	0f 85 de 01 00 00    	jne    80283b <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80265d:	a1 38 51 80 00       	mov    0x805138,%eax
  802662:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802665:	e9 9e 01 00 00       	jmp    802808 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  80266a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266d:	8b 40 0c             	mov    0xc(%eax),%eax
  802670:	3b 45 08             	cmp    0x8(%ebp),%eax
  802673:	0f 82 87 01 00 00    	jb     802800 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802679:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267c:	8b 40 0c             	mov    0xc(%eax),%eax
  80267f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802682:	0f 85 95 00 00 00    	jne    80271d <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802688:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80268c:	75 17                	jne    8026a5 <alloc_block_NF+0x5b>
  80268e:	83 ec 04             	sub    $0x4,%esp
  802691:	68 e8 3f 80 00       	push   $0x803fe8
  802696:	68 e0 00 00 00       	push   $0xe0
  80269b:	68 3f 3f 80 00       	push   $0x803f3f
  8026a0:	e8 eb db ff ff       	call   800290 <_panic>
  8026a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a8:	8b 00                	mov    (%eax),%eax
  8026aa:	85 c0                	test   %eax,%eax
  8026ac:	74 10                	je     8026be <alloc_block_NF+0x74>
  8026ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b1:	8b 00                	mov    (%eax),%eax
  8026b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026b6:	8b 52 04             	mov    0x4(%edx),%edx
  8026b9:	89 50 04             	mov    %edx,0x4(%eax)
  8026bc:	eb 0b                	jmp    8026c9 <alloc_block_NF+0x7f>
  8026be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c1:	8b 40 04             	mov    0x4(%eax),%eax
  8026c4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8026c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cc:	8b 40 04             	mov    0x4(%eax),%eax
  8026cf:	85 c0                	test   %eax,%eax
  8026d1:	74 0f                	je     8026e2 <alloc_block_NF+0x98>
  8026d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d6:	8b 40 04             	mov    0x4(%eax),%eax
  8026d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026dc:	8b 12                	mov    (%edx),%edx
  8026de:	89 10                	mov    %edx,(%eax)
  8026e0:	eb 0a                	jmp    8026ec <alloc_block_NF+0xa2>
  8026e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e5:	8b 00                	mov    (%eax),%eax
  8026e7:	a3 38 51 80 00       	mov    %eax,0x805138
  8026ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026ff:	a1 44 51 80 00       	mov    0x805144,%eax
  802704:	48                   	dec    %eax
  802705:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  80270a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270d:	8b 40 08             	mov    0x8(%eax),%eax
  802710:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802715:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802718:	e9 f8 04 00 00       	jmp    802c15 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  80271d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802720:	8b 40 0c             	mov    0xc(%eax),%eax
  802723:	3b 45 08             	cmp    0x8(%ebp),%eax
  802726:	0f 86 d4 00 00 00    	jbe    802800 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80272c:	a1 48 51 80 00       	mov    0x805148,%eax
  802731:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802734:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802737:	8b 50 08             	mov    0x8(%eax),%edx
  80273a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80273d:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802740:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802743:	8b 55 08             	mov    0x8(%ebp),%edx
  802746:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802749:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80274d:	75 17                	jne    802766 <alloc_block_NF+0x11c>
  80274f:	83 ec 04             	sub    $0x4,%esp
  802752:	68 e8 3f 80 00       	push   $0x803fe8
  802757:	68 e9 00 00 00       	push   $0xe9
  80275c:	68 3f 3f 80 00       	push   $0x803f3f
  802761:	e8 2a db ff ff       	call   800290 <_panic>
  802766:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802769:	8b 00                	mov    (%eax),%eax
  80276b:	85 c0                	test   %eax,%eax
  80276d:	74 10                	je     80277f <alloc_block_NF+0x135>
  80276f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802772:	8b 00                	mov    (%eax),%eax
  802774:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802777:	8b 52 04             	mov    0x4(%edx),%edx
  80277a:	89 50 04             	mov    %edx,0x4(%eax)
  80277d:	eb 0b                	jmp    80278a <alloc_block_NF+0x140>
  80277f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802782:	8b 40 04             	mov    0x4(%eax),%eax
  802785:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80278a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80278d:	8b 40 04             	mov    0x4(%eax),%eax
  802790:	85 c0                	test   %eax,%eax
  802792:	74 0f                	je     8027a3 <alloc_block_NF+0x159>
  802794:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802797:	8b 40 04             	mov    0x4(%eax),%eax
  80279a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80279d:	8b 12                	mov    (%edx),%edx
  80279f:	89 10                	mov    %edx,(%eax)
  8027a1:	eb 0a                	jmp    8027ad <alloc_block_NF+0x163>
  8027a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027a6:	8b 00                	mov    (%eax),%eax
  8027a8:	a3 48 51 80 00       	mov    %eax,0x805148
  8027ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027b9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027c0:	a1 54 51 80 00       	mov    0x805154,%eax
  8027c5:	48                   	dec    %eax
  8027c6:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  8027cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ce:	8b 40 08             	mov    0x8(%eax),%eax
  8027d1:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  8027d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d9:	8b 50 08             	mov    0x8(%eax),%edx
  8027dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8027df:	01 c2                	add    %eax,%edx
  8027e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e4:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  8027e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ea:	8b 40 0c             	mov    0xc(%eax),%eax
  8027ed:	2b 45 08             	sub    0x8(%ebp),%eax
  8027f0:	89 c2                	mov    %eax,%edx
  8027f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f5:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8027f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027fb:	e9 15 04 00 00       	jmp    802c15 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802800:	a1 40 51 80 00       	mov    0x805140,%eax
  802805:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802808:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80280c:	74 07                	je     802815 <alloc_block_NF+0x1cb>
  80280e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802811:	8b 00                	mov    (%eax),%eax
  802813:	eb 05                	jmp    80281a <alloc_block_NF+0x1d0>
  802815:	b8 00 00 00 00       	mov    $0x0,%eax
  80281a:	a3 40 51 80 00       	mov    %eax,0x805140
  80281f:	a1 40 51 80 00       	mov    0x805140,%eax
  802824:	85 c0                	test   %eax,%eax
  802826:	0f 85 3e fe ff ff    	jne    80266a <alloc_block_NF+0x20>
  80282c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802830:	0f 85 34 fe ff ff    	jne    80266a <alloc_block_NF+0x20>
  802836:	e9 d5 03 00 00       	jmp    802c10 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  80283b:	a1 38 51 80 00       	mov    0x805138,%eax
  802840:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802843:	e9 b1 01 00 00       	jmp    8029f9 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802848:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284b:	8b 50 08             	mov    0x8(%eax),%edx
  80284e:	a1 28 50 80 00       	mov    0x805028,%eax
  802853:	39 c2                	cmp    %eax,%edx
  802855:	0f 82 96 01 00 00    	jb     8029f1 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  80285b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285e:	8b 40 0c             	mov    0xc(%eax),%eax
  802861:	3b 45 08             	cmp    0x8(%ebp),%eax
  802864:	0f 82 87 01 00 00    	jb     8029f1 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  80286a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286d:	8b 40 0c             	mov    0xc(%eax),%eax
  802870:	3b 45 08             	cmp    0x8(%ebp),%eax
  802873:	0f 85 95 00 00 00    	jne    80290e <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802879:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80287d:	75 17                	jne    802896 <alloc_block_NF+0x24c>
  80287f:	83 ec 04             	sub    $0x4,%esp
  802882:	68 e8 3f 80 00       	push   $0x803fe8
  802887:	68 fc 00 00 00       	push   $0xfc
  80288c:	68 3f 3f 80 00       	push   $0x803f3f
  802891:	e8 fa d9 ff ff       	call   800290 <_panic>
  802896:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802899:	8b 00                	mov    (%eax),%eax
  80289b:	85 c0                	test   %eax,%eax
  80289d:	74 10                	je     8028af <alloc_block_NF+0x265>
  80289f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a2:	8b 00                	mov    (%eax),%eax
  8028a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028a7:	8b 52 04             	mov    0x4(%edx),%edx
  8028aa:	89 50 04             	mov    %edx,0x4(%eax)
  8028ad:	eb 0b                	jmp    8028ba <alloc_block_NF+0x270>
  8028af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b2:	8b 40 04             	mov    0x4(%eax),%eax
  8028b5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8028ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bd:	8b 40 04             	mov    0x4(%eax),%eax
  8028c0:	85 c0                	test   %eax,%eax
  8028c2:	74 0f                	je     8028d3 <alloc_block_NF+0x289>
  8028c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c7:	8b 40 04             	mov    0x4(%eax),%eax
  8028ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028cd:	8b 12                	mov    (%edx),%edx
  8028cf:	89 10                	mov    %edx,(%eax)
  8028d1:	eb 0a                	jmp    8028dd <alloc_block_NF+0x293>
  8028d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d6:	8b 00                	mov    (%eax),%eax
  8028d8:	a3 38 51 80 00       	mov    %eax,0x805138
  8028dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028f0:	a1 44 51 80 00       	mov    0x805144,%eax
  8028f5:	48                   	dec    %eax
  8028f6:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8028fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fe:	8b 40 08             	mov    0x8(%eax),%eax
  802901:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802906:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802909:	e9 07 03 00 00       	jmp    802c15 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  80290e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802911:	8b 40 0c             	mov    0xc(%eax),%eax
  802914:	3b 45 08             	cmp    0x8(%ebp),%eax
  802917:	0f 86 d4 00 00 00    	jbe    8029f1 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80291d:	a1 48 51 80 00       	mov    0x805148,%eax
  802922:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802925:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802928:	8b 50 08             	mov    0x8(%eax),%edx
  80292b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80292e:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802931:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802934:	8b 55 08             	mov    0x8(%ebp),%edx
  802937:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80293a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80293e:	75 17                	jne    802957 <alloc_block_NF+0x30d>
  802940:	83 ec 04             	sub    $0x4,%esp
  802943:	68 e8 3f 80 00       	push   $0x803fe8
  802948:	68 04 01 00 00       	push   $0x104
  80294d:	68 3f 3f 80 00       	push   $0x803f3f
  802952:	e8 39 d9 ff ff       	call   800290 <_panic>
  802957:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80295a:	8b 00                	mov    (%eax),%eax
  80295c:	85 c0                	test   %eax,%eax
  80295e:	74 10                	je     802970 <alloc_block_NF+0x326>
  802960:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802963:	8b 00                	mov    (%eax),%eax
  802965:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802968:	8b 52 04             	mov    0x4(%edx),%edx
  80296b:	89 50 04             	mov    %edx,0x4(%eax)
  80296e:	eb 0b                	jmp    80297b <alloc_block_NF+0x331>
  802970:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802973:	8b 40 04             	mov    0x4(%eax),%eax
  802976:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80297b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80297e:	8b 40 04             	mov    0x4(%eax),%eax
  802981:	85 c0                	test   %eax,%eax
  802983:	74 0f                	je     802994 <alloc_block_NF+0x34a>
  802985:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802988:	8b 40 04             	mov    0x4(%eax),%eax
  80298b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80298e:	8b 12                	mov    (%edx),%edx
  802990:	89 10                	mov    %edx,(%eax)
  802992:	eb 0a                	jmp    80299e <alloc_block_NF+0x354>
  802994:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802997:	8b 00                	mov    (%eax),%eax
  802999:	a3 48 51 80 00       	mov    %eax,0x805148
  80299e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029a1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029aa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029b1:	a1 54 51 80 00       	mov    0x805154,%eax
  8029b6:	48                   	dec    %eax
  8029b7:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  8029bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029bf:	8b 40 08             	mov    0x8(%eax),%eax
  8029c2:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  8029c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ca:	8b 50 08             	mov    0x8(%eax),%edx
  8029cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d0:	01 c2                	add    %eax,%edx
  8029d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d5:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8029d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029db:	8b 40 0c             	mov    0xc(%eax),%eax
  8029de:	2b 45 08             	sub    0x8(%ebp),%eax
  8029e1:	89 c2                	mov    %eax,%edx
  8029e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e6:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8029e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029ec:	e9 24 02 00 00       	jmp    802c15 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8029f1:	a1 40 51 80 00       	mov    0x805140,%eax
  8029f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029fd:	74 07                	je     802a06 <alloc_block_NF+0x3bc>
  8029ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a02:	8b 00                	mov    (%eax),%eax
  802a04:	eb 05                	jmp    802a0b <alloc_block_NF+0x3c1>
  802a06:	b8 00 00 00 00       	mov    $0x0,%eax
  802a0b:	a3 40 51 80 00       	mov    %eax,0x805140
  802a10:	a1 40 51 80 00       	mov    0x805140,%eax
  802a15:	85 c0                	test   %eax,%eax
  802a17:	0f 85 2b fe ff ff    	jne    802848 <alloc_block_NF+0x1fe>
  802a1d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a21:	0f 85 21 fe ff ff    	jne    802848 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a27:	a1 38 51 80 00       	mov    0x805138,%eax
  802a2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a2f:	e9 ae 01 00 00       	jmp    802be2 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802a34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a37:	8b 50 08             	mov    0x8(%eax),%edx
  802a3a:	a1 28 50 80 00       	mov    0x805028,%eax
  802a3f:	39 c2                	cmp    %eax,%edx
  802a41:	0f 83 93 01 00 00    	jae    802bda <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802a47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4a:	8b 40 0c             	mov    0xc(%eax),%eax
  802a4d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a50:	0f 82 84 01 00 00    	jb     802bda <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802a56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a59:	8b 40 0c             	mov    0xc(%eax),%eax
  802a5c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a5f:	0f 85 95 00 00 00    	jne    802afa <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802a65:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a69:	75 17                	jne    802a82 <alloc_block_NF+0x438>
  802a6b:	83 ec 04             	sub    $0x4,%esp
  802a6e:	68 e8 3f 80 00       	push   $0x803fe8
  802a73:	68 14 01 00 00       	push   $0x114
  802a78:	68 3f 3f 80 00       	push   $0x803f3f
  802a7d:	e8 0e d8 ff ff       	call   800290 <_panic>
  802a82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a85:	8b 00                	mov    (%eax),%eax
  802a87:	85 c0                	test   %eax,%eax
  802a89:	74 10                	je     802a9b <alloc_block_NF+0x451>
  802a8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8e:	8b 00                	mov    (%eax),%eax
  802a90:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a93:	8b 52 04             	mov    0x4(%edx),%edx
  802a96:	89 50 04             	mov    %edx,0x4(%eax)
  802a99:	eb 0b                	jmp    802aa6 <alloc_block_NF+0x45c>
  802a9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9e:	8b 40 04             	mov    0x4(%eax),%eax
  802aa1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802aa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa9:	8b 40 04             	mov    0x4(%eax),%eax
  802aac:	85 c0                	test   %eax,%eax
  802aae:	74 0f                	je     802abf <alloc_block_NF+0x475>
  802ab0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab3:	8b 40 04             	mov    0x4(%eax),%eax
  802ab6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ab9:	8b 12                	mov    (%edx),%edx
  802abb:	89 10                	mov    %edx,(%eax)
  802abd:	eb 0a                	jmp    802ac9 <alloc_block_NF+0x47f>
  802abf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac2:	8b 00                	mov    (%eax),%eax
  802ac4:	a3 38 51 80 00       	mov    %eax,0x805138
  802ac9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ad2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802adc:	a1 44 51 80 00       	mov    0x805144,%eax
  802ae1:	48                   	dec    %eax
  802ae2:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802ae7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aea:	8b 40 08             	mov    0x8(%eax),%eax
  802aed:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802af2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af5:	e9 1b 01 00 00       	jmp    802c15 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802afa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afd:	8b 40 0c             	mov    0xc(%eax),%eax
  802b00:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b03:	0f 86 d1 00 00 00    	jbe    802bda <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b09:	a1 48 51 80 00       	mov    0x805148,%eax
  802b0e:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802b11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b14:	8b 50 08             	mov    0x8(%eax),%edx
  802b17:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b1a:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802b1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b20:	8b 55 08             	mov    0x8(%ebp),%edx
  802b23:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b26:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b2a:	75 17                	jne    802b43 <alloc_block_NF+0x4f9>
  802b2c:	83 ec 04             	sub    $0x4,%esp
  802b2f:	68 e8 3f 80 00       	push   $0x803fe8
  802b34:	68 1c 01 00 00       	push   $0x11c
  802b39:	68 3f 3f 80 00       	push   $0x803f3f
  802b3e:	e8 4d d7 ff ff       	call   800290 <_panic>
  802b43:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b46:	8b 00                	mov    (%eax),%eax
  802b48:	85 c0                	test   %eax,%eax
  802b4a:	74 10                	je     802b5c <alloc_block_NF+0x512>
  802b4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b4f:	8b 00                	mov    (%eax),%eax
  802b51:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b54:	8b 52 04             	mov    0x4(%edx),%edx
  802b57:	89 50 04             	mov    %edx,0x4(%eax)
  802b5a:	eb 0b                	jmp    802b67 <alloc_block_NF+0x51d>
  802b5c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b5f:	8b 40 04             	mov    0x4(%eax),%eax
  802b62:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b67:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b6a:	8b 40 04             	mov    0x4(%eax),%eax
  802b6d:	85 c0                	test   %eax,%eax
  802b6f:	74 0f                	je     802b80 <alloc_block_NF+0x536>
  802b71:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b74:	8b 40 04             	mov    0x4(%eax),%eax
  802b77:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b7a:	8b 12                	mov    (%edx),%edx
  802b7c:	89 10                	mov    %edx,(%eax)
  802b7e:	eb 0a                	jmp    802b8a <alloc_block_NF+0x540>
  802b80:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b83:	8b 00                	mov    (%eax),%eax
  802b85:	a3 48 51 80 00       	mov    %eax,0x805148
  802b8a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b8d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b93:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b96:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b9d:	a1 54 51 80 00       	mov    0x805154,%eax
  802ba2:	48                   	dec    %eax
  802ba3:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802ba8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bab:	8b 40 08             	mov    0x8(%eax),%eax
  802bae:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802bb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb6:	8b 50 08             	mov    0x8(%eax),%edx
  802bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbc:	01 c2                	add    %eax,%edx
  802bbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc1:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802bc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc7:	8b 40 0c             	mov    0xc(%eax),%eax
  802bca:	2b 45 08             	sub    0x8(%ebp),%eax
  802bcd:	89 c2                	mov    %eax,%edx
  802bcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd2:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802bd5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bd8:	eb 3b                	jmp    802c15 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802bda:	a1 40 51 80 00       	mov    0x805140,%eax
  802bdf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802be2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802be6:	74 07                	je     802bef <alloc_block_NF+0x5a5>
  802be8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802beb:	8b 00                	mov    (%eax),%eax
  802bed:	eb 05                	jmp    802bf4 <alloc_block_NF+0x5aa>
  802bef:	b8 00 00 00 00       	mov    $0x0,%eax
  802bf4:	a3 40 51 80 00       	mov    %eax,0x805140
  802bf9:	a1 40 51 80 00       	mov    0x805140,%eax
  802bfe:	85 c0                	test   %eax,%eax
  802c00:	0f 85 2e fe ff ff    	jne    802a34 <alloc_block_NF+0x3ea>
  802c06:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c0a:	0f 85 24 fe ff ff    	jne    802a34 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802c10:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c15:	c9                   	leave  
  802c16:	c3                   	ret    

00802c17 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802c17:	55                   	push   %ebp
  802c18:	89 e5                	mov    %esp,%ebp
  802c1a:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802c1d:	a1 38 51 80 00       	mov    0x805138,%eax
  802c22:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802c25:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802c2a:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802c2d:	a1 38 51 80 00       	mov    0x805138,%eax
  802c32:	85 c0                	test   %eax,%eax
  802c34:	74 14                	je     802c4a <insert_sorted_with_merge_freeList+0x33>
  802c36:	8b 45 08             	mov    0x8(%ebp),%eax
  802c39:	8b 50 08             	mov    0x8(%eax),%edx
  802c3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c3f:	8b 40 08             	mov    0x8(%eax),%eax
  802c42:	39 c2                	cmp    %eax,%edx
  802c44:	0f 87 9b 01 00 00    	ja     802de5 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802c4a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c4e:	75 17                	jne    802c67 <insert_sorted_with_merge_freeList+0x50>
  802c50:	83 ec 04             	sub    $0x4,%esp
  802c53:	68 1c 3f 80 00       	push   $0x803f1c
  802c58:	68 38 01 00 00       	push   $0x138
  802c5d:	68 3f 3f 80 00       	push   $0x803f3f
  802c62:	e8 29 d6 ff ff       	call   800290 <_panic>
  802c67:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c70:	89 10                	mov    %edx,(%eax)
  802c72:	8b 45 08             	mov    0x8(%ebp),%eax
  802c75:	8b 00                	mov    (%eax),%eax
  802c77:	85 c0                	test   %eax,%eax
  802c79:	74 0d                	je     802c88 <insert_sorted_with_merge_freeList+0x71>
  802c7b:	a1 38 51 80 00       	mov    0x805138,%eax
  802c80:	8b 55 08             	mov    0x8(%ebp),%edx
  802c83:	89 50 04             	mov    %edx,0x4(%eax)
  802c86:	eb 08                	jmp    802c90 <insert_sorted_with_merge_freeList+0x79>
  802c88:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c90:	8b 45 08             	mov    0x8(%ebp),%eax
  802c93:	a3 38 51 80 00       	mov    %eax,0x805138
  802c98:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ca2:	a1 44 51 80 00       	mov    0x805144,%eax
  802ca7:	40                   	inc    %eax
  802ca8:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802cad:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cb1:	0f 84 a8 06 00 00    	je     80335f <insert_sorted_with_merge_freeList+0x748>
  802cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  802cba:	8b 50 08             	mov    0x8(%eax),%edx
  802cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc0:	8b 40 0c             	mov    0xc(%eax),%eax
  802cc3:	01 c2                	add    %eax,%edx
  802cc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cc8:	8b 40 08             	mov    0x8(%eax),%eax
  802ccb:	39 c2                	cmp    %eax,%edx
  802ccd:	0f 85 8c 06 00 00    	jne    80335f <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802cd3:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd6:	8b 50 0c             	mov    0xc(%eax),%edx
  802cd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cdc:	8b 40 0c             	mov    0xc(%eax),%eax
  802cdf:	01 c2                	add    %eax,%edx
  802ce1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce4:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802ce7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ceb:	75 17                	jne    802d04 <insert_sorted_with_merge_freeList+0xed>
  802ced:	83 ec 04             	sub    $0x4,%esp
  802cf0:	68 e8 3f 80 00       	push   $0x803fe8
  802cf5:	68 3c 01 00 00       	push   $0x13c
  802cfa:	68 3f 3f 80 00       	push   $0x803f3f
  802cff:	e8 8c d5 ff ff       	call   800290 <_panic>
  802d04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d07:	8b 00                	mov    (%eax),%eax
  802d09:	85 c0                	test   %eax,%eax
  802d0b:	74 10                	je     802d1d <insert_sorted_with_merge_freeList+0x106>
  802d0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d10:	8b 00                	mov    (%eax),%eax
  802d12:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d15:	8b 52 04             	mov    0x4(%edx),%edx
  802d18:	89 50 04             	mov    %edx,0x4(%eax)
  802d1b:	eb 0b                	jmp    802d28 <insert_sorted_with_merge_freeList+0x111>
  802d1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d20:	8b 40 04             	mov    0x4(%eax),%eax
  802d23:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d2b:	8b 40 04             	mov    0x4(%eax),%eax
  802d2e:	85 c0                	test   %eax,%eax
  802d30:	74 0f                	je     802d41 <insert_sorted_with_merge_freeList+0x12a>
  802d32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d35:	8b 40 04             	mov    0x4(%eax),%eax
  802d38:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d3b:	8b 12                	mov    (%edx),%edx
  802d3d:	89 10                	mov    %edx,(%eax)
  802d3f:	eb 0a                	jmp    802d4b <insert_sorted_with_merge_freeList+0x134>
  802d41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d44:	8b 00                	mov    (%eax),%eax
  802d46:	a3 38 51 80 00       	mov    %eax,0x805138
  802d4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d4e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d57:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d5e:	a1 44 51 80 00       	mov    0x805144,%eax
  802d63:	48                   	dec    %eax
  802d64:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802d69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d6c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802d73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d76:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802d7d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d81:	75 17                	jne    802d9a <insert_sorted_with_merge_freeList+0x183>
  802d83:	83 ec 04             	sub    $0x4,%esp
  802d86:	68 1c 3f 80 00       	push   $0x803f1c
  802d8b:	68 3f 01 00 00       	push   $0x13f
  802d90:	68 3f 3f 80 00       	push   $0x803f3f
  802d95:	e8 f6 d4 ff ff       	call   800290 <_panic>
  802d9a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802da0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da3:	89 10                	mov    %edx,(%eax)
  802da5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da8:	8b 00                	mov    (%eax),%eax
  802daa:	85 c0                	test   %eax,%eax
  802dac:	74 0d                	je     802dbb <insert_sorted_with_merge_freeList+0x1a4>
  802dae:	a1 48 51 80 00       	mov    0x805148,%eax
  802db3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802db6:	89 50 04             	mov    %edx,0x4(%eax)
  802db9:	eb 08                	jmp    802dc3 <insert_sorted_with_merge_freeList+0x1ac>
  802dbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dbe:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802dc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc6:	a3 48 51 80 00       	mov    %eax,0x805148
  802dcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dce:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dd5:	a1 54 51 80 00       	mov    0x805154,%eax
  802dda:	40                   	inc    %eax
  802ddb:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802de0:	e9 7a 05 00 00       	jmp    80335f <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802de5:	8b 45 08             	mov    0x8(%ebp),%eax
  802de8:	8b 50 08             	mov    0x8(%eax),%edx
  802deb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dee:	8b 40 08             	mov    0x8(%eax),%eax
  802df1:	39 c2                	cmp    %eax,%edx
  802df3:	0f 82 14 01 00 00    	jb     802f0d <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802df9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dfc:	8b 50 08             	mov    0x8(%eax),%edx
  802dff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e02:	8b 40 0c             	mov    0xc(%eax),%eax
  802e05:	01 c2                	add    %eax,%edx
  802e07:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0a:	8b 40 08             	mov    0x8(%eax),%eax
  802e0d:	39 c2                	cmp    %eax,%edx
  802e0f:	0f 85 90 00 00 00    	jne    802ea5 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802e15:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e18:	8b 50 0c             	mov    0xc(%eax),%edx
  802e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1e:	8b 40 0c             	mov    0xc(%eax),%eax
  802e21:	01 c2                	add    %eax,%edx
  802e23:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e26:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802e29:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802e33:	8b 45 08             	mov    0x8(%ebp),%eax
  802e36:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802e3d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e41:	75 17                	jne    802e5a <insert_sorted_with_merge_freeList+0x243>
  802e43:	83 ec 04             	sub    $0x4,%esp
  802e46:	68 1c 3f 80 00       	push   $0x803f1c
  802e4b:	68 49 01 00 00       	push   $0x149
  802e50:	68 3f 3f 80 00       	push   $0x803f3f
  802e55:	e8 36 d4 ff ff       	call   800290 <_panic>
  802e5a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802e60:	8b 45 08             	mov    0x8(%ebp),%eax
  802e63:	89 10                	mov    %edx,(%eax)
  802e65:	8b 45 08             	mov    0x8(%ebp),%eax
  802e68:	8b 00                	mov    (%eax),%eax
  802e6a:	85 c0                	test   %eax,%eax
  802e6c:	74 0d                	je     802e7b <insert_sorted_with_merge_freeList+0x264>
  802e6e:	a1 48 51 80 00       	mov    0x805148,%eax
  802e73:	8b 55 08             	mov    0x8(%ebp),%edx
  802e76:	89 50 04             	mov    %edx,0x4(%eax)
  802e79:	eb 08                	jmp    802e83 <insert_sorted_with_merge_freeList+0x26c>
  802e7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e83:	8b 45 08             	mov    0x8(%ebp),%eax
  802e86:	a3 48 51 80 00       	mov    %eax,0x805148
  802e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e95:	a1 54 51 80 00       	mov    0x805154,%eax
  802e9a:	40                   	inc    %eax
  802e9b:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802ea0:	e9 bb 04 00 00       	jmp    803360 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802ea5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ea9:	75 17                	jne    802ec2 <insert_sorted_with_merge_freeList+0x2ab>
  802eab:	83 ec 04             	sub    $0x4,%esp
  802eae:	68 90 3f 80 00       	push   $0x803f90
  802eb3:	68 4c 01 00 00       	push   $0x14c
  802eb8:	68 3f 3f 80 00       	push   $0x803f3f
  802ebd:	e8 ce d3 ff ff       	call   800290 <_panic>
  802ec2:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802ec8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ecb:	89 50 04             	mov    %edx,0x4(%eax)
  802ece:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed1:	8b 40 04             	mov    0x4(%eax),%eax
  802ed4:	85 c0                	test   %eax,%eax
  802ed6:	74 0c                	je     802ee4 <insert_sorted_with_merge_freeList+0x2cd>
  802ed8:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802edd:	8b 55 08             	mov    0x8(%ebp),%edx
  802ee0:	89 10                	mov    %edx,(%eax)
  802ee2:	eb 08                	jmp    802eec <insert_sorted_with_merge_freeList+0x2d5>
  802ee4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee7:	a3 38 51 80 00       	mov    %eax,0x805138
  802eec:	8b 45 08             	mov    0x8(%ebp),%eax
  802eef:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ef4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802efd:	a1 44 51 80 00       	mov    0x805144,%eax
  802f02:	40                   	inc    %eax
  802f03:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802f08:	e9 53 04 00 00       	jmp    803360 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802f0d:	a1 38 51 80 00       	mov    0x805138,%eax
  802f12:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f15:	e9 15 04 00 00       	jmp    80332f <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802f1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1d:	8b 00                	mov    (%eax),%eax
  802f1f:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802f22:	8b 45 08             	mov    0x8(%ebp),%eax
  802f25:	8b 50 08             	mov    0x8(%eax),%edx
  802f28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2b:	8b 40 08             	mov    0x8(%eax),%eax
  802f2e:	39 c2                	cmp    %eax,%edx
  802f30:	0f 86 f1 03 00 00    	jbe    803327 <insert_sorted_with_merge_freeList+0x710>
  802f36:	8b 45 08             	mov    0x8(%ebp),%eax
  802f39:	8b 50 08             	mov    0x8(%eax),%edx
  802f3c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f3f:	8b 40 08             	mov    0x8(%eax),%eax
  802f42:	39 c2                	cmp    %eax,%edx
  802f44:	0f 83 dd 03 00 00    	jae    803327 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802f4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4d:	8b 50 08             	mov    0x8(%eax),%edx
  802f50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f53:	8b 40 0c             	mov    0xc(%eax),%eax
  802f56:	01 c2                	add    %eax,%edx
  802f58:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5b:	8b 40 08             	mov    0x8(%eax),%eax
  802f5e:	39 c2                	cmp    %eax,%edx
  802f60:	0f 85 b9 01 00 00    	jne    80311f <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802f66:	8b 45 08             	mov    0x8(%ebp),%eax
  802f69:	8b 50 08             	mov    0x8(%eax),%edx
  802f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6f:	8b 40 0c             	mov    0xc(%eax),%eax
  802f72:	01 c2                	add    %eax,%edx
  802f74:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f77:	8b 40 08             	mov    0x8(%eax),%eax
  802f7a:	39 c2                	cmp    %eax,%edx
  802f7c:	0f 85 0d 01 00 00    	jne    80308f <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802f82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f85:	8b 50 0c             	mov    0xc(%eax),%edx
  802f88:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f8b:	8b 40 0c             	mov    0xc(%eax),%eax
  802f8e:	01 c2                	add    %eax,%edx
  802f90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f93:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802f96:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f9a:	75 17                	jne    802fb3 <insert_sorted_with_merge_freeList+0x39c>
  802f9c:	83 ec 04             	sub    $0x4,%esp
  802f9f:	68 e8 3f 80 00       	push   $0x803fe8
  802fa4:	68 5c 01 00 00       	push   $0x15c
  802fa9:	68 3f 3f 80 00       	push   $0x803f3f
  802fae:	e8 dd d2 ff ff       	call   800290 <_panic>
  802fb3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fb6:	8b 00                	mov    (%eax),%eax
  802fb8:	85 c0                	test   %eax,%eax
  802fba:	74 10                	je     802fcc <insert_sorted_with_merge_freeList+0x3b5>
  802fbc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fbf:	8b 00                	mov    (%eax),%eax
  802fc1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fc4:	8b 52 04             	mov    0x4(%edx),%edx
  802fc7:	89 50 04             	mov    %edx,0x4(%eax)
  802fca:	eb 0b                	jmp    802fd7 <insert_sorted_with_merge_freeList+0x3c0>
  802fcc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fcf:	8b 40 04             	mov    0x4(%eax),%eax
  802fd2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fd7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fda:	8b 40 04             	mov    0x4(%eax),%eax
  802fdd:	85 c0                	test   %eax,%eax
  802fdf:	74 0f                	je     802ff0 <insert_sorted_with_merge_freeList+0x3d9>
  802fe1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fe4:	8b 40 04             	mov    0x4(%eax),%eax
  802fe7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fea:	8b 12                	mov    (%edx),%edx
  802fec:	89 10                	mov    %edx,(%eax)
  802fee:	eb 0a                	jmp    802ffa <insert_sorted_with_merge_freeList+0x3e3>
  802ff0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ff3:	8b 00                	mov    (%eax),%eax
  802ff5:	a3 38 51 80 00       	mov    %eax,0x805138
  802ffa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ffd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803003:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803006:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80300d:	a1 44 51 80 00       	mov    0x805144,%eax
  803012:	48                   	dec    %eax
  803013:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803018:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80301b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803022:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803025:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80302c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803030:	75 17                	jne    803049 <insert_sorted_with_merge_freeList+0x432>
  803032:	83 ec 04             	sub    $0x4,%esp
  803035:	68 1c 3f 80 00       	push   $0x803f1c
  80303a:	68 5f 01 00 00       	push   $0x15f
  80303f:	68 3f 3f 80 00       	push   $0x803f3f
  803044:	e8 47 d2 ff ff       	call   800290 <_panic>
  803049:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80304f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803052:	89 10                	mov    %edx,(%eax)
  803054:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803057:	8b 00                	mov    (%eax),%eax
  803059:	85 c0                	test   %eax,%eax
  80305b:	74 0d                	je     80306a <insert_sorted_with_merge_freeList+0x453>
  80305d:	a1 48 51 80 00       	mov    0x805148,%eax
  803062:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803065:	89 50 04             	mov    %edx,0x4(%eax)
  803068:	eb 08                	jmp    803072 <insert_sorted_with_merge_freeList+0x45b>
  80306a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80306d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803072:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803075:	a3 48 51 80 00       	mov    %eax,0x805148
  80307a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80307d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803084:	a1 54 51 80 00       	mov    0x805154,%eax
  803089:	40                   	inc    %eax
  80308a:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  80308f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803092:	8b 50 0c             	mov    0xc(%eax),%edx
  803095:	8b 45 08             	mov    0x8(%ebp),%eax
  803098:	8b 40 0c             	mov    0xc(%eax),%eax
  80309b:	01 c2                	add    %eax,%edx
  80309d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a0:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8030a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8030ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8030b7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030bb:	75 17                	jne    8030d4 <insert_sorted_with_merge_freeList+0x4bd>
  8030bd:	83 ec 04             	sub    $0x4,%esp
  8030c0:	68 1c 3f 80 00       	push   $0x803f1c
  8030c5:	68 64 01 00 00       	push   $0x164
  8030ca:	68 3f 3f 80 00       	push   $0x803f3f
  8030cf:	e8 bc d1 ff ff       	call   800290 <_panic>
  8030d4:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8030da:	8b 45 08             	mov    0x8(%ebp),%eax
  8030dd:	89 10                	mov    %edx,(%eax)
  8030df:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e2:	8b 00                	mov    (%eax),%eax
  8030e4:	85 c0                	test   %eax,%eax
  8030e6:	74 0d                	je     8030f5 <insert_sorted_with_merge_freeList+0x4de>
  8030e8:	a1 48 51 80 00       	mov    0x805148,%eax
  8030ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8030f0:	89 50 04             	mov    %edx,0x4(%eax)
  8030f3:	eb 08                	jmp    8030fd <insert_sorted_with_merge_freeList+0x4e6>
  8030f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803100:	a3 48 51 80 00       	mov    %eax,0x805148
  803105:	8b 45 08             	mov    0x8(%ebp),%eax
  803108:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80310f:	a1 54 51 80 00       	mov    0x805154,%eax
  803114:	40                   	inc    %eax
  803115:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80311a:	e9 41 02 00 00       	jmp    803360 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80311f:	8b 45 08             	mov    0x8(%ebp),%eax
  803122:	8b 50 08             	mov    0x8(%eax),%edx
  803125:	8b 45 08             	mov    0x8(%ebp),%eax
  803128:	8b 40 0c             	mov    0xc(%eax),%eax
  80312b:	01 c2                	add    %eax,%edx
  80312d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803130:	8b 40 08             	mov    0x8(%eax),%eax
  803133:	39 c2                	cmp    %eax,%edx
  803135:	0f 85 7c 01 00 00    	jne    8032b7 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  80313b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80313f:	74 06                	je     803147 <insert_sorted_with_merge_freeList+0x530>
  803141:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803145:	75 17                	jne    80315e <insert_sorted_with_merge_freeList+0x547>
  803147:	83 ec 04             	sub    $0x4,%esp
  80314a:	68 58 3f 80 00       	push   $0x803f58
  80314f:	68 69 01 00 00       	push   $0x169
  803154:	68 3f 3f 80 00       	push   $0x803f3f
  803159:	e8 32 d1 ff ff       	call   800290 <_panic>
  80315e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803161:	8b 50 04             	mov    0x4(%eax),%edx
  803164:	8b 45 08             	mov    0x8(%ebp),%eax
  803167:	89 50 04             	mov    %edx,0x4(%eax)
  80316a:	8b 45 08             	mov    0x8(%ebp),%eax
  80316d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803170:	89 10                	mov    %edx,(%eax)
  803172:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803175:	8b 40 04             	mov    0x4(%eax),%eax
  803178:	85 c0                	test   %eax,%eax
  80317a:	74 0d                	je     803189 <insert_sorted_with_merge_freeList+0x572>
  80317c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80317f:	8b 40 04             	mov    0x4(%eax),%eax
  803182:	8b 55 08             	mov    0x8(%ebp),%edx
  803185:	89 10                	mov    %edx,(%eax)
  803187:	eb 08                	jmp    803191 <insert_sorted_with_merge_freeList+0x57a>
  803189:	8b 45 08             	mov    0x8(%ebp),%eax
  80318c:	a3 38 51 80 00       	mov    %eax,0x805138
  803191:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803194:	8b 55 08             	mov    0x8(%ebp),%edx
  803197:	89 50 04             	mov    %edx,0x4(%eax)
  80319a:	a1 44 51 80 00       	mov    0x805144,%eax
  80319f:	40                   	inc    %eax
  8031a0:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8031a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a8:	8b 50 0c             	mov    0xc(%eax),%edx
  8031ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ae:	8b 40 0c             	mov    0xc(%eax),%eax
  8031b1:	01 c2                	add    %eax,%edx
  8031b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b6:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8031b9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031bd:	75 17                	jne    8031d6 <insert_sorted_with_merge_freeList+0x5bf>
  8031bf:	83 ec 04             	sub    $0x4,%esp
  8031c2:	68 e8 3f 80 00       	push   $0x803fe8
  8031c7:	68 6b 01 00 00       	push   $0x16b
  8031cc:	68 3f 3f 80 00       	push   $0x803f3f
  8031d1:	e8 ba d0 ff ff       	call   800290 <_panic>
  8031d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d9:	8b 00                	mov    (%eax),%eax
  8031db:	85 c0                	test   %eax,%eax
  8031dd:	74 10                	je     8031ef <insert_sorted_with_merge_freeList+0x5d8>
  8031df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e2:	8b 00                	mov    (%eax),%eax
  8031e4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031e7:	8b 52 04             	mov    0x4(%edx),%edx
  8031ea:	89 50 04             	mov    %edx,0x4(%eax)
  8031ed:	eb 0b                	jmp    8031fa <insert_sorted_with_merge_freeList+0x5e3>
  8031ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f2:	8b 40 04             	mov    0x4(%eax),%eax
  8031f5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031fd:	8b 40 04             	mov    0x4(%eax),%eax
  803200:	85 c0                	test   %eax,%eax
  803202:	74 0f                	je     803213 <insert_sorted_with_merge_freeList+0x5fc>
  803204:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803207:	8b 40 04             	mov    0x4(%eax),%eax
  80320a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80320d:	8b 12                	mov    (%edx),%edx
  80320f:	89 10                	mov    %edx,(%eax)
  803211:	eb 0a                	jmp    80321d <insert_sorted_with_merge_freeList+0x606>
  803213:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803216:	8b 00                	mov    (%eax),%eax
  803218:	a3 38 51 80 00       	mov    %eax,0x805138
  80321d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803220:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803226:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803229:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803230:	a1 44 51 80 00       	mov    0x805144,%eax
  803235:	48                   	dec    %eax
  803236:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  80323b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80323e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803245:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803248:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80324f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803253:	75 17                	jne    80326c <insert_sorted_with_merge_freeList+0x655>
  803255:	83 ec 04             	sub    $0x4,%esp
  803258:	68 1c 3f 80 00       	push   $0x803f1c
  80325d:	68 6e 01 00 00       	push   $0x16e
  803262:	68 3f 3f 80 00       	push   $0x803f3f
  803267:	e8 24 d0 ff ff       	call   800290 <_panic>
  80326c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803272:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803275:	89 10                	mov    %edx,(%eax)
  803277:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80327a:	8b 00                	mov    (%eax),%eax
  80327c:	85 c0                	test   %eax,%eax
  80327e:	74 0d                	je     80328d <insert_sorted_with_merge_freeList+0x676>
  803280:	a1 48 51 80 00       	mov    0x805148,%eax
  803285:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803288:	89 50 04             	mov    %edx,0x4(%eax)
  80328b:	eb 08                	jmp    803295 <insert_sorted_with_merge_freeList+0x67e>
  80328d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803290:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803295:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803298:	a3 48 51 80 00       	mov    %eax,0x805148
  80329d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032a0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032a7:	a1 54 51 80 00       	mov    0x805154,%eax
  8032ac:	40                   	inc    %eax
  8032ad:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8032b2:	e9 a9 00 00 00       	jmp    803360 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8032b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032bb:	74 06                	je     8032c3 <insert_sorted_with_merge_freeList+0x6ac>
  8032bd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032c1:	75 17                	jne    8032da <insert_sorted_with_merge_freeList+0x6c3>
  8032c3:	83 ec 04             	sub    $0x4,%esp
  8032c6:	68 b4 3f 80 00       	push   $0x803fb4
  8032cb:	68 73 01 00 00       	push   $0x173
  8032d0:	68 3f 3f 80 00       	push   $0x803f3f
  8032d5:	e8 b6 cf ff ff       	call   800290 <_panic>
  8032da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032dd:	8b 10                	mov    (%eax),%edx
  8032df:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e2:	89 10                	mov    %edx,(%eax)
  8032e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e7:	8b 00                	mov    (%eax),%eax
  8032e9:	85 c0                	test   %eax,%eax
  8032eb:	74 0b                	je     8032f8 <insert_sorted_with_merge_freeList+0x6e1>
  8032ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f0:	8b 00                	mov    (%eax),%eax
  8032f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8032f5:	89 50 04             	mov    %edx,0x4(%eax)
  8032f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8032fe:	89 10                	mov    %edx,(%eax)
  803300:	8b 45 08             	mov    0x8(%ebp),%eax
  803303:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803306:	89 50 04             	mov    %edx,0x4(%eax)
  803309:	8b 45 08             	mov    0x8(%ebp),%eax
  80330c:	8b 00                	mov    (%eax),%eax
  80330e:	85 c0                	test   %eax,%eax
  803310:	75 08                	jne    80331a <insert_sorted_with_merge_freeList+0x703>
  803312:	8b 45 08             	mov    0x8(%ebp),%eax
  803315:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80331a:	a1 44 51 80 00       	mov    0x805144,%eax
  80331f:	40                   	inc    %eax
  803320:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803325:	eb 39                	jmp    803360 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803327:	a1 40 51 80 00       	mov    0x805140,%eax
  80332c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80332f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803333:	74 07                	je     80333c <insert_sorted_with_merge_freeList+0x725>
  803335:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803338:	8b 00                	mov    (%eax),%eax
  80333a:	eb 05                	jmp    803341 <insert_sorted_with_merge_freeList+0x72a>
  80333c:	b8 00 00 00 00       	mov    $0x0,%eax
  803341:	a3 40 51 80 00       	mov    %eax,0x805140
  803346:	a1 40 51 80 00       	mov    0x805140,%eax
  80334b:	85 c0                	test   %eax,%eax
  80334d:	0f 85 c7 fb ff ff    	jne    802f1a <insert_sorted_with_merge_freeList+0x303>
  803353:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803357:	0f 85 bd fb ff ff    	jne    802f1a <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80335d:	eb 01                	jmp    803360 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80335f:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803360:	90                   	nop
  803361:	c9                   	leave  
  803362:	c3                   	ret    

00803363 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803363:	55                   	push   %ebp
  803364:	89 e5                	mov    %esp,%ebp
  803366:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803369:	8b 55 08             	mov    0x8(%ebp),%edx
  80336c:	89 d0                	mov    %edx,%eax
  80336e:	c1 e0 02             	shl    $0x2,%eax
  803371:	01 d0                	add    %edx,%eax
  803373:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80337a:	01 d0                	add    %edx,%eax
  80337c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803383:	01 d0                	add    %edx,%eax
  803385:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80338c:	01 d0                	add    %edx,%eax
  80338e:	c1 e0 04             	shl    $0x4,%eax
  803391:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803394:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  80339b:	8d 45 e8             	lea    -0x18(%ebp),%eax
  80339e:	83 ec 0c             	sub    $0xc,%esp
  8033a1:	50                   	push   %eax
  8033a2:	e8 26 e7 ff ff       	call   801acd <sys_get_virtual_time>
  8033a7:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8033aa:	eb 41                	jmp    8033ed <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8033ac:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8033af:	83 ec 0c             	sub    $0xc,%esp
  8033b2:	50                   	push   %eax
  8033b3:	e8 15 e7 ff ff       	call   801acd <sys_get_virtual_time>
  8033b8:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8033bb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8033be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033c1:	29 c2                	sub    %eax,%edx
  8033c3:	89 d0                	mov    %edx,%eax
  8033c5:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8033c8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8033cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033ce:	89 d1                	mov    %edx,%ecx
  8033d0:	29 c1                	sub    %eax,%ecx
  8033d2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8033d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033d8:	39 c2                	cmp    %eax,%edx
  8033da:	0f 97 c0             	seta   %al
  8033dd:	0f b6 c0             	movzbl %al,%eax
  8033e0:	29 c1                	sub    %eax,%ecx
  8033e2:	89 c8                	mov    %ecx,%eax
  8033e4:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8033e7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8033ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8033ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8033f3:	72 b7                	jb     8033ac <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8033f5:	90                   	nop
  8033f6:	c9                   	leave  
  8033f7:	c3                   	ret    

008033f8 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8033f8:	55                   	push   %ebp
  8033f9:	89 e5                	mov    %esp,%ebp
  8033fb:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8033fe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803405:	eb 03                	jmp    80340a <busy_wait+0x12>
  803407:	ff 45 fc             	incl   -0x4(%ebp)
  80340a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80340d:	3b 45 08             	cmp    0x8(%ebp),%eax
  803410:	72 f5                	jb     803407 <busy_wait+0xf>
	return i;
  803412:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803415:	c9                   	leave  
  803416:	c3                   	ret    
  803417:	90                   	nop

00803418 <__udivdi3>:
  803418:	55                   	push   %ebp
  803419:	57                   	push   %edi
  80341a:	56                   	push   %esi
  80341b:	53                   	push   %ebx
  80341c:	83 ec 1c             	sub    $0x1c,%esp
  80341f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803423:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803427:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80342b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80342f:	89 ca                	mov    %ecx,%edx
  803431:	89 f8                	mov    %edi,%eax
  803433:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803437:	85 f6                	test   %esi,%esi
  803439:	75 2d                	jne    803468 <__udivdi3+0x50>
  80343b:	39 cf                	cmp    %ecx,%edi
  80343d:	77 65                	ja     8034a4 <__udivdi3+0x8c>
  80343f:	89 fd                	mov    %edi,%ebp
  803441:	85 ff                	test   %edi,%edi
  803443:	75 0b                	jne    803450 <__udivdi3+0x38>
  803445:	b8 01 00 00 00       	mov    $0x1,%eax
  80344a:	31 d2                	xor    %edx,%edx
  80344c:	f7 f7                	div    %edi
  80344e:	89 c5                	mov    %eax,%ebp
  803450:	31 d2                	xor    %edx,%edx
  803452:	89 c8                	mov    %ecx,%eax
  803454:	f7 f5                	div    %ebp
  803456:	89 c1                	mov    %eax,%ecx
  803458:	89 d8                	mov    %ebx,%eax
  80345a:	f7 f5                	div    %ebp
  80345c:	89 cf                	mov    %ecx,%edi
  80345e:	89 fa                	mov    %edi,%edx
  803460:	83 c4 1c             	add    $0x1c,%esp
  803463:	5b                   	pop    %ebx
  803464:	5e                   	pop    %esi
  803465:	5f                   	pop    %edi
  803466:	5d                   	pop    %ebp
  803467:	c3                   	ret    
  803468:	39 ce                	cmp    %ecx,%esi
  80346a:	77 28                	ja     803494 <__udivdi3+0x7c>
  80346c:	0f bd fe             	bsr    %esi,%edi
  80346f:	83 f7 1f             	xor    $0x1f,%edi
  803472:	75 40                	jne    8034b4 <__udivdi3+0x9c>
  803474:	39 ce                	cmp    %ecx,%esi
  803476:	72 0a                	jb     803482 <__udivdi3+0x6a>
  803478:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80347c:	0f 87 9e 00 00 00    	ja     803520 <__udivdi3+0x108>
  803482:	b8 01 00 00 00       	mov    $0x1,%eax
  803487:	89 fa                	mov    %edi,%edx
  803489:	83 c4 1c             	add    $0x1c,%esp
  80348c:	5b                   	pop    %ebx
  80348d:	5e                   	pop    %esi
  80348e:	5f                   	pop    %edi
  80348f:	5d                   	pop    %ebp
  803490:	c3                   	ret    
  803491:	8d 76 00             	lea    0x0(%esi),%esi
  803494:	31 ff                	xor    %edi,%edi
  803496:	31 c0                	xor    %eax,%eax
  803498:	89 fa                	mov    %edi,%edx
  80349a:	83 c4 1c             	add    $0x1c,%esp
  80349d:	5b                   	pop    %ebx
  80349e:	5e                   	pop    %esi
  80349f:	5f                   	pop    %edi
  8034a0:	5d                   	pop    %ebp
  8034a1:	c3                   	ret    
  8034a2:	66 90                	xchg   %ax,%ax
  8034a4:	89 d8                	mov    %ebx,%eax
  8034a6:	f7 f7                	div    %edi
  8034a8:	31 ff                	xor    %edi,%edi
  8034aa:	89 fa                	mov    %edi,%edx
  8034ac:	83 c4 1c             	add    $0x1c,%esp
  8034af:	5b                   	pop    %ebx
  8034b0:	5e                   	pop    %esi
  8034b1:	5f                   	pop    %edi
  8034b2:	5d                   	pop    %ebp
  8034b3:	c3                   	ret    
  8034b4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8034b9:	89 eb                	mov    %ebp,%ebx
  8034bb:	29 fb                	sub    %edi,%ebx
  8034bd:	89 f9                	mov    %edi,%ecx
  8034bf:	d3 e6                	shl    %cl,%esi
  8034c1:	89 c5                	mov    %eax,%ebp
  8034c3:	88 d9                	mov    %bl,%cl
  8034c5:	d3 ed                	shr    %cl,%ebp
  8034c7:	89 e9                	mov    %ebp,%ecx
  8034c9:	09 f1                	or     %esi,%ecx
  8034cb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8034cf:	89 f9                	mov    %edi,%ecx
  8034d1:	d3 e0                	shl    %cl,%eax
  8034d3:	89 c5                	mov    %eax,%ebp
  8034d5:	89 d6                	mov    %edx,%esi
  8034d7:	88 d9                	mov    %bl,%cl
  8034d9:	d3 ee                	shr    %cl,%esi
  8034db:	89 f9                	mov    %edi,%ecx
  8034dd:	d3 e2                	shl    %cl,%edx
  8034df:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034e3:	88 d9                	mov    %bl,%cl
  8034e5:	d3 e8                	shr    %cl,%eax
  8034e7:	09 c2                	or     %eax,%edx
  8034e9:	89 d0                	mov    %edx,%eax
  8034eb:	89 f2                	mov    %esi,%edx
  8034ed:	f7 74 24 0c          	divl   0xc(%esp)
  8034f1:	89 d6                	mov    %edx,%esi
  8034f3:	89 c3                	mov    %eax,%ebx
  8034f5:	f7 e5                	mul    %ebp
  8034f7:	39 d6                	cmp    %edx,%esi
  8034f9:	72 19                	jb     803514 <__udivdi3+0xfc>
  8034fb:	74 0b                	je     803508 <__udivdi3+0xf0>
  8034fd:	89 d8                	mov    %ebx,%eax
  8034ff:	31 ff                	xor    %edi,%edi
  803501:	e9 58 ff ff ff       	jmp    80345e <__udivdi3+0x46>
  803506:	66 90                	xchg   %ax,%ax
  803508:	8b 54 24 08          	mov    0x8(%esp),%edx
  80350c:	89 f9                	mov    %edi,%ecx
  80350e:	d3 e2                	shl    %cl,%edx
  803510:	39 c2                	cmp    %eax,%edx
  803512:	73 e9                	jae    8034fd <__udivdi3+0xe5>
  803514:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803517:	31 ff                	xor    %edi,%edi
  803519:	e9 40 ff ff ff       	jmp    80345e <__udivdi3+0x46>
  80351e:	66 90                	xchg   %ax,%ax
  803520:	31 c0                	xor    %eax,%eax
  803522:	e9 37 ff ff ff       	jmp    80345e <__udivdi3+0x46>
  803527:	90                   	nop

00803528 <__umoddi3>:
  803528:	55                   	push   %ebp
  803529:	57                   	push   %edi
  80352a:	56                   	push   %esi
  80352b:	53                   	push   %ebx
  80352c:	83 ec 1c             	sub    $0x1c,%esp
  80352f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803533:	8b 74 24 34          	mov    0x34(%esp),%esi
  803537:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80353b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80353f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803543:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803547:	89 f3                	mov    %esi,%ebx
  803549:	89 fa                	mov    %edi,%edx
  80354b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80354f:	89 34 24             	mov    %esi,(%esp)
  803552:	85 c0                	test   %eax,%eax
  803554:	75 1a                	jne    803570 <__umoddi3+0x48>
  803556:	39 f7                	cmp    %esi,%edi
  803558:	0f 86 a2 00 00 00    	jbe    803600 <__umoddi3+0xd8>
  80355e:	89 c8                	mov    %ecx,%eax
  803560:	89 f2                	mov    %esi,%edx
  803562:	f7 f7                	div    %edi
  803564:	89 d0                	mov    %edx,%eax
  803566:	31 d2                	xor    %edx,%edx
  803568:	83 c4 1c             	add    $0x1c,%esp
  80356b:	5b                   	pop    %ebx
  80356c:	5e                   	pop    %esi
  80356d:	5f                   	pop    %edi
  80356e:	5d                   	pop    %ebp
  80356f:	c3                   	ret    
  803570:	39 f0                	cmp    %esi,%eax
  803572:	0f 87 ac 00 00 00    	ja     803624 <__umoddi3+0xfc>
  803578:	0f bd e8             	bsr    %eax,%ebp
  80357b:	83 f5 1f             	xor    $0x1f,%ebp
  80357e:	0f 84 ac 00 00 00    	je     803630 <__umoddi3+0x108>
  803584:	bf 20 00 00 00       	mov    $0x20,%edi
  803589:	29 ef                	sub    %ebp,%edi
  80358b:	89 fe                	mov    %edi,%esi
  80358d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803591:	89 e9                	mov    %ebp,%ecx
  803593:	d3 e0                	shl    %cl,%eax
  803595:	89 d7                	mov    %edx,%edi
  803597:	89 f1                	mov    %esi,%ecx
  803599:	d3 ef                	shr    %cl,%edi
  80359b:	09 c7                	or     %eax,%edi
  80359d:	89 e9                	mov    %ebp,%ecx
  80359f:	d3 e2                	shl    %cl,%edx
  8035a1:	89 14 24             	mov    %edx,(%esp)
  8035a4:	89 d8                	mov    %ebx,%eax
  8035a6:	d3 e0                	shl    %cl,%eax
  8035a8:	89 c2                	mov    %eax,%edx
  8035aa:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035ae:	d3 e0                	shl    %cl,%eax
  8035b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8035b4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035b8:	89 f1                	mov    %esi,%ecx
  8035ba:	d3 e8                	shr    %cl,%eax
  8035bc:	09 d0                	or     %edx,%eax
  8035be:	d3 eb                	shr    %cl,%ebx
  8035c0:	89 da                	mov    %ebx,%edx
  8035c2:	f7 f7                	div    %edi
  8035c4:	89 d3                	mov    %edx,%ebx
  8035c6:	f7 24 24             	mull   (%esp)
  8035c9:	89 c6                	mov    %eax,%esi
  8035cb:	89 d1                	mov    %edx,%ecx
  8035cd:	39 d3                	cmp    %edx,%ebx
  8035cf:	0f 82 87 00 00 00    	jb     80365c <__umoddi3+0x134>
  8035d5:	0f 84 91 00 00 00    	je     80366c <__umoddi3+0x144>
  8035db:	8b 54 24 04          	mov    0x4(%esp),%edx
  8035df:	29 f2                	sub    %esi,%edx
  8035e1:	19 cb                	sbb    %ecx,%ebx
  8035e3:	89 d8                	mov    %ebx,%eax
  8035e5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8035e9:	d3 e0                	shl    %cl,%eax
  8035eb:	89 e9                	mov    %ebp,%ecx
  8035ed:	d3 ea                	shr    %cl,%edx
  8035ef:	09 d0                	or     %edx,%eax
  8035f1:	89 e9                	mov    %ebp,%ecx
  8035f3:	d3 eb                	shr    %cl,%ebx
  8035f5:	89 da                	mov    %ebx,%edx
  8035f7:	83 c4 1c             	add    $0x1c,%esp
  8035fa:	5b                   	pop    %ebx
  8035fb:	5e                   	pop    %esi
  8035fc:	5f                   	pop    %edi
  8035fd:	5d                   	pop    %ebp
  8035fe:	c3                   	ret    
  8035ff:	90                   	nop
  803600:	89 fd                	mov    %edi,%ebp
  803602:	85 ff                	test   %edi,%edi
  803604:	75 0b                	jne    803611 <__umoddi3+0xe9>
  803606:	b8 01 00 00 00       	mov    $0x1,%eax
  80360b:	31 d2                	xor    %edx,%edx
  80360d:	f7 f7                	div    %edi
  80360f:	89 c5                	mov    %eax,%ebp
  803611:	89 f0                	mov    %esi,%eax
  803613:	31 d2                	xor    %edx,%edx
  803615:	f7 f5                	div    %ebp
  803617:	89 c8                	mov    %ecx,%eax
  803619:	f7 f5                	div    %ebp
  80361b:	89 d0                	mov    %edx,%eax
  80361d:	e9 44 ff ff ff       	jmp    803566 <__umoddi3+0x3e>
  803622:	66 90                	xchg   %ax,%ax
  803624:	89 c8                	mov    %ecx,%eax
  803626:	89 f2                	mov    %esi,%edx
  803628:	83 c4 1c             	add    $0x1c,%esp
  80362b:	5b                   	pop    %ebx
  80362c:	5e                   	pop    %esi
  80362d:	5f                   	pop    %edi
  80362e:	5d                   	pop    %ebp
  80362f:	c3                   	ret    
  803630:	3b 04 24             	cmp    (%esp),%eax
  803633:	72 06                	jb     80363b <__umoddi3+0x113>
  803635:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803639:	77 0f                	ja     80364a <__umoddi3+0x122>
  80363b:	89 f2                	mov    %esi,%edx
  80363d:	29 f9                	sub    %edi,%ecx
  80363f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803643:	89 14 24             	mov    %edx,(%esp)
  803646:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80364a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80364e:	8b 14 24             	mov    (%esp),%edx
  803651:	83 c4 1c             	add    $0x1c,%esp
  803654:	5b                   	pop    %ebx
  803655:	5e                   	pop    %esi
  803656:	5f                   	pop    %edi
  803657:	5d                   	pop    %ebp
  803658:	c3                   	ret    
  803659:	8d 76 00             	lea    0x0(%esi),%esi
  80365c:	2b 04 24             	sub    (%esp),%eax
  80365f:	19 fa                	sbb    %edi,%edx
  803661:	89 d1                	mov    %edx,%ecx
  803663:	89 c6                	mov    %eax,%esi
  803665:	e9 71 ff ff ff       	jmp    8035db <__umoddi3+0xb3>
  80366a:	66 90                	xchg   %ax,%ax
  80366c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803670:	72 ea                	jb     80365c <__umoddi3+0x134>
  803672:	89 d9                	mov    %ebx,%ecx
  803674:	e9 62 ff ff ff       	jmp    8035db <__umoddi3+0xb3>
