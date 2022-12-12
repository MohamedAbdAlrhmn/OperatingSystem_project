
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
  80008c:	68 40 36 80 00       	push   $0x803640
  800091:	6a 12                	push   $0x12
  800093:	68 5c 36 80 00       	push   $0x80365c
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
  8000aa:	e8 9e 19 00 00       	call   801a4d <sys_getparentenvid>
  8000af:	83 ec 08             	sub    $0x8,%esp
  8000b2:	68 79 36 80 00       	push   $0x803679
  8000b7:	50                   	push   %eax
  8000b8:	e8 f3 14 00 00       	call   8015b0 <sget>
  8000bd:	83 c4 10             	add    $0x10,%esp
  8000c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("Slave B1 env used x (getSharedObject)\n");
  8000c3:	83 ec 0c             	sub    $0xc,%esp
  8000c6:	68 7c 36 80 00       	push   $0x80367c
  8000cb:	e8 74 04 00 00       	call   800544 <cprintf>
  8000d0:	83 c4 10             	add    $0x10,%esp
	//To indicate that it's successfully got x
	inctst();
  8000d3:	e8 9a 1a 00 00       	call   801b72 <inctst>
	cprintf("Slave B1 please be patient ...\n");
  8000d8:	83 ec 0c             	sub    $0xc,%esp
  8000db:	68 a4 36 80 00       	push   $0x8036a4
  8000e0:	e8 5f 04 00 00       	call   800544 <cprintf>
  8000e5:	83 c4 10             	add    $0x10,%esp

	//sleep a while to allow the master to remove x & z
	env_sleep(6000);
  8000e8:	83 ec 0c             	sub    $0xc,%esp
  8000eb:	68 70 17 00 00       	push   $0x1770
  8000f0:	e8 21 32 00 00       	call   803316 <env_sleep>
  8000f5:	83 c4 10             	add    $0x10,%esp

	int freeFrames = sys_calculate_free_frames() ;
  8000f8:	e8 57 16 00 00       	call   801754 <sys_calculate_free_frames>
  8000fd:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sfree(x);
  800100:	83 ec 0c             	sub    $0xc,%esp
  800103:	ff 75 ec             	pushl  -0x14(%ebp)
  800106:	e8 e9 14 00 00       	call   8015f4 <sfree>
  80010b:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave B1 env removed x\n");
  80010e:	83 ec 0c             	sub    $0xc,%esp
  800111:	68 c4 36 80 00       	push   $0x8036c4
  800116:	e8 29 04 00 00       	call   800544 <cprintf>
  80011b:	83 c4 10             	add    $0x10,%esp
	int expected = (1+1) + (1+1);
  80011e:	c7 45 e4 04 00 00 00 	movl   $0x4,-0x1c(%ebp)
	if ((sys_calculate_free_frames() - freeFrames) !=  expected) panic("B1 wrong free: frames removed not equal 4 !, correct frames to be removed are 4:\nfrom the env: 1 table and 1 for frame of x\nframes_storage of x: should be cleared now\n");
  800125:	e8 2a 16 00 00       	call   801754 <sys_calculate_free_frames>
  80012a:	89 c2                	mov    %eax,%edx
  80012c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80012f:	29 c2                	sub    %eax,%edx
  800131:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800134:	39 c2                	cmp    %eax,%edx
  800136:	74 14                	je     80014c <_main+0x114>
  800138:	83 ec 04             	sub    $0x4,%esp
  80013b:	68 dc 36 80 00       	push   $0x8036dc
  800140:	6a 27                	push   $0x27
  800142:	68 5c 36 80 00       	push   $0x80365c
  800147:	e8 44 01 00 00       	call   800290 <_panic>

	//To indicate that it's completed successfully
	inctst();
  80014c:	e8 21 1a 00 00       	call   801b72 <inctst>
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
  80015a:	e8 d5 18 00 00       	call   801a34 <sys_getenvindex>
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
  800181:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800186:	a1 20 40 80 00       	mov    0x804020,%eax
  80018b:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800191:	84 c0                	test   %al,%al
  800193:	74 0f                	je     8001a4 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800195:	a1 20 40 80 00       	mov    0x804020,%eax
  80019a:	05 5c 05 00 00       	add    $0x55c,%eax
  80019f:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001a4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001a8:	7e 0a                	jle    8001b4 <libmain+0x60>
		binaryname = argv[0];
  8001aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001ad:	8b 00                	mov    (%eax),%eax
  8001af:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8001b4:	83 ec 08             	sub    $0x8,%esp
  8001b7:	ff 75 0c             	pushl  0xc(%ebp)
  8001ba:	ff 75 08             	pushl  0x8(%ebp)
  8001bd:	e8 76 fe ff ff       	call   800038 <_main>
  8001c2:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001c5:	e8 77 16 00 00       	call   801841 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001ca:	83 ec 0c             	sub    $0xc,%esp
  8001cd:	68 9c 37 80 00       	push   $0x80379c
  8001d2:	e8 6d 03 00 00       	call   800544 <cprintf>
  8001d7:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001da:	a1 20 40 80 00       	mov    0x804020,%eax
  8001df:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8001e5:	a1 20 40 80 00       	mov    0x804020,%eax
  8001ea:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8001f0:	83 ec 04             	sub    $0x4,%esp
  8001f3:	52                   	push   %edx
  8001f4:	50                   	push   %eax
  8001f5:	68 c4 37 80 00       	push   $0x8037c4
  8001fa:	e8 45 03 00 00       	call   800544 <cprintf>
  8001ff:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800202:	a1 20 40 80 00       	mov    0x804020,%eax
  800207:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80020d:	a1 20 40 80 00       	mov    0x804020,%eax
  800212:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800218:	a1 20 40 80 00       	mov    0x804020,%eax
  80021d:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800223:	51                   	push   %ecx
  800224:	52                   	push   %edx
  800225:	50                   	push   %eax
  800226:	68 ec 37 80 00       	push   $0x8037ec
  80022b:	e8 14 03 00 00       	call   800544 <cprintf>
  800230:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800233:	a1 20 40 80 00       	mov    0x804020,%eax
  800238:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80023e:	83 ec 08             	sub    $0x8,%esp
  800241:	50                   	push   %eax
  800242:	68 44 38 80 00       	push   $0x803844
  800247:	e8 f8 02 00 00       	call   800544 <cprintf>
  80024c:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80024f:	83 ec 0c             	sub    $0xc,%esp
  800252:	68 9c 37 80 00       	push   $0x80379c
  800257:	e8 e8 02 00 00       	call   800544 <cprintf>
  80025c:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80025f:	e8 f7 15 00 00       	call   80185b <sys_enable_interrupt>

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
  800277:	e8 84 17 00 00       	call   801a00 <sys_destroy_env>
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
  800288:	e8 d9 17 00 00       	call   801a66 <sys_exit_env>
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
  80029f:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8002a4:	85 c0                	test   %eax,%eax
  8002a6:	74 16                	je     8002be <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002a8:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8002ad:	83 ec 08             	sub    $0x8,%esp
  8002b0:	50                   	push   %eax
  8002b1:	68 58 38 80 00       	push   $0x803858
  8002b6:	e8 89 02 00 00       	call   800544 <cprintf>
  8002bb:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002be:	a1 00 40 80 00       	mov    0x804000,%eax
  8002c3:	ff 75 0c             	pushl  0xc(%ebp)
  8002c6:	ff 75 08             	pushl  0x8(%ebp)
  8002c9:	50                   	push   %eax
  8002ca:	68 5d 38 80 00       	push   $0x80385d
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
  8002ee:	68 79 38 80 00       	push   $0x803879
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
  800308:	a1 20 40 80 00       	mov    0x804020,%eax
  80030d:	8b 50 74             	mov    0x74(%eax),%edx
  800310:	8b 45 0c             	mov    0xc(%ebp),%eax
  800313:	39 c2                	cmp    %eax,%edx
  800315:	74 14                	je     80032b <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800317:	83 ec 04             	sub    $0x4,%esp
  80031a:	68 7c 38 80 00       	push   $0x80387c
  80031f:	6a 26                	push   $0x26
  800321:	68 c8 38 80 00       	push   $0x8038c8
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
  80036b:	a1 20 40 80 00       	mov    0x804020,%eax
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
  80038b:	a1 20 40 80 00       	mov    0x804020,%eax
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
  8003d4:	a1 20 40 80 00       	mov    0x804020,%eax
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
  8003ec:	68 d4 38 80 00       	push   $0x8038d4
  8003f1:	6a 3a                	push   $0x3a
  8003f3:	68 c8 38 80 00       	push   $0x8038c8
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
  80041c:	a1 20 40 80 00       	mov    0x804020,%eax
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
  800442:	a1 20 40 80 00       	mov    0x804020,%eax
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
  80045c:	68 28 39 80 00       	push   $0x803928
  800461:	6a 44                	push   $0x44
  800463:	68 c8 38 80 00       	push   $0x8038c8
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
  80049b:	a0 24 40 80 00       	mov    0x804024,%al
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
  8004b6:	e8 d8 11 00 00       	call   801693 <sys_cputs>
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
  800510:	a0 24 40 80 00       	mov    0x804024,%al
  800515:	0f b6 c0             	movzbl %al,%eax
  800518:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80051e:	83 ec 04             	sub    $0x4,%esp
  800521:	50                   	push   %eax
  800522:	52                   	push   %edx
  800523:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800529:	83 c0 08             	add    $0x8,%eax
  80052c:	50                   	push   %eax
  80052d:	e8 61 11 00 00       	call   801693 <sys_cputs>
  800532:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800535:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
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
  80054a:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
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
  800577:	e8 c5 12 00 00       	call   801841 <sys_disable_interrupt>
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
  800597:	e8 bf 12 00 00       	call   80185b <sys_enable_interrupt>
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
  8005e1:	e8 e6 2d 00 00       	call   8033cc <__udivdi3>
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
  800631:	e8 a6 2e 00 00       	call   8034dc <__umoddi3>
  800636:	83 c4 10             	add    $0x10,%esp
  800639:	05 94 3b 80 00       	add    $0x803b94,%eax
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
  80078c:	8b 04 85 b8 3b 80 00 	mov    0x803bb8(,%eax,4),%eax
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
  80086d:	8b 34 9d 00 3a 80 00 	mov    0x803a00(,%ebx,4),%esi
  800874:	85 f6                	test   %esi,%esi
  800876:	75 19                	jne    800891 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800878:	53                   	push   %ebx
  800879:	68 a5 3b 80 00       	push   $0x803ba5
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
  800892:	68 ae 3b 80 00       	push   $0x803bae
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
  8008bf:	be b1 3b 80 00       	mov    $0x803bb1,%esi
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
  8012d4:	a1 04 40 80 00       	mov    0x804004,%eax
  8012d9:	85 c0                	test   %eax,%eax
  8012db:	74 1f                	je     8012fc <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8012dd:	e8 1d 00 00 00       	call   8012ff <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8012e2:	83 ec 0c             	sub    $0xc,%esp
  8012e5:	68 10 3d 80 00       	push   $0x803d10
  8012ea:	e8 55 f2 ff ff       	call   800544 <cprintf>
  8012ef:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8012f2:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
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
  801305:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  80130c:	00 00 00 
  80130f:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801316:	00 00 00 
  801319:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801320:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801323:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  80132a:	00 00 00 
  80132d:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801334:	00 00 00 
  801337:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
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
  80135c:	a3 50 40 80 00       	mov    %eax,0x804050
	MAX_MEM_BLOCK_CNT = (USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE;
  801361:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801368:	00 02 00 
	arr_size =  ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock), PAGE_SIZE);
  80136b:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801372:	a1 20 41 80 00       	mov    0x804120,%eax
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
  8013b5:	e8 1d 04 00 00       	call   8017d7 <sys_allocate_chunk>
  8013ba:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013bd:	a1 20 41 80 00       	mov    0x804120,%eax
  8013c2:	83 ec 0c             	sub    $0xc,%esp
  8013c5:	50                   	push   %eax
  8013c6:	e8 92 0a 00 00       	call   801e5d <initialize_MemBlocksList>
  8013cb:	83 c4 10             	add    $0x10,%esp
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	struct MemBlock * NewBlock = LIST_FIRST(&AvailableMemBlocksList);
  8013ce:	a1 48 41 80 00       	mov    0x804148,%eax
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
  8013f3:	68 35 3d 80 00       	push   $0x803d35
  8013f8:	6a 33                	push   $0x33
  8013fa:	68 53 3d 80 00       	push   $0x803d53
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
  801423:	a3 4c 41 80 00       	mov    %eax,0x80414c
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
  801446:	a3 48 41 80 00       	mov    %eax,0x804148
  80144b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80144e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801454:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801457:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80145e:	a1 54 41 80 00       	mov    0x804154,%eax
  801463:	48                   	dec    %eax
  801464:	a3 54 41 80 00       	mov    %eax,0x804154
	LIST_INSERT_HEAD(&FreeMemBlocksList, NewBlock);
  801469:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80146d:	75 14                	jne    801483 <initialize_dyn_block_system+0x184>
  80146f:	83 ec 04             	sub    $0x4,%esp
  801472:	68 60 3d 80 00       	push   $0x803d60
  801477:	6a 34                	push   $0x34
  801479:	68 53 3d 80 00       	push   $0x803d53
  80147e:	e8 0d ee ff ff       	call   800290 <_panic>
  801483:	8b 15 38 41 80 00    	mov    0x804138,%edx
  801489:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80148c:	89 10                	mov    %edx,(%eax)
  80148e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801491:	8b 00                	mov    (%eax),%eax
  801493:	85 c0                	test   %eax,%eax
  801495:	74 0d                	je     8014a4 <initialize_dyn_block_system+0x1a5>
  801497:	a1 38 41 80 00       	mov    0x804138,%eax
  80149c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80149f:	89 50 04             	mov    %edx,0x4(%eax)
  8014a2:	eb 08                	jmp    8014ac <initialize_dyn_block_system+0x1ad>
  8014a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014a7:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8014ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014af:	a3 38 41 80 00       	mov    %eax,0x804138
  8014b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014b7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8014be:	a1 44 41 80 00       	mov    0x804144,%eax
  8014c3:	40                   	inc    %eax
  8014c4:	a3 44 41 80 00       	mov    %eax,0x804144
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
  8014e7:	68 84 3d 80 00       	push   $0x803d84
  8014ec:	6a 46                	push   $0x46
  8014ee:	68 53 3d 80 00       	push   $0x803d53
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
  801503:	68 ac 3d 80 00       	push   $0x803dac
  801508:	6a 61                	push   $0x61
  80150a:	68 53 3d 80 00       	push   $0x803d53
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
  801529:	75 07                	jne    801532 <smalloc+0x1e>
  80152b:	b8 00 00 00 00       	mov    $0x0,%eax
  801530:	eb 7c                	jmp    8015ae <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801532:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801539:	8b 55 0c             	mov    0xc(%ebp),%edx
  80153c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80153f:	01 d0                	add    %edx,%eax
  801541:	48                   	dec    %eax
  801542:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801545:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801548:	ba 00 00 00 00       	mov    $0x0,%edx
  80154d:	f7 75 f0             	divl   -0x10(%ebp)
  801550:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801553:	29 d0                	sub    %edx,%eax
  801555:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801558:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  80155f:	e8 41 06 00 00       	call   801ba5 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801564:	85 c0                	test   %eax,%eax
  801566:	74 11                	je     801579 <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  801568:	83 ec 0c             	sub    $0xc,%esp
  80156b:	ff 75 e8             	pushl  -0x18(%ebp)
  80156e:	e8 ac 0c 00 00       	call   80221f <alloc_block_FF>
  801573:	83 c4 10             	add    $0x10,%esp
  801576:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  801579:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80157d:	74 2a                	je     8015a9 <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  80157f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801582:	8b 40 08             	mov    0x8(%eax),%eax
  801585:	89 c2                	mov    %eax,%edx
  801587:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  80158b:	52                   	push   %edx
  80158c:	50                   	push   %eax
  80158d:	ff 75 0c             	pushl  0xc(%ebp)
  801590:	ff 75 08             	pushl  0x8(%ebp)
  801593:	e8 92 03 00 00       	call   80192a <sys_createSharedObject>
  801598:	83 c4 10             	add    $0x10,%esp
  80159b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  80159e:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  8015a2:	74 05                	je     8015a9 <smalloc+0x95>
			return (void*)virtual_address;
  8015a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015a7:	eb 05                	jmp    8015ae <smalloc+0x9a>
	}
	return NULL;
  8015a9:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8015ae:	c9                   	leave  
  8015af:	c3                   	ret    

008015b0 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8015b0:	55                   	push   %ebp
  8015b1:	89 e5                	mov    %esp,%ebp
  8015b3:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015b6:	e8 13 fd ff ff       	call   8012ce <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8015bb:	83 ec 04             	sub    $0x4,%esp
  8015be:	68 d0 3d 80 00       	push   $0x803dd0
  8015c3:	68 a2 00 00 00       	push   $0xa2
  8015c8:	68 53 3d 80 00       	push   $0x803d53
  8015cd:	e8 be ec ff ff       	call   800290 <_panic>

008015d2 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8015d2:	55                   	push   %ebp
  8015d3:	89 e5                	mov    %esp,%ebp
  8015d5:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015d8:	e8 f1 fc ff ff       	call   8012ce <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8015dd:	83 ec 04             	sub    $0x4,%esp
  8015e0:	68 f4 3d 80 00       	push   $0x803df4
  8015e5:	68 e6 00 00 00       	push   $0xe6
  8015ea:	68 53 3d 80 00       	push   $0x803d53
  8015ef:	e8 9c ec ff ff       	call   800290 <_panic>

008015f4 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8015f4:	55                   	push   %ebp
  8015f5:	89 e5                	mov    %esp,%ebp
  8015f7:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8015fa:	83 ec 04             	sub    $0x4,%esp
  8015fd:	68 1c 3e 80 00       	push   $0x803e1c
  801602:	68 fa 00 00 00       	push   $0xfa
  801607:	68 53 3d 80 00       	push   $0x803d53
  80160c:	e8 7f ec ff ff       	call   800290 <_panic>

00801611 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801611:	55                   	push   %ebp
  801612:	89 e5                	mov    %esp,%ebp
  801614:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801617:	83 ec 04             	sub    $0x4,%esp
  80161a:	68 40 3e 80 00       	push   $0x803e40
  80161f:	68 05 01 00 00       	push   $0x105
  801624:	68 53 3d 80 00       	push   $0x803d53
  801629:	e8 62 ec ff ff       	call   800290 <_panic>

