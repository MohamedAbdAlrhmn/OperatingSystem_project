
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
  80008c:	68 e0 37 80 00       	push   $0x8037e0
  800091:	6a 12                	push   $0x12
  800093:	68 fc 37 80 00       	push   $0x8037fc
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
  8000aa:	e8 33 1b 00 00       	call   801be2 <sys_getparentenvid>
  8000af:	83 ec 08             	sub    $0x8,%esp
  8000b2:	68 19 38 80 00       	push   $0x803819
  8000b7:	50                   	push   %eax
  8000b8:	e8 08 16 00 00       	call   8016c5 <sget>
  8000bd:	83 c4 10             	add    $0x10,%esp
  8000c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("Slave B1 env used x (getSharedObject)\n");
  8000c3:	83 ec 0c             	sub    $0xc,%esp
  8000c6:	68 1c 38 80 00       	push   $0x80381c
  8000cb:	e8 74 04 00 00       	call   800544 <cprintf>
  8000d0:	83 c4 10             	add    $0x10,%esp
	//To indicate that it's successfully got x
	inctst();
  8000d3:	e8 2f 1c 00 00       	call   801d07 <inctst>
	cprintf("Slave B1 please be patient ...\n");
  8000d8:	83 ec 0c             	sub    $0xc,%esp
  8000db:	68 44 38 80 00       	push   $0x803844
  8000e0:	e8 5f 04 00 00       	call   800544 <cprintf>
  8000e5:	83 c4 10             	add    $0x10,%esp

	//sleep a while to allow the master to remove x & z
	env_sleep(6000);
  8000e8:	83 ec 0c             	sub    $0xc,%esp
  8000eb:	68 70 17 00 00       	push   $0x1770
  8000f0:	e8 b6 33 00 00       	call   8034ab <env_sleep>
  8000f5:	83 c4 10             	add    $0x10,%esp

	int freeFrames = sys_calculate_free_frames() ;
  8000f8:	e8 ec 17 00 00       	call   8018e9 <sys_calculate_free_frames>
  8000fd:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sfree(x);
  800100:	83 ec 0c             	sub    $0xc,%esp
  800103:	ff 75 ec             	pushl  -0x14(%ebp)
  800106:	e8 7e 16 00 00       	call   801789 <sfree>
  80010b:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave B1 env removed x\n");
  80010e:	83 ec 0c             	sub    $0xc,%esp
  800111:	68 64 38 80 00       	push   $0x803864
  800116:	e8 29 04 00 00       	call   800544 <cprintf>
  80011b:	83 c4 10             	add    $0x10,%esp
	int expected = (1+1) + (1+1);
  80011e:	c7 45 e4 04 00 00 00 	movl   $0x4,-0x1c(%ebp)
	if ((sys_calculate_free_frames() - freeFrames) !=  expected) panic("B1 wrong free: frames removed not equal 4 !, correct frames to be removed are 4:\nfrom the env: 1 table and 1 for frame of x\nframes_storage of x: should be cleared now\n");
  800125:	e8 bf 17 00 00       	call   8018e9 <sys_calculate_free_frames>
  80012a:	89 c2                	mov    %eax,%edx
  80012c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80012f:	29 c2                	sub    %eax,%edx
  800131:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800134:	39 c2                	cmp    %eax,%edx
  800136:	74 14                	je     80014c <_main+0x114>
  800138:	83 ec 04             	sub    $0x4,%esp
  80013b:	68 7c 38 80 00       	push   $0x80387c
  800140:	6a 27                	push   $0x27
  800142:	68 fc 37 80 00       	push   $0x8037fc
  800147:	e8 44 01 00 00       	call   800290 <_panic>

	//To indicate that it's completed successfully
	inctst();
  80014c:	e8 b6 1b 00 00       	call   801d07 <inctst>
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
  80015a:	e8 6a 1a 00 00       	call   801bc9 <sys_getenvindex>
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
  8001c5:	e8 0c 18 00 00       	call   8019d6 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001ca:	83 ec 0c             	sub    $0xc,%esp
  8001cd:	68 3c 39 80 00       	push   $0x80393c
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
  8001f5:	68 64 39 80 00       	push   $0x803964
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
  800226:	68 8c 39 80 00       	push   $0x80398c
  80022b:	e8 14 03 00 00       	call   800544 <cprintf>
  800230:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800233:	a1 20 50 80 00       	mov    0x805020,%eax
  800238:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80023e:	83 ec 08             	sub    $0x8,%esp
  800241:	50                   	push   %eax
  800242:	68 e4 39 80 00       	push   $0x8039e4
  800247:	e8 f8 02 00 00       	call   800544 <cprintf>
  80024c:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80024f:	83 ec 0c             	sub    $0xc,%esp
  800252:	68 3c 39 80 00       	push   $0x80393c
  800257:	e8 e8 02 00 00       	call   800544 <cprintf>
  80025c:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80025f:	e8 8c 17 00 00       	call   8019f0 <sys_enable_interrupt>

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
  800277:	e8 19 19 00 00       	call   801b95 <sys_destroy_env>
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
  800288:	e8 6e 19 00 00       	call   801bfb <sys_exit_env>
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
  8002b1:	68 f8 39 80 00       	push   $0x8039f8
  8002b6:	e8 89 02 00 00       	call   800544 <cprintf>
  8002bb:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002be:	a1 00 50 80 00       	mov    0x805000,%eax
  8002c3:	ff 75 0c             	pushl  0xc(%ebp)
  8002c6:	ff 75 08             	pushl  0x8(%ebp)
  8002c9:	50                   	push   %eax
  8002ca:	68 fd 39 80 00       	push   $0x8039fd
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
  8002ee:	68 19 3a 80 00       	push   $0x803a19
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
  80031a:	68 1c 3a 80 00       	push   $0x803a1c
  80031f:	6a 26                	push   $0x26
  800321:	68 68 3a 80 00       	push   $0x803a68
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
  8003ec:	68 74 3a 80 00       	push   $0x803a74
  8003f1:	6a 3a                	push   $0x3a
  8003f3:	68 68 3a 80 00       	push   $0x803a68
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
  80045c:	68 c8 3a 80 00       	push   $0x803ac8
  800461:	6a 44                	push   $0x44
  800463:	68 68 3a 80 00       	push   $0x803a68
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
  8004b6:	e8 6d 13 00 00       	call   801828 <sys_cputs>
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
  80052d:	e8 f6 12 00 00       	call   801828 <sys_cputs>
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
  800577:	e8 5a 14 00 00       	call   8019d6 <sys_disable_interrupt>
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
  800597:	e8 54 14 00 00       	call   8019f0 <sys_enable_interrupt>
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
  8005e1:	e8 7a 2f 00 00       	call   803560 <__udivdi3>
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
  800631:	e8 3a 30 00 00       	call   803670 <__umoddi3>
  800636:	83 c4 10             	add    $0x10,%esp
  800639:	05 34 3d 80 00       	add    $0x803d34,%eax
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
  80078c:	8b 04 85 58 3d 80 00 	mov    0x803d58(,%eax,4),%eax
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
  80086d:	8b 34 9d a0 3b 80 00 	mov    0x803ba0(,%ebx,4),%esi
  800874:	85 f6                	test   %esi,%esi
  800876:	75 19                	jne    800891 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800878:	53                   	push   %ebx
  800879:	68 45 3d 80 00       	push   $0x803d45
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
  800892:	68 4e 3d 80 00       	push   $0x803d4e
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
  8008bf:	be 51 3d 80 00       	mov    $0x803d51,%esi
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
  8012e5:	68 b0 3e 80 00       	push   $0x803eb0
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
  8013b5:	e8 b2 05 00 00       	call   80196c <sys_allocate_chunk>
  8013ba:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013bd:	a1 20 51 80 00       	mov    0x805120,%eax
  8013c2:	83 ec 0c             	sub    $0xc,%esp
  8013c5:	50                   	push   %eax
  8013c6:	e8 27 0c 00 00       	call   801ff2 <initialize_MemBlocksList>
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
  8013f3:	68 d5 3e 80 00       	push   $0x803ed5
  8013f8:	6a 33                	push   $0x33
  8013fa:	68 f3 3e 80 00       	push   $0x803ef3
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
  801472:	68 00 3f 80 00       	push   $0x803f00
  801477:	6a 34                	push   $0x34
  801479:	68 f3 3e 80 00       	push   $0x803ef3
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
  80150a:	e8 2b 08 00 00       	call   801d3a <sys_isUHeapPlacementStrategyFIRSTFIT>
  80150f:	85 c0                	test   %eax,%eax
  801511:	74 11                	je     801524 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801513:	83 ec 0c             	sub    $0xc,%esp
  801516:	ff 75 e8             	pushl  -0x18(%ebp)
  801519:	e8 96 0e 00 00       	call   8023b4 <alloc_block_FF>
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
  801530:	e8 f2 0b 00 00       	call   802127 <insert_sorted_allocList>
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
  80154a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	struct MemBlock * free_block=find_block(&AllocMemBlocksList,(uint32)virtual_address);
  80154d:	8b 45 08             	mov    0x8(%ebp),%eax
  801550:	83 ec 08             	sub    $0x8,%esp
  801553:	50                   	push   %eax
  801554:	68 40 50 80 00       	push   $0x805040
  801559:	e8 71 0b 00 00       	call   8020cf <find_block>
  80155e:	83 c4 10             	add    $0x10,%esp
  801561:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(free_block!=NULL)
  801564:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801568:	0f 84 a6 00 00 00    	je     801614 <free+0xcd>
	{
		sys_free_user_mem(free_block->sva,free_block->size);
  80156e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801571:	8b 50 0c             	mov    0xc(%eax),%edx
  801574:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801577:	8b 40 08             	mov    0x8(%eax),%eax
  80157a:	83 ec 08             	sub    $0x8,%esp
  80157d:	52                   	push   %edx
  80157e:	50                   	push   %eax
  80157f:	e8 b0 03 00 00       	call   801934 <sys_free_user_mem>
  801584:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,free_block);
  801587:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80158b:	75 14                	jne    8015a1 <free+0x5a>
  80158d:	83 ec 04             	sub    $0x4,%esp
  801590:	68 d5 3e 80 00       	push   $0x803ed5
  801595:	6a 74                	push   $0x74
  801597:	68 f3 3e 80 00       	push   $0x803ef3
  80159c:	e8 ef ec ff ff       	call   800290 <_panic>
  8015a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015a4:	8b 00                	mov    (%eax),%eax
  8015a6:	85 c0                	test   %eax,%eax
  8015a8:	74 10                	je     8015ba <free+0x73>
  8015aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015ad:	8b 00                	mov    (%eax),%eax
  8015af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015b2:	8b 52 04             	mov    0x4(%edx),%edx
  8015b5:	89 50 04             	mov    %edx,0x4(%eax)
  8015b8:	eb 0b                	jmp    8015c5 <free+0x7e>
  8015ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015bd:	8b 40 04             	mov    0x4(%eax),%eax
  8015c0:	a3 44 50 80 00       	mov    %eax,0x805044
  8015c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015c8:	8b 40 04             	mov    0x4(%eax),%eax
  8015cb:	85 c0                	test   %eax,%eax
  8015cd:	74 0f                	je     8015de <free+0x97>
  8015cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015d2:	8b 40 04             	mov    0x4(%eax),%eax
  8015d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015d8:	8b 12                	mov    (%edx),%edx
  8015da:	89 10                	mov    %edx,(%eax)
  8015dc:	eb 0a                	jmp    8015e8 <free+0xa1>
  8015de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015e1:	8b 00                	mov    (%eax),%eax
  8015e3:	a3 40 50 80 00       	mov    %eax,0x805040
  8015e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015eb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8015f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015f4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8015fb:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801600:	48                   	dec    %eax
  801601:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(free_block);
  801606:	83 ec 0c             	sub    $0xc,%esp
  801609:	ff 75 f4             	pushl  -0xc(%ebp)
  80160c:	e8 4e 17 00 00       	call   802d5f <insert_sorted_with_merge_freeList>
  801611:	83 c4 10             	add    $0x10,%esp
	}

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801614:	90                   	nop
  801615:	c9                   	leave  
  801616:	c3                   	ret    

00801617 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801617:	55                   	push   %ebp
  801618:	89 e5                	mov    %esp,%ebp
  80161a:	83 ec 38             	sub    $0x38,%esp
  80161d:	8b 45 10             	mov    0x10(%ebp),%eax
  801620:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801623:	e8 a6 fc ff ff       	call   8012ce <InitializeUHeap>
	if (size == 0) return NULL ;
  801628:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80162c:	75 0a                	jne    801638 <smalloc+0x21>
  80162e:	b8 00 00 00 00       	mov    $0x0,%eax
  801633:	e9 8b 00 00 00       	jmp    8016c3 <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801638:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80163f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801642:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801645:	01 d0                	add    %edx,%eax
  801647:	48                   	dec    %eax
  801648:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80164b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80164e:	ba 00 00 00 00       	mov    $0x0,%edx
  801653:	f7 75 f0             	divl   -0x10(%ebp)
  801656:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801659:	29 d0                	sub    %edx,%eax
  80165b:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  80165e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801665:	e8 d0 06 00 00       	call   801d3a <sys_isUHeapPlacementStrategyFIRSTFIT>
  80166a:	85 c0                	test   %eax,%eax
  80166c:	74 11                	je     80167f <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  80166e:	83 ec 0c             	sub    $0xc,%esp
  801671:	ff 75 e8             	pushl  -0x18(%ebp)
  801674:	e8 3b 0d 00 00       	call   8023b4 <alloc_block_FF>
  801679:	83 c4 10             	add    $0x10,%esp
  80167c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  80167f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801683:	74 39                	je     8016be <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801685:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801688:	8b 40 08             	mov    0x8(%eax),%eax
  80168b:	89 c2                	mov    %eax,%edx
  80168d:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801691:	52                   	push   %edx
  801692:	50                   	push   %eax
  801693:	ff 75 0c             	pushl  0xc(%ebp)
  801696:	ff 75 08             	pushl  0x8(%ebp)
  801699:	e8 21 04 00 00       	call   801abf <sys_createSharedObject>
  80169e:	83 c4 10             	add    $0x10,%esp
  8016a1:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  8016a4:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  8016a8:	74 14                	je     8016be <smalloc+0xa7>
  8016aa:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  8016ae:	74 0e                	je     8016be <smalloc+0xa7>
  8016b0:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  8016b4:	74 08                	je     8016be <smalloc+0xa7>
			return (void*) mem_block->sva;
  8016b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016b9:	8b 40 08             	mov    0x8(%eax),%eax
  8016bc:	eb 05                	jmp    8016c3 <smalloc+0xac>
	}
	return NULL;
  8016be:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8016c3:	c9                   	leave  
  8016c4:	c3                   	ret    

008016c5 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8016c5:	55                   	push   %ebp
  8016c6:	89 e5                	mov    %esp,%ebp
  8016c8:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016cb:	e8 fe fb ff ff       	call   8012ce <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8016d0:	83 ec 08             	sub    $0x8,%esp
  8016d3:	ff 75 0c             	pushl  0xc(%ebp)
  8016d6:	ff 75 08             	pushl  0x8(%ebp)
  8016d9:	e8 0b 04 00 00       	call   801ae9 <sys_getSizeOfSharedObject>
  8016de:	83 c4 10             	add    $0x10,%esp
  8016e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  8016e4:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  8016e8:	74 76                	je     801760 <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  8016ea:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8016f1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016f7:	01 d0                	add    %edx,%eax
  8016f9:	48                   	dec    %eax
  8016fa:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8016fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801700:	ba 00 00 00 00       	mov    $0x0,%edx
  801705:	f7 75 ec             	divl   -0x14(%ebp)
  801708:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80170b:	29 d0                	sub    %edx,%eax
  80170d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  801710:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801717:	e8 1e 06 00 00       	call   801d3a <sys_isUHeapPlacementStrategyFIRSTFIT>
  80171c:	85 c0                	test   %eax,%eax
  80171e:	74 11                	je     801731 <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  801720:	83 ec 0c             	sub    $0xc,%esp
  801723:	ff 75 e4             	pushl  -0x1c(%ebp)
  801726:	e8 89 0c 00 00       	call   8023b4 <alloc_block_FF>
  80172b:	83 c4 10             	add    $0x10,%esp
  80172e:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  801731:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801735:	74 29                	je     801760 <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  801737:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80173a:	8b 40 08             	mov    0x8(%eax),%eax
  80173d:	83 ec 04             	sub    $0x4,%esp
  801740:	50                   	push   %eax
  801741:	ff 75 0c             	pushl  0xc(%ebp)
  801744:	ff 75 08             	pushl  0x8(%ebp)
  801747:	e8 ba 03 00 00       	call   801b06 <sys_getSharedObject>
  80174c:	83 c4 10             	add    $0x10,%esp
  80174f:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  801752:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  801756:	74 08                	je     801760 <sget+0x9b>
				return (void *)mem_block->sva;
  801758:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80175b:	8b 40 08             	mov    0x8(%eax),%eax
  80175e:	eb 05                	jmp    801765 <sget+0xa0>
		}
	}
	return NULL;
  801760:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801765:	c9                   	leave  
  801766:	c3                   	ret    

00801767 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801767:	55                   	push   %ebp
  801768:	89 e5                	mov    %esp,%ebp
  80176a:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80176d:	e8 5c fb ff ff       	call   8012ce <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801772:	83 ec 04             	sub    $0x4,%esp
  801775:	68 24 3f 80 00       	push   $0x803f24
  80177a:	68 f7 00 00 00       	push   $0xf7
  80177f:	68 f3 3e 80 00       	push   $0x803ef3
  801784:	e8 07 eb ff ff       	call   800290 <_panic>

00801789 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801789:	55                   	push   %ebp
  80178a:	89 e5                	mov    %esp,%ebp
  80178c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()


	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80178f:	83 ec 04             	sub    $0x4,%esp
  801792:	68 4c 3f 80 00       	push   $0x803f4c
  801797:	68 0c 01 00 00       	push   $0x10c
  80179c:	68 f3 3e 80 00       	push   $0x803ef3
  8017a1:	e8 ea ea ff ff       	call   800290 <_panic>

008017a6 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8017a6:	55                   	push   %ebp
  8017a7:	89 e5                	mov    %esp,%ebp
  8017a9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017ac:	83 ec 04             	sub    $0x4,%esp
  8017af:	68 70 3f 80 00       	push   $0x803f70
  8017b4:	68 44 01 00 00       	push   $0x144
  8017b9:	68 f3 3e 80 00       	push   $0x803ef3
  8017be:	e8 cd ea ff ff       	call   800290 <_panic>

