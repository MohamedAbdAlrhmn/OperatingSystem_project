
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
  80008c:	68 60 36 80 00       	push   $0x803660
  800091:	6a 12                	push   $0x12
  800093:	68 7c 36 80 00       	push   $0x80367c
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
  8000aa:	e8 c3 19 00 00       	call   801a72 <sys_getparentenvid>
  8000af:	83 ec 08             	sub    $0x8,%esp
  8000b2:	68 99 36 80 00       	push   $0x803699
  8000b7:	50                   	push   %eax
  8000b8:	e8 18 15 00 00       	call   8015d5 <sget>
  8000bd:	83 c4 10             	add    $0x10,%esp
  8000c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("Slave B1 env used x (getSharedObject)\n");
  8000c3:	83 ec 0c             	sub    $0xc,%esp
  8000c6:	68 9c 36 80 00       	push   $0x80369c
  8000cb:	e8 74 04 00 00       	call   800544 <cprintf>
  8000d0:	83 c4 10             	add    $0x10,%esp
	//To indicate that it's successfully got x
	inctst();
  8000d3:	e8 bf 1a 00 00       	call   801b97 <inctst>
	cprintf("Slave B1 please be patient ...\n");
  8000d8:	83 ec 0c             	sub    $0xc,%esp
  8000db:	68 c4 36 80 00       	push   $0x8036c4
  8000e0:	e8 5f 04 00 00       	call   800544 <cprintf>
  8000e5:	83 c4 10             	add    $0x10,%esp

	//sleep a while to allow the master to remove x & z
	env_sleep(6000);
  8000e8:	83 ec 0c             	sub    $0xc,%esp
  8000eb:	68 70 17 00 00       	push   $0x1770
  8000f0:	e8 46 32 00 00       	call   80333b <env_sleep>
  8000f5:	83 c4 10             	add    $0x10,%esp

	int freeFrames = sys_calculate_free_frames() ;
  8000f8:	e8 7c 16 00 00       	call   801779 <sys_calculate_free_frames>
  8000fd:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sfree(x);
  800100:	83 ec 0c             	sub    $0xc,%esp
  800103:	ff 75 ec             	pushl  -0x14(%ebp)
  800106:	e8 0e 15 00 00       	call   801619 <sfree>
  80010b:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave B1 env removed x\n");
  80010e:	83 ec 0c             	sub    $0xc,%esp
  800111:	68 e4 36 80 00       	push   $0x8036e4
  800116:	e8 29 04 00 00       	call   800544 <cprintf>
  80011b:	83 c4 10             	add    $0x10,%esp
	int expected = (1+1) + (1+1);
  80011e:	c7 45 e4 04 00 00 00 	movl   $0x4,-0x1c(%ebp)
	if ((sys_calculate_free_frames() - freeFrames) !=  expected) panic("B1 wrong free: frames removed not equal 4 !, correct frames to be removed are 4:\nfrom the env: 1 table and 1 for frame of x\nframes_storage of x: should be cleared now\n");
  800125:	e8 4f 16 00 00       	call   801779 <sys_calculate_free_frames>
  80012a:	89 c2                	mov    %eax,%edx
  80012c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80012f:	29 c2                	sub    %eax,%edx
  800131:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800134:	39 c2                	cmp    %eax,%edx
  800136:	74 14                	je     80014c <_main+0x114>
  800138:	83 ec 04             	sub    $0x4,%esp
  80013b:	68 fc 36 80 00       	push   $0x8036fc
  800140:	6a 27                	push   $0x27
  800142:	68 7c 36 80 00       	push   $0x80367c
  800147:	e8 44 01 00 00       	call   800290 <_panic>

	//To indicate that it's completed successfully
	inctst();
  80014c:	e8 46 1a 00 00       	call   801b97 <inctst>
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
  80015a:	e8 fa 18 00 00       	call   801a59 <sys_getenvindex>
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
  8001c5:	e8 9c 16 00 00       	call   801866 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001ca:	83 ec 0c             	sub    $0xc,%esp
  8001cd:	68 bc 37 80 00       	push   $0x8037bc
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
  8001f5:	68 e4 37 80 00       	push   $0x8037e4
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
  800226:	68 0c 38 80 00       	push   $0x80380c
  80022b:	e8 14 03 00 00       	call   800544 <cprintf>
  800230:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800233:	a1 20 50 80 00       	mov    0x805020,%eax
  800238:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80023e:	83 ec 08             	sub    $0x8,%esp
  800241:	50                   	push   %eax
  800242:	68 64 38 80 00       	push   $0x803864
  800247:	e8 f8 02 00 00       	call   800544 <cprintf>
  80024c:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80024f:	83 ec 0c             	sub    $0xc,%esp
  800252:	68 bc 37 80 00       	push   $0x8037bc
  800257:	e8 e8 02 00 00       	call   800544 <cprintf>
  80025c:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80025f:	e8 1c 16 00 00       	call   801880 <sys_enable_interrupt>

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
  800277:	e8 a9 17 00 00       	call   801a25 <sys_destroy_env>
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
  800288:	e8 fe 17 00 00       	call   801a8b <sys_exit_env>
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
  8002b1:	68 78 38 80 00       	push   $0x803878
  8002b6:	e8 89 02 00 00       	call   800544 <cprintf>
  8002bb:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002be:	a1 00 50 80 00       	mov    0x805000,%eax
  8002c3:	ff 75 0c             	pushl  0xc(%ebp)
  8002c6:	ff 75 08             	pushl  0x8(%ebp)
  8002c9:	50                   	push   %eax
  8002ca:	68 7d 38 80 00       	push   $0x80387d
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
  8002ee:	68 99 38 80 00       	push   $0x803899
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
  80031a:	68 9c 38 80 00       	push   $0x80389c
  80031f:	6a 26                	push   $0x26
  800321:	68 e8 38 80 00       	push   $0x8038e8
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
  8003ec:	68 f4 38 80 00       	push   $0x8038f4
  8003f1:	6a 3a                	push   $0x3a
  8003f3:	68 e8 38 80 00       	push   $0x8038e8
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
  80045c:	68 48 39 80 00       	push   $0x803948
  800461:	6a 44                	push   $0x44
  800463:	68 e8 38 80 00       	push   $0x8038e8
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
  8004b6:	e8 fd 11 00 00       	call   8016b8 <sys_cputs>
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
  80052d:	e8 86 11 00 00       	call   8016b8 <sys_cputs>
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
  800577:	e8 ea 12 00 00       	call   801866 <sys_disable_interrupt>
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
  800597:	e8 e4 12 00 00       	call   801880 <sys_enable_interrupt>
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
  8005e1:	e8 0a 2e 00 00       	call   8033f0 <__udivdi3>
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
  800631:	e8 ca 2e 00 00       	call   803500 <__umoddi3>
  800636:	83 c4 10             	add    $0x10,%esp
  800639:	05 b4 3b 80 00       	add    $0x803bb4,%eax
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
  80078c:	8b 04 85 d8 3b 80 00 	mov    0x803bd8(,%eax,4),%eax
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
  80086d:	8b 34 9d 20 3a 80 00 	mov    0x803a20(,%ebx,4),%esi
  800874:	85 f6                	test   %esi,%esi
  800876:	75 19                	jne    800891 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800878:	53                   	push   %ebx
  800879:	68 c5 3b 80 00       	push   $0x803bc5
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
  800892:	68 ce 3b 80 00       	push   $0x803bce
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
  8008bf:	be d1 3b 80 00       	mov    $0x803bd1,%esi
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
  8012e5:	68 30 3d 80 00       	push   $0x803d30
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
  8013b5:	e8 42 04 00 00       	call   8017fc <sys_allocate_chunk>
  8013ba:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013bd:	a1 20 51 80 00       	mov    0x805120,%eax
  8013c2:	83 ec 0c             	sub    $0xc,%esp
  8013c5:	50                   	push   %eax
  8013c6:	e8 b7 0a 00 00       	call   801e82 <initialize_MemBlocksList>
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
  8013f3:	68 55 3d 80 00       	push   $0x803d55
  8013f8:	6a 33                	push   $0x33
  8013fa:	68 73 3d 80 00       	push   $0x803d73
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
  801472:	68 80 3d 80 00       	push   $0x803d80
  801477:	6a 34                	push   $0x34
  801479:	68 73 3d 80 00       	push   $0x803d73
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
  8014cf:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8014d2:	e8 f7 fd ff ff       	call   8012ce <InitializeUHeap>
	if (size == 0) return NULL ;
  8014d7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014db:	75 07                	jne    8014e4 <malloc+0x18>
  8014dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8014e2:	eb 14                	jmp    8014f8 <malloc+0x2c>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  8014e4:	83 ec 04             	sub    $0x4,%esp
  8014e7:	68 a4 3d 80 00       	push   $0x803da4
  8014ec:	6a 46                	push   $0x46
  8014ee:	68 73 3d 80 00       	push   $0x803d73
  8014f3:	e8 98 ed ff ff       	call   800290 <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  8014f8:	c9                   	leave  
  8014f9:	c3                   	ret    

008014fa <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8014fa:	55                   	push   %ebp
  8014fb:	89 e5                	mov    %esp,%ebp
  8014fd:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801500:	83 ec 04             	sub    $0x4,%esp
  801503:	68 cc 3d 80 00       	push   $0x803dcc
  801508:	6a 61                	push   $0x61
  80150a:	68 73 3d 80 00       	push   $0x803d73
  80150f:	e8 7c ed ff ff       	call   800290 <_panic>

00801514 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801514:	55                   	push   %ebp
  801515:	89 e5                	mov    %esp,%ebp
  801517:	83 ec 38             	sub    $0x38,%esp
  80151a:	8b 45 10             	mov    0x10(%ebp),%eax
  80151d:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801520:	e8 a9 fd ff ff       	call   8012ce <InitializeUHeap>
	if (size == 0) return NULL ;
  801525:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801529:	75 0a                	jne    801535 <smalloc+0x21>
  80152b:	b8 00 00 00 00       	mov    $0x0,%eax
  801530:	e9 9e 00 00 00       	jmp    8015d3 <smalloc+0xbf>
	//3-If the Kernel successfully creates the shared variable, return its virtual address
	//4-Else, return NULL



	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801535:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80153c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80153f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801542:	01 d0                	add    %edx,%eax
  801544:	48                   	dec    %eax
  801545:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801548:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80154b:	ba 00 00 00 00       	mov    $0x0,%edx
  801550:	f7 75 f0             	divl   -0x10(%ebp)
  801553:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801556:	29 d0                	sub    %edx,%eax
  801558:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  80155b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801562:	e8 63 06 00 00       	call   801bca <sys_isUHeapPlacementStrategyFIRSTFIT>
  801567:	85 c0                	test   %eax,%eax
  801569:	74 11                	je     80157c <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  80156b:	83 ec 0c             	sub    $0xc,%esp
  80156e:	ff 75 e8             	pushl  -0x18(%ebp)
  801571:	e8 ce 0c 00 00       	call   802244 <alloc_block_FF>
  801576:	83 c4 10             	add    $0x10,%esp
  801579:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  80157c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801580:	74 4c                	je     8015ce <smalloc+0xba>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801582:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801585:	8b 40 08             	mov    0x8(%eax),%eax
  801588:	89 c2                	mov    %eax,%edx
  80158a:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  80158e:	52                   	push   %edx
  80158f:	50                   	push   %eax
  801590:	ff 75 0c             	pushl  0xc(%ebp)
  801593:	ff 75 08             	pushl  0x8(%ebp)
  801596:	e8 b4 03 00 00       	call   80194f <sys_createSharedObject>
  80159b:	83 c4 10             	add    $0x10,%esp
  80159e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cprintf("Output is :  %d \n" , result);
  8015a1:	83 ec 08             	sub    $0x8,%esp
  8015a4:	ff 75 e0             	pushl  -0x20(%ebp)
  8015a7:	68 ef 3d 80 00       	push   $0x803def
  8015ac:	e8 93 ef ff ff       	call   800544 <cprintf>
  8015b1:	83 c4 10             	add    $0x10,%esp
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  8015b4:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  8015b8:	74 14                	je     8015ce <smalloc+0xba>
  8015ba:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  8015be:	74 0e                	je     8015ce <smalloc+0xba>
  8015c0:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  8015c4:	74 08                	je     8015ce <smalloc+0xba>
			return (void*) mem_block->sva;
  8015c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015c9:	8b 40 08             	mov    0x8(%eax),%eax
  8015cc:	eb 05                	jmp    8015d3 <smalloc+0xbf>
	}
	return NULL;
  8015ce:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8015d3:	c9                   	leave  
  8015d4:	c3                   	ret    

008015d5 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8015d5:	55                   	push   %ebp
  8015d6:	89 e5                	mov    %esp,%ebp
  8015d8:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015db:	e8 ee fc ff ff       	call   8012ce <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8015e0:	83 ec 04             	sub    $0x4,%esp
  8015e3:	68 04 3e 80 00       	push   $0x803e04
  8015e8:	68 ab 00 00 00       	push   $0xab
  8015ed:	68 73 3d 80 00       	push   $0x803d73
  8015f2:	e8 99 ec ff ff       	call   800290 <_panic>

008015f7 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8015f7:	55                   	push   %ebp
  8015f8:	89 e5                	mov    %esp,%ebp
  8015fa:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015fd:	e8 cc fc ff ff       	call   8012ce <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801602:	83 ec 04             	sub    $0x4,%esp
  801605:	68 28 3e 80 00       	push   $0x803e28
  80160a:	68 ef 00 00 00       	push   $0xef
  80160f:	68 73 3d 80 00       	push   $0x803d73
  801614:	e8 77 ec ff ff       	call   800290 <_panic>

00801619 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801619:	55                   	push   %ebp
  80161a:	89 e5                	mov    %esp,%ebp
  80161c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80161f:	83 ec 04             	sub    $0x4,%esp
  801622:	68 50 3e 80 00       	push   $0x803e50
  801627:	68 03 01 00 00       	push   $0x103
  80162c:	68 73 3d 80 00       	push   $0x803d73
  801631:	e8 5a ec ff ff       	call   800290 <_panic>

00801636 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801636:	55                   	push   %ebp
  801637:	89 e5                	mov    %esp,%ebp
  801639:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80163c:	83 ec 04             	sub    $0x4,%esp
  80163f:	68 74 3e 80 00       	push   $0x803e74
  801644:	68 0e 01 00 00       	push   $0x10e
  801649:	68 73 3d 80 00       	push   $0x803d73
  80164e:	e8 3d ec ff ff       	call   800290 <_panic>

00801653 <shrink>:

}
void shrink(uint32 newSize)
{
  801653:	55                   	push   %ebp
  801654:	89 e5                	mov    %esp,%ebp
  801656:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801659:	83 ec 04             	sub    $0x4,%esp
  80165c:	68 74 3e 80 00       	push   $0x803e74
  801661:	68 13 01 00 00       	push   $0x113
  801666:	68 73 3d 80 00       	push   $0x803d73
  80166b:	e8 20 ec ff ff       	call   800290 <_panic>

00801670 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801670:	55                   	push   %ebp
  801671:	89 e5                	mov    %esp,%ebp
  801673:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801676:	83 ec 04             	sub    $0x4,%esp
  801679:	68 74 3e 80 00       	push   $0x803e74
  80167e:	68 18 01 00 00       	push   $0x118
  801683:	68 73 3d 80 00       	push   $0x803d73
  801688:	e8 03 ec ff ff       	call   800290 <_panic>

0080168d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80168d:	55                   	push   %ebp
  80168e:	89 e5                	mov    %esp,%ebp
  801690:	57                   	push   %edi
  801691:	56                   	push   %esi
  801692:	53                   	push   %ebx
  801693:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801696:	8b 45 08             	mov    0x8(%ebp),%eax
  801699:	8b 55 0c             	mov    0xc(%ebp),%edx
  80169c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80169f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016a2:	8b 7d 18             	mov    0x18(%ebp),%edi
  8016a5:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8016a8:	cd 30                	int    $0x30
  8016aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8016ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8016b0:	83 c4 10             	add    $0x10,%esp
  8016b3:	5b                   	pop    %ebx
  8016b4:	5e                   	pop    %esi
  8016b5:	5f                   	pop    %edi
  8016b6:	5d                   	pop    %ebp
  8016b7:	c3                   	ret    

008016b8 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8016b8:	55                   	push   %ebp
  8016b9:	89 e5                	mov    %esp,%ebp
  8016bb:	83 ec 04             	sub    $0x4,%esp
  8016be:	8b 45 10             	mov    0x10(%ebp),%eax
  8016c1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8016c4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8016c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cb:	6a 00                	push   $0x0
  8016cd:	6a 00                	push   $0x0
  8016cf:	52                   	push   %edx
  8016d0:	ff 75 0c             	pushl  0xc(%ebp)
  8016d3:	50                   	push   %eax
  8016d4:	6a 00                	push   $0x0
  8016d6:	e8 b2 ff ff ff       	call   80168d <syscall>
  8016db:	83 c4 18             	add    $0x18,%esp
}
  8016de:	90                   	nop
  8016df:	c9                   	leave  
  8016e0:	c3                   	ret    

008016e1 <sys_cgetc>:

int
sys_cgetc(void)
{
  8016e1:	55                   	push   %ebp
  8016e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8016e4:	6a 00                	push   $0x0
  8016e6:	6a 00                	push   $0x0
  8016e8:	6a 00                	push   $0x0
  8016ea:	6a 00                	push   $0x0
  8016ec:	6a 00                	push   $0x0
  8016ee:	6a 01                	push   $0x1
  8016f0:	e8 98 ff ff ff       	call   80168d <syscall>
  8016f5:	83 c4 18             	add    $0x18,%esp
}
  8016f8:	c9                   	leave  
  8016f9:	c3                   	ret    

