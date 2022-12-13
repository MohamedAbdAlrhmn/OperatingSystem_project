
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
  80008d:	68 60 37 80 00       	push   $0x803760
  800092:	6a 13                	push   $0x13
  800094:	68 7c 37 80 00       	push   $0x80377c
  800099:	e8 f2 02 00 00       	call   800390 <_panic>
	}
	uint32 *x,*y,*z;
	int32 parentenvID = sys_getparentenvid();
  80009e:	e8 89 1b 00 00       	call   801c2c <sys_getparentenvid>
  8000a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//GET: z then y then x, opposite to creation order (x then y then z)
	//So, addresses here will be different from the OWNER addresses
	sys_disable_interrupt();
  8000a6:	e8 75 19 00 00       	call   801a20 <sys_disable_interrupt>
	int freeFrames = sys_calculate_free_frames() ;
  8000ab:	e8 83 18 00 00       	call   801933 <sys_calculate_free_frames>
  8000b0:	89 45 e8             	mov    %eax,-0x18(%ebp)
	z = sget(parentenvID,"z");
  8000b3:	83 ec 08             	sub    $0x8,%esp
  8000b6:	68 9a 37 80 00       	push   $0x80379a
  8000bb:	ff 75 ec             	pushl  -0x14(%ebp)
  8000be:	e8 4c 16 00 00       	call   80170f <sget>
  8000c3:	83 c4 10             	add    $0x10,%esp
  8000c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (z != (uint32*)(USER_HEAP_START + 0 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8000c9:	81 7d e4 00 00 00 80 	cmpl   $0x80000000,-0x1c(%ebp)
  8000d0:	74 14                	je     8000e6 <_main+0xae>
  8000d2:	83 ec 04             	sub    $0x4,%esp
  8000d5:	68 9c 37 80 00       	push   $0x80379c
  8000da:	6a 1c                	push   $0x1c
  8000dc:	68 7c 37 80 00       	push   $0x80377c
  8000e1:	e8 aa 02 00 00       	call   800390 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  8000e6:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000e9:	e8 45 18 00 00       	call   801933 <sys_calculate_free_frames>
  8000ee:	29 c3                	sub    %eax,%ebx
  8000f0:	89 d8                	mov    %ebx,%eax
  8000f2:	83 f8 01             	cmp    $0x1,%eax
  8000f5:	74 14                	je     80010b <_main+0xd3>
  8000f7:	83 ec 04             	sub    $0x4,%esp
  8000fa:	68 fc 37 80 00       	push   $0x8037fc
  8000ff:	6a 1d                	push   $0x1d
  800101:	68 7c 37 80 00       	push   $0x80377c
  800106:	e8 85 02 00 00       	call   800390 <_panic>
	sys_enable_interrupt();
  80010b:	e8 2a 19 00 00       	call   801a3a <sys_enable_interrupt>

	sys_disable_interrupt();
  800110:	e8 0b 19 00 00       	call   801a20 <sys_disable_interrupt>
	freeFrames = sys_calculate_free_frames() ;
  800115:	e8 19 18 00 00       	call   801933 <sys_calculate_free_frames>
  80011a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	y = sget(parentenvID,"y");
  80011d:	83 ec 08             	sub    $0x8,%esp
  800120:	68 8d 38 80 00       	push   $0x80388d
  800125:	ff 75 ec             	pushl  -0x14(%ebp)
  800128:	e8 e2 15 00 00       	call   80170f <sget>
  80012d:	83 c4 10             	add    $0x10,%esp
  800130:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (y != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  800133:	81 7d e0 00 10 00 80 	cmpl   $0x80001000,-0x20(%ebp)
  80013a:	74 14                	je     800150 <_main+0x118>
  80013c:	83 ec 04             	sub    $0x4,%esp
  80013f:	68 9c 37 80 00       	push   $0x80379c
  800144:	6a 23                	push   $0x23
  800146:	68 7c 37 80 00       	push   $0x80377c
  80014b:	e8 40 02 00 00       	call   800390 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  800150:	e8 de 17 00 00       	call   801933 <sys_calculate_free_frames>
  800155:	89 c2                	mov    %eax,%edx
  800157:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80015a:	39 c2                	cmp    %eax,%edx
  80015c:	74 14                	je     800172 <_main+0x13a>
  80015e:	83 ec 04             	sub    $0x4,%esp
  800161:	68 fc 37 80 00       	push   $0x8037fc
  800166:	6a 24                	push   $0x24
  800168:	68 7c 37 80 00       	push   $0x80377c
  80016d:	e8 1e 02 00 00       	call   800390 <_panic>
	sys_enable_interrupt();
  800172:	e8 c3 18 00 00       	call   801a3a <sys_enable_interrupt>
	
	if (*y != 20) panic("Get(): Shared Variable is not created or got correctly") ;
  800177:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80017a:	8b 00                	mov    (%eax),%eax
  80017c:	83 f8 14             	cmp    $0x14,%eax
  80017f:	74 14                	je     800195 <_main+0x15d>
  800181:	83 ec 04             	sub    $0x4,%esp
  800184:	68 90 38 80 00       	push   $0x803890
  800189:	6a 27                	push   $0x27
  80018b:	68 7c 37 80 00       	push   $0x80377c
  800190:	e8 fb 01 00 00       	call   800390 <_panic>

	sys_disable_interrupt();
  800195:	e8 86 18 00 00       	call   801a20 <sys_disable_interrupt>
	freeFrames = sys_calculate_free_frames() ;
  80019a:	e8 94 17 00 00       	call   801933 <sys_calculate_free_frames>
  80019f:	89 45 e8             	mov    %eax,-0x18(%ebp)
	x = sget(parentenvID,"x");
  8001a2:	83 ec 08             	sub    $0x8,%esp
  8001a5:	68 c7 38 80 00       	push   $0x8038c7
  8001aa:	ff 75 ec             	pushl  -0x14(%ebp)
  8001ad:	e8 5d 15 00 00       	call   80170f <sget>
  8001b2:	83 c4 10             	add    $0x10,%esp
  8001b5:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (x != (uint32*)(USER_HEAP_START + 2 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8001b8:	81 7d dc 00 20 00 80 	cmpl   $0x80002000,-0x24(%ebp)
  8001bf:	74 14                	je     8001d5 <_main+0x19d>
  8001c1:	83 ec 04             	sub    $0x4,%esp
  8001c4:	68 9c 37 80 00       	push   $0x80379c
  8001c9:	6a 2c                	push   $0x2c
  8001cb:	68 7c 37 80 00       	push   $0x80377c
  8001d0:	e8 bb 01 00 00       	call   800390 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  8001d5:	e8 59 17 00 00       	call   801933 <sys_calculate_free_frames>
  8001da:	89 c2                	mov    %eax,%edx
  8001dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001df:	39 c2                	cmp    %eax,%edx
  8001e1:	74 14                	je     8001f7 <_main+0x1bf>
  8001e3:	83 ec 04             	sub    $0x4,%esp
  8001e6:	68 fc 37 80 00       	push   $0x8037fc
  8001eb:	6a 2d                	push   $0x2d
  8001ed:	68 7c 37 80 00       	push   $0x80377c
  8001f2:	e8 99 01 00 00       	call   800390 <_panic>
	sys_enable_interrupt();
  8001f7:	e8 3e 18 00 00       	call   801a3a <sys_enable_interrupt>

	if (*x != 10) panic("Get(): Shared Variable is not created or got correctly") ;
  8001fc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001ff:	8b 00                	mov    (%eax),%eax
  800201:	83 f8 0a             	cmp    $0xa,%eax
  800204:	74 14                	je     80021a <_main+0x1e2>
  800206:	83 ec 04             	sub    $0x4,%esp
  800209:	68 90 38 80 00       	push   $0x803890
  80020e:	6a 30                	push   $0x30
  800210:	68 7c 37 80 00       	push   $0x80377c
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
  800238:	68 90 38 80 00       	push   $0x803890
  80023d:	6a 33                	push   $0x33
  80023f:	68 7c 37 80 00       	push   $0x80377c
  800244:	e8 47 01 00 00       	call   800390 <_panic>

	//To indicate that it's completed successfully
	inctst();
  800249:	e8 03 1b 00 00       	call   801d51 <inctst>

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
  80025a:	e8 b4 19 00 00       	call   801c13 <sys_getenvindex>
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
  8002c5:	e8 56 17 00 00       	call   801a20 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8002ca:	83 ec 0c             	sub    $0xc,%esp
  8002cd:	68 e4 38 80 00       	push   $0x8038e4
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
  8002f5:	68 0c 39 80 00       	push   $0x80390c
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
  800326:	68 34 39 80 00       	push   $0x803934
  80032b:	e8 14 03 00 00       	call   800644 <cprintf>
  800330:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800333:	a1 20 50 80 00       	mov    0x805020,%eax
  800338:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80033e:	83 ec 08             	sub    $0x8,%esp
  800341:	50                   	push   %eax
  800342:	68 8c 39 80 00       	push   $0x80398c
  800347:	e8 f8 02 00 00       	call   800644 <cprintf>
  80034c:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80034f:	83 ec 0c             	sub    $0xc,%esp
  800352:	68 e4 38 80 00       	push   $0x8038e4
  800357:	e8 e8 02 00 00       	call   800644 <cprintf>
  80035c:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80035f:	e8 d6 16 00 00       	call   801a3a <sys_enable_interrupt>

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
  800377:	e8 63 18 00 00       	call   801bdf <sys_destroy_env>
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
  800388:	e8 b8 18 00 00       	call   801c45 <sys_exit_env>
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
  8003b1:	68 a0 39 80 00       	push   $0x8039a0
  8003b6:	e8 89 02 00 00       	call   800644 <cprintf>
  8003bb:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8003be:	a1 00 50 80 00       	mov    0x805000,%eax
  8003c3:	ff 75 0c             	pushl  0xc(%ebp)
  8003c6:	ff 75 08             	pushl  0x8(%ebp)
  8003c9:	50                   	push   %eax
  8003ca:	68 a5 39 80 00       	push   $0x8039a5
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
  8003ee:	68 c1 39 80 00       	push   $0x8039c1
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
  80041a:	68 c4 39 80 00       	push   $0x8039c4
  80041f:	6a 26                	push   $0x26
  800421:	68 10 3a 80 00       	push   $0x803a10
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
  8004ec:	68 1c 3a 80 00       	push   $0x803a1c
  8004f1:	6a 3a                	push   $0x3a
  8004f3:	68 10 3a 80 00       	push   $0x803a10
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
  80055c:	68 70 3a 80 00       	push   $0x803a70
  800561:	6a 44                	push   $0x44
  800563:	68 10 3a 80 00       	push   $0x803a10
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
  8005b6:	e8 b7 12 00 00       	call   801872 <sys_cputs>
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
  80062d:	e8 40 12 00 00       	call   801872 <sys_cputs>
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
  800677:	e8 a4 13 00 00       	call   801a20 <sys_disable_interrupt>
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
  800697:	e8 9e 13 00 00       	call   801a3a <sys_enable_interrupt>
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
  8006e1:	e8 12 2e 00 00       	call   8034f8 <__udivdi3>
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
  800731:	e8 d2 2e 00 00       	call   803608 <__umoddi3>
  800736:	83 c4 10             	add    $0x10,%esp
  800739:	05 d4 3c 80 00       	add    $0x803cd4,%eax
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
  80088c:	8b 04 85 f8 3c 80 00 	mov    0x803cf8(,%eax,4),%eax
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
  80096d:	8b 34 9d 40 3b 80 00 	mov    0x803b40(,%ebx,4),%esi
  800974:	85 f6                	test   %esi,%esi
  800976:	75 19                	jne    800991 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800978:	53                   	push   %ebx
  800979:	68 e5 3c 80 00       	push   $0x803ce5
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
  800992:	68 ee 3c 80 00       	push   $0x803cee
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
  8009bf:	be f1 3c 80 00       	mov    $0x803cf1,%esi
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
  8013e5:	68 50 3e 80 00       	push   $0x803e50
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
  8014b5:	e8 fc 04 00 00       	call   8019b6 <sys_allocate_chunk>
  8014ba:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8014bd:	a1 20 51 80 00       	mov    0x805120,%eax
  8014c2:	83 ec 0c             	sub    $0xc,%esp
  8014c5:	50                   	push   %eax
  8014c6:	e8 71 0b 00 00       	call   80203c <initialize_MemBlocksList>
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
  8014f3:	68 75 3e 80 00       	push   $0x803e75
  8014f8:	6a 33                	push   $0x33
  8014fa:	68 93 3e 80 00       	push   $0x803e93
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
  801572:	68 a0 3e 80 00       	push   $0x803ea0
  801577:	6a 34                	push   $0x34
  801579:	68 93 3e 80 00       	push   $0x803e93
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
  80160a:	e8 75 07 00 00       	call   801d84 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80160f:	85 c0                	test   %eax,%eax
  801611:	74 11                	je     801624 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801613:	83 ec 0c             	sub    $0xc,%esp
  801616:	ff 75 e8             	pushl  -0x18(%ebp)
  801619:	e8 e0 0d 00 00       	call   8023fe <alloc_block_FF>
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
  801630:	e8 3c 0b 00 00       	call   802171 <insert_sorted_allocList>
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
  801650:	68 c4 3e 80 00       	push   $0x803ec4
  801655:	6a 6f                	push   $0x6f
  801657:	68 93 3e 80 00       	push   $0x803e93
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
  801676:	75 0a                	jne    801682 <smalloc+0x21>
  801678:	b8 00 00 00 00       	mov    $0x0,%eax
  80167d:	e9 8b 00 00 00       	jmp    80170d <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801682:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801689:	8b 55 0c             	mov    0xc(%ebp),%edx
  80168c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80168f:	01 d0                	add    %edx,%eax
  801691:	48                   	dec    %eax
  801692:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801695:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801698:	ba 00 00 00 00       	mov    $0x0,%edx
  80169d:	f7 75 f0             	divl   -0x10(%ebp)
  8016a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016a3:	29 d0                	sub    %edx,%eax
  8016a5:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  8016a8:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8016af:	e8 d0 06 00 00       	call   801d84 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016b4:	85 c0                	test   %eax,%eax
  8016b6:	74 11                	je     8016c9 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  8016b8:	83 ec 0c             	sub    $0xc,%esp
  8016bb:	ff 75 e8             	pushl  -0x18(%ebp)
  8016be:	e8 3b 0d 00 00       	call   8023fe <alloc_block_FF>
  8016c3:	83 c4 10             	add    $0x10,%esp
  8016c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  8016c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8016cd:	74 39                	je     801708 <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8016cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016d2:	8b 40 08             	mov    0x8(%eax),%eax
  8016d5:	89 c2                	mov    %eax,%edx
  8016d7:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8016db:	52                   	push   %edx
  8016dc:	50                   	push   %eax
  8016dd:	ff 75 0c             	pushl  0xc(%ebp)
  8016e0:	ff 75 08             	pushl  0x8(%ebp)
  8016e3:	e8 21 04 00 00       	call   801b09 <sys_createSharedObject>
  8016e8:	83 c4 10             	add    $0x10,%esp
  8016eb:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  8016ee:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  8016f2:	74 14                	je     801708 <smalloc+0xa7>
  8016f4:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  8016f8:	74 0e                	je     801708 <smalloc+0xa7>
  8016fa:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  8016fe:	74 08                	je     801708 <smalloc+0xa7>
			return (void*) mem_block->sva;
  801700:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801703:	8b 40 08             	mov    0x8(%eax),%eax
  801706:	eb 05                	jmp    80170d <smalloc+0xac>
	}
	return NULL;
  801708:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80170d:	c9                   	leave  
  80170e:	c3                   	ret    

0080170f <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80170f:	55                   	push   %ebp
  801710:	89 e5                	mov    %esp,%ebp
  801712:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801715:	e8 b4 fc ff ff       	call   8013ce <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80171a:	83 ec 08             	sub    $0x8,%esp
  80171d:	ff 75 0c             	pushl  0xc(%ebp)
  801720:	ff 75 08             	pushl  0x8(%ebp)
  801723:	e8 0b 04 00 00       	call   801b33 <sys_getSizeOfSharedObject>
  801728:	83 c4 10             	add    $0x10,%esp
  80172b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  80172e:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  801732:	74 76                	je     8017aa <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801734:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80173b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80173e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801741:	01 d0                	add    %edx,%eax
  801743:	48                   	dec    %eax
  801744:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801747:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80174a:	ba 00 00 00 00       	mov    $0x0,%edx
  80174f:	f7 75 ec             	divl   -0x14(%ebp)
  801752:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801755:	29 d0                	sub    %edx,%eax
  801757:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  80175a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801761:	e8 1e 06 00 00       	call   801d84 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801766:	85 c0                	test   %eax,%eax
  801768:	74 11                	je     80177b <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  80176a:	83 ec 0c             	sub    $0xc,%esp
  80176d:	ff 75 e4             	pushl  -0x1c(%ebp)
  801770:	e8 89 0c 00 00       	call   8023fe <alloc_block_FF>
  801775:	83 c4 10             	add    $0x10,%esp
  801778:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  80177b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80177f:	74 29                	je     8017aa <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  801781:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801784:	8b 40 08             	mov    0x8(%eax),%eax
  801787:	83 ec 04             	sub    $0x4,%esp
  80178a:	50                   	push   %eax
  80178b:	ff 75 0c             	pushl  0xc(%ebp)
  80178e:	ff 75 08             	pushl  0x8(%ebp)
  801791:	e8 ba 03 00 00       	call   801b50 <sys_getSharedObject>
  801796:	83 c4 10             	add    $0x10,%esp
  801799:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  80179c:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  8017a0:	74 08                	je     8017aa <sget+0x9b>
				return (void *)mem_block->sva;
  8017a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017a5:	8b 40 08             	mov    0x8(%eax),%eax
  8017a8:	eb 05                	jmp    8017af <sget+0xa0>
		}
	}
	return (void *)NULL;
  8017aa:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8017af:	c9                   	leave  
  8017b0:	c3                   	ret    

008017b1 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8017b1:	55                   	push   %ebp
  8017b2:	89 e5                	mov    %esp,%ebp
  8017b4:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017b7:	e8 12 fc ff ff       	call   8013ce <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8017bc:	83 ec 04             	sub    $0x4,%esp
  8017bf:	68 e8 3e 80 00       	push   $0x803ee8
  8017c4:	68 f1 00 00 00       	push   $0xf1
  8017c9:	68 93 3e 80 00       	push   $0x803e93
  8017ce:	e8 bd eb ff ff       	call   800390 <_panic>

008017d3 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8017d3:	55                   	push   %ebp
  8017d4:	89 e5                	mov    %esp,%ebp
  8017d6:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8017d9:	83 ec 04             	sub    $0x4,%esp
  8017dc:	68 10 3f 80 00       	push   $0x803f10
  8017e1:	68 05 01 00 00       	push   $0x105
  8017e6:	68 93 3e 80 00       	push   $0x803e93
  8017eb:	e8 a0 eb ff ff       	call   800390 <_panic>

008017f0 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8017f0:	55                   	push   %ebp
  8017f1:	89 e5                	mov    %esp,%ebp
  8017f3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017f6:	83 ec 04             	sub    $0x4,%esp
  8017f9:	68 34 3f 80 00       	push   $0x803f34
  8017fe:	68 10 01 00 00       	push   $0x110
  801803:	68 93 3e 80 00       	push   $0x803e93
  801808:	e8 83 eb ff ff       	call   800390 <_panic>

0080180d <shrink>:

}
void shrink(uint32 newSize)
{
  80180d:	55                   	push   %ebp
  80180e:	89 e5                	mov    %esp,%ebp
  801810:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801813:	83 ec 04             	sub    $0x4,%esp
  801816:	68 34 3f 80 00       	push   $0x803f34
  80181b:	68 15 01 00 00       	push   $0x115
  801820:	68 93 3e 80 00       	push   $0x803e93
  801825:	e8 66 eb ff ff       	call   800390 <_panic>

0080182a <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80182a:	55                   	push   %ebp
  80182b:	89 e5                	mov    %esp,%ebp
  80182d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801830:	83 ec 04             	sub    $0x4,%esp
  801833:	68 34 3f 80 00       	push   $0x803f34
  801838:	68 1a 01 00 00       	push   $0x11a
  80183d:	68 93 3e 80 00       	push   $0x803e93
  801842:	e8 49 eb ff ff       	call   800390 <_panic>

00801847 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801847:	55                   	push   %ebp
  801848:	89 e5                	mov    %esp,%ebp
  80184a:	57                   	push   %edi
  80184b:	56                   	push   %esi
  80184c:	53                   	push   %ebx
  80184d:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801850:	8b 45 08             	mov    0x8(%ebp),%eax
  801853:	8b 55 0c             	mov    0xc(%ebp),%edx
  801856:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801859:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80185c:	8b 7d 18             	mov    0x18(%ebp),%edi
  80185f:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801862:	cd 30                	int    $0x30
  801864:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801867:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80186a:	83 c4 10             	add    $0x10,%esp
  80186d:	5b                   	pop    %ebx
  80186e:	5e                   	pop    %esi
  80186f:	5f                   	pop    %edi
  801870:	5d                   	pop    %ebp
  801871:	c3                   	ret    

00801872 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801872:	55                   	push   %ebp
  801873:	89 e5                	mov    %esp,%ebp
  801875:	83 ec 04             	sub    $0x4,%esp
  801878:	8b 45 10             	mov    0x10(%ebp),%eax
  80187b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80187e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801882:	8b 45 08             	mov    0x8(%ebp),%eax
  801885:	6a 00                	push   $0x0
  801887:	6a 00                	push   $0x0
  801889:	52                   	push   %edx
  80188a:	ff 75 0c             	pushl  0xc(%ebp)
  80188d:	50                   	push   %eax
  80188e:	6a 00                	push   $0x0
  801890:	e8 b2 ff ff ff       	call   801847 <syscall>
  801895:	83 c4 18             	add    $0x18,%esp
}
  801898:	90                   	nop
  801899:	c9                   	leave  
  80189a:	c3                   	ret    

0080189b <sys_cgetc>:

int
sys_cgetc(void)
{
  80189b:	55                   	push   %ebp
  80189c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80189e:	6a 00                	push   $0x0
  8018a0:	6a 00                	push   $0x0
  8018a2:	6a 00                	push   $0x0
  8018a4:	6a 00                	push   $0x0
  8018a6:	6a 00                	push   $0x0
  8018a8:	6a 01                	push   $0x1
  8018aa:	e8 98 ff ff ff       	call   801847 <syscall>
  8018af:	83 c4 18             	add    $0x18,%esp
}
  8018b2:	c9                   	leave  
  8018b3:	c3                   	ret    

008018b4 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8018b4:	55                   	push   %ebp
  8018b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8018b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bd:	6a 00                	push   $0x0
  8018bf:	6a 00                	push   $0x0
  8018c1:	6a 00                	push   $0x0
  8018c3:	52                   	push   %edx
  8018c4:	50                   	push   %eax
  8018c5:	6a 05                	push   $0x5
  8018c7:	e8 7b ff ff ff       	call   801847 <syscall>
  8018cc:	83 c4 18             	add    $0x18,%esp
}
  8018cf:	c9                   	leave  
  8018d0:	c3                   	ret    

