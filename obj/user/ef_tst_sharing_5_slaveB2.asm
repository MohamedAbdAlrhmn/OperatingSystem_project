
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
  80008c:	68 e0 36 80 00       	push   $0x8036e0
  800091:	6a 12                	push   $0x12
  800093:	68 fc 36 80 00       	push   $0x8036fc
  800098:	e8 4c 02 00 00       	call   8002e9 <_panic>
	}
	uint32 *z;
	z = sget(sys_getparentenvid(),"z");
  80009d:	e8 51 1a 00 00       	call   801af3 <sys_getparentenvid>
  8000a2:	83 ec 08             	sub    $0x8,%esp
  8000a5:	68 1c 37 80 00       	push   $0x80371c
  8000aa:	50                   	push   %eax
  8000ab:	e8 a6 15 00 00       	call   801656 <sget>
  8000b0:	83 c4 10             	add    $0x10,%esp
  8000b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("Slave B2 env used z (getSharedObject)\n");
  8000b6:	83 ec 0c             	sub    $0xc,%esp
  8000b9:	68 20 37 80 00       	push   $0x803720
  8000be:	e8 da 04 00 00       	call   80059d <cprintf>
  8000c3:	83 c4 10             	add    $0x10,%esp

	cprintf("Slave B2 please be patient ...\n");
  8000c6:	83 ec 0c             	sub    $0xc,%esp
  8000c9:	68 48 37 80 00       	push   $0x803748
  8000ce:	e8 ca 04 00 00       	call   80059d <cprintf>
  8000d3:	83 c4 10             	add    $0x10,%esp

	env_sleep(9000);
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	68 28 23 00 00       	push   $0x2328
  8000de:	e8 d9 32 00 00       	call   8033bc <env_sleep>
  8000e3:	83 c4 10             	add    $0x10,%esp
	int freeFrames = sys_calculate_free_frames() ;
  8000e6:	e8 0f 17 00 00       	call   8017fa <sys_calculate_free_frames>
  8000eb:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sfree(z);
  8000ee:	83 ec 0c             	sub    $0xc,%esp
  8000f1:	ff 75 ec             	pushl  -0x14(%ebp)
  8000f4:	e8 a1 15 00 00       	call   80169a <sfree>
  8000f9:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave B2 env removed z\n");
  8000fc:	83 ec 0c             	sub    $0xc,%esp
  8000ff:	68 68 37 80 00       	push   $0x803768
  800104:	e8 94 04 00 00       	call   80059d <cprintf>
  800109:	83 c4 10             	add    $0x10,%esp

	if ((sys_calculate_free_frames() - freeFrames) !=  4) panic("wrong free: frames removed not equal 4 !, correct frames to be removed are 4:\nfrom the env: 1 table + 1 frame for z\nframes_storage of z: should be cleared now\n");
  80010c:	e8 e9 16 00 00       	call   8017fa <sys_calculate_free_frames>
  800111:	89 c2                	mov    %eax,%edx
  800113:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800116:	29 c2                	sub    %eax,%edx
  800118:	89 d0                	mov    %edx,%eax
  80011a:	83 f8 04             	cmp    $0x4,%eax
  80011d:	74 14                	je     800133 <_main+0xfb>
  80011f:	83 ec 04             	sub    $0x4,%esp
  800122:	68 80 37 80 00       	push   $0x803780
  800127:	6a 20                	push   $0x20
  800129:	68 fc 36 80 00       	push   $0x8036fc
  80012e:	e8 b6 01 00 00       	call   8002e9 <_panic>

	//to ensure that the other environments completed successfully
	if (gettst()!=2) panic("test failed");
  800133:	e8 fa 1a 00 00       	call   801c32 <gettst>
  800138:	83 f8 02             	cmp    $0x2,%eax
  80013b:	74 14                	je     800151 <_main+0x119>
  80013d:	83 ec 04             	sub    $0x4,%esp
  800140:	68 20 38 80 00       	push   $0x803820
  800145:	6a 23                	push   $0x23
  800147:	68 fc 36 80 00       	push   $0x8036fc
  80014c:	e8 98 01 00 00       	call   8002e9 <_panic>

	cprintf("Step B completed successfully!!\n\n\n");
  800151:	83 ec 0c             	sub    $0xc,%esp
  800154:	68 2c 38 80 00       	push   $0x80382c
  800159:	e8 3f 04 00 00       	call   80059d <cprintf>
  80015e:	83 c4 10             	add    $0x10,%esp
	cprintf("Congratulations!! Test of freeSharedObjects [5] completed successfully!!\n\n\n");
  800161:	83 ec 0c             	sub    $0xc,%esp
  800164:	68 50 38 80 00       	push   $0x803850
  800169:	e8 2f 04 00 00       	call   80059d <cprintf>
  80016e:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  800171:	e8 7d 19 00 00       	call   801af3 <sys_getparentenvid>
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
  800189:	68 9c 38 80 00       	push   $0x80389c
  80018e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800191:	e8 c0 14 00 00       	call   801656 <sget>
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
  8001b3:	e8 22 19 00 00       	call   801ada <sys_getenvindex>
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
  80021e:	e8 c4 16 00 00       	call   8018e7 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800223:	83 ec 0c             	sub    $0xc,%esp
  800226:	68 c4 38 80 00       	push   $0x8038c4
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
  80024e:	68 ec 38 80 00       	push   $0x8038ec
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
  80027f:	68 14 39 80 00       	push   $0x803914
  800284:	e8 14 03 00 00       	call   80059d <cprintf>
  800289:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80028c:	a1 20 50 80 00       	mov    0x805020,%eax
  800291:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800297:	83 ec 08             	sub    $0x8,%esp
  80029a:	50                   	push   %eax
  80029b:	68 6c 39 80 00       	push   $0x80396c
  8002a0:	e8 f8 02 00 00       	call   80059d <cprintf>
  8002a5:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8002a8:	83 ec 0c             	sub    $0xc,%esp
  8002ab:	68 c4 38 80 00       	push   $0x8038c4
  8002b0:	e8 e8 02 00 00       	call   80059d <cprintf>
  8002b5:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8002b8:	e8 44 16 00 00       	call   801901 <sys_enable_interrupt>

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
  8002d0:	e8 d1 17 00 00       	call   801aa6 <sys_destroy_env>
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
  8002e1:	e8 26 18 00 00       	call   801b0c <sys_exit_env>
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
  80030a:	68 80 39 80 00       	push   $0x803980
  80030f:	e8 89 02 00 00       	call   80059d <cprintf>
  800314:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800317:	a1 00 50 80 00       	mov    0x805000,%eax
  80031c:	ff 75 0c             	pushl  0xc(%ebp)
  80031f:	ff 75 08             	pushl  0x8(%ebp)
  800322:	50                   	push   %eax
  800323:	68 85 39 80 00       	push   $0x803985
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
  800347:	68 a1 39 80 00       	push   $0x8039a1
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
  800373:	68 a4 39 80 00       	push   $0x8039a4
  800378:	6a 26                	push   $0x26
  80037a:	68 f0 39 80 00       	push   $0x8039f0
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
  800445:	68 fc 39 80 00       	push   $0x8039fc
  80044a:	6a 3a                	push   $0x3a
  80044c:	68 f0 39 80 00       	push   $0x8039f0
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
  8004b5:	68 50 3a 80 00       	push   $0x803a50
  8004ba:	6a 44                	push   $0x44
  8004bc:	68 f0 39 80 00       	push   $0x8039f0
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
  80050f:	e8 25 12 00 00       	call   801739 <sys_cputs>
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
  800586:	e8 ae 11 00 00       	call   801739 <sys_cputs>
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
  8005d0:	e8 12 13 00 00       	call   8018e7 <sys_disable_interrupt>
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
  8005f0:	e8 0c 13 00 00       	call   801901 <sys_enable_interrupt>
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
  80063a:	e8 31 2e 00 00       	call   803470 <__udivdi3>
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
  80068a:	e8 f1 2e 00 00       	call   803580 <__umoddi3>
  80068f:	83 c4 10             	add    $0x10,%esp
  800692:	05 b4 3c 80 00       	add    $0x803cb4,%eax
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
  8007e5:	8b 04 85 d8 3c 80 00 	mov    0x803cd8(,%eax,4),%eax
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
  8008c6:	8b 34 9d 20 3b 80 00 	mov    0x803b20(,%ebx,4),%esi
  8008cd:	85 f6                	test   %esi,%esi
  8008cf:	75 19                	jne    8008ea <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008d1:	53                   	push   %ebx
  8008d2:	68 c5 3c 80 00       	push   $0x803cc5
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
  8008eb:	68 ce 3c 80 00       	push   $0x803cce
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
  800918:	be d1 3c 80 00       	mov    $0x803cd1,%esi
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
  80133e:	68 30 3e 80 00       	push   $0x803e30
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
  80140e:	e8 6a 04 00 00       	call   80187d <sys_allocate_chunk>
  801413:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801416:	a1 20 51 80 00       	mov    0x805120,%eax
  80141b:	83 ec 0c             	sub    $0xc,%esp
  80141e:	50                   	push   %eax
  80141f:	e8 df 0a 00 00       	call   801f03 <initialize_MemBlocksList>
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
  80144c:	68 55 3e 80 00       	push   $0x803e55
  801451:	6a 33                	push   $0x33
  801453:	68 73 3e 80 00       	push   $0x803e73
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
  8014cb:	68 80 3e 80 00       	push   $0x803e80
  8014d0:	6a 34                	push   $0x34
  8014d2:	68 73 3e 80 00       	push   $0x803e73
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
  801528:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80152b:	e8 f7 fd ff ff       	call   801327 <InitializeUHeap>
	if (size == 0) return NULL ;
  801530:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801534:	75 07                	jne    80153d <malloc+0x18>
  801536:	b8 00 00 00 00       	mov    $0x0,%eax
  80153b:	eb 61                	jmp    80159e <malloc+0x79>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
	uint32 malloc_allocsize=ROUNDUP(size,PAGE_SIZE);
  80153d:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801544:	8b 55 08             	mov    0x8(%ebp),%edx
  801547:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80154a:	01 d0                	add    %edx,%eax
  80154c:	48                   	dec    %eax
  80154d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801550:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801553:	ba 00 00 00 00       	mov    $0x0,%edx
  801558:	f7 75 f0             	divl   -0x10(%ebp)
  80155b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80155e:	29 d0                	sub    %edx,%eax
  801560:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 //int ret=0;
	struct MemBlock * user_block;
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801563:	e8 e3 06 00 00       	call   801c4b <sys_isUHeapPlacementStrategyFIRSTFIT>
  801568:	85 c0                	test   %eax,%eax
  80156a:	74 11                	je     80157d <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  80156c:	83 ec 0c             	sub    $0xc,%esp
  80156f:	ff 75 e8             	pushl  -0x18(%ebp)
  801572:	e8 4e 0d 00 00       	call   8022c5 <alloc_block_FF>
  801577:	83 c4 10             	add    $0x10,%esp
  80157a:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(user_block!=NULL)
  80157d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801581:	74 16                	je     801599 <malloc+0x74>
	{
		//sys_allocate_chunk(user_block->sva,malloc_allocsize,PERM_WRITEABLE| PERM_PRESENT);
		insert_sorted_allocList(user_block);
  801583:	83 ec 0c             	sub    $0xc,%esp
  801586:	ff 75 f4             	pushl  -0xc(%ebp)
  801589:	e8 aa 0a 00 00       	call   802038 <insert_sorted_allocList>
  80158e:	83 c4 10             	add    $0x10,%esp
		return (uint32 *)user_block->sva;
  801591:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801594:	8b 40 08             	mov    0x8(%eax),%eax
  801597:	eb 05                	jmp    80159e <malloc+0x79>
	}

    return NULL;
  801599:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80159e:	c9                   	leave  
  80159f:	c3                   	ret    

008015a0 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8015a0:	55                   	push   %ebp
  8015a1:	89 e5                	mov    %esp,%ebp
  8015a3:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  8015a6:	83 ec 04             	sub    $0x4,%esp
  8015a9:	68 a4 3e 80 00       	push   $0x803ea4
  8015ae:	6a 6f                	push   $0x6f
  8015b0:	68 73 3e 80 00       	push   $0x803e73
  8015b5:	e8 2f ed ff ff       	call   8002e9 <_panic>

008015ba <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8015ba:	55                   	push   %ebp
  8015bb:	89 e5                	mov    %esp,%ebp
  8015bd:	83 ec 38             	sub    $0x38,%esp
  8015c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8015c3:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015c6:	e8 5c fd ff ff       	call   801327 <InitializeUHeap>
	if (size == 0) return NULL ;
  8015cb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015cf:	75 07                	jne    8015d8 <smalloc+0x1e>
  8015d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8015d6:	eb 7c                	jmp    801654 <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  8015d8:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8015df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015e5:	01 d0                	add    %edx,%eax
  8015e7:	48                   	dec    %eax
  8015e8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8015eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8015f3:	f7 75 f0             	divl   -0x10(%ebp)
  8015f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015f9:	29 d0                	sub    %edx,%eax
  8015fb:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  8015fe:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801605:	e8 41 06 00 00       	call   801c4b <sys_isUHeapPlacementStrategyFIRSTFIT>
  80160a:	85 c0                	test   %eax,%eax
  80160c:	74 11                	je     80161f <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  80160e:	83 ec 0c             	sub    $0xc,%esp
  801611:	ff 75 e8             	pushl  -0x18(%ebp)
  801614:	e8 ac 0c 00 00       	call   8022c5 <alloc_block_FF>
  801619:	83 c4 10             	add    $0x10,%esp
  80161c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  80161f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801623:	74 2a                	je     80164f <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801625:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801628:	8b 40 08             	mov    0x8(%eax),%eax
  80162b:	89 c2                	mov    %eax,%edx
  80162d:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801631:	52                   	push   %edx
  801632:	50                   	push   %eax
  801633:	ff 75 0c             	pushl  0xc(%ebp)
  801636:	ff 75 08             	pushl  0x8(%ebp)
  801639:	e8 92 03 00 00       	call   8019d0 <sys_createSharedObject>
  80163e:	83 c4 10             	add    $0x10,%esp
  801641:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  801644:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  801648:	74 05                	je     80164f <smalloc+0x95>
			return (void*)virtual_address;
  80164a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80164d:	eb 05                	jmp    801654 <smalloc+0x9a>
	}
	return NULL;
  80164f:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801654:	c9                   	leave  
  801655:	c3                   	ret    

00801656 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801656:	55                   	push   %ebp
  801657:	89 e5                	mov    %esp,%ebp
  801659:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80165c:	e8 c6 fc ff ff       	call   801327 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801661:	83 ec 04             	sub    $0x4,%esp
  801664:	68 c8 3e 80 00       	push   $0x803ec8
  801669:	68 b0 00 00 00       	push   $0xb0
  80166e:	68 73 3e 80 00       	push   $0x803e73
  801673:	e8 71 ec ff ff       	call   8002e9 <_panic>

00801678 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801678:	55                   	push   %ebp
  801679:	89 e5                	mov    %esp,%ebp
  80167b:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80167e:	e8 a4 fc ff ff       	call   801327 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801683:	83 ec 04             	sub    $0x4,%esp
  801686:	68 ec 3e 80 00       	push   $0x803eec
  80168b:	68 f4 00 00 00       	push   $0xf4
  801690:	68 73 3e 80 00       	push   $0x803e73
  801695:	e8 4f ec ff ff       	call   8002e9 <_panic>

0080169a <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80169a:	55                   	push   %ebp
  80169b:	89 e5                	mov    %esp,%ebp
  80169d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8016a0:	83 ec 04             	sub    $0x4,%esp
  8016a3:	68 14 3f 80 00       	push   $0x803f14
  8016a8:	68 08 01 00 00       	push   $0x108
  8016ad:	68 73 3e 80 00       	push   $0x803e73
  8016b2:	e8 32 ec ff ff       	call   8002e9 <_panic>

008016b7 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8016b7:	55                   	push   %ebp
  8016b8:	89 e5                	mov    %esp,%ebp
  8016ba:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016bd:	83 ec 04             	sub    $0x4,%esp
  8016c0:	68 38 3f 80 00       	push   $0x803f38
  8016c5:	68 13 01 00 00       	push   $0x113
  8016ca:	68 73 3e 80 00       	push   $0x803e73
  8016cf:	e8 15 ec ff ff       	call   8002e9 <_panic>

008016d4 <shrink>:

}
void shrink(uint32 newSize)
{
  8016d4:	55                   	push   %ebp
  8016d5:	89 e5                	mov    %esp,%ebp
  8016d7:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016da:	83 ec 04             	sub    $0x4,%esp
  8016dd:	68 38 3f 80 00       	push   $0x803f38
  8016e2:	68 18 01 00 00       	push   $0x118
  8016e7:	68 73 3e 80 00       	push   $0x803e73
  8016ec:	e8 f8 eb ff ff       	call   8002e9 <_panic>

008016f1 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8016f1:	55                   	push   %ebp
  8016f2:	89 e5                	mov    %esp,%ebp
  8016f4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016f7:	83 ec 04             	sub    $0x4,%esp
  8016fa:	68 38 3f 80 00       	push   $0x803f38
  8016ff:	68 1d 01 00 00       	push   $0x11d
  801704:	68 73 3e 80 00       	push   $0x803e73
  801709:	e8 db eb ff ff       	call   8002e9 <_panic>

0080170e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80170e:	55                   	push   %ebp
  80170f:	89 e5                	mov    %esp,%ebp
  801711:	57                   	push   %edi
  801712:	56                   	push   %esi
  801713:	53                   	push   %ebx
  801714:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801717:	8b 45 08             	mov    0x8(%ebp),%eax
  80171a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80171d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801720:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801723:	8b 7d 18             	mov    0x18(%ebp),%edi
  801726:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801729:	cd 30                	int    $0x30
  80172b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80172e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801731:	83 c4 10             	add    $0x10,%esp
  801734:	5b                   	pop    %ebx
  801735:	5e                   	pop    %esi
  801736:	5f                   	pop    %edi
  801737:	5d                   	pop    %ebp
  801738:	c3                   	ret    

00801739 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801739:	55                   	push   %ebp
  80173a:	89 e5                	mov    %esp,%ebp
  80173c:	83 ec 04             	sub    $0x4,%esp
  80173f:	8b 45 10             	mov    0x10(%ebp),%eax
  801742:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801745:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801749:	8b 45 08             	mov    0x8(%ebp),%eax
  80174c:	6a 00                	push   $0x0
  80174e:	6a 00                	push   $0x0
  801750:	52                   	push   %edx
  801751:	ff 75 0c             	pushl  0xc(%ebp)
  801754:	50                   	push   %eax
  801755:	6a 00                	push   $0x0
  801757:	e8 b2 ff ff ff       	call   80170e <syscall>
  80175c:	83 c4 18             	add    $0x18,%esp
}
  80175f:	90                   	nop
  801760:	c9                   	leave  
  801761:	c3                   	ret    

