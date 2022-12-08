
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
  80008c:	68 e0 35 80 00       	push   $0x8035e0
  800091:	6a 12                	push   $0x12
  800093:	68 fc 35 80 00       	push   $0x8035fc
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
  8000aa:	e8 36 19 00 00       	call   8019e5 <sys_getparentenvid>
  8000af:	83 ec 08             	sub    $0x8,%esp
  8000b2:	68 19 36 80 00       	push   $0x803619
  8000b7:	50                   	push   %eax
  8000b8:	e8 8b 14 00 00       	call   801548 <sget>
  8000bd:	83 c4 10             	add    $0x10,%esp
  8000c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("Slave B1 env used x (getSharedObject)\n");
  8000c3:	83 ec 0c             	sub    $0xc,%esp
  8000c6:	68 1c 36 80 00       	push   $0x80361c
  8000cb:	e8 74 04 00 00       	call   800544 <cprintf>
  8000d0:	83 c4 10             	add    $0x10,%esp
	//To indicate that it's successfully got x
	inctst();
  8000d3:	e8 32 1a 00 00       	call   801b0a <inctst>
	cprintf("Slave B1 please be patient ...\n");
  8000d8:	83 ec 0c             	sub    $0xc,%esp
  8000db:	68 44 36 80 00       	push   $0x803644
  8000e0:	e8 5f 04 00 00       	call   800544 <cprintf>
  8000e5:	83 c4 10             	add    $0x10,%esp

	//sleep a while to allow the master to remove x & z
	env_sleep(6000);
  8000e8:	83 ec 0c             	sub    $0xc,%esp
  8000eb:	68 70 17 00 00       	push   $0x1770
  8000f0:	e8 b9 31 00 00       	call   8032ae <env_sleep>
  8000f5:	83 c4 10             	add    $0x10,%esp

	int freeFrames = sys_calculate_free_frames() ;
  8000f8:	e8 ef 15 00 00       	call   8016ec <sys_calculate_free_frames>
  8000fd:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sfree(x);
  800100:	83 ec 0c             	sub    $0xc,%esp
  800103:	ff 75 ec             	pushl  -0x14(%ebp)
  800106:	e8 81 14 00 00       	call   80158c <sfree>
  80010b:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave B1 env removed x\n");
  80010e:	83 ec 0c             	sub    $0xc,%esp
  800111:	68 64 36 80 00       	push   $0x803664
  800116:	e8 29 04 00 00       	call   800544 <cprintf>
  80011b:	83 c4 10             	add    $0x10,%esp
	int expected = (1+1) + (1+1);
  80011e:	c7 45 e4 04 00 00 00 	movl   $0x4,-0x1c(%ebp)
	if ((sys_calculate_free_frames() - freeFrames) !=  expected) panic("B1 wrong free: frames removed not equal 4 !, correct frames to be removed are 4:\nfrom the env: 1 table and 1 for frame of x\nframes_storage of x: should be cleared now\n");
  800125:	e8 c2 15 00 00       	call   8016ec <sys_calculate_free_frames>
  80012a:	89 c2                	mov    %eax,%edx
  80012c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80012f:	29 c2                	sub    %eax,%edx
  800131:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800134:	39 c2                	cmp    %eax,%edx
  800136:	74 14                	je     80014c <_main+0x114>
  800138:	83 ec 04             	sub    $0x4,%esp
  80013b:	68 7c 36 80 00       	push   $0x80367c
  800140:	6a 27                	push   $0x27
  800142:	68 fc 35 80 00       	push   $0x8035fc
  800147:	e8 44 01 00 00       	call   800290 <_panic>

	//To indicate that it's completed successfully
	inctst();
  80014c:	e8 b9 19 00 00       	call   801b0a <inctst>
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
  80015a:	e8 6d 18 00 00       	call   8019cc <sys_getenvindex>
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
  8001c5:	e8 0f 16 00 00       	call   8017d9 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001ca:	83 ec 0c             	sub    $0xc,%esp
  8001cd:	68 3c 37 80 00       	push   $0x80373c
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
  8001f5:	68 64 37 80 00       	push   $0x803764
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
  800226:	68 8c 37 80 00       	push   $0x80378c
  80022b:	e8 14 03 00 00       	call   800544 <cprintf>
  800230:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800233:	a1 20 40 80 00       	mov    0x804020,%eax
  800238:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80023e:	83 ec 08             	sub    $0x8,%esp
  800241:	50                   	push   %eax
  800242:	68 e4 37 80 00       	push   $0x8037e4
  800247:	e8 f8 02 00 00       	call   800544 <cprintf>
  80024c:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80024f:	83 ec 0c             	sub    $0xc,%esp
  800252:	68 3c 37 80 00       	push   $0x80373c
  800257:	e8 e8 02 00 00       	call   800544 <cprintf>
  80025c:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80025f:	e8 8f 15 00 00       	call   8017f3 <sys_enable_interrupt>

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
  800277:	e8 1c 17 00 00       	call   801998 <sys_destroy_env>
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
  800288:	e8 71 17 00 00       	call   8019fe <sys_exit_env>
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
  8002b1:	68 f8 37 80 00       	push   $0x8037f8
  8002b6:	e8 89 02 00 00       	call   800544 <cprintf>
  8002bb:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002be:	a1 00 40 80 00       	mov    0x804000,%eax
  8002c3:	ff 75 0c             	pushl  0xc(%ebp)
  8002c6:	ff 75 08             	pushl  0x8(%ebp)
  8002c9:	50                   	push   %eax
  8002ca:	68 fd 37 80 00       	push   $0x8037fd
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
  8002ee:	68 19 38 80 00       	push   $0x803819
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
  80031a:	68 1c 38 80 00       	push   $0x80381c
  80031f:	6a 26                	push   $0x26
  800321:	68 68 38 80 00       	push   $0x803868
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
  8003ec:	68 74 38 80 00       	push   $0x803874
  8003f1:	6a 3a                	push   $0x3a
  8003f3:	68 68 38 80 00       	push   $0x803868
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
  80045c:	68 c8 38 80 00       	push   $0x8038c8
  800461:	6a 44                	push   $0x44
  800463:	68 68 38 80 00       	push   $0x803868
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
  8004b6:	e8 70 11 00 00       	call   80162b <sys_cputs>
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
  80052d:	e8 f9 10 00 00       	call   80162b <sys_cputs>
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
  800577:	e8 5d 12 00 00       	call   8017d9 <sys_disable_interrupt>
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
  800597:	e8 57 12 00 00       	call   8017f3 <sys_enable_interrupt>
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
  8005e1:	e8 7e 2d 00 00       	call   803364 <__udivdi3>
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
  800631:	e8 3e 2e 00 00       	call   803474 <__umoddi3>
  800636:	83 c4 10             	add    $0x10,%esp
  800639:	05 34 3b 80 00       	add    $0x803b34,%eax
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
  80078c:	8b 04 85 58 3b 80 00 	mov    0x803b58(,%eax,4),%eax
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
  80086d:	8b 34 9d a0 39 80 00 	mov    0x8039a0(,%ebx,4),%esi
  800874:	85 f6                	test   %esi,%esi
  800876:	75 19                	jne    800891 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800878:	53                   	push   %ebx
  800879:	68 45 3b 80 00       	push   $0x803b45
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
  800892:	68 4e 3b 80 00       	push   $0x803b4e
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
  8008bf:	be 51 3b 80 00       	mov    $0x803b51,%esi
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
  8012e5:	68 b0 3c 80 00       	push   $0x803cb0
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
  8013b5:	e8 b5 03 00 00       	call   80176f <sys_allocate_chunk>
  8013ba:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013bd:	a1 20 41 80 00       	mov    0x804120,%eax
  8013c2:	83 ec 0c             	sub    $0xc,%esp
  8013c5:	50                   	push   %eax
  8013c6:	e8 2a 0a 00 00       	call   801df5 <initialize_MemBlocksList>
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
  8013f3:	68 d5 3c 80 00       	push   $0x803cd5
  8013f8:	6a 33                	push   $0x33
  8013fa:	68 f3 3c 80 00       	push   $0x803cf3
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
  801472:	68 00 3d 80 00       	push   $0x803d00
  801477:	6a 34                	push   $0x34
  801479:	68 f3 3c 80 00       	push   $0x803cf3
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
  8014e7:	68 24 3d 80 00       	push   $0x803d24
  8014ec:	6a 46                	push   $0x46
  8014ee:	68 f3 3c 80 00       	push   $0x803cf3
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
  801503:	68 4c 3d 80 00       	push   $0x803d4c
  801508:	6a 61                	push   $0x61
  80150a:	68 f3 3c 80 00       	push   $0x803cf3
  80150f:	e8 7c ed ff ff       	call   800290 <_panic>

00801514 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801514:	55                   	push   %ebp
  801515:	89 e5                	mov    %esp,%ebp
  801517:	83 ec 18             	sub    $0x18,%esp
  80151a:	8b 45 10             	mov    0x10(%ebp),%eax
  80151d:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801520:	e8 a9 fd ff ff       	call   8012ce <InitializeUHeap>
	if (size == 0) return NULL ;
  801525:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801529:	75 07                	jne    801532 <smalloc+0x1e>
  80152b:	b8 00 00 00 00       	mov    $0x0,%eax
  801530:	eb 14                	jmp    801546 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801532:	83 ec 04             	sub    $0x4,%esp
  801535:	68 70 3d 80 00       	push   $0x803d70
  80153a:	6a 76                	push   $0x76
  80153c:	68 f3 3c 80 00       	push   $0x803cf3
  801541:	e8 4a ed ff ff       	call   800290 <_panic>

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801546:	c9                   	leave  
  801547:	c3                   	ret    

00801548 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801548:	55                   	push   %ebp
  801549:	89 e5                	mov    %esp,%ebp
  80154b:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80154e:	e8 7b fd ff ff       	call   8012ce <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801553:	83 ec 04             	sub    $0x4,%esp
  801556:	68 98 3d 80 00       	push   $0x803d98
  80155b:	68 93 00 00 00       	push   $0x93
  801560:	68 f3 3c 80 00       	push   $0x803cf3
  801565:	e8 26 ed ff ff       	call   800290 <_panic>

0080156a <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80156a:	55                   	push   %ebp
  80156b:	89 e5                	mov    %esp,%ebp
  80156d:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801570:	e8 59 fd ff ff       	call   8012ce <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801575:	83 ec 04             	sub    $0x4,%esp
  801578:	68 bc 3d 80 00       	push   $0x803dbc
  80157d:	68 c5 00 00 00       	push   $0xc5
  801582:	68 f3 3c 80 00       	push   $0x803cf3
  801587:	e8 04 ed ff ff       	call   800290 <_panic>

0080158c <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80158c:	55                   	push   %ebp
  80158d:	89 e5                	mov    %esp,%ebp
  80158f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801592:	83 ec 04             	sub    $0x4,%esp
  801595:	68 e4 3d 80 00       	push   $0x803de4
  80159a:	68 d9 00 00 00       	push   $0xd9
  80159f:	68 f3 3c 80 00       	push   $0x803cf3
  8015a4:	e8 e7 ec ff ff       	call   800290 <_panic>

008015a9 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8015a9:	55                   	push   %ebp
  8015aa:	89 e5                	mov    %esp,%ebp
  8015ac:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015af:	83 ec 04             	sub    $0x4,%esp
  8015b2:	68 08 3e 80 00       	push   $0x803e08
  8015b7:	68 e4 00 00 00       	push   $0xe4
  8015bc:	68 f3 3c 80 00       	push   $0x803cf3
  8015c1:	e8 ca ec ff ff       	call   800290 <_panic>

008015c6 <shrink>:

}
void shrink(uint32 newSize)
{
  8015c6:	55                   	push   %ebp
  8015c7:	89 e5                	mov    %esp,%ebp
  8015c9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015cc:	83 ec 04             	sub    $0x4,%esp
  8015cf:	68 08 3e 80 00       	push   $0x803e08
  8015d4:	68 e9 00 00 00       	push   $0xe9
  8015d9:	68 f3 3c 80 00       	push   $0x803cf3
  8015de:	e8 ad ec ff ff       	call   800290 <_panic>

008015e3 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8015e3:	55                   	push   %ebp
  8015e4:	89 e5                	mov    %esp,%ebp
  8015e6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015e9:	83 ec 04             	sub    $0x4,%esp
  8015ec:	68 08 3e 80 00       	push   $0x803e08
  8015f1:	68 ee 00 00 00       	push   $0xee
  8015f6:	68 f3 3c 80 00       	push   $0x803cf3
  8015fb:	e8 90 ec ff ff       	call   800290 <_panic>

00801600 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801600:	55                   	push   %ebp
  801601:	89 e5                	mov    %esp,%ebp
  801603:	57                   	push   %edi
  801604:	56                   	push   %esi
  801605:	53                   	push   %ebx
  801606:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801609:	8b 45 08             	mov    0x8(%ebp),%eax
  80160c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80160f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801612:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801615:	8b 7d 18             	mov    0x18(%ebp),%edi
  801618:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80161b:	cd 30                	int    $0x30
  80161d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801620:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801623:	83 c4 10             	add    $0x10,%esp
  801626:	5b                   	pop    %ebx
  801627:	5e                   	pop    %esi
  801628:	5f                   	pop    %edi
  801629:	5d                   	pop    %ebp
  80162a:	c3                   	ret    

0080162b <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80162b:	55                   	push   %ebp
  80162c:	89 e5                	mov    %esp,%ebp
  80162e:	83 ec 04             	sub    $0x4,%esp
  801631:	8b 45 10             	mov    0x10(%ebp),%eax
  801634:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801637:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80163b:	8b 45 08             	mov    0x8(%ebp),%eax
  80163e:	6a 00                	push   $0x0
  801640:	6a 00                	push   $0x0
  801642:	52                   	push   %edx
  801643:	ff 75 0c             	pushl  0xc(%ebp)
  801646:	50                   	push   %eax
  801647:	6a 00                	push   $0x0
  801649:	e8 b2 ff ff ff       	call   801600 <syscall>
  80164e:	83 c4 18             	add    $0x18,%esp
}
  801651:	90                   	nop
  801652:	c9                   	leave  
  801653:	c3                   	ret    

00801654 <sys_cgetc>:

int
sys_cgetc(void)
{
  801654:	55                   	push   %ebp
  801655:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801657:	6a 00                	push   $0x0
  801659:	6a 00                	push   $0x0
  80165b:	6a 00                	push   $0x0
  80165d:	6a 00                	push   $0x0
  80165f:	6a 00                	push   $0x0
  801661:	6a 01                	push   $0x1
  801663:	e8 98 ff ff ff       	call   801600 <syscall>
  801668:	83 c4 18             	add    $0x18,%esp
}
  80166b:	c9                   	leave  
  80166c:	c3                   	ret    

0080166d <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80166d:	55                   	push   %ebp
  80166e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801670:	8b 55 0c             	mov    0xc(%ebp),%edx
  801673:	8b 45 08             	mov    0x8(%ebp),%eax
  801676:	6a 00                	push   $0x0
  801678:	6a 00                	push   $0x0
  80167a:	6a 00                	push   $0x0
  80167c:	52                   	push   %edx
  80167d:	50                   	push   %eax
  80167e:	6a 05                	push   $0x5
  801680:	e8 7b ff ff ff       	call   801600 <syscall>
  801685:	83 c4 18             	add    $0x18,%esp
}
  801688:	c9                   	leave  
  801689:	c3                   	ret    

0080168a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80168a:	55                   	push   %ebp
  80168b:	89 e5                	mov    %esp,%ebp
  80168d:	56                   	push   %esi
  80168e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80168f:	8b 75 18             	mov    0x18(%ebp),%esi
  801692:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801695:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801698:	8b 55 0c             	mov    0xc(%ebp),%edx
  80169b:	8b 45 08             	mov    0x8(%ebp),%eax
  80169e:	56                   	push   %esi
  80169f:	53                   	push   %ebx
  8016a0:	51                   	push   %ecx
  8016a1:	52                   	push   %edx
  8016a2:	50                   	push   %eax
  8016a3:	6a 06                	push   $0x6
  8016a5:	e8 56 ff ff ff       	call   801600 <syscall>
  8016aa:	83 c4 18             	add    $0x18,%esp
}
  8016ad:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016b0:	5b                   	pop    %ebx
  8016b1:	5e                   	pop    %esi
  8016b2:	5d                   	pop    %ebp
  8016b3:	c3                   	ret    

008016b4 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8016b4:	55                   	push   %ebp
  8016b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8016b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bd:	6a 00                	push   $0x0
  8016bf:	6a 00                	push   $0x0
  8016c1:	6a 00                	push   $0x0
  8016c3:	52                   	push   %edx
  8016c4:	50                   	push   %eax
  8016c5:	6a 07                	push   $0x7
  8016c7:	e8 34 ff ff ff       	call   801600 <syscall>
  8016cc:	83 c4 18             	add    $0x18,%esp
}
  8016cf:	c9                   	leave  
  8016d0:	c3                   	ret    

008016d1 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8016d1:	55                   	push   %ebp
  8016d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8016d4:	6a 00                	push   $0x0
  8016d6:	6a 00                	push   $0x0
  8016d8:	6a 00                	push   $0x0
  8016da:	ff 75 0c             	pushl  0xc(%ebp)
  8016dd:	ff 75 08             	pushl  0x8(%ebp)
  8016e0:	6a 08                	push   $0x8
  8016e2:	e8 19 ff ff ff       	call   801600 <syscall>
  8016e7:	83 c4 18             	add    $0x18,%esp
}
  8016ea:	c9                   	leave  
  8016eb:	c3                   	ret    

008016ec <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8016ec:	55                   	push   %ebp
  8016ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8016ef:	6a 00                	push   $0x0
  8016f1:	6a 00                	push   $0x0
  8016f3:	6a 00                	push   $0x0
  8016f5:	6a 00                	push   $0x0
  8016f7:	6a 00                	push   $0x0
  8016f9:	6a 09                	push   $0x9
  8016fb:	e8 00 ff ff ff       	call   801600 <syscall>
  801700:	83 c4 18             	add    $0x18,%esp
}
  801703:	c9                   	leave  
  801704:	c3                   	ret    

