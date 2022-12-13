
obj/user/ef_tst_sharing_5_slaveB2:     file format elf32-i386


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
  800031:	e8 77 01 00 00       	call   8001ad <libmain>
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
  800098:	e8 4c 02 00 00       	call   8002e9 <_panic>
	}
	uint32 *z;
	z = sget(sys_getparentenvid(),"z");
  80009d:	e8 29 1a 00 00       	call   801acb <sys_getparentenvid>
  8000a2:	83 ec 08             	sub    $0x8,%esp
  8000a5:	68 fc 36 80 00       	push   $0x8036fc
  8000aa:	50                   	push   %eax
  8000ab:	e8 7e 15 00 00       	call   80162e <sget>
  8000b0:	83 c4 10             	add    $0x10,%esp
  8000b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("Slave B2 env used z (getSharedObject)\n");
  8000b6:	83 ec 0c             	sub    $0xc,%esp
  8000b9:	68 00 37 80 00       	push   $0x803700
  8000be:	e8 da 04 00 00       	call   80059d <cprintf>
  8000c3:	83 c4 10             	add    $0x10,%esp

	cprintf("Slave B2 please be patient ...\n");
  8000c6:	83 ec 0c             	sub    $0xc,%esp
  8000c9:	68 28 37 80 00       	push   $0x803728
  8000ce:	e8 ca 04 00 00       	call   80059d <cprintf>
  8000d3:	83 c4 10             	add    $0x10,%esp

	env_sleep(9000);
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	68 28 23 00 00       	push   $0x2328
  8000de:	e8 b1 32 00 00       	call   803394 <env_sleep>
  8000e3:	83 c4 10             	add    $0x10,%esp
	int freeFrames = sys_calculate_free_frames() ;
  8000e6:	e8 e7 16 00 00       	call   8017d2 <sys_calculate_free_frames>
  8000eb:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sfree(z);
  8000ee:	83 ec 0c             	sub    $0xc,%esp
  8000f1:	ff 75 ec             	pushl  -0x14(%ebp)
  8000f4:	e8 79 15 00 00       	call   801672 <sfree>
  8000f9:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave B2 env removed z\n");
  8000fc:	83 ec 0c             	sub    $0xc,%esp
  8000ff:	68 48 37 80 00       	push   $0x803748
  800104:	e8 94 04 00 00       	call   80059d <cprintf>
  800109:	83 c4 10             	add    $0x10,%esp

	if ((sys_calculate_free_frames() - freeFrames) !=  4) panic("wrong free: frames removed not equal 4 !, correct frames to be removed are 4:\nfrom the env: 1 table + 1 frame for z\nframes_storage of z: should be cleared now\n");
  80010c:	e8 c1 16 00 00       	call   8017d2 <sys_calculate_free_frames>
  800111:	89 c2                	mov    %eax,%edx
  800113:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800116:	29 c2                	sub    %eax,%edx
  800118:	89 d0                	mov    %edx,%eax
  80011a:	83 f8 04             	cmp    $0x4,%eax
  80011d:	74 14                	je     800133 <_main+0xfb>
  80011f:	83 ec 04             	sub    $0x4,%esp
  800122:	68 60 37 80 00       	push   $0x803760
  800127:	6a 20                	push   $0x20
  800129:	68 dc 36 80 00       	push   $0x8036dc
  80012e:	e8 b6 01 00 00       	call   8002e9 <_panic>

	//to ensure that the other environments completed successfully
	if (gettst()!=2) panic("test failed");
  800133:	e8 d2 1a 00 00       	call   801c0a <gettst>
  800138:	83 f8 02             	cmp    $0x2,%eax
  80013b:	74 14                	je     800151 <_main+0x119>
  80013d:	83 ec 04             	sub    $0x4,%esp
  800140:	68 00 38 80 00       	push   $0x803800
  800145:	6a 23                	push   $0x23
  800147:	68 dc 36 80 00       	push   $0x8036dc
  80014c:	e8 98 01 00 00       	call   8002e9 <_panic>

	cprintf("Step B completed successfully!!\n\n\n");
  800151:	83 ec 0c             	sub    $0xc,%esp
  800154:	68 0c 38 80 00       	push   $0x80380c
  800159:	e8 3f 04 00 00       	call   80059d <cprintf>
  80015e:	83 c4 10             	add    $0x10,%esp
	cprintf("Congratulations!! Test of freeSharedObjects [5] completed successfully!!\n\n\n");
  800161:	83 ec 0c             	sub    $0xc,%esp
  800164:	68 30 38 80 00       	push   $0x803830
  800169:	e8 2f 04 00 00       	call   80059d <cprintf>
  80016e:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  800171:	e8 55 19 00 00       	call   801acb <sys_getparentenvid>
  800176:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(parentenvID > 0)
  800179:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80017d:	7e 2b                	jle    8001aa <_main+0x172>
	{
		//Get the check-finishing counter
		int *finish = NULL;
  80017f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		finish = sget(parentenvID, "finish_children") ;
  800186:	83 ec 08             	sub    $0x8,%esp
  800189:	68 7c 38 80 00       	push   $0x80387c
  80018e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800191:	e8 98 14 00 00       	call   80162e <sget>
  800196:	83 c4 10             	add    $0x10,%esp
  800199:	89 45 e0             	mov    %eax,-0x20(%ebp)
		(*finish)++ ;
  80019c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80019f:	8b 00                	mov    (%eax),%eax
  8001a1:	8d 50 01             	lea    0x1(%eax),%edx
  8001a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001a7:	89 10                	mov    %edx,(%eax)
	}
	return;
  8001a9:	90                   	nop
  8001aa:	90                   	nop
}
  8001ab:	c9                   	leave  
  8001ac:	c3                   	ret    

008001ad <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8001ad:	55                   	push   %ebp
  8001ae:	89 e5                	mov    %esp,%ebp
  8001b0:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8001b3:	e8 fa 18 00 00       	call   801ab2 <sys_getenvindex>
  8001b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8001bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001be:	89 d0                	mov    %edx,%eax
  8001c0:	c1 e0 03             	shl    $0x3,%eax
  8001c3:	01 d0                	add    %edx,%eax
  8001c5:	01 c0                	add    %eax,%eax
  8001c7:	01 d0                	add    %edx,%eax
  8001c9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001d0:	01 d0                	add    %edx,%eax
  8001d2:	c1 e0 04             	shl    $0x4,%eax
  8001d5:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001da:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001df:	a1 20 50 80 00       	mov    0x805020,%eax
  8001e4:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8001ea:	84 c0                	test   %al,%al
  8001ec:	74 0f                	je     8001fd <libmain+0x50>
		binaryname = myEnv->prog_name;
  8001ee:	a1 20 50 80 00       	mov    0x805020,%eax
  8001f3:	05 5c 05 00 00       	add    $0x55c,%eax
  8001f8:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001fd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800201:	7e 0a                	jle    80020d <libmain+0x60>
		binaryname = argv[0];
  800203:	8b 45 0c             	mov    0xc(%ebp),%eax
  800206:	8b 00                	mov    (%eax),%eax
  800208:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  80020d:	83 ec 08             	sub    $0x8,%esp
  800210:	ff 75 0c             	pushl  0xc(%ebp)
  800213:	ff 75 08             	pushl  0x8(%ebp)
  800216:	e8 1d fe ff ff       	call   800038 <_main>
  80021b:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80021e:	e8 9c 16 00 00       	call   8018bf <sys_disable_interrupt>
	cprintf("**************************************\n");
  800223:	83 ec 0c             	sub    $0xc,%esp
  800226:	68 a4 38 80 00       	push   $0x8038a4
  80022b:	e8 6d 03 00 00       	call   80059d <cprintf>
  800230:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800233:	a1 20 50 80 00       	mov    0x805020,%eax
  800238:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80023e:	a1 20 50 80 00       	mov    0x805020,%eax
  800243:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800249:	83 ec 04             	sub    $0x4,%esp
  80024c:	52                   	push   %edx
  80024d:	50                   	push   %eax
  80024e:	68 cc 38 80 00       	push   $0x8038cc
  800253:	e8 45 03 00 00       	call   80059d <cprintf>
  800258:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80025b:	a1 20 50 80 00       	mov    0x805020,%eax
  800260:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800266:	a1 20 50 80 00       	mov    0x805020,%eax
  80026b:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800271:	a1 20 50 80 00       	mov    0x805020,%eax
  800276:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80027c:	51                   	push   %ecx
  80027d:	52                   	push   %edx
  80027e:	50                   	push   %eax
  80027f:	68 f4 38 80 00       	push   $0x8038f4
  800284:	e8 14 03 00 00       	call   80059d <cprintf>
  800289:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80028c:	a1 20 50 80 00       	mov    0x805020,%eax
  800291:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800297:	83 ec 08             	sub    $0x8,%esp
  80029a:	50                   	push   %eax
  80029b:	68 4c 39 80 00       	push   $0x80394c
  8002a0:	e8 f8 02 00 00       	call   80059d <cprintf>
  8002a5:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8002a8:	83 ec 0c             	sub    $0xc,%esp
  8002ab:	68 a4 38 80 00       	push   $0x8038a4
  8002b0:	e8 e8 02 00 00       	call   80059d <cprintf>
  8002b5:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8002b8:	e8 1c 16 00 00       	call   8018d9 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8002bd:	e8 19 00 00 00       	call   8002db <exit>
}
  8002c2:	90                   	nop
  8002c3:	c9                   	leave  
  8002c4:	c3                   	ret    

008002c5 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002c5:	55                   	push   %ebp
  8002c6:	89 e5                	mov    %esp,%ebp
  8002c8:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002cb:	83 ec 0c             	sub    $0xc,%esp
  8002ce:	6a 00                	push   $0x0
  8002d0:	e8 a9 17 00 00       	call   801a7e <sys_destroy_env>
  8002d5:	83 c4 10             	add    $0x10,%esp
}
  8002d8:	90                   	nop
  8002d9:	c9                   	leave  
  8002da:	c3                   	ret    

008002db <exit>:

void
exit(void)
{
  8002db:	55                   	push   %ebp
  8002dc:	89 e5                	mov    %esp,%ebp
  8002de:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002e1:	e8 fe 17 00 00       	call   801ae4 <sys_exit_env>
}
  8002e6:	90                   	nop
  8002e7:	c9                   	leave  
  8002e8:	c3                   	ret    

008002e9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002e9:	55                   	push   %ebp
  8002ea:	89 e5                	mov    %esp,%ebp
  8002ec:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002ef:	8d 45 10             	lea    0x10(%ebp),%eax
  8002f2:	83 c0 04             	add    $0x4,%eax
  8002f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002f8:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8002fd:	85 c0                	test   %eax,%eax
  8002ff:	74 16                	je     800317 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800301:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800306:	83 ec 08             	sub    $0x8,%esp
  800309:	50                   	push   %eax
  80030a:	68 60 39 80 00       	push   $0x803960
  80030f:	e8 89 02 00 00       	call   80059d <cprintf>
  800314:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800317:	a1 00 50 80 00       	mov    0x805000,%eax
  80031c:	ff 75 0c             	pushl  0xc(%ebp)
  80031f:	ff 75 08             	pushl  0x8(%ebp)
  800322:	50                   	push   %eax
  800323:	68 65 39 80 00       	push   $0x803965
  800328:	e8 70 02 00 00       	call   80059d <cprintf>
  80032d:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800330:	8b 45 10             	mov    0x10(%ebp),%eax
  800333:	83 ec 08             	sub    $0x8,%esp
  800336:	ff 75 f4             	pushl  -0xc(%ebp)
  800339:	50                   	push   %eax
  80033a:	e8 f3 01 00 00       	call   800532 <vcprintf>
  80033f:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800342:	83 ec 08             	sub    $0x8,%esp
  800345:	6a 00                	push   $0x0
  800347:	68 81 39 80 00       	push   $0x803981
  80034c:	e8 e1 01 00 00       	call   800532 <vcprintf>
  800351:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800354:	e8 82 ff ff ff       	call   8002db <exit>

	// should not return here
	while (1) ;
  800359:	eb fe                	jmp    800359 <_panic+0x70>

0080035b <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80035b:	55                   	push   %ebp
  80035c:	89 e5                	mov    %esp,%ebp
  80035e:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800361:	a1 20 50 80 00       	mov    0x805020,%eax
  800366:	8b 50 74             	mov    0x74(%eax),%edx
  800369:	8b 45 0c             	mov    0xc(%ebp),%eax
  80036c:	39 c2                	cmp    %eax,%edx
  80036e:	74 14                	je     800384 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800370:	83 ec 04             	sub    $0x4,%esp
  800373:	68 84 39 80 00       	push   $0x803984
  800378:	6a 26                	push   $0x26
  80037a:	68 d0 39 80 00       	push   $0x8039d0
  80037f:	e8 65 ff ff ff       	call   8002e9 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800384:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80038b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800392:	e9 c2 00 00 00       	jmp    800459 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800397:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80039a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a4:	01 d0                	add    %edx,%eax
  8003a6:	8b 00                	mov    (%eax),%eax
  8003a8:	85 c0                	test   %eax,%eax
  8003aa:	75 08                	jne    8003b4 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8003ac:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003af:	e9 a2 00 00 00       	jmp    800456 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8003b4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003bb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003c2:	eb 69                	jmp    80042d <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003c4:	a1 20 50 80 00       	mov    0x805020,%eax
  8003c9:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003cf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003d2:	89 d0                	mov    %edx,%eax
  8003d4:	01 c0                	add    %eax,%eax
  8003d6:	01 d0                	add    %edx,%eax
  8003d8:	c1 e0 03             	shl    $0x3,%eax
  8003db:	01 c8                	add    %ecx,%eax
  8003dd:	8a 40 04             	mov    0x4(%eax),%al
  8003e0:	84 c0                	test   %al,%al
  8003e2:	75 46                	jne    80042a <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003e4:	a1 20 50 80 00       	mov    0x805020,%eax
  8003e9:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003ef:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003f2:	89 d0                	mov    %edx,%eax
  8003f4:	01 c0                	add    %eax,%eax
  8003f6:	01 d0                	add    %edx,%eax
  8003f8:	c1 e0 03             	shl    $0x3,%eax
  8003fb:	01 c8                	add    %ecx,%eax
  8003fd:	8b 00                	mov    (%eax),%eax
  8003ff:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800402:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800405:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80040a:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80040c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80040f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800416:	8b 45 08             	mov    0x8(%ebp),%eax
  800419:	01 c8                	add    %ecx,%eax
  80041b:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80041d:	39 c2                	cmp    %eax,%edx
  80041f:	75 09                	jne    80042a <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800421:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800428:	eb 12                	jmp    80043c <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80042a:	ff 45 e8             	incl   -0x18(%ebp)
  80042d:	a1 20 50 80 00       	mov    0x805020,%eax
  800432:	8b 50 74             	mov    0x74(%eax),%edx
  800435:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800438:	39 c2                	cmp    %eax,%edx
  80043a:	77 88                	ja     8003c4 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80043c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800440:	75 14                	jne    800456 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800442:	83 ec 04             	sub    $0x4,%esp
  800445:	68 dc 39 80 00       	push   $0x8039dc
  80044a:	6a 3a                	push   $0x3a
  80044c:	68 d0 39 80 00       	push   $0x8039d0
  800451:	e8 93 fe ff ff       	call   8002e9 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800456:	ff 45 f0             	incl   -0x10(%ebp)
  800459:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80045c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80045f:	0f 8c 32 ff ff ff    	jl     800397 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800465:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80046c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800473:	eb 26                	jmp    80049b <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800475:	a1 20 50 80 00       	mov    0x805020,%eax
  80047a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800480:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800483:	89 d0                	mov    %edx,%eax
  800485:	01 c0                	add    %eax,%eax
  800487:	01 d0                	add    %edx,%eax
  800489:	c1 e0 03             	shl    $0x3,%eax
  80048c:	01 c8                	add    %ecx,%eax
  80048e:	8a 40 04             	mov    0x4(%eax),%al
  800491:	3c 01                	cmp    $0x1,%al
  800493:	75 03                	jne    800498 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800495:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800498:	ff 45 e0             	incl   -0x20(%ebp)
  80049b:	a1 20 50 80 00       	mov    0x805020,%eax
  8004a0:	8b 50 74             	mov    0x74(%eax),%edx
  8004a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004a6:	39 c2                	cmp    %eax,%edx
  8004a8:	77 cb                	ja     800475 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004ad:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004b0:	74 14                	je     8004c6 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8004b2:	83 ec 04             	sub    $0x4,%esp
  8004b5:	68 30 3a 80 00       	push   $0x803a30
  8004ba:	6a 44                	push   $0x44
  8004bc:	68 d0 39 80 00       	push   $0x8039d0
  8004c1:	e8 23 fe ff ff       	call   8002e9 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004c6:	90                   	nop
  8004c7:	c9                   	leave  
  8004c8:	c3                   	ret    

008004c9 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8004c9:	55                   	push   %ebp
  8004ca:	89 e5                	mov    %esp,%ebp
  8004cc:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8004cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004d2:	8b 00                	mov    (%eax),%eax
  8004d4:	8d 48 01             	lea    0x1(%eax),%ecx
  8004d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004da:	89 0a                	mov    %ecx,(%edx)
  8004dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8004df:	88 d1                	mov    %dl,%cl
  8004e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004e4:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004eb:	8b 00                	mov    (%eax),%eax
  8004ed:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004f2:	75 2c                	jne    800520 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8004f4:	a0 24 50 80 00       	mov    0x805024,%al
  8004f9:	0f b6 c0             	movzbl %al,%eax
  8004fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004ff:	8b 12                	mov    (%edx),%edx
  800501:	89 d1                	mov    %edx,%ecx
  800503:	8b 55 0c             	mov    0xc(%ebp),%edx
  800506:	83 c2 08             	add    $0x8,%edx
  800509:	83 ec 04             	sub    $0x4,%esp
  80050c:	50                   	push   %eax
  80050d:	51                   	push   %ecx
  80050e:	52                   	push   %edx
  80050f:	e8 fd 11 00 00       	call   801711 <sys_cputs>
  800514:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800517:	8b 45 0c             	mov    0xc(%ebp),%eax
  80051a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800520:	8b 45 0c             	mov    0xc(%ebp),%eax
  800523:	8b 40 04             	mov    0x4(%eax),%eax
  800526:	8d 50 01             	lea    0x1(%eax),%edx
  800529:	8b 45 0c             	mov    0xc(%ebp),%eax
  80052c:	89 50 04             	mov    %edx,0x4(%eax)
}
  80052f:	90                   	nop
  800530:	c9                   	leave  
  800531:	c3                   	ret    

00800532 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800532:	55                   	push   %ebp
  800533:	89 e5                	mov    %esp,%ebp
  800535:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80053b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800542:	00 00 00 
	b.cnt = 0;
  800545:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80054c:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80054f:	ff 75 0c             	pushl  0xc(%ebp)
  800552:	ff 75 08             	pushl  0x8(%ebp)
  800555:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80055b:	50                   	push   %eax
  80055c:	68 c9 04 80 00       	push   $0x8004c9
  800561:	e8 11 02 00 00       	call   800777 <vprintfmt>
  800566:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800569:	a0 24 50 80 00       	mov    0x805024,%al
  80056e:	0f b6 c0             	movzbl %al,%eax
  800571:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800577:	83 ec 04             	sub    $0x4,%esp
  80057a:	50                   	push   %eax
  80057b:	52                   	push   %edx
  80057c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800582:	83 c0 08             	add    $0x8,%eax
  800585:	50                   	push   %eax
  800586:	e8 86 11 00 00       	call   801711 <sys_cputs>
  80058b:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80058e:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800595:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80059b:	c9                   	leave  
  80059c:	c3                   	ret    

0080059d <cprintf>:

int cprintf(const char *fmt, ...) {
  80059d:	55                   	push   %ebp
  80059e:	89 e5                	mov    %esp,%ebp
  8005a0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005a3:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  8005aa:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b3:	83 ec 08             	sub    $0x8,%esp
  8005b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8005b9:	50                   	push   %eax
  8005ba:	e8 73 ff ff ff       	call   800532 <vcprintf>
  8005bf:	83 c4 10             	add    $0x10,%esp
  8005c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005c8:	c9                   	leave  
  8005c9:	c3                   	ret    

008005ca <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8005ca:	55                   	push   %ebp
  8005cb:	89 e5                	mov    %esp,%ebp
  8005cd:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005d0:	e8 ea 12 00 00       	call   8018bf <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8005d5:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005db:	8b 45 08             	mov    0x8(%ebp),%eax
  8005de:	83 ec 08             	sub    $0x8,%esp
  8005e1:	ff 75 f4             	pushl  -0xc(%ebp)
  8005e4:	50                   	push   %eax
  8005e5:	e8 48 ff ff ff       	call   800532 <vcprintf>
  8005ea:	83 c4 10             	add    $0x10,%esp
  8005ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8005f0:	e8 e4 12 00 00       	call   8018d9 <sys_enable_interrupt>
	return cnt;
  8005f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005f8:	c9                   	leave  
  8005f9:	c3                   	ret    

008005fa <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005fa:	55                   	push   %ebp
  8005fb:	89 e5                	mov    %esp,%ebp
  8005fd:	53                   	push   %ebx
  8005fe:	83 ec 14             	sub    $0x14,%esp
  800601:	8b 45 10             	mov    0x10(%ebp),%eax
  800604:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800607:	8b 45 14             	mov    0x14(%ebp),%eax
  80060a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80060d:	8b 45 18             	mov    0x18(%ebp),%eax
  800610:	ba 00 00 00 00       	mov    $0x0,%edx
  800615:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800618:	77 55                	ja     80066f <printnum+0x75>
  80061a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80061d:	72 05                	jb     800624 <printnum+0x2a>
  80061f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800622:	77 4b                	ja     80066f <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800624:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800627:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80062a:	8b 45 18             	mov    0x18(%ebp),%eax
  80062d:	ba 00 00 00 00       	mov    $0x0,%edx
  800632:	52                   	push   %edx
  800633:	50                   	push   %eax
  800634:	ff 75 f4             	pushl  -0xc(%ebp)
  800637:	ff 75 f0             	pushl  -0x10(%ebp)
  80063a:	e8 09 2e 00 00       	call   803448 <__udivdi3>
  80063f:	83 c4 10             	add    $0x10,%esp
  800642:	83 ec 04             	sub    $0x4,%esp
  800645:	ff 75 20             	pushl  0x20(%ebp)
  800648:	53                   	push   %ebx
  800649:	ff 75 18             	pushl  0x18(%ebp)
  80064c:	52                   	push   %edx
  80064d:	50                   	push   %eax
  80064e:	ff 75 0c             	pushl  0xc(%ebp)
  800651:	ff 75 08             	pushl  0x8(%ebp)
  800654:	e8 a1 ff ff ff       	call   8005fa <printnum>
  800659:	83 c4 20             	add    $0x20,%esp
  80065c:	eb 1a                	jmp    800678 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80065e:	83 ec 08             	sub    $0x8,%esp
  800661:	ff 75 0c             	pushl  0xc(%ebp)
  800664:	ff 75 20             	pushl  0x20(%ebp)
  800667:	8b 45 08             	mov    0x8(%ebp),%eax
  80066a:	ff d0                	call   *%eax
  80066c:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80066f:	ff 4d 1c             	decl   0x1c(%ebp)
  800672:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800676:	7f e6                	jg     80065e <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800678:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80067b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800680:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800683:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800686:	53                   	push   %ebx
  800687:	51                   	push   %ecx
  800688:	52                   	push   %edx
  800689:	50                   	push   %eax
  80068a:	e8 c9 2e 00 00       	call   803558 <__umoddi3>
  80068f:	83 c4 10             	add    $0x10,%esp
  800692:	05 94 3c 80 00       	add    $0x803c94,%eax
  800697:	8a 00                	mov    (%eax),%al
  800699:	0f be c0             	movsbl %al,%eax
  80069c:	83 ec 08             	sub    $0x8,%esp
  80069f:	ff 75 0c             	pushl  0xc(%ebp)
  8006a2:	50                   	push   %eax
  8006a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a6:	ff d0                	call   *%eax
  8006a8:	83 c4 10             	add    $0x10,%esp
}
  8006ab:	90                   	nop
  8006ac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006af:	c9                   	leave  
  8006b0:	c3                   	ret    

008006b1 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006b1:	55                   	push   %ebp
  8006b2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006b4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006b8:	7e 1c                	jle    8006d6 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8006ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bd:	8b 00                	mov    (%eax),%eax
  8006bf:	8d 50 08             	lea    0x8(%eax),%edx
  8006c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c5:	89 10                	mov    %edx,(%eax)
  8006c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ca:	8b 00                	mov    (%eax),%eax
  8006cc:	83 e8 08             	sub    $0x8,%eax
  8006cf:	8b 50 04             	mov    0x4(%eax),%edx
  8006d2:	8b 00                	mov    (%eax),%eax
  8006d4:	eb 40                	jmp    800716 <getuint+0x65>
	else if (lflag)
  8006d6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006da:	74 1e                	je     8006fa <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006df:	8b 00                	mov    (%eax),%eax
  8006e1:	8d 50 04             	lea    0x4(%eax),%edx
  8006e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e7:	89 10                	mov    %edx,(%eax)
  8006e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ec:	8b 00                	mov    (%eax),%eax
  8006ee:	83 e8 04             	sub    $0x4,%eax
  8006f1:	8b 00                	mov    (%eax),%eax
  8006f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8006f8:	eb 1c                	jmp    800716 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fd:	8b 00                	mov    (%eax),%eax
  8006ff:	8d 50 04             	lea    0x4(%eax),%edx
  800702:	8b 45 08             	mov    0x8(%ebp),%eax
  800705:	89 10                	mov    %edx,(%eax)
  800707:	8b 45 08             	mov    0x8(%ebp),%eax
  80070a:	8b 00                	mov    (%eax),%eax
  80070c:	83 e8 04             	sub    $0x4,%eax
  80070f:	8b 00                	mov    (%eax),%eax
  800711:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800716:	5d                   	pop    %ebp
  800717:	c3                   	ret    

00800718 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800718:	55                   	push   %ebp
  800719:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80071b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80071f:	7e 1c                	jle    80073d <getint+0x25>
		return va_arg(*ap, long long);
  800721:	8b 45 08             	mov    0x8(%ebp),%eax
  800724:	8b 00                	mov    (%eax),%eax
  800726:	8d 50 08             	lea    0x8(%eax),%edx
  800729:	8b 45 08             	mov    0x8(%ebp),%eax
  80072c:	89 10                	mov    %edx,(%eax)
  80072e:	8b 45 08             	mov    0x8(%ebp),%eax
  800731:	8b 00                	mov    (%eax),%eax
  800733:	83 e8 08             	sub    $0x8,%eax
  800736:	8b 50 04             	mov    0x4(%eax),%edx
  800739:	8b 00                	mov    (%eax),%eax
  80073b:	eb 38                	jmp    800775 <getint+0x5d>
	else if (lflag)
  80073d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800741:	74 1a                	je     80075d <getint+0x45>
		return va_arg(*ap, long);
  800743:	8b 45 08             	mov    0x8(%ebp),%eax
  800746:	8b 00                	mov    (%eax),%eax
  800748:	8d 50 04             	lea    0x4(%eax),%edx
  80074b:	8b 45 08             	mov    0x8(%ebp),%eax
  80074e:	89 10                	mov    %edx,(%eax)
  800750:	8b 45 08             	mov    0x8(%ebp),%eax
  800753:	8b 00                	mov    (%eax),%eax
  800755:	83 e8 04             	sub    $0x4,%eax
  800758:	8b 00                	mov    (%eax),%eax
  80075a:	99                   	cltd   
  80075b:	eb 18                	jmp    800775 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80075d:	8b 45 08             	mov    0x8(%ebp),%eax
  800760:	8b 00                	mov    (%eax),%eax
  800762:	8d 50 04             	lea    0x4(%eax),%edx
  800765:	8b 45 08             	mov    0x8(%ebp),%eax
  800768:	89 10                	mov    %edx,(%eax)
  80076a:	8b 45 08             	mov    0x8(%ebp),%eax
  80076d:	8b 00                	mov    (%eax),%eax
  80076f:	83 e8 04             	sub    $0x4,%eax
  800772:	8b 00                	mov    (%eax),%eax
  800774:	99                   	cltd   
}
  800775:	5d                   	pop    %ebp
  800776:	c3                   	ret    

