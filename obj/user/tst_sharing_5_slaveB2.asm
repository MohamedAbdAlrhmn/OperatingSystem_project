
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
  80008c:	68 c0 36 80 00       	push   $0x8036c0
  800091:	6a 12                	push   $0x12
  800093:	68 dc 36 80 00       	push   $0x8036dc
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
  8000aa:	e8 11 1a 00 00       	call   801ac0 <sys_getparentenvid>
  8000af:	83 ec 08             	sub    $0x8,%esp
  8000b2:	68 f9 36 80 00       	push   $0x8036f9
  8000b7:	50                   	push   %eax
  8000b8:	e8 66 15 00 00       	call   801623 <sget>
  8000bd:	83 c4 10             	add    $0x10,%esp
  8000c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("Slave B2 env used z (getSharedObject)\n");
  8000c3:	83 ec 0c             	sub    $0xc,%esp
  8000c6:	68 fc 36 80 00       	push   $0x8036fc
  8000cb:	e8 9a 04 00 00       	call   80056a <cprintf>
  8000d0:	83 c4 10             	add    $0x10,%esp
	//To indicate that it's successfully got z
	inctst();
  8000d3:	e8 0d 1b 00 00       	call   801be5 <inctst>

	cprintf("Slave B2 please be patient ...\n");
  8000d8:	83 ec 0c             	sub    $0xc,%esp
  8000db:	68 24 37 80 00       	push   $0x803724
  8000e0:	e8 85 04 00 00       	call   80056a <cprintf>
  8000e5:	83 c4 10             	add    $0x10,%esp

	//sleep a while to allow the master to remove x & z
	env_sleep(9000);
  8000e8:	83 ec 0c             	sub    $0xc,%esp
  8000eb:	68 28 23 00 00       	push   $0x2328
  8000f0:	e8 94 32 00 00       	call   803389 <env_sleep>
  8000f5:	83 c4 10             	add    $0x10,%esp
	//to ensure that the other environments completed successfully
	while (gettst()!=2) ;// panic("test failed");
  8000f8:	90                   	nop
  8000f9:	e8 01 1b 00 00       	call   801bff <gettst>
  8000fe:	83 f8 02             	cmp    $0x2,%eax
  800101:	75 f6                	jne    8000f9 <_main+0xc1>

	int freeFrames = sys_calculate_free_frames() ;
  800103:	e8 bf 16 00 00       	call   8017c7 <sys_calculate_free_frames>
  800108:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sfree(z);
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	ff 75 ec             	pushl  -0x14(%ebp)
  800111:	e8 51 15 00 00       	call   801667 <sfree>
  800116:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave B2 env removed z\n");
  800119:	83 ec 0c             	sub    $0xc,%esp
  80011c:	68 44 37 80 00       	push   $0x803744
  800121:	e8 44 04 00 00       	call   80056a <cprintf>
  800126:	83 c4 10             	add    $0x10,%esp
	int expected = (1+1) + (1+1);
  800129:	c7 45 e4 04 00 00 00 	movl   $0x4,-0x1c(%ebp)
	if ((sys_calculate_free_frames() - freeFrames) !=  expected) panic("wrong free: frames removed not equal 4 !, correct frames to be removed are 4:\nfrom the env: 1 table + 1 frame for z\nframes_storage of z: should be cleared now\n");
  800130:	e8 92 16 00 00       	call   8017c7 <sys_calculate_free_frames>
  800135:	89 c2                	mov    %eax,%edx
  800137:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80013a:	29 c2                	sub    %eax,%edx
  80013c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80013f:	39 c2                	cmp    %eax,%edx
  800141:	74 14                	je     800157 <_main+0x11f>
  800143:	83 ec 04             	sub    $0x4,%esp
  800146:	68 5c 37 80 00       	push   $0x80375c
  80014b:	6a 2a                	push   $0x2a
  80014d:	68 dc 36 80 00       	push   $0x8036dc
  800152:	e8 5f 01 00 00       	call   8002b6 <_panic>


	cprintf("Step B completed successfully!!\n\n\n");
  800157:	83 ec 0c             	sub    $0xc,%esp
  80015a:	68 fc 37 80 00       	push   $0x8037fc
  80015f:	e8 06 04 00 00       	call   80056a <cprintf>
  800164:	83 c4 10             	add    $0x10,%esp
	cprintf("Congratulations!! Test of freeSharedObjects [5] completed successfully!!\n\n\n");
  800167:	83 ec 0c             	sub    $0xc,%esp
  80016a:	68 20 38 80 00       	push   $0x803820
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
  800180:	e8 22 19 00 00       	call   801aa7 <sys_getenvindex>
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
  8001eb:	e8 c4 16 00 00       	call   8018b4 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001f0:	83 ec 0c             	sub    $0xc,%esp
  8001f3:	68 84 38 80 00       	push   $0x803884
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
  80021b:	68 ac 38 80 00       	push   $0x8038ac
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
  80024c:	68 d4 38 80 00       	push   $0x8038d4
  800251:	e8 14 03 00 00       	call   80056a <cprintf>
  800256:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800259:	a1 20 50 80 00       	mov    0x805020,%eax
  80025e:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800264:	83 ec 08             	sub    $0x8,%esp
  800267:	50                   	push   %eax
  800268:	68 2c 39 80 00       	push   $0x80392c
  80026d:	e8 f8 02 00 00       	call   80056a <cprintf>
  800272:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800275:	83 ec 0c             	sub    $0xc,%esp
  800278:	68 84 38 80 00       	push   $0x803884
  80027d:	e8 e8 02 00 00       	call   80056a <cprintf>
  800282:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800285:	e8 44 16 00 00       	call   8018ce <sys_enable_interrupt>

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
  80029d:	e8 d1 17 00 00       	call   801a73 <sys_destroy_env>
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
  8002ae:	e8 26 18 00 00       	call   801ad9 <sys_exit_env>
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
  8002d7:	68 40 39 80 00       	push   $0x803940
  8002dc:	e8 89 02 00 00       	call   80056a <cprintf>
  8002e1:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002e4:	a1 00 50 80 00       	mov    0x805000,%eax
  8002e9:	ff 75 0c             	pushl  0xc(%ebp)
  8002ec:	ff 75 08             	pushl  0x8(%ebp)
  8002ef:	50                   	push   %eax
  8002f0:	68 45 39 80 00       	push   $0x803945
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
  800314:	68 61 39 80 00       	push   $0x803961
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
  800340:	68 64 39 80 00       	push   $0x803964
  800345:	6a 26                	push   $0x26
  800347:	68 b0 39 80 00       	push   $0x8039b0
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
  800412:	68 bc 39 80 00       	push   $0x8039bc
  800417:	6a 3a                	push   $0x3a
  800419:	68 b0 39 80 00       	push   $0x8039b0
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
  800482:	68 10 3a 80 00       	push   $0x803a10
  800487:	6a 44                	push   $0x44
  800489:	68 b0 39 80 00       	push   $0x8039b0
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
  8004dc:	e8 25 12 00 00       	call   801706 <sys_cputs>
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
  800553:	e8 ae 11 00 00       	call   801706 <sys_cputs>
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
  80059d:	e8 12 13 00 00       	call   8018b4 <sys_disable_interrupt>
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
  8005bd:	e8 0c 13 00 00       	call   8018ce <sys_enable_interrupt>
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
  800607:	e8 34 2e 00 00       	call   803440 <__udivdi3>
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
  800657:	e8 f4 2e 00 00       	call   803550 <__umoddi3>
  80065c:	83 c4 10             	add    $0x10,%esp
  80065f:	05 74 3c 80 00       	add    $0x803c74,%eax
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
  8007b2:	8b 04 85 98 3c 80 00 	mov    0x803c98(,%eax,4),%eax
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
  800893:	8b 34 9d e0 3a 80 00 	mov    0x803ae0(,%ebx,4),%esi
  80089a:	85 f6                	test   %esi,%esi
  80089c:	75 19                	jne    8008b7 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80089e:	53                   	push   %ebx
  80089f:	68 85 3c 80 00       	push   $0x803c85
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
  8008b8:	68 8e 3c 80 00       	push   $0x803c8e
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
  8008e5:	be 91 3c 80 00       	mov    $0x803c91,%esi
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
  80130b:	68 f0 3d 80 00       	push   $0x803df0
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
  8013db:	e8 6a 04 00 00       	call   80184a <sys_allocate_chunk>
  8013e0:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013e3:	a1 20 51 80 00       	mov    0x805120,%eax
  8013e8:	83 ec 0c             	sub    $0xc,%esp
  8013eb:	50                   	push   %eax
  8013ec:	e8 df 0a 00 00       	call   801ed0 <initialize_MemBlocksList>
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
  801419:	68 15 3e 80 00       	push   $0x803e15
  80141e:	6a 33                	push   $0x33
  801420:	68 33 3e 80 00       	push   $0x803e33
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
  801498:	68 40 3e 80 00       	push   $0x803e40
  80149d:	6a 34                	push   $0x34
  80149f:	68 33 3e 80 00       	push   $0x803e33
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
  801530:	e8 e3 06 00 00       	call   801c18 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801535:	85 c0                	test   %eax,%eax
  801537:	74 11                	je     80154a <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801539:	83 ec 0c             	sub    $0xc,%esp
  80153c:	ff 75 e8             	pushl  -0x18(%ebp)
  80153f:	e8 4e 0d 00 00       	call   802292 <alloc_block_FF>
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
  801556:	e8 aa 0a 00 00       	call   802005 <insert_sorted_allocList>
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
  801576:	68 64 3e 80 00       	push   $0x803e64
  80157b:	6a 6f                	push   $0x6f
  80157d:	68 33 3e 80 00       	push   $0x803e33
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
  80159c:	75 07                	jne    8015a5 <smalloc+0x1e>
  80159e:	b8 00 00 00 00       	mov    $0x0,%eax
  8015a3:	eb 7c                	jmp    801621 <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  8015a5:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8015ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015b2:	01 d0                	add    %edx,%eax
  8015b4:	48                   	dec    %eax
  8015b5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8015b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8015c0:	f7 75 f0             	divl   -0x10(%ebp)
  8015c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015c6:	29 d0                	sub    %edx,%eax
  8015c8:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  8015cb:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8015d2:	e8 41 06 00 00       	call   801c18 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8015d7:	85 c0                	test   %eax,%eax
  8015d9:	74 11                	je     8015ec <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  8015db:	83 ec 0c             	sub    $0xc,%esp
  8015de:	ff 75 e8             	pushl  -0x18(%ebp)
  8015e1:	e8 ac 0c 00 00       	call   802292 <alloc_block_FF>
  8015e6:	83 c4 10             	add    $0x10,%esp
  8015e9:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  8015ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8015f0:	74 2a                	je     80161c <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8015f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015f5:	8b 40 08             	mov    0x8(%eax),%eax
  8015f8:	89 c2                	mov    %eax,%edx
  8015fa:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8015fe:	52                   	push   %edx
  8015ff:	50                   	push   %eax
  801600:	ff 75 0c             	pushl  0xc(%ebp)
  801603:	ff 75 08             	pushl  0x8(%ebp)
  801606:	e8 92 03 00 00       	call   80199d <sys_createSharedObject>
  80160b:	83 c4 10             	add    $0x10,%esp
  80160e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  801611:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  801615:	74 05                	je     80161c <smalloc+0x95>
			return (void*)virtual_address;
  801617:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80161a:	eb 05                	jmp    801621 <smalloc+0x9a>
	}
	return NULL;
  80161c:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801621:	c9                   	leave  
  801622:	c3                   	ret    

00801623 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801623:	55                   	push   %ebp
  801624:	89 e5                	mov    %esp,%ebp
  801626:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801629:	e8 c6 fc ff ff       	call   8012f4 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  80162e:	83 ec 04             	sub    $0x4,%esp
  801631:	68 88 3e 80 00       	push   $0x803e88
  801636:	68 b0 00 00 00       	push   $0xb0
  80163b:	68 33 3e 80 00       	push   $0x803e33
  801640:	e8 71 ec ff ff       	call   8002b6 <_panic>

00801645 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801645:	55                   	push   %ebp
  801646:	89 e5                	mov    %esp,%ebp
  801648:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80164b:	e8 a4 fc ff ff       	call   8012f4 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801650:	83 ec 04             	sub    $0x4,%esp
  801653:	68 ac 3e 80 00       	push   $0x803eac
  801658:	68 f4 00 00 00       	push   $0xf4
  80165d:	68 33 3e 80 00       	push   $0x803e33
  801662:	e8 4f ec ff ff       	call   8002b6 <_panic>

00801667 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801667:	55                   	push   %ebp
  801668:	89 e5                	mov    %esp,%ebp
  80166a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80166d:	83 ec 04             	sub    $0x4,%esp
  801670:	68 d4 3e 80 00       	push   $0x803ed4
  801675:	68 08 01 00 00       	push   $0x108
  80167a:	68 33 3e 80 00       	push   $0x803e33
  80167f:	e8 32 ec ff ff       	call   8002b6 <_panic>

00801684 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801684:	55                   	push   %ebp
  801685:	89 e5                	mov    %esp,%ebp
  801687:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80168a:	83 ec 04             	sub    $0x4,%esp
  80168d:	68 f8 3e 80 00       	push   $0x803ef8
  801692:	68 13 01 00 00       	push   $0x113
  801697:	68 33 3e 80 00       	push   $0x803e33
  80169c:	e8 15 ec ff ff       	call   8002b6 <_panic>

008016a1 <shrink>:

}
void shrink(uint32 newSize)
{
  8016a1:	55                   	push   %ebp
  8016a2:	89 e5                	mov    %esp,%ebp
  8016a4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016a7:	83 ec 04             	sub    $0x4,%esp
  8016aa:	68 f8 3e 80 00       	push   $0x803ef8
  8016af:	68 18 01 00 00       	push   $0x118
  8016b4:	68 33 3e 80 00       	push   $0x803e33
  8016b9:	e8 f8 eb ff ff       	call   8002b6 <_panic>

008016be <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8016be:	55                   	push   %ebp
  8016bf:	89 e5                	mov    %esp,%ebp
  8016c1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016c4:	83 ec 04             	sub    $0x4,%esp
  8016c7:	68 f8 3e 80 00       	push   $0x803ef8
  8016cc:	68 1d 01 00 00       	push   $0x11d
  8016d1:	68 33 3e 80 00       	push   $0x803e33
  8016d6:	e8 db eb ff ff       	call   8002b6 <_panic>

008016db <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8016db:	55                   	push   %ebp
  8016dc:	89 e5                	mov    %esp,%ebp
  8016de:	57                   	push   %edi
  8016df:	56                   	push   %esi
  8016e0:	53                   	push   %ebx
  8016e1:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ea:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016ed:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016f0:	8b 7d 18             	mov    0x18(%ebp),%edi
  8016f3:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8016f6:	cd 30                	int    $0x30
  8016f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8016fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8016fe:	83 c4 10             	add    $0x10,%esp
  801701:	5b                   	pop    %ebx
  801702:	5e                   	pop    %esi
  801703:	5f                   	pop    %edi
  801704:	5d                   	pop    %ebp
  801705:	c3                   	ret    

00801706 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801706:	55                   	push   %ebp
  801707:	89 e5                	mov    %esp,%ebp
  801709:	83 ec 04             	sub    $0x4,%esp
  80170c:	8b 45 10             	mov    0x10(%ebp),%eax
  80170f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801712:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801716:	8b 45 08             	mov    0x8(%ebp),%eax
  801719:	6a 00                	push   $0x0
  80171b:	6a 00                	push   $0x0
  80171d:	52                   	push   %edx
  80171e:	ff 75 0c             	pushl  0xc(%ebp)
  801721:	50                   	push   %eax
  801722:	6a 00                	push   $0x0
  801724:	e8 b2 ff ff ff       	call   8016db <syscall>
  801729:	83 c4 18             	add    $0x18,%esp
}
  80172c:	90                   	nop
  80172d:	c9                   	leave  
  80172e:	c3                   	ret    

0080172f <sys_cgetc>:

int
sys_cgetc(void)
{
  80172f:	55                   	push   %ebp
  801730:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801732:	6a 00                	push   $0x0
  801734:	6a 00                	push   $0x0
  801736:	6a 00                	push   $0x0
  801738:	6a 00                	push   $0x0
  80173a:	6a 00                	push   $0x0
  80173c:	6a 01                	push   $0x1
  80173e:	e8 98 ff ff ff       	call   8016db <syscall>
  801743:	83 c4 18             	add    $0x18,%esp
}
  801746:	c9                   	leave  
  801747:	c3                   	ret    

00801748 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801748:	55                   	push   %ebp
  801749:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80174b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80174e:	8b 45 08             	mov    0x8(%ebp),%eax
  801751:	6a 00                	push   $0x0
  801753:	6a 00                	push   $0x0
  801755:	6a 00                	push   $0x0
  801757:	52                   	push   %edx
  801758:	50                   	push   %eax
  801759:	6a 05                	push   $0x5
  80175b:	e8 7b ff ff ff       	call   8016db <syscall>
  801760:	83 c4 18             	add    $0x18,%esp
}
  801763:	c9                   	leave  
  801764:	c3                   	ret    

00801765 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801765:	55                   	push   %ebp
  801766:	89 e5                	mov    %esp,%ebp
  801768:	56                   	push   %esi
  801769:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80176a:	8b 75 18             	mov    0x18(%ebp),%esi
  80176d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801770:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801773:	8b 55 0c             	mov    0xc(%ebp),%edx
  801776:	8b 45 08             	mov    0x8(%ebp),%eax
  801779:	56                   	push   %esi
  80177a:	53                   	push   %ebx
  80177b:	51                   	push   %ecx
  80177c:	52                   	push   %edx
  80177d:	50                   	push   %eax
  80177e:	6a 06                	push   $0x6
  801780:	e8 56 ff ff ff       	call   8016db <syscall>
  801785:	83 c4 18             	add    $0x18,%esp
}
  801788:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80178b:	5b                   	pop    %ebx
  80178c:	5e                   	pop    %esi
  80178d:	5d                   	pop    %ebp
  80178e:	c3                   	ret    