00801762 <sys_cgetc>:

int
sys_cgetc(void)
{
  801762:	55                   	push   %ebp
  801763:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801765:	6a 00                	push   $0x0
  801767:	6a 00                	push   $0x0
  801769:	6a 00                	push   $0x0
  80176b:	6a 00                	push   $0x0
  80176d:	6a 00                	push   $0x0
  80176f:	6a 01                	push   $0x1
  801771:	e8 98 ff ff ff       	call   80170e <syscall>
  801776:	83 c4 18             	add    $0x18,%esp
}
  801779:	c9                   	leave  
  80177a:	c3                   	ret    

0080177b <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80177b:	55                   	push   %ebp
  80177c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80177e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801781:	8b 45 08             	mov    0x8(%ebp),%eax
  801784:	6a 00                	push   $0x0
  801786:	6a 00                	push   $0x0
  801788:	6a 00                	push   $0x0
  80178a:	52                   	push   %edx
  80178b:	50                   	push   %eax
  80178c:	6a 05                	push   $0x5
  80178e:	e8 7b ff ff ff       	call   80170e <syscall>
  801793:	83 c4 18             	add    $0x18,%esp
}
  801796:	c9                   	leave  
  801797:	c3                   	ret    

00801798 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801798:	55                   	push   %ebp
  801799:	89 e5                	mov    %esp,%ebp
  80179b:	56                   	push   %esi
  80179c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80179d:	8b 75 18             	mov    0x18(%ebp),%esi
  8017a0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017a3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ac:	56                   	push   %esi
  8017ad:	53                   	push   %ebx
  8017ae:	51                   	push   %ecx
  8017af:	52                   	push   %edx
  8017b0:	50                   	push   %eax
  8017b1:	6a 06                	push   $0x6
  8017b3:	e8 56 ff ff ff       	call   80170e <syscall>
  8017b8:	83 c4 18             	add    $0x18,%esp
}
  8017bb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017be:	5b                   	pop    %ebx
  8017bf:	5e                   	pop    %esi
  8017c0:	5d                   	pop    %ebp
  8017c1:	c3                   	ret    

008017c2 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8017c2:	55                   	push   %ebp
  8017c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8017c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cb:	6a 00                	push   $0x0
  8017cd:	6a 00                	push   $0x0
  8017cf:	6a 00                	push   $0x0
  8017d1:	52                   	push   %edx
  8017d2:	50                   	push   %eax
  8017d3:	6a 07                	push   $0x7
  8017d5:	e8 34 ff ff ff       	call   80170e <syscall>
  8017da:	83 c4 18             	add    $0x18,%esp
}
  8017dd:	c9                   	leave  
  8017de:	c3                   	ret    

008017df <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8017df:	55                   	push   %ebp
  8017e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8017e2:	6a 00                	push   $0x0
  8017e4:	6a 00                	push   $0x0
  8017e6:	6a 00                	push   $0x0
  8017e8:	ff 75 0c             	pushl  0xc(%ebp)
  8017eb:	ff 75 08             	pushl  0x8(%ebp)
  8017ee:	6a 08                	push   $0x8
  8017f0:	e8 19 ff ff ff       	call   80170e <syscall>
  8017f5:	83 c4 18             	add    $0x18,%esp
}
  8017f8:	c9                   	leave  
  8017f9:	c3                   	ret    

008017fa <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8017fa:	55                   	push   %ebp
  8017fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8017fd:	6a 00                	push   $0x0
  8017ff:	6a 00                	push   $0x0
  801801:	6a 00                	push   $0x0
  801803:	6a 00                	push   $0x0
  801805:	6a 00                	push   $0x0
  801807:	6a 09                	push   $0x9
  801809:	e8 00 ff ff ff       	call   80170e <syscall>
  80180e:	83 c4 18             	add    $0x18,%esp
}
  801811:	c9                   	leave  
  801812:	c3                   	ret    

00801813 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801813:	55                   	push   %ebp
  801814:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801816:	6a 00                	push   $0x0
  801818:	6a 00                	push   $0x0
  80181a:	6a 00                	push   $0x0
  80181c:	6a 00                	push   $0x0
  80181e:	6a 00                	push   $0x0
  801820:	6a 0a                	push   $0xa
  801822:	e8 e7 fe ff ff       	call   80170e <syscall>
  801827:	83 c4 18             	add    $0x18,%esp
}
  80182a:	c9                   	leave  
  80182b:	c3                   	ret    

0080182c <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80182c:	55                   	push   %ebp
  80182d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80182f:	6a 00                	push   $0x0
  801831:	6a 00                	push   $0x0
  801833:	6a 00                	push   $0x0
  801835:	6a 00                	push   $0x0
  801837:	6a 00                	push   $0x0
  801839:	6a 0b                	push   $0xb
  80183b:	e8 ce fe ff ff       	call   80170e <syscall>
  801840:	83 c4 18             	add    $0x18,%esp
}
  801843:	c9                   	leave  
  801844:	c3                   	ret    

00801845 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801845:	55                   	push   %ebp
  801846:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801848:	6a 00                	push   $0x0
  80184a:	6a 00                	push   $0x0
  80184c:	6a 00                	push   $0x0
  80184e:	ff 75 0c             	pushl  0xc(%ebp)
  801851:	ff 75 08             	pushl  0x8(%ebp)
  801854:	6a 0f                	push   $0xf
  801856:	e8 b3 fe ff ff       	call   80170e <syscall>
  80185b:	83 c4 18             	add    $0x18,%esp
	return;
  80185e:	90                   	nop
}
  80185f:	c9                   	leave  
  801860:	c3                   	ret    

00801861 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801861:	55                   	push   %ebp
  801862:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801864:	6a 00                	push   $0x0
  801866:	6a 00                	push   $0x0
  801868:	6a 00                	push   $0x0
  80186a:	ff 75 0c             	pushl  0xc(%ebp)
  80186d:	ff 75 08             	pushl  0x8(%ebp)
  801870:	6a 10                	push   $0x10
  801872:	e8 97 fe ff ff       	call   80170e <syscall>
  801877:	83 c4 18             	add    $0x18,%esp
	return ;
  80187a:	90                   	nop
}
  80187b:	c9                   	leave  
  80187c:	c3                   	ret    

0080187d <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80187d:	55                   	push   %ebp
  80187e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801880:	6a 00                	push   $0x0
  801882:	6a 00                	push   $0x0
  801884:	ff 75 10             	pushl  0x10(%ebp)
  801887:	ff 75 0c             	pushl  0xc(%ebp)
  80188a:	ff 75 08             	pushl  0x8(%ebp)
  80188d:	6a 11                	push   $0x11
  80188f:	e8 7a fe ff ff       	call   80170e <syscall>
  801894:	83 c4 18             	add    $0x18,%esp
	return ;
  801897:	90                   	nop
}
  801898:	c9                   	leave  
  801899:	c3                   	ret    

0080189a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80189a:	55                   	push   %ebp
  80189b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80189d:	6a 00                	push   $0x0
  80189f:	6a 00                	push   $0x0
  8018a1:	6a 00                	push   $0x0
  8018a3:	6a 00                	push   $0x0
  8018a5:	6a 00                	push   $0x0
  8018a7:	6a 0c                	push   $0xc
  8018a9:	e8 60 fe ff ff       	call   80170e <syscall>
  8018ae:	83 c4 18             	add    $0x18,%esp
}
  8018b1:	c9                   	leave  
  8018b2:	c3                   	ret    

008018b3 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8018b3:	55                   	push   %ebp
  8018b4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8018b6:	6a 00                	push   $0x0
  8018b8:	6a 00                	push   $0x0
  8018ba:	6a 00                	push   $0x0
  8018bc:	6a 00                	push   $0x0
  8018be:	ff 75 08             	pushl  0x8(%ebp)
  8018c1:	6a 0d                	push   $0xd
  8018c3:	e8 46 fe ff ff       	call   80170e <syscall>
  8018c8:	83 c4 18             	add    $0x18,%esp
}
  8018cb:	c9                   	leave  
  8018cc:	c3                   	ret    

008018cd <sys_scarce_memory>:

void sys_scarce_memory()
{
  8018cd:	55                   	push   %ebp
  8018ce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8018d0:	6a 00                	push   $0x0
  8018d2:	6a 00                	push   $0x0
  8018d4:	6a 00                	push   $0x0
  8018d6:	6a 00                	push   $0x0
  8018d8:	6a 00                	push   $0x0
  8018da:	6a 0e                	push   $0xe
  8018dc:	e8 2d fe ff ff       	call   80170e <syscall>
  8018e1:	83 c4 18             	add    $0x18,%esp
}
  8018e4:	90                   	nop
  8018e5:	c9                   	leave  
  8018e6:	c3                   	ret    

008018e7 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8018e7:	55                   	push   %ebp
  8018e8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8018ea:	6a 00                	push   $0x0
  8018ec:	6a 00                	push   $0x0
  8018ee:	6a 00                	push   $0x0
  8018f0:	6a 00                	push   $0x0
  8018f2:	6a 00                	push   $0x0
  8018f4:	6a 13                	push   $0x13
  8018f6:	e8 13 fe ff ff       	call   80170e <syscall>
  8018fb:	83 c4 18             	add    $0x18,%esp
}
  8018fe:	90                   	nop
  8018ff:	c9                   	leave  
  801900:	c3                   	ret    

00801901 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801901:	55                   	push   %ebp
  801902:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801904:	6a 00                	push   $0x0
  801906:	6a 00                	push   $0x0
  801908:	6a 00                	push   $0x0
  80190a:	6a 00                	push   $0x0
  80190c:	6a 00                	push   $0x0
  80190e:	6a 14                	push   $0x14
  801910:	e8 f9 fd ff ff       	call   80170e <syscall>
  801915:	83 c4 18             	add    $0x18,%esp
}
  801918:	90                   	nop
  801919:	c9                   	leave  
  80191a:	c3                   	ret    

0080191b <sys_cputc>:


void
sys_cputc(const char c)
{
  80191b:	55                   	push   %ebp
  80191c:	89 e5                	mov    %esp,%ebp
  80191e:	83 ec 04             	sub    $0x4,%esp
  801921:	8b 45 08             	mov    0x8(%ebp),%eax
  801924:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801927:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80192b:	6a 00                	push   $0x0
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	6a 00                	push   $0x0
  801933:	50                   	push   %eax
  801934:	6a 15                	push   $0x15
  801936:	e8 d3 fd ff ff       	call   80170e <syscall>
  80193b:	83 c4 18             	add    $0x18,%esp
}
  80193e:	90                   	nop
  80193f:	c9                   	leave  
  801940:	c3                   	ret    

00801941 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801941:	55                   	push   %ebp
  801942:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801944:	6a 00                	push   $0x0
  801946:	6a 00                	push   $0x0
  801948:	6a 00                	push   $0x0
  80194a:	6a 00                	push   $0x0
  80194c:	6a 00                	push   $0x0
  80194e:	6a 16                	push   $0x16
  801950:	e8 b9 fd ff ff       	call   80170e <syscall>
  801955:	83 c4 18             	add    $0x18,%esp
}
  801958:	90                   	nop
  801959:	c9                   	leave  
  80195a:	c3                   	ret    

0080195b <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80195b:	55                   	push   %ebp
  80195c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80195e:	8b 45 08             	mov    0x8(%ebp),%eax
  801961:	6a 00                	push   $0x0
  801963:	6a 00                	push   $0x0
  801965:	6a 00                	push   $0x0
  801967:	ff 75 0c             	pushl  0xc(%ebp)
  80196a:	50                   	push   %eax
  80196b:	6a 17                	push   $0x17
  80196d:	e8 9c fd ff ff       	call   80170e <syscall>
  801972:	83 c4 18             	add    $0x18,%esp
}
  801975:	c9                   	leave  
  801976:	c3                   	ret    

00801977 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801977:	55                   	push   %ebp
  801978:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80197a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80197d:	8b 45 08             	mov    0x8(%ebp),%eax
  801980:	6a 00                	push   $0x0
  801982:	6a 00                	push   $0x0
  801984:	6a 00                	push   $0x0
  801986:	52                   	push   %edx
  801987:	50                   	push   %eax
  801988:	6a 1a                	push   $0x1a
  80198a:	e8 7f fd ff ff       	call   80170e <syscall>
  80198f:	83 c4 18             	add    $0x18,%esp
}
  801992:	c9                   	leave  
  801993:	c3                   	ret    

00801994 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801994:	55                   	push   %ebp
  801995:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801997:	8b 55 0c             	mov    0xc(%ebp),%edx
  80199a:	8b 45 08             	mov    0x8(%ebp),%eax
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	52                   	push   %edx
  8019a4:	50                   	push   %eax
  8019a5:	6a 18                	push   $0x18
  8019a7:	e8 62 fd ff ff       	call   80170e <syscall>
  8019ac:	83 c4 18             	add    $0x18,%esp
}
  8019af:	90                   	nop
  8019b0:	c9                   	leave  
  8019b1:	c3                   	ret    

008019b2 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8019b2:	55                   	push   %ebp
  8019b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 00                	push   $0x0
  8019c1:	52                   	push   %edx
  8019c2:	50                   	push   %eax
  8019c3:	6a 19                	push   $0x19
  8019c5:	e8 44 fd ff ff       	call   80170e <syscall>
  8019ca:	83 c4 18             	add    $0x18,%esp
}
  8019cd:	90                   	nop
  8019ce:	c9                   	leave  
  8019cf:	c3                   	ret    

008019d0 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8019d0:	55                   	push   %ebp
  8019d1:	89 e5                	mov    %esp,%ebp
  8019d3:	83 ec 04             	sub    $0x4,%esp
  8019d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8019d9:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8019dc:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8019df:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e6:	6a 00                	push   $0x0
  8019e8:	51                   	push   %ecx
  8019e9:	52                   	push   %edx
  8019ea:	ff 75 0c             	pushl  0xc(%ebp)
  8019ed:	50                   	push   %eax
  8019ee:	6a 1b                	push   $0x1b
  8019f0:	e8 19 fd ff ff       	call   80170e <syscall>
  8019f5:	83 c4 18             	add    $0x18,%esp
}
  8019f8:	c9                   	leave  
  8019f9:	c3                   	ret    

008019fa <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8019fa:	55                   	push   %ebp
  8019fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8019fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a00:	8b 45 08             	mov    0x8(%ebp),%eax
  801a03:	6a 00                	push   $0x0
  801a05:	6a 00                	push   $0x0
  801a07:	6a 00                	push   $0x0
  801a09:	52                   	push   %edx
  801a0a:	50                   	push   %eax
  801a0b:	6a 1c                	push   $0x1c
  801a0d:	e8 fc fc ff ff       	call   80170e <syscall>
  801a12:	83 c4 18             	add    $0x18,%esp
}
  801a15:	c9                   	leave  
  801a16:	c3                   	ret    

00801a17 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801a17:	55                   	push   %ebp
  801a18:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a1a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a1d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a20:	8b 45 08             	mov    0x8(%ebp),%eax
  801a23:	6a 00                	push   $0x0
  801a25:	6a 00                	push   $0x0
  801a27:	51                   	push   %ecx
  801a28:	52                   	push   %edx
  801a29:	50                   	push   %eax
  801a2a:	6a 1d                	push   $0x1d
  801a2c:	e8 dd fc ff ff       	call   80170e <syscall>
  801a31:	83 c4 18             	add    $0x18,%esp
}
  801a34:	c9                   	leave  
  801a35:	c3                   	ret    

00801a36 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801a36:	55                   	push   %ebp
  801a37:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a39:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3f:	6a 00                	push   $0x0
  801a41:	6a 00                	push   $0x0
  801a43:	6a 00                	push   $0x0
  801a45:	52                   	push   %edx
  801a46:	50                   	push   %eax
  801a47:	6a 1e                	push   $0x1e
  801a49:	e8 c0 fc ff ff       	call   80170e <syscall>
  801a4e:	83 c4 18             	add    $0x18,%esp
}
  801a51:	c9                   	leave  
  801a52:	c3                   	ret    

00801a53 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801a53:	55                   	push   %ebp
  801a54:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801a56:	6a 00                	push   $0x0
  801a58:	6a 00                	push   $0x0
  801a5a:	6a 00                	push   $0x0
  801a5c:	6a 00                	push   $0x0
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 1f                	push   $0x1f
  801a62:	e8 a7 fc ff ff       	call   80170e <syscall>
  801a67:	83 c4 18             	add    $0x18,%esp
}
  801a6a:	c9                   	leave  
  801a6b:	c3                   	ret    

00801a6c <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a6c:	55                   	push   %ebp
  801a6d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a72:	6a 00                	push   $0x0
  801a74:	ff 75 14             	pushl  0x14(%ebp)
  801a77:	ff 75 10             	pushl  0x10(%ebp)
  801a7a:	ff 75 0c             	pushl  0xc(%ebp)
  801a7d:	50                   	push   %eax
  801a7e:	6a 20                	push   $0x20
  801a80:	e8 89 fc ff ff       	call   80170e <syscall>
  801a85:	83 c4 18             	add    $0x18,%esp
}
  801a88:	c9                   	leave  
  801a89:	c3                   	ret    

00801a8a <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801a8a:	55                   	push   %ebp
  801a8b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a90:	6a 00                	push   $0x0
  801a92:	6a 00                	push   $0x0
  801a94:	6a 00                	push   $0x0
  801a96:	6a 00                	push   $0x0
  801a98:	50                   	push   %eax
  801a99:	6a 21                	push   $0x21
  801a9b:	e8 6e fc ff ff       	call   80170e <syscall>
  801aa0:	83 c4 18             	add    $0x18,%esp
}
  801aa3:	90                   	nop
  801aa4:	c9                   	leave  
  801aa5:	c3                   	ret    