0080162e <shrink>:

}
void shrink(uint32 newSize)
{
  80162e:	55                   	push   %ebp
  80162f:	89 e5                	mov    %esp,%ebp
  801631:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801634:	83 ec 04             	sub    $0x4,%esp
  801637:	68 40 3e 80 00       	push   $0x803e40
  80163c:	68 0a 01 00 00       	push   $0x10a
  801641:	68 53 3d 80 00       	push   $0x803d53
  801646:	e8 45 ec ff ff       	call   800290 <_panic>

0080164b <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80164b:	55                   	push   %ebp
  80164c:	89 e5                	mov    %esp,%ebp
  80164e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801651:	83 ec 04             	sub    $0x4,%esp
  801654:	68 40 3e 80 00       	push   $0x803e40
  801659:	68 0f 01 00 00       	push   $0x10f
  80165e:	68 53 3d 80 00       	push   $0x803d53
  801663:	e8 28 ec ff ff       	call   800290 <_panic>

00801668 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801668:	55                   	push   %ebp
  801669:	89 e5                	mov    %esp,%ebp
  80166b:	57                   	push   %edi
  80166c:	56                   	push   %esi
  80166d:	53                   	push   %ebx
  80166e:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801671:	8b 45 08             	mov    0x8(%ebp),%eax
  801674:	8b 55 0c             	mov    0xc(%ebp),%edx
  801677:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80167a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80167d:	8b 7d 18             	mov    0x18(%ebp),%edi
  801680:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801683:	cd 30                	int    $0x30
  801685:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801688:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80168b:	83 c4 10             	add    $0x10,%esp
  80168e:	5b                   	pop    %ebx
  80168f:	5e                   	pop    %esi
  801690:	5f                   	pop    %edi
  801691:	5d                   	pop    %ebp
  801692:	c3                   	ret    

00801693 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801693:	55                   	push   %ebp
  801694:	89 e5                	mov    %esp,%ebp
  801696:	83 ec 04             	sub    $0x4,%esp
  801699:	8b 45 10             	mov    0x10(%ebp),%eax
  80169c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80169f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8016a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a6:	6a 00                	push   $0x0
  8016a8:	6a 00                	push   $0x0
  8016aa:	52                   	push   %edx
  8016ab:	ff 75 0c             	pushl  0xc(%ebp)
  8016ae:	50                   	push   %eax
  8016af:	6a 00                	push   $0x0
  8016b1:	e8 b2 ff ff ff       	call   801668 <syscall>
  8016b6:	83 c4 18             	add    $0x18,%esp
}
  8016b9:	90                   	nop
  8016ba:	c9                   	leave  
  8016bb:	c3                   	ret    

008016bc <sys_cgetc>:

int
sys_cgetc(void)
{
  8016bc:	55                   	push   %ebp
  8016bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8016bf:	6a 00                	push   $0x0
  8016c1:	6a 00                	push   $0x0
  8016c3:	6a 00                	push   $0x0
  8016c5:	6a 00                	push   $0x0
  8016c7:	6a 00                	push   $0x0
  8016c9:	6a 01                	push   $0x1
  8016cb:	e8 98 ff ff ff       	call   801668 <syscall>
  8016d0:	83 c4 18             	add    $0x18,%esp
}
  8016d3:	c9                   	leave  
  8016d4:	c3                   	ret    

008016d5 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8016d5:	55                   	push   %ebp
  8016d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8016d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016db:	8b 45 08             	mov    0x8(%ebp),%eax
  8016de:	6a 00                	push   $0x0
  8016e0:	6a 00                	push   $0x0
  8016e2:	6a 00                	push   $0x0
  8016e4:	52                   	push   %edx
  8016e5:	50                   	push   %eax
  8016e6:	6a 05                	push   $0x5
  8016e8:	e8 7b ff ff ff       	call   801668 <syscall>
  8016ed:	83 c4 18             	add    $0x18,%esp
}
  8016f0:	c9                   	leave  
  8016f1:	c3                   	ret    

008016f2 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8016f2:	55                   	push   %ebp
  8016f3:	89 e5                	mov    %esp,%ebp
  8016f5:	56                   	push   %esi
  8016f6:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8016f7:	8b 75 18             	mov    0x18(%ebp),%esi
  8016fa:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016fd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801700:	8b 55 0c             	mov    0xc(%ebp),%edx
  801703:	8b 45 08             	mov    0x8(%ebp),%eax
  801706:	56                   	push   %esi
  801707:	53                   	push   %ebx
  801708:	51                   	push   %ecx
  801709:	52                   	push   %edx
  80170a:	50                   	push   %eax
  80170b:	6a 06                	push   $0x6
  80170d:	e8 56 ff ff ff       	call   801668 <syscall>
  801712:	83 c4 18             	add    $0x18,%esp
}
  801715:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801718:	5b                   	pop    %ebx
  801719:	5e                   	pop    %esi
  80171a:	5d                   	pop    %ebp
  80171b:	c3                   	ret    

0080171c <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80171c:	55                   	push   %ebp
  80171d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80171f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801722:	8b 45 08             	mov    0x8(%ebp),%eax
  801725:	6a 00                	push   $0x0
  801727:	6a 00                	push   $0x0
  801729:	6a 00                	push   $0x0
  80172b:	52                   	push   %edx
  80172c:	50                   	push   %eax
  80172d:	6a 07                	push   $0x7
  80172f:	e8 34 ff ff ff       	call   801668 <syscall>
  801734:	83 c4 18             	add    $0x18,%esp
}
  801737:	c9                   	leave  
  801738:	c3                   	ret    

00801739 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801739:	55                   	push   %ebp
  80173a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80173c:	6a 00                	push   $0x0
  80173e:	6a 00                	push   $0x0
  801740:	6a 00                	push   $0x0
  801742:	ff 75 0c             	pushl  0xc(%ebp)
  801745:	ff 75 08             	pushl  0x8(%ebp)
  801748:	6a 08                	push   $0x8
  80174a:	e8 19 ff ff ff       	call   801668 <syscall>
  80174f:	83 c4 18             	add    $0x18,%esp
}
  801752:	c9                   	leave  
  801753:	c3                   	ret    

00801754 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801754:	55                   	push   %ebp
  801755:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801757:	6a 00                	push   $0x0
  801759:	6a 00                	push   $0x0
  80175b:	6a 00                	push   $0x0
  80175d:	6a 00                	push   $0x0
  80175f:	6a 00                	push   $0x0
  801761:	6a 09                	push   $0x9
  801763:	e8 00 ff ff ff       	call   801668 <syscall>
  801768:	83 c4 18             	add    $0x18,%esp
}
  80176b:	c9                   	leave  
  80176c:	c3                   	ret    

0080176d <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80176d:	55                   	push   %ebp
  80176e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801770:	6a 00                	push   $0x0
  801772:	6a 00                	push   $0x0
  801774:	6a 00                	push   $0x0
  801776:	6a 00                	push   $0x0
  801778:	6a 00                	push   $0x0
  80177a:	6a 0a                	push   $0xa
  80177c:	e8 e7 fe ff ff       	call   801668 <syscall>
  801781:	83 c4 18             	add    $0x18,%esp
}
  801784:	c9                   	leave  
  801785:	c3                   	ret    

00801786 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801786:	55                   	push   %ebp
  801787:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801789:	6a 00                	push   $0x0
  80178b:	6a 00                	push   $0x0
  80178d:	6a 00                	push   $0x0
  80178f:	6a 00                	push   $0x0
  801791:	6a 00                	push   $0x0
  801793:	6a 0b                	push   $0xb
  801795:	e8 ce fe ff ff       	call   801668 <syscall>
  80179a:	83 c4 18             	add    $0x18,%esp
}
  80179d:	c9                   	leave  
  80179e:	c3                   	ret    

0080179f <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80179f:	55                   	push   %ebp
  8017a0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8017a2:	6a 00                	push   $0x0
  8017a4:	6a 00                	push   $0x0
  8017a6:	6a 00                	push   $0x0
  8017a8:	ff 75 0c             	pushl  0xc(%ebp)
  8017ab:	ff 75 08             	pushl  0x8(%ebp)
  8017ae:	6a 0f                	push   $0xf
  8017b0:	e8 b3 fe ff ff       	call   801668 <syscall>
  8017b5:	83 c4 18             	add    $0x18,%esp
	return;
  8017b8:	90                   	nop
}
  8017b9:	c9                   	leave  
  8017ba:	c3                   	ret    

008017bb <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8017bb:	55                   	push   %ebp
  8017bc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8017be:	6a 00                	push   $0x0
  8017c0:	6a 00                	push   $0x0
  8017c2:	6a 00                	push   $0x0
  8017c4:	ff 75 0c             	pushl  0xc(%ebp)
  8017c7:	ff 75 08             	pushl  0x8(%ebp)
  8017ca:	6a 10                	push   $0x10
  8017cc:	e8 97 fe ff ff       	call   801668 <syscall>
  8017d1:	83 c4 18             	add    $0x18,%esp
	return ;
  8017d4:	90                   	nop
}
  8017d5:	c9                   	leave  
  8017d6:	c3                   	ret    

008017d7 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8017d7:	55                   	push   %ebp
  8017d8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8017da:	6a 00                	push   $0x0
  8017dc:	6a 00                	push   $0x0
  8017de:	ff 75 10             	pushl  0x10(%ebp)
  8017e1:	ff 75 0c             	pushl  0xc(%ebp)
  8017e4:	ff 75 08             	pushl  0x8(%ebp)
  8017e7:	6a 11                	push   $0x11
  8017e9:	e8 7a fe ff ff       	call   801668 <syscall>
  8017ee:	83 c4 18             	add    $0x18,%esp
	return ;
  8017f1:	90                   	nop
}
  8017f2:	c9                   	leave  
  8017f3:	c3                   	ret    

008017f4 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8017f4:	55                   	push   %ebp
  8017f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8017f7:	6a 00                	push   $0x0
  8017f9:	6a 00                	push   $0x0
  8017fb:	6a 00                	push   $0x0
  8017fd:	6a 00                	push   $0x0
  8017ff:	6a 00                	push   $0x0
  801801:	6a 0c                	push   $0xc
  801803:	e8 60 fe ff ff       	call   801668 <syscall>
  801808:	83 c4 18             	add    $0x18,%esp
}
  80180b:	c9                   	leave  
  80180c:	c3                   	ret    

0080180d <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80180d:	55                   	push   %ebp
  80180e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801810:	6a 00                	push   $0x0
  801812:	6a 00                	push   $0x0
  801814:	6a 00                	push   $0x0
  801816:	6a 00                	push   $0x0
  801818:	ff 75 08             	pushl  0x8(%ebp)
  80181b:	6a 0d                	push   $0xd
  80181d:	e8 46 fe ff ff       	call   801668 <syscall>
  801822:	83 c4 18             	add    $0x18,%esp
}
  801825:	c9                   	leave  
  801826:	c3                   	ret    

00801827 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801827:	55                   	push   %ebp
  801828:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80182a:	6a 00                	push   $0x0
  80182c:	6a 00                	push   $0x0
  80182e:	6a 00                	push   $0x0
  801830:	6a 00                	push   $0x0
  801832:	6a 00                	push   $0x0
  801834:	6a 0e                	push   $0xe
  801836:	e8 2d fe ff ff       	call   801668 <syscall>
  80183b:	83 c4 18             	add    $0x18,%esp
}
  80183e:	90                   	nop
  80183f:	c9                   	leave  
  801840:	c3                   	ret    

00801841 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801841:	55                   	push   %ebp
  801842:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801844:	6a 00                	push   $0x0
  801846:	6a 00                	push   $0x0
  801848:	6a 00                	push   $0x0
  80184a:	6a 00                	push   $0x0
  80184c:	6a 00                	push   $0x0
  80184e:	6a 13                	push   $0x13
  801850:	e8 13 fe ff ff       	call   801668 <syscall>
  801855:	83 c4 18             	add    $0x18,%esp
}
  801858:	90                   	nop
  801859:	c9                   	leave  
  80185a:	c3                   	ret    

0080185b <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80185b:	55                   	push   %ebp
  80185c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80185e:	6a 00                	push   $0x0
  801860:	6a 00                	push   $0x0
  801862:	6a 00                	push   $0x0
  801864:	6a 00                	push   $0x0
  801866:	6a 00                	push   $0x0
  801868:	6a 14                	push   $0x14
  80186a:	e8 f9 fd ff ff       	call   801668 <syscall>
  80186f:	83 c4 18             	add    $0x18,%esp
}
  801872:	90                   	nop
  801873:	c9                   	leave  
  801874:	c3                   	ret    

00801875 <sys_cputc>:


void
sys_cputc(const char c)
{
  801875:	55                   	push   %ebp
  801876:	89 e5                	mov    %esp,%ebp
  801878:	83 ec 04             	sub    $0x4,%esp
  80187b:	8b 45 08             	mov    0x8(%ebp),%eax
  80187e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801881:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801885:	6a 00                	push   $0x0
  801887:	6a 00                	push   $0x0
  801889:	6a 00                	push   $0x0
  80188b:	6a 00                	push   $0x0
  80188d:	50                   	push   %eax
  80188e:	6a 15                	push   $0x15
  801890:	e8 d3 fd ff ff       	call   801668 <syscall>
  801895:	83 c4 18             	add    $0x18,%esp
}
  801898:	90                   	nop
  801899:	c9                   	leave  
  80189a:	c3                   	ret    

0080189b <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80189b:	55                   	push   %ebp
  80189c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80189e:	6a 00                	push   $0x0
  8018a0:	6a 00                	push   $0x0
  8018a2:	6a 00                	push   $0x0
  8018a4:	6a 00                	push   $0x0
  8018a6:	6a 00                	push   $0x0
  8018a8:	6a 16                	push   $0x16
  8018aa:	e8 b9 fd ff ff       	call   801668 <syscall>
  8018af:	83 c4 18             	add    $0x18,%esp
}
  8018b2:	90                   	nop
  8018b3:	c9                   	leave  
  8018b4:	c3                   	ret    

008018b5 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8018b5:	55                   	push   %ebp
  8018b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8018b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bb:	6a 00                	push   $0x0
  8018bd:	6a 00                	push   $0x0
  8018bf:	6a 00                	push   $0x0
  8018c1:	ff 75 0c             	pushl  0xc(%ebp)
  8018c4:	50                   	push   %eax
  8018c5:	6a 17                	push   $0x17
  8018c7:	e8 9c fd ff ff       	call   801668 <syscall>
  8018cc:	83 c4 18             	add    $0x18,%esp
}
  8018cf:	c9                   	leave  
  8018d0:	c3                   	ret    

008018d1 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8018d1:	55                   	push   %ebp
  8018d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018da:	6a 00                	push   $0x0
  8018dc:	6a 00                	push   $0x0
  8018de:	6a 00                	push   $0x0
  8018e0:	52                   	push   %edx
  8018e1:	50                   	push   %eax
  8018e2:	6a 1a                	push   $0x1a
  8018e4:	e8 7f fd ff ff       	call   801668 <syscall>
  8018e9:	83 c4 18             	add    $0x18,%esp
}
  8018ec:	c9                   	leave  
  8018ed:	c3                   	ret    

008018ee <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8018ee:	55                   	push   %ebp
  8018ef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f7:	6a 00                	push   $0x0
  8018f9:	6a 00                	push   $0x0
  8018fb:	6a 00                	push   $0x0
  8018fd:	52                   	push   %edx
  8018fe:	50                   	push   %eax
  8018ff:	6a 18                	push   $0x18
  801901:	e8 62 fd ff ff       	call   801668 <syscall>
  801906:	83 c4 18             	add    $0x18,%esp
}
  801909:	90                   	nop
  80190a:	c9                   	leave  
  80190b:	c3                   	ret    

0080190c <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80190c:	55                   	push   %ebp
  80190d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80190f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801912:	8b 45 08             	mov    0x8(%ebp),%eax
  801915:	6a 00                	push   $0x0
  801917:	6a 00                	push   $0x0
  801919:	6a 00                	push   $0x0
  80191b:	52                   	push   %edx
  80191c:	50                   	push   %eax
  80191d:	6a 19                	push   $0x19
  80191f:	e8 44 fd ff ff       	call   801668 <syscall>
  801924:	83 c4 18             	add    $0x18,%esp
}
  801927:	90                   	nop
  801928:	c9                   	leave  
  801929:	c3                   	ret    

0080192a <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80192a:	55                   	push   %ebp
  80192b:	89 e5                	mov    %esp,%ebp
  80192d:	83 ec 04             	sub    $0x4,%esp
  801930:	8b 45 10             	mov    0x10(%ebp),%eax
  801933:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801936:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801939:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80193d:	8b 45 08             	mov    0x8(%ebp),%eax
  801940:	6a 00                	push   $0x0
  801942:	51                   	push   %ecx
  801943:	52                   	push   %edx
  801944:	ff 75 0c             	pushl  0xc(%ebp)
  801947:	50                   	push   %eax
  801948:	6a 1b                	push   $0x1b
  80194a:	e8 19 fd ff ff       	call   801668 <syscall>
  80194f:	83 c4 18             	add    $0x18,%esp
}
  801952:	c9                   	leave  
  801953:	c3                   	ret    

00801954 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801954:	55                   	push   %ebp
  801955:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801957:	8b 55 0c             	mov    0xc(%ebp),%edx
  80195a:	8b 45 08             	mov    0x8(%ebp),%eax
  80195d:	6a 00                	push   $0x0
  80195f:	6a 00                	push   $0x0
  801961:	6a 00                	push   $0x0
  801963:	52                   	push   %edx
  801964:	50                   	push   %eax
  801965:	6a 1c                	push   $0x1c
  801967:	e8 fc fc ff ff       	call   801668 <syscall>
  80196c:	83 c4 18             	add    $0x18,%esp
}
  80196f:	c9                   	leave  
  801970:	c3                   	ret    

00801971 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801971:	55                   	push   %ebp
  801972:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801974:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801977:	8b 55 0c             	mov    0xc(%ebp),%edx
  80197a:	8b 45 08             	mov    0x8(%ebp),%eax
  80197d:	6a 00                	push   $0x0
  80197f:	6a 00                	push   $0x0
  801981:	51                   	push   %ecx
  801982:	52                   	push   %edx
  801983:	50                   	push   %eax
  801984:	6a 1d                	push   $0x1d
  801986:	e8 dd fc ff ff       	call   801668 <syscall>
  80198b:	83 c4 18             	add    $0x18,%esp
}
  80198e:	c9                   	leave  
  80198f:	c3                   	ret    

00801990 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801990:	55                   	push   %ebp
  801991:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801993:	8b 55 0c             	mov    0xc(%ebp),%edx
  801996:	8b 45 08             	mov    0x8(%ebp),%eax
  801999:	6a 00                	push   $0x0
  80199b:	6a 00                	push   $0x0
  80199d:	6a 00                	push   $0x0
  80199f:	52                   	push   %edx
  8019a0:	50                   	push   %eax
  8019a1:	6a 1e                	push   $0x1e
  8019a3:	e8 c0 fc ff ff       	call   801668 <syscall>
  8019a8:	83 c4 18             	add    $0x18,%esp
}
  8019ab:	c9                   	leave  
  8019ac:	c3                   	ret    

