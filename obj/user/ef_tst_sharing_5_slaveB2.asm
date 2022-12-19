
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
  80008c:	68 20 38 80 00       	push   $0x803820
  800091:	6a 12                	push   $0x12
  800093:	68 3c 38 80 00       	push   $0x80383c
  800098:	e8 4c 02 00 00       	call   8002e9 <_panic>
	}
	uint32 *z;
	z = sget(sys_getparentenvid(),"z");
  80009d:	e8 99 1b 00 00       	call   801c3b <sys_getparentenvid>
  8000a2:	83 ec 08             	sub    $0x8,%esp
  8000a5:	68 5c 38 80 00       	push   $0x80385c
  8000aa:	50                   	push   %eax
  8000ab:	e8 6e 16 00 00       	call   80171e <sget>
  8000b0:	83 c4 10             	add    $0x10,%esp
  8000b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("Slave B2 env used z (getSharedObject)\n");
  8000b6:	83 ec 0c             	sub    $0xc,%esp
  8000b9:	68 60 38 80 00       	push   $0x803860
  8000be:	e8 da 04 00 00       	call   80059d <cprintf>
  8000c3:	83 c4 10             	add    $0x10,%esp

	cprintf("Slave B2 please be patient ...\n");
  8000c6:	83 ec 0c             	sub    $0xc,%esp
  8000c9:	68 88 38 80 00       	push   $0x803888
  8000ce:	e8 ca 04 00 00       	call   80059d <cprintf>
  8000d3:	83 c4 10             	add    $0x10,%esp

	env_sleep(9000);
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	68 28 23 00 00       	push   $0x2328
  8000de:	e8 21 34 00 00       	call   803504 <env_sleep>
  8000e3:	83 c4 10             	add    $0x10,%esp
	int freeFrames = sys_calculate_free_frames() ;
  8000e6:	e8 57 18 00 00       	call   801942 <sys_calculate_free_frames>
  8000eb:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sfree(z);
  8000ee:	83 ec 0c             	sub    $0xc,%esp
  8000f1:	ff 75 ec             	pushl  -0x14(%ebp)
  8000f4:	e8 e9 16 00 00       	call   8017e2 <sfree>
  8000f9:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave B2 env removed z\n");
  8000fc:	83 ec 0c             	sub    $0xc,%esp
  8000ff:	68 a8 38 80 00       	push   $0x8038a8
  800104:	e8 94 04 00 00       	call   80059d <cprintf>
  800109:	83 c4 10             	add    $0x10,%esp

	if ((sys_calculate_free_frames() - freeFrames) !=  4) panic("wrong free: frames removed not equal 4 !, correct frames to be removed are 4:\nfrom the env: 1 table + 1 frame for z\nframes_storage of z: should be cleared now\n");
  80010c:	e8 31 18 00 00       	call   801942 <sys_calculate_free_frames>
  800111:	89 c2                	mov    %eax,%edx
  800113:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800116:	29 c2                	sub    %eax,%edx
  800118:	89 d0                	mov    %edx,%eax
  80011a:	83 f8 04             	cmp    $0x4,%eax
  80011d:	74 14                	je     800133 <_main+0xfb>
  80011f:	83 ec 04             	sub    $0x4,%esp
  800122:	68 c0 38 80 00       	push   $0x8038c0
  800127:	6a 20                	push   $0x20
  800129:	68 3c 38 80 00       	push   $0x80383c
  80012e:	e8 b6 01 00 00       	call   8002e9 <_panic>

	//to ensure that the other environments completed successfully
	if (gettst()!=2) panic("test failed");
  800133:	e8 42 1c 00 00       	call   801d7a <gettst>
  800138:	83 f8 02             	cmp    $0x2,%eax
  80013b:	74 14                	je     800151 <_main+0x119>
  80013d:	83 ec 04             	sub    $0x4,%esp
  800140:	68 60 39 80 00       	push   $0x803960
  800145:	6a 23                	push   $0x23
  800147:	68 3c 38 80 00       	push   $0x80383c
  80014c:	e8 98 01 00 00       	call   8002e9 <_panic>

	cprintf("Step B completed successfully!!\n\n\n");
  800151:	83 ec 0c             	sub    $0xc,%esp
  800154:	68 6c 39 80 00       	push   $0x80396c
  800159:	e8 3f 04 00 00       	call   80059d <cprintf>
  80015e:	83 c4 10             	add    $0x10,%esp
	cprintf("Congratulations!! Test of freeSharedObjects [5] completed successfully!!\n\n\n");
  800161:	83 ec 0c             	sub    $0xc,%esp
  800164:	68 90 39 80 00       	push   $0x803990
  800169:	e8 2f 04 00 00       	call   80059d <cprintf>
  80016e:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  800171:	e8 c5 1a 00 00       	call   801c3b <sys_getparentenvid>
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
  800189:	68 dc 39 80 00       	push   $0x8039dc
  80018e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800191:	e8 88 15 00 00       	call   80171e <sget>
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
  8001b3:	e8 6a 1a 00 00       	call   801c22 <sys_getenvindex>
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
  80021e:	e8 0c 18 00 00       	call   801a2f <sys_disable_interrupt>
	cprintf("**************************************\n");
  800223:	83 ec 0c             	sub    $0xc,%esp
  800226:	68 04 3a 80 00       	push   $0x803a04
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
  80024e:	68 2c 3a 80 00       	push   $0x803a2c
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
  80027f:	68 54 3a 80 00       	push   $0x803a54
  800284:	e8 14 03 00 00       	call   80059d <cprintf>
  800289:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80028c:	a1 20 50 80 00       	mov    0x805020,%eax
  800291:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800297:	83 ec 08             	sub    $0x8,%esp
  80029a:	50                   	push   %eax
  80029b:	68 ac 3a 80 00       	push   $0x803aac
  8002a0:	e8 f8 02 00 00       	call   80059d <cprintf>
  8002a5:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8002a8:	83 ec 0c             	sub    $0xc,%esp
  8002ab:	68 04 3a 80 00       	push   $0x803a04
  8002b0:	e8 e8 02 00 00       	call   80059d <cprintf>
  8002b5:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8002b8:	e8 8c 17 00 00       	call   801a49 <sys_enable_interrupt>

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
  8002d0:	e8 19 19 00 00       	call   801bee <sys_destroy_env>
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
  8002e1:	e8 6e 19 00 00       	call   801c54 <sys_exit_env>
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
  80030a:	68 c0 3a 80 00       	push   $0x803ac0
  80030f:	e8 89 02 00 00       	call   80059d <cprintf>
  800314:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800317:	a1 00 50 80 00       	mov    0x805000,%eax
  80031c:	ff 75 0c             	pushl  0xc(%ebp)
  80031f:	ff 75 08             	pushl  0x8(%ebp)
  800322:	50                   	push   %eax
  800323:	68 c5 3a 80 00       	push   $0x803ac5
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
  800347:	68 e1 3a 80 00       	push   $0x803ae1
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
  800373:	68 e4 3a 80 00       	push   $0x803ae4
  800378:	6a 26                	push   $0x26
  80037a:	68 30 3b 80 00       	push   $0x803b30
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
  800445:	68 3c 3b 80 00       	push   $0x803b3c
  80044a:	6a 3a                	push   $0x3a
  80044c:	68 30 3b 80 00       	push   $0x803b30
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
  8004b5:	68 90 3b 80 00       	push   $0x803b90
  8004ba:	6a 44                	push   $0x44
  8004bc:	68 30 3b 80 00       	push   $0x803b30
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
  80050f:	e8 6d 13 00 00       	call   801881 <sys_cputs>
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
  800586:	e8 f6 12 00 00       	call   801881 <sys_cputs>
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
  8005d0:	e8 5a 14 00 00       	call   801a2f <sys_disable_interrupt>
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
  8005f0:	e8 54 14 00 00       	call   801a49 <sys_enable_interrupt>
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
  80063a:	e8 79 2f 00 00       	call   8035b8 <__udivdi3>
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
  80068a:	e8 39 30 00 00       	call   8036c8 <__umoddi3>
  80068f:	83 c4 10             	add    $0x10,%esp
  800692:	05 f4 3d 80 00       	add    $0x803df4,%eax
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
  8007e5:	8b 04 85 18 3e 80 00 	mov    0x803e18(,%eax,4),%eax
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
  8008c6:	8b 34 9d 60 3c 80 00 	mov    0x803c60(,%ebx,4),%esi
  8008cd:	85 f6                	test   %esi,%esi
  8008cf:	75 19                	jne    8008ea <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008d1:	53                   	push   %ebx
  8008d2:	68 05 3e 80 00       	push   $0x803e05
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
  8008eb:	68 0e 3e 80 00       	push   $0x803e0e
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
  800918:	be 11 3e 80 00       	mov    $0x803e11,%esi
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
  80133e:	68 70 3f 80 00       	push   $0x803f70
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
  80140e:	e8 b2 05 00 00       	call   8019c5 <sys_allocate_chunk>
  801413:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801416:	a1 20 51 80 00       	mov    0x805120,%eax
  80141b:	83 ec 0c             	sub    $0xc,%esp
  80141e:	50                   	push   %eax
  80141f:	e8 27 0c 00 00       	call   80204b <initialize_MemBlocksList>
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
  80144c:	68 95 3f 80 00       	push   $0x803f95
  801451:	6a 33                	push   $0x33
  801453:	68 b3 3f 80 00       	push   $0x803fb3
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
  8014cb:	68 c0 3f 80 00       	push   $0x803fc0
  8014d0:	6a 34                	push   $0x34
  8014d2:	68 b3 3f 80 00       	push   $0x803fb3
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
  801563:	e8 2b 08 00 00       	call   801d93 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801568:	85 c0                	test   %eax,%eax
  80156a:	74 11                	je     80157d <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  80156c:	83 ec 0c             	sub    $0xc,%esp
  80156f:	ff 75 e8             	pushl  -0x18(%ebp)
  801572:	e8 96 0e 00 00       	call   80240d <alloc_block_FF>
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
  801589:	e8 f2 0b 00 00       	call   802180 <insert_sorted_allocList>
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
  8015a3:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	struct MemBlock * free_block=find_block(&AllocMemBlocksList,(uint32)virtual_address);
  8015a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a9:	83 ec 08             	sub    $0x8,%esp
  8015ac:	50                   	push   %eax
  8015ad:	68 40 50 80 00       	push   $0x805040
  8015b2:	e8 71 0b 00 00       	call   802128 <find_block>
  8015b7:	83 c4 10             	add    $0x10,%esp
  8015ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(free_block!=NULL)
  8015bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8015c1:	0f 84 a6 00 00 00    	je     80166d <free+0xcd>
	{
		sys_free_user_mem(free_block->sva,free_block->size);
  8015c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015ca:	8b 50 0c             	mov    0xc(%eax),%edx
  8015cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015d0:	8b 40 08             	mov    0x8(%eax),%eax
  8015d3:	83 ec 08             	sub    $0x8,%esp
  8015d6:	52                   	push   %edx
  8015d7:	50                   	push   %eax
  8015d8:	e8 b0 03 00 00       	call   80198d <sys_free_user_mem>
  8015dd:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,free_block);
  8015e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8015e4:	75 14                	jne    8015fa <free+0x5a>
  8015e6:	83 ec 04             	sub    $0x4,%esp
  8015e9:	68 95 3f 80 00       	push   $0x803f95
  8015ee:	6a 74                	push   $0x74
  8015f0:	68 b3 3f 80 00       	push   $0x803fb3
  8015f5:	e8 ef ec ff ff       	call   8002e9 <_panic>
  8015fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015fd:	8b 00                	mov    (%eax),%eax
  8015ff:	85 c0                	test   %eax,%eax
  801601:	74 10                	je     801613 <free+0x73>
  801603:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801606:	8b 00                	mov    (%eax),%eax
  801608:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80160b:	8b 52 04             	mov    0x4(%edx),%edx
  80160e:	89 50 04             	mov    %edx,0x4(%eax)
  801611:	eb 0b                	jmp    80161e <free+0x7e>
  801613:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801616:	8b 40 04             	mov    0x4(%eax),%eax
  801619:	a3 44 50 80 00       	mov    %eax,0x805044
  80161e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801621:	8b 40 04             	mov    0x4(%eax),%eax
  801624:	85 c0                	test   %eax,%eax
  801626:	74 0f                	je     801637 <free+0x97>
  801628:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80162b:	8b 40 04             	mov    0x4(%eax),%eax
  80162e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801631:	8b 12                	mov    (%edx),%edx
  801633:	89 10                	mov    %edx,(%eax)
  801635:	eb 0a                	jmp    801641 <free+0xa1>
  801637:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80163a:	8b 00                	mov    (%eax),%eax
  80163c:	a3 40 50 80 00       	mov    %eax,0x805040
  801641:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801644:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80164a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80164d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801654:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801659:	48                   	dec    %eax
  80165a:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(free_block);
  80165f:	83 ec 0c             	sub    $0xc,%esp
  801662:	ff 75 f4             	pushl  -0xc(%ebp)
  801665:	e8 4e 17 00 00       	call   802db8 <insert_sorted_with_merge_freeList>
  80166a:	83 c4 10             	add    $0x10,%esp
	}

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  80166d:	90                   	nop
  80166e:	c9                   	leave  
  80166f:	c3                   	ret    

00801670 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801670:	55                   	push   %ebp
  801671:	89 e5                	mov    %esp,%ebp
  801673:	83 ec 38             	sub    $0x38,%esp
  801676:	8b 45 10             	mov    0x10(%ebp),%eax
  801679:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80167c:	e8 a6 fc ff ff       	call   801327 <InitializeUHeap>
	if (size == 0) return NULL ;
  801681:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801685:	75 0a                	jne    801691 <smalloc+0x21>
  801687:	b8 00 00 00 00       	mov    $0x0,%eax
  80168c:	e9 8b 00 00 00       	jmp    80171c <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801691:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801698:	8b 55 0c             	mov    0xc(%ebp),%edx
  80169b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80169e:	01 d0                	add    %edx,%eax
  8016a0:	48                   	dec    %eax
  8016a1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8016a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8016ac:	f7 75 f0             	divl   -0x10(%ebp)
  8016af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016b2:	29 d0                	sub    %edx,%eax
  8016b4:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  8016b7:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8016be:	e8 d0 06 00 00       	call   801d93 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016c3:	85 c0                	test   %eax,%eax
  8016c5:	74 11                	je     8016d8 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  8016c7:	83 ec 0c             	sub    $0xc,%esp
  8016ca:	ff 75 e8             	pushl  -0x18(%ebp)
  8016cd:	e8 3b 0d 00 00       	call   80240d <alloc_block_FF>
  8016d2:	83 c4 10             	add    $0x10,%esp
  8016d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  8016d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8016dc:	74 39                	je     801717 <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8016de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016e1:	8b 40 08             	mov    0x8(%eax),%eax
  8016e4:	89 c2                	mov    %eax,%edx
  8016e6:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8016ea:	52                   	push   %edx
  8016eb:	50                   	push   %eax
  8016ec:	ff 75 0c             	pushl  0xc(%ebp)
  8016ef:	ff 75 08             	pushl  0x8(%ebp)
  8016f2:	e8 21 04 00 00       	call   801b18 <sys_createSharedObject>
  8016f7:	83 c4 10             	add    $0x10,%esp
  8016fa:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  8016fd:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  801701:	74 14                	je     801717 <smalloc+0xa7>
  801703:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  801707:	74 0e                	je     801717 <smalloc+0xa7>
  801709:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  80170d:	74 08                	je     801717 <smalloc+0xa7>
			return (void*) mem_block->sva;
  80170f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801712:	8b 40 08             	mov    0x8(%eax),%eax
  801715:	eb 05                	jmp    80171c <smalloc+0xac>
	}
	return NULL;
  801717:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80171c:	c9                   	leave  
  80171d:	c3                   	ret    

0080171e <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80171e:	55                   	push   %ebp
  80171f:	89 e5                	mov    %esp,%ebp
  801721:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801724:	e8 fe fb ff ff       	call   801327 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801729:	83 ec 08             	sub    $0x8,%esp
  80172c:	ff 75 0c             	pushl  0xc(%ebp)
  80172f:	ff 75 08             	pushl  0x8(%ebp)
  801732:	e8 0b 04 00 00       	call   801b42 <sys_getSizeOfSharedObject>
  801737:	83 c4 10             	add    $0x10,%esp
  80173a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  80173d:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  801741:	74 76                	je     8017b9 <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801743:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80174a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80174d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801750:	01 d0                	add    %edx,%eax
  801752:	48                   	dec    %eax
  801753:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801756:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801759:	ba 00 00 00 00       	mov    $0x0,%edx
  80175e:	f7 75 ec             	divl   -0x14(%ebp)
  801761:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801764:	29 d0                	sub    %edx,%eax
  801766:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  801769:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801770:	e8 1e 06 00 00       	call   801d93 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801775:	85 c0                	test   %eax,%eax
  801777:	74 11                	je     80178a <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  801779:	83 ec 0c             	sub    $0xc,%esp
  80177c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80177f:	e8 89 0c 00 00       	call   80240d <alloc_block_FF>
  801784:	83 c4 10             	add    $0x10,%esp
  801787:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  80178a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80178e:	74 29                	je     8017b9 <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  801790:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801793:	8b 40 08             	mov    0x8(%eax),%eax
  801796:	83 ec 04             	sub    $0x4,%esp
  801799:	50                   	push   %eax
  80179a:	ff 75 0c             	pushl  0xc(%ebp)
  80179d:	ff 75 08             	pushl  0x8(%ebp)
  8017a0:	e8 ba 03 00 00       	call   801b5f <sys_getSharedObject>
  8017a5:	83 c4 10             	add    $0x10,%esp
  8017a8:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  8017ab:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  8017af:	74 08                	je     8017b9 <sget+0x9b>
				return (void *)mem_block->sva;
  8017b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017b4:	8b 40 08             	mov    0x8(%eax),%eax
  8017b7:	eb 05                	jmp    8017be <sget+0xa0>
		}
	}
	return NULL;
  8017b9:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8017be:	c9                   	leave  
  8017bf:	c3                   	ret    

008017c0 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8017c0:	55                   	push   %ebp
  8017c1:	89 e5                	mov    %esp,%ebp
  8017c3:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017c6:	e8 5c fb ff ff       	call   801327 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8017cb:	83 ec 04             	sub    $0x4,%esp
  8017ce:	68 e4 3f 80 00       	push   $0x803fe4
  8017d3:	68 f7 00 00 00       	push   $0xf7
  8017d8:	68 b3 3f 80 00       	push   $0x803fb3
  8017dd:	e8 07 eb ff ff       	call   8002e9 <_panic>