00801aa6 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801aa6:	55                   	push   %ebp
  801aa7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  801aac:	6a 00                	push   $0x0
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	50                   	push   %eax
  801ab5:	6a 22                	push   $0x22
  801ab7:	e8 52 fc ff ff       	call   80170e <syscall>
  801abc:	83 c4 18             	add    $0x18,%esp
}
  801abf:	c9                   	leave  
  801ac0:	c3                   	ret    

00801ac1 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ac1:	55                   	push   %ebp
  801ac2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ac4:	6a 00                	push   $0x0
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 00                	push   $0x0
  801aca:	6a 00                	push   $0x0
  801acc:	6a 00                	push   $0x0
  801ace:	6a 02                	push   $0x2
  801ad0:	e8 39 fc ff ff       	call   80170e <syscall>
  801ad5:	83 c4 18             	add    $0x18,%esp
}
  801ad8:	c9                   	leave  
  801ad9:	c3                   	ret    

00801ada <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ada:	55                   	push   %ebp
  801adb:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801add:	6a 00                	push   $0x0
  801adf:	6a 00                	push   $0x0
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 03                	push   $0x3
  801ae9:	e8 20 fc ff ff       	call   80170e <syscall>
  801aee:	83 c4 18             	add    $0x18,%esp
}
  801af1:	c9                   	leave  
  801af2:	c3                   	ret    

00801af3 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801af3:	55                   	push   %ebp
  801af4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801af6:	6a 00                	push   $0x0
  801af8:	6a 00                	push   $0x0
  801afa:	6a 00                	push   $0x0
  801afc:	6a 00                	push   $0x0
  801afe:	6a 00                	push   $0x0
  801b00:	6a 04                	push   $0x4
  801b02:	e8 07 fc ff ff       	call   80170e <syscall>
  801b07:	83 c4 18             	add    $0x18,%esp
}
  801b0a:	c9                   	leave  
  801b0b:	c3                   	ret    

00801b0c <sys_exit_env>:


void sys_exit_env(void)
{
  801b0c:	55                   	push   %ebp
  801b0d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 00                	push   $0x0
  801b13:	6a 00                	push   $0x0
  801b15:	6a 00                	push   $0x0
  801b17:	6a 00                	push   $0x0
  801b19:	6a 23                	push   $0x23
  801b1b:	e8 ee fb ff ff       	call   80170e <syscall>
  801b20:	83 c4 18             	add    $0x18,%esp
}
  801b23:	90                   	nop
  801b24:	c9                   	leave  
  801b25:	c3                   	ret    

00801b26 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801b26:	55                   	push   %ebp
  801b27:	89 e5                	mov    %esp,%ebp
  801b29:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b2c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b2f:	8d 50 04             	lea    0x4(%eax),%edx
  801b32:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b35:	6a 00                	push   $0x0
  801b37:	6a 00                	push   $0x0
  801b39:	6a 00                	push   $0x0
  801b3b:	52                   	push   %edx
  801b3c:	50                   	push   %eax
  801b3d:	6a 24                	push   $0x24
  801b3f:	e8 ca fb ff ff       	call   80170e <syscall>
  801b44:	83 c4 18             	add    $0x18,%esp
	return result;
  801b47:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b4a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b4d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b50:	89 01                	mov    %eax,(%ecx)
  801b52:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b55:	8b 45 08             	mov    0x8(%ebp),%eax
  801b58:	c9                   	leave  
  801b59:	c2 04 00             	ret    $0x4

00801b5c <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b5c:	55                   	push   %ebp
  801b5d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b5f:	6a 00                	push   $0x0
  801b61:	6a 00                	push   $0x0
  801b63:	ff 75 10             	pushl  0x10(%ebp)
  801b66:	ff 75 0c             	pushl  0xc(%ebp)
  801b69:	ff 75 08             	pushl  0x8(%ebp)
  801b6c:	6a 12                	push   $0x12
  801b6e:	e8 9b fb ff ff       	call   80170e <syscall>
  801b73:	83 c4 18             	add    $0x18,%esp
	return ;
  801b76:	90                   	nop
}
  801b77:	c9                   	leave  
  801b78:	c3                   	ret    

00801b79 <sys_rcr2>:
uint32 sys_rcr2()
{
  801b79:	55                   	push   %ebp
  801b7a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b7c:	6a 00                	push   $0x0
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 00                	push   $0x0
  801b82:	6a 00                	push   $0x0
  801b84:	6a 00                	push   $0x0
  801b86:	6a 25                	push   $0x25
  801b88:	e8 81 fb ff ff       	call   80170e <syscall>
  801b8d:	83 c4 18             	add    $0x18,%esp
}
  801b90:	c9                   	leave  
  801b91:	c3                   	ret    

00801b92 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801b92:	55                   	push   %ebp
  801b93:	89 e5                	mov    %esp,%ebp
  801b95:	83 ec 04             	sub    $0x4,%esp
  801b98:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801b9e:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 00                	push   $0x0
  801ba6:	6a 00                	push   $0x0
  801ba8:	6a 00                	push   $0x0
  801baa:	50                   	push   %eax
  801bab:	6a 26                	push   $0x26
  801bad:	e8 5c fb ff ff       	call   80170e <syscall>
  801bb2:	83 c4 18             	add    $0x18,%esp
	return ;
  801bb5:	90                   	nop
}
  801bb6:	c9                   	leave  
  801bb7:	c3                   	ret    

00801bb8 <rsttst>:
void rsttst()
{
  801bb8:	55                   	push   %ebp
  801bb9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801bbb:	6a 00                	push   $0x0
  801bbd:	6a 00                	push   $0x0
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 28                	push   $0x28
  801bc7:	e8 42 fb ff ff       	call   80170e <syscall>
  801bcc:	83 c4 18             	add    $0x18,%esp
	return ;
  801bcf:	90                   	nop
}
  801bd0:	c9                   	leave  
  801bd1:	c3                   	ret    

00801bd2 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801bd2:	55                   	push   %ebp
  801bd3:	89 e5                	mov    %esp,%ebp
  801bd5:	83 ec 04             	sub    $0x4,%esp
  801bd8:	8b 45 14             	mov    0x14(%ebp),%eax
  801bdb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801bde:	8b 55 18             	mov    0x18(%ebp),%edx
  801be1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801be5:	52                   	push   %edx
  801be6:	50                   	push   %eax
  801be7:	ff 75 10             	pushl  0x10(%ebp)
  801bea:	ff 75 0c             	pushl  0xc(%ebp)
  801bed:	ff 75 08             	pushl  0x8(%ebp)
  801bf0:	6a 27                	push   $0x27
  801bf2:	e8 17 fb ff ff       	call   80170e <syscall>
  801bf7:	83 c4 18             	add    $0x18,%esp
	return ;
  801bfa:	90                   	nop
}
  801bfb:	c9                   	leave  
  801bfc:	c3                   	ret    

00801bfd <chktst>:
void chktst(uint32 n)
{
  801bfd:	55                   	push   %ebp
  801bfe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c00:	6a 00                	push   $0x0
  801c02:	6a 00                	push   $0x0
  801c04:	6a 00                	push   $0x0
  801c06:	6a 00                	push   $0x0
  801c08:	ff 75 08             	pushl  0x8(%ebp)
  801c0b:	6a 29                	push   $0x29
  801c0d:	e8 fc fa ff ff       	call   80170e <syscall>
  801c12:	83 c4 18             	add    $0x18,%esp
	return ;
  801c15:	90                   	nop
}
  801c16:	c9                   	leave  
  801c17:	c3                   	ret    

00801c18 <inctst>:

void inctst()
{
  801c18:	55                   	push   %ebp
  801c19:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	6a 00                	push   $0x0
  801c25:	6a 2a                	push   $0x2a
  801c27:	e8 e2 fa ff ff       	call   80170e <syscall>
  801c2c:	83 c4 18             	add    $0x18,%esp
	return ;
  801c2f:	90                   	nop
}
  801c30:	c9                   	leave  
  801c31:	c3                   	ret    

00801c32 <gettst>:
uint32 gettst()
{
  801c32:	55                   	push   %ebp
  801c33:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 00                	push   $0x0
  801c3f:	6a 2b                	push   $0x2b
  801c41:	e8 c8 fa ff ff       	call   80170e <syscall>
  801c46:	83 c4 18             	add    $0x18,%esp
}
  801c49:	c9                   	leave  
  801c4a:	c3                   	ret    

00801c4b <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801c4b:	55                   	push   %ebp
  801c4c:	89 e5                	mov    %esp,%ebp
  801c4e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	6a 00                	push   $0x0
  801c57:	6a 00                	push   $0x0
  801c59:	6a 00                	push   $0x0
  801c5b:	6a 2c                	push   $0x2c
  801c5d:	e8 ac fa ff ff       	call   80170e <syscall>
  801c62:	83 c4 18             	add    $0x18,%esp
  801c65:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801c68:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801c6c:	75 07                	jne    801c75 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801c6e:	b8 01 00 00 00       	mov    $0x1,%eax
  801c73:	eb 05                	jmp    801c7a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801c75:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c7a:	c9                   	leave  
  801c7b:	c3                   	ret    

00801c7c <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801c7c:	55                   	push   %ebp
  801c7d:	89 e5                	mov    %esp,%ebp
  801c7f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c82:	6a 00                	push   $0x0
  801c84:	6a 00                	push   $0x0
  801c86:	6a 00                	push   $0x0
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 2c                	push   $0x2c
  801c8e:	e8 7b fa ff ff       	call   80170e <syscall>
  801c93:	83 c4 18             	add    $0x18,%esp
  801c96:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801c99:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801c9d:	75 07                	jne    801ca6 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801c9f:	b8 01 00 00 00       	mov    $0x1,%eax
  801ca4:	eb 05                	jmp    801cab <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801ca6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cab:	c9                   	leave  
  801cac:	c3                   	ret    

00801cad <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801cad:	55                   	push   %ebp
  801cae:	89 e5                	mov    %esp,%ebp
  801cb0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cb3:	6a 00                	push   $0x0
  801cb5:	6a 00                	push   $0x0
  801cb7:	6a 00                	push   $0x0
  801cb9:	6a 00                	push   $0x0
  801cbb:	6a 00                	push   $0x0
  801cbd:	6a 2c                	push   $0x2c
  801cbf:	e8 4a fa ff ff       	call   80170e <syscall>
  801cc4:	83 c4 18             	add    $0x18,%esp
  801cc7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801cca:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801cce:	75 07                	jne    801cd7 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801cd0:	b8 01 00 00 00       	mov    $0x1,%eax
  801cd5:	eb 05                	jmp    801cdc <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801cd7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cdc:	c9                   	leave  
  801cdd:	c3                   	ret    

00801cde <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801cde:	55                   	push   %ebp
  801cdf:	89 e5                	mov    %esp,%ebp
  801ce1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ce4:	6a 00                	push   $0x0
  801ce6:	6a 00                	push   $0x0
  801ce8:	6a 00                	push   $0x0
  801cea:	6a 00                	push   $0x0
  801cec:	6a 00                	push   $0x0
  801cee:	6a 2c                	push   $0x2c
  801cf0:	e8 19 fa ff ff       	call   80170e <syscall>
  801cf5:	83 c4 18             	add    $0x18,%esp
  801cf8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801cfb:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801cff:	75 07                	jne    801d08 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801d01:	b8 01 00 00 00       	mov    $0x1,%eax
  801d06:	eb 05                	jmp    801d0d <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801d08:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d0d:	c9                   	leave  
  801d0e:	c3                   	ret    

00801d0f <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801d0f:	55                   	push   %ebp
  801d10:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801d12:	6a 00                	push   $0x0
  801d14:	6a 00                	push   $0x0
  801d16:	6a 00                	push   $0x0
  801d18:	6a 00                	push   $0x0
  801d1a:	ff 75 08             	pushl  0x8(%ebp)
  801d1d:	6a 2d                	push   $0x2d
  801d1f:	e8 ea f9 ff ff       	call   80170e <syscall>
  801d24:	83 c4 18             	add    $0x18,%esp
	return ;
  801d27:	90                   	nop
}
  801d28:	c9                   	leave  
  801d29:	c3                   	ret    

00801d2a <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801d2a:	55                   	push   %ebp
  801d2b:	89 e5                	mov    %esp,%ebp
  801d2d:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801d2e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d31:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d34:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d37:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3a:	6a 00                	push   $0x0
  801d3c:	53                   	push   %ebx
  801d3d:	51                   	push   %ecx
  801d3e:	52                   	push   %edx
  801d3f:	50                   	push   %eax
  801d40:	6a 2e                	push   $0x2e
  801d42:	e8 c7 f9 ff ff       	call   80170e <syscall>
  801d47:	83 c4 18             	add    $0x18,%esp
}
  801d4a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d4d:	c9                   	leave  
  801d4e:	c3                   	ret    

00801d4f <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801d4f:	55                   	push   %ebp
  801d50:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801d52:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d55:	8b 45 08             	mov    0x8(%ebp),%eax
  801d58:	6a 00                	push   $0x0
  801d5a:	6a 00                	push   $0x0
  801d5c:	6a 00                	push   $0x0
  801d5e:	52                   	push   %edx
  801d5f:	50                   	push   %eax
  801d60:	6a 2f                	push   $0x2f
  801d62:	e8 a7 f9 ff ff       	call   80170e <syscall>
  801d67:	83 c4 18             	add    $0x18,%esp
}
  801d6a:	c9                   	leave  
  801d6b:	c3                   	ret    

00801d6c <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801d6c:	55                   	push   %ebp
  801d6d:	89 e5                	mov    %esp,%ebp
  801d6f:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801d72:	83 ec 0c             	sub    $0xc,%esp
  801d75:	68 48 3f 80 00       	push   $0x803f48
  801d7a:	e8 1e e8 ff ff       	call   80059d <cprintf>
  801d7f:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801d82:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801d89:	83 ec 0c             	sub    $0xc,%esp
  801d8c:	68 74 3f 80 00       	push   $0x803f74
  801d91:	e8 07 e8 ff ff       	call   80059d <cprintf>
  801d96:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801d99:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d9d:	a1 38 51 80 00       	mov    0x805138,%eax
  801da2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801da5:	eb 56                	jmp    801dfd <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801da7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801dab:	74 1c                	je     801dc9 <print_mem_block_lists+0x5d>
  801dad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db0:	8b 50 08             	mov    0x8(%eax),%edx
  801db3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801db6:	8b 48 08             	mov    0x8(%eax),%ecx
  801db9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dbc:	8b 40 0c             	mov    0xc(%eax),%eax
  801dbf:	01 c8                	add    %ecx,%eax
  801dc1:	39 c2                	cmp    %eax,%edx
  801dc3:	73 04                	jae    801dc9 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801dc5:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801dc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dcc:	8b 50 08             	mov    0x8(%eax),%edx
  801dcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd2:	8b 40 0c             	mov    0xc(%eax),%eax
  801dd5:	01 c2                	add    %eax,%edx
  801dd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dda:	8b 40 08             	mov    0x8(%eax),%eax
  801ddd:	83 ec 04             	sub    $0x4,%esp
  801de0:	52                   	push   %edx
  801de1:	50                   	push   %eax
  801de2:	68 89 3f 80 00       	push   $0x803f89
  801de7:	e8 b1 e7 ff ff       	call   80059d <cprintf>
  801dec:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801def:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801df5:	a1 40 51 80 00       	mov    0x805140,%eax
  801dfa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dfd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e01:	74 07                	je     801e0a <print_mem_block_lists+0x9e>
  801e03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e06:	8b 00                	mov    (%eax),%eax
  801e08:	eb 05                	jmp    801e0f <print_mem_block_lists+0xa3>
  801e0a:	b8 00 00 00 00       	mov    $0x0,%eax
  801e0f:	a3 40 51 80 00       	mov    %eax,0x805140
  801e14:	a1 40 51 80 00       	mov    0x805140,%eax
  801e19:	85 c0                	test   %eax,%eax
  801e1b:	75 8a                	jne    801da7 <print_mem_block_lists+0x3b>
  801e1d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e21:	75 84                	jne    801da7 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801e23:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e27:	75 10                	jne    801e39 <print_mem_block_lists+0xcd>
  801e29:	83 ec 0c             	sub    $0xc,%esp
  801e2c:	68 98 3f 80 00       	push   $0x803f98
  801e31:	e8 67 e7 ff ff       	call   80059d <cprintf>
  801e36:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801e39:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801e40:	83 ec 0c             	sub    $0xc,%esp
  801e43:	68 bc 3f 80 00       	push   $0x803fbc
  801e48:	e8 50 e7 ff ff       	call   80059d <cprintf>
  801e4d:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801e50:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801e54:	a1 40 50 80 00       	mov    0x805040,%eax
  801e59:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e5c:	eb 56                	jmp    801eb4 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e5e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e62:	74 1c                	je     801e80 <print_mem_block_lists+0x114>
  801e64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e67:	8b 50 08             	mov    0x8(%eax),%edx
  801e6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e6d:	8b 48 08             	mov    0x8(%eax),%ecx
  801e70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e73:	8b 40 0c             	mov    0xc(%eax),%eax
  801e76:	01 c8                	add    %ecx,%eax
  801e78:	39 c2                	cmp    %eax,%edx
  801e7a:	73 04                	jae    801e80 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801e7c:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e83:	8b 50 08             	mov    0x8(%eax),%edx
  801e86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e89:	8b 40 0c             	mov    0xc(%eax),%eax
  801e8c:	01 c2                	add    %eax,%edx
  801e8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e91:	8b 40 08             	mov    0x8(%eax),%eax
  801e94:	83 ec 04             	sub    $0x4,%esp
  801e97:	52                   	push   %edx
  801e98:	50                   	push   %eax
  801e99:	68 89 3f 80 00       	push   $0x803f89
  801e9e:	e8 fa e6 ff ff       	call   80059d <cprintf>
  801ea3:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801ea6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ea9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801eac:	a1 48 50 80 00       	mov    0x805048,%eax
  801eb1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801eb4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801eb8:	74 07                	je     801ec1 <print_mem_block_lists+0x155>
  801eba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ebd:	8b 00                	mov    (%eax),%eax
  801ebf:	eb 05                	jmp    801ec6 <print_mem_block_lists+0x15a>
  801ec1:	b8 00 00 00 00       	mov    $0x0,%eax
  801ec6:	a3 48 50 80 00       	mov    %eax,0x805048
  801ecb:	a1 48 50 80 00       	mov    0x805048,%eax
  801ed0:	85 c0                	test   %eax,%eax
  801ed2:	75 8a                	jne    801e5e <print_mem_block_lists+0xf2>
  801ed4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ed8:	75 84                	jne    801e5e <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801eda:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801ede:	75 10                	jne    801ef0 <print_mem_block_lists+0x184>
  801ee0:	83 ec 0c             	sub    $0xc,%esp
  801ee3:	68 d4 3f 80 00       	push   $0x803fd4
  801ee8:	e8 b0 e6 ff ff       	call   80059d <cprintf>
  801eed:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801ef0:	83 ec 0c             	sub    $0xc,%esp
  801ef3:	68 48 3f 80 00       	push   $0x803f48
  801ef8:	e8 a0 e6 ff ff       	call   80059d <cprintf>
  801efd:	83 c4 10             	add    $0x10,%esp

}
  801f00:	90                   	nop
  801f01:	c9                   	leave  
  801f02:	c3                   	ret    

