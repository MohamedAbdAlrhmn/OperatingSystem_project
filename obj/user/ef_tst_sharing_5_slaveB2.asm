
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
  80008c:	68 20 36 80 00       	push   $0x803620
  800091:	6a 12                	push   $0x12
  800093:	68 3c 36 80 00       	push   $0x80363c
  800098:	e8 4c 02 00 00       	call   8002e9 <_panic>
	}
	uint32 *z;
	z = sget(sys_getparentenvid(),"z");
  80009d:	e8 9c 19 00 00       	call   801a3e <sys_getparentenvid>
  8000a2:	83 ec 08             	sub    $0x8,%esp
  8000a5:	68 5c 36 80 00       	push   $0x80365c
  8000aa:	50                   	push   %eax
  8000ab:	e8 f1 14 00 00       	call   8015a1 <sget>
  8000b0:	83 c4 10             	add    $0x10,%esp
  8000b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("Slave B2 env used z (getSharedObject)\n");
  8000b6:	83 ec 0c             	sub    $0xc,%esp
  8000b9:	68 60 36 80 00       	push   $0x803660
  8000be:	e8 da 04 00 00       	call   80059d <cprintf>
  8000c3:	83 c4 10             	add    $0x10,%esp

	cprintf("Slave B2 please be patient ...\n");
  8000c6:	83 ec 0c             	sub    $0xc,%esp
  8000c9:	68 88 36 80 00       	push   $0x803688
  8000ce:	e8 ca 04 00 00       	call   80059d <cprintf>
  8000d3:	83 c4 10             	add    $0x10,%esp

	env_sleep(9000);
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	68 28 23 00 00       	push   $0x2328
  8000de:	e8 24 32 00 00       	call   803307 <env_sleep>
  8000e3:	83 c4 10             	add    $0x10,%esp
	int freeFrames = sys_calculate_free_frames() ;
  8000e6:	e8 5a 16 00 00       	call   801745 <sys_calculate_free_frames>
  8000eb:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sfree(z);
  8000ee:	83 ec 0c             	sub    $0xc,%esp
  8000f1:	ff 75 ec             	pushl  -0x14(%ebp)
  8000f4:	e8 ec 14 00 00       	call   8015e5 <sfree>
  8000f9:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave B2 env removed z\n");
  8000fc:	83 ec 0c             	sub    $0xc,%esp
  8000ff:	68 a8 36 80 00       	push   $0x8036a8
  800104:	e8 94 04 00 00       	call   80059d <cprintf>
  800109:	83 c4 10             	add    $0x10,%esp

	if ((sys_calculate_free_frames() - freeFrames) !=  4) panic("wrong free: frames removed not equal 4 !, correct frames to be removed are 4:\nfrom the env: 1 table + 1 frame for z\nframes_storage of z: should be cleared now\n");
  80010c:	e8 34 16 00 00       	call   801745 <sys_calculate_free_frames>
  800111:	89 c2                	mov    %eax,%edx
  800113:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800116:	29 c2                	sub    %eax,%edx
  800118:	89 d0                	mov    %edx,%eax
  80011a:	83 f8 04             	cmp    $0x4,%eax
  80011d:	74 14                	je     800133 <_main+0xfb>
  80011f:	83 ec 04             	sub    $0x4,%esp
  800122:	68 c0 36 80 00       	push   $0x8036c0
  800127:	6a 20                	push   $0x20
  800129:	68 3c 36 80 00       	push   $0x80363c
  80012e:	e8 b6 01 00 00       	call   8002e9 <_panic>

	//to ensure that the other environments completed successfully
	if (gettst()!=2) panic("test failed");
  800133:	e8 45 1a 00 00       	call   801b7d <gettst>
  800138:	83 f8 02             	cmp    $0x2,%eax
  80013b:	74 14                	je     800151 <_main+0x119>
  80013d:	83 ec 04             	sub    $0x4,%esp
  800140:	68 60 37 80 00       	push   $0x803760
  800145:	6a 23                	push   $0x23
  800147:	68 3c 36 80 00       	push   $0x80363c
  80014c:	e8 98 01 00 00       	call   8002e9 <_panic>

	cprintf("Step B completed successfully!!\n\n\n");
  800151:	83 ec 0c             	sub    $0xc,%esp
  800154:	68 6c 37 80 00       	push   $0x80376c
  800159:	e8 3f 04 00 00       	call   80059d <cprintf>
  80015e:	83 c4 10             	add    $0x10,%esp
	cprintf("Congratulations!! Test of freeSharedObjects [5] completed successfully!!\n\n\n");
  800161:	83 ec 0c             	sub    $0xc,%esp
  800164:	68 90 37 80 00       	push   $0x803790
  800169:	e8 2f 04 00 00       	call   80059d <cprintf>
  80016e:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  800171:	e8 c8 18 00 00       	call   801a3e <sys_getparentenvid>
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
  800189:	68 dc 37 80 00       	push   $0x8037dc
  80018e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800191:	e8 0b 14 00 00       	call   8015a1 <sget>
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
  8001b3:	e8 6d 18 00 00       	call   801a25 <sys_getenvindex>
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
  80021e:	e8 0f 16 00 00       	call   801832 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800223:	83 ec 0c             	sub    $0xc,%esp
  800226:	68 04 38 80 00       	push   $0x803804
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
  80024e:	68 2c 38 80 00       	push   $0x80382c
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
  80027f:	68 54 38 80 00       	push   $0x803854
  800284:	e8 14 03 00 00       	call   80059d <cprintf>
  800289:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80028c:	a1 20 50 80 00       	mov    0x805020,%eax
  800291:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800297:	83 ec 08             	sub    $0x8,%esp
  80029a:	50                   	push   %eax
  80029b:	68 ac 38 80 00       	push   $0x8038ac
  8002a0:	e8 f8 02 00 00       	call   80059d <cprintf>
  8002a5:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8002a8:	83 ec 0c             	sub    $0xc,%esp
  8002ab:	68 04 38 80 00       	push   $0x803804
  8002b0:	e8 e8 02 00 00       	call   80059d <cprintf>
  8002b5:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8002b8:	e8 8f 15 00 00       	call   80184c <sys_enable_interrupt>

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
  8002d0:	e8 1c 17 00 00       	call   8019f1 <sys_destroy_env>
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
  8002e1:	e8 71 17 00 00       	call   801a57 <sys_exit_env>
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
  80030a:	68 c0 38 80 00       	push   $0x8038c0
  80030f:	e8 89 02 00 00       	call   80059d <cprintf>
  800314:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800317:	a1 00 50 80 00       	mov    0x805000,%eax
  80031c:	ff 75 0c             	pushl  0xc(%ebp)
  80031f:	ff 75 08             	pushl  0x8(%ebp)
  800322:	50                   	push   %eax
  800323:	68 c5 38 80 00       	push   $0x8038c5
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
  800347:	68 e1 38 80 00       	push   $0x8038e1
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
  800373:	68 e4 38 80 00       	push   $0x8038e4
  800378:	6a 26                	push   $0x26
  80037a:	68 30 39 80 00       	push   $0x803930
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
  800445:	68 3c 39 80 00       	push   $0x80393c
  80044a:	6a 3a                	push   $0x3a
  80044c:	68 30 39 80 00       	push   $0x803930
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
  8004b5:	68 90 39 80 00       	push   $0x803990
  8004ba:	6a 44                	push   $0x44
  8004bc:	68 30 39 80 00       	push   $0x803930
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
  80050f:	e8 70 11 00 00       	call   801684 <sys_cputs>
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
  800586:	e8 f9 10 00 00       	call   801684 <sys_cputs>
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
  8005d0:	e8 5d 12 00 00       	call   801832 <sys_disable_interrupt>
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
  8005f0:	e8 57 12 00 00       	call   80184c <sys_enable_interrupt>
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
  80063a:	e8 7d 2d 00 00       	call   8033bc <__udivdi3>
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
  80068a:	e8 3d 2e 00 00       	call   8034cc <__umoddi3>
  80068f:	83 c4 10             	add    $0x10,%esp
  800692:	05 f4 3b 80 00       	add    $0x803bf4,%eax
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
  8007e5:	8b 04 85 18 3c 80 00 	mov    0x803c18(,%eax,4),%eax
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
  8008c6:	8b 34 9d 60 3a 80 00 	mov    0x803a60(,%ebx,4),%esi
  8008cd:	85 f6                	test   %esi,%esi
  8008cf:	75 19                	jne    8008ea <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008d1:	53                   	push   %ebx
  8008d2:	68 05 3c 80 00       	push   $0x803c05
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
  8008eb:	68 0e 3c 80 00       	push   $0x803c0e
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
  800918:	be 11 3c 80 00       	mov    $0x803c11,%esi
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
  80133e:	68 70 3d 80 00       	push   $0x803d70
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
  80140e:	e8 b5 03 00 00       	call   8017c8 <sys_allocate_chunk>
  801413:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801416:	a1 20 51 80 00       	mov    0x805120,%eax
  80141b:	83 ec 0c             	sub    $0xc,%esp
  80141e:	50                   	push   %eax
  80141f:	e8 2a 0a 00 00       	call   801e4e <initialize_MemBlocksList>
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
  80144c:	68 95 3d 80 00       	push   $0x803d95
  801451:	6a 33                	push   $0x33
  801453:	68 b3 3d 80 00       	push   $0x803db3
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
  8014cb:	68 c0 3d 80 00       	push   $0x803dc0
  8014d0:	6a 34                	push   $0x34
  8014d2:	68 b3 3d 80 00       	push   $0x803db3
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
  801540:	68 e4 3d 80 00       	push   $0x803de4
  801545:	6a 46                	push   $0x46
  801547:	68 b3 3d 80 00       	push   $0x803db3
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
  80155c:	68 0c 3e 80 00       	push   $0x803e0c
  801561:	6a 61                	push   $0x61
  801563:	68 b3 3d 80 00       	push   $0x803db3
  801568:	e8 7c ed ff ff       	call   8002e9 <_panic>

0080156d <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80156d:	55                   	push   %ebp
  80156e:	89 e5                	mov    %esp,%ebp
  801570:	83 ec 18             	sub    $0x18,%esp
  801573:	8b 45 10             	mov    0x10(%ebp),%eax
  801576:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801579:	e8 a9 fd ff ff       	call   801327 <InitializeUHeap>
	if (size == 0) return NULL ;
  80157e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801582:	75 07                	jne    80158b <smalloc+0x1e>
  801584:	b8 00 00 00 00       	mov    $0x0,%eax
  801589:	eb 14                	jmp    80159f <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  80158b:	83 ec 04             	sub    $0x4,%esp
  80158e:	68 30 3e 80 00       	push   $0x803e30
  801593:	6a 76                	push   $0x76
  801595:	68 b3 3d 80 00       	push   $0x803db3
  80159a:	e8 4a ed ff ff       	call   8002e9 <_panic>

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80159f:	c9                   	leave  
  8015a0:	c3                   	ret    

008015a1 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8015a1:	55                   	push   %ebp
  8015a2:	89 e5                	mov    %esp,%ebp
  8015a4:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015a7:	e8 7b fd ff ff       	call   801327 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8015ac:	83 ec 04             	sub    $0x4,%esp
  8015af:	68 58 3e 80 00       	push   $0x803e58
  8015b4:	68 93 00 00 00       	push   $0x93
  8015b9:	68 b3 3d 80 00       	push   $0x803db3
  8015be:	e8 26 ed ff ff       	call   8002e9 <_panic>

008015c3 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8015c3:	55                   	push   %ebp
  8015c4:	89 e5                	mov    %esp,%ebp
  8015c6:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015c9:	e8 59 fd ff ff       	call   801327 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8015ce:	83 ec 04             	sub    $0x4,%esp
  8015d1:	68 7c 3e 80 00       	push   $0x803e7c
  8015d6:	68 c5 00 00 00       	push   $0xc5
  8015db:	68 b3 3d 80 00       	push   $0x803db3
  8015e0:	e8 04 ed ff ff       	call   8002e9 <_panic>

008015e5 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8015e5:	55                   	push   %ebp
  8015e6:	89 e5                	mov    %esp,%ebp
  8015e8:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8015eb:	83 ec 04             	sub    $0x4,%esp
  8015ee:	68 a4 3e 80 00       	push   $0x803ea4
  8015f3:	68 d9 00 00 00       	push   $0xd9
  8015f8:	68 b3 3d 80 00       	push   $0x803db3
  8015fd:	e8 e7 ec ff ff       	call   8002e9 <_panic>

00801602 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801602:	55                   	push   %ebp
  801603:	89 e5                	mov    %esp,%ebp
  801605:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801608:	83 ec 04             	sub    $0x4,%esp
  80160b:	68 c8 3e 80 00       	push   $0x803ec8
  801610:	68 e4 00 00 00       	push   $0xe4
  801615:	68 b3 3d 80 00       	push   $0x803db3
  80161a:	e8 ca ec ff ff       	call   8002e9 <_panic>

0080161f <shrink>:

}
void shrink(uint32 newSize)
{
  80161f:	55                   	push   %ebp
  801620:	89 e5                	mov    %esp,%ebp
  801622:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801625:	83 ec 04             	sub    $0x4,%esp
  801628:	68 c8 3e 80 00       	push   $0x803ec8
  80162d:	68 e9 00 00 00       	push   $0xe9
  801632:	68 b3 3d 80 00       	push   $0x803db3
  801637:	e8 ad ec ff ff       	call   8002e9 <_panic>

0080163c <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80163c:	55                   	push   %ebp
  80163d:	89 e5                	mov    %esp,%ebp
  80163f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801642:	83 ec 04             	sub    $0x4,%esp
  801645:	68 c8 3e 80 00       	push   $0x803ec8
  80164a:	68 ee 00 00 00       	push   $0xee
  80164f:	68 b3 3d 80 00       	push   $0x803db3
  801654:	e8 90 ec ff ff       	call   8002e9 <_panic>

00801659 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801659:	55                   	push   %ebp
  80165a:	89 e5                	mov    %esp,%ebp
  80165c:	57                   	push   %edi
  80165d:	56                   	push   %esi
  80165e:	53                   	push   %ebx
  80165f:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801662:	8b 45 08             	mov    0x8(%ebp),%eax
  801665:	8b 55 0c             	mov    0xc(%ebp),%edx
  801668:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80166b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80166e:	8b 7d 18             	mov    0x18(%ebp),%edi
  801671:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801674:	cd 30                	int    $0x30
  801676:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801679:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80167c:	83 c4 10             	add    $0x10,%esp
  80167f:	5b                   	pop    %ebx
  801680:	5e                   	pop    %esi
  801681:	5f                   	pop    %edi
  801682:	5d                   	pop    %ebp
  801683:	c3                   	ret    

00801684 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801684:	55                   	push   %ebp
  801685:	89 e5                	mov    %esp,%ebp
  801687:	83 ec 04             	sub    $0x4,%esp
  80168a:	8b 45 10             	mov    0x10(%ebp),%eax
  80168d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801690:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801694:	8b 45 08             	mov    0x8(%ebp),%eax
  801697:	6a 00                	push   $0x0
  801699:	6a 00                	push   $0x0
  80169b:	52                   	push   %edx
  80169c:	ff 75 0c             	pushl  0xc(%ebp)
  80169f:	50                   	push   %eax
  8016a0:	6a 00                	push   $0x0
  8016a2:	e8 b2 ff ff ff       	call   801659 <syscall>
  8016a7:	83 c4 18             	add    $0x18,%esp
}
  8016aa:	90                   	nop
  8016ab:	c9                   	leave  
  8016ac:	c3                   	ret    

008016ad <sys_cgetc>:

int
sys_cgetc(void)
{
  8016ad:	55                   	push   %ebp
  8016ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8016b0:	6a 00                	push   $0x0
  8016b2:	6a 00                	push   $0x0
  8016b4:	6a 00                	push   $0x0
  8016b6:	6a 00                	push   $0x0
  8016b8:	6a 00                	push   $0x0
  8016ba:	6a 01                	push   $0x1
  8016bc:	e8 98 ff ff ff       	call   801659 <syscall>
  8016c1:	83 c4 18             	add    $0x18,%esp
}
  8016c4:	c9                   	leave  
  8016c5:	c3                   	ret    

008016c6 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8016c6:	55                   	push   %ebp
  8016c7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8016c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cf:	6a 00                	push   $0x0
  8016d1:	6a 00                	push   $0x0
  8016d3:	6a 00                	push   $0x0
  8016d5:	52                   	push   %edx
  8016d6:	50                   	push   %eax
  8016d7:	6a 05                	push   $0x5
  8016d9:	e8 7b ff ff ff       	call   801659 <syscall>
  8016de:	83 c4 18             	add    $0x18,%esp
}
  8016e1:	c9                   	leave  
  8016e2:	c3                   	ret    

008016e3 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8016e3:	55                   	push   %ebp
  8016e4:	89 e5                	mov    %esp,%ebp
  8016e6:	56                   	push   %esi
  8016e7:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8016e8:	8b 75 18             	mov    0x18(%ebp),%esi
  8016eb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016ee:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f7:	56                   	push   %esi
  8016f8:	53                   	push   %ebx
  8016f9:	51                   	push   %ecx
  8016fa:	52                   	push   %edx
  8016fb:	50                   	push   %eax
  8016fc:	6a 06                	push   $0x6
  8016fe:	e8 56 ff ff ff       	call   801659 <syscall>
  801703:	83 c4 18             	add    $0x18,%esp
}
  801706:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801709:	5b                   	pop    %ebx
  80170a:	5e                   	pop    %esi
  80170b:	5d                   	pop    %ebp
  80170c:	c3                   	ret    

0080170d <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80170d:	55                   	push   %ebp
  80170e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801710:	8b 55 0c             	mov    0xc(%ebp),%edx
  801713:	8b 45 08             	mov    0x8(%ebp),%eax
  801716:	6a 00                	push   $0x0
  801718:	6a 00                	push   $0x0
  80171a:	6a 00                	push   $0x0
  80171c:	52                   	push   %edx
  80171d:	50                   	push   %eax
  80171e:	6a 07                	push   $0x7
  801720:	e8 34 ff ff ff       	call   801659 <syscall>
  801725:	83 c4 18             	add    $0x18,%esp
}
  801728:	c9                   	leave  
  801729:	c3                   	ret    

