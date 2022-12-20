
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
  80008d:	68 20 38 80 00       	push   $0x803820
  800092:	6a 13                	push   $0x13
  800094:	68 3c 38 80 00       	push   $0x80383c
  800099:	e8 f2 02 00 00       	call   800390 <_panic>
	}
	uint32 *x,*y,*z;
	int32 parentenvID = sys_getparentenvid();
  80009e:	e8 3f 1c 00 00       	call   801ce2 <sys_getparentenvid>
  8000a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//GET: z then y then x, opposite to creation order (x then y then z)
	//So, addresses here will be different from the OWNER addresses
	sys_disable_interrupt();
  8000a6:	e8 2b 1a 00 00       	call   801ad6 <sys_disable_interrupt>
	int freeFrames = sys_calculate_free_frames() ;
  8000ab:	e8 39 19 00 00       	call   8019e9 <sys_calculate_free_frames>
  8000b0:	89 45 e8             	mov    %eax,-0x18(%ebp)
	z = sget(parentenvID,"z");
  8000b3:	83 ec 08             	sub    $0x8,%esp
  8000b6:	68 5a 38 80 00       	push   $0x80385a
  8000bb:	ff 75 ec             	pushl  -0x14(%ebp)
  8000be:	e8 02 17 00 00       	call   8017c5 <sget>
  8000c3:	83 c4 10             	add    $0x10,%esp
  8000c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (z != (uint32*)(USER_HEAP_START + 0 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8000c9:	81 7d e4 00 00 00 80 	cmpl   $0x80000000,-0x1c(%ebp)
  8000d0:	74 14                	je     8000e6 <_main+0xae>
  8000d2:	83 ec 04             	sub    $0x4,%esp
  8000d5:	68 5c 38 80 00       	push   $0x80385c
  8000da:	6a 1c                	push   $0x1c
  8000dc:	68 3c 38 80 00       	push   $0x80383c
  8000e1:	e8 aa 02 00 00       	call   800390 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  8000e6:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000e9:	e8 fb 18 00 00       	call   8019e9 <sys_calculate_free_frames>
  8000ee:	29 c3                	sub    %eax,%ebx
  8000f0:	89 d8                	mov    %ebx,%eax
  8000f2:	83 f8 01             	cmp    $0x1,%eax
  8000f5:	74 14                	je     80010b <_main+0xd3>
  8000f7:	83 ec 04             	sub    $0x4,%esp
  8000fa:	68 bc 38 80 00       	push   $0x8038bc
  8000ff:	6a 1d                	push   $0x1d
  800101:	68 3c 38 80 00       	push   $0x80383c
  800106:	e8 85 02 00 00       	call   800390 <_panic>
	sys_enable_interrupt();
  80010b:	e8 e0 19 00 00       	call   801af0 <sys_enable_interrupt>

	sys_disable_interrupt();
  800110:	e8 c1 19 00 00       	call   801ad6 <sys_disable_interrupt>
	freeFrames = sys_calculate_free_frames() ;
  800115:	e8 cf 18 00 00       	call   8019e9 <sys_calculate_free_frames>
  80011a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	y = sget(parentenvID,"y");
  80011d:	83 ec 08             	sub    $0x8,%esp
  800120:	68 4d 39 80 00       	push   $0x80394d
  800125:	ff 75 ec             	pushl  -0x14(%ebp)
  800128:	e8 98 16 00 00       	call   8017c5 <sget>
  80012d:	83 c4 10             	add    $0x10,%esp
  800130:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (y != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  800133:	81 7d e0 00 10 00 80 	cmpl   $0x80001000,-0x20(%ebp)
  80013a:	74 14                	je     800150 <_main+0x118>
  80013c:	83 ec 04             	sub    $0x4,%esp
  80013f:	68 5c 38 80 00       	push   $0x80385c
  800144:	6a 23                	push   $0x23
  800146:	68 3c 38 80 00       	push   $0x80383c
  80014b:	e8 40 02 00 00       	call   800390 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  800150:	e8 94 18 00 00       	call   8019e9 <sys_calculate_free_frames>
  800155:	89 c2                	mov    %eax,%edx
  800157:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80015a:	39 c2                	cmp    %eax,%edx
  80015c:	74 14                	je     800172 <_main+0x13a>
  80015e:	83 ec 04             	sub    $0x4,%esp
  800161:	68 bc 38 80 00       	push   $0x8038bc
  800166:	6a 24                	push   $0x24
  800168:	68 3c 38 80 00       	push   $0x80383c
  80016d:	e8 1e 02 00 00       	call   800390 <_panic>
	sys_enable_interrupt();
  800172:	e8 79 19 00 00       	call   801af0 <sys_enable_interrupt>
	
	if (*y != 20) panic("Get(): Shared Variable is not created or got correctly") ;
  800177:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80017a:	8b 00                	mov    (%eax),%eax
  80017c:	83 f8 14             	cmp    $0x14,%eax
  80017f:	74 14                	je     800195 <_main+0x15d>
  800181:	83 ec 04             	sub    $0x4,%esp
  800184:	68 50 39 80 00       	push   $0x803950
  800189:	6a 27                	push   $0x27
  80018b:	68 3c 38 80 00       	push   $0x80383c
  800190:	e8 fb 01 00 00       	call   800390 <_panic>

	sys_disable_interrupt();
  800195:	e8 3c 19 00 00       	call   801ad6 <sys_disable_interrupt>
	freeFrames = sys_calculate_free_frames() ;
  80019a:	e8 4a 18 00 00       	call   8019e9 <sys_calculate_free_frames>
  80019f:	89 45 e8             	mov    %eax,-0x18(%ebp)
	x = sget(parentenvID,"x");
  8001a2:	83 ec 08             	sub    $0x8,%esp
  8001a5:	68 87 39 80 00       	push   $0x803987
  8001aa:	ff 75 ec             	pushl  -0x14(%ebp)
  8001ad:	e8 13 16 00 00       	call   8017c5 <sget>
  8001b2:	83 c4 10             	add    $0x10,%esp
  8001b5:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (x != (uint32*)(USER_HEAP_START + 2 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8001b8:	81 7d dc 00 20 00 80 	cmpl   $0x80002000,-0x24(%ebp)
  8001bf:	74 14                	je     8001d5 <_main+0x19d>
  8001c1:	83 ec 04             	sub    $0x4,%esp
  8001c4:	68 5c 38 80 00       	push   $0x80385c
  8001c9:	6a 2c                	push   $0x2c
  8001cb:	68 3c 38 80 00       	push   $0x80383c
  8001d0:	e8 bb 01 00 00       	call   800390 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  8001d5:	e8 0f 18 00 00       	call   8019e9 <sys_calculate_free_frames>
  8001da:	89 c2                	mov    %eax,%edx
  8001dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001df:	39 c2                	cmp    %eax,%edx
  8001e1:	74 14                	je     8001f7 <_main+0x1bf>
  8001e3:	83 ec 04             	sub    $0x4,%esp
  8001e6:	68 bc 38 80 00       	push   $0x8038bc
  8001eb:	6a 2d                	push   $0x2d
  8001ed:	68 3c 38 80 00       	push   $0x80383c
  8001f2:	e8 99 01 00 00       	call   800390 <_panic>
	sys_enable_interrupt();
  8001f7:	e8 f4 18 00 00       	call   801af0 <sys_enable_interrupt>

	if (*x != 10) panic("Get(): Shared Variable is not created or got correctly") ;
  8001fc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001ff:	8b 00                	mov    (%eax),%eax
  800201:	83 f8 0a             	cmp    $0xa,%eax
  800204:	74 14                	je     80021a <_main+0x1e2>
  800206:	83 ec 04             	sub    $0x4,%esp
  800209:	68 50 39 80 00       	push   $0x803950
  80020e:	6a 30                	push   $0x30
  800210:	68 3c 38 80 00       	push   $0x80383c
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
  800238:	68 50 39 80 00       	push   $0x803950
  80023d:	6a 33                	push   $0x33
  80023f:	68 3c 38 80 00       	push   $0x80383c
  800244:	e8 47 01 00 00       	call   800390 <_panic>

	//To indicate that it's completed successfully
	inctst();
  800249:	e8 b9 1b 00 00       	call   801e07 <inctst>

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
  80025a:	e8 6a 1a 00 00       	call   801cc9 <sys_getenvindex>
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
  8002c5:	e8 0c 18 00 00       	call   801ad6 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8002ca:	83 ec 0c             	sub    $0xc,%esp
  8002cd:	68 a4 39 80 00       	push   $0x8039a4
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
  8002f5:	68 cc 39 80 00       	push   $0x8039cc
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
  800326:	68 f4 39 80 00       	push   $0x8039f4
  80032b:	e8 14 03 00 00       	call   800644 <cprintf>
  800330:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800333:	a1 20 50 80 00       	mov    0x805020,%eax
  800338:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80033e:	83 ec 08             	sub    $0x8,%esp
  800341:	50                   	push   %eax
  800342:	68 4c 3a 80 00       	push   $0x803a4c
  800347:	e8 f8 02 00 00       	call   800644 <cprintf>
  80034c:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80034f:	83 ec 0c             	sub    $0xc,%esp
  800352:	68 a4 39 80 00       	push   $0x8039a4
  800357:	e8 e8 02 00 00       	call   800644 <cprintf>
  80035c:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80035f:	e8 8c 17 00 00       	call   801af0 <sys_enable_interrupt>

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
  800377:	e8 19 19 00 00       	call   801c95 <sys_destroy_env>
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
  800388:	e8 6e 19 00 00       	call   801cfb <sys_exit_env>
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
  8003b1:	68 60 3a 80 00       	push   $0x803a60
  8003b6:	e8 89 02 00 00       	call   800644 <cprintf>
  8003bb:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8003be:	a1 00 50 80 00       	mov    0x805000,%eax
  8003c3:	ff 75 0c             	pushl  0xc(%ebp)
  8003c6:	ff 75 08             	pushl  0x8(%ebp)
  8003c9:	50                   	push   %eax
  8003ca:	68 65 3a 80 00       	push   $0x803a65
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
  8003ee:	68 81 3a 80 00       	push   $0x803a81
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
  80041a:	68 84 3a 80 00       	push   $0x803a84
  80041f:	6a 26                	push   $0x26
  800421:	68 d0 3a 80 00       	push   $0x803ad0
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
  8004ec:	68 dc 3a 80 00       	push   $0x803adc
  8004f1:	6a 3a                	push   $0x3a
  8004f3:	68 d0 3a 80 00       	push   $0x803ad0
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
  80055c:	68 30 3b 80 00       	push   $0x803b30
  800561:	6a 44                	push   $0x44
  800563:	68 d0 3a 80 00       	push   $0x803ad0
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
  8005b6:	e8 6d 13 00 00       	call   801928 <sys_cputs>
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
  80062d:	e8 f6 12 00 00       	call   801928 <sys_cputs>
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
  800677:	e8 5a 14 00 00       	call   801ad6 <sys_disable_interrupt>
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
  800697:	e8 54 14 00 00       	call   801af0 <sys_enable_interrupt>
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
  8006e1:	e8 c6 2e 00 00       	call   8035ac <__udivdi3>
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
  800731:	e8 86 2f 00 00       	call   8036bc <__umoddi3>
  800736:	83 c4 10             	add    $0x10,%esp
  800739:	05 94 3d 80 00       	add    $0x803d94,%eax
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
  80088c:	8b 04 85 b8 3d 80 00 	mov    0x803db8(,%eax,4),%eax
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
  80096d:	8b 34 9d 00 3c 80 00 	mov    0x803c00(,%ebx,4),%esi
  800974:	85 f6                	test   %esi,%esi
  800976:	75 19                	jne    800991 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800978:	53                   	push   %ebx
  800979:	68 a5 3d 80 00       	push   $0x803da5
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
  800992:	68 ae 3d 80 00       	push   $0x803dae
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
  8009bf:	be b1 3d 80 00       	mov    $0x803db1,%esi
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
  8013e5:	68 10 3f 80 00       	push   $0x803f10
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
  8014b5:	e8 b2 05 00 00       	call   801a6c <sys_allocate_chunk>
  8014ba:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8014bd:	a1 20 51 80 00       	mov    0x805120,%eax
  8014c2:	83 ec 0c             	sub    $0xc,%esp
  8014c5:	50                   	push   %eax
  8014c6:	e8 27 0c 00 00       	call   8020f2 <initialize_MemBlocksList>
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
  8014f3:	68 35 3f 80 00       	push   $0x803f35
  8014f8:	6a 33                	push   $0x33
  8014fa:	68 53 3f 80 00       	push   $0x803f53
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
  801572:	68 60 3f 80 00       	push   $0x803f60
  801577:	6a 34                	push   $0x34
  801579:	68 53 3f 80 00       	push   $0x803f53
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
  80160a:	e8 2b 08 00 00       	call   801e3a <sys_isUHeapPlacementStrategyFIRSTFIT>
  80160f:	85 c0                	test   %eax,%eax
  801611:	74 11                	je     801624 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801613:	83 ec 0c             	sub    $0xc,%esp
  801616:	ff 75 e8             	pushl  -0x18(%ebp)
  801619:	e8 96 0e 00 00       	call   8024b4 <alloc_block_FF>
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
  801630:	e8 f2 0b 00 00       	call   802227 <insert_sorted_allocList>
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
  80164a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	struct MemBlock * free_block=find_block(&AllocMemBlocksList,(uint32)virtual_address);
  80164d:	8b 45 08             	mov    0x8(%ebp),%eax
  801650:	83 ec 08             	sub    $0x8,%esp
  801653:	50                   	push   %eax
  801654:	68 40 50 80 00       	push   $0x805040
  801659:	e8 71 0b 00 00       	call   8021cf <find_block>
  80165e:	83 c4 10             	add    $0x10,%esp
  801661:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(free_block!=NULL)
  801664:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801668:	0f 84 a6 00 00 00    	je     801714 <free+0xcd>
	{
		sys_free_user_mem(free_block->sva,free_block->size);
  80166e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801671:	8b 50 0c             	mov    0xc(%eax),%edx
  801674:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801677:	8b 40 08             	mov    0x8(%eax),%eax
  80167a:	83 ec 08             	sub    $0x8,%esp
  80167d:	52                   	push   %edx
  80167e:	50                   	push   %eax
  80167f:	e8 b0 03 00 00       	call   801a34 <sys_free_user_mem>
  801684:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,free_block);
  801687:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80168b:	75 14                	jne    8016a1 <free+0x5a>
  80168d:	83 ec 04             	sub    $0x4,%esp
  801690:	68 35 3f 80 00       	push   $0x803f35
  801695:	6a 74                	push   $0x74
  801697:	68 53 3f 80 00       	push   $0x803f53
  80169c:	e8 ef ec ff ff       	call   800390 <_panic>
  8016a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016a4:	8b 00                	mov    (%eax),%eax
  8016a6:	85 c0                	test   %eax,%eax
  8016a8:	74 10                	je     8016ba <free+0x73>
  8016aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016ad:	8b 00                	mov    (%eax),%eax
  8016af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016b2:	8b 52 04             	mov    0x4(%edx),%edx
  8016b5:	89 50 04             	mov    %edx,0x4(%eax)
  8016b8:	eb 0b                	jmp    8016c5 <free+0x7e>
  8016ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016bd:	8b 40 04             	mov    0x4(%eax),%eax
  8016c0:	a3 44 50 80 00       	mov    %eax,0x805044
  8016c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016c8:	8b 40 04             	mov    0x4(%eax),%eax
  8016cb:	85 c0                	test   %eax,%eax
  8016cd:	74 0f                	je     8016de <free+0x97>
  8016cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016d2:	8b 40 04             	mov    0x4(%eax),%eax
  8016d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016d8:	8b 12                	mov    (%edx),%edx
  8016da:	89 10                	mov    %edx,(%eax)
  8016dc:	eb 0a                	jmp    8016e8 <free+0xa1>
  8016de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016e1:	8b 00                	mov    (%eax),%eax
  8016e3:	a3 40 50 80 00       	mov    %eax,0x805040
  8016e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016eb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8016f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016f4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8016fb:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801700:	48                   	dec    %eax
  801701:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(free_block);
  801706:	83 ec 0c             	sub    $0xc,%esp
  801709:	ff 75 f4             	pushl  -0xc(%ebp)
  80170c:	e8 4e 17 00 00       	call   802e5f <insert_sorted_with_merge_freeList>
  801711:	83 c4 10             	add    $0x10,%esp
	}

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801714:	90                   	nop
  801715:	c9                   	leave  
  801716:	c3                   	ret    

00801717 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801717:	55                   	push   %ebp
  801718:	89 e5                	mov    %esp,%ebp
  80171a:	83 ec 38             	sub    $0x38,%esp
  80171d:	8b 45 10             	mov    0x10(%ebp),%eax
  801720:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801723:	e8 a6 fc ff ff       	call   8013ce <InitializeUHeap>
	if (size == 0) return NULL ;
  801728:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80172c:	75 0a                	jne    801738 <smalloc+0x21>
  80172e:	b8 00 00 00 00       	mov    $0x0,%eax
  801733:	e9 8b 00 00 00       	jmp    8017c3 <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801738:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80173f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801742:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801745:	01 d0                	add    %edx,%eax
  801747:	48                   	dec    %eax
  801748:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80174b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80174e:	ba 00 00 00 00       	mov    $0x0,%edx
  801753:	f7 75 f0             	divl   -0x10(%ebp)
  801756:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801759:	29 d0                	sub    %edx,%eax
  80175b:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  80175e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801765:	e8 d0 06 00 00       	call   801e3a <sys_isUHeapPlacementStrategyFIRSTFIT>
  80176a:	85 c0                	test   %eax,%eax
  80176c:	74 11                	je     80177f <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  80176e:	83 ec 0c             	sub    $0xc,%esp
  801771:	ff 75 e8             	pushl  -0x18(%ebp)
  801774:	e8 3b 0d 00 00       	call   8024b4 <alloc_block_FF>
  801779:	83 c4 10             	add    $0x10,%esp
  80177c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  80177f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801783:	74 39                	je     8017be <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801785:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801788:	8b 40 08             	mov    0x8(%eax),%eax
  80178b:	89 c2                	mov    %eax,%edx
  80178d:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801791:	52                   	push   %edx
  801792:	50                   	push   %eax
  801793:	ff 75 0c             	pushl  0xc(%ebp)
  801796:	ff 75 08             	pushl  0x8(%ebp)
  801799:	e8 21 04 00 00       	call   801bbf <sys_createSharedObject>
  80179e:	83 c4 10             	add    $0x10,%esp
  8017a1:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  8017a4:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  8017a8:	74 14                	je     8017be <smalloc+0xa7>
  8017aa:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  8017ae:	74 0e                	je     8017be <smalloc+0xa7>
  8017b0:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  8017b4:	74 08                	je     8017be <smalloc+0xa7>
			return (void*) mem_block->sva;
  8017b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017b9:	8b 40 08             	mov    0x8(%eax),%eax
  8017bc:	eb 05                	jmp    8017c3 <smalloc+0xac>
	}
	return NULL;
  8017be:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8017c3:	c9                   	leave  
  8017c4:	c3                   	ret    

008017c5 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8017c5:	55                   	push   %ebp
  8017c6:	89 e5                	mov    %esp,%ebp
  8017c8:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017cb:	e8 fe fb ff ff       	call   8013ce <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8017d0:	83 ec 08             	sub    $0x8,%esp
  8017d3:	ff 75 0c             	pushl  0xc(%ebp)
  8017d6:	ff 75 08             	pushl  0x8(%ebp)
  8017d9:	e8 0b 04 00 00       	call   801be9 <sys_getSizeOfSharedObject>
  8017de:	83 c4 10             	add    $0x10,%esp
  8017e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  8017e4:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  8017e8:	74 76                	je     801860 <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  8017ea:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8017f1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017f7:	01 d0                	add    %edx,%eax
  8017f9:	48                   	dec    %eax
  8017fa:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8017fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801800:	ba 00 00 00 00       	mov    $0x0,%edx
  801805:	f7 75 ec             	divl   -0x14(%ebp)
  801808:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80180b:	29 d0                	sub    %edx,%eax
  80180d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  801810:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801817:	e8 1e 06 00 00       	call   801e3a <sys_isUHeapPlacementStrategyFIRSTFIT>
  80181c:	85 c0                	test   %eax,%eax
  80181e:	74 11                	je     801831 <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  801820:	83 ec 0c             	sub    $0xc,%esp
  801823:	ff 75 e4             	pushl  -0x1c(%ebp)
  801826:	e8 89 0c 00 00       	call   8024b4 <alloc_block_FF>
  80182b:	83 c4 10             	add    $0x10,%esp
  80182e:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  801831:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801835:	74 29                	je     801860 <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  801837:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80183a:	8b 40 08             	mov    0x8(%eax),%eax
  80183d:	83 ec 04             	sub    $0x4,%esp
  801840:	50                   	push   %eax
  801841:	ff 75 0c             	pushl  0xc(%ebp)
  801844:	ff 75 08             	pushl  0x8(%ebp)
  801847:	e8 ba 03 00 00       	call   801c06 <sys_getSharedObject>
  80184c:	83 c4 10             	add    $0x10,%esp
  80184f:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  801852:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  801856:	74 08                	je     801860 <sget+0x9b>
				return (void *)mem_block->sva;
  801858:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80185b:	8b 40 08             	mov    0x8(%eax),%eax
  80185e:	eb 05                	jmp    801865 <sget+0xa0>
		}
	}
	return NULL;
  801860:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801865:	c9                   	leave  
  801866:	c3                   	ret    

00801867 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801867:	55                   	push   %ebp
  801868:	89 e5                	mov    %esp,%ebp
  80186a:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80186d:	e8 5c fb ff ff       	call   8013ce <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801872:	83 ec 04             	sub    $0x4,%esp
  801875:	68 84 3f 80 00       	push   $0x803f84
  80187a:	68 f7 00 00 00       	push   $0xf7
  80187f:	68 53 3f 80 00       	push   $0x803f53
  801884:	e8 07 eb ff ff       	call   800390 <_panic>

00801889 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801889:	55                   	push   %ebp
  80188a:	89 e5                	mov    %esp,%ebp
  80188c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()


	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80188f:	83 ec 04             	sub    $0x4,%esp
  801892:	68 ac 3f 80 00       	push   $0x803fac
  801897:	68 0c 01 00 00       	push   $0x10c
  80189c:	68 53 3f 80 00       	push   $0x803f53
  8018a1:	e8 ea ea ff ff       	call   800390 <_panic>

008018a6 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8018a6:	55                   	push   %ebp
  8018a7:	89 e5                	mov    %esp,%ebp
  8018a9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018ac:	83 ec 04             	sub    $0x4,%esp
  8018af:	68 d0 3f 80 00       	push   $0x803fd0
  8018b4:	68 44 01 00 00       	push   $0x144
  8018b9:	68 53 3f 80 00       	push   $0x803f53
  8018be:	e8 cd ea ff ff       	call   800390 <_panic>

008018c3 <shrink>:

}
void shrink(uint32 newSize)
{
  8018c3:	55                   	push   %ebp
  8018c4:	89 e5                	mov    %esp,%ebp
  8018c6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018c9:	83 ec 04             	sub    $0x4,%esp
  8018cc:	68 d0 3f 80 00       	push   $0x803fd0
  8018d1:	68 49 01 00 00       	push   $0x149
  8018d6:	68 53 3f 80 00       	push   $0x803f53
  8018db:	e8 b0 ea ff ff       	call   800390 <_panic>

008018e0 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8018e0:	55                   	push   %ebp
  8018e1:	89 e5                	mov    %esp,%ebp
  8018e3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018e6:	83 ec 04             	sub    $0x4,%esp
  8018e9:	68 d0 3f 80 00       	push   $0x803fd0
  8018ee:	68 4e 01 00 00       	push   $0x14e
  8018f3:	68 53 3f 80 00       	push   $0x803f53
  8018f8:	e8 93 ea ff ff       	call   800390 <_panic>

008018fd <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8018fd:	55                   	push   %ebp
  8018fe:	89 e5                	mov    %esp,%ebp
  801900:	57                   	push   %edi
  801901:	56                   	push   %esi
  801902:	53                   	push   %ebx
  801903:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801906:	8b 45 08             	mov    0x8(%ebp),%eax
  801909:	8b 55 0c             	mov    0xc(%ebp),%edx
  80190c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80190f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801912:	8b 7d 18             	mov    0x18(%ebp),%edi
  801915:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801918:	cd 30                	int    $0x30
  80191a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80191d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801920:	83 c4 10             	add    $0x10,%esp
  801923:	5b                   	pop    %ebx
  801924:	5e                   	pop    %esi
  801925:	5f                   	pop    %edi
  801926:	5d                   	pop    %ebp
  801927:	c3                   	ret    

00801928 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801928:	55                   	push   %ebp
  801929:	89 e5                	mov    %esp,%ebp
  80192b:	83 ec 04             	sub    $0x4,%esp
  80192e:	8b 45 10             	mov    0x10(%ebp),%eax
  801931:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801934:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801938:	8b 45 08             	mov    0x8(%ebp),%eax
  80193b:	6a 00                	push   $0x0
  80193d:	6a 00                	push   $0x0
  80193f:	52                   	push   %edx
  801940:	ff 75 0c             	pushl  0xc(%ebp)
  801943:	50                   	push   %eax
  801944:	6a 00                	push   $0x0
  801946:	e8 b2 ff ff ff       	call   8018fd <syscall>
  80194b:	83 c4 18             	add    $0x18,%esp
}
  80194e:	90                   	nop
  80194f:	c9                   	leave  
  801950:	c3                   	ret    

