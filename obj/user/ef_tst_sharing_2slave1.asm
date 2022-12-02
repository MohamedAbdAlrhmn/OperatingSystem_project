
obj/user/ef_tst_sharing_2slave1:     file format elf32-i386


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
  800031:	e8 1e 02 00 00       	call   800254 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Slave program1: Read the 2 shared variables, edit the 3rd one, and exit
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 24             	sub    $0x24,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80003f:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800043:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80004a:	eb 29                	jmp    800075 <_main+0x3d>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004c:	a1 20 50 80 00       	mov    0x805020,%eax
  800051:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800057:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80005a:	89 d0                	mov    %edx,%eax
  80005c:	01 c0                	add    %eax,%eax
  80005e:	01 d0                	add    %edx,%eax
  800060:	c1 e0 03             	shl    $0x3,%eax
  800063:	01 c8                	add    %ecx,%eax
  800065:	8a 40 04             	mov    0x4(%eax),%al
  800068:	84 c0                	test   %al,%al
  80006a:	74 06                	je     800072 <_main+0x3a>
			{
				fullWS = 0;
  80006c:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  800070:	eb 12                	jmp    800084 <_main+0x4c>
_main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800072:	ff 45 f0             	incl   -0x10(%ebp)
  800075:	a1 20 50 80 00       	mov    0x805020,%eax
  80007a:	8b 50 74             	mov    0x74(%eax),%edx
  80007d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800080:	39 c2                	cmp    %eax,%edx
  800082:	77 c8                	ja     80004c <_main+0x14>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800084:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800088:	74 14                	je     80009e <_main+0x66>
  80008a:	83 ec 04             	sub    $0x4,%esp
  80008d:	68 20 36 80 00       	push   $0x803620
  800092:	6a 13                	push   $0x13
  800094:	68 3c 36 80 00       	push   $0x80363c
  800099:	e8 f2 02 00 00       	call   800390 <_panic>
	}
	uint32 *x,*y,*z;
	int32 parentenvID = sys_getparentenvid();
  80009e:	e8 42 1a 00 00       	call   801ae5 <sys_getparentenvid>
  8000a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//GET: z then y then x, opposite to creation order (x then y then z)
	//So, addresses here will be different from the OWNER addresses
	sys_disable_interrupt();
  8000a6:	e8 2e 18 00 00       	call   8018d9 <sys_disable_interrupt>
	int freeFrames = sys_calculate_free_frames() ;
  8000ab:	e8 3c 17 00 00       	call   8017ec <sys_calculate_free_frames>
  8000b0:	89 45 e8             	mov    %eax,-0x18(%ebp)
	z = sget(parentenvID,"z");
  8000b3:	83 ec 08             	sub    $0x8,%esp
  8000b6:	68 5a 36 80 00       	push   $0x80365a
  8000bb:	ff 75 ec             	pushl  -0x14(%ebp)
  8000be:	e8 85 15 00 00       	call   801648 <sget>
  8000c3:	83 c4 10             	add    $0x10,%esp
  8000c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (z != (uint32*)(USER_HEAP_START + 0 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8000c9:	81 7d e4 00 00 00 80 	cmpl   $0x80000000,-0x1c(%ebp)
  8000d0:	74 14                	je     8000e6 <_main+0xae>
  8000d2:	83 ec 04             	sub    $0x4,%esp
  8000d5:	68 5c 36 80 00       	push   $0x80365c
  8000da:	6a 1c                	push   $0x1c
  8000dc:	68 3c 36 80 00       	push   $0x80363c
  8000e1:	e8 aa 02 00 00       	call   800390 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  8000e6:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000e9:	e8 fe 16 00 00       	call   8017ec <sys_calculate_free_frames>
  8000ee:	29 c3                	sub    %eax,%ebx
  8000f0:	89 d8                	mov    %ebx,%eax
  8000f2:	83 f8 01             	cmp    $0x1,%eax
  8000f5:	74 14                	je     80010b <_main+0xd3>
  8000f7:	83 ec 04             	sub    $0x4,%esp
  8000fa:	68 bc 36 80 00       	push   $0x8036bc
  8000ff:	6a 1d                	push   $0x1d
  800101:	68 3c 36 80 00       	push   $0x80363c
  800106:	e8 85 02 00 00       	call   800390 <_panic>
	sys_enable_interrupt();
  80010b:	e8 e3 17 00 00       	call   8018f3 <sys_enable_interrupt>

	sys_disable_interrupt();
  800110:	e8 c4 17 00 00       	call   8018d9 <sys_disable_interrupt>
	freeFrames = sys_calculate_free_frames() ;
  800115:	e8 d2 16 00 00       	call   8017ec <sys_calculate_free_frames>
  80011a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	y = sget(parentenvID,"y");
  80011d:	83 ec 08             	sub    $0x8,%esp
  800120:	68 4d 37 80 00       	push   $0x80374d
  800125:	ff 75 ec             	pushl  -0x14(%ebp)
  800128:	e8 1b 15 00 00       	call   801648 <sget>
  80012d:	83 c4 10             	add    $0x10,%esp
  800130:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (y != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  800133:	81 7d e0 00 10 00 80 	cmpl   $0x80001000,-0x20(%ebp)
  80013a:	74 14                	je     800150 <_main+0x118>
  80013c:	83 ec 04             	sub    $0x4,%esp
  80013f:	68 5c 36 80 00       	push   $0x80365c
  800144:	6a 23                	push   $0x23
  800146:	68 3c 36 80 00       	push   $0x80363c
  80014b:	e8 40 02 00 00       	call   800390 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  800150:	e8 97 16 00 00       	call   8017ec <sys_calculate_free_frames>
  800155:	89 c2                	mov    %eax,%edx
  800157:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80015a:	39 c2                	cmp    %eax,%edx
  80015c:	74 14                	je     800172 <_main+0x13a>
  80015e:	83 ec 04             	sub    $0x4,%esp
  800161:	68 bc 36 80 00       	push   $0x8036bc
  800166:	6a 24                	push   $0x24
  800168:	68 3c 36 80 00       	push   $0x80363c
  80016d:	e8 1e 02 00 00       	call   800390 <_panic>
	sys_enable_interrupt();
  800172:	e8 7c 17 00 00       	call   8018f3 <sys_enable_interrupt>
	
	if (*y != 20) panic("Get(): Shared Variable is not created or got correctly") ;
  800177:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80017a:	8b 00                	mov    (%eax),%eax
  80017c:	83 f8 14             	cmp    $0x14,%eax
  80017f:	74 14                	je     800195 <_main+0x15d>
  800181:	83 ec 04             	sub    $0x4,%esp
  800184:	68 50 37 80 00       	push   $0x803750
  800189:	6a 27                	push   $0x27
  80018b:	68 3c 36 80 00       	push   $0x80363c
  800190:	e8 fb 01 00 00       	call   800390 <_panic>

	sys_disable_interrupt();
  800195:	e8 3f 17 00 00       	call   8018d9 <sys_disable_interrupt>
	freeFrames = sys_calculate_free_frames() ;
  80019a:	e8 4d 16 00 00       	call   8017ec <sys_calculate_free_frames>
  80019f:	89 45 e8             	mov    %eax,-0x18(%ebp)
	x = sget(parentenvID,"x");
  8001a2:	83 ec 08             	sub    $0x8,%esp
  8001a5:	68 87 37 80 00       	push   $0x803787
  8001aa:	ff 75 ec             	pushl  -0x14(%ebp)
  8001ad:	e8 96 14 00 00       	call   801648 <sget>
  8001b2:	83 c4 10             	add    $0x10,%esp
  8001b5:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (x != (uint32*)(USER_HEAP_START + 2 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8001b8:	81 7d dc 00 20 00 80 	cmpl   $0x80002000,-0x24(%ebp)
  8001bf:	74 14                	je     8001d5 <_main+0x19d>
  8001c1:	83 ec 04             	sub    $0x4,%esp
  8001c4:	68 5c 36 80 00       	push   $0x80365c
  8001c9:	6a 2c                	push   $0x2c
  8001cb:	68 3c 36 80 00       	push   $0x80363c
  8001d0:	e8 bb 01 00 00       	call   800390 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  8001d5:	e8 12 16 00 00       	call   8017ec <sys_calculate_free_frames>
  8001da:	89 c2                	mov    %eax,%edx
  8001dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001df:	39 c2                	cmp    %eax,%edx
  8001e1:	74 14                	je     8001f7 <_main+0x1bf>
  8001e3:	83 ec 04             	sub    $0x4,%esp
  8001e6:	68 bc 36 80 00       	push   $0x8036bc
  8001eb:	6a 2d                	push   $0x2d
  8001ed:	68 3c 36 80 00       	push   $0x80363c
  8001f2:	e8 99 01 00 00       	call   800390 <_panic>
	sys_enable_interrupt();
  8001f7:	e8 f7 16 00 00       	call   8018f3 <sys_enable_interrupt>

	if (*x != 10) panic("Get(): Shared Variable is not created or got correctly") ;
  8001fc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001ff:	8b 00                	mov    (%eax),%eax
  800201:	83 f8 0a             	cmp    $0xa,%eax
  800204:	74 14                	je     80021a <_main+0x1e2>
  800206:	83 ec 04             	sub    $0x4,%esp
  800209:	68 50 37 80 00       	push   $0x803750
  80020e:	6a 30                	push   $0x30
  800210:	68 3c 36 80 00       	push   $0x80363c
  800215:	e8 76 01 00 00       	call   800390 <_panic>

	*z = *x + *y ;
  80021a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80021d:	8b 10                	mov    (%eax),%edx
  80021f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800222:	8b 00                	mov    (%eax),%eax
  800224:	01 c2                	add    %eax,%edx
  800226:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800229:	89 10                	mov    %edx,(%eax)
	if (*z != 30) panic("Get(): Shared Variable is not created or got correctly") ;
  80022b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80022e:	8b 00                	mov    (%eax),%eax
  800230:	83 f8 1e             	cmp    $0x1e,%eax
  800233:	74 14                	je     800249 <_main+0x211>
  800235:	83 ec 04             	sub    $0x4,%esp
  800238:	68 50 37 80 00       	push   $0x803750
  80023d:	6a 33                	push   $0x33
  80023f:	68 3c 36 80 00       	push   $0x80363c
  800244:	e8 47 01 00 00       	call   800390 <_panic>

	//To indicate that it's completed successfully
	inctst();
  800249:	e8 bc 19 00 00       	call   801c0a <inctst>

	return;
  80024e:	90                   	nop
}
  80024f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800252:	c9                   	leave  
  800253:	c3                   	ret    

00800254 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800254:	55                   	push   %ebp
  800255:	89 e5                	mov    %esp,%ebp
  800257:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80025a:	e8 6d 18 00 00       	call   801acc <sys_getenvindex>
  80025f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800262:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800265:	89 d0                	mov    %edx,%eax
  800267:	c1 e0 03             	shl    $0x3,%eax
  80026a:	01 d0                	add    %edx,%eax
  80026c:	01 c0                	add    %eax,%eax
  80026e:	01 d0                	add    %edx,%eax
  800270:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800277:	01 d0                	add    %edx,%eax
  800279:	c1 e0 04             	shl    $0x4,%eax
  80027c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800281:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800286:	a1 20 50 80 00       	mov    0x805020,%eax
  80028b:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800291:	84 c0                	test   %al,%al
  800293:	74 0f                	je     8002a4 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800295:	a1 20 50 80 00       	mov    0x805020,%eax
  80029a:	05 5c 05 00 00       	add    $0x55c,%eax
  80029f:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002a4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8002a8:	7e 0a                	jle    8002b4 <libmain+0x60>
		binaryname = argv[0];
  8002aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ad:	8b 00                	mov    (%eax),%eax
  8002af:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8002b4:	83 ec 08             	sub    $0x8,%esp
  8002b7:	ff 75 0c             	pushl  0xc(%ebp)
  8002ba:	ff 75 08             	pushl  0x8(%ebp)
  8002bd:	e8 76 fd ff ff       	call   800038 <_main>
  8002c2:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8002c5:	e8 0f 16 00 00       	call   8018d9 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8002ca:	83 ec 0c             	sub    $0xc,%esp
  8002cd:	68 a4 37 80 00       	push   $0x8037a4
  8002d2:	e8 6d 03 00 00       	call   800644 <cprintf>
  8002d7:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8002da:	a1 20 50 80 00       	mov    0x805020,%eax
  8002df:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8002e5:	a1 20 50 80 00       	mov    0x805020,%eax
  8002ea:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8002f0:	83 ec 04             	sub    $0x4,%esp
  8002f3:	52                   	push   %edx
  8002f4:	50                   	push   %eax
  8002f5:	68 cc 37 80 00       	push   $0x8037cc
  8002fa:	e8 45 03 00 00       	call   800644 <cprintf>
  8002ff:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800302:	a1 20 50 80 00       	mov    0x805020,%eax
  800307:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80030d:	a1 20 50 80 00       	mov    0x805020,%eax
  800312:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800318:	a1 20 50 80 00       	mov    0x805020,%eax
  80031d:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800323:	51                   	push   %ecx
  800324:	52                   	push   %edx
  800325:	50                   	push   %eax
  800326:	68 f4 37 80 00       	push   $0x8037f4
  80032b:	e8 14 03 00 00       	call   800644 <cprintf>
  800330:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800333:	a1 20 50 80 00       	mov    0x805020,%eax
  800338:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80033e:	83 ec 08             	sub    $0x8,%esp
  800341:	50                   	push   %eax
  800342:	68 4c 38 80 00       	push   $0x80384c
  800347:	e8 f8 02 00 00       	call   800644 <cprintf>
  80034c:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80034f:	83 ec 0c             	sub    $0xc,%esp
  800352:	68 a4 37 80 00       	push   $0x8037a4
  800357:	e8 e8 02 00 00       	call   800644 <cprintf>
  80035c:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80035f:	e8 8f 15 00 00       	call   8018f3 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800364:	e8 19 00 00 00       	call   800382 <exit>
}
  800369:	90                   	nop
  80036a:	c9                   	leave  
  80036b:	c3                   	ret    

0080036c <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80036c:	55                   	push   %ebp
  80036d:	89 e5                	mov    %esp,%ebp
  80036f:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800372:	83 ec 0c             	sub    $0xc,%esp
  800375:	6a 00                	push   $0x0
  800377:	e8 1c 17 00 00       	call   801a98 <sys_destroy_env>
  80037c:	83 c4 10             	add    $0x10,%esp
}
  80037f:	90                   	nop
  800380:	c9                   	leave  
  800381:	c3                   	ret    

00800382 <exit>:

void
exit(void)
{
  800382:	55                   	push   %ebp
  800383:	89 e5                	mov    %esp,%ebp
  800385:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800388:	e8 71 17 00 00       	call   801afe <sys_exit_env>
}
  80038d:	90                   	nop
  80038e:	c9                   	leave  
  80038f:	c3                   	ret    

00800390 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800390:	55                   	push   %ebp
  800391:	89 e5                	mov    %esp,%ebp
  800393:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800396:	8d 45 10             	lea    0x10(%ebp),%eax
  800399:	83 c0 04             	add    $0x4,%eax
  80039c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80039f:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8003a4:	85 c0                	test   %eax,%eax
  8003a6:	74 16                	je     8003be <_panic+0x2e>
		cprintf("%s: ", argv0);
  8003a8:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8003ad:	83 ec 08             	sub    $0x8,%esp
  8003b0:	50                   	push   %eax
  8003b1:	68 60 38 80 00       	push   $0x803860
  8003b6:	e8 89 02 00 00       	call   800644 <cprintf>
  8003bb:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8003be:	a1 00 50 80 00       	mov    0x805000,%eax
  8003c3:	ff 75 0c             	pushl  0xc(%ebp)
  8003c6:	ff 75 08             	pushl  0x8(%ebp)
  8003c9:	50                   	push   %eax
  8003ca:	68 65 38 80 00       	push   $0x803865
  8003cf:	e8 70 02 00 00       	call   800644 <cprintf>
  8003d4:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8003d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8003da:	83 ec 08             	sub    $0x8,%esp
  8003dd:	ff 75 f4             	pushl  -0xc(%ebp)
  8003e0:	50                   	push   %eax
  8003e1:	e8 f3 01 00 00       	call   8005d9 <vcprintf>
  8003e6:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8003e9:	83 ec 08             	sub    $0x8,%esp
  8003ec:	6a 00                	push   $0x0
  8003ee:	68 81 38 80 00       	push   $0x803881
  8003f3:	e8 e1 01 00 00       	call   8005d9 <vcprintf>
  8003f8:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8003fb:	e8 82 ff ff ff       	call   800382 <exit>

	// should not return here
	while (1) ;
  800400:	eb fe                	jmp    800400 <_panic+0x70>

00800402 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800402:	55                   	push   %ebp
  800403:	89 e5                	mov    %esp,%ebp
  800405:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800408:	a1 20 50 80 00       	mov    0x805020,%eax
  80040d:	8b 50 74             	mov    0x74(%eax),%edx
  800410:	8b 45 0c             	mov    0xc(%ebp),%eax
  800413:	39 c2                	cmp    %eax,%edx
  800415:	74 14                	je     80042b <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800417:	83 ec 04             	sub    $0x4,%esp
  80041a:	68 84 38 80 00       	push   $0x803884
  80041f:	6a 26                	push   $0x26
  800421:	68 d0 38 80 00       	push   $0x8038d0
  800426:	e8 65 ff ff ff       	call   800390 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80042b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800432:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800439:	e9 c2 00 00 00       	jmp    800500 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80043e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800441:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800448:	8b 45 08             	mov    0x8(%ebp),%eax
  80044b:	01 d0                	add    %edx,%eax
  80044d:	8b 00                	mov    (%eax),%eax
  80044f:	85 c0                	test   %eax,%eax
  800451:	75 08                	jne    80045b <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800453:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800456:	e9 a2 00 00 00       	jmp    8004fd <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80045b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800462:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800469:	eb 69                	jmp    8004d4 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80046b:	a1 20 50 80 00       	mov    0x805020,%eax
  800470:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800476:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800479:	89 d0                	mov    %edx,%eax
  80047b:	01 c0                	add    %eax,%eax
  80047d:	01 d0                	add    %edx,%eax
  80047f:	c1 e0 03             	shl    $0x3,%eax
  800482:	01 c8                	add    %ecx,%eax
  800484:	8a 40 04             	mov    0x4(%eax),%al
  800487:	84 c0                	test   %al,%al
  800489:	75 46                	jne    8004d1 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80048b:	a1 20 50 80 00       	mov    0x805020,%eax
  800490:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800496:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800499:	89 d0                	mov    %edx,%eax
  80049b:	01 c0                	add    %eax,%eax
  80049d:	01 d0                	add    %edx,%eax
  80049f:	c1 e0 03             	shl    $0x3,%eax
  8004a2:	01 c8                	add    %ecx,%eax
  8004a4:	8b 00                	mov    (%eax),%eax
  8004a6:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8004a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004ac:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8004b1:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8004b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004b6:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8004bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c0:	01 c8                	add    %ecx,%eax
  8004c2:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004c4:	39 c2                	cmp    %eax,%edx
  8004c6:	75 09                	jne    8004d1 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8004c8:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8004cf:	eb 12                	jmp    8004e3 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004d1:	ff 45 e8             	incl   -0x18(%ebp)
  8004d4:	a1 20 50 80 00       	mov    0x805020,%eax
  8004d9:	8b 50 74             	mov    0x74(%eax),%edx
  8004dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004df:	39 c2                	cmp    %eax,%edx
  8004e1:	77 88                	ja     80046b <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8004e3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8004e7:	75 14                	jne    8004fd <CheckWSWithoutLastIndex+0xfb>
			panic(
  8004e9:	83 ec 04             	sub    $0x4,%esp
  8004ec:	68 dc 38 80 00       	push   $0x8038dc
  8004f1:	6a 3a                	push   $0x3a
  8004f3:	68 d0 38 80 00       	push   $0x8038d0
  8004f8:	e8 93 fe ff ff       	call   800390 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8004fd:	ff 45 f0             	incl   -0x10(%ebp)
  800500:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800503:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800506:	0f 8c 32 ff ff ff    	jl     80043e <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80050c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800513:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80051a:	eb 26                	jmp    800542 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80051c:	a1 20 50 80 00       	mov    0x805020,%eax
  800521:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800527:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80052a:	89 d0                	mov    %edx,%eax
  80052c:	01 c0                	add    %eax,%eax
  80052e:	01 d0                	add    %edx,%eax
  800530:	c1 e0 03             	shl    $0x3,%eax
  800533:	01 c8                	add    %ecx,%eax
  800535:	8a 40 04             	mov    0x4(%eax),%al
  800538:	3c 01                	cmp    $0x1,%al
  80053a:	75 03                	jne    80053f <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80053c:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80053f:	ff 45 e0             	incl   -0x20(%ebp)
  800542:	a1 20 50 80 00       	mov    0x805020,%eax
  800547:	8b 50 74             	mov    0x74(%eax),%edx
  80054a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80054d:	39 c2                	cmp    %eax,%edx
  80054f:	77 cb                	ja     80051c <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800551:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800554:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800557:	74 14                	je     80056d <CheckWSWithoutLastIndex+0x16b>
		panic(
  800559:	83 ec 04             	sub    $0x4,%esp
  80055c:	68 30 39 80 00       	push   $0x803930
  800561:	6a 44                	push   $0x44
  800563:	68 d0 38 80 00       	push   $0x8038d0
  800568:	e8 23 fe ff ff       	call   800390 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80056d:	90                   	nop
  80056e:	c9                   	leave  
  80056f:	c3                   	ret    

00800570 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800570:	55                   	push   %ebp
  800571:	89 e5                	mov    %esp,%ebp
  800573:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800576:	8b 45 0c             	mov    0xc(%ebp),%eax
  800579:	8b 00                	mov    (%eax),%eax
  80057b:	8d 48 01             	lea    0x1(%eax),%ecx
  80057e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800581:	89 0a                	mov    %ecx,(%edx)
  800583:	8b 55 08             	mov    0x8(%ebp),%edx
  800586:	88 d1                	mov    %dl,%cl
  800588:	8b 55 0c             	mov    0xc(%ebp),%edx
  80058b:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80058f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800592:	8b 00                	mov    (%eax),%eax
  800594:	3d ff 00 00 00       	cmp    $0xff,%eax
  800599:	75 2c                	jne    8005c7 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80059b:	a0 24 50 80 00       	mov    0x805024,%al
  8005a0:	0f b6 c0             	movzbl %al,%eax
  8005a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005a6:	8b 12                	mov    (%edx),%edx
  8005a8:	89 d1                	mov    %edx,%ecx
  8005aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005ad:	83 c2 08             	add    $0x8,%edx
  8005b0:	83 ec 04             	sub    $0x4,%esp
  8005b3:	50                   	push   %eax
  8005b4:	51                   	push   %ecx
  8005b5:	52                   	push   %edx
  8005b6:	e8 70 11 00 00       	call   80172b <sys_cputs>
  8005bb:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8005be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8005c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005ca:	8b 40 04             	mov    0x4(%eax),%eax
  8005cd:	8d 50 01             	lea    0x1(%eax),%edx
  8005d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005d3:	89 50 04             	mov    %edx,0x4(%eax)
}
  8005d6:	90                   	nop
  8005d7:	c9                   	leave  
  8005d8:	c3                   	ret    

008005d9 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8005d9:	55                   	push   %ebp
  8005da:	89 e5                	mov    %esp,%ebp
  8005dc:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8005e2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005e9:	00 00 00 
	b.cnt = 0;
  8005ec:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8005f3:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8005f6:	ff 75 0c             	pushl  0xc(%ebp)
  8005f9:	ff 75 08             	pushl  0x8(%ebp)
  8005fc:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800602:	50                   	push   %eax
  800603:	68 70 05 80 00       	push   $0x800570
  800608:	e8 11 02 00 00       	call   80081e <vprintfmt>
  80060d:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800610:	a0 24 50 80 00       	mov    0x805024,%al
  800615:	0f b6 c0             	movzbl %al,%eax
  800618:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80061e:	83 ec 04             	sub    $0x4,%esp
  800621:	50                   	push   %eax
  800622:	52                   	push   %edx
  800623:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800629:	83 c0 08             	add    $0x8,%eax
  80062c:	50                   	push   %eax
  80062d:	e8 f9 10 00 00       	call   80172b <sys_cputs>
  800632:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800635:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  80063c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800642:	c9                   	leave  
  800643:	c3                   	ret    

00800644 <cprintf>:

int cprintf(const char *fmt, ...) {
  800644:	55                   	push   %ebp
  800645:	89 e5                	mov    %esp,%ebp
  800647:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80064a:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800651:	8d 45 0c             	lea    0xc(%ebp),%eax
  800654:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800657:	8b 45 08             	mov    0x8(%ebp),%eax
  80065a:	83 ec 08             	sub    $0x8,%esp
  80065d:	ff 75 f4             	pushl  -0xc(%ebp)
  800660:	50                   	push   %eax
  800661:	e8 73 ff ff ff       	call   8005d9 <vcprintf>
  800666:	83 c4 10             	add    $0x10,%esp
  800669:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80066c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80066f:	c9                   	leave  
  800670:	c3                   	ret    

00800671 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800671:	55                   	push   %ebp
  800672:	89 e5                	mov    %esp,%ebp
  800674:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800677:	e8 5d 12 00 00       	call   8018d9 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80067c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80067f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800682:	8b 45 08             	mov    0x8(%ebp),%eax
  800685:	83 ec 08             	sub    $0x8,%esp
  800688:	ff 75 f4             	pushl  -0xc(%ebp)
  80068b:	50                   	push   %eax
  80068c:	e8 48 ff ff ff       	call   8005d9 <vcprintf>
  800691:	83 c4 10             	add    $0x10,%esp
  800694:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800697:	e8 57 12 00 00       	call   8018f3 <sys_enable_interrupt>
	return cnt;
  80069c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80069f:	c9                   	leave  
  8006a0:	c3                   	ret    

008006a1 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006a1:	55                   	push   %ebp
  8006a2:	89 e5                	mov    %esp,%ebp
  8006a4:	53                   	push   %ebx
  8006a5:	83 ec 14             	sub    $0x14,%esp
  8006a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8006ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006b4:	8b 45 18             	mov    0x18(%ebp),%eax
  8006b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8006bc:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006bf:	77 55                	ja     800716 <printnum+0x75>
  8006c1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006c4:	72 05                	jb     8006cb <printnum+0x2a>
  8006c6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8006c9:	77 4b                	ja     800716 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006cb:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8006ce:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8006d1:	8b 45 18             	mov    0x18(%ebp),%eax
  8006d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8006d9:	52                   	push   %edx
  8006da:	50                   	push   %eax
  8006db:	ff 75 f4             	pushl  -0xc(%ebp)
  8006de:	ff 75 f0             	pushl  -0x10(%ebp)
  8006e1:	e8 ca 2c 00 00       	call   8033b0 <__udivdi3>
  8006e6:	83 c4 10             	add    $0x10,%esp
  8006e9:	83 ec 04             	sub    $0x4,%esp
  8006ec:	ff 75 20             	pushl  0x20(%ebp)
  8006ef:	53                   	push   %ebx
  8006f0:	ff 75 18             	pushl  0x18(%ebp)
  8006f3:	52                   	push   %edx
  8006f4:	50                   	push   %eax
  8006f5:	ff 75 0c             	pushl  0xc(%ebp)
  8006f8:	ff 75 08             	pushl  0x8(%ebp)
  8006fb:	e8 a1 ff ff ff       	call   8006a1 <printnum>
  800700:	83 c4 20             	add    $0x20,%esp
  800703:	eb 1a                	jmp    80071f <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800705:	83 ec 08             	sub    $0x8,%esp
  800708:	ff 75 0c             	pushl  0xc(%ebp)
  80070b:	ff 75 20             	pushl  0x20(%ebp)
  80070e:	8b 45 08             	mov    0x8(%ebp),%eax
  800711:	ff d0                	call   *%eax
  800713:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800716:	ff 4d 1c             	decl   0x1c(%ebp)
  800719:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80071d:	7f e6                	jg     800705 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80071f:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800722:	bb 00 00 00 00       	mov    $0x0,%ebx
  800727:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80072a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80072d:	53                   	push   %ebx
  80072e:	51                   	push   %ecx
  80072f:	52                   	push   %edx
  800730:	50                   	push   %eax
  800731:	e8 8a 2d 00 00       	call   8034c0 <__umoddi3>
  800736:	83 c4 10             	add    $0x10,%esp
  800739:	05 94 3b 80 00       	add    $0x803b94,%eax
  80073e:	8a 00                	mov    (%eax),%al
  800740:	0f be c0             	movsbl %al,%eax
  800743:	83 ec 08             	sub    $0x8,%esp
  800746:	ff 75 0c             	pushl  0xc(%ebp)
  800749:	50                   	push   %eax
  80074a:	8b 45 08             	mov    0x8(%ebp),%eax
  80074d:	ff d0                	call   *%eax
  80074f:	83 c4 10             	add    $0x10,%esp
}
  800752:	90                   	nop
  800753:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800756:	c9                   	leave  
  800757:	c3                   	ret    

00800758 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800758:	55                   	push   %ebp
  800759:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80075b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80075f:	7e 1c                	jle    80077d <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800761:	8b 45 08             	mov    0x8(%ebp),%eax
  800764:	8b 00                	mov    (%eax),%eax
  800766:	8d 50 08             	lea    0x8(%eax),%edx
  800769:	8b 45 08             	mov    0x8(%ebp),%eax
  80076c:	89 10                	mov    %edx,(%eax)
  80076e:	8b 45 08             	mov    0x8(%ebp),%eax
  800771:	8b 00                	mov    (%eax),%eax
  800773:	83 e8 08             	sub    $0x8,%eax
  800776:	8b 50 04             	mov    0x4(%eax),%edx
  800779:	8b 00                	mov    (%eax),%eax
  80077b:	eb 40                	jmp    8007bd <getuint+0x65>
	else if (lflag)
  80077d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800781:	74 1e                	je     8007a1 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800783:	8b 45 08             	mov    0x8(%ebp),%eax
  800786:	8b 00                	mov    (%eax),%eax
  800788:	8d 50 04             	lea    0x4(%eax),%edx
  80078b:	8b 45 08             	mov    0x8(%ebp),%eax
  80078e:	89 10                	mov    %edx,(%eax)
  800790:	8b 45 08             	mov    0x8(%ebp),%eax
  800793:	8b 00                	mov    (%eax),%eax
  800795:	83 e8 04             	sub    $0x4,%eax
  800798:	8b 00                	mov    (%eax),%eax
  80079a:	ba 00 00 00 00       	mov    $0x0,%edx
  80079f:	eb 1c                	jmp    8007bd <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8007a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a4:	8b 00                	mov    (%eax),%eax
  8007a6:	8d 50 04             	lea    0x4(%eax),%edx
  8007a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ac:	89 10                	mov    %edx,(%eax)
  8007ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b1:	8b 00                	mov    (%eax),%eax
  8007b3:	83 e8 04             	sub    $0x4,%eax
  8007b6:	8b 00                	mov    (%eax),%eax
  8007b8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8007bd:	5d                   	pop    %ebp
  8007be:	c3                   	ret    

008007bf <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007bf:	55                   	push   %ebp
  8007c0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007c2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007c6:	7e 1c                	jle    8007e4 <getint+0x25>
		return va_arg(*ap, long long);
  8007c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cb:	8b 00                	mov    (%eax),%eax
  8007cd:	8d 50 08             	lea    0x8(%eax),%edx
  8007d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d3:	89 10                	mov    %edx,(%eax)
  8007d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d8:	8b 00                	mov    (%eax),%eax
  8007da:	83 e8 08             	sub    $0x8,%eax
  8007dd:	8b 50 04             	mov    0x4(%eax),%edx
  8007e0:	8b 00                	mov    (%eax),%eax
  8007e2:	eb 38                	jmp    80081c <getint+0x5d>
	else if (lflag)
  8007e4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007e8:	74 1a                	je     800804 <getint+0x45>
		return va_arg(*ap, long);
  8007ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ed:	8b 00                	mov    (%eax),%eax
  8007ef:	8d 50 04             	lea    0x4(%eax),%edx
  8007f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f5:	89 10                	mov    %edx,(%eax)
  8007f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fa:	8b 00                	mov    (%eax),%eax
  8007fc:	83 e8 04             	sub    $0x4,%eax
  8007ff:	8b 00                	mov    (%eax),%eax
  800801:	99                   	cltd   
  800802:	eb 18                	jmp    80081c <getint+0x5d>
	else
		return va_arg(*ap, int);
  800804:	8b 45 08             	mov    0x8(%ebp),%eax
  800807:	8b 00                	mov    (%eax),%eax
  800809:	8d 50 04             	lea    0x4(%eax),%edx
  80080c:	8b 45 08             	mov    0x8(%ebp),%eax
  80080f:	89 10                	mov    %edx,(%eax)
  800811:	8b 45 08             	mov    0x8(%ebp),%eax
  800814:	8b 00                	mov    (%eax),%eax
  800816:	83 e8 04             	sub    $0x4,%eax
  800819:	8b 00                	mov    (%eax),%eax
  80081b:	99                   	cltd   
}
  80081c:	5d                   	pop    %ebp
  80081d:	c3                   	ret    

0080081e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80081e:	55                   	push   %ebp
  80081f:	89 e5                	mov    %esp,%ebp
  800821:	56                   	push   %esi
  800822:	53                   	push   %ebx
  800823:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800826:	eb 17                	jmp    80083f <vprintfmt+0x21>
			if (ch == '\0')
  800828:	85 db                	test   %ebx,%ebx
  80082a:	0f 84 af 03 00 00    	je     800bdf <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800830:	83 ec 08             	sub    $0x8,%esp
  800833:	ff 75 0c             	pushl  0xc(%ebp)
  800836:	53                   	push   %ebx
  800837:	8b 45 08             	mov    0x8(%ebp),%eax
  80083a:	ff d0                	call   *%eax
  80083c:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80083f:	8b 45 10             	mov    0x10(%ebp),%eax
  800842:	8d 50 01             	lea    0x1(%eax),%edx
  800845:	89 55 10             	mov    %edx,0x10(%ebp)
  800848:	8a 00                	mov    (%eax),%al
  80084a:	0f b6 d8             	movzbl %al,%ebx
  80084d:	83 fb 25             	cmp    $0x25,%ebx
  800850:	75 d6                	jne    800828 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800852:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800856:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80085d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800864:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80086b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800872:	8b 45 10             	mov    0x10(%ebp),%eax
  800875:	8d 50 01             	lea    0x1(%eax),%edx
  800878:	89 55 10             	mov    %edx,0x10(%ebp)
  80087b:	8a 00                	mov    (%eax),%al
  80087d:	0f b6 d8             	movzbl %al,%ebx
  800880:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800883:	83 f8 55             	cmp    $0x55,%eax
  800886:	0f 87 2b 03 00 00    	ja     800bb7 <vprintfmt+0x399>
  80088c:	8b 04 85 b8 3b 80 00 	mov    0x803bb8(,%eax,4),%eax
  800893:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800895:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800899:	eb d7                	jmp    800872 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80089b:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80089f:	eb d1                	jmp    800872 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008a1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8008a8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008ab:	89 d0                	mov    %edx,%eax
  8008ad:	c1 e0 02             	shl    $0x2,%eax
  8008b0:	01 d0                	add    %edx,%eax
  8008b2:	01 c0                	add    %eax,%eax
  8008b4:	01 d8                	add    %ebx,%eax
  8008b6:	83 e8 30             	sub    $0x30,%eax
  8008b9:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8008bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8008bf:	8a 00                	mov    (%eax),%al
  8008c1:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8008c4:	83 fb 2f             	cmp    $0x2f,%ebx
  8008c7:	7e 3e                	jle    800907 <vprintfmt+0xe9>
  8008c9:	83 fb 39             	cmp    $0x39,%ebx
  8008cc:	7f 39                	jg     800907 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008ce:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008d1:	eb d5                	jmp    8008a8 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8008d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d6:	83 c0 04             	add    $0x4,%eax
  8008d9:	89 45 14             	mov    %eax,0x14(%ebp)
  8008dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8008df:	83 e8 04             	sub    $0x4,%eax
  8008e2:	8b 00                	mov    (%eax),%eax
  8008e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8008e7:	eb 1f                	jmp    800908 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008e9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ed:	79 83                	jns    800872 <vprintfmt+0x54>
				width = 0;
  8008ef:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8008f6:	e9 77 ff ff ff       	jmp    800872 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008fb:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800902:	e9 6b ff ff ff       	jmp    800872 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800907:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800908:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80090c:	0f 89 60 ff ff ff    	jns    800872 <vprintfmt+0x54>
				width = precision, precision = -1;
  800912:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800915:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800918:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80091f:	e9 4e ff ff ff       	jmp    800872 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800924:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800927:	e9 46 ff ff ff       	jmp    800872 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80092c:	8b 45 14             	mov    0x14(%ebp),%eax
  80092f:	83 c0 04             	add    $0x4,%eax
  800932:	89 45 14             	mov    %eax,0x14(%ebp)
  800935:	8b 45 14             	mov    0x14(%ebp),%eax
  800938:	83 e8 04             	sub    $0x4,%eax
  80093b:	8b 00                	mov    (%eax),%eax
  80093d:	83 ec 08             	sub    $0x8,%esp
  800940:	ff 75 0c             	pushl  0xc(%ebp)
  800943:	50                   	push   %eax
  800944:	8b 45 08             	mov    0x8(%ebp),%eax
  800947:	ff d0                	call   *%eax
  800949:	83 c4 10             	add    $0x10,%esp
			break;
  80094c:	e9 89 02 00 00       	jmp    800bda <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800951:	8b 45 14             	mov    0x14(%ebp),%eax
  800954:	83 c0 04             	add    $0x4,%eax
  800957:	89 45 14             	mov    %eax,0x14(%ebp)
  80095a:	8b 45 14             	mov    0x14(%ebp),%eax
  80095d:	83 e8 04             	sub    $0x4,%eax
  800960:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800962:	85 db                	test   %ebx,%ebx
  800964:	79 02                	jns    800968 <vprintfmt+0x14a>
				err = -err;
  800966:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800968:	83 fb 64             	cmp    $0x64,%ebx
  80096b:	7f 0b                	jg     800978 <vprintfmt+0x15a>
  80096d:	8b 34 9d 00 3a 80 00 	mov    0x803a00(,%ebx,4),%esi
  800974:	85 f6                	test   %esi,%esi
  800976:	75 19                	jne    800991 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800978:	53                   	push   %ebx
  800979:	68 a5 3b 80 00       	push   $0x803ba5
  80097e:	ff 75 0c             	pushl  0xc(%ebp)
  800981:	ff 75 08             	pushl  0x8(%ebp)
  800984:	e8 5e 02 00 00       	call   800be7 <printfmt>
  800989:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80098c:	e9 49 02 00 00       	jmp    800bda <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800991:	56                   	push   %esi
  800992:	68 ae 3b 80 00       	push   $0x803bae
  800997:	ff 75 0c             	pushl  0xc(%ebp)
  80099a:	ff 75 08             	pushl  0x8(%ebp)
  80099d:	e8 45 02 00 00       	call   800be7 <printfmt>
  8009a2:	83 c4 10             	add    $0x10,%esp
			break;
  8009a5:	e9 30 02 00 00       	jmp    800bda <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8009aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ad:	83 c0 04             	add    $0x4,%eax
  8009b0:	89 45 14             	mov    %eax,0x14(%ebp)
  8009b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b6:	83 e8 04             	sub    $0x4,%eax
  8009b9:	8b 30                	mov    (%eax),%esi
  8009bb:	85 f6                	test   %esi,%esi
  8009bd:	75 05                	jne    8009c4 <vprintfmt+0x1a6>
				p = "(null)";
  8009bf:	be b1 3b 80 00       	mov    $0x803bb1,%esi
			if (width > 0 && padc != '-')
  8009c4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009c8:	7e 6d                	jle    800a37 <vprintfmt+0x219>
  8009ca:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8009ce:	74 67                	je     800a37 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009d3:	83 ec 08             	sub    $0x8,%esp
  8009d6:	50                   	push   %eax
  8009d7:	56                   	push   %esi
  8009d8:	e8 0c 03 00 00       	call   800ce9 <strnlen>
  8009dd:	83 c4 10             	add    $0x10,%esp
  8009e0:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8009e3:	eb 16                	jmp    8009fb <vprintfmt+0x1dd>
					putch(padc, putdat);
  8009e5:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009e9:	83 ec 08             	sub    $0x8,%esp
  8009ec:	ff 75 0c             	pushl  0xc(%ebp)
  8009ef:	50                   	push   %eax
  8009f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f3:	ff d0                	call   *%eax
  8009f5:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009f8:	ff 4d e4             	decl   -0x1c(%ebp)
  8009fb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009ff:	7f e4                	jg     8009e5 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a01:	eb 34                	jmp    800a37 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a03:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a07:	74 1c                	je     800a25 <vprintfmt+0x207>
  800a09:	83 fb 1f             	cmp    $0x1f,%ebx
  800a0c:	7e 05                	jle    800a13 <vprintfmt+0x1f5>
  800a0e:	83 fb 7e             	cmp    $0x7e,%ebx
  800a11:	7e 12                	jle    800a25 <vprintfmt+0x207>
					putch('?', putdat);
  800a13:	83 ec 08             	sub    $0x8,%esp
  800a16:	ff 75 0c             	pushl  0xc(%ebp)
  800a19:	6a 3f                	push   $0x3f
  800a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1e:	ff d0                	call   *%eax
  800a20:	83 c4 10             	add    $0x10,%esp
  800a23:	eb 0f                	jmp    800a34 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a25:	83 ec 08             	sub    $0x8,%esp
  800a28:	ff 75 0c             	pushl  0xc(%ebp)
  800a2b:	53                   	push   %ebx
  800a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2f:	ff d0                	call   *%eax
  800a31:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a34:	ff 4d e4             	decl   -0x1c(%ebp)
  800a37:	89 f0                	mov    %esi,%eax
  800a39:	8d 70 01             	lea    0x1(%eax),%esi
  800a3c:	8a 00                	mov    (%eax),%al
  800a3e:	0f be d8             	movsbl %al,%ebx
  800a41:	85 db                	test   %ebx,%ebx
  800a43:	74 24                	je     800a69 <vprintfmt+0x24b>
  800a45:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a49:	78 b8                	js     800a03 <vprintfmt+0x1e5>
  800a4b:	ff 4d e0             	decl   -0x20(%ebp)
  800a4e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a52:	79 af                	jns    800a03 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a54:	eb 13                	jmp    800a69 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a56:	83 ec 08             	sub    $0x8,%esp
  800a59:	ff 75 0c             	pushl  0xc(%ebp)
  800a5c:	6a 20                	push   $0x20
  800a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a61:	ff d0                	call   *%eax
  800a63:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a66:	ff 4d e4             	decl   -0x1c(%ebp)
  800a69:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a6d:	7f e7                	jg     800a56 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a6f:	e9 66 01 00 00       	jmp    800bda <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a74:	83 ec 08             	sub    $0x8,%esp
  800a77:	ff 75 e8             	pushl  -0x18(%ebp)
  800a7a:	8d 45 14             	lea    0x14(%ebp),%eax
  800a7d:	50                   	push   %eax
  800a7e:	e8 3c fd ff ff       	call   8007bf <getint>
  800a83:	83 c4 10             	add    $0x10,%esp
  800a86:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a89:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a8f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a92:	85 d2                	test   %edx,%edx
  800a94:	79 23                	jns    800ab9 <vprintfmt+0x29b>
				putch('-', putdat);
  800a96:	83 ec 08             	sub    $0x8,%esp
  800a99:	ff 75 0c             	pushl  0xc(%ebp)
  800a9c:	6a 2d                	push   $0x2d
  800a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa1:	ff d0                	call   *%eax
  800aa3:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800aa6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800aa9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800aac:	f7 d8                	neg    %eax
  800aae:	83 d2 00             	adc    $0x0,%edx
  800ab1:	f7 da                	neg    %edx
  800ab3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ab6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800ab9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ac0:	e9 bc 00 00 00       	jmp    800b81 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ac5:	83 ec 08             	sub    $0x8,%esp
  800ac8:	ff 75 e8             	pushl  -0x18(%ebp)
  800acb:	8d 45 14             	lea    0x14(%ebp),%eax
  800ace:	50                   	push   %eax
  800acf:	e8 84 fc ff ff       	call   800758 <getuint>
  800ad4:	83 c4 10             	add    $0x10,%esp
  800ad7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ada:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800add:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ae4:	e9 98 00 00 00       	jmp    800b81 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ae9:	83 ec 08             	sub    $0x8,%esp
  800aec:	ff 75 0c             	pushl  0xc(%ebp)
  800aef:	6a 58                	push   $0x58
  800af1:	8b 45 08             	mov    0x8(%ebp),%eax
  800af4:	ff d0                	call   *%eax
  800af6:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800af9:	83 ec 08             	sub    $0x8,%esp
  800afc:	ff 75 0c             	pushl  0xc(%ebp)
  800aff:	6a 58                	push   $0x58
  800b01:	8b 45 08             	mov    0x8(%ebp),%eax
  800b04:	ff d0                	call   *%eax
  800b06:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b09:	83 ec 08             	sub    $0x8,%esp
  800b0c:	ff 75 0c             	pushl  0xc(%ebp)
  800b0f:	6a 58                	push   $0x58
  800b11:	8b 45 08             	mov    0x8(%ebp),%eax
  800b14:	ff d0                	call   *%eax
  800b16:	83 c4 10             	add    $0x10,%esp
			break;
  800b19:	e9 bc 00 00 00       	jmp    800bda <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800b1e:	83 ec 08             	sub    $0x8,%esp
  800b21:	ff 75 0c             	pushl  0xc(%ebp)
  800b24:	6a 30                	push   $0x30
  800b26:	8b 45 08             	mov    0x8(%ebp),%eax
  800b29:	ff d0                	call   *%eax
  800b2b:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b2e:	83 ec 08             	sub    $0x8,%esp
  800b31:	ff 75 0c             	pushl  0xc(%ebp)
  800b34:	6a 78                	push   $0x78
  800b36:	8b 45 08             	mov    0x8(%ebp),%eax
  800b39:	ff d0                	call   *%eax
  800b3b:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b3e:	8b 45 14             	mov    0x14(%ebp),%eax
  800b41:	83 c0 04             	add    $0x4,%eax
  800b44:	89 45 14             	mov    %eax,0x14(%ebp)
  800b47:	8b 45 14             	mov    0x14(%ebp),%eax
  800b4a:	83 e8 04             	sub    $0x4,%eax
  800b4d:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b52:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b59:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b60:	eb 1f                	jmp    800b81 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b62:	83 ec 08             	sub    $0x8,%esp
  800b65:	ff 75 e8             	pushl  -0x18(%ebp)
  800b68:	8d 45 14             	lea    0x14(%ebp),%eax
  800b6b:	50                   	push   %eax
  800b6c:	e8 e7 fb ff ff       	call   800758 <getuint>
  800b71:	83 c4 10             	add    $0x10,%esp
  800b74:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b77:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b7a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b81:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b85:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b88:	83 ec 04             	sub    $0x4,%esp
  800b8b:	52                   	push   %edx
  800b8c:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b8f:	50                   	push   %eax
  800b90:	ff 75 f4             	pushl  -0xc(%ebp)
  800b93:	ff 75 f0             	pushl  -0x10(%ebp)
  800b96:	ff 75 0c             	pushl  0xc(%ebp)
  800b99:	ff 75 08             	pushl  0x8(%ebp)
  800b9c:	e8 00 fb ff ff       	call   8006a1 <printnum>
  800ba1:	83 c4 20             	add    $0x20,%esp
			break;
  800ba4:	eb 34                	jmp    800bda <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ba6:	83 ec 08             	sub    $0x8,%esp
  800ba9:	ff 75 0c             	pushl  0xc(%ebp)
  800bac:	53                   	push   %ebx
  800bad:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb0:	ff d0                	call   *%eax
  800bb2:	83 c4 10             	add    $0x10,%esp
			break;
  800bb5:	eb 23                	jmp    800bda <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800bb7:	83 ec 08             	sub    $0x8,%esp
  800bba:	ff 75 0c             	pushl  0xc(%ebp)
  800bbd:	6a 25                	push   $0x25
  800bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc2:	ff d0                	call   *%eax
  800bc4:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800bc7:	ff 4d 10             	decl   0x10(%ebp)
  800bca:	eb 03                	jmp    800bcf <vprintfmt+0x3b1>
  800bcc:	ff 4d 10             	decl   0x10(%ebp)
  800bcf:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd2:	48                   	dec    %eax
  800bd3:	8a 00                	mov    (%eax),%al
  800bd5:	3c 25                	cmp    $0x25,%al
  800bd7:	75 f3                	jne    800bcc <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800bd9:	90                   	nop
		}
	}
  800bda:	e9 47 fc ff ff       	jmp    800826 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800bdf:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800be0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800be3:	5b                   	pop    %ebx
  800be4:	5e                   	pop    %esi
  800be5:	5d                   	pop    %ebp
  800be6:	c3                   	ret    

