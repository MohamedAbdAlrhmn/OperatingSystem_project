
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
  80008d:	68 e0 36 80 00       	push   $0x8036e0
  800092:	6a 13                	push   $0x13
  800094:	68 fc 36 80 00       	push   $0x8036fc
  800099:	e8 f2 02 00 00       	call   800390 <_panic>
	}
	uint32 *x,*y,*z;
	int32 parentenvID = sys_getparentenvid();
  80009e:	e8 f7 1a 00 00       	call   801b9a <sys_getparentenvid>
  8000a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//GET: z then y then x, opposite to creation order (x then y then z)
	//So, addresses here will be different from the OWNER addresses
	sys_disable_interrupt();
  8000a6:	e8 e3 18 00 00       	call   80198e <sys_disable_interrupt>
	int freeFrames = sys_calculate_free_frames() ;
  8000ab:	e8 f1 17 00 00       	call   8018a1 <sys_calculate_free_frames>
  8000b0:	89 45 e8             	mov    %eax,-0x18(%ebp)
	z = sget(parentenvID,"z");
  8000b3:	83 ec 08             	sub    $0x8,%esp
  8000b6:	68 1a 37 80 00       	push   $0x80371a
  8000bb:	ff 75 ec             	pushl  -0x14(%ebp)
  8000be:	e8 3a 16 00 00       	call   8016fd <sget>
  8000c3:	83 c4 10             	add    $0x10,%esp
  8000c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (z != (uint32*)(USER_HEAP_START + 0 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8000c9:	81 7d e4 00 00 00 80 	cmpl   $0x80000000,-0x1c(%ebp)
  8000d0:	74 14                	je     8000e6 <_main+0xae>
  8000d2:	83 ec 04             	sub    $0x4,%esp
  8000d5:	68 1c 37 80 00       	push   $0x80371c
  8000da:	6a 1c                	push   $0x1c
  8000dc:	68 fc 36 80 00       	push   $0x8036fc
  8000e1:	e8 aa 02 00 00       	call   800390 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  8000e6:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000e9:	e8 b3 17 00 00       	call   8018a1 <sys_calculate_free_frames>
  8000ee:	29 c3                	sub    %eax,%ebx
  8000f0:	89 d8                	mov    %ebx,%eax
  8000f2:	83 f8 01             	cmp    $0x1,%eax
  8000f5:	74 14                	je     80010b <_main+0xd3>
  8000f7:	83 ec 04             	sub    $0x4,%esp
  8000fa:	68 7c 37 80 00       	push   $0x80377c
  8000ff:	6a 1d                	push   $0x1d
  800101:	68 fc 36 80 00       	push   $0x8036fc
  800106:	e8 85 02 00 00       	call   800390 <_panic>
	sys_enable_interrupt();
  80010b:	e8 98 18 00 00       	call   8019a8 <sys_enable_interrupt>

	sys_disable_interrupt();
  800110:	e8 79 18 00 00       	call   80198e <sys_disable_interrupt>
	freeFrames = sys_calculate_free_frames() ;
  800115:	e8 87 17 00 00       	call   8018a1 <sys_calculate_free_frames>
  80011a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	y = sget(parentenvID,"y");
  80011d:	83 ec 08             	sub    $0x8,%esp
  800120:	68 0d 38 80 00       	push   $0x80380d
  800125:	ff 75 ec             	pushl  -0x14(%ebp)
  800128:	e8 d0 15 00 00       	call   8016fd <sget>
  80012d:	83 c4 10             	add    $0x10,%esp
  800130:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (y != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  800133:	81 7d e0 00 10 00 80 	cmpl   $0x80001000,-0x20(%ebp)
  80013a:	74 14                	je     800150 <_main+0x118>
  80013c:	83 ec 04             	sub    $0x4,%esp
  80013f:	68 1c 37 80 00       	push   $0x80371c
  800144:	6a 23                	push   $0x23
  800146:	68 fc 36 80 00       	push   $0x8036fc
  80014b:	e8 40 02 00 00       	call   800390 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  800150:	e8 4c 17 00 00       	call   8018a1 <sys_calculate_free_frames>
  800155:	89 c2                	mov    %eax,%edx
  800157:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80015a:	39 c2                	cmp    %eax,%edx
  80015c:	74 14                	je     800172 <_main+0x13a>
  80015e:	83 ec 04             	sub    $0x4,%esp
  800161:	68 7c 37 80 00       	push   $0x80377c
  800166:	6a 24                	push   $0x24
  800168:	68 fc 36 80 00       	push   $0x8036fc
  80016d:	e8 1e 02 00 00       	call   800390 <_panic>
	sys_enable_interrupt();
  800172:	e8 31 18 00 00       	call   8019a8 <sys_enable_interrupt>
	
	if (*y != 20) panic("Get(): Shared Variable is not created or got correctly") ;
  800177:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80017a:	8b 00                	mov    (%eax),%eax
  80017c:	83 f8 14             	cmp    $0x14,%eax
  80017f:	74 14                	je     800195 <_main+0x15d>
  800181:	83 ec 04             	sub    $0x4,%esp
  800184:	68 10 38 80 00       	push   $0x803810
  800189:	6a 27                	push   $0x27
  80018b:	68 fc 36 80 00       	push   $0x8036fc
  800190:	e8 fb 01 00 00       	call   800390 <_panic>

	sys_disable_interrupt();
  800195:	e8 f4 17 00 00       	call   80198e <sys_disable_interrupt>
	freeFrames = sys_calculate_free_frames() ;
  80019a:	e8 02 17 00 00       	call   8018a1 <sys_calculate_free_frames>
  80019f:	89 45 e8             	mov    %eax,-0x18(%ebp)
	x = sget(parentenvID,"x");
  8001a2:	83 ec 08             	sub    $0x8,%esp
  8001a5:	68 47 38 80 00       	push   $0x803847
  8001aa:	ff 75 ec             	pushl  -0x14(%ebp)
  8001ad:	e8 4b 15 00 00       	call   8016fd <sget>
  8001b2:	83 c4 10             	add    $0x10,%esp
  8001b5:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (x != (uint32*)(USER_HEAP_START + 2 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8001b8:	81 7d dc 00 20 00 80 	cmpl   $0x80002000,-0x24(%ebp)
  8001bf:	74 14                	je     8001d5 <_main+0x19d>
  8001c1:	83 ec 04             	sub    $0x4,%esp
  8001c4:	68 1c 37 80 00       	push   $0x80371c
  8001c9:	6a 2c                	push   $0x2c
  8001cb:	68 fc 36 80 00       	push   $0x8036fc
  8001d0:	e8 bb 01 00 00       	call   800390 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  8001d5:	e8 c7 16 00 00       	call   8018a1 <sys_calculate_free_frames>
  8001da:	89 c2                	mov    %eax,%edx
  8001dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001df:	39 c2                	cmp    %eax,%edx
  8001e1:	74 14                	je     8001f7 <_main+0x1bf>
  8001e3:	83 ec 04             	sub    $0x4,%esp
  8001e6:	68 7c 37 80 00       	push   $0x80377c
  8001eb:	6a 2d                	push   $0x2d
  8001ed:	68 fc 36 80 00       	push   $0x8036fc
  8001f2:	e8 99 01 00 00       	call   800390 <_panic>
	sys_enable_interrupt();
  8001f7:	e8 ac 17 00 00       	call   8019a8 <sys_enable_interrupt>

	if (*x != 10) panic("Get(): Shared Variable is not created or got correctly") ;
  8001fc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001ff:	8b 00                	mov    (%eax),%eax
  800201:	83 f8 0a             	cmp    $0xa,%eax
  800204:	74 14                	je     80021a <_main+0x1e2>
  800206:	83 ec 04             	sub    $0x4,%esp
  800209:	68 10 38 80 00       	push   $0x803810
  80020e:	6a 30                	push   $0x30
  800210:	68 fc 36 80 00       	push   $0x8036fc
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
  800238:	68 10 38 80 00       	push   $0x803810
  80023d:	6a 33                	push   $0x33
  80023f:	68 fc 36 80 00       	push   $0x8036fc
  800244:	e8 47 01 00 00       	call   800390 <_panic>

	//To indicate that it's completed successfully
	inctst();
  800249:	e8 71 1a 00 00       	call   801cbf <inctst>

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
  80025a:	e8 22 19 00 00       	call   801b81 <sys_getenvindex>
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
  8002c5:	e8 c4 16 00 00       	call   80198e <sys_disable_interrupt>
	cprintf("**************************************\n");
  8002ca:	83 ec 0c             	sub    $0xc,%esp
  8002cd:	68 64 38 80 00       	push   $0x803864
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
  8002f5:	68 8c 38 80 00       	push   $0x80388c
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
  800326:	68 b4 38 80 00       	push   $0x8038b4
  80032b:	e8 14 03 00 00       	call   800644 <cprintf>
  800330:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800333:	a1 20 50 80 00       	mov    0x805020,%eax
  800338:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80033e:	83 ec 08             	sub    $0x8,%esp
  800341:	50                   	push   %eax
  800342:	68 0c 39 80 00       	push   $0x80390c
  800347:	e8 f8 02 00 00       	call   800644 <cprintf>
  80034c:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80034f:	83 ec 0c             	sub    $0xc,%esp
  800352:	68 64 38 80 00       	push   $0x803864
  800357:	e8 e8 02 00 00       	call   800644 <cprintf>
  80035c:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80035f:	e8 44 16 00 00       	call   8019a8 <sys_enable_interrupt>

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
  800377:	e8 d1 17 00 00       	call   801b4d <sys_destroy_env>
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
  800388:	e8 26 18 00 00       	call   801bb3 <sys_exit_env>
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
  8003b1:	68 20 39 80 00       	push   $0x803920
  8003b6:	e8 89 02 00 00       	call   800644 <cprintf>
  8003bb:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8003be:	a1 00 50 80 00       	mov    0x805000,%eax
  8003c3:	ff 75 0c             	pushl  0xc(%ebp)
  8003c6:	ff 75 08             	pushl  0x8(%ebp)
  8003c9:	50                   	push   %eax
  8003ca:	68 25 39 80 00       	push   $0x803925
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
  8003ee:	68 41 39 80 00       	push   $0x803941
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
  80041a:	68 44 39 80 00       	push   $0x803944
  80041f:	6a 26                	push   $0x26
  800421:	68 90 39 80 00       	push   $0x803990
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
  8004ec:	68 9c 39 80 00       	push   $0x80399c
  8004f1:	6a 3a                	push   $0x3a
  8004f3:	68 90 39 80 00       	push   $0x803990
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
  80055c:	68 f0 39 80 00       	push   $0x8039f0
  800561:	6a 44                	push   $0x44
  800563:	68 90 39 80 00       	push   $0x803990
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
  8005b6:	e8 25 12 00 00       	call   8017e0 <sys_cputs>
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
  80062d:	e8 ae 11 00 00       	call   8017e0 <sys_cputs>
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
  800677:	e8 12 13 00 00       	call   80198e <sys_disable_interrupt>
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
  800697:	e8 0c 13 00 00       	call   8019a8 <sys_enable_interrupt>
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
  8006e1:	e8 7e 2d 00 00       	call   803464 <__udivdi3>
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
  800731:	e8 3e 2e 00 00       	call   803574 <__umoddi3>
  800736:	83 c4 10             	add    $0x10,%esp
  800739:	05 54 3c 80 00       	add    $0x803c54,%eax
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
  80088c:	8b 04 85 78 3c 80 00 	mov    0x803c78(,%eax,4),%eax
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
  80096d:	8b 34 9d c0 3a 80 00 	mov    0x803ac0(,%ebx,4),%esi
  800974:	85 f6                	test   %esi,%esi
  800976:	75 19                	jne    800991 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800978:	53                   	push   %ebx
  800979:	68 65 3c 80 00       	push   $0x803c65
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
  800992:	68 6e 3c 80 00       	push   $0x803c6e
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
  8009bf:	be 71 3c 80 00       	mov    $0x803c71,%esi
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
  8013e5:	68 d0 3d 80 00       	push   $0x803dd0
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
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_USER);
  801498:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  80149f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014a2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014a7:	2d 00 10 00 00       	sub    $0x1000,%eax
  8014ac:	83 ec 04             	sub    $0x4,%esp
  8014af:	6a 06                	push   $0x6
  8014b1:	ff 75 f4             	pushl  -0xc(%ebp)
  8014b4:	50                   	push   %eax
  8014b5:	e8 6a 04 00 00       	call   801924 <sys_allocate_chunk>
  8014ba:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8014bd:	a1 20 51 80 00       	mov    0x805120,%eax
  8014c2:	83 ec 0c             	sub    $0xc,%esp
  8014c5:	50                   	push   %eax
  8014c6:	e8 df 0a 00 00       	call   801faa <initialize_MemBlocksList>
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
  8014f3:	68 f5 3d 80 00       	push   $0x803df5
  8014f8:	6a 33                	push   $0x33
  8014fa:	68 13 3e 80 00       	push   $0x803e13
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
  801572:	68 20 3e 80 00       	push   $0x803e20
  801577:	6a 34                	push   $0x34
  801579:	68 13 3e 80 00       	push   $0x803e13
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
  8015cf:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015d2:	e8 f7 fd ff ff       	call   8013ce <InitializeUHeap>
	if (size == 0) return NULL ;
  8015d7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015db:	75 07                	jne    8015e4 <malloc+0x18>
  8015dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8015e2:	eb 61                	jmp    801645 <malloc+0x79>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
	uint32 malloc_allocsize=ROUNDUP(size,PAGE_SIZE);
  8015e4:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8015eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8015ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015f1:	01 d0                	add    %edx,%eax
  8015f3:	48                   	dec    %eax
  8015f4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8015f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8015ff:	f7 75 f0             	divl   -0x10(%ebp)
  801602:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801605:	29 d0                	sub    %edx,%eax
  801607:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 //int ret=0;
	struct MemBlock * user_block;
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80160a:	e8 e3 06 00 00       	call   801cf2 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80160f:	85 c0                	test   %eax,%eax
  801611:	74 11                	je     801624 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801613:	83 ec 0c             	sub    $0xc,%esp
  801616:	ff 75 e8             	pushl  -0x18(%ebp)
  801619:	e8 4e 0d 00 00       	call   80236c <alloc_block_FF>
  80161e:	83 c4 10             	add    $0x10,%esp
  801621:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(user_block!=NULL)
  801624:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801628:	74 16                	je     801640 <malloc+0x74>
	{
		//sys_allocate_chunk(user_block->sva,malloc_allocsize,PERM_WRITEABLE| PERM_PRESENT);
		insert_sorted_allocList(user_block);
  80162a:	83 ec 0c             	sub    $0xc,%esp
  80162d:	ff 75 f4             	pushl  -0xc(%ebp)
  801630:	e8 aa 0a 00 00       	call   8020df <insert_sorted_allocList>
  801635:	83 c4 10             	add    $0x10,%esp
		return (uint32 *)user_block->sva;
  801638:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80163b:	8b 40 08             	mov    0x8(%eax),%eax
  80163e:	eb 05                	jmp    801645 <malloc+0x79>
	}

    return NULL;
  801640:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801645:	c9                   	leave  
  801646:	c3                   	ret    

00801647 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801647:	55                   	push   %ebp
  801648:	89 e5                	mov    %esp,%ebp
  80164a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  80164d:	83 ec 04             	sub    $0x4,%esp
  801650:	68 44 3e 80 00       	push   $0x803e44
  801655:	6a 6f                	push   $0x6f
  801657:	68 13 3e 80 00       	push   $0x803e13
  80165c:	e8 2f ed ff ff       	call   800390 <_panic>

00801661 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801661:	55                   	push   %ebp
  801662:	89 e5                	mov    %esp,%ebp
  801664:	83 ec 38             	sub    $0x38,%esp
  801667:	8b 45 10             	mov    0x10(%ebp),%eax
  80166a:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80166d:	e8 5c fd ff ff       	call   8013ce <InitializeUHeap>
	if (size == 0) return NULL ;
  801672:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801676:	75 07                	jne    80167f <smalloc+0x1e>
  801678:	b8 00 00 00 00       	mov    $0x0,%eax
  80167d:	eb 7c                	jmp    8016fb <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  80167f:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801686:	8b 55 0c             	mov    0xc(%ebp),%edx
  801689:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80168c:	01 d0                	add    %edx,%eax
  80168e:	48                   	dec    %eax
  80168f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801692:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801695:	ba 00 00 00 00       	mov    $0x0,%edx
  80169a:	f7 75 f0             	divl   -0x10(%ebp)
  80169d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016a0:	29 d0                	sub    %edx,%eax
  8016a2:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  8016a5:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8016ac:	e8 41 06 00 00       	call   801cf2 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016b1:	85 c0                	test   %eax,%eax
  8016b3:	74 11                	je     8016c6 <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  8016b5:	83 ec 0c             	sub    $0xc,%esp
  8016b8:	ff 75 e8             	pushl  -0x18(%ebp)
  8016bb:	e8 ac 0c 00 00       	call   80236c <alloc_block_FF>
  8016c0:	83 c4 10             	add    $0x10,%esp
  8016c3:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  8016c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8016ca:	74 2a                	je     8016f6 <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8016cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016cf:	8b 40 08             	mov    0x8(%eax),%eax
  8016d2:	89 c2                	mov    %eax,%edx
  8016d4:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8016d8:	52                   	push   %edx
  8016d9:	50                   	push   %eax
  8016da:	ff 75 0c             	pushl  0xc(%ebp)
  8016dd:	ff 75 08             	pushl  0x8(%ebp)
  8016e0:	e8 92 03 00 00       	call   801a77 <sys_createSharedObject>
  8016e5:	83 c4 10             	add    $0x10,%esp
  8016e8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  8016eb:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  8016ef:	74 05                	je     8016f6 <smalloc+0x95>
			return (void*)virtual_address;
  8016f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016f4:	eb 05                	jmp    8016fb <smalloc+0x9a>
	}
	return NULL;
  8016f6:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8016fb:	c9                   	leave  
  8016fc:	c3                   	ret    

008016fd <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8016fd:	55                   	push   %ebp
  8016fe:	89 e5                	mov    %esp,%ebp
  801700:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801703:	e8 c6 fc ff ff       	call   8013ce <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801708:	83 ec 04             	sub    $0x4,%esp
  80170b:	68 68 3e 80 00       	push   $0x803e68
  801710:	68 b0 00 00 00       	push   $0xb0
  801715:	68 13 3e 80 00       	push   $0x803e13
  80171a:	e8 71 ec ff ff       	call   800390 <_panic>

0080171f <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80171f:	55                   	push   %ebp
  801720:	89 e5                	mov    %esp,%ebp
  801722:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801725:	e8 a4 fc ff ff       	call   8013ce <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80172a:	83 ec 04             	sub    $0x4,%esp
  80172d:	68 8c 3e 80 00       	push   $0x803e8c
  801732:	68 f4 00 00 00       	push   $0xf4
  801737:	68 13 3e 80 00       	push   $0x803e13
  80173c:	e8 4f ec ff ff       	call   800390 <_panic>

00801741 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801741:	55                   	push   %ebp
  801742:	89 e5                	mov    %esp,%ebp
  801744:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801747:	83 ec 04             	sub    $0x4,%esp
  80174a:	68 b4 3e 80 00       	push   $0x803eb4
  80174f:	68 08 01 00 00       	push   $0x108
  801754:	68 13 3e 80 00       	push   $0x803e13
  801759:	e8 32 ec ff ff       	call   800390 <_panic>

0080175e <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80175e:	55                   	push   %ebp
  80175f:	89 e5                	mov    %esp,%ebp
  801761:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801764:	83 ec 04             	sub    $0x4,%esp
  801767:	68 d8 3e 80 00       	push   $0x803ed8
  80176c:	68 13 01 00 00       	push   $0x113
  801771:	68 13 3e 80 00       	push   $0x803e13
  801776:	e8 15 ec ff ff       	call   800390 <_panic>

0080177b <shrink>:

}
void shrink(uint32 newSize)
{
  80177b:	55                   	push   %ebp
  80177c:	89 e5                	mov    %esp,%ebp
  80177e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801781:	83 ec 04             	sub    $0x4,%esp
  801784:	68 d8 3e 80 00       	push   $0x803ed8
  801789:	68 18 01 00 00       	push   $0x118
  80178e:	68 13 3e 80 00       	push   $0x803e13
  801793:	e8 f8 eb ff ff       	call   800390 <_panic>

00801798 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801798:	55                   	push   %ebp
  801799:	89 e5                	mov    %esp,%ebp
  80179b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80179e:	83 ec 04             	sub    $0x4,%esp
  8017a1:	68 d8 3e 80 00       	push   $0x803ed8
  8017a6:	68 1d 01 00 00       	push   $0x11d
  8017ab:	68 13 3e 80 00       	push   $0x803e13
  8017b0:	e8 db eb ff ff       	call   800390 <_panic>

008017b5 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8017b5:	55                   	push   %ebp
  8017b6:	89 e5                	mov    %esp,%ebp
  8017b8:	57                   	push   %edi
  8017b9:	56                   	push   %esi
  8017ba:	53                   	push   %ebx
  8017bb:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017be:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017c4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017c7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017ca:	8b 7d 18             	mov    0x18(%ebp),%edi
  8017cd:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8017d0:	cd 30                	int    $0x30
  8017d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8017d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8017d8:	83 c4 10             	add    $0x10,%esp
  8017db:	5b                   	pop    %ebx
  8017dc:	5e                   	pop    %esi
  8017dd:	5f                   	pop    %edi
  8017de:	5d                   	pop    %ebp
  8017df:	c3                   	ret    

008017e0 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8017e0:	55                   	push   %ebp
  8017e1:	89 e5                	mov    %esp,%ebp
  8017e3:	83 ec 04             	sub    $0x4,%esp
  8017e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8017e9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8017ec:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f3:	6a 00                	push   $0x0
  8017f5:	6a 00                	push   $0x0
  8017f7:	52                   	push   %edx
  8017f8:	ff 75 0c             	pushl  0xc(%ebp)
  8017fb:	50                   	push   %eax
  8017fc:	6a 00                	push   $0x0
  8017fe:	e8 b2 ff ff ff       	call   8017b5 <syscall>
  801803:	83 c4 18             	add    $0x18,%esp
}
  801806:	90                   	nop
  801807:	c9                   	leave  
  801808:	c3                   	ret    

00801809 <sys_cgetc>:

int
sys_cgetc(void)
{
  801809:	55                   	push   %ebp
  80180a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80180c:	6a 00                	push   $0x0
  80180e:	6a 00                	push   $0x0
  801810:	6a 00                	push   $0x0
  801812:	6a 00                	push   $0x0
  801814:	6a 00                	push   $0x0
  801816:	6a 01                	push   $0x1
  801818:	e8 98 ff ff ff       	call   8017b5 <syscall>
  80181d:	83 c4 18             	add    $0x18,%esp
}
  801820:	c9                   	leave  
  801821:	c3                   	ret    

00801822 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801822:	55                   	push   %ebp
  801823:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801825:	8b 55 0c             	mov    0xc(%ebp),%edx
  801828:	8b 45 08             	mov    0x8(%ebp),%eax
  80182b:	6a 00                	push   $0x0
  80182d:	6a 00                	push   $0x0
  80182f:	6a 00                	push   $0x0
  801831:	52                   	push   %edx
  801832:	50                   	push   %eax
  801833:	6a 05                	push   $0x5
  801835:	e8 7b ff ff ff       	call   8017b5 <syscall>
  80183a:	83 c4 18             	add    $0x18,%esp
}
  80183d:	c9                   	leave  
  80183e:	c3                   	ret    

0080183f <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80183f:	55                   	push   %ebp
  801840:	89 e5                	mov    %esp,%ebp
  801842:	56                   	push   %esi
  801843:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801844:	8b 75 18             	mov    0x18(%ebp),%esi
  801847:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80184a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80184d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801850:	8b 45 08             	mov    0x8(%ebp),%eax
  801853:	56                   	push   %esi
  801854:	53                   	push   %ebx
  801855:	51                   	push   %ecx
  801856:	52                   	push   %edx
  801857:	50                   	push   %eax
  801858:	6a 06                	push   $0x6
  80185a:	e8 56 ff ff ff       	call   8017b5 <syscall>
  80185f:	83 c4 18             	add    $0x18,%esp
}
  801862:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801865:	5b                   	pop    %ebx
  801866:	5e                   	pop    %esi
  801867:	5d                   	pop    %ebp
  801868:	c3                   	ret    