00801951 <sys_cgetc>:

int
sys_cgetc(void)
{
  801951:	55                   	push   %ebp
  801952:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801954:	6a 00                	push   $0x0
  801956:	6a 00                	push   $0x0
  801958:	6a 00                	push   $0x0
  80195a:	6a 00                	push   $0x0
  80195c:	6a 00                	push   $0x0
  80195e:	6a 01                	push   $0x1
  801960:	e8 98 ff ff ff       	call   8018fd <syscall>
  801965:	83 c4 18             	add    $0x18,%esp
}
  801968:	c9                   	leave  
  801969:	c3                   	ret    

0080196a <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80196a:	55                   	push   %ebp
  80196b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80196d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801970:	8b 45 08             	mov    0x8(%ebp),%eax
  801973:	6a 00                	push   $0x0
  801975:	6a 00                	push   $0x0
  801977:	6a 00                	push   $0x0
  801979:	52                   	push   %edx
  80197a:	50                   	push   %eax
  80197b:	6a 05                	push   $0x5
  80197d:	e8 7b ff ff ff       	call   8018fd <syscall>
  801982:	83 c4 18             	add    $0x18,%esp
}
  801985:	c9                   	leave  
  801986:	c3                   	ret    

00801987 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801987:	55                   	push   %ebp
  801988:	89 e5                	mov    %esp,%ebp
  80198a:	56                   	push   %esi
  80198b:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80198c:	8b 75 18             	mov    0x18(%ebp),%esi
  80198f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801992:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801995:	8b 55 0c             	mov    0xc(%ebp),%edx
  801998:	8b 45 08             	mov    0x8(%ebp),%eax
  80199b:	56                   	push   %esi
  80199c:	53                   	push   %ebx
  80199d:	51                   	push   %ecx
  80199e:	52                   	push   %edx
  80199f:	50                   	push   %eax
  8019a0:	6a 06                	push   $0x6
  8019a2:	e8 56 ff ff ff       	call   8018fd <syscall>
  8019a7:	83 c4 18             	add    $0x18,%esp
}
  8019aa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019ad:	5b                   	pop    %ebx
  8019ae:	5e                   	pop    %esi
  8019af:	5d                   	pop    %ebp
  8019b0:	c3                   	ret    

008019b1 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8019b1:	55                   	push   %ebp
  8019b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8019b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 00                	push   $0x0
  8019c0:	52                   	push   %edx
  8019c1:	50                   	push   %eax
  8019c2:	6a 07                	push   $0x7
  8019c4:	e8 34 ff ff ff       	call   8018fd <syscall>
  8019c9:	83 c4 18             	add    $0x18,%esp
}
  8019cc:	c9                   	leave  
  8019cd:	c3                   	ret    

008019ce <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8019ce:	55                   	push   %ebp
  8019cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 00                	push   $0x0
  8019d7:	ff 75 0c             	pushl  0xc(%ebp)
  8019da:	ff 75 08             	pushl  0x8(%ebp)
  8019dd:	6a 08                	push   $0x8
  8019df:	e8 19 ff ff ff       	call   8018fd <syscall>
  8019e4:	83 c4 18             	add    $0x18,%esp
}
  8019e7:	c9                   	leave  
  8019e8:	c3                   	ret    

008019e9 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8019e9:	55                   	push   %ebp
  8019ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8019ec:	6a 00                	push   $0x0
  8019ee:	6a 00                	push   $0x0
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 00                	push   $0x0
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 09                	push   $0x9
  8019f8:	e8 00 ff ff ff       	call   8018fd <syscall>
  8019fd:	83 c4 18             	add    $0x18,%esp
}
  801a00:	c9                   	leave  
  801a01:	c3                   	ret    

00801a02 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a02:	55                   	push   %ebp
  801a03:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a05:	6a 00                	push   $0x0
  801a07:	6a 00                	push   $0x0
  801a09:	6a 00                	push   $0x0
  801a0b:	6a 00                	push   $0x0
  801a0d:	6a 00                	push   $0x0
  801a0f:	6a 0a                	push   $0xa
  801a11:	e8 e7 fe ff ff       	call   8018fd <syscall>
  801a16:	83 c4 18             	add    $0x18,%esp
}
  801a19:	c9                   	leave  
  801a1a:	c3                   	ret    

00801a1b <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a1b:	55                   	push   %ebp
  801a1c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a1e:	6a 00                	push   $0x0
  801a20:	6a 00                	push   $0x0
  801a22:	6a 00                	push   $0x0
  801a24:	6a 00                	push   $0x0
  801a26:	6a 00                	push   $0x0
  801a28:	6a 0b                	push   $0xb
  801a2a:	e8 ce fe ff ff       	call   8018fd <syscall>
  801a2f:	83 c4 18             	add    $0x18,%esp
}
  801a32:	c9                   	leave  
  801a33:	c3                   	ret    

00801a34 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a34:	55                   	push   %ebp
  801a35:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801a37:	6a 00                	push   $0x0
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 00                	push   $0x0
  801a3d:	ff 75 0c             	pushl  0xc(%ebp)
  801a40:	ff 75 08             	pushl  0x8(%ebp)
  801a43:	6a 0f                	push   $0xf
  801a45:	e8 b3 fe ff ff       	call   8018fd <syscall>
  801a4a:	83 c4 18             	add    $0x18,%esp
	return;
  801a4d:	90                   	nop
}
  801a4e:	c9                   	leave  
  801a4f:	c3                   	ret    

00801a50 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a50:	55                   	push   %ebp
  801a51:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a53:	6a 00                	push   $0x0
  801a55:	6a 00                	push   $0x0
  801a57:	6a 00                	push   $0x0
  801a59:	ff 75 0c             	pushl  0xc(%ebp)
  801a5c:	ff 75 08             	pushl  0x8(%ebp)
  801a5f:	6a 10                	push   $0x10
  801a61:	e8 97 fe ff ff       	call   8018fd <syscall>
  801a66:	83 c4 18             	add    $0x18,%esp
	return ;
  801a69:	90                   	nop
}
  801a6a:	c9                   	leave  
  801a6b:	c3                   	ret    

00801a6c <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a6c:	55                   	push   %ebp
  801a6d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 00                	push   $0x0
  801a73:	ff 75 10             	pushl  0x10(%ebp)
  801a76:	ff 75 0c             	pushl  0xc(%ebp)
  801a79:	ff 75 08             	pushl  0x8(%ebp)
  801a7c:	6a 11                	push   $0x11
  801a7e:	e8 7a fe ff ff       	call   8018fd <syscall>
  801a83:	83 c4 18             	add    $0x18,%esp
	return ;
  801a86:	90                   	nop
}
  801a87:	c9                   	leave  
  801a88:	c3                   	ret    

00801a89 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a89:	55                   	push   %ebp
  801a8a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 00                	push   $0x0
  801a92:	6a 00                	push   $0x0
  801a94:	6a 00                	push   $0x0
  801a96:	6a 0c                	push   $0xc
  801a98:	e8 60 fe ff ff       	call   8018fd <syscall>
  801a9d:	83 c4 18             	add    $0x18,%esp
}
  801aa0:	c9                   	leave  
  801aa1:	c3                   	ret    

00801aa2 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801aa2:	55                   	push   %ebp
  801aa3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801aa5:	6a 00                	push   $0x0
  801aa7:	6a 00                	push   $0x0
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 00                	push   $0x0
  801aad:	ff 75 08             	pushl  0x8(%ebp)
  801ab0:	6a 0d                	push   $0xd
  801ab2:	e8 46 fe ff ff       	call   8018fd <syscall>
  801ab7:	83 c4 18             	add    $0x18,%esp
}
  801aba:	c9                   	leave  
  801abb:	c3                   	ret    

00801abc <sys_scarce_memory>:

void sys_scarce_memory()
{
  801abc:	55                   	push   %ebp
  801abd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 00                	push   $0x0
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 0e                	push   $0xe
  801acb:	e8 2d fe ff ff       	call   8018fd <syscall>
  801ad0:	83 c4 18             	add    $0x18,%esp
}
  801ad3:	90                   	nop
  801ad4:	c9                   	leave  
  801ad5:	c3                   	ret    

00801ad6 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801ad6:	55                   	push   %ebp
  801ad7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801ad9:	6a 00                	push   $0x0
  801adb:	6a 00                	push   $0x0
  801add:	6a 00                	push   $0x0
  801adf:	6a 00                	push   $0x0
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 13                	push   $0x13
  801ae5:	e8 13 fe ff ff       	call   8018fd <syscall>
  801aea:	83 c4 18             	add    $0x18,%esp
}
  801aed:	90                   	nop
  801aee:	c9                   	leave  
  801aef:	c3                   	ret    

00801af0 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801af0:	55                   	push   %ebp
  801af1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801af3:	6a 00                	push   $0x0
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	6a 00                	push   $0x0
  801afd:	6a 14                	push   $0x14
  801aff:	e8 f9 fd ff ff       	call   8018fd <syscall>
  801b04:	83 c4 18             	add    $0x18,%esp
}
  801b07:	90                   	nop
  801b08:	c9                   	leave  
  801b09:	c3                   	ret    

00801b0a <sys_cputc>:


void
sys_cputc(const char c)
{
  801b0a:	55                   	push   %ebp
  801b0b:	89 e5                	mov    %esp,%ebp
  801b0d:	83 ec 04             	sub    $0x4,%esp
  801b10:	8b 45 08             	mov    0x8(%ebp),%eax
  801b13:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b16:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b1a:	6a 00                	push   $0x0
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 00                	push   $0x0
  801b22:	50                   	push   %eax
  801b23:	6a 15                	push   $0x15
  801b25:	e8 d3 fd ff ff       	call   8018fd <syscall>
  801b2a:	83 c4 18             	add    $0x18,%esp
}
  801b2d:	90                   	nop
  801b2e:	c9                   	leave  
  801b2f:	c3                   	ret    

00801b30 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b30:	55                   	push   %ebp
  801b31:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b33:	6a 00                	push   $0x0
  801b35:	6a 00                	push   $0x0
  801b37:	6a 00                	push   $0x0
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 16                	push   $0x16
  801b3f:	e8 b9 fd ff ff       	call   8018fd <syscall>
  801b44:	83 c4 18             	add    $0x18,%esp
}
  801b47:	90                   	nop
  801b48:	c9                   	leave  
  801b49:	c3                   	ret    

00801b4a <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801b4a:	55                   	push   %ebp
  801b4b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b50:	6a 00                	push   $0x0
  801b52:	6a 00                	push   $0x0
  801b54:	6a 00                	push   $0x0
  801b56:	ff 75 0c             	pushl  0xc(%ebp)
  801b59:	50                   	push   %eax
  801b5a:	6a 17                	push   $0x17
  801b5c:	e8 9c fd ff ff       	call   8018fd <syscall>
  801b61:	83 c4 18             	add    $0x18,%esp
}
  801b64:	c9                   	leave  
  801b65:	c3                   	ret    

00801b66 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801b66:	55                   	push   %ebp
  801b67:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b69:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 00                	push   $0x0
  801b73:	6a 00                	push   $0x0
  801b75:	52                   	push   %edx
  801b76:	50                   	push   %eax
  801b77:	6a 1a                	push   $0x1a
  801b79:	e8 7f fd ff ff       	call   8018fd <syscall>
  801b7e:	83 c4 18             	add    $0x18,%esp
}
  801b81:	c9                   	leave  
  801b82:	c3                   	ret    

00801b83 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b83:	55                   	push   %ebp
  801b84:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b86:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b89:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8c:	6a 00                	push   $0x0
  801b8e:	6a 00                	push   $0x0
  801b90:	6a 00                	push   $0x0
  801b92:	52                   	push   %edx
  801b93:	50                   	push   %eax
  801b94:	6a 18                	push   $0x18
  801b96:	e8 62 fd ff ff       	call   8018fd <syscall>
  801b9b:	83 c4 18             	add    $0x18,%esp
}
  801b9e:	90                   	nop
  801b9f:	c9                   	leave  
  801ba0:	c3                   	ret    