00801f03 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801f03:	55                   	push   %ebp
  801f04:	89 e5                	mov    %esp,%ebp
  801f06:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801f09:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  801f10:	00 00 00 
  801f13:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  801f1a:	00 00 00 
  801f1d:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  801f24:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801f27:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801f2e:	e9 9e 00 00 00       	jmp    801fd1 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801f33:	a1 50 50 80 00       	mov    0x805050,%eax
  801f38:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f3b:	c1 e2 04             	shl    $0x4,%edx
  801f3e:	01 d0                	add    %edx,%eax
  801f40:	85 c0                	test   %eax,%eax
  801f42:	75 14                	jne    801f58 <initialize_MemBlocksList+0x55>
  801f44:	83 ec 04             	sub    $0x4,%esp
  801f47:	68 fc 3f 80 00       	push   $0x803ffc
  801f4c:	6a 46                	push   $0x46
  801f4e:	68 1f 40 80 00       	push   $0x80401f
  801f53:	e8 91 e3 ff ff       	call   8002e9 <_panic>
  801f58:	a1 50 50 80 00       	mov    0x805050,%eax
  801f5d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f60:	c1 e2 04             	shl    $0x4,%edx
  801f63:	01 d0                	add    %edx,%eax
  801f65:	8b 15 48 51 80 00    	mov    0x805148,%edx
  801f6b:	89 10                	mov    %edx,(%eax)
  801f6d:	8b 00                	mov    (%eax),%eax
  801f6f:	85 c0                	test   %eax,%eax
  801f71:	74 18                	je     801f8b <initialize_MemBlocksList+0x88>
  801f73:	a1 48 51 80 00       	mov    0x805148,%eax
  801f78:	8b 15 50 50 80 00    	mov    0x805050,%edx
  801f7e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801f81:	c1 e1 04             	shl    $0x4,%ecx
  801f84:	01 ca                	add    %ecx,%edx
  801f86:	89 50 04             	mov    %edx,0x4(%eax)
  801f89:	eb 12                	jmp    801f9d <initialize_MemBlocksList+0x9a>
  801f8b:	a1 50 50 80 00       	mov    0x805050,%eax
  801f90:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f93:	c1 e2 04             	shl    $0x4,%edx
  801f96:	01 d0                	add    %edx,%eax
  801f98:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801f9d:	a1 50 50 80 00       	mov    0x805050,%eax
  801fa2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fa5:	c1 e2 04             	shl    $0x4,%edx
  801fa8:	01 d0                	add    %edx,%eax
  801faa:	a3 48 51 80 00       	mov    %eax,0x805148
  801faf:	a1 50 50 80 00       	mov    0x805050,%eax
  801fb4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fb7:	c1 e2 04             	shl    $0x4,%edx
  801fba:	01 d0                	add    %edx,%eax
  801fbc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801fc3:	a1 54 51 80 00       	mov    0x805154,%eax
  801fc8:	40                   	inc    %eax
  801fc9:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801fce:	ff 45 f4             	incl   -0xc(%ebp)
  801fd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd4:	3b 45 08             	cmp    0x8(%ebp),%eax
  801fd7:	0f 82 56 ff ff ff    	jb     801f33 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801fdd:	90                   	nop
  801fde:	c9                   	leave  
  801fdf:	c3                   	ret    

00801fe0 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801fe0:	55                   	push   %ebp
  801fe1:	89 e5                	mov    %esp,%ebp
  801fe3:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801fe6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe9:	8b 00                	mov    (%eax),%eax
  801feb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801fee:	eb 19                	jmp    802009 <find_block+0x29>
	{
		if(va==point->sva)
  801ff0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ff3:	8b 40 08             	mov    0x8(%eax),%eax
  801ff6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801ff9:	75 05                	jne    802000 <find_block+0x20>
		   return point;
  801ffb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ffe:	eb 36                	jmp    802036 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802000:	8b 45 08             	mov    0x8(%ebp),%eax
  802003:	8b 40 08             	mov    0x8(%eax),%eax
  802006:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802009:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80200d:	74 07                	je     802016 <find_block+0x36>
  80200f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802012:	8b 00                	mov    (%eax),%eax
  802014:	eb 05                	jmp    80201b <find_block+0x3b>
  802016:	b8 00 00 00 00       	mov    $0x0,%eax
  80201b:	8b 55 08             	mov    0x8(%ebp),%edx
  80201e:	89 42 08             	mov    %eax,0x8(%edx)
  802021:	8b 45 08             	mov    0x8(%ebp),%eax
  802024:	8b 40 08             	mov    0x8(%eax),%eax
  802027:	85 c0                	test   %eax,%eax
  802029:	75 c5                	jne    801ff0 <find_block+0x10>
  80202b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80202f:	75 bf                	jne    801ff0 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802031:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802036:	c9                   	leave  
  802037:	c3                   	ret    

00802038 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802038:	55                   	push   %ebp
  802039:	89 e5                	mov    %esp,%ebp
  80203b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  80203e:	a1 40 50 80 00       	mov    0x805040,%eax
  802043:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802046:	a1 44 50 80 00       	mov    0x805044,%eax
  80204b:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  80204e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802051:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802054:	74 24                	je     80207a <insert_sorted_allocList+0x42>
  802056:	8b 45 08             	mov    0x8(%ebp),%eax
  802059:	8b 50 08             	mov    0x8(%eax),%edx
  80205c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80205f:	8b 40 08             	mov    0x8(%eax),%eax
  802062:	39 c2                	cmp    %eax,%edx
  802064:	76 14                	jbe    80207a <insert_sorted_allocList+0x42>
  802066:	8b 45 08             	mov    0x8(%ebp),%eax
  802069:	8b 50 08             	mov    0x8(%eax),%edx
  80206c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80206f:	8b 40 08             	mov    0x8(%eax),%eax
  802072:	39 c2                	cmp    %eax,%edx
  802074:	0f 82 60 01 00 00    	jb     8021da <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  80207a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80207e:	75 65                	jne    8020e5 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802080:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802084:	75 14                	jne    80209a <insert_sorted_allocList+0x62>
  802086:	83 ec 04             	sub    $0x4,%esp
  802089:	68 fc 3f 80 00       	push   $0x803ffc
  80208e:	6a 6b                	push   $0x6b
  802090:	68 1f 40 80 00       	push   $0x80401f
  802095:	e8 4f e2 ff ff       	call   8002e9 <_panic>
  80209a:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8020a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a3:	89 10                	mov    %edx,(%eax)
  8020a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a8:	8b 00                	mov    (%eax),%eax
  8020aa:	85 c0                	test   %eax,%eax
  8020ac:	74 0d                	je     8020bb <insert_sorted_allocList+0x83>
  8020ae:	a1 40 50 80 00       	mov    0x805040,%eax
  8020b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8020b6:	89 50 04             	mov    %edx,0x4(%eax)
  8020b9:	eb 08                	jmp    8020c3 <insert_sorted_allocList+0x8b>
  8020bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020be:	a3 44 50 80 00       	mov    %eax,0x805044
  8020c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c6:	a3 40 50 80 00       	mov    %eax,0x805040
  8020cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ce:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020d5:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8020da:	40                   	inc    %eax
  8020db:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8020e0:	e9 dc 01 00 00       	jmp    8022c1 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8020e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e8:	8b 50 08             	mov    0x8(%eax),%edx
  8020eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020ee:	8b 40 08             	mov    0x8(%eax),%eax
  8020f1:	39 c2                	cmp    %eax,%edx
  8020f3:	77 6c                	ja     802161 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8020f5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020f9:	74 06                	je     802101 <insert_sorted_allocList+0xc9>
  8020fb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020ff:	75 14                	jne    802115 <insert_sorted_allocList+0xdd>
  802101:	83 ec 04             	sub    $0x4,%esp
  802104:	68 38 40 80 00       	push   $0x804038
  802109:	6a 6f                	push   $0x6f
  80210b:	68 1f 40 80 00       	push   $0x80401f
  802110:	e8 d4 e1 ff ff       	call   8002e9 <_panic>
  802115:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802118:	8b 50 04             	mov    0x4(%eax),%edx
  80211b:	8b 45 08             	mov    0x8(%ebp),%eax
  80211e:	89 50 04             	mov    %edx,0x4(%eax)
  802121:	8b 45 08             	mov    0x8(%ebp),%eax
  802124:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802127:	89 10                	mov    %edx,(%eax)
  802129:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80212c:	8b 40 04             	mov    0x4(%eax),%eax
  80212f:	85 c0                	test   %eax,%eax
  802131:	74 0d                	je     802140 <insert_sorted_allocList+0x108>
  802133:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802136:	8b 40 04             	mov    0x4(%eax),%eax
  802139:	8b 55 08             	mov    0x8(%ebp),%edx
  80213c:	89 10                	mov    %edx,(%eax)
  80213e:	eb 08                	jmp    802148 <insert_sorted_allocList+0x110>
  802140:	8b 45 08             	mov    0x8(%ebp),%eax
  802143:	a3 40 50 80 00       	mov    %eax,0x805040
  802148:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80214b:	8b 55 08             	mov    0x8(%ebp),%edx
  80214e:	89 50 04             	mov    %edx,0x4(%eax)
  802151:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802156:	40                   	inc    %eax
  802157:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80215c:	e9 60 01 00 00       	jmp    8022c1 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802161:	8b 45 08             	mov    0x8(%ebp),%eax
  802164:	8b 50 08             	mov    0x8(%eax),%edx
  802167:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80216a:	8b 40 08             	mov    0x8(%eax),%eax
  80216d:	39 c2                	cmp    %eax,%edx
  80216f:	0f 82 4c 01 00 00    	jb     8022c1 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802175:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802179:	75 14                	jne    80218f <insert_sorted_allocList+0x157>
  80217b:	83 ec 04             	sub    $0x4,%esp
  80217e:	68 70 40 80 00       	push   $0x804070
  802183:	6a 73                	push   $0x73
  802185:	68 1f 40 80 00       	push   $0x80401f
  80218a:	e8 5a e1 ff ff       	call   8002e9 <_panic>
  80218f:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802195:	8b 45 08             	mov    0x8(%ebp),%eax
  802198:	89 50 04             	mov    %edx,0x4(%eax)
  80219b:	8b 45 08             	mov    0x8(%ebp),%eax
  80219e:	8b 40 04             	mov    0x4(%eax),%eax
  8021a1:	85 c0                	test   %eax,%eax
  8021a3:	74 0c                	je     8021b1 <insert_sorted_allocList+0x179>
  8021a5:	a1 44 50 80 00       	mov    0x805044,%eax
  8021aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8021ad:	89 10                	mov    %edx,(%eax)
  8021af:	eb 08                	jmp    8021b9 <insert_sorted_allocList+0x181>
  8021b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b4:	a3 40 50 80 00       	mov    %eax,0x805040
  8021b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bc:	a3 44 50 80 00       	mov    %eax,0x805044
  8021c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021ca:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8021cf:	40                   	inc    %eax
  8021d0:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8021d5:	e9 e7 00 00 00       	jmp    8022c1 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8021da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8021e0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8021e7:	a1 40 50 80 00       	mov    0x805040,%eax
  8021ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021ef:	e9 9d 00 00 00       	jmp    802291 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8021f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f7:	8b 00                	mov    (%eax),%eax
  8021f9:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8021fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ff:	8b 50 08             	mov    0x8(%eax),%edx
  802202:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802205:	8b 40 08             	mov    0x8(%eax),%eax
  802208:	39 c2                	cmp    %eax,%edx
  80220a:	76 7d                	jbe    802289 <insert_sorted_allocList+0x251>
  80220c:	8b 45 08             	mov    0x8(%ebp),%eax
  80220f:	8b 50 08             	mov    0x8(%eax),%edx
  802212:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802215:	8b 40 08             	mov    0x8(%eax),%eax
  802218:	39 c2                	cmp    %eax,%edx
  80221a:	73 6d                	jae    802289 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  80221c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802220:	74 06                	je     802228 <insert_sorted_allocList+0x1f0>
  802222:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802226:	75 14                	jne    80223c <insert_sorted_allocList+0x204>
  802228:	83 ec 04             	sub    $0x4,%esp
  80222b:	68 94 40 80 00       	push   $0x804094
  802230:	6a 7f                	push   $0x7f
  802232:	68 1f 40 80 00       	push   $0x80401f
  802237:	e8 ad e0 ff ff       	call   8002e9 <_panic>
  80223c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223f:	8b 10                	mov    (%eax),%edx
  802241:	8b 45 08             	mov    0x8(%ebp),%eax
  802244:	89 10                	mov    %edx,(%eax)
  802246:	8b 45 08             	mov    0x8(%ebp),%eax
  802249:	8b 00                	mov    (%eax),%eax
  80224b:	85 c0                	test   %eax,%eax
  80224d:	74 0b                	je     80225a <insert_sorted_allocList+0x222>
  80224f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802252:	8b 00                	mov    (%eax),%eax
  802254:	8b 55 08             	mov    0x8(%ebp),%edx
  802257:	89 50 04             	mov    %edx,0x4(%eax)
  80225a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225d:	8b 55 08             	mov    0x8(%ebp),%edx
  802260:	89 10                	mov    %edx,(%eax)
  802262:	8b 45 08             	mov    0x8(%ebp),%eax
  802265:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802268:	89 50 04             	mov    %edx,0x4(%eax)
  80226b:	8b 45 08             	mov    0x8(%ebp),%eax
  80226e:	8b 00                	mov    (%eax),%eax
  802270:	85 c0                	test   %eax,%eax
  802272:	75 08                	jne    80227c <insert_sorted_allocList+0x244>
  802274:	8b 45 08             	mov    0x8(%ebp),%eax
  802277:	a3 44 50 80 00       	mov    %eax,0x805044
  80227c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802281:	40                   	inc    %eax
  802282:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802287:	eb 39                	jmp    8022c2 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802289:	a1 48 50 80 00       	mov    0x805048,%eax
  80228e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802291:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802295:	74 07                	je     80229e <insert_sorted_allocList+0x266>
  802297:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229a:	8b 00                	mov    (%eax),%eax
  80229c:	eb 05                	jmp    8022a3 <insert_sorted_allocList+0x26b>
  80229e:	b8 00 00 00 00       	mov    $0x0,%eax
  8022a3:	a3 48 50 80 00       	mov    %eax,0x805048
  8022a8:	a1 48 50 80 00       	mov    0x805048,%eax
  8022ad:	85 c0                	test   %eax,%eax
  8022af:	0f 85 3f ff ff ff    	jne    8021f4 <insert_sorted_allocList+0x1bc>
  8022b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022b9:	0f 85 35 ff ff ff    	jne    8021f4 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8022bf:	eb 01                	jmp    8022c2 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8022c1:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8022c2:	90                   	nop
  8022c3:	c9                   	leave  
  8022c4:	c3                   	ret    

008022c5 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8022c5:	55                   	push   %ebp
  8022c6:	89 e5                	mov    %esp,%ebp
  8022c8:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8022cb:	a1 38 51 80 00       	mov    0x805138,%eax
  8022d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022d3:	e9 85 01 00 00       	jmp    80245d <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8022d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022db:	8b 40 0c             	mov    0xc(%eax),%eax
  8022de:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022e1:	0f 82 6e 01 00 00    	jb     802455 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8022e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ea:	8b 40 0c             	mov    0xc(%eax),%eax
  8022ed:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022f0:	0f 85 8a 00 00 00    	jne    802380 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8022f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022fa:	75 17                	jne    802313 <alloc_block_FF+0x4e>
  8022fc:	83 ec 04             	sub    $0x4,%esp
  8022ff:	68 c8 40 80 00       	push   $0x8040c8
  802304:	68 93 00 00 00       	push   $0x93
  802309:	68 1f 40 80 00       	push   $0x80401f
  80230e:	e8 d6 df ff ff       	call   8002e9 <_panic>
  802313:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802316:	8b 00                	mov    (%eax),%eax
  802318:	85 c0                	test   %eax,%eax
  80231a:	74 10                	je     80232c <alloc_block_FF+0x67>
  80231c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231f:	8b 00                	mov    (%eax),%eax
  802321:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802324:	8b 52 04             	mov    0x4(%edx),%edx
  802327:	89 50 04             	mov    %edx,0x4(%eax)
  80232a:	eb 0b                	jmp    802337 <alloc_block_FF+0x72>
  80232c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232f:	8b 40 04             	mov    0x4(%eax),%eax
  802332:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802337:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233a:	8b 40 04             	mov    0x4(%eax),%eax
  80233d:	85 c0                	test   %eax,%eax
  80233f:	74 0f                	je     802350 <alloc_block_FF+0x8b>
  802341:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802344:	8b 40 04             	mov    0x4(%eax),%eax
  802347:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80234a:	8b 12                	mov    (%edx),%edx
  80234c:	89 10                	mov    %edx,(%eax)
  80234e:	eb 0a                	jmp    80235a <alloc_block_FF+0x95>
  802350:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802353:	8b 00                	mov    (%eax),%eax
  802355:	a3 38 51 80 00       	mov    %eax,0x805138
  80235a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802363:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802366:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80236d:	a1 44 51 80 00       	mov    0x805144,%eax
  802372:	48                   	dec    %eax
  802373:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802378:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237b:	e9 10 01 00 00       	jmp    802490 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802380:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802383:	8b 40 0c             	mov    0xc(%eax),%eax
  802386:	3b 45 08             	cmp    0x8(%ebp),%eax
  802389:	0f 86 c6 00 00 00    	jbe    802455 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80238f:	a1 48 51 80 00       	mov    0x805148,%eax
  802394:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802397:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239a:	8b 50 08             	mov    0x8(%eax),%edx
  80239d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023a0:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8023a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8023a9:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8023ac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023b0:	75 17                	jne    8023c9 <alloc_block_FF+0x104>
  8023b2:	83 ec 04             	sub    $0x4,%esp
  8023b5:	68 c8 40 80 00       	push   $0x8040c8
  8023ba:	68 9b 00 00 00       	push   $0x9b
  8023bf:	68 1f 40 80 00       	push   $0x80401f
  8023c4:	e8 20 df ff ff       	call   8002e9 <_panic>
  8023c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023cc:	8b 00                	mov    (%eax),%eax
  8023ce:	85 c0                	test   %eax,%eax
  8023d0:	74 10                	je     8023e2 <alloc_block_FF+0x11d>
  8023d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023d5:	8b 00                	mov    (%eax),%eax
  8023d7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023da:	8b 52 04             	mov    0x4(%edx),%edx
  8023dd:	89 50 04             	mov    %edx,0x4(%eax)
  8023e0:	eb 0b                	jmp    8023ed <alloc_block_FF+0x128>
  8023e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023e5:	8b 40 04             	mov    0x4(%eax),%eax
  8023e8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8023ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023f0:	8b 40 04             	mov    0x4(%eax),%eax
  8023f3:	85 c0                	test   %eax,%eax
  8023f5:	74 0f                	je     802406 <alloc_block_FF+0x141>
  8023f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023fa:	8b 40 04             	mov    0x4(%eax),%eax
  8023fd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802400:	8b 12                	mov    (%edx),%edx
  802402:	89 10                	mov    %edx,(%eax)
  802404:	eb 0a                	jmp    802410 <alloc_block_FF+0x14b>
  802406:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802409:	8b 00                	mov    (%eax),%eax
  80240b:	a3 48 51 80 00       	mov    %eax,0x805148
  802410:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802413:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802419:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80241c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802423:	a1 54 51 80 00       	mov    0x805154,%eax
  802428:	48                   	dec    %eax
  802429:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  80242e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802431:	8b 50 08             	mov    0x8(%eax),%edx
  802434:	8b 45 08             	mov    0x8(%ebp),%eax
  802437:	01 c2                	add    %eax,%edx
  802439:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243c:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  80243f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802442:	8b 40 0c             	mov    0xc(%eax),%eax
  802445:	2b 45 08             	sub    0x8(%ebp),%eax
  802448:	89 c2                	mov    %eax,%edx
  80244a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244d:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802450:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802453:	eb 3b                	jmp    802490 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802455:	a1 40 51 80 00       	mov    0x805140,%eax
  80245a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80245d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802461:	74 07                	je     80246a <alloc_block_FF+0x1a5>
  802463:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802466:	8b 00                	mov    (%eax),%eax
  802468:	eb 05                	jmp    80246f <alloc_block_FF+0x1aa>
  80246a:	b8 00 00 00 00       	mov    $0x0,%eax
  80246f:	a3 40 51 80 00       	mov    %eax,0x805140
  802474:	a1 40 51 80 00       	mov    0x805140,%eax
  802479:	85 c0                	test   %eax,%eax
  80247b:	0f 85 57 fe ff ff    	jne    8022d8 <alloc_block_FF+0x13>
  802481:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802485:	0f 85 4d fe ff ff    	jne    8022d8 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  80248b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802490:	c9                   	leave  
  802491:	c3                   	ret    

00802492 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802492:	55                   	push   %ebp
  802493:	89 e5                	mov    %esp,%ebp
  802495:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802498:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80249f:	a1 38 51 80 00       	mov    0x805138,%eax
  8024a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024a7:	e9 df 00 00 00       	jmp    80258b <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8024ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024af:	8b 40 0c             	mov    0xc(%eax),%eax
  8024b2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024b5:	0f 82 c8 00 00 00    	jb     802583 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8024bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024be:	8b 40 0c             	mov    0xc(%eax),%eax
  8024c1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024c4:	0f 85 8a 00 00 00    	jne    802554 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8024ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024ce:	75 17                	jne    8024e7 <alloc_block_BF+0x55>
  8024d0:	83 ec 04             	sub    $0x4,%esp
  8024d3:	68 c8 40 80 00       	push   $0x8040c8
  8024d8:	68 b7 00 00 00       	push   $0xb7
  8024dd:	68 1f 40 80 00       	push   $0x80401f
  8024e2:	e8 02 de ff ff       	call   8002e9 <_panic>
  8024e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ea:	8b 00                	mov    (%eax),%eax
  8024ec:	85 c0                	test   %eax,%eax
  8024ee:	74 10                	je     802500 <alloc_block_BF+0x6e>
  8024f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f3:	8b 00                	mov    (%eax),%eax
  8024f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024f8:	8b 52 04             	mov    0x4(%edx),%edx
  8024fb:	89 50 04             	mov    %edx,0x4(%eax)
  8024fe:	eb 0b                	jmp    80250b <alloc_block_BF+0x79>
  802500:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802503:	8b 40 04             	mov    0x4(%eax),%eax
  802506:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80250b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250e:	8b 40 04             	mov    0x4(%eax),%eax
  802511:	85 c0                	test   %eax,%eax
  802513:	74 0f                	je     802524 <alloc_block_BF+0x92>
  802515:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802518:	8b 40 04             	mov    0x4(%eax),%eax
  80251b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80251e:	8b 12                	mov    (%edx),%edx
  802520:	89 10                	mov    %edx,(%eax)
  802522:	eb 0a                	jmp    80252e <alloc_block_BF+0x9c>
  802524:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802527:	8b 00                	mov    (%eax),%eax
  802529:	a3 38 51 80 00       	mov    %eax,0x805138
  80252e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802531:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802537:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802541:	a1 44 51 80 00       	mov    0x805144,%eax
  802546:	48                   	dec    %eax
  802547:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  80254c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254f:	e9 4d 01 00 00       	jmp    8026a1 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802554:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802557:	8b 40 0c             	mov    0xc(%eax),%eax
  80255a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80255d:	76 24                	jbe    802583 <alloc_block_BF+0xf1>
  80255f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802562:	8b 40 0c             	mov    0xc(%eax),%eax
  802565:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802568:	73 19                	jae    802583 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  80256a:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802571:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802574:	8b 40 0c             	mov    0xc(%eax),%eax
  802577:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  80257a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257d:	8b 40 08             	mov    0x8(%eax),%eax
  802580:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802583:	a1 40 51 80 00       	mov    0x805140,%eax
  802588:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80258b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80258f:	74 07                	je     802598 <alloc_block_BF+0x106>
  802591:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802594:	8b 00                	mov    (%eax),%eax
  802596:	eb 05                	jmp    80259d <alloc_block_BF+0x10b>
  802598:	b8 00 00 00 00       	mov    $0x0,%eax
  80259d:	a3 40 51 80 00       	mov    %eax,0x805140
  8025a2:	a1 40 51 80 00       	mov    0x805140,%eax
  8025a7:	85 c0                	test   %eax,%eax
  8025a9:	0f 85 fd fe ff ff    	jne    8024ac <alloc_block_BF+0x1a>
  8025af:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025b3:	0f 85 f3 fe ff ff    	jne    8024ac <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8025b9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8025bd:	0f 84 d9 00 00 00    	je     80269c <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8025c3:	a1 48 51 80 00       	mov    0x805148,%eax
  8025c8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8025cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025ce:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025d1:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8025d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8025da:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8025dd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8025e1:	75 17                	jne    8025fa <alloc_block_BF+0x168>
  8025e3:	83 ec 04             	sub    $0x4,%esp
  8025e6:	68 c8 40 80 00       	push   $0x8040c8
  8025eb:	68 c7 00 00 00       	push   $0xc7
  8025f0:	68 1f 40 80 00       	push   $0x80401f
  8025f5:	e8 ef dc ff ff       	call   8002e9 <_panic>
  8025fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025fd:	8b 00                	mov    (%eax),%eax
  8025ff:	85 c0                	test   %eax,%eax
  802601:	74 10                	je     802613 <alloc_block_BF+0x181>
  802603:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802606:	8b 00                	mov    (%eax),%eax
  802608:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80260b:	8b 52 04             	mov    0x4(%edx),%edx
  80260e:	89 50 04             	mov    %edx,0x4(%eax)
  802611:	eb 0b                	jmp    80261e <alloc_block_BF+0x18c>
  802613:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802616:	8b 40 04             	mov    0x4(%eax),%eax
  802619:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80261e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802621:	8b 40 04             	mov    0x4(%eax),%eax
  802624:	85 c0                	test   %eax,%eax
  802626:	74 0f                	je     802637 <alloc_block_BF+0x1a5>
  802628:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80262b:	8b 40 04             	mov    0x4(%eax),%eax
  80262e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802631:	8b 12                	mov    (%edx),%edx
  802633:	89 10                	mov    %edx,(%eax)
  802635:	eb 0a                	jmp    802641 <alloc_block_BF+0x1af>
  802637:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80263a:	8b 00                	mov    (%eax),%eax
  80263c:	a3 48 51 80 00       	mov    %eax,0x805148
  802641:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802644:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80264a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80264d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802654:	a1 54 51 80 00       	mov    0x805154,%eax
  802659:	48                   	dec    %eax
  80265a:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  80265f:	83 ec 08             	sub    $0x8,%esp
  802662:	ff 75 ec             	pushl  -0x14(%ebp)
  802665:	68 38 51 80 00       	push   $0x805138
  80266a:	e8 71 f9 ff ff       	call   801fe0 <find_block>
  80266f:	83 c4 10             	add    $0x10,%esp
  802672:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802675:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802678:	8b 50 08             	mov    0x8(%eax),%edx
  80267b:	8b 45 08             	mov    0x8(%ebp),%eax
  80267e:	01 c2                	add    %eax,%edx
  802680:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802683:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802686:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802689:	8b 40 0c             	mov    0xc(%eax),%eax
  80268c:	2b 45 08             	sub    0x8(%ebp),%eax
  80268f:	89 c2                	mov    %eax,%edx
  802691:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802694:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802697:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80269a:	eb 05                	jmp    8026a1 <alloc_block_BF+0x20f>
	}
	return NULL;
  80269c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026a1:	c9                   	leave  
  8026a2:	c3                   	ret    