008018d1 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018d1:	55                   	push   %ebp
  8018d2:	89 e5                	mov    %esp,%ebp
  8018d4:	56                   	push   %esi
  8018d5:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018d6:	8b 75 18             	mov    0x18(%ebp),%esi
  8018d9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018dc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e5:	56                   	push   %esi
  8018e6:	53                   	push   %ebx
  8018e7:	51                   	push   %ecx
  8018e8:	52                   	push   %edx
  8018e9:	50                   	push   %eax
  8018ea:	6a 06                	push   $0x6
  8018ec:	e8 56 ff ff ff       	call   801847 <syscall>
  8018f1:	83 c4 18             	add    $0x18,%esp
}
  8018f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018f7:	5b                   	pop    %ebx
  8018f8:	5e                   	pop    %esi
  8018f9:	5d                   	pop    %ebp
  8018fa:	c3                   	ret    

008018fb <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8018fb:	55                   	push   %ebp
  8018fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8018fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801901:	8b 45 08             	mov    0x8(%ebp),%eax
  801904:	6a 00                	push   $0x0
  801906:	6a 00                	push   $0x0
  801908:	6a 00                	push   $0x0
  80190a:	52                   	push   %edx
  80190b:	50                   	push   %eax
  80190c:	6a 07                	push   $0x7
  80190e:	e8 34 ff ff ff       	call   801847 <syscall>
  801913:	83 c4 18             	add    $0x18,%esp
}
  801916:	c9                   	leave  
  801917:	c3                   	ret    

00801918 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801918:	55                   	push   %ebp
  801919:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80191b:	6a 00                	push   $0x0
  80191d:	6a 00                	push   $0x0
  80191f:	6a 00                	push   $0x0
  801921:	ff 75 0c             	pushl  0xc(%ebp)
  801924:	ff 75 08             	pushl  0x8(%ebp)
  801927:	6a 08                	push   $0x8
  801929:	e8 19 ff ff ff       	call   801847 <syscall>
  80192e:	83 c4 18             	add    $0x18,%esp
}
  801931:	c9                   	leave  
  801932:	c3                   	ret    

00801933 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801933:	55                   	push   %ebp
  801934:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801936:	6a 00                	push   $0x0
  801938:	6a 00                	push   $0x0
  80193a:	6a 00                	push   $0x0
  80193c:	6a 00                	push   $0x0
  80193e:	6a 00                	push   $0x0
  801940:	6a 09                	push   $0x9
  801942:	e8 00 ff ff ff       	call   801847 <syscall>
  801947:	83 c4 18             	add    $0x18,%esp
}
  80194a:	c9                   	leave  
  80194b:	c3                   	ret    

0080194c <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80194c:	55                   	push   %ebp
  80194d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80194f:	6a 00                	push   $0x0
  801951:	6a 00                	push   $0x0
  801953:	6a 00                	push   $0x0
  801955:	6a 00                	push   $0x0
  801957:	6a 00                	push   $0x0
  801959:	6a 0a                	push   $0xa
  80195b:	e8 e7 fe ff ff       	call   801847 <syscall>
  801960:	83 c4 18             	add    $0x18,%esp
}
  801963:	c9                   	leave  
  801964:	c3                   	ret    

00801965 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801965:	55                   	push   %ebp
  801966:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801968:	6a 00                	push   $0x0
  80196a:	6a 00                	push   $0x0
  80196c:	6a 00                	push   $0x0
  80196e:	6a 00                	push   $0x0
  801970:	6a 00                	push   $0x0
  801972:	6a 0b                	push   $0xb
  801974:	e8 ce fe ff ff       	call   801847 <syscall>
  801979:	83 c4 18             	add    $0x18,%esp
}
  80197c:	c9                   	leave  
  80197d:	c3                   	ret    

0080197e <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80197e:	55                   	push   %ebp
  80197f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801981:	6a 00                	push   $0x0
  801983:	6a 00                	push   $0x0
  801985:	6a 00                	push   $0x0
  801987:	ff 75 0c             	pushl  0xc(%ebp)
  80198a:	ff 75 08             	pushl  0x8(%ebp)
  80198d:	6a 0f                	push   $0xf
  80198f:	e8 b3 fe ff ff       	call   801847 <syscall>
  801994:	83 c4 18             	add    $0x18,%esp
	return;
  801997:	90                   	nop
}
  801998:	c9                   	leave  
  801999:	c3                   	ret    

0080199a <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80199a:	55                   	push   %ebp
  80199b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	ff 75 0c             	pushl  0xc(%ebp)
  8019a6:	ff 75 08             	pushl  0x8(%ebp)
  8019a9:	6a 10                	push   $0x10
  8019ab:	e8 97 fe ff ff       	call   801847 <syscall>
  8019b0:	83 c4 18             	add    $0x18,%esp
	return ;
  8019b3:	90                   	nop
}
  8019b4:	c9                   	leave  
  8019b5:	c3                   	ret    

008019b6 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8019b6:	55                   	push   %ebp
  8019b7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 00                	push   $0x0
  8019bd:	ff 75 10             	pushl  0x10(%ebp)
  8019c0:	ff 75 0c             	pushl  0xc(%ebp)
  8019c3:	ff 75 08             	pushl  0x8(%ebp)
  8019c6:	6a 11                	push   $0x11
  8019c8:	e8 7a fe ff ff       	call   801847 <syscall>
  8019cd:	83 c4 18             	add    $0x18,%esp
	return ;
  8019d0:	90                   	nop
}
  8019d1:	c9                   	leave  
  8019d2:	c3                   	ret    

008019d3 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8019d3:	55                   	push   %ebp
  8019d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8019d6:	6a 00                	push   $0x0
  8019d8:	6a 00                	push   $0x0
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 0c                	push   $0xc
  8019e2:	e8 60 fe ff ff       	call   801847 <syscall>
  8019e7:	83 c4 18             	add    $0x18,%esp
}
  8019ea:	c9                   	leave  
  8019eb:	c3                   	ret    

008019ec <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8019ec:	55                   	push   %ebp
  8019ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 00                	push   $0x0
  8019f5:	6a 00                	push   $0x0
  8019f7:	ff 75 08             	pushl  0x8(%ebp)
  8019fa:	6a 0d                	push   $0xd
  8019fc:	e8 46 fe ff ff       	call   801847 <syscall>
  801a01:	83 c4 18             	add    $0x18,%esp
}
  801a04:	c9                   	leave  
  801a05:	c3                   	ret    

00801a06 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a06:	55                   	push   %ebp
  801a07:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a09:	6a 00                	push   $0x0
  801a0b:	6a 00                	push   $0x0
  801a0d:	6a 00                	push   $0x0
  801a0f:	6a 00                	push   $0x0
  801a11:	6a 00                	push   $0x0
  801a13:	6a 0e                	push   $0xe
  801a15:	e8 2d fe ff ff       	call   801847 <syscall>
  801a1a:	83 c4 18             	add    $0x18,%esp
}
  801a1d:	90                   	nop
  801a1e:	c9                   	leave  
  801a1f:	c3                   	ret    

00801a20 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a20:	55                   	push   %ebp
  801a21:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a23:	6a 00                	push   $0x0
  801a25:	6a 00                	push   $0x0
  801a27:	6a 00                	push   $0x0
  801a29:	6a 00                	push   $0x0
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 13                	push   $0x13
  801a2f:	e8 13 fe ff ff       	call   801847 <syscall>
  801a34:	83 c4 18             	add    $0x18,%esp
}
  801a37:	90                   	nop
  801a38:	c9                   	leave  
  801a39:	c3                   	ret    

00801a3a <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a3a:	55                   	push   %ebp
  801a3b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a3d:	6a 00                	push   $0x0
  801a3f:	6a 00                	push   $0x0
  801a41:	6a 00                	push   $0x0
  801a43:	6a 00                	push   $0x0
  801a45:	6a 00                	push   $0x0
  801a47:	6a 14                	push   $0x14
  801a49:	e8 f9 fd ff ff       	call   801847 <syscall>
  801a4e:	83 c4 18             	add    $0x18,%esp
}
  801a51:	90                   	nop
  801a52:	c9                   	leave  
  801a53:	c3                   	ret    

00801a54 <sys_cputc>:


void
sys_cputc(const char c)
{
  801a54:	55                   	push   %ebp
  801a55:	89 e5                	mov    %esp,%ebp
  801a57:	83 ec 04             	sub    $0x4,%esp
  801a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a60:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a64:	6a 00                	push   $0x0
  801a66:	6a 00                	push   $0x0
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 00                	push   $0x0
  801a6c:	50                   	push   %eax
  801a6d:	6a 15                	push   $0x15
  801a6f:	e8 d3 fd ff ff       	call   801847 <syscall>
  801a74:	83 c4 18             	add    $0x18,%esp
}
  801a77:	90                   	nop
  801a78:	c9                   	leave  
  801a79:	c3                   	ret    

00801a7a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a7a:	55                   	push   %ebp
  801a7b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 00                	push   $0x0
  801a83:	6a 00                	push   $0x0
  801a85:	6a 00                	push   $0x0
  801a87:	6a 16                	push   $0x16
  801a89:	e8 b9 fd ff ff       	call   801847 <syscall>
  801a8e:	83 c4 18             	add    $0x18,%esp
}
  801a91:	90                   	nop
  801a92:	c9                   	leave  
  801a93:	c3                   	ret    

00801a94 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a94:	55                   	push   %ebp
  801a95:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a97:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 00                	push   $0x0
  801aa0:	ff 75 0c             	pushl  0xc(%ebp)
  801aa3:	50                   	push   %eax
  801aa4:	6a 17                	push   $0x17
  801aa6:	e8 9c fd ff ff       	call   801847 <syscall>
  801aab:	83 c4 18             	add    $0x18,%esp
}
  801aae:	c9                   	leave  
  801aaf:	c3                   	ret    

00801ab0 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801ab0:	55                   	push   %ebp
  801ab1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ab3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab9:	6a 00                	push   $0x0
  801abb:	6a 00                	push   $0x0
  801abd:	6a 00                	push   $0x0
  801abf:	52                   	push   %edx
  801ac0:	50                   	push   %eax
  801ac1:	6a 1a                	push   $0x1a
  801ac3:	e8 7f fd ff ff       	call   801847 <syscall>
  801ac8:	83 c4 18             	add    $0x18,%esp
}
  801acb:	c9                   	leave  
  801acc:	c3                   	ret    

00801acd <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801acd:	55                   	push   %ebp
  801ace:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ad0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad6:	6a 00                	push   $0x0
  801ad8:	6a 00                	push   $0x0
  801ada:	6a 00                	push   $0x0
  801adc:	52                   	push   %edx
  801add:	50                   	push   %eax
  801ade:	6a 18                	push   $0x18
  801ae0:	e8 62 fd ff ff       	call   801847 <syscall>
  801ae5:	83 c4 18             	add    $0x18,%esp
}
  801ae8:	90                   	nop
  801ae9:	c9                   	leave  
  801aea:	c3                   	ret    

00801aeb <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801aeb:	55                   	push   %ebp
  801aec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801aee:	8b 55 0c             	mov    0xc(%ebp),%edx
  801af1:	8b 45 08             	mov    0x8(%ebp),%eax
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	6a 00                	push   $0x0
  801afa:	52                   	push   %edx
  801afb:	50                   	push   %eax
  801afc:	6a 19                	push   $0x19
  801afe:	e8 44 fd ff ff       	call   801847 <syscall>
  801b03:	83 c4 18             	add    $0x18,%esp
}
  801b06:	90                   	nop
  801b07:	c9                   	leave  
  801b08:	c3                   	ret    

00801b09 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b09:	55                   	push   %ebp
  801b0a:	89 e5                	mov    %esp,%ebp
  801b0c:	83 ec 04             	sub    $0x4,%esp
  801b0f:	8b 45 10             	mov    0x10(%ebp),%eax
  801b12:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b15:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b18:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1f:	6a 00                	push   $0x0
  801b21:	51                   	push   %ecx
  801b22:	52                   	push   %edx
  801b23:	ff 75 0c             	pushl  0xc(%ebp)
  801b26:	50                   	push   %eax
  801b27:	6a 1b                	push   $0x1b
  801b29:	e8 19 fd ff ff       	call   801847 <syscall>
  801b2e:	83 c4 18             	add    $0x18,%esp
}
  801b31:	c9                   	leave  
  801b32:	c3                   	ret    

00801b33 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b33:	55                   	push   %ebp
  801b34:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b36:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b39:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 00                	push   $0x0
  801b42:	52                   	push   %edx
  801b43:	50                   	push   %eax
  801b44:	6a 1c                	push   $0x1c
  801b46:	e8 fc fc ff ff       	call   801847 <syscall>
  801b4b:	83 c4 18             	add    $0x18,%esp
}
  801b4e:	c9                   	leave  
  801b4f:	c3                   	ret    

00801b50 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b50:	55                   	push   %ebp
  801b51:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b53:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b56:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b59:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5c:	6a 00                	push   $0x0
  801b5e:	6a 00                	push   $0x0
  801b60:	51                   	push   %ecx
  801b61:	52                   	push   %edx
  801b62:	50                   	push   %eax
  801b63:	6a 1d                	push   $0x1d
  801b65:	e8 dd fc ff ff       	call   801847 <syscall>
  801b6a:	83 c4 18             	add    $0x18,%esp
}
  801b6d:	c9                   	leave  
  801b6e:	c3                   	ret    

