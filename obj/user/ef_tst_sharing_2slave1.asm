
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
  80008d:	68 80 36 80 00       	push   $0x803680
  800092:	6a 13                	push   $0x13
  800094:	68 9c 36 80 00       	push   $0x80369c
  800099:	e8 f2 02 00 00       	call   800390 <_panic>
	}
	uint32 *x,*y,*z;
	int32 parentenvID = sys_getparentenvid();
  80009e:	e8 aa 1a 00 00       	call   801b4d <sys_getparentenvid>
  8000a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//GET: z then y then x, opposite to creation order (x then y then z)
	//So, addresses here will be different from the OWNER addresses
	sys_disable_interrupt();
  8000a6:	e8 96 18 00 00       	call   801941 <sys_disable_interrupt>
	int freeFrames = sys_calculate_free_frames() ;
  8000ab:	e8 a4 17 00 00       	call   801854 <sys_calculate_free_frames>
  8000b0:	89 45 e8             	mov    %eax,-0x18(%ebp)
	z = sget(parentenvID,"z");
  8000b3:	83 ec 08             	sub    $0x8,%esp
  8000b6:	68 ba 36 80 00       	push   $0x8036ba
  8000bb:	ff 75 ec             	pushl  -0x14(%ebp)
  8000be:	e8 ed 15 00 00       	call   8016b0 <sget>
  8000c3:	83 c4 10             	add    $0x10,%esp
  8000c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (z != (uint32*)(USER_HEAP_START + 0 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8000c9:	81 7d e4 00 00 00 80 	cmpl   $0x80000000,-0x1c(%ebp)
  8000d0:	74 14                	je     8000e6 <_main+0xae>
  8000d2:	83 ec 04             	sub    $0x4,%esp
  8000d5:	68 bc 36 80 00       	push   $0x8036bc
  8000da:	6a 1c                	push   $0x1c
  8000dc:	68 9c 36 80 00       	push   $0x80369c
  8000e1:	e8 aa 02 00 00       	call   800390 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  8000e6:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000e9:	e8 66 17 00 00       	call   801854 <sys_calculate_free_frames>
  8000ee:	29 c3                	sub    %eax,%ebx
  8000f0:	89 d8                	mov    %ebx,%eax
  8000f2:	83 f8 01             	cmp    $0x1,%eax
  8000f5:	74 14                	je     80010b <_main+0xd3>
  8000f7:	83 ec 04             	sub    $0x4,%esp
  8000fa:	68 1c 37 80 00       	push   $0x80371c
  8000ff:	6a 1d                	push   $0x1d
  800101:	68 9c 36 80 00       	push   $0x80369c
  800106:	e8 85 02 00 00       	call   800390 <_panic>
	sys_enable_interrupt();
  80010b:	e8 4b 18 00 00       	call   80195b <sys_enable_interrupt>

	sys_disable_interrupt();
  800110:	e8 2c 18 00 00       	call   801941 <sys_disable_interrupt>
	freeFrames = sys_calculate_free_frames() ;
  800115:	e8 3a 17 00 00       	call   801854 <sys_calculate_free_frames>
  80011a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	y = sget(parentenvID,"y");
  80011d:	83 ec 08             	sub    $0x8,%esp
  800120:	68 ad 37 80 00       	push   $0x8037ad
  800125:	ff 75 ec             	pushl  -0x14(%ebp)
  800128:	e8 83 15 00 00       	call   8016b0 <sget>
  80012d:	83 c4 10             	add    $0x10,%esp
  800130:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (y != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  800133:	81 7d e0 00 10 00 80 	cmpl   $0x80001000,-0x20(%ebp)
  80013a:	74 14                	je     800150 <_main+0x118>
  80013c:	83 ec 04             	sub    $0x4,%esp
  80013f:	68 bc 36 80 00       	push   $0x8036bc
  800144:	6a 23                	push   $0x23
  800146:	68 9c 36 80 00       	push   $0x80369c
  80014b:	e8 40 02 00 00       	call   800390 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  800150:	e8 ff 16 00 00       	call   801854 <sys_calculate_free_frames>
  800155:	89 c2                	mov    %eax,%edx
  800157:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80015a:	39 c2                	cmp    %eax,%edx
  80015c:	74 14                	je     800172 <_main+0x13a>
  80015e:	83 ec 04             	sub    $0x4,%esp
  800161:	68 1c 37 80 00       	push   $0x80371c
  800166:	6a 24                	push   $0x24
  800168:	68 9c 36 80 00       	push   $0x80369c
  80016d:	e8 1e 02 00 00       	call   800390 <_panic>
	sys_enable_interrupt();
  800172:	e8 e4 17 00 00       	call   80195b <sys_enable_interrupt>
	
	if (*y != 20) panic("Get(): Shared Variable is not created or got correctly") ;
  800177:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80017a:	8b 00                	mov    (%eax),%eax
  80017c:	83 f8 14             	cmp    $0x14,%eax
  80017f:	74 14                	je     800195 <_main+0x15d>
  800181:	83 ec 04             	sub    $0x4,%esp
  800184:	68 b0 37 80 00       	push   $0x8037b0
  800189:	6a 27                	push   $0x27
  80018b:	68 9c 36 80 00       	push   $0x80369c
  800190:	e8 fb 01 00 00       	call   800390 <_panic>

	sys_disable_interrupt();
  800195:	e8 a7 17 00 00       	call   801941 <sys_disable_interrupt>
	freeFrames = sys_calculate_free_frames() ;
  80019a:	e8 b5 16 00 00       	call   801854 <sys_calculate_free_frames>
  80019f:	89 45 e8             	mov    %eax,-0x18(%ebp)
	x = sget(parentenvID,"x");
  8001a2:	83 ec 08             	sub    $0x8,%esp
  8001a5:	68 e7 37 80 00       	push   $0x8037e7
  8001aa:	ff 75 ec             	pushl  -0x14(%ebp)
  8001ad:	e8 fe 14 00 00       	call   8016b0 <sget>
  8001b2:	83 c4 10             	add    $0x10,%esp
  8001b5:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (x != (uint32*)(USER_HEAP_START + 2 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8001b8:	81 7d dc 00 20 00 80 	cmpl   $0x80002000,-0x24(%ebp)
  8001bf:	74 14                	je     8001d5 <_main+0x19d>
  8001c1:	83 ec 04             	sub    $0x4,%esp
  8001c4:	68 bc 36 80 00       	push   $0x8036bc
  8001c9:	6a 2c                	push   $0x2c
  8001cb:	68 9c 36 80 00       	push   $0x80369c
  8001d0:	e8 bb 01 00 00       	call   800390 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  8001d5:	e8 7a 16 00 00       	call   801854 <sys_calculate_free_frames>
  8001da:	89 c2                	mov    %eax,%edx
  8001dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001df:	39 c2                	cmp    %eax,%edx
  8001e1:	74 14                	je     8001f7 <_main+0x1bf>
  8001e3:	83 ec 04             	sub    $0x4,%esp
  8001e6:	68 1c 37 80 00       	push   $0x80371c
  8001eb:	6a 2d                	push   $0x2d
  8001ed:	68 9c 36 80 00       	push   $0x80369c
  8001f2:	e8 99 01 00 00       	call   800390 <_panic>
	sys_enable_interrupt();
  8001f7:	e8 5f 17 00 00       	call   80195b <sys_enable_interrupt>

	if (*x != 10) panic("Get(): Shared Variable is not created or got correctly") ;
  8001fc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001ff:	8b 00                	mov    (%eax),%eax
  800201:	83 f8 0a             	cmp    $0xa,%eax
  800204:	74 14                	je     80021a <_main+0x1e2>
  800206:	83 ec 04             	sub    $0x4,%esp
  800209:	68 b0 37 80 00       	push   $0x8037b0
  80020e:	6a 30                	push   $0x30
  800210:	68 9c 36 80 00       	push   $0x80369c
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
  800238:	68 b0 37 80 00       	push   $0x8037b0
  80023d:	6a 33                	push   $0x33
  80023f:	68 9c 36 80 00       	push   $0x80369c
  800244:	e8 47 01 00 00       	call   800390 <_panic>

	//To indicate that it's completed successfully
	inctst();
  800249:	e8 24 1a 00 00       	call   801c72 <inctst>

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
  80025a:	e8 d5 18 00 00       	call   801b34 <sys_getenvindex>
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
  8002c5:	e8 77 16 00 00       	call   801941 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8002ca:	83 ec 0c             	sub    $0xc,%esp
  8002cd:	68 04 38 80 00       	push   $0x803804
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
  8002f5:	68 2c 38 80 00       	push   $0x80382c
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
  800326:	68 54 38 80 00       	push   $0x803854
  80032b:	e8 14 03 00 00       	call   800644 <cprintf>
  800330:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800333:	a1 20 50 80 00       	mov    0x805020,%eax
  800338:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80033e:	83 ec 08             	sub    $0x8,%esp
  800341:	50                   	push   %eax
  800342:	68 ac 38 80 00       	push   $0x8038ac
  800347:	e8 f8 02 00 00       	call   800644 <cprintf>
  80034c:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80034f:	83 ec 0c             	sub    $0xc,%esp
  800352:	68 04 38 80 00       	push   $0x803804
  800357:	e8 e8 02 00 00       	call   800644 <cprintf>
  80035c:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80035f:	e8 f7 15 00 00       	call   80195b <sys_enable_interrupt>

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
  800377:	e8 84 17 00 00       	call   801b00 <sys_destroy_env>
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
  800388:	e8 d9 17 00 00       	call   801b66 <sys_exit_env>
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
  8003b1:	68 c0 38 80 00       	push   $0x8038c0
  8003b6:	e8 89 02 00 00       	call   800644 <cprintf>
  8003bb:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8003be:	a1 00 50 80 00       	mov    0x805000,%eax
  8003c3:	ff 75 0c             	pushl  0xc(%ebp)
  8003c6:	ff 75 08             	pushl  0x8(%ebp)
  8003c9:	50                   	push   %eax
  8003ca:	68 c5 38 80 00       	push   $0x8038c5
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
  8003ee:	68 e1 38 80 00       	push   $0x8038e1
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
  80041a:	68 e4 38 80 00       	push   $0x8038e4
  80041f:	6a 26                	push   $0x26
  800421:	68 30 39 80 00       	push   $0x803930
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
  8004ec:	68 3c 39 80 00       	push   $0x80393c
  8004f1:	6a 3a                	push   $0x3a
  8004f3:	68 30 39 80 00       	push   $0x803930
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
  80055c:	68 90 39 80 00       	push   $0x803990
  800561:	6a 44                	push   $0x44
  800563:	68 30 39 80 00       	push   $0x803930
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
  8005b6:	e8 d8 11 00 00       	call   801793 <sys_cputs>
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
  80062d:	e8 61 11 00 00       	call   801793 <sys_cputs>
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
  800677:	e8 c5 12 00 00       	call   801941 <sys_disable_interrupt>
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
  800697:	e8 bf 12 00 00       	call   80195b <sys_enable_interrupt>
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
  8006e1:	e8 32 2d 00 00       	call   803418 <__udivdi3>
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
  800731:	e8 f2 2d 00 00       	call   803528 <__umoddi3>
  800736:	83 c4 10             	add    $0x10,%esp
  800739:	05 f4 3b 80 00       	add    $0x803bf4,%eax
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
  80088c:	8b 04 85 18 3c 80 00 	mov    0x803c18(,%eax,4),%eax
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
  80096d:	8b 34 9d 60 3a 80 00 	mov    0x803a60(,%ebx,4),%esi
  800974:	85 f6                	test   %esi,%esi
  800976:	75 19                	jne    800991 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800978:	53                   	push   %ebx
  800979:	68 05 3c 80 00       	push   $0x803c05
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
  800992:	68 0e 3c 80 00       	push   $0x803c0e
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
  8009bf:	be 11 3c 80 00       	mov    $0x803c11,%esi
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
  8013e5:	68 70 3d 80 00       	push   $0x803d70
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
  8014b5:	e8 1d 04 00 00       	call   8018d7 <sys_allocate_chunk>
  8014ba:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8014bd:	a1 20 51 80 00       	mov    0x805120,%eax
  8014c2:	83 ec 0c             	sub    $0xc,%esp
  8014c5:	50                   	push   %eax
  8014c6:	e8 92 0a 00 00       	call   801f5d <initialize_MemBlocksList>
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
  8014f3:	68 95 3d 80 00       	push   $0x803d95
  8014f8:	6a 33                	push   $0x33
  8014fa:	68 b3 3d 80 00       	push   $0x803db3
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
  801572:	68 c0 3d 80 00       	push   $0x803dc0
  801577:	6a 34                	push   $0x34
  801579:	68 b3 3d 80 00       	push   $0x803db3
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
  8015e7:	68 e4 3d 80 00       	push   $0x803de4
  8015ec:	6a 46                	push   $0x46
  8015ee:	68 b3 3d 80 00       	push   $0x803db3
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
  801603:	68 0c 3e 80 00       	push   $0x803e0c
  801608:	6a 61                	push   $0x61
  80160a:	68 b3 3d 80 00       	push   $0x803db3
  80160f:	e8 7c ed ff ff       	call   800390 <_panic>

00801614 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801614:	55                   	push   %ebp
  801615:	89 e5                	mov    %esp,%ebp
  801617:	83 ec 38             	sub    $0x38,%esp
  80161a:	8b 45 10             	mov    0x10(%ebp),%eax
  80161d:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801620:	e8 a9 fd ff ff       	call   8013ce <InitializeUHeap>
	if (size == 0) return NULL ;
  801625:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801629:	75 07                	jne    801632 <smalloc+0x1e>
  80162b:	b8 00 00 00 00       	mov    $0x0,%eax
  801630:	eb 7c                	jmp    8016ae <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801632:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801639:	8b 55 0c             	mov    0xc(%ebp),%edx
  80163c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80163f:	01 d0                	add    %edx,%eax
  801641:	48                   	dec    %eax
  801642:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801645:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801648:	ba 00 00 00 00       	mov    $0x0,%edx
  80164d:	f7 75 f0             	divl   -0x10(%ebp)
  801650:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801653:	29 d0                	sub    %edx,%eax
  801655:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801658:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  80165f:	e8 41 06 00 00       	call   801ca5 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801664:	85 c0                	test   %eax,%eax
  801666:	74 11                	je     801679 <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  801668:	83 ec 0c             	sub    $0xc,%esp
  80166b:	ff 75 e8             	pushl  -0x18(%ebp)
  80166e:	e8 ac 0c 00 00       	call   80231f <alloc_block_FF>
  801673:	83 c4 10             	add    $0x10,%esp
  801676:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  801679:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80167d:	74 2a                	je     8016a9 <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  80167f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801682:	8b 40 08             	mov    0x8(%eax),%eax
  801685:	89 c2                	mov    %eax,%edx
  801687:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  80168b:	52                   	push   %edx
  80168c:	50                   	push   %eax
  80168d:	ff 75 0c             	pushl  0xc(%ebp)
  801690:	ff 75 08             	pushl  0x8(%ebp)
  801693:	e8 92 03 00 00       	call   801a2a <sys_createSharedObject>
  801698:	83 c4 10             	add    $0x10,%esp
  80169b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  80169e:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  8016a2:	74 05                	je     8016a9 <smalloc+0x95>
			return (void*)virtual_address;
  8016a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016a7:	eb 05                	jmp    8016ae <smalloc+0x9a>
	}
	return NULL;
  8016a9:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8016ae:	c9                   	leave  
  8016af:	c3                   	ret    

008016b0 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8016b0:	55                   	push   %ebp
  8016b1:	89 e5                	mov    %esp,%ebp
  8016b3:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016b6:	e8 13 fd ff ff       	call   8013ce <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8016bb:	83 ec 04             	sub    $0x4,%esp
  8016be:	68 30 3e 80 00       	push   $0x803e30
  8016c3:	68 a2 00 00 00       	push   $0xa2
  8016c8:	68 b3 3d 80 00       	push   $0x803db3
  8016cd:	e8 be ec ff ff       	call   800390 <_panic>

008016d2 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8016d2:	55                   	push   %ebp
  8016d3:	89 e5                	mov    %esp,%ebp
  8016d5:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016d8:	e8 f1 fc ff ff       	call   8013ce <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8016dd:	83 ec 04             	sub    $0x4,%esp
  8016e0:	68 54 3e 80 00       	push   $0x803e54
  8016e5:	68 e6 00 00 00       	push   $0xe6
  8016ea:	68 b3 3d 80 00       	push   $0x803db3
  8016ef:	e8 9c ec ff ff       	call   800390 <_panic>

008016f4 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8016f4:	55                   	push   %ebp
  8016f5:	89 e5                	mov    %esp,%ebp
  8016f7:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8016fa:	83 ec 04             	sub    $0x4,%esp
  8016fd:	68 7c 3e 80 00       	push   $0x803e7c
  801702:	68 fa 00 00 00       	push   $0xfa
  801707:	68 b3 3d 80 00       	push   $0x803db3
  80170c:	e8 7f ec ff ff       	call   800390 <_panic>

00801711 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801711:	55                   	push   %ebp
  801712:	89 e5                	mov    %esp,%ebp
  801714:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801717:	83 ec 04             	sub    $0x4,%esp
  80171a:	68 a0 3e 80 00       	push   $0x803ea0
  80171f:	68 05 01 00 00       	push   $0x105
  801724:	68 b3 3d 80 00       	push   $0x803db3
  801729:	e8 62 ec ff ff       	call   800390 <_panic>

0080172e <shrink>:

}
void shrink(uint32 newSize)
{
  80172e:	55                   	push   %ebp
  80172f:	89 e5                	mov    %esp,%ebp
  801731:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801734:	83 ec 04             	sub    $0x4,%esp
  801737:	68 a0 3e 80 00       	push   $0x803ea0
  80173c:	68 0a 01 00 00       	push   $0x10a
  801741:	68 b3 3d 80 00       	push   $0x803db3
  801746:	e8 45 ec ff ff       	call   800390 <_panic>

0080174b <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80174b:	55                   	push   %ebp
  80174c:	89 e5                	mov    %esp,%ebp
  80174e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801751:	83 ec 04             	sub    $0x4,%esp
  801754:	68 a0 3e 80 00       	push   $0x803ea0
  801759:	68 0f 01 00 00       	push   $0x10f
  80175e:	68 b3 3d 80 00       	push   $0x803db3
  801763:	e8 28 ec ff ff       	call   800390 <_panic>

00801768 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801768:	55                   	push   %ebp
  801769:	89 e5                	mov    %esp,%ebp
  80176b:	57                   	push   %edi
  80176c:	56                   	push   %esi
  80176d:	53                   	push   %ebx
  80176e:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801771:	8b 45 08             	mov    0x8(%ebp),%eax
  801774:	8b 55 0c             	mov    0xc(%ebp),%edx
  801777:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80177a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80177d:	8b 7d 18             	mov    0x18(%ebp),%edi
  801780:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801783:	cd 30                	int    $0x30
  801785:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801788:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80178b:	83 c4 10             	add    $0x10,%esp
  80178e:	5b                   	pop    %ebx
  80178f:	5e                   	pop    %esi
  801790:	5f                   	pop    %edi
  801791:	5d                   	pop    %ebp
  801792:	c3                   	ret    

00801793 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801793:	55                   	push   %ebp
  801794:	89 e5                	mov    %esp,%ebp
  801796:	83 ec 04             	sub    $0x4,%esp
  801799:	8b 45 10             	mov    0x10(%ebp),%eax
  80179c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80179f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a6:	6a 00                	push   $0x0
  8017a8:	6a 00                	push   $0x0
  8017aa:	52                   	push   %edx
  8017ab:	ff 75 0c             	pushl  0xc(%ebp)
  8017ae:	50                   	push   %eax
  8017af:	6a 00                	push   $0x0
  8017b1:	e8 b2 ff ff ff       	call   801768 <syscall>
  8017b6:	83 c4 18             	add    $0x18,%esp
}
  8017b9:	90                   	nop
  8017ba:	c9                   	leave  
  8017bb:	c3                   	ret    

008017bc <sys_cgetc>:

int
sys_cgetc(void)
{
  8017bc:	55                   	push   %ebp
  8017bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8017bf:	6a 00                	push   $0x0
  8017c1:	6a 00                	push   $0x0
  8017c3:	6a 00                	push   $0x0
  8017c5:	6a 00                	push   $0x0
  8017c7:	6a 00                	push   $0x0
  8017c9:	6a 01                	push   $0x1
  8017cb:	e8 98 ff ff ff       	call   801768 <syscall>
  8017d0:	83 c4 18             	add    $0x18,%esp
}
  8017d3:	c9                   	leave  
  8017d4:	c3                   	ret    

008017d5 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8017d5:	55                   	push   %ebp
  8017d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8017d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017db:	8b 45 08             	mov    0x8(%ebp),%eax
  8017de:	6a 00                	push   $0x0
  8017e0:	6a 00                	push   $0x0
  8017e2:	6a 00                	push   $0x0
  8017e4:	52                   	push   %edx
  8017e5:	50                   	push   %eax
  8017e6:	6a 05                	push   $0x5
  8017e8:	e8 7b ff ff ff       	call   801768 <syscall>
  8017ed:	83 c4 18             	add    $0x18,%esp
}
  8017f0:	c9                   	leave  
  8017f1:	c3                   	ret    

008017f2 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8017f2:	55                   	push   %ebp
  8017f3:	89 e5                	mov    %esp,%ebp
  8017f5:	56                   	push   %esi
  8017f6:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8017f7:	8b 75 18             	mov    0x18(%ebp),%esi
  8017fa:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017fd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801800:	8b 55 0c             	mov    0xc(%ebp),%edx
  801803:	8b 45 08             	mov    0x8(%ebp),%eax
  801806:	56                   	push   %esi
  801807:	53                   	push   %ebx
  801808:	51                   	push   %ecx
  801809:	52                   	push   %edx
  80180a:	50                   	push   %eax
  80180b:	6a 06                	push   $0x6
  80180d:	e8 56 ff ff ff       	call   801768 <syscall>
  801812:	83 c4 18             	add    $0x18,%esp
}
  801815:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801818:	5b                   	pop    %ebx
  801819:	5e                   	pop    %esi
  80181a:	5d                   	pop    %ebp
  80181b:	c3                   	ret    

0080181c <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80181c:	55                   	push   %ebp
  80181d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80181f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801822:	8b 45 08             	mov    0x8(%ebp),%eax
  801825:	6a 00                	push   $0x0
  801827:	6a 00                	push   $0x0
  801829:	6a 00                	push   $0x0
  80182b:	52                   	push   %edx
  80182c:	50                   	push   %eax
  80182d:	6a 07                	push   $0x7
  80182f:	e8 34 ff ff ff       	call   801768 <syscall>
  801834:	83 c4 18             	add    $0x18,%esp
}
  801837:	c9                   	leave  
  801838:	c3                   	ret    