008017e2 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8017e2:	55                   	push   %ebp
  8017e3:	89 e5                	mov    %esp,%ebp
  8017e5:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8017e8:	83 ec 04             	sub    $0x4,%esp
  8017eb:	68 0c 40 80 00       	push   $0x80400c
  8017f0:	68 0b 01 00 00       	push   $0x10b
  8017f5:	68 b3 3f 80 00       	push   $0x803fb3
  8017fa:	e8 ea ea ff ff       	call   8002e9 <_panic>

008017ff <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8017ff:	55                   	push   %ebp
  801800:	89 e5                	mov    %esp,%ebp
  801802:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801805:	83 ec 04             	sub    $0x4,%esp
  801808:	68 30 40 80 00       	push   $0x804030
  80180d:	68 16 01 00 00       	push   $0x116
  801812:	68 b3 3f 80 00       	push   $0x803fb3
  801817:	e8 cd ea ff ff       	call   8002e9 <_panic>

0080181c <shrink>:

}
void shrink(uint32 newSize)
{
  80181c:	55                   	push   %ebp
  80181d:	89 e5                	mov    %esp,%ebp
  80181f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801822:	83 ec 04             	sub    $0x4,%esp
  801825:	68 30 40 80 00       	push   $0x804030
  80182a:	68 1b 01 00 00       	push   $0x11b
  80182f:	68 b3 3f 80 00       	push   $0x803fb3
  801834:	e8 b0 ea ff ff       	call   8002e9 <_panic>

00801839 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801839:	55                   	push   %ebp
  80183a:	89 e5                	mov    %esp,%ebp
  80183c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80183f:	83 ec 04             	sub    $0x4,%esp
  801842:	68 30 40 80 00       	push   $0x804030
  801847:	68 20 01 00 00       	push   $0x120
  80184c:	68 b3 3f 80 00       	push   $0x803fb3
  801851:	e8 93 ea ff ff       	call   8002e9 <_panic>

00801856 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801856:	55                   	push   %ebp
  801857:	89 e5                	mov    %esp,%ebp
  801859:	57                   	push   %edi
  80185a:	56                   	push   %esi
  80185b:	53                   	push   %ebx
  80185c:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80185f:	8b 45 08             	mov    0x8(%ebp),%eax
  801862:	8b 55 0c             	mov    0xc(%ebp),%edx
  801865:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801868:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80186b:	8b 7d 18             	mov    0x18(%ebp),%edi
  80186e:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801871:	cd 30                	int    $0x30
  801873:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801876:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801879:	83 c4 10             	add    $0x10,%esp
  80187c:	5b                   	pop    %ebx
  80187d:	5e                   	pop    %esi
  80187e:	5f                   	pop    %edi
  80187f:	5d                   	pop    %ebp
  801880:	c3                   	ret    

00801881 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801881:	55                   	push   %ebp
  801882:	89 e5                	mov    %esp,%ebp
  801884:	83 ec 04             	sub    $0x4,%esp
  801887:	8b 45 10             	mov    0x10(%ebp),%eax
  80188a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80188d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801891:	8b 45 08             	mov    0x8(%ebp),%eax
  801894:	6a 00                	push   $0x0
  801896:	6a 00                	push   $0x0
  801898:	52                   	push   %edx
  801899:	ff 75 0c             	pushl  0xc(%ebp)
  80189c:	50                   	push   %eax
  80189d:	6a 00                	push   $0x0
  80189f:	e8 b2 ff ff ff       	call   801856 <syscall>
  8018a4:	83 c4 18             	add    $0x18,%esp
}
  8018a7:	90                   	nop
  8018a8:	c9                   	leave  
  8018a9:	c3                   	ret    

008018aa <sys_cgetc>:

int
sys_cgetc(void)
{
  8018aa:	55                   	push   %ebp
  8018ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8018ad:	6a 00                	push   $0x0
  8018af:	6a 00                	push   $0x0
  8018b1:	6a 00                	push   $0x0
  8018b3:	6a 00                	push   $0x0
  8018b5:	6a 00                	push   $0x0
  8018b7:	6a 01                	push   $0x1
  8018b9:	e8 98 ff ff ff       	call   801856 <syscall>
  8018be:	83 c4 18             	add    $0x18,%esp
}
  8018c1:	c9                   	leave  
  8018c2:	c3                   	ret    

008018c3 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8018c3:	55                   	push   %ebp
  8018c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8018c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 00                	push   $0x0
  8018d0:	6a 00                	push   $0x0
  8018d2:	52                   	push   %edx
  8018d3:	50                   	push   %eax
  8018d4:	6a 05                	push   $0x5
  8018d6:	e8 7b ff ff ff       	call   801856 <syscall>
  8018db:	83 c4 18             	add    $0x18,%esp
}
  8018de:	c9                   	leave  
  8018df:	c3                   	ret    

008018e0 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018e0:	55                   	push   %ebp
  8018e1:	89 e5                	mov    %esp,%ebp
  8018e3:	56                   	push   %esi
  8018e4:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018e5:	8b 75 18             	mov    0x18(%ebp),%esi
  8018e8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018eb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f4:	56                   	push   %esi
  8018f5:	53                   	push   %ebx
  8018f6:	51                   	push   %ecx
  8018f7:	52                   	push   %edx
  8018f8:	50                   	push   %eax
  8018f9:	6a 06                	push   $0x6
  8018fb:	e8 56 ff ff ff       	call   801856 <syscall>
  801900:	83 c4 18             	add    $0x18,%esp
}
  801903:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801906:	5b                   	pop    %ebx
  801907:	5e                   	pop    %esi
  801908:	5d                   	pop    %ebp
  801909:	c3                   	ret    

0080190a <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80190a:	55                   	push   %ebp
  80190b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80190d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801910:	8b 45 08             	mov    0x8(%ebp),%eax
  801913:	6a 00                	push   $0x0
  801915:	6a 00                	push   $0x0
  801917:	6a 00                	push   $0x0
  801919:	52                   	push   %edx
  80191a:	50                   	push   %eax
  80191b:	6a 07                	push   $0x7
  80191d:	e8 34 ff ff ff       	call   801856 <syscall>
  801922:	83 c4 18             	add    $0x18,%esp
}
  801925:	c9                   	leave  
  801926:	c3                   	ret    

00801927 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801927:	55                   	push   %ebp
  801928:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80192a:	6a 00                	push   $0x0
  80192c:	6a 00                	push   $0x0
  80192e:	6a 00                	push   $0x0
  801930:	ff 75 0c             	pushl  0xc(%ebp)
  801933:	ff 75 08             	pushl  0x8(%ebp)
  801936:	6a 08                	push   $0x8
  801938:	e8 19 ff ff ff       	call   801856 <syscall>
  80193d:	83 c4 18             	add    $0x18,%esp
}
  801940:	c9                   	leave  
  801941:	c3                   	ret    

00801942 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801942:	55                   	push   %ebp
  801943:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801945:	6a 00                	push   $0x0
  801947:	6a 00                	push   $0x0
  801949:	6a 00                	push   $0x0
  80194b:	6a 00                	push   $0x0
  80194d:	6a 00                	push   $0x0
  80194f:	6a 09                	push   $0x9
  801951:	e8 00 ff ff ff       	call   801856 <syscall>
  801956:	83 c4 18             	add    $0x18,%esp
}
  801959:	c9                   	leave  
  80195a:	c3                   	ret    

0080195b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80195b:	55                   	push   %ebp
  80195c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80195e:	6a 00                	push   $0x0
  801960:	6a 00                	push   $0x0
  801962:	6a 00                	push   $0x0
  801964:	6a 00                	push   $0x0
  801966:	6a 00                	push   $0x0
  801968:	6a 0a                	push   $0xa
  80196a:	e8 e7 fe ff ff       	call   801856 <syscall>
  80196f:	83 c4 18             	add    $0x18,%esp
}
  801972:	c9                   	leave  
  801973:	c3                   	ret    

00801974 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801974:	55                   	push   %ebp
  801975:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801977:	6a 00                	push   $0x0
  801979:	6a 00                	push   $0x0
  80197b:	6a 00                	push   $0x0
  80197d:	6a 00                	push   $0x0
  80197f:	6a 00                	push   $0x0
  801981:	6a 0b                	push   $0xb
  801983:	e8 ce fe ff ff       	call   801856 <syscall>
  801988:	83 c4 18             	add    $0x18,%esp
}
  80198b:	c9                   	leave  
  80198c:	c3                   	ret    

0080198d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80198d:	55                   	push   %ebp
  80198e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801990:	6a 00                	push   $0x0
  801992:	6a 00                	push   $0x0
  801994:	6a 00                	push   $0x0
  801996:	ff 75 0c             	pushl  0xc(%ebp)
  801999:	ff 75 08             	pushl  0x8(%ebp)
  80199c:	6a 0f                	push   $0xf
  80199e:	e8 b3 fe ff ff       	call   801856 <syscall>
  8019a3:	83 c4 18             	add    $0x18,%esp
	return;
  8019a6:	90                   	nop
}
  8019a7:	c9                   	leave  
  8019a8:	c3                   	ret    

008019a9 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8019a9:	55                   	push   %ebp
  8019aa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 00                	push   $0x0
  8019b0:	6a 00                	push   $0x0
  8019b2:	ff 75 0c             	pushl  0xc(%ebp)
  8019b5:	ff 75 08             	pushl  0x8(%ebp)
  8019b8:	6a 10                	push   $0x10
  8019ba:	e8 97 fe ff ff       	call   801856 <syscall>
  8019bf:	83 c4 18             	add    $0x18,%esp
	return ;
  8019c2:	90                   	nop
}
  8019c3:	c9                   	leave  
  8019c4:	c3                   	ret    

008019c5 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8019c5:	55                   	push   %ebp
  8019c6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	ff 75 10             	pushl  0x10(%ebp)
  8019cf:	ff 75 0c             	pushl  0xc(%ebp)
  8019d2:	ff 75 08             	pushl  0x8(%ebp)
  8019d5:	6a 11                	push   $0x11
  8019d7:	e8 7a fe ff ff       	call   801856 <syscall>
  8019dc:	83 c4 18             	add    $0x18,%esp
	return ;
  8019df:	90                   	nop
}
  8019e0:	c9                   	leave  
  8019e1:	c3                   	ret    

008019e2 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8019e2:	55                   	push   %ebp
  8019e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 0c                	push   $0xc
  8019f1:	e8 60 fe ff ff       	call   801856 <syscall>
  8019f6:	83 c4 18             	add    $0x18,%esp
}
  8019f9:	c9                   	leave  
  8019fa:	c3                   	ret    

008019fb <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8019fb:	55                   	push   %ebp
  8019fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8019fe:	6a 00                	push   $0x0
  801a00:	6a 00                	push   $0x0
  801a02:	6a 00                	push   $0x0
  801a04:	6a 00                	push   $0x0
  801a06:	ff 75 08             	pushl  0x8(%ebp)
  801a09:	6a 0d                	push   $0xd
  801a0b:	e8 46 fe ff ff       	call   801856 <syscall>
  801a10:	83 c4 18             	add    $0x18,%esp
}
  801a13:	c9                   	leave  
  801a14:	c3                   	ret    

00801a15 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a15:	55                   	push   %ebp
  801a16:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 00                	push   $0x0
  801a1c:	6a 00                	push   $0x0
  801a1e:	6a 00                	push   $0x0
  801a20:	6a 00                	push   $0x0
  801a22:	6a 0e                	push   $0xe
  801a24:	e8 2d fe ff ff       	call   801856 <syscall>
  801a29:	83 c4 18             	add    $0x18,%esp
}
  801a2c:	90                   	nop
  801a2d:	c9                   	leave  
  801a2e:	c3                   	ret    

00801a2f <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a2f:	55                   	push   %ebp
  801a30:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a32:	6a 00                	push   $0x0
  801a34:	6a 00                	push   $0x0
  801a36:	6a 00                	push   $0x0
  801a38:	6a 00                	push   $0x0
  801a3a:	6a 00                	push   $0x0
  801a3c:	6a 13                	push   $0x13
  801a3e:	e8 13 fe ff ff       	call   801856 <syscall>
  801a43:	83 c4 18             	add    $0x18,%esp
}
  801a46:	90                   	nop
  801a47:	c9                   	leave  
  801a48:	c3                   	ret    

00801a49 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a49:	55                   	push   %ebp
  801a4a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a4c:	6a 00                	push   $0x0
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 00                	push   $0x0
  801a52:	6a 00                	push   $0x0
  801a54:	6a 00                	push   $0x0
  801a56:	6a 14                	push   $0x14
  801a58:	e8 f9 fd ff ff       	call   801856 <syscall>
  801a5d:	83 c4 18             	add    $0x18,%esp
}
  801a60:	90                   	nop
  801a61:	c9                   	leave  
  801a62:	c3                   	ret    

00801a63 <sys_cputc>:


void
sys_cputc(const char c)
{
  801a63:	55                   	push   %ebp
  801a64:	89 e5                	mov    %esp,%ebp
  801a66:	83 ec 04             	sub    $0x4,%esp
  801a69:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a6f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a73:	6a 00                	push   $0x0
  801a75:	6a 00                	push   $0x0
  801a77:	6a 00                	push   $0x0
  801a79:	6a 00                	push   $0x0
  801a7b:	50                   	push   %eax
  801a7c:	6a 15                	push   $0x15
  801a7e:	e8 d3 fd ff ff       	call   801856 <syscall>
  801a83:	83 c4 18             	add    $0x18,%esp
}
  801a86:	90                   	nop
  801a87:	c9                   	leave  
  801a88:	c3                   	ret    

00801a89 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a89:	55                   	push   %ebp
  801a8a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 00                	push   $0x0
  801a92:	6a 00                	push   $0x0
  801a94:	6a 00                	push   $0x0
  801a96:	6a 16                	push   $0x16
  801a98:	e8 b9 fd ff ff       	call   801856 <syscall>
  801a9d:	83 c4 18             	add    $0x18,%esp
}
  801aa0:	90                   	nop
  801aa1:	c9                   	leave  
  801aa2:	c3                   	ret    

00801aa3 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801aa3:	55                   	push   %ebp
  801aa4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 00                	push   $0x0
  801aad:	6a 00                	push   $0x0
  801aaf:	ff 75 0c             	pushl  0xc(%ebp)
  801ab2:	50                   	push   %eax
  801ab3:	6a 17                	push   $0x17
  801ab5:	e8 9c fd ff ff       	call   801856 <syscall>
  801aba:	83 c4 18             	add    $0x18,%esp
}
  801abd:	c9                   	leave  
  801abe:	c3                   	ret    

00801abf <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801abf:	55                   	push   %ebp
  801ac0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ac2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ac5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac8:	6a 00                	push   $0x0
  801aca:	6a 00                	push   $0x0
  801acc:	6a 00                	push   $0x0
  801ace:	52                   	push   %edx
  801acf:	50                   	push   %eax
  801ad0:	6a 1a                	push   $0x1a
  801ad2:	e8 7f fd ff ff       	call   801856 <syscall>
  801ad7:	83 c4 18             	add    $0x18,%esp
}
  801ada:	c9                   	leave  
  801adb:	c3                   	ret    

00801adc <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801adc:	55                   	push   %ebp
  801add:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801adf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 00                	push   $0x0
  801ae9:	6a 00                	push   $0x0
  801aeb:	52                   	push   %edx
  801aec:	50                   	push   %eax
  801aed:	6a 18                	push   $0x18
  801aef:	e8 62 fd ff ff       	call   801856 <syscall>
  801af4:	83 c4 18             	add    $0x18,%esp
}
  801af7:	90                   	nop
  801af8:	c9                   	leave  
  801af9:	c3                   	ret    

00801afa <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801afa:	55                   	push   %ebp
  801afb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801afd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b00:	8b 45 08             	mov    0x8(%ebp),%eax
  801b03:	6a 00                	push   $0x0
  801b05:	6a 00                	push   $0x0
  801b07:	6a 00                	push   $0x0
  801b09:	52                   	push   %edx
  801b0a:	50                   	push   %eax
  801b0b:	6a 19                	push   $0x19
  801b0d:	e8 44 fd ff ff       	call   801856 <syscall>
  801b12:	83 c4 18             	add    $0x18,%esp
}
  801b15:	90                   	nop
  801b16:	c9                   	leave  
  801b17:	c3                   	ret    

00801b18 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b18:	55                   	push   %ebp
  801b19:	89 e5                	mov    %esp,%ebp
  801b1b:	83 ec 04             	sub    $0x4,%esp
  801b1e:	8b 45 10             	mov    0x10(%ebp),%eax
  801b21:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b24:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b27:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2e:	6a 00                	push   $0x0
  801b30:	51                   	push   %ecx
  801b31:	52                   	push   %edx
  801b32:	ff 75 0c             	pushl  0xc(%ebp)
  801b35:	50                   	push   %eax
  801b36:	6a 1b                	push   $0x1b
  801b38:	e8 19 fd ff ff       	call   801856 <syscall>
  801b3d:	83 c4 18             	add    $0x18,%esp
}
  801b40:	c9                   	leave  
  801b41:	c3                   	ret    

00801b42 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b42:	55                   	push   %ebp
  801b43:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b45:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b48:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 00                	push   $0x0
  801b4f:	6a 00                	push   $0x0
  801b51:	52                   	push   %edx
  801b52:	50                   	push   %eax
  801b53:	6a 1c                	push   $0x1c
  801b55:	e8 fc fc ff ff       	call   801856 <syscall>
  801b5a:	83 c4 18             	add    $0x18,%esp
}
  801b5d:	c9                   	leave  
  801b5e:	c3                   	ret    

00801b5f <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b5f:	55                   	push   %ebp
  801b60:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b62:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b65:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b68:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 00                	push   $0x0
  801b6f:	51                   	push   %ecx
  801b70:	52                   	push   %edx
  801b71:	50                   	push   %eax
  801b72:	6a 1d                	push   $0x1d
  801b74:	e8 dd fc ff ff       	call   801856 <syscall>
  801b79:	83 c4 18             	add    $0x18,%esp
}
  801b7c:	c9                   	leave  
  801b7d:	c3                   	ret    

00801b7e <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b7e:	55                   	push   %ebp
  801b7f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b81:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b84:	8b 45 08             	mov    0x8(%ebp),%eax
  801b87:	6a 00                	push   $0x0
  801b89:	6a 00                	push   $0x0
  801b8b:	6a 00                	push   $0x0
  801b8d:	52                   	push   %edx
  801b8e:	50                   	push   %eax
  801b8f:	6a 1e                	push   $0x1e
  801b91:	e8 c0 fc ff ff       	call   801856 <syscall>
  801b96:	83 c4 18             	add    $0x18,%esp
}
  801b99:	c9                   	leave  
  801b9a:	c3                   	ret    