0080172a <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80172a:	55                   	push   %ebp
  80172b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80172d:	6a 00                	push   $0x0
  80172f:	6a 00                	push   $0x0
  801731:	6a 00                	push   $0x0
  801733:	ff 75 0c             	pushl  0xc(%ebp)
  801736:	ff 75 08             	pushl  0x8(%ebp)
  801739:	6a 08                	push   $0x8
  80173b:	e8 19 ff ff ff       	call   801659 <syscall>
  801740:	83 c4 18             	add    $0x18,%esp
}
  801743:	c9                   	leave  
  801744:	c3                   	ret    

00801745 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801745:	55                   	push   %ebp
  801746:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801748:	6a 00                	push   $0x0
  80174a:	6a 00                	push   $0x0
  80174c:	6a 00                	push   $0x0
  80174e:	6a 00                	push   $0x0
  801750:	6a 00                	push   $0x0
  801752:	6a 09                	push   $0x9
  801754:	e8 00 ff ff ff       	call   801659 <syscall>
  801759:	83 c4 18             	add    $0x18,%esp
}
  80175c:	c9                   	leave  
  80175d:	c3                   	ret    

0080175e <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80175e:	55                   	push   %ebp
  80175f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801761:	6a 00                	push   $0x0
  801763:	6a 00                	push   $0x0
  801765:	6a 00                	push   $0x0
  801767:	6a 00                	push   $0x0
  801769:	6a 00                	push   $0x0
  80176b:	6a 0a                	push   $0xa
  80176d:	e8 e7 fe ff ff       	call   801659 <syscall>
  801772:	83 c4 18             	add    $0x18,%esp
}
  801775:	c9                   	leave  
  801776:	c3                   	ret    

00801777 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801777:	55                   	push   %ebp
  801778:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80177a:	6a 00                	push   $0x0
  80177c:	6a 00                	push   $0x0
  80177e:	6a 00                	push   $0x0
  801780:	6a 00                	push   $0x0
  801782:	6a 00                	push   $0x0
  801784:	6a 0b                	push   $0xb
  801786:	e8 ce fe ff ff       	call   801659 <syscall>
  80178b:	83 c4 18             	add    $0x18,%esp
}
  80178e:	c9                   	leave  
  80178f:	c3                   	ret    

00801790 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801790:	55                   	push   %ebp
  801791:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801793:	6a 00                	push   $0x0
  801795:	6a 00                	push   $0x0
  801797:	6a 00                	push   $0x0
  801799:	ff 75 0c             	pushl  0xc(%ebp)
  80179c:	ff 75 08             	pushl  0x8(%ebp)
  80179f:	6a 0f                	push   $0xf
  8017a1:	e8 b3 fe ff ff       	call   801659 <syscall>
  8017a6:	83 c4 18             	add    $0x18,%esp
	return;
  8017a9:	90                   	nop
}
  8017aa:	c9                   	leave  
  8017ab:	c3                   	ret    

008017ac <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8017ac:	55                   	push   %ebp
  8017ad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8017af:	6a 00                	push   $0x0
  8017b1:	6a 00                	push   $0x0
  8017b3:	6a 00                	push   $0x0
  8017b5:	ff 75 0c             	pushl  0xc(%ebp)
  8017b8:	ff 75 08             	pushl  0x8(%ebp)
  8017bb:	6a 10                	push   $0x10
  8017bd:	e8 97 fe ff ff       	call   801659 <syscall>
  8017c2:	83 c4 18             	add    $0x18,%esp
	return ;
  8017c5:	90                   	nop
}
  8017c6:	c9                   	leave  
  8017c7:	c3                   	ret    

008017c8 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8017c8:	55                   	push   %ebp
  8017c9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8017cb:	6a 00                	push   $0x0
  8017cd:	6a 00                	push   $0x0
  8017cf:	ff 75 10             	pushl  0x10(%ebp)
  8017d2:	ff 75 0c             	pushl  0xc(%ebp)
  8017d5:	ff 75 08             	pushl  0x8(%ebp)
  8017d8:	6a 11                	push   $0x11
  8017da:	e8 7a fe ff ff       	call   801659 <syscall>
  8017df:	83 c4 18             	add    $0x18,%esp
	return ;
  8017e2:	90                   	nop
}
  8017e3:	c9                   	leave  
  8017e4:	c3                   	ret    

008017e5 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8017e5:	55                   	push   %ebp
  8017e6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8017e8:	6a 00                	push   $0x0
  8017ea:	6a 00                	push   $0x0
  8017ec:	6a 00                	push   $0x0
  8017ee:	6a 00                	push   $0x0
  8017f0:	6a 00                	push   $0x0
  8017f2:	6a 0c                	push   $0xc
  8017f4:	e8 60 fe ff ff       	call   801659 <syscall>
  8017f9:	83 c4 18             	add    $0x18,%esp
}
  8017fc:	c9                   	leave  
  8017fd:	c3                   	ret    

008017fe <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8017fe:	55                   	push   %ebp
  8017ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801801:	6a 00                	push   $0x0
  801803:	6a 00                	push   $0x0
  801805:	6a 00                	push   $0x0
  801807:	6a 00                	push   $0x0
  801809:	ff 75 08             	pushl  0x8(%ebp)
  80180c:	6a 0d                	push   $0xd
  80180e:	e8 46 fe ff ff       	call   801659 <syscall>
  801813:	83 c4 18             	add    $0x18,%esp
}
  801816:	c9                   	leave  
  801817:	c3                   	ret    

00801818 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801818:	55                   	push   %ebp
  801819:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80181b:	6a 00                	push   $0x0
  80181d:	6a 00                	push   $0x0
  80181f:	6a 00                	push   $0x0
  801821:	6a 00                	push   $0x0
  801823:	6a 00                	push   $0x0
  801825:	6a 0e                	push   $0xe
  801827:	e8 2d fe ff ff       	call   801659 <syscall>
  80182c:	83 c4 18             	add    $0x18,%esp
}
  80182f:	90                   	nop
  801830:	c9                   	leave  
  801831:	c3                   	ret    

00801832 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801832:	55                   	push   %ebp
  801833:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801835:	6a 00                	push   $0x0
  801837:	6a 00                	push   $0x0
  801839:	6a 00                	push   $0x0
  80183b:	6a 00                	push   $0x0
  80183d:	6a 00                	push   $0x0
  80183f:	6a 13                	push   $0x13
  801841:	e8 13 fe ff ff       	call   801659 <syscall>
  801846:	83 c4 18             	add    $0x18,%esp
}
  801849:	90                   	nop
  80184a:	c9                   	leave  
  80184b:	c3                   	ret    

0080184c <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80184c:	55                   	push   %ebp
  80184d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80184f:	6a 00                	push   $0x0
  801851:	6a 00                	push   $0x0
  801853:	6a 00                	push   $0x0
  801855:	6a 00                	push   $0x0
  801857:	6a 00                	push   $0x0
  801859:	6a 14                	push   $0x14
  80185b:	e8 f9 fd ff ff       	call   801659 <syscall>
  801860:	83 c4 18             	add    $0x18,%esp
}
  801863:	90                   	nop
  801864:	c9                   	leave  
  801865:	c3                   	ret    

00801866 <sys_cputc>:


void
sys_cputc(const char c)
{
  801866:	55                   	push   %ebp
  801867:	89 e5                	mov    %esp,%ebp
  801869:	83 ec 04             	sub    $0x4,%esp
  80186c:	8b 45 08             	mov    0x8(%ebp),%eax
  80186f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801872:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801876:	6a 00                	push   $0x0
  801878:	6a 00                	push   $0x0
  80187a:	6a 00                	push   $0x0
  80187c:	6a 00                	push   $0x0
  80187e:	50                   	push   %eax
  80187f:	6a 15                	push   $0x15
  801881:	e8 d3 fd ff ff       	call   801659 <syscall>
  801886:	83 c4 18             	add    $0x18,%esp
}
  801889:	90                   	nop
  80188a:	c9                   	leave  
  80188b:	c3                   	ret    

0080188c <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80188c:	55                   	push   %ebp
  80188d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80188f:	6a 00                	push   $0x0
  801891:	6a 00                	push   $0x0
  801893:	6a 00                	push   $0x0
  801895:	6a 00                	push   $0x0
  801897:	6a 00                	push   $0x0
  801899:	6a 16                	push   $0x16
  80189b:	e8 b9 fd ff ff       	call   801659 <syscall>
  8018a0:	83 c4 18             	add    $0x18,%esp
}
  8018a3:	90                   	nop
  8018a4:	c9                   	leave  
  8018a5:	c3                   	ret    

008018a6 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8018a6:	55                   	push   %ebp
  8018a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8018a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 00                	push   $0x0
  8018b0:	6a 00                	push   $0x0
  8018b2:	ff 75 0c             	pushl  0xc(%ebp)
  8018b5:	50                   	push   %eax
  8018b6:	6a 17                	push   $0x17
  8018b8:	e8 9c fd ff ff       	call   801659 <syscall>
  8018bd:	83 c4 18             	add    $0x18,%esp
}
  8018c0:	c9                   	leave  
  8018c1:	c3                   	ret    

008018c2 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8018c2:	55                   	push   %ebp
  8018c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cb:	6a 00                	push   $0x0
  8018cd:	6a 00                	push   $0x0
  8018cf:	6a 00                	push   $0x0
  8018d1:	52                   	push   %edx
  8018d2:	50                   	push   %eax
  8018d3:	6a 1a                	push   $0x1a
  8018d5:	e8 7f fd ff ff       	call   801659 <syscall>
  8018da:	83 c4 18             	add    $0x18,%esp
}
  8018dd:	c9                   	leave  
  8018de:	c3                   	ret    

008018df <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8018df:	55                   	push   %ebp
  8018e0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e8:	6a 00                	push   $0x0
  8018ea:	6a 00                	push   $0x0
  8018ec:	6a 00                	push   $0x0
  8018ee:	52                   	push   %edx
  8018ef:	50                   	push   %eax
  8018f0:	6a 18                	push   $0x18
  8018f2:	e8 62 fd ff ff       	call   801659 <syscall>
  8018f7:	83 c4 18             	add    $0x18,%esp
}
  8018fa:	90                   	nop
  8018fb:	c9                   	leave  
  8018fc:	c3                   	ret    

008018fd <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8018fd:	55                   	push   %ebp
  8018fe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801900:	8b 55 0c             	mov    0xc(%ebp),%edx
  801903:	8b 45 08             	mov    0x8(%ebp),%eax
  801906:	6a 00                	push   $0x0
  801908:	6a 00                	push   $0x0
  80190a:	6a 00                	push   $0x0
  80190c:	52                   	push   %edx
  80190d:	50                   	push   %eax
  80190e:	6a 19                	push   $0x19
  801910:	e8 44 fd ff ff       	call   801659 <syscall>
  801915:	83 c4 18             	add    $0x18,%esp
}
  801918:	90                   	nop
  801919:	c9                   	leave  
  80191a:	c3                   	ret    

0080191b <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80191b:	55                   	push   %ebp
  80191c:	89 e5                	mov    %esp,%ebp
  80191e:	83 ec 04             	sub    $0x4,%esp
  801921:	8b 45 10             	mov    0x10(%ebp),%eax
  801924:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801927:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80192a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80192e:	8b 45 08             	mov    0x8(%ebp),%eax
  801931:	6a 00                	push   $0x0
  801933:	51                   	push   %ecx
  801934:	52                   	push   %edx
  801935:	ff 75 0c             	pushl  0xc(%ebp)
  801938:	50                   	push   %eax
  801939:	6a 1b                	push   $0x1b
  80193b:	e8 19 fd ff ff       	call   801659 <syscall>
  801940:	83 c4 18             	add    $0x18,%esp
}
  801943:	c9                   	leave  
  801944:	c3                   	ret    

00801945 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801945:	55                   	push   %ebp
  801946:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801948:	8b 55 0c             	mov    0xc(%ebp),%edx
  80194b:	8b 45 08             	mov    0x8(%ebp),%eax
  80194e:	6a 00                	push   $0x0
  801950:	6a 00                	push   $0x0
  801952:	6a 00                	push   $0x0
  801954:	52                   	push   %edx
  801955:	50                   	push   %eax
  801956:	6a 1c                	push   $0x1c
  801958:	e8 fc fc ff ff       	call   801659 <syscall>
  80195d:	83 c4 18             	add    $0x18,%esp
}
  801960:	c9                   	leave  
  801961:	c3                   	ret    

00801962 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801962:	55                   	push   %ebp
  801963:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801965:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801968:	8b 55 0c             	mov    0xc(%ebp),%edx
  80196b:	8b 45 08             	mov    0x8(%ebp),%eax
  80196e:	6a 00                	push   $0x0
  801970:	6a 00                	push   $0x0
  801972:	51                   	push   %ecx
  801973:	52                   	push   %edx
  801974:	50                   	push   %eax
  801975:	6a 1d                	push   $0x1d
  801977:	e8 dd fc ff ff       	call   801659 <syscall>
  80197c:	83 c4 18             	add    $0x18,%esp
}
  80197f:	c9                   	leave  
  801980:	c3                   	ret    

00801981 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801981:	55                   	push   %ebp
  801982:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801984:	8b 55 0c             	mov    0xc(%ebp),%edx
  801987:	8b 45 08             	mov    0x8(%ebp),%eax
  80198a:	6a 00                	push   $0x0
  80198c:	6a 00                	push   $0x0
  80198e:	6a 00                	push   $0x0
  801990:	52                   	push   %edx
  801991:	50                   	push   %eax
  801992:	6a 1e                	push   $0x1e
  801994:	e8 c0 fc ff ff       	call   801659 <syscall>
  801999:	83 c4 18             	add    $0x18,%esp
}
  80199c:	c9                   	leave  
  80199d:	c3                   	ret    

0080199e <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80199e:	55                   	push   %ebp
  80199f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 00                	push   $0x0
  8019ab:	6a 1f                	push   $0x1f
  8019ad:	e8 a7 fc ff ff       	call   801659 <syscall>
  8019b2:	83 c4 18             	add    $0x18,%esp
}
  8019b5:	c9                   	leave  
  8019b6:	c3                   	ret    

008019b7 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8019b7:	55                   	push   %ebp
  8019b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8019ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bd:	6a 00                	push   $0x0
  8019bf:	ff 75 14             	pushl  0x14(%ebp)
  8019c2:	ff 75 10             	pushl  0x10(%ebp)
  8019c5:	ff 75 0c             	pushl  0xc(%ebp)
  8019c8:	50                   	push   %eax
  8019c9:	6a 20                	push   $0x20
  8019cb:	e8 89 fc ff ff       	call   801659 <syscall>
  8019d0:	83 c4 18             	add    $0x18,%esp
}
  8019d3:	c9                   	leave  
  8019d4:	c3                   	ret    

008019d5 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8019d5:	55                   	push   %ebp
  8019d6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8019d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 00                	push   $0x0
  8019e3:	50                   	push   %eax
  8019e4:	6a 21                	push   $0x21
  8019e6:	e8 6e fc ff ff       	call   801659 <syscall>
  8019eb:	83 c4 18             	add    $0x18,%esp
}
  8019ee:	90                   	nop
  8019ef:	c9                   	leave  
  8019f0:	c3                   	ret    

008019f1 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8019f1:	55                   	push   %ebp
  8019f2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8019f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f7:	6a 00                	push   $0x0
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 00                	push   $0x0
  8019fd:	6a 00                	push   $0x0
  8019ff:	50                   	push   %eax
  801a00:	6a 22                	push   $0x22
  801a02:	e8 52 fc ff ff       	call   801659 <syscall>
  801a07:	83 c4 18             	add    $0x18,%esp
}
  801a0a:	c9                   	leave  
  801a0b:	c3                   	ret    

00801a0c <sys_getenvid>:

int32 sys_getenvid(void)
{
  801a0c:	55                   	push   %ebp
  801a0d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801a0f:	6a 00                	push   $0x0
  801a11:	6a 00                	push   $0x0
  801a13:	6a 00                	push   $0x0
  801a15:	6a 00                	push   $0x0
  801a17:	6a 00                	push   $0x0
  801a19:	6a 02                	push   $0x2
  801a1b:	e8 39 fc ff ff       	call   801659 <syscall>
  801a20:	83 c4 18             	add    $0x18,%esp
}
  801a23:	c9                   	leave  
  801a24:	c3                   	ret    

00801a25 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801a25:	55                   	push   %ebp
  801a26:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 00                	push   $0x0
  801a32:	6a 03                	push   $0x3
  801a34:	e8 20 fc ff ff       	call   801659 <syscall>
  801a39:	83 c4 18             	add    $0x18,%esp
}
  801a3c:	c9                   	leave  
  801a3d:	c3                   	ret    

00801a3e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801a3e:	55                   	push   %ebp
  801a3f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801a41:	6a 00                	push   $0x0
  801a43:	6a 00                	push   $0x0
  801a45:	6a 00                	push   $0x0
  801a47:	6a 00                	push   $0x0
  801a49:	6a 00                	push   $0x0
  801a4b:	6a 04                	push   $0x4
  801a4d:	e8 07 fc ff ff       	call   801659 <syscall>
  801a52:	83 c4 18             	add    $0x18,%esp
}
  801a55:	c9                   	leave  
  801a56:	c3                   	ret    

00801a57 <sys_exit_env>:


void sys_exit_env(void)
{
  801a57:	55                   	push   %ebp
  801a58:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801a5a:	6a 00                	push   $0x0
  801a5c:	6a 00                	push   $0x0
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 00                	push   $0x0
  801a62:	6a 00                	push   $0x0
  801a64:	6a 23                	push   $0x23
  801a66:	e8 ee fb ff ff       	call   801659 <syscall>
  801a6b:	83 c4 18             	add    $0x18,%esp
}
  801a6e:	90                   	nop
  801a6f:	c9                   	leave  
  801a70:	c3                   	ret    