00801869 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801869:	55                   	push   %ebp
  80186a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80186c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80186f:	8b 45 08             	mov    0x8(%ebp),%eax
  801872:	6a 00                	push   $0x0
  801874:	6a 00                	push   $0x0
  801876:	6a 00                	push   $0x0
  801878:	52                   	push   %edx
  801879:	50                   	push   %eax
  80187a:	6a 07                	push   $0x7
  80187c:	e8 34 ff ff ff       	call   8017b5 <syscall>
  801881:	83 c4 18             	add    $0x18,%esp
}
  801884:	c9                   	leave  
  801885:	c3                   	ret    

00801886 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801886:	55                   	push   %ebp
  801887:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801889:	6a 00                	push   $0x0
  80188b:	6a 00                	push   $0x0
  80188d:	6a 00                	push   $0x0
  80188f:	ff 75 0c             	pushl  0xc(%ebp)
  801892:	ff 75 08             	pushl  0x8(%ebp)
  801895:	6a 08                	push   $0x8
  801897:	e8 19 ff ff ff       	call   8017b5 <syscall>
  80189c:	83 c4 18             	add    $0x18,%esp
}
  80189f:	c9                   	leave  
  8018a0:	c3                   	ret    

008018a1 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8018a1:	55                   	push   %ebp
  8018a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8018a4:	6a 00                	push   $0x0
  8018a6:	6a 00                	push   $0x0
  8018a8:	6a 00                	push   $0x0
  8018aa:	6a 00                	push   $0x0
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 09                	push   $0x9
  8018b0:	e8 00 ff ff ff       	call   8017b5 <syscall>
  8018b5:	83 c4 18             	add    $0x18,%esp
}
  8018b8:	c9                   	leave  
  8018b9:	c3                   	ret    

008018ba <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8018ba:	55                   	push   %ebp
  8018bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8018bd:	6a 00                	push   $0x0
  8018bf:	6a 00                	push   $0x0
  8018c1:	6a 00                	push   $0x0
  8018c3:	6a 00                	push   $0x0
  8018c5:	6a 00                	push   $0x0
  8018c7:	6a 0a                	push   $0xa
  8018c9:	e8 e7 fe ff ff       	call   8017b5 <syscall>
  8018ce:	83 c4 18             	add    $0x18,%esp
}
  8018d1:	c9                   	leave  
  8018d2:	c3                   	ret    

008018d3 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8018d3:	55                   	push   %ebp
  8018d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8018d6:	6a 00                	push   $0x0
  8018d8:	6a 00                	push   $0x0
  8018da:	6a 00                	push   $0x0
  8018dc:	6a 00                	push   $0x0
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 0b                	push   $0xb
  8018e2:	e8 ce fe ff ff       	call   8017b5 <syscall>
  8018e7:	83 c4 18             	add    $0x18,%esp
}
  8018ea:	c9                   	leave  
  8018eb:	c3                   	ret    

008018ec <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8018ec:	55                   	push   %ebp
  8018ed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8018ef:	6a 00                	push   $0x0
  8018f1:	6a 00                	push   $0x0
  8018f3:	6a 00                	push   $0x0
  8018f5:	ff 75 0c             	pushl  0xc(%ebp)
  8018f8:	ff 75 08             	pushl  0x8(%ebp)
  8018fb:	6a 0f                	push   $0xf
  8018fd:	e8 b3 fe ff ff       	call   8017b5 <syscall>
  801902:	83 c4 18             	add    $0x18,%esp
	return;
  801905:	90                   	nop
}
  801906:	c9                   	leave  
  801907:	c3                   	ret    

00801908 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801908:	55                   	push   %ebp
  801909:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80190b:	6a 00                	push   $0x0
  80190d:	6a 00                	push   $0x0
  80190f:	6a 00                	push   $0x0
  801911:	ff 75 0c             	pushl  0xc(%ebp)
  801914:	ff 75 08             	pushl  0x8(%ebp)
  801917:	6a 10                	push   $0x10
  801919:	e8 97 fe ff ff       	call   8017b5 <syscall>
  80191e:	83 c4 18             	add    $0x18,%esp
	return ;
  801921:	90                   	nop
}
  801922:	c9                   	leave  
  801923:	c3                   	ret    

00801924 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801924:	55                   	push   %ebp
  801925:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801927:	6a 00                	push   $0x0
  801929:	6a 00                	push   $0x0
  80192b:	ff 75 10             	pushl  0x10(%ebp)
  80192e:	ff 75 0c             	pushl  0xc(%ebp)
  801931:	ff 75 08             	pushl  0x8(%ebp)
  801934:	6a 11                	push   $0x11
  801936:	e8 7a fe ff ff       	call   8017b5 <syscall>
  80193b:	83 c4 18             	add    $0x18,%esp
	return ;
  80193e:	90                   	nop
}
  80193f:	c9                   	leave  
  801940:	c3                   	ret    

00801941 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801941:	55                   	push   %ebp
  801942:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801944:	6a 00                	push   $0x0
  801946:	6a 00                	push   $0x0
  801948:	6a 00                	push   $0x0
  80194a:	6a 00                	push   $0x0
  80194c:	6a 00                	push   $0x0
  80194e:	6a 0c                	push   $0xc
  801950:	e8 60 fe ff ff       	call   8017b5 <syscall>
  801955:	83 c4 18             	add    $0x18,%esp
}
  801958:	c9                   	leave  
  801959:	c3                   	ret    

0080195a <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80195a:	55                   	push   %ebp
  80195b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80195d:	6a 00                	push   $0x0
  80195f:	6a 00                	push   $0x0
  801961:	6a 00                	push   $0x0
  801963:	6a 00                	push   $0x0
  801965:	ff 75 08             	pushl  0x8(%ebp)
  801968:	6a 0d                	push   $0xd
  80196a:	e8 46 fe ff ff       	call   8017b5 <syscall>
  80196f:	83 c4 18             	add    $0x18,%esp
}
  801972:	c9                   	leave  
  801973:	c3                   	ret    

00801974 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801974:	55                   	push   %ebp
  801975:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801977:	6a 00                	push   $0x0
  801979:	6a 00                	push   $0x0
  80197b:	6a 00                	push   $0x0
  80197d:	6a 00                	push   $0x0
  80197f:	6a 00                	push   $0x0
  801981:	6a 0e                	push   $0xe
  801983:	e8 2d fe ff ff       	call   8017b5 <syscall>
  801988:	83 c4 18             	add    $0x18,%esp
}
  80198b:	90                   	nop
  80198c:	c9                   	leave  
  80198d:	c3                   	ret    

0080198e <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80198e:	55                   	push   %ebp
  80198f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801991:	6a 00                	push   $0x0
  801993:	6a 00                	push   $0x0
  801995:	6a 00                	push   $0x0
  801997:	6a 00                	push   $0x0
  801999:	6a 00                	push   $0x0
  80199b:	6a 13                	push   $0x13
  80199d:	e8 13 fe ff ff       	call   8017b5 <syscall>
  8019a2:	83 c4 18             	add    $0x18,%esp
}
  8019a5:	90                   	nop
  8019a6:	c9                   	leave  
  8019a7:	c3                   	ret    

008019a8 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8019a8:	55                   	push   %ebp
  8019a9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8019ab:	6a 00                	push   $0x0
  8019ad:	6a 00                	push   $0x0
  8019af:	6a 00                	push   $0x0
  8019b1:	6a 00                	push   $0x0
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 14                	push   $0x14
  8019b7:	e8 f9 fd ff ff       	call   8017b5 <syscall>
  8019bc:	83 c4 18             	add    $0x18,%esp
}
  8019bf:	90                   	nop
  8019c0:	c9                   	leave  
  8019c1:	c3                   	ret    

008019c2 <sys_cputc>:


void
sys_cputc(const char c)
{
  8019c2:	55                   	push   %ebp
  8019c3:	89 e5                	mov    %esp,%ebp
  8019c5:	83 ec 04             	sub    $0x4,%esp
  8019c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8019ce:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019d2:	6a 00                	push   $0x0
  8019d4:	6a 00                	push   $0x0
  8019d6:	6a 00                	push   $0x0
  8019d8:	6a 00                	push   $0x0
  8019da:	50                   	push   %eax
  8019db:	6a 15                	push   $0x15
  8019dd:	e8 d3 fd ff ff       	call   8017b5 <syscall>
  8019e2:	83 c4 18             	add    $0x18,%esp
}
  8019e5:	90                   	nop
  8019e6:	c9                   	leave  
  8019e7:	c3                   	ret    

008019e8 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8019e8:	55                   	push   %ebp
  8019e9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 00                	push   $0x0
  8019f5:	6a 16                	push   $0x16
  8019f7:	e8 b9 fd ff ff       	call   8017b5 <syscall>
  8019fc:	83 c4 18             	add    $0x18,%esp
}
  8019ff:	90                   	nop
  801a00:	c9                   	leave  
  801a01:	c3                   	ret    

00801a02 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a02:	55                   	push   %ebp
  801a03:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a05:	8b 45 08             	mov    0x8(%ebp),%eax
  801a08:	6a 00                	push   $0x0
  801a0a:	6a 00                	push   $0x0
  801a0c:	6a 00                	push   $0x0
  801a0e:	ff 75 0c             	pushl  0xc(%ebp)
  801a11:	50                   	push   %eax
  801a12:	6a 17                	push   $0x17
  801a14:	e8 9c fd ff ff       	call   8017b5 <syscall>
  801a19:	83 c4 18             	add    $0x18,%esp
}
  801a1c:	c9                   	leave  
  801a1d:	c3                   	ret    

00801a1e <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a1e:	55                   	push   %ebp
  801a1f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a21:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a24:	8b 45 08             	mov    0x8(%ebp),%eax
  801a27:	6a 00                	push   $0x0
  801a29:	6a 00                	push   $0x0
  801a2b:	6a 00                	push   $0x0
  801a2d:	52                   	push   %edx
  801a2e:	50                   	push   %eax
  801a2f:	6a 1a                	push   $0x1a
  801a31:	e8 7f fd ff ff       	call   8017b5 <syscall>
  801a36:	83 c4 18             	add    $0x18,%esp
}
  801a39:	c9                   	leave  
  801a3a:	c3                   	ret    

00801a3b <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a3b:	55                   	push   %ebp
  801a3c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a3e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a41:	8b 45 08             	mov    0x8(%ebp),%eax
  801a44:	6a 00                	push   $0x0
  801a46:	6a 00                	push   $0x0
  801a48:	6a 00                	push   $0x0
  801a4a:	52                   	push   %edx
  801a4b:	50                   	push   %eax
  801a4c:	6a 18                	push   $0x18
  801a4e:	e8 62 fd ff ff       	call   8017b5 <syscall>
  801a53:	83 c4 18             	add    $0x18,%esp
}
  801a56:	90                   	nop
  801a57:	c9                   	leave  
  801a58:	c3                   	ret    

00801a59 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a59:	55                   	push   %ebp
  801a5a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a5c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a62:	6a 00                	push   $0x0
  801a64:	6a 00                	push   $0x0
  801a66:	6a 00                	push   $0x0
  801a68:	52                   	push   %edx
  801a69:	50                   	push   %eax
  801a6a:	6a 19                	push   $0x19
  801a6c:	e8 44 fd ff ff       	call   8017b5 <syscall>
  801a71:	83 c4 18             	add    $0x18,%esp
}
  801a74:	90                   	nop
  801a75:	c9                   	leave  
  801a76:	c3                   	ret    

00801a77 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a77:	55                   	push   %ebp
  801a78:	89 e5                	mov    %esp,%ebp
  801a7a:	83 ec 04             	sub    $0x4,%esp
  801a7d:	8b 45 10             	mov    0x10(%ebp),%eax
  801a80:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a83:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a86:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8d:	6a 00                	push   $0x0
  801a8f:	51                   	push   %ecx
  801a90:	52                   	push   %edx
  801a91:	ff 75 0c             	pushl  0xc(%ebp)
  801a94:	50                   	push   %eax
  801a95:	6a 1b                	push   $0x1b
  801a97:	e8 19 fd ff ff       	call   8017b5 <syscall>
  801a9c:	83 c4 18             	add    $0x18,%esp
}
  801a9f:	c9                   	leave  
  801aa0:	c3                   	ret    

00801aa1 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801aa1:	55                   	push   %ebp
  801aa2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801aa4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aa7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aaa:	6a 00                	push   $0x0
  801aac:	6a 00                	push   $0x0
  801aae:	6a 00                	push   $0x0
  801ab0:	52                   	push   %edx
  801ab1:	50                   	push   %eax
  801ab2:	6a 1c                	push   $0x1c
  801ab4:	e8 fc fc ff ff       	call   8017b5 <syscall>
  801ab9:	83 c4 18             	add    $0x18,%esp
}
  801abc:	c9                   	leave  
  801abd:	c3                   	ret    

