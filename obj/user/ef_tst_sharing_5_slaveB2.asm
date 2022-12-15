
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
  80008c:	68 80 37 80 00       	push   $0x803780
  800091:	6a 12                	push   $0x12
  800093:	68 9c 37 80 00       	push   $0x80379c
  800098:	e8 4c 02 00 00       	call   8002e9 <_panic>
	}
	uint32 *z;
	z = sget(sys_getparentenvid(),"z");
  80009d:	e8 e3 1a 00 00       	call   801b85 <sys_getparentenvid>
  8000a2:	83 ec 08             	sub    $0x8,%esp
  8000a5:	68 bc 37 80 00       	push   $0x8037bc
  8000aa:	50                   	push   %eax
  8000ab:	e8 b8 15 00 00       	call   801668 <sget>
  8000b0:	83 c4 10             	add    $0x10,%esp
  8000b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("Slave B2 env used z (getSharedObject)\n");
  8000b6:	83 ec 0c             	sub    $0xc,%esp
  8000b9:	68 c0 37 80 00       	push   $0x8037c0
  8000be:	e8 da 04 00 00       	call   80059d <cprintf>
  8000c3:	83 c4 10             	add    $0x10,%esp

	cprintf("Slave B2 please be patient ...\n");
  8000c6:	83 ec 0c             	sub    $0xc,%esp
  8000c9:	68 e8 37 80 00       	push   $0x8037e8
  8000ce:	e8 ca 04 00 00       	call   80059d <cprintf>
  8000d3:	83 c4 10             	add    $0x10,%esp

	env_sleep(9000);
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	68 28 23 00 00       	push   $0x2328
  8000de:	e8 6b 33 00 00       	call   80344e <env_sleep>
  8000e3:	83 c4 10             	add    $0x10,%esp
	int freeFrames = sys_calculate_free_frames() ;
  8000e6:	e8 a1 17 00 00       	call   80188c <sys_calculate_free_frames>
  8000eb:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sfree(z);
  8000ee:	83 ec 0c             	sub    $0xc,%esp
  8000f1:	ff 75 ec             	pushl  -0x14(%ebp)
  8000f4:	e8 33 16 00 00       	call   80172c <sfree>
  8000f9:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave B2 env removed z\n");
  8000fc:	83 ec 0c             	sub    $0xc,%esp
  8000ff:	68 08 38 80 00       	push   $0x803808
  800104:	e8 94 04 00 00       	call   80059d <cprintf>
  800109:	83 c4 10             	add    $0x10,%esp

	if ((sys_calculate_free_frames() - freeFrames) !=  4) panic("wrong free: frames removed not equal 4 !, correct frames to be removed are 4:\nfrom the env: 1 table + 1 frame for z\nframes_storage of z: should be cleared now\n");
  80010c:	e8 7b 17 00 00       	call   80188c <sys_calculate_free_frames>
  800111:	89 c2                	mov    %eax,%edx
  800113:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800116:	29 c2                	sub    %eax,%edx
  800118:	89 d0                	mov    %edx,%eax
  80011a:	83 f8 04             	cmp    $0x4,%eax
  80011d:	74 14                	je     800133 <_main+0xfb>
  80011f:	83 ec 04             	sub    $0x4,%esp
  800122:	68 20 38 80 00       	push   $0x803820
  800127:	6a 20                	push   $0x20
  800129:	68 9c 37 80 00       	push   $0x80379c
  80012e:	e8 b6 01 00 00       	call   8002e9 <_panic>

	//to ensure that the other environments completed successfully
	if (gettst()!=2) panic("test failed");
  800133:	e8 8c 1b 00 00       	call   801cc4 <gettst>
  800138:	83 f8 02             	cmp    $0x2,%eax
  80013b:	74 14                	je     800151 <_main+0x119>
  80013d:	83 ec 04             	sub    $0x4,%esp
  800140:	68 c0 38 80 00       	push   $0x8038c0
  800145:	6a 23                	push   $0x23
  800147:	68 9c 37 80 00       	push   $0x80379c
  80014c:	e8 98 01 00 00       	call   8002e9 <_panic>

	cprintf("Step B completed successfully!!\n\n\n");
  800151:	83 ec 0c             	sub    $0xc,%esp
  800154:	68 cc 38 80 00       	push   $0x8038cc
  800159:	e8 3f 04 00 00       	call   80059d <cprintf>
  80015e:	83 c4 10             	add    $0x10,%esp
	cprintf("Congratulations!! Test of freeSharedObjects [5] completed successfully!!\n\n\n");
  800161:	83 ec 0c             	sub    $0xc,%esp
  800164:	68 f0 38 80 00       	push   $0x8038f0
  800169:	e8 2f 04 00 00       	call   80059d <cprintf>
  80016e:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  800171:	e8 0f 1a 00 00       	call   801b85 <sys_getparentenvid>
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
  800189:	68 3c 39 80 00       	push   $0x80393c
  80018e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800191:	e8 d2 14 00 00       	call   801668 <sget>
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
  8001b3:	e8 b4 19 00 00       	call   801b6c <sys_getenvindex>
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
  80021e:	e8 56 17 00 00       	call   801979 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800223:	83 ec 0c             	sub    $0xc,%esp
  800226:	68 64 39 80 00       	push   $0x803964
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
  80024e:	68 8c 39 80 00       	push   $0x80398c
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
  80027f:	68 b4 39 80 00       	push   $0x8039b4
  800284:	e8 14 03 00 00       	call   80059d <cprintf>
  800289:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80028c:	a1 20 50 80 00       	mov    0x805020,%eax
  800291:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800297:	83 ec 08             	sub    $0x8,%esp
  80029a:	50                   	push   %eax
  80029b:	68 0c 3a 80 00       	push   $0x803a0c
  8002a0:	e8 f8 02 00 00       	call   80059d <cprintf>
  8002a5:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8002a8:	83 ec 0c             	sub    $0xc,%esp
  8002ab:	68 64 39 80 00       	push   $0x803964
  8002b0:	e8 e8 02 00 00       	call   80059d <cprintf>
  8002b5:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8002b8:	e8 d6 16 00 00       	call   801993 <sys_enable_interrupt>

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
  8002d0:	e8 63 18 00 00       	call   801b38 <sys_destroy_env>
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
  8002e1:	e8 b8 18 00 00       	call   801b9e <sys_exit_env>
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
  80030a:	68 20 3a 80 00       	push   $0x803a20
  80030f:	e8 89 02 00 00       	call   80059d <cprintf>
  800314:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800317:	a1 00 50 80 00       	mov    0x805000,%eax
  80031c:	ff 75 0c             	pushl  0xc(%ebp)
  80031f:	ff 75 08             	pushl  0x8(%ebp)
  800322:	50                   	push   %eax
  800323:	68 25 3a 80 00       	push   $0x803a25
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
  800347:	68 41 3a 80 00       	push   $0x803a41
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
  800373:	68 44 3a 80 00       	push   $0x803a44
  800378:	6a 26                	push   $0x26
  80037a:	68 90 3a 80 00       	push   $0x803a90
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
  800445:	68 9c 3a 80 00       	push   $0x803a9c
  80044a:	6a 3a                	push   $0x3a
  80044c:	68 90 3a 80 00       	push   $0x803a90
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
  8004b5:	68 f0 3a 80 00       	push   $0x803af0
  8004ba:	6a 44                	push   $0x44
  8004bc:	68 90 3a 80 00       	push   $0x803a90
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
  80050f:	e8 b7 12 00 00       	call   8017cb <sys_cputs>
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
  800586:	e8 40 12 00 00       	call   8017cb <sys_cputs>
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
  8005d0:	e8 a4 13 00 00       	call   801979 <sys_disable_interrupt>
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
  8005f0:	e8 9e 13 00 00       	call   801993 <sys_enable_interrupt>
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
  80063a:	e8 c5 2e 00 00       	call   803504 <__udivdi3>
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
  80068a:	e8 85 2f 00 00       	call   803614 <__umoddi3>
  80068f:	83 c4 10             	add    $0x10,%esp
  800692:	05 54 3d 80 00       	add    $0x803d54,%eax
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
  8007e5:	8b 04 85 78 3d 80 00 	mov    0x803d78(,%eax,4),%eax
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
  8008c6:	8b 34 9d c0 3b 80 00 	mov    0x803bc0(,%ebx,4),%esi
  8008cd:	85 f6                	test   %esi,%esi
  8008cf:	75 19                	jne    8008ea <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008d1:	53                   	push   %ebx
  8008d2:	68 65 3d 80 00       	push   $0x803d65
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
  8008eb:	68 6e 3d 80 00       	push   $0x803d6e
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
  800918:	be 71 3d 80 00       	mov    $0x803d71,%esi
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
  80133e:	68 d0 3e 80 00       	push   $0x803ed0
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
  80140e:	e8 fc 04 00 00       	call   80190f <sys_allocate_chunk>
  801413:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801416:	a1 20 51 80 00       	mov    0x805120,%eax
  80141b:	83 ec 0c             	sub    $0xc,%esp
  80141e:	50                   	push   %eax
  80141f:	e8 71 0b 00 00       	call   801f95 <initialize_MemBlocksList>
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
  80144c:	68 f5 3e 80 00       	push   $0x803ef5
  801451:	6a 33                	push   $0x33
  801453:	68 13 3f 80 00       	push   $0x803f13
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
  8014cb:	68 20 3f 80 00       	push   $0x803f20
  8014d0:	6a 34                	push   $0x34
  8014d2:	68 13 3f 80 00       	push   $0x803f13
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
  801563:	e8 75 07 00 00       	call   801cdd <sys_isUHeapPlacementStrategyFIRSTFIT>
  801568:	85 c0                	test   %eax,%eax
  80156a:	74 11                	je     80157d <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  80156c:	83 ec 0c             	sub    $0xc,%esp
  80156f:	ff 75 e8             	pushl  -0x18(%ebp)
  801572:	e8 e0 0d 00 00       	call   802357 <alloc_block_FF>
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
  801589:	e8 3c 0b 00 00       	call   8020ca <insert_sorted_allocList>
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
  8015a9:	68 44 3f 80 00       	push   $0x803f44
  8015ae:	6a 6f                	push   $0x6f
  8015b0:	68 13 3f 80 00       	push   $0x803f13
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
  8015cf:	75 0a                	jne    8015db <smalloc+0x21>
  8015d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8015d6:	e9 8b 00 00 00       	jmp    801666 <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  8015db:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8015e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015e8:	01 d0                	add    %edx,%eax
  8015ea:	48                   	dec    %eax
  8015eb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8015ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8015f6:	f7 75 f0             	divl   -0x10(%ebp)
  8015f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015fc:	29 d0                	sub    %edx,%eax
  8015fe:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801601:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801608:	e8 d0 06 00 00       	call   801cdd <sys_isUHeapPlacementStrategyFIRSTFIT>
  80160d:	85 c0                	test   %eax,%eax
  80160f:	74 11                	je     801622 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  801611:	83 ec 0c             	sub    $0xc,%esp
  801614:	ff 75 e8             	pushl  -0x18(%ebp)
  801617:	e8 3b 0d 00 00       	call   802357 <alloc_block_FF>
  80161c:	83 c4 10             	add    $0x10,%esp
  80161f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  801622:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801626:	74 39                	je     801661 <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801628:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80162b:	8b 40 08             	mov    0x8(%eax),%eax
  80162e:	89 c2                	mov    %eax,%edx
  801630:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801634:	52                   	push   %edx
  801635:	50                   	push   %eax
  801636:	ff 75 0c             	pushl  0xc(%ebp)
  801639:	ff 75 08             	pushl  0x8(%ebp)
  80163c:	e8 21 04 00 00       	call   801a62 <sys_createSharedObject>
  801641:	83 c4 10             	add    $0x10,%esp
  801644:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  801647:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  80164b:	74 14                	je     801661 <smalloc+0xa7>
  80164d:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  801651:	74 0e                	je     801661 <smalloc+0xa7>
  801653:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  801657:	74 08                	je     801661 <smalloc+0xa7>
			return (void*) mem_block->sva;
  801659:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80165c:	8b 40 08             	mov    0x8(%eax),%eax
  80165f:	eb 05                	jmp    801666 <smalloc+0xac>
	}
	return NULL;
  801661:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801666:	c9                   	leave  
  801667:	c3                   	ret    

00801668 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801668:	55                   	push   %ebp
  801669:	89 e5                	mov    %esp,%ebp
  80166b:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80166e:	e8 b4 fc ff ff       	call   801327 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801673:	83 ec 08             	sub    $0x8,%esp
  801676:	ff 75 0c             	pushl  0xc(%ebp)
  801679:	ff 75 08             	pushl  0x8(%ebp)
  80167c:	e8 0b 04 00 00       	call   801a8c <sys_getSizeOfSharedObject>
  801681:	83 c4 10             	add    $0x10,%esp
  801684:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  801687:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  80168b:	74 76                	je     801703 <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  80168d:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801694:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801697:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80169a:	01 d0                	add    %edx,%eax
  80169c:	48                   	dec    %eax
  80169d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8016a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8016a8:	f7 75 ec             	divl   -0x14(%ebp)
  8016ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016ae:	29 d0                	sub    %edx,%eax
  8016b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  8016b3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8016ba:	e8 1e 06 00 00       	call   801cdd <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016bf:	85 c0                	test   %eax,%eax
  8016c1:	74 11                	je     8016d4 <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  8016c3:	83 ec 0c             	sub    $0xc,%esp
  8016c6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8016c9:	e8 89 0c 00 00       	call   802357 <alloc_block_FF>
  8016ce:	83 c4 10             	add    $0x10,%esp
  8016d1:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  8016d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8016d8:	74 29                	je     801703 <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  8016da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016dd:	8b 40 08             	mov    0x8(%eax),%eax
  8016e0:	83 ec 04             	sub    $0x4,%esp
  8016e3:	50                   	push   %eax
  8016e4:	ff 75 0c             	pushl  0xc(%ebp)
  8016e7:	ff 75 08             	pushl  0x8(%ebp)
  8016ea:	e8 ba 03 00 00       	call   801aa9 <sys_getSharedObject>
  8016ef:	83 c4 10             	add    $0x10,%esp
  8016f2:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  8016f5:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  8016f9:	74 08                	je     801703 <sget+0x9b>
				return (void *)mem_block->sva;
  8016fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016fe:	8b 40 08             	mov    0x8(%eax),%eax
  801701:	eb 05                	jmp    801708 <sget+0xa0>
		}
	}
	return NULL;
  801703:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801708:	c9                   	leave  
  801709:	c3                   	ret    

0080170a <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80170a:	55                   	push   %ebp
  80170b:	89 e5                	mov    %esp,%ebp
  80170d:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801710:	e8 12 fc ff ff       	call   801327 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801715:	83 ec 04             	sub    $0x4,%esp
  801718:	68 68 3f 80 00       	push   $0x803f68
  80171d:	68 f1 00 00 00       	push   $0xf1
  801722:	68 13 3f 80 00       	push   $0x803f13
  801727:	e8 bd eb ff ff       	call   8002e9 <_panic>

0080172c <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80172c:	55                   	push   %ebp
  80172d:	89 e5                	mov    %esp,%ebp
  80172f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801732:	83 ec 04             	sub    $0x4,%esp
  801735:	68 90 3f 80 00       	push   $0x803f90
  80173a:	68 05 01 00 00       	push   $0x105
  80173f:	68 13 3f 80 00       	push   $0x803f13
  801744:	e8 a0 eb ff ff       	call   8002e9 <_panic>

00801749 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801749:	55                   	push   %ebp
  80174a:	89 e5                	mov    %esp,%ebp
  80174c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80174f:	83 ec 04             	sub    $0x4,%esp
  801752:	68 b4 3f 80 00       	push   $0x803fb4
  801757:	68 10 01 00 00       	push   $0x110
  80175c:	68 13 3f 80 00       	push   $0x803f13
  801761:	e8 83 eb ff ff       	call   8002e9 <_panic>

00801766 <shrink>:

}
void shrink(uint32 newSize)
{
  801766:	55                   	push   %ebp
  801767:	89 e5                	mov    %esp,%ebp
  801769:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80176c:	83 ec 04             	sub    $0x4,%esp
  80176f:	68 b4 3f 80 00       	push   $0x803fb4
  801774:	68 15 01 00 00       	push   $0x115
  801779:	68 13 3f 80 00       	push   $0x803f13
  80177e:	e8 66 eb ff ff       	call   8002e9 <_panic>

00801783 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801783:	55                   	push   %ebp
  801784:	89 e5                	mov    %esp,%ebp
  801786:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801789:	83 ec 04             	sub    $0x4,%esp
  80178c:	68 b4 3f 80 00       	push   $0x803fb4
  801791:	68 1a 01 00 00       	push   $0x11a
  801796:	68 13 3f 80 00       	push   $0x803f13
  80179b:	e8 49 eb ff ff       	call   8002e9 <_panic>

008017a0 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8017a0:	55                   	push   %ebp
  8017a1:	89 e5                	mov    %esp,%ebp
  8017a3:	57                   	push   %edi
  8017a4:	56                   	push   %esi
  8017a5:	53                   	push   %ebx
  8017a6:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017af:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017b2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017b5:	8b 7d 18             	mov    0x18(%ebp),%edi
  8017b8:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8017bb:	cd 30                	int    $0x30
  8017bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8017c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8017c3:	83 c4 10             	add    $0x10,%esp
  8017c6:	5b                   	pop    %ebx
  8017c7:	5e                   	pop    %esi
  8017c8:	5f                   	pop    %edi
  8017c9:	5d                   	pop    %ebp
  8017ca:	c3                   	ret    

008017cb <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8017cb:	55                   	push   %ebp
  8017cc:	89 e5                	mov    %esp,%ebp
  8017ce:	83 ec 04             	sub    $0x4,%esp
  8017d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8017d4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8017d7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017db:	8b 45 08             	mov    0x8(%ebp),%eax
  8017de:	6a 00                	push   $0x0
  8017e0:	6a 00                	push   $0x0
  8017e2:	52                   	push   %edx
  8017e3:	ff 75 0c             	pushl  0xc(%ebp)
  8017e6:	50                   	push   %eax
  8017e7:	6a 00                	push   $0x0
  8017e9:	e8 b2 ff ff ff       	call   8017a0 <syscall>
  8017ee:	83 c4 18             	add    $0x18,%esp
}
  8017f1:	90                   	nop
  8017f2:	c9                   	leave  
  8017f3:	c3                   	ret    