008016fa <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8016fa:	55                   	push   %ebp
  8016fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8016fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801700:	8b 45 08             	mov    0x8(%ebp),%eax
  801703:	6a 00                	push   $0x0
  801705:	6a 00                	push   $0x0
  801707:	6a 00                	push   $0x0
  801709:	52                   	push   %edx
  80170a:	50                   	push   %eax
  80170b:	6a 05                	push   $0x5
  80170d:	e8 7b ff ff ff       	call   80168d <syscall>
  801712:	83 c4 18             	add    $0x18,%esp
}
  801715:	c9                   	leave  
  801716:	c3                   	ret    

00801717 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801717:	55                   	push   %ebp
  801718:	89 e5                	mov    %esp,%ebp
  80171a:	56                   	push   %esi
  80171b:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80171c:	8b 75 18             	mov    0x18(%ebp),%esi
  80171f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801722:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801725:	8b 55 0c             	mov    0xc(%ebp),%edx
  801728:	8b 45 08             	mov    0x8(%ebp),%eax
  80172b:	56                   	push   %esi
  80172c:	53                   	push   %ebx
  80172d:	51                   	push   %ecx
  80172e:	52                   	push   %edx
  80172f:	50                   	push   %eax
  801730:	6a 06                	push   $0x6
  801732:	e8 56 ff ff ff       	call   80168d <syscall>
  801737:	83 c4 18             	add    $0x18,%esp
}
  80173a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80173d:	5b                   	pop    %ebx
  80173e:	5e                   	pop    %esi
  80173f:	5d                   	pop    %ebp
  801740:	c3                   	ret    

00801741 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801741:	55                   	push   %ebp
  801742:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801744:	8b 55 0c             	mov    0xc(%ebp),%edx
  801747:	8b 45 08             	mov    0x8(%ebp),%eax
  80174a:	6a 00                	push   $0x0
  80174c:	6a 00                	push   $0x0
  80174e:	6a 00                	push   $0x0
  801750:	52                   	push   %edx
  801751:	50                   	push   %eax
  801752:	6a 07                	push   $0x7
  801754:	e8 34 ff ff ff       	call   80168d <syscall>
  801759:	83 c4 18             	add    $0x18,%esp
}
  80175c:	c9                   	leave  
  80175d:	c3                   	ret    

0080175e <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80175e:	55                   	push   %ebp
  80175f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801761:	6a 00                	push   $0x0
  801763:	6a 00                	push   $0x0
  801765:	6a 00                	push   $0x0
  801767:	ff 75 0c             	pushl  0xc(%ebp)
  80176a:	ff 75 08             	pushl  0x8(%ebp)
  80176d:	6a 08                	push   $0x8
  80176f:	e8 19 ff ff ff       	call   80168d <syscall>
  801774:	83 c4 18             	add    $0x18,%esp
}
  801777:	c9                   	leave  
  801778:	c3                   	ret    

00801779 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801779:	55                   	push   %ebp
  80177a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80177c:	6a 00                	push   $0x0
  80177e:	6a 00                	push   $0x0
  801780:	6a 00                	push   $0x0
  801782:	6a 00                	push   $0x0
  801784:	6a 00                	push   $0x0
  801786:	6a 09                	push   $0x9
  801788:	e8 00 ff ff ff       	call   80168d <syscall>
  80178d:	83 c4 18             	add    $0x18,%esp
}
  801790:	c9                   	leave  
  801791:	c3                   	ret    

00801792 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801792:	55                   	push   %ebp
  801793:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801795:	6a 00                	push   $0x0
  801797:	6a 00                	push   $0x0
  801799:	6a 00                	push   $0x0
  80179b:	6a 00                	push   $0x0
  80179d:	6a 00                	push   $0x0
  80179f:	6a 0a                	push   $0xa
  8017a1:	e8 e7 fe ff ff       	call   80168d <syscall>
  8017a6:	83 c4 18             	add    $0x18,%esp
}
  8017a9:	c9                   	leave  
  8017aa:	c3                   	ret    

008017ab <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8017ab:	55                   	push   %ebp
  8017ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8017ae:	6a 00                	push   $0x0
  8017b0:	6a 00                	push   $0x0
  8017b2:	6a 00                	push   $0x0
  8017b4:	6a 00                	push   $0x0
  8017b6:	6a 00                	push   $0x0
  8017b8:	6a 0b                	push   $0xb
  8017ba:	e8 ce fe ff ff       	call   80168d <syscall>
  8017bf:	83 c4 18             	add    $0x18,%esp
}
  8017c2:	c9                   	leave  
  8017c3:	c3                   	ret    

008017c4 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8017c4:	55                   	push   %ebp
  8017c5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8017c7:	6a 00                	push   $0x0
  8017c9:	6a 00                	push   $0x0
  8017cb:	6a 00                	push   $0x0
  8017cd:	ff 75 0c             	pushl  0xc(%ebp)
  8017d0:	ff 75 08             	pushl  0x8(%ebp)
  8017d3:	6a 0f                	push   $0xf
  8017d5:	e8 b3 fe ff ff       	call   80168d <syscall>
  8017da:	83 c4 18             	add    $0x18,%esp
	return;
  8017dd:	90                   	nop
}
  8017de:	c9                   	leave  
  8017df:	c3                   	ret    

008017e0 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8017e0:	55                   	push   %ebp
  8017e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8017e3:	6a 00                	push   $0x0
  8017e5:	6a 00                	push   $0x0
  8017e7:	6a 00                	push   $0x0
  8017e9:	ff 75 0c             	pushl  0xc(%ebp)
  8017ec:	ff 75 08             	pushl  0x8(%ebp)
  8017ef:	6a 10                	push   $0x10
  8017f1:	e8 97 fe ff ff       	call   80168d <syscall>
  8017f6:	83 c4 18             	add    $0x18,%esp
	return ;
  8017f9:	90                   	nop
}
  8017fa:	c9                   	leave  
  8017fb:	c3                   	ret    

008017fc <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8017fc:	55                   	push   %ebp
  8017fd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8017ff:	6a 00                	push   $0x0
  801801:	6a 00                	push   $0x0
  801803:	ff 75 10             	pushl  0x10(%ebp)
  801806:	ff 75 0c             	pushl  0xc(%ebp)
  801809:	ff 75 08             	pushl  0x8(%ebp)
  80180c:	6a 11                	push   $0x11
  80180e:	e8 7a fe ff ff       	call   80168d <syscall>
  801813:	83 c4 18             	add    $0x18,%esp
	return ;
  801816:	90                   	nop
}
  801817:	c9                   	leave  
  801818:	c3                   	ret    

00801819 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801819:	55                   	push   %ebp
  80181a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80181c:	6a 00                	push   $0x0
  80181e:	6a 00                	push   $0x0
  801820:	6a 00                	push   $0x0
  801822:	6a 00                	push   $0x0
  801824:	6a 00                	push   $0x0
  801826:	6a 0c                	push   $0xc
  801828:	e8 60 fe ff ff       	call   80168d <syscall>
  80182d:	83 c4 18             	add    $0x18,%esp
}
  801830:	c9                   	leave  
  801831:	c3                   	ret    

00801832 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801832:	55                   	push   %ebp
  801833:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801835:	6a 00                	push   $0x0
  801837:	6a 00                	push   $0x0
  801839:	6a 00                	push   $0x0
  80183b:	6a 00                	push   $0x0
  80183d:	ff 75 08             	pushl  0x8(%ebp)
  801840:	6a 0d                	push   $0xd
  801842:	e8 46 fe ff ff       	call   80168d <syscall>
  801847:	83 c4 18             	add    $0x18,%esp
}
  80184a:	c9                   	leave  
  80184b:	c3                   	ret    

0080184c <sys_scarce_memory>:

void sys_scarce_memory()
{
  80184c:	55                   	push   %ebp
  80184d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80184f:	6a 00                	push   $0x0
  801851:	6a 00                	push   $0x0
  801853:	6a 00                	push   $0x0
  801855:	6a 00                	push   $0x0
  801857:	6a 00                	push   $0x0
  801859:	6a 0e                	push   $0xe
  80185b:	e8 2d fe ff ff       	call   80168d <syscall>
  801860:	83 c4 18             	add    $0x18,%esp
}
  801863:	90                   	nop
  801864:	c9                   	leave  
  801865:	c3                   	ret    

00801866 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801866:	55                   	push   %ebp
  801867:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801869:	6a 00                	push   $0x0
  80186b:	6a 00                	push   $0x0
  80186d:	6a 00                	push   $0x0
  80186f:	6a 00                	push   $0x0
  801871:	6a 00                	push   $0x0
  801873:	6a 13                	push   $0x13
  801875:	e8 13 fe ff ff       	call   80168d <syscall>
  80187a:	83 c4 18             	add    $0x18,%esp
}
  80187d:	90                   	nop
  80187e:	c9                   	leave  
  80187f:	c3                   	ret    

00801880 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801880:	55                   	push   %ebp
  801881:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801883:	6a 00                	push   $0x0
  801885:	6a 00                	push   $0x0
  801887:	6a 00                	push   $0x0
  801889:	6a 00                	push   $0x0
  80188b:	6a 00                	push   $0x0
  80188d:	6a 14                	push   $0x14
  80188f:	e8 f9 fd ff ff       	call   80168d <syscall>
  801894:	83 c4 18             	add    $0x18,%esp
}
  801897:	90                   	nop
  801898:	c9                   	leave  
  801899:	c3                   	ret    

0080189a <sys_cputc>:


void
sys_cputc(const char c)
{
  80189a:	55                   	push   %ebp
  80189b:	89 e5                	mov    %esp,%ebp
  80189d:	83 ec 04             	sub    $0x4,%esp
  8018a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8018a6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8018aa:	6a 00                	push   $0x0
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 00                	push   $0x0
  8018b0:	6a 00                	push   $0x0
  8018b2:	50                   	push   %eax
  8018b3:	6a 15                	push   $0x15
  8018b5:	e8 d3 fd ff ff       	call   80168d <syscall>
  8018ba:	83 c4 18             	add    $0x18,%esp
}
  8018bd:	90                   	nop
  8018be:	c9                   	leave  
  8018bf:	c3                   	ret    

008018c0 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8018c0:	55                   	push   %ebp
  8018c1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8018c3:	6a 00                	push   $0x0
  8018c5:	6a 00                	push   $0x0
  8018c7:	6a 00                	push   $0x0
  8018c9:	6a 00                	push   $0x0
  8018cb:	6a 00                	push   $0x0
  8018cd:	6a 16                	push   $0x16
  8018cf:	e8 b9 fd ff ff       	call   80168d <syscall>
  8018d4:	83 c4 18             	add    $0x18,%esp
}
  8018d7:	90                   	nop
  8018d8:	c9                   	leave  
  8018d9:	c3                   	ret    

008018da <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8018da:	55                   	push   %ebp
  8018db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8018dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 00                	push   $0x0
  8018e6:	ff 75 0c             	pushl  0xc(%ebp)
  8018e9:	50                   	push   %eax
  8018ea:	6a 17                	push   $0x17
  8018ec:	e8 9c fd ff ff       	call   80168d <syscall>
  8018f1:	83 c4 18             	add    $0x18,%esp
}
  8018f4:	c9                   	leave  
  8018f5:	c3                   	ret    

008018f6 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8018f6:	55                   	push   %ebp
  8018f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ff:	6a 00                	push   $0x0
  801901:	6a 00                	push   $0x0
  801903:	6a 00                	push   $0x0
  801905:	52                   	push   %edx
  801906:	50                   	push   %eax
  801907:	6a 1a                	push   $0x1a
  801909:	e8 7f fd ff ff       	call   80168d <syscall>
  80190e:	83 c4 18             	add    $0x18,%esp
}
  801911:	c9                   	leave  
  801912:	c3                   	ret    

00801913 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801913:	55                   	push   %ebp
  801914:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801916:	8b 55 0c             	mov    0xc(%ebp),%edx
  801919:	8b 45 08             	mov    0x8(%ebp),%eax
  80191c:	6a 00                	push   $0x0
  80191e:	6a 00                	push   $0x0
  801920:	6a 00                	push   $0x0
  801922:	52                   	push   %edx
  801923:	50                   	push   %eax
  801924:	6a 18                	push   $0x18
  801926:	e8 62 fd ff ff       	call   80168d <syscall>
  80192b:	83 c4 18             	add    $0x18,%esp
}
  80192e:	90                   	nop
  80192f:	c9                   	leave  
  801930:	c3                   	ret    

00801931 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801931:	55                   	push   %ebp
  801932:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801934:	8b 55 0c             	mov    0xc(%ebp),%edx
  801937:	8b 45 08             	mov    0x8(%ebp),%eax
  80193a:	6a 00                	push   $0x0
  80193c:	6a 00                	push   $0x0
  80193e:	6a 00                	push   $0x0
  801940:	52                   	push   %edx
  801941:	50                   	push   %eax
  801942:	6a 19                	push   $0x19
  801944:	e8 44 fd ff ff       	call   80168d <syscall>
  801949:	83 c4 18             	add    $0x18,%esp
}
  80194c:	90                   	nop
  80194d:	c9                   	leave  
  80194e:	c3                   	ret    

0080194f <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80194f:	55                   	push   %ebp
  801950:	89 e5                	mov    %esp,%ebp
  801952:	83 ec 04             	sub    $0x4,%esp
  801955:	8b 45 10             	mov    0x10(%ebp),%eax
  801958:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80195b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80195e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801962:	8b 45 08             	mov    0x8(%ebp),%eax
  801965:	6a 00                	push   $0x0
  801967:	51                   	push   %ecx
  801968:	52                   	push   %edx
  801969:	ff 75 0c             	pushl  0xc(%ebp)
  80196c:	50                   	push   %eax
  80196d:	6a 1b                	push   $0x1b
  80196f:	e8 19 fd ff ff       	call   80168d <syscall>
  801974:	83 c4 18             	add    $0x18,%esp
}
  801977:	c9                   	leave  
  801978:	c3                   	ret    

00801979 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801979:	55                   	push   %ebp
  80197a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80197c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80197f:	8b 45 08             	mov    0x8(%ebp),%eax
  801982:	6a 00                	push   $0x0
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	52                   	push   %edx
  801989:	50                   	push   %eax
  80198a:	6a 1c                	push   $0x1c
  80198c:	e8 fc fc ff ff       	call   80168d <syscall>
  801991:	83 c4 18             	add    $0x18,%esp
}
  801994:	c9                   	leave  
  801995:	c3                   	ret    

00801996 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801996:	55                   	push   %ebp
  801997:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801999:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80199c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80199f:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a2:	6a 00                	push   $0x0
  8019a4:	6a 00                	push   $0x0
  8019a6:	51                   	push   %ecx
  8019a7:	52                   	push   %edx
  8019a8:	50                   	push   %eax
  8019a9:	6a 1d                	push   $0x1d
  8019ab:	e8 dd fc ff ff       	call   80168d <syscall>
  8019b0:	83 c4 18             	add    $0x18,%esp
}
  8019b3:	c9                   	leave  
  8019b4:	c3                   	ret    

008019b5 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8019b5:	55                   	push   %ebp
  8019b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8019b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 00                	push   $0x0
  8019c2:	6a 00                	push   $0x0
  8019c4:	52                   	push   %edx
  8019c5:	50                   	push   %eax
  8019c6:	6a 1e                	push   $0x1e
  8019c8:	e8 c0 fc ff ff       	call   80168d <syscall>
  8019cd:	83 c4 18             	add    $0x18,%esp
}
  8019d0:	c9                   	leave  
  8019d1:	c3                   	ret    

008019d2 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8019d2:	55                   	push   %ebp
  8019d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 00                	push   $0x0
  8019d9:	6a 00                	push   $0x0
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 1f                	push   $0x1f
  8019e1:	e8 a7 fc ff ff       	call   80168d <syscall>
  8019e6:	83 c4 18             	add    $0x18,%esp
}
  8019e9:	c9                   	leave  
  8019ea:	c3                   	ret    

008019eb <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8019eb:	55                   	push   %ebp
  8019ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8019ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f1:	6a 00                	push   $0x0
  8019f3:	ff 75 14             	pushl  0x14(%ebp)
  8019f6:	ff 75 10             	pushl  0x10(%ebp)
  8019f9:	ff 75 0c             	pushl  0xc(%ebp)
  8019fc:	50                   	push   %eax
  8019fd:	6a 20                	push   $0x20
  8019ff:	e8 89 fc ff ff       	call   80168d <syscall>
  801a04:	83 c4 18             	add    $0x18,%esp
}
  801a07:	c9                   	leave  
  801a08:	c3                   	ret    

00801a09 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801a09:	55                   	push   %ebp
  801a0a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0f:	6a 00                	push   $0x0
  801a11:	6a 00                	push   $0x0
  801a13:	6a 00                	push   $0x0
  801a15:	6a 00                	push   $0x0
  801a17:	50                   	push   %eax
  801a18:	6a 21                	push   $0x21
  801a1a:	e8 6e fc ff ff       	call   80168d <syscall>
  801a1f:	83 c4 18             	add    $0x18,%esp
}
  801a22:	90                   	nop
  801a23:	c9                   	leave  
  801a24:	c3                   	ret    

00801a25 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801a25:	55                   	push   %ebp
  801a26:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801a28:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 00                	push   $0x0
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 00                	push   $0x0
  801a33:	50                   	push   %eax
  801a34:	6a 22                	push   $0x22
  801a36:	e8 52 fc ff ff       	call   80168d <syscall>
  801a3b:	83 c4 18             	add    $0x18,%esp
}
  801a3e:	c9                   	leave  
  801a3f:	c3                   	ret    

00801a40 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801a40:	55                   	push   %ebp
  801a41:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801a43:	6a 00                	push   $0x0
  801a45:	6a 00                	push   $0x0
  801a47:	6a 00                	push   $0x0
  801a49:	6a 00                	push   $0x0
  801a4b:	6a 00                	push   $0x0
  801a4d:	6a 02                	push   $0x2
  801a4f:	e8 39 fc ff ff       	call   80168d <syscall>
  801a54:	83 c4 18             	add    $0x18,%esp
}
  801a57:	c9                   	leave  
  801a58:	c3                   	ret    

