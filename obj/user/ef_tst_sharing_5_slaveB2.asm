
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
  80008c:	68 a0 36 80 00       	push   $0x8036a0
  800091:	6a 12                	push   $0x12
  800093:	68 bc 36 80 00       	push   $0x8036bc
  800098:	e8 4c 02 00 00       	call   8002e9 <_panic>
	}
	uint32 *z;
	z = sget(sys_getparentenvid(),"z");
  80009d:	e8 04 1a 00 00       	call   801aa6 <sys_getparentenvid>
  8000a2:	83 ec 08             	sub    $0x8,%esp
  8000a5:	68 dc 36 80 00       	push   $0x8036dc
  8000aa:	50                   	push   %eax
  8000ab:	e8 59 15 00 00       	call   801609 <sget>
  8000b0:	83 c4 10             	add    $0x10,%esp
  8000b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("Slave B2 env used z (getSharedObject)\n");
  8000b6:	83 ec 0c             	sub    $0xc,%esp
  8000b9:	68 e0 36 80 00       	push   $0x8036e0
  8000be:	e8 da 04 00 00       	call   80059d <cprintf>
  8000c3:	83 c4 10             	add    $0x10,%esp

	cprintf("Slave B2 please be patient ...\n");
  8000c6:	83 ec 0c             	sub    $0xc,%esp
  8000c9:	68 08 37 80 00       	push   $0x803708
  8000ce:	e8 ca 04 00 00       	call   80059d <cprintf>
  8000d3:	83 c4 10             	add    $0x10,%esp

	env_sleep(9000);
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	68 28 23 00 00       	push   $0x2328
  8000de:	e8 8c 32 00 00       	call   80336f <env_sleep>
  8000e3:	83 c4 10             	add    $0x10,%esp
	int freeFrames = sys_calculate_free_frames() ;
  8000e6:	e8 c2 16 00 00       	call   8017ad <sys_calculate_free_frames>
  8000eb:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sfree(z);
  8000ee:	83 ec 0c             	sub    $0xc,%esp
  8000f1:	ff 75 ec             	pushl  -0x14(%ebp)
  8000f4:	e8 54 15 00 00       	call   80164d <sfree>
  8000f9:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave B2 env removed z\n");
  8000fc:	83 ec 0c             	sub    $0xc,%esp
  8000ff:	68 28 37 80 00       	push   $0x803728
  800104:	e8 94 04 00 00       	call   80059d <cprintf>
  800109:	83 c4 10             	add    $0x10,%esp

	if ((sys_calculate_free_frames() - freeFrames) !=  4) panic("wrong free: frames removed not equal 4 !, correct frames to be removed are 4:\nfrom the env: 1 table + 1 frame for z\nframes_storage of z: should be cleared now\n");
  80010c:	e8 9c 16 00 00       	call   8017ad <sys_calculate_free_frames>
  800111:	89 c2                	mov    %eax,%edx
  800113:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800116:	29 c2                	sub    %eax,%edx
  800118:	89 d0                	mov    %edx,%eax
  80011a:	83 f8 04             	cmp    $0x4,%eax
  80011d:	74 14                	je     800133 <_main+0xfb>
  80011f:	83 ec 04             	sub    $0x4,%esp
  800122:	68 40 37 80 00       	push   $0x803740
  800127:	6a 20                	push   $0x20
  800129:	68 bc 36 80 00       	push   $0x8036bc
  80012e:	e8 b6 01 00 00       	call   8002e9 <_panic>

	//to ensure that the other environments completed successfully
	if (gettst()!=2) panic("test failed");
  800133:	e8 ad 1a 00 00       	call   801be5 <gettst>
  800138:	83 f8 02             	cmp    $0x2,%eax
  80013b:	74 14                	je     800151 <_main+0x119>
  80013d:	83 ec 04             	sub    $0x4,%esp
  800140:	68 e0 37 80 00       	push   $0x8037e0
  800145:	6a 23                	push   $0x23
  800147:	68 bc 36 80 00       	push   $0x8036bc
  80014c:	e8 98 01 00 00       	call   8002e9 <_panic>

	cprintf("Step B completed successfully!!\n\n\n");
  800151:	83 ec 0c             	sub    $0xc,%esp
  800154:	68 ec 37 80 00       	push   $0x8037ec
  800159:	e8 3f 04 00 00       	call   80059d <cprintf>
  80015e:	83 c4 10             	add    $0x10,%esp
	cprintf("Congratulations!! Test of freeSharedObjects [5] completed successfully!!\n\n\n");
  800161:	83 ec 0c             	sub    $0xc,%esp
  800164:	68 10 38 80 00       	push   $0x803810
  800169:	e8 2f 04 00 00       	call   80059d <cprintf>
  80016e:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  800171:	e8 30 19 00 00       	call   801aa6 <sys_getparentenvid>
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
  800189:	68 5c 38 80 00       	push   $0x80385c
  80018e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800191:	e8 73 14 00 00       	call   801609 <sget>
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
  8001b3:	e8 d5 18 00 00       	call   801a8d <sys_getenvindex>
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
  80021e:	e8 77 16 00 00       	call   80189a <sys_disable_interrupt>
	cprintf("**************************************\n");
  800223:	83 ec 0c             	sub    $0xc,%esp
  800226:	68 84 38 80 00       	push   $0x803884
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
  80024e:	68 ac 38 80 00       	push   $0x8038ac
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
  80027f:	68 d4 38 80 00       	push   $0x8038d4
  800284:	e8 14 03 00 00       	call   80059d <cprintf>
  800289:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80028c:	a1 20 50 80 00       	mov    0x805020,%eax
  800291:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800297:	83 ec 08             	sub    $0x8,%esp
  80029a:	50                   	push   %eax
  80029b:	68 2c 39 80 00       	push   $0x80392c
  8002a0:	e8 f8 02 00 00       	call   80059d <cprintf>
  8002a5:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8002a8:	83 ec 0c             	sub    $0xc,%esp
  8002ab:	68 84 38 80 00       	push   $0x803884
  8002b0:	e8 e8 02 00 00       	call   80059d <cprintf>
  8002b5:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8002b8:	e8 f7 15 00 00       	call   8018b4 <sys_enable_interrupt>

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
  8002d0:	e8 84 17 00 00       	call   801a59 <sys_destroy_env>
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
  8002e1:	e8 d9 17 00 00       	call   801abf <sys_exit_env>
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
  80030a:	68 40 39 80 00       	push   $0x803940
  80030f:	e8 89 02 00 00       	call   80059d <cprintf>
  800314:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800317:	a1 00 50 80 00       	mov    0x805000,%eax
  80031c:	ff 75 0c             	pushl  0xc(%ebp)
  80031f:	ff 75 08             	pushl  0x8(%ebp)
  800322:	50                   	push   %eax
  800323:	68 45 39 80 00       	push   $0x803945
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
  800347:	68 61 39 80 00       	push   $0x803961
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
  800373:	68 64 39 80 00       	push   $0x803964
  800378:	6a 26                	push   $0x26
  80037a:	68 b0 39 80 00       	push   $0x8039b0
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
  800445:	68 bc 39 80 00       	push   $0x8039bc
  80044a:	6a 3a                	push   $0x3a
  80044c:	68 b0 39 80 00       	push   $0x8039b0
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
  8004b5:	68 10 3a 80 00       	push   $0x803a10
  8004ba:	6a 44                	push   $0x44
  8004bc:	68 b0 39 80 00       	push   $0x8039b0
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
  80050f:	e8 d8 11 00 00       	call   8016ec <sys_cputs>
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
  800586:	e8 61 11 00 00       	call   8016ec <sys_cputs>
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
  8005d0:	e8 c5 12 00 00       	call   80189a <sys_disable_interrupt>
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
  8005f0:	e8 bf 12 00 00       	call   8018b4 <sys_enable_interrupt>
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
  80063a:	e8 e5 2d 00 00       	call   803424 <__udivdi3>
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
  80068a:	e8 a5 2e 00 00       	call   803534 <__umoddi3>
  80068f:	83 c4 10             	add    $0x10,%esp
  800692:	05 74 3c 80 00       	add    $0x803c74,%eax
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
  8007e5:	8b 04 85 98 3c 80 00 	mov    0x803c98(,%eax,4),%eax
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
  8008c6:	8b 34 9d e0 3a 80 00 	mov    0x803ae0(,%ebx,4),%esi
  8008cd:	85 f6                	test   %esi,%esi
  8008cf:	75 19                	jne    8008ea <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008d1:	53                   	push   %ebx
  8008d2:	68 85 3c 80 00       	push   $0x803c85
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
  8008eb:	68 8e 3c 80 00       	push   $0x803c8e
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
  800918:	be 91 3c 80 00       	mov    $0x803c91,%esi
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
  80133e:	68 f0 3d 80 00       	push   $0x803df0
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
  80140e:	e8 1d 04 00 00       	call   801830 <sys_allocate_chunk>
  801413:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801416:	a1 20 51 80 00       	mov    0x805120,%eax
  80141b:	83 ec 0c             	sub    $0xc,%esp
  80141e:	50                   	push   %eax
  80141f:	e8 92 0a 00 00       	call   801eb6 <initialize_MemBlocksList>
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
  80144c:	68 15 3e 80 00       	push   $0x803e15
  801451:	6a 33                	push   $0x33
  801453:	68 33 3e 80 00       	push   $0x803e33
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
  8014cb:	68 40 3e 80 00       	push   $0x803e40
  8014d0:	6a 34                	push   $0x34
  8014d2:	68 33 3e 80 00       	push   $0x803e33
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
  801540:	68 64 3e 80 00       	push   $0x803e64
  801545:	6a 46                	push   $0x46
  801547:	68 33 3e 80 00       	push   $0x803e33
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
  80155c:	68 8c 3e 80 00       	push   $0x803e8c
  801561:	6a 61                	push   $0x61
  801563:	68 33 3e 80 00       	push   $0x803e33
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
  801582:	75 07                	jne    80158b <smalloc+0x1e>
  801584:	b8 00 00 00 00       	mov    $0x0,%eax
  801589:	eb 7c                	jmp    801607 <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  80158b:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801592:	8b 55 0c             	mov    0xc(%ebp),%edx
  801595:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801598:	01 d0                	add    %edx,%eax
  80159a:	48                   	dec    %eax
  80159b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80159e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015a1:	ba 00 00 00 00       	mov    $0x0,%edx
  8015a6:	f7 75 f0             	divl   -0x10(%ebp)
  8015a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015ac:	29 d0                	sub    %edx,%eax
  8015ae:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  8015b1:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8015b8:	e8 41 06 00 00       	call   801bfe <sys_isUHeapPlacementStrategyFIRSTFIT>
  8015bd:	85 c0                	test   %eax,%eax
  8015bf:	74 11                	je     8015d2 <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  8015c1:	83 ec 0c             	sub    $0xc,%esp
  8015c4:	ff 75 e8             	pushl  -0x18(%ebp)
  8015c7:	e8 ac 0c 00 00       	call   802278 <alloc_block_FF>
  8015cc:	83 c4 10             	add    $0x10,%esp
  8015cf:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  8015d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8015d6:	74 2a                	je     801602 <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8015d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015db:	8b 40 08             	mov    0x8(%eax),%eax
  8015de:	89 c2                	mov    %eax,%edx
  8015e0:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8015e4:	52                   	push   %edx
  8015e5:	50                   	push   %eax
  8015e6:	ff 75 0c             	pushl  0xc(%ebp)
  8015e9:	ff 75 08             	pushl  0x8(%ebp)
  8015ec:	e8 92 03 00 00       	call   801983 <sys_createSharedObject>
  8015f1:	83 c4 10             	add    $0x10,%esp
  8015f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  8015f7:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  8015fb:	74 05                	je     801602 <smalloc+0x95>
			return (void*)virtual_address;
  8015fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801600:	eb 05                	jmp    801607 <smalloc+0x9a>
	}
	return NULL;
  801602:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801607:	c9                   	leave  
  801608:	c3                   	ret    

00801609 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801609:	55                   	push   %ebp
  80160a:	89 e5                	mov    %esp,%ebp
  80160c:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80160f:	e8 13 fd ff ff       	call   801327 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801614:	83 ec 04             	sub    $0x4,%esp
  801617:	68 b0 3e 80 00       	push   $0x803eb0
  80161c:	68 a2 00 00 00       	push   $0xa2
  801621:	68 33 3e 80 00       	push   $0x803e33
  801626:	e8 be ec ff ff       	call   8002e9 <_panic>

0080162b <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80162b:	55                   	push   %ebp
  80162c:	89 e5                	mov    %esp,%ebp
  80162e:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801631:	e8 f1 fc ff ff       	call   801327 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801636:	83 ec 04             	sub    $0x4,%esp
  801639:	68 d4 3e 80 00       	push   $0x803ed4
  80163e:	68 e6 00 00 00       	push   $0xe6
  801643:	68 33 3e 80 00       	push   $0x803e33
  801648:	e8 9c ec ff ff       	call   8002e9 <_panic>

0080164d <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80164d:	55                   	push   %ebp
  80164e:	89 e5                	mov    %esp,%ebp
  801650:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801653:	83 ec 04             	sub    $0x4,%esp
  801656:	68 fc 3e 80 00       	push   $0x803efc
  80165b:	68 fa 00 00 00       	push   $0xfa
  801660:	68 33 3e 80 00       	push   $0x803e33
  801665:	e8 7f ec ff ff       	call   8002e9 <_panic>

0080166a <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80166a:	55                   	push   %ebp
  80166b:	89 e5                	mov    %esp,%ebp
  80166d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801670:	83 ec 04             	sub    $0x4,%esp
  801673:	68 20 3f 80 00       	push   $0x803f20
  801678:	68 05 01 00 00       	push   $0x105
  80167d:	68 33 3e 80 00       	push   $0x803e33
  801682:	e8 62 ec ff ff       	call   8002e9 <_panic>

00801687 <shrink>:

}
void shrink(uint32 newSize)
{
  801687:	55                   	push   %ebp
  801688:	89 e5                	mov    %esp,%ebp
  80168a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80168d:	83 ec 04             	sub    $0x4,%esp
  801690:	68 20 3f 80 00       	push   $0x803f20
  801695:	68 0a 01 00 00       	push   $0x10a
  80169a:	68 33 3e 80 00       	push   $0x803e33
  80169f:	e8 45 ec ff ff       	call   8002e9 <_panic>

008016a4 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8016a4:	55                   	push   %ebp
  8016a5:	89 e5                	mov    %esp,%ebp
  8016a7:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016aa:	83 ec 04             	sub    $0x4,%esp
  8016ad:	68 20 3f 80 00       	push   $0x803f20
  8016b2:	68 0f 01 00 00       	push   $0x10f
  8016b7:	68 33 3e 80 00       	push   $0x803e33
  8016bc:	e8 28 ec ff ff       	call   8002e9 <_panic>

008016c1 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8016c1:	55                   	push   %ebp
  8016c2:	89 e5                	mov    %esp,%ebp
  8016c4:	57                   	push   %edi
  8016c5:	56                   	push   %esi
  8016c6:	53                   	push   %ebx
  8016c7:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016d0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016d3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016d6:	8b 7d 18             	mov    0x18(%ebp),%edi
  8016d9:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8016dc:	cd 30                	int    $0x30
  8016de:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8016e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8016e4:	83 c4 10             	add    $0x10,%esp
  8016e7:	5b                   	pop    %ebx
  8016e8:	5e                   	pop    %esi
  8016e9:	5f                   	pop    %edi
  8016ea:	5d                   	pop    %ebp
  8016eb:	c3                   	ret    

008016ec <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8016ec:	55                   	push   %ebp
  8016ed:	89 e5                	mov    %esp,%ebp
  8016ef:	83 ec 04             	sub    $0x4,%esp
  8016f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8016f5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8016f8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8016fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ff:	6a 00                	push   $0x0
  801701:	6a 00                	push   $0x0
  801703:	52                   	push   %edx
  801704:	ff 75 0c             	pushl  0xc(%ebp)
  801707:	50                   	push   %eax
  801708:	6a 00                	push   $0x0
  80170a:	e8 b2 ff ff ff       	call   8016c1 <syscall>
  80170f:	83 c4 18             	add    $0x18,%esp
}
  801712:	90                   	nop
  801713:	c9                   	leave  
  801714:	c3                   	ret    

00801715 <sys_cgetc>:

int
sys_cgetc(void)
{
  801715:	55                   	push   %ebp
  801716:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801718:	6a 00                	push   $0x0
  80171a:	6a 00                	push   $0x0
  80171c:	6a 00                	push   $0x0
  80171e:	6a 00                	push   $0x0
  801720:	6a 00                	push   $0x0
  801722:	6a 01                	push   $0x1
  801724:	e8 98 ff ff ff       	call   8016c1 <syscall>
  801729:	83 c4 18             	add    $0x18,%esp
}
  80172c:	c9                   	leave  
  80172d:	c3                   	ret    

0080172e <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80172e:	55                   	push   %ebp
  80172f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801731:	8b 55 0c             	mov    0xc(%ebp),%edx
  801734:	8b 45 08             	mov    0x8(%ebp),%eax
  801737:	6a 00                	push   $0x0
  801739:	6a 00                	push   $0x0
  80173b:	6a 00                	push   $0x0
  80173d:	52                   	push   %edx
  80173e:	50                   	push   %eax
  80173f:	6a 05                	push   $0x5
  801741:	e8 7b ff ff ff       	call   8016c1 <syscall>
  801746:	83 c4 18             	add    $0x18,%esp
}
  801749:	c9                   	leave  
  80174a:	c3                   	ret    