008019ad <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8019ad:	55                   	push   %ebp
  8019ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8019b0:	6a 00                	push   $0x0
  8019b2:	6a 00                	push   $0x0
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 1f                	push   $0x1f
  8019bc:	e8 a7 fc ff ff       	call   801668 <syscall>
  8019c1:	83 c4 18             	add    $0x18,%esp
}
  8019c4:	c9                   	leave  
  8019c5:	c3                   	ret    

008019c6 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8019c6:	55                   	push   %ebp
  8019c7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8019c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cc:	6a 00                	push   $0x0
  8019ce:	ff 75 14             	pushl  0x14(%ebp)
  8019d1:	ff 75 10             	pushl  0x10(%ebp)
  8019d4:	ff 75 0c             	pushl  0xc(%ebp)
  8019d7:	50                   	push   %eax
  8019d8:	6a 20                	push   $0x20
  8019da:	e8 89 fc ff ff       	call   801668 <syscall>
  8019df:	83 c4 18             	add    $0x18,%esp
}
  8019e2:	c9                   	leave  
  8019e3:	c3                   	ret    

008019e4 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8019e4:	55                   	push   %ebp
  8019e5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8019e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ea:	6a 00                	push   $0x0
  8019ec:	6a 00                	push   $0x0
  8019ee:	6a 00                	push   $0x0
  8019f0:	6a 00                	push   $0x0
  8019f2:	50                   	push   %eax
  8019f3:	6a 21                	push   $0x21
  8019f5:	e8 6e fc ff ff       	call   801668 <syscall>
  8019fa:	83 c4 18             	add    $0x18,%esp
}
  8019fd:	90                   	nop
  8019fe:	c9                   	leave  
  8019ff:	c3                   	ret    

00801a00 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801a00:	55                   	push   %ebp
  801a01:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801a03:	8b 45 08             	mov    0x8(%ebp),%eax
  801a06:	6a 00                	push   $0x0
  801a08:	6a 00                	push   $0x0
  801a0a:	6a 00                	push   $0x0
  801a0c:	6a 00                	push   $0x0
  801a0e:	50                   	push   %eax
  801a0f:	6a 22                	push   $0x22
  801a11:	e8 52 fc ff ff       	call   801668 <syscall>
  801a16:	83 c4 18             	add    $0x18,%esp
}
  801a19:	c9                   	leave  
  801a1a:	c3                   	ret    

00801a1b <sys_getenvid>:

int32 sys_getenvid(void)
{
  801a1b:	55                   	push   %ebp
  801a1c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801a1e:	6a 00                	push   $0x0
  801a20:	6a 00                	push   $0x0
  801a22:	6a 00                	push   $0x0
  801a24:	6a 00                	push   $0x0
  801a26:	6a 00                	push   $0x0
  801a28:	6a 02                	push   $0x2
  801a2a:	e8 39 fc ff ff       	call   801668 <syscall>
  801a2f:	83 c4 18             	add    $0x18,%esp
}
  801a32:	c9                   	leave  
  801a33:	c3                   	ret    

00801a34 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801a34:	55                   	push   %ebp
  801a35:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801a37:	6a 00                	push   $0x0
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 00                	push   $0x0
  801a3f:	6a 00                	push   $0x0
  801a41:	6a 03                	push   $0x3
  801a43:	e8 20 fc ff ff       	call   801668 <syscall>
  801a48:	83 c4 18             	add    $0x18,%esp
}
  801a4b:	c9                   	leave  
  801a4c:	c3                   	ret    

00801a4d <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801a4d:	55                   	push   %ebp
  801a4e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801a50:	6a 00                	push   $0x0
  801a52:	6a 00                	push   $0x0
  801a54:	6a 00                	push   $0x0
  801a56:	6a 00                	push   $0x0
  801a58:	6a 00                	push   $0x0
  801a5a:	6a 04                	push   $0x4
  801a5c:	e8 07 fc ff ff       	call   801668 <syscall>
  801a61:	83 c4 18             	add    $0x18,%esp
}
  801a64:	c9                   	leave  
  801a65:	c3                   	ret    

00801a66 <sys_exit_env>:


void sys_exit_env(void)
{
  801a66:	55                   	push   %ebp
  801a67:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801a69:	6a 00                	push   $0x0
  801a6b:	6a 00                	push   $0x0
  801a6d:	6a 00                	push   $0x0
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 00                	push   $0x0
  801a73:	6a 23                	push   $0x23
  801a75:	e8 ee fb ff ff       	call   801668 <syscall>
  801a7a:	83 c4 18             	add    $0x18,%esp
}
  801a7d:	90                   	nop
  801a7e:	c9                   	leave  
  801a7f:	c3                   	ret    

00801a80 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801a80:	55                   	push   %ebp
  801a81:	89 e5                	mov    %esp,%ebp
  801a83:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801a86:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a89:	8d 50 04             	lea    0x4(%eax),%edx
  801a8c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 00                	push   $0x0
  801a93:	6a 00                	push   $0x0
  801a95:	52                   	push   %edx
  801a96:	50                   	push   %eax
  801a97:	6a 24                	push   $0x24
  801a99:	e8 ca fb ff ff       	call   801668 <syscall>
  801a9e:	83 c4 18             	add    $0x18,%esp
	return result;
  801aa1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801aa4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801aa7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801aaa:	89 01                	mov    %eax,(%ecx)
  801aac:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801aaf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab2:	c9                   	leave  
  801ab3:	c2 04 00             	ret    $0x4

00801ab6 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801ab6:	55                   	push   %ebp
  801ab7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801ab9:	6a 00                	push   $0x0
  801abb:	6a 00                	push   $0x0
  801abd:	ff 75 10             	pushl  0x10(%ebp)
  801ac0:	ff 75 0c             	pushl  0xc(%ebp)
  801ac3:	ff 75 08             	pushl  0x8(%ebp)
  801ac6:	6a 12                	push   $0x12
  801ac8:	e8 9b fb ff ff       	call   801668 <syscall>
  801acd:	83 c4 18             	add    $0x18,%esp
	return ;
  801ad0:	90                   	nop
}
  801ad1:	c9                   	leave  
  801ad2:	c3                   	ret    

00801ad3 <sys_rcr2>:
uint32 sys_rcr2()
{
  801ad3:	55                   	push   %ebp
  801ad4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ad6:	6a 00                	push   $0x0
  801ad8:	6a 00                	push   $0x0
  801ada:	6a 00                	push   $0x0
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 25                	push   $0x25
  801ae2:	e8 81 fb ff ff       	call   801668 <syscall>
  801ae7:	83 c4 18             	add    $0x18,%esp
}
  801aea:	c9                   	leave  
  801aeb:	c3                   	ret    

00801aec <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801aec:	55                   	push   %ebp
  801aed:	89 e5                	mov    %esp,%ebp
  801aef:	83 ec 04             	sub    $0x4,%esp
  801af2:	8b 45 08             	mov    0x8(%ebp),%eax
  801af5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801af8:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801afc:	6a 00                	push   $0x0
  801afe:	6a 00                	push   $0x0
  801b00:	6a 00                	push   $0x0
  801b02:	6a 00                	push   $0x0
  801b04:	50                   	push   %eax
  801b05:	6a 26                	push   $0x26
  801b07:	e8 5c fb ff ff       	call   801668 <syscall>
  801b0c:	83 c4 18             	add    $0x18,%esp
	return ;
  801b0f:	90                   	nop
}
  801b10:	c9                   	leave  
  801b11:	c3                   	ret    

00801b12 <rsttst>:
void rsttst()
{
  801b12:	55                   	push   %ebp
  801b13:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801b15:	6a 00                	push   $0x0
  801b17:	6a 00                	push   $0x0
  801b19:	6a 00                	push   $0x0
  801b1b:	6a 00                	push   $0x0
  801b1d:	6a 00                	push   $0x0
  801b1f:	6a 28                	push   $0x28
  801b21:	e8 42 fb ff ff       	call   801668 <syscall>
  801b26:	83 c4 18             	add    $0x18,%esp
	return ;
  801b29:	90                   	nop
}
  801b2a:	c9                   	leave  
  801b2b:	c3                   	ret    

00801b2c <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801b2c:	55                   	push   %ebp
  801b2d:	89 e5                	mov    %esp,%ebp
  801b2f:	83 ec 04             	sub    $0x4,%esp
  801b32:	8b 45 14             	mov    0x14(%ebp),%eax
  801b35:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801b38:	8b 55 18             	mov    0x18(%ebp),%edx
  801b3b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b3f:	52                   	push   %edx
  801b40:	50                   	push   %eax
  801b41:	ff 75 10             	pushl  0x10(%ebp)
  801b44:	ff 75 0c             	pushl  0xc(%ebp)
  801b47:	ff 75 08             	pushl  0x8(%ebp)
  801b4a:	6a 27                	push   $0x27
  801b4c:	e8 17 fb ff ff       	call   801668 <syscall>
  801b51:	83 c4 18             	add    $0x18,%esp
	return ;
  801b54:	90                   	nop
}
  801b55:	c9                   	leave  
  801b56:	c3                   	ret    

00801b57 <chktst>:
void chktst(uint32 n)
{
  801b57:	55                   	push   %ebp
  801b58:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801b5a:	6a 00                	push   $0x0
  801b5c:	6a 00                	push   $0x0
  801b5e:	6a 00                	push   $0x0
  801b60:	6a 00                	push   $0x0
  801b62:	ff 75 08             	pushl  0x8(%ebp)
  801b65:	6a 29                	push   $0x29
  801b67:	e8 fc fa ff ff       	call   801668 <syscall>
  801b6c:	83 c4 18             	add    $0x18,%esp
	return ;
  801b6f:	90                   	nop
}
  801b70:	c9                   	leave  
  801b71:	c3                   	ret    

00801b72 <inctst>:

void inctst()
{
  801b72:	55                   	push   %ebp
  801b73:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801b75:	6a 00                	push   $0x0
  801b77:	6a 00                	push   $0x0
  801b79:	6a 00                	push   $0x0
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 2a                	push   $0x2a
  801b81:	e8 e2 fa ff ff       	call   801668 <syscall>
  801b86:	83 c4 18             	add    $0x18,%esp
	return ;
  801b89:	90                   	nop
}
  801b8a:	c9                   	leave  
  801b8b:	c3                   	ret    

00801b8c <gettst>:
uint32 gettst()
{
  801b8c:	55                   	push   %ebp
  801b8d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 00                	push   $0x0
  801b93:	6a 00                	push   $0x0
  801b95:	6a 00                	push   $0x0
  801b97:	6a 00                	push   $0x0
  801b99:	6a 2b                	push   $0x2b
  801b9b:	e8 c8 fa ff ff       	call   801668 <syscall>
  801ba0:	83 c4 18             	add    $0x18,%esp
}
  801ba3:	c9                   	leave  
  801ba4:	c3                   	ret    

00801ba5 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801ba5:	55                   	push   %ebp
  801ba6:	89 e5                	mov    %esp,%ebp
  801ba8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bab:	6a 00                	push   $0x0
  801bad:	6a 00                	push   $0x0
  801baf:	6a 00                	push   $0x0
  801bb1:	6a 00                	push   $0x0
  801bb3:	6a 00                	push   $0x0
  801bb5:	6a 2c                	push   $0x2c
  801bb7:	e8 ac fa ff ff       	call   801668 <syscall>
  801bbc:	83 c4 18             	add    $0x18,%esp
  801bbf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801bc2:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801bc6:	75 07                	jne    801bcf <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801bc8:	b8 01 00 00 00       	mov    $0x1,%eax
  801bcd:	eb 05                	jmp    801bd4 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801bcf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bd4:	c9                   	leave  
  801bd5:	c3                   	ret    

00801bd6 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801bd6:	55                   	push   %ebp
  801bd7:	89 e5                	mov    %esp,%ebp
  801bd9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 00                	push   $0x0
  801be0:	6a 00                	push   $0x0
  801be2:	6a 00                	push   $0x0
  801be4:	6a 00                	push   $0x0
  801be6:	6a 2c                	push   $0x2c
  801be8:	e8 7b fa ff ff       	call   801668 <syscall>
  801bed:	83 c4 18             	add    $0x18,%esp
  801bf0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801bf3:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801bf7:	75 07                	jne    801c00 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801bf9:	b8 01 00 00 00       	mov    $0x1,%eax
  801bfe:	eb 05                	jmp    801c05 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801c00:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c05:	c9                   	leave  
  801c06:	c3                   	ret    

00801c07 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801c07:	55                   	push   %ebp
  801c08:	89 e5                	mov    %esp,%ebp
  801c0a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 00                	push   $0x0
  801c11:	6a 00                	push   $0x0
  801c13:	6a 00                	push   $0x0
  801c15:	6a 00                	push   $0x0
  801c17:	6a 2c                	push   $0x2c
  801c19:	e8 4a fa ff ff       	call   801668 <syscall>
  801c1e:	83 c4 18             	add    $0x18,%esp
  801c21:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801c24:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801c28:	75 07                	jne    801c31 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801c2a:	b8 01 00 00 00       	mov    $0x1,%eax
  801c2f:	eb 05                	jmp    801c36 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801c31:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c36:	c9                   	leave  
  801c37:	c3                   	ret    

00801c38 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801c38:	55                   	push   %ebp
  801c39:	89 e5                	mov    %esp,%ebp
  801c3b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 00                	push   $0x0
  801c42:	6a 00                	push   $0x0
  801c44:	6a 00                	push   $0x0
  801c46:	6a 00                	push   $0x0
  801c48:	6a 2c                	push   $0x2c
  801c4a:	e8 19 fa ff ff       	call   801668 <syscall>
  801c4f:	83 c4 18             	add    $0x18,%esp
  801c52:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801c55:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801c59:	75 07                	jne    801c62 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801c5b:	b8 01 00 00 00       	mov    $0x1,%eax
  801c60:	eb 05                	jmp    801c67 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801c62:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c67:	c9                   	leave  
  801c68:	c3                   	ret    

00801c69 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c69:	55                   	push   %ebp
  801c6a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 00                	push   $0x0
  801c70:	6a 00                	push   $0x0
  801c72:	6a 00                	push   $0x0
  801c74:	ff 75 08             	pushl  0x8(%ebp)
  801c77:	6a 2d                	push   $0x2d
  801c79:	e8 ea f9 ff ff       	call   801668 <syscall>
  801c7e:	83 c4 18             	add    $0x18,%esp
	return ;
  801c81:	90                   	nop
}
  801c82:	c9                   	leave  
  801c83:	c3                   	ret    

00801c84 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801c84:	55                   	push   %ebp
  801c85:	89 e5                	mov    %esp,%ebp
  801c87:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801c88:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c8b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c8e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c91:	8b 45 08             	mov    0x8(%ebp),%eax
  801c94:	6a 00                	push   $0x0
  801c96:	53                   	push   %ebx
  801c97:	51                   	push   %ecx
  801c98:	52                   	push   %edx
  801c99:	50                   	push   %eax
  801c9a:	6a 2e                	push   $0x2e
  801c9c:	e8 c7 f9 ff ff       	call   801668 <syscall>
  801ca1:	83 c4 18             	add    $0x18,%esp
}
  801ca4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ca7:	c9                   	leave  
  801ca8:	c3                   	ret    

00801ca9 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ca9:	55                   	push   %ebp
  801caa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801cac:	8b 55 0c             	mov    0xc(%ebp),%edx
  801caf:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 00                	push   $0x0
  801cb6:	6a 00                	push   $0x0
  801cb8:	52                   	push   %edx
  801cb9:	50                   	push   %eax
  801cba:	6a 2f                	push   $0x2f
  801cbc:	e8 a7 f9 ff ff       	call   801668 <syscall>
  801cc1:	83 c4 18             	add    $0x18,%esp
}
  801cc4:	c9                   	leave  
  801cc5:	c3                   	ret    

00801cc6 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801cc6:	55                   	push   %ebp
  801cc7:	89 e5                	mov    %esp,%ebp
  801cc9:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801ccc:	83 ec 0c             	sub    $0xc,%esp
  801ccf:	68 50 3e 80 00       	push   $0x803e50
  801cd4:	e8 6b e8 ff ff       	call   800544 <cprintf>
  801cd9:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801cdc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801ce3:	83 ec 0c             	sub    $0xc,%esp
  801ce6:	68 7c 3e 80 00       	push   $0x803e7c
  801ceb:	e8 54 e8 ff ff       	call   800544 <cprintf>
  801cf0:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801cf3:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801cf7:	a1 38 41 80 00       	mov    0x804138,%eax
  801cfc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801cff:	eb 56                	jmp    801d57 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801d01:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d05:	74 1c                	je     801d23 <print_mem_block_lists+0x5d>
  801d07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d0a:	8b 50 08             	mov    0x8(%eax),%edx
  801d0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d10:	8b 48 08             	mov    0x8(%eax),%ecx
  801d13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d16:	8b 40 0c             	mov    0xc(%eax),%eax
  801d19:	01 c8                	add    %ecx,%eax
  801d1b:	39 c2                	cmp    %eax,%edx
  801d1d:	73 04                	jae    801d23 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801d1f:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801d23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d26:	8b 50 08             	mov    0x8(%eax),%edx
  801d29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d2c:	8b 40 0c             	mov    0xc(%eax),%eax
  801d2f:	01 c2                	add    %eax,%edx
  801d31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d34:	8b 40 08             	mov    0x8(%eax),%eax
  801d37:	83 ec 04             	sub    $0x4,%esp
  801d3a:	52                   	push   %edx
  801d3b:	50                   	push   %eax
  801d3c:	68 91 3e 80 00       	push   $0x803e91
  801d41:	e8 fe e7 ff ff       	call   800544 <cprintf>
  801d46:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801d49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d4f:	a1 40 41 80 00       	mov    0x804140,%eax
  801d54:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d57:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d5b:	74 07                	je     801d64 <print_mem_block_lists+0x9e>
  801d5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d60:	8b 00                	mov    (%eax),%eax
  801d62:	eb 05                	jmp    801d69 <print_mem_block_lists+0xa3>
  801d64:	b8 00 00 00 00       	mov    $0x0,%eax
  801d69:	a3 40 41 80 00       	mov    %eax,0x804140
  801d6e:	a1 40 41 80 00       	mov    0x804140,%eax
  801d73:	85 c0                	test   %eax,%eax
  801d75:	75 8a                	jne    801d01 <print_mem_block_lists+0x3b>
  801d77:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d7b:	75 84                	jne    801d01 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801d7d:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801d81:	75 10                	jne    801d93 <print_mem_block_lists+0xcd>
  801d83:	83 ec 0c             	sub    $0xc,%esp
  801d86:	68 a0 3e 80 00       	push   $0x803ea0
  801d8b:	e8 b4 e7 ff ff       	call   800544 <cprintf>
  801d90:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801d93:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801d9a:	83 ec 0c             	sub    $0xc,%esp
  801d9d:	68 c4 3e 80 00       	push   $0x803ec4
  801da2:	e8 9d e7 ff ff       	call   800544 <cprintf>
  801da7:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801daa:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801dae:	a1 40 40 80 00       	mov    0x804040,%eax
  801db3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801db6:	eb 56                	jmp    801e0e <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801db8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801dbc:	74 1c                	je     801dda <print_mem_block_lists+0x114>
  801dbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc1:	8b 50 08             	mov    0x8(%eax),%edx
  801dc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dc7:	8b 48 08             	mov    0x8(%eax),%ecx
  801dca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dcd:	8b 40 0c             	mov    0xc(%eax),%eax
  801dd0:	01 c8                	add    %ecx,%eax
  801dd2:	39 c2                	cmp    %eax,%edx
  801dd4:	73 04                	jae    801dda <print_mem_block_lists+0x114>
			sorted = 0 ;
  801dd6:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801dda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ddd:	8b 50 08             	mov    0x8(%eax),%edx
  801de0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801de3:	8b 40 0c             	mov    0xc(%eax),%eax
  801de6:	01 c2                	add    %eax,%edx
  801de8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801deb:	8b 40 08             	mov    0x8(%eax),%eax
  801dee:	83 ec 04             	sub    $0x4,%esp
  801df1:	52                   	push   %edx
  801df2:	50                   	push   %eax
  801df3:	68 91 3e 80 00       	push   $0x803e91
  801df8:	e8 47 e7 ff ff       	call   800544 <cprintf>
  801dfd:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e03:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801e06:	a1 48 40 80 00       	mov    0x804048,%eax
  801e0b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e0e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e12:	74 07                	je     801e1b <print_mem_block_lists+0x155>
  801e14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e17:	8b 00                	mov    (%eax),%eax
  801e19:	eb 05                	jmp    801e20 <print_mem_block_lists+0x15a>
  801e1b:	b8 00 00 00 00       	mov    $0x0,%eax
  801e20:	a3 48 40 80 00       	mov    %eax,0x804048
  801e25:	a1 48 40 80 00       	mov    0x804048,%eax
  801e2a:	85 c0                	test   %eax,%eax
  801e2c:	75 8a                	jne    801db8 <print_mem_block_lists+0xf2>
  801e2e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e32:	75 84                	jne    801db8 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801e34:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e38:	75 10                	jne    801e4a <print_mem_block_lists+0x184>
  801e3a:	83 ec 0c             	sub    $0xc,%esp
  801e3d:	68 dc 3e 80 00       	push   $0x803edc
  801e42:	e8 fd e6 ff ff       	call   800544 <cprintf>
  801e47:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801e4a:	83 ec 0c             	sub    $0xc,%esp
  801e4d:	68 50 3e 80 00       	push   $0x803e50
  801e52:	e8 ed e6 ff ff       	call   800544 <cprintf>
  801e57:	83 c4 10             	add    $0x10,%esp

}
  801e5a:	90                   	nop
  801e5b:	c9                   	leave  
  801e5c:	c3                   	ret    