00801a59 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801a59:	55                   	push   %ebp
  801a5a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801a5c:	6a 00                	push   $0x0
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 00                	push   $0x0
  801a62:	6a 00                	push   $0x0
  801a64:	6a 00                	push   $0x0
  801a66:	6a 03                	push   $0x3
  801a68:	e8 20 fc ff ff       	call   80168d <syscall>
  801a6d:	83 c4 18             	add    $0x18,%esp
}
  801a70:	c9                   	leave  
  801a71:	c3                   	ret    

00801a72 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801a72:	55                   	push   %ebp
  801a73:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801a75:	6a 00                	push   $0x0
  801a77:	6a 00                	push   $0x0
  801a79:	6a 00                	push   $0x0
  801a7b:	6a 00                	push   $0x0
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 04                	push   $0x4
  801a81:	e8 07 fc ff ff       	call   80168d <syscall>
  801a86:	83 c4 18             	add    $0x18,%esp
}
  801a89:	c9                   	leave  
  801a8a:	c3                   	ret    

00801a8b <sys_exit_env>:


void sys_exit_env(void)
{
  801a8b:	55                   	push   %ebp
  801a8c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 00                	push   $0x0
  801a92:	6a 00                	push   $0x0
  801a94:	6a 00                	push   $0x0
  801a96:	6a 00                	push   $0x0
  801a98:	6a 23                	push   $0x23
  801a9a:	e8 ee fb ff ff       	call   80168d <syscall>
  801a9f:	83 c4 18             	add    $0x18,%esp
}
  801aa2:	90                   	nop
  801aa3:	c9                   	leave  
  801aa4:	c3                   	ret    

00801aa5 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801aa5:	55                   	push   %ebp
  801aa6:	89 e5                	mov    %esp,%ebp
  801aa8:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801aab:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801aae:	8d 50 04             	lea    0x4(%eax),%edx
  801ab1:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	52                   	push   %edx
  801abb:	50                   	push   %eax
  801abc:	6a 24                	push   $0x24
  801abe:	e8 ca fb ff ff       	call   80168d <syscall>
  801ac3:	83 c4 18             	add    $0x18,%esp
	return result;
  801ac6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ac9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801acc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801acf:	89 01                	mov    %eax,(%ecx)
  801ad1:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad7:	c9                   	leave  
  801ad8:	c2 04 00             	ret    $0x4

00801adb <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801adb:	55                   	push   %ebp
  801adc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 00                	push   $0x0
  801ae2:	ff 75 10             	pushl  0x10(%ebp)
  801ae5:	ff 75 0c             	pushl  0xc(%ebp)
  801ae8:	ff 75 08             	pushl  0x8(%ebp)
  801aeb:	6a 12                	push   $0x12
  801aed:	e8 9b fb ff ff       	call   80168d <syscall>
  801af2:	83 c4 18             	add    $0x18,%esp
	return ;
  801af5:	90                   	nop
}
  801af6:	c9                   	leave  
  801af7:	c3                   	ret    

00801af8 <sys_rcr2>:
uint32 sys_rcr2()
{
  801af8:	55                   	push   %ebp
  801af9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801afb:	6a 00                	push   $0x0
  801afd:	6a 00                	push   $0x0
  801aff:	6a 00                	push   $0x0
  801b01:	6a 00                	push   $0x0
  801b03:	6a 00                	push   $0x0
  801b05:	6a 25                	push   $0x25
  801b07:	e8 81 fb ff ff       	call   80168d <syscall>
  801b0c:	83 c4 18             	add    $0x18,%esp
}
  801b0f:	c9                   	leave  
  801b10:	c3                   	ret    

00801b11 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801b11:	55                   	push   %ebp
  801b12:	89 e5                	mov    %esp,%ebp
  801b14:	83 ec 04             	sub    $0x4,%esp
  801b17:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801b1d:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801b21:	6a 00                	push   $0x0
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	50                   	push   %eax
  801b2a:	6a 26                	push   $0x26
  801b2c:	e8 5c fb ff ff       	call   80168d <syscall>
  801b31:	83 c4 18             	add    $0x18,%esp
	return ;
  801b34:	90                   	nop
}
  801b35:	c9                   	leave  
  801b36:	c3                   	ret    

00801b37 <rsttst>:
void rsttst()
{
  801b37:	55                   	push   %ebp
  801b38:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801b3a:	6a 00                	push   $0x0
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 00                	push   $0x0
  801b42:	6a 00                	push   $0x0
  801b44:	6a 28                	push   $0x28
  801b46:	e8 42 fb ff ff       	call   80168d <syscall>
  801b4b:	83 c4 18             	add    $0x18,%esp
	return ;
  801b4e:	90                   	nop
}
  801b4f:	c9                   	leave  
  801b50:	c3                   	ret    

00801b51 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801b51:	55                   	push   %ebp
  801b52:	89 e5                	mov    %esp,%ebp
  801b54:	83 ec 04             	sub    $0x4,%esp
  801b57:	8b 45 14             	mov    0x14(%ebp),%eax
  801b5a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801b5d:	8b 55 18             	mov    0x18(%ebp),%edx
  801b60:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b64:	52                   	push   %edx
  801b65:	50                   	push   %eax
  801b66:	ff 75 10             	pushl  0x10(%ebp)
  801b69:	ff 75 0c             	pushl  0xc(%ebp)
  801b6c:	ff 75 08             	pushl  0x8(%ebp)
  801b6f:	6a 27                	push   $0x27
  801b71:	e8 17 fb ff ff       	call   80168d <syscall>
  801b76:	83 c4 18             	add    $0x18,%esp
	return ;
  801b79:	90                   	nop
}
  801b7a:	c9                   	leave  
  801b7b:	c3                   	ret    

00801b7c <chktst>:
void chktst(uint32 n)
{
  801b7c:	55                   	push   %ebp
  801b7d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 00                	push   $0x0
  801b83:	6a 00                	push   $0x0
  801b85:	6a 00                	push   $0x0
  801b87:	ff 75 08             	pushl  0x8(%ebp)
  801b8a:	6a 29                	push   $0x29
  801b8c:	e8 fc fa ff ff       	call   80168d <syscall>
  801b91:	83 c4 18             	add    $0x18,%esp
	return ;
  801b94:	90                   	nop
}
  801b95:	c9                   	leave  
  801b96:	c3                   	ret    

00801b97 <inctst>:

void inctst()
{
  801b97:	55                   	push   %ebp
  801b98:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801b9a:	6a 00                	push   $0x0
  801b9c:	6a 00                	push   $0x0
  801b9e:	6a 00                	push   $0x0
  801ba0:	6a 00                	push   $0x0
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 2a                	push   $0x2a
  801ba6:	e8 e2 fa ff ff       	call   80168d <syscall>
  801bab:	83 c4 18             	add    $0x18,%esp
	return ;
  801bae:	90                   	nop
}
  801baf:	c9                   	leave  
  801bb0:	c3                   	ret    

00801bb1 <gettst>:
uint32 gettst()
{
  801bb1:	55                   	push   %ebp
  801bb2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801bb4:	6a 00                	push   $0x0
  801bb6:	6a 00                	push   $0x0
  801bb8:	6a 00                	push   $0x0
  801bba:	6a 00                	push   $0x0
  801bbc:	6a 00                	push   $0x0
  801bbe:	6a 2b                	push   $0x2b
  801bc0:	e8 c8 fa ff ff       	call   80168d <syscall>
  801bc5:	83 c4 18             	add    $0x18,%esp
}
  801bc8:	c9                   	leave  
  801bc9:	c3                   	ret    

00801bca <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801bca:	55                   	push   %ebp
  801bcb:	89 e5                	mov    %esp,%ebp
  801bcd:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 2c                	push   $0x2c
  801bdc:	e8 ac fa ff ff       	call   80168d <syscall>
  801be1:	83 c4 18             	add    $0x18,%esp
  801be4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801be7:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801beb:	75 07                	jne    801bf4 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801bed:	b8 01 00 00 00       	mov    $0x1,%eax
  801bf2:	eb 05                	jmp    801bf9 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801bf4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bf9:	c9                   	leave  
  801bfa:	c3                   	ret    

00801bfb <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801bfb:	55                   	push   %ebp
  801bfc:	89 e5                	mov    %esp,%ebp
  801bfe:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 2c                	push   $0x2c
  801c0d:	e8 7b fa ff ff       	call   80168d <syscall>
  801c12:	83 c4 18             	add    $0x18,%esp
  801c15:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801c18:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801c1c:	75 07                	jne    801c25 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801c1e:	b8 01 00 00 00       	mov    $0x1,%eax
  801c23:	eb 05                	jmp    801c2a <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801c25:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c2a:	c9                   	leave  
  801c2b:	c3                   	ret    

00801c2c <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801c2c:	55                   	push   %ebp
  801c2d:	89 e5                	mov    %esp,%ebp
  801c2f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c32:	6a 00                	push   $0x0
  801c34:	6a 00                	push   $0x0
  801c36:	6a 00                	push   $0x0
  801c38:	6a 00                	push   $0x0
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 2c                	push   $0x2c
  801c3e:	e8 4a fa ff ff       	call   80168d <syscall>
  801c43:	83 c4 18             	add    $0x18,%esp
  801c46:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801c49:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801c4d:	75 07                	jne    801c56 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801c4f:	b8 01 00 00 00       	mov    $0x1,%eax
  801c54:	eb 05                	jmp    801c5b <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801c56:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c5b:	c9                   	leave  
  801c5c:	c3                   	ret    

00801c5d <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801c5d:	55                   	push   %ebp
  801c5e:	89 e5                	mov    %esp,%ebp
  801c60:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c63:	6a 00                	push   $0x0
  801c65:	6a 00                	push   $0x0
  801c67:	6a 00                	push   $0x0
  801c69:	6a 00                	push   $0x0
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 2c                	push   $0x2c
  801c6f:	e8 19 fa ff ff       	call   80168d <syscall>
  801c74:	83 c4 18             	add    $0x18,%esp
  801c77:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801c7a:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801c7e:	75 07                	jne    801c87 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801c80:	b8 01 00 00 00       	mov    $0x1,%eax
  801c85:	eb 05                	jmp    801c8c <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801c87:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c8c:	c9                   	leave  
  801c8d:	c3                   	ret    

00801c8e <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c8e:	55                   	push   %ebp
  801c8f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c91:	6a 00                	push   $0x0
  801c93:	6a 00                	push   $0x0
  801c95:	6a 00                	push   $0x0
  801c97:	6a 00                	push   $0x0
  801c99:	ff 75 08             	pushl  0x8(%ebp)
  801c9c:	6a 2d                	push   $0x2d
  801c9e:	e8 ea f9 ff ff       	call   80168d <syscall>
  801ca3:	83 c4 18             	add    $0x18,%esp
	return ;
  801ca6:	90                   	nop
}
  801ca7:	c9                   	leave  
  801ca8:	c3                   	ret    

00801ca9 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ca9:	55                   	push   %ebp
  801caa:	89 e5                	mov    %esp,%ebp
  801cac:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801cad:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cb0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cb3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb9:	6a 00                	push   $0x0
  801cbb:	53                   	push   %ebx
  801cbc:	51                   	push   %ecx
  801cbd:	52                   	push   %edx
  801cbe:	50                   	push   %eax
  801cbf:	6a 2e                	push   $0x2e
  801cc1:	e8 c7 f9 ff ff       	call   80168d <syscall>
  801cc6:	83 c4 18             	add    $0x18,%esp
}
  801cc9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ccc:	c9                   	leave  
  801ccd:	c3                   	ret    

00801cce <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801cce:	55                   	push   %ebp
  801ccf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801cd1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cd4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd7:	6a 00                	push   $0x0
  801cd9:	6a 00                	push   $0x0
  801cdb:	6a 00                	push   $0x0
  801cdd:	52                   	push   %edx
  801cde:	50                   	push   %eax
  801cdf:	6a 2f                	push   $0x2f
  801ce1:	e8 a7 f9 ff ff       	call   80168d <syscall>
  801ce6:	83 c4 18             	add    $0x18,%esp
}
  801ce9:	c9                   	leave  
  801cea:	c3                   	ret    

00801ceb <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801ceb:	55                   	push   %ebp
  801cec:	89 e5                	mov    %esp,%ebp
  801cee:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801cf1:	83 ec 0c             	sub    $0xc,%esp
  801cf4:	68 84 3e 80 00       	push   $0x803e84
  801cf9:	e8 46 e8 ff ff       	call   800544 <cprintf>
  801cfe:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801d01:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801d08:	83 ec 0c             	sub    $0xc,%esp
  801d0b:	68 b0 3e 80 00       	push   $0x803eb0
  801d10:	e8 2f e8 ff ff       	call   800544 <cprintf>
  801d15:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801d18:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d1c:	a1 38 51 80 00       	mov    0x805138,%eax
  801d21:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d24:	eb 56                	jmp    801d7c <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801d26:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d2a:	74 1c                	je     801d48 <print_mem_block_lists+0x5d>
  801d2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d2f:	8b 50 08             	mov    0x8(%eax),%edx
  801d32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d35:	8b 48 08             	mov    0x8(%eax),%ecx
  801d38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d3b:	8b 40 0c             	mov    0xc(%eax),%eax
  801d3e:	01 c8                	add    %ecx,%eax
  801d40:	39 c2                	cmp    %eax,%edx
  801d42:	73 04                	jae    801d48 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801d44:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801d48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d4b:	8b 50 08             	mov    0x8(%eax),%edx
  801d4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d51:	8b 40 0c             	mov    0xc(%eax),%eax
  801d54:	01 c2                	add    %eax,%edx
  801d56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d59:	8b 40 08             	mov    0x8(%eax),%eax
  801d5c:	83 ec 04             	sub    $0x4,%esp
  801d5f:	52                   	push   %edx
  801d60:	50                   	push   %eax
  801d61:	68 c5 3e 80 00       	push   $0x803ec5
  801d66:	e8 d9 e7 ff ff       	call   800544 <cprintf>
  801d6b:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801d6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d71:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d74:	a1 40 51 80 00       	mov    0x805140,%eax
  801d79:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d7c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d80:	74 07                	je     801d89 <print_mem_block_lists+0x9e>
  801d82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d85:	8b 00                	mov    (%eax),%eax
  801d87:	eb 05                	jmp    801d8e <print_mem_block_lists+0xa3>
  801d89:	b8 00 00 00 00       	mov    $0x0,%eax
  801d8e:	a3 40 51 80 00       	mov    %eax,0x805140
  801d93:	a1 40 51 80 00       	mov    0x805140,%eax
  801d98:	85 c0                	test   %eax,%eax
  801d9a:	75 8a                	jne    801d26 <print_mem_block_lists+0x3b>
  801d9c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801da0:	75 84                	jne    801d26 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801da2:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801da6:	75 10                	jne    801db8 <print_mem_block_lists+0xcd>
  801da8:	83 ec 0c             	sub    $0xc,%esp
  801dab:	68 d4 3e 80 00       	push   $0x803ed4
  801db0:	e8 8f e7 ff ff       	call   800544 <cprintf>
  801db5:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801db8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801dbf:	83 ec 0c             	sub    $0xc,%esp
  801dc2:	68 f8 3e 80 00       	push   $0x803ef8
  801dc7:	e8 78 e7 ff ff       	call   800544 <cprintf>
  801dcc:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801dcf:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801dd3:	a1 40 50 80 00       	mov    0x805040,%eax
  801dd8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ddb:	eb 56                	jmp    801e33 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801ddd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801de1:	74 1c                	je     801dff <print_mem_block_lists+0x114>
  801de3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801de6:	8b 50 08             	mov    0x8(%eax),%edx
  801de9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dec:	8b 48 08             	mov    0x8(%eax),%ecx
  801def:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801df2:	8b 40 0c             	mov    0xc(%eax),%eax
  801df5:	01 c8                	add    %ecx,%eax
  801df7:	39 c2                	cmp    %eax,%edx
  801df9:	73 04                	jae    801dff <print_mem_block_lists+0x114>
			sorted = 0 ;
  801dfb:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801dff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e02:	8b 50 08             	mov    0x8(%eax),%edx
  801e05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e08:	8b 40 0c             	mov    0xc(%eax),%eax
  801e0b:	01 c2                	add    %eax,%edx
  801e0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e10:	8b 40 08             	mov    0x8(%eax),%eax
  801e13:	83 ec 04             	sub    $0x4,%esp
  801e16:	52                   	push   %edx
  801e17:	50                   	push   %eax
  801e18:	68 c5 3e 80 00       	push   $0x803ec5
  801e1d:	e8 22 e7 ff ff       	call   800544 <cprintf>
  801e22:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e28:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801e2b:	a1 48 50 80 00       	mov    0x805048,%eax
  801e30:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e33:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e37:	74 07                	je     801e40 <print_mem_block_lists+0x155>
  801e39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e3c:	8b 00                	mov    (%eax),%eax
  801e3e:	eb 05                	jmp    801e45 <print_mem_block_lists+0x15a>
  801e40:	b8 00 00 00 00       	mov    $0x0,%eax
  801e45:	a3 48 50 80 00       	mov    %eax,0x805048
  801e4a:	a1 48 50 80 00       	mov    0x805048,%eax
  801e4f:	85 c0                	test   %eax,%eax
  801e51:	75 8a                	jne    801ddd <print_mem_block_lists+0xf2>
  801e53:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e57:	75 84                	jne    801ddd <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801e59:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e5d:	75 10                	jne    801e6f <print_mem_block_lists+0x184>
  801e5f:	83 ec 0c             	sub    $0xc,%esp
  801e62:	68 10 3f 80 00       	push   $0x803f10
  801e67:	e8 d8 e6 ff ff       	call   800544 <cprintf>
  801e6c:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801e6f:	83 ec 0c             	sub    $0xc,%esp
  801e72:	68 84 3e 80 00       	push   $0x803e84
  801e77:	e8 c8 e6 ff ff       	call   800544 <cprintf>
  801e7c:	83 c4 10             	add    $0x10,%esp

}
  801e7f:	90                   	nop
  801e80:	c9                   	leave  
  801e81:	c3                   	ret    