00801a71 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801a71:	55                   	push   %ebp
  801a72:	89 e5                	mov    %esp,%ebp
  801a74:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801a77:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a7a:	8d 50 04             	lea    0x4(%eax),%edx
  801a7d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a80:	6a 00                	push   $0x0
  801a82:	6a 00                	push   $0x0
  801a84:	6a 00                	push   $0x0
  801a86:	52                   	push   %edx
  801a87:	50                   	push   %eax
  801a88:	6a 24                	push   $0x24
  801a8a:	e8 ca fb ff ff       	call   801659 <syscall>
  801a8f:	83 c4 18             	add    $0x18,%esp
	return result;
  801a92:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a95:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a98:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a9b:	89 01                	mov    %eax,(%ecx)
  801a9d:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa3:	c9                   	leave  
  801aa4:	c2 04 00             	ret    $0x4

00801aa7 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801aa7:	55                   	push   %ebp
  801aa8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801aaa:	6a 00                	push   $0x0
  801aac:	6a 00                	push   $0x0
  801aae:	ff 75 10             	pushl  0x10(%ebp)
  801ab1:	ff 75 0c             	pushl  0xc(%ebp)
  801ab4:	ff 75 08             	pushl  0x8(%ebp)
  801ab7:	6a 12                	push   $0x12
  801ab9:	e8 9b fb ff ff       	call   801659 <syscall>
  801abe:	83 c4 18             	add    $0x18,%esp
	return ;
  801ac1:	90                   	nop
}
  801ac2:	c9                   	leave  
  801ac3:	c3                   	ret    

00801ac4 <sys_rcr2>:
uint32 sys_rcr2()
{
  801ac4:	55                   	push   %ebp
  801ac5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 00                	push   $0x0
  801acd:	6a 00                	push   $0x0
  801acf:	6a 00                	push   $0x0
  801ad1:	6a 25                	push   $0x25
  801ad3:	e8 81 fb ff ff       	call   801659 <syscall>
  801ad8:	83 c4 18             	add    $0x18,%esp
}
  801adb:	c9                   	leave  
  801adc:	c3                   	ret    

00801add <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801add:	55                   	push   %ebp
  801ade:	89 e5                	mov    %esp,%ebp
  801ae0:	83 ec 04             	sub    $0x4,%esp
  801ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ae9:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801aed:	6a 00                	push   $0x0
  801aef:	6a 00                	push   $0x0
  801af1:	6a 00                	push   $0x0
  801af3:	6a 00                	push   $0x0
  801af5:	50                   	push   %eax
  801af6:	6a 26                	push   $0x26
  801af8:	e8 5c fb ff ff       	call   801659 <syscall>
  801afd:	83 c4 18             	add    $0x18,%esp
	return ;
  801b00:	90                   	nop
}
  801b01:	c9                   	leave  
  801b02:	c3                   	ret    

00801b03 <rsttst>:
void rsttst()
{
  801b03:	55                   	push   %ebp
  801b04:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801b06:	6a 00                	push   $0x0
  801b08:	6a 00                	push   $0x0
  801b0a:	6a 00                	push   $0x0
  801b0c:	6a 00                	push   $0x0
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 28                	push   $0x28
  801b12:	e8 42 fb ff ff       	call   801659 <syscall>
  801b17:	83 c4 18             	add    $0x18,%esp
	return ;
  801b1a:	90                   	nop
}
  801b1b:	c9                   	leave  
  801b1c:	c3                   	ret    

00801b1d <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801b1d:	55                   	push   %ebp
  801b1e:	89 e5                	mov    %esp,%ebp
  801b20:	83 ec 04             	sub    $0x4,%esp
  801b23:	8b 45 14             	mov    0x14(%ebp),%eax
  801b26:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801b29:	8b 55 18             	mov    0x18(%ebp),%edx
  801b2c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b30:	52                   	push   %edx
  801b31:	50                   	push   %eax
  801b32:	ff 75 10             	pushl  0x10(%ebp)
  801b35:	ff 75 0c             	pushl  0xc(%ebp)
  801b38:	ff 75 08             	pushl  0x8(%ebp)
  801b3b:	6a 27                	push   $0x27
  801b3d:	e8 17 fb ff ff       	call   801659 <syscall>
  801b42:	83 c4 18             	add    $0x18,%esp
	return ;
  801b45:	90                   	nop
}
  801b46:	c9                   	leave  
  801b47:	c3                   	ret    

00801b48 <chktst>:
void chktst(uint32 n)
{
  801b48:	55                   	push   %ebp
  801b49:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 00                	push   $0x0
  801b4f:	6a 00                	push   $0x0
  801b51:	6a 00                	push   $0x0
  801b53:	ff 75 08             	pushl  0x8(%ebp)
  801b56:	6a 29                	push   $0x29
  801b58:	e8 fc fa ff ff       	call   801659 <syscall>
  801b5d:	83 c4 18             	add    $0x18,%esp
	return ;
  801b60:	90                   	nop
}
  801b61:	c9                   	leave  
  801b62:	c3                   	ret    

00801b63 <inctst>:

void inctst()
{
  801b63:	55                   	push   %ebp
  801b64:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801b66:	6a 00                	push   $0x0
  801b68:	6a 00                	push   $0x0
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 00                	push   $0x0
  801b6e:	6a 00                	push   $0x0
  801b70:	6a 2a                	push   $0x2a
  801b72:	e8 e2 fa ff ff       	call   801659 <syscall>
  801b77:	83 c4 18             	add    $0x18,%esp
	return ;
  801b7a:	90                   	nop
}
  801b7b:	c9                   	leave  
  801b7c:	c3                   	ret    

00801b7d <gettst>:
uint32 gettst()
{
  801b7d:	55                   	push   %ebp
  801b7e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801b80:	6a 00                	push   $0x0
  801b82:	6a 00                	push   $0x0
  801b84:	6a 00                	push   $0x0
  801b86:	6a 00                	push   $0x0
  801b88:	6a 00                	push   $0x0
  801b8a:	6a 2b                	push   $0x2b
  801b8c:	e8 c8 fa ff ff       	call   801659 <syscall>
  801b91:	83 c4 18             	add    $0x18,%esp
}
  801b94:	c9                   	leave  
  801b95:	c3                   	ret    

00801b96 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801b96:	55                   	push   %ebp
  801b97:	89 e5                	mov    %esp,%ebp
  801b99:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b9c:	6a 00                	push   $0x0
  801b9e:	6a 00                	push   $0x0
  801ba0:	6a 00                	push   $0x0
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 00                	push   $0x0
  801ba6:	6a 2c                	push   $0x2c
  801ba8:	e8 ac fa ff ff       	call   801659 <syscall>
  801bad:	83 c4 18             	add    $0x18,%esp
  801bb0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801bb3:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801bb7:	75 07                	jne    801bc0 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801bb9:	b8 01 00 00 00       	mov    $0x1,%eax
  801bbe:	eb 05                	jmp    801bc5 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801bc0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bc5:	c9                   	leave  
  801bc6:	c3                   	ret    

00801bc7 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801bc7:	55                   	push   %ebp
  801bc8:	89 e5                	mov    %esp,%ebp
  801bca:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 00                	push   $0x0
  801bd1:	6a 00                	push   $0x0
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 2c                	push   $0x2c
  801bd9:	e8 7b fa ff ff       	call   801659 <syscall>
  801bde:	83 c4 18             	add    $0x18,%esp
  801be1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801be4:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801be8:	75 07                	jne    801bf1 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801bea:	b8 01 00 00 00       	mov    $0x1,%eax
  801bef:	eb 05                	jmp    801bf6 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801bf1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bf6:	c9                   	leave  
  801bf7:	c3                   	ret    

00801bf8 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801bf8:	55                   	push   %ebp
  801bf9:	89 e5                	mov    %esp,%ebp
  801bfb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	6a 00                	push   $0x0
  801c04:	6a 00                	push   $0x0
  801c06:	6a 00                	push   $0x0
  801c08:	6a 2c                	push   $0x2c
  801c0a:	e8 4a fa ff ff       	call   801659 <syscall>
  801c0f:	83 c4 18             	add    $0x18,%esp
  801c12:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801c15:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801c19:	75 07                	jne    801c22 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801c1b:	b8 01 00 00 00       	mov    $0x1,%eax
  801c20:	eb 05                	jmp    801c27 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801c22:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c27:	c9                   	leave  
  801c28:	c3                   	ret    

00801c29 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801c29:	55                   	push   %ebp
  801c2a:	89 e5                	mov    %esp,%ebp
  801c2c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 00                	push   $0x0
  801c33:	6a 00                	push   $0x0
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	6a 2c                	push   $0x2c
  801c3b:	e8 19 fa ff ff       	call   801659 <syscall>
  801c40:	83 c4 18             	add    $0x18,%esp
  801c43:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801c46:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801c4a:	75 07                	jne    801c53 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801c4c:	b8 01 00 00 00       	mov    $0x1,%eax
  801c51:	eb 05                	jmp    801c58 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801c53:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c58:	c9                   	leave  
  801c59:	c3                   	ret    

00801c5a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c5a:	55                   	push   %ebp
  801c5b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c5d:	6a 00                	push   $0x0
  801c5f:	6a 00                	push   $0x0
  801c61:	6a 00                	push   $0x0
  801c63:	6a 00                	push   $0x0
  801c65:	ff 75 08             	pushl  0x8(%ebp)
  801c68:	6a 2d                	push   $0x2d
  801c6a:	e8 ea f9 ff ff       	call   801659 <syscall>
  801c6f:	83 c4 18             	add    $0x18,%esp
	return ;
  801c72:	90                   	nop
}
  801c73:	c9                   	leave  
  801c74:	c3                   	ret    

00801c75 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801c75:	55                   	push   %ebp
  801c76:	89 e5                	mov    %esp,%ebp
  801c78:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801c79:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c7c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c82:	8b 45 08             	mov    0x8(%ebp),%eax
  801c85:	6a 00                	push   $0x0
  801c87:	53                   	push   %ebx
  801c88:	51                   	push   %ecx
  801c89:	52                   	push   %edx
  801c8a:	50                   	push   %eax
  801c8b:	6a 2e                	push   $0x2e
  801c8d:	e8 c7 f9 ff ff       	call   801659 <syscall>
  801c92:	83 c4 18             	add    $0x18,%esp
}
  801c95:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c98:	c9                   	leave  
  801c99:	c3                   	ret    

00801c9a <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801c9a:	55                   	push   %ebp
  801c9b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801c9d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ca0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 00                	push   $0x0
  801ca7:	6a 00                	push   $0x0
  801ca9:	52                   	push   %edx
  801caa:	50                   	push   %eax
  801cab:	6a 2f                	push   $0x2f
  801cad:	e8 a7 f9 ff ff       	call   801659 <syscall>
  801cb2:	83 c4 18             	add    $0x18,%esp
}
  801cb5:	c9                   	leave  
  801cb6:	c3                   	ret    

00801cb7 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801cb7:	55                   	push   %ebp
  801cb8:	89 e5                	mov    %esp,%ebp
  801cba:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801cbd:	83 ec 0c             	sub    $0xc,%esp
  801cc0:	68 d8 3e 80 00       	push   $0x803ed8
  801cc5:	e8 d3 e8 ff ff       	call   80059d <cprintf>
  801cca:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801ccd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801cd4:	83 ec 0c             	sub    $0xc,%esp
  801cd7:	68 04 3f 80 00       	push   $0x803f04
  801cdc:	e8 bc e8 ff ff       	call   80059d <cprintf>
  801ce1:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801ce4:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ce8:	a1 38 51 80 00       	mov    0x805138,%eax
  801ced:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801cf0:	eb 56                	jmp    801d48 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801cf2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801cf6:	74 1c                	je     801d14 <print_mem_block_lists+0x5d>
  801cf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cfb:	8b 50 08             	mov    0x8(%eax),%edx
  801cfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d01:	8b 48 08             	mov    0x8(%eax),%ecx
  801d04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d07:	8b 40 0c             	mov    0xc(%eax),%eax
  801d0a:	01 c8                	add    %ecx,%eax
  801d0c:	39 c2                	cmp    %eax,%edx
  801d0e:	73 04                	jae    801d14 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801d10:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801d14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d17:	8b 50 08             	mov    0x8(%eax),%edx
  801d1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d1d:	8b 40 0c             	mov    0xc(%eax),%eax
  801d20:	01 c2                	add    %eax,%edx
  801d22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d25:	8b 40 08             	mov    0x8(%eax),%eax
  801d28:	83 ec 04             	sub    $0x4,%esp
  801d2b:	52                   	push   %edx
  801d2c:	50                   	push   %eax
  801d2d:	68 19 3f 80 00       	push   $0x803f19
  801d32:	e8 66 e8 ff ff       	call   80059d <cprintf>
  801d37:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801d3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d40:	a1 40 51 80 00       	mov    0x805140,%eax
  801d45:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d48:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d4c:	74 07                	je     801d55 <print_mem_block_lists+0x9e>
  801d4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d51:	8b 00                	mov    (%eax),%eax
  801d53:	eb 05                	jmp    801d5a <print_mem_block_lists+0xa3>
  801d55:	b8 00 00 00 00       	mov    $0x0,%eax
  801d5a:	a3 40 51 80 00       	mov    %eax,0x805140
  801d5f:	a1 40 51 80 00       	mov    0x805140,%eax
  801d64:	85 c0                	test   %eax,%eax
  801d66:	75 8a                	jne    801cf2 <print_mem_block_lists+0x3b>
  801d68:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d6c:	75 84                	jne    801cf2 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801d6e:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801d72:	75 10                	jne    801d84 <print_mem_block_lists+0xcd>
  801d74:	83 ec 0c             	sub    $0xc,%esp
  801d77:	68 28 3f 80 00       	push   $0x803f28
  801d7c:	e8 1c e8 ff ff       	call   80059d <cprintf>
  801d81:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801d84:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801d8b:	83 ec 0c             	sub    $0xc,%esp
  801d8e:	68 4c 3f 80 00       	push   $0x803f4c
  801d93:	e8 05 e8 ff ff       	call   80059d <cprintf>
  801d98:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801d9b:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801d9f:	a1 40 50 80 00       	mov    0x805040,%eax
  801da4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801da7:	eb 56                	jmp    801dff <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801da9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801dad:	74 1c                	je     801dcb <print_mem_block_lists+0x114>
  801daf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db2:	8b 50 08             	mov    0x8(%eax),%edx
  801db5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801db8:	8b 48 08             	mov    0x8(%eax),%ecx
  801dbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dbe:	8b 40 0c             	mov    0xc(%eax),%eax
  801dc1:	01 c8                	add    %ecx,%eax
  801dc3:	39 c2                	cmp    %eax,%edx
  801dc5:	73 04                	jae    801dcb <print_mem_block_lists+0x114>
			sorted = 0 ;
  801dc7:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801dcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dce:	8b 50 08             	mov    0x8(%eax),%edx
  801dd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd4:	8b 40 0c             	mov    0xc(%eax),%eax
  801dd7:	01 c2                	add    %eax,%edx
  801dd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ddc:	8b 40 08             	mov    0x8(%eax),%eax
  801ddf:	83 ec 04             	sub    $0x4,%esp
  801de2:	52                   	push   %edx
  801de3:	50                   	push   %eax
  801de4:	68 19 3f 80 00       	push   $0x803f19
  801de9:	e8 af e7 ff ff       	call   80059d <cprintf>
  801dee:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801df1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801df7:	a1 48 50 80 00       	mov    0x805048,%eax
  801dfc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e03:	74 07                	je     801e0c <print_mem_block_lists+0x155>
  801e05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e08:	8b 00                	mov    (%eax),%eax
  801e0a:	eb 05                	jmp    801e11 <print_mem_block_lists+0x15a>
  801e0c:	b8 00 00 00 00       	mov    $0x0,%eax
  801e11:	a3 48 50 80 00       	mov    %eax,0x805048
  801e16:	a1 48 50 80 00       	mov    0x805048,%eax
  801e1b:	85 c0                	test   %eax,%eax
  801e1d:	75 8a                	jne    801da9 <print_mem_block_lists+0xf2>
  801e1f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e23:	75 84                	jne    801da9 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801e25:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e29:	75 10                	jne    801e3b <print_mem_block_lists+0x184>
  801e2b:	83 ec 0c             	sub    $0xc,%esp
  801e2e:	68 64 3f 80 00       	push   $0x803f64
  801e33:	e8 65 e7 ff ff       	call   80059d <cprintf>
  801e38:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801e3b:	83 ec 0c             	sub    $0xc,%esp
  801e3e:	68 d8 3e 80 00       	push   $0x803ed8
  801e43:	e8 55 e7 ff ff       	call   80059d <cprintf>
  801e48:	83 c4 10             	add    $0x10,%esp

}
  801e4b:	90                   	nop
  801e4c:	c9                   	leave  
  801e4d:	c3                   	ret    