00800be7 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800be7:	55                   	push   %ebp
  800be8:	89 e5                	mov    %esp,%ebp
  800bea:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800bed:	8d 45 10             	lea    0x10(%ebp),%eax
  800bf0:	83 c0 04             	add    $0x4,%eax
  800bf3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800bf6:	8b 45 10             	mov    0x10(%ebp),%eax
  800bf9:	ff 75 f4             	pushl  -0xc(%ebp)
  800bfc:	50                   	push   %eax
  800bfd:	ff 75 0c             	pushl  0xc(%ebp)
  800c00:	ff 75 08             	pushl  0x8(%ebp)
  800c03:	e8 16 fc ff ff       	call   80081e <vprintfmt>
  800c08:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c0b:	90                   	nop
  800c0c:	c9                   	leave  
  800c0d:	c3                   	ret    

00800c0e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c0e:	55                   	push   %ebp
  800c0f:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c11:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c14:	8b 40 08             	mov    0x8(%eax),%eax
  800c17:	8d 50 01             	lea    0x1(%eax),%edx
  800c1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c1d:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c20:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c23:	8b 10                	mov    (%eax),%edx
  800c25:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c28:	8b 40 04             	mov    0x4(%eax),%eax
  800c2b:	39 c2                	cmp    %eax,%edx
  800c2d:	73 12                	jae    800c41 <sprintputch+0x33>
		*b->buf++ = ch;
  800c2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c32:	8b 00                	mov    (%eax),%eax
  800c34:	8d 48 01             	lea    0x1(%eax),%ecx
  800c37:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c3a:	89 0a                	mov    %ecx,(%edx)
  800c3c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c3f:	88 10                	mov    %dl,(%eax)
}
  800c41:	90                   	nop
  800c42:	5d                   	pop    %ebp
  800c43:	c3                   	ret    

00800c44 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c44:	55                   	push   %ebp
  800c45:	89 e5                	mov    %esp,%ebp
  800c47:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c53:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c56:	8b 45 08             	mov    0x8(%ebp),%eax
  800c59:	01 d0                	add    %edx,%eax
  800c5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c5e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c65:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c69:	74 06                	je     800c71 <vsnprintf+0x2d>
  800c6b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c6f:	7f 07                	jg     800c78 <vsnprintf+0x34>
		return -E_INVAL;
  800c71:	b8 03 00 00 00       	mov    $0x3,%eax
  800c76:	eb 20                	jmp    800c98 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c78:	ff 75 14             	pushl  0x14(%ebp)
  800c7b:	ff 75 10             	pushl  0x10(%ebp)
  800c7e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c81:	50                   	push   %eax
  800c82:	68 0e 0c 80 00       	push   $0x800c0e
  800c87:	e8 92 fb ff ff       	call   80081e <vprintfmt>
  800c8c:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c92:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c95:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c98:	c9                   	leave  
  800c99:	c3                   	ret    

00800c9a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c9a:	55                   	push   %ebp
  800c9b:	89 e5                	mov    %esp,%ebp
  800c9d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ca0:	8d 45 10             	lea    0x10(%ebp),%eax
  800ca3:	83 c0 04             	add    $0x4,%eax
  800ca6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ca9:	8b 45 10             	mov    0x10(%ebp),%eax
  800cac:	ff 75 f4             	pushl  -0xc(%ebp)
  800caf:	50                   	push   %eax
  800cb0:	ff 75 0c             	pushl  0xc(%ebp)
  800cb3:	ff 75 08             	pushl  0x8(%ebp)
  800cb6:	e8 89 ff ff ff       	call   800c44 <vsnprintf>
  800cbb:	83 c4 10             	add    $0x10,%esp
  800cbe:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800cc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800cc4:	c9                   	leave  
  800cc5:	c3                   	ret    

00800cc6 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800cc6:	55                   	push   %ebp
  800cc7:	89 e5                	mov    %esp,%ebp
  800cc9:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800ccc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cd3:	eb 06                	jmp    800cdb <strlen+0x15>
		n++;
  800cd5:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800cd8:	ff 45 08             	incl   0x8(%ebp)
  800cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cde:	8a 00                	mov    (%eax),%al
  800ce0:	84 c0                	test   %al,%al
  800ce2:	75 f1                	jne    800cd5 <strlen+0xf>
		n++;
	return n;
  800ce4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ce7:	c9                   	leave  
  800ce8:	c3                   	ret    

00800ce9 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800ce9:	55                   	push   %ebp
  800cea:	89 e5                	mov    %esp,%ebp
  800cec:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cf6:	eb 09                	jmp    800d01 <strnlen+0x18>
		n++;
  800cf8:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cfb:	ff 45 08             	incl   0x8(%ebp)
  800cfe:	ff 4d 0c             	decl   0xc(%ebp)
  800d01:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d05:	74 09                	je     800d10 <strnlen+0x27>
  800d07:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0a:	8a 00                	mov    (%eax),%al
  800d0c:	84 c0                	test   %al,%al
  800d0e:	75 e8                	jne    800cf8 <strnlen+0xf>
		n++;
	return n;
  800d10:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d13:	c9                   	leave  
  800d14:	c3                   	ret    

00800d15 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d15:	55                   	push   %ebp
  800d16:	89 e5                	mov    %esp,%ebp
  800d18:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d21:	90                   	nop
  800d22:	8b 45 08             	mov    0x8(%ebp),%eax
  800d25:	8d 50 01             	lea    0x1(%eax),%edx
  800d28:	89 55 08             	mov    %edx,0x8(%ebp)
  800d2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d2e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d31:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d34:	8a 12                	mov    (%edx),%dl
  800d36:	88 10                	mov    %dl,(%eax)
  800d38:	8a 00                	mov    (%eax),%al
  800d3a:	84 c0                	test   %al,%al
  800d3c:	75 e4                	jne    800d22 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d3e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d41:	c9                   	leave  
  800d42:	c3                   	ret    