0080174b <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80174b:	55                   	push   %ebp
  80174c:	89 e5                	mov    %esp,%ebp
  80174e:	56                   	push   %esi
  80174f:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801750:	8b 75 18             	mov    0x18(%ebp),%esi
  801753:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801756:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801759:	8b 55 0c             	mov    0xc(%ebp),%edx
  80175c:	8b 45 08             	mov    0x8(%ebp),%eax
  80175f:	56                   	push   %esi
  801760:	53                   	push   %ebx
  801761:	51                   	push   %ecx
  801762:	52                   	push   %edx
  801763:	50                   	push   %eax
  801764:	6a 06                	push   $0x6
  801766:	e8 56 ff ff ff       	call   8016c1 <syscall>
  80176b:	83 c4 18             	add    $0x18,%esp
}
  80176e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801771:	5b                   	pop    %ebx
  801772:	5e                   	pop    %esi
  801773:	5d                   	pop    %ebp
  801774:	c3                   	ret    

00801775 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801775:	55                   	push   %ebp
  801776:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801778:	8b 55 0c             	mov    0xc(%ebp),%edx
  80177b:	8b 45 08             	mov    0x8(%ebp),%eax
  80177e:	6a 00                	push   $0x0
  801780:	6a 00                	push   $0x0
  801782:	6a 00                	push   $0x0
  801784:	52                   	push   %edx
  801785:	50                   	push   %eax
  801786:	6a 07                	push   $0x7
  801788:	e8 34 ff ff ff       	call   8016c1 <syscall>
  80178d:	83 c4 18             	add    $0x18,%esp
}
  801790:	c9                   	leave  
  801791:	c3                   	ret    

00801792 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801792:	55                   	push   %ebp
  801793:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801795:	6a 00                	push   $0x0
  801797:	6a 00                	push   $0x0
  801799:	6a 00                	push   $0x0
  80179b:	ff 75 0c             	pushl  0xc(%ebp)
  80179e:	ff 75 08             	pushl  0x8(%ebp)
  8017a1:	6a 08                	push   $0x8
  8017a3:	e8 19 ff ff ff       	call   8016c1 <syscall>
  8017a8:	83 c4 18             	add    $0x18,%esp
}
  8017ab:	c9                   	leave  
  8017ac:	c3                   	ret    

008017ad <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8017ad:	55                   	push   %ebp
  8017ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8017b0:	6a 00                	push   $0x0
  8017b2:	6a 00                	push   $0x0
  8017b4:	6a 00                	push   $0x0
  8017b6:	6a 00                	push   $0x0
  8017b8:	6a 00                	push   $0x0
  8017ba:	6a 09                	push   $0x9
  8017bc:	e8 00 ff ff ff       	call   8016c1 <syscall>
  8017c1:	83 c4 18             	add    $0x18,%esp
}
  8017c4:	c9                   	leave  
  8017c5:	c3                   	ret    

008017c6 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8017c6:	55                   	push   %ebp
  8017c7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8017c9:	6a 00                	push   $0x0
  8017cb:	6a 00                	push   $0x0
  8017cd:	6a 00                	push   $0x0
  8017cf:	6a 00                	push   $0x0
  8017d1:	6a 00                	push   $0x0
  8017d3:	6a 0a                	push   $0xa
  8017d5:	e8 e7 fe ff ff       	call   8016c1 <syscall>
  8017da:	83 c4 18             	add    $0x18,%esp
}
  8017dd:	c9                   	leave  
  8017de:	c3                   	ret    

008017df <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8017df:	55                   	push   %ebp
  8017e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8017e2:	6a 00                	push   $0x0
  8017e4:	6a 00                	push   $0x0
  8017e6:	6a 00                	push   $0x0
  8017e8:	6a 00                	push   $0x0
  8017ea:	6a 00                	push   $0x0
  8017ec:	6a 0b                	push   $0xb
  8017ee:	e8 ce fe ff ff       	call   8016c1 <syscall>
  8017f3:	83 c4 18             	add    $0x18,%esp
}
  8017f6:	c9                   	leave  
  8017f7:	c3                   	ret    

008017f8 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8017f8:	55                   	push   %ebp
  8017f9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8017fb:	6a 00                	push   $0x0
  8017fd:	6a 00                	push   $0x0
  8017ff:	6a 00                	push   $0x0
  801801:	ff 75 0c             	pushl  0xc(%ebp)
  801804:	ff 75 08             	pushl  0x8(%ebp)
  801807:	6a 0f                	push   $0xf
  801809:	e8 b3 fe ff ff       	call   8016c1 <syscall>
  80180e:	83 c4 18             	add    $0x18,%esp
	return;
  801811:	90                   	nop
}
  801812:	c9                   	leave  
  801813:	c3                   	ret    

00801814 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801814:	55                   	push   %ebp
  801815:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801817:	6a 00                	push   $0x0
  801819:	6a 00                	push   $0x0
  80181b:	6a 00                	push   $0x0
  80181d:	ff 75 0c             	pushl  0xc(%ebp)
  801820:	ff 75 08             	pushl  0x8(%ebp)
  801823:	6a 10                	push   $0x10
  801825:	e8 97 fe ff ff       	call   8016c1 <syscall>
  80182a:	83 c4 18             	add    $0x18,%esp
	return ;
  80182d:	90                   	nop
}
  80182e:	c9                   	leave  
  80182f:	c3                   	ret    

00801830 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801830:	55                   	push   %ebp
  801831:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801833:	6a 00                	push   $0x0
  801835:	6a 00                	push   $0x0
  801837:	ff 75 10             	pushl  0x10(%ebp)
  80183a:	ff 75 0c             	pushl  0xc(%ebp)
  80183d:	ff 75 08             	pushl  0x8(%ebp)
  801840:	6a 11                	push   $0x11
  801842:	e8 7a fe ff ff       	call   8016c1 <syscall>
  801847:	83 c4 18             	add    $0x18,%esp
	return ;
  80184a:	90                   	nop
}
  80184b:	c9                   	leave  
  80184c:	c3                   	ret    

0080184d <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80184d:	55                   	push   %ebp
  80184e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801850:	6a 00                	push   $0x0
  801852:	6a 00                	push   $0x0
  801854:	6a 00                	push   $0x0
  801856:	6a 00                	push   $0x0
  801858:	6a 00                	push   $0x0
  80185a:	6a 0c                	push   $0xc
  80185c:	e8 60 fe ff ff       	call   8016c1 <syscall>
  801861:	83 c4 18             	add    $0x18,%esp
}
  801864:	c9                   	leave  
  801865:	c3                   	ret    

00801866 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801866:	55                   	push   %ebp
  801867:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801869:	6a 00                	push   $0x0
  80186b:	6a 00                	push   $0x0
  80186d:	6a 00                	push   $0x0
  80186f:	6a 00                	push   $0x0
  801871:	ff 75 08             	pushl  0x8(%ebp)
  801874:	6a 0d                	push   $0xd
  801876:	e8 46 fe ff ff       	call   8016c1 <syscall>
  80187b:	83 c4 18             	add    $0x18,%esp
}
  80187e:	c9                   	leave  
  80187f:	c3                   	ret    

00801880 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801880:	55                   	push   %ebp
  801881:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801883:	6a 00                	push   $0x0
  801885:	6a 00                	push   $0x0
  801887:	6a 00                	push   $0x0
  801889:	6a 00                	push   $0x0
  80188b:	6a 00                	push   $0x0
  80188d:	6a 0e                	push   $0xe
  80188f:	e8 2d fe ff ff       	call   8016c1 <syscall>
  801894:	83 c4 18             	add    $0x18,%esp
}
  801897:	90                   	nop
  801898:	c9                   	leave  
  801899:	c3                   	ret    

0080189a <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80189a:	55                   	push   %ebp
  80189b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80189d:	6a 00                	push   $0x0
  80189f:	6a 00                	push   $0x0
  8018a1:	6a 00                	push   $0x0
  8018a3:	6a 00                	push   $0x0
  8018a5:	6a 00                	push   $0x0
  8018a7:	6a 13                	push   $0x13
  8018a9:	e8 13 fe ff ff       	call   8016c1 <syscall>
  8018ae:	83 c4 18             	add    $0x18,%esp
}
  8018b1:	90                   	nop
  8018b2:	c9                   	leave  
  8018b3:	c3                   	ret    

008018b4 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8018b4:	55                   	push   %ebp
  8018b5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8018b7:	6a 00                	push   $0x0
  8018b9:	6a 00                	push   $0x0
  8018bb:	6a 00                	push   $0x0
  8018bd:	6a 00                	push   $0x0
  8018bf:	6a 00                	push   $0x0
  8018c1:	6a 14                	push   $0x14
  8018c3:	e8 f9 fd ff ff       	call   8016c1 <syscall>
  8018c8:	83 c4 18             	add    $0x18,%esp
}
  8018cb:	90                   	nop
  8018cc:	c9                   	leave  
  8018cd:	c3                   	ret    

008018ce <sys_cputc>:


void
sys_cputc(const char c)
{
  8018ce:	55                   	push   %ebp
  8018cf:	89 e5                	mov    %esp,%ebp
  8018d1:	83 ec 04             	sub    $0x4,%esp
  8018d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8018da:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 00                	push   $0x0
  8018e6:	50                   	push   %eax
  8018e7:	6a 15                	push   $0x15
  8018e9:	e8 d3 fd ff ff       	call   8016c1 <syscall>
  8018ee:	83 c4 18             	add    $0x18,%esp
}
  8018f1:	90                   	nop
  8018f2:	c9                   	leave  
  8018f3:	c3                   	ret    

008018f4 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8018f4:	55                   	push   %ebp
  8018f5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8018f7:	6a 00                	push   $0x0
  8018f9:	6a 00                	push   $0x0
  8018fb:	6a 00                	push   $0x0
  8018fd:	6a 00                	push   $0x0
  8018ff:	6a 00                	push   $0x0
  801901:	6a 16                	push   $0x16
  801903:	e8 b9 fd ff ff       	call   8016c1 <syscall>
  801908:	83 c4 18             	add    $0x18,%esp
}
  80190b:	90                   	nop
  80190c:	c9                   	leave  
  80190d:	c3                   	ret    

0080190e <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80190e:	55                   	push   %ebp
  80190f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801911:	8b 45 08             	mov    0x8(%ebp),%eax
  801914:	6a 00                	push   $0x0
  801916:	6a 00                	push   $0x0
  801918:	6a 00                	push   $0x0
  80191a:	ff 75 0c             	pushl  0xc(%ebp)
  80191d:	50                   	push   %eax
  80191e:	6a 17                	push   $0x17
  801920:	e8 9c fd ff ff       	call   8016c1 <syscall>
  801925:	83 c4 18             	add    $0x18,%esp
}
  801928:	c9                   	leave  
  801929:	c3                   	ret    

0080192a <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80192a:	55                   	push   %ebp
  80192b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80192d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801930:	8b 45 08             	mov    0x8(%ebp),%eax
  801933:	6a 00                	push   $0x0
  801935:	6a 00                	push   $0x0
  801937:	6a 00                	push   $0x0
  801939:	52                   	push   %edx
  80193a:	50                   	push   %eax
  80193b:	6a 1a                	push   $0x1a
  80193d:	e8 7f fd ff ff       	call   8016c1 <syscall>
  801942:	83 c4 18             	add    $0x18,%esp
}
  801945:	c9                   	leave  
  801946:	c3                   	ret    

00801947 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801947:	55                   	push   %ebp
  801948:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80194a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80194d:	8b 45 08             	mov    0x8(%ebp),%eax
  801950:	6a 00                	push   $0x0
  801952:	6a 00                	push   $0x0
  801954:	6a 00                	push   $0x0
  801956:	52                   	push   %edx
  801957:	50                   	push   %eax
  801958:	6a 18                	push   $0x18
  80195a:	e8 62 fd ff ff       	call   8016c1 <syscall>
  80195f:	83 c4 18             	add    $0x18,%esp
}
  801962:	90                   	nop
  801963:	c9                   	leave  
  801964:	c3                   	ret    

00801965 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801965:	55                   	push   %ebp
  801966:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801968:	8b 55 0c             	mov    0xc(%ebp),%edx
  80196b:	8b 45 08             	mov    0x8(%ebp),%eax
  80196e:	6a 00                	push   $0x0
  801970:	6a 00                	push   $0x0
  801972:	6a 00                	push   $0x0
  801974:	52                   	push   %edx
  801975:	50                   	push   %eax
  801976:	6a 19                	push   $0x19
  801978:	e8 44 fd ff ff       	call   8016c1 <syscall>
  80197d:	83 c4 18             	add    $0x18,%esp
}
  801980:	90                   	nop
  801981:	c9                   	leave  
  801982:	c3                   	ret    

00801983 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801983:	55                   	push   %ebp
  801984:	89 e5                	mov    %esp,%ebp
  801986:	83 ec 04             	sub    $0x4,%esp
  801989:	8b 45 10             	mov    0x10(%ebp),%eax
  80198c:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80198f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801992:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801996:	8b 45 08             	mov    0x8(%ebp),%eax
  801999:	6a 00                	push   $0x0
  80199b:	51                   	push   %ecx
  80199c:	52                   	push   %edx
  80199d:	ff 75 0c             	pushl  0xc(%ebp)
  8019a0:	50                   	push   %eax
  8019a1:	6a 1b                	push   $0x1b
  8019a3:	e8 19 fd ff ff       	call   8016c1 <syscall>
  8019a8:	83 c4 18             	add    $0x18,%esp
}
  8019ab:	c9                   	leave  
  8019ac:	c3                   	ret    

008019ad <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8019ad:	55                   	push   %ebp
  8019ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8019b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 00                	push   $0x0
  8019bc:	52                   	push   %edx
  8019bd:	50                   	push   %eax
  8019be:	6a 1c                	push   $0x1c
  8019c0:	e8 fc fc ff ff       	call   8016c1 <syscall>
  8019c5:	83 c4 18             	add    $0x18,%esp
}
  8019c8:	c9                   	leave  
  8019c9:	c3                   	ret    

008019ca <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8019ca:	55                   	push   %ebp
  8019cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8019cd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d6:	6a 00                	push   $0x0
  8019d8:	6a 00                	push   $0x0
  8019da:	51                   	push   %ecx
  8019db:	52                   	push   %edx
  8019dc:	50                   	push   %eax
  8019dd:	6a 1d                	push   $0x1d
  8019df:	e8 dd fc ff ff       	call   8016c1 <syscall>
  8019e4:	83 c4 18             	add    $0x18,%esp
}
  8019e7:	c9                   	leave  
  8019e8:	c3                   	ret    

008019e9 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8019e9:	55                   	push   %ebp
  8019ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8019ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f2:	6a 00                	push   $0x0
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 00                	push   $0x0
  8019f8:	52                   	push   %edx
  8019f9:	50                   	push   %eax
  8019fa:	6a 1e                	push   $0x1e
  8019fc:	e8 c0 fc ff ff       	call   8016c1 <syscall>
  801a01:	83 c4 18             	add    $0x18,%esp
}
  801a04:	c9                   	leave  
  801a05:	c3                   	ret    

00801a06 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801a06:	55                   	push   %ebp
  801a07:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801a09:	6a 00                	push   $0x0
  801a0b:	6a 00                	push   $0x0
  801a0d:	6a 00                	push   $0x0
  801a0f:	6a 00                	push   $0x0
  801a11:	6a 00                	push   $0x0
  801a13:	6a 1f                	push   $0x1f
  801a15:	e8 a7 fc ff ff       	call   8016c1 <syscall>
  801a1a:	83 c4 18             	add    $0x18,%esp
}
  801a1d:	c9                   	leave  
  801a1e:	c3                   	ret    

00801a1f <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a1f:	55                   	push   %ebp
  801a20:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a22:	8b 45 08             	mov    0x8(%ebp),%eax
  801a25:	6a 00                	push   $0x0
  801a27:	ff 75 14             	pushl  0x14(%ebp)
  801a2a:	ff 75 10             	pushl  0x10(%ebp)
  801a2d:	ff 75 0c             	pushl  0xc(%ebp)
  801a30:	50                   	push   %eax
  801a31:	6a 20                	push   $0x20
  801a33:	e8 89 fc ff ff       	call   8016c1 <syscall>
  801a38:	83 c4 18             	add    $0x18,%esp
}
  801a3b:	c9                   	leave  
  801a3c:	c3                   	ret    

00801a3d <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801a3d:	55                   	push   %ebp
  801a3e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a40:	8b 45 08             	mov    0x8(%ebp),%eax
  801a43:	6a 00                	push   $0x0
  801a45:	6a 00                	push   $0x0
  801a47:	6a 00                	push   $0x0
  801a49:	6a 00                	push   $0x0
  801a4b:	50                   	push   %eax
  801a4c:	6a 21                	push   $0x21
  801a4e:	e8 6e fc ff ff       	call   8016c1 <syscall>
  801a53:	83 c4 18             	add    $0x18,%esp
}
  801a56:	90                   	nop
  801a57:	c9                   	leave  
  801a58:	c3                   	ret    

00801a59 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801a59:	55                   	push   %ebp
  801a5a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 00                	push   $0x0
  801a63:	6a 00                	push   $0x0
  801a65:	6a 00                	push   $0x0
  801a67:	50                   	push   %eax
  801a68:	6a 22                	push   $0x22
  801a6a:	e8 52 fc ff ff       	call   8016c1 <syscall>
  801a6f:	83 c4 18             	add    $0x18,%esp
}
  801a72:	c9                   	leave  
  801a73:	c3                   	ret    

00801a74 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801a74:	55                   	push   %ebp
  801a75:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801a77:	6a 00                	push   $0x0
  801a79:	6a 00                	push   $0x0
  801a7b:	6a 00                	push   $0x0
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 02                	push   $0x2
  801a83:	e8 39 fc ff ff       	call   8016c1 <syscall>
  801a88:	83 c4 18             	add    $0x18,%esp
}
  801a8b:	c9                   	leave  
  801a8c:	c3                   	ret    

00801a8d <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801a8d:	55                   	push   %ebp
  801a8e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801a90:	6a 00                	push   $0x0
  801a92:	6a 00                	push   $0x0
  801a94:	6a 00                	push   $0x0
  801a96:	6a 00                	push   $0x0
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 03                	push   $0x3
  801a9c:	e8 20 fc ff ff       	call   8016c1 <syscall>
  801aa1:	83 c4 18             	add    $0x18,%esp
}
  801aa4:	c9                   	leave  
  801aa5:	c3                   	ret    