00801839 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801839:	55                   	push   %ebp
  80183a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80183c:	6a 00                	push   $0x0
  80183e:	6a 00                	push   $0x0
  801840:	6a 00                	push   $0x0
  801842:	ff 75 0c             	pushl  0xc(%ebp)
  801845:	ff 75 08             	pushl  0x8(%ebp)
  801848:	6a 08                	push   $0x8
  80184a:	e8 19 ff ff ff       	call   801768 <syscall>
  80184f:	83 c4 18             	add    $0x18,%esp
}
  801852:	c9                   	leave  
  801853:	c3                   	ret    

00801854 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801854:	55                   	push   %ebp
  801855:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801857:	6a 00                	push   $0x0
  801859:	6a 00                	push   $0x0
  80185b:	6a 00                	push   $0x0
  80185d:	6a 00                	push   $0x0
  80185f:	6a 00                	push   $0x0
  801861:	6a 09                	push   $0x9
  801863:	e8 00 ff ff ff       	call   801768 <syscall>
  801868:	83 c4 18             	add    $0x18,%esp
}
  80186b:	c9                   	leave  
  80186c:	c3                   	ret    

0080186d <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80186d:	55                   	push   %ebp
  80186e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801870:	6a 00                	push   $0x0
  801872:	6a 00                	push   $0x0
  801874:	6a 00                	push   $0x0
  801876:	6a 00                	push   $0x0
  801878:	6a 00                	push   $0x0
  80187a:	6a 0a                	push   $0xa
  80187c:	e8 e7 fe ff ff       	call   801768 <syscall>
  801881:	83 c4 18             	add    $0x18,%esp
}
  801884:	c9                   	leave  
  801885:	c3                   	ret    

00801886 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801886:	55                   	push   %ebp
  801887:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801889:	6a 00                	push   $0x0
  80188b:	6a 00                	push   $0x0
  80188d:	6a 00                	push   $0x0
  80188f:	6a 00                	push   $0x0
  801891:	6a 00                	push   $0x0
  801893:	6a 0b                	push   $0xb
  801895:	e8 ce fe ff ff       	call   801768 <syscall>
  80189a:	83 c4 18             	add    $0x18,%esp
}
  80189d:	c9                   	leave  
  80189e:	c3                   	ret    

0080189f <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80189f:	55                   	push   %ebp
  8018a0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8018a2:	6a 00                	push   $0x0
  8018a4:	6a 00                	push   $0x0
  8018a6:	6a 00                	push   $0x0
  8018a8:	ff 75 0c             	pushl  0xc(%ebp)
  8018ab:	ff 75 08             	pushl  0x8(%ebp)
  8018ae:	6a 0f                	push   $0xf
  8018b0:	e8 b3 fe ff ff       	call   801768 <syscall>
  8018b5:	83 c4 18             	add    $0x18,%esp
	return;
  8018b8:	90                   	nop
}
  8018b9:	c9                   	leave  
  8018ba:	c3                   	ret    

008018bb <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8018bb:	55                   	push   %ebp
  8018bc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8018be:	6a 00                	push   $0x0
  8018c0:	6a 00                	push   $0x0
  8018c2:	6a 00                	push   $0x0
  8018c4:	ff 75 0c             	pushl  0xc(%ebp)
  8018c7:	ff 75 08             	pushl  0x8(%ebp)
  8018ca:	6a 10                	push   $0x10
  8018cc:	e8 97 fe ff ff       	call   801768 <syscall>
  8018d1:	83 c4 18             	add    $0x18,%esp
	return ;
  8018d4:	90                   	nop
}
  8018d5:	c9                   	leave  
  8018d6:	c3                   	ret    

008018d7 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8018d7:	55                   	push   %ebp
  8018d8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8018da:	6a 00                	push   $0x0
  8018dc:	6a 00                	push   $0x0
  8018de:	ff 75 10             	pushl  0x10(%ebp)
  8018e1:	ff 75 0c             	pushl  0xc(%ebp)
  8018e4:	ff 75 08             	pushl  0x8(%ebp)
  8018e7:	6a 11                	push   $0x11
  8018e9:	e8 7a fe ff ff       	call   801768 <syscall>
  8018ee:	83 c4 18             	add    $0x18,%esp
	return ;
  8018f1:	90                   	nop
}
  8018f2:	c9                   	leave  
  8018f3:	c3                   	ret    

008018f4 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8018f4:	55                   	push   %ebp
  8018f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8018f7:	6a 00                	push   $0x0
  8018f9:	6a 00                	push   $0x0
  8018fb:	6a 00                	push   $0x0
  8018fd:	6a 00                	push   $0x0
  8018ff:	6a 00                	push   $0x0
  801901:	6a 0c                	push   $0xc
  801903:	e8 60 fe ff ff       	call   801768 <syscall>
  801908:	83 c4 18             	add    $0x18,%esp
}
  80190b:	c9                   	leave  
  80190c:	c3                   	ret    

0080190d <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80190d:	55                   	push   %ebp
  80190e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801910:	6a 00                	push   $0x0
  801912:	6a 00                	push   $0x0
  801914:	6a 00                	push   $0x0
  801916:	6a 00                	push   $0x0
  801918:	ff 75 08             	pushl  0x8(%ebp)
  80191b:	6a 0d                	push   $0xd
  80191d:	e8 46 fe ff ff       	call   801768 <syscall>
  801922:	83 c4 18             	add    $0x18,%esp
}
  801925:	c9                   	leave  
  801926:	c3                   	ret    

00801927 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801927:	55                   	push   %ebp
  801928:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80192a:	6a 00                	push   $0x0
  80192c:	6a 00                	push   $0x0
  80192e:	6a 00                	push   $0x0
  801930:	6a 00                	push   $0x0
  801932:	6a 00                	push   $0x0
  801934:	6a 0e                	push   $0xe
  801936:	e8 2d fe ff ff       	call   801768 <syscall>
  80193b:	83 c4 18             	add    $0x18,%esp
}
  80193e:	90                   	nop
  80193f:	c9                   	leave  
  801940:	c3                   	ret    

00801941 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801941:	55                   	push   %ebp
  801942:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801944:	6a 00                	push   $0x0
  801946:	6a 00                	push   $0x0
  801948:	6a 00                	push   $0x0
  80194a:	6a 00                	push   $0x0
  80194c:	6a 00                	push   $0x0
  80194e:	6a 13                	push   $0x13
  801950:	e8 13 fe ff ff       	call   801768 <syscall>
  801955:	83 c4 18             	add    $0x18,%esp
}
  801958:	90                   	nop
  801959:	c9                   	leave  
  80195a:	c3                   	ret    

0080195b <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80195b:	55                   	push   %ebp
  80195c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80195e:	6a 00                	push   $0x0
  801960:	6a 00                	push   $0x0
  801962:	6a 00                	push   $0x0
  801964:	6a 00                	push   $0x0
  801966:	6a 00                	push   $0x0
  801968:	6a 14                	push   $0x14
  80196a:	e8 f9 fd ff ff       	call   801768 <syscall>
  80196f:	83 c4 18             	add    $0x18,%esp
}
  801972:	90                   	nop
  801973:	c9                   	leave  
  801974:	c3                   	ret    

00801975 <sys_cputc>:


void
sys_cputc(const char c)
{
  801975:	55                   	push   %ebp
  801976:	89 e5                	mov    %esp,%ebp
  801978:	83 ec 04             	sub    $0x4,%esp
  80197b:	8b 45 08             	mov    0x8(%ebp),%eax
  80197e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801981:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801985:	6a 00                	push   $0x0
  801987:	6a 00                	push   $0x0
  801989:	6a 00                	push   $0x0
  80198b:	6a 00                	push   $0x0
  80198d:	50                   	push   %eax
  80198e:	6a 15                	push   $0x15
  801990:	e8 d3 fd ff ff       	call   801768 <syscall>
  801995:	83 c4 18             	add    $0x18,%esp
}
  801998:	90                   	nop
  801999:	c9                   	leave  
  80199a:	c3                   	ret    

0080199b <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80199b:	55                   	push   %ebp
  80199c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80199e:	6a 00                	push   $0x0
  8019a0:	6a 00                	push   $0x0
  8019a2:	6a 00                	push   $0x0
  8019a4:	6a 00                	push   $0x0
  8019a6:	6a 00                	push   $0x0
  8019a8:	6a 16                	push   $0x16
  8019aa:	e8 b9 fd ff ff       	call   801768 <syscall>
  8019af:	83 c4 18             	add    $0x18,%esp
}
  8019b2:	90                   	nop
  8019b3:	c9                   	leave  
  8019b4:	c3                   	ret    

008019b5 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8019b5:	55                   	push   %ebp
  8019b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8019b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 00                	push   $0x0
  8019c1:	ff 75 0c             	pushl  0xc(%ebp)
  8019c4:	50                   	push   %eax
  8019c5:	6a 17                	push   $0x17
  8019c7:	e8 9c fd ff ff       	call   801768 <syscall>
  8019cc:	83 c4 18             	add    $0x18,%esp
}
  8019cf:	c9                   	leave  
  8019d0:	c3                   	ret    

008019d1 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8019d1:	55                   	push   %ebp
  8019d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	52                   	push   %edx
  8019e1:	50                   	push   %eax
  8019e2:	6a 1a                	push   $0x1a
  8019e4:	e8 7f fd ff ff       	call   801768 <syscall>
  8019e9:	83 c4 18             	add    $0x18,%esp
}
  8019ec:	c9                   	leave  
  8019ed:	c3                   	ret    