0080178f <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80178f:	55                   	push   %ebp
  801790:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801792:	8b 55 0c             	mov    0xc(%ebp),%edx
  801795:	8b 45 08             	mov    0x8(%ebp),%eax
  801798:	6a 00                	push   $0x0
  80179a:	6a 00                	push   $0x0
  80179c:	6a 00                	push   $0x0
  80179e:	52                   	push   %edx
  80179f:	50                   	push   %eax
  8017a0:	6a 07                	push   $0x7
  8017a2:	e8 34 ff ff ff       	call   8016db <syscall>
  8017a7:	83 c4 18             	add    $0x18,%esp
}
  8017aa:	c9                   	leave  
  8017ab:	c3                   	ret    

008017ac <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8017ac:	55                   	push   %ebp
  8017ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8017af:	6a 00                	push   $0x0
  8017b1:	6a 00                	push   $0x0
  8017b3:	6a 00                	push   $0x0
  8017b5:	ff 75 0c             	pushl  0xc(%ebp)
  8017b8:	ff 75 08             	pushl  0x8(%ebp)
  8017bb:	6a 08                	push   $0x8
  8017bd:	e8 19 ff ff ff       	call   8016db <syscall>
  8017c2:	83 c4 18             	add    $0x18,%esp
}
  8017c5:	c9                   	leave  
  8017c6:	c3                   	ret    

008017c7 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8017c7:	55                   	push   %ebp
  8017c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8017ca:	6a 00                	push   $0x0
  8017cc:	6a 00                	push   $0x0
  8017ce:	6a 00                	push   $0x0
  8017d0:	6a 00                	push   $0x0
  8017d2:	6a 00                	push   $0x0
  8017d4:	6a 09                	push   $0x9
  8017d6:	e8 00 ff ff ff       	call   8016db <syscall>
  8017db:	83 c4 18             	add    $0x18,%esp
}
  8017de:	c9                   	leave  
  8017df:	c3                   	ret    

008017e0 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8017e0:	55                   	push   %ebp
  8017e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8017e3:	6a 00                	push   $0x0
  8017e5:	6a 00                	push   $0x0
  8017e7:	6a 00                	push   $0x0
  8017e9:	6a 00                	push   $0x0
  8017eb:	6a 00                	push   $0x0
  8017ed:	6a 0a                	push   $0xa
  8017ef:	e8 e7 fe ff ff       	call   8016db <syscall>
  8017f4:	83 c4 18             	add    $0x18,%esp
}
  8017f7:	c9                   	leave  
  8017f8:	c3                   	ret    

008017f9 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8017f9:	55                   	push   %ebp
  8017fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8017fc:	6a 00                	push   $0x0
  8017fe:	6a 00                	push   $0x0
  801800:	6a 00                	push   $0x0
  801802:	6a 00                	push   $0x0
  801804:	6a 00                	push   $0x0
  801806:	6a 0b                	push   $0xb
  801808:	e8 ce fe ff ff       	call   8016db <syscall>
  80180d:	83 c4 18             	add    $0x18,%esp
}
  801810:	c9                   	leave  
  801811:	c3                   	ret    

00801812 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801812:	55                   	push   %ebp
  801813:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801815:	6a 00                	push   $0x0
  801817:	6a 00                	push   $0x0
  801819:	6a 00                	push   $0x0
  80181b:	ff 75 0c             	pushl  0xc(%ebp)
  80181e:	ff 75 08             	pushl  0x8(%ebp)
  801821:	6a 0f                	push   $0xf
  801823:	e8 b3 fe ff ff       	call   8016db <syscall>
  801828:	83 c4 18             	add    $0x18,%esp
	return;
  80182b:	90                   	nop
}
  80182c:	c9                   	leave  
  80182d:	c3                   	ret    

0080182e <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80182e:	55                   	push   %ebp
  80182f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801831:	6a 00                	push   $0x0
  801833:	6a 00                	push   $0x0
  801835:	6a 00                	push   $0x0
  801837:	ff 75 0c             	pushl  0xc(%ebp)
  80183a:	ff 75 08             	pushl  0x8(%ebp)
  80183d:	6a 10                	push   $0x10
  80183f:	e8 97 fe ff ff       	call   8016db <syscall>
  801844:	83 c4 18             	add    $0x18,%esp
	return ;
  801847:	90                   	nop
}
  801848:	c9                   	leave  
  801849:	c3                   	ret    

0080184a <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80184a:	55                   	push   %ebp
  80184b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80184d:	6a 00                	push   $0x0
  80184f:	6a 00                	push   $0x0
  801851:	ff 75 10             	pushl  0x10(%ebp)
  801854:	ff 75 0c             	pushl  0xc(%ebp)
  801857:	ff 75 08             	pushl  0x8(%ebp)
  80185a:	6a 11                	push   $0x11
  80185c:	e8 7a fe ff ff       	call   8016db <syscall>
  801861:	83 c4 18             	add    $0x18,%esp
	return ;
  801864:	90                   	nop
}
  801865:	c9                   	leave  
  801866:	c3                   	ret    

00801867 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801867:	55                   	push   %ebp
  801868:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80186a:	6a 00                	push   $0x0
  80186c:	6a 00                	push   $0x0
  80186e:	6a 00                	push   $0x0
  801870:	6a 00                	push   $0x0
  801872:	6a 00                	push   $0x0
  801874:	6a 0c                	push   $0xc
  801876:	e8 60 fe ff ff       	call   8016db <syscall>
  80187b:	83 c4 18             	add    $0x18,%esp
}
  80187e:	c9                   	leave  
  80187f:	c3                   	ret    

00801880 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801880:	55                   	push   %ebp
  801881:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801883:	6a 00                	push   $0x0
  801885:	6a 00                	push   $0x0
  801887:	6a 00                	push   $0x0
  801889:	6a 00                	push   $0x0
  80188b:	ff 75 08             	pushl  0x8(%ebp)
  80188e:	6a 0d                	push   $0xd
  801890:	e8 46 fe ff ff       	call   8016db <syscall>
  801895:	83 c4 18             	add    $0x18,%esp
}
  801898:	c9                   	leave  
  801899:	c3                   	ret    

0080189a <sys_scarce_memory>:

void sys_scarce_memory()
{
  80189a:	55                   	push   %ebp
  80189b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80189d:	6a 00                	push   $0x0
  80189f:	6a 00                	push   $0x0
  8018a1:	6a 00                	push   $0x0
  8018a3:	6a 00                	push   $0x0
  8018a5:	6a 00                	push   $0x0
  8018a7:	6a 0e                	push   $0xe
  8018a9:	e8 2d fe ff ff       	call   8016db <syscall>
  8018ae:	83 c4 18             	add    $0x18,%esp
}
  8018b1:	90                   	nop
  8018b2:	c9                   	leave  
  8018b3:	c3                   	ret    

008018b4 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8018b4:	55                   	push   %ebp
  8018b5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8018b7:	6a 00                	push   $0x0
  8018b9:	6a 00                	push   $0x0
  8018bb:	6a 00                	push   $0x0
  8018bd:	6a 00                	push   $0x0
  8018bf:	6a 00                	push   $0x0
  8018c1:	6a 13                	push   $0x13
  8018c3:	e8 13 fe ff ff       	call   8016db <syscall>
  8018c8:	83 c4 18             	add    $0x18,%esp
}
  8018cb:	90                   	nop
  8018cc:	c9                   	leave  
  8018cd:	c3                   	ret    

008018ce <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8018ce:	55                   	push   %ebp
  8018cf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8018d1:	6a 00                	push   $0x0
  8018d3:	6a 00                	push   $0x0
  8018d5:	6a 00                	push   $0x0
  8018d7:	6a 00                	push   $0x0
  8018d9:	6a 00                	push   $0x0
  8018db:	6a 14                	push   $0x14
  8018dd:	e8 f9 fd ff ff       	call   8016db <syscall>
  8018e2:	83 c4 18             	add    $0x18,%esp
}
  8018e5:	90                   	nop
  8018e6:	c9                   	leave  
  8018e7:	c3                   	ret    

008018e8 <sys_cputc>:


void
sys_cputc(const char c)
{
  8018e8:	55                   	push   %ebp
  8018e9:	89 e5                	mov    %esp,%ebp
  8018eb:	83 ec 04             	sub    $0x4,%esp
  8018ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8018f4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8018f8:	6a 00                	push   $0x0
  8018fa:	6a 00                	push   $0x0
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 00                	push   $0x0
  801900:	50                   	push   %eax
  801901:	6a 15                	push   $0x15
  801903:	e8 d3 fd ff ff       	call   8016db <syscall>
  801908:	83 c4 18             	add    $0x18,%esp
}
  80190b:	90                   	nop
  80190c:	c9                   	leave  
  80190d:	c3                   	ret    

0080190e <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80190e:	55                   	push   %ebp
  80190f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801911:	6a 00                	push   $0x0
  801913:	6a 00                	push   $0x0
  801915:	6a 00                	push   $0x0
  801917:	6a 00                	push   $0x0
  801919:	6a 00                	push   $0x0
  80191b:	6a 16                	push   $0x16
  80191d:	e8 b9 fd ff ff       	call   8016db <syscall>
  801922:	83 c4 18             	add    $0x18,%esp
}
  801925:	90                   	nop
  801926:	c9                   	leave  
  801927:	c3                   	ret    

00801928 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801928:	55                   	push   %ebp
  801929:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80192b:	8b 45 08             	mov    0x8(%ebp),%eax
  80192e:	6a 00                	push   $0x0
  801930:	6a 00                	push   $0x0
  801932:	6a 00                	push   $0x0
  801934:	ff 75 0c             	pushl  0xc(%ebp)
  801937:	50                   	push   %eax
  801938:	6a 17                	push   $0x17
  80193a:	e8 9c fd ff ff       	call   8016db <syscall>
  80193f:	83 c4 18             	add    $0x18,%esp
}
  801942:	c9                   	leave  
  801943:	c3                   	ret    

00801944 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801944:	55                   	push   %ebp
  801945:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801947:	8b 55 0c             	mov    0xc(%ebp),%edx
  80194a:	8b 45 08             	mov    0x8(%ebp),%eax
  80194d:	6a 00                	push   $0x0
  80194f:	6a 00                	push   $0x0
  801951:	6a 00                	push   $0x0
  801953:	52                   	push   %edx
  801954:	50                   	push   %eax
  801955:	6a 1a                	push   $0x1a
  801957:	e8 7f fd ff ff       	call   8016db <syscall>
  80195c:	83 c4 18             	add    $0x18,%esp
}
  80195f:	c9                   	leave  
  801960:	c3                   	ret    

00801961 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801961:	55                   	push   %ebp
  801962:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801964:	8b 55 0c             	mov    0xc(%ebp),%edx
  801967:	8b 45 08             	mov    0x8(%ebp),%eax
  80196a:	6a 00                	push   $0x0
  80196c:	6a 00                	push   $0x0
  80196e:	6a 00                	push   $0x0
  801970:	52                   	push   %edx
  801971:	50                   	push   %eax
  801972:	6a 18                	push   $0x18
  801974:	e8 62 fd ff ff       	call   8016db <syscall>
  801979:	83 c4 18             	add    $0x18,%esp
}
  80197c:	90                   	nop
  80197d:	c9                   	leave  
  80197e:	c3                   	ret    

0080197f <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80197f:	55                   	push   %ebp
  801980:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801982:	8b 55 0c             	mov    0xc(%ebp),%edx
  801985:	8b 45 08             	mov    0x8(%ebp),%eax
  801988:	6a 00                	push   $0x0
  80198a:	6a 00                	push   $0x0
  80198c:	6a 00                	push   $0x0
  80198e:	52                   	push   %edx
  80198f:	50                   	push   %eax
  801990:	6a 19                	push   $0x19
  801992:	e8 44 fd ff ff       	call   8016db <syscall>
  801997:	83 c4 18             	add    $0x18,%esp
}
  80199a:	90                   	nop
  80199b:	c9                   	leave  
  80199c:	c3                   	ret    

0080199d <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80199d:	55                   	push   %ebp
  80199e:	89 e5                	mov    %esp,%ebp
  8019a0:	83 ec 04             	sub    $0x4,%esp
  8019a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8019a6:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8019a9:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8019ac:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b3:	6a 00                	push   $0x0
  8019b5:	51                   	push   %ecx
  8019b6:	52                   	push   %edx
  8019b7:	ff 75 0c             	pushl  0xc(%ebp)
  8019ba:	50                   	push   %eax
  8019bb:	6a 1b                	push   $0x1b
  8019bd:	e8 19 fd ff ff       	call   8016db <syscall>
  8019c2:	83 c4 18             	add    $0x18,%esp
}
  8019c5:	c9                   	leave  
  8019c6:	c3                   	ret    

008019c7 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8019c7:	55                   	push   %ebp
  8019c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8019ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d0:	6a 00                	push   $0x0
  8019d2:	6a 00                	push   $0x0
  8019d4:	6a 00                	push   $0x0
  8019d6:	52                   	push   %edx
  8019d7:	50                   	push   %eax
  8019d8:	6a 1c                	push   $0x1c
  8019da:	e8 fc fc ff ff       	call   8016db <syscall>
  8019df:	83 c4 18             	add    $0x18,%esp
}
  8019e2:	c9                   	leave  
  8019e3:	c3                   	ret    

008019e4 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8019e4:	55                   	push   %ebp
  8019e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8019e7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 00                	push   $0x0
  8019f4:	51                   	push   %ecx
  8019f5:	52                   	push   %edx
  8019f6:	50                   	push   %eax
  8019f7:	6a 1d                	push   $0x1d
  8019f9:	e8 dd fc ff ff       	call   8016db <syscall>
  8019fe:	83 c4 18             	add    $0x18,%esp
}
  801a01:	c9                   	leave  
  801a02:	c3                   	ret    

00801a03 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801a03:	55                   	push   %ebp
  801a04:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a06:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a09:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0c:	6a 00                	push   $0x0
  801a0e:	6a 00                	push   $0x0
  801a10:	6a 00                	push   $0x0
  801a12:	52                   	push   %edx
  801a13:	50                   	push   %eax
  801a14:	6a 1e                	push   $0x1e
  801a16:	e8 c0 fc ff ff       	call   8016db <syscall>
  801a1b:	83 c4 18             	add    $0x18,%esp
}
  801a1e:	c9                   	leave  
  801a1f:	c3                   	ret    

00801a20 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801a20:	55                   	push   %ebp
  801a21:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801a23:	6a 00                	push   $0x0
  801a25:	6a 00                	push   $0x0
  801a27:	6a 00                	push   $0x0
  801a29:	6a 00                	push   $0x0
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 1f                	push   $0x1f
  801a2f:	e8 a7 fc ff ff       	call   8016db <syscall>
  801a34:	83 c4 18             	add    $0x18,%esp
}
  801a37:	c9                   	leave  
  801a38:	c3                   	ret    

00801a39 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a39:	55                   	push   %ebp
  801a3a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3f:	6a 00                	push   $0x0
  801a41:	ff 75 14             	pushl  0x14(%ebp)
  801a44:	ff 75 10             	pushl  0x10(%ebp)
  801a47:	ff 75 0c             	pushl  0xc(%ebp)
  801a4a:	50                   	push   %eax
  801a4b:	6a 20                	push   $0x20
  801a4d:	e8 89 fc ff ff       	call   8016db <syscall>
  801a52:	83 c4 18             	add    $0x18,%esp
}
  801a55:	c9                   	leave  
  801a56:	c3                   	ret    

00801a57 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801a57:	55                   	push   %ebp
  801a58:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 00                	push   $0x0
  801a63:	6a 00                	push   $0x0
  801a65:	50                   	push   %eax
  801a66:	6a 21                	push   $0x21
  801a68:	e8 6e fc ff ff       	call   8016db <syscall>
  801a6d:	83 c4 18             	add    $0x18,%esp
}
  801a70:	90                   	nop
  801a71:	c9                   	leave  
  801a72:	c3                   	ret    

00801a73 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801a73:	55                   	push   %ebp
  801a74:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801a76:	8b 45 08             	mov    0x8(%ebp),%eax
  801a79:	6a 00                	push   $0x0
  801a7b:	6a 00                	push   $0x0
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 00                	push   $0x0
  801a81:	50                   	push   %eax
  801a82:	6a 22                	push   $0x22
  801a84:	e8 52 fc ff ff       	call   8016db <syscall>
  801a89:	83 c4 18             	add    $0x18,%esp
}
  801a8c:	c9                   	leave  
  801a8d:	c3                   	ret    

00801a8e <sys_getenvid>:

int32 sys_getenvid(void)
{
  801a8e:	55                   	push   %ebp
  801a8f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801a91:	6a 00                	push   $0x0
  801a93:	6a 00                	push   $0x0
  801a95:	6a 00                	push   $0x0
  801a97:	6a 00                	push   $0x0
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 02                	push   $0x2
  801a9d:	e8 39 fc ff ff       	call   8016db <syscall>
  801aa2:	83 c4 18             	add    $0x18,%esp
}
  801aa5:	c9                   	leave  
  801aa6:	c3                   	ret    

00801aa7 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801aa7:	55                   	push   %ebp
  801aa8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801aaa:	6a 00                	push   $0x0
  801aac:	6a 00                	push   $0x0
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 03                	push   $0x3
  801ab6:	e8 20 fc ff ff       	call   8016db <syscall>
  801abb:	83 c4 18             	add    $0x18,%esp
}
  801abe:	c9                   	leave  
  801abf:	c3                   	ret    

00801ac0 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801ac0:	55                   	push   %ebp
  801ac1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 00                	push   $0x0
  801acd:	6a 04                	push   $0x4
  801acf:	e8 07 fc ff ff       	call   8016db <syscall>
  801ad4:	83 c4 18             	add    $0x18,%esp
}
  801ad7:	c9                   	leave  
  801ad8:	c3                   	ret    

00801ad9 <sys_exit_env>:


void sys_exit_env(void)
{
  801ad9:	55                   	push   %ebp
  801ada:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 00                	push   $0x0
  801ae4:	6a 00                	push   $0x0
  801ae6:	6a 23                	push   $0x23
  801ae8:	e8 ee fb ff ff       	call   8016db <syscall>
  801aed:	83 c4 18             	add    $0x18,%esp
}
  801af0:	90                   	nop
  801af1:	c9                   	leave  
  801af2:	c3                   	ret    

00801af3 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801af3:	55                   	push   %ebp
  801af4:	89 e5                	mov    %esp,%ebp
  801af6:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801af9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801afc:	8d 50 04             	lea    0x4(%eax),%edx
  801aff:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b02:	6a 00                	push   $0x0
  801b04:	6a 00                	push   $0x0
  801b06:	6a 00                	push   $0x0
  801b08:	52                   	push   %edx
  801b09:	50                   	push   %eax
  801b0a:	6a 24                	push   $0x24
  801b0c:	e8 ca fb ff ff       	call   8016db <syscall>
  801b11:	83 c4 18             	add    $0x18,%esp
	return result;
  801b14:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b17:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b1a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b1d:	89 01                	mov    %eax,(%ecx)
  801b1f:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b22:	8b 45 08             	mov    0x8(%ebp),%eax
  801b25:	c9                   	leave  
  801b26:	c2 04 00             	ret    $0x4

00801b29 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b29:	55                   	push   %ebp
  801b2a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 00                	push   $0x0
  801b30:	ff 75 10             	pushl  0x10(%ebp)
  801b33:	ff 75 0c             	pushl  0xc(%ebp)
  801b36:	ff 75 08             	pushl  0x8(%ebp)
  801b39:	6a 12                	push   $0x12
  801b3b:	e8 9b fb ff ff       	call   8016db <syscall>
  801b40:	83 c4 18             	add    $0x18,%esp
	return ;
  801b43:	90                   	nop
}
  801b44:	c9                   	leave  
  801b45:	c3                   	ret    

00801b46 <sys_rcr2>:
uint32 sys_rcr2()
{
  801b46:	55                   	push   %ebp
  801b47:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 00                	push   $0x0
  801b4f:	6a 00                	push   $0x0
  801b51:	6a 00                	push   $0x0
  801b53:	6a 25                	push   $0x25
  801b55:	e8 81 fb ff ff       	call   8016db <syscall>
  801b5a:	83 c4 18             	add    $0x18,%esp
}
  801b5d:	c9                   	leave  
  801b5e:	c3                   	ret    

00801b5f <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801b5f:	55                   	push   %ebp
  801b60:	89 e5                	mov    %esp,%ebp
  801b62:	83 ec 04             	sub    $0x4,%esp
  801b65:	8b 45 08             	mov    0x8(%ebp),%eax
  801b68:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801b6b:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 00                	push   $0x0
  801b73:	6a 00                	push   $0x0
  801b75:	6a 00                	push   $0x0
  801b77:	50                   	push   %eax
  801b78:	6a 26                	push   $0x26
  801b7a:	e8 5c fb ff ff       	call   8016db <syscall>
  801b7f:	83 c4 18             	add    $0x18,%esp
	return ;
  801b82:	90                   	nop
}
  801b83:	c9                   	leave  
  801b84:	c3                   	ret    

00801b85 <rsttst>:
void rsttst()
{
  801b85:	55                   	push   %ebp
  801b86:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801b88:	6a 00                	push   $0x0
  801b8a:	6a 00                	push   $0x0
  801b8c:	6a 00                	push   $0x0
  801b8e:	6a 00                	push   $0x0
  801b90:	6a 00                	push   $0x0
  801b92:	6a 28                	push   $0x28
  801b94:	e8 42 fb ff ff       	call   8016db <syscall>
  801b99:	83 c4 18             	add    $0x18,%esp
	return ;
  801b9c:	90                   	nop
}
  801b9d:	c9                   	leave  
  801b9e:	c3                   	ret    

00801b9f <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801b9f:	55                   	push   %ebp
  801ba0:	89 e5                	mov    %esp,%ebp
  801ba2:	83 ec 04             	sub    $0x4,%esp
  801ba5:	8b 45 14             	mov    0x14(%ebp),%eax
  801ba8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801bab:	8b 55 18             	mov    0x18(%ebp),%edx
  801bae:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801bb2:	52                   	push   %edx
  801bb3:	50                   	push   %eax
  801bb4:	ff 75 10             	pushl  0x10(%ebp)
  801bb7:	ff 75 0c             	pushl  0xc(%ebp)
  801bba:	ff 75 08             	pushl  0x8(%ebp)
  801bbd:	6a 27                	push   $0x27
  801bbf:	e8 17 fb ff ff       	call   8016db <syscall>
  801bc4:	83 c4 18             	add    $0x18,%esp
	return ;
  801bc7:	90                   	nop
}
  801bc8:	c9                   	leave  
  801bc9:	c3                   	ret    

00801bca <chktst>:
void chktst(uint32 n)
{
  801bca:	55                   	push   %ebp
  801bcb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 00                	push   $0x0
  801bd1:	6a 00                	push   $0x0
  801bd3:	6a 00                	push   $0x0
  801bd5:	ff 75 08             	pushl  0x8(%ebp)
  801bd8:	6a 29                	push   $0x29
  801bda:	e8 fc fa ff ff       	call   8016db <syscall>
  801bdf:	83 c4 18             	add    $0x18,%esp
	return ;
  801be2:	90                   	nop
}
  801be3:	c9                   	leave  
  801be4:	c3                   	ret    

00801be5 <inctst>:

void inctst()
{
  801be5:	55                   	push   %ebp
  801be6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801be8:	6a 00                	push   $0x0
  801bea:	6a 00                	push   $0x0
  801bec:	6a 00                	push   $0x0
  801bee:	6a 00                	push   $0x0
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 2a                	push   $0x2a
  801bf4:	e8 e2 fa ff ff       	call   8016db <syscall>
  801bf9:	83 c4 18             	add    $0x18,%esp
	return ;
  801bfc:	90                   	nop
}
  801bfd:	c9                   	leave  
  801bfe:	c3                   	ret    

00801bff <gettst>:
uint32 gettst()
{
  801bff:	55                   	push   %ebp
  801c00:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c02:	6a 00                	push   $0x0
  801c04:	6a 00                	push   $0x0
  801c06:	6a 00                	push   $0x0
  801c08:	6a 00                	push   $0x0
  801c0a:	6a 00                	push   $0x0
  801c0c:	6a 2b                	push   $0x2b
  801c0e:	e8 c8 fa ff ff       	call   8016db <syscall>
  801c13:	83 c4 18             	add    $0x18,%esp
}
  801c16:	c9                   	leave  
  801c17:	c3                   	ret    

00801c18 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801c18:	55                   	push   %ebp
  801c19:	89 e5                	mov    %esp,%ebp
  801c1b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	6a 00                	push   $0x0
  801c24:	6a 00                	push   $0x0
  801c26:	6a 00                	push   $0x0
  801c28:	6a 2c                	push   $0x2c
  801c2a:	e8 ac fa ff ff       	call   8016db <syscall>
  801c2f:	83 c4 18             	add    $0x18,%esp
  801c32:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801c35:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801c39:	75 07                	jne    801c42 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801c3b:	b8 01 00 00 00       	mov    $0x1,%eax
  801c40:	eb 05                	jmp    801c47 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801c42:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c47:	c9                   	leave  
  801c48:	c3                   	ret    

00801c49 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801c49:	55                   	push   %ebp
  801c4a:	89 e5                	mov    %esp,%ebp
  801c4c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	6a 00                	push   $0x0
  801c57:	6a 00                	push   $0x0
  801c59:	6a 2c                	push   $0x2c
  801c5b:	e8 7b fa ff ff       	call   8016db <syscall>
  801c60:	83 c4 18             	add    $0x18,%esp
  801c63:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801c66:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801c6a:	75 07                	jne    801c73 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801c6c:	b8 01 00 00 00       	mov    $0x1,%eax
  801c71:	eb 05                	jmp    801c78 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801c73:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c78:	c9                   	leave  
  801c79:	c3                   	ret    

00801c7a <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801c7a:	55                   	push   %ebp
  801c7b:	89 e5                	mov    %esp,%ebp
  801c7d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c80:	6a 00                	push   $0x0
  801c82:	6a 00                	push   $0x0
  801c84:	6a 00                	push   $0x0
  801c86:	6a 00                	push   $0x0
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 2c                	push   $0x2c
  801c8c:	e8 4a fa ff ff       	call   8016db <syscall>
  801c91:	83 c4 18             	add    $0x18,%esp
  801c94:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801c97:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801c9b:	75 07                	jne    801ca4 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801c9d:	b8 01 00 00 00       	mov    $0x1,%eax
  801ca2:	eb 05                	jmp    801ca9 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801ca4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ca9:	c9                   	leave  
  801caa:	c3                   	ret    

00801cab <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801cab:	55                   	push   %ebp
  801cac:	89 e5                	mov    %esp,%ebp
  801cae:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cb1:	6a 00                	push   $0x0
  801cb3:	6a 00                	push   $0x0
  801cb5:	6a 00                	push   $0x0
  801cb7:	6a 00                	push   $0x0
  801cb9:	6a 00                	push   $0x0
  801cbb:	6a 2c                	push   $0x2c
  801cbd:	e8 19 fa ff ff       	call   8016db <syscall>
  801cc2:	83 c4 18             	add    $0x18,%esp
  801cc5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801cc8:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801ccc:	75 07                	jne    801cd5 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801cce:	b8 01 00 00 00       	mov    $0x1,%eax
  801cd3:	eb 05                	jmp    801cda <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801cd5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cda:	c9                   	leave  
  801cdb:	c3                   	ret    

00801cdc <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801cdc:	55                   	push   %ebp
  801cdd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801cdf:	6a 00                	push   $0x0
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 00                	push   $0x0
  801ce5:	6a 00                	push   $0x0
  801ce7:	ff 75 08             	pushl  0x8(%ebp)
  801cea:	6a 2d                	push   $0x2d
  801cec:	e8 ea f9 ff ff       	call   8016db <syscall>
  801cf1:	83 c4 18             	add    $0x18,%esp
	return ;
  801cf4:	90                   	nop
}
  801cf5:	c9                   	leave  
  801cf6:	c3                   	ret    

00801cf7 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801cf7:	55                   	push   %ebp
  801cf8:	89 e5                	mov    %esp,%ebp
  801cfa:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801cfb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cfe:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d01:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d04:	8b 45 08             	mov    0x8(%ebp),%eax
  801d07:	6a 00                	push   $0x0
  801d09:	53                   	push   %ebx
  801d0a:	51                   	push   %ecx
  801d0b:	52                   	push   %edx
  801d0c:	50                   	push   %eax
  801d0d:	6a 2e                	push   $0x2e
  801d0f:	e8 c7 f9 ff ff       	call   8016db <syscall>
  801d14:	83 c4 18             	add    $0x18,%esp
}
  801d17:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d1a:	c9                   	leave  
  801d1b:	c3                   	ret    

00801d1c <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801d1c:	55                   	push   %ebp
  801d1d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801d1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d22:	8b 45 08             	mov    0x8(%ebp),%eax
  801d25:	6a 00                	push   $0x0
  801d27:	6a 00                	push   $0x0
  801d29:	6a 00                	push   $0x0
  801d2b:	52                   	push   %edx
  801d2c:	50                   	push   %eax
  801d2d:	6a 2f                	push   $0x2f
  801d2f:	e8 a7 f9 ff ff       	call   8016db <syscall>
  801d34:	83 c4 18             	add    $0x18,%esp
}
  801d37:	c9                   	leave  
  801d38:	c3                   	ret    

00801d39 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801d39:	55                   	push   %ebp
  801d3a:	89 e5                	mov    %esp,%ebp
  801d3c:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801d3f:	83 ec 0c             	sub    $0xc,%esp
  801d42:	68 08 3f 80 00       	push   $0x803f08
  801d47:	e8 1e e8 ff ff       	call   80056a <cprintf>
  801d4c:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801d4f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801d56:	83 ec 0c             	sub    $0xc,%esp
  801d59:	68 34 3f 80 00       	push   $0x803f34
  801d5e:	e8 07 e8 ff ff       	call   80056a <cprintf>
  801d63:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801d66:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d6a:	a1 38 51 80 00       	mov    0x805138,%eax
  801d6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d72:	eb 56                	jmp    801dca <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801d74:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d78:	74 1c                	je     801d96 <print_mem_block_lists+0x5d>
  801d7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d7d:	8b 50 08             	mov    0x8(%eax),%edx
  801d80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d83:	8b 48 08             	mov    0x8(%eax),%ecx
  801d86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d89:	8b 40 0c             	mov    0xc(%eax),%eax
  801d8c:	01 c8                	add    %ecx,%eax
  801d8e:	39 c2                	cmp    %eax,%edx
  801d90:	73 04                	jae    801d96 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801d92:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801d96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d99:	8b 50 08             	mov    0x8(%eax),%edx
  801d9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d9f:	8b 40 0c             	mov    0xc(%eax),%eax
  801da2:	01 c2                	add    %eax,%edx
  801da4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801da7:	8b 40 08             	mov    0x8(%eax),%eax
  801daa:	83 ec 04             	sub    $0x4,%esp
  801dad:	52                   	push   %edx
  801dae:	50                   	push   %eax
  801daf:	68 49 3f 80 00       	push   $0x803f49
  801db4:	e8 b1 e7 ff ff       	call   80056a <cprintf>
  801db9:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801dbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dbf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801dc2:	a1 40 51 80 00       	mov    0x805140,%eax
  801dc7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801dce:	74 07                	je     801dd7 <print_mem_block_lists+0x9e>
  801dd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd3:	8b 00                	mov    (%eax),%eax
  801dd5:	eb 05                	jmp    801ddc <print_mem_block_lists+0xa3>
  801dd7:	b8 00 00 00 00       	mov    $0x0,%eax
  801ddc:	a3 40 51 80 00       	mov    %eax,0x805140
  801de1:	a1 40 51 80 00       	mov    0x805140,%eax
  801de6:	85 c0                	test   %eax,%eax
  801de8:	75 8a                	jne    801d74 <print_mem_block_lists+0x3b>
  801dea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801dee:	75 84                	jne    801d74 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801df0:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801df4:	75 10                	jne    801e06 <print_mem_block_lists+0xcd>
  801df6:	83 ec 0c             	sub    $0xc,%esp
  801df9:	68 58 3f 80 00       	push   $0x803f58
  801dfe:	e8 67 e7 ff ff       	call   80056a <cprintf>
  801e03:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801e06:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801e0d:	83 ec 0c             	sub    $0xc,%esp
  801e10:	68 7c 3f 80 00       	push   $0x803f7c
  801e15:	e8 50 e7 ff ff       	call   80056a <cprintf>
  801e1a:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801e1d:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801e21:	a1 40 50 80 00       	mov    0x805040,%eax
  801e26:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e29:	eb 56                	jmp    801e81 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e2b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e2f:	74 1c                	je     801e4d <print_mem_block_lists+0x114>
  801e31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e34:	8b 50 08             	mov    0x8(%eax),%edx
  801e37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e3a:	8b 48 08             	mov    0x8(%eax),%ecx
  801e3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e40:	8b 40 0c             	mov    0xc(%eax),%eax
  801e43:	01 c8                	add    %ecx,%eax
  801e45:	39 c2                	cmp    %eax,%edx
  801e47:	73 04                	jae    801e4d <print_mem_block_lists+0x114>
			sorted = 0 ;
  801e49:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e50:	8b 50 08             	mov    0x8(%eax),%edx
  801e53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e56:	8b 40 0c             	mov    0xc(%eax),%eax
  801e59:	01 c2                	add    %eax,%edx
  801e5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e5e:	8b 40 08             	mov    0x8(%eax),%eax
  801e61:	83 ec 04             	sub    $0x4,%esp
  801e64:	52                   	push   %edx
  801e65:	50                   	push   %eax
  801e66:	68 49 3f 80 00       	push   $0x803f49
  801e6b:	e8 fa e6 ff ff       	call   80056a <cprintf>
  801e70:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e76:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801e79:	a1 48 50 80 00       	mov    0x805048,%eax
  801e7e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e81:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e85:	74 07                	je     801e8e <print_mem_block_lists+0x155>
  801e87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e8a:	8b 00                	mov    (%eax),%eax
  801e8c:	eb 05                	jmp    801e93 <print_mem_block_lists+0x15a>
  801e8e:	b8 00 00 00 00       	mov    $0x0,%eax
  801e93:	a3 48 50 80 00       	mov    %eax,0x805048
  801e98:	a1 48 50 80 00       	mov    0x805048,%eax
  801e9d:	85 c0                	test   %eax,%eax
  801e9f:	75 8a                	jne    801e2b <print_mem_block_lists+0xf2>
  801ea1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ea5:	75 84                	jne    801e2b <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801ea7:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801eab:	75 10                	jne    801ebd <print_mem_block_lists+0x184>
  801ead:	83 ec 0c             	sub    $0xc,%esp
  801eb0:	68 94 3f 80 00       	push   $0x803f94
  801eb5:	e8 b0 e6 ff ff       	call   80056a <cprintf>
  801eba:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801ebd:	83 ec 0c             	sub    $0xc,%esp
  801ec0:	68 08 3f 80 00       	push   $0x803f08
  801ec5:	e8 a0 e6 ff ff       	call   80056a <cprintf>
  801eca:	83 c4 10             	add    $0x10,%esp

}
  801ecd:	90                   	nop
  801ece:	c9                   	leave  
  801ecf:	c3                   	ret    