008017f4 <sys_cgetc>:

int
sys_cgetc(void)
{
  8017f4:	55                   	push   %ebp
  8017f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8017f7:	6a 00                	push   $0x0
  8017f9:	6a 00                	push   $0x0
  8017fb:	6a 00                	push   $0x0
  8017fd:	6a 00                	push   $0x0
  8017ff:	6a 00                	push   $0x0
  801801:	6a 01                	push   $0x1
  801803:	e8 98 ff ff ff       	call   8017a0 <syscall>
  801808:	83 c4 18             	add    $0x18,%esp
}
  80180b:	c9                   	leave  
  80180c:	c3                   	ret    

0080180d <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80180d:	55                   	push   %ebp
  80180e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801810:	8b 55 0c             	mov    0xc(%ebp),%edx
  801813:	8b 45 08             	mov    0x8(%ebp),%eax
  801816:	6a 00                	push   $0x0
  801818:	6a 00                	push   $0x0
  80181a:	6a 00                	push   $0x0
  80181c:	52                   	push   %edx
  80181d:	50                   	push   %eax
  80181e:	6a 05                	push   $0x5
  801820:	e8 7b ff ff ff       	call   8017a0 <syscall>
  801825:	83 c4 18             	add    $0x18,%esp
}
  801828:	c9                   	leave  
  801829:	c3                   	ret    

0080182a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80182a:	55                   	push   %ebp
  80182b:	89 e5                	mov    %esp,%ebp
  80182d:	56                   	push   %esi
  80182e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80182f:	8b 75 18             	mov    0x18(%ebp),%esi
  801832:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801835:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801838:	8b 55 0c             	mov    0xc(%ebp),%edx
  80183b:	8b 45 08             	mov    0x8(%ebp),%eax
  80183e:	56                   	push   %esi
  80183f:	53                   	push   %ebx
  801840:	51                   	push   %ecx
  801841:	52                   	push   %edx
  801842:	50                   	push   %eax
  801843:	6a 06                	push   $0x6
  801845:	e8 56 ff ff ff       	call   8017a0 <syscall>
  80184a:	83 c4 18             	add    $0x18,%esp
}
  80184d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801850:	5b                   	pop    %ebx
  801851:	5e                   	pop    %esi
  801852:	5d                   	pop    %ebp
  801853:	c3                   	ret    

00801854 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801854:	55                   	push   %ebp
  801855:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801857:	8b 55 0c             	mov    0xc(%ebp),%edx
  80185a:	8b 45 08             	mov    0x8(%ebp),%eax
  80185d:	6a 00                	push   $0x0
  80185f:	6a 00                	push   $0x0
  801861:	6a 00                	push   $0x0
  801863:	52                   	push   %edx
  801864:	50                   	push   %eax
  801865:	6a 07                	push   $0x7
  801867:	e8 34 ff ff ff       	call   8017a0 <syscall>
  80186c:	83 c4 18             	add    $0x18,%esp
}
  80186f:	c9                   	leave  
  801870:	c3                   	ret    

00801871 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801871:	55                   	push   %ebp
  801872:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801874:	6a 00                	push   $0x0
  801876:	6a 00                	push   $0x0
  801878:	6a 00                	push   $0x0
  80187a:	ff 75 0c             	pushl  0xc(%ebp)
  80187d:	ff 75 08             	pushl  0x8(%ebp)
  801880:	6a 08                	push   $0x8
  801882:	e8 19 ff ff ff       	call   8017a0 <syscall>
  801887:	83 c4 18             	add    $0x18,%esp
}
  80188a:	c9                   	leave  
  80188b:	c3                   	ret    

0080188c <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80188c:	55                   	push   %ebp
  80188d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80188f:	6a 00                	push   $0x0
  801891:	6a 00                	push   $0x0
  801893:	6a 00                	push   $0x0
  801895:	6a 00                	push   $0x0
  801897:	6a 00                	push   $0x0
  801899:	6a 09                	push   $0x9
  80189b:	e8 00 ff ff ff       	call   8017a0 <syscall>
  8018a0:	83 c4 18             	add    $0x18,%esp
}
  8018a3:	c9                   	leave  
  8018a4:	c3                   	ret    

008018a5 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8018a5:	55                   	push   %ebp
  8018a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8018a8:	6a 00                	push   $0x0
  8018aa:	6a 00                	push   $0x0
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 00                	push   $0x0
  8018b0:	6a 00                	push   $0x0
  8018b2:	6a 0a                	push   $0xa
  8018b4:	e8 e7 fe ff ff       	call   8017a0 <syscall>
  8018b9:	83 c4 18             	add    $0x18,%esp
}
  8018bc:	c9                   	leave  
  8018bd:	c3                   	ret    

008018be <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8018be:	55                   	push   %ebp
  8018bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8018c1:	6a 00                	push   $0x0
  8018c3:	6a 00                	push   $0x0
  8018c5:	6a 00                	push   $0x0
  8018c7:	6a 00                	push   $0x0
  8018c9:	6a 00                	push   $0x0
  8018cb:	6a 0b                	push   $0xb
  8018cd:	e8 ce fe ff ff       	call   8017a0 <syscall>
  8018d2:	83 c4 18             	add    $0x18,%esp
}
  8018d5:	c9                   	leave  
  8018d6:	c3                   	ret    

008018d7 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8018d7:	55                   	push   %ebp
  8018d8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8018da:	6a 00                	push   $0x0
  8018dc:	6a 00                	push   $0x0
  8018de:	6a 00                	push   $0x0
  8018e0:	ff 75 0c             	pushl  0xc(%ebp)
  8018e3:	ff 75 08             	pushl  0x8(%ebp)
  8018e6:	6a 0f                	push   $0xf
  8018e8:	e8 b3 fe ff ff       	call   8017a0 <syscall>
  8018ed:	83 c4 18             	add    $0x18,%esp
	return;
  8018f0:	90                   	nop
}
  8018f1:	c9                   	leave  
  8018f2:	c3                   	ret    

008018f3 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8018f3:	55                   	push   %ebp
  8018f4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8018f6:	6a 00                	push   $0x0
  8018f8:	6a 00                	push   $0x0
  8018fa:	6a 00                	push   $0x0
  8018fc:	ff 75 0c             	pushl  0xc(%ebp)
  8018ff:	ff 75 08             	pushl  0x8(%ebp)
  801902:	6a 10                	push   $0x10
  801904:	e8 97 fe ff ff       	call   8017a0 <syscall>
  801909:	83 c4 18             	add    $0x18,%esp
	return ;
  80190c:	90                   	nop
}
  80190d:	c9                   	leave  
  80190e:	c3                   	ret    

0080190f <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80190f:	55                   	push   %ebp
  801910:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801912:	6a 00                	push   $0x0
  801914:	6a 00                	push   $0x0
  801916:	ff 75 10             	pushl  0x10(%ebp)
  801919:	ff 75 0c             	pushl  0xc(%ebp)
  80191c:	ff 75 08             	pushl  0x8(%ebp)
  80191f:	6a 11                	push   $0x11
  801921:	e8 7a fe ff ff       	call   8017a0 <syscall>
  801926:	83 c4 18             	add    $0x18,%esp
	return ;
  801929:	90                   	nop
}
  80192a:	c9                   	leave  
  80192b:	c3                   	ret    

0080192c <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80192c:	55                   	push   %ebp
  80192d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80192f:	6a 00                	push   $0x0
  801931:	6a 00                	push   $0x0
  801933:	6a 00                	push   $0x0
  801935:	6a 00                	push   $0x0
  801937:	6a 00                	push   $0x0
  801939:	6a 0c                	push   $0xc
  80193b:	e8 60 fe ff ff       	call   8017a0 <syscall>
  801940:	83 c4 18             	add    $0x18,%esp
}
  801943:	c9                   	leave  
  801944:	c3                   	ret    

00801945 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801945:	55                   	push   %ebp
  801946:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801948:	6a 00                	push   $0x0
  80194a:	6a 00                	push   $0x0
  80194c:	6a 00                	push   $0x0
  80194e:	6a 00                	push   $0x0
  801950:	ff 75 08             	pushl  0x8(%ebp)
  801953:	6a 0d                	push   $0xd
  801955:	e8 46 fe ff ff       	call   8017a0 <syscall>
  80195a:	83 c4 18             	add    $0x18,%esp
}
  80195d:	c9                   	leave  
  80195e:	c3                   	ret    

0080195f <sys_scarce_memory>:

void sys_scarce_memory()
{
  80195f:	55                   	push   %ebp
  801960:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801962:	6a 00                	push   $0x0
  801964:	6a 00                	push   $0x0
  801966:	6a 00                	push   $0x0
  801968:	6a 00                	push   $0x0
  80196a:	6a 00                	push   $0x0
  80196c:	6a 0e                	push   $0xe
  80196e:	e8 2d fe ff ff       	call   8017a0 <syscall>
  801973:	83 c4 18             	add    $0x18,%esp
}
  801976:	90                   	nop
  801977:	c9                   	leave  
  801978:	c3                   	ret    

00801979 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801979:	55                   	push   %ebp
  80197a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80197c:	6a 00                	push   $0x0
  80197e:	6a 00                	push   $0x0
  801980:	6a 00                	push   $0x0
  801982:	6a 00                	push   $0x0
  801984:	6a 00                	push   $0x0
  801986:	6a 13                	push   $0x13
  801988:	e8 13 fe ff ff       	call   8017a0 <syscall>
  80198d:	83 c4 18             	add    $0x18,%esp
}
  801990:	90                   	nop
  801991:	c9                   	leave  
  801992:	c3                   	ret    

00801993 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801993:	55                   	push   %ebp
  801994:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801996:	6a 00                	push   $0x0
  801998:	6a 00                	push   $0x0
  80199a:	6a 00                	push   $0x0
  80199c:	6a 00                	push   $0x0
  80199e:	6a 00                	push   $0x0
  8019a0:	6a 14                	push   $0x14
  8019a2:	e8 f9 fd ff ff       	call   8017a0 <syscall>
  8019a7:	83 c4 18             	add    $0x18,%esp
}
  8019aa:	90                   	nop
  8019ab:	c9                   	leave  
  8019ac:	c3                   	ret    

008019ad <sys_cputc>:


void
sys_cputc(const char c)
{
  8019ad:	55                   	push   %ebp
  8019ae:	89 e5                	mov    %esp,%ebp
  8019b0:	83 ec 04             	sub    $0x4,%esp
  8019b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8019b9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 00                	push   $0x0
  8019c5:	50                   	push   %eax
  8019c6:	6a 15                	push   $0x15
  8019c8:	e8 d3 fd ff ff       	call   8017a0 <syscall>
  8019cd:	83 c4 18             	add    $0x18,%esp
}
  8019d0:	90                   	nop
  8019d1:	c9                   	leave  
  8019d2:	c3                   	ret    

008019d3 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8019d3:	55                   	push   %ebp
  8019d4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8019d6:	6a 00                	push   $0x0
  8019d8:	6a 00                	push   $0x0
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 16                	push   $0x16
  8019e2:	e8 b9 fd ff ff       	call   8017a0 <syscall>
  8019e7:	83 c4 18             	add    $0x18,%esp
}
  8019ea:	90                   	nop
  8019eb:	c9                   	leave  
  8019ec:	c3                   	ret    

008019ed <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8019ed:	55                   	push   %ebp
  8019ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8019f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f3:	6a 00                	push   $0x0
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 00                	push   $0x0
  8019f9:	ff 75 0c             	pushl  0xc(%ebp)
  8019fc:	50                   	push   %eax
  8019fd:	6a 17                	push   $0x17
  8019ff:	e8 9c fd ff ff       	call   8017a0 <syscall>
  801a04:	83 c4 18             	add    $0x18,%esp
}
  801a07:	c9                   	leave  
  801a08:	c3                   	ret    

00801a09 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a09:	55                   	push   %ebp
  801a0a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a0c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a12:	6a 00                	push   $0x0
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	52                   	push   %edx
  801a19:	50                   	push   %eax
  801a1a:	6a 1a                	push   $0x1a
  801a1c:	e8 7f fd ff ff       	call   8017a0 <syscall>
  801a21:	83 c4 18             	add    $0x18,%esp
}
  801a24:	c9                   	leave  
  801a25:	c3                   	ret    

00801a26 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a26:	55                   	push   %ebp
  801a27:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a29:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	52                   	push   %edx
  801a36:	50                   	push   %eax
  801a37:	6a 18                	push   $0x18
  801a39:	e8 62 fd ff ff       	call   8017a0 <syscall>
  801a3e:	83 c4 18             	add    $0x18,%esp
}
  801a41:	90                   	nop
  801a42:	c9                   	leave  
  801a43:	c3                   	ret    

00801a44 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a44:	55                   	push   %ebp
  801a45:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a47:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4d:	6a 00                	push   $0x0
  801a4f:	6a 00                	push   $0x0
  801a51:	6a 00                	push   $0x0
  801a53:	52                   	push   %edx
  801a54:	50                   	push   %eax
  801a55:	6a 19                	push   $0x19
  801a57:	e8 44 fd ff ff       	call   8017a0 <syscall>
  801a5c:	83 c4 18             	add    $0x18,%esp
}
  801a5f:	90                   	nop
  801a60:	c9                   	leave  
  801a61:	c3                   	ret    

00801a62 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a62:	55                   	push   %ebp
  801a63:	89 e5                	mov    %esp,%ebp
  801a65:	83 ec 04             	sub    $0x4,%esp
  801a68:	8b 45 10             	mov    0x10(%ebp),%eax
  801a6b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a6e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a71:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a75:	8b 45 08             	mov    0x8(%ebp),%eax
  801a78:	6a 00                	push   $0x0
  801a7a:	51                   	push   %ecx
  801a7b:	52                   	push   %edx
  801a7c:	ff 75 0c             	pushl  0xc(%ebp)
  801a7f:	50                   	push   %eax
  801a80:	6a 1b                	push   $0x1b
  801a82:	e8 19 fd ff ff       	call   8017a0 <syscall>
  801a87:	83 c4 18             	add    $0x18,%esp
}
  801a8a:	c9                   	leave  
  801a8b:	c3                   	ret    

00801a8c <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801a8c:	55                   	push   %ebp
  801a8d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a92:	8b 45 08             	mov    0x8(%ebp),%eax
  801a95:	6a 00                	push   $0x0
  801a97:	6a 00                	push   $0x0
  801a99:	6a 00                	push   $0x0
  801a9b:	52                   	push   %edx
  801a9c:	50                   	push   %eax
  801a9d:	6a 1c                	push   $0x1c
  801a9f:	e8 fc fc ff ff       	call   8017a0 <syscall>
  801aa4:	83 c4 18             	add    $0x18,%esp
}
  801aa7:	c9                   	leave  
  801aa8:	c3                   	ret    

00801aa9 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801aa9:	55                   	push   %ebp
  801aaa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801aac:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801aaf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab5:	6a 00                	push   $0x0
  801ab7:	6a 00                	push   $0x0
  801ab9:	51                   	push   %ecx
  801aba:	52                   	push   %edx
  801abb:	50                   	push   %eax
  801abc:	6a 1d                	push   $0x1d
  801abe:	e8 dd fc ff ff       	call   8017a0 <syscall>
  801ac3:	83 c4 18             	add    $0x18,%esp
}
  801ac6:	c9                   	leave  
  801ac7:	c3                   	ret    

00801ac8 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801ac8:	55                   	push   %ebp
  801ac9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801acb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ace:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad1:	6a 00                	push   $0x0
  801ad3:	6a 00                	push   $0x0
  801ad5:	6a 00                	push   $0x0
  801ad7:	52                   	push   %edx
  801ad8:	50                   	push   %eax
  801ad9:	6a 1e                	push   $0x1e
  801adb:	e8 c0 fc ff ff       	call   8017a0 <syscall>
  801ae0:	83 c4 18             	add    $0x18,%esp
}
  801ae3:	c9                   	leave  
  801ae4:	c3                   	ret    

00801ae5 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801ae5:	55                   	push   %ebp
  801ae6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 00                	push   $0x0
  801aec:	6a 00                	push   $0x0
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	6a 1f                	push   $0x1f
  801af4:	e8 a7 fc ff ff       	call   8017a0 <syscall>
  801af9:	83 c4 18             	add    $0x18,%esp
}
  801afc:	c9                   	leave  
  801afd:	c3                   	ret    

00801afe <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801afe:	55                   	push   %ebp
  801aff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b01:	8b 45 08             	mov    0x8(%ebp),%eax
  801b04:	6a 00                	push   $0x0
  801b06:	ff 75 14             	pushl  0x14(%ebp)
  801b09:	ff 75 10             	pushl  0x10(%ebp)
  801b0c:	ff 75 0c             	pushl  0xc(%ebp)
  801b0f:	50                   	push   %eax
  801b10:	6a 20                	push   $0x20
  801b12:	e8 89 fc ff ff       	call   8017a0 <syscall>
  801b17:	83 c4 18             	add    $0x18,%esp
}
  801b1a:	c9                   	leave  
  801b1b:	c3                   	ret    

00801b1c <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801b1c:	55                   	push   %ebp
  801b1d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b22:	6a 00                	push   $0x0
  801b24:	6a 00                	push   $0x0
  801b26:	6a 00                	push   $0x0
  801b28:	6a 00                	push   $0x0
  801b2a:	50                   	push   %eax
  801b2b:	6a 21                	push   $0x21
  801b2d:	e8 6e fc ff ff       	call   8017a0 <syscall>
  801b32:	83 c4 18             	add    $0x18,%esp
}
  801b35:	90                   	nop
  801b36:	c9                   	leave  
  801b37:	c3                   	ret    

00801b38 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b38:	55                   	push   %ebp
  801b39:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 00                	push   $0x0
  801b42:	6a 00                	push   $0x0
  801b44:	6a 00                	push   $0x0
  801b46:	50                   	push   %eax
  801b47:	6a 22                	push   $0x22
  801b49:	e8 52 fc ff ff       	call   8017a0 <syscall>
  801b4e:	83 c4 18             	add    $0x18,%esp
}
  801b51:	c9                   	leave  
  801b52:	c3                   	ret    

