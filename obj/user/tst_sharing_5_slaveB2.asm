
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
  80008c:	68 00 36 80 00       	push   $0x803600
  800091:	6a 12                	push   $0x12
  800093:	68 1c 36 80 00       	push   $0x80361c
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
  8000aa:	e8 5c 19 00 00       	call   801a0b <sys_getparentenvid>
  8000af:	83 ec 08             	sub    $0x8,%esp
  8000b2:	68 39 36 80 00       	push   $0x803639
  8000b7:	50                   	push   %eax
  8000b8:	e8 b1 14 00 00       	call   80156e <sget>
  8000bd:	83 c4 10             	add    $0x10,%esp
  8000c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("Slave B2 env used z (getSharedObject)\n");
  8000c3:	83 ec 0c             	sub    $0xc,%esp
  8000c6:	68 3c 36 80 00       	push   $0x80363c
  8000cb:	e8 9a 04 00 00       	call   80056a <cprintf>
  8000d0:	83 c4 10             	add    $0x10,%esp
	//To indicate that it's successfully got z
	inctst();
  8000d3:	e8 58 1a 00 00       	call   801b30 <inctst>

	cprintf("Slave B2 please be patient ...\n");
  8000d8:	83 ec 0c             	sub    $0xc,%esp
  8000db:	68 64 36 80 00       	push   $0x803664
  8000e0:	e8 85 04 00 00       	call   80056a <cprintf>
  8000e5:	83 c4 10             	add    $0x10,%esp

	//sleep a while to allow the master to remove x & z
	env_sleep(9000);
  8000e8:	83 ec 0c             	sub    $0xc,%esp
  8000eb:	68 28 23 00 00       	push   $0x2328
  8000f0:	e8 df 31 00 00       	call   8032d4 <env_sleep>
  8000f5:	83 c4 10             	add    $0x10,%esp
	//to ensure that the other environments completed successfully
	while (gettst()!=2) ;// panic("test failed");
  8000f8:	90                   	nop
  8000f9:	e8 4c 1a 00 00       	call   801b4a <gettst>
  8000fe:	83 f8 02             	cmp    $0x2,%eax
  800101:	75 f6                	jne    8000f9 <_main+0xc1>

	int freeFrames = sys_calculate_free_frames() ;
  800103:	e8 0a 16 00 00       	call   801712 <sys_calculate_free_frames>
  800108:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sfree(z);
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	ff 75 ec             	pushl  -0x14(%ebp)
  800111:	e8 9c 14 00 00       	call   8015b2 <sfree>
  800116:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave B2 env removed z\n");
  800119:	83 ec 0c             	sub    $0xc,%esp
  80011c:	68 84 36 80 00       	push   $0x803684
  800121:	e8 44 04 00 00       	call   80056a <cprintf>
  800126:	83 c4 10             	add    $0x10,%esp
	int expected = (1+1) + (1+1);
  800129:	c7 45 e4 04 00 00 00 	movl   $0x4,-0x1c(%ebp)
	if ((sys_calculate_free_frames() - freeFrames) !=  expected) panic("wrong free: frames removed not equal 4 !, correct frames to be removed are 4:\nfrom the env: 1 table + 1 frame for z\nframes_storage of z: should be cleared now\n");
  800130:	e8 dd 15 00 00       	call   801712 <sys_calculate_free_frames>
  800135:	89 c2                	mov    %eax,%edx
  800137:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80013a:	29 c2                	sub    %eax,%edx
  80013c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80013f:	39 c2                	cmp    %eax,%edx
  800141:	74 14                	je     800157 <_main+0x11f>
  800143:	83 ec 04             	sub    $0x4,%esp
  800146:	68 9c 36 80 00       	push   $0x80369c
  80014b:	6a 2a                	push   $0x2a
  80014d:	68 1c 36 80 00       	push   $0x80361c
  800152:	e8 5f 01 00 00       	call   8002b6 <_panic>


	cprintf("Step B completed successfully!!\n\n\n");
  800157:	83 ec 0c             	sub    $0xc,%esp
  80015a:	68 3c 37 80 00       	push   $0x80373c
  80015f:	e8 06 04 00 00       	call   80056a <cprintf>
  800164:	83 c4 10             	add    $0x10,%esp
	cprintf("Congratulations!! Test of freeSharedObjects [5] completed successfully!!\n\n\n");
  800167:	83 ec 0c             	sub    $0xc,%esp
  80016a:	68 60 37 80 00       	push   $0x803760
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
  800180:	e8 6d 18 00 00       	call   8019f2 <sys_getenvindex>
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
  8001eb:	e8 0f 16 00 00       	call   8017ff <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001f0:	83 ec 0c             	sub    $0xc,%esp
  8001f3:	68 c4 37 80 00       	push   $0x8037c4
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
  80021b:	68 ec 37 80 00       	push   $0x8037ec
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
  80024c:	68 14 38 80 00       	push   $0x803814
  800251:	e8 14 03 00 00       	call   80056a <cprintf>
  800256:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800259:	a1 20 50 80 00       	mov    0x805020,%eax
  80025e:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800264:	83 ec 08             	sub    $0x8,%esp
  800267:	50                   	push   %eax
  800268:	68 6c 38 80 00       	push   $0x80386c
  80026d:	e8 f8 02 00 00       	call   80056a <cprintf>
  800272:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800275:	83 ec 0c             	sub    $0xc,%esp
  800278:	68 c4 37 80 00       	push   $0x8037c4
  80027d:	e8 e8 02 00 00       	call   80056a <cprintf>
  800282:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800285:	e8 8f 15 00 00       	call   801819 <sys_enable_interrupt>

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
  80029d:	e8 1c 17 00 00       	call   8019be <sys_destroy_env>
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
  8002ae:	e8 71 17 00 00       	call   801a24 <sys_exit_env>
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
  8002d7:	68 80 38 80 00       	push   $0x803880
  8002dc:	e8 89 02 00 00       	call   80056a <cprintf>
  8002e1:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002e4:	a1 00 50 80 00       	mov    0x805000,%eax
  8002e9:	ff 75 0c             	pushl  0xc(%ebp)
  8002ec:	ff 75 08             	pushl  0x8(%ebp)
  8002ef:	50                   	push   %eax
  8002f0:	68 85 38 80 00       	push   $0x803885
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
  800314:	68 a1 38 80 00       	push   $0x8038a1
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
  800340:	68 a4 38 80 00       	push   $0x8038a4
  800345:	6a 26                	push   $0x26
  800347:	68 f0 38 80 00       	push   $0x8038f0
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
  800412:	68 fc 38 80 00       	push   $0x8038fc
  800417:	6a 3a                	push   $0x3a
  800419:	68 f0 38 80 00       	push   $0x8038f0
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
  800482:	68 50 39 80 00       	push   $0x803950
  800487:	6a 44                	push   $0x44
  800489:	68 f0 38 80 00       	push   $0x8038f0
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
  8004dc:	e8 70 11 00 00       	call   801651 <sys_cputs>
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
  800553:	e8 f9 10 00 00       	call   801651 <sys_cputs>
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
  80059d:	e8 5d 12 00 00       	call   8017ff <sys_disable_interrupt>
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
  8005bd:	e8 57 12 00 00       	call   801819 <sys_enable_interrupt>
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
  800607:	e8 7c 2d 00 00       	call   803388 <__udivdi3>
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
  800657:	e8 3c 2e 00 00       	call   803498 <__umoddi3>
  80065c:	83 c4 10             	add    $0x10,%esp
  80065f:	05 b4 3b 80 00       	add    $0x803bb4,%eax
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
  8007b2:	8b 04 85 d8 3b 80 00 	mov    0x803bd8(,%eax,4),%eax
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
  800893:	8b 34 9d 20 3a 80 00 	mov    0x803a20(,%ebx,4),%esi
  80089a:	85 f6                	test   %esi,%esi
  80089c:	75 19                	jne    8008b7 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80089e:	53                   	push   %ebx
  80089f:	68 c5 3b 80 00       	push   $0x803bc5
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
  8008b8:	68 ce 3b 80 00       	push   $0x803bce
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
  8008e5:	be d1 3b 80 00       	mov    $0x803bd1,%esi
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
  80130b:	68 30 3d 80 00       	push   $0x803d30
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
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_PRESENT);
  8013be:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8013c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013c8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013cd:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013d2:	83 ec 04             	sub    $0x4,%esp
  8013d5:	6a 03                	push   $0x3
  8013d7:	ff 75 f4             	pushl  -0xc(%ebp)
  8013da:	50                   	push   %eax
  8013db:	e8 b5 03 00 00       	call   801795 <sys_allocate_chunk>
  8013e0:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013e3:	a1 20 51 80 00       	mov    0x805120,%eax
  8013e8:	83 ec 0c             	sub    $0xc,%esp
  8013eb:	50                   	push   %eax
  8013ec:	e8 2a 0a 00 00       	call   801e1b <initialize_MemBlocksList>
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
  801419:	68 55 3d 80 00       	push   $0x803d55
  80141e:	6a 33                	push   $0x33
  801420:	68 73 3d 80 00       	push   $0x803d73
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
  801498:	68 80 3d 80 00       	push   $0x803d80
  80149d:	6a 34                	push   $0x34
  80149f:	68 73 3d 80 00       	push   $0x803d73
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
  8014f5:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8014f8:	e8 f7 fd ff ff       	call   8012f4 <InitializeUHeap>
	if (size == 0) return NULL ;
  8014fd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801501:	75 07                	jne    80150a <malloc+0x18>
  801503:	b8 00 00 00 00       	mov    $0x0,%eax
  801508:	eb 14                	jmp    80151e <malloc+0x2c>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  80150a:	83 ec 04             	sub    $0x4,%esp
  80150d:	68 a4 3d 80 00       	push   $0x803da4
  801512:	6a 46                	push   $0x46
  801514:	68 73 3d 80 00       	push   $0x803d73
  801519:	e8 98 ed ff ff       	call   8002b6 <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  80151e:	c9                   	leave  
  80151f:	c3                   	ret    

00801520 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801520:	55                   	push   %ebp
  801521:	89 e5                	mov    %esp,%ebp
  801523:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801526:	83 ec 04             	sub    $0x4,%esp
  801529:	68 cc 3d 80 00       	push   $0x803dcc
  80152e:	6a 61                	push   $0x61
  801530:	68 73 3d 80 00       	push   $0x803d73
  801535:	e8 7c ed ff ff       	call   8002b6 <_panic>

0080153a <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80153a:	55                   	push   %ebp
  80153b:	89 e5                	mov    %esp,%ebp
  80153d:	83 ec 18             	sub    $0x18,%esp
  801540:	8b 45 10             	mov    0x10(%ebp),%eax
  801543:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801546:	e8 a9 fd ff ff       	call   8012f4 <InitializeUHeap>
	if (size == 0) return NULL ;
  80154b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80154f:	75 07                	jne    801558 <smalloc+0x1e>
  801551:	b8 00 00 00 00       	mov    $0x0,%eax
  801556:	eb 14                	jmp    80156c <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801558:	83 ec 04             	sub    $0x4,%esp
  80155b:	68 f0 3d 80 00       	push   $0x803df0
  801560:	6a 76                	push   $0x76
  801562:	68 73 3d 80 00       	push   $0x803d73
  801567:	e8 4a ed ff ff       	call   8002b6 <_panic>

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80156c:	c9                   	leave  
  80156d:	c3                   	ret    

0080156e <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80156e:	55                   	push   %ebp
  80156f:	89 e5                	mov    %esp,%ebp
  801571:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801574:	e8 7b fd ff ff       	call   8012f4 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801579:	83 ec 04             	sub    $0x4,%esp
  80157c:	68 18 3e 80 00       	push   $0x803e18
  801581:	68 93 00 00 00       	push   $0x93
  801586:	68 73 3d 80 00       	push   $0x803d73
  80158b:	e8 26 ed ff ff       	call   8002b6 <_panic>

00801590 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801590:	55                   	push   %ebp
  801591:	89 e5                	mov    %esp,%ebp
  801593:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801596:	e8 59 fd ff ff       	call   8012f4 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80159b:	83 ec 04             	sub    $0x4,%esp
  80159e:	68 3c 3e 80 00       	push   $0x803e3c
  8015a3:	68 c5 00 00 00       	push   $0xc5
  8015a8:	68 73 3d 80 00       	push   $0x803d73
  8015ad:	e8 04 ed ff ff       	call   8002b6 <_panic>

008015b2 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8015b2:	55                   	push   %ebp
  8015b3:	89 e5                	mov    %esp,%ebp
  8015b5:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8015b8:	83 ec 04             	sub    $0x4,%esp
  8015bb:	68 64 3e 80 00       	push   $0x803e64
  8015c0:	68 d9 00 00 00       	push   $0xd9
  8015c5:	68 73 3d 80 00       	push   $0x803d73
  8015ca:	e8 e7 ec ff ff       	call   8002b6 <_panic>

008015cf <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8015cf:	55                   	push   %ebp
  8015d0:	89 e5                	mov    %esp,%ebp
  8015d2:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015d5:	83 ec 04             	sub    $0x4,%esp
  8015d8:	68 88 3e 80 00       	push   $0x803e88
  8015dd:	68 e4 00 00 00       	push   $0xe4
  8015e2:	68 73 3d 80 00       	push   $0x803d73
  8015e7:	e8 ca ec ff ff       	call   8002b6 <_panic>

008015ec <shrink>:

}
void shrink(uint32 newSize)
{
  8015ec:	55                   	push   %ebp
  8015ed:	89 e5                	mov    %esp,%ebp
  8015ef:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015f2:	83 ec 04             	sub    $0x4,%esp
  8015f5:	68 88 3e 80 00       	push   $0x803e88
  8015fa:	68 e9 00 00 00       	push   $0xe9
  8015ff:	68 73 3d 80 00       	push   $0x803d73
  801604:	e8 ad ec ff ff       	call   8002b6 <_panic>

00801609 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801609:	55                   	push   %ebp
  80160a:	89 e5                	mov    %esp,%ebp
  80160c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80160f:	83 ec 04             	sub    $0x4,%esp
  801612:	68 88 3e 80 00       	push   $0x803e88
  801617:	68 ee 00 00 00       	push   $0xee
  80161c:	68 73 3d 80 00       	push   $0x803d73
  801621:	e8 90 ec ff ff       	call   8002b6 <_panic>

00801626 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801626:	55                   	push   %ebp
  801627:	89 e5                	mov    %esp,%ebp
  801629:	57                   	push   %edi
  80162a:	56                   	push   %esi
  80162b:	53                   	push   %ebx
  80162c:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80162f:	8b 45 08             	mov    0x8(%ebp),%eax
  801632:	8b 55 0c             	mov    0xc(%ebp),%edx
  801635:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801638:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80163b:	8b 7d 18             	mov    0x18(%ebp),%edi
  80163e:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801641:	cd 30                	int    $0x30
  801643:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801646:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801649:	83 c4 10             	add    $0x10,%esp
  80164c:	5b                   	pop    %ebx
  80164d:	5e                   	pop    %esi
  80164e:	5f                   	pop    %edi
  80164f:	5d                   	pop    %ebp
  801650:	c3                   	ret    

00801651 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801651:	55                   	push   %ebp
  801652:	89 e5                	mov    %esp,%ebp
  801654:	83 ec 04             	sub    $0x4,%esp
  801657:	8b 45 10             	mov    0x10(%ebp),%eax
  80165a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80165d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801661:	8b 45 08             	mov    0x8(%ebp),%eax
  801664:	6a 00                	push   $0x0
  801666:	6a 00                	push   $0x0
  801668:	52                   	push   %edx
  801669:	ff 75 0c             	pushl  0xc(%ebp)
  80166c:	50                   	push   %eax
  80166d:	6a 00                	push   $0x0
  80166f:	e8 b2 ff ff ff       	call   801626 <syscall>
  801674:	83 c4 18             	add    $0x18,%esp
}
  801677:	90                   	nop
  801678:	c9                   	leave  
  801679:	c3                   	ret    

0080167a <sys_cgetc>:

int
sys_cgetc(void)
{
  80167a:	55                   	push   %ebp
  80167b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80167d:	6a 00                	push   $0x0
  80167f:	6a 00                	push   $0x0
  801681:	6a 00                	push   $0x0
  801683:	6a 00                	push   $0x0
  801685:	6a 00                	push   $0x0
  801687:	6a 01                	push   $0x1
  801689:	e8 98 ff ff ff       	call   801626 <syscall>
  80168e:	83 c4 18             	add    $0x18,%esp
}
  801691:	c9                   	leave  
  801692:	c3                   	ret    

00801693 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801693:	55                   	push   %ebp
  801694:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801696:	8b 55 0c             	mov    0xc(%ebp),%edx
  801699:	8b 45 08             	mov    0x8(%ebp),%eax
  80169c:	6a 00                	push   $0x0
  80169e:	6a 00                	push   $0x0
  8016a0:	6a 00                	push   $0x0
  8016a2:	52                   	push   %edx
  8016a3:	50                   	push   %eax
  8016a4:	6a 05                	push   $0x5
  8016a6:	e8 7b ff ff ff       	call   801626 <syscall>
  8016ab:	83 c4 18             	add    $0x18,%esp
}
  8016ae:	c9                   	leave  
  8016af:	c3                   	ret    

008016b0 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8016b0:	55                   	push   %ebp
  8016b1:	89 e5                	mov    %esp,%ebp
  8016b3:	56                   	push   %esi
  8016b4:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8016b5:	8b 75 18             	mov    0x18(%ebp),%esi
  8016b8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016bb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c4:	56                   	push   %esi
  8016c5:	53                   	push   %ebx
  8016c6:	51                   	push   %ecx
  8016c7:	52                   	push   %edx
  8016c8:	50                   	push   %eax
  8016c9:	6a 06                	push   $0x6
  8016cb:	e8 56 ff ff ff       	call   801626 <syscall>
  8016d0:	83 c4 18             	add    $0x18,%esp
}
  8016d3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016d6:	5b                   	pop    %ebx
  8016d7:	5e                   	pop    %esi
  8016d8:	5d                   	pop    %ebp
  8016d9:	c3                   	ret    