00801e4e <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801e4e:	55                   	push   %ebp
  801e4f:	89 e5                	mov    %esp,%ebp
  801e51:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801e54:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  801e5b:	00 00 00 
  801e5e:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  801e65:	00 00 00 
  801e68:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  801e6f:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801e72:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801e79:	e9 9e 00 00 00       	jmp    801f1c <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801e7e:	a1 50 50 80 00       	mov    0x805050,%eax
  801e83:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e86:	c1 e2 04             	shl    $0x4,%edx
  801e89:	01 d0                	add    %edx,%eax
  801e8b:	85 c0                	test   %eax,%eax
  801e8d:	75 14                	jne    801ea3 <initialize_MemBlocksList+0x55>
  801e8f:	83 ec 04             	sub    $0x4,%esp
  801e92:	68 8c 3f 80 00       	push   $0x803f8c
  801e97:	6a 46                	push   $0x46
  801e99:	68 af 3f 80 00       	push   $0x803faf
  801e9e:	e8 46 e4 ff ff       	call   8002e9 <_panic>
  801ea3:	a1 50 50 80 00       	mov    0x805050,%eax
  801ea8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801eab:	c1 e2 04             	shl    $0x4,%edx
  801eae:	01 d0                	add    %edx,%eax
  801eb0:	8b 15 48 51 80 00    	mov    0x805148,%edx
  801eb6:	89 10                	mov    %edx,(%eax)
  801eb8:	8b 00                	mov    (%eax),%eax
  801eba:	85 c0                	test   %eax,%eax
  801ebc:	74 18                	je     801ed6 <initialize_MemBlocksList+0x88>
  801ebe:	a1 48 51 80 00       	mov    0x805148,%eax
  801ec3:	8b 15 50 50 80 00    	mov    0x805050,%edx
  801ec9:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801ecc:	c1 e1 04             	shl    $0x4,%ecx
  801ecf:	01 ca                	add    %ecx,%edx
  801ed1:	89 50 04             	mov    %edx,0x4(%eax)
  801ed4:	eb 12                	jmp    801ee8 <initialize_MemBlocksList+0x9a>
  801ed6:	a1 50 50 80 00       	mov    0x805050,%eax
  801edb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ede:	c1 e2 04             	shl    $0x4,%edx
  801ee1:	01 d0                	add    %edx,%eax
  801ee3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801ee8:	a1 50 50 80 00       	mov    0x805050,%eax
  801eed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ef0:	c1 e2 04             	shl    $0x4,%edx
  801ef3:	01 d0                	add    %edx,%eax
  801ef5:	a3 48 51 80 00       	mov    %eax,0x805148
  801efa:	a1 50 50 80 00       	mov    0x805050,%eax
  801eff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f02:	c1 e2 04             	shl    $0x4,%edx
  801f05:	01 d0                	add    %edx,%eax
  801f07:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f0e:	a1 54 51 80 00       	mov    0x805154,%eax
  801f13:	40                   	inc    %eax
  801f14:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801f19:	ff 45 f4             	incl   -0xc(%ebp)
  801f1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f1f:	3b 45 08             	cmp    0x8(%ebp),%eax
  801f22:	0f 82 56 ff ff ff    	jb     801e7e <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801f28:	90                   	nop
  801f29:	c9                   	leave  
  801f2a:	c3                   	ret    

00801f2b <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801f2b:	55                   	push   %ebp
  801f2c:	89 e5                	mov    %esp,%ebp
  801f2e:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801f31:	8b 45 08             	mov    0x8(%ebp),%eax
  801f34:	8b 00                	mov    (%eax),%eax
  801f36:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f39:	eb 19                	jmp    801f54 <find_block+0x29>
	{
		if(va==point->sva)
  801f3b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f3e:	8b 40 08             	mov    0x8(%eax),%eax
  801f41:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801f44:	75 05                	jne    801f4b <find_block+0x20>
		   return point;
  801f46:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f49:	eb 36                	jmp    801f81 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801f4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4e:	8b 40 08             	mov    0x8(%eax),%eax
  801f51:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f54:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f58:	74 07                	je     801f61 <find_block+0x36>
  801f5a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f5d:	8b 00                	mov    (%eax),%eax
  801f5f:	eb 05                	jmp    801f66 <find_block+0x3b>
  801f61:	b8 00 00 00 00       	mov    $0x0,%eax
  801f66:	8b 55 08             	mov    0x8(%ebp),%edx
  801f69:	89 42 08             	mov    %eax,0x8(%edx)
  801f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6f:	8b 40 08             	mov    0x8(%eax),%eax
  801f72:	85 c0                	test   %eax,%eax
  801f74:	75 c5                	jne    801f3b <find_block+0x10>
  801f76:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f7a:	75 bf                	jne    801f3b <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  801f7c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f81:	c9                   	leave  
  801f82:	c3                   	ret    

00801f83 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  801f83:	55                   	push   %ebp
  801f84:	89 e5                	mov    %esp,%ebp
  801f86:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  801f89:	a1 40 50 80 00       	mov    0x805040,%eax
  801f8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  801f91:	a1 44 50 80 00       	mov    0x805044,%eax
  801f96:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  801f99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f9c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801f9f:	74 24                	je     801fc5 <insert_sorted_allocList+0x42>
  801fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa4:	8b 50 08             	mov    0x8(%eax),%edx
  801fa7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801faa:	8b 40 08             	mov    0x8(%eax),%eax
  801fad:	39 c2                	cmp    %eax,%edx
  801faf:	76 14                	jbe    801fc5 <insert_sorted_allocList+0x42>
  801fb1:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb4:	8b 50 08             	mov    0x8(%eax),%edx
  801fb7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fba:	8b 40 08             	mov    0x8(%eax),%eax
  801fbd:	39 c2                	cmp    %eax,%edx
  801fbf:	0f 82 60 01 00 00    	jb     802125 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  801fc5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fc9:	75 65                	jne    802030 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  801fcb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801fcf:	75 14                	jne    801fe5 <insert_sorted_allocList+0x62>
  801fd1:	83 ec 04             	sub    $0x4,%esp
  801fd4:	68 8c 3f 80 00       	push   $0x803f8c
  801fd9:	6a 6b                	push   $0x6b
  801fdb:	68 af 3f 80 00       	push   $0x803faf
  801fe0:	e8 04 e3 ff ff       	call   8002e9 <_panic>
  801fe5:	8b 15 40 50 80 00    	mov    0x805040,%edx
  801feb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fee:	89 10                	mov    %edx,(%eax)
  801ff0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff3:	8b 00                	mov    (%eax),%eax
  801ff5:	85 c0                	test   %eax,%eax
  801ff7:	74 0d                	je     802006 <insert_sorted_allocList+0x83>
  801ff9:	a1 40 50 80 00       	mov    0x805040,%eax
  801ffe:	8b 55 08             	mov    0x8(%ebp),%edx
  802001:	89 50 04             	mov    %edx,0x4(%eax)
  802004:	eb 08                	jmp    80200e <insert_sorted_allocList+0x8b>
  802006:	8b 45 08             	mov    0x8(%ebp),%eax
  802009:	a3 44 50 80 00       	mov    %eax,0x805044
  80200e:	8b 45 08             	mov    0x8(%ebp),%eax
  802011:	a3 40 50 80 00       	mov    %eax,0x805040
  802016:	8b 45 08             	mov    0x8(%ebp),%eax
  802019:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802020:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802025:	40                   	inc    %eax
  802026:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80202b:	e9 dc 01 00 00       	jmp    80220c <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802030:	8b 45 08             	mov    0x8(%ebp),%eax
  802033:	8b 50 08             	mov    0x8(%eax),%edx
  802036:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802039:	8b 40 08             	mov    0x8(%eax),%eax
  80203c:	39 c2                	cmp    %eax,%edx
  80203e:	77 6c                	ja     8020ac <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802040:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802044:	74 06                	je     80204c <insert_sorted_allocList+0xc9>
  802046:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80204a:	75 14                	jne    802060 <insert_sorted_allocList+0xdd>
  80204c:	83 ec 04             	sub    $0x4,%esp
  80204f:	68 c8 3f 80 00       	push   $0x803fc8
  802054:	6a 6f                	push   $0x6f
  802056:	68 af 3f 80 00       	push   $0x803faf
  80205b:	e8 89 e2 ff ff       	call   8002e9 <_panic>
  802060:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802063:	8b 50 04             	mov    0x4(%eax),%edx
  802066:	8b 45 08             	mov    0x8(%ebp),%eax
  802069:	89 50 04             	mov    %edx,0x4(%eax)
  80206c:	8b 45 08             	mov    0x8(%ebp),%eax
  80206f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802072:	89 10                	mov    %edx,(%eax)
  802074:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802077:	8b 40 04             	mov    0x4(%eax),%eax
  80207a:	85 c0                	test   %eax,%eax
  80207c:	74 0d                	je     80208b <insert_sorted_allocList+0x108>
  80207e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802081:	8b 40 04             	mov    0x4(%eax),%eax
  802084:	8b 55 08             	mov    0x8(%ebp),%edx
  802087:	89 10                	mov    %edx,(%eax)
  802089:	eb 08                	jmp    802093 <insert_sorted_allocList+0x110>
  80208b:	8b 45 08             	mov    0x8(%ebp),%eax
  80208e:	a3 40 50 80 00       	mov    %eax,0x805040
  802093:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802096:	8b 55 08             	mov    0x8(%ebp),%edx
  802099:	89 50 04             	mov    %edx,0x4(%eax)
  80209c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8020a1:	40                   	inc    %eax
  8020a2:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8020a7:	e9 60 01 00 00       	jmp    80220c <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8020ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8020af:	8b 50 08             	mov    0x8(%eax),%edx
  8020b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020b5:	8b 40 08             	mov    0x8(%eax),%eax
  8020b8:	39 c2                	cmp    %eax,%edx
  8020ba:	0f 82 4c 01 00 00    	jb     80220c <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8020c0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020c4:	75 14                	jne    8020da <insert_sorted_allocList+0x157>
  8020c6:	83 ec 04             	sub    $0x4,%esp
  8020c9:	68 00 40 80 00       	push   $0x804000
  8020ce:	6a 73                	push   $0x73
  8020d0:	68 af 3f 80 00       	push   $0x803faf
  8020d5:	e8 0f e2 ff ff       	call   8002e9 <_panic>
  8020da:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8020e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e3:	89 50 04             	mov    %edx,0x4(%eax)
  8020e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e9:	8b 40 04             	mov    0x4(%eax),%eax
  8020ec:	85 c0                	test   %eax,%eax
  8020ee:	74 0c                	je     8020fc <insert_sorted_allocList+0x179>
  8020f0:	a1 44 50 80 00       	mov    0x805044,%eax
  8020f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8020f8:	89 10                	mov    %edx,(%eax)
  8020fa:	eb 08                	jmp    802104 <insert_sorted_allocList+0x181>
  8020fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ff:	a3 40 50 80 00       	mov    %eax,0x805040
  802104:	8b 45 08             	mov    0x8(%ebp),%eax
  802107:	a3 44 50 80 00       	mov    %eax,0x805044
  80210c:	8b 45 08             	mov    0x8(%ebp),%eax
  80210f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802115:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80211a:	40                   	inc    %eax
  80211b:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802120:	e9 e7 00 00 00       	jmp    80220c <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802125:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802128:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  80212b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802132:	a1 40 50 80 00       	mov    0x805040,%eax
  802137:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80213a:	e9 9d 00 00 00       	jmp    8021dc <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  80213f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802142:	8b 00                	mov    (%eax),%eax
  802144:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802147:	8b 45 08             	mov    0x8(%ebp),%eax
  80214a:	8b 50 08             	mov    0x8(%eax),%edx
  80214d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802150:	8b 40 08             	mov    0x8(%eax),%eax
  802153:	39 c2                	cmp    %eax,%edx
  802155:	76 7d                	jbe    8021d4 <insert_sorted_allocList+0x251>
  802157:	8b 45 08             	mov    0x8(%ebp),%eax
  80215a:	8b 50 08             	mov    0x8(%eax),%edx
  80215d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802160:	8b 40 08             	mov    0x8(%eax),%eax
  802163:	39 c2                	cmp    %eax,%edx
  802165:	73 6d                	jae    8021d4 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802167:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80216b:	74 06                	je     802173 <insert_sorted_allocList+0x1f0>
  80216d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802171:	75 14                	jne    802187 <insert_sorted_allocList+0x204>
  802173:	83 ec 04             	sub    $0x4,%esp
  802176:	68 24 40 80 00       	push   $0x804024
  80217b:	6a 7f                	push   $0x7f
  80217d:	68 af 3f 80 00       	push   $0x803faf
  802182:	e8 62 e1 ff ff       	call   8002e9 <_panic>
  802187:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80218a:	8b 10                	mov    (%eax),%edx
  80218c:	8b 45 08             	mov    0x8(%ebp),%eax
  80218f:	89 10                	mov    %edx,(%eax)
  802191:	8b 45 08             	mov    0x8(%ebp),%eax
  802194:	8b 00                	mov    (%eax),%eax
  802196:	85 c0                	test   %eax,%eax
  802198:	74 0b                	je     8021a5 <insert_sorted_allocList+0x222>
  80219a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219d:	8b 00                	mov    (%eax),%eax
  80219f:	8b 55 08             	mov    0x8(%ebp),%edx
  8021a2:	89 50 04             	mov    %edx,0x4(%eax)
  8021a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8021ab:	89 10                	mov    %edx,(%eax)
  8021ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021b3:	89 50 04             	mov    %edx,0x4(%eax)
  8021b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b9:	8b 00                	mov    (%eax),%eax
  8021bb:	85 c0                	test   %eax,%eax
  8021bd:	75 08                	jne    8021c7 <insert_sorted_allocList+0x244>
  8021bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c2:	a3 44 50 80 00       	mov    %eax,0x805044
  8021c7:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8021cc:	40                   	inc    %eax
  8021cd:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8021d2:	eb 39                	jmp    80220d <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8021d4:	a1 48 50 80 00       	mov    0x805048,%eax
  8021d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021e0:	74 07                	je     8021e9 <insert_sorted_allocList+0x266>
  8021e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e5:	8b 00                	mov    (%eax),%eax
  8021e7:	eb 05                	jmp    8021ee <insert_sorted_allocList+0x26b>
  8021e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ee:	a3 48 50 80 00       	mov    %eax,0x805048
  8021f3:	a1 48 50 80 00       	mov    0x805048,%eax
  8021f8:	85 c0                	test   %eax,%eax
  8021fa:	0f 85 3f ff ff ff    	jne    80213f <insert_sorted_allocList+0x1bc>
  802200:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802204:	0f 85 35 ff ff ff    	jne    80213f <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80220a:	eb 01                	jmp    80220d <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80220c:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80220d:	90                   	nop
  80220e:	c9                   	leave  
  80220f:	c3                   	ret    

00802210 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802210:	55                   	push   %ebp
  802211:	89 e5                	mov    %esp,%ebp
  802213:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802216:	a1 38 51 80 00       	mov    0x805138,%eax
  80221b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80221e:	e9 85 01 00 00       	jmp    8023a8 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802223:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802226:	8b 40 0c             	mov    0xc(%eax),%eax
  802229:	3b 45 08             	cmp    0x8(%ebp),%eax
  80222c:	0f 82 6e 01 00 00    	jb     8023a0 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802232:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802235:	8b 40 0c             	mov    0xc(%eax),%eax
  802238:	3b 45 08             	cmp    0x8(%ebp),%eax
  80223b:	0f 85 8a 00 00 00    	jne    8022cb <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802241:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802245:	75 17                	jne    80225e <alloc_block_FF+0x4e>
  802247:	83 ec 04             	sub    $0x4,%esp
  80224a:	68 58 40 80 00       	push   $0x804058
  80224f:	68 93 00 00 00       	push   $0x93
  802254:	68 af 3f 80 00       	push   $0x803faf
  802259:	e8 8b e0 ff ff       	call   8002e9 <_panic>
  80225e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802261:	8b 00                	mov    (%eax),%eax
  802263:	85 c0                	test   %eax,%eax
  802265:	74 10                	je     802277 <alloc_block_FF+0x67>
  802267:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226a:	8b 00                	mov    (%eax),%eax
  80226c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80226f:	8b 52 04             	mov    0x4(%edx),%edx
  802272:	89 50 04             	mov    %edx,0x4(%eax)
  802275:	eb 0b                	jmp    802282 <alloc_block_FF+0x72>
  802277:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227a:	8b 40 04             	mov    0x4(%eax),%eax
  80227d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802282:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802285:	8b 40 04             	mov    0x4(%eax),%eax
  802288:	85 c0                	test   %eax,%eax
  80228a:	74 0f                	je     80229b <alloc_block_FF+0x8b>
  80228c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228f:	8b 40 04             	mov    0x4(%eax),%eax
  802292:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802295:	8b 12                	mov    (%edx),%edx
  802297:	89 10                	mov    %edx,(%eax)
  802299:	eb 0a                	jmp    8022a5 <alloc_block_FF+0x95>
  80229b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229e:	8b 00                	mov    (%eax),%eax
  8022a0:	a3 38 51 80 00       	mov    %eax,0x805138
  8022a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022b8:	a1 44 51 80 00       	mov    0x805144,%eax
  8022bd:	48                   	dec    %eax
  8022be:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  8022c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c6:	e9 10 01 00 00       	jmp    8023db <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8022cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ce:	8b 40 0c             	mov    0xc(%eax),%eax
  8022d1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022d4:	0f 86 c6 00 00 00    	jbe    8023a0 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8022da:	a1 48 51 80 00       	mov    0x805148,%eax
  8022df:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8022e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e5:	8b 50 08             	mov    0x8(%eax),%edx
  8022e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022eb:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8022ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8022f4:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8022f7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022fb:	75 17                	jne    802314 <alloc_block_FF+0x104>
  8022fd:	83 ec 04             	sub    $0x4,%esp
  802300:	68 58 40 80 00       	push   $0x804058
  802305:	68 9b 00 00 00       	push   $0x9b
  80230a:	68 af 3f 80 00       	push   $0x803faf
  80230f:	e8 d5 df ff ff       	call   8002e9 <_panic>
  802314:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802317:	8b 00                	mov    (%eax),%eax
  802319:	85 c0                	test   %eax,%eax
  80231b:	74 10                	je     80232d <alloc_block_FF+0x11d>
  80231d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802320:	8b 00                	mov    (%eax),%eax
  802322:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802325:	8b 52 04             	mov    0x4(%edx),%edx
  802328:	89 50 04             	mov    %edx,0x4(%eax)
  80232b:	eb 0b                	jmp    802338 <alloc_block_FF+0x128>
  80232d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802330:	8b 40 04             	mov    0x4(%eax),%eax
  802333:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802338:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80233b:	8b 40 04             	mov    0x4(%eax),%eax
  80233e:	85 c0                	test   %eax,%eax
  802340:	74 0f                	je     802351 <alloc_block_FF+0x141>
  802342:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802345:	8b 40 04             	mov    0x4(%eax),%eax
  802348:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80234b:	8b 12                	mov    (%edx),%edx
  80234d:	89 10                	mov    %edx,(%eax)
  80234f:	eb 0a                	jmp    80235b <alloc_block_FF+0x14b>
  802351:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802354:	8b 00                	mov    (%eax),%eax
  802356:	a3 48 51 80 00       	mov    %eax,0x805148
  80235b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80235e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802364:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802367:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80236e:	a1 54 51 80 00       	mov    0x805154,%eax
  802373:	48                   	dec    %eax
  802374:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802379:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237c:	8b 50 08             	mov    0x8(%eax),%edx
  80237f:	8b 45 08             	mov    0x8(%ebp),%eax
  802382:	01 c2                	add    %eax,%edx
  802384:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802387:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  80238a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238d:	8b 40 0c             	mov    0xc(%eax),%eax
  802390:	2b 45 08             	sub    0x8(%ebp),%eax
  802393:	89 c2                	mov    %eax,%edx
  802395:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802398:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  80239b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80239e:	eb 3b                	jmp    8023db <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8023a0:	a1 40 51 80 00       	mov    0x805140,%eax
  8023a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023ac:	74 07                	je     8023b5 <alloc_block_FF+0x1a5>
  8023ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b1:	8b 00                	mov    (%eax),%eax
  8023b3:	eb 05                	jmp    8023ba <alloc_block_FF+0x1aa>
  8023b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8023ba:	a3 40 51 80 00       	mov    %eax,0x805140
  8023bf:	a1 40 51 80 00       	mov    0x805140,%eax
  8023c4:	85 c0                	test   %eax,%eax
  8023c6:	0f 85 57 fe ff ff    	jne    802223 <alloc_block_FF+0x13>
  8023cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023d0:	0f 85 4d fe ff ff    	jne    802223 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8023d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023db:	c9                   	leave  
  8023dc:	c3                   	ret    

008023dd <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8023dd:	55                   	push   %ebp
  8023de:	89 e5                	mov    %esp,%ebp
  8023e0:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8023e3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8023ea:	a1 38 51 80 00       	mov    0x805138,%eax
  8023ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023f2:	e9 df 00 00 00       	jmp    8024d6 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8023f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fa:	8b 40 0c             	mov    0xc(%eax),%eax
  8023fd:	3b 45 08             	cmp    0x8(%ebp),%eax
  802400:	0f 82 c8 00 00 00    	jb     8024ce <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802406:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802409:	8b 40 0c             	mov    0xc(%eax),%eax
  80240c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80240f:	0f 85 8a 00 00 00    	jne    80249f <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802415:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802419:	75 17                	jne    802432 <alloc_block_BF+0x55>
  80241b:	83 ec 04             	sub    $0x4,%esp
  80241e:	68 58 40 80 00       	push   $0x804058
  802423:	68 b7 00 00 00       	push   $0xb7
  802428:	68 af 3f 80 00       	push   $0x803faf
  80242d:	e8 b7 de ff ff       	call   8002e9 <_panic>
  802432:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802435:	8b 00                	mov    (%eax),%eax
  802437:	85 c0                	test   %eax,%eax
  802439:	74 10                	je     80244b <alloc_block_BF+0x6e>
  80243b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243e:	8b 00                	mov    (%eax),%eax
  802440:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802443:	8b 52 04             	mov    0x4(%edx),%edx
  802446:	89 50 04             	mov    %edx,0x4(%eax)
  802449:	eb 0b                	jmp    802456 <alloc_block_BF+0x79>
  80244b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244e:	8b 40 04             	mov    0x4(%eax),%eax
  802451:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802456:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802459:	8b 40 04             	mov    0x4(%eax),%eax
  80245c:	85 c0                	test   %eax,%eax
  80245e:	74 0f                	je     80246f <alloc_block_BF+0x92>
  802460:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802463:	8b 40 04             	mov    0x4(%eax),%eax
  802466:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802469:	8b 12                	mov    (%edx),%edx
  80246b:	89 10                	mov    %edx,(%eax)
  80246d:	eb 0a                	jmp    802479 <alloc_block_BF+0x9c>
  80246f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802472:	8b 00                	mov    (%eax),%eax
  802474:	a3 38 51 80 00       	mov    %eax,0x805138
  802479:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802482:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802485:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80248c:	a1 44 51 80 00       	mov    0x805144,%eax
  802491:	48                   	dec    %eax
  802492:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802497:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249a:	e9 4d 01 00 00       	jmp    8025ec <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  80249f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a2:	8b 40 0c             	mov    0xc(%eax),%eax
  8024a5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024a8:	76 24                	jbe    8024ce <alloc_block_BF+0xf1>
  8024aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ad:	8b 40 0c             	mov    0xc(%eax),%eax
  8024b0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8024b3:	73 19                	jae    8024ce <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8024b5:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8024bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bf:	8b 40 0c             	mov    0xc(%eax),%eax
  8024c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8024c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c8:	8b 40 08             	mov    0x8(%eax),%eax
  8024cb:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8024ce:	a1 40 51 80 00       	mov    0x805140,%eax
  8024d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024da:	74 07                	je     8024e3 <alloc_block_BF+0x106>
  8024dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024df:	8b 00                	mov    (%eax),%eax
  8024e1:	eb 05                	jmp    8024e8 <alloc_block_BF+0x10b>
  8024e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8024e8:	a3 40 51 80 00       	mov    %eax,0x805140
  8024ed:	a1 40 51 80 00       	mov    0x805140,%eax
  8024f2:	85 c0                	test   %eax,%eax
  8024f4:	0f 85 fd fe ff ff    	jne    8023f7 <alloc_block_BF+0x1a>
  8024fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024fe:	0f 85 f3 fe ff ff    	jne    8023f7 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802504:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802508:	0f 84 d9 00 00 00    	je     8025e7 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  80250e:	a1 48 51 80 00       	mov    0x805148,%eax
  802513:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802516:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802519:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80251c:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  80251f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802522:	8b 55 08             	mov    0x8(%ebp),%edx
  802525:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802528:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80252c:	75 17                	jne    802545 <alloc_block_BF+0x168>
  80252e:	83 ec 04             	sub    $0x4,%esp
  802531:	68 58 40 80 00       	push   $0x804058
  802536:	68 c7 00 00 00       	push   $0xc7
  80253b:	68 af 3f 80 00       	push   $0x803faf
  802540:	e8 a4 dd ff ff       	call   8002e9 <_panic>
  802545:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802548:	8b 00                	mov    (%eax),%eax
  80254a:	85 c0                	test   %eax,%eax
  80254c:	74 10                	je     80255e <alloc_block_BF+0x181>
  80254e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802551:	8b 00                	mov    (%eax),%eax
  802553:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802556:	8b 52 04             	mov    0x4(%edx),%edx
  802559:	89 50 04             	mov    %edx,0x4(%eax)
  80255c:	eb 0b                	jmp    802569 <alloc_block_BF+0x18c>
  80255e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802561:	8b 40 04             	mov    0x4(%eax),%eax
  802564:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802569:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80256c:	8b 40 04             	mov    0x4(%eax),%eax
  80256f:	85 c0                	test   %eax,%eax
  802571:	74 0f                	je     802582 <alloc_block_BF+0x1a5>
  802573:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802576:	8b 40 04             	mov    0x4(%eax),%eax
  802579:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80257c:	8b 12                	mov    (%edx),%edx
  80257e:	89 10                	mov    %edx,(%eax)
  802580:	eb 0a                	jmp    80258c <alloc_block_BF+0x1af>
  802582:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802585:	8b 00                	mov    (%eax),%eax
  802587:	a3 48 51 80 00       	mov    %eax,0x805148
  80258c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80258f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802595:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802598:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80259f:	a1 54 51 80 00       	mov    0x805154,%eax
  8025a4:	48                   	dec    %eax
  8025a5:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8025aa:	83 ec 08             	sub    $0x8,%esp
  8025ad:	ff 75 ec             	pushl  -0x14(%ebp)
  8025b0:	68 38 51 80 00       	push   $0x805138
  8025b5:	e8 71 f9 ff ff       	call   801f2b <find_block>
  8025ba:	83 c4 10             	add    $0x10,%esp
  8025bd:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8025c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025c3:	8b 50 08             	mov    0x8(%eax),%edx
  8025c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c9:	01 c2                	add    %eax,%edx
  8025cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025ce:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8025d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025d4:	8b 40 0c             	mov    0xc(%eax),%eax
  8025d7:	2b 45 08             	sub    0x8(%ebp),%eax
  8025da:	89 c2                	mov    %eax,%edx
  8025dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025df:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8025e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025e5:	eb 05                	jmp    8025ec <alloc_block_BF+0x20f>
	}
	return NULL;
  8025e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025ec:	c9                   	leave  
  8025ed:	c3                   	ret    

