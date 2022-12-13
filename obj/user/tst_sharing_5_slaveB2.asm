
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
  80008c:	68 40 37 80 00       	push   $0x803740
  800091:	6a 12                	push   $0x12
  800093:	68 5c 37 80 00       	push   $0x80375c
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
  8000aa:	e8 a3 1a 00 00       	call   801b52 <sys_getparentenvid>
  8000af:	83 ec 08             	sub    $0x8,%esp
  8000b2:	68 79 37 80 00       	push   $0x803779
  8000b7:	50                   	push   %eax
  8000b8:	e8 78 15 00 00       	call   801635 <sget>
  8000bd:	83 c4 10             	add    $0x10,%esp
  8000c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("Slave B2 env used z (getSharedObject)\n");
  8000c3:	83 ec 0c             	sub    $0xc,%esp
  8000c6:	68 7c 37 80 00       	push   $0x80377c
  8000cb:	e8 9a 04 00 00       	call   80056a <cprintf>
  8000d0:	83 c4 10             	add    $0x10,%esp
	//To indicate that it's successfully got z
	inctst();
  8000d3:	e8 9f 1b 00 00       	call   801c77 <inctst>

	cprintf("Slave B2 please be patient ...\n");
  8000d8:	83 ec 0c             	sub    $0xc,%esp
  8000db:	68 a4 37 80 00       	push   $0x8037a4
  8000e0:	e8 85 04 00 00       	call   80056a <cprintf>
  8000e5:	83 c4 10             	add    $0x10,%esp

	//sleep a while to allow the master to remove x & z
	env_sleep(9000);
  8000e8:	83 ec 0c             	sub    $0xc,%esp
  8000eb:	68 28 23 00 00       	push   $0x2328
  8000f0:	e8 26 33 00 00       	call   80341b <env_sleep>
  8000f5:	83 c4 10             	add    $0x10,%esp
	//to ensure that the other environments completed successfully
	while (gettst()!=2) ;// panic("test failed");
  8000f8:	90                   	nop
  8000f9:	e8 93 1b 00 00       	call   801c91 <gettst>
  8000fe:	83 f8 02             	cmp    $0x2,%eax
  800101:	75 f6                	jne    8000f9 <_main+0xc1>

	int freeFrames = sys_calculate_free_frames() ;
  800103:	e8 51 17 00 00       	call   801859 <sys_calculate_free_frames>
  800108:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sfree(z);
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	ff 75 ec             	pushl  -0x14(%ebp)
  800111:	e8 e3 15 00 00       	call   8016f9 <sfree>
  800116:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave B2 env removed z\n");
  800119:	83 ec 0c             	sub    $0xc,%esp
  80011c:	68 c4 37 80 00       	push   $0x8037c4
  800121:	e8 44 04 00 00       	call   80056a <cprintf>
  800126:	83 c4 10             	add    $0x10,%esp
	int expected = (1+1) + (1+1);
  800129:	c7 45 e4 04 00 00 00 	movl   $0x4,-0x1c(%ebp)
	if ((sys_calculate_free_frames() - freeFrames) !=  expected) panic("wrong free: frames removed not equal 4 !, correct frames to be removed are 4:\nfrom the env: 1 table + 1 frame for z\nframes_storage of z: should be cleared now\n");
  800130:	e8 24 17 00 00       	call   801859 <sys_calculate_free_frames>
  800135:	89 c2                	mov    %eax,%edx
  800137:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80013a:	29 c2                	sub    %eax,%edx
  80013c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80013f:	39 c2                	cmp    %eax,%edx
  800141:	74 14                	je     800157 <_main+0x11f>
  800143:	83 ec 04             	sub    $0x4,%esp
  800146:	68 dc 37 80 00       	push   $0x8037dc
  80014b:	6a 2a                	push   $0x2a
  80014d:	68 5c 37 80 00       	push   $0x80375c
  800152:	e8 5f 01 00 00       	call   8002b6 <_panic>


	cprintf("Step B completed successfully!!\n\n\n");
  800157:	83 ec 0c             	sub    $0xc,%esp
  80015a:	68 7c 38 80 00       	push   $0x80387c
  80015f:	e8 06 04 00 00       	call   80056a <cprintf>
  800164:	83 c4 10             	add    $0x10,%esp
	cprintf("Congratulations!! Test of freeSharedObjects [5] completed successfully!!\n\n\n");
  800167:	83 ec 0c             	sub    $0xc,%esp
  80016a:	68 a0 38 80 00       	push   $0x8038a0
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
  800180:	e8 b4 19 00 00       	call   801b39 <sys_getenvindex>
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
  8001eb:	e8 56 17 00 00       	call   801946 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001f0:	83 ec 0c             	sub    $0xc,%esp
  8001f3:	68 04 39 80 00       	push   $0x803904
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
  80021b:	68 2c 39 80 00       	push   $0x80392c
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
  80024c:	68 54 39 80 00       	push   $0x803954
  800251:	e8 14 03 00 00       	call   80056a <cprintf>
  800256:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800259:	a1 20 50 80 00       	mov    0x805020,%eax
  80025e:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800264:	83 ec 08             	sub    $0x8,%esp
  800267:	50                   	push   %eax
  800268:	68 ac 39 80 00       	push   $0x8039ac
  80026d:	e8 f8 02 00 00       	call   80056a <cprintf>
  800272:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800275:	83 ec 0c             	sub    $0xc,%esp
  800278:	68 04 39 80 00       	push   $0x803904
  80027d:	e8 e8 02 00 00       	call   80056a <cprintf>
  800282:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800285:	e8 d6 16 00 00       	call   801960 <sys_enable_interrupt>

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
  80029d:	e8 63 18 00 00       	call   801b05 <sys_destroy_env>
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
  8002ae:	e8 b8 18 00 00       	call   801b6b <sys_exit_env>
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
  8002d7:	68 c0 39 80 00       	push   $0x8039c0
  8002dc:	e8 89 02 00 00       	call   80056a <cprintf>
  8002e1:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002e4:	a1 00 50 80 00       	mov    0x805000,%eax
  8002e9:	ff 75 0c             	pushl  0xc(%ebp)
  8002ec:	ff 75 08             	pushl  0x8(%ebp)
  8002ef:	50                   	push   %eax
  8002f0:	68 c5 39 80 00       	push   $0x8039c5
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
  800314:	68 e1 39 80 00       	push   $0x8039e1
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
  800340:	68 e4 39 80 00       	push   $0x8039e4
  800345:	6a 26                	push   $0x26
  800347:	68 30 3a 80 00       	push   $0x803a30
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
  800412:	68 3c 3a 80 00       	push   $0x803a3c
  800417:	6a 3a                	push   $0x3a
  800419:	68 30 3a 80 00       	push   $0x803a30
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
  800482:	68 90 3a 80 00       	push   $0x803a90
  800487:	6a 44                	push   $0x44
  800489:	68 30 3a 80 00       	push   $0x803a30
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
  8004dc:	e8 b7 12 00 00       	call   801798 <sys_cputs>
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
  800553:	e8 40 12 00 00       	call   801798 <sys_cputs>
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
  80059d:	e8 a4 13 00 00       	call   801946 <sys_disable_interrupt>
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
  8005bd:	e8 9e 13 00 00       	call   801960 <sys_enable_interrupt>
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
  800607:	e8 c4 2e 00 00       	call   8034d0 <__udivdi3>
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
  800657:	e8 84 2f 00 00       	call   8035e0 <__umoddi3>
  80065c:	83 c4 10             	add    $0x10,%esp
  80065f:	05 f4 3c 80 00       	add    $0x803cf4,%eax
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
  8007b2:	8b 04 85 18 3d 80 00 	mov    0x803d18(,%eax,4),%eax
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
  800893:	8b 34 9d 60 3b 80 00 	mov    0x803b60(,%ebx,4),%esi
  80089a:	85 f6                	test   %esi,%esi
  80089c:	75 19                	jne    8008b7 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80089e:	53                   	push   %ebx
  80089f:	68 05 3d 80 00       	push   $0x803d05
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
  8008b8:	68 0e 3d 80 00       	push   $0x803d0e
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
  8008e5:	be 11 3d 80 00       	mov    $0x803d11,%esi
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
  80130b:	68 70 3e 80 00       	push   $0x803e70
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
  8013db:	e8 fc 04 00 00       	call   8018dc <sys_allocate_chunk>
  8013e0:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013e3:	a1 20 51 80 00       	mov    0x805120,%eax
  8013e8:	83 ec 0c             	sub    $0xc,%esp
  8013eb:	50                   	push   %eax
  8013ec:	e8 71 0b 00 00       	call   801f62 <initialize_MemBlocksList>
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
  801419:	68 95 3e 80 00       	push   $0x803e95
  80141e:	6a 33                	push   $0x33
  801420:	68 b3 3e 80 00       	push   $0x803eb3
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
  801498:	68 c0 3e 80 00       	push   $0x803ec0
  80149d:	6a 34                	push   $0x34
  80149f:	68 b3 3e 80 00       	push   $0x803eb3
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
  801530:	e8 75 07 00 00       	call   801caa <sys_isUHeapPlacementStrategyFIRSTFIT>
  801535:	85 c0                	test   %eax,%eax
  801537:	74 11                	je     80154a <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801539:	83 ec 0c             	sub    $0xc,%esp
  80153c:	ff 75 e8             	pushl  -0x18(%ebp)
  80153f:	e8 e0 0d 00 00       	call   802324 <alloc_block_FF>
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
  801556:	e8 3c 0b 00 00       	call   802097 <insert_sorted_allocList>
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
  801570:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801573:	83 ec 04             	sub    $0x4,%esp
  801576:	68 e4 3e 80 00       	push   $0x803ee4
  80157b:	6a 6f                	push   $0x6f
  80157d:	68 b3 3e 80 00       	push   $0x803eb3
  801582:	e8 2f ed ff ff       	call   8002b6 <_panic>

00801587 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801587:	55                   	push   %ebp
  801588:	89 e5                	mov    %esp,%ebp
  80158a:	83 ec 38             	sub    $0x38,%esp
  80158d:	8b 45 10             	mov    0x10(%ebp),%eax
  801590:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801593:	e8 5c fd ff ff       	call   8012f4 <InitializeUHeap>
	if (size == 0) return NULL ;
  801598:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80159c:	75 0a                	jne    8015a8 <smalloc+0x21>
  80159e:	b8 00 00 00 00       	mov    $0x0,%eax
  8015a3:	e9 8b 00 00 00       	jmp    801633 <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  8015a8:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8015af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015b5:	01 d0                	add    %edx,%eax
  8015b7:	48                   	dec    %eax
  8015b8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8015bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015be:	ba 00 00 00 00       	mov    $0x0,%edx
  8015c3:	f7 75 f0             	divl   -0x10(%ebp)
  8015c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015c9:	29 d0                	sub    %edx,%eax
  8015cb:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  8015ce:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8015d5:	e8 d0 06 00 00       	call   801caa <sys_isUHeapPlacementStrategyFIRSTFIT>
  8015da:	85 c0                	test   %eax,%eax
  8015dc:	74 11                	je     8015ef <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  8015de:	83 ec 0c             	sub    $0xc,%esp
  8015e1:	ff 75 e8             	pushl  -0x18(%ebp)
  8015e4:	e8 3b 0d 00 00       	call   802324 <alloc_block_FF>
  8015e9:	83 c4 10             	add    $0x10,%esp
  8015ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  8015ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8015f3:	74 39                	je     80162e <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8015f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015f8:	8b 40 08             	mov    0x8(%eax),%eax
  8015fb:	89 c2                	mov    %eax,%edx
  8015fd:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801601:	52                   	push   %edx
  801602:	50                   	push   %eax
  801603:	ff 75 0c             	pushl  0xc(%ebp)
  801606:	ff 75 08             	pushl  0x8(%ebp)
  801609:	e8 21 04 00 00       	call   801a2f <sys_createSharedObject>
  80160e:	83 c4 10             	add    $0x10,%esp
  801611:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  801614:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  801618:	74 14                	je     80162e <smalloc+0xa7>
  80161a:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  80161e:	74 0e                	je     80162e <smalloc+0xa7>
  801620:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  801624:	74 08                	je     80162e <smalloc+0xa7>
			return (void*) mem_block->sva;
  801626:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801629:	8b 40 08             	mov    0x8(%eax),%eax
  80162c:	eb 05                	jmp    801633 <smalloc+0xac>
	}
	return NULL;
  80162e:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801633:	c9                   	leave  
  801634:	c3                   	ret    

00801635 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801635:	55                   	push   %ebp
  801636:	89 e5                	mov    %esp,%ebp
  801638:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80163b:	e8 b4 fc ff ff       	call   8012f4 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801640:	83 ec 08             	sub    $0x8,%esp
  801643:	ff 75 0c             	pushl  0xc(%ebp)
  801646:	ff 75 08             	pushl  0x8(%ebp)
  801649:	e8 0b 04 00 00       	call   801a59 <sys_getSizeOfSharedObject>
  80164e:	83 c4 10             	add    $0x10,%esp
  801651:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  801654:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  801658:	74 76                	je     8016d0 <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  80165a:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801661:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801664:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801667:	01 d0                	add    %edx,%eax
  801669:	48                   	dec    %eax
  80166a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80166d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801670:	ba 00 00 00 00       	mov    $0x0,%edx
  801675:	f7 75 ec             	divl   -0x14(%ebp)
  801678:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80167b:	29 d0                	sub    %edx,%eax
  80167d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  801680:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801687:	e8 1e 06 00 00       	call   801caa <sys_isUHeapPlacementStrategyFIRSTFIT>
  80168c:	85 c0                	test   %eax,%eax
  80168e:	74 11                	je     8016a1 <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  801690:	83 ec 0c             	sub    $0xc,%esp
  801693:	ff 75 e4             	pushl  -0x1c(%ebp)
  801696:	e8 89 0c 00 00       	call   802324 <alloc_block_FF>
  80169b:	83 c4 10             	add    $0x10,%esp
  80169e:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  8016a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8016a5:	74 29                	je     8016d0 <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  8016a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016aa:	8b 40 08             	mov    0x8(%eax),%eax
  8016ad:	83 ec 04             	sub    $0x4,%esp
  8016b0:	50                   	push   %eax
  8016b1:	ff 75 0c             	pushl  0xc(%ebp)
  8016b4:	ff 75 08             	pushl  0x8(%ebp)
  8016b7:	e8 ba 03 00 00       	call   801a76 <sys_getSharedObject>
  8016bc:	83 c4 10             	add    $0x10,%esp
  8016bf:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  8016c2:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  8016c6:	74 08                	je     8016d0 <sget+0x9b>
				return (void *)mem_block->sva;
  8016c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016cb:	8b 40 08             	mov    0x8(%eax),%eax
  8016ce:	eb 05                	jmp    8016d5 <sget+0xa0>
		}
	}
	return (void *)NULL;
  8016d0:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8016d5:	c9                   	leave  
  8016d6:	c3                   	ret    

008016d7 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8016d7:	55                   	push   %ebp
  8016d8:	89 e5                	mov    %esp,%ebp
  8016da:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016dd:	e8 12 fc ff ff       	call   8012f4 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8016e2:	83 ec 04             	sub    $0x4,%esp
  8016e5:	68 08 3f 80 00       	push   $0x803f08
  8016ea:	68 f1 00 00 00       	push   $0xf1
  8016ef:	68 b3 3e 80 00       	push   $0x803eb3
  8016f4:	e8 bd eb ff ff       	call   8002b6 <_panic>

008016f9 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8016f9:	55                   	push   %ebp
  8016fa:	89 e5                	mov    %esp,%ebp
  8016fc:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8016ff:	83 ec 04             	sub    $0x4,%esp
  801702:	68 30 3f 80 00       	push   $0x803f30
  801707:	68 05 01 00 00       	push   $0x105
  80170c:	68 b3 3e 80 00       	push   $0x803eb3
  801711:	e8 a0 eb ff ff       	call   8002b6 <_panic>

00801716 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801716:	55                   	push   %ebp
  801717:	89 e5                	mov    %esp,%ebp
  801719:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80171c:	83 ec 04             	sub    $0x4,%esp
  80171f:	68 54 3f 80 00       	push   $0x803f54
  801724:	68 10 01 00 00       	push   $0x110
  801729:	68 b3 3e 80 00       	push   $0x803eb3
  80172e:	e8 83 eb ff ff       	call   8002b6 <_panic>

00801733 <shrink>:

}
void shrink(uint32 newSize)
{
  801733:	55                   	push   %ebp
  801734:	89 e5                	mov    %esp,%ebp
  801736:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801739:	83 ec 04             	sub    $0x4,%esp
  80173c:	68 54 3f 80 00       	push   $0x803f54
  801741:	68 15 01 00 00       	push   $0x115
  801746:	68 b3 3e 80 00       	push   $0x803eb3
  80174b:	e8 66 eb ff ff       	call   8002b6 <_panic>

00801750 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801750:	55                   	push   %ebp
  801751:	89 e5                	mov    %esp,%ebp
  801753:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801756:	83 ec 04             	sub    $0x4,%esp
  801759:	68 54 3f 80 00       	push   $0x803f54
  80175e:	68 1a 01 00 00       	push   $0x11a
  801763:	68 b3 3e 80 00       	push   $0x803eb3
  801768:	e8 49 eb ff ff       	call   8002b6 <_panic>

0080176d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80176d:	55                   	push   %ebp
  80176e:	89 e5                	mov    %esp,%ebp
  801770:	57                   	push   %edi
  801771:	56                   	push   %esi
  801772:	53                   	push   %ebx
  801773:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801776:	8b 45 08             	mov    0x8(%ebp),%eax
  801779:	8b 55 0c             	mov    0xc(%ebp),%edx
  80177c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80177f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801782:	8b 7d 18             	mov    0x18(%ebp),%edi
  801785:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801788:	cd 30                	int    $0x30
  80178a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80178d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801790:	83 c4 10             	add    $0x10,%esp
  801793:	5b                   	pop    %ebx
  801794:	5e                   	pop    %esi
  801795:	5f                   	pop    %edi
  801796:	5d                   	pop    %ebp
  801797:	c3                   	ret    

00801798 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801798:	55                   	push   %ebp
  801799:	89 e5                	mov    %esp,%ebp
  80179b:	83 ec 04             	sub    $0x4,%esp
  80179e:	8b 45 10             	mov    0x10(%ebp),%eax
  8017a1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8017a4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ab:	6a 00                	push   $0x0
  8017ad:	6a 00                	push   $0x0
  8017af:	52                   	push   %edx
  8017b0:	ff 75 0c             	pushl  0xc(%ebp)
  8017b3:	50                   	push   %eax
  8017b4:	6a 00                	push   $0x0
  8017b6:	e8 b2 ff ff ff       	call   80176d <syscall>
  8017bb:	83 c4 18             	add    $0x18,%esp
}
  8017be:	90                   	nop
  8017bf:	c9                   	leave  
  8017c0:	c3                   	ret    

