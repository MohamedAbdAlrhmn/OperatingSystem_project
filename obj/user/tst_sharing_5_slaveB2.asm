
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
  80008c:	68 60 36 80 00       	push   $0x803660
  800091:	6a 12                	push   $0x12
  800093:	68 7c 36 80 00       	push   $0x80367c
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
  8000aa:	e8 c4 19 00 00       	call   801a73 <sys_getparentenvid>
  8000af:	83 ec 08             	sub    $0x8,%esp
  8000b2:	68 99 36 80 00       	push   $0x803699
  8000b7:	50                   	push   %eax
  8000b8:	e8 19 15 00 00       	call   8015d6 <sget>
  8000bd:	83 c4 10             	add    $0x10,%esp
  8000c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("Slave B2 env used z (getSharedObject)\n");
  8000c3:	83 ec 0c             	sub    $0xc,%esp
  8000c6:	68 9c 36 80 00       	push   $0x80369c
  8000cb:	e8 9a 04 00 00       	call   80056a <cprintf>
  8000d0:	83 c4 10             	add    $0x10,%esp
	//To indicate that it's successfully got z
	inctst();
  8000d3:	e8 c0 1a 00 00       	call   801b98 <inctst>

	cprintf("Slave B2 please be patient ...\n");
  8000d8:	83 ec 0c             	sub    $0xc,%esp
  8000db:	68 c4 36 80 00       	push   $0x8036c4
  8000e0:	e8 85 04 00 00       	call   80056a <cprintf>
  8000e5:	83 c4 10             	add    $0x10,%esp

	//sleep a while to allow the master to remove x & z
	env_sleep(9000);
  8000e8:	83 ec 0c             	sub    $0xc,%esp
  8000eb:	68 28 23 00 00       	push   $0x2328
  8000f0:	e8 47 32 00 00       	call   80333c <env_sleep>
  8000f5:	83 c4 10             	add    $0x10,%esp
	//to ensure that the other environments completed successfully
	while (gettst()!=2) ;// panic("test failed");
  8000f8:	90                   	nop
  8000f9:	e8 b4 1a 00 00       	call   801bb2 <gettst>
  8000fe:	83 f8 02             	cmp    $0x2,%eax
  800101:	75 f6                	jne    8000f9 <_main+0xc1>

	int freeFrames = sys_calculate_free_frames() ;
  800103:	e8 72 16 00 00       	call   80177a <sys_calculate_free_frames>
  800108:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sfree(z);
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	ff 75 ec             	pushl  -0x14(%ebp)
  800111:	e8 04 15 00 00       	call   80161a <sfree>
  800116:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave B2 env removed z\n");
  800119:	83 ec 0c             	sub    $0xc,%esp
  80011c:	68 e4 36 80 00       	push   $0x8036e4
  800121:	e8 44 04 00 00       	call   80056a <cprintf>
  800126:	83 c4 10             	add    $0x10,%esp
	int expected = (1+1) + (1+1);
  800129:	c7 45 e4 04 00 00 00 	movl   $0x4,-0x1c(%ebp)
	if ((sys_calculate_free_frames() - freeFrames) !=  expected) panic("wrong free: frames removed not equal 4 !, correct frames to be removed are 4:\nfrom the env: 1 table + 1 frame for z\nframes_storage of z: should be cleared now\n");
  800130:	e8 45 16 00 00       	call   80177a <sys_calculate_free_frames>
  800135:	89 c2                	mov    %eax,%edx
  800137:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80013a:	29 c2                	sub    %eax,%edx
  80013c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80013f:	39 c2                	cmp    %eax,%edx
  800141:	74 14                	je     800157 <_main+0x11f>
  800143:	83 ec 04             	sub    $0x4,%esp
  800146:	68 fc 36 80 00       	push   $0x8036fc
  80014b:	6a 2a                	push   $0x2a
  80014d:	68 7c 36 80 00       	push   $0x80367c
  800152:	e8 5f 01 00 00       	call   8002b6 <_panic>


	cprintf("Step B completed successfully!!\n\n\n");
  800157:	83 ec 0c             	sub    $0xc,%esp
  80015a:	68 9c 37 80 00       	push   $0x80379c
  80015f:	e8 06 04 00 00       	call   80056a <cprintf>
  800164:	83 c4 10             	add    $0x10,%esp
	cprintf("Congratulations!! Test of freeSharedObjects [5] completed successfully!!\n\n\n");
  800167:	83 ec 0c             	sub    $0xc,%esp
  80016a:	68 c0 37 80 00       	push   $0x8037c0
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
  800180:	e8 d5 18 00 00       	call   801a5a <sys_getenvindex>
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
  8001eb:	e8 77 16 00 00       	call   801867 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001f0:	83 ec 0c             	sub    $0xc,%esp
  8001f3:	68 24 38 80 00       	push   $0x803824
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
  80021b:	68 4c 38 80 00       	push   $0x80384c
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
  80024c:	68 74 38 80 00       	push   $0x803874
  800251:	e8 14 03 00 00       	call   80056a <cprintf>
  800256:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800259:	a1 20 50 80 00       	mov    0x805020,%eax
  80025e:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800264:	83 ec 08             	sub    $0x8,%esp
  800267:	50                   	push   %eax
  800268:	68 cc 38 80 00       	push   $0x8038cc
  80026d:	e8 f8 02 00 00       	call   80056a <cprintf>
  800272:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800275:	83 ec 0c             	sub    $0xc,%esp
  800278:	68 24 38 80 00       	push   $0x803824
  80027d:	e8 e8 02 00 00       	call   80056a <cprintf>
  800282:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800285:	e8 f7 15 00 00       	call   801881 <sys_enable_interrupt>

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
  80029d:	e8 84 17 00 00       	call   801a26 <sys_destroy_env>
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
  8002ae:	e8 d9 17 00 00       	call   801a8c <sys_exit_env>
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
  8002d7:	68 e0 38 80 00       	push   $0x8038e0
  8002dc:	e8 89 02 00 00       	call   80056a <cprintf>
  8002e1:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002e4:	a1 00 50 80 00       	mov    0x805000,%eax
  8002e9:	ff 75 0c             	pushl  0xc(%ebp)
  8002ec:	ff 75 08             	pushl  0x8(%ebp)
  8002ef:	50                   	push   %eax
  8002f0:	68 e5 38 80 00       	push   $0x8038e5
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
  800314:	68 01 39 80 00       	push   $0x803901
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
  800340:	68 04 39 80 00       	push   $0x803904
  800345:	6a 26                	push   $0x26
  800347:	68 50 39 80 00       	push   $0x803950
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
  800412:	68 5c 39 80 00       	push   $0x80395c
  800417:	6a 3a                	push   $0x3a
  800419:	68 50 39 80 00       	push   $0x803950
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
  800482:	68 b0 39 80 00       	push   $0x8039b0
  800487:	6a 44                	push   $0x44
  800489:	68 50 39 80 00       	push   $0x803950
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
  8004dc:	e8 d8 11 00 00       	call   8016b9 <sys_cputs>
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
  800553:	e8 61 11 00 00       	call   8016b9 <sys_cputs>
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
  80059d:	e8 c5 12 00 00       	call   801867 <sys_disable_interrupt>
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
  8005bd:	e8 bf 12 00 00       	call   801881 <sys_enable_interrupt>
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
  800607:	e8 e4 2d 00 00       	call   8033f0 <__udivdi3>
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
  800657:	e8 a4 2e 00 00       	call   803500 <__umoddi3>
  80065c:	83 c4 10             	add    $0x10,%esp
  80065f:	05 14 3c 80 00       	add    $0x803c14,%eax
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
  8007b2:	8b 04 85 38 3c 80 00 	mov    0x803c38(,%eax,4),%eax
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
  800893:	8b 34 9d 80 3a 80 00 	mov    0x803a80(,%ebx,4),%esi
  80089a:	85 f6                	test   %esi,%esi
  80089c:	75 19                	jne    8008b7 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80089e:	53                   	push   %ebx
  80089f:	68 25 3c 80 00       	push   $0x803c25
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
  8008b8:	68 2e 3c 80 00       	push   $0x803c2e
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
  8008e5:	be 31 3c 80 00       	mov    $0x803c31,%esi
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
  80130b:	68 90 3d 80 00       	push   $0x803d90
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
  8013db:	e8 1d 04 00 00       	call   8017fd <sys_allocate_chunk>
  8013e0:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013e3:	a1 20 51 80 00       	mov    0x805120,%eax
  8013e8:	83 ec 0c             	sub    $0xc,%esp
  8013eb:	50                   	push   %eax
  8013ec:	e8 92 0a 00 00       	call   801e83 <initialize_MemBlocksList>
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
  801419:	68 b5 3d 80 00       	push   $0x803db5
  80141e:	6a 33                	push   $0x33
  801420:	68 d3 3d 80 00       	push   $0x803dd3
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
  801498:	68 e0 3d 80 00       	push   $0x803de0
  80149d:	6a 34                	push   $0x34
  80149f:	68 d3 3d 80 00       	push   $0x803dd3
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
  80150d:	68 04 3e 80 00       	push   $0x803e04
  801512:	6a 46                	push   $0x46
  801514:	68 d3 3d 80 00       	push   $0x803dd3
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
  801529:	68 2c 3e 80 00       	push   $0x803e2c
  80152e:	6a 61                	push   $0x61
  801530:	68 d3 3d 80 00       	push   $0x803dd3
  801535:	e8 7c ed ff ff       	call   8002b6 <_panic>

0080153a <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80153a:	55                   	push   %ebp
  80153b:	89 e5                	mov    %esp,%ebp
  80153d:	83 ec 38             	sub    $0x38,%esp
  801540:	8b 45 10             	mov    0x10(%ebp),%eax
  801543:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801546:	e8 a9 fd ff ff       	call   8012f4 <InitializeUHeap>
	if (size == 0) return NULL ;
  80154b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80154f:	75 07                	jne    801558 <smalloc+0x1e>
  801551:	b8 00 00 00 00       	mov    $0x0,%eax
  801556:	eb 7c                	jmp    8015d4 <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801558:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80155f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801562:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801565:	01 d0                	add    %edx,%eax
  801567:	48                   	dec    %eax
  801568:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80156b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80156e:	ba 00 00 00 00       	mov    $0x0,%edx
  801573:	f7 75 f0             	divl   -0x10(%ebp)
  801576:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801579:	29 d0                	sub    %edx,%eax
  80157b:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  80157e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801585:	e8 41 06 00 00       	call   801bcb <sys_isUHeapPlacementStrategyFIRSTFIT>
  80158a:	85 c0                	test   %eax,%eax
  80158c:	74 11                	je     80159f <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  80158e:	83 ec 0c             	sub    $0xc,%esp
  801591:	ff 75 e8             	pushl  -0x18(%ebp)
  801594:	e8 ac 0c 00 00       	call   802245 <alloc_block_FF>
  801599:	83 c4 10             	add    $0x10,%esp
  80159c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  80159f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8015a3:	74 2a                	je     8015cf <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8015a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015a8:	8b 40 08             	mov    0x8(%eax),%eax
  8015ab:	89 c2                	mov    %eax,%edx
  8015ad:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8015b1:	52                   	push   %edx
  8015b2:	50                   	push   %eax
  8015b3:	ff 75 0c             	pushl  0xc(%ebp)
  8015b6:	ff 75 08             	pushl  0x8(%ebp)
  8015b9:	e8 92 03 00 00       	call   801950 <sys_createSharedObject>
  8015be:	83 c4 10             	add    $0x10,%esp
  8015c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  8015c4:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  8015c8:	74 05                	je     8015cf <smalloc+0x95>
			return (void*)virtual_address;
  8015ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015cd:	eb 05                	jmp    8015d4 <smalloc+0x9a>
	}
	return NULL;
  8015cf:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8015d4:	c9                   	leave  
  8015d5:	c3                   	ret    

008015d6 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8015d6:	55                   	push   %ebp
  8015d7:	89 e5                	mov    %esp,%ebp
  8015d9:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015dc:	e8 13 fd ff ff       	call   8012f4 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8015e1:	83 ec 04             	sub    $0x4,%esp
  8015e4:	68 50 3e 80 00       	push   $0x803e50
  8015e9:	68 a2 00 00 00       	push   $0xa2
  8015ee:	68 d3 3d 80 00       	push   $0x803dd3
  8015f3:	e8 be ec ff ff       	call   8002b6 <_panic>

008015f8 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8015f8:	55                   	push   %ebp
  8015f9:	89 e5                	mov    %esp,%ebp
  8015fb:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015fe:	e8 f1 fc ff ff       	call   8012f4 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801603:	83 ec 04             	sub    $0x4,%esp
  801606:	68 74 3e 80 00       	push   $0x803e74
  80160b:	68 e6 00 00 00       	push   $0xe6
  801610:	68 d3 3d 80 00       	push   $0x803dd3
  801615:	e8 9c ec ff ff       	call   8002b6 <_panic>

0080161a <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80161a:	55                   	push   %ebp
  80161b:	89 e5                	mov    %esp,%ebp
  80161d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801620:	83 ec 04             	sub    $0x4,%esp
  801623:	68 9c 3e 80 00       	push   $0x803e9c
  801628:	68 fa 00 00 00       	push   $0xfa
  80162d:	68 d3 3d 80 00       	push   $0x803dd3
  801632:	e8 7f ec ff ff       	call   8002b6 <_panic>

00801637 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801637:	55                   	push   %ebp
  801638:	89 e5                	mov    %esp,%ebp
  80163a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80163d:	83 ec 04             	sub    $0x4,%esp
  801640:	68 c0 3e 80 00       	push   $0x803ec0
  801645:	68 05 01 00 00       	push   $0x105
  80164a:	68 d3 3d 80 00       	push   $0x803dd3
  80164f:	e8 62 ec ff ff       	call   8002b6 <_panic>

00801654 <shrink>:

}
void shrink(uint32 newSize)
{
  801654:	55                   	push   %ebp
  801655:	89 e5                	mov    %esp,%ebp
  801657:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80165a:	83 ec 04             	sub    $0x4,%esp
  80165d:	68 c0 3e 80 00       	push   $0x803ec0
  801662:	68 0a 01 00 00       	push   $0x10a
  801667:	68 d3 3d 80 00       	push   $0x803dd3
  80166c:	e8 45 ec ff ff       	call   8002b6 <_panic>

00801671 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801671:	55                   	push   %ebp
  801672:	89 e5                	mov    %esp,%ebp
  801674:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801677:	83 ec 04             	sub    $0x4,%esp
  80167a:	68 c0 3e 80 00       	push   $0x803ec0
  80167f:	68 0f 01 00 00       	push   $0x10f
  801684:	68 d3 3d 80 00       	push   $0x803dd3
  801689:	e8 28 ec ff ff       	call   8002b6 <_panic>

0080168e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80168e:	55                   	push   %ebp
  80168f:	89 e5                	mov    %esp,%ebp
  801691:	57                   	push   %edi
  801692:	56                   	push   %esi
  801693:	53                   	push   %ebx
  801694:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801697:	8b 45 08             	mov    0x8(%ebp),%eax
  80169a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80169d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016a0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016a3:	8b 7d 18             	mov    0x18(%ebp),%edi
  8016a6:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8016a9:	cd 30                	int    $0x30
  8016ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8016ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8016b1:	83 c4 10             	add    $0x10,%esp
  8016b4:	5b                   	pop    %ebx
  8016b5:	5e                   	pop    %esi
  8016b6:	5f                   	pop    %edi
  8016b7:	5d                   	pop    %ebp
  8016b8:	c3                   	ret    

008016b9 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8016b9:	55                   	push   %ebp
  8016ba:	89 e5                	mov    %esp,%ebp
  8016bc:	83 ec 04             	sub    $0x4,%esp
  8016bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8016c2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8016c5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8016c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cc:	6a 00                	push   $0x0
  8016ce:	6a 00                	push   $0x0
  8016d0:	52                   	push   %edx
  8016d1:	ff 75 0c             	pushl  0xc(%ebp)
  8016d4:	50                   	push   %eax
  8016d5:	6a 00                	push   $0x0
  8016d7:	e8 b2 ff ff ff       	call   80168e <syscall>
  8016dc:	83 c4 18             	add    $0x18,%esp
}
  8016df:	90                   	nop
  8016e0:	c9                   	leave  
  8016e1:	c3                   	ret    

