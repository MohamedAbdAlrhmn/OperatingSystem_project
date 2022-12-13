
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
  80008c:	68 80 36 80 00       	push   $0x803680
  800091:	6a 12                	push   $0x12
  800093:	68 9c 36 80 00       	push   $0x80369c
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
  8000aa:	e8 e9 19 00 00       	call   801a98 <sys_getparentenvid>
  8000af:	83 ec 08             	sub    $0x8,%esp
  8000b2:	68 b9 36 80 00       	push   $0x8036b9
  8000b7:	50                   	push   %eax
  8000b8:	e8 3e 15 00 00       	call   8015fb <sget>
  8000bd:	83 c4 10             	add    $0x10,%esp
  8000c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("Slave B2 env used z (getSharedObject)\n");
  8000c3:	83 ec 0c             	sub    $0xc,%esp
  8000c6:	68 bc 36 80 00       	push   $0x8036bc
  8000cb:	e8 9a 04 00 00       	call   80056a <cprintf>
  8000d0:	83 c4 10             	add    $0x10,%esp
	//To indicate that it's successfully got z
	inctst();
  8000d3:	e8 e5 1a 00 00       	call   801bbd <inctst>

	cprintf("Slave B2 please be patient ...\n");
  8000d8:	83 ec 0c             	sub    $0xc,%esp
  8000db:	68 e4 36 80 00       	push   $0x8036e4
  8000e0:	e8 85 04 00 00       	call   80056a <cprintf>
  8000e5:	83 c4 10             	add    $0x10,%esp

	//sleep a while to allow the master to remove x & z
	env_sleep(9000);
  8000e8:	83 ec 0c             	sub    $0xc,%esp
  8000eb:	68 28 23 00 00       	push   $0x2328
  8000f0:	e8 6c 32 00 00       	call   803361 <env_sleep>
  8000f5:	83 c4 10             	add    $0x10,%esp
	//to ensure that the other environments completed successfully
	while (gettst()!=2) ;// panic("test failed");
  8000f8:	90                   	nop
  8000f9:	e8 d9 1a 00 00       	call   801bd7 <gettst>
  8000fe:	83 f8 02             	cmp    $0x2,%eax
  800101:	75 f6                	jne    8000f9 <_main+0xc1>

	int freeFrames = sys_calculate_free_frames() ;
  800103:	e8 97 16 00 00       	call   80179f <sys_calculate_free_frames>
  800108:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sfree(z);
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	ff 75 ec             	pushl  -0x14(%ebp)
  800111:	e8 29 15 00 00       	call   80163f <sfree>
  800116:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave B2 env removed z\n");
  800119:	83 ec 0c             	sub    $0xc,%esp
  80011c:	68 04 37 80 00       	push   $0x803704
  800121:	e8 44 04 00 00       	call   80056a <cprintf>
  800126:	83 c4 10             	add    $0x10,%esp
	int expected = (1+1) + (1+1);
  800129:	c7 45 e4 04 00 00 00 	movl   $0x4,-0x1c(%ebp)
	if ((sys_calculate_free_frames() - freeFrames) !=  expected) panic("wrong free: frames removed not equal 4 !, correct frames to be removed are 4:\nfrom the env: 1 table + 1 frame for z\nframes_storage of z: should be cleared now\n");
  800130:	e8 6a 16 00 00       	call   80179f <sys_calculate_free_frames>
  800135:	89 c2                	mov    %eax,%edx
  800137:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80013a:	29 c2                	sub    %eax,%edx
  80013c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80013f:	39 c2                	cmp    %eax,%edx
  800141:	74 14                	je     800157 <_main+0x11f>
  800143:	83 ec 04             	sub    $0x4,%esp
  800146:	68 1c 37 80 00       	push   $0x80371c
  80014b:	6a 2a                	push   $0x2a
  80014d:	68 9c 36 80 00       	push   $0x80369c
  800152:	e8 5f 01 00 00       	call   8002b6 <_panic>


	cprintf("Step B completed successfully!!\n\n\n");
  800157:	83 ec 0c             	sub    $0xc,%esp
  80015a:	68 bc 37 80 00       	push   $0x8037bc
  80015f:	e8 06 04 00 00       	call   80056a <cprintf>
  800164:	83 c4 10             	add    $0x10,%esp
	cprintf("Congratulations!! Test of freeSharedObjects [5] completed successfully!!\n\n\n");
  800167:	83 ec 0c             	sub    $0xc,%esp
  80016a:	68 e0 37 80 00       	push   $0x8037e0
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
  800180:	e8 fa 18 00 00       	call   801a7f <sys_getenvindex>
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
  8001eb:	e8 9c 16 00 00       	call   80188c <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001f0:	83 ec 0c             	sub    $0xc,%esp
  8001f3:	68 44 38 80 00       	push   $0x803844
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
  80021b:	68 6c 38 80 00       	push   $0x80386c
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
  80024c:	68 94 38 80 00       	push   $0x803894
  800251:	e8 14 03 00 00       	call   80056a <cprintf>
  800256:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800259:	a1 20 50 80 00       	mov    0x805020,%eax
  80025e:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800264:	83 ec 08             	sub    $0x8,%esp
  800267:	50                   	push   %eax
  800268:	68 ec 38 80 00       	push   $0x8038ec
  80026d:	e8 f8 02 00 00       	call   80056a <cprintf>
  800272:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800275:	83 ec 0c             	sub    $0xc,%esp
  800278:	68 44 38 80 00       	push   $0x803844
  80027d:	e8 e8 02 00 00       	call   80056a <cprintf>
  800282:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800285:	e8 1c 16 00 00       	call   8018a6 <sys_enable_interrupt>

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
  80029d:	e8 a9 17 00 00       	call   801a4b <sys_destroy_env>
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
  8002ae:	e8 fe 17 00 00       	call   801ab1 <sys_exit_env>
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
  8002d7:	68 00 39 80 00       	push   $0x803900
  8002dc:	e8 89 02 00 00       	call   80056a <cprintf>
  8002e1:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002e4:	a1 00 50 80 00       	mov    0x805000,%eax
  8002e9:	ff 75 0c             	pushl  0xc(%ebp)
  8002ec:	ff 75 08             	pushl  0x8(%ebp)
  8002ef:	50                   	push   %eax
  8002f0:	68 05 39 80 00       	push   $0x803905
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
  800314:	68 21 39 80 00       	push   $0x803921
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
  800340:	68 24 39 80 00       	push   $0x803924
  800345:	6a 26                	push   $0x26
  800347:	68 70 39 80 00       	push   $0x803970
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
  800412:	68 7c 39 80 00       	push   $0x80397c
  800417:	6a 3a                	push   $0x3a
  800419:	68 70 39 80 00       	push   $0x803970
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
  800482:	68 d0 39 80 00       	push   $0x8039d0
  800487:	6a 44                	push   $0x44
  800489:	68 70 39 80 00       	push   $0x803970
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
  8004dc:	e8 fd 11 00 00       	call   8016de <sys_cputs>
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
  800553:	e8 86 11 00 00       	call   8016de <sys_cputs>
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
  80059d:	e8 ea 12 00 00       	call   80188c <sys_disable_interrupt>
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
  8005bd:	e8 e4 12 00 00       	call   8018a6 <sys_enable_interrupt>
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
  800607:	e8 0c 2e 00 00       	call   803418 <__udivdi3>
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
  800657:	e8 cc 2e 00 00       	call   803528 <__umoddi3>
  80065c:	83 c4 10             	add    $0x10,%esp
  80065f:	05 34 3c 80 00       	add    $0x803c34,%eax
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
  8007b2:	8b 04 85 58 3c 80 00 	mov    0x803c58(,%eax,4),%eax
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
  800893:	8b 34 9d a0 3a 80 00 	mov    0x803aa0(,%ebx,4),%esi
  80089a:	85 f6                	test   %esi,%esi
  80089c:	75 19                	jne    8008b7 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80089e:	53                   	push   %ebx
  80089f:	68 45 3c 80 00       	push   $0x803c45
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
  8008b8:	68 4e 3c 80 00       	push   $0x803c4e
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
  8008e5:	be 51 3c 80 00       	mov    $0x803c51,%esi
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
  80130b:	68 b0 3d 80 00       	push   $0x803db0
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
  8013db:	e8 42 04 00 00       	call   801822 <sys_allocate_chunk>
  8013e0:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013e3:	a1 20 51 80 00       	mov    0x805120,%eax
  8013e8:	83 ec 0c             	sub    $0xc,%esp
  8013eb:	50                   	push   %eax
  8013ec:	e8 b7 0a 00 00       	call   801ea8 <initialize_MemBlocksList>
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
  801419:	68 d5 3d 80 00       	push   $0x803dd5
  80141e:	6a 33                	push   $0x33
  801420:	68 f3 3d 80 00       	push   $0x803df3
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
  801498:	68 00 3e 80 00       	push   $0x803e00
  80149d:	6a 34                	push   $0x34
  80149f:	68 f3 3d 80 00       	push   $0x803df3
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
  80150d:	68 24 3e 80 00       	push   $0x803e24
  801512:	6a 46                	push   $0x46
  801514:	68 f3 3d 80 00       	push   $0x803df3
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
  801529:	68 4c 3e 80 00       	push   $0x803e4c
  80152e:	6a 61                	push   $0x61
  801530:	68 f3 3d 80 00       	push   $0x803df3
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
  80154f:	75 0a                	jne    80155b <smalloc+0x21>
  801551:	b8 00 00 00 00       	mov    $0x0,%eax
  801556:	e9 9e 00 00 00       	jmp    8015f9 <smalloc+0xbf>
	//3-If the Kernel successfully creates the shared variable, return its virtual address
	//4-Else, return NULL



	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  80155b:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801562:	8b 55 0c             	mov    0xc(%ebp),%edx
  801565:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801568:	01 d0                	add    %edx,%eax
  80156a:	48                   	dec    %eax
  80156b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80156e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801571:	ba 00 00 00 00       	mov    $0x0,%edx
  801576:	f7 75 f0             	divl   -0x10(%ebp)
  801579:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80157c:	29 d0                	sub    %edx,%eax
  80157e:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801581:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801588:	e8 63 06 00 00       	call   801bf0 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80158d:	85 c0                	test   %eax,%eax
  80158f:	74 11                	je     8015a2 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  801591:	83 ec 0c             	sub    $0xc,%esp
  801594:	ff 75 e8             	pushl  -0x18(%ebp)
  801597:	e8 ce 0c 00 00       	call   80226a <alloc_block_FF>
  80159c:	83 c4 10             	add    $0x10,%esp
  80159f:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  8015a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8015a6:	74 4c                	je     8015f4 <smalloc+0xba>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8015a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015ab:	8b 40 08             	mov    0x8(%eax),%eax
  8015ae:	89 c2                	mov    %eax,%edx
  8015b0:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8015b4:	52                   	push   %edx
  8015b5:	50                   	push   %eax
  8015b6:	ff 75 0c             	pushl  0xc(%ebp)
  8015b9:	ff 75 08             	pushl  0x8(%ebp)
  8015bc:	e8 b4 03 00 00       	call   801975 <sys_createSharedObject>
  8015c1:	83 c4 10             	add    $0x10,%esp
  8015c4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cprintf("Output is :  %d \n" , result);
  8015c7:	83 ec 08             	sub    $0x8,%esp
  8015ca:	ff 75 e0             	pushl  -0x20(%ebp)
  8015cd:	68 6f 3e 80 00       	push   $0x803e6f
  8015d2:	e8 93 ef ff ff       	call   80056a <cprintf>
  8015d7:	83 c4 10             	add    $0x10,%esp
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  8015da:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  8015de:	74 14                	je     8015f4 <smalloc+0xba>
  8015e0:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  8015e4:	74 0e                	je     8015f4 <smalloc+0xba>
  8015e6:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  8015ea:	74 08                	je     8015f4 <smalloc+0xba>
			return (void*) mem_block->sva;
  8015ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015ef:	8b 40 08             	mov    0x8(%eax),%eax
  8015f2:	eb 05                	jmp    8015f9 <smalloc+0xbf>
	}
	return NULL;
  8015f4:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8015f9:	c9                   	leave  
  8015fa:	c3                   	ret    

008015fb <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8015fb:	55                   	push   %ebp
  8015fc:	89 e5                	mov    %esp,%ebp
  8015fe:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801601:	e8 ee fc ff ff       	call   8012f4 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801606:	83 ec 04             	sub    $0x4,%esp
  801609:	68 84 3e 80 00       	push   $0x803e84
  80160e:	68 ab 00 00 00       	push   $0xab
  801613:	68 f3 3d 80 00       	push   $0x803df3
  801618:	e8 99 ec ff ff       	call   8002b6 <_panic>

0080161d <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80161d:	55                   	push   %ebp
  80161e:	89 e5                	mov    %esp,%ebp
  801620:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801623:	e8 cc fc ff ff       	call   8012f4 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801628:	83 ec 04             	sub    $0x4,%esp
  80162b:	68 a8 3e 80 00       	push   $0x803ea8
  801630:	68 ef 00 00 00       	push   $0xef
  801635:	68 f3 3d 80 00       	push   $0x803df3
  80163a:	e8 77 ec ff ff       	call   8002b6 <_panic>

0080163f <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80163f:	55                   	push   %ebp
  801640:	89 e5                	mov    %esp,%ebp
  801642:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801645:	83 ec 04             	sub    $0x4,%esp
  801648:	68 d0 3e 80 00       	push   $0x803ed0
  80164d:	68 03 01 00 00       	push   $0x103
  801652:	68 f3 3d 80 00       	push   $0x803df3
  801657:	e8 5a ec ff ff       	call   8002b6 <_panic>

0080165c <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80165c:	55                   	push   %ebp
  80165d:	89 e5                	mov    %esp,%ebp
  80165f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801662:	83 ec 04             	sub    $0x4,%esp
  801665:	68 f4 3e 80 00       	push   $0x803ef4
  80166a:	68 0e 01 00 00       	push   $0x10e
  80166f:	68 f3 3d 80 00       	push   $0x803df3
  801674:	e8 3d ec ff ff       	call   8002b6 <_panic>

00801679 <shrink>:

}
void shrink(uint32 newSize)
{
  801679:	55                   	push   %ebp
  80167a:	89 e5                	mov    %esp,%ebp
  80167c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80167f:	83 ec 04             	sub    $0x4,%esp
  801682:	68 f4 3e 80 00       	push   $0x803ef4
  801687:	68 13 01 00 00       	push   $0x113
  80168c:	68 f3 3d 80 00       	push   $0x803df3
  801691:	e8 20 ec ff ff       	call   8002b6 <_panic>

00801696 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801696:	55                   	push   %ebp
  801697:	89 e5                	mov    %esp,%ebp
  801699:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80169c:	83 ec 04             	sub    $0x4,%esp
  80169f:	68 f4 3e 80 00       	push   $0x803ef4
  8016a4:	68 18 01 00 00       	push   $0x118
  8016a9:	68 f3 3d 80 00       	push   $0x803df3
  8016ae:	e8 03 ec ff ff       	call   8002b6 <_panic>

008016b3 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8016b3:	55                   	push   %ebp
  8016b4:	89 e5                	mov    %esp,%ebp
  8016b6:	57                   	push   %edi
  8016b7:	56                   	push   %esi
  8016b8:	53                   	push   %ebx
  8016b9:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016c2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016c5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016c8:	8b 7d 18             	mov    0x18(%ebp),%edi
  8016cb:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8016ce:	cd 30                	int    $0x30
  8016d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8016d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8016d6:	83 c4 10             	add    $0x10,%esp
  8016d9:	5b                   	pop    %ebx
  8016da:	5e                   	pop    %esi
  8016db:	5f                   	pop    %edi
  8016dc:	5d                   	pop    %ebp
  8016dd:	c3                   	ret    

008016de <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8016de:	55                   	push   %ebp
  8016df:	89 e5                	mov    %esp,%ebp
  8016e1:	83 ec 04             	sub    $0x4,%esp
  8016e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8016e7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8016ea:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8016ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f1:	6a 00                	push   $0x0
  8016f3:	6a 00                	push   $0x0
  8016f5:	52                   	push   %edx
  8016f6:	ff 75 0c             	pushl  0xc(%ebp)
  8016f9:	50                   	push   %eax
  8016fa:	6a 00                	push   $0x0
  8016fc:	e8 b2 ff ff ff       	call   8016b3 <syscall>
  801701:	83 c4 18             	add    $0x18,%esp
}
  801704:	90                   	nop
  801705:	c9                   	leave  
  801706:	c3                   	ret    