00801e5d <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801e5d:	55                   	push   %ebp
  801e5e:	89 e5                	mov    %esp,%ebp
  801e60:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801e63:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801e6a:	00 00 00 
  801e6d:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801e74:	00 00 00 
  801e77:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801e7e:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801e81:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801e88:	e9 9e 00 00 00       	jmp    801f2b <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801e8d:	a1 50 40 80 00       	mov    0x804050,%eax
  801e92:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e95:	c1 e2 04             	shl    $0x4,%edx
  801e98:	01 d0                	add    %edx,%eax
  801e9a:	85 c0                	test   %eax,%eax
  801e9c:	75 14                	jne    801eb2 <initialize_MemBlocksList+0x55>
  801e9e:	83 ec 04             	sub    $0x4,%esp
  801ea1:	68 04 3f 80 00       	push   $0x803f04
  801ea6:	6a 46                	push   $0x46
  801ea8:	68 27 3f 80 00       	push   $0x803f27
  801ead:	e8 de e3 ff ff       	call   800290 <_panic>
  801eb2:	a1 50 40 80 00       	mov    0x804050,%eax
  801eb7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801eba:	c1 e2 04             	shl    $0x4,%edx
  801ebd:	01 d0                	add    %edx,%eax
  801ebf:	8b 15 48 41 80 00    	mov    0x804148,%edx
  801ec5:	89 10                	mov    %edx,(%eax)
  801ec7:	8b 00                	mov    (%eax),%eax
  801ec9:	85 c0                	test   %eax,%eax
  801ecb:	74 18                	je     801ee5 <initialize_MemBlocksList+0x88>
  801ecd:	a1 48 41 80 00       	mov    0x804148,%eax
  801ed2:	8b 15 50 40 80 00    	mov    0x804050,%edx
  801ed8:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801edb:	c1 e1 04             	shl    $0x4,%ecx
  801ede:	01 ca                	add    %ecx,%edx
  801ee0:	89 50 04             	mov    %edx,0x4(%eax)
  801ee3:	eb 12                	jmp    801ef7 <initialize_MemBlocksList+0x9a>
  801ee5:	a1 50 40 80 00       	mov    0x804050,%eax
  801eea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801eed:	c1 e2 04             	shl    $0x4,%edx
  801ef0:	01 d0                	add    %edx,%eax
  801ef2:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801ef7:	a1 50 40 80 00       	mov    0x804050,%eax
  801efc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801eff:	c1 e2 04             	shl    $0x4,%edx
  801f02:	01 d0                	add    %edx,%eax
  801f04:	a3 48 41 80 00       	mov    %eax,0x804148
  801f09:	a1 50 40 80 00       	mov    0x804050,%eax
  801f0e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f11:	c1 e2 04             	shl    $0x4,%edx
  801f14:	01 d0                	add    %edx,%eax
  801f16:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f1d:	a1 54 41 80 00       	mov    0x804154,%eax
  801f22:	40                   	inc    %eax
  801f23:	a3 54 41 80 00       	mov    %eax,0x804154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801f28:	ff 45 f4             	incl   -0xc(%ebp)
  801f2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f2e:	3b 45 08             	cmp    0x8(%ebp),%eax
  801f31:	0f 82 56 ff ff ff    	jb     801e8d <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801f37:	90                   	nop
  801f38:	c9                   	leave  
  801f39:	c3                   	ret    

00801f3a <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801f3a:	55                   	push   %ebp
  801f3b:	89 e5                	mov    %esp,%ebp
  801f3d:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801f40:	8b 45 08             	mov    0x8(%ebp),%eax
  801f43:	8b 00                	mov    (%eax),%eax
  801f45:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f48:	eb 19                	jmp    801f63 <find_block+0x29>
	{
		if(va==point->sva)
  801f4a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f4d:	8b 40 08             	mov    0x8(%eax),%eax
  801f50:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801f53:	75 05                	jne    801f5a <find_block+0x20>
		   return point;
  801f55:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f58:	eb 36                	jmp    801f90 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801f5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5d:	8b 40 08             	mov    0x8(%eax),%eax
  801f60:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f63:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f67:	74 07                	je     801f70 <find_block+0x36>
  801f69:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f6c:	8b 00                	mov    (%eax),%eax
  801f6e:	eb 05                	jmp    801f75 <find_block+0x3b>
  801f70:	b8 00 00 00 00       	mov    $0x0,%eax
  801f75:	8b 55 08             	mov    0x8(%ebp),%edx
  801f78:	89 42 08             	mov    %eax,0x8(%edx)
  801f7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7e:	8b 40 08             	mov    0x8(%eax),%eax
  801f81:	85 c0                	test   %eax,%eax
  801f83:	75 c5                	jne    801f4a <find_block+0x10>
  801f85:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f89:	75 bf                	jne    801f4a <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  801f8b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f90:	c9                   	leave  
  801f91:	c3                   	ret    

00801f92 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  801f92:	55                   	push   %ebp
  801f93:	89 e5                	mov    %esp,%ebp
  801f95:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  801f98:	a1 40 40 80 00       	mov    0x804040,%eax
  801f9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  801fa0:	a1 44 40 80 00       	mov    0x804044,%eax
  801fa5:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  801fa8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fab:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801fae:	74 24                	je     801fd4 <insert_sorted_allocList+0x42>
  801fb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb3:	8b 50 08             	mov    0x8(%eax),%edx
  801fb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fb9:	8b 40 08             	mov    0x8(%eax),%eax
  801fbc:	39 c2                	cmp    %eax,%edx
  801fbe:	76 14                	jbe    801fd4 <insert_sorted_allocList+0x42>
  801fc0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc3:	8b 50 08             	mov    0x8(%eax),%edx
  801fc6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fc9:	8b 40 08             	mov    0x8(%eax),%eax
  801fcc:	39 c2                	cmp    %eax,%edx
  801fce:	0f 82 60 01 00 00    	jb     802134 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  801fd4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fd8:	75 65                	jne    80203f <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  801fda:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801fde:	75 14                	jne    801ff4 <insert_sorted_allocList+0x62>
  801fe0:	83 ec 04             	sub    $0x4,%esp
  801fe3:	68 04 3f 80 00       	push   $0x803f04
  801fe8:	6a 6b                	push   $0x6b
  801fea:	68 27 3f 80 00       	push   $0x803f27
  801fef:	e8 9c e2 ff ff       	call   800290 <_panic>
  801ff4:	8b 15 40 40 80 00    	mov    0x804040,%edx
  801ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffd:	89 10                	mov    %edx,(%eax)
  801fff:	8b 45 08             	mov    0x8(%ebp),%eax
  802002:	8b 00                	mov    (%eax),%eax
  802004:	85 c0                	test   %eax,%eax
  802006:	74 0d                	je     802015 <insert_sorted_allocList+0x83>
  802008:	a1 40 40 80 00       	mov    0x804040,%eax
  80200d:	8b 55 08             	mov    0x8(%ebp),%edx
  802010:	89 50 04             	mov    %edx,0x4(%eax)
  802013:	eb 08                	jmp    80201d <insert_sorted_allocList+0x8b>
  802015:	8b 45 08             	mov    0x8(%ebp),%eax
  802018:	a3 44 40 80 00       	mov    %eax,0x804044
  80201d:	8b 45 08             	mov    0x8(%ebp),%eax
  802020:	a3 40 40 80 00       	mov    %eax,0x804040
  802025:	8b 45 08             	mov    0x8(%ebp),%eax
  802028:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80202f:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802034:	40                   	inc    %eax
  802035:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80203a:	e9 dc 01 00 00       	jmp    80221b <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  80203f:	8b 45 08             	mov    0x8(%ebp),%eax
  802042:	8b 50 08             	mov    0x8(%eax),%edx
  802045:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802048:	8b 40 08             	mov    0x8(%eax),%eax
  80204b:	39 c2                	cmp    %eax,%edx
  80204d:	77 6c                	ja     8020bb <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  80204f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802053:	74 06                	je     80205b <insert_sorted_allocList+0xc9>
  802055:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802059:	75 14                	jne    80206f <insert_sorted_allocList+0xdd>
  80205b:	83 ec 04             	sub    $0x4,%esp
  80205e:	68 40 3f 80 00       	push   $0x803f40
  802063:	6a 6f                	push   $0x6f
  802065:	68 27 3f 80 00       	push   $0x803f27
  80206a:	e8 21 e2 ff ff       	call   800290 <_panic>
  80206f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802072:	8b 50 04             	mov    0x4(%eax),%edx
  802075:	8b 45 08             	mov    0x8(%ebp),%eax
  802078:	89 50 04             	mov    %edx,0x4(%eax)
  80207b:	8b 45 08             	mov    0x8(%ebp),%eax
  80207e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802081:	89 10                	mov    %edx,(%eax)
  802083:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802086:	8b 40 04             	mov    0x4(%eax),%eax
  802089:	85 c0                	test   %eax,%eax
  80208b:	74 0d                	je     80209a <insert_sorted_allocList+0x108>
  80208d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802090:	8b 40 04             	mov    0x4(%eax),%eax
  802093:	8b 55 08             	mov    0x8(%ebp),%edx
  802096:	89 10                	mov    %edx,(%eax)
  802098:	eb 08                	jmp    8020a2 <insert_sorted_allocList+0x110>
  80209a:	8b 45 08             	mov    0x8(%ebp),%eax
  80209d:	a3 40 40 80 00       	mov    %eax,0x804040
  8020a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8020a8:	89 50 04             	mov    %edx,0x4(%eax)
  8020ab:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8020b0:	40                   	inc    %eax
  8020b1:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8020b6:	e9 60 01 00 00       	jmp    80221b <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8020bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020be:	8b 50 08             	mov    0x8(%eax),%edx
  8020c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020c4:	8b 40 08             	mov    0x8(%eax),%eax
  8020c7:	39 c2                	cmp    %eax,%edx
  8020c9:	0f 82 4c 01 00 00    	jb     80221b <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8020cf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020d3:	75 14                	jne    8020e9 <insert_sorted_allocList+0x157>
  8020d5:	83 ec 04             	sub    $0x4,%esp
  8020d8:	68 78 3f 80 00       	push   $0x803f78
  8020dd:	6a 73                	push   $0x73
  8020df:	68 27 3f 80 00       	push   $0x803f27
  8020e4:	e8 a7 e1 ff ff       	call   800290 <_panic>
  8020e9:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8020ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f2:	89 50 04             	mov    %edx,0x4(%eax)
  8020f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f8:	8b 40 04             	mov    0x4(%eax),%eax
  8020fb:	85 c0                	test   %eax,%eax
  8020fd:	74 0c                	je     80210b <insert_sorted_allocList+0x179>
  8020ff:	a1 44 40 80 00       	mov    0x804044,%eax
  802104:	8b 55 08             	mov    0x8(%ebp),%edx
  802107:	89 10                	mov    %edx,(%eax)
  802109:	eb 08                	jmp    802113 <insert_sorted_allocList+0x181>
  80210b:	8b 45 08             	mov    0x8(%ebp),%eax
  80210e:	a3 40 40 80 00       	mov    %eax,0x804040
  802113:	8b 45 08             	mov    0x8(%ebp),%eax
  802116:	a3 44 40 80 00       	mov    %eax,0x804044
  80211b:	8b 45 08             	mov    0x8(%ebp),%eax
  80211e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802124:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802129:	40                   	inc    %eax
  80212a:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80212f:	e9 e7 00 00 00       	jmp    80221b <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802134:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802137:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  80213a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802141:	a1 40 40 80 00       	mov    0x804040,%eax
  802146:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802149:	e9 9d 00 00 00       	jmp    8021eb <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  80214e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802151:	8b 00                	mov    (%eax),%eax
  802153:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802156:	8b 45 08             	mov    0x8(%ebp),%eax
  802159:	8b 50 08             	mov    0x8(%eax),%edx
  80215c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80215f:	8b 40 08             	mov    0x8(%eax),%eax
  802162:	39 c2                	cmp    %eax,%edx
  802164:	76 7d                	jbe    8021e3 <insert_sorted_allocList+0x251>
  802166:	8b 45 08             	mov    0x8(%ebp),%eax
  802169:	8b 50 08             	mov    0x8(%eax),%edx
  80216c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80216f:	8b 40 08             	mov    0x8(%eax),%eax
  802172:	39 c2                	cmp    %eax,%edx
  802174:	73 6d                	jae    8021e3 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802176:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80217a:	74 06                	je     802182 <insert_sorted_allocList+0x1f0>
  80217c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802180:	75 14                	jne    802196 <insert_sorted_allocList+0x204>
  802182:	83 ec 04             	sub    $0x4,%esp
  802185:	68 9c 3f 80 00       	push   $0x803f9c
  80218a:	6a 7f                	push   $0x7f
  80218c:	68 27 3f 80 00       	push   $0x803f27
  802191:	e8 fa e0 ff ff       	call   800290 <_panic>
  802196:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802199:	8b 10                	mov    (%eax),%edx
  80219b:	8b 45 08             	mov    0x8(%ebp),%eax
  80219e:	89 10                	mov    %edx,(%eax)
  8021a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a3:	8b 00                	mov    (%eax),%eax
  8021a5:	85 c0                	test   %eax,%eax
  8021a7:	74 0b                	je     8021b4 <insert_sorted_allocList+0x222>
  8021a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ac:	8b 00                	mov    (%eax),%eax
  8021ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8021b1:	89 50 04             	mov    %edx,0x4(%eax)
  8021b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8021ba:	89 10                	mov    %edx,(%eax)
  8021bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021c2:	89 50 04             	mov    %edx,0x4(%eax)
  8021c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c8:	8b 00                	mov    (%eax),%eax
  8021ca:	85 c0                	test   %eax,%eax
  8021cc:	75 08                	jne    8021d6 <insert_sorted_allocList+0x244>
  8021ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d1:	a3 44 40 80 00       	mov    %eax,0x804044
  8021d6:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021db:	40                   	inc    %eax
  8021dc:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  8021e1:	eb 39                	jmp    80221c <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8021e3:	a1 48 40 80 00       	mov    0x804048,%eax
  8021e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021ef:	74 07                	je     8021f8 <insert_sorted_allocList+0x266>
  8021f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f4:	8b 00                	mov    (%eax),%eax
  8021f6:	eb 05                	jmp    8021fd <insert_sorted_allocList+0x26b>
  8021f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8021fd:	a3 48 40 80 00       	mov    %eax,0x804048
  802202:	a1 48 40 80 00       	mov    0x804048,%eax
  802207:	85 c0                	test   %eax,%eax
  802209:	0f 85 3f ff ff ff    	jne    80214e <insert_sorted_allocList+0x1bc>
  80220f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802213:	0f 85 35 ff ff ff    	jne    80214e <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802219:	eb 01                	jmp    80221c <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80221b:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80221c:	90                   	nop
  80221d:	c9                   	leave  
  80221e:	c3                   	ret    

0080221f <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80221f:	55                   	push   %ebp
  802220:	89 e5                	mov    %esp,%ebp
  802222:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802225:	a1 38 41 80 00       	mov    0x804138,%eax
  80222a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80222d:	e9 85 01 00 00       	jmp    8023b7 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802232:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802235:	8b 40 0c             	mov    0xc(%eax),%eax
  802238:	3b 45 08             	cmp    0x8(%ebp),%eax
  80223b:	0f 82 6e 01 00 00    	jb     8023af <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802241:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802244:	8b 40 0c             	mov    0xc(%eax),%eax
  802247:	3b 45 08             	cmp    0x8(%ebp),%eax
  80224a:	0f 85 8a 00 00 00    	jne    8022da <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802250:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802254:	75 17                	jne    80226d <alloc_block_FF+0x4e>
  802256:	83 ec 04             	sub    $0x4,%esp
  802259:	68 d0 3f 80 00       	push   $0x803fd0
  80225e:	68 93 00 00 00       	push   $0x93
  802263:	68 27 3f 80 00       	push   $0x803f27
  802268:	e8 23 e0 ff ff       	call   800290 <_panic>
  80226d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802270:	8b 00                	mov    (%eax),%eax
  802272:	85 c0                	test   %eax,%eax
  802274:	74 10                	je     802286 <alloc_block_FF+0x67>
  802276:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802279:	8b 00                	mov    (%eax),%eax
  80227b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80227e:	8b 52 04             	mov    0x4(%edx),%edx
  802281:	89 50 04             	mov    %edx,0x4(%eax)
  802284:	eb 0b                	jmp    802291 <alloc_block_FF+0x72>
  802286:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802289:	8b 40 04             	mov    0x4(%eax),%eax
  80228c:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802291:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802294:	8b 40 04             	mov    0x4(%eax),%eax
  802297:	85 c0                	test   %eax,%eax
  802299:	74 0f                	je     8022aa <alloc_block_FF+0x8b>
  80229b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229e:	8b 40 04             	mov    0x4(%eax),%eax
  8022a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022a4:	8b 12                	mov    (%edx),%edx
  8022a6:	89 10                	mov    %edx,(%eax)
  8022a8:	eb 0a                	jmp    8022b4 <alloc_block_FF+0x95>
  8022aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ad:	8b 00                	mov    (%eax),%eax
  8022af:	a3 38 41 80 00       	mov    %eax,0x804138
  8022b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022c7:	a1 44 41 80 00       	mov    0x804144,%eax
  8022cc:	48                   	dec    %eax
  8022cd:	a3 44 41 80 00       	mov    %eax,0x804144
			   return  point;
  8022d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d5:	e9 10 01 00 00       	jmp    8023ea <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8022da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022dd:	8b 40 0c             	mov    0xc(%eax),%eax
  8022e0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022e3:	0f 86 c6 00 00 00    	jbe    8023af <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8022e9:	a1 48 41 80 00       	mov    0x804148,%eax
  8022ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8022f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f4:	8b 50 08             	mov    0x8(%eax),%edx
  8022f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022fa:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8022fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802300:	8b 55 08             	mov    0x8(%ebp),%edx
  802303:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802306:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80230a:	75 17                	jne    802323 <alloc_block_FF+0x104>
  80230c:	83 ec 04             	sub    $0x4,%esp
  80230f:	68 d0 3f 80 00       	push   $0x803fd0
  802314:	68 9b 00 00 00       	push   $0x9b
  802319:	68 27 3f 80 00       	push   $0x803f27
  80231e:	e8 6d df ff ff       	call   800290 <_panic>
  802323:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802326:	8b 00                	mov    (%eax),%eax
  802328:	85 c0                	test   %eax,%eax
  80232a:	74 10                	je     80233c <alloc_block_FF+0x11d>
  80232c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80232f:	8b 00                	mov    (%eax),%eax
  802331:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802334:	8b 52 04             	mov    0x4(%edx),%edx
  802337:	89 50 04             	mov    %edx,0x4(%eax)
  80233a:	eb 0b                	jmp    802347 <alloc_block_FF+0x128>
  80233c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80233f:	8b 40 04             	mov    0x4(%eax),%eax
  802342:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802347:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80234a:	8b 40 04             	mov    0x4(%eax),%eax
  80234d:	85 c0                	test   %eax,%eax
  80234f:	74 0f                	je     802360 <alloc_block_FF+0x141>
  802351:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802354:	8b 40 04             	mov    0x4(%eax),%eax
  802357:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80235a:	8b 12                	mov    (%edx),%edx
  80235c:	89 10                	mov    %edx,(%eax)
  80235e:	eb 0a                	jmp    80236a <alloc_block_FF+0x14b>
  802360:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802363:	8b 00                	mov    (%eax),%eax
  802365:	a3 48 41 80 00       	mov    %eax,0x804148
  80236a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80236d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802373:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802376:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80237d:	a1 54 41 80 00       	mov    0x804154,%eax
  802382:	48                   	dec    %eax
  802383:	a3 54 41 80 00       	mov    %eax,0x804154
			   point->sva += size;
  802388:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238b:	8b 50 08             	mov    0x8(%eax),%edx
  80238e:	8b 45 08             	mov    0x8(%ebp),%eax
  802391:	01 c2                	add    %eax,%edx
  802393:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802396:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802399:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239c:	8b 40 0c             	mov    0xc(%eax),%eax
  80239f:	2b 45 08             	sub    0x8(%ebp),%eax
  8023a2:	89 c2                	mov    %eax,%edx
  8023a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a7:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8023aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ad:	eb 3b                	jmp    8023ea <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8023af:	a1 40 41 80 00       	mov    0x804140,%eax
  8023b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023bb:	74 07                	je     8023c4 <alloc_block_FF+0x1a5>
  8023bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c0:	8b 00                	mov    (%eax),%eax
  8023c2:	eb 05                	jmp    8023c9 <alloc_block_FF+0x1aa>
  8023c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8023c9:	a3 40 41 80 00       	mov    %eax,0x804140
  8023ce:	a1 40 41 80 00       	mov    0x804140,%eax
  8023d3:	85 c0                	test   %eax,%eax
  8023d5:	0f 85 57 fe ff ff    	jne    802232 <alloc_block_FF+0x13>
  8023db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023df:	0f 85 4d fe ff ff    	jne    802232 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8023e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023ea:	c9                   	leave  
  8023eb:	c3                   	ret    

008023ec <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8023ec:	55                   	push   %ebp
  8023ed:	89 e5                	mov    %esp,%ebp
  8023ef:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8023f2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8023f9:	a1 38 41 80 00       	mov    0x804138,%eax
  8023fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802401:	e9 df 00 00 00       	jmp    8024e5 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802406:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802409:	8b 40 0c             	mov    0xc(%eax),%eax
  80240c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80240f:	0f 82 c8 00 00 00    	jb     8024dd <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802415:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802418:	8b 40 0c             	mov    0xc(%eax),%eax
  80241b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80241e:	0f 85 8a 00 00 00    	jne    8024ae <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802424:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802428:	75 17                	jne    802441 <alloc_block_BF+0x55>
  80242a:	83 ec 04             	sub    $0x4,%esp
  80242d:	68 d0 3f 80 00       	push   $0x803fd0
  802432:	68 b7 00 00 00       	push   $0xb7
  802437:	68 27 3f 80 00       	push   $0x803f27
  80243c:	e8 4f de ff ff       	call   800290 <_panic>
  802441:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802444:	8b 00                	mov    (%eax),%eax
  802446:	85 c0                	test   %eax,%eax
  802448:	74 10                	je     80245a <alloc_block_BF+0x6e>
  80244a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244d:	8b 00                	mov    (%eax),%eax
  80244f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802452:	8b 52 04             	mov    0x4(%edx),%edx
  802455:	89 50 04             	mov    %edx,0x4(%eax)
  802458:	eb 0b                	jmp    802465 <alloc_block_BF+0x79>
  80245a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245d:	8b 40 04             	mov    0x4(%eax),%eax
  802460:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802465:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802468:	8b 40 04             	mov    0x4(%eax),%eax
  80246b:	85 c0                	test   %eax,%eax
  80246d:	74 0f                	je     80247e <alloc_block_BF+0x92>
  80246f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802472:	8b 40 04             	mov    0x4(%eax),%eax
  802475:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802478:	8b 12                	mov    (%edx),%edx
  80247a:	89 10                	mov    %edx,(%eax)
  80247c:	eb 0a                	jmp    802488 <alloc_block_BF+0x9c>
  80247e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802481:	8b 00                	mov    (%eax),%eax
  802483:	a3 38 41 80 00       	mov    %eax,0x804138
  802488:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802491:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802494:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80249b:	a1 44 41 80 00       	mov    0x804144,%eax
  8024a0:	48                   	dec    %eax
  8024a1:	a3 44 41 80 00       	mov    %eax,0x804144
			   return currentMemBlock;
  8024a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a9:	e9 4d 01 00 00       	jmp    8025fb <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8024ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b1:	8b 40 0c             	mov    0xc(%eax),%eax
  8024b4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024b7:	76 24                	jbe    8024dd <alloc_block_BF+0xf1>
  8024b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8024bf:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8024c2:	73 19                	jae    8024dd <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8024c4:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8024cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ce:	8b 40 0c             	mov    0xc(%eax),%eax
  8024d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8024d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d7:	8b 40 08             	mov    0x8(%eax),%eax
  8024da:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8024dd:	a1 40 41 80 00       	mov    0x804140,%eax
  8024e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024e9:	74 07                	je     8024f2 <alloc_block_BF+0x106>
  8024eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ee:	8b 00                	mov    (%eax),%eax
  8024f0:	eb 05                	jmp    8024f7 <alloc_block_BF+0x10b>
  8024f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8024f7:	a3 40 41 80 00       	mov    %eax,0x804140
  8024fc:	a1 40 41 80 00       	mov    0x804140,%eax
  802501:	85 c0                	test   %eax,%eax
  802503:	0f 85 fd fe ff ff    	jne    802406 <alloc_block_BF+0x1a>
  802509:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80250d:	0f 85 f3 fe ff ff    	jne    802406 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802513:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802517:	0f 84 d9 00 00 00    	je     8025f6 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  80251d:	a1 48 41 80 00       	mov    0x804148,%eax
  802522:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802525:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802528:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80252b:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  80252e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802531:	8b 55 08             	mov    0x8(%ebp),%edx
  802534:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802537:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80253b:	75 17                	jne    802554 <alloc_block_BF+0x168>
  80253d:	83 ec 04             	sub    $0x4,%esp
  802540:	68 d0 3f 80 00       	push   $0x803fd0
  802545:	68 c7 00 00 00       	push   $0xc7
  80254a:	68 27 3f 80 00       	push   $0x803f27
  80254f:	e8 3c dd ff ff       	call   800290 <_panic>
  802554:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802557:	8b 00                	mov    (%eax),%eax
  802559:	85 c0                	test   %eax,%eax
  80255b:	74 10                	je     80256d <alloc_block_BF+0x181>
  80255d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802560:	8b 00                	mov    (%eax),%eax
  802562:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802565:	8b 52 04             	mov    0x4(%edx),%edx
  802568:	89 50 04             	mov    %edx,0x4(%eax)
  80256b:	eb 0b                	jmp    802578 <alloc_block_BF+0x18c>
  80256d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802570:	8b 40 04             	mov    0x4(%eax),%eax
  802573:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802578:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80257b:	8b 40 04             	mov    0x4(%eax),%eax
  80257e:	85 c0                	test   %eax,%eax
  802580:	74 0f                	je     802591 <alloc_block_BF+0x1a5>
  802582:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802585:	8b 40 04             	mov    0x4(%eax),%eax
  802588:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80258b:	8b 12                	mov    (%edx),%edx
  80258d:	89 10                	mov    %edx,(%eax)
  80258f:	eb 0a                	jmp    80259b <alloc_block_BF+0x1af>
  802591:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802594:	8b 00                	mov    (%eax),%eax
  802596:	a3 48 41 80 00       	mov    %eax,0x804148
  80259b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80259e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025a7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025ae:	a1 54 41 80 00       	mov    0x804154,%eax
  8025b3:	48                   	dec    %eax
  8025b4:	a3 54 41 80 00       	mov    %eax,0x804154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8025b9:	83 ec 08             	sub    $0x8,%esp
  8025bc:	ff 75 ec             	pushl  -0x14(%ebp)
  8025bf:	68 38 41 80 00       	push   $0x804138
  8025c4:	e8 71 f9 ff ff       	call   801f3a <find_block>
  8025c9:	83 c4 10             	add    $0x10,%esp
  8025cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8025cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025d2:	8b 50 08             	mov    0x8(%eax),%edx
  8025d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d8:	01 c2                	add    %eax,%edx
  8025da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025dd:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8025e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025e3:	8b 40 0c             	mov    0xc(%eax),%eax
  8025e6:	2b 45 08             	sub    0x8(%ebp),%eax
  8025e9:	89 c2                	mov    %eax,%edx
  8025eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025ee:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8025f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025f4:	eb 05                	jmp    8025fb <alloc_block_BF+0x20f>
	}
	return NULL;
  8025f6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025fb:	c9                   	leave  
  8025fc:	c3                   	ret    