00801e82 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801e82:	55                   	push   %ebp
  801e83:	89 e5                	mov    %esp,%ebp
  801e85:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801e88:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  801e8f:	00 00 00 
  801e92:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  801e99:	00 00 00 
  801e9c:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  801ea3:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801ea6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801ead:	e9 9e 00 00 00       	jmp    801f50 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801eb2:	a1 50 50 80 00       	mov    0x805050,%eax
  801eb7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801eba:	c1 e2 04             	shl    $0x4,%edx
  801ebd:	01 d0                	add    %edx,%eax
  801ebf:	85 c0                	test   %eax,%eax
  801ec1:	75 14                	jne    801ed7 <initialize_MemBlocksList+0x55>
  801ec3:	83 ec 04             	sub    $0x4,%esp
  801ec6:	68 38 3f 80 00       	push   $0x803f38
  801ecb:	6a 46                	push   $0x46
  801ecd:	68 5b 3f 80 00       	push   $0x803f5b
  801ed2:	e8 b9 e3 ff ff       	call   800290 <_panic>
  801ed7:	a1 50 50 80 00       	mov    0x805050,%eax
  801edc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801edf:	c1 e2 04             	shl    $0x4,%edx
  801ee2:	01 d0                	add    %edx,%eax
  801ee4:	8b 15 48 51 80 00    	mov    0x805148,%edx
  801eea:	89 10                	mov    %edx,(%eax)
  801eec:	8b 00                	mov    (%eax),%eax
  801eee:	85 c0                	test   %eax,%eax
  801ef0:	74 18                	je     801f0a <initialize_MemBlocksList+0x88>
  801ef2:	a1 48 51 80 00       	mov    0x805148,%eax
  801ef7:	8b 15 50 50 80 00    	mov    0x805050,%edx
  801efd:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801f00:	c1 e1 04             	shl    $0x4,%ecx
  801f03:	01 ca                	add    %ecx,%edx
  801f05:	89 50 04             	mov    %edx,0x4(%eax)
  801f08:	eb 12                	jmp    801f1c <initialize_MemBlocksList+0x9a>
  801f0a:	a1 50 50 80 00       	mov    0x805050,%eax
  801f0f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f12:	c1 e2 04             	shl    $0x4,%edx
  801f15:	01 d0                	add    %edx,%eax
  801f17:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801f1c:	a1 50 50 80 00       	mov    0x805050,%eax
  801f21:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f24:	c1 e2 04             	shl    $0x4,%edx
  801f27:	01 d0                	add    %edx,%eax
  801f29:	a3 48 51 80 00       	mov    %eax,0x805148
  801f2e:	a1 50 50 80 00       	mov    0x805050,%eax
  801f33:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f36:	c1 e2 04             	shl    $0x4,%edx
  801f39:	01 d0                	add    %edx,%eax
  801f3b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f42:	a1 54 51 80 00       	mov    0x805154,%eax
  801f47:	40                   	inc    %eax
  801f48:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801f4d:	ff 45 f4             	incl   -0xc(%ebp)
  801f50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f53:	3b 45 08             	cmp    0x8(%ebp),%eax
  801f56:	0f 82 56 ff ff ff    	jb     801eb2 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801f5c:	90                   	nop
  801f5d:	c9                   	leave  
  801f5e:	c3                   	ret    

00801f5f <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801f5f:	55                   	push   %ebp
  801f60:	89 e5                	mov    %esp,%ebp
  801f62:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801f65:	8b 45 08             	mov    0x8(%ebp),%eax
  801f68:	8b 00                	mov    (%eax),%eax
  801f6a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f6d:	eb 19                	jmp    801f88 <find_block+0x29>
	{
		if(va==point->sva)
  801f6f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f72:	8b 40 08             	mov    0x8(%eax),%eax
  801f75:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801f78:	75 05                	jne    801f7f <find_block+0x20>
		   return point;
  801f7a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f7d:	eb 36                	jmp    801fb5 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801f7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f82:	8b 40 08             	mov    0x8(%eax),%eax
  801f85:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f88:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f8c:	74 07                	je     801f95 <find_block+0x36>
  801f8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f91:	8b 00                	mov    (%eax),%eax
  801f93:	eb 05                	jmp    801f9a <find_block+0x3b>
  801f95:	b8 00 00 00 00       	mov    $0x0,%eax
  801f9a:	8b 55 08             	mov    0x8(%ebp),%edx
  801f9d:	89 42 08             	mov    %eax,0x8(%edx)
  801fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa3:	8b 40 08             	mov    0x8(%eax),%eax
  801fa6:	85 c0                	test   %eax,%eax
  801fa8:	75 c5                	jne    801f6f <find_block+0x10>
  801faa:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801fae:	75 bf                	jne    801f6f <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  801fb0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fb5:	c9                   	leave  
  801fb6:	c3                   	ret    

00801fb7 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  801fb7:	55                   	push   %ebp
  801fb8:	89 e5                	mov    %esp,%ebp
  801fba:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  801fbd:	a1 40 50 80 00       	mov    0x805040,%eax
  801fc2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  801fc5:	a1 44 50 80 00       	mov    0x805044,%eax
  801fca:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  801fcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fd0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801fd3:	74 24                	je     801ff9 <insert_sorted_allocList+0x42>
  801fd5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd8:	8b 50 08             	mov    0x8(%eax),%edx
  801fdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fde:	8b 40 08             	mov    0x8(%eax),%eax
  801fe1:	39 c2                	cmp    %eax,%edx
  801fe3:	76 14                	jbe    801ff9 <insert_sorted_allocList+0x42>
  801fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe8:	8b 50 08             	mov    0x8(%eax),%edx
  801feb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fee:	8b 40 08             	mov    0x8(%eax),%eax
  801ff1:	39 c2                	cmp    %eax,%edx
  801ff3:	0f 82 60 01 00 00    	jb     802159 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  801ff9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ffd:	75 65                	jne    802064 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  801fff:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802003:	75 14                	jne    802019 <insert_sorted_allocList+0x62>
  802005:	83 ec 04             	sub    $0x4,%esp
  802008:	68 38 3f 80 00       	push   $0x803f38
  80200d:	6a 6b                	push   $0x6b
  80200f:	68 5b 3f 80 00       	push   $0x803f5b
  802014:	e8 77 e2 ff ff       	call   800290 <_panic>
  802019:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80201f:	8b 45 08             	mov    0x8(%ebp),%eax
  802022:	89 10                	mov    %edx,(%eax)
  802024:	8b 45 08             	mov    0x8(%ebp),%eax
  802027:	8b 00                	mov    (%eax),%eax
  802029:	85 c0                	test   %eax,%eax
  80202b:	74 0d                	je     80203a <insert_sorted_allocList+0x83>
  80202d:	a1 40 50 80 00       	mov    0x805040,%eax
  802032:	8b 55 08             	mov    0x8(%ebp),%edx
  802035:	89 50 04             	mov    %edx,0x4(%eax)
  802038:	eb 08                	jmp    802042 <insert_sorted_allocList+0x8b>
  80203a:	8b 45 08             	mov    0x8(%ebp),%eax
  80203d:	a3 44 50 80 00       	mov    %eax,0x805044
  802042:	8b 45 08             	mov    0x8(%ebp),%eax
  802045:	a3 40 50 80 00       	mov    %eax,0x805040
  80204a:	8b 45 08             	mov    0x8(%ebp),%eax
  80204d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802054:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802059:	40                   	inc    %eax
  80205a:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80205f:	e9 dc 01 00 00       	jmp    802240 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802064:	8b 45 08             	mov    0x8(%ebp),%eax
  802067:	8b 50 08             	mov    0x8(%eax),%edx
  80206a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80206d:	8b 40 08             	mov    0x8(%eax),%eax
  802070:	39 c2                	cmp    %eax,%edx
  802072:	77 6c                	ja     8020e0 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802074:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802078:	74 06                	je     802080 <insert_sorted_allocList+0xc9>
  80207a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80207e:	75 14                	jne    802094 <insert_sorted_allocList+0xdd>
  802080:	83 ec 04             	sub    $0x4,%esp
  802083:	68 74 3f 80 00       	push   $0x803f74
  802088:	6a 6f                	push   $0x6f
  80208a:	68 5b 3f 80 00       	push   $0x803f5b
  80208f:	e8 fc e1 ff ff       	call   800290 <_panic>
  802094:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802097:	8b 50 04             	mov    0x4(%eax),%edx
  80209a:	8b 45 08             	mov    0x8(%ebp),%eax
  80209d:	89 50 04             	mov    %edx,0x4(%eax)
  8020a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8020a6:	89 10                	mov    %edx,(%eax)
  8020a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020ab:	8b 40 04             	mov    0x4(%eax),%eax
  8020ae:	85 c0                	test   %eax,%eax
  8020b0:	74 0d                	je     8020bf <insert_sorted_allocList+0x108>
  8020b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020b5:	8b 40 04             	mov    0x4(%eax),%eax
  8020b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8020bb:	89 10                	mov    %edx,(%eax)
  8020bd:	eb 08                	jmp    8020c7 <insert_sorted_allocList+0x110>
  8020bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c2:	a3 40 50 80 00       	mov    %eax,0x805040
  8020c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8020cd:	89 50 04             	mov    %edx,0x4(%eax)
  8020d0:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8020d5:	40                   	inc    %eax
  8020d6:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8020db:	e9 60 01 00 00       	jmp    802240 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8020e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e3:	8b 50 08             	mov    0x8(%eax),%edx
  8020e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020e9:	8b 40 08             	mov    0x8(%eax),%eax
  8020ec:	39 c2                	cmp    %eax,%edx
  8020ee:	0f 82 4c 01 00 00    	jb     802240 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8020f4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020f8:	75 14                	jne    80210e <insert_sorted_allocList+0x157>
  8020fa:	83 ec 04             	sub    $0x4,%esp
  8020fd:	68 ac 3f 80 00       	push   $0x803fac
  802102:	6a 73                	push   $0x73
  802104:	68 5b 3f 80 00       	push   $0x803f5b
  802109:	e8 82 e1 ff ff       	call   800290 <_panic>
  80210e:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802114:	8b 45 08             	mov    0x8(%ebp),%eax
  802117:	89 50 04             	mov    %edx,0x4(%eax)
  80211a:	8b 45 08             	mov    0x8(%ebp),%eax
  80211d:	8b 40 04             	mov    0x4(%eax),%eax
  802120:	85 c0                	test   %eax,%eax
  802122:	74 0c                	je     802130 <insert_sorted_allocList+0x179>
  802124:	a1 44 50 80 00       	mov    0x805044,%eax
  802129:	8b 55 08             	mov    0x8(%ebp),%edx
  80212c:	89 10                	mov    %edx,(%eax)
  80212e:	eb 08                	jmp    802138 <insert_sorted_allocList+0x181>
  802130:	8b 45 08             	mov    0x8(%ebp),%eax
  802133:	a3 40 50 80 00       	mov    %eax,0x805040
  802138:	8b 45 08             	mov    0x8(%ebp),%eax
  80213b:	a3 44 50 80 00       	mov    %eax,0x805044
  802140:	8b 45 08             	mov    0x8(%ebp),%eax
  802143:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802149:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80214e:	40                   	inc    %eax
  80214f:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802154:	e9 e7 00 00 00       	jmp    802240 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802159:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80215c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  80215f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802166:	a1 40 50 80 00       	mov    0x805040,%eax
  80216b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80216e:	e9 9d 00 00 00       	jmp    802210 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802173:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802176:	8b 00                	mov    (%eax),%eax
  802178:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  80217b:	8b 45 08             	mov    0x8(%ebp),%eax
  80217e:	8b 50 08             	mov    0x8(%eax),%edx
  802181:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802184:	8b 40 08             	mov    0x8(%eax),%eax
  802187:	39 c2                	cmp    %eax,%edx
  802189:	76 7d                	jbe    802208 <insert_sorted_allocList+0x251>
  80218b:	8b 45 08             	mov    0x8(%ebp),%eax
  80218e:	8b 50 08             	mov    0x8(%eax),%edx
  802191:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802194:	8b 40 08             	mov    0x8(%eax),%eax
  802197:	39 c2                	cmp    %eax,%edx
  802199:	73 6d                	jae    802208 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  80219b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80219f:	74 06                	je     8021a7 <insert_sorted_allocList+0x1f0>
  8021a1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021a5:	75 14                	jne    8021bb <insert_sorted_allocList+0x204>
  8021a7:	83 ec 04             	sub    $0x4,%esp
  8021aa:	68 d0 3f 80 00       	push   $0x803fd0
  8021af:	6a 7f                	push   $0x7f
  8021b1:	68 5b 3f 80 00       	push   $0x803f5b
  8021b6:	e8 d5 e0 ff ff       	call   800290 <_panic>
  8021bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021be:	8b 10                	mov    (%eax),%edx
  8021c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c3:	89 10                	mov    %edx,(%eax)
  8021c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c8:	8b 00                	mov    (%eax),%eax
  8021ca:	85 c0                	test   %eax,%eax
  8021cc:	74 0b                	je     8021d9 <insert_sorted_allocList+0x222>
  8021ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d1:	8b 00                	mov    (%eax),%eax
  8021d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8021d6:	89 50 04             	mov    %edx,0x4(%eax)
  8021d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8021df:	89 10                	mov    %edx,(%eax)
  8021e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021e7:	89 50 04             	mov    %edx,0x4(%eax)
  8021ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ed:	8b 00                	mov    (%eax),%eax
  8021ef:	85 c0                	test   %eax,%eax
  8021f1:	75 08                	jne    8021fb <insert_sorted_allocList+0x244>
  8021f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f6:	a3 44 50 80 00       	mov    %eax,0x805044
  8021fb:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802200:	40                   	inc    %eax
  802201:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802206:	eb 39                	jmp    802241 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802208:	a1 48 50 80 00       	mov    0x805048,%eax
  80220d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802210:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802214:	74 07                	je     80221d <insert_sorted_allocList+0x266>
  802216:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802219:	8b 00                	mov    (%eax),%eax
  80221b:	eb 05                	jmp    802222 <insert_sorted_allocList+0x26b>
  80221d:	b8 00 00 00 00       	mov    $0x0,%eax
  802222:	a3 48 50 80 00       	mov    %eax,0x805048
  802227:	a1 48 50 80 00       	mov    0x805048,%eax
  80222c:	85 c0                	test   %eax,%eax
  80222e:	0f 85 3f ff ff ff    	jne    802173 <insert_sorted_allocList+0x1bc>
  802234:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802238:	0f 85 35 ff ff ff    	jne    802173 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80223e:	eb 01                	jmp    802241 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802240:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802241:	90                   	nop
  802242:	c9                   	leave  
  802243:	c3                   	ret    

00802244 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802244:	55                   	push   %ebp
  802245:	89 e5                	mov    %esp,%ebp
  802247:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80224a:	a1 38 51 80 00       	mov    0x805138,%eax
  80224f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802252:	e9 85 01 00 00       	jmp    8023dc <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802257:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225a:	8b 40 0c             	mov    0xc(%eax),%eax
  80225d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802260:	0f 82 6e 01 00 00    	jb     8023d4 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802266:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802269:	8b 40 0c             	mov    0xc(%eax),%eax
  80226c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80226f:	0f 85 8a 00 00 00    	jne    8022ff <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802275:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802279:	75 17                	jne    802292 <alloc_block_FF+0x4e>
  80227b:	83 ec 04             	sub    $0x4,%esp
  80227e:	68 04 40 80 00       	push   $0x804004
  802283:	68 93 00 00 00       	push   $0x93
  802288:	68 5b 3f 80 00       	push   $0x803f5b
  80228d:	e8 fe df ff ff       	call   800290 <_panic>
  802292:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802295:	8b 00                	mov    (%eax),%eax
  802297:	85 c0                	test   %eax,%eax
  802299:	74 10                	je     8022ab <alloc_block_FF+0x67>
  80229b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229e:	8b 00                	mov    (%eax),%eax
  8022a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022a3:	8b 52 04             	mov    0x4(%edx),%edx
  8022a6:	89 50 04             	mov    %edx,0x4(%eax)
  8022a9:	eb 0b                	jmp    8022b6 <alloc_block_FF+0x72>
  8022ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ae:	8b 40 04             	mov    0x4(%eax),%eax
  8022b1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8022b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b9:	8b 40 04             	mov    0x4(%eax),%eax
  8022bc:	85 c0                	test   %eax,%eax
  8022be:	74 0f                	je     8022cf <alloc_block_FF+0x8b>
  8022c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c3:	8b 40 04             	mov    0x4(%eax),%eax
  8022c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022c9:	8b 12                	mov    (%edx),%edx
  8022cb:	89 10                	mov    %edx,(%eax)
  8022cd:	eb 0a                	jmp    8022d9 <alloc_block_FF+0x95>
  8022cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d2:	8b 00                	mov    (%eax),%eax
  8022d4:	a3 38 51 80 00       	mov    %eax,0x805138
  8022d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022dc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022ec:	a1 44 51 80 00       	mov    0x805144,%eax
  8022f1:	48                   	dec    %eax
  8022f2:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  8022f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022fa:	e9 10 01 00 00       	jmp    80240f <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8022ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802302:	8b 40 0c             	mov    0xc(%eax),%eax
  802305:	3b 45 08             	cmp    0x8(%ebp),%eax
  802308:	0f 86 c6 00 00 00    	jbe    8023d4 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80230e:	a1 48 51 80 00       	mov    0x805148,%eax
  802313:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802316:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802319:	8b 50 08             	mov    0x8(%eax),%edx
  80231c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80231f:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802322:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802325:	8b 55 08             	mov    0x8(%ebp),%edx
  802328:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80232b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80232f:	75 17                	jne    802348 <alloc_block_FF+0x104>
  802331:	83 ec 04             	sub    $0x4,%esp
  802334:	68 04 40 80 00       	push   $0x804004
  802339:	68 9b 00 00 00       	push   $0x9b
  80233e:	68 5b 3f 80 00       	push   $0x803f5b
  802343:	e8 48 df ff ff       	call   800290 <_panic>
  802348:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80234b:	8b 00                	mov    (%eax),%eax
  80234d:	85 c0                	test   %eax,%eax
  80234f:	74 10                	je     802361 <alloc_block_FF+0x11d>
  802351:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802354:	8b 00                	mov    (%eax),%eax
  802356:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802359:	8b 52 04             	mov    0x4(%edx),%edx
  80235c:	89 50 04             	mov    %edx,0x4(%eax)
  80235f:	eb 0b                	jmp    80236c <alloc_block_FF+0x128>
  802361:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802364:	8b 40 04             	mov    0x4(%eax),%eax
  802367:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80236c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80236f:	8b 40 04             	mov    0x4(%eax),%eax
  802372:	85 c0                	test   %eax,%eax
  802374:	74 0f                	je     802385 <alloc_block_FF+0x141>
  802376:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802379:	8b 40 04             	mov    0x4(%eax),%eax
  80237c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80237f:	8b 12                	mov    (%edx),%edx
  802381:	89 10                	mov    %edx,(%eax)
  802383:	eb 0a                	jmp    80238f <alloc_block_FF+0x14b>
  802385:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802388:	8b 00                	mov    (%eax),%eax
  80238a:	a3 48 51 80 00       	mov    %eax,0x805148
  80238f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802392:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802398:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80239b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023a2:	a1 54 51 80 00       	mov    0x805154,%eax
  8023a7:	48                   	dec    %eax
  8023a8:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  8023ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b0:	8b 50 08             	mov    0x8(%eax),%edx
  8023b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b6:	01 c2                	add    %eax,%edx
  8023b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023bb:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8023be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c1:	8b 40 0c             	mov    0xc(%eax),%eax
  8023c4:	2b 45 08             	sub    0x8(%ebp),%eax
  8023c7:	89 c2                	mov    %eax,%edx
  8023c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cc:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8023cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023d2:	eb 3b                	jmp    80240f <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8023d4:	a1 40 51 80 00       	mov    0x805140,%eax
  8023d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023e0:	74 07                	je     8023e9 <alloc_block_FF+0x1a5>
  8023e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e5:	8b 00                	mov    (%eax),%eax
  8023e7:	eb 05                	jmp    8023ee <alloc_block_FF+0x1aa>
  8023e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8023ee:	a3 40 51 80 00       	mov    %eax,0x805140
  8023f3:	a1 40 51 80 00       	mov    0x805140,%eax
  8023f8:	85 c0                	test   %eax,%eax
  8023fa:	0f 85 57 fe ff ff    	jne    802257 <alloc_block_FF+0x13>
  802400:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802404:	0f 85 4d fe ff ff    	jne    802257 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  80240a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80240f:	c9                   	leave  
  802410:	c3                   	ret    

00802411 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802411:	55                   	push   %ebp
  802412:	89 e5                	mov    %esp,%ebp
  802414:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802417:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80241e:	a1 38 51 80 00       	mov    0x805138,%eax
  802423:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802426:	e9 df 00 00 00       	jmp    80250a <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  80242b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242e:	8b 40 0c             	mov    0xc(%eax),%eax
  802431:	3b 45 08             	cmp    0x8(%ebp),%eax
  802434:	0f 82 c8 00 00 00    	jb     802502 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  80243a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243d:	8b 40 0c             	mov    0xc(%eax),%eax
  802440:	3b 45 08             	cmp    0x8(%ebp),%eax
  802443:	0f 85 8a 00 00 00    	jne    8024d3 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802449:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80244d:	75 17                	jne    802466 <alloc_block_BF+0x55>
  80244f:	83 ec 04             	sub    $0x4,%esp
  802452:	68 04 40 80 00       	push   $0x804004
  802457:	68 b7 00 00 00       	push   $0xb7
  80245c:	68 5b 3f 80 00       	push   $0x803f5b
  802461:	e8 2a de ff ff       	call   800290 <_panic>
  802466:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802469:	8b 00                	mov    (%eax),%eax
  80246b:	85 c0                	test   %eax,%eax
  80246d:	74 10                	je     80247f <alloc_block_BF+0x6e>
  80246f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802472:	8b 00                	mov    (%eax),%eax
  802474:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802477:	8b 52 04             	mov    0x4(%edx),%edx
  80247a:	89 50 04             	mov    %edx,0x4(%eax)
  80247d:	eb 0b                	jmp    80248a <alloc_block_BF+0x79>
  80247f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802482:	8b 40 04             	mov    0x4(%eax),%eax
  802485:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80248a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248d:	8b 40 04             	mov    0x4(%eax),%eax
  802490:	85 c0                	test   %eax,%eax
  802492:	74 0f                	je     8024a3 <alloc_block_BF+0x92>
  802494:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802497:	8b 40 04             	mov    0x4(%eax),%eax
  80249a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80249d:	8b 12                	mov    (%edx),%edx
  80249f:	89 10                	mov    %edx,(%eax)
  8024a1:	eb 0a                	jmp    8024ad <alloc_block_BF+0x9c>
  8024a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a6:	8b 00                	mov    (%eax),%eax
  8024a8:	a3 38 51 80 00       	mov    %eax,0x805138
  8024ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024c0:	a1 44 51 80 00       	mov    0x805144,%eax
  8024c5:	48                   	dec    %eax
  8024c6:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  8024cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ce:	e9 4d 01 00 00       	jmp    802620 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8024d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d6:	8b 40 0c             	mov    0xc(%eax),%eax
  8024d9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024dc:	76 24                	jbe    802502 <alloc_block_BF+0xf1>
  8024de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e1:	8b 40 0c             	mov    0xc(%eax),%eax
  8024e4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8024e7:	73 19                	jae    802502 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8024e9:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8024f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f3:	8b 40 0c             	mov    0xc(%eax),%eax
  8024f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8024f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fc:	8b 40 08             	mov    0x8(%eax),%eax
  8024ff:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802502:	a1 40 51 80 00       	mov    0x805140,%eax
  802507:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80250a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80250e:	74 07                	je     802517 <alloc_block_BF+0x106>
  802510:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802513:	8b 00                	mov    (%eax),%eax
  802515:	eb 05                	jmp    80251c <alloc_block_BF+0x10b>
  802517:	b8 00 00 00 00       	mov    $0x0,%eax
  80251c:	a3 40 51 80 00       	mov    %eax,0x805140
  802521:	a1 40 51 80 00       	mov    0x805140,%eax
  802526:	85 c0                	test   %eax,%eax
  802528:	0f 85 fd fe ff ff    	jne    80242b <alloc_block_BF+0x1a>
  80252e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802532:	0f 85 f3 fe ff ff    	jne    80242b <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802538:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80253c:	0f 84 d9 00 00 00    	je     80261b <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802542:	a1 48 51 80 00       	mov    0x805148,%eax
  802547:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  80254a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80254d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802550:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802553:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802556:	8b 55 08             	mov    0x8(%ebp),%edx
  802559:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  80255c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802560:	75 17                	jne    802579 <alloc_block_BF+0x168>
  802562:	83 ec 04             	sub    $0x4,%esp
  802565:	68 04 40 80 00       	push   $0x804004
  80256a:	68 c7 00 00 00       	push   $0xc7
  80256f:	68 5b 3f 80 00       	push   $0x803f5b
  802574:	e8 17 dd ff ff       	call   800290 <_panic>
  802579:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80257c:	8b 00                	mov    (%eax),%eax
  80257e:	85 c0                	test   %eax,%eax
  802580:	74 10                	je     802592 <alloc_block_BF+0x181>
  802582:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802585:	8b 00                	mov    (%eax),%eax
  802587:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80258a:	8b 52 04             	mov    0x4(%edx),%edx
  80258d:	89 50 04             	mov    %edx,0x4(%eax)
  802590:	eb 0b                	jmp    80259d <alloc_block_BF+0x18c>
  802592:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802595:	8b 40 04             	mov    0x4(%eax),%eax
  802598:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80259d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025a0:	8b 40 04             	mov    0x4(%eax),%eax
  8025a3:	85 c0                	test   %eax,%eax
  8025a5:	74 0f                	je     8025b6 <alloc_block_BF+0x1a5>
  8025a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025aa:	8b 40 04             	mov    0x4(%eax),%eax
  8025ad:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025b0:	8b 12                	mov    (%edx),%edx
  8025b2:	89 10                	mov    %edx,(%eax)
  8025b4:	eb 0a                	jmp    8025c0 <alloc_block_BF+0x1af>
  8025b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025b9:	8b 00                	mov    (%eax),%eax
  8025bb:	a3 48 51 80 00       	mov    %eax,0x805148
  8025c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025c3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025cc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025d3:	a1 54 51 80 00       	mov    0x805154,%eax
  8025d8:	48                   	dec    %eax
  8025d9:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8025de:	83 ec 08             	sub    $0x8,%esp
  8025e1:	ff 75 ec             	pushl  -0x14(%ebp)
  8025e4:	68 38 51 80 00       	push   $0x805138
  8025e9:	e8 71 f9 ff ff       	call   801f5f <find_block>
  8025ee:	83 c4 10             	add    $0x10,%esp
  8025f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8025f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025f7:	8b 50 08             	mov    0x8(%eax),%edx
  8025fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8025fd:	01 c2                	add    %eax,%edx
  8025ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802602:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802605:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802608:	8b 40 0c             	mov    0xc(%eax),%eax
  80260b:	2b 45 08             	sub    0x8(%ebp),%eax
  80260e:	89 c2                	mov    %eax,%edx
  802610:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802613:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802616:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802619:	eb 05                	jmp    802620 <alloc_block_BF+0x20f>
	}
	return NULL;
  80261b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802620:	c9                   	leave  
  802621:	c3                   	ret    