008019ee <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8019ee:	55                   	push   %ebp
  8019ef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f7:	6a 00                	push   $0x0
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 00                	push   $0x0
  8019fd:	52                   	push   %edx
  8019fe:	50                   	push   %eax
  8019ff:	6a 18                	push   $0x18
  801a01:	e8 62 fd ff ff       	call   801768 <syscall>
  801a06:	83 c4 18             	add    $0x18,%esp
}
  801a09:	90                   	nop
  801a0a:	c9                   	leave  
  801a0b:	c3                   	ret    

00801a0c <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a0c:	55                   	push   %ebp
  801a0d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a0f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a12:	8b 45 08             	mov    0x8(%ebp),%eax
  801a15:	6a 00                	push   $0x0
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	52                   	push   %edx
  801a1c:	50                   	push   %eax
  801a1d:	6a 19                	push   $0x19
  801a1f:	e8 44 fd ff ff       	call   801768 <syscall>
  801a24:	83 c4 18             	add    $0x18,%esp
}
  801a27:	90                   	nop
  801a28:	c9                   	leave  
  801a29:	c3                   	ret    

00801a2a <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a2a:	55                   	push   %ebp
  801a2b:	89 e5                	mov    %esp,%ebp
  801a2d:	83 ec 04             	sub    $0x4,%esp
  801a30:	8b 45 10             	mov    0x10(%ebp),%eax
  801a33:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a36:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a39:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a40:	6a 00                	push   $0x0
  801a42:	51                   	push   %ecx
  801a43:	52                   	push   %edx
  801a44:	ff 75 0c             	pushl  0xc(%ebp)
  801a47:	50                   	push   %eax
  801a48:	6a 1b                	push   $0x1b
  801a4a:	e8 19 fd ff ff       	call   801768 <syscall>
  801a4f:	83 c4 18             	add    $0x18,%esp
}
  801a52:	c9                   	leave  
  801a53:	c3                   	ret    

00801a54 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801a54:	55                   	push   %ebp
  801a55:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a57:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 00                	push   $0x0
  801a63:	52                   	push   %edx
  801a64:	50                   	push   %eax
  801a65:	6a 1c                	push   $0x1c
  801a67:	e8 fc fc ff ff       	call   801768 <syscall>
  801a6c:	83 c4 18             	add    $0x18,%esp
}
  801a6f:	c9                   	leave  
  801a70:	c3                   	ret    

00801a71 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801a71:	55                   	push   %ebp
  801a72:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a74:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a77:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 00                	push   $0x0
  801a81:	51                   	push   %ecx
  801a82:	52                   	push   %edx
  801a83:	50                   	push   %eax
  801a84:	6a 1d                	push   $0x1d
  801a86:	e8 dd fc ff ff       	call   801768 <syscall>
  801a8b:	83 c4 18             	add    $0x18,%esp
}
  801a8e:	c9                   	leave  
  801a8f:	c3                   	ret    

00801a90 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801a90:	55                   	push   %ebp
  801a91:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a93:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a96:	8b 45 08             	mov    0x8(%ebp),%eax
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 00                	push   $0x0
  801a9d:	6a 00                	push   $0x0
  801a9f:	52                   	push   %edx
  801aa0:	50                   	push   %eax
  801aa1:	6a 1e                	push   $0x1e
  801aa3:	e8 c0 fc ff ff       	call   801768 <syscall>
  801aa8:	83 c4 18             	add    $0x18,%esp
}
  801aab:	c9                   	leave  
  801aac:	c3                   	ret    

00801aad <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801aad:	55                   	push   %ebp
  801aae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 1f                	push   $0x1f
  801abc:	e8 a7 fc ff ff       	call   801768 <syscall>
  801ac1:	83 c4 18             	add    $0x18,%esp
}
  801ac4:	c9                   	leave  
  801ac5:	c3                   	ret    

00801ac6 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801ac6:	55                   	push   %ebp
  801ac7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  801acc:	6a 00                	push   $0x0
  801ace:	ff 75 14             	pushl  0x14(%ebp)
  801ad1:	ff 75 10             	pushl  0x10(%ebp)
  801ad4:	ff 75 0c             	pushl  0xc(%ebp)
  801ad7:	50                   	push   %eax
  801ad8:	6a 20                	push   $0x20
  801ada:	e8 89 fc ff ff       	call   801768 <syscall>
  801adf:	83 c4 18             	add    $0x18,%esp
}
  801ae2:	c9                   	leave  
  801ae3:	c3                   	ret    

00801ae4 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801ae4:	55                   	push   %ebp
  801ae5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aea:	6a 00                	push   $0x0
  801aec:	6a 00                	push   $0x0
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	50                   	push   %eax
  801af3:	6a 21                	push   $0x21
  801af5:	e8 6e fc ff ff       	call   801768 <syscall>
  801afa:	83 c4 18             	add    $0x18,%esp
}
  801afd:	90                   	nop
  801afe:	c9                   	leave  
  801aff:	c3                   	ret    

00801b00 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b00:	55                   	push   %ebp
  801b01:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b03:	8b 45 08             	mov    0x8(%ebp),%eax
  801b06:	6a 00                	push   $0x0
  801b08:	6a 00                	push   $0x0
  801b0a:	6a 00                	push   $0x0
  801b0c:	6a 00                	push   $0x0
  801b0e:	50                   	push   %eax
  801b0f:	6a 22                	push   $0x22
  801b11:	e8 52 fc ff ff       	call   801768 <syscall>
  801b16:	83 c4 18             	add    $0x18,%esp
}
  801b19:	c9                   	leave  
  801b1a:	c3                   	ret    

00801b1b <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b1b:	55                   	push   %ebp
  801b1c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	6a 00                	push   $0x0
  801b26:	6a 00                	push   $0x0
  801b28:	6a 02                	push   $0x2
  801b2a:	e8 39 fc ff ff       	call   801768 <syscall>
  801b2f:	83 c4 18             	add    $0x18,%esp
}
  801b32:	c9                   	leave  
  801b33:	c3                   	ret    

00801b34 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b34:	55                   	push   %ebp
  801b35:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b37:	6a 00                	push   $0x0
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 00                	push   $0x0
  801b3f:	6a 00                	push   $0x0
  801b41:	6a 03                	push   $0x3
  801b43:	e8 20 fc ff ff       	call   801768 <syscall>
  801b48:	83 c4 18             	add    $0x18,%esp
}
  801b4b:	c9                   	leave  
  801b4c:	c3                   	ret    

00801b4d <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b4d:	55                   	push   %ebp
  801b4e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b50:	6a 00                	push   $0x0
  801b52:	6a 00                	push   $0x0
  801b54:	6a 00                	push   $0x0
  801b56:	6a 00                	push   $0x0
  801b58:	6a 00                	push   $0x0
  801b5a:	6a 04                	push   $0x4
  801b5c:	e8 07 fc ff ff       	call   801768 <syscall>
  801b61:	83 c4 18             	add    $0x18,%esp
}
  801b64:	c9                   	leave  
  801b65:	c3                   	ret    

00801b66 <sys_exit_env>:


void sys_exit_env(void)
{
  801b66:	55                   	push   %ebp
  801b67:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b69:	6a 00                	push   $0x0
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 00                	push   $0x0
  801b73:	6a 23                	push   $0x23
  801b75:	e8 ee fb ff ff       	call   801768 <syscall>
  801b7a:	83 c4 18             	add    $0x18,%esp
}
  801b7d:	90                   	nop
  801b7e:	c9                   	leave  
  801b7f:	c3                   	ret    

00801b80 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801b80:	55                   	push   %ebp
  801b81:	89 e5                	mov    %esp,%ebp
  801b83:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b86:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b89:	8d 50 04             	lea    0x4(%eax),%edx
  801b8c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 00                	push   $0x0
  801b93:	6a 00                	push   $0x0
  801b95:	52                   	push   %edx
  801b96:	50                   	push   %eax
  801b97:	6a 24                	push   $0x24
  801b99:	e8 ca fb ff ff       	call   801768 <syscall>
  801b9e:	83 c4 18             	add    $0x18,%esp
	return result;
  801ba1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ba4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ba7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801baa:	89 01                	mov    %eax,(%ecx)
  801bac:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801baf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb2:	c9                   	leave  
  801bb3:	c2 04 00             	ret    $0x4

00801bb6 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801bb6:	55                   	push   %ebp
  801bb7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801bb9:	6a 00                	push   $0x0
  801bbb:	6a 00                	push   $0x0
  801bbd:	ff 75 10             	pushl  0x10(%ebp)
  801bc0:	ff 75 0c             	pushl  0xc(%ebp)
  801bc3:	ff 75 08             	pushl  0x8(%ebp)
  801bc6:	6a 12                	push   $0x12
  801bc8:	e8 9b fb ff ff       	call   801768 <syscall>
  801bcd:	83 c4 18             	add    $0x18,%esp
	return ;
  801bd0:	90                   	nop
}
  801bd1:	c9                   	leave  
  801bd2:	c3                   	ret    

00801bd3 <sys_rcr2>:
uint32 sys_rcr2()
{
  801bd3:	55                   	push   %ebp
  801bd4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 00                	push   $0x0
  801be0:	6a 25                	push   $0x25
  801be2:	e8 81 fb ff ff       	call   801768 <syscall>
  801be7:	83 c4 18             	add    $0x18,%esp
}
  801bea:	c9                   	leave  
  801beb:	c3                   	ret    

00801bec <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801bec:	55                   	push   %ebp
  801bed:	89 e5                	mov    %esp,%ebp
  801bef:	83 ec 04             	sub    $0x4,%esp
  801bf2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801bf8:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	6a 00                	push   $0x0
  801c04:	50                   	push   %eax
  801c05:	6a 26                	push   $0x26
  801c07:	e8 5c fb ff ff       	call   801768 <syscall>
  801c0c:	83 c4 18             	add    $0x18,%esp
	return ;
  801c0f:	90                   	nop
}
  801c10:	c9                   	leave  
  801c11:	c3                   	ret    

00801c12 <rsttst>:
void rsttst()
{
  801c12:	55                   	push   %ebp
  801c13:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c15:	6a 00                	push   $0x0
  801c17:	6a 00                	push   $0x0
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 28                	push   $0x28
  801c21:	e8 42 fb ff ff       	call   801768 <syscall>
  801c26:	83 c4 18             	add    $0x18,%esp
	return ;
  801c29:	90                   	nop
}
  801c2a:	c9                   	leave  
  801c2b:	c3                   	ret    

00801c2c <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c2c:	55                   	push   %ebp
  801c2d:	89 e5                	mov    %esp,%ebp
  801c2f:	83 ec 04             	sub    $0x4,%esp
  801c32:	8b 45 14             	mov    0x14(%ebp),%eax
  801c35:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c38:	8b 55 18             	mov    0x18(%ebp),%edx
  801c3b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c3f:	52                   	push   %edx
  801c40:	50                   	push   %eax
  801c41:	ff 75 10             	pushl  0x10(%ebp)
  801c44:	ff 75 0c             	pushl  0xc(%ebp)
  801c47:	ff 75 08             	pushl  0x8(%ebp)
  801c4a:	6a 27                	push   $0x27
  801c4c:	e8 17 fb ff ff       	call   801768 <syscall>
  801c51:	83 c4 18             	add    $0x18,%esp
	return ;
  801c54:	90                   	nop
}
  801c55:	c9                   	leave  
  801c56:	c3                   	ret    

00801c57 <chktst>:
void chktst(uint32 n)
{
  801c57:	55                   	push   %ebp
  801c58:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 00                	push   $0x0
  801c60:	6a 00                	push   $0x0
  801c62:	ff 75 08             	pushl  0x8(%ebp)
  801c65:	6a 29                	push   $0x29
  801c67:	e8 fc fa ff ff       	call   801768 <syscall>
  801c6c:	83 c4 18             	add    $0x18,%esp
	return ;
  801c6f:	90                   	nop
}
  801c70:	c9                   	leave  
  801c71:	c3                   	ret    

00801c72 <inctst>:

void inctst()
{
  801c72:	55                   	push   %ebp
  801c73:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c75:	6a 00                	push   $0x0
  801c77:	6a 00                	push   $0x0
  801c79:	6a 00                	push   $0x0
  801c7b:	6a 00                	push   $0x0
  801c7d:	6a 00                	push   $0x0
  801c7f:	6a 2a                	push   $0x2a
  801c81:	e8 e2 fa ff ff       	call   801768 <syscall>
  801c86:	83 c4 18             	add    $0x18,%esp
	return ;
  801c89:	90                   	nop
}
  801c8a:	c9                   	leave  
  801c8b:	c3                   	ret    

00801c8c <gettst>:
uint32 gettst()
{
  801c8c:	55                   	push   %ebp
  801c8d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 00                	push   $0x0
  801c93:	6a 00                	push   $0x0
  801c95:	6a 00                	push   $0x0
  801c97:	6a 00                	push   $0x0
  801c99:	6a 2b                	push   $0x2b
  801c9b:	e8 c8 fa ff ff       	call   801768 <syscall>
  801ca0:	83 c4 18             	add    $0x18,%esp
}
  801ca3:	c9                   	leave  
  801ca4:	c3                   	ret    

00801ca5 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801ca5:	55                   	push   %ebp
  801ca6:	89 e5                	mov    %esp,%ebp
  801ca8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cab:	6a 00                	push   $0x0
  801cad:	6a 00                	push   $0x0
  801caf:	6a 00                	push   $0x0
  801cb1:	6a 00                	push   $0x0
  801cb3:	6a 00                	push   $0x0
  801cb5:	6a 2c                	push   $0x2c
  801cb7:	e8 ac fa ff ff       	call   801768 <syscall>
  801cbc:	83 c4 18             	add    $0x18,%esp
  801cbf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801cc2:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801cc6:	75 07                	jne    801ccf <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801cc8:	b8 01 00 00 00       	mov    $0x1,%eax
  801ccd:	eb 05                	jmp    801cd4 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801ccf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cd4:	c9                   	leave  
  801cd5:	c3                   	ret    

00801cd6 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801cd6:	55                   	push   %ebp
  801cd7:	89 e5                	mov    %esp,%ebp
  801cd9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cdc:	6a 00                	push   $0x0
  801cde:	6a 00                	push   $0x0
  801ce0:	6a 00                	push   $0x0
  801ce2:	6a 00                	push   $0x0
  801ce4:	6a 00                	push   $0x0
  801ce6:	6a 2c                	push   $0x2c
  801ce8:	e8 7b fa ff ff       	call   801768 <syscall>
  801ced:	83 c4 18             	add    $0x18,%esp
  801cf0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801cf3:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801cf7:	75 07                	jne    801d00 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801cf9:	b8 01 00 00 00       	mov    $0x1,%eax
  801cfe:	eb 05                	jmp    801d05 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d00:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d05:	c9                   	leave  
  801d06:	c3                   	ret    

00801d07 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d07:	55                   	push   %ebp
  801d08:	89 e5                	mov    %esp,%ebp
  801d0a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d0d:	6a 00                	push   $0x0
  801d0f:	6a 00                	push   $0x0
  801d11:	6a 00                	push   $0x0
  801d13:	6a 00                	push   $0x0
  801d15:	6a 00                	push   $0x0
  801d17:	6a 2c                	push   $0x2c
  801d19:	e8 4a fa ff ff       	call   801768 <syscall>
  801d1e:	83 c4 18             	add    $0x18,%esp
  801d21:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801d24:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d28:	75 07                	jne    801d31 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801d2a:	b8 01 00 00 00       	mov    $0x1,%eax
  801d2f:	eb 05                	jmp    801d36 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801d31:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d36:	c9                   	leave  
  801d37:	c3                   	ret    

00801d38 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801d38:	55                   	push   %ebp
  801d39:	89 e5                	mov    %esp,%ebp
  801d3b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d3e:	6a 00                	push   $0x0
  801d40:	6a 00                	push   $0x0
  801d42:	6a 00                	push   $0x0
  801d44:	6a 00                	push   $0x0
  801d46:	6a 00                	push   $0x0
  801d48:	6a 2c                	push   $0x2c
  801d4a:	e8 19 fa ff ff       	call   801768 <syscall>
  801d4f:	83 c4 18             	add    $0x18,%esp
  801d52:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801d55:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801d59:	75 07                	jne    801d62 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801d5b:	b8 01 00 00 00       	mov    $0x1,%eax
  801d60:	eb 05                	jmp    801d67 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801d62:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d67:	c9                   	leave  
  801d68:	c3                   	ret    