008016e2 <sys_cgetc>:

int
sys_cgetc(void)
{
  8016e2:	55                   	push   %ebp
  8016e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8016e5:	6a 00                	push   $0x0
  8016e7:	6a 00                	push   $0x0
  8016e9:	6a 00                	push   $0x0
  8016eb:	6a 00                	push   $0x0
  8016ed:	6a 00                	push   $0x0
  8016ef:	6a 01                	push   $0x1
  8016f1:	e8 98 ff ff ff       	call   80168e <syscall>
  8016f6:	83 c4 18             	add    $0x18,%esp
}
  8016f9:	c9                   	leave  
  8016fa:	c3                   	ret    

008016fb <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8016fb:	55                   	push   %ebp
  8016fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8016fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801701:	8b 45 08             	mov    0x8(%ebp),%eax
  801704:	6a 00                	push   $0x0
  801706:	6a 00                	push   $0x0
  801708:	6a 00                	push   $0x0
  80170a:	52                   	push   %edx
  80170b:	50                   	push   %eax
  80170c:	6a 05                	push   $0x5
  80170e:	e8 7b ff ff ff       	call   80168e <syscall>
  801713:	83 c4 18             	add    $0x18,%esp
}
  801716:	c9                   	leave  
  801717:	c3                   	ret    

00801718 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801718:	55                   	push   %ebp
  801719:	89 e5                	mov    %esp,%ebp
  80171b:	56                   	push   %esi
  80171c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80171d:	8b 75 18             	mov    0x18(%ebp),%esi
  801720:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801723:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801726:	8b 55 0c             	mov    0xc(%ebp),%edx
  801729:	8b 45 08             	mov    0x8(%ebp),%eax
  80172c:	56                   	push   %esi
  80172d:	53                   	push   %ebx
  80172e:	51                   	push   %ecx
  80172f:	52                   	push   %edx
  801730:	50                   	push   %eax
  801731:	6a 06                	push   $0x6
  801733:	e8 56 ff ff ff       	call   80168e <syscall>
  801738:	83 c4 18             	add    $0x18,%esp
}
  80173b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80173e:	5b                   	pop    %ebx
  80173f:	5e                   	pop    %esi
  801740:	5d                   	pop    %ebp
  801741:	c3                   	ret    

00801742 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801742:	55                   	push   %ebp
  801743:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801745:	8b 55 0c             	mov    0xc(%ebp),%edx
  801748:	8b 45 08             	mov    0x8(%ebp),%eax
  80174b:	6a 00                	push   $0x0
  80174d:	6a 00                	push   $0x0
  80174f:	6a 00                	push   $0x0
  801751:	52                   	push   %edx
  801752:	50                   	push   %eax
  801753:	6a 07                	push   $0x7
  801755:	e8 34 ff ff ff       	call   80168e <syscall>
  80175a:	83 c4 18             	add    $0x18,%esp
}
  80175d:	c9                   	leave  
  80175e:	c3                   	ret    

0080175f <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80175f:	55                   	push   %ebp
  801760:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801762:	6a 00                	push   $0x0
  801764:	6a 00                	push   $0x0
  801766:	6a 00                	push   $0x0
  801768:	ff 75 0c             	pushl  0xc(%ebp)
  80176b:	ff 75 08             	pushl  0x8(%ebp)
  80176e:	6a 08                	push   $0x8
  801770:	e8 19 ff ff ff       	call   80168e <syscall>
  801775:	83 c4 18             	add    $0x18,%esp
}
  801778:	c9                   	leave  
  801779:	c3                   	ret    

0080177a <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80177a:	55                   	push   %ebp
  80177b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80177d:	6a 00                	push   $0x0
  80177f:	6a 00                	push   $0x0
  801781:	6a 00                	push   $0x0
  801783:	6a 00                	push   $0x0
  801785:	6a 00                	push   $0x0
  801787:	6a 09                	push   $0x9
  801789:	e8 00 ff ff ff       	call   80168e <syscall>
  80178e:	83 c4 18             	add    $0x18,%esp
}
  801791:	c9                   	leave  
  801792:	c3                   	ret    

00801793 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801793:	55                   	push   %ebp
  801794:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801796:	6a 00                	push   $0x0
  801798:	6a 00                	push   $0x0
  80179a:	6a 00                	push   $0x0
  80179c:	6a 00                	push   $0x0
  80179e:	6a 00                	push   $0x0
  8017a0:	6a 0a                	push   $0xa
  8017a2:	e8 e7 fe ff ff       	call   80168e <syscall>
  8017a7:	83 c4 18             	add    $0x18,%esp
}
  8017aa:	c9                   	leave  
  8017ab:	c3                   	ret    

008017ac <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8017ac:	55                   	push   %ebp
  8017ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8017af:	6a 00                	push   $0x0
  8017b1:	6a 00                	push   $0x0
  8017b3:	6a 00                	push   $0x0
  8017b5:	6a 00                	push   $0x0
  8017b7:	6a 00                	push   $0x0
  8017b9:	6a 0b                	push   $0xb
  8017bb:	e8 ce fe ff ff       	call   80168e <syscall>
  8017c0:	83 c4 18             	add    $0x18,%esp
}
  8017c3:	c9                   	leave  
  8017c4:	c3                   	ret    

008017c5 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8017c5:	55                   	push   %ebp
  8017c6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8017c8:	6a 00                	push   $0x0
  8017ca:	6a 00                	push   $0x0
  8017cc:	6a 00                	push   $0x0
  8017ce:	ff 75 0c             	pushl  0xc(%ebp)
  8017d1:	ff 75 08             	pushl  0x8(%ebp)
  8017d4:	6a 0f                	push   $0xf
  8017d6:	e8 b3 fe ff ff       	call   80168e <syscall>
  8017db:	83 c4 18             	add    $0x18,%esp
	return;
  8017de:	90                   	nop
}
  8017df:	c9                   	leave  
  8017e0:	c3                   	ret    

008017e1 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8017e1:	55                   	push   %ebp
  8017e2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8017e4:	6a 00                	push   $0x0
  8017e6:	6a 00                	push   $0x0
  8017e8:	6a 00                	push   $0x0
  8017ea:	ff 75 0c             	pushl  0xc(%ebp)
  8017ed:	ff 75 08             	pushl  0x8(%ebp)
  8017f0:	6a 10                	push   $0x10
  8017f2:	e8 97 fe ff ff       	call   80168e <syscall>
  8017f7:	83 c4 18             	add    $0x18,%esp
	return ;
  8017fa:	90                   	nop
}
  8017fb:	c9                   	leave  
  8017fc:	c3                   	ret    

008017fd <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8017fd:	55                   	push   %ebp
  8017fe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801800:	6a 00                	push   $0x0
  801802:	6a 00                	push   $0x0
  801804:	ff 75 10             	pushl  0x10(%ebp)
  801807:	ff 75 0c             	pushl  0xc(%ebp)
  80180a:	ff 75 08             	pushl  0x8(%ebp)
  80180d:	6a 11                	push   $0x11
  80180f:	e8 7a fe ff ff       	call   80168e <syscall>
  801814:	83 c4 18             	add    $0x18,%esp
	return ;
  801817:	90                   	nop
}
  801818:	c9                   	leave  
  801819:	c3                   	ret    

0080181a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80181a:	55                   	push   %ebp
  80181b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80181d:	6a 00                	push   $0x0
  80181f:	6a 00                	push   $0x0
  801821:	6a 00                	push   $0x0
  801823:	6a 00                	push   $0x0
  801825:	6a 00                	push   $0x0
  801827:	6a 0c                	push   $0xc
  801829:	e8 60 fe ff ff       	call   80168e <syscall>
  80182e:	83 c4 18             	add    $0x18,%esp
}
  801831:	c9                   	leave  
  801832:	c3                   	ret    

00801833 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801833:	55                   	push   %ebp
  801834:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801836:	6a 00                	push   $0x0
  801838:	6a 00                	push   $0x0
  80183a:	6a 00                	push   $0x0
  80183c:	6a 00                	push   $0x0
  80183e:	ff 75 08             	pushl  0x8(%ebp)
  801841:	6a 0d                	push   $0xd
  801843:	e8 46 fe ff ff       	call   80168e <syscall>
  801848:	83 c4 18             	add    $0x18,%esp
}
  80184b:	c9                   	leave  
  80184c:	c3                   	ret    

0080184d <sys_scarce_memory>:

void sys_scarce_memory()
{
  80184d:	55                   	push   %ebp
  80184e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801850:	6a 00                	push   $0x0
  801852:	6a 00                	push   $0x0
  801854:	6a 00                	push   $0x0
  801856:	6a 00                	push   $0x0
  801858:	6a 00                	push   $0x0
  80185a:	6a 0e                	push   $0xe
  80185c:	e8 2d fe ff ff       	call   80168e <syscall>
  801861:	83 c4 18             	add    $0x18,%esp
}
  801864:	90                   	nop
  801865:	c9                   	leave  
  801866:	c3                   	ret    

00801867 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801867:	55                   	push   %ebp
  801868:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80186a:	6a 00                	push   $0x0
  80186c:	6a 00                	push   $0x0
  80186e:	6a 00                	push   $0x0
  801870:	6a 00                	push   $0x0
  801872:	6a 00                	push   $0x0
  801874:	6a 13                	push   $0x13
  801876:	e8 13 fe ff ff       	call   80168e <syscall>
  80187b:	83 c4 18             	add    $0x18,%esp
}
  80187e:	90                   	nop
  80187f:	c9                   	leave  
  801880:	c3                   	ret    

00801881 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801881:	55                   	push   %ebp
  801882:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801884:	6a 00                	push   $0x0
  801886:	6a 00                	push   $0x0
  801888:	6a 00                	push   $0x0
  80188a:	6a 00                	push   $0x0
  80188c:	6a 00                	push   $0x0
  80188e:	6a 14                	push   $0x14
  801890:	e8 f9 fd ff ff       	call   80168e <syscall>
  801895:	83 c4 18             	add    $0x18,%esp
}
  801898:	90                   	nop
  801899:	c9                   	leave  
  80189a:	c3                   	ret    

0080189b <sys_cputc>:


void
sys_cputc(const char c)
{
  80189b:	55                   	push   %ebp
  80189c:	89 e5                	mov    %esp,%ebp
  80189e:	83 ec 04             	sub    $0x4,%esp
  8018a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8018a7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8018ab:	6a 00                	push   $0x0
  8018ad:	6a 00                	push   $0x0
  8018af:	6a 00                	push   $0x0
  8018b1:	6a 00                	push   $0x0
  8018b3:	50                   	push   %eax
  8018b4:	6a 15                	push   $0x15
  8018b6:	e8 d3 fd ff ff       	call   80168e <syscall>
  8018bb:	83 c4 18             	add    $0x18,%esp
}
  8018be:	90                   	nop
  8018bf:	c9                   	leave  
  8018c0:	c3                   	ret    

008018c1 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8018c1:	55                   	push   %ebp
  8018c2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8018c4:	6a 00                	push   $0x0
  8018c6:	6a 00                	push   $0x0
  8018c8:	6a 00                	push   $0x0
  8018ca:	6a 00                	push   $0x0
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 16                	push   $0x16
  8018d0:	e8 b9 fd ff ff       	call   80168e <syscall>
  8018d5:	83 c4 18             	add    $0x18,%esp
}
  8018d8:	90                   	nop
  8018d9:	c9                   	leave  
  8018da:	c3                   	ret    

008018db <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8018db:	55                   	push   %ebp
  8018dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8018de:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e1:	6a 00                	push   $0x0
  8018e3:	6a 00                	push   $0x0
  8018e5:	6a 00                	push   $0x0
  8018e7:	ff 75 0c             	pushl  0xc(%ebp)
  8018ea:	50                   	push   %eax
  8018eb:	6a 17                	push   $0x17
  8018ed:	e8 9c fd ff ff       	call   80168e <syscall>
  8018f2:	83 c4 18             	add    $0x18,%esp
}
  8018f5:	c9                   	leave  
  8018f6:	c3                   	ret    

008018f7 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8018f7:	55                   	push   %ebp
  8018f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801900:	6a 00                	push   $0x0
  801902:	6a 00                	push   $0x0
  801904:	6a 00                	push   $0x0
  801906:	52                   	push   %edx
  801907:	50                   	push   %eax
  801908:	6a 1a                	push   $0x1a
  80190a:	e8 7f fd ff ff       	call   80168e <syscall>
  80190f:	83 c4 18             	add    $0x18,%esp
}
  801912:	c9                   	leave  
  801913:	c3                   	ret    

00801914 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801914:	55                   	push   %ebp
  801915:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801917:	8b 55 0c             	mov    0xc(%ebp),%edx
  80191a:	8b 45 08             	mov    0x8(%ebp),%eax
  80191d:	6a 00                	push   $0x0
  80191f:	6a 00                	push   $0x0
  801921:	6a 00                	push   $0x0
  801923:	52                   	push   %edx
  801924:	50                   	push   %eax
  801925:	6a 18                	push   $0x18
  801927:	e8 62 fd ff ff       	call   80168e <syscall>
  80192c:	83 c4 18             	add    $0x18,%esp
}
  80192f:	90                   	nop
  801930:	c9                   	leave  
  801931:	c3                   	ret    

00801932 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801932:	55                   	push   %ebp
  801933:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801935:	8b 55 0c             	mov    0xc(%ebp),%edx
  801938:	8b 45 08             	mov    0x8(%ebp),%eax
  80193b:	6a 00                	push   $0x0
  80193d:	6a 00                	push   $0x0
  80193f:	6a 00                	push   $0x0
  801941:	52                   	push   %edx
  801942:	50                   	push   %eax
  801943:	6a 19                	push   $0x19
  801945:	e8 44 fd ff ff       	call   80168e <syscall>
  80194a:	83 c4 18             	add    $0x18,%esp
}
  80194d:	90                   	nop
  80194e:	c9                   	leave  
  80194f:	c3                   	ret    

00801950 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801950:	55                   	push   %ebp
  801951:	89 e5                	mov    %esp,%ebp
  801953:	83 ec 04             	sub    $0x4,%esp
  801956:	8b 45 10             	mov    0x10(%ebp),%eax
  801959:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80195c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80195f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801963:	8b 45 08             	mov    0x8(%ebp),%eax
  801966:	6a 00                	push   $0x0
  801968:	51                   	push   %ecx
  801969:	52                   	push   %edx
  80196a:	ff 75 0c             	pushl  0xc(%ebp)
  80196d:	50                   	push   %eax
  80196e:	6a 1b                	push   $0x1b
  801970:	e8 19 fd ff ff       	call   80168e <syscall>
  801975:	83 c4 18             	add    $0x18,%esp
}
  801978:	c9                   	leave  
  801979:	c3                   	ret    

0080197a <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80197a:	55                   	push   %ebp
  80197b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80197d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801980:	8b 45 08             	mov    0x8(%ebp),%eax
  801983:	6a 00                	push   $0x0
  801985:	6a 00                	push   $0x0
  801987:	6a 00                	push   $0x0
  801989:	52                   	push   %edx
  80198a:	50                   	push   %eax
  80198b:	6a 1c                	push   $0x1c
  80198d:	e8 fc fc ff ff       	call   80168e <syscall>
  801992:	83 c4 18             	add    $0x18,%esp
}
  801995:	c9                   	leave  
  801996:	c3                   	ret    

00801997 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801997:	55                   	push   %ebp
  801998:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80199a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80199d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	51                   	push   %ecx
  8019a8:	52                   	push   %edx
  8019a9:	50                   	push   %eax
  8019aa:	6a 1d                	push   $0x1d
  8019ac:	e8 dd fc ff ff       	call   80168e <syscall>
  8019b1:	83 c4 18             	add    $0x18,%esp
}
  8019b4:	c9                   	leave  
  8019b5:	c3                   	ret    

008019b6 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8019b6:	55                   	push   %ebp
  8019b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8019b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 00                	push   $0x0
  8019c5:	52                   	push   %edx
  8019c6:	50                   	push   %eax
  8019c7:	6a 1e                	push   $0x1e
  8019c9:	e8 c0 fc ff ff       	call   80168e <syscall>
  8019ce:	83 c4 18             	add    $0x18,%esp
}
  8019d1:	c9                   	leave  
  8019d2:	c3                   	ret    