00801b6f <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b6f:	55                   	push   %ebp
  801b70:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b72:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b75:	8b 45 08             	mov    0x8(%ebp),%eax
  801b78:	6a 00                	push   $0x0
  801b7a:	6a 00                	push   $0x0
  801b7c:	6a 00                	push   $0x0
  801b7e:	52                   	push   %edx
  801b7f:	50                   	push   %eax
  801b80:	6a 1e                	push   $0x1e
  801b82:	e8 c0 fc ff ff       	call   801847 <syscall>
  801b87:	83 c4 18             	add    $0x18,%esp
}
  801b8a:	c9                   	leave  
  801b8b:	c3                   	ret    

00801b8c <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b8c:	55                   	push   %ebp
  801b8d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 00                	push   $0x0
  801b93:	6a 00                	push   $0x0
  801b95:	6a 00                	push   $0x0
  801b97:	6a 00                	push   $0x0
  801b99:	6a 1f                	push   $0x1f
  801b9b:	e8 a7 fc ff ff       	call   801847 <syscall>
  801ba0:	83 c4 18             	add    $0x18,%esp
}
  801ba3:	c9                   	leave  
  801ba4:	c3                   	ret    

00801ba5 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801ba5:	55                   	push   %ebp
  801ba6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801ba8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bab:	6a 00                	push   $0x0
  801bad:	ff 75 14             	pushl  0x14(%ebp)
  801bb0:	ff 75 10             	pushl  0x10(%ebp)
  801bb3:	ff 75 0c             	pushl  0xc(%ebp)
  801bb6:	50                   	push   %eax
  801bb7:	6a 20                	push   $0x20
  801bb9:	e8 89 fc ff ff       	call   801847 <syscall>
  801bbe:	83 c4 18             	add    $0x18,%esp
}
  801bc1:	c9                   	leave  
  801bc2:	c3                   	ret    

00801bc3 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801bc3:	55                   	push   %ebp
  801bc4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801bc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc9:	6a 00                	push   $0x0
  801bcb:	6a 00                	push   $0x0
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 00                	push   $0x0
  801bd1:	50                   	push   %eax
  801bd2:	6a 21                	push   $0x21
  801bd4:	e8 6e fc ff ff       	call   801847 <syscall>
  801bd9:	83 c4 18             	add    $0x18,%esp
}
  801bdc:	90                   	nop
  801bdd:	c9                   	leave  
  801bde:	c3                   	ret    

00801bdf <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801bdf:	55                   	push   %ebp
  801be0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801be2:	8b 45 08             	mov    0x8(%ebp),%eax
  801be5:	6a 00                	push   $0x0
  801be7:	6a 00                	push   $0x0
  801be9:	6a 00                	push   $0x0
  801beb:	6a 00                	push   $0x0
  801bed:	50                   	push   %eax
  801bee:	6a 22                	push   $0x22
  801bf0:	e8 52 fc ff ff       	call   801847 <syscall>
  801bf5:	83 c4 18             	add    $0x18,%esp
}
  801bf8:	c9                   	leave  
  801bf9:	c3                   	ret    

00801bfa <sys_getenvid>:

int32 sys_getenvid(void)
{
  801bfa:	55                   	push   %ebp
  801bfb:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 00                	push   $0x0
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	6a 02                	push   $0x2
  801c09:	e8 39 fc ff ff       	call   801847 <syscall>
  801c0e:	83 c4 18             	add    $0x18,%esp
}
  801c11:	c9                   	leave  
  801c12:	c3                   	ret    

00801c13 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c13:	55                   	push   %ebp
  801c14:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c16:	6a 00                	push   $0x0
  801c18:	6a 00                	push   $0x0
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 03                	push   $0x3
  801c22:	e8 20 fc ff ff       	call   801847 <syscall>
  801c27:	83 c4 18             	add    $0x18,%esp
}
  801c2a:	c9                   	leave  
  801c2b:	c3                   	ret    

00801c2c <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c2c:	55                   	push   %ebp
  801c2d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 00                	push   $0x0
  801c33:	6a 00                	push   $0x0
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	6a 04                	push   $0x4
  801c3b:	e8 07 fc ff ff       	call   801847 <syscall>
  801c40:	83 c4 18             	add    $0x18,%esp
}
  801c43:	c9                   	leave  
  801c44:	c3                   	ret    

00801c45 <sys_exit_env>:


void sys_exit_env(void)
{
  801c45:	55                   	push   %ebp
  801c46:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 00                	push   $0x0
  801c52:	6a 23                	push   $0x23
  801c54:	e8 ee fb ff ff       	call   801847 <syscall>
  801c59:	83 c4 18             	add    $0x18,%esp
}
  801c5c:	90                   	nop
  801c5d:	c9                   	leave  
  801c5e:	c3                   	ret    

00801c5f <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c5f:	55                   	push   %ebp
  801c60:	89 e5                	mov    %esp,%ebp
  801c62:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c65:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c68:	8d 50 04             	lea    0x4(%eax),%edx
  801c6b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c6e:	6a 00                	push   $0x0
  801c70:	6a 00                	push   $0x0
  801c72:	6a 00                	push   $0x0
  801c74:	52                   	push   %edx
  801c75:	50                   	push   %eax
  801c76:	6a 24                	push   $0x24
  801c78:	e8 ca fb ff ff       	call   801847 <syscall>
  801c7d:	83 c4 18             	add    $0x18,%esp
	return result;
  801c80:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c83:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c86:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c89:	89 01                	mov    %eax,(%ecx)
  801c8b:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c91:	c9                   	leave  
  801c92:	c2 04 00             	ret    $0x4

00801c95 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c95:	55                   	push   %ebp
  801c96:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c98:	6a 00                	push   $0x0
  801c9a:	6a 00                	push   $0x0
  801c9c:	ff 75 10             	pushl  0x10(%ebp)
  801c9f:	ff 75 0c             	pushl  0xc(%ebp)
  801ca2:	ff 75 08             	pushl  0x8(%ebp)
  801ca5:	6a 12                	push   $0x12
  801ca7:	e8 9b fb ff ff       	call   801847 <syscall>
  801cac:	83 c4 18             	add    $0x18,%esp
	return ;
  801caf:	90                   	nop
}
  801cb0:	c9                   	leave  
  801cb1:	c3                   	ret    

00801cb2 <sys_rcr2>:
uint32 sys_rcr2()
{
  801cb2:	55                   	push   %ebp
  801cb3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801cb5:	6a 00                	push   $0x0
  801cb7:	6a 00                	push   $0x0
  801cb9:	6a 00                	push   $0x0
  801cbb:	6a 00                	push   $0x0
  801cbd:	6a 00                	push   $0x0
  801cbf:	6a 25                	push   $0x25
  801cc1:	e8 81 fb ff ff       	call   801847 <syscall>
  801cc6:	83 c4 18             	add    $0x18,%esp
}
  801cc9:	c9                   	leave  
  801cca:	c3                   	ret    

00801ccb <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801ccb:	55                   	push   %ebp
  801ccc:	89 e5                	mov    %esp,%ebp
  801cce:	83 ec 04             	sub    $0x4,%esp
  801cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801cd7:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801cdb:	6a 00                	push   $0x0
  801cdd:	6a 00                	push   $0x0
  801cdf:	6a 00                	push   $0x0
  801ce1:	6a 00                	push   $0x0
  801ce3:	50                   	push   %eax
  801ce4:	6a 26                	push   $0x26
  801ce6:	e8 5c fb ff ff       	call   801847 <syscall>
  801ceb:	83 c4 18             	add    $0x18,%esp
	return ;
  801cee:	90                   	nop
}
  801cef:	c9                   	leave  
  801cf0:	c3                   	ret    

00801cf1 <rsttst>:
void rsttst()
{
  801cf1:	55                   	push   %ebp
  801cf2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801cf4:	6a 00                	push   $0x0
  801cf6:	6a 00                	push   $0x0
  801cf8:	6a 00                	push   $0x0
  801cfa:	6a 00                	push   $0x0
  801cfc:	6a 00                	push   $0x0
  801cfe:	6a 28                	push   $0x28
  801d00:	e8 42 fb ff ff       	call   801847 <syscall>
  801d05:	83 c4 18             	add    $0x18,%esp
	return ;
  801d08:	90                   	nop
}
  801d09:	c9                   	leave  
  801d0a:	c3                   	ret    

00801d0b <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d0b:	55                   	push   %ebp
  801d0c:	89 e5                	mov    %esp,%ebp
  801d0e:	83 ec 04             	sub    $0x4,%esp
  801d11:	8b 45 14             	mov    0x14(%ebp),%eax
  801d14:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d17:	8b 55 18             	mov    0x18(%ebp),%edx
  801d1a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d1e:	52                   	push   %edx
  801d1f:	50                   	push   %eax
  801d20:	ff 75 10             	pushl  0x10(%ebp)
  801d23:	ff 75 0c             	pushl  0xc(%ebp)
  801d26:	ff 75 08             	pushl  0x8(%ebp)
  801d29:	6a 27                	push   $0x27
  801d2b:	e8 17 fb ff ff       	call   801847 <syscall>
  801d30:	83 c4 18             	add    $0x18,%esp
	return ;
  801d33:	90                   	nop
}
  801d34:	c9                   	leave  
  801d35:	c3                   	ret    

00801d36 <chktst>:
void chktst(uint32 n)
{
  801d36:	55                   	push   %ebp
  801d37:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d39:	6a 00                	push   $0x0
  801d3b:	6a 00                	push   $0x0
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 00                	push   $0x0
  801d41:	ff 75 08             	pushl  0x8(%ebp)
  801d44:	6a 29                	push   $0x29
  801d46:	e8 fc fa ff ff       	call   801847 <syscall>
  801d4b:	83 c4 18             	add    $0x18,%esp
	return ;
  801d4e:	90                   	nop
}
  801d4f:	c9                   	leave  
  801d50:	c3                   	ret    

00801d51 <inctst>:

void inctst()
{
  801d51:	55                   	push   %ebp
  801d52:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d54:	6a 00                	push   $0x0
  801d56:	6a 00                	push   $0x0
  801d58:	6a 00                	push   $0x0
  801d5a:	6a 00                	push   $0x0
  801d5c:	6a 00                	push   $0x0
  801d5e:	6a 2a                	push   $0x2a
  801d60:	e8 e2 fa ff ff       	call   801847 <syscall>
  801d65:	83 c4 18             	add    $0x18,%esp
	return ;
  801d68:	90                   	nop
}
  801d69:	c9                   	leave  
  801d6a:	c3                   	ret    

00801d6b <gettst>:
uint32 gettst()
{
  801d6b:	55                   	push   %ebp
  801d6c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d6e:	6a 00                	push   $0x0
  801d70:	6a 00                	push   $0x0
  801d72:	6a 00                	push   $0x0
  801d74:	6a 00                	push   $0x0
  801d76:	6a 00                	push   $0x0
  801d78:	6a 2b                	push   $0x2b
  801d7a:	e8 c8 fa ff ff       	call   801847 <syscall>
  801d7f:	83 c4 18             	add    $0x18,%esp
}
  801d82:	c9                   	leave  
  801d83:	c3                   	ret    

00801d84 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d84:	55                   	push   %ebp
  801d85:	89 e5                	mov    %esp,%ebp
  801d87:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d8a:	6a 00                	push   $0x0
  801d8c:	6a 00                	push   $0x0
  801d8e:	6a 00                	push   $0x0
  801d90:	6a 00                	push   $0x0
  801d92:	6a 00                	push   $0x0
  801d94:	6a 2c                	push   $0x2c
  801d96:	e8 ac fa ff ff       	call   801847 <syscall>
  801d9b:	83 c4 18             	add    $0x18,%esp
  801d9e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801da1:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801da5:	75 07                	jne    801dae <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801da7:	b8 01 00 00 00       	mov    $0x1,%eax
  801dac:	eb 05                	jmp    801db3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801dae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801db3:	c9                   	leave  
  801db4:	c3                   	ret    

00801db5 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801db5:	55                   	push   %ebp
  801db6:	89 e5                	mov    %esp,%ebp
  801db8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dbb:	6a 00                	push   $0x0
  801dbd:	6a 00                	push   $0x0
  801dbf:	6a 00                	push   $0x0
  801dc1:	6a 00                	push   $0x0
  801dc3:	6a 00                	push   $0x0
  801dc5:	6a 2c                	push   $0x2c
  801dc7:	e8 7b fa ff ff       	call   801847 <syscall>
  801dcc:	83 c4 18             	add    $0x18,%esp
  801dcf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801dd2:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801dd6:	75 07                	jne    801ddf <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801dd8:	b8 01 00 00 00       	mov    $0x1,%eax
  801ddd:	eb 05                	jmp    801de4 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801ddf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801de4:	c9                   	leave  
  801de5:	c3                   	ret    

00801de6 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801de6:	55                   	push   %ebp
  801de7:	89 e5                	mov    %esp,%ebp
  801de9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dec:	6a 00                	push   $0x0
  801dee:	6a 00                	push   $0x0
  801df0:	6a 00                	push   $0x0
  801df2:	6a 00                	push   $0x0
  801df4:	6a 00                	push   $0x0
  801df6:	6a 2c                	push   $0x2c
  801df8:	e8 4a fa ff ff       	call   801847 <syscall>
  801dfd:	83 c4 18             	add    $0x18,%esp
  801e00:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e03:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e07:	75 07                	jne    801e10 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e09:	b8 01 00 00 00       	mov    $0x1,%eax
  801e0e:	eb 05                	jmp    801e15 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e10:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e15:	c9                   	leave  
  801e16:	c3                   	ret    

00801e17 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e17:	55                   	push   %ebp
  801e18:	89 e5                	mov    %esp,%ebp
  801e1a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e1d:	6a 00                	push   $0x0
  801e1f:	6a 00                	push   $0x0
  801e21:	6a 00                	push   $0x0
  801e23:	6a 00                	push   $0x0
  801e25:	6a 00                	push   $0x0
  801e27:	6a 2c                	push   $0x2c
  801e29:	e8 19 fa ff ff       	call   801847 <syscall>
  801e2e:	83 c4 18             	add    $0x18,%esp
  801e31:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e34:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e38:	75 07                	jne    801e41 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e3a:	b8 01 00 00 00       	mov    $0x1,%eax
  801e3f:	eb 05                	jmp    801e46 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e41:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e46:	c9                   	leave  
  801e47:	c3                   	ret    

00801e48 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e48:	55                   	push   %ebp
  801e49:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e4b:	6a 00                	push   $0x0
  801e4d:	6a 00                	push   $0x0
  801e4f:	6a 00                	push   $0x0
  801e51:	6a 00                	push   $0x0
  801e53:	ff 75 08             	pushl  0x8(%ebp)
  801e56:	6a 2d                	push   $0x2d
  801e58:	e8 ea f9 ff ff       	call   801847 <syscall>
  801e5d:	83 c4 18             	add    $0x18,%esp
	return ;
  801e60:	90                   	nop
}
  801e61:	c9                   	leave  
  801e62:	c3                   	ret    

00801e63 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e63:	55                   	push   %ebp
  801e64:	89 e5                	mov    %esp,%ebp
  801e66:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e67:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e6a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e6d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e70:	8b 45 08             	mov    0x8(%ebp),%eax
  801e73:	6a 00                	push   $0x0
  801e75:	53                   	push   %ebx
  801e76:	51                   	push   %ecx
  801e77:	52                   	push   %edx
  801e78:	50                   	push   %eax
  801e79:	6a 2e                	push   $0x2e
  801e7b:	e8 c7 f9 ff ff       	call   801847 <syscall>
  801e80:	83 c4 18             	add    $0x18,%esp
}
  801e83:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e86:	c9                   	leave  
  801e87:	c3                   	ret    

00801e88 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e88:	55                   	push   %ebp
  801e89:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e91:	6a 00                	push   $0x0
  801e93:	6a 00                	push   $0x0
  801e95:	6a 00                	push   $0x0
  801e97:	52                   	push   %edx
  801e98:	50                   	push   %eax
  801e99:	6a 2f                	push   $0x2f
  801e9b:	e8 a7 f9 ff ff       	call   801847 <syscall>
  801ea0:	83 c4 18             	add    $0x18,%esp
}
  801ea3:	c9                   	leave  
  801ea4:	c3                   	ret    