00801ba1 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ba1:	55                   	push   %ebp
  801ba2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ba4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  801baa:	6a 00                	push   $0x0
  801bac:	6a 00                	push   $0x0
  801bae:	6a 00                	push   $0x0
  801bb0:	52                   	push   %edx
  801bb1:	50                   	push   %eax
  801bb2:	6a 19                	push   $0x19
  801bb4:	e8 44 fd ff ff       	call   8018fd <syscall>
  801bb9:	83 c4 18             	add    $0x18,%esp
}
  801bbc:	90                   	nop
  801bbd:	c9                   	leave  
  801bbe:	c3                   	ret    

00801bbf <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801bbf:	55                   	push   %ebp
  801bc0:	89 e5                	mov    %esp,%ebp
  801bc2:	83 ec 04             	sub    $0x4,%esp
  801bc5:	8b 45 10             	mov    0x10(%ebp),%eax
  801bc8:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801bcb:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801bce:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd5:	6a 00                	push   $0x0
  801bd7:	51                   	push   %ecx
  801bd8:	52                   	push   %edx
  801bd9:	ff 75 0c             	pushl  0xc(%ebp)
  801bdc:	50                   	push   %eax
  801bdd:	6a 1b                	push   $0x1b
  801bdf:	e8 19 fd ff ff       	call   8018fd <syscall>
  801be4:	83 c4 18             	add    $0x18,%esp
}
  801be7:	c9                   	leave  
  801be8:	c3                   	ret    

00801be9 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801be9:	55                   	push   %ebp
  801bea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801bec:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bef:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf2:	6a 00                	push   $0x0
  801bf4:	6a 00                	push   $0x0
  801bf6:	6a 00                	push   $0x0
  801bf8:	52                   	push   %edx
  801bf9:	50                   	push   %eax
  801bfa:	6a 1c                	push   $0x1c
  801bfc:	e8 fc fc ff ff       	call   8018fd <syscall>
  801c01:	83 c4 18             	add    $0x18,%esp
}
  801c04:	c9                   	leave  
  801c05:	c3                   	ret    

00801c06 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801c06:	55                   	push   %ebp
  801c07:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801c09:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c0c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c12:	6a 00                	push   $0x0
  801c14:	6a 00                	push   $0x0
  801c16:	51                   	push   %ecx
  801c17:	52                   	push   %edx
  801c18:	50                   	push   %eax
  801c19:	6a 1d                	push   $0x1d
  801c1b:	e8 dd fc ff ff       	call   8018fd <syscall>
  801c20:	83 c4 18             	add    $0x18,%esp
}
  801c23:	c9                   	leave  
  801c24:	c3                   	ret    

00801c25 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801c25:	55                   	push   %ebp
  801c26:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c28:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2e:	6a 00                	push   $0x0
  801c30:	6a 00                	push   $0x0
  801c32:	6a 00                	push   $0x0
  801c34:	52                   	push   %edx
  801c35:	50                   	push   %eax
  801c36:	6a 1e                	push   $0x1e
  801c38:	e8 c0 fc ff ff       	call   8018fd <syscall>
  801c3d:	83 c4 18             	add    $0x18,%esp
}
  801c40:	c9                   	leave  
  801c41:	c3                   	ret    

00801c42 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801c42:	55                   	push   %ebp
  801c43:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801c45:	6a 00                	push   $0x0
  801c47:	6a 00                	push   $0x0
  801c49:	6a 00                	push   $0x0
  801c4b:	6a 00                	push   $0x0
  801c4d:	6a 00                	push   $0x0
  801c4f:	6a 1f                	push   $0x1f
  801c51:	e8 a7 fc ff ff       	call   8018fd <syscall>
  801c56:	83 c4 18             	add    $0x18,%esp
}
  801c59:	c9                   	leave  
  801c5a:	c3                   	ret    

00801c5b <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c5b:	55                   	push   %ebp
  801c5c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c61:	6a 00                	push   $0x0
  801c63:	ff 75 14             	pushl  0x14(%ebp)
  801c66:	ff 75 10             	pushl  0x10(%ebp)
  801c69:	ff 75 0c             	pushl  0xc(%ebp)
  801c6c:	50                   	push   %eax
  801c6d:	6a 20                	push   $0x20
  801c6f:	e8 89 fc ff ff       	call   8018fd <syscall>
  801c74:	83 c4 18             	add    $0x18,%esp
}
  801c77:	c9                   	leave  
  801c78:	c3                   	ret    

00801c79 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801c79:	55                   	push   %ebp
  801c7a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7f:	6a 00                	push   $0x0
  801c81:	6a 00                	push   $0x0
  801c83:	6a 00                	push   $0x0
  801c85:	6a 00                	push   $0x0
  801c87:	50                   	push   %eax
  801c88:	6a 21                	push   $0x21
  801c8a:	e8 6e fc ff ff       	call   8018fd <syscall>
  801c8f:	83 c4 18             	add    $0x18,%esp
}
  801c92:	90                   	nop
  801c93:	c9                   	leave  
  801c94:	c3                   	ret    

00801c95 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c95:	55                   	push   %ebp
  801c96:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c98:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9b:	6a 00                	push   $0x0
  801c9d:	6a 00                	push   $0x0
  801c9f:	6a 00                	push   $0x0
  801ca1:	6a 00                	push   $0x0
  801ca3:	50                   	push   %eax
  801ca4:	6a 22                	push   $0x22
  801ca6:	e8 52 fc ff ff       	call   8018fd <syscall>
  801cab:	83 c4 18             	add    $0x18,%esp
}
  801cae:	c9                   	leave  
  801caf:	c3                   	ret    

00801cb0 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801cb0:	55                   	push   %ebp
  801cb1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801cb3:	6a 00                	push   $0x0
  801cb5:	6a 00                	push   $0x0
  801cb7:	6a 00                	push   $0x0
  801cb9:	6a 00                	push   $0x0
  801cbb:	6a 00                	push   $0x0
  801cbd:	6a 02                	push   $0x2
  801cbf:	e8 39 fc ff ff       	call   8018fd <syscall>
  801cc4:	83 c4 18             	add    $0x18,%esp
}
  801cc7:	c9                   	leave  
  801cc8:	c3                   	ret    

00801cc9 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801cc9:	55                   	push   %ebp
  801cca:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801ccc:	6a 00                	push   $0x0
  801cce:	6a 00                	push   $0x0
  801cd0:	6a 00                	push   $0x0
  801cd2:	6a 00                	push   $0x0
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 03                	push   $0x3
  801cd8:	e8 20 fc ff ff       	call   8018fd <syscall>
  801cdd:	83 c4 18             	add    $0x18,%esp
}
  801ce0:	c9                   	leave  
  801ce1:	c3                   	ret    

00801ce2 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801ce2:	55                   	push   %ebp
  801ce3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801ce5:	6a 00                	push   $0x0
  801ce7:	6a 00                	push   $0x0
  801ce9:	6a 00                	push   $0x0
  801ceb:	6a 00                	push   $0x0
  801ced:	6a 00                	push   $0x0
  801cef:	6a 04                	push   $0x4
  801cf1:	e8 07 fc ff ff       	call   8018fd <syscall>
  801cf6:	83 c4 18             	add    $0x18,%esp
}
  801cf9:	c9                   	leave  
  801cfa:	c3                   	ret    

00801cfb <sys_exit_env>:


void sys_exit_env(void)
{
  801cfb:	55                   	push   %ebp
  801cfc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801cfe:	6a 00                	push   $0x0
  801d00:	6a 00                	push   $0x0
  801d02:	6a 00                	push   $0x0
  801d04:	6a 00                	push   $0x0
  801d06:	6a 00                	push   $0x0
  801d08:	6a 23                	push   $0x23
  801d0a:	e8 ee fb ff ff       	call   8018fd <syscall>
  801d0f:	83 c4 18             	add    $0x18,%esp
}
  801d12:	90                   	nop
  801d13:	c9                   	leave  
  801d14:	c3                   	ret    

00801d15 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801d15:	55                   	push   %ebp
  801d16:	89 e5                	mov    %esp,%ebp
  801d18:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801d1b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d1e:	8d 50 04             	lea    0x4(%eax),%edx
  801d21:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d24:	6a 00                	push   $0x0
  801d26:	6a 00                	push   $0x0
  801d28:	6a 00                	push   $0x0
  801d2a:	52                   	push   %edx
  801d2b:	50                   	push   %eax
  801d2c:	6a 24                	push   $0x24
  801d2e:	e8 ca fb ff ff       	call   8018fd <syscall>
  801d33:	83 c4 18             	add    $0x18,%esp
	return result;
  801d36:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d39:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d3c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d3f:	89 01                	mov    %eax,(%ecx)
  801d41:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d44:	8b 45 08             	mov    0x8(%ebp),%eax
  801d47:	c9                   	leave  
  801d48:	c2 04 00             	ret    $0x4

00801d4b <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d4b:	55                   	push   %ebp
  801d4c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d4e:	6a 00                	push   $0x0
  801d50:	6a 00                	push   $0x0
  801d52:	ff 75 10             	pushl  0x10(%ebp)
  801d55:	ff 75 0c             	pushl  0xc(%ebp)
  801d58:	ff 75 08             	pushl  0x8(%ebp)
  801d5b:	6a 12                	push   $0x12
  801d5d:	e8 9b fb ff ff       	call   8018fd <syscall>
  801d62:	83 c4 18             	add    $0x18,%esp
	return ;
  801d65:	90                   	nop
}
  801d66:	c9                   	leave  
  801d67:	c3                   	ret    

00801d68 <sys_rcr2>:
uint32 sys_rcr2()
{
  801d68:	55                   	push   %ebp
  801d69:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d6b:	6a 00                	push   $0x0
  801d6d:	6a 00                	push   $0x0
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 00                	push   $0x0
  801d73:	6a 00                	push   $0x0
  801d75:	6a 25                	push   $0x25
  801d77:	e8 81 fb ff ff       	call   8018fd <syscall>
  801d7c:	83 c4 18             	add    $0x18,%esp
}
  801d7f:	c9                   	leave  
  801d80:	c3                   	ret    

00801d81 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d81:	55                   	push   %ebp
  801d82:	89 e5                	mov    %esp,%ebp
  801d84:	83 ec 04             	sub    $0x4,%esp
  801d87:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d8d:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d91:	6a 00                	push   $0x0
  801d93:	6a 00                	push   $0x0
  801d95:	6a 00                	push   $0x0
  801d97:	6a 00                	push   $0x0
  801d99:	50                   	push   %eax
  801d9a:	6a 26                	push   $0x26
  801d9c:	e8 5c fb ff ff       	call   8018fd <syscall>
  801da1:	83 c4 18             	add    $0x18,%esp
	return ;
  801da4:	90                   	nop
}
  801da5:	c9                   	leave  
  801da6:	c3                   	ret    

00801da7 <rsttst>:
void rsttst()
{
  801da7:	55                   	push   %ebp
  801da8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801daa:	6a 00                	push   $0x0
  801dac:	6a 00                	push   $0x0
  801dae:	6a 00                	push   $0x0
  801db0:	6a 00                	push   $0x0
  801db2:	6a 00                	push   $0x0
  801db4:	6a 28                	push   $0x28
  801db6:	e8 42 fb ff ff       	call   8018fd <syscall>
  801dbb:	83 c4 18             	add    $0x18,%esp
	return ;
  801dbe:	90                   	nop
}
  801dbf:	c9                   	leave  
  801dc0:	c3                   	ret    

00801dc1 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801dc1:	55                   	push   %ebp
  801dc2:	89 e5                	mov    %esp,%ebp
  801dc4:	83 ec 04             	sub    $0x4,%esp
  801dc7:	8b 45 14             	mov    0x14(%ebp),%eax
  801dca:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801dcd:	8b 55 18             	mov    0x18(%ebp),%edx
  801dd0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801dd4:	52                   	push   %edx
  801dd5:	50                   	push   %eax
  801dd6:	ff 75 10             	pushl  0x10(%ebp)
  801dd9:	ff 75 0c             	pushl  0xc(%ebp)
  801ddc:	ff 75 08             	pushl  0x8(%ebp)
  801ddf:	6a 27                	push   $0x27
  801de1:	e8 17 fb ff ff       	call   8018fd <syscall>
  801de6:	83 c4 18             	add    $0x18,%esp
	return ;
  801de9:	90                   	nop
}
  801dea:	c9                   	leave  
  801deb:	c3                   	ret    

00801dec <chktst>:
void chktst(uint32 n)
{
  801dec:	55                   	push   %ebp
  801ded:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801def:	6a 00                	push   $0x0
  801df1:	6a 00                	push   $0x0
  801df3:	6a 00                	push   $0x0
  801df5:	6a 00                	push   $0x0
  801df7:	ff 75 08             	pushl  0x8(%ebp)
  801dfa:	6a 29                	push   $0x29
  801dfc:	e8 fc fa ff ff       	call   8018fd <syscall>
  801e01:	83 c4 18             	add    $0x18,%esp
	return ;
  801e04:	90                   	nop
}
  801e05:	c9                   	leave  
  801e06:	c3                   	ret    

00801e07 <inctst>:

void inctst()
{
  801e07:	55                   	push   %ebp
  801e08:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801e0a:	6a 00                	push   $0x0
  801e0c:	6a 00                	push   $0x0
  801e0e:	6a 00                	push   $0x0
  801e10:	6a 00                	push   $0x0
  801e12:	6a 00                	push   $0x0
  801e14:	6a 2a                	push   $0x2a
  801e16:	e8 e2 fa ff ff       	call   8018fd <syscall>
  801e1b:	83 c4 18             	add    $0x18,%esp
	return ;
  801e1e:	90                   	nop
}
  801e1f:	c9                   	leave  
  801e20:	c3                   	ret    

00801e21 <gettst>:
uint32 gettst()
{
  801e21:	55                   	push   %ebp
  801e22:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801e24:	6a 00                	push   $0x0
  801e26:	6a 00                	push   $0x0
  801e28:	6a 00                	push   $0x0
  801e2a:	6a 00                	push   $0x0
  801e2c:	6a 00                	push   $0x0
  801e2e:	6a 2b                	push   $0x2b
  801e30:	e8 c8 fa ff ff       	call   8018fd <syscall>
  801e35:	83 c4 18             	add    $0x18,%esp
}
  801e38:	c9                   	leave  
  801e39:	c3                   	ret    

00801e3a <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801e3a:	55                   	push   %ebp
  801e3b:	89 e5                	mov    %esp,%ebp
  801e3d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e40:	6a 00                	push   $0x0
  801e42:	6a 00                	push   $0x0
  801e44:	6a 00                	push   $0x0
  801e46:	6a 00                	push   $0x0
  801e48:	6a 00                	push   $0x0
  801e4a:	6a 2c                	push   $0x2c
  801e4c:	e8 ac fa ff ff       	call   8018fd <syscall>
  801e51:	83 c4 18             	add    $0x18,%esp
  801e54:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e57:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e5b:	75 07                	jne    801e64 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e5d:	b8 01 00 00 00       	mov    $0x1,%eax
  801e62:	eb 05                	jmp    801e69 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e64:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e69:	c9                   	leave  
  801e6a:	c3                   	ret    

00801e6b <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e6b:	55                   	push   %ebp
  801e6c:	89 e5                	mov    %esp,%ebp
  801e6e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e71:	6a 00                	push   $0x0
  801e73:	6a 00                	push   $0x0
  801e75:	6a 00                	push   $0x0
  801e77:	6a 00                	push   $0x0
  801e79:	6a 00                	push   $0x0
  801e7b:	6a 2c                	push   $0x2c
  801e7d:	e8 7b fa ff ff       	call   8018fd <syscall>
  801e82:	83 c4 18             	add    $0x18,%esp
  801e85:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e88:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e8c:	75 07                	jne    801e95 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e8e:	b8 01 00 00 00       	mov    $0x1,%eax
  801e93:	eb 05                	jmp    801e9a <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e95:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e9a:	c9                   	leave  
  801e9b:	c3                   	ret    

00801e9c <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e9c:	55                   	push   %ebp
  801e9d:	89 e5                	mov    %esp,%ebp
  801e9f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ea2:	6a 00                	push   $0x0
  801ea4:	6a 00                	push   $0x0
  801ea6:	6a 00                	push   $0x0
  801ea8:	6a 00                	push   $0x0
  801eaa:	6a 00                	push   $0x0
  801eac:	6a 2c                	push   $0x2c
  801eae:	e8 4a fa ff ff       	call   8018fd <syscall>
  801eb3:	83 c4 18             	add    $0x18,%esp
  801eb6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801eb9:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801ebd:	75 07                	jne    801ec6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801ebf:	b8 01 00 00 00       	mov    $0x1,%eax
  801ec4:	eb 05                	jmp    801ecb <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801ec6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ecb:	c9                   	leave  
  801ecc:	c3                   	ret    

00801ecd <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801ecd:	55                   	push   %ebp
  801ece:	89 e5                	mov    %esp,%ebp
  801ed0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ed3:	6a 00                	push   $0x0
  801ed5:	6a 00                	push   $0x0
  801ed7:	6a 00                	push   $0x0
  801ed9:	6a 00                	push   $0x0
  801edb:	6a 00                	push   $0x0
  801edd:	6a 2c                	push   $0x2c
  801edf:	e8 19 fa ff ff       	call   8018fd <syscall>
  801ee4:	83 c4 18             	add    $0x18,%esp
  801ee7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801eea:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801eee:	75 07                	jne    801ef7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801ef0:	b8 01 00 00 00       	mov    $0x1,%eax
  801ef5:	eb 05                	jmp    801efc <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ef7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801efc:	c9                   	leave  
  801efd:	c3                   	ret    

00801efe <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801efe:	55                   	push   %ebp
  801eff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801f01:	6a 00                	push   $0x0
  801f03:	6a 00                	push   $0x0
  801f05:	6a 00                	push   $0x0
  801f07:	6a 00                	push   $0x0
  801f09:	ff 75 08             	pushl  0x8(%ebp)
  801f0c:	6a 2d                	push   $0x2d
  801f0e:	e8 ea f9 ff ff       	call   8018fd <syscall>
  801f13:	83 c4 18             	add    $0x18,%esp
	return ;
  801f16:	90                   	nop
}
  801f17:	c9                   	leave  
  801f18:	c3                   	ret    

00801f19 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801f19:	55                   	push   %ebp
  801f1a:	89 e5                	mov    %esp,%ebp
  801f1c:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801f1d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f20:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f23:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f26:	8b 45 08             	mov    0x8(%ebp),%eax
  801f29:	6a 00                	push   $0x0
  801f2b:	53                   	push   %ebx
  801f2c:	51                   	push   %ecx
  801f2d:	52                   	push   %edx
  801f2e:	50                   	push   %eax
  801f2f:	6a 2e                	push   $0x2e
  801f31:	e8 c7 f9 ff ff       	call   8018fd <syscall>
  801f36:	83 c4 18             	add    $0x18,%esp
}
  801f39:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f3c:	c9                   	leave  
  801f3d:	c3                   	ret    