008026a3 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8026a3:	55                   	push   %ebp
  8026a4:	89 e5                	mov    %esp,%ebp
  8026a6:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8026a9:	a1 28 50 80 00       	mov    0x805028,%eax
  8026ae:	85 c0                	test   %eax,%eax
  8026b0:	0f 85 de 01 00 00    	jne    802894 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8026b6:	a1 38 51 80 00       	mov    0x805138,%eax
  8026bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026be:	e9 9e 01 00 00       	jmp    802861 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8026c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c6:	8b 40 0c             	mov    0xc(%eax),%eax
  8026c9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026cc:	0f 82 87 01 00 00    	jb     802859 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8026d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d5:	8b 40 0c             	mov    0xc(%eax),%eax
  8026d8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026db:	0f 85 95 00 00 00    	jne    802776 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8026e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026e5:	75 17                	jne    8026fe <alloc_block_NF+0x5b>
  8026e7:	83 ec 04             	sub    $0x4,%esp
  8026ea:	68 c8 40 80 00       	push   $0x8040c8
  8026ef:	68 e0 00 00 00       	push   $0xe0
  8026f4:	68 1f 40 80 00       	push   $0x80401f
  8026f9:	e8 eb db ff ff       	call   8002e9 <_panic>
  8026fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802701:	8b 00                	mov    (%eax),%eax
  802703:	85 c0                	test   %eax,%eax
  802705:	74 10                	je     802717 <alloc_block_NF+0x74>
  802707:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270a:	8b 00                	mov    (%eax),%eax
  80270c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80270f:	8b 52 04             	mov    0x4(%edx),%edx
  802712:	89 50 04             	mov    %edx,0x4(%eax)
  802715:	eb 0b                	jmp    802722 <alloc_block_NF+0x7f>
  802717:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271a:	8b 40 04             	mov    0x4(%eax),%eax
  80271d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802722:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802725:	8b 40 04             	mov    0x4(%eax),%eax
  802728:	85 c0                	test   %eax,%eax
  80272a:	74 0f                	je     80273b <alloc_block_NF+0x98>
  80272c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272f:	8b 40 04             	mov    0x4(%eax),%eax
  802732:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802735:	8b 12                	mov    (%edx),%edx
  802737:	89 10                	mov    %edx,(%eax)
  802739:	eb 0a                	jmp    802745 <alloc_block_NF+0xa2>
  80273b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273e:	8b 00                	mov    (%eax),%eax
  802740:	a3 38 51 80 00       	mov    %eax,0x805138
  802745:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802748:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80274e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802751:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802758:	a1 44 51 80 00       	mov    0x805144,%eax
  80275d:	48                   	dec    %eax
  80275e:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802763:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802766:	8b 40 08             	mov    0x8(%eax),%eax
  802769:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  80276e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802771:	e9 f8 04 00 00       	jmp    802c6e <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802776:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802779:	8b 40 0c             	mov    0xc(%eax),%eax
  80277c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80277f:	0f 86 d4 00 00 00    	jbe    802859 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802785:	a1 48 51 80 00       	mov    0x805148,%eax
  80278a:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  80278d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802790:	8b 50 08             	mov    0x8(%eax),%edx
  802793:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802796:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802799:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80279c:	8b 55 08             	mov    0x8(%ebp),%edx
  80279f:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8027a2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027a6:	75 17                	jne    8027bf <alloc_block_NF+0x11c>
  8027a8:	83 ec 04             	sub    $0x4,%esp
  8027ab:	68 c8 40 80 00       	push   $0x8040c8
  8027b0:	68 e9 00 00 00       	push   $0xe9
  8027b5:	68 1f 40 80 00       	push   $0x80401f
  8027ba:	e8 2a db ff ff       	call   8002e9 <_panic>
  8027bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c2:	8b 00                	mov    (%eax),%eax
  8027c4:	85 c0                	test   %eax,%eax
  8027c6:	74 10                	je     8027d8 <alloc_block_NF+0x135>
  8027c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027cb:	8b 00                	mov    (%eax),%eax
  8027cd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027d0:	8b 52 04             	mov    0x4(%edx),%edx
  8027d3:	89 50 04             	mov    %edx,0x4(%eax)
  8027d6:	eb 0b                	jmp    8027e3 <alloc_block_NF+0x140>
  8027d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027db:	8b 40 04             	mov    0x4(%eax),%eax
  8027de:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8027e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e6:	8b 40 04             	mov    0x4(%eax),%eax
  8027e9:	85 c0                	test   %eax,%eax
  8027eb:	74 0f                	je     8027fc <alloc_block_NF+0x159>
  8027ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f0:	8b 40 04             	mov    0x4(%eax),%eax
  8027f3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027f6:	8b 12                	mov    (%edx),%edx
  8027f8:	89 10                	mov    %edx,(%eax)
  8027fa:	eb 0a                	jmp    802806 <alloc_block_NF+0x163>
  8027fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ff:	8b 00                	mov    (%eax),%eax
  802801:	a3 48 51 80 00       	mov    %eax,0x805148
  802806:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802809:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80280f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802812:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802819:	a1 54 51 80 00       	mov    0x805154,%eax
  80281e:	48                   	dec    %eax
  80281f:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802824:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802827:	8b 40 08             	mov    0x8(%eax),%eax
  80282a:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  80282f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802832:	8b 50 08             	mov    0x8(%eax),%edx
  802835:	8b 45 08             	mov    0x8(%ebp),%eax
  802838:	01 c2                	add    %eax,%edx
  80283a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283d:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802840:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802843:	8b 40 0c             	mov    0xc(%eax),%eax
  802846:	2b 45 08             	sub    0x8(%ebp),%eax
  802849:	89 c2                	mov    %eax,%edx
  80284b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284e:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802851:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802854:	e9 15 04 00 00       	jmp    802c6e <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802859:	a1 40 51 80 00       	mov    0x805140,%eax
  80285e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802861:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802865:	74 07                	je     80286e <alloc_block_NF+0x1cb>
  802867:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286a:	8b 00                	mov    (%eax),%eax
  80286c:	eb 05                	jmp    802873 <alloc_block_NF+0x1d0>
  80286e:	b8 00 00 00 00       	mov    $0x0,%eax
  802873:	a3 40 51 80 00       	mov    %eax,0x805140
  802878:	a1 40 51 80 00       	mov    0x805140,%eax
  80287d:	85 c0                	test   %eax,%eax
  80287f:	0f 85 3e fe ff ff    	jne    8026c3 <alloc_block_NF+0x20>
  802885:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802889:	0f 85 34 fe ff ff    	jne    8026c3 <alloc_block_NF+0x20>
  80288f:	e9 d5 03 00 00       	jmp    802c69 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802894:	a1 38 51 80 00       	mov    0x805138,%eax
  802899:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80289c:	e9 b1 01 00 00       	jmp    802a52 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8028a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a4:	8b 50 08             	mov    0x8(%eax),%edx
  8028a7:	a1 28 50 80 00       	mov    0x805028,%eax
  8028ac:	39 c2                	cmp    %eax,%edx
  8028ae:	0f 82 96 01 00 00    	jb     802a4a <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  8028b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b7:	8b 40 0c             	mov    0xc(%eax),%eax
  8028ba:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028bd:	0f 82 87 01 00 00    	jb     802a4a <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  8028c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c6:	8b 40 0c             	mov    0xc(%eax),%eax
  8028c9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028cc:	0f 85 95 00 00 00    	jne    802967 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8028d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028d6:	75 17                	jne    8028ef <alloc_block_NF+0x24c>
  8028d8:	83 ec 04             	sub    $0x4,%esp
  8028db:	68 c8 40 80 00       	push   $0x8040c8
  8028e0:	68 fc 00 00 00       	push   $0xfc
  8028e5:	68 1f 40 80 00       	push   $0x80401f
  8028ea:	e8 fa d9 ff ff       	call   8002e9 <_panic>
  8028ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f2:	8b 00                	mov    (%eax),%eax
  8028f4:	85 c0                	test   %eax,%eax
  8028f6:	74 10                	je     802908 <alloc_block_NF+0x265>
  8028f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fb:	8b 00                	mov    (%eax),%eax
  8028fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802900:	8b 52 04             	mov    0x4(%edx),%edx
  802903:	89 50 04             	mov    %edx,0x4(%eax)
  802906:	eb 0b                	jmp    802913 <alloc_block_NF+0x270>
  802908:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290b:	8b 40 04             	mov    0x4(%eax),%eax
  80290e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802913:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802916:	8b 40 04             	mov    0x4(%eax),%eax
  802919:	85 c0                	test   %eax,%eax
  80291b:	74 0f                	je     80292c <alloc_block_NF+0x289>
  80291d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802920:	8b 40 04             	mov    0x4(%eax),%eax
  802923:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802926:	8b 12                	mov    (%edx),%edx
  802928:	89 10                	mov    %edx,(%eax)
  80292a:	eb 0a                	jmp    802936 <alloc_block_NF+0x293>
  80292c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292f:	8b 00                	mov    (%eax),%eax
  802931:	a3 38 51 80 00       	mov    %eax,0x805138
  802936:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802939:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80293f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802942:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802949:	a1 44 51 80 00       	mov    0x805144,%eax
  80294e:	48                   	dec    %eax
  80294f:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802954:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802957:	8b 40 08             	mov    0x8(%eax),%eax
  80295a:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  80295f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802962:	e9 07 03 00 00       	jmp    802c6e <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802967:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296a:	8b 40 0c             	mov    0xc(%eax),%eax
  80296d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802970:	0f 86 d4 00 00 00    	jbe    802a4a <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802976:	a1 48 51 80 00       	mov    0x805148,%eax
  80297b:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  80297e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802981:	8b 50 08             	mov    0x8(%eax),%edx
  802984:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802987:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  80298a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80298d:	8b 55 08             	mov    0x8(%ebp),%edx
  802990:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802993:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802997:	75 17                	jne    8029b0 <alloc_block_NF+0x30d>
  802999:	83 ec 04             	sub    $0x4,%esp
  80299c:	68 c8 40 80 00       	push   $0x8040c8
  8029a1:	68 04 01 00 00       	push   $0x104
  8029a6:	68 1f 40 80 00       	push   $0x80401f
  8029ab:	e8 39 d9 ff ff       	call   8002e9 <_panic>
  8029b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029b3:	8b 00                	mov    (%eax),%eax
  8029b5:	85 c0                	test   %eax,%eax
  8029b7:	74 10                	je     8029c9 <alloc_block_NF+0x326>
  8029b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029bc:	8b 00                	mov    (%eax),%eax
  8029be:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8029c1:	8b 52 04             	mov    0x4(%edx),%edx
  8029c4:	89 50 04             	mov    %edx,0x4(%eax)
  8029c7:	eb 0b                	jmp    8029d4 <alloc_block_NF+0x331>
  8029c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029cc:	8b 40 04             	mov    0x4(%eax),%eax
  8029cf:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8029d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029d7:	8b 40 04             	mov    0x4(%eax),%eax
  8029da:	85 c0                	test   %eax,%eax
  8029dc:	74 0f                	je     8029ed <alloc_block_NF+0x34a>
  8029de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029e1:	8b 40 04             	mov    0x4(%eax),%eax
  8029e4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8029e7:	8b 12                	mov    (%edx),%edx
  8029e9:	89 10                	mov    %edx,(%eax)
  8029eb:	eb 0a                	jmp    8029f7 <alloc_block_NF+0x354>
  8029ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029f0:	8b 00                	mov    (%eax),%eax
  8029f2:	a3 48 51 80 00       	mov    %eax,0x805148
  8029f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029fa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a00:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a03:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a0a:	a1 54 51 80 00       	mov    0x805154,%eax
  802a0f:	48                   	dec    %eax
  802a10:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802a15:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a18:	8b 40 08             	mov    0x8(%eax),%eax
  802a1b:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802a20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a23:	8b 50 08             	mov    0x8(%eax),%edx
  802a26:	8b 45 08             	mov    0x8(%ebp),%eax
  802a29:	01 c2                	add    %eax,%edx
  802a2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2e:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802a31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a34:	8b 40 0c             	mov    0xc(%eax),%eax
  802a37:	2b 45 08             	sub    0x8(%ebp),%eax
  802a3a:	89 c2                	mov    %eax,%edx
  802a3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3f:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802a42:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a45:	e9 24 02 00 00       	jmp    802c6e <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a4a:	a1 40 51 80 00       	mov    0x805140,%eax
  802a4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a52:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a56:	74 07                	je     802a5f <alloc_block_NF+0x3bc>
  802a58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5b:	8b 00                	mov    (%eax),%eax
  802a5d:	eb 05                	jmp    802a64 <alloc_block_NF+0x3c1>
  802a5f:	b8 00 00 00 00       	mov    $0x0,%eax
  802a64:	a3 40 51 80 00       	mov    %eax,0x805140
  802a69:	a1 40 51 80 00       	mov    0x805140,%eax
  802a6e:	85 c0                	test   %eax,%eax
  802a70:	0f 85 2b fe ff ff    	jne    8028a1 <alloc_block_NF+0x1fe>
  802a76:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a7a:	0f 85 21 fe ff ff    	jne    8028a1 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a80:	a1 38 51 80 00       	mov    0x805138,%eax
  802a85:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a88:	e9 ae 01 00 00       	jmp    802c3b <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802a8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a90:	8b 50 08             	mov    0x8(%eax),%edx
  802a93:	a1 28 50 80 00       	mov    0x805028,%eax
  802a98:	39 c2                	cmp    %eax,%edx
  802a9a:	0f 83 93 01 00 00    	jae    802c33 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802aa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa3:	8b 40 0c             	mov    0xc(%eax),%eax
  802aa6:	3b 45 08             	cmp    0x8(%ebp),%eax
  802aa9:	0f 82 84 01 00 00    	jb     802c33 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802aaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab2:	8b 40 0c             	mov    0xc(%eax),%eax
  802ab5:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ab8:	0f 85 95 00 00 00    	jne    802b53 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802abe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ac2:	75 17                	jne    802adb <alloc_block_NF+0x438>
  802ac4:	83 ec 04             	sub    $0x4,%esp
  802ac7:	68 c8 40 80 00       	push   $0x8040c8
  802acc:	68 14 01 00 00       	push   $0x114
  802ad1:	68 1f 40 80 00       	push   $0x80401f
  802ad6:	e8 0e d8 ff ff       	call   8002e9 <_panic>
  802adb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ade:	8b 00                	mov    (%eax),%eax
  802ae0:	85 c0                	test   %eax,%eax
  802ae2:	74 10                	je     802af4 <alloc_block_NF+0x451>
  802ae4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae7:	8b 00                	mov    (%eax),%eax
  802ae9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802aec:	8b 52 04             	mov    0x4(%edx),%edx
  802aef:	89 50 04             	mov    %edx,0x4(%eax)
  802af2:	eb 0b                	jmp    802aff <alloc_block_NF+0x45c>
  802af4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af7:	8b 40 04             	mov    0x4(%eax),%eax
  802afa:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802aff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b02:	8b 40 04             	mov    0x4(%eax),%eax
  802b05:	85 c0                	test   %eax,%eax
  802b07:	74 0f                	je     802b18 <alloc_block_NF+0x475>
  802b09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0c:	8b 40 04             	mov    0x4(%eax),%eax
  802b0f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b12:	8b 12                	mov    (%edx),%edx
  802b14:	89 10                	mov    %edx,(%eax)
  802b16:	eb 0a                	jmp    802b22 <alloc_block_NF+0x47f>
  802b18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1b:	8b 00                	mov    (%eax),%eax
  802b1d:	a3 38 51 80 00       	mov    %eax,0x805138
  802b22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b25:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b35:	a1 44 51 80 00       	mov    0x805144,%eax
  802b3a:	48                   	dec    %eax
  802b3b:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802b40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b43:	8b 40 08             	mov    0x8(%eax),%eax
  802b46:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802b4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4e:	e9 1b 01 00 00       	jmp    802c6e <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802b53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b56:	8b 40 0c             	mov    0xc(%eax),%eax
  802b59:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b5c:	0f 86 d1 00 00 00    	jbe    802c33 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b62:	a1 48 51 80 00       	mov    0x805148,%eax
  802b67:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802b6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6d:	8b 50 08             	mov    0x8(%eax),%edx
  802b70:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b73:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802b76:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b79:	8b 55 08             	mov    0x8(%ebp),%edx
  802b7c:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b7f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b83:	75 17                	jne    802b9c <alloc_block_NF+0x4f9>
  802b85:	83 ec 04             	sub    $0x4,%esp
  802b88:	68 c8 40 80 00       	push   $0x8040c8
  802b8d:	68 1c 01 00 00       	push   $0x11c
  802b92:	68 1f 40 80 00       	push   $0x80401f
  802b97:	e8 4d d7 ff ff       	call   8002e9 <_panic>
  802b9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b9f:	8b 00                	mov    (%eax),%eax
  802ba1:	85 c0                	test   %eax,%eax
  802ba3:	74 10                	je     802bb5 <alloc_block_NF+0x512>
  802ba5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ba8:	8b 00                	mov    (%eax),%eax
  802baa:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802bad:	8b 52 04             	mov    0x4(%edx),%edx
  802bb0:	89 50 04             	mov    %edx,0x4(%eax)
  802bb3:	eb 0b                	jmp    802bc0 <alloc_block_NF+0x51d>
  802bb5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bb8:	8b 40 04             	mov    0x4(%eax),%eax
  802bbb:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802bc0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bc3:	8b 40 04             	mov    0x4(%eax),%eax
  802bc6:	85 c0                	test   %eax,%eax
  802bc8:	74 0f                	je     802bd9 <alloc_block_NF+0x536>
  802bca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bcd:	8b 40 04             	mov    0x4(%eax),%eax
  802bd0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802bd3:	8b 12                	mov    (%edx),%edx
  802bd5:	89 10                	mov    %edx,(%eax)
  802bd7:	eb 0a                	jmp    802be3 <alloc_block_NF+0x540>
  802bd9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bdc:	8b 00                	mov    (%eax),%eax
  802bde:	a3 48 51 80 00       	mov    %eax,0x805148
  802be3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802be6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bef:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bf6:	a1 54 51 80 00       	mov    0x805154,%eax
  802bfb:	48                   	dec    %eax
  802bfc:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802c01:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c04:	8b 40 08             	mov    0x8(%eax),%eax
  802c07:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802c0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0f:	8b 50 08             	mov    0x8(%eax),%edx
  802c12:	8b 45 08             	mov    0x8(%ebp),%eax
  802c15:	01 c2                	add    %eax,%edx
  802c17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1a:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802c1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c20:	8b 40 0c             	mov    0xc(%eax),%eax
  802c23:	2b 45 08             	sub    0x8(%ebp),%eax
  802c26:	89 c2                	mov    %eax,%edx
  802c28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2b:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802c2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c31:	eb 3b                	jmp    802c6e <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c33:	a1 40 51 80 00       	mov    0x805140,%eax
  802c38:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c3b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c3f:	74 07                	je     802c48 <alloc_block_NF+0x5a5>
  802c41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c44:	8b 00                	mov    (%eax),%eax
  802c46:	eb 05                	jmp    802c4d <alloc_block_NF+0x5aa>
  802c48:	b8 00 00 00 00       	mov    $0x0,%eax
  802c4d:	a3 40 51 80 00       	mov    %eax,0x805140
  802c52:	a1 40 51 80 00       	mov    0x805140,%eax
  802c57:	85 c0                	test   %eax,%eax
  802c59:	0f 85 2e fe ff ff    	jne    802a8d <alloc_block_NF+0x3ea>
  802c5f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c63:	0f 85 24 fe ff ff    	jne    802a8d <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802c69:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c6e:	c9                   	leave  
  802c6f:	c3                   	ret    