008019d3 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8019d3:	55                   	push   %ebp
  8019d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8019d6:	6a 00                	push   $0x0
  8019d8:	6a 00                	push   $0x0
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 1f                	push   $0x1f
  8019e2:	e8 a7 fc ff ff       	call   80168e <syscall>
  8019e7:	83 c4 18             	add    $0x18,%esp
}
  8019ea:	c9                   	leave  
  8019eb:	c3                   	ret    

008019ec <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8019ec:	55                   	push   %ebp
  8019ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8019ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f2:	6a 00                	push   $0x0
  8019f4:	ff 75 14             	pushl  0x14(%ebp)
  8019f7:	ff 75 10             	pushl  0x10(%ebp)
  8019fa:	ff 75 0c             	pushl  0xc(%ebp)
  8019fd:	50                   	push   %eax
  8019fe:	6a 20                	push   $0x20
  801a00:	e8 89 fc ff ff       	call   80168e <syscall>
  801a05:	83 c4 18             	add    $0x18,%esp
}
  801a08:	c9                   	leave  
  801a09:	c3                   	ret    

00801a0a <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801a0a:	55                   	push   %ebp
  801a0b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a10:	6a 00                	push   $0x0
  801a12:	6a 00                	push   $0x0
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	50                   	push   %eax
  801a19:	6a 21                	push   $0x21
  801a1b:	e8 6e fc ff ff       	call   80168e <syscall>
  801a20:	83 c4 18             	add    $0x18,%esp
}
  801a23:	90                   	nop
  801a24:	c9                   	leave  
  801a25:	c3                   	ret    

00801a26 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801a26:	55                   	push   %ebp
  801a27:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801a29:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 00                	push   $0x0
  801a32:	6a 00                	push   $0x0
  801a34:	50                   	push   %eax
  801a35:	6a 22                	push   $0x22
  801a37:	e8 52 fc ff ff       	call   80168e <syscall>
  801a3c:	83 c4 18             	add    $0x18,%esp
}
  801a3f:	c9                   	leave  
  801a40:	c3                   	ret    

00801a41 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801a41:	55                   	push   %ebp
  801a42:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801a44:	6a 00                	push   $0x0
  801a46:	6a 00                	push   $0x0
  801a48:	6a 00                	push   $0x0
  801a4a:	6a 00                	push   $0x0
  801a4c:	6a 00                	push   $0x0
  801a4e:	6a 02                	push   $0x2
  801a50:	e8 39 fc ff ff       	call   80168e <syscall>
  801a55:	83 c4 18             	add    $0x18,%esp
}
  801a58:	c9                   	leave  
  801a59:	c3                   	ret    

00801a5a <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801a5a:	55                   	push   %ebp
  801a5b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 00                	push   $0x0
  801a63:	6a 00                	push   $0x0
  801a65:	6a 00                	push   $0x0
  801a67:	6a 03                	push   $0x3
  801a69:	e8 20 fc ff ff       	call   80168e <syscall>
  801a6e:	83 c4 18             	add    $0x18,%esp
}
  801a71:	c9                   	leave  
  801a72:	c3                   	ret    

00801a73 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801a73:	55                   	push   %ebp
  801a74:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801a76:	6a 00                	push   $0x0
  801a78:	6a 00                	push   $0x0
  801a7a:	6a 00                	push   $0x0
  801a7c:	6a 00                	push   $0x0
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 04                	push   $0x4
  801a82:	e8 07 fc ff ff       	call   80168e <syscall>
  801a87:	83 c4 18             	add    $0x18,%esp
}
  801a8a:	c9                   	leave  
  801a8b:	c3                   	ret    

00801a8c <sys_exit_env>:


void sys_exit_env(void)
{
  801a8c:	55                   	push   %ebp
  801a8d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 00                	push   $0x0
  801a93:	6a 00                	push   $0x0
  801a95:	6a 00                	push   $0x0
  801a97:	6a 00                	push   $0x0
  801a99:	6a 23                	push   $0x23
  801a9b:	e8 ee fb ff ff       	call   80168e <syscall>
  801aa0:	83 c4 18             	add    $0x18,%esp
}
  801aa3:	90                   	nop
  801aa4:	c9                   	leave  
  801aa5:	c3                   	ret    

00801aa6 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801aa6:	55                   	push   %ebp
  801aa7:	89 e5                	mov    %esp,%ebp
  801aa9:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801aac:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801aaf:	8d 50 04             	lea    0x4(%eax),%edx
  801ab2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ab5:	6a 00                	push   $0x0
  801ab7:	6a 00                	push   $0x0
  801ab9:	6a 00                	push   $0x0
  801abb:	52                   	push   %edx
  801abc:	50                   	push   %eax
  801abd:	6a 24                	push   $0x24
  801abf:	e8 ca fb ff ff       	call   80168e <syscall>
  801ac4:	83 c4 18             	add    $0x18,%esp
	return result;
  801ac7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801aca:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801acd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ad0:	89 01                	mov    %eax,(%ecx)
  801ad2:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801ad5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad8:	c9                   	leave  
  801ad9:	c2 04 00             	ret    $0x4

00801adc <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801adc:	55                   	push   %ebp
  801add:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801adf:	6a 00                	push   $0x0
  801ae1:	6a 00                	push   $0x0
  801ae3:	ff 75 10             	pushl  0x10(%ebp)
  801ae6:	ff 75 0c             	pushl  0xc(%ebp)
  801ae9:	ff 75 08             	pushl  0x8(%ebp)
  801aec:	6a 12                	push   $0x12
  801aee:	e8 9b fb ff ff       	call   80168e <syscall>
  801af3:	83 c4 18             	add    $0x18,%esp
	return ;
  801af6:	90                   	nop
}
  801af7:	c9                   	leave  
  801af8:	c3                   	ret    

00801af9 <sys_rcr2>:
uint32 sys_rcr2()
{
  801af9:	55                   	push   %ebp
  801afa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801afc:	6a 00                	push   $0x0
  801afe:	6a 00                	push   $0x0
  801b00:	6a 00                	push   $0x0
  801b02:	6a 00                	push   $0x0
  801b04:	6a 00                	push   $0x0
  801b06:	6a 25                	push   $0x25
  801b08:	e8 81 fb ff ff       	call   80168e <syscall>
  801b0d:	83 c4 18             	add    $0x18,%esp
}
  801b10:	c9                   	leave  
  801b11:	c3                   	ret    

00801b12 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801b12:	55                   	push   %ebp
  801b13:	89 e5                	mov    %esp,%ebp
  801b15:	83 ec 04             	sub    $0x4,%esp
  801b18:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801b1e:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801b22:	6a 00                	push   $0x0
  801b24:	6a 00                	push   $0x0
  801b26:	6a 00                	push   $0x0
  801b28:	6a 00                	push   $0x0
  801b2a:	50                   	push   %eax
  801b2b:	6a 26                	push   $0x26
  801b2d:	e8 5c fb ff ff       	call   80168e <syscall>
  801b32:	83 c4 18             	add    $0x18,%esp
	return ;
  801b35:	90                   	nop
}
  801b36:	c9                   	leave  
  801b37:	c3                   	ret    

00801b38 <rsttst>:
void rsttst()
{
  801b38:	55                   	push   %ebp
  801b39:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 00                	push   $0x0
  801b3f:	6a 00                	push   $0x0
  801b41:	6a 00                	push   $0x0
  801b43:	6a 00                	push   $0x0
  801b45:	6a 28                	push   $0x28
  801b47:	e8 42 fb ff ff       	call   80168e <syscall>
  801b4c:	83 c4 18             	add    $0x18,%esp
	return ;
  801b4f:	90                   	nop
}
  801b50:	c9                   	leave  
  801b51:	c3                   	ret    

00801b52 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801b52:	55                   	push   %ebp
  801b53:	89 e5                	mov    %esp,%ebp
  801b55:	83 ec 04             	sub    $0x4,%esp
  801b58:	8b 45 14             	mov    0x14(%ebp),%eax
  801b5b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801b5e:	8b 55 18             	mov    0x18(%ebp),%edx
  801b61:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b65:	52                   	push   %edx
  801b66:	50                   	push   %eax
  801b67:	ff 75 10             	pushl  0x10(%ebp)
  801b6a:	ff 75 0c             	pushl  0xc(%ebp)
  801b6d:	ff 75 08             	pushl  0x8(%ebp)
  801b70:	6a 27                	push   $0x27
  801b72:	e8 17 fb ff ff       	call   80168e <syscall>
  801b77:	83 c4 18             	add    $0x18,%esp
	return ;
  801b7a:	90                   	nop
}
  801b7b:	c9                   	leave  
  801b7c:	c3                   	ret    

00801b7d <chktst>:
void chktst(uint32 n)
{
  801b7d:	55                   	push   %ebp
  801b7e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801b80:	6a 00                	push   $0x0
  801b82:	6a 00                	push   $0x0
  801b84:	6a 00                	push   $0x0
  801b86:	6a 00                	push   $0x0
  801b88:	ff 75 08             	pushl  0x8(%ebp)
  801b8b:	6a 29                	push   $0x29
  801b8d:	e8 fc fa ff ff       	call   80168e <syscall>
  801b92:	83 c4 18             	add    $0x18,%esp
	return ;
  801b95:	90                   	nop
}
  801b96:	c9                   	leave  
  801b97:	c3                   	ret    

00801b98 <inctst>:

void inctst()
{
  801b98:	55                   	push   %ebp
  801b99:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 00                	push   $0x0
  801b9f:	6a 00                	push   $0x0
  801ba1:	6a 00                	push   $0x0
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 2a                	push   $0x2a
  801ba7:	e8 e2 fa ff ff       	call   80168e <syscall>
  801bac:	83 c4 18             	add    $0x18,%esp
	return ;
  801baf:	90                   	nop
}
  801bb0:	c9                   	leave  
  801bb1:	c3                   	ret    

00801bb2 <gettst>:
uint32 gettst()
{
  801bb2:	55                   	push   %ebp
  801bb3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801bb5:	6a 00                	push   $0x0
  801bb7:	6a 00                	push   $0x0
  801bb9:	6a 00                	push   $0x0
  801bbb:	6a 00                	push   $0x0
  801bbd:	6a 00                	push   $0x0
  801bbf:	6a 2b                	push   $0x2b
  801bc1:	e8 c8 fa ff ff       	call   80168e <syscall>
  801bc6:	83 c4 18             	add    $0x18,%esp
}
  801bc9:	c9                   	leave  
  801bca:	c3                   	ret    

00801bcb <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801bcb:	55                   	push   %ebp
  801bcc:	89 e5                	mov    %esp,%ebp
  801bce:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bd1:	6a 00                	push   $0x0
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 00                	push   $0x0
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 2c                	push   $0x2c
  801bdd:	e8 ac fa ff ff       	call   80168e <syscall>
  801be2:	83 c4 18             	add    $0x18,%esp
  801be5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801be8:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801bec:	75 07                	jne    801bf5 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801bee:	b8 01 00 00 00       	mov    $0x1,%eax
  801bf3:	eb 05                	jmp    801bfa <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801bf5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bfa:	c9                   	leave  
  801bfb:	c3                   	ret    

00801bfc <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801bfc:	55                   	push   %ebp
  801bfd:	89 e5                	mov    %esp,%ebp
  801bff:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c02:	6a 00                	push   $0x0
  801c04:	6a 00                	push   $0x0
  801c06:	6a 00                	push   $0x0
  801c08:	6a 00                	push   $0x0
  801c0a:	6a 00                	push   $0x0
  801c0c:	6a 2c                	push   $0x2c
  801c0e:	e8 7b fa ff ff       	call   80168e <syscall>
  801c13:	83 c4 18             	add    $0x18,%esp
  801c16:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801c19:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801c1d:	75 07                	jne    801c26 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801c1f:	b8 01 00 00 00       	mov    $0x1,%eax
  801c24:	eb 05                	jmp    801c2b <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801c26:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c2b:	c9                   	leave  
  801c2c:	c3                   	ret    

00801c2d <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801c2d:	55                   	push   %ebp
  801c2e:	89 e5                	mov    %esp,%ebp
  801c30:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c33:	6a 00                	push   $0x0
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 2c                	push   $0x2c
  801c3f:	e8 4a fa ff ff       	call   80168e <syscall>
  801c44:	83 c4 18             	add    $0x18,%esp
  801c47:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801c4a:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801c4e:	75 07                	jne    801c57 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801c50:	b8 01 00 00 00       	mov    $0x1,%eax
  801c55:	eb 05                	jmp    801c5c <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801c57:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c5c:	c9                   	leave  
  801c5d:	c3                   	ret    

00801c5e <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801c5e:	55                   	push   %ebp
  801c5f:	89 e5                	mov    %esp,%ebp
  801c61:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c64:	6a 00                	push   $0x0
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 2c                	push   $0x2c
  801c70:	e8 19 fa ff ff       	call   80168e <syscall>
  801c75:	83 c4 18             	add    $0x18,%esp
  801c78:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801c7b:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801c7f:	75 07                	jne    801c88 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801c81:	b8 01 00 00 00       	mov    $0x1,%eax
  801c86:	eb 05                	jmp    801c8d <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801c88:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c8d:	c9                   	leave  
  801c8e:	c3                   	ret    

00801c8f <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c8f:	55                   	push   %ebp
  801c90:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c92:	6a 00                	push   $0x0
  801c94:	6a 00                	push   $0x0
  801c96:	6a 00                	push   $0x0
  801c98:	6a 00                	push   $0x0
  801c9a:	ff 75 08             	pushl  0x8(%ebp)
  801c9d:	6a 2d                	push   $0x2d
  801c9f:	e8 ea f9 ff ff       	call   80168e <syscall>
  801ca4:	83 c4 18             	add    $0x18,%esp
	return ;
  801ca7:	90                   	nop
}
  801ca8:	c9                   	leave  
  801ca9:	c3                   	ret    

00801caa <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801caa:	55                   	push   %ebp
  801cab:	89 e5                	mov    %esp,%ebp
  801cad:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801cae:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cb1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cb4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cba:	6a 00                	push   $0x0
  801cbc:	53                   	push   %ebx
  801cbd:	51                   	push   %ecx
  801cbe:	52                   	push   %edx
  801cbf:	50                   	push   %eax
  801cc0:	6a 2e                	push   $0x2e
  801cc2:	e8 c7 f9 ff ff       	call   80168e <syscall>
  801cc7:	83 c4 18             	add    $0x18,%esp
}
  801cca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ccd:	c9                   	leave  
  801cce:	c3                   	ret    

00801ccf <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ccf:	55                   	push   %ebp
  801cd0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801cd2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd8:	6a 00                	push   $0x0
  801cda:	6a 00                	push   $0x0
  801cdc:	6a 00                	push   $0x0
  801cde:	52                   	push   %edx
  801cdf:	50                   	push   %eax
  801ce0:	6a 2f                	push   $0x2f
  801ce2:	e8 a7 f9 ff ff       	call   80168e <syscall>
  801ce7:	83 c4 18             	add    $0x18,%esp
}
  801cea:	c9                   	leave  
  801ceb:	c3                   	ret    