00801aa6 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801aa6:	55                   	push   %ebp
  801aa7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 00                	push   $0x0
  801aad:	6a 00                	push   $0x0
  801aaf:	6a 00                	push   $0x0
  801ab1:	6a 00                	push   $0x0
  801ab3:	6a 04                	push   $0x4
  801ab5:	e8 07 fc ff ff       	call   8016c1 <syscall>
  801aba:	83 c4 18             	add    $0x18,%esp
}
  801abd:	c9                   	leave  
  801abe:	c3                   	ret    

00801abf <sys_exit_env>:


void sys_exit_env(void)
{
  801abf:	55                   	push   %ebp
  801ac0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801ac2:	6a 00                	push   $0x0
  801ac4:	6a 00                	push   $0x0
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 00                	push   $0x0
  801aca:	6a 00                	push   $0x0
  801acc:	6a 23                	push   $0x23
  801ace:	e8 ee fb ff ff       	call   8016c1 <syscall>
  801ad3:	83 c4 18             	add    $0x18,%esp
}
  801ad6:	90                   	nop
  801ad7:	c9                   	leave  
  801ad8:	c3                   	ret    

00801ad9 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801ad9:	55                   	push   %ebp
  801ada:	89 e5                	mov    %esp,%ebp
  801adc:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801adf:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ae2:	8d 50 04             	lea    0x4(%eax),%edx
  801ae5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 00                	push   $0x0
  801aec:	6a 00                	push   $0x0
  801aee:	52                   	push   %edx
  801aef:	50                   	push   %eax
  801af0:	6a 24                	push   $0x24
  801af2:	e8 ca fb ff ff       	call   8016c1 <syscall>
  801af7:	83 c4 18             	add    $0x18,%esp
	return result;
  801afa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801afd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b00:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b03:	89 01                	mov    %eax,(%ecx)
  801b05:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b08:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0b:	c9                   	leave  
  801b0c:	c2 04 00             	ret    $0x4

00801b0f <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b0f:	55                   	push   %ebp
  801b10:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b12:	6a 00                	push   $0x0
  801b14:	6a 00                	push   $0x0
  801b16:	ff 75 10             	pushl  0x10(%ebp)
  801b19:	ff 75 0c             	pushl  0xc(%ebp)
  801b1c:	ff 75 08             	pushl  0x8(%ebp)
  801b1f:	6a 12                	push   $0x12
  801b21:	e8 9b fb ff ff       	call   8016c1 <syscall>
  801b26:	83 c4 18             	add    $0x18,%esp
	return ;
  801b29:	90                   	nop
}
  801b2a:	c9                   	leave  
  801b2b:	c3                   	ret    

00801b2c <sys_rcr2>:
uint32 sys_rcr2()
{
  801b2c:	55                   	push   %ebp
  801b2d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 00                	push   $0x0
  801b33:	6a 00                	push   $0x0
  801b35:	6a 00                	push   $0x0
  801b37:	6a 00                	push   $0x0
  801b39:	6a 25                	push   $0x25
  801b3b:	e8 81 fb ff ff       	call   8016c1 <syscall>
  801b40:	83 c4 18             	add    $0x18,%esp
}
  801b43:	c9                   	leave  
  801b44:	c3                   	ret    

00801b45 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801b45:	55                   	push   %ebp
  801b46:	89 e5                	mov    %esp,%ebp
  801b48:	83 ec 04             	sub    $0x4,%esp
  801b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801b51:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801b55:	6a 00                	push   $0x0
  801b57:	6a 00                	push   $0x0
  801b59:	6a 00                	push   $0x0
  801b5b:	6a 00                	push   $0x0
  801b5d:	50                   	push   %eax
  801b5e:	6a 26                	push   $0x26
  801b60:	e8 5c fb ff ff       	call   8016c1 <syscall>
  801b65:	83 c4 18             	add    $0x18,%esp
	return ;
  801b68:	90                   	nop
}
  801b69:	c9                   	leave  
  801b6a:	c3                   	ret    

00801b6b <rsttst>:
void rsttst()
{
  801b6b:	55                   	push   %ebp
  801b6c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801b6e:	6a 00                	push   $0x0
  801b70:	6a 00                	push   $0x0
  801b72:	6a 00                	push   $0x0
  801b74:	6a 00                	push   $0x0
  801b76:	6a 00                	push   $0x0
  801b78:	6a 28                	push   $0x28
  801b7a:	e8 42 fb ff ff       	call   8016c1 <syscall>
  801b7f:	83 c4 18             	add    $0x18,%esp
	return ;
  801b82:	90                   	nop
}
  801b83:	c9                   	leave  
  801b84:	c3                   	ret    

00801b85 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801b85:	55                   	push   %ebp
  801b86:	89 e5                	mov    %esp,%ebp
  801b88:	83 ec 04             	sub    $0x4,%esp
  801b8b:	8b 45 14             	mov    0x14(%ebp),%eax
  801b8e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801b91:	8b 55 18             	mov    0x18(%ebp),%edx
  801b94:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b98:	52                   	push   %edx
  801b99:	50                   	push   %eax
  801b9a:	ff 75 10             	pushl  0x10(%ebp)
  801b9d:	ff 75 0c             	pushl  0xc(%ebp)
  801ba0:	ff 75 08             	pushl  0x8(%ebp)
  801ba3:	6a 27                	push   $0x27
  801ba5:	e8 17 fb ff ff       	call   8016c1 <syscall>
  801baa:	83 c4 18             	add    $0x18,%esp
	return ;
  801bad:	90                   	nop
}
  801bae:	c9                   	leave  
  801baf:	c3                   	ret    

00801bb0 <chktst>:
void chktst(uint32 n)
{
  801bb0:	55                   	push   %ebp
  801bb1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801bb3:	6a 00                	push   $0x0
  801bb5:	6a 00                	push   $0x0
  801bb7:	6a 00                	push   $0x0
  801bb9:	6a 00                	push   $0x0
  801bbb:	ff 75 08             	pushl  0x8(%ebp)
  801bbe:	6a 29                	push   $0x29
  801bc0:	e8 fc fa ff ff       	call   8016c1 <syscall>
  801bc5:	83 c4 18             	add    $0x18,%esp
	return ;
  801bc8:	90                   	nop
}
  801bc9:	c9                   	leave  
  801bca:	c3                   	ret    

00801bcb <inctst>:

void inctst()
{
  801bcb:	55                   	push   %ebp
  801bcc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 2a                	push   $0x2a
  801bda:	e8 e2 fa ff ff       	call   8016c1 <syscall>
  801bdf:	83 c4 18             	add    $0x18,%esp
	return ;
  801be2:	90                   	nop
}
  801be3:	c9                   	leave  
  801be4:	c3                   	ret    

00801be5 <gettst>:
uint32 gettst()
{
  801be5:	55                   	push   %ebp
  801be6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801be8:	6a 00                	push   $0x0
  801bea:	6a 00                	push   $0x0
  801bec:	6a 00                	push   $0x0
  801bee:	6a 00                	push   $0x0
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 2b                	push   $0x2b
  801bf4:	e8 c8 fa ff ff       	call   8016c1 <syscall>
  801bf9:	83 c4 18             	add    $0x18,%esp
}
  801bfc:	c9                   	leave  
  801bfd:	c3                   	ret    

00801bfe <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801bfe:	55                   	push   %ebp
  801bff:	89 e5                	mov    %esp,%ebp
  801c01:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c04:	6a 00                	push   $0x0
  801c06:	6a 00                	push   $0x0
  801c08:	6a 00                	push   $0x0
  801c0a:	6a 00                	push   $0x0
  801c0c:	6a 00                	push   $0x0
  801c0e:	6a 2c                	push   $0x2c
  801c10:	e8 ac fa ff ff       	call   8016c1 <syscall>
  801c15:	83 c4 18             	add    $0x18,%esp
  801c18:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801c1b:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801c1f:	75 07                	jne    801c28 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801c21:	b8 01 00 00 00       	mov    $0x1,%eax
  801c26:	eb 05                	jmp    801c2d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801c28:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c2d:	c9                   	leave  
  801c2e:	c3                   	ret    

00801c2f <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801c2f:	55                   	push   %ebp
  801c30:	89 e5                	mov    %esp,%ebp
  801c32:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 00                	push   $0x0
  801c3f:	6a 2c                	push   $0x2c
  801c41:	e8 7b fa ff ff       	call   8016c1 <syscall>
  801c46:	83 c4 18             	add    $0x18,%esp
  801c49:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801c4c:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801c50:	75 07                	jne    801c59 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801c52:	b8 01 00 00 00       	mov    $0x1,%eax
  801c57:	eb 05                	jmp    801c5e <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801c59:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c5e:	c9                   	leave  
  801c5f:	c3                   	ret    

00801c60 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801c60:	55                   	push   %ebp
  801c61:	89 e5                	mov    %esp,%ebp
  801c63:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 00                	push   $0x0
  801c70:	6a 2c                	push   $0x2c
  801c72:	e8 4a fa ff ff       	call   8016c1 <syscall>
  801c77:	83 c4 18             	add    $0x18,%esp
  801c7a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801c7d:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801c81:	75 07                	jne    801c8a <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801c83:	b8 01 00 00 00       	mov    $0x1,%eax
  801c88:	eb 05                	jmp    801c8f <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801c8a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c8f:	c9                   	leave  
  801c90:	c3                   	ret    

00801c91 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801c91:	55                   	push   %ebp
  801c92:	89 e5                	mov    %esp,%ebp
  801c94:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c97:	6a 00                	push   $0x0
  801c99:	6a 00                	push   $0x0
  801c9b:	6a 00                	push   $0x0
  801c9d:	6a 00                	push   $0x0
  801c9f:	6a 00                	push   $0x0
  801ca1:	6a 2c                	push   $0x2c
  801ca3:	e8 19 fa ff ff       	call   8016c1 <syscall>
  801ca8:	83 c4 18             	add    $0x18,%esp
  801cab:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801cae:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801cb2:	75 07                	jne    801cbb <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801cb4:	b8 01 00 00 00       	mov    $0x1,%eax
  801cb9:	eb 05                	jmp    801cc0 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801cbb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cc0:	c9                   	leave  
  801cc1:	c3                   	ret    

00801cc2 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801cc2:	55                   	push   %ebp
  801cc3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801cc5:	6a 00                	push   $0x0
  801cc7:	6a 00                	push   $0x0
  801cc9:	6a 00                	push   $0x0
  801ccb:	6a 00                	push   $0x0
  801ccd:	ff 75 08             	pushl  0x8(%ebp)
  801cd0:	6a 2d                	push   $0x2d
  801cd2:	e8 ea f9 ff ff       	call   8016c1 <syscall>
  801cd7:	83 c4 18             	add    $0x18,%esp
	return ;
  801cda:	90                   	nop
}
  801cdb:	c9                   	leave  
  801cdc:	c3                   	ret    

00801cdd <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801cdd:	55                   	push   %ebp
  801cde:	89 e5                	mov    %esp,%ebp
  801ce0:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ce1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ce4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ce7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cea:	8b 45 08             	mov    0x8(%ebp),%eax
  801ced:	6a 00                	push   $0x0
  801cef:	53                   	push   %ebx
  801cf0:	51                   	push   %ecx
  801cf1:	52                   	push   %edx
  801cf2:	50                   	push   %eax
  801cf3:	6a 2e                	push   $0x2e
  801cf5:	e8 c7 f9 ff ff       	call   8016c1 <syscall>
  801cfa:	83 c4 18             	add    $0x18,%esp
}
  801cfd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d00:	c9                   	leave  
  801d01:	c3                   	ret    

00801d02 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801d02:	55                   	push   %ebp
  801d03:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801d05:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d08:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0b:	6a 00                	push   $0x0
  801d0d:	6a 00                	push   $0x0
  801d0f:	6a 00                	push   $0x0
  801d11:	52                   	push   %edx
  801d12:	50                   	push   %eax
  801d13:	6a 2f                	push   $0x2f
  801d15:	e8 a7 f9 ff ff       	call   8016c1 <syscall>
  801d1a:	83 c4 18             	add    $0x18,%esp
}
  801d1d:	c9                   	leave  
  801d1e:	c3                   	ret    

00801d1f <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801d1f:	55                   	push   %ebp
  801d20:	89 e5                	mov    %esp,%ebp
  801d22:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801d25:	83 ec 0c             	sub    $0xc,%esp
  801d28:	68 30 3f 80 00       	push   $0x803f30
  801d2d:	e8 6b e8 ff ff       	call   80059d <cprintf>
  801d32:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801d35:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801d3c:	83 ec 0c             	sub    $0xc,%esp
  801d3f:	68 5c 3f 80 00       	push   $0x803f5c
  801d44:	e8 54 e8 ff ff       	call   80059d <cprintf>
  801d49:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801d4c:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d50:	a1 38 51 80 00       	mov    0x805138,%eax
  801d55:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d58:	eb 56                	jmp    801db0 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801d5a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d5e:	74 1c                	je     801d7c <print_mem_block_lists+0x5d>
  801d60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d63:	8b 50 08             	mov    0x8(%eax),%edx
  801d66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d69:	8b 48 08             	mov    0x8(%eax),%ecx
  801d6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d6f:	8b 40 0c             	mov    0xc(%eax),%eax
  801d72:	01 c8                	add    %ecx,%eax
  801d74:	39 c2                	cmp    %eax,%edx
  801d76:	73 04                	jae    801d7c <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801d78:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801d7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d7f:	8b 50 08             	mov    0x8(%eax),%edx
  801d82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d85:	8b 40 0c             	mov    0xc(%eax),%eax
  801d88:	01 c2                	add    %eax,%edx
  801d8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d8d:	8b 40 08             	mov    0x8(%eax),%eax
  801d90:	83 ec 04             	sub    $0x4,%esp
  801d93:	52                   	push   %edx
  801d94:	50                   	push   %eax
  801d95:	68 71 3f 80 00       	push   $0x803f71
  801d9a:	e8 fe e7 ff ff       	call   80059d <cprintf>
  801d9f:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801da2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801da5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801da8:	a1 40 51 80 00       	mov    0x805140,%eax
  801dad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801db0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801db4:	74 07                	je     801dbd <print_mem_block_lists+0x9e>
  801db6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db9:	8b 00                	mov    (%eax),%eax
  801dbb:	eb 05                	jmp    801dc2 <print_mem_block_lists+0xa3>
  801dbd:	b8 00 00 00 00       	mov    $0x0,%eax
  801dc2:	a3 40 51 80 00       	mov    %eax,0x805140
  801dc7:	a1 40 51 80 00       	mov    0x805140,%eax
  801dcc:	85 c0                	test   %eax,%eax
  801dce:	75 8a                	jne    801d5a <print_mem_block_lists+0x3b>
  801dd0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801dd4:	75 84                	jne    801d5a <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801dd6:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801dda:	75 10                	jne    801dec <print_mem_block_lists+0xcd>
  801ddc:	83 ec 0c             	sub    $0xc,%esp
  801ddf:	68 80 3f 80 00       	push   $0x803f80
  801de4:	e8 b4 e7 ff ff       	call   80059d <cprintf>
  801de9:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801dec:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801df3:	83 ec 0c             	sub    $0xc,%esp
  801df6:	68 a4 3f 80 00       	push   $0x803fa4
  801dfb:	e8 9d e7 ff ff       	call   80059d <cprintf>
  801e00:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801e03:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801e07:	a1 40 50 80 00       	mov    0x805040,%eax
  801e0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e0f:	eb 56                	jmp    801e67 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e11:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e15:	74 1c                	je     801e33 <print_mem_block_lists+0x114>
  801e17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e1a:	8b 50 08             	mov    0x8(%eax),%edx
  801e1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e20:	8b 48 08             	mov    0x8(%eax),%ecx
  801e23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e26:	8b 40 0c             	mov    0xc(%eax),%eax
  801e29:	01 c8                	add    %ecx,%eax
  801e2b:	39 c2                	cmp    %eax,%edx
  801e2d:	73 04                	jae    801e33 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801e2f:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e36:	8b 50 08             	mov    0x8(%eax),%edx
  801e39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e3c:	8b 40 0c             	mov    0xc(%eax),%eax
  801e3f:	01 c2                	add    %eax,%edx
  801e41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e44:	8b 40 08             	mov    0x8(%eax),%eax
  801e47:	83 ec 04             	sub    $0x4,%esp
  801e4a:	52                   	push   %edx
  801e4b:	50                   	push   %eax
  801e4c:	68 71 3f 80 00       	push   $0x803f71
  801e51:	e8 47 e7 ff ff       	call   80059d <cprintf>
  801e56:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801e5f:	a1 48 50 80 00       	mov    0x805048,%eax
  801e64:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e67:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e6b:	74 07                	je     801e74 <print_mem_block_lists+0x155>
  801e6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e70:	8b 00                	mov    (%eax),%eax
  801e72:	eb 05                	jmp    801e79 <print_mem_block_lists+0x15a>
  801e74:	b8 00 00 00 00       	mov    $0x0,%eax
  801e79:	a3 48 50 80 00       	mov    %eax,0x805048
  801e7e:	a1 48 50 80 00       	mov    0x805048,%eax
  801e83:	85 c0                	test   %eax,%eax
  801e85:	75 8a                	jne    801e11 <print_mem_block_lists+0xf2>
  801e87:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e8b:	75 84                	jne    801e11 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801e8d:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e91:	75 10                	jne    801ea3 <print_mem_block_lists+0x184>
  801e93:	83 ec 0c             	sub    $0xc,%esp
  801e96:	68 bc 3f 80 00       	push   $0x803fbc
  801e9b:	e8 fd e6 ff ff       	call   80059d <cprintf>
  801ea0:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801ea3:	83 ec 0c             	sub    $0xc,%esp
  801ea6:	68 30 3f 80 00       	push   $0x803f30
  801eab:	e8 ed e6 ff ff       	call   80059d <cprintf>
  801eb0:	83 c4 10             	add    $0x10,%esp

}
  801eb3:	90                   	nop
  801eb4:	c9                   	leave  
  801eb5:	c3                   	ret    