00802c70 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802c70:	55                   	push   %ebp
  802c71:	89 e5                	mov    %esp,%ebp
  802c73:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802c76:	a1 38 51 80 00       	mov    0x805138,%eax
  802c7b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802c7e:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802c83:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802c86:	a1 38 51 80 00       	mov    0x805138,%eax
  802c8b:	85 c0                	test   %eax,%eax
  802c8d:	74 14                	je     802ca3 <insert_sorted_with_merge_freeList+0x33>
  802c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c92:	8b 50 08             	mov    0x8(%eax),%edx
  802c95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c98:	8b 40 08             	mov    0x8(%eax),%eax
  802c9b:	39 c2                	cmp    %eax,%edx
  802c9d:	0f 87 9b 01 00 00    	ja     802e3e <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802ca3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ca7:	75 17                	jne    802cc0 <insert_sorted_with_merge_freeList+0x50>
  802ca9:	83 ec 04             	sub    $0x4,%esp
  802cac:	68 fc 3f 80 00       	push   $0x803ffc
  802cb1:	68 38 01 00 00       	push   $0x138
  802cb6:	68 1f 40 80 00       	push   $0x80401f
  802cbb:	e8 29 d6 ff ff       	call   8002e9 <_panic>
  802cc0:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc9:	89 10                	mov    %edx,(%eax)
  802ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cce:	8b 00                	mov    (%eax),%eax
  802cd0:	85 c0                	test   %eax,%eax
  802cd2:	74 0d                	je     802ce1 <insert_sorted_with_merge_freeList+0x71>
  802cd4:	a1 38 51 80 00       	mov    0x805138,%eax
  802cd9:	8b 55 08             	mov    0x8(%ebp),%edx
  802cdc:	89 50 04             	mov    %edx,0x4(%eax)
  802cdf:	eb 08                	jmp    802ce9 <insert_sorted_with_merge_freeList+0x79>
  802ce1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  802cec:	a3 38 51 80 00       	mov    %eax,0x805138
  802cf1:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cfb:	a1 44 51 80 00       	mov    0x805144,%eax
  802d00:	40                   	inc    %eax
  802d01:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802d06:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d0a:	0f 84 a8 06 00 00    	je     8033b8 <insert_sorted_with_merge_freeList+0x748>
  802d10:	8b 45 08             	mov    0x8(%ebp),%eax
  802d13:	8b 50 08             	mov    0x8(%eax),%edx
  802d16:	8b 45 08             	mov    0x8(%ebp),%eax
  802d19:	8b 40 0c             	mov    0xc(%eax),%eax
  802d1c:	01 c2                	add    %eax,%edx
  802d1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d21:	8b 40 08             	mov    0x8(%eax),%eax
  802d24:	39 c2                	cmp    %eax,%edx
  802d26:	0f 85 8c 06 00 00    	jne    8033b8 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2f:	8b 50 0c             	mov    0xc(%eax),%edx
  802d32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d35:	8b 40 0c             	mov    0xc(%eax),%eax
  802d38:	01 c2                	add    %eax,%edx
  802d3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3d:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802d40:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d44:	75 17                	jne    802d5d <insert_sorted_with_merge_freeList+0xed>
  802d46:	83 ec 04             	sub    $0x4,%esp
  802d49:	68 c8 40 80 00       	push   $0x8040c8
  802d4e:	68 3c 01 00 00       	push   $0x13c
  802d53:	68 1f 40 80 00       	push   $0x80401f
  802d58:	e8 8c d5 ff ff       	call   8002e9 <_panic>
  802d5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d60:	8b 00                	mov    (%eax),%eax
  802d62:	85 c0                	test   %eax,%eax
  802d64:	74 10                	je     802d76 <insert_sorted_with_merge_freeList+0x106>
  802d66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d69:	8b 00                	mov    (%eax),%eax
  802d6b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d6e:	8b 52 04             	mov    0x4(%edx),%edx
  802d71:	89 50 04             	mov    %edx,0x4(%eax)
  802d74:	eb 0b                	jmp    802d81 <insert_sorted_with_merge_freeList+0x111>
  802d76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d79:	8b 40 04             	mov    0x4(%eax),%eax
  802d7c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d84:	8b 40 04             	mov    0x4(%eax),%eax
  802d87:	85 c0                	test   %eax,%eax
  802d89:	74 0f                	je     802d9a <insert_sorted_with_merge_freeList+0x12a>
  802d8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d8e:	8b 40 04             	mov    0x4(%eax),%eax
  802d91:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d94:	8b 12                	mov    (%edx),%edx
  802d96:	89 10                	mov    %edx,(%eax)
  802d98:	eb 0a                	jmp    802da4 <insert_sorted_with_merge_freeList+0x134>
  802d9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d9d:	8b 00                	mov    (%eax),%eax
  802d9f:	a3 38 51 80 00       	mov    %eax,0x805138
  802da4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802db0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802db7:	a1 44 51 80 00       	mov    0x805144,%eax
  802dbc:	48                   	dec    %eax
  802dbd:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802dc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802dcc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dcf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802dd6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802dda:	75 17                	jne    802df3 <insert_sorted_with_merge_freeList+0x183>
  802ddc:	83 ec 04             	sub    $0x4,%esp
  802ddf:	68 fc 3f 80 00       	push   $0x803ffc
  802de4:	68 3f 01 00 00       	push   $0x13f
  802de9:	68 1f 40 80 00       	push   $0x80401f
  802dee:	e8 f6 d4 ff ff       	call   8002e9 <_panic>
  802df3:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802df9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dfc:	89 10                	mov    %edx,(%eax)
  802dfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e01:	8b 00                	mov    (%eax),%eax
  802e03:	85 c0                	test   %eax,%eax
  802e05:	74 0d                	je     802e14 <insert_sorted_with_merge_freeList+0x1a4>
  802e07:	a1 48 51 80 00       	mov    0x805148,%eax
  802e0c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e0f:	89 50 04             	mov    %edx,0x4(%eax)
  802e12:	eb 08                	jmp    802e1c <insert_sorted_with_merge_freeList+0x1ac>
  802e14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e17:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e1f:	a3 48 51 80 00       	mov    %eax,0x805148
  802e24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e27:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e2e:	a1 54 51 80 00       	mov    0x805154,%eax
  802e33:	40                   	inc    %eax
  802e34:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802e39:	e9 7a 05 00 00       	jmp    8033b8 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802e3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e41:	8b 50 08             	mov    0x8(%eax),%edx
  802e44:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e47:	8b 40 08             	mov    0x8(%eax),%eax
  802e4a:	39 c2                	cmp    %eax,%edx
  802e4c:	0f 82 14 01 00 00    	jb     802f66 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802e52:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e55:	8b 50 08             	mov    0x8(%eax),%edx
  802e58:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e5b:	8b 40 0c             	mov    0xc(%eax),%eax
  802e5e:	01 c2                	add    %eax,%edx
  802e60:	8b 45 08             	mov    0x8(%ebp),%eax
  802e63:	8b 40 08             	mov    0x8(%eax),%eax
  802e66:	39 c2                	cmp    %eax,%edx
  802e68:	0f 85 90 00 00 00    	jne    802efe <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802e6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e71:	8b 50 0c             	mov    0xc(%eax),%edx
  802e74:	8b 45 08             	mov    0x8(%ebp),%eax
  802e77:	8b 40 0c             	mov    0xc(%eax),%eax
  802e7a:	01 c2                	add    %eax,%edx
  802e7c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e7f:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802e82:	8b 45 08             	mov    0x8(%ebp),%eax
  802e85:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802e8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802e96:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e9a:	75 17                	jne    802eb3 <insert_sorted_with_merge_freeList+0x243>
  802e9c:	83 ec 04             	sub    $0x4,%esp
  802e9f:	68 fc 3f 80 00       	push   $0x803ffc
  802ea4:	68 49 01 00 00       	push   $0x149
  802ea9:	68 1f 40 80 00       	push   $0x80401f
  802eae:	e8 36 d4 ff ff       	call   8002e9 <_panic>
  802eb3:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802eb9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebc:	89 10                	mov    %edx,(%eax)
  802ebe:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec1:	8b 00                	mov    (%eax),%eax
  802ec3:	85 c0                	test   %eax,%eax
  802ec5:	74 0d                	je     802ed4 <insert_sorted_with_merge_freeList+0x264>
  802ec7:	a1 48 51 80 00       	mov    0x805148,%eax
  802ecc:	8b 55 08             	mov    0x8(%ebp),%edx
  802ecf:	89 50 04             	mov    %edx,0x4(%eax)
  802ed2:	eb 08                	jmp    802edc <insert_sorted_with_merge_freeList+0x26c>
  802ed4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802edc:	8b 45 08             	mov    0x8(%ebp),%eax
  802edf:	a3 48 51 80 00       	mov    %eax,0x805148
  802ee4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eee:	a1 54 51 80 00       	mov    0x805154,%eax
  802ef3:	40                   	inc    %eax
  802ef4:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802ef9:	e9 bb 04 00 00       	jmp    8033b9 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802efe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f02:	75 17                	jne    802f1b <insert_sorted_with_merge_freeList+0x2ab>
  802f04:	83 ec 04             	sub    $0x4,%esp
  802f07:	68 70 40 80 00       	push   $0x804070
  802f0c:	68 4c 01 00 00       	push   $0x14c
  802f11:	68 1f 40 80 00       	push   $0x80401f
  802f16:	e8 ce d3 ff ff       	call   8002e9 <_panic>
  802f1b:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802f21:	8b 45 08             	mov    0x8(%ebp),%eax
  802f24:	89 50 04             	mov    %edx,0x4(%eax)
  802f27:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2a:	8b 40 04             	mov    0x4(%eax),%eax
  802f2d:	85 c0                	test   %eax,%eax
  802f2f:	74 0c                	je     802f3d <insert_sorted_with_merge_freeList+0x2cd>
  802f31:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f36:	8b 55 08             	mov    0x8(%ebp),%edx
  802f39:	89 10                	mov    %edx,(%eax)
  802f3b:	eb 08                	jmp    802f45 <insert_sorted_with_merge_freeList+0x2d5>
  802f3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f40:	a3 38 51 80 00       	mov    %eax,0x805138
  802f45:	8b 45 08             	mov    0x8(%ebp),%eax
  802f48:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f50:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f56:	a1 44 51 80 00       	mov    0x805144,%eax
  802f5b:	40                   	inc    %eax
  802f5c:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802f61:	e9 53 04 00 00       	jmp    8033b9 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802f66:	a1 38 51 80 00       	mov    0x805138,%eax
  802f6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f6e:	e9 15 04 00 00       	jmp    803388 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802f73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f76:	8b 00                	mov    (%eax),%eax
  802f78:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802f7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7e:	8b 50 08             	mov    0x8(%eax),%edx
  802f81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f84:	8b 40 08             	mov    0x8(%eax),%eax
  802f87:	39 c2                	cmp    %eax,%edx
  802f89:	0f 86 f1 03 00 00    	jbe    803380 <insert_sorted_with_merge_freeList+0x710>
  802f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f92:	8b 50 08             	mov    0x8(%eax),%edx
  802f95:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f98:	8b 40 08             	mov    0x8(%eax),%eax
  802f9b:	39 c2                	cmp    %eax,%edx
  802f9d:	0f 83 dd 03 00 00    	jae    803380 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802fa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa6:	8b 50 08             	mov    0x8(%eax),%edx
  802fa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fac:	8b 40 0c             	mov    0xc(%eax),%eax
  802faf:	01 c2                	add    %eax,%edx
  802fb1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb4:	8b 40 08             	mov    0x8(%eax),%eax
  802fb7:	39 c2                	cmp    %eax,%edx
  802fb9:	0f 85 b9 01 00 00    	jne    803178 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc2:	8b 50 08             	mov    0x8(%eax),%edx
  802fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc8:	8b 40 0c             	mov    0xc(%eax),%eax
  802fcb:	01 c2                	add    %eax,%edx
  802fcd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fd0:	8b 40 08             	mov    0x8(%eax),%eax
  802fd3:	39 c2                	cmp    %eax,%edx
  802fd5:	0f 85 0d 01 00 00    	jne    8030e8 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802fdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fde:	8b 50 0c             	mov    0xc(%eax),%edx
  802fe1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fe4:	8b 40 0c             	mov    0xc(%eax),%eax
  802fe7:	01 c2                	add    %eax,%edx
  802fe9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fec:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802fef:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ff3:	75 17                	jne    80300c <insert_sorted_with_merge_freeList+0x39c>
  802ff5:	83 ec 04             	sub    $0x4,%esp
  802ff8:	68 c8 40 80 00       	push   $0x8040c8
  802ffd:	68 5c 01 00 00       	push   $0x15c
  803002:	68 1f 40 80 00       	push   $0x80401f
  803007:	e8 dd d2 ff ff       	call   8002e9 <_panic>
  80300c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80300f:	8b 00                	mov    (%eax),%eax
  803011:	85 c0                	test   %eax,%eax
  803013:	74 10                	je     803025 <insert_sorted_with_merge_freeList+0x3b5>
  803015:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803018:	8b 00                	mov    (%eax),%eax
  80301a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80301d:	8b 52 04             	mov    0x4(%edx),%edx
  803020:	89 50 04             	mov    %edx,0x4(%eax)
  803023:	eb 0b                	jmp    803030 <insert_sorted_with_merge_freeList+0x3c0>
  803025:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803028:	8b 40 04             	mov    0x4(%eax),%eax
  80302b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803030:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803033:	8b 40 04             	mov    0x4(%eax),%eax
  803036:	85 c0                	test   %eax,%eax
  803038:	74 0f                	je     803049 <insert_sorted_with_merge_freeList+0x3d9>
  80303a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80303d:	8b 40 04             	mov    0x4(%eax),%eax
  803040:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803043:	8b 12                	mov    (%edx),%edx
  803045:	89 10                	mov    %edx,(%eax)
  803047:	eb 0a                	jmp    803053 <insert_sorted_with_merge_freeList+0x3e3>
  803049:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80304c:	8b 00                	mov    (%eax),%eax
  80304e:	a3 38 51 80 00       	mov    %eax,0x805138
  803053:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803056:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80305c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80305f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803066:	a1 44 51 80 00       	mov    0x805144,%eax
  80306b:	48                   	dec    %eax
  80306c:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803071:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803074:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  80307b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80307e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803085:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803089:	75 17                	jne    8030a2 <insert_sorted_with_merge_freeList+0x432>
  80308b:	83 ec 04             	sub    $0x4,%esp
  80308e:	68 fc 3f 80 00       	push   $0x803ffc
  803093:	68 5f 01 00 00       	push   $0x15f
  803098:	68 1f 40 80 00       	push   $0x80401f
  80309d:	e8 47 d2 ff ff       	call   8002e9 <_panic>
  8030a2:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8030a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ab:	89 10                	mov    %edx,(%eax)
  8030ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030b0:	8b 00                	mov    (%eax),%eax
  8030b2:	85 c0                	test   %eax,%eax
  8030b4:	74 0d                	je     8030c3 <insert_sorted_with_merge_freeList+0x453>
  8030b6:	a1 48 51 80 00       	mov    0x805148,%eax
  8030bb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030be:	89 50 04             	mov    %edx,0x4(%eax)
  8030c1:	eb 08                	jmp    8030cb <insert_sorted_with_merge_freeList+0x45b>
  8030c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030c6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ce:	a3 48 51 80 00       	mov    %eax,0x805148
  8030d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030d6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030dd:	a1 54 51 80 00       	mov    0x805154,%eax
  8030e2:	40                   	inc    %eax
  8030e3:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8030e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030eb:	8b 50 0c             	mov    0xc(%eax),%edx
  8030ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f1:	8b 40 0c             	mov    0xc(%eax),%eax
  8030f4:	01 c2                	add    %eax,%edx
  8030f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f9:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8030fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ff:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803106:	8b 45 08             	mov    0x8(%ebp),%eax
  803109:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803110:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803114:	75 17                	jne    80312d <insert_sorted_with_merge_freeList+0x4bd>
  803116:	83 ec 04             	sub    $0x4,%esp
  803119:	68 fc 3f 80 00       	push   $0x803ffc
  80311e:	68 64 01 00 00       	push   $0x164
  803123:	68 1f 40 80 00       	push   $0x80401f
  803128:	e8 bc d1 ff ff       	call   8002e9 <_panic>
  80312d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803133:	8b 45 08             	mov    0x8(%ebp),%eax
  803136:	89 10                	mov    %edx,(%eax)
  803138:	8b 45 08             	mov    0x8(%ebp),%eax
  80313b:	8b 00                	mov    (%eax),%eax
  80313d:	85 c0                	test   %eax,%eax
  80313f:	74 0d                	je     80314e <insert_sorted_with_merge_freeList+0x4de>
  803141:	a1 48 51 80 00       	mov    0x805148,%eax
  803146:	8b 55 08             	mov    0x8(%ebp),%edx
  803149:	89 50 04             	mov    %edx,0x4(%eax)
  80314c:	eb 08                	jmp    803156 <insert_sorted_with_merge_freeList+0x4e6>
  80314e:	8b 45 08             	mov    0x8(%ebp),%eax
  803151:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803156:	8b 45 08             	mov    0x8(%ebp),%eax
  803159:	a3 48 51 80 00       	mov    %eax,0x805148
  80315e:	8b 45 08             	mov    0x8(%ebp),%eax
  803161:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803168:	a1 54 51 80 00       	mov    0x805154,%eax
  80316d:	40                   	inc    %eax
  80316e:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803173:	e9 41 02 00 00       	jmp    8033b9 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803178:	8b 45 08             	mov    0x8(%ebp),%eax
  80317b:	8b 50 08             	mov    0x8(%eax),%edx
  80317e:	8b 45 08             	mov    0x8(%ebp),%eax
  803181:	8b 40 0c             	mov    0xc(%eax),%eax
  803184:	01 c2                	add    %eax,%edx
  803186:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803189:	8b 40 08             	mov    0x8(%eax),%eax
  80318c:	39 c2                	cmp    %eax,%edx
  80318e:	0f 85 7c 01 00 00    	jne    803310 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803194:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803198:	74 06                	je     8031a0 <insert_sorted_with_merge_freeList+0x530>
  80319a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80319e:	75 17                	jne    8031b7 <insert_sorted_with_merge_freeList+0x547>
  8031a0:	83 ec 04             	sub    $0x4,%esp
  8031a3:	68 38 40 80 00       	push   $0x804038
  8031a8:	68 69 01 00 00       	push   $0x169
  8031ad:	68 1f 40 80 00       	push   $0x80401f
  8031b2:	e8 32 d1 ff ff       	call   8002e9 <_panic>
  8031b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ba:	8b 50 04             	mov    0x4(%eax),%edx
  8031bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c0:	89 50 04             	mov    %edx,0x4(%eax)
  8031c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031c9:	89 10                	mov    %edx,(%eax)
  8031cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ce:	8b 40 04             	mov    0x4(%eax),%eax
  8031d1:	85 c0                	test   %eax,%eax
  8031d3:	74 0d                	je     8031e2 <insert_sorted_with_merge_freeList+0x572>
  8031d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d8:	8b 40 04             	mov    0x4(%eax),%eax
  8031db:	8b 55 08             	mov    0x8(%ebp),%edx
  8031de:	89 10                	mov    %edx,(%eax)
  8031e0:	eb 08                	jmp    8031ea <insert_sorted_with_merge_freeList+0x57a>
  8031e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e5:	a3 38 51 80 00       	mov    %eax,0x805138
  8031ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8031f0:	89 50 04             	mov    %edx,0x4(%eax)
  8031f3:	a1 44 51 80 00       	mov    0x805144,%eax
  8031f8:	40                   	inc    %eax
  8031f9:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8031fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803201:	8b 50 0c             	mov    0xc(%eax),%edx
  803204:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803207:	8b 40 0c             	mov    0xc(%eax),%eax
  80320a:	01 c2                	add    %eax,%edx
  80320c:	8b 45 08             	mov    0x8(%ebp),%eax
  80320f:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803212:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803216:	75 17                	jne    80322f <insert_sorted_with_merge_freeList+0x5bf>
  803218:	83 ec 04             	sub    $0x4,%esp
  80321b:	68 c8 40 80 00       	push   $0x8040c8
  803220:	68 6b 01 00 00       	push   $0x16b
  803225:	68 1f 40 80 00       	push   $0x80401f
  80322a:	e8 ba d0 ff ff       	call   8002e9 <_panic>
  80322f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803232:	8b 00                	mov    (%eax),%eax
  803234:	85 c0                	test   %eax,%eax
  803236:	74 10                	je     803248 <insert_sorted_with_merge_freeList+0x5d8>
  803238:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80323b:	8b 00                	mov    (%eax),%eax
  80323d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803240:	8b 52 04             	mov    0x4(%edx),%edx
  803243:	89 50 04             	mov    %edx,0x4(%eax)
  803246:	eb 0b                	jmp    803253 <insert_sorted_with_merge_freeList+0x5e3>
  803248:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80324b:	8b 40 04             	mov    0x4(%eax),%eax
  80324e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803253:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803256:	8b 40 04             	mov    0x4(%eax),%eax
  803259:	85 c0                	test   %eax,%eax
  80325b:	74 0f                	je     80326c <insert_sorted_with_merge_freeList+0x5fc>
  80325d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803260:	8b 40 04             	mov    0x4(%eax),%eax
  803263:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803266:	8b 12                	mov    (%edx),%edx
  803268:	89 10                	mov    %edx,(%eax)
  80326a:	eb 0a                	jmp    803276 <insert_sorted_with_merge_freeList+0x606>
  80326c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80326f:	8b 00                	mov    (%eax),%eax
  803271:	a3 38 51 80 00       	mov    %eax,0x805138
  803276:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803279:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80327f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803282:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803289:	a1 44 51 80 00       	mov    0x805144,%eax
  80328e:	48                   	dec    %eax
  80328f:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803294:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803297:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  80329e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032a1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8032a8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032ac:	75 17                	jne    8032c5 <insert_sorted_with_merge_freeList+0x655>
  8032ae:	83 ec 04             	sub    $0x4,%esp
  8032b1:	68 fc 3f 80 00       	push   $0x803ffc
  8032b6:	68 6e 01 00 00       	push   $0x16e
  8032bb:	68 1f 40 80 00       	push   $0x80401f
  8032c0:	e8 24 d0 ff ff       	call   8002e9 <_panic>
  8032c5:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ce:	89 10                	mov    %edx,(%eax)
  8032d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d3:	8b 00                	mov    (%eax),%eax
  8032d5:	85 c0                	test   %eax,%eax
  8032d7:	74 0d                	je     8032e6 <insert_sorted_with_merge_freeList+0x676>
  8032d9:	a1 48 51 80 00       	mov    0x805148,%eax
  8032de:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032e1:	89 50 04             	mov    %edx,0x4(%eax)
  8032e4:	eb 08                	jmp    8032ee <insert_sorted_with_merge_freeList+0x67e>
  8032e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032e9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032f1:	a3 48 51 80 00       	mov    %eax,0x805148
  8032f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032f9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803300:	a1 54 51 80 00       	mov    0x805154,%eax
  803305:	40                   	inc    %eax
  803306:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80330b:	e9 a9 00 00 00       	jmp    8033b9 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803310:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803314:	74 06                	je     80331c <insert_sorted_with_merge_freeList+0x6ac>
  803316:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80331a:	75 17                	jne    803333 <insert_sorted_with_merge_freeList+0x6c3>
  80331c:	83 ec 04             	sub    $0x4,%esp
  80331f:	68 94 40 80 00       	push   $0x804094
  803324:	68 73 01 00 00       	push   $0x173
  803329:	68 1f 40 80 00       	push   $0x80401f
  80332e:	e8 b6 cf ff ff       	call   8002e9 <_panic>
  803333:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803336:	8b 10                	mov    (%eax),%edx
  803338:	8b 45 08             	mov    0x8(%ebp),%eax
  80333b:	89 10                	mov    %edx,(%eax)
  80333d:	8b 45 08             	mov    0x8(%ebp),%eax
  803340:	8b 00                	mov    (%eax),%eax
  803342:	85 c0                	test   %eax,%eax
  803344:	74 0b                	je     803351 <insert_sorted_with_merge_freeList+0x6e1>
  803346:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803349:	8b 00                	mov    (%eax),%eax
  80334b:	8b 55 08             	mov    0x8(%ebp),%edx
  80334e:	89 50 04             	mov    %edx,0x4(%eax)
  803351:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803354:	8b 55 08             	mov    0x8(%ebp),%edx
  803357:	89 10                	mov    %edx,(%eax)
  803359:	8b 45 08             	mov    0x8(%ebp),%eax
  80335c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80335f:	89 50 04             	mov    %edx,0x4(%eax)
  803362:	8b 45 08             	mov    0x8(%ebp),%eax
  803365:	8b 00                	mov    (%eax),%eax
  803367:	85 c0                	test   %eax,%eax
  803369:	75 08                	jne    803373 <insert_sorted_with_merge_freeList+0x703>
  80336b:	8b 45 08             	mov    0x8(%ebp),%eax
  80336e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803373:	a1 44 51 80 00       	mov    0x805144,%eax
  803378:	40                   	inc    %eax
  803379:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  80337e:	eb 39                	jmp    8033b9 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803380:	a1 40 51 80 00       	mov    0x805140,%eax
  803385:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803388:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80338c:	74 07                	je     803395 <insert_sorted_with_merge_freeList+0x725>
  80338e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803391:	8b 00                	mov    (%eax),%eax
  803393:	eb 05                	jmp    80339a <insert_sorted_with_merge_freeList+0x72a>
  803395:	b8 00 00 00 00       	mov    $0x0,%eax
  80339a:	a3 40 51 80 00       	mov    %eax,0x805140
  80339f:	a1 40 51 80 00       	mov    0x805140,%eax
  8033a4:	85 c0                	test   %eax,%eax
  8033a6:	0f 85 c7 fb ff ff    	jne    802f73 <insert_sorted_with_merge_freeList+0x303>
  8033ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033b0:	0f 85 bd fb ff ff    	jne    802f73 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8033b6:	eb 01                	jmp    8033b9 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8033b8:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8033b9:	90                   	nop
  8033ba:	c9                   	leave  
  8033bb:	c3                   	ret    