008017c3 <shrink>:

}
void shrink(uint32 newSize)
{
  8017c3:	55                   	push   %ebp
  8017c4:	89 e5                	mov    %esp,%ebp
  8017c6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017c9:	83 ec 04             	sub    $0x4,%esp
  8017cc:	68 70 3f 80 00       	push   $0x803f70
  8017d1:	68 49 01 00 00       	push   $0x149
  8017d6:	68 f3 3e 80 00       	push   $0x803ef3
  8017db:	e8 b0 ea ff ff       	call   800290 <_panic>

008017e0 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8017e0:	55                   	push   %ebp
  8017e1:	89 e5                	mov    %esp,%ebp
  8017e3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017e6:	83 ec 04             	sub    $0x4,%esp
  8017e9:	68 70 3f 80 00       	push   $0x803f70
  8017ee:	68 4e 01 00 00       	push   $0x14e
  8017f3:	68 f3 3e 80 00       	push   $0x803ef3
  8017f8:	e8 93 ea ff ff       	call   800290 <_panic>

008017fd <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8017fd:	55                   	push   %ebp
  8017fe:	89 e5                	mov    %esp,%ebp
  801800:	57                   	push   %edi
  801801:	56                   	push   %esi
  801802:	53                   	push   %ebx
  801803:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801806:	8b 45 08             	mov    0x8(%ebp),%eax
  801809:	8b 55 0c             	mov    0xc(%ebp),%edx
  80180c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80180f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801812:	8b 7d 18             	mov    0x18(%ebp),%edi
  801815:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801818:	cd 30                	int    $0x30
  80181a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80181d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801820:	83 c4 10             	add    $0x10,%esp
  801823:	5b                   	pop    %ebx
  801824:	5e                   	pop    %esi
  801825:	5f                   	pop    %edi
  801826:	5d                   	pop    %ebp
  801827:	c3                   	ret    

00801828 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801828:	55                   	push   %ebp
  801829:	89 e5                	mov    %esp,%ebp
  80182b:	83 ec 04             	sub    $0x4,%esp
  80182e:	8b 45 10             	mov    0x10(%ebp),%eax
  801831:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801834:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801838:	8b 45 08             	mov    0x8(%ebp),%eax
  80183b:	6a 00                	push   $0x0
  80183d:	6a 00                	push   $0x0
  80183f:	52                   	push   %edx
  801840:	ff 75 0c             	pushl  0xc(%ebp)
  801843:	50                   	push   %eax
  801844:	6a 00                	push   $0x0
  801846:	e8 b2 ff ff ff       	call   8017fd <syscall>
  80184b:	83 c4 18             	add    $0x18,%esp
}
  80184e:	90                   	nop
  80184f:	c9                   	leave  
  801850:	c3                   	ret    

00801851 <sys_cgetc>:

int
sys_cgetc(void)
{
  801851:	55                   	push   %ebp
  801852:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801854:	6a 00                	push   $0x0
  801856:	6a 00                	push   $0x0
  801858:	6a 00                	push   $0x0
  80185a:	6a 00                	push   $0x0
  80185c:	6a 00                	push   $0x0
  80185e:	6a 01                	push   $0x1
  801860:	e8 98 ff ff ff       	call   8017fd <syscall>
  801865:	83 c4 18             	add    $0x18,%esp
}
  801868:	c9                   	leave  
  801869:	c3                   	ret    

0080186a <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80186a:	55                   	push   %ebp
  80186b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80186d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801870:	8b 45 08             	mov    0x8(%ebp),%eax
  801873:	6a 00                	push   $0x0
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	52                   	push   %edx
  80187a:	50                   	push   %eax
  80187b:	6a 05                	push   $0x5
  80187d:	e8 7b ff ff ff       	call   8017fd <syscall>
  801882:	83 c4 18             	add    $0x18,%esp
}
  801885:	c9                   	leave  
  801886:	c3                   	ret    

00801887 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801887:	55                   	push   %ebp
  801888:	89 e5                	mov    %esp,%ebp
  80188a:	56                   	push   %esi
  80188b:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80188c:	8b 75 18             	mov    0x18(%ebp),%esi
  80188f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801892:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801895:	8b 55 0c             	mov    0xc(%ebp),%edx
  801898:	8b 45 08             	mov    0x8(%ebp),%eax
  80189b:	56                   	push   %esi
  80189c:	53                   	push   %ebx
  80189d:	51                   	push   %ecx
  80189e:	52                   	push   %edx
  80189f:	50                   	push   %eax
  8018a0:	6a 06                	push   $0x6
  8018a2:	e8 56 ff ff ff       	call   8017fd <syscall>
  8018a7:	83 c4 18             	add    $0x18,%esp
}
  8018aa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018ad:	5b                   	pop    %ebx
  8018ae:	5e                   	pop    %esi
  8018af:	5d                   	pop    %ebp
  8018b0:	c3                   	ret    

008018b1 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8018b1:	55                   	push   %ebp
  8018b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8018b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ba:	6a 00                	push   $0x0
  8018bc:	6a 00                	push   $0x0
  8018be:	6a 00                	push   $0x0
  8018c0:	52                   	push   %edx
  8018c1:	50                   	push   %eax
  8018c2:	6a 07                	push   $0x7
  8018c4:	e8 34 ff ff ff       	call   8017fd <syscall>
  8018c9:	83 c4 18             	add    $0x18,%esp
}
  8018cc:	c9                   	leave  
  8018cd:	c3                   	ret    

008018ce <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018ce:	55                   	push   %ebp
  8018cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018d1:	6a 00                	push   $0x0
  8018d3:	6a 00                	push   $0x0
  8018d5:	6a 00                	push   $0x0
  8018d7:	ff 75 0c             	pushl  0xc(%ebp)
  8018da:	ff 75 08             	pushl  0x8(%ebp)
  8018dd:	6a 08                	push   $0x8
  8018df:	e8 19 ff ff ff       	call   8017fd <syscall>
  8018e4:	83 c4 18             	add    $0x18,%esp
}
  8018e7:	c9                   	leave  
  8018e8:	c3                   	ret    

008018e9 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8018e9:	55                   	push   %ebp
  8018ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8018ec:	6a 00                	push   $0x0
  8018ee:	6a 00                	push   $0x0
  8018f0:	6a 00                	push   $0x0
  8018f2:	6a 00                	push   $0x0
  8018f4:	6a 00                	push   $0x0
  8018f6:	6a 09                	push   $0x9
  8018f8:	e8 00 ff ff ff       	call   8017fd <syscall>
  8018fd:	83 c4 18             	add    $0x18,%esp
}
  801900:	c9                   	leave  
  801901:	c3                   	ret    

00801902 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801902:	55                   	push   %ebp
  801903:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801905:	6a 00                	push   $0x0
  801907:	6a 00                	push   $0x0
  801909:	6a 00                	push   $0x0
  80190b:	6a 00                	push   $0x0
  80190d:	6a 00                	push   $0x0
  80190f:	6a 0a                	push   $0xa
  801911:	e8 e7 fe ff ff       	call   8017fd <syscall>
  801916:	83 c4 18             	add    $0x18,%esp
}
  801919:	c9                   	leave  
  80191a:	c3                   	ret    

0080191b <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80191b:	55                   	push   %ebp
  80191c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80191e:	6a 00                	push   $0x0
  801920:	6a 00                	push   $0x0
  801922:	6a 00                	push   $0x0
  801924:	6a 00                	push   $0x0
  801926:	6a 00                	push   $0x0
  801928:	6a 0b                	push   $0xb
  80192a:	e8 ce fe ff ff       	call   8017fd <syscall>
  80192f:	83 c4 18             	add    $0x18,%esp
}
  801932:	c9                   	leave  
  801933:	c3                   	ret    

00801934 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801934:	55                   	push   %ebp
  801935:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801937:	6a 00                	push   $0x0
  801939:	6a 00                	push   $0x0
  80193b:	6a 00                	push   $0x0
  80193d:	ff 75 0c             	pushl  0xc(%ebp)
  801940:	ff 75 08             	pushl  0x8(%ebp)
  801943:	6a 0f                	push   $0xf
  801945:	e8 b3 fe ff ff       	call   8017fd <syscall>
  80194a:	83 c4 18             	add    $0x18,%esp
	return;
  80194d:	90                   	nop
}
  80194e:	c9                   	leave  
  80194f:	c3                   	ret    

00801950 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801950:	55                   	push   %ebp
  801951:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801953:	6a 00                	push   $0x0
  801955:	6a 00                	push   $0x0
  801957:	6a 00                	push   $0x0
  801959:	ff 75 0c             	pushl  0xc(%ebp)
  80195c:	ff 75 08             	pushl  0x8(%ebp)
  80195f:	6a 10                	push   $0x10
  801961:	e8 97 fe ff ff       	call   8017fd <syscall>
  801966:	83 c4 18             	add    $0x18,%esp
	return ;
  801969:	90                   	nop
}
  80196a:	c9                   	leave  
  80196b:	c3                   	ret    

0080196c <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80196c:	55                   	push   %ebp
  80196d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80196f:	6a 00                	push   $0x0
  801971:	6a 00                	push   $0x0
  801973:	ff 75 10             	pushl  0x10(%ebp)
  801976:	ff 75 0c             	pushl  0xc(%ebp)
  801979:	ff 75 08             	pushl  0x8(%ebp)
  80197c:	6a 11                	push   $0x11
  80197e:	e8 7a fe ff ff       	call   8017fd <syscall>
  801983:	83 c4 18             	add    $0x18,%esp
	return ;
  801986:	90                   	nop
}
  801987:	c9                   	leave  
  801988:	c3                   	ret    

00801989 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801989:	55                   	push   %ebp
  80198a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80198c:	6a 00                	push   $0x0
  80198e:	6a 00                	push   $0x0
  801990:	6a 00                	push   $0x0
  801992:	6a 00                	push   $0x0
  801994:	6a 00                	push   $0x0
  801996:	6a 0c                	push   $0xc
  801998:	e8 60 fe ff ff       	call   8017fd <syscall>
  80199d:	83 c4 18             	add    $0x18,%esp
}
  8019a0:	c9                   	leave  
  8019a1:	c3                   	ret    

008019a2 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8019a2:	55                   	push   %ebp
  8019a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 00                	push   $0x0
  8019ab:	6a 00                	push   $0x0
  8019ad:	ff 75 08             	pushl  0x8(%ebp)
  8019b0:	6a 0d                	push   $0xd
  8019b2:	e8 46 fe ff ff       	call   8017fd <syscall>
  8019b7:	83 c4 18             	add    $0x18,%esp
}
  8019ba:	c9                   	leave  
  8019bb:	c3                   	ret    

008019bc <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019bc:	55                   	push   %ebp
  8019bd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 00                	push   $0x0
  8019c7:	6a 00                	push   $0x0
  8019c9:	6a 0e                	push   $0xe
  8019cb:	e8 2d fe ff ff       	call   8017fd <syscall>
  8019d0:	83 c4 18             	add    $0x18,%esp
}
  8019d3:	90                   	nop
  8019d4:	c9                   	leave  
  8019d5:	c3                   	ret    

008019d6 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8019d6:	55                   	push   %ebp
  8019d7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8019d9:	6a 00                	push   $0x0
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 13                	push   $0x13
  8019e5:	e8 13 fe ff ff       	call   8017fd <syscall>
  8019ea:	83 c4 18             	add    $0x18,%esp
}
  8019ed:	90                   	nop
  8019ee:	c9                   	leave  
  8019ef:	c3                   	ret    

008019f0 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8019f0:	55                   	push   %ebp
  8019f1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8019f3:	6a 00                	push   $0x0
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 00                	push   $0x0
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 00                	push   $0x0
  8019fd:	6a 14                	push   $0x14
  8019ff:	e8 f9 fd ff ff       	call   8017fd <syscall>
  801a04:	83 c4 18             	add    $0x18,%esp
}
  801a07:	90                   	nop
  801a08:	c9                   	leave  
  801a09:	c3                   	ret    

00801a0a <sys_cputc>:


void
sys_cputc(const char c)
{
  801a0a:	55                   	push   %ebp
  801a0b:	89 e5                	mov    %esp,%ebp
  801a0d:	83 ec 04             	sub    $0x4,%esp
  801a10:	8b 45 08             	mov    0x8(%ebp),%eax
  801a13:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a16:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a1a:	6a 00                	push   $0x0
  801a1c:	6a 00                	push   $0x0
  801a1e:	6a 00                	push   $0x0
  801a20:	6a 00                	push   $0x0
  801a22:	50                   	push   %eax
  801a23:	6a 15                	push   $0x15
  801a25:	e8 d3 fd ff ff       	call   8017fd <syscall>
  801a2a:	83 c4 18             	add    $0x18,%esp
}
  801a2d:	90                   	nop
  801a2e:	c9                   	leave  
  801a2f:	c3                   	ret    

00801a30 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a30:	55                   	push   %ebp
  801a31:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a33:	6a 00                	push   $0x0
  801a35:	6a 00                	push   $0x0
  801a37:	6a 00                	push   $0x0
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 16                	push   $0x16
  801a3f:	e8 b9 fd ff ff       	call   8017fd <syscall>
  801a44:	83 c4 18             	add    $0x18,%esp
}
  801a47:	90                   	nop
  801a48:	c9                   	leave  
  801a49:	c3                   	ret    

00801a4a <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a4a:	55                   	push   %ebp
  801a4b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a50:	6a 00                	push   $0x0
  801a52:	6a 00                	push   $0x0
  801a54:	6a 00                	push   $0x0
  801a56:	ff 75 0c             	pushl  0xc(%ebp)
  801a59:	50                   	push   %eax
  801a5a:	6a 17                	push   $0x17
  801a5c:	e8 9c fd ff ff       	call   8017fd <syscall>
  801a61:	83 c4 18             	add    $0x18,%esp
}
  801a64:	c9                   	leave  
  801a65:	c3                   	ret    

00801a66 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a66:	55                   	push   %ebp
  801a67:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a69:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 00                	push   $0x0
  801a73:	6a 00                	push   $0x0
  801a75:	52                   	push   %edx
  801a76:	50                   	push   %eax
  801a77:	6a 1a                	push   $0x1a
  801a79:	e8 7f fd ff ff       	call   8017fd <syscall>
  801a7e:	83 c4 18             	add    $0x18,%esp
}
  801a81:	c9                   	leave  
  801a82:	c3                   	ret    

00801a83 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a83:	55                   	push   %ebp
  801a84:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a86:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a89:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 00                	push   $0x0
  801a92:	52                   	push   %edx
  801a93:	50                   	push   %eax
  801a94:	6a 18                	push   $0x18
  801a96:	e8 62 fd ff ff       	call   8017fd <syscall>
  801a9b:	83 c4 18             	add    $0x18,%esp
}
  801a9e:	90                   	nop
  801a9f:	c9                   	leave  
  801aa0:	c3                   	ret    

00801aa1 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801aa1:	55                   	push   %ebp
  801aa2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801aa4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aa7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aaa:	6a 00                	push   $0x0
  801aac:	6a 00                	push   $0x0
  801aae:	6a 00                	push   $0x0
  801ab0:	52                   	push   %edx
  801ab1:	50                   	push   %eax
  801ab2:	6a 19                	push   $0x19
  801ab4:	e8 44 fd ff ff       	call   8017fd <syscall>
  801ab9:	83 c4 18             	add    $0x18,%esp
}
  801abc:	90                   	nop
  801abd:	c9                   	leave  
  801abe:	c3                   	ret    

00801abf <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801abf:	55                   	push   %ebp
  801ac0:	89 e5                	mov    %esp,%ebp
  801ac2:	83 ec 04             	sub    $0x4,%esp
  801ac5:	8b 45 10             	mov    0x10(%ebp),%eax
  801ac8:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801acb:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ace:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad5:	6a 00                	push   $0x0
  801ad7:	51                   	push   %ecx
  801ad8:	52                   	push   %edx
  801ad9:	ff 75 0c             	pushl  0xc(%ebp)
  801adc:	50                   	push   %eax
  801add:	6a 1b                	push   $0x1b
  801adf:	e8 19 fd ff ff       	call   8017fd <syscall>
  801ae4:	83 c4 18             	add    $0x18,%esp
}
  801ae7:	c9                   	leave  
  801ae8:	c3                   	ret    

00801ae9 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801ae9:	55                   	push   %ebp
  801aea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801aec:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aef:	8b 45 08             	mov    0x8(%ebp),%eax
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	52                   	push   %edx
  801af9:	50                   	push   %eax
  801afa:	6a 1c                	push   $0x1c
  801afc:	e8 fc fc ff ff       	call   8017fd <syscall>
  801b01:	83 c4 18             	add    $0x18,%esp
}
  801b04:	c9                   	leave  
  801b05:	c3                   	ret    

00801b06 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b06:	55                   	push   %ebp
  801b07:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b09:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b0c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b12:	6a 00                	push   $0x0
  801b14:	6a 00                	push   $0x0
  801b16:	51                   	push   %ecx
  801b17:	52                   	push   %edx
  801b18:	50                   	push   %eax
  801b19:	6a 1d                	push   $0x1d
  801b1b:	e8 dd fc ff ff       	call   8017fd <syscall>
  801b20:	83 c4 18             	add    $0x18,%esp
}
  801b23:	c9                   	leave  
  801b24:	c3                   	ret    

00801b25 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b25:	55                   	push   %ebp
  801b26:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b28:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2e:	6a 00                	push   $0x0
  801b30:	6a 00                	push   $0x0
  801b32:	6a 00                	push   $0x0
  801b34:	52                   	push   %edx
  801b35:	50                   	push   %eax
  801b36:	6a 1e                	push   $0x1e
  801b38:	e8 c0 fc ff ff       	call   8017fd <syscall>
  801b3d:	83 c4 18             	add    $0x18,%esp
}
  801b40:	c9                   	leave  
  801b41:	c3                   	ret    

00801b42 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b42:	55                   	push   %ebp
  801b43:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b45:	6a 00                	push   $0x0
  801b47:	6a 00                	push   $0x0
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 00                	push   $0x0
  801b4f:	6a 1f                	push   $0x1f
  801b51:	e8 a7 fc ff ff       	call   8017fd <syscall>
  801b56:	83 c4 18             	add    $0x18,%esp
}
  801b59:	c9                   	leave  
  801b5a:	c3                   	ret    