00801ea5 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801ea5:	55                   	push   %ebp
  801ea6:	89 e5                	mov    %esp,%ebp
  801ea8:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801eab:	83 ec 0c             	sub    $0xc,%esp
  801eae:	68 44 3f 80 00       	push   $0x803f44
  801eb3:	e8 8c e7 ff ff       	call   800644 <cprintf>
  801eb8:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801ebb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801ec2:	83 ec 0c             	sub    $0xc,%esp
  801ec5:	68 70 3f 80 00       	push   $0x803f70
  801eca:	e8 75 e7 ff ff       	call   800644 <cprintf>
  801ecf:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801ed2:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ed6:	a1 38 51 80 00       	mov    0x805138,%eax
  801edb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ede:	eb 56                	jmp    801f36 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801ee0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ee4:	74 1c                	je     801f02 <print_mem_block_lists+0x5d>
  801ee6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee9:	8b 50 08             	mov    0x8(%eax),%edx
  801eec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eef:	8b 48 08             	mov    0x8(%eax),%ecx
  801ef2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ef5:	8b 40 0c             	mov    0xc(%eax),%eax
  801ef8:	01 c8                	add    %ecx,%eax
  801efa:	39 c2                	cmp    %eax,%edx
  801efc:	73 04                	jae    801f02 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801efe:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f05:	8b 50 08             	mov    0x8(%eax),%edx
  801f08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f0b:	8b 40 0c             	mov    0xc(%eax),%eax
  801f0e:	01 c2                	add    %eax,%edx
  801f10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f13:	8b 40 08             	mov    0x8(%eax),%eax
  801f16:	83 ec 04             	sub    $0x4,%esp
  801f19:	52                   	push   %edx
  801f1a:	50                   	push   %eax
  801f1b:	68 85 3f 80 00       	push   $0x803f85
  801f20:	e8 1f e7 ff ff       	call   800644 <cprintf>
  801f25:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f2e:	a1 40 51 80 00       	mov    0x805140,%eax
  801f33:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f36:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f3a:	74 07                	je     801f43 <print_mem_block_lists+0x9e>
  801f3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f3f:	8b 00                	mov    (%eax),%eax
  801f41:	eb 05                	jmp    801f48 <print_mem_block_lists+0xa3>
  801f43:	b8 00 00 00 00       	mov    $0x0,%eax
  801f48:	a3 40 51 80 00       	mov    %eax,0x805140
  801f4d:	a1 40 51 80 00       	mov    0x805140,%eax
  801f52:	85 c0                	test   %eax,%eax
  801f54:	75 8a                	jne    801ee0 <print_mem_block_lists+0x3b>
  801f56:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f5a:	75 84                	jne    801ee0 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801f5c:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f60:	75 10                	jne    801f72 <print_mem_block_lists+0xcd>
  801f62:	83 ec 0c             	sub    $0xc,%esp
  801f65:	68 94 3f 80 00       	push   $0x803f94
  801f6a:	e8 d5 e6 ff ff       	call   800644 <cprintf>
  801f6f:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f72:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f79:	83 ec 0c             	sub    $0xc,%esp
  801f7c:	68 b8 3f 80 00       	push   $0x803fb8
  801f81:	e8 be e6 ff ff       	call   800644 <cprintf>
  801f86:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f89:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f8d:	a1 40 50 80 00       	mov    0x805040,%eax
  801f92:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f95:	eb 56                	jmp    801fed <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f97:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f9b:	74 1c                	je     801fb9 <print_mem_block_lists+0x114>
  801f9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa0:	8b 50 08             	mov    0x8(%eax),%edx
  801fa3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fa6:	8b 48 08             	mov    0x8(%eax),%ecx
  801fa9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fac:	8b 40 0c             	mov    0xc(%eax),%eax
  801faf:	01 c8                	add    %ecx,%eax
  801fb1:	39 c2                	cmp    %eax,%edx
  801fb3:	73 04                	jae    801fb9 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801fb5:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801fb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fbc:	8b 50 08             	mov    0x8(%eax),%edx
  801fbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc2:	8b 40 0c             	mov    0xc(%eax),%eax
  801fc5:	01 c2                	add    %eax,%edx
  801fc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fca:	8b 40 08             	mov    0x8(%eax),%eax
  801fcd:	83 ec 04             	sub    $0x4,%esp
  801fd0:	52                   	push   %edx
  801fd1:	50                   	push   %eax
  801fd2:	68 85 3f 80 00       	push   $0x803f85
  801fd7:	e8 68 e6 ff ff       	call   800644 <cprintf>
  801fdc:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801fdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801fe5:	a1 48 50 80 00       	mov    0x805048,%eax
  801fea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ff1:	74 07                	je     801ffa <print_mem_block_lists+0x155>
  801ff3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff6:	8b 00                	mov    (%eax),%eax
  801ff8:	eb 05                	jmp    801fff <print_mem_block_lists+0x15a>
  801ffa:	b8 00 00 00 00       	mov    $0x0,%eax
  801fff:	a3 48 50 80 00       	mov    %eax,0x805048
  802004:	a1 48 50 80 00       	mov    0x805048,%eax
  802009:	85 c0                	test   %eax,%eax
  80200b:	75 8a                	jne    801f97 <print_mem_block_lists+0xf2>
  80200d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802011:	75 84                	jne    801f97 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802013:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802017:	75 10                	jne    802029 <print_mem_block_lists+0x184>
  802019:	83 ec 0c             	sub    $0xc,%esp
  80201c:	68 d0 3f 80 00       	push   $0x803fd0
  802021:	e8 1e e6 ff ff       	call   800644 <cprintf>
  802026:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802029:	83 ec 0c             	sub    $0xc,%esp
  80202c:	68 44 3f 80 00       	push   $0x803f44
  802031:	e8 0e e6 ff ff       	call   800644 <cprintf>
  802036:	83 c4 10             	add    $0x10,%esp

}
  802039:	90                   	nop
  80203a:	c9                   	leave  
  80203b:	c3                   	ret    

0080203c <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80203c:	55                   	push   %ebp
  80203d:	89 e5                	mov    %esp,%ebp
  80203f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  802042:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802049:	00 00 00 
  80204c:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802053:	00 00 00 
  802056:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  80205d:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802060:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802067:	e9 9e 00 00 00       	jmp    80210a <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  80206c:	a1 50 50 80 00       	mov    0x805050,%eax
  802071:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802074:	c1 e2 04             	shl    $0x4,%edx
  802077:	01 d0                	add    %edx,%eax
  802079:	85 c0                	test   %eax,%eax
  80207b:	75 14                	jne    802091 <initialize_MemBlocksList+0x55>
  80207d:	83 ec 04             	sub    $0x4,%esp
  802080:	68 f8 3f 80 00       	push   $0x803ff8
  802085:	6a 46                	push   $0x46
  802087:	68 1b 40 80 00       	push   $0x80401b
  80208c:	e8 ff e2 ff ff       	call   800390 <_panic>
  802091:	a1 50 50 80 00       	mov    0x805050,%eax
  802096:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802099:	c1 e2 04             	shl    $0x4,%edx
  80209c:	01 d0                	add    %edx,%eax
  80209e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8020a4:	89 10                	mov    %edx,(%eax)
  8020a6:	8b 00                	mov    (%eax),%eax
  8020a8:	85 c0                	test   %eax,%eax
  8020aa:	74 18                	je     8020c4 <initialize_MemBlocksList+0x88>
  8020ac:	a1 48 51 80 00       	mov    0x805148,%eax
  8020b1:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8020b7:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8020ba:	c1 e1 04             	shl    $0x4,%ecx
  8020bd:	01 ca                	add    %ecx,%edx
  8020bf:	89 50 04             	mov    %edx,0x4(%eax)
  8020c2:	eb 12                	jmp    8020d6 <initialize_MemBlocksList+0x9a>
  8020c4:	a1 50 50 80 00       	mov    0x805050,%eax
  8020c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020cc:	c1 e2 04             	shl    $0x4,%edx
  8020cf:	01 d0                	add    %edx,%eax
  8020d1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8020d6:	a1 50 50 80 00       	mov    0x805050,%eax
  8020db:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020de:	c1 e2 04             	shl    $0x4,%edx
  8020e1:	01 d0                	add    %edx,%eax
  8020e3:	a3 48 51 80 00       	mov    %eax,0x805148
  8020e8:	a1 50 50 80 00       	mov    0x805050,%eax
  8020ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020f0:	c1 e2 04             	shl    $0x4,%edx
  8020f3:	01 d0                	add    %edx,%eax
  8020f5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020fc:	a1 54 51 80 00       	mov    0x805154,%eax
  802101:	40                   	inc    %eax
  802102:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802107:	ff 45 f4             	incl   -0xc(%ebp)
  80210a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80210d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802110:	0f 82 56 ff ff ff    	jb     80206c <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802116:	90                   	nop
  802117:	c9                   	leave  
  802118:	c3                   	ret    