00801b9b <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b9b:	55                   	push   %ebp
  801b9c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b9e:	6a 00                	push   $0x0
  801ba0:	6a 00                	push   $0x0
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 00                	push   $0x0
  801ba6:	6a 00                	push   $0x0
  801ba8:	6a 1f                	push   $0x1f
  801baa:	e8 a7 fc ff ff       	call   801856 <syscall>
  801baf:	83 c4 18             	add    $0x18,%esp
}
  801bb2:	c9                   	leave  
  801bb3:	c3                   	ret    

00801bb4 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801bb4:	55                   	push   %ebp
  801bb5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bba:	6a 00                	push   $0x0
  801bbc:	ff 75 14             	pushl  0x14(%ebp)
  801bbf:	ff 75 10             	pushl  0x10(%ebp)
  801bc2:	ff 75 0c             	pushl  0xc(%ebp)
  801bc5:	50                   	push   %eax
  801bc6:	6a 20                	push   $0x20
  801bc8:	e8 89 fc ff ff       	call   801856 <syscall>
  801bcd:	83 c4 18             	add    $0x18,%esp
}
  801bd0:	c9                   	leave  
  801bd1:	c3                   	ret    

00801bd2 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801bd2:	55                   	push   %ebp
  801bd3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 00                	push   $0x0
  801be0:	50                   	push   %eax
  801be1:	6a 21                	push   $0x21
  801be3:	e8 6e fc ff ff       	call   801856 <syscall>
  801be8:	83 c4 18             	add    $0x18,%esp
}
  801beb:	90                   	nop
  801bec:	c9                   	leave  
  801bed:	c3                   	ret    

00801bee <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801bee:	55                   	push   %ebp
  801bef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf4:	6a 00                	push   $0x0
  801bf6:	6a 00                	push   $0x0
  801bf8:	6a 00                	push   $0x0
  801bfa:	6a 00                	push   $0x0
  801bfc:	50                   	push   %eax
  801bfd:	6a 22                	push   $0x22
  801bff:	e8 52 fc ff ff       	call   801856 <syscall>
  801c04:	83 c4 18             	add    $0x18,%esp
}
  801c07:	c9                   	leave  
  801c08:	c3                   	ret    

00801c09 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c09:	55                   	push   %ebp
  801c0a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c0c:	6a 00                	push   $0x0
  801c0e:	6a 00                	push   $0x0
  801c10:	6a 00                	push   $0x0
  801c12:	6a 00                	push   $0x0
  801c14:	6a 00                	push   $0x0
  801c16:	6a 02                	push   $0x2
  801c18:	e8 39 fc ff ff       	call   801856 <syscall>
  801c1d:	83 c4 18             	add    $0x18,%esp
}
  801c20:	c9                   	leave  
  801c21:	c3                   	ret    

00801c22 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c22:	55                   	push   %ebp
  801c23:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c25:	6a 00                	push   $0x0
  801c27:	6a 00                	push   $0x0
  801c29:	6a 00                	push   $0x0
  801c2b:	6a 00                	push   $0x0
  801c2d:	6a 00                	push   $0x0
  801c2f:	6a 03                	push   $0x3
  801c31:	e8 20 fc ff ff       	call   801856 <syscall>
  801c36:	83 c4 18             	add    $0x18,%esp
}
  801c39:	c9                   	leave  
  801c3a:	c3                   	ret    

00801c3b <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c3b:	55                   	push   %ebp
  801c3c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 00                	push   $0x0
  801c42:	6a 00                	push   $0x0
  801c44:	6a 00                	push   $0x0
  801c46:	6a 00                	push   $0x0
  801c48:	6a 04                	push   $0x4
  801c4a:	e8 07 fc ff ff       	call   801856 <syscall>
  801c4f:	83 c4 18             	add    $0x18,%esp
}
  801c52:	c9                   	leave  
  801c53:	c3                   	ret    

00801c54 <sys_exit_env>:


void sys_exit_env(void)
{
  801c54:	55                   	push   %ebp
  801c55:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c57:	6a 00                	push   $0x0
  801c59:	6a 00                	push   $0x0
  801c5b:	6a 00                	push   $0x0
  801c5d:	6a 00                	push   $0x0
  801c5f:	6a 00                	push   $0x0
  801c61:	6a 23                	push   $0x23
  801c63:	e8 ee fb ff ff       	call   801856 <syscall>
  801c68:	83 c4 18             	add    $0x18,%esp
}
  801c6b:	90                   	nop
  801c6c:	c9                   	leave  
  801c6d:	c3                   	ret    

00801c6e <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c6e:	55                   	push   %ebp
  801c6f:	89 e5                	mov    %esp,%ebp
  801c71:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c74:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c77:	8d 50 04             	lea    0x4(%eax),%edx
  801c7a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c7d:	6a 00                	push   $0x0
  801c7f:	6a 00                	push   $0x0
  801c81:	6a 00                	push   $0x0
  801c83:	52                   	push   %edx
  801c84:	50                   	push   %eax
  801c85:	6a 24                	push   $0x24
  801c87:	e8 ca fb ff ff       	call   801856 <syscall>
  801c8c:	83 c4 18             	add    $0x18,%esp
	return result;
  801c8f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c92:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c95:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c98:	89 01                	mov    %eax,(%ecx)
  801c9a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca0:	c9                   	leave  
  801ca1:	c2 04 00             	ret    $0x4

00801ca4 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801ca4:	55                   	push   %ebp
  801ca5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801ca7:	6a 00                	push   $0x0
  801ca9:	6a 00                	push   $0x0
  801cab:	ff 75 10             	pushl  0x10(%ebp)
  801cae:	ff 75 0c             	pushl  0xc(%ebp)
  801cb1:	ff 75 08             	pushl  0x8(%ebp)
  801cb4:	6a 12                	push   $0x12
  801cb6:	e8 9b fb ff ff       	call   801856 <syscall>
  801cbb:	83 c4 18             	add    $0x18,%esp
	return ;
  801cbe:	90                   	nop
}
  801cbf:	c9                   	leave  
  801cc0:	c3                   	ret    

00801cc1 <sys_rcr2>:
uint32 sys_rcr2()
{
  801cc1:	55                   	push   %ebp
  801cc2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801cc4:	6a 00                	push   $0x0
  801cc6:	6a 00                	push   $0x0
  801cc8:	6a 00                	push   $0x0
  801cca:	6a 00                	push   $0x0
  801ccc:	6a 00                	push   $0x0
  801cce:	6a 25                	push   $0x25
  801cd0:	e8 81 fb ff ff       	call   801856 <syscall>
  801cd5:	83 c4 18             	add    $0x18,%esp
}
  801cd8:	c9                   	leave  
  801cd9:	c3                   	ret    

00801cda <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801cda:	55                   	push   %ebp
  801cdb:	89 e5                	mov    %esp,%ebp
  801cdd:	83 ec 04             	sub    $0x4,%esp
  801ce0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ce6:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801cea:	6a 00                	push   $0x0
  801cec:	6a 00                	push   $0x0
  801cee:	6a 00                	push   $0x0
  801cf0:	6a 00                	push   $0x0
  801cf2:	50                   	push   %eax
  801cf3:	6a 26                	push   $0x26
  801cf5:	e8 5c fb ff ff       	call   801856 <syscall>
  801cfa:	83 c4 18             	add    $0x18,%esp
	return ;
  801cfd:	90                   	nop
}
  801cfe:	c9                   	leave  
  801cff:	c3                   	ret    

00801d00 <rsttst>:
void rsttst()
{
  801d00:	55                   	push   %ebp
  801d01:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d03:	6a 00                	push   $0x0
  801d05:	6a 00                	push   $0x0
  801d07:	6a 00                	push   $0x0
  801d09:	6a 00                	push   $0x0
  801d0b:	6a 00                	push   $0x0
  801d0d:	6a 28                	push   $0x28
  801d0f:	e8 42 fb ff ff       	call   801856 <syscall>
  801d14:	83 c4 18             	add    $0x18,%esp
	return ;
  801d17:	90                   	nop
}
  801d18:	c9                   	leave  
  801d19:	c3                   	ret    

00801d1a <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d1a:	55                   	push   %ebp
  801d1b:	89 e5                	mov    %esp,%ebp
  801d1d:	83 ec 04             	sub    $0x4,%esp
  801d20:	8b 45 14             	mov    0x14(%ebp),%eax
  801d23:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d26:	8b 55 18             	mov    0x18(%ebp),%edx
  801d29:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d2d:	52                   	push   %edx
  801d2e:	50                   	push   %eax
  801d2f:	ff 75 10             	pushl  0x10(%ebp)
  801d32:	ff 75 0c             	pushl  0xc(%ebp)
  801d35:	ff 75 08             	pushl  0x8(%ebp)
  801d38:	6a 27                	push   $0x27
  801d3a:	e8 17 fb ff ff       	call   801856 <syscall>
  801d3f:	83 c4 18             	add    $0x18,%esp
	return ;
  801d42:	90                   	nop
}
  801d43:	c9                   	leave  
  801d44:	c3                   	ret    

00801d45 <chktst>:
void chktst(uint32 n)
{
  801d45:	55                   	push   %ebp
  801d46:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 00                	push   $0x0
  801d4e:	6a 00                	push   $0x0
  801d50:	ff 75 08             	pushl  0x8(%ebp)
  801d53:	6a 29                	push   $0x29
  801d55:	e8 fc fa ff ff       	call   801856 <syscall>
  801d5a:	83 c4 18             	add    $0x18,%esp
	return ;
  801d5d:	90                   	nop
}
  801d5e:	c9                   	leave  
  801d5f:	c3                   	ret    

00801d60 <inctst>:

void inctst()
{
  801d60:	55                   	push   %ebp
  801d61:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d63:	6a 00                	push   $0x0
  801d65:	6a 00                	push   $0x0
  801d67:	6a 00                	push   $0x0
  801d69:	6a 00                	push   $0x0
  801d6b:	6a 00                	push   $0x0
  801d6d:	6a 2a                	push   $0x2a
  801d6f:	e8 e2 fa ff ff       	call   801856 <syscall>
  801d74:	83 c4 18             	add    $0x18,%esp
	return ;
  801d77:	90                   	nop
}
  801d78:	c9                   	leave  
  801d79:	c3                   	ret    

00801d7a <gettst>:
uint32 gettst()
{
  801d7a:	55                   	push   %ebp
  801d7b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d7d:	6a 00                	push   $0x0
  801d7f:	6a 00                	push   $0x0
  801d81:	6a 00                	push   $0x0
  801d83:	6a 00                	push   $0x0
  801d85:	6a 00                	push   $0x0
  801d87:	6a 2b                	push   $0x2b
  801d89:	e8 c8 fa ff ff       	call   801856 <syscall>
  801d8e:	83 c4 18             	add    $0x18,%esp
}
  801d91:	c9                   	leave  
  801d92:	c3                   	ret    

00801d93 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d93:	55                   	push   %ebp
  801d94:	89 e5                	mov    %esp,%ebp
  801d96:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d99:	6a 00                	push   $0x0
  801d9b:	6a 00                	push   $0x0
  801d9d:	6a 00                	push   $0x0
  801d9f:	6a 00                	push   $0x0
  801da1:	6a 00                	push   $0x0
  801da3:	6a 2c                	push   $0x2c
  801da5:	e8 ac fa ff ff       	call   801856 <syscall>
  801daa:	83 c4 18             	add    $0x18,%esp
  801dad:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801db0:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801db4:	75 07                	jne    801dbd <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801db6:	b8 01 00 00 00       	mov    $0x1,%eax
  801dbb:	eb 05                	jmp    801dc2 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801dbd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dc2:	c9                   	leave  
  801dc3:	c3                   	ret    

00801dc4 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801dc4:	55                   	push   %ebp
  801dc5:	89 e5                	mov    %esp,%ebp
  801dc7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dca:	6a 00                	push   $0x0
  801dcc:	6a 00                	push   $0x0
  801dce:	6a 00                	push   $0x0
  801dd0:	6a 00                	push   $0x0
  801dd2:	6a 00                	push   $0x0
  801dd4:	6a 2c                	push   $0x2c
  801dd6:	e8 7b fa ff ff       	call   801856 <syscall>
  801ddb:	83 c4 18             	add    $0x18,%esp
  801dde:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801de1:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801de5:	75 07                	jne    801dee <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801de7:	b8 01 00 00 00       	mov    $0x1,%eax
  801dec:	eb 05                	jmp    801df3 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801dee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801df3:	c9                   	leave  
  801df4:	c3                   	ret    

00801df5 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801df5:	55                   	push   %ebp
  801df6:	89 e5                	mov    %esp,%ebp
  801df8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dfb:	6a 00                	push   $0x0
  801dfd:	6a 00                	push   $0x0
  801dff:	6a 00                	push   $0x0
  801e01:	6a 00                	push   $0x0
  801e03:	6a 00                	push   $0x0
  801e05:	6a 2c                	push   $0x2c
  801e07:	e8 4a fa ff ff       	call   801856 <syscall>
  801e0c:	83 c4 18             	add    $0x18,%esp
  801e0f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e12:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e16:	75 07                	jne    801e1f <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e18:	b8 01 00 00 00       	mov    $0x1,%eax
  801e1d:	eb 05                	jmp    801e24 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e1f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e24:	c9                   	leave  
  801e25:	c3                   	ret    

00801e26 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e26:	55                   	push   %ebp
  801e27:	89 e5                	mov    %esp,%ebp
  801e29:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e2c:	6a 00                	push   $0x0
  801e2e:	6a 00                	push   $0x0
  801e30:	6a 00                	push   $0x0
  801e32:	6a 00                	push   $0x0
  801e34:	6a 00                	push   $0x0
  801e36:	6a 2c                	push   $0x2c
  801e38:	e8 19 fa ff ff       	call   801856 <syscall>
  801e3d:	83 c4 18             	add    $0x18,%esp
  801e40:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e43:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e47:	75 07                	jne    801e50 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e49:	b8 01 00 00 00       	mov    $0x1,%eax
  801e4e:	eb 05                	jmp    801e55 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e50:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e55:	c9                   	leave  
  801e56:	c3                   	ret    

00801e57 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e57:	55                   	push   %ebp
  801e58:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e5a:	6a 00                	push   $0x0
  801e5c:	6a 00                	push   $0x0
  801e5e:	6a 00                	push   $0x0
  801e60:	6a 00                	push   $0x0
  801e62:	ff 75 08             	pushl  0x8(%ebp)
  801e65:	6a 2d                	push   $0x2d
  801e67:	e8 ea f9 ff ff       	call   801856 <syscall>
  801e6c:	83 c4 18             	add    $0x18,%esp
	return ;
  801e6f:	90                   	nop
}
  801e70:	c9                   	leave  
  801e71:	c3                   	ret    

00801e72 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e72:	55                   	push   %ebp
  801e73:	89 e5                	mov    %esp,%ebp
  801e75:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e76:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e79:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e7c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e82:	6a 00                	push   $0x0
  801e84:	53                   	push   %ebx
  801e85:	51                   	push   %ecx
  801e86:	52                   	push   %edx
  801e87:	50                   	push   %eax
  801e88:	6a 2e                	push   $0x2e
  801e8a:	e8 c7 f9 ff ff       	call   801856 <syscall>
  801e8f:	83 c4 18             	add    $0x18,%esp
}
  801e92:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e95:	c9                   	leave  
  801e96:	c3                   	ret    

00801e97 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e97:	55                   	push   %ebp
  801e98:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea0:	6a 00                	push   $0x0
  801ea2:	6a 00                	push   $0x0
  801ea4:	6a 00                	push   $0x0
  801ea6:	52                   	push   %edx
  801ea7:	50                   	push   %eax
  801ea8:	6a 2f                	push   $0x2f
  801eaa:	e8 a7 f9 ff ff       	call   801856 <syscall>
  801eaf:	83 c4 18             	add    $0x18,%esp
}
  801eb2:	c9                   	leave  
  801eb3:	c3                   	ret    