00801705 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801705:	55                   	push   %ebp
  801706:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801708:	6a 00                	push   $0x0
  80170a:	6a 00                	push   $0x0
  80170c:	6a 00                	push   $0x0
  80170e:	6a 00                	push   $0x0
  801710:	6a 00                	push   $0x0
  801712:	6a 0a                	push   $0xa
  801714:	e8 e7 fe ff ff       	call   801600 <syscall>
  801719:	83 c4 18             	add    $0x18,%esp
}
  80171c:	c9                   	leave  
  80171d:	c3                   	ret    

0080171e <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80171e:	55                   	push   %ebp
  80171f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801721:	6a 00                	push   $0x0
  801723:	6a 00                	push   $0x0
  801725:	6a 00                	push   $0x0
  801727:	6a 00                	push   $0x0
  801729:	6a 00                	push   $0x0
  80172b:	6a 0b                	push   $0xb
  80172d:	e8 ce fe ff ff       	call   801600 <syscall>
  801732:	83 c4 18             	add    $0x18,%esp
}
  801735:	c9                   	leave  
  801736:	c3                   	ret    

00801737 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801737:	55                   	push   %ebp
  801738:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80173a:	6a 00                	push   $0x0
  80173c:	6a 00                	push   $0x0
  80173e:	6a 00                	push   $0x0
  801740:	ff 75 0c             	pushl  0xc(%ebp)
  801743:	ff 75 08             	pushl  0x8(%ebp)
  801746:	6a 0f                	push   $0xf
  801748:	e8 b3 fe ff ff       	call   801600 <syscall>
  80174d:	83 c4 18             	add    $0x18,%esp
	return;
  801750:	90                   	nop
}
  801751:	c9                   	leave  
  801752:	c3                   	ret    

00801753 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801753:	55                   	push   %ebp
  801754:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801756:	6a 00                	push   $0x0
  801758:	6a 00                	push   $0x0
  80175a:	6a 00                	push   $0x0
  80175c:	ff 75 0c             	pushl  0xc(%ebp)
  80175f:	ff 75 08             	pushl  0x8(%ebp)
  801762:	6a 10                	push   $0x10
  801764:	e8 97 fe ff ff       	call   801600 <syscall>
  801769:	83 c4 18             	add    $0x18,%esp
	return ;
  80176c:	90                   	nop
}
  80176d:	c9                   	leave  
  80176e:	c3                   	ret    

0080176f <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80176f:	55                   	push   %ebp
  801770:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801772:	6a 00                	push   $0x0
  801774:	6a 00                	push   $0x0
  801776:	ff 75 10             	pushl  0x10(%ebp)
  801779:	ff 75 0c             	pushl  0xc(%ebp)
  80177c:	ff 75 08             	pushl  0x8(%ebp)
  80177f:	6a 11                	push   $0x11
  801781:	e8 7a fe ff ff       	call   801600 <syscall>
  801786:	83 c4 18             	add    $0x18,%esp
	return ;
  801789:	90                   	nop
}
  80178a:	c9                   	leave  
  80178b:	c3                   	ret    

0080178c <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80178c:	55                   	push   %ebp
  80178d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80178f:	6a 00                	push   $0x0
  801791:	6a 00                	push   $0x0
  801793:	6a 00                	push   $0x0
  801795:	6a 00                	push   $0x0
  801797:	6a 00                	push   $0x0
  801799:	6a 0c                	push   $0xc
  80179b:	e8 60 fe ff ff       	call   801600 <syscall>
  8017a0:	83 c4 18             	add    $0x18,%esp
}
  8017a3:	c9                   	leave  
  8017a4:	c3                   	ret    

008017a5 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8017a5:	55                   	push   %ebp
  8017a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8017a8:	6a 00                	push   $0x0
  8017aa:	6a 00                	push   $0x0
  8017ac:	6a 00                	push   $0x0
  8017ae:	6a 00                	push   $0x0
  8017b0:	ff 75 08             	pushl  0x8(%ebp)
  8017b3:	6a 0d                	push   $0xd
  8017b5:	e8 46 fe ff ff       	call   801600 <syscall>
  8017ba:	83 c4 18             	add    $0x18,%esp
}
  8017bd:	c9                   	leave  
  8017be:	c3                   	ret    

008017bf <sys_scarce_memory>:

void sys_scarce_memory()
{
  8017bf:	55                   	push   %ebp
  8017c0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8017c2:	6a 00                	push   $0x0
  8017c4:	6a 00                	push   $0x0
  8017c6:	6a 00                	push   $0x0
  8017c8:	6a 00                	push   $0x0
  8017ca:	6a 00                	push   $0x0
  8017cc:	6a 0e                	push   $0xe
  8017ce:	e8 2d fe ff ff       	call   801600 <syscall>
  8017d3:	83 c4 18             	add    $0x18,%esp
}
  8017d6:	90                   	nop
  8017d7:	c9                   	leave  
  8017d8:	c3                   	ret    

008017d9 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8017d9:	55                   	push   %ebp
  8017da:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8017dc:	6a 00                	push   $0x0
  8017de:	6a 00                	push   $0x0
  8017e0:	6a 00                	push   $0x0
  8017e2:	6a 00                	push   $0x0
  8017e4:	6a 00                	push   $0x0
  8017e6:	6a 13                	push   $0x13
  8017e8:	e8 13 fe ff ff       	call   801600 <syscall>
  8017ed:	83 c4 18             	add    $0x18,%esp
}
  8017f0:	90                   	nop
  8017f1:	c9                   	leave  
  8017f2:	c3                   	ret    

008017f3 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8017f3:	55                   	push   %ebp
  8017f4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8017f6:	6a 00                	push   $0x0
  8017f8:	6a 00                	push   $0x0
  8017fa:	6a 00                	push   $0x0
  8017fc:	6a 00                	push   $0x0
  8017fe:	6a 00                	push   $0x0
  801800:	6a 14                	push   $0x14
  801802:	e8 f9 fd ff ff       	call   801600 <syscall>
  801807:	83 c4 18             	add    $0x18,%esp
}
  80180a:	90                   	nop
  80180b:	c9                   	leave  
  80180c:	c3                   	ret    

0080180d <sys_cputc>:


void
sys_cputc(const char c)
{
  80180d:	55                   	push   %ebp
  80180e:	89 e5                	mov    %esp,%ebp
  801810:	83 ec 04             	sub    $0x4,%esp
  801813:	8b 45 08             	mov    0x8(%ebp),%eax
  801816:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801819:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80181d:	6a 00                	push   $0x0
  80181f:	6a 00                	push   $0x0
  801821:	6a 00                	push   $0x0
  801823:	6a 00                	push   $0x0
  801825:	50                   	push   %eax
  801826:	6a 15                	push   $0x15
  801828:	e8 d3 fd ff ff       	call   801600 <syscall>
  80182d:	83 c4 18             	add    $0x18,%esp
}
  801830:	90                   	nop
  801831:	c9                   	leave  
  801832:	c3                   	ret    

00801833 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801833:	55                   	push   %ebp
  801834:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801836:	6a 00                	push   $0x0
  801838:	6a 00                	push   $0x0
  80183a:	6a 00                	push   $0x0
  80183c:	6a 00                	push   $0x0
  80183e:	6a 00                	push   $0x0
  801840:	6a 16                	push   $0x16
  801842:	e8 b9 fd ff ff       	call   801600 <syscall>
  801847:	83 c4 18             	add    $0x18,%esp
}
  80184a:	90                   	nop
  80184b:	c9                   	leave  
  80184c:	c3                   	ret    

0080184d <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80184d:	55                   	push   %ebp
  80184e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801850:	8b 45 08             	mov    0x8(%ebp),%eax
  801853:	6a 00                	push   $0x0
  801855:	6a 00                	push   $0x0
  801857:	6a 00                	push   $0x0
  801859:	ff 75 0c             	pushl  0xc(%ebp)
  80185c:	50                   	push   %eax
  80185d:	6a 17                	push   $0x17
  80185f:	e8 9c fd ff ff       	call   801600 <syscall>
  801864:	83 c4 18             	add    $0x18,%esp
}
  801867:	c9                   	leave  
  801868:	c3                   	ret    

00801869 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801869:	55                   	push   %ebp
  80186a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80186c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80186f:	8b 45 08             	mov    0x8(%ebp),%eax
  801872:	6a 00                	push   $0x0
  801874:	6a 00                	push   $0x0
  801876:	6a 00                	push   $0x0
  801878:	52                   	push   %edx
  801879:	50                   	push   %eax
  80187a:	6a 1a                	push   $0x1a
  80187c:	e8 7f fd ff ff       	call   801600 <syscall>
  801881:	83 c4 18             	add    $0x18,%esp
}
  801884:	c9                   	leave  
  801885:	c3                   	ret    

00801886 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801886:	55                   	push   %ebp
  801887:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801889:	8b 55 0c             	mov    0xc(%ebp),%edx
  80188c:	8b 45 08             	mov    0x8(%ebp),%eax
  80188f:	6a 00                	push   $0x0
  801891:	6a 00                	push   $0x0
  801893:	6a 00                	push   $0x0
  801895:	52                   	push   %edx
  801896:	50                   	push   %eax
  801897:	6a 18                	push   $0x18
  801899:	e8 62 fd ff ff       	call   801600 <syscall>
  80189e:	83 c4 18             	add    $0x18,%esp
}
  8018a1:	90                   	nop
  8018a2:	c9                   	leave  
  8018a3:	c3                   	ret    

008018a4 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8018a4:	55                   	push   %ebp
  8018a5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ad:	6a 00                	push   $0x0
  8018af:	6a 00                	push   $0x0
  8018b1:	6a 00                	push   $0x0
  8018b3:	52                   	push   %edx
  8018b4:	50                   	push   %eax
  8018b5:	6a 19                	push   $0x19
  8018b7:	e8 44 fd ff ff       	call   801600 <syscall>
  8018bc:	83 c4 18             	add    $0x18,%esp
}
  8018bf:	90                   	nop
  8018c0:	c9                   	leave  
  8018c1:	c3                   	ret    

008018c2 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8018c2:	55                   	push   %ebp
  8018c3:	89 e5                	mov    %esp,%ebp
  8018c5:	83 ec 04             	sub    $0x4,%esp
  8018c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8018cb:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8018ce:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8018d1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d8:	6a 00                	push   $0x0
  8018da:	51                   	push   %ecx
  8018db:	52                   	push   %edx
  8018dc:	ff 75 0c             	pushl  0xc(%ebp)
  8018df:	50                   	push   %eax
  8018e0:	6a 1b                	push   $0x1b
  8018e2:	e8 19 fd ff ff       	call   801600 <syscall>
  8018e7:	83 c4 18             	add    $0x18,%esp
}
  8018ea:	c9                   	leave  
  8018eb:	c3                   	ret    

008018ec <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8018ec:	55                   	push   %ebp
  8018ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8018ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f5:	6a 00                	push   $0x0
  8018f7:	6a 00                	push   $0x0
  8018f9:	6a 00                	push   $0x0
  8018fb:	52                   	push   %edx
  8018fc:	50                   	push   %eax
  8018fd:	6a 1c                	push   $0x1c
  8018ff:	e8 fc fc ff ff       	call   801600 <syscall>
  801904:	83 c4 18             	add    $0x18,%esp
}
  801907:	c9                   	leave  
  801908:	c3                   	ret    

00801909 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801909:	55                   	push   %ebp
  80190a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80190c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80190f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801912:	8b 45 08             	mov    0x8(%ebp),%eax
  801915:	6a 00                	push   $0x0
  801917:	6a 00                	push   $0x0
  801919:	51                   	push   %ecx
  80191a:	52                   	push   %edx
  80191b:	50                   	push   %eax
  80191c:	6a 1d                	push   $0x1d
  80191e:	e8 dd fc ff ff       	call   801600 <syscall>
  801923:	83 c4 18             	add    $0x18,%esp
}
  801926:	c9                   	leave  
  801927:	c3                   	ret    

00801928 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801928:	55                   	push   %ebp
  801929:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80192b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80192e:	8b 45 08             	mov    0x8(%ebp),%eax
  801931:	6a 00                	push   $0x0
  801933:	6a 00                	push   $0x0
  801935:	6a 00                	push   $0x0
  801937:	52                   	push   %edx
  801938:	50                   	push   %eax
  801939:	6a 1e                	push   $0x1e
  80193b:	e8 c0 fc ff ff       	call   801600 <syscall>
  801940:	83 c4 18             	add    $0x18,%esp
}
  801943:	c9                   	leave  
  801944:	c3                   	ret    

00801945 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801945:	55                   	push   %ebp
  801946:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801948:	6a 00                	push   $0x0
  80194a:	6a 00                	push   $0x0
  80194c:	6a 00                	push   $0x0
  80194e:	6a 00                	push   $0x0
  801950:	6a 00                	push   $0x0
  801952:	6a 1f                	push   $0x1f
  801954:	e8 a7 fc ff ff       	call   801600 <syscall>
  801959:	83 c4 18             	add    $0x18,%esp
}
  80195c:	c9                   	leave  
  80195d:	c3                   	ret    

0080195e <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80195e:	55                   	push   %ebp
  80195f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801961:	8b 45 08             	mov    0x8(%ebp),%eax
  801964:	6a 00                	push   $0x0
  801966:	ff 75 14             	pushl  0x14(%ebp)
  801969:	ff 75 10             	pushl  0x10(%ebp)
  80196c:	ff 75 0c             	pushl  0xc(%ebp)
  80196f:	50                   	push   %eax
  801970:	6a 20                	push   $0x20
  801972:	e8 89 fc ff ff       	call   801600 <syscall>
  801977:	83 c4 18             	add    $0x18,%esp
}
  80197a:	c9                   	leave  
  80197b:	c3                   	ret    

0080197c <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80197c:	55                   	push   %ebp
  80197d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80197f:	8b 45 08             	mov    0x8(%ebp),%eax
  801982:	6a 00                	push   $0x0
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	6a 00                	push   $0x0
  80198a:	50                   	push   %eax
  80198b:	6a 21                	push   $0x21
  80198d:	e8 6e fc ff ff       	call   801600 <syscall>
  801992:	83 c4 18             	add    $0x18,%esp
}
  801995:	90                   	nop
  801996:	c9                   	leave  
  801997:	c3                   	ret    

00801998 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801998:	55                   	push   %ebp
  801999:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80199b:	8b 45 08             	mov    0x8(%ebp),%eax
  80199e:	6a 00                	push   $0x0
  8019a0:	6a 00                	push   $0x0
  8019a2:	6a 00                	push   $0x0
  8019a4:	6a 00                	push   $0x0
  8019a6:	50                   	push   %eax
  8019a7:	6a 22                	push   $0x22
  8019a9:	e8 52 fc ff ff       	call   801600 <syscall>
  8019ae:	83 c4 18             	add    $0x18,%esp
}
  8019b1:	c9                   	leave  
  8019b2:	c3                   	ret    

008019b3 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8019b3:	55                   	push   %ebp
  8019b4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 02                	push   $0x2
  8019c2:	e8 39 fc ff ff       	call   801600 <syscall>
  8019c7:	83 c4 18             	add    $0x18,%esp
}
  8019ca:	c9                   	leave  
  8019cb:	c3                   	ret    

008019cc <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8019cc:	55                   	push   %ebp
  8019cd:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 00                	push   $0x0
  8019d9:	6a 03                	push   $0x3
  8019db:	e8 20 fc ff ff       	call   801600 <syscall>
  8019e0:	83 c4 18             	add    $0x18,%esp
}
  8019e3:	c9                   	leave  
  8019e4:	c3                   	ret    

008019e5 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8019e5:	55                   	push   %ebp
  8019e6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 00                	push   $0x0
  8019ec:	6a 00                	push   $0x0
  8019ee:	6a 00                	push   $0x0
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 04                	push   $0x4
  8019f4:	e8 07 fc ff ff       	call   801600 <syscall>
  8019f9:	83 c4 18             	add    $0x18,%esp
}
  8019fc:	c9                   	leave  
  8019fd:	c3                   	ret    

008019fe <sys_exit_env>:


void sys_exit_env(void)
{
  8019fe:	55                   	push   %ebp
  8019ff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801a01:	6a 00                	push   $0x0
  801a03:	6a 00                	push   $0x0
  801a05:	6a 00                	push   $0x0
  801a07:	6a 00                	push   $0x0
  801a09:	6a 00                	push   $0x0
  801a0b:	6a 23                	push   $0x23
  801a0d:	e8 ee fb ff ff       	call   801600 <syscall>
  801a12:	83 c4 18             	add    $0x18,%esp
}
  801a15:	90                   	nop
  801a16:	c9                   	leave  
  801a17:	c3                   	ret    

00801a18 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801a18:	55                   	push   %ebp
  801a19:	89 e5                	mov    %esp,%ebp
  801a1b:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801a1e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a21:	8d 50 04             	lea    0x4(%eax),%edx
  801a24:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a27:	6a 00                	push   $0x0
  801a29:	6a 00                	push   $0x0
  801a2b:	6a 00                	push   $0x0
  801a2d:	52                   	push   %edx
  801a2e:	50                   	push   %eax
  801a2f:	6a 24                	push   $0x24
  801a31:	e8 ca fb ff ff       	call   801600 <syscall>
  801a36:	83 c4 18             	add    $0x18,%esp
	return result;
  801a39:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a3c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a3f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a42:	89 01                	mov    %eax,(%ecx)
  801a44:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801a47:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4a:	c9                   	leave  
  801a4b:	c2 04 00             	ret    $0x4