008016da <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8016da:	55                   	push   %ebp
  8016db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8016dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e3:	6a 00                	push   $0x0
  8016e5:	6a 00                	push   $0x0
  8016e7:	6a 00                	push   $0x0
  8016e9:	52                   	push   %edx
  8016ea:	50                   	push   %eax
  8016eb:	6a 07                	push   $0x7
  8016ed:	e8 34 ff ff ff       	call   801626 <syscall>
  8016f2:	83 c4 18             	add    $0x18,%esp
}
  8016f5:	c9                   	leave  
  8016f6:	c3                   	ret    

008016f7 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8016f7:	55                   	push   %ebp
  8016f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8016fa:	6a 00                	push   $0x0
  8016fc:	6a 00                	push   $0x0
  8016fe:	6a 00                	push   $0x0
  801700:	ff 75 0c             	pushl  0xc(%ebp)
  801703:	ff 75 08             	pushl  0x8(%ebp)
  801706:	6a 08                	push   $0x8
  801708:	e8 19 ff ff ff       	call   801626 <syscall>
  80170d:	83 c4 18             	add    $0x18,%esp
}
  801710:	c9                   	leave  
  801711:	c3                   	ret    

00801712 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801712:	55                   	push   %ebp
  801713:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801715:	6a 00                	push   $0x0
  801717:	6a 00                	push   $0x0
  801719:	6a 00                	push   $0x0
  80171b:	6a 00                	push   $0x0
  80171d:	6a 00                	push   $0x0
  80171f:	6a 09                	push   $0x9
  801721:	e8 00 ff ff ff       	call   801626 <syscall>
  801726:	83 c4 18             	add    $0x18,%esp
}
  801729:	c9                   	leave  
  80172a:	c3                   	ret    

0080172b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80172b:	55                   	push   %ebp
  80172c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80172e:	6a 00                	push   $0x0
  801730:	6a 00                	push   $0x0
  801732:	6a 00                	push   $0x0
  801734:	6a 00                	push   $0x0
  801736:	6a 00                	push   $0x0
  801738:	6a 0a                	push   $0xa
  80173a:	e8 e7 fe ff ff       	call   801626 <syscall>
  80173f:	83 c4 18             	add    $0x18,%esp
}
  801742:	c9                   	leave  
  801743:	c3                   	ret    

00801744 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801744:	55                   	push   %ebp
  801745:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801747:	6a 00                	push   $0x0
  801749:	6a 00                	push   $0x0
  80174b:	6a 00                	push   $0x0
  80174d:	6a 00                	push   $0x0
  80174f:	6a 00                	push   $0x0
  801751:	6a 0b                	push   $0xb
  801753:	e8 ce fe ff ff       	call   801626 <syscall>
  801758:	83 c4 18             	add    $0x18,%esp
}
  80175b:	c9                   	leave  
  80175c:	c3                   	ret    

0080175d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80175d:	55                   	push   %ebp
  80175e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801760:	6a 00                	push   $0x0
  801762:	6a 00                	push   $0x0
  801764:	6a 00                	push   $0x0
  801766:	ff 75 0c             	pushl  0xc(%ebp)
  801769:	ff 75 08             	pushl  0x8(%ebp)
  80176c:	6a 0f                	push   $0xf
  80176e:	e8 b3 fe ff ff       	call   801626 <syscall>
  801773:	83 c4 18             	add    $0x18,%esp
	return;
  801776:	90                   	nop
}
  801777:	c9                   	leave  
  801778:	c3                   	ret    

00801779 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801779:	55                   	push   %ebp
  80177a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80177c:	6a 00                	push   $0x0
  80177e:	6a 00                	push   $0x0
  801780:	6a 00                	push   $0x0
  801782:	ff 75 0c             	pushl  0xc(%ebp)
  801785:	ff 75 08             	pushl  0x8(%ebp)
  801788:	6a 10                	push   $0x10
  80178a:	e8 97 fe ff ff       	call   801626 <syscall>
  80178f:	83 c4 18             	add    $0x18,%esp
	return ;
  801792:	90                   	nop
}
  801793:	c9                   	leave  
  801794:	c3                   	ret    

00801795 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801795:	55                   	push   %ebp
  801796:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801798:	6a 00                	push   $0x0
  80179a:	6a 00                	push   $0x0
  80179c:	ff 75 10             	pushl  0x10(%ebp)
  80179f:	ff 75 0c             	pushl  0xc(%ebp)
  8017a2:	ff 75 08             	pushl  0x8(%ebp)
  8017a5:	6a 11                	push   $0x11
  8017a7:	e8 7a fe ff ff       	call   801626 <syscall>
  8017ac:	83 c4 18             	add    $0x18,%esp
	return ;
  8017af:	90                   	nop
}
  8017b0:	c9                   	leave  
  8017b1:	c3                   	ret    

008017b2 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8017b2:	55                   	push   %ebp
  8017b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8017b5:	6a 00                	push   $0x0
  8017b7:	6a 00                	push   $0x0
  8017b9:	6a 00                	push   $0x0
  8017bb:	6a 00                	push   $0x0
  8017bd:	6a 00                	push   $0x0
  8017bf:	6a 0c                	push   $0xc
  8017c1:	e8 60 fe ff ff       	call   801626 <syscall>
  8017c6:	83 c4 18             	add    $0x18,%esp
}
  8017c9:	c9                   	leave  
  8017ca:	c3                   	ret    

008017cb <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8017cb:	55                   	push   %ebp
  8017cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8017ce:	6a 00                	push   $0x0
  8017d0:	6a 00                	push   $0x0
  8017d2:	6a 00                	push   $0x0
  8017d4:	6a 00                	push   $0x0
  8017d6:	ff 75 08             	pushl  0x8(%ebp)
  8017d9:	6a 0d                	push   $0xd
  8017db:	e8 46 fe ff ff       	call   801626 <syscall>
  8017e0:	83 c4 18             	add    $0x18,%esp
}
  8017e3:	c9                   	leave  
  8017e4:	c3                   	ret    

008017e5 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8017e5:	55                   	push   %ebp
  8017e6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8017e8:	6a 00                	push   $0x0
  8017ea:	6a 00                	push   $0x0
  8017ec:	6a 00                	push   $0x0
  8017ee:	6a 00                	push   $0x0
  8017f0:	6a 00                	push   $0x0
  8017f2:	6a 0e                	push   $0xe
  8017f4:	e8 2d fe ff ff       	call   801626 <syscall>
  8017f9:	83 c4 18             	add    $0x18,%esp
}
  8017fc:	90                   	nop
  8017fd:	c9                   	leave  
  8017fe:	c3                   	ret    

008017ff <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8017ff:	55                   	push   %ebp
  801800:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801802:	6a 00                	push   $0x0
  801804:	6a 00                	push   $0x0
  801806:	6a 00                	push   $0x0
  801808:	6a 00                	push   $0x0
  80180a:	6a 00                	push   $0x0
  80180c:	6a 13                	push   $0x13
  80180e:	e8 13 fe ff ff       	call   801626 <syscall>
  801813:	83 c4 18             	add    $0x18,%esp
}
  801816:	90                   	nop
  801817:	c9                   	leave  
  801818:	c3                   	ret    

00801819 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801819:	55                   	push   %ebp
  80181a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80181c:	6a 00                	push   $0x0
  80181e:	6a 00                	push   $0x0
  801820:	6a 00                	push   $0x0
  801822:	6a 00                	push   $0x0
  801824:	6a 00                	push   $0x0
  801826:	6a 14                	push   $0x14
  801828:	e8 f9 fd ff ff       	call   801626 <syscall>
  80182d:	83 c4 18             	add    $0x18,%esp
}
  801830:	90                   	nop
  801831:	c9                   	leave  
  801832:	c3                   	ret    

00801833 <sys_cputc>:


void
sys_cputc(const char c)
{
  801833:	55                   	push   %ebp
  801834:	89 e5                	mov    %esp,%ebp
  801836:	83 ec 04             	sub    $0x4,%esp
  801839:	8b 45 08             	mov    0x8(%ebp),%eax
  80183c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80183f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801843:	6a 00                	push   $0x0
  801845:	6a 00                	push   $0x0
  801847:	6a 00                	push   $0x0
  801849:	6a 00                	push   $0x0
  80184b:	50                   	push   %eax
  80184c:	6a 15                	push   $0x15
  80184e:	e8 d3 fd ff ff       	call   801626 <syscall>
  801853:	83 c4 18             	add    $0x18,%esp
}
  801856:	90                   	nop
  801857:	c9                   	leave  
  801858:	c3                   	ret    

00801859 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801859:	55                   	push   %ebp
  80185a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80185c:	6a 00                	push   $0x0
  80185e:	6a 00                	push   $0x0
  801860:	6a 00                	push   $0x0
  801862:	6a 00                	push   $0x0
  801864:	6a 00                	push   $0x0
  801866:	6a 16                	push   $0x16
  801868:	e8 b9 fd ff ff       	call   801626 <syscall>
  80186d:	83 c4 18             	add    $0x18,%esp
}
  801870:	90                   	nop
  801871:	c9                   	leave  
  801872:	c3                   	ret    

00801873 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801873:	55                   	push   %ebp
  801874:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801876:	8b 45 08             	mov    0x8(%ebp),%eax
  801879:	6a 00                	push   $0x0
  80187b:	6a 00                	push   $0x0
  80187d:	6a 00                	push   $0x0
  80187f:	ff 75 0c             	pushl  0xc(%ebp)
  801882:	50                   	push   %eax
  801883:	6a 17                	push   $0x17
  801885:	e8 9c fd ff ff       	call   801626 <syscall>
  80188a:	83 c4 18             	add    $0x18,%esp
}
  80188d:	c9                   	leave  
  80188e:	c3                   	ret    

0080188f <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80188f:	55                   	push   %ebp
  801890:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801892:	8b 55 0c             	mov    0xc(%ebp),%edx
  801895:	8b 45 08             	mov    0x8(%ebp),%eax
  801898:	6a 00                	push   $0x0
  80189a:	6a 00                	push   $0x0
  80189c:	6a 00                	push   $0x0
  80189e:	52                   	push   %edx
  80189f:	50                   	push   %eax
  8018a0:	6a 1a                	push   $0x1a
  8018a2:	e8 7f fd ff ff       	call   801626 <syscall>
  8018a7:	83 c4 18             	add    $0x18,%esp
}
  8018aa:	c9                   	leave  
  8018ab:	c3                   	ret    

008018ac <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8018ac:	55                   	push   %ebp
  8018ad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b5:	6a 00                	push   $0x0
  8018b7:	6a 00                	push   $0x0
  8018b9:	6a 00                	push   $0x0
  8018bb:	52                   	push   %edx
  8018bc:	50                   	push   %eax
  8018bd:	6a 18                	push   $0x18
  8018bf:	e8 62 fd ff ff       	call   801626 <syscall>
  8018c4:	83 c4 18             	add    $0x18,%esp
}
  8018c7:	90                   	nop
  8018c8:	c9                   	leave  
  8018c9:	c3                   	ret    

008018ca <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8018ca:	55                   	push   %ebp
  8018cb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d3:	6a 00                	push   $0x0
  8018d5:	6a 00                	push   $0x0
  8018d7:	6a 00                	push   $0x0
  8018d9:	52                   	push   %edx
  8018da:	50                   	push   %eax
  8018db:	6a 19                	push   $0x19
  8018dd:	e8 44 fd ff ff       	call   801626 <syscall>
  8018e2:	83 c4 18             	add    $0x18,%esp
}
  8018e5:	90                   	nop
  8018e6:	c9                   	leave  
  8018e7:	c3                   	ret    

008018e8 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8018e8:	55                   	push   %ebp
  8018e9:	89 e5                	mov    %esp,%ebp
  8018eb:	83 ec 04             	sub    $0x4,%esp
  8018ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8018f1:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8018f4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8018f7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fe:	6a 00                	push   $0x0
  801900:	51                   	push   %ecx
  801901:	52                   	push   %edx
  801902:	ff 75 0c             	pushl  0xc(%ebp)
  801905:	50                   	push   %eax
  801906:	6a 1b                	push   $0x1b
  801908:	e8 19 fd ff ff       	call   801626 <syscall>
  80190d:	83 c4 18             	add    $0x18,%esp
}
  801910:	c9                   	leave  
  801911:	c3                   	ret    

00801912 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801912:	55                   	push   %ebp
  801913:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801915:	8b 55 0c             	mov    0xc(%ebp),%edx
  801918:	8b 45 08             	mov    0x8(%ebp),%eax
  80191b:	6a 00                	push   $0x0
  80191d:	6a 00                	push   $0x0
  80191f:	6a 00                	push   $0x0
  801921:	52                   	push   %edx
  801922:	50                   	push   %eax
  801923:	6a 1c                	push   $0x1c
  801925:	e8 fc fc ff ff       	call   801626 <syscall>
  80192a:	83 c4 18             	add    $0x18,%esp
}
  80192d:	c9                   	leave  
  80192e:	c3                   	ret    

0080192f <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80192f:	55                   	push   %ebp
  801930:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801932:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801935:	8b 55 0c             	mov    0xc(%ebp),%edx
  801938:	8b 45 08             	mov    0x8(%ebp),%eax
  80193b:	6a 00                	push   $0x0
  80193d:	6a 00                	push   $0x0
  80193f:	51                   	push   %ecx
  801940:	52                   	push   %edx
  801941:	50                   	push   %eax
  801942:	6a 1d                	push   $0x1d
  801944:	e8 dd fc ff ff       	call   801626 <syscall>
  801949:	83 c4 18             	add    $0x18,%esp
}
  80194c:	c9                   	leave  
  80194d:	c3                   	ret    

0080194e <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80194e:	55                   	push   %ebp
  80194f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801951:	8b 55 0c             	mov    0xc(%ebp),%edx
  801954:	8b 45 08             	mov    0x8(%ebp),%eax
  801957:	6a 00                	push   $0x0
  801959:	6a 00                	push   $0x0
  80195b:	6a 00                	push   $0x0
  80195d:	52                   	push   %edx
  80195e:	50                   	push   %eax
  80195f:	6a 1e                	push   $0x1e
  801961:	e8 c0 fc ff ff       	call   801626 <syscall>
  801966:	83 c4 18             	add    $0x18,%esp
}
  801969:	c9                   	leave  
  80196a:	c3                   	ret    

0080196b <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80196b:	55                   	push   %ebp
  80196c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80196e:	6a 00                	push   $0x0
  801970:	6a 00                	push   $0x0
  801972:	6a 00                	push   $0x0
  801974:	6a 00                	push   $0x0
  801976:	6a 00                	push   $0x0
  801978:	6a 1f                	push   $0x1f
  80197a:	e8 a7 fc ff ff       	call   801626 <syscall>
  80197f:	83 c4 18             	add    $0x18,%esp
}
  801982:	c9                   	leave  
  801983:	c3                   	ret    

00801984 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801984:	55                   	push   %ebp
  801985:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801987:	8b 45 08             	mov    0x8(%ebp),%eax
  80198a:	6a 00                	push   $0x0
  80198c:	ff 75 14             	pushl  0x14(%ebp)
  80198f:	ff 75 10             	pushl  0x10(%ebp)
  801992:	ff 75 0c             	pushl  0xc(%ebp)
  801995:	50                   	push   %eax
  801996:	6a 20                	push   $0x20
  801998:	e8 89 fc ff ff       	call   801626 <syscall>
  80199d:	83 c4 18             	add    $0x18,%esp
}
  8019a0:	c9                   	leave  
  8019a1:	c3                   	ret    

008019a2 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8019a2:	55                   	push   %ebp
  8019a3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8019a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a8:	6a 00                	push   $0x0
  8019aa:	6a 00                	push   $0x0
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 00                	push   $0x0
  8019b0:	50                   	push   %eax
  8019b1:	6a 21                	push   $0x21
  8019b3:	e8 6e fc ff ff       	call   801626 <syscall>
  8019b8:	83 c4 18             	add    $0x18,%esp
}
  8019bb:	90                   	nop
  8019bc:	c9                   	leave  
  8019bd:	c3                   	ret    

008019be <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8019be:	55                   	push   %ebp
  8019bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8019c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c4:	6a 00                	push   $0x0
  8019c6:	6a 00                	push   $0x0
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	50                   	push   %eax
  8019cd:	6a 22                	push   $0x22
  8019cf:	e8 52 fc ff ff       	call   801626 <syscall>
  8019d4:	83 c4 18             	add    $0x18,%esp
}
  8019d7:	c9                   	leave  
  8019d8:	c3                   	ret    

008019d9 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8019d9:	55                   	push   %ebp
  8019da:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 02                	push   $0x2
  8019e8:	e8 39 fc ff ff       	call   801626 <syscall>
  8019ed:	83 c4 18             	add    $0x18,%esp
}
  8019f0:	c9                   	leave  
  8019f1:	c3                   	ret    

008019f2 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8019f2:	55                   	push   %ebp
  8019f3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 00                	push   $0x0
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 00                	push   $0x0
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 03                	push   $0x3
  801a01:	e8 20 fc ff ff       	call   801626 <syscall>
  801a06:	83 c4 18             	add    $0x18,%esp
}
  801a09:	c9                   	leave  
  801a0a:	c3                   	ret    

00801a0b <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801a0b:	55                   	push   %ebp
  801a0c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801a0e:	6a 00                	push   $0x0
  801a10:	6a 00                	push   $0x0
  801a12:	6a 00                	push   $0x0
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	6a 04                	push   $0x4
  801a1a:	e8 07 fc ff ff       	call   801626 <syscall>
  801a1f:	83 c4 18             	add    $0x18,%esp
}
  801a22:	c9                   	leave  
  801a23:	c3                   	ret    

00801a24 <sys_exit_env>:


void sys_exit_env(void)
{
  801a24:	55                   	push   %ebp
  801a25:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801a27:	6a 00                	push   $0x0
  801a29:	6a 00                	push   $0x0
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 00                	push   $0x0
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 23                	push   $0x23
  801a33:	e8 ee fb ff ff       	call   801626 <syscall>
  801a38:	83 c4 18             	add    $0x18,%esp
}
  801a3b:	90                   	nop
  801a3c:	c9                   	leave  
  801a3d:	c3                   	ret    

00801a3e <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801a3e:	55                   	push   %ebp
  801a3f:	89 e5                	mov    %esp,%ebp
  801a41:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801a44:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a47:	8d 50 04             	lea    0x4(%eax),%edx
  801a4a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a4d:	6a 00                	push   $0x0
  801a4f:	6a 00                	push   $0x0
  801a51:	6a 00                	push   $0x0
  801a53:	52                   	push   %edx
  801a54:	50                   	push   %eax
  801a55:	6a 24                	push   $0x24
  801a57:	e8 ca fb ff ff       	call   801626 <syscall>
  801a5c:	83 c4 18             	add    $0x18,%esp
	return result;
  801a5f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a62:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a65:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a68:	89 01                	mov    %eax,(%ecx)
  801a6a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a70:	c9                   	leave  
  801a71:	c2 04 00             	ret    $0x4

00801a74 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801a74:	55                   	push   %ebp
  801a75:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801a77:	6a 00                	push   $0x0
  801a79:	6a 00                	push   $0x0
  801a7b:	ff 75 10             	pushl  0x10(%ebp)
  801a7e:	ff 75 0c             	pushl  0xc(%ebp)
  801a81:	ff 75 08             	pushl  0x8(%ebp)
  801a84:	6a 12                	push   $0x12
  801a86:	e8 9b fb ff ff       	call   801626 <syscall>
  801a8b:	83 c4 18             	add    $0x18,%esp
	return ;
  801a8e:	90                   	nop
}
  801a8f:	c9                   	leave  
  801a90:	c3                   	ret    

00801a91 <sys_rcr2>:
uint32 sys_rcr2()
{
  801a91:	55                   	push   %ebp
  801a92:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801a94:	6a 00                	push   $0x0
  801a96:	6a 00                	push   $0x0
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 25                	push   $0x25
  801aa0:	e8 81 fb ff ff       	call   801626 <syscall>
  801aa5:	83 c4 18             	add    $0x18,%esp
}
  801aa8:	c9                   	leave  
  801aa9:	c3                   	ret    

00801aaa <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801aaa:	55                   	push   %ebp
  801aab:	89 e5                	mov    %esp,%ebp
  801aad:	83 ec 04             	sub    $0x4,%esp
  801ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ab6:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801aba:	6a 00                	push   $0x0
  801abc:	6a 00                	push   $0x0
  801abe:	6a 00                	push   $0x0
  801ac0:	6a 00                	push   $0x0
  801ac2:	50                   	push   %eax
  801ac3:	6a 26                	push   $0x26
  801ac5:	e8 5c fb ff ff       	call   801626 <syscall>
  801aca:	83 c4 18             	add    $0x18,%esp
	return ;
  801acd:	90                   	nop
}
  801ace:	c9                   	leave  
  801acf:	c3                   	ret    

00801ad0 <rsttst>:
void rsttst()
{
  801ad0:	55                   	push   %ebp
  801ad1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ad3:	6a 00                	push   $0x0
  801ad5:	6a 00                	push   $0x0
  801ad7:	6a 00                	push   $0x0
  801ad9:	6a 00                	push   $0x0
  801adb:	6a 00                	push   $0x0
  801add:	6a 28                	push   $0x28
  801adf:	e8 42 fb ff ff       	call   801626 <syscall>
  801ae4:	83 c4 18             	add    $0x18,%esp
	return ;
  801ae7:	90                   	nop
}
  801ae8:	c9                   	leave  
  801ae9:	c3                   	ret    

00801aea <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801aea:	55                   	push   %ebp
  801aeb:	89 e5                	mov    %esp,%ebp
  801aed:	83 ec 04             	sub    $0x4,%esp
  801af0:	8b 45 14             	mov    0x14(%ebp),%eax
  801af3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801af6:	8b 55 18             	mov    0x18(%ebp),%edx
  801af9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801afd:	52                   	push   %edx
  801afe:	50                   	push   %eax
  801aff:	ff 75 10             	pushl  0x10(%ebp)
  801b02:	ff 75 0c             	pushl  0xc(%ebp)
  801b05:	ff 75 08             	pushl  0x8(%ebp)
  801b08:	6a 27                	push   $0x27
  801b0a:	e8 17 fb ff ff       	call   801626 <syscall>
  801b0f:	83 c4 18             	add    $0x18,%esp
	return ;
  801b12:	90                   	nop
}
  801b13:	c9                   	leave  
  801b14:	c3                   	ret    

00801b15 <chktst>:
void chktst(uint32 n)
{
  801b15:	55                   	push   %ebp
  801b16:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 00                	push   $0x0
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 00                	push   $0x0
  801b20:	ff 75 08             	pushl  0x8(%ebp)
  801b23:	6a 29                	push   $0x29
  801b25:	e8 fc fa ff ff       	call   801626 <syscall>
  801b2a:	83 c4 18             	add    $0x18,%esp
	return ;
  801b2d:	90                   	nop
}
  801b2e:	c9                   	leave  
  801b2f:	c3                   	ret    

00801b30 <inctst>:

void inctst()
{
  801b30:	55                   	push   %ebp
  801b31:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801b33:	6a 00                	push   $0x0
  801b35:	6a 00                	push   $0x0
  801b37:	6a 00                	push   $0x0
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 2a                	push   $0x2a
  801b3f:	e8 e2 fa ff ff       	call   801626 <syscall>
  801b44:	83 c4 18             	add    $0x18,%esp
	return ;
  801b47:	90                   	nop
}
  801b48:	c9                   	leave  
  801b49:	c3                   	ret    

00801b4a <gettst>:
uint32 gettst()
{
  801b4a:	55                   	push   %ebp
  801b4b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801b4d:	6a 00                	push   $0x0
  801b4f:	6a 00                	push   $0x0
  801b51:	6a 00                	push   $0x0
  801b53:	6a 00                	push   $0x0
  801b55:	6a 00                	push   $0x0
  801b57:	6a 2b                	push   $0x2b
  801b59:	e8 c8 fa ff ff       	call   801626 <syscall>
  801b5e:	83 c4 18             	add    $0x18,%esp
}
  801b61:	c9                   	leave  
  801b62:	c3                   	ret    

00801b63 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801b63:	55                   	push   %ebp
  801b64:	89 e5                	mov    %esp,%ebp
  801b66:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b69:	6a 00                	push   $0x0
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 00                	push   $0x0
  801b73:	6a 2c                	push   $0x2c
  801b75:	e8 ac fa ff ff       	call   801626 <syscall>
  801b7a:	83 c4 18             	add    $0x18,%esp
  801b7d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801b80:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801b84:	75 07                	jne    801b8d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801b86:	b8 01 00 00 00       	mov    $0x1,%eax
  801b8b:	eb 05                	jmp    801b92 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801b8d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b92:	c9                   	leave  
  801b93:	c3                   	ret    

00801b94 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801b94:	55                   	push   %ebp
  801b95:	89 e5                	mov    %esp,%ebp
  801b97:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b9a:	6a 00                	push   $0x0
  801b9c:	6a 00                	push   $0x0
  801b9e:	6a 00                	push   $0x0
  801ba0:	6a 00                	push   $0x0
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 2c                	push   $0x2c
  801ba6:	e8 7b fa ff ff       	call   801626 <syscall>
  801bab:	83 c4 18             	add    $0x18,%esp
  801bae:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801bb1:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801bb5:	75 07                	jne    801bbe <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801bb7:	b8 01 00 00 00       	mov    $0x1,%eax
  801bbc:	eb 05                	jmp    801bc3 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801bbe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bc3:	c9                   	leave  
  801bc4:	c3                   	ret    

00801bc5 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801bc5:	55                   	push   %ebp
  801bc6:	89 e5                	mov    %esp,%ebp
  801bc8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bcb:	6a 00                	push   $0x0
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 00                	push   $0x0
  801bd1:	6a 00                	push   $0x0
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 2c                	push   $0x2c
  801bd7:	e8 4a fa ff ff       	call   801626 <syscall>
  801bdc:	83 c4 18             	add    $0x18,%esp
  801bdf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801be2:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801be6:	75 07                	jne    801bef <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801be8:	b8 01 00 00 00       	mov    $0x1,%eax
  801bed:	eb 05                	jmp    801bf4 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801bef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bf4:	c9                   	leave  
  801bf5:	c3                   	ret    

00801bf6 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801bf6:	55                   	push   %ebp
  801bf7:	89 e5                	mov    %esp,%ebp
  801bf9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	6a 00                	push   $0x0
  801c04:	6a 00                	push   $0x0
  801c06:	6a 2c                	push   $0x2c
  801c08:	e8 19 fa ff ff       	call   801626 <syscall>
  801c0d:	83 c4 18             	add    $0x18,%esp
  801c10:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801c13:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801c17:	75 07                	jne    801c20 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801c19:	b8 01 00 00 00       	mov    $0x1,%eax
  801c1e:	eb 05                	jmp    801c25 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801c20:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c25:	c9                   	leave  
  801c26:	c3                   	ret    

00801c27 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c27:	55                   	push   %ebp
  801c28:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c2a:	6a 00                	push   $0x0
  801c2c:	6a 00                	push   $0x0
  801c2e:	6a 00                	push   $0x0
  801c30:	6a 00                	push   $0x0
  801c32:	ff 75 08             	pushl  0x8(%ebp)
  801c35:	6a 2d                	push   $0x2d
  801c37:	e8 ea f9 ff ff       	call   801626 <syscall>
  801c3c:	83 c4 18             	add    $0x18,%esp
	return ;
  801c3f:	90                   	nop
}
  801c40:	c9                   	leave  
  801c41:	c3                   	ret    

00801c42 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801c42:	55                   	push   %ebp
  801c43:	89 e5                	mov    %esp,%ebp
  801c45:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801c46:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c49:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c4c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c52:	6a 00                	push   $0x0
  801c54:	53                   	push   %ebx
  801c55:	51                   	push   %ecx
  801c56:	52                   	push   %edx
  801c57:	50                   	push   %eax
  801c58:	6a 2e                	push   $0x2e
  801c5a:	e8 c7 f9 ff ff       	call   801626 <syscall>
  801c5f:	83 c4 18             	add    $0x18,%esp
}
  801c62:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c65:	c9                   	leave  
  801c66:	c3                   	ret    

00801c67 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801c67:	55                   	push   %ebp
  801c68:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801c6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c70:	6a 00                	push   $0x0
  801c72:	6a 00                	push   $0x0
  801c74:	6a 00                	push   $0x0
  801c76:	52                   	push   %edx
  801c77:	50                   	push   %eax
  801c78:	6a 2f                	push   $0x2f
  801c7a:	e8 a7 f9 ff ff       	call   801626 <syscall>
  801c7f:	83 c4 18             	add    $0x18,%esp
}
  801c82:	c9                   	leave  
  801c83:	c3                   	ret    

00801c84 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801c84:	55                   	push   %ebp
  801c85:	89 e5                	mov    %esp,%ebp
  801c87:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801c8a:	83 ec 0c             	sub    $0xc,%esp
  801c8d:	68 98 3e 80 00       	push   $0x803e98
  801c92:	e8 d3 e8 ff ff       	call   80056a <cprintf>
  801c97:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801c9a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801ca1:	83 ec 0c             	sub    $0xc,%esp
  801ca4:	68 c4 3e 80 00       	push   $0x803ec4
  801ca9:	e8 bc e8 ff ff       	call   80056a <cprintf>
  801cae:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801cb1:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801cb5:	a1 38 51 80 00       	mov    0x805138,%eax
  801cba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801cbd:	eb 56                	jmp    801d15 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801cbf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801cc3:	74 1c                	je     801ce1 <print_mem_block_lists+0x5d>
  801cc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cc8:	8b 50 08             	mov    0x8(%eax),%edx
  801ccb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cce:	8b 48 08             	mov    0x8(%eax),%ecx
  801cd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cd4:	8b 40 0c             	mov    0xc(%eax),%eax
  801cd7:	01 c8                	add    %ecx,%eax
  801cd9:	39 c2                	cmp    %eax,%edx
  801cdb:	73 04                	jae    801ce1 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801cdd:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801ce1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ce4:	8b 50 08             	mov    0x8(%eax),%edx
  801ce7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cea:	8b 40 0c             	mov    0xc(%eax),%eax
  801ced:	01 c2                	add    %eax,%edx
  801cef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cf2:	8b 40 08             	mov    0x8(%eax),%eax
  801cf5:	83 ec 04             	sub    $0x4,%esp
  801cf8:	52                   	push   %edx
  801cf9:	50                   	push   %eax
  801cfa:	68 d9 3e 80 00       	push   $0x803ed9
  801cff:	e8 66 e8 ff ff       	call   80056a <cprintf>
  801d04:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801d07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d0a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d0d:	a1 40 51 80 00       	mov    0x805140,%eax
  801d12:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d15:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d19:	74 07                	je     801d22 <print_mem_block_lists+0x9e>
  801d1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d1e:	8b 00                	mov    (%eax),%eax
  801d20:	eb 05                	jmp    801d27 <print_mem_block_lists+0xa3>
  801d22:	b8 00 00 00 00       	mov    $0x0,%eax
  801d27:	a3 40 51 80 00       	mov    %eax,0x805140
  801d2c:	a1 40 51 80 00       	mov    0x805140,%eax
  801d31:	85 c0                	test   %eax,%eax
  801d33:	75 8a                	jne    801cbf <print_mem_block_lists+0x3b>
  801d35:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d39:	75 84                	jne    801cbf <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801d3b:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801d3f:	75 10                	jne    801d51 <print_mem_block_lists+0xcd>
  801d41:	83 ec 0c             	sub    $0xc,%esp
  801d44:	68 e8 3e 80 00       	push   $0x803ee8
  801d49:	e8 1c e8 ff ff       	call   80056a <cprintf>
  801d4e:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801d51:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801d58:	83 ec 0c             	sub    $0xc,%esp
  801d5b:	68 0c 3f 80 00       	push   $0x803f0c
  801d60:	e8 05 e8 ff ff       	call   80056a <cprintf>
  801d65:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801d68:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801d6c:	a1 40 50 80 00       	mov    0x805040,%eax
  801d71:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d74:	eb 56                	jmp    801dcc <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801d76:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d7a:	74 1c                	je     801d98 <print_mem_block_lists+0x114>
  801d7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d7f:	8b 50 08             	mov    0x8(%eax),%edx
  801d82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d85:	8b 48 08             	mov    0x8(%eax),%ecx
  801d88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d8b:	8b 40 0c             	mov    0xc(%eax),%eax
  801d8e:	01 c8                	add    %ecx,%eax
  801d90:	39 c2                	cmp    %eax,%edx
  801d92:	73 04                	jae    801d98 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801d94:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801d98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d9b:	8b 50 08             	mov    0x8(%eax),%edx
  801d9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801da1:	8b 40 0c             	mov    0xc(%eax),%eax
  801da4:	01 c2                	add    %eax,%edx
  801da6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801da9:	8b 40 08             	mov    0x8(%eax),%eax
  801dac:	83 ec 04             	sub    $0x4,%esp
  801daf:	52                   	push   %edx
  801db0:	50                   	push   %eax
  801db1:	68 d9 3e 80 00       	push   $0x803ed9
  801db6:	e8 af e7 ff ff       	call   80056a <cprintf>
  801dbb:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801dbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801dc4:	a1 48 50 80 00       	mov    0x805048,%eax
  801dc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dcc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801dd0:	74 07                	je     801dd9 <print_mem_block_lists+0x155>
  801dd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd5:	8b 00                	mov    (%eax),%eax
  801dd7:	eb 05                	jmp    801dde <print_mem_block_lists+0x15a>
  801dd9:	b8 00 00 00 00       	mov    $0x0,%eax
  801dde:	a3 48 50 80 00       	mov    %eax,0x805048
  801de3:	a1 48 50 80 00       	mov    0x805048,%eax
  801de8:	85 c0                	test   %eax,%eax
  801dea:	75 8a                	jne    801d76 <print_mem_block_lists+0xf2>
  801dec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801df0:	75 84                	jne    801d76 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801df2:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801df6:	75 10                	jne    801e08 <print_mem_block_lists+0x184>
  801df8:	83 ec 0c             	sub    $0xc,%esp
  801dfb:	68 24 3f 80 00       	push   $0x803f24
  801e00:	e8 65 e7 ff ff       	call   80056a <cprintf>
  801e05:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801e08:	83 ec 0c             	sub    $0xc,%esp
  801e0b:	68 98 3e 80 00       	push   $0x803e98
  801e10:	e8 55 e7 ff ff       	call   80056a <cprintf>
  801e15:	83 c4 10             	add    $0x10,%esp

}
  801e18:	90                   	nop
  801e19:	c9                   	leave  
  801e1a:	c3                   	ret    