00802622 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802622:	55                   	push   %ebp
  802623:	89 e5                	mov    %esp,%ebp
  802625:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802628:	a1 28 50 80 00       	mov    0x805028,%eax
  80262d:	85 c0                	test   %eax,%eax
  80262f:	0f 85 de 01 00 00    	jne    802813 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802635:	a1 38 51 80 00       	mov    0x805138,%eax
  80263a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80263d:	e9 9e 01 00 00       	jmp    8027e0 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802642:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802645:	8b 40 0c             	mov    0xc(%eax),%eax
  802648:	3b 45 08             	cmp    0x8(%ebp),%eax
  80264b:	0f 82 87 01 00 00    	jb     8027d8 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802651:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802654:	8b 40 0c             	mov    0xc(%eax),%eax
  802657:	3b 45 08             	cmp    0x8(%ebp),%eax
  80265a:	0f 85 95 00 00 00    	jne    8026f5 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802660:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802664:	75 17                	jne    80267d <alloc_block_NF+0x5b>
  802666:	83 ec 04             	sub    $0x4,%esp
  802669:	68 04 40 80 00       	push   $0x804004
  80266e:	68 e0 00 00 00       	push   $0xe0
  802673:	68 5b 3f 80 00       	push   $0x803f5b
  802678:	e8 13 dc ff ff       	call   800290 <_panic>
  80267d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802680:	8b 00                	mov    (%eax),%eax
  802682:	85 c0                	test   %eax,%eax
  802684:	74 10                	je     802696 <alloc_block_NF+0x74>
  802686:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802689:	8b 00                	mov    (%eax),%eax
  80268b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80268e:	8b 52 04             	mov    0x4(%edx),%edx
  802691:	89 50 04             	mov    %edx,0x4(%eax)
  802694:	eb 0b                	jmp    8026a1 <alloc_block_NF+0x7f>
  802696:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802699:	8b 40 04             	mov    0x4(%eax),%eax
  80269c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8026a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a4:	8b 40 04             	mov    0x4(%eax),%eax
  8026a7:	85 c0                	test   %eax,%eax
  8026a9:	74 0f                	je     8026ba <alloc_block_NF+0x98>
  8026ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ae:	8b 40 04             	mov    0x4(%eax),%eax
  8026b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026b4:	8b 12                	mov    (%edx),%edx
  8026b6:	89 10                	mov    %edx,(%eax)
  8026b8:	eb 0a                	jmp    8026c4 <alloc_block_NF+0xa2>
  8026ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bd:	8b 00                	mov    (%eax),%eax
  8026bf:	a3 38 51 80 00       	mov    %eax,0x805138
  8026c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026d7:	a1 44 51 80 00       	mov    0x805144,%eax
  8026dc:	48                   	dec    %eax
  8026dd:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  8026e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e5:	8b 40 08             	mov    0x8(%eax),%eax
  8026e8:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  8026ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f0:	e9 f8 04 00 00       	jmp    802bed <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8026f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f8:	8b 40 0c             	mov    0xc(%eax),%eax
  8026fb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026fe:	0f 86 d4 00 00 00    	jbe    8027d8 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802704:	a1 48 51 80 00       	mov    0x805148,%eax
  802709:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  80270c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270f:	8b 50 08             	mov    0x8(%eax),%edx
  802712:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802715:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802718:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80271b:	8b 55 08             	mov    0x8(%ebp),%edx
  80271e:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802721:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802725:	75 17                	jne    80273e <alloc_block_NF+0x11c>
  802727:	83 ec 04             	sub    $0x4,%esp
  80272a:	68 04 40 80 00       	push   $0x804004
  80272f:	68 e9 00 00 00       	push   $0xe9
  802734:	68 5b 3f 80 00       	push   $0x803f5b
  802739:	e8 52 db ff ff       	call   800290 <_panic>
  80273e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802741:	8b 00                	mov    (%eax),%eax
  802743:	85 c0                	test   %eax,%eax
  802745:	74 10                	je     802757 <alloc_block_NF+0x135>
  802747:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80274a:	8b 00                	mov    (%eax),%eax
  80274c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80274f:	8b 52 04             	mov    0x4(%edx),%edx
  802752:	89 50 04             	mov    %edx,0x4(%eax)
  802755:	eb 0b                	jmp    802762 <alloc_block_NF+0x140>
  802757:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80275a:	8b 40 04             	mov    0x4(%eax),%eax
  80275d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802762:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802765:	8b 40 04             	mov    0x4(%eax),%eax
  802768:	85 c0                	test   %eax,%eax
  80276a:	74 0f                	je     80277b <alloc_block_NF+0x159>
  80276c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80276f:	8b 40 04             	mov    0x4(%eax),%eax
  802772:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802775:	8b 12                	mov    (%edx),%edx
  802777:	89 10                	mov    %edx,(%eax)
  802779:	eb 0a                	jmp    802785 <alloc_block_NF+0x163>
  80277b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80277e:	8b 00                	mov    (%eax),%eax
  802780:	a3 48 51 80 00       	mov    %eax,0x805148
  802785:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802788:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80278e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802791:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802798:	a1 54 51 80 00       	mov    0x805154,%eax
  80279d:	48                   	dec    %eax
  80279e:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  8027a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027a6:	8b 40 08             	mov    0x8(%eax),%eax
  8027a9:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  8027ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b1:	8b 50 08             	mov    0x8(%eax),%edx
  8027b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b7:	01 c2                	add    %eax,%edx
  8027b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027bc:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  8027bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c2:	8b 40 0c             	mov    0xc(%eax),%eax
  8027c5:	2b 45 08             	sub    0x8(%ebp),%eax
  8027c8:	89 c2                	mov    %eax,%edx
  8027ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cd:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8027d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027d3:	e9 15 04 00 00       	jmp    802bed <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8027d8:	a1 40 51 80 00       	mov    0x805140,%eax
  8027dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027e4:	74 07                	je     8027ed <alloc_block_NF+0x1cb>
  8027e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e9:	8b 00                	mov    (%eax),%eax
  8027eb:	eb 05                	jmp    8027f2 <alloc_block_NF+0x1d0>
  8027ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8027f2:	a3 40 51 80 00       	mov    %eax,0x805140
  8027f7:	a1 40 51 80 00       	mov    0x805140,%eax
  8027fc:	85 c0                	test   %eax,%eax
  8027fe:	0f 85 3e fe ff ff    	jne    802642 <alloc_block_NF+0x20>
  802804:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802808:	0f 85 34 fe ff ff    	jne    802642 <alloc_block_NF+0x20>
  80280e:	e9 d5 03 00 00       	jmp    802be8 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802813:	a1 38 51 80 00       	mov    0x805138,%eax
  802818:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80281b:	e9 b1 01 00 00       	jmp    8029d1 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802820:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802823:	8b 50 08             	mov    0x8(%eax),%edx
  802826:	a1 28 50 80 00       	mov    0x805028,%eax
  80282b:	39 c2                	cmp    %eax,%edx
  80282d:	0f 82 96 01 00 00    	jb     8029c9 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802833:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802836:	8b 40 0c             	mov    0xc(%eax),%eax
  802839:	3b 45 08             	cmp    0x8(%ebp),%eax
  80283c:	0f 82 87 01 00 00    	jb     8029c9 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802842:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802845:	8b 40 0c             	mov    0xc(%eax),%eax
  802848:	3b 45 08             	cmp    0x8(%ebp),%eax
  80284b:	0f 85 95 00 00 00    	jne    8028e6 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802851:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802855:	75 17                	jne    80286e <alloc_block_NF+0x24c>
  802857:	83 ec 04             	sub    $0x4,%esp
  80285a:	68 04 40 80 00       	push   $0x804004
  80285f:	68 fc 00 00 00       	push   $0xfc
  802864:	68 5b 3f 80 00       	push   $0x803f5b
  802869:	e8 22 da ff ff       	call   800290 <_panic>
  80286e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802871:	8b 00                	mov    (%eax),%eax
  802873:	85 c0                	test   %eax,%eax
  802875:	74 10                	je     802887 <alloc_block_NF+0x265>
  802877:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287a:	8b 00                	mov    (%eax),%eax
  80287c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80287f:	8b 52 04             	mov    0x4(%edx),%edx
  802882:	89 50 04             	mov    %edx,0x4(%eax)
  802885:	eb 0b                	jmp    802892 <alloc_block_NF+0x270>
  802887:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288a:	8b 40 04             	mov    0x4(%eax),%eax
  80288d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802892:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802895:	8b 40 04             	mov    0x4(%eax),%eax
  802898:	85 c0                	test   %eax,%eax
  80289a:	74 0f                	je     8028ab <alloc_block_NF+0x289>
  80289c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289f:	8b 40 04             	mov    0x4(%eax),%eax
  8028a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028a5:	8b 12                	mov    (%edx),%edx
  8028a7:	89 10                	mov    %edx,(%eax)
  8028a9:	eb 0a                	jmp    8028b5 <alloc_block_NF+0x293>
  8028ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ae:	8b 00                	mov    (%eax),%eax
  8028b0:	a3 38 51 80 00       	mov    %eax,0x805138
  8028b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028c8:	a1 44 51 80 00       	mov    0x805144,%eax
  8028cd:	48                   	dec    %eax
  8028ce:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8028d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d6:	8b 40 08             	mov    0x8(%eax),%eax
  8028d9:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  8028de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e1:	e9 07 03 00 00       	jmp    802bed <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8028e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e9:	8b 40 0c             	mov    0xc(%eax),%eax
  8028ec:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028ef:	0f 86 d4 00 00 00    	jbe    8029c9 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8028f5:	a1 48 51 80 00       	mov    0x805148,%eax
  8028fa:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  8028fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802900:	8b 50 08             	mov    0x8(%eax),%edx
  802903:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802906:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802909:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80290c:	8b 55 08             	mov    0x8(%ebp),%edx
  80290f:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802912:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802916:	75 17                	jne    80292f <alloc_block_NF+0x30d>
  802918:	83 ec 04             	sub    $0x4,%esp
  80291b:	68 04 40 80 00       	push   $0x804004
  802920:	68 04 01 00 00       	push   $0x104
  802925:	68 5b 3f 80 00       	push   $0x803f5b
  80292a:	e8 61 d9 ff ff       	call   800290 <_panic>
  80292f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802932:	8b 00                	mov    (%eax),%eax
  802934:	85 c0                	test   %eax,%eax
  802936:	74 10                	je     802948 <alloc_block_NF+0x326>
  802938:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80293b:	8b 00                	mov    (%eax),%eax
  80293d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802940:	8b 52 04             	mov    0x4(%edx),%edx
  802943:	89 50 04             	mov    %edx,0x4(%eax)
  802946:	eb 0b                	jmp    802953 <alloc_block_NF+0x331>
  802948:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80294b:	8b 40 04             	mov    0x4(%eax),%eax
  80294e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802953:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802956:	8b 40 04             	mov    0x4(%eax),%eax
  802959:	85 c0                	test   %eax,%eax
  80295b:	74 0f                	je     80296c <alloc_block_NF+0x34a>
  80295d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802960:	8b 40 04             	mov    0x4(%eax),%eax
  802963:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802966:	8b 12                	mov    (%edx),%edx
  802968:	89 10                	mov    %edx,(%eax)
  80296a:	eb 0a                	jmp    802976 <alloc_block_NF+0x354>
  80296c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80296f:	8b 00                	mov    (%eax),%eax
  802971:	a3 48 51 80 00       	mov    %eax,0x805148
  802976:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802979:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80297f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802982:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802989:	a1 54 51 80 00       	mov    0x805154,%eax
  80298e:	48                   	dec    %eax
  80298f:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802994:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802997:	8b 40 08             	mov    0x8(%eax),%eax
  80299a:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  80299f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a2:	8b 50 08             	mov    0x8(%eax),%edx
  8029a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a8:	01 c2                	add    %eax,%edx
  8029aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ad:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8029b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b3:	8b 40 0c             	mov    0xc(%eax),%eax
  8029b6:	2b 45 08             	sub    0x8(%ebp),%eax
  8029b9:	89 c2                	mov    %eax,%edx
  8029bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029be:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8029c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029c4:	e9 24 02 00 00       	jmp    802bed <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8029c9:	a1 40 51 80 00       	mov    0x805140,%eax
  8029ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029d5:	74 07                	je     8029de <alloc_block_NF+0x3bc>
  8029d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029da:	8b 00                	mov    (%eax),%eax
  8029dc:	eb 05                	jmp    8029e3 <alloc_block_NF+0x3c1>
  8029de:	b8 00 00 00 00       	mov    $0x0,%eax
  8029e3:	a3 40 51 80 00       	mov    %eax,0x805140
  8029e8:	a1 40 51 80 00       	mov    0x805140,%eax
  8029ed:	85 c0                	test   %eax,%eax
  8029ef:	0f 85 2b fe ff ff    	jne    802820 <alloc_block_NF+0x1fe>
  8029f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029f9:	0f 85 21 fe ff ff    	jne    802820 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8029ff:	a1 38 51 80 00       	mov    0x805138,%eax
  802a04:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a07:	e9 ae 01 00 00       	jmp    802bba <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802a0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0f:	8b 50 08             	mov    0x8(%eax),%edx
  802a12:	a1 28 50 80 00       	mov    0x805028,%eax
  802a17:	39 c2                	cmp    %eax,%edx
  802a19:	0f 83 93 01 00 00    	jae    802bb2 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802a1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a22:	8b 40 0c             	mov    0xc(%eax),%eax
  802a25:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a28:	0f 82 84 01 00 00    	jb     802bb2 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802a2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a31:	8b 40 0c             	mov    0xc(%eax),%eax
  802a34:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a37:	0f 85 95 00 00 00    	jne    802ad2 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802a3d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a41:	75 17                	jne    802a5a <alloc_block_NF+0x438>
  802a43:	83 ec 04             	sub    $0x4,%esp
  802a46:	68 04 40 80 00       	push   $0x804004
  802a4b:	68 14 01 00 00       	push   $0x114
  802a50:	68 5b 3f 80 00       	push   $0x803f5b
  802a55:	e8 36 d8 ff ff       	call   800290 <_panic>
  802a5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5d:	8b 00                	mov    (%eax),%eax
  802a5f:	85 c0                	test   %eax,%eax
  802a61:	74 10                	je     802a73 <alloc_block_NF+0x451>
  802a63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a66:	8b 00                	mov    (%eax),%eax
  802a68:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a6b:	8b 52 04             	mov    0x4(%edx),%edx
  802a6e:	89 50 04             	mov    %edx,0x4(%eax)
  802a71:	eb 0b                	jmp    802a7e <alloc_block_NF+0x45c>
  802a73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a76:	8b 40 04             	mov    0x4(%eax),%eax
  802a79:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a81:	8b 40 04             	mov    0x4(%eax),%eax
  802a84:	85 c0                	test   %eax,%eax
  802a86:	74 0f                	je     802a97 <alloc_block_NF+0x475>
  802a88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8b:	8b 40 04             	mov    0x4(%eax),%eax
  802a8e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a91:	8b 12                	mov    (%edx),%edx
  802a93:	89 10                	mov    %edx,(%eax)
  802a95:	eb 0a                	jmp    802aa1 <alloc_block_NF+0x47f>
  802a97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9a:	8b 00                	mov    (%eax),%eax
  802a9c:	a3 38 51 80 00       	mov    %eax,0x805138
  802aa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802aaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aad:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ab4:	a1 44 51 80 00       	mov    0x805144,%eax
  802ab9:	48                   	dec    %eax
  802aba:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802abf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac2:	8b 40 08             	mov    0x8(%eax),%eax
  802ac5:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802aca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acd:	e9 1b 01 00 00       	jmp    802bed <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802ad2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad5:	8b 40 0c             	mov    0xc(%eax),%eax
  802ad8:	3b 45 08             	cmp    0x8(%ebp),%eax
  802adb:	0f 86 d1 00 00 00    	jbe    802bb2 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802ae1:	a1 48 51 80 00       	mov    0x805148,%eax
  802ae6:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aec:	8b 50 08             	mov    0x8(%eax),%edx
  802aef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802af2:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802af5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802af8:	8b 55 08             	mov    0x8(%ebp),%edx
  802afb:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802afe:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b02:	75 17                	jne    802b1b <alloc_block_NF+0x4f9>
  802b04:	83 ec 04             	sub    $0x4,%esp
  802b07:	68 04 40 80 00       	push   $0x804004
  802b0c:	68 1c 01 00 00       	push   $0x11c
  802b11:	68 5b 3f 80 00       	push   $0x803f5b
  802b16:	e8 75 d7 ff ff       	call   800290 <_panic>
  802b1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b1e:	8b 00                	mov    (%eax),%eax
  802b20:	85 c0                	test   %eax,%eax
  802b22:	74 10                	je     802b34 <alloc_block_NF+0x512>
  802b24:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b27:	8b 00                	mov    (%eax),%eax
  802b29:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b2c:	8b 52 04             	mov    0x4(%edx),%edx
  802b2f:	89 50 04             	mov    %edx,0x4(%eax)
  802b32:	eb 0b                	jmp    802b3f <alloc_block_NF+0x51d>
  802b34:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b37:	8b 40 04             	mov    0x4(%eax),%eax
  802b3a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b42:	8b 40 04             	mov    0x4(%eax),%eax
  802b45:	85 c0                	test   %eax,%eax
  802b47:	74 0f                	je     802b58 <alloc_block_NF+0x536>
  802b49:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b4c:	8b 40 04             	mov    0x4(%eax),%eax
  802b4f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b52:	8b 12                	mov    (%edx),%edx
  802b54:	89 10                	mov    %edx,(%eax)
  802b56:	eb 0a                	jmp    802b62 <alloc_block_NF+0x540>
  802b58:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b5b:	8b 00                	mov    (%eax),%eax
  802b5d:	a3 48 51 80 00       	mov    %eax,0x805148
  802b62:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b65:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b6e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b75:	a1 54 51 80 00       	mov    0x805154,%eax
  802b7a:	48                   	dec    %eax
  802b7b:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802b80:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b83:	8b 40 08             	mov    0x8(%eax),%eax
  802b86:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802b8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8e:	8b 50 08             	mov    0x8(%eax),%edx
  802b91:	8b 45 08             	mov    0x8(%ebp),%eax
  802b94:	01 c2                	add    %eax,%edx
  802b96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b99:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802b9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9f:	8b 40 0c             	mov    0xc(%eax),%eax
  802ba2:	2b 45 08             	sub    0x8(%ebp),%eax
  802ba5:	89 c2                	mov    %eax,%edx
  802ba7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802baa:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802bad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bb0:	eb 3b                	jmp    802bed <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802bb2:	a1 40 51 80 00       	mov    0x805140,%eax
  802bb7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bbe:	74 07                	je     802bc7 <alloc_block_NF+0x5a5>
  802bc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc3:	8b 00                	mov    (%eax),%eax
  802bc5:	eb 05                	jmp    802bcc <alloc_block_NF+0x5aa>
  802bc7:	b8 00 00 00 00       	mov    $0x0,%eax
  802bcc:	a3 40 51 80 00       	mov    %eax,0x805140
  802bd1:	a1 40 51 80 00       	mov    0x805140,%eax
  802bd6:	85 c0                	test   %eax,%eax
  802bd8:	0f 85 2e fe ff ff    	jne    802a0c <alloc_block_NF+0x3ea>
  802bde:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802be2:	0f 85 24 fe ff ff    	jne    802a0c <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802be8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bed:	c9                   	leave  
  802bee:	c3                   	ret    