00801d69 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801d69:	55                   	push   %ebp
  801d6a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801d6c:	6a 00                	push   $0x0
  801d6e:	6a 00                	push   $0x0
  801d70:	6a 00                	push   $0x0
  801d72:	6a 00                	push   $0x0
  801d74:	ff 75 08             	pushl  0x8(%ebp)
  801d77:	6a 2d                	push   $0x2d
  801d79:	e8 ea f9 ff ff       	call   801768 <syscall>
  801d7e:	83 c4 18             	add    $0x18,%esp
	return ;
  801d81:	90                   	nop
}
  801d82:	c9                   	leave  
  801d83:	c3                   	ret    

00801d84 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801d84:	55                   	push   %ebp
  801d85:	89 e5                	mov    %esp,%ebp
  801d87:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801d88:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d8b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d8e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d91:	8b 45 08             	mov    0x8(%ebp),%eax
  801d94:	6a 00                	push   $0x0
  801d96:	53                   	push   %ebx
  801d97:	51                   	push   %ecx
  801d98:	52                   	push   %edx
  801d99:	50                   	push   %eax
  801d9a:	6a 2e                	push   $0x2e
  801d9c:	e8 c7 f9 ff ff       	call   801768 <syscall>
  801da1:	83 c4 18             	add    $0x18,%esp
}
  801da4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801da7:	c9                   	leave  
  801da8:	c3                   	ret    

00801da9 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801da9:	55                   	push   %ebp
  801daa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801dac:	8b 55 0c             	mov    0xc(%ebp),%edx
  801daf:	8b 45 08             	mov    0x8(%ebp),%eax
  801db2:	6a 00                	push   $0x0
  801db4:	6a 00                	push   $0x0
  801db6:	6a 00                	push   $0x0
  801db8:	52                   	push   %edx
  801db9:	50                   	push   %eax
  801dba:	6a 2f                	push   $0x2f
  801dbc:	e8 a7 f9 ff ff       	call   801768 <syscall>
  801dc1:	83 c4 18             	add    $0x18,%esp
}
  801dc4:	c9                   	leave  
  801dc5:	c3                   	ret    

00801dc6 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801dc6:	55                   	push   %ebp
  801dc7:	89 e5                	mov    %esp,%ebp
  801dc9:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801dcc:	83 ec 0c             	sub    $0xc,%esp
  801dcf:	68 b0 3e 80 00       	push   $0x803eb0
  801dd4:	e8 6b e8 ff ff       	call   800644 <cprintf>
  801dd9:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801ddc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801de3:	83 ec 0c             	sub    $0xc,%esp
  801de6:	68 dc 3e 80 00       	push   $0x803edc
  801deb:	e8 54 e8 ff ff       	call   800644 <cprintf>
  801df0:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801df3:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801df7:	a1 38 51 80 00       	mov    0x805138,%eax
  801dfc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dff:	eb 56                	jmp    801e57 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e01:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e05:	74 1c                	je     801e23 <print_mem_block_lists+0x5d>
  801e07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e0a:	8b 50 08             	mov    0x8(%eax),%edx
  801e0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e10:	8b 48 08             	mov    0x8(%eax),%ecx
  801e13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e16:	8b 40 0c             	mov    0xc(%eax),%eax
  801e19:	01 c8                	add    %ecx,%eax
  801e1b:	39 c2                	cmp    %eax,%edx
  801e1d:	73 04                	jae    801e23 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801e1f:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e26:	8b 50 08             	mov    0x8(%eax),%edx
  801e29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e2c:	8b 40 0c             	mov    0xc(%eax),%eax
  801e2f:	01 c2                	add    %eax,%edx
  801e31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e34:	8b 40 08             	mov    0x8(%eax),%eax
  801e37:	83 ec 04             	sub    $0x4,%esp
  801e3a:	52                   	push   %edx
  801e3b:	50                   	push   %eax
  801e3c:	68 f1 3e 80 00       	push   $0x803ef1
  801e41:	e8 fe e7 ff ff       	call   800644 <cprintf>
  801e46:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e4f:	a1 40 51 80 00       	mov    0x805140,%eax
  801e54:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e57:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e5b:	74 07                	je     801e64 <print_mem_block_lists+0x9e>
  801e5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e60:	8b 00                	mov    (%eax),%eax
  801e62:	eb 05                	jmp    801e69 <print_mem_block_lists+0xa3>
  801e64:	b8 00 00 00 00       	mov    $0x0,%eax
  801e69:	a3 40 51 80 00       	mov    %eax,0x805140
  801e6e:	a1 40 51 80 00       	mov    0x805140,%eax
  801e73:	85 c0                	test   %eax,%eax
  801e75:	75 8a                	jne    801e01 <print_mem_block_lists+0x3b>
  801e77:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e7b:	75 84                	jne    801e01 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801e7d:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e81:	75 10                	jne    801e93 <print_mem_block_lists+0xcd>
  801e83:	83 ec 0c             	sub    $0xc,%esp
  801e86:	68 00 3f 80 00       	push   $0x803f00
  801e8b:	e8 b4 e7 ff ff       	call   800644 <cprintf>
  801e90:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801e93:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801e9a:	83 ec 0c             	sub    $0xc,%esp
  801e9d:	68 24 3f 80 00       	push   $0x803f24
  801ea2:	e8 9d e7 ff ff       	call   800644 <cprintf>
  801ea7:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801eaa:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801eae:	a1 40 50 80 00       	mov    0x805040,%eax
  801eb3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801eb6:	eb 56                	jmp    801f0e <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801eb8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ebc:	74 1c                	je     801eda <print_mem_block_lists+0x114>
  801ebe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec1:	8b 50 08             	mov    0x8(%eax),%edx
  801ec4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ec7:	8b 48 08             	mov    0x8(%eax),%ecx
  801eca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ecd:	8b 40 0c             	mov    0xc(%eax),%eax
  801ed0:	01 c8                	add    %ecx,%eax
  801ed2:	39 c2                	cmp    %eax,%edx
  801ed4:	73 04                	jae    801eda <print_mem_block_lists+0x114>
			sorted = 0 ;
  801ed6:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801eda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801edd:	8b 50 08             	mov    0x8(%eax),%edx
  801ee0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee3:	8b 40 0c             	mov    0xc(%eax),%eax
  801ee6:	01 c2                	add    %eax,%edx
  801ee8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eeb:	8b 40 08             	mov    0x8(%eax),%eax
  801eee:	83 ec 04             	sub    $0x4,%esp
  801ef1:	52                   	push   %edx
  801ef2:	50                   	push   %eax
  801ef3:	68 f1 3e 80 00       	push   $0x803ef1
  801ef8:	e8 47 e7 ff ff       	call   800644 <cprintf>
  801efd:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f03:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f06:	a1 48 50 80 00       	mov    0x805048,%eax
  801f0b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f0e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f12:	74 07                	je     801f1b <print_mem_block_lists+0x155>
  801f14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f17:	8b 00                	mov    (%eax),%eax
  801f19:	eb 05                	jmp    801f20 <print_mem_block_lists+0x15a>
  801f1b:	b8 00 00 00 00       	mov    $0x0,%eax
  801f20:	a3 48 50 80 00       	mov    %eax,0x805048
  801f25:	a1 48 50 80 00       	mov    0x805048,%eax
  801f2a:	85 c0                	test   %eax,%eax
  801f2c:	75 8a                	jne    801eb8 <print_mem_block_lists+0xf2>
  801f2e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f32:	75 84                	jne    801eb8 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801f34:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f38:	75 10                	jne    801f4a <print_mem_block_lists+0x184>
  801f3a:	83 ec 0c             	sub    $0xc,%esp
  801f3d:	68 3c 3f 80 00       	push   $0x803f3c
  801f42:	e8 fd e6 ff ff       	call   800644 <cprintf>
  801f47:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801f4a:	83 ec 0c             	sub    $0xc,%esp
  801f4d:	68 b0 3e 80 00       	push   $0x803eb0
  801f52:	e8 ed e6 ff ff       	call   800644 <cprintf>
  801f57:	83 c4 10             	add    $0x10,%esp

}
  801f5a:	90                   	nop
  801f5b:	c9                   	leave  
  801f5c:	c3                   	ret    

00801f5d <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801f5d:	55                   	push   %ebp
  801f5e:	89 e5                	mov    %esp,%ebp
  801f60:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801f63:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  801f6a:	00 00 00 
  801f6d:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  801f74:	00 00 00 
  801f77:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  801f7e:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801f81:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801f88:	e9 9e 00 00 00       	jmp    80202b <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801f8d:	a1 50 50 80 00       	mov    0x805050,%eax
  801f92:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f95:	c1 e2 04             	shl    $0x4,%edx
  801f98:	01 d0                	add    %edx,%eax
  801f9a:	85 c0                	test   %eax,%eax
  801f9c:	75 14                	jne    801fb2 <initialize_MemBlocksList+0x55>
  801f9e:	83 ec 04             	sub    $0x4,%esp
  801fa1:	68 64 3f 80 00       	push   $0x803f64
  801fa6:	6a 46                	push   $0x46
  801fa8:	68 87 3f 80 00       	push   $0x803f87
  801fad:	e8 de e3 ff ff       	call   800390 <_panic>
  801fb2:	a1 50 50 80 00       	mov    0x805050,%eax
  801fb7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fba:	c1 e2 04             	shl    $0x4,%edx
  801fbd:	01 d0                	add    %edx,%eax
  801fbf:	8b 15 48 51 80 00    	mov    0x805148,%edx
  801fc5:	89 10                	mov    %edx,(%eax)
  801fc7:	8b 00                	mov    (%eax),%eax
  801fc9:	85 c0                	test   %eax,%eax
  801fcb:	74 18                	je     801fe5 <initialize_MemBlocksList+0x88>
  801fcd:	a1 48 51 80 00       	mov    0x805148,%eax
  801fd2:	8b 15 50 50 80 00    	mov    0x805050,%edx
  801fd8:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801fdb:	c1 e1 04             	shl    $0x4,%ecx
  801fde:	01 ca                	add    %ecx,%edx
  801fe0:	89 50 04             	mov    %edx,0x4(%eax)
  801fe3:	eb 12                	jmp    801ff7 <initialize_MemBlocksList+0x9a>
  801fe5:	a1 50 50 80 00       	mov    0x805050,%eax
  801fea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fed:	c1 e2 04             	shl    $0x4,%edx
  801ff0:	01 d0                	add    %edx,%eax
  801ff2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801ff7:	a1 50 50 80 00       	mov    0x805050,%eax
  801ffc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fff:	c1 e2 04             	shl    $0x4,%edx
  802002:	01 d0                	add    %edx,%eax
  802004:	a3 48 51 80 00       	mov    %eax,0x805148
  802009:	a1 50 50 80 00       	mov    0x805050,%eax
  80200e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802011:	c1 e2 04             	shl    $0x4,%edx
  802014:	01 d0                	add    %edx,%eax
  802016:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80201d:	a1 54 51 80 00       	mov    0x805154,%eax
  802022:	40                   	inc    %eax
  802023:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802028:	ff 45 f4             	incl   -0xc(%ebp)
  80202b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80202e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802031:	0f 82 56 ff ff ff    	jb     801f8d <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802037:	90                   	nop
  802038:	c9                   	leave  
  802039:	c3                   	ret    