00800d43 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d43:	55                   	push   %ebp
  800d44:	89 e5                	mov    %esp,%ebp
  800d46:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d49:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d4f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d56:	eb 1f                	jmp    800d77 <strncpy+0x34>
		*dst++ = *src;
  800d58:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5b:	8d 50 01             	lea    0x1(%eax),%edx
  800d5e:	89 55 08             	mov    %edx,0x8(%ebp)
  800d61:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d64:	8a 12                	mov    (%edx),%dl
  800d66:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6b:	8a 00                	mov    (%eax),%al
  800d6d:	84 c0                	test   %al,%al
  800d6f:	74 03                	je     800d74 <strncpy+0x31>
			src++;
  800d71:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d74:	ff 45 fc             	incl   -0x4(%ebp)
  800d77:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d7a:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d7d:	72 d9                	jb     800d58 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d7f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d82:	c9                   	leave  
  800d83:	c3                   	ret    

00800d84 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d84:	55                   	push   %ebp
  800d85:	89 e5                	mov    %esp,%ebp
  800d87:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d90:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d94:	74 30                	je     800dc6 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d96:	eb 16                	jmp    800dae <strlcpy+0x2a>
			*dst++ = *src++;
  800d98:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9b:	8d 50 01             	lea    0x1(%eax),%edx
  800d9e:	89 55 08             	mov    %edx,0x8(%ebp)
  800da1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800da4:	8d 4a 01             	lea    0x1(%edx),%ecx
  800da7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800daa:	8a 12                	mov    (%edx),%dl
  800dac:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800dae:	ff 4d 10             	decl   0x10(%ebp)
  800db1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800db5:	74 09                	je     800dc0 <strlcpy+0x3c>
  800db7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dba:	8a 00                	mov    (%eax),%al
  800dbc:	84 c0                	test   %al,%al
  800dbe:	75 d8                	jne    800d98 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc3:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800dc6:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dcc:	29 c2                	sub    %eax,%edx
  800dce:	89 d0                	mov    %edx,%eax
}
  800dd0:	c9                   	leave  
  800dd1:	c3                   	ret    

00800dd2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800dd2:	55                   	push   %ebp
  800dd3:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800dd5:	eb 06                	jmp    800ddd <strcmp+0xb>
		p++, q++;
  800dd7:	ff 45 08             	incl   0x8(%ebp)
  800dda:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  800de0:	8a 00                	mov    (%eax),%al
  800de2:	84 c0                	test   %al,%al
  800de4:	74 0e                	je     800df4 <strcmp+0x22>
  800de6:	8b 45 08             	mov    0x8(%ebp),%eax
  800de9:	8a 10                	mov    (%eax),%dl
  800deb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dee:	8a 00                	mov    (%eax),%al
  800df0:	38 c2                	cmp    %al,%dl
  800df2:	74 e3                	je     800dd7 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800df4:	8b 45 08             	mov    0x8(%ebp),%eax
  800df7:	8a 00                	mov    (%eax),%al
  800df9:	0f b6 d0             	movzbl %al,%edx
  800dfc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dff:	8a 00                	mov    (%eax),%al
  800e01:	0f b6 c0             	movzbl %al,%eax
  800e04:	29 c2                	sub    %eax,%edx
  800e06:	89 d0                	mov    %edx,%eax
}
  800e08:	5d                   	pop    %ebp
  800e09:	c3                   	ret    

00800e0a <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e0a:	55                   	push   %ebp
  800e0b:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e0d:	eb 09                	jmp    800e18 <strncmp+0xe>
		n--, p++, q++;
  800e0f:	ff 4d 10             	decl   0x10(%ebp)
  800e12:	ff 45 08             	incl   0x8(%ebp)
  800e15:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e18:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e1c:	74 17                	je     800e35 <strncmp+0x2b>
  800e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e21:	8a 00                	mov    (%eax),%al
  800e23:	84 c0                	test   %al,%al
  800e25:	74 0e                	je     800e35 <strncmp+0x2b>
  800e27:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2a:	8a 10                	mov    (%eax),%dl
  800e2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2f:	8a 00                	mov    (%eax),%al
  800e31:	38 c2                	cmp    %al,%dl
  800e33:	74 da                	je     800e0f <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e35:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e39:	75 07                	jne    800e42 <strncmp+0x38>
		return 0;
  800e3b:	b8 00 00 00 00       	mov    $0x0,%eax
  800e40:	eb 14                	jmp    800e56 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e42:	8b 45 08             	mov    0x8(%ebp),%eax
  800e45:	8a 00                	mov    (%eax),%al
  800e47:	0f b6 d0             	movzbl %al,%edx
  800e4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4d:	8a 00                	mov    (%eax),%al
  800e4f:	0f b6 c0             	movzbl %al,%eax
  800e52:	29 c2                	sub    %eax,%edx
  800e54:	89 d0                	mov    %edx,%eax
}
  800e56:	5d                   	pop    %ebp
  800e57:	c3                   	ret    

00800e58 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e58:	55                   	push   %ebp
  800e59:	89 e5                	mov    %esp,%ebp
  800e5b:	83 ec 04             	sub    $0x4,%esp
  800e5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e61:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e64:	eb 12                	jmp    800e78 <strchr+0x20>
		if (*s == c)
  800e66:	8b 45 08             	mov    0x8(%ebp),%eax
  800e69:	8a 00                	mov    (%eax),%al
  800e6b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e6e:	75 05                	jne    800e75 <strchr+0x1d>
			return (char *) s;
  800e70:	8b 45 08             	mov    0x8(%ebp),%eax
  800e73:	eb 11                	jmp    800e86 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e75:	ff 45 08             	incl   0x8(%ebp)
  800e78:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7b:	8a 00                	mov    (%eax),%al
  800e7d:	84 c0                	test   %al,%al
  800e7f:	75 e5                	jne    800e66 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e81:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e86:	c9                   	leave  
  800e87:	c3                   	ret    

00800e88 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e88:	55                   	push   %ebp
  800e89:	89 e5                	mov    %esp,%ebp
  800e8b:	83 ec 04             	sub    $0x4,%esp
  800e8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e91:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e94:	eb 0d                	jmp    800ea3 <strfind+0x1b>
		if (*s == c)
  800e96:	8b 45 08             	mov    0x8(%ebp),%eax
  800e99:	8a 00                	mov    (%eax),%al
  800e9b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e9e:	74 0e                	je     800eae <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ea0:	ff 45 08             	incl   0x8(%ebp)
  800ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea6:	8a 00                	mov    (%eax),%al
  800ea8:	84 c0                	test   %al,%al
  800eaa:	75 ea                	jne    800e96 <strfind+0xe>
  800eac:	eb 01                	jmp    800eaf <strfind+0x27>
		if (*s == c)
			break;
  800eae:	90                   	nop
	return (char *) s;
  800eaf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eb2:	c9                   	leave  
  800eb3:	c3                   	ret    

00800eb4 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800eb4:	55                   	push   %ebp
  800eb5:	89 e5                	mov    %esp,%ebp
  800eb7:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800eba:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800ec0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800ec6:	eb 0e                	jmp    800ed6 <memset+0x22>
		*p++ = c;
  800ec8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ecb:	8d 50 01             	lea    0x1(%eax),%edx
  800ece:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800ed1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ed4:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800ed6:	ff 4d f8             	decl   -0x8(%ebp)
  800ed9:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800edd:	79 e9                	jns    800ec8 <memset+0x14>
		*p++ = c;

	return v;
  800edf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ee2:	c9                   	leave  
  800ee3:	c3                   	ret    

00800ee4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800ee4:	55                   	push   %ebp
  800ee5:	89 e5                	mov    %esp,%ebp
  800ee7:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800eea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eed:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800ef6:	eb 16                	jmp    800f0e <memcpy+0x2a>
		*d++ = *s++;
  800ef8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800efb:	8d 50 01             	lea    0x1(%eax),%edx
  800efe:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f01:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f04:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f07:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f0a:	8a 12                	mov    (%edx),%dl
  800f0c:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800f0e:	8b 45 10             	mov    0x10(%ebp),%eax
  800f11:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f14:	89 55 10             	mov    %edx,0x10(%ebp)
  800f17:	85 c0                	test   %eax,%eax
  800f19:	75 dd                	jne    800ef8 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f1b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f1e:	c9                   	leave  
  800f1f:	c3                   	ret    

00800f20 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f20:	55                   	push   %ebp
  800f21:	89 e5                	mov    %esp,%ebp
  800f23:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f26:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f29:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f32:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f35:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f38:	73 50                	jae    800f8a <memmove+0x6a>
  800f3a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f3d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f40:	01 d0                	add    %edx,%eax
  800f42:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f45:	76 43                	jbe    800f8a <memmove+0x6a>
		s += n;
  800f47:	8b 45 10             	mov    0x10(%ebp),%eax
  800f4a:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f4d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f50:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f53:	eb 10                	jmp    800f65 <memmove+0x45>
			*--d = *--s;
  800f55:	ff 4d f8             	decl   -0x8(%ebp)
  800f58:	ff 4d fc             	decl   -0x4(%ebp)
  800f5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f5e:	8a 10                	mov    (%eax),%dl
  800f60:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f63:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f65:	8b 45 10             	mov    0x10(%ebp),%eax
  800f68:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f6b:	89 55 10             	mov    %edx,0x10(%ebp)
  800f6e:	85 c0                	test   %eax,%eax
  800f70:	75 e3                	jne    800f55 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f72:	eb 23                	jmp    800f97 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f74:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f77:	8d 50 01             	lea    0x1(%eax),%edx
  800f7a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f7d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f80:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f83:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f86:	8a 12                	mov    (%edx),%dl
  800f88:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f8a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f8d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f90:	89 55 10             	mov    %edx,0x10(%ebp)
  800f93:	85 c0                	test   %eax,%eax
  800f95:	75 dd                	jne    800f74 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f97:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f9a:	c9                   	leave  
  800f9b:	c3                   	ret    

00800f9c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f9c:	55                   	push   %ebp
  800f9d:	89 e5                	mov    %esp,%ebp
  800f9f:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800fa2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800fa8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fab:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800fae:	eb 2a                	jmp    800fda <memcmp+0x3e>
		if (*s1 != *s2)
  800fb0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fb3:	8a 10                	mov    (%eax),%dl
  800fb5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fb8:	8a 00                	mov    (%eax),%al
  800fba:	38 c2                	cmp    %al,%dl
  800fbc:	74 16                	je     800fd4 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800fbe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fc1:	8a 00                	mov    (%eax),%al
  800fc3:	0f b6 d0             	movzbl %al,%edx
  800fc6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fc9:	8a 00                	mov    (%eax),%al
  800fcb:	0f b6 c0             	movzbl %al,%eax
  800fce:	29 c2                	sub    %eax,%edx
  800fd0:	89 d0                	mov    %edx,%eax
  800fd2:	eb 18                	jmp    800fec <memcmp+0x50>
		s1++, s2++;
  800fd4:	ff 45 fc             	incl   -0x4(%ebp)
  800fd7:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800fda:	8b 45 10             	mov    0x10(%ebp),%eax
  800fdd:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fe0:	89 55 10             	mov    %edx,0x10(%ebp)
  800fe3:	85 c0                	test   %eax,%eax
  800fe5:	75 c9                	jne    800fb0 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800fe7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fec:	c9                   	leave  
  800fed:	c3                   	ret    

00800fee <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800fee:	55                   	push   %ebp
  800fef:	89 e5                	mov    %esp,%ebp
  800ff1:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ff4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff7:	8b 45 10             	mov    0x10(%ebp),%eax
  800ffa:	01 d0                	add    %edx,%eax
  800ffc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800fff:	eb 15                	jmp    801016 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801001:	8b 45 08             	mov    0x8(%ebp),%eax
  801004:	8a 00                	mov    (%eax),%al
  801006:	0f b6 d0             	movzbl %al,%edx
  801009:	8b 45 0c             	mov    0xc(%ebp),%eax
  80100c:	0f b6 c0             	movzbl %al,%eax
  80100f:	39 c2                	cmp    %eax,%edx
  801011:	74 0d                	je     801020 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801013:	ff 45 08             	incl   0x8(%ebp)
  801016:	8b 45 08             	mov    0x8(%ebp),%eax
  801019:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80101c:	72 e3                	jb     801001 <memfind+0x13>
  80101e:	eb 01                	jmp    801021 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801020:	90                   	nop
	return (void *) s;
  801021:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801024:	c9                   	leave  
  801025:	c3                   	ret    

00801026 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801026:	55                   	push   %ebp
  801027:	89 e5                	mov    %esp,%ebp
  801029:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80102c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801033:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80103a:	eb 03                	jmp    80103f <strtol+0x19>
		s++;
  80103c:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80103f:	8b 45 08             	mov    0x8(%ebp),%eax
  801042:	8a 00                	mov    (%eax),%al
  801044:	3c 20                	cmp    $0x20,%al
  801046:	74 f4                	je     80103c <strtol+0x16>
  801048:	8b 45 08             	mov    0x8(%ebp),%eax
  80104b:	8a 00                	mov    (%eax),%al
  80104d:	3c 09                	cmp    $0x9,%al
  80104f:	74 eb                	je     80103c <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801051:	8b 45 08             	mov    0x8(%ebp),%eax
  801054:	8a 00                	mov    (%eax),%al
  801056:	3c 2b                	cmp    $0x2b,%al
  801058:	75 05                	jne    80105f <strtol+0x39>
		s++;
  80105a:	ff 45 08             	incl   0x8(%ebp)
  80105d:	eb 13                	jmp    801072 <strtol+0x4c>
	else if (*s == '-')
  80105f:	8b 45 08             	mov    0x8(%ebp),%eax
  801062:	8a 00                	mov    (%eax),%al
  801064:	3c 2d                	cmp    $0x2d,%al
  801066:	75 0a                	jne    801072 <strtol+0x4c>
		s++, neg = 1;
  801068:	ff 45 08             	incl   0x8(%ebp)
  80106b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801072:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801076:	74 06                	je     80107e <strtol+0x58>
  801078:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80107c:	75 20                	jne    80109e <strtol+0x78>
  80107e:	8b 45 08             	mov    0x8(%ebp),%eax
  801081:	8a 00                	mov    (%eax),%al
  801083:	3c 30                	cmp    $0x30,%al
  801085:	75 17                	jne    80109e <strtol+0x78>
  801087:	8b 45 08             	mov    0x8(%ebp),%eax
  80108a:	40                   	inc    %eax
  80108b:	8a 00                	mov    (%eax),%al
  80108d:	3c 78                	cmp    $0x78,%al
  80108f:	75 0d                	jne    80109e <strtol+0x78>
		s += 2, base = 16;
  801091:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801095:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80109c:	eb 28                	jmp    8010c6 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80109e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010a2:	75 15                	jne    8010b9 <strtol+0x93>
  8010a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a7:	8a 00                	mov    (%eax),%al
  8010a9:	3c 30                	cmp    $0x30,%al
  8010ab:	75 0c                	jne    8010b9 <strtol+0x93>
		s++, base = 8;
  8010ad:	ff 45 08             	incl   0x8(%ebp)
  8010b0:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8010b7:	eb 0d                	jmp    8010c6 <strtol+0xa0>
	else if (base == 0)
  8010b9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010bd:	75 07                	jne    8010c6 <strtol+0xa0>
		base = 10;
  8010bf:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8010c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c9:	8a 00                	mov    (%eax),%al
  8010cb:	3c 2f                	cmp    $0x2f,%al
  8010cd:	7e 19                	jle    8010e8 <strtol+0xc2>
  8010cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d2:	8a 00                	mov    (%eax),%al
  8010d4:	3c 39                	cmp    $0x39,%al
  8010d6:	7f 10                	jg     8010e8 <strtol+0xc2>
			dig = *s - '0';
  8010d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010db:	8a 00                	mov    (%eax),%al
  8010dd:	0f be c0             	movsbl %al,%eax
  8010e0:	83 e8 30             	sub    $0x30,%eax
  8010e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010e6:	eb 42                	jmp    80112a <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8010e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010eb:	8a 00                	mov    (%eax),%al
  8010ed:	3c 60                	cmp    $0x60,%al
  8010ef:	7e 19                	jle    80110a <strtol+0xe4>
  8010f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f4:	8a 00                	mov    (%eax),%al
  8010f6:	3c 7a                	cmp    $0x7a,%al
  8010f8:	7f 10                	jg     80110a <strtol+0xe4>
			dig = *s - 'a' + 10;
  8010fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fd:	8a 00                	mov    (%eax),%al
  8010ff:	0f be c0             	movsbl %al,%eax
  801102:	83 e8 57             	sub    $0x57,%eax
  801105:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801108:	eb 20                	jmp    80112a <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80110a:	8b 45 08             	mov    0x8(%ebp),%eax
  80110d:	8a 00                	mov    (%eax),%al
  80110f:	3c 40                	cmp    $0x40,%al
  801111:	7e 39                	jle    80114c <strtol+0x126>
  801113:	8b 45 08             	mov    0x8(%ebp),%eax
  801116:	8a 00                	mov    (%eax),%al
  801118:	3c 5a                	cmp    $0x5a,%al
  80111a:	7f 30                	jg     80114c <strtol+0x126>
			dig = *s - 'A' + 10;
  80111c:	8b 45 08             	mov    0x8(%ebp),%eax
  80111f:	8a 00                	mov    (%eax),%al
  801121:	0f be c0             	movsbl %al,%eax
  801124:	83 e8 37             	sub    $0x37,%eax
  801127:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80112a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80112d:	3b 45 10             	cmp    0x10(%ebp),%eax
  801130:	7d 19                	jge    80114b <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801132:	ff 45 08             	incl   0x8(%ebp)
  801135:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801138:	0f af 45 10          	imul   0x10(%ebp),%eax
  80113c:	89 c2                	mov    %eax,%edx
  80113e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801141:	01 d0                	add    %edx,%eax
  801143:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801146:	e9 7b ff ff ff       	jmp    8010c6 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80114b:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80114c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801150:	74 08                	je     80115a <strtol+0x134>
		*endptr = (char *) s;
  801152:	8b 45 0c             	mov    0xc(%ebp),%eax
  801155:	8b 55 08             	mov    0x8(%ebp),%edx
  801158:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80115a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80115e:	74 07                	je     801167 <strtol+0x141>
  801160:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801163:	f7 d8                	neg    %eax
  801165:	eb 03                	jmp    80116a <strtol+0x144>
  801167:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80116a:	c9                   	leave  
  80116b:	c3                   	ret    

0080116c <ltostr>:

void
ltostr(long value, char *str)
{
  80116c:	55                   	push   %ebp
  80116d:	89 e5                	mov    %esp,%ebp
  80116f:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801172:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801179:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801180:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801184:	79 13                	jns    801199 <ltostr+0x2d>
	{
		neg = 1;
  801186:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80118d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801190:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801193:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801196:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801199:	8b 45 08             	mov    0x8(%ebp),%eax
  80119c:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8011a1:	99                   	cltd   
  8011a2:	f7 f9                	idiv   %ecx
  8011a4:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8011a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011aa:	8d 50 01             	lea    0x1(%eax),%edx
  8011ad:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011b0:	89 c2                	mov    %eax,%edx
  8011b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b5:	01 d0                	add    %edx,%eax
  8011b7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011ba:	83 c2 30             	add    $0x30,%edx
  8011bd:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8011bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011c2:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011c7:	f7 e9                	imul   %ecx
  8011c9:	c1 fa 02             	sar    $0x2,%edx
  8011cc:	89 c8                	mov    %ecx,%eax
  8011ce:	c1 f8 1f             	sar    $0x1f,%eax
  8011d1:	29 c2                	sub    %eax,%edx
  8011d3:	89 d0                	mov    %edx,%eax
  8011d5:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8011d8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011db:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011e0:	f7 e9                	imul   %ecx
  8011e2:	c1 fa 02             	sar    $0x2,%edx
  8011e5:	89 c8                	mov    %ecx,%eax
  8011e7:	c1 f8 1f             	sar    $0x1f,%eax
  8011ea:	29 c2                	sub    %eax,%edx
  8011ec:	89 d0                	mov    %edx,%eax
  8011ee:	c1 e0 02             	shl    $0x2,%eax
  8011f1:	01 d0                	add    %edx,%eax
  8011f3:	01 c0                	add    %eax,%eax
  8011f5:	29 c1                	sub    %eax,%ecx
  8011f7:	89 ca                	mov    %ecx,%edx
  8011f9:	85 d2                	test   %edx,%edx
  8011fb:	75 9c                	jne    801199 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8011fd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801204:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801207:	48                   	dec    %eax
  801208:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80120b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80120f:	74 3d                	je     80124e <ltostr+0xe2>
		start = 1 ;
  801211:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801218:	eb 34                	jmp    80124e <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80121a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80121d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801220:	01 d0                	add    %edx,%eax
  801222:	8a 00                	mov    (%eax),%al
  801224:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801227:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80122a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122d:	01 c2                	add    %eax,%edx
  80122f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801232:	8b 45 0c             	mov    0xc(%ebp),%eax
  801235:	01 c8                	add    %ecx,%eax
  801237:	8a 00                	mov    (%eax),%al
  801239:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80123b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80123e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801241:	01 c2                	add    %eax,%edx
  801243:	8a 45 eb             	mov    -0x15(%ebp),%al
  801246:	88 02                	mov    %al,(%edx)
		start++ ;
  801248:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80124b:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80124e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801251:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801254:	7c c4                	jl     80121a <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801256:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801259:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125c:	01 d0                	add    %edx,%eax
  80125e:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801261:	90                   	nop
  801262:	c9                   	leave  
  801263:	c3                   	ret    

00801264 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801264:	55                   	push   %ebp
  801265:	89 e5                	mov    %esp,%ebp
  801267:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80126a:	ff 75 08             	pushl  0x8(%ebp)
  80126d:	e8 54 fa ff ff       	call   800cc6 <strlen>
  801272:	83 c4 04             	add    $0x4,%esp
  801275:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801278:	ff 75 0c             	pushl  0xc(%ebp)
  80127b:	e8 46 fa ff ff       	call   800cc6 <strlen>
  801280:	83 c4 04             	add    $0x4,%esp
  801283:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801286:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80128d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801294:	eb 17                	jmp    8012ad <strcconcat+0x49>
		final[s] = str1[s] ;
  801296:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801299:	8b 45 10             	mov    0x10(%ebp),%eax
  80129c:	01 c2                	add    %eax,%edx
  80129e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a4:	01 c8                	add    %ecx,%eax
  8012a6:	8a 00                	mov    (%eax),%al
  8012a8:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8012aa:	ff 45 fc             	incl   -0x4(%ebp)
  8012ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012b0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8012b3:	7c e1                	jl     801296 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8012b5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8012bc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8012c3:	eb 1f                	jmp    8012e4 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8012c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012c8:	8d 50 01             	lea    0x1(%eax),%edx
  8012cb:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012ce:	89 c2                	mov    %eax,%edx
  8012d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d3:	01 c2                	add    %eax,%edx
  8012d5:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012db:	01 c8                	add    %ecx,%eax
  8012dd:	8a 00                	mov    (%eax),%al
  8012df:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8012e1:	ff 45 f8             	incl   -0x8(%ebp)
  8012e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012e7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012ea:	7c d9                	jl     8012c5 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8012ec:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f2:	01 d0                	add    %edx,%eax
  8012f4:	c6 00 00             	movb   $0x0,(%eax)
}
  8012f7:	90                   	nop
  8012f8:	c9                   	leave  
  8012f9:	c3                   	ret    

008012fa <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8012fa:	55                   	push   %ebp
  8012fb:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8012fd:	8b 45 14             	mov    0x14(%ebp),%eax
  801300:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801306:	8b 45 14             	mov    0x14(%ebp),%eax
  801309:	8b 00                	mov    (%eax),%eax
  80130b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801312:	8b 45 10             	mov    0x10(%ebp),%eax
  801315:	01 d0                	add    %edx,%eax
  801317:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80131d:	eb 0c                	jmp    80132b <strsplit+0x31>
			*string++ = 0;
  80131f:	8b 45 08             	mov    0x8(%ebp),%eax
  801322:	8d 50 01             	lea    0x1(%eax),%edx
  801325:	89 55 08             	mov    %edx,0x8(%ebp)
  801328:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80132b:	8b 45 08             	mov    0x8(%ebp),%eax
  80132e:	8a 00                	mov    (%eax),%al
  801330:	84 c0                	test   %al,%al
  801332:	74 18                	je     80134c <strsplit+0x52>
  801334:	8b 45 08             	mov    0x8(%ebp),%eax
  801337:	8a 00                	mov    (%eax),%al
  801339:	0f be c0             	movsbl %al,%eax
  80133c:	50                   	push   %eax
  80133d:	ff 75 0c             	pushl  0xc(%ebp)
  801340:	e8 13 fb ff ff       	call   800e58 <strchr>
  801345:	83 c4 08             	add    $0x8,%esp
  801348:	85 c0                	test   %eax,%eax
  80134a:	75 d3                	jne    80131f <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80134c:	8b 45 08             	mov    0x8(%ebp),%eax
  80134f:	8a 00                	mov    (%eax),%al
  801351:	84 c0                	test   %al,%al
  801353:	74 5a                	je     8013af <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801355:	8b 45 14             	mov    0x14(%ebp),%eax
  801358:	8b 00                	mov    (%eax),%eax
  80135a:	83 f8 0f             	cmp    $0xf,%eax
  80135d:	75 07                	jne    801366 <strsplit+0x6c>
		{
			return 0;
  80135f:	b8 00 00 00 00       	mov    $0x0,%eax
  801364:	eb 66                	jmp    8013cc <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801366:	8b 45 14             	mov    0x14(%ebp),%eax
  801369:	8b 00                	mov    (%eax),%eax
  80136b:	8d 48 01             	lea    0x1(%eax),%ecx
  80136e:	8b 55 14             	mov    0x14(%ebp),%edx
  801371:	89 0a                	mov    %ecx,(%edx)
  801373:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80137a:	8b 45 10             	mov    0x10(%ebp),%eax
  80137d:	01 c2                	add    %eax,%edx
  80137f:	8b 45 08             	mov    0x8(%ebp),%eax
  801382:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801384:	eb 03                	jmp    801389 <strsplit+0x8f>
			string++;
  801386:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801389:	8b 45 08             	mov    0x8(%ebp),%eax
  80138c:	8a 00                	mov    (%eax),%al
  80138e:	84 c0                	test   %al,%al
  801390:	74 8b                	je     80131d <strsplit+0x23>
  801392:	8b 45 08             	mov    0x8(%ebp),%eax
  801395:	8a 00                	mov    (%eax),%al
  801397:	0f be c0             	movsbl %al,%eax
  80139a:	50                   	push   %eax
  80139b:	ff 75 0c             	pushl  0xc(%ebp)
  80139e:	e8 b5 fa ff ff       	call   800e58 <strchr>
  8013a3:	83 c4 08             	add    $0x8,%esp
  8013a6:	85 c0                	test   %eax,%eax
  8013a8:	74 dc                	je     801386 <strsplit+0x8c>
			string++;
	}
  8013aa:	e9 6e ff ff ff       	jmp    80131d <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8013af:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8013b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8013b3:	8b 00                	mov    (%eax),%eax
  8013b5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8013bf:	01 d0                	add    %edx,%eax
  8013c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8013c7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013cc:	c9                   	leave  
  8013cd:	c3                   	ret    

008013ce <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8013ce:	55                   	push   %ebp
  8013cf:	89 e5                	mov    %esp,%ebp
  8013d1:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8013d4:	a1 04 50 80 00       	mov    0x805004,%eax
  8013d9:	85 c0                	test   %eax,%eax
  8013db:	74 1f                	je     8013fc <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8013dd:	e8 1d 00 00 00       	call   8013ff <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8013e2:	83 ec 0c             	sub    $0xc,%esp
  8013e5:	68 10 3d 80 00       	push   $0x803d10
  8013ea:	e8 55 f2 ff ff       	call   800644 <cprintf>
  8013ef:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8013f2:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  8013f9:	00 00 00 
	}
}
  8013fc:	90                   	nop
  8013fd:	c9                   	leave  
  8013fe:	c3                   	ret    

