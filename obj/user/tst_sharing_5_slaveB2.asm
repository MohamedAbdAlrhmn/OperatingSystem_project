
obj/user/tst_sharing_5_slaveB2:     file format elf32-i386


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
  800031:	e8 44 01 00 00       	call   80017a <libmain>
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
  80008c:	68 00 38 80 00       	push   $0x803800
  800091:	6a 12                	push   $0x12
  800093:	68 1c 38 80 00       	push   $0x80381c
  800098:	e8 19 02 00 00       	call   8002b6 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  80009d:	83 ec 0c             	sub    $0xc,%esp
  8000a0:	6a 00                	push   $0x0
  8000a2:	e8 4b 14 00 00       	call   8014f2 <malloc>
  8000a7:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	uint32 *z;
	z = sget(sys_getparentenvid(),"z");
  8000aa:	e8 59 1b 00 00       	call   801c08 <sys_getparentenvid>
  8000af:	83 ec 08             	sub    $0x8,%esp
  8000b2:	68 39 38 80 00       	push   $0x803839
  8000b7:	50                   	push   %eax
  8000b8:	e8 2e 16 00 00       	call   8016eb <sget>
  8000bd:	83 c4 10             	add    $0x10,%esp
  8000c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("Slave B2 env used z (getSharedObject)\n");
  8000c3:	83 ec 0c             	sub    $0xc,%esp
  8000c6:	68 3c 38 80 00       	push   $0x80383c
  8000cb:	e8 9a 04 00 00       	call   80056a <cprintf>
  8000d0:	83 c4 10             	add    $0x10,%esp
	//To indicate that it's successfully got z
	inctst();
  8000d3:	e8 55 1c 00 00       	call   801d2d <inctst>

	cprintf("Slave B2 please be patient ...\n");
  8000d8:	83 ec 0c             	sub    $0xc,%esp
  8000db:	68 64 38 80 00       	push   $0x803864
  8000e0:	e8 85 04 00 00       	call   80056a <cprintf>
  8000e5:	83 c4 10             	add    $0x10,%esp

	//sleep a while to allow the master to remove x & z
	env_sleep(9000);
  8000e8:	83 ec 0c             	sub    $0xc,%esp
  8000eb:	68 28 23 00 00       	push   $0x2328
  8000f0:	e8 dc 33 00 00       	call   8034d1 <env_sleep>
  8000f5:	83 c4 10             	add    $0x10,%esp
	//to ensure that the other environments completed successfully
	while (gettst()!=2) ;// panic("test failed");
  8000f8:	90                   	nop
  8000f9:	e8 49 1c 00 00       	call   801d47 <gettst>
  8000fe:	83 f8 02             	cmp    $0x2,%eax
  800101:	75 f6                	jne    8000f9 <_main+0xc1>

	int freeFrames = sys_calculate_free_frames() ;
  800103:	e8 07 18 00 00       	call   80190f <sys_calculate_free_frames>
  800108:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sfree(z);
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	ff 75 ec             	pushl  -0x14(%ebp)
  800111:	e8 99 16 00 00       	call   8017af <sfree>
  800116:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave B2 env removed z\n");
  800119:	83 ec 0c             	sub    $0xc,%esp
  80011c:	68 84 38 80 00       	push   $0x803884
  800121:	e8 44 04 00 00       	call   80056a <cprintf>
  800126:	83 c4 10             	add    $0x10,%esp
	int expected = (1+1) + (1+1);
  800129:	c7 45 e4 04 00 00 00 	movl   $0x4,-0x1c(%ebp)
	if ((sys_calculate_free_frames() - freeFrames) !=  expected) panic("wrong free: frames removed not equal 4 !, correct frames to be removed are 4:\nfrom the env: 1 table + 1 frame for z\nframes_storage of z: should be cleared now\n");
  800130:	e8 da 17 00 00       	call   80190f <sys_calculate_free_frames>
  800135:	89 c2                	mov    %eax,%edx
  800137:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80013a:	29 c2                	sub    %eax,%edx
  80013c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80013f:	39 c2                	cmp    %eax,%edx
  800141:	74 14                	je     800157 <_main+0x11f>
  800143:	83 ec 04             	sub    $0x4,%esp
  800146:	68 9c 38 80 00       	push   $0x80389c
  80014b:	6a 2a                	push   $0x2a
  80014d:	68 1c 38 80 00       	push   $0x80381c
  800152:	e8 5f 01 00 00       	call   8002b6 <_panic>


	cprintf("Step B completed successfully!!\n\n\n");
  800157:	83 ec 0c             	sub    $0xc,%esp
  80015a:	68 3c 39 80 00       	push   $0x80393c
  80015f:	e8 06 04 00 00       	call   80056a <cprintf>
  800164:	83 c4 10             	add    $0x10,%esp
	cprintf("Congratulations!! Test of freeSharedObjects [5] completed successfully!!\n\n\n");
  800167:	83 ec 0c             	sub    $0xc,%esp
  80016a:	68 60 39 80 00       	push   $0x803960
  80016f:	e8 f6 03 00 00       	call   80056a <cprintf>
  800174:	83 c4 10             	add    $0x10,%esp

	return;
  800177:	90                   	nop
}
  800178:	c9                   	leave  
  800179:	c3                   	ret    

0080017a <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80017a:	55                   	push   %ebp
  80017b:	89 e5                	mov    %esp,%ebp
  80017d:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800180:	e8 6a 1a 00 00       	call   801bef <sys_getenvindex>
  800185:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800188:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80018b:	89 d0                	mov    %edx,%eax
  80018d:	c1 e0 03             	shl    $0x3,%eax
  800190:	01 d0                	add    %edx,%eax
  800192:	01 c0                	add    %eax,%eax
  800194:	01 d0                	add    %edx,%eax
  800196:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80019d:	01 d0                	add    %edx,%eax
  80019f:	c1 e0 04             	shl    $0x4,%eax
  8001a2:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001a7:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001ac:	a1 20 50 80 00       	mov    0x805020,%eax
  8001b1:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8001b7:	84 c0                	test   %al,%al
  8001b9:	74 0f                	je     8001ca <libmain+0x50>
		binaryname = myEnv->prog_name;
  8001bb:	a1 20 50 80 00       	mov    0x805020,%eax
  8001c0:	05 5c 05 00 00       	add    $0x55c,%eax
  8001c5:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001ca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001ce:	7e 0a                	jle    8001da <libmain+0x60>
		binaryname = argv[0];
  8001d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001d3:	8b 00                	mov    (%eax),%eax
  8001d5:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8001da:	83 ec 08             	sub    $0x8,%esp
  8001dd:	ff 75 0c             	pushl  0xc(%ebp)
  8001e0:	ff 75 08             	pushl  0x8(%ebp)
  8001e3:	e8 50 fe ff ff       	call   800038 <_main>
  8001e8:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001eb:	e8 0c 18 00 00       	call   8019fc <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001f0:	83 ec 0c             	sub    $0xc,%esp
  8001f3:	68 c4 39 80 00       	push   $0x8039c4
  8001f8:	e8 6d 03 00 00       	call   80056a <cprintf>
  8001fd:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800200:	a1 20 50 80 00       	mov    0x805020,%eax
  800205:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80020b:	a1 20 50 80 00       	mov    0x805020,%eax
  800210:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800216:	83 ec 04             	sub    $0x4,%esp
  800219:	52                   	push   %edx
  80021a:	50                   	push   %eax
  80021b:	68 ec 39 80 00       	push   $0x8039ec
  800220:	e8 45 03 00 00       	call   80056a <cprintf>
  800225:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800228:	a1 20 50 80 00       	mov    0x805020,%eax
  80022d:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800233:	a1 20 50 80 00       	mov    0x805020,%eax
  800238:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80023e:	a1 20 50 80 00       	mov    0x805020,%eax
  800243:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800249:	51                   	push   %ecx
  80024a:	52                   	push   %edx
  80024b:	50                   	push   %eax
  80024c:	68 14 3a 80 00       	push   $0x803a14
  800251:	e8 14 03 00 00       	call   80056a <cprintf>
  800256:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800259:	a1 20 50 80 00       	mov    0x805020,%eax
  80025e:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800264:	83 ec 08             	sub    $0x8,%esp
  800267:	50                   	push   %eax
  800268:	68 6c 3a 80 00       	push   $0x803a6c
  80026d:	e8 f8 02 00 00       	call   80056a <cprintf>
  800272:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800275:	83 ec 0c             	sub    $0xc,%esp
  800278:	68 c4 39 80 00       	push   $0x8039c4
  80027d:	e8 e8 02 00 00       	call   80056a <cprintf>
  800282:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800285:	e8 8c 17 00 00       	call   801a16 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80028a:	e8 19 00 00 00       	call   8002a8 <exit>
}
  80028f:	90                   	nop
  800290:	c9                   	leave  
  800291:	c3                   	ret    

00800292 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800292:	55                   	push   %ebp
  800293:	89 e5                	mov    %esp,%ebp
  800295:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800298:	83 ec 0c             	sub    $0xc,%esp
  80029b:	6a 00                	push   $0x0
  80029d:	e8 19 19 00 00       	call   801bbb <sys_destroy_env>
  8002a2:	83 c4 10             	add    $0x10,%esp
}
  8002a5:	90                   	nop
  8002a6:	c9                   	leave  
  8002a7:	c3                   	ret    

008002a8 <exit>:

void
exit(void)
{
  8002a8:	55                   	push   %ebp
  8002a9:	89 e5                	mov    %esp,%ebp
  8002ab:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002ae:	e8 6e 19 00 00       	call   801c21 <sys_exit_env>
}
  8002b3:	90                   	nop
  8002b4:	c9                   	leave  
  8002b5:	c3                   	ret    

008002b6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002b6:	55                   	push   %ebp
  8002b7:	89 e5                	mov    %esp,%ebp
  8002b9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002bc:	8d 45 10             	lea    0x10(%ebp),%eax
  8002bf:	83 c0 04             	add    $0x4,%eax
  8002c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002c5:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8002ca:	85 c0                	test   %eax,%eax
  8002cc:	74 16                	je     8002e4 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002ce:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8002d3:	83 ec 08             	sub    $0x8,%esp
  8002d6:	50                   	push   %eax
  8002d7:	68 80 3a 80 00       	push   $0x803a80
  8002dc:	e8 89 02 00 00       	call   80056a <cprintf>
  8002e1:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002e4:	a1 00 50 80 00       	mov    0x805000,%eax
  8002e9:	ff 75 0c             	pushl  0xc(%ebp)
  8002ec:	ff 75 08             	pushl  0x8(%ebp)
  8002ef:	50                   	push   %eax
  8002f0:	68 85 3a 80 00       	push   $0x803a85
  8002f5:	e8 70 02 00 00       	call   80056a <cprintf>
  8002fa:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002fd:	8b 45 10             	mov    0x10(%ebp),%eax
  800300:	83 ec 08             	sub    $0x8,%esp
  800303:	ff 75 f4             	pushl  -0xc(%ebp)
  800306:	50                   	push   %eax
  800307:	e8 f3 01 00 00       	call   8004ff <vcprintf>
  80030c:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80030f:	83 ec 08             	sub    $0x8,%esp
  800312:	6a 00                	push   $0x0
  800314:	68 a1 3a 80 00       	push   $0x803aa1
  800319:	e8 e1 01 00 00       	call   8004ff <vcprintf>
  80031e:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800321:	e8 82 ff ff ff       	call   8002a8 <exit>

	// should not return here
	while (1) ;
  800326:	eb fe                	jmp    800326 <_panic+0x70>

00800328 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800328:	55                   	push   %ebp
  800329:	89 e5                	mov    %esp,%ebp
  80032b:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80032e:	a1 20 50 80 00       	mov    0x805020,%eax
  800333:	8b 50 74             	mov    0x74(%eax),%edx
  800336:	8b 45 0c             	mov    0xc(%ebp),%eax
  800339:	39 c2                	cmp    %eax,%edx
  80033b:	74 14                	je     800351 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80033d:	83 ec 04             	sub    $0x4,%esp
  800340:	68 a4 3a 80 00       	push   $0x803aa4
  800345:	6a 26                	push   $0x26
  800347:	68 f0 3a 80 00       	push   $0x803af0
  80034c:	e8 65 ff ff ff       	call   8002b6 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800351:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800358:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80035f:	e9 c2 00 00 00       	jmp    800426 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800364:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800367:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80036e:	8b 45 08             	mov    0x8(%ebp),%eax
  800371:	01 d0                	add    %edx,%eax
  800373:	8b 00                	mov    (%eax),%eax
  800375:	85 c0                	test   %eax,%eax
  800377:	75 08                	jne    800381 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800379:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80037c:	e9 a2 00 00 00       	jmp    800423 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800381:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800388:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80038f:	eb 69                	jmp    8003fa <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800391:	a1 20 50 80 00       	mov    0x805020,%eax
  800396:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80039c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80039f:	89 d0                	mov    %edx,%eax
  8003a1:	01 c0                	add    %eax,%eax
  8003a3:	01 d0                	add    %edx,%eax
  8003a5:	c1 e0 03             	shl    $0x3,%eax
  8003a8:	01 c8                	add    %ecx,%eax
  8003aa:	8a 40 04             	mov    0x4(%eax),%al
  8003ad:	84 c0                	test   %al,%al
  8003af:	75 46                	jne    8003f7 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003b1:	a1 20 50 80 00       	mov    0x805020,%eax
  8003b6:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003bc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003bf:	89 d0                	mov    %edx,%eax
  8003c1:	01 c0                	add    %eax,%eax
  8003c3:	01 d0                	add    %edx,%eax
  8003c5:	c1 e0 03             	shl    $0x3,%eax
  8003c8:	01 c8                	add    %ecx,%eax
  8003ca:	8b 00                	mov    (%eax),%eax
  8003cc:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003cf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003d2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003d7:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003dc:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e6:	01 c8                	add    %ecx,%eax
  8003e8:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003ea:	39 c2                	cmp    %eax,%edx
  8003ec:	75 09                	jne    8003f7 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8003ee:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003f5:	eb 12                	jmp    800409 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003f7:	ff 45 e8             	incl   -0x18(%ebp)
  8003fa:	a1 20 50 80 00       	mov    0x805020,%eax
  8003ff:	8b 50 74             	mov    0x74(%eax),%edx
  800402:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800405:	39 c2                	cmp    %eax,%edx
  800407:	77 88                	ja     800391 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800409:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80040d:	75 14                	jne    800423 <CheckWSWithoutLastIndex+0xfb>
			panic(
  80040f:	83 ec 04             	sub    $0x4,%esp
  800412:	68 fc 3a 80 00       	push   $0x803afc
  800417:	6a 3a                	push   $0x3a
  800419:	68 f0 3a 80 00       	push   $0x803af0
  80041e:	e8 93 fe ff ff       	call   8002b6 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800423:	ff 45 f0             	incl   -0x10(%ebp)
  800426:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800429:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80042c:	0f 8c 32 ff ff ff    	jl     800364 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800432:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800439:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800440:	eb 26                	jmp    800468 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800442:	a1 20 50 80 00       	mov    0x805020,%eax
  800447:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80044d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800450:	89 d0                	mov    %edx,%eax
  800452:	01 c0                	add    %eax,%eax
  800454:	01 d0                	add    %edx,%eax
  800456:	c1 e0 03             	shl    $0x3,%eax
  800459:	01 c8                	add    %ecx,%eax
  80045b:	8a 40 04             	mov    0x4(%eax),%al
  80045e:	3c 01                	cmp    $0x1,%al
  800460:	75 03                	jne    800465 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800462:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800465:	ff 45 e0             	incl   -0x20(%ebp)
  800468:	a1 20 50 80 00       	mov    0x805020,%eax
  80046d:	8b 50 74             	mov    0x74(%eax),%edx
  800470:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800473:	39 c2                	cmp    %eax,%edx
  800475:	77 cb                	ja     800442 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800477:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80047a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80047d:	74 14                	je     800493 <CheckWSWithoutLastIndex+0x16b>
		panic(
  80047f:	83 ec 04             	sub    $0x4,%esp
  800482:	68 50 3b 80 00       	push   $0x803b50
  800487:	6a 44                	push   $0x44
  800489:	68 f0 3a 80 00       	push   $0x803af0
  80048e:	e8 23 fe ff ff       	call   8002b6 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800493:	90                   	nop
  800494:	c9                   	leave  
  800495:	c3                   	ret    

00800496 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800496:	55                   	push   %ebp
  800497:	89 e5                	mov    %esp,%ebp
  800499:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80049c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80049f:	8b 00                	mov    (%eax),%eax
  8004a1:	8d 48 01             	lea    0x1(%eax),%ecx
  8004a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004a7:	89 0a                	mov    %ecx,(%edx)
  8004a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8004ac:	88 d1                	mov    %dl,%cl
  8004ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004b1:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b8:	8b 00                	mov    (%eax),%eax
  8004ba:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004bf:	75 2c                	jne    8004ed <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8004c1:	a0 24 50 80 00       	mov    0x805024,%al
  8004c6:	0f b6 c0             	movzbl %al,%eax
  8004c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004cc:	8b 12                	mov    (%edx),%edx
  8004ce:	89 d1                	mov    %edx,%ecx
  8004d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004d3:	83 c2 08             	add    $0x8,%edx
  8004d6:	83 ec 04             	sub    $0x4,%esp
  8004d9:	50                   	push   %eax
  8004da:	51                   	push   %ecx
  8004db:	52                   	push   %edx
  8004dc:	e8 6d 13 00 00       	call   80184e <sys_cputs>
  8004e1:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f0:	8b 40 04             	mov    0x4(%eax),%eax
  8004f3:	8d 50 01             	lea    0x1(%eax),%edx
  8004f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f9:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004fc:	90                   	nop
  8004fd:	c9                   	leave  
  8004fe:	c3                   	ret    

008004ff <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004ff:	55                   	push   %ebp
  800500:	89 e5                	mov    %esp,%ebp
  800502:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800508:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80050f:	00 00 00 
	b.cnt = 0;
  800512:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800519:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80051c:	ff 75 0c             	pushl  0xc(%ebp)
  80051f:	ff 75 08             	pushl  0x8(%ebp)
  800522:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800528:	50                   	push   %eax
  800529:	68 96 04 80 00       	push   $0x800496
  80052e:	e8 11 02 00 00       	call   800744 <vprintfmt>
  800533:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800536:	a0 24 50 80 00       	mov    0x805024,%al
  80053b:	0f b6 c0             	movzbl %al,%eax
  80053e:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800544:	83 ec 04             	sub    $0x4,%esp
  800547:	50                   	push   %eax
  800548:	52                   	push   %edx
  800549:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80054f:	83 c0 08             	add    $0x8,%eax
  800552:	50                   	push   %eax
  800553:	e8 f6 12 00 00       	call   80184e <sys_cputs>
  800558:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80055b:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800562:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800568:	c9                   	leave  
  800569:	c3                   	ret    

0080056a <cprintf>:

int cprintf(const char *fmt, ...) {
  80056a:	55                   	push   %ebp
  80056b:	89 e5                	mov    %esp,%ebp
  80056d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800570:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800577:	8d 45 0c             	lea    0xc(%ebp),%eax
  80057a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80057d:	8b 45 08             	mov    0x8(%ebp),%eax
  800580:	83 ec 08             	sub    $0x8,%esp
  800583:	ff 75 f4             	pushl  -0xc(%ebp)
  800586:	50                   	push   %eax
  800587:	e8 73 ff ff ff       	call   8004ff <vcprintf>
  80058c:	83 c4 10             	add    $0x10,%esp
  80058f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800592:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800595:	c9                   	leave  
  800596:	c3                   	ret    

00800597 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800597:	55                   	push   %ebp
  800598:	89 e5                	mov    %esp,%ebp
  80059a:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80059d:	e8 5a 14 00 00       	call   8019fc <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8005a2:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ab:	83 ec 08             	sub    $0x8,%esp
  8005ae:	ff 75 f4             	pushl  -0xc(%ebp)
  8005b1:	50                   	push   %eax
  8005b2:	e8 48 ff ff ff       	call   8004ff <vcprintf>
  8005b7:	83 c4 10             	add    $0x10,%esp
  8005ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8005bd:	e8 54 14 00 00       	call   801a16 <sys_enable_interrupt>
	return cnt;
  8005c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005c5:	c9                   	leave  
  8005c6:	c3                   	ret    

008005c7 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005c7:	55                   	push   %ebp
  8005c8:	89 e5                	mov    %esp,%ebp
  8005ca:	53                   	push   %ebx
  8005cb:	83 ec 14             	sub    $0x14,%esp
  8005ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8005d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005da:	8b 45 18             	mov    0x18(%ebp),%eax
  8005dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8005e2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005e5:	77 55                	ja     80063c <printnum+0x75>
  8005e7:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005ea:	72 05                	jb     8005f1 <printnum+0x2a>
  8005ec:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005ef:	77 4b                	ja     80063c <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005f1:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005f4:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005f7:	8b 45 18             	mov    0x18(%ebp),%eax
  8005fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ff:	52                   	push   %edx
  800600:	50                   	push   %eax
  800601:	ff 75 f4             	pushl  -0xc(%ebp)
  800604:	ff 75 f0             	pushl  -0x10(%ebp)
  800607:	e8 7c 2f 00 00       	call   803588 <__udivdi3>
  80060c:	83 c4 10             	add    $0x10,%esp
  80060f:	83 ec 04             	sub    $0x4,%esp
  800612:	ff 75 20             	pushl  0x20(%ebp)
  800615:	53                   	push   %ebx
  800616:	ff 75 18             	pushl  0x18(%ebp)
  800619:	52                   	push   %edx
  80061a:	50                   	push   %eax
  80061b:	ff 75 0c             	pushl  0xc(%ebp)
  80061e:	ff 75 08             	pushl  0x8(%ebp)
  800621:	e8 a1 ff ff ff       	call   8005c7 <printnum>
  800626:	83 c4 20             	add    $0x20,%esp
  800629:	eb 1a                	jmp    800645 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80062b:	83 ec 08             	sub    $0x8,%esp
  80062e:	ff 75 0c             	pushl  0xc(%ebp)
  800631:	ff 75 20             	pushl  0x20(%ebp)
  800634:	8b 45 08             	mov    0x8(%ebp),%eax
  800637:	ff d0                	call   *%eax
  800639:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80063c:	ff 4d 1c             	decl   0x1c(%ebp)
  80063f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800643:	7f e6                	jg     80062b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800645:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800648:	bb 00 00 00 00       	mov    $0x0,%ebx
  80064d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800650:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800653:	53                   	push   %ebx
  800654:	51                   	push   %ecx
  800655:	52                   	push   %edx
  800656:	50                   	push   %eax
  800657:	e8 3c 30 00 00       	call   803698 <__umoddi3>
  80065c:	83 c4 10             	add    $0x10,%esp
  80065f:	05 b4 3d 80 00       	add    $0x803db4,%eax
  800664:	8a 00                	mov    (%eax),%al
  800666:	0f be c0             	movsbl %al,%eax
  800669:	83 ec 08             	sub    $0x8,%esp
  80066c:	ff 75 0c             	pushl  0xc(%ebp)
  80066f:	50                   	push   %eax
  800670:	8b 45 08             	mov    0x8(%ebp),%eax
  800673:	ff d0                	call   *%eax
  800675:	83 c4 10             	add    $0x10,%esp
}
  800678:	90                   	nop
  800679:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80067c:	c9                   	leave  
  80067d:	c3                   	ret    

0080067e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80067e:	55                   	push   %ebp
  80067f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800681:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800685:	7e 1c                	jle    8006a3 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800687:	8b 45 08             	mov    0x8(%ebp),%eax
  80068a:	8b 00                	mov    (%eax),%eax
  80068c:	8d 50 08             	lea    0x8(%eax),%edx
  80068f:	8b 45 08             	mov    0x8(%ebp),%eax
  800692:	89 10                	mov    %edx,(%eax)
  800694:	8b 45 08             	mov    0x8(%ebp),%eax
  800697:	8b 00                	mov    (%eax),%eax
  800699:	83 e8 08             	sub    $0x8,%eax
  80069c:	8b 50 04             	mov    0x4(%eax),%edx
  80069f:	8b 00                	mov    (%eax),%eax
  8006a1:	eb 40                	jmp    8006e3 <getuint+0x65>
	else if (lflag)
  8006a3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006a7:	74 1e                	je     8006c7 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ac:	8b 00                	mov    (%eax),%eax
  8006ae:	8d 50 04             	lea    0x4(%eax),%edx
  8006b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b4:	89 10                	mov    %edx,(%eax)
  8006b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b9:	8b 00                	mov    (%eax),%eax
  8006bb:	83 e8 04             	sub    $0x4,%eax
  8006be:	8b 00                	mov    (%eax),%eax
  8006c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8006c5:	eb 1c                	jmp    8006e3 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ca:	8b 00                	mov    (%eax),%eax
  8006cc:	8d 50 04             	lea    0x4(%eax),%edx
  8006cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d2:	89 10                	mov    %edx,(%eax)
  8006d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d7:	8b 00                	mov    (%eax),%eax
  8006d9:	83 e8 04             	sub    $0x4,%eax
  8006dc:	8b 00                	mov    (%eax),%eax
  8006de:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006e3:	5d                   	pop    %ebp
  8006e4:	c3                   	ret    

008006e5 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006e5:	55                   	push   %ebp
  8006e6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006e8:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006ec:	7e 1c                	jle    80070a <getint+0x25>
		return va_arg(*ap, long long);
  8006ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f1:	8b 00                	mov    (%eax),%eax
  8006f3:	8d 50 08             	lea    0x8(%eax),%edx
  8006f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f9:	89 10                	mov    %edx,(%eax)
  8006fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fe:	8b 00                	mov    (%eax),%eax
  800700:	83 e8 08             	sub    $0x8,%eax
  800703:	8b 50 04             	mov    0x4(%eax),%edx
  800706:	8b 00                	mov    (%eax),%eax
  800708:	eb 38                	jmp    800742 <getint+0x5d>
	else if (lflag)
  80070a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80070e:	74 1a                	je     80072a <getint+0x45>
		return va_arg(*ap, long);
  800710:	8b 45 08             	mov    0x8(%ebp),%eax
  800713:	8b 00                	mov    (%eax),%eax
  800715:	8d 50 04             	lea    0x4(%eax),%edx
  800718:	8b 45 08             	mov    0x8(%ebp),%eax
  80071b:	89 10                	mov    %edx,(%eax)
  80071d:	8b 45 08             	mov    0x8(%ebp),%eax
  800720:	8b 00                	mov    (%eax),%eax
  800722:	83 e8 04             	sub    $0x4,%eax
  800725:	8b 00                	mov    (%eax),%eax
  800727:	99                   	cltd   
  800728:	eb 18                	jmp    800742 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80072a:	8b 45 08             	mov    0x8(%ebp),%eax
  80072d:	8b 00                	mov    (%eax),%eax
  80072f:	8d 50 04             	lea    0x4(%eax),%edx
  800732:	8b 45 08             	mov    0x8(%ebp),%eax
  800735:	89 10                	mov    %edx,(%eax)
  800737:	8b 45 08             	mov    0x8(%ebp),%eax
  80073a:	8b 00                	mov    (%eax),%eax
  80073c:	83 e8 04             	sub    $0x4,%eax
  80073f:	8b 00                	mov    (%eax),%eax
  800741:	99                   	cltd   
}
  800742:	5d                   	pop    %ebp
  800743:	c3                   	ret    

00800744 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800744:	55                   	push   %ebp
  800745:	89 e5                	mov    %esp,%ebp
  800747:	56                   	push   %esi
  800748:	53                   	push   %ebx
  800749:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80074c:	eb 17                	jmp    800765 <vprintfmt+0x21>
			if (ch == '\0')
  80074e:	85 db                	test   %ebx,%ebx
  800750:	0f 84 af 03 00 00    	je     800b05 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800756:	83 ec 08             	sub    $0x8,%esp
  800759:	ff 75 0c             	pushl  0xc(%ebp)
  80075c:	53                   	push   %ebx
  80075d:	8b 45 08             	mov    0x8(%ebp),%eax
  800760:	ff d0                	call   *%eax
  800762:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800765:	8b 45 10             	mov    0x10(%ebp),%eax
  800768:	8d 50 01             	lea    0x1(%eax),%edx
  80076b:	89 55 10             	mov    %edx,0x10(%ebp)
  80076e:	8a 00                	mov    (%eax),%al
  800770:	0f b6 d8             	movzbl %al,%ebx
  800773:	83 fb 25             	cmp    $0x25,%ebx
  800776:	75 d6                	jne    80074e <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800778:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80077c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800783:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80078a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800791:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800798:	8b 45 10             	mov    0x10(%ebp),%eax
  80079b:	8d 50 01             	lea    0x1(%eax),%edx
  80079e:	89 55 10             	mov    %edx,0x10(%ebp)
  8007a1:	8a 00                	mov    (%eax),%al
  8007a3:	0f b6 d8             	movzbl %al,%ebx
  8007a6:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007a9:	83 f8 55             	cmp    $0x55,%eax
  8007ac:	0f 87 2b 03 00 00    	ja     800add <vprintfmt+0x399>
  8007b2:	8b 04 85 d8 3d 80 00 	mov    0x803dd8(,%eax,4),%eax
  8007b9:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007bb:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007bf:	eb d7                	jmp    800798 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007c1:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007c5:	eb d1                	jmp    800798 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007c7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007ce:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007d1:	89 d0                	mov    %edx,%eax
  8007d3:	c1 e0 02             	shl    $0x2,%eax
  8007d6:	01 d0                	add    %edx,%eax
  8007d8:	01 c0                	add    %eax,%eax
  8007da:	01 d8                	add    %ebx,%eax
  8007dc:	83 e8 30             	sub    $0x30,%eax
  8007df:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8007e5:	8a 00                	mov    (%eax),%al
  8007e7:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007ea:	83 fb 2f             	cmp    $0x2f,%ebx
  8007ed:	7e 3e                	jle    80082d <vprintfmt+0xe9>
  8007ef:	83 fb 39             	cmp    $0x39,%ebx
  8007f2:	7f 39                	jg     80082d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007f4:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007f7:	eb d5                	jmp    8007ce <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fc:	83 c0 04             	add    $0x4,%eax
  8007ff:	89 45 14             	mov    %eax,0x14(%ebp)
  800802:	8b 45 14             	mov    0x14(%ebp),%eax
  800805:	83 e8 04             	sub    $0x4,%eax
  800808:	8b 00                	mov    (%eax),%eax
  80080a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80080d:	eb 1f                	jmp    80082e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80080f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800813:	79 83                	jns    800798 <vprintfmt+0x54>
				width = 0;
  800815:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80081c:	e9 77 ff ff ff       	jmp    800798 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800821:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800828:	e9 6b ff ff ff       	jmp    800798 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80082d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80082e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800832:	0f 89 60 ff ff ff    	jns    800798 <vprintfmt+0x54>
				width = precision, precision = -1;
  800838:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80083b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80083e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800845:	e9 4e ff ff ff       	jmp    800798 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80084a:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80084d:	e9 46 ff ff ff       	jmp    800798 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800852:	8b 45 14             	mov    0x14(%ebp),%eax
  800855:	83 c0 04             	add    $0x4,%eax
  800858:	89 45 14             	mov    %eax,0x14(%ebp)
  80085b:	8b 45 14             	mov    0x14(%ebp),%eax
  80085e:	83 e8 04             	sub    $0x4,%eax
  800861:	8b 00                	mov    (%eax),%eax
  800863:	83 ec 08             	sub    $0x8,%esp
  800866:	ff 75 0c             	pushl  0xc(%ebp)
  800869:	50                   	push   %eax
  80086a:	8b 45 08             	mov    0x8(%ebp),%eax
  80086d:	ff d0                	call   *%eax
  80086f:	83 c4 10             	add    $0x10,%esp
			break;
  800872:	e9 89 02 00 00       	jmp    800b00 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800877:	8b 45 14             	mov    0x14(%ebp),%eax
  80087a:	83 c0 04             	add    $0x4,%eax
  80087d:	89 45 14             	mov    %eax,0x14(%ebp)
  800880:	8b 45 14             	mov    0x14(%ebp),%eax
  800883:	83 e8 04             	sub    $0x4,%eax
  800886:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800888:	85 db                	test   %ebx,%ebx
  80088a:	79 02                	jns    80088e <vprintfmt+0x14a>
				err = -err;
  80088c:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80088e:	83 fb 64             	cmp    $0x64,%ebx
  800891:	7f 0b                	jg     80089e <vprintfmt+0x15a>
  800893:	8b 34 9d 20 3c 80 00 	mov    0x803c20(,%ebx,4),%esi
  80089a:	85 f6                	test   %esi,%esi
  80089c:	75 19                	jne    8008b7 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80089e:	53                   	push   %ebx
  80089f:	68 c5 3d 80 00       	push   $0x803dc5
  8008a4:	ff 75 0c             	pushl  0xc(%ebp)
  8008a7:	ff 75 08             	pushl  0x8(%ebp)
  8008aa:	e8 5e 02 00 00       	call   800b0d <printfmt>
  8008af:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008b2:	e9 49 02 00 00       	jmp    800b00 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008b7:	56                   	push   %esi
  8008b8:	68 ce 3d 80 00       	push   $0x803dce
  8008bd:	ff 75 0c             	pushl  0xc(%ebp)
  8008c0:	ff 75 08             	pushl  0x8(%ebp)
  8008c3:	e8 45 02 00 00       	call   800b0d <printfmt>
  8008c8:	83 c4 10             	add    $0x10,%esp
			break;
  8008cb:	e9 30 02 00 00       	jmp    800b00 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d3:	83 c0 04             	add    $0x4,%eax
  8008d6:	89 45 14             	mov    %eax,0x14(%ebp)
  8008d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008dc:	83 e8 04             	sub    $0x4,%eax
  8008df:	8b 30                	mov    (%eax),%esi
  8008e1:	85 f6                	test   %esi,%esi
  8008e3:	75 05                	jne    8008ea <vprintfmt+0x1a6>
				p = "(null)";
  8008e5:	be d1 3d 80 00       	mov    $0x803dd1,%esi
			if (width > 0 && padc != '-')
  8008ea:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ee:	7e 6d                	jle    80095d <vprintfmt+0x219>
  8008f0:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008f4:	74 67                	je     80095d <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008f9:	83 ec 08             	sub    $0x8,%esp
  8008fc:	50                   	push   %eax
  8008fd:	56                   	push   %esi
  8008fe:	e8 0c 03 00 00       	call   800c0f <strnlen>
  800903:	83 c4 10             	add    $0x10,%esp
  800906:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800909:	eb 16                	jmp    800921 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80090b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80090f:	83 ec 08             	sub    $0x8,%esp
  800912:	ff 75 0c             	pushl  0xc(%ebp)
  800915:	50                   	push   %eax
  800916:	8b 45 08             	mov    0x8(%ebp),%eax
  800919:	ff d0                	call   *%eax
  80091b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80091e:	ff 4d e4             	decl   -0x1c(%ebp)
  800921:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800925:	7f e4                	jg     80090b <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800927:	eb 34                	jmp    80095d <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800929:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80092d:	74 1c                	je     80094b <vprintfmt+0x207>
  80092f:	83 fb 1f             	cmp    $0x1f,%ebx
  800932:	7e 05                	jle    800939 <vprintfmt+0x1f5>
  800934:	83 fb 7e             	cmp    $0x7e,%ebx
  800937:	7e 12                	jle    80094b <vprintfmt+0x207>
					putch('?', putdat);
  800939:	83 ec 08             	sub    $0x8,%esp
  80093c:	ff 75 0c             	pushl  0xc(%ebp)
  80093f:	6a 3f                	push   $0x3f
  800941:	8b 45 08             	mov    0x8(%ebp),%eax
  800944:	ff d0                	call   *%eax
  800946:	83 c4 10             	add    $0x10,%esp
  800949:	eb 0f                	jmp    80095a <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80094b:	83 ec 08             	sub    $0x8,%esp
  80094e:	ff 75 0c             	pushl  0xc(%ebp)
  800951:	53                   	push   %ebx
  800952:	8b 45 08             	mov    0x8(%ebp),%eax
  800955:	ff d0                	call   *%eax
  800957:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80095a:	ff 4d e4             	decl   -0x1c(%ebp)
  80095d:	89 f0                	mov    %esi,%eax
  80095f:	8d 70 01             	lea    0x1(%eax),%esi
  800962:	8a 00                	mov    (%eax),%al
  800964:	0f be d8             	movsbl %al,%ebx
  800967:	85 db                	test   %ebx,%ebx
  800969:	74 24                	je     80098f <vprintfmt+0x24b>
  80096b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80096f:	78 b8                	js     800929 <vprintfmt+0x1e5>
  800971:	ff 4d e0             	decl   -0x20(%ebp)
  800974:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800978:	79 af                	jns    800929 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80097a:	eb 13                	jmp    80098f <vprintfmt+0x24b>
				putch(' ', putdat);
  80097c:	83 ec 08             	sub    $0x8,%esp
  80097f:	ff 75 0c             	pushl  0xc(%ebp)
  800982:	6a 20                	push   $0x20
  800984:	8b 45 08             	mov    0x8(%ebp),%eax
  800987:	ff d0                	call   *%eax
  800989:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80098c:	ff 4d e4             	decl   -0x1c(%ebp)
  80098f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800993:	7f e7                	jg     80097c <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800995:	e9 66 01 00 00       	jmp    800b00 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80099a:	83 ec 08             	sub    $0x8,%esp
  80099d:	ff 75 e8             	pushl  -0x18(%ebp)
  8009a0:	8d 45 14             	lea    0x14(%ebp),%eax
  8009a3:	50                   	push   %eax
  8009a4:	e8 3c fd ff ff       	call   8006e5 <getint>
  8009a9:	83 c4 10             	add    $0x10,%esp
  8009ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009af:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009b8:	85 d2                	test   %edx,%edx
  8009ba:	79 23                	jns    8009df <vprintfmt+0x29b>
				putch('-', putdat);
  8009bc:	83 ec 08             	sub    $0x8,%esp
  8009bf:	ff 75 0c             	pushl  0xc(%ebp)
  8009c2:	6a 2d                	push   $0x2d
  8009c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c7:	ff d0                	call   *%eax
  8009c9:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009d2:	f7 d8                	neg    %eax
  8009d4:	83 d2 00             	adc    $0x0,%edx
  8009d7:	f7 da                	neg    %edx
  8009d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009dc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009df:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009e6:	e9 bc 00 00 00       	jmp    800aa7 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009eb:	83 ec 08             	sub    $0x8,%esp
  8009ee:	ff 75 e8             	pushl  -0x18(%ebp)
  8009f1:	8d 45 14             	lea    0x14(%ebp),%eax
  8009f4:	50                   	push   %eax
  8009f5:	e8 84 fc ff ff       	call   80067e <getuint>
  8009fa:	83 c4 10             	add    $0x10,%esp
  8009fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a00:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a03:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a0a:	e9 98 00 00 00       	jmp    800aa7 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a0f:	83 ec 08             	sub    $0x8,%esp
  800a12:	ff 75 0c             	pushl  0xc(%ebp)
  800a15:	6a 58                	push   $0x58
  800a17:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1a:	ff d0                	call   *%eax
  800a1c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a1f:	83 ec 08             	sub    $0x8,%esp
  800a22:	ff 75 0c             	pushl  0xc(%ebp)
  800a25:	6a 58                	push   $0x58
  800a27:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2a:	ff d0                	call   *%eax
  800a2c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a2f:	83 ec 08             	sub    $0x8,%esp
  800a32:	ff 75 0c             	pushl  0xc(%ebp)
  800a35:	6a 58                	push   $0x58
  800a37:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3a:	ff d0                	call   *%eax
  800a3c:	83 c4 10             	add    $0x10,%esp
			break;
  800a3f:	e9 bc 00 00 00       	jmp    800b00 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a44:	83 ec 08             	sub    $0x8,%esp
  800a47:	ff 75 0c             	pushl  0xc(%ebp)
  800a4a:	6a 30                	push   $0x30
  800a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4f:	ff d0                	call   *%eax
  800a51:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a54:	83 ec 08             	sub    $0x8,%esp
  800a57:	ff 75 0c             	pushl  0xc(%ebp)
  800a5a:	6a 78                	push   $0x78
  800a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5f:	ff d0                	call   *%eax
  800a61:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a64:	8b 45 14             	mov    0x14(%ebp),%eax
  800a67:	83 c0 04             	add    $0x4,%eax
  800a6a:	89 45 14             	mov    %eax,0x14(%ebp)
  800a6d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a70:	83 e8 04             	sub    $0x4,%eax
  800a73:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a75:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a78:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a7f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a86:	eb 1f                	jmp    800aa7 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a88:	83 ec 08             	sub    $0x8,%esp
  800a8b:	ff 75 e8             	pushl  -0x18(%ebp)
  800a8e:	8d 45 14             	lea    0x14(%ebp),%eax
  800a91:	50                   	push   %eax
  800a92:	e8 e7 fb ff ff       	call   80067e <getuint>
  800a97:	83 c4 10             	add    $0x10,%esp
  800a9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a9d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800aa0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800aa7:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800aab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800aae:	83 ec 04             	sub    $0x4,%esp
  800ab1:	52                   	push   %edx
  800ab2:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ab5:	50                   	push   %eax
  800ab6:	ff 75 f4             	pushl  -0xc(%ebp)
  800ab9:	ff 75 f0             	pushl  -0x10(%ebp)
  800abc:	ff 75 0c             	pushl  0xc(%ebp)
  800abf:	ff 75 08             	pushl  0x8(%ebp)
  800ac2:	e8 00 fb ff ff       	call   8005c7 <printnum>
  800ac7:	83 c4 20             	add    $0x20,%esp
			break;
  800aca:	eb 34                	jmp    800b00 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800acc:	83 ec 08             	sub    $0x8,%esp
  800acf:	ff 75 0c             	pushl  0xc(%ebp)
  800ad2:	53                   	push   %ebx
  800ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad6:	ff d0                	call   *%eax
  800ad8:	83 c4 10             	add    $0x10,%esp
			break;
  800adb:	eb 23                	jmp    800b00 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800add:	83 ec 08             	sub    $0x8,%esp
  800ae0:	ff 75 0c             	pushl  0xc(%ebp)
  800ae3:	6a 25                	push   $0x25
  800ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae8:	ff d0                	call   *%eax
  800aea:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800aed:	ff 4d 10             	decl   0x10(%ebp)
  800af0:	eb 03                	jmp    800af5 <vprintfmt+0x3b1>
  800af2:	ff 4d 10             	decl   0x10(%ebp)
  800af5:	8b 45 10             	mov    0x10(%ebp),%eax
  800af8:	48                   	dec    %eax
  800af9:	8a 00                	mov    (%eax),%al
  800afb:	3c 25                	cmp    $0x25,%al
  800afd:	75 f3                	jne    800af2 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800aff:	90                   	nop
		}
	}
  800b00:	e9 47 fc ff ff       	jmp    80074c <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b05:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b06:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b09:	5b                   	pop    %ebx
  800b0a:	5e                   	pop    %esi
  800b0b:	5d                   	pop    %ebp
  800b0c:	c3                   	ret    