00800777 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800777:	55                   	push   %ebp
  800778:	89 e5                	mov    %esp,%ebp
  80077a:	56                   	push   %esi
  80077b:	53                   	push   %ebx
  80077c:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80077f:	eb 17                	jmp    800798 <vprintfmt+0x21>
			if (ch == '\0')
  800781:	85 db                	test   %ebx,%ebx
  800783:	0f 84 af 03 00 00    	je     800b38 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800789:	83 ec 08             	sub    $0x8,%esp
  80078c:	ff 75 0c             	pushl  0xc(%ebp)
  80078f:	53                   	push   %ebx
  800790:	8b 45 08             	mov    0x8(%ebp),%eax
  800793:	ff d0                	call   *%eax
  800795:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800798:	8b 45 10             	mov    0x10(%ebp),%eax
  80079b:	8d 50 01             	lea    0x1(%eax),%edx
  80079e:	89 55 10             	mov    %edx,0x10(%ebp)
  8007a1:	8a 00                	mov    (%eax),%al
  8007a3:	0f b6 d8             	movzbl %al,%ebx
  8007a6:	83 fb 25             	cmp    $0x25,%ebx
  8007a9:	75 d6                	jne    800781 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007ab:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8007af:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8007b6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007bd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8007c4:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ce:	8d 50 01             	lea    0x1(%eax),%edx
  8007d1:	89 55 10             	mov    %edx,0x10(%ebp)
  8007d4:	8a 00                	mov    (%eax),%al
  8007d6:	0f b6 d8             	movzbl %al,%ebx
  8007d9:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007dc:	83 f8 55             	cmp    $0x55,%eax
  8007df:	0f 87 2b 03 00 00    	ja     800b10 <vprintfmt+0x399>
  8007e5:	8b 04 85 b8 3c 80 00 	mov    0x803cb8(,%eax,4),%eax
  8007ec:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007ee:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007f2:	eb d7                	jmp    8007cb <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007f4:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007f8:	eb d1                	jmp    8007cb <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007fa:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800801:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800804:	89 d0                	mov    %edx,%eax
  800806:	c1 e0 02             	shl    $0x2,%eax
  800809:	01 d0                	add    %edx,%eax
  80080b:	01 c0                	add    %eax,%eax
  80080d:	01 d8                	add    %ebx,%eax
  80080f:	83 e8 30             	sub    $0x30,%eax
  800812:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800815:	8b 45 10             	mov    0x10(%ebp),%eax
  800818:	8a 00                	mov    (%eax),%al
  80081a:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80081d:	83 fb 2f             	cmp    $0x2f,%ebx
  800820:	7e 3e                	jle    800860 <vprintfmt+0xe9>
  800822:	83 fb 39             	cmp    $0x39,%ebx
  800825:	7f 39                	jg     800860 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800827:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80082a:	eb d5                	jmp    800801 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80082c:	8b 45 14             	mov    0x14(%ebp),%eax
  80082f:	83 c0 04             	add    $0x4,%eax
  800832:	89 45 14             	mov    %eax,0x14(%ebp)
  800835:	8b 45 14             	mov    0x14(%ebp),%eax
  800838:	83 e8 04             	sub    $0x4,%eax
  80083b:	8b 00                	mov    (%eax),%eax
  80083d:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800840:	eb 1f                	jmp    800861 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800842:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800846:	79 83                	jns    8007cb <vprintfmt+0x54>
				width = 0;
  800848:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80084f:	e9 77 ff ff ff       	jmp    8007cb <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800854:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80085b:	e9 6b ff ff ff       	jmp    8007cb <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800860:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800861:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800865:	0f 89 60 ff ff ff    	jns    8007cb <vprintfmt+0x54>
				width = precision, precision = -1;
  80086b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80086e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800871:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800878:	e9 4e ff ff ff       	jmp    8007cb <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80087d:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800880:	e9 46 ff ff ff       	jmp    8007cb <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800885:	8b 45 14             	mov    0x14(%ebp),%eax
  800888:	83 c0 04             	add    $0x4,%eax
  80088b:	89 45 14             	mov    %eax,0x14(%ebp)
  80088e:	8b 45 14             	mov    0x14(%ebp),%eax
  800891:	83 e8 04             	sub    $0x4,%eax
  800894:	8b 00                	mov    (%eax),%eax
  800896:	83 ec 08             	sub    $0x8,%esp
  800899:	ff 75 0c             	pushl  0xc(%ebp)
  80089c:	50                   	push   %eax
  80089d:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a0:	ff d0                	call   *%eax
  8008a2:	83 c4 10             	add    $0x10,%esp
			break;
  8008a5:	e9 89 02 00 00       	jmp    800b33 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ad:	83 c0 04             	add    $0x4,%eax
  8008b0:	89 45 14             	mov    %eax,0x14(%ebp)
  8008b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b6:	83 e8 04             	sub    $0x4,%eax
  8008b9:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8008bb:	85 db                	test   %ebx,%ebx
  8008bd:	79 02                	jns    8008c1 <vprintfmt+0x14a>
				err = -err;
  8008bf:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8008c1:	83 fb 64             	cmp    $0x64,%ebx
  8008c4:	7f 0b                	jg     8008d1 <vprintfmt+0x15a>
  8008c6:	8b 34 9d 00 3b 80 00 	mov    0x803b00(,%ebx,4),%esi
  8008cd:	85 f6                	test   %esi,%esi
  8008cf:	75 19                	jne    8008ea <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008d1:	53                   	push   %ebx
  8008d2:	68 a5 3c 80 00       	push   $0x803ca5
  8008d7:	ff 75 0c             	pushl  0xc(%ebp)
  8008da:	ff 75 08             	pushl  0x8(%ebp)
  8008dd:	e8 5e 02 00 00       	call   800b40 <printfmt>
  8008e2:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008e5:	e9 49 02 00 00       	jmp    800b33 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008ea:	56                   	push   %esi
  8008eb:	68 ae 3c 80 00       	push   $0x803cae
  8008f0:	ff 75 0c             	pushl  0xc(%ebp)
  8008f3:	ff 75 08             	pushl  0x8(%ebp)
  8008f6:	e8 45 02 00 00       	call   800b40 <printfmt>
  8008fb:	83 c4 10             	add    $0x10,%esp
			break;
  8008fe:	e9 30 02 00 00       	jmp    800b33 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800903:	8b 45 14             	mov    0x14(%ebp),%eax
  800906:	83 c0 04             	add    $0x4,%eax
  800909:	89 45 14             	mov    %eax,0x14(%ebp)
  80090c:	8b 45 14             	mov    0x14(%ebp),%eax
  80090f:	83 e8 04             	sub    $0x4,%eax
  800912:	8b 30                	mov    (%eax),%esi
  800914:	85 f6                	test   %esi,%esi
  800916:	75 05                	jne    80091d <vprintfmt+0x1a6>
				p = "(null)";
  800918:	be b1 3c 80 00       	mov    $0x803cb1,%esi
			if (width > 0 && padc != '-')
  80091d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800921:	7e 6d                	jle    800990 <vprintfmt+0x219>
  800923:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800927:	74 67                	je     800990 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800929:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80092c:	83 ec 08             	sub    $0x8,%esp
  80092f:	50                   	push   %eax
  800930:	56                   	push   %esi
  800931:	e8 0c 03 00 00       	call   800c42 <strnlen>
  800936:	83 c4 10             	add    $0x10,%esp
  800939:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80093c:	eb 16                	jmp    800954 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80093e:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800942:	83 ec 08             	sub    $0x8,%esp
  800945:	ff 75 0c             	pushl  0xc(%ebp)
  800948:	50                   	push   %eax
  800949:	8b 45 08             	mov    0x8(%ebp),%eax
  80094c:	ff d0                	call   *%eax
  80094e:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800951:	ff 4d e4             	decl   -0x1c(%ebp)
  800954:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800958:	7f e4                	jg     80093e <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80095a:	eb 34                	jmp    800990 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80095c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800960:	74 1c                	je     80097e <vprintfmt+0x207>
  800962:	83 fb 1f             	cmp    $0x1f,%ebx
  800965:	7e 05                	jle    80096c <vprintfmt+0x1f5>
  800967:	83 fb 7e             	cmp    $0x7e,%ebx
  80096a:	7e 12                	jle    80097e <vprintfmt+0x207>
					putch('?', putdat);
  80096c:	83 ec 08             	sub    $0x8,%esp
  80096f:	ff 75 0c             	pushl  0xc(%ebp)
  800972:	6a 3f                	push   $0x3f
  800974:	8b 45 08             	mov    0x8(%ebp),%eax
  800977:	ff d0                	call   *%eax
  800979:	83 c4 10             	add    $0x10,%esp
  80097c:	eb 0f                	jmp    80098d <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80097e:	83 ec 08             	sub    $0x8,%esp
  800981:	ff 75 0c             	pushl  0xc(%ebp)
  800984:	53                   	push   %ebx
  800985:	8b 45 08             	mov    0x8(%ebp),%eax
  800988:	ff d0                	call   *%eax
  80098a:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80098d:	ff 4d e4             	decl   -0x1c(%ebp)
  800990:	89 f0                	mov    %esi,%eax
  800992:	8d 70 01             	lea    0x1(%eax),%esi
  800995:	8a 00                	mov    (%eax),%al
  800997:	0f be d8             	movsbl %al,%ebx
  80099a:	85 db                	test   %ebx,%ebx
  80099c:	74 24                	je     8009c2 <vprintfmt+0x24b>
  80099e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009a2:	78 b8                	js     80095c <vprintfmt+0x1e5>
  8009a4:	ff 4d e0             	decl   -0x20(%ebp)
  8009a7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009ab:	79 af                	jns    80095c <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009ad:	eb 13                	jmp    8009c2 <vprintfmt+0x24b>
				putch(' ', putdat);
  8009af:	83 ec 08             	sub    $0x8,%esp
  8009b2:	ff 75 0c             	pushl  0xc(%ebp)
  8009b5:	6a 20                	push   $0x20
  8009b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ba:	ff d0                	call   *%eax
  8009bc:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009bf:	ff 4d e4             	decl   -0x1c(%ebp)
  8009c2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009c6:	7f e7                	jg     8009af <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8009c8:	e9 66 01 00 00       	jmp    800b33 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009cd:	83 ec 08             	sub    $0x8,%esp
  8009d0:	ff 75 e8             	pushl  -0x18(%ebp)
  8009d3:	8d 45 14             	lea    0x14(%ebp),%eax
  8009d6:	50                   	push   %eax
  8009d7:	e8 3c fd ff ff       	call   800718 <getint>
  8009dc:	83 c4 10             	add    $0x10,%esp
  8009df:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009e2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009eb:	85 d2                	test   %edx,%edx
  8009ed:	79 23                	jns    800a12 <vprintfmt+0x29b>
				putch('-', putdat);
  8009ef:	83 ec 08             	sub    $0x8,%esp
  8009f2:	ff 75 0c             	pushl  0xc(%ebp)
  8009f5:	6a 2d                	push   $0x2d
  8009f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fa:	ff d0                	call   *%eax
  8009fc:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a02:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a05:	f7 d8                	neg    %eax
  800a07:	83 d2 00             	adc    $0x0,%edx
  800a0a:	f7 da                	neg    %edx
  800a0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a0f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a12:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a19:	e9 bc 00 00 00       	jmp    800ada <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a1e:	83 ec 08             	sub    $0x8,%esp
  800a21:	ff 75 e8             	pushl  -0x18(%ebp)
  800a24:	8d 45 14             	lea    0x14(%ebp),%eax
  800a27:	50                   	push   %eax
  800a28:	e8 84 fc ff ff       	call   8006b1 <getuint>
  800a2d:	83 c4 10             	add    $0x10,%esp
  800a30:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a33:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a36:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a3d:	e9 98 00 00 00       	jmp    800ada <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a42:	83 ec 08             	sub    $0x8,%esp
  800a45:	ff 75 0c             	pushl  0xc(%ebp)
  800a48:	6a 58                	push   $0x58
  800a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4d:	ff d0                	call   *%eax
  800a4f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a52:	83 ec 08             	sub    $0x8,%esp
  800a55:	ff 75 0c             	pushl  0xc(%ebp)
  800a58:	6a 58                	push   $0x58
  800a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5d:	ff d0                	call   *%eax
  800a5f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a62:	83 ec 08             	sub    $0x8,%esp
  800a65:	ff 75 0c             	pushl  0xc(%ebp)
  800a68:	6a 58                	push   $0x58
  800a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6d:	ff d0                	call   *%eax
  800a6f:	83 c4 10             	add    $0x10,%esp
			break;
  800a72:	e9 bc 00 00 00       	jmp    800b33 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a77:	83 ec 08             	sub    $0x8,%esp
  800a7a:	ff 75 0c             	pushl  0xc(%ebp)
  800a7d:	6a 30                	push   $0x30
  800a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a82:	ff d0                	call   *%eax
  800a84:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a87:	83 ec 08             	sub    $0x8,%esp
  800a8a:	ff 75 0c             	pushl  0xc(%ebp)
  800a8d:	6a 78                	push   $0x78
  800a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a92:	ff d0                	call   *%eax
  800a94:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a97:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9a:	83 c0 04             	add    $0x4,%eax
  800a9d:	89 45 14             	mov    %eax,0x14(%ebp)
  800aa0:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa3:	83 e8 04             	sub    $0x4,%eax
  800aa6:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800aa8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ab2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ab9:	eb 1f                	jmp    800ada <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800abb:	83 ec 08             	sub    $0x8,%esp
  800abe:	ff 75 e8             	pushl  -0x18(%ebp)
  800ac1:	8d 45 14             	lea    0x14(%ebp),%eax
  800ac4:	50                   	push   %eax
  800ac5:	e8 e7 fb ff ff       	call   8006b1 <getuint>
  800aca:	83 c4 10             	add    $0x10,%esp
  800acd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ad0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ad3:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ada:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ade:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ae1:	83 ec 04             	sub    $0x4,%esp
  800ae4:	52                   	push   %edx
  800ae5:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ae8:	50                   	push   %eax
  800ae9:	ff 75 f4             	pushl  -0xc(%ebp)
  800aec:	ff 75 f0             	pushl  -0x10(%ebp)
  800aef:	ff 75 0c             	pushl  0xc(%ebp)
  800af2:	ff 75 08             	pushl  0x8(%ebp)
  800af5:	e8 00 fb ff ff       	call   8005fa <printnum>
  800afa:	83 c4 20             	add    $0x20,%esp
			break;
  800afd:	eb 34                	jmp    800b33 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800aff:	83 ec 08             	sub    $0x8,%esp
  800b02:	ff 75 0c             	pushl  0xc(%ebp)
  800b05:	53                   	push   %ebx
  800b06:	8b 45 08             	mov    0x8(%ebp),%eax
  800b09:	ff d0                	call   *%eax
  800b0b:	83 c4 10             	add    $0x10,%esp
			break;
  800b0e:	eb 23                	jmp    800b33 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b10:	83 ec 08             	sub    $0x8,%esp
  800b13:	ff 75 0c             	pushl  0xc(%ebp)
  800b16:	6a 25                	push   $0x25
  800b18:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1b:	ff d0                	call   *%eax
  800b1d:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b20:	ff 4d 10             	decl   0x10(%ebp)
  800b23:	eb 03                	jmp    800b28 <vprintfmt+0x3b1>
  800b25:	ff 4d 10             	decl   0x10(%ebp)
  800b28:	8b 45 10             	mov    0x10(%ebp),%eax
  800b2b:	48                   	dec    %eax
  800b2c:	8a 00                	mov    (%eax),%al
  800b2e:	3c 25                	cmp    $0x25,%al
  800b30:	75 f3                	jne    800b25 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800b32:	90                   	nop
		}
	}
  800b33:	e9 47 fc ff ff       	jmp    80077f <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b38:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b39:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b3c:	5b                   	pop    %ebx
  800b3d:	5e                   	pop    %esi
  800b3e:	5d                   	pop    %ebp
  800b3f:	c3                   	ret    

00800b40 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b40:	55                   	push   %ebp
  800b41:	89 e5                	mov    %esp,%ebp
  800b43:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b46:	8d 45 10             	lea    0x10(%ebp),%eax
  800b49:	83 c0 04             	add    $0x4,%eax
  800b4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b4f:	8b 45 10             	mov    0x10(%ebp),%eax
  800b52:	ff 75 f4             	pushl  -0xc(%ebp)
  800b55:	50                   	push   %eax
  800b56:	ff 75 0c             	pushl  0xc(%ebp)
  800b59:	ff 75 08             	pushl  0x8(%ebp)
  800b5c:	e8 16 fc ff ff       	call   800777 <vprintfmt>
  800b61:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b64:	90                   	nop
  800b65:	c9                   	leave  
  800b66:	c3                   	ret    

00800b67 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b67:	55                   	push   %ebp
  800b68:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b6d:	8b 40 08             	mov    0x8(%eax),%eax
  800b70:	8d 50 01             	lea    0x1(%eax),%edx
  800b73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b76:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b7c:	8b 10                	mov    (%eax),%edx
  800b7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b81:	8b 40 04             	mov    0x4(%eax),%eax
  800b84:	39 c2                	cmp    %eax,%edx
  800b86:	73 12                	jae    800b9a <sprintputch+0x33>
		*b->buf++ = ch;
  800b88:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b8b:	8b 00                	mov    (%eax),%eax
  800b8d:	8d 48 01             	lea    0x1(%eax),%ecx
  800b90:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b93:	89 0a                	mov    %ecx,(%edx)
  800b95:	8b 55 08             	mov    0x8(%ebp),%edx
  800b98:	88 10                	mov    %dl,(%eax)
}
  800b9a:	90                   	nop
  800b9b:	5d                   	pop    %ebp
  800b9c:	c3                   	ret    

00800b9d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b9d:	55                   	push   %ebp
  800b9e:	89 e5                	mov    %esp,%ebp
  800ba0:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ba3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800ba9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bac:	8d 50 ff             	lea    -0x1(%eax),%edx
  800baf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb2:	01 d0                	add    %edx,%eax
  800bb4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bb7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800bbe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800bc2:	74 06                	je     800bca <vsnprintf+0x2d>
  800bc4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bc8:	7f 07                	jg     800bd1 <vsnprintf+0x34>
		return -E_INVAL;
  800bca:	b8 03 00 00 00       	mov    $0x3,%eax
  800bcf:	eb 20                	jmp    800bf1 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800bd1:	ff 75 14             	pushl  0x14(%ebp)
  800bd4:	ff 75 10             	pushl  0x10(%ebp)
  800bd7:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bda:	50                   	push   %eax
  800bdb:	68 67 0b 80 00       	push   $0x800b67
  800be0:	e8 92 fb ff ff       	call   800777 <vprintfmt>
  800be5:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800be8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800beb:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bee:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800bf1:	c9                   	leave  
  800bf2:	c3                   	ret    

00800bf3 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bf3:	55                   	push   %ebp
  800bf4:	89 e5                	mov    %esp,%ebp
  800bf6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bf9:	8d 45 10             	lea    0x10(%ebp),%eax
  800bfc:	83 c0 04             	add    $0x4,%eax
  800bff:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c02:	8b 45 10             	mov    0x10(%ebp),%eax
  800c05:	ff 75 f4             	pushl  -0xc(%ebp)
  800c08:	50                   	push   %eax
  800c09:	ff 75 0c             	pushl  0xc(%ebp)
  800c0c:	ff 75 08             	pushl  0x8(%ebp)
  800c0f:	e8 89 ff ff ff       	call   800b9d <vsnprintf>
  800c14:	83 c4 10             	add    $0x10,%esp
  800c17:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c1d:	c9                   	leave  
  800c1e:	c3                   	ret    

00800c1f <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c1f:	55                   	push   %ebp
  800c20:	89 e5                	mov    %esp,%ebp
  800c22:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c25:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c2c:	eb 06                	jmp    800c34 <strlen+0x15>
		n++;
  800c2e:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c31:	ff 45 08             	incl   0x8(%ebp)
  800c34:	8b 45 08             	mov    0x8(%ebp),%eax
  800c37:	8a 00                	mov    (%eax),%al
  800c39:	84 c0                	test   %al,%al
  800c3b:	75 f1                	jne    800c2e <strlen+0xf>
		n++;
	return n;
  800c3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c40:	c9                   	leave  
  800c41:	c3                   	ret    

00800c42 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c42:	55                   	push   %ebp
  800c43:	89 e5                	mov    %esp,%ebp
  800c45:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c48:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c4f:	eb 09                	jmp    800c5a <strnlen+0x18>
		n++;
  800c51:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c54:	ff 45 08             	incl   0x8(%ebp)
  800c57:	ff 4d 0c             	decl   0xc(%ebp)
  800c5a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c5e:	74 09                	je     800c69 <strnlen+0x27>
  800c60:	8b 45 08             	mov    0x8(%ebp),%eax
  800c63:	8a 00                	mov    (%eax),%al
  800c65:	84 c0                	test   %al,%al
  800c67:	75 e8                	jne    800c51 <strnlen+0xf>
		n++;
	return n;
  800c69:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c6c:	c9                   	leave  
  800c6d:	c3                   	ret    

00800c6e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c6e:	55                   	push   %ebp
  800c6f:	89 e5                	mov    %esp,%ebp
  800c71:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c74:	8b 45 08             	mov    0x8(%ebp),%eax
  800c77:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c7a:	90                   	nop
  800c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7e:	8d 50 01             	lea    0x1(%eax),%edx
  800c81:	89 55 08             	mov    %edx,0x8(%ebp)
  800c84:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c87:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c8a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c8d:	8a 12                	mov    (%edx),%dl
  800c8f:	88 10                	mov    %dl,(%eax)
  800c91:	8a 00                	mov    (%eax),%al
  800c93:	84 c0                	test   %al,%al
  800c95:	75 e4                	jne    800c7b <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c97:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c9a:	c9                   	leave  
  800c9b:	c3                   	ret    

00800c9c <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c9c:	55                   	push   %ebp
  800c9d:	89 e5                	mov    %esp,%ebp
  800c9f:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ca8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800caf:	eb 1f                	jmp    800cd0 <strncpy+0x34>
		*dst++ = *src;
  800cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb4:	8d 50 01             	lea    0x1(%eax),%edx
  800cb7:	89 55 08             	mov    %edx,0x8(%ebp)
  800cba:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cbd:	8a 12                	mov    (%edx),%dl
  800cbf:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800cc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc4:	8a 00                	mov    (%eax),%al
  800cc6:	84 c0                	test   %al,%al
  800cc8:	74 03                	je     800ccd <strncpy+0x31>
			src++;
  800cca:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ccd:	ff 45 fc             	incl   -0x4(%ebp)
  800cd0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cd3:	3b 45 10             	cmp    0x10(%ebp),%eax
  800cd6:	72 d9                	jb     800cb1 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800cd8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800cdb:	c9                   	leave  
  800cdc:	c3                   	ret    

00800cdd <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800cdd:	55                   	push   %ebp
  800cde:	89 e5                	mov    %esp,%ebp
  800ce0:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ce9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ced:	74 30                	je     800d1f <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800cef:	eb 16                	jmp    800d07 <strlcpy+0x2a>
			*dst++ = *src++;
  800cf1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf4:	8d 50 01             	lea    0x1(%eax),%edx
  800cf7:	89 55 08             	mov    %edx,0x8(%ebp)
  800cfa:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cfd:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d00:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d03:	8a 12                	mov    (%edx),%dl
  800d05:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d07:	ff 4d 10             	decl   0x10(%ebp)
  800d0a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d0e:	74 09                	je     800d19 <strlcpy+0x3c>
  800d10:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d13:	8a 00                	mov    (%eax),%al
  800d15:	84 c0                	test   %al,%al
  800d17:	75 d8                	jne    800cf1 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d19:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d1f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d22:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d25:	29 c2                	sub    %eax,%edx
  800d27:	89 d0                	mov    %edx,%eax
}
  800d29:	c9                   	leave  
  800d2a:	c3                   	ret    

00800d2b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d2b:	55                   	push   %ebp
  800d2c:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d2e:	eb 06                	jmp    800d36 <strcmp+0xb>
		p++, q++;
  800d30:	ff 45 08             	incl   0x8(%ebp)
  800d33:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d36:	8b 45 08             	mov    0x8(%ebp),%eax
  800d39:	8a 00                	mov    (%eax),%al
  800d3b:	84 c0                	test   %al,%al
  800d3d:	74 0e                	je     800d4d <strcmp+0x22>
  800d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d42:	8a 10                	mov    (%eax),%dl
  800d44:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d47:	8a 00                	mov    (%eax),%al
  800d49:	38 c2                	cmp    %al,%dl
  800d4b:	74 e3                	je     800d30 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d50:	8a 00                	mov    (%eax),%al
  800d52:	0f b6 d0             	movzbl %al,%edx
  800d55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d58:	8a 00                	mov    (%eax),%al
  800d5a:	0f b6 c0             	movzbl %al,%eax
  800d5d:	29 c2                	sub    %eax,%edx
  800d5f:	89 d0                	mov    %edx,%eax
}
  800d61:	5d                   	pop    %ebp
  800d62:	c3                   	ret    

00800d63 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d63:	55                   	push   %ebp
  800d64:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d66:	eb 09                	jmp    800d71 <strncmp+0xe>
		n--, p++, q++;
  800d68:	ff 4d 10             	decl   0x10(%ebp)
  800d6b:	ff 45 08             	incl   0x8(%ebp)
  800d6e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d71:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d75:	74 17                	je     800d8e <strncmp+0x2b>
  800d77:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7a:	8a 00                	mov    (%eax),%al
  800d7c:	84 c0                	test   %al,%al
  800d7e:	74 0e                	je     800d8e <strncmp+0x2b>
  800d80:	8b 45 08             	mov    0x8(%ebp),%eax
  800d83:	8a 10                	mov    (%eax),%dl
  800d85:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d88:	8a 00                	mov    (%eax),%al
  800d8a:	38 c2                	cmp    %al,%dl
  800d8c:	74 da                	je     800d68 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d8e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d92:	75 07                	jne    800d9b <strncmp+0x38>
		return 0;
  800d94:	b8 00 00 00 00       	mov    $0x0,%eax
  800d99:	eb 14                	jmp    800daf <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9e:	8a 00                	mov    (%eax),%al
  800da0:	0f b6 d0             	movzbl %al,%edx
  800da3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da6:	8a 00                	mov    (%eax),%al
  800da8:	0f b6 c0             	movzbl %al,%eax
  800dab:	29 c2                	sub    %eax,%edx
  800dad:	89 d0                	mov    %edx,%eax
}
  800daf:	5d                   	pop    %ebp
  800db0:	c3                   	ret    