00801707 <sys_cgetc>:

int
sys_cgetc(void)
{
  801707:	55                   	push   %ebp
  801708:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80170a:	6a 00                	push   $0x0
  80170c:	6a 00                	push   $0x0
  80170e:	6a 00                	push   $0x0
  801710:	6a 00                	push   $0x0
  801712:	6a 00                	push   $0x0
  801714:	6a 01                	push   $0x1
  801716:	e8 98 ff ff ff       	call   8016b3 <syscall>
  80171b:	83 c4 18             	add    $0x18,%esp
}
  80171e:	c9                   	leave  
  80171f:	c3                   	ret    

00801720 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801720:	55                   	push   %ebp
  801721:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801723:	8b 55 0c             	mov    0xc(%ebp),%edx
  801726:	8b 45 08             	mov    0x8(%ebp),%eax
  801729:	6a 00                	push   $0x0
  80172b:	6a 00                	push   $0x0
  80172d:	6a 00                	push   $0x0
  80172f:	52                   	push   %edx
  801730:	50                   	push   %eax
  801731:	6a 05                	push   $0x5
  801733:	e8 7b ff ff ff       	call   8016b3 <syscall>
  801738:	83 c4 18             	add    $0x18,%esp
}
  80173b:	c9                   	leave  
  80173c:	c3                   	ret    

0080173d <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80173d:	55                   	push   %ebp
  80173e:	89 e5                	mov    %esp,%ebp
  801740:	56                   	push   %esi
  801741:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801742:	8b 75 18             	mov    0x18(%ebp),%esi
  801745:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801748:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80174b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80174e:	8b 45 08             	mov    0x8(%ebp),%eax
  801751:	56                   	push   %esi
  801752:	53                   	push   %ebx
  801753:	51                   	push   %ecx
  801754:	52                   	push   %edx
  801755:	50                   	push   %eax
  801756:	6a 06                	push   $0x6
  801758:	e8 56 ff ff ff       	call   8016b3 <syscall>
  80175d:	83 c4 18             	add    $0x18,%esp
}
  801760:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801763:	5b                   	pop    %ebx
  801764:	5e                   	pop    %esi
  801765:	5d                   	pop    %ebp
  801766:	c3                   	ret    

00801767 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801767:	55                   	push   %ebp
  801768:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80176a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80176d:	8b 45 08             	mov    0x8(%ebp),%eax
  801770:	6a 00                	push   $0x0
  801772:	6a 00                	push   $0x0
  801774:	6a 00                	push   $0x0
  801776:	52                   	push   %edx
  801777:	50                   	push   %eax
  801778:	6a 07                	push   $0x7
  80177a:	e8 34 ff ff ff       	call   8016b3 <syscall>
  80177f:	83 c4 18             	add    $0x18,%esp
}
  801782:	c9                   	leave  
  801783:	c3                   	ret    

00801784 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801784:	55                   	push   %ebp
  801785:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801787:	6a 00                	push   $0x0
  801789:	6a 00                	push   $0x0
  80178b:	6a 00                	push   $0x0
  80178d:	ff 75 0c             	pushl  0xc(%ebp)
  801790:	ff 75 08             	pushl  0x8(%ebp)
  801793:	6a 08                	push   $0x8
  801795:	e8 19 ff ff ff       	call   8016b3 <syscall>
  80179a:	83 c4 18             	add    $0x18,%esp
}
  80179d:	c9                   	leave  
  80179e:	c3                   	ret    

0080179f <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80179f:	55                   	push   %ebp
  8017a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8017a2:	6a 00                	push   $0x0
  8017a4:	6a 00                	push   $0x0
  8017a6:	6a 00                	push   $0x0
  8017a8:	6a 00                	push   $0x0
  8017aa:	6a 00                	push   $0x0
  8017ac:	6a 09                	push   $0x9
  8017ae:	e8 00 ff ff ff       	call   8016b3 <syscall>
  8017b3:	83 c4 18             	add    $0x18,%esp
}
  8017b6:	c9                   	leave  
  8017b7:	c3                   	ret    

008017b8 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8017b8:	55                   	push   %ebp
  8017b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8017bb:	6a 00                	push   $0x0
  8017bd:	6a 00                	push   $0x0
  8017bf:	6a 00                	push   $0x0
  8017c1:	6a 00                	push   $0x0
  8017c3:	6a 00                	push   $0x0
  8017c5:	6a 0a                	push   $0xa
  8017c7:	e8 e7 fe ff ff       	call   8016b3 <syscall>
  8017cc:	83 c4 18             	add    $0x18,%esp
}
  8017cf:	c9                   	leave  
  8017d0:	c3                   	ret    

008017d1 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8017d1:	55                   	push   %ebp
  8017d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8017d4:	6a 00                	push   $0x0
  8017d6:	6a 00                	push   $0x0
  8017d8:	6a 00                	push   $0x0
  8017da:	6a 00                	push   $0x0
  8017dc:	6a 00                	push   $0x0
  8017de:	6a 0b                	push   $0xb
  8017e0:	e8 ce fe ff ff       	call   8016b3 <syscall>
  8017e5:	83 c4 18             	add    $0x18,%esp
}
  8017e8:	c9                   	leave  
  8017e9:	c3                   	ret    

008017ea <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8017ea:	55                   	push   %ebp
  8017eb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8017ed:	6a 00                	push   $0x0
  8017ef:	6a 00                	push   $0x0
  8017f1:	6a 00                	push   $0x0
  8017f3:	ff 75 0c             	pushl  0xc(%ebp)
  8017f6:	ff 75 08             	pushl  0x8(%ebp)
  8017f9:	6a 0f                	push   $0xf
  8017fb:	e8 b3 fe ff ff       	call   8016b3 <syscall>
  801800:	83 c4 18             	add    $0x18,%esp
	return;
  801803:	90                   	nop
}
  801804:	c9                   	leave  
  801805:	c3                   	ret    

00801806 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801806:	55                   	push   %ebp
  801807:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801809:	6a 00                	push   $0x0
  80180b:	6a 00                	push   $0x0
  80180d:	6a 00                	push   $0x0
  80180f:	ff 75 0c             	pushl  0xc(%ebp)
  801812:	ff 75 08             	pushl  0x8(%ebp)
  801815:	6a 10                	push   $0x10
  801817:	e8 97 fe ff ff       	call   8016b3 <syscall>
  80181c:	83 c4 18             	add    $0x18,%esp
	return ;
  80181f:	90                   	nop
}
  801820:	c9                   	leave  
  801821:	c3                   	ret    

00801822 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801822:	55                   	push   %ebp
  801823:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801825:	6a 00                	push   $0x0
  801827:	6a 00                	push   $0x0
  801829:	ff 75 10             	pushl  0x10(%ebp)
  80182c:	ff 75 0c             	pushl  0xc(%ebp)
  80182f:	ff 75 08             	pushl  0x8(%ebp)
  801832:	6a 11                	push   $0x11
  801834:	e8 7a fe ff ff       	call   8016b3 <syscall>
  801839:	83 c4 18             	add    $0x18,%esp
	return ;
  80183c:	90                   	nop
}
  80183d:	c9                   	leave  
  80183e:	c3                   	ret    

0080183f <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80183f:	55                   	push   %ebp
  801840:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801842:	6a 00                	push   $0x0
  801844:	6a 00                	push   $0x0
  801846:	6a 00                	push   $0x0
  801848:	6a 00                	push   $0x0
  80184a:	6a 00                	push   $0x0
  80184c:	6a 0c                	push   $0xc
  80184e:	e8 60 fe ff ff       	call   8016b3 <syscall>
  801853:	83 c4 18             	add    $0x18,%esp
}
  801856:	c9                   	leave  
  801857:	c3                   	ret    

00801858 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801858:	55                   	push   %ebp
  801859:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80185b:	6a 00                	push   $0x0
  80185d:	6a 00                	push   $0x0
  80185f:	6a 00                	push   $0x0
  801861:	6a 00                	push   $0x0
  801863:	ff 75 08             	pushl  0x8(%ebp)
  801866:	6a 0d                	push   $0xd
  801868:	e8 46 fe ff ff       	call   8016b3 <syscall>
  80186d:	83 c4 18             	add    $0x18,%esp
}
  801870:	c9                   	leave  
  801871:	c3                   	ret    

00801872 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801872:	55                   	push   %ebp
  801873:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	6a 00                	push   $0x0
  80187b:	6a 00                	push   $0x0
  80187d:	6a 00                	push   $0x0
  80187f:	6a 0e                	push   $0xe
  801881:	e8 2d fe ff ff       	call   8016b3 <syscall>
  801886:	83 c4 18             	add    $0x18,%esp
}
  801889:	90                   	nop
  80188a:	c9                   	leave  
  80188b:	c3                   	ret    

0080188c <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80188c:	55                   	push   %ebp
  80188d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80188f:	6a 00                	push   $0x0
  801891:	6a 00                	push   $0x0
  801893:	6a 00                	push   $0x0
  801895:	6a 00                	push   $0x0
  801897:	6a 00                	push   $0x0
  801899:	6a 13                	push   $0x13
  80189b:	e8 13 fe ff ff       	call   8016b3 <syscall>
  8018a0:	83 c4 18             	add    $0x18,%esp
}
  8018a3:	90                   	nop
  8018a4:	c9                   	leave  
  8018a5:	c3                   	ret    

008018a6 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8018a6:	55                   	push   %ebp
  8018a7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8018a9:	6a 00                	push   $0x0
  8018ab:	6a 00                	push   $0x0
  8018ad:	6a 00                	push   $0x0
  8018af:	6a 00                	push   $0x0
  8018b1:	6a 00                	push   $0x0
  8018b3:	6a 14                	push   $0x14
  8018b5:	e8 f9 fd ff ff       	call   8016b3 <syscall>
  8018ba:	83 c4 18             	add    $0x18,%esp
}
  8018bd:	90                   	nop
  8018be:	c9                   	leave  
  8018bf:	c3                   	ret    

008018c0 <sys_cputc>:


void
sys_cputc(const char c)
{
  8018c0:	55                   	push   %ebp
  8018c1:	89 e5                	mov    %esp,%ebp
  8018c3:	83 ec 04             	sub    $0x4,%esp
  8018c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8018cc:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8018d0:	6a 00                	push   $0x0
  8018d2:	6a 00                	push   $0x0
  8018d4:	6a 00                	push   $0x0
  8018d6:	6a 00                	push   $0x0
  8018d8:	50                   	push   %eax
  8018d9:	6a 15                	push   $0x15
  8018db:	e8 d3 fd ff ff       	call   8016b3 <syscall>
  8018e0:	83 c4 18             	add    $0x18,%esp
}
  8018e3:	90                   	nop
  8018e4:	c9                   	leave  
  8018e5:	c3                   	ret    

008018e6 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8018e6:	55                   	push   %ebp
  8018e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8018e9:	6a 00                	push   $0x0
  8018eb:	6a 00                	push   $0x0
  8018ed:	6a 00                	push   $0x0
  8018ef:	6a 00                	push   $0x0
  8018f1:	6a 00                	push   $0x0
  8018f3:	6a 16                	push   $0x16
  8018f5:	e8 b9 fd ff ff       	call   8016b3 <syscall>
  8018fa:	83 c4 18             	add    $0x18,%esp
}
  8018fd:	90                   	nop
  8018fe:	c9                   	leave  
  8018ff:	c3                   	ret    

00801900 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801900:	55                   	push   %ebp
  801901:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801903:	8b 45 08             	mov    0x8(%ebp),%eax
  801906:	6a 00                	push   $0x0
  801908:	6a 00                	push   $0x0
  80190a:	6a 00                	push   $0x0
  80190c:	ff 75 0c             	pushl  0xc(%ebp)
  80190f:	50                   	push   %eax
  801910:	6a 17                	push   $0x17
  801912:	e8 9c fd ff ff       	call   8016b3 <syscall>
  801917:	83 c4 18             	add    $0x18,%esp
}
  80191a:	c9                   	leave  
  80191b:	c3                   	ret    

0080191c <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80191c:	55                   	push   %ebp
  80191d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80191f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801922:	8b 45 08             	mov    0x8(%ebp),%eax
  801925:	6a 00                	push   $0x0
  801927:	6a 00                	push   $0x0
  801929:	6a 00                	push   $0x0
  80192b:	52                   	push   %edx
  80192c:	50                   	push   %eax
  80192d:	6a 1a                	push   $0x1a
  80192f:	e8 7f fd ff ff       	call   8016b3 <syscall>
  801934:	83 c4 18             	add    $0x18,%esp
}
  801937:	c9                   	leave  
  801938:	c3                   	ret    

00801939 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801939:	55                   	push   %ebp
  80193a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80193c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80193f:	8b 45 08             	mov    0x8(%ebp),%eax
  801942:	6a 00                	push   $0x0
  801944:	6a 00                	push   $0x0
  801946:	6a 00                	push   $0x0
  801948:	52                   	push   %edx
  801949:	50                   	push   %eax
  80194a:	6a 18                	push   $0x18
  80194c:	e8 62 fd ff ff       	call   8016b3 <syscall>
  801951:	83 c4 18             	add    $0x18,%esp
}
  801954:	90                   	nop
  801955:	c9                   	leave  
  801956:	c3                   	ret    

00801957 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801957:	55                   	push   %ebp
  801958:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80195a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80195d:	8b 45 08             	mov    0x8(%ebp),%eax
  801960:	6a 00                	push   $0x0
  801962:	6a 00                	push   $0x0
  801964:	6a 00                	push   $0x0
  801966:	52                   	push   %edx
  801967:	50                   	push   %eax
  801968:	6a 19                	push   $0x19
  80196a:	e8 44 fd ff ff       	call   8016b3 <syscall>
  80196f:	83 c4 18             	add    $0x18,%esp
}
  801972:	90                   	nop
  801973:	c9                   	leave  
  801974:	c3                   	ret    

00801975 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801975:	55                   	push   %ebp
  801976:	89 e5                	mov    %esp,%ebp
  801978:	83 ec 04             	sub    $0x4,%esp
  80197b:	8b 45 10             	mov    0x10(%ebp),%eax
  80197e:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801981:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801984:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801988:	8b 45 08             	mov    0x8(%ebp),%eax
  80198b:	6a 00                	push   $0x0
  80198d:	51                   	push   %ecx
  80198e:	52                   	push   %edx
  80198f:	ff 75 0c             	pushl  0xc(%ebp)
  801992:	50                   	push   %eax
  801993:	6a 1b                	push   $0x1b
  801995:	e8 19 fd ff ff       	call   8016b3 <syscall>
  80199a:	83 c4 18             	add    $0x18,%esp
}
  80199d:	c9                   	leave  
  80199e:	c3                   	ret    

0080199f <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80199f:	55                   	push   %ebp
  8019a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8019a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a8:	6a 00                	push   $0x0
  8019aa:	6a 00                	push   $0x0
  8019ac:	6a 00                	push   $0x0
  8019ae:	52                   	push   %edx
  8019af:	50                   	push   %eax
  8019b0:	6a 1c                	push   $0x1c
  8019b2:	e8 fc fc ff ff       	call   8016b3 <syscall>
  8019b7:	83 c4 18             	add    $0x18,%esp
}
  8019ba:	c9                   	leave  
  8019bb:	c3                   	ret    

008019bc <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8019bc:	55                   	push   %ebp
  8019bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8019bf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	51                   	push   %ecx
  8019cd:	52                   	push   %edx
  8019ce:	50                   	push   %eax
  8019cf:	6a 1d                	push   $0x1d
  8019d1:	e8 dd fc ff ff       	call   8016b3 <syscall>
  8019d6:	83 c4 18             	add    $0x18,%esp
}
  8019d9:	c9                   	leave  
  8019da:	c3                   	ret    

008019db <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8019db:	55                   	push   %ebp
  8019dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8019de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 00                	push   $0x0
  8019ea:	52                   	push   %edx
  8019eb:	50                   	push   %eax
  8019ec:	6a 1e                	push   $0x1e
  8019ee:	e8 c0 fc ff ff       	call   8016b3 <syscall>
  8019f3:	83 c4 18             	add    $0x18,%esp
}
  8019f6:	c9                   	leave  
  8019f7:	c3                   	ret    