00801e1b <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801e1b:	55                   	push   %ebp
  801e1c:	89 e5                	mov    %esp,%ebp
  801e1e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801e21:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  801e28:	00 00 00 
  801e2b:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  801e32:	00 00 00 
  801e35:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  801e3c:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801e3f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801e46:	e9 9e 00 00 00       	jmp    801ee9 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801e4b:	a1 50 50 80 00       	mov    0x805050,%eax
  801e50:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e53:	c1 e2 04             	shl    $0x4,%edx
  801e56:	01 d0                	add    %edx,%eax
  801e58:	85 c0                	test   %eax,%eax
  801e5a:	75 14                	jne    801e70 <initialize_MemBlocksList+0x55>
  801e5c:	83 ec 04             	sub    $0x4,%esp
  801e5f:	68 4c 3f 80 00       	push   $0x803f4c
  801e64:	6a 46                	push   $0x46
  801e66:	68 6f 3f 80 00       	push   $0x803f6f
  801e6b:	e8 46 e4 ff ff       	call   8002b6 <_panic>
  801e70:	a1 50 50 80 00       	mov    0x805050,%eax
  801e75:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e78:	c1 e2 04             	shl    $0x4,%edx
  801e7b:	01 d0                	add    %edx,%eax
  801e7d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  801e83:	89 10                	mov    %edx,(%eax)
  801e85:	8b 00                	mov    (%eax),%eax
  801e87:	85 c0                	test   %eax,%eax
  801e89:	74 18                	je     801ea3 <initialize_MemBlocksList+0x88>
  801e8b:	a1 48 51 80 00       	mov    0x805148,%eax
  801e90:	8b 15 50 50 80 00    	mov    0x805050,%edx
  801e96:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801e99:	c1 e1 04             	shl    $0x4,%ecx
  801e9c:	01 ca                	add    %ecx,%edx
  801e9e:	89 50 04             	mov    %edx,0x4(%eax)
  801ea1:	eb 12                	jmp    801eb5 <initialize_MemBlocksList+0x9a>
  801ea3:	a1 50 50 80 00       	mov    0x805050,%eax
  801ea8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801eab:	c1 e2 04             	shl    $0x4,%edx
  801eae:	01 d0                	add    %edx,%eax
  801eb0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801eb5:	a1 50 50 80 00       	mov    0x805050,%eax
  801eba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ebd:	c1 e2 04             	shl    $0x4,%edx
  801ec0:	01 d0                	add    %edx,%eax
  801ec2:	a3 48 51 80 00       	mov    %eax,0x805148
  801ec7:	a1 50 50 80 00       	mov    0x805050,%eax
  801ecc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ecf:	c1 e2 04             	shl    $0x4,%edx
  801ed2:	01 d0                	add    %edx,%eax
  801ed4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801edb:	a1 54 51 80 00       	mov    0x805154,%eax
  801ee0:	40                   	inc    %eax
  801ee1:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801ee6:	ff 45 f4             	incl   -0xc(%ebp)
  801ee9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eec:	3b 45 08             	cmp    0x8(%ebp),%eax
  801eef:	0f 82 56 ff ff ff    	jb     801e4b <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801ef5:	90                   	nop
  801ef6:	c9                   	leave  
  801ef7:	c3                   	ret    

00801ef8 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801ef8:	55                   	push   %ebp
  801ef9:	89 e5                	mov    %esp,%ebp
  801efb:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801efe:	8b 45 08             	mov    0x8(%ebp),%eax
  801f01:	8b 00                	mov    (%eax),%eax
  801f03:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f06:	eb 19                	jmp    801f21 <find_block+0x29>
	{
		if(va==point->sva)
  801f08:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f0b:	8b 40 08             	mov    0x8(%eax),%eax
  801f0e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801f11:	75 05                	jne    801f18 <find_block+0x20>
		   return point;
  801f13:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f16:	eb 36                	jmp    801f4e <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801f18:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1b:	8b 40 08             	mov    0x8(%eax),%eax
  801f1e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f21:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f25:	74 07                	je     801f2e <find_block+0x36>
  801f27:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f2a:	8b 00                	mov    (%eax),%eax
  801f2c:	eb 05                	jmp    801f33 <find_block+0x3b>
  801f2e:	b8 00 00 00 00       	mov    $0x0,%eax
  801f33:	8b 55 08             	mov    0x8(%ebp),%edx
  801f36:	89 42 08             	mov    %eax,0x8(%edx)
  801f39:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3c:	8b 40 08             	mov    0x8(%eax),%eax
  801f3f:	85 c0                	test   %eax,%eax
  801f41:	75 c5                	jne    801f08 <find_block+0x10>
  801f43:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f47:	75 bf                	jne    801f08 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  801f49:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f4e:	c9                   	leave  
  801f4f:	c3                   	ret    

00801f50 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  801f50:	55                   	push   %ebp
  801f51:	89 e5                	mov    %esp,%ebp
  801f53:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  801f56:	a1 40 50 80 00       	mov    0x805040,%eax
  801f5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  801f5e:	a1 44 50 80 00       	mov    0x805044,%eax
  801f63:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  801f66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f69:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801f6c:	74 24                	je     801f92 <insert_sorted_allocList+0x42>
  801f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f71:	8b 50 08             	mov    0x8(%eax),%edx
  801f74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f77:	8b 40 08             	mov    0x8(%eax),%eax
  801f7a:	39 c2                	cmp    %eax,%edx
  801f7c:	76 14                	jbe    801f92 <insert_sorted_allocList+0x42>
  801f7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f81:	8b 50 08             	mov    0x8(%eax),%edx
  801f84:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f87:	8b 40 08             	mov    0x8(%eax),%eax
  801f8a:	39 c2                	cmp    %eax,%edx
  801f8c:	0f 82 60 01 00 00    	jb     8020f2 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  801f92:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f96:	75 65                	jne    801ffd <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  801f98:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f9c:	75 14                	jne    801fb2 <insert_sorted_allocList+0x62>
  801f9e:	83 ec 04             	sub    $0x4,%esp
  801fa1:	68 4c 3f 80 00       	push   $0x803f4c
  801fa6:	6a 6b                	push   $0x6b
  801fa8:	68 6f 3f 80 00       	push   $0x803f6f
  801fad:	e8 04 e3 ff ff       	call   8002b6 <_panic>
  801fb2:	8b 15 40 50 80 00    	mov    0x805040,%edx
  801fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  801fbb:	89 10                	mov    %edx,(%eax)
  801fbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc0:	8b 00                	mov    (%eax),%eax
  801fc2:	85 c0                	test   %eax,%eax
  801fc4:	74 0d                	je     801fd3 <insert_sorted_allocList+0x83>
  801fc6:	a1 40 50 80 00       	mov    0x805040,%eax
  801fcb:	8b 55 08             	mov    0x8(%ebp),%edx
  801fce:	89 50 04             	mov    %edx,0x4(%eax)
  801fd1:	eb 08                	jmp    801fdb <insert_sorted_allocList+0x8b>
  801fd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd6:	a3 44 50 80 00       	mov    %eax,0x805044
  801fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fde:	a3 40 50 80 00       	mov    %eax,0x805040
  801fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801fed:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801ff2:	40                   	inc    %eax
  801ff3:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  801ff8:	e9 dc 01 00 00       	jmp    8021d9 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  801ffd:	8b 45 08             	mov    0x8(%ebp),%eax
  802000:	8b 50 08             	mov    0x8(%eax),%edx
  802003:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802006:	8b 40 08             	mov    0x8(%eax),%eax
  802009:	39 c2                	cmp    %eax,%edx
  80200b:	77 6c                	ja     802079 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  80200d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802011:	74 06                	je     802019 <insert_sorted_allocList+0xc9>
  802013:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802017:	75 14                	jne    80202d <insert_sorted_allocList+0xdd>
  802019:	83 ec 04             	sub    $0x4,%esp
  80201c:	68 88 3f 80 00       	push   $0x803f88
  802021:	6a 6f                	push   $0x6f
  802023:	68 6f 3f 80 00       	push   $0x803f6f
  802028:	e8 89 e2 ff ff       	call   8002b6 <_panic>
  80202d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802030:	8b 50 04             	mov    0x4(%eax),%edx
  802033:	8b 45 08             	mov    0x8(%ebp),%eax
  802036:	89 50 04             	mov    %edx,0x4(%eax)
  802039:	8b 45 08             	mov    0x8(%ebp),%eax
  80203c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80203f:	89 10                	mov    %edx,(%eax)
  802041:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802044:	8b 40 04             	mov    0x4(%eax),%eax
  802047:	85 c0                	test   %eax,%eax
  802049:	74 0d                	je     802058 <insert_sorted_allocList+0x108>
  80204b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80204e:	8b 40 04             	mov    0x4(%eax),%eax
  802051:	8b 55 08             	mov    0x8(%ebp),%edx
  802054:	89 10                	mov    %edx,(%eax)
  802056:	eb 08                	jmp    802060 <insert_sorted_allocList+0x110>
  802058:	8b 45 08             	mov    0x8(%ebp),%eax
  80205b:	a3 40 50 80 00       	mov    %eax,0x805040
  802060:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802063:	8b 55 08             	mov    0x8(%ebp),%edx
  802066:	89 50 04             	mov    %edx,0x4(%eax)
  802069:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80206e:	40                   	inc    %eax
  80206f:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802074:	e9 60 01 00 00       	jmp    8021d9 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802079:	8b 45 08             	mov    0x8(%ebp),%eax
  80207c:	8b 50 08             	mov    0x8(%eax),%edx
  80207f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802082:	8b 40 08             	mov    0x8(%eax),%eax
  802085:	39 c2                	cmp    %eax,%edx
  802087:	0f 82 4c 01 00 00    	jb     8021d9 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  80208d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802091:	75 14                	jne    8020a7 <insert_sorted_allocList+0x157>
  802093:	83 ec 04             	sub    $0x4,%esp
  802096:	68 c0 3f 80 00       	push   $0x803fc0
  80209b:	6a 73                	push   $0x73
  80209d:	68 6f 3f 80 00       	push   $0x803f6f
  8020a2:	e8 0f e2 ff ff       	call   8002b6 <_panic>
  8020a7:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8020ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b0:	89 50 04             	mov    %edx,0x4(%eax)
  8020b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b6:	8b 40 04             	mov    0x4(%eax),%eax
  8020b9:	85 c0                	test   %eax,%eax
  8020bb:	74 0c                	je     8020c9 <insert_sorted_allocList+0x179>
  8020bd:	a1 44 50 80 00       	mov    0x805044,%eax
  8020c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8020c5:	89 10                	mov    %edx,(%eax)
  8020c7:	eb 08                	jmp    8020d1 <insert_sorted_allocList+0x181>
  8020c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cc:	a3 40 50 80 00       	mov    %eax,0x805040
  8020d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d4:	a3 44 50 80 00       	mov    %eax,0x805044
  8020d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020dc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8020e2:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8020e7:	40                   	inc    %eax
  8020e8:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8020ed:	e9 e7 00 00 00       	jmp    8021d9 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8020f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8020f8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8020ff:	a1 40 50 80 00       	mov    0x805040,%eax
  802104:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802107:	e9 9d 00 00 00       	jmp    8021a9 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  80210c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80210f:	8b 00                	mov    (%eax),%eax
  802111:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802114:	8b 45 08             	mov    0x8(%ebp),%eax
  802117:	8b 50 08             	mov    0x8(%eax),%edx
  80211a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211d:	8b 40 08             	mov    0x8(%eax),%eax
  802120:	39 c2                	cmp    %eax,%edx
  802122:	76 7d                	jbe    8021a1 <insert_sorted_allocList+0x251>
  802124:	8b 45 08             	mov    0x8(%ebp),%eax
  802127:	8b 50 08             	mov    0x8(%eax),%edx
  80212a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80212d:	8b 40 08             	mov    0x8(%eax),%eax
  802130:	39 c2                	cmp    %eax,%edx
  802132:	73 6d                	jae    8021a1 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802134:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802138:	74 06                	je     802140 <insert_sorted_allocList+0x1f0>
  80213a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80213e:	75 14                	jne    802154 <insert_sorted_allocList+0x204>
  802140:	83 ec 04             	sub    $0x4,%esp
  802143:	68 e4 3f 80 00       	push   $0x803fe4
  802148:	6a 7f                	push   $0x7f
  80214a:	68 6f 3f 80 00       	push   $0x803f6f
  80214f:	e8 62 e1 ff ff       	call   8002b6 <_panic>
  802154:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802157:	8b 10                	mov    (%eax),%edx
  802159:	8b 45 08             	mov    0x8(%ebp),%eax
  80215c:	89 10                	mov    %edx,(%eax)
  80215e:	8b 45 08             	mov    0x8(%ebp),%eax
  802161:	8b 00                	mov    (%eax),%eax
  802163:	85 c0                	test   %eax,%eax
  802165:	74 0b                	je     802172 <insert_sorted_allocList+0x222>
  802167:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216a:	8b 00                	mov    (%eax),%eax
  80216c:	8b 55 08             	mov    0x8(%ebp),%edx
  80216f:	89 50 04             	mov    %edx,0x4(%eax)
  802172:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802175:	8b 55 08             	mov    0x8(%ebp),%edx
  802178:	89 10                	mov    %edx,(%eax)
  80217a:	8b 45 08             	mov    0x8(%ebp),%eax
  80217d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802180:	89 50 04             	mov    %edx,0x4(%eax)
  802183:	8b 45 08             	mov    0x8(%ebp),%eax
  802186:	8b 00                	mov    (%eax),%eax
  802188:	85 c0                	test   %eax,%eax
  80218a:	75 08                	jne    802194 <insert_sorted_allocList+0x244>
  80218c:	8b 45 08             	mov    0x8(%ebp),%eax
  80218f:	a3 44 50 80 00       	mov    %eax,0x805044
  802194:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802199:	40                   	inc    %eax
  80219a:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  80219f:	eb 39                	jmp    8021da <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8021a1:	a1 48 50 80 00       	mov    0x805048,%eax
  8021a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021ad:	74 07                	je     8021b6 <insert_sorted_allocList+0x266>
  8021af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b2:	8b 00                	mov    (%eax),%eax
  8021b4:	eb 05                	jmp    8021bb <insert_sorted_allocList+0x26b>
  8021b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8021bb:	a3 48 50 80 00       	mov    %eax,0x805048
  8021c0:	a1 48 50 80 00       	mov    0x805048,%eax
  8021c5:	85 c0                	test   %eax,%eax
  8021c7:	0f 85 3f ff ff ff    	jne    80210c <insert_sorted_allocList+0x1bc>
  8021cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021d1:	0f 85 35 ff ff ff    	jne    80210c <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8021d7:	eb 01                	jmp    8021da <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8021d9:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8021da:	90                   	nop
  8021db:	c9                   	leave  
  8021dc:	c3                   	ret    

008021dd <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8021dd:	55                   	push   %ebp
  8021de:	89 e5                	mov    %esp,%ebp
  8021e0:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8021e3:	a1 38 51 80 00       	mov    0x805138,%eax
  8021e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021eb:	e9 85 01 00 00       	jmp    802375 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8021f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f3:	8b 40 0c             	mov    0xc(%eax),%eax
  8021f6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021f9:	0f 82 6e 01 00 00    	jb     80236d <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8021ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802202:	8b 40 0c             	mov    0xc(%eax),%eax
  802205:	3b 45 08             	cmp    0x8(%ebp),%eax
  802208:	0f 85 8a 00 00 00    	jne    802298 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  80220e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802212:	75 17                	jne    80222b <alloc_block_FF+0x4e>
  802214:	83 ec 04             	sub    $0x4,%esp
  802217:	68 18 40 80 00       	push   $0x804018
  80221c:	68 93 00 00 00       	push   $0x93
  802221:	68 6f 3f 80 00       	push   $0x803f6f
  802226:	e8 8b e0 ff ff       	call   8002b6 <_panic>
  80222b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80222e:	8b 00                	mov    (%eax),%eax
  802230:	85 c0                	test   %eax,%eax
  802232:	74 10                	je     802244 <alloc_block_FF+0x67>
  802234:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802237:	8b 00                	mov    (%eax),%eax
  802239:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80223c:	8b 52 04             	mov    0x4(%edx),%edx
  80223f:	89 50 04             	mov    %edx,0x4(%eax)
  802242:	eb 0b                	jmp    80224f <alloc_block_FF+0x72>
  802244:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802247:	8b 40 04             	mov    0x4(%eax),%eax
  80224a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80224f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802252:	8b 40 04             	mov    0x4(%eax),%eax
  802255:	85 c0                	test   %eax,%eax
  802257:	74 0f                	je     802268 <alloc_block_FF+0x8b>
  802259:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225c:	8b 40 04             	mov    0x4(%eax),%eax
  80225f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802262:	8b 12                	mov    (%edx),%edx
  802264:	89 10                	mov    %edx,(%eax)
  802266:	eb 0a                	jmp    802272 <alloc_block_FF+0x95>
  802268:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226b:	8b 00                	mov    (%eax),%eax
  80226d:	a3 38 51 80 00       	mov    %eax,0x805138
  802272:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802275:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80227b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802285:	a1 44 51 80 00       	mov    0x805144,%eax
  80228a:	48                   	dec    %eax
  80228b:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802290:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802293:	e9 10 01 00 00       	jmp    8023a8 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802298:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229b:	8b 40 0c             	mov    0xc(%eax),%eax
  80229e:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022a1:	0f 86 c6 00 00 00    	jbe    80236d <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8022a7:	a1 48 51 80 00       	mov    0x805148,%eax
  8022ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8022af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b2:	8b 50 08             	mov    0x8(%eax),%edx
  8022b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022b8:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8022bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022be:	8b 55 08             	mov    0x8(%ebp),%edx
  8022c1:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8022c4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022c8:	75 17                	jne    8022e1 <alloc_block_FF+0x104>
  8022ca:	83 ec 04             	sub    $0x4,%esp
  8022cd:	68 18 40 80 00       	push   $0x804018
  8022d2:	68 9b 00 00 00       	push   $0x9b
  8022d7:	68 6f 3f 80 00       	push   $0x803f6f
  8022dc:	e8 d5 df ff ff       	call   8002b6 <_panic>
  8022e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022e4:	8b 00                	mov    (%eax),%eax
  8022e6:	85 c0                	test   %eax,%eax
  8022e8:	74 10                	je     8022fa <alloc_block_FF+0x11d>
  8022ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022ed:	8b 00                	mov    (%eax),%eax
  8022ef:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022f2:	8b 52 04             	mov    0x4(%edx),%edx
  8022f5:	89 50 04             	mov    %edx,0x4(%eax)
  8022f8:	eb 0b                	jmp    802305 <alloc_block_FF+0x128>
  8022fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022fd:	8b 40 04             	mov    0x4(%eax),%eax
  802300:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802305:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802308:	8b 40 04             	mov    0x4(%eax),%eax
  80230b:	85 c0                	test   %eax,%eax
  80230d:	74 0f                	je     80231e <alloc_block_FF+0x141>
  80230f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802312:	8b 40 04             	mov    0x4(%eax),%eax
  802315:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802318:	8b 12                	mov    (%edx),%edx
  80231a:	89 10                	mov    %edx,(%eax)
  80231c:	eb 0a                	jmp    802328 <alloc_block_FF+0x14b>
  80231e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802321:	8b 00                	mov    (%eax),%eax
  802323:	a3 48 51 80 00       	mov    %eax,0x805148
  802328:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80232b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802331:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802334:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80233b:	a1 54 51 80 00       	mov    0x805154,%eax
  802340:	48                   	dec    %eax
  802341:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802346:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802349:	8b 50 08             	mov    0x8(%eax),%edx
  80234c:	8b 45 08             	mov    0x8(%ebp),%eax
  80234f:	01 c2                	add    %eax,%edx
  802351:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802354:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802357:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235a:	8b 40 0c             	mov    0xc(%eax),%eax
  80235d:	2b 45 08             	sub    0x8(%ebp),%eax
  802360:	89 c2                	mov    %eax,%edx
  802362:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802365:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802368:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80236b:	eb 3b                	jmp    8023a8 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80236d:	a1 40 51 80 00       	mov    0x805140,%eax
  802372:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802375:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802379:	74 07                	je     802382 <alloc_block_FF+0x1a5>
  80237b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237e:	8b 00                	mov    (%eax),%eax
  802380:	eb 05                	jmp    802387 <alloc_block_FF+0x1aa>
  802382:	b8 00 00 00 00       	mov    $0x0,%eax
  802387:	a3 40 51 80 00       	mov    %eax,0x805140
  80238c:	a1 40 51 80 00       	mov    0x805140,%eax
  802391:	85 c0                	test   %eax,%eax
  802393:	0f 85 57 fe ff ff    	jne    8021f0 <alloc_block_FF+0x13>
  802399:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80239d:	0f 85 4d fe ff ff    	jne    8021f0 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8023a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023a8:	c9                   	leave  
  8023a9:	c3                   	ret    

008023aa <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8023aa:	55                   	push   %ebp
  8023ab:	89 e5                	mov    %esp,%ebp
  8023ad:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8023b0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8023b7:	a1 38 51 80 00       	mov    0x805138,%eax
  8023bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023bf:	e9 df 00 00 00       	jmp    8024a3 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8023c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c7:	8b 40 0c             	mov    0xc(%eax),%eax
  8023ca:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023cd:	0f 82 c8 00 00 00    	jb     80249b <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8023d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d6:	8b 40 0c             	mov    0xc(%eax),%eax
  8023d9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023dc:	0f 85 8a 00 00 00    	jne    80246c <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8023e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023e6:	75 17                	jne    8023ff <alloc_block_BF+0x55>
  8023e8:	83 ec 04             	sub    $0x4,%esp
  8023eb:	68 18 40 80 00       	push   $0x804018
  8023f0:	68 b7 00 00 00       	push   $0xb7
  8023f5:	68 6f 3f 80 00       	push   $0x803f6f
  8023fa:	e8 b7 de ff ff       	call   8002b6 <_panic>
  8023ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802402:	8b 00                	mov    (%eax),%eax
  802404:	85 c0                	test   %eax,%eax
  802406:	74 10                	je     802418 <alloc_block_BF+0x6e>
  802408:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240b:	8b 00                	mov    (%eax),%eax
  80240d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802410:	8b 52 04             	mov    0x4(%edx),%edx
  802413:	89 50 04             	mov    %edx,0x4(%eax)
  802416:	eb 0b                	jmp    802423 <alloc_block_BF+0x79>
  802418:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241b:	8b 40 04             	mov    0x4(%eax),%eax
  80241e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802423:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802426:	8b 40 04             	mov    0x4(%eax),%eax
  802429:	85 c0                	test   %eax,%eax
  80242b:	74 0f                	je     80243c <alloc_block_BF+0x92>
  80242d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802430:	8b 40 04             	mov    0x4(%eax),%eax
  802433:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802436:	8b 12                	mov    (%edx),%edx
  802438:	89 10                	mov    %edx,(%eax)
  80243a:	eb 0a                	jmp    802446 <alloc_block_BF+0x9c>
  80243c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243f:	8b 00                	mov    (%eax),%eax
  802441:	a3 38 51 80 00       	mov    %eax,0x805138
  802446:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802449:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80244f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802452:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802459:	a1 44 51 80 00       	mov    0x805144,%eax
  80245e:	48                   	dec    %eax
  80245f:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802464:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802467:	e9 4d 01 00 00       	jmp    8025b9 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  80246c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246f:	8b 40 0c             	mov    0xc(%eax),%eax
  802472:	3b 45 08             	cmp    0x8(%ebp),%eax
  802475:	76 24                	jbe    80249b <alloc_block_BF+0xf1>
  802477:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247a:	8b 40 0c             	mov    0xc(%eax),%eax
  80247d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802480:	73 19                	jae    80249b <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802482:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802489:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248c:	8b 40 0c             	mov    0xc(%eax),%eax
  80248f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802492:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802495:	8b 40 08             	mov    0x8(%eax),%eax
  802498:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80249b:	a1 40 51 80 00       	mov    0x805140,%eax
  8024a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024a7:	74 07                	je     8024b0 <alloc_block_BF+0x106>
  8024a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ac:	8b 00                	mov    (%eax),%eax
  8024ae:	eb 05                	jmp    8024b5 <alloc_block_BF+0x10b>
  8024b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8024b5:	a3 40 51 80 00       	mov    %eax,0x805140
  8024ba:	a1 40 51 80 00       	mov    0x805140,%eax
  8024bf:	85 c0                	test   %eax,%eax
  8024c1:	0f 85 fd fe ff ff    	jne    8023c4 <alloc_block_BF+0x1a>
  8024c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024cb:	0f 85 f3 fe ff ff    	jne    8023c4 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8024d1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8024d5:	0f 84 d9 00 00 00    	je     8025b4 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8024db:	a1 48 51 80 00       	mov    0x805148,%eax
  8024e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8024e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024e6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024e9:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8024ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8024f2:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8024f5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8024f9:	75 17                	jne    802512 <alloc_block_BF+0x168>
  8024fb:	83 ec 04             	sub    $0x4,%esp
  8024fe:	68 18 40 80 00       	push   $0x804018
  802503:	68 c7 00 00 00       	push   $0xc7
  802508:	68 6f 3f 80 00       	push   $0x803f6f
  80250d:	e8 a4 dd ff ff       	call   8002b6 <_panic>
  802512:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802515:	8b 00                	mov    (%eax),%eax
  802517:	85 c0                	test   %eax,%eax
  802519:	74 10                	je     80252b <alloc_block_BF+0x181>
  80251b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80251e:	8b 00                	mov    (%eax),%eax
  802520:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802523:	8b 52 04             	mov    0x4(%edx),%edx
  802526:	89 50 04             	mov    %edx,0x4(%eax)
  802529:	eb 0b                	jmp    802536 <alloc_block_BF+0x18c>
  80252b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80252e:	8b 40 04             	mov    0x4(%eax),%eax
  802531:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802536:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802539:	8b 40 04             	mov    0x4(%eax),%eax
  80253c:	85 c0                	test   %eax,%eax
  80253e:	74 0f                	je     80254f <alloc_block_BF+0x1a5>
  802540:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802543:	8b 40 04             	mov    0x4(%eax),%eax
  802546:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802549:	8b 12                	mov    (%edx),%edx
  80254b:	89 10                	mov    %edx,(%eax)
  80254d:	eb 0a                	jmp    802559 <alloc_block_BF+0x1af>
  80254f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802552:	8b 00                	mov    (%eax),%eax
  802554:	a3 48 51 80 00       	mov    %eax,0x805148
  802559:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80255c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802562:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802565:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80256c:	a1 54 51 80 00       	mov    0x805154,%eax
  802571:	48                   	dec    %eax
  802572:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802577:	83 ec 08             	sub    $0x8,%esp
  80257a:	ff 75 ec             	pushl  -0x14(%ebp)
  80257d:	68 38 51 80 00       	push   $0x805138
  802582:	e8 71 f9 ff ff       	call   801ef8 <find_block>
  802587:	83 c4 10             	add    $0x10,%esp
  80258a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  80258d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802590:	8b 50 08             	mov    0x8(%eax),%edx
  802593:	8b 45 08             	mov    0x8(%ebp),%eax
  802596:	01 c2                	add    %eax,%edx
  802598:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80259b:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  80259e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025a1:	8b 40 0c             	mov    0xc(%eax),%eax
  8025a4:	2b 45 08             	sub    0x8(%ebp),%eax
  8025a7:	89 c2                	mov    %eax,%edx
  8025a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025ac:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8025af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025b2:	eb 05                	jmp    8025b9 <alloc_block_BF+0x20f>
	}
	return NULL;
  8025b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025b9:	c9                   	leave  
  8025ba:	c3                   	ret    