008025ee <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8025ee:	55                   	push   %ebp
  8025ef:	89 e5                	mov    %esp,%ebp
  8025f1:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8025f4:	a1 28 50 80 00       	mov    0x805028,%eax
  8025f9:	85 c0                	test   %eax,%eax
  8025fb:	0f 85 de 01 00 00    	jne    8027df <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802601:	a1 38 51 80 00       	mov    0x805138,%eax
  802606:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802609:	e9 9e 01 00 00       	jmp    8027ac <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  80260e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802611:	8b 40 0c             	mov    0xc(%eax),%eax
  802614:	3b 45 08             	cmp    0x8(%ebp),%eax
  802617:	0f 82 87 01 00 00    	jb     8027a4 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  80261d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802620:	8b 40 0c             	mov    0xc(%eax),%eax
  802623:	3b 45 08             	cmp    0x8(%ebp),%eax
  802626:	0f 85 95 00 00 00    	jne    8026c1 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  80262c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802630:	75 17                	jne    802649 <alloc_block_NF+0x5b>
  802632:	83 ec 04             	sub    $0x4,%esp
  802635:	68 58 40 80 00       	push   $0x804058
  80263a:	68 e0 00 00 00       	push   $0xe0
  80263f:	68 af 3f 80 00       	push   $0x803faf
  802644:	e8 a0 dc ff ff       	call   8002e9 <_panic>
  802649:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264c:	8b 00                	mov    (%eax),%eax
  80264e:	85 c0                	test   %eax,%eax
  802650:	74 10                	je     802662 <alloc_block_NF+0x74>
  802652:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802655:	8b 00                	mov    (%eax),%eax
  802657:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80265a:	8b 52 04             	mov    0x4(%edx),%edx
  80265d:	89 50 04             	mov    %edx,0x4(%eax)
  802660:	eb 0b                	jmp    80266d <alloc_block_NF+0x7f>
  802662:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802665:	8b 40 04             	mov    0x4(%eax),%eax
  802668:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80266d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802670:	8b 40 04             	mov    0x4(%eax),%eax
  802673:	85 c0                	test   %eax,%eax
  802675:	74 0f                	je     802686 <alloc_block_NF+0x98>
  802677:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267a:	8b 40 04             	mov    0x4(%eax),%eax
  80267d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802680:	8b 12                	mov    (%edx),%edx
  802682:	89 10                	mov    %edx,(%eax)
  802684:	eb 0a                	jmp    802690 <alloc_block_NF+0xa2>
  802686:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802689:	8b 00                	mov    (%eax),%eax
  80268b:	a3 38 51 80 00       	mov    %eax,0x805138
  802690:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802693:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802699:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026a3:	a1 44 51 80 00       	mov    0x805144,%eax
  8026a8:	48                   	dec    %eax
  8026a9:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  8026ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b1:	8b 40 08             	mov    0x8(%eax),%eax
  8026b4:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  8026b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bc:	e9 f8 04 00 00       	jmp    802bb9 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8026c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c4:	8b 40 0c             	mov    0xc(%eax),%eax
  8026c7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026ca:	0f 86 d4 00 00 00    	jbe    8027a4 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8026d0:	a1 48 51 80 00       	mov    0x805148,%eax
  8026d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8026d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026db:	8b 50 08             	mov    0x8(%eax),%edx
  8026de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026e1:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8026e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8026ea:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8026ed:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026f1:	75 17                	jne    80270a <alloc_block_NF+0x11c>
  8026f3:	83 ec 04             	sub    $0x4,%esp
  8026f6:	68 58 40 80 00       	push   $0x804058
  8026fb:	68 e9 00 00 00       	push   $0xe9
  802700:	68 af 3f 80 00       	push   $0x803faf
  802705:	e8 df db ff ff       	call   8002e9 <_panic>
  80270a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80270d:	8b 00                	mov    (%eax),%eax
  80270f:	85 c0                	test   %eax,%eax
  802711:	74 10                	je     802723 <alloc_block_NF+0x135>
  802713:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802716:	8b 00                	mov    (%eax),%eax
  802718:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80271b:	8b 52 04             	mov    0x4(%edx),%edx
  80271e:	89 50 04             	mov    %edx,0x4(%eax)
  802721:	eb 0b                	jmp    80272e <alloc_block_NF+0x140>
  802723:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802726:	8b 40 04             	mov    0x4(%eax),%eax
  802729:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80272e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802731:	8b 40 04             	mov    0x4(%eax),%eax
  802734:	85 c0                	test   %eax,%eax
  802736:	74 0f                	je     802747 <alloc_block_NF+0x159>
  802738:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80273b:	8b 40 04             	mov    0x4(%eax),%eax
  80273e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802741:	8b 12                	mov    (%edx),%edx
  802743:	89 10                	mov    %edx,(%eax)
  802745:	eb 0a                	jmp    802751 <alloc_block_NF+0x163>
  802747:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80274a:	8b 00                	mov    (%eax),%eax
  80274c:	a3 48 51 80 00       	mov    %eax,0x805148
  802751:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802754:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80275a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80275d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802764:	a1 54 51 80 00       	mov    0x805154,%eax
  802769:	48                   	dec    %eax
  80276a:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  80276f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802772:	8b 40 08             	mov    0x8(%eax),%eax
  802775:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  80277a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277d:	8b 50 08             	mov    0x8(%eax),%edx
  802780:	8b 45 08             	mov    0x8(%ebp),%eax
  802783:	01 c2                	add    %eax,%edx
  802785:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802788:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  80278b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278e:	8b 40 0c             	mov    0xc(%eax),%eax
  802791:	2b 45 08             	sub    0x8(%ebp),%eax
  802794:	89 c2                	mov    %eax,%edx
  802796:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802799:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  80279c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80279f:	e9 15 04 00 00       	jmp    802bb9 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8027a4:	a1 40 51 80 00       	mov    0x805140,%eax
  8027a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027b0:	74 07                	je     8027b9 <alloc_block_NF+0x1cb>
  8027b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b5:	8b 00                	mov    (%eax),%eax
  8027b7:	eb 05                	jmp    8027be <alloc_block_NF+0x1d0>
  8027b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8027be:	a3 40 51 80 00       	mov    %eax,0x805140
  8027c3:	a1 40 51 80 00       	mov    0x805140,%eax
  8027c8:	85 c0                	test   %eax,%eax
  8027ca:	0f 85 3e fe ff ff    	jne    80260e <alloc_block_NF+0x20>
  8027d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027d4:	0f 85 34 fe ff ff    	jne    80260e <alloc_block_NF+0x20>
  8027da:	e9 d5 03 00 00       	jmp    802bb4 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8027df:	a1 38 51 80 00       	mov    0x805138,%eax
  8027e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027e7:	e9 b1 01 00 00       	jmp    80299d <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8027ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ef:	8b 50 08             	mov    0x8(%eax),%edx
  8027f2:	a1 28 50 80 00       	mov    0x805028,%eax
  8027f7:	39 c2                	cmp    %eax,%edx
  8027f9:	0f 82 96 01 00 00    	jb     802995 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  8027ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802802:	8b 40 0c             	mov    0xc(%eax),%eax
  802805:	3b 45 08             	cmp    0x8(%ebp),%eax
  802808:	0f 82 87 01 00 00    	jb     802995 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  80280e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802811:	8b 40 0c             	mov    0xc(%eax),%eax
  802814:	3b 45 08             	cmp    0x8(%ebp),%eax
  802817:	0f 85 95 00 00 00    	jne    8028b2 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80281d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802821:	75 17                	jne    80283a <alloc_block_NF+0x24c>
  802823:	83 ec 04             	sub    $0x4,%esp
  802826:	68 58 40 80 00       	push   $0x804058
  80282b:	68 fc 00 00 00       	push   $0xfc
  802830:	68 af 3f 80 00       	push   $0x803faf
  802835:	e8 af da ff ff       	call   8002e9 <_panic>
  80283a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283d:	8b 00                	mov    (%eax),%eax
  80283f:	85 c0                	test   %eax,%eax
  802841:	74 10                	je     802853 <alloc_block_NF+0x265>
  802843:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802846:	8b 00                	mov    (%eax),%eax
  802848:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80284b:	8b 52 04             	mov    0x4(%edx),%edx
  80284e:	89 50 04             	mov    %edx,0x4(%eax)
  802851:	eb 0b                	jmp    80285e <alloc_block_NF+0x270>
  802853:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802856:	8b 40 04             	mov    0x4(%eax),%eax
  802859:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80285e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802861:	8b 40 04             	mov    0x4(%eax),%eax
  802864:	85 c0                	test   %eax,%eax
  802866:	74 0f                	je     802877 <alloc_block_NF+0x289>
  802868:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286b:	8b 40 04             	mov    0x4(%eax),%eax
  80286e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802871:	8b 12                	mov    (%edx),%edx
  802873:	89 10                	mov    %edx,(%eax)
  802875:	eb 0a                	jmp    802881 <alloc_block_NF+0x293>
  802877:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287a:	8b 00                	mov    (%eax),%eax
  80287c:	a3 38 51 80 00       	mov    %eax,0x805138
  802881:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802884:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80288a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802894:	a1 44 51 80 00       	mov    0x805144,%eax
  802899:	48                   	dec    %eax
  80289a:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  80289f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a2:	8b 40 08             	mov    0x8(%eax),%eax
  8028a5:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  8028aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ad:	e9 07 03 00 00       	jmp    802bb9 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8028b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b5:	8b 40 0c             	mov    0xc(%eax),%eax
  8028b8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028bb:	0f 86 d4 00 00 00    	jbe    802995 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8028c1:	a1 48 51 80 00       	mov    0x805148,%eax
  8028c6:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  8028c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cc:	8b 50 08             	mov    0x8(%eax),%edx
  8028cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028d2:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8028d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028d8:	8b 55 08             	mov    0x8(%ebp),%edx
  8028db:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8028de:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8028e2:	75 17                	jne    8028fb <alloc_block_NF+0x30d>
  8028e4:	83 ec 04             	sub    $0x4,%esp
  8028e7:	68 58 40 80 00       	push   $0x804058
  8028ec:	68 04 01 00 00       	push   $0x104
  8028f1:	68 af 3f 80 00       	push   $0x803faf
  8028f6:	e8 ee d9 ff ff       	call   8002e9 <_panic>
  8028fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028fe:	8b 00                	mov    (%eax),%eax
  802900:	85 c0                	test   %eax,%eax
  802902:	74 10                	je     802914 <alloc_block_NF+0x326>
  802904:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802907:	8b 00                	mov    (%eax),%eax
  802909:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80290c:	8b 52 04             	mov    0x4(%edx),%edx
  80290f:	89 50 04             	mov    %edx,0x4(%eax)
  802912:	eb 0b                	jmp    80291f <alloc_block_NF+0x331>
  802914:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802917:	8b 40 04             	mov    0x4(%eax),%eax
  80291a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80291f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802922:	8b 40 04             	mov    0x4(%eax),%eax
  802925:	85 c0                	test   %eax,%eax
  802927:	74 0f                	je     802938 <alloc_block_NF+0x34a>
  802929:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80292c:	8b 40 04             	mov    0x4(%eax),%eax
  80292f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802932:	8b 12                	mov    (%edx),%edx
  802934:	89 10                	mov    %edx,(%eax)
  802936:	eb 0a                	jmp    802942 <alloc_block_NF+0x354>
  802938:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80293b:	8b 00                	mov    (%eax),%eax
  80293d:	a3 48 51 80 00       	mov    %eax,0x805148
  802942:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802945:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80294b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80294e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802955:	a1 54 51 80 00       	mov    0x805154,%eax
  80295a:	48                   	dec    %eax
  80295b:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802960:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802963:	8b 40 08             	mov    0x8(%eax),%eax
  802966:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  80296b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296e:	8b 50 08             	mov    0x8(%eax),%edx
  802971:	8b 45 08             	mov    0x8(%ebp),%eax
  802974:	01 c2                	add    %eax,%edx
  802976:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802979:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  80297c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297f:	8b 40 0c             	mov    0xc(%eax),%eax
  802982:	2b 45 08             	sub    0x8(%ebp),%eax
  802985:	89 c2                	mov    %eax,%edx
  802987:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298a:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  80298d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802990:	e9 24 02 00 00       	jmp    802bb9 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802995:	a1 40 51 80 00       	mov    0x805140,%eax
  80299a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80299d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029a1:	74 07                	je     8029aa <alloc_block_NF+0x3bc>
  8029a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a6:	8b 00                	mov    (%eax),%eax
  8029a8:	eb 05                	jmp    8029af <alloc_block_NF+0x3c1>
  8029aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8029af:	a3 40 51 80 00       	mov    %eax,0x805140
  8029b4:	a1 40 51 80 00       	mov    0x805140,%eax
  8029b9:	85 c0                	test   %eax,%eax
  8029bb:	0f 85 2b fe ff ff    	jne    8027ec <alloc_block_NF+0x1fe>
  8029c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029c5:	0f 85 21 fe ff ff    	jne    8027ec <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8029cb:	a1 38 51 80 00       	mov    0x805138,%eax
  8029d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029d3:	e9 ae 01 00 00       	jmp    802b86 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  8029d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029db:	8b 50 08             	mov    0x8(%eax),%edx
  8029de:	a1 28 50 80 00       	mov    0x805028,%eax
  8029e3:	39 c2                	cmp    %eax,%edx
  8029e5:	0f 83 93 01 00 00    	jae    802b7e <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  8029eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ee:	8b 40 0c             	mov    0xc(%eax),%eax
  8029f1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029f4:	0f 82 84 01 00 00    	jb     802b7e <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  8029fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fd:	8b 40 0c             	mov    0xc(%eax),%eax
  802a00:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a03:	0f 85 95 00 00 00    	jne    802a9e <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802a09:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a0d:	75 17                	jne    802a26 <alloc_block_NF+0x438>
  802a0f:	83 ec 04             	sub    $0x4,%esp
  802a12:	68 58 40 80 00       	push   $0x804058
  802a17:	68 14 01 00 00       	push   $0x114
  802a1c:	68 af 3f 80 00       	push   $0x803faf
  802a21:	e8 c3 d8 ff ff       	call   8002e9 <_panic>
  802a26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a29:	8b 00                	mov    (%eax),%eax
  802a2b:	85 c0                	test   %eax,%eax
  802a2d:	74 10                	je     802a3f <alloc_block_NF+0x451>
  802a2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a32:	8b 00                	mov    (%eax),%eax
  802a34:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a37:	8b 52 04             	mov    0x4(%edx),%edx
  802a3a:	89 50 04             	mov    %edx,0x4(%eax)
  802a3d:	eb 0b                	jmp    802a4a <alloc_block_NF+0x45c>
  802a3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a42:	8b 40 04             	mov    0x4(%eax),%eax
  802a45:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4d:	8b 40 04             	mov    0x4(%eax),%eax
  802a50:	85 c0                	test   %eax,%eax
  802a52:	74 0f                	je     802a63 <alloc_block_NF+0x475>
  802a54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a57:	8b 40 04             	mov    0x4(%eax),%eax
  802a5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a5d:	8b 12                	mov    (%edx),%edx
  802a5f:	89 10                	mov    %edx,(%eax)
  802a61:	eb 0a                	jmp    802a6d <alloc_block_NF+0x47f>
  802a63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a66:	8b 00                	mov    (%eax),%eax
  802a68:	a3 38 51 80 00       	mov    %eax,0x805138
  802a6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a70:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a79:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a80:	a1 44 51 80 00       	mov    0x805144,%eax
  802a85:	48                   	dec    %eax
  802a86:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802a8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8e:	8b 40 08             	mov    0x8(%eax),%eax
  802a91:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802a96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a99:	e9 1b 01 00 00       	jmp    802bb9 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802a9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa1:	8b 40 0c             	mov    0xc(%eax),%eax
  802aa4:	3b 45 08             	cmp    0x8(%ebp),%eax
  802aa7:	0f 86 d1 00 00 00    	jbe    802b7e <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802aad:	a1 48 51 80 00       	mov    0x805148,%eax
  802ab2:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802ab5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab8:	8b 50 08             	mov    0x8(%eax),%edx
  802abb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802abe:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802ac1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ac4:	8b 55 08             	mov    0x8(%ebp),%edx
  802ac7:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802aca:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802ace:	75 17                	jne    802ae7 <alloc_block_NF+0x4f9>
  802ad0:	83 ec 04             	sub    $0x4,%esp
  802ad3:	68 58 40 80 00       	push   $0x804058
  802ad8:	68 1c 01 00 00       	push   $0x11c
  802add:	68 af 3f 80 00       	push   $0x803faf
  802ae2:	e8 02 d8 ff ff       	call   8002e9 <_panic>
  802ae7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aea:	8b 00                	mov    (%eax),%eax
  802aec:	85 c0                	test   %eax,%eax
  802aee:	74 10                	je     802b00 <alloc_block_NF+0x512>
  802af0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802af3:	8b 00                	mov    (%eax),%eax
  802af5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802af8:	8b 52 04             	mov    0x4(%edx),%edx
  802afb:	89 50 04             	mov    %edx,0x4(%eax)
  802afe:	eb 0b                	jmp    802b0b <alloc_block_NF+0x51d>
  802b00:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b03:	8b 40 04             	mov    0x4(%eax),%eax
  802b06:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b0e:	8b 40 04             	mov    0x4(%eax),%eax
  802b11:	85 c0                	test   %eax,%eax
  802b13:	74 0f                	je     802b24 <alloc_block_NF+0x536>
  802b15:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b18:	8b 40 04             	mov    0x4(%eax),%eax
  802b1b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b1e:	8b 12                	mov    (%edx),%edx
  802b20:	89 10                	mov    %edx,(%eax)
  802b22:	eb 0a                	jmp    802b2e <alloc_block_NF+0x540>
  802b24:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b27:	8b 00                	mov    (%eax),%eax
  802b29:	a3 48 51 80 00       	mov    %eax,0x805148
  802b2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b31:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b37:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b3a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b41:	a1 54 51 80 00       	mov    0x805154,%eax
  802b46:	48                   	dec    %eax
  802b47:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802b4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b4f:	8b 40 08             	mov    0x8(%eax),%eax
  802b52:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802b57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5a:	8b 50 08             	mov    0x8(%eax),%edx
  802b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b60:	01 c2                	add    %eax,%edx
  802b62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b65:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802b68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6b:	8b 40 0c             	mov    0xc(%eax),%eax
  802b6e:	2b 45 08             	sub    0x8(%ebp),%eax
  802b71:	89 c2                	mov    %eax,%edx
  802b73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b76:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802b79:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b7c:	eb 3b                	jmp    802bb9 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b7e:	a1 40 51 80 00       	mov    0x805140,%eax
  802b83:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b86:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b8a:	74 07                	je     802b93 <alloc_block_NF+0x5a5>
  802b8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8f:	8b 00                	mov    (%eax),%eax
  802b91:	eb 05                	jmp    802b98 <alloc_block_NF+0x5aa>
  802b93:	b8 00 00 00 00       	mov    $0x0,%eax
  802b98:	a3 40 51 80 00       	mov    %eax,0x805140
  802b9d:	a1 40 51 80 00       	mov    0x805140,%eax
  802ba2:	85 c0                	test   %eax,%eax
  802ba4:	0f 85 2e fe ff ff    	jne    8029d8 <alloc_block_NF+0x3ea>
  802baa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bae:	0f 85 24 fe ff ff    	jne    8029d8 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802bb4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bb9:	c9                   	leave  
  802bba:	c3                   	ret    