008019f8 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8019f8:	55                   	push   %ebp
  8019f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8019fb:	6a 00                	push   $0x0
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 00                	push   $0x0
  801a01:	6a 00                	push   $0x0
  801a03:	6a 00                	push   $0x0
  801a05:	6a 1f                	push   $0x1f
  801a07:	e8 a7 fc ff ff       	call   8016b3 <syscall>
  801a0c:	83 c4 18             	add    $0x18,%esp
}
  801a0f:	c9                   	leave  
  801a10:	c3                   	ret    

00801a11 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a11:	55                   	push   %ebp
  801a12:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a14:	8b 45 08             	mov    0x8(%ebp),%eax
  801a17:	6a 00                	push   $0x0
  801a19:	ff 75 14             	pushl  0x14(%ebp)
  801a1c:	ff 75 10             	pushl  0x10(%ebp)
  801a1f:	ff 75 0c             	pushl  0xc(%ebp)
  801a22:	50                   	push   %eax
  801a23:	6a 20                	push   $0x20
  801a25:	e8 89 fc ff ff       	call   8016b3 <syscall>
  801a2a:	83 c4 18             	add    $0x18,%esp
}
  801a2d:	c9                   	leave  
  801a2e:	c3                   	ret    

00801a2f <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801a2f:	55                   	push   %ebp
  801a30:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a32:	8b 45 08             	mov    0x8(%ebp),%eax
  801a35:	6a 00                	push   $0x0
  801a37:	6a 00                	push   $0x0
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 00                	push   $0x0
  801a3d:	50                   	push   %eax
  801a3e:	6a 21                	push   $0x21
  801a40:	e8 6e fc ff ff       	call   8016b3 <syscall>
  801a45:	83 c4 18             	add    $0x18,%esp
}
  801a48:	90                   	nop
  801a49:	c9                   	leave  
  801a4a:	c3                   	ret    

00801a4b <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801a4b:	55                   	push   %ebp
  801a4c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a51:	6a 00                	push   $0x0
  801a53:	6a 00                	push   $0x0
  801a55:	6a 00                	push   $0x0
  801a57:	6a 00                	push   $0x0
  801a59:	50                   	push   %eax
  801a5a:	6a 22                	push   $0x22
  801a5c:	e8 52 fc ff ff       	call   8016b3 <syscall>
  801a61:	83 c4 18             	add    $0x18,%esp
}
  801a64:	c9                   	leave  
  801a65:	c3                   	ret    

00801a66 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801a66:	55                   	push   %ebp
  801a67:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801a69:	6a 00                	push   $0x0
  801a6b:	6a 00                	push   $0x0
  801a6d:	6a 00                	push   $0x0
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 00                	push   $0x0
  801a73:	6a 02                	push   $0x2
  801a75:	e8 39 fc ff ff       	call   8016b3 <syscall>
  801a7a:	83 c4 18             	add    $0x18,%esp
}
  801a7d:	c9                   	leave  
  801a7e:	c3                   	ret    

00801a7f <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801a7f:	55                   	push   %ebp
  801a80:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801a82:	6a 00                	push   $0x0
  801a84:	6a 00                	push   $0x0
  801a86:	6a 00                	push   $0x0
  801a88:	6a 00                	push   $0x0
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 03                	push   $0x3
  801a8e:	e8 20 fc ff ff       	call   8016b3 <syscall>
  801a93:	83 c4 18             	add    $0x18,%esp
}
  801a96:	c9                   	leave  
  801a97:	c3                   	ret    

00801a98 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801a98:	55                   	push   %ebp
  801a99:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801a9b:	6a 00                	push   $0x0
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 00                	push   $0x0
  801aa3:	6a 00                	push   $0x0
  801aa5:	6a 04                	push   $0x4
  801aa7:	e8 07 fc ff ff       	call   8016b3 <syscall>
  801aac:	83 c4 18             	add    $0x18,%esp
}
  801aaf:	c9                   	leave  
  801ab0:	c3                   	ret    

00801ab1 <sys_exit_env>:


void sys_exit_env(void)
{
  801ab1:	55                   	push   %ebp
  801ab2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	6a 00                	push   $0x0
  801abe:	6a 23                	push   $0x23
  801ac0:	e8 ee fb ff ff       	call   8016b3 <syscall>
  801ac5:	83 c4 18             	add    $0x18,%esp
}
  801ac8:	90                   	nop
  801ac9:	c9                   	leave  
  801aca:	c3                   	ret    

00801acb <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801acb:	55                   	push   %ebp
  801acc:	89 e5                	mov    %esp,%ebp
  801ace:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801ad1:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ad4:	8d 50 04             	lea    0x4(%eax),%edx
  801ad7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ada:	6a 00                	push   $0x0
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	52                   	push   %edx
  801ae1:	50                   	push   %eax
  801ae2:	6a 24                	push   $0x24
  801ae4:	e8 ca fb ff ff       	call   8016b3 <syscall>
  801ae9:	83 c4 18             	add    $0x18,%esp
	return result;
  801aec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801aef:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801af2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801af5:	89 01                	mov    %eax,(%ecx)
  801af7:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801afa:	8b 45 08             	mov    0x8(%ebp),%eax
  801afd:	c9                   	leave  
  801afe:	c2 04 00             	ret    $0x4

00801b01 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b01:	55                   	push   %ebp
  801b02:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b04:	6a 00                	push   $0x0
  801b06:	6a 00                	push   $0x0
  801b08:	ff 75 10             	pushl  0x10(%ebp)
  801b0b:	ff 75 0c             	pushl  0xc(%ebp)
  801b0e:	ff 75 08             	pushl  0x8(%ebp)
  801b11:	6a 12                	push   $0x12
  801b13:	e8 9b fb ff ff       	call   8016b3 <syscall>
  801b18:	83 c4 18             	add    $0x18,%esp
	return ;
  801b1b:	90                   	nop
}
  801b1c:	c9                   	leave  
  801b1d:	c3                   	ret    

00801b1e <sys_rcr2>:
uint32 sys_rcr2()
{
  801b1e:	55                   	push   %ebp
  801b1f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b21:	6a 00                	push   $0x0
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 25                	push   $0x25
  801b2d:	e8 81 fb ff ff       	call   8016b3 <syscall>
  801b32:	83 c4 18             	add    $0x18,%esp
}
  801b35:	c9                   	leave  
  801b36:	c3                   	ret    

00801b37 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801b37:	55                   	push   %ebp
  801b38:	89 e5                	mov    %esp,%ebp
  801b3a:	83 ec 04             	sub    $0x4,%esp
  801b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b40:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801b43:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801b47:	6a 00                	push   $0x0
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 00                	push   $0x0
  801b4f:	50                   	push   %eax
  801b50:	6a 26                	push   $0x26
  801b52:	e8 5c fb ff ff       	call   8016b3 <syscall>
  801b57:	83 c4 18             	add    $0x18,%esp
	return ;
  801b5a:	90                   	nop
}
  801b5b:	c9                   	leave  
  801b5c:	c3                   	ret    

00801b5d <rsttst>:
void rsttst()
{
  801b5d:	55                   	push   %ebp
  801b5e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801b60:	6a 00                	push   $0x0
  801b62:	6a 00                	push   $0x0
  801b64:	6a 00                	push   $0x0
  801b66:	6a 00                	push   $0x0
  801b68:	6a 00                	push   $0x0
  801b6a:	6a 28                	push   $0x28
  801b6c:	e8 42 fb ff ff       	call   8016b3 <syscall>
  801b71:	83 c4 18             	add    $0x18,%esp
	return ;
  801b74:	90                   	nop
}
  801b75:	c9                   	leave  
  801b76:	c3                   	ret    

00801b77 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801b77:	55                   	push   %ebp
  801b78:	89 e5                	mov    %esp,%ebp
  801b7a:	83 ec 04             	sub    $0x4,%esp
  801b7d:	8b 45 14             	mov    0x14(%ebp),%eax
  801b80:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801b83:	8b 55 18             	mov    0x18(%ebp),%edx
  801b86:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b8a:	52                   	push   %edx
  801b8b:	50                   	push   %eax
  801b8c:	ff 75 10             	pushl  0x10(%ebp)
  801b8f:	ff 75 0c             	pushl  0xc(%ebp)
  801b92:	ff 75 08             	pushl  0x8(%ebp)
  801b95:	6a 27                	push   $0x27
  801b97:	e8 17 fb ff ff       	call   8016b3 <syscall>
  801b9c:	83 c4 18             	add    $0x18,%esp
	return ;
  801b9f:	90                   	nop
}
  801ba0:	c9                   	leave  
  801ba1:	c3                   	ret    

00801ba2 <chktst>:
void chktst(uint32 n)
{
  801ba2:	55                   	push   %ebp
  801ba3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 00                	push   $0x0
  801bad:	ff 75 08             	pushl  0x8(%ebp)
  801bb0:	6a 29                	push   $0x29
  801bb2:	e8 fc fa ff ff       	call   8016b3 <syscall>
  801bb7:	83 c4 18             	add    $0x18,%esp
	return ;
  801bba:	90                   	nop
}
  801bbb:	c9                   	leave  
  801bbc:	c3                   	ret    

00801bbd <inctst>:

void inctst()
{
  801bbd:	55                   	push   %ebp
  801bbe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801bc0:	6a 00                	push   $0x0
  801bc2:	6a 00                	push   $0x0
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 00                	push   $0x0
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 2a                	push   $0x2a
  801bcc:	e8 e2 fa ff ff       	call   8016b3 <syscall>
  801bd1:	83 c4 18             	add    $0x18,%esp
	return ;
  801bd4:	90                   	nop
}
  801bd5:	c9                   	leave  
  801bd6:	c3                   	ret    

00801bd7 <gettst>:
uint32 gettst()
{
  801bd7:	55                   	push   %ebp
  801bd8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 00                	push   $0x0
  801be0:	6a 00                	push   $0x0
  801be2:	6a 00                	push   $0x0
  801be4:	6a 2b                	push   $0x2b
  801be6:	e8 c8 fa ff ff       	call   8016b3 <syscall>
  801beb:	83 c4 18             	add    $0x18,%esp
}
  801bee:	c9                   	leave  
  801bef:	c3                   	ret    

00801bf0 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801bf0:	55                   	push   %ebp
  801bf1:	89 e5                	mov    %esp,%ebp
  801bf3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bf6:	6a 00                	push   $0x0
  801bf8:	6a 00                	push   $0x0
  801bfa:	6a 00                	push   $0x0
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 2c                	push   $0x2c
  801c02:	e8 ac fa ff ff       	call   8016b3 <syscall>
  801c07:	83 c4 18             	add    $0x18,%esp
  801c0a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801c0d:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801c11:	75 07                	jne    801c1a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801c13:	b8 01 00 00 00       	mov    $0x1,%eax
  801c18:	eb 05                	jmp    801c1f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801c1a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c1f:	c9                   	leave  
  801c20:	c3                   	ret    

00801c21 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801c21:	55                   	push   %ebp
  801c22:	89 e5                	mov    %esp,%ebp
  801c24:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c27:	6a 00                	push   $0x0
  801c29:	6a 00                	push   $0x0
  801c2b:	6a 00                	push   $0x0
  801c2d:	6a 00                	push   $0x0
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 2c                	push   $0x2c
  801c33:	e8 7b fa ff ff       	call   8016b3 <syscall>
  801c38:	83 c4 18             	add    $0x18,%esp
  801c3b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801c3e:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801c42:	75 07                	jne    801c4b <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801c44:	b8 01 00 00 00       	mov    $0x1,%eax
  801c49:	eb 05                	jmp    801c50 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801c4b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c50:	c9                   	leave  
  801c51:	c3                   	ret    

00801c52 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801c52:	55                   	push   %ebp
  801c53:	89 e5                	mov    %esp,%ebp
  801c55:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 00                	push   $0x0
  801c60:	6a 00                	push   $0x0
  801c62:	6a 2c                	push   $0x2c
  801c64:	e8 4a fa ff ff       	call   8016b3 <syscall>
  801c69:	83 c4 18             	add    $0x18,%esp
  801c6c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801c6f:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801c73:	75 07                	jne    801c7c <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801c75:	b8 01 00 00 00       	mov    $0x1,%eax
  801c7a:	eb 05                	jmp    801c81 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801c7c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c81:	c9                   	leave  
  801c82:	c3                   	ret    

00801c83 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801c83:	55                   	push   %ebp
  801c84:	89 e5                	mov    %esp,%ebp
  801c86:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 00                	push   $0x0
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 00                	push   $0x0
  801c93:	6a 2c                	push   $0x2c
  801c95:	e8 19 fa ff ff       	call   8016b3 <syscall>
  801c9a:	83 c4 18             	add    $0x18,%esp
  801c9d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801ca0:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801ca4:	75 07                	jne    801cad <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801ca6:	b8 01 00 00 00       	mov    $0x1,%eax
  801cab:	eb 05                	jmp    801cb2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801cad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cb2:	c9                   	leave  
  801cb3:	c3                   	ret    

00801cb4 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801cb4:	55                   	push   %ebp
  801cb5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801cb7:	6a 00                	push   $0x0
  801cb9:	6a 00                	push   $0x0
  801cbb:	6a 00                	push   $0x0
  801cbd:	6a 00                	push   $0x0
  801cbf:	ff 75 08             	pushl  0x8(%ebp)
  801cc2:	6a 2d                	push   $0x2d
  801cc4:	e8 ea f9 ff ff       	call   8016b3 <syscall>
  801cc9:	83 c4 18             	add    $0x18,%esp
	return ;
  801ccc:	90                   	nop
}
  801ccd:	c9                   	leave  
  801cce:	c3                   	ret    

00801ccf <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ccf:	55                   	push   %ebp
  801cd0:	89 e5                	mov    %esp,%ebp
  801cd2:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801cd3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cd6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cd9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cdc:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdf:	6a 00                	push   $0x0
  801ce1:	53                   	push   %ebx
  801ce2:	51                   	push   %ecx
  801ce3:	52                   	push   %edx
  801ce4:	50                   	push   %eax
  801ce5:	6a 2e                	push   $0x2e
  801ce7:	e8 c7 f9 ff ff       	call   8016b3 <syscall>
  801cec:	83 c4 18             	add    $0x18,%esp
}
  801cef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cf2:	c9                   	leave  
  801cf3:	c3                   	ret    

00801cf4 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801cf4:	55                   	push   %ebp
  801cf5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801cf7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cfa:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfd:	6a 00                	push   $0x0
  801cff:	6a 00                	push   $0x0
  801d01:	6a 00                	push   $0x0
  801d03:	52                   	push   %edx
  801d04:	50                   	push   %eax
  801d05:	6a 2f                	push   $0x2f
  801d07:	e8 a7 f9 ff ff       	call   8016b3 <syscall>
  801d0c:	83 c4 18             	add    $0x18,%esp
}
  801d0f:	c9                   	leave  
  801d10:	c3                   	ret    