008025bb <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8025bb:	55                   	push   %ebp
  8025bc:	89 e5                	mov    %esp,%ebp
  8025be:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8025c1:	a1 28 50 80 00       	mov    0x805028,%eax
  8025c6:	85 c0                	test   %eax,%eax
  8025c8:	0f 85 de 01 00 00    	jne    8027ac <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8025ce:	a1 38 51 80 00       	mov    0x805138,%eax
  8025d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025d6:	e9 9e 01 00 00       	jmp    802779 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8025db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025de:	8b 40 0c             	mov    0xc(%eax),%eax
  8025e1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025e4:	0f 82 87 01 00 00    	jb     802771 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8025ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8025f0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025f3:	0f 85 95 00 00 00    	jne    80268e <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8025f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025fd:	75 17                	jne    802616 <alloc_block_NF+0x5b>
  8025ff:	83 ec 04             	sub    $0x4,%esp
  802602:	68 18 40 80 00       	push   $0x804018
  802607:	68 e0 00 00 00       	push   $0xe0
  80260c:	68 6f 3f 80 00       	push   $0x803f6f
  802611:	e8 a0 dc ff ff       	call   8002b6 <_panic>
  802616:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802619:	8b 00                	mov    (%eax),%eax
  80261b:	85 c0                	test   %eax,%eax
  80261d:	74 10                	je     80262f <alloc_block_NF+0x74>
  80261f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802622:	8b 00                	mov    (%eax),%eax
  802624:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802627:	8b 52 04             	mov    0x4(%edx),%edx
  80262a:	89 50 04             	mov    %edx,0x4(%eax)
  80262d:	eb 0b                	jmp    80263a <alloc_block_NF+0x7f>
  80262f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802632:	8b 40 04             	mov    0x4(%eax),%eax
  802635:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80263a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263d:	8b 40 04             	mov    0x4(%eax),%eax
  802640:	85 c0                	test   %eax,%eax
  802642:	74 0f                	je     802653 <alloc_block_NF+0x98>
  802644:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802647:	8b 40 04             	mov    0x4(%eax),%eax
  80264a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80264d:	8b 12                	mov    (%edx),%edx
  80264f:	89 10                	mov    %edx,(%eax)
  802651:	eb 0a                	jmp    80265d <alloc_block_NF+0xa2>
  802653:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802656:	8b 00                	mov    (%eax),%eax
  802658:	a3 38 51 80 00       	mov    %eax,0x805138
  80265d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802660:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802666:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802669:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802670:	a1 44 51 80 00       	mov    0x805144,%eax
  802675:	48                   	dec    %eax
  802676:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  80267b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267e:	8b 40 08             	mov    0x8(%eax),%eax
  802681:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802686:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802689:	e9 f8 04 00 00       	jmp    802b86 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  80268e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802691:	8b 40 0c             	mov    0xc(%eax),%eax
  802694:	3b 45 08             	cmp    0x8(%ebp),%eax
  802697:	0f 86 d4 00 00 00    	jbe    802771 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80269d:	a1 48 51 80 00       	mov    0x805148,%eax
  8026a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8026a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a8:	8b 50 08             	mov    0x8(%eax),%edx
  8026ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026ae:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8026b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8026b7:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8026ba:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026be:	75 17                	jne    8026d7 <alloc_block_NF+0x11c>
  8026c0:	83 ec 04             	sub    $0x4,%esp
  8026c3:	68 18 40 80 00       	push   $0x804018
  8026c8:	68 e9 00 00 00       	push   $0xe9
  8026cd:	68 6f 3f 80 00       	push   $0x803f6f
  8026d2:	e8 df db ff ff       	call   8002b6 <_panic>
  8026d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026da:	8b 00                	mov    (%eax),%eax
  8026dc:	85 c0                	test   %eax,%eax
  8026de:	74 10                	je     8026f0 <alloc_block_NF+0x135>
  8026e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026e3:	8b 00                	mov    (%eax),%eax
  8026e5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026e8:	8b 52 04             	mov    0x4(%edx),%edx
  8026eb:	89 50 04             	mov    %edx,0x4(%eax)
  8026ee:	eb 0b                	jmp    8026fb <alloc_block_NF+0x140>
  8026f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026f3:	8b 40 04             	mov    0x4(%eax),%eax
  8026f6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8026fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026fe:	8b 40 04             	mov    0x4(%eax),%eax
  802701:	85 c0                	test   %eax,%eax
  802703:	74 0f                	je     802714 <alloc_block_NF+0x159>
  802705:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802708:	8b 40 04             	mov    0x4(%eax),%eax
  80270b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80270e:	8b 12                	mov    (%edx),%edx
  802710:	89 10                	mov    %edx,(%eax)
  802712:	eb 0a                	jmp    80271e <alloc_block_NF+0x163>
  802714:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802717:	8b 00                	mov    (%eax),%eax
  802719:	a3 48 51 80 00       	mov    %eax,0x805148
  80271e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802721:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802727:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80272a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802731:	a1 54 51 80 00       	mov    0x805154,%eax
  802736:	48                   	dec    %eax
  802737:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  80273c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80273f:	8b 40 08             	mov    0x8(%eax),%eax
  802742:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802747:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274a:	8b 50 08             	mov    0x8(%eax),%edx
  80274d:	8b 45 08             	mov    0x8(%ebp),%eax
  802750:	01 c2                	add    %eax,%edx
  802752:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802755:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802758:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275b:	8b 40 0c             	mov    0xc(%eax),%eax
  80275e:	2b 45 08             	sub    0x8(%ebp),%eax
  802761:	89 c2                	mov    %eax,%edx
  802763:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802766:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802769:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80276c:	e9 15 04 00 00       	jmp    802b86 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802771:	a1 40 51 80 00       	mov    0x805140,%eax
  802776:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802779:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80277d:	74 07                	je     802786 <alloc_block_NF+0x1cb>
  80277f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802782:	8b 00                	mov    (%eax),%eax
  802784:	eb 05                	jmp    80278b <alloc_block_NF+0x1d0>
  802786:	b8 00 00 00 00       	mov    $0x0,%eax
  80278b:	a3 40 51 80 00       	mov    %eax,0x805140
  802790:	a1 40 51 80 00       	mov    0x805140,%eax
  802795:	85 c0                	test   %eax,%eax
  802797:	0f 85 3e fe ff ff    	jne    8025db <alloc_block_NF+0x20>
  80279d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027a1:	0f 85 34 fe ff ff    	jne    8025db <alloc_block_NF+0x20>
  8027a7:	e9 d5 03 00 00       	jmp    802b81 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8027ac:	a1 38 51 80 00       	mov    0x805138,%eax
  8027b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027b4:	e9 b1 01 00 00       	jmp    80296a <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8027b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027bc:	8b 50 08             	mov    0x8(%eax),%edx
  8027bf:	a1 28 50 80 00       	mov    0x805028,%eax
  8027c4:	39 c2                	cmp    %eax,%edx
  8027c6:	0f 82 96 01 00 00    	jb     802962 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  8027cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cf:	8b 40 0c             	mov    0xc(%eax),%eax
  8027d2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027d5:	0f 82 87 01 00 00    	jb     802962 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  8027db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027de:	8b 40 0c             	mov    0xc(%eax),%eax
  8027e1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027e4:	0f 85 95 00 00 00    	jne    80287f <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8027ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027ee:	75 17                	jne    802807 <alloc_block_NF+0x24c>
  8027f0:	83 ec 04             	sub    $0x4,%esp
  8027f3:	68 18 40 80 00       	push   $0x804018
  8027f8:	68 fc 00 00 00       	push   $0xfc
  8027fd:	68 6f 3f 80 00       	push   $0x803f6f
  802802:	e8 af da ff ff       	call   8002b6 <_panic>
  802807:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280a:	8b 00                	mov    (%eax),%eax
  80280c:	85 c0                	test   %eax,%eax
  80280e:	74 10                	je     802820 <alloc_block_NF+0x265>
  802810:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802813:	8b 00                	mov    (%eax),%eax
  802815:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802818:	8b 52 04             	mov    0x4(%edx),%edx
  80281b:	89 50 04             	mov    %edx,0x4(%eax)
  80281e:	eb 0b                	jmp    80282b <alloc_block_NF+0x270>
  802820:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802823:	8b 40 04             	mov    0x4(%eax),%eax
  802826:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80282b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282e:	8b 40 04             	mov    0x4(%eax),%eax
  802831:	85 c0                	test   %eax,%eax
  802833:	74 0f                	je     802844 <alloc_block_NF+0x289>
  802835:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802838:	8b 40 04             	mov    0x4(%eax),%eax
  80283b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80283e:	8b 12                	mov    (%edx),%edx
  802840:	89 10                	mov    %edx,(%eax)
  802842:	eb 0a                	jmp    80284e <alloc_block_NF+0x293>
  802844:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802847:	8b 00                	mov    (%eax),%eax
  802849:	a3 38 51 80 00       	mov    %eax,0x805138
  80284e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802851:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802857:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802861:	a1 44 51 80 00       	mov    0x805144,%eax
  802866:	48                   	dec    %eax
  802867:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  80286c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286f:	8b 40 08             	mov    0x8(%eax),%eax
  802872:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802877:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287a:	e9 07 03 00 00       	jmp    802b86 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  80287f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802882:	8b 40 0c             	mov    0xc(%eax),%eax
  802885:	3b 45 08             	cmp    0x8(%ebp),%eax
  802888:	0f 86 d4 00 00 00    	jbe    802962 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80288e:	a1 48 51 80 00       	mov    0x805148,%eax
  802893:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802896:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802899:	8b 50 08             	mov    0x8(%eax),%edx
  80289c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80289f:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8028a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8028a8:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8028ab:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8028af:	75 17                	jne    8028c8 <alloc_block_NF+0x30d>
  8028b1:	83 ec 04             	sub    $0x4,%esp
  8028b4:	68 18 40 80 00       	push   $0x804018
  8028b9:	68 04 01 00 00       	push   $0x104
  8028be:	68 6f 3f 80 00       	push   $0x803f6f
  8028c3:	e8 ee d9 ff ff       	call   8002b6 <_panic>
  8028c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028cb:	8b 00                	mov    (%eax),%eax
  8028cd:	85 c0                	test   %eax,%eax
  8028cf:	74 10                	je     8028e1 <alloc_block_NF+0x326>
  8028d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028d4:	8b 00                	mov    (%eax),%eax
  8028d6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8028d9:	8b 52 04             	mov    0x4(%edx),%edx
  8028dc:	89 50 04             	mov    %edx,0x4(%eax)
  8028df:	eb 0b                	jmp    8028ec <alloc_block_NF+0x331>
  8028e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028e4:	8b 40 04             	mov    0x4(%eax),%eax
  8028e7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8028ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028ef:	8b 40 04             	mov    0x4(%eax),%eax
  8028f2:	85 c0                	test   %eax,%eax
  8028f4:	74 0f                	je     802905 <alloc_block_NF+0x34a>
  8028f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028f9:	8b 40 04             	mov    0x4(%eax),%eax
  8028fc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8028ff:	8b 12                	mov    (%edx),%edx
  802901:	89 10                	mov    %edx,(%eax)
  802903:	eb 0a                	jmp    80290f <alloc_block_NF+0x354>
  802905:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802908:	8b 00                	mov    (%eax),%eax
  80290a:	a3 48 51 80 00       	mov    %eax,0x805148
  80290f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802912:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802918:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80291b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802922:	a1 54 51 80 00       	mov    0x805154,%eax
  802927:	48                   	dec    %eax
  802928:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  80292d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802930:	8b 40 08             	mov    0x8(%eax),%eax
  802933:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802938:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293b:	8b 50 08             	mov    0x8(%eax),%edx
  80293e:	8b 45 08             	mov    0x8(%ebp),%eax
  802941:	01 c2                	add    %eax,%edx
  802943:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802946:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802949:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294c:	8b 40 0c             	mov    0xc(%eax),%eax
  80294f:	2b 45 08             	sub    0x8(%ebp),%eax
  802952:	89 c2                	mov    %eax,%edx
  802954:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802957:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  80295a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80295d:	e9 24 02 00 00       	jmp    802b86 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802962:	a1 40 51 80 00       	mov    0x805140,%eax
  802967:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80296a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80296e:	74 07                	je     802977 <alloc_block_NF+0x3bc>
  802970:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802973:	8b 00                	mov    (%eax),%eax
  802975:	eb 05                	jmp    80297c <alloc_block_NF+0x3c1>
  802977:	b8 00 00 00 00       	mov    $0x0,%eax
  80297c:	a3 40 51 80 00       	mov    %eax,0x805140
  802981:	a1 40 51 80 00       	mov    0x805140,%eax
  802986:	85 c0                	test   %eax,%eax
  802988:	0f 85 2b fe ff ff    	jne    8027b9 <alloc_block_NF+0x1fe>
  80298e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802992:	0f 85 21 fe ff ff    	jne    8027b9 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802998:	a1 38 51 80 00       	mov    0x805138,%eax
  80299d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029a0:	e9 ae 01 00 00       	jmp    802b53 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  8029a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a8:	8b 50 08             	mov    0x8(%eax),%edx
  8029ab:	a1 28 50 80 00       	mov    0x805028,%eax
  8029b0:	39 c2                	cmp    %eax,%edx
  8029b2:	0f 83 93 01 00 00    	jae    802b4b <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  8029b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bb:	8b 40 0c             	mov    0xc(%eax),%eax
  8029be:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029c1:	0f 82 84 01 00 00    	jb     802b4b <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  8029c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8029cd:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029d0:	0f 85 95 00 00 00    	jne    802a6b <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8029d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029da:	75 17                	jne    8029f3 <alloc_block_NF+0x438>
  8029dc:	83 ec 04             	sub    $0x4,%esp
  8029df:	68 18 40 80 00       	push   $0x804018
  8029e4:	68 14 01 00 00       	push   $0x114
  8029e9:	68 6f 3f 80 00       	push   $0x803f6f
  8029ee:	e8 c3 d8 ff ff       	call   8002b6 <_panic>
  8029f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f6:	8b 00                	mov    (%eax),%eax
  8029f8:	85 c0                	test   %eax,%eax
  8029fa:	74 10                	je     802a0c <alloc_block_NF+0x451>
  8029fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ff:	8b 00                	mov    (%eax),%eax
  802a01:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a04:	8b 52 04             	mov    0x4(%edx),%edx
  802a07:	89 50 04             	mov    %edx,0x4(%eax)
  802a0a:	eb 0b                	jmp    802a17 <alloc_block_NF+0x45c>
  802a0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0f:	8b 40 04             	mov    0x4(%eax),%eax
  802a12:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1a:	8b 40 04             	mov    0x4(%eax),%eax
  802a1d:	85 c0                	test   %eax,%eax
  802a1f:	74 0f                	je     802a30 <alloc_block_NF+0x475>
  802a21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a24:	8b 40 04             	mov    0x4(%eax),%eax
  802a27:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a2a:	8b 12                	mov    (%edx),%edx
  802a2c:	89 10                	mov    %edx,(%eax)
  802a2e:	eb 0a                	jmp    802a3a <alloc_block_NF+0x47f>
  802a30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a33:	8b 00                	mov    (%eax),%eax
  802a35:	a3 38 51 80 00       	mov    %eax,0x805138
  802a3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a46:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a4d:	a1 44 51 80 00       	mov    0x805144,%eax
  802a52:	48                   	dec    %eax
  802a53:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802a58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5b:	8b 40 08             	mov    0x8(%eax),%eax
  802a5e:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802a63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a66:	e9 1b 01 00 00       	jmp    802b86 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802a6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6e:	8b 40 0c             	mov    0xc(%eax),%eax
  802a71:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a74:	0f 86 d1 00 00 00    	jbe    802b4b <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802a7a:	a1 48 51 80 00       	mov    0x805148,%eax
  802a7f:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802a82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a85:	8b 50 08             	mov    0x8(%eax),%edx
  802a88:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a8b:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802a8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a91:	8b 55 08             	mov    0x8(%ebp),%edx
  802a94:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802a97:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a9b:	75 17                	jne    802ab4 <alloc_block_NF+0x4f9>
  802a9d:	83 ec 04             	sub    $0x4,%esp
  802aa0:	68 18 40 80 00       	push   $0x804018
  802aa5:	68 1c 01 00 00       	push   $0x11c
  802aaa:	68 6f 3f 80 00       	push   $0x803f6f
  802aaf:	e8 02 d8 ff ff       	call   8002b6 <_panic>
  802ab4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ab7:	8b 00                	mov    (%eax),%eax
  802ab9:	85 c0                	test   %eax,%eax
  802abb:	74 10                	je     802acd <alloc_block_NF+0x512>
  802abd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ac0:	8b 00                	mov    (%eax),%eax
  802ac2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ac5:	8b 52 04             	mov    0x4(%edx),%edx
  802ac8:	89 50 04             	mov    %edx,0x4(%eax)
  802acb:	eb 0b                	jmp    802ad8 <alloc_block_NF+0x51d>
  802acd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ad0:	8b 40 04             	mov    0x4(%eax),%eax
  802ad3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ad8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802adb:	8b 40 04             	mov    0x4(%eax),%eax
  802ade:	85 c0                	test   %eax,%eax
  802ae0:	74 0f                	je     802af1 <alloc_block_NF+0x536>
  802ae2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ae5:	8b 40 04             	mov    0x4(%eax),%eax
  802ae8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802aeb:	8b 12                	mov    (%edx),%edx
  802aed:	89 10                	mov    %edx,(%eax)
  802aef:	eb 0a                	jmp    802afb <alloc_block_NF+0x540>
  802af1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802af4:	8b 00                	mov    (%eax),%eax
  802af6:	a3 48 51 80 00       	mov    %eax,0x805148
  802afb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802afe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b04:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b07:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b0e:	a1 54 51 80 00       	mov    0x805154,%eax
  802b13:	48                   	dec    %eax
  802b14:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802b19:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b1c:	8b 40 08             	mov    0x8(%eax),%eax
  802b1f:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802b24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b27:	8b 50 08             	mov    0x8(%eax),%edx
  802b2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2d:	01 c2                	add    %eax,%edx
  802b2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b32:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802b35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b38:	8b 40 0c             	mov    0xc(%eax),%eax
  802b3b:	2b 45 08             	sub    0x8(%ebp),%eax
  802b3e:	89 c2                	mov    %eax,%edx
  802b40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b43:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802b46:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b49:	eb 3b                	jmp    802b86 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b4b:	a1 40 51 80 00       	mov    0x805140,%eax
  802b50:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b53:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b57:	74 07                	je     802b60 <alloc_block_NF+0x5a5>
  802b59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5c:	8b 00                	mov    (%eax),%eax
  802b5e:	eb 05                	jmp    802b65 <alloc_block_NF+0x5aa>
  802b60:	b8 00 00 00 00       	mov    $0x0,%eax
  802b65:	a3 40 51 80 00       	mov    %eax,0x805140
  802b6a:	a1 40 51 80 00       	mov    0x805140,%eax
  802b6f:	85 c0                	test   %eax,%eax
  802b71:	0f 85 2e fe ff ff    	jne    8029a5 <alloc_block_NF+0x3ea>
  802b77:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b7b:	0f 85 24 fe ff ff    	jne    8029a5 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802b81:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b86:	c9                   	leave  
  802b87:	c3                   	ret    