00801abe <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801abe:	55                   	push   %ebp
  801abf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801ac1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ac4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aca:	6a 00                	push   $0x0
  801acc:	6a 00                	push   $0x0
  801ace:	51                   	push   %ecx
  801acf:	52                   	push   %edx
  801ad0:	50                   	push   %eax
  801ad1:	6a 1d                	push   $0x1d
  801ad3:	e8 dd fc ff ff       	call   8017b5 <syscall>
  801ad8:	83 c4 18             	add    $0x18,%esp
}
  801adb:	c9                   	leave  
  801adc:	c3                   	ret    

00801add <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801add:	55                   	push   %ebp
  801ade:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801ae0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae6:	6a 00                	push   $0x0
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 00                	push   $0x0
  801aec:	52                   	push   %edx
  801aed:	50                   	push   %eax
  801aee:	6a 1e                	push   $0x1e
  801af0:	e8 c0 fc ff ff       	call   8017b5 <syscall>
  801af5:	83 c4 18             	add    $0x18,%esp
}
  801af8:	c9                   	leave  
  801af9:	c3                   	ret    

00801afa <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801afa:	55                   	push   %ebp
  801afb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801afd:	6a 00                	push   $0x0
  801aff:	6a 00                	push   $0x0
  801b01:	6a 00                	push   $0x0
  801b03:	6a 00                	push   $0x0
  801b05:	6a 00                	push   $0x0
  801b07:	6a 1f                	push   $0x1f
  801b09:	e8 a7 fc ff ff       	call   8017b5 <syscall>
  801b0e:	83 c4 18             	add    $0x18,%esp
}
  801b11:	c9                   	leave  
  801b12:	c3                   	ret    

00801b13 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b13:	55                   	push   %ebp
  801b14:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b16:	8b 45 08             	mov    0x8(%ebp),%eax
  801b19:	6a 00                	push   $0x0
  801b1b:	ff 75 14             	pushl  0x14(%ebp)
  801b1e:	ff 75 10             	pushl  0x10(%ebp)
  801b21:	ff 75 0c             	pushl  0xc(%ebp)
  801b24:	50                   	push   %eax
  801b25:	6a 20                	push   $0x20
  801b27:	e8 89 fc ff ff       	call   8017b5 <syscall>
  801b2c:	83 c4 18             	add    $0x18,%esp
}
  801b2f:	c9                   	leave  
  801b30:	c3                   	ret    

00801b31 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801b31:	55                   	push   %ebp
  801b32:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b34:	8b 45 08             	mov    0x8(%ebp),%eax
  801b37:	6a 00                	push   $0x0
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 00                	push   $0x0
  801b3f:	50                   	push   %eax
  801b40:	6a 21                	push   $0x21
  801b42:	e8 6e fc ff ff       	call   8017b5 <syscall>
  801b47:	83 c4 18             	add    $0x18,%esp
}
  801b4a:	90                   	nop
  801b4b:	c9                   	leave  
  801b4c:	c3                   	ret    

00801b4d <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b4d:	55                   	push   %ebp
  801b4e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b50:	8b 45 08             	mov    0x8(%ebp),%eax
  801b53:	6a 00                	push   $0x0
  801b55:	6a 00                	push   $0x0
  801b57:	6a 00                	push   $0x0
  801b59:	6a 00                	push   $0x0
  801b5b:	50                   	push   %eax
  801b5c:	6a 22                	push   $0x22
  801b5e:	e8 52 fc ff ff       	call   8017b5 <syscall>
  801b63:	83 c4 18             	add    $0x18,%esp
}
  801b66:	c9                   	leave  
  801b67:	c3                   	ret    

00801b68 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b68:	55                   	push   %ebp
  801b69:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 00                	push   $0x0
  801b73:	6a 00                	push   $0x0
  801b75:	6a 02                	push   $0x2
  801b77:	e8 39 fc ff ff       	call   8017b5 <syscall>
  801b7c:	83 c4 18             	add    $0x18,%esp
}
  801b7f:	c9                   	leave  
  801b80:	c3                   	ret    

00801b81 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b81:	55                   	push   %ebp
  801b82:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b84:	6a 00                	push   $0x0
  801b86:	6a 00                	push   $0x0
  801b88:	6a 00                	push   $0x0
  801b8a:	6a 00                	push   $0x0
  801b8c:	6a 00                	push   $0x0
  801b8e:	6a 03                	push   $0x3
  801b90:	e8 20 fc ff ff       	call   8017b5 <syscall>
  801b95:	83 c4 18             	add    $0x18,%esp
}
  801b98:	c9                   	leave  
  801b99:	c3                   	ret    

00801b9a <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b9a:	55                   	push   %ebp
  801b9b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b9d:	6a 00                	push   $0x0
  801b9f:	6a 00                	push   $0x0
  801ba1:	6a 00                	push   $0x0
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 04                	push   $0x4
  801ba9:	e8 07 fc ff ff       	call   8017b5 <syscall>
  801bae:	83 c4 18             	add    $0x18,%esp
}
  801bb1:	c9                   	leave  
  801bb2:	c3                   	ret    

00801bb3 <sys_exit_env>:


void sys_exit_env(void)
{
  801bb3:	55                   	push   %ebp
  801bb4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801bb6:	6a 00                	push   $0x0
  801bb8:	6a 00                	push   $0x0
  801bba:	6a 00                	push   $0x0
  801bbc:	6a 00                	push   $0x0
  801bbe:	6a 00                	push   $0x0
  801bc0:	6a 23                	push   $0x23
  801bc2:	e8 ee fb ff ff       	call   8017b5 <syscall>
  801bc7:	83 c4 18             	add    $0x18,%esp
}
  801bca:	90                   	nop
  801bcb:	c9                   	leave  
  801bcc:	c3                   	ret    

00801bcd <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801bcd:	55                   	push   %ebp
  801bce:	89 e5                	mov    %esp,%ebp
  801bd0:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801bd3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801bd6:	8d 50 04             	lea    0x4(%eax),%edx
  801bd9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 00                	push   $0x0
  801be0:	6a 00                	push   $0x0
  801be2:	52                   	push   %edx
  801be3:	50                   	push   %eax
  801be4:	6a 24                	push   $0x24
  801be6:	e8 ca fb ff ff       	call   8017b5 <syscall>
  801beb:	83 c4 18             	add    $0x18,%esp
	return result;
  801bee:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801bf1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bf4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801bf7:	89 01                	mov    %eax,(%ecx)
  801bf9:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bff:	c9                   	leave  
  801c00:	c2 04 00             	ret    $0x4

00801c03 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c03:	55                   	push   %ebp
  801c04:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c06:	6a 00                	push   $0x0
  801c08:	6a 00                	push   $0x0
  801c0a:	ff 75 10             	pushl  0x10(%ebp)
  801c0d:	ff 75 0c             	pushl  0xc(%ebp)
  801c10:	ff 75 08             	pushl  0x8(%ebp)
  801c13:	6a 12                	push   $0x12
  801c15:	e8 9b fb ff ff       	call   8017b5 <syscall>
  801c1a:	83 c4 18             	add    $0x18,%esp
	return ;
  801c1d:	90                   	nop
}
  801c1e:	c9                   	leave  
  801c1f:	c3                   	ret    

00801c20 <sys_rcr2>:
uint32 sys_rcr2()
{
  801c20:	55                   	push   %ebp
  801c21:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c23:	6a 00                	push   $0x0
  801c25:	6a 00                	push   $0x0
  801c27:	6a 00                	push   $0x0
  801c29:	6a 00                	push   $0x0
  801c2b:	6a 00                	push   $0x0
  801c2d:	6a 25                	push   $0x25
  801c2f:	e8 81 fb ff ff       	call   8017b5 <syscall>
  801c34:	83 c4 18             	add    $0x18,%esp
}
  801c37:	c9                   	leave  
  801c38:	c3                   	ret    

00801c39 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801c39:	55                   	push   %ebp
  801c3a:	89 e5                	mov    %esp,%ebp
  801c3c:	83 ec 04             	sub    $0x4,%esp
  801c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c42:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c45:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c49:	6a 00                	push   $0x0
  801c4b:	6a 00                	push   $0x0
  801c4d:	6a 00                	push   $0x0
  801c4f:	6a 00                	push   $0x0
  801c51:	50                   	push   %eax
  801c52:	6a 26                	push   $0x26
  801c54:	e8 5c fb ff ff       	call   8017b5 <syscall>
  801c59:	83 c4 18             	add    $0x18,%esp
	return ;
  801c5c:	90                   	nop
}
  801c5d:	c9                   	leave  
  801c5e:	c3                   	ret    

00801c5f <rsttst>:
void rsttst()
{
  801c5f:	55                   	push   %ebp
  801c60:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c62:	6a 00                	push   $0x0
  801c64:	6a 00                	push   $0x0
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 28                	push   $0x28
  801c6e:	e8 42 fb ff ff       	call   8017b5 <syscall>
  801c73:	83 c4 18             	add    $0x18,%esp
	return ;
  801c76:	90                   	nop
}
  801c77:	c9                   	leave  
  801c78:	c3                   	ret    

00801c79 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c79:	55                   	push   %ebp
  801c7a:	89 e5                	mov    %esp,%ebp
  801c7c:	83 ec 04             	sub    $0x4,%esp
  801c7f:	8b 45 14             	mov    0x14(%ebp),%eax
  801c82:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c85:	8b 55 18             	mov    0x18(%ebp),%edx
  801c88:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c8c:	52                   	push   %edx
  801c8d:	50                   	push   %eax
  801c8e:	ff 75 10             	pushl  0x10(%ebp)
  801c91:	ff 75 0c             	pushl  0xc(%ebp)
  801c94:	ff 75 08             	pushl  0x8(%ebp)
  801c97:	6a 27                	push   $0x27
  801c99:	e8 17 fb ff ff       	call   8017b5 <syscall>
  801c9e:	83 c4 18             	add    $0x18,%esp
	return ;
  801ca1:	90                   	nop
}
  801ca2:	c9                   	leave  
  801ca3:	c3                   	ret    

00801ca4 <chktst>:
void chktst(uint32 n)
{
  801ca4:	55                   	push   %ebp
  801ca5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801ca7:	6a 00                	push   $0x0
  801ca9:	6a 00                	push   $0x0
  801cab:	6a 00                	push   $0x0
  801cad:	6a 00                	push   $0x0
  801caf:	ff 75 08             	pushl  0x8(%ebp)
  801cb2:	6a 29                	push   $0x29
  801cb4:	e8 fc fa ff ff       	call   8017b5 <syscall>
  801cb9:	83 c4 18             	add    $0x18,%esp
	return ;
  801cbc:	90                   	nop
}
  801cbd:	c9                   	leave  
  801cbe:	c3                   	ret    

00801cbf <inctst>:

void inctst()
{
  801cbf:	55                   	push   %ebp
  801cc0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801cc2:	6a 00                	push   $0x0
  801cc4:	6a 00                	push   $0x0
  801cc6:	6a 00                	push   $0x0
  801cc8:	6a 00                	push   $0x0
  801cca:	6a 00                	push   $0x0
  801ccc:	6a 2a                	push   $0x2a
  801cce:	e8 e2 fa ff ff       	call   8017b5 <syscall>
  801cd3:	83 c4 18             	add    $0x18,%esp
	return ;
  801cd6:	90                   	nop
}
  801cd7:	c9                   	leave  
  801cd8:	c3                   	ret    

00801cd9 <gettst>:
uint32 gettst()
{
  801cd9:	55                   	push   %ebp
  801cda:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801cdc:	6a 00                	push   $0x0
  801cde:	6a 00                	push   $0x0
  801ce0:	6a 00                	push   $0x0
  801ce2:	6a 00                	push   $0x0
  801ce4:	6a 00                	push   $0x0
  801ce6:	6a 2b                	push   $0x2b
  801ce8:	e8 c8 fa ff ff       	call   8017b5 <syscall>
  801ced:	83 c4 18             	add    $0x18,%esp
}
  801cf0:	c9                   	leave  
  801cf1:	c3                   	ret    

00801cf2 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801cf2:	55                   	push   %ebp
  801cf3:	89 e5                	mov    %esp,%ebp
  801cf5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cf8:	6a 00                	push   $0x0
  801cfa:	6a 00                	push   $0x0
  801cfc:	6a 00                	push   $0x0
  801cfe:	6a 00                	push   $0x0
  801d00:	6a 00                	push   $0x0
  801d02:	6a 2c                	push   $0x2c
  801d04:	e8 ac fa ff ff       	call   8017b5 <syscall>
  801d09:	83 c4 18             	add    $0x18,%esp
  801d0c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d0f:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d13:	75 07                	jne    801d1c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d15:	b8 01 00 00 00       	mov    $0x1,%eax
  801d1a:	eb 05                	jmp    801d21 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d1c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d21:	c9                   	leave  
  801d22:	c3                   	ret    

00801d23 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d23:	55                   	push   %ebp
  801d24:	89 e5                	mov    %esp,%ebp
  801d26:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d29:	6a 00                	push   $0x0
  801d2b:	6a 00                	push   $0x0
  801d2d:	6a 00                	push   $0x0
  801d2f:	6a 00                	push   $0x0
  801d31:	6a 00                	push   $0x0
  801d33:	6a 2c                	push   $0x2c
  801d35:	e8 7b fa ff ff       	call   8017b5 <syscall>
  801d3a:	83 c4 18             	add    $0x18,%esp
  801d3d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d40:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d44:	75 07                	jne    801d4d <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d46:	b8 01 00 00 00       	mov    $0x1,%eax
  801d4b:	eb 05                	jmp    801d52 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d4d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d52:	c9                   	leave  
  801d53:	c3                   	ret    

00801d54 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d54:	55                   	push   %ebp
  801d55:	89 e5                	mov    %esp,%ebp
  801d57:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d5a:	6a 00                	push   $0x0
  801d5c:	6a 00                	push   $0x0
  801d5e:	6a 00                	push   $0x0
  801d60:	6a 00                	push   $0x0
  801d62:	6a 00                	push   $0x0
  801d64:	6a 2c                	push   $0x2c
  801d66:	e8 4a fa ff ff       	call   8017b5 <syscall>
  801d6b:	83 c4 18             	add    $0x18,%esp
  801d6e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801d71:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d75:	75 07                	jne    801d7e <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801d77:	b8 01 00 00 00       	mov    $0x1,%eax
  801d7c:	eb 05                	jmp    801d83 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801d7e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d83:	c9                   	leave  
  801d84:	c3                   	ret    

00801d85 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801d85:	55                   	push   %ebp
  801d86:	89 e5                	mov    %esp,%ebp
  801d88:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d8b:	6a 00                	push   $0x0
  801d8d:	6a 00                	push   $0x0
  801d8f:	6a 00                	push   $0x0
  801d91:	6a 00                	push   $0x0
  801d93:	6a 00                	push   $0x0
  801d95:	6a 2c                	push   $0x2c
  801d97:	e8 19 fa ff ff       	call   8017b5 <syscall>
  801d9c:	83 c4 18             	add    $0x18,%esp
  801d9f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801da2:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801da6:	75 07                	jne    801daf <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801da8:	b8 01 00 00 00       	mov    $0x1,%eax
  801dad:	eb 05                	jmp    801db4 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801daf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801db4:	c9                   	leave  
  801db5:	c3                   	ret    

00801db6 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801db6:	55                   	push   %ebp
  801db7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801db9:	6a 00                	push   $0x0
  801dbb:	6a 00                	push   $0x0
  801dbd:	6a 00                	push   $0x0
  801dbf:	6a 00                	push   $0x0
  801dc1:	ff 75 08             	pushl  0x8(%ebp)
  801dc4:	6a 2d                	push   $0x2d
  801dc6:	e8 ea f9 ff ff       	call   8017b5 <syscall>
  801dcb:	83 c4 18             	add    $0x18,%esp
	return ;
  801dce:	90                   	nop
}
  801dcf:	c9                   	leave  
  801dd0:	c3                   	ret    

00801dd1 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801dd1:	55                   	push   %ebp
  801dd2:	89 e5                	mov    %esp,%ebp
  801dd4:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801dd5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801dd8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ddb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dde:	8b 45 08             	mov    0x8(%ebp),%eax
  801de1:	6a 00                	push   $0x0
  801de3:	53                   	push   %ebx
  801de4:	51                   	push   %ecx
  801de5:	52                   	push   %edx
  801de6:	50                   	push   %eax
  801de7:	6a 2e                	push   $0x2e
  801de9:	e8 c7 f9 ff ff       	call   8017b5 <syscall>
  801dee:	83 c4 18             	add    $0x18,%esp
}
  801df1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801df4:	c9                   	leave  
  801df5:	c3                   	ret    

00801df6 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801df6:	55                   	push   %ebp
  801df7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801df9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  801dff:	6a 00                	push   $0x0
  801e01:	6a 00                	push   $0x0
  801e03:	6a 00                	push   $0x0
  801e05:	52                   	push   %edx
  801e06:	50                   	push   %eax
  801e07:	6a 2f                	push   $0x2f
  801e09:	e8 a7 f9 ff ff       	call   8017b5 <syscall>
  801e0e:	83 c4 18             	add    $0x18,%esp
}
  801e11:	c9                   	leave  
  801e12:	c3                   	ret    