00801cec <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801cec:	55                   	push   %ebp
  801ced:	89 e5                	mov    %esp,%ebp
  801cef:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801cf2:	83 ec 0c             	sub    $0xc,%esp
  801cf5:	68 d0 3e 80 00       	push   $0x803ed0
  801cfa:	e8 6b e8 ff ff       	call   80056a <cprintf>
  801cff:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801d02:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801d09:	83 ec 0c             	sub    $0xc,%esp
  801d0c:	68 fc 3e 80 00       	push   $0x803efc
  801d11:	e8 54 e8 ff ff       	call   80056a <cprintf>
  801d16:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801d19:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d1d:	a1 38 51 80 00       	mov    0x805138,%eax
  801d22:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d25:	eb 56                	jmp    801d7d <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801d27:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d2b:	74 1c                	je     801d49 <print_mem_block_lists+0x5d>
  801d2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d30:	8b 50 08             	mov    0x8(%eax),%edx
  801d33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d36:	8b 48 08             	mov    0x8(%eax),%ecx
  801d39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d3c:	8b 40 0c             	mov    0xc(%eax),%eax
  801d3f:	01 c8                	add    %ecx,%eax
  801d41:	39 c2                	cmp    %eax,%edx
  801d43:	73 04                	jae    801d49 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801d45:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801d49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d4c:	8b 50 08             	mov    0x8(%eax),%edx
  801d4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d52:	8b 40 0c             	mov    0xc(%eax),%eax
  801d55:	01 c2                	add    %eax,%edx
  801d57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d5a:	8b 40 08             	mov    0x8(%eax),%eax
  801d5d:	83 ec 04             	sub    $0x4,%esp
  801d60:	52                   	push   %edx
  801d61:	50                   	push   %eax
  801d62:	68 11 3f 80 00       	push   $0x803f11
  801d67:	e8 fe e7 ff ff       	call   80056a <cprintf>
  801d6c:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801d6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d72:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d75:	a1 40 51 80 00       	mov    0x805140,%eax
  801d7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d7d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d81:	74 07                	je     801d8a <print_mem_block_lists+0x9e>
  801d83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d86:	8b 00                	mov    (%eax),%eax
  801d88:	eb 05                	jmp    801d8f <print_mem_block_lists+0xa3>
  801d8a:	b8 00 00 00 00       	mov    $0x0,%eax
  801d8f:	a3 40 51 80 00       	mov    %eax,0x805140
  801d94:	a1 40 51 80 00       	mov    0x805140,%eax
  801d99:	85 c0                	test   %eax,%eax
  801d9b:	75 8a                	jne    801d27 <print_mem_block_lists+0x3b>
  801d9d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801da1:	75 84                	jne    801d27 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801da3:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801da7:	75 10                	jne    801db9 <print_mem_block_lists+0xcd>
  801da9:	83 ec 0c             	sub    $0xc,%esp
  801dac:	68 20 3f 80 00       	push   $0x803f20
  801db1:	e8 b4 e7 ff ff       	call   80056a <cprintf>
  801db6:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801db9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801dc0:	83 ec 0c             	sub    $0xc,%esp
  801dc3:	68 44 3f 80 00       	push   $0x803f44
  801dc8:	e8 9d e7 ff ff       	call   80056a <cprintf>
  801dcd:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801dd0:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801dd4:	a1 40 50 80 00       	mov    0x805040,%eax
  801dd9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ddc:	eb 56                	jmp    801e34 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801dde:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801de2:	74 1c                	je     801e00 <print_mem_block_lists+0x114>
  801de4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801de7:	8b 50 08             	mov    0x8(%eax),%edx
  801dea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ded:	8b 48 08             	mov    0x8(%eax),%ecx
  801df0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801df3:	8b 40 0c             	mov    0xc(%eax),%eax
  801df6:	01 c8                	add    %ecx,%eax
  801df8:	39 c2                	cmp    %eax,%edx
  801dfa:	73 04                	jae    801e00 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801dfc:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e03:	8b 50 08             	mov    0x8(%eax),%edx
  801e06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e09:	8b 40 0c             	mov    0xc(%eax),%eax
  801e0c:	01 c2                	add    %eax,%edx
  801e0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e11:	8b 40 08             	mov    0x8(%eax),%eax
  801e14:	83 ec 04             	sub    $0x4,%esp
  801e17:	52                   	push   %edx
  801e18:	50                   	push   %eax
  801e19:	68 11 3f 80 00       	push   $0x803f11
  801e1e:	e8 47 e7 ff ff       	call   80056a <cprintf>
  801e23:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e29:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801e2c:	a1 48 50 80 00       	mov    0x805048,%eax
  801e31:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e34:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e38:	74 07                	je     801e41 <print_mem_block_lists+0x155>
  801e3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e3d:	8b 00                	mov    (%eax),%eax
  801e3f:	eb 05                	jmp    801e46 <print_mem_block_lists+0x15a>
  801e41:	b8 00 00 00 00       	mov    $0x0,%eax
  801e46:	a3 48 50 80 00       	mov    %eax,0x805048
  801e4b:	a1 48 50 80 00       	mov    0x805048,%eax
  801e50:	85 c0                	test   %eax,%eax
  801e52:	75 8a                	jne    801dde <print_mem_block_lists+0xf2>
  801e54:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e58:	75 84                	jne    801dde <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801e5a:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e5e:	75 10                	jne    801e70 <print_mem_block_lists+0x184>
  801e60:	83 ec 0c             	sub    $0xc,%esp
  801e63:	68 5c 3f 80 00       	push   $0x803f5c
  801e68:	e8 fd e6 ff ff       	call   80056a <cprintf>
  801e6d:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801e70:	83 ec 0c             	sub    $0xc,%esp
  801e73:	68 d0 3e 80 00       	push   $0x803ed0
  801e78:	e8 ed e6 ff ff       	call   80056a <cprintf>
  801e7d:	83 c4 10             	add    $0x10,%esp

}
  801e80:	90                   	nop
  801e81:	c9                   	leave  
  801e82:	c3                   	ret    

00801e83 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801e83:	55                   	push   %ebp
  801e84:	89 e5                	mov    %esp,%ebp
  801e86:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801e89:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  801e90:	00 00 00 
  801e93:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  801e9a:	00 00 00 
  801e9d:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  801ea4:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801ea7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801eae:	e9 9e 00 00 00       	jmp    801f51 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801eb3:	a1 50 50 80 00       	mov    0x805050,%eax
  801eb8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ebb:	c1 e2 04             	shl    $0x4,%edx
  801ebe:	01 d0                	add    %edx,%eax
  801ec0:	85 c0                	test   %eax,%eax
  801ec2:	75 14                	jne    801ed8 <initialize_MemBlocksList+0x55>
  801ec4:	83 ec 04             	sub    $0x4,%esp
  801ec7:	68 84 3f 80 00       	push   $0x803f84
  801ecc:	6a 46                	push   $0x46
  801ece:	68 a7 3f 80 00       	push   $0x803fa7
  801ed3:	e8 de e3 ff ff       	call   8002b6 <_panic>
  801ed8:	a1 50 50 80 00       	mov    0x805050,%eax
  801edd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ee0:	c1 e2 04             	shl    $0x4,%edx
  801ee3:	01 d0                	add    %edx,%eax
  801ee5:	8b 15 48 51 80 00    	mov    0x805148,%edx
  801eeb:	89 10                	mov    %edx,(%eax)
  801eed:	8b 00                	mov    (%eax),%eax
  801eef:	85 c0                	test   %eax,%eax
  801ef1:	74 18                	je     801f0b <initialize_MemBlocksList+0x88>
  801ef3:	a1 48 51 80 00       	mov    0x805148,%eax
  801ef8:	8b 15 50 50 80 00    	mov    0x805050,%edx
  801efe:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801f01:	c1 e1 04             	shl    $0x4,%ecx
  801f04:	01 ca                	add    %ecx,%edx
  801f06:	89 50 04             	mov    %edx,0x4(%eax)
  801f09:	eb 12                	jmp    801f1d <initialize_MemBlocksList+0x9a>
  801f0b:	a1 50 50 80 00       	mov    0x805050,%eax
  801f10:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f13:	c1 e2 04             	shl    $0x4,%edx
  801f16:	01 d0                	add    %edx,%eax
  801f18:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801f1d:	a1 50 50 80 00       	mov    0x805050,%eax
  801f22:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f25:	c1 e2 04             	shl    $0x4,%edx
  801f28:	01 d0                	add    %edx,%eax
  801f2a:	a3 48 51 80 00       	mov    %eax,0x805148
  801f2f:	a1 50 50 80 00       	mov    0x805050,%eax
  801f34:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f37:	c1 e2 04             	shl    $0x4,%edx
  801f3a:	01 d0                	add    %edx,%eax
  801f3c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f43:	a1 54 51 80 00       	mov    0x805154,%eax
  801f48:	40                   	inc    %eax
  801f49:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801f4e:	ff 45 f4             	incl   -0xc(%ebp)
  801f51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f54:	3b 45 08             	cmp    0x8(%ebp),%eax
  801f57:	0f 82 56 ff ff ff    	jb     801eb3 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801f5d:	90                   	nop
  801f5e:	c9                   	leave  
  801f5f:	c3                   	ret    