00801f3e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f3e:	55                   	push   %ebp
  801f3f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f41:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f44:	8b 45 08             	mov    0x8(%ebp),%eax
  801f47:	6a 00                	push   $0x0
  801f49:	6a 00                	push   $0x0
  801f4b:	6a 00                	push   $0x0
  801f4d:	52                   	push   %edx
  801f4e:	50                   	push   %eax
  801f4f:	6a 2f                	push   $0x2f
  801f51:	e8 a7 f9 ff ff       	call   8018fd <syscall>
  801f56:	83 c4 18             	add    $0x18,%esp
}
  801f59:	c9                   	leave  
  801f5a:	c3                   	ret    

00801f5b <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801f5b:	55                   	push   %ebp
  801f5c:	89 e5                	mov    %esp,%ebp
  801f5e:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801f61:	83 ec 0c             	sub    $0xc,%esp
  801f64:	68 e0 3f 80 00       	push   $0x803fe0
  801f69:	e8 d6 e6 ff ff       	call   800644 <cprintf>
  801f6e:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801f71:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801f78:	83 ec 0c             	sub    $0xc,%esp
  801f7b:	68 0c 40 80 00       	push   $0x80400c
  801f80:	e8 bf e6 ff ff       	call   800644 <cprintf>
  801f85:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801f88:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f8c:	a1 38 51 80 00       	mov    0x805138,%eax
  801f91:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f94:	eb 56                	jmp    801fec <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f96:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f9a:	74 1c                	je     801fb8 <print_mem_block_lists+0x5d>
  801f9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f9f:	8b 50 08             	mov    0x8(%eax),%edx
  801fa2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fa5:	8b 48 08             	mov    0x8(%eax),%ecx
  801fa8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fab:	8b 40 0c             	mov    0xc(%eax),%eax
  801fae:	01 c8                	add    %ecx,%eax
  801fb0:	39 c2                	cmp    %eax,%edx
  801fb2:	73 04                	jae    801fb8 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801fb4:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801fb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fbb:	8b 50 08             	mov    0x8(%eax),%edx
  801fbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc1:	8b 40 0c             	mov    0xc(%eax),%eax
  801fc4:	01 c2                	add    %eax,%edx
  801fc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc9:	8b 40 08             	mov    0x8(%eax),%eax
  801fcc:	83 ec 04             	sub    $0x4,%esp
  801fcf:	52                   	push   %edx
  801fd0:	50                   	push   %eax
  801fd1:	68 21 40 80 00       	push   $0x804021
  801fd6:	e8 69 e6 ff ff       	call   800644 <cprintf>
  801fdb:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801fde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801fe4:	a1 40 51 80 00       	mov    0x805140,%eax
  801fe9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ff0:	74 07                	je     801ff9 <print_mem_block_lists+0x9e>
  801ff2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff5:	8b 00                	mov    (%eax),%eax
  801ff7:	eb 05                	jmp    801ffe <print_mem_block_lists+0xa3>
  801ff9:	b8 00 00 00 00       	mov    $0x0,%eax
  801ffe:	a3 40 51 80 00       	mov    %eax,0x805140
  802003:	a1 40 51 80 00       	mov    0x805140,%eax
  802008:	85 c0                	test   %eax,%eax
  80200a:	75 8a                	jne    801f96 <print_mem_block_lists+0x3b>
  80200c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802010:	75 84                	jne    801f96 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802012:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802016:	75 10                	jne    802028 <print_mem_block_lists+0xcd>
  802018:	83 ec 0c             	sub    $0xc,%esp
  80201b:	68 30 40 80 00       	push   $0x804030
  802020:	e8 1f e6 ff ff       	call   800644 <cprintf>
  802025:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802028:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80202f:	83 ec 0c             	sub    $0xc,%esp
  802032:	68 54 40 80 00       	push   $0x804054
  802037:	e8 08 e6 ff ff       	call   800644 <cprintf>
  80203c:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80203f:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802043:	a1 40 50 80 00       	mov    0x805040,%eax
  802048:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80204b:	eb 56                	jmp    8020a3 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80204d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802051:	74 1c                	je     80206f <print_mem_block_lists+0x114>
  802053:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802056:	8b 50 08             	mov    0x8(%eax),%edx
  802059:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80205c:	8b 48 08             	mov    0x8(%eax),%ecx
  80205f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802062:	8b 40 0c             	mov    0xc(%eax),%eax
  802065:	01 c8                	add    %ecx,%eax
  802067:	39 c2                	cmp    %eax,%edx
  802069:	73 04                	jae    80206f <print_mem_block_lists+0x114>
			sorted = 0 ;
  80206b:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80206f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802072:	8b 50 08             	mov    0x8(%eax),%edx
  802075:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802078:	8b 40 0c             	mov    0xc(%eax),%eax
  80207b:	01 c2                	add    %eax,%edx
  80207d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802080:	8b 40 08             	mov    0x8(%eax),%eax
  802083:	83 ec 04             	sub    $0x4,%esp
  802086:	52                   	push   %edx
  802087:	50                   	push   %eax
  802088:	68 21 40 80 00       	push   $0x804021
  80208d:	e8 b2 e5 ff ff       	call   800644 <cprintf>
  802092:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802095:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802098:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80209b:	a1 48 50 80 00       	mov    0x805048,%eax
  8020a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020a7:	74 07                	je     8020b0 <print_mem_block_lists+0x155>
  8020a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ac:	8b 00                	mov    (%eax),%eax
  8020ae:	eb 05                	jmp    8020b5 <print_mem_block_lists+0x15a>
  8020b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8020b5:	a3 48 50 80 00       	mov    %eax,0x805048
  8020ba:	a1 48 50 80 00       	mov    0x805048,%eax
  8020bf:	85 c0                	test   %eax,%eax
  8020c1:	75 8a                	jne    80204d <print_mem_block_lists+0xf2>
  8020c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020c7:	75 84                	jne    80204d <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8020c9:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8020cd:	75 10                	jne    8020df <print_mem_block_lists+0x184>
  8020cf:	83 ec 0c             	sub    $0xc,%esp
  8020d2:	68 6c 40 80 00       	push   $0x80406c
  8020d7:	e8 68 e5 ff ff       	call   800644 <cprintf>
  8020dc:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8020df:	83 ec 0c             	sub    $0xc,%esp
  8020e2:	68 e0 3f 80 00       	push   $0x803fe0
  8020e7:	e8 58 e5 ff ff       	call   800644 <cprintf>
  8020ec:	83 c4 10             	add    $0x10,%esp

}
  8020ef:	90                   	nop
  8020f0:	c9                   	leave  
  8020f1:	c3                   	ret    

008020f2 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8020f2:	55                   	push   %ebp
  8020f3:	89 e5                	mov    %esp,%ebp
  8020f5:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  8020f8:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8020ff:	00 00 00 
  802102:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802109:	00 00 00 
  80210c:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802113:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802116:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80211d:	e9 9e 00 00 00       	jmp    8021c0 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802122:	a1 50 50 80 00       	mov    0x805050,%eax
  802127:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80212a:	c1 e2 04             	shl    $0x4,%edx
  80212d:	01 d0                	add    %edx,%eax
  80212f:	85 c0                	test   %eax,%eax
  802131:	75 14                	jne    802147 <initialize_MemBlocksList+0x55>
  802133:	83 ec 04             	sub    $0x4,%esp
  802136:	68 94 40 80 00       	push   $0x804094
  80213b:	6a 46                	push   $0x46
  80213d:	68 b7 40 80 00       	push   $0x8040b7
  802142:	e8 49 e2 ff ff       	call   800390 <_panic>
  802147:	a1 50 50 80 00       	mov    0x805050,%eax
  80214c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80214f:	c1 e2 04             	shl    $0x4,%edx
  802152:	01 d0                	add    %edx,%eax
  802154:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80215a:	89 10                	mov    %edx,(%eax)
  80215c:	8b 00                	mov    (%eax),%eax
  80215e:	85 c0                	test   %eax,%eax
  802160:	74 18                	je     80217a <initialize_MemBlocksList+0x88>
  802162:	a1 48 51 80 00       	mov    0x805148,%eax
  802167:	8b 15 50 50 80 00    	mov    0x805050,%edx
  80216d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802170:	c1 e1 04             	shl    $0x4,%ecx
  802173:	01 ca                	add    %ecx,%edx
  802175:	89 50 04             	mov    %edx,0x4(%eax)
  802178:	eb 12                	jmp    80218c <initialize_MemBlocksList+0x9a>
  80217a:	a1 50 50 80 00       	mov    0x805050,%eax
  80217f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802182:	c1 e2 04             	shl    $0x4,%edx
  802185:	01 d0                	add    %edx,%eax
  802187:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80218c:	a1 50 50 80 00       	mov    0x805050,%eax
  802191:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802194:	c1 e2 04             	shl    $0x4,%edx
  802197:	01 d0                	add    %edx,%eax
  802199:	a3 48 51 80 00       	mov    %eax,0x805148
  80219e:	a1 50 50 80 00       	mov    0x805050,%eax
  8021a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021a6:	c1 e2 04             	shl    $0x4,%edx
  8021a9:	01 d0                	add    %edx,%eax
  8021ab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021b2:	a1 54 51 80 00       	mov    0x805154,%eax
  8021b7:	40                   	inc    %eax
  8021b8:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  8021bd:	ff 45 f4             	incl   -0xc(%ebp)
  8021c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021c6:	0f 82 56 ff ff ff    	jb     802122 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  8021cc:	90                   	nop
  8021cd:	c9                   	leave  
  8021ce:	c3                   	ret    