008013ff <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8013ff:	55                   	push   %ebp
  801400:	89 e5                	mov    %esp,%ebp
  801402:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	LIST_INIT(&AllocMemBlocksList);
  801405:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  80140c:	00 00 00 
  80140f:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801416:	00 00 00 
  801419:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801420:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801423:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  80142a:	00 00 00 
  80142d:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801434:	00 00 00 
  801437:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  80143e:	00 00 00 
	uint32 arr_size = 0;
  801441:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	MemBlockNodes  =(struct MemBlock*) USER_DYN_BLKS_ARRAY;
  801448:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  80144f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801452:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801457:	2d 00 10 00 00       	sub    $0x1000,%eax
  80145c:	a3 50 50 80 00       	mov    %eax,0x805050
	MAX_MEM_BLOCK_CNT = (USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE;
  801461:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801468:	00 02 00 
	arr_size =  ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock), PAGE_SIZE);
  80146b:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801472:	a1 20 51 80 00       	mov    0x805120,%eax
  801477:	c1 e0 04             	shl    $0x4,%eax
  80147a:	89 c2                	mov    %eax,%edx
  80147c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80147f:	01 d0                	add    %edx,%eax
  801481:	48                   	dec    %eax
  801482:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801485:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801488:	ba 00 00 00 00       	mov    $0x0,%edx
  80148d:	f7 75 ec             	divl   -0x14(%ebp)
  801490:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801493:	29 d0                	sub    %edx,%eax
  801495:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_PRESENT);
  801498:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  80149f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014a2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014a7:	2d 00 10 00 00       	sub    $0x1000,%eax
  8014ac:	83 ec 04             	sub    $0x4,%esp
  8014af:	6a 03                	push   $0x3
  8014b1:	ff 75 f4             	pushl  -0xc(%ebp)
  8014b4:	50                   	push   %eax
  8014b5:	e8 b5 03 00 00       	call   80186f <sys_allocate_chunk>
  8014ba:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8014bd:	a1 20 51 80 00       	mov    0x805120,%eax
  8014c2:	83 ec 0c             	sub    $0xc,%esp
  8014c5:	50                   	push   %eax
  8014c6:	e8 2a 0a 00 00       	call   801ef5 <initialize_MemBlocksList>
  8014cb:	83 c4 10             	add    $0x10,%esp
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	struct MemBlock * NewBlock = LIST_FIRST(&AvailableMemBlocksList);
  8014ce:	a1 48 51 80 00       	mov    0x805148,%eax
  8014d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
	NewBlock->sva = USER_HEAP_START;
  8014d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014d9:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	NewBlock->size = (USER_HEAP_MAX-USER_HEAP_START);
  8014e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014e3:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	LIST_REMOVE(&AvailableMemBlocksList,NewBlock);
  8014ea:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8014ee:	75 14                	jne    801504 <initialize_dyn_block_system+0x105>
  8014f0:	83 ec 04             	sub    $0x4,%esp
  8014f3:	68 35 3d 80 00       	push   $0x803d35
  8014f8:	6a 33                	push   $0x33
  8014fa:	68 53 3d 80 00       	push   $0x803d53
  8014ff:	e8 8c ee ff ff       	call   800390 <_panic>
  801504:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801507:	8b 00                	mov    (%eax),%eax
  801509:	85 c0                	test   %eax,%eax
  80150b:	74 10                	je     80151d <initialize_dyn_block_system+0x11e>
  80150d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801510:	8b 00                	mov    (%eax),%eax
  801512:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801515:	8b 52 04             	mov    0x4(%edx),%edx
  801518:	89 50 04             	mov    %edx,0x4(%eax)
  80151b:	eb 0b                	jmp    801528 <initialize_dyn_block_system+0x129>
  80151d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801520:	8b 40 04             	mov    0x4(%eax),%eax
  801523:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801528:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80152b:	8b 40 04             	mov    0x4(%eax),%eax
  80152e:	85 c0                	test   %eax,%eax
  801530:	74 0f                	je     801541 <initialize_dyn_block_system+0x142>
  801532:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801535:	8b 40 04             	mov    0x4(%eax),%eax
  801538:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80153b:	8b 12                	mov    (%edx),%edx
  80153d:	89 10                	mov    %edx,(%eax)
  80153f:	eb 0a                	jmp    80154b <initialize_dyn_block_system+0x14c>
  801541:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801544:	8b 00                	mov    (%eax),%eax
  801546:	a3 48 51 80 00       	mov    %eax,0x805148
  80154b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80154e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801554:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801557:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80155e:	a1 54 51 80 00       	mov    0x805154,%eax
  801563:	48                   	dec    %eax
  801564:	a3 54 51 80 00       	mov    %eax,0x805154
	LIST_INSERT_HEAD(&FreeMemBlocksList, NewBlock);
  801569:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80156d:	75 14                	jne    801583 <initialize_dyn_block_system+0x184>
  80156f:	83 ec 04             	sub    $0x4,%esp
  801572:	68 60 3d 80 00       	push   $0x803d60
  801577:	6a 34                	push   $0x34
  801579:	68 53 3d 80 00       	push   $0x803d53
  80157e:	e8 0d ee ff ff       	call   800390 <_panic>
  801583:	8b 15 38 51 80 00    	mov    0x805138,%edx
  801589:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80158c:	89 10                	mov    %edx,(%eax)
  80158e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801591:	8b 00                	mov    (%eax),%eax
  801593:	85 c0                	test   %eax,%eax
  801595:	74 0d                	je     8015a4 <initialize_dyn_block_system+0x1a5>
  801597:	a1 38 51 80 00       	mov    0x805138,%eax
  80159c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80159f:	89 50 04             	mov    %edx,0x4(%eax)
  8015a2:	eb 08                	jmp    8015ac <initialize_dyn_block_system+0x1ad>
  8015a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015a7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8015ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015af:	a3 38 51 80 00       	mov    %eax,0x805138
  8015b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015b7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8015be:	a1 44 51 80 00       	mov    0x805144,%eax
  8015c3:	40                   	inc    %eax
  8015c4:	a3 44 51 80 00       	mov    %eax,0x805144
}
  8015c9:	90                   	nop
  8015ca:	c9                   	leave  
  8015cb:	c3                   	ret    

008015cc <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8015cc:	55                   	push   %ebp
  8015cd:	89 e5                	mov    %esp,%ebp
  8015cf:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015d2:	e8 f7 fd ff ff       	call   8013ce <InitializeUHeap>
	if (size == 0) return NULL ;
  8015d7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015db:	75 07                	jne    8015e4 <malloc+0x18>
  8015dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8015e2:	eb 14                	jmp    8015f8 <malloc+0x2c>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  8015e4:	83 ec 04             	sub    $0x4,%esp
  8015e7:	68 84 3d 80 00       	push   $0x803d84
  8015ec:	6a 46                	push   $0x46
  8015ee:	68 53 3d 80 00       	push   $0x803d53
  8015f3:	e8 98 ed ff ff       	call   800390 <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  8015f8:	c9                   	leave  
  8015f9:	c3                   	ret    

008015fa <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8015fa:	55                   	push   %ebp
  8015fb:	89 e5                	mov    %esp,%ebp
  8015fd:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801600:	83 ec 04             	sub    $0x4,%esp
  801603:	68 ac 3d 80 00       	push   $0x803dac
  801608:	6a 61                	push   $0x61
  80160a:	68 53 3d 80 00       	push   $0x803d53
  80160f:	e8 7c ed ff ff       	call   800390 <_panic>

00801614 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801614:	55                   	push   %ebp
  801615:	89 e5                	mov    %esp,%ebp
  801617:	83 ec 18             	sub    $0x18,%esp
  80161a:	8b 45 10             	mov    0x10(%ebp),%eax
  80161d:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801620:	e8 a9 fd ff ff       	call   8013ce <InitializeUHeap>
	if (size == 0) return NULL ;
  801625:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801629:	75 07                	jne    801632 <smalloc+0x1e>
  80162b:	b8 00 00 00 00       	mov    $0x0,%eax
  801630:	eb 14                	jmp    801646 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801632:	83 ec 04             	sub    $0x4,%esp
  801635:	68 d0 3d 80 00       	push   $0x803dd0
  80163a:	6a 76                	push   $0x76
  80163c:	68 53 3d 80 00       	push   $0x803d53
  801641:	e8 4a ed ff ff       	call   800390 <_panic>

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801646:	c9                   	leave  
  801647:	c3                   	ret    

00801648 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801648:	55                   	push   %ebp
  801649:	89 e5                	mov    %esp,%ebp
  80164b:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80164e:	e8 7b fd ff ff       	call   8013ce <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801653:	83 ec 04             	sub    $0x4,%esp
  801656:	68 f8 3d 80 00       	push   $0x803df8
  80165b:	68 93 00 00 00       	push   $0x93
  801660:	68 53 3d 80 00       	push   $0x803d53
  801665:	e8 26 ed ff ff       	call   800390 <_panic>

0080166a <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80166a:	55                   	push   %ebp
  80166b:	89 e5                	mov    %esp,%ebp
  80166d:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801670:	e8 59 fd ff ff       	call   8013ce <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801675:	83 ec 04             	sub    $0x4,%esp
  801678:	68 1c 3e 80 00       	push   $0x803e1c
  80167d:	68 c5 00 00 00       	push   $0xc5
  801682:	68 53 3d 80 00       	push   $0x803d53
  801687:	e8 04 ed ff ff       	call   800390 <_panic>

0080168c <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80168c:	55                   	push   %ebp
  80168d:	89 e5                	mov    %esp,%ebp
  80168f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801692:	83 ec 04             	sub    $0x4,%esp
  801695:	68 44 3e 80 00       	push   $0x803e44
  80169a:	68 d9 00 00 00       	push   $0xd9
  80169f:	68 53 3d 80 00       	push   $0x803d53
  8016a4:	e8 e7 ec ff ff       	call   800390 <_panic>

008016a9 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8016a9:	55                   	push   %ebp
  8016aa:	89 e5                	mov    %esp,%ebp
  8016ac:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016af:	83 ec 04             	sub    $0x4,%esp
  8016b2:	68 68 3e 80 00       	push   $0x803e68
  8016b7:	68 e4 00 00 00       	push   $0xe4
  8016bc:	68 53 3d 80 00       	push   $0x803d53
  8016c1:	e8 ca ec ff ff       	call   800390 <_panic>

008016c6 <shrink>:

}
void shrink(uint32 newSize)
{
  8016c6:	55                   	push   %ebp
  8016c7:	89 e5                	mov    %esp,%ebp
  8016c9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016cc:	83 ec 04             	sub    $0x4,%esp
  8016cf:	68 68 3e 80 00       	push   $0x803e68
  8016d4:	68 e9 00 00 00       	push   $0xe9
  8016d9:	68 53 3d 80 00       	push   $0x803d53
  8016de:	e8 ad ec ff ff       	call   800390 <_panic>

008016e3 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8016e3:	55                   	push   %ebp
  8016e4:	89 e5                	mov    %esp,%ebp
  8016e6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016e9:	83 ec 04             	sub    $0x4,%esp
  8016ec:	68 68 3e 80 00       	push   $0x803e68
  8016f1:	68 ee 00 00 00       	push   $0xee
  8016f6:	68 53 3d 80 00       	push   $0x803d53
  8016fb:	e8 90 ec ff ff       	call   800390 <_panic>

00801700 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801700:	55                   	push   %ebp
  801701:	89 e5                	mov    %esp,%ebp
  801703:	57                   	push   %edi
  801704:	56                   	push   %esi
  801705:	53                   	push   %ebx
  801706:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801709:	8b 45 08             	mov    0x8(%ebp),%eax
  80170c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80170f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801712:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801715:	8b 7d 18             	mov    0x18(%ebp),%edi
  801718:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80171b:	cd 30                	int    $0x30
  80171d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801720:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801723:	83 c4 10             	add    $0x10,%esp
  801726:	5b                   	pop    %ebx
  801727:	5e                   	pop    %esi
  801728:	5f                   	pop    %edi
  801729:	5d                   	pop    %ebp
  80172a:	c3                   	ret    

0080172b <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80172b:	55                   	push   %ebp
  80172c:	89 e5                	mov    %esp,%ebp
  80172e:	83 ec 04             	sub    $0x4,%esp
  801731:	8b 45 10             	mov    0x10(%ebp),%eax
  801734:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801737:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80173b:	8b 45 08             	mov    0x8(%ebp),%eax
  80173e:	6a 00                	push   $0x0
  801740:	6a 00                	push   $0x0
  801742:	52                   	push   %edx
  801743:	ff 75 0c             	pushl  0xc(%ebp)
  801746:	50                   	push   %eax
  801747:	6a 00                	push   $0x0
  801749:	e8 b2 ff ff ff       	call   801700 <syscall>
  80174e:	83 c4 18             	add    $0x18,%esp
}
  801751:	90                   	nop
  801752:	c9                   	leave  
  801753:	c3                   	ret    

00801754 <sys_cgetc>:

int
sys_cgetc(void)
{
  801754:	55                   	push   %ebp
  801755:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801757:	6a 00                	push   $0x0
  801759:	6a 00                	push   $0x0
  80175b:	6a 00                	push   $0x0
  80175d:	6a 00                	push   $0x0
  80175f:	6a 00                	push   $0x0
  801761:	6a 01                	push   $0x1
  801763:	e8 98 ff ff ff       	call   801700 <syscall>
  801768:	83 c4 18             	add    $0x18,%esp
}
  80176b:	c9                   	leave  
  80176c:	c3                   	ret    

0080176d <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80176d:	55                   	push   %ebp
  80176e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801770:	8b 55 0c             	mov    0xc(%ebp),%edx
  801773:	8b 45 08             	mov    0x8(%ebp),%eax
  801776:	6a 00                	push   $0x0
  801778:	6a 00                	push   $0x0
  80177a:	6a 00                	push   $0x0
  80177c:	52                   	push   %edx
  80177d:	50                   	push   %eax
  80177e:	6a 05                	push   $0x5
  801780:	e8 7b ff ff ff       	call   801700 <syscall>
  801785:	83 c4 18             	add    $0x18,%esp
}
  801788:	c9                   	leave  
  801789:	c3                   	ret    

0080178a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80178a:	55                   	push   %ebp
  80178b:	89 e5                	mov    %esp,%ebp
  80178d:	56                   	push   %esi
  80178e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80178f:	8b 75 18             	mov    0x18(%ebp),%esi
  801792:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801795:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801798:	8b 55 0c             	mov    0xc(%ebp),%edx
  80179b:	8b 45 08             	mov    0x8(%ebp),%eax
  80179e:	56                   	push   %esi
  80179f:	53                   	push   %ebx
  8017a0:	51                   	push   %ecx
  8017a1:	52                   	push   %edx
  8017a2:	50                   	push   %eax
  8017a3:	6a 06                	push   $0x6
  8017a5:	e8 56 ff ff ff       	call   801700 <syscall>
  8017aa:	83 c4 18             	add    $0x18,%esp
}
  8017ad:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017b0:	5b                   	pop    %ebx
  8017b1:	5e                   	pop    %esi
  8017b2:	5d                   	pop    %ebp
  8017b3:	c3                   	ret    

008017b4 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8017b4:	55                   	push   %ebp
  8017b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8017b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bd:	6a 00                	push   $0x0
  8017bf:	6a 00                	push   $0x0
  8017c1:	6a 00                	push   $0x0
  8017c3:	52                   	push   %edx
  8017c4:	50                   	push   %eax
  8017c5:	6a 07                	push   $0x7
  8017c7:	e8 34 ff ff ff       	call   801700 <syscall>
  8017cc:	83 c4 18             	add    $0x18,%esp
}
  8017cf:	c9                   	leave  
  8017d0:	c3                   	ret    

008017d1 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8017d1:	55                   	push   %ebp
  8017d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8017d4:	6a 00                	push   $0x0
  8017d6:	6a 00                	push   $0x0
  8017d8:	6a 00                	push   $0x0
  8017da:	ff 75 0c             	pushl  0xc(%ebp)
  8017dd:	ff 75 08             	pushl  0x8(%ebp)
  8017e0:	6a 08                	push   $0x8
  8017e2:	e8 19 ff ff ff       	call   801700 <syscall>
  8017e7:	83 c4 18             	add    $0x18,%esp
}
  8017ea:	c9                   	leave  
  8017eb:	c3                   	ret    

008017ec <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8017ec:	55                   	push   %ebp
  8017ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8017ef:	6a 00                	push   $0x0
  8017f1:	6a 00                	push   $0x0
  8017f3:	6a 00                	push   $0x0
  8017f5:	6a 00                	push   $0x0
  8017f7:	6a 00                	push   $0x0
  8017f9:	6a 09                	push   $0x9
  8017fb:	e8 00 ff ff ff       	call   801700 <syscall>
  801800:	83 c4 18             	add    $0x18,%esp
}
  801803:	c9                   	leave  
  801804:	c3                   	ret    

00801805 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801805:	55                   	push   %ebp
  801806:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801808:	6a 00                	push   $0x0
  80180a:	6a 00                	push   $0x0
  80180c:	6a 00                	push   $0x0
  80180e:	6a 00                	push   $0x0
  801810:	6a 00                	push   $0x0
  801812:	6a 0a                	push   $0xa
  801814:	e8 e7 fe ff ff       	call   801700 <syscall>
  801819:	83 c4 18             	add    $0x18,%esp
}
  80181c:	c9                   	leave  
  80181d:	c3                   	ret    

0080181e <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80181e:	55                   	push   %ebp
  80181f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801821:	6a 00                	push   $0x0
  801823:	6a 00                	push   $0x0
  801825:	6a 00                	push   $0x0
  801827:	6a 00                	push   $0x0
  801829:	6a 00                	push   $0x0
  80182b:	6a 0b                	push   $0xb
  80182d:	e8 ce fe ff ff       	call   801700 <syscall>
  801832:	83 c4 18             	add    $0x18,%esp
}
  801835:	c9                   	leave  
  801836:	c3                   	ret    

00801837 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801837:	55                   	push   %ebp
  801838:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80183a:	6a 00                	push   $0x0
  80183c:	6a 00                	push   $0x0
  80183e:	6a 00                	push   $0x0
  801840:	ff 75 0c             	pushl  0xc(%ebp)
  801843:	ff 75 08             	pushl  0x8(%ebp)
  801846:	6a 0f                	push   $0xf
  801848:	e8 b3 fe ff ff       	call   801700 <syscall>
  80184d:	83 c4 18             	add    $0x18,%esp
	return;
  801850:	90                   	nop
}
  801851:	c9                   	leave  
  801852:	c3                   	ret    

00801853 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801853:	55                   	push   %ebp
  801854:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801856:	6a 00                	push   $0x0
  801858:	6a 00                	push   $0x0
  80185a:	6a 00                	push   $0x0
  80185c:	ff 75 0c             	pushl  0xc(%ebp)
  80185f:	ff 75 08             	pushl  0x8(%ebp)
  801862:	6a 10                	push   $0x10
  801864:	e8 97 fe ff ff       	call   801700 <syscall>
  801869:	83 c4 18             	add    $0x18,%esp
	return ;
  80186c:	90                   	nop
}
  80186d:	c9                   	leave  
  80186e:	c3                   	ret    

0080186f <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80186f:	55                   	push   %ebp
  801870:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801872:	6a 00                	push   $0x0
  801874:	6a 00                	push   $0x0
  801876:	ff 75 10             	pushl  0x10(%ebp)
  801879:	ff 75 0c             	pushl  0xc(%ebp)
  80187c:	ff 75 08             	pushl  0x8(%ebp)
  80187f:	6a 11                	push   $0x11
  801881:	e8 7a fe ff ff       	call   801700 <syscall>
  801886:	83 c4 18             	add    $0x18,%esp
	return ;
  801889:	90                   	nop
}
  80188a:	c9                   	leave  
  80188b:	c3                   	ret    

0080188c <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80188c:	55                   	push   %ebp
  80188d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80188f:	6a 00                	push   $0x0
  801891:	6a 00                	push   $0x0
  801893:	6a 00                	push   $0x0
  801895:	6a 00                	push   $0x0
  801897:	6a 00                	push   $0x0
  801899:	6a 0c                	push   $0xc
  80189b:	e8 60 fe ff ff       	call   801700 <syscall>
  8018a0:	83 c4 18             	add    $0x18,%esp
}
  8018a3:	c9                   	leave  
  8018a4:	c3                   	ret    

008018a5 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8018a5:	55                   	push   %ebp
  8018a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8018a8:	6a 00                	push   $0x0
  8018aa:	6a 00                	push   $0x0
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 00                	push   $0x0
  8018b0:	ff 75 08             	pushl  0x8(%ebp)
  8018b3:	6a 0d                	push   $0xd
  8018b5:	e8 46 fe ff ff       	call   801700 <syscall>
  8018ba:	83 c4 18             	add    $0x18,%esp
}
  8018bd:	c9                   	leave  
  8018be:	c3                   	ret    

008018bf <sys_scarce_memory>:

void sys_scarce_memory()
{
  8018bf:	55                   	push   %ebp
  8018c0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8018c2:	6a 00                	push   $0x0
  8018c4:	6a 00                	push   $0x0
  8018c6:	6a 00                	push   $0x0
  8018c8:	6a 00                	push   $0x0
  8018ca:	6a 00                	push   $0x0
  8018cc:	6a 0e                	push   $0xe
  8018ce:	e8 2d fe ff ff       	call   801700 <syscall>
  8018d3:	83 c4 18             	add    $0x18,%esp
}
  8018d6:	90                   	nop
  8018d7:	c9                   	leave  
  8018d8:	c3                   	ret    

008018d9 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8018d9:	55                   	push   %ebp
  8018da:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8018dc:	6a 00                	push   $0x0
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 00                	push   $0x0
  8018e6:	6a 13                	push   $0x13
  8018e8:	e8 13 fe ff ff       	call   801700 <syscall>
  8018ed:	83 c4 18             	add    $0x18,%esp
}
  8018f0:	90                   	nop
  8018f1:	c9                   	leave  
  8018f2:	c3                   	ret    

008018f3 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8018f3:	55                   	push   %ebp
  8018f4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8018f6:	6a 00                	push   $0x0
  8018f8:	6a 00                	push   $0x0
  8018fa:	6a 00                	push   $0x0
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 00                	push   $0x0
  801900:	6a 14                	push   $0x14
  801902:	e8 f9 fd ff ff       	call   801700 <syscall>
  801907:	83 c4 18             	add    $0x18,%esp
}
  80190a:	90                   	nop
  80190b:	c9                   	leave  
  80190c:	c3                   	ret    

0080190d <sys_cputc>:


void
sys_cputc(const char c)
{
  80190d:	55                   	push   %ebp
  80190e:	89 e5                	mov    %esp,%ebp
  801910:	83 ec 04             	sub    $0x4,%esp
  801913:	8b 45 08             	mov    0x8(%ebp),%eax
  801916:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801919:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80191d:	6a 00                	push   $0x0
  80191f:	6a 00                	push   $0x0
  801921:	6a 00                	push   $0x0
  801923:	6a 00                	push   $0x0
  801925:	50                   	push   %eax
  801926:	6a 15                	push   $0x15
  801928:	e8 d3 fd ff ff       	call   801700 <syscall>
  80192d:	83 c4 18             	add    $0x18,%esp
}
  801930:	90                   	nop
  801931:	c9                   	leave  
  801932:	c3                   	ret    

00801933 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801933:	55                   	push   %ebp
  801934:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801936:	6a 00                	push   $0x0
  801938:	6a 00                	push   $0x0
  80193a:	6a 00                	push   $0x0
  80193c:	6a 00                	push   $0x0
  80193e:	6a 00                	push   $0x0
  801940:	6a 16                	push   $0x16
  801942:	e8 b9 fd ff ff       	call   801700 <syscall>
  801947:	83 c4 18             	add    $0x18,%esp
}
  80194a:	90                   	nop
  80194b:	c9                   	leave  
  80194c:	c3                   	ret    

0080194d <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80194d:	55                   	push   %ebp
  80194e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801950:	8b 45 08             	mov    0x8(%ebp),%eax
  801953:	6a 00                	push   $0x0
  801955:	6a 00                	push   $0x0
  801957:	6a 00                	push   $0x0
  801959:	ff 75 0c             	pushl  0xc(%ebp)
  80195c:	50                   	push   %eax
  80195d:	6a 17                	push   $0x17
  80195f:	e8 9c fd ff ff       	call   801700 <syscall>
  801964:	83 c4 18             	add    $0x18,%esp
}
  801967:	c9                   	leave  
  801968:	c3                   	ret    

00801969 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801969:	55                   	push   %ebp
  80196a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80196c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80196f:	8b 45 08             	mov    0x8(%ebp),%eax
  801972:	6a 00                	push   $0x0
  801974:	6a 00                	push   $0x0
  801976:	6a 00                	push   $0x0
  801978:	52                   	push   %edx
  801979:	50                   	push   %eax
  80197a:	6a 1a                	push   $0x1a
  80197c:	e8 7f fd ff ff       	call   801700 <syscall>
  801981:	83 c4 18             	add    $0x18,%esp
}
  801984:	c9                   	leave  
  801985:	c3                   	ret    

00801986 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801986:	55                   	push   %ebp
  801987:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801989:	8b 55 0c             	mov    0xc(%ebp),%edx
  80198c:	8b 45 08             	mov    0x8(%ebp),%eax
  80198f:	6a 00                	push   $0x0
  801991:	6a 00                	push   $0x0
  801993:	6a 00                	push   $0x0
  801995:	52                   	push   %edx
  801996:	50                   	push   %eax
  801997:	6a 18                	push   $0x18
  801999:	e8 62 fd ff ff       	call   801700 <syscall>
  80199e:	83 c4 18             	add    $0x18,%esp
}
  8019a1:	90                   	nop
  8019a2:	c9                   	leave  
  8019a3:	c3                   	ret    

008019a4 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8019a4:	55                   	push   %ebp
  8019a5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ad:	6a 00                	push   $0x0
  8019af:	6a 00                	push   $0x0
  8019b1:	6a 00                	push   $0x0
  8019b3:	52                   	push   %edx
  8019b4:	50                   	push   %eax
  8019b5:	6a 19                	push   $0x19
  8019b7:	e8 44 fd ff ff       	call   801700 <syscall>
  8019bc:	83 c4 18             	add    $0x18,%esp
}
  8019bf:	90                   	nop
  8019c0:	c9                   	leave  
  8019c1:	c3                   	ret    

008019c2 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8019c2:	55                   	push   %ebp
  8019c3:	89 e5                	mov    %esp,%ebp
  8019c5:	83 ec 04             	sub    $0x4,%esp
  8019c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8019cb:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8019ce:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8019d1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d8:	6a 00                	push   $0x0
  8019da:	51                   	push   %ecx
  8019db:	52                   	push   %edx
  8019dc:	ff 75 0c             	pushl  0xc(%ebp)
  8019df:	50                   	push   %eax
  8019e0:	6a 1b                	push   $0x1b
  8019e2:	e8 19 fd ff ff       	call   801700 <syscall>
  8019e7:	83 c4 18             	add    $0x18,%esp
}
  8019ea:	c9                   	leave  
  8019eb:	c3                   	ret    