00801b53 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b53:	55                   	push   %ebp
  801b54:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b56:	6a 00                	push   $0x0
  801b58:	6a 00                	push   $0x0
  801b5a:	6a 00                	push   $0x0
  801b5c:	6a 00                	push   $0x0
  801b5e:	6a 00                	push   $0x0
  801b60:	6a 02                	push   $0x2
  801b62:	e8 39 fc ff ff       	call   8017a0 <syscall>
  801b67:	83 c4 18             	add    $0x18,%esp
}
  801b6a:	c9                   	leave  
  801b6b:	c3                   	ret    

00801b6c <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b6c:	55                   	push   %ebp
  801b6d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 00                	push   $0x0
  801b73:	6a 00                	push   $0x0
  801b75:	6a 00                	push   $0x0
  801b77:	6a 00                	push   $0x0
  801b79:	6a 03                	push   $0x3
  801b7b:	e8 20 fc ff ff       	call   8017a0 <syscall>
  801b80:	83 c4 18             	add    $0x18,%esp
}
  801b83:	c9                   	leave  
  801b84:	c3                   	ret    

00801b85 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b85:	55                   	push   %ebp
  801b86:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b88:	6a 00                	push   $0x0
  801b8a:	6a 00                	push   $0x0
  801b8c:	6a 00                	push   $0x0
  801b8e:	6a 00                	push   $0x0
  801b90:	6a 00                	push   $0x0
  801b92:	6a 04                	push   $0x4
  801b94:	e8 07 fc ff ff       	call   8017a0 <syscall>
  801b99:	83 c4 18             	add    $0x18,%esp
}
  801b9c:	c9                   	leave  
  801b9d:	c3                   	ret    

00801b9e <sys_exit_env>:


void sys_exit_env(void)
{
  801b9e:	55                   	push   %ebp
  801b9f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801ba1:	6a 00                	push   $0x0
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 23                	push   $0x23
  801bad:	e8 ee fb ff ff       	call   8017a0 <syscall>
  801bb2:	83 c4 18             	add    $0x18,%esp
}
  801bb5:	90                   	nop
  801bb6:	c9                   	leave  
  801bb7:	c3                   	ret    

00801bb8 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801bb8:	55                   	push   %ebp
  801bb9:	89 e5                	mov    %esp,%ebp
  801bbb:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801bbe:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801bc1:	8d 50 04             	lea    0x4(%eax),%edx
  801bc4:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 00                	push   $0x0
  801bcb:	6a 00                	push   $0x0
  801bcd:	52                   	push   %edx
  801bce:	50                   	push   %eax
  801bcf:	6a 24                	push   $0x24
  801bd1:	e8 ca fb ff ff       	call   8017a0 <syscall>
  801bd6:	83 c4 18             	add    $0x18,%esp
	return result;
  801bd9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801bdc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bdf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801be2:	89 01                	mov    %eax,(%ecx)
  801be4:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801be7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bea:	c9                   	leave  
  801beb:	c2 04 00             	ret    $0x4

00801bee <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801bee:	55                   	push   %ebp
  801bef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801bf1:	6a 00                	push   $0x0
  801bf3:	6a 00                	push   $0x0
  801bf5:	ff 75 10             	pushl  0x10(%ebp)
  801bf8:	ff 75 0c             	pushl  0xc(%ebp)
  801bfb:	ff 75 08             	pushl  0x8(%ebp)
  801bfe:	6a 12                	push   $0x12
  801c00:	e8 9b fb ff ff       	call   8017a0 <syscall>
  801c05:	83 c4 18             	add    $0x18,%esp
	return ;
  801c08:	90                   	nop
}
  801c09:	c9                   	leave  
  801c0a:	c3                   	ret    

00801c0b <sys_rcr2>:
uint32 sys_rcr2()
{
  801c0b:	55                   	push   %ebp
  801c0c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c0e:	6a 00                	push   $0x0
  801c10:	6a 00                	push   $0x0
  801c12:	6a 00                	push   $0x0
  801c14:	6a 00                	push   $0x0
  801c16:	6a 00                	push   $0x0
  801c18:	6a 25                	push   $0x25
  801c1a:	e8 81 fb ff ff       	call   8017a0 <syscall>
  801c1f:	83 c4 18             	add    $0x18,%esp
}
  801c22:	c9                   	leave  
  801c23:	c3                   	ret    

00801c24 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801c24:	55                   	push   %ebp
  801c25:	89 e5                	mov    %esp,%ebp
  801c27:	83 ec 04             	sub    $0x4,%esp
  801c2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c30:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c34:	6a 00                	push   $0x0
  801c36:	6a 00                	push   $0x0
  801c38:	6a 00                	push   $0x0
  801c3a:	6a 00                	push   $0x0
  801c3c:	50                   	push   %eax
  801c3d:	6a 26                	push   $0x26
  801c3f:	e8 5c fb ff ff       	call   8017a0 <syscall>
  801c44:	83 c4 18             	add    $0x18,%esp
	return ;
  801c47:	90                   	nop
}
  801c48:	c9                   	leave  
  801c49:	c3                   	ret    

00801c4a <rsttst>:
void rsttst()
{
  801c4a:	55                   	push   %ebp
  801c4b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c4d:	6a 00                	push   $0x0
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	6a 00                	push   $0x0
  801c57:	6a 28                	push   $0x28
  801c59:	e8 42 fb ff ff       	call   8017a0 <syscall>
  801c5e:	83 c4 18             	add    $0x18,%esp
	return ;
  801c61:	90                   	nop
}
  801c62:	c9                   	leave  
  801c63:	c3                   	ret    

00801c64 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c64:	55                   	push   %ebp
  801c65:	89 e5                	mov    %esp,%ebp
  801c67:	83 ec 04             	sub    $0x4,%esp
  801c6a:	8b 45 14             	mov    0x14(%ebp),%eax
  801c6d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c70:	8b 55 18             	mov    0x18(%ebp),%edx
  801c73:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c77:	52                   	push   %edx
  801c78:	50                   	push   %eax
  801c79:	ff 75 10             	pushl  0x10(%ebp)
  801c7c:	ff 75 0c             	pushl  0xc(%ebp)
  801c7f:	ff 75 08             	pushl  0x8(%ebp)
  801c82:	6a 27                	push   $0x27
  801c84:	e8 17 fb ff ff       	call   8017a0 <syscall>
  801c89:	83 c4 18             	add    $0x18,%esp
	return ;
  801c8c:	90                   	nop
}
  801c8d:	c9                   	leave  
  801c8e:	c3                   	ret    

00801c8f <chktst>:
void chktst(uint32 n)
{
  801c8f:	55                   	push   %ebp
  801c90:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c92:	6a 00                	push   $0x0
  801c94:	6a 00                	push   $0x0
  801c96:	6a 00                	push   $0x0
  801c98:	6a 00                	push   $0x0
  801c9a:	ff 75 08             	pushl  0x8(%ebp)
  801c9d:	6a 29                	push   $0x29
  801c9f:	e8 fc fa ff ff       	call   8017a0 <syscall>
  801ca4:	83 c4 18             	add    $0x18,%esp
	return ;
  801ca7:	90                   	nop
}
  801ca8:	c9                   	leave  
  801ca9:	c3                   	ret    

00801caa <inctst>:

void inctst()
{
  801caa:	55                   	push   %ebp
  801cab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801cad:	6a 00                	push   $0x0
  801caf:	6a 00                	push   $0x0
  801cb1:	6a 00                	push   $0x0
  801cb3:	6a 00                	push   $0x0
  801cb5:	6a 00                	push   $0x0
  801cb7:	6a 2a                	push   $0x2a
  801cb9:	e8 e2 fa ff ff       	call   8017a0 <syscall>
  801cbe:	83 c4 18             	add    $0x18,%esp
	return ;
  801cc1:	90                   	nop
}
  801cc2:	c9                   	leave  
  801cc3:	c3                   	ret    

00801cc4 <gettst>:
uint32 gettst()
{
  801cc4:	55                   	push   %ebp
  801cc5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801cc7:	6a 00                	push   $0x0
  801cc9:	6a 00                	push   $0x0
  801ccb:	6a 00                	push   $0x0
  801ccd:	6a 00                	push   $0x0
  801ccf:	6a 00                	push   $0x0
  801cd1:	6a 2b                	push   $0x2b
  801cd3:	e8 c8 fa ff ff       	call   8017a0 <syscall>
  801cd8:	83 c4 18             	add    $0x18,%esp
}
  801cdb:	c9                   	leave  
  801cdc:	c3                   	ret    

00801cdd <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801cdd:	55                   	push   %ebp
  801cde:	89 e5                	mov    %esp,%ebp
  801ce0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ce3:	6a 00                	push   $0x0
  801ce5:	6a 00                	push   $0x0
  801ce7:	6a 00                	push   $0x0
  801ce9:	6a 00                	push   $0x0
  801ceb:	6a 00                	push   $0x0
  801ced:	6a 2c                	push   $0x2c
  801cef:	e8 ac fa ff ff       	call   8017a0 <syscall>
  801cf4:	83 c4 18             	add    $0x18,%esp
  801cf7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801cfa:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801cfe:	75 07                	jne    801d07 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d00:	b8 01 00 00 00       	mov    $0x1,%eax
  801d05:	eb 05                	jmp    801d0c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d07:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d0c:	c9                   	leave  
  801d0d:	c3                   	ret    

00801d0e <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d0e:	55                   	push   %ebp
  801d0f:	89 e5                	mov    %esp,%ebp
  801d11:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d14:	6a 00                	push   $0x0
  801d16:	6a 00                	push   $0x0
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 00                	push   $0x0
  801d1e:	6a 2c                	push   $0x2c
  801d20:	e8 7b fa ff ff       	call   8017a0 <syscall>
  801d25:	83 c4 18             	add    $0x18,%esp
  801d28:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d2b:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d2f:	75 07                	jne    801d38 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d31:	b8 01 00 00 00       	mov    $0x1,%eax
  801d36:	eb 05                	jmp    801d3d <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d38:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d3d:	c9                   	leave  
  801d3e:	c3                   	ret    

00801d3f <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d3f:	55                   	push   %ebp
  801d40:	89 e5                	mov    %esp,%ebp
  801d42:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d45:	6a 00                	push   $0x0
  801d47:	6a 00                	push   $0x0
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 00                	push   $0x0
  801d4d:	6a 00                	push   $0x0
  801d4f:	6a 2c                	push   $0x2c
  801d51:	e8 4a fa ff ff       	call   8017a0 <syscall>
  801d56:	83 c4 18             	add    $0x18,%esp
  801d59:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801d5c:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d60:	75 07                	jne    801d69 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801d62:	b8 01 00 00 00       	mov    $0x1,%eax
  801d67:	eb 05                	jmp    801d6e <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801d69:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d6e:	c9                   	leave  
  801d6f:	c3                   	ret    

00801d70 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801d70:	55                   	push   %ebp
  801d71:	89 e5                	mov    %esp,%ebp
  801d73:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d76:	6a 00                	push   $0x0
  801d78:	6a 00                	push   $0x0
  801d7a:	6a 00                	push   $0x0
  801d7c:	6a 00                	push   $0x0
  801d7e:	6a 00                	push   $0x0
  801d80:	6a 2c                	push   $0x2c
  801d82:	e8 19 fa ff ff       	call   8017a0 <syscall>
  801d87:	83 c4 18             	add    $0x18,%esp
  801d8a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801d8d:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801d91:	75 07                	jne    801d9a <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801d93:	b8 01 00 00 00       	mov    $0x1,%eax
  801d98:	eb 05                	jmp    801d9f <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801d9a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d9f:	c9                   	leave  
  801da0:	c3                   	ret    

00801da1 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801da1:	55                   	push   %ebp
  801da2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801da4:	6a 00                	push   $0x0
  801da6:	6a 00                	push   $0x0
  801da8:	6a 00                	push   $0x0
  801daa:	6a 00                	push   $0x0
  801dac:	ff 75 08             	pushl  0x8(%ebp)
  801daf:	6a 2d                	push   $0x2d
  801db1:	e8 ea f9 ff ff       	call   8017a0 <syscall>
  801db6:	83 c4 18             	add    $0x18,%esp
	return ;
  801db9:	90                   	nop
}
  801dba:	c9                   	leave  
  801dbb:	c3                   	ret    

00801dbc <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801dbc:	55                   	push   %ebp
  801dbd:	89 e5                	mov    %esp,%ebp
  801dbf:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801dc0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801dc3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801dc6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dcc:	6a 00                	push   $0x0
  801dce:	53                   	push   %ebx
  801dcf:	51                   	push   %ecx
  801dd0:	52                   	push   %edx
  801dd1:	50                   	push   %eax
  801dd2:	6a 2e                	push   $0x2e
  801dd4:	e8 c7 f9 ff ff       	call   8017a0 <syscall>
  801dd9:	83 c4 18             	add    $0x18,%esp
}
  801ddc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ddf:	c9                   	leave  
  801de0:	c3                   	ret    

00801de1 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801de1:	55                   	push   %ebp
  801de2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801de4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801de7:	8b 45 08             	mov    0x8(%ebp),%eax
  801dea:	6a 00                	push   $0x0
  801dec:	6a 00                	push   $0x0
  801dee:	6a 00                	push   $0x0
  801df0:	52                   	push   %edx
  801df1:	50                   	push   %eax
  801df2:	6a 2f                	push   $0x2f
  801df4:	e8 a7 f9 ff ff       	call   8017a0 <syscall>
  801df9:	83 c4 18             	add    $0x18,%esp
}
  801dfc:	c9                   	leave  
  801dfd:	c3                   	ret    

00801dfe <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801dfe:	55                   	push   %ebp
  801dff:	89 e5                	mov    %esp,%ebp
  801e01:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801e04:	83 ec 0c             	sub    $0xc,%esp
  801e07:	68 c4 3f 80 00       	push   $0x803fc4
  801e0c:	e8 8c e7 ff ff       	call   80059d <cprintf>
  801e11:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801e14:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801e1b:	83 ec 0c             	sub    $0xc,%esp
  801e1e:	68 f0 3f 80 00       	push   $0x803ff0
  801e23:	e8 75 e7 ff ff       	call   80059d <cprintf>
  801e28:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801e2b:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e2f:	a1 38 51 80 00       	mov    0x805138,%eax
  801e34:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e37:	eb 56                	jmp    801e8f <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e39:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e3d:	74 1c                	je     801e5b <print_mem_block_lists+0x5d>
  801e3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e42:	8b 50 08             	mov    0x8(%eax),%edx
  801e45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e48:	8b 48 08             	mov    0x8(%eax),%ecx
  801e4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e4e:	8b 40 0c             	mov    0xc(%eax),%eax
  801e51:	01 c8                	add    %ecx,%eax
  801e53:	39 c2                	cmp    %eax,%edx
  801e55:	73 04                	jae    801e5b <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801e57:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e5e:	8b 50 08             	mov    0x8(%eax),%edx
  801e61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e64:	8b 40 0c             	mov    0xc(%eax),%eax
  801e67:	01 c2                	add    %eax,%edx
  801e69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e6c:	8b 40 08             	mov    0x8(%eax),%eax
  801e6f:	83 ec 04             	sub    $0x4,%esp
  801e72:	52                   	push   %edx
  801e73:	50                   	push   %eax
  801e74:	68 05 40 80 00       	push   $0x804005
  801e79:	e8 1f e7 ff ff       	call   80059d <cprintf>
  801e7e:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e84:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e87:	a1 40 51 80 00       	mov    0x805140,%eax
  801e8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e8f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e93:	74 07                	je     801e9c <print_mem_block_lists+0x9e>
  801e95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e98:	8b 00                	mov    (%eax),%eax
  801e9a:	eb 05                	jmp    801ea1 <print_mem_block_lists+0xa3>
  801e9c:	b8 00 00 00 00       	mov    $0x0,%eax
  801ea1:	a3 40 51 80 00       	mov    %eax,0x805140
  801ea6:	a1 40 51 80 00       	mov    0x805140,%eax
  801eab:	85 c0                	test   %eax,%eax
  801ead:	75 8a                	jne    801e39 <print_mem_block_lists+0x3b>
  801eaf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801eb3:	75 84                	jne    801e39 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801eb5:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801eb9:	75 10                	jne    801ecb <print_mem_block_lists+0xcd>
  801ebb:	83 ec 0c             	sub    $0xc,%esp
  801ebe:	68 14 40 80 00       	push   $0x804014
  801ec3:	e8 d5 e6 ff ff       	call   80059d <cprintf>
  801ec8:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801ecb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801ed2:	83 ec 0c             	sub    $0xc,%esp
  801ed5:	68 38 40 80 00       	push   $0x804038
  801eda:	e8 be e6 ff ff       	call   80059d <cprintf>
  801edf:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801ee2:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801ee6:	a1 40 50 80 00       	mov    0x805040,%eax
  801eeb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801eee:	eb 56                	jmp    801f46 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801ef0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ef4:	74 1c                	je     801f12 <print_mem_block_lists+0x114>
  801ef6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef9:	8b 50 08             	mov    0x8(%eax),%edx
  801efc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eff:	8b 48 08             	mov    0x8(%eax),%ecx
  801f02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f05:	8b 40 0c             	mov    0xc(%eax),%eax
  801f08:	01 c8                	add    %ecx,%eax
  801f0a:	39 c2                	cmp    %eax,%edx
  801f0c:	73 04                	jae    801f12 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801f0e:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f15:	8b 50 08             	mov    0x8(%eax),%edx
  801f18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f1b:	8b 40 0c             	mov    0xc(%eax),%eax
  801f1e:	01 c2                	add    %eax,%edx
  801f20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f23:	8b 40 08             	mov    0x8(%eax),%eax
  801f26:	83 ec 04             	sub    $0x4,%esp
  801f29:	52                   	push   %edx
  801f2a:	50                   	push   %eax
  801f2b:	68 05 40 80 00       	push   $0x804005
  801f30:	e8 68 e6 ff ff       	call   80059d <cprintf>
  801f35:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f3e:	a1 48 50 80 00       	mov    0x805048,%eax
  801f43:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f46:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f4a:	74 07                	je     801f53 <print_mem_block_lists+0x155>
  801f4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f4f:	8b 00                	mov    (%eax),%eax
  801f51:	eb 05                	jmp    801f58 <print_mem_block_lists+0x15a>
  801f53:	b8 00 00 00 00       	mov    $0x0,%eax
  801f58:	a3 48 50 80 00       	mov    %eax,0x805048
  801f5d:	a1 48 50 80 00       	mov    0x805048,%eax
  801f62:	85 c0                	test   %eax,%eax
  801f64:	75 8a                	jne    801ef0 <print_mem_block_lists+0xf2>
  801f66:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f6a:	75 84                	jne    801ef0 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801f6c:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f70:	75 10                	jne    801f82 <print_mem_block_lists+0x184>
  801f72:	83 ec 0c             	sub    $0xc,%esp
  801f75:	68 50 40 80 00       	push   $0x804050
  801f7a:	e8 1e e6 ff ff       	call   80059d <cprintf>
  801f7f:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801f82:	83 ec 0c             	sub    $0xc,%esp
  801f85:	68 c4 3f 80 00       	push   $0x803fc4
  801f8a:	e8 0e e6 ff ff       	call   80059d <cprintf>
  801f8f:	83 c4 10             	add    $0x10,%esp

}
  801f92:	90                   	nop
  801f93:	c9                   	leave  
  801f94:	c3                   	ret    