00802b88 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802b88:	55                   	push   %ebp
  802b89:	89 e5                	mov    %esp,%ebp
  802b8b:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802b8e:	a1 38 51 80 00       	mov    0x805138,%eax
  802b93:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802b96:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802b9b:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802b9e:	a1 38 51 80 00       	mov    0x805138,%eax
  802ba3:	85 c0                	test   %eax,%eax
  802ba5:	74 14                	je     802bbb <insert_sorted_with_merge_freeList+0x33>
  802ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  802baa:	8b 50 08             	mov    0x8(%eax),%edx
  802bad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb0:	8b 40 08             	mov    0x8(%eax),%eax
  802bb3:	39 c2                	cmp    %eax,%edx
  802bb5:	0f 87 9b 01 00 00    	ja     802d56 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802bbb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bbf:	75 17                	jne    802bd8 <insert_sorted_with_merge_freeList+0x50>
  802bc1:	83 ec 04             	sub    $0x4,%esp
  802bc4:	68 4c 3f 80 00       	push   $0x803f4c
  802bc9:	68 38 01 00 00       	push   $0x138
  802bce:	68 6f 3f 80 00       	push   $0x803f6f
  802bd3:	e8 de d6 ff ff       	call   8002b6 <_panic>
  802bd8:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802bde:	8b 45 08             	mov    0x8(%ebp),%eax
  802be1:	89 10                	mov    %edx,(%eax)
  802be3:	8b 45 08             	mov    0x8(%ebp),%eax
  802be6:	8b 00                	mov    (%eax),%eax
  802be8:	85 c0                	test   %eax,%eax
  802bea:	74 0d                	je     802bf9 <insert_sorted_with_merge_freeList+0x71>
  802bec:	a1 38 51 80 00       	mov    0x805138,%eax
  802bf1:	8b 55 08             	mov    0x8(%ebp),%edx
  802bf4:	89 50 04             	mov    %edx,0x4(%eax)
  802bf7:	eb 08                	jmp    802c01 <insert_sorted_with_merge_freeList+0x79>
  802bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bfc:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c01:	8b 45 08             	mov    0x8(%ebp),%eax
  802c04:	a3 38 51 80 00       	mov    %eax,0x805138
  802c09:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c13:	a1 44 51 80 00       	mov    0x805144,%eax
  802c18:	40                   	inc    %eax
  802c19:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802c1e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c22:	0f 84 a8 06 00 00    	je     8032d0 <insert_sorted_with_merge_freeList+0x748>
  802c28:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2b:	8b 50 08             	mov    0x8(%eax),%edx
  802c2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c31:	8b 40 0c             	mov    0xc(%eax),%eax
  802c34:	01 c2                	add    %eax,%edx
  802c36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c39:	8b 40 08             	mov    0x8(%eax),%eax
  802c3c:	39 c2                	cmp    %eax,%edx
  802c3e:	0f 85 8c 06 00 00    	jne    8032d0 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802c44:	8b 45 08             	mov    0x8(%ebp),%eax
  802c47:	8b 50 0c             	mov    0xc(%eax),%edx
  802c4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c4d:	8b 40 0c             	mov    0xc(%eax),%eax
  802c50:	01 c2                	add    %eax,%edx
  802c52:	8b 45 08             	mov    0x8(%ebp),%eax
  802c55:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802c58:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c5c:	75 17                	jne    802c75 <insert_sorted_with_merge_freeList+0xed>
  802c5e:	83 ec 04             	sub    $0x4,%esp
  802c61:	68 18 40 80 00       	push   $0x804018
  802c66:	68 3c 01 00 00       	push   $0x13c
  802c6b:	68 6f 3f 80 00       	push   $0x803f6f
  802c70:	e8 41 d6 ff ff       	call   8002b6 <_panic>
  802c75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c78:	8b 00                	mov    (%eax),%eax
  802c7a:	85 c0                	test   %eax,%eax
  802c7c:	74 10                	je     802c8e <insert_sorted_with_merge_freeList+0x106>
  802c7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c81:	8b 00                	mov    (%eax),%eax
  802c83:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c86:	8b 52 04             	mov    0x4(%edx),%edx
  802c89:	89 50 04             	mov    %edx,0x4(%eax)
  802c8c:	eb 0b                	jmp    802c99 <insert_sorted_with_merge_freeList+0x111>
  802c8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c91:	8b 40 04             	mov    0x4(%eax),%eax
  802c94:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c9c:	8b 40 04             	mov    0x4(%eax),%eax
  802c9f:	85 c0                	test   %eax,%eax
  802ca1:	74 0f                	je     802cb2 <insert_sorted_with_merge_freeList+0x12a>
  802ca3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ca6:	8b 40 04             	mov    0x4(%eax),%eax
  802ca9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cac:	8b 12                	mov    (%edx),%edx
  802cae:	89 10                	mov    %edx,(%eax)
  802cb0:	eb 0a                	jmp    802cbc <insert_sorted_with_merge_freeList+0x134>
  802cb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb5:	8b 00                	mov    (%eax),%eax
  802cb7:	a3 38 51 80 00       	mov    %eax,0x805138
  802cbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cbf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cc8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ccf:	a1 44 51 80 00       	mov    0x805144,%eax
  802cd4:	48                   	dec    %eax
  802cd5:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802cda:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cdd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802ce4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ce7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802cee:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cf2:	75 17                	jne    802d0b <insert_sorted_with_merge_freeList+0x183>
  802cf4:	83 ec 04             	sub    $0x4,%esp
  802cf7:	68 4c 3f 80 00       	push   $0x803f4c
  802cfc:	68 3f 01 00 00       	push   $0x13f
  802d01:	68 6f 3f 80 00       	push   $0x803f6f
  802d06:	e8 ab d5 ff ff       	call   8002b6 <_panic>
  802d0b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802d11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d14:	89 10                	mov    %edx,(%eax)
  802d16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d19:	8b 00                	mov    (%eax),%eax
  802d1b:	85 c0                	test   %eax,%eax
  802d1d:	74 0d                	je     802d2c <insert_sorted_with_merge_freeList+0x1a4>
  802d1f:	a1 48 51 80 00       	mov    0x805148,%eax
  802d24:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d27:	89 50 04             	mov    %edx,0x4(%eax)
  802d2a:	eb 08                	jmp    802d34 <insert_sorted_with_merge_freeList+0x1ac>
  802d2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d2f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d37:	a3 48 51 80 00       	mov    %eax,0x805148
  802d3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d3f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d46:	a1 54 51 80 00       	mov    0x805154,%eax
  802d4b:	40                   	inc    %eax
  802d4c:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802d51:	e9 7a 05 00 00       	jmp    8032d0 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802d56:	8b 45 08             	mov    0x8(%ebp),%eax
  802d59:	8b 50 08             	mov    0x8(%eax),%edx
  802d5c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d5f:	8b 40 08             	mov    0x8(%eax),%eax
  802d62:	39 c2                	cmp    %eax,%edx
  802d64:	0f 82 14 01 00 00    	jb     802e7e <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802d6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d6d:	8b 50 08             	mov    0x8(%eax),%edx
  802d70:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d73:	8b 40 0c             	mov    0xc(%eax),%eax
  802d76:	01 c2                	add    %eax,%edx
  802d78:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7b:	8b 40 08             	mov    0x8(%eax),%eax
  802d7e:	39 c2                	cmp    %eax,%edx
  802d80:	0f 85 90 00 00 00    	jne    802e16 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802d86:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d89:	8b 50 0c             	mov    0xc(%eax),%edx
  802d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8f:	8b 40 0c             	mov    0xc(%eax),%eax
  802d92:	01 c2                	add    %eax,%edx
  802d94:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d97:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802da4:	8b 45 08             	mov    0x8(%ebp),%eax
  802da7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802dae:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802db2:	75 17                	jne    802dcb <insert_sorted_with_merge_freeList+0x243>
  802db4:	83 ec 04             	sub    $0x4,%esp
  802db7:	68 4c 3f 80 00       	push   $0x803f4c
  802dbc:	68 49 01 00 00       	push   $0x149
  802dc1:	68 6f 3f 80 00       	push   $0x803f6f
  802dc6:	e8 eb d4 ff ff       	call   8002b6 <_panic>
  802dcb:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd4:	89 10                	mov    %edx,(%eax)
  802dd6:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd9:	8b 00                	mov    (%eax),%eax
  802ddb:	85 c0                	test   %eax,%eax
  802ddd:	74 0d                	je     802dec <insert_sorted_with_merge_freeList+0x264>
  802ddf:	a1 48 51 80 00       	mov    0x805148,%eax
  802de4:	8b 55 08             	mov    0x8(%ebp),%edx
  802de7:	89 50 04             	mov    %edx,0x4(%eax)
  802dea:	eb 08                	jmp    802df4 <insert_sorted_with_merge_freeList+0x26c>
  802dec:	8b 45 08             	mov    0x8(%ebp),%eax
  802def:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802df4:	8b 45 08             	mov    0x8(%ebp),%eax
  802df7:	a3 48 51 80 00       	mov    %eax,0x805148
  802dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  802dff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e06:	a1 54 51 80 00       	mov    0x805154,%eax
  802e0b:	40                   	inc    %eax
  802e0c:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802e11:	e9 bb 04 00 00       	jmp    8032d1 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802e16:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e1a:	75 17                	jne    802e33 <insert_sorted_with_merge_freeList+0x2ab>
  802e1c:	83 ec 04             	sub    $0x4,%esp
  802e1f:	68 c0 3f 80 00       	push   $0x803fc0
  802e24:	68 4c 01 00 00       	push   $0x14c
  802e29:	68 6f 3f 80 00       	push   $0x803f6f
  802e2e:	e8 83 d4 ff ff       	call   8002b6 <_panic>
  802e33:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802e39:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3c:	89 50 04             	mov    %edx,0x4(%eax)
  802e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e42:	8b 40 04             	mov    0x4(%eax),%eax
  802e45:	85 c0                	test   %eax,%eax
  802e47:	74 0c                	je     802e55 <insert_sorted_with_merge_freeList+0x2cd>
  802e49:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802e4e:	8b 55 08             	mov    0x8(%ebp),%edx
  802e51:	89 10                	mov    %edx,(%eax)
  802e53:	eb 08                	jmp    802e5d <insert_sorted_with_merge_freeList+0x2d5>
  802e55:	8b 45 08             	mov    0x8(%ebp),%eax
  802e58:	a3 38 51 80 00       	mov    %eax,0x805138
  802e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e60:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e65:	8b 45 08             	mov    0x8(%ebp),%eax
  802e68:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e6e:	a1 44 51 80 00       	mov    0x805144,%eax
  802e73:	40                   	inc    %eax
  802e74:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802e79:	e9 53 04 00 00       	jmp    8032d1 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802e7e:	a1 38 51 80 00       	mov    0x805138,%eax
  802e83:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e86:	e9 15 04 00 00       	jmp    8032a0 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802e8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8e:	8b 00                	mov    (%eax),%eax
  802e90:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802e93:	8b 45 08             	mov    0x8(%ebp),%eax
  802e96:	8b 50 08             	mov    0x8(%eax),%edx
  802e99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9c:	8b 40 08             	mov    0x8(%eax),%eax
  802e9f:	39 c2                	cmp    %eax,%edx
  802ea1:	0f 86 f1 03 00 00    	jbe    803298 <insert_sorted_with_merge_freeList+0x710>
  802ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eaa:	8b 50 08             	mov    0x8(%eax),%edx
  802ead:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eb0:	8b 40 08             	mov    0x8(%eax),%eax
  802eb3:	39 c2                	cmp    %eax,%edx
  802eb5:	0f 83 dd 03 00 00    	jae    803298 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802ebb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebe:	8b 50 08             	mov    0x8(%eax),%edx
  802ec1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec4:	8b 40 0c             	mov    0xc(%eax),%eax
  802ec7:	01 c2                	add    %eax,%edx
  802ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ecc:	8b 40 08             	mov    0x8(%eax),%eax
  802ecf:	39 c2                	cmp    %eax,%edx
  802ed1:	0f 85 b9 01 00 00    	jne    803090 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802ed7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eda:	8b 50 08             	mov    0x8(%eax),%edx
  802edd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee0:	8b 40 0c             	mov    0xc(%eax),%eax
  802ee3:	01 c2                	add    %eax,%edx
  802ee5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ee8:	8b 40 08             	mov    0x8(%eax),%eax
  802eeb:	39 c2                	cmp    %eax,%edx
  802eed:	0f 85 0d 01 00 00    	jne    803000 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802ef3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef6:	8b 50 0c             	mov    0xc(%eax),%edx
  802ef9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802efc:	8b 40 0c             	mov    0xc(%eax),%eax
  802eff:	01 c2                	add    %eax,%edx
  802f01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f04:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802f07:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f0b:	75 17                	jne    802f24 <insert_sorted_with_merge_freeList+0x39c>
  802f0d:	83 ec 04             	sub    $0x4,%esp
  802f10:	68 18 40 80 00       	push   $0x804018
  802f15:	68 5c 01 00 00       	push   $0x15c
  802f1a:	68 6f 3f 80 00       	push   $0x803f6f
  802f1f:	e8 92 d3 ff ff       	call   8002b6 <_panic>
  802f24:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f27:	8b 00                	mov    (%eax),%eax
  802f29:	85 c0                	test   %eax,%eax
  802f2b:	74 10                	je     802f3d <insert_sorted_with_merge_freeList+0x3b5>
  802f2d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f30:	8b 00                	mov    (%eax),%eax
  802f32:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f35:	8b 52 04             	mov    0x4(%edx),%edx
  802f38:	89 50 04             	mov    %edx,0x4(%eax)
  802f3b:	eb 0b                	jmp    802f48 <insert_sorted_with_merge_freeList+0x3c0>
  802f3d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f40:	8b 40 04             	mov    0x4(%eax),%eax
  802f43:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f48:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f4b:	8b 40 04             	mov    0x4(%eax),%eax
  802f4e:	85 c0                	test   %eax,%eax
  802f50:	74 0f                	je     802f61 <insert_sorted_with_merge_freeList+0x3d9>
  802f52:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f55:	8b 40 04             	mov    0x4(%eax),%eax
  802f58:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f5b:	8b 12                	mov    (%edx),%edx
  802f5d:	89 10                	mov    %edx,(%eax)
  802f5f:	eb 0a                	jmp    802f6b <insert_sorted_with_merge_freeList+0x3e3>
  802f61:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f64:	8b 00                	mov    (%eax),%eax
  802f66:	a3 38 51 80 00       	mov    %eax,0x805138
  802f6b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f6e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f74:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f77:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f7e:	a1 44 51 80 00       	mov    0x805144,%eax
  802f83:	48                   	dec    %eax
  802f84:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  802f89:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f8c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  802f93:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f96:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  802f9d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802fa1:	75 17                	jne    802fba <insert_sorted_with_merge_freeList+0x432>
  802fa3:	83 ec 04             	sub    $0x4,%esp
  802fa6:	68 4c 3f 80 00       	push   $0x803f4c
  802fab:	68 5f 01 00 00       	push   $0x15f
  802fb0:	68 6f 3f 80 00       	push   $0x803f6f
  802fb5:	e8 fc d2 ff ff       	call   8002b6 <_panic>
  802fba:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802fc0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fc3:	89 10                	mov    %edx,(%eax)
  802fc5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fc8:	8b 00                	mov    (%eax),%eax
  802fca:	85 c0                	test   %eax,%eax
  802fcc:	74 0d                	je     802fdb <insert_sorted_with_merge_freeList+0x453>
  802fce:	a1 48 51 80 00       	mov    0x805148,%eax
  802fd3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fd6:	89 50 04             	mov    %edx,0x4(%eax)
  802fd9:	eb 08                	jmp    802fe3 <insert_sorted_with_merge_freeList+0x45b>
  802fdb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fde:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fe3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fe6:	a3 48 51 80 00       	mov    %eax,0x805148
  802feb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ff5:	a1 54 51 80 00       	mov    0x805154,%eax
  802ffa:	40                   	inc    %eax
  802ffb:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803000:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803003:	8b 50 0c             	mov    0xc(%eax),%edx
  803006:	8b 45 08             	mov    0x8(%ebp),%eax
  803009:	8b 40 0c             	mov    0xc(%eax),%eax
  80300c:	01 c2                	add    %eax,%edx
  80300e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803011:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803014:	8b 45 08             	mov    0x8(%ebp),%eax
  803017:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  80301e:	8b 45 08             	mov    0x8(%ebp),%eax
  803021:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803028:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80302c:	75 17                	jne    803045 <insert_sorted_with_merge_freeList+0x4bd>
  80302e:	83 ec 04             	sub    $0x4,%esp
  803031:	68 4c 3f 80 00       	push   $0x803f4c
  803036:	68 64 01 00 00       	push   $0x164
  80303b:	68 6f 3f 80 00       	push   $0x803f6f
  803040:	e8 71 d2 ff ff       	call   8002b6 <_panic>
  803045:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80304b:	8b 45 08             	mov    0x8(%ebp),%eax
  80304e:	89 10                	mov    %edx,(%eax)
  803050:	8b 45 08             	mov    0x8(%ebp),%eax
  803053:	8b 00                	mov    (%eax),%eax
  803055:	85 c0                	test   %eax,%eax
  803057:	74 0d                	je     803066 <insert_sorted_with_merge_freeList+0x4de>
  803059:	a1 48 51 80 00       	mov    0x805148,%eax
  80305e:	8b 55 08             	mov    0x8(%ebp),%edx
  803061:	89 50 04             	mov    %edx,0x4(%eax)
  803064:	eb 08                	jmp    80306e <insert_sorted_with_merge_freeList+0x4e6>
  803066:	8b 45 08             	mov    0x8(%ebp),%eax
  803069:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80306e:	8b 45 08             	mov    0x8(%ebp),%eax
  803071:	a3 48 51 80 00       	mov    %eax,0x805148
  803076:	8b 45 08             	mov    0x8(%ebp),%eax
  803079:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803080:	a1 54 51 80 00       	mov    0x805154,%eax
  803085:	40                   	inc    %eax
  803086:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80308b:	e9 41 02 00 00       	jmp    8032d1 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803090:	8b 45 08             	mov    0x8(%ebp),%eax
  803093:	8b 50 08             	mov    0x8(%eax),%edx
  803096:	8b 45 08             	mov    0x8(%ebp),%eax
  803099:	8b 40 0c             	mov    0xc(%eax),%eax
  80309c:	01 c2                	add    %eax,%edx
  80309e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030a1:	8b 40 08             	mov    0x8(%eax),%eax
  8030a4:	39 c2                	cmp    %eax,%edx
  8030a6:	0f 85 7c 01 00 00    	jne    803228 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8030ac:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030b0:	74 06                	je     8030b8 <insert_sorted_with_merge_freeList+0x530>
  8030b2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030b6:	75 17                	jne    8030cf <insert_sorted_with_merge_freeList+0x547>
  8030b8:	83 ec 04             	sub    $0x4,%esp
  8030bb:	68 88 3f 80 00       	push   $0x803f88
  8030c0:	68 69 01 00 00       	push   $0x169
  8030c5:	68 6f 3f 80 00       	push   $0x803f6f
  8030ca:	e8 e7 d1 ff ff       	call   8002b6 <_panic>
  8030cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030d2:	8b 50 04             	mov    0x4(%eax),%edx
  8030d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d8:	89 50 04             	mov    %edx,0x4(%eax)
  8030db:	8b 45 08             	mov    0x8(%ebp),%eax
  8030de:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030e1:	89 10                	mov    %edx,(%eax)
  8030e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030e6:	8b 40 04             	mov    0x4(%eax),%eax
  8030e9:	85 c0                	test   %eax,%eax
  8030eb:	74 0d                	je     8030fa <insert_sorted_with_merge_freeList+0x572>
  8030ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030f0:	8b 40 04             	mov    0x4(%eax),%eax
  8030f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8030f6:	89 10                	mov    %edx,(%eax)
  8030f8:	eb 08                	jmp    803102 <insert_sorted_with_merge_freeList+0x57a>
  8030fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fd:	a3 38 51 80 00       	mov    %eax,0x805138
  803102:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803105:	8b 55 08             	mov    0x8(%ebp),%edx
  803108:	89 50 04             	mov    %edx,0x4(%eax)
  80310b:	a1 44 51 80 00       	mov    0x805144,%eax
  803110:	40                   	inc    %eax
  803111:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803116:	8b 45 08             	mov    0x8(%ebp),%eax
  803119:	8b 50 0c             	mov    0xc(%eax),%edx
  80311c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80311f:	8b 40 0c             	mov    0xc(%eax),%eax
  803122:	01 c2                	add    %eax,%edx
  803124:	8b 45 08             	mov    0x8(%ebp),%eax
  803127:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80312a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80312e:	75 17                	jne    803147 <insert_sorted_with_merge_freeList+0x5bf>
  803130:	83 ec 04             	sub    $0x4,%esp
  803133:	68 18 40 80 00       	push   $0x804018
  803138:	68 6b 01 00 00       	push   $0x16b
  80313d:	68 6f 3f 80 00       	push   $0x803f6f
  803142:	e8 6f d1 ff ff       	call   8002b6 <_panic>
  803147:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80314a:	8b 00                	mov    (%eax),%eax
  80314c:	85 c0                	test   %eax,%eax
  80314e:	74 10                	je     803160 <insert_sorted_with_merge_freeList+0x5d8>
  803150:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803153:	8b 00                	mov    (%eax),%eax
  803155:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803158:	8b 52 04             	mov    0x4(%edx),%edx
  80315b:	89 50 04             	mov    %edx,0x4(%eax)
  80315e:	eb 0b                	jmp    80316b <insert_sorted_with_merge_freeList+0x5e3>
  803160:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803163:	8b 40 04             	mov    0x4(%eax),%eax
  803166:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80316b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80316e:	8b 40 04             	mov    0x4(%eax),%eax
  803171:	85 c0                	test   %eax,%eax
  803173:	74 0f                	je     803184 <insert_sorted_with_merge_freeList+0x5fc>
  803175:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803178:	8b 40 04             	mov    0x4(%eax),%eax
  80317b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80317e:	8b 12                	mov    (%edx),%edx
  803180:	89 10                	mov    %edx,(%eax)
  803182:	eb 0a                	jmp    80318e <insert_sorted_with_merge_freeList+0x606>
  803184:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803187:	8b 00                	mov    (%eax),%eax
  803189:	a3 38 51 80 00       	mov    %eax,0x805138
  80318e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803191:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803197:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80319a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031a1:	a1 44 51 80 00       	mov    0x805144,%eax
  8031a6:	48                   	dec    %eax
  8031a7:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8031ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031af:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8031b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031b9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8031c0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031c4:	75 17                	jne    8031dd <insert_sorted_with_merge_freeList+0x655>
  8031c6:	83 ec 04             	sub    $0x4,%esp
  8031c9:	68 4c 3f 80 00       	push   $0x803f4c
  8031ce:	68 6e 01 00 00       	push   $0x16e
  8031d3:	68 6f 3f 80 00       	push   $0x803f6f
  8031d8:	e8 d9 d0 ff ff       	call   8002b6 <_panic>
  8031dd:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e6:	89 10                	mov    %edx,(%eax)
  8031e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031eb:	8b 00                	mov    (%eax),%eax
  8031ed:	85 c0                	test   %eax,%eax
  8031ef:	74 0d                	je     8031fe <insert_sorted_with_merge_freeList+0x676>
  8031f1:	a1 48 51 80 00       	mov    0x805148,%eax
  8031f6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031f9:	89 50 04             	mov    %edx,0x4(%eax)
  8031fc:	eb 08                	jmp    803206 <insert_sorted_with_merge_freeList+0x67e>
  8031fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803201:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803206:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803209:	a3 48 51 80 00       	mov    %eax,0x805148
  80320e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803211:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803218:	a1 54 51 80 00       	mov    0x805154,%eax
  80321d:	40                   	inc    %eax
  80321e:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803223:	e9 a9 00 00 00       	jmp    8032d1 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803228:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80322c:	74 06                	je     803234 <insert_sorted_with_merge_freeList+0x6ac>
  80322e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803232:	75 17                	jne    80324b <insert_sorted_with_merge_freeList+0x6c3>
  803234:	83 ec 04             	sub    $0x4,%esp
  803237:	68 e4 3f 80 00       	push   $0x803fe4
  80323c:	68 73 01 00 00       	push   $0x173
  803241:	68 6f 3f 80 00       	push   $0x803f6f
  803246:	e8 6b d0 ff ff       	call   8002b6 <_panic>
  80324b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80324e:	8b 10                	mov    (%eax),%edx
  803250:	8b 45 08             	mov    0x8(%ebp),%eax
  803253:	89 10                	mov    %edx,(%eax)
  803255:	8b 45 08             	mov    0x8(%ebp),%eax
  803258:	8b 00                	mov    (%eax),%eax
  80325a:	85 c0                	test   %eax,%eax
  80325c:	74 0b                	je     803269 <insert_sorted_with_merge_freeList+0x6e1>
  80325e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803261:	8b 00                	mov    (%eax),%eax
  803263:	8b 55 08             	mov    0x8(%ebp),%edx
  803266:	89 50 04             	mov    %edx,0x4(%eax)
  803269:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80326c:	8b 55 08             	mov    0x8(%ebp),%edx
  80326f:	89 10                	mov    %edx,(%eax)
  803271:	8b 45 08             	mov    0x8(%ebp),%eax
  803274:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803277:	89 50 04             	mov    %edx,0x4(%eax)
  80327a:	8b 45 08             	mov    0x8(%ebp),%eax
  80327d:	8b 00                	mov    (%eax),%eax
  80327f:	85 c0                	test   %eax,%eax
  803281:	75 08                	jne    80328b <insert_sorted_with_merge_freeList+0x703>
  803283:	8b 45 08             	mov    0x8(%ebp),%eax
  803286:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80328b:	a1 44 51 80 00       	mov    0x805144,%eax
  803290:	40                   	inc    %eax
  803291:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803296:	eb 39                	jmp    8032d1 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803298:	a1 40 51 80 00       	mov    0x805140,%eax
  80329d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032a4:	74 07                	je     8032ad <insert_sorted_with_merge_freeList+0x725>
  8032a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a9:	8b 00                	mov    (%eax),%eax
  8032ab:	eb 05                	jmp    8032b2 <insert_sorted_with_merge_freeList+0x72a>
  8032ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8032b2:	a3 40 51 80 00       	mov    %eax,0x805140
  8032b7:	a1 40 51 80 00       	mov    0x805140,%eax
  8032bc:	85 c0                	test   %eax,%eax
  8032be:	0f 85 c7 fb ff ff    	jne    802e8b <insert_sorted_with_merge_freeList+0x303>
  8032c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032c8:	0f 85 bd fb ff ff    	jne    802e8b <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8032ce:	eb 01                	jmp    8032d1 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8032d0:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8032d1:	90                   	nop
  8032d2:	c9                   	leave  
  8032d3:	c3                   	ret    