00802bbb <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802bbb:	55                   	push   %ebp
  802bbc:	89 e5                	mov    %esp,%ebp
  802bbe:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802bc1:	a1 38 51 80 00       	mov    0x805138,%eax
  802bc6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802bc9:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802bce:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802bd1:	a1 38 51 80 00       	mov    0x805138,%eax
  802bd6:	85 c0                	test   %eax,%eax
  802bd8:	74 14                	je     802bee <insert_sorted_with_merge_freeList+0x33>
  802bda:	8b 45 08             	mov    0x8(%ebp),%eax
  802bdd:	8b 50 08             	mov    0x8(%eax),%edx
  802be0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be3:	8b 40 08             	mov    0x8(%eax),%eax
  802be6:	39 c2                	cmp    %eax,%edx
  802be8:	0f 87 9b 01 00 00    	ja     802d89 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802bee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bf2:	75 17                	jne    802c0b <insert_sorted_with_merge_freeList+0x50>
  802bf4:	83 ec 04             	sub    $0x4,%esp
  802bf7:	68 8c 3f 80 00       	push   $0x803f8c
  802bfc:	68 38 01 00 00       	push   $0x138
  802c01:	68 af 3f 80 00       	push   $0x803faf
  802c06:	e8 de d6 ff ff       	call   8002e9 <_panic>
  802c0b:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802c11:	8b 45 08             	mov    0x8(%ebp),%eax
  802c14:	89 10                	mov    %edx,(%eax)
  802c16:	8b 45 08             	mov    0x8(%ebp),%eax
  802c19:	8b 00                	mov    (%eax),%eax
  802c1b:	85 c0                	test   %eax,%eax
  802c1d:	74 0d                	je     802c2c <insert_sorted_with_merge_freeList+0x71>
  802c1f:	a1 38 51 80 00       	mov    0x805138,%eax
  802c24:	8b 55 08             	mov    0x8(%ebp),%edx
  802c27:	89 50 04             	mov    %edx,0x4(%eax)
  802c2a:	eb 08                	jmp    802c34 <insert_sorted_with_merge_freeList+0x79>
  802c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c34:	8b 45 08             	mov    0x8(%ebp),%eax
  802c37:	a3 38 51 80 00       	mov    %eax,0x805138
  802c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c46:	a1 44 51 80 00       	mov    0x805144,%eax
  802c4b:	40                   	inc    %eax
  802c4c:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802c51:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c55:	0f 84 a8 06 00 00    	je     803303 <insert_sorted_with_merge_freeList+0x748>
  802c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5e:	8b 50 08             	mov    0x8(%eax),%edx
  802c61:	8b 45 08             	mov    0x8(%ebp),%eax
  802c64:	8b 40 0c             	mov    0xc(%eax),%eax
  802c67:	01 c2                	add    %eax,%edx
  802c69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c6c:	8b 40 08             	mov    0x8(%eax),%eax
  802c6f:	39 c2                	cmp    %eax,%edx
  802c71:	0f 85 8c 06 00 00    	jne    803303 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802c77:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7a:	8b 50 0c             	mov    0xc(%eax),%edx
  802c7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c80:	8b 40 0c             	mov    0xc(%eax),%eax
  802c83:	01 c2                	add    %eax,%edx
  802c85:	8b 45 08             	mov    0x8(%ebp),%eax
  802c88:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802c8b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c8f:	75 17                	jne    802ca8 <insert_sorted_with_merge_freeList+0xed>
  802c91:	83 ec 04             	sub    $0x4,%esp
  802c94:	68 58 40 80 00       	push   $0x804058
  802c99:	68 3c 01 00 00       	push   $0x13c
  802c9e:	68 af 3f 80 00       	push   $0x803faf
  802ca3:	e8 41 d6 ff ff       	call   8002e9 <_panic>
  802ca8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cab:	8b 00                	mov    (%eax),%eax
  802cad:	85 c0                	test   %eax,%eax
  802caf:	74 10                	je     802cc1 <insert_sorted_with_merge_freeList+0x106>
  802cb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb4:	8b 00                	mov    (%eax),%eax
  802cb6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cb9:	8b 52 04             	mov    0x4(%edx),%edx
  802cbc:	89 50 04             	mov    %edx,0x4(%eax)
  802cbf:	eb 0b                	jmp    802ccc <insert_sorted_with_merge_freeList+0x111>
  802cc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cc4:	8b 40 04             	mov    0x4(%eax),%eax
  802cc7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ccc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ccf:	8b 40 04             	mov    0x4(%eax),%eax
  802cd2:	85 c0                	test   %eax,%eax
  802cd4:	74 0f                	je     802ce5 <insert_sorted_with_merge_freeList+0x12a>
  802cd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cd9:	8b 40 04             	mov    0x4(%eax),%eax
  802cdc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cdf:	8b 12                	mov    (%edx),%edx
  802ce1:	89 10                	mov    %edx,(%eax)
  802ce3:	eb 0a                	jmp    802cef <insert_sorted_with_merge_freeList+0x134>
  802ce5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ce8:	8b 00                	mov    (%eax),%eax
  802cea:	a3 38 51 80 00       	mov    %eax,0x805138
  802cef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cf8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cfb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d02:	a1 44 51 80 00       	mov    0x805144,%eax
  802d07:	48                   	dec    %eax
  802d08:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802d0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d10:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802d17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d1a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802d21:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d25:	75 17                	jne    802d3e <insert_sorted_with_merge_freeList+0x183>
  802d27:	83 ec 04             	sub    $0x4,%esp
  802d2a:	68 8c 3f 80 00       	push   $0x803f8c
  802d2f:	68 3f 01 00 00       	push   $0x13f
  802d34:	68 af 3f 80 00       	push   $0x803faf
  802d39:	e8 ab d5 ff ff       	call   8002e9 <_panic>
  802d3e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802d44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d47:	89 10                	mov    %edx,(%eax)
  802d49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d4c:	8b 00                	mov    (%eax),%eax
  802d4e:	85 c0                	test   %eax,%eax
  802d50:	74 0d                	je     802d5f <insert_sorted_with_merge_freeList+0x1a4>
  802d52:	a1 48 51 80 00       	mov    0x805148,%eax
  802d57:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d5a:	89 50 04             	mov    %edx,0x4(%eax)
  802d5d:	eb 08                	jmp    802d67 <insert_sorted_with_merge_freeList+0x1ac>
  802d5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d62:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d6a:	a3 48 51 80 00       	mov    %eax,0x805148
  802d6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d72:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d79:	a1 54 51 80 00       	mov    0x805154,%eax
  802d7e:	40                   	inc    %eax
  802d7f:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802d84:	e9 7a 05 00 00       	jmp    803303 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802d89:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8c:	8b 50 08             	mov    0x8(%eax),%edx
  802d8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d92:	8b 40 08             	mov    0x8(%eax),%eax
  802d95:	39 c2                	cmp    %eax,%edx
  802d97:	0f 82 14 01 00 00    	jb     802eb1 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802d9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802da0:	8b 50 08             	mov    0x8(%eax),%edx
  802da3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802da6:	8b 40 0c             	mov    0xc(%eax),%eax
  802da9:	01 c2                	add    %eax,%edx
  802dab:	8b 45 08             	mov    0x8(%ebp),%eax
  802dae:	8b 40 08             	mov    0x8(%eax),%eax
  802db1:	39 c2                	cmp    %eax,%edx
  802db3:	0f 85 90 00 00 00    	jne    802e49 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802db9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dbc:	8b 50 0c             	mov    0xc(%eax),%edx
  802dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc2:	8b 40 0c             	mov    0xc(%eax),%eax
  802dc5:	01 c2                	add    %eax,%edx
  802dc7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dca:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dda:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802de1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802de5:	75 17                	jne    802dfe <insert_sorted_with_merge_freeList+0x243>
  802de7:	83 ec 04             	sub    $0x4,%esp
  802dea:	68 8c 3f 80 00       	push   $0x803f8c
  802def:	68 49 01 00 00       	push   $0x149
  802df4:	68 af 3f 80 00       	push   $0x803faf
  802df9:	e8 eb d4 ff ff       	call   8002e9 <_panic>
  802dfe:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802e04:	8b 45 08             	mov    0x8(%ebp),%eax
  802e07:	89 10                	mov    %edx,(%eax)
  802e09:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0c:	8b 00                	mov    (%eax),%eax
  802e0e:	85 c0                	test   %eax,%eax
  802e10:	74 0d                	je     802e1f <insert_sorted_with_merge_freeList+0x264>
  802e12:	a1 48 51 80 00       	mov    0x805148,%eax
  802e17:	8b 55 08             	mov    0x8(%ebp),%edx
  802e1a:	89 50 04             	mov    %edx,0x4(%eax)
  802e1d:	eb 08                	jmp    802e27 <insert_sorted_with_merge_freeList+0x26c>
  802e1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e22:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e27:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2a:	a3 48 51 80 00       	mov    %eax,0x805148
  802e2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e32:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e39:	a1 54 51 80 00       	mov    0x805154,%eax
  802e3e:	40                   	inc    %eax
  802e3f:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802e44:	e9 bb 04 00 00       	jmp    803304 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802e49:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e4d:	75 17                	jne    802e66 <insert_sorted_with_merge_freeList+0x2ab>
  802e4f:	83 ec 04             	sub    $0x4,%esp
  802e52:	68 00 40 80 00       	push   $0x804000
  802e57:	68 4c 01 00 00       	push   $0x14c
  802e5c:	68 af 3f 80 00       	push   $0x803faf
  802e61:	e8 83 d4 ff ff       	call   8002e9 <_panic>
  802e66:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6f:	89 50 04             	mov    %edx,0x4(%eax)
  802e72:	8b 45 08             	mov    0x8(%ebp),%eax
  802e75:	8b 40 04             	mov    0x4(%eax),%eax
  802e78:	85 c0                	test   %eax,%eax
  802e7a:	74 0c                	je     802e88 <insert_sorted_with_merge_freeList+0x2cd>
  802e7c:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802e81:	8b 55 08             	mov    0x8(%ebp),%edx
  802e84:	89 10                	mov    %edx,(%eax)
  802e86:	eb 08                	jmp    802e90 <insert_sorted_with_merge_freeList+0x2d5>
  802e88:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8b:	a3 38 51 80 00       	mov    %eax,0x805138
  802e90:	8b 45 08             	mov    0x8(%ebp),%eax
  802e93:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e98:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ea1:	a1 44 51 80 00       	mov    0x805144,%eax
  802ea6:	40                   	inc    %eax
  802ea7:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802eac:	e9 53 04 00 00       	jmp    803304 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802eb1:	a1 38 51 80 00       	mov    0x805138,%eax
  802eb6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802eb9:	e9 15 04 00 00       	jmp    8032d3 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802ebe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec1:	8b 00                	mov    (%eax),%eax
  802ec3:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802ec6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec9:	8b 50 08             	mov    0x8(%eax),%edx
  802ecc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ecf:	8b 40 08             	mov    0x8(%eax),%eax
  802ed2:	39 c2                	cmp    %eax,%edx
  802ed4:	0f 86 f1 03 00 00    	jbe    8032cb <insert_sorted_with_merge_freeList+0x710>
  802eda:	8b 45 08             	mov    0x8(%ebp),%eax
  802edd:	8b 50 08             	mov    0x8(%eax),%edx
  802ee0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ee3:	8b 40 08             	mov    0x8(%eax),%eax
  802ee6:	39 c2                	cmp    %eax,%edx
  802ee8:	0f 83 dd 03 00 00    	jae    8032cb <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802eee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef1:	8b 50 08             	mov    0x8(%eax),%edx
  802ef4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef7:	8b 40 0c             	mov    0xc(%eax),%eax
  802efa:	01 c2                	add    %eax,%edx
  802efc:	8b 45 08             	mov    0x8(%ebp),%eax
  802eff:	8b 40 08             	mov    0x8(%eax),%eax
  802f02:	39 c2                	cmp    %eax,%edx
  802f04:	0f 85 b9 01 00 00    	jne    8030c3 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802f0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0d:	8b 50 08             	mov    0x8(%eax),%edx
  802f10:	8b 45 08             	mov    0x8(%ebp),%eax
  802f13:	8b 40 0c             	mov    0xc(%eax),%eax
  802f16:	01 c2                	add    %eax,%edx
  802f18:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f1b:	8b 40 08             	mov    0x8(%eax),%eax
  802f1e:	39 c2                	cmp    %eax,%edx
  802f20:	0f 85 0d 01 00 00    	jne    803033 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802f26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f29:	8b 50 0c             	mov    0xc(%eax),%edx
  802f2c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f2f:	8b 40 0c             	mov    0xc(%eax),%eax
  802f32:	01 c2                	add    %eax,%edx
  802f34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f37:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802f3a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f3e:	75 17                	jne    802f57 <insert_sorted_with_merge_freeList+0x39c>
  802f40:	83 ec 04             	sub    $0x4,%esp
  802f43:	68 58 40 80 00       	push   $0x804058
  802f48:	68 5c 01 00 00       	push   $0x15c
  802f4d:	68 af 3f 80 00       	push   $0x803faf
  802f52:	e8 92 d3 ff ff       	call   8002e9 <_panic>
  802f57:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f5a:	8b 00                	mov    (%eax),%eax
  802f5c:	85 c0                	test   %eax,%eax
  802f5e:	74 10                	je     802f70 <insert_sorted_with_merge_freeList+0x3b5>
  802f60:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f63:	8b 00                	mov    (%eax),%eax
  802f65:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f68:	8b 52 04             	mov    0x4(%edx),%edx
  802f6b:	89 50 04             	mov    %edx,0x4(%eax)
  802f6e:	eb 0b                	jmp    802f7b <insert_sorted_with_merge_freeList+0x3c0>
  802f70:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f73:	8b 40 04             	mov    0x4(%eax),%eax
  802f76:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f7b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f7e:	8b 40 04             	mov    0x4(%eax),%eax
  802f81:	85 c0                	test   %eax,%eax
  802f83:	74 0f                	je     802f94 <insert_sorted_with_merge_freeList+0x3d9>
  802f85:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f88:	8b 40 04             	mov    0x4(%eax),%eax
  802f8b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f8e:	8b 12                	mov    (%edx),%edx
  802f90:	89 10                	mov    %edx,(%eax)
  802f92:	eb 0a                	jmp    802f9e <insert_sorted_with_merge_freeList+0x3e3>
  802f94:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f97:	8b 00                	mov    (%eax),%eax
  802f99:	a3 38 51 80 00       	mov    %eax,0x805138
  802f9e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fa1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fa7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802faa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fb1:	a1 44 51 80 00       	mov    0x805144,%eax
  802fb6:	48                   	dec    %eax
  802fb7:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  802fbc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fbf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  802fc6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fc9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  802fd0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802fd4:	75 17                	jne    802fed <insert_sorted_with_merge_freeList+0x432>
  802fd6:	83 ec 04             	sub    $0x4,%esp
  802fd9:	68 8c 3f 80 00       	push   $0x803f8c
  802fde:	68 5f 01 00 00       	push   $0x15f
  802fe3:	68 af 3f 80 00       	push   $0x803faf
  802fe8:	e8 fc d2 ff ff       	call   8002e9 <_panic>
  802fed:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802ff3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ff6:	89 10                	mov    %edx,(%eax)
  802ff8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ffb:	8b 00                	mov    (%eax),%eax
  802ffd:	85 c0                	test   %eax,%eax
  802fff:	74 0d                	je     80300e <insert_sorted_with_merge_freeList+0x453>
  803001:	a1 48 51 80 00       	mov    0x805148,%eax
  803006:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803009:	89 50 04             	mov    %edx,0x4(%eax)
  80300c:	eb 08                	jmp    803016 <insert_sorted_with_merge_freeList+0x45b>
  80300e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803011:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803016:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803019:	a3 48 51 80 00       	mov    %eax,0x805148
  80301e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803021:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803028:	a1 54 51 80 00       	mov    0x805154,%eax
  80302d:	40                   	inc    %eax
  80302e:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803033:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803036:	8b 50 0c             	mov    0xc(%eax),%edx
  803039:	8b 45 08             	mov    0x8(%ebp),%eax
  80303c:	8b 40 0c             	mov    0xc(%eax),%eax
  80303f:	01 c2                	add    %eax,%edx
  803041:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803044:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803047:	8b 45 08             	mov    0x8(%ebp),%eax
  80304a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803051:	8b 45 08             	mov    0x8(%ebp),%eax
  803054:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80305b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80305f:	75 17                	jne    803078 <insert_sorted_with_merge_freeList+0x4bd>
  803061:	83 ec 04             	sub    $0x4,%esp
  803064:	68 8c 3f 80 00       	push   $0x803f8c
  803069:	68 64 01 00 00       	push   $0x164
  80306e:	68 af 3f 80 00       	push   $0x803faf
  803073:	e8 71 d2 ff ff       	call   8002e9 <_panic>
  803078:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80307e:	8b 45 08             	mov    0x8(%ebp),%eax
  803081:	89 10                	mov    %edx,(%eax)
  803083:	8b 45 08             	mov    0x8(%ebp),%eax
  803086:	8b 00                	mov    (%eax),%eax
  803088:	85 c0                	test   %eax,%eax
  80308a:	74 0d                	je     803099 <insert_sorted_with_merge_freeList+0x4de>
  80308c:	a1 48 51 80 00       	mov    0x805148,%eax
  803091:	8b 55 08             	mov    0x8(%ebp),%edx
  803094:	89 50 04             	mov    %edx,0x4(%eax)
  803097:	eb 08                	jmp    8030a1 <insert_sorted_with_merge_freeList+0x4e6>
  803099:	8b 45 08             	mov    0x8(%ebp),%eax
  80309c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a4:	a3 48 51 80 00       	mov    %eax,0x805148
  8030a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030b3:	a1 54 51 80 00       	mov    0x805154,%eax
  8030b8:	40                   	inc    %eax
  8030b9:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8030be:	e9 41 02 00 00       	jmp    803304 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8030c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c6:	8b 50 08             	mov    0x8(%eax),%edx
  8030c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030cc:	8b 40 0c             	mov    0xc(%eax),%eax
  8030cf:	01 c2                	add    %eax,%edx
  8030d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030d4:	8b 40 08             	mov    0x8(%eax),%eax
  8030d7:	39 c2                	cmp    %eax,%edx
  8030d9:	0f 85 7c 01 00 00    	jne    80325b <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8030df:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030e3:	74 06                	je     8030eb <insert_sorted_with_merge_freeList+0x530>
  8030e5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030e9:	75 17                	jne    803102 <insert_sorted_with_merge_freeList+0x547>
  8030eb:	83 ec 04             	sub    $0x4,%esp
  8030ee:	68 c8 3f 80 00       	push   $0x803fc8
  8030f3:	68 69 01 00 00       	push   $0x169
  8030f8:	68 af 3f 80 00       	push   $0x803faf
  8030fd:	e8 e7 d1 ff ff       	call   8002e9 <_panic>
  803102:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803105:	8b 50 04             	mov    0x4(%eax),%edx
  803108:	8b 45 08             	mov    0x8(%ebp),%eax
  80310b:	89 50 04             	mov    %edx,0x4(%eax)
  80310e:	8b 45 08             	mov    0x8(%ebp),%eax
  803111:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803114:	89 10                	mov    %edx,(%eax)
  803116:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803119:	8b 40 04             	mov    0x4(%eax),%eax
  80311c:	85 c0                	test   %eax,%eax
  80311e:	74 0d                	je     80312d <insert_sorted_with_merge_freeList+0x572>
  803120:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803123:	8b 40 04             	mov    0x4(%eax),%eax
  803126:	8b 55 08             	mov    0x8(%ebp),%edx
  803129:	89 10                	mov    %edx,(%eax)
  80312b:	eb 08                	jmp    803135 <insert_sorted_with_merge_freeList+0x57a>
  80312d:	8b 45 08             	mov    0x8(%ebp),%eax
  803130:	a3 38 51 80 00       	mov    %eax,0x805138
  803135:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803138:	8b 55 08             	mov    0x8(%ebp),%edx
  80313b:	89 50 04             	mov    %edx,0x4(%eax)
  80313e:	a1 44 51 80 00       	mov    0x805144,%eax
  803143:	40                   	inc    %eax
  803144:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803149:	8b 45 08             	mov    0x8(%ebp),%eax
  80314c:	8b 50 0c             	mov    0xc(%eax),%edx
  80314f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803152:	8b 40 0c             	mov    0xc(%eax),%eax
  803155:	01 c2                	add    %eax,%edx
  803157:	8b 45 08             	mov    0x8(%ebp),%eax
  80315a:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80315d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803161:	75 17                	jne    80317a <insert_sorted_with_merge_freeList+0x5bf>
  803163:	83 ec 04             	sub    $0x4,%esp
  803166:	68 58 40 80 00       	push   $0x804058
  80316b:	68 6b 01 00 00       	push   $0x16b
  803170:	68 af 3f 80 00       	push   $0x803faf
  803175:	e8 6f d1 ff ff       	call   8002e9 <_panic>
  80317a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80317d:	8b 00                	mov    (%eax),%eax
  80317f:	85 c0                	test   %eax,%eax
  803181:	74 10                	je     803193 <insert_sorted_with_merge_freeList+0x5d8>
  803183:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803186:	8b 00                	mov    (%eax),%eax
  803188:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80318b:	8b 52 04             	mov    0x4(%edx),%edx
  80318e:	89 50 04             	mov    %edx,0x4(%eax)
  803191:	eb 0b                	jmp    80319e <insert_sorted_with_merge_freeList+0x5e3>
  803193:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803196:	8b 40 04             	mov    0x4(%eax),%eax
  803199:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80319e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031a1:	8b 40 04             	mov    0x4(%eax),%eax
  8031a4:	85 c0                	test   %eax,%eax
  8031a6:	74 0f                	je     8031b7 <insert_sorted_with_merge_freeList+0x5fc>
  8031a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ab:	8b 40 04             	mov    0x4(%eax),%eax
  8031ae:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031b1:	8b 12                	mov    (%edx),%edx
  8031b3:	89 10                	mov    %edx,(%eax)
  8031b5:	eb 0a                	jmp    8031c1 <insert_sorted_with_merge_freeList+0x606>
  8031b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ba:	8b 00                	mov    (%eax),%eax
  8031bc:	a3 38 51 80 00       	mov    %eax,0x805138
  8031c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031cd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031d4:	a1 44 51 80 00       	mov    0x805144,%eax
  8031d9:	48                   	dec    %eax
  8031da:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8031df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8031e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ec:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8031f3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031f7:	75 17                	jne    803210 <insert_sorted_with_merge_freeList+0x655>
  8031f9:	83 ec 04             	sub    $0x4,%esp
  8031fc:	68 8c 3f 80 00       	push   $0x803f8c
  803201:	68 6e 01 00 00       	push   $0x16e
  803206:	68 af 3f 80 00       	push   $0x803faf
  80320b:	e8 d9 d0 ff ff       	call   8002e9 <_panic>
  803210:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803216:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803219:	89 10                	mov    %edx,(%eax)
  80321b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80321e:	8b 00                	mov    (%eax),%eax
  803220:	85 c0                	test   %eax,%eax
  803222:	74 0d                	je     803231 <insert_sorted_with_merge_freeList+0x676>
  803224:	a1 48 51 80 00       	mov    0x805148,%eax
  803229:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80322c:	89 50 04             	mov    %edx,0x4(%eax)
  80322f:	eb 08                	jmp    803239 <insert_sorted_with_merge_freeList+0x67e>
  803231:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803234:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803239:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80323c:	a3 48 51 80 00       	mov    %eax,0x805148
  803241:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803244:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80324b:	a1 54 51 80 00       	mov    0x805154,%eax
  803250:	40                   	inc    %eax
  803251:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803256:	e9 a9 00 00 00       	jmp    803304 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  80325b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80325f:	74 06                	je     803267 <insert_sorted_with_merge_freeList+0x6ac>
  803261:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803265:	75 17                	jne    80327e <insert_sorted_with_merge_freeList+0x6c3>
  803267:	83 ec 04             	sub    $0x4,%esp
  80326a:	68 24 40 80 00       	push   $0x804024
  80326f:	68 73 01 00 00       	push   $0x173
  803274:	68 af 3f 80 00       	push   $0x803faf
  803279:	e8 6b d0 ff ff       	call   8002e9 <_panic>
  80327e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803281:	8b 10                	mov    (%eax),%edx
  803283:	8b 45 08             	mov    0x8(%ebp),%eax
  803286:	89 10                	mov    %edx,(%eax)
  803288:	8b 45 08             	mov    0x8(%ebp),%eax
  80328b:	8b 00                	mov    (%eax),%eax
  80328d:	85 c0                	test   %eax,%eax
  80328f:	74 0b                	je     80329c <insert_sorted_with_merge_freeList+0x6e1>
  803291:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803294:	8b 00                	mov    (%eax),%eax
  803296:	8b 55 08             	mov    0x8(%ebp),%edx
  803299:	89 50 04             	mov    %edx,0x4(%eax)
  80329c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80329f:	8b 55 08             	mov    0x8(%ebp),%edx
  8032a2:	89 10                	mov    %edx,(%eax)
  8032a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032aa:	89 50 04             	mov    %edx,0x4(%eax)
  8032ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b0:	8b 00                	mov    (%eax),%eax
  8032b2:	85 c0                	test   %eax,%eax
  8032b4:	75 08                	jne    8032be <insert_sorted_with_merge_freeList+0x703>
  8032b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032be:	a1 44 51 80 00       	mov    0x805144,%eax
  8032c3:	40                   	inc    %eax
  8032c4:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  8032c9:	eb 39                	jmp    803304 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8032cb:	a1 40 51 80 00       	mov    0x805140,%eax
  8032d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032d7:	74 07                	je     8032e0 <insert_sorted_with_merge_freeList+0x725>
  8032d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032dc:	8b 00                	mov    (%eax),%eax
  8032de:	eb 05                	jmp    8032e5 <insert_sorted_with_merge_freeList+0x72a>
  8032e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8032e5:	a3 40 51 80 00       	mov    %eax,0x805140
  8032ea:	a1 40 51 80 00       	mov    0x805140,%eax
  8032ef:	85 c0                	test   %eax,%eax
  8032f1:	0f 85 c7 fb ff ff    	jne    802ebe <insert_sorted_with_merge_freeList+0x303>
  8032f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032fb:	0f 85 bd fb ff ff    	jne    802ebe <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803301:	eb 01                	jmp    803304 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803303:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803304:	90                   	nop
  803305:	c9                   	leave  
  803306:	c3                   	ret    