008019ec <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8019ec:	55                   	push   %ebp
  8019ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8019ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 00                	push   $0x0
  8019f9:	6a 00                	push   $0x0
  8019fb:	52                   	push   %edx
  8019fc:	50                   	push   %eax
  8019fd:	6a 1c                	push   $0x1c
  8019ff:	e8 fc fc ff ff       	call   801700 <syscall>
  801a04:	83 c4 18             	add    $0x18,%esp
}
  801a07:	c9                   	leave  
  801a08:	c3                   	ret    

00801a09 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801a09:	55                   	push   %ebp
  801a0a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a0c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a0f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a12:	8b 45 08             	mov    0x8(%ebp),%eax
  801a15:	6a 00                	push   $0x0
  801a17:	6a 00                	push   $0x0
  801a19:	51                   	push   %ecx
  801a1a:	52                   	push   %edx
  801a1b:	50                   	push   %eax
  801a1c:	6a 1d                	push   $0x1d
  801a1e:	e8 dd fc ff ff       	call   801700 <syscall>
  801a23:	83 c4 18             	add    $0x18,%esp
}
  801a26:	c9                   	leave  
  801a27:	c3                   	ret    

00801a28 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801a28:	55                   	push   %ebp
  801a29:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	6a 00                	push   $0x0
  801a37:	52                   	push   %edx
  801a38:	50                   	push   %eax
  801a39:	6a 1e                	push   $0x1e
  801a3b:	e8 c0 fc ff ff       	call   801700 <syscall>
  801a40:	83 c4 18             	add    $0x18,%esp
}
  801a43:	c9                   	leave  
  801a44:	c3                   	ret    

00801a45 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801a45:	55                   	push   %ebp
  801a46:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801a48:	6a 00                	push   $0x0
  801a4a:	6a 00                	push   $0x0
  801a4c:	6a 00                	push   $0x0
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 00                	push   $0x0
  801a52:	6a 1f                	push   $0x1f
  801a54:	e8 a7 fc ff ff       	call   801700 <syscall>
  801a59:	83 c4 18             	add    $0x18,%esp
}
  801a5c:	c9                   	leave  
  801a5d:	c3                   	ret    

00801a5e <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a5e:	55                   	push   %ebp
  801a5f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a61:	8b 45 08             	mov    0x8(%ebp),%eax
  801a64:	6a 00                	push   $0x0
  801a66:	ff 75 14             	pushl  0x14(%ebp)
  801a69:	ff 75 10             	pushl  0x10(%ebp)
  801a6c:	ff 75 0c             	pushl  0xc(%ebp)
  801a6f:	50                   	push   %eax
  801a70:	6a 20                	push   $0x20
  801a72:	e8 89 fc ff ff       	call   801700 <syscall>
  801a77:	83 c4 18             	add    $0x18,%esp
}
  801a7a:	c9                   	leave  
  801a7b:	c3                   	ret    

00801a7c <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801a7c:	55                   	push   %ebp
  801a7d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a82:	6a 00                	push   $0x0
  801a84:	6a 00                	push   $0x0
  801a86:	6a 00                	push   $0x0
  801a88:	6a 00                	push   $0x0
  801a8a:	50                   	push   %eax
  801a8b:	6a 21                	push   $0x21
  801a8d:	e8 6e fc ff ff       	call   801700 <syscall>
  801a92:	83 c4 18             	add    $0x18,%esp
}
  801a95:	90                   	nop
  801a96:	c9                   	leave  
  801a97:	c3                   	ret    

00801a98 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801a98:	55                   	push   %ebp
  801a99:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 00                	push   $0x0
  801aa2:	6a 00                	push   $0x0
  801aa4:	6a 00                	push   $0x0
  801aa6:	50                   	push   %eax
  801aa7:	6a 22                	push   $0x22
  801aa9:	e8 52 fc ff ff       	call   801700 <syscall>
  801aae:	83 c4 18             	add    $0x18,%esp
}
  801ab1:	c9                   	leave  
  801ab2:	c3                   	ret    

00801ab3 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ab3:	55                   	push   %ebp
  801ab4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	6a 00                	push   $0x0
  801abe:	6a 00                	push   $0x0
  801ac0:	6a 02                	push   $0x2
  801ac2:	e8 39 fc ff ff       	call   801700 <syscall>
  801ac7:	83 c4 18             	add    $0x18,%esp
}
  801aca:	c9                   	leave  
  801acb:	c3                   	ret    

00801acc <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801acc:	55                   	push   %ebp
  801acd:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801acf:	6a 00                	push   $0x0
  801ad1:	6a 00                	push   $0x0
  801ad3:	6a 00                	push   $0x0
  801ad5:	6a 00                	push   $0x0
  801ad7:	6a 00                	push   $0x0
  801ad9:	6a 03                	push   $0x3
  801adb:	e8 20 fc ff ff       	call   801700 <syscall>
  801ae0:	83 c4 18             	add    $0x18,%esp
}
  801ae3:	c9                   	leave  
  801ae4:	c3                   	ret    

00801ae5 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801ae5:	55                   	push   %ebp
  801ae6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 00                	push   $0x0
  801aec:	6a 00                	push   $0x0
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	6a 04                	push   $0x4
  801af4:	e8 07 fc ff ff       	call   801700 <syscall>
  801af9:	83 c4 18             	add    $0x18,%esp
}
  801afc:	c9                   	leave  
  801afd:	c3                   	ret    

00801afe <sys_exit_env>:


void sys_exit_env(void)
{
  801afe:	55                   	push   %ebp
  801aff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b01:	6a 00                	push   $0x0
  801b03:	6a 00                	push   $0x0
  801b05:	6a 00                	push   $0x0
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 23                	push   $0x23
  801b0d:	e8 ee fb ff ff       	call   801700 <syscall>
  801b12:	83 c4 18             	add    $0x18,%esp
}
  801b15:	90                   	nop
  801b16:	c9                   	leave  
  801b17:	c3                   	ret    

00801b18 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801b18:	55                   	push   %ebp
  801b19:	89 e5                	mov    %esp,%ebp
  801b1b:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b1e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b21:	8d 50 04             	lea    0x4(%eax),%edx
  801b24:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	52                   	push   %edx
  801b2e:	50                   	push   %eax
  801b2f:	6a 24                	push   $0x24
  801b31:	e8 ca fb ff ff       	call   801700 <syscall>
  801b36:	83 c4 18             	add    $0x18,%esp
	return result;
  801b39:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b3c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b3f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b42:	89 01                	mov    %eax,(%ecx)
  801b44:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b47:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4a:	c9                   	leave  
  801b4b:	c2 04 00             	ret    $0x4

00801b4e <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b4e:	55                   	push   %ebp
  801b4f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b51:	6a 00                	push   $0x0
  801b53:	6a 00                	push   $0x0
  801b55:	ff 75 10             	pushl  0x10(%ebp)
  801b58:	ff 75 0c             	pushl  0xc(%ebp)
  801b5b:	ff 75 08             	pushl  0x8(%ebp)
  801b5e:	6a 12                	push   $0x12
  801b60:	e8 9b fb ff ff       	call   801700 <syscall>
  801b65:	83 c4 18             	add    $0x18,%esp
	return ;
  801b68:	90                   	nop
}
  801b69:	c9                   	leave  
  801b6a:	c3                   	ret    

00801b6b <sys_rcr2>:
uint32 sys_rcr2()
{
  801b6b:	55                   	push   %ebp
  801b6c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b6e:	6a 00                	push   $0x0
  801b70:	6a 00                	push   $0x0
  801b72:	6a 00                	push   $0x0
  801b74:	6a 00                	push   $0x0
  801b76:	6a 00                	push   $0x0
  801b78:	6a 25                	push   $0x25
  801b7a:	e8 81 fb ff ff       	call   801700 <syscall>
  801b7f:	83 c4 18             	add    $0x18,%esp
}
  801b82:	c9                   	leave  
  801b83:	c3                   	ret    

00801b84 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801b84:	55                   	push   %ebp
  801b85:	89 e5                	mov    %esp,%ebp
  801b87:	83 ec 04             	sub    $0x4,%esp
  801b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801b90:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801b94:	6a 00                	push   $0x0
  801b96:	6a 00                	push   $0x0
  801b98:	6a 00                	push   $0x0
  801b9a:	6a 00                	push   $0x0
  801b9c:	50                   	push   %eax
  801b9d:	6a 26                	push   $0x26
  801b9f:	e8 5c fb ff ff       	call   801700 <syscall>
  801ba4:	83 c4 18             	add    $0x18,%esp
	return ;
  801ba7:	90                   	nop
}
  801ba8:	c9                   	leave  
  801ba9:	c3                   	ret    

00801baa <rsttst>:
void rsttst()
{
  801baa:	55                   	push   %ebp
  801bab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801bad:	6a 00                	push   $0x0
  801baf:	6a 00                	push   $0x0
  801bb1:	6a 00                	push   $0x0
  801bb3:	6a 00                	push   $0x0
  801bb5:	6a 00                	push   $0x0
  801bb7:	6a 28                	push   $0x28
  801bb9:	e8 42 fb ff ff       	call   801700 <syscall>
  801bbe:	83 c4 18             	add    $0x18,%esp
	return ;
  801bc1:	90                   	nop
}
  801bc2:	c9                   	leave  
  801bc3:	c3                   	ret    

00801bc4 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801bc4:	55                   	push   %ebp
  801bc5:	89 e5                	mov    %esp,%ebp
  801bc7:	83 ec 04             	sub    $0x4,%esp
  801bca:	8b 45 14             	mov    0x14(%ebp),%eax
  801bcd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801bd0:	8b 55 18             	mov    0x18(%ebp),%edx
  801bd3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801bd7:	52                   	push   %edx
  801bd8:	50                   	push   %eax
  801bd9:	ff 75 10             	pushl  0x10(%ebp)
  801bdc:	ff 75 0c             	pushl  0xc(%ebp)
  801bdf:	ff 75 08             	pushl  0x8(%ebp)
  801be2:	6a 27                	push   $0x27
  801be4:	e8 17 fb ff ff       	call   801700 <syscall>
  801be9:	83 c4 18             	add    $0x18,%esp
	return ;
  801bec:	90                   	nop
}
  801bed:	c9                   	leave  
  801bee:	c3                   	ret    

00801bef <chktst>:
void chktst(uint32 n)
{
  801bef:	55                   	push   %ebp
  801bf0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801bf2:	6a 00                	push   $0x0
  801bf4:	6a 00                	push   $0x0
  801bf6:	6a 00                	push   $0x0
  801bf8:	6a 00                	push   $0x0
  801bfa:	ff 75 08             	pushl  0x8(%ebp)
  801bfd:	6a 29                	push   $0x29
  801bff:	e8 fc fa ff ff       	call   801700 <syscall>
  801c04:	83 c4 18             	add    $0x18,%esp
	return ;
  801c07:	90                   	nop
}
  801c08:	c9                   	leave  
  801c09:	c3                   	ret    

00801c0a <inctst>:

void inctst()
{
  801c0a:	55                   	push   %ebp
  801c0b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 00                	push   $0x0
  801c11:	6a 00                	push   $0x0
  801c13:	6a 00                	push   $0x0
  801c15:	6a 00                	push   $0x0
  801c17:	6a 2a                	push   $0x2a
  801c19:	e8 e2 fa ff ff       	call   801700 <syscall>
  801c1e:	83 c4 18             	add    $0x18,%esp
	return ;
  801c21:	90                   	nop
}
  801c22:	c9                   	leave  
  801c23:	c3                   	ret    

00801c24 <gettst>:
uint32 gettst()
{
  801c24:	55                   	push   %ebp
  801c25:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c27:	6a 00                	push   $0x0
  801c29:	6a 00                	push   $0x0
  801c2b:	6a 00                	push   $0x0
  801c2d:	6a 00                	push   $0x0
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 2b                	push   $0x2b
  801c33:	e8 c8 fa ff ff       	call   801700 <syscall>
  801c38:	83 c4 18             	add    $0x18,%esp
}
  801c3b:	c9                   	leave  
  801c3c:	c3                   	ret    

00801c3d <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801c3d:	55                   	push   %ebp
  801c3e:	89 e5                	mov    %esp,%ebp
  801c40:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c43:	6a 00                	push   $0x0
  801c45:	6a 00                	push   $0x0
  801c47:	6a 00                	push   $0x0
  801c49:	6a 00                	push   $0x0
  801c4b:	6a 00                	push   $0x0
  801c4d:	6a 2c                	push   $0x2c
  801c4f:	e8 ac fa ff ff       	call   801700 <syscall>
  801c54:	83 c4 18             	add    $0x18,%esp
  801c57:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801c5a:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801c5e:	75 07                	jne    801c67 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801c60:	b8 01 00 00 00       	mov    $0x1,%eax
  801c65:	eb 05                	jmp    801c6c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801c67:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c6c:	c9                   	leave  
  801c6d:	c3                   	ret    

00801c6e <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801c6e:	55                   	push   %ebp
  801c6f:	89 e5                	mov    %esp,%ebp
  801c71:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c74:	6a 00                	push   $0x0
  801c76:	6a 00                	push   $0x0
  801c78:	6a 00                	push   $0x0
  801c7a:	6a 00                	push   $0x0
  801c7c:	6a 00                	push   $0x0
  801c7e:	6a 2c                	push   $0x2c
  801c80:	e8 7b fa ff ff       	call   801700 <syscall>
  801c85:	83 c4 18             	add    $0x18,%esp
  801c88:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801c8b:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801c8f:	75 07                	jne    801c98 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801c91:	b8 01 00 00 00       	mov    $0x1,%eax
  801c96:	eb 05                	jmp    801c9d <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801c98:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c9d:	c9                   	leave  
  801c9e:	c3                   	ret    

00801c9f <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801c9f:	55                   	push   %ebp
  801ca0:	89 e5                	mov    %esp,%ebp
  801ca2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ca5:	6a 00                	push   $0x0
  801ca7:	6a 00                	push   $0x0
  801ca9:	6a 00                	push   $0x0
  801cab:	6a 00                	push   $0x0
  801cad:	6a 00                	push   $0x0
  801caf:	6a 2c                	push   $0x2c
  801cb1:	e8 4a fa ff ff       	call   801700 <syscall>
  801cb6:	83 c4 18             	add    $0x18,%esp
  801cb9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801cbc:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801cc0:	75 07                	jne    801cc9 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801cc2:	b8 01 00 00 00       	mov    $0x1,%eax
  801cc7:	eb 05                	jmp    801cce <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801cc9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cce:	c9                   	leave  
  801ccf:	c3                   	ret    

00801cd0 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801cd0:	55                   	push   %ebp
  801cd1:	89 e5                	mov    %esp,%ebp
  801cd3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 00                	push   $0x0
  801cda:	6a 00                	push   $0x0
  801cdc:	6a 00                	push   $0x0
  801cde:	6a 00                	push   $0x0
  801ce0:	6a 2c                	push   $0x2c
  801ce2:	e8 19 fa ff ff       	call   801700 <syscall>
  801ce7:	83 c4 18             	add    $0x18,%esp
  801cea:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801ced:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801cf1:	75 07                	jne    801cfa <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801cf3:	b8 01 00 00 00       	mov    $0x1,%eax
  801cf8:	eb 05                	jmp    801cff <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801cfa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cff:	c9                   	leave  
  801d00:	c3                   	ret    

00801d01 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801d01:	55                   	push   %ebp
  801d02:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801d04:	6a 00                	push   $0x0
  801d06:	6a 00                	push   $0x0
  801d08:	6a 00                	push   $0x0
  801d0a:	6a 00                	push   $0x0
  801d0c:	ff 75 08             	pushl  0x8(%ebp)
  801d0f:	6a 2d                	push   $0x2d
  801d11:	e8 ea f9 ff ff       	call   801700 <syscall>
  801d16:	83 c4 18             	add    $0x18,%esp
	return ;
  801d19:	90                   	nop
}
  801d1a:	c9                   	leave  
  801d1b:	c3                   	ret    

00801d1c <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801d1c:	55                   	push   %ebp
  801d1d:	89 e5                	mov    %esp,%ebp
  801d1f:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801d20:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d23:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d26:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d29:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2c:	6a 00                	push   $0x0
  801d2e:	53                   	push   %ebx
  801d2f:	51                   	push   %ecx
  801d30:	52                   	push   %edx
  801d31:	50                   	push   %eax
  801d32:	6a 2e                	push   $0x2e
  801d34:	e8 c7 f9 ff ff       	call   801700 <syscall>
  801d39:	83 c4 18             	add    $0x18,%esp
}
  801d3c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d3f:	c9                   	leave  
  801d40:	c3                   	ret    

00801d41 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801d41:	55                   	push   %ebp
  801d42:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801d44:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d47:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 00                	push   $0x0
  801d4e:	6a 00                	push   $0x0
  801d50:	52                   	push   %edx
  801d51:	50                   	push   %eax
  801d52:	6a 2f                	push   $0x2f
  801d54:	e8 a7 f9 ff ff       	call   801700 <syscall>
  801d59:	83 c4 18             	add    $0x18,%esp
}
  801d5c:	c9                   	leave  
  801d5d:	c3                   	ret    

00801d5e <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801d5e:	55                   	push   %ebp
  801d5f:	89 e5                	mov    %esp,%ebp
  801d61:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801d64:	83 ec 0c             	sub    $0xc,%esp
  801d67:	68 78 3e 80 00       	push   $0x803e78
  801d6c:	e8 d3 e8 ff ff       	call   800644 <cprintf>
  801d71:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801d74:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801d7b:	83 ec 0c             	sub    $0xc,%esp
  801d7e:	68 a4 3e 80 00       	push   $0x803ea4
  801d83:	e8 bc e8 ff ff       	call   800644 <cprintf>
  801d88:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801d8b:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d8f:	a1 38 51 80 00       	mov    0x805138,%eax
  801d94:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d97:	eb 56                	jmp    801def <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801d99:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d9d:	74 1c                	je     801dbb <print_mem_block_lists+0x5d>
  801d9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801da2:	8b 50 08             	mov    0x8(%eax),%edx
  801da5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801da8:	8b 48 08             	mov    0x8(%eax),%ecx
  801dab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dae:	8b 40 0c             	mov    0xc(%eax),%eax
  801db1:	01 c8                	add    %ecx,%eax
  801db3:	39 c2                	cmp    %eax,%edx
  801db5:	73 04                	jae    801dbb <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801db7:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801dbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dbe:	8b 50 08             	mov    0x8(%eax),%edx
  801dc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc4:	8b 40 0c             	mov    0xc(%eax),%eax
  801dc7:	01 c2                	add    %eax,%edx
  801dc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dcc:	8b 40 08             	mov    0x8(%eax),%eax
  801dcf:	83 ec 04             	sub    $0x4,%esp
  801dd2:	52                   	push   %edx
  801dd3:	50                   	push   %eax
  801dd4:	68 b9 3e 80 00       	push   $0x803eb9
  801dd9:	e8 66 e8 ff ff       	call   800644 <cprintf>
  801dde:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801de1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801de4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801de7:	a1 40 51 80 00       	mov    0x805140,%eax
  801dec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801def:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801df3:	74 07                	je     801dfc <print_mem_block_lists+0x9e>
  801df5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df8:	8b 00                	mov    (%eax),%eax
  801dfa:	eb 05                	jmp    801e01 <print_mem_block_lists+0xa3>
  801dfc:	b8 00 00 00 00       	mov    $0x0,%eax
  801e01:	a3 40 51 80 00       	mov    %eax,0x805140
  801e06:	a1 40 51 80 00       	mov    0x805140,%eax
  801e0b:	85 c0                	test   %eax,%eax
  801e0d:	75 8a                	jne    801d99 <print_mem_block_lists+0x3b>
  801e0f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e13:	75 84                	jne    801d99 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801e15:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e19:	75 10                	jne    801e2b <print_mem_block_lists+0xcd>
  801e1b:	83 ec 0c             	sub    $0xc,%esp
  801e1e:	68 c8 3e 80 00       	push   $0x803ec8
  801e23:	e8 1c e8 ff ff       	call   800644 <cprintf>
  801e28:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801e2b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801e32:	83 ec 0c             	sub    $0xc,%esp
  801e35:	68 ec 3e 80 00       	push   $0x803eec
  801e3a:	e8 05 e8 ff ff       	call   800644 <cprintf>
  801e3f:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801e42:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801e46:	a1 40 50 80 00       	mov    0x805040,%eax
  801e4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e4e:	eb 56                	jmp    801ea6 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e50:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e54:	74 1c                	je     801e72 <print_mem_block_lists+0x114>
  801e56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e59:	8b 50 08             	mov    0x8(%eax),%edx
  801e5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e5f:	8b 48 08             	mov    0x8(%eax),%ecx
  801e62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e65:	8b 40 0c             	mov    0xc(%eax),%eax
  801e68:	01 c8                	add    %ecx,%eax
  801e6a:	39 c2                	cmp    %eax,%edx
  801e6c:	73 04                	jae    801e72 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801e6e:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e75:	8b 50 08             	mov    0x8(%eax),%edx
  801e78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e7b:	8b 40 0c             	mov    0xc(%eax),%eax
  801e7e:	01 c2                	add    %eax,%edx
  801e80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e83:	8b 40 08             	mov    0x8(%eax),%eax
  801e86:	83 ec 04             	sub    $0x4,%esp
  801e89:	52                   	push   %edx
  801e8a:	50                   	push   %eax
  801e8b:	68 b9 3e 80 00       	push   $0x803eb9
  801e90:	e8 af e7 ff ff       	call   800644 <cprintf>
  801e95:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801e9e:	a1 48 50 80 00       	mov    0x805048,%eax
  801ea3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ea6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801eaa:	74 07                	je     801eb3 <print_mem_block_lists+0x155>
  801eac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eaf:	8b 00                	mov    (%eax),%eax
  801eb1:	eb 05                	jmp    801eb8 <print_mem_block_lists+0x15a>
  801eb3:	b8 00 00 00 00       	mov    $0x0,%eax
  801eb8:	a3 48 50 80 00       	mov    %eax,0x805048
  801ebd:	a1 48 50 80 00       	mov    0x805048,%eax
  801ec2:	85 c0                	test   %eax,%eax
  801ec4:	75 8a                	jne    801e50 <print_mem_block_lists+0xf2>
  801ec6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801eca:	75 84                	jne    801e50 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801ecc:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801ed0:	75 10                	jne    801ee2 <print_mem_block_lists+0x184>
  801ed2:	83 ec 0c             	sub    $0xc,%esp
  801ed5:	68 04 3f 80 00       	push   $0x803f04
  801eda:	e8 65 e7 ff ff       	call   800644 <cprintf>
  801edf:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801ee2:	83 ec 0c             	sub    $0xc,%esp
  801ee5:	68 78 3e 80 00       	push   $0x803e78
  801eea:	e8 55 e7 ff ff       	call   800644 <cprintf>
  801eef:	83 c4 10             	add    $0x10,%esp

}
  801ef2:	90                   	nop
  801ef3:	c9                   	leave  
  801ef4:	c3                   	ret    

00801ef5 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801ef5:	55                   	push   %ebp
  801ef6:	89 e5                	mov    %esp,%ebp
  801ef8:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801efb:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  801f02:	00 00 00 
  801f05:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  801f0c:	00 00 00 
  801f0f:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  801f16:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801f19:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801f20:	e9 9e 00 00 00       	jmp    801fc3 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801f25:	a1 50 50 80 00       	mov    0x805050,%eax
  801f2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f2d:	c1 e2 04             	shl    $0x4,%edx
  801f30:	01 d0                	add    %edx,%eax
  801f32:	85 c0                	test   %eax,%eax
  801f34:	75 14                	jne    801f4a <initialize_MemBlocksList+0x55>
  801f36:	83 ec 04             	sub    $0x4,%esp
  801f39:	68 2c 3f 80 00       	push   $0x803f2c
  801f3e:	6a 46                	push   $0x46
  801f40:	68 4f 3f 80 00       	push   $0x803f4f
  801f45:	e8 46 e4 ff ff       	call   800390 <_panic>
  801f4a:	a1 50 50 80 00       	mov    0x805050,%eax
  801f4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f52:	c1 e2 04             	shl    $0x4,%edx
  801f55:	01 d0                	add    %edx,%eax
  801f57:	8b 15 48 51 80 00    	mov    0x805148,%edx
  801f5d:	89 10                	mov    %edx,(%eax)
  801f5f:	8b 00                	mov    (%eax),%eax
  801f61:	85 c0                	test   %eax,%eax
  801f63:	74 18                	je     801f7d <initialize_MemBlocksList+0x88>
  801f65:	a1 48 51 80 00       	mov    0x805148,%eax
  801f6a:	8b 15 50 50 80 00    	mov    0x805050,%edx
  801f70:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801f73:	c1 e1 04             	shl    $0x4,%ecx
  801f76:	01 ca                	add    %ecx,%edx
  801f78:	89 50 04             	mov    %edx,0x4(%eax)
  801f7b:	eb 12                	jmp    801f8f <initialize_MemBlocksList+0x9a>
  801f7d:	a1 50 50 80 00       	mov    0x805050,%eax
  801f82:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f85:	c1 e2 04             	shl    $0x4,%edx
  801f88:	01 d0                	add    %edx,%eax
  801f8a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801f8f:	a1 50 50 80 00       	mov    0x805050,%eax
  801f94:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f97:	c1 e2 04             	shl    $0x4,%edx
  801f9a:	01 d0                	add    %edx,%eax
  801f9c:	a3 48 51 80 00       	mov    %eax,0x805148
  801fa1:	a1 50 50 80 00       	mov    0x805050,%eax
  801fa6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fa9:	c1 e2 04             	shl    $0x4,%edx
  801fac:	01 d0                	add    %edx,%eax
  801fae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801fb5:	a1 54 51 80 00       	mov    0x805154,%eax
  801fba:	40                   	inc    %eax
  801fbb:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801fc0:	ff 45 f4             	incl   -0xc(%ebp)
  801fc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc6:	3b 45 08             	cmp    0x8(%ebp),%eax
  801fc9:	0f 82 56 ff ff ff    	jb     801f25 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801fcf:	90                   	nop
  801fd0:	c9                   	leave  
  801fd1:	c3                   	ret    