008032d4 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8032d4:	55                   	push   %ebp
  8032d5:	89 e5                	mov    %esp,%ebp
  8032d7:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8032da:	8b 55 08             	mov    0x8(%ebp),%edx
  8032dd:	89 d0                	mov    %edx,%eax
  8032df:	c1 e0 02             	shl    $0x2,%eax
  8032e2:	01 d0                	add    %edx,%eax
  8032e4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8032eb:	01 d0                	add    %edx,%eax
  8032ed:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8032f4:	01 d0                	add    %edx,%eax
  8032f6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8032fd:	01 d0                	add    %edx,%eax
  8032ff:	c1 e0 04             	shl    $0x4,%eax
  803302:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803305:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  80330c:	8d 45 e8             	lea    -0x18(%ebp),%eax
  80330f:	83 ec 0c             	sub    $0xc,%esp
  803312:	50                   	push   %eax
  803313:	e8 26 e7 ff ff       	call   801a3e <sys_get_virtual_time>
  803318:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  80331b:	eb 41                	jmp    80335e <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  80331d:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803320:	83 ec 0c             	sub    $0xc,%esp
  803323:	50                   	push   %eax
  803324:	e8 15 e7 ff ff       	call   801a3e <sys_get_virtual_time>
  803329:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  80332c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80332f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803332:	29 c2                	sub    %eax,%edx
  803334:	89 d0                	mov    %edx,%eax
  803336:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803339:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80333c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80333f:	89 d1                	mov    %edx,%ecx
  803341:	29 c1                	sub    %eax,%ecx
  803343:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803346:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803349:	39 c2                	cmp    %eax,%edx
  80334b:	0f 97 c0             	seta   %al
  80334e:	0f b6 c0             	movzbl %al,%eax
  803351:	29 c1                	sub    %eax,%ecx
  803353:	89 c8                	mov    %ecx,%eax
  803355:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803358:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80335b:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  80335e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803361:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803364:	72 b7                	jb     80331d <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803366:	90                   	nop
  803367:	c9                   	leave  
  803368:	c3                   	ret    