00801ed0 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801ed0:	55                   	push   %ebp
  801ed1:	89 e5                	mov    %esp,%ebp
  801ed3:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801ed6:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  801edd:	00 00 00 
  801ee0:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  801ee7:	00 00 00 
  801eea:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  801ef1:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801ef4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801efb:	e9 9e 00 00 00       	jmp    801f9e <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801f00:	a1 50 50 80 00       	mov    0x805050,%eax
  801f05:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f08:	c1 e2 04             	shl    $0x4,%edx
  801f0b:	01 d0                	add    %edx,%eax
  801f0d:	85 c0                	test   %eax,%eax
  801f0f:	75 14                	jne    801f25 <initialize_MemBlocksList+0x55>
  801f11:	83 ec 04             	sub    $0x4,%esp
  801f14:	68 bc 3f 80 00       	push   $0x803fbc
  801f19:	6a 46                	push   $0x46
  801f1b:	68 df 3f 80 00       	push   $0x803fdf
  801f20:	e8 91 e3 ff ff       	call   8002b6 <_panic>
  801f25:	a1 50 50 80 00       	mov    0x805050,%eax
  801f2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f2d:	c1 e2 04             	shl    $0x4,%edx
  801f30:	01 d0                	add    %edx,%eax
  801f32:	8b 15 48 51 80 00    	mov    0x805148,%edx
  801f38:	89 10                	mov    %edx,(%eax)
  801f3a:	8b 00                	mov    (%eax),%eax
  801f3c:	85 c0                	test   %eax,%eax
  801f3e:	74 18                	je     801f58 <initialize_MemBlocksList+0x88>
  801f40:	a1 48 51 80 00       	mov    0x805148,%eax
  801f45:	8b 15 50 50 80 00    	mov    0x805050,%edx
  801f4b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801f4e:	c1 e1 04             	shl    $0x4,%ecx
  801f51:	01 ca                	add    %ecx,%edx
  801f53:	89 50 04             	mov    %edx,0x4(%eax)
  801f56:	eb 12                	jmp    801f6a <initialize_MemBlocksList+0x9a>
  801f58:	a1 50 50 80 00       	mov    0x805050,%eax
  801f5d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f60:	c1 e2 04             	shl    $0x4,%edx
  801f63:	01 d0                	add    %edx,%eax
  801f65:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801f6a:	a1 50 50 80 00       	mov    0x805050,%eax
  801f6f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f72:	c1 e2 04             	shl    $0x4,%edx
  801f75:	01 d0                	add    %edx,%eax
  801f77:	a3 48 51 80 00       	mov    %eax,0x805148
  801f7c:	a1 50 50 80 00       	mov    0x805050,%eax
  801f81:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f84:	c1 e2 04             	shl    $0x4,%edx
  801f87:	01 d0                	add    %edx,%eax
  801f89:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f90:	a1 54 51 80 00       	mov    0x805154,%eax
  801f95:	40                   	inc    %eax
  801f96:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801f9b:	ff 45 f4             	incl   -0xc(%ebp)
  801f9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa1:	3b 45 08             	cmp    0x8(%ebp),%eax
  801fa4:	0f 82 56 ff ff ff    	jb     801f00 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801faa:	90                   	nop
  801fab:	c9                   	leave  
  801fac:	c3                   	ret    

00801fad <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801fad:	55                   	push   %ebp
  801fae:	89 e5                	mov    %esp,%ebp
  801fb0:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb6:	8b 00                	mov    (%eax),%eax
  801fb8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801fbb:	eb 19                	jmp    801fd6 <find_block+0x29>
	{
		if(va==point->sva)
  801fbd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fc0:	8b 40 08             	mov    0x8(%eax),%eax
  801fc3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801fc6:	75 05                	jne    801fcd <find_block+0x20>
		   return point;
  801fc8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fcb:	eb 36                	jmp    802003 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801fcd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd0:	8b 40 08             	mov    0x8(%eax),%eax
  801fd3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801fd6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801fda:	74 07                	je     801fe3 <find_block+0x36>
  801fdc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fdf:	8b 00                	mov    (%eax),%eax
  801fe1:	eb 05                	jmp    801fe8 <find_block+0x3b>
  801fe3:	b8 00 00 00 00       	mov    $0x0,%eax
  801fe8:	8b 55 08             	mov    0x8(%ebp),%edx
  801feb:	89 42 08             	mov    %eax,0x8(%edx)
  801fee:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff1:	8b 40 08             	mov    0x8(%eax),%eax
  801ff4:	85 c0                	test   %eax,%eax
  801ff6:	75 c5                	jne    801fbd <find_block+0x10>
  801ff8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801ffc:	75 bf                	jne    801fbd <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  801ffe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802003:	c9                   	leave  
  802004:	c3                   	ret    

00802005 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802005:	55                   	push   %ebp
  802006:	89 e5                	mov    %esp,%ebp
  802008:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  80200b:	a1 40 50 80 00       	mov    0x805040,%eax
  802010:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802013:	a1 44 50 80 00       	mov    0x805044,%eax
  802018:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  80201b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80201e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802021:	74 24                	je     802047 <insert_sorted_allocList+0x42>
  802023:	8b 45 08             	mov    0x8(%ebp),%eax
  802026:	8b 50 08             	mov    0x8(%eax),%edx
  802029:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80202c:	8b 40 08             	mov    0x8(%eax),%eax
  80202f:	39 c2                	cmp    %eax,%edx
  802031:	76 14                	jbe    802047 <insert_sorted_allocList+0x42>
  802033:	8b 45 08             	mov    0x8(%ebp),%eax
  802036:	8b 50 08             	mov    0x8(%eax),%edx
  802039:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80203c:	8b 40 08             	mov    0x8(%eax),%eax
  80203f:	39 c2                	cmp    %eax,%edx
  802041:	0f 82 60 01 00 00    	jb     8021a7 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802047:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80204b:	75 65                	jne    8020b2 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  80204d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802051:	75 14                	jne    802067 <insert_sorted_allocList+0x62>
  802053:	83 ec 04             	sub    $0x4,%esp
  802056:	68 bc 3f 80 00       	push   $0x803fbc
  80205b:	6a 6b                	push   $0x6b
  80205d:	68 df 3f 80 00       	push   $0x803fdf
  802062:	e8 4f e2 ff ff       	call   8002b6 <_panic>
  802067:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80206d:	8b 45 08             	mov    0x8(%ebp),%eax
  802070:	89 10                	mov    %edx,(%eax)
  802072:	8b 45 08             	mov    0x8(%ebp),%eax
  802075:	8b 00                	mov    (%eax),%eax
  802077:	85 c0                	test   %eax,%eax
  802079:	74 0d                	je     802088 <insert_sorted_allocList+0x83>
  80207b:	a1 40 50 80 00       	mov    0x805040,%eax
  802080:	8b 55 08             	mov    0x8(%ebp),%edx
  802083:	89 50 04             	mov    %edx,0x4(%eax)
  802086:	eb 08                	jmp    802090 <insert_sorted_allocList+0x8b>
  802088:	8b 45 08             	mov    0x8(%ebp),%eax
  80208b:	a3 44 50 80 00       	mov    %eax,0x805044
  802090:	8b 45 08             	mov    0x8(%ebp),%eax
  802093:	a3 40 50 80 00       	mov    %eax,0x805040
  802098:	8b 45 08             	mov    0x8(%ebp),%eax
  80209b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020a2:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8020a7:	40                   	inc    %eax
  8020a8:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8020ad:	e9 dc 01 00 00       	jmp    80228e <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8020b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b5:	8b 50 08             	mov    0x8(%eax),%edx
  8020b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020bb:	8b 40 08             	mov    0x8(%eax),%eax
  8020be:	39 c2                	cmp    %eax,%edx
  8020c0:	77 6c                	ja     80212e <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8020c2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020c6:	74 06                	je     8020ce <insert_sorted_allocList+0xc9>
  8020c8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020cc:	75 14                	jne    8020e2 <insert_sorted_allocList+0xdd>
  8020ce:	83 ec 04             	sub    $0x4,%esp
  8020d1:	68 f8 3f 80 00       	push   $0x803ff8
  8020d6:	6a 6f                	push   $0x6f
  8020d8:	68 df 3f 80 00       	push   $0x803fdf
  8020dd:	e8 d4 e1 ff ff       	call   8002b6 <_panic>
  8020e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020e5:	8b 50 04             	mov    0x4(%eax),%edx
  8020e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020eb:	89 50 04             	mov    %edx,0x4(%eax)
  8020ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8020f4:	89 10                	mov    %edx,(%eax)
  8020f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020f9:	8b 40 04             	mov    0x4(%eax),%eax
  8020fc:	85 c0                	test   %eax,%eax
  8020fe:	74 0d                	je     80210d <insert_sorted_allocList+0x108>
  802100:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802103:	8b 40 04             	mov    0x4(%eax),%eax
  802106:	8b 55 08             	mov    0x8(%ebp),%edx
  802109:	89 10                	mov    %edx,(%eax)
  80210b:	eb 08                	jmp    802115 <insert_sorted_allocList+0x110>
  80210d:	8b 45 08             	mov    0x8(%ebp),%eax
  802110:	a3 40 50 80 00       	mov    %eax,0x805040
  802115:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802118:	8b 55 08             	mov    0x8(%ebp),%edx
  80211b:	89 50 04             	mov    %edx,0x4(%eax)
  80211e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802123:	40                   	inc    %eax
  802124:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802129:	e9 60 01 00 00       	jmp    80228e <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  80212e:	8b 45 08             	mov    0x8(%ebp),%eax
  802131:	8b 50 08             	mov    0x8(%eax),%edx
  802134:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802137:	8b 40 08             	mov    0x8(%eax),%eax
  80213a:	39 c2                	cmp    %eax,%edx
  80213c:	0f 82 4c 01 00 00    	jb     80228e <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802142:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802146:	75 14                	jne    80215c <insert_sorted_allocList+0x157>
  802148:	83 ec 04             	sub    $0x4,%esp
  80214b:	68 30 40 80 00       	push   $0x804030
  802150:	6a 73                	push   $0x73
  802152:	68 df 3f 80 00       	push   $0x803fdf
  802157:	e8 5a e1 ff ff       	call   8002b6 <_panic>
  80215c:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802162:	8b 45 08             	mov    0x8(%ebp),%eax
  802165:	89 50 04             	mov    %edx,0x4(%eax)
  802168:	8b 45 08             	mov    0x8(%ebp),%eax
  80216b:	8b 40 04             	mov    0x4(%eax),%eax
  80216e:	85 c0                	test   %eax,%eax
  802170:	74 0c                	je     80217e <insert_sorted_allocList+0x179>
  802172:	a1 44 50 80 00       	mov    0x805044,%eax
  802177:	8b 55 08             	mov    0x8(%ebp),%edx
  80217a:	89 10                	mov    %edx,(%eax)
  80217c:	eb 08                	jmp    802186 <insert_sorted_allocList+0x181>
  80217e:	8b 45 08             	mov    0x8(%ebp),%eax
  802181:	a3 40 50 80 00       	mov    %eax,0x805040
  802186:	8b 45 08             	mov    0x8(%ebp),%eax
  802189:	a3 44 50 80 00       	mov    %eax,0x805044
  80218e:	8b 45 08             	mov    0x8(%ebp),%eax
  802191:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802197:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80219c:	40                   	inc    %eax
  80219d:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8021a2:	e9 e7 00 00 00       	jmp    80228e <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8021a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8021ad:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8021b4:	a1 40 50 80 00       	mov    0x805040,%eax
  8021b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021bc:	e9 9d 00 00 00       	jmp    80225e <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8021c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c4:	8b 00                	mov    (%eax),%eax
  8021c6:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8021c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cc:	8b 50 08             	mov    0x8(%eax),%edx
  8021cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d2:	8b 40 08             	mov    0x8(%eax),%eax
  8021d5:	39 c2                	cmp    %eax,%edx
  8021d7:	76 7d                	jbe    802256 <insert_sorted_allocList+0x251>
  8021d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021dc:	8b 50 08             	mov    0x8(%eax),%edx
  8021df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8021e2:	8b 40 08             	mov    0x8(%eax),%eax
  8021e5:	39 c2                	cmp    %eax,%edx
  8021e7:	73 6d                	jae    802256 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8021e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021ed:	74 06                	je     8021f5 <insert_sorted_allocList+0x1f0>
  8021ef:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021f3:	75 14                	jne    802209 <insert_sorted_allocList+0x204>
  8021f5:	83 ec 04             	sub    $0x4,%esp
  8021f8:	68 54 40 80 00       	push   $0x804054
  8021fd:	6a 7f                	push   $0x7f
  8021ff:	68 df 3f 80 00       	push   $0x803fdf
  802204:	e8 ad e0 ff ff       	call   8002b6 <_panic>
  802209:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80220c:	8b 10                	mov    (%eax),%edx
  80220e:	8b 45 08             	mov    0x8(%ebp),%eax
  802211:	89 10                	mov    %edx,(%eax)
  802213:	8b 45 08             	mov    0x8(%ebp),%eax
  802216:	8b 00                	mov    (%eax),%eax
  802218:	85 c0                	test   %eax,%eax
  80221a:	74 0b                	je     802227 <insert_sorted_allocList+0x222>
  80221c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80221f:	8b 00                	mov    (%eax),%eax
  802221:	8b 55 08             	mov    0x8(%ebp),%edx
  802224:	89 50 04             	mov    %edx,0x4(%eax)
  802227:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80222a:	8b 55 08             	mov    0x8(%ebp),%edx
  80222d:	89 10                	mov    %edx,(%eax)
  80222f:	8b 45 08             	mov    0x8(%ebp),%eax
  802232:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802235:	89 50 04             	mov    %edx,0x4(%eax)
  802238:	8b 45 08             	mov    0x8(%ebp),%eax
  80223b:	8b 00                	mov    (%eax),%eax
  80223d:	85 c0                	test   %eax,%eax
  80223f:	75 08                	jne    802249 <insert_sorted_allocList+0x244>
  802241:	8b 45 08             	mov    0x8(%ebp),%eax
  802244:	a3 44 50 80 00       	mov    %eax,0x805044
  802249:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80224e:	40                   	inc    %eax
  80224f:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802254:	eb 39                	jmp    80228f <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802256:	a1 48 50 80 00       	mov    0x805048,%eax
  80225b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80225e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802262:	74 07                	je     80226b <insert_sorted_allocList+0x266>
  802264:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802267:	8b 00                	mov    (%eax),%eax
  802269:	eb 05                	jmp    802270 <insert_sorted_allocList+0x26b>
  80226b:	b8 00 00 00 00       	mov    $0x0,%eax
  802270:	a3 48 50 80 00       	mov    %eax,0x805048
  802275:	a1 48 50 80 00       	mov    0x805048,%eax
  80227a:	85 c0                	test   %eax,%eax
  80227c:	0f 85 3f ff ff ff    	jne    8021c1 <insert_sorted_allocList+0x1bc>
  802282:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802286:	0f 85 35 ff ff ff    	jne    8021c1 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80228c:	eb 01                	jmp    80228f <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80228e:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80228f:	90                   	nop
  802290:	c9                   	leave  
  802291:	c3                   	ret    

00802292 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802292:	55                   	push   %ebp
  802293:	89 e5                	mov    %esp,%ebp
  802295:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802298:	a1 38 51 80 00       	mov    0x805138,%eax
  80229d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022a0:	e9 85 01 00 00       	jmp    80242a <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8022a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a8:	8b 40 0c             	mov    0xc(%eax),%eax
  8022ab:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022ae:	0f 82 6e 01 00 00    	jb     802422 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8022b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b7:	8b 40 0c             	mov    0xc(%eax),%eax
  8022ba:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022bd:	0f 85 8a 00 00 00    	jne    80234d <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8022c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022c7:	75 17                	jne    8022e0 <alloc_block_FF+0x4e>
  8022c9:	83 ec 04             	sub    $0x4,%esp
  8022cc:	68 88 40 80 00       	push   $0x804088
  8022d1:	68 93 00 00 00       	push   $0x93
  8022d6:	68 df 3f 80 00       	push   $0x803fdf
  8022db:	e8 d6 df ff ff       	call   8002b6 <_panic>
  8022e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e3:	8b 00                	mov    (%eax),%eax
  8022e5:	85 c0                	test   %eax,%eax
  8022e7:	74 10                	je     8022f9 <alloc_block_FF+0x67>
  8022e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ec:	8b 00                	mov    (%eax),%eax
  8022ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022f1:	8b 52 04             	mov    0x4(%edx),%edx
  8022f4:	89 50 04             	mov    %edx,0x4(%eax)
  8022f7:	eb 0b                	jmp    802304 <alloc_block_FF+0x72>
  8022f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022fc:	8b 40 04             	mov    0x4(%eax),%eax
  8022ff:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802304:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802307:	8b 40 04             	mov    0x4(%eax),%eax
  80230a:	85 c0                	test   %eax,%eax
  80230c:	74 0f                	je     80231d <alloc_block_FF+0x8b>
  80230e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802311:	8b 40 04             	mov    0x4(%eax),%eax
  802314:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802317:	8b 12                	mov    (%edx),%edx
  802319:	89 10                	mov    %edx,(%eax)
  80231b:	eb 0a                	jmp    802327 <alloc_block_FF+0x95>
  80231d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802320:	8b 00                	mov    (%eax),%eax
  802322:	a3 38 51 80 00       	mov    %eax,0x805138
  802327:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802330:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802333:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80233a:	a1 44 51 80 00       	mov    0x805144,%eax
  80233f:	48                   	dec    %eax
  802340:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802345:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802348:	e9 10 01 00 00       	jmp    80245d <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  80234d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802350:	8b 40 0c             	mov    0xc(%eax),%eax
  802353:	3b 45 08             	cmp    0x8(%ebp),%eax
  802356:	0f 86 c6 00 00 00    	jbe    802422 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80235c:	a1 48 51 80 00       	mov    0x805148,%eax
  802361:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802364:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802367:	8b 50 08             	mov    0x8(%eax),%edx
  80236a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80236d:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802370:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802373:	8b 55 08             	mov    0x8(%ebp),%edx
  802376:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802379:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80237d:	75 17                	jne    802396 <alloc_block_FF+0x104>
  80237f:	83 ec 04             	sub    $0x4,%esp
  802382:	68 88 40 80 00       	push   $0x804088
  802387:	68 9b 00 00 00       	push   $0x9b
  80238c:	68 df 3f 80 00       	push   $0x803fdf
  802391:	e8 20 df ff ff       	call   8002b6 <_panic>
  802396:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802399:	8b 00                	mov    (%eax),%eax
  80239b:	85 c0                	test   %eax,%eax
  80239d:	74 10                	je     8023af <alloc_block_FF+0x11d>
  80239f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023a2:	8b 00                	mov    (%eax),%eax
  8023a4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023a7:	8b 52 04             	mov    0x4(%edx),%edx
  8023aa:	89 50 04             	mov    %edx,0x4(%eax)
  8023ad:	eb 0b                	jmp    8023ba <alloc_block_FF+0x128>
  8023af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023b2:	8b 40 04             	mov    0x4(%eax),%eax
  8023b5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8023ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023bd:	8b 40 04             	mov    0x4(%eax),%eax
  8023c0:	85 c0                	test   %eax,%eax
  8023c2:	74 0f                	je     8023d3 <alloc_block_FF+0x141>
  8023c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023c7:	8b 40 04             	mov    0x4(%eax),%eax
  8023ca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023cd:	8b 12                	mov    (%edx),%edx
  8023cf:	89 10                	mov    %edx,(%eax)
  8023d1:	eb 0a                	jmp    8023dd <alloc_block_FF+0x14b>
  8023d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023d6:	8b 00                	mov    (%eax),%eax
  8023d8:	a3 48 51 80 00       	mov    %eax,0x805148
  8023dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023e9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023f0:	a1 54 51 80 00       	mov    0x805154,%eax
  8023f5:	48                   	dec    %eax
  8023f6:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  8023fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fe:	8b 50 08             	mov    0x8(%eax),%edx
  802401:	8b 45 08             	mov    0x8(%ebp),%eax
  802404:	01 c2                	add    %eax,%edx
  802406:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802409:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  80240c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240f:	8b 40 0c             	mov    0xc(%eax),%eax
  802412:	2b 45 08             	sub    0x8(%ebp),%eax
  802415:	89 c2                	mov    %eax,%edx
  802417:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241a:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  80241d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802420:	eb 3b                	jmp    80245d <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802422:	a1 40 51 80 00       	mov    0x805140,%eax
  802427:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80242a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80242e:	74 07                	je     802437 <alloc_block_FF+0x1a5>
  802430:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802433:	8b 00                	mov    (%eax),%eax
  802435:	eb 05                	jmp    80243c <alloc_block_FF+0x1aa>
  802437:	b8 00 00 00 00       	mov    $0x0,%eax
  80243c:	a3 40 51 80 00       	mov    %eax,0x805140
  802441:	a1 40 51 80 00       	mov    0x805140,%eax
  802446:	85 c0                	test   %eax,%eax
  802448:	0f 85 57 fe ff ff    	jne    8022a5 <alloc_block_FF+0x13>
  80244e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802452:	0f 85 4d fe ff ff    	jne    8022a5 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802458:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80245d:	c9                   	leave  
  80245e:	c3                   	ret    

0080245f <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80245f:	55                   	push   %ebp
  802460:	89 e5                	mov    %esp,%ebp
  802462:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802465:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80246c:	a1 38 51 80 00       	mov    0x805138,%eax
  802471:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802474:	e9 df 00 00 00       	jmp    802558 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802479:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247c:	8b 40 0c             	mov    0xc(%eax),%eax
  80247f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802482:	0f 82 c8 00 00 00    	jb     802550 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802488:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248b:	8b 40 0c             	mov    0xc(%eax),%eax
  80248e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802491:	0f 85 8a 00 00 00    	jne    802521 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802497:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80249b:	75 17                	jne    8024b4 <alloc_block_BF+0x55>
  80249d:	83 ec 04             	sub    $0x4,%esp
  8024a0:	68 88 40 80 00       	push   $0x804088
  8024a5:	68 b7 00 00 00       	push   $0xb7
  8024aa:	68 df 3f 80 00       	push   $0x803fdf
  8024af:	e8 02 de ff ff       	call   8002b6 <_panic>
  8024b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b7:	8b 00                	mov    (%eax),%eax
  8024b9:	85 c0                	test   %eax,%eax
  8024bb:	74 10                	je     8024cd <alloc_block_BF+0x6e>
  8024bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c0:	8b 00                	mov    (%eax),%eax
  8024c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024c5:	8b 52 04             	mov    0x4(%edx),%edx
  8024c8:	89 50 04             	mov    %edx,0x4(%eax)
  8024cb:	eb 0b                	jmp    8024d8 <alloc_block_BF+0x79>
  8024cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d0:	8b 40 04             	mov    0x4(%eax),%eax
  8024d3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8024d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024db:	8b 40 04             	mov    0x4(%eax),%eax
  8024de:	85 c0                	test   %eax,%eax
  8024e0:	74 0f                	je     8024f1 <alloc_block_BF+0x92>
  8024e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e5:	8b 40 04             	mov    0x4(%eax),%eax
  8024e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024eb:	8b 12                	mov    (%edx),%edx
  8024ed:	89 10                	mov    %edx,(%eax)
  8024ef:	eb 0a                	jmp    8024fb <alloc_block_BF+0x9c>
  8024f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f4:	8b 00                	mov    (%eax),%eax
  8024f6:	a3 38 51 80 00       	mov    %eax,0x805138
  8024fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802504:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802507:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80250e:	a1 44 51 80 00       	mov    0x805144,%eax
  802513:	48                   	dec    %eax
  802514:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802519:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251c:	e9 4d 01 00 00       	jmp    80266e <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802521:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802524:	8b 40 0c             	mov    0xc(%eax),%eax
  802527:	3b 45 08             	cmp    0x8(%ebp),%eax
  80252a:	76 24                	jbe    802550 <alloc_block_BF+0xf1>
  80252c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252f:	8b 40 0c             	mov    0xc(%eax),%eax
  802532:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802535:	73 19                	jae    802550 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802537:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  80253e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802541:	8b 40 0c             	mov    0xc(%eax),%eax
  802544:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802547:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254a:	8b 40 08             	mov    0x8(%eax),%eax
  80254d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802550:	a1 40 51 80 00       	mov    0x805140,%eax
  802555:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802558:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80255c:	74 07                	je     802565 <alloc_block_BF+0x106>
  80255e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802561:	8b 00                	mov    (%eax),%eax
  802563:	eb 05                	jmp    80256a <alloc_block_BF+0x10b>
  802565:	b8 00 00 00 00       	mov    $0x0,%eax
  80256a:	a3 40 51 80 00       	mov    %eax,0x805140
  80256f:	a1 40 51 80 00       	mov    0x805140,%eax
  802574:	85 c0                	test   %eax,%eax
  802576:	0f 85 fd fe ff ff    	jne    802479 <alloc_block_BF+0x1a>
  80257c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802580:	0f 85 f3 fe ff ff    	jne    802479 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802586:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80258a:	0f 84 d9 00 00 00    	je     802669 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802590:	a1 48 51 80 00       	mov    0x805148,%eax
  802595:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802598:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80259b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80259e:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8025a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8025a7:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8025aa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8025ae:	75 17                	jne    8025c7 <alloc_block_BF+0x168>
  8025b0:	83 ec 04             	sub    $0x4,%esp
  8025b3:	68 88 40 80 00       	push   $0x804088
  8025b8:	68 c7 00 00 00       	push   $0xc7
  8025bd:	68 df 3f 80 00       	push   $0x803fdf
  8025c2:	e8 ef dc ff ff       	call   8002b6 <_panic>
  8025c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025ca:	8b 00                	mov    (%eax),%eax
  8025cc:	85 c0                	test   %eax,%eax
  8025ce:	74 10                	je     8025e0 <alloc_block_BF+0x181>
  8025d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025d3:	8b 00                	mov    (%eax),%eax
  8025d5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025d8:	8b 52 04             	mov    0x4(%edx),%edx
  8025db:	89 50 04             	mov    %edx,0x4(%eax)
  8025de:	eb 0b                	jmp    8025eb <alloc_block_BF+0x18c>
  8025e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025e3:	8b 40 04             	mov    0x4(%eax),%eax
  8025e6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8025eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025ee:	8b 40 04             	mov    0x4(%eax),%eax
  8025f1:	85 c0                	test   %eax,%eax
  8025f3:	74 0f                	je     802604 <alloc_block_BF+0x1a5>
  8025f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025f8:	8b 40 04             	mov    0x4(%eax),%eax
  8025fb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025fe:	8b 12                	mov    (%edx),%edx
  802600:	89 10                	mov    %edx,(%eax)
  802602:	eb 0a                	jmp    80260e <alloc_block_BF+0x1af>
  802604:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802607:	8b 00                	mov    (%eax),%eax
  802609:	a3 48 51 80 00       	mov    %eax,0x805148
  80260e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802611:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802617:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80261a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802621:	a1 54 51 80 00       	mov    0x805154,%eax
  802626:	48                   	dec    %eax
  802627:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  80262c:	83 ec 08             	sub    $0x8,%esp
  80262f:	ff 75 ec             	pushl  -0x14(%ebp)
  802632:	68 38 51 80 00       	push   $0x805138
  802637:	e8 71 f9 ff ff       	call   801fad <find_block>
  80263c:	83 c4 10             	add    $0x10,%esp
  80263f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802642:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802645:	8b 50 08             	mov    0x8(%eax),%edx
  802648:	8b 45 08             	mov    0x8(%ebp),%eax
  80264b:	01 c2                	add    %eax,%edx
  80264d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802650:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802653:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802656:	8b 40 0c             	mov    0xc(%eax),%eax
  802659:	2b 45 08             	sub    0x8(%ebp),%eax
  80265c:	89 c2                	mov    %eax,%edx
  80265e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802661:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802664:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802667:	eb 05                	jmp    80266e <alloc_block_BF+0x20f>
	}
	return NULL;
  802669:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80266e:	c9                   	leave  
  80266f:	c3                   	ret    