00800b0d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b0d:	55                   	push   %ebp
  800b0e:	89 e5                	mov    %esp,%ebp
  800b10:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b13:	8d 45 10             	lea    0x10(%ebp),%eax
  800b16:	83 c0 04             	add    $0x4,%eax
  800b19:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b1c:	8b 45 10             	mov    0x10(%ebp),%eax
  800b1f:	ff 75 f4             	pushl  -0xc(%ebp)
  800b22:	50                   	push   %eax
  800b23:	ff 75 0c             	pushl  0xc(%ebp)
  800b26:	ff 75 08             	pushl  0x8(%ebp)
  800b29:	e8 16 fc ff ff       	call   800744 <vprintfmt>
  800b2e:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b31:	90                   	nop
  800b32:	c9                   	leave  
  800b33:	c3                   	ret    

00800b34 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b34:	55                   	push   %ebp
  800b35:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3a:	8b 40 08             	mov    0x8(%eax),%eax
  800b3d:	8d 50 01             	lea    0x1(%eax),%edx
  800b40:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b43:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b49:	8b 10                	mov    (%eax),%edx
  800b4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4e:	8b 40 04             	mov    0x4(%eax),%eax
  800b51:	39 c2                	cmp    %eax,%edx
  800b53:	73 12                	jae    800b67 <sprintputch+0x33>
		*b->buf++ = ch;
  800b55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b58:	8b 00                	mov    (%eax),%eax
  800b5a:	8d 48 01             	lea    0x1(%eax),%ecx
  800b5d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b60:	89 0a                	mov    %ecx,(%edx)
  800b62:	8b 55 08             	mov    0x8(%ebp),%edx
  800b65:	88 10                	mov    %dl,(%eax)
}
  800b67:	90                   	nop
  800b68:	5d                   	pop    %ebp
  800b69:	c3                   	ret    

00800b6a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b6a:	55                   	push   %ebp
  800b6b:	89 e5                	mov    %esp,%ebp
  800b6d:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b70:	8b 45 08             	mov    0x8(%ebp),%eax
  800b73:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b76:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b79:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7f:	01 d0                	add    %edx,%eax
  800b81:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b84:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b8b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b8f:	74 06                	je     800b97 <vsnprintf+0x2d>
  800b91:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b95:	7f 07                	jg     800b9e <vsnprintf+0x34>
		return -E_INVAL;
  800b97:	b8 03 00 00 00       	mov    $0x3,%eax
  800b9c:	eb 20                	jmp    800bbe <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b9e:	ff 75 14             	pushl  0x14(%ebp)
  800ba1:	ff 75 10             	pushl  0x10(%ebp)
  800ba4:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ba7:	50                   	push   %eax
  800ba8:	68 34 0b 80 00       	push   $0x800b34
  800bad:	e8 92 fb ff ff       	call   800744 <vprintfmt>
  800bb2:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800bb5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bb8:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800bbe:	c9                   	leave  
  800bbf:	c3                   	ret    

00800bc0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bc0:	55                   	push   %ebp
  800bc1:	89 e5                	mov    %esp,%ebp
  800bc3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bc6:	8d 45 10             	lea    0x10(%ebp),%eax
  800bc9:	83 c0 04             	add    $0x4,%eax
  800bcc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800bcf:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd2:	ff 75 f4             	pushl  -0xc(%ebp)
  800bd5:	50                   	push   %eax
  800bd6:	ff 75 0c             	pushl  0xc(%ebp)
  800bd9:	ff 75 08             	pushl  0x8(%ebp)
  800bdc:	e8 89 ff ff ff       	call   800b6a <vsnprintf>
  800be1:	83 c4 10             	add    $0x10,%esp
  800be4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800be7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bea:	c9                   	leave  
  800beb:	c3                   	ret    

00800bec <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800bec:	55                   	push   %ebp
  800bed:	89 e5                	mov    %esp,%ebp
  800bef:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bf2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bf9:	eb 06                	jmp    800c01 <strlen+0x15>
		n++;
  800bfb:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bfe:	ff 45 08             	incl   0x8(%ebp)
  800c01:	8b 45 08             	mov    0x8(%ebp),%eax
  800c04:	8a 00                	mov    (%eax),%al
  800c06:	84 c0                	test   %al,%al
  800c08:	75 f1                	jne    800bfb <strlen+0xf>
		n++;
	return n;
  800c0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c0d:	c9                   	leave  
  800c0e:	c3                   	ret    

00800c0f <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c0f:	55                   	push   %ebp
  800c10:	89 e5                	mov    %esp,%ebp
  800c12:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c15:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c1c:	eb 09                	jmp    800c27 <strnlen+0x18>
		n++;
  800c1e:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c21:	ff 45 08             	incl   0x8(%ebp)
  800c24:	ff 4d 0c             	decl   0xc(%ebp)
  800c27:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c2b:	74 09                	je     800c36 <strnlen+0x27>
  800c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c30:	8a 00                	mov    (%eax),%al
  800c32:	84 c0                	test   %al,%al
  800c34:	75 e8                	jne    800c1e <strnlen+0xf>
		n++;
	return n;
  800c36:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c39:	c9                   	leave  
  800c3a:	c3                   	ret    

00800c3b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c3b:	55                   	push   %ebp
  800c3c:	89 e5                	mov    %esp,%ebp
  800c3e:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c41:	8b 45 08             	mov    0x8(%ebp),%eax
  800c44:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c47:	90                   	nop
  800c48:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4b:	8d 50 01             	lea    0x1(%eax),%edx
  800c4e:	89 55 08             	mov    %edx,0x8(%ebp)
  800c51:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c54:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c57:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c5a:	8a 12                	mov    (%edx),%dl
  800c5c:	88 10                	mov    %dl,(%eax)
  800c5e:	8a 00                	mov    (%eax),%al
  800c60:	84 c0                	test   %al,%al
  800c62:	75 e4                	jne    800c48 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c64:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c67:	c9                   	leave  
  800c68:	c3                   	ret    

00800c69 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c69:	55                   	push   %ebp
  800c6a:	89 e5                	mov    %esp,%ebp
  800c6c:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c72:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c75:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c7c:	eb 1f                	jmp    800c9d <strncpy+0x34>
		*dst++ = *src;
  800c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c81:	8d 50 01             	lea    0x1(%eax),%edx
  800c84:	89 55 08             	mov    %edx,0x8(%ebp)
  800c87:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c8a:	8a 12                	mov    (%edx),%dl
  800c8c:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c91:	8a 00                	mov    (%eax),%al
  800c93:	84 c0                	test   %al,%al
  800c95:	74 03                	je     800c9a <strncpy+0x31>
			src++;
  800c97:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c9a:	ff 45 fc             	incl   -0x4(%ebp)
  800c9d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ca0:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ca3:	72 d9                	jb     800c7e <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ca5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ca8:	c9                   	leave  
  800ca9:	c3                   	ret    

00800caa <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800caa:	55                   	push   %ebp
  800cab:	89 e5                	mov    %esp,%ebp
  800cad:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800cb6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cba:	74 30                	je     800cec <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800cbc:	eb 16                	jmp    800cd4 <strlcpy+0x2a>
			*dst++ = *src++;
  800cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc1:	8d 50 01             	lea    0x1(%eax),%edx
  800cc4:	89 55 08             	mov    %edx,0x8(%ebp)
  800cc7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cca:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ccd:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cd0:	8a 12                	mov    (%edx),%dl
  800cd2:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cd4:	ff 4d 10             	decl   0x10(%ebp)
  800cd7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cdb:	74 09                	je     800ce6 <strlcpy+0x3c>
  800cdd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce0:	8a 00                	mov    (%eax),%al
  800ce2:	84 c0                	test   %al,%al
  800ce4:	75 d8                	jne    800cbe <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce9:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cec:	8b 55 08             	mov    0x8(%ebp),%edx
  800cef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cf2:	29 c2                	sub    %eax,%edx
  800cf4:	89 d0                	mov    %edx,%eax
}
  800cf6:	c9                   	leave  
  800cf7:	c3                   	ret    

00800cf8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cf8:	55                   	push   %ebp
  800cf9:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cfb:	eb 06                	jmp    800d03 <strcmp+0xb>
		p++, q++;
  800cfd:	ff 45 08             	incl   0x8(%ebp)
  800d00:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d03:	8b 45 08             	mov    0x8(%ebp),%eax
  800d06:	8a 00                	mov    (%eax),%al
  800d08:	84 c0                	test   %al,%al
  800d0a:	74 0e                	je     800d1a <strcmp+0x22>
  800d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0f:	8a 10                	mov    (%eax),%dl
  800d11:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d14:	8a 00                	mov    (%eax),%al
  800d16:	38 c2                	cmp    %al,%dl
  800d18:	74 e3                	je     800cfd <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1d:	8a 00                	mov    (%eax),%al
  800d1f:	0f b6 d0             	movzbl %al,%edx
  800d22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d25:	8a 00                	mov    (%eax),%al
  800d27:	0f b6 c0             	movzbl %al,%eax
  800d2a:	29 c2                	sub    %eax,%edx
  800d2c:	89 d0                	mov    %edx,%eax
}
  800d2e:	5d                   	pop    %ebp
  800d2f:	c3                   	ret    

00800d30 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d30:	55                   	push   %ebp
  800d31:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d33:	eb 09                	jmp    800d3e <strncmp+0xe>
		n--, p++, q++;
  800d35:	ff 4d 10             	decl   0x10(%ebp)
  800d38:	ff 45 08             	incl   0x8(%ebp)
  800d3b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d3e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d42:	74 17                	je     800d5b <strncmp+0x2b>
  800d44:	8b 45 08             	mov    0x8(%ebp),%eax
  800d47:	8a 00                	mov    (%eax),%al
  800d49:	84 c0                	test   %al,%al
  800d4b:	74 0e                	je     800d5b <strncmp+0x2b>
  800d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d50:	8a 10                	mov    (%eax),%dl
  800d52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d55:	8a 00                	mov    (%eax),%al
  800d57:	38 c2                	cmp    %al,%dl
  800d59:	74 da                	je     800d35 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d5b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d5f:	75 07                	jne    800d68 <strncmp+0x38>
		return 0;
  800d61:	b8 00 00 00 00       	mov    $0x0,%eax
  800d66:	eb 14                	jmp    800d7c <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d68:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6b:	8a 00                	mov    (%eax),%al
  800d6d:	0f b6 d0             	movzbl %al,%edx
  800d70:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d73:	8a 00                	mov    (%eax),%al
  800d75:	0f b6 c0             	movzbl %al,%eax
  800d78:	29 c2                	sub    %eax,%edx
  800d7a:	89 d0                	mov    %edx,%eax
}
  800d7c:	5d                   	pop    %ebp
  800d7d:	c3                   	ret    

00800d7e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d7e:	55                   	push   %ebp
  800d7f:	89 e5                	mov    %esp,%ebp
  800d81:	83 ec 04             	sub    $0x4,%esp
  800d84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d87:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d8a:	eb 12                	jmp    800d9e <strchr+0x20>
		if (*s == c)
  800d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8f:	8a 00                	mov    (%eax),%al
  800d91:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d94:	75 05                	jne    800d9b <strchr+0x1d>
			return (char *) s;
  800d96:	8b 45 08             	mov    0x8(%ebp),%eax
  800d99:	eb 11                	jmp    800dac <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d9b:	ff 45 08             	incl   0x8(%ebp)
  800d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800da1:	8a 00                	mov    (%eax),%al
  800da3:	84 c0                	test   %al,%al
  800da5:	75 e5                	jne    800d8c <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800da7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dac:	c9                   	leave  
  800dad:	c3                   	ret    

00800dae <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800dae:	55                   	push   %ebp
  800daf:	89 e5                	mov    %esp,%ebp
  800db1:	83 ec 04             	sub    $0x4,%esp
  800db4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dba:	eb 0d                	jmp    800dc9 <strfind+0x1b>
		if (*s == c)
  800dbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbf:	8a 00                	mov    (%eax),%al
  800dc1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dc4:	74 0e                	je     800dd4 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800dc6:	ff 45 08             	incl   0x8(%ebp)
  800dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcc:	8a 00                	mov    (%eax),%al
  800dce:	84 c0                	test   %al,%al
  800dd0:	75 ea                	jne    800dbc <strfind+0xe>
  800dd2:	eb 01                	jmp    800dd5 <strfind+0x27>
		if (*s == c)
			break;
  800dd4:	90                   	nop
	return (char *) s;
  800dd5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dd8:	c9                   	leave  
  800dd9:	c3                   	ret    