00800db1 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800db1:	55                   	push   %ebp
  800db2:	89 e5                	mov    %esp,%ebp
  800db4:	83 ec 04             	sub    $0x4,%esp
  800db7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dba:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dbd:	eb 12                	jmp    800dd1 <strchr+0x20>
		if (*s == c)
  800dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc2:	8a 00                	mov    (%eax),%al
  800dc4:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dc7:	75 05                	jne    800dce <strchr+0x1d>
			return (char *) s;
  800dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcc:	eb 11                	jmp    800ddf <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800dce:	ff 45 08             	incl   0x8(%ebp)
  800dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd4:	8a 00                	mov    (%eax),%al
  800dd6:	84 c0                	test   %al,%al
  800dd8:	75 e5                	jne    800dbf <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800dda:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ddf:	c9                   	leave  
  800de0:	c3                   	ret    

00800de1 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800de1:	55                   	push   %ebp
  800de2:	89 e5                	mov    %esp,%ebp
  800de4:	83 ec 04             	sub    $0x4,%esp
  800de7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dea:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ded:	eb 0d                	jmp    800dfc <strfind+0x1b>
		if (*s == c)
  800def:	8b 45 08             	mov    0x8(%ebp),%eax
  800df2:	8a 00                	mov    (%eax),%al
  800df4:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800df7:	74 0e                	je     800e07 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800df9:	ff 45 08             	incl   0x8(%ebp)
  800dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dff:	8a 00                	mov    (%eax),%al
  800e01:	84 c0                	test   %al,%al
  800e03:	75 ea                	jne    800def <strfind+0xe>
  800e05:	eb 01                	jmp    800e08 <strfind+0x27>
		if (*s == c)
			break;
  800e07:	90                   	nop
	return (char *) s;
  800e08:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e0b:	c9                   	leave  
  800e0c:	c3                   	ret    

00800e0d <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800e0d:	55                   	push   %ebp
  800e0e:	89 e5                	mov    %esp,%ebp
  800e10:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e13:	8b 45 08             	mov    0x8(%ebp),%eax
  800e16:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e19:	8b 45 10             	mov    0x10(%ebp),%eax
  800e1c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e1f:	eb 0e                	jmp    800e2f <memset+0x22>
		*p++ = c;
  800e21:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e24:	8d 50 01             	lea    0x1(%eax),%edx
  800e27:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e2d:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e2f:	ff 4d f8             	decl   -0x8(%ebp)
  800e32:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e36:	79 e9                	jns    800e21 <memset+0x14>
		*p++ = c;

	return v;
  800e38:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e3b:	c9                   	leave  
  800e3c:	c3                   	ret    

00800e3d <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e3d:	55                   	push   %ebp
  800e3e:	89 e5                	mov    %esp,%ebp
  800e40:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e46:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e49:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e4f:	eb 16                	jmp    800e67 <memcpy+0x2a>
		*d++ = *s++;
  800e51:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e54:	8d 50 01             	lea    0x1(%eax),%edx
  800e57:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e5a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e5d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e60:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e63:	8a 12                	mov    (%edx),%dl
  800e65:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e67:	8b 45 10             	mov    0x10(%ebp),%eax
  800e6a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e6d:	89 55 10             	mov    %edx,0x10(%ebp)
  800e70:	85 c0                	test   %eax,%eax
  800e72:	75 dd                	jne    800e51 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e74:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e77:	c9                   	leave  
  800e78:	c3                   	ret    

00800e79 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e79:	55                   	push   %ebp
  800e7a:	89 e5                	mov    %esp,%ebp
  800e7c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e82:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e85:	8b 45 08             	mov    0x8(%ebp),%eax
  800e88:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e8b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e8e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e91:	73 50                	jae    800ee3 <memmove+0x6a>
  800e93:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e96:	8b 45 10             	mov    0x10(%ebp),%eax
  800e99:	01 d0                	add    %edx,%eax
  800e9b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e9e:	76 43                	jbe    800ee3 <memmove+0x6a>
		s += n;
  800ea0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea3:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800ea6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea9:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800eac:	eb 10                	jmp    800ebe <memmove+0x45>
			*--d = *--s;
  800eae:	ff 4d f8             	decl   -0x8(%ebp)
  800eb1:	ff 4d fc             	decl   -0x4(%ebp)
  800eb4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eb7:	8a 10                	mov    (%eax),%dl
  800eb9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ebc:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800ebe:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ec4:	89 55 10             	mov    %edx,0x10(%ebp)
  800ec7:	85 c0                	test   %eax,%eax
  800ec9:	75 e3                	jne    800eae <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ecb:	eb 23                	jmp    800ef0 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800ecd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ed0:	8d 50 01             	lea    0x1(%eax),%edx
  800ed3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ed6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ed9:	8d 4a 01             	lea    0x1(%edx),%ecx
  800edc:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800edf:	8a 12                	mov    (%edx),%dl
  800ee1:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800ee3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee6:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ee9:	89 55 10             	mov    %edx,0x10(%ebp)
  800eec:	85 c0                	test   %eax,%eax
  800eee:	75 dd                	jne    800ecd <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ef0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ef3:	c9                   	leave  
  800ef4:	c3                   	ret    

00800ef5 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ef5:	55                   	push   %ebp
  800ef6:	89 e5                	mov    %esp,%ebp
  800ef8:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800efb:	8b 45 08             	mov    0x8(%ebp),%eax
  800efe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f01:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f04:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f07:	eb 2a                	jmp    800f33 <memcmp+0x3e>
		if (*s1 != *s2)
  800f09:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f0c:	8a 10                	mov    (%eax),%dl
  800f0e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f11:	8a 00                	mov    (%eax),%al
  800f13:	38 c2                	cmp    %al,%dl
  800f15:	74 16                	je     800f2d <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f17:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f1a:	8a 00                	mov    (%eax),%al
  800f1c:	0f b6 d0             	movzbl %al,%edx
  800f1f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f22:	8a 00                	mov    (%eax),%al
  800f24:	0f b6 c0             	movzbl %al,%eax
  800f27:	29 c2                	sub    %eax,%edx
  800f29:	89 d0                	mov    %edx,%eax
  800f2b:	eb 18                	jmp    800f45 <memcmp+0x50>
		s1++, s2++;
  800f2d:	ff 45 fc             	incl   -0x4(%ebp)
  800f30:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f33:	8b 45 10             	mov    0x10(%ebp),%eax
  800f36:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f39:	89 55 10             	mov    %edx,0x10(%ebp)
  800f3c:	85 c0                	test   %eax,%eax
  800f3e:	75 c9                	jne    800f09 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f40:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f45:	c9                   	leave  
  800f46:	c3                   	ret    

00800f47 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f47:	55                   	push   %ebp
  800f48:	89 e5                	mov    %esp,%ebp
  800f4a:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f4d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f50:	8b 45 10             	mov    0x10(%ebp),%eax
  800f53:	01 d0                	add    %edx,%eax
  800f55:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f58:	eb 15                	jmp    800f6f <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5d:	8a 00                	mov    (%eax),%al
  800f5f:	0f b6 d0             	movzbl %al,%edx
  800f62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f65:	0f b6 c0             	movzbl %al,%eax
  800f68:	39 c2                	cmp    %eax,%edx
  800f6a:	74 0d                	je     800f79 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f6c:	ff 45 08             	incl   0x8(%ebp)
  800f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f72:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f75:	72 e3                	jb     800f5a <memfind+0x13>
  800f77:	eb 01                	jmp    800f7a <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f79:	90                   	nop
	return (void *) s;
  800f7a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f7d:	c9                   	leave  
  800f7e:	c3                   	ret    

00800f7f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f7f:	55                   	push   %ebp
  800f80:	89 e5                	mov    %esp,%ebp
  800f82:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f85:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f8c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f93:	eb 03                	jmp    800f98 <strtol+0x19>
		s++;
  800f95:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f98:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9b:	8a 00                	mov    (%eax),%al
  800f9d:	3c 20                	cmp    $0x20,%al
  800f9f:	74 f4                	je     800f95 <strtol+0x16>
  800fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa4:	8a 00                	mov    (%eax),%al
  800fa6:	3c 09                	cmp    $0x9,%al
  800fa8:	74 eb                	je     800f95 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800faa:	8b 45 08             	mov    0x8(%ebp),%eax
  800fad:	8a 00                	mov    (%eax),%al
  800faf:	3c 2b                	cmp    $0x2b,%al
  800fb1:	75 05                	jne    800fb8 <strtol+0x39>
		s++;
  800fb3:	ff 45 08             	incl   0x8(%ebp)
  800fb6:	eb 13                	jmp    800fcb <strtol+0x4c>
	else if (*s == '-')
  800fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbb:	8a 00                	mov    (%eax),%al
  800fbd:	3c 2d                	cmp    $0x2d,%al
  800fbf:	75 0a                	jne    800fcb <strtol+0x4c>
		s++, neg = 1;
  800fc1:	ff 45 08             	incl   0x8(%ebp)
  800fc4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800fcb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fcf:	74 06                	je     800fd7 <strtol+0x58>
  800fd1:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800fd5:	75 20                	jne    800ff7 <strtol+0x78>
  800fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fda:	8a 00                	mov    (%eax),%al
  800fdc:	3c 30                	cmp    $0x30,%al
  800fde:	75 17                	jne    800ff7 <strtol+0x78>
  800fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe3:	40                   	inc    %eax
  800fe4:	8a 00                	mov    (%eax),%al
  800fe6:	3c 78                	cmp    $0x78,%al
  800fe8:	75 0d                	jne    800ff7 <strtol+0x78>
		s += 2, base = 16;
  800fea:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800fee:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800ff5:	eb 28                	jmp    80101f <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800ff7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ffb:	75 15                	jne    801012 <strtol+0x93>
  800ffd:	8b 45 08             	mov    0x8(%ebp),%eax
  801000:	8a 00                	mov    (%eax),%al
  801002:	3c 30                	cmp    $0x30,%al
  801004:	75 0c                	jne    801012 <strtol+0x93>
		s++, base = 8;
  801006:	ff 45 08             	incl   0x8(%ebp)
  801009:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801010:	eb 0d                	jmp    80101f <strtol+0xa0>
	else if (base == 0)
  801012:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801016:	75 07                	jne    80101f <strtol+0xa0>
		base = 10;
  801018:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80101f:	8b 45 08             	mov    0x8(%ebp),%eax
  801022:	8a 00                	mov    (%eax),%al
  801024:	3c 2f                	cmp    $0x2f,%al
  801026:	7e 19                	jle    801041 <strtol+0xc2>
  801028:	8b 45 08             	mov    0x8(%ebp),%eax
  80102b:	8a 00                	mov    (%eax),%al
  80102d:	3c 39                	cmp    $0x39,%al
  80102f:	7f 10                	jg     801041 <strtol+0xc2>
			dig = *s - '0';
  801031:	8b 45 08             	mov    0x8(%ebp),%eax
  801034:	8a 00                	mov    (%eax),%al
  801036:	0f be c0             	movsbl %al,%eax
  801039:	83 e8 30             	sub    $0x30,%eax
  80103c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80103f:	eb 42                	jmp    801083 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801041:	8b 45 08             	mov    0x8(%ebp),%eax
  801044:	8a 00                	mov    (%eax),%al
  801046:	3c 60                	cmp    $0x60,%al
  801048:	7e 19                	jle    801063 <strtol+0xe4>
  80104a:	8b 45 08             	mov    0x8(%ebp),%eax
  80104d:	8a 00                	mov    (%eax),%al
  80104f:	3c 7a                	cmp    $0x7a,%al
  801051:	7f 10                	jg     801063 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801053:	8b 45 08             	mov    0x8(%ebp),%eax
  801056:	8a 00                	mov    (%eax),%al
  801058:	0f be c0             	movsbl %al,%eax
  80105b:	83 e8 57             	sub    $0x57,%eax
  80105e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801061:	eb 20                	jmp    801083 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801063:	8b 45 08             	mov    0x8(%ebp),%eax
  801066:	8a 00                	mov    (%eax),%al
  801068:	3c 40                	cmp    $0x40,%al
  80106a:	7e 39                	jle    8010a5 <strtol+0x126>
  80106c:	8b 45 08             	mov    0x8(%ebp),%eax
  80106f:	8a 00                	mov    (%eax),%al
  801071:	3c 5a                	cmp    $0x5a,%al
  801073:	7f 30                	jg     8010a5 <strtol+0x126>
			dig = *s - 'A' + 10;
  801075:	8b 45 08             	mov    0x8(%ebp),%eax
  801078:	8a 00                	mov    (%eax),%al
  80107a:	0f be c0             	movsbl %al,%eax
  80107d:	83 e8 37             	sub    $0x37,%eax
  801080:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801083:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801086:	3b 45 10             	cmp    0x10(%ebp),%eax
  801089:	7d 19                	jge    8010a4 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80108b:	ff 45 08             	incl   0x8(%ebp)
  80108e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801091:	0f af 45 10          	imul   0x10(%ebp),%eax
  801095:	89 c2                	mov    %eax,%edx
  801097:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80109a:	01 d0                	add    %edx,%eax
  80109c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80109f:	e9 7b ff ff ff       	jmp    80101f <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8010a4:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8010a5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010a9:	74 08                	je     8010b3 <strtol+0x134>
		*endptr = (char *) s;
  8010ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b1:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8010b3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010b7:	74 07                	je     8010c0 <strtol+0x141>
  8010b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010bc:	f7 d8                	neg    %eax
  8010be:	eb 03                	jmp    8010c3 <strtol+0x144>
  8010c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010c3:	c9                   	leave  
  8010c4:	c3                   	ret    

008010c5 <ltostr>:

void
ltostr(long value, char *str)
{
  8010c5:	55                   	push   %ebp
  8010c6:	89 e5                	mov    %esp,%ebp
  8010c8:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8010cb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8010d2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8010d9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010dd:	79 13                	jns    8010f2 <ltostr+0x2d>
	{
		neg = 1;
  8010df:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8010e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e9:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8010ec:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8010ef:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8010f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f5:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010fa:	99                   	cltd   
  8010fb:	f7 f9                	idiv   %ecx
  8010fd:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801100:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801103:	8d 50 01             	lea    0x1(%eax),%edx
  801106:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801109:	89 c2                	mov    %eax,%edx
  80110b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110e:	01 d0                	add    %edx,%eax
  801110:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801113:	83 c2 30             	add    $0x30,%edx
  801116:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801118:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80111b:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801120:	f7 e9                	imul   %ecx
  801122:	c1 fa 02             	sar    $0x2,%edx
  801125:	89 c8                	mov    %ecx,%eax
  801127:	c1 f8 1f             	sar    $0x1f,%eax
  80112a:	29 c2                	sub    %eax,%edx
  80112c:	89 d0                	mov    %edx,%eax
  80112e:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801131:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801134:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801139:	f7 e9                	imul   %ecx
  80113b:	c1 fa 02             	sar    $0x2,%edx
  80113e:	89 c8                	mov    %ecx,%eax
  801140:	c1 f8 1f             	sar    $0x1f,%eax
  801143:	29 c2                	sub    %eax,%edx
  801145:	89 d0                	mov    %edx,%eax
  801147:	c1 e0 02             	shl    $0x2,%eax
  80114a:	01 d0                	add    %edx,%eax
  80114c:	01 c0                	add    %eax,%eax
  80114e:	29 c1                	sub    %eax,%ecx
  801150:	89 ca                	mov    %ecx,%edx
  801152:	85 d2                	test   %edx,%edx
  801154:	75 9c                	jne    8010f2 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801156:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80115d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801160:	48                   	dec    %eax
  801161:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801164:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801168:	74 3d                	je     8011a7 <ltostr+0xe2>
		start = 1 ;
  80116a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801171:	eb 34                	jmp    8011a7 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801173:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801176:	8b 45 0c             	mov    0xc(%ebp),%eax
  801179:	01 d0                	add    %edx,%eax
  80117b:	8a 00                	mov    (%eax),%al
  80117d:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801180:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801183:	8b 45 0c             	mov    0xc(%ebp),%eax
  801186:	01 c2                	add    %eax,%edx
  801188:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80118b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118e:	01 c8                	add    %ecx,%eax
  801190:	8a 00                	mov    (%eax),%al
  801192:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801194:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801197:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119a:	01 c2                	add    %eax,%edx
  80119c:	8a 45 eb             	mov    -0x15(%ebp),%al
  80119f:	88 02                	mov    %al,(%edx)
		start++ ;
  8011a1:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8011a4:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8011a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011aa:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011ad:	7c c4                	jl     801173 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8011af:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8011b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b5:	01 d0                	add    %edx,%eax
  8011b7:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8011ba:	90                   	nop
  8011bb:	c9                   	leave  
  8011bc:	c3                   	ret    

008011bd <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8011bd:	55                   	push   %ebp
  8011be:	89 e5                	mov    %esp,%ebp
  8011c0:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8011c3:	ff 75 08             	pushl  0x8(%ebp)
  8011c6:	e8 54 fa ff ff       	call   800c1f <strlen>
  8011cb:	83 c4 04             	add    $0x4,%esp
  8011ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8011d1:	ff 75 0c             	pushl  0xc(%ebp)
  8011d4:	e8 46 fa ff ff       	call   800c1f <strlen>
  8011d9:	83 c4 04             	add    $0x4,%esp
  8011dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8011df:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8011e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011ed:	eb 17                	jmp    801206 <strcconcat+0x49>
		final[s] = str1[s] ;
  8011ef:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f5:	01 c2                	add    %eax,%edx
  8011f7:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fd:	01 c8                	add    %ecx,%eax
  8011ff:	8a 00                	mov    (%eax),%al
  801201:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801203:	ff 45 fc             	incl   -0x4(%ebp)
  801206:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801209:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80120c:	7c e1                	jl     8011ef <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80120e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801215:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80121c:	eb 1f                	jmp    80123d <strcconcat+0x80>
		final[s++] = str2[i] ;
  80121e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801221:	8d 50 01             	lea    0x1(%eax),%edx
  801224:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801227:	89 c2                	mov    %eax,%edx
  801229:	8b 45 10             	mov    0x10(%ebp),%eax
  80122c:	01 c2                	add    %eax,%edx
  80122e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801231:	8b 45 0c             	mov    0xc(%ebp),%eax
  801234:	01 c8                	add    %ecx,%eax
  801236:	8a 00                	mov    (%eax),%al
  801238:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80123a:	ff 45 f8             	incl   -0x8(%ebp)
  80123d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801240:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801243:	7c d9                	jl     80121e <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801245:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801248:	8b 45 10             	mov    0x10(%ebp),%eax
  80124b:	01 d0                	add    %edx,%eax
  80124d:	c6 00 00             	movb   $0x0,(%eax)
}
  801250:	90                   	nop
  801251:	c9                   	leave  
  801252:	c3                   	ret    

00801253 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801253:	55                   	push   %ebp
  801254:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801256:	8b 45 14             	mov    0x14(%ebp),%eax
  801259:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80125f:	8b 45 14             	mov    0x14(%ebp),%eax
  801262:	8b 00                	mov    (%eax),%eax
  801264:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80126b:	8b 45 10             	mov    0x10(%ebp),%eax
  80126e:	01 d0                	add    %edx,%eax
  801270:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801276:	eb 0c                	jmp    801284 <strsplit+0x31>
			*string++ = 0;
  801278:	8b 45 08             	mov    0x8(%ebp),%eax
  80127b:	8d 50 01             	lea    0x1(%eax),%edx
  80127e:	89 55 08             	mov    %edx,0x8(%ebp)
  801281:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801284:	8b 45 08             	mov    0x8(%ebp),%eax
  801287:	8a 00                	mov    (%eax),%al
  801289:	84 c0                	test   %al,%al
  80128b:	74 18                	je     8012a5 <strsplit+0x52>
  80128d:	8b 45 08             	mov    0x8(%ebp),%eax
  801290:	8a 00                	mov    (%eax),%al
  801292:	0f be c0             	movsbl %al,%eax
  801295:	50                   	push   %eax
  801296:	ff 75 0c             	pushl  0xc(%ebp)
  801299:	e8 13 fb ff ff       	call   800db1 <strchr>
  80129e:	83 c4 08             	add    $0x8,%esp
  8012a1:	85 c0                	test   %eax,%eax
  8012a3:	75 d3                	jne    801278 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8012a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a8:	8a 00                	mov    (%eax),%al
  8012aa:	84 c0                	test   %al,%al
  8012ac:	74 5a                	je     801308 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8012ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8012b1:	8b 00                	mov    (%eax),%eax
  8012b3:	83 f8 0f             	cmp    $0xf,%eax
  8012b6:	75 07                	jne    8012bf <strsplit+0x6c>
		{
			return 0;
  8012b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8012bd:	eb 66                	jmp    801325 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8012bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8012c2:	8b 00                	mov    (%eax),%eax
  8012c4:	8d 48 01             	lea    0x1(%eax),%ecx
  8012c7:	8b 55 14             	mov    0x14(%ebp),%edx
  8012ca:	89 0a                	mov    %ecx,(%edx)
  8012cc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d6:	01 c2                	add    %eax,%edx
  8012d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012db:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012dd:	eb 03                	jmp    8012e2 <strsplit+0x8f>
			string++;
  8012df:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e5:	8a 00                	mov    (%eax),%al
  8012e7:	84 c0                	test   %al,%al
  8012e9:	74 8b                	je     801276 <strsplit+0x23>
  8012eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ee:	8a 00                	mov    (%eax),%al
  8012f0:	0f be c0             	movsbl %al,%eax
  8012f3:	50                   	push   %eax
  8012f4:	ff 75 0c             	pushl  0xc(%ebp)
  8012f7:	e8 b5 fa ff ff       	call   800db1 <strchr>
  8012fc:	83 c4 08             	add    $0x8,%esp
  8012ff:	85 c0                	test   %eax,%eax
  801301:	74 dc                	je     8012df <strsplit+0x8c>
			string++;
	}
  801303:	e9 6e ff ff ff       	jmp    801276 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801308:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801309:	8b 45 14             	mov    0x14(%ebp),%eax
  80130c:	8b 00                	mov    (%eax),%eax
  80130e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801315:	8b 45 10             	mov    0x10(%ebp),%eax
  801318:	01 d0                	add    %edx,%eax
  80131a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801320:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801325:	c9                   	leave  
  801326:	c3                   	ret    

00801327 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801327:	55                   	push   %ebp
  801328:	89 e5                	mov    %esp,%ebp
  80132a:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  80132d:	a1 04 50 80 00       	mov    0x805004,%eax
  801332:	85 c0                	test   %eax,%eax
  801334:	74 1f                	je     801355 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801336:	e8 1d 00 00 00       	call   801358 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  80133b:	83 ec 0c             	sub    $0xc,%esp
  80133e:	68 10 3e 80 00       	push   $0x803e10
  801343:	e8 55 f2 ff ff       	call   80059d <cprintf>
  801348:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80134b:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801352:	00 00 00 
	}
}
  801355:	90                   	nop
  801356:	c9                   	leave  
  801357:	c3                   	ret    

00801358 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801358:	55                   	push   %ebp
  801359:	89 e5                	mov    %esp,%ebp
  80135b:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	LIST_INIT(&AllocMemBlocksList);
  80135e:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801365:	00 00 00 
  801368:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  80136f:	00 00 00 
  801372:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801379:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  80137c:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801383:	00 00 00 
  801386:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  80138d:	00 00 00 
  801390:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801397:	00 00 00 
	uint32 arr_size = 0;
  80139a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	MemBlockNodes  =(struct MemBlock*) USER_DYN_BLKS_ARRAY;
  8013a1:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  8013a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013ab:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013b0:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013b5:	a3 50 50 80 00       	mov    %eax,0x805050
	MAX_MEM_BLOCK_CNT = (USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE;
  8013ba:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  8013c1:	00 02 00 
	arr_size =  ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock), PAGE_SIZE);
  8013c4:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8013cb:	a1 20 51 80 00       	mov    0x805120,%eax
  8013d0:	c1 e0 04             	shl    $0x4,%eax
  8013d3:	89 c2                	mov    %eax,%edx
  8013d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013d8:	01 d0                	add    %edx,%eax
  8013da:	48                   	dec    %eax
  8013db:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8013de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8013e6:	f7 75 ec             	divl   -0x14(%ebp)
  8013e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013ec:	29 d0                	sub    %edx,%eax
  8013ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_USER);
  8013f1:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8013f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013fb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801400:	2d 00 10 00 00       	sub    $0x1000,%eax
  801405:	83 ec 04             	sub    $0x4,%esp
  801408:	6a 06                	push   $0x6
  80140a:	ff 75 f4             	pushl  -0xc(%ebp)
  80140d:	50                   	push   %eax
  80140e:	e8 42 04 00 00       	call   801855 <sys_allocate_chunk>
  801413:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801416:	a1 20 51 80 00       	mov    0x805120,%eax
  80141b:	83 ec 0c             	sub    $0xc,%esp
  80141e:	50                   	push   %eax
  80141f:	e8 b7 0a 00 00       	call   801edb <initialize_MemBlocksList>
  801424:	83 c4 10             	add    $0x10,%esp
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	struct MemBlock * NewBlock = LIST_FIRST(&AvailableMemBlocksList);
  801427:	a1 48 51 80 00       	mov    0x805148,%eax
  80142c:	89 45 e0             	mov    %eax,-0x20(%ebp)
	NewBlock->sva = USER_HEAP_START;
  80142f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801432:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	NewBlock->size = (USER_HEAP_MAX-USER_HEAP_START);
  801439:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80143c:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	LIST_REMOVE(&AvailableMemBlocksList,NewBlock);
  801443:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801447:	75 14                	jne    80145d <initialize_dyn_block_system+0x105>
  801449:	83 ec 04             	sub    $0x4,%esp
  80144c:	68 35 3e 80 00       	push   $0x803e35
  801451:	6a 33                	push   $0x33
  801453:	68 53 3e 80 00       	push   $0x803e53
  801458:	e8 8c ee ff ff       	call   8002e9 <_panic>
  80145d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801460:	8b 00                	mov    (%eax),%eax
  801462:	85 c0                	test   %eax,%eax
  801464:	74 10                	je     801476 <initialize_dyn_block_system+0x11e>
  801466:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801469:	8b 00                	mov    (%eax),%eax
  80146b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80146e:	8b 52 04             	mov    0x4(%edx),%edx
  801471:	89 50 04             	mov    %edx,0x4(%eax)
  801474:	eb 0b                	jmp    801481 <initialize_dyn_block_system+0x129>
  801476:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801479:	8b 40 04             	mov    0x4(%eax),%eax
  80147c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801481:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801484:	8b 40 04             	mov    0x4(%eax),%eax
  801487:	85 c0                	test   %eax,%eax
  801489:	74 0f                	je     80149a <initialize_dyn_block_system+0x142>
  80148b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80148e:	8b 40 04             	mov    0x4(%eax),%eax
  801491:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801494:	8b 12                	mov    (%edx),%edx
  801496:	89 10                	mov    %edx,(%eax)
  801498:	eb 0a                	jmp    8014a4 <initialize_dyn_block_system+0x14c>
  80149a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80149d:	8b 00                	mov    (%eax),%eax
  80149f:	a3 48 51 80 00       	mov    %eax,0x805148
  8014a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014a7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8014ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014b0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8014b7:	a1 54 51 80 00       	mov    0x805154,%eax
  8014bc:	48                   	dec    %eax
  8014bd:	a3 54 51 80 00       	mov    %eax,0x805154
	LIST_INSERT_HEAD(&FreeMemBlocksList, NewBlock);
  8014c2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8014c6:	75 14                	jne    8014dc <initialize_dyn_block_system+0x184>
  8014c8:	83 ec 04             	sub    $0x4,%esp
  8014cb:	68 60 3e 80 00       	push   $0x803e60
  8014d0:	6a 34                	push   $0x34
  8014d2:	68 53 3e 80 00       	push   $0x803e53
  8014d7:	e8 0d ee ff ff       	call   8002e9 <_panic>
  8014dc:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8014e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014e5:	89 10                	mov    %edx,(%eax)
  8014e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014ea:	8b 00                	mov    (%eax),%eax
  8014ec:	85 c0                	test   %eax,%eax
  8014ee:	74 0d                	je     8014fd <initialize_dyn_block_system+0x1a5>
  8014f0:	a1 38 51 80 00       	mov    0x805138,%eax
  8014f5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8014f8:	89 50 04             	mov    %edx,0x4(%eax)
  8014fb:	eb 08                	jmp    801505 <initialize_dyn_block_system+0x1ad>
  8014fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801500:	a3 3c 51 80 00       	mov    %eax,0x80513c
  801505:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801508:	a3 38 51 80 00       	mov    %eax,0x805138
  80150d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801510:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801517:	a1 44 51 80 00       	mov    0x805144,%eax
  80151c:	40                   	inc    %eax
  80151d:	a3 44 51 80 00       	mov    %eax,0x805144
}
  801522:	90                   	nop
  801523:	c9                   	leave  
  801524:	c3                   	ret    