00802670 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802670:	55                   	push   %ebp
  802671:	89 e5                	mov    %esp,%ebp
  802673:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802676:	a1 28 50 80 00       	mov    0x805028,%eax
  80267b:	85 c0                	test   %eax,%eax
  80267d:	0f 85 de 01 00 00    	jne    802861 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802683:	a1 38 51 80 00       	mov    0x805138,%eax
  802688:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80268b:	e9 9e 01 00 00       	jmp    80282e <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802690:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802693:	8b 40 0c             	mov    0xc(%eax),%eax
  802696:	3b 45 08             	cmp    0x8(%ebp),%eax
  802699:	0f 82 87 01 00 00    	jb     802826 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  80269f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a2:	8b 40 0c             	mov    0xc(%eax),%eax
  8026a5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026a8:	0f 85 95 00 00 00    	jne    802743 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8026ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026b2:	75 17                	jne    8026cb <alloc_block_NF+0x5b>
  8026b4:	83 ec 04             	sub    $0x4,%esp
  8026b7:	68 88 40 80 00       	push   $0x804088
  8026bc:	68 e0 00 00 00       	push   $0xe0
  8026c1:	68 df 3f 80 00       	push   $0x803fdf
  8026c6:	e8 eb db ff ff       	call   8002b6 <_panic>
  8026cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ce:	8b 00                	mov    (%eax),%eax
  8026d0:	85 c0                	test   %eax,%eax
  8026d2:	74 10                	je     8026e4 <alloc_block_NF+0x74>
  8026d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d7:	8b 00                	mov    (%eax),%eax
  8026d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026dc:	8b 52 04             	mov    0x4(%edx),%edx
  8026df:	89 50 04             	mov    %edx,0x4(%eax)
  8026e2:	eb 0b                	jmp    8026ef <alloc_block_NF+0x7f>
  8026e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e7:	8b 40 04             	mov    0x4(%eax),%eax
  8026ea:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8026ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f2:	8b 40 04             	mov    0x4(%eax),%eax
  8026f5:	85 c0                	test   %eax,%eax
  8026f7:	74 0f                	je     802708 <alloc_block_NF+0x98>
  8026f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fc:	8b 40 04             	mov    0x4(%eax),%eax
  8026ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802702:	8b 12                	mov    (%edx),%edx
  802704:	89 10                	mov    %edx,(%eax)
  802706:	eb 0a                	jmp    802712 <alloc_block_NF+0xa2>
  802708:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270b:	8b 00                	mov    (%eax),%eax
  80270d:	a3 38 51 80 00       	mov    %eax,0x805138
  802712:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802715:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80271b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802725:	a1 44 51 80 00       	mov    0x805144,%eax
  80272a:	48                   	dec    %eax
  80272b:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802730:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802733:	8b 40 08             	mov    0x8(%eax),%eax
  802736:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  80273b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273e:	e9 f8 04 00 00       	jmp    802c3b <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802743:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802746:	8b 40 0c             	mov    0xc(%eax),%eax
  802749:	3b 45 08             	cmp    0x8(%ebp),%eax
  80274c:	0f 86 d4 00 00 00    	jbe    802826 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802752:	a1 48 51 80 00       	mov    0x805148,%eax
  802757:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  80275a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275d:	8b 50 08             	mov    0x8(%eax),%edx
  802760:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802763:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802766:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802769:	8b 55 08             	mov    0x8(%ebp),%edx
  80276c:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80276f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802773:	75 17                	jne    80278c <alloc_block_NF+0x11c>
  802775:	83 ec 04             	sub    $0x4,%esp
  802778:	68 88 40 80 00       	push   $0x804088
  80277d:	68 e9 00 00 00       	push   $0xe9
  802782:	68 df 3f 80 00       	push   $0x803fdf
  802787:	e8 2a db ff ff       	call   8002b6 <_panic>
  80278c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80278f:	8b 00                	mov    (%eax),%eax
  802791:	85 c0                	test   %eax,%eax
  802793:	74 10                	je     8027a5 <alloc_block_NF+0x135>
  802795:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802798:	8b 00                	mov    (%eax),%eax
  80279a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80279d:	8b 52 04             	mov    0x4(%edx),%edx
  8027a0:	89 50 04             	mov    %edx,0x4(%eax)
  8027a3:	eb 0b                	jmp    8027b0 <alloc_block_NF+0x140>
  8027a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027a8:	8b 40 04             	mov    0x4(%eax),%eax
  8027ab:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8027b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027b3:	8b 40 04             	mov    0x4(%eax),%eax
  8027b6:	85 c0                	test   %eax,%eax
  8027b8:	74 0f                	je     8027c9 <alloc_block_NF+0x159>
  8027ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027bd:	8b 40 04             	mov    0x4(%eax),%eax
  8027c0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027c3:	8b 12                	mov    (%edx),%edx
  8027c5:	89 10                	mov    %edx,(%eax)
  8027c7:	eb 0a                	jmp    8027d3 <alloc_block_NF+0x163>
  8027c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027cc:	8b 00                	mov    (%eax),%eax
  8027ce:	a3 48 51 80 00       	mov    %eax,0x805148
  8027d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027df:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027e6:	a1 54 51 80 00       	mov    0x805154,%eax
  8027eb:	48                   	dec    %eax
  8027ec:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  8027f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f4:	8b 40 08             	mov    0x8(%eax),%eax
  8027f7:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  8027fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ff:	8b 50 08             	mov    0x8(%eax),%edx
  802802:	8b 45 08             	mov    0x8(%ebp),%eax
  802805:	01 c2                	add    %eax,%edx
  802807:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280a:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  80280d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802810:	8b 40 0c             	mov    0xc(%eax),%eax
  802813:	2b 45 08             	sub    0x8(%ebp),%eax
  802816:	89 c2                	mov    %eax,%edx
  802818:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281b:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  80281e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802821:	e9 15 04 00 00       	jmp    802c3b <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802826:	a1 40 51 80 00       	mov    0x805140,%eax
  80282b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80282e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802832:	74 07                	je     80283b <alloc_block_NF+0x1cb>
  802834:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802837:	8b 00                	mov    (%eax),%eax
  802839:	eb 05                	jmp    802840 <alloc_block_NF+0x1d0>
  80283b:	b8 00 00 00 00       	mov    $0x0,%eax
  802840:	a3 40 51 80 00       	mov    %eax,0x805140
  802845:	a1 40 51 80 00       	mov    0x805140,%eax
  80284a:	85 c0                	test   %eax,%eax
  80284c:	0f 85 3e fe ff ff    	jne    802690 <alloc_block_NF+0x20>
  802852:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802856:	0f 85 34 fe ff ff    	jne    802690 <alloc_block_NF+0x20>
  80285c:	e9 d5 03 00 00       	jmp    802c36 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802861:	a1 38 51 80 00       	mov    0x805138,%eax
  802866:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802869:	e9 b1 01 00 00       	jmp    802a1f <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  80286e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802871:	8b 50 08             	mov    0x8(%eax),%edx
  802874:	a1 28 50 80 00       	mov    0x805028,%eax
  802879:	39 c2                	cmp    %eax,%edx
  80287b:	0f 82 96 01 00 00    	jb     802a17 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802881:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802884:	8b 40 0c             	mov    0xc(%eax),%eax
  802887:	3b 45 08             	cmp    0x8(%ebp),%eax
  80288a:	0f 82 87 01 00 00    	jb     802a17 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802890:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802893:	8b 40 0c             	mov    0xc(%eax),%eax
  802896:	3b 45 08             	cmp    0x8(%ebp),%eax
  802899:	0f 85 95 00 00 00    	jne    802934 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80289f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028a3:	75 17                	jne    8028bc <alloc_block_NF+0x24c>
  8028a5:	83 ec 04             	sub    $0x4,%esp
  8028a8:	68 88 40 80 00       	push   $0x804088
  8028ad:	68 fc 00 00 00       	push   $0xfc
  8028b2:	68 df 3f 80 00       	push   $0x803fdf
  8028b7:	e8 fa d9 ff ff       	call   8002b6 <_panic>
  8028bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bf:	8b 00                	mov    (%eax),%eax
  8028c1:	85 c0                	test   %eax,%eax
  8028c3:	74 10                	je     8028d5 <alloc_block_NF+0x265>
  8028c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c8:	8b 00                	mov    (%eax),%eax
  8028ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028cd:	8b 52 04             	mov    0x4(%edx),%edx
  8028d0:	89 50 04             	mov    %edx,0x4(%eax)
  8028d3:	eb 0b                	jmp    8028e0 <alloc_block_NF+0x270>
  8028d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d8:	8b 40 04             	mov    0x4(%eax),%eax
  8028db:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8028e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e3:	8b 40 04             	mov    0x4(%eax),%eax
  8028e6:	85 c0                	test   %eax,%eax
  8028e8:	74 0f                	je     8028f9 <alloc_block_NF+0x289>
  8028ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ed:	8b 40 04             	mov    0x4(%eax),%eax
  8028f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028f3:	8b 12                	mov    (%edx),%edx
  8028f5:	89 10                	mov    %edx,(%eax)
  8028f7:	eb 0a                	jmp    802903 <alloc_block_NF+0x293>
  8028f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fc:	8b 00                	mov    (%eax),%eax
  8028fe:	a3 38 51 80 00       	mov    %eax,0x805138
  802903:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802906:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80290c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802916:	a1 44 51 80 00       	mov    0x805144,%eax
  80291b:	48                   	dec    %eax
  80291c:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802921:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802924:	8b 40 08             	mov    0x8(%eax),%eax
  802927:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  80292c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292f:	e9 07 03 00 00       	jmp    802c3b <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802934:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802937:	8b 40 0c             	mov    0xc(%eax),%eax
  80293a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80293d:	0f 86 d4 00 00 00    	jbe    802a17 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802943:	a1 48 51 80 00       	mov    0x805148,%eax
  802948:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  80294b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294e:	8b 50 08             	mov    0x8(%eax),%edx
  802951:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802954:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802957:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80295a:	8b 55 08             	mov    0x8(%ebp),%edx
  80295d:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802960:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802964:	75 17                	jne    80297d <alloc_block_NF+0x30d>
  802966:	83 ec 04             	sub    $0x4,%esp
  802969:	68 88 40 80 00       	push   $0x804088
  80296e:	68 04 01 00 00       	push   $0x104
  802973:	68 df 3f 80 00       	push   $0x803fdf
  802978:	e8 39 d9 ff ff       	call   8002b6 <_panic>
  80297d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802980:	8b 00                	mov    (%eax),%eax
  802982:	85 c0                	test   %eax,%eax
  802984:	74 10                	je     802996 <alloc_block_NF+0x326>
  802986:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802989:	8b 00                	mov    (%eax),%eax
  80298b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80298e:	8b 52 04             	mov    0x4(%edx),%edx
  802991:	89 50 04             	mov    %edx,0x4(%eax)
  802994:	eb 0b                	jmp    8029a1 <alloc_block_NF+0x331>
  802996:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802999:	8b 40 04             	mov    0x4(%eax),%eax
  80299c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8029a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029a4:	8b 40 04             	mov    0x4(%eax),%eax
  8029a7:	85 c0                	test   %eax,%eax
  8029a9:	74 0f                	je     8029ba <alloc_block_NF+0x34a>
  8029ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029ae:	8b 40 04             	mov    0x4(%eax),%eax
  8029b1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8029b4:	8b 12                	mov    (%edx),%edx
  8029b6:	89 10                	mov    %edx,(%eax)
  8029b8:	eb 0a                	jmp    8029c4 <alloc_block_NF+0x354>
  8029ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029bd:	8b 00                	mov    (%eax),%eax
  8029bf:	a3 48 51 80 00       	mov    %eax,0x805148
  8029c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029c7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029d0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029d7:	a1 54 51 80 00       	mov    0x805154,%eax
  8029dc:	48                   	dec    %eax
  8029dd:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  8029e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029e5:	8b 40 08             	mov    0x8(%eax),%eax
  8029e8:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  8029ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f0:	8b 50 08             	mov    0x8(%eax),%edx
  8029f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f6:	01 c2                	add    %eax,%edx
  8029f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fb:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8029fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a01:	8b 40 0c             	mov    0xc(%eax),%eax
  802a04:	2b 45 08             	sub    0x8(%ebp),%eax
  802a07:	89 c2                	mov    %eax,%edx
  802a09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0c:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802a0f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a12:	e9 24 02 00 00       	jmp    802c3b <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a17:	a1 40 51 80 00       	mov    0x805140,%eax
  802a1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a1f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a23:	74 07                	je     802a2c <alloc_block_NF+0x3bc>
  802a25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a28:	8b 00                	mov    (%eax),%eax
  802a2a:	eb 05                	jmp    802a31 <alloc_block_NF+0x3c1>
  802a2c:	b8 00 00 00 00       	mov    $0x0,%eax
  802a31:	a3 40 51 80 00       	mov    %eax,0x805140
  802a36:	a1 40 51 80 00       	mov    0x805140,%eax
  802a3b:	85 c0                	test   %eax,%eax
  802a3d:	0f 85 2b fe ff ff    	jne    80286e <alloc_block_NF+0x1fe>
  802a43:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a47:	0f 85 21 fe ff ff    	jne    80286e <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a4d:	a1 38 51 80 00       	mov    0x805138,%eax
  802a52:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a55:	e9 ae 01 00 00       	jmp    802c08 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802a5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5d:	8b 50 08             	mov    0x8(%eax),%edx
  802a60:	a1 28 50 80 00       	mov    0x805028,%eax
  802a65:	39 c2                	cmp    %eax,%edx
  802a67:	0f 83 93 01 00 00    	jae    802c00 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802a6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a70:	8b 40 0c             	mov    0xc(%eax),%eax
  802a73:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a76:	0f 82 84 01 00 00    	jb     802c00 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802a7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7f:	8b 40 0c             	mov    0xc(%eax),%eax
  802a82:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a85:	0f 85 95 00 00 00    	jne    802b20 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802a8b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a8f:	75 17                	jne    802aa8 <alloc_block_NF+0x438>
  802a91:	83 ec 04             	sub    $0x4,%esp
  802a94:	68 88 40 80 00       	push   $0x804088
  802a99:	68 14 01 00 00       	push   $0x114
  802a9e:	68 df 3f 80 00       	push   $0x803fdf
  802aa3:	e8 0e d8 ff ff       	call   8002b6 <_panic>
  802aa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aab:	8b 00                	mov    (%eax),%eax
  802aad:	85 c0                	test   %eax,%eax
  802aaf:	74 10                	je     802ac1 <alloc_block_NF+0x451>
  802ab1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab4:	8b 00                	mov    (%eax),%eax
  802ab6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ab9:	8b 52 04             	mov    0x4(%edx),%edx
  802abc:	89 50 04             	mov    %edx,0x4(%eax)
  802abf:	eb 0b                	jmp    802acc <alloc_block_NF+0x45c>
  802ac1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac4:	8b 40 04             	mov    0x4(%eax),%eax
  802ac7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802acc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acf:	8b 40 04             	mov    0x4(%eax),%eax
  802ad2:	85 c0                	test   %eax,%eax
  802ad4:	74 0f                	je     802ae5 <alloc_block_NF+0x475>
  802ad6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad9:	8b 40 04             	mov    0x4(%eax),%eax
  802adc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802adf:	8b 12                	mov    (%edx),%edx
  802ae1:	89 10                	mov    %edx,(%eax)
  802ae3:	eb 0a                	jmp    802aef <alloc_block_NF+0x47f>
  802ae5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae8:	8b 00                	mov    (%eax),%eax
  802aea:	a3 38 51 80 00       	mov    %eax,0x805138
  802aef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802af8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b02:	a1 44 51 80 00       	mov    0x805144,%eax
  802b07:	48                   	dec    %eax
  802b08:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802b0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b10:	8b 40 08             	mov    0x8(%eax),%eax
  802b13:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802b18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1b:	e9 1b 01 00 00       	jmp    802c3b <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802b20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b23:	8b 40 0c             	mov    0xc(%eax),%eax
  802b26:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b29:	0f 86 d1 00 00 00    	jbe    802c00 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b2f:	a1 48 51 80 00       	mov    0x805148,%eax
  802b34:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802b37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3a:	8b 50 08             	mov    0x8(%eax),%edx
  802b3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b40:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802b43:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b46:	8b 55 08             	mov    0x8(%ebp),%edx
  802b49:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b4c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b50:	75 17                	jne    802b69 <alloc_block_NF+0x4f9>
  802b52:	83 ec 04             	sub    $0x4,%esp
  802b55:	68 88 40 80 00       	push   $0x804088
  802b5a:	68 1c 01 00 00       	push   $0x11c
  802b5f:	68 df 3f 80 00       	push   $0x803fdf
  802b64:	e8 4d d7 ff ff       	call   8002b6 <_panic>
  802b69:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b6c:	8b 00                	mov    (%eax),%eax
  802b6e:	85 c0                	test   %eax,%eax
  802b70:	74 10                	je     802b82 <alloc_block_NF+0x512>
  802b72:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b75:	8b 00                	mov    (%eax),%eax
  802b77:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b7a:	8b 52 04             	mov    0x4(%edx),%edx
  802b7d:	89 50 04             	mov    %edx,0x4(%eax)
  802b80:	eb 0b                	jmp    802b8d <alloc_block_NF+0x51d>
  802b82:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b85:	8b 40 04             	mov    0x4(%eax),%eax
  802b88:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b8d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b90:	8b 40 04             	mov    0x4(%eax),%eax
  802b93:	85 c0                	test   %eax,%eax
  802b95:	74 0f                	je     802ba6 <alloc_block_NF+0x536>
  802b97:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b9a:	8b 40 04             	mov    0x4(%eax),%eax
  802b9d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ba0:	8b 12                	mov    (%edx),%edx
  802ba2:	89 10                	mov    %edx,(%eax)
  802ba4:	eb 0a                	jmp    802bb0 <alloc_block_NF+0x540>
  802ba6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ba9:	8b 00                	mov    (%eax),%eax
  802bab:	a3 48 51 80 00       	mov    %eax,0x805148
  802bb0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bb3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bb9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bbc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bc3:	a1 54 51 80 00       	mov    0x805154,%eax
  802bc8:	48                   	dec    %eax
  802bc9:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802bce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bd1:	8b 40 08             	mov    0x8(%eax),%eax
  802bd4:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802bd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bdc:	8b 50 08             	mov    0x8(%eax),%edx
  802bdf:	8b 45 08             	mov    0x8(%ebp),%eax
  802be2:	01 c2                	add    %eax,%edx
  802be4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be7:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802bea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bed:	8b 40 0c             	mov    0xc(%eax),%eax
  802bf0:	2b 45 08             	sub    0x8(%ebp),%eax
  802bf3:	89 c2                	mov    %eax,%edx
  802bf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf8:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802bfb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bfe:	eb 3b                	jmp    802c3b <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c00:	a1 40 51 80 00       	mov    0x805140,%eax
  802c05:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c08:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c0c:	74 07                	je     802c15 <alloc_block_NF+0x5a5>
  802c0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c11:	8b 00                	mov    (%eax),%eax
  802c13:	eb 05                	jmp    802c1a <alloc_block_NF+0x5aa>
  802c15:	b8 00 00 00 00       	mov    $0x0,%eax
  802c1a:	a3 40 51 80 00       	mov    %eax,0x805140
  802c1f:	a1 40 51 80 00       	mov    0x805140,%eax
  802c24:	85 c0                	test   %eax,%eax
  802c26:	0f 85 2e fe ff ff    	jne    802a5a <alloc_block_NF+0x3ea>
  802c2c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c30:	0f 85 24 fe ff ff    	jne    802a5a <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802c36:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c3b:	c9                   	leave  
  802c3c:	c3                   	ret    