00801f60 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801f60:	55                   	push   %ebp
  801f61:	89 e5                	mov    %esp,%ebp
  801f63:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801f66:	8b 45 08             	mov    0x8(%ebp),%eax
  801f69:	8b 00                	mov    (%eax),%eax
  801f6b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f6e:	eb 19                	jmp    801f89 <find_block+0x29>
	{
		if(va==point->sva)
  801f70:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f73:	8b 40 08             	mov    0x8(%eax),%eax
  801f76:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801f79:	75 05                	jne    801f80 <find_block+0x20>
		   return point;
  801f7b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f7e:	eb 36                	jmp    801fb6 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801f80:	8b 45 08             	mov    0x8(%ebp),%eax
  801f83:	8b 40 08             	mov    0x8(%eax),%eax
  801f86:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f89:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f8d:	74 07                	je     801f96 <find_block+0x36>
  801f8f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f92:	8b 00                	mov    (%eax),%eax
  801f94:	eb 05                	jmp    801f9b <find_block+0x3b>
  801f96:	b8 00 00 00 00       	mov    $0x0,%eax
  801f9b:	8b 55 08             	mov    0x8(%ebp),%edx
  801f9e:	89 42 08             	mov    %eax,0x8(%edx)
  801fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa4:	8b 40 08             	mov    0x8(%eax),%eax
  801fa7:	85 c0                	test   %eax,%eax
  801fa9:	75 c5                	jne    801f70 <find_block+0x10>
  801fab:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801faf:	75 bf                	jne    801f70 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  801fb1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fb6:	c9                   	leave  
  801fb7:	c3                   	ret    

00801fb8 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  801fb8:	55                   	push   %ebp
  801fb9:	89 e5                	mov    %esp,%ebp
  801fbb:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  801fbe:	a1 40 50 80 00       	mov    0x805040,%eax
  801fc3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  801fc6:	a1 44 50 80 00       	mov    0x805044,%eax
  801fcb:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  801fce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fd1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801fd4:	74 24                	je     801ffa <insert_sorted_allocList+0x42>
  801fd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd9:	8b 50 08             	mov    0x8(%eax),%edx
  801fdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fdf:	8b 40 08             	mov    0x8(%eax),%eax
  801fe2:	39 c2                	cmp    %eax,%edx
  801fe4:	76 14                	jbe    801ffa <insert_sorted_allocList+0x42>
  801fe6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe9:	8b 50 08             	mov    0x8(%eax),%edx
  801fec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fef:	8b 40 08             	mov    0x8(%eax),%eax
  801ff2:	39 c2                	cmp    %eax,%edx
  801ff4:	0f 82 60 01 00 00    	jb     80215a <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  801ffa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ffe:	75 65                	jne    802065 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802000:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802004:	75 14                	jne    80201a <insert_sorted_allocList+0x62>
  802006:	83 ec 04             	sub    $0x4,%esp
  802009:	68 84 3f 80 00       	push   $0x803f84
  80200e:	6a 6b                	push   $0x6b
  802010:	68 a7 3f 80 00       	push   $0x803fa7
  802015:	e8 9c e2 ff ff       	call   8002b6 <_panic>
  80201a:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802020:	8b 45 08             	mov    0x8(%ebp),%eax
  802023:	89 10                	mov    %edx,(%eax)
  802025:	8b 45 08             	mov    0x8(%ebp),%eax
  802028:	8b 00                	mov    (%eax),%eax
  80202a:	85 c0                	test   %eax,%eax
  80202c:	74 0d                	je     80203b <insert_sorted_allocList+0x83>
  80202e:	a1 40 50 80 00       	mov    0x805040,%eax
  802033:	8b 55 08             	mov    0x8(%ebp),%edx
  802036:	89 50 04             	mov    %edx,0x4(%eax)
  802039:	eb 08                	jmp    802043 <insert_sorted_allocList+0x8b>
  80203b:	8b 45 08             	mov    0x8(%ebp),%eax
  80203e:	a3 44 50 80 00       	mov    %eax,0x805044
  802043:	8b 45 08             	mov    0x8(%ebp),%eax
  802046:	a3 40 50 80 00       	mov    %eax,0x805040
  80204b:	8b 45 08             	mov    0x8(%ebp),%eax
  80204e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802055:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80205a:	40                   	inc    %eax
  80205b:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802060:	e9 dc 01 00 00       	jmp    802241 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802065:	8b 45 08             	mov    0x8(%ebp),%eax
  802068:	8b 50 08             	mov    0x8(%eax),%edx
  80206b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80206e:	8b 40 08             	mov    0x8(%eax),%eax
  802071:	39 c2                	cmp    %eax,%edx
  802073:	77 6c                	ja     8020e1 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802075:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802079:	74 06                	je     802081 <insert_sorted_allocList+0xc9>
  80207b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80207f:	75 14                	jne    802095 <insert_sorted_allocList+0xdd>
  802081:	83 ec 04             	sub    $0x4,%esp
  802084:	68 c0 3f 80 00       	push   $0x803fc0
  802089:	6a 6f                	push   $0x6f
  80208b:	68 a7 3f 80 00       	push   $0x803fa7
  802090:	e8 21 e2 ff ff       	call   8002b6 <_panic>
  802095:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802098:	8b 50 04             	mov    0x4(%eax),%edx
  80209b:	8b 45 08             	mov    0x8(%ebp),%eax
  80209e:	89 50 04             	mov    %edx,0x4(%eax)
  8020a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8020a7:	89 10                	mov    %edx,(%eax)
  8020a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020ac:	8b 40 04             	mov    0x4(%eax),%eax
  8020af:	85 c0                	test   %eax,%eax
  8020b1:	74 0d                	je     8020c0 <insert_sorted_allocList+0x108>
  8020b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020b6:	8b 40 04             	mov    0x4(%eax),%eax
  8020b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8020bc:	89 10                	mov    %edx,(%eax)
  8020be:	eb 08                	jmp    8020c8 <insert_sorted_allocList+0x110>
  8020c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c3:	a3 40 50 80 00       	mov    %eax,0x805040
  8020c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8020ce:	89 50 04             	mov    %edx,0x4(%eax)
  8020d1:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8020d6:	40                   	inc    %eax
  8020d7:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8020dc:	e9 60 01 00 00       	jmp    802241 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8020e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e4:	8b 50 08             	mov    0x8(%eax),%edx
  8020e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020ea:	8b 40 08             	mov    0x8(%eax),%eax
  8020ed:	39 c2                	cmp    %eax,%edx
  8020ef:	0f 82 4c 01 00 00    	jb     802241 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8020f5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020f9:	75 14                	jne    80210f <insert_sorted_allocList+0x157>
  8020fb:	83 ec 04             	sub    $0x4,%esp
  8020fe:	68 f8 3f 80 00       	push   $0x803ff8
  802103:	6a 73                	push   $0x73
  802105:	68 a7 3f 80 00       	push   $0x803fa7
  80210a:	e8 a7 e1 ff ff       	call   8002b6 <_panic>
  80210f:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802115:	8b 45 08             	mov    0x8(%ebp),%eax
  802118:	89 50 04             	mov    %edx,0x4(%eax)
  80211b:	8b 45 08             	mov    0x8(%ebp),%eax
  80211e:	8b 40 04             	mov    0x4(%eax),%eax
  802121:	85 c0                	test   %eax,%eax
  802123:	74 0c                	je     802131 <insert_sorted_allocList+0x179>
  802125:	a1 44 50 80 00       	mov    0x805044,%eax
  80212a:	8b 55 08             	mov    0x8(%ebp),%edx
  80212d:	89 10                	mov    %edx,(%eax)
  80212f:	eb 08                	jmp    802139 <insert_sorted_allocList+0x181>
  802131:	8b 45 08             	mov    0x8(%ebp),%eax
  802134:	a3 40 50 80 00       	mov    %eax,0x805040
  802139:	8b 45 08             	mov    0x8(%ebp),%eax
  80213c:	a3 44 50 80 00       	mov    %eax,0x805044
  802141:	8b 45 08             	mov    0x8(%ebp),%eax
  802144:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80214a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80214f:	40                   	inc    %eax
  802150:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802155:	e9 e7 00 00 00       	jmp    802241 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  80215a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80215d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802160:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802167:	a1 40 50 80 00       	mov    0x805040,%eax
  80216c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80216f:	e9 9d 00 00 00       	jmp    802211 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802174:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802177:	8b 00                	mov    (%eax),%eax
  802179:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  80217c:	8b 45 08             	mov    0x8(%ebp),%eax
  80217f:	8b 50 08             	mov    0x8(%eax),%edx
  802182:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802185:	8b 40 08             	mov    0x8(%eax),%eax
  802188:	39 c2                	cmp    %eax,%edx
  80218a:	76 7d                	jbe    802209 <insert_sorted_allocList+0x251>
  80218c:	8b 45 08             	mov    0x8(%ebp),%eax
  80218f:	8b 50 08             	mov    0x8(%eax),%edx
  802192:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802195:	8b 40 08             	mov    0x8(%eax),%eax
  802198:	39 c2                	cmp    %eax,%edx
  80219a:	73 6d                	jae    802209 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  80219c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021a0:	74 06                	je     8021a8 <insert_sorted_allocList+0x1f0>
  8021a2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021a6:	75 14                	jne    8021bc <insert_sorted_allocList+0x204>
  8021a8:	83 ec 04             	sub    $0x4,%esp
  8021ab:	68 1c 40 80 00       	push   $0x80401c
  8021b0:	6a 7f                	push   $0x7f
  8021b2:	68 a7 3f 80 00       	push   $0x803fa7
  8021b7:	e8 fa e0 ff ff       	call   8002b6 <_panic>
  8021bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021bf:	8b 10                	mov    (%eax),%edx
  8021c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c4:	89 10                	mov    %edx,(%eax)
  8021c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c9:	8b 00                	mov    (%eax),%eax
  8021cb:	85 c0                	test   %eax,%eax
  8021cd:	74 0b                	je     8021da <insert_sorted_allocList+0x222>
  8021cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d2:	8b 00                	mov    (%eax),%eax
  8021d4:	8b 55 08             	mov    0x8(%ebp),%edx
  8021d7:	89 50 04             	mov    %edx,0x4(%eax)
  8021da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8021e0:	89 10                	mov    %edx,(%eax)
  8021e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021e8:	89 50 04             	mov    %edx,0x4(%eax)
  8021eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ee:	8b 00                	mov    (%eax),%eax
  8021f0:	85 c0                	test   %eax,%eax
  8021f2:	75 08                	jne    8021fc <insert_sorted_allocList+0x244>
  8021f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f7:	a3 44 50 80 00       	mov    %eax,0x805044
  8021fc:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802201:	40                   	inc    %eax
  802202:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802207:	eb 39                	jmp    802242 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802209:	a1 48 50 80 00       	mov    0x805048,%eax
  80220e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802211:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802215:	74 07                	je     80221e <insert_sorted_allocList+0x266>
  802217:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80221a:	8b 00                	mov    (%eax),%eax
  80221c:	eb 05                	jmp    802223 <insert_sorted_allocList+0x26b>
  80221e:	b8 00 00 00 00       	mov    $0x0,%eax
  802223:	a3 48 50 80 00       	mov    %eax,0x805048
  802228:	a1 48 50 80 00       	mov    0x805048,%eax
  80222d:	85 c0                	test   %eax,%eax
  80222f:	0f 85 3f ff ff ff    	jne    802174 <insert_sorted_allocList+0x1bc>
  802235:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802239:	0f 85 35 ff ff ff    	jne    802174 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80223f:	eb 01                	jmp    802242 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802241:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802242:	90                   	nop
  802243:	c9                   	leave  
  802244:	c3                   	ret    

00802245 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802245:	55                   	push   %ebp
  802246:	89 e5                	mov    %esp,%ebp
  802248:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80224b:	a1 38 51 80 00       	mov    0x805138,%eax
  802250:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802253:	e9 85 01 00 00       	jmp    8023dd <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802258:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225b:	8b 40 0c             	mov    0xc(%eax),%eax
  80225e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802261:	0f 82 6e 01 00 00    	jb     8023d5 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802267:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226a:	8b 40 0c             	mov    0xc(%eax),%eax
  80226d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802270:	0f 85 8a 00 00 00    	jne    802300 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802276:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80227a:	75 17                	jne    802293 <alloc_block_FF+0x4e>
  80227c:	83 ec 04             	sub    $0x4,%esp
  80227f:	68 50 40 80 00       	push   $0x804050
  802284:	68 93 00 00 00       	push   $0x93
  802289:	68 a7 3f 80 00       	push   $0x803fa7
  80228e:	e8 23 e0 ff ff       	call   8002b6 <_panic>
  802293:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802296:	8b 00                	mov    (%eax),%eax
  802298:	85 c0                	test   %eax,%eax
  80229a:	74 10                	je     8022ac <alloc_block_FF+0x67>
  80229c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229f:	8b 00                	mov    (%eax),%eax
  8022a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022a4:	8b 52 04             	mov    0x4(%edx),%edx
  8022a7:	89 50 04             	mov    %edx,0x4(%eax)
  8022aa:	eb 0b                	jmp    8022b7 <alloc_block_FF+0x72>
  8022ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022af:	8b 40 04             	mov    0x4(%eax),%eax
  8022b2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8022b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ba:	8b 40 04             	mov    0x4(%eax),%eax
  8022bd:	85 c0                	test   %eax,%eax
  8022bf:	74 0f                	je     8022d0 <alloc_block_FF+0x8b>
  8022c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c4:	8b 40 04             	mov    0x4(%eax),%eax
  8022c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022ca:	8b 12                	mov    (%edx),%edx
  8022cc:	89 10                	mov    %edx,(%eax)
  8022ce:	eb 0a                	jmp    8022da <alloc_block_FF+0x95>
  8022d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d3:	8b 00                	mov    (%eax),%eax
  8022d5:	a3 38 51 80 00       	mov    %eax,0x805138
  8022da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022ed:	a1 44 51 80 00       	mov    0x805144,%eax
  8022f2:	48                   	dec    %eax
  8022f3:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  8022f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022fb:	e9 10 01 00 00       	jmp    802410 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802300:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802303:	8b 40 0c             	mov    0xc(%eax),%eax
  802306:	3b 45 08             	cmp    0x8(%ebp),%eax
  802309:	0f 86 c6 00 00 00    	jbe    8023d5 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80230f:	a1 48 51 80 00       	mov    0x805148,%eax
  802314:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802317:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231a:	8b 50 08             	mov    0x8(%eax),%edx
  80231d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802320:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802323:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802326:	8b 55 08             	mov    0x8(%ebp),%edx
  802329:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80232c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802330:	75 17                	jne    802349 <alloc_block_FF+0x104>
  802332:	83 ec 04             	sub    $0x4,%esp
  802335:	68 50 40 80 00       	push   $0x804050
  80233a:	68 9b 00 00 00       	push   $0x9b
  80233f:	68 a7 3f 80 00       	push   $0x803fa7
  802344:	e8 6d df ff ff       	call   8002b6 <_panic>
  802349:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80234c:	8b 00                	mov    (%eax),%eax
  80234e:	85 c0                	test   %eax,%eax
  802350:	74 10                	je     802362 <alloc_block_FF+0x11d>
  802352:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802355:	8b 00                	mov    (%eax),%eax
  802357:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80235a:	8b 52 04             	mov    0x4(%edx),%edx
  80235d:	89 50 04             	mov    %edx,0x4(%eax)
  802360:	eb 0b                	jmp    80236d <alloc_block_FF+0x128>
  802362:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802365:	8b 40 04             	mov    0x4(%eax),%eax
  802368:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80236d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802370:	8b 40 04             	mov    0x4(%eax),%eax
  802373:	85 c0                	test   %eax,%eax
  802375:	74 0f                	je     802386 <alloc_block_FF+0x141>
  802377:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80237a:	8b 40 04             	mov    0x4(%eax),%eax
  80237d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802380:	8b 12                	mov    (%edx),%edx
  802382:	89 10                	mov    %edx,(%eax)
  802384:	eb 0a                	jmp    802390 <alloc_block_FF+0x14b>
  802386:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802389:	8b 00                	mov    (%eax),%eax
  80238b:	a3 48 51 80 00       	mov    %eax,0x805148
  802390:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802393:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802399:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80239c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023a3:	a1 54 51 80 00       	mov    0x805154,%eax
  8023a8:	48                   	dec    %eax
  8023a9:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  8023ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b1:	8b 50 08             	mov    0x8(%eax),%edx
  8023b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b7:	01 c2                	add    %eax,%edx
  8023b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023bc:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8023bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c2:	8b 40 0c             	mov    0xc(%eax),%eax
  8023c5:	2b 45 08             	sub    0x8(%ebp),%eax
  8023c8:	89 c2                	mov    %eax,%edx
  8023ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cd:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8023d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023d3:	eb 3b                	jmp    802410 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8023d5:	a1 40 51 80 00       	mov    0x805140,%eax
  8023da:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023e1:	74 07                	je     8023ea <alloc_block_FF+0x1a5>
  8023e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e6:	8b 00                	mov    (%eax),%eax
  8023e8:	eb 05                	jmp    8023ef <alloc_block_FF+0x1aa>
  8023ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8023ef:	a3 40 51 80 00       	mov    %eax,0x805140
  8023f4:	a1 40 51 80 00       	mov    0x805140,%eax
  8023f9:	85 c0                	test   %eax,%eax
  8023fb:	0f 85 57 fe ff ff    	jne    802258 <alloc_block_FF+0x13>
  802401:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802405:	0f 85 4d fe ff ff    	jne    802258 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  80240b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802410:	c9                   	leave  
  802411:	c3                   	ret    

00802412 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802412:	55                   	push   %ebp
  802413:	89 e5                	mov    %esp,%ebp
  802415:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802418:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80241f:	a1 38 51 80 00       	mov    0x805138,%eax
  802424:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802427:	e9 df 00 00 00       	jmp    80250b <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  80242c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242f:	8b 40 0c             	mov    0xc(%eax),%eax
  802432:	3b 45 08             	cmp    0x8(%ebp),%eax
  802435:	0f 82 c8 00 00 00    	jb     802503 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  80243b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243e:	8b 40 0c             	mov    0xc(%eax),%eax
  802441:	3b 45 08             	cmp    0x8(%ebp),%eax
  802444:	0f 85 8a 00 00 00    	jne    8024d4 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  80244a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80244e:	75 17                	jne    802467 <alloc_block_BF+0x55>
  802450:	83 ec 04             	sub    $0x4,%esp
  802453:	68 50 40 80 00       	push   $0x804050
  802458:	68 b7 00 00 00       	push   $0xb7
  80245d:	68 a7 3f 80 00       	push   $0x803fa7
  802462:	e8 4f de ff ff       	call   8002b6 <_panic>
  802467:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246a:	8b 00                	mov    (%eax),%eax
  80246c:	85 c0                	test   %eax,%eax
  80246e:	74 10                	je     802480 <alloc_block_BF+0x6e>
  802470:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802473:	8b 00                	mov    (%eax),%eax
  802475:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802478:	8b 52 04             	mov    0x4(%edx),%edx
  80247b:	89 50 04             	mov    %edx,0x4(%eax)
  80247e:	eb 0b                	jmp    80248b <alloc_block_BF+0x79>
  802480:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802483:	8b 40 04             	mov    0x4(%eax),%eax
  802486:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80248b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248e:	8b 40 04             	mov    0x4(%eax),%eax
  802491:	85 c0                	test   %eax,%eax
  802493:	74 0f                	je     8024a4 <alloc_block_BF+0x92>
  802495:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802498:	8b 40 04             	mov    0x4(%eax),%eax
  80249b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80249e:	8b 12                	mov    (%edx),%edx
  8024a0:	89 10                	mov    %edx,(%eax)
  8024a2:	eb 0a                	jmp    8024ae <alloc_block_BF+0x9c>
  8024a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a7:	8b 00                	mov    (%eax),%eax
  8024a9:	a3 38 51 80 00       	mov    %eax,0x805138
  8024ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024c1:	a1 44 51 80 00       	mov    0x805144,%eax
  8024c6:	48                   	dec    %eax
  8024c7:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  8024cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cf:	e9 4d 01 00 00       	jmp    802621 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8024d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d7:	8b 40 0c             	mov    0xc(%eax),%eax
  8024da:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024dd:	76 24                	jbe    802503 <alloc_block_BF+0xf1>
  8024df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8024e5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8024e8:	73 19                	jae    802503 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8024ea:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8024f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f4:	8b 40 0c             	mov    0xc(%eax),%eax
  8024f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8024fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fd:	8b 40 08             	mov    0x8(%eax),%eax
  802500:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802503:	a1 40 51 80 00       	mov    0x805140,%eax
  802508:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80250b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80250f:	74 07                	je     802518 <alloc_block_BF+0x106>
  802511:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802514:	8b 00                	mov    (%eax),%eax
  802516:	eb 05                	jmp    80251d <alloc_block_BF+0x10b>
  802518:	b8 00 00 00 00       	mov    $0x0,%eax
  80251d:	a3 40 51 80 00       	mov    %eax,0x805140
  802522:	a1 40 51 80 00       	mov    0x805140,%eax
  802527:	85 c0                	test   %eax,%eax
  802529:	0f 85 fd fe ff ff    	jne    80242c <alloc_block_BF+0x1a>
  80252f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802533:	0f 85 f3 fe ff ff    	jne    80242c <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802539:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80253d:	0f 84 d9 00 00 00    	je     80261c <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802543:	a1 48 51 80 00       	mov    0x805148,%eax
  802548:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  80254b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80254e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802551:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802554:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802557:	8b 55 08             	mov    0x8(%ebp),%edx
  80255a:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  80255d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802561:	75 17                	jne    80257a <alloc_block_BF+0x168>
  802563:	83 ec 04             	sub    $0x4,%esp
  802566:	68 50 40 80 00       	push   $0x804050
  80256b:	68 c7 00 00 00       	push   $0xc7
  802570:	68 a7 3f 80 00       	push   $0x803fa7
  802575:	e8 3c dd ff ff       	call   8002b6 <_panic>
  80257a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80257d:	8b 00                	mov    (%eax),%eax
  80257f:	85 c0                	test   %eax,%eax
  802581:	74 10                	je     802593 <alloc_block_BF+0x181>
  802583:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802586:	8b 00                	mov    (%eax),%eax
  802588:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80258b:	8b 52 04             	mov    0x4(%edx),%edx
  80258e:	89 50 04             	mov    %edx,0x4(%eax)
  802591:	eb 0b                	jmp    80259e <alloc_block_BF+0x18c>
  802593:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802596:	8b 40 04             	mov    0x4(%eax),%eax
  802599:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80259e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025a1:	8b 40 04             	mov    0x4(%eax),%eax
  8025a4:	85 c0                	test   %eax,%eax
  8025a6:	74 0f                	je     8025b7 <alloc_block_BF+0x1a5>
  8025a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025ab:	8b 40 04             	mov    0x4(%eax),%eax
  8025ae:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025b1:	8b 12                	mov    (%edx),%edx
  8025b3:	89 10                	mov    %edx,(%eax)
  8025b5:	eb 0a                	jmp    8025c1 <alloc_block_BF+0x1af>
  8025b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025ba:	8b 00                	mov    (%eax),%eax
  8025bc:	a3 48 51 80 00       	mov    %eax,0x805148
  8025c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025c4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025cd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025d4:	a1 54 51 80 00       	mov    0x805154,%eax
  8025d9:	48                   	dec    %eax
  8025da:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8025df:	83 ec 08             	sub    $0x8,%esp
  8025e2:	ff 75 ec             	pushl  -0x14(%ebp)
  8025e5:	68 38 51 80 00       	push   $0x805138
  8025ea:	e8 71 f9 ff ff       	call   801f60 <find_block>
  8025ef:	83 c4 10             	add    $0x10,%esp
  8025f2:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8025f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025f8:	8b 50 08             	mov    0x8(%eax),%edx
  8025fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8025fe:	01 c2                	add    %eax,%edx
  802600:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802603:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802606:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802609:	8b 40 0c             	mov    0xc(%eax),%eax
  80260c:	2b 45 08             	sub    0x8(%ebp),%eax
  80260f:	89 c2                	mov    %eax,%edx
  802611:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802614:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802617:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80261a:	eb 05                	jmp    802621 <alloc_block_BF+0x20f>
	}
	return NULL;
  80261c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802621:	c9                   	leave  
  802622:	c3                   	ret    