008017c1 <sys_cgetc>:

int
sys_cgetc(void)
{
  8017c1:	55                   	push   %ebp
  8017c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8017c4:	6a 00                	push   $0x0
  8017c6:	6a 00                	push   $0x0
  8017c8:	6a 00                	push   $0x0
  8017ca:	6a 00                	push   $0x0
  8017cc:	6a 00                	push   $0x0
  8017ce:	6a 01                	push   $0x1
  8017d0:	e8 98 ff ff ff       	call   80176d <syscall>
  8017d5:	83 c4 18             	add    $0x18,%esp
}
  8017d8:	c9                   	leave  
  8017d9:	c3                   	ret    

008017da <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8017da:	55                   	push   %ebp
  8017db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8017dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e3:	6a 00                	push   $0x0
  8017e5:	6a 00                	push   $0x0
  8017e7:	6a 00                	push   $0x0
  8017e9:	52                   	push   %edx
  8017ea:	50                   	push   %eax
  8017eb:	6a 05                	push   $0x5
  8017ed:	e8 7b ff ff ff       	call   80176d <syscall>
  8017f2:	83 c4 18             	add    $0x18,%esp
}
  8017f5:	c9                   	leave  
  8017f6:	c3                   	ret    

008017f7 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8017f7:	55                   	push   %ebp
  8017f8:	89 e5                	mov    %esp,%ebp
  8017fa:	56                   	push   %esi
  8017fb:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8017fc:	8b 75 18             	mov    0x18(%ebp),%esi
  8017ff:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801802:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801805:	8b 55 0c             	mov    0xc(%ebp),%edx
  801808:	8b 45 08             	mov    0x8(%ebp),%eax
  80180b:	56                   	push   %esi
  80180c:	53                   	push   %ebx
  80180d:	51                   	push   %ecx
  80180e:	52                   	push   %edx
  80180f:	50                   	push   %eax
  801810:	6a 06                	push   $0x6
  801812:	e8 56 ff ff ff       	call   80176d <syscall>
  801817:	83 c4 18             	add    $0x18,%esp
}
  80181a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80181d:	5b                   	pop    %ebx
  80181e:	5e                   	pop    %esi
  80181f:	5d                   	pop    %ebp
  801820:	c3                   	ret    

00801821 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801821:	55                   	push   %ebp
  801822:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801824:	8b 55 0c             	mov    0xc(%ebp),%edx
  801827:	8b 45 08             	mov    0x8(%ebp),%eax
  80182a:	6a 00                	push   $0x0
  80182c:	6a 00                	push   $0x0
  80182e:	6a 00                	push   $0x0
  801830:	52                   	push   %edx
  801831:	50                   	push   %eax
  801832:	6a 07                	push   $0x7
  801834:	e8 34 ff ff ff       	call   80176d <syscall>
  801839:	83 c4 18             	add    $0x18,%esp
}
  80183c:	c9                   	leave  
  80183d:	c3                   	ret    

0080183e <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80183e:	55                   	push   %ebp
  80183f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801841:	6a 00                	push   $0x0
  801843:	6a 00                	push   $0x0
  801845:	6a 00                	push   $0x0
  801847:	ff 75 0c             	pushl  0xc(%ebp)
  80184a:	ff 75 08             	pushl  0x8(%ebp)
  80184d:	6a 08                	push   $0x8
  80184f:	e8 19 ff ff ff       	call   80176d <syscall>
  801854:	83 c4 18             	add    $0x18,%esp
}
  801857:	c9                   	leave  
  801858:	c3                   	ret    

00801859 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801859:	55                   	push   %ebp
  80185a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80185c:	6a 00                	push   $0x0
  80185e:	6a 00                	push   $0x0
  801860:	6a 00                	push   $0x0
  801862:	6a 00                	push   $0x0
  801864:	6a 00                	push   $0x0
  801866:	6a 09                	push   $0x9
  801868:	e8 00 ff ff ff       	call   80176d <syscall>
  80186d:	83 c4 18             	add    $0x18,%esp
}
  801870:	c9                   	leave  
  801871:	c3                   	ret    

00801872 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801872:	55                   	push   %ebp
  801873:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	6a 00                	push   $0x0
  80187b:	6a 00                	push   $0x0
  80187d:	6a 00                	push   $0x0
  80187f:	6a 0a                	push   $0xa
  801881:	e8 e7 fe ff ff       	call   80176d <syscall>
  801886:	83 c4 18             	add    $0x18,%esp
}
  801889:	c9                   	leave  
  80188a:	c3                   	ret    

0080188b <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80188b:	55                   	push   %ebp
  80188c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80188e:	6a 00                	push   $0x0
  801890:	6a 00                	push   $0x0
  801892:	6a 00                	push   $0x0
  801894:	6a 00                	push   $0x0
  801896:	6a 00                	push   $0x0
  801898:	6a 0b                	push   $0xb
  80189a:	e8 ce fe ff ff       	call   80176d <syscall>
  80189f:	83 c4 18             	add    $0x18,%esp
}
  8018a2:	c9                   	leave  
  8018a3:	c3                   	ret    

008018a4 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8018a4:	55                   	push   %ebp
  8018a5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8018a7:	6a 00                	push   $0x0
  8018a9:	6a 00                	push   $0x0
  8018ab:	6a 00                	push   $0x0
  8018ad:	ff 75 0c             	pushl  0xc(%ebp)
  8018b0:	ff 75 08             	pushl  0x8(%ebp)
  8018b3:	6a 0f                	push   $0xf
  8018b5:	e8 b3 fe ff ff       	call   80176d <syscall>
  8018ba:	83 c4 18             	add    $0x18,%esp
	return;
  8018bd:	90                   	nop
}
  8018be:	c9                   	leave  
  8018bf:	c3                   	ret    

008018c0 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8018c0:	55                   	push   %ebp
  8018c1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8018c3:	6a 00                	push   $0x0
  8018c5:	6a 00                	push   $0x0
  8018c7:	6a 00                	push   $0x0
  8018c9:	ff 75 0c             	pushl  0xc(%ebp)
  8018cc:	ff 75 08             	pushl  0x8(%ebp)
  8018cf:	6a 10                	push   $0x10
  8018d1:	e8 97 fe ff ff       	call   80176d <syscall>
  8018d6:	83 c4 18             	add    $0x18,%esp
	return ;
  8018d9:	90                   	nop
}
  8018da:	c9                   	leave  
  8018db:	c3                   	ret    

008018dc <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8018dc:	55                   	push   %ebp
  8018dd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8018df:	6a 00                	push   $0x0
  8018e1:	6a 00                	push   $0x0
  8018e3:	ff 75 10             	pushl  0x10(%ebp)
  8018e6:	ff 75 0c             	pushl  0xc(%ebp)
  8018e9:	ff 75 08             	pushl  0x8(%ebp)
  8018ec:	6a 11                	push   $0x11
  8018ee:	e8 7a fe ff ff       	call   80176d <syscall>
  8018f3:	83 c4 18             	add    $0x18,%esp
	return ;
  8018f6:	90                   	nop
}
  8018f7:	c9                   	leave  
  8018f8:	c3                   	ret    

008018f9 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8018f9:	55                   	push   %ebp
  8018fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 00                	push   $0x0
  801900:	6a 00                	push   $0x0
  801902:	6a 00                	push   $0x0
  801904:	6a 00                	push   $0x0
  801906:	6a 0c                	push   $0xc
  801908:	e8 60 fe ff ff       	call   80176d <syscall>
  80190d:	83 c4 18             	add    $0x18,%esp
}
  801910:	c9                   	leave  
  801911:	c3                   	ret    

00801912 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801912:	55                   	push   %ebp
  801913:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801915:	6a 00                	push   $0x0
  801917:	6a 00                	push   $0x0
  801919:	6a 00                	push   $0x0
  80191b:	6a 00                	push   $0x0
  80191d:	ff 75 08             	pushl  0x8(%ebp)
  801920:	6a 0d                	push   $0xd
  801922:	e8 46 fe ff ff       	call   80176d <syscall>
  801927:	83 c4 18             	add    $0x18,%esp
}
  80192a:	c9                   	leave  
  80192b:	c3                   	ret    

0080192c <sys_scarce_memory>:

void sys_scarce_memory()
{
  80192c:	55                   	push   %ebp
  80192d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80192f:	6a 00                	push   $0x0
  801931:	6a 00                	push   $0x0
  801933:	6a 00                	push   $0x0
  801935:	6a 00                	push   $0x0
  801937:	6a 00                	push   $0x0
  801939:	6a 0e                	push   $0xe
  80193b:	e8 2d fe ff ff       	call   80176d <syscall>
  801940:	83 c4 18             	add    $0x18,%esp
}
  801943:	90                   	nop
  801944:	c9                   	leave  
  801945:	c3                   	ret    

00801946 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801946:	55                   	push   %ebp
  801947:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801949:	6a 00                	push   $0x0
  80194b:	6a 00                	push   $0x0
  80194d:	6a 00                	push   $0x0
  80194f:	6a 00                	push   $0x0
  801951:	6a 00                	push   $0x0
  801953:	6a 13                	push   $0x13
  801955:	e8 13 fe ff ff       	call   80176d <syscall>
  80195a:	83 c4 18             	add    $0x18,%esp
}
  80195d:	90                   	nop
  80195e:	c9                   	leave  
  80195f:	c3                   	ret    

00801960 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801960:	55                   	push   %ebp
  801961:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801963:	6a 00                	push   $0x0
  801965:	6a 00                	push   $0x0
  801967:	6a 00                	push   $0x0
  801969:	6a 00                	push   $0x0
  80196b:	6a 00                	push   $0x0
  80196d:	6a 14                	push   $0x14
  80196f:	e8 f9 fd ff ff       	call   80176d <syscall>
  801974:	83 c4 18             	add    $0x18,%esp
}
  801977:	90                   	nop
  801978:	c9                   	leave  
  801979:	c3                   	ret    

0080197a <sys_cputc>:


void
sys_cputc(const char c)
{
  80197a:	55                   	push   %ebp
  80197b:	89 e5                	mov    %esp,%ebp
  80197d:	83 ec 04             	sub    $0x4,%esp
  801980:	8b 45 08             	mov    0x8(%ebp),%eax
  801983:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801986:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80198a:	6a 00                	push   $0x0
  80198c:	6a 00                	push   $0x0
  80198e:	6a 00                	push   $0x0
  801990:	6a 00                	push   $0x0
  801992:	50                   	push   %eax
  801993:	6a 15                	push   $0x15
  801995:	e8 d3 fd ff ff       	call   80176d <syscall>
  80199a:	83 c4 18             	add    $0x18,%esp
}
  80199d:	90                   	nop
  80199e:	c9                   	leave  
  80199f:	c3                   	ret    

008019a0 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8019a0:	55                   	push   %ebp
  8019a1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 00                	push   $0x0
  8019ab:	6a 00                	push   $0x0
  8019ad:	6a 16                	push   $0x16
  8019af:	e8 b9 fd ff ff       	call   80176d <syscall>
  8019b4:	83 c4 18             	add    $0x18,%esp
}
  8019b7:	90                   	nop
  8019b8:	c9                   	leave  
  8019b9:	c3                   	ret    

008019ba <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8019ba:	55                   	push   %ebp
  8019bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8019bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c0:	6a 00                	push   $0x0
  8019c2:	6a 00                	push   $0x0
  8019c4:	6a 00                	push   $0x0
  8019c6:	ff 75 0c             	pushl  0xc(%ebp)
  8019c9:	50                   	push   %eax
  8019ca:	6a 17                	push   $0x17
  8019cc:	e8 9c fd ff ff       	call   80176d <syscall>
  8019d1:	83 c4 18             	add    $0x18,%esp
}
  8019d4:	c9                   	leave  
  8019d5:	c3                   	ret    

008019d6 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8019d6:	55                   	push   %ebp
  8019d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 00                	push   $0x0
  8019e5:	52                   	push   %edx
  8019e6:	50                   	push   %eax
  8019e7:	6a 1a                	push   $0x1a
  8019e9:	e8 7f fd ff ff       	call   80176d <syscall>
  8019ee:	83 c4 18             	add    $0x18,%esp
}
  8019f1:	c9                   	leave  
  8019f2:	c3                   	ret    

008019f3 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8019f3:	55                   	push   %ebp
  8019f4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fc:	6a 00                	push   $0x0
  8019fe:	6a 00                	push   $0x0
  801a00:	6a 00                	push   $0x0
  801a02:	52                   	push   %edx
  801a03:	50                   	push   %eax
  801a04:	6a 18                	push   $0x18
  801a06:	e8 62 fd ff ff       	call   80176d <syscall>
  801a0b:	83 c4 18             	add    $0x18,%esp
}
  801a0e:	90                   	nop
  801a0f:	c9                   	leave  
  801a10:	c3                   	ret    

00801a11 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a11:	55                   	push   %ebp
  801a12:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a14:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a17:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1a:	6a 00                	push   $0x0
  801a1c:	6a 00                	push   $0x0
  801a1e:	6a 00                	push   $0x0
  801a20:	52                   	push   %edx
  801a21:	50                   	push   %eax
  801a22:	6a 19                	push   $0x19
  801a24:	e8 44 fd ff ff       	call   80176d <syscall>
  801a29:	83 c4 18             	add    $0x18,%esp
}
  801a2c:	90                   	nop
  801a2d:	c9                   	leave  
  801a2e:	c3                   	ret    

00801a2f <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a2f:	55                   	push   %ebp
  801a30:	89 e5                	mov    %esp,%ebp
  801a32:	83 ec 04             	sub    $0x4,%esp
  801a35:	8b 45 10             	mov    0x10(%ebp),%eax
  801a38:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a3b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a3e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a42:	8b 45 08             	mov    0x8(%ebp),%eax
  801a45:	6a 00                	push   $0x0
  801a47:	51                   	push   %ecx
  801a48:	52                   	push   %edx
  801a49:	ff 75 0c             	pushl  0xc(%ebp)
  801a4c:	50                   	push   %eax
  801a4d:	6a 1b                	push   $0x1b
  801a4f:	e8 19 fd ff ff       	call   80176d <syscall>
  801a54:	83 c4 18             	add    $0x18,%esp
}
  801a57:	c9                   	leave  
  801a58:	c3                   	ret    

00801a59 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801a59:	55                   	push   %ebp
  801a5a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a5c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a62:	6a 00                	push   $0x0
  801a64:	6a 00                	push   $0x0
  801a66:	6a 00                	push   $0x0
  801a68:	52                   	push   %edx
  801a69:	50                   	push   %eax
  801a6a:	6a 1c                	push   $0x1c
  801a6c:	e8 fc fc ff ff       	call   80176d <syscall>
  801a71:	83 c4 18             	add    $0x18,%esp
}
  801a74:	c9                   	leave  
  801a75:	c3                   	ret    

00801a76 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801a76:	55                   	push   %ebp
  801a77:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a79:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a7c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a82:	6a 00                	push   $0x0
  801a84:	6a 00                	push   $0x0
  801a86:	51                   	push   %ecx
  801a87:	52                   	push   %edx
  801a88:	50                   	push   %eax
  801a89:	6a 1d                	push   $0x1d
  801a8b:	e8 dd fc ff ff       	call   80176d <syscall>
  801a90:	83 c4 18             	add    $0x18,%esp
}
  801a93:	c9                   	leave  
  801a94:	c3                   	ret    

00801a95 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801a95:	55                   	push   %ebp
  801a96:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a98:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 00                	push   $0x0
  801aa2:	6a 00                	push   $0x0
  801aa4:	52                   	push   %edx
  801aa5:	50                   	push   %eax
  801aa6:	6a 1e                	push   $0x1e
  801aa8:	e8 c0 fc ff ff       	call   80176d <syscall>
  801aad:	83 c4 18             	add    $0x18,%esp
}
  801ab0:	c9                   	leave  
  801ab1:	c3                   	ret    

00801ab2 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801ab2:	55                   	push   %ebp
  801ab3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801ab5:	6a 00                	push   $0x0
  801ab7:	6a 00                	push   $0x0
  801ab9:	6a 00                	push   $0x0
  801abb:	6a 00                	push   $0x0
  801abd:	6a 00                	push   $0x0
  801abf:	6a 1f                	push   $0x1f
  801ac1:	e8 a7 fc ff ff       	call   80176d <syscall>
  801ac6:	83 c4 18             	add    $0x18,%esp
}
  801ac9:	c9                   	leave  
  801aca:	c3                   	ret    

00801acb <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801acb:	55                   	push   %ebp
  801acc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801ace:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad1:	6a 00                	push   $0x0
  801ad3:	ff 75 14             	pushl  0x14(%ebp)
  801ad6:	ff 75 10             	pushl  0x10(%ebp)
  801ad9:	ff 75 0c             	pushl  0xc(%ebp)
  801adc:	50                   	push   %eax
  801add:	6a 20                	push   $0x20
  801adf:	e8 89 fc ff ff       	call   80176d <syscall>
  801ae4:	83 c4 18             	add    $0x18,%esp
}
  801ae7:	c9                   	leave  
  801ae8:	c3                   	ret    

00801ae9 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801ae9:	55                   	push   %ebp
  801aea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801aec:	8b 45 08             	mov    0x8(%ebp),%eax
  801aef:	6a 00                	push   $0x0
  801af1:	6a 00                	push   $0x0
  801af3:	6a 00                	push   $0x0
  801af5:	6a 00                	push   $0x0
  801af7:	50                   	push   %eax
  801af8:	6a 21                	push   $0x21
  801afa:	e8 6e fc ff ff       	call   80176d <syscall>
  801aff:	83 c4 18             	add    $0x18,%esp
}
  801b02:	90                   	nop
  801b03:	c9                   	leave  
  801b04:	c3                   	ret    