00801525 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801525:	55                   	push   %ebp
  801526:	89 e5                	mov    %esp,%ebp
  801528:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80152b:	e8 f7 fd ff ff       	call   801327 <InitializeUHeap>
	if (size == 0) return NULL ;
  801530:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801534:	75 07                	jne    80153d <malloc+0x18>
  801536:	b8 00 00 00 00       	mov    $0x0,%eax
  80153b:	eb 14                	jmp    801551 <malloc+0x2c>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  80153d:	83 ec 04             	sub    $0x4,%esp
  801540:	68 84 3e 80 00       	push   $0x803e84
  801545:	6a 46                	push   $0x46
  801547:	68 53 3e 80 00       	push   $0x803e53
  80154c:	e8 98 ed ff ff       	call   8002e9 <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801551:	c9                   	leave  
  801552:	c3                   	ret    

00801553 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801553:	55                   	push   %ebp
  801554:	89 e5                	mov    %esp,%ebp
  801556:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801559:	83 ec 04             	sub    $0x4,%esp
  80155c:	68 ac 3e 80 00       	push   $0x803eac
  801561:	6a 61                	push   $0x61
  801563:	68 53 3e 80 00       	push   $0x803e53
  801568:	e8 7c ed ff ff       	call   8002e9 <_panic>

0080156d <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80156d:	55                   	push   %ebp
  80156e:	89 e5                	mov    %esp,%ebp
  801570:	83 ec 38             	sub    $0x38,%esp
  801573:	8b 45 10             	mov    0x10(%ebp),%eax
  801576:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801579:	e8 a9 fd ff ff       	call   801327 <InitializeUHeap>
	if (size == 0) return NULL ;
  80157e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801582:	75 0a                	jne    80158e <smalloc+0x21>
  801584:	b8 00 00 00 00       	mov    $0x0,%eax
  801589:	e9 9e 00 00 00       	jmp    80162c <smalloc+0xbf>
	//3-If the Kernel successfully creates the shared variable, return its virtual address
	//4-Else, return NULL



	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  80158e:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801595:	8b 55 0c             	mov    0xc(%ebp),%edx
  801598:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80159b:	01 d0                	add    %edx,%eax
  80159d:	48                   	dec    %eax
  80159e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8015a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8015a9:	f7 75 f0             	divl   -0x10(%ebp)
  8015ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015af:	29 d0                	sub    %edx,%eax
  8015b1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  8015b4:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8015bb:	e8 63 06 00 00       	call   801c23 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8015c0:	85 c0                	test   %eax,%eax
  8015c2:	74 11                	je     8015d5 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  8015c4:	83 ec 0c             	sub    $0xc,%esp
  8015c7:	ff 75 e8             	pushl  -0x18(%ebp)
  8015ca:	e8 ce 0c 00 00       	call   80229d <alloc_block_FF>
  8015cf:	83 c4 10             	add    $0x10,%esp
  8015d2:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  8015d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8015d9:	74 4c                	je     801627 <smalloc+0xba>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8015db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015de:	8b 40 08             	mov    0x8(%eax),%eax
  8015e1:	89 c2                	mov    %eax,%edx
  8015e3:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8015e7:	52                   	push   %edx
  8015e8:	50                   	push   %eax
  8015e9:	ff 75 0c             	pushl  0xc(%ebp)
  8015ec:	ff 75 08             	pushl  0x8(%ebp)
  8015ef:	e8 b4 03 00 00       	call   8019a8 <sys_createSharedObject>
  8015f4:	83 c4 10             	add    $0x10,%esp
  8015f7:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cprintf("Output is :  %d \n" , result);
  8015fa:	83 ec 08             	sub    $0x8,%esp
  8015fd:	ff 75 e0             	pushl  -0x20(%ebp)
  801600:	68 cf 3e 80 00       	push   $0x803ecf
  801605:	e8 93 ef ff ff       	call   80059d <cprintf>
  80160a:	83 c4 10             	add    $0x10,%esp
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  80160d:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  801611:	74 14                	je     801627 <smalloc+0xba>
  801613:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  801617:	74 0e                	je     801627 <smalloc+0xba>
  801619:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  80161d:	74 08                	je     801627 <smalloc+0xba>
			return (void*) mem_block->sva;
  80161f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801622:	8b 40 08             	mov    0x8(%eax),%eax
  801625:	eb 05                	jmp    80162c <smalloc+0xbf>
	}
	return NULL;
  801627:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80162c:	c9                   	leave  
  80162d:	c3                   	ret    

0080162e <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80162e:	55                   	push   %ebp
  80162f:	89 e5                	mov    %esp,%ebp
  801631:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801634:	e8 ee fc ff ff       	call   801327 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801639:	83 ec 04             	sub    $0x4,%esp
  80163c:	68 e4 3e 80 00       	push   $0x803ee4
  801641:	68 ab 00 00 00       	push   $0xab
  801646:	68 53 3e 80 00       	push   $0x803e53
  80164b:	e8 99 ec ff ff       	call   8002e9 <_panic>

00801650 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801650:	55                   	push   %ebp
  801651:	89 e5                	mov    %esp,%ebp
  801653:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801656:	e8 cc fc ff ff       	call   801327 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80165b:	83 ec 04             	sub    $0x4,%esp
  80165e:	68 08 3f 80 00       	push   $0x803f08
  801663:	68 ef 00 00 00       	push   $0xef
  801668:	68 53 3e 80 00       	push   $0x803e53
  80166d:	e8 77 ec ff ff       	call   8002e9 <_panic>

00801672 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801672:	55                   	push   %ebp
  801673:	89 e5                	mov    %esp,%ebp
  801675:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801678:	83 ec 04             	sub    $0x4,%esp
  80167b:	68 30 3f 80 00       	push   $0x803f30
  801680:	68 03 01 00 00       	push   $0x103
  801685:	68 53 3e 80 00       	push   $0x803e53
  80168a:	e8 5a ec ff ff       	call   8002e9 <_panic>

0080168f <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80168f:	55                   	push   %ebp
  801690:	89 e5                	mov    %esp,%ebp
  801692:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801695:	83 ec 04             	sub    $0x4,%esp
  801698:	68 54 3f 80 00       	push   $0x803f54
  80169d:	68 0e 01 00 00       	push   $0x10e
  8016a2:	68 53 3e 80 00       	push   $0x803e53
  8016a7:	e8 3d ec ff ff       	call   8002e9 <_panic>

008016ac <shrink>:

}
void shrink(uint32 newSize)
{
  8016ac:	55                   	push   %ebp
  8016ad:	89 e5                	mov    %esp,%ebp
  8016af:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016b2:	83 ec 04             	sub    $0x4,%esp
  8016b5:	68 54 3f 80 00       	push   $0x803f54
  8016ba:	68 13 01 00 00       	push   $0x113
  8016bf:	68 53 3e 80 00       	push   $0x803e53
  8016c4:	e8 20 ec ff ff       	call   8002e9 <_panic>

008016c9 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8016c9:	55                   	push   %ebp
  8016ca:	89 e5                	mov    %esp,%ebp
  8016cc:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016cf:	83 ec 04             	sub    $0x4,%esp
  8016d2:	68 54 3f 80 00       	push   $0x803f54
  8016d7:	68 18 01 00 00       	push   $0x118
  8016dc:	68 53 3e 80 00       	push   $0x803e53
  8016e1:	e8 03 ec ff ff       	call   8002e9 <_panic>

008016e6 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8016e6:	55                   	push   %ebp
  8016e7:	89 e5                	mov    %esp,%ebp
  8016e9:	57                   	push   %edi
  8016ea:	56                   	push   %esi
  8016eb:	53                   	push   %ebx
  8016ec:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016f5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016f8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016fb:	8b 7d 18             	mov    0x18(%ebp),%edi
  8016fe:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801701:	cd 30                	int    $0x30
  801703:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801706:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801709:	83 c4 10             	add    $0x10,%esp
  80170c:	5b                   	pop    %ebx
  80170d:	5e                   	pop    %esi
  80170e:	5f                   	pop    %edi
  80170f:	5d                   	pop    %ebp
  801710:	c3                   	ret    

00801711 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801711:	55                   	push   %ebp
  801712:	89 e5                	mov    %esp,%ebp
  801714:	83 ec 04             	sub    $0x4,%esp
  801717:	8b 45 10             	mov    0x10(%ebp),%eax
  80171a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80171d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801721:	8b 45 08             	mov    0x8(%ebp),%eax
  801724:	6a 00                	push   $0x0
  801726:	6a 00                	push   $0x0
  801728:	52                   	push   %edx
  801729:	ff 75 0c             	pushl  0xc(%ebp)
  80172c:	50                   	push   %eax
  80172d:	6a 00                	push   $0x0
  80172f:	e8 b2 ff ff ff       	call   8016e6 <syscall>
  801734:	83 c4 18             	add    $0x18,%esp
}
  801737:	90                   	nop
  801738:	c9                   	leave  
  801739:	c3                   	ret    

0080173a <sys_cgetc>:

int
sys_cgetc(void)
{
  80173a:	55                   	push   %ebp
  80173b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80173d:	6a 00                	push   $0x0
  80173f:	6a 00                	push   $0x0
  801741:	6a 00                	push   $0x0
  801743:	6a 00                	push   $0x0
  801745:	6a 00                	push   $0x0
  801747:	6a 01                	push   $0x1
  801749:	e8 98 ff ff ff       	call   8016e6 <syscall>
  80174e:	83 c4 18             	add    $0x18,%esp
}
  801751:	c9                   	leave  
  801752:	c3                   	ret    

00801753 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801753:	55                   	push   %ebp
  801754:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801756:	8b 55 0c             	mov    0xc(%ebp),%edx
  801759:	8b 45 08             	mov    0x8(%ebp),%eax
  80175c:	6a 00                	push   $0x0
  80175e:	6a 00                	push   $0x0
  801760:	6a 00                	push   $0x0
  801762:	52                   	push   %edx
  801763:	50                   	push   %eax
  801764:	6a 05                	push   $0x5
  801766:	e8 7b ff ff ff       	call   8016e6 <syscall>
  80176b:	83 c4 18             	add    $0x18,%esp
}
  80176e:	c9                   	leave  
  80176f:	c3                   	ret    

00801770 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801770:	55                   	push   %ebp
  801771:	89 e5                	mov    %esp,%ebp
  801773:	56                   	push   %esi
  801774:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801775:	8b 75 18             	mov    0x18(%ebp),%esi
  801778:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80177b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80177e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801781:	8b 45 08             	mov    0x8(%ebp),%eax
  801784:	56                   	push   %esi
  801785:	53                   	push   %ebx
  801786:	51                   	push   %ecx
  801787:	52                   	push   %edx
  801788:	50                   	push   %eax
  801789:	6a 06                	push   $0x6
  80178b:	e8 56 ff ff ff       	call   8016e6 <syscall>
  801790:	83 c4 18             	add    $0x18,%esp
}
  801793:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801796:	5b                   	pop    %ebx
  801797:	5e                   	pop    %esi
  801798:	5d                   	pop    %ebp
  801799:	c3                   	ret    

0080179a <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80179a:	55                   	push   %ebp
  80179b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80179d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a3:	6a 00                	push   $0x0
  8017a5:	6a 00                	push   $0x0
  8017a7:	6a 00                	push   $0x0
  8017a9:	52                   	push   %edx
  8017aa:	50                   	push   %eax
  8017ab:	6a 07                	push   $0x7
  8017ad:	e8 34 ff ff ff       	call   8016e6 <syscall>
  8017b2:	83 c4 18             	add    $0x18,%esp
}
  8017b5:	c9                   	leave  
  8017b6:	c3                   	ret    

008017b7 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8017b7:	55                   	push   %ebp
  8017b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8017ba:	6a 00                	push   $0x0
  8017bc:	6a 00                	push   $0x0
  8017be:	6a 00                	push   $0x0
  8017c0:	ff 75 0c             	pushl  0xc(%ebp)
  8017c3:	ff 75 08             	pushl  0x8(%ebp)
  8017c6:	6a 08                	push   $0x8
  8017c8:	e8 19 ff ff ff       	call   8016e6 <syscall>
  8017cd:	83 c4 18             	add    $0x18,%esp
}
  8017d0:	c9                   	leave  
  8017d1:	c3                   	ret    

008017d2 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8017d2:	55                   	push   %ebp
  8017d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8017d5:	6a 00                	push   $0x0
  8017d7:	6a 00                	push   $0x0
  8017d9:	6a 00                	push   $0x0
  8017db:	6a 00                	push   $0x0
  8017dd:	6a 00                	push   $0x0
  8017df:	6a 09                	push   $0x9
  8017e1:	e8 00 ff ff ff       	call   8016e6 <syscall>
  8017e6:	83 c4 18             	add    $0x18,%esp
}
  8017e9:	c9                   	leave  
  8017ea:	c3                   	ret    

008017eb <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8017eb:	55                   	push   %ebp
  8017ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8017ee:	6a 00                	push   $0x0
  8017f0:	6a 00                	push   $0x0
  8017f2:	6a 00                	push   $0x0
  8017f4:	6a 00                	push   $0x0
  8017f6:	6a 00                	push   $0x0
  8017f8:	6a 0a                	push   $0xa
  8017fa:	e8 e7 fe ff ff       	call   8016e6 <syscall>
  8017ff:	83 c4 18             	add    $0x18,%esp
}
  801802:	c9                   	leave  
  801803:	c3                   	ret    

00801804 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801804:	55                   	push   %ebp
  801805:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801807:	6a 00                	push   $0x0
  801809:	6a 00                	push   $0x0
  80180b:	6a 00                	push   $0x0
  80180d:	6a 00                	push   $0x0
  80180f:	6a 00                	push   $0x0
  801811:	6a 0b                	push   $0xb
  801813:	e8 ce fe ff ff       	call   8016e6 <syscall>
  801818:	83 c4 18             	add    $0x18,%esp
}
  80181b:	c9                   	leave  
  80181c:	c3                   	ret    

0080181d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80181d:	55                   	push   %ebp
  80181e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801820:	6a 00                	push   $0x0
  801822:	6a 00                	push   $0x0
  801824:	6a 00                	push   $0x0
  801826:	ff 75 0c             	pushl  0xc(%ebp)
  801829:	ff 75 08             	pushl  0x8(%ebp)
  80182c:	6a 0f                	push   $0xf
  80182e:	e8 b3 fe ff ff       	call   8016e6 <syscall>
  801833:	83 c4 18             	add    $0x18,%esp
	return;
  801836:	90                   	nop
}
  801837:	c9                   	leave  
  801838:	c3                   	ret    

00801839 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801839:	55                   	push   %ebp
  80183a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80183c:	6a 00                	push   $0x0
  80183e:	6a 00                	push   $0x0
  801840:	6a 00                	push   $0x0
  801842:	ff 75 0c             	pushl  0xc(%ebp)
  801845:	ff 75 08             	pushl  0x8(%ebp)
  801848:	6a 10                	push   $0x10
  80184a:	e8 97 fe ff ff       	call   8016e6 <syscall>
  80184f:	83 c4 18             	add    $0x18,%esp
	return ;
  801852:	90                   	nop
}
  801853:	c9                   	leave  
  801854:	c3                   	ret    

00801855 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801855:	55                   	push   %ebp
  801856:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801858:	6a 00                	push   $0x0
  80185a:	6a 00                	push   $0x0
  80185c:	ff 75 10             	pushl  0x10(%ebp)
  80185f:	ff 75 0c             	pushl  0xc(%ebp)
  801862:	ff 75 08             	pushl  0x8(%ebp)
  801865:	6a 11                	push   $0x11
  801867:	e8 7a fe ff ff       	call   8016e6 <syscall>
  80186c:	83 c4 18             	add    $0x18,%esp
	return ;
  80186f:	90                   	nop
}
  801870:	c9                   	leave  
  801871:	c3                   	ret    

00801872 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801872:	55                   	push   %ebp
  801873:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	6a 00                	push   $0x0
  80187b:	6a 00                	push   $0x0
  80187d:	6a 00                	push   $0x0
  80187f:	6a 0c                	push   $0xc
  801881:	e8 60 fe ff ff       	call   8016e6 <syscall>
  801886:	83 c4 18             	add    $0x18,%esp
}
  801889:	c9                   	leave  
  80188a:	c3                   	ret    

0080188b <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80188b:	55                   	push   %ebp
  80188c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80188e:	6a 00                	push   $0x0
  801890:	6a 00                	push   $0x0
  801892:	6a 00                	push   $0x0
  801894:	6a 00                	push   $0x0
  801896:	ff 75 08             	pushl  0x8(%ebp)
  801899:	6a 0d                	push   $0xd
  80189b:	e8 46 fe ff ff       	call   8016e6 <syscall>
  8018a0:	83 c4 18             	add    $0x18,%esp
}
  8018a3:	c9                   	leave  
  8018a4:	c3                   	ret    

008018a5 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8018a5:	55                   	push   %ebp
  8018a6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8018a8:	6a 00                	push   $0x0
  8018aa:	6a 00                	push   $0x0
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 00                	push   $0x0
  8018b0:	6a 00                	push   $0x0
  8018b2:	6a 0e                	push   $0xe
  8018b4:	e8 2d fe ff ff       	call   8016e6 <syscall>
  8018b9:	83 c4 18             	add    $0x18,%esp
}
  8018bc:	90                   	nop
  8018bd:	c9                   	leave  
  8018be:	c3                   	ret    

008018bf <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8018bf:	55                   	push   %ebp
  8018c0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8018c2:	6a 00                	push   $0x0
  8018c4:	6a 00                	push   $0x0
  8018c6:	6a 00                	push   $0x0
  8018c8:	6a 00                	push   $0x0
  8018ca:	6a 00                	push   $0x0
  8018cc:	6a 13                	push   $0x13
  8018ce:	e8 13 fe ff ff       	call   8016e6 <syscall>
  8018d3:	83 c4 18             	add    $0x18,%esp
}
  8018d6:	90                   	nop
  8018d7:	c9                   	leave  
  8018d8:	c3                   	ret    

008018d9 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8018d9:	55                   	push   %ebp
  8018da:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8018dc:	6a 00                	push   $0x0
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 00                	push   $0x0
  8018e6:	6a 14                	push   $0x14
  8018e8:	e8 f9 fd ff ff       	call   8016e6 <syscall>
  8018ed:	83 c4 18             	add    $0x18,%esp
}
  8018f0:	90                   	nop
  8018f1:	c9                   	leave  
  8018f2:	c3                   	ret    

008018f3 <sys_cputc>:


void
sys_cputc(const char c)
{
  8018f3:	55                   	push   %ebp
  8018f4:	89 e5                	mov    %esp,%ebp
  8018f6:	83 ec 04             	sub    $0x4,%esp
  8018f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8018ff:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801903:	6a 00                	push   $0x0
  801905:	6a 00                	push   $0x0
  801907:	6a 00                	push   $0x0
  801909:	6a 00                	push   $0x0
  80190b:	50                   	push   %eax
  80190c:	6a 15                	push   $0x15
  80190e:	e8 d3 fd ff ff       	call   8016e6 <syscall>
  801913:	83 c4 18             	add    $0x18,%esp
}
  801916:	90                   	nop
  801917:	c9                   	leave  
  801918:	c3                   	ret    

00801919 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801919:	55                   	push   %ebp
  80191a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80191c:	6a 00                	push   $0x0
  80191e:	6a 00                	push   $0x0
  801920:	6a 00                	push   $0x0
  801922:	6a 00                	push   $0x0
  801924:	6a 00                	push   $0x0
  801926:	6a 16                	push   $0x16
  801928:	e8 b9 fd ff ff       	call   8016e6 <syscall>
  80192d:	83 c4 18             	add    $0x18,%esp
}
  801930:	90                   	nop
  801931:	c9                   	leave  
  801932:	c3                   	ret    

00801933 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801933:	55                   	push   %ebp
  801934:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801936:	8b 45 08             	mov    0x8(%ebp),%eax
  801939:	6a 00                	push   $0x0
  80193b:	6a 00                	push   $0x0
  80193d:	6a 00                	push   $0x0
  80193f:	ff 75 0c             	pushl  0xc(%ebp)
  801942:	50                   	push   %eax
  801943:	6a 17                	push   $0x17
  801945:	e8 9c fd ff ff       	call   8016e6 <syscall>
  80194a:	83 c4 18             	add    $0x18,%esp
}
  80194d:	c9                   	leave  
  80194e:	c3                   	ret    

0080194f <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80194f:	55                   	push   %ebp
  801950:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801952:	8b 55 0c             	mov    0xc(%ebp),%edx
  801955:	8b 45 08             	mov    0x8(%ebp),%eax
  801958:	6a 00                	push   $0x0
  80195a:	6a 00                	push   $0x0
  80195c:	6a 00                	push   $0x0
  80195e:	52                   	push   %edx
  80195f:	50                   	push   %eax
  801960:	6a 1a                	push   $0x1a
  801962:	e8 7f fd ff ff       	call   8016e6 <syscall>
  801967:	83 c4 18             	add    $0x18,%esp
}
  80196a:	c9                   	leave  
  80196b:	c3                   	ret    

0080196c <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80196c:	55                   	push   %ebp
  80196d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80196f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801972:	8b 45 08             	mov    0x8(%ebp),%eax
  801975:	6a 00                	push   $0x0
  801977:	6a 00                	push   $0x0
  801979:	6a 00                	push   $0x0
  80197b:	52                   	push   %edx
  80197c:	50                   	push   %eax
  80197d:	6a 18                	push   $0x18
  80197f:	e8 62 fd ff ff       	call   8016e6 <syscall>
  801984:	83 c4 18             	add    $0x18,%esp
}
  801987:	90                   	nop
  801988:	c9                   	leave  
  801989:	c3                   	ret    

0080198a <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80198a:	55                   	push   %ebp
  80198b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80198d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801990:	8b 45 08             	mov    0x8(%ebp),%eax
  801993:	6a 00                	push   $0x0
  801995:	6a 00                	push   $0x0
  801997:	6a 00                	push   $0x0
  801999:	52                   	push   %edx
  80199a:	50                   	push   %eax
  80199b:	6a 19                	push   $0x19
  80199d:	e8 44 fd ff ff       	call   8016e6 <syscall>
  8019a2:	83 c4 18             	add    $0x18,%esp
}
  8019a5:	90                   	nop
  8019a6:	c9                   	leave  
  8019a7:	c3                   	ret    

008019a8 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8019a8:	55                   	push   %ebp
  8019a9:	89 e5                	mov    %esp,%ebp
  8019ab:	83 ec 04             	sub    $0x4,%esp
  8019ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8019b1:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8019b4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8019b7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019be:	6a 00                	push   $0x0
  8019c0:	51                   	push   %ecx
  8019c1:	52                   	push   %edx
  8019c2:	ff 75 0c             	pushl  0xc(%ebp)
  8019c5:	50                   	push   %eax
  8019c6:	6a 1b                	push   $0x1b
  8019c8:	e8 19 fd ff ff       	call   8016e6 <syscall>
  8019cd:	83 c4 18             	add    $0x18,%esp
}
  8019d0:	c9                   	leave  
  8019d1:	c3                   	ret    

008019d2 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8019d2:	55                   	push   %ebp
  8019d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8019d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 00                	push   $0x0
  8019e1:	52                   	push   %edx
  8019e2:	50                   	push   %eax
  8019e3:	6a 1c                	push   $0x1c
  8019e5:	e8 fc fc ff ff       	call   8016e6 <syscall>
  8019ea:	83 c4 18             	add    $0x18,%esp
}
  8019ed:	c9                   	leave  
  8019ee:	c3                   	ret    

008019ef <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8019ef:	55                   	push   %ebp
  8019f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8019f2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fb:	6a 00                	push   $0x0
  8019fd:	6a 00                	push   $0x0
  8019ff:	51                   	push   %ecx
  801a00:	52                   	push   %edx
  801a01:	50                   	push   %eax
  801a02:	6a 1d                	push   $0x1d
  801a04:	e8 dd fc ff ff       	call   8016e6 <syscall>
  801a09:	83 c4 18             	add    $0x18,%esp
}
  801a0c:	c9                   	leave  
  801a0d:	c3                   	ret    

00801a0e <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801a0e:	55                   	push   %ebp
  801a0f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a11:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a14:	8b 45 08             	mov    0x8(%ebp),%eax
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 00                	push   $0x0
  801a1d:	52                   	push   %edx
  801a1e:	50                   	push   %eax
  801a1f:	6a 1e                	push   $0x1e
  801a21:	e8 c0 fc ff ff       	call   8016e6 <syscall>
  801a26:	83 c4 18             	add    $0x18,%esp
}
  801a29:	c9                   	leave  
  801a2a:	c3                   	ret    

00801a2b <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801a2b:	55                   	push   %ebp
  801a2c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 00                	push   $0x0
  801a32:	6a 00                	push   $0x0
  801a34:	6a 00                	push   $0x0
  801a36:	6a 00                	push   $0x0
  801a38:	6a 1f                	push   $0x1f
  801a3a:	e8 a7 fc ff ff       	call   8016e6 <syscall>
  801a3f:	83 c4 18             	add    $0x18,%esp
}
  801a42:	c9                   	leave  
  801a43:	c3                   	ret    

00801a44 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a44:	55                   	push   %ebp
  801a45:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a47:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4a:	6a 00                	push   $0x0
  801a4c:	ff 75 14             	pushl  0x14(%ebp)
  801a4f:	ff 75 10             	pushl  0x10(%ebp)
  801a52:	ff 75 0c             	pushl  0xc(%ebp)
  801a55:	50                   	push   %eax
  801a56:	6a 20                	push   $0x20
  801a58:	e8 89 fc ff ff       	call   8016e6 <syscall>
  801a5d:	83 c4 18             	add    $0x18,%esp
}
  801a60:	c9                   	leave  
  801a61:	c3                   	ret    

00801a62 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801a62:	55                   	push   %ebp
  801a63:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a65:	8b 45 08             	mov    0x8(%ebp),%eax
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 00                	push   $0x0
  801a70:	50                   	push   %eax
  801a71:	6a 21                	push   $0x21
  801a73:	e8 6e fc ff ff       	call   8016e6 <syscall>
  801a78:	83 c4 18             	add    $0x18,%esp
}
  801a7b:	90                   	nop
  801a7c:	c9                   	leave  
  801a7d:	c3                   	ret    