00800dda <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800dda:	55                   	push   %ebp
  800ddb:	89 e5                	mov    %esp,%ebp
  800ddd:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800de0:	8b 45 08             	mov    0x8(%ebp),%eax
  800de3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800de6:	8b 45 10             	mov    0x10(%ebp),%eax
  800de9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800dec:	eb 0e                	jmp    800dfc <memset+0x22>
		*p++ = c;
  800dee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800df1:	8d 50 01             	lea    0x1(%eax),%edx
  800df4:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800df7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dfa:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800dfc:	ff 4d f8             	decl   -0x8(%ebp)
  800dff:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e03:	79 e9                	jns    800dee <memset+0x14>
		*p++ = c;

	return v;
  800e05:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e08:	c9                   	leave  
  800e09:	c3                   	ret    

00800e0a <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e0a:	55                   	push   %ebp
  800e0b:	89 e5                	mov    %esp,%ebp
  800e0d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e10:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e13:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e16:	8b 45 08             	mov    0x8(%ebp),%eax
  800e19:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e1c:	eb 16                	jmp    800e34 <memcpy+0x2a>
		*d++ = *s++;
  800e1e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e21:	8d 50 01             	lea    0x1(%eax),%edx
  800e24:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e27:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e2a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e2d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e30:	8a 12                	mov    (%edx),%dl
  800e32:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e34:	8b 45 10             	mov    0x10(%ebp),%eax
  800e37:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e3a:	89 55 10             	mov    %edx,0x10(%ebp)
  800e3d:	85 c0                	test   %eax,%eax
  800e3f:	75 dd                	jne    800e1e <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e41:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e44:	c9                   	leave  
  800e45:	c3                   	ret    

00800e46 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e46:	55                   	push   %ebp
  800e47:	89 e5                	mov    %esp,%ebp
  800e49:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e52:	8b 45 08             	mov    0x8(%ebp),%eax
  800e55:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e58:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e5b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e5e:	73 50                	jae    800eb0 <memmove+0x6a>
  800e60:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e63:	8b 45 10             	mov    0x10(%ebp),%eax
  800e66:	01 d0                	add    %edx,%eax
  800e68:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e6b:	76 43                	jbe    800eb0 <memmove+0x6a>
		s += n;
  800e6d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e70:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e73:	8b 45 10             	mov    0x10(%ebp),%eax
  800e76:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e79:	eb 10                	jmp    800e8b <memmove+0x45>
			*--d = *--s;
  800e7b:	ff 4d f8             	decl   -0x8(%ebp)
  800e7e:	ff 4d fc             	decl   -0x4(%ebp)
  800e81:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e84:	8a 10                	mov    (%eax),%dl
  800e86:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e89:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e8b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e8e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e91:	89 55 10             	mov    %edx,0x10(%ebp)
  800e94:	85 c0                	test   %eax,%eax
  800e96:	75 e3                	jne    800e7b <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e98:	eb 23                	jmp    800ebd <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e9a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e9d:	8d 50 01             	lea    0x1(%eax),%edx
  800ea0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ea3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ea6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ea9:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800eac:	8a 12                	mov    (%edx),%dl
  800eae:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800eb0:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb3:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eb6:	89 55 10             	mov    %edx,0x10(%ebp)
  800eb9:	85 c0                	test   %eax,%eax
  800ebb:	75 dd                	jne    800e9a <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ebd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ec0:	c9                   	leave  
  800ec1:	c3                   	ret    

00800ec2 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ec2:	55                   	push   %ebp
  800ec3:	89 e5                	mov    %esp,%ebp
  800ec5:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ec8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ece:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed1:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ed4:	eb 2a                	jmp    800f00 <memcmp+0x3e>
		if (*s1 != *s2)
  800ed6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed9:	8a 10                	mov    (%eax),%dl
  800edb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ede:	8a 00                	mov    (%eax),%al
  800ee0:	38 c2                	cmp    %al,%dl
  800ee2:	74 16                	je     800efa <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ee4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee7:	8a 00                	mov    (%eax),%al
  800ee9:	0f b6 d0             	movzbl %al,%edx
  800eec:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eef:	8a 00                	mov    (%eax),%al
  800ef1:	0f b6 c0             	movzbl %al,%eax
  800ef4:	29 c2                	sub    %eax,%edx
  800ef6:	89 d0                	mov    %edx,%eax
  800ef8:	eb 18                	jmp    800f12 <memcmp+0x50>
		s1++, s2++;
  800efa:	ff 45 fc             	incl   -0x4(%ebp)
  800efd:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f00:	8b 45 10             	mov    0x10(%ebp),%eax
  800f03:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f06:	89 55 10             	mov    %edx,0x10(%ebp)
  800f09:	85 c0                	test   %eax,%eax
  800f0b:	75 c9                	jne    800ed6 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f0d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f12:	c9                   	leave  
  800f13:	c3                   	ret    

00800f14 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f14:	55                   	push   %ebp
  800f15:	89 e5                	mov    %esp,%ebp
  800f17:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f1a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f1d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f20:	01 d0                	add    %edx,%eax
  800f22:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f25:	eb 15                	jmp    800f3c <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f27:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2a:	8a 00                	mov    (%eax),%al
  800f2c:	0f b6 d0             	movzbl %al,%edx
  800f2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f32:	0f b6 c0             	movzbl %al,%eax
  800f35:	39 c2                	cmp    %eax,%edx
  800f37:	74 0d                	je     800f46 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f39:	ff 45 08             	incl   0x8(%ebp)
  800f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f42:	72 e3                	jb     800f27 <memfind+0x13>
  800f44:	eb 01                	jmp    800f47 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f46:	90                   	nop
	return (void *) s;
  800f47:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f4a:	c9                   	leave  
  800f4b:	c3                   	ret    

00800f4c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f4c:	55                   	push   %ebp
  800f4d:	89 e5                	mov    %esp,%ebp
  800f4f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f52:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f59:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f60:	eb 03                	jmp    800f65 <strtol+0x19>
		s++;
  800f62:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f65:	8b 45 08             	mov    0x8(%ebp),%eax
  800f68:	8a 00                	mov    (%eax),%al
  800f6a:	3c 20                	cmp    $0x20,%al
  800f6c:	74 f4                	je     800f62 <strtol+0x16>
  800f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f71:	8a 00                	mov    (%eax),%al
  800f73:	3c 09                	cmp    $0x9,%al
  800f75:	74 eb                	je     800f62 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f77:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7a:	8a 00                	mov    (%eax),%al
  800f7c:	3c 2b                	cmp    $0x2b,%al
  800f7e:	75 05                	jne    800f85 <strtol+0x39>
		s++;
  800f80:	ff 45 08             	incl   0x8(%ebp)
  800f83:	eb 13                	jmp    800f98 <strtol+0x4c>
	else if (*s == '-')
  800f85:	8b 45 08             	mov    0x8(%ebp),%eax
  800f88:	8a 00                	mov    (%eax),%al
  800f8a:	3c 2d                	cmp    $0x2d,%al
  800f8c:	75 0a                	jne    800f98 <strtol+0x4c>
		s++, neg = 1;
  800f8e:	ff 45 08             	incl   0x8(%ebp)
  800f91:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f98:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f9c:	74 06                	je     800fa4 <strtol+0x58>
  800f9e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800fa2:	75 20                	jne    800fc4 <strtol+0x78>
  800fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa7:	8a 00                	mov    (%eax),%al
  800fa9:	3c 30                	cmp    $0x30,%al
  800fab:	75 17                	jne    800fc4 <strtol+0x78>
  800fad:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb0:	40                   	inc    %eax
  800fb1:	8a 00                	mov    (%eax),%al
  800fb3:	3c 78                	cmp    $0x78,%al
  800fb5:	75 0d                	jne    800fc4 <strtol+0x78>
		s += 2, base = 16;
  800fb7:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800fbb:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800fc2:	eb 28                	jmp    800fec <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800fc4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fc8:	75 15                	jne    800fdf <strtol+0x93>
  800fca:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcd:	8a 00                	mov    (%eax),%al
  800fcf:	3c 30                	cmp    $0x30,%al
  800fd1:	75 0c                	jne    800fdf <strtol+0x93>
		s++, base = 8;
  800fd3:	ff 45 08             	incl   0x8(%ebp)
  800fd6:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fdd:	eb 0d                	jmp    800fec <strtol+0xa0>
	else if (base == 0)
  800fdf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fe3:	75 07                	jne    800fec <strtol+0xa0>
		base = 10;
  800fe5:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fec:	8b 45 08             	mov    0x8(%ebp),%eax
  800fef:	8a 00                	mov    (%eax),%al
  800ff1:	3c 2f                	cmp    $0x2f,%al
  800ff3:	7e 19                	jle    80100e <strtol+0xc2>
  800ff5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff8:	8a 00                	mov    (%eax),%al
  800ffa:	3c 39                	cmp    $0x39,%al
  800ffc:	7f 10                	jg     80100e <strtol+0xc2>
			dig = *s - '0';
  800ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  801001:	8a 00                	mov    (%eax),%al
  801003:	0f be c0             	movsbl %al,%eax
  801006:	83 e8 30             	sub    $0x30,%eax
  801009:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80100c:	eb 42                	jmp    801050 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80100e:	8b 45 08             	mov    0x8(%ebp),%eax
  801011:	8a 00                	mov    (%eax),%al
  801013:	3c 60                	cmp    $0x60,%al
  801015:	7e 19                	jle    801030 <strtol+0xe4>
  801017:	8b 45 08             	mov    0x8(%ebp),%eax
  80101a:	8a 00                	mov    (%eax),%al
  80101c:	3c 7a                	cmp    $0x7a,%al
  80101e:	7f 10                	jg     801030 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801020:	8b 45 08             	mov    0x8(%ebp),%eax
  801023:	8a 00                	mov    (%eax),%al
  801025:	0f be c0             	movsbl %al,%eax
  801028:	83 e8 57             	sub    $0x57,%eax
  80102b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80102e:	eb 20                	jmp    801050 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801030:	8b 45 08             	mov    0x8(%ebp),%eax
  801033:	8a 00                	mov    (%eax),%al
  801035:	3c 40                	cmp    $0x40,%al
  801037:	7e 39                	jle    801072 <strtol+0x126>
  801039:	8b 45 08             	mov    0x8(%ebp),%eax
  80103c:	8a 00                	mov    (%eax),%al
  80103e:	3c 5a                	cmp    $0x5a,%al
  801040:	7f 30                	jg     801072 <strtol+0x126>
			dig = *s - 'A' + 10;
  801042:	8b 45 08             	mov    0x8(%ebp),%eax
  801045:	8a 00                	mov    (%eax),%al
  801047:	0f be c0             	movsbl %al,%eax
  80104a:	83 e8 37             	sub    $0x37,%eax
  80104d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801050:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801053:	3b 45 10             	cmp    0x10(%ebp),%eax
  801056:	7d 19                	jge    801071 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801058:	ff 45 08             	incl   0x8(%ebp)
  80105b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80105e:	0f af 45 10          	imul   0x10(%ebp),%eax
  801062:	89 c2                	mov    %eax,%edx
  801064:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801067:	01 d0                	add    %edx,%eax
  801069:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80106c:	e9 7b ff ff ff       	jmp    800fec <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801071:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801072:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801076:	74 08                	je     801080 <strtol+0x134>
		*endptr = (char *) s;
  801078:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107b:	8b 55 08             	mov    0x8(%ebp),%edx
  80107e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801080:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801084:	74 07                	je     80108d <strtol+0x141>
  801086:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801089:	f7 d8                	neg    %eax
  80108b:	eb 03                	jmp    801090 <strtol+0x144>
  80108d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801090:	c9                   	leave  
  801091:	c3                   	ret    

00801092 <ltostr>:

void
ltostr(long value, char *str)
{
  801092:	55                   	push   %ebp
  801093:	89 e5                	mov    %esp,%ebp
  801095:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801098:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80109f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8010a6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010aa:	79 13                	jns    8010bf <ltostr+0x2d>
	{
		neg = 1;
  8010ac:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8010b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b6:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8010b9:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8010bc:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8010bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c2:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010c7:	99                   	cltd   
  8010c8:	f7 f9                	idiv   %ecx
  8010ca:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010d0:	8d 50 01             	lea    0x1(%eax),%edx
  8010d3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010d6:	89 c2                	mov    %eax,%edx
  8010d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010db:	01 d0                	add    %edx,%eax
  8010dd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010e0:	83 c2 30             	add    $0x30,%edx
  8010e3:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010e5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010e8:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010ed:	f7 e9                	imul   %ecx
  8010ef:	c1 fa 02             	sar    $0x2,%edx
  8010f2:	89 c8                	mov    %ecx,%eax
  8010f4:	c1 f8 1f             	sar    $0x1f,%eax
  8010f7:	29 c2                	sub    %eax,%edx
  8010f9:	89 d0                	mov    %edx,%eax
  8010fb:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010fe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801101:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801106:	f7 e9                	imul   %ecx
  801108:	c1 fa 02             	sar    $0x2,%edx
  80110b:	89 c8                	mov    %ecx,%eax
  80110d:	c1 f8 1f             	sar    $0x1f,%eax
  801110:	29 c2                	sub    %eax,%edx
  801112:	89 d0                	mov    %edx,%eax
  801114:	c1 e0 02             	shl    $0x2,%eax
  801117:	01 d0                	add    %edx,%eax
  801119:	01 c0                	add    %eax,%eax
  80111b:	29 c1                	sub    %eax,%ecx
  80111d:	89 ca                	mov    %ecx,%edx
  80111f:	85 d2                	test   %edx,%edx
  801121:	75 9c                	jne    8010bf <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801123:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80112a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80112d:	48                   	dec    %eax
  80112e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801131:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801135:	74 3d                	je     801174 <ltostr+0xe2>
		start = 1 ;
  801137:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80113e:	eb 34                	jmp    801174 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801140:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801143:	8b 45 0c             	mov    0xc(%ebp),%eax
  801146:	01 d0                	add    %edx,%eax
  801148:	8a 00                	mov    (%eax),%al
  80114a:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80114d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801150:	8b 45 0c             	mov    0xc(%ebp),%eax
  801153:	01 c2                	add    %eax,%edx
  801155:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801158:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115b:	01 c8                	add    %ecx,%eax
  80115d:	8a 00                	mov    (%eax),%al
  80115f:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801161:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801164:	8b 45 0c             	mov    0xc(%ebp),%eax
  801167:	01 c2                	add    %eax,%edx
  801169:	8a 45 eb             	mov    -0x15(%ebp),%al
  80116c:	88 02                	mov    %al,(%edx)
		start++ ;
  80116e:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801171:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801174:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801177:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80117a:	7c c4                	jl     801140 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80117c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80117f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801182:	01 d0                	add    %edx,%eax
  801184:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801187:	90                   	nop
  801188:	c9                   	leave  
  801189:	c3                   	ret    

0080118a <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80118a:	55                   	push   %ebp
  80118b:	89 e5                	mov    %esp,%ebp
  80118d:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801190:	ff 75 08             	pushl  0x8(%ebp)
  801193:	e8 54 fa ff ff       	call   800bec <strlen>
  801198:	83 c4 04             	add    $0x4,%esp
  80119b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80119e:	ff 75 0c             	pushl  0xc(%ebp)
  8011a1:	e8 46 fa ff ff       	call   800bec <strlen>
  8011a6:	83 c4 04             	add    $0x4,%esp
  8011a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8011ac:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8011b3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011ba:	eb 17                	jmp    8011d3 <strcconcat+0x49>
		final[s] = str1[s] ;
  8011bc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c2:	01 c2                	add    %eax,%edx
  8011c4:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ca:	01 c8                	add    %ecx,%eax
  8011cc:	8a 00                	mov    (%eax),%al
  8011ce:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8011d0:	ff 45 fc             	incl   -0x4(%ebp)
  8011d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011d6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011d9:	7c e1                	jl     8011bc <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011db:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011e2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011e9:	eb 1f                	jmp    80120a <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011ee:	8d 50 01             	lea    0x1(%eax),%edx
  8011f1:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011f4:	89 c2                	mov    %eax,%edx
  8011f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f9:	01 c2                	add    %eax,%edx
  8011fb:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801201:	01 c8                	add    %ecx,%eax
  801203:	8a 00                	mov    (%eax),%al
  801205:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801207:	ff 45 f8             	incl   -0x8(%ebp)
  80120a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80120d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801210:	7c d9                	jl     8011eb <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801212:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801215:	8b 45 10             	mov    0x10(%ebp),%eax
  801218:	01 d0                	add    %edx,%eax
  80121a:	c6 00 00             	movb   $0x0,(%eax)
}
  80121d:	90                   	nop
  80121e:	c9                   	leave  
  80121f:	c3                   	ret    

00801220 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801220:	55                   	push   %ebp
  801221:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801223:	8b 45 14             	mov    0x14(%ebp),%eax
  801226:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80122c:	8b 45 14             	mov    0x14(%ebp),%eax
  80122f:	8b 00                	mov    (%eax),%eax
  801231:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801238:	8b 45 10             	mov    0x10(%ebp),%eax
  80123b:	01 d0                	add    %edx,%eax
  80123d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801243:	eb 0c                	jmp    801251 <strsplit+0x31>
			*string++ = 0;
  801245:	8b 45 08             	mov    0x8(%ebp),%eax
  801248:	8d 50 01             	lea    0x1(%eax),%edx
  80124b:	89 55 08             	mov    %edx,0x8(%ebp)
  80124e:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801251:	8b 45 08             	mov    0x8(%ebp),%eax
  801254:	8a 00                	mov    (%eax),%al
  801256:	84 c0                	test   %al,%al
  801258:	74 18                	je     801272 <strsplit+0x52>
  80125a:	8b 45 08             	mov    0x8(%ebp),%eax
  80125d:	8a 00                	mov    (%eax),%al
  80125f:	0f be c0             	movsbl %al,%eax
  801262:	50                   	push   %eax
  801263:	ff 75 0c             	pushl  0xc(%ebp)
  801266:	e8 13 fb ff ff       	call   800d7e <strchr>
  80126b:	83 c4 08             	add    $0x8,%esp
  80126e:	85 c0                	test   %eax,%eax
  801270:	75 d3                	jne    801245 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801272:	8b 45 08             	mov    0x8(%ebp),%eax
  801275:	8a 00                	mov    (%eax),%al
  801277:	84 c0                	test   %al,%al
  801279:	74 5a                	je     8012d5 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80127b:	8b 45 14             	mov    0x14(%ebp),%eax
  80127e:	8b 00                	mov    (%eax),%eax
  801280:	83 f8 0f             	cmp    $0xf,%eax
  801283:	75 07                	jne    80128c <strsplit+0x6c>
		{
			return 0;
  801285:	b8 00 00 00 00       	mov    $0x0,%eax
  80128a:	eb 66                	jmp    8012f2 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80128c:	8b 45 14             	mov    0x14(%ebp),%eax
  80128f:	8b 00                	mov    (%eax),%eax
  801291:	8d 48 01             	lea    0x1(%eax),%ecx
  801294:	8b 55 14             	mov    0x14(%ebp),%edx
  801297:	89 0a                	mov    %ecx,(%edx)
  801299:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a3:	01 c2                	add    %eax,%edx
  8012a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a8:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012aa:	eb 03                	jmp    8012af <strsplit+0x8f>
			string++;
  8012ac:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012af:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b2:	8a 00                	mov    (%eax),%al
  8012b4:	84 c0                	test   %al,%al
  8012b6:	74 8b                	je     801243 <strsplit+0x23>
  8012b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bb:	8a 00                	mov    (%eax),%al
  8012bd:	0f be c0             	movsbl %al,%eax
  8012c0:	50                   	push   %eax
  8012c1:	ff 75 0c             	pushl  0xc(%ebp)
  8012c4:	e8 b5 fa ff ff       	call   800d7e <strchr>
  8012c9:	83 c4 08             	add    $0x8,%esp
  8012cc:	85 c0                	test   %eax,%eax
  8012ce:	74 dc                	je     8012ac <strsplit+0x8c>
			string++;
	}
  8012d0:	e9 6e ff ff ff       	jmp    801243 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012d5:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8012d9:	8b 00                	mov    (%eax),%eax
  8012db:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e5:	01 d0                	add    %edx,%eax
  8012e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012ed:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012f2:	c9                   	leave  
  8012f3:	c3                   	ret    

008012f4 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8012f4:	55                   	push   %ebp
  8012f5:	89 e5                	mov    %esp,%ebp
  8012f7:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8012fa:	a1 04 50 80 00       	mov    0x805004,%eax
  8012ff:	85 c0                	test   %eax,%eax
  801301:	74 1f                	je     801322 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801303:	e8 1d 00 00 00       	call   801325 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801308:	83 ec 0c             	sub    $0xc,%esp
  80130b:	68 30 3f 80 00       	push   $0x803f30
  801310:	e8 55 f2 ff ff       	call   80056a <cprintf>
  801315:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801318:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  80131f:	00 00 00 
	}
}
  801322:	90                   	nop
  801323:	c9                   	leave  
  801324:	c3                   	ret    

00801325 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801325:	55                   	push   %ebp
  801326:	89 e5                	mov    %esp,%ebp
  801328:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	LIST_INIT(&AllocMemBlocksList);
  80132b:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801332:	00 00 00 
  801335:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  80133c:	00 00 00 
  80133f:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801346:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801349:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801350:	00 00 00 
  801353:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  80135a:	00 00 00 
  80135d:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801364:	00 00 00 
	uint32 arr_size = 0;
  801367:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	MemBlockNodes  =(struct MemBlock*) USER_DYN_BLKS_ARRAY;
  80136e:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801375:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801378:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80137d:	2d 00 10 00 00       	sub    $0x1000,%eax
  801382:	a3 50 50 80 00       	mov    %eax,0x805050
	MAX_MEM_BLOCK_CNT = (USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE;
  801387:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  80138e:	00 02 00 
	arr_size =  ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock), PAGE_SIZE);
  801391:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801398:	a1 20 51 80 00       	mov    0x805120,%eax
  80139d:	c1 e0 04             	shl    $0x4,%eax
  8013a0:	89 c2                	mov    %eax,%edx
  8013a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013a5:	01 d0                	add    %edx,%eax
  8013a7:	48                   	dec    %eax
  8013a8:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8013ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8013b3:	f7 75 ec             	divl   -0x14(%ebp)
  8013b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013b9:	29 d0                	sub    %edx,%eax
  8013bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_USER);
  8013be:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8013c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013c8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013cd:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013d2:	83 ec 04             	sub    $0x4,%esp
  8013d5:	6a 06                	push   $0x6
  8013d7:	ff 75 f4             	pushl  -0xc(%ebp)
  8013da:	50                   	push   %eax
  8013db:	e8 b2 05 00 00       	call   801992 <sys_allocate_chunk>
  8013e0:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013e3:	a1 20 51 80 00       	mov    0x805120,%eax
  8013e8:	83 ec 0c             	sub    $0xc,%esp
  8013eb:	50                   	push   %eax
  8013ec:	e8 27 0c 00 00       	call   802018 <initialize_MemBlocksList>
  8013f1:	83 c4 10             	add    $0x10,%esp
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	struct MemBlock * NewBlock = LIST_FIRST(&AvailableMemBlocksList);
  8013f4:	a1 48 51 80 00       	mov    0x805148,%eax
  8013f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
	NewBlock->sva = USER_HEAP_START;
  8013fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013ff:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	NewBlock->size = (USER_HEAP_MAX-USER_HEAP_START);
  801406:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801409:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	LIST_REMOVE(&AvailableMemBlocksList,NewBlock);
  801410:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801414:	75 14                	jne    80142a <initialize_dyn_block_system+0x105>
  801416:	83 ec 04             	sub    $0x4,%esp
  801419:	68 55 3f 80 00       	push   $0x803f55
  80141e:	6a 33                	push   $0x33
  801420:	68 73 3f 80 00       	push   $0x803f73
  801425:	e8 8c ee ff ff       	call   8002b6 <_panic>
  80142a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80142d:	8b 00                	mov    (%eax),%eax
  80142f:	85 c0                	test   %eax,%eax
  801431:	74 10                	je     801443 <initialize_dyn_block_system+0x11e>
  801433:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801436:	8b 00                	mov    (%eax),%eax
  801438:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80143b:	8b 52 04             	mov    0x4(%edx),%edx
  80143e:	89 50 04             	mov    %edx,0x4(%eax)
  801441:	eb 0b                	jmp    80144e <initialize_dyn_block_system+0x129>
  801443:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801446:	8b 40 04             	mov    0x4(%eax),%eax
  801449:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80144e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801451:	8b 40 04             	mov    0x4(%eax),%eax
  801454:	85 c0                	test   %eax,%eax
  801456:	74 0f                	je     801467 <initialize_dyn_block_system+0x142>
  801458:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80145b:	8b 40 04             	mov    0x4(%eax),%eax
  80145e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801461:	8b 12                	mov    (%edx),%edx
  801463:	89 10                	mov    %edx,(%eax)
  801465:	eb 0a                	jmp    801471 <initialize_dyn_block_system+0x14c>
  801467:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80146a:	8b 00                	mov    (%eax),%eax
  80146c:	a3 48 51 80 00       	mov    %eax,0x805148
  801471:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801474:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80147a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80147d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801484:	a1 54 51 80 00       	mov    0x805154,%eax
  801489:	48                   	dec    %eax
  80148a:	a3 54 51 80 00       	mov    %eax,0x805154
	LIST_INSERT_HEAD(&FreeMemBlocksList, NewBlock);
  80148f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801493:	75 14                	jne    8014a9 <initialize_dyn_block_system+0x184>
  801495:	83 ec 04             	sub    $0x4,%esp
  801498:	68 80 3f 80 00       	push   $0x803f80
  80149d:	6a 34                	push   $0x34
  80149f:	68 73 3f 80 00       	push   $0x803f73
  8014a4:	e8 0d ee ff ff       	call   8002b6 <_panic>
  8014a9:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8014af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014b2:	89 10                	mov    %edx,(%eax)
  8014b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014b7:	8b 00                	mov    (%eax),%eax
  8014b9:	85 c0                	test   %eax,%eax
  8014bb:	74 0d                	je     8014ca <initialize_dyn_block_system+0x1a5>
  8014bd:	a1 38 51 80 00       	mov    0x805138,%eax
  8014c2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8014c5:	89 50 04             	mov    %edx,0x4(%eax)
  8014c8:	eb 08                	jmp    8014d2 <initialize_dyn_block_system+0x1ad>
  8014ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014cd:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8014d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014d5:	a3 38 51 80 00       	mov    %eax,0x805138
  8014da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014dd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8014e4:	a1 44 51 80 00       	mov    0x805144,%eax
  8014e9:	40                   	inc    %eax
  8014ea:	a3 44 51 80 00       	mov    %eax,0x805144
}
  8014ef:	90                   	nop
  8014f0:	c9                   	leave  
  8014f1:	c3                   	ret    

008014f2 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8014f2:	55                   	push   %ebp
  8014f3:	89 e5                	mov    %esp,%ebp
  8014f5:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8014f8:	e8 f7 fd ff ff       	call   8012f4 <InitializeUHeap>
	if (size == 0) return NULL ;
  8014fd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801501:	75 07                	jne    80150a <malloc+0x18>
  801503:	b8 00 00 00 00       	mov    $0x0,%eax
  801508:	eb 61                	jmp    80156b <malloc+0x79>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
	uint32 malloc_allocsize=ROUNDUP(size,PAGE_SIZE);
  80150a:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801511:	8b 55 08             	mov    0x8(%ebp),%edx
  801514:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801517:	01 d0                	add    %edx,%eax
  801519:	48                   	dec    %eax
  80151a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80151d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801520:	ba 00 00 00 00       	mov    $0x0,%edx
  801525:	f7 75 f0             	divl   -0x10(%ebp)
  801528:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80152b:	29 d0                	sub    %edx,%eax
  80152d:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 //int ret=0;
	struct MemBlock * user_block;
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801530:	e8 2b 08 00 00       	call   801d60 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801535:	85 c0                	test   %eax,%eax
  801537:	74 11                	je     80154a <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801539:	83 ec 0c             	sub    $0xc,%esp
  80153c:	ff 75 e8             	pushl  -0x18(%ebp)
  80153f:	e8 96 0e 00 00       	call   8023da <alloc_block_FF>
  801544:	83 c4 10             	add    $0x10,%esp
  801547:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(user_block!=NULL)
  80154a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80154e:	74 16                	je     801566 <malloc+0x74>
	{
		//sys_allocate_chunk(user_block->sva,malloc_allocsize,PERM_WRITEABLE| PERM_PRESENT);
		insert_sorted_allocList(user_block);
  801550:	83 ec 0c             	sub    $0xc,%esp
  801553:	ff 75 f4             	pushl  -0xc(%ebp)
  801556:	e8 f2 0b 00 00       	call   80214d <insert_sorted_allocList>
  80155b:	83 c4 10             	add    $0x10,%esp
		return (uint32 *)user_block->sva;
  80155e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801561:	8b 40 08             	mov    0x8(%eax),%eax
  801564:	eb 05                	jmp    80156b <malloc+0x79>
	}

    return NULL;
  801566:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80156b:	c9                   	leave  
  80156c:	c3                   	ret    