00801fd2 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801fd2:	55                   	push   %ebp
  801fd3:	89 e5                	mov    %esp,%ebp
  801fd5:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  801fdb:	8b 00                	mov    (%eax),%eax
  801fdd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801fe0:	eb 19                	jmp    801ffb <find_block+0x29>
	{
		if(va==point->sva)
  801fe2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fe5:	8b 40 08             	mov    0x8(%eax),%eax
  801fe8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801feb:	75 05                	jne    801ff2 <find_block+0x20>
		   return point;
  801fed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ff0:	eb 36                	jmp    802028 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801ff2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff5:	8b 40 08             	mov    0x8(%eax),%eax
  801ff8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801ffb:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801fff:	74 07                	je     802008 <find_block+0x36>
  802001:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802004:	8b 00                	mov    (%eax),%eax
  802006:	eb 05                	jmp    80200d <find_block+0x3b>
  802008:	b8 00 00 00 00       	mov    $0x0,%eax
  80200d:	8b 55 08             	mov    0x8(%ebp),%edx
  802010:	89 42 08             	mov    %eax,0x8(%edx)
  802013:	8b 45 08             	mov    0x8(%ebp),%eax
  802016:	8b 40 08             	mov    0x8(%eax),%eax
  802019:	85 c0                	test   %eax,%eax
  80201b:	75 c5                	jne    801fe2 <find_block+0x10>
  80201d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802021:	75 bf                	jne    801fe2 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802023:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802028:	c9                   	leave  
  802029:	c3                   	ret    

0080202a <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80202a:	55                   	push   %ebp
  80202b:	89 e5                	mov    %esp,%ebp
  80202d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802030:	a1 40 50 80 00       	mov    0x805040,%eax
  802035:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802038:	a1 44 50 80 00       	mov    0x805044,%eax
  80203d:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802040:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802043:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802046:	74 24                	je     80206c <insert_sorted_allocList+0x42>
  802048:	8b 45 08             	mov    0x8(%ebp),%eax
  80204b:	8b 50 08             	mov    0x8(%eax),%edx
  80204e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802051:	8b 40 08             	mov    0x8(%eax),%eax
  802054:	39 c2                	cmp    %eax,%edx
  802056:	76 14                	jbe    80206c <insert_sorted_allocList+0x42>
  802058:	8b 45 08             	mov    0x8(%ebp),%eax
  80205b:	8b 50 08             	mov    0x8(%eax),%edx
  80205e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802061:	8b 40 08             	mov    0x8(%eax),%eax
  802064:	39 c2                	cmp    %eax,%edx
  802066:	0f 82 60 01 00 00    	jb     8021cc <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  80206c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802070:	75 65                	jne    8020d7 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802072:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802076:	75 14                	jne    80208c <insert_sorted_allocList+0x62>
  802078:	83 ec 04             	sub    $0x4,%esp
  80207b:	68 2c 3f 80 00       	push   $0x803f2c
  802080:	6a 6b                	push   $0x6b
  802082:	68 4f 3f 80 00       	push   $0x803f4f
  802087:	e8 04 e3 ff ff       	call   800390 <_panic>
  80208c:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802092:	8b 45 08             	mov    0x8(%ebp),%eax
  802095:	89 10                	mov    %edx,(%eax)
  802097:	8b 45 08             	mov    0x8(%ebp),%eax
  80209a:	8b 00                	mov    (%eax),%eax
  80209c:	85 c0                	test   %eax,%eax
  80209e:	74 0d                	je     8020ad <insert_sorted_allocList+0x83>
  8020a0:	a1 40 50 80 00       	mov    0x805040,%eax
  8020a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8020a8:	89 50 04             	mov    %edx,0x4(%eax)
  8020ab:	eb 08                	jmp    8020b5 <insert_sorted_allocList+0x8b>
  8020ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b0:	a3 44 50 80 00       	mov    %eax,0x805044
  8020b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b8:	a3 40 50 80 00       	mov    %eax,0x805040
  8020bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020c7:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8020cc:	40                   	inc    %eax
  8020cd:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8020d2:	e9 dc 01 00 00       	jmp    8022b3 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8020d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020da:	8b 50 08             	mov    0x8(%eax),%edx
  8020dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020e0:	8b 40 08             	mov    0x8(%eax),%eax
  8020e3:	39 c2                	cmp    %eax,%edx
  8020e5:	77 6c                	ja     802153 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8020e7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020eb:	74 06                	je     8020f3 <insert_sorted_allocList+0xc9>
  8020ed:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020f1:	75 14                	jne    802107 <insert_sorted_allocList+0xdd>
  8020f3:	83 ec 04             	sub    $0x4,%esp
  8020f6:	68 68 3f 80 00       	push   $0x803f68
  8020fb:	6a 6f                	push   $0x6f
  8020fd:	68 4f 3f 80 00       	push   $0x803f4f
  802102:	e8 89 e2 ff ff       	call   800390 <_panic>
  802107:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80210a:	8b 50 04             	mov    0x4(%eax),%edx
  80210d:	8b 45 08             	mov    0x8(%ebp),%eax
  802110:	89 50 04             	mov    %edx,0x4(%eax)
  802113:	8b 45 08             	mov    0x8(%ebp),%eax
  802116:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802119:	89 10                	mov    %edx,(%eax)
  80211b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80211e:	8b 40 04             	mov    0x4(%eax),%eax
  802121:	85 c0                	test   %eax,%eax
  802123:	74 0d                	je     802132 <insert_sorted_allocList+0x108>
  802125:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802128:	8b 40 04             	mov    0x4(%eax),%eax
  80212b:	8b 55 08             	mov    0x8(%ebp),%edx
  80212e:	89 10                	mov    %edx,(%eax)
  802130:	eb 08                	jmp    80213a <insert_sorted_allocList+0x110>
  802132:	8b 45 08             	mov    0x8(%ebp),%eax
  802135:	a3 40 50 80 00       	mov    %eax,0x805040
  80213a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80213d:	8b 55 08             	mov    0x8(%ebp),%edx
  802140:	89 50 04             	mov    %edx,0x4(%eax)
  802143:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802148:	40                   	inc    %eax
  802149:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80214e:	e9 60 01 00 00       	jmp    8022b3 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802153:	8b 45 08             	mov    0x8(%ebp),%eax
  802156:	8b 50 08             	mov    0x8(%eax),%edx
  802159:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80215c:	8b 40 08             	mov    0x8(%eax),%eax
  80215f:	39 c2                	cmp    %eax,%edx
  802161:	0f 82 4c 01 00 00    	jb     8022b3 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802167:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80216b:	75 14                	jne    802181 <insert_sorted_allocList+0x157>
  80216d:	83 ec 04             	sub    $0x4,%esp
  802170:	68 a0 3f 80 00       	push   $0x803fa0
  802175:	6a 73                	push   $0x73
  802177:	68 4f 3f 80 00       	push   $0x803f4f
  80217c:	e8 0f e2 ff ff       	call   800390 <_panic>
  802181:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802187:	8b 45 08             	mov    0x8(%ebp),%eax
  80218a:	89 50 04             	mov    %edx,0x4(%eax)
  80218d:	8b 45 08             	mov    0x8(%ebp),%eax
  802190:	8b 40 04             	mov    0x4(%eax),%eax
  802193:	85 c0                	test   %eax,%eax
  802195:	74 0c                	je     8021a3 <insert_sorted_allocList+0x179>
  802197:	a1 44 50 80 00       	mov    0x805044,%eax
  80219c:	8b 55 08             	mov    0x8(%ebp),%edx
  80219f:	89 10                	mov    %edx,(%eax)
  8021a1:	eb 08                	jmp    8021ab <insert_sorted_allocList+0x181>
  8021a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a6:	a3 40 50 80 00       	mov    %eax,0x805040
  8021ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ae:	a3 44 50 80 00       	mov    %eax,0x805044
  8021b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021bc:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8021c1:	40                   	inc    %eax
  8021c2:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8021c7:	e9 e7 00 00 00       	jmp    8022b3 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8021cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8021d2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8021d9:	a1 40 50 80 00       	mov    0x805040,%eax
  8021de:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021e1:	e9 9d 00 00 00       	jmp    802283 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8021e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e9:	8b 00                	mov    (%eax),%eax
  8021eb:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8021ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f1:	8b 50 08             	mov    0x8(%eax),%edx
  8021f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f7:	8b 40 08             	mov    0x8(%eax),%eax
  8021fa:	39 c2                	cmp    %eax,%edx
  8021fc:	76 7d                	jbe    80227b <insert_sorted_allocList+0x251>
  8021fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802201:	8b 50 08             	mov    0x8(%eax),%edx
  802204:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802207:	8b 40 08             	mov    0x8(%eax),%eax
  80220a:	39 c2                	cmp    %eax,%edx
  80220c:	73 6d                	jae    80227b <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  80220e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802212:	74 06                	je     80221a <insert_sorted_allocList+0x1f0>
  802214:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802218:	75 14                	jne    80222e <insert_sorted_allocList+0x204>
  80221a:	83 ec 04             	sub    $0x4,%esp
  80221d:	68 c4 3f 80 00       	push   $0x803fc4
  802222:	6a 7f                	push   $0x7f
  802224:	68 4f 3f 80 00       	push   $0x803f4f
  802229:	e8 62 e1 ff ff       	call   800390 <_panic>
  80222e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802231:	8b 10                	mov    (%eax),%edx
  802233:	8b 45 08             	mov    0x8(%ebp),%eax
  802236:	89 10                	mov    %edx,(%eax)
  802238:	8b 45 08             	mov    0x8(%ebp),%eax
  80223b:	8b 00                	mov    (%eax),%eax
  80223d:	85 c0                	test   %eax,%eax
  80223f:	74 0b                	je     80224c <insert_sorted_allocList+0x222>
  802241:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802244:	8b 00                	mov    (%eax),%eax
  802246:	8b 55 08             	mov    0x8(%ebp),%edx
  802249:	89 50 04             	mov    %edx,0x4(%eax)
  80224c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224f:	8b 55 08             	mov    0x8(%ebp),%edx
  802252:	89 10                	mov    %edx,(%eax)
  802254:	8b 45 08             	mov    0x8(%ebp),%eax
  802257:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80225a:	89 50 04             	mov    %edx,0x4(%eax)
  80225d:	8b 45 08             	mov    0x8(%ebp),%eax
  802260:	8b 00                	mov    (%eax),%eax
  802262:	85 c0                	test   %eax,%eax
  802264:	75 08                	jne    80226e <insert_sorted_allocList+0x244>
  802266:	8b 45 08             	mov    0x8(%ebp),%eax
  802269:	a3 44 50 80 00       	mov    %eax,0x805044
  80226e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802273:	40                   	inc    %eax
  802274:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802279:	eb 39                	jmp    8022b4 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80227b:	a1 48 50 80 00       	mov    0x805048,%eax
  802280:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802283:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802287:	74 07                	je     802290 <insert_sorted_allocList+0x266>
  802289:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228c:	8b 00                	mov    (%eax),%eax
  80228e:	eb 05                	jmp    802295 <insert_sorted_allocList+0x26b>
  802290:	b8 00 00 00 00       	mov    $0x0,%eax
  802295:	a3 48 50 80 00       	mov    %eax,0x805048
  80229a:	a1 48 50 80 00       	mov    0x805048,%eax
  80229f:	85 c0                	test   %eax,%eax
  8022a1:	0f 85 3f ff ff ff    	jne    8021e6 <insert_sorted_allocList+0x1bc>
  8022a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022ab:	0f 85 35 ff ff ff    	jne    8021e6 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8022b1:	eb 01                	jmp    8022b4 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8022b3:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8022b4:	90                   	nop
  8022b5:	c9                   	leave  
  8022b6:	c3                   	ret    

008022b7 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8022b7:	55                   	push   %ebp
  8022b8:	89 e5                	mov    %esp,%ebp
  8022ba:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8022bd:	a1 38 51 80 00       	mov    0x805138,%eax
  8022c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022c5:	e9 85 01 00 00       	jmp    80244f <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8022ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022cd:	8b 40 0c             	mov    0xc(%eax),%eax
  8022d0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022d3:	0f 82 6e 01 00 00    	jb     802447 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8022d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8022df:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022e2:	0f 85 8a 00 00 00    	jne    802372 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8022e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022ec:	75 17                	jne    802305 <alloc_block_FF+0x4e>
  8022ee:	83 ec 04             	sub    $0x4,%esp
  8022f1:	68 f8 3f 80 00       	push   $0x803ff8
  8022f6:	68 93 00 00 00       	push   $0x93
  8022fb:	68 4f 3f 80 00       	push   $0x803f4f
  802300:	e8 8b e0 ff ff       	call   800390 <_panic>
  802305:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802308:	8b 00                	mov    (%eax),%eax
  80230a:	85 c0                	test   %eax,%eax
  80230c:	74 10                	je     80231e <alloc_block_FF+0x67>
  80230e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802311:	8b 00                	mov    (%eax),%eax
  802313:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802316:	8b 52 04             	mov    0x4(%edx),%edx
  802319:	89 50 04             	mov    %edx,0x4(%eax)
  80231c:	eb 0b                	jmp    802329 <alloc_block_FF+0x72>
  80231e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802321:	8b 40 04             	mov    0x4(%eax),%eax
  802324:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802329:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232c:	8b 40 04             	mov    0x4(%eax),%eax
  80232f:	85 c0                	test   %eax,%eax
  802331:	74 0f                	je     802342 <alloc_block_FF+0x8b>
  802333:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802336:	8b 40 04             	mov    0x4(%eax),%eax
  802339:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80233c:	8b 12                	mov    (%edx),%edx
  80233e:	89 10                	mov    %edx,(%eax)
  802340:	eb 0a                	jmp    80234c <alloc_block_FF+0x95>
  802342:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802345:	8b 00                	mov    (%eax),%eax
  802347:	a3 38 51 80 00       	mov    %eax,0x805138
  80234c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802355:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802358:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80235f:	a1 44 51 80 00       	mov    0x805144,%eax
  802364:	48                   	dec    %eax
  802365:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  80236a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236d:	e9 10 01 00 00       	jmp    802482 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802372:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802375:	8b 40 0c             	mov    0xc(%eax),%eax
  802378:	3b 45 08             	cmp    0x8(%ebp),%eax
  80237b:	0f 86 c6 00 00 00    	jbe    802447 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802381:	a1 48 51 80 00       	mov    0x805148,%eax
  802386:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802389:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238c:	8b 50 08             	mov    0x8(%eax),%edx
  80238f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802392:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802395:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802398:	8b 55 08             	mov    0x8(%ebp),%edx
  80239b:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80239e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023a2:	75 17                	jne    8023bb <alloc_block_FF+0x104>
  8023a4:	83 ec 04             	sub    $0x4,%esp
  8023a7:	68 f8 3f 80 00       	push   $0x803ff8
  8023ac:	68 9b 00 00 00       	push   $0x9b
  8023b1:	68 4f 3f 80 00       	push   $0x803f4f
  8023b6:	e8 d5 df ff ff       	call   800390 <_panic>
  8023bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023be:	8b 00                	mov    (%eax),%eax
  8023c0:	85 c0                	test   %eax,%eax
  8023c2:	74 10                	je     8023d4 <alloc_block_FF+0x11d>
  8023c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023c7:	8b 00                	mov    (%eax),%eax
  8023c9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023cc:	8b 52 04             	mov    0x4(%edx),%edx
  8023cf:	89 50 04             	mov    %edx,0x4(%eax)
  8023d2:	eb 0b                	jmp    8023df <alloc_block_FF+0x128>
  8023d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023d7:	8b 40 04             	mov    0x4(%eax),%eax
  8023da:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8023df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023e2:	8b 40 04             	mov    0x4(%eax),%eax
  8023e5:	85 c0                	test   %eax,%eax
  8023e7:	74 0f                	je     8023f8 <alloc_block_FF+0x141>
  8023e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ec:	8b 40 04             	mov    0x4(%eax),%eax
  8023ef:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023f2:	8b 12                	mov    (%edx),%edx
  8023f4:	89 10                	mov    %edx,(%eax)
  8023f6:	eb 0a                	jmp    802402 <alloc_block_FF+0x14b>
  8023f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023fb:	8b 00                	mov    (%eax),%eax
  8023fd:	a3 48 51 80 00       	mov    %eax,0x805148
  802402:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802405:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80240b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80240e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802415:	a1 54 51 80 00       	mov    0x805154,%eax
  80241a:	48                   	dec    %eax
  80241b:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802420:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802423:	8b 50 08             	mov    0x8(%eax),%edx
  802426:	8b 45 08             	mov    0x8(%ebp),%eax
  802429:	01 c2                	add    %eax,%edx
  80242b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242e:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802431:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802434:	8b 40 0c             	mov    0xc(%eax),%eax
  802437:	2b 45 08             	sub    0x8(%ebp),%eax
  80243a:	89 c2                	mov    %eax,%edx
  80243c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243f:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802442:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802445:	eb 3b                	jmp    802482 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802447:	a1 40 51 80 00       	mov    0x805140,%eax
  80244c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80244f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802453:	74 07                	je     80245c <alloc_block_FF+0x1a5>
  802455:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802458:	8b 00                	mov    (%eax),%eax
  80245a:	eb 05                	jmp    802461 <alloc_block_FF+0x1aa>
  80245c:	b8 00 00 00 00       	mov    $0x0,%eax
  802461:	a3 40 51 80 00       	mov    %eax,0x805140
  802466:	a1 40 51 80 00       	mov    0x805140,%eax
  80246b:	85 c0                	test   %eax,%eax
  80246d:	0f 85 57 fe ff ff    	jne    8022ca <alloc_block_FF+0x13>
  802473:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802477:	0f 85 4d fe ff ff    	jne    8022ca <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  80247d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802482:	c9                   	leave  
  802483:	c3                   	ret    

00802484 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802484:	55                   	push   %ebp
  802485:	89 e5                	mov    %esp,%ebp
  802487:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  80248a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802491:	a1 38 51 80 00       	mov    0x805138,%eax
  802496:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802499:	e9 df 00 00 00       	jmp    80257d <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  80249e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a1:	8b 40 0c             	mov    0xc(%eax),%eax
  8024a4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024a7:	0f 82 c8 00 00 00    	jb     802575 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8024ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8024b3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024b6:	0f 85 8a 00 00 00    	jne    802546 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8024bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024c0:	75 17                	jne    8024d9 <alloc_block_BF+0x55>
  8024c2:	83 ec 04             	sub    $0x4,%esp
  8024c5:	68 f8 3f 80 00       	push   $0x803ff8
  8024ca:	68 b7 00 00 00       	push   $0xb7
  8024cf:	68 4f 3f 80 00       	push   $0x803f4f
  8024d4:	e8 b7 de ff ff       	call   800390 <_panic>
  8024d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024dc:	8b 00                	mov    (%eax),%eax
  8024de:	85 c0                	test   %eax,%eax
  8024e0:	74 10                	je     8024f2 <alloc_block_BF+0x6e>
  8024e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e5:	8b 00                	mov    (%eax),%eax
  8024e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024ea:	8b 52 04             	mov    0x4(%edx),%edx
  8024ed:	89 50 04             	mov    %edx,0x4(%eax)
  8024f0:	eb 0b                	jmp    8024fd <alloc_block_BF+0x79>
  8024f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f5:	8b 40 04             	mov    0x4(%eax),%eax
  8024f8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8024fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802500:	8b 40 04             	mov    0x4(%eax),%eax
  802503:	85 c0                	test   %eax,%eax
  802505:	74 0f                	je     802516 <alloc_block_BF+0x92>
  802507:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250a:	8b 40 04             	mov    0x4(%eax),%eax
  80250d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802510:	8b 12                	mov    (%edx),%edx
  802512:	89 10                	mov    %edx,(%eax)
  802514:	eb 0a                	jmp    802520 <alloc_block_BF+0x9c>
  802516:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802519:	8b 00                	mov    (%eax),%eax
  80251b:	a3 38 51 80 00       	mov    %eax,0x805138
  802520:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802523:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802529:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802533:	a1 44 51 80 00       	mov    0x805144,%eax
  802538:	48                   	dec    %eax
  802539:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  80253e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802541:	e9 4d 01 00 00       	jmp    802693 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802546:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802549:	8b 40 0c             	mov    0xc(%eax),%eax
  80254c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80254f:	76 24                	jbe    802575 <alloc_block_BF+0xf1>
  802551:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802554:	8b 40 0c             	mov    0xc(%eax),%eax
  802557:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80255a:	73 19                	jae    802575 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  80255c:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802563:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802566:	8b 40 0c             	mov    0xc(%eax),%eax
  802569:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  80256c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256f:	8b 40 08             	mov    0x8(%eax),%eax
  802572:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802575:	a1 40 51 80 00       	mov    0x805140,%eax
  80257a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80257d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802581:	74 07                	je     80258a <alloc_block_BF+0x106>
  802583:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802586:	8b 00                	mov    (%eax),%eax
  802588:	eb 05                	jmp    80258f <alloc_block_BF+0x10b>
  80258a:	b8 00 00 00 00       	mov    $0x0,%eax
  80258f:	a3 40 51 80 00       	mov    %eax,0x805140
  802594:	a1 40 51 80 00       	mov    0x805140,%eax
  802599:	85 c0                	test   %eax,%eax
  80259b:	0f 85 fd fe ff ff    	jne    80249e <alloc_block_BF+0x1a>
  8025a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025a5:	0f 85 f3 fe ff ff    	jne    80249e <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8025ab:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8025af:	0f 84 d9 00 00 00    	je     80268e <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8025b5:	a1 48 51 80 00       	mov    0x805148,%eax
  8025ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8025bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025c0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025c3:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8025c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8025cc:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8025cf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8025d3:	75 17                	jne    8025ec <alloc_block_BF+0x168>
  8025d5:	83 ec 04             	sub    $0x4,%esp
  8025d8:	68 f8 3f 80 00       	push   $0x803ff8
  8025dd:	68 c7 00 00 00       	push   $0xc7
  8025e2:	68 4f 3f 80 00       	push   $0x803f4f
  8025e7:	e8 a4 dd ff ff       	call   800390 <_panic>
  8025ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025ef:	8b 00                	mov    (%eax),%eax
  8025f1:	85 c0                	test   %eax,%eax
  8025f3:	74 10                	je     802605 <alloc_block_BF+0x181>
  8025f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025f8:	8b 00                	mov    (%eax),%eax
  8025fa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025fd:	8b 52 04             	mov    0x4(%edx),%edx
  802600:	89 50 04             	mov    %edx,0x4(%eax)
  802603:	eb 0b                	jmp    802610 <alloc_block_BF+0x18c>
  802605:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802608:	8b 40 04             	mov    0x4(%eax),%eax
  80260b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802610:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802613:	8b 40 04             	mov    0x4(%eax),%eax
  802616:	85 c0                	test   %eax,%eax
  802618:	74 0f                	je     802629 <alloc_block_BF+0x1a5>
  80261a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80261d:	8b 40 04             	mov    0x4(%eax),%eax
  802620:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802623:	8b 12                	mov    (%edx),%edx
  802625:	89 10                	mov    %edx,(%eax)
  802627:	eb 0a                	jmp    802633 <alloc_block_BF+0x1af>
  802629:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80262c:	8b 00                	mov    (%eax),%eax
  80262e:	a3 48 51 80 00       	mov    %eax,0x805148
  802633:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802636:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80263c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80263f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802646:	a1 54 51 80 00       	mov    0x805154,%eax
  80264b:	48                   	dec    %eax
  80264c:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802651:	83 ec 08             	sub    $0x8,%esp
  802654:	ff 75 ec             	pushl  -0x14(%ebp)
  802657:	68 38 51 80 00       	push   $0x805138
  80265c:	e8 71 f9 ff ff       	call   801fd2 <find_block>
  802661:	83 c4 10             	add    $0x10,%esp
  802664:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802667:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80266a:	8b 50 08             	mov    0x8(%eax),%edx
  80266d:	8b 45 08             	mov    0x8(%ebp),%eax
  802670:	01 c2                	add    %eax,%edx
  802672:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802675:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802678:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80267b:	8b 40 0c             	mov    0xc(%eax),%eax
  80267e:	2b 45 08             	sub    0x8(%ebp),%eax
  802681:	89 c2                	mov    %eax,%edx
  802683:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802686:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802689:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80268c:	eb 05                	jmp    802693 <alloc_block_BF+0x20f>
	}
	return NULL;
  80268e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802693:	c9                   	leave  
  802694:	c3                   	ret    