00801a7e <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801a7e:	55                   	push   %ebp
  801a7f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801a81:	8b 45 08             	mov    0x8(%ebp),%eax
  801a84:	6a 00                	push   $0x0
  801a86:	6a 00                	push   $0x0
  801a88:	6a 00                	push   $0x0
  801a8a:	6a 00                	push   $0x0
  801a8c:	50                   	push   %eax
  801a8d:	6a 22                	push   $0x22
  801a8f:	e8 52 fc ff ff       	call   8016e6 <syscall>
  801a94:	83 c4 18             	add    $0x18,%esp
}
  801a97:	c9                   	leave  
  801a98:	c3                   	ret    

00801a99 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801a99:	55                   	push   %ebp
  801a9a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 00                	push   $0x0
  801aa2:	6a 00                	push   $0x0
  801aa4:	6a 00                	push   $0x0
  801aa6:	6a 02                	push   $0x2
  801aa8:	e8 39 fc ff ff       	call   8016e6 <syscall>
  801aad:	83 c4 18             	add    $0x18,%esp
}
  801ab0:	c9                   	leave  
  801ab1:	c3                   	ret    

00801ab2 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ab2:	55                   	push   %ebp
  801ab3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801ab5:	6a 00                	push   $0x0
  801ab7:	6a 00                	push   $0x0
  801ab9:	6a 00                	push   $0x0
  801abb:	6a 00                	push   $0x0
  801abd:	6a 00                	push   $0x0
  801abf:	6a 03                	push   $0x3
  801ac1:	e8 20 fc ff ff       	call   8016e6 <syscall>
  801ac6:	83 c4 18             	add    $0x18,%esp
}
  801ac9:	c9                   	leave  
  801aca:	c3                   	ret    

00801acb <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801acb:	55                   	push   %ebp
  801acc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801ace:	6a 00                	push   $0x0
  801ad0:	6a 00                	push   $0x0
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 00                	push   $0x0
  801ad6:	6a 00                	push   $0x0
  801ad8:	6a 04                	push   $0x4
  801ada:	e8 07 fc ff ff       	call   8016e6 <syscall>
  801adf:	83 c4 18             	add    $0x18,%esp
}
  801ae2:	c9                   	leave  
  801ae3:	c3                   	ret    

00801ae4 <sys_exit_env>:


void sys_exit_env(void)
{
  801ae4:	55                   	push   %ebp
  801ae5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801ae7:	6a 00                	push   $0x0
  801ae9:	6a 00                	push   $0x0
  801aeb:	6a 00                	push   $0x0
  801aed:	6a 00                	push   $0x0
  801aef:	6a 00                	push   $0x0
  801af1:	6a 23                	push   $0x23
  801af3:	e8 ee fb ff ff       	call   8016e6 <syscall>
  801af8:	83 c4 18             	add    $0x18,%esp
}
  801afb:	90                   	nop
  801afc:	c9                   	leave  
  801afd:	c3                   	ret    

00801afe <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801afe:	55                   	push   %ebp
  801aff:	89 e5                	mov    %esp,%ebp
  801b01:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b04:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b07:	8d 50 04             	lea    0x4(%eax),%edx
  801b0a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 00                	push   $0x0
  801b13:	52                   	push   %edx
  801b14:	50                   	push   %eax
  801b15:	6a 24                	push   $0x24
  801b17:	e8 ca fb ff ff       	call   8016e6 <syscall>
  801b1c:	83 c4 18             	add    $0x18,%esp
	return result;
  801b1f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b22:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b25:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b28:	89 01                	mov    %eax,(%ecx)
  801b2a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b30:	c9                   	leave  
  801b31:	c2 04 00             	ret    $0x4

00801b34 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b34:	55                   	push   %ebp
  801b35:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b37:	6a 00                	push   $0x0
  801b39:	6a 00                	push   $0x0
  801b3b:	ff 75 10             	pushl  0x10(%ebp)
  801b3e:	ff 75 0c             	pushl  0xc(%ebp)
  801b41:	ff 75 08             	pushl  0x8(%ebp)
  801b44:	6a 12                	push   $0x12
  801b46:	e8 9b fb ff ff       	call   8016e6 <syscall>
  801b4b:	83 c4 18             	add    $0x18,%esp
	return ;
  801b4e:	90                   	nop
}
  801b4f:	c9                   	leave  
  801b50:	c3                   	ret    

00801b51 <sys_rcr2>:
uint32 sys_rcr2()
{
  801b51:	55                   	push   %ebp
  801b52:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b54:	6a 00                	push   $0x0
  801b56:	6a 00                	push   $0x0
  801b58:	6a 00                	push   $0x0
  801b5a:	6a 00                	push   $0x0
  801b5c:	6a 00                	push   $0x0
  801b5e:	6a 25                	push   $0x25
  801b60:	e8 81 fb ff ff       	call   8016e6 <syscall>
  801b65:	83 c4 18             	add    $0x18,%esp
}
  801b68:	c9                   	leave  
  801b69:	c3                   	ret    

00801b6a <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801b6a:	55                   	push   %ebp
  801b6b:	89 e5                	mov    %esp,%ebp
  801b6d:	83 ec 04             	sub    $0x4,%esp
  801b70:	8b 45 08             	mov    0x8(%ebp),%eax
  801b73:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801b76:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801b7a:	6a 00                	push   $0x0
  801b7c:	6a 00                	push   $0x0
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 00                	push   $0x0
  801b82:	50                   	push   %eax
  801b83:	6a 26                	push   $0x26
  801b85:	e8 5c fb ff ff       	call   8016e6 <syscall>
  801b8a:	83 c4 18             	add    $0x18,%esp
	return ;
  801b8d:	90                   	nop
}
  801b8e:	c9                   	leave  
  801b8f:	c3                   	ret    

00801b90 <rsttst>:
void rsttst()
{
  801b90:	55                   	push   %ebp
  801b91:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801b93:	6a 00                	push   $0x0
  801b95:	6a 00                	push   $0x0
  801b97:	6a 00                	push   $0x0
  801b99:	6a 00                	push   $0x0
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 28                	push   $0x28
  801b9f:	e8 42 fb ff ff       	call   8016e6 <syscall>
  801ba4:	83 c4 18             	add    $0x18,%esp
	return ;
  801ba7:	90                   	nop
}
  801ba8:	c9                   	leave  
  801ba9:	c3                   	ret    

00801baa <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801baa:	55                   	push   %ebp
  801bab:	89 e5                	mov    %esp,%ebp
  801bad:	83 ec 04             	sub    $0x4,%esp
  801bb0:	8b 45 14             	mov    0x14(%ebp),%eax
  801bb3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801bb6:	8b 55 18             	mov    0x18(%ebp),%edx
  801bb9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801bbd:	52                   	push   %edx
  801bbe:	50                   	push   %eax
  801bbf:	ff 75 10             	pushl  0x10(%ebp)
  801bc2:	ff 75 0c             	pushl  0xc(%ebp)
  801bc5:	ff 75 08             	pushl  0x8(%ebp)
  801bc8:	6a 27                	push   $0x27
  801bca:	e8 17 fb ff ff       	call   8016e6 <syscall>
  801bcf:	83 c4 18             	add    $0x18,%esp
	return ;
  801bd2:	90                   	nop
}
  801bd3:	c9                   	leave  
  801bd4:	c3                   	ret    

00801bd5 <chktst>:
void chktst(uint32 n)
{
  801bd5:	55                   	push   %ebp
  801bd6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 00                	push   $0x0
  801be0:	ff 75 08             	pushl  0x8(%ebp)
  801be3:	6a 29                	push   $0x29
  801be5:	e8 fc fa ff ff       	call   8016e6 <syscall>
  801bea:	83 c4 18             	add    $0x18,%esp
	return ;
  801bed:	90                   	nop
}
  801bee:	c9                   	leave  
  801bef:	c3                   	ret    

00801bf0 <inctst>:

void inctst()
{
  801bf0:	55                   	push   %ebp
  801bf1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801bf3:	6a 00                	push   $0x0
  801bf5:	6a 00                	push   $0x0
  801bf7:	6a 00                	push   $0x0
  801bf9:	6a 00                	push   $0x0
  801bfb:	6a 00                	push   $0x0
  801bfd:	6a 2a                	push   $0x2a
  801bff:	e8 e2 fa ff ff       	call   8016e6 <syscall>
  801c04:	83 c4 18             	add    $0x18,%esp
	return ;
  801c07:	90                   	nop
}
  801c08:	c9                   	leave  
  801c09:	c3                   	ret    

00801c0a <gettst>:
uint32 gettst()
{
  801c0a:	55                   	push   %ebp
  801c0b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 00                	push   $0x0
  801c11:	6a 00                	push   $0x0
  801c13:	6a 00                	push   $0x0
  801c15:	6a 00                	push   $0x0
  801c17:	6a 2b                	push   $0x2b
  801c19:	e8 c8 fa ff ff       	call   8016e6 <syscall>
  801c1e:	83 c4 18             	add    $0x18,%esp
}
  801c21:	c9                   	leave  
  801c22:	c3                   	ret    

00801c23 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801c23:	55                   	push   %ebp
  801c24:	89 e5                	mov    %esp,%ebp
  801c26:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c29:	6a 00                	push   $0x0
  801c2b:	6a 00                	push   $0x0
  801c2d:	6a 00                	push   $0x0
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 00                	push   $0x0
  801c33:	6a 2c                	push   $0x2c
  801c35:	e8 ac fa ff ff       	call   8016e6 <syscall>
  801c3a:	83 c4 18             	add    $0x18,%esp
  801c3d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801c40:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801c44:	75 07                	jne    801c4d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801c46:	b8 01 00 00 00       	mov    $0x1,%eax
  801c4b:	eb 05                	jmp    801c52 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801c4d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c52:	c9                   	leave  
  801c53:	c3                   	ret    

00801c54 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801c54:	55                   	push   %ebp
  801c55:	89 e5                	mov    %esp,%ebp
  801c57:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 00                	push   $0x0
  801c60:	6a 00                	push   $0x0
  801c62:	6a 00                	push   $0x0
  801c64:	6a 2c                	push   $0x2c
  801c66:	e8 7b fa ff ff       	call   8016e6 <syscall>
  801c6b:	83 c4 18             	add    $0x18,%esp
  801c6e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801c71:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801c75:	75 07                	jne    801c7e <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801c77:	b8 01 00 00 00       	mov    $0x1,%eax
  801c7c:	eb 05                	jmp    801c83 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801c7e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c83:	c9                   	leave  
  801c84:	c3                   	ret    

00801c85 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801c85:	55                   	push   %ebp
  801c86:	89 e5                	mov    %esp,%ebp
  801c88:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c8b:	6a 00                	push   $0x0
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 00                	push   $0x0
  801c93:	6a 00                	push   $0x0
  801c95:	6a 2c                	push   $0x2c
  801c97:	e8 4a fa ff ff       	call   8016e6 <syscall>
  801c9c:	83 c4 18             	add    $0x18,%esp
  801c9f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801ca2:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801ca6:	75 07                	jne    801caf <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801ca8:	b8 01 00 00 00       	mov    $0x1,%eax
  801cad:	eb 05                	jmp    801cb4 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801caf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cb4:	c9                   	leave  
  801cb5:	c3                   	ret    

00801cb6 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801cb6:	55                   	push   %ebp
  801cb7:	89 e5                	mov    %esp,%ebp
  801cb9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cbc:	6a 00                	push   $0x0
  801cbe:	6a 00                	push   $0x0
  801cc0:	6a 00                	push   $0x0
  801cc2:	6a 00                	push   $0x0
  801cc4:	6a 00                	push   $0x0
  801cc6:	6a 2c                	push   $0x2c
  801cc8:	e8 19 fa ff ff       	call   8016e6 <syscall>
  801ccd:	83 c4 18             	add    $0x18,%esp
  801cd0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801cd3:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801cd7:	75 07                	jne    801ce0 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801cd9:	b8 01 00 00 00       	mov    $0x1,%eax
  801cde:	eb 05                	jmp    801ce5 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ce0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ce5:	c9                   	leave  
  801ce6:	c3                   	ret    

00801ce7 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ce7:	55                   	push   %ebp
  801ce8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801cea:	6a 00                	push   $0x0
  801cec:	6a 00                	push   $0x0
  801cee:	6a 00                	push   $0x0
  801cf0:	6a 00                	push   $0x0
  801cf2:	ff 75 08             	pushl  0x8(%ebp)
  801cf5:	6a 2d                	push   $0x2d
  801cf7:	e8 ea f9 ff ff       	call   8016e6 <syscall>
  801cfc:	83 c4 18             	add    $0x18,%esp
	return ;
  801cff:	90                   	nop
}
  801d00:	c9                   	leave  
  801d01:	c3                   	ret    

00801d02 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801d02:	55                   	push   %ebp
  801d03:	89 e5                	mov    %esp,%ebp
  801d05:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801d06:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d09:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d0c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d12:	6a 00                	push   $0x0
  801d14:	53                   	push   %ebx
  801d15:	51                   	push   %ecx
  801d16:	52                   	push   %edx
  801d17:	50                   	push   %eax
  801d18:	6a 2e                	push   $0x2e
  801d1a:	e8 c7 f9 ff ff       	call   8016e6 <syscall>
  801d1f:	83 c4 18             	add    $0x18,%esp
}
  801d22:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d25:	c9                   	leave  
  801d26:	c3                   	ret    

00801d27 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801d27:	55                   	push   %ebp
  801d28:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801d2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d30:	6a 00                	push   $0x0
  801d32:	6a 00                	push   $0x0
  801d34:	6a 00                	push   $0x0
  801d36:	52                   	push   %edx
  801d37:	50                   	push   %eax
  801d38:	6a 2f                	push   $0x2f
  801d3a:	e8 a7 f9 ff ff       	call   8016e6 <syscall>
  801d3f:	83 c4 18             	add    $0x18,%esp
}
  801d42:	c9                   	leave  
  801d43:	c3                   	ret    

00801d44 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801d44:	55                   	push   %ebp
  801d45:	89 e5                	mov    %esp,%ebp
  801d47:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801d4a:	83 ec 0c             	sub    $0xc,%esp
  801d4d:	68 64 3f 80 00       	push   $0x803f64
  801d52:	e8 46 e8 ff ff       	call   80059d <cprintf>
  801d57:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801d5a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801d61:	83 ec 0c             	sub    $0xc,%esp
  801d64:	68 90 3f 80 00       	push   $0x803f90
  801d69:	e8 2f e8 ff ff       	call   80059d <cprintf>
  801d6e:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801d71:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d75:	a1 38 51 80 00       	mov    0x805138,%eax
  801d7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d7d:	eb 56                	jmp    801dd5 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801d7f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d83:	74 1c                	je     801da1 <print_mem_block_lists+0x5d>
  801d85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d88:	8b 50 08             	mov    0x8(%eax),%edx
  801d8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d8e:	8b 48 08             	mov    0x8(%eax),%ecx
  801d91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d94:	8b 40 0c             	mov    0xc(%eax),%eax
  801d97:	01 c8                	add    %ecx,%eax
  801d99:	39 c2                	cmp    %eax,%edx
  801d9b:	73 04                	jae    801da1 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801d9d:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801da1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801da4:	8b 50 08             	mov    0x8(%eax),%edx
  801da7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801daa:	8b 40 0c             	mov    0xc(%eax),%eax
  801dad:	01 c2                	add    %eax,%edx
  801daf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db2:	8b 40 08             	mov    0x8(%eax),%eax
  801db5:	83 ec 04             	sub    $0x4,%esp
  801db8:	52                   	push   %edx
  801db9:	50                   	push   %eax
  801dba:	68 a5 3f 80 00       	push   $0x803fa5
  801dbf:	e8 d9 e7 ff ff       	call   80059d <cprintf>
  801dc4:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801dc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dca:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801dcd:	a1 40 51 80 00       	mov    0x805140,%eax
  801dd2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dd5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801dd9:	74 07                	je     801de2 <print_mem_block_lists+0x9e>
  801ddb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dde:	8b 00                	mov    (%eax),%eax
  801de0:	eb 05                	jmp    801de7 <print_mem_block_lists+0xa3>
  801de2:	b8 00 00 00 00       	mov    $0x0,%eax
  801de7:	a3 40 51 80 00       	mov    %eax,0x805140
  801dec:	a1 40 51 80 00       	mov    0x805140,%eax
  801df1:	85 c0                	test   %eax,%eax
  801df3:	75 8a                	jne    801d7f <print_mem_block_lists+0x3b>
  801df5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801df9:	75 84                	jne    801d7f <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801dfb:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801dff:	75 10                	jne    801e11 <print_mem_block_lists+0xcd>
  801e01:	83 ec 0c             	sub    $0xc,%esp
  801e04:	68 b4 3f 80 00       	push   $0x803fb4
  801e09:	e8 8f e7 ff ff       	call   80059d <cprintf>
  801e0e:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801e11:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801e18:	83 ec 0c             	sub    $0xc,%esp
  801e1b:	68 d8 3f 80 00       	push   $0x803fd8
  801e20:	e8 78 e7 ff ff       	call   80059d <cprintf>
  801e25:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801e28:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801e2c:	a1 40 50 80 00       	mov    0x805040,%eax
  801e31:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e34:	eb 56                	jmp    801e8c <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e36:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e3a:	74 1c                	je     801e58 <print_mem_block_lists+0x114>
  801e3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e3f:	8b 50 08             	mov    0x8(%eax),%edx
  801e42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e45:	8b 48 08             	mov    0x8(%eax),%ecx
  801e48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e4b:	8b 40 0c             	mov    0xc(%eax),%eax
  801e4e:	01 c8                	add    %ecx,%eax
  801e50:	39 c2                	cmp    %eax,%edx
  801e52:	73 04                	jae    801e58 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801e54:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e5b:	8b 50 08             	mov    0x8(%eax),%edx
  801e5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e61:	8b 40 0c             	mov    0xc(%eax),%eax
  801e64:	01 c2                	add    %eax,%edx
  801e66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e69:	8b 40 08             	mov    0x8(%eax),%eax
  801e6c:	83 ec 04             	sub    $0x4,%esp
  801e6f:	52                   	push   %edx
  801e70:	50                   	push   %eax
  801e71:	68 a5 3f 80 00       	push   $0x803fa5
  801e76:	e8 22 e7 ff ff       	call   80059d <cprintf>
  801e7b:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e81:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801e84:	a1 48 50 80 00       	mov    0x805048,%eax
  801e89:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e8c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e90:	74 07                	je     801e99 <print_mem_block_lists+0x155>
  801e92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e95:	8b 00                	mov    (%eax),%eax
  801e97:	eb 05                	jmp    801e9e <print_mem_block_lists+0x15a>
  801e99:	b8 00 00 00 00       	mov    $0x0,%eax
  801e9e:	a3 48 50 80 00       	mov    %eax,0x805048
  801ea3:	a1 48 50 80 00       	mov    0x805048,%eax
  801ea8:	85 c0                	test   %eax,%eax
  801eaa:	75 8a                	jne    801e36 <print_mem_block_lists+0xf2>
  801eac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801eb0:	75 84                	jne    801e36 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801eb2:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801eb6:	75 10                	jne    801ec8 <print_mem_block_lists+0x184>
  801eb8:	83 ec 0c             	sub    $0xc,%esp
  801ebb:	68 f0 3f 80 00       	push   $0x803ff0
  801ec0:	e8 d8 e6 ff ff       	call   80059d <cprintf>
  801ec5:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801ec8:	83 ec 0c             	sub    $0xc,%esp
  801ecb:	68 64 3f 80 00       	push   $0x803f64
  801ed0:	e8 c8 e6 ff ff       	call   80059d <cprintf>
  801ed5:	83 c4 10             	add    $0x10,%esp

}
  801ed8:	90                   	nop
  801ed9:	c9                   	leave  
  801eda:	c3                   	ret    

00801edb <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801edb:	55                   	push   %ebp
  801edc:	89 e5                	mov    %esp,%ebp
  801ede:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801ee1:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  801ee8:	00 00 00 
  801eeb:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  801ef2:	00 00 00 
  801ef5:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  801efc:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801eff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801f06:	e9 9e 00 00 00       	jmp    801fa9 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801f0b:	a1 50 50 80 00       	mov    0x805050,%eax
  801f10:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f13:	c1 e2 04             	shl    $0x4,%edx
  801f16:	01 d0                	add    %edx,%eax
  801f18:	85 c0                	test   %eax,%eax
  801f1a:	75 14                	jne    801f30 <initialize_MemBlocksList+0x55>
  801f1c:	83 ec 04             	sub    $0x4,%esp
  801f1f:	68 18 40 80 00       	push   $0x804018
  801f24:	6a 46                	push   $0x46
  801f26:	68 3b 40 80 00       	push   $0x80403b
  801f2b:	e8 b9 e3 ff ff       	call   8002e9 <_panic>
  801f30:	a1 50 50 80 00       	mov    0x805050,%eax
  801f35:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f38:	c1 e2 04             	shl    $0x4,%edx
  801f3b:	01 d0                	add    %edx,%eax
  801f3d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  801f43:	89 10                	mov    %edx,(%eax)
  801f45:	8b 00                	mov    (%eax),%eax
  801f47:	85 c0                	test   %eax,%eax
  801f49:	74 18                	je     801f63 <initialize_MemBlocksList+0x88>
  801f4b:	a1 48 51 80 00       	mov    0x805148,%eax
  801f50:	8b 15 50 50 80 00    	mov    0x805050,%edx
  801f56:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801f59:	c1 e1 04             	shl    $0x4,%ecx
  801f5c:	01 ca                	add    %ecx,%edx
  801f5e:	89 50 04             	mov    %edx,0x4(%eax)
  801f61:	eb 12                	jmp    801f75 <initialize_MemBlocksList+0x9a>
  801f63:	a1 50 50 80 00       	mov    0x805050,%eax
  801f68:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f6b:	c1 e2 04             	shl    $0x4,%edx
  801f6e:	01 d0                	add    %edx,%eax
  801f70:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801f75:	a1 50 50 80 00       	mov    0x805050,%eax
  801f7a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f7d:	c1 e2 04             	shl    $0x4,%edx
  801f80:	01 d0                	add    %edx,%eax
  801f82:	a3 48 51 80 00       	mov    %eax,0x805148
  801f87:	a1 50 50 80 00       	mov    0x805050,%eax
  801f8c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f8f:	c1 e2 04             	shl    $0x4,%edx
  801f92:	01 d0                	add    %edx,%eax
  801f94:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f9b:	a1 54 51 80 00       	mov    0x805154,%eax
  801fa0:	40                   	inc    %eax
  801fa1:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801fa6:	ff 45 f4             	incl   -0xc(%ebp)
  801fa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fac:	3b 45 08             	cmp    0x8(%ebp),%eax
  801faf:	0f 82 56 ff ff ff    	jb     801f0b <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801fb5:	90                   	nop
  801fb6:	c9                   	leave  
  801fb7:	c3                   	ret    