00801b05 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b05:	55                   	push   %ebp
  801b06:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b08:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 00                	push   $0x0
  801b13:	50                   	push   %eax
  801b14:	6a 22                	push   $0x22
  801b16:	e8 52 fc ff ff       	call   80176d <syscall>
  801b1b:	83 c4 18             	add    $0x18,%esp
}
  801b1e:	c9                   	leave  
  801b1f:	c3                   	ret    

00801b20 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b20:	55                   	push   %ebp
  801b21:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 02                	push   $0x2
  801b2f:	e8 39 fc ff ff       	call   80176d <syscall>
  801b34:	83 c4 18             	add    $0x18,%esp
}
  801b37:	c9                   	leave  
  801b38:	c3                   	ret    

00801b39 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b39:	55                   	push   %ebp
  801b3a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 00                	push   $0x0
  801b42:	6a 00                	push   $0x0
  801b44:	6a 00                	push   $0x0
  801b46:	6a 03                	push   $0x3
  801b48:	e8 20 fc ff ff       	call   80176d <syscall>
  801b4d:	83 c4 18             	add    $0x18,%esp
}
  801b50:	c9                   	leave  
  801b51:	c3                   	ret    

00801b52 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b52:	55                   	push   %ebp
  801b53:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b55:	6a 00                	push   $0x0
  801b57:	6a 00                	push   $0x0
  801b59:	6a 00                	push   $0x0
  801b5b:	6a 00                	push   $0x0
  801b5d:	6a 00                	push   $0x0
  801b5f:	6a 04                	push   $0x4
  801b61:	e8 07 fc ff ff       	call   80176d <syscall>
  801b66:	83 c4 18             	add    $0x18,%esp
}
  801b69:	c9                   	leave  
  801b6a:	c3                   	ret    

00801b6b <sys_exit_env>:


void sys_exit_env(void)
{
  801b6b:	55                   	push   %ebp
  801b6c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b6e:	6a 00                	push   $0x0
  801b70:	6a 00                	push   $0x0
  801b72:	6a 00                	push   $0x0
  801b74:	6a 00                	push   $0x0
  801b76:	6a 00                	push   $0x0
  801b78:	6a 23                	push   $0x23
  801b7a:	e8 ee fb ff ff       	call   80176d <syscall>
  801b7f:	83 c4 18             	add    $0x18,%esp
}
  801b82:	90                   	nop
  801b83:	c9                   	leave  
  801b84:	c3                   	ret    

00801b85 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801b85:	55                   	push   %ebp
  801b86:	89 e5                	mov    %esp,%ebp
  801b88:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b8b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b8e:	8d 50 04             	lea    0x4(%eax),%edx
  801b91:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b94:	6a 00                	push   $0x0
  801b96:	6a 00                	push   $0x0
  801b98:	6a 00                	push   $0x0
  801b9a:	52                   	push   %edx
  801b9b:	50                   	push   %eax
  801b9c:	6a 24                	push   $0x24
  801b9e:	e8 ca fb ff ff       	call   80176d <syscall>
  801ba3:	83 c4 18             	add    $0x18,%esp
	return result;
  801ba6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ba9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bac:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801baf:	89 01                	mov    %eax,(%ecx)
  801bb1:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb7:	c9                   	leave  
  801bb8:	c2 04 00             	ret    $0x4

00801bbb <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801bbb:	55                   	push   %ebp
  801bbc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801bbe:	6a 00                	push   $0x0
  801bc0:	6a 00                	push   $0x0
  801bc2:	ff 75 10             	pushl  0x10(%ebp)
  801bc5:	ff 75 0c             	pushl  0xc(%ebp)
  801bc8:	ff 75 08             	pushl  0x8(%ebp)
  801bcb:	6a 12                	push   $0x12
  801bcd:	e8 9b fb ff ff       	call   80176d <syscall>
  801bd2:	83 c4 18             	add    $0x18,%esp
	return ;
  801bd5:	90                   	nop
}
  801bd6:	c9                   	leave  
  801bd7:	c3                   	ret    

00801bd8 <sys_rcr2>:
uint32 sys_rcr2()
{
  801bd8:	55                   	push   %ebp
  801bd9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 00                	push   $0x0
  801be3:	6a 00                	push   $0x0
  801be5:	6a 25                	push   $0x25
  801be7:	e8 81 fb ff ff       	call   80176d <syscall>
  801bec:	83 c4 18             	add    $0x18,%esp
}
  801bef:	c9                   	leave  
  801bf0:	c3                   	ret    

00801bf1 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801bf1:	55                   	push   %ebp
  801bf2:	89 e5                	mov    %esp,%ebp
  801bf4:	83 ec 04             	sub    $0x4,%esp
  801bf7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfa:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801bfd:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	50                   	push   %eax
  801c0a:	6a 26                	push   $0x26
  801c0c:	e8 5c fb ff ff       	call   80176d <syscall>
  801c11:	83 c4 18             	add    $0x18,%esp
	return ;
  801c14:	90                   	nop
}
  801c15:	c9                   	leave  
  801c16:	c3                   	ret    

00801c17 <rsttst>:
void rsttst()
{
  801c17:	55                   	push   %ebp
  801c18:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	6a 00                	push   $0x0
  801c24:	6a 28                	push   $0x28
  801c26:	e8 42 fb ff ff       	call   80176d <syscall>
  801c2b:	83 c4 18             	add    $0x18,%esp
	return ;
  801c2e:	90                   	nop
}
  801c2f:	c9                   	leave  
  801c30:	c3                   	ret    

00801c31 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c31:	55                   	push   %ebp
  801c32:	89 e5                	mov    %esp,%ebp
  801c34:	83 ec 04             	sub    $0x4,%esp
  801c37:	8b 45 14             	mov    0x14(%ebp),%eax
  801c3a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c3d:	8b 55 18             	mov    0x18(%ebp),%edx
  801c40:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c44:	52                   	push   %edx
  801c45:	50                   	push   %eax
  801c46:	ff 75 10             	pushl  0x10(%ebp)
  801c49:	ff 75 0c             	pushl  0xc(%ebp)
  801c4c:	ff 75 08             	pushl  0x8(%ebp)
  801c4f:	6a 27                	push   $0x27
  801c51:	e8 17 fb ff ff       	call   80176d <syscall>
  801c56:	83 c4 18             	add    $0x18,%esp
	return ;
  801c59:	90                   	nop
}
  801c5a:	c9                   	leave  
  801c5b:	c3                   	ret    

00801c5c <chktst>:
void chktst(uint32 n)
{
  801c5c:	55                   	push   %ebp
  801c5d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c5f:	6a 00                	push   $0x0
  801c61:	6a 00                	push   $0x0
  801c63:	6a 00                	push   $0x0
  801c65:	6a 00                	push   $0x0
  801c67:	ff 75 08             	pushl  0x8(%ebp)
  801c6a:	6a 29                	push   $0x29
  801c6c:	e8 fc fa ff ff       	call   80176d <syscall>
  801c71:	83 c4 18             	add    $0x18,%esp
	return ;
  801c74:	90                   	nop
}
  801c75:	c9                   	leave  
  801c76:	c3                   	ret    

00801c77 <inctst>:

void inctst()
{
  801c77:	55                   	push   %ebp
  801c78:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c7a:	6a 00                	push   $0x0
  801c7c:	6a 00                	push   $0x0
  801c7e:	6a 00                	push   $0x0
  801c80:	6a 00                	push   $0x0
  801c82:	6a 00                	push   $0x0
  801c84:	6a 2a                	push   $0x2a
  801c86:	e8 e2 fa ff ff       	call   80176d <syscall>
  801c8b:	83 c4 18             	add    $0x18,%esp
	return ;
  801c8e:	90                   	nop
}
  801c8f:	c9                   	leave  
  801c90:	c3                   	ret    

00801c91 <gettst>:
uint32 gettst()
{
  801c91:	55                   	push   %ebp
  801c92:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c94:	6a 00                	push   $0x0
  801c96:	6a 00                	push   $0x0
  801c98:	6a 00                	push   $0x0
  801c9a:	6a 00                	push   $0x0
  801c9c:	6a 00                	push   $0x0
  801c9e:	6a 2b                	push   $0x2b
  801ca0:	e8 c8 fa ff ff       	call   80176d <syscall>
  801ca5:	83 c4 18             	add    $0x18,%esp
}
  801ca8:	c9                   	leave  
  801ca9:	c3                   	ret    

00801caa <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801caa:	55                   	push   %ebp
  801cab:	89 e5                	mov    %esp,%ebp
  801cad:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cb0:	6a 00                	push   $0x0
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 00                	push   $0x0
  801cb6:	6a 00                	push   $0x0
  801cb8:	6a 00                	push   $0x0
  801cba:	6a 2c                	push   $0x2c
  801cbc:	e8 ac fa ff ff       	call   80176d <syscall>
  801cc1:	83 c4 18             	add    $0x18,%esp
  801cc4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801cc7:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801ccb:	75 07                	jne    801cd4 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801ccd:	b8 01 00 00 00       	mov    $0x1,%eax
  801cd2:	eb 05                	jmp    801cd9 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801cd4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cd9:	c9                   	leave  
  801cda:	c3                   	ret    

00801cdb <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801cdb:	55                   	push   %ebp
  801cdc:	89 e5                	mov    %esp,%ebp
  801cde:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 00                	push   $0x0
  801ce5:	6a 00                	push   $0x0
  801ce7:	6a 00                	push   $0x0
  801ce9:	6a 00                	push   $0x0
  801ceb:	6a 2c                	push   $0x2c
  801ced:	e8 7b fa ff ff       	call   80176d <syscall>
  801cf2:	83 c4 18             	add    $0x18,%esp
  801cf5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801cf8:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801cfc:	75 07                	jne    801d05 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801cfe:	b8 01 00 00 00       	mov    $0x1,%eax
  801d03:	eb 05                	jmp    801d0a <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d05:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d0a:	c9                   	leave  
  801d0b:	c3                   	ret    

00801d0c <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d0c:	55                   	push   %ebp
  801d0d:	89 e5                	mov    %esp,%ebp
  801d0f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d12:	6a 00                	push   $0x0
  801d14:	6a 00                	push   $0x0
  801d16:	6a 00                	push   $0x0
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 2c                	push   $0x2c
  801d1e:	e8 4a fa ff ff       	call   80176d <syscall>
  801d23:	83 c4 18             	add    $0x18,%esp
  801d26:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801d29:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d2d:	75 07                	jne    801d36 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801d2f:	b8 01 00 00 00       	mov    $0x1,%eax
  801d34:	eb 05                	jmp    801d3b <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801d36:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d3b:	c9                   	leave  
  801d3c:	c3                   	ret    

00801d3d <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801d3d:	55                   	push   %ebp
  801d3e:	89 e5                	mov    %esp,%ebp
  801d40:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d43:	6a 00                	push   $0x0
  801d45:	6a 00                	push   $0x0
  801d47:	6a 00                	push   $0x0
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 00                	push   $0x0
  801d4d:	6a 2c                	push   $0x2c
  801d4f:	e8 19 fa ff ff       	call   80176d <syscall>
  801d54:	83 c4 18             	add    $0x18,%esp
  801d57:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801d5a:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801d5e:	75 07                	jne    801d67 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801d60:	b8 01 00 00 00       	mov    $0x1,%eax
  801d65:	eb 05                	jmp    801d6c <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801d67:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d6c:	c9                   	leave  
  801d6d:	c3                   	ret    

00801d6e <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801d6e:	55                   	push   %ebp
  801d6f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801d71:	6a 00                	push   $0x0
  801d73:	6a 00                	push   $0x0
  801d75:	6a 00                	push   $0x0
  801d77:	6a 00                	push   $0x0
  801d79:	ff 75 08             	pushl  0x8(%ebp)
  801d7c:	6a 2d                	push   $0x2d
  801d7e:	e8 ea f9 ff ff       	call   80176d <syscall>
  801d83:	83 c4 18             	add    $0x18,%esp
	return ;
  801d86:	90                   	nop
}
  801d87:	c9                   	leave  
  801d88:	c3                   	ret    

00801d89 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801d89:	55                   	push   %ebp
  801d8a:	89 e5                	mov    %esp,%ebp
  801d8c:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801d8d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d90:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d93:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d96:	8b 45 08             	mov    0x8(%ebp),%eax
  801d99:	6a 00                	push   $0x0
  801d9b:	53                   	push   %ebx
  801d9c:	51                   	push   %ecx
  801d9d:	52                   	push   %edx
  801d9e:	50                   	push   %eax
  801d9f:	6a 2e                	push   $0x2e
  801da1:	e8 c7 f9 ff ff       	call   80176d <syscall>
  801da6:	83 c4 18             	add    $0x18,%esp
}
  801da9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dac:	c9                   	leave  
  801dad:	c3                   	ret    

00801dae <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801dae:	55                   	push   %ebp
  801daf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801db1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801db4:	8b 45 08             	mov    0x8(%ebp),%eax
  801db7:	6a 00                	push   $0x0
  801db9:	6a 00                	push   $0x0
  801dbb:	6a 00                	push   $0x0
  801dbd:	52                   	push   %edx
  801dbe:	50                   	push   %eax
  801dbf:	6a 2f                	push   $0x2f
  801dc1:	e8 a7 f9 ff ff       	call   80176d <syscall>
  801dc6:	83 c4 18             	add    $0x18,%esp
}
  801dc9:	c9                   	leave  
  801dca:	c3                   	ret    

00801dcb <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801dcb:	55                   	push   %ebp
  801dcc:	89 e5                	mov    %esp,%ebp
  801dce:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801dd1:	83 ec 0c             	sub    $0xc,%esp
  801dd4:	68 64 3f 80 00       	push   $0x803f64
  801dd9:	e8 8c e7 ff ff       	call   80056a <cprintf>
  801dde:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801de1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801de8:	83 ec 0c             	sub    $0xc,%esp
  801deb:	68 90 3f 80 00       	push   $0x803f90
  801df0:	e8 75 e7 ff ff       	call   80056a <cprintf>
  801df5:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801df8:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801dfc:	a1 38 51 80 00       	mov    0x805138,%eax
  801e01:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e04:	eb 56                	jmp    801e5c <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e06:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e0a:	74 1c                	je     801e28 <print_mem_block_lists+0x5d>
  801e0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e0f:	8b 50 08             	mov    0x8(%eax),%edx
  801e12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e15:	8b 48 08             	mov    0x8(%eax),%ecx
  801e18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e1b:	8b 40 0c             	mov    0xc(%eax),%eax
  801e1e:	01 c8                	add    %ecx,%eax
  801e20:	39 c2                	cmp    %eax,%edx
  801e22:	73 04                	jae    801e28 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801e24:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e2b:	8b 50 08             	mov    0x8(%eax),%edx
  801e2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e31:	8b 40 0c             	mov    0xc(%eax),%eax
  801e34:	01 c2                	add    %eax,%edx
  801e36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e39:	8b 40 08             	mov    0x8(%eax),%eax
  801e3c:	83 ec 04             	sub    $0x4,%esp
  801e3f:	52                   	push   %edx
  801e40:	50                   	push   %eax
  801e41:	68 a5 3f 80 00       	push   $0x803fa5
  801e46:	e8 1f e7 ff ff       	call   80056a <cprintf>
  801e4b:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e51:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e54:	a1 40 51 80 00       	mov    0x805140,%eax
  801e59:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e5c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e60:	74 07                	je     801e69 <print_mem_block_lists+0x9e>
  801e62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e65:	8b 00                	mov    (%eax),%eax
  801e67:	eb 05                	jmp    801e6e <print_mem_block_lists+0xa3>
  801e69:	b8 00 00 00 00       	mov    $0x0,%eax
  801e6e:	a3 40 51 80 00       	mov    %eax,0x805140
  801e73:	a1 40 51 80 00       	mov    0x805140,%eax
  801e78:	85 c0                	test   %eax,%eax
  801e7a:	75 8a                	jne    801e06 <print_mem_block_lists+0x3b>
  801e7c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e80:	75 84                	jne    801e06 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801e82:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e86:	75 10                	jne    801e98 <print_mem_block_lists+0xcd>
  801e88:	83 ec 0c             	sub    $0xc,%esp
  801e8b:	68 b4 3f 80 00       	push   $0x803fb4
  801e90:	e8 d5 e6 ff ff       	call   80056a <cprintf>
  801e95:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801e98:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801e9f:	83 ec 0c             	sub    $0xc,%esp
  801ea2:	68 d8 3f 80 00       	push   $0x803fd8
  801ea7:	e8 be e6 ff ff       	call   80056a <cprintf>
  801eac:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801eaf:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801eb3:	a1 40 50 80 00       	mov    0x805040,%eax
  801eb8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ebb:	eb 56                	jmp    801f13 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801ebd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ec1:	74 1c                	je     801edf <print_mem_block_lists+0x114>
  801ec3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec6:	8b 50 08             	mov    0x8(%eax),%edx
  801ec9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ecc:	8b 48 08             	mov    0x8(%eax),%ecx
  801ecf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ed2:	8b 40 0c             	mov    0xc(%eax),%eax
  801ed5:	01 c8                	add    %ecx,%eax
  801ed7:	39 c2                	cmp    %eax,%edx
  801ed9:	73 04                	jae    801edf <print_mem_block_lists+0x114>
			sorted = 0 ;
  801edb:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801edf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee2:	8b 50 08             	mov    0x8(%eax),%edx
  801ee5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee8:	8b 40 0c             	mov    0xc(%eax),%eax
  801eeb:	01 c2                	add    %eax,%edx
  801eed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef0:	8b 40 08             	mov    0x8(%eax),%eax
  801ef3:	83 ec 04             	sub    $0x4,%esp
  801ef6:	52                   	push   %edx
  801ef7:	50                   	push   %eax
  801ef8:	68 a5 3f 80 00       	push   $0x803fa5
  801efd:	e8 68 e6 ff ff       	call   80056a <cprintf>
  801f02:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f08:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f0b:	a1 48 50 80 00       	mov    0x805048,%eax
  801f10:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f13:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f17:	74 07                	je     801f20 <print_mem_block_lists+0x155>
  801f19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f1c:	8b 00                	mov    (%eax),%eax
  801f1e:	eb 05                	jmp    801f25 <print_mem_block_lists+0x15a>
  801f20:	b8 00 00 00 00       	mov    $0x0,%eax
  801f25:	a3 48 50 80 00       	mov    %eax,0x805048
  801f2a:	a1 48 50 80 00       	mov    0x805048,%eax
  801f2f:	85 c0                	test   %eax,%eax
  801f31:	75 8a                	jne    801ebd <print_mem_block_lists+0xf2>
  801f33:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f37:	75 84                	jne    801ebd <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801f39:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f3d:	75 10                	jne    801f4f <print_mem_block_lists+0x184>
  801f3f:	83 ec 0c             	sub    $0xc,%esp
  801f42:	68 f0 3f 80 00       	push   $0x803ff0
  801f47:	e8 1e e6 ff ff       	call   80056a <cprintf>
  801f4c:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801f4f:	83 ec 0c             	sub    $0xc,%esp
  801f52:	68 64 3f 80 00       	push   $0x803f64
  801f57:	e8 0e e6 ff ff       	call   80056a <cprintf>
  801f5c:	83 c4 10             	add    $0x10,%esp

}
  801f5f:	90                   	nop
  801f60:	c9                   	leave  
  801f61:	c3                   	ret    