00801eb4 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801eb4:	55                   	push   %ebp
  801eb5:	89 e5                	mov    %esp,%ebp
  801eb7:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801eba:	83 ec 0c             	sub    $0xc,%esp
  801ebd:	68 40 40 80 00       	push   $0x804040
  801ec2:	e8 d6 e6 ff ff       	call   80059d <cprintf>
  801ec7:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801eca:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801ed1:	83 ec 0c             	sub    $0xc,%esp
  801ed4:	68 6c 40 80 00       	push   $0x80406c
  801ed9:	e8 bf e6 ff ff       	call   80059d <cprintf>
  801ede:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801ee1:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ee5:	a1 38 51 80 00       	mov    0x805138,%eax
  801eea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801eed:	eb 56                	jmp    801f45 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801eef:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ef3:	74 1c                	je     801f11 <print_mem_block_lists+0x5d>
  801ef5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef8:	8b 50 08             	mov    0x8(%eax),%edx
  801efb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801efe:	8b 48 08             	mov    0x8(%eax),%ecx
  801f01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f04:	8b 40 0c             	mov    0xc(%eax),%eax
  801f07:	01 c8                	add    %ecx,%eax
  801f09:	39 c2                	cmp    %eax,%edx
  801f0b:	73 04                	jae    801f11 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801f0d:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f14:	8b 50 08             	mov    0x8(%eax),%edx
  801f17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f1a:	8b 40 0c             	mov    0xc(%eax),%eax
  801f1d:	01 c2                	add    %eax,%edx
  801f1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f22:	8b 40 08             	mov    0x8(%eax),%eax
  801f25:	83 ec 04             	sub    $0x4,%esp
  801f28:	52                   	push   %edx
  801f29:	50                   	push   %eax
  801f2a:	68 81 40 80 00       	push   $0x804081
  801f2f:	e8 69 e6 ff ff       	call   80059d <cprintf>
  801f34:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f3a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f3d:	a1 40 51 80 00       	mov    0x805140,%eax
  801f42:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f45:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f49:	74 07                	je     801f52 <print_mem_block_lists+0x9e>
  801f4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f4e:	8b 00                	mov    (%eax),%eax
  801f50:	eb 05                	jmp    801f57 <print_mem_block_lists+0xa3>
  801f52:	b8 00 00 00 00       	mov    $0x0,%eax
  801f57:	a3 40 51 80 00       	mov    %eax,0x805140
  801f5c:	a1 40 51 80 00       	mov    0x805140,%eax
  801f61:	85 c0                	test   %eax,%eax
  801f63:	75 8a                	jne    801eef <print_mem_block_lists+0x3b>
  801f65:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f69:	75 84                	jne    801eef <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801f6b:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f6f:	75 10                	jne    801f81 <print_mem_block_lists+0xcd>
  801f71:	83 ec 0c             	sub    $0xc,%esp
  801f74:	68 90 40 80 00       	push   $0x804090
  801f79:	e8 1f e6 ff ff       	call   80059d <cprintf>
  801f7e:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f81:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f88:	83 ec 0c             	sub    $0xc,%esp
  801f8b:	68 b4 40 80 00       	push   $0x8040b4
  801f90:	e8 08 e6 ff ff       	call   80059d <cprintf>
  801f95:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f98:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f9c:	a1 40 50 80 00       	mov    0x805040,%eax
  801fa1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fa4:	eb 56                	jmp    801ffc <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801fa6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801faa:	74 1c                	je     801fc8 <print_mem_block_lists+0x114>
  801fac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801faf:	8b 50 08             	mov    0x8(%eax),%edx
  801fb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fb5:	8b 48 08             	mov    0x8(%eax),%ecx
  801fb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fbb:	8b 40 0c             	mov    0xc(%eax),%eax
  801fbe:	01 c8                	add    %ecx,%eax
  801fc0:	39 c2                	cmp    %eax,%edx
  801fc2:	73 04                	jae    801fc8 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801fc4:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801fc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fcb:	8b 50 08             	mov    0x8(%eax),%edx
  801fce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd1:	8b 40 0c             	mov    0xc(%eax),%eax
  801fd4:	01 c2                	add    %eax,%edx
  801fd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd9:	8b 40 08             	mov    0x8(%eax),%eax
  801fdc:	83 ec 04             	sub    $0x4,%esp
  801fdf:	52                   	push   %edx
  801fe0:	50                   	push   %eax
  801fe1:	68 81 40 80 00       	push   $0x804081
  801fe6:	e8 b2 e5 ff ff       	call   80059d <cprintf>
  801feb:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801fee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801ff4:	a1 48 50 80 00       	mov    0x805048,%eax
  801ff9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ffc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802000:	74 07                	je     802009 <print_mem_block_lists+0x155>
  802002:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802005:	8b 00                	mov    (%eax),%eax
  802007:	eb 05                	jmp    80200e <print_mem_block_lists+0x15a>
  802009:	b8 00 00 00 00       	mov    $0x0,%eax
  80200e:	a3 48 50 80 00       	mov    %eax,0x805048
  802013:	a1 48 50 80 00       	mov    0x805048,%eax
  802018:	85 c0                	test   %eax,%eax
  80201a:	75 8a                	jne    801fa6 <print_mem_block_lists+0xf2>
  80201c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802020:	75 84                	jne    801fa6 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802022:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802026:	75 10                	jne    802038 <print_mem_block_lists+0x184>
  802028:	83 ec 0c             	sub    $0xc,%esp
  80202b:	68 cc 40 80 00       	push   $0x8040cc
  802030:	e8 68 e5 ff ff       	call   80059d <cprintf>
  802035:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802038:	83 ec 0c             	sub    $0xc,%esp
  80203b:	68 40 40 80 00       	push   $0x804040
  802040:	e8 58 e5 ff ff       	call   80059d <cprintf>
  802045:	83 c4 10             	add    $0x10,%esp

}
  802048:	90                   	nop
  802049:	c9                   	leave  
  80204a:	c3                   	ret    

0080204b <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80204b:	55                   	push   %ebp
  80204c:	89 e5                	mov    %esp,%ebp
  80204e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  802051:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802058:	00 00 00 
  80205b:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802062:	00 00 00 
  802065:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  80206c:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  80206f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802076:	e9 9e 00 00 00       	jmp    802119 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  80207b:	a1 50 50 80 00       	mov    0x805050,%eax
  802080:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802083:	c1 e2 04             	shl    $0x4,%edx
  802086:	01 d0                	add    %edx,%eax
  802088:	85 c0                	test   %eax,%eax
  80208a:	75 14                	jne    8020a0 <initialize_MemBlocksList+0x55>
  80208c:	83 ec 04             	sub    $0x4,%esp
  80208f:	68 f4 40 80 00       	push   $0x8040f4
  802094:	6a 46                	push   $0x46
  802096:	68 17 41 80 00       	push   $0x804117
  80209b:	e8 49 e2 ff ff       	call   8002e9 <_panic>
  8020a0:	a1 50 50 80 00       	mov    0x805050,%eax
  8020a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020a8:	c1 e2 04             	shl    $0x4,%edx
  8020ab:	01 d0                	add    %edx,%eax
  8020ad:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8020b3:	89 10                	mov    %edx,(%eax)
  8020b5:	8b 00                	mov    (%eax),%eax
  8020b7:	85 c0                	test   %eax,%eax
  8020b9:	74 18                	je     8020d3 <initialize_MemBlocksList+0x88>
  8020bb:	a1 48 51 80 00       	mov    0x805148,%eax
  8020c0:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8020c6:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8020c9:	c1 e1 04             	shl    $0x4,%ecx
  8020cc:	01 ca                	add    %ecx,%edx
  8020ce:	89 50 04             	mov    %edx,0x4(%eax)
  8020d1:	eb 12                	jmp    8020e5 <initialize_MemBlocksList+0x9a>
  8020d3:	a1 50 50 80 00       	mov    0x805050,%eax
  8020d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020db:	c1 e2 04             	shl    $0x4,%edx
  8020de:	01 d0                	add    %edx,%eax
  8020e0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8020e5:	a1 50 50 80 00       	mov    0x805050,%eax
  8020ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020ed:	c1 e2 04             	shl    $0x4,%edx
  8020f0:	01 d0                	add    %edx,%eax
  8020f2:	a3 48 51 80 00       	mov    %eax,0x805148
  8020f7:	a1 50 50 80 00       	mov    0x805050,%eax
  8020fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020ff:	c1 e2 04             	shl    $0x4,%edx
  802102:	01 d0                	add    %edx,%eax
  802104:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80210b:	a1 54 51 80 00       	mov    0x805154,%eax
  802110:	40                   	inc    %eax
  802111:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802116:	ff 45 f4             	incl   -0xc(%ebp)
  802119:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80211f:	0f 82 56 ff ff ff    	jb     80207b <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802125:	90                   	nop
  802126:	c9                   	leave  
  802127:	c3                   	ret    

00802128 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802128:	55                   	push   %ebp
  802129:	89 e5                	mov    %esp,%ebp
  80212b:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80212e:	8b 45 08             	mov    0x8(%ebp),%eax
  802131:	8b 00                	mov    (%eax),%eax
  802133:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802136:	eb 19                	jmp    802151 <find_block+0x29>
	{
		if(va==point->sva)
  802138:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80213b:	8b 40 08             	mov    0x8(%eax),%eax
  80213e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802141:	75 05                	jne    802148 <find_block+0x20>
		   return point;
  802143:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802146:	eb 36                	jmp    80217e <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802148:	8b 45 08             	mov    0x8(%ebp),%eax
  80214b:	8b 40 08             	mov    0x8(%eax),%eax
  80214e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802151:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802155:	74 07                	je     80215e <find_block+0x36>
  802157:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80215a:	8b 00                	mov    (%eax),%eax
  80215c:	eb 05                	jmp    802163 <find_block+0x3b>
  80215e:	b8 00 00 00 00       	mov    $0x0,%eax
  802163:	8b 55 08             	mov    0x8(%ebp),%edx
  802166:	89 42 08             	mov    %eax,0x8(%edx)
  802169:	8b 45 08             	mov    0x8(%ebp),%eax
  80216c:	8b 40 08             	mov    0x8(%eax),%eax
  80216f:	85 c0                	test   %eax,%eax
  802171:	75 c5                	jne    802138 <find_block+0x10>
  802173:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802177:	75 bf                	jne    802138 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802179:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80217e:	c9                   	leave  
  80217f:	c3                   	ret    

00802180 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802180:	55                   	push   %ebp
  802181:	89 e5                	mov    %esp,%ebp
  802183:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802186:	a1 40 50 80 00       	mov    0x805040,%eax
  80218b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  80218e:	a1 44 50 80 00       	mov    0x805044,%eax
  802193:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802196:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802199:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80219c:	74 24                	je     8021c2 <insert_sorted_allocList+0x42>
  80219e:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a1:	8b 50 08             	mov    0x8(%eax),%edx
  8021a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021a7:	8b 40 08             	mov    0x8(%eax),%eax
  8021aa:	39 c2                	cmp    %eax,%edx
  8021ac:	76 14                	jbe    8021c2 <insert_sorted_allocList+0x42>
  8021ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b1:	8b 50 08             	mov    0x8(%eax),%edx
  8021b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021b7:	8b 40 08             	mov    0x8(%eax),%eax
  8021ba:	39 c2                	cmp    %eax,%edx
  8021bc:	0f 82 60 01 00 00    	jb     802322 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8021c2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021c6:	75 65                	jne    80222d <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8021c8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021cc:	75 14                	jne    8021e2 <insert_sorted_allocList+0x62>
  8021ce:	83 ec 04             	sub    $0x4,%esp
  8021d1:	68 f4 40 80 00       	push   $0x8040f4
  8021d6:	6a 6b                	push   $0x6b
  8021d8:	68 17 41 80 00       	push   $0x804117
  8021dd:	e8 07 e1 ff ff       	call   8002e9 <_panic>
  8021e2:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8021e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021eb:	89 10                	mov    %edx,(%eax)
  8021ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f0:	8b 00                	mov    (%eax),%eax
  8021f2:	85 c0                	test   %eax,%eax
  8021f4:	74 0d                	je     802203 <insert_sorted_allocList+0x83>
  8021f6:	a1 40 50 80 00       	mov    0x805040,%eax
  8021fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8021fe:	89 50 04             	mov    %edx,0x4(%eax)
  802201:	eb 08                	jmp    80220b <insert_sorted_allocList+0x8b>
  802203:	8b 45 08             	mov    0x8(%ebp),%eax
  802206:	a3 44 50 80 00       	mov    %eax,0x805044
  80220b:	8b 45 08             	mov    0x8(%ebp),%eax
  80220e:	a3 40 50 80 00       	mov    %eax,0x805040
  802213:	8b 45 08             	mov    0x8(%ebp),%eax
  802216:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80221d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802222:	40                   	inc    %eax
  802223:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802228:	e9 dc 01 00 00       	jmp    802409 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  80222d:	8b 45 08             	mov    0x8(%ebp),%eax
  802230:	8b 50 08             	mov    0x8(%eax),%edx
  802233:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802236:	8b 40 08             	mov    0x8(%eax),%eax
  802239:	39 c2                	cmp    %eax,%edx
  80223b:	77 6c                	ja     8022a9 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  80223d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802241:	74 06                	je     802249 <insert_sorted_allocList+0xc9>
  802243:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802247:	75 14                	jne    80225d <insert_sorted_allocList+0xdd>
  802249:	83 ec 04             	sub    $0x4,%esp
  80224c:	68 30 41 80 00       	push   $0x804130
  802251:	6a 6f                	push   $0x6f
  802253:	68 17 41 80 00       	push   $0x804117
  802258:	e8 8c e0 ff ff       	call   8002e9 <_panic>
  80225d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802260:	8b 50 04             	mov    0x4(%eax),%edx
  802263:	8b 45 08             	mov    0x8(%ebp),%eax
  802266:	89 50 04             	mov    %edx,0x4(%eax)
  802269:	8b 45 08             	mov    0x8(%ebp),%eax
  80226c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80226f:	89 10                	mov    %edx,(%eax)
  802271:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802274:	8b 40 04             	mov    0x4(%eax),%eax
  802277:	85 c0                	test   %eax,%eax
  802279:	74 0d                	je     802288 <insert_sorted_allocList+0x108>
  80227b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80227e:	8b 40 04             	mov    0x4(%eax),%eax
  802281:	8b 55 08             	mov    0x8(%ebp),%edx
  802284:	89 10                	mov    %edx,(%eax)
  802286:	eb 08                	jmp    802290 <insert_sorted_allocList+0x110>
  802288:	8b 45 08             	mov    0x8(%ebp),%eax
  80228b:	a3 40 50 80 00       	mov    %eax,0x805040
  802290:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802293:	8b 55 08             	mov    0x8(%ebp),%edx
  802296:	89 50 04             	mov    %edx,0x4(%eax)
  802299:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80229e:	40                   	inc    %eax
  80229f:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8022a4:	e9 60 01 00 00       	jmp    802409 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8022a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ac:	8b 50 08             	mov    0x8(%eax),%edx
  8022af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022b2:	8b 40 08             	mov    0x8(%eax),%eax
  8022b5:	39 c2                	cmp    %eax,%edx
  8022b7:	0f 82 4c 01 00 00    	jb     802409 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8022bd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022c1:	75 14                	jne    8022d7 <insert_sorted_allocList+0x157>
  8022c3:	83 ec 04             	sub    $0x4,%esp
  8022c6:	68 68 41 80 00       	push   $0x804168
  8022cb:	6a 73                	push   $0x73
  8022cd:	68 17 41 80 00       	push   $0x804117
  8022d2:	e8 12 e0 ff ff       	call   8002e9 <_panic>
  8022d7:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8022dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e0:	89 50 04             	mov    %edx,0x4(%eax)
  8022e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e6:	8b 40 04             	mov    0x4(%eax),%eax
  8022e9:	85 c0                	test   %eax,%eax
  8022eb:	74 0c                	je     8022f9 <insert_sorted_allocList+0x179>
  8022ed:	a1 44 50 80 00       	mov    0x805044,%eax
  8022f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8022f5:	89 10                	mov    %edx,(%eax)
  8022f7:	eb 08                	jmp    802301 <insert_sorted_allocList+0x181>
  8022f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fc:	a3 40 50 80 00       	mov    %eax,0x805040
  802301:	8b 45 08             	mov    0x8(%ebp),%eax
  802304:	a3 44 50 80 00       	mov    %eax,0x805044
  802309:	8b 45 08             	mov    0x8(%ebp),%eax
  80230c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802312:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802317:	40                   	inc    %eax
  802318:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80231d:	e9 e7 00 00 00       	jmp    802409 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802322:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802325:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802328:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80232f:	a1 40 50 80 00       	mov    0x805040,%eax
  802334:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802337:	e9 9d 00 00 00       	jmp    8023d9 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  80233c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233f:	8b 00                	mov    (%eax),%eax
  802341:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802344:	8b 45 08             	mov    0x8(%ebp),%eax
  802347:	8b 50 08             	mov    0x8(%eax),%edx
  80234a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234d:	8b 40 08             	mov    0x8(%eax),%eax
  802350:	39 c2                	cmp    %eax,%edx
  802352:	76 7d                	jbe    8023d1 <insert_sorted_allocList+0x251>
  802354:	8b 45 08             	mov    0x8(%ebp),%eax
  802357:	8b 50 08             	mov    0x8(%eax),%edx
  80235a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80235d:	8b 40 08             	mov    0x8(%eax),%eax
  802360:	39 c2                	cmp    %eax,%edx
  802362:	73 6d                	jae    8023d1 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802364:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802368:	74 06                	je     802370 <insert_sorted_allocList+0x1f0>
  80236a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80236e:	75 14                	jne    802384 <insert_sorted_allocList+0x204>
  802370:	83 ec 04             	sub    $0x4,%esp
  802373:	68 8c 41 80 00       	push   $0x80418c
  802378:	6a 7f                	push   $0x7f
  80237a:	68 17 41 80 00       	push   $0x804117
  80237f:	e8 65 df ff ff       	call   8002e9 <_panic>
  802384:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802387:	8b 10                	mov    (%eax),%edx
  802389:	8b 45 08             	mov    0x8(%ebp),%eax
  80238c:	89 10                	mov    %edx,(%eax)
  80238e:	8b 45 08             	mov    0x8(%ebp),%eax
  802391:	8b 00                	mov    (%eax),%eax
  802393:	85 c0                	test   %eax,%eax
  802395:	74 0b                	je     8023a2 <insert_sorted_allocList+0x222>
  802397:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239a:	8b 00                	mov    (%eax),%eax
  80239c:	8b 55 08             	mov    0x8(%ebp),%edx
  80239f:	89 50 04             	mov    %edx,0x4(%eax)
  8023a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8023a8:	89 10                	mov    %edx,(%eax)
  8023aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023b0:	89 50 04             	mov    %edx,0x4(%eax)
  8023b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b6:	8b 00                	mov    (%eax),%eax
  8023b8:	85 c0                	test   %eax,%eax
  8023ba:	75 08                	jne    8023c4 <insert_sorted_allocList+0x244>
  8023bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bf:	a3 44 50 80 00       	mov    %eax,0x805044
  8023c4:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8023c9:	40                   	inc    %eax
  8023ca:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8023cf:	eb 39                	jmp    80240a <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8023d1:	a1 48 50 80 00       	mov    0x805048,%eax
  8023d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023dd:	74 07                	je     8023e6 <insert_sorted_allocList+0x266>
  8023df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e2:	8b 00                	mov    (%eax),%eax
  8023e4:	eb 05                	jmp    8023eb <insert_sorted_allocList+0x26b>
  8023e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8023eb:	a3 48 50 80 00       	mov    %eax,0x805048
  8023f0:	a1 48 50 80 00       	mov    0x805048,%eax
  8023f5:	85 c0                	test   %eax,%eax
  8023f7:	0f 85 3f ff ff ff    	jne    80233c <insert_sorted_allocList+0x1bc>
  8023fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802401:	0f 85 35 ff ff ff    	jne    80233c <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802407:	eb 01                	jmp    80240a <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802409:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80240a:	90                   	nop
  80240b:	c9                   	leave  
  80240c:	c3                   	ret    

0080240d <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80240d:	55                   	push   %ebp
  80240e:	89 e5                	mov    %esp,%ebp
  802410:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802413:	a1 38 51 80 00       	mov    0x805138,%eax
  802418:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80241b:	e9 85 01 00 00       	jmp    8025a5 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802420:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802423:	8b 40 0c             	mov    0xc(%eax),%eax
  802426:	3b 45 08             	cmp    0x8(%ebp),%eax
  802429:	0f 82 6e 01 00 00    	jb     80259d <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  80242f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802432:	8b 40 0c             	mov    0xc(%eax),%eax
  802435:	3b 45 08             	cmp    0x8(%ebp),%eax
  802438:	0f 85 8a 00 00 00    	jne    8024c8 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  80243e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802442:	75 17                	jne    80245b <alloc_block_FF+0x4e>
  802444:	83 ec 04             	sub    $0x4,%esp
  802447:	68 c0 41 80 00       	push   $0x8041c0
  80244c:	68 93 00 00 00       	push   $0x93
  802451:	68 17 41 80 00       	push   $0x804117
  802456:	e8 8e de ff ff       	call   8002e9 <_panic>
  80245b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245e:	8b 00                	mov    (%eax),%eax
  802460:	85 c0                	test   %eax,%eax
  802462:	74 10                	je     802474 <alloc_block_FF+0x67>
  802464:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802467:	8b 00                	mov    (%eax),%eax
  802469:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80246c:	8b 52 04             	mov    0x4(%edx),%edx
  80246f:	89 50 04             	mov    %edx,0x4(%eax)
  802472:	eb 0b                	jmp    80247f <alloc_block_FF+0x72>
  802474:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802477:	8b 40 04             	mov    0x4(%eax),%eax
  80247a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80247f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802482:	8b 40 04             	mov    0x4(%eax),%eax
  802485:	85 c0                	test   %eax,%eax
  802487:	74 0f                	je     802498 <alloc_block_FF+0x8b>
  802489:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248c:	8b 40 04             	mov    0x4(%eax),%eax
  80248f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802492:	8b 12                	mov    (%edx),%edx
  802494:	89 10                	mov    %edx,(%eax)
  802496:	eb 0a                	jmp    8024a2 <alloc_block_FF+0x95>
  802498:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249b:	8b 00                	mov    (%eax),%eax
  80249d:	a3 38 51 80 00       	mov    %eax,0x805138
  8024a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024b5:	a1 44 51 80 00       	mov    0x805144,%eax
  8024ba:	48                   	dec    %eax
  8024bb:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  8024c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c3:	e9 10 01 00 00       	jmp    8025d8 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8024c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cb:	8b 40 0c             	mov    0xc(%eax),%eax
  8024ce:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024d1:	0f 86 c6 00 00 00    	jbe    80259d <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8024d7:	a1 48 51 80 00       	mov    0x805148,%eax
  8024dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8024df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e2:	8b 50 08             	mov    0x8(%eax),%edx
  8024e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024e8:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8024eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8024f1:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8024f4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024f8:	75 17                	jne    802511 <alloc_block_FF+0x104>
  8024fa:	83 ec 04             	sub    $0x4,%esp
  8024fd:	68 c0 41 80 00       	push   $0x8041c0
  802502:	68 9b 00 00 00       	push   $0x9b
  802507:	68 17 41 80 00       	push   $0x804117
  80250c:	e8 d8 dd ff ff       	call   8002e9 <_panic>
  802511:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802514:	8b 00                	mov    (%eax),%eax
  802516:	85 c0                	test   %eax,%eax
  802518:	74 10                	je     80252a <alloc_block_FF+0x11d>
  80251a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80251d:	8b 00                	mov    (%eax),%eax
  80251f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802522:	8b 52 04             	mov    0x4(%edx),%edx
  802525:	89 50 04             	mov    %edx,0x4(%eax)
  802528:	eb 0b                	jmp    802535 <alloc_block_FF+0x128>
  80252a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80252d:	8b 40 04             	mov    0x4(%eax),%eax
  802530:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802535:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802538:	8b 40 04             	mov    0x4(%eax),%eax
  80253b:	85 c0                	test   %eax,%eax
  80253d:	74 0f                	je     80254e <alloc_block_FF+0x141>
  80253f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802542:	8b 40 04             	mov    0x4(%eax),%eax
  802545:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802548:	8b 12                	mov    (%edx),%edx
  80254a:	89 10                	mov    %edx,(%eax)
  80254c:	eb 0a                	jmp    802558 <alloc_block_FF+0x14b>
  80254e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802551:	8b 00                	mov    (%eax),%eax
  802553:	a3 48 51 80 00       	mov    %eax,0x805148
  802558:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80255b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802561:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802564:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80256b:	a1 54 51 80 00       	mov    0x805154,%eax
  802570:	48                   	dec    %eax
  802571:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802576:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802579:	8b 50 08             	mov    0x8(%eax),%edx
  80257c:	8b 45 08             	mov    0x8(%ebp),%eax
  80257f:	01 c2                	add    %eax,%edx
  802581:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802584:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802587:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258a:	8b 40 0c             	mov    0xc(%eax),%eax
  80258d:	2b 45 08             	sub    0x8(%ebp),%eax
  802590:	89 c2                	mov    %eax,%edx
  802592:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802595:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802598:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80259b:	eb 3b                	jmp    8025d8 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80259d:	a1 40 51 80 00       	mov    0x805140,%eax
  8025a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025a9:	74 07                	je     8025b2 <alloc_block_FF+0x1a5>
  8025ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ae:	8b 00                	mov    (%eax),%eax
  8025b0:	eb 05                	jmp    8025b7 <alloc_block_FF+0x1aa>
  8025b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8025b7:	a3 40 51 80 00       	mov    %eax,0x805140
  8025bc:	a1 40 51 80 00       	mov    0x805140,%eax
  8025c1:	85 c0                	test   %eax,%eax
  8025c3:	0f 85 57 fe ff ff    	jne    802420 <alloc_block_FF+0x13>
  8025c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025cd:	0f 85 4d fe ff ff    	jne    802420 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8025d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025d8:	c9                   	leave  
  8025d9:	c3                   	ret    

008025da <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8025da:	55                   	push   %ebp
  8025db:	89 e5                	mov    %esp,%ebp
  8025dd:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8025e0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8025e7:	a1 38 51 80 00       	mov    0x805138,%eax
  8025ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025ef:	e9 df 00 00 00       	jmp    8026d3 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8025f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f7:	8b 40 0c             	mov    0xc(%eax),%eax
  8025fa:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025fd:	0f 82 c8 00 00 00    	jb     8026cb <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802603:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802606:	8b 40 0c             	mov    0xc(%eax),%eax
  802609:	3b 45 08             	cmp    0x8(%ebp),%eax
  80260c:	0f 85 8a 00 00 00    	jne    80269c <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802612:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802616:	75 17                	jne    80262f <alloc_block_BF+0x55>
  802618:	83 ec 04             	sub    $0x4,%esp
  80261b:	68 c0 41 80 00       	push   $0x8041c0
  802620:	68 b7 00 00 00       	push   $0xb7
  802625:	68 17 41 80 00       	push   $0x804117
  80262a:	e8 ba dc ff ff       	call   8002e9 <_panic>
  80262f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802632:	8b 00                	mov    (%eax),%eax
  802634:	85 c0                	test   %eax,%eax
  802636:	74 10                	je     802648 <alloc_block_BF+0x6e>
  802638:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263b:	8b 00                	mov    (%eax),%eax
  80263d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802640:	8b 52 04             	mov    0x4(%edx),%edx
  802643:	89 50 04             	mov    %edx,0x4(%eax)
  802646:	eb 0b                	jmp    802653 <alloc_block_BF+0x79>
  802648:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264b:	8b 40 04             	mov    0x4(%eax),%eax
  80264e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802653:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802656:	8b 40 04             	mov    0x4(%eax),%eax
  802659:	85 c0                	test   %eax,%eax
  80265b:	74 0f                	je     80266c <alloc_block_BF+0x92>
  80265d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802660:	8b 40 04             	mov    0x4(%eax),%eax
  802663:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802666:	8b 12                	mov    (%edx),%edx
  802668:	89 10                	mov    %edx,(%eax)
  80266a:	eb 0a                	jmp    802676 <alloc_block_BF+0x9c>
  80266c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266f:	8b 00                	mov    (%eax),%eax
  802671:	a3 38 51 80 00       	mov    %eax,0x805138
  802676:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802679:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80267f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802682:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802689:	a1 44 51 80 00       	mov    0x805144,%eax
  80268e:	48                   	dec    %eax
  80268f:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802694:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802697:	e9 4d 01 00 00       	jmp    8027e9 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  80269c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269f:	8b 40 0c             	mov    0xc(%eax),%eax
  8026a2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026a5:	76 24                	jbe    8026cb <alloc_block_BF+0xf1>
  8026a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026aa:	8b 40 0c             	mov    0xc(%eax),%eax
  8026ad:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8026b0:	73 19                	jae    8026cb <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8026b2:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8026b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8026bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8026c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c5:	8b 40 08             	mov    0x8(%eax),%eax
  8026c8:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8026cb:	a1 40 51 80 00       	mov    0x805140,%eax
  8026d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026d7:	74 07                	je     8026e0 <alloc_block_BF+0x106>
  8026d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026dc:	8b 00                	mov    (%eax),%eax
  8026de:	eb 05                	jmp    8026e5 <alloc_block_BF+0x10b>
  8026e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8026e5:	a3 40 51 80 00       	mov    %eax,0x805140
  8026ea:	a1 40 51 80 00       	mov    0x805140,%eax
  8026ef:	85 c0                	test   %eax,%eax
  8026f1:	0f 85 fd fe ff ff    	jne    8025f4 <alloc_block_BF+0x1a>
  8026f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026fb:	0f 85 f3 fe ff ff    	jne    8025f4 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802701:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802705:	0f 84 d9 00 00 00    	je     8027e4 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  80270b:	a1 48 51 80 00       	mov    0x805148,%eax
  802710:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802713:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802716:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802719:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  80271c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80271f:	8b 55 08             	mov    0x8(%ebp),%edx
  802722:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802725:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802729:	75 17                	jne    802742 <alloc_block_BF+0x168>
  80272b:	83 ec 04             	sub    $0x4,%esp
  80272e:	68 c0 41 80 00       	push   $0x8041c0
  802733:	68 c7 00 00 00       	push   $0xc7
  802738:	68 17 41 80 00       	push   $0x804117
  80273d:	e8 a7 db ff ff       	call   8002e9 <_panic>
  802742:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802745:	8b 00                	mov    (%eax),%eax
  802747:	85 c0                	test   %eax,%eax
  802749:	74 10                	je     80275b <alloc_block_BF+0x181>
  80274b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80274e:	8b 00                	mov    (%eax),%eax
  802750:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802753:	8b 52 04             	mov    0x4(%edx),%edx
  802756:	89 50 04             	mov    %edx,0x4(%eax)
  802759:	eb 0b                	jmp    802766 <alloc_block_BF+0x18c>
  80275b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80275e:	8b 40 04             	mov    0x4(%eax),%eax
  802761:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802766:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802769:	8b 40 04             	mov    0x4(%eax),%eax
  80276c:	85 c0                	test   %eax,%eax
  80276e:	74 0f                	je     80277f <alloc_block_BF+0x1a5>
  802770:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802773:	8b 40 04             	mov    0x4(%eax),%eax
  802776:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802779:	8b 12                	mov    (%edx),%edx
  80277b:	89 10                	mov    %edx,(%eax)
  80277d:	eb 0a                	jmp    802789 <alloc_block_BF+0x1af>
  80277f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802782:	8b 00                	mov    (%eax),%eax
  802784:	a3 48 51 80 00       	mov    %eax,0x805148
  802789:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80278c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802792:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802795:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80279c:	a1 54 51 80 00       	mov    0x805154,%eax
  8027a1:	48                   	dec    %eax
  8027a2:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8027a7:	83 ec 08             	sub    $0x8,%esp
  8027aa:	ff 75 ec             	pushl  -0x14(%ebp)
  8027ad:	68 38 51 80 00       	push   $0x805138
  8027b2:	e8 71 f9 ff ff       	call   802128 <find_block>
  8027b7:	83 c4 10             	add    $0x10,%esp
  8027ba:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8027bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027c0:	8b 50 08             	mov    0x8(%eax),%edx
  8027c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c6:	01 c2                	add    %eax,%edx
  8027c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027cb:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8027ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027d1:	8b 40 0c             	mov    0xc(%eax),%eax
  8027d4:	2b 45 08             	sub    0x8(%ebp),%eax
  8027d7:	89 c2                	mov    %eax,%edx
  8027d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027dc:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8027df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027e2:	eb 05                	jmp    8027e9 <alloc_block_BF+0x20f>
	}
	return NULL;
  8027e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027e9:	c9                   	leave  
  8027ea:	c3                   	ret    