00803369 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803369:	55                   	push   %ebp
  80336a:	89 e5                	mov    %esp,%ebp
  80336c:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  80336f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803376:	eb 03                	jmp    80337b <busy_wait+0x12>
  803378:	ff 45 fc             	incl   -0x4(%ebp)
  80337b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80337e:	3b 45 08             	cmp    0x8(%ebp),%eax
  803381:	72 f5                	jb     803378 <busy_wait+0xf>
	return i;
  803383:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803386:	c9                   	leave  
  803387:	c3                   	ret    

00803388 <__udivdi3>:
  803388:	55                   	push   %ebp
  803389:	57                   	push   %edi
  80338a:	56                   	push   %esi
  80338b:	53                   	push   %ebx
  80338c:	83 ec 1c             	sub    $0x1c,%esp
  80338f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803393:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803397:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80339b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80339f:	89 ca                	mov    %ecx,%edx
  8033a1:	89 f8                	mov    %edi,%eax
  8033a3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8033a7:	85 f6                	test   %esi,%esi
  8033a9:	75 2d                	jne    8033d8 <__udivdi3+0x50>
  8033ab:	39 cf                	cmp    %ecx,%edi
  8033ad:	77 65                	ja     803414 <__udivdi3+0x8c>
  8033af:	89 fd                	mov    %edi,%ebp
  8033b1:	85 ff                	test   %edi,%edi
  8033b3:	75 0b                	jne    8033c0 <__udivdi3+0x38>
  8033b5:	b8 01 00 00 00       	mov    $0x1,%eax
  8033ba:	31 d2                	xor    %edx,%edx
  8033bc:	f7 f7                	div    %edi
  8033be:	89 c5                	mov    %eax,%ebp
  8033c0:	31 d2                	xor    %edx,%edx
  8033c2:	89 c8                	mov    %ecx,%eax
  8033c4:	f7 f5                	div    %ebp
  8033c6:	89 c1                	mov    %eax,%ecx
  8033c8:	89 d8                	mov    %ebx,%eax
  8033ca:	f7 f5                	div    %ebp
  8033cc:	89 cf                	mov    %ecx,%edi
  8033ce:	89 fa                	mov    %edi,%edx
  8033d0:	83 c4 1c             	add    $0x1c,%esp
  8033d3:	5b                   	pop    %ebx
  8033d4:	5e                   	pop    %esi
  8033d5:	5f                   	pop    %edi
  8033d6:	5d                   	pop    %ebp
  8033d7:	c3                   	ret    
  8033d8:	39 ce                	cmp    %ecx,%esi
  8033da:	77 28                	ja     803404 <__udivdi3+0x7c>
  8033dc:	0f bd fe             	bsr    %esi,%edi
  8033df:	83 f7 1f             	xor    $0x1f,%edi
  8033e2:	75 40                	jne    803424 <__udivdi3+0x9c>
  8033e4:	39 ce                	cmp    %ecx,%esi
  8033e6:	72 0a                	jb     8033f2 <__udivdi3+0x6a>
  8033e8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8033ec:	0f 87 9e 00 00 00    	ja     803490 <__udivdi3+0x108>
  8033f2:	b8 01 00 00 00       	mov    $0x1,%eax
  8033f7:	89 fa                	mov    %edi,%edx
  8033f9:	83 c4 1c             	add    $0x1c,%esp
  8033fc:	5b                   	pop    %ebx
  8033fd:	5e                   	pop    %esi
  8033fe:	5f                   	pop    %edi
  8033ff:	5d                   	pop    %ebp
  803400:	c3                   	ret    
  803401:	8d 76 00             	lea    0x0(%esi),%esi
  803404:	31 ff                	xor    %edi,%edi
  803406:	31 c0                	xor    %eax,%eax
  803408:	89 fa                	mov    %edi,%edx
  80340a:	83 c4 1c             	add    $0x1c,%esp
  80340d:	5b                   	pop    %ebx
  80340e:	5e                   	pop    %esi
  80340f:	5f                   	pop    %edi
  803410:	5d                   	pop    %ebp
  803411:	c3                   	ret    
  803412:	66 90                	xchg   %ax,%ax
  803414:	89 d8                	mov    %ebx,%eax
  803416:	f7 f7                	div    %edi
  803418:	31 ff                	xor    %edi,%edi
  80341a:	89 fa                	mov    %edi,%edx
  80341c:	83 c4 1c             	add    $0x1c,%esp
  80341f:	5b                   	pop    %ebx
  803420:	5e                   	pop    %esi
  803421:	5f                   	pop    %edi
  803422:	5d                   	pop    %ebp
  803423:	c3                   	ret    
  803424:	bd 20 00 00 00       	mov    $0x20,%ebp
  803429:	89 eb                	mov    %ebp,%ebx
  80342b:	29 fb                	sub    %edi,%ebx
  80342d:	89 f9                	mov    %edi,%ecx
  80342f:	d3 e6                	shl    %cl,%esi
  803431:	89 c5                	mov    %eax,%ebp
  803433:	88 d9                	mov    %bl,%cl
  803435:	d3 ed                	shr    %cl,%ebp
  803437:	89 e9                	mov    %ebp,%ecx
  803439:	09 f1                	or     %esi,%ecx
  80343b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80343f:	89 f9                	mov    %edi,%ecx
  803441:	d3 e0                	shl    %cl,%eax
  803443:	89 c5                	mov    %eax,%ebp
  803445:	89 d6                	mov    %edx,%esi
  803447:	88 d9                	mov    %bl,%cl
  803449:	d3 ee                	shr    %cl,%esi
  80344b:	89 f9                	mov    %edi,%ecx
  80344d:	d3 e2                	shl    %cl,%edx
  80344f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803453:	88 d9                	mov    %bl,%cl
  803455:	d3 e8                	shr    %cl,%eax
  803457:	09 c2                	or     %eax,%edx
  803459:	89 d0                	mov    %edx,%eax
  80345b:	89 f2                	mov    %esi,%edx
  80345d:	f7 74 24 0c          	divl   0xc(%esp)
  803461:	89 d6                	mov    %edx,%esi
  803463:	89 c3                	mov    %eax,%ebx
  803465:	f7 e5                	mul    %ebp
  803467:	39 d6                	cmp    %edx,%esi
  803469:	72 19                	jb     803484 <__udivdi3+0xfc>
  80346b:	74 0b                	je     803478 <__udivdi3+0xf0>
  80346d:	89 d8                	mov    %ebx,%eax
  80346f:	31 ff                	xor    %edi,%edi
  803471:	e9 58 ff ff ff       	jmp    8033ce <__udivdi3+0x46>
  803476:	66 90                	xchg   %ax,%ax
  803478:	8b 54 24 08          	mov    0x8(%esp),%edx
  80347c:	89 f9                	mov    %edi,%ecx
  80347e:	d3 e2                	shl    %cl,%edx
  803480:	39 c2                	cmp    %eax,%edx
  803482:	73 e9                	jae    80346d <__udivdi3+0xe5>
  803484:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803487:	31 ff                	xor    %edi,%edi
  803489:	e9 40 ff ff ff       	jmp    8033ce <__udivdi3+0x46>
  80348e:	66 90                	xchg   %ax,%ax
  803490:	31 c0                	xor    %eax,%eax
  803492:	e9 37 ff ff ff       	jmp    8033ce <__udivdi3+0x46>
  803497:	90                   	nop

00803498 <__umoddi3>:
  803498:	55                   	push   %ebp
  803499:	57                   	push   %edi
  80349a:	56                   	push   %esi
  80349b:	53                   	push   %ebx
  80349c:	83 ec 1c             	sub    $0x1c,%esp
  80349f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8034a3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8034a7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8034ab:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8034af:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8034b3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8034b7:	89 f3                	mov    %esi,%ebx
  8034b9:	89 fa                	mov    %edi,%edx
  8034bb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8034bf:	89 34 24             	mov    %esi,(%esp)
  8034c2:	85 c0                	test   %eax,%eax
  8034c4:	75 1a                	jne    8034e0 <__umoddi3+0x48>
  8034c6:	39 f7                	cmp    %esi,%edi
  8034c8:	0f 86 a2 00 00 00    	jbe    803570 <__umoddi3+0xd8>
  8034ce:	89 c8                	mov    %ecx,%eax
  8034d0:	89 f2                	mov    %esi,%edx
  8034d2:	f7 f7                	div    %edi
  8034d4:	89 d0                	mov    %edx,%eax
  8034d6:	31 d2                	xor    %edx,%edx
  8034d8:	83 c4 1c             	add    $0x1c,%esp
  8034db:	5b                   	pop    %ebx
  8034dc:	5e                   	pop    %esi
  8034dd:	5f                   	pop    %edi
  8034de:	5d                   	pop    %ebp
  8034df:	c3                   	ret    
  8034e0:	39 f0                	cmp    %esi,%eax
  8034e2:	0f 87 ac 00 00 00    	ja     803594 <__umoddi3+0xfc>
  8034e8:	0f bd e8             	bsr    %eax,%ebp
  8034eb:	83 f5 1f             	xor    $0x1f,%ebp
  8034ee:	0f 84 ac 00 00 00    	je     8035a0 <__umoddi3+0x108>
  8034f4:	bf 20 00 00 00       	mov    $0x20,%edi
  8034f9:	29 ef                	sub    %ebp,%edi
  8034fb:	89 fe                	mov    %edi,%esi
  8034fd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803501:	89 e9                	mov    %ebp,%ecx
  803503:	d3 e0                	shl    %cl,%eax
  803505:	89 d7                	mov    %edx,%edi
  803507:	89 f1                	mov    %esi,%ecx
  803509:	d3 ef                	shr    %cl,%edi
  80350b:	09 c7                	or     %eax,%edi
  80350d:	89 e9                	mov    %ebp,%ecx
  80350f:	d3 e2                	shl    %cl,%edx
  803511:	89 14 24             	mov    %edx,(%esp)
  803514:	89 d8                	mov    %ebx,%eax
  803516:	d3 e0                	shl    %cl,%eax
  803518:	89 c2                	mov    %eax,%edx
  80351a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80351e:	d3 e0                	shl    %cl,%eax
  803520:	89 44 24 04          	mov    %eax,0x4(%esp)
  803524:	8b 44 24 08          	mov    0x8(%esp),%eax
  803528:	89 f1                	mov    %esi,%ecx
  80352a:	d3 e8                	shr    %cl,%eax
  80352c:	09 d0                	or     %edx,%eax
  80352e:	d3 eb                	shr    %cl,%ebx
  803530:	89 da                	mov    %ebx,%edx
  803532:	f7 f7                	div    %edi
  803534:	89 d3                	mov    %edx,%ebx
  803536:	f7 24 24             	mull   (%esp)
  803539:	89 c6                	mov    %eax,%esi
  80353b:	89 d1                	mov    %edx,%ecx
  80353d:	39 d3                	cmp    %edx,%ebx
  80353f:	0f 82 87 00 00 00    	jb     8035cc <__umoddi3+0x134>
  803545:	0f 84 91 00 00 00    	je     8035dc <__umoddi3+0x144>
  80354b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80354f:	29 f2                	sub    %esi,%edx
  803551:	19 cb                	sbb    %ecx,%ebx
  803553:	89 d8                	mov    %ebx,%eax
  803555:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803559:	d3 e0                	shl    %cl,%eax
  80355b:	89 e9                	mov    %ebp,%ecx
  80355d:	d3 ea                	shr    %cl,%edx
  80355f:	09 d0                	or     %edx,%eax
  803561:	89 e9                	mov    %ebp,%ecx
  803563:	d3 eb                	shr    %cl,%ebx
  803565:	89 da                	mov    %ebx,%edx
  803567:	83 c4 1c             	add    $0x1c,%esp
  80356a:	5b                   	pop    %ebx
  80356b:	5e                   	pop    %esi
  80356c:	5f                   	pop    %edi
  80356d:	5d                   	pop    %ebp
  80356e:	c3                   	ret    
  80356f:	90                   	nop
  803570:	89 fd                	mov    %edi,%ebp
  803572:	85 ff                	test   %edi,%edi
  803574:	75 0b                	jne    803581 <__umoddi3+0xe9>
  803576:	b8 01 00 00 00       	mov    $0x1,%eax
  80357b:	31 d2                	xor    %edx,%edx
  80357d:	f7 f7                	div    %edi
  80357f:	89 c5                	mov    %eax,%ebp
  803581:	89 f0                	mov    %esi,%eax
  803583:	31 d2                	xor    %edx,%edx
  803585:	f7 f5                	div    %ebp
  803587:	89 c8                	mov    %ecx,%eax
  803589:	f7 f5                	div    %ebp
  80358b:	89 d0                	mov    %edx,%eax
  80358d:	e9 44 ff ff ff       	jmp    8034d6 <__umoddi3+0x3e>
  803592:	66 90                	xchg   %ax,%ax
  803594:	89 c8                	mov    %ecx,%eax
  803596:	89 f2                	mov    %esi,%edx
  803598:	83 c4 1c             	add    $0x1c,%esp
  80359b:	5b                   	pop    %ebx
  80359c:	5e                   	pop    %esi
  80359d:	5f                   	pop    %edi
  80359e:	5d                   	pop    %ebp
  80359f:	c3                   	ret    
  8035a0:	3b 04 24             	cmp    (%esp),%eax
  8035a3:	72 06                	jb     8035ab <__umoddi3+0x113>
  8035a5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8035a9:	77 0f                	ja     8035ba <__umoddi3+0x122>
  8035ab:	89 f2                	mov    %esi,%edx
  8035ad:	29 f9                	sub    %edi,%ecx
  8035af:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8035b3:	89 14 24             	mov    %edx,(%esp)
  8035b6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8035ba:	8b 44 24 04          	mov    0x4(%esp),%eax
  8035be:	8b 14 24             	mov    (%esp),%edx
  8035c1:	83 c4 1c             	add    $0x1c,%esp
  8035c4:	5b                   	pop    %ebx
  8035c5:	5e                   	pop    %esi
  8035c6:	5f                   	pop    %edi
  8035c7:	5d                   	pop    %ebp
  8035c8:	c3                   	ret    
  8035c9:	8d 76 00             	lea    0x0(%esi),%esi
  8035cc:	2b 04 24             	sub    (%esp),%eax
  8035cf:	19 fa                	sbb    %edi,%edx
  8035d1:	89 d1                	mov    %edx,%ecx
  8035d3:	89 c6                	mov    %eax,%esi
  8035d5:	e9 71 ff ff ff       	jmp    80354b <__umoddi3+0xb3>
  8035da:	66 90                	xchg   %ax,%ax
  8035dc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8035e0:	72 ea                	jb     8035cc <__umoddi3+0x134>
  8035e2:	89 d9                	mov    %ebx,%ecx
  8035e4:	e9 62 ff ff ff       	jmp    80354b <__umoddi3+0xb3>