00801a4e <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801a4e:	55                   	push   %ebp
  801a4f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801a51:	6a 00                	push   $0x0
  801a53:	6a 00                	push   $0x0
  801a55:	ff 75 10             	pushl  0x10(%ebp)
  801a58:	ff 75 0c             	pushl  0xc(%ebp)
  801a5b:	ff 75 08             	pushl  0x8(%ebp)
  801a5e:	6a 12                	push   $0x12
  801a60:	e8 9b fb ff ff       	call   801600 <syscall>
  801a65:	83 c4 18             	add    $0x18,%esp
	return ;
  801a68:	90                   	nop
}
  801a69:	c9                   	leave  
  801a6a:	c3                   	ret    

00801a6b <sys_rcr2>:
uint32 sys_rcr2()
{
  801a6b:	55                   	push   %ebp
  801a6c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801a6e:	6a 00                	push   $0x0
  801a70:	6a 00                	push   $0x0
  801a72:	6a 00                	push   $0x0
  801a74:	6a 00                	push   $0x0
  801a76:	6a 00                	push   $0x0
  801a78:	6a 25                	push   $0x25
  801a7a:	e8 81 fb ff ff       	call   801600 <syscall>
  801a7f:	83 c4 18             	add    $0x18,%esp
}
  801a82:	c9                   	leave  
  801a83:	c3                   	ret    

00801a84 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801a84:	55                   	push   %ebp
  801a85:	89 e5                	mov    %esp,%ebp
  801a87:	83 ec 04             	sub    $0x4,%esp
  801a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801a90:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801a94:	6a 00                	push   $0x0
  801a96:	6a 00                	push   $0x0
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 00                	push   $0x0
  801a9c:	50                   	push   %eax
  801a9d:	6a 26                	push   $0x26
  801a9f:	e8 5c fb ff ff       	call   801600 <syscall>
  801aa4:	83 c4 18             	add    $0x18,%esp
	return ;
  801aa7:	90                   	nop
}
  801aa8:	c9                   	leave  
  801aa9:	c3                   	ret    

00801aaa <rsttst>:
void rsttst()
{
  801aaa:	55                   	push   %ebp
  801aab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801aad:	6a 00                	push   $0x0
  801aaf:	6a 00                	push   $0x0
  801ab1:	6a 00                	push   $0x0
  801ab3:	6a 00                	push   $0x0
  801ab5:	6a 00                	push   $0x0
  801ab7:	6a 28                	push   $0x28
  801ab9:	e8 42 fb ff ff       	call   801600 <syscall>
  801abe:	83 c4 18             	add    $0x18,%esp
	return ;
  801ac1:	90                   	nop
}
  801ac2:	c9                   	leave  
  801ac3:	c3                   	ret    

00801ac4 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ac4:	55                   	push   %ebp
  801ac5:	89 e5                	mov    %esp,%ebp
  801ac7:	83 ec 04             	sub    $0x4,%esp
  801aca:	8b 45 14             	mov    0x14(%ebp),%eax
  801acd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ad0:	8b 55 18             	mov    0x18(%ebp),%edx
  801ad3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ad7:	52                   	push   %edx
  801ad8:	50                   	push   %eax
  801ad9:	ff 75 10             	pushl  0x10(%ebp)
  801adc:	ff 75 0c             	pushl  0xc(%ebp)
  801adf:	ff 75 08             	pushl  0x8(%ebp)
  801ae2:	6a 27                	push   $0x27
  801ae4:	e8 17 fb ff ff       	call   801600 <syscall>
  801ae9:	83 c4 18             	add    $0x18,%esp
	return ;
  801aec:	90                   	nop
}
  801aed:	c9                   	leave  
  801aee:	c3                   	ret    

00801aef <chktst>:
void chktst(uint32 n)
{
  801aef:	55                   	push   %ebp
  801af0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	6a 00                	push   $0x0
  801afa:	ff 75 08             	pushl  0x8(%ebp)
  801afd:	6a 29                	push   $0x29
  801aff:	e8 fc fa ff ff       	call   801600 <syscall>
  801b04:	83 c4 18             	add    $0x18,%esp
	return ;
  801b07:	90                   	nop
}
  801b08:	c9                   	leave  
  801b09:	c3                   	ret    

00801b0a <inctst>:

void inctst()
{
  801b0a:	55                   	push   %ebp
  801b0b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 00                	push   $0x0
  801b13:	6a 00                	push   $0x0
  801b15:	6a 00                	push   $0x0
  801b17:	6a 2a                	push   $0x2a
  801b19:	e8 e2 fa ff ff       	call   801600 <syscall>
  801b1e:	83 c4 18             	add    $0x18,%esp
	return ;
  801b21:	90                   	nop
}
  801b22:	c9                   	leave  
  801b23:	c3                   	ret    

00801b24 <gettst>:
uint32 gettst()
{
  801b24:	55                   	push   %ebp
  801b25:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 2b                	push   $0x2b
  801b33:	e8 c8 fa ff ff       	call   801600 <syscall>
  801b38:	83 c4 18             	add    $0x18,%esp
}
  801b3b:	c9                   	leave  
  801b3c:	c3                   	ret    

00801b3d <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801b3d:	55                   	push   %ebp
  801b3e:	89 e5                	mov    %esp,%ebp
  801b40:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b43:	6a 00                	push   $0x0
  801b45:	6a 00                	push   $0x0
  801b47:	6a 00                	push   $0x0
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 2c                	push   $0x2c
  801b4f:	e8 ac fa ff ff       	call   801600 <syscall>
  801b54:	83 c4 18             	add    $0x18,%esp
  801b57:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801b5a:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801b5e:	75 07                	jne    801b67 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801b60:	b8 01 00 00 00       	mov    $0x1,%eax
  801b65:	eb 05                	jmp    801b6c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801b67:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b6c:	c9                   	leave  
  801b6d:	c3                   	ret    

00801b6e <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801b6e:	55                   	push   %ebp
  801b6f:	89 e5                	mov    %esp,%ebp
  801b71:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b74:	6a 00                	push   $0x0
  801b76:	6a 00                	push   $0x0
  801b78:	6a 00                	push   $0x0
  801b7a:	6a 00                	push   $0x0
  801b7c:	6a 00                	push   $0x0
  801b7e:	6a 2c                	push   $0x2c
  801b80:	e8 7b fa ff ff       	call   801600 <syscall>
  801b85:	83 c4 18             	add    $0x18,%esp
  801b88:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801b8b:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801b8f:	75 07                	jne    801b98 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801b91:	b8 01 00 00 00       	mov    $0x1,%eax
  801b96:	eb 05                	jmp    801b9d <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801b98:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b9d:	c9                   	leave  
  801b9e:	c3                   	ret    

00801b9f <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801b9f:	55                   	push   %ebp
  801ba0:	89 e5                	mov    %esp,%ebp
  801ba2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 00                	push   $0x0
  801bad:	6a 00                	push   $0x0
  801baf:	6a 2c                	push   $0x2c
  801bb1:	e8 4a fa ff ff       	call   801600 <syscall>
  801bb6:	83 c4 18             	add    $0x18,%esp
  801bb9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801bbc:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801bc0:	75 07                	jne    801bc9 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801bc2:	b8 01 00 00 00       	mov    $0x1,%eax
  801bc7:	eb 05                	jmp    801bce <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801bc9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bce:	c9                   	leave  
  801bcf:	c3                   	ret    

00801bd0 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801bd0:	55                   	push   %ebp
  801bd1:	89 e5                	mov    %esp,%ebp
  801bd3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 00                	push   $0x0
  801be0:	6a 2c                	push   $0x2c
  801be2:	e8 19 fa ff ff       	call   801600 <syscall>
  801be7:	83 c4 18             	add    $0x18,%esp
  801bea:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801bed:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801bf1:	75 07                	jne    801bfa <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801bf3:	b8 01 00 00 00       	mov    $0x1,%eax
  801bf8:	eb 05                	jmp    801bff <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801bfa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bff:	c9                   	leave  
  801c00:	c3                   	ret    

00801c01 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c01:	55                   	push   %ebp
  801c02:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c04:	6a 00                	push   $0x0
  801c06:	6a 00                	push   $0x0
  801c08:	6a 00                	push   $0x0
  801c0a:	6a 00                	push   $0x0
  801c0c:	ff 75 08             	pushl  0x8(%ebp)
  801c0f:	6a 2d                	push   $0x2d
  801c11:	e8 ea f9 ff ff       	call   801600 <syscall>
  801c16:	83 c4 18             	add    $0x18,%esp
	return ;
  801c19:	90                   	nop
}
  801c1a:	c9                   	leave  
  801c1b:	c3                   	ret    

00801c1c <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801c1c:	55                   	push   %ebp
  801c1d:	89 e5                	mov    %esp,%ebp
  801c1f:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801c20:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c23:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c26:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c29:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2c:	6a 00                	push   $0x0
  801c2e:	53                   	push   %ebx
  801c2f:	51                   	push   %ecx
  801c30:	52                   	push   %edx
  801c31:	50                   	push   %eax
  801c32:	6a 2e                	push   $0x2e
  801c34:	e8 c7 f9 ff ff       	call   801600 <syscall>
  801c39:	83 c4 18             	add    $0x18,%esp
}
  801c3c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c3f:	c9                   	leave  
  801c40:	c3                   	ret    

00801c41 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801c41:	55                   	push   %ebp
  801c42:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801c44:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c47:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 00                	push   $0x0
  801c50:	52                   	push   %edx
  801c51:	50                   	push   %eax
  801c52:	6a 2f                	push   $0x2f
  801c54:	e8 a7 f9 ff ff       	call   801600 <syscall>
  801c59:	83 c4 18             	add    $0x18,%esp
}
  801c5c:	c9                   	leave  
  801c5d:	c3                   	ret    

00801c5e <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801c5e:	55                   	push   %ebp
  801c5f:	89 e5                	mov    %esp,%ebp
  801c61:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801c64:	83 ec 0c             	sub    $0xc,%esp
  801c67:	68 18 3e 80 00       	push   $0x803e18
  801c6c:	e8 d3 e8 ff ff       	call   800544 <cprintf>
  801c71:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801c74:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801c7b:	83 ec 0c             	sub    $0xc,%esp
  801c7e:	68 44 3e 80 00       	push   $0x803e44
  801c83:	e8 bc e8 ff ff       	call   800544 <cprintf>
  801c88:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801c8b:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801c8f:	a1 38 41 80 00       	mov    0x804138,%eax
  801c94:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c97:	eb 56                	jmp    801cef <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801c99:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801c9d:	74 1c                	je     801cbb <print_mem_block_lists+0x5d>
  801c9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ca2:	8b 50 08             	mov    0x8(%eax),%edx
  801ca5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ca8:	8b 48 08             	mov    0x8(%eax),%ecx
  801cab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cae:	8b 40 0c             	mov    0xc(%eax),%eax
  801cb1:	01 c8                	add    %ecx,%eax
  801cb3:	39 c2                	cmp    %eax,%edx
  801cb5:	73 04                	jae    801cbb <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801cb7:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801cbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cbe:	8b 50 08             	mov    0x8(%eax),%edx
  801cc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cc4:	8b 40 0c             	mov    0xc(%eax),%eax
  801cc7:	01 c2                	add    %eax,%edx
  801cc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ccc:	8b 40 08             	mov    0x8(%eax),%eax
  801ccf:	83 ec 04             	sub    $0x4,%esp
  801cd2:	52                   	push   %edx
  801cd3:	50                   	push   %eax
  801cd4:	68 59 3e 80 00       	push   $0x803e59
  801cd9:	e8 66 e8 ff ff       	call   800544 <cprintf>
  801cde:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801ce1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ce4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ce7:	a1 40 41 80 00       	mov    0x804140,%eax
  801cec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801cef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801cf3:	74 07                	je     801cfc <print_mem_block_lists+0x9e>
  801cf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cf8:	8b 00                	mov    (%eax),%eax
  801cfa:	eb 05                	jmp    801d01 <print_mem_block_lists+0xa3>
  801cfc:	b8 00 00 00 00       	mov    $0x0,%eax
  801d01:	a3 40 41 80 00       	mov    %eax,0x804140
  801d06:	a1 40 41 80 00       	mov    0x804140,%eax
  801d0b:	85 c0                	test   %eax,%eax
  801d0d:	75 8a                	jne    801c99 <print_mem_block_lists+0x3b>
  801d0f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d13:	75 84                	jne    801c99 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801d15:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801d19:	75 10                	jne    801d2b <print_mem_block_lists+0xcd>
  801d1b:	83 ec 0c             	sub    $0xc,%esp
  801d1e:	68 68 3e 80 00       	push   $0x803e68
  801d23:	e8 1c e8 ff ff       	call   800544 <cprintf>
  801d28:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801d2b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801d32:	83 ec 0c             	sub    $0xc,%esp
  801d35:	68 8c 3e 80 00       	push   $0x803e8c
  801d3a:	e8 05 e8 ff ff       	call   800544 <cprintf>
  801d3f:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801d42:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801d46:	a1 40 40 80 00       	mov    0x804040,%eax
  801d4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d4e:	eb 56                	jmp    801da6 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801d50:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d54:	74 1c                	je     801d72 <print_mem_block_lists+0x114>
  801d56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d59:	8b 50 08             	mov    0x8(%eax),%edx
  801d5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d5f:	8b 48 08             	mov    0x8(%eax),%ecx
  801d62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d65:	8b 40 0c             	mov    0xc(%eax),%eax
  801d68:	01 c8                	add    %ecx,%eax
  801d6a:	39 c2                	cmp    %eax,%edx
  801d6c:	73 04                	jae    801d72 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801d6e:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801d72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d75:	8b 50 08             	mov    0x8(%eax),%edx
  801d78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d7b:	8b 40 0c             	mov    0xc(%eax),%eax
  801d7e:	01 c2                	add    %eax,%edx
  801d80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d83:	8b 40 08             	mov    0x8(%eax),%eax
  801d86:	83 ec 04             	sub    $0x4,%esp
  801d89:	52                   	push   %edx
  801d8a:	50                   	push   %eax
  801d8b:	68 59 3e 80 00       	push   $0x803e59
  801d90:	e8 af e7 ff ff       	call   800544 <cprintf>
  801d95:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801d98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801d9e:	a1 48 40 80 00       	mov    0x804048,%eax
  801da3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801da6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801daa:	74 07                	je     801db3 <print_mem_block_lists+0x155>
  801dac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801daf:	8b 00                	mov    (%eax),%eax
  801db1:	eb 05                	jmp    801db8 <print_mem_block_lists+0x15a>
  801db3:	b8 00 00 00 00       	mov    $0x0,%eax
  801db8:	a3 48 40 80 00       	mov    %eax,0x804048
  801dbd:	a1 48 40 80 00       	mov    0x804048,%eax
  801dc2:	85 c0                	test   %eax,%eax
  801dc4:	75 8a                	jne    801d50 <print_mem_block_lists+0xf2>
  801dc6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801dca:	75 84                	jne    801d50 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801dcc:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801dd0:	75 10                	jne    801de2 <print_mem_block_lists+0x184>
  801dd2:	83 ec 0c             	sub    $0xc,%esp
  801dd5:	68 a4 3e 80 00       	push   $0x803ea4
  801dda:	e8 65 e7 ff ff       	call   800544 <cprintf>
  801ddf:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801de2:	83 ec 0c             	sub    $0xc,%esp
  801de5:	68 18 3e 80 00       	push   $0x803e18
  801dea:	e8 55 e7 ff ff       	call   800544 <cprintf>
  801def:	83 c4 10             	add    $0x10,%esp

}
  801df2:	90                   	nop
  801df3:	c9                   	leave  
  801df4:	c3                   	ret    

00801df5 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801df5:	55                   	push   %ebp
  801df6:	89 e5                	mov    %esp,%ebp
  801df8:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801dfb:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801e02:	00 00 00 
  801e05:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801e0c:	00 00 00 
  801e0f:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801e16:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801e19:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801e20:	e9 9e 00 00 00       	jmp    801ec3 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801e25:	a1 50 40 80 00       	mov    0x804050,%eax
  801e2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e2d:	c1 e2 04             	shl    $0x4,%edx
  801e30:	01 d0                	add    %edx,%eax
  801e32:	85 c0                	test   %eax,%eax
  801e34:	75 14                	jne    801e4a <initialize_MemBlocksList+0x55>
  801e36:	83 ec 04             	sub    $0x4,%esp
  801e39:	68 cc 3e 80 00       	push   $0x803ecc
  801e3e:	6a 46                	push   $0x46
  801e40:	68 ef 3e 80 00       	push   $0x803eef
  801e45:	e8 46 e4 ff ff       	call   800290 <_panic>
  801e4a:	a1 50 40 80 00       	mov    0x804050,%eax
  801e4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e52:	c1 e2 04             	shl    $0x4,%edx
  801e55:	01 d0                	add    %edx,%eax
  801e57:	8b 15 48 41 80 00    	mov    0x804148,%edx
  801e5d:	89 10                	mov    %edx,(%eax)
  801e5f:	8b 00                	mov    (%eax),%eax
  801e61:	85 c0                	test   %eax,%eax
  801e63:	74 18                	je     801e7d <initialize_MemBlocksList+0x88>
  801e65:	a1 48 41 80 00       	mov    0x804148,%eax
  801e6a:	8b 15 50 40 80 00    	mov    0x804050,%edx
  801e70:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801e73:	c1 e1 04             	shl    $0x4,%ecx
  801e76:	01 ca                	add    %ecx,%edx
  801e78:	89 50 04             	mov    %edx,0x4(%eax)
  801e7b:	eb 12                	jmp    801e8f <initialize_MemBlocksList+0x9a>
  801e7d:	a1 50 40 80 00       	mov    0x804050,%eax
  801e82:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e85:	c1 e2 04             	shl    $0x4,%edx
  801e88:	01 d0                	add    %edx,%eax
  801e8a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801e8f:	a1 50 40 80 00       	mov    0x804050,%eax
  801e94:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e97:	c1 e2 04             	shl    $0x4,%edx
  801e9a:	01 d0                	add    %edx,%eax
  801e9c:	a3 48 41 80 00       	mov    %eax,0x804148
  801ea1:	a1 50 40 80 00       	mov    0x804050,%eax
  801ea6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ea9:	c1 e2 04             	shl    $0x4,%edx
  801eac:	01 d0                	add    %edx,%eax
  801eae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801eb5:	a1 54 41 80 00       	mov    0x804154,%eax
  801eba:	40                   	inc    %eax
  801ebb:	a3 54 41 80 00       	mov    %eax,0x804154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801ec0:	ff 45 f4             	incl   -0xc(%ebp)
  801ec3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec6:	3b 45 08             	cmp    0x8(%ebp),%eax
  801ec9:	0f 82 56 ff ff ff    	jb     801e25 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801ecf:	90                   	nop
  801ed0:	c9                   	leave  
  801ed1:	c3                   	ret    