00801e13 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801e13:	55                   	push   %ebp
  801e14:	89 e5                	mov    %esp,%ebp
  801e16:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801e19:	83 ec 0c             	sub    $0xc,%esp
  801e1c:	68 e8 3e 80 00       	push   $0x803ee8
  801e21:	e8 1e e8 ff ff       	call   800644 <cprintf>
  801e26:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801e29:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801e30:	83 ec 0c             	sub    $0xc,%esp
  801e33:	68 14 3f 80 00       	push   $0x803f14
  801e38:	e8 07 e8 ff ff       	call   800644 <cprintf>
  801e3d:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801e40:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e44:	a1 38 51 80 00       	mov    0x805138,%eax
  801e49:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e4c:	eb 56                	jmp    801ea4 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e4e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e52:	74 1c                	je     801e70 <print_mem_block_lists+0x5d>
  801e54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e57:	8b 50 08             	mov    0x8(%eax),%edx
  801e5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e5d:	8b 48 08             	mov    0x8(%eax),%ecx
  801e60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e63:	8b 40 0c             	mov    0xc(%eax),%eax
  801e66:	01 c8                	add    %ecx,%eax
  801e68:	39 c2                	cmp    %eax,%edx
  801e6a:	73 04                	jae    801e70 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801e6c:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e73:	8b 50 08             	mov    0x8(%eax),%edx
  801e76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e79:	8b 40 0c             	mov    0xc(%eax),%eax
  801e7c:	01 c2                	add    %eax,%edx
  801e7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e81:	8b 40 08             	mov    0x8(%eax),%eax
  801e84:	83 ec 04             	sub    $0x4,%esp
  801e87:	52                   	push   %edx
  801e88:	50                   	push   %eax
  801e89:	68 29 3f 80 00       	push   $0x803f29
  801e8e:	e8 b1 e7 ff ff       	call   800644 <cprintf>
  801e93:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e99:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e9c:	a1 40 51 80 00       	mov    0x805140,%eax
  801ea1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ea4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ea8:	74 07                	je     801eb1 <print_mem_block_lists+0x9e>
  801eaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ead:	8b 00                	mov    (%eax),%eax
  801eaf:	eb 05                	jmp    801eb6 <print_mem_block_lists+0xa3>
  801eb1:	b8 00 00 00 00       	mov    $0x0,%eax
  801eb6:	a3 40 51 80 00       	mov    %eax,0x805140
  801ebb:	a1 40 51 80 00       	mov    0x805140,%eax
  801ec0:	85 c0                	test   %eax,%eax
  801ec2:	75 8a                	jne    801e4e <print_mem_block_lists+0x3b>
  801ec4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ec8:	75 84                	jne    801e4e <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801eca:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801ece:	75 10                	jne    801ee0 <print_mem_block_lists+0xcd>
  801ed0:	83 ec 0c             	sub    $0xc,%esp
  801ed3:	68 38 3f 80 00       	push   $0x803f38
  801ed8:	e8 67 e7 ff ff       	call   800644 <cprintf>
  801edd:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801ee0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801ee7:	83 ec 0c             	sub    $0xc,%esp
  801eea:	68 5c 3f 80 00       	push   $0x803f5c
  801eef:	e8 50 e7 ff ff       	call   800644 <cprintf>
  801ef4:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801ef7:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801efb:	a1 40 50 80 00       	mov    0x805040,%eax
  801f00:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f03:	eb 56                	jmp    801f5b <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f05:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f09:	74 1c                	je     801f27 <print_mem_block_lists+0x114>
  801f0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f0e:	8b 50 08             	mov    0x8(%eax),%edx
  801f11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f14:	8b 48 08             	mov    0x8(%eax),%ecx
  801f17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f1a:	8b 40 0c             	mov    0xc(%eax),%eax
  801f1d:	01 c8                	add    %ecx,%eax
  801f1f:	39 c2                	cmp    %eax,%edx
  801f21:	73 04                	jae    801f27 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801f23:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f2a:	8b 50 08             	mov    0x8(%eax),%edx
  801f2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f30:	8b 40 0c             	mov    0xc(%eax),%eax
  801f33:	01 c2                	add    %eax,%edx
  801f35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f38:	8b 40 08             	mov    0x8(%eax),%eax
  801f3b:	83 ec 04             	sub    $0x4,%esp
  801f3e:	52                   	push   %edx
  801f3f:	50                   	push   %eax
  801f40:	68 29 3f 80 00       	push   $0x803f29
  801f45:	e8 fa e6 ff ff       	call   800644 <cprintf>
  801f4a:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f50:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f53:	a1 48 50 80 00       	mov    0x805048,%eax
  801f58:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f5b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f5f:	74 07                	je     801f68 <print_mem_block_lists+0x155>
  801f61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f64:	8b 00                	mov    (%eax),%eax
  801f66:	eb 05                	jmp    801f6d <print_mem_block_lists+0x15a>
  801f68:	b8 00 00 00 00       	mov    $0x0,%eax
  801f6d:	a3 48 50 80 00       	mov    %eax,0x805048
  801f72:	a1 48 50 80 00       	mov    0x805048,%eax
  801f77:	85 c0                	test   %eax,%eax
  801f79:	75 8a                	jne    801f05 <print_mem_block_lists+0xf2>
  801f7b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f7f:	75 84                	jne    801f05 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801f81:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f85:	75 10                	jne    801f97 <print_mem_block_lists+0x184>
  801f87:	83 ec 0c             	sub    $0xc,%esp
  801f8a:	68 74 3f 80 00       	push   $0x803f74
  801f8f:	e8 b0 e6 ff ff       	call   800644 <cprintf>
  801f94:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801f97:	83 ec 0c             	sub    $0xc,%esp
  801f9a:	68 e8 3e 80 00       	push   $0x803ee8
  801f9f:	e8 a0 e6 ff ff       	call   800644 <cprintf>
  801fa4:	83 c4 10             	add    $0x10,%esp

}
  801fa7:	90                   	nop
  801fa8:	c9                   	leave  
  801fa9:	c3                   	ret    

00801faa <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801faa:	55                   	push   %ebp
  801fab:	89 e5                	mov    %esp,%ebp
  801fad:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801fb0:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  801fb7:	00 00 00 
  801fba:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  801fc1:	00 00 00 
  801fc4:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  801fcb:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801fce:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801fd5:	e9 9e 00 00 00       	jmp    802078 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801fda:	a1 50 50 80 00       	mov    0x805050,%eax
  801fdf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fe2:	c1 e2 04             	shl    $0x4,%edx
  801fe5:	01 d0                	add    %edx,%eax
  801fe7:	85 c0                	test   %eax,%eax
  801fe9:	75 14                	jne    801fff <initialize_MemBlocksList+0x55>
  801feb:	83 ec 04             	sub    $0x4,%esp
  801fee:	68 9c 3f 80 00       	push   $0x803f9c
  801ff3:	6a 46                	push   $0x46
  801ff5:	68 bf 3f 80 00       	push   $0x803fbf
  801ffa:	e8 91 e3 ff ff       	call   800390 <_panic>
  801fff:	a1 50 50 80 00       	mov    0x805050,%eax
  802004:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802007:	c1 e2 04             	shl    $0x4,%edx
  80200a:	01 d0                	add    %edx,%eax
  80200c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802012:	89 10                	mov    %edx,(%eax)
  802014:	8b 00                	mov    (%eax),%eax
  802016:	85 c0                	test   %eax,%eax
  802018:	74 18                	je     802032 <initialize_MemBlocksList+0x88>
  80201a:	a1 48 51 80 00       	mov    0x805148,%eax
  80201f:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802025:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802028:	c1 e1 04             	shl    $0x4,%ecx
  80202b:	01 ca                	add    %ecx,%edx
  80202d:	89 50 04             	mov    %edx,0x4(%eax)
  802030:	eb 12                	jmp    802044 <initialize_MemBlocksList+0x9a>
  802032:	a1 50 50 80 00       	mov    0x805050,%eax
  802037:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80203a:	c1 e2 04             	shl    $0x4,%edx
  80203d:	01 d0                	add    %edx,%eax
  80203f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802044:	a1 50 50 80 00       	mov    0x805050,%eax
  802049:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80204c:	c1 e2 04             	shl    $0x4,%edx
  80204f:	01 d0                	add    %edx,%eax
  802051:	a3 48 51 80 00       	mov    %eax,0x805148
  802056:	a1 50 50 80 00       	mov    0x805050,%eax
  80205b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80205e:	c1 e2 04             	shl    $0x4,%edx
  802061:	01 d0                	add    %edx,%eax
  802063:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80206a:	a1 54 51 80 00       	mov    0x805154,%eax
  80206f:	40                   	inc    %eax
  802070:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802075:	ff 45 f4             	incl   -0xc(%ebp)
  802078:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80207b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80207e:	0f 82 56 ff ff ff    	jb     801fda <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802084:	90                   	nop
  802085:	c9                   	leave  
  802086:	c3                   	ret    