0080203a <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80203a:	55                   	push   %ebp
  80203b:	89 e5                	mov    %esp,%ebp
  80203d:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802040:	8b 45 08             	mov    0x8(%ebp),%eax
  802043:	8b 00                	mov    (%eax),%eax
  802045:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802048:	eb 19                	jmp    802063 <find_block+0x29>
	{
		if(va==point->sva)
  80204a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80204d:	8b 40 08             	mov    0x8(%eax),%eax
  802050:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802053:	75 05                	jne    80205a <find_block+0x20>
		   return point;
  802055:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802058:	eb 36                	jmp    802090 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80205a:	8b 45 08             	mov    0x8(%ebp),%eax
  80205d:	8b 40 08             	mov    0x8(%eax),%eax
  802060:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802063:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802067:	74 07                	je     802070 <find_block+0x36>
  802069:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80206c:	8b 00                	mov    (%eax),%eax
  80206e:	eb 05                	jmp    802075 <find_block+0x3b>
  802070:	b8 00 00 00 00       	mov    $0x0,%eax
  802075:	8b 55 08             	mov    0x8(%ebp),%edx
  802078:	89 42 08             	mov    %eax,0x8(%edx)
  80207b:	8b 45 08             	mov    0x8(%ebp),%eax
  80207e:	8b 40 08             	mov    0x8(%eax),%eax
  802081:	85 c0                	test   %eax,%eax
  802083:	75 c5                	jne    80204a <find_block+0x10>
  802085:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802089:	75 bf                	jne    80204a <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  80208b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802090:	c9                   	leave  
  802091:	c3                   	ret    

00802092 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802092:	55                   	push   %ebp
  802093:	89 e5                	mov    %esp,%ebp
  802095:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802098:	a1 40 50 80 00       	mov    0x805040,%eax
  80209d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8020a0:	a1 44 50 80 00       	mov    0x805044,%eax
  8020a5:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8020a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020ab:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8020ae:	74 24                	je     8020d4 <insert_sorted_allocList+0x42>
  8020b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b3:	8b 50 08             	mov    0x8(%eax),%edx
  8020b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020b9:	8b 40 08             	mov    0x8(%eax),%eax
  8020bc:	39 c2                	cmp    %eax,%edx
  8020be:	76 14                	jbe    8020d4 <insert_sorted_allocList+0x42>
  8020c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c3:	8b 50 08             	mov    0x8(%eax),%edx
  8020c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020c9:	8b 40 08             	mov    0x8(%eax),%eax
  8020cc:	39 c2                	cmp    %eax,%edx
  8020ce:	0f 82 60 01 00 00    	jb     802234 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8020d4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020d8:	75 65                	jne    80213f <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8020da:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020de:	75 14                	jne    8020f4 <insert_sorted_allocList+0x62>
  8020e0:	83 ec 04             	sub    $0x4,%esp
  8020e3:	68 64 3f 80 00       	push   $0x803f64
  8020e8:	6a 6b                	push   $0x6b
  8020ea:	68 87 3f 80 00       	push   $0x803f87
  8020ef:	e8 9c e2 ff ff       	call   800390 <_panic>
  8020f4:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8020fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fd:	89 10                	mov    %edx,(%eax)
  8020ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802102:	8b 00                	mov    (%eax),%eax
  802104:	85 c0                	test   %eax,%eax
  802106:	74 0d                	je     802115 <insert_sorted_allocList+0x83>
  802108:	a1 40 50 80 00       	mov    0x805040,%eax
  80210d:	8b 55 08             	mov    0x8(%ebp),%edx
  802110:	89 50 04             	mov    %edx,0x4(%eax)
  802113:	eb 08                	jmp    80211d <insert_sorted_allocList+0x8b>
  802115:	8b 45 08             	mov    0x8(%ebp),%eax
  802118:	a3 44 50 80 00       	mov    %eax,0x805044
  80211d:	8b 45 08             	mov    0x8(%ebp),%eax
  802120:	a3 40 50 80 00       	mov    %eax,0x805040
  802125:	8b 45 08             	mov    0x8(%ebp),%eax
  802128:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80212f:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802134:	40                   	inc    %eax
  802135:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80213a:	e9 dc 01 00 00       	jmp    80231b <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  80213f:	8b 45 08             	mov    0x8(%ebp),%eax
  802142:	8b 50 08             	mov    0x8(%eax),%edx
  802145:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802148:	8b 40 08             	mov    0x8(%eax),%eax
  80214b:	39 c2                	cmp    %eax,%edx
  80214d:	77 6c                	ja     8021bb <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  80214f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802153:	74 06                	je     80215b <insert_sorted_allocList+0xc9>
  802155:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802159:	75 14                	jne    80216f <insert_sorted_allocList+0xdd>
  80215b:	83 ec 04             	sub    $0x4,%esp
  80215e:	68 a0 3f 80 00       	push   $0x803fa0
  802163:	6a 6f                	push   $0x6f
  802165:	68 87 3f 80 00       	push   $0x803f87
  80216a:	e8 21 e2 ff ff       	call   800390 <_panic>
  80216f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802172:	8b 50 04             	mov    0x4(%eax),%edx
  802175:	8b 45 08             	mov    0x8(%ebp),%eax
  802178:	89 50 04             	mov    %edx,0x4(%eax)
  80217b:	8b 45 08             	mov    0x8(%ebp),%eax
  80217e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802181:	89 10                	mov    %edx,(%eax)
  802183:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802186:	8b 40 04             	mov    0x4(%eax),%eax
  802189:	85 c0                	test   %eax,%eax
  80218b:	74 0d                	je     80219a <insert_sorted_allocList+0x108>
  80218d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802190:	8b 40 04             	mov    0x4(%eax),%eax
  802193:	8b 55 08             	mov    0x8(%ebp),%edx
  802196:	89 10                	mov    %edx,(%eax)
  802198:	eb 08                	jmp    8021a2 <insert_sorted_allocList+0x110>
  80219a:	8b 45 08             	mov    0x8(%ebp),%eax
  80219d:	a3 40 50 80 00       	mov    %eax,0x805040
  8021a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8021a8:	89 50 04             	mov    %edx,0x4(%eax)
  8021ab:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8021b0:	40                   	inc    %eax
  8021b1:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8021b6:	e9 60 01 00 00       	jmp    80231b <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8021bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021be:	8b 50 08             	mov    0x8(%eax),%edx
  8021c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021c4:	8b 40 08             	mov    0x8(%eax),%eax
  8021c7:	39 c2                	cmp    %eax,%edx
  8021c9:	0f 82 4c 01 00 00    	jb     80231b <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8021cf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021d3:	75 14                	jne    8021e9 <insert_sorted_allocList+0x157>
  8021d5:	83 ec 04             	sub    $0x4,%esp
  8021d8:	68 d8 3f 80 00       	push   $0x803fd8
  8021dd:	6a 73                	push   $0x73
  8021df:	68 87 3f 80 00       	push   $0x803f87
  8021e4:	e8 a7 e1 ff ff       	call   800390 <_panic>
  8021e9:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8021ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f2:	89 50 04             	mov    %edx,0x4(%eax)
  8021f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f8:	8b 40 04             	mov    0x4(%eax),%eax
  8021fb:	85 c0                	test   %eax,%eax
  8021fd:	74 0c                	je     80220b <insert_sorted_allocList+0x179>
  8021ff:	a1 44 50 80 00       	mov    0x805044,%eax
  802204:	8b 55 08             	mov    0x8(%ebp),%edx
  802207:	89 10                	mov    %edx,(%eax)
  802209:	eb 08                	jmp    802213 <insert_sorted_allocList+0x181>
  80220b:	8b 45 08             	mov    0x8(%ebp),%eax
  80220e:	a3 40 50 80 00       	mov    %eax,0x805040
  802213:	8b 45 08             	mov    0x8(%ebp),%eax
  802216:	a3 44 50 80 00       	mov    %eax,0x805044
  80221b:	8b 45 08             	mov    0x8(%ebp),%eax
  80221e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802224:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802229:	40                   	inc    %eax
  80222a:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80222f:	e9 e7 00 00 00       	jmp    80231b <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802234:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802237:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  80223a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802241:	a1 40 50 80 00       	mov    0x805040,%eax
  802246:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802249:	e9 9d 00 00 00       	jmp    8022eb <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  80224e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802251:	8b 00                	mov    (%eax),%eax
  802253:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802256:	8b 45 08             	mov    0x8(%ebp),%eax
  802259:	8b 50 08             	mov    0x8(%eax),%edx
  80225c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225f:	8b 40 08             	mov    0x8(%eax),%eax
  802262:	39 c2                	cmp    %eax,%edx
  802264:	76 7d                	jbe    8022e3 <insert_sorted_allocList+0x251>
  802266:	8b 45 08             	mov    0x8(%ebp),%eax
  802269:	8b 50 08             	mov    0x8(%eax),%edx
  80226c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80226f:	8b 40 08             	mov    0x8(%eax),%eax
  802272:	39 c2                	cmp    %eax,%edx
  802274:	73 6d                	jae    8022e3 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802276:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80227a:	74 06                	je     802282 <insert_sorted_allocList+0x1f0>
  80227c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802280:	75 14                	jne    802296 <insert_sorted_allocList+0x204>
  802282:	83 ec 04             	sub    $0x4,%esp
  802285:	68 fc 3f 80 00       	push   $0x803ffc
  80228a:	6a 7f                	push   $0x7f
  80228c:	68 87 3f 80 00       	push   $0x803f87
  802291:	e8 fa e0 ff ff       	call   800390 <_panic>
  802296:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802299:	8b 10                	mov    (%eax),%edx
  80229b:	8b 45 08             	mov    0x8(%ebp),%eax
  80229e:	89 10                	mov    %edx,(%eax)
  8022a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a3:	8b 00                	mov    (%eax),%eax
  8022a5:	85 c0                	test   %eax,%eax
  8022a7:	74 0b                	je     8022b4 <insert_sorted_allocList+0x222>
  8022a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ac:	8b 00                	mov    (%eax),%eax
  8022ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8022b1:	89 50 04             	mov    %edx,0x4(%eax)
  8022b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8022ba:	89 10                	mov    %edx,(%eax)
  8022bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022c2:	89 50 04             	mov    %edx,0x4(%eax)
  8022c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c8:	8b 00                	mov    (%eax),%eax
  8022ca:	85 c0                	test   %eax,%eax
  8022cc:	75 08                	jne    8022d6 <insert_sorted_allocList+0x244>
  8022ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d1:	a3 44 50 80 00       	mov    %eax,0x805044
  8022d6:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8022db:	40                   	inc    %eax
  8022dc:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8022e1:	eb 39                	jmp    80231c <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8022e3:	a1 48 50 80 00       	mov    0x805048,%eax
  8022e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022ef:	74 07                	je     8022f8 <insert_sorted_allocList+0x266>
  8022f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f4:	8b 00                	mov    (%eax),%eax
  8022f6:	eb 05                	jmp    8022fd <insert_sorted_allocList+0x26b>
  8022f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8022fd:	a3 48 50 80 00       	mov    %eax,0x805048
  802302:	a1 48 50 80 00       	mov    0x805048,%eax
  802307:	85 c0                	test   %eax,%eax
  802309:	0f 85 3f ff ff ff    	jne    80224e <insert_sorted_allocList+0x1bc>
  80230f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802313:	0f 85 35 ff ff ff    	jne    80224e <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802319:	eb 01                	jmp    80231c <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80231b:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80231c:	90                   	nop
  80231d:	c9                   	leave  
  80231e:	c3                   	ret    

0080231f <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80231f:	55                   	push   %ebp
  802320:	89 e5                	mov    %esp,%ebp
  802322:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802325:	a1 38 51 80 00       	mov    0x805138,%eax
  80232a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80232d:	e9 85 01 00 00       	jmp    8024b7 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802332:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802335:	8b 40 0c             	mov    0xc(%eax),%eax
  802338:	3b 45 08             	cmp    0x8(%ebp),%eax
  80233b:	0f 82 6e 01 00 00    	jb     8024af <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802341:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802344:	8b 40 0c             	mov    0xc(%eax),%eax
  802347:	3b 45 08             	cmp    0x8(%ebp),%eax
  80234a:	0f 85 8a 00 00 00    	jne    8023da <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802350:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802354:	75 17                	jne    80236d <alloc_block_FF+0x4e>
  802356:	83 ec 04             	sub    $0x4,%esp
  802359:	68 30 40 80 00       	push   $0x804030
  80235e:	68 93 00 00 00       	push   $0x93
  802363:	68 87 3f 80 00       	push   $0x803f87
  802368:	e8 23 e0 ff ff       	call   800390 <_panic>
  80236d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802370:	8b 00                	mov    (%eax),%eax
  802372:	85 c0                	test   %eax,%eax
  802374:	74 10                	je     802386 <alloc_block_FF+0x67>
  802376:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802379:	8b 00                	mov    (%eax),%eax
  80237b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80237e:	8b 52 04             	mov    0x4(%edx),%edx
  802381:	89 50 04             	mov    %edx,0x4(%eax)
  802384:	eb 0b                	jmp    802391 <alloc_block_FF+0x72>
  802386:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802389:	8b 40 04             	mov    0x4(%eax),%eax
  80238c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802391:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802394:	8b 40 04             	mov    0x4(%eax),%eax
  802397:	85 c0                	test   %eax,%eax
  802399:	74 0f                	je     8023aa <alloc_block_FF+0x8b>
  80239b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239e:	8b 40 04             	mov    0x4(%eax),%eax
  8023a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023a4:	8b 12                	mov    (%edx),%edx
  8023a6:	89 10                	mov    %edx,(%eax)
  8023a8:	eb 0a                	jmp    8023b4 <alloc_block_FF+0x95>
  8023aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ad:	8b 00                	mov    (%eax),%eax
  8023af:	a3 38 51 80 00       	mov    %eax,0x805138
  8023b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023c7:	a1 44 51 80 00       	mov    0x805144,%eax
  8023cc:	48                   	dec    %eax
  8023cd:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  8023d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d5:	e9 10 01 00 00       	jmp    8024ea <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8023da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023dd:	8b 40 0c             	mov    0xc(%eax),%eax
  8023e0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023e3:	0f 86 c6 00 00 00    	jbe    8024af <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8023e9:	a1 48 51 80 00       	mov    0x805148,%eax
  8023ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8023f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f4:	8b 50 08             	mov    0x8(%eax),%edx
  8023f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023fa:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8023fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802400:	8b 55 08             	mov    0x8(%ebp),%edx
  802403:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802406:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80240a:	75 17                	jne    802423 <alloc_block_FF+0x104>
  80240c:	83 ec 04             	sub    $0x4,%esp
  80240f:	68 30 40 80 00       	push   $0x804030
  802414:	68 9b 00 00 00       	push   $0x9b
  802419:	68 87 3f 80 00       	push   $0x803f87
  80241e:	e8 6d df ff ff       	call   800390 <_panic>
  802423:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802426:	8b 00                	mov    (%eax),%eax
  802428:	85 c0                	test   %eax,%eax
  80242a:	74 10                	je     80243c <alloc_block_FF+0x11d>
  80242c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80242f:	8b 00                	mov    (%eax),%eax
  802431:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802434:	8b 52 04             	mov    0x4(%edx),%edx
  802437:	89 50 04             	mov    %edx,0x4(%eax)
  80243a:	eb 0b                	jmp    802447 <alloc_block_FF+0x128>
  80243c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80243f:	8b 40 04             	mov    0x4(%eax),%eax
  802442:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802447:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80244a:	8b 40 04             	mov    0x4(%eax),%eax
  80244d:	85 c0                	test   %eax,%eax
  80244f:	74 0f                	je     802460 <alloc_block_FF+0x141>
  802451:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802454:	8b 40 04             	mov    0x4(%eax),%eax
  802457:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80245a:	8b 12                	mov    (%edx),%edx
  80245c:	89 10                	mov    %edx,(%eax)
  80245e:	eb 0a                	jmp    80246a <alloc_block_FF+0x14b>
  802460:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802463:	8b 00                	mov    (%eax),%eax
  802465:	a3 48 51 80 00       	mov    %eax,0x805148
  80246a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80246d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802473:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802476:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80247d:	a1 54 51 80 00       	mov    0x805154,%eax
  802482:	48                   	dec    %eax
  802483:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802488:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248b:	8b 50 08             	mov    0x8(%eax),%edx
  80248e:	8b 45 08             	mov    0x8(%ebp),%eax
  802491:	01 c2                	add    %eax,%edx
  802493:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802496:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802499:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249c:	8b 40 0c             	mov    0xc(%eax),%eax
  80249f:	2b 45 08             	sub    0x8(%ebp),%eax
  8024a2:	89 c2                	mov    %eax,%edx
  8024a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a7:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8024aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024ad:	eb 3b                	jmp    8024ea <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8024af:	a1 40 51 80 00       	mov    0x805140,%eax
  8024b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024bb:	74 07                	je     8024c4 <alloc_block_FF+0x1a5>
  8024bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c0:	8b 00                	mov    (%eax),%eax
  8024c2:	eb 05                	jmp    8024c9 <alloc_block_FF+0x1aa>
  8024c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8024c9:	a3 40 51 80 00       	mov    %eax,0x805140
  8024ce:	a1 40 51 80 00       	mov    0x805140,%eax
  8024d3:	85 c0                	test   %eax,%eax
  8024d5:	0f 85 57 fe ff ff    	jne    802332 <alloc_block_FF+0x13>
  8024db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024df:	0f 85 4d fe ff ff    	jne    802332 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8024e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024ea:	c9                   	leave  
  8024eb:	c3                   	ret    

008024ec <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8024ec:	55                   	push   %ebp
  8024ed:	89 e5                	mov    %esp,%ebp
  8024ef:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8024f2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8024f9:	a1 38 51 80 00       	mov    0x805138,%eax
  8024fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802501:	e9 df 00 00 00       	jmp    8025e5 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802506:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802509:	8b 40 0c             	mov    0xc(%eax),%eax
  80250c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80250f:	0f 82 c8 00 00 00    	jb     8025dd <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802515:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802518:	8b 40 0c             	mov    0xc(%eax),%eax
  80251b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80251e:	0f 85 8a 00 00 00    	jne    8025ae <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802524:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802528:	75 17                	jne    802541 <alloc_block_BF+0x55>
  80252a:	83 ec 04             	sub    $0x4,%esp
  80252d:	68 30 40 80 00       	push   $0x804030
  802532:	68 b7 00 00 00       	push   $0xb7
  802537:	68 87 3f 80 00       	push   $0x803f87
  80253c:	e8 4f de ff ff       	call   800390 <_panic>
  802541:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802544:	8b 00                	mov    (%eax),%eax
  802546:	85 c0                	test   %eax,%eax
  802548:	74 10                	je     80255a <alloc_block_BF+0x6e>
  80254a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254d:	8b 00                	mov    (%eax),%eax
  80254f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802552:	8b 52 04             	mov    0x4(%edx),%edx
  802555:	89 50 04             	mov    %edx,0x4(%eax)
  802558:	eb 0b                	jmp    802565 <alloc_block_BF+0x79>
  80255a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255d:	8b 40 04             	mov    0x4(%eax),%eax
  802560:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802565:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802568:	8b 40 04             	mov    0x4(%eax),%eax
  80256b:	85 c0                	test   %eax,%eax
  80256d:	74 0f                	je     80257e <alloc_block_BF+0x92>
  80256f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802572:	8b 40 04             	mov    0x4(%eax),%eax
  802575:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802578:	8b 12                	mov    (%edx),%edx
  80257a:	89 10                	mov    %edx,(%eax)
  80257c:	eb 0a                	jmp    802588 <alloc_block_BF+0x9c>
  80257e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802581:	8b 00                	mov    (%eax),%eax
  802583:	a3 38 51 80 00       	mov    %eax,0x805138
  802588:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802591:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802594:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80259b:	a1 44 51 80 00       	mov    0x805144,%eax
  8025a0:	48                   	dec    %eax
  8025a1:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  8025a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a9:	e9 4d 01 00 00       	jmp    8026fb <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8025ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b1:	8b 40 0c             	mov    0xc(%eax),%eax
  8025b4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025b7:	76 24                	jbe    8025dd <alloc_block_BF+0xf1>
  8025b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8025bf:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8025c2:	73 19                	jae    8025dd <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8025c4:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8025cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ce:	8b 40 0c             	mov    0xc(%eax),%eax
  8025d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8025d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d7:	8b 40 08             	mov    0x8(%eax),%eax
  8025da:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8025dd:	a1 40 51 80 00       	mov    0x805140,%eax
  8025e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025e9:	74 07                	je     8025f2 <alloc_block_BF+0x106>
  8025eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ee:	8b 00                	mov    (%eax),%eax
  8025f0:	eb 05                	jmp    8025f7 <alloc_block_BF+0x10b>
  8025f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8025f7:	a3 40 51 80 00       	mov    %eax,0x805140
  8025fc:	a1 40 51 80 00       	mov    0x805140,%eax
  802601:	85 c0                	test   %eax,%eax
  802603:	0f 85 fd fe ff ff    	jne    802506 <alloc_block_BF+0x1a>
  802609:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80260d:	0f 85 f3 fe ff ff    	jne    802506 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802613:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802617:	0f 84 d9 00 00 00    	je     8026f6 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  80261d:	a1 48 51 80 00       	mov    0x805148,%eax
  802622:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802625:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802628:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80262b:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  80262e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802631:	8b 55 08             	mov    0x8(%ebp),%edx
  802634:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802637:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80263b:	75 17                	jne    802654 <alloc_block_BF+0x168>
  80263d:	83 ec 04             	sub    $0x4,%esp
  802640:	68 30 40 80 00       	push   $0x804030
  802645:	68 c7 00 00 00       	push   $0xc7
  80264a:	68 87 3f 80 00       	push   $0x803f87
  80264f:	e8 3c dd ff ff       	call   800390 <_panic>
  802654:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802657:	8b 00                	mov    (%eax),%eax
  802659:	85 c0                	test   %eax,%eax
  80265b:	74 10                	je     80266d <alloc_block_BF+0x181>
  80265d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802660:	8b 00                	mov    (%eax),%eax
  802662:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802665:	8b 52 04             	mov    0x4(%edx),%edx
  802668:	89 50 04             	mov    %edx,0x4(%eax)
  80266b:	eb 0b                	jmp    802678 <alloc_block_BF+0x18c>
  80266d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802670:	8b 40 04             	mov    0x4(%eax),%eax
  802673:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802678:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80267b:	8b 40 04             	mov    0x4(%eax),%eax
  80267e:	85 c0                	test   %eax,%eax
  802680:	74 0f                	je     802691 <alloc_block_BF+0x1a5>
  802682:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802685:	8b 40 04             	mov    0x4(%eax),%eax
  802688:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80268b:	8b 12                	mov    (%edx),%edx
  80268d:	89 10                	mov    %edx,(%eax)
  80268f:	eb 0a                	jmp    80269b <alloc_block_BF+0x1af>
  802691:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802694:	8b 00                	mov    (%eax),%eax
  802696:	a3 48 51 80 00       	mov    %eax,0x805148
  80269b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80269e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026a7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026ae:	a1 54 51 80 00       	mov    0x805154,%eax
  8026b3:	48                   	dec    %eax
  8026b4:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8026b9:	83 ec 08             	sub    $0x8,%esp
  8026bc:	ff 75 ec             	pushl  -0x14(%ebp)
  8026bf:	68 38 51 80 00       	push   $0x805138
  8026c4:	e8 71 f9 ff ff       	call   80203a <find_block>
  8026c9:	83 c4 10             	add    $0x10,%esp
  8026cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8026cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026d2:	8b 50 08             	mov    0x8(%eax),%edx
  8026d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d8:	01 c2                	add    %eax,%edx
  8026da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026dd:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8026e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026e3:	8b 40 0c             	mov    0xc(%eax),%eax
  8026e6:	2b 45 08             	sub    0x8(%ebp),%eax
  8026e9:	89 c2                	mov    %eax,%edx
  8026eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026ee:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8026f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026f4:	eb 05                	jmp    8026fb <alloc_block_BF+0x20f>
	}
	return NULL;
  8026f6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026fb:	c9                   	leave  
  8026fc:	c3                   	ret    