00801f62 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801f62:	55                   	push   %ebp
  801f63:	89 e5                	mov    %esp,%ebp
  801f65:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801f68:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  801f6f:	00 00 00 
  801f72:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  801f79:	00 00 00 
  801f7c:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  801f83:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801f86:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801f8d:	e9 9e 00 00 00       	jmp    802030 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801f92:	a1 50 50 80 00       	mov    0x805050,%eax
  801f97:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f9a:	c1 e2 04             	shl    $0x4,%edx
  801f9d:	01 d0                	add    %edx,%eax
  801f9f:	85 c0                	test   %eax,%eax
  801fa1:	75 14                	jne    801fb7 <initialize_MemBlocksList+0x55>
  801fa3:	83 ec 04             	sub    $0x4,%esp
  801fa6:	68 18 40 80 00       	push   $0x804018
  801fab:	6a 46                	push   $0x46
  801fad:	68 3b 40 80 00       	push   $0x80403b
  801fb2:	e8 ff e2 ff ff       	call   8002b6 <_panic>
  801fb7:	a1 50 50 80 00       	mov    0x805050,%eax
  801fbc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fbf:	c1 e2 04             	shl    $0x4,%edx
  801fc2:	01 d0                	add    %edx,%eax
  801fc4:	8b 15 48 51 80 00    	mov    0x805148,%edx
  801fca:	89 10                	mov    %edx,(%eax)
  801fcc:	8b 00                	mov    (%eax),%eax
  801fce:	85 c0                	test   %eax,%eax
  801fd0:	74 18                	je     801fea <initialize_MemBlocksList+0x88>
  801fd2:	a1 48 51 80 00       	mov    0x805148,%eax
  801fd7:	8b 15 50 50 80 00    	mov    0x805050,%edx
  801fdd:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801fe0:	c1 e1 04             	shl    $0x4,%ecx
  801fe3:	01 ca                	add    %ecx,%edx
  801fe5:	89 50 04             	mov    %edx,0x4(%eax)
  801fe8:	eb 12                	jmp    801ffc <initialize_MemBlocksList+0x9a>
  801fea:	a1 50 50 80 00       	mov    0x805050,%eax
  801fef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ff2:	c1 e2 04             	shl    $0x4,%edx
  801ff5:	01 d0                	add    %edx,%eax
  801ff7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801ffc:	a1 50 50 80 00       	mov    0x805050,%eax
  802001:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802004:	c1 e2 04             	shl    $0x4,%edx
  802007:	01 d0                	add    %edx,%eax
  802009:	a3 48 51 80 00       	mov    %eax,0x805148
  80200e:	a1 50 50 80 00       	mov    0x805050,%eax
  802013:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802016:	c1 e2 04             	shl    $0x4,%edx
  802019:	01 d0                	add    %edx,%eax
  80201b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802022:	a1 54 51 80 00       	mov    0x805154,%eax
  802027:	40                   	inc    %eax
  802028:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  80202d:	ff 45 f4             	incl   -0xc(%ebp)
  802030:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802033:	3b 45 08             	cmp    0x8(%ebp),%eax
  802036:	0f 82 56 ff ff ff    	jb     801f92 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  80203c:	90                   	nop
  80203d:	c9                   	leave  
  80203e:	c3                   	ret    

0080203f <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80203f:	55                   	push   %ebp
  802040:	89 e5                	mov    %esp,%ebp
  802042:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802045:	8b 45 08             	mov    0x8(%ebp),%eax
  802048:	8b 00                	mov    (%eax),%eax
  80204a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80204d:	eb 19                	jmp    802068 <find_block+0x29>
	{
		if(va==point->sva)
  80204f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802052:	8b 40 08             	mov    0x8(%eax),%eax
  802055:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802058:	75 05                	jne    80205f <find_block+0x20>
		   return point;
  80205a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80205d:	eb 36                	jmp    802095 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80205f:	8b 45 08             	mov    0x8(%ebp),%eax
  802062:	8b 40 08             	mov    0x8(%eax),%eax
  802065:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802068:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80206c:	74 07                	je     802075 <find_block+0x36>
  80206e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802071:	8b 00                	mov    (%eax),%eax
  802073:	eb 05                	jmp    80207a <find_block+0x3b>
  802075:	b8 00 00 00 00       	mov    $0x0,%eax
  80207a:	8b 55 08             	mov    0x8(%ebp),%edx
  80207d:	89 42 08             	mov    %eax,0x8(%edx)
  802080:	8b 45 08             	mov    0x8(%ebp),%eax
  802083:	8b 40 08             	mov    0x8(%eax),%eax
  802086:	85 c0                	test   %eax,%eax
  802088:	75 c5                	jne    80204f <find_block+0x10>
  80208a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80208e:	75 bf                	jne    80204f <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802090:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802095:	c9                   	leave  
  802096:	c3                   	ret    

00802097 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802097:	55                   	push   %ebp
  802098:	89 e5                	mov    %esp,%ebp
  80209a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  80209d:	a1 40 50 80 00       	mov    0x805040,%eax
  8020a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8020a5:	a1 44 50 80 00       	mov    0x805044,%eax
  8020aa:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8020ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020b0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8020b3:	74 24                	je     8020d9 <insert_sorted_allocList+0x42>
  8020b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b8:	8b 50 08             	mov    0x8(%eax),%edx
  8020bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020be:	8b 40 08             	mov    0x8(%eax),%eax
  8020c1:	39 c2                	cmp    %eax,%edx
  8020c3:	76 14                	jbe    8020d9 <insert_sorted_allocList+0x42>
  8020c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c8:	8b 50 08             	mov    0x8(%eax),%edx
  8020cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020ce:	8b 40 08             	mov    0x8(%eax),%eax
  8020d1:	39 c2                	cmp    %eax,%edx
  8020d3:	0f 82 60 01 00 00    	jb     802239 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8020d9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020dd:	75 65                	jne    802144 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8020df:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020e3:	75 14                	jne    8020f9 <insert_sorted_allocList+0x62>
  8020e5:	83 ec 04             	sub    $0x4,%esp
  8020e8:	68 18 40 80 00       	push   $0x804018
  8020ed:	6a 6b                	push   $0x6b
  8020ef:	68 3b 40 80 00       	push   $0x80403b
  8020f4:	e8 bd e1 ff ff       	call   8002b6 <_panic>
  8020f9:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8020ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802102:	89 10                	mov    %edx,(%eax)
  802104:	8b 45 08             	mov    0x8(%ebp),%eax
  802107:	8b 00                	mov    (%eax),%eax
  802109:	85 c0                	test   %eax,%eax
  80210b:	74 0d                	je     80211a <insert_sorted_allocList+0x83>
  80210d:	a1 40 50 80 00       	mov    0x805040,%eax
  802112:	8b 55 08             	mov    0x8(%ebp),%edx
  802115:	89 50 04             	mov    %edx,0x4(%eax)
  802118:	eb 08                	jmp    802122 <insert_sorted_allocList+0x8b>
  80211a:	8b 45 08             	mov    0x8(%ebp),%eax
  80211d:	a3 44 50 80 00       	mov    %eax,0x805044
  802122:	8b 45 08             	mov    0x8(%ebp),%eax
  802125:	a3 40 50 80 00       	mov    %eax,0x805040
  80212a:	8b 45 08             	mov    0x8(%ebp),%eax
  80212d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802134:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802139:	40                   	inc    %eax
  80213a:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80213f:	e9 dc 01 00 00       	jmp    802320 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802144:	8b 45 08             	mov    0x8(%ebp),%eax
  802147:	8b 50 08             	mov    0x8(%eax),%edx
  80214a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80214d:	8b 40 08             	mov    0x8(%eax),%eax
  802150:	39 c2                	cmp    %eax,%edx
  802152:	77 6c                	ja     8021c0 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802154:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802158:	74 06                	je     802160 <insert_sorted_allocList+0xc9>
  80215a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80215e:	75 14                	jne    802174 <insert_sorted_allocList+0xdd>
  802160:	83 ec 04             	sub    $0x4,%esp
  802163:	68 54 40 80 00       	push   $0x804054
  802168:	6a 6f                	push   $0x6f
  80216a:	68 3b 40 80 00       	push   $0x80403b
  80216f:	e8 42 e1 ff ff       	call   8002b6 <_panic>
  802174:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802177:	8b 50 04             	mov    0x4(%eax),%edx
  80217a:	8b 45 08             	mov    0x8(%ebp),%eax
  80217d:	89 50 04             	mov    %edx,0x4(%eax)
  802180:	8b 45 08             	mov    0x8(%ebp),%eax
  802183:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802186:	89 10                	mov    %edx,(%eax)
  802188:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80218b:	8b 40 04             	mov    0x4(%eax),%eax
  80218e:	85 c0                	test   %eax,%eax
  802190:	74 0d                	je     80219f <insert_sorted_allocList+0x108>
  802192:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802195:	8b 40 04             	mov    0x4(%eax),%eax
  802198:	8b 55 08             	mov    0x8(%ebp),%edx
  80219b:	89 10                	mov    %edx,(%eax)
  80219d:	eb 08                	jmp    8021a7 <insert_sorted_allocList+0x110>
  80219f:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a2:	a3 40 50 80 00       	mov    %eax,0x805040
  8021a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8021ad:	89 50 04             	mov    %edx,0x4(%eax)
  8021b0:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8021b5:	40                   	inc    %eax
  8021b6:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8021bb:	e9 60 01 00 00       	jmp    802320 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8021c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c3:	8b 50 08             	mov    0x8(%eax),%edx
  8021c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021c9:	8b 40 08             	mov    0x8(%eax),%eax
  8021cc:	39 c2                	cmp    %eax,%edx
  8021ce:	0f 82 4c 01 00 00    	jb     802320 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8021d4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021d8:	75 14                	jne    8021ee <insert_sorted_allocList+0x157>
  8021da:	83 ec 04             	sub    $0x4,%esp
  8021dd:	68 8c 40 80 00       	push   $0x80408c
  8021e2:	6a 73                	push   $0x73
  8021e4:	68 3b 40 80 00       	push   $0x80403b
  8021e9:	e8 c8 e0 ff ff       	call   8002b6 <_panic>
  8021ee:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8021f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f7:	89 50 04             	mov    %edx,0x4(%eax)
  8021fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fd:	8b 40 04             	mov    0x4(%eax),%eax
  802200:	85 c0                	test   %eax,%eax
  802202:	74 0c                	je     802210 <insert_sorted_allocList+0x179>
  802204:	a1 44 50 80 00       	mov    0x805044,%eax
  802209:	8b 55 08             	mov    0x8(%ebp),%edx
  80220c:	89 10                	mov    %edx,(%eax)
  80220e:	eb 08                	jmp    802218 <insert_sorted_allocList+0x181>
  802210:	8b 45 08             	mov    0x8(%ebp),%eax
  802213:	a3 40 50 80 00       	mov    %eax,0x805040
  802218:	8b 45 08             	mov    0x8(%ebp),%eax
  80221b:	a3 44 50 80 00       	mov    %eax,0x805044
  802220:	8b 45 08             	mov    0x8(%ebp),%eax
  802223:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802229:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80222e:	40                   	inc    %eax
  80222f:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802234:	e9 e7 00 00 00       	jmp    802320 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802239:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80223c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  80223f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802246:	a1 40 50 80 00       	mov    0x805040,%eax
  80224b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80224e:	e9 9d 00 00 00       	jmp    8022f0 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802253:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802256:	8b 00                	mov    (%eax),%eax
  802258:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  80225b:	8b 45 08             	mov    0x8(%ebp),%eax
  80225e:	8b 50 08             	mov    0x8(%eax),%edx
  802261:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802264:	8b 40 08             	mov    0x8(%eax),%eax
  802267:	39 c2                	cmp    %eax,%edx
  802269:	76 7d                	jbe    8022e8 <insert_sorted_allocList+0x251>
  80226b:	8b 45 08             	mov    0x8(%ebp),%eax
  80226e:	8b 50 08             	mov    0x8(%eax),%edx
  802271:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802274:	8b 40 08             	mov    0x8(%eax),%eax
  802277:	39 c2                	cmp    %eax,%edx
  802279:	73 6d                	jae    8022e8 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  80227b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80227f:	74 06                	je     802287 <insert_sorted_allocList+0x1f0>
  802281:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802285:	75 14                	jne    80229b <insert_sorted_allocList+0x204>
  802287:	83 ec 04             	sub    $0x4,%esp
  80228a:	68 b0 40 80 00       	push   $0x8040b0
  80228f:	6a 7f                	push   $0x7f
  802291:	68 3b 40 80 00       	push   $0x80403b
  802296:	e8 1b e0 ff ff       	call   8002b6 <_panic>
  80229b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229e:	8b 10                	mov    (%eax),%edx
  8022a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a3:	89 10                	mov    %edx,(%eax)
  8022a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a8:	8b 00                	mov    (%eax),%eax
  8022aa:	85 c0                	test   %eax,%eax
  8022ac:	74 0b                	je     8022b9 <insert_sorted_allocList+0x222>
  8022ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b1:	8b 00                	mov    (%eax),%eax
  8022b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8022b6:	89 50 04             	mov    %edx,0x4(%eax)
  8022b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8022bf:	89 10                	mov    %edx,(%eax)
  8022c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022c7:	89 50 04             	mov    %edx,0x4(%eax)
  8022ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cd:	8b 00                	mov    (%eax),%eax
  8022cf:	85 c0                	test   %eax,%eax
  8022d1:	75 08                	jne    8022db <insert_sorted_allocList+0x244>
  8022d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d6:	a3 44 50 80 00       	mov    %eax,0x805044
  8022db:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8022e0:	40                   	inc    %eax
  8022e1:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8022e6:	eb 39                	jmp    802321 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8022e8:	a1 48 50 80 00       	mov    0x805048,%eax
  8022ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022f4:	74 07                	je     8022fd <insert_sorted_allocList+0x266>
  8022f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f9:	8b 00                	mov    (%eax),%eax
  8022fb:	eb 05                	jmp    802302 <insert_sorted_allocList+0x26b>
  8022fd:	b8 00 00 00 00       	mov    $0x0,%eax
  802302:	a3 48 50 80 00       	mov    %eax,0x805048
  802307:	a1 48 50 80 00       	mov    0x805048,%eax
  80230c:	85 c0                	test   %eax,%eax
  80230e:	0f 85 3f ff ff ff    	jne    802253 <insert_sorted_allocList+0x1bc>
  802314:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802318:	0f 85 35 ff ff ff    	jne    802253 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80231e:	eb 01                	jmp    802321 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802320:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802321:	90                   	nop
  802322:	c9                   	leave  
  802323:	c3                   	ret    

00802324 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802324:	55                   	push   %ebp
  802325:	89 e5                	mov    %esp,%ebp
  802327:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80232a:	a1 38 51 80 00       	mov    0x805138,%eax
  80232f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802332:	e9 85 01 00 00       	jmp    8024bc <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802337:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233a:	8b 40 0c             	mov    0xc(%eax),%eax
  80233d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802340:	0f 82 6e 01 00 00    	jb     8024b4 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802346:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802349:	8b 40 0c             	mov    0xc(%eax),%eax
  80234c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80234f:	0f 85 8a 00 00 00    	jne    8023df <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802355:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802359:	75 17                	jne    802372 <alloc_block_FF+0x4e>
  80235b:	83 ec 04             	sub    $0x4,%esp
  80235e:	68 e4 40 80 00       	push   $0x8040e4
  802363:	68 93 00 00 00       	push   $0x93
  802368:	68 3b 40 80 00       	push   $0x80403b
  80236d:	e8 44 df ff ff       	call   8002b6 <_panic>
  802372:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802375:	8b 00                	mov    (%eax),%eax
  802377:	85 c0                	test   %eax,%eax
  802379:	74 10                	je     80238b <alloc_block_FF+0x67>
  80237b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237e:	8b 00                	mov    (%eax),%eax
  802380:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802383:	8b 52 04             	mov    0x4(%edx),%edx
  802386:	89 50 04             	mov    %edx,0x4(%eax)
  802389:	eb 0b                	jmp    802396 <alloc_block_FF+0x72>
  80238b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238e:	8b 40 04             	mov    0x4(%eax),%eax
  802391:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802396:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802399:	8b 40 04             	mov    0x4(%eax),%eax
  80239c:	85 c0                	test   %eax,%eax
  80239e:	74 0f                	je     8023af <alloc_block_FF+0x8b>
  8023a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a3:	8b 40 04             	mov    0x4(%eax),%eax
  8023a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023a9:	8b 12                	mov    (%edx),%edx
  8023ab:	89 10                	mov    %edx,(%eax)
  8023ad:	eb 0a                	jmp    8023b9 <alloc_block_FF+0x95>
  8023af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b2:	8b 00                	mov    (%eax),%eax
  8023b4:	a3 38 51 80 00       	mov    %eax,0x805138
  8023b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023cc:	a1 44 51 80 00       	mov    0x805144,%eax
  8023d1:	48                   	dec    %eax
  8023d2:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  8023d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023da:	e9 10 01 00 00       	jmp    8024ef <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8023df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8023e5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023e8:	0f 86 c6 00 00 00    	jbe    8024b4 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8023ee:	a1 48 51 80 00       	mov    0x805148,%eax
  8023f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8023f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f9:	8b 50 08             	mov    0x8(%eax),%edx
  8023fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ff:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802402:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802405:	8b 55 08             	mov    0x8(%ebp),%edx
  802408:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80240b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80240f:	75 17                	jne    802428 <alloc_block_FF+0x104>
  802411:	83 ec 04             	sub    $0x4,%esp
  802414:	68 e4 40 80 00       	push   $0x8040e4
  802419:	68 9b 00 00 00       	push   $0x9b
  80241e:	68 3b 40 80 00       	push   $0x80403b
  802423:	e8 8e de ff ff       	call   8002b6 <_panic>
  802428:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80242b:	8b 00                	mov    (%eax),%eax
  80242d:	85 c0                	test   %eax,%eax
  80242f:	74 10                	je     802441 <alloc_block_FF+0x11d>
  802431:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802434:	8b 00                	mov    (%eax),%eax
  802436:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802439:	8b 52 04             	mov    0x4(%edx),%edx
  80243c:	89 50 04             	mov    %edx,0x4(%eax)
  80243f:	eb 0b                	jmp    80244c <alloc_block_FF+0x128>
  802441:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802444:	8b 40 04             	mov    0x4(%eax),%eax
  802447:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80244c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80244f:	8b 40 04             	mov    0x4(%eax),%eax
  802452:	85 c0                	test   %eax,%eax
  802454:	74 0f                	je     802465 <alloc_block_FF+0x141>
  802456:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802459:	8b 40 04             	mov    0x4(%eax),%eax
  80245c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80245f:	8b 12                	mov    (%edx),%edx
  802461:	89 10                	mov    %edx,(%eax)
  802463:	eb 0a                	jmp    80246f <alloc_block_FF+0x14b>
  802465:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802468:	8b 00                	mov    (%eax),%eax
  80246a:	a3 48 51 80 00       	mov    %eax,0x805148
  80246f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802472:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802478:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80247b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802482:	a1 54 51 80 00       	mov    0x805154,%eax
  802487:	48                   	dec    %eax
  802488:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  80248d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802490:	8b 50 08             	mov    0x8(%eax),%edx
  802493:	8b 45 08             	mov    0x8(%ebp),%eax
  802496:	01 c2                	add    %eax,%edx
  802498:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249b:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  80249e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a1:	8b 40 0c             	mov    0xc(%eax),%eax
  8024a4:	2b 45 08             	sub    0x8(%ebp),%eax
  8024a7:	89 c2                	mov    %eax,%edx
  8024a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ac:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8024af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024b2:	eb 3b                	jmp    8024ef <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8024b4:	a1 40 51 80 00       	mov    0x805140,%eax
  8024b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024c0:	74 07                	je     8024c9 <alloc_block_FF+0x1a5>
  8024c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c5:	8b 00                	mov    (%eax),%eax
  8024c7:	eb 05                	jmp    8024ce <alloc_block_FF+0x1aa>
  8024c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8024ce:	a3 40 51 80 00       	mov    %eax,0x805140
  8024d3:	a1 40 51 80 00       	mov    0x805140,%eax
  8024d8:	85 c0                	test   %eax,%eax
  8024da:	0f 85 57 fe ff ff    	jne    802337 <alloc_block_FF+0x13>
  8024e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024e4:	0f 85 4d fe ff ff    	jne    802337 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8024ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024ef:	c9                   	leave  
  8024f0:	c3                   	ret    

008024f1 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8024f1:	55                   	push   %ebp
  8024f2:	89 e5                	mov    %esp,%ebp
  8024f4:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8024f7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8024fe:	a1 38 51 80 00       	mov    0x805138,%eax
  802503:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802506:	e9 df 00 00 00       	jmp    8025ea <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  80250b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250e:	8b 40 0c             	mov    0xc(%eax),%eax
  802511:	3b 45 08             	cmp    0x8(%ebp),%eax
  802514:	0f 82 c8 00 00 00    	jb     8025e2 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  80251a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251d:	8b 40 0c             	mov    0xc(%eax),%eax
  802520:	3b 45 08             	cmp    0x8(%ebp),%eax
  802523:	0f 85 8a 00 00 00    	jne    8025b3 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802529:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80252d:	75 17                	jne    802546 <alloc_block_BF+0x55>
  80252f:	83 ec 04             	sub    $0x4,%esp
  802532:	68 e4 40 80 00       	push   $0x8040e4
  802537:	68 b7 00 00 00       	push   $0xb7
  80253c:	68 3b 40 80 00       	push   $0x80403b
  802541:	e8 70 dd ff ff       	call   8002b6 <_panic>
  802546:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802549:	8b 00                	mov    (%eax),%eax
  80254b:	85 c0                	test   %eax,%eax
  80254d:	74 10                	je     80255f <alloc_block_BF+0x6e>
  80254f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802552:	8b 00                	mov    (%eax),%eax
  802554:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802557:	8b 52 04             	mov    0x4(%edx),%edx
  80255a:	89 50 04             	mov    %edx,0x4(%eax)
  80255d:	eb 0b                	jmp    80256a <alloc_block_BF+0x79>
  80255f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802562:	8b 40 04             	mov    0x4(%eax),%eax
  802565:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80256a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256d:	8b 40 04             	mov    0x4(%eax),%eax
  802570:	85 c0                	test   %eax,%eax
  802572:	74 0f                	je     802583 <alloc_block_BF+0x92>
  802574:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802577:	8b 40 04             	mov    0x4(%eax),%eax
  80257a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80257d:	8b 12                	mov    (%edx),%edx
  80257f:	89 10                	mov    %edx,(%eax)
  802581:	eb 0a                	jmp    80258d <alloc_block_BF+0x9c>
  802583:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802586:	8b 00                	mov    (%eax),%eax
  802588:	a3 38 51 80 00       	mov    %eax,0x805138
  80258d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802590:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802596:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802599:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025a0:	a1 44 51 80 00       	mov    0x805144,%eax
  8025a5:	48                   	dec    %eax
  8025a6:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  8025ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ae:	e9 4d 01 00 00       	jmp    802700 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8025b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b6:	8b 40 0c             	mov    0xc(%eax),%eax
  8025b9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025bc:	76 24                	jbe    8025e2 <alloc_block_BF+0xf1>
  8025be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c1:	8b 40 0c             	mov    0xc(%eax),%eax
  8025c4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8025c7:	73 19                	jae    8025e2 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8025c9:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8025d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d3:	8b 40 0c             	mov    0xc(%eax),%eax
  8025d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8025d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025dc:	8b 40 08             	mov    0x8(%eax),%eax
  8025df:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8025e2:	a1 40 51 80 00       	mov    0x805140,%eax
  8025e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025ee:	74 07                	je     8025f7 <alloc_block_BF+0x106>
  8025f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f3:	8b 00                	mov    (%eax),%eax
  8025f5:	eb 05                	jmp    8025fc <alloc_block_BF+0x10b>
  8025f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8025fc:	a3 40 51 80 00       	mov    %eax,0x805140
  802601:	a1 40 51 80 00       	mov    0x805140,%eax
  802606:	85 c0                	test   %eax,%eax
  802608:	0f 85 fd fe ff ff    	jne    80250b <alloc_block_BF+0x1a>
  80260e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802612:	0f 85 f3 fe ff ff    	jne    80250b <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802618:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80261c:	0f 84 d9 00 00 00    	je     8026fb <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802622:	a1 48 51 80 00       	mov    0x805148,%eax
  802627:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  80262a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80262d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802630:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802633:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802636:	8b 55 08             	mov    0x8(%ebp),%edx
  802639:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  80263c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802640:	75 17                	jne    802659 <alloc_block_BF+0x168>
  802642:	83 ec 04             	sub    $0x4,%esp
  802645:	68 e4 40 80 00       	push   $0x8040e4
  80264a:	68 c7 00 00 00       	push   $0xc7
  80264f:	68 3b 40 80 00       	push   $0x80403b
  802654:	e8 5d dc ff ff       	call   8002b6 <_panic>
  802659:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80265c:	8b 00                	mov    (%eax),%eax
  80265e:	85 c0                	test   %eax,%eax
  802660:	74 10                	je     802672 <alloc_block_BF+0x181>
  802662:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802665:	8b 00                	mov    (%eax),%eax
  802667:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80266a:	8b 52 04             	mov    0x4(%edx),%edx
  80266d:	89 50 04             	mov    %edx,0x4(%eax)
  802670:	eb 0b                	jmp    80267d <alloc_block_BF+0x18c>
  802672:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802675:	8b 40 04             	mov    0x4(%eax),%eax
  802678:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80267d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802680:	8b 40 04             	mov    0x4(%eax),%eax
  802683:	85 c0                	test   %eax,%eax
  802685:	74 0f                	je     802696 <alloc_block_BF+0x1a5>
  802687:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80268a:	8b 40 04             	mov    0x4(%eax),%eax
  80268d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802690:	8b 12                	mov    (%edx),%edx
  802692:	89 10                	mov    %edx,(%eax)
  802694:	eb 0a                	jmp    8026a0 <alloc_block_BF+0x1af>
  802696:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802699:	8b 00                	mov    (%eax),%eax
  80269b:	a3 48 51 80 00       	mov    %eax,0x805148
  8026a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026a3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026ac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026b3:	a1 54 51 80 00       	mov    0x805154,%eax
  8026b8:	48                   	dec    %eax
  8026b9:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8026be:	83 ec 08             	sub    $0x8,%esp
  8026c1:	ff 75 ec             	pushl  -0x14(%ebp)
  8026c4:	68 38 51 80 00       	push   $0x805138
  8026c9:	e8 71 f9 ff ff       	call   80203f <find_block>
  8026ce:	83 c4 10             	add    $0x10,%esp
  8026d1:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8026d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026d7:	8b 50 08             	mov    0x8(%eax),%edx
  8026da:	8b 45 08             	mov    0x8(%ebp),%eax
  8026dd:	01 c2                	add    %eax,%edx
  8026df:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026e2:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8026e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026e8:	8b 40 0c             	mov    0xc(%eax),%eax
  8026eb:	2b 45 08             	sub    0x8(%ebp),%eax
  8026ee:	89 c2                	mov    %eax,%edx
  8026f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026f3:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8026f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026f9:	eb 05                	jmp    802700 <alloc_block_BF+0x20f>
	}
	return NULL;
  8026fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802700:	c9                   	leave  
  802701:	c3                   	ret    