00801b5b <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b5b:	55                   	push   %ebp
  801b5c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b61:	6a 00                	push   $0x0
  801b63:	ff 75 14             	pushl  0x14(%ebp)
  801b66:	ff 75 10             	pushl  0x10(%ebp)
  801b69:	ff 75 0c             	pushl  0xc(%ebp)
  801b6c:	50                   	push   %eax
  801b6d:	6a 20                	push   $0x20
  801b6f:	e8 89 fc ff ff       	call   8017fd <syscall>
  801b74:	83 c4 18             	add    $0x18,%esp
}
  801b77:	c9                   	leave  
  801b78:	c3                   	ret    

00801b79 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801b79:	55                   	push   %ebp
  801b7a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 00                	push   $0x0
  801b83:	6a 00                	push   $0x0
  801b85:	6a 00                	push   $0x0
  801b87:	50                   	push   %eax
  801b88:	6a 21                	push   $0x21
  801b8a:	e8 6e fc ff ff       	call   8017fd <syscall>
  801b8f:	83 c4 18             	add    $0x18,%esp
}
  801b92:	90                   	nop
  801b93:	c9                   	leave  
  801b94:	c3                   	ret    

00801b95 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b95:	55                   	push   %ebp
  801b96:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b98:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 00                	push   $0x0
  801b9f:	6a 00                	push   $0x0
  801ba1:	6a 00                	push   $0x0
  801ba3:	50                   	push   %eax
  801ba4:	6a 22                	push   $0x22
  801ba6:	e8 52 fc ff ff       	call   8017fd <syscall>
  801bab:	83 c4 18             	add    $0x18,%esp
}
  801bae:	c9                   	leave  
  801baf:	c3                   	ret    

00801bb0 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801bb0:	55                   	push   %ebp
  801bb1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801bb3:	6a 00                	push   $0x0
  801bb5:	6a 00                	push   $0x0
  801bb7:	6a 00                	push   $0x0
  801bb9:	6a 00                	push   $0x0
  801bbb:	6a 00                	push   $0x0
  801bbd:	6a 02                	push   $0x2
  801bbf:	e8 39 fc ff ff       	call   8017fd <syscall>
  801bc4:	83 c4 18             	add    $0x18,%esp
}
  801bc7:	c9                   	leave  
  801bc8:	c3                   	ret    

00801bc9 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801bc9:	55                   	push   %ebp
  801bca:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 03                	push   $0x3
  801bd8:	e8 20 fc ff ff       	call   8017fd <syscall>
  801bdd:	83 c4 18             	add    $0x18,%esp
}
  801be0:	c9                   	leave  
  801be1:	c3                   	ret    

00801be2 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801be2:	55                   	push   %ebp
  801be3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801be5:	6a 00                	push   $0x0
  801be7:	6a 00                	push   $0x0
  801be9:	6a 00                	push   $0x0
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	6a 04                	push   $0x4
  801bf1:	e8 07 fc ff ff       	call   8017fd <syscall>
  801bf6:	83 c4 18             	add    $0x18,%esp
}
  801bf9:	c9                   	leave  
  801bfa:	c3                   	ret    

00801bfb <sys_exit_env>:


void sys_exit_env(void)
{
  801bfb:	55                   	push   %ebp
  801bfc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	6a 00                	push   $0x0
  801c04:	6a 00                	push   $0x0
  801c06:	6a 00                	push   $0x0
  801c08:	6a 23                	push   $0x23
  801c0a:	e8 ee fb ff ff       	call   8017fd <syscall>
  801c0f:	83 c4 18             	add    $0x18,%esp
}
  801c12:	90                   	nop
  801c13:	c9                   	leave  
  801c14:	c3                   	ret    

00801c15 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c15:	55                   	push   %ebp
  801c16:	89 e5                	mov    %esp,%ebp
  801c18:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c1b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c1e:	8d 50 04             	lea    0x4(%eax),%edx
  801c21:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c24:	6a 00                	push   $0x0
  801c26:	6a 00                	push   $0x0
  801c28:	6a 00                	push   $0x0
  801c2a:	52                   	push   %edx
  801c2b:	50                   	push   %eax
  801c2c:	6a 24                	push   $0x24
  801c2e:	e8 ca fb ff ff       	call   8017fd <syscall>
  801c33:	83 c4 18             	add    $0x18,%esp
	return result;
  801c36:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c39:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c3c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c3f:	89 01                	mov    %eax,(%ecx)
  801c41:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c44:	8b 45 08             	mov    0x8(%ebp),%eax
  801c47:	c9                   	leave  
  801c48:	c2 04 00             	ret    $0x4

00801c4b <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c4b:	55                   	push   %ebp
  801c4c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 00                	push   $0x0
  801c52:	ff 75 10             	pushl  0x10(%ebp)
  801c55:	ff 75 0c             	pushl  0xc(%ebp)
  801c58:	ff 75 08             	pushl  0x8(%ebp)
  801c5b:	6a 12                	push   $0x12
  801c5d:	e8 9b fb ff ff       	call   8017fd <syscall>
  801c62:	83 c4 18             	add    $0x18,%esp
	return ;
  801c65:	90                   	nop
}
  801c66:	c9                   	leave  
  801c67:	c3                   	ret    

00801c68 <sys_rcr2>:
uint32 sys_rcr2()
{
  801c68:	55                   	push   %ebp
  801c69:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 00                	push   $0x0
  801c71:	6a 00                	push   $0x0
  801c73:	6a 00                	push   $0x0
  801c75:	6a 25                	push   $0x25
  801c77:	e8 81 fb ff ff       	call   8017fd <syscall>
  801c7c:	83 c4 18             	add    $0x18,%esp
}
  801c7f:	c9                   	leave  
  801c80:	c3                   	ret    

00801c81 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801c81:	55                   	push   %ebp
  801c82:	89 e5                	mov    %esp,%ebp
  801c84:	83 ec 04             	sub    $0x4,%esp
  801c87:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c8d:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c91:	6a 00                	push   $0x0
  801c93:	6a 00                	push   $0x0
  801c95:	6a 00                	push   $0x0
  801c97:	6a 00                	push   $0x0
  801c99:	50                   	push   %eax
  801c9a:	6a 26                	push   $0x26
  801c9c:	e8 5c fb ff ff       	call   8017fd <syscall>
  801ca1:	83 c4 18             	add    $0x18,%esp
	return ;
  801ca4:	90                   	nop
}
  801ca5:	c9                   	leave  
  801ca6:	c3                   	ret    

00801ca7 <rsttst>:
void rsttst()
{
  801ca7:	55                   	push   %ebp
  801ca8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801caa:	6a 00                	push   $0x0
  801cac:	6a 00                	push   $0x0
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 00                	push   $0x0
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 28                	push   $0x28
  801cb6:	e8 42 fb ff ff       	call   8017fd <syscall>
  801cbb:	83 c4 18             	add    $0x18,%esp
	return ;
  801cbe:	90                   	nop
}
  801cbf:	c9                   	leave  
  801cc0:	c3                   	ret    

00801cc1 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801cc1:	55                   	push   %ebp
  801cc2:	89 e5                	mov    %esp,%ebp
  801cc4:	83 ec 04             	sub    $0x4,%esp
  801cc7:	8b 45 14             	mov    0x14(%ebp),%eax
  801cca:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ccd:	8b 55 18             	mov    0x18(%ebp),%edx
  801cd0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cd4:	52                   	push   %edx
  801cd5:	50                   	push   %eax
  801cd6:	ff 75 10             	pushl  0x10(%ebp)
  801cd9:	ff 75 0c             	pushl  0xc(%ebp)
  801cdc:	ff 75 08             	pushl  0x8(%ebp)
  801cdf:	6a 27                	push   $0x27
  801ce1:	e8 17 fb ff ff       	call   8017fd <syscall>
  801ce6:	83 c4 18             	add    $0x18,%esp
	return ;
  801ce9:	90                   	nop
}
  801cea:	c9                   	leave  
  801ceb:	c3                   	ret    

00801cec <chktst>:
void chktst(uint32 n)
{
  801cec:	55                   	push   %ebp
  801ced:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801cef:	6a 00                	push   $0x0
  801cf1:	6a 00                	push   $0x0
  801cf3:	6a 00                	push   $0x0
  801cf5:	6a 00                	push   $0x0
  801cf7:	ff 75 08             	pushl  0x8(%ebp)
  801cfa:	6a 29                	push   $0x29
  801cfc:	e8 fc fa ff ff       	call   8017fd <syscall>
  801d01:	83 c4 18             	add    $0x18,%esp
	return ;
  801d04:	90                   	nop
}
  801d05:	c9                   	leave  
  801d06:	c3                   	ret    

00801d07 <inctst>:

void inctst()
{
  801d07:	55                   	push   %ebp
  801d08:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d0a:	6a 00                	push   $0x0
  801d0c:	6a 00                	push   $0x0
  801d0e:	6a 00                	push   $0x0
  801d10:	6a 00                	push   $0x0
  801d12:	6a 00                	push   $0x0
  801d14:	6a 2a                	push   $0x2a
  801d16:	e8 e2 fa ff ff       	call   8017fd <syscall>
  801d1b:	83 c4 18             	add    $0x18,%esp
	return ;
  801d1e:	90                   	nop
}
  801d1f:	c9                   	leave  
  801d20:	c3                   	ret    

00801d21 <gettst>:
uint32 gettst()
{
  801d21:	55                   	push   %ebp
  801d22:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d24:	6a 00                	push   $0x0
  801d26:	6a 00                	push   $0x0
  801d28:	6a 00                	push   $0x0
  801d2a:	6a 00                	push   $0x0
  801d2c:	6a 00                	push   $0x0
  801d2e:	6a 2b                	push   $0x2b
  801d30:	e8 c8 fa ff ff       	call   8017fd <syscall>
  801d35:	83 c4 18             	add    $0x18,%esp
}
  801d38:	c9                   	leave  
  801d39:	c3                   	ret    

00801d3a <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d3a:	55                   	push   %ebp
  801d3b:	89 e5                	mov    %esp,%ebp
  801d3d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d40:	6a 00                	push   $0x0
  801d42:	6a 00                	push   $0x0
  801d44:	6a 00                	push   $0x0
  801d46:	6a 00                	push   $0x0
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 2c                	push   $0x2c
  801d4c:	e8 ac fa ff ff       	call   8017fd <syscall>
  801d51:	83 c4 18             	add    $0x18,%esp
  801d54:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d57:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d5b:	75 07                	jne    801d64 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d5d:	b8 01 00 00 00       	mov    $0x1,%eax
  801d62:	eb 05                	jmp    801d69 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d64:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d69:	c9                   	leave  
  801d6a:	c3                   	ret    

00801d6b <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d6b:	55                   	push   %ebp
  801d6c:	89 e5                	mov    %esp,%ebp
  801d6e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d71:	6a 00                	push   $0x0
  801d73:	6a 00                	push   $0x0
  801d75:	6a 00                	push   $0x0
  801d77:	6a 00                	push   $0x0
  801d79:	6a 00                	push   $0x0
  801d7b:	6a 2c                	push   $0x2c
  801d7d:	e8 7b fa ff ff       	call   8017fd <syscall>
  801d82:	83 c4 18             	add    $0x18,%esp
  801d85:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d88:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d8c:	75 07                	jne    801d95 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d8e:	b8 01 00 00 00       	mov    $0x1,%eax
  801d93:	eb 05                	jmp    801d9a <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d95:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d9a:	c9                   	leave  
  801d9b:	c3                   	ret    

00801d9c <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d9c:	55                   	push   %ebp
  801d9d:	89 e5                	mov    %esp,%ebp
  801d9f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801da2:	6a 00                	push   $0x0
  801da4:	6a 00                	push   $0x0
  801da6:	6a 00                	push   $0x0
  801da8:	6a 00                	push   $0x0
  801daa:	6a 00                	push   $0x0
  801dac:	6a 2c                	push   $0x2c
  801dae:	e8 4a fa ff ff       	call   8017fd <syscall>
  801db3:	83 c4 18             	add    $0x18,%esp
  801db6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801db9:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801dbd:	75 07                	jne    801dc6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801dbf:	b8 01 00 00 00       	mov    $0x1,%eax
  801dc4:	eb 05                	jmp    801dcb <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801dc6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dcb:	c9                   	leave  
  801dcc:	c3                   	ret    

00801dcd <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801dcd:	55                   	push   %ebp
  801dce:	89 e5                	mov    %esp,%ebp
  801dd0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dd3:	6a 00                	push   $0x0
  801dd5:	6a 00                	push   $0x0
  801dd7:	6a 00                	push   $0x0
  801dd9:	6a 00                	push   $0x0
  801ddb:	6a 00                	push   $0x0
  801ddd:	6a 2c                	push   $0x2c
  801ddf:	e8 19 fa ff ff       	call   8017fd <syscall>
  801de4:	83 c4 18             	add    $0x18,%esp
  801de7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801dea:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801dee:	75 07                	jne    801df7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801df0:	b8 01 00 00 00       	mov    $0x1,%eax
  801df5:	eb 05                	jmp    801dfc <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801df7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dfc:	c9                   	leave  
  801dfd:	c3                   	ret    

00801dfe <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801dfe:	55                   	push   %ebp
  801dff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e01:	6a 00                	push   $0x0
  801e03:	6a 00                	push   $0x0
  801e05:	6a 00                	push   $0x0
  801e07:	6a 00                	push   $0x0
  801e09:	ff 75 08             	pushl  0x8(%ebp)
  801e0c:	6a 2d                	push   $0x2d
  801e0e:	e8 ea f9 ff ff       	call   8017fd <syscall>
  801e13:	83 c4 18             	add    $0x18,%esp
	return ;
  801e16:	90                   	nop
}
  801e17:	c9                   	leave  
  801e18:	c3                   	ret    

00801e19 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e19:	55                   	push   %ebp
  801e1a:	89 e5                	mov    %esp,%ebp
  801e1c:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e1d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e20:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e23:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e26:	8b 45 08             	mov    0x8(%ebp),%eax
  801e29:	6a 00                	push   $0x0
  801e2b:	53                   	push   %ebx
  801e2c:	51                   	push   %ecx
  801e2d:	52                   	push   %edx
  801e2e:	50                   	push   %eax
  801e2f:	6a 2e                	push   $0x2e
  801e31:	e8 c7 f9 ff ff       	call   8017fd <syscall>
  801e36:	83 c4 18             	add    $0x18,%esp
}
  801e39:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e3c:	c9                   	leave  
  801e3d:	c3                   	ret    

00801e3e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e3e:	55                   	push   %ebp
  801e3f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e41:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e44:	8b 45 08             	mov    0x8(%ebp),%eax
  801e47:	6a 00                	push   $0x0
  801e49:	6a 00                	push   $0x0
  801e4b:	6a 00                	push   $0x0
  801e4d:	52                   	push   %edx
  801e4e:	50                   	push   %eax
  801e4f:	6a 2f                	push   $0x2f
  801e51:	e8 a7 f9 ff ff       	call   8017fd <syscall>
  801e56:	83 c4 18             	add    $0x18,%esp
}
  801e59:	c9                   	leave  
  801e5a:	c3                   	ret    

00801e5b <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801e5b:	55                   	push   %ebp
  801e5c:	89 e5                	mov    %esp,%ebp
  801e5e:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801e61:	83 ec 0c             	sub    $0xc,%esp
  801e64:	68 80 3f 80 00       	push   $0x803f80
  801e69:	e8 d6 e6 ff ff       	call   800544 <cprintf>
  801e6e:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801e71:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801e78:	83 ec 0c             	sub    $0xc,%esp
  801e7b:	68 ac 3f 80 00       	push   $0x803fac
  801e80:	e8 bf e6 ff ff       	call   800544 <cprintf>
  801e85:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801e88:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e8c:	a1 38 51 80 00       	mov    0x805138,%eax
  801e91:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e94:	eb 56                	jmp    801eec <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e96:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e9a:	74 1c                	je     801eb8 <print_mem_block_lists+0x5d>
  801e9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e9f:	8b 50 08             	mov    0x8(%eax),%edx
  801ea2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ea5:	8b 48 08             	mov    0x8(%eax),%ecx
  801ea8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eab:	8b 40 0c             	mov    0xc(%eax),%eax
  801eae:	01 c8                	add    %ecx,%eax
  801eb0:	39 c2                	cmp    %eax,%edx
  801eb2:	73 04                	jae    801eb8 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801eb4:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801eb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ebb:	8b 50 08             	mov    0x8(%eax),%edx
  801ebe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec1:	8b 40 0c             	mov    0xc(%eax),%eax
  801ec4:	01 c2                	add    %eax,%edx
  801ec6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec9:	8b 40 08             	mov    0x8(%eax),%eax
  801ecc:	83 ec 04             	sub    $0x4,%esp
  801ecf:	52                   	push   %edx
  801ed0:	50                   	push   %eax
  801ed1:	68 c1 3f 80 00       	push   $0x803fc1
  801ed6:	e8 69 e6 ff ff       	call   800544 <cprintf>
  801edb:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801ede:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ee4:	a1 40 51 80 00       	mov    0x805140,%eax
  801ee9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801eec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ef0:	74 07                	je     801ef9 <print_mem_block_lists+0x9e>
  801ef2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef5:	8b 00                	mov    (%eax),%eax
  801ef7:	eb 05                	jmp    801efe <print_mem_block_lists+0xa3>
  801ef9:	b8 00 00 00 00       	mov    $0x0,%eax
  801efe:	a3 40 51 80 00       	mov    %eax,0x805140
  801f03:	a1 40 51 80 00       	mov    0x805140,%eax
  801f08:	85 c0                	test   %eax,%eax
  801f0a:	75 8a                	jne    801e96 <print_mem_block_lists+0x3b>
  801f0c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f10:	75 84                	jne    801e96 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801f12:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f16:	75 10                	jne    801f28 <print_mem_block_lists+0xcd>
  801f18:	83 ec 0c             	sub    $0xc,%esp
  801f1b:	68 d0 3f 80 00       	push   $0x803fd0
  801f20:	e8 1f e6 ff ff       	call   800544 <cprintf>
  801f25:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f28:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f2f:	83 ec 0c             	sub    $0xc,%esp
  801f32:	68 f4 3f 80 00       	push   $0x803ff4
  801f37:	e8 08 e6 ff ff       	call   800544 <cprintf>
  801f3c:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f3f:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f43:	a1 40 50 80 00       	mov    0x805040,%eax
  801f48:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f4b:	eb 56                	jmp    801fa3 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f4d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f51:	74 1c                	je     801f6f <print_mem_block_lists+0x114>
  801f53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f56:	8b 50 08             	mov    0x8(%eax),%edx
  801f59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f5c:	8b 48 08             	mov    0x8(%eax),%ecx
  801f5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f62:	8b 40 0c             	mov    0xc(%eax),%eax
  801f65:	01 c8                	add    %ecx,%eax
  801f67:	39 c2                	cmp    %eax,%edx
  801f69:	73 04                	jae    801f6f <print_mem_block_lists+0x114>
			sorted = 0 ;
  801f6b:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f72:	8b 50 08             	mov    0x8(%eax),%edx
  801f75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f78:	8b 40 0c             	mov    0xc(%eax),%eax
  801f7b:	01 c2                	add    %eax,%edx
  801f7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f80:	8b 40 08             	mov    0x8(%eax),%eax
  801f83:	83 ec 04             	sub    $0x4,%esp
  801f86:	52                   	push   %edx
  801f87:	50                   	push   %eax
  801f88:	68 c1 3f 80 00       	push   $0x803fc1
  801f8d:	e8 b2 e5 ff ff       	call   800544 <cprintf>
  801f92:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f98:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f9b:	a1 48 50 80 00       	mov    0x805048,%eax
  801fa0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fa3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fa7:	74 07                	je     801fb0 <print_mem_block_lists+0x155>
  801fa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fac:	8b 00                	mov    (%eax),%eax
  801fae:	eb 05                	jmp    801fb5 <print_mem_block_lists+0x15a>
  801fb0:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb5:	a3 48 50 80 00       	mov    %eax,0x805048
  801fba:	a1 48 50 80 00       	mov    0x805048,%eax
  801fbf:	85 c0                	test   %eax,%eax
  801fc1:	75 8a                	jne    801f4d <print_mem_block_lists+0xf2>
  801fc3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fc7:	75 84                	jne    801f4d <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801fc9:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fcd:	75 10                	jne    801fdf <print_mem_block_lists+0x184>
  801fcf:	83 ec 0c             	sub    $0xc,%esp
  801fd2:	68 0c 40 80 00       	push   $0x80400c
  801fd7:	e8 68 e5 ff ff       	call   800544 <cprintf>
  801fdc:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801fdf:	83 ec 0c             	sub    $0xc,%esp
  801fe2:	68 80 3f 80 00       	push   $0x803f80
  801fe7:	e8 58 e5 ff ff       	call   800544 <cprintf>
  801fec:	83 c4 10             	add    $0x10,%esp

}
  801fef:	90                   	nop
  801ff0:	c9                   	leave  
  801ff1:	c3                   	ret    