0080156d <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80156d:	55                   	push   %ebp
  80156e:	89 e5                	mov    %esp,%ebp
  801570:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	struct MemBlock * free_block=find_block(&AllocMemBlocksList,(uint32)virtual_address);
  801573:	8b 45 08             	mov    0x8(%ebp),%eax
  801576:	83 ec 08             	sub    $0x8,%esp
  801579:	50                   	push   %eax
  80157a:	68 40 50 80 00       	push   $0x805040
  80157f:	e8 71 0b 00 00       	call   8020f5 <find_block>
  801584:	83 c4 10             	add    $0x10,%esp
  801587:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(free_block!=NULL)
  80158a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80158e:	0f 84 a6 00 00 00    	je     80163a <free+0xcd>
	{
		sys_free_user_mem(free_block->sva,free_block->size);
  801594:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801597:	8b 50 0c             	mov    0xc(%eax),%edx
  80159a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80159d:	8b 40 08             	mov    0x8(%eax),%eax
  8015a0:	83 ec 08             	sub    $0x8,%esp
  8015a3:	52                   	push   %edx
  8015a4:	50                   	push   %eax
  8015a5:	e8 b0 03 00 00       	call   80195a <sys_free_user_mem>
  8015aa:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,free_block);
  8015ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8015b1:	75 14                	jne    8015c7 <free+0x5a>
  8015b3:	83 ec 04             	sub    $0x4,%esp
  8015b6:	68 55 3f 80 00       	push   $0x803f55
  8015bb:	6a 74                	push   $0x74
  8015bd:	68 73 3f 80 00       	push   $0x803f73
  8015c2:	e8 ef ec ff ff       	call   8002b6 <_panic>
  8015c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015ca:	8b 00                	mov    (%eax),%eax
  8015cc:	85 c0                	test   %eax,%eax
  8015ce:	74 10                	je     8015e0 <free+0x73>
  8015d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015d3:	8b 00                	mov    (%eax),%eax
  8015d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015d8:	8b 52 04             	mov    0x4(%edx),%edx
  8015db:	89 50 04             	mov    %edx,0x4(%eax)
  8015de:	eb 0b                	jmp    8015eb <free+0x7e>
  8015e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015e3:	8b 40 04             	mov    0x4(%eax),%eax
  8015e6:	a3 44 50 80 00       	mov    %eax,0x805044
  8015eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015ee:	8b 40 04             	mov    0x4(%eax),%eax
  8015f1:	85 c0                	test   %eax,%eax
  8015f3:	74 0f                	je     801604 <free+0x97>
  8015f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015f8:	8b 40 04             	mov    0x4(%eax),%eax
  8015fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015fe:	8b 12                	mov    (%edx),%edx
  801600:	89 10                	mov    %edx,(%eax)
  801602:	eb 0a                	jmp    80160e <free+0xa1>
  801604:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801607:	8b 00                	mov    (%eax),%eax
  801609:	a3 40 50 80 00       	mov    %eax,0x805040
  80160e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801611:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801617:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80161a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801621:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801626:	48                   	dec    %eax
  801627:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(free_block);
  80162c:	83 ec 0c             	sub    $0xc,%esp
  80162f:	ff 75 f4             	pushl  -0xc(%ebp)
  801632:	e8 4e 17 00 00       	call   802d85 <insert_sorted_with_merge_freeList>
  801637:	83 c4 10             	add    $0x10,%esp
	}

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  80163a:	90                   	nop
  80163b:	c9                   	leave  
  80163c:	c3                   	ret    

0080163d <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80163d:	55                   	push   %ebp
  80163e:	89 e5                	mov    %esp,%ebp
  801640:	83 ec 38             	sub    $0x38,%esp
  801643:	8b 45 10             	mov    0x10(%ebp),%eax
  801646:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801649:	e8 a6 fc ff ff       	call   8012f4 <InitializeUHeap>
	if (size == 0) return NULL ;
  80164e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801652:	75 0a                	jne    80165e <smalloc+0x21>
  801654:	b8 00 00 00 00       	mov    $0x0,%eax
  801659:	e9 8b 00 00 00       	jmp    8016e9 <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  80165e:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801665:	8b 55 0c             	mov    0xc(%ebp),%edx
  801668:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80166b:	01 d0                	add    %edx,%eax
  80166d:	48                   	dec    %eax
  80166e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801671:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801674:	ba 00 00 00 00       	mov    $0x0,%edx
  801679:	f7 75 f0             	divl   -0x10(%ebp)
  80167c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80167f:	29 d0                	sub    %edx,%eax
  801681:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801684:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  80168b:	e8 d0 06 00 00       	call   801d60 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801690:	85 c0                	test   %eax,%eax
  801692:	74 11                	je     8016a5 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  801694:	83 ec 0c             	sub    $0xc,%esp
  801697:	ff 75 e8             	pushl  -0x18(%ebp)
  80169a:	e8 3b 0d 00 00       	call   8023da <alloc_block_FF>
  80169f:	83 c4 10             	add    $0x10,%esp
  8016a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  8016a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8016a9:	74 39                	je     8016e4 <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8016ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016ae:	8b 40 08             	mov    0x8(%eax),%eax
  8016b1:	89 c2                	mov    %eax,%edx
  8016b3:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8016b7:	52                   	push   %edx
  8016b8:	50                   	push   %eax
  8016b9:	ff 75 0c             	pushl  0xc(%ebp)
  8016bc:	ff 75 08             	pushl  0x8(%ebp)
  8016bf:	e8 21 04 00 00       	call   801ae5 <sys_createSharedObject>
  8016c4:	83 c4 10             	add    $0x10,%esp
  8016c7:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  8016ca:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  8016ce:	74 14                	je     8016e4 <smalloc+0xa7>
  8016d0:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  8016d4:	74 0e                	je     8016e4 <smalloc+0xa7>
  8016d6:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  8016da:	74 08                	je     8016e4 <smalloc+0xa7>
			return (void*) mem_block->sva;
  8016dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016df:	8b 40 08             	mov    0x8(%eax),%eax
  8016e2:	eb 05                	jmp    8016e9 <smalloc+0xac>
	}
	return NULL;
  8016e4:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8016e9:	c9                   	leave  
  8016ea:	c3                   	ret    

008016eb <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8016eb:	55                   	push   %ebp
  8016ec:	89 e5                	mov    %esp,%ebp
  8016ee:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016f1:	e8 fe fb ff ff       	call   8012f4 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8016f6:	83 ec 08             	sub    $0x8,%esp
  8016f9:	ff 75 0c             	pushl  0xc(%ebp)
  8016fc:	ff 75 08             	pushl  0x8(%ebp)
  8016ff:	e8 0b 04 00 00       	call   801b0f <sys_getSizeOfSharedObject>
  801704:	83 c4 10             	add    $0x10,%esp
  801707:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  80170a:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  80170e:	74 76                	je     801786 <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801710:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801717:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80171a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80171d:	01 d0                	add    %edx,%eax
  80171f:	48                   	dec    %eax
  801720:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801723:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801726:	ba 00 00 00 00       	mov    $0x0,%edx
  80172b:	f7 75 ec             	divl   -0x14(%ebp)
  80172e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801731:	29 d0                	sub    %edx,%eax
  801733:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  801736:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  80173d:	e8 1e 06 00 00       	call   801d60 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801742:	85 c0                	test   %eax,%eax
  801744:	74 11                	je     801757 <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  801746:	83 ec 0c             	sub    $0xc,%esp
  801749:	ff 75 e4             	pushl  -0x1c(%ebp)
  80174c:	e8 89 0c 00 00       	call   8023da <alloc_block_FF>
  801751:	83 c4 10             	add    $0x10,%esp
  801754:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  801757:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80175b:	74 29                	je     801786 <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  80175d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801760:	8b 40 08             	mov    0x8(%eax),%eax
  801763:	83 ec 04             	sub    $0x4,%esp
  801766:	50                   	push   %eax
  801767:	ff 75 0c             	pushl  0xc(%ebp)
  80176a:	ff 75 08             	pushl  0x8(%ebp)
  80176d:	e8 ba 03 00 00       	call   801b2c <sys_getSharedObject>
  801772:	83 c4 10             	add    $0x10,%esp
  801775:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  801778:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  80177c:	74 08                	je     801786 <sget+0x9b>
				return (void *)mem_block->sva;
  80177e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801781:	8b 40 08             	mov    0x8(%eax),%eax
  801784:	eb 05                	jmp    80178b <sget+0xa0>
		}
	}
	return NULL;
  801786:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80178b:	c9                   	leave  
  80178c:	c3                   	ret    

0080178d <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80178d:	55                   	push   %ebp
  80178e:	89 e5                	mov    %esp,%ebp
  801790:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801793:	e8 5c fb ff ff       	call   8012f4 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801798:	83 ec 04             	sub    $0x4,%esp
  80179b:	68 a4 3f 80 00       	push   $0x803fa4
  8017a0:	68 f7 00 00 00       	push   $0xf7
  8017a5:	68 73 3f 80 00       	push   $0x803f73
  8017aa:	e8 07 eb ff ff       	call   8002b6 <_panic>

008017af <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8017af:	55                   	push   %ebp
  8017b0:	89 e5                	mov    %esp,%ebp
  8017b2:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()


	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8017b5:	83 ec 04             	sub    $0x4,%esp
  8017b8:	68 cc 3f 80 00       	push   $0x803fcc
  8017bd:	68 0c 01 00 00       	push   $0x10c
  8017c2:	68 73 3f 80 00       	push   $0x803f73
  8017c7:	e8 ea ea ff ff       	call   8002b6 <_panic>

008017cc <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8017cc:	55                   	push   %ebp
  8017cd:	89 e5                	mov    %esp,%ebp
  8017cf:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017d2:	83 ec 04             	sub    $0x4,%esp
  8017d5:	68 f0 3f 80 00       	push   $0x803ff0
  8017da:	68 44 01 00 00       	push   $0x144
  8017df:	68 73 3f 80 00       	push   $0x803f73
  8017e4:	e8 cd ea ff ff       	call   8002b6 <_panic>

008017e9 <shrink>:

}
void shrink(uint32 newSize)
{
  8017e9:	55                   	push   %ebp
  8017ea:	89 e5                	mov    %esp,%ebp
  8017ec:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017ef:	83 ec 04             	sub    $0x4,%esp
  8017f2:	68 f0 3f 80 00       	push   $0x803ff0
  8017f7:	68 49 01 00 00       	push   $0x149
  8017fc:	68 73 3f 80 00       	push   $0x803f73
  801801:	e8 b0 ea ff ff       	call   8002b6 <_panic>

00801806 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801806:	55                   	push   %ebp
  801807:	89 e5                	mov    %esp,%ebp
  801809:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80180c:	83 ec 04             	sub    $0x4,%esp
  80180f:	68 f0 3f 80 00       	push   $0x803ff0
  801814:	68 4e 01 00 00       	push   $0x14e
  801819:	68 73 3f 80 00       	push   $0x803f73
  80181e:	e8 93 ea ff ff       	call   8002b6 <_panic>

00801823 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801823:	55                   	push   %ebp
  801824:	89 e5                	mov    %esp,%ebp
  801826:	57                   	push   %edi
  801827:	56                   	push   %esi
  801828:	53                   	push   %ebx
  801829:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80182c:	8b 45 08             	mov    0x8(%ebp),%eax
  80182f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801832:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801835:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801838:	8b 7d 18             	mov    0x18(%ebp),%edi
  80183b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80183e:	cd 30                	int    $0x30
  801840:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801843:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801846:	83 c4 10             	add    $0x10,%esp
  801849:	5b                   	pop    %ebx
  80184a:	5e                   	pop    %esi
  80184b:	5f                   	pop    %edi
  80184c:	5d                   	pop    %ebp
  80184d:	c3                   	ret    

0080184e <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80184e:	55                   	push   %ebp
  80184f:	89 e5                	mov    %esp,%ebp
  801851:	83 ec 04             	sub    $0x4,%esp
  801854:	8b 45 10             	mov    0x10(%ebp),%eax
  801857:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80185a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80185e:	8b 45 08             	mov    0x8(%ebp),%eax
  801861:	6a 00                	push   $0x0
  801863:	6a 00                	push   $0x0
  801865:	52                   	push   %edx
  801866:	ff 75 0c             	pushl  0xc(%ebp)
  801869:	50                   	push   %eax
  80186a:	6a 00                	push   $0x0
  80186c:	e8 b2 ff ff ff       	call   801823 <syscall>
  801871:	83 c4 18             	add    $0x18,%esp
}
  801874:	90                   	nop
  801875:	c9                   	leave  
  801876:	c3                   	ret    

00801877 <sys_cgetc>:

int
sys_cgetc(void)
{
  801877:	55                   	push   %ebp
  801878:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80187a:	6a 00                	push   $0x0
  80187c:	6a 00                	push   $0x0
  80187e:	6a 00                	push   $0x0
  801880:	6a 00                	push   $0x0
  801882:	6a 00                	push   $0x0
  801884:	6a 01                	push   $0x1
  801886:	e8 98 ff ff ff       	call   801823 <syscall>
  80188b:	83 c4 18             	add    $0x18,%esp
}
  80188e:	c9                   	leave  
  80188f:	c3                   	ret    

00801890 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801890:	55                   	push   %ebp
  801891:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801893:	8b 55 0c             	mov    0xc(%ebp),%edx
  801896:	8b 45 08             	mov    0x8(%ebp),%eax
  801899:	6a 00                	push   $0x0
  80189b:	6a 00                	push   $0x0
  80189d:	6a 00                	push   $0x0
  80189f:	52                   	push   %edx
  8018a0:	50                   	push   %eax
  8018a1:	6a 05                	push   $0x5
  8018a3:	e8 7b ff ff ff       	call   801823 <syscall>
  8018a8:	83 c4 18             	add    $0x18,%esp
}
  8018ab:	c9                   	leave  
  8018ac:	c3                   	ret    

008018ad <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018ad:	55                   	push   %ebp
  8018ae:	89 e5                	mov    %esp,%ebp
  8018b0:	56                   	push   %esi
  8018b1:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018b2:	8b 75 18             	mov    0x18(%ebp),%esi
  8018b5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018b8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018be:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c1:	56                   	push   %esi
  8018c2:	53                   	push   %ebx
  8018c3:	51                   	push   %ecx
  8018c4:	52                   	push   %edx
  8018c5:	50                   	push   %eax
  8018c6:	6a 06                	push   $0x6
  8018c8:	e8 56 ff ff ff       	call   801823 <syscall>
  8018cd:	83 c4 18             	add    $0x18,%esp
}
  8018d0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018d3:	5b                   	pop    %ebx
  8018d4:	5e                   	pop    %esi
  8018d5:	5d                   	pop    %ebp
  8018d6:	c3                   	ret    

008018d7 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8018d7:	55                   	push   %ebp
  8018d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8018da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 00                	push   $0x0
  8018e6:	52                   	push   %edx
  8018e7:	50                   	push   %eax
  8018e8:	6a 07                	push   $0x7
  8018ea:	e8 34 ff ff ff       	call   801823 <syscall>
  8018ef:	83 c4 18             	add    $0x18,%esp
}
  8018f2:	c9                   	leave  
  8018f3:	c3                   	ret    

008018f4 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018f4:	55                   	push   %ebp
  8018f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018f7:	6a 00                	push   $0x0
  8018f9:	6a 00                	push   $0x0
  8018fb:	6a 00                	push   $0x0
  8018fd:	ff 75 0c             	pushl  0xc(%ebp)
  801900:	ff 75 08             	pushl  0x8(%ebp)
  801903:	6a 08                	push   $0x8
  801905:	e8 19 ff ff ff       	call   801823 <syscall>
  80190a:	83 c4 18             	add    $0x18,%esp
}
  80190d:	c9                   	leave  
  80190e:	c3                   	ret    

0080190f <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80190f:	55                   	push   %ebp
  801910:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801912:	6a 00                	push   $0x0
  801914:	6a 00                	push   $0x0
  801916:	6a 00                	push   $0x0
  801918:	6a 00                	push   $0x0
  80191a:	6a 00                	push   $0x0
  80191c:	6a 09                	push   $0x9
  80191e:	e8 00 ff ff ff       	call   801823 <syscall>
  801923:	83 c4 18             	add    $0x18,%esp
}
  801926:	c9                   	leave  
  801927:	c3                   	ret    

00801928 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801928:	55                   	push   %ebp
  801929:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80192b:	6a 00                	push   $0x0
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	6a 00                	push   $0x0
  801933:	6a 00                	push   $0x0
  801935:	6a 0a                	push   $0xa
  801937:	e8 e7 fe ff ff       	call   801823 <syscall>
  80193c:	83 c4 18             	add    $0x18,%esp
}
  80193f:	c9                   	leave  
  801940:	c3                   	ret    

00801941 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801941:	55                   	push   %ebp
  801942:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801944:	6a 00                	push   $0x0
  801946:	6a 00                	push   $0x0
  801948:	6a 00                	push   $0x0
  80194a:	6a 00                	push   $0x0
  80194c:	6a 00                	push   $0x0
  80194e:	6a 0b                	push   $0xb
  801950:	e8 ce fe ff ff       	call   801823 <syscall>
  801955:	83 c4 18             	add    $0x18,%esp
}
  801958:	c9                   	leave  
  801959:	c3                   	ret    

0080195a <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80195a:	55                   	push   %ebp
  80195b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80195d:	6a 00                	push   $0x0
  80195f:	6a 00                	push   $0x0
  801961:	6a 00                	push   $0x0
  801963:	ff 75 0c             	pushl  0xc(%ebp)
  801966:	ff 75 08             	pushl  0x8(%ebp)
  801969:	6a 0f                	push   $0xf
  80196b:	e8 b3 fe ff ff       	call   801823 <syscall>
  801970:	83 c4 18             	add    $0x18,%esp
	return;
  801973:	90                   	nop
}
  801974:	c9                   	leave  
  801975:	c3                   	ret    

00801976 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801976:	55                   	push   %ebp
  801977:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801979:	6a 00                	push   $0x0
  80197b:	6a 00                	push   $0x0
  80197d:	6a 00                	push   $0x0
  80197f:	ff 75 0c             	pushl  0xc(%ebp)
  801982:	ff 75 08             	pushl  0x8(%ebp)
  801985:	6a 10                	push   $0x10
  801987:	e8 97 fe ff ff       	call   801823 <syscall>
  80198c:	83 c4 18             	add    $0x18,%esp
	return ;
  80198f:	90                   	nop
}
  801990:	c9                   	leave  
  801991:	c3                   	ret    

00801992 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801992:	55                   	push   %ebp
  801993:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801995:	6a 00                	push   $0x0
  801997:	6a 00                	push   $0x0
  801999:	ff 75 10             	pushl  0x10(%ebp)
  80199c:	ff 75 0c             	pushl  0xc(%ebp)
  80199f:	ff 75 08             	pushl  0x8(%ebp)
  8019a2:	6a 11                	push   $0x11
  8019a4:	e8 7a fe ff ff       	call   801823 <syscall>
  8019a9:	83 c4 18             	add    $0x18,%esp
	return ;
  8019ac:	90                   	nop
}
  8019ad:	c9                   	leave  
  8019ae:	c3                   	ret    

008019af <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8019af:	55                   	push   %ebp
  8019b0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8019b2:	6a 00                	push   $0x0
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 0c                	push   $0xc
  8019be:	e8 60 fe ff ff       	call   801823 <syscall>
  8019c3:	83 c4 18             	add    $0x18,%esp
}
  8019c6:	c9                   	leave  
  8019c7:	c3                   	ret    

008019c8 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8019c8:	55                   	push   %ebp
  8019c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	ff 75 08             	pushl  0x8(%ebp)
  8019d6:	6a 0d                	push   $0xd
  8019d8:	e8 46 fe ff ff       	call   801823 <syscall>
  8019dd:	83 c4 18             	add    $0x18,%esp
}
  8019e0:	c9                   	leave  
  8019e1:	c3                   	ret    

008019e2 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019e2:	55                   	push   %ebp
  8019e3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 0e                	push   $0xe
  8019f1:	e8 2d fe ff ff       	call   801823 <syscall>
  8019f6:	83 c4 18             	add    $0x18,%esp
}
  8019f9:	90                   	nop
  8019fa:	c9                   	leave  
  8019fb:	c3                   	ret    

008019fc <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8019fc:	55                   	push   %ebp
  8019fd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8019ff:	6a 00                	push   $0x0
  801a01:	6a 00                	push   $0x0
  801a03:	6a 00                	push   $0x0
  801a05:	6a 00                	push   $0x0
  801a07:	6a 00                	push   $0x0
  801a09:	6a 13                	push   $0x13
  801a0b:	e8 13 fe ff ff       	call   801823 <syscall>
  801a10:	83 c4 18             	add    $0x18,%esp
}
  801a13:	90                   	nop
  801a14:	c9                   	leave  
  801a15:	c3                   	ret    

00801a16 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a16:	55                   	push   %ebp
  801a17:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 00                	push   $0x0
  801a23:	6a 14                	push   $0x14
  801a25:	e8 f9 fd ff ff       	call   801823 <syscall>
  801a2a:	83 c4 18             	add    $0x18,%esp
}
  801a2d:	90                   	nop
  801a2e:	c9                   	leave  
  801a2f:	c3                   	ret    

00801a30 <sys_cputc>:


void
sys_cputc(const char c)
{
  801a30:	55                   	push   %ebp
  801a31:	89 e5                	mov    %esp,%ebp
  801a33:	83 ec 04             	sub    $0x4,%esp
  801a36:	8b 45 08             	mov    0x8(%ebp),%eax
  801a39:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a3c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a40:	6a 00                	push   $0x0
  801a42:	6a 00                	push   $0x0
  801a44:	6a 00                	push   $0x0
  801a46:	6a 00                	push   $0x0
  801a48:	50                   	push   %eax
  801a49:	6a 15                	push   $0x15
  801a4b:	e8 d3 fd ff ff       	call   801823 <syscall>
  801a50:	83 c4 18             	add    $0x18,%esp
}
  801a53:	90                   	nop
  801a54:	c9                   	leave  
  801a55:	c3                   	ret    

00801a56 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a56:	55                   	push   %ebp
  801a57:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a59:	6a 00                	push   $0x0
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 00                	push   $0x0
  801a63:	6a 16                	push   $0x16
  801a65:	e8 b9 fd ff ff       	call   801823 <syscall>
  801a6a:	83 c4 18             	add    $0x18,%esp
}
  801a6d:	90                   	nop
  801a6e:	c9                   	leave  
  801a6f:	c3                   	ret    

00801a70 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a70:	55                   	push   %ebp
  801a71:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a73:	8b 45 08             	mov    0x8(%ebp),%eax
  801a76:	6a 00                	push   $0x0
  801a78:	6a 00                	push   $0x0
  801a7a:	6a 00                	push   $0x0
  801a7c:	ff 75 0c             	pushl  0xc(%ebp)
  801a7f:	50                   	push   %eax
  801a80:	6a 17                	push   $0x17
  801a82:	e8 9c fd ff ff       	call   801823 <syscall>
  801a87:	83 c4 18             	add    $0x18,%esp
}
  801a8a:	c9                   	leave  
  801a8b:	c3                   	ret    

00801a8c <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a8c:	55                   	push   %ebp
  801a8d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a92:	8b 45 08             	mov    0x8(%ebp),%eax
  801a95:	6a 00                	push   $0x0
  801a97:	6a 00                	push   $0x0
  801a99:	6a 00                	push   $0x0
  801a9b:	52                   	push   %edx
  801a9c:	50                   	push   %eax
  801a9d:	6a 1a                	push   $0x1a
  801a9f:	e8 7f fd ff ff       	call   801823 <syscall>
  801aa4:	83 c4 18             	add    $0x18,%esp
}
  801aa7:	c9                   	leave  
  801aa8:	c3                   	ret    

00801aa9 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801aa9:	55                   	push   %ebp
  801aaa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801aac:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aaf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	52                   	push   %edx
  801ab9:	50                   	push   %eax
  801aba:	6a 18                	push   $0x18
  801abc:	e8 62 fd ff ff       	call   801823 <syscall>
  801ac1:	83 c4 18             	add    $0x18,%esp
}
  801ac4:	90                   	nop
  801ac5:	c9                   	leave  
  801ac6:	c3                   	ret    

00801ac7 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ac7:	55                   	push   %ebp
  801ac8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801aca:	8b 55 0c             	mov    0xc(%ebp),%edx
  801acd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad0:	6a 00                	push   $0x0
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 00                	push   $0x0
  801ad6:	52                   	push   %edx
  801ad7:	50                   	push   %eax
  801ad8:	6a 19                	push   $0x19
  801ada:	e8 44 fd ff ff       	call   801823 <syscall>
  801adf:	83 c4 18             	add    $0x18,%esp
}
  801ae2:	90                   	nop
  801ae3:	c9                   	leave  
  801ae4:	c3                   	ret    

00801ae5 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801ae5:	55                   	push   %ebp
  801ae6:	89 e5                	mov    %esp,%ebp
  801ae8:	83 ec 04             	sub    $0x4,%esp
  801aeb:	8b 45 10             	mov    0x10(%ebp),%eax
  801aee:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801af1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801af4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801af8:	8b 45 08             	mov    0x8(%ebp),%eax
  801afb:	6a 00                	push   $0x0
  801afd:	51                   	push   %ecx
  801afe:	52                   	push   %edx
  801aff:	ff 75 0c             	pushl  0xc(%ebp)
  801b02:	50                   	push   %eax
  801b03:	6a 1b                	push   $0x1b
  801b05:	e8 19 fd ff ff       	call   801823 <syscall>
  801b0a:	83 c4 18             	add    $0x18,%esp
}
  801b0d:	c9                   	leave  
  801b0e:	c3                   	ret    

00801b0f <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b0f:	55                   	push   %ebp
  801b10:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b12:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b15:	8b 45 08             	mov    0x8(%ebp),%eax
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 00                	push   $0x0
  801b1c:	6a 00                	push   $0x0
  801b1e:	52                   	push   %edx
  801b1f:	50                   	push   %eax
  801b20:	6a 1c                	push   $0x1c
  801b22:	e8 fc fc ff ff       	call   801823 <syscall>
  801b27:	83 c4 18             	add    $0x18,%esp
}
  801b2a:	c9                   	leave  
  801b2b:	c3                   	ret    

00801b2c <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b2c:	55                   	push   %ebp
  801b2d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b2f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b32:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b35:	8b 45 08             	mov    0x8(%ebp),%eax
  801b38:	6a 00                	push   $0x0
  801b3a:	6a 00                	push   $0x0
  801b3c:	51                   	push   %ecx
  801b3d:	52                   	push   %edx
  801b3e:	50                   	push   %eax
  801b3f:	6a 1d                	push   $0x1d
  801b41:	e8 dd fc ff ff       	call   801823 <syscall>
  801b46:	83 c4 18             	add    $0x18,%esp
}
  801b49:	c9                   	leave  
  801b4a:	c3                   	ret    