00802702 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802702:	55                   	push   %ebp
  802703:	89 e5                	mov    %esp,%ebp
  802705:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802708:	a1 28 50 80 00       	mov    0x805028,%eax
  80270d:	85 c0                	test   %eax,%eax
  80270f:	0f 85 de 01 00 00    	jne    8028f3 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802715:	a1 38 51 80 00       	mov    0x805138,%eax
  80271a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80271d:	e9 9e 01 00 00       	jmp    8028c0 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802722:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802725:	8b 40 0c             	mov    0xc(%eax),%eax
  802728:	3b 45 08             	cmp    0x8(%ebp),%eax
  80272b:	0f 82 87 01 00 00    	jb     8028b8 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802731:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802734:	8b 40 0c             	mov    0xc(%eax),%eax
  802737:	3b 45 08             	cmp    0x8(%ebp),%eax
  80273a:	0f 85 95 00 00 00    	jne    8027d5 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802740:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802744:	75 17                	jne    80275d <alloc_block_NF+0x5b>
  802746:	83 ec 04             	sub    $0x4,%esp
  802749:	68 e4 40 80 00       	push   $0x8040e4
  80274e:	68 e0 00 00 00       	push   $0xe0
  802753:	68 3b 40 80 00       	push   $0x80403b
  802758:	e8 59 db ff ff       	call   8002b6 <_panic>
  80275d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802760:	8b 00                	mov    (%eax),%eax
  802762:	85 c0                	test   %eax,%eax
  802764:	74 10                	je     802776 <alloc_block_NF+0x74>
  802766:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802769:	8b 00                	mov    (%eax),%eax
  80276b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80276e:	8b 52 04             	mov    0x4(%edx),%edx
  802771:	89 50 04             	mov    %edx,0x4(%eax)
  802774:	eb 0b                	jmp    802781 <alloc_block_NF+0x7f>
  802776:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802779:	8b 40 04             	mov    0x4(%eax),%eax
  80277c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802781:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802784:	8b 40 04             	mov    0x4(%eax),%eax
  802787:	85 c0                	test   %eax,%eax
  802789:	74 0f                	je     80279a <alloc_block_NF+0x98>
  80278b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278e:	8b 40 04             	mov    0x4(%eax),%eax
  802791:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802794:	8b 12                	mov    (%edx),%edx
  802796:	89 10                	mov    %edx,(%eax)
  802798:	eb 0a                	jmp    8027a4 <alloc_block_NF+0xa2>
  80279a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279d:	8b 00                	mov    (%eax),%eax
  80279f:	a3 38 51 80 00       	mov    %eax,0x805138
  8027a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027b7:	a1 44 51 80 00       	mov    0x805144,%eax
  8027bc:	48                   	dec    %eax
  8027bd:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  8027c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c5:	8b 40 08             	mov    0x8(%eax),%eax
  8027c8:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  8027cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d0:	e9 f8 04 00 00       	jmp    802ccd <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8027d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d8:	8b 40 0c             	mov    0xc(%eax),%eax
  8027db:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027de:	0f 86 d4 00 00 00    	jbe    8028b8 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8027e4:	a1 48 51 80 00       	mov    0x805148,%eax
  8027e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8027ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ef:	8b 50 08             	mov    0x8(%eax),%edx
  8027f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f5:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8027f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8027fe:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802801:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802805:	75 17                	jne    80281e <alloc_block_NF+0x11c>
  802807:	83 ec 04             	sub    $0x4,%esp
  80280a:	68 e4 40 80 00       	push   $0x8040e4
  80280f:	68 e9 00 00 00       	push   $0xe9
  802814:	68 3b 40 80 00       	push   $0x80403b
  802819:	e8 98 da ff ff       	call   8002b6 <_panic>
  80281e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802821:	8b 00                	mov    (%eax),%eax
  802823:	85 c0                	test   %eax,%eax
  802825:	74 10                	je     802837 <alloc_block_NF+0x135>
  802827:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80282a:	8b 00                	mov    (%eax),%eax
  80282c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80282f:	8b 52 04             	mov    0x4(%edx),%edx
  802832:	89 50 04             	mov    %edx,0x4(%eax)
  802835:	eb 0b                	jmp    802842 <alloc_block_NF+0x140>
  802837:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80283a:	8b 40 04             	mov    0x4(%eax),%eax
  80283d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802842:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802845:	8b 40 04             	mov    0x4(%eax),%eax
  802848:	85 c0                	test   %eax,%eax
  80284a:	74 0f                	je     80285b <alloc_block_NF+0x159>
  80284c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80284f:	8b 40 04             	mov    0x4(%eax),%eax
  802852:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802855:	8b 12                	mov    (%edx),%edx
  802857:	89 10                	mov    %edx,(%eax)
  802859:	eb 0a                	jmp    802865 <alloc_block_NF+0x163>
  80285b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80285e:	8b 00                	mov    (%eax),%eax
  802860:	a3 48 51 80 00       	mov    %eax,0x805148
  802865:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802868:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80286e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802871:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802878:	a1 54 51 80 00       	mov    0x805154,%eax
  80287d:	48                   	dec    %eax
  80287e:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802883:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802886:	8b 40 08             	mov    0x8(%eax),%eax
  802889:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  80288e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802891:	8b 50 08             	mov    0x8(%eax),%edx
  802894:	8b 45 08             	mov    0x8(%ebp),%eax
  802897:	01 c2                	add    %eax,%edx
  802899:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289c:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  80289f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a2:	8b 40 0c             	mov    0xc(%eax),%eax
  8028a5:	2b 45 08             	sub    0x8(%ebp),%eax
  8028a8:	89 c2                	mov    %eax,%edx
  8028aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ad:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8028b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b3:	e9 15 04 00 00       	jmp    802ccd <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8028b8:	a1 40 51 80 00       	mov    0x805140,%eax
  8028bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028c4:	74 07                	je     8028cd <alloc_block_NF+0x1cb>
  8028c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c9:	8b 00                	mov    (%eax),%eax
  8028cb:	eb 05                	jmp    8028d2 <alloc_block_NF+0x1d0>
  8028cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8028d2:	a3 40 51 80 00       	mov    %eax,0x805140
  8028d7:	a1 40 51 80 00       	mov    0x805140,%eax
  8028dc:	85 c0                	test   %eax,%eax
  8028de:	0f 85 3e fe ff ff    	jne    802722 <alloc_block_NF+0x20>
  8028e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028e8:	0f 85 34 fe ff ff    	jne    802722 <alloc_block_NF+0x20>
  8028ee:	e9 d5 03 00 00       	jmp    802cc8 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8028f3:	a1 38 51 80 00       	mov    0x805138,%eax
  8028f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028fb:	e9 b1 01 00 00       	jmp    802ab1 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802900:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802903:	8b 50 08             	mov    0x8(%eax),%edx
  802906:	a1 28 50 80 00       	mov    0x805028,%eax
  80290b:	39 c2                	cmp    %eax,%edx
  80290d:	0f 82 96 01 00 00    	jb     802aa9 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802913:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802916:	8b 40 0c             	mov    0xc(%eax),%eax
  802919:	3b 45 08             	cmp    0x8(%ebp),%eax
  80291c:	0f 82 87 01 00 00    	jb     802aa9 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802922:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802925:	8b 40 0c             	mov    0xc(%eax),%eax
  802928:	3b 45 08             	cmp    0x8(%ebp),%eax
  80292b:	0f 85 95 00 00 00    	jne    8029c6 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802931:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802935:	75 17                	jne    80294e <alloc_block_NF+0x24c>
  802937:	83 ec 04             	sub    $0x4,%esp
  80293a:	68 e4 40 80 00       	push   $0x8040e4
  80293f:	68 fc 00 00 00       	push   $0xfc
  802944:	68 3b 40 80 00       	push   $0x80403b
  802949:	e8 68 d9 ff ff       	call   8002b6 <_panic>
  80294e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802951:	8b 00                	mov    (%eax),%eax
  802953:	85 c0                	test   %eax,%eax
  802955:	74 10                	je     802967 <alloc_block_NF+0x265>
  802957:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295a:	8b 00                	mov    (%eax),%eax
  80295c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80295f:	8b 52 04             	mov    0x4(%edx),%edx
  802962:	89 50 04             	mov    %edx,0x4(%eax)
  802965:	eb 0b                	jmp    802972 <alloc_block_NF+0x270>
  802967:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296a:	8b 40 04             	mov    0x4(%eax),%eax
  80296d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802972:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802975:	8b 40 04             	mov    0x4(%eax),%eax
  802978:	85 c0                	test   %eax,%eax
  80297a:	74 0f                	je     80298b <alloc_block_NF+0x289>
  80297c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297f:	8b 40 04             	mov    0x4(%eax),%eax
  802982:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802985:	8b 12                	mov    (%edx),%edx
  802987:	89 10                	mov    %edx,(%eax)
  802989:	eb 0a                	jmp    802995 <alloc_block_NF+0x293>
  80298b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298e:	8b 00                	mov    (%eax),%eax
  802990:	a3 38 51 80 00       	mov    %eax,0x805138
  802995:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802998:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80299e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029a8:	a1 44 51 80 00       	mov    0x805144,%eax
  8029ad:	48                   	dec    %eax
  8029ae:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8029b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b6:	8b 40 08             	mov    0x8(%eax),%eax
  8029b9:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  8029be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c1:	e9 07 03 00 00       	jmp    802ccd <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8029c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c9:	8b 40 0c             	mov    0xc(%eax),%eax
  8029cc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029cf:	0f 86 d4 00 00 00    	jbe    802aa9 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8029d5:	a1 48 51 80 00       	mov    0x805148,%eax
  8029da:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  8029dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e0:	8b 50 08             	mov    0x8(%eax),%edx
  8029e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029e6:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8029e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8029ef:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8029f2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8029f6:	75 17                	jne    802a0f <alloc_block_NF+0x30d>
  8029f8:	83 ec 04             	sub    $0x4,%esp
  8029fb:	68 e4 40 80 00       	push   $0x8040e4
  802a00:	68 04 01 00 00       	push   $0x104
  802a05:	68 3b 40 80 00       	push   $0x80403b
  802a0a:	e8 a7 d8 ff ff       	call   8002b6 <_panic>
  802a0f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a12:	8b 00                	mov    (%eax),%eax
  802a14:	85 c0                	test   %eax,%eax
  802a16:	74 10                	je     802a28 <alloc_block_NF+0x326>
  802a18:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a1b:	8b 00                	mov    (%eax),%eax
  802a1d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a20:	8b 52 04             	mov    0x4(%edx),%edx
  802a23:	89 50 04             	mov    %edx,0x4(%eax)
  802a26:	eb 0b                	jmp    802a33 <alloc_block_NF+0x331>
  802a28:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a2b:	8b 40 04             	mov    0x4(%eax),%eax
  802a2e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a33:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a36:	8b 40 04             	mov    0x4(%eax),%eax
  802a39:	85 c0                	test   %eax,%eax
  802a3b:	74 0f                	je     802a4c <alloc_block_NF+0x34a>
  802a3d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a40:	8b 40 04             	mov    0x4(%eax),%eax
  802a43:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a46:	8b 12                	mov    (%edx),%edx
  802a48:	89 10                	mov    %edx,(%eax)
  802a4a:	eb 0a                	jmp    802a56 <alloc_block_NF+0x354>
  802a4c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a4f:	8b 00                	mov    (%eax),%eax
  802a51:	a3 48 51 80 00       	mov    %eax,0x805148
  802a56:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a59:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a5f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a62:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a69:	a1 54 51 80 00       	mov    0x805154,%eax
  802a6e:	48                   	dec    %eax
  802a6f:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802a74:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a77:	8b 40 08             	mov    0x8(%eax),%eax
  802a7a:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802a7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a82:	8b 50 08             	mov    0x8(%eax),%edx
  802a85:	8b 45 08             	mov    0x8(%ebp),%eax
  802a88:	01 c2                	add    %eax,%edx
  802a8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8d:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802a90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a93:	8b 40 0c             	mov    0xc(%eax),%eax
  802a96:	2b 45 08             	sub    0x8(%ebp),%eax
  802a99:	89 c2                	mov    %eax,%edx
  802a9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9e:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802aa1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aa4:	e9 24 02 00 00       	jmp    802ccd <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802aa9:	a1 40 51 80 00       	mov    0x805140,%eax
  802aae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ab1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ab5:	74 07                	je     802abe <alloc_block_NF+0x3bc>
  802ab7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aba:	8b 00                	mov    (%eax),%eax
  802abc:	eb 05                	jmp    802ac3 <alloc_block_NF+0x3c1>
  802abe:	b8 00 00 00 00       	mov    $0x0,%eax
  802ac3:	a3 40 51 80 00       	mov    %eax,0x805140
  802ac8:	a1 40 51 80 00       	mov    0x805140,%eax
  802acd:	85 c0                	test   %eax,%eax
  802acf:	0f 85 2b fe ff ff    	jne    802900 <alloc_block_NF+0x1fe>
  802ad5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ad9:	0f 85 21 fe ff ff    	jne    802900 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802adf:	a1 38 51 80 00       	mov    0x805138,%eax
  802ae4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ae7:	e9 ae 01 00 00       	jmp    802c9a <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802aec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aef:	8b 50 08             	mov    0x8(%eax),%edx
  802af2:	a1 28 50 80 00       	mov    0x805028,%eax
  802af7:	39 c2                	cmp    %eax,%edx
  802af9:	0f 83 93 01 00 00    	jae    802c92 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802aff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b02:	8b 40 0c             	mov    0xc(%eax),%eax
  802b05:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b08:	0f 82 84 01 00 00    	jb     802c92 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802b0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b11:	8b 40 0c             	mov    0xc(%eax),%eax
  802b14:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b17:	0f 85 95 00 00 00    	jne    802bb2 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802b1d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b21:	75 17                	jne    802b3a <alloc_block_NF+0x438>
  802b23:	83 ec 04             	sub    $0x4,%esp
  802b26:	68 e4 40 80 00       	push   $0x8040e4
  802b2b:	68 14 01 00 00       	push   $0x114
  802b30:	68 3b 40 80 00       	push   $0x80403b
  802b35:	e8 7c d7 ff ff       	call   8002b6 <_panic>
  802b3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3d:	8b 00                	mov    (%eax),%eax
  802b3f:	85 c0                	test   %eax,%eax
  802b41:	74 10                	je     802b53 <alloc_block_NF+0x451>
  802b43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b46:	8b 00                	mov    (%eax),%eax
  802b48:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b4b:	8b 52 04             	mov    0x4(%edx),%edx
  802b4e:	89 50 04             	mov    %edx,0x4(%eax)
  802b51:	eb 0b                	jmp    802b5e <alloc_block_NF+0x45c>
  802b53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b56:	8b 40 04             	mov    0x4(%eax),%eax
  802b59:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b61:	8b 40 04             	mov    0x4(%eax),%eax
  802b64:	85 c0                	test   %eax,%eax
  802b66:	74 0f                	je     802b77 <alloc_block_NF+0x475>
  802b68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6b:	8b 40 04             	mov    0x4(%eax),%eax
  802b6e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b71:	8b 12                	mov    (%edx),%edx
  802b73:	89 10                	mov    %edx,(%eax)
  802b75:	eb 0a                	jmp    802b81 <alloc_block_NF+0x47f>
  802b77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7a:	8b 00                	mov    (%eax),%eax
  802b7c:	a3 38 51 80 00       	mov    %eax,0x805138
  802b81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b84:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b94:	a1 44 51 80 00       	mov    0x805144,%eax
  802b99:	48                   	dec    %eax
  802b9a:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802b9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba2:	8b 40 08             	mov    0x8(%eax),%eax
  802ba5:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802baa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bad:	e9 1b 01 00 00       	jmp    802ccd <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802bb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb5:	8b 40 0c             	mov    0xc(%eax),%eax
  802bb8:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bbb:	0f 86 d1 00 00 00    	jbe    802c92 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802bc1:	a1 48 51 80 00       	mov    0x805148,%eax
  802bc6:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802bc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcc:	8b 50 08             	mov    0x8(%eax),%edx
  802bcf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bd2:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802bd5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bd8:	8b 55 08             	mov    0x8(%ebp),%edx
  802bdb:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802bde:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802be2:	75 17                	jne    802bfb <alloc_block_NF+0x4f9>
  802be4:	83 ec 04             	sub    $0x4,%esp
  802be7:	68 e4 40 80 00       	push   $0x8040e4
  802bec:	68 1c 01 00 00       	push   $0x11c
  802bf1:	68 3b 40 80 00       	push   $0x80403b
  802bf6:	e8 bb d6 ff ff       	call   8002b6 <_panic>
  802bfb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bfe:	8b 00                	mov    (%eax),%eax
  802c00:	85 c0                	test   %eax,%eax
  802c02:	74 10                	je     802c14 <alloc_block_NF+0x512>
  802c04:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c07:	8b 00                	mov    (%eax),%eax
  802c09:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c0c:	8b 52 04             	mov    0x4(%edx),%edx
  802c0f:	89 50 04             	mov    %edx,0x4(%eax)
  802c12:	eb 0b                	jmp    802c1f <alloc_block_NF+0x51d>
  802c14:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c17:	8b 40 04             	mov    0x4(%eax),%eax
  802c1a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c22:	8b 40 04             	mov    0x4(%eax),%eax
  802c25:	85 c0                	test   %eax,%eax
  802c27:	74 0f                	je     802c38 <alloc_block_NF+0x536>
  802c29:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c2c:	8b 40 04             	mov    0x4(%eax),%eax
  802c2f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c32:	8b 12                	mov    (%edx),%edx
  802c34:	89 10                	mov    %edx,(%eax)
  802c36:	eb 0a                	jmp    802c42 <alloc_block_NF+0x540>
  802c38:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c3b:	8b 00                	mov    (%eax),%eax
  802c3d:	a3 48 51 80 00       	mov    %eax,0x805148
  802c42:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c45:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c4e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c55:	a1 54 51 80 00       	mov    0x805154,%eax
  802c5a:	48                   	dec    %eax
  802c5b:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802c60:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c63:	8b 40 08             	mov    0x8(%eax),%eax
  802c66:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802c6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6e:	8b 50 08             	mov    0x8(%eax),%edx
  802c71:	8b 45 08             	mov    0x8(%ebp),%eax
  802c74:	01 c2                	add    %eax,%edx
  802c76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c79:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802c7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7f:	8b 40 0c             	mov    0xc(%eax),%eax
  802c82:	2b 45 08             	sub    0x8(%ebp),%eax
  802c85:	89 c2                	mov    %eax,%edx
  802c87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8a:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802c8d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c90:	eb 3b                	jmp    802ccd <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c92:	a1 40 51 80 00       	mov    0x805140,%eax
  802c97:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c9a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c9e:	74 07                	je     802ca7 <alloc_block_NF+0x5a5>
  802ca0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca3:	8b 00                	mov    (%eax),%eax
  802ca5:	eb 05                	jmp    802cac <alloc_block_NF+0x5aa>
  802ca7:	b8 00 00 00 00       	mov    $0x0,%eax
  802cac:	a3 40 51 80 00       	mov    %eax,0x805140
  802cb1:	a1 40 51 80 00       	mov    0x805140,%eax
  802cb6:	85 c0                	test   %eax,%eax
  802cb8:	0f 85 2e fe ff ff    	jne    802aec <alloc_block_NF+0x3ea>
  802cbe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cc2:	0f 85 24 fe ff ff    	jne    802aec <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802cc8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ccd:	c9                   	leave  
  802cce:	c3                   	ret    