008021cf <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8021cf:	55                   	push   %ebp
  8021d0:	89 e5                	mov    %esp,%ebp
  8021d2:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8021d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d8:	8b 00                	mov    (%eax),%eax
  8021da:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8021dd:	eb 19                	jmp    8021f8 <find_block+0x29>
	{
		if(va==point->sva)
  8021df:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021e2:	8b 40 08             	mov    0x8(%eax),%eax
  8021e5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8021e8:	75 05                	jne    8021ef <find_block+0x20>
		   return point;
  8021ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021ed:	eb 36                	jmp    802225 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8021ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f2:	8b 40 08             	mov    0x8(%eax),%eax
  8021f5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8021f8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021fc:	74 07                	je     802205 <find_block+0x36>
  8021fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802201:	8b 00                	mov    (%eax),%eax
  802203:	eb 05                	jmp    80220a <find_block+0x3b>
  802205:	b8 00 00 00 00       	mov    $0x0,%eax
  80220a:	8b 55 08             	mov    0x8(%ebp),%edx
  80220d:	89 42 08             	mov    %eax,0x8(%edx)
  802210:	8b 45 08             	mov    0x8(%ebp),%eax
  802213:	8b 40 08             	mov    0x8(%eax),%eax
  802216:	85 c0                	test   %eax,%eax
  802218:	75 c5                	jne    8021df <find_block+0x10>
  80221a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80221e:	75 bf                	jne    8021df <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802220:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802225:	c9                   	leave  
  802226:	c3                   	ret    

00802227 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802227:	55                   	push   %ebp
  802228:	89 e5                	mov    %esp,%ebp
  80222a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  80222d:	a1 40 50 80 00       	mov    0x805040,%eax
  802232:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802235:	a1 44 50 80 00       	mov    0x805044,%eax
  80223a:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  80223d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802240:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802243:	74 24                	je     802269 <insert_sorted_allocList+0x42>
  802245:	8b 45 08             	mov    0x8(%ebp),%eax
  802248:	8b 50 08             	mov    0x8(%eax),%edx
  80224b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80224e:	8b 40 08             	mov    0x8(%eax),%eax
  802251:	39 c2                	cmp    %eax,%edx
  802253:	76 14                	jbe    802269 <insert_sorted_allocList+0x42>
  802255:	8b 45 08             	mov    0x8(%ebp),%eax
  802258:	8b 50 08             	mov    0x8(%eax),%edx
  80225b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80225e:	8b 40 08             	mov    0x8(%eax),%eax
  802261:	39 c2                	cmp    %eax,%edx
  802263:	0f 82 60 01 00 00    	jb     8023c9 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802269:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80226d:	75 65                	jne    8022d4 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  80226f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802273:	75 14                	jne    802289 <insert_sorted_allocList+0x62>
  802275:	83 ec 04             	sub    $0x4,%esp
  802278:	68 94 40 80 00       	push   $0x804094
  80227d:	6a 6b                	push   $0x6b
  80227f:	68 b7 40 80 00       	push   $0x8040b7
  802284:	e8 07 e1 ff ff       	call   800390 <_panic>
  802289:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80228f:	8b 45 08             	mov    0x8(%ebp),%eax
  802292:	89 10                	mov    %edx,(%eax)
  802294:	8b 45 08             	mov    0x8(%ebp),%eax
  802297:	8b 00                	mov    (%eax),%eax
  802299:	85 c0                	test   %eax,%eax
  80229b:	74 0d                	je     8022aa <insert_sorted_allocList+0x83>
  80229d:	a1 40 50 80 00       	mov    0x805040,%eax
  8022a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8022a5:	89 50 04             	mov    %edx,0x4(%eax)
  8022a8:	eb 08                	jmp    8022b2 <insert_sorted_allocList+0x8b>
  8022aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ad:	a3 44 50 80 00       	mov    %eax,0x805044
  8022b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b5:	a3 40 50 80 00       	mov    %eax,0x805040
  8022ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022c4:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8022c9:	40                   	inc    %eax
  8022ca:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8022cf:	e9 dc 01 00 00       	jmp    8024b0 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8022d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d7:	8b 50 08             	mov    0x8(%eax),%edx
  8022da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022dd:	8b 40 08             	mov    0x8(%eax),%eax
  8022e0:	39 c2                	cmp    %eax,%edx
  8022e2:	77 6c                	ja     802350 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8022e4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022e8:	74 06                	je     8022f0 <insert_sorted_allocList+0xc9>
  8022ea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022ee:	75 14                	jne    802304 <insert_sorted_allocList+0xdd>
  8022f0:	83 ec 04             	sub    $0x4,%esp
  8022f3:	68 d0 40 80 00       	push   $0x8040d0
  8022f8:	6a 6f                	push   $0x6f
  8022fa:	68 b7 40 80 00       	push   $0x8040b7
  8022ff:	e8 8c e0 ff ff       	call   800390 <_panic>
  802304:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802307:	8b 50 04             	mov    0x4(%eax),%edx
  80230a:	8b 45 08             	mov    0x8(%ebp),%eax
  80230d:	89 50 04             	mov    %edx,0x4(%eax)
  802310:	8b 45 08             	mov    0x8(%ebp),%eax
  802313:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802316:	89 10                	mov    %edx,(%eax)
  802318:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80231b:	8b 40 04             	mov    0x4(%eax),%eax
  80231e:	85 c0                	test   %eax,%eax
  802320:	74 0d                	je     80232f <insert_sorted_allocList+0x108>
  802322:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802325:	8b 40 04             	mov    0x4(%eax),%eax
  802328:	8b 55 08             	mov    0x8(%ebp),%edx
  80232b:	89 10                	mov    %edx,(%eax)
  80232d:	eb 08                	jmp    802337 <insert_sorted_allocList+0x110>
  80232f:	8b 45 08             	mov    0x8(%ebp),%eax
  802332:	a3 40 50 80 00       	mov    %eax,0x805040
  802337:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80233a:	8b 55 08             	mov    0x8(%ebp),%edx
  80233d:	89 50 04             	mov    %edx,0x4(%eax)
  802340:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802345:	40                   	inc    %eax
  802346:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80234b:	e9 60 01 00 00       	jmp    8024b0 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802350:	8b 45 08             	mov    0x8(%ebp),%eax
  802353:	8b 50 08             	mov    0x8(%eax),%edx
  802356:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802359:	8b 40 08             	mov    0x8(%eax),%eax
  80235c:	39 c2                	cmp    %eax,%edx
  80235e:	0f 82 4c 01 00 00    	jb     8024b0 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802364:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802368:	75 14                	jne    80237e <insert_sorted_allocList+0x157>
  80236a:	83 ec 04             	sub    $0x4,%esp
  80236d:	68 08 41 80 00       	push   $0x804108
  802372:	6a 73                	push   $0x73
  802374:	68 b7 40 80 00       	push   $0x8040b7
  802379:	e8 12 e0 ff ff       	call   800390 <_panic>
  80237e:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802384:	8b 45 08             	mov    0x8(%ebp),%eax
  802387:	89 50 04             	mov    %edx,0x4(%eax)
  80238a:	8b 45 08             	mov    0x8(%ebp),%eax
  80238d:	8b 40 04             	mov    0x4(%eax),%eax
  802390:	85 c0                	test   %eax,%eax
  802392:	74 0c                	je     8023a0 <insert_sorted_allocList+0x179>
  802394:	a1 44 50 80 00       	mov    0x805044,%eax
  802399:	8b 55 08             	mov    0x8(%ebp),%edx
  80239c:	89 10                	mov    %edx,(%eax)
  80239e:	eb 08                	jmp    8023a8 <insert_sorted_allocList+0x181>
  8023a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a3:	a3 40 50 80 00       	mov    %eax,0x805040
  8023a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ab:	a3 44 50 80 00       	mov    %eax,0x805044
  8023b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023b9:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8023be:	40                   	inc    %eax
  8023bf:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8023c4:	e9 e7 00 00 00       	jmp    8024b0 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8023c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8023cf:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8023d6:	a1 40 50 80 00       	mov    0x805040,%eax
  8023db:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023de:	e9 9d 00 00 00       	jmp    802480 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8023e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e6:	8b 00                	mov    (%eax),%eax
  8023e8:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8023eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ee:	8b 50 08             	mov    0x8(%eax),%edx
  8023f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f4:	8b 40 08             	mov    0x8(%eax),%eax
  8023f7:	39 c2                	cmp    %eax,%edx
  8023f9:	76 7d                	jbe    802478 <insert_sorted_allocList+0x251>
  8023fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fe:	8b 50 08             	mov    0x8(%eax),%edx
  802401:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802404:	8b 40 08             	mov    0x8(%eax),%eax
  802407:	39 c2                	cmp    %eax,%edx
  802409:	73 6d                	jae    802478 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  80240b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80240f:	74 06                	je     802417 <insert_sorted_allocList+0x1f0>
  802411:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802415:	75 14                	jne    80242b <insert_sorted_allocList+0x204>
  802417:	83 ec 04             	sub    $0x4,%esp
  80241a:	68 2c 41 80 00       	push   $0x80412c
  80241f:	6a 7f                	push   $0x7f
  802421:	68 b7 40 80 00       	push   $0x8040b7
  802426:	e8 65 df ff ff       	call   800390 <_panic>
  80242b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242e:	8b 10                	mov    (%eax),%edx
  802430:	8b 45 08             	mov    0x8(%ebp),%eax
  802433:	89 10                	mov    %edx,(%eax)
  802435:	8b 45 08             	mov    0x8(%ebp),%eax
  802438:	8b 00                	mov    (%eax),%eax
  80243a:	85 c0                	test   %eax,%eax
  80243c:	74 0b                	je     802449 <insert_sorted_allocList+0x222>
  80243e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802441:	8b 00                	mov    (%eax),%eax
  802443:	8b 55 08             	mov    0x8(%ebp),%edx
  802446:	89 50 04             	mov    %edx,0x4(%eax)
  802449:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244c:	8b 55 08             	mov    0x8(%ebp),%edx
  80244f:	89 10                	mov    %edx,(%eax)
  802451:	8b 45 08             	mov    0x8(%ebp),%eax
  802454:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802457:	89 50 04             	mov    %edx,0x4(%eax)
  80245a:	8b 45 08             	mov    0x8(%ebp),%eax
  80245d:	8b 00                	mov    (%eax),%eax
  80245f:	85 c0                	test   %eax,%eax
  802461:	75 08                	jne    80246b <insert_sorted_allocList+0x244>
  802463:	8b 45 08             	mov    0x8(%ebp),%eax
  802466:	a3 44 50 80 00       	mov    %eax,0x805044
  80246b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802470:	40                   	inc    %eax
  802471:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802476:	eb 39                	jmp    8024b1 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802478:	a1 48 50 80 00       	mov    0x805048,%eax
  80247d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802480:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802484:	74 07                	je     80248d <insert_sorted_allocList+0x266>
  802486:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802489:	8b 00                	mov    (%eax),%eax
  80248b:	eb 05                	jmp    802492 <insert_sorted_allocList+0x26b>
  80248d:	b8 00 00 00 00       	mov    $0x0,%eax
  802492:	a3 48 50 80 00       	mov    %eax,0x805048
  802497:	a1 48 50 80 00       	mov    0x805048,%eax
  80249c:	85 c0                	test   %eax,%eax
  80249e:	0f 85 3f ff ff ff    	jne    8023e3 <insert_sorted_allocList+0x1bc>
  8024a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024a8:	0f 85 35 ff ff ff    	jne    8023e3 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8024ae:	eb 01                	jmp    8024b1 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8024b0:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8024b1:	90                   	nop
  8024b2:	c9                   	leave  
  8024b3:	c3                   	ret    

008024b4 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8024b4:	55                   	push   %ebp
  8024b5:	89 e5                	mov    %esp,%ebp
  8024b7:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8024ba:	a1 38 51 80 00       	mov    0x805138,%eax
  8024bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024c2:	e9 85 01 00 00       	jmp    80264c <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8024c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8024cd:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024d0:	0f 82 6e 01 00 00    	jb     802644 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8024d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d9:	8b 40 0c             	mov    0xc(%eax),%eax
  8024dc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024df:	0f 85 8a 00 00 00    	jne    80256f <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8024e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024e9:	75 17                	jne    802502 <alloc_block_FF+0x4e>
  8024eb:	83 ec 04             	sub    $0x4,%esp
  8024ee:	68 60 41 80 00       	push   $0x804160
  8024f3:	68 93 00 00 00       	push   $0x93
  8024f8:	68 b7 40 80 00       	push   $0x8040b7
  8024fd:	e8 8e de ff ff       	call   800390 <_panic>
  802502:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802505:	8b 00                	mov    (%eax),%eax
  802507:	85 c0                	test   %eax,%eax
  802509:	74 10                	je     80251b <alloc_block_FF+0x67>
  80250b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250e:	8b 00                	mov    (%eax),%eax
  802510:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802513:	8b 52 04             	mov    0x4(%edx),%edx
  802516:	89 50 04             	mov    %edx,0x4(%eax)
  802519:	eb 0b                	jmp    802526 <alloc_block_FF+0x72>
  80251b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251e:	8b 40 04             	mov    0x4(%eax),%eax
  802521:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802526:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802529:	8b 40 04             	mov    0x4(%eax),%eax
  80252c:	85 c0                	test   %eax,%eax
  80252e:	74 0f                	je     80253f <alloc_block_FF+0x8b>
  802530:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802533:	8b 40 04             	mov    0x4(%eax),%eax
  802536:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802539:	8b 12                	mov    (%edx),%edx
  80253b:	89 10                	mov    %edx,(%eax)
  80253d:	eb 0a                	jmp    802549 <alloc_block_FF+0x95>
  80253f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802542:	8b 00                	mov    (%eax),%eax
  802544:	a3 38 51 80 00       	mov    %eax,0x805138
  802549:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802552:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802555:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80255c:	a1 44 51 80 00       	mov    0x805144,%eax
  802561:	48                   	dec    %eax
  802562:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802567:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256a:	e9 10 01 00 00       	jmp    80267f <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  80256f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802572:	8b 40 0c             	mov    0xc(%eax),%eax
  802575:	3b 45 08             	cmp    0x8(%ebp),%eax
  802578:	0f 86 c6 00 00 00    	jbe    802644 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80257e:	a1 48 51 80 00       	mov    0x805148,%eax
  802583:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802586:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802589:	8b 50 08             	mov    0x8(%eax),%edx
  80258c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80258f:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802592:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802595:	8b 55 08             	mov    0x8(%ebp),%edx
  802598:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80259b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80259f:	75 17                	jne    8025b8 <alloc_block_FF+0x104>
  8025a1:	83 ec 04             	sub    $0x4,%esp
  8025a4:	68 60 41 80 00       	push   $0x804160
  8025a9:	68 9b 00 00 00       	push   $0x9b
  8025ae:	68 b7 40 80 00       	push   $0x8040b7
  8025b3:	e8 d8 dd ff ff       	call   800390 <_panic>
  8025b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025bb:	8b 00                	mov    (%eax),%eax
  8025bd:	85 c0                	test   %eax,%eax
  8025bf:	74 10                	je     8025d1 <alloc_block_FF+0x11d>
  8025c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025c4:	8b 00                	mov    (%eax),%eax
  8025c6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025c9:	8b 52 04             	mov    0x4(%edx),%edx
  8025cc:	89 50 04             	mov    %edx,0x4(%eax)
  8025cf:	eb 0b                	jmp    8025dc <alloc_block_FF+0x128>
  8025d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025d4:	8b 40 04             	mov    0x4(%eax),%eax
  8025d7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8025dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025df:	8b 40 04             	mov    0x4(%eax),%eax
  8025e2:	85 c0                	test   %eax,%eax
  8025e4:	74 0f                	je     8025f5 <alloc_block_FF+0x141>
  8025e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025e9:	8b 40 04             	mov    0x4(%eax),%eax
  8025ec:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025ef:	8b 12                	mov    (%edx),%edx
  8025f1:	89 10                	mov    %edx,(%eax)
  8025f3:	eb 0a                	jmp    8025ff <alloc_block_FF+0x14b>
  8025f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025f8:	8b 00                	mov    (%eax),%eax
  8025fa:	a3 48 51 80 00       	mov    %eax,0x805148
  8025ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802602:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802608:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80260b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802612:	a1 54 51 80 00       	mov    0x805154,%eax
  802617:	48                   	dec    %eax
  802618:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  80261d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802620:	8b 50 08             	mov    0x8(%eax),%edx
  802623:	8b 45 08             	mov    0x8(%ebp),%eax
  802626:	01 c2                	add    %eax,%edx
  802628:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262b:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  80262e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802631:	8b 40 0c             	mov    0xc(%eax),%eax
  802634:	2b 45 08             	sub    0x8(%ebp),%eax
  802637:	89 c2                	mov    %eax,%edx
  802639:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263c:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  80263f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802642:	eb 3b                	jmp    80267f <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802644:	a1 40 51 80 00       	mov    0x805140,%eax
  802649:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80264c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802650:	74 07                	je     802659 <alloc_block_FF+0x1a5>
  802652:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802655:	8b 00                	mov    (%eax),%eax
  802657:	eb 05                	jmp    80265e <alloc_block_FF+0x1aa>
  802659:	b8 00 00 00 00       	mov    $0x0,%eax
  80265e:	a3 40 51 80 00       	mov    %eax,0x805140
  802663:	a1 40 51 80 00       	mov    0x805140,%eax
  802668:	85 c0                	test   %eax,%eax
  80266a:	0f 85 57 fe ff ff    	jne    8024c7 <alloc_block_FF+0x13>
  802670:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802674:	0f 85 4d fe ff ff    	jne    8024c7 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  80267a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80267f:	c9                   	leave  
  802680:	c3                   	ret    

00802681 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802681:	55                   	push   %ebp
  802682:	89 e5                	mov    %esp,%ebp
  802684:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802687:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80268e:	a1 38 51 80 00       	mov    0x805138,%eax
  802693:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802696:	e9 df 00 00 00       	jmp    80277a <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  80269b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269e:	8b 40 0c             	mov    0xc(%eax),%eax
  8026a1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026a4:	0f 82 c8 00 00 00    	jb     802772 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8026aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ad:	8b 40 0c             	mov    0xc(%eax),%eax
  8026b0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026b3:	0f 85 8a 00 00 00    	jne    802743 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8026b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026bd:	75 17                	jne    8026d6 <alloc_block_BF+0x55>
  8026bf:	83 ec 04             	sub    $0x4,%esp
  8026c2:	68 60 41 80 00       	push   $0x804160
  8026c7:	68 b7 00 00 00       	push   $0xb7
  8026cc:	68 b7 40 80 00       	push   $0x8040b7
  8026d1:	e8 ba dc ff ff       	call   800390 <_panic>
  8026d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d9:	8b 00                	mov    (%eax),%eax
  8026db:	85 c0                	test   %eax,%eax
  8026dd:	74 10                	je     8026ef <alloc_block_BF+0x6e>
  8026df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e2:	8b 00                	mov    (%eax),%eax
  8026e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026e7:	8b 52 04             	mov    0x4(%edx),%edx
  8026ea:	89 50 04             	mov    %edx,0x4(%eax)
  8026ed:	eb 0b                	jmp    8026fa <alloc_block_BF+0x79>
  8026ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f2:	8b 40 04             	mov    0x4(%eax),%eax
  8026f5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8026fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fd:	8b 40 04             	mov    0x4(%eax),%eax
  802700:	85 c0                	test   %eax,%eax
  802702:	74 0f                	je     802713 <alloc_block_BF+0x92>
  802704:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802707:	8b 40 04             	mov    0x4(%eax),%eax
  80270a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80270d:	8b 12                	mov    (%edx),%edx
  80270f:	89 10                	mov    %edx,(%eax)
  802711:	eb 0a                	jmp    80271d <alloc_block_BF+0x9c>
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
			   return currentMemBlock;
  80273b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273e:	e9 4d 01 00 00       	jmp    802890 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802743:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802746:	8b 40 0c             	mov    0xc(%eax),%eax
  802749:	3b 45 08             	cmp    0x8(%ebp),%eax
  80274c:	76 24                	jbe    802772 <alloc_block_BF+0xf1>
  80274e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802751:	8b 40 0c             	mov    0xc(%eax),%eax
  802754:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802757:	73 19                	jae    802772 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802759:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802760:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802763:	8b 40 0c             	mov    0xc(%eax),%eax
  802766:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802769:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276c:	8b 40 08             	mov    0x8(%eax),%eax
  80276f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802772:	a1 40 51 80 00       	mov    0x805140,%eax
  802777:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80277a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80277e:	74 07                	je     802787 <alloc_block_BF+0x106>
  802780:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802783:	8b 00                	mov    (%eax),%eax
  802785:	eb 05                	jmp    80278c <alloc_block_BF+0x10b>
  802787:	b8 00 00 00 00       	mov    $0x0,%eax
  80278c:	a3 40 51 80 00       	mov    %eax,0x805140
  802791:	a1 40 51 80 00       	mov    0x805140,%eax
  802796:	85 c0                	test   %eax,%eax
  802798:	0f 85 fd fe ff ff    	jne    80269b <alloc_block_BF+0x1a>
  80279e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027a2:	0f 85 f3 fe ff ff    	jne    80269b <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8027a8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8027ac:	0f 84 d9 00 00 00    	je     80288b <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8027b2:	a1 48 51 80 00       	mov    0x805148,%eax
  8027b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8027ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027bd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027c0:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8027c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8027c9:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8027cc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8027d0:	75 17                	jne    8027e9 <alloc_block_BF+0x168>
  8027d2:	83 ec 04             	sub    $0x4,%esp
  8027d5:	68 60 41 80 00       	push   $0x804160
  8027da:	68 c7 00 00 00       	push   $0xc7
  8027df:	68 b7 40 80 00       	push   $0x8040b7
  8027e4:	e8 a7 db ff ff       	call   800390 <_panic>
  8027e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027ec:	8b 00                	mov    (%eax),%eax
  8027ee:	85 c0                	test   %eax,%eax
  8027f0:	74 10                	je     802802 <alloc_block_BF+0x181>
  8027f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027f5:	8b 00                	mov    (%eax),%eax
  8027f7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027fa:	8b 52 04             	mov    0x4(%edx),%edx
  8027fd:	89 50 04             	mov    %edx,0x4(%eax)
  802800:	eb 0b                	jmp    80280d <alloc_block_BF+0x18c>
  802802:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802805:	8b 40 04             	mov    0x4(%eax),%eax
  802808:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80280d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802810:	8b 40 04             	mov    0x4(%eax),%eax
  802813:	85 c0                	test   %eax,%eax
  802815:	74 0f                	je     802826 <alloc_block_BF+0x1a5>
  802817:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80281a:	8b 40 04             	mov    0x4(%eax),%eax
  80281d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802820:	8b 12                	mov    (%edx),%edx
  802822:	89 10                	mov    %edx,(%eax)
  802824:	eb 0a                	jmp    802830 <alloc_block_BF+0x1af>
  802826:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802829:	8b 00                	mov    (%eax),%eax
  80282b:	a3 48 51 80 00       	mov    %eax,0x805148
  802830:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802833:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802839:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80283c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802843:	a1 54 51 80 00       	mov    0x805154,%eax
  802848:	48                   	dec    %eax
  802849:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  80284e:	83 ec 08             	sub    $0x8,%esp
  802851:	ff 75 ec             	pushl  -0x14(%ebp)
  802854:	68 38 51 80 00       	push   $0x805138
  802859:	e8 71 f9 ff ff       	call   8021cf <find_block>
  80285e:	83 c4 10             	add    $0x10,%esp
  802861:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802864:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802867:	8b 50 08             	mov    0x8(%eax),%edx
  80286a:	8b 45 08             	mov    0x8(%ebp),%eax
  80286d:	01 c2                	add    %eax,%edx
  80286f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802872:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802875:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802878:	8b 40 0c             	mov    0xc(%eax),%eax
  80287b:	2b 45 08             	sub    0x8(%ebp),%eax
  80287e:	89 c2                	mov    %eax,%edx
  802880:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802883:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802886:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802889:	eb 05                	jmp    802890 <alloc_block_BF+0x20f>
	}
	return NULL;
  80288b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802890:	c9                   	leave  
  802891:	c3                   	ret    