008025fd <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8025fd:	55                   	push   %ebp
  8025fe:	89 e5                	mov    %esp,%ebp
  802600:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802603:	a1 28 40 80 00       	mov    0x804028,%eax
  802608:	85 c0                	test   %eax,%eax
  80260a:	0f 85 de 01 00 00    	jne    8027ee <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802610:	a1 38 41 80 00       	mov    0x804138,%eax
  802615:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802618:	e9 9e 01 00 00       	jmp    8027bb <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  80261d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802620:	8b 40 0c             	mov    0xc(%eax),%eax
  802623:	3b 45 08             	cmp    0x8(%ebp),%eax
  802626:	0f 82 87 01 00 00    	jb     8027b3 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  80262c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262f:	8b 40 0c             	mov    0xc(%eax),%eax
  802632:	3b 45 08             	cmp    0x8(%ebp),%eax
  802635:	0f 85 95 00 00 00    	jne    8026d0 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  80263b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80263f:	75 17                	jne    802658 <alloc_block_NF+0x5b>
  802641:	83 ec 04             	sub    $0x4,%esp
  802644:	68 d0 3f 80 00       	push   $0x803fd0
  802649:	68 e0 00 00 00       	push   $0xe0
  80264e:	68 27 3f 80 00       	push   $0x803f27
  802653:	e8 38 dc ff ff       	call   800290 <_panic>
  802658:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265b:	8b 00                	mov    (%eax),%eax
  80265d:	85 c0                	test   %eax,%eax
  80265f:	74 10                	je     802671 <alloc_block_NF+0x74>
  802661:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802664:	8b 00                	mov    (%eax),%eax
  802666:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802669:	8b 52 04             	mov    0x4(%edx),%edx
  80266c:	89 50 04             	mov    %edx,0x4(%eax)
  80266f:	eb 0b                	jmp    80267c <alloc_block_NF+0x7f>
  802671:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802674:	8b 40 04             	mov    0x4(%eax),%eax
  802677:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80267c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267f:	8b 40 04             	mov    0x4(%eax),%eax
  802682:	85 c0                	test   %eax,%eax
  802684:	74 0f                	je     802695 <alloc_block_NF+0x98>
  802686:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802689:	8b 40 04             	mov    0x4(%eax),%eax
  80268c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80268f:	8b 12                	mov    (%edx),%edx
  802691:	89 10                	mov    %edx,(%eax)
  802693:	eb 0a                	jmp    80269f <alloc_block_NF+0xa2>
  802695:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802698:	8b 00                	mov    (%eax),%eax
  80269a:	a3 38 41 80 00       	mov    %eax,0x804138
  80269f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026b2:	a1 44 41 80 00       	mov    0x804144,%eax
  8026b7:	48                   	dec    %eax
  8026b8:	a3 44 41 80 00       	mov    %eax,0x804144
				   svaOfNF = point->sva;
  8026bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c0:	8b 40 08             	mov    0x8(%eax),%eax
  8026c3:	a3 28 40 80 00       	mov    %eax,0x804028
				   return  point;
  8026c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cb:	e9 f8 04 00 00       	jmp    802bc8 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8026d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d3:	8b 40 0c             	mov    0xc(%eax),%eax
  8026d6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026d9:	0f 86 d4 00 00 00    	jbe    8027b3 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8026df:	a1 48 41 80 00       	mov    0x804148,%eax
  8026e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8026e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ea:	8b 50 08             	mov    0x8(%eax),%edx
  8026ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026f0:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8026f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8026f9:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8026fc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802700:	75 17                	jne    802719 <alloc_block_NF+0x11c>
  802702:	83 ec 04             	sub    $0x4,%esp
  802705:	68 d0 3f 80 00       	push   $0x803fd0
  80270a:	68 e9 00 00 00       	push   $0xe9
  80270f:	68 27 3f 80 00       	push   $0x803f27
  802714:	e8 77 db ff ff       	call   800290 <_panic>
  802719:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80271c:	8b 00                	mov    (%eax),%eax
  80271e:	85 c0                	test   %eax,%eax
  802720:	74 10                	je     802732 <alloc_block_NF+0x135>
  802722:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802725:	8b 00                	mov    (%eax),%eax
  802727:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80272a:	8b 52 04             	mov    0x4(%edx),%edx
  80272d:	89 50 04             	mov    %edx,0x4(%eax)
  802730:	eb 0b                	jmp    80273d <alloc_block_NF+0x140>
  802732:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802735:	8b 40 04             	mov    0x4(%eax),%eax
  802738:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80273d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802740:	8b 40 04             	mov    0x4(%eax),%eax
  802743:	85 c0                	test   %eax,%eax
  802745:	74 0f                	je     802756 <alloc_block_NF+0x159>
  802747:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80274a:	8b 40 04             	mov    0x4(%eax),%eax
  80274d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802750:	8b 12                	mov    (%edx),%edx
  802752:	89 10                	mov    %edx,(%eax)
  802754:	eb 0a                	jmp    802760 <alloc_block_NF+0x163>
  802756:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802759:	8b 00                	mov    (%eax),%eax
  80275b:	a3 48 41 80 00       	mov    %eax,0x804148
  802760:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802763:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802769:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80276c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802773:	a1 54 41 80 00       	mov    0x804154,%eax
  802778:	48                   	dec    %eax
  802779:	a3 54 41 80 00       	mov    %eax,0x804154
				   svaOfNF = ReturnedBlock->sva;
  80277e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802781:	8b 40 08             	mov    0x8(%eax),%eax
  802784:	a3 28 40 80 00       	mov    %eax,0x804028
				   point->sva += size;
  802789:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278c:	8b 50 08             	mov    0x8(%eax),%edx
  80278f:	8b 45 08             	mov    0x8(%ebp),%eax
  802792:	01 c2                	add    %eax,%edx
  802794:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802797:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  80279a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279d:	8b 40 0c             	mov    0xc(%eax),%eax
  8027a0:	2b 45 08             	sub    0x8(%ebp),%eax
  8027a3:	89 c2                	mov    %eax,%edx
  8027a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a8:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8027ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ae:	e9 15 04 00 00       	jmp    802bc8 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8027b3:	a1 40 41 80 00       	mov    0x804140,%eax
  8027b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027bf:	74 07                	je     8027c8 <alloc_block_NF+0x1cb>
  8027c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c4:	8b 00                	mov    (%eax),%eax
  8027c6:	eb 05                	jmp    8027cd <alloc_block_NF+0x1d0>
  8027c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8027cd:	a3 40 41 80 00       	mov    %eax,0x804140
  8027d2:	a1 40 41 80 00       	mov    0x804140,%eax
  8027d7:	85 c0                	test   %eax,%eax
  8027d9:	0f 85 3e fe ff ff    	jne    80261d <alloc_block_NF+0x20>
  8027df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027e3:	0f 85 34 fe ff ff    	jne    80261d <alloc_block_NF+0x20>
  8027e9:	e9 d5 03 00 00       	jmp    802bc3 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8027ee:	a1 38 41 80 00       	mov    0x804138,%eax
  8027f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027f6:	e9 b1 01 00 00       	jmp    8029ac <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8027fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fe:	8b 50 08             	mov    0x8(%eax),%edx
  802801:	a1 28 40 80 00       	mov    0x804028,%eax
  802806:	39 c2                	cmp    %eax,%edx
  802808:	0f 82 96 01 00 00    	jb     8029a4 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  80280e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802811:	8b 40 0c             	mov    0xc(%eax),%eax
  802814:	3b 45 08             	cmp    0x8(%ebp),%eax
  802817:	0f 82 87 01 00 00    	jb     8029a4 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  80281d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802820:	8b 40 0c             	mov    0xc(%eax),%eax
  802823:	3b 45 08             	cmp    0x8(%ebp),%eax
  802826:	0f 85 95 00 00 00    	jne    8028c1 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80282c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802830:	75 17                	jne    802849 <alloc_block_NF+0x24c>
  802832:	83 ec 04             	sub    $0x4,%esp
  802835:	68 d0 3f 80 00       	push   $0x803fd0
  80283a:	68 fc 00 00 00       	push   $0xfc
  80283f:	68 27 3f 80 00       	push   $0x803f27
  802844:	e8 47 da ff ff       	call   800290 <_panic>
  802849:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284c:	8b 00                	mov    (%eax),%eax
  80284e:	85 c0                	test   %eax,%eax
  802850:	74 10                	je     802862 <alloc_block_NF+0x265>
  802852:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802855:	8b 00                	mov    (%eax),%eax
  802857:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80285a:	8b 52 04             	mov    0x4(%edx),%edx
  80285d:	89 50 04             	mov    %edx,0x4(%eax)
  802860:	eb 0b                	jmp    80286d <alloc_block_NF+0x270>
  802862:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802865:	8b 40 04             	mov    0x4(%eax),%eax
  802868:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80286d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802870:	8b 40 04             	mov    0x4(%eax),%eax
  802873:	85 c0                	test   %eax,%eax
  802875:	74 0f                	je     802886 <alloc_block_NF+0x289>
  802877:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287a:	8b 40 04             	mov    0x4(%eax),%eax
  80287d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802880:	8b 12                	mov    (%edx),%edx
  802882:	89 10                	mov    %edx,(%eax)
  802884:	eb 0a                	jmp    802890 <alloc_block_NF+0x293>
  802886:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802889:	8b 00                	mov    (%eax),%eax
  80288b:	a3 38 41 80 00       	mov    %eax,0x804138
  802890:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802893:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802899:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028a3:	a1 44 41 80 00       	mov    0x804144,%eax
  8028a8:	48                   	dec    %eax
  8028a9:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  8028ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b1:	8b 40 08             	mov    0x8(%eax),%eax
  8028b4:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  8028b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bc:	e9 07 03 00 00       	jmp    802bc8 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8028c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c4:	8b 40 0c             	mov    0xc(%eax),%eax
  8028c7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028ca:	0f 86 d4 00 00 00    	jbe    8029a4 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8028d0:	a1 48 41 80 00       	mov    0x804148,%eax
  8028d5:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  8028d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028db:	8b 50 08             	mov    0x8(%eax),%edx
  8028de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028e1:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8028e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8028ea:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8028ed:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8028f1:	75 17                	jne    80290a <alloc_block_NF+0x30d>
  8028f3:	83 ec 04             	sub    $0x4,%esp
  8028f6:	68 d0 3f 80 00       	push   $0x803fd0
  8028fb:	68 04 01 00 00       	push   $0x104
  802900:	68 27 3f 80 00       	push   $0x803f27
  802905:	e8 86 d9 ff ff       	call   800290 <_panic>
  80290a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80290d:	8b 00                	mov    (%eax),%eax
  80290f:	85 c0                	test   %eax,%eax
  802911:	74 10                	je     802923 <alloc_block_NF+0x326>
  802913:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802916:	8b 00                	mov    (%eax),%eax
  802918:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80291b:	8b 52 04             	mov    0x4(%edx),%edx
  80291e:	89 50 04             	mov    %edx,0x4(%eax)
  802921:	eb 0b                	jmp    80292e <alloc_block_NF+0x331>
  802923:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802926:	8b 40 04             	mov    0x4(%eax),%eax
  802929:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80292e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802931:	8b 40 04             	mov    0x4(%eax),%eax
  802934:	85 c0                	test   %eax,%eax
  802936:	74 0f                	je     802947 <alloc_block_NF+0x34a>
  802938:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80293b:	8b 40 04             	mov    0x4(%eax),%eax
  80293e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802941:	8b 12                	mov    (%edx),%edx
  802943:	89 10                	mov    %edx,(%eax)
  802945:	eb 0a                	jmp    802951 <alloc_block_NF+0x354>
  802947:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80294a:	8b 00                	mov    (%eax),%eax
  80294c:	a3 48 41 80 00       	mov    %eax,0x804148
  802951:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802954:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80295a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80295d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802964:	a1 54 41 80 00       	mov    0x804154,%eax
  802969:	48                   	dec    %eax
  80296a:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  80296f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802972:	8b 40 08             	mov    0x8(%eax),%eax
  802975:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  80297a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297d:	8b 50 08             	mov    0x8(%eax),%edx
  802980:	8b 45 08             	mov    0x8(%ebp),%eax
  802983:	01 c2                	add    %eax,%edx
  802985:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802988:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  80298b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298e:	8b 40 0c             	mov    0xc(%eax),%eax
  802991:	2b 45 08             	sub    0x8(%ebp),%eax
  802994:	89 c2                	mov    %eax,%edx
  802996:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802999:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  80299c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80299f:	e9 24 02 00 00       	jmp    802bc8 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8029a4:	a1 40 41 80 00       	mov    0x804140,%eax
  8029a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029b0:	74 07                	je     8029b9 <alloc_block_NF+0x3bc>
  8029b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b5:	8b 00                	mov    (%eax),%eax
  8029b7:	eb 05                	jmp    8029be <alloc_block_NF+0x3c1>
  8029b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8029be:	a3 40 41 80 00       	mov    %eax,0x804140
  8029c3:	a1 40 41 80 00       	mov    0x804140,%eax
  8029c8:	85 c0                	test   %eax,%eax
  8029ca:	0f 85 2b fe ff ff    	jne    8027fb <alloc_block_NF+0x1fe>
  8029d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029d4:	0f 85 21 fe ff ff    	jne    8027fb <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8029da:	a1 38 41 80 00       	mov    0x804138,%eax
  8029df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029e2:	e9 ae 01 00 00       	jmp    802b95 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  8029e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ea:	8b 50 08             	mov    0x8(%eax),%edx
  8029ed:	a1 28 40 80 00       	mov    0x804028,%eax
  8029f2:	39 c2                	cmp    %eax,%edx
  8029f4:	0f 83 93 01 00 00    	jae    802b8d <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  8029fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fd:	8b 40 0c             	mov    0xc(%eax),%eax
  802a00:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a03:	0f 82 84 01 00 00    	jb     802b8d <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802a09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0c:	8b 40 0c             	mov    0xc(%eax),%eax
  802a0f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a12:	0f 85 95 00 00 00    	jne    802aad <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802a18:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a1c:	75 17                	jne    802a35 <alloc_block_NF+0x438>
  802a1e:	83 ec 04             	sub    $0x4,%esp
  802a21:	68 d0 3f 80 00       	push   $0x803fd0
  802a26:	68 14 01 00 00       	push   $0x114
  802a2b:	68 27 3f 80 00       	push   $0x803f27
  802a30:	e8 5b d8 ff ff       	call   800290 <_panic>
  802a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a38:	8b 00                	mov    (%eax),%eax
  802a3a:	85 c0                	test   %eax,%eax
  802a3c:	74 10                	je     802a4e <alloc_block_NF+0x451>
  802a3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a41:	8b 00                	mov    (%eax),%eax
  802a43:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a46:	8b 52 04             	mov    0x4(%edx),%edx
  802a49:	89 50 04             	mov    %edx,0x4(%eax)
  802a4c:	eb 0b                	jmp    802a59 <alloc_block_NF+0x45c>
  802a4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a51:	8b 40 04             	mov    0x4(%eax),%eax
  802a54:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5c:	8b 40 04             	mov    0x4(%eax),%eax
  802a5f:	85 c0                	test   %eax,%eax
  802a61:	74 0f                	je     802a72 <alloc_block_NF+0x475>
  802a63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a66:	8b 40 04             	mov    0x4(%eax),%eax
  802a69:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a6c:	8b 12                	mov    (%edx),%edx
  802a6e:	89 10                	mov    %edx,(%eax)
  802a70:	eb 0a                	jmp    802a7c <alloc_block_NF+0x47f>
  802a72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a75:	8b 00                	mov    (%eax),%eax
  802a77:	a3 38 41 80 00       	mov    %eax,0x804138
  802a7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a88:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a8f:	a1 44 41 80 00       	mov    0x804144,%eax
  802a94:	48                   	dec    %eax
  802a95:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  802a9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9d:	8b 40 08             	mov    0x8(%eax),%eax
  802aa0:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  802aa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa8:	e9 1b 01 00 00       	jmp    802bc8 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802aad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab0:	8b 40 0c             	mov    0xc(%eax),%eax
  802ab3:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ab6:	0f 86 d1 00 00 00    	jbe    802b8d <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802abc:	a1 48 41 80 00       	mov    0x804148,%eax
  802ac1:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802ac4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac7:	8b 50 08             	mov    0x8(%eax),%edx
  802aca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802acd:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802ad0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ad3:	8b 55 08             	mov    0x8(%ebp),%edx
  802ad6:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802ad9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802add:	75 17                	jne    802af6 <alloc_block_NF+0x4f9>
  802adf:	83 ec 04             	sub    $0x4,%esp
  802ae2:	68 d0 3f 80 00       	push   $0x803fd0
  802ae7:	68 1c 01 00 00       	push   $0x11c
  802aec:	68 27 3f 80 00       	push   $0x803f27
  802af1:	e8 9a d7 ff ff       	call   800290 <_panic>
  802af6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802af9:	8b 00                	mov    (%eax),%eax
  802afb:	85 c0                	test   %eax,%eax
  802afd:	74 10                	je     802b0f <alloc_block_NF+0x512>
  802aff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b02:	8b 00                	mov    (%eax),%eax
  802b04:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b07:	8b 52 04             	mov    0x4(%edx),%edx
  802b0a:	89 50 04             	mov    %edx,0x4(%eax)
  802b0d:	eb 0b                	jmp    802b1a <alloc_block_NF+0x51d>
  802b0f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b12:	8b 40 04             	mov    0x4(%eax),%eax
  802b15:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b1a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b1d:	8b 40 04             	mov    0x4(%eax),%eax
  802b20:	85 c0                	test   %eax,%eax
  802b22:	74 0f                	je     802b33 <alloc_block_NF+0x536>
  802b24:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b27:	8b 40 04             	mov    0x4(%eax),%eax
  802b2a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b2d:	8b 12                	mov    (%edx),%edx
  802b2f:	89 10                	mov    %edx,(%eax)
  802b31:	eb 0a                	jmp    802b3d <alloc_block_NF+0x540>
  802b33:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b36:	8b 00                	mov    (%eax),%eax
  802b38:	a3 48 41 80 00       	mov    %eax,0x804148
  802b3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b40:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b46:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b49:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b50:	a1 54 41 80 00       	mov    0x804154,%eax
  802b55:	48                   	dec    %eax
  802b56:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  802b5b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b5e:	8b 40 08             	mov    0x8(%eax),%eax
  802b61:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  802b66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b69:	8b 50 08             	mov    0x8(%eax),%edx
  802b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6f:	01 c2                	add    %eax,%edx
  802b71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b74:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802b77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7a:	8b 40 0c             	mov    0xc(%eax),%eax
  802b7d:	2b 45 08             	sub    0x8(%ebp),%eax
  802b80:	89 c2                	mov    %eax,%edx
  802b82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b85:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802b88:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b8b:	eb 3b                	jmp    802bc8 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b8d:	a1 40 41 80 00       	mov    0x804140,%eax
  802b92:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b95:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b99:	74 07                	je     802ba2 <alloc_block_NF+0x5a5>
  802b9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9e:	8b 00                	mov    (%eax),%eax
  802ba0:	eb 05                	jmp    802ba7 <alloc_block_NF+0x5aa>
  802ba2:	b8 00 00 00 00       	mov    $0x0,%eax
  802ba7:	a3 40 41 80 00       	mov    %eax,0x804140
  802bac:	a1 40 41 80 00       	mov    0x804140,%eax
  802bb1:	85 c0                	test   %eax,%eax
  802bb3:	0f 85 2e fe ff ff    	jne    8029e7 <alloc_block_NF+0x3ea>
  802bb9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bbd:	0f 85 24 fe ff ff    	jne    8029e7 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802bc3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bc8:	c9                   	leave  
  802bc9:	c3                   	ret    