00801ff2 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801ff2:	55                   	push   %ebp
  801ff3:	89 e5                	mov    %esp,%ebp
  801ff5:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801ff8:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  801fff:	00 00 00 
  802002:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802009:	00 00 00 
  80200c:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802013:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802016:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80201d:	e9 9e 00 00 00       	jmp    8020c0 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802022:	a1 50 50 80 00       	mov    0x805050,%eax
  802027:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80202a:	c1 e2 04             	shl    $0x4,%edx
  80202d:	01 d0                	add    %edx,%eax
  80202f:	85 c0                	test   %eax,%eax
  802031:	75 14                	jne    802047 <initialize_MemBlocksList+0x55>
  802033:	83 ec 04             	sub    $0x4,%esp
  802036:	68 34 40 80 00       	push   $0x804034
  80203b:	6a 46                	push   $0x46
  80203d:	68 57 40 80 00       	push   $0x804057
  802042:	e8 49 e2 ff ff       	call   800290 <_panic>
  802047:	a1 50 50 80 00       	mov    0x805050,%eax
  80204c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80204f:	c1 e2 04             	shl    $0x4,%edx
  802052:	01 d0                	add    %edx,%eax
  802054:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80205a:	89 10                	mov    %edx,(%eax)
  80205c:	8b 00                	mov    (%eax),%eax
  80205e:	85 c0                	test   %eax,%eax
  802060:	74 18                	je     80207a <initialize_MemBlocksList+0x88>
  802062:	a1 48 51 80 00       	mov    0x805148,%eax
  802067:	8b 15 50 50 80 00    	mov    0x805050,%edx
  80206d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802070:	c1 e1 04             	shl    $0x4,%ecx
  802073:	01 ca                	add    %ecx,%edx
  802075:	89 50 04             	mov    %edx,0x4(%eax)
  802078:	eb 12                	jmp    80208c <initialize_MemBlocksList+0x9a>
  80207a:	a1 50 50 80 00       	mov    0x805050,%eax
  80207f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802082:	c1 e2 04             	shl    $0x4,%edx
  802085:	01 d0                	add    %edx,%eax
  802087:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80208c:	a1 50 50 80 00       	mov    0x805050,%eax
  802091:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802094:	c1 e2 04             	shl    $0x4,%edx
  802097:	01 d0                	add    %edx,%eax
  802099:	a3 48 51 80 00       	mov    %eax,0x805148
  80209e:	a1 50 50 80 00       	mov    0x805050,%eax
  8020a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020a6:	c1 e2 04             	shl    $0x4,%edx
  8020a9:	01 d0                	add    %edx,%eax
  8020ab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020b2:	a1 54 51 80 00       	mov    0x805154,%eax
  8020b7:	40                   	inc    %eax
  8020b8:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  8020bd:	ff 45 f4             	incl   -0xc(%ebp)
  8020c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8020c6:	0f 82 56 ff ff ff    	jb     802022 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  8020cc:	90                   	nop
  8020cd:	c9                   	leave  
  8020ce:	c3                   	ret    

008020cf <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8020cf:	55                   	push   %ebp
  8020d0:	89 e5                	mov    %esp,%ebp
  8020d2:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8020d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d8:	8b 00                	mov    (%eax),%eax
  8020da:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020dd:	eb 19                	jmp    8020f8 <find_block+0x29>
	{
		if(va==point->sva)
  8020df:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020e2:	8b 40 08             	mov    0x8(%eax),%eax
  8020e5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8020e8:	75 05                	jne    8020ef <find_block+0x20>
		   return point;
  8020ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020ed:	eb 36                	jmp    802125 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8020ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f2:	8b 40 08             	mov    0x8(%eax),%eax
  8020f5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020f8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020fc:	74 07                	je     802105 <find_block+0x36>
  8020fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802101:	8b 00                	mov    (%eax),%eax
  802103:	eb 05                	jmp    80210a <find_block+0x3b>
  802105:	b8 00 00 00 00       	mov    $0x0,%eax
  80210a:	8b 55 08             	mov    0x8(%ebp),%edx
  80210d:	89 42 08             	mov    %eax,0x8(%edx)
  802110:	8b 45 08             	mov    0x8(%ebp),%eax
  802113:	8b 40 08             	mov    0x8(%eax),%eax
  802116:	85 c0                	test   %eax,%eax
  802118:	75 c5                	jne    8020df <find_block+0x10>
  80211a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80211e:	75 bf                	jne    8020df <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802120:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802125:	c9                   	leave  
  802126:	c3                   	ret    

00802127 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802127:	55                   	push   %ebp
  802128:	89 e5                	mov    %esp,%ebp
  80212a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  80212d:	a1 40 50 80 00       	mov    0x805040,%eax
  802132:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802135:	a1 44 50 80 00       	mov    0x805044,%eax
  80213a:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  80213d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802140:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802143:	74 24                	je     802169 <insert_sorted_allocList+0x42>
  802145:	8b 45 08             	mov    0x8(%ebp),%eax
  802148:	8b 50 08             	mov    0x8(%eax),%edx
  80214b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80214e:	8b 40 08             	mov    0x8(%eax),%eax
  802151:	39 c2                	cmp    %eax,%edx
  802153:	76 14                	jbe    802169 <insert_sorted_allocList+0x42>
  802155:	8b 45 08             	mov    0x8(%ebp),%eax
  802158:	8b 50 08             	mov    0x8(%eax),%edx
  80215b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80215e:	8b 40 08             	mov    0x8(%eax),%eax
  802161:	39 c2                	cmp    %eax,%edx
  802163:	0f 82 60 01 00 00    	jb     8022c9 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802169:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80216d:	75 65                	jne    8021d4 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  80216f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802173:	75 14                	jne    802189 <insert_sorted_allocList+0x62>
  802175:	83 ec 04             	sub    $0x4,%esp
  802178:	68 34 40 80 00       	push   $0x804034
  80217d:	6a 6b                	push   $0x6b
  80217f:	68 57 40 80 00       	push   $0x804057
  802184:	e8 07 e1 ff ff       	call   800290 <_panic>
  802189:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80218f:	8b 45 08             	mov    0x8(%ebp),%eax
  802192:	89 10                	mov    %edx,(%eax)
  802194:	8b 45 08             	mov    0x8(%ebp),%eax
  802197:	8b 00                	mov    (%eax),%eax
  802199:	85 c0                	test   %eax,%eax
  80219b:	74 0d                	je     8021aa <insert_sorted_allocList+0x83>
  80219d:	a1 40 50 80 00       	mov    0x805040,%eax
  8021a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8021a5:	89 50 04             	mov    %edx,0x4(%eax)
  8021a8:	eb 08                	jmp    8021b2 <insert_sorted_allocList+0x8b>
  8021aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ad:	a3 44 50 80 00       	mov    %eax,0x805044
  8021b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b5:	a3 40 50 80 00       	mov    %eax,0x805040
  8021ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021c4:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8021c9:	40                   	inc    %eax
  8021ca:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8021cf:	e9 dc 01 00 00       	jmp    8023b0 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8021d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d7:	8b 50 08             	mov    0x8(%eax),%edx
  8021da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021dd:	8b 40 08             	mov    0x8(%eax),%eax
  8021e0:	39 c2                	cmp    %eax,%edx
  8021e2:	77 6c                	ja     802250 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8021e4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021e8:	74 06                	je     8021f0 <insert_sorted_allocList+0xc9>
  8021ea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021ee:	75 14                	jne    802204 <insert_sorted_allocList+0xdd>
  8021f0:	83 ec 04             	sub    $0x4,%esp
  8021f3:	68 70 40 80 00       	push   $0x804070
  8021f8:	6a 6f                	push   $0x6f
  8021fa:	68 57 40 80 00       	push   $0x804057
  8021ff:	e8 8c e0 ff ff       	call   800290 <_panic>
  802204:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802207:	8b 50 04             	mov    0x4(%eax),%edx
  80220a:	8b 45 08             	mov    0x8(%ebp),%eax
  80220d:	89 50 04             	mov    %edx,0x4(%eax)
  802210:	8b 45 08             	mov    0x8(%ebp),%eax
  802213:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802216:	89 10                	mov    %edx,(%eax)
  802218:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80221b:	8b 40 04             	mov    0x4(%eax),%eax
  80221e:	85 c0                	test   %eax,%eax
  802220:	74 0d                	je     80222f <insert_sorted_allocList+0x108>
  802222:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802225:	8b 40 04             	mov    0x4(%eax),%eax
  802228:	8b 55 08             	mov    0x8(%ebp),%edx
  80222b:	89 10                	mov    %edx,(%eax)
  80222d:	eb 08                	jmp    802237 <insert_sorted_allocList+0x110>
  80222f:	8b 45 08             	mov    0x8(%ebp),%eax
  802232:	a3 40 50 80 00       	mov    %eax,0x805040
  802237:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80223a:	8b 55 08             	mov    0x8(%ebp),%edx
  80223d:	89 50 04             	mov    %edx,0x4(%eax)
  802240:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802245:	40                   	inc    %eax
  802246:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80224b:	e9 60 01 00 00       	jmp    8023b0 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802250:	8b 45 08             	mov    0x8(%ebp),%eax
  802253:	8b 50 08             	mov    0x8(%eax),%edx
  802256:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802259:	8b 40 08             	mov    0x8(%eax),%eax
  80225c:	39 c2                	cmp    %eax,%edx
  80225e:	0f 82 4c 01 00 00    	jb     8023b0 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802264:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802268:	75 14                	jne    80227e <insert_sorted_allocList+0x157>
  80226a:	83 ec 04             	sub    $0x4,%esp
  80226d:	68 a8 40 80 00       	push   $0x8040a8
  802272:	6a 73                	push   $0x73
  802274:	68 57 40 80 00       	push   $0x804057
  802279:	e8 12 e0 ff ff       	call   800290 <_panic>
  80227e:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802284:	8b 45 08             	mov    0x8(%ebp),%eax
  802287:	89 50 04             	mov    %edx,0x4(%eax)
  80228a:	8b 45 08             	mov    0x8(%ebp),%eax
  80228d:	8b 40 04             	mov    0x4(%eax),%eax
  802290:	85 c0                	test   %eax,%eax
  802292:	74 0c                	je     8022a0 <insert_sorted_allocList+0x179>
  802294:	a1 44 50 80 00       	mov    0x805044,%eax
  802299:	8b 55 08             	mov    0x8(%ebp),%edx
  80229c:	89 10                	mov    %edx,(%eax)
  80229e:	eb 08                	jmp    8022a8 <insert_sorted_allocList+0x181>
  8022a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a3:	a3 40 50 80 00       	mov    %eax,0x805040
  8022a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ab:	a3 44 50 80 00       	mov    %eax,0x805044
  8022b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022b9:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8022be:	40                   	inc    %eax
  8022bf:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8022c4:	e9 e7 00 00 00       	jmp    8023b0 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8022c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8022cf:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8022d6:	a1 40 50 80 00       	mov    0x805040,%eax
  8022db:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022de:	e9 9d 00 00 00       	jmp    802380 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8022e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e6:	8b 00                	mov    (%eax),%eax
  8022e8:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8022eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ee:	8b 50 08             	mov    0x8(%eax),%edx
  8022f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f4:	8b 40 08             	mov    0x8(%eax),%eax
  8022f7:	39 c2                	cmp    %eax,%edx
  8022f9:	76 7d                	jbe    802378 <insert_sorted_allocList+0x251>
  8022fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fe:	8b 50 08             	mov    0x8(%eax),%edx
  802301:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802304:	8b 40 08             	mov    0x8(%eax),%eax
  802307:	39 c2                	cmp    %eax,%edx
  802309:	73 6d                	jae    802378 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  80230b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80230f:	74 06                	je     802317 <insert_sorted_allocList+0x1f0>
  802311:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802315:	75 14                	jne    80232b <insert_sorted_allocList+0x204>
  802317:	83 ec 04             	sub    $0x4,%esp
  80231a:	68 cc 40 80 00       	push   $0x8040cc
  80231f:	6a 7f                	push   $0x7f
  802321:	68 57 40 80 00       	push   $0x804057
  802326:	e8 65 df ff ff       	call   800290 <_panic>
  80232b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232e:	8b 10                	mov    (%eax),%edx
  802330:	8b 45 08             	mov    0x8(%ebp),%eax
  802333:	89 10                	mov    %edx,(%eax)
  802335:	8b 45 08             	mov    0x8(%ebp),%eax
  802338:	8b 00                	mov    (%eax),%eax
  80233a:	85 c0                	test   %eax,%eax
  80233c:	74 0b                	je     802349 <insert_sorted_allocList+0x222>
  80233e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802341:	8b 00                	mov    (%eax),%eax
  802343:	8b 55 08             	mov    0x8(%ebp),%edx
  802346:	89 50 04             	mov    %edx,0x4(%eax)
  802349:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234c:	8b 55 08             	mov    0x8(%ebp),%edx
  80234f:	89 10                	mov    %edx,(%eax)
  802351:	8b 45 08             	mov    0x8(%ebp),%eax
  802354:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802357:	89 50 04             	mov    %edx,0x4(%eax)
  80235a:	8b 45 08             	mov    0x8(%ebp),%eax
  80235d:	8b 00                	mov    (%eax),%eax
  80235f:	85 c0                	test   %eax,%eax
  802361:	75 08                	jne    80236b <insert_sorted_allocList+0x244>
  802363:	8b 45 08             	mov    0x8(%ebp),%eax
  802366:	a3 44 50 80 00       	mov    %eax,0x805044
  80236b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802370:	40                   	inc    %eax
  802371:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802376:	eb 39                	jmp    8023b1 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802378:	a1 48 50 80 00       	mov    0x805048,%eax
  80237d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802380:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802384:	74 07                	je     80238d <insert_sorted_allocList+0x266>
  802386:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802389:	8b 00                	mov    (%eax),%eax
  80238b:	eb 05                	jmp    802392 <insert_sorted_allocList+0x26b>
  80238d:	b8 00 00 00 00       	mov    $0x0,%eax
  802392:	a3 48 50 80 00       	mov    %eax,0x805048
  802397:	a1 48 50 80 00       	mov    0x805048,%eax
  80239c:	85 c0                	test   %eax,%eax
  80239e:	0f 85 3f ff ff ff    	jne    8022e3 <insert_sorted_allocList+0x1bc>
  8023a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023a8:	0f 85 35 ff ff ff    	jne    8022e3 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8023ae:	eb 01                	jmp    8023b1 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8023b0:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8023b1:	90                   	nop
  8023b2:	c9                   	leave  
  8023b3:	c3                   	ret    

008023b4 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8023b4:	55                   	push   %ebp
  8023b5:	89 e5                	mov    %esp,%ebp
  8023b7:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8023ba:	a1 38 51 80 00       	mov    0x805138,%eax
  8023bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023c2:	e9 85 01 00 00       	jmp    80254c <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8023c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8023cd:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023d0:	0f 82 6e 01 00 00    	jb     802544 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8023d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d9:	8b 40 0c             	mov    0xc(%eax),%eax
  8023dc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023df:	0f 85 8a 00 00 00    	jne    80246f <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8023e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023e9:	75 17                	jne    802402 <alloc_block_FF+0x4e>
  8023eb:	83 ec 04             	sub    $0x4,%esp
  8023ee:	68 00 41 80 00       	push   $0x804100
  8023f3:	68 93 00 00 00       	push   $0x93
  8023f8:	68 57 40 80 00       	push   $0x804057
  8023fd:	e8 8e de ff ff       	call   800290 <_panic>
  802402:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802405:	8b 00                	mov    (%eax),%eax
  802407:	85 c0                	test   %eax,%eax
  802409:	74 10                	je     80241b <alloc_block_FF+0x67>
  80240b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240e:	8b 00                	mov    (%eax),%eax
  802410:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802413:	8b 52 04             	mov    0x4(%edx),%edx
  802416:	89 50 04             	mov    %edx,0x4(%eax)
  802419:	eb 0b                	jmp    802426 <alloc_block_FF+0x72>
  80241b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241e:	8b 40 04             	mov    0x4(%eax),%eax
  802421:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802426:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802429:	8b 40 04             	mov    0x4(%eax),%eax
  80242c:	85 c0                	test   %eax,%eax
  80242e:	74 0f                	je     80243f <alloc_block_FF+0x8b>
  802430:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802433:	8b 40 04             	mov    0x4(%eax),%eax
  802436:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802439:	8b 12                	mov    (%edx),%edx
  80243b:	89 10                	mov    %edx,(%eax)
  80243d:	eb 0a                	jmp    802449 <alloc_block_FF+0x95>
  80243f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802442:	8b 00                	mov    (%eax),%eax
  802444:	a3 38 51 80 00       	mov    %eax,0x805138
  802449:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802452:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802455:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80245c:	a1 44 51 80 00       	mov    0x805144,%eax
  802461:	48                   	dec    %eax
  802462:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802467:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246a:	e9 10 01 00 00       	jmp    80257f <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  80246f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802472:	8b 40 0c             	mov    0xc(%eax),%eax
  802475:	3b 45 08             	cmp    0x8(%ebp),%eax
  802478:	0f 86 c6 00 00 00    	jbe    802544 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80247e:	a1 48 51 80 00       	mov    0x805148,%eax
  802483:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802486:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802489:	8b 50 08             	mov    0x8(%eax),%edx
  80248c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80248f:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802492:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802495:	8b 55 08             	mov    0x8(%ebp),%edx
  802498:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80249b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80249f:	75 17                	jne    8024b8 <alloc_block_FF+0x104>
  8024a1:	83 ec 04             	sub    $0x4,%esp
  8024a4:	68 00 41 80 00       	push   $0x804100
  8024a9:	68 9b 00 00 00       	push   $0x9b
  8024ae:	68 57 40 80 00       	push   $0x804057
  8024b3:	e8 d8 dd ff ff       	call   800290 <_panic>
  8024b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024bb:	8b 00                	mov    (%eax),%eax
  8024bd:	85 c0                	test   %eax,%eax
  8024bf:	74 10                	je     8024d1 <alloc_block_FF+0x11d>
  8024c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024c4:	8b 00                	mov    (%eax),%eax
  8024c6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024c9:	8b 52 04             	mov    0x4(%edx),%edx
  8024cc:	89 50 04             	mov    %edx,0x4(%eax)
  8024cf:	eb 0b                	jmp    8024dc <alloc_block_FF+0x128>
  8024d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024d4:	8b 40 04             	mov    0x4(%eax),%eax
  8024d7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8024dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024df:	8b 40 04             	mov    0x4(%eax),%eax
  8024e2:	85 c0                	test   %eax,%eax
  8024e4:	74 0f                	je     8024f5 <alloc_block_FF+0x141>
  8024e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024e9:	8b 40 04             	mov    0x4(%eax),%eax
  8024ec:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024ef:	8b 12                	mov    (%edx),%edx
  8024f1:	89 10                	mov    %edx,(%eax)
  8024f3:	eb 0a                	jmp    8024ff <alloc_block_FF+0x14b>
  8024f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024f8:	8b 00                	mov    (%eax),%eax
  8024fa:	a3 48 51 80 00       	mov    %eax,0x805148
  8024ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802502:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802508:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80250b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802512:	a1 54 51 80 00       	mov    0x805154,%eax
  802517:	48                   	dec    %eax
  802518:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  80251d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802520:	8b 50 08             	mov    0x8(%eax),%edx
  802523:	8b 45 08             	mov    0x8(%ebp),%eax
  802526:	01 c2                	add    %eax,%edx
  802528:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252b:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  80252e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802531:	8b 40 0c             	mov    0xc(%eax),%eax
  802534:	2b 45 08             	sub    0x8(%ebp),%eax
  802537:	89 c2                	mov    %eax,%edx
  802539:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253c:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  80253f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802542:	eb 3b                	jmp    80257f <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802544:	a1 40 51 80 00       	mov    0x805140,%eax
  802549:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80254c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802550:	74 07                	je     802559 <alloc_block_FF+0x1a5>
  802552:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802555:	8b 00                	mov    (%eax),%eax
  802557:	eb 05                	jmp    80255e <alloc_block_FF+0x1aa>
  802559:	b8 00 00 00 00       	mov    $0x0,%eax
  80255e:	a3 40 51 80 00       	mov    %eax,0x805140
  802563:	a1 40 51 80 00       	mov    0x805140,%eax
  802568:	85 c0                	test   %eax,%eax
  80256a:	0f 85 57 fe ff ff    	jne    8023c7 <alloc_block_FF+0x13>
  802570:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802574:	0f 85 4d fe ff ff    	jne    8023c7 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  80257a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80257f:	c9                   	leave  
  802580:	c3                   	ret    

00802581 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802581:	55                   	push   %ebp
  802582:	89 e5                	mov    %esp,%ebp
  802584:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802587:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80258e:	a1 38 51 80 00       	mov    0x805138,%eax
  802593:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802596:	e9 df 00 00 00       	jmp    80267a <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  80259b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259e:	8b 40 0c             	mov    0xc(%eax),%eax
  8025a1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025a4:	0f 82 c8 00 00 00    	jb     802672 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8025aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ad:	8b 40 0c             	mov    0xc(%eax),%eax
  8025b0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025b3:	0f 85 8a 00 00 00    	jne    802643 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8025b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025bd:	75 17                	jne    8025d6 <alloc_block_BF+0x55>
  8025bf:	83 ec 04             	sub    $0x4,%esp
  8025c2:	68 00 41 80 00       	push   $0x804100
  8025c7:	68 b7 00 00 00       	push   $0xb7
  8025cc:	68 57 40 80 00       	push   $0x804057
  8025d1:	e8 ba dc ff ff       	call   800290 <_panic>
  8025d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d9:	8b 00                	mov    (%eax),%eax
  8025db:	85 c0                	test   %eax,%eax
  8025dd:	74 10                	je     8025ef <alloc_block_BF+0x6e>
  8025df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e2:	8b 00                	mov    (%eax),%eax
  8025e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025e7:	8b 52 04             	mov    0x4(%edx),%edx
  8025ea:	89 50 04             	mov    %edx,0x4(%eax)
  8025ed:	eb 0b                	jmp    8025fa <alloc_block_BF+0x79>
  8025ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f2:	8b 40 04             	mov    0x4(%eax),%eax
  8025f5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8025fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fd:	8b 40 04             	mov    0x4(%eax),%eax
  802600:	85 c0                	test   %eax,%eax
  802602:	74 0f                	je     802613 <alloc_block_BF+0x92>
  802604:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802607:	8b 40 04             	mov    0x4(%eax),%eax
  80260a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80260d:	8b 12                	mov    (%edx),%edx
  80260f:	89 10                	mov    %edx,(%eax)
  802611:	eb 0a                	jmp    80261d <alloc_block_BF+0x9c>
  802613:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802616:	8b 00                	mov    (%eax),%eax
  802618:	a3 38 51 80 00       	mov    %eax,0x805138
  80261d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802620:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802626:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802629:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802630:	a1 44 51 80 00       	mov    0x805144,%eax
  802635:	48                   	dec    %eax
  802636:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  80263b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263e:	e9 4d 01 00 00       	jmp    802790 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802643:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802646:	8b 40 0c             	mov    0xc(%eax),%eax
  802649:	3b 45 08             	cmp    0x8(%ebp),%eax
  80264c:	76 24                	jbe    802672 <alloc_block_BF+0xf1>
  80264e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802651:	8b 40 0c             	mov    0xc(%eax),%eax
  802654:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802657:	73 19                	jae    802672 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802659:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802660:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802663:	8b 40 0c             	mov    0xc(%eax),%eax
  802666:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802669:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266c:	8b 40 08             	mov    0x8(%eax),%eax
  80266f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802672:	a1 40 51 80 00       	mov    0x805140,%eax
  802677:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80267a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80267e:	74 07                	je     802687 <alloc_block_BF+0x106>
  802680:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802683:	8b 00                	mov    (%eax),%eax
  802685:	eb 05                	jmp    80268c <alloc_block_BF+0x10b>
  802687:	b8 00 00 00 00       	mov    $0x0,%eax
  80268c:	a3 40 51 80 00       	mov    %eax,0x805140
  802691:	a1 40 51 80 00       	mov    0x805140,%eax
  802696:	85 c0                	test   %eax,%eax
  802698:	0f 85 fd fe ff ff    	jne    80259b <alloc_block_BF+0x1a>
  80269e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026a2:	0f 85 f3 fe ff ff    	jne    80259b <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8026a8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8026ac:	0f 84 d9 00 00 00    	je     80278b <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8026b2:	a1 48 51 80 00       	mov    0x805148,%eax
  8026b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8026ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026bd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026c0:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8026c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8026c9:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8026cc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8026d0:	75 17                	jne    8026e9 <alloc_block_BF+0x168>
  8026d2:	83 ec 04             	sub    $0x4,%esp
  8026d5:	68 00 41 80 00       	push   $0x804100
  8026da:	68 c7 00 00 00       	push   $0xc7
  8026df:	68 57 40 80 00       	push   $0x804057
  8026e4:	e8 a7 db ff ff       	call   800290 <_panic>
  8026e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026ec:	8b 00                	mov    (%eax),%eax
  8026ee:	85 c0                	test   %eax,%eax
  8026f0:	74 10                	je     802702 <alloc_block_BF+0x181>
  8026f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026f5:	8b 00                	mov    (%eax),%eax
  8026f7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026fa:	8b 52 04             	mov    0x4(%edx),%edx
  8026fd:	89 50 04             	mov    %edx,0x4(%eax)
  802700:	eb 0b                	jmp    80270d <alloc_block_BF+0x18c>
  802702:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802705:	8b 40 04             	mov    0x4(%eax),%eax
  802708:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80270d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802710:	8b 40 04             	mov    0x4(%eax),%eax
  802713:	85 c0                	test   %eax,%eax
  802715:	74 0f                	je     802726 <alloc_block_BF+0x1a5>
  802717:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80271a:	8b 40 04             	mov    0x4(%eax),%eax
  80271d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802720:	8b 12                	mov    (%edx),%edx
  802722:	89 10                	mov    %edx,(%eax)
  802724:	eb 0a                	jmp    802730 <alloc_block_BF+0x1af>
  802726:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802729:	8b 00                	mov    (%eax),%eax
  80272b:	a3 48 51 80 00       	mov    %eax,0x805148
  802730:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802733:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802739:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80273c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802743:	a1 54 51 80 00       	mov    0x805154,%eax
  802748:	48                   	dec    %eax
  802749:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  80274e:	83 ec 08             	sub    $0x8,%esp
  802751:	ff 75 ec             	pushl  -0x14(%ebp)
  802754:	68 38 51 80 00       	push   $0x805138
  802759:	e8 71 f9 ff ff       	call   8020cf <find_block>
  80275e:	83 c4 10             	add    $0x10,%esp
  802761:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802764:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802767:	8b 50 08             	mov    0x8(%eax),%edx
  80276a:	8b 45 08             	mov    0x8(%ebp),%eax
  80276d:	01 c2                	add    %eax,%edx
  80276f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802772:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802775:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802778:	8b 40 0c             	mov    0xc(%eax),%eax
  80277b:	2b 45 08             	sub    0x8(%ebp),%eax
  80277e:	89 c2                	mov    %eax,%edx
  802780:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802783:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802786:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802789:	eb 05                	jmp    802790 <alloc_block_BF+0x20f>
	}
	return NULL;
  80278b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802790:	c9                   	leave  
  802791:	c3                   	ret    