00803307 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803307:	55                   	push   %ebp
  803308:	89 e5                	mov    %esp,%ebp
  80330a:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  80330d:	8b 55 08             	mov    0x8(%ebp),%edx
  803310:	89 d0                	mov    %edx,%eax
  803312:	c1 e0 02             	shl    $0x2,%eax
  803315:	01 d0                	add    %edx,%eax
  803317:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80331e:	01 d0                	add    %edx,%eax
  803320:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803327:	01 d0                	add    %edx,%eax
  803329:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803330:	01 d0                	add    %edx,%eax
  803332:	c1 e0 04             	shl    $0x4,%eax
  803335:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803338:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  80333f:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803342:	83 ec 0c             	sub    $0xc,%esp
  803345:	50                   	push   %eax
  803346:	e8 26 e7 ff ff       	call   801a71 <sys_get_virtual_time>
  80334b:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  80334e:	eb 41                	jmp    803391 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803350:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803353:	83 ec 0c             	sub    $0xc,%esp
  803356:	50                   	push   %eax
  803357:	e8 15 e7 ff ff       	call   801a71 <sys_get_virtual_time>
  80335c:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  80335f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803362:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803365:	29 c2                	sub    %eax,%edx
  803367:	89 d0                	mov    %edx,%eax
  803369:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  80336c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80336f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803372:	89 d1                	mov    %edx,%ecx
  803374:	29 c1                	sub    %eax,%ecx
  803376:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803379:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80337c:	39 c2                	cmp    %eax,%edx
  80337e:	0f 97 c0             	seta   %al
  803381:	0f b6 c0             	movzbl %al,%eax
  803384:	29 c1                	sub    %eax,%ecx
  803386:	89 c8                	mov    %ecx,%eax
  803388:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  80338b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80338e:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803391:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803394:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803397:	72 b7                	jb     803350 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803399:	90                   	nop
  80339a:	c9                   	leave  
  80339b:	c3                   	ret    