00802087 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802087:	55                   	push   %ebp
  802088:	89 e5                	mov    %esp,%ebp
  80208a:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80208d:	8b 45 08             	mov    0x8(%ebp),%eax
  802090:	8b 00                	mov    (%eax),%eax
  802092:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802095:	eb 19                	jmp    8020b0 <find_block+0x29>
	{
		if(va==point->sva)
  802097:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80209a:	8b 40 08             	mov    0x8(%eax),%eax
  80209d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8020a0:	75 05                	jne    8020a7 <find_block+0x20>
		   return point;
  8020a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020a5:	eb 36                	jmp    8020dd <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8020a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020aa:	8b 40 08             	mov    0x8(%eax),%eax
  8020ad:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020b0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020b4:	74 07                	je     8020bd <find_block+0x36>
  8020b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020b9:	8b 00                	mov    (%eax),%eax
  8020bb:	eb 05                	jmp    8020c2 <find_block+0x3b>
  8020bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8020c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8020c5:	89 42 08             	mov    %eax,0x8(%edx)
  8020c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cb:	8b 40 08             	mov    0x8(%eax),%eax
  8020ce:	85 c0                	test   %eax,%eax
  8020d0:	75 c5                	jne    802097 <find_block+0x10>
  8020d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020d6:	75 bf                	jne    802097 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  8020d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020dd:	c9                   	leave  
  8020de:	c3                   	ret    

008020df <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8020df:	55                   	push   %ebp
  8020e0:	89 e5                	mov    %esp,%ebp
  8020e2:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8020e5:	a1 40 50 80 00       	mov    0x805040,%eax
  8020ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8020ed:	a1 44 50 80 00       	mov    0x805044,%eax
  8020f2:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8020f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020f8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8020fb:	74 24                	je     802121 <insert_sorted_allocList+0x42>
  8020fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802100:	8b 50 08             	mov    0x8(%eax),%edx
  802103:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802106:	8b 40 08             	mov    0x8(%eax),%eax
  802109:	39 c2                	cmp    %eax,%edx
  80210b:	76 14                	jbe    802121 <insert_sorted_allocList+0x42>
  80210d:	8b 45 08             	mov    0x8(%ebp),%eax
  802110:	8b 50 08             	mov    0x8(%eax),%edx
  802113:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802116:	8b 40 08             	mov    0x8(%eax),%eax
  802119:	39 c2                	cmp    %eax,%edx
  80211b:	0f 82 60 01 00 00    	jb     802281 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802121:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802125:	75 65                	jne    80218c <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802127:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80212b:	75 14                	jne    802141 <insert_sorted_allocList+0x62>
  80212d:	83 ec 04             	sub    $0x4,%esp
  802130:	68 9c 3f 80 00       	push   $0x803f9c
  802135:	6a 6b                	push   $0x6b
  802137:	68 bf 3f 80 00       	push   $0x803fbf
  80213c:	e8 4f e2 ff ff       	call   800390 <_panic>
  802141:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802147:	8b 45 08             	mov    0x8(%ebp),%eax
  80214a:	89 10                	mov    %edx,(%eax)
  80214c:	8b 45 08             	mov    0x8(%ebp),%eax
  80214f:	8b 00                	mov    (%eax),%eax
  802151:	85 c0                	test   %eax,%eax
  802153:	74 0d                	je     802162 <insert_sorted_allocList+0x83>
  802155:	a1 40 50 80 00       	mov    0x805040,%eax
  80215a:	8b 55 08             	mov    0x8(%ebp),%edx
  80215d:	89 50 04             	mov    %edx,0x4(%eax)
  802160:	eb 08                	jmp    80216a <insert_sorted_allocList+0x8b>
  802162:	8b 45 08             	mov    0x8(%ebp),%eax
  802165:	a3 44 50 80 00       	mov    %eax,0x805044
  80216a:	8b 45 08             	mov    0x8(%ebp),%eax
  80216d:	a3 40 50 80 00       	mov    %eax,0x805040
  802172:	8b 45 08             	mov    0x8(%ebp),%eax
  802175:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80217c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802181:	40                   	inc    %eax
  802182:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802187:	e9 dc 01 00 00       	jmp    802368 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  80218c:	8b 45 08             	mov    0x8(%ebp),%eax
  80218f:	8b 50 08             	mov    0x8(%eax),%edx
  802192:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802195:	8b 40 08             	mov    0x8(%eax),%eax
  802198:	39 c2                	cmp    %eax,%edx
  80219a:	77 6c                	ja     802208 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  80219c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021a0:	74 06                	je     8021a8 <insert_sorted_allocList+0xc9>
  8021a2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021a6:	75 14                	jne    8021bc <insert_sorted_allocList+0xdd>
  8021a8:	83 ec 04             	sub    $0x4,%esp
  8021ab:	68 d8 3f 80 00       	push   $0x803fd8
  8021b0:	6a 6f                	push   $0x6f
  8021b2:	68 bf 3f 80 00       	push   $0x803fbf
  8021b7:	e8 d4 e1 ff ff       	call   800390 <_panic>
  8021bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021bf:	8b 50 04             	mov    0x4(%eax),%edx
  8021c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c5:	89 50 04             	mov    %edx,0x4(%eax)
  8021c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021ce:	89 10                	mov    %edx,(%eax)
  8021d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021d3:	8b 40 04             	mov    0x4(%eax),%eax
  8021d6:	85 c0                	test   %eax,%eax
  8021d8:	74 0d                	je     8021e7 <insert_sorted_allocList+0x108>
  8021da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021dd:	8b 40 04             	mov    0x4(%eax),%eax
  8021e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8021e3:	89 10                	mov    %edx,(%eax)
  8021e5:	eb 08                	jmp    8021ef <insert_sorted_allocList+0x110>
  8021e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ea:	a3 40 50 80 00       	mov    %eax,0x805040
  8021ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8021f5:	89 50 04             	mov    %edx,0x4(%eax)
  8021f8:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8021fd:	40                   	inc    %eax
  8021fe:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802203:	e9 60 01 00 00       	jmp    802368 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802208:	8b 45 08             	mov    0x8(%ebp),%eax
  80220b:	8b 50 08             	mov    0x8(%eax),%edx
  80220e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802211:	8b 40 08             	mov    0x8(%eax),%eax
  802214:	39 c2                	cmp    %eax,%edx
  802216:	0f 82 4c 01 00 00    	jb     802368 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  80221c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802220:	75 14                	jne    802236 <insert_sorted_allocList+0x157>
  802222:	83 ec 04             	sub    $0x4,%esp
  802225:	68 10 40 80 00       	push   $0x804010
  80222a:	6a 73                	push   $0x73
  80222c:	68 bf 3f 80 00       	push   $0x803fbf
  802231:	e8 5a e1 ff ff       	call   800390 <_panic>
  802236:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80223c:	8b 45 08             	mov    0x8(%ebp),%eax
  80223f:	89 50 04             	mov    %edx,0x4(%eax)
  802242:	8b 45 08             	mov    0x8(%ebp),%eax
  802245:	8b 40 04             	mov    0x4(%eax),%eax
  802248:	85 c0                	test   %eax,%eax
  80224a:	74 0c                	je     802258 <insert_sorted_allocList+0x179>
  80224c:	a1 44 50 80 00       	mov    0x805044,%eax
  802251:	8b 55 08             	mov    0x8(%ebp),%edx
  802254:	89 10                	mov    %edx,(%eax)
  802256:	eb 08                	jmp    802260 <insert_sorted_allocList+0x181>
  802258:	8b 45 08             	mov    0x8(%ebp),%eax
  80225b:	a3 40 50 80 00       	mov    %eax,0x805040
  802260:	8b 45 08             	mov    0x8(%ebp),%eax
  802263:	a3 44 50 80 00       	mov    %eax,0x805044
  802268:	8b 45 08             	mov    0x8(%ebp),%eax
  80226b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802271:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802276:	40                   	inc    %eax
  802277:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80227c:	e9 e7 00 00 00       	jmp    802368 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802281:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802284:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802287:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80228e:	a1 40 50 80 00       	mov    0x805040,%eax
  802293:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802296:	e9 9d 00 00 00       	jmp    802338 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  80229b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229e:	8b 00                	mov    (%eax),%eax
  8022a0:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8022a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a6:	8b 50 08             	mov    0x8(%eax),%edx
  8022a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ac:	8b 40 08             	mov    0x8(%eax),%eax
  8022af:	39 c2                	cmp    %eax,%edx
  8022b1:	76 7d                	jbe    802330 <insert_sorted_allocList+0x251>
  8022b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b6:	8b 50 08             	mov    0x8(%eax),%edx
  8022b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022bc:	8b 40 08             	mov    0x8(%eax),%eax
  8022bf:	39 c2                	cmp    %eax,%edx
  8022c1:	73 6d                	jae    802330 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8022c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022c7:	74 06                	je     8022cf <insert_sorted_allocList+0x1f0>
  8022c9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022cd:	75 14                	jne    8022e3 <insert_sorted_allocList+0x204>
  8022cf:	83 ec 04             	sub    $0x4,%esp
  8022d2:	68 34 40 80 00       	push   $0x804034
  8022d7:	6a 7f                	push   $0x7f
  8022d9:	68 bf 3f 80 00       	push   $0x803fbf
  8022de:	e8 ad e0 ff ff       	call   800390 <_panic>
  8022e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e6:	8b 10                	mov    (%eax),%edx
  8022e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022eb:	89 10                	mov    %edx,(%eax)
  8022ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f0:	8b 00                	mov    (%eax),%eax
  8022f2:	85 c0                	test   %eax,%eax
  8022f4:	74 0b                	je     802301 <insert_sorted_allocList+0x222>
  8022f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f9:	8b 00                	mov    (%eax),%eax
  8022fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8022fe:	89 50 04             	mov    %edx,0x4(%eax)
  802301:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802304:	8b 55 08             	mov    0x8(%ebp),%edx
  802307:	89 10                	mov    %edx,(%eax)
  802309:	8b 45 08             	mov    0x8(%ebp),%eax
  80230c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80230f:	89 50 04             	mov    %edx,0x4(%eax)
  802312:	8b 45 08             	mov    0x8(%ebp),%eax
  802315:	8b 00                	mov    (%eax),%eax
  802317:	85 c0                	test   %eax,%eax
  802319:	75 08                	jne    802323 <insert_sorted_allocList+0x244>
  80231b:	8b 45 08             	mov    0x8(%ebp),%eax
  80231e:	a3 44 50 80 00       	mov    %eax,0x805044
  802323:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802328:	40                   	inc    %eax
  802329:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  80232e:	eb 39                	jmp    802369 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802330:	a1 48 50 80 00       	mov    0x805048,%eax
  802335:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802338:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80233c:	74 07                	je     802345 <insert_sorted_allocList+0x266>
  80233e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802341:	8b 00                	mov    (%eax),%eax
  802343:	eb 05                	jmp    80234a <insert_sorted_allocList+0x26b>
  802345:	b8 00 00 00 00       	mov    $0x0,%eax
  80234a:	a3 48 50 80 00       	mov    %eax,0x805048
  80234f:	a1 48 50 80 00       	mov    0x805048,%eax
  802354:	85 c0                	test   %eax,%eax
  802356:	0f 85 3f ff ff ff    	jne    80229b <insert_sorted_allocList+0x1bc>
  80235c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802360:	0f 85 35 ff ff ff    	jne    80229b <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802366:	eb 01                	jmp    802369 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802368:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802369:	90                   	nop
  80236a:	c9                   	leave  
  80236b:	c3                   	ret    

0080236c <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80236c:	55                   	push   %ebp
  80236d:	89 e5                	mov    %esp,%ebp
  80236f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802372:	a1 38 51 80 00       	mov    0x805138,%eax
  802377:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80237a:	e9 85 01 00 00       	jmp    802504 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  80237f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802382:	8b 40 0c             	mov    0xc(%eax),%eax
  802385:	3b 45 08             	cmp    0x8(%ebp),%eax
  802388:	0f 82 6e 01 00 00    	jb     8024fc <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  80238e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802391:	8b 40 0c             	mov    0xc(%eax),%eax
  802394:	3b 45 08             	cmp    0x8(%ebp),%eax
  802397:	0f 85 8a 00 00 00    	jne    802427 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  80239d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023a1:	75 17                	jne    8023ba <alloc_block_FF+0x4e>
  8023a3:	83 ec 04             	sub    $0x4,%esp
  8023a6:	68 68 40 80 00       	push   $0x804068
  8023ab:	68 93 00 00 00       	push   $0x93
  8023b0:	68 bf 3f 80 00       	push   $0x803fbf
  8023b5:	e8 d6 df ff ff       	call   800390 <_panic>
  8023ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023bd:	8b 00                	mov    (%eax),%eax
  8023bf:	85 c0                	test   %eax,%eax
  8023c1:	74 10                	je     8023d3 <alloc_block_FF+0x67>
  8023c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c6:	8b 00                	mov    (%eax),%eax
  8023c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023cb:	8b 52 04             	mov    0x4(%edx),%edx
  8023ce:	89 50 04             	mov    %edx,0x4(%eax)
  8023d1:	eb 0b                	jmp    8023de <alloc_block_FF+0x72>
  8023d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d6:	8b 40 04             	mov    0x4(%eax),%eax
  8023d9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8023de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e1:	8b 40 04             	mov    0x4(%eax),%eax
  8023e4:	85 c0                	test   %eax,%eax
  8023e6:	74 0f                	je     8023f7 <alloc_block_FF+0x8b>
  8023e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023eb:	8b 40 04             	mov    0x4(%eax),%eax
  8023ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023f1:	8b 12                	mov    (%edx),%edx
  8023f3:	89 10                	mov    %edx,(%eax)
  8023f5:	eb 0a                	jmp    802401 <alloc_block_FF+0x95>
  8023f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fa:	8b 00                	mov    (%eax),%eax
  8023fc:	a3 38 51 80 00       	mov    %eax,0x805138
  802401:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802404:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80240a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802414:	a1 44 51 80 00       	mov    0x805144,%eax
  802419:	48                   	dec    %eax
  80241a:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  80241f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802422:	e9 10 01 00 00       	jmp    802537 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802427:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242a:	8b 40 0c             	mov    0xc(%eax),%eax
  80242d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802430:	0f 86 c6 00 00 00    	jbe    8024fc <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802436:	a1 48 51 80 00       	mov    0x805148,%eax
  80243b:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  80243e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802441:	8b 50 08             	mov    0x8(%eax),%edx
  802444:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802447:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  80244a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80244d:	8b 55 08             	mov    0x8(%ebp),%edx
  802450:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802453:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802457:	75 17                	jne    802470 <alloc_block_FF+0x104>
  802459:	83 ec 04             	sub    $0x4,%esp
  80245c:	68 68 40 80 00       	push   $0x804068
  802461:	68 9b 00 00 00       	push   $0x9b
  802466:	68 bf 3f 80 00       	push   $0x803fbf
  80246b:	e8 20 df ff ff       	call   800390 <_panic>
  802470:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802473:	8b 00                	mov    (%eax),%eax
  802475:	85 c0                	test   %eax,%eax
  802477:	74 10                	je     802489 <alloc_block_FF+0x11d>
  802479:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80247c:	8b 00                	mov    (%eax),%eax
  80247e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802481:	8b 52 04             	mov    0x4(%edx),%edx
  802484:	89 50 04             	mov    %edx,0x4(%eax)
  802487:	eb 0b                	jmp    802494 <alloc_block_FF+0x128>
  802489:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80248c:	8b 40 04             	mov    0x4(%eax),%eax
  80248f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802494:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802497:	8b 40 04             	mov    0x4(%eax),%eax
  80249a:	85 c0                	test   %eax,%eax
  80249c:	74 0f                	je     8024ad <alloc_block_FF+0x141>
  80249e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024a1:	8b 40 04             	mov    0x4(%eax),%eax
  8024a4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024a7:	8b 12                	mov    (%edx),%edx
  8024a9:	89 10                	mov    %edx,(%eax)
  8024ab:	eb 0a                	jmp    8024b7 <alloc_block_FF+0x14b>
  8024ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024b0:	8b 00                	mov    (%eax),%eax
  8024b2:	a3 48 51 80 00       	mov    %eax,0x805148
  8024b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024c3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024ca:	a1 54 51 80 00       	mov    0x805154,%eax
  8024cf:	48                   	dec    %eax
  8024d0:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  8024d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d8:	8b 50 08             	mov    0x8(%eax),%edx
  8024db:	8b 45 08             	mov    0x8(%ebp),%eax
  8024de:	01 c2                	add    %eax,%edx
  8024e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e3:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8024e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e9:	8b 40 0c             	mov    0xc(%eax),%eax
  8024ec:	2b 45 08             	sub    0x8(%ebp),%eax
  8024ef:	89 c2                	mov    %eax,%edx
  8024f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f4:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8024f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024fa:	eb 3b                	jmp    802537 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8024fc:	a1 40 51 80 00       	mov    0x805140,%eax
  802501:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802504:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802508:	74 07                	je     802511 <alloc_block_FF+0x1a5>
  80250a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250d:	8b 00                	mov    (%eax),%eax
  80250f:	eb 05                	jmp    802516 <alloc_block_FF+0x1aa>
  802511:	b8 00 00 00 00       	mov    $0x0,%eax
  802516:	a3 40 51 80 00       	mov    %eax,0x805140
  80251b:	a1 40 51 80 00       	mov    0x805140,%eax
  802520:	85 c0                	test   %eax,%eax
  802522:	0f 85 57 fe ff ff    	jne    80237f <alloc_block_FF+0x13>
  802528:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80252c:	0f 85 4d fe ff ff    	jne    80237f <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802532:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802537:	c9                   	leave  
  802538:	c3                   	ret    

00802539 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802539:	55                   	push   %ebp
  80253a:	89 e5                	mov    %esp,%ebp
  80253c:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  80253f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802546:	a1 38 51 80 00       	mov    0x805138,%eax
  80254b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80254e:	e9 df 00 00 00       	jmp    802632 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802553:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802556:	8b 40 0c             	mov    0xc(%eax),%eax
  802559:	3b 45 08             	cmp    0x8(%ebp),%eax
  80255c:	0f 82 c8 00 00 00    	jb     80262a <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802562:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802565:	8b 40 0c             	mov    0xc(%eax),%eax
  802568:	3b 45 08             	cmp    0x8(%ebp),%eax
  80256b:	0f 85 8a 00 00 00    	jne    8025fb <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802571:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802575:	75 17                	jne    80258e <alloc_block_BF+0x55>
  802577:	83 ec 04             	sub    $0x4,%esp
  80257a:	68 68 40 80 00       	push   $0x804068
  80257f:	68 b7 00 00 00       	push   $0xb7
  802584:	68 bf 3f 80 00       	push   $0x803fbf
  802589:	e8 02 de ff ff       	call   800390 <_panic>
  80258e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802591:	8b 00                	mov    (%eax),%eax
  802593:	85 c0                	test   %eax,%eax
  802595:	74 10                	je     8025a7 <alloc_block_BF+0x6e>
  802597:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259a:	8b 00                	mov    (%eax),%eax
  80259c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80259f:	8b 52 04             	mov    0x4(%edx),%edx
  8025a2:	89 50 04             	mov    %edx,0x4(%eax)
  8025a5:	eb 0b                	jmp    8025b2 <alloc_block_BF+0x79>
  8025a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025aa:	8b 40 04             	mov    0x4(%eax),%eax
  8025ad:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8025b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b5:	8b 40 04             	mov    0x4(%eax),%eax
  8025b8:	85 c0                	test   %eax,%eax
  8025ba:	74 0f                	je     8025cb <alloc_block_BF+0x92>
  8025bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bf:	8b 40 04             	mov    0x4(%eax),%eax
  8025c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025c5:	8b 12                	mov    (%edx),%edx
  8025c7:	89 10                	mov    %edx,(%eax)
  8025c9:	eb 0a                	jmp    8025d5 <alloc_block_BF+0x9c>
  8025cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ce:	8b 00                	mov    (%eax),%eax
  8025d0:	a3 38 51 80 00       	mov    %eax,0x805138
  8025d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025e8:	a1 44 51 80 00       	mov    0x805144,%eax
  8025ed:	48                   	dec    %eax
  8025ee:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  8025f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f6:	e9 4d 01 00 00       	jmp    802748 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8025fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fe:	8b 40 0c             	mov    0xc(%eax),%eax
  802601:	3b 45 08             	cmp    0x8(%ebp),%eax
  802604:	76 24                	jbe    80262a <alloc_block_BF+0xf1>
  802606:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802609:	8b 40 0c             	mov    0xc(%eax),%eax
  80260c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80260f:	73 19                	jae    80262a <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802611:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802618:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261b:	8b 40 0c             	mov    0xc(%eax),%eax
  80261e:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802621:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802624:	8b 40 08             	mov    0x8(%eax),%eax
  802627:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80262a:	a1 40 51 80 00       	mov    0x805140,%eax
  80262f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802632:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802636:	74 07                	je     80263f <alloc_block_BF+0x106>
  802638:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263b:	8b 00                	mov    (%eax),%eax
  80263d:	eb 05                	jmp    802644 <alloc_block_BF+0x10b>
  80263f:	b8 00 00 00 00       	mov    $0x0,%eax
  802644:	a3 40 51 80 00       	mov    %eax,0x805140
  802649:	a1 40 51 80 00       	mov    0x805140,%eax
  80264e:	85 c0                	test   %eax,%eax
  802650:	0f 85 fd fe ff ff    	jne    802553 <alloc_block_BF+0x1a>
  802656:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80265a:	0f 85 f3 fe ff ff    	jne    802553 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802660:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802664:	0f 84 d9 00 00 00    	je     802743 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  80266a:	a1 48 51 80 00       	mov    0x805148,%eax
  80266f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802672:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802675:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802678:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  80267b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80267e:	8b 55 08             	mov    0x8(%ebp),%edx
  802681:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802684:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802688:	75 17                	jne    8026a1 <alloc_block_BF+0x168>
  80268a:	83 ec 04             	sub    $0x4,%esp
  80268d:	68 68 40 80 00       	push   $0x804068
  802692:	68 c7 00 00 00       	push   $0xc7
  802697:	68 bf 3f 80 00       	push   $0x803fbf
  80269c:	e8 ef dc ff ff       	call   800390 <_panic>
  8026a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026a4:	8b 00                	mov    (%eax),%eax
  8026a6:	85 c0                	test   %eax,%eax
  8026a8:	74 10                	je     8026ba <alloc_block_BF+0x181>
  8026aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026ad:	8b 00                	mov    (%eax),%eax
  8026af:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026b2:	8b 52 04             	mov    0x4(%edx),%edx
  8026b5:	89 50 04             	mov    %edx,0x4(%eax)
  8026b8:	eb 0b                	jmp    8026c5 <alloc_block_BF+0x18c>
  8026ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026bd:	8b 40 04             	mov    0x4(%eax),%eax
  8026c0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8026c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026c8:	8b 40 04             	mov    0x4(%eax),%eax
  8026cb:	85 c0                	test   %eax,%eax
  8026cd:	74 0f                	je     8026de <alloc_block_BF+0x1a5>
  8026cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026d2:	8b 40 04             	mov    0x4(%eax),%eax
  8026d5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026d8:	8b 12                	mov    (%edx),%edx
  8026da:	89 10                	mov    %edx,(%eax)
  8026dc:	eb 0a                	jmp    8026e8 <alloc_block_BF+0x1af>
  8026de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026e1:	8b 00                	mov    (%eax),%eax
  8026e3:	a3 48 51 80 00       	mov    %eax,0x805148
  8026e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026eb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026f4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026fb:	a1 54 51 80 00       	mov    0x805154,%eax
  802700:	48                   	dec    %eax
  802701:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802706:	83 ec 08             	sub    $0x8,%esp
  802709:	ff 75 ec             	pushl  -0x14(%ebp)
  80270c:	68 38 51 80 00       	push   $0x805138
  802711:	e8 71 f9 ff ff       	call   802087 <find_block>
  802716:	83 c4 10             	add    $0x10,%esp
  802719:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  80271c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80271f:	8b 50 08             	mov    0x8(%eax),%edx
  802722:	8b 45 08             	mov    0x8(%ebp),%eax
  802725:	01 c2                	add    %eax,%edx
  802727:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80272a:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  80272d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802730:	8b 40 0c             	mov    0xc(%eax),%eax
  802733:	2b 45 08             	sub    0x8(%ebp),%eax
  802736:	89 c2                	mov    %eax,%edx
  802738:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80273b:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  80273e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802741:	eb 05                	jmp    802748 <alloc_block_BF+0x20f>
	}
	return NULL;
  802743:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802748:	c9                   	leave  
  802749:	c3                   	ret    