00801eb6 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801eb6:	55                   	push   %ebp
  801eb7:	89 e5                	mov    %esp,%ebp
  801eb9:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801ebc:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  801ec3:	00 00 00 
  801ec6:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  801ecd:	00 00 00 
  801ed0:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  801ed7:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801eda:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801ee1:	e9 9e 00 00 00       	jmp    801f84 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801ee6:	a1 50 50 80 00       	mov    0x805050,%eax
  801eeb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801eee:	c1 e2 04             	shl    $0x4,%edx
  801ef1:	01 d0                	add    %edx,%eax
  801ef3:	85 c0                	test   %eax,%eax
  801ef5:	75 14                	jne    801f0b <initialize_MemBlocksList+0x55>
  801ef7:	83 ec 04             	sub    $0x4,%esp
  801efa:	68 e4 3f 80 00       	push   $0x803fe4
  801eff:	6a 46                	push   $0x46
  801f01:	68 07 40 80 00       	push   $0x804007
  801f06:	e8 de e3 ff ff       	call   8002e9 <_panic>
  801f0b:	a1 50 50 80 00       	mov    0x805050,%eax
  801f10:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f13:	c1 e2 04             	shl    $0x4,%edx
  801f16:	01 d0                	add    %edx,%eax
  801f18:	8b 15 48 51 80 00    	mov    0x805148,%edx
  801f1e:	89 10                	mov    %edx,(%eax)
  801f20:	8b 00                	mov    (%eax),%eax
  801f22:	85 c0                	test   %eax,%eax
  801f24:	74 18                	je     801f3e <initialize_MemBlocksList+0x88>
  801f26:	a1 48 51 80 00       	mov    0x805148,%eax
  801f2b:	8b 15 50 50 80 00    	mov    0x805050,%edx
  801f31:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801f34:	c1 e1 04             	shl    $0x4,%ecx
  801f37:	01 ca                	add    %ecx,%edx
  801f39:	89 50 04             	mov    %edx,0x4(%eax)
  801f3c:	eb 12                	jmp    801f50 <initialize_MemBlocksList+0x9a>
  801f3e:	a1 50 50 80 00       	mov    0x805050,%eax
  801f43:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f46:	c1 e2 04             	shl    $0x4,%edx
  801f49:	01 d0                	add    %edx,%eax
  801f4b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801f50:	a1 50 50 80 00       	mov    0x805050,%eax
  801f55:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f58:	c1 e2 04             	shl    $0x4,%edx
  801f5b:	01 d0                	add    %edx,%eax
  801f5d:	a3 48 51 80 00       	mov    %eax,0x805148
  801f62:	a1 50 50 80 00       	mov    0x805050,%eax
  801f67:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f6a:	c1 e2 04             	shl    $0x4,%edx
  801f6d:	01 d0                	add    %edx,%eax
  801f6f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f76:	a1 54 51 80 00       	mov    0x805154,%eax
  801f7b:	40                   	inc    %eax
  801f7c:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801f81:	ff 45 f4             	incl   -0xc(%ebp)
  801f84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f87:	3b 45 08             	cmp    0x8(%ebp),%eax
  801f8a:	0f 82 56 ff ff ff    	jb     801ee6 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801f90:	90                   	nop
  801f91:	c9                   	leave  
  801f92:	c3                   	ret    

00801f93 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801f93:	55                   	push   %ebp
  801f94:	89 e5                	mov    %esp,%ebp
  801f96:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801f99:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9c:	8b 00                	mov    (%eax),%eax
  801f9e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801fa1:	eb 19                	jmp    801fbc <find_block+0x29>
	{
		if(va==point->sva)
  801fa3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fa6:	8b 40 08             	mov    0x8(%eax),%eax
  801fa9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801fac:	75 05                	jne    801fb3 <find_block+0x20>
		   return point;
  801fae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fb1:	eb 36                	jmp    801fe9 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb6:	8b 40 08             	mov    0x8(%eax),%eax
  801fb9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801fbc:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801fc0:	74 07                	je     801fc9 <find_block+0x36>
  801fc2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fc5:	8b 00                	mov    (%eax),%eax
  801fc7:	eb 05                	jmp    801fce <find_block+0x3b>
  801fc9:	b8 00 00 00 00       	mov    $0x0,%eax
  801fce:	8b 55 08             	mov    0x8(%ebp),%edx
  801fd1:	89 42 08             	mov    %eax,0x8(%edx)
  801fd4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd7:	8b 40 08             	mov    0x8(%eax),%eax
  801fda:	85 c0                	test   %eax,%eax
  801fdc:	75 c5                	jne    801fa3 <find_block+0x10>
  801fde:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801fe2:	75 bf                	jne    801fa3 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  801fe4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fe9:	c9                   	leave  
  801fea:	c3                   	ret    

00801feb <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  801feb:	55                   	push   %ebp
  801fec:	89 e5                	mov    %esp,%ebp
  801fee:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  801ff1:	a1 40 50 80 00       	mov    0x805040,%eax
  801ff6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  801ff9:	a1 44 50 80 00       	mov    0x805044,%eax
  801ffe:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802001:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802004:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802007:	74 24                	je     80202d <insert_sorted_allocList+0x42>
  802009:	8b 45 08             	mov    0x8(%ebp),%eax
  80200c:	8b 50 08             	mov    0x8(%eax),%edx
  80200f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802012:	8b 40 08             	mov    0x8(%eax),%eax
  802015:	39 c2                	cmp    %eax,%edx
  802017:	76 14                	jbe    80202d <insert_sorted_allocList+0x42>
  802019:	8b 45 08             	mov    0x8(%ebp),%eax
  80201c:	8b 50 08             	mov    0x8(%eax),%edx
  80201f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802022:	8b 40 08             	mov    0x8(%eax),%eax
  802025:	39 c2                	cmp    %eax,%edx
  802027:	0f 82 60 01 00 00    	jb     80218d <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  80202d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802031:	75 65                	jne    802098 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802033:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802037:	75 14                	jne    80204d <insert_sorted_allocList+0x62>
  802039:	83 ec 04             	sub    $0x4,%esp
  80203c:	68 e4 3f 80 00       	push   $0x803fe4
  802041:	6a 6b                	push   $0x6b
  802043:	68 07 40 80 00       	push   $0x804007
  802048:	e8 9c e2 ff ff       	call   8002e9 <_panic>
  80204d:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802053:	8b 45 08             	mov    0x8(%ebp),%eax
  802056:	89 10                	mov    %edx,(%eax)
  802058:	8b 45 08             	mov    0x8(%ebp),%eax
  80205b:	8b 00                	mov    (%eax),%eax
  80205d:	85 c0                	test   %eax,%eax
  80205f:	74 0d                	je     80206e <insert_sorted_allocList+0x83>
  802061:	a1 40 50 80 00       	mov    0x805040,%eax
  802066:	8b 55 08             	mov    0x8(%ebp),%edx
  802069:	89 50 04             	mov    %edx,0x4(%eax)
  80206c:	eb 08                	jmp    802076 <insert_sorted_allocList+0x8b>
  80206e:	8b 45 08             	mov    0x8(%ebp),%eax
  802071:	a3 44 50 80 00       	mov    %eax,0x805044
  802076:	8b 45 08             	mov    0x8(%ebp),%eax
  802079:	a3 40 50 80 00       	mov    %eax,0x805040
  80207e:	8b 45 08             	mov    0x8(%ebp),%eax
  802081:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802088:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80208d:	40                   	inc    %eax
  80208e:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802093:	e9 dc 01 00 00       	jmp    802274 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802098:	8b 45 08             	mov    0x8(%ebp),%eax
  80209b:	8b 50 08             	mov    0x8(%eax),%edx
  80209e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020a1:	8b 40 08             	mov    0x8(%eax),%eax
  8020a4:	39 c2                	cmp    %eax,%edx
  8020a6:	77 6c                	ja     802114 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8020a8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020ac:	74 06                	je     8020b4 <insert_sorted_allocList+0xc9>
  8020ae:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020b2:	75 14                	jne    8020c8 <insert_sorted_allocList+0xdd>
  8020b4:	83 ec 04             	sub    $0x4,%esp
  8020b7:	68 20 40 80 00       	push   $0x804020
  8020bc:	6a 6f                	push   $0x6f
  8020be:	68 07 40 80 00       	push   $0x804007
  8020c3:	e8 21 e2 ff ff       	call   8002e9 <_panic>
  8020c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020cb:	8b 50 04             	mov    0x4(%eax),%edx
  8020ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d1:	89 50 04             	mov    %edx,0x4(%eax)
  8020d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8020da:	89 10                	mov    %edx,(%eax)
  8020dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020df:	8b 40 04             	mov    0x4(%eax),%eax
  8020e2:	85 c0                	test   %eax,%eax
  8020e4:	74 0d                	je     8020f3 <insert_sorted_allocList+0x108>
  8020e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020e9:	8b 40 04             	mov    0x4(%eax),%eax
  8020ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8020ef:	89 10                	mov    %edx,(%eax)
  8020f1:	eb 08                	jmp    8020fb <insert_sorted_allocList+0x110>
  8020f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f6:	a3 40 50 80 00       	mov    %eax,0x805040
  8020fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020fe:	8b 55 08             	mov    0x8(%ebp),%edx
  802101:	89 50 04             	mov    %edx,0x4(%eax)
  802104:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802109:	40                   	inc    %eax
  80210a:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80210f:	e9 60 01 00 00       	jmp    802274 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802114:	8b 45 08             	mov    0x8(%ebp),%eax
  802117:	8b 50 08             	mov    0x8(%eax),%edx
  80211a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80211d:	8b 40 08             	mov    0x8(%eax),%eax
  802120:	39 c2                	cmp    %eax,%edx
  802122:	0f 82 4c 01 00 00    	jb     802274 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802128:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80212c:	75 14                	jne    802142 <insert_sorted_allocList+0x157>
  80212e:	83 ec 04             	sub    $0x4,%esp
  802131:	68 58 40 80 00       	push   $0x804058
  802136:	6a 73                	push   $0x73
  802138:	68 07 40 80 00       	push   $0x804007
  80213d:	e8 a7 e1 ff ff       	call   8002e9 <_panic>
  802142:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802148:	8b 45 08             	mov    0x8(%ebp),%eax
  80214b:	89 50 04             	mov    %edx,0x4(%eax)
  80214e:	8b 45 08             	mov    0x8(%ebp),%eax
  802151:	8b 40 04             	mov    0x4(%eax),%eax
  802154:	85 c0                	test   %eax,%eax
  802156:	74 0c                	je     802164 <insert_sorted_allocList+0x179>
  802158:	a1 44 50 80 00       	mov    0x805044,%eax
  80215d:	8b 55 08             	mov    0x8(%ebp),%edx
  802160:	89 10                	mov    %edx,(%eax)
  802162:	eb 08                	jmp    80216c <insert_sorted_allocList+0x181>
  802164:	8b 45 08             	mov    0x8(%ebp),%eax
  802167:	a3 40 50 80 00       	mov    %eax,0x805040
  80216c:	8b 45 08             	mov    0x8(%ebp),%eax
  80216f:	a3 44 50 80 00       	mov    %eax,0x805044
  802174:	8b 45 08             	mov    0x8(%ebp),%eax
  802177:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80217d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802182:	40                   	inc    %eax
  802183:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802188:	e9 e7 00 00 00       	jmp    802274 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  80218d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802190:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802193:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80219a:	a1 40 50 80 00       	mov    0x805040,%eax
  80219f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021a2:	e9 9d 00 00 00       	jmp    802244 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8021a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021aa:	8b 00                	mov    (%eax),%eax
  8021ac:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8021af:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b2:	8b 50 08             	mov    0x8(%eax),%edx
  8021b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b8:	8b 40 08             	mov    0x8(%eax),%eax
  8021bb:	39 c2                	cmp    %eax,%edx
  8021bd:	76 7d                	jbe    80223c <insert_sorted_allocList+0x251>
  8021bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c2:	8b 50 08             	mov    0x8(%eax),%edx
  8021c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8021c8:	8b 40 08             	mov    0x8(%eax),%eax
  8021cb:	39 c2                	cmp    %eax,%edx
  8021cd:	73 6d                	jae    80223c <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8021cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021d3:	74 06                	je     8021db <insert_sorted_allocList+0x1f0>
  8021d5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021d9:	75 14                	jne    8021ef <insert_sorted_allocList+0x204>
  8021db:	83 ec 04             	sub    $0x4,%esp
  8021de:	68 7c 40 80 00       	push   $0x80407c
  8021e3:	6a 7f                	push   $0x7f
  8021e5:	68 07 40 80 00       	push   $0x804007
  8021ea:	e8 fa e0 ff ff       	call   8002e9 <_panic>
  8021ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f2:	8b 10                	mov    (%eax),%edx
  8021f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f7:	89 10                	mov    %edx,(%eax)
  8021f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fc:	8b 00                	mov    (%eax),%eax
  8021fe:	85 c0                	test   %eax,%eax
  802200:	74 0b                	je     80220d <insert_sorted_allocList+0x222>
  802202:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802205:	8b 00                	mov    (%eax),%eax
  802207:	8b 55 08             	mov    0x8(%ebp),%edx
  80220a:	89 50 04             	mov    %edx,0x4(%eax)
  80220d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802210:	8b 55 08             	mov    0x8(%ebp),%edx
  802213:	89 10                	mov    %edx,(%eax)
  802215:	8b 45 08             	mov    0x8(%ebp),%eax
  802218:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80221b:	89 50 04             	mov    %edx,0x4(%eax)
  80221e:	8b 45 08             	mov    0x8(%ebp),%eax
  802221:	8b 00                	mov    (%eax),%eax
  802223:	85 c0                	test   %eax,%eax
  802225:	75 08                	jne    80222f <insert_sorted_allocList+0x244>
  802227:	8b 45 08             	mov    0x8(%ebp),%eax
  80222a:	a3 44 50 80 00       	mov    %eax,0x805044
  80222f:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802234:	40                   	inc    %eax
  802235:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  80223a:	eb 39                	jmp    802275 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80223c:	a1 48 50 80 00       	mov    0x805048,%eax
  802241:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802244:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802248:	74 07                	je     802251 <insert_sorted_allocList+0x266>
  80224a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224d:	8b 00                	mov    (%eax),%eax
  80224f:	eb 05                	jmp    802256 <insert_sorted_allocList+0x26b>
  802251:	b8 00 00 00 00       	mov    $0x0,%eax
  802256:	a3 48 50 80 00       	mov    %eax,0x805048
  80225b:	a1 48 50 80 00       	mov    0x805048,%eax
  802260:	85 c0                	test   %eax,%eax
  802262:	0f 85 3f ff ff ff    	jne    8021a7 <insert_sorted_allocList+0x1bc>
  802268:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80226c:	0f 85 35 ff ff ff    	jne    8021a7 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802272:	eb 01                	jmp    802275 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802274:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802275:	90                   	nop
  802276:	c9                   	leave  
  802277:	c3                   	ret    

00802278 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802278:	55                   	push   %ebp
  802279:	89 e5                	mov    %esp,%ebp
  80227b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80227e:	a1 38 51 80 00       	mov    0x805138,%eax
  802283:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802286:	e9 85 01 00 00       	jmp    802410 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  80228b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228e:	8b 40 0c             	mov    0xc(%eax),%eax
  802291:	3b 45 08             	cmp    0x8(%ebp),%eax
  802294:	0f 82 6e 01 00 00    	jb     802408 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  80229a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229d:	8b 40 0c             	mov    0xc(%eax),%eax
  8022a0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022a3:	0f 85 8a 00 00 00    	jne    802333 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8022a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022ad:	75 17                	jne    8022c6 <alloc_block_FF+0x4e>
  8022af:	83 ec 04             	sub    $0x4,%esp
  8022b2:	68 b0 40 80 00       	push   $0x8040b0
  8022b7:	68 93 00 00 00       	push   $0x93
  8022bc:	68 07 40 80 00       	push   $0x804007
  8022c1:	e8 23 e0 ff ff       	call   8002e9 <_panic>
  8022c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c9:	8b 00                	mov    (%eax),%eax
  8022cb:	85 c0                	test   %eax,%eax
  8022cd:	74 10                	je     8022df <alloc_block_FF+0x67>
  8022cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d2:	8b 00                	mov    (%eax),%eax
  8022d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022d7:	8b 52 04             	mov    0x4(%edx),%edx
  8022da:	89 50 04             	mov    %edx,0x4(%eax)
  8022dd:	eb 0b                	jmp    8022ea <alloc_block_FF+0x72>
  8022df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e2:	8b 40 04             	mov    0x4(%eax),%eax
  8022e5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8022ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ed:	8b 40 04             	mov    0x4(%eax),%eax
  8022f0:	85 c0                	test   %eax,%eax
  8022f2:	74 0f                	je     802303 <alloc_block_FF+0x8b>
  8022f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f7:	8b 40 04             	mov    0x4(%eax),%eax
  8022fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022fd:	8b 12                	mov    (%edx),%edx
  8022ff:	89 10                	mov    %edx,(%eax)
  802301:	eb 0a                	jmp    80230d <alloc_block_FF+0x95>
  802303:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802306:	8b 00                	mov    (%eax),%eax
  802308:	a3 38 51 80 00       	mov    %eax,0x805138
  80230d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802310:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802316:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802319:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802320:	a1 44 51 80 00       	mov    0x805144,%eax
  802325:	48                   	dec    %eax
  802326:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  80232b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232e:	e9 10 01 00 00       	jmp    802443 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802333:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802336:	8b 40 0c             	mov    0xc(%eax),%eax
  802339:	3b 45 08             	cmp    0x8(%ebp),%eax
  80233c:	0f 86 c6 00 00 00    	jbe    802408 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802342:	a1 48 51 80 00       	mov    0x805148,%eax
  802347:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  80234a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234d:	8b 50 08             	mov    0x8(%eax),%edx
  802350:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802353:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802356:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802359:	8b 55 08             	mov    0x8(%ebp),%edx
  80235c:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80235f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802363:	75 17                	jne    80237c <alloc_block_FF+0x104>
  802365:	83 ec 04             	sub    $0x4,%esp
  802368:	68 b0 40 80 00       	push   $0x8040b0
  80236d:	68 9b 00 00 00       	push   $0x9b
  802372:	68 07 40 80 00       	push   $0x804007
  802377:	e8 6d df ff ff       	call   8002e9 <_panic>
  80237c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80237f:	8b 00                	mov    (%eax),%eax
  802381:	85 c0                	test   %eax,%eax
  802383:	74 10                	je     802395 <alloc_block_FF+0x11d>
  802385:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802388:	8b 00                	mov    (%eax),%eax
  80238a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80238d:	8b 52 04             	mov    0x4(%edx),%edx
  802390:	89 50 04             	mov    %edx,0x4(%eax)
  802393:	eb 0b                	jmp    8023a0 <alloc_block_FF+0x128>
  802395:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802398:	8b 40 04             	mov    0x4(%eax),%eax
  80239b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8023a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023a3:	8b 40 04             	mov    0x4(%eax),%eax
  8023a6:	85 c0                	test   %eax,%eax
  8023a8:	74 0f                	je     8023b9 <alloc_block_FF+0x141>
  8023aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ad:	8b 40 04             	mov    0x4(%eax),%eax
  8023b0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023b3:	8b 12                	mov    (%edx),%edx
  8023b5:	89 10                	mov    %edx,(%eax)
  8023b7:	eb 0a                	jmp    8023c3 <alloc_block_FF+0x14b>
  8023b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023bc:	8b 00                	mov    (%eax),%eax
  8023be:	a3 48 51 80 00       	mov    %eax,0x805148
  8023c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023cf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023d6:	a1 54 51 80 00       	mov    0x805154,%eax
  8023db:	48                   	dec    %eax
  8023dc:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  8023e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e4:	8b 50 08             	mov    0x8(%eax),%edx
  8023e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ea:	01 c2                	add    %eax,%edx
  8023ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ef:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8023f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f5:	8b 40 0c             	mov    0xc(%eax),%eax
  8023f8:	2b 45 08             	sub    0x8(%ebp),%eax
  8023fb:	89 c2                	mov    %eax,%edx
  8023fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802400:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802403:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802406:	eb 3b                	jmp    802443 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802408:	a1 40 51 80 00       	mov    0x805140,%eax
  80240d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802410:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802414:	74 07                	je     80241d <alloc_block_FF+0x1a5>
  802416:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802419:	8b 00                	mov    (%eax),%eax
  80241b:	eb 05                	jmp    802422 <alloc_block_FF+0x1aa>
  80241d:	b8 00 00 00 00       	mov    $0x0,%eax
  802422:	a3 40 51 80 00       	mov    %eax,0x805140
  802427:	a1 40 51 80 00       	mov    0x805140,%eax
  80242c:	85 c0                	test   %eax,%eax
  80242e:	0f 85 57 fe ff ff    	jne    80228b <alloc_block_FF+0x13>
  802434:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802438:	0f 85 4d fe ff ff    	jne    80228b <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  80243e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802443:	c9                   	leave  
  802444:	c3                   	ret    

00802445 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802445:	55                   	push   %ebp
  802446:	89 e5                	mov    %esp,%ebp
  802448:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  80244b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802452:	a1 38 51 80 00       	mov    0x805138,%eax
  802457:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80245a:	e9 df 00 00 00       	jmp    80253e <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  80245f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802462:	8b 40 0c             	mov    0xc(%eax),%eax
  802465:	3b 45 08             	cmp    0x8(%ebp),%eax
  802468:	0f 82 c8 00 00 00    	jb     802536 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  80246e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802471:	8b 40 0c             	mov    0xc(%eax),%eax
  802474:	3b 45 08             	cmp    0x8(%ebp),%eax
  802477:	0f 85 8a 00 00 00    	jne    802507 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  80247d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802481:	75 17                	jne    80249a <alloc_block_BF+0x55>
  802483:	83 ec 04             	sub    $0x4,%esp
  802486:	68 b0 40 80 00       	push   $0x8040b0
  80248b:	68 b7 00 00 00       	push   $0xb7
  802490:	68 07 40 80 00       	push   $0x804007
  802495:	e8 4f de ff ff       	call   8002e9 <_panic>
  80249a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249d:	8b 00                	mov    (%eax),%eax
  80249f:	85 c0                	test   %eax,%eax
  8024a1:	74 10                	je     8024b3 <alloc_block_BF+0x6e>
  8024a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a6:	8b 00                	mov    (%eax),%eax
  8024a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024ab:	8b 52 04             	mov    0x4(%edx),%edx
  8024ae:	89 50 04             	mov    %edx,0x4(%eax)
  8024b1:	eb 0b                	jmp    8024be <alloc_block_BF+0x79>
  8024b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b6:	8b 40 04             	mov    0x4(%eax),%eax
  8024b9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8024be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c1:	8b 40 04             	mov    0x4(%eax),%eax
  8024c4:	85 c0                	test   %eax,%eax
  8024c6:	74 0f                	je     8024d7 <alloc_block_BF+0x92>
  8024c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cb:	8b 40 04             	mov    0x4(%eax),%eax
  8024ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024d1:	8b 12                	mov    (%edx),%edx
  8024d3:	89 10                	mov    %edx,(%eax)
  8024d5:	eb 0a                	jmp    8024e1 <alloc_block_BF+0x9c>
  8024d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024da:	8b 00                	mov    (%eax),%eax
  8024dc:	a3 38 51 80 00       	mov    %eax,0x805138
  8024e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024f4:	a1 44 51 80 00       	mov    0x805144,%eax
  8024f9:	48                   	dec    %eax
  8024fa:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  8024ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802502:	e9 4d 01 00 00       	jmp    802654 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802507:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250a:	8b 40 0c             	mov    0xc(%eax),%eax
  80250d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802510:	76 24                	jbe    802536 <alloc_block_BF+0xf1>
  802512:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802515:	8b 40 0c             	mov    0xc(%eax),%eax
  802518:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80251b:	73 19                	jae    802536 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  80251d:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802524:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802527:	8b 40 0c             	mov    0xc(%eax),%eax
  80252a:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  80252d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802530:	8b 40 08             	mov    0x8(%eax),%eax
  802533:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802536:	a1 40 51 80 00       	mov    0x805140,%eax
  80253b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80253e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802542:	74 07                	je     80254b <alloc_block_BF+0x106>
  802544:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802547:	8b 00                	mov    (%eax),%eax
  802549:	eb 05                	jmp    802550 <alloc_block_BF+0x10b>
  80254b:	b8 00 00 00 00       	mov    $0x0,%eax
  802550:	a3 40 51 80 00       	mov    %eax,0x805140
  802555:	a1 40 51 80 00       	mov    0x805140,%eax
  80255a:	85 c0                	test   %eax,%eax
  80255c:	0f 85 fd fe ff ff    	jne    80245f <alloc_block_BF+0x1a>
  802562:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802566:	0f 85 f3 fe ff ff    	jne    80245f <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  80256c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802570:	0f 84 d9 00 00 00    	je     80264f <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802576:	a1 48 51 80 00       	mov    0x805148,%eax
  80257b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  80257e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802581:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802584:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802587:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80258a:	8b 55 08             	mov    0x8(%ebp),%edx
  80258d:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802590:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802594:	75 17                	jne    8025ad <alloc_block_BF+0x168>
  802596:	83 ec 04             	sub    $0x4,%esp
  802599:	68 b0 40 80 00       	push   $0x8040b0
  80259e:	68 c7 00 00 00       	push   $0xc7
  8025a3:	68 07 40 80 00       	push   $0x804007
  8025a8:	e8 3c dd ff ff       	call   8002e9 <_panic>
  8025ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025b0:	8b 00                	mov    (%eax),%eax
  8025b2:	85 c0                	test   %eax,%eax
  8025b4:	74 10                	je     8025c6 <alloc_block_BF+0x181>
  8025b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025b9:	8b 00                	mov    (%eax),%eax
  8025bb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025be:	8b 52 04             	mov    0x4(%edx),%edx
  8025c1:	89 50 04             	mov    %edx,0x4(%eax)
  8025c4:	eb 0b                	jmp    8025d1 <alloc_block_BF+0x18c>
  8025c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025c9:	8b 40 04             	mov    0x4(%eax),%eax
  8025cc:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8025d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025d4:	8b 40 04             	mov    0x4(%eax),%eax
  8025d7:	85 c0                	test   %eax,%eax
  8025d9:	74 0f                	je     8025ea <alloc_block_BF+0x1a5>
  8025db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025de:	8b 40 04             	mov    0x4(%eax),%eax
  8025e1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025e4:	8b 12                	mov    (%edx),%edx
  8025e6:	89 10                	mov    %edx,(%eax)
  8025e8:	eb 0a                	jmp    8025f4 <alloc_block_BF+0x1af>
  8025ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025ed:	8b 00                	mov    (%eax),%eax
  8025ef:	a3 48 51 80 00       	mov    %eax,0x805148
  8025f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025f7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802600:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802607:	a1 54 51 80 00       	mov    0x805154,%eax
  80260c:	48                   	dec    %eax
  80260d:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802612:	83 ec 08             	sub    $0x8,%esp
  802615:	ff 75 ec             	pushl  -0x14(%ebp)
  802618:	68 38 51 80 00       	push   $0x805138
  80261d:	e8 71 f9 ff ff       	call   801f93 <find_block>
  802622:	83 c4 10             	add    $0x10,%esp
  802625:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802628:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80262b:	8b 50 08             	mov    0x8(%eax),%edx
  80262e:	8b 45 08             	mov    0x8(%ebp),%eax
  802631:	01 c2                	add    %eax,%edx
  802633:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802636:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802639:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80263c:	8b 40 0c             	mov    0xc(%eax),%eax
  80263f:	2b 45 08             	sub    0x8(%ebp),%eax
  802642:	89 c2                	mov    %eax,%edx
  802644:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802647:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  80264a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80264d:	eb 05                	jmp    802654 <alloc_block_BF+0x20f>
	}
	return NULL;
  80264f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802654:	c9                   	leave  
  802655:	c3                   	ret    