00801f95 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801f95:	55                   	push   %ebp
  801f96:	89 e5                	mov    %esp,%ebp
  801f98:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801f9b:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  801fa2:	00 00 00 
  801fa5:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  801fac:	00 00 00 
  801faf:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  801fb6:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801fb9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801fc0:	e9 9e 00 00 00       	jmp    802063 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801fc5:	a1 50 50 80 00       	mov    0x805050,%eax
  801fca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fcd:	c1 e2 04             	shl    $0x4,%edx
  801fd0:	01 d0                	add    %edx,%eax
  801fd2:	85 c0                	test   %eax,%eax
  801fd4:	75 14                	jne    801fea <initialize_MemBlocksList+0x55>
  801fd6:	83 ec 04             	sub    $0x4,%esp
  801fd9:	68 78 40 80 00       	push   $0x804078
  801fde:	6a 46                	push   $0x46
  801fe0:	68 9b 40 80 00       	push   $0x80409b
  801fe5:	e8 ff e2 ff ff       	call   8002e9 <_panic>
  801fea:	a1 50 50 80 00       	mov    0x805050,%eax
  801fef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ff2:	c1 e2 04             	shl    $0x4,%edx
  801ff5:	01 d0                	add    %edx,%eax
  801ff7:	8b 15 48 51 80 00    	mov    0x805148,%edx
  801ffd:	89 10                	mov    %edx,(%eax)
  801fff:	8b 00                	mov    (%eax),%eax
  802001:	85 c0                	test   %eax,%eax
  802003:	74 18                	je     80201d <initialize_MemBlocksList+0x88>
  802005:	a1 48 51 80 00       	mov    0x805148,%eax
  80200a:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802010:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802013:	c1 e1 04             	shl    $0x4,%ecx
  802016:	01 ca                	add    %ecx,%edx
  802018:	89 50 04             	mov    %edx,0x4(%eax)
  80201b:	eb 12                	jmp    80202f <initialize_MemBlocksList+0x9a>
  80201d:	a1 50 50 80 00       	mov    0x805050,%eax
  802022:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802025:	c1 e2 04             	shl    $0x4,%edx
  802028:	01 d0                	add    %edx,%eax
  80202a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80202f:	a1 50 50 80 00       	mov    0x805050,%eax
  802034:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802037:	c1 e2 04             	shl    $0x4,%edx
  80203a:	01 d0                	add    %edx,%eax
  80203c:	a3 48 51 80 00       	mov    %eax,0x805148
  802041:	a1 50 50 80 00       	mov    0x805050,%eax
  802046:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802049:	c1 e2 04             	shl    $0x4,%edx
  80204c:	01 d0                	add    %edx,%eax
  80204e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802055:	a1 54 51 80 00       	mov    0x805154,%eax
  80205a:	40                   	inc    %eax
  80205b:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802060:	ff 45 f4             	incl   -0xc(%ebp)
  802063:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802066:	3b 45 08             	cmp    0x8(%ebp),%eax
  802069:	0f 82 56 ff ff ff    	jb     801fc5 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  80206f:	90                   	nop
  802070:	c9                   	leave  
  802071:	c3                   	ret    

00802072 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802072:	55                   	push   %ebp
  802073:	89 e5                	mov    %esp,%ebp
  802075:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802078:	8b 45 08             	mov    0x8(%ebp),%eax
  80207b:	8b 00                	mov    (%eax),%eax
  80207d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802080:	eb 19                	jmp    80209b <find_block+0x29>
	{
		if(va==point->sva)
  802082:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802085:	8b 40 08             	mov    0x8(%eax),%eax
  802088:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80208b:	75 05                	jne    802092 <find_block+0x20>
		   return point;
  80208d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802090:	eb 36                	jmp    8020c8 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802092:	8b 45 08             	mov    0x8(%ebp),%eax
  802095:	8b 40 08             	mov    0x8(%eax),%eax
  802098:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80209b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80209f:	74 07                	je     8020a8 <find_block+0x36>
  8020a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020a4:	8b 00                	mov    (%eax),%eax
  8020a6:	eb 05                	jmp    8020ad <find_block+0x3b>
  8020a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8020b0:	89 42 08             	mov    %eax,0x8(%edx)
  8020b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b6:	8b 40 08             	mov    0x8(%eax),%eax
  8020b9:	85 c0                	test   %eax,%eax
  8020bb:	75 c5                	jne    802082 <find_block+0x10>
  8020bd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020c1:	75 bf                	jne    802082 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  8020c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020c8:	c9                   	leave  
  8020c9:	c3                   	ret    

008020ca <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8020ca:	55                   	push   %ebp
  8020cb:	89 e5                	mov    %esp,%ebp
  8020cd:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8020d0:	a1 40 50 80 00       	mov    0x805040,%eax
  8020d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8020d8:	a1 44 50 80 00       	mov    0x805044,%eax
  8020dd:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8020e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020e3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8020e6:	74 24                	je     80210c <insert_sorted_allocList+0x42>
  8020e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020eb:	8b 50 08             	mov    0x8(%eax),%edx
  8020ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020f1:	8b 40 08             	mov    0x8(%eax),%eax
  8020f4:	39 c2                	cmp    %eax,%edx
  8020f6:	76 14                	jbe    80210c <insert_sorted_allocList+0x42>
  8020f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fb:	8b 50 08             	mov    0x8(%eax),%edx
  8020fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802101:	8b 40 08             	mov    0x8(%eax),%eax
  802104:	39 c2                	cmp    %eax,%edx
  802106:	0f 82 60 01 00 00    	jb     80226c <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  80210c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802110:	75 65                	jne    802177 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802112:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802116:	75 14                	jne    80212c <insert_sorted_allocList+0x62>
  802118:	83 ec 04             	sub    $0x4,%esp
  80211b:	68 78 40 80 00       	push   $0x804078
  802120:	6a 6b                	push   $0x6b
  802122:	68 9b 40 80 00       	push   $0x80409b
  802127:	e8 bd e1 ff ff       	call   8002e9 <_panic>
  80212c:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802132:	8b 45 08             	mov    0x8(%ebp),%eax
  802135:	89 10                	mov    %edx,(%eax)
  802137:	8b 45 08             	mov    0x8(%ebp),%eax
  80213a:	8b 00                	mov    (%eax),%eax
  80213c:	85 c0                	test   %eax,%eax
  80213e:	74 0d                	je     80214d <insert_sorted_allocList+0x83>
  802140:	a1 40 50 80 00       	mov    0x805040,%eax
  802145:	8b 55 08             	mov    0x8(%ebp),%edx
  802148:	89 50 04             	mov    %edx,0x4(%eax)
  80214b:	eb 08                	jmp    802155 <insert_sorted_allocList+0x8b>
  80214d:	8b 45 08             	mov    0x8(%ebp),%eax
  802150:	a3 44 50 80 00       	mov    %eax,0x805044
  802155:	8b 45 08             	mov    0x8(%ebp),%eax
  802158:	a3 40 50 80 00       	mov    %eax,0x805040
  80215d:	8b 45 08             	mov    0x8(%ebp),%eax
  802160:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802167:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80216c:	40                   	inc    %eax
  80216d:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802172:	e9 dc 01 00 00       	jmp    802353 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802177:	8b 45 08             	mov    0x8(%ebp),%eax
  80217a:	8b 50 08             	mov    0x8(%eax),%edx
  80217d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802180:	8b 40 08             	mov    0x8(%eax),%eax
  802183:	39 c2                	cmp    %eax,%edx
  802185:	77 6c                	ja     8021f3 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802187:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80218b:	74 06                	je     802193 <insert_sorted_allocList+0xc9>
  80218d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802191:	75 14                	jne    8021a7 <insert_sorted_allocList+0xdd>
  802193:	83 ec 04             	sub    $0x4,%esp
  802196:	68 b4 40 80 00       	push   $0x8040b4
  80219b:	6a 6f                	push   $0x6f
  80219d:	68 9b 40 80 00       	push   $0x80409b
  8021a2:	e8 42 e1 ff ff       	call   8002e9 <_panic>
  8021a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021aa:	8b 50 04             	mov    0x4(%eax),%edx
  8021ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b0:	89 50 04             	mov    %edx,0x4(%eax)
  8021b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021b9:	89 10                	mov    %edx,(%eax)
  8021bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021be:	8b 40 04             	mov    0x4(%eax),%eax
  8021c1:	85 c0                	test   %eax,%eax
  8021c3:	74 0d                	je     8021d2 <insert_sorted_allocList+0x108>
  8021c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021c8:	8b 40 04             	mov    0x4(%eax),%eax
  8021cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8021ce:	89 10                	mov    %edx,(%eax)
  8021d0:	eb 08                	jmp    8021da <insert_sorted_allocList+0x110>
  8021d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d5:	a3 40 50 80 00       	mov    %eax,0x805040
  8021da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8021e0:	89 50 04             	mov    %edx,0x4(%eax)
  8021e3:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8021e8:	40                   	inc    %eax
  8021e9:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8021ee:	e9 60 01 00 00       	jmp    802353 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8021f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f6:	8b 50 08             	mov    0x8(%eax),%edx
  8021f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021fc:	8b 40 08             	mov    0x8(%eax),%eax
  8021ff:	39 c2                	cmp    %eax,%edx
  802201:	0f 82 4c 01 00 00    	jb     802353 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802207:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80220b:	75 14                	jne    802221 <insert_sorted_allocList+0x157>
  80220d:	83 ec 04             	sub    $0x4,%esp
  802210:	68 ec 40 80 00       	push   $0x8040ec
  802215:	6a 73                	push   $0x73
  802217:	68 9b 40 80 00       	push   $0x80409b
  80221c:	e8 c8 e0 ff ff       	call   8002e9 <_panic>
  802221:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802227:	8b 45 08             	mov    0x8(%ebp),%eax
  80222a:	89 50 04             	mov    %edx,0x4(%eax)
  80222d:	8b 45 08             	mov    0x8(%ebp),%eax
  802230:	8b 40 04             	mov    0x4(%eax),%eax
  802233:	85 c0                	test   %eax,%eax
  802235:	74 0c                	je     802243 <insert_sorted_allocList+0x179>
  802237:	a1 44 50 80 00       	mov    0x805044,%eax
  80223c:	8b 55 08             	mov    0x8(%ebp),%edx
  80223f:	89 10                	mov    %edx,(%eax)
  802241:	eb 08                	jmp    80224b <insert_sorted_allocList+0x181>
  802243:	8b 45 08             	mov    0x8(%ebp),%eax
  802246:	a3 40 50 80 00       	mov    %eax,0x805040
  80224b:	8b 45 08             	mov    0x8(%ebp),%eax
  80224e:	a3 44 50 80 00       	mov    %eax,0x805044
  802253:	8b 45 08             	mov    0x8(%ebp),%eax
  802256:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80225c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802261:	40                   	inc    %eax
  802262:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802267:	e9 e7 00 00 00       	jmp    802353 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  80226c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80226f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802272:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802279:	a1 40 50 80 00       	mov    0x805040,%eax
  80227e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802281:	e9 9d 00 00 00       	jmp    802323 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802286:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802289:	8b 00                	mov    (%eax),%eax
  80228b:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  80228e:	8b 45 08             	mov    0x8(%ebp),%eax
  802291:	8b 50 08             	mov    0x8(%eax),%edx
  802294:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802297:	8b 40 08             	mov    0x8(%eax),%eax
  80229a:	39 c2                	cmp    %eax,%edx
  80229c:	76 7d                	jbe    80231b <insert_sorted_allocList+0x251>
  80229e:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a1:	8b 50 08             	mov    0x8(%eax),%edx
  8022a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022a7:	8b 40 08             	mov    0x8(%eax),%eax
  8022aa:	39 c2                	cmp    %eax,%edx
  8022ac:	73 6d                	jae    80231b <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8022ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022b2:	74 06                	je     8022ba <insert_sorted_allocList+0x1f0>
  8022b4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022b8:	75 14                	jne    8022ce <insert_sorted_allocList+0x204>
  8022ba:	83 ec 04             	sub    $0x4,%esp
  8022bd:	68 10 41 80 00       	push   $0x804110
  8022c2:	6a 7f                	push   $0x7f
  8022c4:	68 9b 40 80 00       	push   $0x80409b
  8022c9:	e8 1b e0 ff ff       	call   8002e9 <_panic>
  8022ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d1:	8b 10                	mov    (%eax),%edx
  8022d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d6:	89 10                	mov    %edx,(%eax)
  8022d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022db:	8b 00                	mov    (%eax),%eax
  8022dd:	85 c0                	test   %eax,%eax
  8022df:	74 0b                	je     8022ec <insert_sorted_allocList+0x222>
  8022e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e4:	8b 00                	mov    (%eax),%eax
  8022e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8022e9:	89 50 04             	mov    %edx,0x4(%eax)
  8022ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8022f2:	89 10                	mov    %edx,(%eax)
  8022f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022fa:	89 50 04             	mov    %edx,0x4(%eax)
  8022fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802300:	8b 00                	mov    (%eax),%eax
  802302:	85 c0                	test   %eax,%eax
  802304:	75 08                	jne    80230e <insert_sorted_allocList+0x244>
  802306:	8b 45 08             	mov    0x8(%ebp),%eax
  802309:	a3 44 50 80 00       	mov    %eax,0x805044
  80230e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802313:	40                   	inc    %eax
  802314:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802319:	eb 39                	jmp    802354 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80231b:	a1 48 50 80 00       	mov    0x805048,%eax
  802320:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802323:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802327:	74 07                	je     802330 <insert_sorted_allocList+0x266>
  802329:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232c:	8b 00                	mov    (%eax),%eax
  80232e:	eb 05                	jmp    802335 <insert_sorted_allocList+0x26b>
  802330:	b8 00 00 00 00       	mov    $0x0,%eax
  802335:	a3 48 50 80 00       	mov    %eax,0x805048
  80233a:	a1 48 50 80 00       	mov    0x805048,%eax
  80233f:	85 c0                	test   %eax,%eax
  802341:	0f 85 3f ff ff ff    	jne    802286 <insert_sorted_allocList+0x1bc>
  802347:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80234b:	0f 85 35 ff ff ff    	jne    802286 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802351:	eb 01                	jmp    802354 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802353:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802354:	90                   	nop
  802355:	c9                   	leave  
  802356:	c3                   	ret    

00802357 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802357:	55                   	push   %ebp
  802358:	89 e5                	mov    %esp,%ebp
  80235a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80235d:	a1 38 51 80 00       	mov    0x805138,%eax
  802362:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802365:	e9 85 01 00 00       	jmp    8024ef <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  80236a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236d:	8b 40 0c             	mov    0xc(%eax),%eax
  802370:	3b 45 08             	cmp    0x8(%ebp),%eax
  802373:	0f 82 6e 01 00 00    	jb     8024e7 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802379:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237c:	8b 40 0c             	mov    0xc(%eax),%eax
  80237f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802382:	0f 85 8a 00 00 00    	jne    802412 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802388:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80238c:	75 17                	jne    8023a5 <alloc_block_FF+0x4e>
  80238e:	83 ec 04             	sub    $0x4,%esp
  802391:	68 44 41 80 00       	push   $0x804144
  802396:	68 93 00 00 00       	push   $0x93
  80239b:	68 9b 40 80 00       	push   $0x80409b
  8023a0:	e8 44 df ff ff       	call   8002e9 <_panic>
  8023a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a8:	8b 00                	mov    (%eax),%eax
  8023aa:	85 c0                	test   %eax,%eax
  8023ac:	74 10                	je     8023be <alloc_block_FF+0x67>
  8023ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b1:	8b 00                	mov    (%eax),%eax
  8023b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023b6:	8b 52 04             	mov    0x4(%edx),%edx
  8023b9:	89 50 04             	mov    %edx,0x4(%eax)
  8023bc:	eb 0b                	jmp    8023c9 <alloc_block_FF+0x72>
  8023be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c1:	8b 40 04             	mov    0x4(%eax),%eax
  8023c4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8023c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cc:	8b 40 04             	mov    0x4(%eax),%eax
  8023cf:	85 c0                	test   %eax,%eax
  8023d1:	74 0f                	je     8023e2 <alloc_block_FF+0x8b>
  8023d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d6:	8b 40 04             	mov    0x4(%eax),%eax
  8023d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023dc:	8b 12                	mov    (%edx),%edx
  8023de:	89 10                	mov    %edx,(%eax)
  8023e0:	eb 0a                	jmp    8023ec <alloc_block_FF+0x95>
  8023e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e5:	8b 00                	mov    (%eax),%eax
  8023e7:	a3 38 51 80 00       	mov    %eax,0x805138
  8023ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023ff:	a1 44 51 80 00       	mov    0x805144,%eax
  802404:	48                   	dec    %eax
  802405:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  80240a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240d:	e9 10 01 00 00       	jmp    802522 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802412:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802415:	8b 40 0c             	mov    0xc(%eax),%eax
  802418:	3b 45 08             	cmp    0x8(%ebp),%eax
  80241b:	0f 86 c6 00 00 00    	jbe    8024e7 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802421:	a1 48 51 80 00       	mov    0x805148,%eax
  802426:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802429:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242c:	8b 50 08             	mov    0x8(%eax),%edx
  80242f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802432:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802435:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802438:	8b 55 08             	mov    0x8(%ebp),%edx
  80243b:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80243e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802442:	75 17                	jne    80245b <alloc_block_FF+0x104>
  802444:	83 ec 04             	sub    $0x4,%esp
  802447:	68 44 41 80 00       	push   $0x804144
  80244c:	68 9b 00 00 00       	push   $0x9b
  802451:	68 9b 40 80 00       	push   $0x80409b
  802456:	e8 8e de ff ff       	call   8002e9 <_panic>
  80245b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80245e:	8b 00                	mov    (%eax),%eax
  802460:	85 c0                	test   %eax,%eax
  802462:	74 10                	je     802474 <alloc_block_FF+0x11d>
  802464:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802467:	8b 00                	mov    (%eax),%eax
  802469:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80246c:	8b 52 04             	mov    0x4(%edx),%edx
  80246f:	89 50 04             	mov    %edx,0x4(%eax)
  802472:	eb 0b                	jmp    80247f <alloc_block_FF+0x128>
  802474:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802477:	8b 40 04             	mov    0x4(%eax),%eax
  80247a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80247f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802482:	8b 40 04             	mov    0x4(%eax),%eax
  802485:	85 c0                	test   %eax,%eax
  802487:	74 0f                	je     802498 <alloc_block_FF+0x141>
  802489:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80248c:	8b 40 04             	mov    0x4(%eax),%eax
  80248f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802492:	8b 12                	mov    (%edx),%edx
  802494:	89 10                	mov    %edx,(%eax)
  802496:	eb 0a                	jmp    8024a2 <alloc_block_FF+0x14b>
  802498:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80249b:	8b 00                	mov    (%eax),%eax
  80249d:	a3 48 51 80 00       	mov    %eax,0x805148
  8024a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024ae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024b5:	a1 54 51 80 00       	mov    0x805154,%eax
  8024ba:	48                   	dec    %eax
  8024bb:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  8024c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c3:	8b 50 08             	mov    0x8(%eax),%edx
  8024c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c9:	01 c2                	add    %eax,%edx
  8024cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ce:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8024d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d4:	8b 40 0c             	mov    0xc(%eax),%eax
  8024d7:	2b 45 08             	sub    0x8(%ebp),%eax
  8024da:	89 c2                	mov    %eax,%edx
  8024dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024df:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8024e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024e5:	eb 3b                	jmp    802522 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8024e7:	a1 40 51 80 00       	mov    0x805140,%eax
  8024ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024f3:	74 07                	je     8024fc <alloc_block_FF+0x1a5>
  8024f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f8:	8b 00                	mov    (%eax),%eax
  8024fa:	eb 05                	jmp    802501 <alloc_block_FF+0x1aa>
  8024fc:	b8 00 00 00 00       	mov    $0x0,%eax
  802501:	a3 40 51 80 00       	mov    %eax,0x805140
  802506:	a1 40 51 80 00       	mov    0x805140,%eax
  80250b:	85 c0                	test   %eax,%eax
  80250d:	0f 85 57 fe ff ff    	jne    80236a <alloc_block_FF+0x13>
  802513:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802517:	0f 85 4d fe ff ff    	jne    80236a <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  80251d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802522:	c9                   	leave  
  802523:	c3                   	ret    

00802524 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802524:	55                   	push   %ebp
  802525:	89 e5                	mov    %esp,%ebp
  802527:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  80252a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802531:	a1 38 51 80 00       	mov    0x805138,%eax
  802536:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802539:	e9 df 00 00 00       	jmp    80261d <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  80253e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802541:	8b 40 0c             	mov    0xc(%eax),%eax
  802544:	3b 45 08             	cmp    0x8(%ebp),%eax
  802547:	0f 82 c8 00 00 00    	jb     802615 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  80254d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802550:	8b 40 0c             	mov    0xc(%eax),%eax
  802553:	3b 45 08             	cmp    0x8(%ebp),%eax
  802556:	0f 85 8a 00 00 00    	jne    8025e6 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  80255c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802560:	75 17                	jne    802579 <alloc_block_BF+0x55>
  802562:	83 ec 04             	sub    $0x4,%esp
  802565:	68 44 41 80 00       	push   $0x804144
  80256a:	68 b7 00 00 00       	push   $0xb7
  80256f:	68 9b 40 80 00       	push   $0x80409b
  802574:	e8 70 dd ff ff       	call   8002e9 <_panic>
  802579:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257c:	8b 00                	mov    (%eax),%eax
  80257e:	85 c0                	test   %eax,%eax
  802580:	74 10                	je     802592 <alloc_block_BF+0x6e>
  802582:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802585:	8b 00                	mov    (%eax),%eax
  802587:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80258a:	8b 52 04             	mov    0x4(%edx),%edx
  80258d:	89 50 04             	mov    %edx,0x4(%eax)
  802590:	eb 0b                	jmp    80259d <alloc_block_BF+0x79>
  802592:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802595:	8b 40 04             	mov    0x4(%eax),%eax
  802598:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80259d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a0:	8b 40 04             	mov    0x4(%eax),%eax
  8025a3:	85 c0                	test   %eax,%eax
  8025a5:	74 0f                	je     8025b6 <alloc_block_BF+0x92>
  8025a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025aa:	8b 40 04             	mov    0x4(%eax),%eax
  8025ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025b0:	8b 12                	mov    (%edx),%edx
  8025b2:	89 10                	mov    %edx,(%eax)
  8025b4:	eb 0a                	jmp    8025c0 <alloc_block_BF+0x9c>
  8025b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b9:	8b 00                	mov    (%eax),%eax
  8025bb:	a3 38 51 80 00       	mov    %eax,0x805138
  8025c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025d3:	a1 44 51 80 00       	mov    0x805144,%eax
  8025d8:	48                   	dec    %eax
  8025d9:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  8025de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e1:	e9 4d 01 00 00       	jmp    802733 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8025e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e9:	8b 40 0c             	mov    0xc(%eax),%eax
  8025ec:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025ef:	76 24                	jbe    802615 <alloc_block_BF+0xf1>
  8025f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f4:	8b 40 0c             	mov    0xc(%eax),%eax
  8025f7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8025fa:	73 19                	jae    802615 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8025fc:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802603:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802606:	8b 40 0c             	mov    0xc(%eax),%eax
  802609:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  80260c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260f:	8b 40 08             	mov    0x8(%eax),%eax
  802612:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802615:	a1 40 51 80 00       	mov    0x805140,%eax
  80261a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80261d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802621:	74 07                	je     80262a <alloc_block_BF+0x106>
  802623:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802626:	8b 00                	mov    (%eax),%eax
  802628:	eb 05                	jmp    80262f <alloc_block_BF+0x10b>
  80262a:	b8 00 00 00 00       	mov    $0x0,%eax
  80262f:	a3 40 51 80 00       	mov    %eax,0x805140
  802634:	a1 40 51 80 00       	mov    0x805140,%eax
  802639:	85 c0                	test   %eax,%eax
  80263b:	0f 85 fd fe ff ff    	jne    80253e <alloc_block_BF+0x1a>
  802641:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802645:	0f 85 f3 fe ff ff    	jne    80253e <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  80264b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80264f:	0f 84 d9 00 00 00    	je     80272e <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802655:	a1 48 51 80 00       	mov    0x805148,%eax
  80265a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  80265d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802660:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802663:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802666:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802669:	8b 55 08             	mov    0x8(%ebp),%edx
  80266c:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  80266f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802673:	75 17                	jne    80268c <alloc_block_BF+0x168>
  802675:	83 ec 04             	sub    $0x4,%esp
  802678:	68 44 41 80 00       	push   $0x804144
  80267d:	68 c7 00 00 00       	push   $0xc7
  802682:	68 9b 40 80 00       	push   $0x80409b
  802687:	e8 5d dc ff ff       	call   8002e9 <_panic>
  80268c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80268f:	8b 00                	mov    (%eax),%eax
  802691:	85 c0                	test   %eax,%eax
  802693:	74 10                	je     8026a5 <alloc_block_BF+0x181>
  802695:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802698:	8b 00                	mov    (%eax),%eax
  80269a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80269d:	8b 52 04             	mov    0x4(%edx),%edx
  8026a0:	89 50 04             	mov    %edx,0x4(%eax)
  8026a3:	eb 0b                	jmp    8026b0 <alloc_block_BF+0x18c>
  8026a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026a8:	8b 40 04             	mov    0x4(%eax),%eax
  8026ab:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8026b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026b3:	8b 40 04             	mov    0x4(%eax),%eax
  8026b6:	85 c0                	test   %eax,%eax
  8026b8:	74 0f                	je     8026c9 <alloc_block_BF+0x1a5>
  8026ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026bd:	8b 40 04             	mov    0x4(%eax),%eax
  8026c0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026c3:	8b 12                	mov    (%edx),%edx
  8026c5:	89 10                	mov    %edx,(%eax)
  8026c7:	eb 0a                	jmp    8026d3 <alloc_block_BF+0x1af>
  8026c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026cc:	8b 00                	mov    (%eax),%eax
  8026ce:	a3 48 51 80 00       	mov    %eax,0x805148
  8026d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026df:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026e6:	a1 54 51 80 00       	mov    0x805154,%eax
  8026eb:	48                   	dec    %eax
  8026ec:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8026f1:	83 ec 08             	sub    $0x8,%esp
  8026f4:	ff 75 ec             	pushl  -0x14(%ebp)
  8026f7:	68 38 51 80 00       	push   $0x805138
  8026fc:	e8 71 f9 ff ff       	call   802072 <find_block>
  802701:	83 c4 10             	add    $0x10,%esp
  802704:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802707:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80270a:	8b 50 08             	mov    0x8(%eax),%edx
  80270d:	8b 45 08             	mov    0x8(%ebp),%eax
  802710:	01 c2                	add    %eax,%edx
  802712:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802715:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802718:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80271b:	8b 40 0c             	mov    0xc(%eax),%eax
  80271e:	2b 45 08             	sub    0x8(%ebp),%eax
  802721:	89 c2                	mov    %eax,%edx
  802723:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802726:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802729:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80272c:	eb 05                	jmp    802733 <alloc_block_BF+0x20f>
	}
	return NULL;
  80272e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802733:	c9                   	leave  
  802734:	c3                   	ret    