0080339c <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  80339c:	55                   	push   %ebp
  80339d:	89 e5                	mov    %esp,%ebp
  80339f:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8033a2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8033a9:	eb 03                	jmp    8033ae <busy_wait+0x12>
  8033ab:	ff 45 fc             	incl   -0x4(%ebp)
  8033ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8033b1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8033b4:	72 f5                	jb     8033ab <busy_wait+0xf>
	return i;
  8033b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8033b9:	c9                   	leave  
  8033ba:	c3                   	ret    
  8033bb:	90                   	nop

008033bc <__udivdi3>:
  8033bc:	55                   	push   %ebp
  8033bd:	57                   	push   %edi
  8033be:	56                   	push   %esi
  8033bf:	53                   	push   %ebx
  8033c0:	83 ec 1c             	sub    $0x1c,%esp
  8033c3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8033c7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8033cb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8033cf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8033d3:	89 ca                	mov    %ecx,%edx
  8033d5:	89 f8                	mov    %edi,%eax
  8033d7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8033db:	85 f6                	test   %esi,%esi
  8033dd:	75 2d                	jne    80340c <__udivdi3+0x50>
  8033df:	39 cf                	cmp    %ecx,%edi
  8033e1:	77 65                	ja     803448 <__udivdi3+0x8c>
  8033e3:	89 fd                	mov    %edi,%ebp
  8033e5:	85 ff                	test   %edi,%edi
  8033e7:	75 0b                	jne    8033f4 <__udivdi3+0x38>
  8033e9:	b8 01 00 00 00       	mov    $0x1,%eax
  8033ee:	31 d2                	xor    %edx,%edx
  8033f0:	f7 f7                	div    %edi
  8033f2:	89 c5                	mov    %eax,%ebp
  8033f4:	31 d2                	xor    %edx,%edx
  8033f6:	89 c8                	mov    %ecx,%eax
  8033f8:	f7 f5                	div    %ebp
  8033fa:	89 c1                	mov    %eax,%ecx
  8033fc:	89 d8                	mov    %ebx,%eax
  8033fe:	f7 f5                	div    %ebp
  803400:	89 cf                	mov    %ecx,%edi
  803402:	89 fa                	mov    %edi,%edx
  803404:	83 c4 1c             	add    $0x1c,%esp
  803407:	5b                   	pop    %ebx
  803408:	5e                   	pop    %esi
  803409:	5f                   	pop    %edi
  80340a:	5d                   	pop    %ebp
  80340b:	c3                   	ret    
  80340c:	39 ce                	cmp    %ecx,%esi
  80340e:	77 28                	ja     803438 <__udivdi3+0x7c>
  803410:	0f bd fe             	bsr    %esi,%edi
  803413:	83 f7 1f             	xor    $0x1f,%edi
  803416:	75 40                	jne    803458 <__udivdi3+0x9c>
  803418:	39 ce                	cmp    %ecx,%esi
  80341a:	72 0a                	jb     803426 <__udivdi3+0x6a>
  80341c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803420:	0f 87 9e 00 00 00    	ja     8034c4 <__udivdi3+0x108>
  803426:	b8 01 00 00 00       	mov    $0x1,%eax
  80342b:	89 fa                	mov    %edi,%edx
  80342d:	83 c4 1c             	add    $0x1c,%esp
  803430:	5b                   	pop    %ebx
  803431:	5e                   	pop    %esi
  803432:	5f                   	pop    %edi
  803433:	5d                   	pop    %ebp
  803434:	c3                   	ret    
  803435:	8d 76 00             	lea    0x0(%esi),%esi
  803438:	31 ff                	xor    %edi,%edi
  80343a:	31 c0                	xor    %eax,%eax
  80343c:	89 fa                	mov    %edi,%edx
  80343e:	83 c4 1c             	add    $0x1c,%esp
  803441:	5b                   	pop    %ebx
  803442:	5e                   	pop    %esi
  803443:	5f                   	pop    %edi
  803444:	5d                   	pop    %ebp
  803445:	c3                   	ret    
  803446:	66 90                	xchg   %ax,%ax
  803448:	89 d8                	mov    %ebx,%eax
  80344a:	f7 f7                	div    %edi
  80344c:	31 ff                	xor    %edi,%edi
  80344e:	89 fa                	mov    %edi,%edx
  803450:	83 c4 1c             	add    $0x1c,%esp
  803453:	5b                   	pop    %ebx
  803454:	5e                   	pop    %esi
  803455:	5f                   	pop    %edi
  803456:	5d                   	pop    %ebp
  803457:	c3                   	ret    
  803458:	bd 20 00 00 00       	mov    $0x20,%ebp
  80345d:	89 eb                	mov    %ebp,%ebx
  80345f:	29 fb                	sub    %edi,%ebx
  803461:	89 f9                	mov    %edi,%ecx
  803463:	d3 e6                	shl    %cl,%esi
  803465:	89 c5                	mov    %eax,%ebp
  803467:	88 d9                	mov    %bl,%cl
  803469:	d3 ed                	shr    %cl,%ebp
  80346b:	89 e9                	mov    %ebp,%ecx
  80346d:	09 f1                	or     %esi,%ecx
  80346f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803473:	89 f9                	mov    %edi,%ecx
  803475:	d3 e0                	shl    %cl,%eax
  803477:	89 c5                	mov    %eax,%ebp
  803479:	89 d6                	mov    %edx,%esi
  80347b:	88 d9                	mov    %bl,%cl
  80347d:	d3 ee                	shr    %cl,%esi
  80347f:	89 f9                	mov    %edi,%ecx
  803481:	d3 e2                	shl    %cl,%edx
  803483:	8b 44 24 08          	mov    0x8(%esp),%eax
  803487:	88 d9                	mov    %bl,%cl
  803489:	d3 e8                	shr    %cl,%eax
  80348b:	09 c2                	or     %eax,%edx
  80348d:	89 d0                	mov    %edx,%eax
  80348f:	89 f2                	mov    %esi,%edx
  803491:	f7 74 24 0c          	divl   0xc(%esp)
  803495:	89 d6                	mov    %edx,%esi
  803497:	89 c3                	mov    %eax,%ebx
  803499:	f7 e5                	mul    %ebp
  80349b:	39 d6                	cmp    %edx,%esi
  80349d:	72 19                	jb     8034b8 <__udivdi3+0xfc>
  80349f:	74 0b                	je     8034ac <__udivdi3+0xf0>
  8034a1:	89 d8                	mov    %ebx,%eax
  8034a3:	31 ff                	xor    %edi,%edi
  8034a5:	e9 58 ff ff ff       	jmp    803402 <__udivdi3+0x46>
  8034aa:	66 90                	xchg   %ax,%ax
  8034ac:	8b 54 24 08          	mov    0x8(%esp),%edx
  8034b0:	89 f9                	mov    %edi,%ecx
  8034b2:	d3 e2                	shl    %cl,%edx
  8034b4:	39 c2                	cmp    %eax,%edx
  8034b6:	73 e9                	jae    8034a1 <__udivdi3+0xe5>
  8034b8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8034bb:	31 ff                	xor    %edi,%edi
  8034bd:	e9 40 ff ff ff       	jmp    803402 <__udivdi3+0x46>
  8034c2:	66 90                	xchg   %ax,%ax
  8034c4:	31 c0                	xor    %eax,%eax
  8034c6:	e9 37 ff ff ff       	jmp    803402 <__udivdi3+0x46>
  8034cb:	90                   	nop

008034cc <__umoddi3>:
  8034cc:	55                   	push   %ebp
  8034cd:	57                   	push   %edi
  8034ce:	56                   	push   %esi
  8034cf:	53                   	push   %ebx
  8034d0:	83 ec 1c             	sub    $0x1c,%esp
  8034d3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8034d7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8034db:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8034df:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8034e3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8034e7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8034eb:	89 f3                	mov    %esi,%ebx
  8034ed:	89 fa                	mov    %edi,%edx
  8034ef:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8034f3:	89 34 24             	mov    %esi,(%esp)
  8034f6:	85 c0                	test   %eax,%eax
  8034f8:	75 1a                	jne    803514 <__umoddi3+0x48>
  8034fa:	39 f7                	cmp    %esi,%edi
  8034fc:	0f 86 a2 00 00 00    	jbe    8035a4 <__umoddi3+0xd8>
  803502:	89 c8                	mov    %ecx,%eax
  803504:	89 f2                	mov    %esi,%edx
  803506:	f7 f7                	div    %edi
  803508:	89 d0                	mov    %edx,%eax
  80350a:	31 d2                	xor    %edx,%edx
  80350c:	83 c4 1c             	add    $0x1c,%esp
  80350f:	5b                   	pop    %ebx
  803510:	5e                   	pop    %esi
  803511:	5f                   	pop    %edi
  803512:	5d                   	pop    %ebp
  803513:	c3                   	ret    
  803514:	39 f0                	cmp    %esi,%eax
  803516:	0f 87 ac 00 00 00    	ja     8035c8 <__umoddi3+0xfc>
  80351c:	0f bd e8             	bsr    %eax,%ebp
  80351f:	83 f5 1f             	xor    $0x1f,%ebp
  803522:	0f 84 ac 00 00 00    	je     8035d4 <__umoddi3+0x108>
  803528:	bf 20 00 00 00       	mov    $0x20,%edi
  80352d:	29 ef                	sub    %ebp,%edi
  80352f:	89 fe                	mov    %edi,%esi
  803531:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803535:	89 e9                	mov    %ebp,%ecx
  803537:	d3 e0                	shl    %cl,%eax
  803539:	89 d7                	mov    %edx,%edi
  80353b:	89 f1                	mov    %esi,%ecx
  80353d:	d3 ef                	shr    %cl,%edi
  80353f:	09 c7                	or     %eax,%edi
  803541:	89 e9                	mov    %ebp,%ecx
  803543:	d3 e2                	shl    %cl,%edx
  803545:	89 14 24             	mov    %edx,(%esp)
  803548:	89 d8                	mov    %ebx,%eax
  80354a:	d3 e0                	shl    %cl,%eax
  80354c:	89 c2                	mov    %eax,%edx
  80354e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803552:	d3 e0                	shl    %cl,%eax
  803554:	89 44 24 04          	mov    %eax,0x4(%esp)
  803558:	8b 44 24 08          	mov    0x8(%esp),%eax
  80355c:	89 f1                	mov    %esi,%ecx
  80355e:	d3 e8                	shr    %cl,%eax
  803560:	09 d0                	or     %edx,%eax
  803562:	d3 eb                	shr    %cl,%ebx
  803564:	89 da                	mov    %ebx,%edx
  803566:	f7 f7                	div    %edi
  803568:	89 d3                	mov    %edx,%ebx
  80356a:	f7 24 24             	mull   (%esp)
  80356d:	89 c6                	mov    %eax,%esi
  80356f:	89 d1                	mov    %edx,%ecx
  803571:	39 d3                	cmp    %edx,%ebx
  803573:	0f 82 87 00 00 00    	jb     803600 <__umoddi3+0x134>
  803579:	0f 84 91 00 00 00    	je     803610 <__umoddi3+0x144>
  80357f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803583:	29 f2                	sub    %esi,%edx
  803585:	19 cb                	sbb    %ecx,%ebx
  803587:	89 d8                	mov    %ebx,%eax
  803589:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80358d:	d3 e0                	shl    %cl,%eax
  80358f:	89 e9                	mov    %ebp,%ecx
  803591:	d3 ea                	shr    %cl,%edx
  803593:	09 d0                	or     %edx,%eax
  803595:	89 e9                	mov    %ebp,%ecx
  803597:	d3 eb                	shr    %cl,%ebx
  803599:	89 da                	mov    %ebx,%edx
  80359b:	83 c4 1c             	add    $0x1c,%esp
  80359e:	5b                   	pop    %ebx
  80359f:	5e                   	pop    %esi
  8035a0:	5f                   	pop    %edi
  8035a1:	5d                   	pop    %ebp
  8035a2:	c3                   	ret    
  8035a3:	90                   	nop
  8035a4:	89 fd                	mov    %edi,%ebp
  8035a6:	85 ff                	test   %edi,%edi
  8035a8:	75 0b                	jne    8035b5 <__umoddi3+0xe9>
  8035aa:	b8 01 00 00 00       	mov    $0x1,%eax
  8035af:	31 d2                	xor    %edx,%edx
  8035b1:	f7 f7                	div    %edi
  8035b3:	89 c5                	mov    %eax,%ebp
  8035b5:	89 f0                	mov    %esi,%eax
  8035b7:	31 d2                	xor    %edx,%edx
  8035b9:	f7 f5                	div    %ebp
  8035bb:	89 c8                	mov    %ecx,%eax
  8035bd:	f7 f5                	div    %ebp
  8035bf:	89 d0                	mov    %edx,%eax
  8035c1:	e9 44 ff ff ff       	jmp    80350a <__umoddi3+0x3e>
  8035c6:	66 90                	xchg   %ax,%ax
  8035c8:	89 c8                	mov    %ecx,%eax
  8035ca:	89 f2                	mov    %esi,%edx
  8035cc:	83 c4 1c             	add    $0x1c,%esp
  8035cf:	5b                   	pop    %ebx
  8035d0:	5e                   	pop    %esi
  8035d1:	5f                   	pop    %edi
  8035d2:	5d                   	pop    %ebp
  8035d3:	c3                   	ret    
  8035d4:	3b 04 24             	cmp    (%esp),%eax
  8035d7:	72 06                	jb     8035df <__umoddi3+0x113>
  8035d9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8035dd:	77 0f                	ja     8035ee <__umoddi3+0x122>
  8035df:	89 f2                	mov    %esi,%edx
  8035e1:	29 f9                	sub    %edi,%ecx
  8035e3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8035e7:	89 14 24             	mov    %edx,(%esp)
  8035ea:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8035ee:	8b 44 24 04          	mov    0x4(%esp),%eax
  8035f2:	8b 14 24             	mov    (%esp),%edx
  8035f5:	83 c4 1c             	add    $0x1c,%esp
  8035f8:	5b                   	pop    %ebx
  8035f9:	5e                   	pop    %esi
  8035fa:	5f                   	pop    %edi
  8035fb:	5d                   	pop    %ebp
  8035fc:	c3                   	ret    
  8035fd:	8d 76 00             	lea    0x0(%esi),%esi
  803600:	2b 04 24             	sub    (%esp),%eax
  803603:	19 fa                	sbb    %edi,%edx
  803605:	89 d1                	mov    %edx,%ecx
  803607:	89 c6                	mov    %eax,%esi
  803609:	e9 71 ff ff ff       	jmp    80357f <__umoddi3+0xb3>
  80360e:	66 90                	xchg   %ax,%ax
  803610:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803614:	72 ea                	jb     803600 <__umoddi3+0x134>
  803616:	89 d9                	mov    %ebx,%ecx
  803618:	e9 62 ff ff ff       	jmp    80357f <__umoddi3+0xb3>