00802623 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802623:	55                   	push   %ebp
  802624:	89 e5                	mov    %esp,%ebp
  802626:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802629:	a1 28 50 80 00       	mov    0x805028,%eax
  80262e:	85 c0                	test   %eax,%eax
  802630:	0f 85 de 01 00 00    	jne    802814 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802636:	a1 38 51 80 00       	mov    0x805138,%eax
  80263b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80263e:	e9 9e 01 00 00       	jmp    8027e1 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802643:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802646:	8b 40 0c             	mov    0xc(%eax),%eax
  802649:	3b 45 08             	cmp    0x8(%ebp),%eax
  80264c:	0f 82 87 01 00 00    	jb     8027d9 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802652:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802655:	8b 40 0c             	mov    0xc(%eax),%eax
  802658:	3b 45 08             	cmp    0x8(%ebp),%eax
  80265b:	0f 85 95 00 00 00    	jne    8026f6 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802661:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802665:	75 17                	jne    80267e <alloc_block_NF+0x5b>
  802667:	83 ec 04             	sub    $0x4,%esp
  80266a:	68 50 40 80 00       	push   $0x804050
  80266f:	68 e0 00 00 00       	push   $0xe0
  802674:	68 a7 3f 80 00       	push   $0x803fa7
  802679:	e8 38 dc ff ff       	call   8002b6 <_panic>
  80267e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802681:	8b 00                	mov    (%eax),%eax
  802683:	85 c0                	test   %eax,%eax
  802685:	74 10                	je     802697 <alloc_block_NF+0x74>
  802687:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268a:	8b 00                	mov    (%eax),%eax
  80268c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80268f:	8b 52 04             	mov    0x4(%edx),%edx
  802692:	89 50 04             	mov    %edx,0x4(%eax)
  802695:	eb 0b                	jmp    8026a2 <alloc_block_NF+0x7f>
  802697:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269a:	8b 40 04             	mov    0x4(%eax),%eax
  80269d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8026a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a5:	8b 40 04             	mov    0x4(%eax),%eax
  8026a8:	85 c0                	test   %eax,%eax
  8026aa:	74 0f                	je     8026bb <alloc_block_NF+0x98>
  8026ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026af:	8b 40 04             	mov    0x4(%eax),%eax
  8026b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026b5:	8b 12                	mov    (%edx),%edx
  8026b7:	89 10                	mov    %edx,(%eax)
  8026b9:	eb 0a                	jmp    8026c5 <alloc_block_NF+0xa2>
  8026bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026be:	8b 00                	mov    (%eax),%eax
  8026c0:	a3 38 51 80 00       	mov    %eax,0x805138
  8026c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026d8:	a1 44 51 80 00       	mov    0x805144,%eax
  8026dd:	48                   	dec    %eax
  8026de:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  8026e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e6:	8b 40 08             	mov    0x8(%eax),%eax
  8026e9:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  8026ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f1:	e9 f8 04 00 00       	jmp    802bee <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8026f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f9:	8b 40 0c             	mov    0xc(%eax),%eax
  8026fc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026ff:	0f 86 d4 00 00 00    	jbe    8027d9 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802705:	a1 48 51 80 00       	mov    0x805148,%eax
  80270a:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  80270d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802710:	8b 50 08             	mov    0x8(%eax),%edx
  802713:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802716:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802719:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80271c:	8b 55 08             	mov    0x8(%ebp),%edx
  80271f:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802722:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802726:	75 17                	jne    80273f <alloc_block_NF+0x11c>
  802728:	83 ec 04             	sub    $0x4,%esp
  80272b:	68 50 40 80 00       	push   $0x804050
  802730:	68 e9 00 00 00       	push   $0xe9
  802735:	68 a7 3f 80 00       	push   $0x803fa7
  80273a:	e8 77 db ff ff       	call   8002b6 <_panic>
  80273f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802742:	8b 00                	mov    (%eax),%eax
  802744:	85 c0                	test   %eax,%eax
  802746:	74 10                	je     802758 <alloc_block_NF+0x135>
  802748:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80274b:	8b 00                	mov    (%eax),%eax
  80274d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802750:	8b 52 04             	mov    0x4(%edx),%edx
  802753:	89 50 04             	mov    %edx,0x4(%eax)
  802756:	eb 0b                	jmp    802763 <alloc_block_NF+0x140>
  802758:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80275b:	8b 40 04             	mov    0x4(%eax),%eax
  80275e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802763:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802766:	8b 40 04             	mov    0x4(%eax),%eax
  802769:	85 c0                	test   %eax,%eax
  80276b:	74 0f                	je     80277c <alloc_block_NF+0x159>
  80276d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802770:	8b 40 04             	mov    0x4(%eax),%eax
  802773:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802776:	8b 12                	mov    (%edx),%edx
  802778:	89 10                	mov    %edx,(%eax)
  80277a:	eb 0a                	jmp    802786 <alloc_block_NF+0x163>
  80277c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80277f:	8b 00                	mov    (%eax),%eax
  802781:	a3 48 51 80 00       	mov    %eax,0x805148
  802786:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802789:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80278f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802792:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802799:	a1 54 51 80 00       	mov    0x805154,%eax
  80279e:	48                   	dec    %eax
  80279f:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  8027a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027a7:	8b 40 08             	mov    0x8(%eax),%eax
  8027aa:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  8027af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b2:	8b 50 08             	mov    0x8(%eax),%edx
  8027b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b8:	01 c2                	add    %eax,%edx
  8027ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027bd:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  8027c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c3:	8b 40 0c             	mov    0xc(%eax),%eax
  8027c6:	2b 45 08             	sub    0x8(%ebp),%eax
  8027c9:	89 c2                	mov    %eax,%edx
  8027cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ce:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8027d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027d4:	e9 15 04 00 00       	jmp    802bee <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8027d9:	a1 40 51 80 00       	mov    0x805140,%eax
  8027de:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027e5:	74 07                	je     8027ee <alloc_block_NF+0x1cb>
  8027e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ea:	8b 00                	mov    (%eax),%eax
  8027ec:	eb 05                	jmp    8027f3 <alloc_block_NF+0x1d0>
  8027ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8027f3:	a3 40 51 80 00       	mov    %eax,0x805140
  8027f8:	a1 40 51 80 00       	mov    0x805140,%eax
  8027fd:	85 c0                	test   %eax,%eax
  8027ff:	0f 85 3e fe ff ff    	jne    802643 <alloc_block_NF+0x20>
  802805:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802809:	0f 85 34 fe ff ff    	jne    802643 <alloc_block_NF+0x20>
  80280f:	e9 d5 03 00 00       	jmp    802be9 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802814:	a1 38 51 80 00       	mov    0x805138,%eax
  802819:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80281c:	e9 b1 01 00 00       	jmp    8029d2 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802821:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802824:	8b 50 08             	mov    0x8(%eax),%edx
  802827:	a1 28 50 80 00       	mov    0x805028,%eax
  80282c:	39 c2                	cmp    %eax,%edx
  80282e:	0f 82 96 01 00 00    	jb     8029ca <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802834:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802837:	8b 40 0c             	mov    0xc(%eax),%eax
  80283a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80283d:	0f 82 87 01 00 00    	jb     8029ca <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802843:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802846:	8b 40 0c             	mov    0xc(%eax),%eax
  802849:	3b 45 08             	cmp    0x8(%ebp),%eax
  80284c:	0f 85 95 00 00 00    	jne    8028e7 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802852:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802856:	75 17                	jne    80286f <alloc_block_NF+0x24c>
  802858:	83 ec 04             	sub    $0x4,%esp
  80285b:	68 50 40 80 00       	push   $0x804050
  802860:	68 fc 00 00 00       	push   $0xfc
  802865:	68 a7 3f 80 00       	push   $0x803fa7
  80286a:	e8 47 da ff ff       	call   8002b6 <_panic>
  80286f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802872:	8b 00                	mov    (%eax),%eax
  802874:	85 c0                	test   %eax,%eax
  802876:	74 10                	je     802888 <alloc_block_NF+0x265>
  802878:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287b:	8b 00                	mov    (%eax),%eax
  80287d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802880:	8b 52 04             	mov    0x4(%edx),%edx
  802883:	89 50 04             	mov    %edx,0x4(%eax)
  802886:	eb 0b                	jmp    802893 <alloc_block_NF+0x270>
  802888:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288b:	8b 40 04             	mov    0x4(%eax),%eax
  80288e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802893:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802896:	8b 40 04             	mov    0x4(%eax),%eax
  802899:	85 c0                	test   %eax,%eax
  80289b:	74 0f                	je     8028ac <alloc_block_NF+0x289>
  80289d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a0:	8b 40 04             	mov    0x4(%eax),%eax
  8028a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028a6:	8b 12                	mov    (%edx),%edx
  8028a8:	89 10                	mov    %edx,(%eax)
  8028aa:	eb 0a                	jmp    8028b6 <alloc_block_NF+0x293>
  8028ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028af:	8b 00                	mov    (%eax),%eax
  8028b1:	a3 38 51 80 00       	mov    %eax,0x805138
  8028b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028c9:	a1 44 51 80 00       	mov    0x805144,%eax
  8028ce:	48                   	dec    %eax
  8028cf:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8028d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d7:	8b 40 08             	mov    0x8(%eax),%eax
  8028da:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  8028df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e2:	e9 07 03 00 00       	jmp    802bee <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8028e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ea:	8b 40 0c             	mov    0xc(%eax),%eax
  8028ed:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028f0:	0f 86 d4 00 00 00    	jbe    8029ca <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8028f6:	a1 48 51 80 00       	mov    0x805148,%eax
  8028fb:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  8028fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802901:	8b 50 08             	mov    0x8(%eax),%edx
  802904:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802907:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  80290a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80290d:	8b 55 08             	mov    0x8(%ebp),%edx
  802910:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802913:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802917:	75 17                	jne    802930 <alloc_block_NF+0x30d>
  802919:	83 ec 04             	sub    $0x4,%esp
  80291c:	68 50 40 80 00       	push   $0x804050
  802921:	68 04 01 00 00       	push   $0x104
  802926:	68 a7 3f 80 00       	push   $0x803fa7
  80292b:	e8 86 d9 ff ff       	call   8002b6 <_panic>
  802930:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802933:	8b 00                	mov    (%eax),%eax
  802935:	85 c0                	test   %eax,%eax
  802937:	74 10                	je     802949 <alloc_block_NF+0x326>
  802939:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80293c:	8b 00                	mov    (%eax),%eax
  80293e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802941:	8b 52 04             	mov    0x4(%edx),%edx
  802944:	89 50 04             	mov    %edx,0x4(%eax)
  802947:	eb 0b                	jmp    802954 <alloc_block_NF+0x331>
  802949:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80294c:	8b 40 04             	mov    0x4(%eax),%eax
  80294f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802954:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802957:	8b 40 04             	mov    0x4(%eax),%eax
  80295a:	85 c0                	test   %eax,%eax
  80295c:	74 0f                	je     80296d <alloc_block_NF+0x34a>
  80295e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802961:	8b 40 04             	mov    0x4(%eax),%eax
  802964:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802967:	8b 12                	mov    (%edx),%edx
  802969:	89 10                	mov    %edx,(%eax)
  80296b:	eb 0a                	jmp    802977 <alloc_block_NF+0x354>
  80296d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802970:	8b 00                	mov    (%eax),%eax
  802972:	a3 48 51 80 00       	mov    %eax,0x805148
  802977:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80297a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802980:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802983:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80298a:	a1 54 51 80 00       	mov    0x805154,%eax
  80298f:	48                   	dec    %eax
  802990:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802995:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802998:	8b 40 08             	mov    0x8(%eax),%eax
  80299b:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  8029a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a3:	8b 50 08             	mov    0x8(%eax),%edx
  8029a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a9:	01 c2                	add    %eax,%edx
  8029ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ae:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8029b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b4:	8b 40 0c             	mov    0xc(%eax),%eax
  8029b7:	2b 45 08             	sub    0x8(%ebp),%eax
  8029ba:	89 c2                	mov    %eax,%edx
  8029bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bf:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8029c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029c5:	e9 24 02 00 00       	jmp    802bee <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8029ca:	a1 40 51 80 00       	mov    0x805140,%eax
  8029cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029d6:	74 07                	je     8029df <alloc_block_NF+0x3bc>
  8029d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029db:	8b 00                	mov    (%eax),%eax
  8029dd:	eb 05                	jmp    8029e4 <alloc_block_NF+0x3c1>
  8029df:	b8 00 00 00 00       	mov    $0x0,%eax
  8029e4:	a3 40 51 80 00       	mov    %eax,0x805140
  8029e9:	a1 40 51 80 00       	mov    0x805140,%eax
  8029ee:	85 c0                	test   %eax,%eax
  8029f0:	0f 85 2b fe ff ff    	jne    802821 <alloc_block_NF+0x1fe>
  8029f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029fa:	0f 85 21 fe ff ff    	jne    802821 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a00:	a1 38 51 80 00       	mov    0x805138,%eax
  802a05:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a08:	e9 ae 01 00 00       	jmp    802bbb <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802a0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a10:	8b 50 08             	mov    0x8(%eax),%edx
  802a13:	a1 28 50 80 00       	mov    0x805028,%eax
  802a18:	39 c2                	cmp    %eax,%edx
  802a1a:	0f 83 93 01 00 00    	jae    802bb3 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802a20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a23:	8b 40 0c             	mov    0xc(%eax),%eax
  802a26:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a29:	0f 82 84 01 00 00    	jb     802bb3 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802a2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a32:	8b 40 0c             	mov    0xc(%eax),%eax
  802a35:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a38:	0f 85 95 00 00 00    	jne    802ad3 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802a3e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a42:	75 17                	jne    802a5b <alloc_block_NF+0x438>
  802a44:	83 ec 04             	sub    $0x4,%esp
  802a47:	68 50 40 80 00       	push   $0x804050
  802a4c:	68 14 01 00 00       	push   $0x114
  802a51:	68 a7 3f 80 00       	push   $0x803fa7
  802a56:	e8 5b d8 ff ff       	call   8002b6 <_panic>
  802a5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5e:	8b 00                	mov    (%eax),%eax
  802a60:	85 c0                	test   %eax,%eax
  802a62:	74 10                	je     802a74 <alloc_block_NF+0x451>
  802a64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a67:	8b 00                	mov    (%eax),%eax
  802a69:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a6c:	8b 52 04             	mov    0x4(%edx),%edx
  802a6f:	89 50 04             	mov    %edx,0x4(%eax)
  802a72:	eb 0b                	jmp    802a7f <alloc_block_NF+0x45c>
  802a74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a77:	8b 40 04             	mov    0x4(%eax),%eax
  802a7a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a82:	8b 40 04             	mov    0x4(%eax),%eax
  802a85:	85 c0                	test   %eax,%eax
  802a87:	74 0f                	je     802a98 <alloc_block_NF+0x475>
  802a89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8c:	8b 40 04             	mov    0x4(%eax),%eax
  802a8f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a92:	8b 12                	mov    (%edx),%edx
  802a94:	89 10                	mov    %edx,(%eax)
  802a96:	eb 0a                	jmp    802aa2 <alloc_block_NF+0x47f>
  802a98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9b:	8b 00                	mov    (%eax),%eax
  802a9d:	a3 38 51 80 00       	mov    %eax,0x805138
  802aa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802aab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ab5:	a1 44 51 80 00       	mov    0x805144,%eax
  802aba:	48                   	dec    %eax
  802abb:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802ac0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac3:	8b 40 08             	mov    0x8(%eax),%eax
  802ac6:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802acb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ace:	e9 1b 01 00 00       	jmp    802bee <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802ad3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad6:	8b 40 0c             	mov    0xc(%eax),%eax
  802ad9:	3b 45 08             	cmp    0x8(%ebp),%eax
  802adc:	0f 86 d1 00 00 00    	jbe    802bb3 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802ae2:	a1 48 51 80 00       	mov    0x805148,%eax
  802ae7:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802aea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aed:	8b 50 08             	mov    0x8(%eax),%edx
  802af0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802af3:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802af6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802af9:	8b 55 08             	mov    0x8(%ebp),%edx
  802afc:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802aff:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b03:	75 17                	jne    802b1c <alloc_block_NF+0x4f9>
  802b05:	83 ec 04             	sub    $0x4,%esp
  802b08:	68 50 40 80 00       	push   $0x804050
  802b0d:	68 1c 01 00 00       	push   $0x11c
  802b12:	68 a7 3f 80 00       	push   $0x803fa7
  802b17:	e8 9a d7 ff ff       	call   8002b6 <_panic>
  802b1c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b1f:	8b 00                	mov    (%eax),%eax
  802b21:	85 c0                	test   %eax,%eax
  802b23:	74 10                	je     802b35 <alloc_block_NF+0x512>
  802b25:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b28:	8b 00                	mov    (%eax),%eax
  802b2a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b2d:	8b 52 04             	mov    0x4(%edx),%edx
  802b30:	89 50 04             	mov    %edx,0x4(%eax)
  802b33:	eb 0b                	jmp    802b40 <alloc_block_NF+0x51d>
  802b35:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b38:	8b 40 04             	mov    0x4(%eax),%eax
  802b3b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b40:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b43:	8b 40 04             	mov    0x4(%eax),%eax
  802b46:	85 c0                	test   %eax,%eax
  802b48:	74 0f                	je     802b59 <alloc_block_NF+0x536>
  802b4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b4d:	8b 40 04             	mov    0x4(%eax),%eax
  802b50:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b53:	8b 12                	mov    (%edx),%edx
  802b55:	89 10                	mov    %edx,(%eax)
  802b57:	eb 0a                	jmp    802b63 <alloc_block_NF+0x540>
  802b59:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b5c:	8b 00                	mov    (%eax),%eax
  802b5e:	a3 48 51 80 00       	mov    %eax,0x805148
  802b63:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b66:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b6f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b76:	a1 54 51 80 00       	mov    0x805154,%eax
  802b7b:	48                   	dec    %eax
  802b7c:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802b81:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b84:	8b 40 08             	mov    0x8(%eax),%eax
  802b87:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802b8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8f:	8b 50 08             	mov    0x8(%eax),%edx
  802b92:	8b 45 08             	mov    0x8(%ebp),%eax
  802b95:	01 c2                	add    %eax,%edx
  802b97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9a:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802b9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba0:	8b 40 0c             	mov    0xc(%eax),%eax
  802ba3:	2b 45 08             	sub    0x8(%ebp),%eax
  802ba6:	89 c2                	mov    %eax,%edx
  802ba8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bab:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802bae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bb1:	eb 3b                	jmp    802bee <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802bb3:	a1 40 51 80 00       	mov    0x805140,%eax
  802bb8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bbb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bbf:	74 07                	je     802bc8 <alloc_block_NF+0x5a5>
  802bc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc4:	8b 00                	mov    (%eax),%eax
  802bc6:	eb 05                	jmp    802bcd <alloc_block_NF+0x5aa>
  802bc8:	b8 00 00 00 00       	mov    $0x0,%eax
  802bcd:	a3 40 51 80 00       	mov    %eax,0x805140
  802bd2:	a1 40 51 80 00       	mov    0x805140,%eax
  802bd7:	85 c0                	test   %eax,%eax
  802bd9:	0f 85 2e fe ff ff    	jne    802a0d <alloc_block_NF+0x3ea>
  802bdf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802be3:	0f 85 24 fe ff ff    	jne    802a0d <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802be9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bee:	c9                   	leave  
  802bef:	c3                   	ret    