00802792 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802792:	55                   	push   %ebp
  802793:	89 e5                	mov    %esp,%ebp
  802795:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802798:	a1 28 50 80 00       	mov    0x805028,%eax
  80279d:	85 c0                	test   %eax,%eax
  80279f:	0f 85 de 01 00 00    	jne    802983 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8027a5:	a1 38 51 80 00       	mov    0x805138,%eax
  8027aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027ad:	e9 9e 01 00 00       	jmp    802950 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8027b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b5:	8b 40 0c             	mov    0xc(%eax),%eax
  8027b8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027bb:	0f 82 87 01 00 00    	jb     802948 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8027c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c4:	8b 40 0c             	mov    0xc(%eax),%eax
  8027c7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027ca:	0f 85 95 00 00 00    	jne    802865 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8027d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027d4:	75 17                	jne    8027ed <alloc_block_NF+0x5b>
  8027d6:	83 ec 04             	sub    $0x4,%esp
  8027d9:	68 00 41 80 00       	push   $0x804100
  8027de:	68 e0 00 00 00       	push   $0xe0
  8027e3:	68 57 40 80 00       	push   $0x804057
  8027e8:	e8 a3 da ff ff       	call   800290 <_panic>
  8027ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f0:	8b 00                	mov    (%eax),%eax
  8027f2:	85 c0                	test   %eax,%eax
  8027f4:	74 10                	je     802806 <alloc_block_NF+0x74>
  8027f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f9:	8b 00                	mov    (%eax),%eax
  8027fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027fe:	8b 52 04             	mov    0x4(%edx),%edx
  802801:	89 50 04             	mov    %edx,0x4(%eax)
  802804:	eb 0b                	jmp    802811 <alloc_block_NF+0x7f>
  802806:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802809:	8b 40 04             	mov    0x4(%eax),%eax
  80280c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802811:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802814:	8b 40 04             	mov    0x4(%eax),%eax
  802817:	85 c0                	test   %eax,%eax
  802819:	74 0f                	je     80282a <alloc_block_NF+0x98>
  80281b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281e:	8b 40 04             	mov    0x4(%eax),%eax
  802821:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802824:	8b 12                	mov    (%edx),%edx
  802826:	89 10                	mov    %edx,(%eax)
  802828:	eb 0a                	jmp    802834 <alloc_block_NF+0xa2>
  80282a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282d:	8b 00                	mov    (%eax),%eax
  80282f:	a3 38 51 80 00       	mov    %eax,0x805138
  802834:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802837:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80283d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802840:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802847:	a1 44 51 80 00       	mov    0x805144,%eax
  80284c:	48                   	dec    %eax
  80284d:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802852:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802855:	8b 40 08             	mov    0x8(%eax),%eax
  802858:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  80285d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802860:	e9 f8 04 00 00       	jmp    802d5d <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802865:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802868:	8b 40 0c             	mov    0xc(%eax),%eax
  80286b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80286e:	0f 86 d4 00 00 00    	jbe    802948 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802874:	a1 48 51 80 00       	mov    0x805148,%eax
  802879:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  80287c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287f:	8b 50 08             	mov    0x8(%eax),%edx
  802882:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802885:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802888:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80288b:	8b 55 08             	mov    0x8(%ebp),%edx
  80288e:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802891:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802895:	75 17                	jne    8028ae <alloc_block_NF+0x11c>
  802897:	83 ec 04             	sub    $0x4,%esp
  80289a:	68 00 41 80 00       	push   $0x804100
  80289f:	68 e9 00 00 00       	push   $0xe9
  8028a4:	68 57 40 80 00       	push   $0x804057
  8028a9:	e8 e2 d9 ff ff       	call   800290 <_panic>
  8028ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b1:	8b 00                	mov    (%eax),%eax
  8028b3:	85 c0                	test   %eax,%eax
  8028b5:	74 10                	je     8028c7 <alloc_block_NF+0x135>
  8028b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ba:	8b 00                	mov    (%eax),%eax
  8028bc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028bf:	8b 52 04             	mov    0x4(%edx),%edx
  8028c2:	89 50 04             	mov    %edx,0x4(%eax)
  8028c5:	eb 0b                	jmp    8028d2 <alloc_block_NF+0x140>
  8028c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ca:	8b 40 04             	mov    0x4(%eax),%eax
  8028cd:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8028d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028d5:	8b 40 04             	mov    0x4(%eax),%eax
  8028d8:	85 c0                	test   %eax,%eax
  8028da:	74 0f                	je     8028eb <alloc_block_NF+0x159>
  8028dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028df:	8b 40 04             	mov    0x4(%eax),%eax
  8028e2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028e5:	8b 12                	mov    (%edx),%edx
  8028e7:	89 10                	mov    %edx,(%eax)
  8028e9:	eb 0a                	jmp    8028f5 <alloc_block_NF+0x163>
  8028eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ee:	8b 00                	mov    (%eax),%eax
  8028f0:	a3 48 51 80 00       	mov    %eax,0x805148
  8028f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802901:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802908:	a1 54 51 80 00       	mov    0x805154,%eax
  80290d:	48                   	dec    %eax
  80290e:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802913:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802916:	8b 40 08             	mov    0x8(%eax),%eax
  802919:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  80291e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802921:	8b 50 08             	mov    0x8(%eax),%edx
  802924:	8b 45 08             	mov    0x8(%ebp),%eax
  802927:	01 c2                	add    %eax,%edx
  802929:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292c:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  80292f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802932:	8b 40 0c             	mov    0xc(%eax),%eax
  802935:	2b 45 08             	sub    0x8(%ebp),%eax
  802938:	89 c2                	mov    %eax,%edx
  80293a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293d:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802940:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802943:	e9 15 04 00 00       	jmp    802d5d <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802948:	a1 40 51 80 00       	mov    0x805140,%eax
  80294d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802950:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802954:	74 07                	je     80295d <alloc_block_NF+0x1cb>
  802956:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802959:	8b 00                	mov    (%eax),%eax
  80295b:	eb 05                	jmp    802962 <alloc_block_NF+0x1d0>
  80295d:	b8 00 00 00 00       	mov    $0x0,%eax
  802962:	a3 40 51 80 00       	mov    %eax,0x805140
  802967:	a1 40 51 80 00       	mov    0x805140,%eax
  80296c:	85 c0                	test   %eax,%eax
  80296e:	0f 85 3e fe ff ff    	jne    8027b2 <alloc_block_NF+0x20>
  802974:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802978:	0f 85 34 fe ff ff    	jne    8027b2 <alloc_block_NF+0x20>
  80297e:	e9 d5 03 00 00       	jmp    802d58 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802983:	a1 38 51 80 00       	mov    0x805138,%eax
  802988:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80298b:	e9 b1 01 00 00       	jmp    802b41 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802990:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802993:	8b 50 08             	mov    0x8(%eax),%edx
  802996:	a1 28 50 80 00       	mov    0x805028,%eax
  80299b:	39 c2                	cmp    %eax,%edx
  80299d:	0f 82 96 01 00 00    	jb     802b39 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  8029a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a6:	8b 40 0c             	mov    0xc(%eax),%eax
  8029a9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029ac:	0f 82 87 01 00 00    	jb     802b39 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  8029b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b5:	8b 40 0c             	mov    0xc(%eax),%eax
  8029b8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029bb:	0f 85 95 00 00 00    	jne    802a56 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8029c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029c5:	75 17                	jne    8029de <alloc_block_NF+0x24c>
  8029c7:	83 ec 04             	sub    $0x4,%esp
  8029ca:	68 00 41 80 00       	push   $0x804100
  8029cf:	68 fc 00 00 00       	push   $0xfc
  8029d4:	68 57 40 80 00       	push   $0x804057
  8029d9:	e8 b2 d8 ff ff       	call   800290 <_panic>
  8029de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e1:	8b 00                	mov    (%eax),%eax
  8029e3:	85 c0                	test   %eax,%eax
  8029e5:	74 10                	je     8029f7 <alloc_block_NF+0x265>
  8029e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ea:	8b 00                	mov    (%eax),%eax
  8029ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029ef:	8b 52 04             	mov    0x4(%edx),%edx
  8029f2:	89 50 04             	mov    %edx,0x4(%eax)
  8029f5:	eb 0b                	jmp    802a02 <alloc_block_NF+0x270>
  8029f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fa:	8b 40 04             	mov    0x4(%eax),%eax
  8029fd:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a05:	8b 40 04             	mov    0x4(%eax),%eax
  802a08:	85 c0                	test   %eax,%eax
  802a0a:	74 0f                	je     802a1b <alloc_block_NF+0x289>
  802a0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0f:	8b 40 04             	mov    0x4(%eax),%eax
  802a12:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a15:	8b 12                	mov    (%edx),%edx
  802a17:	89 10                	mov    %edx,(%eax)
  802a19:	eb 0a                	jmp    802a25 <alloc_block_NF+0x293>
  802a1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1e:	8b 00                	mov    (%eax),%eax
  802a20:	a3 38 51 80 00       	mov    %eax,0x805138
  802a25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a28:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a31:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a38:	a1 44 51 80 00       	mov    0x805144,%eax
  802a3d:	48                   	dec    %eax
  802a3e:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802a43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a46:	8b 40 08             	mov    0x8(%eax),%eax
  802a49:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802a4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a51:	e9 07 03 00 00       	jmp    802d5d <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802a56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a59:	8b 40 0c             	mov    0xc(%eax),%eax
  802a5c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a5f:	0f 86 d4 00 00 00    	jbe    802b39 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802a65:	a1 48 51 80 00       	mov    0x805148,%eax
  802a6a:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802a6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a70:	8b 50 08             	mov    0x8(%eax),%edx
  802a73:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a76:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802a79:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a7c:	8b 55 08             	mov    0x8(%ebp),%edx
  802a7f:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802a82:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802a86:	75 17                	jne    802a9f <alloc_block_NF+0x30d>
  802a88:	83 ec 04             	sub    $0x4,%esp
  802a8b:	68 00 41 80 00       	push   $0x804100
  802a90:	68 04 01 00 00       	push   $0x104
  802a95:	68 57 40 80 00       	push   $0x804057
  802a9a:	e8 f1 d7 ff ff       	call   800290 <_panic>
  802a9f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aa2:	8b 00                	mov    (%eax),%eax
  802aa4:	85 c0                	test   %eax,%eax
  802aa6:	74 10                	je     802ab8 <alloc_block_NF+0x326>
  802aa8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aab:	8b 00                	mov    (%eax),%eax
  802aad:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ab0:	8b 52 04             	mov    0x4(%edx),%edx
  802ab3:	89 50 04             	mov    %edx,0x4(%eax)
  802ab6:	eb 0b                	jmp    802ac3 <alloc_block_NF+0x331>
  802ab8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802abb:	8b 40 04             	mov    0x4(%eax),%eax
  802abe:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ac3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ac6:	8b 40 04             	mov    0x4(%eax),%eax
  802ac9:	85 c0                	test   %eax,%eax
  802acb:	74 0f                	je     802adc <alloc_block_NF+0x34a>
  802acd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ad0:	8b 40 04             	mov    0x4(%eax),%eax
  802ad3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ad6:	8b 12                	mov    (%edx),%edx
  802ad8:	89 10                	mov    %edx,(%eax)
  802ada:	eb 0a                	jmp    802ae6 <alloc_block_NF+0x354>
  802adc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802adf:	8b 00                	mov    (%eax),%eax
  802ae1:	a3 48 51 80 00       	mov    %eax,0x805148
  802ae6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ae9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802aef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802af2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802af9:	a1 54 51 80 00       	mov    0x805154,%eax
  802afe:	48                   	dec    %eax
  802aff:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802b04:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b07:	8b 40 08             	mov    0x8(%eax),%eax
  802b0a:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802b0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b12:	8b 50 08             	mov    0x8(%eax),%edx
  802b15:	8b 45 08             	mov    0x8(%ebp),%eax
  802b18:	01 c2                	add    %eax,%edx
  802b1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1d:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802b20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b23:	8b 40 0c             	mov    0xc(%eax),%eax
  802b26:	2b 45 08             	sub    0x8(%ebp),%eax
  802b29:	89 c2                	mov    %eax,%edx
  802b2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2e:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802b31:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b34:	e9 24 02 00 00       	jmp    802d5d <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b39:	a1 40 51 80 00       	mov    0x805140,%eax
  802b3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b41:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b45:	74 07                	je     802b4e <alloc_block_NF+0x3bc>
  802b47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4a:	8b 00                	mov    (%eax),%eax
  802b4c:	eb 05                	jmp    802b53 <alloc_block_NF+0x3c1>
  802b4e:	b8 00 00 00 00       	mov    $0x0,%eax
  802b53:	a3 40 51 80 00       	mov    %eax,0x805140
  802b58:	a1 40 51 80 00       	mov    0x805140,%eax
  802b5d:	85 c0                	test   %eax,%eax
  802b5f:	0f 85 2b fe ff ff    	jne    802990 <alloc_block_NF+0x1fe>
  802b65:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b69:	0f 85 21 fe ff ff    	jne    802990 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b6f:	a1 38 51 80 00       	mov    0x805138,%eax
  802b74:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b77:	e9 ae 01 00 00       	jmp    802d2a <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802b7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7f:	8b 50 08             	mov    0x8(%eax),%edx
  802b82:	a1 28 50 80 00       	mov    0x805028,%eax
  802b87:	39 c2                	cmp    %eax,%edx
  802b89:	0f 83 93 01 00 00    	jae    802d22 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802b8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b92:	8b 40 0c             	mov    0xc(%eax),%eax
  802b95:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b98:	0f 82 84 01 00 00    	jb     802d22 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802b9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ba4:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ba7:	0f 85 95 00 00 00    	jne    802c42 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802bad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bb1:	75 17                	jne    802bca <alloc_block_NF+0x438>
  802bb3:	83 ec 04             	sub    $0x4,%esp
  802bb6:	68 00 41 80 00       	push   $0x804100
  802bbb:	68 14 01 00 00       	push   $0x114
  802bc0:	68 57 40 80 00       	push   $0x804057
  802bc5:	e8 c6 d6 ff ff       	call   800290 <_panic>
  802bca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcd:	8b 00                	mov    (%eax),%eax
  802bcf:	85 c0                	test   %eax,%eax
  802bd1:	74 10                	je     802be3 <alloc_block_NF+0x451>
  802bd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd6:	8b 00                	mov    (%eax),%eax
  802bd8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bdb:	8b 52 04             	mov    0x4(%edx),%edx
  802bde:	89 50 04             	mov    %edx,0x4(%eax)
  802be1:	eb 0b                	jmp    802bee <alloc_block_NF+0x45c>
  802be3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be6:	8b 40 04             	mov    0x4(%eax),%eax
  802be9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802bee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf1:	8b 40 04             	mov    0x4(%eax),%eax
  802bf4:	85 c0                	test   %eax,%eax
  802bf6:	74 0f                	je     802c07 <alloc_block_NF+0x475>
  802bf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfb:	8b 40 04             	mov    0x4(%eax),%eax
  802bfe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c01:	8b 12                	mov    (%edx),%edx
  802c03:	89 10                	mov    %edx,(%eax)
  802c05:	eb 0a                	jmp    802c11 <alloc_block_NF+0x47f>
  802c07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0a:	8b 00                	mov    (%eax),%eax
  802c0c:	a3 38 51 80 00       	mov    %eax,0x805138
  802c11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c14:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c24:	a1 44 51 80 00       	mov    0x805144,%eax
  802c29:	48                   	dec    %eax
  802c2a:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802c2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c32:	8b 40 08             	mov    0x8(%eax),%eax
  802c35:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802c3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3d:	e9 1b 01 00 00       	jmp    802d5d <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802c42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c45:	8b 40 0c             	mov    0xc(%eax),%eax
  802c48:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c4b:	0f 86 d1 00 00 00    	jbe    802d22 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802c51:	a1 48 51 80 00       	mov    0x805148,%eax
  802c56:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802c59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5c:	8b 50 08             	mov    0x8(%eax),%edx
  802c5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c62:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802c65:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c68:	8b 55 08             	mov    0x8(%ebp),%edx
  802c6b:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802c6e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c72:	75 17                	jne    802c8b <alloc_block_NF+0x4f9>
  802c74:	83 ec 04             	sub    $0x4,%esp
  802c77:	68 00 41 80 00       	push   $0x804100
  802c7c:	68 1c 01 00 00       	push   $0x11c
  802c81:	68 57 40 80 00       	push   $0x804057
  802c86:	e8 05 d6 ff ff       	call   800290 <_panic>
  802c8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c8e:	8b 00                	mov    (%eax),%eax
  802c90:	85 c0                	test   %eax,%eax
  802c92:	74 10                	je     802ca4 <alloc_block_NF+0x512>
  802c94:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c97:	8b 00                	mov    (%eax),%eax
  802c99:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c9c:	8b 52 04             	mov    0x4(%edx),%edx
  802c9f:	89 50 04             	mov    %edx,0x4(%eax)
  802ca2:	eb 0b                	jmp    802caf <alloc_block_NF+0x51d>
  802ca4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ca7:	8b 40 04             	mov    0x4(%eax),%eax
  802caa:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802caf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cb2:	8b 40 04             	mov    0x4(%eax),%eax
  802cb5:	85 c0                	test   %eax,%eax
  802cb7:	74 0f                	je     802cc8 <alloc_block_NF+0x536>
  802cb9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cbc:	8b 40 04             	mov    0x4(%eax),%eax
  802cbf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802cc2:	8b 12                	mov    (%edx),%edx
  802cc4:	89 10                	mov    %edx,(%eax)
  802cc6:	eb 0a                	jmp    802cd2 <alloc_block_NF+0x540>
  802cc8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ccb:	8b 00                	mov    (%eax),%eax
  802ccd:	a3 48 51 80 00       	mov    %eax,0x805148
  802cd2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cd5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cdb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cde:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ce5:	a1 54 51 80 00       	mov    0x805154,%eax
  802cea:	48                   	dec    %eax
  802ceb:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802cf0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cf3:	8b 40 08             	mov    0x8(%eax),%eax
  802cf6:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802cfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfe:	8b 50 08             	mov    0x8(%eax),%edx
  802d01:	8b 45 08             	mov    0x8(%ebp),%eax
  802d04:	01 c2                	add    %eax,%edx
  802d06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d09:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802d0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0f:	8b 40 0c             	mov    0xc(%eax),%eax
  802d12:	2b 45 08             	sub    0x8(%ebp),%eax
  802d15:	89 c2                	mov    %eax,%edx
  802d17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1a:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802d1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d20:	eb 3b                	jmp    802d5d <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802d22:	a1 40 51 80 00       	mov    0x805140,%eax
  802d27:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d2a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d2e:	74 07                	je     802d37 <alloc_block_NF+0x5a5>
  802d30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d33:	8b 00                	mov    (%eax),%eax
  802d35:	eb 05                	jmp    802d3c <alloc_block_NF+0x5aa>
  802d37:	b8 00 00 00 00       	mov    $0x0,%eax
  802d3c:	a3 40 51 80 00       	mov    %eax,0x805140
  802d41:	a1 40 51 80 00       	mov    0x805140,%eax
  802d46:	85 c0                	test   %eax,%eax
  802d48:	0f 85 2e fe ff ff    	jne    802b7c <alloc_block_NF+0x3ea>
  802d4e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d52:	0f 85 24 fe ff ff    	jne    802b7c <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802d58:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d5d:	c9                   	leave  
  802d5e:	c3                   	ret    