00801fb8 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801fb8:	55                   	push   %ebp
  801fb9:	89 e5                	mov    %esp,%ebp
  801fbb:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc1:	8b 00                	mov    (%eax),%eax
  801fc3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801fc6:	eb 19                	jmp    801fe1 <find_block+0x29>
	{
		if(va==point->sva)
  801fc8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fcb:	8b 40 08             	mov    0x8(%eax),%eax
  801fce:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801fd1:	75 05                	jne    801fd8 <find_block+0x20>
		   return point;
  801fd3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fd6:	eb 36                	jmp    80200e <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  801fdb:	8b 40 08             	mov    0x8(%eax),%eax
  801fde:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801fe1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801fe5:	74 07                	je     801fee <find_block+0x36>
  801fe7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fea:	8b 00                	mov    (%eax),%eax
  801fec:	eb 05                	jmp    801ff3 <find_block+0x3b>
  801fee:	b8 00 00 00 00       	mov    $0x0,%eax
  801ff3:	8b 55 08             	mov    0x8(%ebp),%edx
  801ff6:	89 42 08             	mov    %eax,0x8(%edx)
  801ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffc:	8b 40 08             	mov    0x8(%eax),%eax
  801fff:	85 c0                	test   %eax,%eax
  802001:	75 c5                	jne    801fc8 <find_block+0x10>
  802003:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802007:	75 bf                	jne    801fc8 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802009:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80200e:	c9                   	leave  
  80200f:	c3                   	ret    

00802010 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802010:	55                   	push   %ebp
  802011:	89 e5                	mov    %esp,%ebp
  802013:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802016:	a1 40 50 80 00       	mov    0x805040,%eax
  80201b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  80201e:	a1 44 50 80 00       	mov    0x805044,%eax
  802023:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802026:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802029:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80202c:	74 24                	je     802052 <insert_sorted_allocList+0x42>
  80202e:	8b 45 08             	mov    0x8(%ebp),%eax
  802031:	8b 50 08             	mov    0x8(%eax),%edx
  802034:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802037:	8b 40 08             	mov    0x8(%eax),%eax
  80203a:	39 c2                	cmp    %eax,%edx
  80203c:	76 14                	jbe    802052 <insert_sorted_allocList+0x42>
  80203e:	8b 45 08             	mov    0x8(%ebp),%eax
  802041:	8b 50 08             	mov    0x8(%eax),%edx
  802044:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802047:	8b 40 08             	mov    0x8(%eax),%eax
  80204a:	39 c2                	cmp    %eax,%edx
  80204c:	0f 82 60 01 00 00    	jb     8021b2 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802052:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802056:	75 65                	jne    8020bd <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802058:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80205c:	75 14                	jne    802072 <insert_sorted_allocList+0x62>
  80205e:	83 ec 04             	sub    $0x4,%esp
  802061:	68 18 40 80 00       	push   $0x804018
  802066:	6a 6b                	push   $0x6b
  802068:	68 3b 40 80 00       	push   $0x80403b
  80206d:	e8 77 e2 ff ff       	call   8002e9 <_panic>
  802072:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802078:	8b 45 08             	mov    0x8(%ebp),%eax
  80207b:	89 10                	mov    %edx,(%eax)
  80207d:	8b 45 08             	mov    0x8(%ebp),%eax
  802080:	8b 00                	mov    (%eax),%eax
  802082:	85 c0                	test   %eax,%eax
  802084:	74 0d                	je     802093 <insert_sorted_allocList+0x83>
  802086:	a1 40 50 80 00       	mov    0x805040,%eax
  80208b:	8b 55 08             	mov    0x8(%ebp),%edx
  80208e:	89 50 04             	mov    %edx,0x4(%eax)
  802091:	eb 08                	jmp    80209b <insert_sorted_allocList+0x8b>
  802093:	8b 45 08             	mov    0x8(%ebp),%eax
  802096:	a3 44 50 80 00       	mov    %eax,0x805044
  80209b:	8b 45 08             	mov    0x8(%ebp),%eax
  80209e:	a3 40 50 80 00       	mov    %eax,0x805040
  8020a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020ad:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8020b2:	40                   	inc    %eax
  8020b3:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8020b8:	e9 dc 01 00 00       	jmp    802299 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8020bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c0:	8b 50 08             	mov    0x8(%eax),%edx
  8020c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020c6:	8b 40 08             	mov    0x8(%eax),%eax
  8020c9:	39 c2                	cmp    %eax,%edx
  8020cb:	77 6c                	ja     802139 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8020cd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020d1:	74 06                	je     8020d9 <insert_sorted_allocList+0xc9>
  8020d3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020d7:	75 14                	jne    8020ed <insert_sorted_allocList+0xdd>
  8020d9:	83 ec 04             	sub    $0x4,%esp
  8020dc:	68 54 40 80 00       	push   $0x804054
  8020e1:	6a 6f                	push   $0x6f
  8020e3:	68 3b 40 80 00       	push   $0x80403b
  8020e8:	e8 fc e1 ff ff       	call   8002e9 <_panic>
  8020ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020f0:	8b 50 04             	mov    0x4(%eax),%edx
  8020f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f6:	89 50 04             	mov    %edx,0x4(%eax)
  8020f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8020ff:	89 10                	mov    %edx,(%eax)
  802101:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802104:	8b 40 04             	mov    0x4(%eax),%eax
  802107:	85 c0                	test   %eax,%eax
  802109:	74 0d                	je     802118 <insert_sorted_allocList+0x108>
  80210b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80210e:	8b 40 04             	mov    0x4(%eax),%eax
  802111:	8b 55 08             	mov    0x8(%ebp),%edx
  802114:	89 10                	mov    %edx,(%eax)
  802116:	eb 08                	jmp    802120 <insert_sorted_allocList+0x110>
  802118:	8b 45 08             	mov    0x8(%ebp),%eax
  80211b:	a3 40 50 80 00       	mov    %eax,0x805040
  802120:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802123:	8b 55 08             	mov    0x8(%ebp),%edx
  802126:	89 50 04             	mov    %edx,0x4(%eax)
  802129:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80212e:	40                   	inc    %eax
  80212f:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802134:	e9 60 01 00 00       	jmp    802299 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802139:	8b 45 08             	mov    0x8(%ebp),%eax
  80213c:	8b 50 08             	mov    0x8(%eax),%edx
  80213f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802142:	8b 40 08             	mov    0x8(%eax),%eax
  802145:	39 c2                	cmp    %eax,%edx
  802147:	0f 82 4c 01 00 00    	jb     802299 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  80214d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802151:	75 14                	jne    802167 <insert_sorted_allocList+0x157>
  802153:	83 ec 04             	sub    $0x4,%esp
  802156:	68 8c 40 80 00       	push   $0x80408c
  80215b:	6a 73                	push   $0x73
  80215d:	68 3b 40 80 00       	push   $0x80403b
  802162:	e8 82 e1 ff ff       	call   8002e9 <_panic>
  802167:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80216d:	8b 45 08             	mov    0x8(%ebp),%eax
  802170:	89 50 04             	mov    %edx,0x4(%eax)
  802173:	8b 45 08             	mov    0x8(%ebp),%eax
  802176:	8b 40 04             	mov    0x4(%eax),%eax
  802179:	85 c0                	test   %eax,%eax
  80217b:	74 0c                	je     802189 <insert_sorted_allocList+0x179>
  80217d:	a1 44 50 80 00       	mov    0x805044,%eax
  802182:	8b 55 08             	mov    0x8(%ebp),%edx
  802185:	89 10                	mov    %edx,(%eax)
  802187:	eb 08                	jmp    802191 <insert_sorted_allocList+0x181>
  802189:	8b 45 08             	mov    0x8(%ebp),%eax
  80218c:	a3 40 50 80 00       	mov    %eax,0x805040
  802191:	8b 45 08             	mov    0x8(%ebp),%eax
  802194:	a3 44 50 80 00       	mov    %eax,0x805044
  802199:	8b 45 08             	mov    0x8(%ebp),%eax
  80219c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021a2:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8021a7:	40                   	inc    %eax
  8021a8:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8021ad:	e9 e7 00 00 00       	jmp    802299 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8021b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8021b8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8021bf:	a1 40 50 80 00       	mov    0x805040,%eax
  8021c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021c7:	e9 9d 00 00 00       	jmp    802269 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8021cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021cf:	8b 00                	mov    (%eax),%eax
  8021d1:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8021d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d7:	8b 50 08             	mov    0x8(%eax),%edx
  8021da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021dd:	8b 40 08             	mov    0x8(%eax),%eax
  8021e0:	39 c2                	cmp    %eax,%edx
  8021e2:	76 7d                	jbe    802261 <insert_sorted_allocList+0x251>
  8021e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e7:	8b 50 08             	mov    0x8(%eax),%edx
  8021ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8021ed:	8b 40 08             	mov    0x8(%eax),%eax
  8021f0:	39 c2                	cmp    %eax,%edx
  8021f2:	73 6d                	jae    802261 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8021f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021f8:	74 06                	je     802200 <insert_sorted_allocList+0x1f0>
  8021fa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021fe:	75 14                	jne    802214 <insert_sorted_allocList+0x204>
  802200:	83 ec 04             	sub    $0x4,%esp
  802203:	68 b0 40 80 00       	push   $0x8040b0
  802208:	6a 7f                	push   $0x7f
  80220a:	68 3b 40 80 00       	push   $0x80403b
  80220f:	e8 d5 e0 ff ff       	call   8002e9 <_panic>
  802214:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802217:	8b 10                	mov    (%eax),%edx
  802219:	8b 45 08             	mov    0x8(%ebp),%eax
  80221c:	89 10                	mov    %edx,(%eax)
  80221e:	8b 45 08             	mov    0x8(%ebp),%eax
  802221:	8b 00                	mov    (%eax),%eax
  802223:	85 c0                	test   %eax,%eax
  802225:	74 0b                	je     802232 <insert_sorted_allocList+0x222>
  802227:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80222a:	8b 00                	mov    (%eax),%eax
  80222c:	8b 55 08             	mov    0x8(%ebp),%edx
  80222f:	89 50 04             	mov    %edx,0x4(%eax)
  802232:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802235:	8b 55 08             	mov    0x8(%ebp),%edx
  802238:	89 10                	mov    %edx,(%eax)
  80223a:	8b 45 08             	mov    0x8(%ebp),%eax
  80223d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802240:	89 50 04             	mov    %edx,0x4(%eax)
  802243:	8b 45 08             	mov    0x8(%ebp),%eax
  802246:	8b 00                	mov    (%eax),%eax
  802248:	85 c0                	test   %eax,%eax
  80224a:	75 08                	jne    802254 <insert_sorted_allocList+0x244>
  80224c:	8b 45 08             	mov    0x8(%ebp),%eax
  80224f:	a3 44 50 80 00       	mov    %eax,0x805044
  802254:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802259:	40                   	inc    %eax
  80225a:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  80225f:	eb 39                	jmp    80229a <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802261:	a1 48 50 80 00       	mov    0x805048,%eax
  802266:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802269:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80226d:	74 07                	je     802276 <insert_sorted_allocList+0x266>
  80226f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802272:	8b 00                	mov    (%eax),%eax
  802274:	eb 05                	jmp    80227b <insert_sorted_allocList+0x26b>
  802276:	b8 00 00 00 00       	mov    $0x0,%eax
  80227b:	a3 48 50 80 00       	mov    %eax,0x805048
  802280:	a1 48 50 80 00       	mov    0x805048,%eax
  802285:	85 c0                	test   %eax,%eax
  802287:	0f 85 3f ff ff ff    	jne    8021cc <insert_sorted_allocList+0x1bc>
  80228d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802291:	0f 85 35 ff ff ff    	jne    8021cc <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802297:	eb 01                	jmp    80229a <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802299:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80229a:	90                   	nop
  80229b:	c9                   	leave  
  80229c:	c3                   	ret    

0080229d <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80229d:	55                   	push   %ebp
  80229e:	89 e5                	mov    %esp,%ebp
  8022a0:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8022a3:	a1 38 51 80 00       	mov    0x805138,%eax
  8022a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022ab:	e9 85 01 00 00       	jmp    802435 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8022b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b3:	8b 40 0c             	mov    0xc(%eax),%eax
  8022b6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022b9:	0f 82 6e 01 00 00    	jb     80242d <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8022bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c2:	8b 40 0c             	mov    0xc(%eax),%eax
  8022c5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022c8:	0f 85 8a 00 00 00    	jne    802358 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8022ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022d2:	75 17                	jne    8022eb <alloc_block_FF+0x4e>
  8022d4:	83 ec 04             	sub    $0x4,%esp
  8022d7:	68 e4 40 80 00       	push   $0x8040e4
  8022dc:	68 93 00 00 00       	push   $0x93
  8022e1:	68 3b 40 80 00       	push   $0x80403b
  8022e6:	e8 fe df ff ff       	call   8002e9 <_panic>
  8022eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ee:	8b 00                	mov    (%eax),%eax
  8022f0:	85 c0                	test   %eax,%eax
  8022f2:	74 10                	je     802304 <alloc_block_FF+0x67>
  8022f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f7:	8b 00                	mov    (%eax),%eax
  8022f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022fc:	8b 52 04             	mov    0x4(%edx),%edx
  8022ff:	89 50 04             	mov    %edx,0x4(%eax)
  802302:	eb 0b                	jmp    80230f <alloc_block_FF+0x72>
  802304:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802307:	8b 40 04             	mov    0x4(%eax),%eax
  80230a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80230f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802312:	8b 40 04             	mov    0x4(%eax),%eax
  802315:	85 c0                	test   %eax,%eax
  802317:	74 0f                	je     802328 <alloc_block_FF+0x8b>
  802319:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231c:	8b 40 04             	mov    0x4(%eax),%eax
  80231f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802322:	8b 12                	mov    (%edx),%edx
  802324:	89 10                	mov    %edx,(%eax)
  802326:	eb 0a                	jmp    802332 <alloc_block_FF+0x95>
  802328:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232b:	8b 00                	mov    (%eax),%eax
  80232d:	a3 38 51 80 00       	mov    %eax,0x805138
  802332:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802335:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80233b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802345:	a1 44 51 80 00       	mov    0x805144,%eax
  80234a:	48                   	dec    %eax
  80234b:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802350:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802353:	e9 10 01 00 00       	jmp    802468 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802358:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235b:	8b 40 0c             	mov    0xc(%eax),%eax
  80235e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802361:	0f 86 c6 00 00 00    	jbe    80242d <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802367:	a1 48 51 80 00       	mov    0x805148,%eax
  80236c:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  80236f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802372:	8b 50 08             	mov    0x8(%eax),%edx
  802375:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802378:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  80237b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80237e:	8b 55 08             	mov    0x8(%ebp),%edx
  802381:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802384:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802388:	75 17                	jne    8023a1 <alloc_block_FF+0x104>
  80238a:	83 ec 04             	sub    $0x4,%esp
  80238d:	68 e4 40 80 00       	push   $0x8040e4
  802392:	68 9b 00 00 00       	push   $0x9b
  802397:	68 3b 40 80 00       	push   $0x80403b
  80239c:	e8 48 df ff ff       	call   8002e9 <_panic>
  8023a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023a4:	8b 00                	mov    (%eax),%eax
  8023a6:	85 c0                	test   %eax,%eax
  8023a8:	74 10                	je     8023ba <alloc_block_FF+0x11d>
  8023aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ad:	8b 00                	mov    (%eax),%eax
  8023af:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023b2:	8b 52 04             	mov    0x4(%edx),%edx
  8023b5:	89 50 04             	mov    %edx,0x4(%eax)
  8023b8:	eb 0b                	jmp    8023c5 <alloc_block_FF+0x128>
  8023ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023bd:	8b 40 04             	mov    0x4(%eax),%eax
  8023c0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8023c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023c8:	8b 40 04             	mov    0x4(%eax),%eax
  8023cb:	85 c0                	test   %eax,%eax
  8023cd:	74 0f                	je     8023de <alloc_block_FF+0x141>
  8023cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023d2:	8b 40 04             	mov    0x4(%eax),%eax
  8023d5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023d8:	8b 12                	mov    (%edx),%edx
  8023da:	89 10                	mov    %edx,(%eax)
  8023dc:	eb 0a                	jmp    8023e8 <alloc_block_FF+0x14b>
  8023de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023e1:	8b 00                	mov    (%eax),%eax
  8023e3:	a3 48 51 80 00       	mov    %eax,0x805148
  8023e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023eb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023f4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023fb:	a1 54 51 80 00       	mov    0x805154,%eax
  802400:	48                   	dec    %eax
  802401:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802406:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802409:	8b 50 08             	mov    0x8(%eax),%edx
  80240c:	8b 45 08             	mov    0x8(%ebp),%eax
  80240f:	01 c2                	add    %eax,%edx
  802411:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802414:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802417:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241a:	8b 40 0c             	mov    0xc(%eax),%eax
  80241d:	2b 45 08             	sub    0x8(%ebp),%eax
  802420:	89 c2                	mov    %eax,%edx
  802422:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802425:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802428:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80242b:	eb 3b                	jmp    802468 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80242d:	a1 40 51 80 00       	mov    0x805140,%eax
  802432:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802435:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802439:	74 07                	je     802442 <alloc_block_FF+0x1a5>
  80243b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243e:	8b 00                	mov    (%eax),%eax
  802440:	eb 05                	jmp    802447 <alloc_block_FF+0x1aa>
  802442:	b8 00 00 00 00       	mov    $0x0,%eax
  802447:	a3 40 51 80 00       	mov    %eax,0x805140
  80244c:	a1 40 51 80 00       	mov    0x805140,%eax
  802451:	85 c0                	test   %eax,%eax
  802453:	0f 85 57 fe ff ff    	jne    8022b0 <alloc_block_FF+0x13>
  802459:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80245d:	0f 85 4d fe ff ff    	jne    8022b0 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802463:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802468:	c9                   	leave  
  802469:	c3                   	ret    

0080246a <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80246a:	55                   	push   %ebp
  80246b:	89 e5                	mov    %esp,%ebp
  80246d:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802470:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802477:	a1 38 51 80 00       	mov    0x805138,%eax
  80247c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80247f:	e9 df 00 00 00       	jmp    802563 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802484:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802487:	8b 40 0c             	mov    0xc(%eax),%eax
  80248a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80248d:	0f 82 c8 00 00 00    	jb     80255b <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802493:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802496:	8b 40 0c             	mov    0xc(%eax),%eax
  802499:	3b 45 08             	cmp    0x8(%ebp),%eax
  80249c:	0f 85 8a 00 00 00    	jne    80252c <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8024a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024a6:	75 17                	jne    8024bf <alloc_block_BF+0x55>
  8024a8:	83 ec 04             	sub    $0x4,%esp
  8024ab:	68 e4 40 80 00       	push   $0x8040e4
  8024b0:	68 b7 00 00 00       	push   $0xb7
  8024b5:	68 3b 40 80 00       	push   $0x80403b
  8024ba:	e8 2a de ff ff       	call   8002e9 <_panic>
  8024bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c2:	8b 00                	mov    (%eax),%eax
  8024c4:	85 c0                	test   %eax,%eax
  8024c6:	74 10                	je     8024d8 <alloc_block_BF+0x6e>
  8024c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cb:	8b 00                	mov    (%eax),%eax
  8024cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024d0:	8b 52 04             	mov    0x4(%edx),%edx
  8024d3:	89 50 04             	mov    %edx,0x4(%eax)
  8024d6:	eb 0b                	jmp    8024e3 <alloc_block_BF+0x79>
  8024d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024db:	8b 40 04             	mov    0x4(%eax),%eax
  8024de:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8024e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e6:	8b 40 04             	mov    0x4(%eax),%eax
  8024e9:	85 c0                	test   %eax,%eax
  8024eb:	74 0f                	je     8024fc <alloc_block_BF+0x92>
  8024ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f0:	8b 40 04             	mov    0x4(%eax),%eax
  8024f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024f6:	8b 12                	mov    (%edx),%edx
  8024f8:	89 10                	mov    %edx,(%eax)
  8024fa:	eb 0a                	jmp    802506 <alloc_block_BF+0x9c>
  8024fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ff:	8b 00                	mov    (%eax),%eax
  802501:	a3 38 51 80 00       	mov    %eax,0x805138
  802506:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802509:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80250f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802512:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802519:	a1 44 51 80 00       	mov    0x805144,%eax
  80251e:	48                   	dec    %eax
  80251f:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802524:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802527:	e9 4d 01 00 00       	jmp    802679 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  80252c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252f:	8b 40 0c             	mov    0xc(%eax),%eax
  802532:	3b 45 08             	cmp    0x8(%ebp),%eax
  802535:	76 24                	jbe    80255b <alloc_block_BF+0xf1>
  802537:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253a:	8b 40 0c             	mov    0xc(%eax),%eax
  80253d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802540:	73 19                	jae    80255b <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802542:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802549:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254c:	8b 40 0c             	mov    0xc(%eax),%eax
  80254f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802552:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802555:	8b 40 08             	mov    0x8(%eax),%eax
  802558:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80255b:	a1 40 51 80 00       	mov    0x805140,%eax
  802560:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802563:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802567:	74 07                	je     802570 <alloc_block_BF+0x106>
  802569:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256c:	8b 00                	mov    (%eax),%eax
  80256e:	eb 05                	jmp    802575 <alloc_block_BF+0x10b>
  802570:	b8 00 00 00 00       	mov    $0x0,%eax
  802575:	a3 40 51 80 00       	mov    %eax,0x805140
  80257a:	a1 40 51 80 00       	mov    0x805140,%eax
  80257f:	85 c0                	test   %eax,%eax
  802581:	0f 85 fd fe ff ff    	jne    802484 <alloc_block_BF+0x1a>
  802587:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80258b:	0f 85 f3 fe ff ff    	jne    802484 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802591:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802595:	0f 84 d9 00 00 00    	je     802674 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  80259b:	a1 48 51 80 00       	mov    0x805148,%eax
  8025a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8025a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025a6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025a9:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8025ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025af:	8b 55 08             	mov    0x8(%ebp),%edx
  8025b2:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8025b5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8025b9:	75 17                	jne    8025d2 <alloc_block_BF+0x168>
  8025bb:	83 ec 04             	sub    $0x4,%esp
  8025be:	68 e4 40 80 00       	push   $0x8040e4
  8025c3:	68 c7 00 00 00       	push   $0xc7
  8025c8:	68 3b 40 80 00       	push   $0x80403b
  8025cd:	e8 17 dd ff ff       	call   8002e9 <_panic>
  8025d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025d5:	8b 00                	mov    (%eax),%eax
  8025d7:	85 c0                	test   %eax,%eax
  8025d9:	74 10                	je     8025eb <alloc_block_BF+0x181>
  8025db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025de:	8b 00                	mov    (%eax),%eax
  8025e0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025e3:	8b 52 04             	mov    0x4(%edx),%edx
  8025e6:	89 50 04             	mov    %edx,0x4(%eax)
  8025e9:	eb 0b                	jmp    8025f6 <alloc_block_BF+0x18c>
  8025eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025ee:	8b 40 04             	mov    0x4(%eax),%eax
  8025f1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8025f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025f9:	8b 40 04             	mov    0x4(%eax),%eax
  8025fc:	85 c0                	test   %eax,%eax
  8025fe:	74 0f                	je     80260f <alloc_block_BF+0x1a5>
  802600:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802603:	8b 40 04             	mov    0x4(%eax),%eax
  802606:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802609:	8b 12                	mov    (%edx),%edx
  80260b:	89 10                	mov    %edx,(%eax)
  80260d:	eb 0a                	jmp    802619 <alloc_block_BF+0x1af>
  80260f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802612:	8b 00                	mov    (%eax),%eax
  802614:	a3 48 51 80 00       	mov    %eax,0x805148
  802619:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80261c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802622:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802625:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80262c:	a1 54 51 80 00       	mov    0x805154,%eax
  802631:	48                   	dec    %eax
  802632:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802637:	83 ec 08             	sub    $0x8,%esp
  80263a:	ff 75 ec             	pushl  -0x14(%ebp)
  80263d:	68 38 51 80 00       	push   $0x805138
  802642:	e8 71 f9 ff ff       	call   801fb8 <find_block>
  802647:	83 c4 10             	add    $0x10,%esp
  80264a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  80264d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802650:	8b 50 08             	mov    0x8(%eax),%edx
  802653:	8b 45 08             	mov    0x8(%ebp),%eax
  802656:	01 c2                	add    %eax,%edx
  802658:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80265b:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  80265e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802661:	8b 40 0c             	mov    0xc(%eax),%eax
  802664:	2b 45 08             	sub    0x8(%ebp),%eax
  802667:	89 c2                	mov    %eax,%edx
  802669:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80266c:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  80266f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802672:	eb 05                	jmp    802679 <alloc_block_BF+0x20f>
	}
	return NULL;
  802674:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802679:	c9                   	leave  
  80267a:	c3                   	ret    