00802735 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802735:	55                   	push   %ebp
  802736:	89 e5                	mov    %esp,%ebp
  802738:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  80273b:	a1 28 50 80 00       	mov    0x805028,%eax
  802740:	85 c0                	test   %eax,%eax
  802742:	0f 85 de 01 00 00    	jne    802926 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802748:	a1 38 51 80 00       	mov    0x805138,%eax
  80274d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802750:	e9 9e 01 00 00       	jmp    8028f3 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802755:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802758:	8b 40 0c             	mov    0xc(%eax),%eax
  80275b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80275e:	0f 82 87 01 00 00    	jb     8028eb <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802764:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802767:	8b 40 0c             	mov    0xc(%eax),%eax
  80276a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80276d:	0f 85 95 00 00 00    	jne    802808 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802773:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802777:	75 17                	jne    802790 <alloc_block_NF+0x5b>
  802779:	83 ec 04             	sub    $0x4,%esp
  80277c:	68 44 41 80 00       	push   $0x804144
  802781:	68 e0 00 00 00       	push   $0xe0
  802786:	68 9b 40 80 00       	push   $0x80409b
  80278b:	e8 59 db ff ff       	call   8002e9 <_panic>
  802790:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802793:	8b 00                	mov    (%eax),%eax
  802795:	85 c0                	test   %eax,%eax
  802797:	74 10                	je     8027a9 <alloc_block_NF+0x74>
  802799:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279c:	8b 00                	mov    (%eax),%eax
  80279e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027a1:	8b 52 04             	mov    0x4(%edx),%edx
  8027a4:	89 50 04             	mov    %edx,0x4(%eax)
  8027a7:	eb 0b                	jmp    8027b4 <alloc_block_NF+0x7f>
  8027a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ac:	8b 40 04             	mov    0x4(%eax),%eax
  8027af:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8027b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b7:	8b 40 04             	mov    0x4(%eax),%eax
  8027ba:	85 c0                	test   %eax,%eax
  8027bc:	74 0f                	je     8027cd <alloc_block_NF+0x98>
  8027be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c1:	8b 40 04             	mov    0x4(%eax),%eax
  8027c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027c7:	8b 12                	mov    (%edx),%edx
  8027c9:	89 10                	mov    %edx,(%eax)
  8027cb:	eb 0a                	jmp    8027d7 <alloc_block_NF+0xa2>
  8027cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d0:	8b 00                	mov    (%eax),%eax
  8027d2:	a3 38 51 80 00       	mov    %eax,0x805138
  8027d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027ea:	a1 44 51 80 00       	mov    0x805144,%eax
  8027ef:	48                   	dec    %eax
  8027f0:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  8027f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f8:	8b 40 08             	mov    0x8(%eax),%eax
  8027fb:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802800:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802803:	e9 f8 04 00 00       	jmp    802d00 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802808:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280b:	8b 40 0c             	mov    0xc(%eax),%eax
  80280e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802811:	0f 86 d4 00 00 00    	jbe    8028eb <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802817:	a1 48 51 80 00       	mov    0x805148,%eax
  80281c:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  80281f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802822:	8b 50 08             	mov    0x8(%eax),%edx
  802825:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802828:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  80282b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80282e:	8b 55 08             	mov    0x8(%ebp),%edx
  802831:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802834:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802838:	75 17                	jne    802851 <alloc_block_NF+0x11c>
  80283a:	83 ec 04             	sub    $0x4,%esp
  80283d:	68 44 41 80 00       	push   $0x804144
  802842:	68 e9 00 00 00       	push   $0xe9
  802847:	68 9b 40 80 00       	push   $0x80409b
  80284c:	e8 98 da ff ff       	call   8002e9 <_panic>
  802851:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802854:	8b 00                	mov    (%eax),%eax
  802856:	85 c0                	test   %eax,%eax
  802858:	74 10                	je     80286a <alloc_block_NF+0x135>
  80285a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80285d:	8b 00                	mov    (%eax),%eax
  80285f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802862:	8b 52 04             	mov    0x4(%edx),%edx
  802865:	89 50 04             	mov    %edx,0x4(%eax)
  802868:	eb 0b                	jmp    802875 <alloc_block_NF+0x140>
  80286a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80286d:	8b 40 04             	mov    0x4(%eax),%eax
  802870:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802875:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802878:	8b 40 04             	mov    0x4(%eax),%eax
  80287b:	85 c0                	test   %eax,%eax
  80287d:	74 0f                	je     80288e <alloc_block_NF+0x159>
  80287f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802882:	8b 40 04             	mov    0x4(%eax),%eax
  802885:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802888:	8b 12                	mov    (%edx),%edx
  80288a:	89 10                	mov    %edx,(%eax)
  80288c:	eb 0a                	jmp    802898 <alloc_block_NF+0x163>
  80288e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802891:	8b 00                	mov    (%eax),%eax
  802893:	a3 48 51 80 00       	mov    %eax,0x805148
  802898:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80289b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028ab:	a1 54 51 80 00       	mov    0x805154,%eax
  8028b0:	48                   	dec    %eax
  8028b1:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  8028b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b9:	8b 40 08             	mov    0x8(%eax),%eax
  8028bc:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  8028c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c4:	8b 50 08             	mov    0x8(%eax),%edx
  8028c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ca:	01 c2                	add    %eax,%edx
  8028cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cf:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  8028d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d5:	8b 40 0c             	mov    0xc(%eax),%eax
  8028d8:	2b 45 08             	sub    0x8(%ebp),%eax
  8028db:	89 c2                	mov    %eax,%edx
  8028dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e0:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8028e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e6:	e9 15 04 00 00       	jmp    802d00 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8028eb:	a1 40 51 80 00       	mov    0x805140,%eax
  8028f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028f7:	74 07                	je     802900 <alloc_block_NF+0x1cb>
  8028f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fc:	8b 00                	mov    (%eax),%eax
  8028fe:	eb 05                	jmp    802905 <alloc_block_NF+0x1d0>
  802900:	b8 00 00 00 00       	mov    $0x0,%eax
  802905:	a3 40 51 80 00       	mov    %eax,0x805140
  80290a:	a1 40 51 80 00       	mov    0x805140,%eax
  80290f:	85 c0                	test   %eax,%eax
  802911:	0f 85 3e fe ff ff    	jne    802755 <alloc_block_NF+0x20>
  802917:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80291b:	0f 85 34 fe ff ff    	jne    802755 <alloc_block_NF+0x20>
  802921:	e9 d5 03 00 00       	jmp    802cfb <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802926:	a1 38 51 80 00       	mov    0x805138,%eax
  80292b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80292e:	e9 b1 01 00 00       	jmp    802ae4 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802933:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802936:	8b 50 08             	mov    0x8(%eax),%edx
  802939:	a1 28 50 80 00       	mov    0x805028,%eax
  80293e:	39 c2                	cmp    %eax,%edx
  802940:	0f 82 96 01 00 00    	jb     802adc <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802946:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802949:	8b 40 0c             	mov    0xc(%eax),%eax
  80294c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80294f:	0f 82 87 01 00 00    	jb     802adc <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802955:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802958:	8b 40 0c             	mov    0xc(%eax),%eax
  80295b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80295e:	0f 85 95 00 00 00    	jne    8029f9 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802964:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802968:	75 17                	jne    802981 <alloc_block_NF+0x24c>
  80296a:	83 ec 04             	sub    $0x4,%esp
  80296d:	68 44 41 80 00       	push   $0x804144
  802972:	68 fc 00 00 00       	push   $0xfc
  802977:	68 9b 40 80 00       	push   $0x80409b
  80297c:	e8 68 d9 ff ff       	call   8002e9 <_panic>
  802981:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802984:	8b 00                	mov    (%eax),%eax
  802986:	85 c0                	test   %eax,%eax
  802988:	74 10                	je     80299a <alloc_block_NF+0x265>
  80298a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298d:	8b 00                	mov    (%eax),%eax
  80298f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802992:	8b 52 04             	mov    0x4(%edx),%edx
  802995:	89 50 04             	mov    %edx,0x4(%eax)
  802998:	eb 0b                	jmp    8029a5 <alloc_block_NF+0x270>
  80299a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299d:	8b 40 04             	mov    0x4(%eax),%eax
  8029a0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8029a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a8:	8b 40 04             	mov    0x4(%eax),%eax
  8029ab:	85 c0                	test   %eax,%eax
  8029ad:	74 0f                	je     8029be <alloc_block_NF+0x289>
  8029af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b2:	8b 40 04             	mov    0x4(%eax),%eax
  8029b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029b8:	8b 12                	mov    (%edx),%edx
  8029ba:	89 10                	mov    %edx,(%eax)
  8029bc:	eb 0a                	jmp    8029c8 <alloc_block_NF+0x293>
  8029be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c1:	8b 00                	mov    (%eax),%eax
  8029c3:	a3 38 51 80 00       	mov    %eax,0x805138
  8029c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029db:	a1 44 51 80 00       	mov    0x805144,%eax
  8029e0:	48                   	dec    %eax
  8029e1:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8029e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e9:	8b 40 08             	mov    0x8(%eax),%eax
  8029ec:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  8029f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f4:	e9 07 03 00 00       	jmp    802d00 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8029f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fc:	8b 40 0c             	mov    0xc(%eax),%eax
  8029ff:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a02:	0f 86 d4 00 00 00    	jbe    802adc <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802a08:	a1 48 51 80 00       	mov    0x805148,%eax
  802a0d:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802a10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a13:	8b 50 08             	mov    0x8(%eax),%edx
  802a16:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a19:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802a1c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a1f:	8b 55 08             	mov    0x8(%ebp),%edx
  802a22:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802a25:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802a29:	75 17                	jne    802a42 <alloc_block_NF+0x30d>
  802a2b:	83 ec 04             	sub    $0x4,%esp
  802a2e:	68 44 41 80 00       	push   $0x804144
  802a33:	68 04 01 00 00       	push   $0x104
  802a38:	68 9b 40 80 00       	push   $0x80409b
  802a3d:	e8 a7 d8 ff ff       	call   8002e9 <_panic>
  802a42:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a45:	8b 00                	mov    (%eax),%eax
  802a47:	85 c0                	test   %eax,%eax
  802a49:	74 10                	je     802a5b <alloc_block_NF+0x326>
  802a4b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a4e:	8b 00                	mov    (%eax),%eax
  802a50:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a53:	8b 52 04             	mov    0x4(%edx),%edx
  802a56:	89 50 04             	mov    %edx,0x4(%eax)
  802a59:	eb 0b                	jmp    802a66 <alloc_block_NF+0x331>
  802a5b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a5e:	8b 40 04             	mov    0x4(%eax),%eax
  802a61:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a66:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a69:	8b 40 04             	mov    0x4(%eax),%eax
  802a6c:	85 c0                	test   %eax,%eax
  802a6e:	74 0f                	je     802a7f <alloc_block_NF+0x34a>
  802a70:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a73:	8b 40 04             	mov    0x4(%eax),%eax
  802a76:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a79:	8b 12                	mov    (%edx),%edx
  802a7b:	89 10                	mov    %edx,(%eax)
  802a7d:	eb 0a                	jmp    802a89 <alloc_block_NF+0x354>
  802a7f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a82:	8b 00                	mov    (%eax),%eax
  802a84:	a3 48 51 80 00       	mov    %eax,0x805148
  802a89:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a8c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a92:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a95:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a9c:	a1 54 51 80 00       	mov    0x805154,%eax
  802aa1:	48                   	dec    %eax
  802aa2:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802aa7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aaa:	8b 40 08             	mov    0x8(%eax),%eax
  802aad:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802ab2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab5:	8b 50 08             	mov    0x8(%eax),%edx
  802ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  802abb:	01 c2                	add    %eax,%edx
  802abd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac0:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802ac3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac6:	8b 40 0c             	mov    0xc(%eax),%eax
  802ac9:	2b 45 08             	sub    0x8(%ebp),%eax
  802acc:	89 c2                	mov    %eax,%edx
  802ace:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad1:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802ad4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ad7:	e9 24 02 00 00       	jmp    802d00 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802adc:	a1 40 51 80 00       	mov    0x805140,%eax
  802ae1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ae4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ae8:	74 07                	je     802af1 <alloc_block_NF+0x3bc>
  802aea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aed:	8b 00                	mov    (%eax),%eax
  802aef:	eb 05                	jmp    802af6 <alloc_block_NF+0x3c1>
  802af1:	b8 00 00 00 00       	mov    $0x0,%eax
  802af6:	a3 40 51 80 00       	mov    %eax,0x805140
  802afb:	a1 40 51 80 00       	mov    0x805140,%eax
  802b00:	85 c0                	test   %eax,%eax
  802b02:	0f 85 2b fe ff ff    	jne    802933 <alloc_block_NF+0x1fe>
  802b08:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b0c:	0f 85 21 fe ff ff    	jne    802933 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b12:	a1 38 51 80 00       	mov    0x805138,%eax
  802b17:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b1a:	e9 ae 01 00 00       	jmp    802ccd <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802b1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b22:	8b 50 08             	mov    0x8(%eax),%edx
  802b25:	a1 28 50 80 00       	mov    0x805028,%eax
  802b2a:	39 c2                	cmp    %eax,%edx
  802b2c:	0f 83 93 01 00 00    	jae    802cc5 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802b32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b35:	8b 40 0c             	mov    0xc(%eax),%eax
  802b38:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b3b:	0f 82 84 01 00 00    	jb     802cc5 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802b41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b44:	8b 40 0c             	mov    0xc(%eax),%eax
  802b47:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b4a:	0f 85 95 00 00 00    	jne    802be5 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802b50:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b54:	75 17                	jne    802b6d <alloc_block_NF+0x438>
  802b56:	83 ec 04             	sub    $0x4,%esp
  802b59:	68 44 41 80 00       	push   $0x804144
  802b5e:	68 14 01 00 00       	push   $0x114
  802b63:	68 9b 40 80 00       	push   $0x80409b
  802b68:	e8 7c d7 ff ff       	call   8002e9 <_panic>
  802b6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b70:	8b 00                	mov    (%eax),%eax
  802b72:	85 c0                	test   %eax,%eax
  802b74:	74 10                	je     802b86 <alloc_block_NF+0x451>
  802b76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b79:	8b 00                	mov    (%eax),%eax
  802b7b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b7e:	8b 52 04             	mov    0x4(%edx),%edx
  802b81:	89 50 04             	mov    %edx,0x4(%eax)
  802b84:	eb 0b                	jmp    802b91 <alloc_block_NF+0x45c>
  802b86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b89:	8b 40 04             	mov    0x4(%eax),%eax
  802b8c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b94:	8b 40 04             	mov    0x4(%eax),%eax
  802b97:	85 c0                	test   %eax,%eax
  802b99:	74 0f                	je     802baa <alloc_block_NF+0x475>
  802b9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9e:	8b 40 04             	mov    0x4(%eax),%eax
  802ba1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ba4:	8b 12                	mov    (%edx),%edx
  802ba6:	89 10                	mov    %edx,(%eax)
  802ba8:	eb 0a                	jmp    802bb4 <alloc_block_NF+0x47f>
  802baa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bad:	8b 00                	mov    (%eax),%eax
  802baf:	a3 38 51 80 00       	mov    %eax,0x805138
  802bb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bc7:	a1 44 51 80 00       	mov    0x805144,%eax
  802bcc:	48                   	dec    %eax
  802bcd:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802bd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd5:	8b 40 08             	mov    0x8(%eax),%eax
  802bd8:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802bdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be0:	e9 1b 01 00 00       	jmp    802d00 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802be5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be8:	8b 40 0c             	mov    0xc(%eax),%eax
  802beb:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bee:	0f 86 d1 00 00 00    	jbe    802cc5 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802bf4:	a1 48 51 80 00       	mov    0x805148,%eax
  802bf9:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802bfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bff:	8b 50 08             	mov    0x8(%eax),%edx
  802c02:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c05:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802c08:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c0b:	8b 55 08             	mov    0x8(%ebp),%edx
  802c0e:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802c11:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c15:	75 17                	jne    802c2e <alloc_block_NF+0x4f9>
  802c17:	83 ec 04             	sub    $0x4,%esp
  802c1a:	68 44 41 80 00       	push   $0x804144
  802c1f:	68 1c 01 00 00       	push   $0x11c
  802c24:	68 9b 40 80 00       	push   $0x80409b
  802c29:	e8 bb d6 ff ff       	call   8002e9 <_panic>
  802c2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c31:	8b 00                	mov    (%eax),%eax
  802c33:	85 c0                	test   %eax,%eax
  802c35:	74 10                	je     802c47 <alloc_block_NF+0x512>
  802c37:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c3a:	8b 00                	mov    (%eax),%eax
  802c3c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c3f:	8b 52 04             	mov    0x4(%edx),%edx
  802c42:	89 50 04             	mov    %edx,0x4(%eax)
  802c45:	eb 0b                	jmp    802c52 <alloc_block_NF+0x51d>
  802c47:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c4a:	8b 40 04             	mov    0x4(%eax),%eax
  802c4d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c52:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c55:	8b 40 04             	mov    0x4(%eax),%eax
  802c58:	85 c0                	test   %eax,%eax
  802c5a:	74 0f                	je     802c6b <alloc_block_NF+0x536>
  802c5c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c5f:	8b 40 04             	mov    0x4(%eax),%eax
  802c62:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c65:	8b 12                	mov    (%edx),%edx
  802c67:	89 10                	mov    %edx,(%eax)
  802c69:	eb 0a                	jmp    802c75 <alloc_block_NF+0x540>
  802c6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c6e:	8b 00                	mov    (%eax),%eax
  802c70:	a3 48 51 80 00       	mov    %eax,0x805148
  802c75:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c78:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c81:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c88:	a1 54 51 80 00       	mov    0x805154,%eax
  802c8d:	48                   	dec    %eax
  802c8e:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802c93:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c96:	8b 40 08             	mov    0x8(%eax),%eax
  802c99:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802c9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca1:	8b 50 08             	mov    0x8(%eax),%edx
  802ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca7:	01 c2                	add    %eax,%edx
  802ca9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cac:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802caf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb2:	8b 40 0c             	mov    0xc(%eax),%eax
  802cb5:	2b 45 08             	sub    0x8(%ebp),%eax
  802cb8:	89 c2                	mov    %eax,%edx
  802cba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbd:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802cc0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cc3:	eb 3b                	jmp    802d00 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802cc5:	a1 40 51 80 00       	mov    0x805140,%eax
  802cca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ccd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cd1:	74 07                	je     802cda <alloc_block_NF+0x5a5>
  802cd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd6:	8b 00                	mov    (%eax),%eax
  802cd8:	eb 05                	jmp    802cdf <alloc_block_NF+0x5aa>
  802cda:	b8 00 00 00 00       	mov    $0x0,%eax
  802cdf:	a3 40 51 80 00       	mov    %eax,0x805140
  802ce4:	a1 40 51 80 00       	mov    0x805140,%eax
  802ce9:	85 c0                	test   %eax,%eax
  802ceb:	0f 85 2e fe ff ff    	jne    802b1f <alloc_block_NF+0x3ea>
  802cf1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cf5:	0f 85 24 fe ff ff    	jne    802b1f <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802cfb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d00:	c9                   	leave  
  802d01:	c3                   	ret    