00801ed2 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801ed2:	55                   	push   %ebp
  801ed3:	89 e5                	mov    %esp,%ebp
  801ed5:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  801edb:	8b 00                	mov    (%eax),%eax
  801edd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801ee0:	eb 19                	jmp    801efb <find_block+0x29>
	{
		if(va==point->sva)
  801ee2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ee5:	8b 40 08             	mov    0x8(%eax),%eax
  801ee8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801eeb:	75 05                	jne    801ef2 <find_block+0x20>
		   return point;
  801eed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ef0:	eb 36                	jmp    801f28 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef5:	8b 40 08             	mov    0x8(%eax),%eax
  801ef8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801efb:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801eff:	74 07                	je     801f08 <find_block+0x36>
  801f01:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f04:	8b 00                	mov    (%eax),%eax
  801f06:	eb 05                	jmp    801f0d <find_block+0x3b>
  801f08:	b8 00 00 00 00       	mov    $0x0,%eax
  801f0d:	8b 55 08             	mov    0x8(%ebp),%edx
  801f10:	89 42 08             	mov    %eax,0x8(%edx)
  801f13:	8b 45 08             	mov    0x8(%ebp),%eax
  801f16:	8b 40 08             	mov    0x8(%eax),%eax
  801f19:	85 c0                	test   %eax,%eax
  801f1b:	75 c5                	jne    801ee2 <find_block+0x10>
  801f1d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f21:	75 bf                	jne    801ee2 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  801f23:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f28:	c9                   	leave  
  801f29:	c3                   	ret    

00801f2a <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  801f2a:	55                   	push   %ebp
  801f2b:	89 e5                	mov    %esp,%ebp
  801f2d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  801f30:	a1 40 40 80 00       	mov    0x804040,%eax
  801f35:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  801f38:	a1 44 40 80 00       	mov    0x804044,%eax
  801f3d:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  801f40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f43:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801f46:	74 24                	je     801f6c <insert_sorted_allocList+0x42>
  801f48:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4b:	8b 50 08             	mov    0x8(%eax),%edx
  801f4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f51:	8b 40 08             	mov    0x8(%eax),%eax
  801f54:	39 c2                	cmp    %eax,%edx
  801f56:	76 14                	jbe    801f6c <insert_sorted_allocList+0x42>
  801f58:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5b:	8b 50 08             	mov    0x8(%eax),%edx
  801f5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f61:	8b 40 08             	mov    0x8(%eax),%eax
  801f64:	39 c2                	cmp    %eax,%edx
  801f66:	0f 82 60 01 00 00    	jb     8020cc <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  801f6c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f70:	75 65                	jne    801fd7 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  801f72:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f76:	75 14                	jne    801f8c <insert_sorted_allocList+0x62>
  801f78:	83 ec 04             	sub    $0x4,%esp
  801f7b:	68 cc 3e 80 00       	push   $0x803ecc
  801f80:	6a 6b                	push   $0x6b
  801f82:	68 ef 3e 80 00       	push   $0x803eef
  801f87:	e8 04 e3 ff ff       	call   800290 <_panic>
  801f8c:	8b 15 40 40 80 00    	mov    0x804040,%edx
  801f92:	8b 45 08             	mov    0x8(%ebp),%eax
  801f95:	89 10                	mov    %edx,(%eax)
  801f97:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9a:	8b 00                	mov    (%eax),%eax
  801f9c:	85 c0                	test   %eax,%eax
  801f9e:	74 0d                	je     801fad <insert_sorted_allocList+0x83>
  801fa0:	a1 40 40 80 00       	mov    0x804040,%eax
  801fa5:	8b 55 08             	mov    0x8(%ebp),%edx
  801fa8:	89 50 04             	mov    %edx,0x4(%eax)
  801fab:	eb 08                	jmp    801fb5 <insert_sorted_allocList+0x8b>
  801fad:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb0:	a3 44 40 80 00       	mov    %eax,0x804044
  801fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb8:	a3 40 40 80 00       	mov    %eax,0x804040
  801fbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801fc7:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801fcc:	40                   	inc    %eax
  801fcd:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  801fd2:	e9 dc 01 00 00       	jmp    8021b3 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  801fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  801fda:	8b 50 08             	mov    0x8(%eax),%edx
  801fdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fe0:	8b 40 08             	mov    0x8(%eax),%eax
  801fe3:	39 c2                	cmp    %eax,%edx
  801fe5:	77 6c                	ja     802053 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  801fe7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801feb:	74 06                	je     801ff3 <insert_sorted_allocList+0xc9>
  801fed:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ff1:	75 14                	jne    802007 <insert_sorted_allocList+0xdd>
  801ff3:	83 ec 04             	sub    $0x4,%esp
  801ff6:	68 08 3f 80 00       	push   $0x803f08
  801ffb:	6a 6f                	push   $0x6f
  801ffd:	68 ef 3e 80 00       	push   $0x803eef
  802002:	e8 89 e2 ff ff       	call   800290 <_panic>
  802007:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80200a:	8b 50 04             	mov    0x4(%eax),%edx
  80200d:	8b 45 08             	mov    0x8(%ebp),%eax
  802010:	89 50 04             	mov    %edx,0x4(%eax)
  802013:	8b 45 08             	mov    0x8(%ebp),%eax
  802016:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802019:	89 10                	mov    %edx,(%eax)
  80201b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80201e:	8b 40 04             	mov    0x4(%eax),%eax
  802021:	85 c0                	test   %eax,%eax
  802023:	74 0d                	je     802032 <insert_sorted_allocList+0x108>
  802025:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802028:	8b 40 04             	mov    0x4(%eax),%eax
  80202b:	8b 55 08             	mov    0x8(%ebp),%edx
  80202e:	89 10                	mov    %edx,(%eax)
  802030:	eb 08                	jmp    80203a <insert_sorted_allocList+0x110>
  802032:	8b 45 08             	mov    0x8(%ebp),%eax
  802035:	a3 40 40 80 00       	mov    %eax,0x804040
  80203a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80203d:	8b 55 08             	mov    0x8(%ebp),%edx
  802040:	89 50 04             	mov    %edx,0x4(%eax)
  802043:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802048:	40                   	inc    %eax
  802049:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80204e:	e9 60 01 00 00       	jmp    8021b3 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802053:	8b 45 08             	mov    0x8(%ebp),%eax
  802056:	8b 50 08             	mov    0x8(%eax),%edx
  802059:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80205c:	8b 40 08             	mov    0x8(%eax),%eax
  80205f:	39 c2                	cmp    %eax,%edx
  802061:	0f 82 4c 01 00 00    	jb     8021b3 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802067:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80206b:	75 14                	jne    802081 <insert_sorted_allocList+0x157>
  80206d:	83 ec 04             	sub    $0x4,%esp
  802070:	68 40 3f 80 00       	push   $0x803f40
  802075:	6a 73                	push   $0x73
  802077:	68 ef 3e 80 00       	push   $0x803eef
  80207c:	e8 0f e2 ff ff       	call   800290 <_panic>
  802081:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802087:	8b 45 08             	mov    0x8(%ebp),%eax
  80208a:	89 50 04             	mov    %edx,0x4(%eax)
  80208d:	8b 45 08             	mov    0x8(%ebp),%eax
  802090:	8b 40 04             	mov    0x4(%eax),%eax
  802093:	85 c0                	test   %eax,%eax
  802095:	74 0c                	je     8020a3 <insert_sorted_allocList+0x179>
  802097:	a1 44 40 80 00       	mov    0x804044,%eax
  80209c:	8b 55 08             	mov    0x8(%ebp),%edx
  80209f:	89 10                	mov    %edx,(%eax)
  8020a1:	eb 08                	jmp    8020ab <insert_sorted_allocList+0x181>
  8020a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a6:	a3 40 40 80 00       	mov    %eax,0x804040
  8020ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ae:	a3 44 40 80 00       	mov    %eax,0x804044
  8020b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8020bc:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8020c1:	40                   	inc    %eax
  8020c2:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8020c7:	e9 e7 00 00 00       	jmp    8021b3 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8020cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8020d2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8020d9:	a1 40 40 80 00       	mov    0x804040,%eax
  8020de:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020e1:	e9 9d 00 00 00       	jmp    802183 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8020e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e9:	8b 00                	mov    (%eax),%eax
  8020eb:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8020ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f1:	8b 50 08             	mov    0x8(%eax),%edx
  8020f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f7:	8b 40 08             	mov    0x8(%eax),%eax
  8020fa:	39 c2                	cmp    %eax,%edx
  8020fc:	76 7d                	jbe    80217b <insert_sorted_allocList+0x251>
  8020fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802101:	8b 50 08             	mov    0x8(%eax),%edx
  802104:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802107:	8b 40 08             	mov    0x8(%eax),%eax
  80210a:	39 c2                	cmp    %eax,%edx
  80210c:	73 6d                	jae    80217b <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  80210e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802112:	74 06                	je     80211a <insert_sorted_allocList+0x1f0>
  802114:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802118:	75 14                	jne    80212e <insert_sorted_allocList+0x204>
  80211a:	83 ec 04             	sub    $0x4,%esp
  80211d:	68 64 3f 80 00       	push   $0x803f64
  802122:	6a 7f                	push   $0x7f
  802124:	68 ef 3e 80 00       	push   $0x803eef
  802129:	e8 62 e1 ff ff       	call   800290 <_panic>
  80212e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802131:	8b 10                	mov    (%eax),%edx
  802133:	8b 45 08             	mov    0x8(%ebp),%eax
  802136:	89 10                	mov    %edx,(%eax)
  802138:	8b 45 08             	mov    0x8(%ebp),%eax
  80213b:	8b 00                	mov    (%eax),%eax
  80213d:	85 c0                	test   %eax,%eax
  80213f:	74 0b                	je     80214c <insert_sorted_allocList+0x222>
  802141:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802144:	8b 00                	mov    (%eax),%eax
  802146:	8b 55 08             	mov    0x8(%ebp),%edx
  802149:	89 50 04             	mov    %edx,0x4(%eax)
  80214c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80214f:	8b 55 08             	mov    0x8(%ebp),%edx
  802152:	89 10                	mov    %edx,(%eax)
  802154:	8b 45 08             	mov    0x8(%ebp),%eax
  802157:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80215a:	89 50 04             	mov    %edx,0x4(%eax)
  80215d:	8b 45 08             	mov    0x8(%ebp),%eax
  802160:	8b 00                	mov    (%eax),%eax
  802162:	85 c0                	test   %eax,%eax
  802164:	75 08                	jne    80216e <insert_sorted_allocList+0x244>
  802166:	8b 45 08             	mov    0x8(%ebp),%eax
  802169:	a3 44 40 80 00       	mov    %eax,0x804044
  80216e:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802173:	40                   	inc    %eax
  802174:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  802179:	eb 39                	jmp    8021b4 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80217b:	a1 48 40 80 00       	mov    0x804048,%eax
  802180:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802183:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802187:	74 07                	je     802190 <insert_sorted_allocList+0x266>
  802189:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80218c:	8b 00                	mov    (%eax),%eax
  80218e:	eb 05                	jmp    802195 <insert_sorted_allocList+0x26b>
  802190:	b8 00 00 00 00       	mov    $0x0,%eax
  802195:	a3 48 40 80 00       	mov    %eax,0x804048
  80219a:	a1 48 40 80 00       	mov    0x804048,%eax
  80219f:	85 c0                	test   %eax,%eax
  8021a1:	0f 85 3f ff ff ff    	jne    8020e6 <insert_sorted_allocList+0x1bc>
  8021a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021ab:	0f 85 35 ff ff ff    	jne    8020e6 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8021b1:	eb 01                	jmp    8021b4 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8021b3:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8021b4:	90                   	nop
  8021b5:	c9                   	leave  
  8021b6:	c3                   	ret    

008021b7 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8021b7:	55                   	push   %ebp
  8021b8:	89 e5                	mov    %esp,%ebp
  8021ba:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8021bd:	a1 38 41 80 00       	mov    0x804138,%eax
  8021c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021c5:	e9 85 01 00 00       	jmp    80234f <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8021ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021cd:	8b 40 0c             	mov    0xc(%eax),%eax
  8021d0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021d3:	0f 82 6e 01 00 00    	jb     802347 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8021d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8021df:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021e2:	0f 85 8a 00 00 00    	jne    802272 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8021e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021ec:	75 17                	jne    802205 <alloc_block_FF+0x4e>
  8021ee:	83 ec 04             	sub    $0x4,%esp
  8021f1:	68 98 3f 80 00       	push   $0x803f98
  8021f6:	68 93 00 00 00       	push   $0x93
  8021fb:	68 ef 3e 80 00       	push   $0x803eef
  802200:	e8 8b e0 ff ff       	call   800290 <_panic>
  802205:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802208:	8b 00                	mov    (%eax),%eax
  80220a:	85 c0                	test   %eax,%eax
  80220c:	74 10                	je     80221e <alloc_block_FF+0x67>
  80220e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802211:	8b 00                	mov    (%eax),%eax
  802213:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802216:	8b 52 04             	mov    0x4(%edx),%edx
  802219:	89 50 04             	mov    %edx,0x4(%eax)
  80221c:	eb 0b                	jmp    802229 <alloc_block_FF+0x72>
  80221e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802221:	8b 40 04             	mov    0x4(%eax),%eax
  802224:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802229:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80222c:	8b 40 04             	mov    0x4(%eax),%eax
  80222f:	85 c0                	test   %eax,%eax
  802231:	74 0f                	je     802242 <alloc_block_FF+0x8b>
  802233:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802236:	8b 40 04             	mov    0x4(%eax),%eax
  802239:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80223c:	8b 12                	mov    (%edx),%edx
  80223e:	89 10                	mov    %edx,(%eax)
  802240:	eb 0a                	jmp    80224c <alloc_block_FF+0x95>
  802242:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802245:	8b 00                	mov    (%eax),%eax
  802247:	a3 38 41 80 00       	mov    %eax,0x804138
  80224c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802255:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802258:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80225f:	a1 44 41 80 00       	mov    0x804144,%eax
  802264:	48                   	dec    %eax
  802265:	a3 44 41 80 00       	mov    %eax,0x804144
			   return  point;
  80226a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226d:	e9 10 01 00 00       	jmp    802382 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802272:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802275:	8b 40 0c             	mov    0xc(%eax),%eax
  802278:	3b 45 08             	cmp    0x8(%ebp),%eax
  80227b:	0f 86 c6 00 00 00    	jbe    802347 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802281:	a1 48 41 80 00       	mov    0x804148,%eax
  802286:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802289:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228c:	8b 50 08             	mov    0x8(%eax),%edx
  80228f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802292:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802295:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802298:	8b 55 08             	mov    0x8(%ebp),%edx
  80229b:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80229e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022a2:	75 17                	jne    8022bb <alloc_block_FF+0x104>
  8022a4:	83 ec 04             	sub    $0x4,%esp
  8022a7:	68 98 3f 80 00       	push   $0x803f98
  8022ac:	68 9b 00 00 00       	push   $0x9b
  8022b1:	68 ef 3e 80 00       	push   $0x803eef
  8022b6:	e8 d5 df ff ff       	call   800290 <_panic>
  8022bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022be:	8b 00                	mov    (%eax),%eax
  8022c0:	85 c0                	test   %eax,%eax
  8022c2:	74 10                	je     8022d4 <alloc_block_FF+0x11d>
  8022c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022c7:	8b 00                	mov    (%eax),%eax
  8022c9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022cc:	8b 52 04             	mov    0x4(%edx),%edx
  8022cf:	89 50 04             	mov    %edx,0x4(%eax)
  8022d2:	eb 0b                	jmp    8022df <alloc_block_FF+0x128>
  8022d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022d7:	8b 40 04             	mov    0x4(%eax),%eax
  8022da:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8022df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022e2:	8b 40 04             	mov    0x4(%eax),%eax
  8022e5:	85 c0                	test   %eax,%eax
  8022e7:	74 0f                	je     8022f8 <alloc_block_FF+0x141>
  8022e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022ec:	8b 40 04             	mov    0x4(%eax),%eax
  8022ef:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022f2:	8b 12                	mov    (%edx),%edx
  8022f4:	89 10                	mov    %edx,(%eax)
  8022f6:	eb 0a                	jmp    802302 <alloc_block_FF+0x14b>
  8022f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022fb:	8b 00                	mov    (%eax),%eax
  8022fd:	a3 48 41 80 00       	mov    %eax,0x804148
  802302:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802305:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80230b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80230e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802315:	a1 54 41 80 00       	mov    0x804154,%eax
  80231a:	48                   	dec    %eax
  80231b:	a3 54 41 80 00       	mov    %eax,0x804154
			   point->sva += size;
  802320:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802323:	8b 50 08             	mov    0x8(%eax),%edx
  802326:	8b 45 08             	mov    0x8(%ebp),%eax
  802329:	01 c2                	add    %eax,%edx
  80232b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232e:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802331:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802334:	8b 40 0c             	mov    0xc(%eax),%eax
  802337:	2b 45 08             	sub    0x8(%ebp),%eax
  80233a:	89 c2                	mov    %eax,%edx
  80233c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233f:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802342:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802345:	eb 3b                	jmp    802382 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802347:	a1 40 41 80 00       	mov    0x804140,%eax
  80234c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80234f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802353:	74 07                	je     80235c <alloc_block_FF+0x1a5>
  802355:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802358:	8b 00                	mov    (%eax),%eax
  80235a:	eb 05                	jmp    802361 <alloc_block_FF+0x1aa>
  80235c:	b8 00 00 00 00       	mov    $0x0,%eax
  802361:	a3 40 41 80 00       	mov    %eax,0x804140
  802366:	a1 40 41 80 00       	mov    0x804140,%eax
  80236b:	85 c0                	test   %eax,%eax
  80236d:	0f 85 57 fe ff ff    	jne    8021ca <alloc_block_FF+0x13>
  802373:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802377:	0f 85 4d fe ff ff    	jne    8021ca <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  80237d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802382:	c9                   	leave  
  802383:	c3                   	ret    

00802384 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802384:	55                   	push   %ebp
  802385:	89 e5                	mov    %esp,%ebp
  802387:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  80238a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802391:	a1 38 41 80 00       	mov    0x804138,%eax
  802396:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802399:	e9 df 00 00 00       	jmp    80247d <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  80239e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a1:	8b 40 0c             	mov    0xc(%eax),%eax
  8023a4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023a7:	0f 82 c8 00 00 00    	jb     802475 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8023ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8023b3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023b6:	0f 85 8a 00 00 00    	jne    802446 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8023bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023c0:	75 17                	jne    8023d9 <alloc_block_BF+0x55>
  8023c2:	83 ec 04             	sub    $0x4,%esp
  8023c5:	68 98 3f 80 00       	push   $0x803f98
  8023ca:	68 b7 00 00 00       	push   $0xb7
  8023cf:	68 ef 3e 80 00       	push   $0x803eef
  8023d4:	e8 b7 de ff ff       	call   800290 <_panic>
  8023d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023dc:	8b 00                	mov    (%eax),%eax
  8023de:	85 c0                	test   %eax,%eax
  8023e0:	74 10                	je     8023f2 <alloc_block_BF+0x6e>
  8023e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e5:	8b 00                	mov    (%eax),%eax
  8023e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023ea:	8b 52 04             	mov    0x4(%edx),%edx
  8023ed:	89 50 04             	mov    %edx,0x4(%eax)
  8023f0:	eb 0b                	jmp    8023fd <alloc_block_BF+0x79>
  8023f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f5:	8b 40 04             	mov    0x4(%eax),%eax
  8023f8:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8023fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802400:	8b 40 04             	mov    0x4(%eax),%eax
  802403:	85 c0                	test   %eax,%eax
  802405:	74 0f                	je     802416 <alloc_block_BF+0x92>
  802407:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240a:	8b 40 04             	mov    0x4(%eax),%eax
  80240d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802410:	8b 12                	mov    (%edx),%edx
  802412:	89 10                	mov    %edx,(%eax)
  802414:	eb 0a                	jmp    802420 <alloc_block_BF+0x9c>
  802416:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802419:	8b 00                	mov    (%eax),%eax
  80241b:	a3 38 41 80 00       	mov    %eax,0x804138
  802420:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802423:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802429:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802433:	a1 44 41 80 00       	mov    0x804144,%eax
  802438:	48                   	dec    %eax
  802439:	a3 44 41 80 00       	mov    %eax,0x804144
			   return currentMemBlock;
  80243e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802441:	e9 4d 01 00 00       	jmp    802593 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802446:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802449:	8b 40 0c             	mov    0xc(%eax),%eax
  80244c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80244f:	76 24                	jbe    802475 <alloc_block_BF+0xf1>
  802451:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802454:	8b 40 0c             	mov    0xc(%eax),%eax
  802457:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80245a:	73 19                	jae    802475 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  80245c:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802463:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802466:	8b 40 0c             	mov    0xc(%eax),%eax
  802469:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  80246c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246f:	8b 40 08             	mov    0x8(%eax),%eax
  802472:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802475:	a1 40 41 80 00       	mov    0x804140,%eax
  80247a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80247d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802481:	74 07                	je     80248a <alloc_block_BF+0x106>
  802483:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802486:	8b 00                	mov    (%eax),%eax
  802488:	eb 05                	jmp    80248f <alloc_block_BF+0x10b>
  80248a:	b8 00 00 00 00       	mov    $0x0,%eax
  80248f:	a3 40 41 80 00       	mov    %eax,0x804140
  802494:	a1 40 41 80 00       	mov    0x804140,%eax
  802499:	85 c0                	test   %eax,%eax
  80249b:	0f 85 fd fe ff ff    	jne    80239e <alloc_block_BF+0x1a>
  8024a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024a5:	0f 85 f3 fe ff ff    	jne    80239e <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8024ab:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8024af:	0f 84 d9 00 00 00    	je     80258e <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8024b5:	a1 48 41 80 00       	mov    0x804148,%eax
  8024ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8024bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024c0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024c3:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8024c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8024cc:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8024cf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8024d3:	75 17                	jne    8024ec <alloc_block_BF+0x168>
  8024d5:	83 ec 04             	sub    $0x4,%esp
  8024d8:	68 98 3f 80 00       	push   $0x803f98
  8024dd:	68 c7 00 00 00       	push   $0xc7
  8024e2:	68 ef 3e 80 00       	push   $0x803eef
  8024e7:	e8 a4 dd ff ff       	call   800290 <_panic>
  8024ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024ef:	8b 00                	mov    (%eax),%eax
  8024f1:	85 c0                	test   %eax,%eax
  8024f3:	74 10                	je     802505 <alloc_block_BF+0x181>
  8024f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024f8:	8b 00                	mov    (%eax),%eax
  8024fa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8024fd:	8b 52 04             	mov    0x4(%edx),%edx
  802500:	89 50 04             	mov    %edx,0x4(%eax)
  802503:	eb 0b                	jmp    802510 <alloc_block_BF+0x18c>
  802505:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802508:	8b 40 04             	mov    0x4(%eax),%eax
  80250b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802510:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802513:	8b 40 04             	mov    0x4(%eax),%eax
  802516:	85 c0                	test   %eax,%eax
  802518:	74 0f                	je     802529 <alloc_block_BF+0x1a5>
  80251a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80251d:	8b 40 04             	mov    0x4(%eax),%eax
  802520:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802523:	8b 12                	mov    (%edx),%edx
  802525:	89 10                	mov    %edx,(%eax)
  802527:	eb 0a                	jmp    802533 <alloc_block_BF+0x1af>
  802529:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80252c:	8b 00                	mov    (%eax),%eax
  80252e:	a3 48 41 80 00       	mov    %eax,0x804148
  802533:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802536:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80253c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80253f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802546:	a1 54 41 80 00       	mov    0x804154,%eax
  80254b:	48                   	dec    %eax
  80254c:	a3 54 41 80 00       	mov    %eax,0x804154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802551:	83 ec 08             	sub    $0x8,%esp
  802554:	ff 75 ec             	pushl  -0x14(%ebp)
  802557:	68 38 41 80 00       	push   $0x804138
  80255c:	e8 71 f9 ff ff       	call   801ed2 <find_block>
  802561:	83 c4 10             	add    $0x10,%esp
  802564:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802567:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80256a:	8b 50 08             	mov    0x8(%eax),%edx
  80256d:	8b 45 08             	mov    0x8(%ebp),%eax
  802570:	01 c2                	add    %eax,%edx
  802572:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802575:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802578:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80257b:	8b 40 0c             	mov    0xc(%eax),%eax
  80257e:	2b 45 08             	sub    0x8(%ebp),%eax
  802581:	89 c2                	mov    %eax,%edx
  802583:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802586:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802589:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80258c:	eb 05                	jmp    802593 <alloc_block_BF+0x20f>
	}
	return NULL;
  80258e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802593:	c9                   	leave  
  802594:	c3                   	ret    