00802656 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802656:	55                   	push   %ebp
  802657:	89 e5                	mov    %esp,%ebp
  802659:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  80265c:	a1 28 50 80 00       	mov    0x805028,%eax
  802661:	85 c0                	test   %eax,%eax
  802663:	0f 85 de 01 00 00    	jne    802847 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802669:	a1 38 51 80 00       	mov    0x805138,%eax
  80266e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802671:	e9 9e 01 00 00       	jmp    802814 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802676:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802679:	8b 40 0c             	mov    0xc(%eax),%eax
  80267c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80267f:	0f 82 87 01 00 00    	jb     80280c <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802685:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802688:	8b 40 0c             	mov    0xc(%eax),%eax
  80268b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80268e:	0f 85 95 00 00 00    	jne    802729 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802694:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802698:	75 17                	jne    8026b1 <alloc_block_NF+0x5b>
  80269a:	83 ec 04             	sub    $0x4,%esp
  80269d:	68 b0 40 80 00       	push   $0x8040b0
  8026a2:	68 e0 00 00 00       	push   $0xe0
  8026a7:	68 07 40 80 00       	push   $0x804007
  8026ac:	e8 38 dc ff ff       	call   8002e9 <_panic>
  8026b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b4:	8b 00                	mov    (%eax),%eax
  8026b6:	85 c0                	test   %eax,%eax
  8026b8:	74 10                	je     8026ca <alloc_block_NF+0x74>
  8026ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bd:	8b 00                	mov    (%eax),%eax
  8026bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026c2:	8b 52 04             	mov    0x4(%edx),%edx
  8026c5:	89 50 04             	mov    %edx,0x4(%eax)
  8026c8:	eb 0b                	jmp    8026d5 <alloc_block_NF+0x7f>
  8026ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cd:	8b 40 04             	mov    0x4(%eax),%eax
  8026d0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8026d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d8:	8b 40 04             	mov    0x4(%eax),%eax
  8026db:	85 c0                	test   %eax,%eax
  8026dd:	74 0f                	je     8026ee <alloc_block_NF+0x98>
  8026df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e2:	8b 40 04             	mov    0x4(%eax),%eax
  8026e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026e8:	8b 12                	mov    (%edx),%edx
  8026ea:	89 10                	mov    %edx,(%eax)
  8026ec:	eb 0a                	jmp    8026f8 <alloc_block_NF+0xa2>
  8026ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f1:	8b 00                	mov    (%eax),%eax
  8026f3:	a3 38 51 80 00       	mov    %eax,0x805138
  8026f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802701:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802704:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80270b:	a1 44 51 80 00       	mov    0x805144,%eax
  802710:	48                   	dec    %eax
  802711:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802716:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802719:	8b 40 08             	mov    0x8(%eax),%eax
  80271c:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802721:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802724:	e9 f8 04 00 00       	jmp    802c21 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802729:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272c:	8b 40 0c             	mov    0xc(%eax),%eax
  80272f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802732:	0f 86 d4 00 00 00    	jbe    80280c <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802738:	a1 48 51 80 00       	mov    0x805148,%eax
  80273d:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802740:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802743:	8b 50 08             	mov    0x8(%eax),%edx
  802746:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802749:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  80274c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80274f:	8b 55 08             	mov    0x8(%ebp),%edx
  802752:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802755:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802759:	75 17                	jne    802772 <alloc_block_NF+0x11c>
  80275b:	83 ec 04             	sub    $0x4,%esp
  80275e:	68 b0 40 80 00       	push   $0x8040b0
  802763:	68 e9 00 00 00       	push   $0xe9
  802768:	68 07 40 80 00       	push   $0x804007
  80276d:	e8 77 db ff ff       	call   8002e9 <_panic>
  802772:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802775:	8b 00                	mov    (%eax),%eax
  802777:	85 c0                	test   %eax,%eax
  802779:	74 10                	je     80278b <alloc_block_NF+0x135>
  80277b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80277e:	8b 00                	mov    (%eax),%eax
  802780:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802783:	8b 52 04             	mov    0x4(%edx),%edx
  802786:	89 50 04             	mov    %edx,0x4(%eax)
  802789:	eb 0b                	jmp    802796 <alloc_block_NF+0x140>
  80278b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80278e:	8b 40 04             	mov    0x4(%eax),%eax
  802791:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802796:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802799:	8b 40 04             	mov    0x4(%eax),%eax
  80279c:	85 c0                	test   %eax,%eax
  80279e:	74 0f                	je     8027af <alloc_block_NF+0x159>
  8027a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027a3:	8b 40 04             	mov    0x4(%eax),%eax
  8027a6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027a9:	8b 12                	mov    (%edx),%edx
  8027ab:	89 10                	mov    %edx,(%eax)
  8027ad:	eb 0a                	jmp    8027b9 <alloc_block_NF+0x163>
  8027af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027b2:	8b 00                	mov    (%eax),%eax
  8027b4:	a3 48 51 80 00       	mov    %eax,0x805148
  8027b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027cc:	a1 54 51 80 00       	mov    0x805154,%eax
  8027d1:	48                   	dec    %eax
  8027d2:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  8027d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027da:	8b 40 08             	mov    0x8(%eax),%eax
  8027dd:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  8027e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e5:	8b 50 08             	mov    0x8(%eax),%edx
  8027e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8027eb:	01 c2                	add    %eax,%edx
  8027ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f0:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  8027f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f6:	8b 40 0c             	mov    0xc(%eax),%eax
  8027f9:	2b 45 08             	sub    0x8(%ebp),%eax
  8027fc:	89 c2                	mov    %eax,%edx
  8027fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802801:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802804:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802807:	e9 15 04 00 00       	jmp    802c21 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80280c:	a1 40 51 80 00       	mov    0x805140,%eax
  802811:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802814:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802818:	74 07                	je     802821 <alloc_block_NF+0x1cb>
  80281a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281d:	8b 00                	mov    (%eax),%eax
  80281f:	eb 05                	jmp    802826 <alloc_block_NF+0x1d0>
  802821:	b8 00 00 00 00       	mov    $0x0,%eax
  802826:	a3 40 51 80 00       	mov    %eax,0x805140
  80282b:	a1 40 51 80 00       	mov    0x805140,%eax
  802830:	85 c0                	test   %eax,%eax
  802832:	0f 85 3e fe ff ff    	jne    802676 <alloc_block_NF+0x20>
  802838:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80283c:	0f 85 34 fe ff ff    	jne    802676 <alloc_block_NF+0x20>
  802842:	e9 d5 03 00 00       	jmp    802c1c <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802847:	a1 38 51 80 00       	mov    0x805138,%eax
  80284c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80284f:	e9 b1 01 00 00       	jmp    802a05 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802854:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802857:	8b 50 08             	mov    0x8(%eax),%edx
  80285a:	a1 28 50 80 00       	mov    0x805028,%eax
  80285f:	39 c2                	cmp    %eax,%edx
  802861:	0f 82 96 01 00 00    	jb     8029fd <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802867:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286a:	8b 40 0c             	mov    0xc(%eax),%eax
  80286d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802870:	0f 82 87 01 00 00    	jb     8029fd <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802876:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802879:	8b 40 0c             	mov    0xc(%eax),%eax
  80287c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80287f:	0f 85 95 00 00 00    	jne    80291a <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802885:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802889:	75 17                	jne    8028a2 <alloc_block_NF+0x24c>
  80288b:	83 ec 04             	sub    $0x4,%esp
  80288e:	68 b0 40 80 00       	push   $0x8040b0
  802893:	68 fc 00 00 00       	push   $0xfc
  802898:	68 07 40 80 00       	push   $0x804007
  80289d:	e8 47 da ff ff       	call   8002e9 <_panic>
  8028a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a5:	8b 00                	mov    (%eax),%eax
  8028a7:	85 c0                	test   %eax,%eax
  8028a9:	74 10                	je     8028bb <alloc_block_NF+0x265>
  8028ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ae:	8b 00                	mov    (%eax),%eax
  8028b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028b3:	8b 52 04             	mov    0x4(%edx),%edx
  8028b6:	89 50 04             	mov    %edx,0x4(%eax)
  8028b9:	eb 0b                	jmp    8028c6 <alloc_block_NF+0x270>
  8028bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028be:	8b 40 04             	mov    0x4(%eax),%eax
  8028c1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8028c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c9:	8b 40 04             	mov    0x4(%eax),%eax
  8028cc:	85 c0                	test   %eax,%eax
  8028ce:	74 0f                	je     8028df <alloc_block_NF+0x289>
  8028d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d3:	8b 40 04             	mov    0x4(%eax),%eax
  8028d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028d9:	8b 12                	mov    (%edx),%edx
  8028db:	89 10                	mov    %edx,(%eax)
  8028dd:	eb 0a                	jmp    8028e9 <alloc_block_NF+0x293>
  8028df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e2:	8b 00                	mov    (%eax),%eax
  8028e4:	a3 38 51 80 00       	mov    %eax,0x805138
  8028e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028fc:	a1 44 51 80 00       	mov    0x805144,%eax
  802901:	48                   	dec    %eax
  802902:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802907:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290a:	8b 40 08             	mov    0x8(%eax),%eax
  80290d:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802912:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802915:	e9 07 03 00 00       	jmp    802c21 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  80291a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291d:	8b 40 0c             	mov    0xc(%eax),%eax
  802920:	3b 45 08             	cmp    0x8(%ebp),%eax
  802923:	0f 86 d4 00 00 00    	jbe    8029fd <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802929:	a1 48 51 80 00       	mov    0x805148,%eax
  80292e:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802931:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802934:	8b 50 08             	mov    0x8(%eax),%edx
  802937:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80293a:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  80293d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802940:	8b 55 08             	mov    0x8(%ebp),%edx
  802943:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802946:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80294a:	75 17                	jne    802963 <alloc_block_NF+0x30d>
  80294c:	83 ec 04             	sub    $0x4,%esp
  80294f:	68 b0 40 80 00       	push   $0x8040b0
  802954:	68 04 01 00 00       	push   $0x104
  802959:	68 07 40 80 00       	push   $0x804007
  80295e:	e8 86 d9 ff ff       	call   8002e9 <_panic>
  802963:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802966:	8b 00                	mov    (%eax),%eax
  802968:	85 c0                	test   %eax,%eax
  80296a:	74 10                	je     80297c <alloc_block_NF+0x326>
  80296c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80296f:	8b 00                	mov    (%eax),%eax
  802971:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802974:	8b 52 04             	mov    0x4(%edx),%edx
  802977:	89 50 04             	mov    %edx,0x4(%eax)
  80297a:	eb 0b                	jmp    802987 <alloc_block_NF+0x331>
  80297c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80297f:	8b 40 04             	mov    0x4(%eax),%eax
  802982:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802987:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80298a:	8b 40 04             	mov    0x4(%eax),%eax
  80298d:	85 c0                	test   %eax,%eax
  80298f:	74 0f                	je     8029a0 <alloc_block_NF+0x34a>
  802991:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802994:	8b 40 04             	mov    0x4(%eax),%eax
  802997:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80299a:	8b 12                	mov    (%edx),%edx
  80299c:	89 10                	mov    %edx,(%eax)
  80299e:	eb 0a                	jmp    8029aa <alloc_block_NF+0x354>
  8029a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029a3:	8b 00                	mov    (%eax),%eax
  8029a5:	a3 48 51 80 00       	mov    %eax,0x805148
  8029aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029ad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029b6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029bd:	a1 54 51 80 00       	mov    0x805154,%eax
  8029c2:	48                   	dec    %eax
  8029c3:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  8029c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029cb:	8b 40 08             	mov    0x8(%eax),%eax
  8029ce:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  8029d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d6:	8b 50 08             	mov    0x8(%eax),%edx
  8029d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8029dc:	01 c2                	add    %eax,%edx
  8029de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e1:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8029e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e7:	8b 40 0c             	mov    0xc(%eax),%eax
  8029ea:	2b 45 08             	sub    0x8(%ebp),%eax
  8029ed:	89 c2                	mov    %eax,%edx
  8029ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f2:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8029f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029f8:	e9 24 02 00 00       	jmp    802c21 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8029fd:	a1 40 51 80 00       	mov    0x805140,%eax
  802a02:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a05:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a09:	74 07                	je     802a12 <alloc_block_NF+0x3bc>
  802a0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0e:	8b 00                	mov    (%eax),%eax
  802a10:	eb 05                	jmp    802a17 <alloc_block_NF+0x3c1>
  802a12:	b8 00 00 00 00       	mov    $0x0,%eax
  802a17:	a3 40 51 80 00       	mov    %eax,0x805140
  802a1c:	a1 40 51 80 00       	mov    0x805140,%eax
  802a21:	85 c0                	test   %eax,%eax
  802a23:	0f 85 2b fe ff ff    	jne    802854 <alloc_block_NF+0x1fe>
  802a29:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a2d:	0f 85 21 fe ff ff    	jne    802854 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a33:	a1 38 51 80 00       	mov    0x805138,%eax
  802a38:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a3b:	e9 ae 01 00 00       	jmp    802bee <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802a40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a43:	8b 50 08             	mov    0x8(%eax),%edx
  802a46:	a1 28 50 80 00       	mov    0x805028,%eax
  802a4b:	39 c2                	cmp    %eax,%edx
  802a4d:	0f 83 93 01 00 00    	jae    802be6 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802a53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a56:	8b 40 0c             	mov    0xc(%eax),%eax
  802a59:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a5c:	0f 82 84 01 00 00    	jb     802be6 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802a62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a65:	8b 40 0c             	mov    0xc(%eax),%eax
  802a68:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a6b:	0f 85 95 00 00 00    	jne    802b06 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802a71:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a75:	75 17                	jne    802a8e <alloc_block_NF+0x438>
  802a77:	83 ec 04             	sub    $0x4,%esp
  802a7a:	68 b0 40 80 00       	push   $0x8040b0
  802a7f:	68 14 01 00 00       	push   $0x114
  802a84:	68 07 40 80 00       	push   $0x804007
  802a89:	e8 5b d8 ff ff       	call   8002e9 <_panic>
  802a8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a91:	8b 00                	mov    (%eax),%eax
  802a93:	85 c0                	test   %eax,%eax
  802a95:	74 10                	je     802aa7 <alloc_block_NF+0x451>
  802a97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9a:	8b 00                	mov    (%eax),%eax
  802a9c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a9f:	8b 52 04             	mov    0x4(%edx),%edx
  802aa2:	89 50 04             	mov    %edx,0x4(%eax)
  802aa5:	eb 0b                	jmp    802ab2 <alloc_block_NF+0x45c>
  802aa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aaa:	8b 40 04             	mov    0x4(%eax),%eax
  802aad:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ab2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab5:	8b 40 04             	mov    0x4(%eax),%eax
  802ab8:	85 c0                	test   %eax,%eax
  802aba:	74 0f                	je     802acb <alloc_block_NF+0x475>
  802abc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abf:	8b 40 04             	mov    0x4(%eax),%eax
  802ac2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ac5:	8b 12                	mov    (%edx),%edx
  802ac7:	89 10                	mov    %edx,(%eax)
  802ac9:	eb 0a                	jmp    802ad5 <alloc_block_NF+0x47f>
  802acb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ace:	8b 00                	mov    (%eax),%eax
  802ad0:	a3 38 51 80 00       	mov    %eax,0x805138
  802ad5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ade:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ae8:	a1 44 51 80 00       	mov    0x805144,%eax
  802aed:	48                   	dec    %eax
  802aee:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802af3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af6:	8b 40 08             	mov    0x8(%eax),%eax
  802af9:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802afe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b01:	e9 1b 01 00 00       	jmp    802c21 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802b06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b09:	8b 40 0c             	mov    0xc(%eax),%eax
  802b0c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b0f:	0f 86 d1 00 00 00    	jbe    802be6 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b15:	a1 48 51 80 00       	mov    0x805148,%eax
  802b1a:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802b1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b20:	8b 50 08             	mov    0x8(%eax),%edx
  802b23:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b26:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802b29:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b2c:	8b 55 08             	mov    0x8(%ebp),%edx
  802b2f:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b32:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b36:	75 17                	jne    802b4f <alloc_block_NF+0x4f9>
  802b38:	83 ec 04             	sub    $0x4,%esp
  802b3b:	68 b0 40 80 00       	push   $0x8040b0
  802b40:	68 1c 01 00 00       	push   $0x11c
  802b45:	68 07 40 80 00       	push   $0x804007
  802b4a:	e8 9a d7 ff ff       	call   8002e9 <_panic>
  802b4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b52:	8b 00                	mov    (%eax),%eax
  802b54:	85 c0                	test   %eax,%eax
  802b56:	74 10                	je     802b68 <alloc_block_NF+0x512>
  802b58:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b5b:	8b 00                	mov    (%eax),%eax
  802b5d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b60:	8b 52 04             	mov    0x4(%edx),%edx
  802b63:	89 50 04             	mov    %edx,0x4(%eax)
  802b66:	eb 0b                	jmp    802b73 <alloc_block_NF+0x51d>
  802b68:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b6b:	8b 40 04             	mov    0x4(%eax),%eax
  802b6e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b73:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b76:	8b 40 04             	mov    0x4(%eax),%eax
  802b79:	85 c0                	test   %eax,%eax
  802b7b:	74 0f                	je     802b8c <alloc_block_NF+0x536>
  802b7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b80:	8b 40 04             	mov    0x4(%eax),%eax
  802b83:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b86:	8b 12                	mov    (%edx),%edx
  802b88:	89 10                	mov    %edx,(%eax)
  802b8a:	eb 0a                	jmp    802b96 <alloc_block_NF+0x540>
  802b8c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b8f:	8b 00                	mov    (%eax),%eax
  802b91:	a3 48 51 80 00       	mov    %eax,0x805148
  802b96:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b99:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b9f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ba2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ba9:	a1 54 51 80 00       	mov    0x805154,%eax
  802bae:	48                   	dec    %eax
  802baf:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802bb4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bb7:	8b 40 08             	mov    0x8(%eax),%eax
  802bba:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802bbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc2:	8b 50 08             	mov    0x8(%eax),%edx
  802bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc8:	01 c2                	add    %eax,%edx
  802bca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcd:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802bd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd3:	8b 40 0c             	mov    0xc(%eax),%eax
  802bd6:	2b 45 08             	sub    0x8(%ebp),%eax
  802bd9:	89 c2                	mov    %eax,%edx
  802bdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bde:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802be1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802be4:	eb 3b                	jmp    802c21 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802be6:	a1 40 51 80 00       	mov    0x805140,%eax
  802beb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bf2:	74 07                	je     802bfb <alloc_block_NF+0x5a5>
  802bf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf7:	8b 00                	mov    (%eax),%eax
  802bf9:	eb 05                	jmp    802c00 <alloc_block_NF+0x5aa>
  802bfb:	b8 00 00 00 00       	mov    $0x0,%eax
  802c00:	a3 40 51 80 00       	mov    %eax,0x805140
  802c05:	a1 40 51 80 00       	mov    0x805140,%eax
  802c0a:	85 c0                	test   %eax,%eax
  802c0c:	0f 85 2e fe ff ff    	jne    802a40 <alloc_block_NF+0x3ea>
  802c12:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c16:	0f 85 24 fe ff ff    	jne    802a40 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802c1c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c21:	c9                   	leave  
  802c22:	c3                   	ret    