008033bc <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8033bc:	55                   	push   %ebp
  8033bd:	89 e5                	mov    %esp,%ebp
  8033bf:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8033c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8033c5:	89 d0                	mov    %edx,%eax
  8033c7:	c1 e0 02             	shl    $0x2,%eax
  8033ca:	01 d0                	add    %edx,%eax
  8033cc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8033d3:	01 d0                	add    %edx,%eax
  8033d5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8033dc:	01 d0                	add    %edx,%eax
  8033de:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8033e5:	01 d0                	add    %edx,%eax
  8033e7:	c1 e0 04             	shl    $0x4,%eax
  8033ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8033ed:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8033f4:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8033f7:	83 ec 0c             	sub    $0xc,%esp
  8033fa:	50                   	push   %eax
  8033fb:	e8 26 e7 ff ff       	call   801b26 <sys_get_virtual_time>
  803400:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803403:	eb 41                	jmp    803446 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803405:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803408:	83 ec 0c             	sub    $0xc,%esp
  80340b:	50                   	push   %eax
  80340c:	e8 15 e7 ff ff       	call   801b26 <sys_get_virtual_time>
  803411:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803414:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803417:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80341a:	29 c2                	sub    %eax,%edx
  80341c:	89 d0                	mov    %edx,%eax
  80341e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803421:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803424:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803427:	89 d1                	mov    %edx,%ecx
  803429:	29 c1                	sub    %eax,%ecx
  80342b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80342e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803431:	39 c2                	cmp    %eax,%edx
  803433:	0f 97 c0             	seta   %al
  803436:	0f b6 c0             	movzbl %al,%eax
  803439:	29 c1                	sub    %eax,%ecx
  80343b:	89 c8                	mov    %ecx,%eax
  80343d:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803440:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803443:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803446:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803449:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80344c:	72 b7                	jb     803405 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  80344e:	90                   	nop
  80344f:	c9                   	leave  
  803450:	c3                   	ret    