0080274a <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  80274a:	55                   	push   %ebp
  80274b:	89 e5                	mov    %esp,%ebp
  80274d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802750:	a1 28 50 80 00       	mov    0x805028,%eax
  802755:	85 c0                	test   %eax,%eax
  802757:	0f 85 de 01 00 00    	jne    80293b <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80275d:	a1 38 51 80 00       	mov    0x805138,%eax
  802762:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802765:	e9 9e 01 00 00       	jmp    802908 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  80276a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276d:	8b 40 0c             	mov    0xc(%eax),%eax
  802770:	3b 45 08             	cmp    0x8(%ebp),%eax
  802773:	0f 82 87 01 00 00    	jb     802900 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802779:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277c:	8b 40 0c             	mov    0xc(%eax),%eax
  80277f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802782:	0f 85 95 00 00 00    	jne    80281d <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802788:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80278c:	75 17                	jne    8027a5 <alloc_block_NF+0x5b>
  80278e:	83 ec 04             	sub    $0x4,%esp
  802791:	68 68 40 80 00       	push   $0x804068
  802796:	68 e0 00 00 00       	push   $0xe0
  80279b:	68 bf 3f 80 00       	push   $0x803fbf
  8027a0:	e8 eb db ff ff       	call   800390 <_panic>
  8027a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a8:	8b 00                	mov    (%eax),%eax
  8027aa:	85 c0                	test   %eax,%eax
  8027ac:	74 10                	je     8027be <alloc_block_NF+0x74>
  8027ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b1:	8b 00                	mov    (%eax),%eax
  8027b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027b6:	8b 52 04             	mov    0x4(%edx),%edx
  8027b9:	89 50 04             	mov    %edx,0x4(%eax)
  8027bc:	eb 0b                	jmp    8027c9 <alloc_block_NF+0x7f>
  8027be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c1:	8b 40 04             	mov    0x4(%eax),%eax
  8027c4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8027c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cc:	8b 40 04             	mov    0x4(%eax),%eax
  8027cf:	85 c0                	test   %eax,%eax
  8027d1:	74 0f                	je     8027e2 <alloc_block_NF+0x98>
  8027d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d6:	8b 40 04             	mov    0x4(%eax),%eax
  8027d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027dc:	8b 12                	mov    (%edx),%edx
  8027de:	89 10                	mov    %edx,(%eax)
  8027e0:	eb 0a                	jmp    8027ec <alloc_block_NF+0xa2>
  8027e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e5:	8b 00                	mov    (%eax),%eax
  8027e7:	a3 38 51 80 00       	mov    %eax,0x805138
  8027ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027ff:	a1 44 51 80 00       	mov    0x805144,%eax
  802804:	48                   	dec    %eax
  802805:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  80280a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280d:	8b 40 08             	mov    0x8(%eax),%eax
  802810:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802815:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802818:	e9 f8 04 00 00       	jmp    802d15 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  80281d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802820:	8b 40 0c             	mov    0xc(%eax),%eax
  802823:	3b 45 08             	cmp    0x8(%ebp),%eax
  802826:	0f 86 d4 00 00 00    	jbe    802900 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80282c:	a1 48 51 80 00       	mov    0x805148,%eax
  802831:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802834:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802837:	8b 50 08             	mov    0x8(%eax),%edx
  80283a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80283d:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802840:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802843:	8b 55 08             	mov    0x8(%ebp),%edx
  802846:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802849:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80284d:	75 17                	jne    802866 <alloc_block_NF+0x11c>
  80284f:	83 ec 04             	sub    $0x4,%esp
  802852:	68 68 40 80 00       	push   $0x804068
  802857:	68 e9 00 00 00       	push   $0xe9
  80285c:	68 bf 3f 80 00       	push   $0x803fbf
  802861:	e8 2a db ff ff       	call   800390 <_panic>
  802866:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802869:	8b 00                	mov    (%eax),%eax
  80286b:	85 c0                	test   %eax,%eax
  80286d:	74 10                	je     80287f <alloc_block_NF+0x135>
  80286f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802872:	8b 00                	mov    (%eax),%eax
  802874:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802877:	8b 52 04             	mov    0x4(%edx),%edx
  80287a:	89 50 04             	mov    %edx,0x4(%eax)
  80287d:	eb 0b                	jmp    80288a <alloc_block_NF+0x140>
  80287f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802882:	8b 40 04             	mov    0x4(%eax),%eax
  802885:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80288a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80288d:	8b 40 04             	mov    0x4(%eax),%eax
  802890:	85 c0                	test   %eax,%eax
  802892:	74 0f                	je     8028a3 <alloc_block_NF+0x159>
  802894:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802897:	8b 40 04             	mov    0x4(%eax),%eax
  80289a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80289d:	8b 12                	mov    (%edx),%edx
  80289f:	89 10                	mov    %edx,(%eax)
  8028a1:	eb 0a                	jmp    8028ad <alloc_block_NF+0x163>
  8028a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a6:	8b 00                	mov    (%eax),%eax
  8028a8:	a3 48 51 80 00       	mov    %eax,0x805148
  8028ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028c0:	a1 54 51 80 00       	mov    0x805154,%eax
  8028c5:	48                   	dec    %eax
  8028c6:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  8028cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ce:	8b 40 08             	mov    0x8(%eax),%eax
  8028d1:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  8028d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d9:	8b 50 08             	mov    0x8(%eax),%edx
  8028dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8028df:	01 c2                	add    %eax,%edx
  8028e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e4:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  8028e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ea:	8b 40 0c             	mov    0xc(%eax),%eax
  8028ed:	2b 45 08             	sub    0x8(%ebp),%eax
  8028f0:	89 c2                	mov    %eax,%edx
  8028f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f5:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8028f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028fb:	e9 15 04 00 00       	jmp    802d15 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802900:	a1 40 51 80 00       	mov    0x805140,%eax
  802905:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802908:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80290c:	74 07                	je     802915 <alloc_block_NF+0x1cb>
  80290e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802911:	8b 00                	mov    (%eax),%eax
  802913:	eb 05                	jmp    80291a <alloc_block_NF+0x1d0>
  802915:	b8 00 00 00 00       	mov    $0x0,%eax
  80291a:	a3 40 51 80 00       	mov    %eax,0x805140
  80291f:	a1 40 51 80 00       	mov    0x805140,%eax
  802924:	85 c0                	test   %eax,%eax
  802926:	0f 85 3e fe ff ff    	jne    80276a <alloc_block_NF+0x20>
  80292c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802930:	0f 85 34 fe ff ff    	jne    80276a <alloc_block_NF+0x20>
  802936:	e9 d5 03 00 00       	jmp    802d10 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  80293b:	a1 38 51 80 00       	mov    0x805138,%eax
  802940:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802943:	e9 b1 01 00 00       	jmp    802af9 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802948:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294b:	8b 50 08             	mov    0x8(%eax),%edx
  80294e:	a1 28 50 80 00       	mov    0x805028,%eax
  802953:	39 c2                	cmp    %eax,%edx
  802955:	0f 82 96 01 00 00    	jb     802af1 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  80295b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295e:	8b 40 0c             	mov    0xc(%eax),%eax
  802961:	3b 45 08             	cmp    0x8(%ebp),%eax
  802964:	0f 82 87 01 00 00    	jb     802af1 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  80296a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296d:	8b 40 0c             	mov    0xc(%eax),%eax
  802970:	3b 45 08             	cmp    0x8(%ebp),%eax
  802973:	0f 85 95 00 00 00    	jne    802a0e <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802979:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80297d:	75 17                	jne    802996 <alloc_block_NF+0x24c>
  80297f:	83 ec 04             	sub    $0x4,%esp
  802982:	68 68 40 80 00       	push   $0x804068
  802987:	68 fc 00 00 00       	push   $0xfc
  80298c:	68 bf 3f 80 00       	push   $0x803fbf
  802991:	e8 fa d9 ff ff       	call   800390 <_panic>
  802996:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802999:	8b 00                	mov    (%eax),%eax
  80299b:	85 c0                	test   %eax,%eax
  80299d:	74 10                	je     8029af <alloc_block_NF+0x265>
  80299f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a2:	8b 00                	mov    (%eax),%eax
  8029a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029a7:	8b 52 04             	mov    0x4(%edx),%edx
  8029aa:	89 50 04             	mov    %edx,0x4(%eax)
  8029ad:	eb 0b                	jmp    8029ba <alloc_block_NF+0x270>
  8029af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b2:	8b 40 04             	mov    0x4(%eax),%eax
  8029b5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8029ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bd:	8b 40 04             	mov    0x4(%eax),%eax
  8029c0:	85 c0                	test   %eax,%eax
  8029c2:	74 0f                	je     8029d3 <alloc_block_NF+0x289>
  8029c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c7:	8b 40 04             	mov    0x4(%eax),%eax
  8029ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029cd:	8b 12                	mov    (%edx),%edx
  8029cf:	89 10                	mov    %edx,(%eax)
  8029d1:	eb 0a                	jmp    8029dd <alloc_block_NF+0x293>
  8029d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d6:	8b 00                	mov    (%eax),%eax
  8029d8:	a3 38 51 80 00       	mov    %eax,0x805138
  8029dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029f0:	a1 44 51 80 00       	mov    0x805144,%eax
  8029f5:	48                   	dec    %eax
  8029f6:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8029fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fe:	8b 40 08             	mov    0x8(%eax),%eax
  802a01:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802a06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a09:	e9 07 03 00 00       	jmp    802d15 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802a0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a11:	8b 40 0c             	mov    0xc(%eax),%eax
  802a14:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a17:	0f 86 d4 00 00 00    	jbe    802af1 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802a1d:	a1 48 51 80 00       	mov    0x805148,%eax
  802a22:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802a25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a28:	8b 50 08             	mov    0x8(%eax),%edx
  802a2b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a2e:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802a31:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a34:	8b 55 08             	mov    0x8(%ebp),%edx
  802a37:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802a3a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802a3e:	75 17                	jne    802a57 <alloc_block_NF+0x30d>
  802a40:	83 ec 04             	sub    $0x4,%esp
  802a43:	68 68 40 80 00       	push   $0x804068
  802a48:	68 04 01 00 00       	push   $0x104
  802a4d:	68 bf 3f 80 00       	push   $0x803fbf
  802a52:	e8 39 d9 ff ff       	call   800390 <_panic>
  802a57:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a5a:	8b 00                	mov    (%eax),%eax
  802a5c:	85 c0                	test   %eax,%eax
  802a5e:	74 10                	je     802a70 <alloc_block_NF+0x326>
  802a60:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a63:	8b 00                	mov    (%eax),%eax
  802a65:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a68:	8b 52 04             	mov    0x4(%edx),%edx
  802a6b:	89 50 04             	mov    %edx,0x4(%eax)
  802a6e:	eb 0b                	jmp    802a7b <alloc_block_NF+0x331>
  802a70:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a73:	8b 40 04             	mov    0x4(%eax),%eax
  802a76:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a7b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a7e:	8b 40 04             	mov    0x4(%eax),%eax
  802a81:	85 c0                	test   %eax,%eax
  802a83:	74 0f                	je     802a94 <alloc_block_NF+0x34a>
  802a85:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a88:	8b 40 04             	mov    0x4(%eax),%eax
  802a8b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a8e:	8b 12                	mov    (%edx),%edx
  802a90:	89 10                	mov    %edx,(%eax)
  802a92:	eb 0a                	jmp    802a9e <alloc_block_NF+0x354>
  802a94:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a97:	8b 00                	mov    (%eax),%eax
  802a99:	a3 48 51 80 00       	mov    %eax,0x805148
  802a9e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aa1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802aa7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aaa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ab1:	a1 54 51 80 00       	mov    0x805154,%eax
  802ab6:	48                   	dec    %eax
  802ab7:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802abc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802abf:	8b 40 08             	mov    0x8(%eax),%eax
  802ac2:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802ac7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aca:	8b 50 08             	mov    0x8(%eax),%edx
  802acd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad0:	01 c2                	add    %eax,%edx
  802ad2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad5:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802ad8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802adb:	8b 40 0c             	mov    0xc(%eax),%eax
  802ade:	2b 45 08             	sub    0x8(%ebp),%eax
  802ae1:	89 c2                	mov    %eax,%edx
  802ae3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae6:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802ae9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aec:	e9 24 02 00 00       	jmp    802d15 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802af1:	a1 40 51 80 00       	mov    0x805140,%eax
  802af6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802af9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802afd:	74 07                	je     802b06 <alloc_block_NF+0x3bc>
  802aff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b02:	8b 00                	mov    (%eax),%eax
  802b04:	eb 05                	jmp    802b0b <alloc_block_NF+0x3c1>
  802b06:	b8 00 00 00 00       	mov    $0x0,%eax
  802b0b:	a3 40 51 80 00       	mov    %eax,0x805140
  802b10:	a1 40 51 80 00       	mov    0x805140,%eax
  802b15:	85 c0                	test   %eax,%eax
  802b17:	0f 85 2b fe ff ff    	jne    802948 <alloc_block_NF+0x1fe>
  802b1d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b21:	0f 85 21 fe ff ff    	jne    802948 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b27:	a1 38 51 80 00       	mov    0x805138,%eax
  802b2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b2f:	e9 ae 01 00 00       	jmp    802ce2 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802b34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b37:	8b 50 08             	mov    0x8(%eax),%edx
  802b3a:	a1 28 50 80 00       	mov    0x805028,%eax
  802b3f:	39 c2                	cmp    %eax,%edx
  802b41:	0f 83 93 01 00 00    	jae    802cda <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802b47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4a:	8b 40 0c             	mov    0xc(%eax),%eax
  802b4d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b50:	0f 82 84 01 00 00    	jb     802cda <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802b56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b59:	8b 40 0c             	mov    0xc(%eax),%eax
  802b5c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b5f:	0f 85 95 00 00 00    	jne    802bfa <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802b65:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b69:	75 17                	jne    802b82 <alloc_block_NF+0x438>
  802b6b:	83 ec 04             	sub    $0x4,%esp
  802b6e:	68 68 40 80 00       	push   $0x804068
  802b73:	68 14 01 00 00       	push   $0x114
  802b78:	68 bf 3f 80 00       	push   $0x803fbf
  802b7d:	e8 0e d8 ff ff       	call   800390 <_panic>
  802b82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b85:	8b 00                	mov    (%eax),%eax
  802b87:	85 c0                	test   %eax,%eax
  802b89:	74 10                	je     802b9b <alloc_block_NF+0x451>
  802b8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8e:	8b 00                	mov    (%eax),%eax
  802b90:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b93:	8b 52 04             	mov    0x4(%edx),%edx
  802b96:	89 50 04             	mov    %edx,0x4(%eax)
  802b99:	eb 0b                	jmp    802ba6 <alloc_block_NF+0x45c>
  802b9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9e:	8b 40 04             	mov    0x4(%eax),%eax
  802ba1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ba6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba9:	8b 40 04             	mov    0x4(%eax),%eax
  802bac:	85 c0                	test   %eax,%eax
  802bae:	74 0f                	je     802bbf <alloc_block_NF+0x475>
  802bb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb3:	8b 40 04             	mov    0x4(%eax),%eax
  802bb6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bb9:	8b 12                	mov    (%edx),%edx
  802bbb:	89 10                	mov    %edx,(%eax)
  802bbd:	eb 0a                	jmp    802bc9 <alloc_block_NF+0x47f>
  802bbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc2:	8b 00                	mov    (%eax),%eax
  802bc4:	a3 38 51 80 00       	mov    %eax,0x805138
  802bc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bdc:	a1 44 51 80 00       	mov    0x805144,%eax
  802be1:	48                   	dec    %eax
  802be2:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802be7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bea:	8b 40 08             	mov    0x8(%eax),%eax
  802bed:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802bf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf5:	e9 1b 01 00 00       	jmp    802d15 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802bfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfd:	8b 40 0c             	mov    0xc(%eax),%eax
  802c00:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c03:	0f 86 d1 00 00 00    	jbe    802cda <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802c09:	a1 48 51 80 00       	mov    0x805148,%eax
  802c0e:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802c11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c14:	8b 50 08             	mov    0x8(%eax),%edx
  802c17:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c1a:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802c1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c20:	8b 55 08             	mov    0x8(%ebp),%edx
  802c23:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802c26:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c2a:	75 17                	jne    802c43 <alloc_block_NF+0x4f9>
  802c2c:	83 ec 04             	sub    $0x4,%esp
  802c2f:	68 68 40 80 00       	push   $0x804068
  802c34:	68 1c 01 00 00       	push   $0x11c
  802c39:	68 bf 3f 80 00       	push   $0x803fbf
  802c3e:	e8 4d d7 ff ff       	call   800390 <_panic>
  802c43:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c46:	8b 00                	mov    (%eax),%eax
  802c48:	85 c0                	test   %eax,%eax
  802c4a:	74 10                	je     802c5c <alloc_block_NF+0x512>
  802c4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c4f:	8b 00                	mov    (%eax),%eax
  802c51:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c54:	8b 52 04             	mov    0x4(%edx),%edx
  802c57:	89 50 04             	mov    %edx,0x4(%eax)
  802c5a:	eb 0b                	jmp    802c67 <alloc_block_NF+0x51d>
  802c5c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c5f:	8b 40 04             	mov    0x4(%eax),%eax
  802c62:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c67:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c6a:	8b 40 04             	mov    0x4(%eax),%eax
  802c6d:	85 c0                	test   %eax,%eax
  802c6f:	74 0f                	je     802c80 <alloc_block_NF+0x536>
  802c71:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c74:	8b 40 04             	mov    0x4(%eax),%eax
  802c77:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c7a:	8b 12                	mov    (%edx),%edx
  802c7c:	89 10                	mov    %edx,(%eax)
  802c7e:	eb 0a                	jmp    802c8a <alloc_block_NF+0x540>
  802c80:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c83:	8b 00                	mov    (%eax),%eax
  802c85:	a3 48 51 80 00       	mov    %eax,0x805148
  802c8a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c8d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c93:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c96:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c9d:	a1 54 51 80 00       	mov    0x805154,%eax
  802ca2:	48                   	dec    %eax
  802ca3:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802ca8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cab:	8b 40 08             	mov    0x8(%eax),%eax
  802cae:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802cb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb6:	8b 50 08             	mov    0x8(%eax),%edx
  802cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbc:	01 c2                	add    %eax,%edx
  802cbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc1:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802cc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc7:	8b 40 0c             	mov    0xc(%eax),%eax
  802cca:	2b 45 08             	sub    0x8(%ebp),%eax
  802ccd:	89 c2                	mov    %eax,%edx
  802ccf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd2:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802cd5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cd8:	eb 3b                	jmp    802d15 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802cda:	a1 40 51 80 00       	mov    0x805140,%eax
  802cdf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ce2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ce6:	74 07                	je     802cef <alloc_block_NF+0x5a5>
  802ce8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ceb:	8b 00                	mov    (%eax),%eax
  802ced:	eb 05                	jmp    802cf4 <alloc_block_NF+0x5aa>
  802cef:	b8 00 00 00 00       	mov    $0x0,%eax
  802cf4:	a3 40 51 80 00       	mov    %eax,0x805140
  802cf9:	a1 40 51 80 00       	mov    0x805140,%eax
  802cfe:	85 c0                	test   %eax,%eax
  802d00:	0f 85 2e fe ff ff    	jne    802b34 <alloc_block_NF+0x3ea>
  802d06:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d0a:	0f 85 24 fe ff ff    	jne    802b34 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802d10:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d15:	c9                   	leave  
  802d16:	c3                   	ret    