00802c3d <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802c3d:	55                   	push   %ebp
  802c3e:	89 e5                	mov    %esp,%ebp
  802c40:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802c43:	a1 38 51 80 00       	mov    0x805138,%eax
  802c48:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802c4b:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802c50:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802c53:	a1 38 51 80 00       	mov    0x805138,%eax
  802c58:	85 c0                	test   %eax,%eax
  802c5a:	74 14                	je     802c70 <insert_sorted_with_merge_freeList+0x33>
  802c5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5f:	8b 50 08             	mov    0x8(%eax),%edx
  802c62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c65:	8b 40 08             	mov    0x8(%eax),%eax
  802c68:	39 c2                	cmp    %eax,%edx
  802c6a:	0f 87 9b 01 00 00    	ja     802e0b <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802c70:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c74:	75 17                	jne    802c8d <insert_sorted_with_merge_freeList+0x50>
  802c76:	83 ec 04             	sub    $0x4,%esp
  802c79:	68 bc 3f 80 00       	push   $0x803fbc
  802c7e:	68 38 01 00 00       	push   $0x138
  802c83:	68 df 3f 80 00       	push   $0x803fdf
  802c88:	e8 29 d6 ff ff       	call   8002b6 <_panic>
  802c8d:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802c93:	8b 45 08             	mov    0x8(%ebp),%eax
  802c96:	89 10                	mov    %edx,(%eax)
  802c98:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9b:	8b 00                	mov    (%eax),%eax
  802c9d:	85 c0                	test   %eax,%eax
  802c9f:	74 0d                	je     802cae <insert_sorted_with_merge_freeList+0x71>
  802ca1:	a1 38 51 80 00       	mov    0x805138,%eax
  802ca6:	8b 55 08             	mov    0x8(%ebp),%edx
  802ca9:	89 50 04             	mov    %edx,0x4(%eax)
  802cac:	eb 08                	jmp    802cb6 <insert_sorted_with_merge_freeList+0x79>
  802cae:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb9:	a3 38 51 80 00       	mov    %eax,0x805138
  802cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cc8:	a1 44 51 80 00       	mov    0x805144,%eax
  802ccd:	40                   	inc    %eax
  802cce:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802cd3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cd7:	0f 84 a8 06 00 00    	je     803385 <insert_sorted_with_merge_freeList+0x748>
  802cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce0:	8b 50 08             	mov    0x8(%eax),%edx
  802ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce6:	8b 40 0c             	mov    0xc(%eax),%eax
  802ce9:	01 c2                	add    %eax,%edx
  802ceb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cee:	8b 40 08             	mov    0x8(%eax),%eax
  802cf1:	39 c2                	cmp    %eax,%edx
  802cf3:	0f 85 8c 06 00 00    	jne    803385 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  802cfc:	8b 50 0c             	mov    0xc(%eax),%edx
  802cff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d02:	8b 40 0c             	mov    0xc(%eax),%eax
  802d05:	01 c2                	add    %eax,%edx
  802d07:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0a:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802d0d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d11:	75 17                	jne    802d2a <insert_sorted_with_merge_freeList+0xed>
  802d13:	83 ec 04             	sub    $0x4,%esp
  802d16:	68 88 40 80 00       	push   $0x804088
  802d1b:	68 3c 01 00 00       	push   $0x13c
  802d20:	68 df 3f 80 00       	push   $0x803fdf
  802d25:	e8 8c d5 ff ff       	call   8002b6 <_panic>
  802d2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d2d:	8b 00                	mov    (%eax),%eax
  802d2f:	85 c0                	test   %eax,%eax
  802d31:	74 10                	je     802d43 <insert_sorted_with_merge_freeList+0x106>
  802d33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d36:	8b 00                	mov    (%eax),%eax
  802d38:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d3b:	8b 52 04             	mov    0x4(%edx),%edx
  802d3e:	89 50 04             	mov    %edx,0x4(%eax)
  802d41:	eb 0b                	jmp    802d4e <insert_sorted_with_merge_freeList+0x111>
  802d43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d46:	8b 40 04             	mov    0x4(%eax),%eax
  802d49:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d51:	8b 40 04             	mov    0x4(%eax),%eax
  802d54:	85 c0                	test   %eax,%eax
  802d56:	74 0f                	je     802d67 <insert_sorted_with_merge_freeList+0x12a>
  802d58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d5b:	8b 40 04             	mov    0x4(%eax),%eax
  802d5e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d61:	8b 12                	mov    (%edx),%edx
  802d63:	89 10                	mov    %edx,(%eax)
  802d65:	eb 0a                	jmp    802d71 <insert_sorted_with_merge_freeList+0x134>
  802d67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d6a:	8b 00                	mov    (%eax),%eax
  802d6c:	a3 38 51 80 00       	mov    %eax,0x805138
  802d71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d74:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d7d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d84:	a1 44 51 80 00       	mov    0x805144,%eax
  802d89:	48                   	dec    %eax
  802d8a:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802d8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d92:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802d99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d9c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802da3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802da7:	75 17                	jne    802dc0 <insert_sorted_with_merge_freeList+0x183>
  802da9:	83 ec 04             	sub    $0x4,%esp
  802dac:	68 bc 3f 80 00       	push   $0x803fbc
  802db1:	68 3f 01 00 00       	push   $0x13f
  802db6:	68 df 3f 80 00       	push   $0x803fdf
  802dbb:	e8 f6 d4 ff ff       	call   8002b6 <_panic>
  802dc0:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802dc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc9:	89 10                	mov    %edx,(%eax)
  802dcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dce:	8b 00                	mov    (%eax),%eax
  802dd0:	85 c0                	test   %eax,%eax
  802dd2:	74 0d                	je     802de1 <insert_sorted_with_merge_freeList+0x1a4>
  802dd4:	a1 48 51 80 00       	mov    0x805148,%eax
  802dd9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ddc:	89 50 04             	mov    %edx,0x4(%eax)
  802ddf:	eb 08                	jmp    802de9 <insert_sorted_with_merge_freeList+0x1ac>
  802de1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802de9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dec:	a3 48 51 80 00       	mov    %eax,0x805148
  802df1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dfb:	a1 54 51 80 00       	mov    0x805154,%eax
  802e00:	40                   	inc    %eax
  802e01:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802e06:	e9 7a 05 00 00       	jmp    803385 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802e0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0e:	8b 50 08             	mov    0x8(%eax),%edx
  802e11:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e14:	8b 40 08             	mov    0x8(%eax),%eax
  802e17:	39 c2                	cmp    %eax,%edx
  802e19:	0f 82 14 01 00 00    	jb     802f33 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802e1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e22:	8b 50 08             	mov    0x8(%eax),%edx
  802e25:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e28:	8b 40 0c             	mov    0xc(%eax),%eax
  802e2b:	01 c2                	add    %eax,%edx
  802e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e30:	8b 40 08             	mov    0x8(%eax),%eax
  802e33:	39 c2                	cmp    %eax,%edx
  802e35:	0f 85 90 00 00 00    	jne    802ecb <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802e3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e3e:	8b 50 0c             	mov    0xc(%eax),%edx
  802e41:	8b 45 08             	mov    0x8(%ebp),%eax
  802e44:	8b 40 0c             	mov    0xc(%eax),%eax
  802e47:	01 c2                	add    %eax,%edx
  802e49:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e4c:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802e4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e52:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802e59:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802e63:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e67:	75 17                	jne    802e80 <insert_sorted_with_merge_freeList+0x243>
  802e69:	83 ec 04             	sub    $0x4,%esp
  802e6c:	68 bc 3f 80 00       	push   $0x803fbc
  802e71:	68 49 01 00 00       	push   $0x149
  802e76:	68 df 3f 80 00       	push   $0x803fdf
  802e7b:	e8 36 d4 ff ff       	call   8002b6 <_panic>
  802e80:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802e86:	8b 45 08             	mov    0x8(%ebp),%eax
  802e89:	89 10                	mov    %edx,(%eax)
  802e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8e:	8b 00                	mov    (%eax),%eax
  802e90:	85 c0                	test   %eax,%eax
  802e92:	74 0d                	je     802ea1 <insert_sorted_with_merge_freeList+0x264>
  802e94:	a1 48 51 80 00       	mov    0x805148,%eax
  802e99:	8b 55 08             	mov    0x8(%ebp),%edx
  802e9c:	89 50 04             	mov    %edx,0x4(%eax)
  802e9f:	eb 08                	jmp    802ea9 <insert_sorted_with_merge_freeList+0x26c>
  802ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  802eac:	a3 48 51 80 00       	mov    %eax,0x805148
  802eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ebb:	a1 54 51 80 00       	mov    0x805154,%eax
  802ec0:	40                   	inc    %eax
  802ec1:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802ec6:	e9 bb 04 00 00       	jmp    803386 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802ecb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ecf:	75 17                	jne    802ee8 <insert_sorted_with_merge_freeList+0x2ab>
  802ed1:	83 ec 04             	sub    $0x4,%esp
  802ed4:	68 30 40 80 00       	push   $0x804030
  802ed9:	68 4c 01 00 00       	push   $0x14c
  802ede:	68 df 3f 80 00       	push   $0x803fdf
  802ee3:	e8 ce d3 ff ff       	call   8002b6 <_panic>
  802ee8:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802eee:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef1:	89 50 04             	mov    %edx,0x4(%eax)
  802ef4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef7:	8b 40 04             	mov    0x4(%eax),%eax
  802efa:	85 c0                	test   %eax,%eax
  802efc:	74 0c                	je     802f0a <insert_sorted_with_merge_freeList+0x2cd>
  802efe:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f03:	8b 55 08             	mov    0x8(%ebp),%edx
  802f06:	89 10                	mov    %edx,(%eax)
  802f08:	eb 08                	jmp    802f12 <insert_sorted_with_merge_freeList+0x2d5>
  802f0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0d:	a3 38 51 80 00       	mov    %eax,0x805138
  802f12:	8b 45 08             	mov    0x8(%ebp),%eax
  802f15:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f23:	a1 44 51 80 00       	mov    0x805144,%eax
  802f28:	40                   	inc    %eax
  802f29:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802f2e:	e9 53 04 00 00       	jmp    803386 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802f33:	a1 38 51 80 00       	mov    0x805138,%eax
  802f38:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f3b:	e9 15 04 00 00       	jmp    803355 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802f40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f43:	8b 00                	mov    (%eax),%eax
  802f45:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802f48:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4b:	8b 50 08             	mov    0x8(%eax),%edx
  802f4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f51:	8b 40 08             	mov    0x8(%eax),%eax
  802f54:	39 c2                	cmp    %eax,%edx
  802f56:	0f 86 f1 03 00 00    	jbe    80334d <insert_sorted_with_merge_freeList+0x710>
  802f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5f:	8b 50 08             	mov    0x8(%eax),%edx
  802f62:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f65:	8b 40 08             	mov    0x8(%eax),%eax
  802f68:	39 c2                	cmp    %eax,%edx
  802f6a:	0f 83 dd 03 00 00    	jae    80334d <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802f70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f73:	8b 50 08             	mov    0x8(%eax),%edx
  802f76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f79:	8b 40 0c             	mov    0xc(%eax),%eax
  802f7c:	01 c2                	add    %eax,%edx
  802f7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f81:	8b 40 08             	mov    0x8(%eax),%eax
  802f84:	39 c2                	cmp    %eax,%edx
  802f86:	0f 85 b9 01 00 00    	jne    803145 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802f8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8f:	8b 50 08             	mov    0x8(%eax),%edx
  802f92:	8b 45 08             	mov    0x8(%ebp),%eax
  802f95:	8b 40 0c             	mov    0xc(%eax),%eax
  802f98:	01 c2                	add    %eax,%edx
  802f9a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f9d:	8b 40 08             	mov    0x8(%eax),%eax
  802fa0:	39 c2                	cmp    %eax,%edx
  802fa2:	0f 85 0d 01 00 00    	jne    8030b5 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802fa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fab:	8b 50 0c             	mov    0xc(%eax),%edx
  802fae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fb1:	8b 40 0c             	mov    0xc(%eax),%eax
  802fb4:	01 c2                	add    %eax,%edx
  802fb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb9:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802fbc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802fc0:	75 17                	jne    802fd9 <insert_sorted_with_merge_freeList+0x39c>
  802fc2:	83 ec 04             	sub    $0x4,%esp
  802fc5:	68 88 40 80 00       	push   $0x804088
  802fca:	68 5c 01 00 00       	push   $0x15c
  802fcf:	68 df 3f 80 00       	push   $0x803fdf
  802fd4:	e8 dd d2 ff ff       	call   8002b6 <_panic>
  802fd9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fdc:	8b 00                	mov    (%eax),%eax
  802fde:	85 c0                	test   %eax,%eax
  802fe0:	74 10                	je     802ff2 <insert_sorted_with_merge_freeList+0x3b5>
  802fe2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fe5:	8b 00                	mov    (%eax),%eax
  802fe7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fea:	8b 52 04             	mov    0x4(%edx),%edx
  802fed:	89 50 04             	mov    %edx,0x4(%eax)
  802ff0:	eb 0b                	jmp    802ffd <insert_sorted_with_merge_freeList+0x3c0>
  802ff2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ff5:	8b 40 04             	mov    0x4(%eax),%eax
  802ff8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ffd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803000:	8b 40 04             	mov    0x4(%eax),%eax
  803003:	85 c0                	test   %eax,%eax
  803005:	74 0f                	je     803016 <insert_sorted_with_merge_freeList+0x3d9>
  803007:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80300a:	8b 40 04             	mov    0x4(%eax),%eax
  80300d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803010:	8b 12                	mov    (%edx),%edx
  803012:	89 10                	mov    %edx,(%eax)
  803014:	eb 0a                	jmp    803020 <insert_sorted_with_merge_freeList+0x3e3>
  803016:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803019:	8b 00                	mov    (%eax),%eax
  80301b:	a3 38 51 80 00       	mov    %eax,0x805138
  803020:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803023:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803029:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80302c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803033:	a1 44 51 80 00       	mov    0x805144,%eax
  803038:	48                   	dec    %eax
  803039:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  80303e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803041:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803048:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80304b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803052:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803056:	75 17                	jne    80306f <insert_sorted_with_merge_freeList+0x432>
  803058:	83 ec 04             	sub    $0x4,%esp
  80305b:	68 bc 3f 80 00       	push   $0x803fbc
  803060:	68 5f 01 00 00       	push   $0x15f
  803065:	68 df 3f 80 00       	push   $0x803fdf
  80306a:	e8 47 d2 ff ff       	call   8002b6 <_panic>
  80306f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803075:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803078:	89 10                	mov    %edx,(%eax)
  80307a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80307d:	8b 00                	mov    (%eax),%eax
  80307f:	85 c0                	test   %eax,%eax
  803081:	74 0d                	je     803090 <insert_sorted_with_merge_freeList+0x453>
  803083:	a1 48 51 80 00       	mov    0x805148,%eax
  803088:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80308b:	89 50 04             	mov    %edx,0x4(%eax)
  80308e:	eb 08                	jmp    803098 <insert_sorted_with_merge_freeList+0x45b>
  803090:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803093:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803098:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80309b:	a3 48 51 80 00       	mov    %eax,0x805148
  8030a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030a3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030aa:	a1 54 51 80 00       	mov    0x805154,%eax
  8030af:	40                   	inc    %eax
  8030b0:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8030b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b8:	8b 50 0c             	mov    0xc(%eax),%edx
  8030bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8030be:	8b 40 0c             	mov    0xc(%eax),%eax
  8030c1:	01 c2                	add    %eax,%edx
  8030c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c6:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8030c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030cc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8030d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8030dd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030e1:	75 17                	jne    8030fa <insert_sorted_with_merge_freeList+0x4bd>
  8030e3:	83 ec 04             	sub    $0x4,%esp
  8030e6:	68 bc 3f 80 00       	push   $0x803fbc
  8030eb:	68 64 01 00 00       	push   $0x164
  8030f0:	68 df 3f 80 00       	push   $0x803fdf
  8030f5:	e8 bc d1 ff ff       	call   8002b6 <_panic>
  8030fa:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803100:	8b 45 08             	mov    0x8(%ebp),%eax
  803103:	89 10                	mov    %edx,(%eax)
  803105:	8b 45 08             	mov    0x8(%ebp),%eax
  803108:	8b 00                	mov    (%eax),%eax
  80310a:	85 c0                	test   %eax,%eax
  80310c:	74 0d                	je     80311b <insert_sorted_with_merge_freeList+0x4de>
  80310e:	a1 48 51 80 00       	mov    0x805148,%eax
  803113:	8b 55 08             	mov    0x8(%ebp),%edx
  803116:	89 50 04             	mov    %edx,0x4(%eax)
  803119:	eb 08                	jmp    803123 <insert_sorted_with_merge_freeList+0x4e6>
  80311b:	8b 45 08             	mov    0x8(%ebp),%eax
  80311e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803123:	8b 45 08             	mov    0x8(%ebp),%eax
  803126:	a3 48 51 80 00       	mov    %eax,0x805148
  80312b:	8b 45 08             	mov    0x8(%ebp),%eax
  80312e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803135:	a1 54 51 80 00       	mov    0x805154,%eax
  80313a:	40                   	inc    %eax
  80313b:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803140:	e9 41 02 00 00       	jmp    803386 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803145:	8b 45 08             	mov    0x8(%ebp),%eax
  803148:	8b 50 08             	mov    0x8(%eax),%edx
  80314b:	8b 45 08             	mov    0x8(%ebp),%eax
  80314e:	8b 40 0c             	mov    0xc(%eax),%eax
  803151:	01 c2                	add    %eax,%edx
  803153:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803156:	8b 40 08             	mov    0x8(%eax),%eax
  803159:	39 c2                	cmp    %eax,%edx
  80315b:	0f 85 7c 01 00 00    	jne    8032dd <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803161:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803165:	74 06                	je     80316d <insert_sorted_with_merge_freeList+0x530>
  803167:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80316b:	75 17                	jne    803184 <insert_sorted_with_merge_freeList+0x547>
  80316d:	83 ec 04             	sub    $0x4,%esp
  803170:	68 f8 3f 80 00       	push   $0x803ff8
  803175:	68 69 01 00 00       	push   $0x169
  80317a:	68 df 3f 80 00       	push   $0x803fdf
  80317f:	e8 32 d1 ff ff       	call   8002b6 <_panic>
  803184:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803187:	8b 50 04             	mov    0x4(%eax),%edx
  80318a:	8b 45 08             	mov    0x8(%ebp),%eax
  80318d:	89 50 04             	mov    %edx,0x4(%eax)
  803190:	8b 45 08             	mov    0x8(%ebp),%eax
  803193:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803196:	89 10                	mov    %edx,(%eax)
  803198:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80319b:	8b 40 04             	mov    0x4(%eax),%eax
  80319e:	85 c0                	test   %eax,%eax
  8031a0:	74 0d                	je     8031af <insert_sorted_with_merge_freeList+0x572>
  8031a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031a5:	8b 40 04             	mov    0x4(%eax),%eax
  8031a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8031ab:	89 10                	mov    %edx,(%eax)
  8031ad:	eb 08                	jmp    8031b7 <insert_sorted_with_merge_freeList+0x57a>
  8031af:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b2:	a3 38 51 80 00       	mov    %eax,0x805138
  8031b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8031bd:	89 50 04             	mov    %edx,0x4(%eax)
  8031c0:	a1 44 51 80 00       	mov    0x805144,%eax
  8031c5:	40                   	inc    %eax
  8031c6:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8031cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ce:	8b 50 0c             	mov    0xc(%eax),%edx
  8031d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d4:	8b 40 0c             	mov    0xc(%eax),%eax
  8031d7:	01 c2                	add    %eax,%edx
  8031d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031dc:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8031df:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031e3:	75 17                	jne    8031fc <insert_sorted_with_merge_freeList+0x5bf>
  8031e5:	83 ec 04             	sub    $0x4,%esp
  8031e8:	68 88 40 80 00       	push   $0x804088
  8031ed:	68 6b 01 00 00       	push   $0x16b
  8031f2:	68 df 3f 80 00       	push   $0x803fdf
  8031f7:	e8 ba d0 ff ff       	call   8002b6 <_panic>
  8031fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ff:	8b 00                	mov    (%eax),%eax
  803201:	85 c0                	test   %eax,%eax
  803203:	74 10                	je     803215 <insert_sorted_with_merge_freeList+0x5d8>
  803205:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803208:	8b 00                	mov    (%eax),%eax
  80320a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80320d:	8b 52 04             	mov    0x4(%edx),%edx
  803210:	89 50 04             	mov    %edx,0x4(%eax)
  803213:	eb 0b                	jmp    803220 <insert_sorted_with_merge_freeList+0x5e3>
  803215:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803218:	8b 40 04             	mov    0x4(%eax),%eax
  80321b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803220:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803223:	8b 40 04             	mov    0x4(%eax),%eax
  803226:	85 c0                	test   %eax,%eax
  803228:	74 0f                	je     803239 <insert_sorted_with_merge_freeList+0x5fc>
  80322a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80322d:	8b 40 04             	mov    0x4(%eax),%eax
  803230:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803233:	8b 12                	mov    (%edx),%edx
  803235:	89 10                	mov    %edx,(%eax)
  803237:	eb 0a                	jmp    803243 <insert_sorted_with_merge_freeList+0x606>
  803239:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80323c:	8b 00                	mov    (%eax),%eax
  80323e:	a3 38 51 80 00       	mov    %eax,0x805138
  803243:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803246:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80324c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80324f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803256:	a1 44 51 80 00       	mov    0x805144,%eax
  80325b:	48                   	dec    %eax
  80325c:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803261:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803264:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  80326b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80326e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803275:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803279:	75 17                	jne    803292 <insert_sorted_with_merge_freeList+0x655>
  80327b:	83 ec 04             	sub    $0x4,%esp
  80327e:	68 bc 3f 80 00       	push   $0x803fbc
  803283:	68 6e 01 00 00       	push   $0x16e
  803288:	68 df 3f 80 00       	push   $0x803fdf
  80328d:	e8 24 d0 ff ff       	call   8002b6 <_panic>
  803292:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803298:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80329b:	89 10                	mov    %edx,(%eax)
  80329d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032a0:	8b 00                	mov    (%eax),%eax
  8032a2:	85 c0                	test   %eax,%eax
  8032a4:	74 0d                	je     8032b3 <insert_sorted_with_merge_freeList+0x676>
  8032a6:	a1 48 51 80 00       	mov    0x805148,%eax
  8032ab:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032ae:	89 50 04             	mov    %edx,0x4(%eax)
  8032b1:	eb 08                	jmp    8032bb <insert_sorted_with_merge_freeList+0x67e>
  8032b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032b6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032be:	a3 48 51 80 00       	mov    %eax,0x805148
  8032c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032c6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032cd:	a1 54 51 80 00       	mov    0x805154,%eax
  8032d2:	40                   	inc    %eax
  8032d3:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8032d8:	e9 a9 00 00 00       	jmp    803386 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8032dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032e1:	74 06                	je     8032e9 <insert_sorted_with_merge_freeList+0x6ac>
  8032e3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032e7:	75 17                	jne    803300 <insert_sorted_with_merge_freeList+0x6c3>
  8032e9:	83 ec 04             	sub    $0x4,%esp
  8032ec:	68 54 40 80 00       	push   $0x804054
  8032f1:	68 73 01 00 00       	push   $0x173
  8032f6:	68 df 3f 80 00       	push   $0x803fdf
  8032fb:	e8 b6 cf ff ff       	call   8002b6 <_panic>
  803300:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803303:	8b 10                	mov    (%eax),%edx
  803305:	8b 45 08             	mov    0x8(%ebp),%eax
  803308:	89 10                	mov    %edx,(%eax)
  80330a:	8b 45 08             	mov    0x8(%ebp),%eax
  80330d:	8b 00                	mov    (%eax),%eax
  80330f:	85 c0                	test   %eax,%eax
  803311:	74 0b                	je     80331e <insert_sorted_with_merge_freeList+0x6e1>
  803313:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803316:	8b 00                	mov    (%eax),%eax
  803318:	8b 55 08             	mov    0x8(%ebp),%edx
  80331b:	89 50 04             	mov    %edx,0x4(%eax)
  80331e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803321:	8b 55 08             	mov    0x8(%ebp),%edx
  803324:	89 10                	mov    %edx,(%eax)
  803326:	8b 45 08             	mov    0x8(%ebp),%eax
  803329:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80332c:	89 50 04             	mov    %edx,0x4(%eax)
  80332f:	8b 45 08             	mov    0x8(%ebp),%eax
  803332:	8b 00                	mov    (%eax),%eax
  803334:	85 c0                	test   %eax,%eax
  803336:	75 08                	jne    803340 <insert_sorted_with_merge_freeList+0x703>
  803338:	8b 45 08             	mov    0x8(%ebp),%eax
  80333b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803340:	a1 44 51 80 00       	mov    0x805144,%eax
  803345:	40                   	inc    %eax
  803346:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  80334b:	eb 39                	jmp    803386 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80334d:	a1 40 51 80 00       	mov    0x805140,%eax
  803352:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803355:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803359:	74 07                	je     803362 <insert_sorted_with_merge_freeList+0x725>
  80335b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80335e:	8b 00                	mov    (%eax),%eax
  803360:	eb 05                	jmp    803367 <insert_sorted_with_merge_freeList+0x72a>
  803362:	b8 00 00 00 00       	mov    $0x0,%eax
  803367:	a3 40 51 80 00       	mov    %eax,0x805140
  80336c:	a1 40 51 80 00       	mov    0x805140,%eax
  803371:	85 c0                	test   %eax,%eax
  803373:	0f 85 c7 fb ff ff    	jne    802f40 <insert_sorted_with_merge_freeList+0x303>
  803379:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80337d:	0f 85 bd fb ff ff    	jne    802f40 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803383:	eb 01                	jmp    803386 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803385:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803386:	90                   	nop
  803387:	c9                   	leave  
  803388:	c3                   	ret    