008027eb <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8027eb:	55                   	push   %ebp
  8027ec:	89 e5                	mov    %esp,%ebp
  8027ee:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8027f1:	a1 28 50 80 00       	mov    0x805028,%eax
  8027f6:	85 c0                	test   %eax,%eax
  8027f8:	0f 85 de 01 00 00    	jne    8029dc <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8027fe:	a1 38 51 80 00       	mov    0x805138,%eax
  802803:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802806:	e9 9e 01 00 00       	jmp    8029a9 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  80280b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280e:	8b 40 0c             	mov    0xc(%eax),%eax
  802811:	3b 45 08             	cmp    0x8(%ebp),%eax
  802814:	0f 82 87 01 00 00    	jb     8029a1 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  80281a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281d:	8b 40 0c             	mov    0xc(%eax),%eax
  802820:	3b 45 08             	cmp    0x8(%ebp),%eax
  802823:	0f 85 95 00 00 00    	jne    8028be <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802829:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80282d:	75 17                	jne    802846 <alloc_block_NF+0x5b>
  80282f:	83 ec 04             	sub    $0x4,%esp
  802832:	68 c0 41 80 00       	push   $0x8041c0
  802837:	68 e0 00 00 00       	push   $0xe0
  80283c:	68 17 41 80 00       	push   $0x804117
  802841:	e8 a3 da ff ff       	call   8002e9 <_panic>
  802846:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802849:	8b 00                	mov    (%eax),%eax
  80284b:	85 c0                	test   %eax,%eax
  80284d:	74 10                	je     80285f <alloc_block_NF+0x74>
  80284f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802852:	8b 00                	mov    (%eax),%eax
  802854:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802857:	8b 52 04             	mov    0x4(%edx),%edx
  80285a:	89 50 04             	mov    %edx,0x4(%eax)
  80285d:	eb 0b                	jmp    80286a <alloc_block_NF+0x7f>
  80285f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802862:	8b 40 04             	mov    0x4(%eax),%eax
  802865:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80286a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286d:	8b 40 04             	mov    0x4(%eax),%eax
  802870:	85 c0                	test   %eax,%eax
  802872:	74 0f                	je     802883 <alloc_block_NF+0x98>
  802874:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802877:	8b 40 04             	mov    0x4(%eax),%eax
  80287a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80287d:	8b 12                	mov    (%edx),%edx
  80287f:	89 10                	mov    %edx,(%eax)
  802881:	eb 0a                	jmp    80288d <alloc_block_NF+0xa2>
  802883:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802886:	8b 00                	mov    (%eax),%eax
  802888:	a3 38 51 80 00       	mov    %eax,0x805138
  80288d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802890:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802896:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802899:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028a0:	a1 44 51 80 00       	mov    0x805144,%eax
  8028a5:	48                   	dec    %eax
  8028a6:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  8028ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ae:	8b 40 08             	mov    0x8(%eax),%eax
  8028b1:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  8028b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b9:	e9 f8 04 00 00       	jmp    802db6 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8028be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c1:	8b 40 0c             	mov    0xc(%eax),%eax
  8028c4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028c7:	0f 86 d4 00 00 00    	jbe    8029a1 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8028cd:	a1 48 51 80 00       	mov    0x805148,%eax
  8028d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8028d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d8:	8b 50 08             	mov    0x8(%eax),%edx
  8028db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028de:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8028e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8028e7:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8028ea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028ee:	75 17                	jne    802907 <alloc_block_NF+0x11c>
  8028f0:	83 ec 04             	sub    $0x4,%esp
  8028f3:	68 c0 41 80 00       	push   $0x8041c0
  8028f8:	68 e9 00 00 00       	push   $0xe9
  8028fd:	68 17 41 80 00       	push   $0x804117
  802902:	e8 e2 d9 ff ff       	call   8002e9 <_panic>
  802907:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80290a:	8b 00                	mov    (%eax),%eax
  80290c:	85 c0                	test   %eax,%eax
  80290e:	74 10                	je     802920 <alloc_block_NF+0x135>
  802910:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802913:	8b 00                	mov    (%eax),%eax
  802915:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802918:	8b 52 04             	mov    0x4(%edx),%edx
  80291b:	89 50 04             	mov    %edx,0x4(%eax)
  80291e:	eb 0b                	jmp    80292b <alloc_block_NF+0x140>
  802920:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802923:	8b 40 04             	mov    0x4(%eax),%eax
  802926:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80292b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80292e:	8b 40 04             	mov    0x4(%eax),%eax
  802931:	85 c0                	test   %eax,%eax
  802933:	74 0f                	je     802944 <alloc_block_NF+0x159>
  802935:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802938:	8b 40 04             	mov    0x4(%eax),%eax
  80293b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80293e:	8b 12                	mov    (%edx),%edx
  802940:	89 10                	mov    %edx,(%eax)
  802942:	eb 0a                	jmp    80294e <alloc_block_NF+0x163>
  802944:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802947:	8b 00                	mov    (%eax),%eax
  802949:	a3 48 51 80 00       	mov    %eax,0x805148
  80294e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802951:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802957:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80295a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802961:	a1 54 51 80 00       	mov    0x805154,%eax
  802966:	48                   	dec    %eax
  802967:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  80296c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80296f:	8b 40 08             	mov    0x8(%eax),%eax
  802972:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802977:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297a:	8b 50 08             	mov    0x8(%eax),%edx
  80297d:	8b 45 08             	mov    0x8(%ebp),%eax
  802980:	01 c2                	add    %eax,%edx
  802982:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802985:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802988:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298b:	8b 40 0c             	mov    0xc(%eax),%eax
  80298e:	2b 45 08             	sub    0x8(%ebp),%eax
  802991:	89 c2                	mov    %eax,%edx
  802993:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802996:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802999:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80299c:	e9 15 04 00 00       	jmp    802db6 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8029a1:	a1 40 51 80 00       	mov    0x805140,%eax
  8029a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029ad:	74 07                	je     8029b6 <alloc_block_NF+0x1cb>
  8029af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b2:	8b 00                	mov    (%eax),%eax
  8029b4:	eb 05                	jmp    8029bb <alloc_block_NF+0x1d0>
  8029b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8029bb:	a3 40 51 80 00       	mov    %eax,0x805140
  8029c0:	a1 40 51 80 00       	mov    0x805140,%eax
  8029c5:	85 c0                	test   %eax,%eax
  8029c7:	0f 85 3e fe ff ff    	jne    80280b <alloc_block_NF+0x20>
  8029cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029d1:	0f 85 34 fe ff ff    	jne    80280b <alloc_block_NF+0x20>
  8029d7:	e9 d5 03 00 00       	jmp    802db1 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8029dc:	a1 38 51 80 00       	mov    0x805138,%eax
  8029e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029e4:	e9 b1 01 00 00       	jmp    802b9a <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8029e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ec:	8b 50 08             	mov    0x8(%eax),%edx
  8029ef:	a1 28 50 80 00       	mov    0x805028,%eax
  8029f4:	39 c2                	cmp    %eax,%edx
  8029f6:	0f 82 96 01 00 00    	jb     802b92 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  8029fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ff:	8b 40 0c             	mov    0xc(%eax),%eax
  802a02:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a05:	0f 82 87 01 00 00    	jb     802b92 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802a0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0e:	8b 40 0c             	mov    0xc(%eax),%eax
  802a11:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a14:	0f 85 95 00 00 00    	jne    802aaf <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802a1a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a1e:	75 17                	jne    802a37 <alloc_block_NF+0x24c>
  802a20:	83 ec 04             	sub    $0x4,%esp
  802a23:	68 c0 41 80 00       	push   $0x8041c0
  802a28:	68 fc 00 00 00       	push   $0xfc
  802a2d:	68 17 41 80 00       	push   $0x804117
  802a32:	e8 b2 d8 ff ff       	call   8002e9 <_panic>
  802a37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3a:	8b 00                	mov    (%eax),%eax
  802a3c:	85 c0                	test   %eax,%eax
  802a3e:	74 10                	je     802a50 <alloc_block_NF+0x265>
  802a40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a43:	8b 00                	mov    (%eax),%eax
  802a45:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a48:	8b 52 04             	mov    0x4(%edx),%edx
  802a4b:	89 50 04             	mov    %edx,0x4(%eax)
  802a4e:	eb 0b                	jmp    802a5b <alloc_block_NF+0x270>
  802a50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a53:	8b 40 04             	mov    0x4(%eax),%eax
  802a56:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5e:	8b 40 04             	mov    0x4(%eax),%eax
  802a61:	85 c0                	test   %eax,%eax
  802a63:	74 0f                	je     802a74 <alloc_block_NF+0x289>
  802a65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a68:	8b 40 04             	mov    0x4(%eax),%eax
  802a6b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a6e:	8b 12                	mov    (%edx),%edx
  802a70:	89 10                	mov    %edx,(%eax)
  802a72:	eb 0a                	jmp    802a7e <alloc_block_NF+0x293>
  802a74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a77:	8b 00                	mov    (%eax),%eax
  802a79:	a3 38 51 80 00       	mov    %eax,0x805138
  802a7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a81:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a91:	a1 44 51 80 00       	mov    0x805144,%eax
  802a96:	48                   	dec    %eax
  802a97:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802a9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9f:	8b 40 08             	mov    0x8(%eax),%eax
  802aa2:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802aa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aaa:	e9 07 03 00 00       	jmp    802db6 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802aaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab2:	8b 40 0c             	mov    0xc(%eax),%eax
  802ab5:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ab8:	0f 86 d4 00 00 00    	jbe    802b92 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802abe:	a1 48 51 80 00       	mov    0x805148,%eax
  802ac3:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802ac6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac9:	8b 50 08             	mov    0x8(%eax),%edx
  802acc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802acf:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802ad2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ad5:	8b 55 08             	mov    0x8(%ebp),%edx
  802ad8:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802adb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802adf:	75 17                	jne    802af8 <alloc_block_NF+0x30d>
  802ae1:	83 ec 04             	sub    $0x4,%esp
  802ae4:	68 c0 41 80 00       	push   $0x8041c0
  802ae9:	68 04 01 00 00       	push   $0x104
  802aee:	68 17 41 80 00       	push   $0x804117
  802af3:	e8 f1 d7 ff ff       	call   8002e9 <_panic>
  802af8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802afb:	8b 00                	mov    (%eax),%eax
  802afd:	85 c0                	test   %eax,%eax
  802aff:	74 10                	je     802b11 <alloc_block_NF+0x326>
  802b01:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b04:	8b 00                	mov    (%eax),%eax
  802b06:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b09:	8b 52 04             	mov    0x4(%edx),%edx
  802b0c:	89 50 04             	mov    %edx,0x4(%eax)
  802b0f:	eb 0b                	jmp    802b1c <alloc_block_NF+0x331>
  802b11:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b14:	8b 40 04             	mov    0x4(%eax),%eax
  802b17:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b1c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b1f:	8b 40 04             	mov    0x4(%eax),%eax
  802b22:	85 c0                	test   %eax,%eax
  802b24:	74 0f                	je     802b35 <alloc_block_NF+0x34a>
  802b26:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b29:	8b 40 04             	mov    0x4(%eax),%eax
  802b2c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b2f:	8b 12                	mov    (%edx),%edx
  802b31:	89 10                	mov    %edx,(%eax)
  802b33:	eb 0a                	jmp    802b3f <alloc_block_NF+0x354>
  802b35:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b38:	8b 00                	mov    (%eax),%eax
  802b3a:	a3 48 51 80 00       	mov    %eax,0x805148
  802b3f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b42:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b48:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b4b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b52:	a1 54 51 80 00       	mov    0x805154,%eax
  802b57:	48                   	dec    %eax
  802b58:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802b5d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b60:	8b 40 08             	mov    0x8(%eax),%eax
  802b63:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802b68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6b:	8b 50 08             	mov    0x8(%eax),%edx
  802b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b71:	01 c2                	add    %eax,%edx
  802b73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b76:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802b79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7c:	8b 40 0c             	mov    0xc(%eax),%eax
  802b7f:	2b 45 08             	sub    0x8(%ebp),%eax
  802b82:	89 c2                	mov    %eax,%edx
  802b84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b87:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802b8a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b8d:	e9 24 02 00 00       	jmp    802db6 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b92:	a1 40 51 80 00       	mov    0x805140,%eax
  802b97:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b9a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b9e:	74 07                	je     802ba7 <alloc_block_NF+0x3bc>
  802ba0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba3:	8b 00                	mov    (%eax),%eax
  802ba5:	eb 05                	jmp    802bac <alloc_block_NF+0x3c1>
  802ba7:	b8 00 00 00 00       	mov    $0x0,%eax
  802bac:	a3 40 51 80 00       	mov    %eax,0x805140
  802bb1:	a1 40 51 80 00       	mov    0x805140,%eax
  802bb6:	85 c0                	test   %eax,%eax
  802bb8:	0f 85 2b fe ff ff    	jne    8029e9 <alloc_block_NF+0x1fe>
  802bbe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bc2:	0f 85 21 fe ff ff    	jne    8029e9 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802bc8:	a1 38 51 80 00       	mov    0x805138,%eax
  802bcd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bd0:	e9 ae 01 00 00       	jmp    802d83 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802bd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd8:	8b 50 08             	mov    0x8(%eax),%edx
  802bdb:	a1 28 50 80 00       	mov    0x805028,%eax
  802be0:	39 c2                	cmp    %eax,%edx
  802be2:	0f 83 93 01 00 00    	jae    802d7b <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802be8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802beb:	8b 40 0c             	mov    0xc(%eax),%eax
  802bee:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bf1:	0f 82 84 01 00 00    	jb     802d7b <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802bf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfa:	8b 40 0c             	mov    0xc(%eax),%eax
  802bfd:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c00:	0f 85 95 00 00 00    	jne    802c9b <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802c06:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c0a:	75 17                	jne    802c23 <alloc_block_NF+0x438>
  802c0c:	83 ec 04             	sub    $0x4,%esp
  802c0f:	68 c0 41 80 00       	push   $0x8041c0
  802c14:	68 14 01 00 00       	push   $0x114
  802c19:	68 17 41 80 00       	push   $0x804117
  802c1e:	e8 c6 d6 ff ff       	call   8002e9 <_panic>
  802c23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c26:	8b 00                	mov    (%eax),%eax
  802c28:	85 c0                	test   %eax,%eax
  802c2a:	74 10                	je     802c3c <alloc_block_NF+0x451>
  802c2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2f:	8b 00                	mov    (%eax),%eax
  802c31:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c34:	8b 52 04             	mov    0x4(%edx),%edx
  802c37:	89 50 04             	mov    %edx,0x4(%eax)
  802c3a:	eb 0b                	jmp    802c47 <alloc_block_NF+0x45c>
  802c3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3f:	8b 40 04             	mov    0x4(%eax),%eax
  802c42:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4a:	8b 40 04             	mov    0x4(%eax),%eax
  802c4d:	85 c0                	test   %eax,%eax
  802c4f:	74 0f                	je     802c60 <alloc_block_NF+0x475>
  802c51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c54:	8b 40 04             	mov    0x4(%eax),%eax
  802c57:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c5a:	8b 12                	mov    (%edx),%edx
  802c5c:	89 10                	mov    %edx,(%eax)
  802c5e:	eb 0a                	jmp    802c6a <alloc_block_NF+0x47f>
  802c60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c63:	8b 00                	mov    (%eax),%eax
  802c65:	a3 38 51 80 00       	mov    %eax,0x805138
  802c6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c76:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c7d:	a1 44 51 80 00       	mov    0x805144,%eax
  802c82:	48                   	dec    %eax
  802c83:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802c88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8b:	8b 40 08             	mov    0x8(%eax),%eax
  802c8e:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802c93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c96:	e9 1b 01 00 00       	jmp    802db6 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802c9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9e:	8b 40 0c             	mov    0xc(%eax),%eax
  802ca1:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ca4:	0f 86 d1 00 00 00    	jbe    802d7b <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802caa:	a1 48 51 80 00       	mov    0x805148,%eax
  802caf:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802cb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb5:	8b 50 08             	mov    0x8(%eax),%edx
  802cb8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cbb:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802cbe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cc1:	8b 55 08             	mov    0x8(%ebp),%edx
  802cc4:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802cc7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802ccb:	75 17                	jne    802ce4 <alloc_block_NF+0x4f9>
  802ccd:	83 ec 04             	sub    $0x4,%esp
  802cd0:	68 c0 41 80 00       	push   $0x8041c0
  802cd5:	68 1c 01 00 00       	push   $0x11c
  802cda:	68 17 41 80 00       	push   $0x804117
  802cdf:	e8 05 d6 ff ff       	call   8002e9 <_panic>
  802ce4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ce7:	8b 00                	mov    (%eax),%eax
  802ce9:	85 c0                	test   %eax,%eax
  802ceb:	74 10                	je     802cfd <alloc_block_NF+0x512>
  802ced:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cf0:	8b 00                	mov    (%eax),%eax
  802cf2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802cf5:	8b 52 04             	mov    0x4(%edx),%edx
  802cf8:	89 50 04             	mov    %edx,0x4(%eax)
  802cfb:	eb 0b                	jmp    802d08 <alloc_block_NF+0x51d>
  802cfd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d00:	8b 40 04             	mov    0x4(%eax),%eax
  802d03:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d08:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d0b:	8b 40 04             	mov    0x4(%eax),%eax
  802d0e:	85 c0                	test   %eax,%eax
  802d10:	74 0f                	je     802d21 <alloc_block_NF+0x536>
  802d12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d15:	8b 40 04             	mov    0x4(%eax),%eax
  802d18:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d1b:	8b 12                	mov    (%edx),%edx
  802d1d:	89 10                	mov    %edx,(%eax)
  802d1f:	eb 0a                	jmp    802d2b <alloc_block_NF+0x540>
  802d21:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d24:	8b 00                	mov    (%eax),%eax
  802d26:	a3 48 51 80 00       	mov    %eax,0x805148
  802d2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d2e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d34:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d37:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d3e:	a1 54 51 80 00       	mov    0x805154,%eax
  802d43:	48                   	dec    %eax
  802d44:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802d49:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d4c:	8b 40 08             	mov    0x8(%eax),%eax
  802d4f:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802d54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d57:	8b 50 08             	mov    0x8(%eax),%edx
  802d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5d:	01 c2                	add    %eax,%edx
  802d5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d62:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802d65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d68:	8b 40 0c             	mov    0xc(%eax),%eax
  802d6b:	2b 45 08             	sub    0x8(%ebp),%eax
  802d6e:	89 c2                	mov    %eax,%edx
  802d70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d73:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802d76:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d79:	eb 3b                	jmp    802db6 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802d7b:	a1 40 51 80 00       	mov    0x805140,%eax
  802d80:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d83:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d87:	74 07                	je     802d90 <alloc_block_NF+0x5a5>
  802d89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8c:	8b 00                	mov    (%eax),%eax
  802d8e:	eb 05                	jmp    802d95 <alloc_block_NF+0x5aa>
  802d90:	b8 00 00 00 00       	mov    $0x0,%eax
  802d95:	a3 40 51 80 00       	mov    %eax,0x805140
  802d9a:	a1 40 51 80 00       	mov    0x805140,%eax
  802d9f:	85 c0                	test   %eax,%eax
  802da1:	0f 85 2e fe ff ff    	jne    802bd5 <alloc_block_NF+0x3ea>
  802da7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dab:	0f 85 24 fe ff ff    	jne    802bd5 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802db1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802db6:	c9                   	leave  
  802db7:	c3                   	ret    