00802695 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802695:	55                   	push   %ebp
  802696:	89 e5                	mov    %esp,%ebp
  802698:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  80269b:	a1 28 50 80 00       	mov    0x805028,%eax
  8026a0:	85 c0                	test   %eax,%eax
  8026a2:	0f 85 de 01 00 00    	jne    802886 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8026a8:	a1 38 51 80 00       	mov    0x805138,%eax
  8026ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026b0:	e9 9e 01 00 00       	jmp    802853 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8026b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b8:	8b 40 0c             	mov    0xc(%eax),%eax
  8026bb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026be:	0f 82 87 01 00 00    	jb     80284b <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8026c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c7:	8b 40 0c             	mov    0xc(%eax),%eax
  8026ca:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026cd:	0f 85 95 00 00 00    	jne    802768 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8026d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026d7:	75 17                	jne    8026f0 <alloc_block_NF+0x5b>
  8026d9:	83 ec 04             	sub    $0x4,%esp
  8026dc:	68 f8 3f 80 00       	push   $0x803ff8
  8026e1:	68 e0 00 00 00       	push   $0xe0
  8026e6:	68 4f 3f 80 00       	push   $0x803f4f
  8026eb:	e8 a0 dc ff ff       	call   800390 <_panic>
  8026f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f3:	8b 00                	mov    (%eax),%eax
  8026f5:	85 c0                	test   %eax,%eax
  8026f7:	74 10                	je     802709 <alloc_block_NF+0x74>
  8026f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fc:	8b 00                	mov    (%eax),%eax
  8026fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802701:	8b 52 04             	mov    0x4(%edx),%edx
  802704:	89 50 04             	mov    %edx,0x4(%eax)
  802707:	eb 0b                	jmp    802714 <alloc_block_NF+0x7f>
  802709:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270c:	8b 40 04             	mov    0x4(%eax),%eax
  80270f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802714:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802717:	8b 40 04             	mov    0x4(%eax),%eax
  80271a:	85 c0                	test   %eax,%eax
  80271c:	74 0f                	je     80272d <alloc_block_NF+0x98>
  80271e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802721:	8b 40 04             	mov    0x4(%eax),%eax
  802724:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802727:	8b 12                	mov    (%edx),%edx
  802729:	89 10                	mov    %edx,(%eax)
  80272b:	eb 0a                	jmp    802737 <alloc_block_NF+0xa2>
  80272d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802730:	8b 00                	mov    (%eax),%eax
  802732:	a3 38 51 80 00       	mov    %eax,0x805138
  802737:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802740:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802743:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80274a:	a1 44 51 80 00       	mov    0x805144,%eax
  80274f:	48                   	dec    %eax
  802750:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802755:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802758:	8b 40 08             	mov    0x8(%eax),%eax
  80275b:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802760:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802763:	e9 f8 04 00 00       	jmp    802c60 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802768:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276b:	8b 40 0c             	mov    0xc(%eax),%eax
  80276e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802771:	0f 86 d4 00 00 00    	jbe    80284b <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802777:	a1 48 51 80 00       	mov    0x805148,%eax
  80277c:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  80277f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802782:	8b 50 08             	mov    0x8(%eax),%edx
  802785:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802788:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  80278b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80278e:	8b 55 08             	mov    0x8(%ebp),%edx
  802791:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802794:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802798:	75 17                	jne    8027b1 <alloc_block_NF+0x11c>
  80279a:	83 ec 04             	sub    $0x4,%esp
  80279d:	68 f8 3f 80 00       	push   $0x803ff8
  8027a2:	68 e9 00 00 00       	push   $0xe9
  8027a7:	68 4f 3f 80 00       	push   $0x803f4f
  8027ac:	e8 df db ff ff       	call   800390 <_panic>
  8027b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027b4:	8b 00                	mov    (%eax),%eax
  8027b6:	85 c0                	test   %eax,%eax
  8027b8:	74 10                	je     8027ca <alloc_block_NF+0x135>
  8027ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027bd:	8b 00                	mov    (%eax),%eax
  8027bf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027c2:	8b 52 04             	mov    0x4(%edx),%edx
  8027c5:	89 50 04             	mov    %edx,0x4(%eax)
  8027c8:	eb 0b                	jmp    8027d5 <alloc_block_NF+0x140>
  8027ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027cd:	8b 40 04             	mov    0x4(%eax),%eax
  8027d0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8027d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027d8:	8b 40 04             	mov    0x4(%eax),%eax
  8027db:	85 c0                	test   %eax,%eax
  8027dd:	74 0f                	je     8027ee <alloc_block_NF+0x159>
  8027df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e2:	8b 40 04             	mov    0x4(%eax),%eax
  8027e5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027e8:	8b 12                	mov    (%edx),%edx
  8027ea:	89 10                	mov    %edx,(%eax)
  8027ec:	eb 0a                	jmp    8027f8 <alloc_block_NF+0x163>
  8027ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f1:	8b 00                	mov    (%eax),%eax
  8027f3:	a3 48 51 80 00       	mov    %eax,0x805148
  8027f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027fb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802801:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802804:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80280b:	a1 54 51 80 00       	mov    0x805154,%eax
  802810:	48                   	dec    %eax
  802811:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802816:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802819:	8b 40 08             	mov    0x8(%eax),%eax
  80281c:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802821:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802824:	8b 50 08             	mov    0x8(%eax),%edx
  802827:	8b 45 08             	mov    0x8(%ebp),%eax
  80282a:	01 c2                	add    %eax,%edx
  80282c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282f:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802832:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802835:	8b 40 0c             	mov    0xc(%eax),%eax
  802838:	2b 45 08             	sub    0x8(%ebp),%eax
  80283b:	89 c2                	mov    %eax,%edx
  80283d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802840:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802843:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802846:	e9 15 04 00 00       	jmp    802c60 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80284b:	a1 40 51 80 00       	mov    0x805140,%eax
  802850:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802853:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802857:	74 07                	je     802860 <alloc_block_NF+0x1cb>
  802859:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285c:	8b 00                	mov    (%eax),%eax
  80285e:	eb 05                	jmp    802865 <alloc_block_NF+0x1d0>
  802860:	b8 00 00 00 00       	mov    $0x0,%eax
  802865:	a3 40 51 80 00       	mov    %eax,0x805140
  80286a:	a1 40 51 80 00       	mov    0x805140,%eax
  80286f:	85 c0                	test   %eax,%eax
  802871:	0f 85 3e fe ff ff    	jne    8026b5 <alloc_block_NF+0x20>
  802877:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80287b:	0f 85 34 fe ff ff    	jne    8026b5 <alloc_block_NF+0x20>
  802881:	e9 d5 03 00 00       	jmp    802c5b <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802886:	a1 38 51 80 00       	mov    0x805138,%eax
  80288b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80288e:	e9 b1 01 00 00       	jmp    802a44 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802893:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802896:	8b 50 08             	mov    0x8(%eax),%edx
  802899:	a1 28 50 80 00       	mov    0x805028,%eax
  80289e:	39 c2                	cmp    %eax,%edx
  8028a0:	0f 82 96 01 00 00    	jb     802a3c <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  8028a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8028ac:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028af:	0f 82 87 01 00 00    	jb     802a3c <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  8028b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b8:	8b 40 0c             	mov    0xc(%eax),%eax
  8028bb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028be:	0f 85 95 00 00 00    	jne    802959 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8028c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028c8:	75 17                	jne    8028e1 <alloc_block_NF+0x24c>
  8028ca:	83 ec 04             	sub    $0x4,%esp
  8028cd:	68 f8 3f 80 00       	push   $0x803ff8
  8028d2:	68 fc 00 00 00       	push   $0xfc
  8028d7:	68 4f 3f 80 00       	push   $0x803f4f
  8028dc:	e8 af da ff ff       	call   800390 <_panic>
  8028e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e4:	8b 00                	mov    (%eax),%eax
  8028e6:	85 c0                	test   %eax,%eax
  8028e8:	74 10                	je     8028fa <alloc_block_NF+0x265>
  8028ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ed:	8b 00                	mov    (%eax),%eax
  8028ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028f2:	8b 52 04             	mov    0x4(%edx),%edx
  8028f5:	89 50 04             	mov    %edx,0x4(%eax)
  8028f8:	eb 0b                	jmp    802905 <alloc_block_NF+0x270>
  8028fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fd:	8b 40 04             	mov    0x4(%eax),%eax
  802900:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802905:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802908:	8b 40 04             	mov    0x4(%eax),%eax
  80290b:	85 c0                	test   %eax,%eax
  80290d:	74 0f                	je     80291e <alloc_block_NF+0x289>
  80290f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802912:	8b 40 04             	mov    0x4(%eax),%eax
  802915:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802918:	8b 12                	mov    (%edx),%edx
  80291a:	89 10                	mov    %edx,(%eax)
  80291c:	eb 0a                	jmp    802928 <alloc_block_NF+0x293>
  80291e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802921:	8b 00                	mov    (%eax),%eax
  802923:	a3 38 51 80 00       	mov    %eax,0x805138
  802928:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802931:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802934:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80293b:	a1 44 51 80 00       	mov    0x805144,%eax
  802940:	48                   	dec    %eax
  802941:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802946:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802949:	8b 40 08             	mov    0x8(%eax),%eax
  80294c:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802951:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802954:	e9 07 03 00 00       	jmp    802c60 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802959:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295c:	8b 40 0c             	mov    0xc(%eax),%eax
  80295f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802962:	0f 86 d4 00 00 00    	jbe    802a3c <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802968:	a1 48 51 80 00       	mov    0x805148,%eax
  80296d:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802970:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802973:	8b 50 08             	mov    0x8(%eax),%edx
  802976:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802979:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  80297c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80297f:	8b 55 08             	mov    0x8(%ebp),%edx
  802982:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802985:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802989:	75 17                	jne    8029a2 <alloc_block_NF+0x30d>
  80298b:	83 ec 04             	sub    $0x4,%esp
  80298e:	68 f8 3f 80 00       	push   $0x803ff8
  802993:	68 04 01 00 00       	push   $0x104
  802998:	68 4f 3f 80 00       	push   $0x803f4f
  80299d:	e8 ee d9 ff ff       	call   800390 <_panic>
  8029a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029a5:	8b 00                	mov    (%eax),%eax
  8029a7:	85 c0                	test   %eax,%eax
  8029a9:	74 10                	je     8029bb <alloc_block_NF+0x326>
  8029ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029ae:	8b 00                	mov    (%eax),%eax
  8029b0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8029b3:	8b 52 04             	mov    0x4(%edx),%edx
  8029b6:	89 50 04             	mov    %edx,0x4(%eax)
  8029b9:	eb 0b                	jmp    8029c6 <alloc_block_NF+0x331>
  8029bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029be:	8b 40 04             	mov    0x4(%eax),%eax
  8029c1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8029c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029c9:	8b 40 04             	mov    0x4(%eax),%eax
  8029cc:	85 c0                	test   %eax,%eax
  8029ce:	74 0f                	je     8029df <alloc_block_NF+0x34a>
  8029d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029d3:	8b 40 04             	mov    0x4(%eax),%eax
  8029d6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8029d9:	8b 12                	mov    (%edx),%edx
  8029db:	89 10                	mov    %edx,(%eax)
  8029dd:	eb 0a                	jmp    8029e9 <alloc_block_NF+0x354>
  8029df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029e2:	8b 00                	mov    (%eax),%eax
  8029e4:	a3 48 51 80 00       	mov    %eax,0x805148
  8029e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029ec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029f5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029fc:	a1 54 51 80 00       	mov    0x805154,%eax
  802a01:	48                   	dec    %eax
  802a02:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802a07:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a0a:	8b 40 08             	mov    0x8(%eax),%eax
  802a0d:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802a12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a15:	8b 50 08             	mov    0x8(%eax),%edx
  802a18:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1b:	01 c2                	add    %eax,%edx
  802a1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a20:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802a23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a26:	8b 40 0c             	mov    0xc(%eax),%eax
  802a29:	2b 45 08             	sub    0x8(%ebp),%eax
  802a2c:	89 c2                	mov    %eax,%edx
  802a2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a31:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802a34:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a37:	e9 24 02 00 00       	jmp    802c60 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a3c:	a1 40 51 80 00       	mov    0x805140,%eax
  802a41:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a44:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a48:	74 07                	je     802a51 <alloc_block_NF+0x3bc>
  802a4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4d:	8b 00                	mov    (%eax),%eax
  802a4f:	eb 05                	jmp    802a56 <alloc_block_NF+0x3c1>
  802a51:	b8 00 00 00 00       	mov    $0x0,%eax
  802a56:	a3 40 51 80 00       	mov    %eax,0x805140
  802a5b:	a1 40 51 80 00       	mov    0x805140,%eax
  802a60:	85 c0                	test   %eax,%eax
  802a62:	0f 85 2b fe ff ff    	jne    802893 <alloc_block_NF+0x1fe>
  802a68:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a6c:	0f 85 21 fe ff ff    	jne    802893 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a72:	a1 38 51 80 00       	mov    0x805138,%eax
  802a77:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a7a:	e9 ae 01 00 00       	jmp    802c2d <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802a7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a82:	8b 50 08             	mov    0x8(%eax),%edx
  802a85:	a1 28 50 80 00       	mov    0x805028,%eax
  802a8a:	39 c2                	cmp    %eax,%edx
  802a8c:	0f 83 93 01 00 00    	jae    802c25 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802a92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a95:	8b 40 0c             	mov    0xc(%eax),%eax
  802a98:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a9b:	0f 82 84 01 00 00    	jb     802c25 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802aa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa4:	8b 40 0c             	mov    0xc(%eax),%eax
  802aa7:	3b 45 08             	cmp    0x8(%ebp),%eax
  802aaa:	0f 85 95 00 00 00    	jne    802b45 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802ab0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ab4:	75 17                	jne    802acd <alloc_block_NF+0x438>
  802ab6:	83 ec 04             	sub    $0x4,%esp
  802ab9:	68 f8 3f 80 00       	push   $0x803ff8
  802abe:	68 14 01 00 00       	push   $0x114
  802ac3:	68 4f 3f 80 00       	push   $0x803f4f
  802ac8:	e8 c3 d8 ff ff       	call   800390 <_panic>
  802acd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad0:	8b 00                	mov    (%eax),%eax
  802ad2:	85 c0                	test   %eax,%eax
  802ad4:	74 10                	je     802ae6 <alloc_block_NF+0x451>
  802ad6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad9:	8b 00                	mov    (%eax),%eax
  802adb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ade:	8b 52 04             	mov    0x4(%edx),%edx
  802ae1:	89 50 04             	mov    %edx,0x4(%eax)
  802ae4:	eb 0b                	jmp    802af1 <alloc_block_NF+0x45c>
  802ae6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae9:	8b 40 04             	mov    0x4(%eax),%eax
  802aec:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802af1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af4:	8b 40 04             	mov    0x4(%eax),%eax
  802af7:	85 c0                	test   %eax,%eax
  802af9:	74 0f                	je     802b0a <alloc_block_NF+0x475>
  802afb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afe:	8b 40 04             	mov    0x4(%eax),%eax
  802b01:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b04:	8b 12                	mov    (%edx),%edx
  802b06:	89 10                	mov    %edx,(%eax)
  802b08:	eb 0a                	jmp    802b14 <alloc_block_NF+0x47f>
  802b0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0d:	8b 00                	mov    (%eax),%eax
  802b0f:	a3 38 51 80 00       	mov    %eax,0x805138
  802b14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b17:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b20:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b27:	a1 44 51 80 00       	mov    0x805144,%eax
  802b2c:	48                   	dec    %eax
  802b2d:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802b32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b35:	8b 40 08             	mov    0x8(%eax),%eax
  802b38:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802b3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b40:	e9 1b 01 00 00       	jmp    802c60 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802b45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b48:	8b 40 0c             	mov    0xc(%eax),%eax
  802b4b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b4e:	0f 86 d1 00 00 00    	jbe    802c25 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b54:	a1 48 51 80 00       	mov    0x805148,%eax
  802b59:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802b5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5f:	8b 50 08             	mov    0x8(%eax),%edx
  802b62:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b65:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802b68:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b6b:	8b 55 08             	mov    0x8(%ebp),%edx
  802b6e:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b71:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b75:	75 17                	jne    802b8e <alloc_block_NF+0x4f9>
  802b77:	83 ec 04             	sub    $0x4,%esp
  802b7a:	68 f8 3f 80 00       	push   $0x803ff8
  802b7f:	68 1c 01 00 00       	push   $0x11c
  802b84:	68 4f 3f 80 00       	push   $0x803f4f
  802b89:	e8 02 d8 ff ff       	call   800390 <_panic>
  802b8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b91:	8b 00                	mov    (%eax),%eax
  802b93:	85 c0                	test   %eax,%eax
  802b95:	74 10                	je     802ba7 <alloc_block_NF+0x512>
  802b97:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b9a:	8b 00                	mov    (%eax),%eax
  802b9c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b9f:	8b 52 04             	mov    0x4(%edx),%edx
  802ba2:	89 50 04             	mov    %edx,0x4(%eax)
  802ba5:	eb 0b                	jmp    802bb2 <alloc_block_NF+0x51d>
  802ba7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802baa:	8b 40 04             	mov    0x4(%eax),%eax
  802bad:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802bb2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bb5:	8b 40 04             	mov    0x4(%eax),%eax
  802bb8:	85 c0                	test   %eax,%eax
  802bba:	74 0f                	je     802bcb <alloc_block_NF+0x536>
  802bbc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bbf:	8b 40 04             	mov    0x4(%eax),%eax
  802bc2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802bc5:	8b 12                	mov    (%edx),%edx
  802bc7:	89 10                	mov    %edx,(%eax)
  802bc9:	eb 0a                	jmp    802bd5 <alloc_block_NF+0x540>
  802bcb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bce:	8b 00                	mov    (%eax),%eax
  802bd0:	a3 48 51 80 00       	mov    %eax,0x805148
  802bd5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bd8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bde:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802be1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802be8:	a1 54 51 80 00       	mov    0x805154,%eax
  802bed:	48                   	dec    %eax
  802bee:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802bf3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bf6:	8b 40 08             	mov    0x8(%eax),%eax
  802bf9:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802bfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c01:	8b 50 08             	mov    0x8(%eax),%edx
  802c04:	8b 45 08             	mov    0x8(%ebp),%eax
  802c07:	01 c2                	add    %eax,%edx
  802c09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0c:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802c0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c12:	8b 40 0c             	mov    0xc(%eax),%eax
  802c15:	2b 45 08             	sub    0x8(%ebp),%eax
  802c18:	89 c2                	mov    %eax,%edx
  802c1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1d:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802c20:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c23:	eb 3b                	jmp    802c60 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c25:	a1 40 51 80 00       	mov    0x805140,%eax
  802c2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c2d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c31:	74 07                	je     802c3a <alloc_block_NF+0x5a5>
  802c33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c36:	8b 00                	mov    (%eax),%eax
  802c38:	eb 05                	jmp    802c3f <alloc_block_NF+0x5aa>
  802c3a:	b8 00 00 00 00       	mov    $0x0,%eax
  802c3f:	a3 40 51 80 00       	mov    %eax,0x805140
  802c44:	a1 40 51 80 00       	mov    0x805140,%eax
  802c49:	85 c0                	test   %eax,%eax
  802c4b:	0f 85 2e fe ff ff    	jne    802a7f <alloc_block_NF+0x3ea>
  802c51:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c55:	0f 85 24 fe ff ff    	jne    802a7f <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802c5b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c60:	c9                   	leave  
  802c61:	c3                   	ret    