00802119 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802119:	55                   	push   %ebp
  80211a:	89 e5                	mov    %esp,%ebp
  80211c:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80211f:	8b 45 08             	mov    0x8(%ebp),%eax
  802122:	8b 00                	mov    (%eax),%eax
  802124:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802127:	eb 19                	jmp    802142 <find_block+0x29>
	{
		if(va==point->sva)
  802129:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80212c:	8b 40 08             	mov    0x8(%eax),%eax
  80212f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802132:	75 05                	jne    802139 <find_block+0x20>
		   return point;
  802134:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802137:	eb 36                	jmp    80216f <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802139:	8b 45 08             	mov    0x8(%ebp),%eax
  80213c:	8b 40 08             	mov    0x8(%eax),%eax
  80213f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802142:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802146:	74 07                	je     80214f <find_block+0x36>
  802148:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80214b:	8b 00                	mov    (%eax),%eax
  80214d:	eb 05                	jmp    802154 <find_block+0x3b>
  80214f:	b8 00 00 00 00       	mov    $0x0,%eax
  802154:	8b 55 08             	mov    0x8(%ebp),%edx
  802157:	89 42 08             	mov    %eax,0x8(%edx)
  80215a:	8b 45 08             	mov    0x8(%ebp),%eax
  80215d:	8b 40 08             	mov    0x8(%eax),%eax
  802160:	85 c0                	test   %eax,%eax
  802162:	75 c5                	jne    802129 <find_block+0x10>
  802164:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802168:	75 bf                	jne    802129 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  80216a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80216f:	c9                   	leave  
  802170:	c3                   	ret    

00802171 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802171:	55                   	push   %ebp
  802172:	89 e5                	mov    %esp,%ebp
  802174:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802177:	a1 40 50 80 00       	mov    0x805040,%eax
  80217c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  80217f:	a1 44 50 80 00       	mov    0x805044,%eax
  802184:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802187:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80218a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80218d:	74 24                	je     8021b3 <insert_sorted_allocList+0x42>
  80218f:	8b 45 08             	mov    0x8(%ebp),%eax
  802192:	8b 50 08             	mov    0x8(%eax),%edx
  802195:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802198:	8b 40 08             	mov    0x8(%eax),%eax
  80219b:	39 c2                	cmp    %eax,%edx
  80219d:	76 14                	jbe    8021b3 <insert_sorted_allocList+0x42>
  80219f:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a2:	8b 50 08             	mov    0x8(%eax),%edx
  8021a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021a8:	8b 40 08             	mov    0x8(%eax),%eax
  8021ab:	39 c2                	cmp    %eax,%edx
  8021ad:	0f 82 60 01 00 00    	jb     802313 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8021b3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021b7:	75 65                	jne    80221e <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8021b9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021bd:	75 14                	jne    8021d3 <insert_sorted_allocList+0x62>
  8021bf:	83 ec 04             	sub    $0x4,%esp
  8021c2:	68 f8 3f 80 00       	push   $0x803ff8
  8021c7:	6a 6b                	push   $0x6b
  8021c9:	68 1b 40 80 00       	push   $0x80401b
  8021ce:	e8 bd e1 ff ff       	call   800390 <_panic>
  8021d3:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8021d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021dc:	89 10                	mov    %edx,(%eax)
  8021de:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e1:	8b 00                	mov    (%eax),%eax
  8021e3:	85 c0                	test   %eax,%eax
  8021e5:	74 0d                	je     8021f4 <insert_sorted_allocList+0x83>
  8021e7:	a1 40 50 80 00       	mov    0x805040,%eax
  8021ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8021ef:	89 50 04             	mov    %edx,0x4(%eax)
  8021f2:	eb 08                	jmp    8021fc <insert_sorted_allocList+0x8b>
  8021f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f7:	a3 44 50 80 00       	mov    %eax,0x805044
  8021fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ff:	a3 40 50 80 00       	mov    %eax,0x805040
  802204:	8b 45 08             	mov    0x8(%ebp),%eax
  802207:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80220e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802213:	40                   	inc    %eax
  802214:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802219:	e9 dc 01 00 00       	jmp    8023fa <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  80221e:	8b 45 08             	mov    0x8(%ebp),%eax
  802221:	8b 50 08             	mov    0x8(%eax),%edx
  802224:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802227:	8b 40 08             	mov    0x8(%eax),%eax
  80222a:	39 c2                	cmp    %eax,%edx
  80222c:	77 6c                	ja     80229a <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  80222e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802232:	74 06                	je     80223a <insert_sorted_allocList+0xc9>
  802234:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802238:	75 14                	jne    80224e <insert_sorted_allocList+0xdd>
  80223a:	83 ec 04             	sub    $0x4,%esp
  80223d:	68 34 40 80 00       	push   $0x804034
  802242:	6a 6f                	push   $0x6f
  802244:	68 1b 40 80 00       	push   $0x80401b
  802249:	e8 42 e1 ff ff       	call   800390 <_panic>
  80224e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802251:	8b 50 04             	mov    0x4(%eax),%edx
  802254:	8b 45 08             	mov    0x8(%ebp),%eax
  802257:	89 50 04             	mov    %edx,0x4(%eax)
  80225a:	8b 45 08             	mov    0x8(%ebp),%eax
  80225d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802260:	89 10                	mov    %edx,(%eax)
  802262:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802265:	8b 40 04             	mov    0x4(%eax),%eax
  802268:	85 c0                	test   %eax,%eax
  80226a:	74 0d                	je     802279 <insert_sorted_allocList+0x108>
  80226c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80226f:	8b 40 04             	mov    0x4(%eax),%eax
  802272:	8b 55 08             	mov    0x8(%ebp),%edx
  802275:	89 10                	mov    %edx,(%eax)
  802277:	eb 08                	jmp    802281 <insert_sorted_allocList+0x110>
  802279:	8b 45 08             	mov    0x8(%ebp),%eax
  80227c:	a3 40 50 80 00       	mov    %eax,0x805040
  802281:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802284:	8b 55 08             	mov    0x8(%ebp),%edx
  802287:	89 50 04             	mov    %edx,0x4(%eax)
  80228a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80228f:	40                   	inc    %eax
  802290:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802295:	e9 60 01 00 00       	jmp    8023fa <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  80229a:	8b 45 08             	mov    0x8(%ebp),%eax
  80229d:	8b 50 08             	mov    0x8(%eax),%edx
  8022a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022a3:	8b 40 08             	mov    0x8(%eax),%eax
  8022a6:	39 c2                	cmp    %eax,%edx
  8022a8:	0f 82 4c 01 00 00    	jb     8023fa <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8022ae:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022b2:	75 14                	jne    8022c8 <insert_sorted_allocList+0x157>
  8022b4:	83 ec 04             	sub    $0x4,%esp
  8022b7:	68 6c 40 80 00       	push   $0x80406c
  8022bc:	6a 73                	push   $0x73
  8022be:	68 1b 40 80 00       	push   $0x80401b
  8022c3:	e8 c8 e0 ff ff       	call   800390 <_panic>
  8022c8:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8022ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d1:	89 50 04             	mov    %edx,0x4(%eax)
  8022d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d7:	8b 40 04             	mov    0x4(%eax),%eax
  8022da:	85 c0                	test   %eax,%eax
  8022dc:	74 0c                	je     8022ea <insert_sorted_allocList+0x179>
  8022de:	a1 44 50 80 00       	mov    0x805044,%eax
  8022e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8022e6:	89 10                	mov    %edx,(%eax)
  8022e8:	eb 08                	jmp    8022f2 <insert_sorted_allocList+0x181>
  8022ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ed:	a3 40 50 80 00       	mov    %eax,0x805040
  8022f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f5:	a3 44 50 80 00       	mov    %eax,0x805044
  8022fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802303:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802308:	40                   	inc    %eax
  802309:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80230e:	e9 e7 00 00 00       	jmp    8023fa <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802313:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802316:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802319:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802320:	a1 40 50 80 00       	mov    0x805040,%eax
  802325:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802328:	e9 9d 00 00 00       	jmp    8023ca <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  80232d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802330:	8b 00                	mov    (%eax),%eax
  802332:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802335:	8b 45 08             	mov    0x8(%ebp),%eax
  802338:	8b 50 08             	mov    0x8(%eax),%edx
  80233b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233e:	8b 40 08             	mov    0x8(%eax),%eax
  802341:	39 c2                	cmp    %eax,%edx
  802343:	76 7d                	jbe    8023c2 <insert_sorted_allocList+0x251>
  802345:	8b 45 08             	mov    0x8(%ebp),%eax
  802348:	8b 50 08             	mov    0x8(%eax),%edx
  80234b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80234e:	8b 40 08             	mov    0x8(%eax),%eax
  802351:	39 c2                	cmp    %eax,%edx
  802353:	73 6d                	jae    8023c2 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802355:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802359:	74 06                	je     802361 <insert_sorted_allocList+0x1f0>
  80235b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80235f:	75 14                	jne    802375 <insert_sorted_allocList+0x204>
  802361:	83 ec 04             	sub    $0x4,%esp
  802364:	68 90 40 80 00       	push   $0x804090
  802369:	6a 7f                	push   $0x7f
  80236b:	68 1b 40 80 00       	push   $0x80401b
  802370:	e8 1b e0 ff ff       	call   800390 <_panic>
  802375:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802378:	8b 10                	mov    (%eax),%edx
  80237a:	8b 45 08             	mov    0x8(%ebp),%eax
  80237d:	89 10                	mov    %edx,(%eax)
  80237f:	8b 45 08             	mov    0x8(%ebp),%eax
  802382:	8b 00                	mov    (%eax),%eax
  802384:	85 c0                	test   %eax,%eax
  802386:	74 0b                	je     802393 <insert_sorted_allocList+0x222>
  802388:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238b:	8b 00                	mov    (%eax),%eax
  80238d:	8b 55 08             	mov    0x8(%ebp),%edx
  802390:	89 50 04             	mov    %edx,0x4(%eax)
  802393:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802396:	8b 55 08             	mov    0x8(%ebp),%edx
  802399:	89 10                	mov    %edx,(%eax)
  80239b:	8b 45 08             	mov    0x8(%ebp),%eax
  80239e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023a1:	89 50 04             	mov    %edx,0x4(%eax)
  8023a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a7:	8b 00                	mov    (%eax),%eax
  8023a9:	85 c0                	test   %eax,%eax
  8023ab:	75 08                	jne    8023b5 <insert_sorted_allocList+0x244>
  8023ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b0:	a3 44 50 80 00       	mov    %eax,0x805044
  8023b5:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8023ba:	40                   	inc    %eax
  8023bb:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8023c0:	eb 39                	jmp    8023fb <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8023c2:	a1 48 50 80 00       	mov    0x805048,%eax
  8023c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023ce:	74 07                	je     8023d7 <insert_sorted_allocList+0x266>
  8023d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d3:	8b 00                	mov    (%eax),%eax
  8023d5:	eb 05                	jmp    8023dc <insert_sorted_allocList+0x26b>
  8023d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8023dc:	a3 48 50 80 00       	mov    %eax,0x805048
  8023e1:	a1 48 50 80 00       	mov    0x805048,%eax
  8023e6:	85 c0                	test   %eax,%eax
  8023e8:	0f 85 3f ff ff ff    	jne    80232d <insert_sorted_allocList+0x1bc>
  8023ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023f2:	0f 85 35 ff ff ff    	jne    80232d <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8023f8:	eb 01                	jmp    8023fb <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8023fa:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8023fb:	90                   	nop
  8023fc:	c9                   	leave  
  8023fd:	c3                   	ret    

008023fe <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8023fe:	55                   	push   %ebp
  8023ff:	89 e5                	mov    %esp,%ebp
  802401:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802404:	a1 38 51 80 00       	mov    0x805138,%eax
  802409:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80240c:	e9 85 01 00 00       	jmp    802596 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802411:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802414:	8b 40 0c             	mov    0xc(%eax),%eax
  802417:	3b 45 08             	cmp    0x8(%ebp),%eax
  80241a:	0f 82 6e 01 00 00    	jb     80258e <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802420:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802423:	8b 40 0c             	mov    0xc(%eax),%eax
  802426:	3b 45 08             	cmp    0x8(%ebp),%eax
  802429:	0f 85 8a 00 00 00    	jne    8024b9 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  80242f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802433:	75 17                	jne    80244c <alloc_block_FF+0x4e>
  802435:	83 ec 04             	sub    $0x4,%esp
  802438:	68 c4 40 80 00       	push   $0x8040c4
  80243d:	68 93 00 00 00       	push   $0x93
  802442:	68 1b 40 80 00       	push   $0x80401b
  802447:	e8 44 df ff ff       	call   800390 <_panic>
  80244c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244f:	8b 00                	mov    (%eax),%eax
  802451:	85 c0                	test   %eax,%eax
  802453:	74 10                	je     802465 <alloc_block_FF+0x67>
  802455:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802458:	8b 00                	mov    (%eax),%eax
  80245a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80245d:	8b 52 04             	mov    0x4(%edx),%edx
  802460:	89 50 04             	mov    %edx,0x4(%eax)
  802463:	eb 0b                	jmp    802470 <alloc_block_FF+0x72>
  802465:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802468:	8b 40 04             	mov    0x4(%eax),%eax
  80246b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802470:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802473:	8b 40 04             	mov    0x4(%eax),%eax
  802476:	85 c0                	test   %eax,%eax
  802478:	74 0f                	je     802489 <alloc_block_FF+0x8b>
  80247a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247d:	8b 40 04             	mov    0x4(%eax),%eax
  802480:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802483:	8b 12                	mov    (%edx),%edx
  802485:	89 10                	mov    %edx,(%eax)
  802487:	eb 0a                	jmp    802493 <alloc_block_FF+0x95>
  802489:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248c:	8b 00                	mov    (%eax),%eax
  80248e:	a3 38 51 80 00       	mov    %eax,0x805138
  802493:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802496:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80249c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024a6:	a1 44 51 80 00       	mov    0x805144,%eax
  8024ab:	48                   	dec    %eax
  8024ac:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  8024b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b4:	e9 10 01 00 00       	jmp    8025c9 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8024b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8024bf:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024c2:	0f 86 c6 00 00 00    	jbe    80258e <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8024c8:	a1 48 51 80 00       	mov    0x805148,%eax
  8024cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8024d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d3:	8b 50 08             	mov    0x8(%eax),%edx
  8024d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024d9:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8024dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024df:	8b 55 08             	mov    0x8(%ebp),%edx
  8024e2:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8024e5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024e9:	75 17                	jne    802502 <alloc_block_FF+0x104>
  8024eb:	83 ec 04             	sub    $0x4,%esp
  8024ee:	68 c4 40 80 00       	push   $0x8040c4
  8024f3:	68 9b 00 00 00       	push   $0x9b
  8024f8:	68 1b 40 80 00       	push   $0x80401b
  8024fd:	e8 8e de ff ff       	call   800390 <_panic>
  802502:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802505:	8b 00                	mov    (%eax),%eax
  802507:	85 c0                	test   %eax,%eax
  802509:	74 10                	je     80251b <alloc_block_FF+0x11d>
  80250b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80250e:	8b 00                	mov    (%eax),%eax
  802510:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802513:	8b 52 04             	mov    0x4(%edx),%edx
  802516:	89 50 04             	mov    %edx,0x4(%eax)
  802519:	eb 0b                	jmp    802526 <alloc_block_FF+0x128>
  80251b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80251e:	8b 40 04             	mov    0x4(%eax),%eax
  802521:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802526:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802529:	8b 40 04             	mov    0x4(%eax),%eax
  80252c:	85 c0                	test   %eax,%eax
  80252e:	74 0f                	je     80253f <alloc_block_FF+0x141>
  802530:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802533:	8b 40 04             	mov    0x4(%eax),%eax
  802536:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802539:	8b 12                	mov    (%edx),%edx
  80253b:	89 10                	mov    %edx,(%eax)
  80253d:	eb 0a                	jmp    802549 <alloc_block_FF+0x14b>
  80253f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802542:	8b 00                	mov    (%eax),%eax
  802544:	a3 48 51 80 00       	mov    %eax,0x805148
  802549:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80254c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802552:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802555:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80255c:	a1 54 51 80 00       	mov    0x805154,%eax
  802561:	48                   	dec    %eax
  802562:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802567:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256a:	8b 50 08             	mov    0x8(%eax),%edx
  80256d:	8b 45 08             	mov    0x8(%ebp),%eax
  802570:	01 c2                	add    %eax,%edx
  802572:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802575:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802578:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257b:	8b 40 0c             	mov    0xc(%eax),%eax
  80257e:	2b 45 08             	sub    0x8(%ebp),%eax
  802581:	89 c2                	mov    %eax,%edx
  802583:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802586:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802589:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80258c:	eb 3b                	jmp    8025c9 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80258e:	a1 40 51 80 00       	mov    0x805140,%eax
  802593:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802596:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80259a:	74 07                	je     8025a3 <alloc_block_FF+0x1a5>
  80259c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259f:	8b 00                	mov    (%eax),%eax
  8025a1:	eb 05                	jmp    8025a8 <alloc_block_FF+0x1aa>
  8025a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8025a8:	a3 40 51 80 00       	mov    %eax,0x805140
  8025ad:	a1 40 51 80 00       	mov    0x805140,%eax
  8025b2:	85 c0                	test   %eax,%eax
  8025b4:	0f 85 57 fe ff ff    	jne    802411 <alloc_block_FF+0x13>
  8025ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025be:	0f 85 4d fe ff ff    	jne    802411 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8025c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025c9:	c9                   	leave  
  8025ca:	c3                   	ret    

008025cb <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8025cb:	55                   	push   %ebp
  8025cc:	89 e5                	mov    %esp,%ebp
  8025ce:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8025d1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8025d8:	a1 38 51 80 00       	mov    0x805138,%eax
  8025dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025e0:	e9 df 00 00 00       	jmp    8026c4 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8025e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e8:	8b 40 0c             	mov    0xc(%eax),%eax
  8025eb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025ee:	0f 82 c8 00 00 00    	jb     8026bc <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8025f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f7:	8b 40 0c             	mov    0xc(%eax),%eax
  8025fa:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025fd:	0f 85 8a 00 00 00    	jne    80268d <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802603:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802607:	75 17                	jne    802620 <alloc_block_BF+0x55>
  802609:	83 ec 04             	sub    $0x4,%esp
  80260c:	68 c4 40 80 00       	push   $0x8040c4
  802611:	68 b7 00 00 00       	push   $0xb7
  802616:	68 1b 40 80 00       	push   $0x80401b
  80261b:	e8 70 dd ff ff       	call   800390 <_panic>
  802620:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802623:	8b 00                	mov    (%eax),%eax
  802625:	85 c0                	test   %eax,%eax
  802627:	74 10                	je     802639 <alloc_block_BF+0x6e>
  802629:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262c:	8b 00                	mov    (%eax),%eax
  80262e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802631:	8b 52 04             	mov    0x4(%edx),%edx
  802634:	89 50 04             	mov    %edx,0x4(%eax)
  802637:	eb 0b                	jmp    802644 <alloc_block_BF+0x79>
  802639:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263c:	8b 40 04             	mov    0x4(%eax),%eax
  80263f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802644:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802647:	8b 40 04             	mov    0x4(%eax),%eax
  80264a:	85 c0                	test   %eax,%eax
  80264c:	74 0f                	je     80265d <alloc_block_BF+0x92>
  80264e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802651:	8b 40 04             	mov    0x4(%eax),%eax
  802654:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802657:	8b 12                	mov    (%edx),%edx
  802659:	89 10                	mov    %edx,(%eax)
  80265b:	eb 0a                	jmp    802667 <alloc_block_BF+0x9c>
  80265d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802660:	8b 00                	mov    (%eax),%eax
  802662:	a3 38 51 80 00       	mov    %eax,0x805138
  802667:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802670:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802673:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80267a:	a1 44 51 80 00       	mov    0x805144,%eax
  80267f:	48                   	dec    %eax
  802680:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802685:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802688:	e9 4d 01 00 00       	jmp    8027da <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  80268d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802690:	8b 40 0c             	mov    0xc(%eax),%eax
  802693:	3b 45 08             	cmp    0x8(%ebp),%eax
  802696:	76 24                	jbe    8026bc <alloc_block_BF+0xf1>
  802698:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269b:	8b 40 0c             	mov    0xc(%eax),%eax
  80269e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8026a1:	73 19                	jae    8026bc <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8026a3:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8026aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ad:	8b 40 0c             	mov    0xc(%eax),%eax
  8026b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8026b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b6:	8b 40 08             	mov    0x8(%eax),%eax
  8026b9:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8026bc:	a1 40 51 80 00       	mov    0x805140,%eax
  8026c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026c8:	74 07                	je     8026d1 <alloc_block_BF+0x106>
  8026ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cd:	8b 00                	mov    (%eax),%eax
  8026cf:	eb 05                	jmp    8026d6 <alloc_block_BF+0x10b>
  8026d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8026d6:	a3 40 51 80 00       	mov    %eax,0x805140
  8026db:	a1 40 51 80 00       	mov    0x805140,%eax
  8026e0:	85 c0                	test   %eax,%eax
  8026e2:	0f 85 fd fe ff ff    	jne    8025e5 <alloc_block_BF+0x1a>
  8026e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026ec:	0f 85 f3 fe ff ff    	jne    8025e5 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8026f2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8026f6:	0f 84 d9 00 00 00    	je     8027d5 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8026fc:	a1 48 51 80 00       	mov    0x805148,%eax
  802701:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802704:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802707:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80270a:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  80270d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802710:	8b 55 08             	mov    0x8(%ebp),%edx
  802713:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802716:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80271a:	75 17                	jne    802733 <alloc_block_BF+0x168>
  80271c:	83 ec 04             	sub    $0x4,%esp
  80271f:	68 c4 40 80 00       	push   $0x8040c4
  802724:	68 c7 00 00 00       	push   $0xc7
  802729:	68 1b 40 80 00       	push   $0x80401b
  80272e:	e8 5d dc ff ff       	call   800390 <_panic>
  802733:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802736:	8b 00                	mov    (%eax),%eax
  802738:	85 c0                	test   %eax,%eax
  80273a:	74 10                	je     80274c <alloc_block_BF+0x181>
  80273c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80273f:	8b 00                	mov    (%eax),%eax
  802741:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802744:	8b 52 04             	mov    0x4(%edx),%edx
  802747:	89 50 04             	mov    %edx,0x4(%eax)
  80274a:	eb 0b                	jmp    802757 <alloc_block_BF+0x18c>
  80274c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80274f:	8b 40 04             	mov    0x4(%eax),%eax
  802752:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802757:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80275a:	8b 40 04             	mov    0x4(%eax),%eax
  80275d:	85 c0                	test   %eax,%eax
  80275f:	74 0f                	je     802770 <alloc_block_BF+0x1a5>
  802761:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802764:	8b 40 04             	mov    0x4(%eax),%eax
  802767:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80276a:	8b 12                	mov    (%edx),%edx
  80276c:	89 10                	mov    %edx,(%eax)
  80276e:	eb 0a                	jmp    80277a <alloc_block_BF+0x1af>
  802770:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802773:	8b 00                	mov    (%eax),%eax
  802775:	a3 48 51 80 00       	mov    %eax,0x805148
  80277a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80277d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802783:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802786:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80278d:	a1 54 51 80 00       	mov    0x805154,%eax
  802792:	48                   	dec    %eax
  802793:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802798:	83 ec 08             	sub    $0x8,%esp
  80279b:	ff 75 ec             	pushl  -0x14(%ebp)
  80279e:	68 38 51 80 00       	push   $0x805138
  8027a3:	e8 71 f9 ff ff       	call   802119 <find_block>
  8027a8:	83 c4 10             	add    $0x10,%esp
  8027ab:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8027ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027b1:	8b 50 08             	mov    0x8(%eax),%edx
  8027b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b7:	01 c2                	add    %eax,%edx
  8027b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027bc:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8027bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027c2:	8b 40 0c             	mov    0xc(%eax),%eax
  8027c5:	2b 45 08             	sub    0x8(%ebp),%eax
  8027c8:	89 c2                	mov    %eax,%edx
  8027ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027cd:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8027d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027d3:	eb 05                	jmp    8027da <alloc_block_BF+0x20f>
	}
	return NULL;
  8027d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027da:	c9                   	leave  
  8027db:	c3                   	ret    