00802bf0 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802bf0:	55                   	push   %ebp
  802bf1:	89 e5                	mov    %esp,%ebp
  802bf3:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802bf6:	a1 38 51 80 00       	mov    0x805138,%eax
  802bfb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802bfe:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802c03:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802c06:	a1 38 51 80 00       	mov    0x805138,%eax
  802c0b:	85 c0                	test   %eax,%eax
  802c0d:	74 14                	je     802c23 <insert_sorted_with_merge_freeList+0x33>
  802c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c12:	8b 50 08             	mov    0x8(%eax),%edx
  802c15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c18:	8b 40 08             	mov    0x8(%eax),%eax
  802c1b:	39 c2                	cmp    %eax,%edx
  802c1d:	0f 87 9b 01 00 00    	ja     802dbe <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802c23:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c27:	75 17                	jne    802c40 <insert_sorted_with_merge_freeList+0x50>
  802c29:	83 ec 04             	sub    $0x4,%esp
  802c2c:	68 84 3f 80 00       	push   $0x803f84
  802c31:	68 38 01 00 00       	push   $0x138
  802c36:	68 a7 3f 80 00       	push   $0x803fa7
  802c3b:	e8 76 d6 ff ff       	call   8002b6 <_panic>
  802c40:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802c46:	8b 45 08             	mov    0x8(%ebp),%eax
  802c49:	89 10                	mov    %edx,(%eax)
  802c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4e:	8b 00                	mov    (%eax),%eax
  802c50:	85 c0                	test   %eax,%eax
  802c52:	74 0d                	je     802c61 <insert_sorted_with_merge_freeList+0x71>
  802c54:	a1 38 51 80 00       	mov    0x805138,%eax
  802c59:	8b 55 08             	mov    0x8(%ebp),%edx
  802c5c:	89 50 04             	mov    %edx,0x4(%eax)
  802c5f:	eb 08                	jmp    802c69 <insert_sorted_with_merge_freeList+0x79>
  802c61:	8b 45 08             	mov    0x8(%ebp),%eax
  802c64:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c69:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6c:	a3 38 51 80 00       	mov    %eax,0x805138
  802c71:	8b 45 08             	mov    0x8(%ebp),%eax
  802c74:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c7b:	a1 44 51 80 00       	mov    0x805144,%eax
  802c80:	40                   	inc    %eax
  802c81:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802c86:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c8a:	0f 84 a8 06 00 00    	je     803338 <insert_sorted_with_merge_freeList+0x748>
  802c90:	8b 45 08             	mov    0x8(%ebp),%eax
  802c93:	8b 50 08             	mov    0x8(%eax),%edx
  802c96:	8b 45 08             	mov    0x8(%ebp),%eax
  802c99:	8b 40 0c             	mov    0xc(%eax),%eax
  802c9c:	01 c2                	add    %eax,%edx
  802c9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ca1:	8b 40 08             	mov    0x8(%eax),%eax
  802ca4:	39 c2                	cmp    %eax,%edx
  802ca6:	0f 85 8c 06 00 00    	jne    803338 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802cac:	8b 45 08             	mov    0x8(%ebp),%eax
  802caf:	8b 50 0c             	mov    0xc(%eax),%edx
  802cb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb5:	8b 40 0c             	mov    0xc(%eax),%eax
  802cb8:	01 c2                	add    %eax,%edx
  802cba:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbd:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802cc0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cc4:	75 17                	jne    802cdd <insert_sorted_with_merge_freeList+0xed>
  802cc6:	83 ec 04             	sub    $0x4,%esp
  802cc9:	68 50 40 80 00       	push   $0x804050
  802cce:	68 3c 01 00 00       	push   $0x13c
  802cd3:	68 a7 3f 80 00       	push   $0x803fa7
  802cd8:	e8 d9 d5 ff ff       	call   8002b6 <_panic>
  802cdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ce0:	8b 00                	mov    (%eax),%eax
  802ce2:	85 c0                	test   %eax,%eax
  802ce4:	74 10                	je     802cf6 <insert_sorted_with_merge_freeList+0x106>
  802ce6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ce9:	8b 00                	mov    (%eax),%eax
  802ceb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cee:	8b 52 04             	mov    0x4(%edx),%edx
  802cf1:	89 50 04             	mov    %edx,0x4(%eax)
  802cf4:	eb 0b                	jmp    802d01 <insert_sorted_with_merge_freeList+0x111>
  802cf6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf9:	8b 40 04             	mov    0x4(%eax),%eax
  802cfc:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d04:	8b 40 04             	mov    0x4(%eax),%eax
  802d07:	85 c0                	test   %eax,%eax
  802d09:	74 0f                	je     802d1a <insert_sorted_with_merge_freeList+0x12a>
  802d0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d0e:	8b 40 04             	mov    0x4(%eax),%eax
  802d11:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d14:	8b 12                	mov    (%edx),%edx
  802d16:	89 10                	mov    %edx,(%eax)
  802d18:	eb 0a                	jmp    802d24 <insert_sorted_with_merge_freeList+0x134>
  802d1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d1d:	8b 00                	mov    (%eax),%eax
  802d1f:	a3 38 51 80 00       	mov    %eax,0x805138
  802d24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d27:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d30:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d37:	a1 44 51 80 00       	mov    0x805144,%eax
  802d3c:	48                   	dec    %eax
  802d3d:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802d42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d45:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802d4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d4f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802d56:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d5a:	75 17                	jne    802d73 <insert_sorted_with_merge_freeList+0x183>
  802d5c:	83 ec 04             	sub    $0x4,%esp
  802d5f:	68 84 3f 80 00       	push   $0x803f84
  802d64:	68 3f 01 00 00       	push   $0x13f
  802d69:	68 a7 3f 80 00       	push   $0x803fa7
  802d6e:	e8 43 d5 ff ff       	call   8002b6 <_panic>
  802d73:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802d79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d7c:	89 10                	mov    %edx,(%eax)
  802d7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d81:	8b 00                	mov    (%eax),%eax
  802d83:	85 c0                	test   %eax,%eax
  802d85:	74 0d                	je     802d94 <insert_sorted_with_merge_freeList+0x1a4>
  802d87:	a1 48 51 80 00       	mov    0x805148,%eax
  802d8c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d8f:	89 50 04             	mov    %edx,0x4(%eax)
  802d92:	eb 08                	jmp    802d9c <insert_sorted_with_merge_freeList+0x1ac>
  802d94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d97:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d9f:	a3 48 51 80 00       	mov    %eax,0x805148
  802da4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dae:	a1 54 51 80 00       	mov    0x805154,%eax
  802db3:	40                   	inc    %eax
  802db4:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802db9:	e9 7a 05 00 00       	jmp    803338 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc1:	8b 50 08             	mov    0x8(%eax),%edx
  802dc4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dc7:	8b 40 08             	mov    0x8(%eax),%eax
  802dca:	39 c2                	cmp    %eax,%edx
  802dcc:	0f 82 14 01 00 00    	jb     802ee6 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802dd2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dd5:	8b 50 08             	mov    0x8(%eax),%edx
  802dd8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ddb:	8b 40 0c             	mov    0xc(%eax),%eax
  802dde:	01 c2                	add    %eax,%edx
  802de0:	8b 45 08             	mov    0x8(%ebp),%eax
  802de3:	8b 40 08             	mov    0x8(%eax),%eax
  802de6:	39 c2                	cmp    %eax,%edx
  802de8:	0f 85 90 00 00 00    	jne    802e7e <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802dee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802df1:	8b 50 0c             	mov    0xc(%eax),%edx
  802df4:	8b 45 08             	mov    0x8(%ebp),%eax
  802df7:	8b 40 0c             	mov    0xc(%eax),%eax
  802dfa:	01 c2                	add    %eax,%edx
  802dfc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dff:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802e02:	8b 45 08             	mov    0x8(%ebp),%eax
  802e05:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802e0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802e16:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e1a:	75 17                	jne    802e33 <insert_sorted_with_merge_freeList+0x243>
  802e1c:	83 ec 04             	sub    $0x4,%esp
  802e1f:	68 84 3f 80 00       	push   $0x803f84
  802e24:	68 49 01 00 00       	push   $0x149
  802e29:	68 a7 3f 80 00       	push   $0x803fa7
  802e2e:	e8 83 d4 ff ff       	call   8002b6 <_panic>
  802e33:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802e39:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3c:	89 10                	mov    %edx,(%eax)
  802e3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e41:	8b 00                	mov    (%eax),%eax
  802e43:	85 c0                	test   %eax,%eax
  802e45:	74 0d                	je     802e54 <insert_sorted_with_merge_freeList+0x264>
  802e47:	a1 48 51 80 00       	mov    0x805148,%eax
  802e4c:	8b 55 08             	mov    0x8(%ebp),%edx
  802e4f:	89 50 04             	mov    %edx,0x4(%eax)
  802e52:	eb 08                	jmp    802e5c <insert_sorted_with_merge_freeList+0x26c>
  802e54:	8b 45 08             	mov    0x8(%ebp),%eax
  802e57:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5f:	a3 48 51 80 00       	mov    %eax,0x805148
  802e64:	8b 45 08             	mov    0x8(%ebp),%eax
  802e67:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e6e:	a1 54 51 80 00       	mov    0x805154,%eax
  802e73:	40                   	inc    %eax
  802e74:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802e79:	e9 bb 04 00 00       	jmp    803339 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802e7e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e82:	75 17                	jne    802e9b <insert_sorted_with_merge_freeList+0x2ab>
  802e84:	83 ec 04             	sub    $0x4,%esp
  802e87:	68 f8 3f 80 00       	push   $0x803ff8
  802e8c:	68 4c 01 00 00       	push   $0x14c
  802e91:	68 a7 3f 80 00       	push   $0x803fa7
  802e96:	e8 1b d4 ff ff       	call   8002b6 <_panic>
  802e9b:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea4:	89 50 04             	mov    %edx,0x4(%eax)
  802ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eaa:	8b 40 04             	mov    0x4(%eax),%eax
  802ead:	85 c0                	test   %eax,%eax
  802eaf:	74 0c                	je     802ebd <insert_sorted_with_merge_freeList+0x2cd>
  802eb1:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802eb6:	8b 55 08             	mov    0x8(%ebp),%edx
  802eb9:	89 10                	mov    %edx,(%eax)
  802ebb:	eb 08                	jmp    802ec5 <insert_sorted_with_merge_freeList+0x2d5>
  802ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec0:	a3 38 51 80 00       	mov    %eax,0x805138
  802ec5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ecd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ed6:	a1 44 51 80 00       	mov    0x805144,%eax
  802edb:	40                   	inc    %eax
  802edc:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802ee1:	e9 53 04 00 00       	jmp    803339 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802ee6:	a1 38 51 80 00       	mov    0x805138,%eax
  802eeb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802eee:	e9 15 04 00 00       	jmp    803308 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802ef3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef6:	8b 00                	mov    (%eax),%eax
  802ef8:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802efb:	8b 45 08             	mov    0x8(%ebp),%eax
  802efe:	8b 50 08             	mov    0x8(%eax),%edx
  802f01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f04:	8b 40 08             	mov    0x8(%eax),%eax
  802f07:	39 c2                	cmp    %eax,%edx
  802f09:	0f 86 f1 03 00 00    	jbe    803300 <insert_sorted_with_merge_freeList+0x710>
  802f0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f12:	8b 50 08             	mov    0x8(%eax),%edx
  802f15:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f18:	8b 40 08             	mov    0x8(%eax),%eax
  802f1b:	39 c2                	cmp    %eax,%edx
  802f1d:	0f 83 dd 03 00 00    	jae    803300 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802f23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f26:	8b 50 08             	mov    0x8(%eax),%edx
  802f29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2c:	8b 40 0c             	mov    0xc(%eax),%eax
  802f2f:	01 c2                	add    %eax,%edx
  802f31:	8b 45 08             	mov    0x8(%ebp),%eax
  802f34:	8b 40 08             	mov    0x8(%eax),%eax
  802f37:	39 c2                	cmp    %eax,%edx
  802f39:	0f 85 b9 01 00 00    	jne    8030f8 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f42:	8b 50 08             	mov    0x8(%eax),%edx
  802f45:	8b 45 08             	mov    0x8(%ebp),%eax
  802f48:	8b 40 0c             	mov    0xc(%eax),%eax
  802f4b:	01 c2                	add    %eax,%edx
  802f4d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f50:	8b 40 08             	mov    0x8(%eax),%eax
  802f53:	39 c2                	cmp    %eax,%edx
  802f55:	0f 85 0d 01 00 00    	jne    803068 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802f5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5e:	8b 50 0c             	mov    0xc(%eax),%edx
  802f61:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f64:	8b 40 0c             	mov    0xc(%eax),%eax
  802f67:	01 c2                	add    %eax,%edx
  802f69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6c:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802f6f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f73:	75 17                	jne    802f8c <insert_sorted_with_merge_freeList+0x39c>
  802f75:	83 ec 04             	sub    $0x4,%esp
  802f78:	68 50 40 80 00       	push   $0x804050
  802f7d:	68 5c 01 00 00       	push   $0x15c
  802f82:	68 a7 3f 80 00       	push   $0x803fa7
  802f87:	e8 2a d3 ff ff       	call   8002b6 <_panic>
  802f8c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f8f:	8b 00                	mov    (%eax),%eax
  802f91:	85 c0                	test   %eax,%eax
  802f93:	74 10                	je     802fa5 <insert_sorted_with_merge_freeList+0x3b5>
  802f95:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f98:	8b 00                	mov    (%eax),%eax
  802f9a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f9d:	8b 52 04             	mov    0x4(%edx),%edx
  802fa0:	89 50 04             	mov    %edx,0x4(%eax)
  802fa3:	eb 0b                	jmp    802fb0 <insert_sorted_with_merge_freeList+0x3c0>
  802fa5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fa8:	8b 40 04             	mov    0x4(%eax),%eax
  802fab:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fb0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fb3:	8b 40 04             	mov    0x4(%eax),%eax
  802fb6:	85 c0                	test   %eax,%eax
  802fb8:	74 0f                	je     802fc9 <insert_sorted_with_merge_freeList+0x3d9>
  802fba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fbd:	8b 40 04             	mov    0x4(%eax),%eax
  802fc0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fc3:	8b 12                	mov    (%edx),%edx
  802fc5:	89 10                	mov    %edx,(%eax)
  802fc7:	eb 0a                	jmp    802fd3 <insert_sorted_with_merge_freeList+0x3e3>
  802fc9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fcc:	8b 00                	mov    (%eax),%eax
  802fce:	a3 38 51 80 00       	mov    %eax,0x805138
  802fd3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fd6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fdc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fdf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fe6:	a1 44 51 80 00       	mov    0x805144,%eax
  802feb:	48                   	dec    %eax
  802fec:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  802ff1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ff4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  802ffb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ffe:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803005:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803009:	75 17                	jne    803022 <insert_sorted_with_merge_freeList+0x432>
  80300b:	83 ec 04             	sub    $0x4,%esp
  80300e:	68 84 3f 80 00       	push   $0x803f84
  803013:	68 5f 01 00 00       	push   $0x15f
  803018:	68 a7 3f 80 00       	push   $0x803fa7
  80301d:	e8 94 d2 ff ff       	call   8002b6 <_panic>
  803022:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803028:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80302b:	89 10                	mov    %edx,(%eax)
  80302d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803030:	8b 00                	mov    (%eax),%eax
  803032:	85 c0                	test   %eax,%eax
  803034:	74 0d                	je     803043 <insert_sorted_with_merge_freeList+0x453>
  803036:	a1 48 51 80 00       	mov    0x805148,%eax
  80303b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80303e:	89 50 04             	mov    %edx,0x4(%eax)
  803041:	eb 08                	jmp    80304b <insert_sorted_with_merge_freeList+0x45b>
  803043:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803046:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80304b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80304e:	a3 48 51 80 00       	mov    %eax,0x805148
  803053:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803056:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80305d:	a1 54 51 80 00       	mov    0x805154,%eax
  803062:	40                   	inc    %eax
  803063:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803068:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80306b:	8b 50 0c             	mov    0xc(%eax),%edx
  80306e:	8b 45 08             	mov    0x8(%ebp),%eax
  803071:	8b 40 0c             	mov    0xc(%eax),%eax
  803074:	01 c2                	add    %eax,%edx
  803076:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803079:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  80307c:	8b 45 08             	mov    0x8(%ebp),%eax
  80307f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803086:	8b 45 08             	mov    0x8(%ebp),%eax
  803089:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803090:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803094:	75 17                	jne    8030ad <insert_sorted_with_merge_freeList+0x4bd>
  803096:	83 ec 04             	sub    $0x4,%esp
  803099:	68 84 3f 80 00       	push   $0x803f84
  80309e:	68 64 01 00 00       	push   $0x164
  8030a3:	68 a7 3f 80 00       	push   $0x803fa7
  8030a8:	e8 09 d2 ff ff       	call   8002b6 <_panic>
  8030ad:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8030b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b6:	89 10                	mov    %edx,(%eax)
  8030b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030bb:	8b 00                	mov    (%eax),%eax
  8030bd:	85 c0                	test   %eax,%eax
  8030bf:	74 0d                	je     8030ce <insert_sorted_with_merge_freeList+0x4de>
  8030c1:	a1 48 51 80 00       	mov    0x805148,%eax
  8030c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8030c9:	89 50 04             	mov    %edx,0x4(%eax)
  8030cc:	eb 08                	jmp    8030d6 <insert_sorted_with_merge_freeList+0x4e6>
  8030ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d9:	a3 48 51 80 00       	mov    %eax,0x805148
  8030de:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030e8:	a1 54 51 80 00       	mov    0x805154,%eax
  8030ed:	40                   	inc    %eax
  8030ee:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8030f3:	e9 41 02 00 00       	jmp    803339 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8030f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fb:	8b 50 08             	mov    0x8(%eax),%edx
  8030fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803101:	8b 40 0c             	mov    0xc(%eax),%eax
  803104:	01 c2                	add    %eax,%edx
  803106:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803109:	8b 40 08             	mov    0x8(%eax),%eax
  80310c:	39 c2                	cmp    %eax,%edx
  80310e:	0f 85 7c 01 00 00    	jne    803290 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803114:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803118:	74 06                	je     803120 <insert_sorted_with_merge_freeList+0x530>
  80311a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80311e:	75 17                	jne    803137 <insert_sorted_with_merge_freeList+0x547>
  803120:	83 ec 04             	sub    $0x4,%esp
  803123:	68 c0 3f 80 00       	push   $0x803fc0
  803128:	68 69 01 00 00       	push   $0x169
  80312d:	68 a7 3f 80 00       	push   $0x803fa7
  803132:	e8 7f d1 ff ff       	call   8002b6 <_panic>
  803137:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80313a:	8b 50 04             	mov    0x4(%eax),%edx
  80313d:	8b 45 08             	mov    0x8(%ebp),%eax
  803140:	89 50 04             	mov    %edx,0x4(%eax)
  803143:	8b 45 08             	mov    0x8(%ebp),%eax
  803146:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803149:	89 10                	mov    %edx,(%eax)
  80314b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80314e:	8b 40 04             	mov    0x4(%eax),%eax
  803151:	85 c0                	test   %eax,%eax
  803153:	74 0d                	je     803162 <insert_sorted_with_merge_freeList+0x572>
  803155:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803158:	8b 40 04             	mov    0x4(%eax),%eax
  80315b:	8b 55 08             	mov    0x8(%ebp),%edx
  80315e:	89 10                	mov    %edx,(%eax)
  803160:	eb 08                	jmp    80316a <insert_sorted_with_merge_freeList+0x57a>
  803162:	8b 45 08             	mov    0x8(%ebp),%eax
  803165:	a3 38 51 80 00       	mov    %eax,0x805138
  80316a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80316d:	8b 55 08             	mov    0x8(%ebp),%edx
  803170:	89 50 04             	mov    %edx,0x4(%eax)
  803173:	a1 44 51 80 00       	mov    0x805144,%eax
  803178:	40                   	inc    %eax
  803179:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  80317e:	8b 45 08             	mov    0x8(%ebp),%eax
  803181:	8b 50 0c             	mov    0xc(%eax),%edx
  803184:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803187:	8b 40 0c             	mov    0xc(%eax),%eax
  80318a:	01 c2                	add    %eax,%edx
  80318c:	8b 45 08             	mov    0x8(%ebp),%eax
  80318f:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803192:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803196:	75 17                	jne    8031af <insert_sorted_with_merge_freeList+0x5bf>
  803198:	83 ec 04             	sub    $0x4,%esp
  80319b:	68 50 40 80 00       	push   $0x804050
  8031a0:	68 6b 01 00 00       	push   $0x16b
  8031a5:	68 a7 3f 80 00       	push   $0x803fa7
  8031aa:	e8 07 d1 ff ff       	call   8002b6 <_panic>
  8031af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031b2:	8b 00                	mov    (%eax),%eax
  8031b4:	85 c0                	test   %eax,%eax
  8031b6:	74 10                	je     8031c8 <insert_sorted_with_merge_freeList+0x5d8>
  8031b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031bb:	8b 00                	mov    (%eax),%eax
  8031bd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031c0:	8b 52 04             	mov    0x4(%edx),%edx
  8031c3:	89 50 04             	mov    %edx,0x4(%eax)
  8031c6:	eb 0b                	jmp    8031d3 <insert_sorted_with_merge_freeList+0x5e3>
  8031c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031cb:	8b 40 04             	mov    0x4(%eax),%eax
  8031ce:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d6:	8b 40 04             	mov    0x4(%eax),%eax
  8031d9:	85 c0                	test   %eax,%eax
  8031db:	74 0f                	je     8031ec <insert_sorted_with_merge_freeList+0x5fc>
  8031dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e0:	8b 40 04             	mov    0x4(%eax),%eax
  8031e3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031e6:	8b 12                	mov    (%edx),%edx
  8031e8:	89 10                	mov    %edx,(%eax)
  8031ea:	eb 0a                	jmp    8031f6 <insert_sorted_with_merge_freeList+0x606>
  8031ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ef:	8b 00                	mov    (%eax),%eax
  8031f1:	a3 38 51 80 00       	mov    %eax,0x805138
  8031f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803202:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803209:	a1 44 51 80 00       	mov    0x805144,%eax
  80320e:	48                   	dec    %eax
  80320f:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803214:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803217:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  80321e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803221:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803228:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80322c:	75 17                	jne    803245 <insert_sorted_with_merge_freeList+0x655>
  80322e:	83 ec 04             	sub    $0x4,%esp
  803231:	68 84 3f 80 00       	push   $0x803f84
  803236:	68 6e 01 00 00       	push   $0x16e
  80323b:	68 a7 3f 80 00       	push   $0x803fa7
  803240:	e8 71 d0 ff ff       	call   8002b6 <_panic>
  803245:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80324b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80324e:	89 10                	mov    %edx,(%eax)
  803250:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803253:	8b 00                	mov    (%eax),%eax
  803255:	85 c0                	test   %eax,%eax
  803257:	74 0d                	je     803266 <insert_sorted_with_merge_freeList+0x676>
  803259:	a1 48 51 80 00       	mov    0x805148,%eax
  80325e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803261:	89 50 04             	mov    %edx,0x4(%eax)
  803264:	eb 08                	jmp    80326e <insert_sorted_with_merge_freeList+0x67e>
  803266:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803269:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80326e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803271:	a3 48 51 80 00       	mov    %eax,0x805148
  803276:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803279:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803280:	a1 54 51 80 00       	mov    0x805154,%eax
  803285:	40                   	inc    %eax
  803286:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80328b:	e9 a9 00 00 00       	jmp    803339 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803290:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803294:	74 06                	je     80329c <insert_sorted_with_merge_freeList+0x6ac>
  803296:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80329a:	75 17                	jne    8032b3 <insert_sorted_with_merge_freeList+0x6c3>
  80329c:	83 ec 04             	sub    $0x4,%esp
  80329f:	68 1c 40 80 00       	push   $0x80401c
  8032a4:	68 73 01 00 00       	push   $0x173
  8032a9:	68 a7 3f 80 00       	push   $0x803fa7
  8032ae:	e8 03 d0 ff ff       	call   8002b6 <_panic>
  8032b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b6:	8b 10                	mov    (%eax),%edx
  8032b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032bb:	89 10                	mov    %edx,(%eax)
  8032bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c0:	8b 00                	mov    (%eax),%eax
  8032c2:	85 c0                	test   %eax,%eax
  8032c4:	74 0b                	je     8032d1 <insert_sorted_with_merge_freeList+0x6e1>
  8032c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c9:	8b 00                	mov    (%eax),%eax
  8032cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8032ce:	89 50 04             	mov    %edx,0x4(%eax)
  8032d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d4:	8b 55 08             	mov    0x8(%ebp),%edx
  8032d7:	89 10                	mov    %edx,(%eax)
  8032d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032df:	89 50 04             	mov    %edx,0x4(%eax)
  8032e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e5:	8b 00                	mov    (%eax),%eax
  8032e7:	85 c0                	test   %eax,%eax
  8032e9:	75 08                	jne    8032f3 <insert_sorted_with_merge_freeList+0x703>
  8032eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ee:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032f3:	a1 44 51 80 00       	mov    0x805144,%eax
  8032f8:	40                   	inc    %eax
  8032f9:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  8032fe:	eb 39                	jmp    803339 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803300:	a1 40 51 80 00       	mov    0x805140,%eax
  803305:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803308:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80330c:	74 07                	je     803315 <insert_sorted_with_merge_freeList+0x725>
  80330e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803311:	8b 00                	mov    (%eax),%eax
  803313:	eb 05                	jmp    80331a <insert_sorted_with_merge_freeList+0x72a>
  803315:	b8 00 00 00 00       	mov    $0x0,%eax
  80331a:	a3 40 51 80 00       	mov    %eax,0x805140
  80331f:	a1 40 51 80 00       	mov    0x805140,%eax
  803324:	85 c0                	test   %eax,%eax
  803326:	0f 85 c7 fb ff ff    	jne    802ef3 <insert_sorted_with_merge_freeList+0x303>
  80332c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803330:	0f 85 bd fb ff ff    	jne    802ef3 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803336:	eb 01                	jmp    803339 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803338:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803339:	90                   	nop
  80333a:	c9                   	leave  
  80333b:	c3                   	ret    