00802c62 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802c62:	55                   	push   %ebp
  802c63:	89 e5                	mov    %esp,%ebp
  802c65:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802c68:	a1 38 51 80 00       	mov    0x805138,%eax
  802c6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802c70:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802c75:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802c78:	a1 38 51 80 00       	mov    0x805138,%eax
  802c7d:	85 c0                	test   %eax,%eax
  802c7f:	74 14                	je     802c95 <insert_sorted_with_merge_freeList+0x33>
  802c81:	8b 45 08             	mov    0x8(%ebp),%eax
  802c84:	8b 50 08             	mov    0x8(%eax),%edx
  802c87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c8a:	8b 40 08             	mov    0x8(%eax),%eax
  802c8d:	39 c2                	cmp    %eax,%edx
  802c8f:	0f 87 9b 01 00 00    	ja     802e30 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802c95:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c99:	75 17                	jne    802cb2 <insert_sorted_with_merge_freeList+0x50>
  802c9b:	83 ec 04             	sub    $0x4,%esp
  802c9e:	68 2c 3f 80 00       	push   $0x803f2c
  802ca3:	68 38 01 00 00       	push   $0x138
  802ca8:	68 4f 3f 80 00       	push   $0x803f4f
  802cad:	e8 de d6 ff ff       	call   800390 <_panic>
  802cb2:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbb:	89 10                	mov    %edx,(%eax)
  802cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc0:	8b 00                	mov    (%eax),%eax
  802cc2:	85 c0                	test   %eax,%eax
  802cc4:	74 0d                	je     802cd3 <insert_sorted_with_merge_freeList+0x71>
  802cc6:	a1 38 51 80 00       	mov    0x805138,%eax
  802ccb:	8b 55 08             	mov    0x8(%ebp),%edx
  802cce:	89 50 04             	mov    %edx,0x4(%eax)
  802cd1:	eb 08                	jmp    802cdb <insert_sorted_with_merge_freeList+0x79>
  802cd3:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cde:	a3 38 51 80 00       	mov    %eax,0x805138
  802ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ced:	a1 44 51 80 00       	mov    0x805144,%eax
  802cf2:	40                   	inc    %eax
  802cf3:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802cf8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cfc:	0f 84 a8 06 00 00    	je     8033aa <insert_sorted_with_merge_freeList+0x748>
  802d02:	8b 45 08             	mov    0x8(%ebp),%eax
  802d05:	8b 50 08             	mov    0x8(%eax),%edx
  802d08:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0b:	8b 40 0c             	mov    0xc(%eax),%eax
  802d0e:	01 c2                	add    %eax,%edx
  802d10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d13:	8b 40 08             	mov    0x8(%eax),%eax
  802d16:	39 c2                	cmp    %eax,%edx
  802d18:	0f 85 8c 06 00 00    	jne    8033aa <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d21:	8b 50 0c             	mov    0xc(%eax),%edx
  802d24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d27:	8b 40 0c             	mov    0xc(%eax),%eax
  802d2a:	01 c2                	add    %eax,%edx
  802d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2f:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802d32:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d36:	75 17                	jne    802d4f <insert_sorted_with_merge_freeList+0xed>
  802d38:	83 ec 04             	sub    $0x4,%esp
  802d3b:	68 f8 3f 80 00       	push   $0x803ff8
  802d40:	68 3c 01 00 00       	push   $0x13c
  802d45:	68 4f 3f 80 00       	push   $0x803f4f
  802d4a:	e8 41 d6 ff ff       	call   800390 <_panic>
  802d4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d52:	8b 00                	mov    (%eax),%eax
  802d54:	85 c0                	test   %eax,%eax
  802d56:	74 10                	je     802d68 <insert_sorted_with_merge_freeList+0x106>
  802d58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d5b:	8b 00                	mov    (%eax),%eax
  802d5d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d60:	8b 52 04             	mov    0x4(%edx),%edx
  802d63:	89 50 04             	mov    %edx,0x4(%eax)
  802d66:	eb 0b                	jmp    802d73 <insert_sorted_with_merge_freeList+0x111>
  802d68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d6b:	8b 40 04             	mov    0x4(%eax),%eax
  802d6e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d76:	8b 40 04             	mov    0x4(%eax),%eax
  802d79:	85 c0                	test   %eax,%eax
  802d7b:	74 0f                	je     802d8c <insert_sorted_with_merge_freeList+0x12a>
  802d7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d80:	8b 40 04             	mov    0x4(%eax),%eax
  802d83:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d86:	8b 12                	mov    (%edx),%edx
  802d88:	89 10                	mov    %edx,(%eax)
  802d8a:	eb 0a                	jmp    802d96 <insert_sorted_with_merge_freeList+0x134>
  802d8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d8f:	8b 00                	mov    (%eax),%eax
  802d91:	a3 38 51 80 00       	mov    %eax,0x805138
  802d96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d99:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802da9:	a1 44 51 80 00       	mov    0x805144,%eax
  802dae:	48                   	dec    %eax
  802daf:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802db4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802db7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802dbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802dc8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802dcc:	75 17                	jne    802de5 <insert_sorted_with_merge_freeList+0x183>
  802dce:	83 ec 04             	sub    $0x4,%esp
  802dd1:	68 2c 3f 80 00       	push   $0x803f2c
  802dd6:	68 3f 01 00 00       	push   $0x13f
  802ddb:	68 4f 3f 80 00       	push   $0x803f4f
  802de0:	e8 ab d5 ff ff       	call   800390 <_panic>
  802de5:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802deb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dee:	89 10                	mov    %edx,(%eax)
  802df0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df3:	8b 00                	mov    (%eax),%eax
  802df5:	85 c0                	test   %eax,%eax
  802df7:	74 0d                	je     802e06 <insert_sorted_with_merge_freeList+0x1a4>
  802df9:	a1 48 51 80 00       	mov    0x805148,%eax
  802dfe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e01:	89 50 04             	mov    %edx,0x4(%eax)
  802e04:	eb 08                	jmp    802e0e <insert_sorted_with_merge_freeList+0x1ac>
  802e06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e09:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e11:	a3 48 51 80 00       	mov    %eax,0x805148
  802e16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e19:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e20:	a1 54 51 80 00       	mov    0x805154,%eax
  802e25:	40                   	inc    %eax
  802e26:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802e2b:	e9 7a 05 00 00       	jmp    8033aa <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802e30:	8b 45 08             	mov    0x8(%ebp),%eax
  802e33:	8b 50 08             	mov    0x8(%eax),%edx
  802e36:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e39:	8b 40 08             	mov    0x8(%eax),%eax
  802e3c:	39 c2                	cmp    %eax,%edx
  802e3e:	0f 82 14 01 00 00    	jb     802f58 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802e44:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e47:	8b 50 08             	mov    0x8(%eax),%edx
  802e4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e4d:	8b 40 0c             	mov    0xc(%eax),%eax
  802e50:	01 c2                	add    %eax,%edx
  802e52:	8b 45 08             	mov    0x8(%ebp),%eax
  802e55:	8b 40 08             	mov    0x8(%eax),%eax
  802e58:	39 c2                	cmp    %eax,%edx
  802e5a:	0f 85 90 00 00 00    	jne    802ef0 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802e60:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e63:	8b 50 0c             	mov    0xc(%eax),%edx
  802e66:	8b 45 08             	mov    0x8(%ebp),%eax
  802e69:	8b 40 0c             	mov    0xc(%eax),%eax
  802e6c:	01 c2                	add    %eax,%edx
  802e6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e71:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802e74:	8b 45 08             	mov    0x8(%ebp),%eax
  802e77:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802e7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e81:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802e88:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e8c:	75 17                	jne    802ea5 <insert_sorted_with_merge_freeList+0x243>
  802e8e:	83 ec 04             	sub    $0x4,%esp
  802e91:	68 2c 3f 80 00       	push   $0x803f2c
  802e96:	68 49 01 00 00       	push   $0x149
  802e9b:	68 4f 3f 80 00       	push   $0x803f4f
  802ea0:	e8 eb d4 ff ff       	call   800390 <_panic>
  802ea5:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802eab:	8b 45 08             	mov    0x8(%ebp),%eax
  802eae:	89 10                	mov    %edx,(%eax)
  802eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb3:	8b 00                	mov    (%eax),%eax
  802eb5:	85 c0                	test   %eax,%eax
  802eb7:	74 0d                	je     802ec6 <insert_sorted_with_merge_freeList+0x264>
  802eb9:	a1 48 51 80 00       	mov    0x805148,%eax
  802ebe:	8b 55 08             	mov    0x8(%ebp),%edx
  802ec1:	89 50 04             	mov    %edx,0x4(%eax)
  802ec4:	eb 08                	jmp    802ece <insert_sorted_with_merge_freeList+0x26c>
  802ec6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ece:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed1:	a3 48 51 80 00       	mov    %eax,0x805148
  802ed6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ee0:	a1 54 51 80 00       	mov    0x805154,%eax
  802ee5:	40                   	inc    %eax
  802ee6:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802eeb:	e9 bb 04 00 00       	jmp    8033ab <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802ef0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ef4:	75 17                	jne    802f0d <insert_sorted_with_merge_freeList+0x2ab>
  802ef6:	83 ec 04             	sub    $0x4,%esp
  802ef9:	68 a0 3f 80 00       	push   $0x803fa0
  802efe:	68 4c 01 00 00       	push   $0x14c
  802f03:	68 4f 3f 80 00       	push   $0x803f4f
  802f08:	e8 83 d4 ff ff       	call   800390 <_panic>
  802f0d:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802f13:	8b 45 08             	mov    0x8(%ebp),%eax
  802f16:	89 50 04             	mov    %edx,0x4(%eax)
  802f19:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1c:	8b 40 04             	mov    0x4(%eax),%eax
  802f1f:	85 c0                	test   %eax,%eax
  802f21:	74 0c                	je     802f2f <insert_sorted_with_merge_freeList+0x2cd>
  802f23:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f28:	8b 55 08             	mov    0x8(%ebp),%edx
  802f2b:	89 10                	mov    %edx,(%eax)
  802f2d:	eb 08                	jmp    802f37 <insert_sorted_with_merge_freeList+0x2d5>
  802f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f32:	a3 38 51 80 00       	mov    %eax,0x805138
  802f37:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f42:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f48:	a1 44 51 80 00       	mov    0x805144,%eax
  802f4d:	40                   	inc    %eax
  802f4e:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802f53:	e9 53 04 00 00       	jmp    8033ab <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802f58:	a1 38 51 80 00       	mov    0x805138,%eax
  802f5d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f60:	e9 15 04 00 00       	jmp    80337a <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802f65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f68:	8b 00                	mov    (%eax),%eax
  802f6a:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f70:	8b 50 08             	mov    0x8(%eax),%edx
  802f73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f76:	8b 40 08             	mov    0x8(%eax),%eax
  802f79:	39 c2                	cmp    %eax,%edx
  802f7b:	0f 86 f1 03 00 00    	jbe    803372 <insert_sorted_with_merge_freeList+0x710>
  802f81:	8b 45 08             	mov    0x8(%ebp),%eax
  802f84:	8b 50 08             	mov    0x8(%eax),%edx
  802f87:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f8a:	8b 40 08             	mov    0x8(%eax),%eax
  802f8d:	39 c2                	cmp    %eax,%edx
  802f8f:	0f 83 dd 03 00 00    	jae    803372 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802f95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f98:	8b 50 08             	mov    0x8(%eax),%edx
  802f9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f9e:	8b 40 0c             	mov    0xc(%eax),%eax
  802fa1:	01 c2                	add    %eax,%edx
  802fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa6:	8b 40 08             	mov    0x8(%eax),%eax
  802fa9:	39 c2                	cmp    %eax,%edx
  802fab:	0f 85 b9 01 00 00    	jne    80316a <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802fb1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb4:	8b 50 08             	mov    0x8(%eax),%edx
  802fb7:	8b 45 08             	mov    0x8(%ebp),%eax
  802fba:	8b 40 0c             	mov    0xc(%eax),%eax
  802fbd:	01 c2                	add    %eax,%edx
  802fbf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fc2:	8b 40 08             	mov    0x8(%eax),%eax
  802fc5:	39 c2                	cmp    %eax,%edx
  802fc7:	0f 85 0d 01 00 00    	jne    8030da <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802fcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd0:	8b 50 0c             	mov    0xc(%eax),%edx
  802fd3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fd6:	8b 40 0c             	mov    0xc(%eax),%eax
  802fd9:	01 c2                	add    %eax,%edx
  802fdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fde:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802fe1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802fe5:	75 17                	jne    802ffe <insert_sorted_with_merge_freeList+0x39c>
  802fe7:	83 ec 04             	sub    $0x4,%esp
  802fea:	68 f8 3f 80 00       	push   $0x803ff8
  802fef:	68 5c 01 00 00       	push   $0x15c
  802ff4:	68 4f 3f 80 00       	push   $0x803f4f
  802ff9:	e8 92 d3 ff ff       	call   800390 <_panic>
  802ffe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803001:	8b 00                	mov    (%eax),%eax
  803003:	85 c0                	test   %eax,%eax
  803005:	74 10                	je     803017 <insert_sorted_with_merge_freeList+0x3b5>
  803007:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80300a:	8b 00                	mov    (%eax),%eax
  80300c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80300f:	8b 52 04             	mov    0x4(%edx),%edx
  803012:	89 50 04             	mov    %edx,0x4(%eax)
  803015:	eb 0b                	jmp    803022 <insert_sorted_with_merge_freeList+0x3c0>
  803017:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80301a:	8b 40 04             	mov    0x4(%eax),%eax
  80301d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803022:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803025:	8b 40 04             	mov    0x4(%eax),%eax
  803028:	85 c0                	test   %eax,%eax
  80302a:	74 0f                	je     80303b <insert_sorted_with_merge_freeList+0x3d9>
  80302c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80302f:	8b 40 04             	mov    0x4(%eax),%eax
  803032:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803035:	8b 12                	mov    (%edx),%edx
  803037:	89 10                	mov    %edx,(%eax)
  803039:	eb 0a                	jmp    803045 <insert_sorted_with_merge_freeList+0x3e3>
  80303b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80303e:	8b 00                	mov    (%eax),%eax
  803040:	a3 38 51 80 00       	mov    %eax,0x805138
  803045:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803048:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80304e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803051:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803058:	a1 44 51 80 00       	mov    0x805144,%eax
  80305d:	48                   	dec    %eax
  80305e:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803063:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803066:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  80306d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803070:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803077:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80307b:	75 17                	jne    803094 <insert_sorted_with_merge_freeList+0x432>
  80307d:	83 ec 04             	sub    $0x4,%esp
  803080:	68 2c 3f 80 00       	push   $0x803f2c
  803085:	68 5f 01 00 00       	push   $0x15f
  80308a:	68 4f 3f 80 00       	push   $0x803f4f
  80308f:	e8 fc d2 ff ff       	call   800390 <_panic>
  803094:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80309a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80309d:	89 10                	mov    %edx,(%eax)
  80309f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030a2:	8b 00                	mov    (%eax),%eax
  8030a4:	85 c0                	test   %eax,%eax
  8030a6:	74 0d                	je     8030b5 <insert_sorted_with_merge_freeList+0x453>
  8030a8:	a1 48 51 80 00       	mov    0x805148,%eax
  8030ad:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030b0:	89 50 04             	mov    %edx,0x4(%eax)
  8030b3:	eb 08                	jmp    8030bd <insert_sorted_with_merge_freeList+0x45b>
  8030b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030b8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030c0:	a3 48 51 80 00       	mov    %eax,0x805148
  8030c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030c8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030cf:	a1 54 51 80 00       	mov    0x805154,%eax
  8030d4:	40                   	inc    %eax
  8030d5:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8030da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030dd:	8b 50 0c             	mov    0xc(%eax),%edx
  8030e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e3:	8b 40 0c             	mov    0xc(%eax),%eax
  8030e6:	01 c2                	add    %eax,%edx
  8030e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030eb:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8030ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8030f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fb:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803102:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803106:	75 17                	jne    80311f <insert_sorted_with_merge_freeList+0x4bd>
  803108:	83 ec 04             	sub    $0x4,%esp
  80310b:	68 2c 3f 80 00       	push   $0x803f2c
  803110:	68 64 01 00 00       	push   $0x164
  803115:	68 4f 3f 80 00       	push   $0x803f4f
  80311a:	e8 71 d2 ff ff       	call   800390 <_panic>
  80311f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803125:	8b 45 08             	mov    0x8(%ebp),%eax
  803128:	89 10                	mov    %edx,(%eax)
  80312a:	8b 45 08             	mov    0x8(%ebp),%eax
  80312d:	8b 00                	mov    (%eax),%eax
  80312f:	85 c0                	test   %eax,%eax
  803131:	74 0d                	je     803140 <insert_sorted_with_merge_freeList+0x4de>
  803133:	a1 48 51 80 00       	mov    0x805148,%eax
  803138:	8b 55 08             	mov    0x8(%ebp),%edx
  80313b:	89 50 04             	mov    %edx,0x4(%eax)
  80313e:	eb 08                	jmp    803148 <insert_sorted_with_merge_freeList+0x4e6>
  803140:	8b 45 08             	mov    0x8(%ebp),%eax
  803143:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803148:	8b 45 08             	mov    0x8(%ebp),%eax
  80314b:	a3 48 51 80 00       	mov    %eax,0x805148
  803150:	8b 45 08             	mov    0x8(%ebp),%eax
  803153:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80315a:	a1 54 51 80 00       	mov    0x805154,%eax
  80315f:	40                   	inc    %eax
  803160:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803165:	e9 41 02 00 00       	jmp    8033ab <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80316a:	8b 45 08             	mov    0x8(%ebp),%eax
  80316d:	8b 50 08             	mov    0x8(%eax),%edx
  803170:	8b 45 08             	mov    0x8(%ebp),%eax
  803173:	8b 40 0c             	mov    0xc(%eax),%eax
  803176:	01 c2                	add    %eax,%edx
  803178:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80317b:	8b 40 08             	mov    0x8(%eax),%eax
  80317e:	39 c2                	cmp    %eax,%edx
  803180:	0f 85 7c 01 00 00    	jne    803302 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803186:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80318a:	74 06                	je     803192 <insert_sorted_with_merge_freeList+0x530>
  80318c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803190:	75 17                	jne    8031a9 <insert_sorted_with_merge_freeList+0x547>
  803192:	83 ec 04             	sub    $0x4,%esp
  803195:	68 68 3f 80 00       	push   $0x803f68
  80319a:	68 69 01 00 00       	push   $0x169
  80319f:	68 4f 3f 80 00       	push   $0x803f4f
  8031a4:	e8 e7 d1 ff ff       	call   800390 <_panic>
  8031a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ac:	8b 50 04             	mov    0x4(%eax),%edx
  8031af:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b2:	89 50 04             	mov    %edx,0x4(%eax)
  8031b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031bb:	89 10                	mov    %edx,(%eax)
  8031bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c0:	8b 40 04             	mov    0x4(%eax),%eax
  8031c3:	85 c0                	test   %eax,%eax
  8031c5:	74 0d                	je     8031d4 <insert_sorted_with_merge_freeList+0x572>
  8031c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ca:	8b 40 04             	mov    0x4(%eax),%eax
  8031cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8031d0:	89 10                	mov    %edx,(%eax)
  8031d2:	eb 08                	jmp    8031dc <insert_sorted_with_merge_freeList+0x57a>
  8031d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d7:	a3 38 51 80 00       	mov    %eax,0x805138
  8031dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031df:	8b 55 08             	mov    0x8(%ebp),%edx
  8031e2:	89 50 04             	mov    %edx,0x4(%eax)
  8031e5:	a1 44 51 80 00       	mov    0x805144,%eax
  8031ea:	40                   	inc    %eax
  8031eb:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8031f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f3:	8b 50 0c             	mov    0xc(%eax),%edx
  8031f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f9:	8b 40 0c             	mov    0xc(%eax),%eax
  8031fc:	01 c2                	add    %eax,%edx
  8031fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803201:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803204:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803208:	75 17                	jne    803221 <insert_sorted_with_merge_freeList+0x5bf>
  80320a:	83 ec 04             	sub    $0x4,%esp
  80320d:	68 f8 3f 80 00       	push   $0x803ff8
  803212:	68 6b 01 00 00       	push   $0x16b
  803217:	68 4f 3f 80 00       	push   $0x803f4f
  80321c:	e8 6f d1 ff ff       	call   800390 <_panic>
  803221:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803224:	8b 00                	mov    (%eax),%eax
  803226:	85 c0                	test   %eax,%eax
  803228:	74 10                	je     80323a <insert_sorted_with_merge_freeList+0x5d8>
  80322a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80322d:	8b 00                	mov    (%eax),%eax
  80322f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803232:	8b 52 04             	mov    0x4(%edx),%edx
  803235:	89 50 04             	mov    %edx,0x4(%eax)
  803238:	eb 0b                	jmp    803245 <insert_sorted_with_merge_freeList+0x5e3>
  80323a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80323d:	8b 40 04             	mov    0x4(%eax),%eax
  803240:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803245:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803248:	8b 40 04             	mov    0x4(%eax),%eax
  80324b:	85 c0                	test   %eax,%eax
  80324d:	74 0f                	je     80325e <insert_sorted_with_merge_freeList+0x5fc>
  80324f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803252:	8b 40 04             	mov    0x4(%eax),%eax
  803255:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803258:	8b 12                	mov    (%edx),%edx
  80325a:	89 10                	mov    %edx,(%eax)
  80325c:	eb 0a                	jmp    803268 <insert_sorted_with_merge_freeList+0x606>
  80325e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803261:	8b 00                	mov    (%eax),%eax
  803263:	a3 38 51 80 00       	mov    %eax,0x805138
  803268:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80326b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803271:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803274:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80327b:	a1 44 51 80 00       	mov    0x805144,%eax
  803280:	48                   	dec    %eax
  803281:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803286:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803289:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803290:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803293:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80329a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80329e:	75 17                	jne    8032b7 <insert_sorted_with_merge_freeList+0x655>
  8032a0:	83 ec 04             	sub    $0x4,%esp
  8032a3:	68 2c 3f 80 00       	push   $0x803f2c
  8032a8:	68 6e 01 00 00       	push   $0x16e
  8032ad:	68 4f 3f 80 00       	push   $0x803f4f
  8032b2:	e8 d9 d0 ff ff       	call   800390 <_panic>
  8032b7:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032c0:	89 10                	mov    %edx,(%eax)
  8032c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032c5:	8b 00                	mov    (%eax),%eax
  8032c7:	85 c0                	test   %eax,%eax
  8032c9:	74 0d                	je     8032d8 <insert_sorted_with_merge_freeList+0x676>
  8032cb:	a1 48 51 80 00       	mov    0x805148,%eax
  8032d0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032d3:	89 50 04             	mov    %edx,0x4(%eax)
  8032d6:	eb 08                	jmp    8032e0 <insert_sorted_with_merge_freeList+0x67e>
  8032d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032db:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032e3:	a3 48 51 80 00       	mov    %eax,0x805148
  8032e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032eb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032f2:	a1 54 51 80 00       	mov    0x805154,%eax
  8032f7:	40                   	inc    %eax
  8032f8:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8032fd:	e9 a9 00 00 00       	jmp    8033ab <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803302:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803306:	74 06                	je     80330e <insert_sorted_with_merge_freeList+0x6ac>
  803308:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80330c:	75 17                	jne    803325 <insert_sorted_with_merge_freeList+0x6c3>
  80330e:	83 ec 04             	sub    $0x4,%esp
  803311:	68 c4 3f 80 00       	push   $0x803fc4
  803316:	68 73 01 00 00       	push   $0x173
  80331b:	68 4f 3f 80 00       	push   $0x803f4f
  803320:	e8 6b d0 ff ff       	call   800390 <_panic>
  803325:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803328:	8b 10                	mov    (%eax),%edx
  80332a:	8b 45 08             	mov    0x8(%ebp),%eax
  80332d:	89 10                	mov    %edx,(%eax)
  80332f:	8b 45 08             	mov    0x8(%ebp),%eax
  803332:	8b 00                	mov    (%eax),%eax
  803334:	85 c0                	test   %eax,%eax
  803336:	74 0b                	je     803343 <insert_sorted_with_merge_freeList+0x6e1>
  803338:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80333b:	8b 00                	mov    (%eax),%eax
  80333d:	8b 55 08             	mov    0x8(%ebp),%edx
  803340:	89 50 04             	mov    %edx,0x4(%eax)
  803343:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803346:	8b 55 08             	mov    0x8(%ebp),%edx
  803349:	89 10                	mov    %edx,(%eax)
  80334b:	8b 45 08             	mov    0x8(%ebp),%eax
  80334e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803351:	89 50 04             	mov    %edx,0x4(%eax)
  803354:	8b 45 08             	mov    0x8(%ebp),%eax
  803357:	8b 00                	mov    (%eax),%eax
  803359:	85 c0                	test   %eax,%eax
  80335b:	75 08                	jne    803365 <insert_sorted_with_merge_freeList+0x703>
  80335d:	8b 45 08             	mov    0x8(%ebp),%eax
  803360:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803365:	a1 44 51 80 00       	mov    0x805144,%eax
  80336a:	40                   	inc    %eax
  80336b:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803370:	eb 39                	jmp    8033ab <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803372:	a1 40 51 80 00       	mov    0x805140,%eax
  803377:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80337a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80337e:	74 07                	je     803387 <insert_sorted_with_merge_freeList+0x725>
  803380:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803383:	8b 00                	mov    (%eax),%eax
  803385:	eb 05                	jmp    80338c <insert_sorted_with_merge_freeList+0x72a>
  803387:	b8 00 00 00 00       	mov    $0x0,%eax
  80338c:	a3 40 51 80 00       	mov    %eax,0x805140
  803391:	a1 40 51 80 00       	mov    0x805140,%eax
  803396:	85 c0                	test   %eax,%eax
  803398:	0f 85 c7 fb ff ff    	jne    802f65 <insert_sorted_with_merge_freeList+0x303>
  80339e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033a2:	0f 85 bd fb ff ff    	jne    802f65 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8033a8:	eb 01                	jmp    8033ab <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8033aa:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8033ab:	90                   	nop
  8033ac:	c9                   	leave  
  8033ad:	c3                   	ret    
  8033ae:	66 90                	xchg   %ax,%ax

008033b0 <__udivdi3>:
  8033b0:	55                   	push   %ebp
  8033b1:	57                   	push   %edi
  8033b2:	56                   	push   %esi
  8033b3:	53                   	push   %ebx
  8033b4:	83 ec 1c             	sub    $0x1c,%esp
  8033b7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8033bb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8033bf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8033c3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8033c7:	89 ca                	mov    %ecx,%edx
  8033c9:	89 f8                	mov    %edi,%eax
  8033cb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8033cf:	85 f6                	test   %esi,%esi
  8033d1:	75 2d                	jne    803400 <__udivdi3+0x50>
  8033d3:	39 cf                	cmp    %ecx,%edi
  8033d5:	77 65                	ja     80343c <__udivdi3+0x8c>
  8033d7:	89 fd                	mov    %edi,%ebp
  8033d9:	85 ff                	test   %edi,%edi
  8033db:	75 0b                	jne    8033e8 <__udivdi3+0x38>
  8033dd:	b8 01 00 00 00       	mov    $0x1,%eax
  8033e2:	31 d2                	xor    %edx,%edx
  8033e4:	f7 f7                	div    %edi
  8033e6:	89 c5                	mov    %eax,%ebp
  8033e8:	31 d2                	xor    %edx,%edx
  8033ea:	89 c8                	mov    %ecx,%eax
  8033ec:	f7 f5                	div    %ebp
  8033ee:	89 c1                	mov    %eax,%ecx
  8033f0:	89 d8                	mov    %ebx,%eax
  8033f2:	f7 f5                	div    %ebp
  8033f4:	89 cf                	mov    %ecx,%edi
  8033f6:	89 fa                	mov    %edi,%edx
  8033f8:	83 c4 1c             	add    $0x1c,%esp
  8033fb:	5b                   	pop    %ebx
  8033fc:	5e                   	pop    %esi
  8033fd:	5f                   	pop    %edi
  8033fe:	5d                   	pop    %ebp
  8033ff:	c3                   	ret    
  803400:	39 ce                	cmp    %ecx,%esi
  803402:	77 28                	ja     80342c <__udivdi3+0x7c>
  803404:	0f bd fe             	bsr    %esi,%edi
  803407:	83 f7 1f             	xor    $0x1f,%edi
  80340a:	75 40                	jne    80344c <__udivdi3+0x9c>
  80340c:	39 ce                	cmp    %ecx,%esi
  80340e:	72 0a                	jb     80341a <__udivdi3+0x6a>
  803410:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803414:	0f 87 9e 00 00 00    	ja     8034b8 <__udivdi3+0x108>
  80341a:	b8 01 00 00 00       	mov    $0x1,%eax
  80341f:	89 fa                	mov    %edi,%edx
  803421:	83 c4 1c             	add    $0x1c,%esp
  803424:	5b                   	pop    %ebx
  803425:	5e                   	pop    %esi
  803426:	5f                   	pop    %edi
  803427:	5d                   	pop    %ebp
  803428:	c3                   	ret    
  803429:	8d 76 00             	lea    0x0(%esi),%esi
  80342c:	31 ff                	xor    %edi,%edi
  80342e:	31 c0                	xor    %eax,%eax
  803430:	89 fa                	mov    %edi,%edx
  803432:	83 c4 1c             	add    $0x1c,%esp
  803435:	5b                   	pop    %ebx
  803436:	5e                   	pop    %esi
  803437:	5f                   	pop    %edi
  803438:	5d                   	pop    %ebp
  803439:	c3                   	ret    
  80343a:	66 90                	xchg   %ax,%ax
  80343c:	89 d8                	mov    %ebx,%eax
  80343e:	f7 f7                	div    %edi
  803440:	31 ff                	xor    %edi,%edi
  803442:	89 fa                	mov    %edi,%edx
  803444:	83 c4 1c             	add    $0x1c,%esp
  803447:	5b                   	pop    %ebx
  803448:	5e                   	pop    %esi
  803449:	5f                   	pop    %edi
  80344a:	5d                   	pop    %ebp
  80344b:	c3                   	ret    
  80344c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803451:	89 eb                	mov    %ebp,%ebx
  803453:	29 fb                	sub    %edi,%ebx
  803455:	89 f9                	mov    %edi,%ecx
  803457:	d3 e6                	shl    %cl,%esi
  803459:	89 c5                	mov    %eax,%ebp
  80345b:	88 d9                	mov    %bl,%cl
  80345d:	d3 ed                	shr    %cl,%ebp
  80345f:	89 e9                	mov    %ebp,%ecx
  803461:	09 f1                	or     %esi,%ecx
  803463:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803467:	89 f9                	mov    %edi,%ecx
  803469:	d3 e0                	shl    %cl,%eax
  80346b:	89 c5                	mov    %eax,%ebp
  80346d:	89 d6                	mov    %edx,%esi
  80346f:	88 d9                	mov    %bl,%cl
  803471:	d3 ee                	shr    %cl,%esi
  803473:	89 f9                	mov    %edi,%ecx
  803475:	d3 e2                	shl    %cl,%edx
  803477:	8b 44 24 08          	mov    0x8(%esp),%eax
  80347b:	88 d9                	mov    %bl,%cl
  80347d:	d3 e8                	shr    %cl,%eax
  80347f:	09 c2                	or     %eax,%edx
  803481:	89 d0                	mov    %edx,%eax
  803483:	89 f2                	mov    %esi,%edx
  803485:	f7 74 24 0c          	divl   0xc(%esp)
  803489:	89 d6                	mov    %edx,%esi
  80348b:	89 c3                	mov    %eax,%ebx
  80348d:	f7 e5                	mul    %ebp
  80348f:	39 d6                	cmp    %edx,%esi
  803491:	72 19                	jb     8034ac <__udivdi3+0xfc>
  803493:	74 0b                	je     8034a0 <__udivdi3+0xf0>
  803495:	89 d8                	mov    %ebx,%eax
  803497:	31 ff                	xor    %edi,%edi
  803499:	e9 58 ff ff ff       	jmp    8033f6 <__udivdi3+0x46>
  80349e:	66 90                	xchg   %ax,%ax
  8034a0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8034a4:	89 f9                	mov    %edi,%ecx
  8034a6:	d3 e2                	shl    %cl,%edx
  8034a8:	39 c2                	cmp    %eax,%edx
  8034aa:	73 e9                	jae    803495 <__udivdi3+0xe5>
  8034ac:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8034af:	31 ff                	xor    %edi,%edi
  8034b1:	e9 40 ff ff ff       	jmp    8033f6 <__udivdi3+0x46>
  8034b6:	66 90                	xchg   %ax,%ax
  8034b8:	31 c0                	xor    %eax,%eax
  8034ba:	e9 37 ff ff ff       	jmp    8033f6 <__udivdi3+0x46>
  8034bf:	90                   	nop

008034c0 <__umoddi3>:
  8034c0:	55                   	push   %ebp
  8034c1:	57                   	push   %edi
  8034c2:	56                   	push   %esi
  8034c3:	53                   	push   %ebx
  8034c4:	83 ec 1c             	sub    $0x1c,%esp
  8034c7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8034cb:	8b 74 24 34          	mov    0x34(%esp),%esi
  8034cf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8034d3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8034d7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8034db:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8034df:	89 f3                	mov    %esi,%ebx
  8034e1:	89 fa                	mov    %edi,%edx
  8034e3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8034e7:	89 34 24             	mov    %esi,(%esp)
  8034ea:	85 c0                	test   %eax,%eax
  8034ec:	75 1a                	jne    803508 <__umoddi3+0x48>
  8034ee:	39 f7                	cmp    %esi,%edi
  8034f0:	0f 86 a2 00 00 00    	jbe    803598 <__umoddi3+0xd8>
  8034f6:	89 c8                	mov    %ecx,%eax
  8034f8:	89 f2                	mov    %esi,%edx
  8034fa:	f7 f7                	div    %edi
  8034fc:	89 d0                	mov    %edx,%eax
  8034fe:	31 d2                	xor    %edx,%edx
  803500:	83 c4 1c             	add    $0x1c,%esp
  803503:	5b                   	pop    %ebx
  803504:	5e                   	pop    %esi
  803505:	5f                   	pop    %edi
  803506:	5d                   	pop    %ebp
  803507:	c3                   	ret    
  803508:	39 f0                	cmp    %esi,%eax
  80350a:	0f 87 ac 00 00 00    	ja     8035bc <__umoddi3+0xfc>
  803510:	0f bd e8             	bsr    %eax,%ebp
  803513:	83 f5 1f             	xor    $0x1f,%ebp
  803516:	0f 84 ac 00 00 00    	je     8035c8 <__umoddi3+0x108>
  80351c:	bf 20 00 00 00       	mov    $0x20,%edi
  803521:	29 ef                	sub    %ebp,%edi
  803523:	89 fe                	mov    %edi,%esi
  803525:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803529:	89 e9                	mov    %ebp,%ecx
  80352b:	d3 e0                	shl    %cl,%eax
  80352d:	89 d7                	mov    %edx,%edi
  80352f:	89 f1                	mov    %esi,%ecx
  803531:	d3 ef                	shr    %cl,%edi
  803533:	09 c7                	or     %eax,%edi
  803535:	89 e9                	mov    %ebp,%ecx
  803537:	d3 e2                	shl    %cl,%edx
  803539:	89 14 24             	mov    %edx,(%esp)
  80353c:	89 d8                	mov    %ebx,%eax
  80353e:	d3 e0                	shl    %cl,%eax
  803540:	89 c2                	mov    %eax,%edx
  803542:	8b 44 24 08          	mov    0x8(%esp),%eax
  803546:	d3 e0                	shl    %cl,%eax
  803548:	89 44 24 04          	mov    %eax,0x4(%esp)
  80354c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803550:	89 f1                	mov    %esi,%ecx
  803552:	d3 e8                	shr    %cl,%eax
  803554:	09 d0                	or     %edx,%eax
  803556:	d3 eb                	shr    %cl,%ebx
  803558:	89 da                	mov    %ebx,%edx
  80355a:	f7 f7                	div    %edi
  80355c:	89 d3                	mov    %edx,%ebx
  80355e:	f7 24 24             	mull   (%esp)
  803561:	89 c6                	mov    %eax,%esi
  803563:	89 d1                	mov    %edx,%ecx
  803565:	39 d3                	cmp    %edx,%ebx
  803567:	0f 82 87 00 00 00    	jb     8035f4 <__umoddi3+0x134>
  80356d:	0f 84 91 00 00 00    	je     803604 <__umoddi3+0x144>
  803573:	8b 54 24 04          	mov    0x4(%esp),%edx
  803577:	29 f2                	sub    %esi,%edx
  803579:	19 cb                	sbb    %ecx,%ebx
  80357b:	89 d8                	mov    %ebx,%eax
  80357d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803581:	d3 e0                	shl    %cl,%eax
  803583:	89 e9                	mov    %ebp,%ecx
  803585:	d3 ea                	shr    %cl,%edx
  803587:	09 d0                	or     %edx,%eax
  803589:	89 e9                	mov    %ebp,%ecx
  80358b:	d3 eb                	shr    %cl,%ebx
  80358d:	89 da                	mov    %ebx,%edx
  80358f:	83 c4 1c             	add    $0x1c,%esp
  803592:	5b                   	pop    %ebx
  803593:	5e                   	pop    %esi
  803594:	5f                   	pop    %edi
  803595:	5d                   	pop    %ebp
  803596:	c3                   	ret    
  803597:	90                   	nop
  803598:	89 fd                	mov    %edi,%ebp
  80359a:	85 ff                	test   %edi,%edi
  80359c:	75 0b                	jne    8035a9 <__umoddi3+0xe9>
  80359e:	b8 01 00 00 00       	mov    $0x1,%eax
  8035a3:	31 d2                	xor    %edx,%edx
  8035a5:	f7 f7                	div    %edi
  8035a7:	89 c5                	mov    %eax,%ebp
  8035a9:	89 f0                	mov    %esi,%eax
  8035ab:	31 d2                	xor    %edx,%edx
  8035ad:	f7 f5                	div    %ebp
  8035af:	89 c8                	mov    %ecx,%eax
  8035b1:	f7 f5                	div    %ebp
  8035b3:	89 d0                	mov    %edx,%eax
  8035b5:	e9 44 ff ff ff       	jmp    8034fe <__umoddi3+0x3e>
  8035ba:	66 90                	xchg   %ax,%ax
  8035bc:	89 c8                	mov    %ecx,%eax
  8035be:	89 f2                	mov    %esi,%edx
  8035c0:	83 c4 1c             	add    $0x1c,%esp
  8035c3:	5b                   	pop    %ebx
  8035c4:	5e                   	pop    %esi
  8035c5:	5f                   	pop    %edi
  8035c6:	5d                   	pop    %ebp
  8035c7:	c3                   	ret    
  8035c8:	3b 04 24             	cmp    (%esp),%eax
  8035cb:	72 06                	jb     8035d3 <__umoddi3+0x113>
  8035cd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8035d1:	77 0f                	ja     8035e2 <__umoddi3+0x122>
  8035d3:	89 f2                	mov    %esi,%edx
  8035d5:	29 f9                	sub    %edi,%ecx
  8035d7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8035db:	89 14 24             	mov    %edx,(%esp)
  8035de:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8035e2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8035e6:	8b 14 24             	mov    (%esp),%edx
  8035e9:	83 c4 1c             	add    $0x1c,%esp
  8035ec:	5b                   	pop    %ebx
  8035ed:	5e                   	pop    %esi
  8035ee:	5f                   	pop    %edi
  8035ef:	5d                   	pop    %ebp
  8035f0:	c3                   	ret    
  8035f1:	8d 76 00             	lea    0x0(%esi),%esi
  8035f4:	2b 04 24             	sub    (%esp),%eax
  8035f7:	19 fa                	sbb    %edi,%edx
  8035f9:	89 d1                	mov    %edx,%ecx
  8035fb:	89 c6                	mov    %eax,%esi
  8035fd:	e9 71 ff ff ff       	jmp    803573 <__umoddi3+0xb3>
  803602:	66 90                	xchg   %ax,%ax
  803604:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803608:	72 ea                	jb     8035f4 <__umoddi3+0x134>
  80360a:	89 d9                	mov    %ebx,%ecx
  80360c:	e9 62 ff ff ff       	jmp    803573 <__umoddi3+0xb3>