0080267b <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  80267b:	55                   	push   %ebp
  80267c:	89 e5                	mov    %esp,%ebp
  80267e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802681:	a1 28 50 80 00       	mov    0x805028,%eax
  802686:	85 c0                	test   %eax,%eax
  802688:	0f 85 de 01 00 00    	jne    80286c <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80268e:	a1 38 51 80 00       	mov    0x805138,%eax
  802693:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802696:	e9 9e 01 00 00       	jmp    802839 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  80269b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269e:	8b 40 0c             	mov    0xc(%eax),%eax
  8026a1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026a4:	0f 82 87 01 00 00    	jb     802831 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8026aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ad:	8b 40 0c             	mov    0xc(%eax),%eax
  8026b0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026b3:	0f 85 95 00 00 00    	jne    80274e <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8026b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026bd:	75 17                	jne    8026d6 <alloc_block_NF+0x5b>
  8026bf:	83 ec 04             	sub    $0x4,%esp
  8026c2:	68 e4 40 80 00       	push   $0x8040e4
  8026c7:	68 e0 00 00 00       	push   $0xe0
  8026cc:	68 3b 40 80 00       	push   $0x80403b
  8026d1:	e8 13 dc ff ff       	call   8002e9 <_panic>
  8026d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d9:	8b 00                	mov    (%eax),%eax
  8026db:	85 c0                	test   %eax,%eax
  8026dd:	74 10                	je     8026ef <alloc_block_NF+0x74>
  8026df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e2:	8b 00                	mov    (%eax),%eax
  8026e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026e7:	8b 52 04             	mov    0x4(%edx),%edx
  8026ea:	89 50 04             	mov    %edx,0x4(%eax)
  8026ed:	eb 0b                	jmp    8026fa <alloc_block_NF+0x7f>
  8026ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f2:	8b 40 04             	mov    0x4(%eax),%eax
  8026f5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8026fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fd:	8b 40 04             	mov    0x4(%eax),%eax
  802700:	85 c0                	test   %eax,%eax
  802702:	74 0f                	je     802713 <alloc_block_NF+0x98>
  802704:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802707:	8b 40 04             	mov    0x4(%eax),%eax
  80270a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80270d:	8b 12                	mov    (%edx),%edx
  80270f:	89 10                	mov    %edx,(%eax)
  802711:	eb 0a                	jmp    80271d <alloc_block_NF+0xa2>
  802713:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802716:	8b 00                	mov    (%eax),%eax
  802718:	a3 38 51 80 00       	mov    %eax,0x805138
  80271d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802720:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802726:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802729:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802730:	a1 44 51 80 00       	mov    0x805144,%eax
  802735:	48                   	dec    %eax
  802736:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  80273b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273e:	8b 40 08             	mov    0x8(%eax),%eax
  802741:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802746:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802749:	e9 f8 04 00 00       	jmp    802c46 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  80274e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802751:	8b 40 0c             	mov    0xc(%eax),%eax
  802754:	3b 45 08             	cmp    0x8(%ebp),%eax
  802757:	0f 86 d4 00 00 00    	jbe    802831 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80275d:	a1 48 51 80 00       	mov    0x805148,%eax
  802762:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802765:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802768:	8b 50 08             	mov    0x8(%eax),%edx
  80276b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80276e:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802771:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802774:	8b 55 08             	mov    0x8(%ebp),%edx
  802777:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80277a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80277e:	75 17                	jne    802797 <alloc_block_NF+0x11c>
  802780:	83 ec 04             	sub    $0x4,%esp
  802783:	68 e4 40 80 00       	push   $0x8040e4
  802788:	68 e9 00 00 00       	push   $0xe9
  80278d:	68 3b 40 80 00       	push   $0x80403b
  802792:	e8 52 db ff ff       	call   8002e9 <_panic>
  802797:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80279a:	8b 00                	mov    (%eax),%eax
  80279c:	85 c0                	test   %eax,%eax
  80279e:	74 10                	je     8027b0 <alloc_block_NF+0x135>
  8027a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027a3:	8b 00                	mov    (%eax),%eax
  8027a5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027a8:	8b 52 04             	mov    0x4(%edx),%edx
  8027ab:	89 50 04             	mov    %edx,0x4(%eax)
  8027ae:	eb 0b                	jmp    8027bb <alloc_block_NF+0x140>
  8027b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027b3:	8b 40 04             	mov    0x4(%eax),%eax
  8027b6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8027bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027be:	8b 40 04             	mov    0x4(%eax),%eax
  8027c1:	85 c0                	test   %eax,%eax
  8027c3:	74 0f                	je     8027d4 <alloc_block_NF+0x159>
  8027c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c8:	8b 40 04             	mov    0x4(%eax),%eax
  8027cb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027ce:	8b 12                	mov    (%edx),%edx
  8027d0:	89 10                	mov    %edx,(%eax)
  8027d2:	eb 0a                	jmp    8027de <alloc_block_NF+0x163>
  8027d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027d7:	8b 00                	mov    (%eax),%eax
  8027d9:	a3 48 51 80 00       	mov    %eax,0x805148
  8027de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027f1:	a1 54 51 80 00       	mov    0x805154,%eax
  8027f6:	48                   	dec    %eax
  8027f7:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  8027fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ff:	8b 40 08             	mov    0x8(%eax),%eax
  802802:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802807:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280a:	8b 50 08             	mov    0x8(%eax),%edx
  80280d:	8b 45 08             	mov    0x8(%ebp),%eax
  802810:	01 c2                	add    %eax,%edx
  802812:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802815:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802818:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281b:	8b 40 0c             	mov    0xc(%eax),%eax
  80281e:	2b 45 08             	sub    0x8(%ebp),%eax
  802821:	89 c2                	mov    %eax,%edx
  802823:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802826:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802829:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80282c:	e9 15 04 00 00       	jmp    802c46 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802831:	a1 40 51 80 00       	mov    0x805140,%eax
  802836:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802839:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80283d:	74 07                	je     802846 <alloc_block_NF+0x1cb>
  80283f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802842:	8b 00                	mov    (%eax),%eax
  802844:	eb 05                	jmp    80284b <alloc_block_NF+0x1d0>
  802846:	b8 00 00 00 00       	mov    $0x0,%eax
  80284b:	a3 40 51 80 00       	mov    %eax,0x805140
  802850:	a1 40 51 80 00       	mov    0x805140,%eax
  802855:	85 c0                	test   %eax,%eax
  802857:	0f 85 3e fe ff ff    	jne    80269b <alloc_block_NF+0x20>
  80285d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802861:	0f 85 34 fe ff ff    	jne    80269b <alloc_block_NF+0x20>
  802867:	e9 d5 03 00 00       	jmp    802c41 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  80286c:	a1 38 51 80 00       	mov    0x805138,%eax
  802871:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802874:	e9 b1 01 00 00       	jmp    802a2a <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802879:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287c:	8b 50 08             	mov    0x8(%eax),%edx
  80287f:	a1 28 50 80 00       	mov    0x805028,%eax
  802884:	39 c2                	cmp    %eax,%edx
  802886:	0f 82 96 01 00 00    	jb     802a22 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  80288c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288f:	8b 40 0c             	mov    0xc(%eax),%eax
  802892:	3b 45 08             	cmp    0x8(%ebp),%eax
  802895:	0f 82 87 01 00 00    	jb     802a22 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  80289b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289e:	8b 40 0c             	mov    0xc(%eax),%eax
  8028a1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028a4:	0f 85 95 00 00 00    	jne    80293f <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8028aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028ae:	75 17                	jne    8028c7 <alloc_block_NF+0x24c>
  8028b0:	83 ec 04             	sub    $0x4,%esp
  8028b3:	68 e4 40 80 00       	push   $0x8040e4
  8028b8:	68 fc 00 00 00       	push   $0xfc
  8028bd:	68 3b 40 80 00       	push   $0x80403b
  8028c2:	e8 22 da ff ff       	call   8002e9 <_panic>
  8028c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ca:	8b 00                	mov    (%eax),%eax
  8028cc:	85 c0                	test   %eax,%eax
  8028ce:	74 10                	je     8028e0 <alloc_block_NF+0x265>
  8028d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d3:	8b 00                	mov    (%eax),%eax
  8028d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028d8:	8b 52 04             	mov    0x4(%edx),%edx
  8028db:	89 50 04             	mov    %edx,0x4(%eax)
  8028de:	eb 0b                	jmp    8028eb <alloc_block_NF+0x270>
  8028e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e3:	8b 40 04             	mov    0x4(%eax),%eax
  8028e6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8028eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ee:	8b 40 04             	mov    0x4(%eax),%eax
  8028f1:	85 c0                	test   %eax,%eax
  8028f3:	74 0f                	je     802904 <alloc_block_NF+0x289>
  8028f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f8:	8b 40 04             	mov    0x4(%eax),%eax
  8028fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028fe:	8b 12                	mov    (%edx),%edx
  802900:	89 10                	mov    %edx,(%eax)
  802902:	eb 0a                	jmp    80290e <alloc_block_NF+0x293>
  802904:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802907:	8b 00                	mov    (%eax),%eax
  802909:	a3 38 51 80 00       	mov    %eax,0x805138
  80290e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802911:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802917:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802921:	a1 44 51 80 00       	mov    0x805144,%eax
  802926:	48                   	dec    %eax
  802927:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  80292c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292f:	8b 40 08             	mov    0x8(%eax),%eax
  802932:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802937:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293a:	e9 07 03 00 00       	jmp    802c46 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  80293f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802942:	8b 40 0c             	mov    0xc(%eax),%eax
  802945:	3b 45 08             	cmp    0x8(%ebp),%eax
  802948:	0f 86 d4 00 00 00    	jbe    802a22 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80294e:	a1 48 51 80 00       	mov    0x805148,%eax
  802953:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802956:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802959:	8b 50 08             	mov    0x8(%eax),%edx
  80295c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80295f:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802962:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802965:	8b 55 08             	mov    0x8(%ebp),%edx
  802968:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80296b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80296f:	75 17                	jne    802988 <alloc_block_NF+0x30d>
  802971:	83 ec 04             	sub    $0x4,%esp
  802974:	68 e4 40 80 00       	push   $0x8040e4
  802979:	68 04 01 00 00       	push   $0x104
  80297e:	68 3b 40 80 00       	push   $0x80403b
  802983:	e8 61 d9 ff ff       	call   8002e9 <_panic>
  802988:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80298b:	8b 00                	mov    (%eax),%eax
  80298d:	85 c0                	test   %eax,%eax
  80298f:	74 10                	je     8029a1 <alloc_block_NF+0x326>
  802991:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802994:	8b 00                	mov    (%eax),%eax
  802996:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802999:	8b 52 04             	mov    0x4(%edx),%edx
  80299c:	89 50 04             	mov    %edx,0x4(%eax)
  80299f:	eb 0b                	jmp    8029ac <alloc_block_NF+0x331>
  8029a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029a4:	8b 40 04             	mov    0x4(%eax),%eax
  8029a7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8029ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029af:	8b 40 04             	mov    0x4(%eax),%eax
  8029b2:	85 c0                	test   %eax,%eax
  8029b4:	74 0f                	je     8029c5 <alloc_block_NF+0x34a>
  8029b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029b9:	8b 40 04             	mov    0x4(%eax),%eax
  8029bc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8029bf:	8b 12                	mov    (%edx),%edx
  8029c1:	89 10                	mov    %edx,(%eax)
  8029c3:	eb 0a                	jmp    8029cf <alloc_block_NF+0x354>
  8029c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029c8:	8b 00                	mov    (%eax),%eax
  8029ca:	a3 48 51 80 00       	mov    %eax,0x805148
  8029cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029d2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029db:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029e2:	a1 54 51 80 00       	mov    0x805154,%eax
  8029e7:	48                   	dec    %eax
  8029e8:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  8029ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029f0:	8b 40 08             	mov    0x8(%eax),%eax
  8029f3:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  8029f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fb:	8b 50 08             	mov    0x8(%eax),%edx
  8029fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802a01:	01 c2                	add    %eax,%edx
  802a03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a06:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802a09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0c:	8b 40 0c             	mov    0xc(%eax),%eax
  802a0f:	2b 45 08             	sub    0x8(%ebp),%eax
  802a12:	89 c2                	mov    %eax,%edx
  802a14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a17:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802a1a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a1d:	e9 24 02 00 00       	jmp    802c46 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a22:	a1 40 51 80 00       	mov    0x805140,%eax
  802a27:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a2a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a2e:	74 07                	je     802a37 <alloc_block_NF+0x3bc>
  802a30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a33:	8b 00                	mov    (%eax),%eax
  802a35:	eb 05                	jmp    802a3c <alloc_block_NF+0x3c1>
  802a37:	b8 00 00 00 00       	mov    $0x0,%eax
  802a3c:	a3 40 51 80 00       	mov    %eax,0x805140
  802a41:	a1 40 51 80 00       	mov    0x805140,%eax
  802a46:	85 c0                	test   %eax,%eax
  802a48:	0f 85 2b fe ff ff    	jne    802879 <alloc_block_NF+0x1fe>
  802a4e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a52:	0f 85 21 fe ff ff    	jne    802879 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a58:	a1 38 51 80 00       	mov    0x805138,%eax
  802a5d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a60:	e9 ae 01 00 00       	jmp    802c13 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802a65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a68:	8b 50 08             	mov    0x8(%eax),%edx
  802a6b:	a1 28 50 80 00       	mov    0x805028,%eax
  802a70:	39 c2                	cmp    %eax,%edx
  802a72:	0f 83 93 01 00 00    	jae    802c0b <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802a78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7b:	8b 40 0c             	mov    0xc(%eax),%eax
  802a7e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a81:	0f 82 84 01 00 00    	jb     802c0b <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802a87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8a:	8b 40 0c             	mov    0xc(%eax),%eax
  802a8d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a90:	0f 85 95 00 00 00    	jne    802b2b <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802a96:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a9a:	75 17                	jne    802ab3 <alloc_block_NF+0x438>
  802a9c:	83 ec 04             	sub    $0x4,%esp
  802a9f:	68 e4 40 80 00       	push   $0x8040e4
  802aa4:	68 14 01 00 00       	push   $0x114
  802aa9:	68 3b 40 80 00       	push   $0x80403b
  802aae:	e8 36 d8 ff ff       	call   8002e9 <_panic>
  802ab3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab6:	8b 00                	mov    (%eax),%eax
  802ab8:	85 c0                	test   %eax,%eax
  802aba:	74 10                	je     802acc <alloc_block_NF+0x451>
  802abc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abf:	8b 00                	mov    (%eax),%eax
  802ac1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ac4:	8b 52 04             	mov    0x4(%edx),%edx
  802ac7:	89 50 04             	mov    %edx,0x4(%eax)
  802aca:	eb 0b                	jmp    802ad7 <alloc_block_NF+0x45c>
  802acc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acf:	8b 40 04             	mov    0x4(%eax),%eax
  802ad2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ad7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ada:	8b 40 04             	mov    0x4(%eax),%eax
  802add:	85 c0                	test   %eax,%eax
  802adf:	74 0f                	je     802af0 <alloc_block_NF+0x475>
  802ae1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae4:	8b 40 04             	mov    0x4(%eax),%eax
  802ae7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802aea:	8b 12                	mov    (%edx),%edx
  802aec:	89 10                	mov    %edx,(%eax)
  802aee:	eb 0a                	jmp    802afa <alloc_block_NF+0x47f>
  802af0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af3:	8b 00                	mov    (%eax),%eax
  802af5:	a3 38 51 80 00       	mov    %eax,0x805138
  802afa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b06:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b0d:	a1 44 51 80 00       	mov    0x805144,%eax
  802b12:	48                   	dec    %eax
  802b13:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802b18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1b:	8b 40 08             	mov    0x8(%eax),%eax
  802b1e:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802b23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b26:	e9 1b 01 00 00       	jmp    802c46 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802b2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2e:	8b 40 0c             	mov    0xc(%eax),%eax
  802b31:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b34:	0f 86 d1 00 00 00    	jbe    802c0b <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b3a:	a1 48 51 80 00       	mov    0x805148,%eax
  802b3f:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802b42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b45:	8b 50 08             	mov    0x8(%eax),%edx
  802b48:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b4b:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802b4e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b51:	8b 55 08             	mov    0x8(%ebp),%edx
  802b54:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b57:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b5b:	75 17                	jne    802b74 <alloc_block_NF+0x4f9>
  802b5d:	83 ec 04             	sub    $0x4,%esp
  802b60:	68 e4 40 80 00       	push   $0x8040e4
  802b65:	68 1c 01 00 00       	push   $0x11c
  802b6a:	68 3b 40 80 00       	push   $0x80403b
  802b6f:	e8 75 d7 ff ff       	call   8002e9 <_panic>
  802b74:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b77:	8b 00                	mov    (%eax),%eax
  802b79:	85 c0                	test   %eax,%eax
  802b7b:	74 10                	je     802b8d <alloc_block_NF+0x512>
  802b7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b80:	8b 00                	mov    (%eax),%eax
  802b82:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b85:	8b 52 04             	mov    0x4(%edx),%edx
  802b88:	89 50 04             	mov    %edx,0x4(%eax)
  802b8b:	eb 0b                	jmp    802b98 <alloc_block_NF+0x51d>
  802b8d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b90:	8b 40 04             	mov    0x4(%eax),%eax
  802b93:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b98:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b9b:	8b 40 04             	mov    0x4(%eax),%eax
  802b9e:	85 c0                	test   %eax,%eax
  802ba0:	74 0f                	je     802bb1 <alloc_block_NF+0x536>
  802ba2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ba5:	8b 40 04             	mov    0x4(%eax),%eax
  802ba8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802bab:	8b 12                	mov    (%edx),%edx
  802bad:	89 10                	mov    %edx,(%eax)
  802baf:	eb 0a                	jmp    802bbb <alloc_block_NF+0x540>
  802bb1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bb4:	8b 00                	mov    (%eax),%eax
  802bb6:	a3 48 51 80 00       	mov    %eax,0x805148
  802bbb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bbe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bc4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bc7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bce:	a1 54 51 80 00       	mov    0x805154,%eax
  802bd3:	48                   	dec    %eax
  802bd4:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802bd9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bdc:	8b 40 08             	mov    0x8(%eax),%eax
  802bdf:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802be4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be7:	8b 50 08             	mov    0x8(%eax),%edx
  802bea:	8b 45 08             	mov    0x8(%ebp),%eax
  802bed:	01 c2                	add    %eax,%edx
  802bef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf2:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802bf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf8:	8b 40 0c             	mov    0xc(%eax),%eax
  802bfb:	2b 45 08             	sub    0x8(%ebp),%eax
  802bfe:	89 c2                	mov    %eax,%edx
  802c00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c03:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802c06:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c09:	eb 3b                	jmp    802c46 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c0b:	a1 40 51 80 00       	mov    0x805140,%eax
  802c10:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c13:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c17:	74 07                	je     802c20 <alloc_block_NF+0x5a5>
  802c19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1c:	8b 00                	mov    (%eax),%eax
  802c1e:	eb 05                	jmp    802c25 <alloc_block_NF+0x5aa>
  802c20:	b8 00 00 00 00       	mov    $0x0,%eax
  802c25:	a3 40 51 80 00       	mov    %eax,0x805140
  802c2a:	a1 40 51 80 00       	mov    0x805140,%eax
  802c2f:	85 c0                	test   %eax,%eax
  802c31:	0f 85 2e fe ff ff    	jne    802a65 <alloc_block_NF+0x3ea>
  802c37:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c3b:	0f 85 24 fe ff ff    	jne    802a65 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802c41:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c46:	c9                   	leave  
  802c47:	c3                   	ret    

00802c48 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802c48:	55                   	push   %ebp
  802c49:	89 e5                	mov    %esp,%ebp
  802c4b:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802c4e:	a1 38 51 80 00       	mov    0x805138,%eax
  802c53:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802c56:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802c5b:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802c5e:	a1 38 51 80 00       	mov    0x805138,%eax
  802c63:	85 c0                	test   %eax,%eax
  802c65:	74 14                	je     802c7b <insert_sorted_with_merge_freeList+0x33>
  802c67:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6a:	8b 50 08             	mov    0x8(%eax),%edx
  802c6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c70:	8b 40 08             	mov    0x8(%eax),%eax
  802c73:	39 c2                	cmp    %eax,%edx
  802c75:	0f 87 9b 01 00 00    	ja     802e16 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802c7b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c7f:	75 17                	jne    802c98 <insert_sorted_with_merge_freeList+0x50>
  802c81:	83 ec 04             	sub    $0x4,%esp
  802c84:	68 18 40 80 00       	push   $0x804018
  802c89:	68 38 01 00 00       	push   $0x138
  802c8e:	68 3b 40 80 00       	push   $0x80403b
  802c93:	e8 51 d6 ff ff       	call   8002e9 <_panic>
  802c98:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca1:	89 10                	mov    %edx,(%eax)
  802ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca6:	8b 00                	mov    (%eax),%eax
  802ca8:	85 c0                	test   %eax,%eax
  802caa:	74 0d                	je     802cb9 <insert_sorted_with_merge_freeList+0x71>
  802cac:	a1 38 51 80 00       	mov    0x805138,%eax
  802cb1:	8b 55 08             	mov    0x8(%ebp),%edx
  802cb4:	89 50 04             	mov    %edx,0x4(%eax)
  802cb7:	eb 08                	jmp    802cc1 <insert_sorted_with_merge_freeList+0x79>
  802cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbc:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802cc1:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc4:	a3 38 51 80 00       	mov    %eax,0x805138
  802cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ccc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cd3:	a1 44 51 80 00       	mov    0x805144,%eax
  802cd8:	40                   	inc    %eax
  802cd9:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802cde:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ce2:	0f 84 a8 06 00 00    	je     803390 <insert_sorted_with_merge_freeList+0x748>
  802ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ceb:	8b 50 08             	mov    0x8(%eax),%edx
  802cee:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf1:	8b 40 0c             	mov    0xc(%eax),%eax
  802cf4:	01 c2                	add    %eax,%edx
  802cf6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf9:	8b 40 08             	mov    0x8(%eax),%eax
  802cfc:	39 c2                	cmp    %eax,%edx
  802cfe:	0f 85 8c 06 00 00    	jne    803390 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802d04:	8b 45 08             	mov    0x8(%ebp),%eax
  802d07:	8b 50 0c             	mov    0xc(%eax),%edx
  802d0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d0d:	8b 40 0c             	mov    0xc(%eax),%eax
  802d10:	01 c2                	add    %eax,%edx
  802d12:	8b 45 08             	mov    0x8(%ebp),%eax
  802d15:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802d18:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d1c:	75 17                	jne    802d35 <insert_sorted_with_merge_freeList+0xed>
  802d1e:	83 ec 04             	sub    $0x4,%esp
  802d21:	68 e4 40 80 00       	push   $0x8040e4
  802d26:	68 3c 01 00 00       	push   $0x13c
  802d2b:	68 3b 40 80 00       	push   $0x80403b
  802d30:	e8 b4 d5 ff ff       	call   8002e9 <_panic>
  802d35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d38:	8b 00                	mov    (%eax),%eax
  802d3a:	85 c0                	test   %eax,%eax
  802d3c:	74 10                	je     802d4e <insert_sorted_with_merge_freeList+0x106>
  802d3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d41:	8b 00                	mov    (%eax),%eax
  802d43:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d46:	8b 52 04             	mov    0x4(%edx),%edx
  802d49:	89 50 04             	mov    %edx,0x4(%eax)
  802d4c:	eb 0b                	jmp    802d59 <insert_sorted_with_merge_freeList+0x111>
  802d4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d51:	8b 40 04             	mov    0x4(%eax),%eax
  802d54:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d5c:	8b 40 04             	mov    0x4(%eax),%eax
  802d5f:	85 c0                	test   %eax,%eax
  802d61:	74 0f                	je     802d72 <insert_sorted_with_merge_freeList+0x12a>
  802d63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d66:	8b 40 04             	mov    0x4(%eax),%eax
  802d69:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d6c:	8b 12                	mov    (%edx),%edx
  802d6e:	89 10                	mov    %edx,(%eax)
  802d70:	eb 0a                	jmp    802d7c <insert_sorted_with_merge_freeList+0x134>
  802d72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d75:	8b 00                	mov    (%eax),%eax
  802d77:	a3 38 51 80 00       	mov    %eax,0x805138
  802d7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d7f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d88:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d8f:	a1 44 51 80 00       	mov    0x805144,%eax
  802d94:	48                   	dec    %eax
  802d95:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802d9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d9d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802da4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802dae:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802db2:	75 17                	jne    802dcb <insert_sorted_with_merge_freeList+0x183>
  802db4:	83 ec 04             	sub    $0x4,%esp
  802db7:	68 18 40 80 00       	push   $0x804018
  802dbc:	68 3f 01 00 00       	push   $0x13f
  802dc1:	68 3b 40 80 00       	push   $0x80403b
  802dc6:	e8 1e d5 ff ff       	call   8002e9 <_panic>
  802dcb:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802dd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dd4:	89 10                	mov    %edx,(%eax)
  802dd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dd9:	8b 00                	mov    (%eax),%eax
  802ddb:	85 c0                	test   %eax,%eax
  802ddd:	74 0d                	je     802dec <insert_sorted_with_merge_freeList+0x1a4>
  802ddf:	a1 48 51 80 00       	mov    0x805148,%eax
  802de4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802de7:	89 50 04             	mov    %edx,0x4(%eax)
  802dea:	eb 08                	jmp    802df4 <insert_sorted_with_merge_freeList+0x1ac>
  802dec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802def:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802df4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df7:	a3 48 51 80 00       	mov    %eax,0x805148
  802dfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e06:	a1 54 51 80 00       	mov    0x805154,%eax
  802e0b:	40                   	inc    %eax
  802e0c:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802e11:	e9 7a 05 00 00       	jmp    803390 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802e16:	8b 45 08             	mov    0x8(%ebp),%eax
  802e19:	8b 50 08             	mov    0x8(%eax),%edx
  802e1c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e1f:	8b 40 08             	mov    0x8(%eax),%eax
  802e22:	39 c2                	cmp    %eax,%edx
  802e24:	0f 82 14 01 00 00    	jb     802f3e <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802e2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e2d:	8b 50 08             	mov    0x8(%eax),%edx
  802e30:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e33:	8b 40 0c             	mov    0xc(%eax),%eax
  802e36:	01 c2                	add    %eax,%edx
  802e38:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3b:	8b 40 08             	mov    0x8(%eax),%eax
  802e3e:	39 c2                	cmp    %eax,%edx
  802e40:	0f 85 90 00 00 00    	jne    802ed6 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802e46:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e49:	8b 50 0c             	mov    0xc(%eax),%edx
  802e4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4f:	8b 40 0c             	mov    0xc(%eax),%eax
  802e52:	01 c2                	add    %eax,%edx
  802e54:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e57:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802e5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802e64:	8b 45 08             	mov    0x8(%ebp),%eax
  802e67:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802e6e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e72:	75 17                	jne    802e8b <insert_sorted_with_merge_freeList+0x243>
  802e74:	83 ec 04             	sub    $0x4,%esp
  802e77:	68 18 40 80 00       	push   $0x804018
  802e7c:	68 49 01 00 00       	push   $0x149
  802e81:	68 3b 40 80 00       	push   $0x80403b
  802e86:	e8 5e d4 ff ff       	call   8002e9 <_panic>
  802e8b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802e91:	8b 45 08             	mov    0x8(%ebp),%eax
  802e94:	89 10                	mov    %edx,(%eax)
  802e96:	8b 45 08             	mov    0x8(%ebp),%eax
  802e99:	8b 00                	mov    (%eax),%eax
  802e9b:	85 c0                	test   %eax,%eax
  802e9d:	74 0d                	je     802eac <insert_sorted_with_merge_freeList+0x264>
  802e9f:	a1 48 51 80 00       	mov    0x805148,%eax
  802ea4:	8b 55 08             	mov    0x8(%ebp),%edx
  802ea7:	89 50 04             	mov    %edx,0x4(%eax)
  802eaa:	eb 08                	jmp    802eb4 <insert_sorted_with_merge_freeList+0x26c>
  802eac:	8b 45 08             	mov    0x8(%ebp),%eax
  802eaf:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802eb4:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb7:	a3 48 51 80 00       	mov    %eax,0x805148
  802ebc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ec6:	a1 54 51 80 00       	mov    0x805154,%eax
  802ecb:	40                   	inc    %eax
  802ecc:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802ed1:	e9 bb 04 00 00       	jmp    803391 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802ed6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802eda:	75 17                	jne    802ef3 <insert_sorted_with_merge_freeList+0x2ab>
  802edc:	83 ec 04             	sub    $0x4,%esp
  802edf:	68 8c 40 80 00       	push   $0x80408c
  802ee4:	68 4c 01 00 00       	push   $0x14c
  802ee9:	68 3b 40 80 00       	push   $0x80403b
  802eee:	e8 f6 d3 ff ff       	call   8002e9 <_panic>
  802ef3:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  802efc:	89 50 04             	mov    %edx,0x4(%eax)
  802eff:	8b 45 08             	mov    0x8(%ebp),%eax
  802f02:	8b 40 04             	mov    0x4(%eax),%eax
  802f05:	85 c0                	test   %eax,%eax
  802f07:	74 0c                	je     802f15 <insert_sorted_with_merge_freeList+0x2cd>
  802f09:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f0e:	8b 55 08             	mov    0x8(%ebp),%edx
  802f11:	89 10                	mov    %edx,(%eax)
  802f13:	eb 08                	jmp    802f1d <insert_sorted_with_merge_freeList+0x2d5>
  802f15:	8b 45 08             	mov    0x8(%ebp),%eax
  802f18:	a3 38 51 80 00       	mov    %eax,0x805138
  802f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f20:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f25:	8b 45 08             	mov    0x8(%ebp),%eax
  802f28:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f2e:	a1 44 51 80 00       	mov    0x805144,%eax
  802f33:	40                   	inc    %eax
  802f34:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802f39:	e9 53 04 00 00       	jmp    803391 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802f3e:	a1 38 51 80 00       	mov    0x805138,%eax
  802f43:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f46:	e9 15 04 00 00       	jmp    803360 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802f4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4e:	8b 00                	mov    (%eax),%eax
  802f50:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802f53:	8b 45 08             	mov    0x8(%ebp),%eax
  802f56:	8b 50 08             	mov    0x8(%eax),%edx
  802f59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5c:	8b 40 08             	mov    0x8(%eax),%eax
  802f5f:	39 c2                	cmp    %eax,%edx
  802f61:	0f 86 f1 03 00 00    	jbe    803358 <insert_sorted_with_merge_freeList+0x710>
  802f67:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6a:	8b 50 08             	mov    0x8(%eax),%edx
  802f6d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f70:	8b 40 08             	mov    0x8(%eax),%eax
  802f73:	39 c2                	cmp    %eax,%edx
  802f75:	0f 83 dd 03 00 00    	jae    803358 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802f7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7e:	8b 50 08             	mov    0x8(%eax),%edx
  802f81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f84:	8b 40 0c             	mov    0xc(%eax),%eax
  802f87:	01 c2                	add    %eax,%edx
  802f89:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8c:	8b 40 08             	mov    0x8(%eax),%eax
  802f8f:	39 c2                	cmp    %eax,%edx
  802f91:	0f 85 b9 01 00 00    	jne    803150 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802f97:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9a:	8b 50 08             	mov    0x8(%eax),%edx
  802f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa0:	8b 40 0c             	mov    0xc(%eax),%eax
  802fa3:	01 c2                	add    %eax,%edx
  802fa5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fa8:	8b 40 08             	mov    0x8(%eax),%eax
  802fab:	39 c2                	cmp    %eax,%edx
  802fad:	0f 85 0d 01 00 00    	jne    8030c0 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802fb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb6:	8b 50 0c             	mov    0xc(%eax),%edx
  802fb9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fbc:	8b 40 0c             	mov    0xc(%eax),%eax
  802fbf:	01 c2                	add    %eax,%edx
  802fc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc4:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802fc7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802fcb:	75 17                	jne    802fe4 <insert_sorted_with_merge_freeList+0x39c>
  802fcd:	83 ec 04             	sub    $0x4,%esp
  802fd0:	68 e4 40 80 00       	push   $0x8040e4
  802fd5:	68 5c 01 00 00       	push   $0x15c
  802fda:	68 3b 40 80 00       	push   $0x80403b
  802fdf:	e8 05 d3 ff ff       	call   8002e9 <_panic>
  802fe4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fe7:	8b 00                	mov    (%eax),%eax
  802fe9:	85 c0                	test   %eax,%eax
  802feb:	74 10                	je     802ffd <insert_sorted_with_merge_freeList+0x3b5>
  802fed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ff0:	8b 00                	mov    (%eax),%eax
  802ff2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ff5:	8b 52 04             	mov    0x4(%edx),%edx
  802ff8:	89 50 04             	mov    %edx,0x4(%eax)
  802ffb:	eb 0b                	jmp    803008 <insert_sorted_with_merge_freeList+0x3c0>
  802ffd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803000:	8b 40 04             	mov    0x4(%eax),%eax
  803003:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803008:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80300b:	8b 40 04             	mov    0x4(%eax),%eax
  80300e:	85 c0                	test   %eax,%eax
  803010:	74 0f                	je     803021 <insert_sorted_with_merge_freeList+0x3d9>
  803012:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803015:	8b 40 04             	mov    0x4(%eax),%eax
  803018:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80301b:	8b 12                	mov    (%edx),%edx
  80301d:	89 10                	mov    %edx,(%eax)
  80301f:	eb 0a                	jmp    80302b <insert_sorted_with_merge_freeList+0x3e3>
  803021:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803024:	8b 00                	mov    (%eax),%eax
  803026:	a3 38 51 80 00       	mov    %eax,0x805138
  80302b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80302e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803034:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803037:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80303e:	a1 44 51 80 00       	mov    0x805144,%eax
  803043:	48                   	dec    %eax
  803044:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803049:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80304c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803053:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803056:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80305d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803061:	75 17                	jne    80307a <insert_sorted_with_merge_freeList+0x432>
  803063:	83 ec 04             	sub    $0x4,%esp
  803066:	68 18 40 80 00       	push   $0x804018
  80306b:	68 5f 01 00 00       	push   $0x15f
  803070:	68 3b 40 80 00       	push   $0x80403b
  803075:	e8 6f d2 ff ff       	call   8002e9 <_panic>
  80307a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803080:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803083:	89 10                	mov    %edx,(%eax)
  803085:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803088:	8b 00                	mov    (%eax),%eax
  80308a:	85 c0                	test   %eax,%eax
  80308c:	74 0d                	je     80309b <insert_sorted_with_merge_freeList+0x453>
  80308e:	a1 48 51 80 00       	mov    0x805148,%eax
  803093:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803096:	89 50 04             	mov    %edx,0x4(%eax)
  803099:	eb 08                	jmp    8030a3 <insert_sorted_with_merge_freeList+0x45b>
  80309b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80309e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030a6:	a3 48 51 80 00       	mov    %eax,0x805148
  8030ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030b5:	a1 54 51 80 00       	mov    0x805154,%eax
  8030ba:	40                   	inc    %eax
  8030bb:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8030c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c3:	8b 50 0c             	mov    0xc(%eax),%edx
  8030c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c9:	8b 40 0c             	mov    0xc(%eax),%eax
  8030cc:	01 c2                	add    %eax,%edx
  8030ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d1:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8030d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8030de:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8030e8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030ec:	75 17                	jne    803105 <insert_sorted_with_merge_freeList+0x4bd>
  8030ee:	83 ec 04             	sub    $0x4,%esp
  8030f1:	68 18 40 80 00       	push   $0x804018
  8030f6:	68 64 01 00 00       	push   $0x164
  8030fb:	68 3b 40 80 00       	push   $0x80403b
  803100:	e8 e4 d1 ff ff       	call   8002e9 <_panic>
  803105:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80310b:	8b 45 08             	mov    0x8(%ebp),%eax
  80310e:	89 10                	mov    %edx,(%eax)
  803110:	8b 45 08             	mov    0x8(%ebp),%eax
  803113:	8b 00                	mov    (%eax),%eax
  803115:	85 c0                	test   %eax,%eax
  803117:	74 0d                	je     803126 <insert_sorted_with_merge_freeList+0x4de>
  803119:	a1 48 51 80 00       	mov    0x805148,%eax
  80311e:	8b 55 08             	mov    0x8(%ebp),%edx
  803121:	89 50 04             	mov    %edx,0x4(%eax)
  803124:	eb 08                	jmp    80312e <insert_sorted_with_merge_freeList+0x4e6>
  803126:	8b 45 08             	mov    0x8(%ebp),%eax
  803129:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80312e:	8b 45 08             	mov    0x8(%ebp),%eax
  803131:	a3 48 51 80 00       	mov    %eax,0x805148
  803136:	8b 45 08             	mov    0x8(%ebp),%eax
  803139:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803140:	a1 54 51 80 00       	mov    0x805154,%eax
  803145:	40                   	inc    %eax
  803146:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80314b:	e9 41 02 00 00       	jmp    803391 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803150:	8b 45 08             	mov    0x8(%ebp),%eax
  803153:	8b 50 08             	mov    0x8(%eax),%edx
  803156:	8b 45 08             	mov    0x8(%ebp),%eax
  803159:	8b 40 0c             	mov    0xc(%eax),%eax
  80315c:	01 c2                	add    %eax,%edx
  80315e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803161:	8b 40 08             	mov    0x8(%eax),%eax
  803164:	39 c2                	cmp    %eax,%edx
  803166:	0f 85 7c 01 00 00    	jne    8032e8 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  80316c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803170:	74 06                	je     803178 <insert_sorted_with_merge_freeList+0x530>
  803172:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803176:	75 17                	jne    80318f <insert_sorted_with_merge_freeList+0x547>
  803178:	83 ec 04             	sub    $0x4,%esp
  80317b:	68 54 40 80 00       	push   $0x804054
  803180:	68 69 01 00 00       	push   $0x169
  803185:	68 3b 40 80 00       	push   $0x80403b
  80318a:	e8 5a d1 ff ff       	call   8002e9 <_panic>
  80318f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803192:	8b 50 04             	mov    0x4(%eax),%edx
  803195:	8b 45 08             	mov    0x8(%ebp),%eax
  803198:	89 50 04             	mov    %edx,0x4(%eax)
  80319b:	8b 45 08             	mov    0x8(%ebp),%eax
  80319e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031a1:	89 10                	mov    %edx,(%eax)
  8031a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031a6:	8b 40 04             	mov    0x4(%eax),%eax
  8031a9:	85 c0                	test   %eax,%eax
  8031ab:	74 0d                	je     8031ba <insert_sorted_with_merge_freeList+0x572>
  8031ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031b0:	8b 40 04             	mov    0x4(%eax),%eax
  8031b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8031b6:	89 10                	mov    %edx,(%eax)
  8031b8:	eb 08                	jmp    8031c2 <insert_sorted_with_merge_freeList+0x57a>
  8031ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8031bd:	a3 38 51 80 00       	mov    %eax,0x805138
  8031c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8031c8:	89 50 04             	mov    %edx,0x4(%eax)
  8031cb:	a1 44 51 80 00       	mov    0x805144,%eax
  8031d0:	40                   	inc    %eax
  8031d1:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8031d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d9:	8b 50 0c             	mov    0xc(%eax),%edx
  8031dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031df:	8b 40 0c             	mov    0xc(%eax),%eax
  8031e2:	01 c2                	add    %eax,%edx
  8031e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e7:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8031ea:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031ee:	75 17                	jne    803207 <insert_sorted_with_merge_freeList+0x5bf>
  8031f0:	83 ec 04             	sub    $0x4,%esp
  8031f3:	68 e4 40 80 00       	push   $0x8040e4
  8031f8:	68 6b 01 00 00       	push   $0x16b
  8031fd:	68 3b 40 80 00       	push   $0x80403b
  803202:	e8 e2 d0 ff ff       	call   8002e9 <_panic>
  803207:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80320a:	8b 00                	mov    (%eax),%eax
  80320c:	85 c0                	test   %eax,%eax
  80320e:	74 10                	je     803220 <insert_sorted_with_merge_freeList+0x5d8>
  803210:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803213:	8b 00                	mov    (%eax),%eax
  803215:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803218:	8b 52 04             	mov    0x4(%edx),%edx
  80321b:	89 50 04             	mov    %edx,0x4(%eax)
  80321e:	eb 0b                	jmp    80322b <insert_sorted_with_merge_freeList+0x5e3>
  803220:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803223:	8b 40 04             	mov    0x4(%eax),%eax
  803226:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80322b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80322e:	8b 40 04             	mov    0x4(%eax),%eax
  803231:	85 c0                	test   %eax,%eax
  803233:	74 0f                	je     803244 <insert_sorted_with_merge_freeList+0x5fc>
  803235:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803238:	8b 40 04             	mov    0x4(%eax),%eax
  80323b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80323e:	8b 12                	mov    (%edx),%edx
  803240:	89 10                	mov    %edx,(%eax)
  803242:	eb 0a                	jmp    80324e <insert_sorted_with_merge_freeList+0x606>
  803244:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803247:	8b 00                	mov    (%eax),%eax
  803249:	a3 38 51 80 00       	mov    %eax,0x805138
  80324e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803251:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803257:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80325a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803261:	a1 44 51 80 00       	mov    0x805144,%eax
  803266:	48                   	dec    %eax
  803267:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  80326c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80326f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803276:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803279:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803280:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803284:	75 17                	jne    80329d <insert_sorted_with_merge_freeList+0x655>
  803286:	83 ec 04             	sub    $0x4,%esp
  803289:	68 18 40 80 00       	push   $0x804018
  80328e:	68 6e 01 00 00       	push   $0x16e
  803293:	68 3b 40 80 00       	push   $0x80403b
  803298:	e8 4c d0 ff ff       	call   8002e9 <_panic>
  80329d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032a6:	89 10                	mov    %edx,(%eax)
  8032a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ab:	8b 00                	mov    (%eax),%eax
  8032ad:	85 c0                	test   %eax,%eax
  8032af:	74 0d                	je     8032be <insert_sorted_with_merge_freeList+0x676>
  8032b1:	a1 48 51 80 00       	mov    0x805148,%eax
  8032b6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032b9:	89 50 04             	mov    %edx,0x4(%eax)
  8032bc:	eb 08                	jmp    8032c6 <insert_sorted_with_merge_freeList+0x67e>
  8032be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032c1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032c9:	a3 48 51 80 00       	mov    %eax,0x805148
  8032ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032d8:	a1 54 51 80 00       	mov    0x805154,%eax
  8032dd:	40                   	inc    %eax
  8032de:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8032e3:	e9 a9 00 00 00       	jmp    803391 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8032e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032ec:	74 06                	je     8032f4 <insert_sorted_with_merge_freeList+0x6ac>
  8032ee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032f2:	75 17                	jne    80330b <insert_sorted_with_merge_freeList+0x6c3>
  8032f4:	83 ec 04             	sub    $0x4,%esp
  8032f7:	68 b0 40 80 00       	push   $0x8040b0
  8032fc:	68 73 01 00 00       	push   $0x173
  803301:	68 3b 40 80 00       	push   $0x80403b
  803306:	e8 de cf ff ff       	call   8002e9 <_panic>
  80330b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80330e:	8b 10                	mov    (%eax),%edx
  803310:	8b 45 08             	mov    0x8(%ebp),%eax
  803313:	89 10                	mov    %edx,(%eax)
  803315:	8b 45 08             	mov    0x8(%ebp),%eax
  803318:	8b 00                	mov    (%eax),%eax
  80331a:	85 c0                	test   %eax,%eax
  80331c:	74 0b                	je     803329 <insert_sorted_with_merge_freeList+0x6e1>
  80331e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803321:	8b 00                	mov    (%eax),%eax
  803323:	8b 55 08             	mov    0x8(%ebp),%edx
  803326:	89 50 04             	mov    %edx,0x4(%eax)
  803329:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80332c:	8b 55 08             	mov    0x8(%ebp),%edx
  80332f:	89 10                	mov    %edx,(%eax)
  803331:	8b 45 08             	mov    0x8(%ebp),%eax
  803334:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803337:	89 50 04             	mov    %edx,0x4(%eax)
  80333a:	8b 45 08             	mov    0x8(%ebp),%eax
  80333d:	8b 00                	mov    (%eax),%eax
  80333f:	85 c0                	test   %eax,%eax
  803341:	75 08                	jne    80334b <insert_sorted_with_merge_freeList+0x703>
  803343:	8b 45 08             	mov    0x8(%ebp),%eax
  803346:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80334b:	a1 44 51 80 00       	mov    0x805144,%eax
  803350:	40                   	inc    %eax
  803351:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803356:	eb 39                	jmp    803391 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803358:	a1 40 51 80 00       	mov    0x805140,%eax
  80335d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803360:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803364:	74 07                	je     80336d <insert_sorted_with_merge_freeList+0x725>
  803366:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803369:	8b 00                	mov    (%eax),%eax
  80336b:	eb 05                	jmp    803372 <insert_sorted_with_merge_freeList+0x72a>
  80336d:	b8 00 00 00 00       	mov    $0x0,%eax
  803372:	a3 40 51 80 00       	mov    %eax,0x805140
  803377:	a1 40 51 80 00       	mov    0x805140,%eax
  80337c:	85 c0                	test   %eax,%eax
  80337e:	0f 85 c7 fb ff ff    	jne    802f4b <insert_sorted_with_merge_freeList+0x303>
  803384:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803388:	0f 85 bd fb ff ff    	jne    802f4b <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80338e:	eb 01                	jmp    803391 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803390:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803391:	90                   	nop
  803392:	c9                   	leave  
  803393:	c3                   	ret    