008027dc <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8027dc:	55                   	push   %ebp
  8027dd:	89 e5                	mov    %esp,%ebp
  8027df:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8027e2:	a1 28 50 80 00       	mov    0x805028,%eax
  8027e7:	85 c0                	test   %eax,%eax
  8027e9:	0f 85 de 01 00 00    	jne    8029cd <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8027ef:	a1 38 51 80 00       	mov    0x805138,%eax
  8027f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027f7:	e9 9e 01 00 00       	jmp    80299a <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8027fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ff:	8b 40 0c             	mov    0xc(%eax),%eax
  802802:	3b 45 08             	cmp    0x8(%ebp),%eax
  802805:	0f 82 87 01 00 00    	jb     802992 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  80280b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280e:	8b 40 0c             	mov    0xc(%eax),%eax
  802811:	3b 45 08             	cmp    0x8(%ebp),%eax
  802814:	0f 85 95 00 00 00    	jne    8028af <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  80281a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80281e:	75 17                	jne    802837 <alloc_block_NF+0x5b>
  802820:	83 ec 04             	sub    $0x4,%esp
  802823:	68 c4 40 80 00       	push   $0x8040c4
  802828:	68 e0 00 00 00       	push   $0xe0
  80282d:	68 1b 40 80 00       	push   $0x80401b
  802832:	e8 59 db ff ff       	call   800390 <_panic>
  802837:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283a:	8b 00                	mov    (%eax),%eax
  80283c:	85 c0                	test   %eax,%eax
  80283e:	74 10                	je     802850 <alloc_block_NF+0x74>
  802840:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802843:	8b 00                	mov    (%eax),%eax
  802845:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802848:	8b 52 04             	mov    0x4(%edx),%edx
  80284b:	89 50 04             	mov    %edx,0x4(%eax)
  80284e:	eb 0b                	jmp    80285b <alloc_block_NF+0x7f>
  802850:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802853:	8b 40 04             	mov    0x4(%eax),%eax
  802856:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80285b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285e:	8b 40 04             	mov    0x4(%eax),%eax
  802861:	85 c0                	test   %eax,%eax
  802863:	74 0f                	je     802874 <alloc_block_NF+0x98>
  802865:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802868:	8b 40 04             	mov    0x4(%eax),%eax
  80286b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80286e:	8b 12                	mov    (%edx),%edx
  802870:	89 10                	mov    %edx,(%eax)
  802872:	eb 0a                	jmp    80287e <alloc_block_NF+0xa2>
  802874:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802877:	8b 00                	mov    (%eax),%eax
  802879:	a3 38 51 80 00       	mov    %eax,0x805138
  80287e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802881:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802887:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802891:	a1 44 51 80 00       	mov    0x805144,%eax
  802896:	48                   	dec    %eax
  802897:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  80289c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289f:	8b 40 08             	mov    0x8(%eax),%eax
  8028a2:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  8028a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028aa:	e9 f8 04 00 00       	jmp    802da7 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8028af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b2:	8b 40 0c             	mov    0xc(%eax),%eax
  8028b5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028b8:	0f 86 d4 00 00 00    	jbe    802992 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8028be:	a1 48 51 80 00       	mov    0x805148,%eax
  8028c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8028c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c9:	8b 50 08             	mov    0x8(%eax),%edx
  8028cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028cf:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8028d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028d5:	8b 55 08             	mov    0x8(%ebp),%edx
  8028d8:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8028db:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028df:	75 17                	jne    8028f8 <alloc_block_NF+0x11c>
  8028e1:	83 ec 04             	sub    $0x4,%esp
  8028e4:	68 c4 40 80 00       	push   $0x8040c4
  8028e9:	68 e9 00 00 00       	push   $0xe9
  8028ee:	68 1b 40 80 00       	push   $0x80401b
  8028f3:	e8 98 da ff ff       	call   800390 <_panic>
  8028f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028fb:	8b 00                	mov    (%eax),%eax
  8028fd:	85 c0                	test   %eax,%eax
  8028ff:	74 10                	je     802911 <alloc_block_NF+0x135>
  802901:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802904:	8b 00                	mov    (%eax),%eax
  802906:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802909:	8b 52 04             	mov    0x4(%edx),%edx
  80290c:	89 50 04             	mov    %edx,0x4(%eax)
  80290f:	eb 0b                	jmp    80291c <alloc_block_NF+0x140>
  802911:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802914:	8b 40 04             	mov    0x4(%eax),%eax
  802917:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80291c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80291f:	8b 40 04             	mov    0x4(%eax),%eax
  802922:	85 c0                	test   %eax,%eax
  802924:	74 0f                	je     802935 <alloc_block_NF+0x159>
  802926:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802929:	8b 40 04             	mov    0x4(%eax),%eax
  80292c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80292f:	8b 12                	mov    (%edx),%edx
  802931:	89 10                	mov    %edx,(%eax)
  802933:	eb 0a                	jmp    80293f <alloc_block_NF+0x163>
  802935:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802938:	8b 00                	mov    (%eax),%eax
  80293a:	a3 48 51 80 00       	mov    %eax,0x805148
  80293f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802942:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802948:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80294b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802952:	a1 54 51 80 00       	mov    0x805154,%eax
  802957:	48                   	dec    %eax
  802958:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  80295d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802960:	8b 40 08             	mov    0x8(%eax),%eax
  802963:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802968:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296b:	8b 50 08             	mov    0x8(%eax),%edx
  80296e:	8b 45 08             	mov    0x8(%ebp),%eax
  802971:	01 c2                	add    %eax,%edx
  802973:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802976:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802979:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297c:	8b 40 0c             	mov    0xc(%eax),%eax
  80297f:	2b 45 08             	sub    0x8(%ebp),%eax
  802982:	89 c2                	mov    %eax,%edx
  802984:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802987:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  80298a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80298d:	e9 15 04 00 00       	jmp    802da7 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802992:	a1 40 51 80 00       	mov    0x805140,%eax
  802997:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80299a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80299e:	74 07                	je     8029a7 <alloc_block_NF+0x1cb>
  8029a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a3:	8b 00                	mov    (%eax),%eax
  8029a5:	eb 05                	jmp    8029ac <alloc_block_NF+0x1d0>
  8029a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8029ac:	a3 40 51 80 00       	mov    %eax,0x805140
  8029b1:	a1 40 51 80 00       	mov    0x805140,%eax
  8029b6:	85 c0                	test   %eax,%eax
  8029b8:	0f 85 3e fe ff ff    	jne    8027fc <alloc_block_NF+0x20>
  8029be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029c2:	0f 85 34 fe ff ff    	jne    8027fc <alloc_block_NF+0x20>
  8029c8:	e9 d5 03 00 00       	jmp    802da2 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8029cd:	a1 38 51 80 00       	mov    0x805138,%eax
  8029d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029d5:	e9 b1 01 00 00       	jmp    802b8b <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8029da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029dd:	8b 50 08             	mov    0x8(%eax),%edx
  8029e0:	a1 28 50 80 00       	mov    0x805028,%eax
  8029e5:	39 c2                	cmp    %eax,%edx
  8029e7:	0f 82 96 01 00 00    	jb     802b83 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  8029ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f0:	8b 40 0c             	mov    0xc(%eax),%eax
  8029f3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029f6:	0f 82 87 01 00 00    	jb     802b83 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  8029fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ff:	8b 40 0c             	mov    0xc(%eax),%eax
  802a02:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a05:	0f 85 95 00 00 00    	jne    802aa0 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802a0b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a0f:	75 17                	jne    802a28 <alloc_block_NF+0x24c>
  802a11:	83 ec 04             	sub    $0x4,%esp
  802a14:	68 c4 40 80 00       	push   $0x8040c4
  802a19:	68 fc 00 00 00       	push   $0xfc
  802a1e:	68 1b 40 80 00       	push   $0x80401b
  802a23:	e8 68 d9 ff ff       	call   800390 <_panic>
  802a28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2b:	8b 00                	mov    (%eax),%eax
  802a2d:	85 c0                	test   %eax,%eax
  802a2f:	74 10                	je     802a41 <alloc_block_NF+0x265>
  802a31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a34:	8b 00                	mov    (%eax),%eax
  802a36:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a39:	8b 52 04             	mov    0x4(%edx),%edx
  802a3c:	89 50 04             	mov    %edx,0x4(%eax)
  802a3f:	eb 0b                	jmp    802a4c <alloc_block_NF+0x270>
  802a41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a44:	8b 40 04             	mov    0x4(%eax),%eax
  802a47:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4f:	8b 40 04             	mov    0x4(%eax),%eax
  802a52:	85 c0                	test   %eax,%eax
  802a54:	74 0f                	je     802a65 <alloc_block_NF+0x289>
  802a56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a59:	8b 40 04             	mov    0x4(%eax),%eax
  802a5c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a5f:	8b 12                	mov    (%edx),%edx
  802a61:	89 10                	mov    %edx,(%eax)
  802a63:	eb 0a                	jmp    802a6f <alloc_block_NF+0x293>
  802a65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a68:	8b 00                	mov    (%eax),%eax
  802a6a:	a3 38 51 80 00       	mov    %eax,0x805138
  802a6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a72:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a82:	a1 44 51 80 00       	mov    0x805144,%eax
  802a87:	48                   	dec    %eax
  802a88:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802a8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a90:	8b 40 08             	mov    0x8(%eax),%eax
  802a93:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802a98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9b:	e9 07 03 00 00       	jmp    802da7 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802aa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa3:	8b 40 0c             	mov    0xc(%eax),%eax
  802aa6:	3b 45 08             	cmp    0x8(%ebp),%eax
  802aa9:	0f 86 d4 00 00 00    	jbe    802b83 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802aaf:	a1 48 51 80 00       	mov    0x805148,%eax
  802ab4:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802ab7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aba:	8b 50 08             	mov    0x8(%eax),%edx
  802abd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ac0:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802ac3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ac6:	8b 55 08             	mov    0x8(%ebp),%edx
  802ac9:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802acc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ad0:	75 17                	jne    802ae9 <alloc_block_NF+0x30d>
  802ad2:	83 ec 04             	sub    $0x4,%esp
  802ad5:	68 c4 40 80 00       	push   $0x8040c4
  802ada:	68 04 01 00 00       	push   $0x104
  802adf:	68 1b 40 80 00       	push   $0x80401b
  802ae4:	e8 a7 d8 ff ff       	call   800390 <_panic>
  802ae9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aec:	8b 00                	mov    (%eax),%eax
  802aee:	85 c0                	test   %eax,%eax
  802af0:	74 10                	je     802b02 <alloc_block_NF+0x326>
  802af2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802af5:	8b 00                	mov    (%eax),%eax
  802af7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802afa:	8b 52 04             	mov    0x4(%edx),%edx
  802afd:	89 50 04             	mov    %edx,0x4(%eax)
  802b00:	eb 0b                	jmp    802b0d <alloc_block_NF+0x331>
  802b02:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b05:	8b 40 04             	mov    0x4(%eax),%eax
  802b08:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b0d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b10:	8b 40 04             	mov    0x4(%eax),%eax
  802b13:	85 c0                	test   %eax,%eax
  802b15:	74 0f                	je     802b26 <alloc_block_NF+0x34a>
  802b17:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b1a:	8b 40 04             	mov    0x4(%eax),%eax
  802b1d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b20:	8b 12                	mov    (%edx),%edx
  802b22:	89 10                	mov    %edx,(%eax)
  802b24:	eb 0a                	jmp    802b30 <alloc_block_NF+0x354>
  802b26:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b29:	8b 00                	mov    (%eax),%eax
  802b2b:	a3 48 51 80 00       	mov    %eax,0x805148
  802b30:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b33:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b39:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b3c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b43:	a1 54 51 80 00       	mov    0x805154,%eax
  802b48:	48                   	dec    %eax
  802b49:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802b4e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b51:	8b 40 08             	mov    0x8(%eax),%eax
  802b54:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802b59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5c:	8b 50 08             	mov    0x8(%eax),%edx
  802b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b62:	01 c2                	add    %eax,%edx
  802b64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b67:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802b6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6d:	8b 40 0c             	mov    0xc(%eax),%eax
  802b70:	2b 45 08             	sub    0x8(%ebp),%eax
  802b73:	89 c2                	mov    %eax,%edx
  802b75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b78:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802b7b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b7e:	e9 24 02 00 00       	jmp    802da7 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b83:	a1 40 51 80 00       	mov    0x805140,%eax
  802b88:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b8b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b8f:	74 07                	je     802b98 <alloc_block_NF+0x3bc>
  802b91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b94:	8b 00                	mov    (%eax),%eax
  802b96:	eb 05                	jmp    802b9d <alloc_block_NF+0x3c1>
  802b98:	b8 00 00 00 00       	mov    $0x0,%eax
  802b9d:	a3 40 51 80 00       	mov    %eax,0x805140
  802ba2:	a1 40 51 80 00       	mov    0x805140,%eax
  802ba7:	85 c0                	test   %eax,%eax
  802ba9:	0f 85 2b fe ff ff    	jne    8029da <alloc_block_NF+0x1fe>
  802baf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bb3:	0f 85 21 fe ff ff    	jne    8029da <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802bb9:	a1 38 51 80 00       	mov    0x805138,%eax
  802bbe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bc1:	e9 ae 01 00 00       	jmp    802d74 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802bc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc9:	8b 50 08             	mov    0x8(%eax),%edx
  802bcc:	a1 28 50 80 00       	mov    0x805028,%eax
  802bd1:	39 c2                	cmp    %eax,%edx
  802bd3:	0f 83 93 01 00 00    	jae    802d6c <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802bd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bdc:	8b 40 0c             	mov    0xc(%eax),%eax
  802bdf:	3b 45 08             	cmp    0x8(%ebp),%eax
  802be2:	0f 82 84 01 00 00    	jb     802d6c <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802be8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802beb:	8b 40 0c             	mov    0xc(%eax),%eax
  802bee:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bf1:	0f 85 95 00 00 00    	jne    802c8c <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802bf7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bfb:	75 17                	jne    802c14 <alloc_block_NF+0x438>
  802bfd:	83 ec 04             	sub    $0x4,%esp
  802c00:	68 c4 40 80 00       	push   $0x8040c4
  802c05:	68 14 01 00 00       	push   $0x114
  802c0a:	68 1b 40 80 00       	push   $0x80401b
  802c0f:	e8 7c d7 ff ff       	call   800390 <_panic>
  802c14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c17:	8b 00                	mov    (%eax),%eax
  802c19:	85 c0                	test   %eax,%eax
  802c1b:	74 10                	je     802c2d <alloc_block_NF+0x451>
  802c1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c20:	8b 00                	mov    (%eax),%eax
  802c22:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c25:	8b 52 04             	mov    0x4(%edx),%edx
  802c28:	89 50 04             	mov    %edx,0x4(%eax)
  802c2b:	eb 0b                	jmp    802c38 <alloc_block_NF+0x45c>
  802c2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c30:	8b 40 04             	mov    0x4(%eax),%eax
  802c33:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3b:	8b 40 04             	mov    0x4(%eax),%eax
  802c3e:	85 c0                	test   %eax,%eax
  802c40:	74 0f                	je     802c51 <alloc_block_NF+0x475>
  802c42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c45:	8b 40 04             	mov    0x4(%eax),%eax
  802c48:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c4b:	8b 12                	mov    (%edx),%edx
  802c4d:	89 10                	mov    %edx,(%eax)
  802c4f:	eb 0a                	jmp    802c5b <alloc_block_NF+0x47f>
  802c51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c54:	8b 00                	mov    (%eax),%eax
  802c56:	a3 38 51 80 00       	mov    %eax,0x805138
  802c5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c67:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c6e:	a1 44 51 80 00       	mov    0x805144,%eax
  802c73:	48                   	dec    %eax
  802c74:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802c79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7c:	8b 40 08             	mov    0x8(%eax),%eax
  802c7f:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802c84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c87:	e9 1b 01 00 00       	jmp    802da7 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802c8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8f:	8b 40 0c             	mov    0xc(%eax),%eax
  802c92:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c95:	0f 86 d1 00 00 00    	jbe    802d6c <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802c9b:	a1 48 51 80 00       	mov    0x805148,%eax
  802ca0:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802ca3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca6:	8b 50 08             	mov    0x8(%eax),%edx
  802ca9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cac:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802caf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cb2:	8b 55 08             	mov    0x8(%ebp),%edx
  802cb5:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802cb8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802cbc:	75 17                	jne    802cd5 <alloc_block_NF+0x4f9>
  802cbe:	83 ec 04             	sub    $0x4,%esp
  802cc1:	68 c4 40 80 00       	push   $0x8040c4
  802cc6:	68 1c 01 00 00       	push   $0x11c
  802ccb:	68 1b 40 80 00       	push   $0x80401b
  802cd0:	e8 bb d6 ff ff       	call   800390 <_panic>
  802cd5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cd8:	8b 00                	mov    (%eax),%eax
  802cda:	85 c0                	test   %eax,%eax
  802cdc:	74 10                	je     802cee <alloc_block_NF+0x512>
  802cde:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ce1:	8b 00                	mov    (%eax),%eax
  802ce3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ce6:	8b 52 04             	mov    0x4(%edx),%edx
  802ce9:	89 50 04             	mov    %edx,0x4(%eax)
  802cec:	eb 0b                	jmp    802cf9 <alloc_block_NF+0x51d>
  802cee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cf1:	8b 40 04             	mov    0x4(%eax),%eax
  802cf4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802cf9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cfc:	8b 40 04             	mov    0x4(%eax),%eax
  802cff:	85 c0                	test   %eax,%eax
  802d01:	74 0f                	je     802d12 <alloc_block_NF+0x536>
  802d03:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d06:	8b 40 04             	mov    0x4(%eax),%eax
  802d09:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d0c:	8b 12                	mov    (%edx),%edx
  802d0e:	89 10                	mov    %edx,(%eax)
  802d10:	eb 0a                	jmp    802d1c <alloc_block_NF+0x540>
  802d12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d15:	8b 00                	mov    (%eax),%eax
  802d17:	a3 48 51 80 00       	mov    %eax,0x805148
  802d1c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d1f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d25:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d28:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d2f:	a1 54 51 80 00       	mov    0x805154,%eax
  802d34:	48                   	dec    %eax
  802d35:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802d3a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d3d:	8b 40 08             	mov    0x8(%eax),%eax
  802d40:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802d45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d48:	8b 50 08             	mov    0x8(%eax),%edx
  802d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4e:	01 c2                	add    %eax,%edx
  802d50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d53:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802d56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d59:	8b 40 0c             	mov    0xc(%eax),%eax
  802d5c:	2b 45 08             	sub    0x8(%ebp),%eax
  802d5f:	89 c2                	mov    %eax,%edx
  802d61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d64:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802d67:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d6a:	eb 3b                	jmp    802da7 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802d6c:	a1 40 51 80 00       	mov    0x805140,%eax
  802d71:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d74:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d78:	74 07                	je     802d81 <alloc_block_NF+0x5a5>
  802d7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7d:	8b 00                	mov    (%eax),%eax
  802d7f:	eb 05                	jmp    802d86 <alloc_block_NF+0x5aa>
  802d81:	b8 00 00 00 00       	mov    $0x0,%eax
  802d86:	a3 40 51 80 00       	mov    %eax,0x805140
  802d8b:	a1 40 51 80 00       	mov    0x805140,%eax
  802d90:	85 c0                	test   %eax,%eax
  802d92:	0f 85 2e fe ff ff    	jne    802bc6 <alloc_block_NF+0x3ea>
  802d98:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d9c:	0f 85 24 fe ff ff    	jne    802bc6 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802da2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802da7:	c9                   	leave  
  802da8:	c3                   	ret    