00802c23 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802c23:	55                   	push   %ebp
  802c24:	89 e5                	mov    %esp,%ebp
  802c26:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802c29:	a1 38 51 80 00       	mov    0x805138,%eax
  802c2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802c31:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802c36:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802c39:	a1 38 51 80 00       	mov    0x805138,%eax
  802c3e:	85 c0                	test   %eax,%eax
  802c40:	74 14                	je     802c56 <insert_sorted_with_merge_freeList+0x33>
  802c42:	8b 45 08             	mov    0x8(%ebp),%eax
  802c45:	8b 50 08             	mov    0x8(%eax),%edx
  802c48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c4b:	8b 40 08             	mov    0x8(%eax),%eax
  802c4e:	39 c2                	cmp    %eax,%edx
  802c50:	0f 87 9b 01 00 00    	ja     802df1 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802c56:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c5a:	75 17                	jne    802c73 <insert_sorted_with_merge_freeList+0x50>
  802c5c:	83 ec 04             	sub    $0x4,%esp
  802c5f:	68 e4 3f 80 00       	push   $0x803fe4
  802c64:	68 38 01 00 00       	push   $0x138
  802c69:	68 07 40 80 00       	push   $0x804007
  802c6e:	e8 76 d6 ff ff       	call   8002e9 <_panic>
  802c73:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802c79:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7c:	89 10                	mov    %edx,(%eax)
  802c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c81:	8b 00                	mov    (%eax),%eax
  802c83:	85 c0                	test   %eax,%eax
  802c85:	74 0d                	je     802c94 <insert_sorted_with_merge_freeList+0x71>
  802c87:	a1 38 51 80 00       	mov    0x805138,%eax
  802c8c:	8b 55 08             	mov    0x8(%ebp),%edx
  802c8f:	89 50 04             	mov    %edx,0x4(%eax)
  802c92:	eb 08                	jmp    802c9c <insert_sorted_with_merge_freeList+0x79>
  802c94:	8b 45 08             	mov    0x8(%ebp),%eax
  802c97:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9f:	a3 38 51 80 00       	mov    %eax,0x805138
  802ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cae:	a1 44 51 80 00       	mov    0x805144,%eax
  802cb3:	40                   	inc    %eax
  802cb4:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802cb9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cbd:	0f 84 a8 06 00 00    	je     80336b <insert_sorted_with_merge_freeList+0x748>
  802cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc6:	8b 50 08             	mov    0x8(%eax),%edx
  802cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ccc:	8b 40 0c             	mov    0xc(%eax),%eax
  802ccf:	01 c2                	add    %eax,%edx
  802cd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cd4:	8b 40 08             	mov    0x8(%eax),%eax
  802cd7:	39 c2                	cmp    %eax,%edx
  802cd9:	0f 85 8c 06 00 00    	jne    80336b <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce2:	8b 50 0c             	mov    0xc(%eax),%edx
  802ce5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ce8:	8b 40 0c             	mov    0xc(%eax),%eax
  802ceb:	01 c2                	add    %eax,%edx
  802ced:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf0:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802cf3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cf7:	75 17                	jne    802d10 <insert_sorted_with_merge_freeList+0xed>
  802cf9:	83 ec 04             	sub    $0x4,%esp
  802cfc:	68 b0 40 80 00       	push   $0x8040b0
  802d01:	68 3c 01 00 00       	push   $0x13c
  802d06:	68 07 40 80 00       	push   $0x804007
  802d0b:	e8 d9 d5 ff ff       	call   8002e9 <_panic>
  802d10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d13:	8b 00                	mov    (%eax),%eax
  802d15:	85 c0                	test   %eax,%eax
  802d17:	74 10                	je     802d29 <insert_sorted_with_merge_freeList+0x106>
  802d19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d1c:	8b 00                	mov    (%eax),%eax
  802d1e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d21:	8b 52 04             	mov    0x4(%edx),%edx
  802d24:	89 50 04             	mov    %edx,0x4(%eax)
  802d27:	eb 0b                	jmp    802d34 <insert_sorted_with_merge_freeList+0x111>
  802d29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d2c:	8b 40 04             	mov    0x4(%eax),%eax
  802d2f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d37:	8b 40 04             	mov    0x4(%eax),%eax
  802d3a:	85 c0                	test   %eax,%eax
  802d3c:	74 0f                	je     802d4d <insert_sorted_with_merge_freeList+0x12a>
  802d3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d41:	8b 40 04             	mov    0x4(%eax),%eax
  802d44:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d47:	8b 12                	mov    (%edx),%edx
  802d49:	89 10                	mov    %edx,(%eax)
  802d4b:	eb 0a                	jmp    802d57 <insert_sorted_with_merge_freeList+0x134>
  802d4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d50:	8b 00                	mov    (%eax),%eax
  802d52:	a3 38 51 80 00       	mov    %eax,0x805138
  802d57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d5a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d63:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d6a:	a1 44 51 80 00       	mov    0x805144,%eax
  802d6f:	48                   	dec    %eax
  802d70:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802d75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d78:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802d7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d82:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802d89:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d8d:	75 17                	jne    802da6 <insert_sorted_with_merge_freeList+0x183>
  802d8f:	83 ec 04             	sub    $0x4,%esp
  802d92:	68 e4 3f 80 00       	push   $0x803fe4
  802d97:	68 3f 01 00 00       	push   $0x13f
  802d9c:	68 07 40 80 00       	push   $0x804007
  802da1:	e8 43 d5 ff ff       	call   8002e9 <_panic>
  802da6:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802dac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802daf:	89 10                	mov    %edx,(%eax)
  802db1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802db4:	8b 00                	mov    (%eax),%eax
  802db6:	85 c0                	test   %eax,%eax
  802db8:	74 0d                	je     802dc7 <insert_sorted_with_merge_freeList+0x1a4>
  802dba:	a1 48 51 80 00       	mov    0x805148,%eax
  802dbf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802dc2:	89 50 04             	mov    %edx,0x4(%eax)
  802dc5:	eb 08                	jmp    802dcf <insert_sorted_with_merge_freeList+0x1ac>
  802dc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dca:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802dcf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dd2:	a3 48 51 80 00       	mov    %eax,0x805148
  802dd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dda:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802de1:	a1 54 51 80 00       	mov    0x805154,%eax
  802de6:	40                   	inc    %eax
  802de7:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802dec:	e9 7a 05 00 00       	jmp    80336b <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802df1:	8b 45 08             	mov    0x8(%ebp),%eax
  802df4:	8b 50 08             	mov    0x8(%eax),%edx
  802df7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dfa:	8b 40 08             	mov    0x8(%eax),%eax
  802dfd:	39 c2                	cmp    %eax,%edx
  802dff:	0f 82 14 01 00 00    	jb     802f19 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802e05:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e08:	8b 50 08             	mov    0x8(%eax),%edx
  802e0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e0e:	8b 40 0c             	mov    0xc(%eax),%eax
  802e11:	01 c2                	add    %eax,%edx
  802e13:	8b 45 08             	mov    0x8(%ebp),%eax
  802e16:	8b 40 08             	mov    0x8(%eax),%eax
  802e19:	39 c2                	cmp    %eax,%edx
  802e1b:	0f 85 90 00 00 00    	jne    802eb1 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802e21:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e24:	8b 50 0c             	mov    0xc(%eax),%edx
  802e27:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2a:	8b 40 0c             	mov    0xc(%eax),%eax
  802e2d:	01 c2                	add    %eax,%edx
  802e2f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e32:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802e35:	8b 45 08             	mov    0x8(%ebp),%eax
  802e38:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e42:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802e49:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e4d:	75 17                	jne    802e66 <insert_sorted_with_merge_freeList+0x243>
  802e4f:	83 ec 04             	sub    $0x4,%esp
  802e52:	68 e4 3f 80 00       	push   $0x803fe4
  802e57:	68 49 01 00 00       	push   $0x149
  802e5c:	68 07 40 80 00       	push   $0x804007
  802e61:	e8 83 d4 ff ff       	call   8002e9 <_panic>
  802e66:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6f:	89 10                	mov    %edx,(%eax)
  802e71:	8b 45 08             	mov    0x8(%ebp),%eax
  802e74:	8b 00                	mov    (%eax),%eax
  802e76:	85 c0                	test   %eax,%eax
  802e78:	74 0d                	je     802e87 <insert_sorted_with_merge_freeList+0x264>
  802e7a:	a1 48 51 80 00       	mov    0x805148,%eax
  802e7f:	8b 55 08             	mov    0x8(%ebp),%edx
  802e82:	89 50 04             	mov    %edx,0x4(%eax)
  802e85:	eb 08                	jmp    802e8f <insert_sorted_with_merge_freeList+0x26c>
  802e87:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e92:	a3 48 51 80 00       	mov    %eax,0x805148
  802e97:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ea1:	a1 54 51 80 00       	mov    0x805154,%eax
  802ea6:	40                   	inc    %eax
  802ea7:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802eac:	e9 bb 04 00 00       	jmp    80336c <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802eb1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802eb5:	75 17                	jne    802ece <insert_sorted_with_merge_freeList+0x2ab>
  802eb7:	83 ec 04             	sub    $0x4,%esp
  802eba:	68 58 40 80 00       	push   $0x804058
  802ebf:	68 4c 01 00 00       	push   $0x14c
  802ec4:	68 07 40 80 00       	push   $0x804007
  802ec9:	e8 1b d4 ff ff       	call   8002e9 <_panic>
  802ece:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802ed4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed7:	89 50 04             	mov    %edx,0x4(%eax)
  802eda:	8b 45 08             	mov    0x8(%ebp),%eax
  802edd:	8b 40 04             	mov    0x4(%eax),%eax
  802ee0:	85 c0                	test   %eax,%eax
  802ee2:	74 0c                	je     802ef0 <insert_sorted_with_merge_freeList+0x2cd>
  802ee4:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802ee9:	8b 55 08             	mov    0x8(%ebp),%edx
  802eec:	89 10                	mov    %edx,(%eax)
  802eee:	eb 08                	jmp    802ef8 <insert_sorted_with_merge_freeList+0x2d5>
  802ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef3:	a3 38 51 80 00       	mov    %eax,0x805138
  802ef8:	8b 45 08             	mov    0x8(%ebp),%eax
  802efb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f00:	8b 45 08             	mov    0x8(%ebp),%eax
  802f03:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f09:	a1 44 51 80 00       	mov    0x805144,%eax
  802f0e:	40                   	inc    %eax
  802f0f:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802f14:	e9 53 04 00 00       	jmp    80336c <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802f19:	a1 38 51 80 00       	mov    0x805138,%eax
  802f1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f21:	e9 15 04 00 00       	jmp    80333b <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802f26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f29:	8b 00                	mov    (%eax),%eax
  802f2b:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802f2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f31:	8b 50 08             	mov    0x8(%eax),%edx
  802f34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f37:	8b 40 08             	mov    0x8(%eax),%eax
  802f3a:	39 c2                	cmp    %eax,%edx
  802f3c:	0f 86 f1 03 00 00    	jbe    803333 <insert_sorted_with_merge_freeList+0x710>
  802f42:	8b 45 08             	mov    0x8(%ebp),%eax
  802f45:	8b 50 08             	mov    0x8(%eax),%edx
  802f48:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f4b:	8b 40 08             	mov    0x8(%eax),%eax
  802f4e:	39 c2                	cmp    %eax,%edx
  802f50:	0f 83 dd 03 00 00    	jae    803333 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802f56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f59:	8b 50 08             	mov    0x8(%eax),%edx
  802f5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5f:	8b 40 0c             	mov    0xc(%eax),%eax
  802f62:	01 c2                	add    %eax,%edx
  802f64:	8b 45 08             	mov    0x8(%ebp),%eax
  802f67:	8b 40 08             	mov    0x8(%eax),%eax
  802f6a:	39 c2                	cmp    %eax,%edx
  802f6c:	0f 85 b9 01 00 00    	jne    80312b <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802f72:	8b 45 08             	mov    0x8(%ebp),%eax
  802f75:	8b 50 08             	mov    0x8(%eax),%edx
  802f78:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7b:	8b 40 0c             	mov    0xc(%eax),%eax
  802f7e:	01 c2                	add    %eax,%edx
  802f80:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f83:	8b 40 08             	mov    0x8(%eax),%eax
  802f86:	39 c2                	cmp    %eax,%edx
  802f88:	0f 85 0d 01 00 00    	jne    80309b <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802f8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f91:	8b 50 0c             	mov    0xc(%eax),%edx
  802f94:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f97:	8b 40 0c             	mov    0xc(%eax),%eax
  802f9a:	01 c2                	add    %eax,%edx
  802f9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f9f:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802fa2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802fa6:	75 17                	jne    802fbf <insert_sorted_with_merge_freeList+0x39c>
  802fa8:	83 ec 04             	sub    $0x4,%esp
  802fab:	68 b0 40 80 00       	push   $0x8040b0
  802fb0:	68 5c 01 00 00       	push   $0x15c
  802fb5:	68 07 40 80 00       	push   $0x804007
  802fba:	e8 2a d3 ff ff       	call   8002e9 <_panic>
  802fbf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fc2:	8b 00                	mov    (%eax),%eax
  802fc4:	85 c0                	test   %eax,%eax
  802fc6:	74 10                	je     802fd8 <insert_sorted_with_merge_freeList+0x3b5>
  802fc8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fcb:	8b 00                	mov    (%eax),%eax
  802fcd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fd0:	8b 52 04             	mov    0x4(%edx),%edx
  802fd3:	89 50 04             	mov    %edx,0x4(%eax)
  802fd6:	eb 0b                	jmp    802fe3 <insert_sorted_with_merge_freeList+0x3c0>
  802fd8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fdb:	8b 40 04             	mov    0x4(%eax),%eax
  802fde:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fe3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fe6:	8b 40 04             	mov    0x4(%eax),%eax
  802fe9:	85 c0                	test   %eax,%eax
  802feb:	74 0f                	je     802ffc <insert_sorted_with_merge_freeList+0x3d9>
  802fed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ff0:	8b 40 04             	mov    0x4(%eax),%eax
  802ff3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ff6:	8b 12                	mov    (%edx),%edx
  802ff8:	89 10                	mov    %edx,(%eax)
  802ffa:	eb 0a                	jmp    803006 <insert_sorted_with_merge_freeList+0x3e3>
  802ffc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fff:	8b 00                	mov    (%eax),%eax
  803001:	a3 38 51 80 00       	mov    %eax,0x805138
  803006:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803009:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80300f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803012:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803019:	a1 44 51 80 00       	mov    0x805144,%eax
  80301e:	48                   	dec    %eax
  80301f:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803024:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803027:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  80302e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803031:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803038:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80303c:	75 17                	jne    803055 <insert_sorted_with_merge_freeList+0x432>
  80303e:	83 ec 04             	sub    $0x4,%esp
  803041:	68 e4 3f 80 00       	push   $0x803fe4
  803046:	68 5f 01 00 00       	push   $0x15f
  80304b:	68 07 40 80 00       	push   $0x804007
  803050:	e8 94 d2 ff ff       	call   8002e9 <_panic>
  803055:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80305b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80305e:	89 10                	mov    %edx,(%eax)
  803060:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803063:	8b 00                	mov    (%eax),%eax
  803065:	85 c0                	test   %eax,%eax
  803067:	74 0d                	je     803076 <insert_sorted_with_merge_freeList+0x453>
  803069:	a1 48 51 80 00       	mov    0x805148,%eax
  80306e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803071:	89 50 04             	mov    %edx,0x4(%eax)
  803074:	eb 08                	jmp    80307e <insert_sorted_with_merge_freeList+0x45b>
  803076:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803079:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80307e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803081:	a3 48 51 80 00       	mov    %eax,0x805148
  803086:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803089:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803090:	a1 54 51 80 00       	mov    0x805154,%eax
  803095:	40                   	inc    %eax
  803096:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  80309b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309e:	8b 50 0c             	mov    0xc(%eax),%edx
  8030a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a4:	8b 40 0c             	mov    0xc(%eax),%eax
  8030a7:	01 c2                	add    %eax,%edx
  8030a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ac:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8030af:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8030b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030bc:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8030c3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030c7:	75 17                	jne    8030e0 <insert_sorted_with_merge_freeList+0x4bd>
  8030c9:	83 ec 04             	sub    $0x4,%esp
  8030cc:	68 e4 3f 80 00       	push   $0x803fe4
  8030d1:	68 64 01 00 00       	push   $0x164
  8030d6:	68 07 40 80 00       	push   $0x804007
  8030db:	e8 09 d2 ff ff       	call   8002e9 <_panic>
  8030e0:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8030e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e9:	89 10                	mov    %edx,(%eax)
  8030eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ee:	8b 00                	mov    (%eax),%eax
  8030f0:	85 c0                	test   %eax,%eax
  8030f2:	74 0d                	je     803101 <insert_sorted_with_merge_freeList+0x4de>
  8030f4:	a1 48 51 80 00       	mov    0x805148,%eax
  8030f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8030fc:	89 50 04             	mov    %edx,0x4(%eax)
  8030ff:	eb 08                	jmp    803109 <insert_sorted_with_merge_freeList+0x4e6>
  803101:	8b 45 08             	mov    0x8(%ebp),%eax
  803104:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803109:	8b 45 08             	mov    0x8(%ebp),%eax
  80310c:	a3 48 51 80 00       	mov    %eax,0x805148
  803111:	8b 45 08             	mov    0x8(%ebp),%eax
  803114:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80311b:	a1 54 51 80 00       	mov    0x805154,%eax
  803120:	40                   	inc    %eax
  803121:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803126:	e9 41 02 00 00       	jmp    80336c <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80312b:	8b 45 08             	mov    0x8(%ebp),%eax
  80312e:	8b 50 08             	mov    0x8(%eax),%edx
  803131:	8b 45 08             	mov    0x8(%ebp),%eax
  803134:	8b 40 0c             	mov    0xc(%eax),%eax
  803137:	01 c2                	add    %eax,%edx
  803139:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80313c:	8b 40 08             	mov    0x8(%eax),%eax
  80313f:	39 c2                	cmp    %eax,%edx
  803141:	0f 85 7c 01 00 00    	jne    8032c3 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803147:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80314b:	74 06                	je     803153 <insert_sorted_with_merge_freeList+0x530>
  80314d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803151:	75 17                	jne    80316a <insert_sorted_with_merge_freeList+0x547>
  803153:	83 ec 04             	sub    $0x4,%esp
  803156:	68 20 40 80 00       	push   $0x804020
  80315b:	68 69 01 00 00       	push   $0x169
  803160:	68 07 40 80 00       	push   $0x804007
  803165:	e8 7f d1 ff ff       	call   8002e9 <_panic>
  80316a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80316d:	8b 50 04             	mov    0x4(%eax),%edx
  803170:	8b 45 08             	mov    0x8(%ebp),%eax
  803173:	89 50 04             	mov    %edx,0x4(%eax)
  803176:	8b 45 08             	mov    0x8(%ebp),%eax
  803179:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80317c:	89 10                	mov    %edx,(%eax)
  80317e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803181:	8b 40 04             	mov    0x4(%eax),%eax
  803184:	85 c0                	test   %eax,%eax
  803186:	74 0d                	je     803195 <insert_sorted_with_merge_freeList+0x572>
  803188:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80318b:	8b 40 04             	mov    0x4(%eax),%eax
  80318e:	8b 55 08             	mov    0x8(%ebp),%edx
  803191:	89 10                	mov    %edx,(%eax)
  803193:	eb 08                	jmp    80319d <insert_sorted_with_merge_freeList+0x57a>
  803195:	8b 45 08             	mov    0x8(%ebp),%eax
  803198:	a3 38 51 80 00       	mov    %eax,0x805138
  80319d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8031a3:	89 50 04             	mov    %edx,0x4(%eax)
  8031a6:	a1 44 51 80 00       	mov    0x805144,%eax
  8031ab:	40                   	inc    %eax
  8031ac:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8031b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b4:	8b 50 0c             	mov    0xc(%eax),%edx
  8031b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8031bd:	01 c2                	add    %eax,%edx
  8031bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c2:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8031c5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031c9:	75 17                	jne    8031e2 <insert_sorted_with_merge_freeList+0x5bf>
  8031cb:	83 ec 04             	sub    $0x4,%esp
  8031ce:	68 b0 40 80 00       	push   $0x8040b0
  8031d3:	68 6b 01 00 00       	push   $0x16b
  8031d8:	68 07 40 80 00       	push   $0x804007
  8031dd:	e8 07 d1 ff ff       	call   8002e9 <_panic>
  8031e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e5:	8b 00                	mov    (%eax),%eax
  8031e7:	85 c0                	test   %eax,%eax
  8031e9:	74 10                	je     8031fb <insert_sorted_with_merge_freeList+0x5d8>
  8031eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ee:	8b 00                	mov    (%eax),%eax
  8031f0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031f3:	8b 52 04             	mov    0x4(%edx),%edx
  8031f6:	89 50 04             	mov    %edx,0x4(%eax)
  8031f9:	eb 0b                	jmp    803206 <insert_sorted_with_merge_freeList+0x5e3>
  8031fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031fe:	8b 40 04             	mov    0x4(%eax),%eax
  803201:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803206:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803209:	8b 40 04             	mov    0x4(%eax),%eax
  80320c:	85 c0                	test   %eax,%eax
  80320e:	74 0f                	je     80321f <insert_sorted_with_merge_freeList+0x5fc>
  803210:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803213:	8b 40 04             	mov    0x4(%eax),%eax
  803216:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803219:	8b 12                	mov    (%edx),%edx
  80321b:	89 10                	mov    %edx,(%eax)
  80321d:	eb 0a                	jmp    803229 <insert_sorted_with_merge_freeList+0x606>
  80321f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803222:	8b 00                	mov    (%eax),%eax
  803224:	a3 38 51 80 00       	mov    %eax,0x805138
  803229:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80322c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803232:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803235:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80323c:	a1 44 51 80 00       	mov    0x805144,%eax
  803241:	48                   	dec    %eax
  803242:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803247:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80324a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803251:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803254:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80325b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80325f:	75 17                	jne    803278 <insert_sorted_with_merge_freeList+0x655>
  803261:	83 ec 04             	sub    $0x4,%esp
  803264:	68 e4 3f 80 00       	push   $0x803fe4
  803269:	68 6e 01 00 00       	push   $0x16e
  80326e:	68 07 40 80 00       	push   $0x804007
  803273:	e8 71 d0 ff ff       	call   8002e9 <_panic>
  803278:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80327e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803281:	89 10                	mov    %edx,(%eax)
  803283:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803286:	8b 00                	mov    (%eax),%eax
  803288:	85 c0                	test   %eax,%eax
  80328a:	74 0d                	je     803299 <insert_sorted_with_merge_freeList+0x676>
  80328c:	a1 48 51 80 00       	mov    0x805148,%eax
  803291:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803294:	89 50 04             	mov    %edx,0x4(%eax)
  803297:	eb 08                	jmp    8032a1 <insert_sorted_with_merge_freeList+0x67e>
  803299:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80329c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032a4:	a3 48 51 80 00       	mov    %eax,0x805148
  8032a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032b3:	a1 54 51 80 00       	mov    0x805154,%eax
  8032b8:	40                   	inc    %eax
  8032b9:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8032be:	e9 a9 00 00 00       	jmp    80336c <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8032c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032c7:	74 06                	je     8032cf <insert_sorted_with_merge_freeList+0x6ac>
  8032c9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032cd:	75 17                	jne    8032e6 <insert_sorted_with_merge_freeList+0x6c3>
  8032cf:	83 ec 04             	sub    $0x4,%esp
  8032d2:	68 7c 40 80 00       	push   $0x80407c
  8032d7:	68 73 01 00 00       	push   $0x173
  8032dc:	68 07 40 80 00       	push   $0x804007
  8032e1:	e8 03 d0 ff ff       	call   8002e9 <_panic>
  8032e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032e9:	8b 10                	mov    (%eax),%edx
  8032eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ee:	89 10                	mov    %edx,(%eax)
  8032f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f3:	8b 00                	mov    (%eax),%eax
  8032f5:	85 c0                	test   %eax,%eax
  8032f7:	74 0b                	je     803304 <insert_sorted_with_merge_freeList+0x6e1>
  8032f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032fc:	8b 00                	mov    (%eax),%eax
  8032fe:	8b 55 08             	mov    0x8(%ebp),%edx
  803301:	89 50 04             	mov    %edx,0x4(%eax)
  803304:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803307:	8b 55 08             	mov    0x8(%ebp),%edx
  80330a:	89 10                	mov    %edx,(%eax)
  80330c:	8b 45 08             	mov    0x8(%ebp),%eax
  80330f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803312:	89 50 04             	mov    %edx,0x4(%eax)
  803315:	8b 45 08             	mov    0x8(%ebp),%eax
  803318:	8b 00                	mov    (%eax),%eax
  80331a:	85 c0                	test   %eax,%eax
  80331c:	75 08                	jne    803326 <insert_sorted_with_merge_freeList+0x703>
  80331e:	8b 45 08             	mov    0x8(%ebp),%eax
  803321:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803326:	a1 44 51 80 00       	mov    0x805144,%eax
  80332b:	40                   	inc    %eax
  80332c:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803331:	eb 39                	jmp    80336c <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803333:	a1 40 51 80 00       	mov    0x805140,%eax
  803338:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80333b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80333f:	74 07                	je     803348 <insert_sorted_with_merge_freeList+0x725>
  803341:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803344:	8b 00                	mov    (%eax),%eax
  803346:	eb 05                	jmp    80334d <insert_sorted_with_merge_freeList+0x72a>
  803348:	b8 00 00 00 00       	mov    $0x0,%eax
  80334d:	a3 40 51 80 00       	mov    %eax,0x805140
  803352:	a1 40 51 80 00       	mov    0x805140,%eax
  803357:	85 c0                	test   %eax,%eax
  803359:	0f 85 c7 fb ff ff    	jne    802f26 <insert_sorted_with_merge_freeList+0x303>
  80335f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803363:	0f 85 bd fb ff ff    	jne    802f26 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803369:	eb 01                	jmp    80336c <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80336b:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80336c:	90                   	nop
  80336d:	c9                   	leave  
  80336e:	c3                   	ret    