00802ccf <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802ccf:	55                   	push   %ebp
  802cd0:	89 e5                	mov    %esp,%ebp
  802cd2:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802cd5:	a1 38 51 80 00       	mov    0x805138,%eax
  802cda:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802cdd:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802ce2:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802ce5:	a1 38 51 80 00       	mov    0x805138,%eax
  802cea:	85 c0                	test   %eax,%eax
  802cec:	74 14                	je     802d02 <insert_sorted_with_merge_freeList+0x33>
  802cee:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf1:	8b 50 08             	mov    0x8(%eax),%edx
  802cf4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf7:	8b 40 08             	mov    0x8(%eax),%eax
  802cfa:	39 c2                	cmp    %eax,%edx
  802cfc:	0f 87 9b 01 00 00    	ja     802e9d <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802d02:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d06:	75 17                	jne    802d1f <insert_sorted_with_merge_freeList+0x50>
  802d08:	83 ec 04             	sub    $0x4,%esp
  802d0b:	68 18 40 80 00       	push   $0x804018
  802d10:	68 38 01 00 00       	push   $0x138
  802d15:	68 3b 40 80 00       	push   $0x80403b
  802d1a:	e8 97 d5 ff ff       	call   8002b6 <_panic>
  802d1f:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802d25:	8b 45 08             	mov    0x8(%ebp),%eax
  802d28:	89 10                	mov    %edx,(%eax)
  802d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2d:	8b 00                	mov    (%eax),%eax
  802d2f:	85 c0                	test   %eax,%eax
  802d31:	74 0d                	je     802d40 <insert_sorted_with_merge_freeList+0x71>
  802d33:	a1 38 51 80 00       	mov    0x805138,%eax
  802d38:	8b 55 08             	mov    0x8(%ebp),%edx
  802d3b:	89 50 04             	mov    %edx,0x4(%eax)
  802d3e:	eb 08                	jmp    802d48 <insert_sorted_with_merge_freeList+0x79>
  802d40:	8b 45 08             	mov    0x8(%ebp),%eax
  802d43:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d48:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4b:	a3 38 51 80 00       	mov    %eax,0x805138
  802d50:	8b 45 08             	mov    0x8(%ebp),%eax
  802d53:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d5a:	a1 44 51 80 00       	mov    0x805144,%eax
  802d5f:	40                   	inc    %eax
  802d60:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802d65:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d69:	0f 84 a8 06 00 00    	je     803417 <insert_sorted_with_merge_freeList+0x748>
  802d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d72:	8b 50 08             	mov    0x8(%eax),%edx
  802d75:	8b 45 08             	mov    0x8(%ebp),%eax
  802d78:	8b 40 0c             	mov    0xc(%eax),%eax
  802d7b:	01 c2                	add    %eax,%edx
  802d7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d80:	8b 40 08             	mov    0x8(%eax),%eax
  802d83:	39 c2                	cmp    %eax,%edx
  802d85:	0f 85 8c 06 00 00    	jne    803417 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802d8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8e:	8b 50 0c             	mov    0xc(%eax),%edx
  802d91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d94:	8b 40 0c             	mov    0xc(%eax),%eax
  802d97:	01 c2                	add    %eax,%edx
  802d99:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9c:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802d9f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802da3:	75 17                	jne    802dbc <insert_sorted_with_merge_freeList+0xed>
  802da5:	83 ec 04             	sub    $0x4,%esp
  802da8:	68 e4 40 80 00       	push   $0x8040e4
  802dad:	68 3c 01 00 00       	push   $0x13c
  802db2:	68 3b 40 80 00       	push   $0x80403b
  802db7:	e8 fa d4 ff ff       	call   8002b6 <_panic>
  802dbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dbf:	8b 00                	mov    (%eax),%eax
  802dc1:	85 c0                	test   %eax,%eax
  802dc3:	74 10                	je     802dd5 <insert_sorted_with_merge_freeList+0x106>
  802dc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc8:	8b 00                	mov    (%eax),%eax
  802dca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802dcd:	8b 52 04             	mov    0x4(%edx),%edx
  802dd0:	89 50 04             	mov    %edx,0x4(%eax)
  802dd3:	eb 0b                	jmp    802de0 <insert_sorted_with_merge_freeList+0x111>
  802dd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dd8:	8b 40 04             	mov    0x4(%eax),%eax
  802ddb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802de0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de3:	8b 40 04             	mov    0x4(%eax),%eax
  802de6:	85 c0                	test   %eax,%eax
  802de8:	74 0f                	je     802df9 <insert_sorted_with_merge_freeList+0x12a>
  802dea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ded:	8b 40 04             	mov    0x4(%eax),%eax
  802df0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802df3:	8b 12                	mov    (%edx),%edx
  802df5:	89 10                	mov    %edx,(%eax)
  802df7:	eb 0a                	jmp    802e03 <insert_sorted_with_merge_freeList+0x134>
  802df9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dfc:	8b 00                	mov    (%eax),%eax
  802dfe:	a3 38 51 80 00       	mov    %eax,0x805138
  802e03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e06:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e0f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e16:	a1 44 51 80 00       	mov    0x805144,%eax
  802e1b:	48                   	dec    %eax
  802e1c:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802e21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e24:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802e2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e2e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802e35:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e39:	75 17                	jne    802e52 <insert_sorted_with_merge_freeList+0x183>
  802e3b:	83 ec 04             	sub    $0x4,%esp
  802e3e:	68 18 40 80 00       	push   $0x804018
  802e43:	68 3f 01 00 00       	push   $0x13f
  802e48:	68 3b 40 80 00       	push   $0x80403b
  802e4d:	e8 64 d4 ff ff       	call   8002b6 <_panic>
  802e52:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802e58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e5b:	89 10                	mov    %edx,(%eax)
  802e5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e60:	8b 00                	mov    (%eax),%eax
  802e62:	85 c0                	test   %eax,%eax
  802e64:	74 0d                	je     802e73 <insert_sorted_with_merge_freeList+0x1a4>
  802e66:	a1 48 51 80 00       	mov    0x805148,%eax
  802e6b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e6e:	89 50 04             	mov    %edx,0x4(%eax)
  802e71:	eb 08                	jmp    802e7b <insert_sorted_with_merge_freeList+0x1ac>
  802e73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e76:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e7e:	a3 48 51 80 00       	mov    %eax,0x805148
  802e83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e86:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e8d:	a1 54 51 80 00       	mov    0x805154,%eax
  802e92:	40                   	inc    %eax
  802e93:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802e98:	e9 7a 05 00 00       	jmp    803417 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea0:	8b 50 08             	mov    0x8(%eax),%edx
  802ea3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ea6:	8b 40 08             	mov    0x8(%eax),%eax
  802ea9:	39 c2                	cmp    %eax,%edx
  802eab:	0f 82 14 01 00 00    	jb     802fc5 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802eb1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eb4:	8b 50 08             	mov    0x8(%eax),%edx
  802eb7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eba:	8b 40 0c             	mov    0xc(%eax),%eax
  802ebd:	01 c2                	add    %eax,%edx
  802ebf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec2:	8b 40 08             	mov    0x8(%eax),%eax
  802ec5:	39 c2                	cmp    %eax,%edx
  802ec7:	0f 85 90 00 00 00    	jne    802f5d <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802ecd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ed0:	8b 50 0c             	mov    0xc(%eax),%edx
  802ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed6:	8b 40 0c             	mov    0xc(%eax),%eax
  802ed9:	01 c2                	add    %eax,%edx
  802edb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ede:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802eeb:	8b 45 08             	mov    0x8(%ebp),%eax
  802eee:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802ef5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ef9:	75 17                	jne    802f12 <insert_sorted_with_merge_freeList+0x243>
  802efb:	83 ec 04             	sub    $0x4,%esp
  802efe:	68 18 40 80 00       	push   $0x804018
  802f03:	68 49 01 00 00       	push   $0x149
  802f08:	68 3b 40 80 00       	push   $0x80403b
  802f0d:	e8 a4 d3 ff ff       	call   8002b6 <_panic>
  802f12:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f18:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1b:	89 10                	mov    %edx,(%eax)
  802f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f20:	8b 00                	mov    (%eax),%eax
  802f22:	85 c0                	test   %eax,%eax
  802f24:	74 0d                	je     802f33 <insert_sorted_with_merge_freeList+0x264>
  802f26:	a1 48 51 80 00       	mov    0x805148,%eax
  802f2b:	8b 55 08             	mov    0x8(%ebp),%edx
  802f2e:	89 50 04             	mov    %edx,0x4(%eax)
  802f31:	eb 08                	jmp    802f3b <insert_sorted_with_merge_freeList+0x26c>
  802f33:	8b 45 08             	mov    0x8(%ebp),%eax
  802f36:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3e:	a3 48 51 80 00       	mov    %eax,0x805148
  802f43:	8b 45 08             	mov    0x8(%ebp),%eax
  802f46:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f4d:	a1 54 51 80 00       	mov    0x805154,%eax
  802f52:	40                   	inc    %eax
  802f53:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802f58:	e9 bb 04 00 00       	jmp    803418 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802f5d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f61:	75 17                	jne    802f7a <insert_sorted_with_merge_freeList+0x2ab>
  802f63:	83 ec 04             	sub    $0x4,%esp
  802f66:	68 8c 40 80 00       	push   $0x80408c
  802f6b:	68 4c 01 00 00       	push   $0x14c
  802f70:	68 3b 40 80 00       	push   $0x80403b
  802f75:	e8 3c d3 ff ff       	call   8002b6 <_panic>
  802f7a:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802f80:	8b 45 08             	mov    0x8(%ebp),%eax
  802f83:	89 50 04             	mov    %edx,0x4(%eax)
  802f86:	8b 45 08             	mov    0x8(%ebp),%eax
  802f89:	8b 40 04             	mov    0x4(%eax),%eax
  802f8c:	85 c0                	test   %eax,%eax
  802f8e:	74 0c                	je     802f9c <insert_sorted_with_merge_freeList+0x2cd>
  802f90:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f95:	8b 55 08             	mov    0x8(%ebp),%edx
  802f98:	89 10                	mov    %edx,(%eax)
  802f9a:	eb 08                	jmp    802fa4 <insert_sorted_with_merge_freeList+0x2d5>
  802f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9f:	a3 38 51 80 00       	mov    %eax,0x805138
  802fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fac:	8b 45 08             	mov    0x8(%ebp),%eax
  802faf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fb5:	a1 44 51 80 00       	mov    0x805144,%eax
  802fba:	40                   	inc    %eax
  802fbb:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802fc0:	e9 53 04 00 00       	jmp    803418 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802fc5:	a1 38 51 80 00       	mov    0x805138,%eax
  802fca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fcd:	e9 15 04 00 00       	jmp    8033e7 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802fd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd5:	8b 00                	mov    (%eax),%eax
  802fd7:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802fda:	8b 45 08             	mov    0x8(%ebp),%eax
  802fdd:	8b 50 08             	mov    0x8(%eax),%edx
  802fe0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe3:	8b 40 08             	mov    0x8(%eax),%eax
  802fe6:	39 c2                	cmp    %eax,%edx
  802fe8:	0f 86 f1 03 00 00    	jbe    8033df <insert_sorted_with_merge_freeList+0x710>
  802fee:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff1:	8b 50 08             	mov    0x8(%eax),%edx
  802ff4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ff7:	8b 40 08             	mov    0x8(%eax),%eax
  802ffa:	39 c2                	cmp    %eax,%edx
  802ffc:	0f 83 dd 03 00 00    	jae    8033df <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803002:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803005:	8b 50 08             	mov    0x8(%eax),%edx
  803008:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300b:	8b 40 0c             	mov    0xc(%eax),%eax
  80300e:	01 c2                	add    %eax,%edx
  803010:	8b 45 08             	mov    0x8(%ebp),%eax
  803013:	8b 40 08             	mov    0x8(%eax),%eax
  803016:	39 c2                	cmp    %eax,%edx
  803018:	0f 85 b9 01 00 00    	jne    8031d7 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80301e:	8b 45 08             	mov    0x8(%ebp),%eax
  803021:	8b 50 08             	mov    0x8(%eax),%edx
  803024:	8b 45 08             	mov    0x8(%ebp),%eax
  803027:	8b 40 0c             	mov    0xc(%eax),%eax
  80302a:	01 c2                	add    %eax,%edx
  80302c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80302f:	8b 40 08             	mov    0x8(%eax),%eax
  803032:	39 c2                	cmp    %eax,%edx
  803034:	0f 85 0d 01 00 00    	jne    803147 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  80303a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303d:	8b 50 0c             	mov    0xc(%eax),%edx
  803040:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803043:	8b 40 0c             	mov    0xc(%eax),%eax
  803046:	01 c2                	add    %eax,%edx
  803048:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304b:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80304e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803052:	75 17                	jne    80306b <insert_sorted_with_merge_freeList+0x39c>
  803054:	83 ec 04             	sub    $0x4,%esp
  803057:	68 e4 40 80 00       	push   $0x8040e4
  80305c:	68 5c 01 00 00       	push   $0x15c
  803061:	68 3b 40 80 00       	push   $0x80403b
  803066:	e8 4b d2 ff ff       	call   8002b6 <_panic>
  80306b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80306e:	8b 00                	mov    (%eax),%eax
  803070:	85 c0                	test   %eax,%eax
  803072:	74 10                	je     803084 <insert_sorted_with_merge_freeList+0x3b5>
  803074:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803077:	8b 00                	mov    (%eax),%eax
  803079:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80307c:	8b 52 04             	mov    0x4(%edx),%edx
  80307f:	89 50 04             	mov    %edx,0x4(%eax)
  803082:	eb 0b                	jmp    80308f <insert_sorted_with_merge_freeList+0x3c0>
  803084:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803087:	8b 40 04             	mov    0x4(%eax),%eax
  80308a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80308f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803092:	8b 40 04             	mov    0x4(%eax),%eax
  803095:	85 c0                	test   %eax,%eax
  803097:	74 0f                	je     8030a8 <insert_sorted_with_merge_freeList+0x3d9>
  803099:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80309c:	8b 40 04             	mov    0x4(%eax),%eax
  80309f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030a2:	8b 12                	mov    (%edx),%edx
  8030a4:	89 10                	mov    %edx,(%eax)
  8030a6:	eb 0a                	jmp    8030b2 <insert_sorted_with_merge_freeList+0x3e3>
  8030a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ab:	8b 00                	mov    (%eax),%eax
  8030ad:	a3 38 51 80 00       	mov    %eax,0x805138
  8030b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030b5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030be:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030c5:	a1 44 51 80 00       	mov    0x805144,%eax
  8030ca:	48                   	dec    %eax
  8030cb:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8030d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030d3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8030da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030dd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8030e4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030e8:	75 17                	jne    803101 <insert_sorted_with_merge_freeList+0x432>
  8030ea:	83 ec 04             	sub    $0x4,%esp
  8030ed:	68 18 40 80 00       	push   $0x804018
  8030f2:	68 5f 01 00 00       	push   $0x15f
  8030f7:	68 3b 40 80 00       	push   $0x80403b
  8030fc:	e8 b5 d1 ff ff       	call   8002b6 <_panic>
  803101:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803107:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80310a:	89 10                	mov    %edx,(%eax)
  80310c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80310f:	8b 00                	mov    (%eax),%eax
  803111:	85 c0                	test   %eax,%eax
  803113:	74 0d                	je     803122 <insert_sorted_with_merge_freeList+0x453>
  803115:	a1 48 51 80 00       	mov    0x805148,%eax
  80311a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80311d:	89 50 04             	mov    %edx,0x4(%eax)
  803120:	eb 08                	jmp    80312a <insert_sorted_with_merge_freeList+0x45b>
  803122:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803125:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80312a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80312d:	a3 48 51 80 00       	mov    %eax,0x805148
  803132:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803135:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80313c:	a1 54 51 80 00       	mov    0x805154,%eax
  803141:	40                   	inc    %eax
  803142:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803147:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80314a:	8b 50 0c             	mov    0xc(%eax),%edx
  80314d:	8b 45 08             	mov    0x8(%ebp),%eax
  803150:	8b 40 0c             	mov    0xc(%eax),%eax
  803153:	01 c2                	add    %eax,%edx
  803155:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803158:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  80315b:	8b 45 08             	mov    0x8(%ebp),%eax
  80315e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803165:	8b 45 08             	mov    0x8(%ebp),%eax
  803168:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80316f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803173:	75 17                	jne    80318c <insert_sorted_with_merge_freeList+0x4bd>
  803175:	83 ec 04             	sub    $0x4,%esp
  803178:	68 18 40 80 00       	push   $0x804018
  80317d:	68 64 01 00 00       	push   $0x164
  803182:	68 3b 40 80 00       	push   $0x80403b
  803187:	e8 2a d1 ff ff       	call   8002b6 <_panic>
  80318c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803192:	8b 45 08             	mov    0x8(%ebp),%eax
  803195:	89 10                	mov    %edx,(%eax)
  803197:	8b 45 08             	mov    0x8(%ebp),%eax
  80319a:	8b 00                	mov    (%eax),%eax
  80319c:	85 c0                	test   %eax,%eax
  80319e:	74 0d                	je     8031ad <insert_sorted_with_merge_freeList+0x4de>
  8031a0:	a1 48 51 80 00       	mov    0x805148,%eax
  8031a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8031a8:	89 50 04             	mov    %edx,0x4(%eax)
  8031ab:	eb 08                	jmp    8031b5 <insert_sorted_with_merge_freeList+0x4e6>
  8031ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b8:	a3 48 51 80 00       	mov    %eax,0x805148
  8031bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031c7:	a1 54 51 80 00       	mov    0x805154,%eax
  8031cc:	40                   	inc    %eax
  8031cd:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8031d2:	e9 41 02 00 00       	jmp    803418 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8031d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031da:	8b 50 08             	mov    0x8(%eax),%edx
  8031dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e0:	8b 40 0c             	mov    0xc(%eax),%eax
  8031e3:	01 c2                	add    %eax,%edx
  8031e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e8:	8b 40 08             	mov    0x8(%eax),%eax
  8031eb:	39 c2                	cmp    %eax,%edx
  8031ed:	0f 85 7c 01 00 00    	jne    80336f <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8031f3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031f7:	74 06                	je     8031ff <insert_sorted_with_merge_freeList+0x530>
  8031f9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031fd:	75 17                	jne    803216 <insert_sorted_with_merge_freeList+0x547>
  8031ff:	83 ec 04             	sub    $0x4,%esp
  803202:	68 54 40 80 00       	push   $0x804054
  803207:	68 69 01 00 00       	push   $0x169
  80320c:	68 3b 40 80 00       	push   $0x80403b
  803211:	e8 a0 d0 ff ff       	call   8002b6 <_panic>
  803216:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803219:	8b 50 04             	mov    0x4(%eax),%edx
  80321c:	8b 45 08             	mov    0x8(%ebp),%eax
  80321f:	89 50 04             	mov    %edx,0x4(%eax)
  803222:	8b 45 08             	mov    0x8(%ebp),%eax
  803225:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803228:	89 10                	mov    %edx,(%eax)
  80322a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80322d:	8b 40 04             	mov    0x4(%eax),%eax
  803230:	85 c0                	test   %eax,%eax
  803232:	74 0d                	je     803241 <insert_sorted_with_merge_freeList+0x572>
  803234:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803237:	8b 40 04             	mov    0x4(%eax),%eax
  80323a:	8b 55 08             	mov    0x8(%ebp),%edx
  80323d:	89 10                	mov    %edx,(%eax)
  80323f:	eb 08                	jmp    803249 <insert_sorted_with_merge_freeList+0x57a>
  803241:	8b 45 08             	mov    0x8(%ebp),%eax
  803244:	a3 38 51 80 00       	mov    %eax,0x805138
  803249:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80324c:	8b 55 08             	mov    0x8(%ebp),%edx
  80324f:	89 50 04             	mov    %edx,0x4(%eax)
  803252:	a1 44 51 80 00       	mov    0x805144,%eax
  803257:	40                   	inc    %eax
  803258:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  80325d:	8b 45 08             	mov    0x8(%ebp),%eax
  803260:	8b 50 0c             	mov    0xc(%eax),%edx
  803263:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803266:	8b 40 0c             	mov    0xc(%eax),%eax
  803269:	01 c2                	add    %eax,%edx
  80326b:	8b 45 08             	mov    0x8(%ebp),%eax
  80326e:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803271:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803275:	75 17                	jne    80328e <insert_sorted_with_merge_freeList+0x5bf>
  803277:	83 ec 04             	sub    $0x4,%esp
  80327a:	68 e4 40 80 00       	push   $0x8040e4
  80327f:	68 6b 01 00 00       	push   $0x16b
  803284:	68 3b 40 80 00       	push   $0x80403b
  803289:	e8 28 d0 ff ff       	call   8002b6 <_panic>
  80328e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803291:	8b 00                	mov    (%eax),%eax
  803293:	85 c0                	test   %eax,%eax
  803295:	74 10                	je     8032a7 <insert_sorted_with_merge_freeList+0x5d8>
  803297:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80329a:	8b 00                	mov    (%eax),%eax
  80329c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80329f:	8b 52 04             	mov    0x4(%edx),%edx
  8032a2:	89 50 04             	mov    %edx,0x4(%eax)
  8032a5:	eb 0b                	jmp    8032b2 <insert_sorted_with_merge_freeList+0x5e3>
  8032a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032aa:	8b 40 04             	mov    0x4(%eax),%eax
  8032ad:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032b5:	8b 40 04             	mov    0x4(%eax),%eax
  8032b8:	85 c0                	test   %eax,%eax
  8032ba:	74 0f                	je     8032cb <insert_sorted_with_merge_freeList+0x5fc>
  8032bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032bf:	8b 40 04             	mov    0x4(%eax),%eax
  8032c2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032c5:	8b 12                	mov    (%edx),%edx
  8032c7:	89 10                	mov    %edx,(%eax)
  8032c9:	eb 0a                	jmp    8032d5 <insert_sorted_with_merge_freeList+0x606>
  8032cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ce:	8b 00                	mov    (%eax),%eax
  8032d0:	a3 38 51 80 00       	mov    %eax,0x805138
  8032d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032e1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032e8:	a1 44 51 80 00       	mov    0x805144,%eax
  8032ed:	48                   	dec    %eax
  8032ee:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8032f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032f6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8032fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803300:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803307:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80330b:	75 17                	jne    803324 <insert_sorted_with_merge_freeList+0x655>
  80330d:	83 ec 04             	sub    $0x4,%esp
  803310:	68 18 40 80 00       	push   $0x804018
  803315:	68 6e 01 00 00       	push   $0x16e
  80331a:	68 3b 40 80 00       	push   $0x80403b
  80331f:	e8 92 cf ff ff       	call   8002b6 <_panic>
  803324:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80332a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80332d:	89 10                	mov    %edx,(%eax)
  80332f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803332:	8b 00                	mov    (%eax),%eax
  803334:	85 c0                	test   %eax,%eax
  803336:	74 0d                	je     803345 <insert_sorted_with_merge_freeList+0x676>
  803338:	a1 48 51 80 00       	mov    0x805148,%eax
  80333d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803340:	89 50 04             	mov    %edx,0x4(%eax)
  803343:	eb 08                	jmp    80334d <insert_sorted_with_merge_freeList+0x67e>
  803345:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803348:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80334d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803350:	a3 48 51 80 00       	mov    %eax,0x805148
  803355:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803358:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80335f:	a1 54 51 80 00       	mov    0x805154,%eax
  803364:	40                   	inc    %eax
  803365:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80336a:	e9 a9 00 00 00       	jmp    803418 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  80336f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803373:	74 06                	je     80337b <insert_sorted_with_merge_freeList+0x6ac>
  803375:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803379:	75 17                	jne    803392 <insert_sorted_with_merge_freeList+0x6c3>
  80337b:	83 ec 04             	sub    $0x4,%esp
  80337e:	68 b0 40 80 00       	push   $0x8040b0
  803383:	68 73 01 00 00       	push   $0x173
  803388:	68 3b 40 80 00       	push   $0x80403b
  80338d:	e8 24 cf ff ff       	call   8002b6 <_panic>
  803392:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803395:	8b 10                	mov    (%eax),%edx
  803397:	8b 45 08             	mov    0x8(%ebp),%eax
  80339a:	89 10                	mov    %edx,(%eax)
  80339c:	8b 45 08             	mov    0x8(%ebp),%eax
  80339f:	8b 00                	mov    (%eax),%eax
  8033a1:	85 c0                	test   %eax,%eax
  8033a3:	74 0b                	je     8033b0 <insert_sorted_with_merge_freeList+0x6e1>
  8033a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a8:	8b 00                	mov    (%eax),%eax
  8033aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8033ad:	89 50 04             	mov    %edx,0x4(%eax)
  8033b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8033b6:	89 10                	mov    %edx,(%eax)
  8033b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8033bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033be:	89 50 04             	mov    %edx,0x4(%eax)
  8033c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c4:	8b 00                	mov    (%eax),%eax
  8033c6:	85 c0                	test   %eax,%eax
  8033c8:	75 08                	jne    8033d2 <insert_sorted_with_merge_freeList+0x703>
  8033ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8033cd:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033d2:	a1 44 51 80 00       	mov    0x805144,%eax
  8033d7:	40                   	inc    %eax
  8033d8:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  8033dd:	eb 39                	jmp    803418 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8033df:	a1 40 51 80 00       	mov    0x805140,%eax
  8033e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033eb:	74 07                	je     8033f4 <insert_sorted_with_merge_freeList+0x725>
  8033ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f0:	8b 00                	mov    (%eax),%eax
  8033f2:	eb 05                	jmp    8033f9 <insert_sorted_with_merge_freeList+0x72a>
  8033f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8033f9:	a3 40 51 80 00       	mov    %eax,0x805140
  8033fe:	a1 40 51 80 00       	mov    0x805140,%eax
  803403:	85 c0                	test   %eax,%eax
  803405:	0f 85 c7 fb ff ff    	jne    802fd2 <insert_sorted_with_merge_freeList+0x303>
  80340b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80340f:	0f 85 bd fb ff ff    	jne    802fd2 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803415:	eb 01                	jmp    803418 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803417:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803418:	90                   	nop
  803419:	c9                   	leave  
  80341a:	c3                   	ret    