00802da9 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802da9:	55                   	push   %ebp
  802daa:	89 e5                	mov    %esp,%ebp
  802dac:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802daf:	a1 38 51 80 00       	mov    0x805138,%eax
  802db4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802db7:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802dbc:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802dbf:	a1 38 51 80 00       	mov    0x805138,%eax
  802dc4:	85 c0                	test   %eax,%eax
  802dc6:	74 14                	je     802ddc <insert_sorted_with_merge_freeList+0x33>
  802dc8:	8b 45 08             	mov    0x8(%ebp),%eax
  802dcb:	8b 50 08             	mov    0x8(%eax),%edx
  802dce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dd1:	8b 40 08             	mov    0x8(%eax),%eax
  802dd4:	39 c2                	cmp    %eax,%edx
  802dd6:	0f 87 9b 01 00 00    	ja     802f77 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802ddc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802de0:	75 17                	jne    802df9 <insert_sorted_with_merge_freeList+0x50>
  802de2:	83 ec 04             	sub    $0x4,%esp
  802de5:	68 f8 3f 80 00       	push   $0x803ff8
  802dea:	68 38 01 00 00       	push   $0x138
  802def:	68 1b 40 80 00       	push   $0x80401b
  802df4:	e8 97 d5 ff ff       	call   800390 <_panic>
  802df9:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802dff:	8b 45 08             	mov    0x8(%ebp),%eax
  802e02:	89 10                	mov    %edx,(%eax)
  802e04:	8b 45 08             	mov    0x8(%ebp),%eax
  802e07:	8b 00                	mov    (%eax),%eax
  802e09:	85 c0                	test   %eax,%eax
  802e0b:	74 0d                	je     802e1a <insert_sorted_with_merge_freeList+0x71>
  802e0d:	a1 38 51 80 00       	mov    0x805138,%eax
  802e12:	8b 55 08             	mov    0x8(%ebp),%edx
  802e15:	89 50 04             	mov    %edx,0x4(%eax)
  802e18:	eb 08                	jmp    802e22 <insert_sorted_with_merge_freeList+0x79>
  802e1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e22:	8b 45 08             	mov    0x8(%ebp),%eax
  802e25:	a3 38 51 80 00       	mov    %eax,0x805138
  802e2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e34:	a1 44 51 80 00       	mov    0x805144,%eax
  802e39:	40                   	inc    %eax
  802e3a:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802e3f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e43:	0f 84 a8 06 00 00    	je     8034f1 <insert_sorted_with_merge_freeList+0x748>
  802e49:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4c:	8b 50 08             	mov    0x8(%eax),%edx
  802e4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e52:	8b 40 0c             	mov    0xc(%eax),%eax
  802e55:	01 c2                	add    %eax,%edx
  802e57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e5a:	8b 40 08             	mov    0x8(%eax),%eax
  802e5d:	39 c2                	cmp    %eax,%edx
  802e5f:	0f 85 8c 06 00 00    	jne    8034f1 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802e65:	8b 45 08             	mov    0x8(%ebp),%eax
  802e68:	8b 50 0c             	mov    0xc(%eax),%edx
  802e6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e6e:	8b 40 0c             	mov    0xc(%eax),%eax
  802e71:	01 c2                	add    %eax,%edx
  802e73:	8b 45 08             	mov    0x8(%ebp),%eax
  802e76:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802e79:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e7d:	75 17                	jne    802e96 <insert_sorted_with_merge_freeList+0xed>
  802e7f:	83 ec 04             	sub    $0x4,%esp
  802e82:	68 c4 40 80 00       	push   $0x8040c4
  802e87:	68 3c 01 00 00       	push   $0x13c
  802e8c:	68 1b 40 80 00       	push   $0x80401b
  802e91:	e8 fa d4 ff ff       	call   800390 <_panic>
  802e96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e99:	8b 00                	mov    (%eax),%eax
  802e9b:	85 c0                	test   %eax,%eax
  802e9d:	74 10                	je     802eaf <insert_sorted_with_merge_freeList+0x106>
  802e9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ea2:	8b 00                	mov    (%eax),%eax
  802ea4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ea7:	8b 52 04             	mov    0x4(%edx),%edx
  802eaa:	89 50 04             	mov    %edx,0x4(%eax)
  802ead:	eb 0b                	jmp    802eba <insert_sorted_with_merge_freeList+0x111>
  802eaf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eb2:	8b 40 04             	mov    0x4(%eax),%eax
  802eb5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802eba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ebd:	8b 40 04             	mov    0x4(%eax),%eax
  802ec0:	85 c0                	test   %eax,%eax
  802ec2:	74 0f                	je     802ed3 <insert_sorted_with_merge_freeList+0x12a>
  802ec4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ec7:	8b 40 04             	mov    0x4(%eax),%eax
  802eca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ecd:	8b 12                	mov    (%edx),%edx
  802ecf:	89 10                	mov    %edx,(%eax)
  802ed1:	eb 0a                	jmp    802edd <insert_sorted_with_merge_freeList+0x134>
  802ed3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ed6:	8b 00                	mov    (%eax),%eax
  802ed8:	a3 38 51 80 00       	mov    %eax,0x805138
  802edd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ee0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ee6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ee9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ef0:	a1 44 51 80 00       	mov    0x805144,%eax
  802ef5:	48                   	dec    %eax
  802ef6:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802efb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802efe:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802f05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f08:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802f0f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f13:	75 17                	jne    802f2c <insert_sorted_with_merge_freeList+0x183>
  802f15:	83 ec 04             	sub    $0x4,%esp
  802f18:	68 f8 3f 80 00       	push   $0x803ff8
  802f1d:	68 3f 01 00 00       	push   $0x13f
  802f22:	68 1b 40 80 00       	push   $0x80401b
  802f27:	e8 64 d4 ff ff       	call   800390 <_panic>
  802f2c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f35:	89 10                	mov    %edx,(%eax)
  802f37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f3a:	8b 00                	mov    (%eax),%eax
  802f3c:	85 c0                	test   %eax,%eax
  802f3e:	74 0d                	je     802f4d <insert_sorted_with_merge_freeList+0x1a4>
  802f40:	a1 48 51 80 00       	mov    0x805148,%eax
  802f45:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f48:	89 50 04             	mov    %edx,0x4(%eax)
  802f4b:	eb 08                	jmp    802f55 <insert_sorted_with_merge_freeList+0x1ac>
  802f4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f50:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f58:	a3 48 51 80 00       	mov    %eax,0x805148
  802f5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f60:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f67:	a1 54 51 80 00       	mov    0x805154,%eax
  802f6c:	40                   	inc    %eax
  802f6d:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802f72:	e9 7a 05 00 00       	jmp    8034f1 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802f77:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7a:	8b 50 08             	mov    0x8(%eax),%edx
  802f7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f80:	8b 40 08             	mov    0x8(%eax),%eax
  802f83:	39 c2                	cmp    %eax,%edx
  802f85:	0f 82 14 01 00 00    	jb     80309f <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802f8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f8e:	8b 50 08             	mov    0x8(%eax),%edx
  802f91:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f94:	8b 40 0c             	mov    0xc(%eax),%eax
  802f97:	01 c2                	add    %eax,%edx
  802f99:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9c:	8b 40 08             	mov    0x8(%eax),%eax
  802f9f:	39 c2                	cmp    %eax,%edx
  802fa1:	0f 85 90 00 00 00    	jne    803037 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802fa7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802faa:	8b 50 0c             	mov    0xc(%eax),%edx
  802fad:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb0:	8b 40 0c             	mov    0xc(%eax),%eax
  802fb3:	01 c2                	add    %eax,%edx
  802fb5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fb8:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802fbb:	8b 45 08             	mov    0x8(%ebp),%eax
  802fbe:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802fcf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fd3:	75 17                	jne    802fec <insert_sorted_with_merge_freeList+0x243>
  802fd5:	83 ec 04             	sub    $0x4,%esp
  802fd8:	68 f8 3f 80 00       	push   $0x803ff8
  802fdd:	68 49 01 00 00       	push   $0x149
  802fe2:	68 1b 40 80 00       	push   $0x80401b
  802fe7:	e8 a4 d3 ff ff       	call   800390 <_panic>
  802fec:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802ff2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff5:	89 10                	mov    %edx,(%eax)
  802ff7:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffa:	8b 00                	mov    (%eax),%eax
  802ffc:	85 c0                	test   %eax,%eax
  802ffe:	74 0d                	je     80300d <insert_sorted_with_merge_freeList+0x264>
  803000:	a1 48 51 80 00       	mov    0x805148,%eax
  803005:	8b 55 08             	mov    0x8(%ebp),%edx
  803008:	89 50 04             	mov    %edx,0x4(%eax)
  80300b:	eb 08                	jmp    803015 <insert_sorted_with_merge_freeList+0x26c>
  80300d:	8b 45 08             	mov    0x8(%ebp),%eax
  803010:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803015:	8b 45 08             	mov    0x8(%ebp),%eax
  803018:	a3 48 51 80 00       	mov    %eax,0x805148
  80301d:	8b 45 08             	mov    0x8(%ebp),%eax
  803020:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803027:	a1 54 51 80 00       	mov    0x805154,%eax
  80302c:	40                   	inc    %eax
  80302d:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803032:	e9 bb 04 00 00       	jmp    8034f2 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803037:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80303b:	75 17                	jne    803054 <insert_sorted_with_merge_freeList+0x2ab>
  80303d:	83 ec 04             	sub    $0x4,%esp
  803040:	68 6c 40 80 00       	push   $0x80406c
  803045:	68 4c 01 00 00       	push   $0x14c
  80304a:	68 1b 40 80 00       	push   $0x80401b
  80304f:	e8 3c d3 ff ff       	call   800390 <_panic>
  803054:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80305a:	8b 45 08             	mov    0x8(%ebp),%eax
  80305d:	89 50 04             	mov    %edx,0x4(%eax)
  803060:	8b 45 08             	mov    0x8(%ebp),%eax
  803063:	8b 40 04             	mov    0x4(%eax),%eax
  803066:	85 c0                	test   %eax,%eax
  803068:	74 0c                	je     803076 <insert_sorted_with_merge_freeList+0x2cd>
  80306a:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80306f:	8b 55 08             	mov    0x8(%ebp),%edx
  803072:	89 10                	mov    %edx,(%eax)
  803074:	eb 08                	jmp    80307e <insert_sorted_with_merge_freeList+0x2d5>
  803076:	8b 45 08             	mov    0x8(%ebp),%eax
  803079:	a3 38 51 80 00       	mov    %eax,0x805138
  80307e:	8b 45 08             	mov    0x8(%ebp),%eax
  803081:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803086:	8b 45 08             	mov    0x8(%ebp),%eax
  803089:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80308f:	a1 44 51 80 00       	mov    0x805144,%eax
  803094:	40                   	inc    %eax
  803095:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80309a:	e9 53 04 00 00       	jmp    8034f2 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80309f:	a1 38 51 80 00       	mov    0x805138,%eax
  8030a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030a7:	e9 15 04 00 00       	jmp    8034c1 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  8030ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030af:	8b 00                	mov    (%eax),%eax
  8030b1:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  8030b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b7:	8b 50 08             	mov    0x8(%eax),%edx
  8030ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030bd:	8b 40 08             	mov    0x8(%eax),%eax
  8030c0:	39 c2                	cmp    %eax,%edx
  8030c2:	0f 86 f1 03 00 00    	jbe    8034b9 <insert_sorted_with_merge_freeList+0x710>
  8030c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030cb:	8b 50 08             	mov    0x8(%eax),%edx
  8030ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030d1:	8b 40 08             	mov    0x8(%eax),%eax
  8030d4:	39 c2                	cmp    %eax,%edx
  8030d6:	0f 83 dd 03 00 00    	jae    8034b9 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8030dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030df:	8b 50 08             	mov    0x8(%eax),%edx
  8030e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e5:	8b 40 0c             	mov    0xc(%eax),%eax
  8030e8:	01 c2                	add    %eax,%edx
  8030ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ed:	8b 40 08             	mov    0x8(%eax),%eax
  8030f0:	39 c2                	cmp    %eax,%edx
  8030f2:	0f 85 b9 01 00 00    	jne    8032b1 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8030f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fb:	8b 50 08             	mov    0x8(%eax),%edx
  8030fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803101:	8b 40 0c             	mov    0xc(%eax),%eax
  803104:	01 c2                	add    %eax,%edx
  803106:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803109:	8b 40 08             	mov    0x8(%eax),%eax
  80310c:	39 c2                	cmp    %eax,%edx
  80310e:	0f 85 0d 01 00 00    	jne    803221 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803114:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803117:	8b 50 0c             	mov    0xc(%eax),%edx
  80311a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80311d:	8b 40 0c             	mov    0xc(%eax),%eax
  803120:	01 c2                	add    %eax,%edx
  803122:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803125:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803128:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80312c:	75 17                	jne    803145 <insert_sorted_with_merge_freeList+0x39c>
  80312e:	83 ec 04             	sub    $0x4,%esp
  803131:	68 c4 40 80 00       	push   $0x8040c4
  803136:	68 5c 01 00 00       	push   $0x15c
  80313b:	68 1b 40 80 00       	push   $0x80401b
  803140:	e8 4b d2 ff ff       	call   800390 <_panic>
  803145:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803148:	8b 00                	mov    (%eax),%eax
  80314a:	85 c0                	test   %eax,%eax
  80314c:	74 10                	je     80315e <insert_sorted_with_merge_freeList+0x3b5>
  80314e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803151:	8b 00                	mov    (%eax),%eax
  803153:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803156:	8b 52 04             	mov    0x4(%edx),%edx
  803159:	89 50 04             	mov    %edx,0x4(%eax)
  80315c:	eb 0b                	jmp    803169 <insert_sorted_with_merge_freeList+0x3c0>
  80315e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803161:	8b 40 04             	mov    0x4(%eax),%eax
  803164:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803169:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80316c:	8b 40 04             	mov    0x4(%eax),%eax
  80316f:	85 c0                	test   %eax,%eax
  803171:	74 0f                	je     803182 <insert_sorted_with_merge_freeList+0x3d9>
  803173:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803176:	8b 40 04             	mov    0x4(%eax),%eax
  803179:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80317c:	8b 12                	mov    (%edx),%edx
  80317e:	89 10                	mov    %edx,(%eax)
  803180:	eb 0a                	jmp    80318c <insert_sorted_with_merge_freeList+0x3e3>
  803182:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803185:	8b 00                	mov    (%eax),%eax
  803187:	a3 38 51 80 00       	mov    %eax,0x805138
  80318c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80318f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803195:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803198:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80319f:	a1 44 51 80 00       	mov    0x805144,%eax
  8031a4:	48                   	dec    %eax
  8031a5:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8031aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ad:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8031b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031b7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8031be:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031c2:	75 17                	jne    8031db <insert_sorted_with_merge_freeList+0x432>
  8031c4:	83 ec 04             	sub    $0x4,%esp
  8031c7:	68 f8 3f 80 00       	push   $0x803ff8
  8031cc:	68 5f 01 00 00       	push   $0x15f
  8031d1:	68 1b 40 80 00       	push   $0x80401b
  8031d6:	e8 b5 d1 ff ff       	call   800390 <_panic>
  8031db:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e4:	89 10                	mov    %edx,(%eax)
  8031e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e9:	8b 00                	mov    (%eax),%eax
  8031eb:	85 c0                	test   %eax,%eax
  8031ed:	74 0d                	je     8031fc <insert_sorted_with_merge_freeList+0x453>
  8031ef:	a1 48 51 80 00       	mov    0x805148,%eax
  8031f4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031f7:	89 50 04             	mov    %edx,0x4(%eax)
  8031fa:	eb 08                	jmp    803204 <insert_sorted_with_merge_freeList+0x45b>
  8031fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ff:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803204:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803207:	a3 48 51 80 00       	mov    %eax,0x805148
  80320c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80320f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803216:	a1 54 51 80 00       	mov    0x805154,%eax
  80321b:	40                   	inc    %eax
  80321c:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803221:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803224:	8b 50 0c             	mov    0xc(%eax),%edx
  803227:	8b 45 08             	mov    0x8(%ebp),%eax
  80322a:	8b 40 0c             	mov    0xc(%eax),%eax
  80322d:	01 c2                	add    %eax,%edx
  80322f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803232:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803235:	8b 45 08             	mov    0x8(%ebp),%eax
  803238:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  80323f:	8b 45 08             	mov    0x8(%ebp),%eax
  803242:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803249:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80324d:	75 17                	jne    803266 <insert_sorted_with_merge_freeList+0x4bd>
  80324f:	83 ec 04             	sub    $0x4,%esp
  803252:	68 f8 3f 80 00       	push   $0x803ff8
  803257:	68 64 01 00 00       	push   $0x164
  80325c:	68 1b 40 80 00       	push   $0x80401b
  803261:	e8 2a d1 ff ff       	call   800390 <_panic>
  803266:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80326c:	8b 45 08             	mov    0x8(%ebp),%eax
  80326f:	89 10                	mov    %edx,(%eax)
  803271:	8b 45 08             	mov    0x8(%ebp),%eax
  803274:	8b 00                	mov    (%eax),%eax
  803276:	85 c0                	test   %eax,%eax
  803278:	74 0d                	je     803287 <insert_sorted_with_merge_freeList+0x4de>
  80327a:	a1 48 51 80 00       	mov    0x805148,%eax
  80327f:	8b 55 08             	mov    0x8(%ebp),%edx
  803282:	89 50 04             	mov    %edx,0x4(%eax)
  803285:	eb 08                	jmp    80328f <insert_sorted_with_merge_freeList+0x4e6>
  803287:	8b 45 08             	mov    0x8(%ebp),%eax
  80328a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80328f:	8b 45 08             	mov    0x8(%ebp),%eax
  803292:	a3 48 51 80 00       	mov    %eax,0x805148
  803297:	8b 45 08             	mov    0x8(%ebp),%eax
  80329a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032a1:	a1 54 51 80 00       	mov    0x805154,%eax
  8032a6:	40                   	inc    %eax
  8032a7:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8032ac:	e9 41 02 00 00       	jmp    8034f2 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8032b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b4:	8b 50 08             	mov    0x8(%eax),%edx
  8032b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8032bd:	01 c2                	add    %eax,%edx
  8032bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032c2:	8b 40 08             	mov    0x8(%eax),%eax
  8032c5:	39 c2                	cmp    %eax,%edx
  8032c7:	0f 85 7c 01 00 00    	jne    803449 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8032cd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032d1:	74 06                	je     8032d9 <insert_sorted_with_merge_freeList+0x530>
  8032d3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032d7:	75 17                	jne    8032f0 <insert_sorted_with_merge_freeList+0x547>
  8032d9:	83 ec 04             	sub    $0x4,%esp
  8032dc:	68 34 40 80 00       	push   $0x804034
  8032e1:	68 69 01 00 00       	push   $0x169
  8032e6:	68 1b 40 80 00       	push   $0x80401b
  8032eb:	e8 a0 d0 ff ff       	call   800390 <_panic>
  8032f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032f3:	8b 50 04             	mov    0x4(%eax),%edx
  8032f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f9:	89 50 04             	mov    %edx,0x4(%eax)
  8032fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ff:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803302:	89 10                	mov    %edx,(%eax)
  803304:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803307:	8b 40 04             	mov    0x4(%eax),%eax
  80330a:	85 c0                	test   %eax,%eax
  80330c:	74 0d                	je     80331b <insert_sorted_with_merge_freeList+0x572>
  80330e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803311:	8b 40 04             	mov    0x4(%eax),%eax
  803314:	8b 55 08             	mov    0x8(%ebp),%edx
  803317:	89 10                	mov    %edx,(%eax)
  803319:	eb 08                	jmp    803323 <insert_sorted_with_merge_freeList+0x57a>
  80331b:	8b 45 08             	mov    0x8(%ebp),%eax
  80331e:	a3 38 51 80 00       	mov    %eax,0x805138
  803323:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803326:	8b 55 08             	mov    0x8(%ebp),%edx
  803329:	89 50 04             	mov    %edx,0x4(%eax)
  80332c:	a1 44 51 80 00       	mov    0x805144,%eax
  803331:	40                   	inc    %eax
  803332:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803337:	8b 45 08             	mov    0x8(%ebp),%eax
  80333a:	8b 50 0c             	mov    0xc(%eax),%edx
  80333d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803340:	8b 40 0c             	mov    0xc(%eax),%eax
  803343:	01 c2                	add    %eax,%edx
  803345:	8b 45 08             	mov    0x8(%ebp),%eax
  803348:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80334b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80334f:	75 17                	jne    803368 <insert_sorted_with_merge_freeList+0x5bf>
  803351:	83 ec 04             	sub    $0x4,%esp
  803354:	68 c4 40 80 00       	push   $0x8040c4
  803359:	68 6b 01 00 00       	push   $0x16b
  80335e:	68 1b 40 80 00       	push   $0x80401b
  803363:	e8 28 d0 ff ff       	call   800390 <_panic>
  803368:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80336b:	8b 00                	mov    (%eax),%eax
  80336d:	85 c0                	test   %eax,%eax
  80336f:	74 10                	je     803381 <insert_sorted_with_merge_freeList+0x5d8>
  803371:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803374:	8b 00                	mov    (%eax),%eax
  803376:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803379:	8b 52 04             	mov    0x4(%edx),%edx
  80337c:	89 50 04             	mov    %edx,0x4(%eax)
  80337f:	eb 0b                	jmp    80338c <insert_sorted_with_merge_freeList+0x5e3>
  803381:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803384:	8b 40 04             	mov    0x4(%eax),%eax
  803387:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80338c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80338f:	8b 40 04             	mov    0x4(%eax),%eax
  803392:	85 c0                	test   %eax,%eax
  803394:	74 0f                	je     8033a5 <insert_sorted_with_merge_freeList+0x5fc>
  803396:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803399:	8b 40 04             	mov    0x4(%eax),%eax
  80339c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80339f:	8b 12                	mov    (%edx),%edx
  8033a1:	89 10                	mov    %edx,(%eax)
  8033a3:	eb 0a                	jmp    8033af <insert_sorted_with_merge_freeList+0x606>
  8033a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033a8:	8b 00                	mov    (%eax),%eax
  8033aa:	a3 38 51 80 00       	mov    %eax,0x805138
  8033af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033bb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033c2:	a1 44 51 80 00       	mov    0x805144,%eax
  8033c7:	48                   	dec    %eax
  8033c8:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8033cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033d0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8033d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033da:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8033e1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8033e5:	75 17                	jne    8033fe <insert_sorted_with_merge_freeList+0x655>
  8033e7:	83 ec 04             	sub    $0x4,%esp
  8033ea:	68 f8 3f 80 00       	push   $0x803ff8
  8033ef:	68 6e 01 00 00       	push   $0x16e
  8033f4:	68 1b 40 80 00       	push   $0x80401b
  8033f9:	e8 92 cf ff ff       	call   800390 <_panic>
  8033fe:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803404:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803407:	89 10                	mov    %edx,(%eax)
  803409:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80340c:	8b 00                	mov    (%eax),%eax
  80340e:	85 c0                	test   %eax,%eax
  803410:	74 0d                	je     80341f <insert_sorted_with_merge_freeList+0x676>
  803412:	a1 48 51 80 00       	mov    0x805148,%eax
  803417:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80341a:	89 50 04             	mov    %edx,0x4(%eax)
  80341d:	eb 08                	jmp    803427 <insert_sorted_with_merge_freeList+0x67e>
  80341f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803422:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803427:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80342a:	a3 48 51 80 00       	mov    %eax,0x805148
  80342f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803432:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803439:	a1 54 51 80 00       	mov    0x805154,%eax
  80343e:	40                   	inc    %eax
  80343f:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803444:	e9 a9 00 00 00       	jmp    8034f2 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803449:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80344d:	74 06                	je     803455 <insert_sorted_with_merge_freeList+0x6ac>
  80344f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803453:	75 17                	jne    80346c <insert_sorted_with_merge_freeList+0x6c3>
  803455:	83 ec 04             	sub    $0x4,%esp
  803458:	68 90 40 80 00       	push   $0x804090
  80345d:	68 73 01 00 00       	push   $0x173
  803462:	68 1b 40 80 00       	push   $0x80401b
  803467:	e8 24 cf ff ff       	call   800390 <_panic>
  80346c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80346f:	8b 10                	mov    (%eax),%edx
  803471:	8b 45 08             	mov    0x8(%ebp),%eax
  803474:	89 10                	mov    %edx,(%eax)
  803476:	8b 45 08             	mov    0x8(%ebp),%eax
  803479:	8b 00                	mov    (%eax),%eax
  80347b:	85 c0                	test   %eax,%eax
  80347d:	74 0b                	je     80348a <insert_sorted_with_merge_freeList+0x6e1>
  80347f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803482:	8b 00                	mov    (%eax),%eax
  803484:	8b 55 08             	mov    0x8(%ebp),%edx
  803487:	89 50 04             	mov    %edx,0x4(%eax)
  80348a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80348d:	8b 55 08             	mov    0x8(%ebp),%edx
  803490:	89 10                	mov    %edx,(%eax)
  803492:	8b 45 08             	mov    0x8(%ebp),%eax
  803495:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803498:	89 50 04             	mov    %edx,0x4(%eax)
  80349b:	8b 45 08             	mov    0x8(%ebp),%eax
  80349e:	8b 00                	mov    (%eax),%eax
  8034a0:	85 c0                	test   %eax,%eax
  8034a2:	75 08                	jne    8034ac <insert_sorted_with_merge_freeList+0x703>
  8034a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8034ac:	a1 44 51 80 00       	mov    0x805144,%eax
  8034b1:	40                   	inc    %eax
  8034b2:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  8034b7:	eb 39                	jmp    8034f2 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8034b9:	a1 40 51 80 00       	mov    0x805140,%eax
  8034be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034c5:	74 07                	je     8034ce <insert_sorted_with_merge_freeList+0x725>
  8034c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ca:	8b 00                	mov    (%eax),%eax
  8034cc:	eb 05                	jmp    8034d3 <insert_sorted_with_merge_freeList+0x72a>
  8034ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8034d3:	a3 40 51 80 00       	mov    %eax,0x805140
  8034d8:	a1 40 51 80 00       	mov    0x805140,%eax
  8034dd:	85 c0                	test   %eax,%eax
  8034df:	0f 85 c7 fb ff ff    	jne    8030ac <insert_sorted_with_merge_freeList+0x303>
  8034e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034e9:	0f 85 bd fb ff ff    	jne    8030ac <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8034ef:	eb 01                	jmp    8034f2 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8034f1:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8034f2:	90                   	nop
  8034f3:	c9                   	leave  
  8034f4:	c3                   	ret    
  8034f5:	66 90                	xchg   %ax,%ax
  8034f7:	90                   	nop