0080336f <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  80336f:	55                   	push   %ebp
  803370:	89 e5                	mov    %esp,%ebp
  803372:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803375:	8b 55 08             	mov    0x8(%ebp),%edx
  803378:	89 d0                	mov    %edx,%eax
  80337a:	c1 e0 02             	shl    $0x2,%eax
  80337d:	01 d0                	add    %edx,%eax
  80337f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803386:	01 d0                	add    %edx,%eax
  803388:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80338f:	01 d0                	add    %edx,%eax
  803391:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803398:	01 d0                	add    %edx,%eax
  80339a:	c1 e0 04             	shl    $0x4,%eax
  80339d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8033a0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8033a7:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8033aa:	83 ec 0c             	sub    $0xc,%esp
  8033ad:	50                   	push   %eax
  8033ae:	e8 26 e7 ff ff       	call   801ad9 <sys_get_virtual_time>
  8033b3:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8033b6:	eb 41                	jmp    8033f9 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8033b8:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8033bb:	83 ec 0c             	sub    $0xc,%esp
  8033be:	50                   	push   %eax
  8033bf:	e8 15 e7 ff ff       	call   801ad9 <sys_get_virtual_time>
  8033c4:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8033c7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8033ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033cd:	29 c2                	sub    %eax,%edx
  8033cf:	89 d0                	mov    %edx,%eax
  8033d1:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8033d4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8033d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033da:	89 d1                	mov    %edx,%ecx
  8033dc:	29 c1                	sub    %eax,%ecx
  8033de:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8033e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033e4:	39 c2                	cmp    %eax,%edx
  8033e6:	0f 97 c0             	seta   %al
  8033e9:	0f b6 c0             	movzbl %al,%eax
  8033ec:	29 c1                	sub    %eax,%ecx
  8033ee:	89 c8                	mov    %ecx,%eax
  8033f0:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8033f3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8033f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8033f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033fc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8033ff:	72 b7                	jb     8033b8 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803401:	90                   	nop
  803402:	c9                   	leave  
  803403:	c3                   	ret    