00802bef <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802bef:	55                   	push   %ebp
  802bf0:	89 e5                	mov    %esp,%ebp
  802bf2:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802bf5:	a1 38 51 80 00       	mov    0x805138,%eax
  802bfa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802bfd:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802c02:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802c05:	a1 38 51 80 00       	mov    0x805138,%eax
  802c0a:	85 c0                	test   %eax,%eax
  802c0c:	74 14                	je     802c22 <insert_sorted_with_merge_freeList+0x33>
  802c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c11:	8b 50 08             	mov    0x8(%eax),%edx
  802c14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c17:	8b 40 08             	mov    0x8(%eax),%eax
  802c1a:	39 c2                	cmp    %eax,%edx
  802c1c:	0f 87 9b 01 00 00    	ja     802dbd <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802c22:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c26:	75 17                	jne    802c3f <insert_sorted_with_merge_freeList+0x50>
  802c28:	83 ec 04             	sub    $0x4,%esp
  802c2b:	68 38 3f 80 00       	push   $0x803f38
  802c30:	68 38 01 00 00       	push   $0x138
  802c35:	68 5b 3f 80 00       	push   $0x803f5b
  802c3a:	e8 51 d6 ff ff       	call   800290 <_panic>
  802c3f:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802c45:	8b 45 08             	mov    0x8(%ebp),%eax
  802c48:	89 10                	mov    %edx,(%eax)
  802c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4d:	8b 00                	mov    (%eax),%eax
  802c4f:	85 c0                	test   %eax,%eax
  802c51:	74 0d                	je     802c60 <insert_sorted_with_merge_freeList+0x71>
  802c53:	a1 38 51 80 00       	mov    0x805138,%eax
  802c58:	8b 55 08             	mov    0x8(%ebp),%edx
  802c5b:	89 50 04             	mov    %edx,0x4(%eax)
  802c5e:	eb 08                	jmp    802c68 <insert_sorted_with_merge_freeList+0x79>
  802c60:	8b 45 08             	mov    0x8(%ebp),%eax
  802c63:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c68:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6b:	a3 38 51 80 00       	mov    %eax,0x805138
  802c70:	8b 45 08             	mov    0x8(%ebp),%eax
  802c73:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c7a:	a1 44 51 80 00       	mov    0x805144,%eax
  802c7f:	40                   	inc    %eax
  802c80:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802c85:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c89:	0f 84 a8 06 00 00    	je     803337 <insert_sorted_with_merge_freeList+0x748>
  802c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c92:	8b 50 08             	mov    0x8(%eax),%edx
  802c95:	8b 45 08             	mov    0x8(%ebp),%eax
  802c98:	8b 40 0c             	mov    0xc(%eax),%eax
  802c9b:	01 c2                	add    %eax,%edx
  802c9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ca0:	8b 40 08             	mov    0x8(%eax),%eax
  802ca3:	39 c2                	cmp    %eax,%edx
  802ca5:	0f 85 8c 06 00 00    	jne    803337 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802cab:	8b 45 08             	mov    0x8(%ebp),%eax
  802cae:	8b 50 0c             	mov    0xc(%eax),%edx
  802cb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb4:	8b 40 0c             	mov    0xc(%eax),%eax
  802cb7:	01 c2                	add    %eax,%edx
  802cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbc:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802cbf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cc3:	75 17                	jne    802cdc <insert_sorted_with_merge_freeList+0xed>
  802cc5:	83 ec 04             	sub    $0x4,%esp
  802cc8:	68 04 40 80 00       	push   $0x804004
  802ccd:	68 3c 01 00 00       	push   $0x13c
  802cd2:	68 5b 3f 80 00       	push   $0x803f5b
  802cd7:	e8 b4 d5 ff ff       	call   800290 <_panic>
  802cdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cdf:	8b 00                	mov    (%eax),%eax
  802ce1:	85 c0                	test   %eax,%eax
  802ce3:	74 10                	je     802cf5 <insert_sorted_with_merge_freeList+0x106>
  802ce5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ce8:	8b 00                	mov    (%eax),%eax
  802cea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ced:	8b 52 04             	mov    0x4(%edx),%edx
  802cf0:	89 50 04             	mov    %edx,0x4(%eax)
  802cf3:	eb 0b                	jmp    802d00 <insert_sorted_with_merge_freeList+0x111>
  802cf5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf8:	8b 40 04             	mov    0x4(%eax),%eax
  802cfb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d00:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d03:	8b 40 04             	mov    0x4(%eax),%eax
  802d06:	85 c0                	test   %eax,%eax
  802d08:	74 0f                	je     802d19 <insert_sorted_with_merge_freeList+0x12a>
  802d0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d0d:	8b 40 04             	mov    0x4(%eax),%eax
  802d10:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d13:	8b 12                	mov    (%edx),%edx
  802d15:	89 10                	mov    %edx,(%eax)
  802d17:	eb 0a                	jmp    802d23 <insert_sorted_with_merge_freeList+0x134>
  802d19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d1c:	8b 00                	mov    (%eax),%eax
  802d1e:	a3 38 51 80 00       	mov    %eax,0x805138
  802d23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d26:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d2f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d36:	a1 44 51 80 00       	mov    0x805144,%eax
  802d3b:	48                   	dec    %eax
  802d3c:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802d41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d44:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802d4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d4e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802d55:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d59:	75 17                	jne    802d72 <insert_sorted_with_merge_freeList+0x183>
  802d5b:	83 ec 04             	sub    $0x4,%esp
  802d5e:	68 38 3f 80 00       	push   $0x803f38
  802d63:	68 3f 01 00 00       	push   $0x13f
  802d68:	68 5b 3f 80 00       	push   $0x803f5b
  802d6d:	e8 1e d5 ff ff       	call   800290 <_panic>
  802d72:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802d78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d7b:	89 10                	mov    %edx,(%eax)
  802d7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d80:	8b 00                	mov    (%eax),%eax
  802d82:	85 c0                	test   %eax,%eax
  802d84:	74 0d                	je     802d93 <insert_sorted_with_merge_freeList+0x1a4>
  802d86:	a1 48 51 80 00       	mov    0x805148,%eax
  802d8b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d8e:	89 50 04             	mov    %edx,0x4(%eax)
  802d91:	eb 08                	jmp    802d9b <insert_sorted_with_merge_freeList+0x1ac>
  802d93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d96:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d9e:	a3 48 51 80 00       	mov    %eax,0x805148
  802da3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dad:	a1 54 51 80 00       	mov    0x805154,%eax
  802db2:	40                   	inc    %eax
  802db3:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802db8:	e9 7a 05 00 00       	jmp    803337 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc0:	8b 50 08             	mov    0x8(%eax),%edx
  802dc3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dc6:	8b 40 08             	mov    0x8(%eax),%eax
  802dc9:	39 c2                	cmp    %eax,%edx
  802dcb:	0f 82 14 01 00 00    	jb     802ee5 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802dd1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dd4:	8b 50 08             	mov    0x8(%eax),%edx
  802dd7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dda:	8b 40 0c             	mov    0xc(%eax),%eax
  802ddd:	01 c2                	add    %eax,%edx
  802ddf:	8b 45 08             	mov    0x8(%ebp),%eax
  802de2:	8b 40 08             	mov    0x8(%eax),%eax
  802de5:	39 c2                	cmp    %eax,%edx
  802de7:	0f 85 90 00 00 00    	jne    802e7d <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802ded:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802df0:	8b 50 0c             	mov    0xc(%eax),%edx
  802df3:	8b 45 08             	mov    0x8(%ebp),%eax
  802df6:	8b 40 0c             	mov    0xc(%eax),%eax
  802df9:	01 c2                	add    %eax,%edx
  802dfb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dfe:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802e01:	8b 45 08             	mov    0x8(%ebp),%eax
  802e04:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802e0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802e15:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e19:	75 17                	jne    802e32 <insert_sorted_with_merge_freeList+0x243>
  802e1b:	83 ec 04             	sub    $0x4,%esp
  802e1e:	68 38 3f 80 00       	push   $0x803f38
  802e23:	68 49 01 00 00       	push   $0x149
  802e28:	68 5b 3f 80 00       	push   $0x803f5b
  802e2d:	e8 5e d4 ff ff       	call   800290 <_panic>
  802e32:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802e38:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3b:	89 10                	mov    %edx,(%eax)
  802e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e40:	8b 00                	mov    (%eax),%eax
  802e42:	85 c0                	test   %eax,%eax
  802e44:	74 0d                	je     802e53 <insert_sorted_with_merge_freeList+0x264>
  802e46:	a1 48 51 80 00       	mov    0x805148,%eax
  802e4b:	8b 55 08             	mov    0x8(%ebp),%edx
  802e4e:	89 50 04             	mov    %edx,0x4(%eax)
  802e51:	eb 08                	jmp    802e5b <insert_sorted_with_merge_freeList+0x26c>
  802e53:	8b 45 08             	mov    0x8(%ebp),%eax
  802e56:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5e:	a3 48 51 80 00       	mov    %eax,0x805148
  802e63:	8b 45 08             	mov    0x8(%ebp),%eax
  802e66:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e6d:	a1 54 51 80 00       	mov    0x805154,%eax
  802e72:	40                   	inc    %eax
  802e73:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802e78:	e9 bb 04 00 00       	jmp    803338 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802e7d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e81:	75 17                	jne    802e9a <insert_sorted_with_merge_freeList+0x2ab>
  802e83:	83 ec 04             	sub    $0x4,%esp
  802e86:	68 ac 3f 80 00       	push   $0x803fac
  802e8b:	68 4c 01 00 00       	push   $0x14c
  802e90:	68 5b 3f 80 00       	push   $0x803f5b
  802e95:	e8 f6 d3 ff ff       	call   800290 <_panic>
  802e9a:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802ea0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea3:	89 50 04             	mov    %edx,0x4(%eax)
  802ea6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea9:	8b 40 04             	mov    0x4(%eax),%eax
  802eac:	85 c0                	test   %eax,%eax
  802eae:	74 0c                	je     802ebc <insert_sorted_with_merge_freeList+0x2cd>
  802eb0:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802eb5:	8b 55 08             	mov    0x8(%ebp),%edx
  802eb8:	89 10                	mov    %edx,(%eax)
  802eba:	eb 08                	jmp    802ec4 <insert_sorted_with_merge_freeList+0x2d5>
  802ebc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebf:	a3 38 51 80 00       	mov    %eax,0x805138
  802ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ecf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ed5:	a1 44 51 80 00       	mov    0x805144,%eax
  802eda:	40                   	inc    %eax
  802edb:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802ee0:	e9 53 04 00 00       	jmp    803338 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802ee5:	a1 38 51 80 00       	mov    0x805138,%eax
  802eea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802eed:	e9 15 04 00 00       	jmp    803307 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802ef2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef5:	8b 00                	mov    (%eax),%eax
  802ef7:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802efa:	8b 45 08             	mov    0x8(%ebp),%eax
  802efd:	8b 50 08             	mov    0x8(%eax),%edx
  802f00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f03:	8b 40 08             	mov    0x8(%eax),%eax
  802f06:	39 c2                	cmp    %eax,%edx
  802f08:	0f 86 f1 03 00 00    	jbe    8032ff <insert_sorted_with_merge_freeList+0x710>
  802f0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f11:	8b 50 08             	mov    0x8(%eax),%edx
  802f14:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f17:	8b 40 08             	mov    0x8(%eax),%eax
  802f1a:	39 c2                	cmp    %eax,%edx
  802f1c:	0f 83 dd 03 00 00    	jae    8032ff <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802f22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f25:	8b 50 08             	mov    0x8(%eax),%edx
  802f28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2b:	8b 40 0c             	mov    0xc(%eax),%eax
  802f2e:	01 c2                	add    %eax,%edx
  802f30:	8b 45 08             	mov    0x8(%ebp),%eax
  802f33:	8b 40 08             	mov    0x8(%eax),%eax
  802f36:	39 c2                	cmp    %eax,%edx
  802f38:	0f 85 b9 01 00 00    	jne    8030f7 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802f3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f41:	8b 50 08             	mov    0x8(%eax),%edx
  802f44:	8b 45 08             	mov    0x8(%ebp),%eax
  802f47:	8b 40 0c             	mov    0xc(%eax),%eax
  802f4a:	01 c2                	add    %eax,%edx
  802f4c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f4f:	8b 40 08             	mov    0x8(%eax),%eax
  802f52:	39 c2                	cmp    %eax,%edx
  802f54:	0f 85 0d 01 00 00    	jne    803067 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802f5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5d:	8b 50 0c             	mov    0xc(%eax),%edx
  802f60:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f63:	8b 40 0c             	mov    0xc(%eax),%eax
  802f66:	01 c2                	add    %eax,%edx
  802f68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6b:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802f6e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f72:	75 17                	jne    802f8b <insert_sorted_with_merge_freeList+0x39c>
  802f74:	83 ec 04             	sub    $0x4,%esp
  802f77:	68 04 40 80 00       	push   $0x804004
  802f7c:	68 5c 01 00 00       	push   $0x15c
  802f81:	68 5b 3f 80 00       	push   $0x803f5b
  802f86:	e8 05 d3 ff ff       	call   800290 <_panic>
  802f8b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f8e:	8b 00                	mov    (%eax),%eax
  802f90:	85 c0                	test   %eax,%eax
  802f92:	74 10                	je     802fa4 <insert_sorted_with_merge_freeList+0x3b5>
  802f94:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f97:	8b 00                	mov    (%eax),%eax
  802f99:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f9c:	8b 52 04             	mov    0x4(%edx),%edx
  802f9f:	89 50 04             	mov    %edx,0x4(%eax)
  802fa2:	eb 0b                	jmp    802faf <insert_sorted_with_merge_freeList+0x3c0>
  802fa4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fa7:	8b 40 04             	mov    0x4(%eax),%eax
  802faa:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802faf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fb2:	8b 40 04             	mov    0x4(%eax),%eax
  802fb5:	85 c0                	test   %eax,%eax
  802fb7:	74 0f                	je     802fc8 <insert_sorted_with_merge_freeList+0x3d9>
  802fb9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fbc:	8b 40 04             	mov    0x4(%eax),%eax
  802fbf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fc2:	8b 12                	mov    (%edx),%edx
  802fc4:	89 10                	mov    %edx,(%eax)
  802fc6:	eb 0a                	jmp    802fd2 <insert_sorted_with_merge_freeList+0x3e3>
  802fc8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fcb:	8b 00                	mov    (%eax),%eax
  802fcd:	a3 38 51 80 00       	mov    %eax,0x805138
  802fd2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fd5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fdb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fde:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fe5:	a1 44 51 80 00       	mov    0x805144,%eax
  802fea:	48                   	dec    %eax
  802feb:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  802ff0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ff3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  802ffa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ffd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803004:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803008:	75 17                	jne    803021 <insert_sorted_with_merge_freeList+0x432>
  80300a:	83 ec 04             	sub    $0x4,%esp
  80300d:	68 38 3f 80 00       	push   $0x803f38
  803012:	68 5f 01 00 00       	push   $0x15f
  803017:	68 5b 3f 80 00       	push   $0x803f5b
  80301c:	e8 6f d2 ff ff       	call   800290 <_panic>
  803021:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803027:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80302a:	89 10                	mov    %edx,(%eax)
  80302c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80302f:	8b 00                	mov    (%eax),%eax
  803031:	85 c0                	test   %eax,%eax
  803033:	74 0d                	je     803042 <insert_sorted_with_merge_freeList+0x453>
  803035:	a1 48 51 80 00       	mov    0x805148,%eax
  80303a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80303d:	89 50 04             	mov    %edx,0x4(%eax)
  803040:	eb 08                	jmp    80304a <insert_sorted_with_merge_freeList+0x45b>
  803042:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803045:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80304a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80304d:	a3 48 51 80 00       	mov    %eax,0x805148
  803052:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803055:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80305c:	a1 54 51 80 00       	mov    0x805154,%eax
  803061:	40                   	inc    %eax
  803062:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803067:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80306a:	8b 50 0c             	mov    0xc(%eax),%edx
  80306d:	8b 45 08             	mov    0x8(%ebp),%eax
  803070:	8b 40 0c             	mov    0xc(%eax),%eax
  803073:	01 c2                	add    %eax,%edx
  803075:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803078:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  80307b:	8b 45 08             	mov    0x8(%ebp),%eax
  80307e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803085:	8b 45 08             	mov    0x8(%ebp),%eax
  803088:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80308f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803093:	75 17                	jne    8030ac <insert_sorted_with_merge_freeList+0x4bd>
  803095:	83 ec 04             	sub    $0x4,%esp
  803098:	68 38 3f 80 00       	push   $0x803f38
  80309d:	68 64 01 00 00       	push   $0x164
  8030a2:	68 5b 3f 80 00       	push   $0x803f5b
  8030a7:	e8 e4 d1 ff ff       	call   800290 <_panic>
  8030ac:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8030b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b5:	89 10                	mov    %edx,(%eax)
  8030b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ba:	8b 00                	mov    (%eax),%eax
  8030bc:	85 c0                	test   %eax,%eax
  8030be:	74 0d                	je     8030cd <insert_sorted_with_merge_freeList+0x4de>
  8030c0:	a1 48 51 80 00       	mov    0x805148,%eax
  8030c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8030c8:	89 50 04             	mov    %edx,0x4(%eax)
  8030cb:	eb 08                	jmp    8030d5 <insert_sorted_with_merge_freeList+0x4e6>
  8030cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d8:	a3 48 51 80 00       	mov    %eax,0x805148
  8030dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030e7:	a1 54 51 80 00       	mov    0x805154,%eax
  8030ec:	40                   	inc    %eax
  8030ed:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8030f2:	e9 41 02 00 00       	jmp    803338 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8030f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fa:	8b 50 08             	mov    0x8(%eax),%edx
  8030fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803100:	8b 40 0c             	mov    0xc(%eax),%eax
  803103:	01 c2                	add    %eax,%edx
  803105:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803108:	8b 40 08             	mov    0x8(%eax),%eax
  80310b:	39 c2                	cmp    %eax,%edx
  80310d:	0f 85 7c 01 00 00    	jne    80328f <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803113:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803117:	74 06                	je     80311f <insert_sorted_with_merge_freeList+0x530>
  803119:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80311d:	75 17                	jne    803136 <insert_sorted_with_merge_freeList+0x547>
  80311f:	83 ec 04             	sub    $0x4,%esp
  803122:	68 74 3f 80 00       	push   $0x803f74
  803127:	68 69 01 00 00       	push   $0x169
  80312c:	68 5b 3f 80 00       	push   $0x803f5b
  803131:	e8 5a d1 ff ff       	call   800290 <_panic>
  803136:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803139:	8b 50 04             	mov    0x4(%eax),%edx
  80313c:	8b 45 08             	mov    0x8(%ebp),%eax
  80313f:	89 50 04             	mov    %edx,0x4(%eax)
  803142:	8b 45 08             	mov    0x8(%ebp),%eax
  803145:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803148:	89 10                	mov    %edx,(%eax)
  80314a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80314d:	8b 40 04             	mov    0x4(%eax),%eax
  803150:	85 c0                	test   %eax,%eax
  803152:	74 0d                	je     803161 <insert_sorted_with_merge_freeList+0x572>
  803154:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803157:	8b 40 04             	mov    0x4(%eax),%eax
  80315a:	8b 55 08             	mov    0x8(%ebp),%edx
  80315d:	89 10                	mov    %edx,(%eax)
  80315f:	eb 08                	jmp    803169 <insert_sorted_with_merge_freeList+0x57a>
  803161:	8b 45 08             	mov    0x8(%ebp),%eax
  803164:	a3 38 51 80 00       	mov    %eax,0x805138
  803169:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80316c:	8b 55 08             	mov    0x8(%ebp),%edx
  80316f:	89 50 04             	mov    %edx,0x4(%eax)
  803172:	a1 44 51 80 00       	mov    0x805144,%eax
  803177:	40                   	inc    %eax
  803178:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  80317d:	8b 45 08             	mov    0x8(%ebp),%eax
  803180:	8b 50 0c             	mov    0xc(%eax),%edx
  803183:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803186:	8b 40 0c             	mov    0xc(%eax),%eax
  803189:	01 c2                	add    %eax,%edx
  80318b:	8b 45 08             	mov    0x8(%ebp),%eax
  80318e:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803191:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803195:	75 17                	jne    8031ae <insert_sorted_with_merge_freeList+0x5bf>
  803197:	83 ec 04             	sub    $0x4,%esp
  80319a:	68 04 40 80 00       	push   $0x804004
  80319f:	68 6b 01 00 00       	push   $0x16b
  8031a4:	68 5b 3f 80 00       	push   $0x803f5b
  8031a9:	e8 e2 d0 ff ff       	call   800290 <_panic>
  8031ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031b1:	8b 00                	mov    (%eax),%eax
  8031b3:	85 c0                	test   %eax,%eax
  8031b5:	74 10                	je     8031c7 <insert_sorted_with_merge_freeList+0x5d8>
  8031b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ba:	8b 00                	mov    (%eax),%eax
  8031bc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031bf:	8b 52 04             	mov    0x4(%edx),%edx
  8031c2:	89 50 04             	mov    %edx,0x4(%eax)
  8031c5:	eb 0b                	jmp    8031d2 <insert_sorted_with_merge_freeList+0x5e3>
  8031c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ca:	8b 40 04             	mov    0x4(%eax),%eax
  8031cd:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d5:	8b 40 04             	mov    0x4(%eax),%eax
  8031d8:	85 c0                	test   %eax,%eax
  8031da:	74 0f                	je     8031eb <insert_sorted_with_merge_freeList+0x5fc>
  8031dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031df:	8b 40 04             	mov    0x4(%eax),%eax
  8031e2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031e5:	8b 12                	mov    (%edx),%edx
  8031e7:	89 10                	mov    %edx,(%eax)
  8031e9:	eb 0a                	jmp    8031f5 <insert_sorted_with_merge_freeList+0x606>
  8031eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ee:	8b 00                	mov    (%eax),%eax
  8031f0:	a3 38 51 80 00       	mov    %eax,0x805138
  8031f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803201:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803208:	a1 44 51 80 00       	mov    0x805144,%eax
  80320d:	48                   	dec    %eax
  80320e:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803213:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803216:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  80321d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803220:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803227:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80322b:	75 17                	jne    803244 <insert_sorted_with_merge_freeList+0x655>
  80322d:	83 ec 04             	sub    $0x4,%esp
  803230:	68 38 3f 80 00       	push   $0x803f38
  803235:	68 6e 01 00 00       	push   $0x16e
  80323a:	68 5b 3f 80 00       	push   $0x803f5b
  80323f:	e8 4c d0 ff ff       	call   800290 <_panic>
  803244:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80324a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80324d:	89 10                	mov    %edx,(%eax)
  80324f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803252:	8b 00                	mov    (%eax),%eax
  803254:	85 c0                	test   %eax,%eax
  803256:	74 0d                	je     803265 <insert_sorted_with_merge_freeList+0x676>
  803258:	a1 48 51 80 00       	mov    0x805148,%eax
  80325d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803260:	89 50 04             	mov    %edx,0x4(%eax)
  803263:	eb 08                	jmp    80326d <insert_sorted_with_merge_freeList+0x67e>
  803265:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803268:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80326d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803270:	a3 48 51 80 00       	mov    %eax,0x805148
  803275:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803278:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80327f:	a1 54 51 80 00       	mov    0x805154,%eax
  803284:	40                   	inc    %eax
  803285:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80328a:	e9 a9 00 00 00       	jmp    803338 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  80328f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803293:	74 06                	je     80329b <insert_sorted_with_merge_freeList+0x6ac>
  803295:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803299:	75 17                	jne    8032b2 <insert_sorted_with_merge_freeList+0x6c3>
  80329b:	83 ec 04             	sub    $0x4,%esp
  80329e:	68 d0 3f 80 00       	push   $0x803fd0
  8032a3:	68 73 01 00 00       	push   $0x173
  8032a8:	68 5b 3f 80 00       	push   $0x803f5b
  8032ad:	e8 de cf ff ff       	call   800290 <_panic>
  8032b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b5:	8b 10                	mov    (%eax),%edx
  8032b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ba:	89 10                	mov    %edx,(%eax)
  8032bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8032bf:	8b 00                	mov    (%eax),%eax
  8032c1:	85 c0                	test   %eax,%eax
  8032c3:	74 0b                	je     8032d0 <insert_sorted_with_merge_freeList+0x6e1>
  8032c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c8:	8b 00                	mov    (%eax),%eax
  8032ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8032cd:	89 50 04             	mov    %edx,0x4(%eax)
  8032d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8032d6:	89 10                	mov    %edx,(%eax)
  8032d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032db:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032de:	89 50 04             	mov    %edx,0x4(%eax)
  8032e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e4:	8b 00                	mov    (%eax),%eax
  8032e6:	85 c0                	test   %eax,%eax
  8032e8:	75 08                	jne    8032f2 <insert_sorted_with_merge_freeList+0x703>
  8032ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ed:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032f2:	a1 44 51 80 00       	mov    0x805144,%eax
  8032f7:	40                   	inc    %eax
  8032f8:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  8032fd:	eb 39                	jmp    803338 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8032ff:	a1 40 51 80 00       	mov    0x805140,%eax
  803304:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803307:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80330b:	74 07                	je     803314 <insert_sorted_with_merge_freeList+0x725>
  80330d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803310:	8b 00                	mov    (%eax),%eax
  803312:	eb 05                	jmp    803319 <insert_sorted_with_merge_freeList+0x72a>
  803314:	b8 00 00 00 00       	mov    $0x0,%eax
  803319:	a3 40 51 80 00       	mov    %eax,0x805140
  80331e:	a1 40 51 80 00       	mov    0x805140,%eax
  803323:	85 c0                	test   %eax,%eax
  803325:	0f 85 c7 fb ff ff    	jne    802ef2 <insert_sorted_with_merge_freeList+0x303>
  80332b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80332f:	0f 85 bd fb ff ff    	jne    802ef2 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803335:	eb 01                	jmp    803338 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803337:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803338:	90                   	nop
  803339:	c9                   	leave  
  80333a:	c3                   	ret    