00801d11 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801d11:	55                   	push   %ebp
  801d12:	89 e5                	mov    %esp,%ebp
  801d14:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801d17:	83 ec 0c             	sub    $0xc,%esp
  801d1a:	68 04 3f 80 00       	push   $0x803f04
  801d1f:	e8 46 e8 ff ff       	call   80056a <cprintf>
  801d24:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801d27:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801d2e:	83 ec 0c             	sub    $0xc,%esp
  801d31:	68 30 3f 80 00       	push   $0x803f30
  801d36:	e8 2f e8 ff ff       	call   80056a <cprintf>
  801d3b:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801d3e:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d42:	a1 38 51 80 00       	mov    0x805138,%eax
  801d47:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d4a:	eb 56                	jmp    801da2 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801d4c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d50:	74 1c                	je     801d6e <print_mem_block_lists+0x5d>
  801d52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d55:	8b 50 08             	mov    0x8(%eax),%edx
  801d58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d5b:	8b 48 08             	mov    0x8(%eax),%ecx
  801d5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d61:	8b 40 0c             	mov    0xc(%eax),%eax
  801d64:	01 c8                	add    %ecx,%eax
  801d66:	39 c2                	cmp    %eax,%edx
  801d68:	73 04                	jae    801d6e <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801d6a:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801d6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d71:	8b 50 08             	mov    0x8(%eax),%edx
  801d74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d77:	8b 40 0c             	mov    0xc(%eax),%eax
  801d7a:	01 c2                	add    %eax,%edx
  801d7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d7f:	8b 40 08             	mov    0x8(%eax),%eax
  801d82:	83 ec 04             	sub    $0x4,%esp
  801d85:	52                   	push   %edx
  801d86:	50                   	push   %eax
  801d87:	68 45 3f 80 00       	push   $0x803f45
  801d8c:	e8 d9 e7 ff ff       	call   80056a <cprintf>
  801d91:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801d94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d97:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d9a:	a1 40 51 80 00       	mov    0x805140,%eax
  801d9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801da2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801da6:	74 07                	je     801daf <print_mem_block_lists+0x9e>
  801da8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dab:	8b 00                	mov    (%eax),%eax
  801dad:	eb 05                	jmp    801db4 <print_mem_block_lists+0xa3>
  801daf:	b8 00 00 00 00       	mov    $0x0,%eax
  801db4:	a3 40 51 80 00       	mov    %eax,0x805140
  801db9:	a1 40 51 80 00       	mov    0x805140,%eax
  801dbe:	85 c0                	test   %eax,%eax
  801dc0:	75 8a                	jne    801d4c <print_mem_block_lists+0x3b>
  801dc2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801dc6:	75 84                	jne    801d4c <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801dc8:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801dcc:	75 10                	jne    801dde <print_mem_block_lists+0xcd>
  801dce:	83 ec 0c             	sub    $0xc,%esp
  801dd1:	68 54 3f 80 00       	push   $0x803f54
  801dd6:	e8 8f e7 ff ff       	call   80056a <cprintf>
  801ddb:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801dde:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801de5:	83 ec 0c             	sub    $0xc,%esp
  801de8:	68 78 3f 80 00       	push   $0x803f78
  801ded:	e8 78 e7 ff ff       	call   80056a <cprintf>
  801df2:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801df5:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801df9:	a1 40 50 80 00       	mov    0x805040,%eax
  801dfe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e01:	eb 56                	jmp    801e59 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e03:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e07:	74 1c                	je     801e25 <print_mem_block_lists+0x114>
  801e09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e0c:	8b 50 08             	mov    0x8(%eax),%edx
  801e0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e12:	8b 48 08             	mov    0x8(%eax),%ecx
  801e15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e18:	8b 40 0c             	mov    0xc(%eax),%eax
  801e1b:	01 c8                	add    %ecx,%eax
  801e1d:	39 c2                	cmp    %eax,%edx
  801e1f:	73 04                	jae    801e25 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801e21:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e28:	8b 50 08             	mov    0x8(%eax),%edx
  801e2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e2e:	8b 40 0c             	mov    0xc(%eax),%eax
  801e31:	01 c2                	add    %eax,%edx
  801e33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e36:	8b 40 08             	mov    0x8(%eax),%eax
  801e39:	83 ec 04             	sub    $0x4,%esp
  801e3c:	52                   	push   %edx
  801e3d:	50                   	push   %eax
  801e3e:	68 45 3f 80 00       	push   $0x803f45
  801e43:	e8 22 e7 ff ff       	call   80056a <cprintf>
  801e48:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801e51:	a1 48 50 80 00       	mov    0x805048,%eax
  801e56:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e59:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e5d:	74 07                	je     801e66 <print_mem_block_lists+0x155>
  801e5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e62:	8b 00                	mov    (%eax),%eax
  801e64:	eb 05                	jmp    801e6b <print_mem_block_lists+0x15a>
  801e66:	b8 00 00 00 00       	mov    $0x0,%eax
  801e6b:	a3 48 50 80 00       	mov    %eax,0x805048
  801e70:	a1 48 50 80 00       	mov    0x805048,%eax
  801e75:	85 c0                	test   %eax,%eax
  801e77:	75 8a                	jne    801e03 <print_mem_block_lists+0xf2>
  801e79:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e7d:	75 84                	jne    801e03 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801e7f:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e83:	75 10                	jne    801e95 <print_mem_block_lists+0x184>
  801e85:	83 ec 0c             	sub    $0xc,%esp
  801e88:	68 90 3f 80 00       	push   $0x803f90
  801e8d:	e8 d8 e6 ff ff       	call   80056a <cprintf>
  801e92:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801e95:	83 ec 0c             	sub    $0xc,%esp
  801e98:	68 04 3f 80 00       	push   $0x803f04
  801e9d:	e8 c8 e6 ff ff       	call   80056a <cprintf>
  801ea2:	83 c4 10             	add    $0x10,%esp

}
  801ea5:	90                   	nop
  801ea6:	c9                   	leave  
  801ea7:	c3                   	ret    

00801ea8 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801ea8:	55                   	push   %ebp
  801ea9:	89 e5                	mov    %esp,%ebp
  801eab:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801eae:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  801eb5:	00 00 00 
  801eb8:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  801ebf:	00 00 00 
  801ec2:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  801ec9:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801ecc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801ed3:	e9 9e 00 00 00       	jmp    801f76 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801ed8:	a1 50 50 80 00       	mov    0x805050,%eax
  801edd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ee0:	c1 e2 04             	shl    $0x4,%edx
  801ee3:	01 d0                	add    %edx,%eax
  801ee5:	85 c0                	test   %eax,%eax
  801ee7:	75 14                	jne    801efd <initialize_MemBlocksList+0x55>
  801ee9:	83 ec 04             	sub    $0x4,%esp
  801eec:	68 b8 3f 80 00       	push   $0x803fb8
  801ef1:	6a 46                	push   $0x46
  801ef3:	68 db 3f 80 00       	push   $0x803fdb
  801ef8:	e8 b9 e3 ff ff       	call   8002b6 <_panic>
  801efd:	a1 50 50 80 00       	mov    0x805050,%eax
  801f02:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f05:	c1 e2 04             	shl    $0x4,%edx
  801f08:	01 d0                	add    %edx,%eax
  801f0a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  801f10:	89 10                	mov    %edx,(%eax)
  801f12:	8b 00                	mov    (%eax),%eax
  801f14:	85 c0                	test   %eax,%eax
  801f16:	74 18                	je     801f30 <initialize_MemBlocksList+0x88>
  801f18:	a1 48 51 80 00       	mov    0x805148,%eax
  801f1d:	8b 15 50 50 80 00    	mov    0x805050,%edx
  801f23:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801f26:	c1 e1 04             	shl    $0x4,%ecx
  801f29:	01 ca                	add    %ecx,%edx
  801f2b:	89 50 04             	mov    %edx,0x4(%eax)
  801f2e:	eb 12                	jmp    801f42 <initialize_MemBlocksList+0x9a>
  801f30:	a1 50 50 80 00       	mov    0x805050,%eax
  801f35:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f38:	c1 e2 04             	shl    $0x4,%edx
  801f3b:	01 d0                	add    %edx,%eax
  801f3d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801f42:	a1 50 50 80 00       	mov    0x805050,%eax
  801f47:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f4a:	c1 e2 04             	shl    $0x4,%edx
  801f4d:	01 d0                	add    %edx,%eax
  801f4f:	a3 48 51 80 00       	mov    %eax,0x805148
  801f54:	a1 50 50 80 00       	mov    0x805050,%eax
  801f59:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f5c:	c1 e2 04             	shl    $0x4,%edx
  801f5f:	01 d0                	add    %edx,%eax
  801f61:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f68:	a1 54 51 80 00       	mov    0x805154,%eax
  801f6d:	40                   	inc    %eax
  801f6e:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801f73:	ff 45 f4             	incl   -0xc(%ebp)
  801f76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f79:	3b 45 08             	cmp    0x8(%ebp),%eax
  801f7c:	0f 82 56 ff ff ff    	jb     801ed8 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801f82:	90                   	nop
  801f83:	c9                   	leave  
  801f84:	c3                   	ret    