00803394 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803394:	55                   	push   %ebp
  803395:	89 e5                	mov    %esp,%ebp
  803397:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  80339a:	8b 55 08             	mov    0x8(%ebp),%edx
  80339d:	89 d0                	mov    %edx,%eax
  80339f:	c1 e0 02             	shl    $0x2,%eax
  8033a2:	01 d0                	add    %edx,%eax
  8033a4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8033ab:	01 d0                	add    %edx,%eax
  8033ad:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8033b4:	01 d0                	add    %edx,%eax
  8033b6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8033bd:	01 d0                	add    %edx,%eax
  8033bf:	c1 e0 04             	shl    $0x4,%eax
  8033c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8033c5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8033cc:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8033cf:	83 ec 0c             	sub    $0xc,%esp
  8033d2:	50                   	push   %eax
  8033d3:	e8 26 e7 ff ff       	call   801afe <sys_get_virtual_time>
  8033d8:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8033db:	eb 41                	jmp    80341e <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8033dd:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8033e0:	83 ec 0c             	sub    $0xc,%esp
  8033e3:	50                   	push   %eax
  8033e4:	e8 15 e7 ff ff       	call   801afe <sys_get_virtual_time>
  8033e9:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8033ec:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8033ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033f2:	29 c2                	sub    %eax,%edx
  8033f4:	89 d0                	mov    %edx,%eax
  8033f6:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8033f9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8033fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033ff:	89 d1                	mov    %edx,%ecx
  803401:	29 c1                	sub    %eax,%ecx
  803403:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803406:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803409:	39 c2                	cmp    %eax,%edx
  80340b:	0f 97 c0             	seta   %al
  80340e:	0f b6 c0             	movzbl %al,%eax
  803411:	29 c1                	sub    %eax,%ecx
  803413:	89 c8                	mov    %ecx,%eax
  803415:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803418:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80341b:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  80341e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803421:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803424:	72 b7                	jb     8033dd <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803426:	90                   	nop
  803427:	c9                   	leave  
  803428:	c3                   	ret    

00803429 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803429:	55                   	push   %ebp
  80342a:	89 e5                	mov    %esp,%ebp
  80342c:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  80342f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803436:	eb 03                	jmp    80343b <busy_wait+0x12>
  803438:	ff 45 fc             	incl   -0x4(%ebp)
  80343b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80343e:	3b 45 08             	cmp    0x8(%ebp),%eax
  803441:	72 f5                	jb     803438 <busy_wait+0xf>
	return i;
  803443:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803446:	c9                   	leave  
  803447:	c3                   	ret    

00803448 <__udivdi3>:
  803448:	55                   	push   %ebp
  803449:	57                   	push   %edi
  80344a:	56                   	push   %esi
  80344b:	53                   	push   %ebx
  80344c:	83 ec 1c             	sub    $0x1c,%esp
  80344f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803453:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803457:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80345b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80345f:	89 ca                	mov    %ecx,%edx
  803461:	89 f8                	mov    %edi,%eax
  803463:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803467:	85 f6                	test   %esi,%esi
  803469:	75 2d                	jne    803498 <__udivdi3+0x50>
  80346b:	39 cf                	cmp    %ecx,%edi
  80346d:	77 65                	ja     8034d4 <__udivdi3+0x8c>
  80346f:	89 fd                	mov    %edi,%ebp
  803471:	85 ff                	test   %edi,%edi
  803473:	75 0b                	jne    803480 <__udivdi3+0x38>
  803475:	b8 01 00 00 00       	mov    $0x1,%eax
  80347a:	31 d2                	xor    %edx,%edx
  80347c:	f7 f7                	div    %edi
  80347e:	89 c5                	mov    %eax,%ebp
  803480:	31 d2                	xor    %edx,%edx
  803482:	89 c8                	mov    %ecx,%eax
  803484:	f7 f5                	div    %ebp
  803486:	89 c1                	mov    %eax,%ecx
  803488:	89 d8                	mov    %ebx,%eax
  80348a:	f7 f5                	div    %ebp
  80348c:	89 cf                	mov    %ecx,%edi
  80348e:	89 fa                	mov    %edi,%edx
  803490:	83 c4 1c             	add    $0x1c,%esp
  803493:	5b                   	pop    %ebx
  803494:	5e                   	pop    %esi
  803495:	5f                   	pop    %edi
  803496:	5d                   	pop    %ebp
  803497:	c3                   	ret    
  803498:	39 ce                	cmp    %ecx,%esi
  80349a:	77 28                	ja     8034c4 <__udivdi3+0x7c>
  80349c:	0f bd fe             	bsr    %esi,%edi
  80349f:	83 f7 1f             	xor    $0x1f,%edi
  8034a2:	75 40                	jne    8034e4 <__udivdi3+0x9c>
  8034a4:	39 ce                	cmp    %ecx,%esi
  8034a6:	72 0a                	jb     8034b2 <__udivdi3+0x6a>
  8034a8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8034ac:	0f 87 9e 00 00 00    	ja     803550 <__udivdi3+0x108>
  8034b2:	b8 01 00 00 00       	mov    $0x1,%eax
  8034b7:	89 fa                	mov    %edi,%edx
  8034b9:	83 c4 1c             	add    $0x1c,%esp
  8034bc:	5b                   	pop    %ebx
  8034bd:	5e                   	pop    %esi
  8034be:	5f                   	pop    %edi
  8034bf:	5d                   	pop    %ebp
  8034c0:	c3                   	ret    
  8034c1:	8d 76 00             	lea    0x0(%esi),%esi
  8034c4:	31 ff                	xor    %edi,%edi
  8034c6:	31 c0                	xor    %eax,%eax
  8034c8:	89 fa                	mov    %edi,%edx
  8034ca:	83 c4 1c             	add    $0x1c,%esp
  8034cd:	5b                   	pop    %ebx
  8034ce:	5e                   	pop    %esi
  8034cf:	5f                   	pop    %edi
  8034d0:	5d                   	pop    %ebp
  8034d1:	c3                   	ret    
  8034d2:	66 90                	xchg   %ax,%ax
  8034d4:	89 d8                	mov    %ebx,%eax
  8034d6:	f7 f7                	div    %edi
  8034d8:	31 ff                	xor    %edi,%edi
  8034da:	89 fa                	mov    %edi,%edx
  8034dc:	83 c4 1c             	add    $0x1c,%esp
  8034df:	5b                   	pop    %ebx
  8034e0:	5e                   	pop    %esi
  8034e1:	5f                   	pop    %edi
  8034e2:	5d                   	pop    %ebp
  8034e3:	c3                   	ret    
  8034e4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8034e9:	89 eb                	mov    %ebp,%ebx
  8034eb:	29 fb                	sub    %edi,%ebx
  8034ed:	89 f9                	mov    %edi,%ecx
  8034ef:	d3 e6                	shl    %cl,%esi
  8034f1:	89 c5                	mov    %eax,%ebp
  8034f3:	88 d9                	mov    %bl,%cl
  8034f5:	d3 ed                	shr    %cl,%ebp
  8034f7:	89 e9                	mov    %ebp,%ecx
  8034f9:	09 f1                	or     %esi,%ecx
  8034fb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8034ff:	89 f9                	mov    %edi,%ecx
  803501:	d3 e0                	shl    %cl,%eax
  803503:	89 c5                	mov    %eax,%ebp
  803505:	89 d6                	mov    %edx,%esi
  803507:	88 d9                	mov    %bl,%cl
  803509:	d3 ee                	shr    %cl,%esi
  80350b:	89 f9                	mov    %edi,%ecx
  80350d:	d3 e2                	shl    %cl,%edx
  80350f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803513:	88 d9                	mov    %bl,%cl
  803515:	d3 e8                	shr    %cl,%eax
  803517:	09 c2                	or     %eax,%edx
  803519:	89 d0                	mov    %edx,%eax
  80351b:	89 f2                	mov    %esi,%edx
  80351d:	f7 74 24 0c          	divl   0xc(%esp)
  803521:	89 d6                	mov    %edx,%esi
  803523:	89 c3                	mov    %eax,%ebx
  803525:	f7 e5                	mul    %ebp
  803527:	39 d6                	cmp    %edx,%esi
  803529:	72 19                	jb     803544 <__udivdi3+0xfc>
  80352b:	74 0b                	je     803538 <__udivdi3+0xf0>
  80352d:	89 d8                	mov    %ebx,%eax
  80352f:	31 ff                	xor    %edi,%edi
  803531:	e9 58 ff ff ff       	jmp    80348e <__udivdi3+0x46>
  803536:	66 90                	xchg   %ax,%ax
  803538:	8b 54 24 08          	mov    0x8(%esp),%edx
  80353c:	89 f9                	mov    %edi,%ecx
  80353e:	d3 e2                	shl    %cl,%edx
  803540:	39 c2                	cmp    %eax,%edx
  803542:	73 e9                	jae    80352d <__udivdi3+0xe5>
  803544:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803547:	31 ff                	xor    %edi,%edi
  803549:	e9 40 ff ff ff       	jmp    80348e <__udivdi3+0x46>
  80354e:	66 90                	xchg   %ax,%ax
  803550:	31 c0                	xor    %eax,%eax
  803552:	e9 37 ff ff ff       	jmp    80348e <__udivdi3+0x46>
  803557:	90                   	nop

00803558 <__umoddi3>:
  803558:	55                   	push   %ebp
  803559:	57                   	push   %edi
  80355a:	56                   	push   %esi
  80355b:	53                   	push   %ebx
  80355c:	83 ec 1c             	sub    $0x1c,%esp
  80355f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803563:	8b 74 24 34          	mov    0x34(%esp),%esi
  803567:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80356b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80356f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803573:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803577:	89 f3                	mov    %esi,%ebx
  803579:	89 fa                	mov    %edi,%edx
  80357b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80357f:	89 34 24             	mov    %esi,(%esp)
  803582:	85 c0                	test   %eax,%eax
  803584:	75 1a                	jne    8035a0 <__umoddi3+0x48>
  803586:	39 f7                	cmp    %esi,%edi
  803588:	0f 86 a2 00 00 00    	jbe    803630 <__umoddi3+0xd8>
  80358e:	89 c8                	mov    %ecx,%eax
  803590:	89 f2                	mov    %esi,%edx
  803592:	f7 f7                	div    %edi
  803594:	89 d0                	mov    %edx,%eax
  803596:	31 d2                	xor    %edx,%edx
  803598:	83 c4 1c             	add    $0x1c,%esp
  80359b:	5b                   	pop    %ebx
  80359c:	5e                   	pop    %esi
  80359d:	5f                   	pop    %edi
  80359e:	5d                   	pop    %ebp
  80359f:	c3                   	ret    
  8035a0:	39 f0                	cmp    %esi,%eax
  8035a2:	0f 87 ac 00 00 00    	ja     803654 <__umoddi3+0xfc>
  8035a8:	0f bd e8             	bsr    %eax,%ebp
  8035ab:	83 f5 1f             	xor    $0x1f,%ebp
  8035ae:	0f 84 ac 00 00 00    	je     803660 <__umoddi3+0x108>
  8035b4:	bf 20 00 00 00       	mov    $0x20,%edi
  8035b9:	29 ef                	sub    %ebp,%edi
  8035bb:	89 fe                	mov    %edi,%esi
  8035bd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8035c1:	89 e9                	mov    %ebp,%ecx
  8035c3:	d3 e0                	shl    %cl,%eax
  8035c5:	89 d7                	mov    %edx,%edi
  8035c7:	89 f1                	mov    %esi,%ecx
  8035c9:	d3 ef                	shr    %cl,%edi
  8035cb:	09 c7                	or     %eax,%edi
  8035cd:	89 e9                	mov    %ebp,%ecx
  8035cf:	d3 e2                	shl    %cl,%edx
  8035d1:	89 14 24             	mov    %edx,(%esp)
  8035d4:	89 d8                	mov    %ebx,%eax
  8035d6:	d3 e0                	shl    %cl,%eax
  8035d8:	89 c2                	mov    %eax,%edx
  8035da:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035de:	d3 e0                	shl    %cl,%eax
  8035e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8035e4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035e8:	89 f1                	mov    %esi,%ecx
  8035ea:	d3 e8                	shr    %cl,%eax
  8035ec:	09 d0                	or     %edx,%eax
  8035ee:	d3 eb                	shr    %cl,%ebx
  8035f0:	89 da                	mov    %ebx,%edx
  8035f2:	f7 f7                	div    %edi
  8035f4:	89 d3                	mov    %edx,%ebx
  8035f6:	f7 24 24             	mull   (%esp)
  8035f9:	89 c6                	mov    %eax,%esi
  8035fb:	89 d1                	mov    %edx,%ecx
  8035fd:	39 d3                	cmp    %edx,%ebx
  8035ff:	0f 82 87 00 00 00    	jb     80368c <__umoddi3+0x134>
  803605:	0f 84 91 00 00 00    	je     80369c <__umoddi3+0x144>
  80360b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80360f:	29 f2                	sub    %esi,%edx
  803611:	19 cb                	sbb    %ecx,%ebx
  803613:	89 d8                	mov    %ebx,%eax
  803615:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803619:	d3 e0                	shl    %cl,%eax
  80361b:	89 e9                	mov    %ebp,%ecx
  80361d:	d3 ea                	shr    %cl,%edx
  80361f:	09 d0                	or     %edx,%eax
  803621:	89 e9                	mov    %ebp,%ecx
  803623:	d3 eb                	shr    %cl,%ebx
  803625:	89 da                	mov    %ebx,%edx
  803627:	83 c4 1c             	add    $0x1c,%esp
  80362a:	5b                   	pop    %ebx
  80362b:	5e                   	pop    %esi
  80362c:	5f                   	pop    %edi
  80362d:	5d                   	pop    %ebp
  80362e:	c3                   	ret    
  80362f:	90                   	nop
  803630:	89 fd                	mov    %edi,%ebp
  803632:	85 ff                	test   %edi,%edi
  803634:	75 0b                	jne    803641 <__umoddi3+0xe9>
  803636:	b8 01 00 00 00       	mov    $0x1,%eax
  80363b:	31 d2                	xor    %edx,%edx
  80363d:	f7 f7                	div    %edi
  80363f:	89 c5                	mov    %eax,%ebp
  803641:	89 f0                	mov    %esi,%eax
  803643:	31 d2                	xor    %edx,%edx
  803645:	f7 f5                	div    %ebp
  803647:	89 c8                	mov    %ecx,%eax
  803649:	f7 f5                	div    %ebp
  80364b:	89 d0                	mov    %edx,%eax
  80364d:	e9 44 ff ff ff       	jmp    803596 <__umoddi3+0x3e>
  803652:	66 90                	xchg   %ax,%ax
  803654:	89 c8                	mov    %ecx,%eax
  803656:	89 f2                	mov    %esi,%edx
  803658:	83 c4 1c             	add    $0x1c,%esp
  80365b:	5b                   	pop    %ebx
  80365c:	5e                   	pop    %esi
  80365d:	5f                   	pop    %edi
  80365e:	5d                   	pop    %ebp
  80365f:	c3                   	ret    
  803660:	3b 04 24             	cmp    (%esp),%eax
  803663:	72 06                	jb     80366b <__umoddi3+0x113>
  803665:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803669:	77 0f                	ja     80367a <__umoddi3+0x122>
  80366b:	89 f2                	mov    %esi,%edx
  80366d:	29 f9                	sub    %edi,%ecx
  80366f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803673:	89 14 24             	mov    %edx,(%esp)
  803676:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80367a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80367e:	8b 14 24             	mov    (%esp),%edx
  803681:	83 c4 1c             	add    $0x1c,%esp
  803684:	5b                   	pop    %ebx
  803685:	5e                   	pop    %esi
  803686:	5f                   	pop    %edi
  803687:	5d                   	pop    %ebp
  803688:	c3                   	ret    
  803689:	8d 76 00             	lea    0x0(%esi),%esi
  80368c:	2b 04 24             	sub    (%esp),%eax
  80368f:	19 fa                	sbb    %edi,%edx
  803691:	89 d1                	mov    %edx,%ecx
  803693:	89 c6                	mov    %eax,%esi
  803695:	e9 71 ff ff ff       	jmp    80360b <__umoddi3+0xb3>
  80369a:	66 90                	xchg   %ax,%ax
  80369c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8036a0:	72 ea                	jb     80368c <__umoddi3+0x134>
  8036a2:	89 d9                	mov    %ebx,%ecx
  8036a4:	e9 62 ff ff ff       	jmp    80360b <__umoddi3+0xb3>