00802d17 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802d17:	55                   	push   %ebp
  802d18:	89 e5                	mov    %esp,%ebp
  802d1a:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802d1d:	a1 38 51 80 00       	mov    0x805138,%eax
  802d22:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802d25:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802d2a:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802d2d:	a1 38 51 80 00       	mov    0x805138,%eax
  802d32:	85 c0                	test   %eax,%eax
  802d34:	74 14                	je     802d4a <insert_sorted_with_merge_freeList+0x33>
  802d36:	8b 45 08             	mov    0x8(%ebp),%eax
  802d39:	8b 50 08             	mov    0x8(%eax),%edx
  802d3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d3f:	8b 40 08             	mov    0x8(%eax),%eax
  802d42:	39 c2                	cmp    %eax,%edx
  802d44:	0f 87 9b 01 00 00    	ja     802ee5 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802d4a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d4e:	75 17                	jne    802d67 <insert_sorted_with_merge_freeList+0x50>
  802d50:	83 ec 04             	sub    $0x4,%esp
  802d53:	68 9c 3f 80 00       	push   $0x803f9c
  802d58:	68 38 01 00 00       	push   $0x138
  802d5d:	68 bf 3f 80 00       	push   $0x803fbf
  802d62:	e8 29 d6 ff ff       	call   800390 <_panic>
  802d67:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d70:	89 10                	mov    %edx,(%eax)
  802d72:	8b 45 08             	mov    0x8(%ebp),%eax
  802d75:	8b 00                	mov    (%eax),%eax
  802d77:	85 c0                	test   %eax,%eax
  802d79:	74 0d                	je     802d88 <insert_sorted_with_merge_freeList+0x71>
  802d7b:	a1 38 51 80 00       	mov    0x805138,%eax
  802d80:	8b 55 08             	mov    0x8(%ebp),%edx
  802d83:	89 50 04             	mov    %edx,0x4(%eax)
  802d86:	eb 08                	jmp    802d90 <insert_sorted_with_merge_freeList+0x79>
  802d88:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d90:	8b 45 08             	mov    0x8(%ebp),%eax
  802d93:	a3 38 51 80 00       	mov    %eax,0x805138
  802d98:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802da2:	a1 44 51 80 00       	mov    0x805144,%eax
  802da7:	40                   	inc    %eax
  802da8:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802dad:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802db1:	0f 84 a8 06 00 00    	je     80345f <insert_sorted_with_merge_freeList+0x748>
  802db7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dba:	8b 50 08             	mov    0x8(%eax),%edx
  802dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc0:	8b 40 0c             	mov    0xc(%eax),%eax
  802dc3:	01 c2                	add    %eax,%edx
  802dc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc8:	8b 40 08             	mov    0x8(%eax),%eax
  802dcb:	39 c2                	cmp    %eax,%edx
  802dcd:	0f 85 8c 06 00 00    	jne    80345f <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802dd3:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd6:	8b 50 0c             	mov    0xc(%eax),%edx
  802dd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ddc:	8b 40 0c             	mov    0xc(%eax),%eax
  802ddf:	01 c2                	add    %eax,%edx
  802de1:	8b 45 08             	mov    0x8(%ebp),%eax
  802de4:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802de7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802deb:	75 17                	jne    802e04 <insert_sorted_with_merge_freeList+0xed>
  802ded:	83 ec 04             	sub    $0x4,%esp
  802df0:	68 68 40 80 00       	push   $0x804068
  802df5:	68 3c 01 00 00       	push   $0x13c
  802dfa:	68 bf 3f 80 00       	push   $0x803fbf
  802dff:	e8 8c d5 ff ff       	call   800390 <_panic>
  802e04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e07:	8b 00                	mov    (%eax),%eax
  802e09:	85 c0                	test   %eax,%eax
  802e0b:	74 10                	je     802e1d <insert_sorted_with_merge_freeList+0x106>
  802e0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e10:	8b 00                	mov    (%eax),%eax
  802e12:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e15:	8b 52 04             	mov    0x4(%edx),%edx
  802e18:	89 50 04             	mov    %edx,0x4(%eax)
  802e1b:	eb 0b                	jmp    802e28 <insert_sorted_with_merge_freeList+0x111>
  802e1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e20:	8b 40 04             	mov    0x4(%eax),%eax
  802e23:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e2b:	8b 40 04             	mov    0x4(%eax),%eax
  802e2e:	85 c0                	test   %eax,%eax
  802e30:	74 0f                	je     802e41 <insert_sorted_with_merge_freeList+0x12a>
  802e32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e35:	8b 40 04             	mov    0x4(%eax),%eax
  802e38:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e3b:	8b 12                	mov    (%edx),%edx
  802e3d:	89 10                	mov    %edx,(%eax)
  802e3f:	eb 0a                	jmp    802e4b <insert_sorted_with_merge_freeList+0x134>
  802e41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e44:	8b 00                	mov    (%eax),%eax
  802e46:	a3 38 51 80 00       	mov    %eax,0x805138
  802e4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e4e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e57:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e5e:	a1 44 51 80 00       	mov    0x805144,%eax
  802e63:	48                   	dec    %eax
  802e64:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802e69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e6c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802e73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e76:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802e7d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e81:	75 17                	jne    802e9a <insert_sorted_with_merge_freeList+0x183>
  802e83:	83 ec 04             	sub    $0x4,%esp
  802e86:	68 9c 3f 80 00       	push   $0x803f9c
  802e8b:	68 3f 01 00 00       	push   $0x13f
  802e90:	68 bf 3f 80 00       	push   $0x803fbf
  802e95:	e8 f6 d4 ff ff       	call   800390 <_panic>
  802e9a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802ea0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ea3:	89 10                	mov    %edx,(%eax)
  802ea5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ea8:	8b 00                	mov    (%eax),%eax
  802eaa:	85 c0                	test   %eax,%eax
  802eac:	74 0d                	je     802ebb <insert_sorted_with_merge_freeList+0x1a4>
  802eae:	a1 48 51 80 00       	mov    0x805148,%eax
  802eb3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802eb6:	89 50 04             	mov    %edx,0x4(%eax)
  802eb9:	eb 08                	jmp    802ec3 <insert_sorted_with_merge_freeList+0x1ac>
  802ebb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ebe:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ec3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ec6:	a3 48 51 80 00       	mov    %eax,0x805148
  802ecb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ece:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ed5:	a1 54 51 80 00       	mov    0x805154,%eax
  802eda:	40                   	inc    %eax
  802edb:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802ee0:	e9 7a 05 00 00       	jmp    80345f <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802ee5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee8:	8b 50 08             	mov    0x8(%eax),%edx
  802eeb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eee:	8b 40 08             	mov    0x8(%eax),%eax
  802ef1:	39 c2                	cmp    %eax,%edx
  802ef3:	0f 82 14 01 00 00    	jb     80300d <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802ef9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802efc:	8b 50 08             	mov    0x8(%eax),%edx
  802eff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f02:	8b 40 0c             	mov    0xc(%eax),%eax
  802f05:	01 c2                	add    %eax,%edx
  802f07:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0a:	8b 40 08             	mov    0x8(%eax),%eax
  802f0d:	39 c2                	cmp    %eax,%edx
  802f0f:	0f 85 90 00 00 00    	jne    802fa5 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802f15:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f18:	8b 50 0c             	mov    0xc(%eax),%edx
  802f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1e:	8b 40 0c             	mov    0xc(%eax),%eax
  802f21:	01 c2                	add    %eax,%edx
  802f23:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f26:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802f29:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802f33:	8b 45 08             	mov    0x8(%ebp),%eax
  802f36:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802f3d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f41:	75 17                	jne    802f5a <insert_sorted_with_merge_freeList+0x243>
  802f43:	83 ec 04             	sub    $0x4,%esp
  802f46:	68 9c 3f 80 00       	push   $0x803f9c
  802f4b:	68 49 01 00 00       	push   $0x149
  802f50:	68 bf 3f 80 00       	push   $0x803fbf
  802f55:	e8 36 d4 ff ff       	call   800390 <_panic>
  802f5a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f60:	8b 45 08             	mov    0x8(%ebp),%eax
  802f63:	89 10                	mov    %edx,(%eax)
  802f65:	8b 45 08             	mov    0x8(%ebp),%eax
  802f68:	8b 00                	mov    (%eax),%eax
  802f6a:	85 c0                	test   %eax,%eax
  802f6c:	74 0d                	je     802f7b <insert_sorted_with_merge_freeList+0x264>
  802f6e:	a1 48 51 80 00       	mov    0x805148,%eax
  802f73:	8b 55 08             	mov    0x8(%ebp),%edx
  802f76:	89 50 04             	mov    %edx,0x4(%eax)
  802f79:	eb 08                	jmp    802f83 <insert_sorted_with_merge_freeList+0x26c>
  802f7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f83:	8b 45 08             	mov    0x8(%ebp),%eax
  802f86:	a3 48 51 80 00       	mov    %eax,0x805148
  802f8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f95:	a1 54 51 80 00       	mov    0x805154,%eax
  802f9a:	40                   	inc    %eax
  802f9b:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802fa0:	e9 bb 04 00 00       	jmp    803460 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802fa5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fa9:	75 17                	jne    802fc2 <insert_sorted_with_merge_freeList+0x2ab>
  802fab:	83 ec 04             	sub    $0x4,%esp
  802fae:	68 10 40 80 00       	push   $0x804010
  802fb3:	68 4c 01 00 00       	push   $0x14c
  802fb8:	68 bf 3f 80 00       	push   $0x803fbf
  802fbd:	e8 ce d3 ff ff       	call   800390 <_panic>
  802fc2:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  802fcb:	89 50 04             	mov    %edx,0x4(%eax)
  802fce:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd1:	8b 40 04             	mov    0x4(%eax),%eax
  802fd4:	85 c0                	test   %eax,%eax
  802fd6:	74 0c                	je     802fe4 <insert_sorted_with_merge_freeList+0x2cd>
  802fd8:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802fdd:	8b 55 08             	mov    0x8(%ebp),%edx
  802fe0:	89 10                	mov    %edx,(%eax)
  802fe2:	eb 08                	jmp    802fec <insert_sorted_with_merge_freeList+0x2d5>
  802fe4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe7:	a3 38 51 80 00       	mov    %eax,0x805138
  802fec:	8b 45 08             	mov    0x8(%ebp),%eax
  802fef:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ffd:	a1 44 51 80 00       	mov    0x805144,%eax
  803002:	40                   	inc    %eax
  803003:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803008:	e9 53 04 00 00       	jmp    803460 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80300d:	a1 38 51 80 00       	mov    0x805138,%eax
  803012:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803015:	e9 15 04 00 00       	jmp    80342f <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  80301a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80301d:	8b 00                	mov    (%eax),%eax
  80301f:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803022:	8b 45 08             	mov    0x8(%ebp),%eax
  803025:	8b 50 08             	mov    0x8(%eax),%edx
  803028:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80302b:	8b 40 08             	mov    0x8(%eax),%eax
  80302e:	39 c2                	cmp    %eax,%edx
  803030:	0f 86 f1 03 00 00    	jbe    803427 <insert_sorted_with_merge_freeList+0x710>
  803036:	8b 45 08             	mov    0x8(%ebp),%eax
  803039:	8b 50 08             	mov    0x8(%eax),%edx
  80303c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80303f:	8b 40 08             	mov    0x8(%eax),%eax
  803042:	39 c2                	cmp    %eax,%edx
  803044:	0f 83 dd 03 00 00    	jae    803427 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  80304a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304d:	8b 50 08             	mov    0x8(%eax),%edx
  803050:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803053:	8b 40 0c             	mov    0xc(%eax),%eax
  803056:	01 c2                	add    %eax,%edx
  803058:	8b 45 08             	mov    0x8(%ebp),%eax
  80305b:	8b 40 08             	mov    0x8(%eax),%eax
  80305e:	39 c2                	cmp    %eax,%edx
  803060:	0f 85 b9 01 00 00    	jne    80321f <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803066:	8b 45 08             	mov    0x8(%ebp),%eax
  803069:	8b 50 08             	mov    0x8(%eax),%edx
  80306c:	8b 45 08             	mov    0x8(%ebp),%eax
  80306f:	8b 40 0c             	mov    0xc(%eax),%eax
  803072:	01 c2                	add    %eax,%edx
  803074:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803077:	8b 40 08             	mov    0x8(%eax),%eax
  80307a:	39 c2                	cmp    %eax,%edx
  80307c:	0f 85 0d 01 00 00    	jne    80318f <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803082:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803085:	8b 50 0c             	mov    0xc(%eax),%edx
  803088:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80308b:	8b 40 0c             	mov    0xc(%eax),%eax
  80308e:	01 c2                	add    %eax,%edx
  803090:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803093:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803096:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80309a:	75 17                	jne    8030b3 <insert_sorted_with_merge_freeList+0x39c>
  80309c:	83 ec 04             	sub    $0x4,%esp
  80309f:	68 68 40 80 00       	push   $0x804068
  8030a4:	68 5c 01 00 00       	push   $0x15c
  8030a9:	68 bf 3f 80 00       	push   $0x803fbf
  8030ae:	e8 dd d2 ff ff       	call   800390 <_panic>
  8030b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030b6:	8b 00                	mov    (%eax),%eax
  8030b8:	85 c0                	test   %eax,%eax
  8030ba:	74 10                	je     8030cc <insert_sorted_with_merge_freeList+0x3b5>
  8030bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030bf:	8b 00                	mov    (%eax),%eax
  8030c1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030c4:	8b 52 04             	mov    0x4(%edx),%edx
  8030c7:	89 50 04             	mov    %edx,0x4(%eax)
  8030ca:	eb 0b                	jmp    8030d7 <insert_sorted_with_merge_freeList+0x3c0>
  8030cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030cf:	8b 40 04             	mov    0x4(%eax),%eax
  8030d2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030da:	8b 40 04             	mov    0x4(%eax),%eax
  8030dd:	85 c0                	test   %eax,%eax
  8030df:	74 0f                	je     8030f0 <insert_sorted_with_merge_freeList+0x3d9>
  8030e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030e4:	8b 40 04             	mov    0x4(%eax),%eax
  8030e7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030ea:	8b 12                	mov    (%edx),%edx
  8030ec:	89 10                	mov    %edx,(%eax)
  8030ee:	eb 0a                	jmp    8030fa <insert_sorted_with_merge_freeList+0x3e3>
  8030f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030f3:	8b 00                	mov    (%eax),%eax
  8030f5:	a3 38 51 80 00       	mov    %eax,0x805138
  8030fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030fd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803103:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803106:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80310d:	a1 44 51 80 00       	mov    0x805144,%eax
  803112:	48                   	dec    %eax
  803113:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803118:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80311b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803122:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803125:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80312c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803130:	75 17                	jne    803149 <insert_sorted_with_merge_freeList+0x432>
  803132:	83 ec 04             	sub    $0x4,%esp
  803135:	68 9c 3f 80 00       	push   $0x803f9c
  80313a:	68 5f 01 00 00       	push   $0x15f
  80313f:	68 bf 3f 80 00       	push   $0x803fbf
  803144:	e8 47 d2 ff ff       	call   800390 <_panic>
  803149:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80314f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803152:	89 10                	mov    %edx,(%eax)
  803154:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803157:	8b 00                	mov    (%eax),%eax
  803159:	85 c0                	test   %eax,%eax
  80315b:	74 0d                	je     80316a <insert_sorted_with_merge_freeList+0x453>
  80315d:	a1 48 51 80 00       	mov    0x805148,%eax
  803162:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803165:	89 50 04             	mov    %edx,0x4(%eax)
  803168:	eb 08                	jmp    803172 <insert_sorted_with_merge_freeList+0x45b>
  80316a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80316d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803172:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803175:	a3 48 51 80 00       	mov    %eax,0x805148
  80317a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80317d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803184:	a1 54 51 80 00       	mov    0x805154,%eax
  803189:	40                   	inc    %eax
  80318a:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  80318f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803192:	8b 50 0c             	mov    0xc(%eax),%edx
  803195:	8b 45 08             	mov    0x8(%ebp),%eax
  803198:	8b 40 0c             	mov    0xc(%eax),%eax
  80319b:	01 c2                	add    %eax,%edx
  80319d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a0:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8031a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8031ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8031b7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031bb:	75 17                	jne    8031d4 <insert_sorted_with_merge_freeList+0x4bd>
  8031bd:	83 ec 04             	sub    $0x4,%esp
  8031c0:	68 9c 3f 80 00       	push   $0x803f9c
  8031c5:	68 64 01 00 00       	push   $0x164
  8031ca:	68 bf 3f 80 00       	push   $0x803fbf
  8031cf:	e8 bc d1 ff ff       	call   800390 <_panic>
  8031d4:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031da:	8b 45 08             	mov    0x8(%ebp),%eax
  8031dd:	89 10                	mov    %edx,(%eax)
  8031df:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e2:	8b 00                	mov    (%eax),%eax
  8031e4:	85 c0                	test   %eax,%eax
  8031e6:	74 0d                	je     8031f5 <insert_sorted_with_merge_freeList+0x4de>
  8031e8:	a1 48 51 80 00       	mov    0x805148,%eax
  8031ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8031f0:	89 50 04             	mov    %edx,0x4(%eax)
  8031f3:	eb 08                	jmp    8031fd <insert_sorted_with_merge_freeList+0x4e6>
  8031f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803200:	a3 48 51 80 00       	mov    %eax,0x805148
  803205:	8b 45 08             	mov    0x8(%ebp),%eax
  803208:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80320f:	a1 54 51 80 00       	mov    0x805154,%eax
  803214:	40                   	inc    %eax
  803215:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80321a:	e9 41 02 00 00       	jmp    803460 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80321f:	8b 45 08             	mov    0x8(%ebp),%eax
  803222:	8b 50 08             	mov    0x8(%eax),%edx
  803225:	8b 45 08             	mov    0x8(%ebp),%eax
  803228:	8b 40 0c             	mov    0xc(%eax),%eax
  80322b:	01 c2                	add    %eax,%edx
  80322d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803230:	8b 40 08             	mov    0x8(%eax),%eax
  803233:	39 c2                	cmp    %eax,%edx
  803235:	0f 85 7c 01 00 00    	jne    8033b7 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  80323b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80323f:	74 06                	je     803247 <insert_sorted_with_merge_freeList+0x530>
  803241:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803245:	75 17                	jne    80325e <insert_sorted_with_merge_freeList+0x547>
  803247:	83 ec 04             	sub    $0x4,%esp
  80324a:	68 d8 3f 80 00       	push   $0x803fd8
  80324f:	68 69 01 00 00       	push   $0x169
  803254:	68 bf 3f 80 00       	push   $0x803fbf
  803259:	e8 32 d1 ff ff       	call   800390 <_panic>
  80325e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803261:	8b 50 04             	mov    0x4(%eax),%edx
  803264:	8b 45 08             	mov    0x8(%ebp),%eax
  803267:	89 50 04             	mov    %edx,0x4(%eax)
  80326a:	8b 45 08             	mov    0x8(%ebp),%eax
  80326d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803270:	89 10                	mov    %edx,(%eax)
  803272:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803275:	8b 40 04             	mov    0x4(%eax),%eax
  803278:	85 c0                	test   %eax,%eax
  80327a:	74 0d                	je     803289 <insert_sorted_with_merge_freeList+0x572>
  80327c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80327f:	8b 40 04             	mov    0x4(%eax),%eax
  803282:	8b 55 08             	mov    0x8(%ebp),%edx
  803285:	89 10                	mov    %edx,(%eax)
  803287:	eb 08                	jmp    803291 <insert_sorted_with_merge_freeList+0x57a>
  803289:	8b 45 08             	mov    0x8(%ebp),%eax
  80328c:	a3 38 51 80 00       	mov    %eax,0x805138
  803291:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803294:	8b 55 08             	mov    0x8(%ebp),%edx
  803297:	89 50 04             	mov    %edx,0x4(%eax)
  80329a:	a1 44 51 80 00       	mov    0x805144,%eax
  80329f:	40                   	inc    %eax
  8032a0:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8032a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a8:	8b 50 0c             	mov    0xc(%eax),%edx
  8032ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ae:	8b 40 0c             	mov    0xc(%eax),%eax
  8032b1:	01 c2                	add    %eax,%edx
  8032b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b6:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8032b9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032bd:	75 17                	jne    8032d6 <insert_sorted_with_merge_freeList+0x5bf>
  8032bf:	83 ec 04             	sub    $0x4,%esp
  8032c2:	68 68 40 80 00       	push   $0x804068
  8032c7:	68 6b 01 00 00       	push   $0x16b
  8032cc:	68 bf 3f 80 00       	push   $0x803fbf
  8032d1:	e8 ba d0 ff ff       	call   800390 <_panic>
  8032d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d9:	8b 00                	mov    (%eax),%eax
  8032db:	85 c0                	test   %eax,%eax
  8032dd:	74 10                	je     8032ef <insert_sorted_with_merge_freeList+0x5d8>
  8032df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032e2:	8b 00                	mov    (%eax),%eax
  8032e4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032e7:	8b 52 04             	mov    0x4(%edx),%edx
  8032ea:	89 50 04             	mov    %edx,0x4(%eax)
  8032ed:	eb 0b                	jmp    8032fa <insert_sorted_with_merge_freeList+0x5e3>
  8032ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032f2:	8b 40 04             	mov    0x4(%eax),%eax
  8032f5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032fd:	8b 40 04             	mov    0x4(%eax),%eax
  803300:	85 c0                	test   %eax,%eax
  803302:	74 0f                	je     803313 <insert_sorted_with_merge_freeList+0x5fc>
  803304:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803307:	8b 40 04             	mov    0x4(%eax),%eax
  80330a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80330d:	8b 12                	mov    (%edx),%edx
  80330f:	89 10                	mov    %edx,(%eax)
  803311:	eb 0a                	jmp    80331d <insert_sorted_with_merge_freeList+0x606>
  803313:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803316:	8b 00                	mov    (%eax),%eax
  803318:	a3 38 51 80 00       	mov    %eax,0x805138
  80331d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803320:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803326:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803329:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803330:	a1 44 51 80 00       	mov    0x805144,%eax
  803335:	48                   	dec    %eax
  803336:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  80333b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80333e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803345:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803348:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80334f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803353:	75 17                	jne    80336c <insert_sorted_with_merge_freeList+0x655>
  803355:	83 ec 04             	sub    $0x4,%esp
  803358:	68 9c 3f 80 00       	push   $0x803f9c
  80335d:	68 6e 01 00 00       	push   $0x16e
  803362:	68 bf 3f 80 00       	push   $0x803fbf
  803367:	e8 24 d0 ff ff       	call   800390 <_panic>
  80336c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803372:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803375:	89 10                	mov    %edx,(%eax)
  803377:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80337a:	8b 00                	mov    (%eax),%eax
  80337c:	85 c0                	test   %eax,%eax
  80337e:	74 0d                	je     80338d <insert_sorted_with_merge_freeList+0x676>
  803380:	a1 48 51 80 00       	mov    0x805148,%eax
  803385:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803388:	89 50 04             	mov    %edx,0x4(%eax)
  80338b:	eb 08                	jmp    803395 <insert_sorted_with_merge_freeList+0x67e>
  80338d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803390:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803395:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803398:	a3 48 51 80 00       	mov    %eax,0x805148
  80339d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033a0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033a7:	a1 54 51 80 00       	mov    0x805154,%eax
  8033ac:	40                   	inc    %eax
  8033ad:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8033b2:	e9 a9 00 00 00       	jmp    803460 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8033b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033bb:	74 06                	je     8033c3 <insert_sorted_with_merge_freeList+0x6ac>
  8033bd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033c1:	75 17                	jne    8033da <insert_sorted_with_merge_freeList+0x6c3>
  8033c3:	83 ec 04             	sub    $0x4,%esp
  8033c6:	68 34 40 80 00       	push   $0x804034
  8033cb:	68 73 01 00 00       	push   $0x173
  8033d0:	68 bf 3f 80 00       	push   $0x803fbf
  8033d5:	e8 b6 cf ff ff       	call   800390 <_panic>
  8033da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033dd:	8b 10                	mov    (%eax),%edx
  8033df:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e2:	89 10                	mov    %edx,(%eax)
  8033e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e7:	8b 00                	mov    (%eax),%eax
  8033e9:	85 c0                	test   %eax,%eax
  8033eb:	74 0b                	je     8033f8 <insert_sorted_with_merge_freeList+0x6e1>
  8033ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f0:	8b 00                	mov    (%eax),%eax
  8033f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8033f5:	89 50 04             	mov    %edx,0x4(%eax)
  8033f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8033fe:	89 10                	mov    %edx,(%eax)
  803400:	8b 45 08             	mov    0x8(%ebp),%eax
  803403:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803406:	89 50 04             	mov    %edx,0x4(%eax)
  803409:	8b 45 08             	mov    0x8(%ebp),%eax
  80340c:	8b 00                	mov    (%eax),%eax
  80340e:	85 c0                	test   %eax,%eax
  803410:	75 08                	jne    80341a <insert_sorted_with_merge_freeList+0x703>
  803412:	8b 45 08             	mov    0x8(%ebp),%eax
  803415:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80341a:	a1 44 51 80 00       	mov    0x805144,%eax
  80341f:	40                   	inc    %eax
  803420:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803425:	eb 39                	jmp    803460 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803427:	a1 40 51 80 00       	mov    0x805140,%eax
  80342c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80342f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803433:	74 07                	je     80343c <insert_sorted_with_merge_freeList+0x725>
  803435:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803438:	8b 00                	mov    (%eax),%eax
  80343a:	eb 05                	jmp    803441 <insert_sorted_with_merge_freeList+0x72a>
  80343c:	b8 00 00 00 00       	mov    $0x0,%eax
  803441:	a3 40 51 80 00       	mov    %eax,0x805140
  803446:	a1 40 51 80 00       	mov    0x805140,%eax
  80344b:	85 c0                	test   %eax,%eax
  80344d:	0f 85 c7 fb ff ff    	jne    80301a <insert_sorted_with_merge_freeList+0x303>
  803453:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803457:	0f 85 bd fb ff ff    	jne    80301a <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80345d:	eb 01                	jmp    803460 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80345f:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803460:	90                   	nop
  803461:	c9                   	leave  
  803462:	c3                   	ret    
  803463:	90                   	nop