00801f85 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801f85:	55                   	push   %ebp
  801f86:	89 e5                	mov    %esp,%ebp
  801f88:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801f8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8e:	8b 00                	mov    (%eax),%eax
  801f90:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f93:	eb 19                	jmp    801fae <find_block+0x29>
	{
		if(va==point->sva)
  801f95:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f98:	8b 40 08             	mov    0x8(%eax),%eax
  801f9b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801f9e:	75 05                	jne    801fa5 <find_block+0x20>
		   return point;
  801fa0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fa3:	eb 36                	jmp    801fdb <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa8:	8b 40 08             	mov    0x8(%eax),%eax
  801fab:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801fae:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801fb2:	74 07                	je     801fbb <find_block+0x36>
  801fb4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fb7:	8b 00                	mov    (%eax),%eax
  801fb9:	eb 05                	jmp    801fc0 <find_block+0x3b>
  801fbb:	b8 00 00 00 00       	mov    $0x0,%eax
  801fc0:	8b 55 08             	mov    0x8(%ebp),%edx
  801fc3:	89 42 08             	mov    %eax,0x8(%edx)
  801fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc9:	8b 40 08             	mov    0x8(%eax),%eax
  801fcc:	85 c0                	test   %eax,%eax
  801fce:	75 c5                	jne    801f95 <find_block+0x10>
  801fd0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801fd4:	75 bf                	jne    801f95 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  801fd6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fdb:	c9                   	leave  
  801fdc:	c3                   	ret    

00801fdd <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  801fdd:	55                   	push   %ebp
  801fde:	89 e5                	mov    %esp,%ebp
  801fe0:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  801fe3:	a1 40 50 80 00       	mov    0x805040,%eax
  801fe8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  801feb:	a1 44 50 80 00       	mov    0x805044,%eax
  801ff0:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  801ff3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ff6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801ff9:	74 24                	je     80201f <insert_sorted_allocList+0x42>
  801ffb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffe:	8b 50 08             	mov    0x8(%eax),%edx
  802001:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802004:	8b 40 08             	mov    0x8(%eax),%eax
  802007:	39 c2                	cmp    %eax,%edx
  802009:	76 14                	jbe    80201f <insert_sorted_allocList+0x42>
  80200b:	8b 45 08             	mov    0x8(%ebp),%eax
  80200e:	8b 50 08             	mov    0x8(%eax),%edx
  802011:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802014:	8b 40 08             	mov    0x8(%eax),%eax
  802017:	39 c2                	cmp    %eax,%edx
  802019:	0f 82 60 01 00 00    	jb     80217f <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  80201f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802023:	75 65                	jne    80208a <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802025:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802029:	75 14                	jne    80203f <insert_sorted_allocList+0x62>
  80202b:	83 ec 04             	sub    $0x4,%esp
  80202e:	68 b8 3f 80 00       	push   $0x803fb8
  802033:	6a 6b                	push   $0x6b
  802035:	68 db 3f 80 00       	push   $0x803fdb
  80203a:	e8 77 e2 ff ff       	call   8002b6 <_panic>
  80203f:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802045:	8b 45 08             	mov    0x8(%ebp),%eax
  802048:	89 10                	mov    %edx,(%eax)
  80204a:	8b 45 08             	mov    0x8(%ebp),%eax
  80204d:	8b 00                	mov    (%eax),%eax
  80204f:	85 c0                	test   %eax,%eax
  802051:	74 0d                	je     802060 <insert_sorted_allocList+0x83>
  802053:	a1 40 50 80 00       	mov    0x805040,%eax
  802058:	8b 55 08             	mov    0x8(%ebp),%edx
  80205b:	89 50 04             	mov    %edx,0x4(%eax)
  80205e:	eb 08                	jmp    802068 <insert_sorted_allocList+0x8b>
  802060:	8b 45 08             	mov    0x8(%ebp),%eax
  802063:	a3 44 50 80 00       	mov    %eax,0x805044
  802068:	8b 45 08             	mov    0x8(%ebp),%eax
  80206b:	a3 40 50 80 00       	mov    %eax,0x805040
  802070:	8b 45 08             	mov    0x8(%ebp),%eax
  802073:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80207a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80207f:	40                   	inc    %eax
  802080:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802085:	e9 dc 01 00 00       	jmp    802266 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  80208a:	8b 45 08             	mov    0x8(%ebp),%eax
  80208d:	8b 50 08             	mov    0x8(%eax),%edx
  802090:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802093:	8b 40 08             	mov    0x8(%eax),%eax
  802096:	39 c2                	cmp    %eax,%edx
  802098:	77 6c                	ja     802106 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  80209a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80209e:	74 06                	je     8020a6 <insert_sorted_allocList+0xc9>
  8020a0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020a4:	75 14                	jne    8020ba <insert_sorted_allocList+0xdd>
  8020a6:	83 ec 04             	sub    $0x4,%esp
  8020a9:	68 f4 3f 80 00       	push   $0x803ff4
  8020ae:	6a 6f                	push   $0x6f
  8020b0:	68 db 3f 80 00       	push   $0x803fdb
  8020b5:	e8 fc e1 ff ff       	call   8002b6 <_panic>
  8020ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020bd:	8b 50 04             	mov    0x4(%eax),%edx
  8020c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c3:	89 50 04             	mov    %edx,0x4(%eax)
  8020c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8020cc:	89 10                	mov    %edx,(%eax)
  8020ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020d1:	8b 40 04             	mov    0x4(%eax),%eax
  8020d4:	85 c0                	test   %eax,%eax
  8020d6:	74 0d                	je     8020e5 <insert_sorted_allocList+0x108>
  8020d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020db:	8b 40 04             	mov    0x4(%eax),%eax
  8020de:	8b 55 08             	mov    0x8(%ebp),%edx
  8020e1:	89 10                	mov    %edx,(%eax)
  8020e3:	eb 08                	jmp    8020ed <insert_sorted_allocList+0x110>
  8020e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e8:	a3 40 50 80 00       	mov    %eax,0x805040
  8020ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8020f3:	89 50 04             	mov    %edx,0x4(%eax)
  8020f6:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8020fb:	40                   	inc    %eax
  8020fc:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802101:	e9 60 01 00 00       	jmp    802266 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802106:	8b 45 08             	mov    0x8(%ebp),%eax
  802109:	8b 50 08             	mov    0x8(%eax),%edx
  80210c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80210f:	8b 40 08             	mov    0x8(%eax),%eax
  802112:	39 c2                	cmp    %eax,%edx
  802114:	0f 82 4c 01 00 00    	jb     802266 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  80211a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80211e:	75 14                	jne    802134 <insert_sorted_allocList+0x157>
  802120:	83 ec 04             	sub    $0x4,%esp
  802123:	68 2c 40 80 00       	push   $0x80402c
  802128:	6a 73                	push   $0x73
  80212a:	68 db 3f 80 00       	push   $0x803fdb
  80212f:	e8 82 e1 ff ff       	call   8002b6 <_panic>
  802134:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80213a:	8b 45 08             	mov    0x8(%ebp),%eax
  80213d:	89 50 04             	mov    %edx,0x4(%eax)
  802140:	8b 45 08             	mov    0x8(%ebp),%eax
  802143:	8b 40 04             	mov    0x4(%eax),%eax
  802146:	85 c0                	test   %eax,%eax
  802148:	74 0c                	je     802156 <insert_sorted_allocList+0x179>
  80214a:	a1 44 50 80 00       	mov    0x805044,%eax
  80214f:	8b 55 08             	mov    0x8(%ebp),%edx
  802152:	89 10                	mov    %edx,(%eax)
  802154:	eb 08                	jmp    80215e <insert_sorted_allocList+0x181>
  802156:	8b 45 08             	mov    0x8(%ebp),%eax
  802159:	a3 40 50 80 00       	mov    %eax,0x805040
  80215e:	8b 45 08             	mov    0x8(%ebp),%eax
  802161:	a3 44 50 80 00       	mov    %eax,0x805044
  802166:	8b 45 08             	mov    0x8(%ebp),%eax
  802169:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80216f:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802174:	40                   	inc    %eax
  802175:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80217a:	e9 e7 00 00 00       	jmp    802266 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  80217f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802182:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802185:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80218c:	a1 40 50 80 00       	mov    0x805040,%eax
  802191:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802194:	e9 9d 00 00 00       	jmp    802236 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802199:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219c:	8b 00                	mov    (%eax),%eax
  80219e:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8021a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a4:	8b 50 08             	mov    0x8(%eax),%edx
  8021a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021aa:	8b 40 08             	mov    0x8(%eax),%eax
  8021ad:	39 c2                	cmp    %eax,%edx
  8021af:	76 7d                	jbe    80222e <insert_sorted_allocList+0x251>
  8021b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b4:	8b 50 08             	mov    0x8(%eax),%edx
  8021b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8021ba:	8b 40 08             	mov    0x8(%eax),%eax
  8021bd:	39 c2                	cmp    %eax,%edx
  8021bf:	73 6d                	jae    80222e <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8021c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021c5:	74 06                	je     8021cd <insert_sorted_allocList+0x1f0>
  8021c7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021cb:	75 14                	jne    8021e1 <insert_sorted_allocList+0x204>
  8021cd:	83 ec 04             	sub    $0x4,%esp
  8021d0:	68 50 40 80 00       	push   $0x804050
  8021d5:	6a 7f                	push   $0x7f
  8021d7:	68 db 3f 80 00       	push   $0x803fdb
  8021dc:	e8 d5 e0 ff ff       	call   8002b6 <_panic>
  8021e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e4:	8b 10                	mov    (%eax),%edx
  8021e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e9:	89 10                	mov    %edx,(%eax)
  8021eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ee:	8b 00                	mov    (%eax),%eax
  8021f0:	85 c0                	test   %eax,%eax
  8021f2:	74 0b                	je     8021ff <insert_sorted_allocList+0x222>
  8021f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f7:	8b 00                	mov    (%eax),%eax
  8021f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8021fc:	89 50 04             	mov    %edx,0x4(%eax)
  8021ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802202:	8b 55 08             	mov    0x8(%ebp),%edx
  802205:	89 10                	mov    %edx,(%eax)
  802207:	8b 45 08             	mov    0x8(%ebp),%eax
  80220a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80220d:	89 50 04             	mov    %edx,0x4(%eax)
  802210:	8b 45 08             	mov    0x8(%ebp),%eax
  802213:	8b 00                	mov    (%eax),%eax
  802215:	85 c0                	test   %eax,%eax
  802217:	75 08                	jne    802221 <insert_sorted_allocList+0x244>
  802219:	8b 45 08             	mov    0x8(%ebp),%eax
  80221c:	a3 44 50 80 00       	mov    %eax,0x805044
  802221:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802226:	40                   	inc    %eax
  802227:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  80222c:	eb 39                	jmp    802267 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80222e:	a1 48 50 80 00       	mov    0x805048,%eax
  802233:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802236:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80223a:	74 07                	je     802243 <insert_sorted_allocList+0x266>
  80223c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223f:	8b 00                	mov    (%eax),%eax
  802241:	eb 05                	jmp    802248 <insert_sorted_allocList+0x26b>
  802243:	b8 00 00 00 00       	mov    $0x0,%eax
  802248:	a3 48 50 80 00       	mov    %eax,0x805048
  80224d:	a1 48 50 80 00       	mov    0x805048,%eax
  802252:	85 c0                	test   %eax,%eax
  802254:	0f 85 3f ff ff ff    	jne    802199 <insert_sorted_allocList+0x1bc>
  80225a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80225e:	0f 85 35 ff ff ff    	jne    802199 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802264:	eb 01                	jmp    802267 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802266:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802267:	90                   	nop
  802268:	c9                   	leave  
  802269:	c3                   	ret    

0080226a <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80226a:	55                   	push   %ebp
  80226b:	89 e5                	mov    %esp,%ebp
  80226d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802270:	a1 38 51 80 00       	mov    0x805138,%eax
  802275:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802278:	e9 85 01 00 00       	jmp    802402 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  80227d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802280:	8b 40 0c             	mov    0xc(%eax),%eax
  802283:	3b 45 08             	cmp    0x8(%ebp),%eax
  802286:	0f 82 6e 01 00 00    	jb     8023fa <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  80228c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228f:	8b 40 0c             	mov    0xc(%eax),%eax
  802292:	3b 45 08             	cmp    0x8(%ebp),%eax
  802295:	0f 85 8a 00 00 00    	jne    802325 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  80229b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80229f:	75 17                	jne    8022b8 <alloc_block_FF+0x4e>
  8022a1:	83 ec 04             	sub    $0x4,%esp
  8022a4:	68 84 40 80 00       	push   $0x804084
  8022a9:	68 93 00 00 00       	push   $0x93
  8022ae:	68 db 3f 80 00       	push   $0x803fdb
  8022b3:	e8 fe df ff ff       	call   8002b6 <_panic>
  8022b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022bb:	8b 00                	mov    (%eax),%eax
  8022bd:	85 c0                	test   %eax,%eax
  8022bf:	74 10                	je     8022d1 <alloc_block_FF+0x67>
  8022c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c4:	8b 00                	mov    (%eax),%eax
  8022c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022c9:	8b 52 04             	mov    0x4(%edx),%edx
  8022cc:	89 50 04             	mov    %edx,0x4(%eax)
  8022cf:	eb 0b                	jmp    8022dc <alloc_block_FF+0x72>
  8022d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d4:	8b 40 04             	mov    0x4(%eax),%eax
  8022d7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8022dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022df:	8b 40 04             	mov    0x4(%eax),%eax
  8022e2:	85 c0                	test   %eax,%eax
  8022e4:	74 0f                	je     8022f5 <alloc_block_FF+0x8b>
  8022e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e9:	8b 40 04             	mov    0x4(%eax),%eax
  8022ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022ef:	8b 12                	mov    (%edx),%edx
  8022f1:	89 10                	mov    %edx,(%eax)
  8022f3:	eb 0a                	jmp    8022ff <alloc_block_FF+0x95>
  8022f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f8:	8b 00                	mov    (%eax),%eax
  8022fa:	a3 38 51 80 00       	mov    %eax,0x805138
  8022ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802302:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802308:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802312:	a1 44 51 80 00       	mov    0x805144,%eax
  802317:	48                   	dec    %eax
  802318:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  80231d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802320:	e9 10 01 00 00       	jmp    802435 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802325:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802328:	8b 40 0c             	mov    0xc(%eax),%eax
  80232b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80232e:	0f 86 c6 00 00 00    	jbe    8023fa <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802334:	a1 48 51 80 00       	mov    0x805148,%eax
  802339:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  80233c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233f:	8b 50 08             	mov    0x8(%eax),%edx
  802342:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802345:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802348:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80234b:	8b 55 08             	mov    0x8(%ebp),%edx
  80234e:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802351:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802355:	75 17                	jne    80236e <alloc_block_FF+0x104>
  802357:	83 ec 04             	sub    $0x4,%esp
  80235a:	68 84 40 80 00       	push   $0x804084
  80235f:	68 9b 00 00 00       	push   $0x9b
  802364:	68 db 3f 80 00       	push   $0x803fdb
  802369:	e8 48 df ff ff       	call   8002b6 <_panic>
  80236e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802371:	8b 00                	mov    (%eax),%eax
  802373:	85 c0                	test   %eax,%eax
  802375:	74 10                	je     802387 <alloc_block_FF+0x11d>
  802377:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80237a:	8b 00                	mov    (%eax),%eax
  80237c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80237f:	8b 52 04             	mov    0x4(%edx),%edx
  802382:	89 50 04             	mov    %edx,0x4(%eax)
  802385:	eb 0b                	jmp    802392 <alloc_block_FF+0x128>
  802387:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80238a:	8b 40 04             	mov    0x4(%eax),%eax
  80238d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802392:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802395:	8b 40 04             	mov    0x4(%eax),%eax
  802398:	85 c0                	test   %eax,%eax
  80239a:	74 0f                	je     8023ab <alloc_block_FF+0x141>
  80239c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80239f:	8b 40 04             	mov    0x4(%eax),%eax
  8023a2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023a5:	8b 12                	mov    (%edx),%edx
  8023a7:	89 10                	mov    %edx,(%eax)
  8023a9:	eb 0a                	jmp    8023b5 <alloc_block_FF+0x14b>
  8023ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ae:	8b 00                	mov    (%eax),%eax
  8023b0:	a3 48 51 80 00       	mov    %eax,0x805148
  8023b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023c1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023c8:	a1 54 51 80 00       	mov    0x805154,%eax
  8023cd:	48                   	dec    %eax
  8023ce:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  8023d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d6:	8b 50 08             	mov    0x8(%eax),%edx
  8023d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023dc:	01 c2                	add    %eax,%edx
  8023de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e1:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8023e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e7:	8b 40 0c             	mov    0xc(%eax),%eax
  8023ea:	2b 45 08             	sub    0x8(%ebp),%eax
  8023ed:	89 c2                	mov    %eax,%edx
  8023ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f2:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8023f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023f8:	eb 3b                	jmp    802435 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8023fa:	a1 40 51 80 00       	mov    0x805140,%eax
  8023ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802402:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802406:	74 07                	je     80240f <alloc_block_FF+0x1a5>
  802408:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240b:	8b 00                	mov    (%eax),%eax
  80240d:	eb 05                	jmp    802414 <alloc_block_FF+0x1aa>
  80240f:	b8 00 00 00 00       	mov    $0x0,%eax
  802414:	a3 40 51 80 00       	mov    %eax,0x805140
  802419:	a1 40 51 80 00       	mov    0x805140,%eax
  80241e:	85 c0                	test   %eax,%eax
  802420:	0f 85 57 fe ff ff    	jne    80227d <alloc_block_FF+0x13>
  802426:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80242a:	0f 85 4d fe ff ff    	jne    80227d <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802430:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802435:	c9                   	leave  
  802436:	c3                   	ret    

00802437 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802437:	55                   	push   %ebp
  802438:	89 e5                	mov    %esp,%ebp
  80243a:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  80243d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802444:	a1 38 51 80 00       	mov    0x805138,%eax
  802449:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80244c:	e9 df 00 00 00       	jmp    802530 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802451:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802454:	8b 40 0c             	mov    0xc(%eax),%eax
  802457:	3b 45 08             	cmp    0x8(%ebp),%eax
  80245a:	0f 82 c8 00 00 00    	jb     802528 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802460:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802463:	8b 40 0c             	mov    0xc(%eax),%eax
  802466:	3b 45 08             	cmp    0x8(%ebp),%eax
  802469:	0f 85 8a 00 00 00    	jne    8024f9 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  80246f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802473:	75 17                	jne    80248c <alloc_block_BF+0x55>
  802475:	83 ec 04             	sub    $0x4,%esp
  802478:	68 84 40 80 00       	push   $0x804084
  80247d:	68 b7 00 00 00       	push   $0xb7
  802482:	68 db 3f 80 00       	push   $0x803fdb
  802487:	e8 2a de ff ff       	call   8002b6 <_panic>
  80248c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248f:	8b 00                	mov    (%eax),%eax
  802491:	85 c0                	test   %eax,%eax
  802493:	74 10                	je     8024a5 <alloc_block_BF+0x6e>
  802495:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802498:	8b 00                	mov    (%eax),%eax
  80249a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80249d:	8b 52 04             	mov    0x4(%edx),%edx
  8024a0:	89 50 04             	mov    %edx,0x4(%eax)
  8024a3:	eb 0b                	jmp    8024b0 <alloc_block_BF+0x79>
  8024a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a8:	8b 40 04             	mov    0x4(%eax),%eax
  8024ab:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8024b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b3:	8b 40 04             	mov    0x4(%eax),%eax
  8024b6:	85 c0                	test   %eax,%eax
  8024b8:	74 0f                	je     8024c9 <alloc_block_BF+0x92>
  8024ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bd:	8b 40 04             	mov    0x4(%eax),%eax
  8024c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024c3:	8b 12                	mov    (%edx),%edx
  8024c5:	89 10                	mov    %edx,(%eax)
  8024c7:	eb 0a                	jmp    8024d3 <alloc_block_BF+0x9c>
  8024c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cc:	8b 00                	mov    (%eax),%eax
  8024ce:	a3 38 51 80 00       	mov    %eax,0x805138
  8024d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024df:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024e6:	a1 44 51 80 00       	mov    0x805144,%eax
  8024eb:	48                   	dec    %eax
  8024ec:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  8024f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f4:	e9 4d 01 00 00       	jmp    802646 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8024f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fc:	8b 40 0c             	mov    0xc(%eax),%eax
  8024ff:	3b 45 08             	cmp    0x8(%ebp),%eax
  802502:	76 24                	jbe    802528 <alloc_block_BF+0xf1>
  802504:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802507:	8b 40 0c             	mov    0xc(%eax),%eax
  80250a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80250d:	73 19                	jae    802528 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  80250f:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802516:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802519:	8b 40 0c             	mov    0xc(%eax),%eax
  80251c:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  80251f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802522:	8b 40 08             	mov    0x8(%eax),%eax
  802525:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802528:	a1 40 51 80 00       	mov    0x805140,%eax
  80252d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802530:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802534:	74 07                	je     80253d <alloc_block_BF+0x106>
  802536:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802539:	8b 00                	mov    (%eax),%eax
  80253b:	eb 05                	jmp    802542 <alloc_block_BF+0x10b>
  80253d:	b8 00 00 00 00       	mov    $0x0,%eax
  802542:	a3 40 51 80 00       	mov    %eax,0x805140
  802547:	a1 40 51 80 00       	mov    0x805140,%eax
  80254c:	85 c0                	test   %eax,%eax
  80254e:	0f 85 fd fe ff ff    	jne    802451 <alloc_block_BF+0x1a>
  802554:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802558:	0f 85 f3 fe ff ff    	jne    802451 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  80255e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802562:	0f 84 d9 00 00 00    	je     802641 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802568:	a1 48 51 80 00       	mov    0x805148,%eax
  80256d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802570:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802573:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802576:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802579:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80257c:	8b 55 08             	mov    0x8(%ebp),%edx
  80257f:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802582:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802586:	75 17                	jne    80259f <alloc_block_BF+0x168>
  802588:	83 ec 04             	sub    $0x4,%esp
  80258b:	68 84 40 80 00       	push   $0x804084
  802590:	68 c7 00 00 00       	push   $0xc7
  802595:	68 db 3f 80 00       	push   $0x803fdb
  80259a:	e8 17 dd ff ff       	call   8002b6 <_panic>
  80259f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025a2:	8b 00                	mov    (%eax),%eax
  8025a4:	85 c0                	test   %eax,%eax
  8025a6:	74 10                	je     8025b8 <alloc_block_BF+0x181>
  8025a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025ab:	8b 00                	mov    (%eax),%eax
  8025ad:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025b0:	8b 52 04             	mov    0x4(%edx),%edx
  8025b3:	89 50 04             	mov    %edx,0x4(%eax)
  8025b6:	eb 0b                	jmp    8025c3 <alloc_block_BF+0x18c>
  8025b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025bb:	8b 40 04             	mov    0x4(%eax),%eax
  8025be:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8025c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025c6:	8b 40 04             	mov    0x4(%eax),%eax
  8025c9:	85 c0                	test   %eax,%eax
  8025cb:	74 0f                	je     8025dc <alloc_block_BF+0x1a5>
  8025cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025d0:	8b 40 04             	mov    0x4(%eax),%eax
  8025d3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025d6:	8b 12                	mov    (%edx),%edx
  8025d8:	89 10                	mov    %edx,(%eax)
  8025da:	eb 0a                	jmp    8025e6 <alloc_block_BF+0x1af>
  8025dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025df:	8b 00                	mov    (%eax),%eax
  8025e1:	a3 48 51 80 00       	mov    %eax,0x805148
  8025e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025f2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025f9:	a1 54 51 80 00       	mov    0x805154,%eax
  8025fe:	48                   	dec    %eax
  8025ff:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802604:	83 ec 08             	sub    $0x8,%esp
  802607:	ff 75 ec             	pushl  -0x14(%ebp)
  80260a:	68 38 51 80 00       	push   $0x805138
  80260f:	e8 71 f9 ff ff       	call   801f85 <find_block>
  802614:	83 c4 10             	add    $0x10,%esp
  802617:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  80261a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80261d:	8b 50 08             	mov    0x8(%eax),%edx
  802620:	8b 45 08             	mov    0x8(%ebp),%eax
  802623:	01 c2                	add    %eax,%edx
  802625:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802628:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  80262b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80262e:	8b 40 0c             	mov    0xc(%eax),%eax
  802631:	2b 45 08             	sub    0x8(%ebp),%eax
  802634:	89 c2                	mov    %eax,%edx
  802636:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802639:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  80263c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80263f:	eb 05                	jmp    802646 <alloc_block_BF+0x20f>
	}
	return NULL;
  802641:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802646:	c9                   	leave  
  802647:	c3                   	ret    