00802db8 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802db8:	55                   	push   %ebp
  802db9:	89 e5                	mov    %esp,%ebp
  802dbb:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802dbe:	a1 38 51 80 00       	mov    0x805138,%eax
  802dc3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802dc6:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802dcb:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802dce:	a1 38 51 80 00       	mov    0x805138,%eax
  802dd3:	85 c0                	test   %eax,%eax
  802dd5:	74 14                	je     802deb <insert_sorted_with_merge_freeList+0x33>
  802dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dda:	8b 50 08             	mov    0x8(%eax),%edx
  802ddd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de0:	8b 40 08             	mov    0x8(%eax),%eax
  802de3:	39 c2                	cmp    %eax,%edx
  802de5:	0f 87 9b 01 00 00    	ja     802f86 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802deb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802def:	75 17                	jne    802e08 <insert_sorted_with_merge_freeList+0x50>
  802df1:	83 ec 04             	sub    $0x4,%esp
  802df4:	68 f4 40 80 00       	push   $0x8040f4
  802df9:	68 38 01 00 00       	push   $0x138
  802dfe:	68 17 41 80 00       	push   $0x804117
  802e03:	e8 e1 d4 ff ff       	call   8002e9 <_panic>
  802e08:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e11:	89 10                	mov    %edx,(%eax)
  802e13:	8b 45 08             	mov    0x8(%ebp),%eax
  802e16:	8b 00                	mov    (%eax),%eax
  802e18:	85 c0                	test   %eax,%eax
  802e1a:	74 0d                	je     802e29 <insert_sorted_with_merge_freeList+0x71>
  802e1c:	a1 38 51 80 00       	mov    0x805138,%eax
  802e21:	8b 55 08             	mov    0x8(%ebp),%edx
  802e24:	89 50 04             	mov    %edx,0x4(%eax)
  802e27:	eb 08                	jmp    802e31 <insert_sorted_with_merge_freeList+0x79>
  802e29:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e31:	8b 45 08             	mov    0x8(%ebp),%eax
  802e34:	a3 38 51 80 00       	mov    %eax,0x805138
  802e39:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e43:	a1 44 51 80 00       	mov    0x805144,%eax
  802e48:	40                   	inc    %eax
  802e49:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802e4e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e52:	0f 84 a8 06 00 00    	je     803500 <insert_sorted_with_merge_freeList+0x748>
  802e58:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5b:	8b 50 08             	mov    0x8(%eax),%edx
  802e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e61:	8b 40 0c             	mov    0xc(%eax),%eax
  802e64:	01 c2                	add    %eax,%edx
  802e66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e69:	8b 40 08             	mov    0x8(%eax),%eax
  802e6c:	39 c2                	cmp    %eax,%edx
  802e6e:	0f 85 8c 06 00 00    	jne    803500 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802e74:	8b 45 08             	mov    0x8(%ebp),%eax
  802e77:	8b 50 0c             	mov    0xc(%eax),%edx
  802e7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e7d:	8b 40 0c             	mov    0xc(%eax),%eax
  802e80:	01 c2                	add    %eax,%edx
  802e82:	8b 45 08             	mov    0x8(%ebp),%eax
  802e85:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802e88:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e8c:	75 17                	jne    802ea5 <insert_sorted_with_merge_freeList+0xed>
  802e8e:	83 ec 04             	sub    $0x4,%esp
  802e91:	68 c0 41 80 00       	push   $0x8041c0
  802e96:	68 3c 01 00 00       	push   $0x13c
  802e9b:	68 17 41 80 00       	push   $0x804117
  802ea0:	e8 44 d4 ff ff       	call   8002e9 <_panic>
  802ea5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ea8:	8b 00                	mov    (%eax),%eax
  802eaa:	85 c0                	test   %eax,%eax
  802eac:	74 10                	je     802ebe <insert_sorted_with_merge_freeList+0x106>
  802eae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eb1:	8b 00                	mov    (%eax),%eax
  802eb3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802eb6:	8b 52 04             	mov    0x4(%edx),%edx
  802eb9:	89 50 04             	mov    %edx,0x4(%eax)
  802ebc:	eb 0b                	jmp    802ec9 <insert_sorted_with_merge_freeList+0x111>
  802ebe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ec1:	8b 40 04             	mov    0x4(%eax),%eax
  802ec4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ec9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ecc:	8b 40 04             	mov    0x4(%eax),%eax
  802ecf:	85 c0                	test   %eax,%eax
  802ed1:	74 0f                	je     802ee2 <insert_sorted_with_merge_freeList+0x12a>
  802ed3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ed6:	8b 40 04             	mov    0x4(%eax),%eax
  802ed9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802edc:	8b 12                	mov    (%edx),%edx
  802ede:	89 10                	mov    %edx,(%eax)
  802ee0:	eb 0a                	jmp    802eec <insert_sorted_with_merge_freeList+0x134>
  802ee2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ee5:	8b 00                	mov    (%eax),%eax
  802ee7:	a3 38 51 80 00       	mov    %eax,0x805138
  802eec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ef5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ef8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eff:	a1 44 51 80 00       	mov    0x805144,%eax
  802f04:	48                   	dec    %eax
  802f05:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802f0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f0d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802f14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f17:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802f1e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f22:	75 17                	jne    802f3b <insert_sorted_with_merge_freeList+0x183>
  802f24:	83 ec 04             	sub    $0x4,%esp
  802f27:	68 f4 40 80 00       	push   $0x8040f4
  802f2c:	68 3f 01 00 00       	push   $0x13f
  802f31:	68 17 41 80 00       	push   $0x804117
  802f36:	e8 ae d3 ff ff       	call   8002e9 <_panic>
  802f3b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f44:	89 10                	mov    %edx,(%eax)
  802f46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f49:	8b 00                	mov    (%eax),%eax
  802f4b:	85 c0                	test   %eax,%eax
  802f4d:	74 0d                	je     802f5c <insert_sorted_with_merge_freeList+0x1a4>
  802f4f:	a1 48 51 80 00       	mov    0x805148,%eax
  802f54:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f57:	89 50 04             	mov    %edx,0x4(%eax)
  802f5a:	eb 08                	jmp    802f64 <insert_sorted_with_merge_freeList+0x1ac>
  802f5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f5f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f67:	a3 48 51 80 00       	mov    %eax,0x805148
  802f6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f6f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f76:	a1 54 51 80 00       	mov    0x805154,%eax
  802f7b:	40                   	inc    %eax
  802f7c:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802f81:	e9 7a 05 00 00       	jmp    803500 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802f86:	8b 45 08             	mov    0x8(%ebp),%eax
  802f89:	8b 50 08             	mov    0x8(%eax),%edx
  802f8c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f8f:	8b 40 08             	mov    0x8(%eax),%eax
  802f92:	39 c2                	cmp    %eax,%edx
  802f94:	0f 82 14 01 00 00    	jb     8030ae <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802f9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f9d:	8b 50 08             	mov    0x8(%eax),%edx
  802fa0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fa3:	8b 40 0c             	mov    0xc(%eax),%eax
  802fa6:	01 c2                	add    %eax,%edx
  802fa8:	8b 45 08             	mov    0x8(%ebp),%eax
  802fab:	8b 40 08             	mov    0x8(%eax),%eax
  802fae:	39 c2                	cmp    %eax,%edx
  802fb0:	0f 85 90 00 00 00    	jne    803046 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802fb6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fb9:	8b 50 0c             	mov    0xc(%eax),%edx
  802fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802fbf:	8b 40 0c             	mov    0xc(%eax),%eax
  802fc2:	01 c2                	add    %eax,%edx
  802fc4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fc7:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802fca:	8b 45 08             	mov    0x8(%ebp),%eax
  802fcd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802fd4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802fde:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fe2:	75 17                	jne    802ffb <insert_sorted_with_merge_freeList+0x243>
  802fe4:	83 ec 04             	sub    $0x4,%esp
  802fe7:	68 f4 40 80 00       	push   $0x8040f4
  802fec:	68 49 01 00 00       	push   $0x149
  802ff1:	68 17 41 80 00       	push   $0x804117
  802ff6:	e8 ee d2 ff ff       	call   8002e9 <_panic>
  802ffb:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803001:	8b 45 08             	mov    0x8(%ebp),%eax
  803004:	89 10                	mov    %edx,(%eax)
  803006:	8b 45 08             	mov    0x8(%ebp),%eax
  803009:	8b 00                	mov    (%eax),%eax
  80300b:	85 c0                	test   %eax,%eax
  80300d:	74 0d                	je     80301c <insert_sorted_with_merge_freeList+0x264>
  80300f:	a1 48 51 80 00       	mov    0x805148,%eax
  803014:	8b 55 08             	mov    0x8(%ebp),%edx
  803017:	89 50 04             	mov    %edx,0x4(%eax)
  80301a:	eb 08                	jmp    803024 <insert_sorted_with_merge_freeList+0x26c>
  80301c:	8b 45 08             	mov    0x8(%ebp),%eax
  80301f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803024:	8b 45 08             	mov    0x8(%ebp),%eax
  803027:	a3 48 51 80 00       	mov    %eax,0x805148
  80302c:	8b 45 08             	mov    0x8(%ebp),%eax
  80302f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803036:	a1 54 51 80 00       	mov    0x805154,%eax
  80303b:	40                   	inc    %eax
  80303c:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803041:	e9 bb 04 00 00       	jmp    803501 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803046:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80304a:	75 17                	jne    803063 <insert_sorted_with_merge_freeList+0x2ab>
  80304c:	83 ec 04             	sub    $0x4,%esp
  80304f:	68 68 41 80 00       	push   $0x804168
  803054:	68 4c 01 00 00       	push   $0x14c
  803059:	68 17 41 80 00       	push   $0x804117
  80305e:	e8 86 d2 ff ff       	call   8002e9 <_panic>
  803063:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803069:	8b 45 08             	mov    0x8(%ebp),%eax
  80306c:	89 50 04             	mov    %edx,0x4(%eax)
  80306f:	8b 45 08             	mov    0x8(%ebp),%eax
  803072:	8b 40 04             	mov    0x4(%eax),%eax
  803075:	85 c0                	test   %eax,%eax
  803077:	74 0c                	je     803085 <insert_sorted_with_merge_freeList+0x2cd>
  803079:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80307e:	8b 55 08             	mov    0x8(%ebp),%edx
  803081:	89 10                	mov    %edx,(%eax)
  803083:	eb 08                	jmp    80308d <insert_sorted_with_merge_freeList+0x2d5>
  803085:	8b 45 08             	mov    0x8(%ebp),%eax
  803088:	a3 38 51 80 00       	mov    %eax,0x805138
  80308d:	8b 45 08             	mov    0x8(%ebp),%eax
  803090:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803095:	8b 45 08             	mov    0x8(%ebp),%eax
  803098:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80309e:	a1 44 51 80 00       	mov    0x805144,%eax
  8030a3:	40                   	inc    %eax
  8030a4:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8030a9:	e9 53 04 00 00       	jmp    803501 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8030ae:	a1 38 51 80 00       	mov    0x805138,%eax
  8030b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030b6:	e9 15 04 00 00       	jmp    8034d0 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  8030bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030be:	8b 00                	mov    (%eax),%eax
  8030c0:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  8030c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c6:	8b 50 08             	mov    0x8(%eax),%edx
  8030c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030cc:	8b 40 08             	mov    0x8(%eax),%eax
  8030cf:	39 c2                	cmp    %eax,%edx
  8030d1:	0f 86 f1 03 00 00    	jbe    8034c8 <insert_sorted_with_merge_freeList+0x710>
  8030d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030da:	8b 50 08             	mov    0x8(%eax),%edx
  8030dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030e0:	8b 40 08             	mov    0x8(%eax),%eax
  8030e3:	39 c2                	cmp    %eax,%edx
  8030e5:	0f 83 dd 03 00 00    	jae    8034c8 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8030eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ee:	8b 50 08             	mov    0x8(%eax),%edx
  8030f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f4:	8b 40 0c             	mov    0xc(%eax),%eax
  8030f7:	01 c2                	add    %eax,%edx
  8030f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fc:	8b 40 08             	mov    0x8(%eax),%eax
  8030ff:	39 c2                	cmp    %eax,%edx
  803101:	0f 85 b9 01 00 00    	jne    8032c0 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803107:	8b 45 08             	mov    0x8(%ebp),%eax
  80310a:	8b 50 08             	mov    0x8(%eax),%edx
  80310d:	8b 45 08             	mov    0x8(%ebp),%eax
  803110:	8b 40 0c             	mov    0xc(%eax),%eax
  803113:	01 c2                	add    %eax,%edx
  803115:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803118:	8b 40 08             	mov    0x8(%eax),%eax
  80311b:	39 c2                	cmp    %eax,%edx
  80311d:	0f 85 0d 01 00 00    	jne    803230 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803123:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803126:	8b 50 0c             	mov    0xc(%eax),%edx
  803129:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80312c:	8b 40 0c             	mov    0xc(%eax),%eax
  80312f:	01 c2                	add    %eax,%edx
  803131:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803134:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803137:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80313b:	75 17                	jne    803154 <insert_sorted_with_merge_freeList+0x39c>
  80313d:	83 ec 04             	sub    $0x4,%esp
  803140:	68 c0 41 80 00       	push   $0x8041c0
  803145:	68 5c 01 00 00       	push   $0x15c
  80314a:	68 17 41 80 00       	push   $0x804117
  80314f:	e8 95 d1 ff ff       	call   8002e9 <_panic>
  803154:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803157:	8b 00                	mov    (%eax),%eax
  803159:	85 c0                	test   %eax,%eax
  80315b:	74 10                	je     80316d <insert_sorted_with_merge_freeList+0x3b5>
  80315d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803160:	8b 00                	mov    (%eax),%eax
  803162:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803165:	8b 52 04             	mov    0x4(%edx),%edx
  803168:	89 50 04             	mov    %edx,0x4(%eax)
  80316b:	eb 0b                	jmp    803178 <insert_sorted_with_merge_freeList+0x3c0>
  80316d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803170:	8b 40 04             	mov    0x4(%eax),%eax
  803173:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803178:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80317b:	8b 40 04             	mov    0x4(%eax),%eax
  80317e:	85 c0                	test   %eax,%eax
  803180:	74 0f                	je     803191 <insert_sorted_with_merge_freeList+0x3d9>
  803182:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803185:	8b 40 04             	mov    0x4(%eax),%eax
  803188:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80318b:	8b 12                	mov    (%edx),%edx
  80318d:	89 10                	mov    %edx,(%eax)
  80318f:	eb 0a                	jmp    80319b <insert_sorted_with_merge_freeList+0x3e3>
  803191:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803194:	8b 00                	mov    (%eax),%eax
  803196:	a3 38 51 80 00       	mov    %eax,0x805138
  80319b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80319e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031a7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031ae:	a1 44 51 80 00       	mov    0x805144,%eax
  8031b3:	48                   	dec    %eax
  8031b4:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8031b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031bc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8031c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8031cd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031d1:	75 17                	jne    8031ea <insert_sorted_with_merge_freeList+0x432>
  8031d3:	83 ec 04             	sub    $0x4,%esp
  8031d6:	68 f4 40 80 00       	push   $0x8040f4
  8031db:	68 5f 01 00 00       	push   $0x15f
  8031e0:	68 17 41 80 00       	push   $0x804117
  8031e5:	e8 ff d0 ff ff       	call   8002e9 <_panic>
  8031ea:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f3:	89 10                	mov    %edx,(%eax)
  8031f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f8:	8b 00                	mov    (%eax),%eax
  8031fa:	85 c0                	test   %eax,%eax
  8031fc:	74 0d                	je     80320b <insert_sorted_with_merge_freeList+0x453>
  8031fe:	a1 48 51 80 00       	mov    0x805148,%eax
  803203:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803206:	89 50 04             	mov    %edx,0x4(%eax)
  803209:	eb 08                	jmp    803213 <insert_sorted_with_merge_freeList+0x45b>
  80320b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80320e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803213:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803216:	a3 48 51 80 00       	mov    %eax,0x805148
  80321b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80321e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803225:	a1 54 51 80 00       	mov    0x805154,%eax
  80322a:	40                   	inc    %eax
  80322b:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803230:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803233:	8b 50 0c             	mov    0xc(%eax),%edx
  803236:	8b 45 08             	mov    0x8(%ebp),%eax
  803239:	8b 40 0c             	mov    0xc(%eax),%eax
  80323c:	01 c2                	add    %eax,%edx
  80323e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803241:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803244:	8b 45 08             	mov    0x8(%ebp),%eax
  803247:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  80324e:	8b 45 08             	mov    0x8(%ebp),%eax
  803251:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803258:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80325c:	75 17                	jne    803275 <insert_sorted_with_merge_freeList+0x4bd>
  80325e:	83 ec 04             	sub    $0x4,%esp
  803261:	68 f4 40 80 00       	push   $0x8040f4
  803266:	68 64 01 00 00       	push   $0x164
  80326b:	68 17 41 80 00       	push   $0x804117
  803270:	e8 74 d0 ff ff       	call   8002e9 <_panic>
  803275:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80327b:	8b 45 08             	mov    0x8(%ebp),%eax
  80327e:	89 10                	mov    %edx,(%eax)
  803280:	8b 45 08             	mov    0x8(%ebp),%eax
  803283:	8b 00                	mov    (%eax),%eax
  803285:	85 c0                	test   %eax,%eax
  803287:	74 0d                	je     803296 <insert_sorted_with_merge_freeList+0x4de>
  803289:	a1 48 51 80 00       	mov    0x805148,%eax
  80328e:	8b 55 08             	mov    0x8(%ebp),%edx
  803291:	89 50 04             	mov    %edx,0x4(%eax)
  803294:	eb 08                	jmp    80329e <insert_sorted_with_merge_freeList+0x4e6>
  803296:	8b 45 08             	mov    0x8(%ebp),%eax
  803299:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80329e:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a1:	a3 48 51 80 00       	mov    %eax,0x805148
  8032a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032b0:	a1 54 51 80 00       	mov    0x805154,%eax
  8032b5:	40                   	inc    %eax
  8032b6:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8032bb:	e9 41 02 00 00       	jmp    803501 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8032c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c3:	8b 50 08             	mov    0x8(%eax),%edx
  8032c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c9:	8b 40 0c             	mov    0xc(%eax),%eax
  8032cc:	01 c2                	add    %eax,%edx
  8032ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d1:	8b 40 08             	mov    0x8(%eax),%eax
  8032d4:	39 c2                	cmp    %eax,%edx
  8032d6:	0f 85 7c 01 00 00    	jne    803458 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8032dc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032e0:	74 06                	je     8032e8 <insert_sorted_with_merge_freeList+0x530>
  8032e2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032e6:	75 17                	jne    8032ff <insert_sorted_with_merge_freeList+0x547>
  8032e8:	83 ec 04             	sub    $0x4,%esp
  8032eb:	68 30 41 80 00       	push   $0x804130
  8032f0:	68 69 01 00 00       	push   $0x169
  8032f5:	68 17 41 80 00       	push   $0x804117
  8032fa:	e8 ea cf ff ff       	call   8002e9 <_panic>
  8032ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803302:	8b 50 04             	mov    0x4(%eax),%edx
  803305:	8b 45 08             	mov    0x8(%ebp),%eax
  803308:	89 50 04             	mov    %edx,0x4(%eax)
  80330b:	8b 45 08             	mov    0x8(%ebp),%eax
  80330e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803311:	89 10                	mov    %edx,(%eax)
  803313:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803316:	8b 40 04             	mov    0x4(%eax),%eax
  803319:	85 c0                	test   %eax,%eax
  80331b:	74 0d                	je     80332a <insert_sorted_with_merge_freeList+0x572>
  80331d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803320:	8b 40 04             	mov    0x4(%eax),%eax
  803323:	8b 55 08             	mov    0x8(%ebp),%edx
  803326:	89 10                	mov    %edx,(%eax)
  803328:	eb 08                	jmp    803332 <insert_sorted_with_merge_freeList+0x57a>
  80332a:	8b 45 08             	mov    0x8(%ebp),%eax
  80332d:	a3 38 51 80 00       	mov    %eax,0x805138
  803332:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803335:	8b 55 08             	mov    0x8(%ebp),%edx
  803338:	89 50 04             	mov    %edx,0x4(%eax)
  80333b:	a1 44 51 80 00       	mov    0x805144,%eax
  803340:	40                   	inc    %eax
  803341:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803346:	8b 45 08             	mov    0x8(%ebp),%eax
  803349:	8b 50 0c             	mov    0xc(%eax),%edx
  80334c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80334f:	8b 40 0c             	mov    0xc(%eax),%eax
  803352:	01 c2                	add    %eax,%edx
  803354:	8b 45 08             	mov    0x8(%ebp),%eax
  803357:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80335a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80335e:	75 17                	jne    803377 <insert_sorted_with_merge_freeList+0x5bf>
  803360:	83 ec 04             	sub    $0x4,%esp
  803363:	68 c0 41 80 00       	push   $0x8041c0
  803368:	68 6b 01 00 00       	push   $0x16b
  80336d:	68 17 41 80 00       	push   $0x804117
  803372:	e8 72 cf ff ff       	call   8002e9 <_panic>
  803377:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80337a:	8b 00                	mov    (%eax),%eax
  80337c:	85 c0                	test   %eax,%eax
  80337e:	74 10                	je     803390 <insert_sorted_with_merge_freeList+0x5d8>
  803380:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803383:	8b 00                	mov    (%eax),%eax
  803385:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803388:	8b 52 04             	mov    0x4(%edx),%edx
  80338b:	89 50 04             	mov    %edx,0x4(%eax)
  80338e:	eb 0b                	jmp    80339b <insert_sorted_with_merge_freeList+0x5e3>
  803390:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803393:	8b 40 04             	mov    0x4(%eax),%eax
  803396:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80339b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80339e:	8b 40 04             	mov    0x4(%eax),%eax
  8033a1:	85 c0                	test   %eax,%eax
  8033a3:	74 0f                	je     8033b4 <insert_sorted_with_merge_freeList+0x5fc>
  8033a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033a8:	8b 40 04             	mov    0x4(%eax),%eax
  8033ab:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033ae:	8b 12                	mov    (%edx),%edx
  8033b0:	89 10                	mov    %edx,(%eax)
  8033b2:	eb 0a                	jmp    8033be <insert_sorted_with_merge_freeList+0x606>
  8033b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033b7:	8b 00                	mov    (%eax),%eax
  8033b9:	a3 38 51 80 00       	mov    %eax,0x805138
  8033be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033ca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033d1:	a1 44 51 80 00       	mov    0x805144,%eax
  8033d6:	48                   	dec    %eax
  8033d7:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8033dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033df:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8033e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033e9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8033f0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8033f4:	75 17                	jne    80340d <insert_sorted_with_merge_freeList+0x655>
  8033f6:	83 ec 04             	sub    $0x4,%esp
  8033f9:	68 f4 40 80 00       	push   $0x8040f4
  8033fe:	68 6e 01 00 00       	push   $0x16e
  803403:	68 17 41 80 00       	push   $0x804117
  803408:	e8 dc ce ff ff       	call   8002e9 <_panic>
  80340d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803413:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803416:	89 10                	mov    %edx,(%eax)
  803418:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80341b:	8b 00                	mov    (%eax),%eax
  80341d:	85 c0                	test   %eax,%eax
  80341f:	74 0d                	je     80342e <insert_sorted_with_merge_freeList+0x676>
  803421:	a1 48 51 80 00       	mov    0x805148,%eax
  803426:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803429:	89 50 04             	mov    %edx,0x4(%eax)
  80342c:	eb 08                	jmp    803436 <insert_sorted_with_merge_freeList+0x67e>
  80342e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803431:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803436:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803439:	a3 48 51 80 00       	mov    %eax,0x805148
  80343e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803441:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803448:	a1 54 51 80 00       	mov    0x805154,%eax
  80344d:	40                   	inc    %eax
  80344e:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803453:	e9 a9 00 00 00       	jmp    803501 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803458:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80345c:	74 06                	je     803464 <insert_sorted_with_merge_freeList+0x6ac>
  80345e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803462:	75 17                	jne    80347b <insert_sorted_with_merge_freeList+0x6c3>
  803464:	83 ec 04             	sub    $0x4,%esp
  803467:	68 8c 41 80 00       	push   $0x80418c
  80346c:	68 73 01 00 00       	push   $0x173
  803471:	68 17 41 80 00       	push   $0x804117
  803476:	e8 6e ce ff ff       	call   8002e9 <_panic>
  80347b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80347e:	8b 10                	mov    (%eax),%edx
  803480:	8b 45 08             	mov    0x8(%ebp),%eax
  803483:	89 10                	mov    %edx,(%eax)
  803485:	8b 45 08             	mov    0x8(%ebp),%eax
  803488:	8b 00                	mov    (%eax),%eax
  80348a:	85 c0                	test   %eax,%eax
  80348c:	74 0b                	je     803499 <insert_sorted_with_merge_freeList+0x6e1>
  80348e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803491:	8b 00                	mov    (%eax),%eax
  803493:	8b 55 08             	mov    0x8(%ebp),%edx
  803496:	89 50 04             	mov    %edx,0x4(%eax)
  803499:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80349c:	8b 55 08             	mov    0x8(%ebp),%edx
  80349f:	89 10                	mov    %edx,(%eax)
  8034a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034a7:	89 50 04             	mov    %edx,0x4(%eax)
  8034aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ad:	8b 00                	mov    (%eax),%eax
  8034af:	85 c0                	test   %eax,%eax
  8034b1:	75 08                	jne    8034bb <insert_sorted_with_merge_freeList+0x703>
  8034b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8034bb:	a1 44 51 80 00       	mov    0x805144,%eax
  8034c0:	40                   	inc    %eax
  8034c1:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  8034c6:	eb 39                	jmp    803501 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8034c8:	a1 40 51 80 00       	mov    0x805140,%eax
  8034cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034d4:	74 07                	je     8034dd <insert_sorted_with_merge_freeList+0x725>
  8034d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d9:	8b 00                	mov    (%eax),%eax
  8034db:	eb 05                	jmp    8034e2 <insert_sorted_with_merge_freeList+0x72a>
  8034dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8034e2:	a3 40 51 80 00       	mov    %eax,0x805140
  8034e7:	a1 40 51 80 00       	mov    0x805140,%eax
  8034ec:	85 c0                	test   %eax,%eax
  8034ee:	0f 85 c7 fb ff ff    	jne    8030bb <insert_sorted_with_merge_freeList+0x303>
  8034f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034f8:	0f 85 bd fb ff ff    	jne    8030bb <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8034fe:	eb 01                	jmp    803501 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803500:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803501:	90                   	nop
  803502:	c9                   	leave  
  803503:	c3                   	ret    