008026fd <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8026fd:	55                   	push   %ebp
  8026fe:	89 e5                	mov    %esp,%ebp
  802700:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802703:	a1 28 50 80 00       	mov    0x805028,%eax
  802708:	85 c0                	test   %eax,%eax
  80270a:	0f 85 de 01 00 00    	jne    8028ee <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802710:	a1 38 51 80 00       	mov    0x805138,%eax
  802715:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802718:	e9 9e 01 00 00       	jmp    8028bb <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  80271d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802720:	8b 40 0c             	mov    0xc(%eax),%eax
  802723:	3b 45 08             	cmp    0x8(%ebp),%eax
  802726:	0f 82 87 01 00 00    	jb     8028b3 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  80272c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272f:	8b 40 0c             	mov    0xc(%eax),%eax
  802732:	3b 45 08             	cmp    0x8(%ebp),%eax
  802735:	0f 85 95 00 00 00    	jne    8027d0 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  80273b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80273f:	75 17                	jne    802758 <alloc_block_NF+0x5b>
  802741:	83 ec 04             	sub    $0x4,%esp
  802744:	68 30 40 80 00       	push   $0x804030
  802749:	68 e0 00 00 00       	push   $0xe0
  80274e:	68 87 3f 80 00       	push   $0x803f87
  802753:	e8 38 dc ff ff       	call   800390 <_panic>
  802758:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275b:	8b 00                	mov    (%eax),%eax
  80275d:	85 c0                	test   %eax,%eax
  80275f:	74 10                	je     802771 <alloc_block_NF+0x74>
  802761:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802764:	8b 00                	mov    (%eax),%eax
  802766:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802769:	8b 52 04             	mov    0x4(%edx),%edx
  80276c:	89 50 04             	mov    %edx,0x4(%eax)
  80276f:	eb 0b                	jmp    80277c <alloc_block_NF+0x7f>
  802771:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802774:	8b 40 04             	mov    0x4(%eax),%eax
  802777:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80277c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277f:	8b 40 04             	mov    0x4(%eax),%eax
  802782:	85 c0                	test   %eax,%eax
  802784:	74 0f                	je     802795 <alloc_block_NF+0x98>
  802786:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802789:	8b 40 04             	mov    0x4(%eax),%eax
  80278c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80278f:	8b 12                	mov    (%edx),%edx
  802791:	89 10                	mov    %edx,(%eax)
  802793:	eb 0a                	jmp    80279f <alloc_block_NF+0xa2>
  802795:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802798:	8b 00                	mov    (%eax),%eax
  80279a:	a3 38 51 80 00       	mov    %eax,0x805138
  80279f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027b2:	a1 44 51 80 00       	mov    0x805144,%eax
  8027b7:	48                   	dec    %eax
  8027b8:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  8027bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c0:	8b 40 08             	mov    0x8(%eax),%eax
  8027c3:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  8027c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cb:	e9 f8 04 00 00       	jmp    802cc8 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8027d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d3:	8b 40 0c             	mov    0xc(%eax),%eax
  8027d6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027d9:	0f 86 d4 00 00 00    	jbe    8028b3 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8027df:	a1 48 51 80 00       	mov    0x805148,%eax
  8027e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8027e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ea:	8b 50 08             	mov    0x8(%eax),%edx
  8027ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f0:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8027f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8027f9:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8027fc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802800:	75 17                	jne    802819 <alloc_block_NF+0x11c>
  802802:	83 ec 04             	sub    $0x4,%esp
  802805:	68 30 40 80 00       	push   $0x804030
  80280a:	68 e9 00 00 00       	push   $0xe9
  80280f:	68 87 3f 80 00       	push   $0x803f87
  802814:	e8 77 db ff ff       	call   800390 <_panic>
  802819:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80281c:	8b 00                	mov    (%eax),%eax
  80281e:	85 c0                	test   %eax,%eax
  802820:	74 10                	je     802832 <alloc_block_NF+0x135>
  802822:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802825:	8b 00                	mov    (%eax),%eax
  802827:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80282a:	8b 52 04             	mov    0x4(%edx),%edx
  80282d:	89 50 04             	mov    %edx,0x4(%eax)
  802830:	eb 0b                	jmp    80283d <alloc_block_NF+0x140>
  802832:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802835:	8b 40 04             	mov    0x4(%eax),%eax
  802838:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80283d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802840:	8b 40 04             	mov    0x4(%eax),%eax
  802843:	85 c0                	test   %eax,%eax
  802845:	74 0f                	je     802856 <alloc_block_NF+0x159>
  802847:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80284a:	8b 40 04             	mov    0x4(%eax),%eax
  80284d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802850:	8b 12                	mov    (%edx),%edx
  802852:	89 10                	mov    %edx,(%eax)
  802854:	eb 0a                	jmp    802860 <alloc_block_NF+0x163>
  802856:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802859:	8b 00                	mov    (%eax),%eax
  80285b:	a3 48 51 80 00       	mov    %eax,0x805148
  802860:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802863:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802869:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80286c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802873:	a1 54 51 80 00       	mov    0x805154,%eax
  802878:	48                   	dec    %eax
  802879:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  80287e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802881:	8b 40 08             	mov    0x8(%eax),%eax
  802884:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802889:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288c:	8b 50 08             	mov    0x8(%eax),%edx
  80288f:	8b 45 08             	mov    0x8(%ebp),%eax
  802892:	01 c2                	add    %eax,%edx
  802894:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802897:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  80289a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289d:	8b 40 0c             	mov    0xc(%eax),%eax
  8028a0:	2b 45 08             	sub    0x8(%ebp),%eax
  8028a3:	89 c2                	mov    %eax,%edx
  8028a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a8:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8028ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ae:	e9 15 04 00 00       	jmp    802cc8 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8028b3:	a1 40 51 80 00       	mov    0x805140,%eax
  8028b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028bf:	74 07                	je     8028c8 <alloc_block_NF+0x1cb>
  8028c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c4:	8b 00                	mov    (%eax),%eax
  8028c6:	eb 05                	jmp    8028cd <alloc_block_NF+0x1d0>
  8028c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8028cd:	a3 40 51 80 00       	mov    %eax,0x805140
  8028d2:	a1 40 51 80 00       	mov    0x805140,%eax
  8028d7:	85 c0                	test   %eax,%eax
  8028d9:	0f 85 3e fe ff ff    	jne    80271d <alloc_block_NF+0x20>
  8028df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028e3:	0f 85 34 fe ff ff    	jne    80271d <alloc_block_NF+0x20>
  8028e9:	e9 d5 03 00 00       	jmp    802cc3 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8028ee:	a1 38 51 80 00       	mov    0x805138,%eax
  8028f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028f6:	e9 b1 01 00 00       	jmp    802aac <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8028fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fe:	8b 50 08             	mov    0x8(%eax),%edx
  802901:	a1 28 50 80 00       	mov    0x805028,%eax
  802906:	39 c2                	cmp    %eax,%edx
  802908:	0f 82 96 01 00 00    	jb     802aa4 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  80290e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802911:	8b 40 0c             	mov    0xc(%eax),%eax
  802914:	3b 45 08             	cmp    0x8(%ebp),%eax
  802917:	0f 82 87 01 00 00    	jb     802aa4 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  80291d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802920:	8b 40 0c             	mov    0xc(%eax),%eax
  802923:	3b 45 08             	cmp    0x8(%ebp),%eax
  802926:	0f 85 95 00 00 00    	jne    8029c1 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80292c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802930:	75 17                	jne    802949 <alloc_block_NF+0x24c>
  802932:	83 ec 04             	sub    $0x4,%esp
  802935:	68 30 40 80 00       	push   $0x804030
  80293a:	68 fc 00 00 00       	push   $0xfc
  80293f:	68 87 3f 80 00       	push   $0x803f87
  802944:	e8 47 da ff ff       	call   800390 <_panic>
  802949:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294c:	8b 00                	mov    (%eax),%eax
  80294e:	85 c0                	test   %eax,%eax
  802950:	74 10                	je     802962 <alloc_block_NF+0x265>
  802952:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802955:	8b 00                	mov    (%eax),%eax
  802957:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80295a:	8b 52 04             	mov    0x4(%edx),%edx
  80295d:	89 50 04             	mov    %edx,0x4(%eax)
  802960:	eb 0b                	jmp    80296d <alloc_block_NF+0x270>
  802962:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802965:	8b 40 04             	mov    0x4(%eax),%eax
  802968:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80296d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802970:	8b 40 04             	mov    0x4(%eax),%eax
  802973:	85 c0                	test   %eax,%eax
  802975:	74 0f                	je     802986 <alloc_block_NF+0x289>
  802977:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297a:	8b 40 04             	mov    0x4(%eax),%eax
  80297d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802980:	8b 12                	mov    (%edx),%edx
  802982:	89 10                	mov    %edx,(%eax)
  802984:	eb 0a                	jmp    802990 <alloc_block_NF+0x293>
  802986:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802989:	8b 00                	mov    (%eax),%eax
  80298b:	a3 38 51 80 00       	mov    %eax,0x805138
  802990:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802993:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802999:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029a3:	a1 44 51 80 00       	mov    0x805144,%eax
  8029a8:	48                   	dec    %eax
  8029a9:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8029ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b1:	8b 40 08             	mov    0x8(%eax),%eax
  8029b4:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  8029b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bc:	e9 07 03 00 00       	jmp    802cc8 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8029c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c4:	8b 40 0c             	mov    0xc(%eax),%eax
  8029c7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029ca:	0f 86 d4 00 00 00    	jbe    802aa4 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8029d0:	a1 48 51 80 00       	mov    0x805148,%eax
  8029d5:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  8029d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029db:	8b 50 08             	mov    0x8(%eax),%edx
  8029de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029e1:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8029e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8029ea:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8029ed:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8029f1:	75 17                	jne    802a0a <alloc_block_NF+0x30d>
  8029f3:	83 ec 04             	sub    $0x4,%esp
  8029f6:	68 30 40 80 00       	push   $0x804030
  8029fb:	68 04 01 00 00       	push   $0x104
  802a00:	68 87 3f 80 00       	push   $0x803f87
  802a05:	e8 86 d9 ff ff       	call   800390 <_panic>
  802a0a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a0d:	8b 00                	mov    (%eax),%eax
  802a0f:	85 c0                	test   %eax,%eax
  802a11:	74 10                	je     802a23 <alloc_block_NF+0x326>
  802a13:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a16:	8b 00                	mov    (%eax),%eax
  802a18:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a1b:	8b 52 04             	mov    0x4(%edx),%edx
  802a1e:	89 50 04             	mov    %edx,0x4(%eax)
  802a21:	eb 0b                	jmp    802a2e <alloc_block_NF+0x331>
  802a23:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a26:	8b 40 04             	mov    0x4(%eax),%eax
  802a29:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a2e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a31:	8b 40 04             	mov    0x4(%eax),%eax
  802a34:	85 c0                	test   %eax,%eax
  802a36:	74 0f                	je     802a47 <alloc_block_NF+0x34a>
  802a38:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a3b:	8b 40 04             	mov    0x4(%eax),%eax
  802a3e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a41:	8b 12                	mov    (%edx),%edx
  802a43:	89 10                	mov    %edx,(%eax)
  802a45:	eb 0a                	jmp    802a51 <alloc_block_NF+0x354>
  802a47:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a4a:	8b 00                	mov    (%eax),%eax
  802a4c:	a3 48 51 80 00       	mov    %eax,0x805148
  802a51:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a54:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a5a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a5d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a64:	a1 54 51 80 00       	mov    0x805154,%eax
  802a69:	48                   	dec    %eax
  802a6a:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802a6f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a72:	8b 40 08             	mov    0x8(%eax),%eax
  802a75:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802a7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7d:	8b 50 08             	mov    0x8(%eax),%edx
  802a80:	8b 45 08             	mov    0x8(%ebp),%eax
  802a83:	01 c2                	add    %eax,%edx
  802a85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a88:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802a8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8e:	8b 40 0c             	mov    0xc(%eax),%eax
  802a91:	2b 45 08             	sub    0x8(%ebp),%eax
  802a94:	89 c2                	mov    %eax,%edx
  802a96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a99:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802a9c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a9f:	e9 24 02 00 00       	jmp    802cc8 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802aa4:	a1 40 51 80 00       	mov    0x805140,%eax
  802aa9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802aac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ab0:	74 07                	je     802ab9 <alloc_block_NF+0x3bc>
  802ab2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab5:	8b 00                	mov    (%eax),%eax
  802ab7:	eb 05                	jmp    802abe <alloc_block_NF+0x3c1>
  802ab9:	b8 00 00 00 00       	mov    $0x0,%eax
  802abe:	a3 40 51 80 00       	mov    %eax,0x805140
  802ac3:	a1 40 51 80 00       	mov    0x805140,%eax
  802ac8:	85 c0                	test   %eax,%eax
  802aca:	0f 85 2b fe ff ff    	jne    8028fb <alloc_block_NF+0x1fe>
  802ad0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ad4:	0f 85 21 fe ff ff    	jne    8028fb <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802ada:	a1 38 51 80 00       	mov    0x805138,%eax
  802adf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ae2:	e9 ae 01 00 00       	jmp    802c95 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802ae7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aea:	8b 50 08             	mov    0x8(%eax),%edx
  802aed:	a1 28 50 80 00       	mov    0x805028,%eax
  802af2:	39 c2                	cmp    %eax,%edx
  802af4:	0f 83 93 01 00 00    	jae    802c8d <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802afa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afd:	8b 40 0c             	mov    0xc(%eax),%eax
  802b00:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b03:	0f 82 84 01 00 00    	jb     802c8d <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802b09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0c:	8b 40 0c             	mov    0xc(%eax),%eax
  802b0f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b12:	0f 85 95 00 00 00    	jne    802bad <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802b18:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b1c:	75 17                	jne    802b35 <alloc_block_NF+0x438>
  802b1e:	83 ec 04             	sub    $0x4,%esp
  802b21:	68 30 40 80 00       	push   $0x804030
  802b26:	68 14 01 00 00       	push   $0x114
  802b2b:	68 87 3f 80 00       	push   $0x803f87
  802b30:	e8 5b d8 ff ff       	call   800390 <_panic>
  802b35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b38:	8b 00                	mov    (%eax),%eax
  802b3a:	85 c0                	test   %eax,%eax
  802b3c:	74 10                	je     802b4e <alloc_block_NF+0x451>
  802b3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b41:	8b 00                	mov    (%eax),%eax
  802b43:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b46:	8b 52 04             	mov    0x4(%edx),%edx
  802b49:	89 50 04             	mov    %edx,0x4(%eax)
  802b4c:	eb 0b                	jmp    802b59 <alloc_block_NF+0x45c>
  802b4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b51:	8b 40 04             	mov    0x4(%eax),%eax
  802b54:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5c:	8b 40 04             	mov    0x4(%eax),%eax
  802b5f:	85 c0                	test   %eax,%eax
  802b61:	74 0f                	je     802b72 <alloc_block_NF+0x475>
  802b63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b66:	8b 40 04             	mov    0x4(%eax),%eax
  802b69:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b6c:	8b 12                	mov    (%edx),%edx
  802b6e:	89 10                	mov    %edx,(%eax)
  802b70:	eb 0a                	jmp    802b7c <alloc_block_NF+0x47f>
  802b72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b75:	8b 00                	mov    (%eax),%eax
  802b77:	a3 38 51 80 00       	mov    %eax,0x805138
  802b7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b88:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b8f:	a1 44 51 80 00       	mov    0x805144,%eax
  802b94:	48                   	dec    %eax
  802b95:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802b9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9d:	8b 40 08             	mov    0x8(%eax),%eax
  802ba0:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802ba5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba8:	e9 1b 01 00 00       	jmp    802cc8 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802bad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb0:	8b 40 0c             	mov    0xc(%eax),%eax
  802bb3:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bb6:	0f 86 d1 00 00 00    	jbe    802c8d <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802bbc:	a1 48 51 80 00       	mov    0x805148,%eax
  802bc1:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802bc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc7:	8b 50 08             	mov    0x8(%eax),%edx
  802bca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bcd:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802bd0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bd3:	8b 55 08             	mov    0x8(%ebp),%edx
  802bd6:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802bd9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802bdd:	75 17                	jne    802bf6 <alloc_block_NF+0x4f9>
  802bdf:	83 ec 04             	sub    $0x4,%esp
  802be2:	68 30 40 80 00       	push   $0x804030
  802be7:	68 1c 01 00 00       	push   $0x11c
  802bec:	68 87 3f 80 00       	push   $0x803f87
  802bf1:	e8 9a d7 ff ff       	call   800390 <_panic>
  802bf6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bf9:	8b 00                	mov    (%eax),%eax
  802bfb:	85 c0                	test   %eax,%eax
  802bfd:	74 10                	je     802c0f <alloc_block_NF+0x512>
  802bff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c02:	8b 00                	mov    (%eax),%eax
  802c04:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c07:	8b 52 04             	mov    0x4(%edx),%edx
  802c0a:	89 50 04             	mov    %edx,0x4(%eax)
  802c0d:	eb 0b                	jmp    802c1a <alloc_block_NF+0x51d>
  802c0f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c12:	8b 40 04             	mov    0x4(%eax),%eax
  802c15:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c1a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c1d:	8b 40 04             	mov    0x4(%eax),%eax
  802c20:	85 c0                	test   %eax,%eax
  802c22:	74 0f                	je     802c33 <alloc_block_NF+0x536>
  802c24:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c27:	8b 40 04             	mov    0x4(%eax),%eax
  802c2a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c2d:	8b 12                	mov    (%edx),%edx
  802c2f:	89 10                	mov    %edx,(%eax)
  802c31:	eb 0a                	jmp    802c3d <alloc_block_NF+0x540>
  802c33:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c36:	8b 00                	mov    (%eax),%eax
  802c38:	a3 48 51 80 00       	mov    %eax,0x805148
  802c3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c40:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c46:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c49:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c50:	a1 54 51 80 00       	mov    0x805154,%eax
  802c55:	48                   	dec    %eax
  802c56:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802c5b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c5e:	8b 40 08             	mov    0x8(%eax),%eax
  802c61:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802c66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c69:	8b 50 08             	mov    0x8(%eax),%edx
  802c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6f:	01 c2                	add    %eax,%edx
  802c71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c74:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802c77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7a:	8b 40 0c             	mov    0xc(%eax),%eax
  802c7d:	2b 45 08             	sub    0x8(%ebp),%eax
  802c80:	89 c2                	mov    %eax,%edx
  802c82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c85:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802c88:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c8b:	eb 3b                	jmp    802cc8 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c8d:	a1 40 51 80 00       	mov    0x805140,%eax
  802c92:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c95:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c99:	74 07                	je     802ca2 <alloc_block_NF+0x5a5>
  802c9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9e:	8b 00                	mov    (%eax),%eax
  802ca0:	eb 05                	jmp    802ca7 <alloc_block_NF+0x5aa>
  802ca2:	b8 00 00 00 00       	mov    $0x0,%eax
  802ca7:	a3 40 51 80 00       	mov    %eax,0x805140
  802cac:	a1 40 51 80 00       	mov    0x805140,%eax
  802cb1:	85 c0                	test   %eax,%eax
  802cb3:	0f 85 2e fe ff ff    	jne    802ae7 <alloc_block_NF+0x3ea>
  802cb9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cbd:	0f 85 24 fe ff ff    	jne    802ae7 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802cc3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802cc8:	c9                   	leave  
  802cc9:	c3                   	ret    