00802648 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802648:	55                   	push   %ebp
  802649:	89 e5                	mov    %esp,%ebp
  80264b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  80264e:	a1 28 50 80 00       	mov    0x805028,%eax
  802653:	85 c0                	test   %eax,%eax
  802655:	0f 85 de 01 00 00    	jne    802839 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80265b:	a1 38 51 80 00       	mov    0x805138,%eax
  802660:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802663:	e9 9e 01 00 00       	jmp    802806 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802668:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266b:	8b 40 0c             	mov    0xc(%eax),%eax
  80266e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802671:	0f 82 87 01 00 00    	jb     8027fe <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802677:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267a:	8b 40 0c             	mov    0xc(%eax),%eax
  80267d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802680:	0f 85 95 00 00 00    	jne    80271b <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802686:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80268a:	75 17                	jne    8026a3 <alloc_block_NF+0x5b>
  80268c:	83 ec 04             	sub    $0x4,%esp
  80268f:	68 84 40 80 00       	push   $0x804084
  802694:	68 e0 00 00 00       	push   $0xe0
  802699:	68 db 3f 80 00       	push   $0x803fdb
  80269e:	e8 13 dc ff ff       	call   8002b6 <_panic>
  8026a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a6:	8b 00                	mov    (%eax),%eax
  8026a8:	85 c0                	test   %eax,%eax
  8026aa:	74 10                	je     8026bc <alloc_block_NF+0x74>
  8026ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026af:	8b 00                	mov    (%eax),%eax
  8026b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026b4:	8b 52 04             	mov    0x4(%edx),%edx
  8026b7:	89 50 04             	mov    %edx,0x4(%eax)
  8026ba:	eb 0b                	jmp    8026c7 <alloc_block_NF+0x7f>
  8026bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bf:	8b 40 04             	mov    0x4(%eax),%eax
  8026c2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8026c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ca:	8b 40 04             	mov    0x4(%eax),%eax
  8026cd:	85 c0                	test   %eax,%eax
  8026cf:	74 0f                	je     8026e0 <alloc_block_NF+0x98>
  8026d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d4:	8b 40 04             	mov    0x4(%eax),%eax
  8026d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026da:	8b 12                	mov    (%edx),%edx
  8026dc:	89 10                	mov    %edx,(%eax)
  8026de:	eb 0a                	jmp    8026ea <alloc_block_NF+0xa2>
  8026e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e3:	8b 00                	mov    (%eax),%eax
  8026e5:	a3 38 51 80 00       	mov    %eax,0x805138
  8026ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026fd:	a1 44 51 80 00       	mov    0x805144,%eax
  802702:	48                   	dec    %eax
  802703:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802708:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270b:	8b 40 08             	mov    0x8(%eax),%eax
  80270e:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802713:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802716:	e9 f8 04 00 00       	jmp    802c13 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  80271b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271e:	8b 40 0c             	mov    0xc(%eax),%eax
  802721:	3b 45 08             	cmp    0x8(%ebp),%eax
  802724:	0f 86 d4 00 00 00    	jbe    8027fe <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80272a:	a1 48 51 80 00       	mov    0x805148,%eax
  80272f:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802732:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802735:	8b 50 08             	mov    0x8(%eax),%edx
  802738:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80273b:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  80273e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802741:	8b 55 08             	mov    0x8(%ebp),%edx
  802744:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802747:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80274b:	75 17                	jne    802764 <alloc_block_NF+0x11c>
  80274d:	83 ec 04             	sub    $0x4,%esp
  802750:	68 84 40 80 00       	push   $0x804084
  802755:	68 e9 00 00 00       	push   $0xe9
  80275a:	68 db 3f 80 00       	push   $0x803fdb
  80275f:	e8 52 db ff ff       	call   8002b6 <_panic>
  802764:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802767:	8b 00                	mov    (%eax),%eax
  802769:	85 c0                	test   %eax,%eax
  80276b:	74 10                	je     80277d <alloc_block_NF+0x135>
  80276d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802770:	8b 00                	mov    (%eax),%eax
  802772:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802775:	8b 52 04             	mov    0x4(%edx),%edx
  802778:	89 50 04             	mov    %edx,0x4(%eax)
  80277b:	eb 0b                	jmp    802788 <alloc_block_NF+0x140>
  80277d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802780:	8b 40 04             	mov    0x4(%eax),%eax
  802783:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802788:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80278b:	8b 40 04             	mov    0x4(%eax),%eax
  80278e:	85 c0                	test   %eax,%eax
  802790:	74 0f                	je     8027a1 <alloc_block_NF+0x159>
  802792:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802795:	8b 40 04             	mov    0x4(%eax),%eax
  802798:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80279b:	8b 12                	mov    (%edx),%edx
  80279d:	89 10                	mov    %edx,(%eax)
  80279f:	eb 0a                	jmp    8027ab <alloc_block_NF+0x163>
  8027a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027a4:	8b 00                	mov    (%eax),%eax
  8027a6:	a3 48 51 80 00       	mov    %eax,0x805148
  8027ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027b7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027be:	a1 54 51 80 00       	mov    0x805154,%eax
  8027c3:	48                   	dec    %eax
  8027c4:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  8027c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027cc:	8b 40 08             	mov    0x8(%eax),%eax
  8027cf:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  8027d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d7:	8b 50 08             	mov    0x8(%eax),%edx
  8027da:	8b 45 08             	mov    0x8(%ebp),%eax
  8027dd:	01 c2                	add    %eax,%edx
  8027df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e2:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  8027e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e8:	8b 40 0c             	mov    0xc(%eax),%eax
  8027eb:	2b 45 08             	sub    0x8(%ebp),%eax
  8027ee:	89 c2                	mov    %eax,%edx
  8027f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f3:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8027f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f9:	e9 15 04 00 00       	jmp    802c13 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8027fe:	a1 40 51 80 00       	mov    0x805140,%eax
  802803:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802806:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80280a:	74 07                	je     802813 <alloc_block_NF+0x1cb>
  80280c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280f:	8b 00                	mov    (%eax),%eax
  802811:	eb 05                	jmp    802818 <alloc_block_NF+0x1d0>
  802813:	b8 00 00 00 00       	mov    $0x0,%eax
  802818:	a3 40 51 80 00       	mov    %eax,0x805140
  80281d:	a1 40 51 80 00       	mov    0x805140,%eax
  802822:	85 c0                	test   %eax,%eax
  802824:	0f 85 3e fe ff ff    	jne    802668 <alloc_block_NF+0x20>
  80282a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80282e:	0f 85 34 fe ff ff    	jne    802668 <alloc_block_NF+0x20>
  802834:	e9 d5 03 00 00       	jmp    802c0e <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802839:	a1 38 51 80 00       	mov    0x805138,%eax
  80283e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802841:	e9 b1 01 00 00       	jmp    8029f7 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802846:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802849:	8b 50 08             	mov    0x8(%eax),%edx
  80284c:	a1 28 50 80 00       	mov    0x805028,%eax
  802851:	39 c2                	cmp    %eax,%edx
  802853:	0f 82 96 01 00 00    	jb     8029ef <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802859:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285c:	8b 40 0c             	mov    0xc(%eax),%eax
  80285f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802862:	0f 82 87 01 00 00    	jb     8029ef <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802868:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286b:	8b 40 0c             	mov    0xc(%eax),%eax
  80286e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802871:	0f 85 95 00 00 00    	jne    80290c <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802877:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80287b:	75 17                	jne    802894 <alloc_block_NF+0x24c>
  80287d:	83 ec 04             	sub    $0x4,%esp
  802880:	68 84 40 80 00       	push   $0x804084
  802885:	68 fc 00 00 00       	push   $0xfc
  80288a:	68 db 3f 80 00       	push   $0x803fdb
  80288f:	e8 22 da ff ff       	call   8002b6 <_panic>
  802894:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802897:	8b 00                	mov    (%eax),%eax
  802899:	85 c0                	test   %eax,%eax
  80289b:	74 10                	je     8028ad <alloc_block_NF+0x265>
  80289d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a0:	8b 00                	mov    (%eax),%eax
  8028a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028a5:	8b 52 04             	mov    0x4(%edx),%edx
  8028a8:	89 50 04             	mov    %edx,0x4(%eax)
  8028ab:	eb 0b                	jmp    8028b8 <alloc_block_NF+0x270>
  8028ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b0:	8b 40 04             	mov    0x4(%eax),%eax
  8028b3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8028b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bb:	8b 40 04             	mov    0x4(%eax),%eax
  8028be:	85 c0                	test   %eax,%eax
  8028c0:	74 0f                	je     8028d1 <alloc_block_NF+0x289>
  8028c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c5:	8b 40 04             	mov    0x4(%eax),%eax
  8028c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028cb:	8b 12                	mov    (%edx),%edx
  8028cd:	89 10                	mov    %edx,(%eax)
  8028cf:	eb 0a                	jmp    8028db <alloc_block_NF+0x293>
  8028d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d4:	8b 00                	mov    (%eax),%eax
  8028d6:	a3 38 51 80 00       	mov    %eax,0x805138
  8028db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028ee:	a1 44 51 80 00       	mov    0x805144,%eax
  8028f3:	48                   	dec    %eax
  8028f4:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8028f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fc:	8b 40 08             	mov    0x8(%eax),%eax
  8028ff:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802904:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802907:	e9 07 03 00 00       	jmp    802c13 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  80290c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290f:	8b 40 0c             	mov    0xc(%eax),%eax
  802912:	3b 45 08             	cmp    0x8(%ebp),%eax
  802915:	0f 86 d4 00 00 00    	jbe    8029ef <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80291b:	a1 48 51 80 00       	mov    0x805148,%eax
  802920:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802923:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802926:	8b 50 08             	mov    0x8(%eax),%edx
  802929:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80292c:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  80292f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802932:	8b 55 08             	mov    0x8(%ebp),%edx
  802935:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802938:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80293c:	75 17                	jne    802955 <alloc_block_NF+0x30d>
  80293e:	83 ec 04             	sub    $0x4,%esp
  802941:	68 84 40 80 00       	push   $0x804084
  802946:	68 04 01 00 00       	push   $0x104
  80294b:	68 db 3f 80 00       	push   $0x803fdb
  802950:	e8 61 d9 ff ff       	call   8002b6 <_panic>
  802955:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802958:	8b 00                	mov    (%eax),%eax
  80295a:	85 c0                	test   %eax,%eax
  80295c:	74 10                	je     80296e <alloc_block_NF+0x326>
  80295e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802961:	8b 00                	mov    (%eax),%eax
  802963:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802966:	8b 52 04             	mov    0x4(%edx),%edx
  802969:	89 50 04             	mov    %edx,0x4(%eax)
  80296c:	eb 0b                	jmp    802979 <alloc_block_NF+0x331>
  80296e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802971:	8b 40 04             	mov    0x4(%eax),%eax
  802974:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802979:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80297c:	8b 40 04             	mov    0x4(%eax),%eax
  80297f:	85 c0                	test   %eax,%eax
  802981:	74 0f                	je     802992 <alloc_block_NF+0x34a>
  802983:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802986:	8b 40 04             	mov    0x4(%eax),%eax
  802989:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80298c:	8b 12                	mov    (%edx),%edx
  80298e:	89 10                	mov    %edx,(%eax)
  802990:	eb 0a                	jmp    80299c <alloc_block_NF+0x354>
  802992:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802995:	8b 00                	mov    (%eax),%eax
  802997:	a3 48 51 80 00       	mov    %eax,0x805148
  80299c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80299f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029a8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029af:	a1 54 51 80 00       	mov    0x805154,%eax
  8029b4:	48                   	dec    %eax
  8029b5:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  8029ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029bd:	8b 40 08             	mov    0x8(%eax),%eax
  8029c0:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  8029c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c8:	8b 50 08             	mov    0x8(%eax),%edx
  8029cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ce:	01 c2                	add    %eax,%edx
  8029d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d3:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8029d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d9:	8b 40 0c             	mov    0xc(%eax),%eax
  8029dc:	2b 45 08             	sub    0x8(%ebp),%eax
  8029df:	89 c2                	mov    %eax,%edx
  8029e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e4:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8029e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029ea:	e9 24 02 00 00       	jmp    802c13 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8029ef:	a1 40 51 80 00       	mov    0x805140,%eax
  8029f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029fb:	74 07                	je     802a04 <alloc_block_NF+0x3bc>
  8029fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a00:	8b 00                	mov    (%eax),%eax
  802a02:	eb 05                	jmp    802a09 <alloc_block_NF+0x3c1>
  802a04:	b8 00 00 00 00       	mov    $0x0,%eax
  802a09:	a3 40 51 80 00       	mov    %eax,0x805140
  802a0e:	a1 40 51 80 00       	mov    0x805140,%eax
  802a13:	85 c0                	test   %eax,%eax
  802a15:	0f 85 2b fe ff ff    	jne    802846 <alloc_block_NF+0x1fe>
  802a1b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a1f:	0f 85 21 fe ff ff    	jne    802846 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a25:	a1 38 51 80 00       	mov    0x805138,%eax
  802a2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a2d:	e9 ae 01 00 00       	jmp    802be0 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802a32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a35:	8b 50 08             	mov    0x8(%eax),%edx
  802a38:	a1 28 50 80 00       	mov    0x805028,%eax
  802a3d:	39 c2                	cmp    %eax,%edx
  802a3f:	0f 83 93 01 00 00    	jae    802bd8 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802a45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a48:	8b 40 0c             	mov    0xc(%eax),%eax
  802a4b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a4e:	0f 82 84 01 00 00    	jb     802bd8 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802a54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a57:	8b 40 0c             	mov    0xc(%eax),%eax
  802a5a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a5d:	0f 85 95 00 00 00    	jne    802af8 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802a63:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a67:	75 17                	jne    802a80 <alloc_block_NF+0x438>
  802a69:	83 ec 04             	sub    $0x4,%esp
  802a6c:	68 84 40 80 00       	push   $0x804084
  802a71:	68 14 01 00 00       	push   $0x114
  802a76:	68 db 3f 80 00       	push   $0x803fdb
  802a7b:	e8 36 d8 ff ff       	call   8002b6 <_panic>
  802a80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a83:	8b 00                	mov    (%eax),%eax
  802a85:	85 c0                	test   %eax,%eax
  802a87:	74 10                	je     802a99 <alloc_block_NF+0x451>
  802a89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8c:	8b 00                	mov    (%eax),%eax
  802a8e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a91:	8b 52 04             	mov    0x4(%edx),%edx
  802a94:	89 50 04             	mov    %edx,0x4(%eax)
  802a97:	eb 0b                	jmp    802aa4 <alloc_block_NF+0x45c>
  802a99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9c:	8b 40 04             	mov    0x4(%eax),%eax
  802a9f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802aa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa7:	8b 40 04             	mov    0x4(%eax),%eax
  802aaa:	85 c0                	test   %eax,%eax
  802aac:	74 0f                	je     802abd <alloc_block_NF+0x475>
  802aae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab1:	8b 40 04             	mov    0x4(%eax),%eax
  802ab4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ab7:	8b 12                	mov    (%edx),%edx
  802ab9:	89 10                	mov    %edx,(%eax)
  802abb:	eb 0a                	jmp    802ac7 <alloc_block_NF+0x47f>
  802abd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac0:	8b 00                	mov    (%eax),%eax
  802ac2:	a3 38 51 80 00       	mov    %eax,0x805138
  802ac7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ad0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ada:	a1 44 51 80 00       	mov    0x805144,%eax
  802adf:	48                   	dec    %eax
  802ae0:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802ae5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae8:	8b 40 08             	mov    0x8(%eax),%eax
  802aeb:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802af0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af3:	e9 1b 01 00 00       	jmp    802c13 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802af8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afb:	8b 40 0c             	mov    0xc(%eax),%eax
  802afe:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b01:	0f 86 d1 00 00 00    	jbe    802bd8 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b07:	a1 48 51 80 00       	mov    0x805148,%eax
  802b0c:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802b0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b12:	8b 50 08             	mov    0x8(%eax),%edx
  802b15:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b18:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802b1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b1e:	8b 55 08             	mov    0x8(%ebp),%edx
  802b21:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b24:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b28:	75 17                	jne    802b41 <alloc_block_NF+0x4f9>
  802b2a:	83 ec 04             	sub    $0x4,%esp
  802b2d:	68 84 40 80 00       	push   $0x804084
  802b32:	68 1c 01 00 00       	push   $0x11c
  802b37:	68 db 3f 80 00       	push   $0x803fdb
  802b3c:	e8 75 d7 ff ff       	call   8002b6 <_panic>
  802b41:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b44:	8b 00                	mov    (%eax),%eax
  802b46:	85 c0                	test   %eax,%eax
  802b48:	74 10                	je     802b5a <alloc_block_NF+0x512>
  802b4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b4d:	8b 00                	mov    (%eax),%eax
  802b4f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b52:	8b 52 04             	mov    0x4(%edx),%edx
  802b55:	89 50 04             	mov    %edx,0x4(%eax)
  802b58:	eb 0b                	jmp    802b65 <alloc_block_NF+0x51d>
  802b5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b5d:	8b 40 04             	mov    0x4(%eax),%eax
  802b60:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b65:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b68:	8b 40 04             	mov    0x4(%eax),%eax
  802b6b:	85 c0                	test   %eax,%eax
  802b6d:	74 0f                	je     802b7e <alloc_block_NF+0x536>
  802b6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b72:	8b 40 04             	mov    0x4(%eax),%eax
  802b75:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b78:	8b 12                	mov    (%edx),%edx
  802b7a:	89 10                	mov    %edx,(%eax)
  802b7c:	eb 0a                	jmp    802b88 <alloc_block_NF+0x540>
  802b7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b81:	8b 00                	mov    (%eax),%eax
  802b83:	a3 48 51 80 00       	mov    %eax,0x805148
  802b88:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b8b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b91:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b94:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b9b:	a1 54 51 80 00       	mov    0x805154,%eax
  802ba0:	48                   	dec    %eax
  802ba1:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802ba6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ba9:	8b 40 08             	mov    0x8(%eax),%eax
  802bac:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802bb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb4:	8b 50 08             	mov    0x8(%eax),%edx
  802bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  802bba:	01 c2                	add    %eax,%edx
  802bbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbf:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802bc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc5:	8b 40 0c             	mov    0xc(%eax),%eax
  802bc8:	2b 45 08             	sub    0x8(%ebp),%eax
  802bcb:	89 c2                	mov    %eax,%edx
  802bcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd0:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802bd3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bd6:	eb 3b                	jmp    802c13 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802bd8:	a1 40 51 80 00       	mov    0x805140,%eax
  802bdd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802be0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802be4:	74 07                	je     802bed <alloc_block_NF+0x5a5>
  802be6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be9:	8b 00                	mov    (%eax),%eax
  802beb:	eb 05                	jmp    802bf2 <alloc_block_NF+0x5aa>
  802bed:	b8 00 00 00 00       	mov    $0x0,%eax
  802bf2:	a3 40 51 80 00       	mov    %eax,0x805140
  802bf7:	a1 40 51 80 00       	mov    0x805140,%eax
  802bfc:	85 c0                	test   %eax,%eax
  802bfe:	0f 85 2e fe ff ff    	jne    802a32 <alloc_block_NF+0x3ea>
  802c04:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c08:	0f 85 24 fe ff ff    	jne    802a32 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802c0e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c13:	c9                   	leave  
  802c14:	c3                   	ret    