00802d02 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802d02:	55                   	push   %ebp
  802d03:	89 e5                	mov    %esp,%ebp
  802d05:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802d08:	a1 38 51 80 00       	mov    0x805138,%eax
  802d0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802d10:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802d15:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802d18:	a1 38 51 80 00       	mov    0x805138,%eax
  802d1d:	85 c0                	test   %eax,%eax
  802d1f:	74 14                	je     802d35 <insert_sorted_with_merge_freeList+0x33>
  802d21:	8b 45 08             	mov    0x8(%ebp),%eax
  802d24:	8b 50 08             	mov    0x8(%eax),%edx
  802d27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d2a:	8b 40 08             	mov    0x8(%eax),%eax
  802d2d:	39 c2                	cmp    %eax,%edx
  802d2f:	0f 87 9b 01 00 00    	ja     802ed0 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802d35:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d39:	75 17                	jne    802d52 <insert_sorted_with_merge_freeList+0x50>
  802d3b:	83 ec 04             	sub    $0x4,%esp
  802d3e:	68 78 40 80 00       	push   $0x804078
  802d43:	68 38 01 00 00       	push   $0x138
  802d48:	68 9b 40 80 00       	push   $0x80409b
  802d4d:	e8 97 d5 ff ff       	call   8002e9 <_panic>
  802d52:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802d58:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5b:	89 10                	mov    %edx,(%eax)
  802d5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d60:	8b 00                	mov    (%eax),%eax
  802d62:	85 c0                	test   %eax,%eax
  802d64:	74 0d                	je     802d73 <insert_sorted_with_merge_freeList+0x71>
  802d66:	a1 38 51 80 00       	mov    0x805138,%eax
  802d6b:	8b 55 08             	mov    0x8(%ebp),%edx
  802d6e:	89 50 04             	mov    %edx,0x4(%eax)
  802d71:	eb 08                	jmp    802d7b <insert_sorted_with_merge_freeList+0x79>
  802d73:	8b 45 08             	mov    0x8(%ebp),%eax
  802d76:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7e:	a3 38 51 80 00       	mov    %eax,0x805138
  802d83:	8b 45 08             	mov    0x8(%ebp),%eax
  802d86:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d8d:	a1 44 51 80 00       	mov    0x805144,%eax
  802d92:	40                   	inc    %eax
  802d93:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802d98:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d9c:	0f 84 a8 06 00 00    	je     80344a <insert_sorted_with_merge_freeList+0x748>
  802da2:	8b 45 08             	mov    0x8(%ebp),%eax
  802da5:	8b 50 08             	mov    0x8(%eax),%edx
  802da8:	8b 45 08             	mov    0x8(%ebp),%eax
  802dab:	8b 40 0c             	mov    0xc(%eax),%eax
  802dae:	01 c2                	add    %eax,%edx
  802db0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802db3:	8b 40 08             	mov    0x8(%eax),%eax
  802db6:	39 c2                	cmp    %eax,%edx
  802db8:	0f 85 8c 06 00 00    	jne    80344a <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc1:	8b 50 0c             	mov    0xc(%eax),%edx
  802dc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc7:	8b 40 0c             	mov    0xc(%eax),%eax
  802dca:	01 c2                	add    %eax,%edx
  802dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  802dcf:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802dd2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802dd6:	75 17                	jne    802def <insert_sorted_with_merge_freeList+0xed>
  802dd8:	83 ec 04             	sub    $0x4,%esp
  802ddb:	68 44 41 80 00       	push   $0x804144
  802de0:	68 3c 01 00 00       	push   $0x13c
  802de5:	68 9b 40 80 00       	push   $0x80409b
  802dea:	e8 fa d4 ff ff       	call   8002e9 <_panic>
  802def:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df2:	8b 00                	mov    (%eax),%eax
  802df4:	85 c0                	test   %eax,%eax
  802df6:	74 10                	je     802e08 <insert_sorted_with_merge_freeList+0x106>
  802df8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dfb:	8b 00                	mov    (%eax),%eax
  802dfd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e00:	8b 52 04             	mov    0x4(%edx),%edx
  802e03:	89 50 04             	mov    %edx,0x4(%eax)
  802e06:	eb 0b                	jmp    802e13 <insert_sorted_with_merge_freeList+0x111>
  802e08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e0b:	8b 40 04             	mov    0x4(%eax),%eax
  802e0e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e16:	8b 40 04             	mov    0x4(%eax),%eax
  802e19:	85 c0                	test   %eax,%eax
  802e1b:	74 0f                	je     802e2c <insert_sorted_with_merge_freeList+0x12a>
  802e1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e20:	8b 40 04             	mov    0x4(%eax),%eax
  802e23:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e26:	8b 12                	mov    (%edx),%edx
  802e28:	89 10                	mov    %edx,(%eax)
  802e2a:	eb 0a                	jmp    802e36 <insert_sorted_with_merge_freeList+0x134>
  802e2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e2f:	8b 00                	mov    (%eax),%eax
  802e31:	a3 38 51 80 00       	mov    %eax,0x805138
  802e36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e39:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e42:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e49:	a1 44 51 80 00       	mov    0x805144,%eax
  802e4e:	48                   	dec    %eax
  802e4f:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802e54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e57:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802e5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e61:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802e68:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e6c:	75 17                	jne    802e85 <insert_sorted_with_merge_freeList+0x183>
  802e6e:	83 ec 04             	sub    $0x4,%esp
  802e71:	68 78 40 80 00       	push   $0x804078
  802e76:	68 3f 01 00 00       	push   $0x13f
  802e7b:	68 9b 40 80 00       	push   $0x80409b
  802e80:	e8 64 d4 ff ff       	call   8002e9 <_panic>
  802e85:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802e8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e8e:	89 10                	mov    %edx,(%eax)
  802e90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e93:	8b 00                	mov    (%eax),%eax
  802e95:	85 c0                	test   %eax,%eax
  802e97:	74 0d                	je     802ea6 <insert_sorted_with_merge_freeList+0x1a4>
  802e99:	a1 48 51 80 00       	mov    0x805148,%eax
  802e9e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ea1:	89 50 04             	mov    %edx,0x4(%eax)
  802ea4:	eb 08                	jmp    802eae <insert_sorted_with_merge_freeList+0x1ac>
  802ea6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ea9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802eae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eb1:	a3 48 51 80 00       	mov    %eax,0x805148
  802eb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eb9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ec0:	a1 54 51 80 00       	mov    0x805154,%eax
  802ec5:	40                   	inc    %eax
  802ec6:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802ecb:	e9 7a 05 00 00       	jmp    80344a <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed3:	8b 50 08             	mov    0x8(%eax),%edx
  802ed6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ed9:	8b 40 08             	mov    0x8(%eax),%eax
  802edc:	39 c2                	cmp    %eax,%edx
  802ede:	0f 82 14 01 00 00    	jb     802ff8 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802ee4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ee7:	8b 50 08             	mov    0x8(%eax),%edx
  802eea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eed:	8b 40 0c             	mov    0xc(%eax),%eax
  802ef0:	01 c2                	add    %eax,%edx
  802ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef5:	8b 40 08             	mov    0x8(%eax),%eax
  802ef8:	39 c2                	cmp    %eax,%edx
  802efa:	0f 85 90 00 00 00    	jne    802f90 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802f00:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f03:	8b 50 0c             	mov    0xc(%eax),%edx
  802f06:	8b 45 08             	mov    0x8(%ebp),%eax
  802f09:	8b 40 0c             	mov    0xc(%eax),%eax
  802f0c:	01 c2                	add    %eax,%edx
  802f0e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f11:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802f14:	8b 45 08             	mov    0x8(%ebp),%eax
  802f17:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802f1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f21:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802f28:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f2c:	75 17                	jne    802f45 <insert_sorted_with_merge_freeList+0x243>
  802f2e:	83 ec 04             	sub    $0x4,%esp
  802f31:	68 78 40 80 00       	push   $0x804078
  802f36:	68 49 01 00 00       	push   $0x149
  802f3b:	68 9b 40 80 00       	push   $0x80409b
  802f40:	e8 a4 d3 ff ff       	call   8002e9 <_panic>
  802f45:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4e:	89 10                	mov    %edx,(%eax)
  802f50:	8b 45 08             	mov    0x8(%ebp),%eax
  802f53:	8b 00                	mov    (%eax),%eax
  802f55:	85 c0                	test   %eax,%eax
  802f57:	74 0d                	je     802f66 <insert_sorted_with_merge_freeList+0x264>
  802f59:	a1 48 51 80 00       	mov    0x805148,%eax
  802f5e:	8b 55 08             	mov    0x8(%ebp),%edx
  802f61:	89 50 04             	mov    %edx,0x4(%eax)
  802f64:	eb 08                	jmp    802f6e <insert_sorted_with_merge_freeList+0x26c>
  802f66:	8b 45 08             	mov    0x8(%ebp),%eax
  802f69:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f71:	a3 48 51 80 00       	mov    %eax,0x805148
  802f76:	8b 45 08             	mov    0x8(%ebp),%eax
  802f79:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f80:	a1 54 51 80 00       	mov    0x805154,%eax
  802f85:	40                   	inc    %eax
  802f86:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802f8b:	e9 bb 04 00 00       	jmp    80344b <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802f90:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f94:	75 17                	jne    802fad <insert_sorted_with_merge_freeList+0x2ab>
  802f96:	83 ec 04             	sub    $0x4,%esp
  802f99:	68 ec 40 80 00       	push   $0x8040ec
  802f9e:	68 4c 01 00 00       	push   $0x14c
  802fa3:	68 9b 40 80 00       	push   $0x80409b
  802fa8:	e8 3c d3 ff ff       	call   8002e9 <_panic>
  802fad:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb6:	89 50 04             	mov    %edx,0x4(%eax)
  802fb9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fbc:	8b 40 04             	mov    0x4(%eax),%eax
  802fbf:	85 c0                	test   %eax,%eax
  802fc1:	74 0c                	je     802fcf <insert_sorted_with_merge_freeList+0x2cd>
  802fc3:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802fc8:	8b 55 08             	mov    0x8(%ebp),%edx
  802fcb:	89 10                	mov    %edx,(%eax)
  802fcd:	eb 08                	jmp    802fd7 <insert_sorted_with_merge_freeList+0x2d5>
  802fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd2:	a3 38 51 80 00       	mov    %eax,0x805138
  802fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802fda:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fdf:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fe8:	a1 44 51 80 00       	mov    0x805144,%eax
  802fed:	40                   	inc    %eax
  802fee:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802ff3:	e9 53 04 00 00       	jmp    80344b <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802ff8:	a1 38 51 80 00       	mov    0x805138,%eax
  802ffd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803000:	e9 15 04 00 00       	jmp    80341a <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803005:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803008:	8b 00                	mov    (%eax),%eax
  80300a:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  80300d:	8b 45 08             	mov    0x8(%ebp),%eax
  803010:	8b 50 08             	mov    0x8(%eax),%edx
  803013:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803016:	8b 40 08             	mov    0x8(%eax),%eax
  803019:	39 c2                	cmp    %eax,%edx
  80301b:	0f 86 f1 03 00 00    	jbe    803412 <insert_sorted_with_merge_freeList+0x710>
  803021:	8b 45 08             	mov    0x8(%ebp),%eax
  803024:	8b 50 08             	mov    0x8(%eax),%edx
  803027:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80302a:	8b 40 08             	mov    0x8(%eax),%eax
  80302d:	39 c2                	cmp    %eax,%edx
  80302f:	0f 83 dd 03 00 00    	jae    803412 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803035:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803038:	8b 50 08             	mov    0x8(%eax),%edx
  80303b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303e:	8b 40 0c             	mov    0xc(%eax),%eax
  803041:	01 c2                	add    %eax,%edx
  803043:	8b 45 08             	mov    0x8(%ebp),%eax
  803046:	8b 40 08             	mov    0x8(%eax),%eax
  803049:	39 c2                	cmp    %eax,%edx
  80304b:	0f 85 b9 01 00 00    	jne    80320a <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803051:	8b 45 08             	mov    0x8(%ebp),%eax
  803054:	8b 50 08             	mov    0x8(%eax),%edx
  803057:	8b 45 08             	mov    0x8(%ebp),%eax
  80305a:	8b 40 0c             	mov    0xc(%eax),%eax
  80305d:	01 c2                	add    %eax,%edx
  80305f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803062:	8b 40 08             	mov    0x8(%eax),%eax
  803065:	39 c2                	cmp    %eax,%edx
  803067:	0f 85 0d 01 00 00    	jne    80317a <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  80306d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803070:	8b 50 0c             	mov    0xc(%eax),%edx
  803073:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803076:	8b 40 0c             	mov    0xc(%eax),%eax
  803079:	01 c2                	add    %eax,%edx
  80307b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80307e:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803081:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803085:	75 17                	jne    80309e <insert_sorted_with_merge_freeList+0x39c>
  803087:	83 ec 04             	sub    $0x4,%esp
  80308a:	68 44 41 80 00       	push   $0x804144
  80308f:	68 5c 01 00 00       	push   $0x15c
  803094:	68 9b 40 80 00       	push   $0x80409b
  803099:	e8 4b d2 ff ff       	call   8002e9 <_panic>
  80309e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030a1:	8b 00                	mov    (%eax),%eax
  8030a3:	85 c0                	test   %eax,%eax
  8030a5:	74 10                	je     8030b7 <insert_sorted_with_merge_freeList+0x3b5>
  8030a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030aa:	8b 00                	mov    (%eax),%eax
  8030ac:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030af:	8b 52 04             	mov    0x4(%edx),%edx
  8030b2:	89 50 04             	mov    %edx,0x4(%eax)
  8030b5:	eb 0b                	jmp    8030c2 <insert_sorted_with_merge_freeList+0x3c0>
  8030b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ba:	8b 40 04             	mov    0x4(%eax),%eax
  8030bd:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030c5:	8b 40 04             	mov    0x4(%eax),%eax
  8030c8:	85 c0                	test   %eax,%eax
  8030ca:	74 0f                	je     8030db <insert_sorted_with_merge_freeList+0x3d9>
  8030cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030cf:	8b 40 04             	mov    0x4(%eax),%eax
  8030d2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030d5:	8b 12                	mov    (%edx),%edx
  8030d7:	89 10                	mov    %edx,(%eax)
  8030d9:	eb 0a                	jmp    8030e5 <insert_sorted_with_merge_freeList+0x3e3>
  8030db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030de:	8b 00                	mov    (%eax),%eax
  8030e0:	a3 38 51 80 00       	mov    %eax,0x805138
  8030e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030e8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030f1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030f8:	a1 44 51 80 00       	mov    0x805144,%eax
  8030fd:	48                   	dec    %eax
  8030fe:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803103:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803106:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  80310d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803110:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803117:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80311b:	75 17                	jne    803134 <insert_sorted_with_merge_freeList+0x432>
  80311d:	83 ec 04             	sub    $0x4,%esp
  803120:	68 78 40 80 00       	push   $0x804078
  803125:	68 5f 01 00 00       	push   $0x15f
  80312a:	68 9b 40 80 00       	push   $0x80409b
  80312f:	e8 b5 d1 ff ff       	call   8002e9 <_panic>
  803134:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80313a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80313d:	89 10                	mov    %edx,(%eax)
  80313f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803142:	8b 00                	mov    (%eax),%eax
  803144:	85 c0                	test   %eax,%eax
  803146:	74 0d                	je     803155 <insert_sorted_with_merge_freeList+0x453>
  803148:	a1 48 51 80 00       	mov    0x805148,%eax
  80314d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803150:	89 50 04             	mov    %edx,0x4(%eax)
  803153:	eb 08                	jmp    80315d <insert_sorted_with_merge_freeList+0x45b>
  803155:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803158:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80315d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803160:	a3 48 51 80 00       	mov    %eax,0x805148
  803165:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803168:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80316f:	a1 54 51 80 00       	mov    0x805154,%eax
  803174:	40                   	inc    %eax
  803175:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  80317a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80317d:	8b 50 0c             	mov    0xc(%eax),%edx
  803180:	8b 45 08             	mov    0x8(%ebp),%eax
  803183:	8b 40 0c             	mov    0xc(%eax),%eax
  803186:	01 c2                	add    %eax,%edx
  803188:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80318b:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  80318e:	8b 45 08             	mov    0x8(%ebp),%eax
  803191:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803198:	8b 45 08             	mov    0x8(%ebp),%eax
  80319b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8031a2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031a6:	75 17                	jne    8031bf <insert_sorted_with_merge_freeList+0x4bd>
  8031a8:	83 ec 04             	sub    $0x4,%esp
  8031ab:	68 78 40 80 00       	push   $0x804078
  8031b0:	68 64 01 00 00       	push   $0x164
  8031b5:	68 9b 40 80 00       	push   $0x80409b
  8031ba:	e8 2a d1 ff ff       	call   8002e9 <_panic>
  8031bf:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c8:	89 10                	mov    %edx,(%eax)
  8031ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8031cd:	8b 00                	mov    (%eax),%eax
  8031cf:	85 c0                	test   %eax,%eax
  8031d1:	74 0d                	je     8031e0 <insert_sorted_with_merge_freeList+0x4de>
  8031d3:	a1 48 51 80 00       	mov    0x805148,%eax
  8031d8:	8b 55 08             	mov    0x8(%ebp),%edx
  8031db:	89 50 04             	mov    %edx,0x4(%eax)
  8031de:	eb 08                	jmp    8031e8 <insert_sorted_with_merge_freeList+0x4e6>
  8031e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031eb:	a3 48 51 80 00       	mov    %eax,0x805148
  8031f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031fa:	a1 54 51 80 00       	mov    0x805154,%eax
  8031ff:	40                   	inc    %eax
  803200:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803205:	e9 41 02 00 00       	jmp    80344b <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80320a:	8b 45 08             	mov    0x8(%ebp),%eax
  80320d:	8b 50 08             	mov    0x8(%eax),%edx
  803210:	8b 45 08             	mov    0x8(%ebp),%eax
  803213:	8b 40 0c             	mov    0xc(%eax),%eax
  803216:	01 c2                	add    %eax,%edx
  803218:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80321b:	8b 40 08             	mov    0x8(%eax),%eax
  80321e:	39 c2                	cmp    %eax,%edx
  803220:	0f 85 7c 01 00 00    	jne    8033a2 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803226:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80322a:	74 06                	je     803232 <insert_sorted_with_merge_freeList+0x530>
  80322c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803230:	75 17                	jne    803249 <insert_sorted_with_merge_freeList+0x547>
  803232:	83 ec 04             	sub    $0x4,%esp
  803235:	68 b4 40 80 00       	push   $0x8040b4
  80323a:	68 69 01 00 00       	push   $0x169
  80323f:	68 9b 40 80 00       	push   $0x80409b
  803244:	e8 a0 d0 ff ff       	call   8002e9 <_panic>
  803249:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80324c:	8b 50 04             	mov    0x4(%eax),%edx
  80324f:	8b 45 08             	mov    0x8(%ebp),%eax
  803252:	89 50 04             	mov    %edx,0x4(%eax)
  803255:	8b 45 08             	mov    0x8(%ebp),%eax
  803258:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80325b:	89 10                	mov    %edx,(%eax)
  80325d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803260:	8b 40 04             	mov    0x4(%eax),%eax
  803263:	85 c0                	test   %eax,%eax
  803265:	74 0d                	je     803274 <insert_sorted_with_merge_freeList+0x572>
  803267:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80326a:	8b 40 04             	mov    0x4(%eax),%eax
  80326d:	8b 55 08             	mov    0x8(%ebp),%edx
  803270:	89 10                	mov    %edx,(%eax)
  803272:	eb 08                	jmp    80327c <insert_sorted_with_merge_freeList+0x57a>
  803274:	8b 45 08             	mov    0x8(%ebp),%eax
  803277:	a3 38 51 80 00       	mov    %eax,0x805138
  80327c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80327f:	8b 55 08             	mov    0x8(%ebp),%edx
  803282:	89 50 04             	mov    %edx,0x4(%eax)
  803285:	a1 44 51 80 00       	mov    0x805144,%eax
  80328a:	40                   	inc    %eax
  80328b:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803290:	8b 45 08             	mov    0x8(%ebp),%eax
  803293:	8b 50 0c             	mov    0xc(%eax),%edx
  803296:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803299:	8b 40 0c             	mov    0xc(%eax),%eax
  80329c:	01 c2                	add    %eax,%edx
  80329e:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a1:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8032a4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032a8:	75 17                	jne    8032c1 <insert_sorted_with_merge_freeList+0x5bf>
  8032aa:	83 ec 04             	sub    $0x4,%esp
  8032ad:	68 44 41 80 00       	push   $0x804144
  8032b2:	68 6b 01 00 00       	push   $0x16b
  8032b7:	68 9b 40 80 00       	push   $0x80409b
  8032bc:	e8 28 d0 ff ff       	call   8002e9 <_panic>
  8032c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032c4:	8b 00                	mov    (%eax),%eax
  8032c6:	85 c0                	test   %eax,%eax
  8032c8:	74 10                	je     8032da <insert_sorted_with_merge_freeList+0x5d8>
  8032ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032cd:	8b 00                	mov    (%eax),%eax
  8032cf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032d2:	8b 52 04             	mov    0x4(%edx),%edx
  8032d5:	89 50 04             	mov    %edx,0x4(%eax)
  8032d8:	eb 0b                	jmp    8032e5 <insert_sorted_with_merge_freeList+0x5e3>
  8032da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032dd:	8b 40 04             	mov    0x4(%eax),%eax
  8032e0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032e8:	8b 40 04             	mov    0x4(%eax),%eax
  8032eb:	85 c0                	test   %eax,%eax
  8032ed:	74 0f                	je     8032fe <insert_sorted_with_merge_freeList+0x5fc>
  8032ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032f2:	8b 40 04             	mov    0x4(%eax),%eax
  8032f5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032f8:	8b 12                	mov    (%edx),%edx
  8032fa:	89 10                	mov    %edx,(%eax)
  8032fc:	eb 0a                	jmp    803308 <insert_sorted_with_merge_freeList+0x606>
  8032fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803301:	8b 00                	mov    (%eax),%eax
  803303:	a3 38 51 80 00       	mov    %eax,0x805138
  803308:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80330b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803311:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803314:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80331b:	a1 44 51 80 00       	mov    0x805144,%eax
  803320:	48                   	dec    %eax
  803321:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803326:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803329:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803330:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803333:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80333a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80333e:	75 17                	jne    803357 <insert_sorted_with_merge_freeList+0x655>
  803340:	83 ec 04             	sub    $0x4,%esp
  803343:	68 78 40 80 00       	push   $0x804078
  803348:	68 6e 01 00 00       	push   $0x16e
  80334d:	68 9b 40 80 00       	push   $0x80409b
  803352:	e8 92 cf ff ff       	call   8002e9 <_panic>
  803357:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80335d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803360:	89 10                	mov    %edx,(%eax)
  803362:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803365:	8b 00                	mov    (%eax),%eax
  803367:	85 c0                	test   %eax,%eax
  803369:	74 0d                	je     803378 <insert_sorted_with_merge_freeList+0x676>
  80336b:	a1 48 51 80 00       	mov    0x805148,%eax
  803370:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803373:	89 50 04             	mov    %edx,0x4(%eax)
  803376:	eb 08                	jmp    803380 <insert_sorted_with_merge_freeList+0x67e>
  803378:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80337b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803380:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803383:	a3 48 51 80 00       	mov    %eax,0x805148
  803388:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80338b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803392:	a1 54 51 80 00       	mov    0x805154,%eax
  803397:	40                   	inc    %eax
  803398:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80339d:	e9 a9 00 00 00       	jmp    80344b <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8033a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033a6:	74 06                	je     8033ae <insert_sorted_with_merge_freeList+0x6ac>
  8033a8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033ac:	75 17                	jne    8033c5 <insert_sorted_with_merge_freeList+0x6c3>
  8033ae:	83 ec 04             	sub    $0x4,%esp
  8033b1:	68 10 41 80 00       	push   $0x804110
  8033b6:	68 73 01 00 00       	push   $0x173
  8033bb:	68 9b 40 80 00       	push   $0x80409b
  8033c0:	e8 24 cf ff ff       	call   8002e9 <_panic>
  8033c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c8:	8b 10                	mov    (%eax),%edx
  8033ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8033cd:	89 10                	mov    %edx,(%eax)
  8033cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d2:	8b 00                	mov    (%eax),%eax
  8033d4:	85 c0                	test   %eax,%eax
  8033d6:	74 0b                	je     8033e3 <insert_sorted_with_merge_freeList+0x6e1>
  8033d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033db:	8b 00                	mov    (%eax),%eax
  8033dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8033e0:	89 50 04             	mov    %edx,0x4(%eax)
  8033e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8033e9:	89 10                	mov    %edx,(%eax)
  8033eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033f1:	89 50 04             	mov    %edx,0x4(%eax)
  8033f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f7:	8b 00                	mov    (%eax),%eax
  8033f9:	85 c0                	test   %eax,%eax
  8033fb:	75 08                	jne    803405 <insert_sorted_with_merge_freeList+0x703>
  8033fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803400:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803405:	a1 44 51 80 00       	mov    0x805144,%eax
  80340a:	40                   	inc    %eax
  80340b:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803410:	eb 39                	jmp    80344b <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803412:	a1 40 51 80 00       	mov    0x805140,%eax
  803417:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80341a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80341e:	74 07                	je     803427 <insert_sorted_with_merge_freeList+0x725>
  803420:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803423:	8b 00                	mov    (%eax),%eax
  803425:	eb 05                	jmp    80342c <insert_sorted_with_merge_freeList+0x72a>
  803427:	b8 00 00 00 00       	mov    $0x0,%eax
  80342c:	a3 40 51 80 00       	mov    %eax,0x805140
  803431:	a1 40 51 80 00       	mov    0x805140,%eax
  803436:	85 c0                	test   %eax,%eax
  803438:	0f 85 c7 fb ff ff    	jne    803005 <insert_sorted_with_merge_freeList+0x303>
  80343e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803442:	0f 85 bd fb ff ff    	jne    803005 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803448:	eb 01                	jmp    80344b <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80344a:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80344b:	90                   	nop
  80344c:	c9                   	leave  
  80344d:	c3                   	ret    