00801b4b <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b4b:	55                   	push   %ebp
  801b4c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b4e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b51:	8b 45 08             	mov    0x8(%ebp),%eax
  801b54:	6a 00                	push   $0x0
  801b56:	6a 00                	push   $0x0
  801b58:	6a 00                	push   $0x0
  801b5a:	52                   	push   %edx
  801b5b:	50                   	push   %eax
  801b5c:	6a 1e                	push   $0x1e
  801b5e:	e8 c0 fc ff ff       	call   801823 <syscall>
  801b63:	83 c4 18             	add    $0x18,%esp
}
  801b66:	c9                   	leave  
  801b67:	c3                   	ret    

00801b68 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b68:	55                   	push   %ebp
  801b69:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 00                	push   $0x0
  801b73:	6a 00                	push   $0x0
  801b75:	6a 1f                	push   $0x1f
  801b77:	e8 a7 fc ff ff       	call   801823 <syscall>
  801b7c:	83 c4 18             	add    $0x18,%esp
}
  801b7f:	c9                   	leave  
  801b80:	c3                   	ret    

00801b81 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b81:	55                   	push   %ebp
  801b82:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b84:	8b 45 08             	mov    0x8(%ebp),%eax
  801b87:	6a 00                	push   $0x0
  801b89:	ff 75 14             	pushl  0x14(%ebp)
  801b8c:	ff 75 10             	pushl  0x10(%ebp)
  801b8f:	ff 75 0c             	pushl  0xc(%ebp)
  801b92:	50                   	push   %eax
  801b93:	6a 20                	push   $0x20
  801b95:	e8 89 fc ff ff       	call   801823 <syscall>
  801b9a:	83 c4 18             	add    $0x18,%esp
}
  801b9d:	c9                   	leave  
  801b9e:	c3                   	ret    

00801b9f <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801b9f:	55                   	push   %ebp
  801ba0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 00                	push   $0x0
  801bad:	50                   	push   %eax
  801bae:	6a 21                	push   $0x21
  801bb0:	e8 6e fc ff ff       	call   801823 <syscall>
  801bb5:	83 c4 18             	add    $0x18,%esp
}
  801bb8:	90                   	nop
  801bb9:	c9                   	leave  
  801bba:	c3                   	ret    

00801bbb <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801bbb:	55                   	push   %ebp
  801bbc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801bbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 00                	push   $0x0
  801bc9:	50                   	push   %eax
  801bca:	6a 22                	push   $0x22
  801bcc:	e8 52 fc ff ff       	call   801823 <syscall>
  801bd1:	83 c4 18             	add    $0x18,%esp
}
  801bd4:	c9                   	leave  
  801bd5:	c3                   	ret    

00801bd6 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801bd6:	55                   	push   %ebp
  801bd7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 00                	push   $0x0
  801be3:	6a 02                	push   $0x2
  801be5:	e8 39 fc ff ff       	call   801823 <syscall>
  801bea:	83 c4 18             	add    $0x18,%esp
}
  801bed:	c9                   	leave  
  801bee:	c3                   	ret    

00801bef <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801bef:	55                   	push   %ebp
  801bf0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801bf2:	6a 00                	push   $0x0
  801bf4:	6a 00                	push   $0x0
  801bf6:	6a 00                	push   $0x0
  801bf8:	6a 00                	push   $0x0
  801bfa:	6a 00                	push   $0x0
  801bfc:	6a 03                	push   $0x3
  801bfe:	e8 20 fc ff ff       	call   801823 <syscall>
  801c03:	83 c4 18             	add    $0x18,%esp
}
  801c06:	c9                   	leave  
  801c07:	c3                   	ret    

00801c08 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c08:	55                   	push   %ebp
  801c09:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 00                	push   $0x0
  801c11:	6a 00                	push   $0x0
  801c13:	6a 00                	push   $0x0
  801c15:	6a 04                	push   $0x4
  801c17:	e8 07 fc ff ff       	call   801823 <syscall>
  801c1c:	83 c4 18             	add    $0x18,%esp
}
  801c1f:	c9                   	leave  
  801c20:	c3                   	ret    

00801c21 <sys_exit_env>:


void sys_exit_env(void)
{
  801c21:	55                   	push   %ebp
  801c22:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c24:	6a 00                	push   $0x0
  801c26:	6a 00                	push   $0x0
  801c28:	6a 00                	push   $0x0
  801c2a:	6a 00                	push   $0x0
  801c2c:	6a 00                	push   $0x0
  801c2e:	6a 23                	push   $0x23
  801c30:	e8 ee fb ff ff       	call   801823 <syscall>
  801c35:	83 c4 18             	add    $0x18,%esp
}
  801c38:	90                   	nop
  801c39:	c9                   	leave  
  801c3a:	c3                   	ret    

00801c3b <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c3b:	55                   	push   %ebp
  801c3c:	89 e5                	mov    %esp,%ebp
  801c3e:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c41:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c44:	8d 50 04             	lea    0x4(%eax),%edx
  801c47:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 00                	push   $0x0
  801c50:	52                   	push   %edx
  801c51:	50                   	push   %eax
  801c52:	6a 24                	push   $0x24
  801c54:	e8 ca fb ff ff       	call   801823 <syscall>
  801c59:	83 c4 18             	add    $0x18,%esp
	return result;
  801c5c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c5f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c62:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c65:	89 01                	mov    %eax,(%ecx)
  801c67:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6d:	c9                   	leave  
  801c6e:	c2 04 00             	ret    $0x4

00801c71 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c71:	55                   	push   %ebp
  801c72:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c74:	6a 00                	push   $0x0
  801c76:	6a 00                	push   $0x0
  801c78:	ff 75 10             	pushl  0x10(%ebp)
  801c7b:	ff 75 0c             	pushl  0xc(%ebp)
  801c7e:	ff 75 08             	pushl  0x8(%ebp)
  801c81:	6a 12                	push   $0x12
  801c83:	e8 9b fb ff ff       	call   801823 <syscall>
  801c88:	83 c4 18             	add    $0x18,%esp
	return ;
  801c8b:	90                   	nop
}
  801c8c:	c9                   	leave  
  801c8d:	c3                   	ret    

00801c8e <sys_rcr2>:
uint32 sys_rcr2()
{
  801c8e:	55                   	push   %ebp
  801c8f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c91:	6a 00                	push   $0x0
  801c93:	6a 00                	push   $0x0
  801c95:	6a 00                	push   $0x0
  801c97:	6a 00                	push   $0x0
  801c99:	6a 00                	push   $0x0
  801c9b:	6a 25                	push   $0x25
  801c9d:	e8 81 fb ff ff       	call   801823 <syscall>
  801ca2:	83 c4 18             	add    $0x18,%esp
}
  801ca5:	c9                   	leave  
  801ca6:	c3                   	ret    

00801ca7 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801ca7:	55                   	push   %ebp
  801ca8:	89 e5                	mov    %esp,%ebp
  801caa:	83 ec 04             	sub    $0x4,%esp
  801cad:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801cb3:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801cb7:	6a 00                	push   $0x0
  801cb9:	6a 00                	push   $0x0
  801cbb:	6a 00                	push   $0x0
  801cbd:	6a 00                	push   $0x0
  801cbf:	50                   	push   %eax
  801cc0:	6a 26                	push   $0x26
  801cc2:	e8 5c fb ff ff       	call   801823 <syscall>
  801cc7:	83 c4 18             	add    $0x18,%esp
	return ;
  801cca:	90                   	nop
}
  801ccb:	c9                   	leave  
  801ccc:	c3                   	ret    

00801ccd <rsttst>:
void rsttst()
{
  801ccd:	55                   	push   %ebp
  801cce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801cd0:	6a 00                	push   $0x0
  801cd2:	6a 00                	push   $0x0
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 00                	push   $0x0
  801cda:	6a 28                	push   $0x28
  801cdc:	e8 42 fb ff ff       	call   801823 <syscall>
  801ce1:	83 c4 18             	add    $0x18,%esp
	return ;
  801ce4:	90                   	nop
}
  801ce5:	c9                   	leave  
  801ce6:	c3                   	ret    

00801ce7 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ce7:	55                   	push   %ebp
  801ce8:	89 e5                	mov    %esp,%ebp
  801cea:	83 ec 04             	sub    $0x4,%esp
  801ced:	8b 45 14             	mov    0x14(%ebp),%eax
  801cf0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801cf3:	8b 55 18             	mov    0x18(%ebp),%edx
  801cf6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cfa:	52                   	push   %edx
  801cfb:	50                   	push   %eax
  801cfc:	ff 75 10             	pushl  0x10(%ebp)
  801cff:	ff 75 0c             	pushl  0xc(%ebp)
  801d02:	ff 75 08             	pushl  0x8(%ebp)
  801d05:	6a 27                	push   $0x27
  801d07:	e8 17 fb ff ff       	call   801823 <syscall>
  801d0c:	83 c4 18             	add    $0x18,%esp
	return ;
  801d0f:	90                   	nop
}
  801d10:	c9                   	leave  
  801d11:	c3                   	ret    

00801d12 <chktst>:
void chktst(uint32 n)
{
  801d12:	55                   	push   %ebp
  801d13:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d15:	6a 00                	push   $0x0
  801d17:	6a 00                	push   $0x0
  801d19:	6a 00                	push   $0x0
  801d1b:	6a 00                	push   $0x0
  801d1d:	ff 75 08             	pushl  0x8(%ebp)
  801d20:	6a 29                	push   $0x29
  801d22:	e8 fc fa ff ff       	call   801823 <syscall>
  801d27:	83 c4 18             	add    $0x18,%esp
	return ;
  801d2a:	90                   	nop
}
  801d2b:	c9                   	leave  
  801d2c:	c3                   	ret    

00801d2d <inctst>:

void inctst()
{
  801d2d:	55                   	push   %ebp
  801d2e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d30:	6a 00                	push   $0x0
  801d32:	6a 00                	push   $0x0
  801d34:	6a 00                	push   $0x0
  801d36:	6a 00                	push   $0x0
  801d38:	6a 00                	push   $0x0
  801d3a:	6a 2a                	push   $0x2a
  801d3c:	e8 e2 fa ff ff       	call   801823 <syscall>
  801d41:	83 c4 18             	add    $0x18,%esp
	return ;
  801d44:	90                   	nop
}
  801d45:	c9                   	leave  
  801d46:	c3                   	ret    

00801d47 <gettst>:
uint32 gettst()
{
  801d47:	55                   	push   %ebp
  801d48:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 00                	push   $0x0
  801d4e:	6a 00                	push   $0x0
  801d50:	6a 00                	push   $0x0
  801d52:	6a 00                	push   $0x0
  801d54:	6a 2b                	push   $0x2b
  801d56:	e8 c8 fa ff ff       	call   801823 <syscall>
  801d5b:	83 c4 18             	add    $0x18,%esp
}
  801d5e:	c9                   	leave  
  801d5f:	c3                   	ret    

00801d60 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d60:	55                   	push   %ebp
  801d61:	89 e5                	mov    %esp,%ebp
  801d63:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d66:	6a 00                	push   $0x0
  801d68:	6a 00                	push   $0x0
  801d6a:	6a 00                	push   $0x0
  801d6c:	6a 00                	push   $0x0
  801d6e:	6a 00                	push   $0x0
  801d70:	6a 2c                	push   $0x2c
  801d72:	e8 ac fa ff ff       	call   801823 <syscall>
  801d77:	83 c4 18             	add    $0x18,%esp
  801d7a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d7d:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d81:	75 07                	jne    801d8a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d83:	b8 01 00 00 00       	mov    $0x1,%eax
  801d88:	eb 05                	jmp    801d8f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d8a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d8f:	c9                   	leave  
  801d90:	c3                   	ret    

00801d91 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d91:	55                   	push   %ebp
  801d92:	89 e5                	mov    %esp,%ebp
  801d94:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d97:	6a 00                	push   $0x0
  801d99:	6a 00                	push   $0x0
  801d9b:	6a 00                	push   $0x0
  801d9d:	6a 00                	push   $0x0
  801d9f:	6a 00                	push   $0x0
  801da1:	6a 2c                	push   $0x2c
  801da3:	e8 7b fa ff ff       	call   801823 <syscall>
  801da8:	83 c4 18             	add    $0x18,%esp
  801dab:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801dae:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801db2:	75 07                	jne    801dbb <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801db4:	b8 01 00 00 00       	mov    $0x1,%eax
  801db9:	eb 05                	jmp    801dc0 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801dbb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dc0:	c9                   	leave  
  801dc1:	c3                   	ret    

00801dc2 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801dc2:	55                   	push   %ebp
  801dc3:	89 e5                	mov    %esp,%ebp
  801dc5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dc8:	6a 00                	push   $0x0
  801dca:	6a 00                	push   $0x0
  801dcc:	6a 00                	push   $0x0
  801dce:	6a 00                	push   $0x0
  801dd0:	6a 00                	push   $0x0
  801dd2:	6a 2c                	push   $0x2c
  801dd4:	e8 4a fa ff ff       	call   801823 <syscall>
  801dd9:	83 c4 18             	add    $0x18,%esp
  801ddc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801ddf:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801de3:	75 07                	jne    801dec <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801de5:	b8 01 00 00 00       	mov    $0x1,%eax
  801dea:	eb 05                	jmp    801df1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801dec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801df1:	c9                   	leave  
  801df2:	c3                   	ret    

00801df3 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801df3:	55                   	push   %ebp
  801df4:	89 e5                	mov    %esp,%ebp
  801df6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801df9:	6a 00                	push   $0x0
  801dfb:	6a 00                	push   $0x0
  801dfd:	6a 00                	push   $0x0
  801dff:	6a 00                	push   $0x0
  801e01:	6a 00                	push   $0x0
  801e03:	6a 2c                	push   $0x2c
  801e05:	e8 19 fa ff ff       	call   801823 <syscall>
  801e0a:	83 c4 18             	add    $0x18,%esp
  801e0d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e10:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e14:	75 07                	jne    801e1d <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e16:	b8 01 00 00 00       	mov    $0x1,%eax
  801e1b:	eb 05                	jmp    801e22 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e1d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e22:	c9                   	leave  
  801e23:	c3                   	ret    

00801e24 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e24:	55                   	push   %ebp
  801e25:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e27:	6a 00                	push   $0x0
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 00                	push   $0x0
  801e2f:	ff 75 08             	pushl  0x8(%ebp)
  801e32:	6a 2d                	push   $0x2d
  801e34:	e8 ea f9 ff ff       	call   801823 <syscall>
  801e39:	83 c4 18             	add    $0x18,%esp
	return ;
  801e3c:	90                   	nop
}
  801e3d:	c9                   	leave  
  801e3e:	c3                   	ret    

00801e3f <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e3f:	55                   	push   %ebp
  801e40:	89 e5                	mov    %esp,%ebp
  801e42:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e43:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e46:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e49:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4f:	6a 00                	push   $0x0
  801e51:	53                   	push   %ebx
  801e52:	51                   	push   %ecx
  801e53:	52                   	push   %edx
  801e54:	50                   	push   %eax
  801e55:	6a 2e                	push   $0x2e
  801e57:	e8 c7 f9 ff ff       	call   801823 <syscall>
  801e5c:	83 c4 18             	add    $0x18,%esp
}
  801e5f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e62:	c9                   	leave  
  801e63:	c3                   	ret    

00801e64 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e64:	55                   	push   %ebp
  801e65:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e67:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6d:	6a 00                	push   $0x0
  801e6f:	6a 00                	push   $0x0
  801e71:	6a 00                	push   $0x0
  801e73:	52                   	push   %edx
  801e74:	50                   	push   %eax
  801e75:	6a 2f                	push   $0x2f
  801e77:	e8 a7 f9 ff ff       	call   801823 <syscall>
  801e7c:	83 c4 18             	add    $0x18,%esp
}
  801e7f:	c9                   	leave  
  801e80:	c3                   	ret    

00801e81 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801e81:	55                   	push   %ebp
  801e82:	89 e5                	mov    %esp,%ebp
  801e84:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801e87:	83 ec 0c             	sub    $0xc,%esp
  801e8a:	68 00 40 80 00       	push   $0x804000
  801e8f:	e8 d6 e6 ff ff       	call   80056a <cprintf>
  801e94:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801e97:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801e9e:	83 ec 0c             	sub    $0xc,%esp
  801ea1:	68 2c 40 80 00       	push   $0x80402c
  801ea6:	e8 bf e6 ff ff       	call   80056a <cprintf>
  801eab:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801eae:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801eb2:	a1 38 51 80 00       	mov    0x805138,%eax
  801eb7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801eba:	eb 56                	jmp    801f12 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801ebc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ec0:	74 1c                	je     801ede <print_mem_block_lists+0x5d>
  801ec2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec5:	8b 50 08             	mov    0x8(%eax),%edx
  801ec8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ecb:	8b 48 08             	mov    0x8(%eax),%ecx
  801ece:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ed1:	8b 40 0c             	mov    0xc(%eax),%eax
  801ed4:	01 c8                	add    %ecx,%eax
  801ed6:	39 c2                	cmp    %eax,%edx
  801ed8:	73 04                	jae    801ede <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801eda:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801ede:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee1:	8b 50 08             	mov    0x8(%eax),%edx
  801ee4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee7:	8b 40 0c             	mov    0xc(%eax),%eax
  801eea:	01 c2                	add    %eax,%edx
  801eec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eef:	8b 40 08             	mov    0x8(%eax),%eax
  801ef2:	83 ec 04             	sub    $0x4,%esp
  801ef5:	52                   	push   %edx
  801ef6:	50                   	push   %eax
  801ef7:	68 41 40 80 00       	push   $0x804041
  801efc:	e8 69 e6 ff ff       	call   80056a <cprintf>
  801f01:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f07:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f0a:	a1 40 51 80 00       	mov    0x805140,%eax
  801f0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f12:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f16:	74 07                	je     801f1f <print_mem_block_lists+0x9e>
  801f18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f1b:	8b 00                	mov    (%eax),%eax
  801f1d:	eb 05                	jmp    801f24 <print_mem_block_lists+0xa3>
  801f1f:	b8 00 00 00 00       	mov    $0x0,%eax
  801f24:	a3 40 51 80 00       	mov    %eax,0x805140
  801f29:	a1 40 51 80 00       	mov    0x805140,%eax
  801f2e:	85 c0                	test   %eax,%eax
  801f30:	75 8a                	jne    801ebc <print_mem_block_lists+0x3b>
  801f32:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f36:	75 84                	jne    801ebc <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801f38:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f3c:	75 10                	jne    801f4e <print_mem_block_lists+0xcd>
  801f3e:	83 ec 0c             	sub    $0xc,%esp
  801f41:	68 50 40 80 00       	push   $0x804050
  801f46:	e8 1f e6 ff ff       	call   80056a <cprintf>
  801f4b:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f4e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f55:	83 ec 0c             	sub    $0xc,%esp
  801f58:	68 74 40 80 00       	push   $0x804074
  801f5d:	e8 08 e6 ff ff       	call   80056a <cprintf>
  801f62:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f65:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f69:	a1 40 50 80 00       	mov    0x805040,%eax
  801f6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f71:	eb 56                	jmp    801fc9 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f73:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f77:	74 1c                	je     801f95 <print_mem_block_lists+0x114>
  801f79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f7c:	8b 50 08             	mov    0x8(%eax),%edx
  801f7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f82:	8b 48 08             	mov    0x8(%eax),%ecx
  801f85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f88:	8b 40 0c             	mov    0xc(%eax),%eax
  801f8b:	01 c8                	add    %ecx,%eax
  801f8d:	39 c2                	cmp    %eax,%edx
  801f8f:	73 04                	jae    801f95 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801f91:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f98:	8b 50 08             	mov    0x8(%eax),%edx
  801f9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f9e:	8b 40 0c             	mov    0xc(%eax),%eax
  801fa1:	01 c2                	add    %eax,%edx
  801fa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa6:	8b 40 08             	mov    0x8(%eax),%eax
  801fa9:	83 ec 04             	sub    $0x4,%esp
  801fac:	52                   	push   %edx
  801fad:	50                   	push   %eax
  801fae:	68 41 40 80 00       	push   $0x804041
  801fb3:	e8 b2 e5 ff ff       	call   80056a <cprintf>
  801fb8:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801fbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fbe:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801fc1:	a1 48 50 80 00       	mov    0x805048,%eax
  801fc6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fc9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fcd:	74 07                	je     801fd6 <print_mem_block_lists+0x155>
  801fcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd2:	8b 00                	mov    (%eax),%eax
  801fd4:	eb 05                	jmp    801fdb <print_mem_block_lists+0x15a>
  801fd6:	b8 00 00 00 00       	mov    $0x0,%eax
  801fdb:	a3 48 50 80 00       	mov    %eax,0x805048
  801fe0:	a1 48 50 80 00       	mov    0x805048,%eax
  801fe5:	85 c0                	test   %eax,%eax
  801fe7:	75 8a                	jne    801f73 <print_mem_block_lists+0xf2>
  801fe9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fed:	75 84                	jne    801f73 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801fef:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801ff3:	75 10                	jne    802005 <print_mem_block_lists+0x184>
  801ff5:	83 ec 0c             	sub    $0xc,%esp
  801ff8:	68 8c 40 80 00       	push   $0x80408c
  801ffd:	e8 68 e5 ff ff       	call   80056a <cprintf>
  802002:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802005:	83 ec 0c             	sub    $0xc,%esp
  802008:	68 00 40 80 00       	push   $0x804000
  80200d:	e8 58 e5 ff ff       	call   80056a <cprintf>
  802012:	83 c4 10             	add    $0x10,%esp

}
  802015:	90                   	nop
  802016:	c9                   	leave  
  802017:	c3                   	ret    

00802018 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802018:	55                   	push   %ebp
  802019:	89 e5                	mov    %esp,%ebp
  80201b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  80201e:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802025:	00 00 00 
  802028:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80202f:	00 00 00 
  802032:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802039:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  80203c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802043:	e9 9e 00 00 00       	jmp    8020e6 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802048:	a1 50 50 80 00       	mov    0x805050,%eax
  80204d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802050:	c1 e2 04             	shl    $0x4,%edx
  802053:	01 d0                	add    %edx,%eax
  802055:	85 c0                	test   %eax,%eax
  802057:	75 14                	jne    80206d <initialize_MemBlocksList+0x55>
  802059:	83 ec 04             	sub    $0x4,%esp
  80205c:	68 b4 40 80 00       	push   $0x8040b4
  802061:	6a 46                	push   $0x46
  802063:	68 d7 40 80 00       	push   $0x8040d7
  802068:	e8 49 e2 ff ff       	call   8002b6 <_panic>
  80206d:	a1 50 50 80 00       	mov    0x805050,%eax
  802072:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802075:	c1 e2 04             	shl    $0x4,%edx
  802078:	01 d0                	add    %edx,%eax
  80207a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802080:	89 10                	mov    %edx,(%eax)
  802082:	8b 00                	mov    (%eax),%eax
  802084:	85 c0                	test   %eax,%eax
  802086:	74 18                	je     8020a0 <initialize_MemBlocksList+0x88>
  802088:	a1 48 51 80 00       	mov    0x805148,%eax
  80208d:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802093:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802096:	c1 e1 04             	shl    $0x4,%ecx
  802099:	01 ca                	add    %ecx,%edx
  80209b:	89 50 04             	mov    %edx,0x4(%eax)
  80209e:	eb 12                	jmp    8020b2 <initialize_MemBlocksList+0x9a>
  8020a0:	a1 50 50 80 00       	mov    0x805050,%eax
  8020a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020a8:	c1 e2 04             	shl    $0x4,%edx
  8020ab:	01 d0                	add    %edx,%eax
  8020ad:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8020b2:	a1 50 50 80 00       	mov    0x805050,%eax
  8020b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020ba:	c1 e2 04             	shl    $0x4,%edx
  8020bd:	01 d0                	add    %edx,%eax
  8020bf:	a3 48 51 80 00       	mov    %eax,0x805148
  8020c4:	a1 50 50 80 00       	mov    0x805050,%eax
  8020c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020cc:	c1 e2 04             	shl    $0x4,%edx
  8020cf:	01 d0                	add    %edx,%eax
  8020d1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020d8:	a1 54 51 80 00       	mov    0x805154,%eax
  8020dd:	40                   	inc    %eax
  8020de:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  8020e3:	ff 45 f4             	incl   -0xc(%ebp)
  8020e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8020ec:	0f 82 56 ff ff ff    	jb     802048 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  8020f2:	90                   	nop
  8020f3:	c9                   	leave  
  8020f4:	c3                   	ret    