00802d5f <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802d5f:	55                   	push   %ebp
  802d60:	89 e5                	mov    %esp,%ebp
  802d62:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802d65:	a1 38 51 80 00       	mov    0x805138,%eax
  802d6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802d6d:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802d72:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802d75:	a1 38 51 80 00       	mov    0x805138,%eax
  802d7a:	85 c0                	test   %eax,%eax
  802d7c:	74 14                	je     802d92 <insert_sorted_with_merge_freeList+0x33>
  802d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d81:	8b 50 08             	mov    0x8(%eax),%edx
  802d84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d87:	8b 40 08             	mov    0x8(%eax),%eax
  802d8a:	39 c2                	cmp    %eax,%edx
  802d8c:	0f 87 9b 01 00 00    	ja     802f2d <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802d92:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d96:	75 17                	jne    802daf <insert_sorted_with_merge_freeList+0x50>
  802d98:	83 ec 04             	sub    $0x4,%esp
  802d9b:	68 34 40 80 00       	push   $0x804034
  802da0:	68 38 01 00 00       	push   $0x138
  802da5:	68 57 40 80 00       	push   $0x804057
  802daa:	e8 e1 d4 ff ff       	call   800290 <_panic>
  802daf:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802db5:	8b 45 08             	mov    0x8(%ebp),%eax
  802db8:	89 10                	mov    %edx,(%eax)
  802dba:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbd:	8b 00                	mov    (%eax),%eax
  802dbf:	85 c0                	test   %eax,%eax
  802dc1:	74 0d                	je     802dd0 <insert_sorted_with_merge_freeList+0x71>
  802dc3:	a1 38 51 80 00       	mov    0x805138,%eax
  802dc8:	8b 55 08             	mov    0x8(%ebp),%edx
  802dcb:	89 50 04             	mov    %edx,0x4(%eax)
  802dce:	eb 08                	jmp    802dd8 <insert_sorted_with_merge_freeList+0x79>
  802dd0:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802dd8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ddb:	a3 38 51 80 00       	mov    %eax,0x805138
  802de0:	8b 45 08             	mov    0x8(%ebp),%eax
  802de3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dea:	a1 44 51 80 00       	mov    0x805144,%eax
  802def:	40                   	inc    %eax
  802df0:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802df5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802df9:	0f 84 a8 06 00 00    	je     8034a7 <insert_sorted_with_merge_freeList+0x748>
  802dff:	8b 45 08             	mov    0x8(%ebp),%eax
  802e02:	8b 50 08             	mov    0x8(%eax),%edx
  802e05:	8b 45 08             	mov    0x8(%ebp),%eax
  802e08:	8b 40 0c             	mov    0xc(%eax),%eax
  802e0b:	01 c2                	add    %eax,%edx
  802e0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e10:	8b 40 08             	mov    0x8(%eax),%eax
  802e13:	39 c2                	cmp    %eax,%edx
  802e15:	0f 85 8c 06 00 00    	jne    8034a7 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1e:	8b 50 0c             	mov    0xc(%eax),%edx
  802e21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e24:	8b 40 0c             	mov    0xc(%eax),%eax
  802e27:	01 c2                	add    %eax,%edx
  802e29:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2c:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802e2f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e33:	75 17                	jne    802e4c <insert_sorted_with_merge_freeList+0xed>
  802e35:	83 ec 04             	sub    $0x4,%esp
  802e38:	68 00 41 80 00       	push   $0x804100
  802e3d:	68 3c 01 00 00       	push   $0x13c
  802e42:	68 57 40 80 00       	push   $0x804057
  802e47:	e8 44 d4 ff ff       	call   800290 <_panic>
  802e4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e4f:	8b 00                	mov    (%eax),%eax
  802e51:	85 c0                	test   %eax,%eax
  802e53:	74 10                	je     802e65 <insert_sorted_with_merge_freeList+0x106>
  802e55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e58:	8b 00                	mov    (%eax),%eax
  802e5a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e5d:	8b 52 04             	mov    0x4(%edx),%edx
  802e60:	89 50 04             	mov    %edx,0x4(%eax)
  802e63:	eb 0b                	jmp    802e70 <insert_sorted_with_merge_freeList+0x111>
  802e65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e68:	8b 40 04             	mov    0x4(%eax),%eax
  802e6b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e73:	8b 40 04             	mov    0x4(%eax),%eax
  802e76:	85 c0                	test   %eax,%eax
  802e78:	74 0f                	je     802e89 <insert_sorted_with_merge_freeList+0x12a>
  802e7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e7d:	8b 40 04             	mov    0x4(%eax),%eax
  802e80:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e83:	8b 12                	mov    (%edx),%edx
  802e85:	89 10                	mov    %edx,(%eax)
  802e87:	eb 0a                	jmp    802e93 <insert_sorted_with_merge_freeList+0x134>
  802e89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e8c:	8b 00                	mov    (%eax),%eax
  802e8e:	a3 38 51 80 00       	mov    %eax,0x805138
  802e93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e96:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e9f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ea6:	a1 44 51 80 00       	mov    0x805144,%eax
  802eab:	48                   	dec    %eax
  802eac:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802eb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eb4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802ebb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ebe:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802ec5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ec9:	75 17                	jne    802ee2 <insert_sorted_with_merge_freeList+0x183>
  802ecb:	83 ec 04             	sub    $0x4,%esp
  802ece:	68 34 40 80 00       	push   $0x804034
  802ed3:	68 3f 01 00 00       	push   $0x13f
  802ed8:	68 57 40 80 00       	push   $0x804057
  802edd:	e8 ae d3 ff ff       	call   800290 <_panic>
  802ee2:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802ee8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eeb:	89 10                	mov    %edx,(%eax)
  802eed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ef0:	8b 00                	mov    (%eax),%eax
  802ef2:	85 c0                	test   %eax,%eax
  802ef4:	74 0d                	je     802f03 <insert_sorted_with_merge_freeList+0x1a4>
  802ef6:	a1 48 51 80 00       	mov    0x805148,%eax
  802efb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802efe:	89 50 04             	mov    %edx,0x4(%eax)
  802f01:	eb 08                	jmp    802f0b <insert_sorted_with_merge_freeList+0x1ac>
  802f03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f06:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f0e:	a3 48 51 80 00       	mov    %eax,0x805148
  802f13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f16:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f1d:	a1 54 51 80 00       	mov    0x805154,%eax
  802f22:	40                   	inc    %eax
  802f23:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802f28:	e9 7a 05 00 00       	jmp    8034a7 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f30:	8b 50 08             	mov    0x8(%eax),%edx
  802f33:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f36:	8b 40 08             	mov    0x8(%eax),%eax
  802f39:	39 c2                	cmp    %eax,%edx
  802f3b:	0f 82 14 01 00 00    	jb     803055 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802f41:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f44:	8b 50 08             	mov    0x8(%eax),%edx
  802f47:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f4a:	8b 40 0c             	mov    0xc(%eax),%eax
  802f4d:	01 c2                	add    %eax,%edx
  802f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f52:	8b 40 08             	mov    0x8(%eax),%eax
  802f55:	39 c2                	cmp    %eax,%edx
  802f57:	0f 85 90 00 00 00    	jne    802fed <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802f5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f60:	8b 50 0c             	mov    0xc(%eax),%edx
  802f63:	8b 45 08             	mov    0x8(%ebp),%eax
  802f66:	8b 40 0c             	mov    0xc(%eax),%eax
  802f69:	01 c2                	add    %eax,%edx
  802f6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f6e:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802f71:	8b 45 08             	mov    0x8(%ebp),%eax
  802f74:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802f7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802f85:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f89:	75 17                	jne    802fa2 <insert_sorted_with_merge_freeList+0x243>
  802f8b:	83 ec 04             	sub    $0x4,%esp
  802f8e:	68 34 40 80 00       	push   $0x804034
  802f93:	68 49 01 00 00       	push   $0x149
  802f98:	68 57 40 80 00       	push   $0x804057
  802f9d:	e8 ee d2 ff ff       	call   800290 <_panic>
  802fa2:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802fa8:	8b 45 08             	mov    0x8(%ebp),%eax
  802fab:	89 10                	mov    %edx,(%eax)
  802fad:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb0:	8b 00                	mov    (%eax),%eax
  802fb2:	85 c0                	test   %eax,%eax
  802fb4:	74 0d                	je     802fc3 <insert_sorted_with_merge_freeList+0x264>
  802fb6:	a1 48 51 80 00       	mov    0x805148,%eax
  802fbb:	8b 55 08             	mov    0x8(%ebp),%edx
  802fbe:	89 50 04             	mov    %edx,0x4(%eax)
  802fc1:	eb 08                	jmp    802fcb <insert_sorted_with_merge_freeList+0x26c>
  802fc3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  802fce:	a3 48 51 80 00       	mov    %eax,0x805148
  802fd3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fdd:	a1 54 51 80 00       	mov    0x805154,%eax
  802fe2:	40                   	inc    %eax
  802fe3:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802fe8:	e9 bb 04 00 00       	jmp    8034a8 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802fed:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ff1:	75 17                	jne    80300a <insert_sorted_with_merge_freeList+0x2ab>
  802ff3:	83 ec 04             	sub    $0x4,%esp
  802ff6:	68 a8 40 80 00       	push   $0x8040a8
  802ffb:	68 4c 01 00 00       	push   $0x14c
  803000:	68 57 40 80 00       	push   $0x804057
  803005:	e8 86 d2 ff ff       	call   800290 <_panic>
  80300a:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803010:	8b 45 08             	mov    0x8(%ebp),%eax
  803013:	89 50 04             	mov    %edx,0x4(%eax)
  803016:	8b 45 08             	mov    0x8(%ebp),%eax
  803019:	8b 40 04             	mov    0x4(%eax),%eax
  80301c:	85 c0                	test   %eax,%eax
  80301e:	74 0c                	je     80302c <insert_sorted_with_merge_freeList+0x2cd>
  803020:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803025:	8b 55 08             	mov    0x8(%ebp),%edx
  803028:	89 10                	mov    %edx,(%eax)
  80302a:	eb 08                	jmp    803034 <insert_sorted_with_merge_freeList+0x2d5>
  80302c:	8b 45 08             	mov    0x8(%ebp),%eax
  80302f:	a3 38 51 80 00       	mov    %eax,0x805138
  803034:	8b 45 08             	mov    0x8(%ebp),%eax
  803037:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80303c:	8b 45 08             	mov    0x8(%ebp),%eax
  80303f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803045:	a1 44 51 80 00       	mov    0x805144,%eax
  80304a:	40                   	inc    %eax
  80304b:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803050:	e9 53 04 00 00       	jmp    8034a8 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803055:	a1 38 51 80 00       	mov    0x805138,%eax
  80305a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80305d:	e9 15 04 00 00       	jmp    803477 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803062:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803065:	8b 00                	mov    (%eax),%eax
  803067:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  80306a:	8b 45 08             	mov    0x8(%ebp),%eax
  80306d:	8b 50 08             	mov    0x8(%eax),%edx
  803070:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803073:	8b 40 08             	mov    0x8(%eax),%eax
  803076:	39 c2                	cmp    %eax,%edx
  803078:	0f 86 f1 03 00 00    	jbe    80346f <insert_sorted_with_merge_freeList+0x710>
  80307e:	8b 45 08             	mov    0x8(%ebp),%eax
  803081:	8b 50 08             	mov    0x8(%eax),%edx
  803084:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803087:	8b 40 08             	mov    0x8(%eax),%eax
  80308a:	39 c2                	cmp    %eax,%edx
  80308c:	0f 83 dd 03 00 00    	jae    80346f <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803092:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803095:	8b 50 08             	mov    0x8(%eax),%edx
  803098:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309b:	8b 40 0c             	mov    0xc(%eax),%eax
  80309e:	01 c2                	add    %eax,%edx
  8030a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a3:	8b 40 08             	mov    0x8(%eax),%eax
  8030a6:	39 c2                	cmp    %eax,%edx
  8030a8:	0f 85 b9 01 00 00    	jne    803267 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8030ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b1:	8b 50 08             	mov    0x8(%eax),%edx
  8030b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b7:	8b 40 0c             	mov    0xc(%eax),%eax
  8030ba:	01 c2                	add    %eax,%edx
  8030bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030bf:	8b 40 08             	mov    0x8(%eax),%eax
  8030c2:	39 c2                	cmp    %eax,%edx
  8030c4:	0f 85 0d 01 00 00    	jne    8031d7 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8030ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030cd:	8b 50 0c             	mov    0xc(%eax),%edx
  8030d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030d3:	8b 40 0c             	mov    0xc(%eax),%eax
  8030d6:	01 c2                	add    %eax,%edx
  8030d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030db:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8030de:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030e2:	75 17                	jne    8030fb <insert_sorted_with_merge_freeList+0x39c>
  8030e4:	83 ec 04             	sub    $0x4,%esp
  8030e7:	68 00 41 80 00       	push   $0x804100
  8030ec:	68 5c 01 00 00       	push   $0x15c
  8030f1:	68 57 40 80 00       	push   $0x804057
  8030f6:	e8 95 d1 ff ff       	call   800290 <_panic>
  8030fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030fe:	8b 00                	mov    (%eax),%eax
  803100:	85 c0                	test   %eax,%eax
  803102:	74 10                	je     803114 <insert_sorted_with_merge_freeList+0x3b5>
  803104:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803107:	8b 00                	mov    (%eax),%eax
  803109:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80310c:	8b 52 04             	mov    0x4(%edx),%edx
  80310f:	89 50 04             	mov    %edx,0x4(%eax)
  803112:	eb 0b                	jmp    80311f <insert_sorted_with_merge_freeList+0x3c0>
  803114:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803117:	8b 40 04             	mov    0x4(%eax),%eax
  80311a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80311f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803122:	8b 40 04             	mov    0x4(%eax),%eax
  803125:	85 c0                	test   %eax,%eax
  803127:	74 0f                	je     803138 <insert_sorted_with_merge_freeList+0x3d9>
  803129:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80312c:	8b 40 04             	mov    0x4(%eax),%eax
  80312f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803132:	8b 12                	mov    (%edx),%edx
  803134:	89 10                	mov    %edx,(%eax)
  803136:	eb 0a                	jmp    803142 <insert_sorted_with_merge_freeList+0x3e3>
  803138:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80313b:	8b 00                	mov    (%eax),%eax
  80313d:	a3 38 51 80 00       	mov    %eax,0x805138
  803142:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803145:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80314b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80314e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803155:	a1 44 51 80 00       	mov    0x805144,%eax
  80315a:	48                   	dec    %eax
  80315b:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803160:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803163:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  80316a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80316d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803174:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803178:	75 17                	jne    803191 <insert_sorted_with_merge_freeList+0x432>
  80317a:	83 ec 04             	sub    $0x4,%esp
  80317d:	68 34 40 80 00       	push   $0x804034
  803182:	68 5f 01 00 00       	push   $0x15f
  803187:	68 57 40 80 00       	push   $0x804057
  80318c:	e8 ff d0 ff ff       	call   800290 <_panic>
  803191:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803197:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80319a:	89 10                	mov    %edx,(%eax)
  80319c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80319f:	8b 00                	mov    (%eax),%eax
  8031a1:	85 c0                	test   %eax,%eax
  8031a3:	74 0d                	je     8031b2 <insert_sorted_with_merge_freeList+0x453>
  8031a5:	a1 48 51 80 00       	mov    0x805148,%eax
  8031aa:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031ad:	89 50 04             	mov    %edx,0x4(%eax)
  8031b0:	eb 08                	jmp    8031ba <insert_sorted_with_merge_freeList+0x45b>
  8031b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031b5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031bd:	a3 48 51 80 00       	mov    %eax,0x805148
  8031c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031cc:	a1 54 51 80 00       	mov    0x805154,%eax
  8031d1:	40                   	inc    %eax
  8031d2:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8031d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031da:	8b 50 0c             	mov    0xc(%eax),%edx
  8031dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e0:	8b 40 0c             	mov    0xc(%eax),%eax
  8031e3:	01 c2                	add    %eax,%edx
  8031e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e8:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8031eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ee:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8031f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8031ff:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803203:	75 17                	jne    80321c <insert_sorted_with_merge_freeList+0x4bd>
  803205:	83 ec 04             	sub    $0x4,%esp
  803208:	68 34 40 80 00       	push   $0x804034
  80320d:	68 64 01 00 00       	push   $0x164
  803212:	68 57 40 80 00       	push   $0x804057
  803217:	e8 74 d0 ff ff       	call   800290 <_panic>
  80321c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803222:	8b 45 08             	mov    0x8(%ebp),%eax
  803225:	89 10                	mov    %edx,(%eax)
  803227:	8b 45 08             	mov    0x8(%ebp),%eax
  80322a:	8b 00                	mov    (%eax),%eax
  80322c:	85 c0                	test   %eax,%eax
  80322e:	74 0d                	je     80323d <insert_sorted_with_merge_freeList+0x4de>
  803230:	a1 48 51 80 00       	mov    0x805148,%eax
  803235:	8b 55 08             	mov    0x8(%ebp),%edx
  803238:	89 50 04             	mov    %edx,0x4(%eax)
  80323b:	eb 08                	jmp    803245 <insert_sorted_with_merge_freeList+0x4e6>
  80323d:	8b 45 08             	mov    0x8(%ebp),%eax
  803240:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803245:	8b 45 08             	mov    0x8(%ebp),%eax
  803248:	a3 48 51 80 00       	mov    %eax,0x805148
  80324d:	8b 45 08             	mov    0x8(%ebp),%eax
  803250:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803257:	a1 54 51 80 00       	mov    0x805154,%eax
  80325c:	40                   	inc    %eax
  80325d:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803262:	e9 41 02 00 00       	jmp    8034a8 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803267:	8b 45 08             	mov    0x8(%ebp),%eax
  80326a:	8b 50 08             	mov    0x8(%eax),%edx
  80326d:	8b 45 08             	mov    0x8(%ebp),%eax
  803270:	8b 40 0c             	mov    0xc(%eax),%eax
  803273:	01 c2                	add    %eax,%edx
  803275:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803278:	8b 40 08             	mov    0x8(%eax),%eax
  80327b:	39 c2                	cmp    %eax,%edx
  80327d:	0f 85 7c 01 00 00    	jne    8033ff <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803283:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803287:	74 06                	je     80328f <insert_sorted_with_merge_freeList+0x530>
  803289:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80328d:	75 17                	jne    8032a6 <insert_sorted_with_merge_freeList+0x547>
  80328f:	83 ec 04             	sub    $0x4,%esp
  803292:	68 70 40 80 00       	push   $0x804070
  803297:	68 69 01 00 00       	push   $0x169
  80329c:	68 57 40 80 00       	push   $0x804057
  8032a1:	e8 ea cf ff ff       	call   800290 <_panic>
  8032a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032a9:	8b 50 04             	mov    0x4(%eax),%edx
  8032ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8032af:	89 50 04             	mov    %edx,0x4(%eax)
  8032b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032b8:	89 10                	mov    %edx,(%eax)
  8032ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032bd:	8b 40 04             	mov    0x4(%eax),%eax
  8032c0:	85 c0                	test   %eax,%eax
  8032c2:	74 0d                	je     8032d1 <insert_sorted_with_merge_freeList+0x572>
  8032c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032c7:	8b 40 04             	mov    0x4(%eax),%eax
  8032ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8032cd:	89 10                	mov    %edx,(%eax)
  8032cf:	eb 08                	jmp    8032d9 <insert_sorted_with_merge_freeList+0x57a>
  8032d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d4:	a3 38 51 80 00       	mov    %eax,0x805138
  8032d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8032df:	89 50 04             	mov    %edx,0x4(%eax)
  8032e2:	a1 44 51 80 00       	mov    0x805144,%eax
  8032e7:	40                   	inc    %eax
  8032e8:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8032ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f0:	8b 50 0c             	mov    0xc(%eax),%edx
  8032f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032f6:	8b 40 0c             	mov    0xc(%eax),%eax
  8032f9:	01 c2                	add    %eax,%edx
  8032fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fe:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803301:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803305:	75 17                	jne    80331e <insert_sorted_with_merge_freeList+0x5bf>
  803307:	83 ec 04             	sub    $0x4,%esp
  80330a:	68 00 41 80 00       	push   $0x804100
  80330f:	68 6b 01 00 00       	push   $0x16b
  803314:	68 57 40 80 00       	push   $0x804057
  803319:	e8 72 cf ff ff       	call   800290 <_panic>
  80331e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803321:	8b 00                	mov    (%eax),%eax
  803323:	85 c0                	test   %eax,%eax
  803325:	74 10                	je     803337 <insert_sorted_with_merge_freeList+0x5d8>
  803327:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80332a:	8b 00                	mov    (%eax),%eax
  80332c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80332f:	8b 52 04             	mov    0x4(%edx),%edx
  803332:	89 50 04             	mov    %edx,0x4(%eax)
  803335:	eb 0b                	jmp    803342 <insert_sorted_with_merge_freeList+0x5e3>
  803337:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80333a:	8b 40 04             	mov    0x4(%eax),%eax
  80333d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803342:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803345:	8b 40 04             	mov    0x4(%eax),%eax
  803348:	85 c0                	test   %eax,%eax
  80334a:	74 0f                	je     80335b <insert_sorted_with_merge_freeList+0x5fc>
  80334c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80334f:	8b 40 04             	mov    0x4(%eax),%eax
  803352:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803355:	8b 12                	mov    (%edx),%edx
  803357:	89 10                	mov    %edx,(%eax)
  803359:	eb 0a                	jmp    803365 <insert_sorted_with_merge_freeList+0x606>
  80335b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80335e:	8b 00                	mov    (%eax),%eax
  803360:	a3 38 51 80 00       	mov    %eax,0x805138
  803365:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803368:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80336e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803371:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803378:	a1 44 51 80 00       	mov    0x805144,%eax
  80337d:	48                   	dec    %eax
  80337e:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803383:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803386:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  80338d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803390:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803397:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80339b:	75 17                	jne    8033b4 <insert_sorted_with_merge_freeList+0x655>
  80339d:	83 ec 04             	sub    $0x4,%esp
  8033a0:	68 34 40 80 00       	push   $0x804034
  8033a5:	68 6e 01 00 00       	push   $0x16e
  8033aa:	68 57 40 80 00       	push   $0x804057
  8033af:	e8 dc ce ff ff       	call   800290 <_panic>
  8033b4:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033bd:	89 10                	mov    %edx,(%eax)
  8033bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033c2:	8b 00                	mov    (%eax),%eax
  8033c4:	85 c0                	test   %eax,%eax
  8033c6:	74 0d                	je     8033d5 <insert_sorted_with_merge_freeList+0x676>
  8033c8:	a1 48 51 80 00       	mov    0x805148,%eax
  8033cd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033d0:	89 50 04             	mov    %edx,0x4(%eax)
  8033d3:	eb 08                	jmp    8033dd <insert_sorted_with_merge_freeList+0x67e>
  8033d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033d8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033e0:	a3 48 51 80 00       	mov    %eax,0x805148
  8033e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033e8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033ef:	a1 54 51 80 00       	mov    0x805154,%eax
  8033f4:	40                   	inc    %eax
  8033f5:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8033fa:	e9 a9 00 00 00       	jmp    8034a8 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8033ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803403:	74 06                	je     80340b <insert_sorted_with_merge_freeList+0x6ac>
  803405:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803409:	75 17                	jne    803422 <insert_sorted_with_merge_freeList+0x6c3>
  80340b:	83 ec 04             	sub    $0x4,%esp
  80340e:	68 cc 40 80 00       	push   $0x8040cc
  803413:	68 73 01 00 00       	push   $0x173
  803418:	68 57 40 80 00       	push   $0x804057
  80341d:	e8 6e ce ff ff       	call   800290 <_panic>
  803422:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803425:	8b 10                	mov    (%eax),%edx
  803427:	8b 45 08             	mov    0x8(%ebp),%eax
  80342a:	89 10                	mov    %edx,(%eax)
  80342c:	8b 45 08             	mov    0x8(%ebp),%eax
  80342f:	8b 00                	mov    (%eax),%eax
  803431:	85 c0                	test   %eax,%eax
  803433:	74 0b                	je     803440 <insert_sorted_with_merge_freeList+0x6e1>
  803435:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803438:	8b 00                	mov    (%eax),%eax
  80343a:	8b 55 08             	mov    0x8(%ebp),%edx
  80343d:	89 50 04             	mov    %edx,0x4(%eax)
  803440:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803443:	8b 55 08             	mov    0x8(%ebp),%edx
  803446:	89 10                	mov    %edx,(%eax)
  803448:	8b 45 08             	mov    0x8(%ebp),%eax
  80344b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80344e:	89 50 04             	mov    %edx,0x4(%eax)
  803451:	8b 45 08             	mov    0x8(%ebp),%eax
  803454:	8b 00                	mov    (%eax),%eax
  803456:	85 c0                	test   %eax,%eax
  803458:	75 08                	jne    803462 <insert_sorted_with_merge_freeList+0x703>
  80345a:	8b 45 08             	mov    0x8(%ebp),%eax
  80345d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803462:	a1 44 51 80 00       	mov    0x805144,%eax
  803467:	40                   	inc    %eax
  803468:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  80346d:	eb 39                	jmp    8034a8 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80346f:	a1 40 51 80 00       	mov    0x805140,%eax
  803474:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803477:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80347b:	74 07                	je     803484 <insert_sorted_with_merge_freeList+0x725>
  80347d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803480:	8b 00                	mov    (%eax),%eax
  803482:	eb 05                	jmp    803489 <insert_sorted_with_merge_freeList+0x72a>
  803484:	b8 00 00 00 00       	mov    $0x0,%eax
  803489:	a3 40 51 80 00       	mov    %eax,0x805140
  80348e:	a1 40 51 80 00       	mov    0x805140,%eax
  803493:	85 c0                	test   %eax,%eax
  803495:	0f 85 c7 fb ff ff    	jne    803062 <insert_sorted_with_merge_freeList+0x303>
  80349b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80349f:	0f 85 bd fb ff ff    	jne    803062 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8034a5:	eb 01                	jmp    8034a8 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8034a7:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8034a8:	90                   	nop
  8034a9:	c9                   	leave  
  8034aa:	c3                   	ret    