00803404 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803404:	55                   	push   %ebp
  803405:	89 e5                	mov    %esp,%ebp
  803407:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  80340a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803411:	eb 03                	jmp    803416 <busy_wait+0x12>
  803413:	ff 45 fc             	incl   -0x4(%ebp)
  803416:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803419:	3b 45 08             	cmp    0x8(%ebp),%eax
  80341c:	72 f5                	jb     803413 <busy_wait+0xf>
	return i;
  80341e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803421:	c9                   	leave  
  803422:	c3                   	ret    
  803423:	90                   	nop

00803424 <__udivdi3>:
  803424:	55                   	push   %ebp
  803425:	57                   	push   %edi
  803426:	56                   	push   %esi
  803427:	53                   	push   %ebx
  803428:	83 ec 1c             	sub    $0x1c,%esp
  80342b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80342f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803433:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803437:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80343b:	89 ca                	mov    %ecx,%edx
  80343d:	89 f8                	mov    %edi,%eax
  80343f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803443:	85 f6                	test   %esi,%esi
  803445:	75 2d                	jne    803474 <__udivdi3+0x50>
  803447:	39 cf                	cmp    %ecx,%edi
  803449:	77 65                	ja     8034b0 <__udivdi3+0x8c>
  80344b:	89 fd                	mov    %edi,%ebp
  80344d:	85 ff                	test   %edi,%edi
  80344f:	75 0b                	jne    80345c <__udivdi3+0x38>
  803451:	b8 01 00 00 00       	mov    $0x1,%eax
  803456:	31 d2                	xor    %edx,%edx
  803458:	f7 f7                	div    %edi
  80345a:	89 c5                	mov    %eax,%ebp
  80345c:	31 d2                	xor    %edx,%edx
  80345e:	89 c8                	mov    %ecx,%eax
  803460:	f7 f5                	div    %ebp
  803462:	89 c1                	mov    %eax,%ecx
  803464:	89 d8                	mov    %ebx,%eax
  803466:	f7 f5                	div    %ebp
  803468:	89 cf                	mov    %ecx,%edi
  80346a:	89 fa                	mov    %edi,%edx
  80346c:	83 c4 1c             	add    $0x1c,%esp
  80346f:	5b                   	pop    %ebx
  803470:	5e                   	pop    %esi
  803471:	5f                   	pop    %edi
  803472:	5d                   	pop    %ebp
  803473:	c3                   	ret    
  803474:	39 ce                	cmp    %ecx,%esi
  803476:	77 28                	ja     8034a0 <__udivdi3+0x7c>
  803478:	0f bd fe             	bsr    %esi,%edi
  80347b:	83 f7 1f             	xor    $0x1f,%edi
  80347e:	75 40                	jne    8034c0 <__udivdi3+0x9c>
  803480:	39 ce                	cmp    %ecx,%esi
  803482:	72 0a                	jb     80348e <__udivdi3+0x6a>
  803484:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803488:	0f 87 9e 00 00 00    	ja     80352c <__udivdi3+0x108>
  80348e:	b8 01 00 00 00       	mov    $0x1,%eax
  803493:	89 fa                	mov    %edi,%edx
  803495:	83 c4 1c             	add    $0x1c,%esp
  803498:	5b                   	pop    %ebx
  803499:	5e                   	pop    %esi
  80349a:	5f                   	pop    %edi
  80349b:	5d                   	pop    %ebp
  80349c:	c3                   	ret    
  80349d:	8d 76 00             	lea    0x0(%esi),%esi
  8034a0:	31 ff                	xor    %edi,%edi
  8034a2:	31 c0                	xor    %eax,%eax
  8034a4:	89 fa                	mov    %edi,%edx
  8034a6:	83 c4 1c             	add    $0x1c,%esp
  8034a9:	5b                   	pop    %ebx
  8034aa:	5e                   	pop    %esi
  8034ab:	5f                   	pop    %edi
  8034ac:	5d                   	pop    %ebp
  8034ad:	c3                   	ret    
  8034ae:	66 90                	xchg   %ax,%ax
  8034b0:	89 d8                	mov    %ebx,%eax
  8034b2:	f7 f7                	div    %edi
  8034b4:	31 ff                	xor    %edi,%edi
  8034b6:	89 fa                	mov    %edi,%edx
  8034b8:	83 c4 1c             	add    $0x1c,%esp
  8034bb:	5b                   	pop    %ebx
  8034bc:	5e                   	pop    %esi
  8034bd:	5f                   	pop    %edi
  8034be:	5d                   	pop    %ebp
  8034bf:	c3                   	ret    
  8034c0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8034c5:	89 eb                	mov    %ebp,%ebx
  8034c7:	29 fb                	sub    %edi,%ebx
  8034c9:	89 f9                	mov    %edi,%ecx
  8034cb:	d3 e6                	shl    %cl,%esi
  8034cd:	89 c5                	mov    %eax,%ebp
  8034cf:	88 d9                	mov    %bl,%cl
  8034d1:	d3 ed                	shr    %cl,%ebp
  8034d3:	89 e9                	mov    %ebp,%ecx
  8034d5:	09 f1                	or     %esi,%ecx
  8034d7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8034db:	89 f9                	mov    %edi,%ecx
  8034dd:	d3 e0                	shl    %cl,%eax
  8034df:	89 c5                	mov    %eax,%ebp
  8034e1:	89 d6                	mov    %edx,%esi
  8034e3:	88 d9                	mov    %bl,%cl
  8034e5:	d3 ee                	shr    %cl,%esi
  8034e7:	89 f9                	mov    %edi,%ecx
  8034e9:	d3 e2                	shl    %cl,%edx
  8034eb:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034ef:	88 d9                	mov    %bl,%cl
  8034f1:	d3 e8                	shr    %cl,%eax
  8034f3:	09 c2                	or     %eax,%edx
  8034f5:	89 d0                	mov    %edx,%eax
  8034f7:	89 f2                	mov    %esi,%edx
  8034f9:	f7 74 24 0c          	divl   0xc(%esp)
  8034fd:	89 d6                	mov    %edx,%esi
  8034ff:	89 c3                	mov    %eax,%ebx
  803501:	f7 e5                	mul    %ebp
  803503:	39 d6                	cmp    %edx,%esi
  803505:	72 19                	jb     803520 <__udivdi3+0xfc>
  803507:	74 0b                	je     803514 <__udivdi3+0xf0>
  803509:	89 d8                	mov    %ebx,%eax
  80350b:	31 ff                	xor    %edi,%edi
  80350d:	e9 58 ff ff ff       	jmp    80346a <__udivdi3+0x46>
  803512:	66 90                	xchg   %ax,%ax
  803514:	8b 54 24 08          	mov    0x8(%esp),%edx
  803518:	89 f9                	mov    %edi,%ecx
  80351a:	d3 e2                	shl    %cl,%edx
  80351c:	39 c2                	cmp    %eax,%edx
  80351e:	73 e9                	jae    803509 <__udivdi3+0xe5>
  803520:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803523:	31 ff                	xor    %edi,%edi
  803525:	e9 40 ff ff ff       	jmp    80346a <__udivdi3+0x46>
  80352a:	66 90                	xchg   %ax,%ax
  80352c:	31 c0                	xor    %eax,%eax
  80352e:	e9 37 ff ff ff       	jmp    80346a <__udivdi3+0x46>
  803533:	90                   	nop

00803534 <__umoddi3>:
  803534:	55                   	push   %ebp
  803535:	57                   	push   %edi
  803536:	56                   	push   %esi
  803537:	53                   	push   %ebx
  803538:	83 ec 1c             	sub    $0x1c,%esp
  80353b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80353f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803543:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803547:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80354b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80354f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803553:	89 f3                	mov    %esi,%ebx
  803555:	89 fa                	mov    %edi,%edx
  803557:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80355b:	89 34 24             	mov    %esi,(%esp)
  80355e:	85 c0                	test   %eax,%eax
  803560:	75 1a                	jne    80357c <__umoddi3+0x48>
  803562:	39 f7                	cmp    %esi,%edi
  803564:	0f 86 a2 00 00 00    	jbe    80360c <__umoddi3+0xd8>
  80356a:	89 c8                	mov    %ecx,%eax
  80356c:	89 f2                	mov    %esi,%edx
  80356e:	f7 f7                	div    %edi
  803570:	89 d0                	mov    %edx,%eax
  803572:	31 d2                	xor    %edx,%edx
  803574:	83 c4 1c             	add    $0x1c,%esp
  803577:	5b                   	pop    %ebx
  803578:	5e                   	pop    %esi
  803579:	5f                   	pop    %edi
  80357a:	5d                   	pop    %ebp
  80357b:	c3                   	ret    
  80357c:	39 f0                	cmp    %esi,%eax
  80357e:	0f 87 ac 00 00 00    	ja     803630 <__umoddi3+0xfc>
  803584:	0f bd e8             	bsr    %eax,%ebp
  803587:	83 f5 1f             	xor    $0x1f,%ebp
  80358a:	0f 84 ac 00 00 00    	je     80363c <__umoddi3+0x108>
  803590:	bf 20 00 00 00       	mov    $0x20,%edi
  803595:	29 ef                	sub    %ebp,%edi
  803597:	89 fe                	mov    %edi,%esi
  803599:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80359d:	89 e9                	mov    %ebp,%ecx
  80359f:	d3 e0                	shl    %cl,%eax
  8035a1:	89 d7                	mov    %edx,%edi
  8035a3:	89 f1                	mov    %esi,%ecx
  8035a5:	d3 ef                	shr    %cl,%edi
  8035a7:	09 c7                	or     %eax,%edi
  8035a9:	89 e9                	mov    %ebp,%ecx
  8035ab:	d3 e2                	shl    %cl,%edx
  8035ad:	89 14 24             	mov    %edx,(%esp)
  8035b0:	89 d8                	mov    %ebx,%eax
  8035b2:	d3 e0                	shl    %cl,%eax
  8035b4:	89 c2                	mov    %eax,%edx
  8035b6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035ba:	d3 e0                	shl    %cl,%eax
  8035bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8035c0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035c4:	89 f1                	mov    %esi,%ecx
  8035c6:	d3 e8                	shr    %cl,%eax
  8035c8:	09 d0                	or     %edx,%eax
  8035ca:	d3 eb                	shr    %cl,%ebx
  8035cc:	89 da                	mov    %ebx,%edx
  8035ce:	f7 f7                	div    %edi
  8035d0:	89 d3                	mov    %edx,%ebx
  8035d2:	f7 24 24             	mull   (%esp)
  8035d5:	89 c6                	mov    %eax,%esi
  8035d7:	89 d1                	mov    %edx,%ecx
  8035d9:	39 d3                	cmp    %edx,%ebx
  8035db:	0f 82 87 00 00 00    	jb     803668 <__umoddi3+0x134>
  8035e1:	0f 84 91 00 00 00    	je     803678 <__umoddi3+0x144>
  8035e7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8035eb:	29 f2                	sub    %esi,%edx
  8035ed:	19 cb                	sbb    %ecx,%ebx
  8035ef:	89 d8                	mov    %ebx,%eax
  8035f1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8035f5:	d3 e0                	shl    %cl,%eax
  8035f7:	89 e9                	mov    %ebp,%ecx
  8035f9:	d3 ea                	shr    %cl,%edx
  8035fb:	09 d0                	or     %edx,%eax
  8035fd:	89 e9                	mov    %ebp,%ecx
  8035ff:	d3 eb                	shr    %cl,%ebx
  803601:	89 da                	mov    %ebx,%edx
  803603:	83 c4 1c             	add    $0x1c,%esp
  803606:	5b                   	pop    %ebx
  803607:	5e                   	pop    %esi
  803608:	5f                   	pop    %edi
  803609:	5d                   	pop    %ebp
  80360a:	c3                   	ret    
  80360b:	90                   	nop
  80360c:	89 fd                	mov    %edi,%ebp
  80360e:	85 ff                	test   %edi,%edi
  803610:	75 0b                	jne    80361d <__umoddi3+0xe9>
  803612:	b8 01 00 00 00       	mov    $0x1,%eax
  803617:	31 d2                	xor    %edx,%edx
  803619:	f7 f7                	div    %edi
  80361b:	89 c5                	mov    %eax,%ebp
  80361d:	89 f0                	mov    %esi,%eax
  80361f:	31 d2                	xor    %edx,%edx
  803621:	f7 f5                	div    %ebp
  803623:	89 c8                	mov    %ecx,%eax
  803625:	f7 f5                	div    %ebp
  803627:	89 d0                	mov    %edx,%eax
  803629:	e9 44 ff ff ff       	jmp    803572 <__umoddi3+0x3e>
  80362e:	66 90                	xchg   %ax,%ax
  803630:	89 c8                	mov    %ecx,%eax
  803632:	89 f2                	mov    %esi,%edx
  803634:	83 c4 1c             	add    $0x1c,%esp
  803637:	5b                   	pop    %ebx
  803638:	5e                   	pop    %esi
  803639:	5f                   	pop    %edi
  80363a:	5d                   	pop    %ebp
  80363b:	c3                   	ret    
  80363c:	3b 04 24             	cmp    (%esp),%eax
  80363f:	72 06                	jb     803647 <__umoddi3+0x113>
  803641:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803645:	77 0f                	ja     803656 <__umoddi3+0x122>
  803647:	89 f2                	mov    %esi,%edx
  803649:	29 f9                	sub    %edi,%ecx
  80364b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80364f:	89 14 24             	mov    %edx,(%esp)
  803652:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803656:	8b 44 24 04          	mov    0x4(%esp),%eax
  80365a:	8b 14 24             	mov    (%esp),%edx
  80365d:	83 c4 1c             	add    $0x1c,%esp
  803660:	5b                   	pop    %ebx
  803661:	5e                   	pop    %esi
  803662:	5f                   	pop    %edi
  803663:	5d                   	pop    %ebp
  803664:	c3                   	ret    
  803665:	8d 76 00             	lea    0x0(%esi),%esi
  803668:	2b 04 24             	sub    (%esp),%eax
  80366b:	19 fa                	sbb    %edi,%edx
  80366d:	89 d1                	mov    %edx,%ecx
  80366f:	89 c6                	mov    %eax,%esi
  803671:	e9 71 ff ff ff       	jmp    8035e7 <__umoddi3+0xb3>
  803676:	66 90                	xchg   %ax,%ax
  803678:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80367c:	72 ea                	jb     803668 <__umoddi3+0x134>
  80367e:	89 d9                	mov    %ebx,%ecx
  803680:	e9 62 ff ff ff       	jmp    8035e7 <__umoddi3+0xb3>