00802892 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802892:	55                   	push   %ebp
  802893:	89 e5                	mov    %esp,%ebp
  802895:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802898:	a1 28 50 80 00       	mov    0x805028,%eax
  80289d:	85 c0                	test   %eax,%eax
  80289f:	0f 85 de 01 00 00    	jne    802a83 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8028a5:	a1 38 51 80 00       	mov    0x805138,%eax
  8028aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028ad:	e9 9e 01 00 00       	jmp    802a50 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8028b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b5:	8b 40 0c             	mov    0xc(%eax),%eax
  8028b8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028bb:	0f 82 87 01 00 00    	jb     802a48 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8028c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c4:	8b 40 0c             	mov    0xc(%eax),%eax
  8028c7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028ca:	0f 85 95 00 00 00    	jne    802965 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8028d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028d4:	75 17                	jne    8028ed <alloc_block_NF+0x5b>
  8028d6:	83 ec 04             	sub    $0x4,%esp
  8028d9:	68 60 41 80 00       	push   $0x804160
  8028de:	68 e0 00 00 00       	push   $0xe0
  8028e3:	68 b7 40 80 00       	push   $0x8040b7
  8028e8:	e8 a3 da ff ff       	call   800390 <_panic>
  8028ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f0:	8b 00                	mov    (%eax),%eax
  8028f2:	85 c0                	test   %eax,%eax
  8028f4:	74 10                	je     802906 <alloc_block_NF+0x74>
  8028f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f9:	8b 00                	mov    (%eax),%eax
  8028fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028fe:	8b 52 04             	mov    0x4(%edx),%edx
  802901:	89 50 04             	mov    %edx,0x4(%eax)
  802904:	eb 0b                	jmp    802911 <alloc_block_NF+0x7f>
  802906:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802909:	8b 40 04             	mov    0x4(%eax),%eax
  80290c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802911:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802914:	8b 40 04             	mov    0x4(%eax),%eax
  802917:	85 c0                	test   %eax,%eax
  802919:	74 0f                	je     80292a <alloc_block_NF+0x98>
  80291b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291e:	8b 40 04             	mov    0x4(%eax),%eax
  802921:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802924:	8b 12                	mov    (%edx),%edx
  802926:	89 10                	mov    %edx,(%eax)
  802928:	eb 0a                	jmp    802934 <alloc_block_NF+0xa2>
  80292a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292d:	8b 00                	mov    (%eax),%eax
  80292f:	a3 38 51 80 00       	mov    %eax,0x805138
  802934:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802937:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80293d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802940:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802947:	a1 44 51 80 00       	mov    0x805144,%eax
  80294c:	48                   	dec    %eax
  80294d:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802952:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802955:	8b 40 08             	mov    0x8(%eax),%eax
  802958:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  80295d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802960:	e9 f8 04 00 00       	jmp    802e5d <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802965:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802968:	8b 40 0c             	mov    0xc(%eax),%eax
  80296b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80296e:	0f 86 d4 00 00 00    	jbe    802a48 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802974:	a1 48 51 80 00       	mov    0x805148,%eax
  802979:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  80297c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297f:	8b 50 08             	mov    0x8(%eax),%edx
  802982:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802985:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802988:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80298b:	8b 55 08             	mov    0x8(%ebp),%edx
  80298e:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802991:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802995:	75 17                	jne    8029ae <alloc_block_NF+0x11c>
  802997:	83 ec 04             	sub    $0x4,%esp
  80299a:	68 60 41 80 00       	push   $0x804160
  80299f:	68 e9 00 00 00       	push   $0xe9
  8029a4:	68 b7 40 80 00       	push   $0x8040b7
  8029a9:	e8 e2 d9 ff ff       	call   800390 <_panic>
  8029ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029b1:	8b 00                	mov    (%eax),%eax
  8029b3:	85 c0                	test   %eax,%eax
  8029b5:	74 10                	je     8029c7 <alloc_block_NF+0x135>
  8029b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ba:	8b 00                	mov    (%eax),%eax
  8029bc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029bf:	8b 52 04             	mov    0x4(%edx),%edx
  8029c2:	89 50 04             	mov    %edx,0x4(%eax)
  8029c5:	eb 0b                	jmp    8029d2 <alloc_block_NF+0x140>
  8029c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ca:	8b 40 04             	mov    0x4(%eax),%eax
  8029cd:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8029d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d5:	8b 40 04             	mov    0x4(%eax),%eax
  8029d8:	85 c0                	test   %eax,%eax
  8029da:	74 0f                	je     8029eb <alloc_block_NF+0x159>
  8029dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029df:	8b 40 04             	mov    0x4(%eax),%eax
  8029e2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029e5:	8b 12                	mov    (%edx),%edx
  8029e7:	89 10                	mov    %edx,(%eax)
  8029e9:	eb 0a                	jmp    8029f5 <alloc_block_NF+0x163>
  8029eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ee:	8b 00                	mov    (%eax),%eax
  8029f0:	a3 48 51 80 00       	mov    %eax,0x805148
  8029f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a01:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a08:	a1 54 51 80 00       	mov    0x805154,%eax
  802a0d:	48                   	dec    %eax
  802a0e:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802a13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a16:	8b 40 08             	mov    0x8(%eax),%eax
  802a19:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802a1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a21:	8b 50 08             	mov    0x8(%eax),%edx
  802a24:	8b 45 08             	mov    0x8(%ebp),%eax
  802a27:	01 c2                	add    %eax,%edx
  802a29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2c:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802a2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a32:	8b 40 0c             	mov    0xc(%eax),%eax
  802a35:	2b 45 08             	sub    0x8(%ebp),%eax
  802a38:	89 c2                	mov    %eax,%edx
  802a3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3d:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802a40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a43:	e9 15 04 00 00       	jmp    802e5d <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802a48:	a1 40 51 80 00       	mov    0x805140,%eax
  802a4d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a50:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a54:	74 07                	je     802a5d <alloc_block_NF+0x1cb>
  802a56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a59:	8b 00                	mov    (%eax),%eax
  802a5b:	eb 05                	jmp    802a62 <alloc_block_NF+0x1d0>
  802a5d:	b8 00 00 00 00       	mov    $0x0,%eax
  802a62:	a3 40 51 80 00       	mov    %eax,0x805140
  802a67:	a1 40 51 80 00       	mov    0x805140,%eax
  802a6c:	85 c0                	test   %eax,%eax
  802a6e:	0f 85 3e fe ff ff    	jne    8028b2 <alloc_block_NF+0x20>
  802a74:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a78:	0f 85 34 fe ff ff    	jne    8028b2 <alloc_block_NF+0x20>
  802a7e:	e9 d5 03 00 00       	jmp    802e58 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a83:	a1 38 51 80 00       	mov    0x805138,%eax
  802a88:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a8b:	e9 b1 01 00 00       	jmp    802c41 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802a90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a93:	8b 50 08             	mov    0x8(%eax),%edx
  802a96:	a1 28 50 80 00       	mov    0x805028,%eax
  802a9b:	39 c2                	cmp    %eax,%edx
  802a9d:	0f 82 96 01 00 00    	jb     802c39 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802aa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa6:	8b 40 0c             	mov    0xc(%eax),%eax
  802aa9:	3b 45 08             	cmp    0x8(%ebp),%eax
  802aac:	0f 82 87 01 00 00    	jb     802c39 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802ab2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab5:	8b 40 0c             	mov    0xc(%eax),%eax
  802ab8:	3b 45 08             	cmp    0x8(%ebp),%eax
  802abb:	0f 85 95 00 00 00    	jne    802b56 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802ac1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ac5:	75 17                	jne    802ade <alloc_block_NF+0x24c>
  802ac7:	83 ec 04             	sub    $0x4,%esp
  802aca:	68 60 41 80 00       	push   $0x804160
  802acf:	68 fc 00 00 00       	push   $0xfc
  802ad4:	68 b7 40 80 00       	push   $0x8040b7
  802ad9:	e8 b2 d8 ff ff       	call   800390 <_panic>
  802ade:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae1:	8b 00                	mov    (%eax),%eax
  802ae3:	85 c0                	test   %eax,%eax
  802ae5:	74 10                	je     802af7 <alloc_block_NF+0x265>
  802ae7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aea:	8b 00                	mov    (%eax),%eax
  802aec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802aef:	8b 52 04             	mov    0x4(%edx),%edx
  802af2:	89 50 04             	mov    %edx,0x4(%eax)
  802af5:	eb 0b                	jmp    802b02 <alloc_block_NF+0x270>
  802af7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afa:	8b 40 04             	mov    0x4(%eax),%eax
  802afd:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b05:	8b 40 04             	mov    0x4(%eax),%eax
  802b08:	85 c0                	test   %eax,%eax
  802b0a:	74 0f                	je     802b1b <alloc_block_NF+0x289>
  802b0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0f:	8b 40 04             	mov    0x4(%eax),%eax
  802b12:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b15:	8b 12                	mov    (%edx),%edx
  802b17:	89 10                	mov    %edx,(%eax)
  802b19:	eb 0a                	jmp    802b25 <alloc_block_NF+0x293>
  802b1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1e:	8b 00                	mov    (%eax),%eax
  802b20:	a3 38 51 80 00       	mov    %eax,0x805138
  802b25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b28:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b31:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b38:	a1 44 51 80 00       	mov    0x805144,%eax
  802b3d:	48                   	dec    %eax
  802b3e:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802b43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b46:	8b 40 08             	mov    0x8(%eax),%eax
  802b49:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802b4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b51:	e9 07 03 00 00       	jmp    802e5d <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802b56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b59:	8b 40 0c             	mov    0xc(%eax),%eax
  802b5c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b5f:	0f 86 d4 00 00 00    	jbe    802c39 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b65:	a1 48 51 80 00       	mov    0x805148,%eax
  802b6a:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802b6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b70:	8b 50 08             	mov    0x8(%eax),%edx
  802b73:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b76:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802b79:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b7c:	8b 55 08             	mov    0x8(%ebp),%edx
  802b7f:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b82:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802b86:	75 17                	jne    802b9f <alloc_block_NF+0x30d>
  802b88:	83 ec 04             	sub    $0x4,%esp
  802b8b:	68 60 41 80 00       	push   $0x804160
  802b90:	68 04 01 00 00       	push   $0x104
  802b95:	68 b7 40 80 00       	push   $0x8040b7
  802b9a:	e8 f1 d7 ff ff       	call   800390 <_panic>
  802b9f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ba2:	8b 00                	mov    (%eax),%eax
  802ba4:	85 c0                	test   %eax,%eax
  802ba6:	74 10                	je     802bb8 <alloc_block_NF+0x326>
  802ba8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bab:	8b 00                	mov    (%eax),%eax
  802bad:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802bb0:	8b 52 04             	mov    0x4(%edx),%edx
  802bb3:	89 50 04             	mov    %edx,0x4(%eax)
  802bb6:	eb 0b                	jmp    802bc3 <alloc_block_NF+0x331>
  802bb8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bbb:	8b 40 04             	mov    0x4(%eax),%eax
  802bbe:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802bc3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bc6:	8b 40 04             	mov    0x4(%eax),%eax
  802bc9:	85 c0                	test   %eax,%eax
  802bcb:	74 0f                	je     802bdc <alloc_block_NF+0x34a>
  802bcd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bd0:	8b 40 04             	mov    0x4(%eax),%eax
  802bd3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802bd6:	8b 12                	mov    (%edx),%edx
  802bd8:	89 10                	mov    %edx,(%eax)
  802bda:	eb 0a                	jmp    802be6 <alloc_block_NF+0x354>
  802bdc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bdf:	8b 00                	mov    (%eax),%eax
  802be1:	a3 48 51 80 00       	mov    %eax,0x805148
  802be6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802be9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bf2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bf9:	a1 54 51 80 00       	mov    0x805154,%eax
  802bfe:	48                   	dec    %eax
  802bff:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802c04:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c07:	8b 40 08             	mov    0x8(%eax),%eax
  802c0a:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802c0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c12:	8b 50 08             	mov    0x8(%eax),%edx
  802c15:	8b 45 08             	mov    0x8(%ebp),%eax
  802c18:	01 c2                	add    %eax,%edx
  802c1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1d:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802c20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c23:	8b 40 0c             	mov    0xc(%eax),%eax
  802c26:	2b 45 08             	sub    0x8(%ebp),%eax
  802c29:	89 c2                	mov    %eax,%edx
  802c2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2e:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802c31:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c34:	e9 24 02 00 00       	jmp    802e5d <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c39:	a1 40 51 80 00       	mov    0x805140,%eax
  802c3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c41:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c45:	74 07                	je     802c4e <alloc_block_NF+0x3bc>
  802c47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4a:	8b 00                	mov    (%eax),%eax
  802c4c:	eb 05                	jmp    802c53 <alloc_block_NF+0x3c1>
  802c4e:	b8 00 00 00 00       	mov    $0x0,%eax
  802c53:	a3 40 51 80 00       	mov    %eax,0x805140
  802c58:	a1 40 51 80 00       	mov    0x805140,%eax
  802c5d:	85 c0                	test   %eax,%eax
  802c5f:	0f 85 2b fe ff ff    	jne    802a90 <alloc_block_NF+0x1fe>
  802c65:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c69:	0f 85 21 fe ff ff    	jne    802a90 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c6f:	a1 38 51 80 00       	mov    0x805138,%eax
  802c74:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c77:	e9 ae 01 00 00       	jmp    802e2a <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802c7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7f:	8b 50 08             	mov    0x8(%eax),%edx
  802c82:	a1 28 50 80 00       	mov    0x805028,%eax
  802c87:	39 c2                	cmp    %eax,%edx
  802c89:	0f 83 93 01 00 00    	jae    802e22 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802c8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c92:	8b 40 0c             	mov    0xc(%eax),%eax
  802c95:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c98:	0f 82 84 01 00 00    	jb     802e22 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802c9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ca4:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ca7:	0f 85 95 00 00 00    	jne    802d42 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802cad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cb1:	75 17                	jne    802cca <alloc_block_NF+0x438>
  802cb3:	83 ec 04             	sub    $0x4,%esp
  802cb6:	68 60 41 80 00       	push   $0x804160
  802cbb:	68 14 01 00 00       	push   $0x114
  802cc0:	68 b7 40 80 00       	push   $0x8040b7
  802cc5:	e8 c6 d6 ff ff       	call   800390 <_panic>
  802cca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ccd:	8b 00                	mov    (%eax),%eax
  802ccf:	85 c0                	test   %eax,%eax
  802cd1:	74 10                	je     802ce3 <alloc_block_NF+0x451>
  802cd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd6:	8b 00                	mov    (%eax),%eax
  802cd8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cdb:	8b 52 04             	mov    0x4(%edx),%edx
  802cde:	89 50 04             	mov    %edx,0x4(%eax)
  802ce1:	eb 0b                	jmp    802cee <alloc_block_NF+0x45c>
  802ce3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce6:	8b 40 04             	mov    0x4(%eax),%eax
  802ce9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802cee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf1:	8b 40 04             	mov    0x4(%eax),%eax
  802cf4:	85 c0                	test   %eax,%eax
  802cf6:	74 0f                	je     802d07 <alloc_block_NF+0x475>
  802cf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfb:	8b 40 04             	mov    0x4(%eax),%eax
  802cfe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d01:	8b 12                	mov    (%edx),%edx
  802d03:	89 10                	mov    %edx,(%eax)
  802d05:	eb 0a                	jmp    802d11 <alloc_block_NF+0x47f>
  802d07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0a:	8b 00                	mov    (%eax),%eax
  802d0c:	a3 38 51 80 00       	mov    %eax,0x805138
  802d11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d14:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d24:	a1 44 51 80 00       	mov    0x805144,%eax
  802d29:	48                   	dec    %eax
  802d2a:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802d2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d32:	8b 40 08             	mov    0x8(%eax),%eax
  802d35:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802d3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3d:	e9 1b 01 00 00       	jmp    802e5d <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802d42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d45:	8b 40 0c             	mov    0xc(%eax),%eax
  802d48:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d4b:	0f 86 d1 00 00 00    	jbe    802e22 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802d51:	a1 48 51 80 00       	mov    0x805148,%eax
  802d56:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802d59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5c:	8b 50 08             	mov    0x8(%eax),%edx
  802d5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d62:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802d65:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d68:	8b 55 08             	mov    0x8(%ebp),%edx
  802d6b:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802d6e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802d72:	75 17                	jne    802d8b <alloc_block_NF+0x4f9>
  802d74:	83 ec 04             	sub    $0x4,%esp
  802d77:	68 60 41 80 00       	push   $0x804160
  802d7c:	68 1c 01 00 00       	push   $0x11c
  802d81:	68 b7 40 80 00       	push   $0x8040b7
  802d86:	e8 05 d6 ff ff       	call   800390 <_panic>
  802d8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d8e:	8b 00                	mov    (%eax),%eax
  802d90:	85 c0                	test   %eax,%eax
  802d92:	74 10                	je     802da4 <alloc_block_NF+0x512>
  802d94:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d97:	8b 00                	mov    (%eax),%eax
  802d99:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d9c:	8b 52 04             	mov    0x4(%edx),%edx
  802d9f:	89 50 04             	mov    %edx,0x4(%eax)
  802da2:	eb 0b                	jmp    802daf <alloc_block_NF+0x51d>
  802da4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802da7:	8b 40 04             	mov    0x4(%eax),%eax
  802daa:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802daf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802db2:	8b 40 04             	mov    0x4(%eax),%eax
  802db5:	85 c0                	test   %eax,%eax
  802db7:	74 0f                	je     802dc8 <alloc_block_NF+0x536>
  802db9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dbc:	8b 40 04             	mov    0x4(%eax),%eax
  802dbf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802dc2:	8b 12                	mov    (%edx),%edx
  802dc4:	89 10                	mov    %edx,(%eax)
  802dc6:	eb 0a                	jmp    802dd2 <alloc_block_NF+0x540>
  802dc8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dcb:	8b 00                	mov    (%eax),%eax
  802dcd:	a3 48 51 80 00       	mov    %eax,0x805148
  802dd2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dd5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ddb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dde:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802de5:	a1 54 51 80 00       	mov    0x805154,%eax
  802dea:	48                   	dec    %eax
  802deb:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802df0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802df3:	8b 40 08             	mov    0x8(%eax),%eax
  802df6:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802dfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfe:	8b 50 08             	mov    0x8(%eax),%edx
  802e01:	8b 45 08             	mov    0x8(%ebp),%eax
  802e04:	01 c2                	add    %eax,%edx
  802e06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e09:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802e0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0f:	8b 40 0c             	mov    0xc(%eax),%eax
  802e12:	2b 45 08             	sub    0x8(%ebp),%eax
  802e15:	89 c2                	mov    %eax,%edx
  802e17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1a:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802e1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e20:	eb 3b                	jmp    802e5d <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802e22:	a1 40 51 80 00       	mov    0x805140,%eax
  802e27:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e2a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e2e:	74 07                	je     802e37 <alloc_block_NF+0x5a5>
  802e30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e33:	8b 00                	mov    (%eax),%eax
  802e35:	eb 05                	jmp    802e3c <alloc_block_NF+0x5aa>
  802e37:	b8 00 00 00 00       	mov    $0x0,%eax
  802e3c:	a3 40 51 80 00       	mov    %eax,0x805140
  802e41:	a1 40 51 80 00       	mov    0x805140,%eax
  802e46:	85 c0                	test   %eax,%eax
  802e48:	0f 85 2e fe ff ff    	jne    802c7c <alloc_block_NF+0x3ea>
  802e4e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e52:	0f 85 24 fe ff ff    	jne    802c7c <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802e58:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e5d:	c9                   	leave  
  802e5e:	c3                   	ret    