008034ab <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8034ab:	55                   	push   %ebp
  8034ac:	89 e5                	mov    %esp,%ebp
  8034ae:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8034b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8034b4:	89 d0                	mov    %edx,%eax
  8034b6:	c1 e0 02             	shl    $0x2,%eax
  8034b9:	01 d0                	add    %edx,%eax
  8034bb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8034c2:	01 d0                	add    %edx,%eax
  8034c4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8034cb:	01 d0                	add    %edx,%eax
  8034cd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8034d4:	01 d0                	add    %edx,%eax
  8034d6:	c1 e0 04             	shl    $0x4,%eax
  8034d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8034dc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8034e3:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8034e6:	83 ec 0c             	sub    $0xc,%esp
  8034e9:	50                   	push   %eax
  8034ea:	e8 26 e7 ff ff       	call   801c15 <sys_get_virtual_time>
  8034ef:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8034f2:	eb 41                	jmp    803535 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8034f4:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8034f7:	83 ec 0c             	sub    $0xc,%esp
  8034fa:	50                   	push   %eax
  8034fb:	e8 15 e7 ff ff       	call   801c15 <sys_get_virtual_time>
  803500:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803503:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803506:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803509:	29 c2                	sub    %eax,%edx
  80350b:	89 d0                	mov    %edx,%eax
  80350d:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803510:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803513:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803516:	89 d1                	mov    %edx,%ecx
  803518:	29 c1                	sub    %eax,%ecx
  80351a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80351d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803520:	39 c2                	cmp    %eax,%edx
  803522:	0f 97 c0             	seta   %al
  803525:	0f b6 c0             	movzbl %al,%eax
  803528:	29 c1                	sub    %eax,%ecx
  80352a:	89 c8                	mov    %ecx,%eax
  80352c:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  80352f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803532:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803535:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803538:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80353b:	72 b7                	jb     8034f4 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  80353d:	90                   	nop
  80353e:	c9                   	leave  
  80353f:	c3                   	ret    