0080341b <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  80341b:	55                   	push   %ebp
  80341c:	89 e5                	mov    %esp,%ebp
  80341e:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803421:	8b 55 08             	mov    0x8(%ebp),%edx
  803424:	89 d0                	mov    %edx,%eax
  803426:	c1 e0 02             	shl    $0x2,%eax
  803429:	01 d0                	add    %edx,%eax
  80342b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803432:	01 d0                	add    %edx,%eax
  803434:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80343b:	01 d0                	add    %edx,%eax
  80343d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803444:	01 d0                	add    %edx,%eax
  803446:	c1 e0 04             	shl    $0x4,%eax
  803449:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  80344c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803453:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803456:	83 ec 0c             	sub    $0xc,%esp
  803459:	50                   	push   %eax
  80345a:	e8 26 e7 ff ff       	call   801b85 <sys_get_virtual_time>
  80345f:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803462:	eb 41                	jmp    8034a5 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803464:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803467:	83 ec 0c             	sub    $0xc,%esp
  80346a:	50                   	push   %eax
  80346b:	e8 15 e7 ff ff       	call   801b85 <sys_get_virtual_time>
  803470:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803473:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803476:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803479:	29 c2                	sub    %eax,%edx
  80347b:	89 d0                	mov    %edx,%eax
  80347d:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803480:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803483:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803486:	89 d1                	mov    %edx,%ecx
  803488:	29 c1                	sub    %eax,%ecx
  80348a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80348d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803490:	39 c2                	cmp    %eax,%edx
  803492:	0f 97 c0             	seta   %al
  803495:	0f b6 c0             	movzbl %al,%eax
  803498:	29 c1                	sub    %eax,%ecx
  80349a:	89 c8                	mov    %ecx,%eax
  80349c:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  80349f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8034a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8034a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8034ab:	72 b7                	jb     803464 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8034ad:	90                   	nop
  8034ae:	c9                   	leave  
  8034af:	c3                   	ret    