008020f5 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8020f5:	55                   	push   %ebp
  8020f6:	89 e5                	mov    %esp,%ebp
  8020f8:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8020fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fe:	8b 00                	mov    (%eax),%eax
  802100:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802103:	eb 19                	jmp    80211e <find_block+0x29>
	{
		if(va==point->sva)
  802105:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802108:	8b 40 08             	mov    0x8(%eax),%eax
  80210b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80210e:	75 05                	jne    802115 <find_block+0x20>
		   return point;
  802110:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802113:	eb 36                	jmp    80214b <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802115:	8b 45 08             	mov    0x8(%ebp),%eax
  802118:	8b 40 08             	mov    0x8(%eax),%eax
  80211b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80211e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802122:	74 07                	je     80212b <find_block+0x36>
  802124:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802127:	8b 00                	mov    (%eax),%eax
  802129:	eb 05                	jmp    802130 <find_block+0x3b>
  80212b:	b8 00 00 00 00       	mov    $0x0,%eax
  802130:	8b 55 08             	mov    0x8(%ebp),%edx
  802133:	89 42 08             	mov    %eax,0x8(%edx)
  802136:	8b 45 08             	mov    0x8(%ebp),%eax
  802139:	8b 40 08             	mov    0x8(%eax),%eax
  80213c:	85 c0                	test   %eax,%eax
  80213e:	75 c5                	jne    802105 <find_block+0x10>
  802140:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802144:	75 bf                	jne    802105 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802146:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80214b:	c9                   	leave  
  80214c:	c3                   	ret    

0080214d <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80214d:	55                   	push   %ebp
  80214e:	89 e5                	mov    %esp,%ebp
  802150:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802153:	a1 40 50 80 00       	mov    0x805040,%eax
  802158:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  80215b:	a1 44 50 80 00       	mov    0x805044,%eax
  802160:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802163:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802166:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802169:	74 24                	je     80218f <insert_sorted_allocList+0x42>
  80216b:	8b 45 08             	mov    0x8(%ebp),%eax
  80216e:	8b 50 08             	mov    0x8(%eax),%edx
  802171:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802174:	8b 40 08             	mov    0x8(%eax),%eax
  802177:	39 c2                	cmp    %eax,%edx
  802179:	76 14                	jbe    80218f <insert_sorted_allocList+0x42>
  80217b:	8b 45 08             	mov    0x8(%ebp),%eax
  80217e:	8b 50 08             	mov    0x8(%eax),%edx
  802181:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802184:	8b 40 08             	mov    0x8(%eax),%eax
  802187:	39 c2                	cmp    %eax,%edx
  802189:	0f 82 60 01 00 00    	jb     8022ef <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  80218f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802193:	75 65                	jne    8021fa <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802195:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802199:	75 14                	jne    8021af <insert_sorted_allocList+0x62>
  80219b:	83 ec 04             	sub    $0x4,%esp
  80219e:	68 b4 40 80 00       	push   $0x8040b4
  8021a3:	6a 6b                	push   $0x6b
  8021a5:	68 d7 40 80 00       	push   $0x8040d7
  8021aa:	e8 07 e1 ff ff       	call   8002b6 <_panic>
  8021af:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8021b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b8:	89 10                	mov    %edx,(%eax)
  8021ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bd:	8b 00                	mov    (%eax),%eax
  8021bf:	85 c0                	test   %eax,%eax
  8021c1:	74 0d                	je     8021d0 <insert_sorted_allocList+0x83>
  8021c3:	a1 40 50 80 00       	mov    0x805040,%eax
  8021c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8021cb:	89 50 04             	mov    %edx,0x4(%eax)
  8021ce:	eb 08                	jmp    8021d8 <insert_sorted_allocList+0x8b>
  8021d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d3:	a3 44 50 80 00       	mov    %eax,0x805044
  8021d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021db:	a3 40 50 80 00       	mov    %eax,0x805040
  8021e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021ea:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8021ef:	40                   	inc    %eax
  8021f0:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8021f5:	e9 dc 01 00 00       	jmp    8023d6 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8021fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fd:	8b 50 08             	mov    0x8(%eax),%edx
  802200:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802203:	8b 40 08             	mov    0x8(%eax),%eax
  802206:	39 c2                	cmp    %eax,%edx
  802208:	77 6c                	ja     802276 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  80220a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80220e:	74 06                	je     802216 <insert_sorted_allocList+0xc9>
  802210:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802214:	75 14                	jne    80222a <insert_sorted_allocList+0xdd>
  802216:	83 ec 04             	sub    $0x4,%esp
  802219:	68 f0 40 80 00       	push   $0x8040f0
  80221e:	6a 6f                	push   $0x6f
  802220:	68 d7 40 80 00       	push   $0x8040d7
  802225:	e8 8c e0 ff ff       	call   8002b6 <_panic>
  80222a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80222d:	8b 50 04             	mov    0x4(%eax),%edx
  802230:	8b 45 08             	mov    0x8(%ebp),%eax
  802233:	89 50 04             	mov    %edx,0x4(%eax)
  802236:	8b 45 08             	mov    0x8(%ebp),%eax
  802239:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80223c:	89 10                	mov    %edx,(%eax)
  80223e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802241:	8b 40 04             	mov    0x4(%eax),%eax
  802244:	85 c0                	test   %eax,%eax
  802246:	74 0d                	je     802255 <insert_sorted_allocList+0x108>
  802248:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80224b:	8b 40 04             	mov    0x4(%eax),%eax
  80224e:	8b 55 08             	mov    0x8(%ebp),%edx
  802251:	89 10                	mov    %edx,(%eax)
  802253:	eb 08                	jmp    80225d <insert_sorted_allocList+0x110>
  802255:	8b 45 08             	mov    0x8(%ebp),%eax
  802258:	a3 40 50 80 00       	mov    %eax,0x805040
  80225d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802260:	8b 55 08             	mov    0x8(%ebp),%edx
  802263:	89 50 04             	mov    %edx,0x4(%eax)
  802266:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80226b:	40                   	inc    %eax
  80226c:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802271:	e9 60 01 00 00       	jmp    8023d6 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802276:	8b 45 08             	mov    0x8(%ebp),%eax
  802279:	8b 50 08             	mov    0x8(%eax),%edx
  80227c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80227f:	8b 40 08             	mov    0x8(%eax),%eax
  802282:	39 c2                	cmp    %eax,%edx
  802284:	0f 82 4c 01 00 00    	jb     8023d6 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  80228a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80228e:	75 14                	jne    8022a4 <insert_sorted_allocList+0x157>
  802290:	83 ec 04             	sub    $0x4,%esp
  802293:	68 28 41 80 00       	push   $0x804128
  802298:	6a 73                	push   $0x73
  80229a:	68 d7 40 80 00       	push   $0x8040d7
  80229f:	e8 12 e0 ff ff       	call   8002b6 <_panic>
  8022a4:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8022aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ad:	89 50 04             	mov    %edx,0x4(%eax)
  8022b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b3:	8b 40 04             	mov    0x4(%eax),%eax
  8022b6:	85 c0                	test   %eax,%eax
  8022b8:	74 0c                	je     8022c6 <insert_sorted_allocList+0x179>
  8022ba:	a1 44 50 80 00       	mov    0x805044,%eax
  8022bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8022c2:	89 10                	mov    %edx,(%eax)
  8022c4:	eb 08                	jmp    8022ce <insert_sorted_allocList+0x181>
  8022c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c9:	a3 40 50 80 00       	mov    %eax,0x805040
  8022ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d1:	a3 44 50 80 00       	mov    %eax,0x805044
  8022d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022df:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8022e4:	40                   	inc    %eax
  8022e5:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8022ea:	e9 e7 00 00 00       	jmp    8023d6 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8022ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8022f5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8022fc:	a1 40 50 80 00       	mov    0x805040,%eax
  802301:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802304:	e9 9d 00 00 00       	jmp    8023a6 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802309:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230c:	8b 00                	mov    (%eax),%eax
  80230e:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802311:	8b 45 08             	mov    0x8(%ebp),%eax
  802314:	8b 50 08             	mov    0x8(%eax),%edx
  802317:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231a:	8b 40 08             	mov    0x8(%eax),%eax
  80231d:	39 c2                	cmp    %eax,%edx
  80231f:	76 7d                	jbe    80239e <insert_sorted_allocList+0x251>
  802321:	8b 45 08             	mov    0x8(%ebp),%eax
  802324:	8b 50 08             	mov    0x8(%eax),%edx
  802327:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80232a:	8b 40 08             	mov    0x8(%eax),%eax
  80232d:	39 c2                	cmp    %eax,%edx
  80232f:	73 6d                	jae    80239e <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802331:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802335:	74 06                	je     80233d <insert_sorted_allocList+0x1f0>
  802337:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80233b:	75 14                	jne    802351 <insert_sorted_allocList+0x204>
  80233d:	83 ec 04             	sub    $0x4,%esp
  802340:	68 4c 41 80 00       	push   $0x80414c
  802345:	6a 7f                	push   $0x7f
  802347:	68 d7 40 80 00       	push   $0x8040d7
  80234c:	e8 65 df ff ff       	call   8002b6 <_panic>
  802351:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802354:	8b 10                	mov    (%eax),%edx
  802356:	8b 45 08             	mov    0x8(%ebp),%eax
  802359:	89 10                	mov    %edx,(%eax)
  80235b:	8b 45 08             	mov    0x8(%ebp),%eax
  80235e:	8b 00                	mov    (%eax),%eax
  802360:	85 c0                	test   %eax,%eax
  802362:	74 0b                	je     80236f <insert_sorted_allocList+0x222>
  802364:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802367:	8b 00                	mov    (%eax),%eax
  802369:	8b 55 08             	mov    0x8(%ebp),%edx
  80236c:	89 50 04             	mov    %edx,0x4(%eax)
  80236f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802372:	8b 55 08             	mov    0x8(%ebp),%edx
  802375:	89 10                	mov    %edx,(%eax)
  802377:	8b 45 08             	mov    0x8(%ebp),%eax
  80237a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80237d:	89 50 04             	mov    %edx,0x4(%eax)
  802380:	8b 45 08             	mov    0x8(%ebp),%eax
  802383:	8b 00                	mov    (%eax),%eax
  802385:	85 c0                	test   %eax,%eax
  802387:	75 08                	jne    802391 <insert_sorted_allocList+0x244>
  802389:	8b 45 08             	mov    0x8(%ebp),%eax
  80238c:	a3 44 50 80 00       	mov    %eax,0x805044
  802391:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802396:	40                   	inc    %eax
  802397:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  80239c:	eb 39                	jmp    8023d7 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80239e:	a1 48 50 80 00       	mov    0x805048,%eax
  8023a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023aa:	74 07                	je     8023b3 <insert_sorted_allocList+0x266>
  8023ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023af:	8b 00                	mov    (%eax),%eax
  8023b1:	eb 05                	jmp    8023b8 <insert_sorted_allocList+0x26b>
  8023b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8023b8:	a3 48 50 80 00       	mov    %eax,0x805048
  8023bd:	a1 48 50 80 00       	mov    0x805048,%eax
  8023c2:	85 c0                	test   %eax,%eax
  8023c4:	0f 85 3f ff ff ff    	jne    802309 <insert_sorted_allocList+0x1bc>
  8023ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023ce:	0f 85 35 ff ff ff    	jne    802309 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8023d4:	eb 01                	jmp    8023d7 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8023d6:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8023d7:	90                   	nop
  8023d8:	c9                   	leave  
  8023d9:	c3                   	ret    

008023da <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8023da:	55                   	push   %ebp
  8023db:	89 e5                	mov    %esp,%ebp
  8023dd:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8023e0:	a1 38 51 80 00       	mov    0x805138,%eax
  8023e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023e8:	e9 85 01 00 00       	jmp    802572 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8023ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f0:	8b 40 0c             	mov    0xc(%eax),%eax
  8023f3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023f6:	0f 82 6e 01 00 00    	jb     80256a <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8023fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ff:	8b 40 0c             	mov    0xc(%eax),%eax
  802402:	3b 45 08             	cmp    0x8(%ebp),%eax
  802405:	0f 85 8a 00 00 00    	jne    802495 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  80240b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80240f:	75 17                	jne    802428 <alloc_block_FF+0x4e>
  802411:	83 ec 04             	sub    $0x4,%esp
  802414:	68 80 41 80 00       	push   $0x804180
  802419:	68 93 00 00 00       	push   $0x93
  80241e:	68 d7 40 80 00       	push   $0x8040d7
  802423:	e8 8e de ff ff       	call   8002b6 <_panic>
  802428:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242b:	8b 00                	mov    (%eax),%eax
  80242d:	85 c0                	test   %eax,%eax
  80242f:	74 10                	je     802441 <alloc_block_FF+0x67>
  802431:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802434:	8b 00                	mov    (%eax),%eax
  802436:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802439:	8b 52 04             	mov    0x4(%edx),%edx
  80243c:	89 50 04             	mov    %edx,0x4(%eax)
  80243f:	eb 0b                	jmp    80244c <alloc_block_FF+0x72>
  802441:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802444:	8b 40 04             	mov    0x4(%eax),%eax
  802447:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80244c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244f:	8b 40 04             	mov    0x4(%eax),%eax
  802452:	85 c0                	test   %eax,%eax
  802454:	74 0f                	je     802465 <alloc_block_FF+0x8b>
  802456:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802459:	8b 40 04             	mov    0x4(%eax),%eax
  80245c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80245f:	8b 12                	mov    (%edx),%edx
  802461:	89 10                	mov    %edx,(%eax)
  802463:	eb 0a                	jmp    80246f <alloc_block_FF+0x95>
  802465:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802468:	8b 00                	mov    (%eax),%eax
  80246a:	a3 38 51 80 00       	mov    %eax,0x805138
  80246f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802472:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802478:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802482:	a1 44 51 80 00       	mov    0x805144,%eax
  802487:	48                   	dec    %eax
  802488:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  80248d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802490:	e9 10 01 00 00       	jmp    8025a5 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802495:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802498:	8b 40 0c             	mov    0xc(%eax),%eax
  80249b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80249e:	0f 86 c6 00 00 00    	jbe    80256a <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8024a4:	a1 48 51 80 00       	mov    0x805148,%eax
  8024a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8024ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024af:	8b 50 08             	mov    0x8(%eax),%edx
  8024b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024b5:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8024b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8024be:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8024c1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024c5:	75 17                	jne    8024de <alloc_block_FF+0x104>
  8024c7:	83 ec 04             	sub    $0x4,%esp
  8024ca:	68 80 41 80 00       	push   $0x804180
  8024cf:	68 9b 00 00 00       	push   $0x9b
  8024d4:	68 d7 40 80 00       	push   $0x8040d7
  8024d9:	e8 d8 dd ff ff       	call   8002b6 <_panic>
  8024de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024e1:	8b 00                	mov    (%eax),%eax
  8024e3:	85 c0                	test   %eax,%eax
  8024e5:	74 10                	je     8024f7 <alloc_block_FF+0x11d>
  8024e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024ea:	8b 00                	mov    (%eax),%eax
  8024ec:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024ef:	8b 52 04             	mov    0x4(%edx),%edx
  8024f2:	89 50 04             	mov    %edx,0x4(%eax)
  8024f5:	eb 0b                	jmp    802502 <alloc_block_FF+0x128>
  8024f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024fa:	8b 40 04             	mov    0x4(%eax),%eax
  8024fd:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802502:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802505:	8b 40 04             	mov    0x4(%eax),%eax
  802508:	85 c0                	test   %eax,%eax
  80250a:	74 0f                	je     80251b <alloc_block_FF+0x141>
  80250c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80250f:	8b 40 04             	mov    0x4(%eax),%eax
  802512:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802515:	8b 12                	mov    (%edx),%edx
  802517:	89 10                	mov    %edx,(%eax)
  802519:	eb 0a                	jmp    802525 <alloc_block_FF+0x14b>
  80251b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80251e:	8b 00                	mov    (%eax),%eax
  802520:	a3 48 51 80 00       	mov    %eax,0x805148
  802525:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802528:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80252e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802531:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802538:	a1 54 51 80 00       	mov    0x805154,%eax
  80253d:	48                   	dec    %eax
  80253e:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802543:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802546:	8b 50 08             	mov    0x8(%eax),%edx
  802549:	8b 45 08             	mov    0x8(%ebp),%eax
  80254c:	01 c2                	add    %eax,%edx
  80254e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802551:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802554:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802557:	8b 40 0c             	mov    0xc(%eax),%eax
  80255a:	2b 45 08             	sub    0x8(%ebp),%eax
  80255d:	89 c2                	mov    %eax,%edx
  80255f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802562:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802565:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802568:	eb 3b                	jmp    8025a5 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80256a:	a1 40 51 80 00       	mov    0x805140,%eax
  80256f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802572:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802576:	74 07                	je     80257f <alloc_block_FF+0x1a5>
  802578:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257b:	8b 00                	mov    (%eax),%eax
  80257d:	eb 05                	jmp    802584 <alloc_block_FF+0x1aa>
  80257f:	b8 00 00 00 00       	mov    $0x0,%eax
  802584:	a3 40 51 80 00       	mov    %eax,0x805140
  802589:	a1 40 51 80 00       	mov    0x805140,%eax
  80258e:	85 c0                	test   %eax,%eax
  802590:	0f 85 57 fe ff ff    	jne    8023ed <alloc_block_FF+0x13>
  802596:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80259a:	0f 85 4d fe ff ff    	jne    8023ed <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8025a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025a5:	c9                   	leave  
  8025a6:	c3                   	ret    

008025a7 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8025a7:	55                   	push   %ebp
  8025a8:	89 e5                	mov    %esp,%ebp
  8025aa:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8025ad:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8025b4:	a1 38 51 80 00       	mov    0x805138,%eax
  8025b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025bc:	e9 df 00 00 00       	jmp    8026a0 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8025c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c4:	8b 40 0c             	mov    0xc(%eax),%eax
  8025c7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025ca:	0f 82 c8 00 00 00    	jb     802698 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8025d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d3:	8b 40 0c             	mov    0xc(%eax),%eax
  8025d6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025d9:	0f 85 8a 00 00 00    	jne    802669 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8025df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025e3:	75 17                	jne    8025fc <alloc_block_BF+0x55>
  8025e5:	83 ec 04             	sub    $0x4,%esp
  8025e8:	68 80 41 80 00       	push   $0x804180
  8025ed:	68 b7 00 00 00       	push   $0xb7
  8025f2:	68 d7 40 80 00       	push   $0x8040d7
  8025f7:	e8 ba dc ff ff       	call   8002b6 <_panic>
  8025fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ff:	8b 00                	mov    (%eax),%eax
  802601:	85 c0                	test   %eax,%eax
  802603:	74 10                	je     802615 <alloc_block_BF+0x6e>
  802605:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802608:	8b 00                	mov    (%eax),%eax
  80260a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80260d:	8b 52 04             	mov    0x4(%edx),%edx
  802610:	89 50 04             	mov    %edx,0x4(%eax)
  802613:	eb 0b                	jmp    802620 <alloc_block_BF+0x79>
  802615:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802618:	8b 40 04             	mov    0x4(%eax),%eax
  80261b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802620:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802623:	8b 40 04             	mov    0x4(%eax),%eax
  802626:	85 c0                	test   %eax,%eax
  802628:	74 0f                	je     802639 <alloc_block_BF+0x92>
  80262a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262d:	8b 40 04             	mov    0x4(%eax),%eax
  802630:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802633:	8b 12                	mov    (%edx),%edx
  802635:	89 10                	mov    %edx,(%eax)
  802637:	eb 0a                	jmp    802643 <alloc_block_BF+0x9c>
  802639:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263c:	8b 00                	mov    (%eax),%eax
  80263e:	a3 38 51 80 00       	mov    %eax,0x805138
  802643:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802646:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80264c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802656:	a1 44 51 80 00       	mov    0x805144,%eax
  80265b:	48                   	dec    %eax
  80265c:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802661:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802664:	e9 4d 01 00 00       	jmp    8027b6 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802669:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266c:	8b 40 0c             	mov    0xc(%eax),%eax
  80266f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802672:	76 24                	jbe    802698 <alloc_block_BF+0xf1>
  802674:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802677:	8b 40 0c             	mov    0xc(%eax),%eax
  80267a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80267d:	73 19                	jae    802698 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  80267f:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802686:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802689:	8b 40 0c             	mov    0xc(%eax),%eax
  80268c:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  80268f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802692:	8b 40 08             	mov    0x8(%eax),%eax
  802695:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802698:	a1 40 51 80 00       	mov    0x805140,%eax
  80269d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026a4:	74 07                	je     8026ad <alloc_block_BF+0x106>
  8026a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a9:	8b 00                	mov    (%eax),%eax
  8026ab:	eb 05                	jmp    8026b2 <alloc_block_BF+0x10b>
  8026ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8026b2:	a3 40 51 80 00       	mov    %eax,0x805140
  8026b7:	a1 40 51 80 00       	mov    0x805140,%eax
  8026bc:	85 c0                	test   %eax,%eax
  8026be:	0f 85 fd fe ff ff    	jne    8025c1 <alloc_block_BF+0x1a>
  8026c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026c8:	0f 85 f3 fe ff ff    	jne    8025c1 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8026ce:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8026d2:	0f 84 d9 00 00 00    	je     8027b1 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8026d8:	a1 48 51 80 00       	mov    0x805148,%eax
  8026dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8026e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026e3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026e6:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8026e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8026ef:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8026f2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8026f6:	75 17                	jne    80270f <alloc_block_BF+0x168>
  8026f8:	83 ec 04             	sub    $0x4,%esp
  8026fb:	68 80 41 80 00       	push   $0x804180
  802700:	68 c7 00 00 00       	push   $0xc7
  802705:	68 d7 40 80 00       	push   $0x8040d7
  80270a:	e8 a7 db ff ff       	call   8002b6 <_panic>
  80270f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802712:	8b 00                	mov    (%eax),%eax
  802714:	85 c0                	test   %eax,%eax
  802716:	74 10                	je     802728 <alloc_block_BF+0x181>
  802718:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80271b:	8b 00                	mov    (%eax),%eax
  80271d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802720:	8b 52 04             	mov    0x4(%edx),%edx
  802723:	89 50 04             	mov    %edx,0x4(%eax)
  802726:	eb 0b                	jmp    802733 <alloc_block_BF+0x18c>
  802728:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80272b:	8b 40 04             	mov    0x4(%eax),%eax
  80272e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802733:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802736:	8b 40 04             	mov    0x4(%eax),%eax
  802739:	85 c0                	test   %eax,%eax
  80273b:	74 0f                	je     80274c <alloc_block_BF+0x1a5>
  80273d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802740:	8b 40 04             	mov    0x4(%eax),%eax
  802743:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802746:	8b 12                	mov    (%edx),%edx
  802748:	89 10                	mov    %edx,(%eax)
  80274a:	eb 0a                	jmp    802756 <alloc_block_BF+0x1af>
  80274c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80274f:	8b 00                	mov    (%eax),%eax
  802751:	a3 48 51 80 00       	mov    %eax,0x805148
  802756:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802759:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80275f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802762:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802769:	a1 54 51 80 00       	mov    0x805154,%eax
  80276e:	48                   	dec    %eax
  80276f:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802774:	83 ec 08             	sub    $0x8,%esp
  802777:	ff 75 ec             	pushl  -0x14(%ebp)
  80277a:	68 38 51 80 00       	push   $0x805138
  80277f:	e8 71 f9 ff ff       	call   8020f5 <find_block>
  802784:	83 c4 10             	add    $0x10,%esp
  802787:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  80278a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80278d:	8b 50 08             	mov    0x8(%eax),%edx
  802790:	8b 45 08             	mov    0x8(%ebp),%eax
  802793:	01 c2                	add    %eax,%edx
  802795:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802798:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  80279b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80279e:	8b 40 0c             	mov    0xc(%eax),%eax
  8027a1:	2b 45 08             	sub    0x8(%ebp),%eax
  8027a4:	89 c2                	mov    %eax,%edx
  8027a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027a9:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8027ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027af:	eb 05                	jmp    8027b6 <alloc_block_BF+0x20f>
	}
	return NULL;
  8027b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027b6:	c9                   	leave  
  8027b7:	c3                   	ret    