00803540 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803540:	55                   	push   %ebp
  803541:	89 e5                	mov    %esp,%ebp
  803543:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803546:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  80354d:	eb 03                	jmp    803552 <busy_wait+0x12>
  80354f:	ff 45 fc             	incl   -0x4(%ebp)
  803552:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803555:	3b 45 08             	cmp    0x8(%ebp),%eax
  803558:	72 f5                	jb     80354f <busy_wait+0xf>
	return i;
  80355a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80355d:	c9                   	leave  
  80355e:	c3                   	ret    
  80355f:	90                   	nop

00803560 <__udivdi3>:
  803560:	55                   	push   %ebp
  803561:	57                   	push   %edi
  803562:	56                   	push   %esi
  803563:	53                   	push   %ebx
  803564:	83 ec 1c             	sub    $0x1c,%esp
  803567:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80356b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80356f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803573:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803577:	89 ca                	mov    %ecx,%edx
  803579:	89 f8                	mov    %edi,%eax
  80357b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80357f:	85 f6                	test   %esi,%esi
  803581:	75 2d                	jne    8035b0 <__udivdi3+0x50>
  803583:	39 cf                	cmp    %ecx,%edi
  803585:	77 65                	ja     8035ec <__udivdi3+0x8c>
  803587:	89 fd                	mov    %edi,%ebp
  803589:	85 ff                	test   %edi,%edi
  80358b:	75 0b                	jne    803598 <__udivdi3+0x38>
  80358d:	b8 01 00 00 00       	mov    $0x1,%eax
  803592:	31 d2                	xor    %edx,%edx
  803594:	f7 f7                	div    %edi
  803596:	89 c5                	mov    %eax,%ebp
  803598:	31 d2                	xor    %edx,%edx
  80359a:	89 c8                	mov    %ecx,%eax
  80359c:	f7 f5                	div    %ebp
  80359e:	89 c1                	mov    %eax,%ecx
  8035a0:	89 d8                	mov    %ebx,%eax
  8035a2:	f7 f5                	div    %ebp
  8035a4:	89 cf                	mov    %ecx,%edi
  8035a6:	89 fa                	mov    %edi,%edx
  8035a8:	83 c4 1c             	add    $0x1c,%esp
  8035ab:	5b                   	pop    %ebx
  8035ac:	5e                   	pop    %esi
  8035ad:	5f                   	pop    %edi
  8035ae:	5d                   	pop    %ebp
  8035af:	c3                   	ret    
  8035b0:	39 ce                	cmp    %ecx,%esi
  8035b2:	77 28                	ja     8035dc <__udivdi3+0x7c>
  8035b4:	0f bd fe             	bsr    %esi,%edi
  8035b7:	83 f7 1f             	xor    $0x1f,%edi
  8035ba:	75 40                	jne    8035fc <__udivdi3+0x9c>
  8035bc:	39 ce                	cmp    %ecx,%esi
  8035be:	72 0a                	jb     8035ca <__udivdi3+0x6a>
  8035c0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8035c4:	0f 87 9e 00 00 00    	ja     803668 <__udivdi3+0x108>
  8035ca:	b8 01 00 00 00       	mov    $0x1,%eax
  8035cf:	89 fa                	mov    %edi,%edx
  8035d1:	83 c4 1c             	add    $0x1c,%esp
  8035d4:	5b                   	pop    %ebx
  8035d5:	5e                   	pop    %esi
  8035d6:	5f                   	pop    %edi
  8035d7:	5d                   	pop    %ebp
  8035d8:	c3                   	ret    
  8035d9:	8d 76 00             	lea    0x0(%esi),%esi
  8035dc:	31 ff                	xor    %edi,%edi
  8035de:	31 c0                	xor    %eax,%eax
  8035e0:	89 fa                	mov    %edi,%edx
  8035e2:	83 c4 1c             	add    $0x1c,%esp
  8035e5:	5b                   	pop    %ebx
  8035e6:	5e                   	pop    %esi
  8035e7:	5f                   	pop    %edi
  8035e8:	5d                   	pop    %ebp
  8035e9:	c3                   	ret    
  8035ea:	66 90                	xchg   %ax,%ax
  8035ec:	89 d8                	mov    %ebx,%eax
  8035ee:	f7 f7                	div    %edi
  8035f0:	31 ff                	xor    %edi,%edi
  8035f2:	89 fa                	mov    %edi,%edx
  8035f4:	83 c4 1c             	add    $0x1c,%esp
  8035f7:	5b                   	pop    %ebx
  8035f8:	5e                   	pop    %esi
  8035f9:	5f                   	pop    %edi
  8035fa:	5d                   	pop    %ebp
  8035fb:	c3                   	ret    
  8035fc:	bd 20 00 00 00       	mov    $0x20,%ebp
  803601:	89 eb                	mov    %ebp,%ebx
  803603:	29 fb                	sub    %edi,%ebx
  803605:	89 f9                	mov    %edi,%ecx
  803607:	d3 e6                	shl    %cl,%esi
  803609:	89 c5                	mov    %eax,%ebp
  80360b:	88 d9                	mov    %bl,%cl
  80360d:	d3 ed                	shr    %cl,%ebp
  80360f:	89 e9                	mov    %ebp,%ecx
  803611:	09 f1                	or     %esi,%ecx
  803613:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803617:	89 f9                	mov    %edi,%ecx
  803619:	d3 e0                	shl    %cl,%eax
  80361b:	89 c5                	mov    %eax,%ebp
  80361d:	89 d6                	mov    %edx,%esi
  80361f:	88 d9                	mov    %bl,%cl
  803621:	d3 ee                	shr    %cl,%esi
  803623:	89 f9                	mov    %edi,%ecx
  803625:	d3 e2                	shl    %cl,%edx
  803627:	8b 44 24 08          	mov    0x8(%esp),%eax
  80362b:	88 d9                	mov    %bl,%cl
  80362d:	d3 e8                	shr    %cl,%eax
  80362f:	09 c2                	or     %eax,%edx
  803631:	89 d0                	mov    %edx,%eax
  803633:	89 f2                	mov    %esi,%edx
  803635:	f7 74 24 0c          	divl   0xc(%esp)
  803639:	89 d6                	mov    %edx,%esi
  80363b:	89 c3                	mov    %eax,%ebx
  80363d:	f7 e5                	mul    %ebp
  80363f:	39 d6                	cmp    %edx,%esi
  803641:	72 19                	jb     80365c <__udivdi3+0xfc>
  803643:	74 0b                	je     803650 <__udivdi3+0xf0>
  803645:	89 d8                	mov    %ebx,%eax
  803647:	31 ff                	xor    %edi,%edi
  803649:	e9 58 ff ff ff       	jmp    8035a6 <__udivdi3+0x46>
  80364e:	66 90                	xchg   %ax,%ax
  803650:	8b 54 24 08          	mov    0x8(%esp),%edx
  803654:	89 f9                	mov    %edi,%ecx
  803656:	d3 e2                	shl    %cl,%edx
  803658:	39 c2                	cmp    %eax,%edx
  80365a:	73 e9                	jae    803645 <__udivdi3+0xe5>
  80365c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80365f:	31 ff                	xor    %edi,%edi
  803661:	e9 40 ff ff ff       	jmp    8035a6 <__udivdi3+0x46>
  803666:	66 90                	xchg   %ax,%ax
  803668:	31 c0                	xor    %eax,%eax
  80366a:	e9 37 ff ff ff       	jmp    8035a6 <__udivdi3+0x46>
  80366f:	90                   	nop

00803670 <__umoddi3>:
  803670:	55                   	push   %ebp
  803671:	57                   	push   %edi
  803672:	56                   	push   %esi
  803673:	53                   	push   %ebx
  803674:	83 ec 1c             	sub    $0x1c,%esp
  803677:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80367b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80367f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803683:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803687:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80368b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80368f:	89 f3                	mov    %esi,%ebx
  803691:	89 fa                	mov    %edi,%edx
  803693:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803697:	89 34 24             	mov    %esi,(%esp)
  80369a:	85 c0                	test   %eax,%eax
  80369c:	75 1a                	jne    8036b8 <__umoddi3+0x48>
  80369e:	39 f7                	cmp    %esi,%edi
  8036a0:	0f 86 a2 00 00 00    	jbe    803748 <__umoddi3+0xd8>
  8036a6:	89 c8                	mov    %ecx,%eax
  8036a8:	89 f2                	mov    %esi,%edx
  8036aa:	f7 f7                	div    %edi
  8036ac:	89 d0                	mov    %edx,%eax
  8036ae:	31 d2                	xor    %edx,%edx
  8036b0:	83 c4 1c             	add    $0x1c,%esp
  8036b3:	5b                   	pop    %ebx
  8036b4:	5e                   	pop    %esi
  8036b5:	5f                   	pop    %edi
  8036b6:	5d                   	pop    %ebp
  8036b7:	c3                   	ret    
  8036b8:	39 f0                	cmp    %esi,%eax
  8036ba:	0f 87 ac 00 00 00    	ja     80376c <__umoddi3+0xfc>
  8036c0:	0f bd e8             	bsr    %eax,%ebp
  8036c3:	83 f5 1f             	xor    $0x1f,%ebp
  8036c6:	0f 84 ac 00 00 00    	je     803778 <__umoddi3+0x108>
  8036cc:	bf 20 00 00 00       	mov    $0x20,%edi
  8036d1:	29 ef                	sub    %ebp,%edi
  8036d3:	89 fe                	mov    %edi,%esi
  8036d5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8036d9:	89 e9                	mov    %ebp,%ecx
  8036db:	d3 e0                	shl    %cl,%eax
  8036dd:	89 d7                	mov    %edx,%edi
  8036df:	89 f1                	mov    %esi,%ecx
  8036e1:	d3 ef                	shr    %cl,%edi
  8036e3:	09 c7                	or     %eax,%edi
  8036e5:	89 e9                	mov    %ebp,%ecx
  8036e7:	d3 e2                	shl    %cl,%edx
  8036e9:	89 14 24             	mov    %edx,(%esp)
  8036ec:	89 d8                	mov    %ebx,%eax
  8036ee:	d3 e0                	shl    %cl,%eax
  8036f0:	89 c2                	mov    %eax,%edx
  8036f2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8036f6:	d3 e0                	shl    %cl,%eax
  8036f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8036fc:	8b 44 24 08          	mov    0x8(%esp),%eax
  803700:	89 f1                	mov    %esi,%ecx
  803702:	d3 e8                	shr    %cl,%eax
  803704:	09 d0                	or     %edx,%eax
  803706:	d3 eb                	shr    %cl,%ebx
  803708:	89 da                	mov    %ebx,%edx
  80370a:	f7 f7                	div    %edi
  80370c:	89 d3                	mov    %edx,%ebx
  80370e:	f7 24 24             	mull   (%esp)
  803711:	89 c6                	mov    %eax,%esi
  803713:	89 d1                	mov    %edx,%ecx
  803715:	39 d3                	cmp    %edx,%ebx
  803717:	0f 82 87 00 00 00    	jb     8037a4 <__umoddi3+0x134>
  80371d:	0f 84 91 00 00 00    	je     8037b4 <__umoddi3+0x144>
  803723:	8b 54 24 04          	mov    0x4(%esp),%edx
  803727:	29 f2                	sub    %esi,%edx
  803729:	19 cb                	sbb    %ecx,%ebx
  80372b:	89 d8                	mov    %ebx,%eax
  80372d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803731:	d3 e0                	shl    %cl,%eax
  803733:	89 e9                	mov    %ebp,%ecx
  803735:	d3 ea                	shr    %cl,%edx
  803737:	09 d0                	or     %edx,%eax
  803739:	89 e9                	mov    %ebp,%ecx
  80373b:	d3 eb                	shr    %cl,%ebx
  80373d:	89 da                	mov    %ebx,%edx
  80373f:	83 c4 1c             	add    $0x1c,%esp
  803742:	5b                   	pop    %ebx
  803743:	5e                   	pop    %esi
  803744:	5f                   	pop    %edi
  803745:	5d                   	pop    %ebp
  803746:	c3                   	ret    
  803747:	90                   	nop
  803748:	89 fd                	mov    %edi,%ebp
  80374a:	85 ff                	test   %edi,%edi
  80374c:	75 0b                	jne    803759 <__umoddi3+0xe9>
  80374e:	b8 01 00 00 00       	mov    $0x1,%eax
  803753:	31 d2                	xor    %edx,%edx
  803755:	f7 f7                	div    %edi
  803757:	89 c5                	mov    %eax,%ebp
  803759:	89 f0                	mov    %esi,%eax
  80375b:	31 d2                	xor    %edx,%edx
  80375d:	f7 f5                	div    %ebp
  80375f:	89 c8                	mov    %ecx,%eax
  803761:	f7 f5                	div    %ebp
  803763:	89 d0                	mov    %edx,%eax
  803765:	e9 44 ff ff ff       	jmp    8036ae <__umoddi3+0x3e>
  80376a:	66 90                	xchg   %ax,%ax
  80376c:	89 c8                	mov    %ecx,%eax
  80376e:	89 f2                	mov    %esi,%edx
  803770:	83 c4 1c             	add    $0x1c,%esp
  803773:	5b                   	pop    %ebx
  803774:	5e                   	pop    %esi
  803775:	5f                   	pop    %edi
  803776:	5d                   	pop    %ebp
  803777:	c3                   	ret    
  803778:	3b 04 24             	cmp    (%esp),%eax
  80377b:	72 06                	jb     803783 <__umoddi3+0x113>
  80377d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803781:	77 0f                	ja     803792 <__umoddi3+0x122>
  803783:	89 f2                	mov    %esi,%edx
  803785:	29 f9                	sub    %edi,%ecx
  803787:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80378b:	89 14 24             	mov    %edx,(%esp)
  80378e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803792:	8b 44 24 04          	mov    0x4(%esp),%eax
  803796:	8b 14 24             	mov    (%esp),%edx
  803799:	83 c4 1c             	add    $0x1c,%esp
  80379c:	5b                   	pop    %ebx
  80379d:	5e                   	pop    %esi
  80379e:	5f                   	pop    %edi
  80379f:	5d                   	pop    %ebp
  8037a0:	c3                   	ret    
  8037a1:	8d 76 00             	lea    0x0(%esi),%esi
  8037a4:	2b 04 24             	sub    (%esp),%eax
  8037a7:	19 fa                	sbb    %edi,%edx
  8037a9:	89 d1                	mov    %edx,%ecx
  8037ab:	89 c6                	mov    %eax,%esi
  8037ad:	e9 71 ff ff ff       	jmp    803723 <__umoddi3+0xb3>
  8037b2:	66 90                	xchg   %ax,%ax
  8037b4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8037b8:	72 ea                	jb     8037a4 <__umoddi3+0x134>
  8037ba:	89 d9                	mov    %ebx,%ecx
  8037bc:	e9 62 ff ff ff       	jmp    803723 <__umoddi3+0xb3>