008034f8 <__udivdi3>:
  8034f8:	55                   	push   %ebp
  8034f9:	57                   	push   %edi
  8034fa:	56                   	push   %esi
  8034fb:	53                   	push   %ebx
  8034fc:	83 ec 1c             	sub    $0x1c,%esp
  8034ff:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803503:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803507:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80350b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80350f:	89 ca                	mov    %ecx,%edx
  803511:	89 f8                	mov    %edi,%eax
  803513:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803517:	85 f6                	test   %esi,%esi
  803519:	75 2d                	jne    803548 <__udivdi3+0x50>
  80351b:	39 cf                	cmp    %ecx,%edi
  80351d:	77 65                	ja     803584 <__udivdi3+0x8c>
  80351f:	89 fd                	mov    %edi,%ebp
  803521:	85 ff                	test   %edi,%edi
  803523:	75 0b                	jne    803530 <__udivdi3+0x38>
  803525:	b8 01 00 00 00       	mov    $0x1,%eax
  80352a:	31 d2                	xor    %edx,%edx
  80352c:	f7 f7                	div    %edi
  80352e:	89 c5                	mov    %eax,%ebp
  803530:	31 d2                	xor    %edx,%edx
  803532:	89 c8                	mov    %ecx,%eax
  803534:	f7 f5                	div    %ebp
  803536:	89 c1                	mov    %eax,%ecx
  803538:	89 d8                	mov    %ebx,%eax
  80353a:	f7 f5                	div    %ebp
  80353c:	89 cf                	mov    %ecx,%edi
  80353e:	89 fa                	mov    %edi,%edx
  803540:	83 c4 1c             	add    $0x1c,%esp
  803543:	5b                   	pop    %ebx
  803544:	5e                   	pop    %esi
  803545:	5f                   	pop    %edi
  803546:	5d                   	pop    %ebp
  803547:	c3                   	ret    
  803548:	39 ce                	cmp    %ecx,%esi
  80354a:	77 28                	ja     803574 <__udivdi3+0x7c>
  80354c:	0f bd fe             	bsr    %esi,%edi
  80354f:	83 f7 1f             	xor    $0x1f,%edi
  803552:	75 40                	jne    803594 <__udivdi3+0x9c>
  803554:	39 ce                	cmp    %ecx,%esi
  803556:	72 0a                	jb     803562 <__udivdi3+0x6a>
  803558:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80355c:	0f 87 9e 00 00 00    	ja     803600 <__udivdi3+0x108>
  803562:	b8 01 00 00 00       	mov    $0x1,%eax
  803567:	89 fa                	mov    %edi,%edx
  803569:	83 c4 1c             	add    $0x1c,%esp
  80356c:	5b                   	pop    %ebx
  80356d:	5e                   	pop    %esi
  80356e:	5f                   	pop    %edi
  80356f:	5d                   	pop    %ebp
  803570:	c3                   	ret    
  803571:	8d 76 00             	lea    0x0(%esi),%esi
  803574:	31 ff                	xor    %edi,%edi
  803576:	31 c0                	xor    %eax,%eax
  803578:	89 fa                	mov    %edi,%edx
  80357a:	83 c4 1c             	add    $0x1c,%esp
  80357d:	5b                   	pop    %ebx
  80357e:	5e                   	pop    %esi
  80357f:	5f                   	pop    %edi
  803580:	5d                   	pop    %ebp
  803581:	c3                   	ret    
  803582:	66 90                	xchg   %ax,%ax
  803584:	89 d8                	mov    %ebx,%eax
  803586:	f7 f7                	div    %edi
  803588:	31 ff                	xor    %edi,%edi
  80358a:	89 fa                	mov    %edi,%edx
  80358c:	83 c4 1c             	add    $0x1c,%esp
  80358f:	5b                   	pop    %ebx
  803590:	5e                   	pop    %esi
  803591:	5f                   	pop    %edi
  803592:	5d                   	pop    %ebp
  803593:	c3                   	ret    
  803594:	bd 20 00 00 00       	mov    $0x20,%ebp
  803599:	89 eb                	mov    %ebp,%ebx
  80359b:	29 fb                	sub    %edi,%ebx
  80359d:	89 f9                	mov    %edi,%ecx
  80359f:	d3 e6                	shl    %cl,%esi
  8035a1:	89 c5                	mov    %eax,%ebp
  8035a3:	88 d9                	mov    %bl,%cl
  8035a5:	d3 ed                	shr    %cl,%ebp
  8035a7:	89 e9                	mov    %ebp,%ecx
  8035a9:	09 f1                	or     %esi,%ecx
  8035ab:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8035af:	89 f9                	mov    %edi,%ecx
  8035b1:	d3 e0                	shl    %cl,%eax
  8035b3:	89 c5                	mov    %eax,%ebp
  8035b5:	89 d6                	mov    %edx,%esi
  8035b7:	88 d9                	mov    %bl,%cl
  8035b9:	d3 ee                	shr    %cl,%esi
  8035bb:	89 f9                	mov    %edi,%ecx
  8035bd:	d3 e2                	shl    %cl,%edx
  8035bf:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035c3:	88 d9                	mov    %bl,%cl
  8035c5:	d3 e8                	shr    %cl,%eax
  8035c7:	09 c2                	or     %eax,%edx
  8035c9:	89 d0                	mov    %edx,%eax
  8035cb:	89 f2                	mov    %esi,%edx
  8035cd:	f7 74 24 0c          	divl   0xc(%esp)
  8035d1:	89 d6                	mov    %edx,%esi
  8035d3:	89 c3                	mov    %eax,%ebx
  8035d5:	f7 e5                	mul    %ebp
  8035d7:	39 d6                	cmp    %edx,%esi
  8035d9:	72 19                	jb     8035f4 <__udivdi3+0xfc>
  8035db:	74 0b                	je     8035e8 <__udivdi3+0xf0>
  8035dd:	89 d8                	mov    %ebx,%eax
  8035df:	31 ff                	xor    %edi,%edi
  8035e1:	e9 58 ff ff ff       	jmp    80353e <__udivdi3+0x46>
  8035e6:	66 90                	xchg   %ax,%ax
  8035e8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8035ec:	89 f9                	mov    %edi,%ecx
  8035ee:	d3 e2                	shl    %cl,%edx
  8035f0:	39 c2                	cmp    %eax,%edx
  8035f2:	73 e9                	jae    8035dd <__udivdi3+0xe5>
  8035f4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8035f7:	31 ff                	xor    %edi,%edi
  8035f9:	e9 40 ff ff ff       	jmp    80353e <__udivdi3+0x46>
  8035fe:	66 90                	xchg   %ax,%ax
  803600:	31 c0                	xor    %eax,%eax
  803602:	e9 37 ff ff ff       	jmp    80353e <__udivdi3+0x46>
  803607:	90                   	nop

00803608 <__umoddi3>:
  803608:	55                   	push   %ebp
  803609:	57                   	push   %edi
  80360a:	56                   	push   %esi
  80360b:	53                   	push   %ebx
  80360c:	83 ec 1c             	sub    $0x1c,%esp
  80360f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803613:	8b 74 24 34          	mov    0x34(%esp),%esi
  803617:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80361b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80361f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803623:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803627:	89 f3                	mov    %esi,%ebx
  803629:	89 fa                	mov    %edi,%edx
  80362b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80362f:	89 34 24             	mov    %esi,(%esp)
  803632:	85 c0                	test   %eax,%eax
  803634:	75 1a                	jne    803650 <__umoddi3+0x48>
  803636:	39 f7                	cmp    %esi,%edi
  803638:	0f 86 a2 00 00 00    	jbe    8036e0 <__umoddi3+0xd8>
  80363e:	89 c8                	mov    %ecx,%eax
  803640:	89 f2                	mov    %esi,%edx
  803642:	f7 f7                	div    %edi
  803644:	89 d0                	mov    %edx,%eax
  803646:	31 d2                	xor    %edx,%edx
  803648:	83 c4 1c             	add    $0x1c,%esp
  80364b:	5b                   	pop    %ebx
  80364c:	5e                   	pop    %esi
  80364d:	5f                   	pop    %edi
  80364e:	5d                   	pop    %ebp
  80364f:	c3                   	ret    
  803650:	39 f0                	cmp    %esi,%eax
  803652:	0f 87 ac 00 00 00    	ja     803704 <__umoddi3+0xfc>
  803658:	0f bd e8             	bsr    %eax,%ebp
  80365b:	83 f5 1f             	xor    $0x1f,%ebp
  80365e:	0f 84 ac 00 00 00    	je     803710 <__umoddi3+0x108>
  803664:	bf 20 00 00 00       	mov    $0x20,%edi
  803669:	29 ef                	sub    %ebp,%edi
  80366b:	89 fe                	mov    %edi,%esi
  80366d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803671:	89 e9                	mov    %ebp,%ecx
  803673:	d3 e0                	shl    %cl,%eax
  803675:	89 d7                	mov    %edx,%edi
  803677:	89 f1                	mov    %esi,%ecx
  803679:	d3 ef                	shr    %cl,%edi
  80367b:	09 c7                	or     %eax,%edi
  80367d:	89 e9                	mov    %ebp,%ecx
  80367f:	d3 e2                	shl    %cl,%edx
  803681:	89 14 24             	mov    %edx,(%esp)
  803684:	89 d8                	mov    %ebx,%eax
  803686:	d3 e0                	shl    %cl,%eax
  803688:	89 c2                	mov    %eax,%edx
  80368a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80368e:	d3 e0                	shl    %cl,%eax
  803690:	89 44 24 04          	mov    %eax,0x4(%esp)
  803694:	8b 44 24 08          	mov    0x8(%esp),%eax
  803698:	89 f1                	mov    %esi,%ecx
  80369a:	d3 e8                	shr    %cl,%eax
  80369c:	09 d0                	or     %edx,%eax
  80369e:	d3 eb                	shr    %cl,%ebx
  8036a0:	89 da                	mov    %ebx,%edx
  8036a2:	f7 f7                	div    %edi
  8036a4:	89 d3                	mov    %edx,%ebx
  8036a6:	f7 24 24             	mull   (%esp)
  8036a9:	89 c6                	mov    %eax,%esi
  8036ab:	89 d1                	mov    %edx,%ecx
  8036ad:	39 d3                	cmp    %edx,%ebx
  8036af:	0f 82 87 00 00 00    	jb     80373c <__umoddi3+0x134>
  8036b5:	0f 84 91 00 00 00    	je     80374c <__umoddi3+0x144>
  8036bb:	8b 54 24 04          	mov    0x4(%esp),%edx
  8036bf:	29 f2                	sub    %esi,%edx
  8036c1:	19 cb                	sbb    %ecx,%ebx
  8036c3:	89 d8                	mov    %ebx,%eax
  8036c5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8036c9:	d3 e0                	shl    %cl,%eax
  8036cb:	89 e9                	mov    %ebp,%ecx
  8036cd:	d3 ea                	shr    %cl,%edx
  8036cf:	09 d0                	or     %edx,%eax
  8036d1:	89 e9                	mov    %ebp,%ecx
  8036d3:	d3 eb                	shr    %cl,%ebx
  8036d5:	89 da                	mov    %ebx,%edx
  8036d7:	83 c4 1c             	add    $0x1c,%esp
  8036da:	5b                   	pop    %ebx
  8036db:	5e                   	pop    %esi
  8036dc:	5f                   	pop    %edi
  8036dd:	5d                   	pop    %ebp
  8036de:	c3                   	ret    
  8036df:	90                   	nop
  8036e0:	89 fd                	mov    %edi,%ebp
  8036e2:	85 ff                	test   %edi,%edi
  8036e4:	75 0b                	jne    8036f1 <__umoddi3+0xe9>
  8036e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8036eb:	31 d2                	xor    %edx,%edx
  8036ed:	f7 f7                	div    %edi
  8036ef:	89 c5                	mov    %eax,%ebp
  8036f1:	89 f0                	mov    %esi,%eax
  8036f3:	31 d2                	xor    %edx,%edx
  8036f5:	f7 f5                	div    %ebp
  8036f7:	89 c8                	mov    %ecx,%eax
  8036f9:	f7 f5                	div    %ebp
  8036fb:	89 d0                	mov    %edx,%eax
  8036fd:	e9 44 ff ff ff       	jmp    803646 <__umoddi3+0x3e>
  803702:	66 90                	xchg   %ax,%ax
  803704:	89 c8                	mov    %ecx,%eax
  803706:	89 f2                	mov    %esi,%edx
  803708:	83 c4 1c             	add    $0x1c,%esp
  80370b:	5b                   	pop    %ebx
  80370c:	5e                   	pop    %esi
  80370d:	5f                   	pop    %edi
  80370e:	5d                   	pop    %ebp
  80370f:	c3                   	ret    
  803710:	3b 04 24             	cmp    (%esp),%eax
  803713:	72 06                	jb     80371b <__umoddi3+0x113>
  803715:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803719:	77 0f                	ja     80372a <__umoddi3+0x122>
  80371b:	89 f2                	mov    %esi,%edx
  80371d:	29 f9                	sub    %edi,%ecx
  80371f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803723:	89 14 24             	mov    %edx,(%esp)
  803726:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80372a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80372e:	8b 14 24             	mov    (%esp),%edx
  803731:	83 c4 1c             	add    $0x1c,%esp
  803734:	5b                   	pop    %ebx
  803735:	5e                   	pop    %esi
  803736:	5f                   	pop    %edi
  803737:	5d                   	pop    %ebp
  803738:	c3                   	ret    
  803739:	8d 76 00             	lea    0x0(%esi),%esi
  80373c:	2b 04 24             	sub    (%esp),%eax
  80373f:	19 fa                	sbb    %edi,%edx
  803741:	89 d1                	mov    %edx,%ecx
  803743:	89 c6                	mov    %eax,%esi
  803745:	e9 71 ff ff ff       	jmp    8036bb <__umoddi3+0xb3>
  80374a:	66 90                	xchg   %ax,%ax
  80374c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803750:	72 ea                	jb     80373c <__umoddi3+0x134>
  803752:	89 d9                	mov    %ebx,%ecx
  803754:	e9 62 ff ff ff       	jmp    8036bb <__umoddi3+0xb3>