00802595 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802595:	55                   	push   %ebp
  802596:	89 e5                	mov    %esp,%ebp
  802598:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  80259b:	a1 28 40 80 00       	mov    0x804028,%eax
  8025a0:	85 c0                	test   %eax,%eax
  8025a2:	0f 85 de 01 00 00    	jne    802786 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8025a8:	a1 38 41 80 00       	mov    0x804138,%eax
  8025ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025b0:	e9 9e 01 00 00       	jmp    802753 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8025b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b8:	8b 40 0c             	mov    0xc(%eax),%eax
  8025bb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025be:	0f 82 87 01 00 00    	jb     80274b <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8025c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c7:	8b 40 0c             	mov    0xc(%eax),%eax
  8025ca:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025cd:	0f 85 95 00 00 00    	jne    802668 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8025d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025d7:	75 17                	jne    8025f0 <alloc_block_NF+0x5b>
  8025d9:	83 ec 04             	sub    $0x4,%esp
  8025dc:	68 98 3f 80 00       	push   $0x803f98
  8025e1:	68 e0 00 00 00       	push   $0xe0
  8025e6:	68 ef 3e 80 00       	push   $0x803eef
  8025eb:	e8 a0 dc ff ff       	call   800290 <_panic>
  8025f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f3:	8b 00                	mov    (%eax),%eax
  8025f5:	85 c0                	test   %eax,%eax
  8025f7:	74 10                	je     802609 <alloc_block_NF+0x74>
  8025f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fc:	8b 00                	mov    (%eax),%eax
  8025fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802601:	8b 52 04             	mov    0x4(%edx),%edx
  802604:	89 50 04             	mov    %edx,0x4(%eax)
  802607:	eb 0b                	jmp    802614 <alloc_block_NF+0x7f>
  802609:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260c:	8b 40 04             	mov    0x4(%eax),%eax
  80260f:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802614:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802617:	8b 40 04             	mov    0x4(%eax),%eax
  80261a:	85 c0                	test   %eax,%eax
  80261c:	74 0f                	je     80262d <alloc_block_NF+0x98>
  80261e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802621:	8b 40 04             	mov    0x4(%eax),%eax
  802624:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802627:	8b 12                	mov    (%edx),%edx
  802629:	89 10                	mov    %edx,(%eax)
  80262b:	eb 0a                	jmp    802637 <alloc_block_NF+0xa2>
  80262d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802630:	8b 00                	mov    (%eax),%eax
  802632:	a3 38 41 80 00       	mov    %eax,0x804138
  802637:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802640:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802643:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80264a:	a1 44 41 80 00       	mov    0x804144,%eax
  80264f:	48                   	dec    %eax
  802650:	a3 44 41 80 00       	mov    %eax,0x804144
				   svaOfNF = point->sva;
  802655:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802658:	8b 40 08             	mov    0x8(%eax),%eax
  80265b:	a3 28 40 80 00       	mov    %eax,0x804028
				   return  point;
  802660:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802663:	e9 f8 04 00 00       	jmp    802b60 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802668:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266b:	8b 40 0c             	mov    0xc(%eax),%eax
  80266e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802671:	0f 86 d4 00 00 00    	jbe    80274b <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802677:	a1 48 41 80 00       	mov    0x804148,%eax
  80267c:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  80267f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802682:	8b 50 08             	mov    0x8(%eax),%edx
  802685:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802688:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  80268b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80268e:	8b 55 08             	mov    0x8(%ebp),%edx
  802691:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802694:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802698:	75 17                	jne    8026b1 <alloc_block_NF+0x11c>
  80269a:	83 ec 04             	sub    $0x4,%esp
  80269d:	68 98 3f 80 00       	push   $0x803f98
  8026a2:	68 e9 00 00 00       	push   $0xe9
  8026a7:	68 ef 3e 80 00       	push   $0x803eef
  8026ac:	e8 df db ff ff       	call   800290 <_panic>
  8026b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026b4:	8b 00                	mov    (%eax),%eax
  8026b6:	85 c0                	test   %eax,%eax
  8026b8:	74 10                	je     8026ca <alloc_block_NF+0x135>
  8026ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026bd:	8b 00                	mov    (%eax),%eax
  8026bf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026c2:	8b 52 04             	mov    0x4(%edx),%edx
  8026c5:	89 50 04             	mov    %edx,0x4(%eax)
  8026c8:	eb 0b                	jmp    8026d5 <alloc_block_NF+0x140>
  8026ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026cd:	8b 40 04             	mov    0x4(%eax),%eax
  8026d0:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8026d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026d8:	8b 40 04             	mov    0x4(%eax),%eax
  8026db:	85 c0                	test   %eax,%eax
  8026dd:	74 0f                	je     8026ee <alloc_block_NF+0x159>
  8026df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026e2:	8b 40 04             	mov    0x4(%eax),%eax
  8026e5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026e8:	8b 12                	mov    (%edx),%edx
  8026ea:	89 10                	mov    %edx,(%eax)
  8026ec:	eb 0a                	jmp    8026f8 <alloc_block_NF+0x163>
  8026ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026f1:	8b 00                	mov    (%eax),%eax
  8026f3:	a3 48 41 80 00       	mov    %eax,0x804148
  8026f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026fb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802701:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802704:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80270b:	a1 54 41 80 00       	mov    0x804154,%eax
  802710:	48                   	dec    %eax
  802711:	a3 54 41 80 00       	mov    %eax,0x804154
				   svaOfNF = ReturnedBlock->sva;
  802716:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802719:	8b 40 08             	mov    0x8(%eax),%eax
  80271c:	a3 28 40 80 00       	mov    %eax,0x804028
				   point->sva += size;
  802721:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802724:	8b 50 08             	mov    0x8(%eax),%edx
  802727:	8b 45 08             	mov    0x8(%ebp),%eax
  80272a:	01 c2                	add    %eax,%edx
  80272c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272f:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802732:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802735:	8b 40 0c             	mov    0xc(%eax),%eax
  802738:	2b 45 08             	sub    0x8(%ebp),%eax
  80273b:	89 c2                	mov    %eax,%edx
  80273d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802740:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802743:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802746:	e9 15 04 00 00       	jmp    802b60 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80274b:	a1 40 41 80 00       	mov    0x804140,%eax
  802750:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802753:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802757:	74 07                	je     802760 <alloc_block_NF+0x1cb>
  802759:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275c:	8b 00                	mov    (%eax),%eax
  80275e:	eb 05                	jmp    802765 <alloc_block_NF+0x1d0>
  802760:	b8 00 00 00 00       	mov    $0x0,%eax
  802765:	a3 40 41 80 00       	mov    %eax,0x804140
  80276a:	a1 40 41 80 00       	mov    0x804140,%eax
  80276f:	85 c0                	test   %eax,%eax
  802771:	0f 85 3e fe ff ff    	jne    8025b5 <alloc_block_NF+0x20>
  802777:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80277b:	0f 85 34 fe ff ff    	jne    8025b5 <alloc_block_NF+0x20>
  802781:	e9 d5 03 00 00       	jmp    802b5b <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802786:	a1 38 41 80 00       	mov    0x804138,%eax
  80278b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80278e:	e9 b1 01 00 00       	jmp    802944 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802793:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802796:	8b 50 08             	mov    0x8(%eax),%edx
  802799:	a1 28 40 80 00       	mov    0x804028,%eax
  80279e:	39 c2                	cmp    %eax,%edx
  8027a0:	0f 82 96 01 00 00    	jb     80293c <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  8027a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8027ac:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027af:	0f 82 87 01 00 00    	jb     80293c <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  8027b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b8:	8b 40 0c             	mov    0xc(%eax),%eax
  8027bb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027be:	0f 85 95 00 00 00    	jne    802859 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8027c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027c8:	75 17                	jne    8027e1 <alloc_block_NF+0x24c>
  8027ca:	83 ec 04             	sub    $0x4,%esp
  8027cd:	68 98 3f 80 00       	push   $0x803f98
  8027d2:	68 fc 00 00 00       	push   $0xfc
  8027d7:	68 ef 3e 80 00       	push   $0x803eef
  8027dc:	e8 af da ff ff       	call   800290 <_panic>
  8027e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e4:	8b 00                	mov    (%eax),%eax
  8027e6:	85 c0                	test   %eax,%eax
  8027e8:	74 10                	je     8027fa <alloc_block_NF+0x265>
  8027ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ed:	8b 00                	mov    (%eax),%eax
  8027ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027f2:	8b 52 04             	mov    0x4(%edx),%edx
  8027f5:	89 50 04             	mov    %edx,0x4(%eax)
  8027f8:	eb 0b                	jmp    802805 <alloc_block_NF+0x270>
  8027fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fd:	8b 40 04             	mov    0x4(%eax),%eax
  802800:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802805:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802808:	8b 40 04             	mov    0x4(%eax),%eax
  80280b:	85 c0                	test   %eax,%eax
  80280d:	74 0f                	je     80281e <alloc_block_NF+0x289>
  80280f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802812:	8b 40 04             	mov    0x4(%eax),%eax
  802815:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802818:	8b 12                	mov    (%edx),%edx
  80281a:	89 10                	mov    %edx,(%eax)
  80281c:	eb 0a                	jmp    802828 <alloc_block_NF+0x293>
  80281e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802821:	8b 00                	mov    (%eax),%eax
  802823:	a3 38 41 80 00       	mov    %eax,0x804138
  802828:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802831:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802834:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80283b:	a1 44 41 80 00       	mov    0x804144,%eax
  802840:	48                   	dec    %eax
  802841:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  802846:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802849:	8b 40 08             	mov    0x8(%eax),%eax
  80284c:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  802851:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802854:	e9 07 03 00 00       	jmp    802b60 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802859:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285c:	8b 40 0c             	mov    0xc(%eax),%eax
  80285f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802862:	0f 86 d4 00 00 00    	jbe    80293c <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802868:	a1 48 41 80 00       	mov    0x804148,%eax
  80286d:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802870:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802873:	8b 50 08             	mov    0x8(%eax),%edx
  802876:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802879:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  80287c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80287f:	8b 55 08             	mov    0x8(%ebp),%edx
  802882:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802885:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802889:	75 17                	jne    8028a2 <alloc_block_NF+0x30d>
  80288b:	83 ec 04             	sub    $0x4,%esp
  80288e:	68 98 3f 80 00       	push   $0x803f98
  802893:	68 04 01 00 00       	push   $0x104
  802898:	68 ef 3e 80 00       	push   $0x803eef
  80289d:	e8 ee d9 ff ff       	call   800290 <_panic>
  8028a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028a5:	8b 00                	mov    (%eax),%eax
  8028a7:	85 c0                	test   %eax,%eax
  8028a9:	74 10                	je     8028bb <alloc_block_NF+0x326>
  8028ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028ae:	8b 00                	mov    (%eax),%eax
  8028b0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8028b3:	8b 52 04             	mov    0x4(%edx),%edx
  8028b6:	89 50 04             	mov    %edx,0x4(%eax)
  8028b9:	eb 0b                	jmp    8028c6 <alloc_block_NF+0x331>
  8028bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028be:	8b 40 04             	mov    0x4(%eax),%eax
  8028c1:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8028c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028c9:	8b 40 04             	mov    0x4(%eax),%eax
  8028cc:	85 c0                	test   %eax,%eax
  8028ce:	74 0f                	je     8028df <alloc_block_NF+0x34a>
  8028d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028d3:	8b 40 04             	mov    0x4(%eax),%eax
  8028d6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8028d9:	8b 12                	mov    (%edx),%edx
  8028db:	89 10                	mov    %edx,(%eax)
  8028dd:	eb 0a                	jmp    8028e9 <alloc_block_NF+0x354>
  8028df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028e2:	8b 00                	mov    (%eax),%eax
  8028e4:	a3 48 41 80 00       	mov    %eax,0x804148
  8028e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028ec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028f5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028fc:	a1 54 41 80 00       	mov    0x804154,%eax
  802901:	48                   	dec    %eax
  802902:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  802907:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80290a:	8b 40 08             	mov    0x8(%eax),%eax
  80290d:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  802912:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802915:	8b 50 08             	mov    0x8(%eax),%edx
  802918:	8b 45 08             	mov    0x8(%ebp),%eax
  80291b:	01 c2                	add    %eax,%edx
  80291d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802920:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802923:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802926:	8b 40 0c             	mov    0xc(%eax),%eax
  802929:	2b 45 08             	sub    0x8(%ebp),%eax
  80292c:	89 c2                	mov    %eax,%edx
  80292e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802931:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802934:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802937:	e9 24 02 00 00       	jmp    802b60 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  80293c:	a1 40 41 80 00       	mov    0x804140,%eax
  802941:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802944:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802948:	74 07                	je     802951 <alloc_block_NF+0x3bc>
  80294a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294d:	8b 00                	mov    (%eax),%eax
  80294f:	eb 05                	jmp    802956 <alloc_block_NF+0x3c1>
  802951:	b8 00 00 00 00       	mov    $0x0,%eax
  802956:	a3 40 41 80 00       	mov    %eax,0x804140
  80295b:	a1 40 41 80 00       	mov    0x804140,%eax
  802960:	85 c0                	test   %eax,%eax
  802962:	0f 85 2b fe ff ff    	jne    802793 <alloc_block_NF+0x1fe>
  802968:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80296c:	0f 85 21 fe ff ff    	jne    802793 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802972:	a1 38 41 80 00       	mov    0x804138,%eax
  802977:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80297a:	e9 ae 01 00 00       	jmp    802b2d <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  80297f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802982:	8b 50 08             	mov    0x8(%eax),%edx
  802985:	a1 28 40 80 00       	mov    0x804028,%eax
  80298a:	39 c2                	cmp    %eax,%edx
  80298c:	0f 83 93 01 00 00    	jae    802b25 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802992:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802995:	8b 40 0c             	mov    0xc(%eax),%eax
  802998:	3b 45 08             	cmp    0x8(%ebp),%eax
  80299b:	0f 82 84 01 00 00    	jb     802b25 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  8029a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a4:	8b 40 0c             	mov    0xc(%eax),%eax
  8029a7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029aa:	0f 85 95 00 00 00    	jne    802a45 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8029b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029b4:	75 17                	jne    8029cd <alloc_block_NF+0x438>
  8029b6:	83 ec 04             	sub    $0x4,%esp
  8029b9:	68 98 3f 80 00       	push   $0x803f98
  8029be:	68 14 01 00 00       	push   $0x114
  8029c3:	68 ef 3e 80 00       	push   $0x803eef
  8029c8:	e8 c3 d8 ff ff       	call   800290 <_panic>
  8029cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d0:	8b 00                	mov    (%eax),%eax
  8029d2:	85 c0                	test   %eax,%eax
  8029d4:	74 10                	je     8029e6 <alloc_block_NF+0x451>
  8029d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d9:	8b 00                	mov    (%eax),%eax
  8029db:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029de:	8b 52 04             	mov    0x4(%edx),%edx
  8029e1:	89 50 04             	mov    %edx,0x4(%eax)
  8029e4:	eb 0b                	jmp    8029f1 <alloc_block_NF+0x45c>
  8029e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e9:	8b 40 04             	mov    0x4(%eax),%eax
  8029ec:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8029f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f4:	8b 40 04             	mov    0x4(%eax),%eax
  8029f7:	85 c0                	test   %eax,%eax
  8029f9:	74 0f                	je     802a0a <alloc_block_NF+0x475>
  8029fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fe:	8b 40 04             	mov    0x4(%eax),%eax
  802a01:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a04:	8b 12                	mov    (%edx),%edx
  802a06:	89 10                	mov    %edx,(%eax)
  802a08:	eb 0a                	jmp    802a14 <alloc_block_NF+0x47f>
  802a0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0d:	8b 00                	mov    (%eax),%eax
  802a0f:	a3 38 41 80 00       	mov    %eax,0x804138
  802a14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a17:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a20:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a27:	a1 44 41 80 00       	mov    0x804144,%eax
  802a2c:	48                   	dec    %eax
  802a2d:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  802a32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a35:	8b 40 08             	mov    0x8(%eax),%eax
  802a38:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  802a3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a40:	e9 1b 01 00 00       	jmp    802b60 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802a45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a48:	8b 40 0c             	mov    0xc(%eax),%eax
  802a4b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a4e:	0f 86 d1 00 00 00    	jbe    802b25 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802a54:	a1 48 41 80 00       	mov    0x804148,%eax
  802a59:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5f:	8b 50 08             	mov    0x8(%eax),%edx
  802a62:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a65:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802a68:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a6b:	8b 55 08             	mov    0x8(%ebp),%edx
  802a6e:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802a71:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a75:	75 17                	jne    802a8e <alloc_block_NF+0x4f9>
  802a77:	83 ec 04             	sub    $0x4,%esp
  802a7a:	68 98 3f 80 00       	push   $0x803f98
  802a7f:	68 1c 01 00 00       	push   $0x11c
  802a84:	68 ef 3e 80 00       	push   $0x803eef
  802a89:	e8 02 d8 ff ff       	call   800290 <_panic>
  802a8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a91:	8b 00                	mov    (%eax),%eax
  802a93:	85 c0                	test   %eax,%eax
  802a95:	74 10                	je     802aa7 <alloc_block_NF+0x512>
  802a97:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a9a:	8b 00                	mov    (%eax),%eax
  802a9c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a9f:	8b 52 04             	mov    0x4(%edx),%edx
  802aa2:	89 50 04             	mov    %edx,0x4(%eax)
  802aa5:	eb 0b                	jmp    802ab2 <alloc_block_NF+0x51d>
  802aa7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aaa:	8b 40 04             	mov    0x4(%eax),%eax
  802aad:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ab2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ab5:	8b 40 04             	mov    0x4(%eax),%eax
  802ab8:	85 c0                	test   %eax,%eax
  802aba:	74 0f                	je     802acb <alloc_block_NF+0x536>
  802abc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802abf:	8b 40 04             	mov    0x4(%eax),%eax
  802ac2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ac5:	8b 12                	mov    (%edx),%edx
  802ac7:	89 10                	mov    %edx,(%eax)
  802ac9:	eb 0a                	jmp    802ad5 <alloc_block_NF+0x540>
  802acb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ace:	8b 00                	mov    (%eax),%eax
  802ad0:	a3 48 41 80 00       	mov    %eax,0x804148
  802ad5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ad8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ade:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ae1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ae8:	a1 54 41 80 00       	mov    0x804154,%eax
  802aed:	48                   	dec    %eax
  802aee:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  802af3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802af6:	8b 40 08             	mov    0x8(%eax),%eax
  802af9:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  802afe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b01:	8b 50 08             	mov    0x8(%eax),%edx
  802b04:	8b 45 08             	mov    0x8(%ebp),%eax
  802b07:	01 c2                	add    %eax,%edx
  802b09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0c:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802b0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b12:	8b 40 0c             	mov    0xc(%eax),%eax
  802b15:	2b 45 08             	sub    0x8(%ebp),%eax
  802b18:	89 c2                	mov    %eax,%edx
  802b1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1d:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802b20:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b23:	eb 3b                	jmp    802b60 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b25:	a1 40 41 80 00       	mov    0x804140,%eax
  802b2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b2d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b31:	74 07                	je     802b3a <alloc_block_NF+0x5a5>
  802b33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b36:	8b 00                	mov    (%eax),%eax
  802b38:	eb 05                	jmp    802b3f <alloc_block_NF+0x5aa>
  802b3a:	b8 00 00 00 00       	mov    $0x0,%eax
  802b3f:	a3 40 41 80 00       	mov    %eax,0x804140
  802b44:	a1 40 41 80 00       	mov    0x804140,%eax
  802b49:	85 c0                	test   %eax,%eax
  802b4b:	0f 85 2e fe ff ff    	jne    80297f <alloc_block_NF+0x3ea>
  802b51:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b55:	0f 85 24 fe ff ff    	jne    80297f <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802b5b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b60:	c9                   	leave  
  802b61:	c3                   	ret    