00802e5f <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802e5f:	55                   	push   %ebp
  802e60:	89 e5                	mov    %esp,%ebp
  802e62:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802e65:	a1 38 51 80 00       	mov    0x805138,%eax
  802e6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802e6d:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802e72:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802e75:	a1 38 51 80 00       	mov    0x805138,%eax
  802e7a:	85 c0                	test   %eax,%eax
  802e7c:	74 14                	je     802e92 <insert_sorted_with_merge_freeList+0x33>
  802e7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e81:	8b 50 08             	mov    0x8(%eax),%edx
  802e84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e87:	8b 40 08             	mov    0x8(%eax),%eax
  802e8a:	39 c2                	cmp    %eax,%edx
  802e8c:	0f 87 9b 01 00 00    	ja     80302d <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802e92:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e96:	75 17                	jne    802eaf <insert_sorted_with_merge_freeList+0x50>
  802e98:	83 ec 04             	sub    $0x4,%esp
  802e9b:	68 94 40 80 00       	push   $0x804094
  802ea0:	68 38 01 00 00       	push   $0x138
  802ea5:	68 b7 40 80 00       	push   $0x8040b7
  802eaa:	e8 e1 d4 ff ff       	call   800390 <_panic>
  802eaf:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb8:	89 10                	mov    %edx,(%eax)
  802eba:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebd:	8b 00                	mov    (%eax),%eax
  802ebf:	85 c0                	test   %eax,%eax
  802ec1:	74 0d                	je     802ed0 <insert_sorted_with_merge_freeList+0x71>
  802ec3:	a1 38 51 80 00       	mov    0x805138,%eax
  802ec8:	8b 55 08             	mov    0x8(%ebp),%edx
  802ecb:	89 50 04             	mov    %edx,0x4(%eax)
  802ece:	eb 08                	jmp    802ed8 <insert_sorted_with_merge_freeList+0x79>
  802ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  802edb:	a3 38 51 80 00       	mov    %eax,0x805138
  802ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eea:	a1 44 51 80 00       	mov    0x805144,%eax
  802eef:	40                   	inc    %eax
  802ef0:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802ef5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ef9:	0f 84 a8 06 00 00    	je     8035a7 <insert_sorted_with_merge_freeList+0x748>
  802eff:	8b 45 08             	mov    0x8(%ebp),%eax
  802f02:	8b 50 08             	mov    0x8(%eax),%edx
  802f05:	8b 45 08             	mov    0x8(%ebp),%eax
  802f08:	8b 40 0c             	mov    0xc(%eax),%eax
  802f0b:	01 c2                	add    %eax,%edx
  802f0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f10:	8b 40 08             	mov    0x8(%eax),%eax
  802f13:	39 c2                	cmp    %eax,%edx
  802f15:	0f 85 8c 06 00 00    	jne    8035a7 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1e:	8b 50 0c             	mov    0xc(%eax),%edx
  802f21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f24:	8b 40 0c             	mov    0xc(%eax),%eax
  802f27:	01 c2                	add    %eax,%edx
  802f29:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2c:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802f2f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f33:	75 17                	jne    802f4c <insert_sorted_with_merge_freeList+0xed>
  802f35:	83 ec 04             	sub    $0x4,%esp
  802f38:	68 60 41 80 00       	push   $0x804160
  802f3d:	68 3c 01 00 00       	push   $0x13c
  802f42:	68 b7 40 80 00       	push   $0x8040b7
  802f47:	e8 44 d4 ff ff       	call   800390 <_panic>
  802f4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f4f:	8b 00                	mov    (%eax),%eax
  802f51:	85 c0                	test   %eax,%eax
  802f53:	74 10                	je     802f65 <insert_sorted_with_merge_freeList+0x106>
  802f55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f58:	8b 00                	mov    (%eax),%eax
  802f5a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f5d:	8b 52 04             	mov    0x4(%edx),%edx
  802f60:	89 50 04             	mov    %edx,0x4(%eax)
  802f63:	eb 0b                	jmp    802f70 <insert_sorted_with_merge_freeList+0x111>
  802f65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f68:	8b 40 04             	mov    0x4(%eax),%eax
  802f6b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f73:	8b 40 04             	mov    0x4(%eax),%eax
  802f76:	85 c0                	test   %eax,%eax
  802f78:	74 0f                	je     802f89 <insert_sorted_with_merge_freeList+0x12a>
  802f7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f7d:	8b 40 04             	mov    0x4(%eax),%eax
  802f80:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f83:	8b 12                	mov    (%edx),%edx
  802f85:	89 10                	mov    %edx,(%eax)
  802f87:	eb 0a                	jmp    802f93 <insert_sorted_with_merge_freeList+0x134>
  802f89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f8c:	8b 00                	mov    (%eax),%eax
  802f8e:	a3 38 51 80 00       	mov    %eax,0x805138
  802f93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f96:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f9f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fa6:	a1 44 51 80 00       	mov    0x805144,%eax
  802fab:	48                   	dec    %eax
  802fac:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802fb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fb4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802fbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fbe:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802fc5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802fc9:	75 17                	jne    802fe2 <insert_sorted_with_merge_freeList+0x183>
  802fcb:	83 ec 04             	sub    $0x4,%esp
  802fce:	68 94 40 80 00       	push   $0x804094
  802fd3:	68 3f 01 00 00       	push   $0x13f
  802fd8:	68 b7 40 80 00       	push   $0x8040b7
  802fdd:	e8 ae d3 ff ff       	call   800390 <_panic>
  802fe2:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802fe8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802feb:	89 10                	mov    %edx,(%eax)
  802fed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ff0:	8b 00                	mov    (%eax),%eax
  802ff2:	85 c0                	test   %eax,%eax
  802ff4:	74 0d                	je     803003 <insert_sorted_with_merge_freeList+0x1a4>
  802ff6:	a1 48 51 80 00       	mov    0x805148,%eax
  802ffb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ffe:	89 50 04             	mov    %edx,0x4(%eax)
  803001:	eb 08                	jmp    80300b <insert_sorted_with_merge_freeList+0x1ac>
  803003:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803006:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80300b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80300e:	a3 48 51 80 00       	mov    %eax,0x805148
  803013:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803016:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80301d:	a1 54 51 80 00       	mov    0x805154,%eax
  803022:	40                   	inc    %eax
  803023:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803028:	e9 7a 05 00 00       	jmp    8035a7 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  80302d:	8b 45 08             	mov    0x8(%ebp),%eax
  803030:	8b 50 08             	mov    0x8(%eax),%edx
  803033:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803036:	8b 40 08             	mov    0x8(%eax),%eax
  803039:	39 c2                	cmp    %eax,%edx
  80303b:	0f 82 14 01 00 00    	jb     803155 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  803041:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803044:	8b 50 08             	mov    0x8(%eax),%edx
  803047:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80304a:	8b 40 0c             	mov    0xc(%eax),%eax
  80304d:	01 c2                	add    %eax,%edx
  80304f:	8b 45 08             	mov    0x8(%ebp),%eax
  803052:	8b 40 08             	mov    0x8(%eax),%eax
  803055:	39 c2                	cmp    %eax,%edx
  803057:	0f 85 90 00 00 00    	jne    8030ed <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  80305d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803060:	8b 50 0c             	mov    0xc(%eax),%edx
  803063:	8b 45 08             	mov    0x8(%ebp),%eax
  803066:	8b 40 0c             	mov    0xc(%eax),%eax
  803069:	01 c2                	add    %eax,%edx
  80306b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80306e:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  803071:	8b 45 08             	mov    0x8(%ebp),%eax
  803074:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  80307b:	8b 45 08             	mov    0x8(%ebp),%eax
  80307e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803085:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803089:	75 17                	jne    8030a2 <insert_sorted_with_merge_freeList+0x243>
  80308b:	83 ec 04             	sub    $0x4,%esp
  80308e:	68 94 40 80 00       	push   $0x804094
  803093:	68 49 01 00 00       	push   $0x149
  803098:	68 b7 40 80 00       	push   $0x8040b7
  80309d:	e8 ee d2 ff ff       	call   800390 <_panic>
  8030a2:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8030a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ab:	89 10                	mov    %edx,(%eax)
  8030ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b0:	8b 00                	mov    (%eax),%eax
  8030b2:	85 c0                	test   %eax,%eax
  8030b4:	74 0d                	je     8030c3 <insert_sorted_with_merge_freeList+0x264>
  8030b6:	a1 48 51 80 00       	mov    0x805148,%eax
  8030bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8030be:	89 50 04             	mov    %edx,0x4(%eax)
  8030c1:	eb 08                	jmp    8030cb <insert_sorted_with_merge_freeList+0x26c>
  8030c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ce:	a3 48 51 80 00       	mov    %eax,0x805148
  8030d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030dd:	a1 54 51 80 00       	mov    0x805154,%eax
  8030e2:	40                   	inc    %eax
  8030e3:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8030e8:	e9 bb 04 00 00       	jmp    8035a8 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  8030ed:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030f1:	75 17                	jne    80310a <insert_sorted_with_merge_freeList+0x2ab>
  8030f3:	83 ec 04             	sub    $0x4,%esp
  8030f6:	68 08 41 80 00       	push   $0x804108
  8030fb:	68 4c 01 00 00       	push   $0x14c
  803100:	68 b7 40 80 00       	push   $0x8040b7
  803105:	e8 86 d2 ff ff       	call   800390 <_panic>
  80310a:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803110:	8b 45 08             	mov    0x8(%ebp),%eax
  803113:	89 50 04             	mov    %edx,0x4(%eax)
  803116:	8b 45 08             	mov    0x8(%ebp),%eax
  803119:	8b 40 04             	mov    0x4(%eax),%eax
  80311c:	85 c0                	test   %eax,%eax
  80311e:	74 0c                	je     80312c <insert_sorted_with_merge_freeList+0x2cd>
  803120:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803125:	8b 55 08             	mov    0x8(%ebp),%edx
  803128:	89 10                	mov    %edx,(%eax)
  80312a:	eb 08                	jmp    803134 <insert_sorted_with_merge_freeList+0x2d5>
  80312c:	8b 45 08             	mov    0x8(%ebp),%eax
  80312f:	a3 38 51 80 00       	mov    %eax,0x805138
  803134:	8b 45 08             	mov    0x8(%ebp),%eax
  803137:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80313c:	8b 45 08             	mov    0x8(%ebp),%eax
  80313f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803145:	a1 44 51 80 00       	mov    0x805144,%eax
  80314a:	40                   	inc    %eax
  80314b:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803150:	e9 53 04 00 00       	jmp    8035a8 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803155:	a1 38 51 80 00       	mov    0x805138,%eax
  80315a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80315d:	e9 15 04 00 00       	jmp    803577 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803162:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803165:	8b 00                	mov    (%eax),%eax
  803167:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  80316a:	8b 45 08             	mov    0x8(%ebp),%eax
  80316d:	8b 50 08             	mov    0x8(%eax),%edx
  803170:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803173:	8b 40 08             	mov    0x8(%eax),%eax
  803176:	39 c2                	cmp    %eax,%edx
  803178:	0f 86 f1 03 00 00    	jbe    80356f <insert_sorted_with_merge_freeList+0x710>
  80317e:	8b 45 08             	mov    0x8(%ebp),%eax
  803181:	8b 50 08             	mov    0x8(%eax),%edx
  803184:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803187:	8b 40 08             	mov    0x8(%eax),%eax
  80318a:	39 c2                	cmp    %eax,%edx
  80318c:	0f 83 dd 03 00 00    	jae    80356f <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803192:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803195:	8b 50 08             	mov    0x8(%eax),%edx
  803198:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80319b:	8b 40 0c             	mov    0xc(%eax),%eax
  80319e:	01 c2                	add    %eax,%edx
  8031a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a3:	8b 40 08             	mov    0x8(%eax),%eax
  8031a6:	39 c2                	cmp    %eax,%edx
  8031a8:	0f 85 b9 01 00 00    	jne    803367 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8031ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b1:	8b 50 08             	mov    0x8(%eax),%edx
  8031b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b7:	8b 40 0c             	mov    0xc(%eax),%eax
  8031ba:	01 c2                	add    %eax,%edx
  8031bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031bf:	8b 40 08             	mov    0x8(%eax),%eax
  8031c2:	39 c2                	cmp    %eax,%edx
  8031c4:	0f 85 0d 01 00 00    	jne    8032d7 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8031ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031cd:	8b 50 0c             	mov    0xc(%eax),%edx
  8031d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d3:	8b 40 0c             	mov    0xc(%eax),%eax
  8031d6:	01 c2                	add    %eax,%edx
  8031d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031db:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8031de:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031e2:	75 17                	jne    8031fb <insert_sorted_with_merge_freeList+0x39c>
  8031e4:	83 ec 04             	sub    $0x4,%esp
  8031e7:	68 60 41 80 00       	push   $0x804160
  8031ec:	68 5c 01 00 00       	push   $0x15c
  8031f1:	68 b7 40 80 00       	push   $0x8040b7
  8031f6:	e8 95 d1 ff ff       	call   800390 <_panic>
  8031fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031fe:	8b 00                	mov    (%eax),%eax
  803200:	85 c0                	test   %eax,%eax
  803202:	74 10                	je     803214 <insert_sorted_with_merge_freeList+0x3b5>
  803204:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803207:	8b 00                	mov    (%eax),%eax
  803209:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80320c:	8b 52 04             	mov    0x4(%edx),%edx
  80320f:	89 50 04             	mov    %edx,0x4(%eax)
  803212:	eb 0b                	jmp    80321f <insert_sorted_with_merge_freeList+0x3c0>
  803214:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803217:	8b 40 04             	mov    0x4(%eax),%eax
  80321a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80321f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803222:	8b 40 04             	mov    0x4(%eax),%eax
  803225:	85 c0                	test   %eax,%eax
  803227:	74 0f                	je     803238 <insert_sorted_with_merge_freeList+0x3d9>
  803229:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80322c:	8b 40 04             	mov    0x4(%eax),%eax
  80322f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803232:	8b 12                	mov    (%edx),%edx
  803234:	89 10                	mov    %edx,(%eax)
  803236:	eb 0a                	jmp    803242 <insert_sorted_with_merge_freeList+0x3e3>
  803238:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80323b:	8b 00                	mov    (%eax),%eax
  80323d:	a3 38 51 80 00       	mov    %eax,0x805138
  803242:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803245:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80324b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80324e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803255:	a1 44 51 80 00       	mov    0x805144,%eax
  80325a:	48                   	dec    %eax
  80325b:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803260:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803263:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  80326a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80326d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803274:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803278:	75 17                	jne    803291 <insert_sorted_with_merge_freeList+0x432>
  80327a:	83 ec 04             	sub    $0x4,%esp
  80327d:	68 94 40 80 00       	push   $0x804094
  803282:	68 5f 01 00 00       	push   $0x15f
  803287:	68 b7 40 80 00       	push   $0x8040b7
  80328c:	e8 ff d0 ff ff       	call   800390 <_panic>
  803291:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803297:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80329a:	89 10                	mov    %edx,(%eax)
  80329c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80329f:	8b 00                	mov    (%eax),%eax
  8032a1:	85 c0                	test   %eax,%eax
  8032a3:	74 0d                	je     8032b2 <insert_sorted_with_merge_freeList+0x453>
  8032a5:	a1 48 51 80 00       	mov    0x805148,%eax
  8032aa:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032ad:	89 50 04             	mov    %edx,0x4(%eax)
  8032b0:	eb 08                	jmp    8032ba <insert_sorted_with_merge_freeList+0x45b>
  8032b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032b5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032bd:	a3 48 51 80 00       	mov    %eax,0x805148
  8032c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032c5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032cc:	a1 54 51 80 00       	mov    0x805154,%eax
  8032d1:	40                   	inc    %eax
  8032d2:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8032d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032da:	8b 50 0c             	mov    0xc(%eax),%edx
  8032dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e0:	8b 40 0c             	mov    0xc(%eax),%eax
  8032e3:	01 c2                	add    %eax,%edx
  8032e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032e8:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8032eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ee:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8032f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8032ff:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803303:	75 17                	jne    80331c <insert_sorted_with_merge_freeList+0x4bd>
  803305:	83 ec 04             	sub    $0x4,%esp
  803308:	68 94 40 80 00       	push   $0x804094
  80330d:	68 64 01 00 00       	push   $0x164
  803312:	68 b7 40 80 00       	push   $0x8040b7
  803317:	e8 74 d0 ff ff       	call   800390 <_panic>
  80331c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803322:	8b 45 08             	mov    0x8(%ebp),%eax
  803325:	89 10                	mov    %edx,(%eax)
  803327:	8b 45 08             	mov    0x8(%ebp),%eax
  80332a:	8b 00                	mov    (%eax),%eax
  80332c:	85 c0                	test   %eax,%eax
  80332e:	74 0d                	je     80333d <insert_sorted_with_merge_freeList+0x4de>
  803330:	a1 48 51 80 00       	mov    0x805148,%eax
  803335:	8b 55 08             	mov    0x8(%ebp),%edx
  803338:	89 50 04             	mov    %edx,0x4(%eax)
  80333b:	eb 08                	jmp    803345 <insert_sorted_with_merge_freeList+0x4e6>
  80333d:	8b 45 08             	mov    0x8(%ebp),%eax
  803340:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803345:	8b 45 08             	mov    0x8(%ebp),%eax
  803348:	a3 48 51 80 00       	mov    %eax,0x805148
  80334d:	8b 45 08             	mov    0x8(%ebp),%eax
  803350:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803357:	a1 54 51 80 00       	mov    0x805154,%eax
  80335c:	40                   	inc    %eax
  80335d:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803362:	e9 41 02 00 00       	jmp    8035a8 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803367:	8b 45 08             	mov    0x8(%ebp),%eax
  80336a:	8b 50 08             	mov    0x8(%eax),%edx
  80336d:	8b 45 08             	mov    0x8(%ebp),%eax
  803370:	8b 40 0c             	mov    0xc(%eax),%eax
  803373:	01 c2                	add    %eax,%edx
  803375:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803378:	8b 40 08             	mov    0x8(%eax),%eax
  80337b:	39 c2                	cmp    %eax,%edx
  80337d:	0f 85 7c 01 00 00    	jne    8034ff <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803383:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803387:	74 06                	je     80338f <insert_sorted_with_merge_freeList+0x530>
  803389:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80338d:	75 17                	jne    8033a6 <insert_sorted_with_merge_freeList+0x547>
  80338f:	83 ec 04             	sub    $0x4,%esp
  803392:	68 d0 40 80 00       	push   $0x8040d0
  803397:	68 69 01 00 00       	push   $0x169
  80339c:	68 b7 40 80 00       	push   $0x8040b7
  8033a1:	e8 ea cf ff ff       	call   800390 <_panic>
  8033a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033a9:	8b 50 04             	mov    0x4(%eax),%edx
  8033ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8033af:	89 50 04             	mov    %edx,0x4(%eax)
  8033b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033b8:	89 10                	mov    %edx,(%eax)
  8033ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033bd:	8b 40 04             	mov    0x4(%eax),%eax
  8033c0:	85 c0                	test   %eax,%eax
  8033c2:	74 0d                	je     8033d1 <insert_sorted_with_merge_freeList+0x572>
  8033c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033c7:	8b 40 04             	mov    0x4(%eax),%eax
  8033ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8033cd:	89 10                	mov    %edx,(%eax)
  8033cf:	eb 08                	jmp    8033d9 <insert_sorted_with_merge_freeList+0x57a>
  8033d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d4:	a3 38 51 80 00       	mov    %eax,0x805138
  8033d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8033df:	89 50 04             	mov    %edx,0x4(%eax)
  8033e2:	a1 44 51 80 00       	mov    0x805144,%eax
  8033e7:	40                   	inc    %eax
  8033e8:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8033ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f0:	8b 50 0c             	mov    0xc(%eax),%edx
  8033f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033f6:	8b 40 0c             	mov    0xc(%eax),%eax
  8033f9:	01 c2                	add    %eax,%edx
  8033fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8033fe:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803401:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803405:	75 17                	jne    80341e <insert_sorted_with_merge_freeList+0x5bf>
  803407:	83 ec 04             	sub    $0x4,%esp
  80340a:	68 60 41 80 00       	push   $0x804160
  80340f:	68 6b 01 00 00       	push   $0x16b
  803414:	68 b7 40 80 00       	push   $0x8040b7
  803419:	e8 72 cf ff ff       	call   800390 <_panic>
  80341e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803421:	8b 00                	mov    (%eax),%eax
  803423:	85 c0                	test   %eax,%eax
  803425:	74 10                	je     803437 <insert_sorted_with_merge_freeList+0x5d8>
  803427:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80342a:	8b 00                	mov    (%eax),%eax
  80342c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80342f:	8b 52 04             	mov    0x4(%edx),%edx
  803432:	89 50 04             	mov    %edx,0x4(%eax)
  803435:	eb 0b                	jmp    803442 <insert_sorted_with_merge_freeList+0x5e3>
  803437:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80343a:	8b 40 04             	mov    0x4(%eax),%eax
  80343d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803442:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803445:	8b 40 04             	mov    0x4(%eax),%eax
  803448:	85 c0                	test   %eax,%eax
  80344a:	74 0f                	je     80345b <insert_sorted_with_merge_freeList+0x5fc>
  80344c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80344f:	8b 40 04             	mov    0x4(%eax),%eax
  803452:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803455:	8b 12                	mov    (%edx),%edx
  803457:	89 10                	mov    %edx,(%eax)
  803459:	eb 0a                	jmp    803465 <insert_sorted_with_merge_freeList+0x606>
  80345b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80345e:	8b 00                	mov    (%eax),%eax
  803460:	a3 38 51 80 00       	mov    %eax,0x805138
  803465:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803468:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80346e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803471:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803478:	a1 44 51 80 00       	mov    0x805144,%eax
  80347d:	48                   	dec    %eax
  80347e:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803483:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803486:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  80348d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803490:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803497:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80349b:	75 17                	jne    8034b4 <insert_sorted_with_merge_freeList+0x655>
  80349d:	83 ec 04             	sub    $0x4,%esp
  8034a0:	68 94 40 80 00       	push   $0x804094
  8034a5:	68 6e 01 00 00       	push   $0x16e
  8034aa:	68 b7 40 80 00       	push   $0x8040b7
  8034af:	e8 dc ce ff ff       	call   800390 <_panic>
  8034b4:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8034ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034bd:	89 10                	mov    %edx,(%eax)
  8034bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034c2:	8b 00                	mov    (%eax),%eax
  8034c4:	85 c0                	test   %eax,%eax
  8034c6:	74 0d                	je     8034d5 <insert_sorted_with_merge_freeList+0x676>
  8034c8:	a1 48 51 80 00       	mov    0x805148,%eax
  8034cd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034d0:	89 50 04             	mov    %edx,0x4(%eax)
  8034d3:	eb 08                	jmp    8034dd <insert_sorted_with_merge_freeList+0x67e>
  8034d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034d8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034e0:	a3 48 51 80 00       	mov    %eax,0x805148
  8034e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034e8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034ef:	a1 54 51 80 00       	mov    0x805154,%eax
  8034f4:	40                   	inc    %eax
  8034f5:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8034fa:	e9 a9 00 00 00       	jmp    8035a8 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8034ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803503:	74 06                	je     80350b <insert_sorted_with_merge_freeList+0x6ac>
  803505:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803509:	75 17                	jne    803522 <insert_sorted_with_merge_freeList+0x6c3>
  80350b:	83 ec 04             	sub    $0x4,%esp
  80350e:	68 2c 41 80 00       	push   $0x80412c
  803513:	68 73 01 00 00       	push   $0x173
  803518:	68 b7 40 80 00       	push   $0x8040b7
  80351d:	e8 6e ce ff ff       	call   800390 <_panic>
  803522:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803525:	8b 10                	mov    (%eax),%edx
  803527:	8b 45 08             	mov    0x8(%ebp),%eax
  80352a:	89 10                	mov    %edx,(%eax)
  80352c:	8b 45 08             	mov    0x8(%ebp),%eax
  80352f:	8b 00                	mov    (%eax),%eax
  803531:	85 c0                	test   %eax,%eax
  803533:	74 0b                	je     803540 <insert_sorted_with_merge_freeList+0x6e1>
  803535:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803538:	8b 00                	mov    (%eax),%eax
  80353a:	8b 55 08             	mov    0x8(%ebp),%edx
  80353d:	89 50 04             	mov    %edx,0x4(%eax)
  803540:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803543:	8b 55 08             	mov    0x8(%ebp),%edx
  803546:	89 10                	mov    %edx,(%eax)
  803548:	8b 45 08             	mov    0x8(%ebp),%eax
  80354b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80354e:	89 50 04             	mov    %edx,0x4(%eax)
  803551:	8b 45 08             	mov    0x8(%ebp),%eax
  803554:	8b 00                	mov    (%eax),%eax
  803556:	85 c0                	test   %eax,%eax
  803558:	75 08                	jne    803562 <insert_sorted_with_merge_freeList+0x703>
  80355a:	8b 45 08             	mov    0x8(%ebp),%eax
  80355d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803562:	a1 44 51 80 00       	mov    0x805144,%eax
  803567:	40                   	inc    %eax
  803568:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  80356d:	eb 39                	jmp    8035a8 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80356f:	a1 40 51 80 00       	mov    0x805140,%eax
  803574:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803577:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80357b:	74 07                	je     803584 <insert_sorted_with_merge_freeList+0x725>
  80357d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803580:	8b 00                	mov    (%eax),%eax
  803582:	eb 05                	jmp    803589 <insert_sorted_with_merge_freeList+0x72a>
  803584:	b8 00 00 00 00       	mov    $0x0,%eax
  803589:	a3 40 51 80 00       	mov    %eax,0x805140
  80358e:	a1 40 51 80 00       	mov    0x805140,%eax
  803593:	85 c0                	test   %eax,%eax
  803595:	0f 85 c7 fb ff ff    	jne    803162 <insert_sorted_with_merge_freeList+0x303>
  80359b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80359f:	0f 85 bd fb ff ff    	jne    803162 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8035a5:	eb 01                	jmp    8035a8 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8035a7:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8035a8:	90                   	nop
  8035a9:	c9                   	leave  
  8035aa:	c3                   	ret    
  8035ab:	90                   	nop