00802bca <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802bca:	55                   	push   %ebp
  802bcb:	89 e5                	mov    %esp,%ebp
  802bcd:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802bd0:	a1 38 41 80 00       	mov    0x804138,%eax
  802bd5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802bd8:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802bdd:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802be0:	a1 38 41 80 00       	mov    0x804138,%eax
  802be5:	85 c0                	test   %eax,%eax
  802be7:	74 14                	je     802bfd <insert_sorted_with_merge_freeList+0x33>
  802be9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bec:	8b 50 08             	mov    0x8(%eax),%edx
  802bef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf2:	8b 40 08             	mov    0x8(%eax),%eax
  802bf5:	39 c2                	cmp    %eax,%edx
  802bf7:	0f 87 9b 01 00 00    	ja     802d98 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802bfd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c01:	75 17                	jne    802c1a <insert_sorted_with_merge_freeList+0x50>
  802c03:	83 ec 04             	sub    $0x4,%esp
  802c06:	68 04 3f 80 00       	push   $0x803f04
  802c0b:	68 38 01 00 00       	push   $0x138
  802c10:	68 27 3f 80 00       	push   $0x803f27
  802c15:	e8 76 d6 ff ff       	call   800290 <_panic>
  802c1a:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802c20:	8b 45 08             	mov    0x8(%ebp),%eax
  802c23:	89 10                	mov    %edx,(%eax)
  802c25:	8b 45 08             	mov    0x8(%ebp),%eax
  802c28:	8b 00                	mov    (%eax),%eax
  802c2a:	85 c0                	test   %eax,%eax
  802c2c:	74 0d                	je     802c3b <insert_sorted_with_merge_freeList+0x71>
  802c2e:	a1 38 41 80 00       	mov    0x804138,%eax
  802c33:	8b 55 08             	mov    0x8(%ebp),%edx
  802c36:	89 50 04             	mov    %edx,0x4(%eax)
  802c39:	eb 08                	jmp    802c43 <insert_sorted_with_merge_freeList+0x79>
  802c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3e:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c43:	8b 45 08             	mov    0x8(%ebp),%eax
  802c46:	a3 38 41 80 00       	mov    %eax,0x804138
  802c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c55:	a1 44 41 80 00       	mov    0x804144,%eax
  802c5a:	40                   	inc    %eax
  802c5b:	a3 44 41 80 00       	mov    %eax,0x804144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802c60:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c64:	0f 84 a8 06 00 00    	je     803312 <insert_sorted_with_merge_freeList+0x748>
  802c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6d:	8b 50 08             	mov    0x8(%eax),%edx
  802c70:	8b 45 08             	mov    0x8(%ebp),%eax
  802c73:	8b 40 0c             	mov    0xc(%eax),%eax
  802c76:	01 c2                	add    %eax,%edx
  802c78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c7b:	8b 40 08             	mov    0x8(%eax),%eax
  802c7e:	39 c2                	cmp    %eax,%edx
  802c80:	0f 85 8c 06 00 00    	jne    803312 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802c86:	8b 45 08             	mov    0x8(%ebp),%eax
  802c89:	8b 50 0c             	mov    0xc(%eax),%edx
  802c8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c8f:	8b 40 0c             	mov    0xc(%eax),%eax
  802c92:	01 c2                	add    %eax,%edx
  802c94:	8b 45 08             	mov    0x8(%ebp),%eax
  802c97:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802c9a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c9e:	75 17                	jne    802cb7 <insert_sorted_with_merge_freeList+0xed>
  802ca0:	83 ec 04             	sub    $0x4,%esp
  802ca3:	68 d0 3f 80 00       	push   $0x803fd0
  802ca8:	68 3c 01 00 00       	push   $0x13c
  802cad:	68 27 3f 80 00       	push   $0x803f27
  802cb2:	e8 d9 d5 ff ff       	call   800290 <_panic>
  802cb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cba:	8b 00                	mov    (%eax),%eax
  802cbc:	85 c0                	test   %eax,%eax
  802cbe:	74 10                	je     802cd0 <insert_sorted_with_merge_freeList+0x106>
  802cc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cc3:	8b 00                	mov    (%eax),%eax
  802cc5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cc8:	8b 52 04             	mov    0x4(%edx),%edx
  802ccb:	89 50 04             	mov    %edx,0x4(%eax)
  802cce:	eb 0b                	jmp    802cdb <insert_sorted_with_merge_freeList+0x111>
  802cd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cd3:	8b 40 04             	mov    0x4(%eax),%eax
  802cd6:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802cdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cde:	8b 40 04             	mov    0x4(%eax),%eax
  802ce1:	85 c0                	test   %eax,%eax
  802ce3:	74 0f                	je     802cf4 <insert_sorted_with_merge_freeList+0x12a>
  802ce5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ce8:	8b 40 04             	mov    0x4(%eax),%eax
  802ceb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cee:	8b 12                	mov    (%edx),%edx
  802cf0:	89 10                	mov    %edx,(%eax)
  802cf2:	eb 0a                	jmp    802cfe <insert_sorted_with_merge_freeList+0x134>
  802cf4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf7:	8b 00                	mov    (%eax),%eax
  802cf9:	a3 38 41 80 00       	mov    %eax,0x804138
  802cfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d01:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d0a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d11:	a1 44 41 80 00       	mov    0x804144,%eax
  802d16:	48                   	dec    %eax
  802d17:	a3 44 41 80 00       	mov    %eax,0x804144
			head->size = 0;
  802d1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d1f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802d26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d29:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802d30:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d34:	75 17                	jne    802d4d <insert_sorted_with_merge_freeList+0x183>
  802d36:	83 ec 04             	sub    $0x4,%esp
  802d39:	68 04 3f 80 00       	push   $0x803f04
  802d3e:	68 3f 01 00 00       	push   $0x13f
  802d43:	68 27 3f 80 00       	push   $0x803f27
  802d48:	e8 43 d5 ff ff       	call   800290 <_panic>
  802d4d:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d56:	89 10                	mov    %edx,(%eax)
  802d58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d5b:	8b 00                	mov    (%eax),%eax
  802d5d:	85 c0                	test   %eax,%eax
  802d5f:	74 0d                	je     802d6e <insert_sorted_with_merge_freeList+0x1a4>
  802d61:	a1 48 41 80 00       	mov    0x804148,%eax
  802d66:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d69:	89 50 04             	mov    %edx,0x4(%eax)
  802d6c:	eb 08                	jmp    802d76 <insert_sorted_with_merge_freeList+0x1ac>
  802d6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d71:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d79:	a3 48 41 80 00       	mov    %eax,0x804148
  802d7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d81:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d88:	a1 54 41 80 00       	mov    0x804154,%eax
  802d8d:	40                   	inc    %eax
  802d8e:	a3 54 41 80 00       	mov    %eax,0x804154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802d93:	e9 7a 05 00 00       	jmp    803312 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802d98:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9b:	8b 50 08             	mov    0x8(%eax),%edx
  802d9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802da1:	8b 40 08             	mov    0x8(%eax),%eax
  802da4:	39 c2                	cmp    %eax,%edx
  802da6:	0f 82 14 01 00 00    	jb     802ec0 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802dac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802daf:	8b 50 08             	mov    0x8(%eax),%edx
  802db2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802db5:	8b 40 0c             	mov    0xc(%eax),%eax
  802db8:	01 c2                	add    %eax,%edx
  802dba:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbd:	8b 40 08             	mov    0x8(%eax),%eax
  802dc0:	39 c2                	cmp    %eax,%edx
  802dc2:	0f 85 90 00 00 00    	jne    802e58 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802dc8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dcb:	8b 50 0c             	mov    0xc(%eax),%edx
  802dce:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd1:	8b 40 0c             	mov    0xc(%eax),%eax
  802dd4:	01 c2                	add    %eax,%edx
  802dd6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dd9:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ddf:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802de6:	8b 45 08             	mov    0x8(%ebp),%eax
  802de9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802df0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802df4:	75 17                	jne    802e0d <insert_sorted_with_merge_freeList+0x243>
  802df6:	83 ec 04             	sub    $0x4,%esp
  802df9:	68 04 3f 80 00       	push   $0x803f04
  802dfe:	68 49 01 00 00       	push   $0x149
  802e03:	68 27 3f 80 00       	push   $0x803f27
  802e08:	e8 83 d4 ff ff       	call   800290 <_panic>
  802e0d:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e13:	8b 45 08             	mov    0x8(%ebp),%eax
  802e16:	89 10                	mov    %edx,(%eax)
  802e18:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1b:	8b 00                	mov    (%eax),%eax
  802e1d:	85 c0                	test   %eax,%eax
  802e1f:	74 0d                	je     802e2e <insert_sorted_with_merge_freeList+0x264>
  802e21:	a1 48 41 80 00       	mov    0x804148,%eax
  802e26:	8b 55 08             	mov    0x8(%ebp),%edx
  802e29:	89 50 04             	mov    %edx,0x4(%eax)
  802e2c:	eb 08                	jmp    802e36 <insert_sorted_with_merge_freeList+0x26c>
  802e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e31:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e36:	8b 45 08             	mov    0x8(%ebp),%eax
  802e39:	a3 48 41 80 00       	mov    %eax,0x804148
  802e3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e41:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e48:	a1 54 41 80 00       	mov    0x804154,%eax
  802e4d:	40                   	inc    %eax
  802e4e:	a3 54 41 80 00       	mov    %eax,0x804154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802e53:	e9 bb 04 00 00       	jmp    803313 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802e58:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e5c:	75 17                	jne    802e75 <insert_sorted_with_merge_freeList+0x2ab>
  802e5e:	83 ec 04             	sub    $0x4,%esp
  802e61:	68 78 3f 80 00       	push   $0x803f78
  802e66:	68 4c 01 00 00       	push   $0x14c
  802e6b:	68 27 3f 80 00       	push   $0x803f27
  802e70:	e8 1b d4 ff ff       	call   800290 <_panic>
  802e75:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802e7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7e:	89 50 04             	mov    %edx,0x4(%eax)
  802e81:	8b 45 08             	mov    0x8(%ebp),%eax
  802e84:	8b 40 04             	mov    0x4(%eax),%eax
  802e87:	85 c0                	test   %eax,%eax
  802e89:	74 0c                	je     802e97 <insert_sorted_with_merge_freeList+0x2cd>
  802e8b:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802e90:	8b 55 08             	mov    0x8(%ebp),%edx
  802e93:	89 10                	mov    %edx,(%eax)
  802e95:	eb 08                	jmp    802e9f <insert_sorted_with_merge_freeList+0x2d5>
  802e97:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9a:	a3 38 41 80 00       	mov    %eax,0x804138
  802e9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea2:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eaa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802eb0:	a1 44 41 80 00       	mov    0x804144,%eax
  802eb5:	40                   	inc    %eax
  802eb6:	a3 44 41 80 00       	mov    %eax,0x804144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802ebb:	e9 53 04 00 00       	jmp    803313 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802ec0:	a1 38 41 80 00       	mov    0x804138,%eax
  802ec5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ec8:	e9 15 04 00 00       	jmp    8032e2 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802ecd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed0:	8b 00                	mov    (%eax),%eax
  802ed2:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802ed5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed8:	8b 50 08             	mov    0x8(%eax),%edx
  802edb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ede:	8b 40 08             	mov    0x8(%eax),%eax
  802ee1:	39 c2                	cmp    %eax,%edx
  802ee3:	0f 86 f1 03 00 00    	jbe    8032da <insert_sorted_with_merge_freeList+0x710>
  802ee9:	8b 45 08             	mov    0x8(%ebp),%eax
  802eec:	8b 50 08             	mov    0x8(%eax),%edx
  802eef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ef2:	8b 40 08             	mov    0x8(%eax),%eax
  802ef5:	39 c2                	cmp    %eax,%edx
  802ef7:	0f 83 dd 03 00 00    	jae    8032da <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802efd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f00:	8b 50 08             	mov    0x8(%eax),%edx
  802f03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f06:	8b 40 0c             	mov    0xc(%eax),%eax
  802f09:	01 c2                	add    %eax,%edx
  802f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0e:	8b 40 08             	mov    0x8(%eax),%eax
  802f11:	39 c2                	cmp    %eax,%edx
  802f13:	0f 85 b9 01 00 00    	jne    8030d2 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802f19:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1c:	8b 50 08             	mov    0x8(%eax),%edx
  802f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f22:	8b 40 0c             	mov    0xc(%eax),%eax
  802f25:	01 c2                	add    %eax,%edx
  802f27:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f2a:	8b 40 08             	mov    0x8(%eax),%eax
  802f2d:	39 c2                	cmp    %eax,%edx
  802f2f:	0f 85 0d 01 00 00    	jne    803042 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802f35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f38:	8b 50 0c             	mov    0xc(%eax),%edx
  802f3b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f3e:	8b 40 0c             	mov    0xc(%eax),%eax
  802f41:	01 c2                	add    %eax,%edx
  802f43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f46:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802f49:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f4d:	75 17                	jne    802f66 <insert_sorted_with_merge_freeList+0x39c>
  802f4f:	83 ec 04             	sub    $0x4,%esp
  802f52:	68 d0 3f 80 00       	push   $0x803fd0
  802f57:	68 5c 01 00 00       	push   $0x15c
  802f5c:	68 27 3f 80 00       	push   $0x803f27
  802f61:	e8 2a d3 ff ff       	call   800290 <_panic>
  802f66:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f69:	8b 00                	mov    (%eax),%eax
  802f6b:	85 c0                	test   %eax,%eax
  802f6d:	74 10                	je     802f7f <insert_sorted_with_merge_freeList+0x3b5>
  802f6f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f72:	8b 00                	mov    (%eax),%eax
  802f74:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f77:	8b 52 04             	mov    0x4(%edx),%edx
  802f7a:	89 50 04             	mov    %edx,0x4(%eax)
  802f7d:	eb 0b                	jmp    802f8a <insert_sorted_with_merge_freeList+0x3c0>
  802f7f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f82:	8b 40 04             	mov    0x4(%eax),%eax
  802f85:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802f8a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f8d:	8b 40 04             	mov    0x4(%eax),%eax
  802f90:	85 c0                	test   %eax,%eax
  802f92:	74 0f                	je     802fa3 <insert_sorted_with_merge_freeList+0x3d9>
  802f94:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f97:	8b 40 04             	mov    0x4(%eax),%eax
  802f9a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f9d:	8b 12                	mov    (%edx),%edx
  802f9f:	89 10                	mov    %edx,(%eax)
  802fa1:	eb 0a                	jmp    802fad <insert_sorted_with_merge_freeList+0x3e3>
  802fa3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fa6:	8b 00                	mov    (%eax),%eax
  802fa8:	a3 38 41 80 00       	mov    %eax,0x804138
  802fad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fb0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fb6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fb9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fc0:	a1 44 41 80 00       	mov    0x804144,%eax
  802fc5:	48                   	dec    %eax
  802fc6:	a3 44 41 80 00       	mov    %eax,0x804144
						nextBlock->sva = 0;
  802fcb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fce:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  802fd5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fd8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  802fdf:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802fe3:	75 17                	jne    802ffc <insert_sorted_with_merge_freeList+0x432>
  802fe5:	83 ec 04             	sub    $0x4,%esp
  802fe8:	68 04 3f 80 00       	push   $0x803f04
  802fed:	68 5f 01 00 00       	push   $0x15f
  802ff2:	68 27 3f 80 00       	push   $0x803f27
  802ff7:	e8 94 d2 ff ff       	call   800290 <_panic>
  802ffc:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803002:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803005:	89 10                	mov    %edx,(%eax)
  803007:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80300a:	8b 00                	mov    (%eax),%eax
  80300c:	85 c0                	test   %eax,%eax
  80300e:	74 0d                	je     80301d <insert_sorted_with_merge_freeList+0x453>
  803010:	a1 48 41 80 00       	mov    0x804148,%eax
  803015:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803018:	89 50 04             	mov    %edx,0x4(%eax)
  80301b:	eb 08                	jmp    803025 <insert_sorted_with_merge_freeList+0x45b>
  80301d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803020:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803025:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803028:	a3 48 41 80 00       	mov    %eax,0x804148
  80302d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803030:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803037:	a1 54 41 80 00       	mov    0x804154,%eax
  80303c:	40                   	inc    %eax
  80303d:	a3 54 41 80 00       	mov    %eax,0x804154
					}
					currentBlock->size += blockToInsert->size;
  803042:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803045:	8b 50 0c             	mov    0xc(%eax),%edx
  803048:	8b 45 08             	mov    0x8(%ebp),%eax
  80304b:	8b 40 0c             	mov    0xc(%eax),%eax
  80304e:	01 c2                	add    %eax,%edx
  803050:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803053:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803056:	8b 45 08             	mov    0x8(%ebp),%eax
  803059:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803060:	8b 45 08             	mov    0x8(%ebp),%eax
  803063:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80306a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80306e:	75 17                	jne    803087 <insert_sorted_with_merge_freeList+0x4bd>
  803070:	83 ec 04             	sub    $0x4,%esp
  803073:	68 04 3f 80 00       	push   $0x803f04
  803078:	68 64 01 00 00       	push   $0x164
  80307d:	68 27 3f 80 00       	push   $0x803f27
  803082:	e8 09 d2 ff ff       	call   800290 <_panic>
  803087:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80308d:	8b 45 08             	mov    0x8(%ebp),%eax
  803090:	89 10                	mov    %edx,(%eax)
  803092:	8b 45 08             	mov    0x8(%ebp),%eax
  803095:	8b 00                	mov    (%eax),%eax
  803097:	85 c0                	test   %eax,%eax
  803099:	74 0d                	je     8030a8 <insert_sorted_with_merge_freeList+0x4de>
  80309b:	a1 48 41 80 00       	mov    0x804148,%eax
  8030a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8030a3:	89 50 04             	mov    %edx,0x4(%eax)
  8030a6:	eb 08                	jmp    8030b0 <insert_sorted_with_merge_freeList+0x4e6>
  8030a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ab:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8030b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b3:	a3 48 41 80 00       	mov    %eax,0x804148
  8030b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030bb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030c2:	a1 54 41 80 00       	mov    0x804154,%eax
  8030c7:	40                   	inc    %eax
  8030c8:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  8030cd:	e9 41 02 00 00       	jmp    803313 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8030d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d5:	8b 50 08             	mov    0x8(%eax),%edx
  8030d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030db:	8b 40 0c             	mov    0xc(%eax),%eax
  8030de:	01 c2                	add    %eax,%edx
  8030e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030e3:	8b 40 08             	mov    0x8(%eax),%eax
  8030e6:	39 c2                	cmp    %eax,%edx
  8030e8:	0f 85 7c 01 00 00    	jne    80326a <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8030ee:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030f2:	74 06                	je     8030fa <insert_sorted_with_merge_freeList+0x530>
  8030f4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030f8:	75 17                	jne    803111 <insert_sorted_with_merge_freeList+0x547>
  8030fa:	83 ec 04             	sub    $0x4,%esp
  8030fd:	68 40 3f 80 00       	push   $0x803f40
  803102:	68 69 01 00 00       	push   $0x169
  803107:	68 27 3f 80 00       	push   $0x803f27
  80310c:	e8 7f d1 ff ff       	call   800290 <_panic>
  803111:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803114:	8b 50 04             	mov    0x4(%eax),%edx
  803117:	8b 45 08             	mov    0x8(%ebp),%eax
  80311a:	89 50 04             	mov    %edx,0x4(%eax)
  80311d:	8b 45 08             	mov    0x8(%ebp),%eax
  803120:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803123:	89 10                	mov    %edx,(%eax)
  803125:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803128:	8b 40 04             	mov    0x4(%eax),%eax
  80312b:	85 c0                	test   %eax,%eax
  80312d:	74 0d                	je     80313c <insert_sorted_with_merge_freeList+0x572>
  80312f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803132:	8b 40 04             	mov    0x4(%eax),%eax
  803135:	8b 55 08             	mov    0x8(%ebp),%edx
  803138:	89 10                	mov    %edx,(%eax)
  80313a:	eb 08                	jmp    803144 <insert_sorted_with_merge_freeList+0x57a>
  80313c:	8b 45 08             	mov    0x8(%ebp),%eax
  80313f:	a3 38 41 80 00       	mov    %eax,0x804138
  803144:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803147:	8b 55 08             	mov    0x8(%ebp),%edx
  80314a:	89 50 04             	mov    %edx,0x4(%eax)
  80314d:	a1 44 41 80 00       	mov    0x804144,%eax
  803152:	40                   	inc    %eax
  803153:	a3 44 41 80 00       	mov    %eax,0x804144
					blockToInsert->size += nextBlock->size;
  803158:	8b 45 08             	mov    0x8(%ebp),%eax
  80315b:	8b 50 0c             	mov    0xc(%eax),%edx
  80315e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803161:	8b 40 0c             	mov    0xc(%eax),%eax
  803164:	01 c2                	add    %eax,%edx
  803166:	8b 45 08             	mov    0x8(%ebp),%eax
  803169:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80316c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803170:	75 17                	jne    803189 <insert_sorted_with_merge_freeList+0x5bf>
  803172:	83 ec 04             	sub    $0x4,%esp
  803175:	68 d0 3f 80 00       	push   $0x803fd0
  80317a:	68 6b 01 00 00       	push   $0x16b
  80317f:	68 27 3f 80 00       	push   $0x803f27
  803184:	e8 07 d1 ff ff       	call   800290 <_panic>
  803189:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80318c:	8b 00                	mov    (%eax),%eax
  80318e:	85 c0                	test   %eax,%eax
  803190:	74 10                	je     8031a2 <insert_sorted_with_merge_freeList+0x5d8>
  803192:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803195:	8b 00                	mov    (%eax),%eax
  803197:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80319a:	8b 52 04             	mov    0x4(%edx),%edx
  80319d:	89 50 04             	mov    %edx,0x4(%eax)
  8031a0:	eb 0b                	jmp    8031ad <insert_sorted_with_merge_freeList+0x5e3>
  8031a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031a5:	8b 40 04             	mov    0x4(%eax),%eax
  8031a8:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8031ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031b0:	8b 40 04             	mov    0x4(%eax),%eax
  8031b3:	85 c0                	test   %eax,%eax
  8031b5:	74 0f                	je     8031c6 <insert_sorted_with_merge_freeList+0x5fc>
  8031b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ba:	8b 40 04             	mov    0x4(%eax),%eax
  8031bd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031c0:	8b 12                	mov    (%edx),%edx
  8031c2:	89 10                	mov    %edx,(%eax)
  8031c4:	eb 0a                	jmp    8031d0 <insert_sorted_with_merge_freeList+0x606>
  8031c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c9:	8b 00                	mov    (%eax),%eax
  8031cb:	a3 38 41 80 00       	mov    %eax,0x804138
  8031d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031dc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031e3:	a1 44 41 80 00       	mov    0x804144,%eax
  8031e8:	48                   	dec    %eax
  8031e9:	a3 44 41 80 00       	mov    %eax,0x804144
					nextBlock->sva = 0;
  8031ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8031f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031fb:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803202:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803206:	75 17                	jne    80321f <insert_sorted_with_merge_freeList+0x655>
  803208:	83 ec 04             	sub    $0x4,%esp
  80320b:	68 04 3f 80 00       	push   $0x803f04
  803210:	68 6e 01 00 00       	push   $0x16e
  803215:	68 27 3f 80 00       	push   $0x803f27
  80321a:	e8 71 d0 ff ff       	call   800290 <_panic>
  80321f:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803225:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803228:	89 10                	mov    %edx,(%eax)
  80322a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80322d:	8b 00                	mov    (%eax),%eax
  80322f:	85 c0                	test   %eax,%eax
  803231:	74 0d                	je     803240 <insert_sorted_with_merge_freeList+0x676>
  803233:	a1 48 41 80 00       	mov    0x804148,%eax
  803238:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80323b:	89 50 04             	mov    %edx,0x4(%eax)
  80323e:	eb 08                	jmp    803248 <insert_sorted_with_merge_freeList+0x67e>
  803240:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803243:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803248:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80324b:	a3 48 41 80 00       	mov    %eax,0x804148
  803250:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803253:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80325a:	a1 54 41 80 00       	mov    0x804154,%eax
  80325f:	40                   	inc    %eax
  803260:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  803265:	e9 a9 00 00 00       	jmp    803313 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  80326a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80326e:	74 06                	je     803276 <insert_sorted_with_merge_freeList+0x6ac>
  803270:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803274:	75 17                	jne    80328d <insert_sorted_with_merge_freeList+0x6c3>
  803276:	83 ec 04             	sub    $0x4,%esp
  803279:	68 9c 3f 80 00       	push   $0x803f9c
  80327e:	68 73 01 00 00       	push   $0x173
  803283:	68 27 3f 80 00       	push   $0x803f27
  803288:	e8 03 d0 ff ff       	call   800290 <_panic>
  80328d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803290:	8b 10                	mov    (%eax),%edx
  803292:	8b 45 08             	mov    0x8(%ebp),%eax
  803295:	89 10                	mov    %edx,(%eax)
  803297:	8b 45 08             	mov    0x8(%ebp),%eax
  80329a:	8b 00                	mov    (%eax),%eax
  80329c:	85 c0                	test   %eax,%eax
  80329e:	74 0b                	je     8032ab <insert_sorted_with_merge_freeList+0x6e1>
  8032a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a3:	8b 00                	mov    (%eax),%eax
  8032a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8032a8:	89 50 04             	mov    %edx,0x4(%eax)
  8032ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8032b1:	89 10                	mov    %edx,(%eax)
  8032b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032b9:	89 50 04             	mov    %edx,0x4(%eax)
  8032bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8032bf:	8b 00                	mov    (%eax),%eax
  8032c1:	85 c0                	test   %eax,%eax
  8032c3:	75 08                	jne    8032cd <insert_sorted_with_merge_freeList+0x703>
  8032c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c8:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8032cd:	a1 44 41 80 00       	mov    0x804144,%eax
  8032d2:	40                   	inc    %eax
  8032d3:	a3 44 41 80 00       	mov    %eax,0x804144
					break;
  8032d8:	eb 39                	jmp    803313 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8032da:	a1 40 41 80 00       	mov    0x804140,%eax
  8032df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032e6:	74 07                	je     8032ef <insert_sorted_with_merge_freeList+0x725>
  8032e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032eb:	8b 00                	mov    (%eax),%eax
  8032ed:	eb 05                	jmp    8032f4 <insert_sorted_with_merge_freeList+0x72a>
  8032ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8032f4:	a3 40 41 80 00       	mov    %eax,0x804140
  8032f9:	a1 40 41 80 00       	mov    0x804140,%eax
  8032fe:	85 c0                	test   %eax,%eax
  803300:	0f 85 c7 fb ff ff    	jne    802ecd <insert_sorted_with_merge_freeList+0x303>
  803306:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80330a:	0f 85 bd fb ff ff    	jne    802ecd <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803310:	eb 01                	jmp    803313 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803312:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803313:	90                   	nop
  803314:	c9                   	leave  
  803315:	c3                   	ret    