00802c15 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802c15:	55                   	push   %ebp
  802c16:	89 e5                	mov    %esp,%ebp
  802c18:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802c1b:	a1 38 51 80 00       	mov    0x805138,%eax
  802c20:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802c23:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802c28:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802c2b:	a1 38 51 80 00       	mov    0x805138,%eax
  802c30:	85 c0                	test   %eax,%eax
  802c32:	74 14                	je     802c48 <insert_sorted_with_merge_freeList+0x33>
  802c34:	8b 45 08             	mov    0x8(%ebp),%eax
  802c37:	8b 50 08             	mov    0x8(%eax),%edx
  802c3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c3d:	8b 40 08             	mov    0x8(%eax),%eax
  802c40:	39 c2                	cmp    %eax,%edx
  802c42:	0f 87 9b 01 00 00    	ja     802de3 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802c48:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c4c:	75 17                	jne    802c65 <insert_sorted_with_merge_freeList+0x50>
  802c4e:	83 ec 04             	sub    $0x4,%esp
  802c51:	68 b8 3f 80 00       	push   $0x803fb8
  802c56:	68 38 01 00 00       	push   $0x138
  802c5b:	68 db 3f 80 00       	push   $0x803fdb
  802c60:	e8 51 d6 ff ff       	call   8002b6 <_panic>
  802c65:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6e:	89 10                	mov    %edx,(%eax)
  802c70:	8b 45 08             	mov    0x8(%ebp),%eax
  802c73:	8b 00                	mov    (%eax),%eax
  802c75:	85 c0                	test   %eax,%eax
  802c77:	74 0d                	je     802c86 <insert_sorted_with_merge_freeList+0x71>
  802c79:	a1 38 51 80 00       	mov    0x805138,%eax
  802c7e:	8b 55 08             	mov    0x8(%ebp),%edx
  802c81:	89 50 04             	mov    %edx,0x4(%eax)
  802c84:	eb 08                	jmp    802c8e <insert_sorted_with_merge_freeList+0x79>
  802c86:	8b 45 08             	mov    0x8(%ebp),%eax
  802c89:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c91:	a3 38 51 80 00       	mov    %eax,0x805138
  802c96:	8b 45 08             	mov    0x8(%ebp),%eax
  802c99:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ca0:	a1 44 51 80 00       	mov    0x805144,%eax
  802ca5:	40                   	inc    %eax
  802ca6:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802cab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802caf:	0f 84 a8 06 00 00    	je     80335d <insert_sorted_with_merge_freeList+0x748>
  802cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb8:	8b 50 08             	mov    0x8(%eax),%edx
  802cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbe:	8b 40 0c             	mov    0xc(%eax),%eax
  802cc1:	01 c2                	add    %eax,%edx
  802cc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cc6:	8b 40 08             	mov    0x8(%eax),%eax
  802cc9:	39 c2                	cmp    %eax,%edx
  802ccb:	0f 85 8c 06 00 00    	jne    80335d <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd4:	8b 50 0c             	mov    0xc(%eax),%edx
  802cd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cda:	8b 40 0c             	mov    0xc(%eax),%eax
  802cdd:	01 c2                	add    %eax,%edx
  802cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce2:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802ce5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ce9:	75 17                	jne    802d02 <insert_sorted_with_merge_freeList+0xed>
  802ceb:	83 ec 04             	sub    $0x4,%esp
  802cee:	68 84 40 80 00       	push   $0x804084
  802cf3:	68 3c 01 00 00       	push   $0x13c
  802cf8:	68 db 3f 80 00       	push   $0x803fdb
  802cfd:	e8 b4 d5 ff ff       	call   8002b6 <_panic>
  802d02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d05:	8b 00                	mov    (%eax),%eax
  802d07:	85 c0                	test   %eax,%eax
  802d09:	74 10                	je     802d1b <insert_sorted_with_merge_freeList+0x106>
  802d0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d0e:	8b 00                	mov    (%eax),%eax
  802d10:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d13:	8b 52 04             	mov    0x4(%edx),%edx
  802d16:	89 50 04             	mov    %edx,0x4(%eax)
  802d19:	eb 0b                	jmp    802d26 <insert_sorted_with_merge_freeList+0x111>
  802d1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d1e:	8b 40 04             	mov    0x4(%eax),%eax
  802d21:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d29:	8b 40 04             	mov    0x4(%eax),%eax
  802d2c:	85 c0                	test   %eax,%eax
  802d2e:	74 0f                	je     802d3f <insert_sorted_with_merge_freeList+0x12a>
  802d30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d33:	8b 40 04             	mov    0x4(%eax),%eax
  802d36:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d39:	8b 12                	mov    (%edx),%edx
  802d3b:	89 10                	mov    %edx,(%eax)
  802d3d:	eb 0a                	jmp    802d49 <insert_sorted_with_merge_freeList+0x134>
  802d3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d42:	8b 00                	mov    (%eax),%eax
  802d44:	a3 38 51 80 00       	mov    %eax,0x805138
  802d49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d4c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d55:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d5c:	a1 44 51 80 00       	mov    0x805144,%eax
  802d61:	48                   	dec    %eax
  802d62:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802d67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d6a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802d71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d74:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802d7b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d7f:	75 17                	jne    802d98 <insert_sorted_with_merge_freeList+0x183>
  802d81:	83 ec 04             	sub    $0x4,%esp
  802d84:	68 b8 3f 80 00       	push   $0x803fb8
  802d89:	68 3f 01 00 00       	push   $0x13f
  802d8e:	68 db 3f 80 00       	push   $0x803fdb
  802d93:	e8 1e d5 ff ff       	call   8002b6 <_panic>
  802d98:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802d9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da1:	89 10                	mov    %edx,(%eax)
  802da3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da6:	8b 00                	mov    (%eax),%eax
  802da8:	85 c0                	test   %eax,%eax
  802daa:	74 0d                	je     802db9 <insert_sorted_with_merge_freeList+0x1a4>
  802dac:	a1 48 51 80 00       	mov    0x805148,%eax
  802db1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802db4:	89 50 04             	mov    %edx,0x4(%eax)
  802db7:	eb 08                	jmp    802dc1 <insert_sorted_with_merge_freeList+0x1ac>
  802db9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dbc:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802dc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc4:	a3 48 51 80 00       	mov    %eax,0x805148
  802dc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dcc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dd3:	a1 54 51 80 00       	mov    0x805154,%eax
  802dd8:	40                   	inc    %eax
  802dd9:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802dde:	e9 7a 05 00 00       	jmp    80335d <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802de3:	8b 45 08             	mov    0x8(%ebp),%eax
  802de6:	8b 50 08             	mov    0x8(%eax),%edx
  802de9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dec:	8b 40 08             	mov    0x8(%eax),%eax
  802def:	39 c2                	cmp    %eax,%edx
  802df1:	0f 82 14 01 00 00    	jb     802f0b <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802df7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dfa:	8b 50 08             	mov    0x8(%eax),%edx
  802dfd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e00:	8b 40 0c             	mov    0xc(%eax),%eax
  802e03:	01 c2                	add    %eax,%edx
  802e05:	8b 45 08             	mov    0x8(%ebp),%eax
  802e08:	8b 40 08             	mov    0x8(%eax),%eax
  802e0b:	39 c2                	cmp    %eax,%edx
  802e0d:	0f 85 90 00 00 00    	jne    802ea3 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802e13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e16:	8b 50 0c             	mov    0xc(%eax),%edx
  802e19:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1c:	8b 40 0c             	mov    0xc(%eax),%eax
  802e1f:	01 c2                	add    %eax,%edx
  802e21:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e24:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802e27:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802e31:	8b 45 08             	mov    0x8(%ebp),%eax
  802e34:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802e3b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e3f:	75 17                	jne    802e58 <insert_sorted_with_merge_freeList+0x243>
  802e41:	83 ec 04             	sub    $0x4,%esp
  802e44:	68 b8 3f 80 00       	push   $0x803fb8
  802e49:	68 49 01 00 00       	push   $0x149
  802e4e:	68 db 3f 80 00       	push   $0x803fdb
  802e53:	e8 5e d4 ff ff       	call   8002b6 <_panic>
  802e58:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e61:	89 10                	mov    %edx,(%eax)
  802e63:	8b 45 08             	mov    0x8(%ebp),%eax
  802e66:	8b 00                	mov    (%eax),%eax
  802e68:	85 c0                	test   %eax,%eax
  802e6a:	74 0d                	je     802e79 <insert_sorted_with_merge_freeList+0x264>
  802e6c:	a1 48 51 80 00       	mov    0x805148,%eax
  802e71:	8b 55 08             	mov    0x8(%ebp),%edx
  802e74:	89 50 04             	mov    %edx,0x4(%eax)
  802e77:	eb 08                	jmp    802e81 <insert_sorted_with_merge_freeList+0x26c>
  802e79:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e81:	8b 45 08             	mov    0x8(%ebp),%eax
  802e84:	a3 48 51 80 00       	mov    %eax,0x805148
  802e89:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e93:	a1 54 51 80 00       	mov    0x805154,%eax
  802e98:	40                   	inc    %eax
  802e99:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802e9e:	e9 bb 04 00 00       	jmp    80335e <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802ea3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ea7:	75 17                	jne    802ec0 <insert_sorted_with_merge_freeList+0x2ab>
  802ea9:	83 ec 04             	sub    $0x4,%esp
  802eac:	68 2c 40 80 00       	push   $0x80402c
  802eb1:	68 4c 01 00 00       	push   $0x14c
  802eb6:	68 db 3f 80 00       	push   $0x803fdb
  802ebb:	e8 f6 d3 ff ff       	call   8002b6 <_panic>
  802ec0:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802ec6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec9:	89 50 04             	mov    %edx,0x4(%eax)
  802ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ecf:	8b 40 04             	mov    0x4(%eax),%eax
  802ed2:	85 c0                	test   %eax,%eax
  802ed4:	74 0c                	je     802ee2 <insert_sorted_with_merge_freeList+0x2cd>
  802ed6:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802edb:	8b 55 08             	mov    0x8(%ebp),%edx
  802ede:	89 10                	mov    %edx,(%eax)
  802ee0:	eb 08                	jmp    802eea <insert_sorted_with_merge_freeList+0x2d5>
  802ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee5:	a3 38 51 80 00       	mov    %eax,0x805138
  802eea:	8b 45 08             	mov    0x8(%ebp),%eax
  802eed:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802efb:	a1 44 51 80 00       	mov    0x805144,%eax
  802f00:	40                   	inc    %eax
  802f01:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802f06:	e9 53 04 00 00       	jmp    80335e <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802f0b:	a1 38 51 80 00       	mov    0x805138,%eax
  802f10:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f13:	e9 15 04 00 00       	jmp    80332d <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802f18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1b:	8b 00                	mov    (%eax),%eax
  802f1d:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802f20:	8b 45 08             	mov    0x8(%ebp),%eax
  802f23:	8b 50 08             	mov    0x8(%eax),%edx
  802f26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f29:	8b 40 08             	mov    0x8(%eax),%eax
  802f2c:	39 c2                	cmp    %eax,%edx
  802f2e:	0f 86 f1 03 00 00    	jbe    803325 <insert_sorted_with_merge_freeList+0x710>
  802f34:	8b 45 08             	mov    0x8(%ebp),%eax
  802f37:	8b 50 08             	mov    0x8(%eax),%edx
  802f3a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f3d:	8b 40 08             	mov    0x8(%eax),%eax
  802f40:	39 c2                	cmp    %eax,%edx
  802f42:	0f 83 dd 03 00 00    	jae    803325 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802f48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4b:	8b 50 08             	mov    0x8(%eax),%edx
  802f4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f51:	8b 40 0c             	mov    0xc(%eax),%eax
  802f54:	01 c2                	add    %eax,%edx
  802f56:	8b 45 08             	mov    0x8(%ebp),%eax
  802f59:	8b 40 08             	mov    0x8(%eax),%eax
  802f5c:	39 c2                	cmp    %eax,%edx
  802f5e:	0f 85 b9 01 00 00    	jne    80311d <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802f64:	8b 45 08             	mov    0x8(%ebp),%eax
  802f67:	8b 50 08             	mov    0x8(%eax),%edx
  802f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6d:	8b 40 0c             	mov    0xc(%eax),%eax
  802f70:	01 c2                	add    %eax,%edx
  802f72:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f75:	8b 40 08             	mov    0x8(%eax),%eax
  802f78:	39 c2                	cmp    %eax,%edx
  802f7a:	0f 85 0d 01 00 00    	jne    80308d <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802f80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f83:	8b 50 0c             	mov    0xc(%eax),%edx
  802f86:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f89:	8b 40 0c             	mov    0xc(%eax),%eax
  802f8c:	01 c2                	add    %eax,%edx
  802f8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f91:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802f94:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f98:	75 17                	jne    802fb1 <insert_sorted_with_merge_freeList+0x39c>
  802f9a:	83 ec 04             	sub    $0x4,%esp
  802f9d:	68 84 40 80 00       	push   $0x804084
  802fa2:	68 5c 01 00 00       	push   $0x15c
  802fa7:	68 db 3f 80 00       	push   $0x803fdb
  802fac:	e8 05 d3 ff ff       	call   8002b6 <_panic>
  802fb1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fb4:	8b 00                	mov    (%eax),%eax
  802fb6:	85 c0                	test   %eax,%eax
  802fb8:	74 10                	je     802fca <insert_sorted_with_merge_freeList+0x3b5>
  802fba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fbd:	8b 00                	mov    (%eax),%eax
  802fbf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fc2:	8b 52 04             	mov    0x4(%edx),%edx
  802fc5:	89 50 04             	mov    %edx,0x4(%eax)
  802fc8:	eb 0b                	jmp    802fd5 <insert_sorted_with_merge_freeList+0x3c0>
  802fca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fcd:	8b 40 04             	mov    0x4(%eax),%eax
  802fd0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fd5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fd8:	8b 40 04             	mov    0x4(%eax),%eax
  802fdb:	85 c0                	test   %eax,%eax
  802fdd:	74 0f                	je     802fee <insert_sorted_with_merge_freeList+0x3d9>
  802fdf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fe2:	8b 40 04             	mov    0x4(%eax),%eax
  802fe5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fe8:	8b 12                	mov    (%edx),%edx
  802fea:	89 10                	mov    %edx,(%eax)
  802fec:	eb 0a                	jmp    802ff8 <insert_sorted_with_merge_freeList+0x3e3>
  802fee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ff1:	8b 00                	mov    (%eax),%eax
  802ff3:	a3 38 51 80 00       	mov    %eax,0x805138
  802ff8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ffb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803001:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803004:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80300b:	a1 44 51 80 00       	mov    0x805144,%eax
  803010:	48                   	dec    %eax
  803011:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803016:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803019:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803020:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803023:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80302a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80302e:	75 17                	jne    803047 <insert_sorted_with_merge_freeList+0x432>
  803030:	83 ec 04             	sub    $0x4,%esp
  803033:	68 b8 3f 80 00       	push   $0x803fb8
  803038:	68 5f 01 00 00       	push   $0x15f
  80303d:	68 db 3f 80 00       	push   $0x803fdb
  803042:	e8 6f d2 ff ff       	call   8002b6 <_panic>
  803047:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80304d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803050:	89 10                	mov    %edx,(%eax)
  803052:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803055:	8b 00                	mov    (%eax),%eax
  803057:	85 c0                	test   %eax,%eax
  803059:	74 0d                	je     803068 <insert_sorted_with_merge_freeList+0x453>
  80305b:	a1 48 51 80 00       	mov    0x805148,%eax
  803060:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803063:	89 50 04             	mov    %edx,0x4(%eax)
  803066:	eb 08                	jmp    803070 <insert_sorted_with_merge_freeList+0x45b>
  803068:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80306b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803070:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803073:	a3 48 51 80 00       	mov    %eax,0x805148
  803078:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80307b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803082:	a1 54 51 80 00       	mov    0x805154,%eax
  803087:	40                   	inc    %eax
  803088:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  80308d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803090:	8b 50 0c             	mov    0xc(%eax),%edx
  803093:	8b 45 08             	mov    0x8(%ebp),%eax
  803096:	8b 40 0c             	mov    0xc(%eax),%eax
  803099:	01 c2                	add    %eax,%edx
  80309b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309e:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8030a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8030ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ae:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8030b5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030b9:	75 17                	jne    8030d2 <insert_sorted_with_merge_freeList+0x4bd>
  8030bb:	83 ec 04             	sub    $0x4,%esp
  8030be:	68 b8 3f 80 00       	push   $0x803fb8
  8030c3:	68 64 01 00 00       	push   $0x164
  8030c8:	68 db 3f 80 00       	push   $0x803fdb
  8030cd:	e8 e4 d1 ff ff       	call   8002b6 <_panic>
  8030d2:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8030d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030db:	89 10                	mov    %edx,(%eax)
  8030dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e0:	8b 00                	mov    (%eax),%eax
  8030e2:	85 c0                	test   %eax,%eax
  8030e4:	74 0d                	je     8030f3 <insert_sorted_with_merge_freeList+0x4de>
  8030e6:	a1 48 51 80 00       	mov    0x805148,%eax
  8030eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8030ee:	89 50 04             	mov    %edx,0x4(%eax)
  8030f1:	eb 08                	jmp    8030fb <insert_sorted_with_merge_freeList+0x4e6>
  8030f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fe:	a3 48 51 80 00       	mov    %eax,0x805148
  803103:	8b 45 08             	mov    0x8(%ebp),%eax
  803106:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80310d:	a1 54 51 80 00       	mov    0x805154,%eax
  803112:	40                   	inc    %eax
  803113:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803118:	e9 41 02 00 00       	jmp    80335e <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80311d:	8b 45 08             	mov    0x8(%ebp),%eax
  803120:	8b 50 08             	mov    0x8(%eax),%edx
  803123:	8b 45 08             	mov    0x8(%ebp),%eax
  803126:	8b 40 0c             	mov    0xc(%eax),%eax
  803129:	01 c2                	add    %eax,%edx
  80312b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80312e:	8b 40 08             	mov    0x8(%eax),%eax
  803131:	39 c2                	cmp    %eax,%edx
  803133:	0f 85 7c 01 00 00    	jne    8032b5 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803139:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80313d:	74 06                	je     803145 <insert_sorted_with_merge_freeList+0x530>
  80313f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803143:	75 17                	jne    80315c <insert_sorted_with_merge_freeList+0x547>
  803145:	83 ec 04             	sub    $0x4,%esp
  803148:	68 f4 3f 80 00       	push   $0x803ff4
  80314d:	68 69 01 00 00       	push   $0x169
  803152:	68 db 3f 80 00       	push   $0x803fdb
  803157:	e8 5a d1 ff ff       	call   8002b6 <_panic>
  80315c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80315f:	8b 50 04             	mov    0x4(%eax),%edx
  803162:	8b 45 08             	mov    0x8(%ebp),%eax
  803165:	89 50 04             	mov    %edx,0x4(%eax)
  803168:	8b 45 08             	mov    0x8(%ebp),%eax
  80316b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80316e:	89 10                	mov    %edx,(%eax)
  803170:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803173:	8b 40 04             	mov    0x4(%eax),%eax
  803176:	85 c0                	test   %eax,%eax
  803178:	74 0d                	je     803187 <insert_sorted_with_merge_freeList+0x572>
  80317a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80317d:	8b 40 04             	mov    0x4(%eax),%eax
  803180:	8b 55 08             	mov    0x8(%ebp),%edx
  803183:	89 10                	mov    %edx,(%eax)
  803185:	eb 08                	jmp    80318f <insert_sorted_with_merge_freeList+0x57a>
  803187:	8b 45 08             	mov    0x8(%ebp),%eax
  80318a:	a3 38 51 80 00       	mov    %eax,0x805138
  80318f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803192:	8b 55 08             	mov    0x8(%ebp),%edx
  803195:	89 50 04             	mov    %edx,0x4(%eax)
  803198:	a1 44 51 80 00       	mov    0x805144,%eax
  80319d:	40                   	inc    %eax
  80319e:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8031a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a6:	8b 50 0c             	mov    0xc(%eax),%edx
  8031a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ac:	8b 40 0c             	mov    0xc(%eax),%eax
  8031af:	01 c2                	add    %eax,%edx
  8031b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b4:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8031b7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031bb:	75 17                	jne    8031d4 <insert_sorted_with_merge_freeList+0x5bf>
  8031bd:	83 ec 04             	sub    $0x4,%esp
  8031c0:	68 84 40 80 00       	push   $0x804084
  8031c5:	68 6b 01 00 00       	push   $0x16b
  8031ca:	68 db 3f 80 00       	push   $0x803fdb
  8031cf:	e8 e2 d0 ff ff       	call   8002b6 <_panic>
  8031d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d7:	8b 00                	mov    (%eax),%eax
  8031d9:	85 c0                	test   %eax,%eax
  8031db:	74 10                	je     8031ed <insert_sorted_with_merge_freeList+0x5d8>
  8031dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e0:	8b 00                	mov    (%eax),%eax
  8031e2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031e5:	8b 52 04             	mov    0x4(%edx),%edx
  8031e8:	89 50 04             	mov    %edx,0x4(%eax)
  8031eb:	eb 0b                	jmp    8031f8 <insert_sorted_with_merge_freeList+0x5e3>
  8031ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f0:	8b 40 04             	mov    0x4(%eax),%eax
  8031f3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031fb:	8b 40 04             	mov    0x4(%eax),%eax
  8031fe:	85 c0                	test   %eax,%eax
  803200:	74 0f                	je     803211 <insert_sorted_with_merge_freeList+0x5fc>
  803202:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803205:	8b 40 04             	mov    0x4(%eax),%eax
  803208:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80320b:	8b 12                	mov    (%edx),%edx
  80320d:	89 10                	mov    %edx,(%eax)
  80320f:	eb 0a                	jmp    80321b <insert_sorted_with_merge_freeList+0x606>
  803211:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803214:	8b 00                	mov    (%eax),%eax
  803216:	a3 38 51 80 00       	mov    %eax,0x805138
  80321b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80321e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803224:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803227:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80322e:	a1 44 51 80 00       	mov    0x805144,%eax
  803233:	48                   	dec    %eax
  803234:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803239:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80323c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803243:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803246:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80324d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803251:	75 17                	jne    80326a <insert_sorted_with_merge_freeList+0x655>
  803253:	83 ec 04             	sub    $0x4,%esp
  803256:	68 b8 3f 80 00       	push   $0x803fb8
  80325b:	68 6e 01 00 00       	push   $0x16e
  803260:	68 db 3f 80 00       	push   $0x803fdb
  803265:	e8 4c d0 ff ff       	call   8002b6 <_panic>
  80326a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803270:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803273:	89 10                	mov    %edx,(%eax)
  803275:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803278:	8b 00                	mov    (%eax),%eax
  80327a:	85 c0                	test   %eax,%eax
  80327c:	74 0d                	je     80328b <insert_sorted_with_merge_freeList+0x676>
  80327e:	a1 48 51 80 00       	mov    0x805148,%eax
  803283:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803286:	89 50 04             	mov    %edx,0x4(%eax)
  803289:	eb 08                	jmp    803293 <insert_sorted_with_merge_freeList+0x67e>
  80328b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80328e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803293:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803296:	a3 48 51 80 00       	mov    %eax,0x805148
  80329b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80329e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032a5:	a1 54 51 80 00       	mov    0x805154,%eax
  8032aa:	40                   	inc    %eax
  8032ab:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8032b0:	e9 a9 00 00 00       	jmp    80335e <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8032b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032b9:	74 06                	je     8032c1 <insert_sorted_with_merge_freeList+0x6ac>
  8032bb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032bf:	75 17                	jne    8032d8 <insert_sorted_with_merge_freeList+0x6c3>
  8032c1:	83 ec 04             	sub    $0x4,%esp
  8032c4:	68 50 40 80 00       	push   $0x804050
  8032c9:	68 73 01 00 00       	push   $0x173
  8032ce:	68 db 3f 80 00       	push   $0x803fdb
  8032d3:	e8 de cf ff ff       	call   8002b6 <_panic>
  8032d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032db:	8b 10                	mov    (%eax),%edx
  8032dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e0:	89 10                	mov    %edx,(%eax)
  8032e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e5:	8b 00                	mov    (%eax),%eax
  8032e7:	85 c0                	test   %eax,%eax
  8032e9:	74 0b                	je     8032f6 <insert_sorted_with_merge_freeList+0x6e1>
  8032eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ee:	8b 00                	mov    (%eax),%eax
  8032f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8032f3:	89 50 04             	mov    %edx,0x4(%eax)
  8032f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8032fc:	89 10                	mov    %edx,(%eax)
  8032fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803301:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803304:	89 50 04             	mov    %edx,0x4(%eax)
  803307:	8b 45 08             	mov    0x8(%ebp),%eax
  80330a:	8b 00                	mov    (%eax),%eax
  80330c:	85 c0                	test   %eax,%eax
  80330e:	75 08                	jne    803318 <insert_sorted_with_merge_freeList+0x703>
  803310:	8b 45 08             	mov    0x8(%ebp),%eax
  803313:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803318:	a1 44 51 80 00       	mov    0x805144,%eax
  80331d:	40                   	inc    %eax
  80331e:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803323:	eb 39                	jmp    80335e <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803325:	a1 40 51 80 00       	mov    0x805140,%eax
  80332a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80332d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803331:	74 07                	je     80333a <insert_sorted_with_merge_freeList+0x725>
  803333:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803336:	8b 00                	mov    (%eax),%eax
  803338:	eb 05                	jmp    80333f <insert_sorted_with_merge_freeList+0x72a>
  80333a:	b8 00 00 00 00       	mov    $0x0,%eax
  80333f:	a3 40 51 80 00       	mov    %eax,0x805140
  803344:	a1 40 51 80 00       	mov    0x805140,%eax
  803349:	85 c0                	test   %eax,%eax
  80334b:	0f 85 c7 fb ff ff    	jne    802f18 <insert_sorted_with_merge_freeList+0x303>
  803351:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803355:	0f 85 bd fb ff ff    	jne    802f18 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80335b:	eb 01                	jmp    80335e <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80335d:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80335e:	90                   	nop
  80335f:	c9                   	leave  
  803360:	c3                   	ret    