00803504 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803504:	55                   	push   %ebp
  803505:	89 e5                	mov    %esp,%ebp
  803507:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  80350a:	8b 55 08             	mov    0x8(%ebp),%edx
  80350d:	89 d0                	mov    %edx,%eax
  80350f:	c1 e0 02             	shl    $0x2,%eax
  803512:	01 d0                	add    %edx,%eax
  803514:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80351b:	01 d0                	add    %edx,%eax
  80351d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803524:	01 d0                	add    %edx,%eax
  803526:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80352d:	01 d0                	add    %edx,%eax
  80352f:	c1 e0 04             	shl    $0x4,%eax
  803532:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803535:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  80353c:	8d 45 e8             	lea    -0x18(%ebp),%eax
  80353f:	83 ec 0c             	sub    $0xc,%esp
  803542:	50                   	push   %eax
  803543:	e8 26 e7 ff ff       	call   801c6e <sys_get_virtual_time>
  803548:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  80354b:	eb 41                	jmp    80358e <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  80354d:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803550:	83 ec 0c             	sub    $0xc,%esp
  803553:	50                   	push   %eax
  803554:	e8 15 e7 ff ff       	call   801c6e <sys_get_virtual_time>
  803559:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  80355c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80355f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803562:	29 c2                	sub    %eax,%edx
  803564:	89 d0                	mov    %edx,%eax
  803566:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803569:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80356c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80356f:	89 d1                	mov    %edx,%ecx
  803571:	29 c1                	sub    %eax,%ecx
  803573:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803576:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803579:	39 c2                	cmp    %eax,%edx
  80357b:	0f 97 c0             	seta   %al
  80357e:	0f b6 c0             	movzbl %al,%eax
  803581:	29 c1                	sub    %eax,%ecx
  803583:	89 c8                	mov    %ecx,%eax
  803585:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803588:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80358b:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  80358e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803591:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803594:	72 b7                	jb     80354d <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803596:	90                   	nop
  803597:	c9                   	leave  
  803598:	c3                   	ret    