008027b8 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8027b8:	55                   	push   %ebp
  8027b9:	89 e5                	mov    %esp,%ebp
  8027bb:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8027be:	a1 28 50 80 00       	mov    0x805028,%eax
  8027c3:	85 c0                	test   %eax,%eax
  8027c5:	0f 85 de 01 00 00    	jne    8029a9 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8027cb:	a1 38 51 80 00       	mov    0x805138,%eax
  8027d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027d3:	e9 9e 01 00 00       	jmp    802976 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8027d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027db:	8b 40 0c             	mov    0xc(%eax),%eax
  8027de:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027e1:	0f 82 87 01 00 00    	jb     80296e <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8027e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ea:	8b 40 0c             	mov    0xc(%eax),%eax
  8027ed:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027f0:	0f 85 95 00 00 00    	jne    80288b <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8027f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027fa:	75 17                	jne    802813 <alloc_block_NF+0x5b>
  8027fc:	83 ec 04             	sub    $0x4,%esp
  8027ff:	68 80 41 80 00       	push   $0x804180
  802804:	68 e0 00 00 00       	push   $0xe0
  802809:	68 d7 40 80 00       	push   $0x8040d7
  80280e:	e8 a3 da ff ff       	call   8002b6 <_panic>
  802813:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802816:	8b 00                	mov    (%eax),%eax
  802818:	85 c0                	test   %eax,%eax
  80281a:	74 10                	je     80282c <alloc_block_NF+0x74>
  80281c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281f:	8b 00                	mov    (%eax),%eax
  802821:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802824:	8b 52 04             	mov    0x4(%edx),%edx
  802827:	89 50 04             	mov    %edx,0x4(%eax)
  80282a:	eb 0b                	jmp    802837 <alloc_block_NF+0x7f>
  80282c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282f:	8b 40 04             	mov    0x4(%eax),%eax
  802832:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802837:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283a:	8b 40 04             	mov    0x4(%eax),%eax
  80283d:	85 c0                	test   %eax,%eax
  80283f:	74 0f                	je     802850 <alloc_block_NF+0x98>
  802841:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802844:	8b 40 04             	mov    0x4(%eax),%eax
  802847:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80284a:	8b 12                	mov    (%edx),%edx
  80284c:	89 10                	mov    %edx,(%eax)
  80284e:	eb 0a                	jmp    80285a <alloc_block_NF+0xa2>
  802850:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802853:	8b 00                	mov    (%eax),%eax
  802855:	a3 38 51 80 00       	mov    %eax,0x805138
  80285a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802863:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802866:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80286d:	a1 44 51 80 00       	mov    0x805144,%eax
  802872:	48                   	dec    %eax
  802873:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802878:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287b:	8b 40 08             	mov    0x8(%eax),%eax
  80287e:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802883:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802886:	e9 f8 04 00 00       	jmp    802d83 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  80288b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288e:	8b 40 0c             	mov    0xc(%eax),%eax
  802891:	3b 45 08             	cmp    0x8(%ebp),%eax
  802894:	0f 86 d4 00 00 00    	jbe    80296e <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80289a:	a1 48 51 80 00       	mov    0x805148,%eax
  80289f:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8028a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a5:	8b 50 08             	mov    0x8(%eax),%edx
  8028a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ab:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8028ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8028b4:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8028b7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028bb:	75 17                	jne    8028d4 <alloc_block_NF+0x11c>
  8028bd:	83 ec 04             	sub    $0x4,%esp
  8028c0:	68 80 41 80 00       	push   $0x804180
  8028c5:	68 e9 00 00 00       	push   $0xe9
  8028ca:	68 d7 40 80 00       	push   $0x8040d7
  8028cf:	e8 e2 d9 ff ff       	call   8002b6 <_panic>
  8028d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028d7:	8b 00                	mov    (%eax),%eax
  8028d9:	85 c0                	test   %eax,%eax
  8028db:	74 10                	je     8028ed <alloc_block_NF+0x135>
  8028dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e0:	8b 00                	mov    (%eax),%eax
  8028e2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028e5:	8b 52 04             	mov    0x4(%edx),%edx
  8028e8:	89 50 04             	mov    %edx,0x4(%eax)
  8028eb:	eb 0b                	jmp    8028f8 <alloc_block_NF+0x140>
  8028ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f0:	8b 40 04             	mov    0x4(%eax),%eax
  8028f3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8028f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028fb:	8b 40 04             	mov    0x4(%eax),%eax
  8028fe:	85 c0                	test   %eax,%eax
  802900:	74 0f                	je     802911 <alloc_block_NF+0x159>
  802902:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802905:	8b 40 04             	mov    0x4(%eax),%eax
  802908:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80290b:	8b 12                	mov    (%edx),%edx
  80290d:	89 10                	mov    %edx,(%eax)
  80290f:	eb 0a                	jmp    80291b <alloc_block_NF+0x163>
  802911:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802914:	8b 00                	mov    (%eax),%eax
  802916:	a3 48 51 80 00       	mov    %eax,0x805148
  80291b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80291e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802924:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802927:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80292e:	a1 54 51 80 00       	mov    0x805154,%eax
  802933:	48                   	dec    %eax
  802934:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802939:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80293c:	8b 40 08             	mov    0x8(%eax),%eax
  80293f:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802944:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802947:	8b 50 08             	mov    0x8(%eax),%edx
  80294a:	8b 45 08             	mov    0x8(%ebp),%eax
  80294d:	01 c2                	add    %eax,%edx
  80294f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802952:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802955:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802958:	8b 40 0c             	mov    0xc(%eax),%eax
  80295b:	2b 45 08             	sub    0x8(%ebp),%eax
  80295e:	89 c2                	mov    %eax,%edx
  802960:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802963:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802966:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802969:	e9 15 04 00 00       	jmp    802d83 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80296e:	a1 40 51 80 00       	mov    0x805140,%eax
  802973:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802976:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80297a:	74 07                	je     802983 <alloc_block_NF+0x1cb>
  80297c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297f:	8b 00                	mov    (%eax),%eax
  802981:	eb 05                	jmp    802988 <alloc_block_NF+0x1d0>
  802983:	b8 00 00 00 00       	mov    $0x0,%eax
  802988:	a3 40 51 80 00       	mov    %eax,0x805140
  80298d:	a1 40 51 80 00       	mov    0x805140,%eax
  802992:	85 c0                	test   %eax,%eax
  802994:	0f 85 3e fe ff ff    	jne    8027d8 <alloc_block_NF+0x20>
  80299a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80299e:	0f 85 34 fe ff ff    	jne    8027d8 <alloc_block_NF+0x20>
  8029a4:	e9 d5 03 00 00       	jmp    802d7e <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8029a9:	a1 38 51 80 00       	mov    0x805138,%eax
  8029ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029b1:	e9 b1 01 00 00       	jmp    802b67 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8029b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b9:	8b 50 08             	mov    0x8(%eax),%edx
  8029bc:	a1 28 50 80 00       	mov    0x805028,%eax
  8029c1:	39 c2                	cmp    %eax,%edx
  8029c3:	0f 82 96 01 00 00    	jb     802b5f <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  8029c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029cc:	8b 40 0c             	mov    0xc(%eax),%eax
  8029cf:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029d2:	0f 82 87 01 00 00    	jb     802b5f <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  8029d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029db:	8b 40 0c             	mov    0xc(%eax),%eax
  8029de:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029e1:	0f 85 95 00 00 00    	jne    802a7c <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8029e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029eb:	75 17                	jne    802a04 <alloc_block_NF+0x24c>
  8029ed:	83 ec 04             	sub    $0x4,%esp
  8029f0:	68 80 41 80 00       	push   $0x804180
  8029f5:	68 fc 00 00 00       	push   $0xfc
  8029fa:	68 d7 40 80 00       	push   $0x8040d7
  8029ff:	e8 b2 d8 ff ff       	call   8002b6 <_panic>
  802a04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a07:	8b 00                	mov    (%eax),%eax
  802a09:	85 c0                	test   %eax,%eax
  802a0b:	74 10                	je     802a1d <alloc_block_NF+0x265>
  802a0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a10:	8b 00                	mov    (%eax),%eax
  802a12:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a15:	8b 52 04             	mov    0x4(%edx),%edx
  802a18:	89 50 04             	mov    %edx,0x4(%eax)
  802a1b:	eb 0b                	jmp    802a28 <alloc_block_NF+0x270>
  802a1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a20:	8b 40 04             	mov    0x4(%eax),%eax
  802a23:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2b:	8b 40 04             	mov    0x4(%eax),%eax
  802a2e:	85 c0                	test   %eax,%eax
  802a30:	74 0f                	je     802a41 <alloc_block_NF+0x289>
  802a32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a35:	8b 40 04             	mov    0x4(%eax),%eax
  802a38:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a3b:	8b 12                	mov    (%edx),%edx
  802a3d:	89 10                	mov    %edx,(%eax)
  802a3f:	eb 0a                	jmp    802a4b <alloc_block_NF+0x293>
  802a41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a44:	8b 00                	mov    (%eax),%eax
  802a46:	a3 38 51 80 00       	mov    %eax,0x805138
  802a4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a57:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a5e:	a1 44 51 80 00       	mov    0x805144,%eax
  802a63:	48                   	dec    %eax
  802a64:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802a69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6c:	8b 40 08             	mov    0x8(%eax),%eax
  802a6f:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802a74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a77:	e9 07 03 00 00       	jmp    802d83 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802a7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7f:	8b 40 0c             	mov    0xc(%eax),%eax
  802a82:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a85:	0f 86 d4 00 00 00    	jbe    802b5f <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802a8b:	a1 48 51 80 00       	mov    0x805148,%eax
  802a90:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802a93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a96:	8b 50 08             	mov    0x8(%eax),%edx
  802a99:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a9c:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802a9f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aa2:	8b 55 08             	mov    0x8(%ebp),%edx
  802aa5:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802aa8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802aac:	75 17                	jne    802ac5 <alloc_block_NF+0x30d>
  802aae:	83 ec 04             	sub    $0x4,%esp
  802ab1:	68 80 41 80 00       	push   $0x804180
  802ab6:	68 04 01 00 00       	push   $0x104
  802abb:	68 d7 40 80 00       	push   $0x8040d7
  802ac0:	e8 f1 d7 ff ff       	call   8002b6 <_panic>
  802ac5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ac8:	8b 00                	mov    (%eax),%eax
  802aca:	85 c0                	test   %eax,%eax
  802acc:	74 10                	je     802ade <alloc_block_NF+0x326>
  802ace:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ad1:	8b 00                	mov    (%eax),%eax
  802ad3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ad6:	8b 52 04             	mov    0x4(%edx),%edx
  802ad9:	89 50 04             	mov    %edx,0x4(%eax)
  802adc:	eb 0b                	jmp    802ae9 <alloc_block_NF+0x331>
  802ade:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ae1:	8b 40 04             	mov    0x4(%eax),%eax
  802ae4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ae9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aec:	8b 40 04             	mov    0x4(%eax),%eax
  802aef:	85 c0                	test   %eax,%eax
  802af1:	74 0f                	je     802b02 <alloc_block_NF+0x34a>
  802af3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802af6:	8b 40 04             	mov    0x4(%eax),%eax
  802af9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802afc:	8b 12                	mov    (%edx),%edx
  802afe:	89 10                	mov    %edx,(%eax)
  802b00:	eb 0a                	jmp    802b0c <alloc_block_NF+0x354>
  802b02:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b05:	8b 00                	mov    (%eax),%eax
  802b07:	a3 48 51 80 00       	mov    %eax,0x805148
  802b0c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b0f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b15:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b18:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b1f:	a1 54 51 80 00       	mov    0x805154,%eax
  802b24:	48                   	dec    %eax
  802b25:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802b2a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b2d:	8b 40 08             	mov    0x8(%eax),%eax
  802b30:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802b35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b38:	8b 50 08             	mov    0x8(%eax),%edx
  802b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3e:	01 c2                	add    %eax,%edx
  802b40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b43:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802b46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b49:	8b 40 0c             	mov    0xc(%eax),%eax
  802b4c:	2b 45 08             	sub    0x8(%ebp),%eax
  802b4f:	89 c2                	mov    %eax,%edx
  802b51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b54:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802b57:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b5a:	e9 24 02 00 00       	jmp    802d83 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b5f:	a1 40 51 80 00       	mov    0x805140,%eax
  802b64:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b67:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b6b:	74 07                	je     802b74 <alloc_block_NF+0x3bc>
  802b6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b70:	8b 00                	mov    (%eax),%eax
  802b72:	eb 05                	jmp    802b79 <alloc_block_NF+0x3c1>
  802b74:	b8 00 00 00 00       	mov    $0x0,%eax
  802b79:	a3 40 51 80 00       	mov    %eax,0x805140
  802b7e:	a1 40 51 80 00       	mov    0x805140,%eax
  802b83:	85 c0                	test   %eax,%eax
  802b85:	0f 85 2b fe ff ff    	jne    8029b6 <alloc_block_NF+0x1fe>
  802b8b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b8f:	0f 85 21 fe ff ff    	jne    8029b6 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b95:	a1 38 51 80 00       	mov    0x805138,%eax
  802b9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b9d:	e9 ae 01 00 00       	jmp    802d50 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802ba2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba5:	8b 50 08             	mov    0x8(%eax),%edx
  802ba8:	a1 28 50 80 00       	mov    0x805028,%eax
  802bad:	39 c2                	cmp    %eax,%edx
  802baf:	0f 83 93 01 00 00    	jae    802d48 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802bb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb8:	8b 40 0c             	mov    0xc(%eax),%eax
  802bbb:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bbe:	0f 82 84 01 00 00    	jb     802d48 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802bc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc7:	8b 40 0c             	mov    0xc(%eax),%eax
  802bca:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bcd:	0f 85 95 00 00 00    	jne    802c68 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802bd3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bd7:	75 17                	jne    802bf0 <alloc_block_NF+0x438>
  802bd9:	83 ec 04             	sub    $0x4,%esp
  802bdc:	68 80 41 80 00       	push   $0x804180
  802be1:	68 14 01 00 00       	push   $0x114
  802be6:	68 d7 40 80 00       	push   $0x8040d7
  802beb:	e8 c6 d6 ff ff       	call   8002b6 <_panic>
  802bf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf3:	8b 00                	mov    (%eax),%eax
  802bf5:	85 c0                	test   %eax,%eax
  802bf7:	74 10                	je     802c09 <alloc_block_NF+0x451>
  802bf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfc:	8b 00                	mov    (%eax),%eax
  802bfe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c01:	8b 52 04             	mov    0x4(%edx),%edx
  802c04:	89 50 04             	mov    %edx,0x4(%eax)
  802c07:	eb 0b                	jmp    802c14 <alloc_block_NF+0x45c>
  802c09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0c:	8b 40 04             	mov    0x4(%eax),%eax
  802c0f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c17:	8b 40 04             	mov    0x4(%eax),%eax
  802c1a:	85 c0                	test   %eax,%eax
  802c1c:	74 0f                	je     802c2d <alloc_block_NF+0x475>
  802c1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c21:	8b 40 04             	mov    0x4(%eax),%eax
  802c24:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c27:	8b 12                	mov    (%edx),%edx
  802c29:	89 10                	mov    %edx,(%eax)
  802c2b:	eb 0a                	jmp    802c37 <alloc_block_NF+0x47f>
  802c2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c30:	8b 00                	mov    (%eax),%eax
  802c32:	a3 38 51 80 00       	mov    %eax,0x805138
  802c37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c43:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c4a:	a1 44 51 80 00       	mov    0x805144,%eax
  802c4f:	48                   	dec    %eax
  802c50:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802c55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c58:	8b 40 08             	mov    0x8(%eax),%eax
  802c5b:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802c60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c63:	e9 1b 01 00 00       	jmp    802d83 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802c68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6b:	8b 40 0c             	mov    0xc(%eax),%eax
  802c6e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c71:	0f 86 d1 00 00 00    	jbe    802d48 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802c77:	a1 48 51 80 00       	mov    0x805148,%eax
  802c7c:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802c7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c82:	8b 50 08             	mov    0x8(%eax),%edx
  802c85:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c88:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802c8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c8e:	8b 55 08             	mov    0x8(%ebp),%edx
  802c91:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802c94:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c98:	75 17                	jne    802cb1 <alloc_block_NF+0x4f9>
  802c9a:	83 ec 04             	sub    $0x4,%esp
  802c9d:	68 80 41 80 00       	push   $0x804180
  802ca2:	68 1c 01 00 00       	push   $0x11c
  802ca7:	68 d7 40 80 00       	push   $0x8040d7
  802cac:	e8 05 d6 ff ff       	call   8002b6 <_panic>
  802cb1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cb4:	8b 00                	mov    (%eax),%eax
  802cb6:	85 c0                	test   %eax,%eax
  802cb8:	74 10                	je     802cca <alloc_block_NF+0x512>
  802cba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cbd:	8b 00                	mov    (%eax),%eax
  802cbf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802cc2:	8b 52 04             	mov    0x4(%edx),%edx
  802cc5:	89 50 04             	mov    %edx,0x4(%eax)
  802cc8:	eb 0b                	jmp    802cd5 <alloc_block_NF+0x51d>
  802cca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ccd:	8b 40 04             	mov    0x4(%eax),%eax
  802cd0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802cd5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cd8:	8b 40 04             	mov    0x4(%eax),%eax
  802cdb:	85 c0                	test   %eax,%eax
  802cdd:	74 0f                	je     802cee <alloc_block_NF+0x536>
  802cdf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ce2:	8b 40 04             	mov    0x4(%eax),%eax
  802ce5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ce8:	8b 12                	mov    (%edx),%edx
  802cea:	89 10                	mov    %edx,(%eax)
  802cec:	eb 0a                	jmp    802cf8 <alloc_block_NF+0x540>
  802cee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cf1:	8b 00                	mov    (%eax),%eax
  802cf3:	a3 48 51 80 00       	mov    %eax,0x805148
  802cf8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cfb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d01:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d04:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d0b:	a1 54 51 80 00       	mov    0x805154,%eax
  802d10:	48                   	dec    %eax
  802d11:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802d16:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d19:	8b 40 08             	mov    0x8(%eax),%eax
  802d1c:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802d21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d24:	8b 50 08             	mov    0x8(%eax),%edx
  802d27:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2a:	01 c2                	add    %eax,%edx
  802d2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2f:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802d32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d35:	8b 40 0c             	mov    0xc(%eax),%eax
  802d38:	2b 45 08             	sub    0x8(%ebp),%eax
  802d3b:	89 c2                	mov    %eax,%edx
  802d3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d40:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802d43:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d46:	eb 3b                	jmp    802d83 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802d48:	a1 40 51 80 00       	mov    0x805140,%eax
  802d4d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d50:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d54:	74 07                	je     802d5d <alloc_block_NF+0x5a5>
  802d56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d59:	8b 00                	mov    (%eax),%eax
  802d5b:	eb 05                	jmp    802d62 <alloc_block_NF+0x5aa>
  802d5d:	b8 00 00 00 00       	mov    $0x0,%eax
  802d62:	a3 40 51 80 00       	mov    %eax,0x805140
  802d67:	a1 40 51 80 00       	mov    0x805140,%eax
  802d6c:	85 c0                	test   %eax,%eax
  802d6e:	0f 85 2e fe ff ff    	jne    802ba2 <alloc_block_NF+0x3ea>
  802d74:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d78:	0f 85 24 fe ff ff    	jne    802ba2 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802d7e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d83:	c9                   	leave  
  802d84:	c3                   	ret    

00802d85 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802d85:	55                   	push   %ebp
  802d86:	89 e5                	mov    %esp,%ebp
  802d88:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802d8b:	a1 38 51 80 00       	mov    0x805138,%eax
  802d90:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802d93:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802d98:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802d9b:	a1 38 51 80 00       	mov    0x805138,%eax
  802da0:	85 c0                	test   %eax,%eax
  802da2:	74 14                	je     802db8 <insert_sorted_with_merge_freeList+0x33>
  802da4:	8b 45 08             	mov    0x8(%ebp),%eax
  802da7:	8b 50 08             	mov    0x8(%eax),%edx
  802daa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dad:	8b 40 08             	mov    0x8(%eax),%eax
  802db0:	39 c2                	cmp    %eax,%edx
  802db2:	0f 87 9b 01 00 00    	ja     802f53 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802db8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dbc:	75 17                	jne    802dd5 <insert_sorted_with_merge_freeList+0x50>
  802dbe:	83 ec 04             	sub    $0x4,%esp
  802dc1:	68 b4 40 80 00       	push   $0x8040b4
  802dc6:	68 38 01 00 00       	push   $0x138
  802dcb:	68 d7 40 80 00       	push   $0x8040d7
  802dd0:	e8 e1 d4 ff ff       	call   8002b6 <_panic>
  802dd5:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dde:	89 10                	mov    %edx,(%eax)
  802de0:	8b 45 08             	mov    0x8(%ebp),%eax
  802de3:	8b 00                	mov    (%eax),%eax
  802de5:	85 c0                	test   %eax,%eax
  802de7:	74 0d                	je     802df6 <insert_sorted_with_merge_freeList+0x71>
  802de9:	a1 38 51 80 00       	mov    0x805138,%eax
  802dee:	8b 55 08             	mov    0x8(%ebp),%edx
  802df1:	89 50 04             	mov    %edx,0x4(%eax)
  802df4:	eb 08                	jmp    802dfe <insert_sorted_with_merge_freeList+0x79>
  802df6:	8b 45 08             	mov    0x8(%ebp),%eax
  802df9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  802e01:	a3 38 51 80 00       	mov    %eax,0x805138
  802e06:	8b 45 08             	mov    0x8(%ebp),%eax
  802e09:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e10:	a1 44 51 80 00       	mov    0x805144,%eax
  802e15:	40                   	inc    %eax
  802e16:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802e1b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e1f:	0f 84 a8 06 00 00    	je     8034cd <insert_sorted_with_merge_freeList+0x748>
  802e25:	8b 45 08             	mov    0x8(%ebp),%eax
  802e28:	8b 50 08             	mov    0x8(%eax),%edx
  802e2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2e:	8b 40 0c             	mov    0xc(%eax),%eax
  802e31:	01 c2                	add    %eax,%edx
  802e33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e36:	8b 40 08             	mov    0x8(%eax),%eax
  802e39:	39 c2                	cmp    %eax,%edx
  802e3b:	0f 85 8c 06 00 00    	jne    8034cd <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802e41:	8b 45 08             	mov    0x8(%ebp),%eax
  802e44:	8b 50 0c             	mov    0xc(%eax),%edx
  802e47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e4a:	8b 40 0c             	mov    0xc(%eax),%eax
  802e4d:	01 c2                	add    %eax,%edx
  802e4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e52:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802e55:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e59:	75 17                	jne    802e72 <insert_sorted_with_merge_freeList+0xed>
  802e5b:	83 ec 04             	sub    $0x4,%esp
  802e5e:	68 80 41 80 00       	push   $0x804180
  802e63:	68 3c 01 00 00       	push   $0x13c
  802e68:	68 d7 40 80 00       	push   $0x8040d7
  802e6d:	e8 44 d4 ff ff       	call   8002b6 <_panic>
  802e72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e75:	8b 00                	mov    (%eax),%eax
  802e77:	85 c0                	test   %eax,%eax
  802e79:	74 10                	je     802e8b <insert_sorted_with_merge_freeList+0x106>
  802e7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e7e:	8b 00                	mov    (%eax),%eax
  802e80:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e83:	8b 52 04             	mov    0x4(%edx),%edx
  802e86:	89 50 04             	mov    %edx,0x4(%eax)
  802e89:	eb 0b                	jmp    802e96 <insert_sorted_with_merge_freeList+0x111>
  802e8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e8e:	8b 40 04             	mov    0x4(%eax),%eax
  802e91:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e99:	8b 40 04             	mov    0x4(%eax),%eax
  802e9c:	85 c0                	test   %eax,%eax
  802e9e:	74 0f                	je     802eaf <insert_sorted_with_merge_freeList+0x12a>
  802ea0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ea3:	8b 40 04             	mov    0x4(%eax),%eax
  802ea6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ea9:	8b 12                	mov    (%edx),%edx
  802eab:	89 10                	mov    %edx,(%eax)
  802ead:	eb 0a                	jmp    802eb9 <insert_sorted_with_merge_freeList+0x134>
  802eaf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eb2:	8b 00                	mov    (%eax),%eax
  802eb4:	a3 38 51 80 00       	mov    %eax,0x805138
  802eb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ebc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ec2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ec5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ecc:	a1 44 51 80 00       	mov    0x805144,%eax
  802ed1:	48                   	dec    %eax
  802ed2:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802ed7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eda:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802ee1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ee4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802eeb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802eef:	75 17                	jne    802f08 <insert_sorted_with_merge_freeList+0x183>
  802ef1:	83 ec 04             	sub    $0x4,%esp
  802ef4:	68 b4 40 80 00       	push   $0x8040b4
  802ef9:	68 3f 01 00 00       	push   $0x13f
  802efe:	68 d7 40 80 00       	push   $0x8040d7
  802f03:	e8 ae d3 ff ff       	call   8002b6 <_panic>
  802f08:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f11:	89 10                	mov    %edx,(%eax)
  802f13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f16:	8b 00                	mov    (%eax),%eax
  802f18:	85 c0                	test   %eax,%eax
  802f1a:	74 0d                	je     802f29 <insert_sorted_with_merge_freeList+0x1a4>
  802f1c:	a1 48 51 80 00       	mov    0x805148,%eax
  802f21:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f24:	89 50 04             	mov    %edx,0x4(%eax)
  802f27:	eb 08                	jmp    802f31 <insert_sorted_with_merge_freeList+0x1ac>
  802f29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f2c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f34:	a3 48 51 80 00       	mov    %eax,0x805148
  802f39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f3c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f43:	a1 54 51 80 00       	mov    0x805154,%eax
  802f48:	40                   	inc    %eax
  802f49:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802f4e:	e9 7a 05 00 00       	jmp    8034cd <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802f53:	8b 45 08             	mov    0x8(%ebp),%eax
  802f56:	8b 50 08             	mov    0x8(%eax),%edx
  802f59:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f5c:	8b 40 08             	mov    0x8(%eax),%eax
  802f5f:	39 c2                	cmp    %eax,%edx
  802f61:	0f 82 14 01 00 00    	jb     80307b <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802f67:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f6a:	8b 50 08             	mov    0x8(%eax),%edx
  802f6d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f70:	8b 40 0c             	mov    0xc(%eax),%eax
  802f73:	01 c2                	add    %eax,%edx
  802f75:	8b 45 08             	mov    0x8(%ebp),%eax
  802f78:	8b 40 08             	mov    0x8(%eax),%eax
  802f7b:	39 c2                	cmp    %eax,%edx
  802f7d:	0f 85 90 00 00 00    	jne    803013 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802f83:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f86:	8b 50 0c             	mov    0xc(%eax),%edx
  802f89:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8c:	8b 40 0c             	mov    0xc(%eax),%eax
  802f8f:	01 c2                	add    %eax,%edx
  802f91:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f94:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802f97:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802fab:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802faf:	75 17                	jne    802fc8 <insert_sorted_with_merge_freeList+0x243>
  802fb1:	83 ec 04             	sub    $0x4,%esp
  802fb4:	68 b4 40 80 00       	push   $0x8040b4
  802fb9:	68 49 01 00 00       	push   $0x149
  802fbe:	68 d7 40 80 00       	push   $0x8040d7
  802fc3:	e8 ee d2 ff ff       	call   8002b6 <_panic>
  802fc8:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802fce:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd1:	89 10                	mov    %edx,(%eax)
  802fd3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd6:	8b 00                	mov    (%eax),%eax
  802fd8:	85 c0                	test   %eax,%eax
  802fda:	74 0d                	je     802fe9 <insert_sorted_with_merge_freeList+0x264>
  802fdc:	a1 48 51 80 00       	mov    0x805148,%eax
  802fe1:	8b 55 08             	mov    0x8(%ebp),%edx
  802fe4:	89 50 04             	mov    %edx,0x4(%eax)
  802fe7:	eb 08                	jmp    802ff1 <insert_sorted_with_merge_freeList+0x26c>
  802fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fec:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff4:	a3 48 51 80 00       	mov    %eax,0x805148
  802ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803003:	a1 54 51 80 00       	mov    0x805154,%eax
  803008:	40                   	inc    %eax
  803009:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80300e:	e9 bb 04 00 00       	jmp    8034ce <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803013:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803017:	75 17                	jne    803030 <insert_sorted_with_merge_freeList+0x2ab>
  803019:	83 ec 04             	sub    $0x4,%esp
  80301c:	68 28 41 80 00       	push   $0x804128
  803021:	68 4c 01 00 00       	push   $0x14c
  803026:	68 d7 40 80 00       	push   $0x8040d7
  80302b:	e8 86 d2 ff ff       	call   8002b6 <_panic>
  803030:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803036:	8b 45 08             	mov    0x8(%ebp),%eax
  803039:	89 50 04             	mov    %edx,0x4(%eax)
  80303c:	8b 45 08             	mov    0x8(%ebp),%eax
  80303f:	8b 40 04             	mov    0x4(%eax),%eax
  803042:	85 c0                	test   %eax,%eax
  803044:	74 0c                	je     803052 <insert_sorted_with_merge_freeList+0x2cd>
  803046:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80304b:	8b 55 08             	mov    0x8(%ebp),%edx
  80304e:	89 10                	mov    %edx,(%eax)
  803050:	eb 08                	jmp    80305a <insert_sorted_with_merge_freeList+0x2d5>
  803052:	8b 45 08             	mov    0x8(%ebp),%eax
  803055:	a3 38 51 80 00       	mov    %eax,0x805138
  80305a:	8b 45 08             	mov    0x8(%ebp),%eax
  80305d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803062:	8b 45 08             	mov    0x8(%ebp),%eax
  803065:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80306b:	a1 44 51 80 00       	mov    0x805144,%eax
  803070:	40                   	inc    %eax
  803071:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803076:	e9 53 04 00 00       	jmp    8034ce <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80307b:	a1 38 51 80 00       	mov    0x805138,%eax
  803080:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803083:	e9 15 04 00 00       	jmp    80349d <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803088:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308b:	8b 00                	mov    (%eax),%eax
  80308d:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803090:	8b 45 08             	mov    0x8(%ebp),%eax
  803093:	8b 50 08             	mov    0x8(%eax),%edx
  803096:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803099:	8b 40 08             	mov    0x8(%eax),%eax
  80309c:	39 c2                	cmp    %eax,%edx
  80309e:	0f 86 f1 03 00 00    	jbe    803495 <insert_sorted_with_merge_freeList+0x710>
  8030a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a7:	8b 50 08             	mov    0x8(%eax),%edx
  8030aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ad:	8b 40 08             	mov    0x8(%eax),%eax
  8030b0:	39 c2                	cmp    %eax,%edx
  8030b2:	0f 83 dd 03 00 00    	jae    803495 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8030b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030bb:	8b 50 08             	mov    0x8(%eax),%edx
  8030be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c1:	8b 40 0c             	mov    0xc(%eax),%eax
  8030c4:	01 c2                	add    %eax,%edx
  8030c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c9:	8b 40 08             	mov    0x8(%eax),%eax
  8030cc:	39 c2                	cmp    %eax,%edx
  8030ce:	0f 85 b9 01 00 00    	jne    80328d <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8030d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d7:	8b 50 08             	mov    0x8(%eax),%edx
  8030da:	8b 45 08             	mov    0x8(%ebp),%eax
  8030dd:	8b 40 0c             	mov    0xc(%eax),%eax
  8030e0:	01 c2                	add    %eax,%edx
  8030e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030e5:	8b 40 08             	mov    0x8(%eax),%eax
  8030e8:	39 c2                	cmp    %eax,%edx
  8030ea:	0f 85 0d 01 00 00    	jne    8031fd <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8030f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f3:	8b 50 0c             	mov    0xc(%eax),%edx
  8030f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030f9:	8b 40 0c             	mov    0xc(%eax),%eax
  8030fc:	01 c2                	add    %eax,%edx
  8030fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803101:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803104:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803108:	75 17                	jne    803121 <insert_sorted_with_merge_freeList+0x39c>
  80310a:	83 ec 04             	sub    $0x4,%esp
  80310d:	68 80 41 80 00       	push   $0x804180
  803112:	68 5c 01 00 00       	push   $0x15c
  803117:	68 d7 40 80 00       	push   $0x8040d7
  80311c:	e8 95 d1 ff ff       	call   8002b6 <_panic>
  803121:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803124:	8b 00                	mov    (%eax),%eax
  803126:	85 c0                	test   %eax,%eax
  803128:	74 10                	je     80313a <insert_sorted_with_merge_freeList+0x3b5>
  80312a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80312d:	8b 00                	mov    (%eax),%eax
  80312f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803132:	8b 52 04             	mov    0x4(%edx),%edx
  803135:	89 50 04             	mov    %edx,0x4(%eax)
  803138:	eb 0b                	jmp    803145 <insert_sorted_with_merge_freeList+0x3c0>
  80313a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80313d:	8b 40 04             	mov    0x4(%eax),%eax
  803140:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803145:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803148:	8b 40 04             	mov    0x4(%eax),%eax
  80314b:	85 c0                	test   %eax,%eax
  80314d:	74 0f                	je     80315e <insert_sorted_with_merge_freeList+0x3d9>
  80314f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803152:	8b 40 04             	mov    0x4(%eax),%eax
  803155:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803158:	8b 12                	mov    (%edx),%edx
  80315a:	89 10                	mov    %edx,(%eax)
  80315c:	eb 0a                	jmp    803168 <insert_sorted_with_merge_freeList+0x3e3>
  80315e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803161:	8b 00                	mov    (%eax),%eax
  803163:	a3 38 51 80 00       	mov    %eax,0x805138
  803168:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80316b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803171:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803174:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80317b:	a1 44 51 80 00       	mov    0x805144,%eax
  803180:	48                   	dec    %eax
  803181:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803186:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803189:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803190:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803193:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80319a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80319e:	75 17                	jne    8031b7 <insert_sorted_with_merge_freeList+0x432>
  8031a0:	83 ec 04             	sub    $0x4,%esp
  8031a3:	68 b4 40 80 00       	push   $0x8040b4
  8031a8:	68 5f 01 00 00       	push   $0x15f
  8031ad:	68 d7 40 80 00       	push   $0x8040d7
  8031b2:	e8 ff d0 ff ff       	call   8002b6 <_panic>
  8031b7:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c0:	89 10                	mov    %edx,(%eax)
  8031c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c5:	8b 00                	mov    (%eax),%eax
  8031c7:	85 c0                	test   %eax,%eax
  8031c9:	74 0d                	je     8031d8 <insert_sorted_with_merge_freeList+0x453>
  8031cb:	a1 48 51 80 00       	mov    0x805148,%eax
  8031d0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031d3:	89 50 04             	mov    %edx,0x4(%eax)
  8031d6:	eb 08                	jmp    8031e0 <insert_sorted_with_merge_freeList+0x45b>
  8031d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031db:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e3:	a3 48 51 80 00       	mov    %eax,0x805148
  8031e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031eb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031f2:	a1 54 51 80 00       	mov    0x805154,%eax
  8031f7:	40                   	inc    %eax
  8031f8:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8031fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803200:	8b 50 0c             	mov    0xc(%eax),%edx
  803203:	8b 45 08             	mov    0x8(%ebp),%eax
  803206:	8b 40 0c             	mov    0xc(%eax),%eax
  803209:	01 c2                	add    %eax,%edx
  80320b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80320e:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803211:	8b 45 08             	mov    0x8(%ebp),%eax
  803214:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  80321b:	8b 45 08             	mov    0x8(%ebp),%eax
  80321e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803225:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803229:	75 17                	jne    803242 <insert_sorted_with_merge_freeList+0x4bd>
  80322b:	83 ec 04             	sub    $0x4,%esp
  80322e:	68 b4 40 80 00       	push   $0x8040b4
  803233:	68 64 01 00 00       	push   $0x164
  803238:	68 d7 40 80 00       	push   $0x8040d7
  80323d:	e8 74 d0 ff ff       	call   8002b6 <_panic>
  803242:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803248:	8b 45 08             	mov    0x8(%ebp),%eax
  80324b:	89 10                	mov    %edx,(%eax)
  80324d:	8b 45 08             	mov    0x8(%ebp),%eax
  803250:	8b 00                	mov    (%eax),%eax
  803252:	85 c0                	test   %eax,%eax
  803254:	74 0d                	je     803263 <insert_sorted_with_merge_freeList+0x4de>
  803256:	a1 48 51 80 00       	mov    0x805148,%eax
  80325b:	8b 55 08             	mov    0x8(%ebp),%edx
  80325e:	89 50 04             	mov    %edx,0x4(%eax)
  803261:	eb 08                	jmp    80326b <insert_sorted_with_merge_freeList+0x4e6>
  803263:	8b 45 08             	mov    0x8(%ebp),%eax
  803266:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80326b:	8b 45 08             	mov    0x8(%ebp),%eax
  80326e:	a3 48 51 80 00       	mov    %eax,0x805148
  803273:	8b 45 08             	mov    0x8(%ebp),%eax
  803276:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80327d:	a1 54 51 80 00       	mov    0x805154,%eax
  803282:	40                   	inc    %eax
  803283:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803288:	e9 41 02 00 00       	jmp    8034ce <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80328d:	8b 45 08             	mov    0x8(%ebp),%eax
  803290:	8b 50 08             	mov    0x8(%eax),%edx
  803293:	8b 45 08             	mov    0x8(%ebp),%eax
  803296:	8b 40 0c             	mov    0xc(%eax),%eax
  803299:	01 c2                	add    %eax,%edx
  80329b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80329e:	8b 40 08             	mov    0x8(%eax),%eax
  8032a1:	39 c2                	cmp    %eax,%edx
  8032a3:	0f 85 7c 01 00 00    	jne    803425 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8032a9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032ad:	74 06                	je     8032b5 <insert_sorted_with_merge_freeList+0x530>
  8032af:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032b3:	75 17                	jne    8032cc <insert_sorted_with_merge_freeList+0x547>
  8032b5:	83 ec 04             	sub    $0x4,%esp
  8032b8:	68 f0 40 80 00       	push   $0x8040f0
  8032bd:	68 69 01 00 00       	push   $0x169
  8032c2:	68 d7 40 80 00       	push   $0x8040d7
  8032c7:	e8 ea cf ff ff       	call   8002b6 <_panic>
  8032cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032cf:	8b 50 04             	mov    0x4(%eax),%edx
  8032d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d5:	89 50 04             	mov    %edx,0x4(%eax)
  8032d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032db:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032de:	89 10                	mov    %edx,(%eax)
  8032e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032e3:	8b 40 04             	mov    0x4(%eax),%eax
  8032e6:	85 c0                	test   %eax,%eax
  8032e8:	74 0d                	je     8032f7 <insert_sorted_with_merge_freeList+0x572>
  8032ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ed:	8b 40 04             	mov    0x4(%eax),%eax
  8032f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8032f3:	89 10                	mov    %edx,(%eax)
  8032f5:	eb 08                	jmp    8032ff <insert_sorted_with_merge_freeList+0x57a>
  8032f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fa:	a3 38 51 80 00       	mov    %eax,0x805138
  8032ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803302:	8b 55 08             	mov    0x8(%ebp),%edx
  803305:	89 50 04             	mov    %edx,0x4(%eax)
  803308:	a1 44 51 80 00       	mov    0x805144,%eax
  80330d:	40                   	inc    %eax
  80330e:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803313:	8b 45 08             	mov    0x8(%ebp),%eax
  803316:	8b 50 0c             	mov    0xc(%eax),%edx
  803319:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80331c:	8b 40 0c             	mov    0xc(%eax),%eax
  80331f:	01 c2                	add    %eax,%edx
  803321:	8b 45 08             	mov    0x8(%ebp),%eax
  803324:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803327:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80332b:	75 17                	jne    803344 <insert_sorted_with_merge_freeList+0x5bf>
  80332d:	83 ec 04             	sub    $0x4,%esp
  803330:	68 80 41 80 00       	push   $0x804180
  803335:	68 6b 01 00 00       	push   $0x16b
  80333a:	68 d7 40 80 00       	push   $0x8040d7
  80333f:	e8 72 cf ff ff       	call   8002b6 <_panic>
  803344:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803347:	8b 00                	mov    (%eax),%eax
  803349:	85 c0                	test   %eax,%eax
  80334b:	74 10                	je     80335d <insert_sorted_with_merge_freeList+0x5d8>
  80334d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803350:	8b 00                	mov    (%eax),%eax
  803352:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803355:	8b 52 04             	mov    0x4(%edx),%edx
  803358:	89 50 04             	mov    %edx,0x4(%eax)
  80335b:	eb 0b                	jmp    803368 <insert_sorted_with_merge_freeList+0x5e3>
  80335d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803360:	8b 40 04             	mov    0x4(%eax),%eax
  803363:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803368:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80336b:	8b 40 04             	mov    0x4(%eax),%eax
  80336e:	85 c0                	test   %eax,%eax
  803370:	74 0f                	je     803381 <insert_sorted_with_merge_freeList+0x5fc>
  803372:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803375:	8b 40 04             	mov    0x4(%eax),%eax
  803378:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80337b:	8b 12                	mov    (%edx),%edx
  80337d:	89 10                	mov    %edx,(%eax)
  80337f:	eb 0a                	jmp    80338b <insert_sorted_with_merge_freeList+0x606>
  803381:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803384:	8b 00                	mov    (%eax),%eax
  803386:	a3 38 51 80 00       	mov    %eax,0x805138
  80338b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80338e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803394:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803397:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80339e:	a1 44 51 80 00       	mov    0x805144,%eax
  8033a3:	48                   	dec    %eax
  8033a4:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8033a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033ac:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8033b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033b6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8033bd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8033c1:	75 17                	jne    8033da <insert_sorted_with_merge_freeList+0x655>
  8033c3:	83 ec 04             	sub    $0x4,%esp
  8033c6:	68 b4 40 80 00       	push   $0x8040b4
  8033cb:	68 6e 01 00 00       	push   $0x16e
  8033d0:	68 d7 40 80 00       	push   $0x8040d7
  8033d5:	e8 dc ce ff ff       	call   8002b6 <_panic>
  8033da:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033e3:	89 10                	mov    %edx,(%eax)
  8033e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033e8:	8b 00                	mov    (%eax),%eax
  8033ea:	85 c0                	test   %eax,%eax
  8033ec:	74 0d                	je     8033fb <insert_sorted_with_merge_freeList+0x676>
  8033ee:	a1 48 51 80 00       	mov    0x805148,%eax
  8033f3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033f6:	89 50 04             	mov    %edx,0x4(%eax)
  8033f9:	eb 08                	jmp    803403 <insert_sorted_with_merge_freeList+0x67e>
  8033fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033fe:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803403:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803406:	a3 48 51 80 00       	mov    %eax,0x805148
  80340b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80340e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803415:	a1 54 51 80 00       	mov    0x805154,%eax
  80341a:	40                   	inc    %eax
  80341b:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803420:	e9 a9 00 00 00       	jmp    8034ce <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803425:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803429:	74 06                	je     803431 <insert_sorted_with_merge_freeList+0x6ac>
  80342b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80342f:	75 17                	jne    803448 <insert_sorted_with_merge_freeList+0x6c3>
  803431:	83 ec 04             	sub    $0x4,%esp
  803434:	68 4c 41 80 00       	push   $0x80414c
  803439:	68 73 01 00 00       	push   $0x173
  80343e:	68 d7 40 80 00       	push   $0x8040d7
  803443:	e8 6e ce ff ff       	call   8002b6 <_panic>
  803448:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80344b:	8b 10                	mov    (%eax),%edx
  80344d:	8b 45 08             	mov    0x8(%ebp),%eax
  803450:	89 10                	mov    %edx,(%eax)
  803452:	8b 45 08             	mov    0x8(%ebp),%eax
  803455:	8b 00                	mov    (%eax),%eax
  803457:	85 c0                	test   %eax,%eax
  803459:	74 0b                	je     803466 <insert_sorted_with_merge_freeList+0x6e1>
  80345b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80345e:	8b 00                	mov    (%eax),%eax
  803460:	8b 55 08             	mov    0x8(%ebp),%edx
  803463:	89 50 04             	mov    %edx,0x4(%eax)
  803466:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803469:	8b 55 08             	mov    0x8(%ebp),%edx
  80346c:	89 10                	mov    %edx,(%eax)
  80346e:	8b 45 08             	mov    0x8(%ebp),%eax
  803471:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803474:	89 50 04             	mov    %edx,0x4(%eax)
  803477:	8b 45 08             	mov    0x8(%ebp),%eax
  80347a:	8b 00                	mov    (%eax),%eax
  80347c:	85 c0                	test   %eax,%eax
  80347e:	75 08                	jne    803488 <insert_sorted_with_merge_freeList+0x703>
  803480:	8b 45 08             	mov    0x8(%ebp),%eax
  803483:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803488:	a1 44 51 80 00       	mov    0x805144,%eax
  80348d:	40                   	inc    %eax
  80348e:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803493:	eb 39                	jmp    8034ce <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803495:	a1 40 51 80 00       	mov    0x805140,%eax
  80349a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80349d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034a1:	74 07                	je     8034aa <insert_sorted_with_merge_freeList+0x725>
  8034a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a6:	8b 00                	mov    (%eax),%eax
  8034a8:	eb 05                	jmp    8034af <insert_sorted_with_merge_freeList+0x72a>
  8034aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8034af:	a3 40 51 80 00       	mov    %eax,0x805140
  8034b4:	a1 40 51 80 00       	mov    0x805140,%eax
  8034b9:	85 c0                	test   %eax,%eax
  8034bb:	0f 85 c7 fb ff ff    	jne    803088 <insert_sorted_with_merge_freeList+0x303>
  8034c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034c5:	0f 85 bd fb ff ff    	jne    803088 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8034cb:	eb 01                	jmp    8034ce <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8034cd:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8034ce:	90                   	nop
  8034cf:	c9                   	leave  
  8034d0:	c3                   	ret    