0080344e <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  80344e:	55                   	push   %ebp
  80344f:	89 e5                	mov    %esp,%ebp
  803451:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803454:	8b 55 08             	mov    0x8(%ebp),%edx
  803457:	89 d0                	mov    %edx,%eax
  803459:	c1 e0 02             	shl    $0x2,%eax
  80345c:	01 d0                	add    %edx,%eax
  80345e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803465:	01 d0                	add    %edx,%eax
  803467:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80346e:	01 d0                	add    %edx,%eax
  803470:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803477:	01 d0                	add    %edx,%eax
  803479:	c1 e0 04             	shl    $0x4,%eax
  80347c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  80347f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803486:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803489:	83 ec 0c             	sub    $0xc,%esp
  80348c:	50                   	push   %eax
  80348d:	e8 26 e7 ff ff       	call   801bb8 <sys_get_virtual_time>
  803492:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803495:	eb 41                	jmp    8034d8 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803497:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80349a:	83 ec 0c             	sub    $0xc,%esp
  80349d:	50                   	push   %eax
  80349e:	e8 15 e7 ff ff       	call   801bb8 <sys_get_virtual_time>
  8034a3:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8034a6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8034a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034ac:	29 c2                	sub    %eax,%edx
  8034ae:	89 d0                	mov    %edx,%eax
  8034b0:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8034b3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034b9:	89 d1                	mov    %edx,%ecx
  8034bb:	29 c1                	sub    %eax,%ecx
  8034bd:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8034c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034c3:	39 c2                	cmp    %eax,%edx
  8034c5:	0f 97 c0             	seta   %al
  8034c8:	0f b6 c0             	movzbl %al,%eax
  8034cb:	29 c1                	sub    %eax,%ecx
  8034cd:	89 c8                	mov    %ecx,%eax
  8034cf:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8034d2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8034d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8034d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034db:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8034de:	72 b7                	jb     803497 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8034e0:	90                   	nop
  8034e1:	c9                   	leave  
  8034e2:	c3                   	ret    