00802b62 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802b62:	55                   	push   %ebp
  802b63:	89 e5                	mov    %esp,%ebp
  802b65:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802b68:	a1 38 41 80 00       	mov    0x804138,%eax
  802b6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802b70:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b75:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802b78:	a1 38 41 80 00       	mov    0x804138,%eax
  802b7d:	85 c0                	test   %eax,%eax
  802b7f:	74 14                	je     802b95 <insert_sorted_with_merge_freeList+0x33>
  802b81:	8b 45 08             	mov    0x8(%ebp),%eax
  802b84:	8b 50 08             	mov    0x8(%eax),%edx
  802b87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b8a:	8b 40 08             	mov    0x8(%eax),%eax
  802b8d:	39 c2                	cmp    %eax,%edx
  802b8f:	0f 87 9b 01 00 00    	ja     802d30 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802b95:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b99:	75 17                	jne    802bb2 <insert_sorted_with_merge_freeList+0x50>
  802b9b:	83 ec 04             	sub    $0x4,%esp
  802b9e:	68 cc 3e 80 00       	push   $0x803ecc
  802ba3:	68 38 01 00 00       	push   $0x138
  802ba8:	68 ef 3e 80 00       	push   $0x803eef
  802bad:	e8 de d6 ff ff       	call   800290 <_panic>
  802bb2:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbb:	89 10                	mov    %edx,(%eax)
  802bbd:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc0:	8b 00                	mov    (%eax),%eax
  802bc2:	85 c0                	test   %eax,%eax
  802bc4:	74 0d                	je     802bd3 <insert_sorted_with_merge_freeList+0x71>
  802bc6:	a1 38 41 80 00       	mov    0x804138,%eax
  802bcb:	8b 55 08             	mov    0x8(%ebp),%edx
  802bce:	89 50 04             	mov    %edx,0x4(%eax)
  802bd1:	eb 08                	jmp    802bdb <insert_sorted_with_merge_freeList+0x79>
  802bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd6:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bde:	a3 38 41 80 00       	mov    %eax,0x804138
  802be3:	8b 45 08             	mov    0x8(%ebp),%eax
  802be6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bed:	a1 44 41 80 00       	mov    0x804144,%eax
  802bf2:	40                   	inc    %eax
  802bf3:	a3 44 41 80 00       	mov    %eax,0x804144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802bf8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bfc:	0f 84 a8 06 00 00    	je     8032aa <insert_sorted_with_merge_freeList+0x748>
  802c02:	8b 45 08             	mov    0x8(%ebp),%eax
  802c05:	8b 50 08             	mov    0x8(%eax),%edx
  802c08:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0b:	8b 40 0c             	mov    0xc(%eax),%eax
  802c0e:	01 c2                	add    %eax,%edx
  802c10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c13:	8b 40 08             	mov    0x8(%eax),%eax
  802c16:	39 c2                	cmp    %eax,%edx
  802c18:	0f 85 8c 06 00 00    	jne    8032aa <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c21:	8b 50 0c             	mov    0xc(%eax),%edx
  802c24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c27:	8b 40 0c             	mov    0xc(%eax),%eax
  802c2a:	01 c2                	add    %eax,%edx
  802c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2f:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802c32:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c36:	75 17                	jne    802c4f <insert_sorted_with_merge_freeList+0xed>
  802c38:	83 ec 04             	sub    $0x4,%esp
  802c3b:	68 98 3f 80 00       	push   $0x803f98
  802c40:	68 3c 01 00 00       	push   $0x13c
  802c45:	68 ef 3e 80 00       	push   $0x803eef
  802c4a:	e8 41 d6 ff ff       	call   800290 <_panic>
  802c4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c52:	8b 00                	mov    (%eax),%eax
  802c54:	85 c0                	test   %eax,%eax
  802c56:	74 10                	je     802c68 <insert_sorted_with_merge_freeList+0x106>
  802c58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c5b:	8b 00                	mov    (%eax),%eax
  802c5d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c60:	8b 52 04             	mov    0x4(%edx),%edx
  802c63:	89 50 04             	mov    %edx,0x4(%eax)
  802c66:	eb 0b                	jmp    802c73 <insert_sorted_with_merge_freeList+0x111>
  802c68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c6b:	8b 40 04             	mov    0x4(%eax),%eax
  802c6e:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c76:	8b 40 04             	mov    0x4(%eax),%eax
  802c79:	85 c0                	test   %eax,%eax
  802c7b:	74 0f                	je     802c8c <insert_sorted_with_merge_freeList+0x12a>
  802c7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c80:	8b 40 04             	mov    0x4(%eax),%eax
  802c83:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c86:	8b 12                	mov    (%edx),%edx
  802c88:	89 10                	mov    %edx,(%eax)
  802c8a:	eb 0a                	jmp    802c96 <insert_sorted_with_merge_freeList+0x134>
  802c8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c8f:	8b 00                	mov    (%eax),%eax
  802c91:	a3 38 41 80 00       	mov    %eax,0x804138
  802c96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c99:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ca2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ca9:	a1 44 41 80 00       	mov    0x804144,%eax
  802cae:	48                   	dec    %eax
  802caf:	a3 44 41 80 00       	mov    %eax,0x804144
			head->size = 0;
  802cb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802cbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cc1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802cc8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ccc:	75 17                	jne    802ce5 <insert_sorted_with_merge_freeList+0x183>
  802cce:	83 ec 04             	sub    $0x4,%esp
  802cd1:	68 cc 3e 80 00       	push   $0x803ecc
  802cd6:	68 3f 01 00 00       	push   $0x13f
  802cdb:	68 ef 3e 80 00       	push   $0x803eef
  802ce0:	e8 ab d5 ff ff       	call   800290 <_panic>
  802ce5:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ceb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cee:	89 10                	mov    %edx,(%eax)
  802cf0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf3:	8b 00                	mov    (%eax),%eax
  802cf5:	85 c0                	test   %eax,%eax
  802cf7:	74 0d                	je     802d06 <insert_sorted_with_merge_freeList+0x1a4>
  802cf9:	a1 48 41 80 00       	mov    0x804148,%eax
  802cfe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d01:	89 50 04             	mov    %edx,0x4(%eax)
  802d04:	eb 08                	jmp    802d0e <insert_sorted_with_merge_freeList+0x1ac>
  802d06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d09:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d11:	a3 48 41 80 00       	mov    %eax,0x804148
  802d16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d19:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d20:	a1 54 41 80 00       	mov    0x804154,%eax
  802d25:	40                   	inc    %eax
  802d26:	a3 54 41 80 00       	mov    %eax,0x804154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802d2b:	e9 7a 05 00 00       	jmp    8032aa <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802d30:	8b 45 08             	mov    0x8(%ebp),%eax
  802d33:	8b 50 08             	mov    0x8(%eax),%edx
  802d36:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d39:	8b 40 08             	mov    0x8(%eax),%eax
  802d3c:	39 c2                	cmp    %eax,%edx
  802d3e:	0f 82 14 01 00 00    	jb     802e58 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802d44:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d47:	8b 50 08             	mov    0x8(%eax),%edx
  802d4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d4d:	8b 40 0c             	mov    0xc(%eax),%eax
  802d50:	01 c2                	add    %eax,%edx
  802d52:	8b 45 08             	mov    0x8(%ebp),%eax
  802d55:	8b 40 08             	mov    0x8(%eax),%eax
  802d58:	39 c2                	cmp    %eax,%edx
  802d5a:	0f 85 90 00 00 00    	jne    802df0 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802d60:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d63:	8b 50 0c             	mov    0xc(%eax),%edx
  802d66:	8b 45 08             	mov    0x8(%ebp),%eax
  802d69:	8b 40 0c             	mov    0xc(%eax),%eax
  802d6c:	01 c2                	add    %eax,%edx
  802d6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d71:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802d74:	8b 45 08             	mov    0x8(%ebp),%eax
  802d77:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d81:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802d88:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d8c:	75 17                	jne    802da5 <insert_sorted_with_merge_freeList+0x243>
  802d8e:	83 ec 04             	sub    $0x4,%esp
  802d91:	68 cc 3e 80 00       	push   $0x803ecc
  802d96:	68 49 01 00 00       	push   $0x149
  802d9b:	68 ef 3e 80 00       	push   $0x803eef
  802da0:	e8 eb d4 ff ff       	call   800290 <_panic>
  802da5:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802dab:	8b 45 08             	mov    0x8(%ebp),%eax
  802dae:	89 10                	mov    %edx,(%eax)
  802db0:	8b 45 08             	mov    0x8(%ebp),%eax
  802db3:	8b 00                	mov    (%eax),%eax
  802db5:	85 c0                	test   %eax,%eax
  802db7:	74 0d                	je     802dc6 <insert_sorted_with_merge_freeList+0x264>
  802db9:	a1 48 41 80 00       	mov    0x804148,%eax
  802dbe:	8b 55 08             	mov    0x8(%ebp),%edx
  802dc1:	89 50 04             	mov    %edx,0x4(%eax)
  802dc4:	eb 08                	jmp    802dce <insert_sorted_with_merge_freeList+0x26c>
  802dc6:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc9:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802dce:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd1:	a3 48 41 80 00       	mov    %eax,0x804148
  802dd6:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802de0:	a1 54 41 80 00       	mov    0x804154,%eax
  802de5:	40                   	inc    %eax
  802de6:	a3 54 41 80 00       	mov    %eax,0x804154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802deb:	e9 bb 04 00 00       	jmp    8032ab <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802df0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802df4:	75 17                	jne    802e0d <insert_sorted_with_merge_freeList+0x2ab>
  802df6:	83 ec 04             	sub    $0x4,%esp
  802df9:	68 40 3f 80 00       	push   $0x803f40
  802dfe:	68 4c 01 00 00       	push   $0x14c
  802e03:	68 ef 3e 80 00       	push   $0x803eef
  802e08:	e8 83 d4 ff ff       	call   800290 <_panic>
  802e0d:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802e13:	8b 45 08             	mov    0x8(%ebp),%eax
  802e16:	89 50 04             	mov    %edx,0x4(%eax)
  802e19:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1c:	8b 40 04             	mov    0x4(%eax),%eax
  802e1f:	85 c0                	test   %eax,%eax
  802e21:	74 0c                	je     802e2f <insert_sorted_with_merge_freeList+0x2cd>
  802e23:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802e28:	8b 55 08             	mov    0x8(%ebp),%edx
  802e2b:	89 10                	mov    %edx,(%eax)
  802e2d:	eb 08                	jmp    802e37 <insert_sorted_with_merge_freeList+0x2d5>
  802e2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e32:	a3 38 41 80 00       	mov    %eax,0x804138
  802e37:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3a:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e42:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e48:	a1 44 41 80 00       	mov    0x804144,%eax
  802e4d:	40                   	inc    %eax
  802e4e:	a3 44 41 80 00       	mov    %eax,0x804144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802e53:	e9 53 04 00 00       	jmp    8032ab <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802e58:	a1 38 41 80 00       	mov    0x804138,%eax
  802e5d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e60:	e9 15 04 00 00       	jmp    80327a <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802e65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e68:	8b 00                	mov    (%eax),%eax
  802e6a:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802e6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e70:	8b 50 08             	mov    0x8(%eax),%edx
  802e73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e76:	8b 40 08             	mov    0x8(%eax),%eax
  802e79:	39 c2                	cmp    %eax,%edx
  802e7b:	0f 86 f1 03 00 00    	jbe    803272 <insert_sorted_with_merge_freeList+0x710>
  802e81:	8b 45 08             	mov    0x8(%ebp),%eax
  802e84:	8b 50 08             	mov    0x8(%eax),%edx
  802e87:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e8a:	8b 40 08             	mov    0x8(%eax),%eax
  802e8d:	39 c2                	cmp    %eax,%edx
  802e8f:	0f 83 dd 03 00 00    	jae    803272 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802e95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e98:	8b 50 08             	mov    0x8(%eax),%edx
  802e9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9e:	8b 40 0c             	mov    0xc(%eax),%eax
  802ea1:	01 c2                	add    %eax,%edx
  802ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea6:	8b 40 08             	mov    0x8(%eax),%eax
  802ea9:	39 c2                	cmp    %eax,%edx
  802eab:	0f 85 b9 01 00 00    	jne    80306a <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb4:	8b 50 08             	mov    0x8(%eax),%edx
  802eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eba:	8b 40 0c             	mov    0xc(%eax),%eax
  802ebd:	01 c2                	add    %eax,%edx
  802ebf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ec2:	8b 40 08             	mov    0x8(%eax),%eax
  802ec5:	39 c2                	cmp    %eax,%edx
  802ec7:	0f 85 0d 01 00 00    	jne    802fda <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802ecd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed0:	8b 50 0c             	mov    0xc(%eax),%edx
  802ed3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ed6:	8b 40 0c             	mov    0xc(%eax),%eax
  802ed9:	01 c2                	add    %eax,%edx
  802edb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ede:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802ee1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ee5:	75 17                	jne    802efe <insert_sorted_with_merge_freeList+0x39c>
  802ee7:	83 ec 04             	sub    $0x4,%esp
  802eea:	68 98 3f 80 00       	push   $0x803f98
  802eef:	68 5c 01 00 00       	push   $0x15c
  802ef4:	68 ef 3e 80 00       	push   $0x803eef
  802ef9:	e8 92 d3 ff ff       	call   800290 <_panic>
  802efe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f01:	8b 00                	mov    (%eax),%eax
  802f03:	85 c0                	test   %eax,%eax
  802f05:	74 10                	je     802f17 <insert_sorted_with_merge_freeList+0x3b5>
  802f07:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f0a:	8b 00                	mov    (%eax),%eax
  802f0c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f0f:	8b 52 04             	mov    0x4(%edx),%edx
  802f12:	89 50 04             	mov    %edx,0x4(%eax)
  802f15:	eb 0b                	jmp    802f22 <insert_sorted_with_merge_freeList+0x3c0>
  802f17:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f1a:	8b 40 04             	mov    0x4(%eax),%eax
  802f1d:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802f22:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f25:	8b 40 04             	mov    0x4(%eax),%eax
  802f28:	85 c0                	test   %eax,%eax
  802f2a:	74 0f                	je     802f3b <insert_sorted_with_merge_freeList+0x3d9>
  802f2c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f2f:	8b 40 04             	mov    0x4(%eax),%eax
  802f32:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f35:	8b 12                	mov    (%edx),%edx
  802f37:	89 10                	mov    %edx,(%eax)
  802f39:	eb 0a                	jmp    802f45 <insert_sorted_with_merge_freeList+0x3e3>
  802f3b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f3e:	8b 00                	mov    (%eax),%eax
  802f40:	a3 38 41 80 00       	mov    %eax,0x804138
  802f45:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f48:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f4e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f51:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f58:	a1 44 41 80 00       	mov    0x804144,%eax
  802f5d:	48                   	dec    %eax
  802f5e:	a3 44 41 80 00       	mov    %eax,0x804144
						nextBlock->sva = 0;
  802f63:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f66:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  802f6d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f70:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  802f77:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f7b:	75 17                	jne    802f94 <insert_sorted_with_merge_freeList+0x432>
  802f7d:	83 ec 04             	sub    $0x4,%esp
  802f80:	68 cc 3e 80 00       	push   $0x803ecc
  802f85:	68 5f 01 00 00       	push   $0x15f
  802f8a:	68 ef 3e 80 00       	push   $0x803eef
  802f8f:	e8 fc d2 ff ff       	call   800290 <_panic>
  802f94:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f9a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f9d:	89 10                	mov    %edx,(%eax)
  802f9f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fa2:	8b 00                	mov    (%eax),%eax
  802fa4:	85 c0                	test   %eax,%eax
  802fa6:	74 0d                	je     802fb5 <insert_sorted_with_merge_freeList+0x453>
  802fa8:	a1 48 41 80 00       	mov    0x804148,%eax
  802fad:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fb0:	89 50 04             	mov    %edx,0x4(%eax)
  802fb3:	eb 08                	jmp    802fbd <insert_sorted_with_merge_freeList+0x45b>
  802fb5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fb8:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802fbd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fc0:	a3 48 41 80 00       	mov    %eax,0x804148
  802fc5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fc8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fcf:	a1 54 41 80 00       	mov    0x804154,%eax
  802fd4:	40                   	inc    %eax
  802fd5:	a3 54 41 80 00       	mov    %eax,0x804154
					}
					currentBlock->size += blockToInsert->size;
  802fda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fdd:	8b 50 0c             	mov    0xc(%eax),%edx
  802fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe3:	8b 40 0c             	mov    0xc(%eax),%eax
  802fe6:	01 c2                	add    %eax,%edx
  802fe8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802feb:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  802fee:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  802ff8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffb:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803002:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803006:	75 17                	jne    80301f <insert_sorted_with_merge_freeList+0x4bd>
  803008:	83 ec 04             	sub    $0x4,%esp
  80300b:	68 cc 3e 80 00       	push   $0x803ecc
  803010:	68 64 01 00 00       	push   $0x164
  803015:	68 ef 3e 80 00       	push   $0x803eef
  80301a:	e8 71 d2 ff ff       	call   800290 <_panic>
  80301f:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803025:	8b 45 08             	mov    0x8(%ebp),%eax
  803028:	89 10                	mov    %edx,(%eax)
  80302a:	8b 45 08             	mov    0x8(%ebp),%eax
  80302d:	8b 00                	mov    (%eax),%eax
  80302f:	85 c0                	test   %eax,%eax
  803031:	74 0d                	je     803040 <insert_sorted_with_merge_freeList+0x4de>
  803033:	a1 48 41 80 00       	mov    0x804148,%eax
  803038:	8b 55 08             	mov    0x8(%ebp),%edx
  80303b:	89 50 04             	mov    %edx,0x4(%eax)
  80303e:	eb 08                	jmp    803048 <insert_sorted_with_merge_freeList+0x4e6>
  803040:	8b 45 08             	mov    0x8(%ebp),%eax
  803043:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803048:	8b 45 08             	mov    0x8(%ebp),%eax
  80304b:	a3 48 41 80 00       	mov    %eax,0x804148
  803050:	8b 45 08             	mov    0x8(%ebp),%eax
  803053:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80305a:	a1 54 41 80 00       	mov    0x804154,%eax
  80305f:	40                   	inc    %eax
  803060:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  803065:	e9 41 02 00 00       	jmp    8032ab <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80306a:	8b 45 08             	mov    0x8(%ebp),%eax
  80306d:	8b 50 08             	mov    0x8(%eax),%edx
  803070:	8b 45 08             	mov    0x8(%ebp),%eax
  803073:	8b 40 0c             	mov    0xc(%eax),%eax
  803076:	01 c2                	add    %eax,%edx
  803078:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80307b:	8b 40 08             	mov    0x8(%eax),%eax
  80307e:	39 c2                	cmp    %eax,%edx
  803080:	0f 85 7c 01 00 00    	jne    803202 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803086:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80308a:	74 06                	je     803092 <insert_sorted_with_merge_freeList+0x530>
  80308c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803090:	75 17                	jne    8030a9 <insert_sorted_with_merge_freeList+0x547>
  803092:	83 ec 04             	sub    $0x4,%esp
  803095:	68 08 3f 80 00       	push   $0x803f08
  80309a:	68 69 01 00 00       	push   $0x169
  80309f:	68 ef 3e 80 00       	push   $0x803eef
  8030a4:	e8 e7 d1 ff ff       	call   800290 <_panic>
  8030a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ac:	8b 50 04             	mov    0x4(%eax),%edx
  8030af:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b2:	89 50 04             	mov    %edx,0x4(%eax)
  8030b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030bb:	89 10                	mov    %edx,(%eax)
  8030bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030c0:	8b 40 04             	mov    0x4(%eax),%eax
  8030c3:	85 c0                	test   %eax,%eax
  8030c5:	74 0d                	je     8030d4 <insert_sorted_with_merge_freeList+0x572>
  8030c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ca:	8b 40 04             	mov    0x4(%eax),%eax
  8030cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8030d0:	89 10                	mov    %edx,(%eax)
  8030d2:	eb 08                	jmp    8030dc <insert_sorted_with_merge_freeList+0x57a>
  8030d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d7:	a3 38 41 80 00       	mov    %eax,0x804138
  8030dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030df:	8b 55 08             	mov    0x8(%ebp),%edx
  8030e2:	89 50 04             	mov    %edx,0x4(%eax)
  8030e5:	a1 44 41 80 00       	mov    0x804144,%eax
  8030ea:	40                   	inc    %eax
  8030eb:	a3 44 41 80 00       	mov    %eax,0x804144
					blockToInsert->size += nextBlock->size;
  8030f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f3:	8b 50 0c             	mov    0xc(%eax),%edx
  8030f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030f9:	8b 40 0c             	mov    0xc(%eax),%eax
  8030fc:	01 c2                	add    %eax,%edx
  8030fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803101:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803104:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803108:	75 17                	jne    803121 <insert_sorted_with_merge_freeList+0x5bf>
  80310a:	83 ec 04             	sub    $0x4,%esp
  80310d:	68 98 3f 80 00       	push   $0x803f98
  803112:	68 6b 01 00 00       	push   $0x16b
  803117:	68 ef 3e 80 00       	push   $0x803eef
  80311c:	e8 6f d1 ff ff       	call   800290 <_panic>
  803121:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803124:	8b 00                	mov    (%eax),%eax
  803126:	85 c0                	test   %eax,%eax
  803128:	74 10                	je     80313a <insert_sorted_with_merge_freeList+0x5d8>
  80312a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80312d:	8b 00                	mov    (%eax),%eax
  80312f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803132:	8b 52 04             	mov    0x4(%edx),%edx
  803135:	89 50 04             	mov    %edx,0x4(%eax)
  803138:	eb 0b                	jmp    803145 <insert_sorted_with_merge_freeList+0x5e3>
  80313a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80313d:	8b 40 04             	mov    0x4(%eax),%eax
  803140:	a3 3c 41 80 00       	mov    %eax,0x80413c
  803145:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803148:	8b 40 04             	mov    0x4(%eax),%eax
  80314b:	85 c0                	test   %eax,%eax
  80314d:	74 0f                	je     80315e <insert_sorted_with_merge_freeList+0x5fc>
  80314f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803152:	8b 40 04             	mov    0x4(%eax),%eax
  803155:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803158:	8b 12                	mov    (%edx),%edx
  80315a:	89 10                	mov    %edx,(%eax)
  80315c:	eb 0a                	jmp    803168 <insert_sorted_with_merge_freeList+0x606>
  80315e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803161:	8b 00                	mov    (%eax),%eax
  803163:	a3 38 41 80 00       	mov    %eax,0x804138
  803168:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80316b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803171:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803174:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80317b:	a1 44 41 80 00       	mov    0x804144,%eax
  803180:	48                   	dec    %eax
  803181:	a3 44 41 80 00       	mov    %eax,0x804144
					nextBlock->sva = 0;
  803186:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803189:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803190:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803193:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80319a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80319e:	75 17                	jne    8031b7 <insert_sorted_with_merge_freeList+0x655>
  8031a0:	83 ec 04             	sub    $0x4,%esp
  8031a3:	68 cc 3e 80 00       	push   $0x803ecc
  8031a8:	68 6e 01 00 00       	push   $0x16e
  8031ad:	68 ef 3e 80 00       	push   $0x803eef
  8031b2:	e8 d9 d0 ff ff       	call   800290 <_panic>
  8031b7:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8031bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c0:	89 10                	mov    %edx,(%eax)
  8031c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c5:	8b 00                	mov    (%eax),%eax
  8031c7:	85 c0                	test   %eax,%eax
  8031c9:	74 0d                	je     8031d8 <insert_sorted_with_merge_freeList+0x676>
  8031cb:	a1 48 41 80 00       	mov    0x804148,%eax
  8031d0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031d3:	89 50 04             	mov    %edx,0x4(%eax)
  8031d6:	eb 08                	jmp    8031e0 <insert_sorted_with_merge_freeList+0x67e>
  8031d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031db:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8031e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e3:	a3 48 41 80 00       	mov    %eax,0x804148
  8031e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031eb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031f2:	a1 54 41 80 00       	mov    0x804154,%eax
  8031f7:	40                   	inc    %eax
  8031f8:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  8031fd:	e9 a9 00 00 00       	jmp    8032ab <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803202:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803206:	74 06                	je     80320e <insert_sorted_with_merge_freeList+0x6ac>
  803208:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80320c:	75 17                	jne    803225 <insert_sorted_with_merge_freeList+0x6c3>
  80320e:	83 ec 04             	sub    $0x4,%esp
  803211:	68 64 3f 80 00       	push   $0x803f64
  803216:	68 73 01 00 00       	push   $0x173
  80321b:	68 ef 3e 80 00       	push   $0x803eef
  803220:	e8 6b d0 ff ff       	call   800290 <_panic>
  803225:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803228:	8b 10                	mov    (%eax),%edx
  80322a:	8b 45 08             	mov    0x8(%ebp),%eax
  80322d:	89 10                	mov    %edx,(%eax)
  80322f:	8b 45 08             	mov    0x8(%ebp),%eax
  803232:	8b 00                	mov    (%eax),%eax
  803234:	85 c0                	test   %eax,%eax
  803236:	74 0b                	je     803243 <insert_sorted_with_merge_freeList+0x6e1>
  803238:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80323b:	8b 00                	mov    (%eax),%eax
  80323d:	8b 55 08             	mov    0x8(%ebp),%edx
  803240:	89 50 04             	mov    %edx,0x4(%eax)
  803243:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803246:	8b 55 08             	mov    0x8(%ebp),%edx
  803249:	89 10                	mov    %edx,(%eax)
  80324b:	8b 45 08             	mov    0x8(%ebp),%eax
  80324e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803251:	89 50 04             	mov    %edx,0x4(%eax)
  803254:	8b 45 08             	mov    0x8(%ebp),%eax
  803257:	8b 00                	mov    (%eax),%eax
  803259:	85 c0                	test   %eax,%eax
  80325b:	75 08                	jne    803265 <insert_sorted_with_merge_freeList+0x703>
  80325d:	8b 45 08             	mov    0x8(%ebp),%eax
  803260:	a3 3c 41 80 00       	mov    %eax,0x80413c
  803265:	a1 44 41 80 00       	mov    0x804144,%eax
  80326a:	40                   	inc    %eax
  80326b:	a3 44 41 80 00       	mov    %eax,0x804144
					break;
  803270:	eb 39                	jmp    8032ab <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803272:	a1 40 41 80 00       	mov    0x804140,%eax
  803277:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80327a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80327e:	74 07                	je     803287 <insert_sorted_with_merge_freeList+0x725>
  803280:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803283:	8b 00                	mov    (%eax),%eax
  803285:	eb 05                	jmp    80328c <insert_sorted_with_merge_freeList+0x72a>
  803287:	b8 00 00 00 00       	mov    $0x0,%eax
  80328c:	a3 40 41 80 00       	mov    %eax,0x804140
  803291:	a1 40 41 80 00       	mov    0x804140,%eax
  803296:	85 c0                	test   %eax,%eax
  803298:	0f 85 c7 fb ff ff    	jne    802e65 <insert_sorted_with_merge_freeList+0x303>
  80329e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032a2:	0f 85 bd fb ff ff    	jne    802e65 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8032a8:	eb 01                	jmp    8032ab <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8032aa:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8032ab:	90                   	nop
  8032ac:	c9                   	leave  
  8032ad:	c3                   	ret    