00803451 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803451:	55                   	push   %ebp
  803452:	89 e5                	mov    %esp,%ebp
  803454:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803457:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  80345e:	eb 03                	jmp    803463 <busy_wait+0x12>
  803460:	ff 45 fc             	incl   -0x4(%ebp)
  803463:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803466:	3b 45 08             	cmp    0x8(%ebp),%eax
  803469:	72 f5                	jb     803460 <busy_wait+0xf>
	return i;
  80346b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80346e:	c9                   	leave  
  80346f:	c3                   	ret    

00803470 <__udivdi3>:
  803470:	55                   	push   %ebp
  803471:	57                   	push   %edi
  803472:	56                   	push   %esi
  803473:	53                   	push   %ebx
  803474:	83 ec 1c             	sub    $0x1c,%esp
  803477:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80347b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80347f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803483:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803487:	89 ca                	mov    %ecx,%edx
  803489:	89 f8                	mov    %edi,%eax
  80348b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80348f:	85 f6                	test   %esi,%esi
  803491:	75 2d                	jne    8034c0 <__udivdi3+0x50>
  803493:	39 cf                	cmp    %ecx,%edi
  803495:	77 65                	ja     8034fc <__udivdi3+0x8c>
  803497:	89 fd                	mov    %edi,%ebp
  803499:	85 ff                	test   %edi,%edi
  80349b:	75 0b                	jne    8034a8 <__udivdi3+0x38>
  80349d:	b8 01 00 00 00       	mov    $0x1,%eax
  8034a2:	31 d2                	xor    %edx,%edx
  8034a4:	f7 f7                	div    %edi
  8034a6:	89 c5                	mov    %eax,%ebp
  8034a8:	31 d2                	xor    %edx,%edx
  8034aa:	89 c8                	mov    %ecx,%eax
  8034ac:	f7 f5                	div    %ebp
  8034ae:	89 c1                	mov    %eax,%ecx
  8034b0:	89 d8                	mov    %ebx,%eax
  8034b2:	f7 f5                	div    %ebp
  8034b4:	89 cf                	mov    %ecx,%edi
  8034b6:	89 fa                	mov    %edi,%edx
  8034b8:	83 c4 1c             	add    $0x1c,%esp
  8034bb:	5b                   	pop    %ebx
  8034bc:	5e                   	pop    %esi
  8034bd:	5f                   	pop    %edi
  8034be:	5d                   	pop    %ebp
  8034bf:	c3                   	ret    
  8034c0:	39 ce                	cmp    %ecx,%esi
  8034c2:	77 28                	ja     8034ec <__udivdi3+0x7c>
  8034c4:	0f bd fe             	bsr    %esi,%edi
  8034c7:	83 f7 1f             	xor    $0x1f,%edi
  8034ca:	75 40                	jne    80350c <__udivdi3+0x9c>
  8034cc:	39 ce                	cmp    %ecx,%esi
  8034ce:	72 0a                	jb     8034da <__udivdi3+0x6a>
  8034d0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8034d4:	0f 87 9e 00 00 00    	ja     803578 <__udivdi3+0x108>
  8034da:	b8 01 00 00 00       	mov    $0x1,%eax
  8034df:	89 fa                	mov    %edi,%edx
  8034e1:	83 c4 1c             	add    $0x1c,%esp
  8034e4:	5b                   	pop    %ebx
  8034e5:	5e                   	pop    %esi
  8034e6:	5f                   	pop    %edi
  8034e7:	5d                   	pop    %ebp
  8034e8:	c3                   	ret    
  8034e9:	8d 76 00             	lea    0x0(%esi),%esi
  8034ec:	31 ff                	xor    %edi,%edi
  8034ee:	31 c0                	xor    %eax,%eax
  8034f0:	89 fa                	mov    %edi,%edx
  8034f2:	83 c4 1c             	add    $0x1c,%esp
  8034f5:	5b                   	pop    %ebx
  8034f6:	5e                   	pop    %esi
  8034f7:	5f                   	pop    %edi
  8034f8:	5d                   	pop    %ebp
  8034f9:	c3                   	ret    
  8034fa:	66 90                	xchg   %ax,%ax
  8034fc:	89 d8                	mov    %ebx,%eax
  8034fe:	f7 f7                	div    %edi
  803500:	31 ff                	xor    %edi,%edi
  803502:	89 fa                	mov    %edi,%edx
  803504:	83 c4 1c             	add    $0x1c,%esp
  803507:	5b                   	pop    %ebx
  803508:	5e                   	pop    %esi
  803509:	5f                   	pop    %edi
  80350a:	5d                   	pop    %ebp
  80350b:	c3                   	ret    
  80350c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803511:	89 eb                	mov    %ebp,%ebx
  803513:	29 fb                	sub    %edi,%ebx
  803515:	89 f9                	mov    %edi,%ecx
  803517:	d3 e6                	shl    %cl,%esi
  803519:	89 c5                	mov    %eax,%ebp
  80351b:	88 d9                	mov    %bl,%cl
  80351d:	d3 ed                	shr    %cl,%ebp
  80351f:	89 e9                	mov    %ebp,%ecx
  803521:	09 f1                	or     %esi,%ecx
  803523:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803527:	89 f9                	mov    %edi,%ecx
  803529:	d3 e0                	shl    %cl,%eax
  80352b:	89 c5                	mov    %eax,%ebp
  80352d:	89 d6                	mov    %edx,%esi
  80352f:	88 d9                	mov    %bl,%cl
  803531:	d3 ee                	shr    %cl,%esi
  803533:	89 f9                	mov    %edi,%ecx
  803535:	d3 e2                	shl    %cl,%edx
  803537:	8b 44 24 08          	mov    0x8(%esp),%eax
  80353b:	88 d9                	mov    %bl,%cl
  80353d:	d3 e8                	shr    %cl,%eax
  80353f:	09 c2                	or     %eax,%edx
  803541:	89 d0                	mov    %edx,%eax
  803543:	89 f2                	mov    %esi,%edx
  803545:	f7 74 24 0c          	divl   0xc(%esp)
  803549:	89 d6                	mov    %edx,%esi
  80354b:	89 c3                	mov    %eax,%ebx
  80354d:	f7 e5                	mul    %ebp
  80354f:	39 d6                	cmp    %edx,%esi
  803551:	72 19                	jb     80356c <__udivdi3+0xfc>
  803553:	74 0b                	je     803560 <__udivdi3+0xf0>
  803555:	89 d8                	mov    %ebx,%eax
  803557:	31 ff                	xor    %edi,%edi
  803559:	e9 58 ff ff ff       	jmp    8034b6 <__udivdi3+0x46>
  80355e:	66 90                	xchg   %ax,%ax
  803560:	8b 54 24 08          	mov    0x8(%esp),%edx
  803564:	89 f9                	mov    %edi,%ecx
  803566:	d3 e2                	shl    %cl,%edx
  803568:	39 c2                	cmp    %eax,%edx
  80356a:	73 e9                	jae    803555 <__udivdi3+0xe5>
  80356c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80356f:	31 ff                	xor    %edi,%edi
  803571:	e9 40 ff ff ff       	jmp    8034b6 <__udivdi3+0x46>
  803576:	66 90                	xchg   %ax,%ax
  803578:	31 c0                	xor    %eax,%eax
  80357a:	e9 37 ff ff ff       	jmp    8034b6 <__udivdi3+0x46>
  80357f:	90                   	nop

00803580 <__umoddi3>:
  803580:	55                   	push   %ebp
  803581:	57                   	push   %edi
  803582:	56                   	push   %esi
  803583:	53                   	push   %ebx
  803584:	83 ec 1c             	sub    $0x1c,%esp
  803587:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80358b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80358f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803593:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803597:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80359b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80359f:	89 f3                	mov    %esi,%ebx
  8035a1:	89 fa                	mov    %edi,%edx
  8035a3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8035a7:	89 34 24             	mov    %esi,(%esp)
  8035aa:	85 c0                	test   %eax,%eax
  8035ac:	75 1a                	jne    8035c8 <__umoddi3+0x48>
  8035ae:	39 f7                	cmp    %esi,%edi
  8035b0:	0f 86 a2 00 00 00    	jbe    803658 <__umoddi3+0xd8>
  8035b6:	89 c8                	mov    %ecx,%eax
  8035b8:	89 f2                	mov    %esi,%edx
  8035ba:	f7 f7                	div    %edi
  8035bc:	89 d0                	mov    %edx,%eax
  8035be:	31 d2                	xor    %edx,%edx
  8035c0:	83 c4 1c             	add    $0x1c,%esp
  8035c3:	5b                   	pop    %ebx
  8035c4:	5e                   	pop    %esi
  8035c5:	5f                   	pop    %edi
  8035c6:	5d                   	pop    %ebp
  8035c7:	c3                   	ret    
  8035c8:	39 f0                	cmp    %esi,%eax
  8035ca:	0f 87 ac 00 00 00    	ja     80367c <__umoddi3+0xfc>
  8035d0:	0f bd e8             	bsr    %eax,%ebp
  8035d3:	83 f5 1f             	xor    $0x1f,%ebp
  8035d6:	0f 84 ac 00 00 00    	je     803688 <__umoddi3+0x108>
  8035dc:	bf 20 00 00 00       	mov    $0x20,%edi
  8035e1:	29 ef                	sub    %ebp,%edi
  8035e3:	89 fe                	mov    %edi,%esi
  8035e5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8035e9:	89 e9                	mov    %ebp,%ecx
  8035eb:	d3 e0                	shl    %cl,%eax
  8035ed:	89 d7                	mov    %edx,%edi
  8035ef:	89 f1                	mov    %esi,%ecx
  8035f1:	d3 ef                	shr    %cl,%edi
  8035f3:	09 c7                	or     %eax,%edi
  8035f5:	89 e9                	mov    %ebp,%ecx
  8035f7:	d3 e2                	shl    %cl,%edx
  8035f9:	89 14 24             	mov    %edx,(%esp)
  8035fc:	89 d8                	mov    %ebx,%eax
  8035fe:	d3 e0                	shl    %cl,%eax
  803600:	89 c2                	mov    %eax,%edx
  803602:	8b 44 24 08          	mov    0x8(%esp),%eax
  803606:	d3 e0                	shl    %cl,%eax
  803608:	89 44 24 04          	mov    %eax,0x4(%esp)
  80360c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803610:	89 f1                	mov    %esi,%ecx
  803612:	d3 e8                	shr    %cl,%eax
  803614:	09 d0                	or     %edx,%eax
  803616:	d3 eb                	shr    %cl,%ebx
  803618:	89 da                	mov    %ebx,%edx
  80361a:	f7 f7                	div    %edi
  80361c:	89 d3                	mov    %edx,%ebx
  80361e:	f7 24 24             	mull   (%esp)
  803621:	89 c6                	mov    %eax,%esi
  803623:	89 d1                	mov    %edx,%ecx
  803625:	39 d3                	cmp    %edx,%ebx
  803627:	0f 82 87 00 00 00    	jb     8036b4 <__umoddi3+0x134>
  80362d:	0f 84 91 00 00 00    	je     8036c4 <__umoddi3+0x144>
  803633:	8b 54 24 04          	mov    0x4(%esp),%edx
  803637:	29 f2                	sub    %esi,%edx
  803639:	19 cb                	sbb    %ecx,%ebx
  80363b:	89 d8                	mov    %ebx,%eax
  80363d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803641:	d3 e0                	shl    %cl,%eax
  803643:	89 e9                	mov    %ebp,%ecx
  803645:	d3 ea                	shr    %cl,%edx
  803647:	09 d0                	or     %edx,%eax
  803649:	89 e9                	mov    %ebp,%ecx
  80364b:	d3 eb                	shr    %cl,%ebx
  80364d:	89 da                	mov    %ebx,%edx
  80364f:	83 c4 1c             	add    $0x1c,%esp
  803652:	5b                   	pop    %ebx
  803653:	5e                   	pop    %esi
  803654:	5f                   	pop    %edi
  803655:	5d                   	pop    %ebp
  803656:	c3                   	ret    
  803657:	90                   	nop
  803658:	89 fd                	mov    %edi,%ebp
  80365a:	85 ff                	test   %edi,%edi
  80365c:	75 0b                	jne    803669 <__umoddi3+0xe9>
  80365e:	b8 01 00 00 00       	mov    $0x1,%eax
  803663:	31 d2                	xor    %edx,%edx
  803665:	f7 f7                	div    %edi
  803667:	89 c5                	mov    %eax,%ebp
  803669:	89 f0                	mov    %esi,%eax
  80366b:	31 d2                	xor    %edx,%edx
  80366d:	f7 f5                	div    %ebp
  80366f:	89 c8                	mov    %ecx,%eax
  803671:	f7 f5                	div    %ebp
  803673:	89 d0                	mov    %edx,%eax
  803675:	e9 44 ff ff ff       	jmp    8035be <__umoddi3+0x3e>
  80367a:	66 90                	xchg   %ax,%ax
  80367c:	89 c8                	mov    %ecx,%eax
  80367e:	89 f2                	mov    %esi,%edx
  803680:	83 c4 1c             	add    $0x1c,%esp
  803683:	5b                   	pop    %ebx
  803684:	5e                   	pop    %esi
  803685:	5f                   	pop    %edi
  803686:	5d                   	pop    %ebp
  803687:	c3                   	ret    
  803688:	3b 04 24             	cmp    (%esp),%eax
  80368b:	72 06                	jb     803693 <__umoddi3+0x113>
  80368d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803691:	77 0f                	ja     8036a2 <__umoddi3+0x122>
  803693:	89 f2                	mov    %esi,%edx
  803695:	29 f9                	sub    %edi,%ecx
  803697:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80369b:	89 14 24             	mov    %edx,(%esp)
  80369e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8036a2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8036a6:	8b 14 24             	mov    (%esp),%edx
  8036a9:	83 c4 1c             	add    $0x1c,%esp
  8036ac:	5b                   	pop    %ebx
  8036ad:	5e                   	pop    %esi
  8036ae:	5f                   	pop    %edi
  8036af:	5d                   	pop    %ebp
  8036b0:	c3                   	ret    
  8036b1:	8d 76 00             	lea    0x0(%esi),%esi
  8036b4:	2b 04 24             	sub    (%esp),%eax
  8036b7:	19 fa                	sbb    %edi,%edx
  8036b9:	89 d1                	mov    %edx,%ecx
  8036bb:	89 c6                	mov    %eax,%esi
  8036bd:	e9 71 ff ff ff       	jmp    803633 <__umoddi3+0xb3>
  8036c2:	66 90                	xchg   %ax,%ax
  8036c4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8036c8:	72 ea                	jb     8036b4 <__umoddi3+0x134>
  8036ca:	89 d9                	mov    %ebx,%ecx
  8036cc:	e9 62 ff ff ff       	jmp    803633 <__umoddi3+0xb3>