008034e3 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8034e3:	55                   	push   %ebp
  8034e4:	89 e5                	mov    %esp,%ebp
  8034e6:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8034e9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8034f0:	eb 03                	jmp    8034f5 <busy_wait+0x12>
  8034f2:	ff 45 fc             	incl   -0x4(%ebp)
  8034f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8034f8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8034fb:	72 f5                	jb     8034f2 <busy_wait+0xf>
	return i;
  8034fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803500:	c9                   	leave  
  803501:	c3                   	ret    
  803502:	66 90                	xchg   %ax,%ax

00803504 <__udivdi3>:
  803504:	55                   	push   %ebp
  803505:	57                   	push   %edi
  803506:	56                   	push   %esi
  803507:	53                   	push   %ebx
  803508:	83 ec 1c             	sub    $0x1c,%esp
  80350b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80350f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803513:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803517:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80351b:	89 ca                	mov    %ecx,%edx
  80351d:	89 f8                	mov    %edi,%eax
  80351f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803523:	85 f6                	test   %esi,%esi
  803525:	75 2d                	jne    803554 <__udivdi3+0x50>
  803527:	39 cf                	cmp    %ecx,%edi
  803529:	77 65                	ja     803590 <__udivdi3+0x8c>
  80352b:	89 fd                	mov    %edi,%ebp
  80352d:	85 ff                	test   %edi,%edi
  80352f:	75 0b                	jne    80353c <__udivdi3+0x38>
  803531:	b8 01 00 00 00       	mov    $0x1,%eax
  803536:	31 d2                	xor    %edx,%edx
  803538:	f7 f7                	div    %edi
  80353a:	89 c5                	mov    %eax,%ebp
  80353c:	31 d2                	xor    %edx,%edx
  80353e:	89 c8                	mov    %ecx,%eax
  803540:	f7 f5                	div    %ebp
  803542:	89 c1                	mov    %eax,%ecx
  803544:	89 d8                	mov    %ebx,%eax
  803546:	f7 f5                	div    %ebp
  803548:	89 cf                	mov    %ecx,%edi
  80354a:	89 fa                	mov    %edi,%edx
  80354c:	83 c4 1c             	add    $0x1c,%esp
  80354f:	5b                   	pop    %ebx
  803550:	5e                   	pop    %esi
  803551:	5f                   	pop    %edi
  803552:	5d                   	pop    %ebp
  803553:	c3                   	ret    
  803554:	39 ce                	cmp    %ecx,%esi
  803556:	77 28                	ja     803580 <__udivdi3+0x7c>
  803558:	0f bd fe             	bsr    %esi,%edi
  80355b:	83 f7 1f             	xor    $0x1f,%edi
  80355e:	75 40                	jne    8035a0 <__udivdi3+0x9c>
  803560:	39 ce                	cmp    %ecx,%esi
  803562:	72 0a                	jb     80356e <__udivdi3+0x6a>
  803564:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803568:	0f 87 9e 00 00 00    	ja     80360c <__udivdi3+0x108>
  80356e:	b8 01 00 00 00       	mov    $0x1,%eax
  803573:	89 fa                	mov    %edi,%edx
  803575:	83 c4 1c             	add    $0x1c,%esp
  803578:	5b                   	pop    %ebx
  803579:	5e                   	pop    %esi
  80357a:	5f                   	pop    %edi
  80357b:	5d                   	pop    %ebp
  80357c:	c3                   	ret    
  80357d:	8d 76 00             	lea    0x0(%esi),%esi
  803580:	31 ff                	xor    %edi,%edi
  803582:	31 c0                	xor    %eax,%eax
  803584:	89 fa                	mov    %edi,%edx
  803586:	83 c4 1c             	add    $0x1c,%esp
  803589:	5b                   	pop    %ebx
  80358a:	5e                   	pop    %esi
  80358b:	5f                   	pop    %edi
  80358c:	5d                   	pop    %ebp
  80358d:	c3                   	ret    
  80358e:	66 90                	xchg   %ax,%ax
  803590:	89 d8                	mov    %ebx,%eax
  803592:	f7 f7                	div    %edi
  803594:	31 ff                	xor    %edi,%edi
  803596:	89 fa                	mov    %edi,%edx
  803598:	83 c4 1c             	add    $0x1c,%esp
  80359b:	5b                   	pop    %ebx
  80359c:	5e                   	pop    %esi
  80359d:	5f                   	pop    %edi
  80359e:	5d                   	pop    %ebp
  80359f:	c3                   	ret    
  8035a0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8035a5:	89 eb                	mov    %ebp,%ebx
  8035a7:	29 fb                	sub    %edi,%ebx
  8035a9:	89 f9                	mov    %edi,%ecx
  8035ab:	d3 e6                	shl    %cl,%esi
  8035ad:	89 c5                	mov    %eax,%ebp
  8035af:	88 d9                	mov    %bl,%cl
  8035b1:	d3 ed                	shr    %cl,%ebp
  8035b3:	89 e9                	mov    %ebp,%ecx
  8035b5:	09 f1                	or     %esi,%ecx
  8035b7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8035bb:	89 f9                	mov    %edi,%ecx
  8035bd:	d3 e0                	shl    %cl,%eax
  8035bf:	89 c5                	mov    %eax,%ebp
  8035c1:	89 d6                	mov    %edx,%esi
  8035c3:	88 d9                	mov    %bl,%cl
  8035c5:	d3 ee                	shr    %cl,%esi
  8035c7:	89 f9                	mov    %edi,%ecx
  8035c9:	d3 e2                	shl    %cl,%edx
  8035cb:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035cf:	88 d9                	mov    %bl,%cl
  8035d1:	d3 e8                	shr    %cl,%eax
  8035d3:	09 c2                	or     %eax,%edx
  8035d5:	89 d0                	mov    %edx,%eax
  8035d7:	89 f2                	mov    %esi,%edx
  8035d9:	f7 74 24 0c          	divl   0xc(%esp)
  8035dd:	89 d6                	mov    %edx,%esi
  8035df:	89 c3                	mov    %eax,%ebx
  8035e1:	f7 e5                	mul    %ebp
  8035e3:	39 d6                	cmp    %edx,%esi
  8035e5:	72 19                	jb     803600 <__udivdi3+0xfc>
  8035e7:	74 0b                	je     8035f4 <__udivdi3+0xf0>
  8035e9:	89 d8                	mov    %ebx,%eax
  8035eb:	31 ff                	xor    %edi,%edi
  8035ed:	e9 58 ff ff ff       	jmp    80354a <__udivdi3+0x46>
  8035f2:	66 90                	xchg   %ax,%ax
  8035f4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8035f8:	89 f9                	mov    %edi,%ecx
  8035fa:	d3 e2                	shl    %cl,%edx
  8035fc:	39 c2                	cmp    %eax,%edx
  8035fe:	73 e9                	jae    8035e9 <__udivdi3+0xe5>
  803600:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803603:	31 ff                	xor    %edi,%edi
  803605:	e9 40 ff ff ff       	jmp    80354a <__udivdi3+0x46>
  80360a:	66 90                	xchg   %ax,%ax
  80360c:	31 c0                	xor    %eax,%eax
  80360e:	e9 37 ff ff ff       	jmp    80354a <__udivdi3+0x46>
  803613:	90                   	nop

00803614 <__umoddi3>:
  803614:	55                   	push   %ebp
  803615:	57                   	push   %edi
  803616:	56                   	push   %esi
  803617:	53                   	push   %ebx
  803618:	83 ec 1c             	sub    $0x1c,%esp
  80361b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80361f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803623:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803627:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80362b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80362f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803633:	89 f3                	mov    %esi,%ebx
  803635:	89 fa                	mov    %edi,%edx
  803637:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80363b:	89 34 24             	mov    %esi,(%esp)
  80363e:	85 c0                	test   %eax,%eax
  803640:	75 1a                	jne    80365c <__umoddi3+0x48>
  803642:	39 f7                	cmp    %esi,%edi
  803644:	0f 86 a2 00 00 00    	jbe    8036ec <__umoddi3+0xd8>
  80364a:	89 c8                	mov    %ecx,%eax
  80364c:	89 f2                	mov    %esi,%edx
  80364e:	f7 f7                	div    %edi
  803650:	89 d0                	mov    %edx,%eax
  803652:	31 d2                	xor    %edx,%edx
  803654:	83 c4 1c             	add    $0x1c,%esp
  803657:	5b                   	pop    %ebx
  803658:	5e                   	pop    %esi
  803659:	5f                   	pop    %edi
  80365a:	5d                   	pop    %ebp
  80365b:	c3                   	ret    
  80365c:	39 f0                	cmp    %esi,%eax
  80365e:	0f 87 ac 00 00 00    	ja     803710 <__umoddi3+0xfc>
  803664:	0f bd e8             	bsr    %eax,%ebp
  803667:	83 f5 1f             	xor    $0x1f,%ebp
  80366a:	0f 84 ac 00 00 00    	je     80371c <__umoddi3+0x108>
  803670:	bf 20 00 00 00       	mov    $0x20,%edi
  803675:	29 ef                	sub    %ebp,%edi
  803677:	89 fe                	mov    %edi,%esi
  803679:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80367d:	89 e9                	mov    %ebp,%ecx
  80367f:	d3 e0                	shl    %cl,%eax
  803681:	89 d7                	mov    %edx,%edi
  803683:	89 f1                	mov    %esi,%ecx
  803685:	d3 ef                	shr    %cl,%edi
  803687:	09 c7                	or     %eax,%edi
  803689:	89 e9                	mov    %ebp,%ecx
  80368b:	d3 e2                	shl    %cl,%edx
  80368d:	89 14 24             	mov    %edx,(%esp)
  803690:	89 d8                	mov    %ebx,%eax
  803692:	d3 e0                	shl    %cl,%eax
  803694:	89 c2                	mov    %eax,%edx
  803696:	8b 44 24 08          	mov    0x8(%esp),%eax
  80369a:	d3 e0                	shl    %cl,%eax
  80369c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8036a0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8036a4:	89 f1                	mov    %esi,%ecx
  8036a6:	d3 e8                	shr    %cl,%eax
  8036a8:	09 d0                	or     %edx,%eax
  8036aa:	d3 eb                	shr    %cl,%ebx
  8036ac:	89 da                	mov    %ebx,%edx
  8036ae:	f7 f7                	div    %edi
  8036b0:	89 d3                	mov    %edx,%ebx
  8036b2:	f7 24 24             	mull   (%esp)
  8036b5:	89 c6                	mov    %eax,%esi
  8036b7:	89 d1                	mov    %edx,%ecx
  8036b9:	39 d3                	cmp    %edx,%ebx
  8036bb:	0f 82 87 00 00 00    	jb     803748 <__umoddi3+0x134>
  8036c1:	0f 84 91 00 00 00    	je     803758 <__umoddi3+0x144>
  8036c7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8036cb:	29 f2                	sub    %esi,%edx
  8036cd:	19 cb                	sbb    %ecx,%ebx
  8036cf:	89 d8                	mov    %ebx,%eax
  8036d1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8036d5:	d3 e0                	shl    %cl,%eax
  8036d7:	89 e9                	mov    %ebp,%ecx
  8036d9:	d3 ea                	shr    %cl,%edx
  8036db:	09 d0                	or     %edx,%eax
  8036dd:	89 e9                	mov    %ebp,%ecx
  8036df:	d3 eb                	shr    %cl,%ebx
  8036e1:	89 da                	mov    %ebx,%edx
  8036e3:	83 c4 1c             	add    $0x1c,%esp
  8036e6:	5b                   	pop    %ebx
  8036e7:	5e                   	pop    %esi
  8036e8:	5f                   	pop    %edi
  8036e9:	5d                   	pop    %ebp
  8036ea:	c3                   	ret    
  8036eb:	90                   	nop
  8036ec:	89 fd                	mov    %edi,%ebp
  8036ee:	85 ff                	test   %edi,%edi
  8036f0:	75 0b                	jne    8036fd <__umoddi3+0xe9>
  8036f2:	b8 01 00 00 00       	mov    $0x1,%eax
  8036f7:	31 d2                	xor    %edx,%edx
  8036f9:	f7 f7                	div    %edi
  8036fb:	89 c5                	mov    %eax,%ebp
  8036fd:	89 f0                	mov    %esi,%eax
  8036ff:	31 d2                	xor    %edx,%edx
  803701:	f7 f5                	div    %ebp
  803703:	89 c8                	mov    %ecx,%eax
  803705:	f7 f5                	div    %ebp
  803707:	89 d0                	mov    %edx,%eax
  803709:	e9 44 ff ff ff       	jmp    803652 <__umoddi3+0x3e>
  80370e:	66 90                	xchg   %ax,%ax
  803710:	89 c8                	mov    %ecx,%eax
  803712:	89 f2                	mov    %esi,%edx
  803714:	83 c4 1c             	add    $0x1c,%esp
  803717:	5b                   	pop    %ebx
  803718:	5e                   	pop    %esi
  803719:	5f                   	pop    %edi
  80371a:	5d                   	pop    %ebp
  80371b:	c3                   	ret    
  80371c:	3b 04 24             	cmp    (%esp),%eax
  80371f:	72 06                	jb     803727 <__umoddi3+0x113>
  803721:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803725:	77 0f                	ja     803736 <__umoddi3+0x122>
  803727:	89 f2                	mov    %esi,%edx
  803729:	29 f9                	sub    %edi,%ecx
  80372b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80372f:	89 14 24             	mov    %edx,(%esp)
  803732:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803736:	8b 44 24 04          	mov    0x4(%esp),%eax
  80373a:	8b 14 24             	mov    (%esp),%edx
  80373d:	83 c4 1c             	add    $0x1c,%esp
  803740:	5b                   	pop    %ebx
  803741:	5e                   	pop    %esi
  803742:	5f                   	pop    %edi
  803743:	5d                   	pop    %ebp
  803744:	c3                   	ret    
  803745:	8d 76 00             	lea    0x0(%esi),%esi
  803748:	2b 04 24             	sub    (%esp),%eax
  80374b:	19 fa                	sbb    %edi,%edx
  80374d:	89 d1                	mov    %edx,%ecx
  80374f:	89 c6                	mov    %eax,%esi
  803751:	e9 71 ff ff ff       	jmp    8036c7 <__umoddi3+0xb3>
  803756:	66 90                	xchg   %ax,%ax
  803758:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80375c:	72 ea                	jb     803748 <__umoddi3+0x134>
  80375e:	89 d9                	mov    %ebx,%ecx
  803760:	e9 62 ff ff ff       	jmp    8036c7 <__umoddi3+0xb3>