00803316 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803316:	55                   	push   %ebp
  803317:	89 e5                	mov    %esp,%ebp
  803319:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  80331c:	8b 55 08             	mov    0x8(%ebp),%edx
  80331f:	89 d0                	mov    %edx,%eax
  803321:	c1 e0 02             	shl    $0x2,%eax
  803324:	01 d0                	add    %edx,%eax
  803326:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80332d:	01 d0                	add    %edx,%eax
  80332f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803336:	01 d0                	add    %edx,%eax
  803338:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80333f:	01 d0                	add    %edx,%eax
  803341:	c1 e0 04             	shl    $0x4,%eax
  803344:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803347:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  80334e:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803351:	83 ec 0c             	sub    $0xc,%esp
  803354:	50                   	push   %eax
  803355:	e8 26 e7 ff ff       	call   801a80 <sys_get_virtual_time>
  80335a:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  80335d:	eb 41                	jmp    8033a0 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  80335f:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803362:	83 ec 0c             	sub    $0xc,%esp
  803365:	50                   	push   %eax
  803366:	e8 15 e7 ff ff       	call   801a80 <sys_get_virtual_time>
  80336b:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  80336e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803371:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803374:	29 c2                	sub    %eax,%edx
  803376:	89 d0                	mov    %edx,%eax
  803378:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  80337b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80337e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803381:	89 d1                	mov    %edx,%ecx
  803383:	29 c1                	sub    %eax,%ecx
  803385:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803388:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80338b:	39 c2                	cmp    %eax,%edx
  80338d:	0f 97 c0             	seta   %al
  803390:	0f b6 c0             	movzbl %al,%eax
  803393:	29 c1                	sub    %eax,%ecx
  803395:	89 c8                	mov    %ecx,%eax
  803397:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  80339a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80339d:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8033a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8033a6:	72 b7                	jb     80335f <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8033a8:	90                   	nop
  8033a9:	c9                   	leave  
  8033aa:	c3                   	ret    