008034b0 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8034b0:	55                   	push   %ebp
  8034b1:	89 e5                	mov    %esp,%ebp
  8034b3:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8034b6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8034bd:	eb 03                	jmp    8034c2 <busy_wait+0x12>
  8034bf:	ff 45 fc             	incl   -0x4(%ebp)
  8034c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8034c5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8034c8:	72 f5                	jb     8034bf <busy_wait+0xf>
	return i;
  8034ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8034cd:	c9                   	leave  
  8034ce:	c3                   	ret    
  8034cf:	90                   	nop

008034d0 <__udivdi3>:
  8034d0:	55                   	push   %ebp
  8034d1:	57                   	push   %edi
  8034d2:	56                   	push   %esi
  8034d3:	53                   	push   %ebx
  8034d4:	83 ec 1c             	sub    $0x1c,%esp
  8034d7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8034db:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8034df:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8034e3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8034e7:	89 ca                	mov    %ecx,%edx
  8034e9:	89 f8                	mov    %edi,%eax
  8034eb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8034ef:	85 f6                	test   %esi,%esi
  8034f1:	75 2d                	jne    803520 <__udivdi3+0x50>
  8034f3:	39 cf                	cmp    %ecx,%edi
  8034f5:	77 65                	ja     80355c <__udivdi3+0x8c>
  8034f7:	89 fd                	mov    %edi,%ebp
  8034f9:	85 ff                	test   %edi,%edi
  8034fb:	75 0b                	jne    803508 <__udivdi3+0x38>
  8034fd:	b8 01 00 00 00       	mov    $0x1,%eax
  803502:	31 d2                	xor    %edx,%edx
  803504:	f7 f7                	div    %edi
  803506:	89 c5                	mov    %eax,%ebp
  803508:	31 d2                	xor    %edx,%edx
  80350a:	89 c8                	mov    %ecx,%eax
  80350c:	f7 f5                	div    %ebp
  80350e:	89 c1                	mov    %eax,%ecx
  803510:	89 d8                	mov    %ebx,%eax
  803512:	f7 f5                	div    %ebp
  803514:	89 cf                	mov    %ecx,%edi
  803516:	89 fa                	mov    %edi,%edx
  803518:	83 c4 1c             	add    $0x1c,%esp
  80351b:	5b                   	pop    %ebx
  80351c:	5e                   	pop    %esi
  80351d:	5f                   	pop    %edi
  80351e:	5d                   	pop    %ebp
  80351f:	c3                   	ret    
  803520:	39 ce                	cmp    %ecx,%esi
  803522:	77 28                	ja     80354c <__udivdi3+0x7c>
  803524:	0f bd fe             	bsr    %esi,%edi
  803527:	83 f7 1f             	xor    $0x1f,%edi
  80352a:	75 40                	jne    80356c <__udivdi3+0x9c>
  80352c:	39 ce                	cmp    %ecx,%esi
  80352e:	72 0a                	jb     80353a <__udivdi3+0x6a>
  803530:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803534:	0f 87 9e 00 00 00    	ja     8035d8 <__udivdi3+0x108>
  80353a:	b8 01 00 00 00       	mov    $0x1,%eax
  80353f:	89 fa                	mov    %edi,%edx
  803541:	83 c4 1c             	add    $0x1c,%esp
  803544:	5b                   	pop    %ebx
  803545:	5e                   	pop    %esi
  803546:	5f                   	pop    %edi
  803547:	5d                   	pop    %ebp
  803548:	c3                   	ret    
  803549:	8d 76 00             	lea    0x0(%esi),%esi
  80354c:	31 ff                	xor    %edi,%edi
  80354e:	31 c0                	xor    %eax,%eax
  803550:	89 fa                	mov    %edi,%edx
  803552:	83 c4 1c             	add    $0x1c,%esp
  803555:	5b                   	pop    %ebx
  803556:	5e                   	pop    %esi
  803557:	5f                   	pop    %edi
  803558:	5d                   	pop    %ebp
  803559:	c3                   	ret    
  80355a:	66 90                	xchg   %ax,%ax
  80355c:	89 d8                	mov    %ebx,%eax
  80355e:	f7 f7                	div    %edi
  803560:	31 ff                	xor    %edi,%edi
  803562:	89 fa                	mov    %edi,%edx
  803564:	83 c4 1c             	add    $0x1c,%esp
  803567:	5b                   	pop    %ebx
  803568:	5e                   	pop    %esi
  803569:	5f                   	pop    %edi
  80356a:	5d                   	pop    %ebp
  80356b:	c3                   	ret    
  80356c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803571:	89 eb                	mov    %ebp,%ebx
  803573:	29 fb                	sub    %edi,%ebx
  803575:	89 f9                	mov    %edi,%ecx
  803577:	d3 e6                	shl    %cl,%esi
  803579:	89 c5                	mov    %eax,%ebp
  80357b:	88 d9                	mov    %bl,%cl
  80357d:	d3 ed                	shr    %cl,%ebp
  80357f:	89 e9                	mov    %ebp,%ecx
  803581:	09 f1                	or     %esi,%ecx
  803583:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803587:	89 f9                	mov    %edi,%ecx
  803589:	d3 e0                	shl    %cl,%eax
  80358b:	89 c5                	mov    %eax,%ebp
  80358d:	89 d6                	mov    %edx,%esi
  80358f:	88 d9                	mov    %bl,%cl
  803591:	d3 ee                	shr    %cl,%esi
  803593:	89 f9                	mov    %edi,%ecx
  803595:	d3 e2                	shl    %cl,%edx
  803597:	8b 44 24 08          	mov    0x8(%esp),%eax
  80359b:	88 d9                	mov    %bl,%cl
  80359d:	d3 e8                	shr    %cl,%eax
  80359f:	09 c2                	or     %eax,%edx
  8035a1:	89 d0                	mov    %edx,%eax
  8035a3:	89 f2                	mov    %esi,%edx
  8035a5:	f7 74 24 0c          	divl   0xc(%esp)
  8035a9:	89 d6                	mov    %edx,%esi
  8035ab:	89 c3                	mov    %eax,%ebx
  8035ad:	f7 e5                	mul    %ebp
  8035af:	39 d6                	cmp    %edx,%esi
  8035b1:	72 19                	jb     8035cc <__udivdi3+0xfc>
  8035b3:	74 0b                	je     8035c0 <__udivdi3+0xf0>
  8035b5:	89 d8                	mov    %ebx,%eax
  8035b7:	31 ff                	xor    %edi,%edi
  8035b9:	e9 58 ff ff ff       	jmp    803516 <__udivdi3+0x46>
  8035be:	66 90                	xchg   %ax,%ax
  8035c0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8035c4:	89 f9                	mov    %edi,%ecx
  8035c6:	d3 e2                	shl    %cl,%edx
  8035c8:	39 c2                	cmp    %eax,%edx
  8035ca:	73 e9                	jae    8035b5 <__udivdi3+0xe5>
  8035cc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8035cf:	31 ff                	xor    %edi,%edi
  8035d1:	e9 40 ff ff ff       	jmp    803516 <__udivdi3+0x46>
  8035d6:	66 90                	xchg   %ax,%ax
  8035d8:	31 c0                	xor    %eax,%eax
  8035da:	e9 37 ff ff ff       	jmp    803516 <__udivdi3+0x46>
  8035df:	90                   	nop

008035e0 <__umoddi3>:
  8035e0:	55                   	push   %ebp
  8035e1:	57                   	push   %edi
  8035e2:	56                   	push   %esi
  8035e3:	53                   	push   %ebx
  8035e4:	83 ec 1c             	sub    $0x1c,%esp
  8035e7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8035eb:	8b 74 24 34          	mov    0x34(%esp),%esi
  8035ef:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8035f3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8035f7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8035fb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8035ff:	89 f3                	mov    %esi,%ebx
  803601:	89 fa                	mov    %edi,%edx
  803603:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803607:	89 34 24             	mov    %esi,(%esp)
  80360a:	85 c0                	test   %eax,%eax
  80360c:	75 1a                	jne    803628 <__umoddi3+0x48>
  80360e:	39 f7                	cmp    %esi,%edi
  803610:	0f 86 a2 00 00 00    	jbe    8036b8 <__umoddi3+0xd8>
  803616:	89 c8                	mov    %ecx,%eax
  803618:	89 f2                	mov    %esi,%edx
  80361a:	f7 f7                	div    %edi
  80361c:	89 d0                	mov    %edx,%eax
  80361e:	31 d2                	xor    %edx,%edx
  803620:	83 c4 1c             	add    $0x1c,%esp
  803623:	5b                   	pop    %ebx
  803624:	5e                   	pop    %esi
  803625:	5f                   	pop    %edi
  803626:	5d                   	pop    %ebp
  803627:	c3                   	ret    
  803628:	39 f0                	cmp    %esi,%eax
  80362a:	0f 87 ac 00 00 00    	ja     8036dc <__umoddi3+0xfc>
  803630:	0f bd e8             	bsr    %eax,%ebp
  803633:	83 f5 1f             	xor    $0x1f,%ebp
  803636:	0f 84 ac 00 00 00    	je     8036e8 <__umoddi3+0x108>
  80363c:	bf 20 00 00 00       	mov    $0x20,%edi
  803641:	29 ef                	sub    %ebp,%edi
  803643:	89 fe                	mov    %edi,%esi
  803645:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803649:	89 e9                	mov    %ebp,%ecx
  80364b:	d3 e0                	shl    %cl,%eax
  80364d:	89 d7                	mov    %edx,%edi
  80364f:	89 f1                	mov    %esi,%ecx
  803651:	d3 ef                	shr    %cl,%edi
  803653:	09 c7                	or     %eax,%edi
  803655:	89 e9                	mov    %ebp,%ecx
  803657:	d3 e2                	shl    %cl,%edx
  803659:	89 14 24             	mov    %edx,(%esp)
  80365c:	89 d8                	mov    %ebx,%eax
  80365e:	d3 e0                	shl    %cl,%eax
  803660:	89 c2                	mov    %eax,%edx
  803662:	8b 44 24 08          	mov    0x8(%esp),%eax
  803666:	d3 e0                	shl    %cl,%eax
  803668:	89 44 24 04          	mov    %eax,0x4(%esp)
  80366c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803670:	89 f1                	mov    %esi,%ecx
  803672:	d3 e8                	shr    %cl,%eax
  803674:	09 d0                	or     %edx,%eax
  803676:	d3 eb                	shr    %cl,%ebx
  803678:	89 da                	mov    %ebx,%edx
  80367a:	f7 f7                	div    %edi
  80367c:	89 d3                	mov    %edx,%ebx
  80367e:	f7 24 24             	mull   (%esp)
  803681:	89 c6                	mov    %eax,%esi
  803683:	89 d1                	mov    %edx,%ecx
  803685:	39 d3                	cmp    %edx,%ebx
  803687:	0f 82 87 00 00 00    	jb     803714 <__umoddi3+0x134>
  80368d:	0f 84 91 00 00 00    	je     803724 <__umoddi3+0x144>
  803693:	8b 54 24 04          	mov    0x4(%esp),%edx
  803697:	29 f2                	sub    %esi,%edx
  803699:	19 cb                	sbb    %ecx,%ebx
  80369b:	89 d8                	mov    %ebx,%eax
  80369d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8036a1:	d3 e0                	shl    %cl,%eax
  8036a3:	89 e9                	mov    %ebp,%ecx
  8036a5:	d3 ea                	shr    %cl,%edx
  8036a7:	09 d0                	or     %edx,%eax
  8036a9:	89 e9                	mov    %ebp,%ecx
  8036ab:	d3 eb                	shr    %cl,%ebx
  8036ad:	89 da                	mov    %ebx,%edx
  8036af:	83 c4 1c             	add    $0x1c,%esp
  8036b2:	5b                   	pop    %ebx
  8036b3:	5e                   	pop    %esi
  8036b4:	5f                   	pop    %edi
  8036b5:	5d                   	pop    %ebp
  8036b6:	c3                   	ret    
  8036b7:	90                   	nop
  8036b8:	89 fd                	mov    %edi,%ebp
  8036ba:	85 ff                	test   %edi,%edi
  8036bc:	75 0b                	jne    8036c9 <__umoddi3+0xe9>
  8036be:	b8 01 00 00 00       	mov    $0x1,%eax
  8036c3:	31 d2                	xor    %edx,%edx
  8036c5:	f7 f7                	div    %edi
  8036c7:	89 c5                	mov    %eax,%ebp
  8036c9:	89 f0                	mov    %esi,%eax
  8036cb:	31 d2                	xor    %edx,%edx
  8036cd:	f7 f5                	div    %ebp
  8036cf:	89 c8                	mov    %ecx,%eax
  8036d1:	f7 f5                	div    %ebp
  8036d3:	89 d0                	mov    %edx,%eax
  8036d5:	e9 44 ff ff ff       	jmp    80361e <__umoddi3+0x3e>
  8036da:	66 90                	xchg   %ax,%ax
  8036dc:	89 c8                	mov    %ecx,%eax
  8036de:	89 f2                	mov    %esi,%edx
  8036e0:	83 c4 1c             	add    $0x1c,%esp
  8036e3:	5b                   	pop    %ebx
  8036e4:	5e                   	pop    %esi
  8036e5:	5f                   	pop    %edi
  8036e6:	5d                   	pop    %ebp
  8036e7:	c3                   	ret    
  8036e8:	3b 04 24             	cmp    (%esp),%eax
  8036eb:	72 06                	jb     8036f3 <__umoddi3+0x113>
  8036ed:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8036f1:	77 0f                	ja     803702 <__umoddi3+0x122>
  8036f3:	89 f2                	mov    %esi,%edx
  8036f5:	29 f9                	sub    %edi,%ecx
  8036f7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8036fb:	89 14 24             	mov    %edx,(%esp)
  8036fe:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803702:	8b 44 24 04          	mov    0x4(%esp),%eax
  803706:	8b 14 24             	mov    (%esp),%edx
  803709:	83 c4 1c             	add    $0x1c,%esp
  80370c:	5b                   	pop    %ebx
  80370d:	5e                   	pop    %esi
  80370e:	5f                   	pop    %edi
  80370f:	5d                   	pop    %ebp
  803710:	c3                   	ret    
  803711:	8d 76 00             	lea    0x0(%esi),%esi
  803714:	2b 04 24             	sub    (%esp),%eax
  803717:	19 fa                	sbb    %edi,%edx
  803719:	89 d1                	mov    %edx,%ecx
  80371b:	89 c6                	mov    %eax,%esi
  80371d:	e9 71 ff ff ff       	jmp    803693 <__umoddi3+0xb3>
  803722:	66 90                	xchg   %ax,%ax
  803724:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803728:	72 ea                	jb     803714 <__umoddi3+0x134>
  80372a:	89 d9                	mov    %ebx,%ecx
  80372c:	e9 62 ff ff ff       	jmp    803693 <__umoddi3+0xb3>