00803464 <__udivdi3>:
  803464:	55                   	push   %ebp
  803465:	57                   	push   %edi
  803466:	56                   	push   %esi
  803467:	53                   	push   %ebx
  803468:	83 ec 1c             	sub    $0x1c,%esp
  80346b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80346f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803473:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803477:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80347b:	89 ca                	mov    %ecx,%edx
  80347d:	89 f8                	mov    %edi,%eax
  80347f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803483:	85 f6                	test   %esi,%esi
  803485:	75 2d                	jne    8034b4 <__udivdi3+0x50>
  803487:	39 cf                	cmp    %ecx,%edi
  803489:	77 65                	ja     8034f0 <__udivdi3+0x8c>
  80348b:	89 fd                	mov    %edi,%ebp
  80348d:	85 ff                	test   %edi,%edi
  80348f:	75 0b                	jne    80349c <__udivdi3+0x38>
  803491:	b8 01 00 00 00       	mov    $0x1,%eax
  803496:	31 d2                	xor    %edx,%edx
  803498:	f7 f7                	div    %edi
  80349a:	89 c5                	mov    %eax,%ebp
  80349c:	31 d2                	xor    %edx,%edx
  80349e:	89 c8                	mov    %ecx,%eax
  8034a0:	f7 f5                	div    %ebp
  8034a2:	89 c1                	mov    %eax,%ecx
  8034a4:	89 d8                	mov    %ebx,%eax
  8034a6:	f7 f5                	div    %ebp
  8034a8:	89 cf                	mov    %ecx,%edi
  8034aa:	89 fa                	mov    %edi,%edx
  8034ac:	83 c4 1c             	add    $0x1c,%esp
  8034af:	5b                   	pop    %ebx
  8034b0:	5e                   	pop    %esi
  8034b1:	5f                   	pop    %edi
  8034b2:	5d                   	pop    %ebp
  8034b3:	c3                   	ret    
  8034b4:	39 ce                	cmp    %ecx,%esi
  8034b6:	77 28                	ja     8034e0 <__udivdi3+0x7c>
  8034b8:	0f bd fe             	bsr    %esi,%edi
  8034bb:	83 f7 1f             	xor    $0x1f,%edi
  8034be:	75 40                	jne    803500 <__udivdi3+0x9c>
  8034c0:	39 ce                	cmp    %ecx,%esi
  8034c2:	72 0a                	jb     8034ce <__udivdi3+0x6a>
  8034c4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8034c8:	0f 87 9e 00 00 00    	ja     80356c <__udivdi3+0x108>
  8034ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8034d3:	89 fa                	mov    %edi,%edx
  8034d5:	83 c4 1c             	add    $0x1c,%esp
  8034d8:	5b                   	pop    %ebx
  8034d9:	5e                   	pop    %esi
  8034da:	5f                   	pop    %edi
  8034db:	5d                   	pop    %ebp
  8034dc:	c3                   	ret    
  8034dd:	8d 76 00             	lea    0x0(%esi),%esi
  8034e0:	31 ff                	xor    %edi,%edi
  8034e2:	31 c0                	xor    %eax,%eax
  8034e4:	89 fa                	mov    %edi,%edx
  8034e6:	83 c4 1c             	add    $0x1c,%esp
  8034e9:	5b                   	pop    %ebx
  8034ea:	5e                   	pop    %esi
  8034eb:	5f                   	pop    %edi
  8034ec:	5d                   	pop    %ebp
  8034ed:	c3                   	ret    
  8034ee:	66 90                	xchg   %ax,%ax
  8034f0:	89 d8                	mov    %ebx,%eax
  8034f2:	f7 f7                	div    %edi
  8034f4:	31 ff                	xor    %edi,%edi
  8034f6:	89 fa                	mov    %edi,%edx
  8034f8:	83 c4 1c             	add    $0x1c,%esp
  8034fb:	5b                   	pop    %ebx
  8034fc:	5e                   	pop    %esi
  8034fd:	5f                   	pop    %edi
  8034fe:	5d                   	pop    %ebp
  8034ff:	c3                   	ret    
  803500:	bd 20 00 00 00       	mov    $0x20,%ebp
  803505:	89 eb                	mov    %ebp,%ebx
  803507:	29 fb                	sub    %edi,%ebx
  803509:	89 f9                	mov    %edi,%ecx
  80350b:	d3 e6                	shl    %cl,%esi
  80350d:	89 c5                	mov    %eax,%ebp
  80350f:	88 d9                	mov    %bl,%cl
  803511:	d3 ed                	shr    %cl,%ebp
  803513:	89 e9                	mov    %ebp,%ecx
  803515:	09 f1                	or     %esi,%ecx
  803517:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80351b:	89 f9                	mov    %edi,%ecx
  80351d:	d3 e0                	shl    %cl,%eax
  80351f:	89 c5                	mov    %eax,%ebp
  803521:	89 d6                	mov    %edx,%esi
  803523:	88 d9                	mov    %bl,%cl
  803525:	d3 ee                	shr    %cl,%esi
  803527:	89 f9                	mov    %edi,%ecx
  803529:	d3 e2                	shl    %cl,%edx
  80352b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80352f:	88 d9                	mov    %bl,%cl
  803531:	d3 e8                	shr    %cl,%eax
  803533:	09 c2                	or     %eax,%edx
  803535:	89 d0                	mov    %edx,%eax
  803537:	89 f2                	mov    %esi,%edx
  803539:	f7 74 24 0c          	divl   0xc(%esp)
  80353d:	89 d6                	mov    %edx,%esi
  80353f:	89 c3                	mov    %eax,%ebx
  803541:	f7 e5                	mul    %ebp
  803543:	39 d6                	cmp    %edx,%esi
  803545:	72 19                	jb     803560 <__udivdi3+0xfc>
  803547:	74 0b                	je     803554 <__udivdi3+0xf0>
  803549:	89 d8                	mov    %ebx,%eax
  80354b:	31 ff                	xor    %edi,%edi
  80354d:	e9 58 ff ff ff       	jmp    8034aa <__udivdi3+0x46>
  803552:	66 90                	xchg   %ax,%ax
  803554:	8b 54 24 08          	mov    0x8(%esp),%edx
  803558:	89 f9                	mov    %edi,%ecx
  80355a:	d3 e2                	shl    %cl,%edx
  80355c:	39 c2                	cmp    %eax,%edx
  80355e:	73 e9                	jae    803549 <__udivdi3+0xe5>
  803560:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803563:	31 ff                	xor    %edi,%edi
  803565:	e9 40 ff ff ff       	jmp    8034aa <__udivdi3+0x46>
  80356a:	66 90                	xchg   %ax,%ax
  80356c:	31 c0                	xor    %eax,%eax
  80356e:	e9 37 ff ff ff       	jmp    8034aa <__udivdi3+0x46>
  803573:	90                   	nop

00803574 <__umoddi3>:
  803574:	55                   	push   %ebp
  803575:	57                   	push   %edi
  803576:	56                   	push   %esi
  803577:	53                   	push   %ebx
  803578:	83 ec 1c             	sub    $0x1c,%esp
  80357b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80357f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803583:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803587:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80358b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80358f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803593:	89 f3                	mov    %esi,%ebx
  803595:	89 fa                	mov    %edi,%edx
  803597:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80359b:	89 34 24             	mov    %esi,(%esp)
  80359e:	85 c0                	test   %eax,%eax
  8035a0:	75 1a                	jne    8035bc <__umoddi3+0x48>
  8035a2:	39 f7                	cmp    %esi,%edi
  8035a4:	0f 86 a2 00 00 00    	jbe    80364c <__umoddi3+0xd8>
  8035aa:	89 c8                	mov    %ecx,%eax
  8035ac:	89 f2                	mov    %esi,%edx
  8035ae:	f7 f7                	div    %edi
  8035b0:	89 d0                	mov    %edx,%eax
  8035b2:	31 d2                	xor    %edx,%edx
  8035b4:	83 c4 1c             	add    $0x1c,%esp
  8035b7:	5b                   	pop    %ebx
  8035b8:	5e                   	pop    %esi
  8035b9:	5f                   	pop    %edi
  8035ba:	5d                   	pop    %ebp
  8035bb:	c3                   	ret    
  8035bc:	39 f0                	cmp    %esi,%eax
  8035be:	0f 87 ac 00 00 00    	ja     803670 <__umoddi3+0xfc>
  8035c4:	0f bd e8             	bsr    %eax,%ebp
  8035c7:	83 f5 1f             	xor    $0x1f,%ebp
  8035ca:	0f 84 ac 00 00 00    	je     80367c <__umoddi3+0x108>
  8035d0:	bf 20 00 00 00       	mov    $0x20,%edi
  8035d5:	29 ef                	sub    %ebp,%edi
  8035d7:	89 fe                	mov    %edi,%esi
  8035d9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8035dd:	89 e9                	mov    %ebp,%ecx
  8035df:	d3 e0                	shl    %cl,%eax
  8035e1:	89 d7                	mov    %edx,%edi
  8035e3:	89 f1                	mov    %esi,%ecx
  8035e5:	d3 ef                	shr    %cl,%edi
  8035e7:	09 c7                	or     %eax,%edi
  8035e9:	89 e9                	mov    %ebp,%ecx
  8035eb:	d3 e2                	shl    %cl,%edx
  8035ed:	89 14 24             	mov    %edx,(%esp)
  8035f0:	89 d8                	mov    %ebx,%eax
  8035f2:	d3 e0                	shl    %cl,%eax
  8035f4:	89 c2                	mov    %eax,%edx
  8035f6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035fa:	d3 e0                	shl    %cl,%eax
  8035fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  803600:	8b 44 24 08          	mov    0x8(%esp),%eax
  803604:	89 f1                	mov    %esi,%ecx
  803606:	d3 e8                	shr    %cl,%eax
  803608:	09 d0                	or     %edx,%eax
  80360a:	d3 eb                	shr    %cl,%ebx
  80360c:	89 da                	mov    %ebx,%edx
  80360e:	f7 f7                	div    %edi
  803610:	89 d3                	mov    %edx,%ebx
  803612:	f7 24 24             	mull   (%esp)
  803615:	89 c6                	mov    %eax,%esi
  803617:	89 d1                	mov    %edx,%ecx
  803619:	39 d3                	cmp    %edx,%ebx
  80361b:	0f 82 87 00 00 00    	jb     8036a8 <__umoddi3+0x134>
  803621:	0f 84 91 00 00 00    	je     8036b8 <__umoddi3+0x144>
  803627:	8b 54 24 04          	mov    0x4(%esp),%edx
  80362b:	29 f2                	sub    %esi,%edx
  80362d:	19 cb                	sbb    %ecx,%ebx
  80362f:	89 d8                	mov    %ebx,%eax
  803631:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803635:	d3 e0                	shl    %cl,%eax
  803637:	89 e9                	mov    %ebp,%ecx
  803639:	d3 ea                	shr    %cl,%edx
  80363b:	09 d0                	or     %edx,%eax
  80363d:	89 e9                	mov    %ebp,%ecx
  80363f:	d3 eb                	shr    %cl,%ebx
  803641:	89 da                	mov    %ebx,%edx
  803643:	83 c4 1c             	add    $0x1c,%esp
  803646:	5b                   	pop    %ebx
  803647:	5e                   	pop    %esi
  803648:	5f                   	pop    %edi
  803649:	5d                   	pop    %ebp
  80364a:	c3                   	ret    
  80364b:	90                   	nop
  80364c:	89 fd                	mov    %edi,%ebp
  80364e:	85 ff                	test   %edi,%edi
  803650:	75 0b                	jne    80365d <__umoddi3+0xe9>
  803652:	b8 01 00 00 00       	mov    $0x1,%eax
  803657:	31 d2                	xor    %edx,%edx
  803659:	f7 f7                	div    %edi
  80365b:	89 c5                	mov    %eax,%ebp
  80365d:	89 f0                	mov    %esi,%eax
  80365f:	31 d2                	xor    %edx,%edx
  803661:	f7 f5                	div    %ebp
  803663:	89 c8                	mov    %ecx,%eax
  803665:	f7 f5                	div    %ebp
  803667:	89 d0                	mov    %edx,%eax
  803669:	e9 44 ff ff ff       	jmp    8035b2 <__umoddi3+0x3e>
  80366e:	66 90                	xchg   %ax,%ax
  803670:	89 c8                	mov    %ecx,%eax
  803672:	89 f2                	mov    %esi,%edx
  803674:	83 c4 1c             	add    $0x1c,%esp
  803677:	5b                   	pop    %ebx
  803678:	5e                   	pop    %esi
  803679:	5f                   	pop    %edi
  80367a:	5d                   	pop    %ebp
  80367b:	c3                   	ret    
  80367c:	3b 04 24             	cmp    (%esp),%eax
  80367f:	72 06                	jb     803687 <__umoddi3+0x113>
  803681:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803685:	77 0f                	ja     803696 <__umoddi3+0x122>
  803687:	89 f2                	mov    %esi,%edx
  803689:	29 f9                	sub    %edi,%ecx
  80368b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80368f:	89 14 24             	mov    %edx,(%esp)
  803692:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803696:	8b 44 24 04          	mov    0x4(%esp),%eax
  80369a:	8b 14 24             	mov    (%esp),%edx
  80369d:	83 c4 1c             	add    $0x1c,%esp
  8036a0:	5b                   	pop    %ebx
  8036a1:	5e                   	pop    %esi
  8036a2:	5f                   	pop    %edi
  8036a3:	5d                   	pop    %ebp
  8036a4:	c3                   	ret    
  8036a5:	8d 76 00             	lea    0x0(%esi),%esi
  8036a8:	2b 04 24             	sub    (%esp),%eax
  8036ab:	19 fa                	sbb    %edi,%edx
  8036ad:	89 d1                	mov    %edx,%ecx
  8036af:	89 c6                	mov    %eax,%esi
  8036b1:	e9 71 ff ff ff       	jmp    803627 <__umoddi3+0xb3>
  8036b6:	66 90                	xchg   %ax,%ax
  8036b8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8036bc:	72 ea                	jb     8036a8 <__umoddi3+0x134>
  8036be:	89 d9                	mov    %ebx,%ecx
  8036c0:	e9 62 ff ff ff       	jmp    803627 <__umoddi3+0xb3>