00802cca <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802cca:	55                   	push   %ebp
  802ccb:	89 e5                	mov    %esp,%ebp
  802ccd:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802cd0:	a1 38 51 80 00       	mov    0x805138,%eax
  802cd5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802cd8:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802cdd:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802ce0:	a1 38 51 80 00       	mov    0x805138,%eax
  802ce5:	85 c0                	test   %eax,%eax
  802ce7:	74 14                	je     802cfd <insert_sorted_with_merge_freeList+0x33>
  802ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  802cec:	8b 50 08             	mov    0x8(%eax),%edx
  802cef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf2:	8b 40 08             	mov    0x8(%eax),%eax
  802cf5:	39 c2                	cmp    %eax,%edx
  802cf7:	0f 87 9b 01 00 00    	ja     802e98 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802cfd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d01:	75 17                	jne    802d1a <insert_sorted_with_merge_freeList+0x50>
  802d03:	83 ec 04             	sub    $0x4,%esp
  802d06:	68 64 3f 80 00       	push   $0x803f64
  802d0b:	68 38 01 00 00       	push   $0x138
  802d10:	68 87 3f 80 00       	push   $0x803f87
  802d15:	e8 76 d6 ff ff       	call   800390 <_panic>
  802d1a:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802d20:	8b 45 08             	mov    0x8(%ebp),%eax
  802d23:	89 10                	mov    %edx,(%eax)
  802d25:	8b 45 08             	mov    0x8(%ebp),%eax
  802d28:	8b 00                	mov    (%eax),%eax
  802d2a:	85 c0                	test   %eax,%eax
  802d2c:	74 0d                	je     802d3b <insert_sorted_with_merge_freeList+0x71>
  802d2e:	a1 38 51 80 00       	mov    0x805138,%eax
  802d33:	8b 55 08             	mov    0x8(%ebp),%edx
  802d36:	89 50 04             	mov    %edx,0x4(%eax)
  802d39:	eb 08                	jmp    802d43 <insert_sorted_with_merge_freeList+0x79>
  802d3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d43:	8b 45 08             	mov    0x8(%ebp),%eax
  802d46:	a3 38 51 80 00       	mov    %eax,0x805138
  802d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d55:	a1 44 51 80 00       	mov    0x805144,%eax
  802d5a:	40                   	inc    %eax
  802d5b:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802d60:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d64:	0f 84 a8 06 00 00    	je     803412 <insert_sorted_with_merge_freeList+0x748>
  802d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6d:	8b 50 08             	mov    0x8(%eax),%edx
  802d70:	8b 45 08             	mov    0x8(%ebp),%eax
  802d73:	8b 40 0c             	mov    0xc(%eax),%eax
  802d76:	01 c2                	add    %eax,%edx
  802d78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d7b:	8b 40 08             	mov    0x8(%eax),%eax
  802d7e:	39 c2                	cmp    %eax,%edx
  802d80:	0f 85 8c 06 00 00    	jne    803412 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802d86:	8b 45 08             	mov    0x8(%ebp),%eax
  802d89:	8b 50 0c             	mov    0xc(%eax),%edx
  802d8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d8f:	8b 40 0c             	mov    0xc(%eax),%eax
  802d92:	01 c2                	add    %eax,%edx
  802d94:	8b 45 08             	mov    0x8(%ebp),%eax
  802d97:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802d9a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d9e:	75 17                	jne    802db7 <insert_sorted_with_merge_freeList+0xed>
  802da0:	83 ec 04             	sub    $0x4,%esp
  802da3:	68 30 40 80 00       	push   $0x804030
  802da8:	68 3c 01 00 00       	push   $0x13c
  802dad:	68 87 3f 80 00       	push   $0x803f87
  802db2:	e8 d9 d5 ff ff       	call   800390 <_panic>
  802db7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dba:	8b 00                	mov    (%eax),%eax
  802dbc:	85 c0                	test   %eax,%eax
  802dbe:	74 10                	je     802dd0 <insert_sorted_with_merge_freeList+0x106>
  802dc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc3:	8b 00                	mov    (%eax),%eax
  802dc5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802dc8:	8b 52 04             	mov    0x4(%edx),%edx
  802dcb:	89 50 04             	mov    %edx,0x4(%eax)
  802dce:	eb 0b                	jmp    802ddb <insert_sorted_with_merge_freeList+0x111>
  802dd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dd3:	8b 40 04             	mov    0x4(%eax),%eax
  802dd6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ddb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dde:	8b 40 04             	mov    0x4(%eax),%eax
  802de1:	85 c0                	test   %eax,%eax
  802de3:	74 0f                	je     802df4 <insert_sorted_with_merge_freeList+0x12a>
  802de5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de8:	8b 40 04             	mov    0x4(%eax),%eax
  802deb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802dee:	8b 12                	mov    (%edx),%edx
  802df0:	89 10                	mov    %edx,(%eax)
  802df2:	eb 0a                	jmp    802dfe <insert_sorted_with_merge_freeList+0x134>
  802df4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df7:	8b 00                	mov    (%eax),%eax
  802df9:	a3 38 51 80 00       	mov    %eax,0x805138
  802dfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e01:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e0a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e11:	a1 44 51 80 00       	mov    0x805144,%eax
  802e16:	48                   	dec    %eax
  802e17:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802e1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e1f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802e26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e29:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802e30:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e34:	75 17                	jne    802e4d <insert_sorted_with_merge_freeList+0x183>
  802e36:	83 ec 04             	sub    $0x4,%esp
  802e39:	68 64 3f 80 00       	push   $0x803f64
  802e3e:	68 3f 01 00 00       	push   $0x13f
  802e43:	68 87 3f 80 00       	push   $0x803f87
  802e48:	e8 43 d5 ff ff       	call   800390 <_panic>
  802e4d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802e53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e56:	89 10                	mov    %edx,(%eax)
  802e58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e5b:	8b 00                	mov    (%eax),%eax
  802e5d:	85 c0                	test   %eax,%eax
  802e5f:	74 0d                	je     802e6e <insert_sorted_with_merge_freeList+0x1a4>
  802e61:	a1 48 51 80 00       	mov    0x805148,%eax
  802e66:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e69:	89 50 04             	mov    %edx,0x4(%eax)
  802e6c:	eb 08                	jmp    802e76 <insert_sorted_with_merge_freeList+0x1ac>
  802e6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e71:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e79:	a3 48 51 80 00       	mov    %eax,0x805148
  802e7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e81:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e88:	a1 54 51 80 00       	mov    0x805154,%eax
  802e8d:	40                   	inc    %eax
  802e8e:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802e93:	e9 7a 05 00 00       	jmp    803412 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802e98:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9b:	8b 50 08             	mov    0x8(%eax),%edx
  802e9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ea1:	8b 40 08             	mov    0x8(%eax),%eax
  802ea4:	39 c2                	cmp    %eax,%edx
  802ea6:	0f 82 14 01 00 00    	jb     802fc0 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802eac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eaf:	8b 50 08             	mov    0x8(%eax),%edx
  802eb2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eb5:	8b 40 0c             	mov    0xc(%eax),%eax
  802eb8:	01 c2                	add    %eax,%edx
  802eba:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebd:	8b 40 08             	mov    0x8(%eax),%eax
  802ec0:	39 c2                	cmp    %eax,%edx
  802ec2:	0f 85 90 00 00 00    	jne    802f58 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802ec8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ecb:	8b 50 0c             	mov    0xc(%eax),%edx
  802ece:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ed4:	01 c2                	add    %eax,%edx
  802ed6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ed9:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802edc:	8b 45 08             	mov    0x8(%ebp),%eax
  802edf:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802ee6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802ef0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ef4:	75 17                	jne    802f0d <insert_sorted_with_merge_freeList+0x243>
  802ef6:	83 ec 04             	sub    $0x4,%esp
  802ef9:	68 64 3f 80 00       	push   $0x803f64
  802efe:	68 49 01 00 00       	push   $0x149
  802f03:	68 87 3f 80 00       	push   $0x803f87
  802f08:	e8 83 d4 ff ff       	call   800390 <_panic>
  802f0d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f13:	8b 45 08             	mov    0x8(%ebp),%eax
  802f16:	89 10                	mov    %edx,(%eax)
  802f18:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1b:	8b 00                	mov    (%eax),%eax
  802f1d:	85 c0                	test   %eax,%eax
  802f1f:	74 0d                	je     802f2e <insert_sorted_with_merge_freeList+0x264>
  802f21:	a1 48 51 80 00       	mov    0x805148,%eax
  802f26:	8b 55 08             	mov    0x8(%ebp),%edx
  802f29:	89 50 04             	mov    %edx,0x4(%eax)
  802f2c:	eb 08                	jmp    802f36 <insert_sorted_with_merge_freeList+0x26c>
  802f2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f31:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f36:	8b 45 08             	mov    0x8(%ebp),%eax
  802f39:	a3 48 51 80 00       	mov    %eax,0x805148
  802f3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f41:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f48:	a1 54 51 80 00       	mov    0x805154,%eax
  802f4d:	40                   	inc    %eax
  802f4e:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802f53:	e9 bb 04 00 00       	jmp    803413 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802f58:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f5c:	75 17                	jne    802f75 <insert_sorted_with_merge_freeList+0x2ab>
  802f5e:	83 ec 04             	sub    $0x4,%esp
  802f61:	68 d8 3f 80 00       	push   $0x803fd8
  802f66:	68 4c 01 00 00       	push   $0x14c
  802f6b:	68 87 3f 80 00       	push   $0x803f87
  802f70:	e8 1b d4 ff ff       	call   800390 <_panic>
  802f75:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802f7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7e:	89 50 04             	mov    %edx,0x4(%eax)
  802f81:	8b 45 08             	mov    0x8(%ebp),%eax
  802f84:	8b 40 04             	mov    0x4(%eax),%eax
  802f87:	85 c0                	test   %eax,%eax
  802f89:	74 0c                	je     802f97 <insert_sorted_with_merge_freeList+0x2cd>
  802f8b:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f90:	8b 55 08             	mov    0x8(%ebp),%edx
  802f93:	89 10                	mov    %edx,(%eax)
  802f95:	eb 08                	jmp    802f9f <insert_sorted_with_merge_freeList+0x2d5>
  802f97:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9a:	a3 38 51 80 00       	mov    %eax,0x805138
  802f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  802faa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fb0:	a1 44 51 80 00       	mov    0x805144,%eax
  802fb5:	40                   	inc    %eax
  802fb6:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802fbb:	e9 53 04 00 00       	jmp    803413 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802fc0:	a1 38 51 80 00       	mov    0x805138,%eax
  802fc5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fc8:	e9 15 04 00 00       	jmp    8033e2 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802fcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd0:	8b 00                	mov    (%eax),%eax
  802fd2:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802fd5:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd8:	8b 50 08             	mov    0x8(%eax),%edx
  802fdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fde:	8b 40 08             	mov    0x8(%eax),%eax
  802fe1:	39 c2                	cmp    %eax,%edx
  802fe3:	0f 86 f1 03 00 00    	jbe    8033da <insert_sorted_with_merge_freeList+0x710>
  802fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fec:	8b 50 08             	mov    0x8(%eax),%edx
  802fef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ff2:	8b 40 08             	mov    0x8(%eax),%eax
  802ff5:	39 c2                	cmp    %eax,%edx
  802ff7:	0f 83 dd 03 00 00    	jae    8033da <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802ffd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803000:	8b 50 08             	mov    0x8(%eax),%edx
  803003:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803006:	8b 40 0c             	mov    0xc(%eax),%eax
  803009:	01 c2                	add    %eax,%edx
  80300b:	8b 45 08             	mov    0x8(%ebp),%eax
  80300e:	8b 40 08             	mov    0x8(%eax),%eax
  803011:	39 c2                	cmp    %eax,%edx
  803013:	0f 85 b9 01 00 00    	jne    8031d2 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803019:	8b 45 08             	mov    0x8(%ebp),%eax
  80301c:	8b 50 08             	mov    0x8(%eax),%edx
  80301f:	8b 45 08             	mov    0x8(%ebp),%eax
  803022:	8b 40 0c             	mov    0xc(%eax),%eax
  803025:	01 c2                	add    %eax,%edx
  803027:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80302a:	8b 40 08             	mov    0x8(%eax),%eax
  80302d:	39 c2                	cmp    %eax,%edx
  80302f:	0f 85 0d 01 00 00    	jne    803142 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803035:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803038:	8b 50 0c             	mov    0xc(%eax),%edx
  80303b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80303e:	8b 40 0c             	mov    0xc(%eax),%eax
  803041:	01 c2                	add    %eax,%edx
  803043:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803046:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803049:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80304d:	75 17                	jne    803066 <insert_sorted_with_merge_freeList+0x39c>
  80304f:	83 ec 04             	sub    $0x4,%esp
  803052:	68 30 40 80 00       	push   $0x804030
  803057:	68 5c 01 00 00       	push   $0x15c
  80305c:	68 87 3f 80 00       	push   $0x803f87
  803061:	e8 2a d3 ff ff       	call   800390 <_panic>
  803066:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803069:	8b 00                	mov    (%eax),%eax
  80306b:	85 c0                	test   %eax,%eax
  80306d:	74 10                	je     80307f <insert_sorted_with_merge_freeList+0x3b5>
  80306f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803072:	8b 00                	mov    (%eax),%eax
  803074:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803077:	8b 52 04             	mov    0x4(%edx),%edx
  80307a:	89 50 04             	mov    %edx,0x4(%eax)
  80307d:	eb 0b                	jmp    80308a <insert_sorted_with_merge_freeList+0x3c0>
  80307f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803082:	8b 40 04             	mov    0x4(%eax),%eax
  803085:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80308a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80308d:	8b 40 04             	mov    0x4(%eax),%eax
  803090:	85 c0                	test   %eax,%eax
  803092:	74 0f                	je     8030a3 <insert_sorted_with_merge_freeList+0x3d9>
  803094:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803097:	8b 40 04             	mov    0x4(%eax),%eax
  80309a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80309d:	8b 12                	mov    (%edx),%edx
  80309f:	89 10                	mov    %edx,(%eax)
  8030a1:	eb 0a                	jmp    8030ad <insert_sorted_with_merge_freeList+0x3e3>
  8030a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030a6:	8b 00                	mov    (%eax),%eax
  8030a8:	a3 38 51 80 00       	mov    %eax,0x805138
  8030ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030b9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030c0:	a1 44 51 80 00       	mov    0x805144,%eax
  8030c5:	48                   	dec    %eax
  8030c6:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8030cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ce:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8030d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030d8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8030df:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030e3:	75 17                	jne    8030fc <insert_sorted_with_merge_freeList+0x432>
  8030e5:	83 ec 04             	sub    $0x4,%esp
  8030e8:	68 64 3f 80 00       	push   $0x803f64
  8030ed:	68 5f 01 00 00       	push   $0x15f
  8030f2:	68 87 3f 80 00       	push   $0x803f87
  8030f7:	e8 94 d2 ff ff       	call   800390 <_panic>
  8030fc:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803102:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803105:	89 10                	mov    %edx,(%eax)
  803107:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80310a:	8b 00                	mov    (%eax),%eax
  80310c:	85 c0                	test   %eax,%eax
  80310e:	74 0d                	je     80311d <insert_sorted_with_merge_freeList+0x453>
  803110:	a1 48 51 80 00       	mov    0x805148,%eax
  803115:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803118:	89 50 04             	mov    %edx,0x4(%eax)
  80311b:	eb 08                	jmp    803125 <insert_sorted_with_merge_freeList+0x45b>
  80311d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803120:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803125:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803128:	a3 48 51 80 00       	mov    %eax,0x805148
  80312d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803130:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803137:	a1 54 51 80 00       	mov    0x805154,%eax
  80313c:	40                   	inc    %eax
  80313d:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803142:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803145:	8b 50 0c             	mov    0xc(%eax),%edx
  803148:	8b 45 08             	mov    0x8(%ebp),%eax
  80314b:	8b 40 0c             	mov    0xc(%eax),%eax
  80314e:	01 c2                	add    %eax,%edx
  803150:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803153:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803156:	8b 45 08             	mov    0x8(%ebp),%eax
  803159:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803160:	8b 45 08             	mov    0x8(%ebp),%eax
  803163:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80316a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80316e:	75 17                	jne    803187 <insert_sorted_with_merge_freeList+0x4bd>
  803170:	83 ec 04             	sub    $0x4,%esp
  803173:	68 64 3f 80 00       	push   $0x803f64
  803178:	68 64 01 00 00       	push   $0x164
  80317d:	68 87 3f 80 00       	push   $0x803f87
  803182:	e8 09 d2 ff ff       	call   800390 <_panic>
  803187:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80318d:	8b 45 08             	mov    0x8(%ebp),%eax
  803190:	89 10                	mov    %edx,(%eax)
  803192:	8b 45 08             	mov    0x8(%ebp),%eax
  803195:	8b 00                	mov    (%eax),%eax
  803197:	85 c0                	test   %eax,%eax
  803199:	74 0d                	je     8031a8 <insert_sorted_with_merge_freeList+0x4de>
  80319b:	a1 48 51 80 00       	mov    0x805148,%eax
  8031a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8031a3:	89 50 04             	mov    %edx,0x4(%eax)
  8031a6:	eb 08                	jmp    8031b0 <insert_sorted_with_merge_freeList+0x4e6>
  8031a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ab:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b3:	a3 48 51 80 00       	mov    %eax,0x805148
  8031b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031bb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031c2:	a1 54 51 80 00       	mov    0x805154,%eax
  8031c7:	40                   	inc    %eax
  8031c8:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8031cd:	e9 41 02 00 00       	jmp    803413 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8031d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d5:	8b 50 08             	mov    0x8(%eax),%edx
  8031d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031db:	8b 40 0c             	mov    0xc(%eax),%eax
  8031de:	01 c2                	add    %eax,%edx
  8031e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e3:	8b 40 08             	mov    0x8(%eax),%eax
  8031e6:	39 c2                	cmp    %eax,%edx
  8031e8:	0f 85 7c 01 00 00    	jne    80336a <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8031ee:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031f2:	74 06                	je     8031fa <insert_sorted_with_merge_freeList+0x530>
  8031f4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031f8:	75 17                	jne    803211 <insert_sorted_with_merge_freeList+0x547>
  8031fa:	83 ec 04             	sub    $0x4,%esp
  8031fd:	68 a0 3f 80 00       	push   $0x803fa0
  803202:	68 69 01 00 00       	push   $0x169
  803207:	68 87 3f 80 00       	push   $0x803f87
  80320c:	e8 7f d1 ff ff       	call   800390 <_panic>
  803211:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803214:	8b 50 04             	mov    0x4(%eax),%edx
  803217:	8b 45 08             	mov    0x8(%ebp),%eax
  80321a:	89 50 04             	mov    %edx,0x4(%eax)
  80321d:	8b 45 08             	mov    0x8(%ebp),%eax
  803220:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803223:	89 10                	mov    %edx,(%eax)
  803225:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803228:	8b 40 04             	mov    0x4(%eax),%eax
  80322b:	85 c0                	test   %eax,%eax
  80322d:	74 0d                	je     80323c <insert_sorted_with_merge_freeList+0x572>
  80322f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803232:	8b 40 04             	mov    0x4(%eax),%eax
  803235:	8b 55 08             	mov    0x8(%ebp),%edx
  803238:	89 10                	mov    %edx,(%eax)
  80323a:	eb 08                	jmp    803244 <insert_sorted_with_merge_freeList+0x57a>
  80323c:	8b 45 08             	mov    0x8(%ebp),%eax
  80323f:	a3 38 51 80 00       	mov    %eax,0x805138
  803244:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803247:	8b 55 08             	mov    0x8(%ebp),%edx
  80324a:	89 50 04             	mov    %edx,0x4(%eax)
  80324d:	a1 44 51 80 00       	mov    0x805144,%eax
  803252:	40                   	inc    %eax
  803253:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803258:	8b 45 08             	mov    0x8(%ebp),%eax
  80325b:	8b 50 0c             	mov    0xc(%eax),%edx
  80325e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803261:	8b 40 0c             	mov    0xc(%eax),%eax
  803264:	01 c2                	add    %eax,%edx
  803266:	8b 45 08             	mov    0x8(%ebp),%eax
  803269:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80326c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803270:	75 17                	jne    803289 <insert_sorted_with_merge_freeList+0x5bf>
  803272:	83 ec 04             	sub    $0x4,%esp
  803275:	68 30 40 80 00       	push   $0x804030
  80327a:	68 6b 01 00 00       	push   $0x16b
  80327f:	68 87 3f 80 00       	push   $0x803f87
  803284:	e8 07 d1 ff ff       	call   800390 <_panic>
  803289:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80328c:	8b 00                	mov    (%eax),%eax
  80328e:	85 c0                	test   %eax,%eax
  803290:	74 10                	je     8032a2 <insert_sorted_with_merge_freeList+0x5d8>
  803292:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803295:	8b 00                	mov    (%eax),%eax
  803297:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80329a:	8b 52 04             	mov    0x4(%edx),%edx
  80329d:	89 50 04             	mov    %edx,0x4(%eax)
  8032a0:	eb 0b                	jmp    8032ad <insert_sorted_with_merge_freeList+0x5e3>
  8032a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032a5:	8b 40 04             	mov    0x4(%eax),%eax
  8032a8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032b0:	8b 40 04             	mov    0x4(%eax),%eax
  8032b3:	85 c0                	test   %eax,%eax
  8032b5:	74 0f                	je     8032c6 <insert_sorted_with_merge_freeList+0x5fc>
  8032b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ba:	8b 40 04             	mov    0x4(%eax),%eax
  8032bd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032c0:	8b 12                	mov    (%edx),%edx
  8032c2:	89 10                	mov    %edx,(%eax)
  8032c4:	eb 0a                	jmp    8032d0 <insert_sorted_with_merge_freeList+0x606>
  8032c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032c9:	8b 00                	mov    (%eax),%eax
  8032cb:	a3 38 51 80 00       	mov    %eax,0x805138
  8032d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032dc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032e3:	a1 44 51 80 00       	mov    0x805144,%eax
  8032e8:	48                   	dec    %eax
  8032e9:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8032ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032f1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8032f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032fb:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803302:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803306:	75 17                	jne    80331f <insert_sorted_with_merge_freeList+0x655>
  803308:	83 ec 04             	sub    $0x4,%esp
  80330b:	68 64 3f 80 00       	push   $0x803f64
  803310:	68 6e 01 00 00       	push   $0x16e
  803315:	68 87 3f 80 00       	push   $0x803f87
  80331a:	e8 71 d0 ff ff       	call   800390 <_panic>
  80331f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803325:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803328:	89 10                	mov    %edx,(%eax)
  80332a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80332d:	8b 00                	mov    (%eax),%eax
  80332f:	85 c0                	test   %eax,%eax
  803331:	74 0d                	je     803340 <insert_sorted_with_merge_freeList+0x676>
  803333:	a1 48 51 80 00       	mov    0x805148,%eax
  803338:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80333b:	89 50 04             	mov    %edx,0x4(%eax)
  80333e:	eb 08                	jmp    803348 <insert_sorted_with_merge_freeList+0x67e>
  803340:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803343:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803348:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80334b:	a3 48 51 80 00       	mov    %eax,0x805148
  803350:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803353:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80335a:	a1 54 51 80 00       	mov    0x805154,%eax
  80335f:	40                   	inc    %eax
  803360:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803365:	e9 a9 00 00 00       	jmp    803413 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  80336a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80336e:	74 06                	je     803376 <insert_sorted_with_merge_freeList+0x6ac>
  803370:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803374:	75 17                	jne    80338d <insert_sorted_with_merge_freeList+0x6c3>
  803376:	83 ec 04             	sub    $0x4,%esp
  803379:	68 fc 3f 80 00       	push   $0x803ffc
  80337e:	68 73 01 00 00       	push   $0x173
  803383:	68 87 3f 80 00       	push   $0x803f87
  803388:	e8 03 d0 ff ff       	call   800390 <_panic>
  80338d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803390:	8b 10                	mov    (%eax),%edx
  803392:	8b 45 08             	mov    0x8(%ebp),%eax
  803395:	89 10                	mov    %edx,(%eax)
  803397:	8b 45 08             	mov    0x8(%ebp),%eax
  80339a:	8b 00                	mov    (%eax),%eax
  80339c:	85 c0                	test   %eax,%eax
  80339e:	74 0b                	je     8033ab <insert_sorted_with_merge_freeList+0x6e1>
  8033a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a3:	8b 00                	mov    (%eax),%eax
  8033a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8033a8:	89 50 04             	mov    %edx,0x4(%eax)
  8033ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8033b1:	89 10                	mov    %edx,(%eax)
  8033b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033b9:	89 50 04             	mov    %edx,0x4(%eax)
  8033bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8033bf:	8b 00                	mov    (%eax),%eax
  8033c1:	85 c0                	test   %eax,%eax
  8033c3:	75 08                	jne    8033cd <insert_sorted_with_merge_freeList+0x703>
  8033c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033cd:	a1 44 51 80 00       	mov    0x805144,%eax
  8033d2:	40                   	inc    %eax
  8033d3:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  8033d8:	eb 39                	jmp    803413 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8033da:	a1 40 51 80 00       	mov    0x805140,%eax
  8033df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033e6:	74 07                	je     8033ef <insert_sorted_with_merge_freeList+0x725>
  8033e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033eb:	8b 00                	mov    (%eax),%eax
  8033ed:	eb 05                	jmp    8033f4 <insert_sorted_with_merge_freeList+0x72a>
  8033ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8033f4:	a3 40 51 80 00       	mov    %eax,0x805140
  8033f9:	a1 40 51 80 00       	mov    0x805140,%eax
  8033fe:	85 c0                	test   %eax,%eax
  803400:	0f 85 c7 fb ff ff    	jne    802fcd <insert_sorted_with_merge_freeList+0x303>
  803406:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80340a:	0f 85 bd fb ff ff    	jne    802fcd <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803410:	eb 01                	jmp    803413 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803412:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803413:	90                   	nop
  803414:	c9                   	leave  
  803415:	c3                   	ret    
  803416:	66 90                	xchg   %ax,%ax

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