008032ae <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8032ae:	55                   	push   %ebp
  8032af:	89 e5                	mov    %esp,%ebp
  8032b1:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8032b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8032b7:	89 d0                	mov    %edx,%eax
  8032b9:	c1 e0 02             	shl    $0x2,%eax
  8032bc:	01 d0                	add    %edx,%eax
  8032be:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8032c5:	01 d0                	add    %edx,%eax
  8032c7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8032ce:	01 d0                	add    %edx,%eax
  8032d0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8032d7:	01 d0                	add    %edx,%eax
  8032d9:	c1 e0 04             	shl    $0x4,%eax
  8032dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8032df:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8032e6:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8032e9:	83 ec 0c             	sub    $0xc,%esp
  8032ec:	50                   	push   %eax
  8032ed:	e8 26 e7 ff ff       	call   801a18 <sys_get_virtual_time>
  8032f2:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8032f5:	eb 41                	jmp    803338 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8032f7:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8032fa:	83 ec 0c             	sub    $0xc,%esp
  8032fd:	50                   	push   %eax
  8032fe:	e8 15 e7 ff ff       	call   801a18 <sys_get_virtual_time>
  803303:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803306:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803309:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80330c:	29 c2                	sub    %eax,%edx
  80330e:	89 d0                	mov    %edx,%eax
  803310:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803313:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803316:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803319:	89 d1                	mov    %edx,%ecx
  80331b:	29 c1                	sub    %eax,%ecx
  80331d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803320:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803323:	39 c2                	cmp    %eax,%edx
  803325:	0f 97 c0             	seta   %al
  803328:	0f b6 c0             	movzbl %al,%eax
  80332b:	29 c1                	sub    %eax,%ecx
  80332d:	89 c8                	mov    %ecx,%eax
  80332f:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803332:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803335:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803338:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80333b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80333e:	72 b7                	jb     8032f7 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803340:	90                   	nop
  803341:	c9                   	leave  
  803342:	c3                   	ret    