00803389 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803389:	55                   	push   %ebp
  80338a:	89 e5                	mov    %esp,%ebp
  80338c:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  80338f:	8b 55 08             	mov    0x8(%ebp),%edx
  803392:	89 d0                	mov    %edx,%eax
  803394:	c1 e0 02             	shl    $0x2,%eax
  803397:	01 d0                	add    %edx,%eax
  803399:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8033a0:	01 d0                	add    %edx,%eax
  8033a2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8033a9:	01 d0                	add    %edx,%eax
  8033ab:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8033b2:	01 d0                	add    %edx,%eax
  8033b4:	c1 e0 04             	shl    $0x4,%eax
  8033b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8033ba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8033c1:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8033c4:	83 ec 0c             	sub    $0xc,%esp
  8033c7:	50                   	push   %eax
  8033c8:	e8 26 e7 ff ff       	call   801af3 <sys_get_virtual_time>
  8033cd:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8033d0:	eb 41                	jmp    803413 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8033d2:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8033d5:	83 ec 0c             	sub    $0xc,%esp
  8033d8:	50                   	push   %eax
  8033d9:	e8 15 e7 ff ff       	call   801af3 <sys_get_virtual_time>
  8033de:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8033e1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8033e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033e7:	29 c2                	sub    %eax,%edx
  8033e9:	89 d0                	mov    %edx,%eax
  8033eb:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8033ee:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8033f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033f4:	89 d1                	mov    %edx,%ecx
  8033f6:	29 c1                	sub    %eax,%ecx
  8033f8:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8033fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033fe:	39 c2                	cmp    %eax,%edx
  803400:	0f 97 c0             	seta   %al
  803403:	0f b6 c0             	movzbl %al,%eax
  803406:	29 c1                	sub    %eax,%ecx
  803408:	89 c8                	mov    %ecx,%eax
  80340a:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  80340d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803410:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803413:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803416:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803419:	72 b7                	jb     8033d2 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  80341b:	90                   	nop
  80341c:	c9                   	leave  
  80341d:	c3                   	ret    