00803599 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803599:	55                   	push   %ebp
  80359a:	89 e5                	mov    %esp,%ebp
  80359c:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  80359f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8035a6:	eb 03                	jmp    8035ab <busy_wait+0x12>
  8035a8:	ff 45 fc             	incl   -0x4(%ebp)
  8035ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8035ae:	3b 45 08             	cmp    0x8(%ebp),%eax
  8035b1:	72 f5                	jb     8035a8 <busy_wait+0xf>
	return i;
  8035b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8035b6:	c9                   	leave  
  8035b7:	c3                   	ret    

008035b8 <__udivdi3>:
  8035b8:	55                   	push   %ebp
  8035b9:	57                   	push   %edi
  8035ba:	56                   	push   %esi
  8035bb:	53                   	push   %ebx
  8035bc:	83 ec 1c             	sub    $0x1c,%esp
  8035bf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8035c3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8035c7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8035cb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8035cf:	89 ca                	mov    %ecx,%edx
  8035d1:	89 f8                	mov    %edi,%eax
  8035d3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8035d7:	85 f6                	test   %esi,%esi
  8035d9:	75 2d                	jne    803608 <__udivdi3+0x50>
  8035db:	39 cf                	cmp    %ecx,%edi
  8035dd:	77 65                	ja     803644 <__udivdi3+0x8c>
  8035df:	89 fd                	mov    %edi,%ebp
  8035e1:	85 ff                	test   %edi,%edi
  8035e3:	75 0b                	jne    8035f0 <__udivdi3+0x38>
  8035e5:	b8 01 00 00 00       	mov    $0x1,%eax
  8035ea:	31 d2                	xor    %edx,%edx
  8035ec:	f7 f7                	div    %edi
  8035ee:	89 c5                	mov    %eax,%ebp
  8035f0:	31 d2                	xor    %edx,%edx
  8035f2:	89 c8                	mov    %ecx,%eax
  8035f4:	f7 f5                	div    %ebp
  8035f6:	89 c1                	mov    %eax,%ecx
  8035f8:	89 d8                	mov    %ebx,%eax
  8035fa:	f7 f5                	div    %ebp
  8035fc:	89 cf                	mov    %ecx,%edi
  8035fe:	89 fa                	mov    %edi,%edx
  803600:	83 c4 1c             	add    $0x1c,%esp
  803603:	5b                   	pop    %ebx
  803604:	5e                   	pop    %esi
  803605:	5f                   	pop    %edi
  803606:	5d                   	pop    %ebp
  803607:	c3                   	ret    
  803608:	39 ce                	cmp    %ecx,%esi
  80360a:	77 28                	ja     803634 <__udivdi3+0x7c>
  80360c:	0f bd fe             	bsr    %esi,%edi
  80360f:	83 f7 1f             	xor    $0x1f,%edi
  803612:	75 40                	jne    803654 <__udivdi3+0x9c>
  803614:	39 ce                	cmp    %ecx,%esi
  803616:	72 0a                	jb     803622 <__udivdi3+0x6a>
  803618:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80361c:	0f 87 9e 00 00 00    	ja     8036c0 <__udivdi3+0x108>
  803622:	b8 01 00 00 00       	mov    $0x1,%eax
  803627:	89 fa                	mov    %edi,%edx
  803629:	83 c4 1c             	add    $0x1c,%esp
  80362c:	5b                   	pop    %ebx
  80362d:	5e                   	pop    %esi
  80362e:	5f                   	pop    %edi
  80362f:	5d                   	pop    %ebp
  803630:	c3                   	ret    
  803631:	8d 76 00             	lea    0x0(%esi),%esi
  803634:	31 ff                	xor    %edi,%edi
  803636:	31 c0                	xor    %eax,%eax
  803638:	89 fa                	mov    %edi,%edx
  80363a:	83 c4 1c             	add    $0x1c,%esp
  80363d:	5b                   	pop    %ebx
  80363e:	5e                   	pop    %esi
  80363f:	5f                   	pop    %edi
  803640:	5d                   	pop    %ebp
  803641:	c3                   	ret    
  803642:	66 90                	xchg   %ax,%ax
  803644:	89 d8                	mov    %ebx,%eax
  803646:	f7 f7                	div    %edi
  803648:	31 ff                	xor    %edi,%edi
  80364a:	89 fa                	mov    %edi,%edx
  80364c:	83 c4 1c             	add    $0x1c,%esp
  80364f:	5b                   	pop    %ebx
  803650:	5e                   	pop    %esi
  803651:	5f                   	pop    %edi
  803652:	5d                   	pop    %ebp
  803653:	c3                   	ret    
  803654:	bd 20 00 00 00       	mov    $0x20,%ebp
  803659:	89 eb                	mov    %ebp,%ebx
  80365b:	29 fb                	sub    %edi,%ebx
  80365d:	89 f9                	mov    %edi,%ecx
  80365f:	d3 e6                	shl    %cl,%esi
  803661:	89 c5                	mov    %eax,%ebp
  803663:	88 d9                	mov    %bl,%cl
  803665:	d3 ed                	shr    %cl,%ebp
  803667:	89 e9                	mov    %ebp,%ecx
  803669:	09 f1                	or     %esi,%ecx
  80366b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80366f:	89 f9                	mov    %edi,%ecx
  803671:	d3 e0                	shl    %cl,%eax
  803673:	89 c5                	mov    %eax,%ebp
  803675:	89 d6                	mov    %edx,%esi
  803677:	88 d9                	mov    %bl,%cl
  803679:	d3 ee                	shr    %cl,%esi
  80367b:	89 f9                	mov    %edi,%ecx
  80367d:	d3 e2                	shl    %cl,%edx
  80367f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803683:	88 d9                	mov    %bl,%cl
  803685:	d3 e8                	shr    %cl,%eax
  803687:	09 c2                	or     %eax,%edx
  803689:	89 d0                	mov    %edx,%eax
  80368b:	89 f2                	mov    %esi,%edx
  80368d:	f7 74 24 0c          	divl   0xc(%esp)
  803691:	89 d6                	mov    %edx,%esi
  803693:	89 c3                	mov    %eax,%ebx
  803695:	f7 e5                	mul    %ebp
  803697:	39 d6                	cmp    %edx,%esi
  803699:	72 19                	jb     8036b4 <__udivdi3+0xfc>
  80369b:	74 0b                	je     8036a8 <__udivdi3+0xf0>
  80369d:	89 d8                	mov    %ebx,%eax
  80369f:	31 ff                	xor    %edi,%edi
  8036a1:	e9 58 ff ff ff       	jmp    8035fe <__udivdi3+0x46>
  8036a6:	66 90                	xchg   %ax,%ax
  8036a8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8036ac:	89 f9                	mov    %edi,%ecx
  8036ae:	d3 e2                	shl    %cl,%edx
  8036b0:	39 c2                	cmp    %eax,%edx
  8036b2:	73 e9                	jae    80369d <__udivdi3+0xe5>
  8036b4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8036b7:	31 ff                	xor    %edi,%edi
  8036b9:	e9 40 ff ff ff       	jmp    8035fe <__udivdi3+0x46>
  8036be:	66 90                	xchg   %ax,%ax
  8036c0:	31 c0                	xor    %eax,%eax
  8036c2:	e9 37 ff ff ff       	jmp    8035fe <__udivdi3+0x46>
  8036c7:	90                   	nop

008036c8 <__umoddi3>:
  8036c8:	55                   	push   %ebp
  8036c9:	57                   	push   %edi
  8036ca:	56                   	push   %esi
  8036cb:	53                   	push   %ebx
  8036cc:	83 ec 1c             	sub    $0x1c,%esp
  8036cf:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8036d3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8036d7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8036db:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8036df:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8036e3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8036e7:	89 f3                	mov    %esi,%ebx
  8036e9:	89 fa                	mov    %edi,%edx
  8036eb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8036ef:	89 34 24             	mov    %esi,(%esp)
  8036f2:	85 c0                	test   %eax,%eax
  8036f4:	75 1a                	jne    803710 <__umoddi3+0x48>
  8036f6:	39 f7                	cmp    %esi,%edi
  8036f8:	0f 86 a2 00 00 00    	jbe    8037a0 <__umoddi3+0xd8>
  8036fe:	89 c8                	mov    %ecx,%eax
  803700:	89 f2                	mov    %esi,%edx
  803702:	f7 f7                	div    %edi
  803704:	89 d0                	mov    %edx,%eax
  803706:	31 d2                	xor    %edx,%edx
  803708:	83 c4 1c             	add    $0x1c,%esp
  80370b:	5b                   	pop    %ebx
  80370c:	5e                   	pop    %esi
  80370d:	5f                   	pop    %edi
  80370e:	5d                   	pop    %ebp
  80370f:	c3                   	ret    
  803710:	39 f0                	cmp    %esi,%eax
  803712:	0f 87 ac 00 00 00    	ja     8037c4 <__umoddi3+0xfc>
  803718:	0f bd e8             	bsr    %eax,%ebp
  80371b:	83 f5 1f             	xor    $0x1f,%ebp
  80371e:	0f 84 ac 00 00 00    	je     8037d0 <__umoddi3+0x108>
  803724:	bf 20 00 00 00       	mov    $0x20,%edi
  803729:	29 ef                	sub    %ebp,%edi
  80372b:	89 fe                	mov    %edi,%esi
  80372d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803731:	89 e9                	mov    %ebp,%ecx
  803733:	d3 e0                	shl    %cl,%eax
  803735:	89 d7                	mov    %edx,%edi
  803737:	89 f1                	mov    %esi,%ecx
  803739:	d3 ef                	shr    %cl,%edi
  80373b:	09 c7                	or     %eax,%edi
  80373d:	89 e9                	mov    %ebp,%ecx
  80373f:	d3 e2                	shl    %cl,%edx
  803741:	89 14 24             	mov    %edx,(%esp)
  803744:	89 d8                	mov    %ebx,%eax
  803746:	d3 e0                	shl    %cl,%eax
  803748:	89 c2                	mov    %eax,%edx
  80374a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80374e:	d3 e0                	shl    %cl,%eax
  803750:	89 44 24 04          	mov    %eax,0x4(%esp)
  803754:	8b 44 24 08          	mov    0x8(%esp),%eax
  803758:	89 f1                	mov    %esi,%ecx
  80375a:	d3 e8                	shr    %cl,%eax
  80375c:	09 d0                	or     %edx,%eax
  80375e:	d3 eb                	shr    %cl,%ebx
  803760:	89 da                	mov    %ebx,%edx
  803762:	f7 f7                	div    %edi
  803764:	89 d3                	mov    %edx,%ebx
  803766:	f7 24 24             	mull   (%esp)
  803769:	89 c6                	mov    %eax,%esi
  80376b:	89 d1                	mov    %edx,%ecx
  80376d:	39 d3                	cmp    %edx,%ebx
  80376f:	0f 82 87 00 00 00    	jb     8037fc <__umoddi3+0x134>
  803775:	0f 84 91 00 00 00    	je     80380c <__umoddi3+0x144>
  80377b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80377f:	29 f2                	sub    %esi,%edx
  803781:	19 cb                	sbb    %ecx,%ebx
  803783:	89 d8                	mov    %ebx,%eax
  803785:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803789:	d3 e0                	shl    %cl,%eax
  80378b:	89 e9                	mov    %ebp,%ecx
  80378d:	d3 ea                	shr    %cl,%edx
  80378f:	09 d0                	or     %edx,%eax
  803791:	89 e9                	mov    %ebp,%ecx
  803793:	d3 eb                	shr    %cl,%ebx
  803795:	89 da                	mov    %ebx,%edx
  803797:	83 c4 1c             	add    $0x1c,%esp
  80379a:	5b                   	pop    %ebx
  80379b:	5e                   	pop    %esi
  80379c:	5f                   	pop    %edi
  80379d:	5d                   	pop    %ebp
  80379e:	c3                   	ret    
  80379f:	90                   	nop
  8037a0:	89 fd                	mov    %edi,%ebp
  8037a2:	85 ff                	test   %edi,%edi
  8037a4:	75 0b                	jne    8037b1 <__umoddi3+0xe9>
  8037a6:	b8 01 00 00 00       	mov    $0x1,%eax
  8037ab:	31 d2                	xor    %edx,%edx
  8037ad:	f7 f7                	div    %edi
  8037af:	89 c5                	mov    %eax,%ebp
  8037b1:	89 f0                	mov    %esi,%eax
  8037b3:	31 d2                	xor    %edx,%edx
  8037b5:	f7 f5                	div    %ebp
  8037b7:	89 c8                	mov    %ecx,%eax
  8037b9:	f7 f5                	div    %ebp
  8037bb:	89 d0                	mov    %edx,%eax
  8037bd:	e9 44 ff ff ff       	jmp    803706 <__umoddi3+0x3e>
  8037c2:	66 90                	xchg   %ax,%ax
  8037c4:	89 c8                	mov    %ecx,%eax
  8037c6:	89 f2                	mov    %esi,%edx
  8037c8:	83 c4 1c             	add    $0x1c,%esp
  8037cb:	5b                   	pop    %ebx
  8037cc:	5e                   	pop    %esi
  8037cd:	5f                   	pop    %edi
  8037ce:	5d                   	pop    %ebp
  8037cf:	c3                   	ret    
  8037d0:	3b 04 24             	cmp    (%esp),%eax
  8037d3:	72 06                	jb     8037db <__umoddi3+0x113>
  8037d5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8037d9:	77 0f                	ja     8037ea <__umoddi3+0x122>
  8037db:	89 f2                	mov    %esi,%edx
  8037dd:	29 f9                	sub    %edi,%ecx
  8037df:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8037e3:	89 14 24             	mov    %edx,(%esp)
  8037e6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8037ea:	8b 44 24 04          	mov    0x4(%esp),%eax
  8037ee:	8b 14 24             	mov    (%esp),%edx
  8037f1:	83 c4 1c             	add    $0x1c,%esp
  8037f4:	5b                   	pop    %ebx
  8037f5:	5e                   	pop    %esi
  8037f6:	5f                   	pop    %edi
  8037f7:	5d                   	pop    %ebp
  8037f8:	c3                   	ret    
  8037f9:	8d 76 00             	lea    0x0(%esi),%esi
  8037fc:	2b 04 24             	sub    (%esp),%eax
  8037ff:	19 fa                	sbb    %edi,%edx
  803801:	89 d1                	mov    %edx,%ecx
  803803:	89 c6                	mov    %eax,%esi
  803805:	e9 71 ff ff ff       	jmp    80377b <__umoddi3+0xb3>
  80380a:	66 90                	xchg   %ax,%ax
  80380c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803810:	72 ea                	jb     8037fc <__umoddi3+0x134>
  803812:	89 d9                	mov    %ebx,%ecx
  803814:	e9 62 ff ff ff       	jmp    80377b <__umoddi3+0xb3>