008034d1 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8034d1:	55                   	push   %ebp
  8034d2:	89 e5                	mov    %esp,%ebp
  8034d4:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8034d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8034da:	89 d0                	mov    %edx,%eax
  8034dc:	c1 e0 02             	shl    $0x2,%eax
  8034df:	01 d0                	add    %edx,%eax
  8034e1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8034e8:	01 d0                	add    %edx,%eax
  8034ea:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8034f1:	01 d0                	add    %edx,%eax
  8034f3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8034fa:	01 d0                	add    %edx,%eax
  8034fc:	c1 e0 04             	shl    $0x4,%eax
  8034ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803502:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803509:	8d 45 e8             	lea    -0x18(%ebp),%eax
  80350c:	83 ec 0c             	sub    $0xc,%esp
  80350f:	50                   	push   %eax
  803510:	e8 26 e7 ff ff       	call   801c3b <sys_get_virtual_time>
  803515:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803518:	eb 41                	jmp    80355b <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  80351a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80351d:	83 ec 0c             	sub    $0xc,%esp
  803520:	50                   	push   %eax
  803521:	e8 15 e7 ff ff       	call   801c3b <sys_get_virtual_time>
  803526:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803529:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80352c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80352f:	29 c2                	sub    %eax,%edx
  803531:	89 d0                	mov    %edx,%eax
  803533:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803536:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803539:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80353c:	89 d1                	mov    %edx,%ecx
  80353e:	29 c1                	sub    %eax,%ecx
  803540:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803543:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803546:	39 c2                	cmp    %eax,%edx
  803548:	0f 97 c0             	seta   %al
  80354b:	0f b6 c0             	movzbl %al,%eax
  80354e:	29 c1                	sub    %eax,%ecx
  803550:	89 c8                	mov    %ecx,%eax
  803552:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803555:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803558:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  80355b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80355e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803561:	72 b7                	jb     80351a <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803563:	90                   	nop
  803564:	c9                   	leave  
  803565:	c3                   	ret    

00803566 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803566:	55                   	push   %ebp
  803567:	89 e5                	mov    %esp,%ebp
  803569:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  80356c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803573:	eb 03                	jmp    803578 <busy_wait+0x12>
  803575:	ff 45 fc             	incl   -0x4(%ebp)
  803578:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80357b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80357e:	72 f5                	jb     803575 <busy_wait+0xf>
	return i;
  803580:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803583:	c9                   	leave  
  803584:	c3                   	ret    
  803585:	66 90                	xchg   %ax,%ax
  803587:	90                   	nop

00803588 <__udivdi3>:
  803588:	55                   	push   %ebp
  803589:	57                   	push   %edi
  80358a:	56                   	push   %esi
  80358b:	53                   	push   %ebx
  80358c:	83 ec 1c             	sub    $0x1c,%esp
  80358f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803593:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803597:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80359b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80359f:	89 ca                	mov    %ecx,%edx
  8035a1:	89 f8                	mov    %edi,%eax
  8035a3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8035a7:	85 f6                	test   %esi,%esi
  8035a9:	75 2d                	jne    8035d8 <__udivdi3+0x50>
  8035ab:	39 cf                	cmp    %ecx,%edi
  8035ad:	77 65                	ja     803614 <__udivdi3+0x8c>
  8035af:	89 fd                	mov    %edi,%ebp
  8035b1:	85 ff                	test   %edi,%edi
  8035b3:	75 0b                	jne    8035c0 <__udivdi3+0x38>
  8035b5:	b8 01 00 00 00       	mov    $0x1,%eax
  8035ba:	31 d2                	xor    %edx,%edx
  8035bc:	f7 f7                	div    %edi
  8035be:	89 c5                	mov    %eax,%ebp
  8035c0:	31 d2                	xor    %edx,%edx
  8035c2:	89 c8                	mov    %ecx,%eax
  8035c4:	f7 f5                	div    %ebp
  8035c6:	89 c1                	mov    %eax,%ecx
  8035c8:	89 d8                	mov    %ebx,%eax
  8035ca:	f7 f5                	div    %ebp
  8035cc:	89 cf                	mov    %ecx,%edi
  8035ce:	89 fa                	mov    %edi,%edx
  8035d0:	83 c4 1c             	add    $0x1c,%esp
  8035d3:	5b                   	pop    %ebx
  8035d4:	5e                   	pop    %esi
  8035d5:	5f                   	pop    %edi
  8035d6:	5d                   	pop    %ebp
  8035d7:	c3                   	ret    
  8035d8:	39 ce                	cmp    %ecx,%esi
  8035da:	77 28                	ja     803604 <__udivdi3+0x7c>
  8035dc:	0f bd fe             	bsr    %esi,%edi
  8035df:	83 f7 1f             	xor    $0x1f,%edi
  8035e2:	75 40                	jne    803624 <__udivdi3+0x9c>
  8035e4:	39 ce                	cmp    %ecx,%esi
  8035e6:	72 0a                	jb     8035f2 <__udivdi3+0x6a>
  8035e8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8035ec:	0f 87 9e 00 00 00    	ja     803690 <__udivdi3+0x108>
  8035f2:	b8 01 00 00 00       	mov    $0x1,%eax
  8035f7:	89 fa                	mov    %edi,%edx
  8035f9:	83 c4 1c             	add    $0x1c,%esp
  8035fc:	5b                   	pop    %ebx
  8035fd:	5e                   	pop    %esi
  8035fe:	5f                   	pop    %edi
  8035ff:	5d                   	pop    %ebp
  803600:	c3                   	ret    
  803601:	8d 76 00             	lea    0x0(%esi),%esi
  803604:	31 ff                	xor    %edi,%edi
  803606:	31 c0                	xor    %eax,%eax
  803608:	89 fa                	mov    %edi,%edx
  80360a:	83 c4 1c             	add    $0x1c,%esp
  80360d:	5b                   	pop    %ebx
  80360e:	5e                   	pop    %esi
  80360f:	5f                   	pop    %edi
  803610:	5d                   	pop    %ebp
  803611:	c3                   	ret    
  803612:	66 90                	xchg   %ax,%ax
  803614:	89 d8                	mov    %ebx,%eax
  803616:	f7 f7                	div    %edi
  803618:	31 ff                	xor    %edi,%edi
  80361a:	89 fa                	mov    %edi,%edx
  80361c:	83 c4 1c             	add    $0x1c,%esp
  80361f:	5b                   	pop    %ebx
  803620:	5e                   	pop    %esi
  803621:	5f                   	pop    %edi
  803622:	5d                   	pop    %ebp
  803623:	c3                   	ret    
  803624:	bd 20 00 00 00       	mov    $0x20,%ebp
  803629:	89 eb                	mov    %ebp,%ebx
  80362b:	29 fb                	sub    %edi,%ebx
  80362d:	89 f9                	mov    %edi,%ecx
  80362f:	d3 e6                	shl    %cl,%esi
  803631:	89 c5                	mov    %eax,%ebp
  803633:	88 d9                	mov    %bl,%cl
  803635:	d3 ed                	shr    %cl,%ebp
  803637:	89 e9                	mov    %ebp,%ecx
  803639:	09 f1                	or     %esi,%ecx
  80363b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80363f:	89 f9                	mov    %edi,%ecx
  803641:	d3 e0                	shl    %cl,%eax
  803643:	89 c5                	mov    %eax,%ebp
  803645:	89 d6                	mov    %edx,%esi
  803647:	88 d9                	mov    %bl,%cl
  803649:	d3 ee                	shr    %cl,%esi
  80364b:	89 f9                	mov    %edi,%ecx
  80364d:	d3 e2                	shl    %cl,%edx
  80364f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803653:	88 d9                	mov    %bl,%cl
  803655:	d3 e8                	shr    %cl,%eax
  803657:	09 c2                	or     %eax,%edx
  803659:	89 d0                	mov    %edx,%eax
  80365b:	89 f2                	mov    %esi,%edx
  80365d:	f7 74 24 0c          	divl   0xc(%esp)
  803661:	89 d6                	mov    %edx,%esi
  803663:	89 c3                	mov    %eax,%ebx
  803665:	f7 e5                	mul    %ebp
  803667:	39 d6                	cmp    %edx,%esi
  803669:	72 19                	jb     803684 <__udivdi3+0xfc>
  80366b:	74 0b                	je     803678 <__udivdi3+0xf0>
  80366d:	89 d8                	mov    %ebx,%eax
  80366f:	31 ff                	xor    %edi,%edi
  803671:	e9 58 ff ff ff       	jmp    8035ce <__udivdi3+0x46>
  803676:	66 90                	xchg   %ax,%ax
  803678:	8b 54 24 08          	mov    0x8(%esp),%edx
  80367c:	89 f9                	mov    %edi,%ecx
  80367e:	d3 e2                	shl    %cl,%edx
  803680:	39 c2                	cmp    %eax,%edx
  803682:	73 e9                	jae    80366d <__udivdi3+0xe5>
  803684:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803687:	31 ff                	xor    %edi,%edi
  803689:	e9 40 ff ff ff       	jmp    8035ce <__udivdi3+0x46>
  80368e:	66 90                	xchg   %ax,%ax
  803690:	31 c0                	xor    %eax,%eax
  803692:	e9 37 ff ff ff       	jmp    8035ce <__udivdi3+0x46>
  803697:	90                   	nop

00803698 <__umoddi3>:
  803698:	55                   	push   %ebp
  803699:	57                   	push   %edi
  80369a:	56                   	push   %esi
  80369b:	53                   	push   %ebx
  80369c:	83 ec 1c             	sub    $0x1c,%esp
  80369f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8036a3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8036a7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8036ab:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8036af:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8036b3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8036b7:	89 f3                	mov    %esi,%ebx
  8036b9:	89 fa                	mov    %edi,%edx
  8036bb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8036bf:	89 34 24             	mov    %esi,(%esp)
  8036c2:	85 c0                	test   %eax,%eax
  8036c4:	75 1a                	jne    8036e0 <__umoddi3+0x48>
  8036c6:	39 f7                	cmp    %esi,%edi
  8036c8:	0f 86 a2 00 00 00    	jbe    803770 <__umoddi3+0xd8>
  8036ce:	89 c8                	mov    %ecx,%eax
  8036d0:	89 f2                	mov    %esi,%edx
  8036d2:	f7 f7                	div    %edi
  8036d4:	89 d0                	mov    %edx,%eax
  8036d6:	31 d2                	xor    %edx,%edx
  8036d8:	83 c4 1c             	add    $0x1c,%esp
  8036db:	5b                   	pop    %ebx
  8036dc:	5e                   	pop    %esi
  8036dd:	5f                   	pop    %edi
  8036de:	5d                   	pop    %ebp
  8036df:	c3                   	ret    
  8036e0:	39 f0                	cmp    %esi,%eax
  8036e2:	0f 87 ac 00 00 00    	ja     803794 <__umoddi3+0xfc>
  8036e8:	0f bd e8             	bsr    %eax,%ebp
  8036eb:	83 f5 1f             	xor    $0x1f,%ebp
  8036ee:	0f 84 ac 00 00 00    	je     8037a0 <__umoddi3+0x108>
  8036f4:	bf 20 00 00 00       	mov    $0x20,%edi
  8036f9:	29 ef                	sub    %ebp,%edi
  8036fb:	89 fe                	mov    %edi,%esi
  8036fd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803701:	89 e9                	mov    %ebp,%ecx
  803703:	d3 e0                	shl    %cl,%eax
  803705:	89 d7                	mov    %edx,%edi
  803707:	89 f1                	mov    %esi,%ecx
  803709:	d3 ef                	shr    %cl,%edi
  80370b:	09 c7                	or     %eax,%edi
  80370d:	89 e9                	mov    %ebp,%ecx
  80370f:	d3 e2                	shl    %cl,%edx
  803711:	89 14 24             	mov    %edx,(%esp)
  803714:	89 d8                	mov    %ebx,%eax
  803716:	d3 e0                	shl    %cl,%eax
  803718:	89 c2                	mov    %eax,%edx
  80371a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80371e:	d3 e0                	shl    %cl,%eax
  803720:	89 44 24 04          	mov    %eax,0x4(%esp)
  803724:	8b 44 24 08          	mov    0x8(%esp),%eax
  803728:	89 f1                	mov    %esi,%ecx
  80372a:	d3 e8                	shr    %cl,%eax
  80372c:	09 d0                	or     %edx,%eax
  80372e:	d3 eb                	shr    %cl,%ebx
  803730:	89 da                	mov    %ebx,%edx
  803732:	f7 f7                	div    %edi
  803734:	89 d3                	mov    %edx,%ebx
  803736:	f7 24 24             	mull   (%esp)
  803739:	89 c6                	mov    %eax,%esi
  80373b:	89 d1                	mov    %edx,%ecx
  80373d:	39 d3                	cmp    %edx,%ebx
  80373f:	0f 82 87 00 00 00    	jb     8037cc <__umoddi3+0x134>
  803745:	0f 84 91 00 00 00    	je     8037dc <__umoddi3+0x144>
  80374b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80374f:	29 f2                	sub    %esi,%edx
  803751:	19 cb                	sbb    %ecx,%ebx
  803753:	89 d8                	mov    %ebx,%eax
  803755:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803759:	d3 e0                	shl    %cl,%eax
  80375b:	89 e9                	mov    %ebp,%ecx
  80375d:	d3 ea                	shr    %cl,%edx
  80375f:	09 d0                	or     %edx,%eax
  803761:	89 e9                	mov    %ebp,%ecx
  803763:	d3 eb                	shr    %cl,%ebx
  803765:	89 da                	mov    %ebx,%edx
  803767:	83 c4 1c             	add    $0x1c,%esp
  80376a:	5b                   	pop    %ebx
  80376b:	5e                   	pop    %esi
  80376c:	5f                   	pop    %edi
  80376d:	5d                   	pop    %ebp
  80376e:	c3                   	ret    
  80376f:	90                   	nop
  803770:	89 fd                	mov    %edi,%ebp
  803772:	85 ff                	test   %edi,%edi
  803774:	75 0b                	jne    803781 <__umoddi3+0xe9>
  803776:	b8 01 00 00 00       	mov    $0x1,%eax
  80377b:	31 d2                	xor    %edx,%edx
  80377d:	f7 f7                	div    %edi
  80377f:	89 c5                	mov    %eax,%ebp
  803781:	89 f0                	mov    %esi,%eax
  803783:	31 d2                	xor    %edx,%edx
  803785:	f7 f5                	div    %ebp
  803787:	89 c8                	mov    %ecx,%eax
  803789:	f7 f5                	div    %ebp
  80378b:	89 d0                	mov    %edx,%eax
  80378d:	e9 44 ff ff ff       	jmp    8036d6 <__umoddi3+0x3e>
  803792:	66 90                	xchg   %ax,%ax
  803794:	89 c8                	mov    %ecx,%eax
  803796:	89 f2                	mov    %esi,%edx
  803798:	83 c4 1c             	add    $0x1c,%esp
  80379b:	5b                   	pop    %ebx
  80379c:	5e                   	pop    %esi
  80379d:	5f                   	pop    %edi
  80379e:	5d                   	pop    %ebp
  80379f:	c3                   	ret    
  8037a0:	3b 04 24             	cmp    (%esp),%eax
  8037a3:	72 06                	jb     8037ab <__umoddi3+0x113>
  8037a5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8037a9:	77 0f                	ja     8037ba <__umoddi3+0x122>
  8037ab:	89 f2                	mov    %esi,%edx
  8037ad:	29 f9                	sub    %edi,%ecx
  8037af:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8037b3:	89 14 24             	mov    %edx,(%esp)
  8037b6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8037ba:	8b 44 24 04          	mov    0x4(%esp),%eax
  8037be:	8b 14 24             	mov    (%esp),%edx
  8037c1:	83 c4 1c             	add    $0x1c,%esp
  8037c4:	5b                   	pop    %ebx
  8037c5:	5e                   	pop    %esi
  8037c6:	5f                   	pop    %edi
  8037c7:	5d                   	pop    %ebp
  8037c8:	c3                   	ret    
  8037c9:	8d 76 00             	lea    0x0(%esi),%esi
  8037cc:	2b 04 24             	sub    (%esp),%eax
  8037cf:	19 fa                	sbb    %edi,%edx
  8037d1:	89 d1                	mov    %edx,%ecx
  8037d3:	89 c6                	mov    %eax,%esi
  8037d5:	e9 71 ff ff ff       	jmp    80374b <__umoddi3+0xb3>
  8037da:	66 90                	xchg   %ax,%ax
  8037dc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8037e0:	72 ea                	jb     8037cc <__umoddi3+0x134>
  8037e2:	89 d9                	mov    %ebx,%ecx
  8037e4:	e9 62 ff ff ff       	jmp    80374b <__umoddi3+0xb3>