00803343 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803343:	55                   	push   %ebp
  803344:	89 e5                	mov    %esp,%ebp
  803346:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803349:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803350:	eb 03                	jmp    803355 <busy_wait+0x12>
  803352:	ff 45 fc             	incl   -0x4(%ebp)
  803355:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803358:	3b 45 08             	cmp    0x8(%ebp),%eax
  80335b:	72 f5                	jb     803352 <busy_wait+0xf>
	return i;
  80335d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803360:	c9                   	leave  
  803361:	c3                   	ret    
  803362:	66 90                	xchg   %ax,%ax

00803364 <__udivdi3>:
  803364:	55                   	push   %ebp
  803365:	57                   	push   %edi
  803366:	56                   	push   %esi
  803367:	53                   	push   %ebx
  803368:	83 ec 1c             	sub    $0x1c,%esp
  80336b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80336f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803373:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803377:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80337b:	89 ca                	mov    %ecx,%edx
  80337d:	89 f8                	mov    %edi,%eax
  80337f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803383:	85 f6                	test   %esi,%esi
  803385:	75 2d                	jne    8033b4 <__udivdi3+0x50>
  803387:	39 cf                	cmp    %ecx,%edi
  803389:	77 65                	ja     8033f0 <__udivdi3+0x8c>
  80338b:	89 fd                	mov    %edi,%ebp
  80338d:	85 ff                	test   %edi,%edi
  80338f:	75 0b                	jne    80339c <__udivdi3+0x38>
  803391:	b8 01 00 00 00       	mov    $0x1,%eax
  803396:	31 d2                	xor    %edx,%edx
  803398:	f7 f7                	div    %edi
  80339a:	89 c5                	mov    %eax,%ebp
  80339c:	31 d2                	xor    %edx,%edx
  80339e:	89 c8                	mov    %ecx,%eax
  8033a0:	f7 f5                	div    %ebp
  8033a2:	89 c1                	mov    %eax,%ecx
  8033a4:	89 d8                	mov    %ebx,%eax
  8033a6:	f7 f5                	div    %ebp
  8033a8:	89 cf                	mov    %ecx,%edi
  8033aa:	89 fa                	mov    %edi,%edx
  8033ac:	83 c4 1c             	add    $0x1c,%esp
  8033af:	5b                   	pop    %ebx
  8033b0:	5e                   	pop    %esi
  8033b1:	5f                   	pop    %edi
  8033b2:	5d                   	pop    %ebp
  8033b3:	c3                   	ret    
  8033b4:	39 ce                	cmp    %ecx,%esi
  8033b6:	77 28                	ja     8033e0 <__udivdi3+0x7c>
  8033b8:	0f bd fe             	bsr    %esi,%edi
  8033bb:	83 f7 1f             	xor    $0x1f,%edi
  8033be:	75 40                	jne    803400 <__udivdi3+0x9c>
  8033c0:	39 ce                	cmp    %ecx,%esi
  8033c2:	72 0a                	jb     8033ce <__udivdi3+0x6a>
  8033c4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8033c8:	0f 87 9e 00 00 00    	ja     80346c <__udivdi3+0x108>
  8033ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8033d3:	89 fa                	mov    %edi,%edx
  8033d5:	83 c4 1c             	add    $0x1c,%esp
  8033d8:	5b                   	pop    %ebx
  8033d9:	5e                   	pop    %esi
  8033da:	5f                   	pop    %edi
  8033db:	5d                   	pop    %ebp
  8033dc:	c3                   	ret    
  8033dd:	8d 76 00             	lea    0x0(%esi),%esi
  8033e0:	31 ff                	xor    %edi,%edi
  8033e2:	31 c0                	xor    %eax,%eax
  8033e4:	89 fa                	mov    %edi,%edx
  8033e6:	83 c4 1c             	add    $0x1c,%esp
  8033e9:	5b                   	pop    %ebx
  8033ea:	5e                   	pop    %esi
  8033eb:	5f                   	pop    %edi
  8033ec:	5d                   	pop    %ebp
  8033ed:	c3                   	ret    
  8033ee:	66 90                	xchg   %ax,%ax
  8033f0:	89 d8                	mov    %ebx,%eax
  8033f2:	f7 f7                	div    %edi
  8033f4:	31 ff                	xor    %edi,%edi
  8033f6:	89 fa                	mov    %edi,%edx
  8033f8:	83 c4 1c             	add    $0x1c,%esp
  8033fb:	5b                   	pop    %ebx
  8033fc:	5e                   	pop    %esi
  8033fd:	5f                   	pop    %edi
  8033fe:	5d                   	pop    %ebp
  8033ff:	c3                   	ret    
  803400:	bd 20 00 00 00       	mov    $0x20,%ebp
  803405:	89 eb                	mov    %ebp,%ebx
  803407:	29 fb                	sub    %edi,%ebx
  803409:	89 f9                	mov    %edi,%ecx
  80340b:	d3 e6                	shl    %cl,%esi
  80340d:	89 c5                	mov    %eax,%ebp
  80340f:	88 d9                	mov    %bl,%cl
  803411:	d3 ed                	shr    %cl,%ebp
  803413:	89 e9                	mov    %ebp,%ecx
  803415:	09 f1                	or     %esi,%ecx
  803417:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80341b:	89 f9                	mov    %edi,%ecx
  80341d:	d3 e0                	shl    %cl,%eax
  80341f:	89 c5                	mov    %eax,%ebp
  803421:	89 d6                	mov    %edx,%esi
  803423:	88 d9                	mov    %bl,%cl
  803425:	d3 ee                	shr    %cl,%esi
  803427:	89 f9                	mov    %edi,%ecx
  803429:	d3 e2                	shl    %cl,%edx
  80342b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80342f:	88 d9                	mov    %bl,%cl
  803431:	d3 e8                	shr    %cl,%eax
  803433:	09 c2                	or     %eax,%edx
  803435:	89 d0                	mov    %edx,%eax
  803437:	89 f2                	mov    %esi,%edx
  803439:	f7 74 24 0c          	divl   0xc(%esp)
  80343d:	89 d6                	mov    %edx,%esi
  80343f:	89 c3                	mov    %eax,%ebx
  803441:	f7 e5                	mul    %ebp
  803443:	39 d6                	cmp    %edx,%esi
  803445:	72 19                	jb     803460 <__udivdi3+0xfc>
  803447:	74 0b                	je     803454 <__udivdi3+0xf0>
  803449:	89 d8                	mov    %ebx,%eax
  80344b:	31 ff                	xor    %edi,%edi
  80344d:	e9 58 ff ff ff       	jmp    8033aa <__udivdi3+0x46>
  803452:	66 90                	xchg   %ax,%ax
  803454:	8b 54 24 08          	mov    0x8(%esp),%edx
  803458:	89 f9                	mov    %edi,%ecx
  80345a:	d3 e2                	shl    %cl,%edx
  80345c:	39 c2                	cmp    %eax,%edx
  80345e:	73 e9                	jae    803449 <__udivdi3+0xe5>
  803460:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803463:	31 ff                	xor    %edi,%edi
  803465:	e9 40 ff ff ff       	jmp    8033aa <__udivdi3+0x46>
  80346a:	66 90                	xchg   %ax,%ax
  80346c:	31 c0                	xor    %eax,%eax
  80346e:	e9 37 ff ff ff       	jmp    8033aa <__udivdi3+0x46>
  803473:	90                   	nop

00803474 <__umoddi3>:
  803474:	55                   	push   %ebp
  803475:	57                   	push   %edi
  803476:	56                   	push   %esi
  803477:	53                   	push   %ebx
  803478:	83 ec 1c             	sub    $0x1c,%esp
  80347b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80347f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803483:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803487:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80348b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80348f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803493:	89 f3                	mov    %esi,%ebx
  803495:	89 fa                	mov    %edi,%edx
  803497:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80349b:	89 34 24             	mov    %esi,(%esp)
  80349e:	85 c0                	test   %eax,%eax
  8034a0:	75 1a                	jne    8034bc <__umoddi3+0x48>
  8034a2:	39 f7                	cmp    %esi,%edi
  8034a4:	0f 86 a2 00 00 00    	jbe    80354c <__umoddi3+0xd8>
  8034aa:	89 c8                	mov    %ecx,%eax
  8034ac:	89 f2                	mov    %esi,%edx
  8034ae:	f7 f7                	div    %edi
  8034b0:	89 d0                	mov    %edx,%eax
  8034b2:	31 d2                	xor    %edx,%edx
  8034b4:	83 c4 1c             	add    $0x1c,%esp
  8034b7:	5b                   	pop    %ebx
  8034b8:	5e                   	pop    %esi
  8034b9:	5f                   	pop    %edi
  8034ba:	5d                   	pop    %ebp
  8034bb:	c3                   	ret    
  8034bc:	39 f0                	cmp    %esi,%eax
  8034be:	0f 87 ac 00 00 00    	ja     803570 <__umoddi3+0xfc>
  8034c4:	0f bd e8             	bsr    %eax,%ebp
  8034c7:	83 f5 1f             	xor    $0x1f,%ebp
  8034ca:	0f 84 ac 00 00 00    	je     80357c <__umoddi3+0x108>
  8034d0:	bf 20 00 00 00       	mov    $0x20,%edi
  8034d5:	29 ef                	sub    %ebp,%edi
  8034d7:	89 fe                	mov    %edi,%esi
  8034d9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8034dd:	89 e9                	mov    %ebp,%ecx
  8034df:	d3 e0                	shl    %cl,%eax
  8034e1:	89 d7                	mov    %edx,%edi
  8034e3:	89 f1                	mov    %esi,%ecx
  8034e5:	d3 ef                	shr    %cl,%edi
  8034e7:	09 c7                	or     %eax,%edi
  8034e9:	89 e9                	mov    %ebp,%ecx
  8034eb:	d3 e2                	shl    %cl,%edx
  8034ed:	89 14 24             	mov    %edx,(%esp)
  8034f0:	89 d8                	mov    %ebx,%eax
  8034f2:	d3 e0                	shl    %cl,%eax
  8034f4:	89 c2                	mov    %eax,%edx
  8034f6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034fa:	d3 e0                	shl    %cl,%eax
  8034fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  803500:	8b 44 24 08          	mov    0x8(%esp),%eax
  803504:	89 f1                	mov    %esi,%ecx
  803506:	d3 e8                	shr    %cl,%eax
  803508:	09 d0                	or     %edx,%eax
  80350a:	d3 eb                	shr    %cl,%ebx
  80350c:	89 da                	mov    %ebx,%edx
  80350e:	f7 f7                	div    %edi
  803510:	89 d3                	mov    %edx,%ebx
  803512:	f7 24 24             	mull   (%esp)
  803515:	89 c6                	mov    %eax,%esi
  803517:	89 d1                	mov    %edx,%ecx
  803519:	39 d3                	cmp    %edx,%ebx
  80351b:	0f 82 87 00 00 00    	jb     8035a8 <__umoddi3+0x134>
  803521:	0f 84 91 00 00 00    	je     8035b8 <__umoddi3+0x144>
  803527:	8b 54 24 04          	mov    0x4(%esp),%edx
  80352b:	29 f2                	sub    %esi,%edx
  80352d:	19 cb                	sbb    %ecx,%ebx
  80352f:	89 d8                	mov    %ebx,%eax
  803531:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803535:	d3 e0                	shl    %cl,%eax
  803537:	89 e9                	mov    %ebp,%ecx
  803539:	d3 ea                	shr    %cl,%edx
  80353b:	09 d0                	or     %edx,%eax
  80353d:	89 e9                	mov    %ebp,%ecx
  80353f:	d3 eb                	shr    %cl,%ebx
  803541:	89 da                	mov    %ebx,%edx
  803543:	83 c4 1c             	add    $0x1c,%esp
  803546:	5b                   	pop    %ebx
  803547:	5e                   	pop    %esi
  803548:	5f                   	pop    %edi
  803549:	5d                   	pop    %ebp
  80354a:	c3                   	ret    
  80354b:	90                   	nop
  80354c:	89 fd                	mov    %edi,%ebp
  80354e:	85 ff                	test   %edi,%edi
  803550:	75 0b                	jne    80355d <__umoddi3+0xe9>
  803552:	b8 01 00 00 00       	mov    $0x1,%eax
  803557:	31 d2                	xor    %edx,%edx
  803559:	f7 f7                	div    %edi
  80355b:	89 c5                	mov    %eax,%ebp
  80355d:	89 f0                	mov    %esi,%eax
  80355f:	31 d2                	xor    %edx,%edx
  803561:	f7 f5                	div    %ebp
  803563:	89 c8                	mov    %ecx,%eax
  803565:	f7 f5                	div    %ebp
  803567:	89 d0                	mov    %edx,%eax
  803569:	e9 44 ff ff ff       	jmp    8034b2 <__umoddi3+0x3e>
  80356e:	66 90                	xchg   %ax,%ax
  803570:	89 c8                	mov    %ecx,%eax
  803572:	89 f2                	mov    %esi,%edx
  803574:	83 c4 1c             	add    $0x1c,%esp
  803577:	5b                   	pop    %ebx
  803578:	5e                   	pop    %esi
  803579:	5f                   	pop    %edi
  80357a:	5d                   	pop    %ebp
  80357b:	c3                   	ret    
  80357c:	3b 04 24             	cmp    (%esp),%eax
  80357f:	72 06                	jb     803587 <__umoddi3+0x113>
  803581:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803585:	77 0f                	ja     803596 <__umoddi3+0x122>
  803587:	89 f2                	mov    %esi,%edx
  803589:	29 f9                	sub    %edi,%ecx
  80358b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80358f:	89 14 24             	mov    %edx,(%esp)
  803592:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803596:	8b 44 24 04          	mov    0x4(%esp),%eax
  80359a:	8b 14 24             	mov    (%esp),%edx
  80359d:	83 c4 1c             	add    $0x1c,%esp
  8035a0:	5b                   	pop    %ebx
  8035a1:	5e                   	pop    %esi
  8035a2:	5f                   	pop    %edi
  8035a3:	5d                   	pop    %ebp
  8035a4:	c3                   	ret    
  8035a5:	8d 76 00             	lea    0x0(%esi),%esi
  8035a8:	2b 04 24             	sub    (%esp),%eax
  8035ab:	19 fa                	sbb    %edi,%edx
  8035ad:	89 d1                	mov    %edx,%ecx
  8035af:	89 c6                	mov    %eax,%esi
  8035b1:	e9 71 ff ff ff       	jmp    803527 <__umoddi3+0xb3>
  8035b6:	66 90                	xchg   %ax,%ax
  8035b8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8035bc:	72 ea                	jb     8035a8 <__umoddi3+0x134>
  8035be:	89 d9                	mov    %ebx,%ecx
  8035c0:	e9 62 ff ff ff       	jmp    803527 <__umoddi3+0xb3>