0080333b <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  80333b:	55                   	push   %ebp
  80333c:	89 e5                	mov    %esp,%ebp
  80333e:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803341:	8b 55 08             	mov    0x8(%ebp),%edx
  803344:	89 d0                	mov    %edx,%eax
  803346:	c1 e0 02             	shl    $0x2,%eax
  803349:	01 d0                	add    %edx,%eax
  80334b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803352:	01 d0                	add    %edx,%eax
  803354:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80335b:	01 d0                	add    %edx,%eax
  80335d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803364:	01 d0                	add    %edx,%eax
  803366:	c1 e0 04             	shl    $0x4,%eax
  803369:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  80336c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803373:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803376:	83 ec 0c             	sub    $0xc,%esp
  803379:	50                   	push   %eax
  80337a:	e8 26 e7 ff ff       	call   801aa5 <sys_get_virtual_time>
  80337f:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803382:	eb 41                	jmp    8033c5 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803384:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803387:	83 ec 0c             	sub    $0xc,%esp
  80338a:	50                   	push   %eax
  80338b:	e8 15 e7 ff ff       	call   801aa5 <sys_get_virtual_time>
  803390:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803393:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803396:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803399:	29 c2                	sub    %eax,%edx
  80339b:	89 d0                	mov    %edx,%eax
  80339d:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8033a0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8033a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033a6:	89 d1                	mov    %edx,%ecx
  8033a8:	29 c1                	sub    %eax,%ecx
  8033aa:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8033ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033b0:	39 c2                	cmp    %eax,%edx
  8033b2:	0f 97 c0             	seta   %al
  8033b5:	0f b6 c0             	movzbl %al,%eax
  8033b8:	29 c1                	sub    %eax,%ecx
  8033ba:	89 c8                	mov    %ecx,%eax
  8033bc:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8033bf:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8033c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8033c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8033cb:	72 b7                	jb     803384 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8033cd:	90                   	nop
  8033ce:	c9                   	leave  
  8033cf:	c3                   	ret    