0080341e <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  80341e:	55                   	push   %ebp
  80341f:	89 e5                	mov    %esp,%ebp
  803421:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803424:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  80342b:	eb 03                	jmp    803430 <busy_wait+0x12>
  80342d:	ff 45 fc             	incl   -0x4(%ebp)
  803430:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803433:	3b 45 08             	cmp    0x8(%ebp),%eax
  803436:	72 f5                	jb     80342d <busy_wait+0xf>
	return i;
  803438:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80343b:	c9                   	leave  
  80343c:	c3                   	ret    
  80343d:	66 90                	xchg   %ax,%ax
  80343f:	90                   	nop

00803440 <__udivdi3>:
  803440:	55                   	push   %ebp
  803441:	57                   	push   %edi
  803442:	56                   	push   %esi
  803443:	53                   	push   %ebx
  803444:	83 ec 1c             	sub    $0x1c,%esp
  803447:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80344b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80344f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803453:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803457:	89 ca                	mov    %ecx,%edx
  803459:	89 f8                	mov    %edi,%eax
  80345b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80345f:	85 f6                	test   %esi,%esi
  803461:	75 2d                	jne    803490 <__udivdi3+0x50>
  803463:	39 cf                	cmp    %ecx,%edi
  803465:	77 65                	ja     8034cc <__udivdi3+0x8c>
  803467:	89 fd                	mov    %edi,%ebp
  803469:	85 ff                	test   %edi,%edi
  80346b:	75 0b                	jne    803478 <__udivdi3+0x38>
  80346d:	b8 01 00 00 00       	mov    $0x1,%eax
  803472:	31 d2                	xor    %edx,%edx
  803474:	f7 f7                	div    %edi
  803476:	89 c5                	mov    %eax,%ebp
  803478:	31 d2                	xor    %edx,%edx
  80347a:	89 c8                	mov    %ecx,%eax
  80347c:	f7 f5                	div    %ebp
  80347e:	89 c1                	mov    %eax,%ecx
  803480:	89 d8                	mov    %ebx,%eax
  803482:	f7 f5                	div    %ebp
  803484:	89 cf                	mov    %ecx,%edi
  803486:	89 fa                	mov    %edi,%edx
  803488:	83 c4 1c             	add    $0x1c,%esp
  80348b:	5b                   	pop    %ebx
  80348c:	5e                   	pop    %esi
  80348d:	5f                   	pop    %edi
  80348e:	5d                   	pop    %ebp
  80348f:	c3                   	ret    
  803490:	39 ce                	cmp    %ecx,%esi
  803492:	77 28                	ja     8034bc <__udivdi3+0x7c>
  803494:	0f bd fe             	bsr    %esi,%edi
  803497:	83 f7 1f             	xor    $0x1f,%edi
  80349a:	75 40                	jne    8034dc <__udivdi3+0x9c>
  80349c:	39 ce                	cmp    %ecx,%esi
  80349e:	72 0a                	jb     8034aa <__udivdi3+0x6a>
  8034a0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8034a4:	0f 87 9e 00 00 00    	ja     803548 <__udivdi3+0x108>
  8034aa:	b8 01 00 00 00       	mov    $0x1,%eax
  8034af:	89 fa                	mov    %edi,%edx
  8034b1:	83 c4 1c             	add    $0x1c,%esp
  8034b4:	5b                   	pop    %ebx
  8034b5:	5e                   	pop    %esi
  8034b6:	5f                   	pop    %edi
  8034b7:	5d                   	pop    %ebp
  8034b8:	c3                   	ret    
  8034b9:	8d 76 00             	lea    0x0(%esi),%esi
  8034bc:	31 ff                	xor    %edi,%edi
  8034be:	31 c0                	xor    %eax,%eax
  8034c0:	89 fa                	mov    %edi,%edx
  8034c2:	83 c4 1c             	add    $0x1c,%esp
  8034c5:	5b                   	pop    %ebx
  8034c6:	5e                   	pop    %esi
  8034c7:	5f                   	pop    %edi
  8034c8:	5d                   	pop    %ebp
  8034c9:	c3                   	ret    
  8034ca:	66 90                	xchg   %ax,%ax
  8034cc:	89 d8                	mov    %ebx,%eax
  8034ce:	f7 f7                	div    %edi
  8034d0:	31 ff                	xor    %edi,%edi
  8034d2:	89 fa                	mov    %edi,%edx
  8034d4:	83 c4 1c             	add    $0x1c,%esp
  8034d7:	5b                   	pop    %ebx
  8034d8:	5e                   	pop    %esi
  8034d9:	5f                   	pop    %edi
  8034da:	5d                   	pop    %ebp
  8034db:	c3                   	ret    
  8034dc:	bd 20 00 00 00       	mov    $0x20,%ebp
  8034e1:	89 eb                	mov    %ebp,%ebx
  8034e3:	29 fb                	sub    %edi,%ebx
  8034e5:	89 f9                	mov    %edi,%ecx
  8034e7:	d3 e6                	shl    %cl,%esi
  8034e9:	89 c5                	mov    %eax,%ebp
  8034eb:	88 d9                	mov    %bl,%cl
  8034ed:	d3 ed                	shr    %cl,%ebp
  8034ef:	89 e9                	mov    %ebp,%ecx
  8034f1:	09 f1                	or     %esi,%ecx
  8034f3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8034f7:	89 f9                	mov    %edi,%ecx
  8034f9:	d3 e0                	shl    %cl,%eax
  8034fb:	89 c5                	mov    %eax,%ebp
  8034fd:	89 d6                	mov    %edx,%esi
  8034ff:	88 d9                	mov    %bl,%cl
  803501:	d3 ee                	shr    %cl,%esi
  803503:	89 f9                	mov    %edi,%ecx
  803505:	d3 e2                	shl    %cl,%edx
  803507:	8b 44 24 08          	mov    0x8(%esp),%eax
  80350b:	88 d9                	mov    %bl,%cl
  80350d:	d3 e8                	shr    %cl,%eax
  80350f:	09 c2                	or     %eax,%edx
  803511:	89 d0                	mov    %edx,%eax
  803513:	89 f2                	mov    %esi,%edx
  803515:	f7 74 24 0c          	divl   0xc(%esp)
  803519:	89 d6                	mov    %edx,%esi
  80351b:	89 c3                	mov    %eax,%ebx
  80351d:	f7 e5                	mul    %ebp
  80351f:	39 d6                	cmp    %edx,%esi
  803521:	72 19                	jb     80353c <__udivdi3+0xfc>
  803523:	74 0b                	je     803530 <__udivdi3+0xf0>
  803525:	89 d8                	mov    %ebx,%eax
  803527:	31 ff                	xor    %edi,%edi
  803529:	e9 58 ff ff ff       	jmp    803486 <__udivdi3+0x46>
  80352e:	66 90                	xchg   %ax,%ax
  803530:	8b 54 24 08          	mov    0x8(%esp),%edx
  803534:	89 f9                	mov    %edi,%ecx
  803536:	d3 e2                	shl    %cl,%edx
  803538:	39 c2                	cmp    %eax,%edx
  80353a:	73 e9                	jae    803525 <__udivdi3+0xe5>
  80353c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80353f:	31 ff                	xor    %edi,%edi
  803541:	e9 40 ff ff ff       	jmp    803486 <__udivdi3+0x46>
  803546:	66 90                	xchg   %ax,%ax
  803548:	31 c0                	xor    %eax,%eax
  80354a:	e9 37 ff ff ff       	jmp    803486 <__udivdi3+0x46>
  80354f:	90                   	nop

00803550 <__umoddi3>:
  803550:	55                   	push   %ebp
  803551:	57                   	push   %edi
  803552:	56                   	push   %esi
  803553:	53                   	push   %ebx
  803554:	83 ec 1c             	sub    $0x1c,%esp
  803557:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80355b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80355f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803563:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803567:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80356b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80356f:	89 f3                	mov    %esi,%ebx
  803571:	89 fa                	mov    %edi,%edx
  803573:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803577:	89 34 24             	mov    %esi,(%esp)
  80357a:	85 c0                	test   %eax,%eax
  80357c:	75 1a                	jne    803598 <__umoddi3+0x48>
  80357e:	39 f7                	cmp    %esi,%edi
  803580:	0f 86 a2 00 00 00    	jbe    803628 <__umoddi3+0xd8>
  803586:	89 c8                	mov    %ecx,%eax
  803588:	89 f2                	mov    %esi,%edx
  80358a:	f7 f7                	div    %edi
  80358c:	89 d0                	mov    %edx,%eax
  80358e:	31 d2                	xor    %edx,%edx
  803590:	83 c4 1c             	add    $0x1c,%esp
  803593:	5b                   	pop    %ebx
  803594:	5e                   	pop    %esi
  803595:	5f                   	pop    %edi
  803596:	5d                   	pop    %ebp
  803597:	c3                   	ret    
  803598:	39 f0                	cmp    %esi,%eax
  80359a:	0f 87 ac 00 00 00    	ja     80364c <__umoddi3+0xfc>
  8035a0:	0f bd e8             	bsr    %eax,%ebp
  8035a3:	83 f5 1f             	xor    $0x1f,%ebp
  8035a6:	0f 84 ac 00 00 00    	je     803658 <__umoddi3+0x108>
  8035ac:	bf 20 00 00 00       	mov    $0x20,%edi
  8035b1:	29 ef                	sub    %ebp,%edi
  8035b3:	89 fe                	mov    %edi,%esi
  8035b5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8035b9:	89 e9                	mov    %ebp,%ecx
  8035bb:	d3 e0                	shl    %cl,%eax
  8035bd:	89 d7                	mov    %edx,%edi
  8035bf:	89 f1                	mov    %esi,%ecx
  8035c1:	d3 ef                	shr    %cl,%edi
  8035c3:	09 c7                	or     %eax,%edi
  8035c5:	89 e9                	mov    %ebp,%ecx
  8035c7:	d3 e2                	shl    %cl,%edx
  8035c9:	89 14 24             	mov    %edx,(%esp)
  8035cc:	89 d8                	mov    %ebx,%eax
  8035ce:	d3 e0                	shl    %cl,%eax
  8035d0:	89 c2                	mov    %eax,%edx
  8035d2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035d6:	d3 e0                	shl    %cl,%eax
  8035d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8035dc:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035e0:	89 f1                	mov    %esi,%ecx
  8035e2:	d3 e8                	shr    %cl,%eax
  8035e4:	09 d0                	or     %edx,%eax
  8035e6:	d3 eb                	shr    %cl,%ebx
  8035e8:	89 da                	mov    %ebx,%edx
  8035ea:	f7 f7                	div    %edi
  8035ec:	89 d3                	mov    %edx,%ebx
  8035ee:	f7 24 24             	mull   (%esp)
  8035f1:	89 c6                	mov    %eax,%esi
  8035f3:	89 d1                	mov    %edx,%ecx
  8035f5:	39 d3                	cmp    %edx,%ebx
  8035f7:	0f 82 87 00 00 00    	jb     803684 <__umoddi3+0x134>
  8035fd:	0f 84 91 00 00 00    	je     803694 <__umoddi3+0x144>
  803603:	8b 54 24 04          	mov    0x4(%esp),%edx
  803607:	29 f2                	sub    %esi,%edx
  803609:	19 cb                	sbb    %ecx,%ebx
  80360b:	89 d8                	mov    %ebx,%eax
  80360d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803611:	d3 e0                	shl    %cl,%eax
  803613:	89 e9                	mov    %ebp,%ecx
  803615:	d3 ea                	shr    %cl,%edx
  803617:	09 d0                	or     %edx,%eax
  803619:	89 e9                	mov    %ebp,%ecx
  80361b:	d3 eb                	shr    %cl,%ebx
  80361d:	89 da                	mov    %ebx,%edx
  80361f:	83 c4 1c             	add    $0x1c,%esp
  803622:	5b                   	pop    %ebx
  803623:	5e                   	pop    %esi
  803624:	5f                   	pop    %edi
  803625:	5d                   	pop    %ebp
  803626:	c3                   	ret    
  803627:	90                   	nop
  803628:	89 fd                	mov    %edi,%ebp
  80362a:	85 ff                	test   %edi,%edi
  80362c:	75 0b                	jne    803639 <__umoddi3+0xe9>
  80362e:	b8 01 00 00 00       	mov    $0x1,%eax
  803633:	31 d2                	xor    %edx,%edx
  803635:	f7 f7                	div    %edi
  803637:	89 c5                	mov    %eax,%ebp
  803639:	89 f0                	mov    %esi,%eax
  80363b:	31 d2                	xor    %edx,%edx
  80363d:	f7 f5                	div    %ebp
  80363f:	89 c8                	mov    %ecx,%eax
  803641:	f7 f5                	div    %ebp
  803643:	89 d0                	mov    %edx,%eax
  803645:	e9 44 ff ff ff       	jmp    80358e <__umoddi3+0x3e>
  80364a:	66 90                	xchg   %ax,%ax
  80364c:	89 c8                	mov    %ecx,%eax
  80364e:	89 f2                	mov    %esi,%edx
  803650:	83 c4 1c             	add    $0x1c,%esp
  803653:	5b                   	pop    %ebx
  803654:	5e                   	pop    %esi
  803655:	5f                   	pop    %edi
  803656:	5d                   	pop    %ebp
  803657:	c3                   	ret    
  803658:	3b 04 24             	cmp    (%esp),%eax
  80365b:	72 06                	jb     803663 <__umoddi3+0x113>
  80365d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803661:	77 0f                	ja     803672 <__umoddi3+0x122>
  803663:	89 f2                	mov    %esi,%edx
  803665:	29 f9                	sub    %edi,%ecx
  803667:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80366b:	89 14 24             	mov    %edx,(%esp)
  80366e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803672:	8b 44 24 04          	mov    0x4(%esp),%eax
  803676:	8b 14 24             	mov    (%esp),%edx
  803679:	83 c4 1c             	add    $0x1c,%esp
  80367c:	5b                   	pop    %ebx
  80367d:	5e                   	pop    %esi
  80367e:	5f                   	pop    %edi
  80367f:	5d                   	pop    %ebp
  803680:	c3                   	ret    
  803681:	8d 76 00             	lea    0x0(%esi),%esi
  803684:	2b 04 24             	sub    (%esp),%eax
  803687:	19 fa                	sbb    %edi,%edx
  803689:	89 d1                	mov    %edx,%ecx
  80368b:	89 c6                	mov    %eax,%esi
  80368d:	e9 71 ff ff ff       	jmp    803603 <__umoddi3+0xb3>
  803692:	66 90                	xchg   %ax,%ax
  803694:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803698:	72 ea                	jb     803684 <__umoddi3+0x134>
  80369a:	89 d9                	mov    %ebx,%ecx
  80369c:	e9 62 ff ff ff       	jmp    803603 <__umoddi3+0xb3>