008035ac <__udivdi3>:
  8035ac:	55                   	push   %ebp
  8035ad:	57                   	push   %edi
  8035ae:	56                   	push   %esi
  8035af:	53                   	push   %ebx
  8035b0:	83 ec 1c             	sub    $0x1c,%esp
  8035b3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8035b7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8035bb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8035bf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8035c3:	89 ca                	mov    %ecx,%edx
  8035c5:	89 f8                	mov    %edi,%eax
  8035c7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8035cb:	85 f6                	test   %esi,%esi
  8035cd:	75 2d                	jne    8035fc <__udivdi3+0x50>
  8035cf:	39 cf                	cmp    %ecx,%edi
  8035d1:	77 65                	ja     803638 <__udivdi3+0x8c>
  8035d3:	89 fd                	mov    %edi,%ebp
  8035d5:	85 ff                	test   %edi,%edi
  8035d7:	75 0b                	jne    8035e4 <__udivdi3+0x38>
  8035d9:	b8 01 00 00 00       	mov    $0x1,%eax
  8035de:	31 d2                	xor    %edx,%edx
  8035e0:	f7 f7                	div    %edi
  8035e2:	89 c5                	mov    %eax,%ebp
  8035e4:	31 d2                	xor    %edx,%edx
  8035e6:	89 c8                	mov    %ecx,%eax
  8035e8:	f7 f5                	div    %ebp
  8035ea:	89 c1                	mov    %eax,%ecx
  8035ec:	89 d8                	mov    %ebx,%eax
  8035ee:	f7 f5                	div    %ebp
  8035f0:	89 cf                	mov    %ecx,%edi
  8035f2:	89 fa                	mov    %edi,%edx
  8035f4:	83 c4 1c             	add    $0x1c,%esp
  8035f7:	5b                   	pop    %ebx
  8035f8:	5e                   	pop    %esi
  8035f9:	5f                   	pop    %edi
  8035fa:	5d                   	pop    %ebp
  8035fb:	c3                   	ret    
  8035fc:	39 ce                	cmp    %ecx,%esi
  8035fe:	77 28                	ja     803628 <__udivdi3+0x7c>
  803600:	0f bd fe             	bsr    %esi,%edi
  803603:	83 f7 1f             	xor    $0x1f,%edi
  803606:	75 40                	jne    803648 <__udivdi3+0x9c>
  803608:	39 ce                	cmp    %ecx,%esi
  80360a:	72 0a                	jb     803616 <__udivdi3+0x6a>
  80360c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803610:	0f 87 9e 00 00 00    	ja     8036b4 <__udivdi3+0x108>
  803616:	b8 01 00 00 00       	mov    $0x1,%eax
  80361b:	89 fa                	mov    %edi,%edx
  80361d:	83 c4 1c             	add    $0x1c,%esp
  803620:	5b                   	pop    %ebx
  803621:	5e                   	pop    %esi
  803622:	5f                   	pop    %edi
  803623:	5d                   	pop    %ebp
  803624:	c3                   	ret    
  803625:	8d 76 00             	lea    0x0(%esi),%esi
  803628:	31 ff                	xor    %edi,%edi
  80362a:	31 c0                	xor    %eax,%eax
  80362c:	89 fa                	mov    %edi,%edx
  80362e:	83 c4 1c             	add    $0x1c,%esp
  803631:	5b                   	pop    %ebx
  803632:	5e                   	pop    %esi
  803633:	5f                   	pop    %edi
  803634:	5d                   	pop    %ebp
  803635:	c3                   	ret    
  803636:	66 90                	xchg   %ax,%ax
  803638:	89 d8                	mov    %ebx,%eax
  80363a:	f7 f7                	div    %edi
  80363c:	31 ff                	xor    %edi,%edi
  80363e:	89 fa                	mov    %edi,%edx
  803640:	83 c4 1c             	add    $0x1c,%esp
  803643:	5b                   	pop    %ebx
  803644:	5e                   	pop    %esi
  803645:	5f                   	pop    %edi
  803646:	5d                   	pop    %ebp
  803647:	c3                   	ret    
  803648:	bd 20 00 00 00       	mov    $0x20,%ebp
  80364d:	89 eb                	mov    %ebp,%ebx
  80364f:	29 fb                	sub    %edi,%ebx
  803651:	89 f9                	mov    %edi,%ecx
  803653:	d3 e6                	shl    %cl,%esi
  803655:	89 c5                	mov    %eax,%ebp
  803657:	88 d9                	mov    %bl,%cl
  803659:	d3 ed                	shr    %cl,%ebp
  80365b:	89 e9                	mov    %ebp,%ecx
  80365d:	09 f1                	or     %esi,%ecx
  80365f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803663:	89 f9                	mov    %edi,%ecx
  803665:	d3 e0                	shl    %cl,%eax
  803667:	89 c5                	mov    %eax,%ebp
  803669:	89 d6                	mov    %edx,%esi
  80366b:	88 d9                	mov    %bl,%cl
  80366d:	d3 ee                	shr    %cl,%esi
  80366f:	89 f9                	mov    %edi,%ecx
  803671:	d3 e2                	shl    %cl,%edx
  803673:	8b 44 24 08          	mov    0x8(%esp),%eax
  803677:	88 d9                	mov    %bl,%cl
  803679:	d3 e8                	shr    %cl,%eax
  80367b:	09 c2                	or     %eax,%edx
  80367d:	89 d0                	mov    %edx,%eax
  80367f:	89 f2                	mov    %esi,%edx
  803681:	f7 74 24 0c          	divl   0xc(%esp)
  803685:	89 d6                	mov    %edx,%esi
  803687:	89 c3                	mov    %eax,%ebx
  803689:	f7 e5                	mul    %ebp
  80368b:	39 d6                	cmp    %edx,%esi
  80368d:	72 19                	jb     8036a8 <__udivdi3+0xfc>
  80368f:	74 0b                	je     80369c <__udivdi3+0xf0>
  803691:	89 d8                	mov    %ebx,%eax
  803693:	31 ff                	xor    %edi,%edi
  803695:	e9 58 ff ff ff       	jmp    8035f2 <__udivdi3+0x46>
  80369a:	66 90                	xchg   %ax,%ax
  80369c:	8b 54 24 08          	mov    0x8(%esp),%edx
  8036a0:	89 f9                	mov    %edi,%ecx
  8036a2:	d3 e2                	shl    %cl,%edx
  8036a4:	39 c2                	cmp    %eax,%edx
  8036a6:	73 e9                	jae    803691 <__udivdi3+0xe5>
  8036a8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8036ab:	31 ff                	xor    %edi,%edi
  8036ad:	e9 40 ff ff ff       	jmp    8035f2 <__udivdi3+0x46>
  8036b2:	66 90                	xchg   %ax,%ax
  8036b4:	31 c0                	xor    %eax,%eax
  8036b6:	e9 37 ff ff ff       	jmp    8035f2 <__udivdi3+0x46>
  8036bb:	90                   	nop

008036bc <__umoddi3>:
  8036bc:	55                   	push   %ebp
  8036bd:	57                   	push   %edi
  8036be:	56                   	push   %esi
  8036bf:	53                   	push   %ebx
  8036c0:	83 ec 1c             	sub    $0x1c,%esp
  8036c3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8036c7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8036cb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8036cf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8036d3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8036d7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8036db:	89 f3                	mov    %esi,%ebx
  8036dd:	89 fa                	mov    %edi,%edx
  8036df:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8036e3:	89 34 24             	mov    %esi,(%esp)
  8036e6:	85 c0                	test   %eax,%eax
  8036e8:	75 1a                	jne    803704 <__umoddi3+0x48>
  8036ea:	39 f7                	cmp    %esi,%edi
  8036ec:	0f 86 a2 00 00 00    	jbe    803794 <__umoddi3+0xd8>
  8036f2:	89 c8                	mov    %ecx,%eax
  8036f4:	89 f2                	mov    %esi,%edx
  8036f6:	f7 f7                	div    %edi
  8036f8:	89 d0                	mov    %edx,%eax
  8036fa:	31 d2                	xor    %edx,%edx
  8036fc:	83 c4 1c             	add    $0x1c,%esp
  8036ff:	5b                   	pop    %ebx
  803700:	5e                   	pop    %esi
  803701:	5f                   	pop    %edi
  803702:	5d                   	pop    %ebp
  803703:	c3                   	ret    
  803704:	39 f0                	cmp    %esi,%eax
  803706:	0f 87 ac 00 00 00    	ja     8037b8 <__umoddi3+0xfc>
  80370c:	0f bd e8             	bsr    %eax,%ebp
  80370f:	83 f5 1f             	xor    $0x1f,%ebp
  803712:	0f 84 ac 00 00 00    	je     8037c4 <__umoddi3+0x108>
  803718:	bf 20 00 00 00       	mov    $0x20,%edi
  80371d:	29 ef                	sub    %ebp,%edi
  80371f:	89 fe                	mov    %edi,%esi
  803721:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803725:	89 e9                	mov    %ebp,%ecx
  803727:	d3 e0                	shl    %cl,%eax
  803729:	89 d7                	mov    %edx,%edi
  80372b:	89 f1                	mov    %esi,%ecx
  80372d:	d3 ef                	shr    %cl,%edi
  80372f:	09 c7                	or     %eax,%edi
  803731:	89 e9                	mov    %ebp,%ecx
  803733:	d3 e2                	shl    %cl,%edx
  803735:	89 14 24             	mov    %edx,(%esp)
  803738:	89 d8                	mov    %ebx,%eax
  80373a:	d3 e0                	shl    %cl,%eax
  80373c:	89 c2                	mov    %eax,%edx
  80373e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803742:	d3 e0                	shl    %cl,%eax
  803744:	89 44 24 04          	mov    %eax,0x4(%esp)
  803748:	8b 44 24 08          	mov    0x8(%esp),%eax
  80374c:	89 f1                	mov    %esi,%ecx
  80374e:	d3 e8                	shr    %cl,%eax
  803750:	09 d0                	or     %edx,%eax
  803752:	d3 eb                	shr    %cl,%ebx
  803754:	89 da                	mov    %ebx,%edx
  803756:	f7 f7                	div    %edi
  803758:	89 d3                	mov    %edx,%ebx
  80375a:	f7 24 24             	mull   (%esp)
  80375d:	89 c6                	mov    %eax,%esi
  80375f:	89 d1                	mov    %edx,%ecx
  803761:	39 d3                	cmp    %edx,%ebx
  803763:	0f 82 87 00 00 00    	jb     8037f0 <__umoddi3+0x134>
  803769:	0f 84 91 00 00 00    	je     803800 <__umoddi3+0x144>
  80376f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803773:	29 f2                	sub    %esi,%edx
  803775:	19 cb                	sbb    %ecx,%ebx
  803777:	89 d8                	mov    %ebx,%eax
  803779:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80377d:	d3 e0                	shl    %cl,%eax
  80377f:	89 e9                	mov    %ebp,%ecx
  803781:	d3 ea                	shr    %cl,%edx
  803783:	09 d0                	or     %edx,%eax
  803785:	89 e9                	mov    %ebp,%ecx
  803787:	d3 eb                	shr    %cl,%ebx
  803789:	89 da                	mov    %ebx,%edx
  80378b:	83 c4 1c             	add    $0x1c,%esp
  80378e:	5b                   	pop    %ebx
  80378f:	5e                   	pop    %esi
  803790:	5f                   	pop    %edi
  803791:	5d                   	pop    %ebp
  803792:	c3                   	ret    
  803793:	90                   	nop
  803794:	89 fd                	mov    %edi,%ebp
  803796:	85 ff                	test   %edi,%edi
  803798:	75 0b                	jne    8037a5 <__umoddi3+0xe9>
  80379a:	b8 01 00 00 00       	mov    $0x1,%eax
  80379f:	31 d2                	xor    %edx,%edx
  8037a1:	f7 f7                	div    %edi
  8037a3:	89 c5                	mov    %eax,%ebp
  8037a5:	89 f0                	mov    %esi,%eax
  8037a7:	31 d2                	xor    %edx,%edx
  8037a9:	f7 f5                	div    %ebp
  8037ab:	89 c8                	mov    %ecx,%eax
  8037ad:	f7 f5                	div    %ebp
  8037af:	89 d0                	mov    %edx,%eax
  8037b1:	e9 44 ff ff ff       	jmp    8036fa <__umoddi3+0x3e>
  8037b6:	66 90                	xchg   %ax,%ax
  8037b8:	89 c8                	mov    %ecx,%eax
  8037ba:	89 f2                	mov    %esi,%edx
  8037bc:	83 c4 1c             	add    $0x1c,%esp
  8037bf:	5b                   	pop    %ebx
  8037c0:	5e                   	pop    %esi
  8037c1:	5f                   	pop    %edi
  8037c2:	5d                   	pop    %ebp
  8037c3:	c3                   	ret    
  8037c4:	3b 04 24             	cmp    (%esp),%eax
  8037c7:	72 06                	jb     8037cf <__umoddi3+0x113>
  8037c9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8037cd:	77 0f                	ja     8037de <__umoddi3+0x122>
  8037cf:	89 f2                	mov    %esi,%edx
  8037d1:	29 f9                	sub    %edi,%ecx
  8037d3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8037d7:	89 14 24             	mov    %edx,(%esp)
  8037da:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8037de:	8b 44 24 04          	mov    0x4(%esp),%eax
  8037e2:	8b 14 24             	mov    (%esp),%edx
  8037e5:	83 c4 1c             	add    $0x1c,%esp
  8037e8:	5b                   	pop    %ebx
  8037e9:	5e                   	pop    %esi
  8037ea:	5f                   	pop    %edi
  8037eb:	5d                   	pop    %ebp
  8037ec:	c3                   	ret    
  8037ed:	8d 76 00             	lea    0x0(%esi),%esi
  8037f0:	2b 04 24             	sub    (%esp),%eax
  8037f3:	19 fa                	sbb    %edi,%edx
  8037f5:	89 d1                	mov    %edx,%ecx
  8037f7:	89 c6                	mov    %eax,%esi
  8037f9:	e9 71 ff ff ff       	jmp    80376f <__umoddi3+0xb3>
  8037fe:	66 90                	xchg   %ax,%ax
  803800:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803804:	72 ea                	jb     8037f0 <__umoddi3+0x134>
  803806:	89 d9                	mov    %ebx,%ecx
  803808:	e9 62 ff ff ff       	jmp    80376f <__umoddi3+0xb3>