008033d0 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8033d0:	55                   	push   %ebp
  8033d1:	89 e5                	mov    %esp,%ebp
  8033d3:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8033d6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8033dd:	eb 03                	jmp    8033e2 <busy_wait+0x12>
  8033df:	ff 45 fc             	incl   -0x4(%ebp)
  8033e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8033e5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8033e8:	72 f5                	jb     8033df <busy_wait+0xf>
	return i;
  8033ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8033ed:	c9                   	leave  
  8033ee:	c3                   	ret    
  8033ef:	90                   	nop

008033f0 <__udivdi3>:
  8033f0:	55                   	push   %ebp
  8033f1:	57                   	push   %edi
  8033f2:	56                   	push   %esi
  8033f3:	53                   	push   %ebx
  8033f4:	83 ec 1c             	sub    $0x1c,%esp
  8033f7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8033fb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8033ff:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803403:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803407:	89 ca                	mov    %ecx,%edx
  803409:	89 f8                	mov    %edi,%eax
  80340b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80340f:	85 f6                	test   %esi,%esi
  803411:	75 2d                	jne    803440 <__udivdi3+0x50>
  803413:	39 cf                	cmp    %ecx,%edi
  803415:	77 65                	ja     80347c <__udivdi3+0x8c>
  803417:	89 fd                	mov    %edi,%ebp
  803419:	85 ff                	test   %edi,%edi
  80341b:	75 0b                	jne    803428 <__udivdi3+0x38>
  80341d:	b8 01 00 00 00       	mov    $0x1,%eax
  803422:	31 d2                	xor    %edx,%edx
  803424:	f7 f7                	div    %edi
  803426:	89 c5                	mov    %eax,%ebp
  803428:	31 d2                	xor    %edx,%edx
  80342a:	89 c8                	mov    %ecx,%eax
  80342c:	f7 f5                	div    %ebp
  80342e:	89 c1                	mov    %eax,%ecx
  803430:	89 d8                	mov    %ebx,%eax
  803432:	f7 f5                	div    %ebp
  803434:	89 cf                	mov    %ecx,%edi
  803436:	89 fa                	mov    %edi,%edx
  803438:	83 c4 1c             	add    $0x1c,%esp
  80343b:	5b                   	pop    %ebx
  80343c:	5e                   	pop    %esi
  80343d:	5f                   	pop    %edi
  80343e:	5d                   	pop    %ebp
  80343f:	c3                   	ret    
  803440:	39 ce                	cmp    %ecx,%esi
  803442:	77 28                	ja     80346c <__udivdi3+0x7c>
  803444:	0f bd fe             	bsr    %esi,%edi
  803447:	83 f7 1f             	xor    $0x1f,%edi
  80344a:	75 40                	jne    80348c <__udivdi3+0x9c>
  80344c:	39 ce                	cmp    %ecx,%esi
  80344e:	72 0a                	jb     80345a <__udivdi3+0x6a>
  803450:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803454:	0f 87 9e 00 00 00    	ja     8034f8 <__udivdi3+0x108>
  80345a:	b8 01 00 00 00       	mov    $0x1,%eax
  80345f:	89 fa                	mov    %edi,%edx
  803461:	83 c4 1c             	add    $0x1c,%esp
  803464:	5b                   	pop    %ebx
  803465:	5e                   	pop    %esi
  803466:	5f                   	pop    %edi
  803467:	5d                   	pop    %ebp
  803468:	c3                   	ret    
  803469:	8d 76 00             	lea    0x0(%esi),%esi
  80346c:	31 ff                	xor    %edi,%edi
  80346e:	31 c0                	xor    %eax,%eax
  803470:	89 fa                	mov    %edi,%edx
  803472:	83 c4 1c             	add    $0x1c,%esp
  803475:	5b                   	pop    %ebx
  803476:	5e                   	pop    %esi
  803477:	5f                   	pop    %edi
  803478:	5d                   	pop    %ebp
  803479:	c3                   	ret    
  80347a:	66 90                	xchg   %ax,%ax
  80347c:	89 d8                	mov    %ebx,%eax
  80347e:	f7 f7                	div    %edi
  803480:	31 ff                	xor    %edi,%edi
  803482:	89 fa                	mov    %edi,%edx
  803484:	83 c4 1c             	add    $0x1c,%esp
  803487:	5b                   	pop    %ebx
  803488:	5e                   	pop    %esi
  803489:	5f                   	pop    %edi
  80348a:	5d                   	pop    %ebp
  80348b:	c3                   	ret    
  80348c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803491:	89 eb                	mov    %ebp,%ebx
  803493:	29 fb                	sub    %edi,%ebx
  803495:	89 f9                	mov    %edi,%ecx
  803497:	d3 e6                	shl    %cl,%esi
  803499:	89 c5                	mov    %eax,%ebp
  80349b:	88 d9                	mov    %bl,%cl
  80349d:	d3 ed                	shr    %cl,%ebp
  80349f:	89 e9                	mov    %ebp,%ecx
  8034a1:	09 f1                	or     %esi,%ecx
  8034a3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8034a7:	89 f9                	mov    %edi,%ecx
  8034a9:	d3 e0                	shl    %cl,%eax
  8034ab:	89 c5                	mov    %eax,%ebp
  8034ad:	89 d6                	mov    %edx,%esi
  8034af:	88 d9                	mov    %bl,%cl
  8034b1:	d3 ee                	shr    %cl,%esi
  8034b3:	89 f9                	mov    %edi,%ecx
  8034b5:	d3 e2                	shl    %cl,%edx
  8034b7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034bb:	88 d9                	mov    %bl,%cl
  8034bd:	d3 e8                	shr    %cl,%eax
  8034bf:	09 c2                	or     %eax,%edx
  8034c1:	89 d0                	mov    %edx,%eax
  8034c3:	89 f2                	mov    %esi,%edx
  8034c5:	f7 74 24 0c          	divl   0xc(%esp)
  8034c9:	89 d6                	mov    %edx,%esi
  8034cb:	89 c3                	mov    %eax,%ebx
  8034cd:	f7 e5                	mul    %ebp
  8034cf:	39 d6                	cmp    %edx,%esi
  8034d1:	72 19                	jb     8034ec <__udivdi3+0xfc>
  8034d3:	74 0b                	je     8034e0 <__udivdi3+0xf0>
  8034d5:	89 d8                	mov    %ebx,%eax
  8034d7:	31 ff                	xor    %edi,%edi
  8034d9:	e9 58 ff ff ff       	jmp    803436 <__udivdi3+0x46>
  8034de:	66 90                	xchg   %ax,%ax
  8034e0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8034e4:	89 f9                	mov    %edi,%ecx
  8034e6:	d3 e2                	shl    %cl,%edx
  8034e8:	39 c2                	cmp    %eax,%edx
  8034ea:	73 e9                	jae    8034d5 <__udivdi3+0xe5>
  8034ec:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8034ef:	31 ff                	xor    %edi,%edi
  8034f1:	e9 40 ff ff ff       	jmp    803436 <__udivdi3+0x46>
  8034f6:	66 90                	xchg   %ax,%ax
  8034f8:	31 c0                	xor    %eax,%eax
  8034fa:	e9 37 ff ff ff       	jmp    803436 <__udivdi3+0x46>
  8034ff:	90                   	nop

00803500 <__umoddi3>:
  803500:	55                   	push   %ebp
  803501:	57                   	push   %edi
  803502:	56                   	push   %esi
  803503:	53                   	push   %ebx
  803504:	83 ec 1c             	sub    $0x1c,%esp
  803507:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80350b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80350f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803513:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803517:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80351b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80351f:	89 f3                	mov    %esi,%ebx
  803521:	89 fa                	mov    %edi,%edx
  803523:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803527:	89 34 24             	mov    %esi,(%esp)
  80352a:	85 c0                	test   %eax,%eax
  80352c:	75 1a                	jne    803548 <__umoddi3+0x48>
  80352e:	39 f7                	cmp    %esi,%edi
  803530:	0f 86 a2 00 00 00    	jbe    8035d8 <__umoddi3+0xd8>
  803536:	89 c8                	mov    %ecx,%eax
  803538:	89 f2                	mov    %esi,%edx
  80353a:	f7 f7                	div    %edi
  80353c:	89 d0                	mov    %edx,%eax
  80353e:	31 d2                	xor    %edx,%edx
  803540:	83 c4 1c             	add    $0x1c,%esp
  803543:	5b                   	pop    %ebx
  803544:	5e                   	pop    %esi
  803545:	5f                   	pop    %edi
  803546:	5d                   	pop    %ebp
  803547:	c3                   	ret    
  803548:	39 f0                	cmp    %esi,%eax
  80354a:	0f 87 ac 00 00 00    	ja     8035fc <__umoddi3+0xfc>
  803550:	0f bd e8             	bsr    %eax,%ebp
  803553:	83 f5 1f             	xor    $0x1f,%ebp
  803556:	0f 84 ac 00 00 00    	je     803608 <__umoddi3+0x108>
  80355c:	bf 20 00 00 00       	mov    $0x20,%edi
  803561:	29 ef                	sub    %ebp,%edi
  803563:	89 fe                	mov    %edi,%esi
  803565:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803569:	89 e9                	mov    %ebp,%ecx
  80356b:	d3 e0                	shl    %cl,%eax
  80356d:	89 d7                	mov    %edx,%edi
  80356f:	89 f1                	mov    %esi,%ecx
  803571:	d3 ef                	shr    %cl,%edi
  803573:	09 c7                	or     %eax,%edi
  803575:	89 e9                	mov    %ebp,%ecx
  803577:	d3 e2                	shl    %cl,%edx
  803579:	89 14 24             	mov    %edx,(%esp)
  80357c:	89 d8                	mov    %ebx,%eax
  80357e:	d3 e0                	shl    %cl,%eax
  803580:	89 c2                	mov    %eax,%edx
  803582:	8b 44 24 08          	mov    0x8(%esp),%eax
  803586:	d3 e0                	shl    %cl,%eax
  803588:	89 44 24 04          	mov    %eax,0x4(%esp)
  80358c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803590:	89 f1                	mov    %esi,%ecx
  803592:	d3 e8                	shr    %cl,%eax
  803594:	09 d0                	or     %edx,%eax
  803596:	d3 eb                	shr    %cl,%ebx
  803598:	89 da                	mov    %ebx,%edx
  80359a:	f7 f7                	div    %edi
  80359c:	89 d3                	mov    %edx,%ebx
  80359e:	f7 24 24             	mull   (%esp)
  8035a1:	89 c6                	mov    %eax,%esi
  8035a3:	89 d1                	mov    %edx,%ecx
  8035a5:	39 d3                	cmp    %edx,%ebx
  8035a7:	0f 82 87 00 00 00    	jb     803634 <__umoddi3+0x134>
  8035ad:	0f 84 91 00 00 00    	je     803644 <__umoddi3+0x144>
  8035b3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8035b7:	29 f2                	sub    %esi,%edx
  8035b9:	19 cb                	sbb    %ecx,%ebx
  8035bb:	89 d8                	mov    %ebx,%eax
  8035bd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8035c1:	d3 e0                	shl    %cl,%eax
  8035c3:	89 e9                	mov    %ebp,%ecx
  8035c5:	d3 ea                	shr    %cl,%edx
  8035c7:	09 d0                	or     %edx,%eax
  8035c9:	89 e9                	mov    %ebp,%ecx
  8035cb:	d3 eb                	shr    %cl,%ebx
  8035cd:	89 da                	mov    %ebx,%edx
  8035cf:	83 c4 1c             	add    $0x1c,%esp
  8035d2:	5b                   	pop    %ebx
  8035d3:	5e                   	pop    %esi
  8035d4:	5f                   	pop    %edi
  8035d5:	5d                   	pop    %ebp
  8035d6:	c3                   	ret    
  8035d7:	90                   	nop
  8035d8:	89 fd                	mov    %edi,%ebp
  8035da:	85 ff                	test   %edi,%edi
  8035dc:	75 0b                	jne    8035e9 <__umoddi3+0xe9>
  8035de:	b8 01 00 00 00       	mov    $0x1,%eax
  8035e3:	31 d2                	xor    %edx,%edx
  8035e5:	f7 f7                	div    %edi
  8035e7:	89 c5                	mov    %eax,%ebp
  8035e9:	89 f0                	mov    %esi,%eax
  8035eb:	31 d2                	xor    %edx,%edx
  8035ed:	f7 f5                	div    %ebp
  8035ef:	89 c8                	mov    %ecx,%eax
  8035f1:	f7 f5                	div    %ebp
  8035f3:	89 d0                	mov    %edx,%eax
  8035f5:	e9 44 ff ff ff       	jmp    80353e <__umoddi3+0x3e>
  8035fa:	66 90                	xchg   %ax,%ax
  8035fc:	89 c8                	mov    %ecx,%eax
  8035fe:	89 f2                	mov    %esi,%edx
  803600:	83 c4 1c             	add    $0x1c,%esp
  803603:	5b                   	pop    %ebx
  803604:	5e                   	pop    %esi
  803605:	5f                   	pop    %edi
  803606:	5d                   	pop    %ebp
  803607:	c3                   	ret    
  803608:	3b 04 24             	cmp    (%esp),%eax
  80360b:	72 06                	jb     803613 <__umoddi3+0x113>
  80360d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803611:	77 0f                	ja     803622 <__umoddi3+0x122>
  803613:	89 f2                	mov    %esi,%edx
  803615:	29 f9                	sub    %edi,%ecx
  803617:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80361b:	89 14 24             	mov    %edx,(%esp)
  80361e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803622:	8b 44 24 04          	mov    0x4(%esp),%eax
  803626:	8b 14 24             	mov    (%esp),%edx
  803629:	83 c4 1c             	add    $0x1c,%esp
  80362c:	5b                   	pop    %ebx
  80362d:	5e                   	pop    %esi
  80362e:	5f                   	pop    %edi
  80362f:	5d                   	pop    %ebp
  803630:	c3                   	ret    
  803631:	8d 76 00             	lea    0x0(%esi),%esi
  803634:	2b 04 24             	sub    (%esp),%eax
  803637:	19 fa                	sbb    %edi,%edx
  803639:	89 d1                	mov    %edx,%ecx
  80363b:	89 c6                	mov    %eax,%esi
  80363d:	e9 71 ff ff ff       	jmp    8035b3 <__umoddi3+0xb3>
  803642:	66 90                	xchg   %ax,%ax
  803644:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803648:	72 ea                	jb     803634 <__umoddi3+0x134>
  80364a:	89 d9                	mov    %ebx,%ecx
  80364c:	e9 62 ff ff ff       	jmp    8035b3 <__umoddi3+0xb3>