008033ab <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8033ab:	55                   	push   %ebp
  8033ac:	89 e5                	mov    %esp,%ebp
  8033ae:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8033b1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8033b8:	eb 03                	jmp    8033bd <busy_wait+0x12>
  8033ba:	ff 45 fc             	incl   -0x4(%ebp)
  8033bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8033c0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8033c3:	72 f5                	jb     8033ba <busy_wait+0xf>
	return i;
  8033c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8033c8:	c9                   	leave  
  8033c9:	c3                   	ret    
  8033ca:	66 90                	xchg   %ax,%ax

008033cc <__udivdi3>:
  8033cc:	55                   	push   %ebp
  8033cd:	57                   	push   %edi
  8033ce:	56                   	push   %esi
  8033cf:	53                   	push   %ebx
  8033d0:	83 ec 1c             	sub    $0x1c,%esp
  8033d3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8033d7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8033db:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8033df:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8033e3:	89 ca                	mov    %ecx,%edx
  8033e5:	89 f8                	mov    %edi,%eax
  8033e7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8033eb:	85 f6                	test   %esi,%esi
  8033ed:	75 2d                	jne    80341c <__udivdi3+0x50>
  8033ef:	39 cf                	cmp    %ecx,%edi
  8033f1:	77 65                	ja     803458 <__udivdi3+0x8c>
  8033f3:	89 fd                	mov    %edi,%ebp
  8033f5:	85 ff                	test   %edi,%edi
  8033f7:	75 0b                	jne    803404 <__udivdi3+0x38>
  8033f9:	b8 01 00 00 00       	mov    $0x1,%eax
  8033fe:	31 d2                	xor    %edx,%edx
  803400:	f7 f7                	div    %edi
  803402:	89 c5                	mov    %eax,%ebp
  803404:	31 d2                	xor    %edx,%edx
  803406:	89 c8                	mov    %ecx,%eax
  803408:	f7 f5                	div    %ebp
  80340a:	89 c1                	mov    %eax,%ecx
  80340c:	89 d8                	mov    %ebx,%eax
  80340e:	f7 f5                	div    %ebp
  803410:	89 cf                	mov    %ecx,%edi
  803412:	89 fa                	mov    %edi,%edx
  803414:	83 c4 1c             	add    $0x1c,%esp
  803417:	5b                   	pop    %ebx
  803418:	5e                   	pop    %esi
  803419:	5f                   	pop    %edi
  80341a:	5d                   	pop    %ebp
  80341b:	c3                   	ret    
  80341c:	39 ce                	cmp    %ecx,%esi
  80341e:	77 28                	ja     803448 <__udivdi3+0x7c>
  803420:	0f bd fe             	bsr    %esi,%edi
  803423:	83 f7 1f             	xor    $0x1f,%edi
  803426:	75 40                	jne    803468 <__udivdi3+0x9c>
  803428:	39 ce                	cmp    %ecx,%esi
  80342a:	72 0a                	jb     803436 <__udivdi3+0x6a>
  80342c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803430:	0f 87 9e 00 00 00    	ja     8034d4 <__udivdi3+0x108>
  803436:	b8 01 00 00 00       	mov    $0x1,%eax
  80343b:	89 fa                	mov    %edi,%edx
  80343d:	83 c4 1c             	add    $0x1c,%esp
  803440:	5b                   	pop    %ebx
  803441:	5e                   	pop    %esi
  803442:	5f                   	pop    %edi
  803443:	5d                   	pop    %ebp
  803444:	c3                   	ret    
  803445:	8d 76 00             	lea    0x0(%esi),%esi
  803448:	31 ff                	xor    %edi,%edi
  80344a:	31 c0                	xor    %eax,%eax
  80344c:	89 fa                	mov    %edi,%edx
  80344e:	83 c4 1c             	add    $0x1c,%esp
  803451:	5b                   	pop    %ebx
  803452:	5e                   	pop    %esi
  803453:	5f                   	pop    %edi
  803454:	5d                   	pop    %ebp
  803455:	c3                   	ret    
  803456:	66 90                	xchg   %ax,%ax
  803458:	89 d8                	mov    %ebx,%eax
  80345a:	f7 f7                	div    %edi
  80345c:	31 ff                	xor    %edi,%edi
  80345e:	89 fa                	mov    %edi,%edx
  803460:	83 c4 1c             	add    $0x1c,%esp
  803463:	5b                   	pop    %ebx
  803464:	5e                   	pop    %esi
  803465:	5f                   	pop    %edi
  803466:	5d                   	pop    %ebp
  803467:	c3                   	ret    
  803468:	bd 20 00 00 00       	mov    $0x20,%ebp
  80346d:	89 eb                	mov    %ebp,%ebx
  80346f:	29 fb                	sub    %edi,%ebx
  803471:	89 f9                	mov    %edi,%ecx
  803473:	d3 e6                	shl    %cl,%esi
  803475:	89 c5                	mov    %eax,%ebp
  803477:	88 d9                	mov    %bl,%cl
  803479:	d3 ed                	shr    %cl,%ebp
  80347b:	89 e9                	mov    %ebp,%ecx
  80347d:	09 f1                	or     %esi,%ecx
  80347f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803483:	89 f9                	mov    %edi,%ecx
  803485:	d3 e0                	shl    %cl,%eax
  803487:	89 c5                	mov    %eax,%ebp
  803489:	89 d6                	mov    %edx,%esi
  80348b:	88 d9                	mov    %bl,%cl
  80348d:	d3 ee                	shr    %cl,%esi
  80348f:	89 f9                	mov    %edi,%ecx
  803491:	d3 e2                	shl    %cl,%edx
  803493:	8b 44 24 08          	mov    0x8(%esp),%eax
  803497:	88 d9                	mov    %bl,%cl
  803499:	d3 e8                	shr    %cl,%eax
  80349b:	09 c2                	or     %eax,%edx
  80349d:	89 d0                	mov    %edx,%eax
  80349f:	89 f2                	mov    %esi,%edx
  8034a1:	f7 74 24 0c          	divl   0xc(%esp)
  8034a5:	89 d6                	mov    %edx,%esi
  8034a7:	89 c3                	mov    %eax,%ebx
  8034a9:	f7 e5                	mul    %ebp
  8034ab:	39 d6                	cmp    %edx,%esi
  8034ad:	72 19                	jb     8034c8 <__udivdi3+0xfc>
  8034af:	74 0b                	je     8034bc <__udivdi3+0xf0>
  8034b1:	89 d8                	mov    %ebx,%eax
  8034b3:	31 ff                	xor    %edi,%edi
  8034b5:	e9 58 ff ff ff       	jmp    803412 <__udivdi3+0x46>
  8034ba:	66 90                	xchg   %ax,%ax
  8034bc:	8b 54 24 08          	mov    0x8(%esp),%edx
  8034c0:	89 f9                	mov    %edi,%ecx
  8034c2:	d3 e2                	shl    %cl,%edx
  8034c4:	39 c2                	cmp    %eax,%edx
  8034c6:	73 e9                	jae    8034b1 <__udivdi3+0xe5>
  8034c8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8034cb:	31 ff                	xor    %edi,%edi
  8034cd:	e9 40 ff ff ff       	jmp    803412 <__udivdi3+0x46>
  8034d2:	66 90                	xchg   %ax,%ax
  8034d4:	31 c0                	xor    %eax,%eax
  8034d6:	e9 37 ff ff ff       	jmp    803412 <__udivdi3+0x46>
  8034db:	90                   	nop

008034dc <__umoddi3>:
  8034dc:	55                   	push   %ebp
  8034dd:	57                   	push   %edi
  8034de:	56                   	push   %esi
  8034df:	53                   	push   %ebx
  8034e0:	83 ec 1c             	sub    $0x1c,%esp
  8034e3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8034e7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8034eb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8034ef:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8034f3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8034f7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8034fb:	89 f3                	mov    %esi,%ebx
  8034fd:	89 fa                	mov    %edi,%edx
  8034ff:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803503:	89 34 24             	mov    %esi,(%esp)
  803506:	85 c0                	test   %eax,%eax
  803508:	75 1a                	jne    803524 <__umoddi3+0x48>
  80350a:	39 f7                	cmp    %esi,%edi
  80350c:	0f 86 a2 00 00 00    	jbe    8035b4 <__umoddi3+0xd8>
  803512:	89 c8                	mov    %ecx,%eax
  803514:	89 f2                	mov    %esi,%edx
  803516:	f7 f7                	div    %edi
  803518:	89 d0                	mov    %edx,%eax
  80351a:	31 d2                	xor    %edx,%edx
  80351c:	83 c4 1c             	add    $0x1c,%esp
  80351f:	5b                   	pop    %ebx
  803520:	5e                   	pop    %esi
  803521:	5f                   	pop    %edi
  803522:	5d                   	pop    %ebp
  803523:	c3                   	ret    
  803524:	39 f0                	cmp    %esi,%eax
  803526:	0f 87 ac 00 00 00    	ja     8035d8 <__umoddi3+0xfc>
  80352c:	0f bd e8             	bsr    %eax,%ebp
  80352f:	83 f5 1f             	xor    $0x1f,%ebp
  803532:	0f 84 ac 00 00 00    	je     8035e4 <__umoddi3+0x108>
  803538:	bf 20 00 00 00       	mov    $0x20,%edi
  80353d:	29 ef                	sub    %ebp,%edi
  80353f:	89 fe                	mov    %edi,%esi
  803541:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803545:	89 e9                	mov    %ebp,%ecx
  803547:	d3 e0                	shl    %cl,%eax
  803549:	89 d7                	mov    %edx,%edi
  80354b:	89 f1                	mov    %esi,%ecx
  80354d:	d3 ef                	shr    %cl,%edi
  80354f:	09 c7                	or     %eax,%edi
  803551:	89 e9                	mov    %ebp,%ecx
  803553:	d3 e2                	shl    %cl,%edx
  803555:	89 14 24             	mov    %edx,(%esp)
  803558:	89 d8                	mov    %ebx,%eax
  80355a:	d3 e0                	shl    %cl,%eax
  80355c:	89 c2                	mov    %eax,%edx
  80355e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803562:	d3 e0                	shl    %cl,%eax
  803564:	89 44 24 04          	mov    %eax,0x4(%esp)
  803568:	8b 44 24 08          	mov    0x8(%esp),%eax
  80356c:	89 f1                	mov    %esi,%ecx
  80356e:	d3 e8                	shr    %cl,%eax
  803570:	09 d0                	or     %edx,%eax
  803572:	d3 eb                	shr    %cl,%ebx
  803574:	89 da                	mov    %ebx,%edx
  803576:	f7 f7                	div    %edi
  803578:	89 d3                	mov    %edx,%ebx
  80357a:	f7 24 24             	mull   (%esp)
  80357d:	89 c6                	mov    %eax,%esi
  80357f:	89 d1                	mov    %edx,%ecx
  803581:	39 d3                	cmp    %edx,%ebx
  803583:	0f 82 87 00 00 00    	jb     803610 <__umoddi3+0x134>
  803589:	0f 84 91 00 00 00    	je     803620 <__umoddi3+0x144>
  80358f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803593:	29 f2                	sub    %esi,%edx
  803595:	19 cb                	sbb    %ecx,%ebx
  803597:	89 d8                	mov    %ebx,%eax
  803599:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80359d:	d3 e0                	shl    %cl,%eax
  80359f:	89 e9                	mov    %ebp,%ecx
  8035a1:	d3 ea                	shr    %cl,%edx
  8035a3:	09 d0                	or     %edx,%eax
  8035a5:	89 e9                	mov    %ebp,%ecx
  8035a7:	d3 eb                	shr    %cl,%ebx
  8035a9:	89 da                	mov    %ebx,%edx
  8035ab:	83 c4 1c             	add    $0x1c,%esp
  8035ae:	5b                   	pop    %ebx
  8035af:	5e                   	pop    %esi
  8035b0:	5f                   	pop    %edi
  8035b1:	5d                   	pop    %ebp
  8035b2:	c3                   	ret    
  8035b3:	90                   	nop
  8035b4:	89 fd                	mov    %edi,%ebp
  8035b6:	85 ff                	test   %edi,%edi
  8035b8:	75 0b                	jne    8035c5 <__umoddi3+0xe9>
  8035ba:	b8 01 00 00 00       	mov    $0x1,%eax
  8035bf:	31 d2                	xor    %edx,%edx
  8035c1:	f7 f7                	div    %edi
  8035c3:	89 c5                	mov    %eax,%ebp
  8035c5:	89 f0                	mov    %esi,%eax
  8035c7:	31 d2                	xor    %edx,%edx
  8035c9:	f7 f5                	div    %ebp
  8035cb:	89 c8                	mov    %ecx,%eax
  8035cd:	f7 f5                	div    %ebp
  8035cf:	89 d0                	mov    %edx,%eax
  8035d1:	e9 44 ff ff ff       	jmp    80351a <__umoddi3+0x3e>
  8035d6:	66 90                	xchg   %ax,%ax
  8035d8:	89 c8                	mov    %ecx,%eax
  8035da:	89 f2                	mov    %esi,%edx
  8035dc:	83 c4 1c             	add    $0x1c,%esp
  8035df:	5b                   	pop    %ebx
  8035e0:	5e                   	pop    %esi
  8035e1:	5f                   	pop    %edi
  8035e2:	5d                   	pop    %ebp
  8035e3:	c3                   	ret    
  8035e4:	3b 04 24             	cmp    (%esp),%eax
  8035e7:	72 06                	jb     8035ef <__umoddi3+0x113>
  8035e9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8035ed:	77 0f                	ja     8035fe <__umoddi3+0x122>
  8035ef:	89 f2                	mov    %esi,%edx
  8035f1:	29 f9                	sub    %edi,%ecx
  8035f3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8035f7:	89 14 24             	mov    %edx,(%esp)
  8035fa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8035fe:	8b 44 24 04          	mov    0x4(%esp),%eax
  803602:	8b 14 24             	mov    (%esp),%edx
  803605:	83 c4 1c             	add    $0x1c,%esp
  803608:	5b                   	pop    %ebx
  803609:	5e                   	pop    %esi
  80360a:	5f                   	pop    %edi
  80360b:	5d                   	pop    %ebp
  80360c:	c3                   	ret    
  80360d:	8d 76 00             	lea    0x0(%esi),%esi
  803610:	2b 04 24             	sub    (%esp),%eax
  803613:	19 fa                	sbb    %edi,%edx
  803615:	89 d1                	mov    %edx,%ecx
  803617:	89 c6                	mov    %eax,%esi
  803619:	e9 71 ff ff ff       	jmp    80358f <__umoddi3+0xb3>
  80361e:	66 90                	xchg   %ax,%ax
  803620:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803624:	72 ea                	jb     803610 <__umoddi3+0x134>
  803626:	89 d9                	mov    %ebx,%ecx
  803628:	e9 62 ff ff ff       	jmp    80358f <__umoddi3+0xb3>