0080333c <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  80333c:	55                   	push   %ebp
  80333d:	89 e5                	mov    %esp,%ebp
  80333f:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803342:	8b 55 08             	mov    0x8(%ebp),%edx
  803345:	89 d0                	mov    %edx,%eax
  803347:	c1 e0 02             	shl    $0x2,%eax
  80334a:	01 d0                	add    %edx,%eax
  80334c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803353:	01 d0                	add    %edx,%eax
  803355:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80335c:	01 d0                	add    %edx,%eax
  80335e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803365:	01 d0                	add    %edx,%eax
  803367:	c1 e0 04             	shl    $0x4,%eax
  80336a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  80336d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803374:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803377:	83 ec 0c             	sub    $0xc,%esp
  80337a:	50                   	push   %eax
  80337b:	e8 26 e7 ff ff       	call   801aa6 <sys_get_virtual_time>
  803380:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803383:	eb 41                	jmp    8033c6 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803385:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803388:	83 ec 0c             	sub    $0xc,%esp
  80338b:	50                   	push   %eax
  80338c:	e8 15 e7 ff ff       	call   801aa6 <sys_get_virtual_time>
  803391:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803394:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803397:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80339a:	29 c2                	sub    %eax,%edx
  80339c:	89 d0                	mov    %edx,%eax
  80339e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8033a1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8033a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033a7:	89 d1                	mov    %edx,%ecx
  8033a9:	29 c1                	sub    %eax,%ecx
  8033ab:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8033ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033b1:	39 c2                	cmp    %eax,%edx
  8033b3:	0f 97 c0             	seta   %al
  8033b6:	0f b6 c0             	movzbl %al,%eax
  8033b9:	29 c1                	sub    %eax,%ecx
  8033bb:	89 c8                	mov    %ecx,%eax
  8033bd:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8033c0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8033c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8033c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8033cc:	72 b7                	jb     803385 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8033ce:	90                   	nop
  8033cf:	c9                   	leave  
  8033d0:	c3                   	ret    

008033d1 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8033d1:	55                   	push   %ebp
  8033d2:	89 e5                	mov    %esp,%ebp
  8033d4:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8033d7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8033de:	eb 03                	jmp    8033e3 <busy_wait+0x12>
  8033e0:	ff 45 fc             	incl   -0x4(%ebp)
  8033e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8033e6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8033e9:	72 f5                	jb     8033e0 <busy_wait+0xf>
	return i;
  8033eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8033ee:	c9                   	leave  
  8033ef:	c3                   	ret    

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