00803361 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803361:	55                   	push   %ebp
  803362:	89 e5                	mov    %esp,%ebp
  803364:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803367:	8b 55 08             	mov    0x8(%ebp),%edx
  80336a:	89 d0                	mov    %edx,%eax
  80336c:	c1 e0 02             	shl    $0x2,%eax
  80336f:	01 d0                	add    %edx,%eax
  803371:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803378:	01 d0                	add    %edx,%eax
  80337a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803381:	01 d0                	add    %edx,%eax
  803383:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80338a:	01 d0                	add    %edx,%eax
  80338c:	c1 e0 04             	shl    $0x4,%eax
  80338f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803392:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803399:	8d 45 e8             	lea    -0x18(%ebp),%eax
  80339c:	83 ec 0c             	sub    $0xc,%esp
  80339f:	50                   	push   %eax
  8033a0:	e8 26 e7 ff ff       	call   801acb <sys_get_virtual_time>
  8033a5:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8033a8:	eb 41                	jmp    8033eb <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8033aa:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8033ad:	83 ec 0c             	sub    $0xc,%esp
  8033b0:	50                   	push   %eax
  8033b1:	e8 15 e7 ff ff       	call   801acb <sys_get_virtual_time>
  8033b6:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8033b9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8033bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033bf:	29 c2                	sub    %eax,%edx
  8033c1:	89 d0                	mov    %edx,%eax
  8033c3:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8033c6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8033c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033cc:	89 d1                	mov    %edx,%ecx
  8033ce:	29 c1                	sub    %eax,%ecx
  8033d0:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8033d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033d6:	39 c2                	cmp    %eax,%edx
  8033d8:	0f 97 c0             	seta   %al
  8033db:	0f b6 c0             	movzbl %al,%eax
  8033de:	29 c1                	sub    %eax,%ecx
  8033e0:	89 c8                	mov    %ecx,%eax
  8033e2:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8033e5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8033e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8033eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ee:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8033f1:	72 b7                	jb     8033aa <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8033f3:	90                   	nop
  8033f4:	c9                   	leave  
  8033f5:	c3                   	ret    

008033f6 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8033f6:	55                   	push   %ebp
  8033f7:	89 e5                	mov    %esp,%ebp
  8033f9:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8033fc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803403:	eb 03                	jmp    803408 <busy_wait+0x12>
  803405:	ff 45 fc             	incl   -0x4(%ebp)
  803408:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80340b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80340e:	72 f5                	jb     803405 <busy_wait+0xf>
	return i;
  803410:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803413:	c9                   	leave  
  803414:	c3                   	ret    
  803415:	66 90                	xchg   %ax,%ax
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
